# expandable_list_test — click-crash isolation experiments

Minimal drill-down list (QML) plus three drivers that click its rows
with synthesized real-pipeline mouse events (Qt's own
`qt_handleMouseEvent` test entry point, resolved with `dlsym`):

* `cpp_control.cpp` — pure C++, no D/dqt anywhere in the process.
* `d_variant/` — the D twin: same QML, same injection, dqt glue.
* (the `Makefile` builds both; `make run-cpp` / `make run-d` run them
  under `MALLOC_CHECK_=3 MALLOC_PERTURB_=165`).

The point is to attribute crashes: if the C++ control aborts too, the
bug is in Qt; if only the D twin aborts, the bug is in the D bindings.

## Bug 1 (fixed): D GC collects QObjects that only C++ references

Reproduce (before the fix): `FSU_AUTOTEST=1 FSU_DROP_ROOT=1 …` drops
the D reference to the driver object. The D GC then frees it while Qt
(parent + timer connection) still holds the raw pointer and keeps
invoking the slot — aborting with `double free or corruption (out)`.

Fix (in the dqt repo, `core/qt/core/object.d`): `QObject.connect`
now keeps signal receivers and delegate contexts alive in a GC-scanned
registry (`dqtKeepAlive`), and `QQmlContext.setContextProperty`
(`qml/qt/qml/context.d`) does the same for objects exposed to QML.
With the fix, the dropped-reference run survives.

A second, related dqt fix from the same investigation
(`core/qt/helpers.d`): the convenience-wrapper mixin generated a
variadic template constructor for `__ctor` whose body called the real
constructor and discarded the temporary instead of initializing `this`.
For classes that meant `new`/`cpp_new` failed loudly ("no match for
implicit super() call" — e.g. `QKeyEvent` was unconstructible from D);
for structs it was worse, compiling silently with default-initialized
values (e.g. `QFont("Arial", 12)` lost its arguments). Class
constructors are now excluded from wrapper generation (undelegatable),
struct constructors assign the converted temporary to `this` — verified
with a probe (`family: [Arial]`, `pointSize: 12`).

## Bug 2 (fixed): D binary interposed Qt's `QEvent::clone()`

With bug 1 fixed, the D twin still aborted — now inside Qt itself,
`QQuickFlickable::filterPointerEvent` deleting a non-heap pointer in
the delayed-press/event-clone path. Established facts (gdb + objdump,
see git history for the full trail):

* The C++ control survives the identical QML + event stream (9/9 runs);
  the D twin crashed deterministically, even with a cpp-identical
  stream (`FSU_CPPISH=1`) and the D reference kept — and even with
  static QML, no timers, no D slots and no model changes.
* Header clicks (outside the Flickable) survived; idle runs survived.
  The injected call itself was verified argument-by-argument against
  the C++ version.
* At the crash, Qt's `clonePointerEvent` returned its stack-allocated
  input unchanged instead of a heap clone. Reading the clone vtable
  slot (`[vptr+24]`) showed: C++ → Qt's `QMouseEvent::clone`, D → an
  address in the **main executable**.

Root cause (in the dqt repo, `core/qt/core/coreevent.d`): the
`Q_DECL_EVENT_COMMON` mixin defined `QEvent::clone()` with a D body
(`cpp_new_copy`), so LDC emitted 37 C++-mangled `Q<X>Event::cloneEv`
definitions with global visibility into every D binary. The dynamic
linker resolved Qt's own vtable clone slots to those definitions
(symbol interposition). Qt then "cloned" its events with D code sized
by `__traits(classInstanceSize)` of the memberless binding (16 bytes
for a real 80-byte `QMouseEvent`) — heap corruption, detected as
`double free or corruption` / SEGV in `free()` during press delivery.

Fix: the mixin now declares `clone()` without a body, binding Qt's
real implementation. Verified: the rebuilt binary exports zero
`cloneEv` symbols, the vtable slot resolves to libQt6Gui, and every
driver mode survives under `MALLOC_CHECK_=3 MALLOC_PERTURB_=165`
(`FSU_CPPISH=1`, drop-root/kept-root, `FSU_V2`/`FSU_V3`,
`FSU_AT_FIXED`). Lesson: bindings must never define C++ virtuals with
D bodies unless the object layout is exactly right — a bodyless
declaration is interposition-proof.

## Running

```
make cpp            # build the C++ control
make run-cpp        # C++ control under MALLOC_CHECK_
make d-build        # build the D twin (via dub, path dependency on dqt)
make run-d          # D twin, kept D reference
```

D twin environment switches:

* `FSU_AUTOTEST=1` — drive clicks on a timer.
* `FSU_DROP_ROOT=1` — drop the D reference (bug-1 repro; survives now).
* `FSU_CPPISH=1` — cpp-identical event stream (row-map positions,
  QTest timestamps, no hover moves).
* `FSU_AT_FIXED=y1,y2,…` — click fixed positions at x=100.
* `FSU_V2=1` / `FSU_V3=1` — cache the window once / drive the injection
  from a plain D thread instead of a QTimer slot.
