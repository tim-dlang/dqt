/*
 * DQt - D bindings for the Qt Toolkit
 *
 * GNU Lesser General Public License Usage
 * This file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPL3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
 */
module qt.core.eventloop;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.object;
import qt.core.thread;
import qt.helpers;

extern(C++, class) struct QEventLoopPrivate;

/// Binding for C++ class [QEventLoop](https://doc.qt.io/qt-6/qeventloop.html).
class /+ Q_CORE_EXPORT +/ QEventLoop : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QEventLoop) +/

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    enum ProcessEventsFlag {
        AllEvents = 0x00,
        ExcludeUserInputEvents = 0x01,
        ExcludeSocketNotifiers = 0x02,
        WaitForMoreEvents = 0x04,
        X11ExcludeTimers = 0x08,
        EventLoopExec = 0x20,
        DialogExec = 0x40,
        ApplicationExec = 0x80,
    }
    /+ Q_DECLARE_FLAGS(ProcessEventsFlags, ProcessEventsFlag) +/
alias ProcessEventsFlags = QFlags!(ProcessEventsFlag);    /+ Q_FLAG(ProcessEventsFlags) +/

    final bool processEvents(ProcessEventsFlags flags = ProcessEventsFlag.AllEvents);
    final void processEvents(ProcessEventsFlags flags, int maximumTime);

    final int exec(ProcessEventsFlags flags = ProcessEventsFlag.AllEvents);
    final bool isRunning() const;

    final void wakeUp();

    override bool event(QEvent event);

public /+ Q_SLOTS +/:
    @QSlot final void exit(int returnCode = 0);
    @QSlot final void quit();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QEventLoop.ProcessEventsFlags.enum_type) operator |(QEventLoop.ProcessEventsFlags.enum_type f1, QEventLoop.ProcessEventsFlags.enum_type f2)/+noexcept+/{return QFlags!(QEventLoop.ProcessEventsFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QEventLoop.ProcessEventsFlags.enum_type) operator |(QEventLoop.ProcessEventsFlags.enum_type f1, QFlags!(QEventLoop.ProcessEventsFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QEventLoop.ProcessEventsFlags.enum_type) operator &(QEventLoop.ProcessEventsFlags.enum_type f1, QEventLoop.ProcessEventsFlags.enum_type f2)/+noexcept+/{return QFlags!(QEventLoop.ProcessEventsFlags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QEventLoop.ProcessEventsFlags.enum_type) operator &(QEventLoop.ProcessEventsFlags.enum_type f1, QFlags!(QEventLoop.ProcessEventsFlags.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QEventLoop.ProcessEventsFlags.enum_type) operator ^(QEventLoop.ProcessEventsFlags.enum_type f1, QEventLoop.ProcessEventsFlags.enum_type f2)/+noexcept+/{return QFlags!(QEventLoop.ProcessEventsFlags.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QEventLoop.ProcessEventsFlags.enum_type) operator ^(QEventLoop.ProcessEventsFlags.enum_type f1, QFlags!(QEventLoop.ProcessEventsFlags.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QEventLoop.ProcessEventsFlags.enum_type f1, QEventLoop.ProcessEventsFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QEventLoop.ProcessEventsFlags.enum_type f1, QFlags!(QEventLoop.ProcessEventsFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QEventLoop.ProcessEventsFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QEventLoop.ProcessEventsFlags.enum_type f1, QEventLoop.ProcessEventsFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QEventLoop.ProcessEventsFlags.enum_type f1, QFlags!(QEventLoop.ProcessEventsFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QEventLoop.ProcessEventsFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QEventLoop.ProcessEventsFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QEventLoop.ProcessEventsFlags.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QEventLoop.ProcessEventsFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QEventLoop.ProcessEventsFlags.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QEventLoop.ProcessEventsFlags operator ~(QEventLoop.ProcessEventsFlags.enum_type e)/+noexcept+/{return~QEventLoop.ProcessEventsFlags(e);}+/
/+pragma(inline, true) void operator |(QEventLoop.ProcessEventsFlags.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QEventLoop.ProcessEventsFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QEventLoop::ProcessEventsFlags) +/
extern(C++, class) struct QEventLoopLockerPrivate;

/// Binding for C++ class [QEventLoopLocker](https://doc.qt.io/qt-6/qeventlooplocker.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QEventLoopLocker
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ explicit +/this(QEventLoop loop);
    /+ explicit +/this(QThread thread);
    ~this();

private:
    /+ Q_DISABLE_COPY(QEventLoopLocker) +/
@disable this(this);
/+@disable this(ref const(QEventLoopLocker));+/@disable ref QEventLoopLocker opAssign(ref const(QEventLoopLocker));    QEventLoopLockerPrivate* d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

