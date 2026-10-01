// QT_MODULES: core
module corelib.tools.tst_margins_x;

import qt.core.margins;
import qt.core.global;

/*
 * Supplemental coverage for the `QMargins`/`QMarginsF` bindings in
 * `qt/core/core/margins.d`, covering members the mirrored `tst_margins.d`
 * (upstream `tst_qmargins.cpp`) does not exercise.
 *
 * These cases are D-only: there is no upstream `*_data` fixture to mirror, so
 * expectations are derived from the Qt semantics the binding implements.
 *
 * Exclusions (not bound): `QDebug` and `QDataStream` streaming operators for
 * `QMargins`/`QMarginsF`.
 *
 * BINDING GAP (rvalue parameters): `QMarginsF(const QMargins)` takes
 * `ref const(QMargins)`, which D cannot bind to an rvalue; the source is stored
 * in a local below.
 */

// constructor from QMargins
unittest
{
    QMargins m = QMargins(1, 2, 3, 4);
    QMarginsF f = QMarginsF(m);
    assert(f.left() == 1.0 && f.top() == 2.0 && f.right() == 3.0 && f.bottom() == 4.0);
    assert(f == QMarginsF(1, 2, 3, 4));
}

// toMargins
unittest
{
    QMargins roundTrip = QMarginsF(1, 2, 3, 4).toMargins();
    assert(roundTrip == QMargins(1, 2, 3, 4));

    // fractional components round with qRound
    QMargins rounded = QMarginsF(1.4, 2.6, -3.6, 4.5).toMargins();
    assert(rounded == QMargins(1, 3, -4, 5));
}
