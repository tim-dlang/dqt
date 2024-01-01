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
module qt.gui.event;
extern(C++):

import core.stdc.config;
import qt.config;
import qt.core.coreevent;
import qt.core.file;
import qt.core.flags;
import qt.core.global;
import qt.core.iodevice;
import qt.core.list;
import qt.core.metamacros;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.url;
import qt.core.vector;
import qt.gui.region;
import qt.gui.screen;
import qt.gui.touchdevice;
import qt.gui.vector2d;
import qt.gui.windowdefs;
import qt.helpers;
version (QT_NO_INPUTMETHOD) {} else
    import qt.core.variant;
version (QT_NO_SHORTCUT) {} else
    import qt.gui.keysequence;

/+ #ifndef QT_NO_GESTURES
class QGesture;
#endif +/

/// Binding for C++ class [QInputEvent](https://doc.qt.io/qt-5/qinputevent.html).
class /+ Q_GUI_EXPORT +/ QInputEvent : QEvent
{
public:
    /+ explicit +/this(Type type, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier);
    ~this();
    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers() const { return modState; }
    pragma(inline, true) final void setModifiers(/+ Qt:: +/qt.core.namespace.KeyboardModifiers amodifiers) { modState = amodifiers; }
    pragma(inline, true) final cpp_ulong timestamp() const { return ts; }
    pragma(inline, true) final void setTimestamp(cpp_ulong atimestamp) { ts = atimestamp; }
protected:
    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modState;
    cpp_ulong ts;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QEnterEvent](https://doc.qt.io/qt-5/qenterevent.html).
class /+ Q_GUI_EXPORT +/ QEnterEvent : QEvent
{
public:
    this(ref const(QPointF) localPos, ref const(QPointF) windowPos, ref const(QPointF) screenPos);
    ~this();

    version (QT_NO_INTEGER_EVENT_COORDINATES) {} else
    {
        pragma(inline, true) final QPoint pos() const { return l.toPoint(); }
        pragma(inline, true) final QPoint globalPos() const { return s.toPoint(); }
        pragma(inline, true) final int x() const { return qRound(l.x()); }
        pragma(inline, true) final int y() const { return qRound(l.y()); }
        pragma(inline, true) final int globalX() const { return qRound(s.x()); }
        pragma(inline, true) final int globalY() const { return qRound(s.y()); }
    }
    final ref const(QPointF) localPos() const { return l; }
    final ref const(QPointF) windowPos() const { return w; }
    final ref const(QPointF) screenPos() const { return s; }

protected:
    QPointF l; QPointF w; QPointF s;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QMouseEvent](https://doc.qt.io/qt-5/qmouseevent.html).
class /+ Q_GUI_EXPORT +/ QMouseEvent : QInputEvent
{
public:
    this(Type type, ref const(QPointF) localPos, /+ Qt:: +/qt.core.namespace.MouseButton button,
                    /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers);
    this(Type type, ref const(QPointF) localPos, ref const(QPointF) screenPos,
                    /+ Qt:: +/qt.core.namespace.MouseButton button, /+ Qt:: +/qt.core.namespace.MouseButtons buttons,
                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers);
    this(Type type, ref const(QPointF) localPos, ref const(QPointF) windowPos, ref const(QPointF) screenPos,
                    /+ Qt:: +/qt.core.namespace.MouseButton button, /+ Qt:: +/qt.core.namespace.MouseButtons buttons,
                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers);
    this(Type type, ref const(QPointF) localPos, ref const(QPointF) windowPos, ref const(QPointF) screenPos,
                    /+ Qt:: +/qt.core.namespace.MouseButton button, /+ Qt:: +/qt.core.namespace.MouseButtons buttons,
                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, /+ Qt:: +/qt.core.namespace.MouseEventSource source);
    ~this();

    version (QT_NO_INTEGER_EVENT_COORDINATES) {} else
    {
        pragma(inline, true) final QPoint pos() const { return l.toPoint(); }
        pragma(inline, true) final QPoint globalPos() const { return s.toPoint(); }
        pragma(inline, true) final int x() const { return qRound(l.x()); }
        pragma(inline, true) final int y() const { return qRound(l.y()); }
        pragma(inline, true) final int globalX() const { return qRound(s.x()); }
        pragma(inline, true) final int globalY() const { return qRound(s.y()); }
    }
    final ref const(QPointF) localPos() const { return l; }
    final ref const(QPointF) windowPos() const { return w; }
    final ref const(QPointF) screenPos() const { return s; }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.MouseButton button() const { return b; }
    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.MouseButtons buttons() const { return mouseState; }

    pragma(inline, true) final void setLocalPos(ref const(QPointF) localPosition) { l = localPosition; }

/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED inline QPointF posF() const { return l; }
#endif +/

    final /+ Qt:: +/qt.core.namespace.MouseEventSource source() const;
    final /+ Qt:: +/qt.core.namespace.MouseEventFlags flags() const;

protected:
    QPointF l; QPointF w; QPointF s;
    /+ Qt:: +/qt.core.namespace.MouseButton b;
    /+ Qt:: +/qt.core.namespace.MouseButtons mouseState;
    int caps;
    QVector2D velocity;

    /+ friend class QGuiApplicationPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QHoverEvent](https://doc.qt.io/qt-5/qhoverevent.html).
class /+ Q_GUI_EXPORT +/ QHoverEvent : QInputEvent
{
public:
    this(Type type, ref const(QPointF) pos, ref const(QPointF) oldPos, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier);
    ~this();

    version (QT_NO_INTEGER_EVENT_COORDINATES) {} else
    {
        pragma(inline, true) final QPoint pos() const { return p.toPoint(); }
        pragma(inline, true) final QPoint oldPos() const { return op.toPoint(); }
    }

    pragma(inline, true) final ref const(QPointF) posF() const { return p; }
    pragma(inline, true) final ref const(QPointF) oldPosF() const { return op; }

protected:
    QPointF p; QPointF op;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #if QT_CONFIG(wheelevent) +/
/// Binding for C++ class [QWheelEvent](https://doc.qt.io/qt-5/qwheelevent.html).
class /+ Q_GUI_EXPORT +/ QWheelEvent : QInputEvent
{
public:
    enum { DefaultDeltasPerStep = 120 }

/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    // Actually deprecated since 5.0, in docs
    /+ QT_DEPRECATED_VERSION_X_5_15("Use the last QWheelEvent constructor taking pixelDelta, angleDelta, phase, and inverted") +/this(ref const(QPointF) pos, int delta,
                    /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers,
                    /+ Qt:: +/qt.core.namespace.Orientation orient = /+ Qt:: +/qt.core.namespace.Orientation.Vertical);
    // Actually deprecated since 5.0, in docs
    /+ QT_DEPRECATED_VERSION_X_5_15("Use the last QWheelEvent constructor taking pixelDelta, angleDelta, phase, and inverted") +/this(ref const(QPointF) pos, ref const(QPointF) globalPos, int delta,
                    /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers,
                    /+ Qt:: +/qt.core.namespace.Orientation orient = /+ Qt:: +/qt.core.namespace.Orientation.Vertical);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use the last QWheelEvent constructor taking pixelDelta, angleDelta, phase, and inverted") +/this(ref const(QPointF) pos, ref const(QPointF) globalPos,
                    QPoint pixelDelta, QPoint angleDelta, int qt4Delta, /+ Qt:: +/qt.core.namespace.Orientation qt4Orientation,
                    /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use the last QWheelEvent constructor taking pixelDelta, angleDelta, phase, and inverted") +/this(ref const(QPointF) pos, ref const(QPointF) globalPos,
                    QPoint pixelDelta, QPoint angleDelta, int qt4Delta, /+ Qt:: +/qt.core.namespace.Orientation qt4Orientation,
                    /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, /+ Qt:: +/qt.core.namespace.ScrollPhase phase);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use the last QWheelEvent constructor taking pixelDelta, angleDelta, phase, and inverted") +/this(ref const(QPointF) pos, ref const(QPointF) globalPos, QPoint pixelDelta, QPoint angleDelta,
                    int qt4Delta, /+ Qt:: +/qt.core.namespace.Orientation qt4Orientation, /+ Qt:: +/qt.core.namespace.MouseButtons buttons,
                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, /+ Qt:: +/qt.core.namespace.ScrollPhase phase, /+ Qt:: +/qt.core.namespace.MouseEventSource source);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use the last QWheelEvent constructor taking pixelDelta, angleDelta, phase, and inverted") +/this(ref const(QPointF) pos, ref const(QPointF) globalPos, QPoint pixelDelta, QPoint angleDelta,
                    int qt4Delta, /+ Qt:: +/qt.core.namespace.Orientation qt4Orientation, /+ Qt:: +/qt.core.namespace.MouseButtons buttons,
                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, /+ Qt:: +/qt.core.namespace.ScrollPhase phase, /+ Qt:: +/qt.core.namespace.MouseEventSource source, bool inverted);
/+ #endif +/

    this(QPointF pos, QPointF globalPos, QPoint pixelDelta, QPoint angleDelta,
                    /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, /+ Qt:: +/qt.core.namespace.ScrollPhase phase,
                    bool inverted, /+ Qt:: +/qt.core.namespace.MouseEventSource source = /+ Qt:: +/qt.core.namespace.MouseEventSource.MouseEventNotSynthesized);
    ~this();


    pragma(inline, true) final QPoint pixelDelta() const { return pixelD; }
    pragma(inline, true) final QPoint angleDelta() const { return angleD; }

/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    // Actually deprecated since 5.0, in docs
    /+ QT_DEPRECATED_VERSION_X_5_15("Use angleDelta()") +/
        pragma(inline, true) final int delta() const  { return qt4D; }
    // Actually deprecated since 5.0, in docs
    /+ QT_DEPRECATED_VERSION_X_5_15("Use angleDelta()") +/
        pragma(inline, true) final /+ Qt:: +/qt.core.namespace.Orientation orientation() const { return qt4O; }
    version (QT_NO_INTEGER_EVENT_COORDINATES) {} else
    {
        /+ QT_DEPRECATED_VERSION_X_5_15("Use position()") +/
            pragma(inline, true) final QPoint pos() const { return p.toPoint(); }
        /+ QT_DEPRECATED_VERSION_X_5_15("Use globalPosition()") +/
            pragma(inline, true) final QPoint globalPos()   const { return g.toPoint(); }
        /+ QT_DEPRECATED_VERSION_X_5_15("Use position()") +/
            pragma(inline, true) final int x() const { return cast(int) (p.x()); }
        /+ QT_DEPRECATED_VERSION_X_5_15("Use position()") +/
            pragma(inline, true) final int y() const { return cast(int) (p.y()); }
        /+ QT_DEPRECATED_VERSION_X_5_15("Use globalPosition()") +/
            pragma(inline, true) final int globalX() const { return cast(int) (g.x()); }
        /+ QT_DEPRECATED_VERSION_X_5_15("Use globalPosition()") +/
            pragma(inline, true) final int globalY() const { return cast(int) (g.y()); }
    }
    /+ QT_DEPRECATED_VERSION_X_5_15("Use position()") +/
        pragma(inline, true) final ref const(QPointF) posF() const { return p; }
    /+ QT_DEPRECATED_VERSION_X_5_15("Use globalPosition()") +/
        pragma(inline, true) final ref const(QPointF) globalPosF()   const { return g; }
/+ #endif +/ // QT_DEPRECATED_SINCE(5, 15)

    pragma(inline, true) final QPointF position() const { return p; }
    pragma(inline, true) final QPointF globalPosition() const { return g; }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.MouseButtons buttons() const { return mouseState; }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.ScrollPhase phase() const { return cast(/+ Qt:: +/qt.core.namespace.ScrollPhase) (ph); }
    pragma(inline, true) final bool inverted() const { return invertedScrolling; }

    final /+ Qt:: +/qt.core.namespace.MouseEventSource source() const { return cast(/+ Qt:: +/qt.core.namespace.MouseEventSource) (src); }

protected:
    QPointF p;
    QPointF g;
    QPoint pixelD;
    QPoint angleD;
    int qt4D = 0;
    /+ Qt:: +/qt.core.namespace.Orientation qt4O = /+ Qt:: +/qt.core.namespace.Orientation.Vertical;
    /+ Qt:: +/qt.core.namespace.MouseButtons mouseState = /+ Qt:: +/qt.core.namespace.MouseButton.NoButton;
    /+ uint _unused_ : 2; +/ // Kept for binary compatibility
    uint bitfieldData__unused_;
    uint _unused_() const
    {
        return (bitfieldData__unused_ >> 0) & 0x3;
    }
    uint _unused_(uint value)
    {
        bitfieldData__unused_ = (bitfieldData__unused_ & ~0x3) | ((value & 0x3) << 0);
        return value;
    }
    /+ uint src: 2; +/
    uint src() const
    {
        return (bitfieldData__unused_ >> 2) & 0x3;
    }
    uint src(uint value)
    {
        bitfieldData__unused_ = (bitfieldData__unused_ & ~0xc) | ((value & 0x3) << 2);
        return value;
    }
    /+ bool invertedScrolling : 1; +/
    bool invertedScrolling() const
    {
        return (bitfieldData__unused_ >> 4) & 0x1;
    }
    bool invertedScrolling(bool value)
    {
        bitfieldData__unused_ = (bitfieldData__unused_ & ~0x10) | ((value & 0x1) << 4);
        return value;
    }
    /+ uint ph : 3; +/
    uint ph() const
    {
        return (bitfieldData__unused_ >> 5) & 0x7;
    }
    uint ph(uint value)
    {
        bitfieldData__unused_ = (bitfieldData__unused_ & ~0xe0) | ((value & 0x7) << 5);
        return value;
    }
    /+ int reserved : 24; +/
    int reserved() const
    {
        return (bitfieldData__unused_ >> 8) & 0xffffff;
    }
    int reserved(int value)
    {
        bitfieldData__unused_ = (bitfieldData__unused_ & ~0xffffff00) | ((value & 0xffffff) << 8);
        return value;
    }

    /+ friend class QApplication; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #endif

#if QT_CONFIG(tabletevent) +/
/// Binding for C++ class [QTabletEvent](https://doc.qt.io/qt-5/qtabletevent.html).
class /+ Q_GUI_EXPORT +/ QTabletEvent : QInputEvent
{
    mixin(Q_GADGET);
public:
    enum TabletDevice { NoDevice, Puck, Stylus, Airbrush, FourDMouse,
                        XFreeEraser /*internal*/, RotationStylus }
    /+ Q_ENUM(TabletDevice) +/
    enum PointerType { UnknownPointer, Pen, Cursor, Eraser }
    /+ Q_ENUM(PointerType) +/

/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    // Actually deprecated since 5.4, in docs
    /+ QT_DEPRECATED_VERSION_X_5_15("Use the other QTabletEvent constructor") +/this(Type t, ref const(QPointF) pos, ref const(QPointF) globalPos,
                     int device, int pointerType, qreal pressure, int xTilt, int yTilt,
                     qreal tangentialPressure, qreal rotation, int z,
                     /+ Qt:: +/qt.core.namespace.KeyboardModifiers keyState, qint64 uniqueID); // ### remove in Qt 6
/+ #endif +/
    this(Type t, ref const(QPointF) pos, ref const(QPointF) globalPos,
                     int device, int pointerType, qreal pressure, int xTilt, int yTilt,
                     qreal tangentialPressure, qreal rotation, int z,
                     /+ Qt:: +/qt.core.namespace.KeyboardModifiers keyState, qint64 uniqueID,
                     /+ Qt:: +/qt.core.namespace.MouseButton button, /+ Qt:: +/qt.core.namespace.MouseButtons buttons);
    ~this();

    pragma(inline, true) final QPoint pos() const { return mPos.toPoint(); }
    pragma(inline, true) final QPoint globalPos() const { return mGPos.toPoint(); }
/+ #if QT_DEPRECATED_SINCE(5,0)
    QT_DEPRECATED inline const QPointF &hiResGlobalPos() const { return mPos; }
#endif +/

    pragma(inline, true) final ref const(QPointF) posF() const { return mPos; }
    pragma(inline, true) final ref const(QPointF) globalPosF() const { return mGPos; }

    pragma(inline, true) final int x() const { return qRound(mPos.x()); }
    pragma(inline, true) final int y() const { return qRound(mPos.y()); }
    pragma(inline, true) final int globalX() const { return qRound(mGPos.x()); }
    pragma(inline, true) final int globalY() const { return qRound(mGPos.y()); }
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+ QT_DEPRECATED_VERSION_X_5_15("use globalPosF().x()") +/
        pragma(inline, true) final qreal hiResGlobalX() const { return mGPos.x(); }
    /+ QT_DEPRECATED_VERSION_X_5_15("use globalPosF().y()") +/
        pragma(inline, true) final qreal hiResGlobalY() const { return mGPos.y(); }
    /+ QT_DEPRECATED_VERSION_X_5_15("Use deviceType()") +/
        pragma(inline, true) final TabletDevice device() const { return cast(TabletDevice) (mDev); }
/+ #endif +/
    pragma(inline, true) final TabletDevice deviceType() const { return cast(TabletDevice) (mDev); }
    pragma(inline, true) final PointerType pointerType() const { return cast(PointerType) (mPointerType); }
    pragma(inline, true) final qint64 uniqueId() const { return mUnique; }
    pragma(inline, true) final qreal pressure() const { return mPress; }
    pragma(inline, true) final int z() const { return mZ; }
    pragma(inline, true) final qreal tangentialPressure() const { return mTangential; }
    pragma(inline, true) final qreal rotation() const { return mRot; }
    pragma(inline, true) final int xTilt() const { return mXT; }
    pragma(inline, true) final int yTilt() const { return mYT; }
    final /+ Qt:: +/qt.core.namespace.MouseButton button() const;
    final /+ Qt:: +/qt.core.namespace.MouseButtons buttons() const;

protected:
    QPointF mPos; QPointF mGPos;
    int mDev; int mPointerType; int mXT; int mYT; int mZ;
    qreal mPress; qreal mTangential; qreal mRot;
    qint64 mUnique;

    // QTabletEventPrivate for extra storage.
    // ### Qt 6: QPointingEvent will have Buttons, QTabletEvent will inherit
    void* mExtra;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #endif +/ // QT_CONFIG(tabletevent)

version (QT_NO_GESTURES) {} else
{
/// Binding for C++ class [QNativeGestureEvent](https://doc.qt.io/qt-5/qnativegestureevent.html).
class /+ Q_GUI_EXPORT +/ QNativeGestureEvent : QInputEvent
{
public:
/+ #if QT_DEPRECATED_SINCE(5, 10) +/
    /+ QT_DEPRECATED +/this(/+ Qt:: +/qt.core.namespace.NativeGestureType type, ref const(QPointF) localPos, ref const(QPointF) windowPos,
                            ref const(QPointF) screenPos, qreal value, cpp_ulong sequenceId, quint64 intArgument);
/+ #endif +/
    this(/+ Qt:: +/qt.core.namespace.NativeGestureType type, const(QTouchDevice)* dev, ref const(QPointF) localPos, ref const(QPointF) windowPos,
                            ref const(QPointF) screenPos, qreal value, cpp_ulong sequenceId, quint64 intArgument);
    ~this();
    final /+ Qt:: +/qt.core.namespace.NativeGestureType gestureType() const { return mGestureType; }
    final qreal value() const { return mRealValue; }

    version (QT_NO_INTEGER_EVENT_COORDINATES) {} else
    {
        pragma(inline, true) final const(QPoint) pos() const { return mLocalPos.toPoint(); }
        pragma(inline, true) final const(QPoint) globalPos() const { return mScreenPos.toPoint(); }
    }

    final ref const(QPointF) localPos() const { return mLocalPos; }
    final ref const(QPointF) windowPos() const { return mWindowPos; }
    final ref const(QPointF) screenPos() const { return mScreenPos; }

    final const(QTouchDevice)* device() const;

protected:
    /+ Qt:: +/qt.core.namespace.NativeGestureType mGestureType;
    QPointF mLocalPos;
    QPointF mWindowPos;
    QPointF mScreenPos;
    qreal mRealValue;
    cpp_ulong mSequenceId;
    quint64 mIntValue;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
}

/// Binding for C++ class [QKeyEvent](https://doc.qt.io/qt-5/qkeyevent.html).
class /+ Q_GUI_EXPORT +/ QKeyEvent : QInputEvent
{
public:
    this(Type type, int key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, ref const(QString) text = globalInitVar!QString,
                  bool autorep = false, ushort count = 1);
    this(Type type, int key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers,
                  quint32 nativeScanCode, quint32 nativeVirtualKey, quint32 nativeModifiers,
                  ref const(QString) text = globalInitVar!QString, bool autorep = false, ushort count = 1);
    ~this();

    final int key() const { return k; }
    version (QT_NO_SHORTCUT) {} else
    {
        final bool matches(QKeySequence.StandardKey key) const;
    }
//    final /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers() const;
    pragma(inline, true) final QString text() const { return *cast(QString*)&txt; }
    pragma(inline, true) final bool isAutoRepeat() const { return (autor) != 0; }
    pragma(inline, true) final int count() const { return int(c); }

    pragma(inline, true) final quint32 nativeScanCode() const { return nScanCode; }
    pragma(inline, true) final quint32 nativeVirtualKey() const { return nVirtualKey; }
    pragma(inline, true) final quint32 nativeModifiers() const { return nModifiers; }

    // Functions for the extended key event information
/+ #if QT_DEPRECATED_SINCE(5, 0)
    static inline QKeyEvent *createExtendedKeyEvent(Type type, int key, Qt::KeyboardModifiers modifiers,
                                             quint32 nativeScanCode, quint32 nativeVirtualKey,
                                             quint32 nativeModifiers,
                                             const QString& text = QString(), bool autorep = false,
                                             ushort count = 1)
    {
        return new QKeyEvent(type, key, modifiers,
                             nativeScanCode, nativeVirtualKey, nativeModifiers,
                             text, autorep, count);
    }

    inline bool hasExtendedInfo() const { return true; }
#endif +/

protected:
    QString txt;
    int k;
    quint32 nScanCode;
    quint32 nVirtualKey;
    quint32 nModifiers;
    ushort c;
    /+ ushort autor:1; +/
    ubyte bitfieldData_autor;
    ushort autor() const
    {
        return (bitfieldData_autor >> 0) & 0x1;
    }
    ushort autor(ushort value)
    {
        bitfieldData_autor = (bitfieldData_autor & ~0x1) | ((value & 0x1) << 0);
        return value;
    }
    // ushort reserved:15;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QFocusEvent](https://doc.qt.io/qt-5/qfocusevent.html).
class /+ Q_GUI_EXPORT +/ QFocusEvent : QEvent
{
public:
    /+ explicit +/this(Type type, /+ Qt:: +/qt.core.namespace.FocusReason reason=/+ Qt:: +/qt.core.namespace.FocusReason.OtherFocusReason);
    ~this();

    pragma(inline, true) final bool gotFocus() const { return type() == Type.FocusIn; }
    pragma(inline, true) final bool lostFocus() const { return type() == Type.FocusOut; }

    final /+ Qt:: +/qt.core.namespace.FocusReason reason() const;

private:
    /+ Qt:: +/qt.core.namespace.FocusReason m_reason;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QPaintEvent](https://doc.qt.io/qt-5/qpaintevent.html).
class /+ Q_GUI_EXPORT +/ QPaintEvent : QEvent
{
public:
    /+ explicit +/this(ref const(QRegion) paintRegion);
    /+ explicit +/this(ref const(QRect) paintRect);
    ~this();

    pragma(inline, true) final ref const(QRect) rect() const { return m_rect; }
    pragma(inline, true) final ref const(QRegion) region() const { return m_region; }

protected:
    QRect m_rect;
    QRegion m_region;
    bool m_erased;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QMoveEvent](https://doc.qt.io/qt-5/qmoveevent.html).
class /+ Q_GUI_EXPORT +/ QMoveEvent : QEvent
{
public:
    this(ref const(QPoint) pos, ref const(QPoint) oldPos);
    ~this();

    pragma(inline, true) final ref const(QPoint) pos() const { return p; }
    pragma(inline, true) final ref const(QPoint) oldPos() const { return oldp;}
protected:
    QPoint p; QPoint oldp;
    /+ friend class QApplication; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QExposeEvent](https://doc.qt.io/qt-5/qexposeevent.html).
class /+ Q_GUI_EXPORT +/ QExposeEvent : QEvent
{
public:
    /+ explicit +/this(ref const(QRegion) rgn);
    ~this();

    pragma(inline, true) final ref const(QRegion) region() const { return rgn; }

protected:
    QRegion rgn;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QPlatformSurfaceEvent](https://doc.qt.io/qt-5/qplatformsurfaceevent.html).
class /+ Q_GUI_EXPORT +/ QPlatformSurfaceEvent : QEvent
{
public:
    enum SurfaceEventType {
        SurfaceCreated,
        SurfaceAboutToBeDestroyed
    }

    /+ explicit +/this(SurfaceEventType surfaceEventType);
    ~this();

    pragma(inline, true) final SurfaceEventType surfaceEventType() const { return m_surfaceEventType; }

protected:
    SurfaceEventType m_surfaceEventType;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QResizeEvent](https://doc.qt.io/qt-5/qresizeevent.html).
class /+ Q_GUI_EXPORT +/ QResizeEvent : QEvent
{
public:
    this(ref const(QSize) size, ref const(QSize) oldSize);
    ~this();

    pragma(inline, true) final ref const(QSize) size() const { return s; }
    pragma(inline, true) final ref const(QSize) oldSize()const { return olds;}
protected:
    QSize s; QSize olds;
    /+ friend class QApplication; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QCloseEvent](https://doc.qt.io/qt-5/qcloseevent.html).
class /+ Q_GUI_EXPORT +/ QCloseEvent : QEvent
{
public:
    this();
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QIconDragEvent](https://doc.qt.io/qt-5/qicondragevent.html).
class /+ Q_GUI_EXPORT +/ QIconDragEvent : QEvent
{
public:
    this();
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QShowEvent](https://doc.qt.io/qt-5/qshowevent.html).
class /+ Q_GUI_EXPORT +/ QShowEvent : QEvent
{
public:
    this();
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QHideEvent](https://doc.qt.io/qt-5/qhideevent.html).
class /+ Q_GUI_EXPORT +/ QHideEvent : QEvent
{
public:
    this();
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

version (QT_NO_CONTEXTMENU) {} else
{
/// Binding for C++ class [QContextMenuEvent](https://doc.qt.io/qt-5/qcontextmenuevent.html).
class /+ Q_GUI_EXPORT +/ QContextMenuEvent : QInputEvent
{
public:
    enum Reason { Mouse, Keyboard, Other }

    this(Reason reason, ref const(QPoint) pos, ref const(QPoint) globalPos,
                          /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers);
    this(Reason reason, ref const(QPoint) pos, ref const(QPoint) globalPos);
    this(Reason reason, ref const(QPoint) pos);
    ~this();

    pragma(inline, true) final int x() const { return p.x(); }
    pragma(inline, true) final int y() const { return p.y(); }
    pragma(inline, true) final int globalX() const { return gp.x(); }
    pragma(inline, true) final int globalY() const { return gp.y(); }

    pragma(inline, true) final ref const(QPoint) pos() const { return p; }
    pragma(inline, true) final ref const(QPoint) globalPos() const { return gp; }

    pragma(inline, true) final Reason reason() const { return cast(Reason) (reas); }

protected:
    QPoint p;
    QPoint gp;
    /+ uint reas : 8; +/
    ubyte bitfieldData_reas;
    uint reas() const
    {
        return (bitfieldData_reas >> 0) & 0xff;
    }
    uint reas(uint value)
    {
        bitfieldData_reas = (bitfieldData_reas & ~0xff) | ((value & 0xff) << 0);
        return value;
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
}

version (QT_NO_INPUTMETHOD) {} else
{
/// Binding for C++ class [QInputMethodEvent](https://doc.qt.io/qt-5/qinputmethodevent.html).
class /+ Q_GUI_EXPORT +/ QInputMethodEvent : QEvent
{
public:
    enum AttributeType {
       TextFormat,
       Cursor,
       Language,
       Ruby,
       Selection
    }
    /// Binding for C++ class [QInputMethodEvent::Attribute](https://doc.qt.io/qt-5/qinputmethodevent-attribute.html).
    extern(C++, class) struct Attribute {
    public:
        /+this(AttributeType typ, int s, int l, QVariant val)
        {
            this.type = typ;
            this.start = s;
            this.length = l;
            this.value = /+ std:: +/move(cast(_Tp && ) (val));
        }
        this(AttributeType typ, int s, int l)
        {
            this.type = typ;
            this.start = s;
            this.length = l;
            this.value = typeof(this.value)();
        }+/

        AttributeType type;
        int start;
        int length;
        QVariant value;
    }
    this();
//    this(ref const(QString) preeditText, ref const(QList!(Attribute)) /+ QList<Attribute> +/ attributes);
    ~this();

    final void setCommitString(ref const(QString) commitString, int replaceFrom = 0, int replaceLength = 0);
//    pragma(inline, true) final ref const(QList!(Attribute)) attributes() const { return attrs; }
    pragma(inline, true) final ref const(QString) preeditString() const { return preedit; }

    pragma(inline, true) final ref const(QString) commitString() const { return commit; }
    pragma(inline, true) final int replacementStart() const { return replace_from; }
    pragma(inline, true) final int replacementLength() const { return replace_length; }

    /+ QInputMethodEvent(const QInputMethodEvent &other); +/

private:
    QString preedit;
    QList!(void*) attrs;
    QString commit;
    int replace_from;
    int replace_length;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QInputMethodEvent::Attribute, Q_MOVABLE_TYPE); +/

/// Binding for C++ class [QInputMethodQueryEvent](https://doc.qt.io/qt-5/qinputmethodqueryevent.html).
class /+ Q_GUI_EXPORT +/ QInputMethodQueryEvent : QEvent
{
public:
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.InputMethodQueries queries);
    ~this();

    final /+ Qt:: +/qt.core.namespace.InputMethodQueries queries() const { return m_queries; }

    final void setValue(/+ Qt:: +/qt.core.namespace.InputMethodQuery query, ref const(QVariant) value);
    final QVariant value(/+ Qt:: +/qt.core.namespace.InputMethodQuery query) const;
private:
    /+ Qt:: +/qt.core.namespace.InputMethodQueries m_queries;
    struct QueryPair {
        /+ Qt:: +/qt.core.namespace.InputMethodQuery query;
        QVariant value;
    }
    /+ friend QTypeInfo<QueryPair>; +/
    QVector!(void*) m_values;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QInputMethodQueryEvent::QueryPair, Q_MOVABLE_TYPE); +/

}

/+ #if QT_CONFIG(draganddrop) +/


/// Binding for C++ class [QDropEvent](https://doc.qt.io/qt-5/qdropevent.html).
class /+ Q_GUI_EXPORT +/ QDropEvent : QEvent
{
public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(ref const(QPointF) pos, /+ Qt:: +/qt.core.namespace.DropActions actions, const(QMimeData) data,
                   /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, Type type = Type.Drop);
    }));
    ~this();

    pragma(inline, true) final QPoint pos() const { return p.toPoint(); }
    pragma(inline, true) final ref const(QPointF) posF() const { return p; }
    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.MouseButtons mouseButtons() const { return mouseState; }
    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.KeyboardModifiers keyboardModifiers() const { return modState; }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.DropActions possibleActions() const { return act; }
    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.DropAction proposedAction() const { return default_action; }
    pragma(inline, true) final void acceptProposedAction() { drop_action = default_action; accept(); }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.DropAction dropAction() const { return drop_action; }
    final void setDropAction(/+ Qt:: +/qt.core.namespace.DropAction action);

    final QObject source() const;
    pragma(inline, true) final const(QMimeData) mimeData() const { return mdata; }

protected:
    /+ friend class QApplication; +/
    QPointF p;
    /+ Qt:: +/qt.core.namespace.MouseButtons mouseState;
    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modState;
    /+ Qt:: +/qt.core.namespace.DropActions act;
    /+ Qt:: +/qt.core.namespace.DropAction drop_action;
    /+ Qt:: +/qt.core.namespace.DropAction default_action;
    const(QMimeData) mdata;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QDragMoveEvent](https://doc.qt.io/qt-5/qdragmoveevent.html).
class /+ Q_GUI_EXPORT +/ QDragMoveEvent : QDropEvent
{
public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(ref const(QPoint) pos, /+ Qt:: +/qt.core.namespace.DropActions actions, const(QMimeData) data,
                       /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, Type type = Type.DragMove);
    }));
    ~this();

    pragma(inline, true) final QRect answerRect() const { return rect; }

//    pragma(inline, true) final void accept() { QDropEvent.accept(); }
//    pragma(inline, true) final void ignore() { QDropEvent.ignore(); }

/+    pragma(inline, true) final void accept(ref const(QRect)  r) { accept(); rect = r; }
    pragma(inline, true) final void ignore(ref const(QRect)  r) { ignore(); rect = r; }+/

protected:
    QRect rect;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QDragEnterEvent](https://doc.qt.io/qt-5/qdragenterevent.html).
class /+ Q_GUI_EXPORT +/ QDragEnterEvent : QDragMoveEvent
{
public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(ref const(QPoint) pos, /+ Qt:: +/qt.core.namespace.DropActions actions, const(QMimeData) data,
                        /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers);
    }));
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QDragLeaveEvent](https://doc.qt.io/qt-5/qdragleaveevent.html).
class /+ Q_GUI_EXPORT +/ QDragLeaveEvent : QEvent
{
public:
    this();
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #endif +/ // QT_CONFIG(draganddrop)


/// Binding for C++ class [QHelpEvent](https://doc.qt.io/qt-5/qhelpevent.html).
class /+ Q_GUI_EXPORT +/ QHelpEvent : QEvent
{
public:
    this(Type type, ref const(QPoint) pos, ref const(QPoint) globalPos);
    ~this();

    pragma(inline, true) final int x() const { return p.x(); }
    pragma(inline, true) final int y() const { return p.y(); }
    pragma(inline, true) final int globalX() const { return gp.x(); }
    pragma(inline, true) final int globalY() const { return gp.y(); }

    pragma(inline, true) final ref const(QPoint) pos()  const { return p; }
    pragma(inline, true) final ref const(QPoint) globalPos() const { return gp; }

private:
    QPoint p;
    QPoint gp;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

version (QT_NO_STATUSTIP) {} else
{
/// Binding for C++ class [QStatusTipEvent](https://doc.qt.io/qt-5/qstatustipevent.html).
class /+ Q_GUI_EXPORT +/ QStatusTipEvent : QEvent
{
public:
    /+ explicit +/this(ref const(QString) tip);
    ~this();

    pragma(inline, true) final QString tip() const { return *cast(QString*)&s; }
private:
    QString s;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
}

/+ #if QT_CONFIG(whatsthis) +/
/// Binding for C++ class [QWhatsThisClickedEvent](https://doc.qt.io/qt-5/qwhatsthisclickedevent.html).
class /+ Q_GUI_EXPORT +/ QWhatsThisClickedEvent : QEvent
{
public:
    /+ explicit +/this(ref const(QString) href);
    ~this();

    pragma(inline, true) final QString href() const { return *cast(QString*)&s; }
private:
    QString s;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #endif +/

/// Binding for C++ class [QFileOpenEvent](https://doc.qt.io/qt-5/qfileopenevent.html).
class /+ Q_GUI_EXPORT +/ QFileOpenEvent : QEvent
{
public:
    /+ explicit +/this(ref const(QString) file);
    /+ explicit +/this(ref const(QUrl) url);
    ~this();

    pragma(inline, true) final QString file() const { return *cast(QString*)&f; }
    final QUrl url() const { return m_url; }
    // final bool openFile(QFile &file, QIODevice.OpenMode flags) const;
private:
    QString f;
    QUrl m_url;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

version (QT_NO_TOOLBAR) {} else
{
class /+ Q_GUI_EXPORT +/ QToolBarChangeEvent : QEvent
{
public:
    /+ explicit +/this(bool t);
    ~this();

    pragma(inline, true) final bool toggle() const { return (tog) != 0; }
private:
    /+ uint tog : 1; +/
    ubyte bitfieldData_tog;
    uint tog() const
    {
        return (bitfieldData_tog >> 0) & 0x1;
    }
    uint tog(uint value)
    {
        bitfieldData_tog = (bitfieldData_tog & ~0x1) | ((value & 0x1) << 0);
        return value;
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
}

version (QT_NO_SHORTCUT) {} else
{
/// Binding for C++ class [QShortcutEvent](https://doc.qt.io/qt-5/qshortcutevent.html).
class /+ Q_GUI_EXPORT +/ QShortcutEvent : QEvent
{
public:
    this(ref const(QKeySequence) key, int id, bool ambiguous = false);
    ~this();

    pragma(inline, true) final ref const(QKeySequence) key() const { return sequence; }
    pragma(inline, true) final int shortcutId() const { return sid; }
    pragma(inline, true) final bool isAmbiguous() const { return ambig; }
protected:
    QKeySequence sequence;
    bool ambig;
    int  sid;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
}

/// Binding for C++ class [QWindowStateChangeEvent](https://doc.qt.io/qt-5/qwindowstatechangeevent.html).
class /+ Q_GUI_EXPORT +/ QWindowStateChangeEvent: QEvent
{
public:
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.WindowStates aOldState, bool isOverride = false);
    ~this();

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.WindowStates oldState() const { return ostate; }
    final bool isOverride() const;

private:
    /+ Qt:: +/qt.core.namespace.WindowStates ostate;
    bool m_override;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QEvent *);
#endif +/

version (QT_NO_SHORTCUT) {} else
{
/+pragma(inline, true) bool operator ==(QKeyEvent e, QKeySequence.StandardKey key){return (e ? e.matches(key) : false);}+/
/+pragma(inline, true) bool operator ==(QKeySequence.StandardKey key, QKeyEvent e){return (e ? e.matches(key) : false);}+/
}

/// Binding for C++ class [QPointingDeviceUniqueId](https://doc.qt.io/qt-5/qpointingdeviceuniqueid.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPointingDeviceUniqueId
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(qint64 numericId READ numericId CONSTANT) +/
public:
    @disable this();
    /+/+ Q_ALWAYS_INLINE +/
        pragma(inline, true) this()/+ noexcept+/
        {
            this.m_numericId = -1;
        }+/
    // compiler-generated copy/move ctor/assignment operators are ok!
    // compiler-generated dtor is ok!

    static QPointingDeviceUniqueId fromNumericId(qint64 id);

    /+ Q_ALWAYS_INLINE +/ pragma(inline, true) bool isValid() const/+ noexcept+/ { return m_numericId != -1; }
    qint64 numericId() const/+ noexcept+/;

private:
    // TODO: for TUIO 2, or any other type of complex token ID, an internal
    // array (or hash) can be added to hold additional properties.
    // In this case, m_numericId will then turn into an index into that array (or hash).
    qint64 m_numericId = -1;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QPointingDeviceUniqueId, Q_MOVABLE_TYPE);

#if 0
#pragma qt_sync_suspend_processing
#endif
template <> class QList<QPointingDeviceUniqueId> {}; // to prevent instantiation: use QVector instead
#if 0
#pragma qt_sync_resume_processing
#endif +/

/+/+ Q_GUI_EXPORT +/ bool operator ==(QPointingDeviceUniqueId lhs, QPointingDeviceUniqueId rhs)/+ noexcept+/;+/
/+pragma(inline, true) bool operator !=(QPointingDeviceUniqueId lhs, QPointingDeviceUniqueId rhs)/+ noexcept+/
{ return !operator==(lhs, rhs); }+/
/+ Q_GUI_EXPORT uint qHash(QPointingDeviceUniqueId key, uint seed = 0) noexcept; +/



extern(C++, class) struct QTouchEventTouchPointPrivate;
/// Binding for C++ class [QTouchEvent](https://doc.qt.io/qt-5/qtouchevent.html).
class /+ Q_GUI_EXPORT +/ QTouchEvent : QInputEvent
{
public:
    /// Binding for C++ class [QTouchEvent::TouchPoint](https://doc.qt.io/qt-5/qtouchevent-touchpoint.html).
    extern(C++, class) struct /+ Q_GUI_EXPORT +/ TouchPoint
    {
    public:
        enum InfoFlag {
            Pen  = 0x0001,
            Token = 0x0002
        }
/+ #ifndef Q_MOC_RUN
        // otherwise moc gives
        // Error: Meta object features not supported for nested classes
        Q_DECLARE_FLAGS(InfoFlags, InfoFlag) +/
alias InfoFlags = QFlags!(InfoFlag);/+ #endif +/

        @disable this();
        /+ explicit +/this(int id/+ = -1+/);
        @disable this(this);
        this(ref const(TouchPoint) other);
        /+ TouchPoint(TouchPoint &&other) noexcept
            : d(nullptr)
        { qSwap(d, other.d); } +/
        /+ TouchPoint &operator=(TouchPoint &&other) noexcept
        { qSwap(d, other.d); return *this; } +/
        ~this();

        /+ref TouchPoint operator =(ref const(TouchPoint) other)
        { if ( d != other.d ) { auto copy = TouchPoint(other); swap(copy); } return this; }+/

        /+ void swap(TouchPoint &other) noexcept
        { qSwap(d, other.d); } +/

        int id() const;
        QPointingDeviceUniqueId uniqueId() const;

        /+ Qt:: +/qt.core.namespace.TouchPointState state() const;

        QPointF pos() const;
        QPointF startPos() const;
        QPointF lastPos() const;

        QPointF scenePos() const;
        QPointF startScenePos() const;
        QPointF lastScenePos() const;

        QPointF screenPos() const;
        QPointF startScreenPos() const;
        QPointF lastScreenPos() const;

        QPointF normalizedPos() const;
        QPointF startNormalizedPos() const;
        QPointF lastNormalizedPos() const;

/+ #if QT_DEPRECATED_SINCE(5, 15) +/
        // All these are actually deprecated since 5.9, in docs
        /+ QT_DEPRECATED_VERSION_X_5_15("Use pos() and ellipseDiameters()") +/
                QRectF rect() const;
        /+ QT_DEPRECATED_VERSION_X_5_15("Use scenePos() and ellipseDiameters()") +/
                QRectF sceneRect() const;
        /+ QT_DEPRECATED_VERSION_X_5_15("Use screenPos() and ellipseDiameters()") +/
                QRectF screenRect() const;

        // internal
        /+ QT_DEPRECATED_VERSION_X_5_15("Use setPos() and setEllipseDiameters()") +/
                void setRect(ref const(QRectF) rect); // deprecated
        /+ QT_DEPRECATED_VERSION_X_5_15("Use setScenePos() and setEllipseDiameters()") +/
                void setSceneRect(ref const(QRectF) sceneRect); // deprecated
        /+ QT_DEPRECATED_VERSION_X_5_15("Use setScreenPos() and setEllipseDiameters()") +/
                void setScreenRect(ref const(QRectF) screenRect); // deprecated
/+ #endif +/
        qreal pressure() const;
        qreal rotation() const;
        QSizeF ellipseDiameters() const;

        QVector2D velocity() const;
        InfoFlags flags() const;
        QVector!(QPointF) rawScreenPositions() const;

        // internal
        void setId(int id);
        void setUniqueId(qint64 uid);
        void setState(/+ Qt:: +/qt.core.namespace.TouchPointStates state);
        void setPos(ref const(QPointF) pos);
        void setScenePos(ref const(QPointF) scenePos);
        void setScreenPos(ref const(QPointF) screenPos);
        void setNormalizedPos(ref const(QPointF) normalizedPos);
        void setStartPos(ref const(QPointF) startPos);
        void setStartScenePos(ref const(QPointF) startScenePos);
        void setStartScreenPos(ref const(QPointF) startScreenPos);
        void setStartNormalizedPos(ref const(QPointF) startNormalizedPos);
        void setLastPos(ref const(QPointF) lastPos);
        void setLastScenePos(ref const(QPointF) lastScenePos);
        void setLastScreenPos(ref const(QPointF) lastScreenPos);
        void setLastNormalizedPos(ref const(QPointF) lastNormalizedPos);
        void setPressure(qreal pressure);
        void setRotation(qreal angle);
        void setEllipseDiameters(ref const(QSizeF) dia);
        void setVelocity(ref const(QVector2D) v);
        void setFlags(InfoFlags flags);
        void setRawScreenPositions(ref const(QVector!(QPointF)) positions);

    private:
        QTouchEventTouchPointPrivate* d;
        /+ friend class QGuiApplication; +/
        /+ friend class QGuiApplicationPrivate; +/
        /+ friend class QApplication; +/
        /+ friend class QApplicationPrivate; +/
        /+ friend class QQuickPointerTouchEvent; +/
        /+ friend class QQuickMultiPointTouchArea; +/
    }

/+ #if QT_DEPRECATED_SINCE(5, 0)
    enum DeviceType {
        TouchScreen,
        TouchPad
    };
#endif +/

    /+ explicit +/this(QEvent.Type eventType,
                             QTouchDevice* device = null,
                             /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier,
                             /+ Qt:: +/qt.core.namespace.TouchPointStates touchPointStates = /+ Qt:: +/qt.core.namespace.TouchPointStates(),
                             ref const(QList!(TouchPoint)) touchPoints = globalInitVar!(QList!(TouchPoint)));
    ~this();

    pragma(inline, true) final QWindow* window() const { return cast(QWindow*)_window; }
    pragma(inline, true) final QObject target() const { return cast(QObject)_target; }
/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED inline QTouchEvent::DeviceType deviceType() const { return static_cast<DeviceType>(int(_device->type())); }
#endif +/
    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.TouchPointStates touchPointStates() const { return _touchPointStates; }
    pragma(inline, true) final ref const(QList!(QTouchEvent.TouchPoint)) touchPoints() const { return _touchPoints; }
    pragma(inline, true) final QTouchDevice* device() const { return cast(QTouchDevice*)_device; }

    // internal
    pragma(inline, true) final void setWindow(QWindow* awindow) { _window = awindow; }
    pragma(inline, true) final void setTarget(QObject atarget) { _target = atarget; }
    pragma(inline, true) final void setTouchPointStates(/+ Qt:: +/qt.core.namespace.TouchPointStates aTouchPointStates) { _touchPointStates = aTouchPointStates; }
    pragma(inline, true) final void setTouchPoints(ref const(QList!(QTouchEvent.TouchPoint)) atouchPoints) { _touchPoints = *cast(QList!TouchPoint*)&atouchPoints; }
    pragma(inline, true) final void setDevice(QTouchDevice* adevice) { _device = adevice; }

protected:
    QWindow* _window;
    QObject _target;
    QTouchDevice* _device;
    /+ Qt:: +/qt.core.namespace.TouchPointStates _touchPointStates;
    QList!(TouchPoint) _touchPoints;

    /+ friend class QGuiApplication; +/
    /+ friend class QGuiApplicationPrivate; +/
    /+ friend class QApplication; +/
    /+ friend class QApplicationPrivate; +/
    version (QT_NO_GRAPHICSVIEW) {} else
    {
        /+ friend class QGraphicsScenePrivate; +/ // direct access to _touchPoints
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QTouchEvent.TouchPoint.InfoFlags.enum_type) operator |(QTouchEvent.TouchPoint.InfoFlags.enum_type f1, QTouchEvent.TouchPoint.InfoFlags.enum_type f2)/+noexcept+/{return QFlags!(QTouchEvent.TouchPoint.InfoFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QTouchEvent.TouchPoint.InfoFlags.enum_type) operator |(QTouchEvent.TouchPoint.InfoFlags.enum_type f1, QFlags!(QTouchEvent.TouchPoint.InfoFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QTouchEvent.TouchPoint.InfoFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+ Q_DECLARE_TYPEINFO(QTouchEvent::TouchPoint, Q_MOVABLE_TYPE);
Q_DECLARE_OPERATORS_FOR_FLAGS(QTouchEvent::TouchPoint::InfoFlags)
#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QTouchEvent::TouchPoint &);
#endif +/

/// Binding for C++ class [QScrollPrepareEvent](https://doc.qt.io/qt-5/qscrollprepareevent.html).
class /+ Q_GUI_EXPORT +/ QScrollPrepareEvent : QEvent
{
public:
    /+ explicit +/this(ref const(QPointF) startPos);
    ~this();

    final QPointF startPos() const;

    final QSizeF viewportSize() const;
    final QRectF contentPosRange() const;
    final QPointF contentPos() const;

    final void setViewportSize(ref const(QSizeF) size);
    final void setContentPosRange(ref const(QRectF) rect);
    final void setContentPos(ref const(QPointF) pos);

private:
    QObject m_target; // Qt 6 remove.
    QPointF m_startPos;
    QSizeF m_viewportSize;
    QRectF m_contentPosRange;
    QPointF m_contentPos;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QScrollEvent](https://doc.qt.io/qt-5/qscrollevent.html).
class /+ Q_GUI_EXPORT +/ QScrollEvent : QEvent
{
public:
    enum ScrollState
    {
        ScrollStarted,
        ScrollUpdated,
        ScrollFinished
    }

    this(ref const(QPointF) contentPos, ref const(QPointF) overshoot, ScrollState scrollState);
    ~this();

    final QPointF contentPos() const;
    final QPointF overshootDistance() const;
    final ScrollState scrollState() const;

private:
    QPointF m_contentPos;
    QPointF m_overshoot;
    ScrollState m_state;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

class /+ Q_GUI_EXPORT +/ QScreenOrientationChangeEvent : QEvent
{
public:
    this(QScreen screen, /+ Qt:: +/qt.core.namespace.ScreenOrientation orientation);
    ~this();

    final QScreen screen() const;
    final /+ Qt:: +/qt.core.namespace.ScreenOrientation orientation() const;

private:
    QScreen m_screen;
    /+ Qt:: +/qt.core.namespace.ScreenOrientation m_orientation;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

class /+ Q_GUI_EXPORT +/ QApplicationStateChangeEvent : QEvent
{
public:
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.ApplicationState state);
    final /+ Qt:: +/qt.core.namespace.ApplicationState applicationState() const;

private:
    /+ Qt:: +/qt.core.namespace.ApplicationState m_applicationState;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
version (QT_NO_INPUTMETHOD)
{
extern(C++, class) struct QInputMethodQueryEvent;
}

version (QT_NO_CONTEXTMENU)
{
class QContextMenuEvent;
}

version (QT_NO_INPUTMETHOD)
{
class QInputMethodEvent;
}


