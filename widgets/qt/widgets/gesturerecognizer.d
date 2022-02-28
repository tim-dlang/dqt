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
module qt.widgets.gesturerecognizer;
extern(C++):

import qt.config;
import qt.helpers;
version(QT_NO_GESTURES){}else
{
    import qt.core.coreevent;
    import qt.core.flags;
    import qt.core.namespace;
    import qt.core.object;
    import qt.widgets.gesture;
}

version(QT_NO_GESTURES){}else
{



/// Binding for C++ class [QGestureRecognizer](https://doc.qt.io/qt-6/qgesturerecognizer.html).
abstract class /+ Q_WIDGETS_EXPORT +/ QGestureRecognizer
{
public:
    enum ResultFlag
    {
        Ignore           = 0x0001,

        MayBeGesture     = 0x0002,
        TriggerGesture   = 0x0004,
        FinishGesture    = 0x0008,
        CancelGesture    = 0x0010,

        ResultState_Mask = 0x00ff,

        ConsumeEventHint        = 0x0100,
        // StoreEventHint          = 0x0200,
        // ReplayStoredEventsHint  = 0x0400,
        // DiscardStoredEventsHint = 0x0800,

        ResultHint_Mask = 0xff00
    }
    /+ Q_DECLARE_FLAGS(Result, ResultFlag) +/
alias Result = QFlags!(ResultFlag);
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this();
    }));
    /+ virtual +/~this();

    /+ virtual +/ QGesture create(QObject target);
    /+ virtual +/ abstract Result recognize(QGesture state, QObject watched,
                                 QEvent event);
    /+ virtual +/ void reset(QGesture state);

    static /+ Qt:: +/qt.core.namespace.GestureType registerRecognizer(QGestureRecognizer recognizer);
    static void unregisterRecognizer(/+ Qt:: +/qt.core.namespace.GestureType type);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QGestureRecognizer.Result.enum_type) operator |(QGestureRecognizer.Result.enum_type f1, QGestureRecognizer.Result.enum_type f2)/+noexcept+/{return QFlags!(QGestureRecognizer.Result.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QGestureRecognizer.Result.enum_type) operator |(QGestureRecognizer.Result.enum_type f1, QFlags!(QGestureRecognizer.Result.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QGestureRecognizer.Result.enum_type) operator &(QGestureRecognizer.Result.enum_type f1, QGestureRecognizer.Result.enum_type f2)/+noexcept+/{return QFlags!(QGestureRecognizer.Result.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QGestureRecognizer.Result.enum_type) operator &(QGestureRecognizer.Result.enum_type f1, QFlags!(QGestureRecognizer.Result.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) void operator +(QGestureRecognizer.Result.enum_type f1, QGestureRecognizer.Result.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QGestureRecognizer.Result.enum_type f1, QFlags!(QGestureRecognizer.Result.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QGestureRecognizer.Result.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QGestureRecognizer.Result.enum_type f1, QGestureRecognizer.Result.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QGestureRecognizer.Result.enum_type f1, QFlags!(QGestureRecognizer.Result.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QGestureRecognizer.Result.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) QIncompatibleFlag operator |(QGestureRecognizer.Result.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+pragma(inline, true) void operator +(int f1, QGestureRecognizer.Result.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QGestureRecognizer.Result.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QGestureRecognizer.Result.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QGestureRecognizer.Result.enum_type f1, int f2)/+noexcept+/;+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QGestureRecognizer::Result) +/

}

