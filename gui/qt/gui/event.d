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

import qt.config;
import qt.core.coreevent;
import qt.core.file;
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
import qt.core.url;
import qt.gui.action;
import qt.gui.eventpoint;
import qt.gui.inputdevice;
import qt.gui.keysequence;
import qt.gui.pointingdevice;
import qt.gui.region;
import qt.gui.screen;
import qt.gui.vector2d;
import qt.helpers;
version (QT_NO_INPUTMETHOD) {} else
    import qt.core.variant;

/+ #if QT_CONFIG(shortcut)
#endif


#if QT_CONFIG(gestures) +/
version (QT_NO_GESTURES)
{
extern(C++, class) struct QGesture;
}

/+ #endif +/

/// Binding for C++ class [QInputEvent](https://doc.qt.io/qt-6/qinputevent.html).
class /+ Q_GUI_EXPORT +/ QInputEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QInputEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ explicit +/this(Type type, const(QInputDevice) m_dev, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier);
    }));
    ~this();
    override QInputEvent clone() const {
        return cpp_new_copy!QInputEvent(cast() this);
    }

    final const(QInputDevice) device() const { return m_dev; }
    final QInputDevice.DeviceType deviceType() const { return m_dev ? m_dev.type() : QInputDevice.DeviceType.Unknown; }
    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers() const { return m_modState; }
    pragma(inline, true) final void setModifiers(/+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers) { m_modState = modifiers; }
    pragma(inline, true) final quint64 timestamp() const { return m_timeStamp; }
    /+ virtual +/ void setTimestamp(quint64 timestamp) { m_timeStamp = timestamp; }

protected:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(Type type, PointerEventTag, const(QInputDevice) dev, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier);
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(Type type, SinglePointEventTag, const(QInputDevice) dev, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier);
    }));

    const(QInputDevice) m_dev = null;
    quint64 m_timeStamp = 0;
    /+ Qt:: +/qt.core.namespace.KeyboardModifiers m_modState = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier;
    // fill up to the closest 8-byte aligned size: 48
    quint32 m_reserved = 0;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QPointerEvent](https://doc.qt.io/qt-6/qpointerevent.html).
class /+ Q_GUI_EXPORT +/ QPointerEvent : QInputEvent
{
    /+ Q_EVENT_DISABLE_COPY(QPointerEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ explicit +/this(Type type, const(QPointingDevice) dev,
                               /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, ref const(QList!(QEventPoint)) points = globalInitVar!(QList!(QEventPoint)));
    }));
    ~this();

    override QPointerEvent clone() const {
        return cpp_new_copy!QPointerEvent(cast() this);
    }

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final const(QPointingDevice) pointingDevice() const;
    }));
    final QPointingDevice.PointerType pointerType() const {
        return pointingDevice() ? pointingDevice().pointerType() : QPointingDevice.PointerType.Unknown;
    }
    override void setTimestamp(quint64 timestamp);
    final qsizetype pointCount() const { return m_points.count(); }
//    final ref QEventPoint point(qsizetype i) { return m_points[i]; }
    final ref const(QList!(QEventPoint)) points() const { return m_points; }
    final QEventPoint* pointById(int id);
    final bool allPointsGrabbed() const;
    /+ virtual +/ bool isBeginEvent() const { return false; }
    /+ virtual +/ bool isUpdateEvent() const { return false; }
    /+ virtual +/ bool isEndEvent() const { return false; }
    final bool allPointsAccepted() const;
    /+ virtual +/ override void setAccepted(bool accepted);
    final QObject exclusiveGrabber(ref const(QEventPoint) point) const;
    final void setExclusiveGrabber(ref const(QEventPoint) point, QObject exclusiveGrabber);
    //final QList!( QPointer!(QObject)) passiveGrabbers(ref const(QEventPoint) point) const;
    final void clearPassiveGrabbers(ref const(QEventPoint) point);
    final bool addPassiveGrabber(ref const(QEventPoint) point, QObject grabber);
    final bool removePassiveGrabber(ref const(QEventPoint) point, QObject grabber);

protected:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(Type type, SinglePointEventTag, const(QInputDevice) dev, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier);
    }));

    QList!(QEventPoint) m_points;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QSinglePointEvent](https://doc.qt.io/qt-6/qsinglepointevent.html).
class /+ Q_GUI_EXPORT +/ QSinglePointEvent : QPointerEvent
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(QObject *exclusivePointGrabber READ exclusivePointGrabber
               WRITE setExclusivePointGrabber)

    Q_EVENT_DISABLE_COPY(QSinglePointEvent) +/protected:/+ ; +/
    public this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    // Workaround for https://issues.dlang.org/show_bug.cgi?id=22811
    // Destructor added to prevent DMD error "class `qt.gui.event.QEnterEvent` use of `qt.gui.event.QPointerEvent.~this()` is hidden by `QEnterEvent`"
    ~this(){}

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.MouseButton button() const { return m_button; }
    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.MouseButtons buttons() const { return m_mouseState; }

    pragma(inline, true) final QPointF position() const
    { (mixin(Q_ASSERT(q{!QPointerEvent.m_points.isEmpty()}))); return m_points.first().position(); }
    pragma(inline, true) final QPointF scenePosition() const
    { (mixin(Q_ASSERT(q{!QPointerEvent.m_points.isEmpty()}))); return m_points.first().scenePosition(); }
    pragma(inline, true) final QPointF globalPosition() const
    { (mixin(Q_ASSERT(q{!QPointerEvent.m_points.isEmpty()}))); return m_points.first().globalPosition(); }

    override bool isBeginEvent() const;
    override bool isUpdateEvent() const;
    override bool isEndEvent() const;

    final QObject exclusivePointGrabber() const
    { return QPointerEvent.exclusiveGrabber(points().first()); }
    final void setExclusivePointGrabber(QObject exclusiveGrabber)
    { QPointerEvent.setExclusiveGrabber(points().first(), exclusiveGrabber); }

    override QSinglePointEvent clone() const {
        return cpp_new_copy!QSinglePointEvent(cast() this);
    }

protected:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(Type type, const(QPointingDevice) dev, ref const(QEventPoint) point,
                          /+ Qt:: +/qt.core.namespace.MouseButton button, /+ Qt:: +/qt.core.namespace.MouseButtons buttons,
                          /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, /+ Qt:: +/qt.core.namespace.MouseEventSource source);
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(Type type, const(QPointingDevice) dev, ref const(QPointF) localPos,
                          ref const(QPointF) scenePos, ref const(QPointF) globalPos,
                          /+ Qt:: +/qt.core.namespace.MouseButton button, /+ Qt:: +/qt.core.namespace.MouseButtons buttons,
                          /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers,
                          /+ Qt:: +/qt.core.namespace.MouseEventSource source = /+ Qt:: +/qt.core.namespace.MouseEventSource.MouseEventNotSynthesized);
    }));

    /+ Qt:: +/qt.core.namespace.MouseButton m_button = /+ Qt:: +/qt.core.namespace.MouseButton.NoButton;
    /+ Qt:: +/qt.core.namespace.MouseButtons m_mouseState = /+ Qt:: +/qt.core.namespace.MouseButton.NoButton;
    /+ Qt:: +/qt.core.namespace.MouseEventSource m_source;
    /*
        Fill up to the next 8-byte aligned size: 88
        We have 32bits left, use some for QSinglePointEvent subclasses so that
        we don't end up with gaps.
    */
    // split this in two quint16; with a quint32, MSVC would 32-bit align it
    quint16 m_reserved;
    /+ quint16 m_reserved2  : 11; +/
    ushort bitfieldData_m_reserved2;
    quint16 m_reserved2() const
    {
        return (bitfieldData_m_reserved2 >> 0) & 0x7ff;
    }
    quint16 m_reserved2(quint16 value)
    {
        bitfieldData_m_reserved2 = (bitfieldData_m_reserved2 & ~0x7ff) | ((value & 0x7ff) << 0);
        return value;
    }
    // for QMouseEvent
    /+ quint16 m_doubleClick : 1; +/
    quint16 m_doubleClick() const
    {
        return (bitfieldData_m_reserved2 >> 11) & 0x1;
    }
    quint16 m_doubleClick(quint16 value)
    {
        bitfieldData_m_reserved2 = (bitfieldData_m_reserved2 & ~0x800) | ((value & 0x1) << 11);
        return value;
    }
    // for QWheelEvent
    /+ quint16 m_phase : 3; +/
    quint16 m_phase() const
    {
        return (bitfieldData_m_reserved2 >> 12) & 0x7;
    }
    quint16 m_phase(quint16 value)
    {
        bitfieldData_m_reserved2 = (bitfieldData_m_reserved2 & ~0x7000) | ((value & 0x7) << 12);
        return value;
    }
    /+ quint16 m_invertedScrolling : 1; +/
    quint16 m_invertedScrolling() const
    {
        return (bitfieldData_m_reserved2 >> 15) & 0x1;
    }
    quint16 m_invertedScrolling(quint16 value)
    {
        bitfieldData_m_reserved2 = (bitfieldData_m_reserved2 & ~0x8000) | ((value & 0x1) << 15);
        return value;
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QEnterEvent](https://doc.qt.io/qt-6/qenterevent.html).
class /+ Q_GUI_EXPORT +/ QEnterEvent : QSinglePointEvent
{
    /+ Q_EVENT_DISABLE_COPY(QEnterEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(ref const(QPointF) localPos, ref const(QPointF) scenePos, ref const(QPointF) globalPos,
                    const(QPointingDevice) device = QPointingDevice.primaryPointingDevice());
    }));
    ~this();

    override QEnterEvent clone() const {
        return cpp_new_copy!QEnterEvent(cast() this);
    }

/+ #if QT_DEPRECATED_SINCE(6, 0)
#ifndef QT_NO_INTEGER_EVENT_COORDINATES +/
    version (QT_NO_INTEGER_EVENT_COORDINATES) {} else
    {
        /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
            pragma(inline, true) final QPoint pos() const { return position().toPoint(); }
        /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition()") +/
            pragma(inline, true) final QPoint globalPos() const { return globalPosition().toPoint(); }
        /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
            pragma(inline, true) final int x() const { return qRound(position().x()); }
        /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
            pragma(inline, true) final int y() const { return qRound(position().y()); }
        /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition()") +/
            pragma(inline, true) final int globalX() const { return qRound(globalPosition().x()); }
        /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition()") +/
            pragma(inline, true) final int globalY() const { return qRound(globalPosition().y()); }
    }
/+ #endif +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
        final QPointF localPos() const { return position(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use scenePosition()") +/
        final QPointF windowPos() const { return scenePosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition()") +/
        final QPointF screenPos() const { return globalPosition(); }
/+ #endif +/ // QT_DEPRECATED_SINCE(6, 0)
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QMouseEvent](https://doc.qt.io/qt-6/qmouseevent.html).
class /+ Q_GUI_EXPORT +/ QMouseEvent : QSinglePointEvent
{
    /+ Q_EVENT_DISABLE_COPY(QMouseEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(Type type, ref const(QPointF) localPos, /+ Qt:: +/qt.core.namespace.MouseButton button,
                    /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers,
                    const(QPointingDevice) device = QPointingDevice.primaryPointingDevice());
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(Type type, ref const(QPointF) localPos, ref const(QPointF) globalPos,
                    /+ Qt:: +/qt.core.namespace.MouseButton button, /+ Qt:: +/qt.core.namespace.MouseButtons buttons,
                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers,
                    const(QPointingDevice) device = QPointingDevice.primaryPointingDevice());
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(Type type, ref const(QPointF) localPos, ref const(QPointF) scenePos, ref const(QPointF) globalPos,
                    /+ Qt:: +/qt.core.namespace.MouseButton button, /+ Qt:: +/qt.core.namespace.MouseButtons buttons,
                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers,
                    const(QPointingDevice) device = QPointingDevice.primaryPointingDevice());
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(Type type, ref const(QPointF) localPos, ref const(QPointF) scenePos, ref const(QPointF) globalPos,
                    /+ Qt:: +/qt.core.namespace.MouseButton button, /+ Qt:: +/qt.core.namespace.MouseButtons buttons,
                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, /+ Qt:: +/qt.core.namespace.MouseEventSource source,
                    const(QPointingDevice) device = QPointingDevice.primaryPointingDevice());
    }));
    ~this();

    override QMouseEvent clone() const {
        return cpp_new_copy!QMouseEvent(cast() this);
    }

/+ #ifndef QT_NO_INTEGER_EVENT_COORDINATES +/
    version (QT_NO_INTEGER_EVENT_COORDINATES) {} else
    {
        pragma(inline, true) final QPoint pos() const { return position().toPoint(); }
    }
/+ #endif
#if QT_DEPRECATED_SINCE(6, 0)
#ifndef QT_NO_INTEGER_EVENT_COORDINATES +/
    version (QT_NO_INTEGER_EVENT_COORDINATES) {} else
    {
        /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition()") +/
            pragma(inline, true) final QPoint globalPos() const { return globalPosition().toPoint(); }
        /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
            pragma(inline, true) final int x() const { return qRound(position().x()); }
        /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
            pragma(inline, true) final int y() const { return qRound(position().y()); }
        /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition()") +/
            pragma(inline, true) final int globalX() const { return qRound(globalPosition().x()); }
        /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition()") +/
            pragma(inline, true) final int globalY() const { return qRound(globalPosition().y()); }
    }
/+ #endif +/ // QT_NO_INTEGER_EVENT_COORDINATES
    /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
        final QPointF localPos() const { return position(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use scenePosition()") +/
        final QPointF windowPos() const { return scenePosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition()") +/
        final QPointF screenPos() const { return globalPosition(); }
    final /+ Qt:: +/qt.core.namespace.MouseEventSource source() const;
/+ #endif +/ // QT_DEPRECATED_SINCE(6, 0)
    final /+ Qt:: +/qt.core.namespace.MouseEventFlags flags() const;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QHoverEvent](https://doc.qt.io/qt-6/qhoverevent.html).
class /+ Q_GUI_EXPORT +/ QHoverEvent : QSinglePointEvent
{
    /+ Q_EVENT_DISABLE_COPY(QHoverEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(Type type, ref const(QPointF) pos, ref const(QPointF) oldPos,
                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier,
                    const(QPointingDevice) device = QPointingDevice.primaryPointingDevice());
    }));
    ~this();

    override QHoverEvent clone() const {
        return cpp_new_copy!QHoverEvent(cast() this);
    }

/+ #if QT_DEPRECATED_SINCE(6, 0)
#ifndef QT_NO_INTEGER_EVENT_COORDINATES +/
    version (QT_NO_INTEGER_EVENT_COORDINATES) {} else
    {
        /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
            pragma(inline, true) final QPoint pos() const { return position().toPoint(); }
    }
/+ #endif +/

    /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
        pragma(inline, true) final QPointF posF() const { return position(); }
/+ #endif +/ // QT_DEPRECATED_SINCE(6, 0)

    override bool isUpdateEvent() const  { return true; }

    // TODO deprecate when we figure out an actual replacement (point history?)
    pragma(inline, true) final QPoint oldPos() const { return m_oldPos.toPoint(); }
    pragma(inline, true) final QPointF oldPosF() const { return m_oldPos; }

protected:
    QPointF m_oldPos; // TODO remove?
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #if QT_CONFIG(wheelevent) +/
/// Binding for C++ class [QWheelEvent](https://doc.qt.io/qt-6/qwheelevent.html).
class /+ Q_GUI_EXPORT +/ QWheelEvent : QSinglePointEvent
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(const QPointingDevice *device READ pointingDevice)
    Q_PROPERTY(QPoint pixelDelta READ pixelDelta)
    Q_PROPERTY(QPoint angleDelta READ angleDelta)
    Q_PROPERTY(Qt::ScrollPhase phase READ phase)
    Q_PROPERTY(bool inverted READ inverted)

    Q_EVENT_DISABLE_COPY(QWheelEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    enum { DefaultDeltasPerStep = 120 }

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(ref const(QPointF) pos, ref const(QPointF) globalPos, QPoint pixelDelta, QPoint angleDelta,
                    /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, /+ Qt:: +/qt.core.namespace.ScrollPhase phase,
                    bool inverted, /+ Qt:: +/qt.core.namespace.MouseEventSource source = /+ Qt:: +/qt.core.namespace.MouseEventSource.MouseEventNotSynthesized,
                    const(QPointingDevice) device = QPointingDevice.primaryPointingDevice());
    }));
    ~this();

    override QWheelEvent clone() const {
        return cpp_new_copy!QWheelEvent(cast() this);
    }

    pragma(inline, true) final QPoint pixelDelta() const { return m_pixelDelta; }
    pragma(inline, true) final QPoint angleDelta() const { return m_angleDelta; }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.ScrollPhase phase() const { return cast(/+ Qt:: +/qt.core.namespace.ScrollPhase) (m_phase); }
    pragma(inline, true) final bool inverted() const { return (m_invertedScrolling) != 0; }
    pragma(inline, true) final bool isInverted() const { return (m_invertedScrolling) != 0; }
    pragma(inline, true) final bool hasPixelDelta() const { return !m_pixelDelta.isNull(); }

    override bool isBeginEvent() const;
    override bool isUpdateEvent() const;
    override bool isEndEvent() const;
    final /+ Qt:: +/qt.core.namespace.MouseEventSource source() const { return /+ Qt:: +/qt.core.namespace.MouseEventSource(m_source); }

protected:
    QPoint m_pixelDelta;
    QPoint m_angleDelta;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #endif

#if QT_CONFIG(tabletevent) +/
/// Binding for C++ class [QTabletEvent](https://doc.qt.io/qt-6/qtabletevent.html).
class /+ Q_GUI_EXPORT +/ QTabletEvent : QSinglePointEvent
{
    /+ Q_EVENT_DISABLE_COPY(QTabletEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(Type t, const(QPointingDevice) device,
                     ref const(QPointF) pos, ref const(QPointF) globalPos,
                     qreal pressure, float xTilt, float yTilt,
                     float tangentialPressure, qreal rotation, float z,
                     /+ Qt:: +/qt.core.namespace.KeyboardModifiers keyState,
                     /+ Qt:: +/qt.core.namespace.MouseButton button, /+ Qt:: +/qt.core.namespace.MouseButtons buttons);
    }));
    ~this();

    override QTabletEvent clone() const {
        return cpp_new_copy!QTabletEvent(cast() this);
    }

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
        pragma(inline, true) final QPoint pos() const { return position().toPoint(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition()") +/
        pragma(inline, true) final QPoint globalPos() const { return globalPosition().toPoint(); }

    /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
        pragma(inline, true) final const(QPointF) posF() const { return position(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition()") +/
        pragma(inline, true) final const(QPointF) globalPosF() const { return globalPosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use position().x()") +/
        pragma(inline, true) final int x() const { return qRound(position().x()); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use position().y()") +/
        pragma(inline, true) final int y() const { return qRound(position().y()); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition().x()") +/
        pragma(inline, true) final int globalX() const { return qRound(globalPosition().x()); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition().y()") +/
        pragma(inline, true) final int globalY() const { return qRound(globalPosition().y()); }
    /+ QT_DEPRECATED_VERSION_X_6_0("use globalPosition().x()") +/
        pragma(inline, true) final qreal hiResGlobalX() const { return globalPosition().x(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("use globalPosition().y()") +/
        pragma(inline, true) final qreal hiResGlobalY() const { return globalPosition().y(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("use pointingDevice().uniqueId()") +/
        pragma(inline, true) final qint64 uniqueId() const { return pointingDevice() ? pointingDevice().uniqueId().numericId() : -1; }
/+ #endif +/
    pragma(inline, true) final qreal pressure() const { (mixin(Q_ASSERT(q{!QPointerEvent.points().isEmpty()}))); return points().first().pressure(); }
    pragma(inline, true) final qreal rotation() const { (mixin(Q_ASSERT(q{!QPointerEvent.points().isEmpty()}))); return points().first().rotation(); }
    pragma(inline, true) final qreal z() const { return m_z; }
    pragma(inline, true) final qreal tangentialPressure() const { return m_tangential; }
    pragma(inline, true) final qreal xTilt() const { return m_xTilt; }
    pragma(inline, true) final qreal yTilt() const { return m_yTilt; }

protected:
    float m_tangential;
    float m_xTilt;
    float m_yTilt;
    float m_z;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #endif // QT_CONFIG(tabletevent)

#if QT_CONFIG(gestures) +/
/// Binding for C++ class [QNativeGestureEvent](https://doc.qt.io/qt-6/qnativegestureevent.html).
class /+ Q_GUI_EXPORT +/ QNativeGestureEvent : QSinglePointEvent
{
    /+ Q_EVENT_DISABLE_COPY(QNativeGestureEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
/+ #if QT_DEPRECATED_SINCE(6, 2) +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_VERSION_X_6_2("Use the other constructor") +/this(/+ Qt:: +/qt.core.namespace.NativeGestureType type, const(QPointingDevice) dev, ref const(QPointF) localPos, ref const(QPointF) scenePos,
                            ref const(QPointF) globalPos, qreal value, quint64 sequenceId, quint64 intArgument);
    }));
/+ #endif +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(/+ Qt:: +/qt.core.namespace.NativeGestureType type, const(QPointingDevice) dev, int fingerCount,
                            ref const(QPointF) localPos, ref const(QPointF) scenePos, ref const(QPointF) globalPos,
                            qreal value, ref const(QPointF) delta, quint64 sequenceId = ulong.max);
    }));
    ~this();

    override QNativeGestureEvent clone() const {
        return cpp_new_copy!QNativeGestureEvent(cast() this);
    }

    final /+ Qt:: +/qt.core.namespace.NativeGestureType gestureType() const { return m_gestureType; }
    final int fingerCount() const { return m_fingerCount; }
    final qreal value() const { return m_realValue; }
    final QPointF delta() const {
/+ #if QT_VERSION < QT_VERSION_CHECK(7, 0, 0) +/
        return m_delta.toPointF();
/+ #else
        return m_delta;
#endif +/
    }

/+ #if QT_DEPRECATED_SINCE(6, 0)
#ifndef QT_NO_INTEGER_EVENT_COORDINATES +/
    version (QT_NO_INTEGER_EVENT_COORDINATES) {} else
    {
        /+ QT_DEPRECATED_VERSION_X_6_0("Use position().toPoint()") +/
            pragma(inline, true) final const(QPoint) pos() const { return position().toPoint(); }
        /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition().toPoint()") +/
            pragma(inline, true) final const(QPoint) globalPos() const { return globalPosition().toPoint(); }
    }
/+ #endif +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
        final QPointF localPos() const { return position(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use scenePosition()") +/
        final QPointF windowPos() const { return scenePosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition()") +/
        final QPointF screenPos() const { return globalPosition(); }
/+ #endif +/

protected:
    quint64 m_sequenceId;
/+ #if QT_VERSION < QT_VERSION_CHECK(7, 0, 0) +/
    QVector2D m_delta;
/+ #else
    QPointF m_delta;
#endif +/
    qreal m_realValue;
    /+ Qt:: +/qt.core.namespace.NativeGestureType m_gestureType;
    /+ quint32 m_fingerCount : 4; +/
    uint bitfieldData_m_fingerCount;
    quint32 m_fingerCount() const
    {
        return (bitfieldData_m_fingerCount >> 0) & 0xf;
    }
    quint32 m_fingerCount(quint32 value)
    {
        bitfieldData_m_fingerCount = (bitfieldData_m_fingerCount & ~0xf) | ((value & 0xf) << 0);
        return value;
    }
    /+ quint32 m_reserved : 28; +/
    quint32 m_reserved() const
    {
        return (bitfieldData_m_fingerCount >> 4) & 0xfffffff;
    }
    quint32 m_reserved(quint32 value)
    {
        bitfieldData_m_fingerCount = (bitfieldData_m_fingerCount & ~0xfffffff0) | ((value & 0xfffffff) << 4);
        return value;
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #endif +/ // QT_CONFIG(gestures)

/// Binding for C++ class [QKeyEvent](https://doc.qt.io/qt-6/qkeyevent.html).
class /+ Q_GUI_EXPORT +/ QKeyEvent : QInputEvent
{
    /+ Q_EVENT_DISABLE_COPY(QKeyEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    this(Type type, int key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, ref const(QString) text = globalInitVar!QString,
                  bool autorep = false, quint16 count = 1);
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(Type type, int key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers,
                  quint32 nativeScanCode, quint32 nativeVirtualKey, quint32 nativeModifiers,
                  ref const(QString) text = globalInitVar!QString, bool autorep = false, quint16 count = 1,
                  const(QInputDevice) device = QInputDevice.primaryKeyboard());
    }));
    ~this();

    override QKeyEvent clone() const {
        return cpp_new_copy!QKeyEvent(cast() this);
    }

    final int key() const { return m_key; }
/+ #if QT_CONFIG(shortcut) +/
    final bool matches(QKeySequence.StandardKey key) const;
/+ #endif +/
    //final /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers() const;
    final QKeyCombination keyCombination() const
    {
        return QKeyCombination(modifiers(), cast(/+ Qt:: +/qt.core.namespace.Key) (m_key));
    }
    pragma(inline, true) final QString text() /*const*/ { return m_text; }
    pragma(inline, true) final bool isAutoRepeat() const { return (m_autoRepeat) != 0; }
    pragma(inline, true) final int count() const { return int(m_count); }

    pragma(inline, true) final quint32 nativeScanCode() const { return m_scanCode; }
    pragma(inline, true) final quint32 nativeVirtualKey() const { return m_virtualKey; }
    pragma(inline, true) final quint32 nativeModifiers() const { return m_nativeModifiers; }

/+ #if QT_CONFIG(shortcut) +/
    /+ friend inline bool operator==(QKeyEvent *e, QKeySequence::StandardKey key)
    { return (e ? e->matches(key) : false); } +/
    /+ friend inline bool operator==(QKeySequence::StandardKey key, QKeyEvent *e)
    { return (e ? e->matches(key) : false); } +/
/+ #endif +/ // QT_CONFIG(shortcut)

protected:
    QString m_text;
    int m_key;
    quint32 m_scanCode;
    quint32 m_virtualKey;
    quint32 m_nativeModifiers;
    /+ quint16 m_count      : 15; +/
    ushort bitfieldData_m_count;
    quint16 m_count() const
    {
        return (bitfieldData_m_count >> 0) & 0x7fff;
    }
    quint16 m_count(quint16 value)
    {
        bitfieldData_m_count = (bitfieldData_m_count & ~0x7fff) | ((value & 0x7fff) << 0);
        return value;
    }
    /+ quint16 m_autoRepeat : 1; +/
    quint16 m_autoRepeat() const
    {
        return (bitfieldData_m_count >> 15) & 0x1;
    }
    quint16 m_autoRepeat(quint16 value)
    {
        bitfieldData_m_count = (bitfieldData_m_count & ~0x8000) | ((value & 0x1) << 15);
        return value;
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QFocusEvent](https://doc.qt.io/qt-6/qfocusevent.html).
class /+ Q_GUI_EXPORT +/ QFocusEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QFocusEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    /+ explicit +/this(Type type, /+ Qt:: +/qt.core.namespace.FocusReason reason=/+ Qt:: +/qt.core.namespace.FocusReason.OtherFocusReason);
    ~this();

    override QFocusEvent clone() const {
        return cpp_new_copy!QFocusEvent(cast() this);
    }

    pragma(inline, true) final bool gotFocus() const { return type() == Type.FocusIn; }
    pragma(inline, true) final bool lostFocus() const { return type() == Type.FocusOut; }

    final /+ Qt:: +/qt.core.namespace.FocusReason reason() const;

private:
    /+ Qt:: +/qt.core.namespace.FocusReason m_reason;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QPaintEvent](https://doc.qt.io/qt-6/qpaintevent.html).
class /+ Q_GUI_EXPORT +/ QPaintEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QPaintEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    /+ explicit +/this(ref const(QRegion) paintRegion);
    /+ explicit +/this(ref const(QRect) paintRect);
    ~this();

    override QPaintEvent clone() const {
        return cpp_new_copy!QPaintEvent(cast() this);
    }

    pragma(inline, true) final ref const(QRect) rect() const { return m_rect; }
    pragma(inline, true) final ref const(QRegion) region() const { return m_region; }

protected:
    QRect m_rect;
    QRegion m_region;
    bool m_erased;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QMoveEvent](https://doc.qt.io/qt-6/qmoveevent.html).
class /+ Q_GUI_EXPORT +/ QMoveEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QMoveEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    this(ref const(QPoint) pos, ref const(QPoint) oldPos);
    ~this();

    override QMoveEvent clone() const {
        return cpp_new_copy!QMoveEvent(cast() this);
    }

    pragma(inline, true) final ref const(QPoint) pos() const { return m_pos; }
    pragma(inline, true) final ref const(QPoint) oldPos() const { return m_oldPos;}
protected:
    QPoint m_pos; QPoint m_oldPos;
    /+ friend class QApplication; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QExposeEvent](https://doc.qt.io/qt-6/qexposeevent.html).
class /+ Q_GUI_EXPORT +/ QExposeEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QExposeEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    /+ explicit +/this(ref const(QRegion) m_region);
    ~this();

    override QExposeEvent clone() const {
        return cpp_new_copy!QExposeEvent(cast() this);
    }

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Handle QPaintEvent instead") +/
        pragma(inline, true) final ref const(QRegion) region() const { return m_region; }
/+ #endif +/

protected:
    QRegion m_region;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QPlatformSurfaceEvent](https://doc.qt.io/qt-6/qplatformsurfaceevent.html).
class /+ Q_GUI_EXPORT +/ QPlatformSurfaceEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QPlatformSurfaceEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    enum SurfaceEventType {
        SurfaceCreated,
        SurfaceAboutToBeDestroyed
    }

    /+ explicit +/this(SurfaceEventType surfaceEventType);
    ~this();

    override QPlatformSurfaceEvent clone() const {
        return cpp_new_copy!QPlatformSurfaceEvent(cast() this);
    }

    pragma(inline, true) final SurfaceEventType surfaceEventType() const { return m_surfaceEventType; }

protected:
    SurfaceEventType m_surfaceEventType;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QResizeEvent](https://doc.qt.io/qt-6/qresizeevent.html).
class /+ Q_GUI_EXPORT +/ QResizeEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QResizeEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    this(ref const(QSize) size, ref const(QSize) oldSize);
    ~this();

    override QResizeEvent clone() const {
        return cpp_new_copy!QResizeEvent(cast() this);
    }

    pragma(inline, true) final ref const(QSize) size() const { return m_size; }
    pragma(inline, true) final ref const(QSize) oldSize()const { return m_oldSize;}
protected:
    QSize m_size; QSize m_oldSize;
    /+ friend class QApplication; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QCloseEvent](https://doc.qt.io/qt-6/qcloseevent.html).
class /+ Q_GUI_EXPORT +/ QCloseEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QCloseEvent) +/protected:/+ ; +/
public:
    this();
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QIconDragEvent](https://doc.qt.io/qt-6/qicondragevent.html).
class /+ Q_GUI_EXPORT +/ QIconDragEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QIconDragEvent) +/protected:/+ ; +/
public:
    this();
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QShowEvent](https://doc.qt.io/qt-6/qshowevent.html).
class /+ Q_GUI_EXPORT +/ QShowEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QShowEvent) +/protected:/+ ; +/
public:
    this();
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QHideEvent](https://doc.qt.io/qt-6/qhideevent.html).
class /+ Q_GUI_EXPORT +/ QHideEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QHideEvent) +/protected:/+ ; +/
public:
    this();
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

version (QT_NO_CONTEXTMENU) {} else
{
/// Binding for C++ class [QContextMenuEvent](https://doc.qt.io/qt-6/qcontextmenuevent.html).
class /+ Q_GUI_EXPORT +/ QContextMenuEvent : QInputEvent
{
    /+ Q_EVENT_DISABLE_COPY(QContextMenuEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    enum Reason { Mouse, Keyboard, Other }

    this(Reason reason, ref const(QPoint) pos, ref const(QPoint) globalPos,
                          /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier);
    this(Reason reason, ref const(QPoint) pos);
    ~this();

    override QContextMenuEvent clone() const {
        return cpp_new_copy!QContextMenuEvent(cast() this);
    }

    pragma(inline, true) final int x() const { return m_pos.x(); }
    pragma(inline, true) final int y() const { return m_pos.y(); }
    pragma(inline, true) final int globalX() const { return m_globalPos.x(); }
    pragma(inline, true) final int globalY() const { return m_globalPos.y(); }

    pragma(inline, true) final ref const(QPoint) pos() const { return m_pos; }
    pragma(inline, true) final ref const(QPoint) globalPos() const { return m_globalPos; }

    pragma(inline, true) final Reason reason() const { return cast(Reason) (m_reason); }

protected:
    QPoint m_pos;
    QPoint m_globalPos;
    /+ uint m_reason : 8; +/
    ubyte bitfieldData_m_reason;
    uint m_reason() const
    {
        return (bitfieldData_m_reason >> 0) & 0xff;
    }
    uint m_reason(uint value)
    {
        bitfieldData_m_reason = (bitfieldData_m_reason & ~0xff) | ((value & 0xff) << 0);
        return value;
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
}

version (QT_NO_INPUTMETHOD) {} else
{
/// Binding for C++ class [QInputMethodEvent](https://doc.qt.io/qt-6/qinputmethodevent.html).
class /+ Q_GUI_EXPORT +/ QInputMethodEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QInputMethodEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    enum AttributeType {
       TextFormat,
       Cursor,
       Language,
       Ruby,
       Selection
    }
    /// Binding for C++ class [QInputMethodEvent::Attribute](https://doc.qt.io/qt-6/qinputmethodevent-attribute.html).
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

        this(ref Attribute other)
        {
            this.tupleof = (cast(typeof(this))other).tupleof;
        }
    }
    this();
//    this(ref const(QString) preeditText, ref const(QList!(Attribute)) /+ QList<Attribute> +/ attributes);
    ~this();

    override QInputMethodEvent clone() const {
        return cpp_new_copy!QInputMethodEvent(cast() this);
    }

    final void setCommitString(ref const(QString) commitString, int replaceFrom = 0, int replaceLength = 0);
    pragma(inline, true) final ref const(QList!(Attribute)) attributes() const { return m_attributes; }
    pragma(inline, true) final ref const(QString) preeditString() const { return m_preedit; }

    pragma(inline, true) final ref const(QString) commitString() const { return m_commit; }
    pragma(inline, true) final int replacementStart() const { return m_replacementStart; }
    pragma(inline, true) final int replacementLength() const { return m_replacementLength; }

    /+ inline friend bool operator==(const QInputMethodEvent::Attribute &lhs,
                                  const QInputMethodEvent::Attribute &rhs)
    {
        return lhs.type == rhs.type && lhs.start == rhs.start
                && lhs.length == rhs.length && lhs.value == rhs.value;
    } +/

    /+ inline friend bool operator!=(const QInputMethodEvent::Attribute &lhs,
                                  const QInputMethodEvent::Attribute &rhs)
    {
        return !(lhs == rhs);
    } +/

private:
    QString m_preedit;
    QString m_commit;
    QList!(Attribute) m_attributes;
    int m_replacementStart;
    int m_replacementLength;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QInputMethodEvent::Attribute, Q_RELOCATABLE_TYPE); +/

/// Binding for C++ class [QInputMethodQueryEvent](https://doc.qt.io/qt-6/qinputmethodqueryevent.html).
class /+ Q_GUI_EXPORT +/ QInputMethodQueryEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QInputMethodQueryEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.InputMethodQueries queries);
    ~this();

    override QInputMethodQueryEvent clone() const {
        return cpp_new_copy!QInputMethodQueryEvent(cast() this);
    }

    final /+ Qt:: +/qt.core.namespace.InputMethodQueries queries() const { return m_queries; }

    final void setValue(/+ Qt:: +/qt.core.namespace.InputMethodQuery query, ref const(QVariant) value);
    final QVariant value(/+ Qt:: +/qt.core.namespace.InputMethodQuery query) const;
private:
    /+ Qt:: +/qt.core.namespace.InputMethodQueries m_queries;
    struct QueryPair {
        /+ Qt:: +/qt.core.namespace.InputMethodQuery query;
        QVariant value;

        this(ref QueryPair other)
        {
            this.tupleof = (cast(typeof(this))other).tupleof;
        }
    }
    /+ friend QTypeInfo<QueryPair>; +/
    QList!(QueryPair) m_values;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QInputMethodQueryEvent::QueryPair, Q_RELOCATABLE_TYPE); +/

}

/+ #if QT_CONFIG(draganddrop) +/


/// Binding for C++ class [QDropEvent](https://doc.qt.io/qt-6/qdropevent.html).
class /+ Q_GUI_EXPORT +/ QDropEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QDropEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(ref const(QPointF) pos, /+ Qt:: +/qt.core.namespace.DropActions actions, const(QMimeData) data,
                   /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, Type type = Type.Drop);
    }));
    ~this();

    override QDropEvent clone() const {
        return cpp_new_copy!QDropEvent(cast() this);
    }

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use position().toPoint()") +/
        pragma(inline, true) final QPoint pos() const { return position().toPoint(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
        pragma(inline, true) final QPointF posF() const { return position(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use buttons()") +/
        pragma(inline, true) final /+ Qt:: +/qt.core.namespace.MouseButtons mouseButtons() const { return buttons(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use modifiers()") +/
        pragma(inline, true) final /+ Qt:: +/qt.core.namespace.KeyboardModifiers keyboardModifiers() const { return modifiers(); }
/+ #endif +/ // QT_DEPRECATED_SINCE(6, 0)

    final QPointF position() const { return m_pos; }
    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.MouseButtons buttons() const { return m_mouseState; }
    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers() const { return m_modState; }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.DropActions possibleActions() const { return m_actions; }
    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.DropAction proposedAction() const { return m_defaultAction; }
    pragma(inline, true) final void acceptProposedAction() { m_dropAction = m_defaultAction; accept(); }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.DropAction dropAction() const { return m_dropAction; }
    final void setDropAction(/+ Qt:: +/qt.core.namespace.DropAction action);

    final QObject source() const;
    pragma(inline, true) final const(QMimeData) mimeData() const { return m_data; }

protected:
    /+ friend class QApplication; +/
    QPointF m_pos;
    /+ Qt:: +/qt.core.namespace.MouseButtons m_mouseState;
    /+ Qt:: +/qt.core.namespace.KeyboardModifiers m_modState;
    /+ Qt:: +/qt.core.namespace.DropActions m_actions;
    /+ Qt:: +/qt.core.namespace.DropAction m_dropAction;
    /+ Qt:: +/qt.core.namespace.DropAction m_defaultAction;
    const(QMimeData) m_data;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QDragMoveEvent](https://doc.qt.io/qt-6/qdragmoveevent.html).
class /+ Q_GUI_EXPORT +/ QDragMoveEvent : QDropEvent
{
    /+ Q_EVENT_DISABLE_COPY(QDragMoveEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(ref const(QPoint) pos, /+ Qt:: +/qt.core.namespace.DropActions actions, const(QMimeData) data,
                       /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers, Type type = Type.DragMove);
    }));
    ~this();

    override QDragMoveEvent clone() const {
        return cpp_new_copy!QDragMoveEvent(cast() this);
    }

    pragma(inline, true) final QRect answerRect() const { return m_rect; }

//    pragma(inline, true) final void accept() { QDropEvent.accept(); }
//    pragma(inline, true) final void ignore() { QDropEvent.ignore(); }

/+    pragma(inline, true) final void accept(ref const(QRect)  r) { accept(); m_rect = r; }
    pragma(inline, true) final void ignore(ref const(QRect)  r) { ignore(); m_rect = r; }+/

protected:
    QRect m_rect;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QDragEnterEvent](https://doc.qt.io/qt-6/qdragenterevent.html).
class /+ Q_GUI_EXPORT +/ QDragEnterEvent : QDragMoveEvent
{
    /+ Q_EVENT_DISABLE_COPY(QDragEnterEvent) +/protected:/+ ; +/
public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(ref const(QPoint) pos, /+ Qt:: +/qt.core.namespace.DropActions actions, const(QMimeData) data,
                        /+ Qt:: +/qt.core.namespace.MouseButtons buttons, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers);
    }));
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QDragLeaveEvent](https://doc.qt.io/qt-6/qdragleaveevent.html).
class /+ Q_GUI_EXPORT +/ QDragLeaveEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QDragLeaveEvent) +/protected:/+ ; +/
public:
    this();
    ~this();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #endif +/ // QT_CONFIG(draganddrop)


/// Binding for C++ class [QHelpEvent](https://doc.qt.io/qt-6/qhelpevent.html).
class /+ Q_GUI_EXPORT +/ QHelpEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QHelpEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    this(Type type, ref const(QPoint) pos, ref const(QPoint) globalPos);
    ~this();

    override QHelpEvent clone() const {
        return cpp_new_copy!QHelpEvent(cast() this);
    }

    pragma(inline, true) final int x() const { return m_pos.x(); }
    pragma(inline, true) final int y() const { return m_pos.y(); }
    pragma(inline, true) final int globalX() const { return m_globalPos.x(); }
    pragma(inline, true) final int globalY() const { return m_globalPos.y(); }

    pragma(inline, true) final ref const(QPoint) pos()  const { return m_pos; }
    pragma(inline, true) final ref const(QPoint) globalPos() const { return m_globalPos; }

private:
    QPoint m_pos;
    QPoint m_globalPos;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

version (QT_NO_STATUSTIP) {} else
{
/// Binding for C++ class [QStatusTipEvent](https://doc.qt.io/qt-6/qstatustipevent.html).
class /+ Q_GUI_EXPORT +/ QStatusTipEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QStatusTipEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    /+ explicit +/this(ref const(QString) tip);
    ~this();

    override QStatusTipEvent clone() const {
        return cpp_new_copy!QStatusTipEvent(cast() this);
    }

    pragma(inline, true) final QString tip() /*const*/ { return m_tip; }
private:
    QString m_tip;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
}

/+ #if QT_CONFIG(whatsthis) +/
/// Binding for C++ class [QWhatsThisClickedEvent](https://doc.qt.io/qt-6/qwhatsthisclickedevent.html).
class /+ Q_GUI_EXPORT +/ QWhatsThisClickedEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QWhatsThisClickedEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    /+ explicit +/this(ref const(QString) href);
    ~this();

    override QWhatsThisClickedEvent clone() const {
        return cpp_new_copy!QWhatsThisClickedEvent(cast() this);
    }

    pragma(inline, true) final QString href() /*const*/ { return m_href; }
private:
    QString m_href;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #endif

#if QT_CONFIG(action) +/
/// Binding for C++ class [QActionEvent](https://doc.qt.io/qt-6/qactionevent.html).
class /+ Q_GUI_EXPORT +/ QActionEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QActionEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    this(int type, QAction action, QAction before = null);
    ~this();

    override QActionEvent clone() const {
        return cpp_new_copy!QActionEvent(cast() this);
    }

    pragma(inline, true) final QAction action() /*const*/ { return m_action; }
    pragma(inline, true) final QAction before() /*const*/ { return m_before; }
private:
    QAction m_action;
    QAction m_before;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #endif +/ // QT_CONFIG(action)

/// Binding for C++ class [QFileOpenEvent](https://doc.qt.io/qt-6/qfileopenevent.html).
class /+ Q_GUI_EXPORT +/ QFileOpenEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QFileOpenEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    /+ explicit +/this(ref const(QString) file);
    /+ explicit +/this(ref const(QUrl) url);
    ~this();

    override QFileOpenEvent clone() const {
        return cpp_new_copy!QFileOpenEvent(cast() this);
    }

    pragma(inline, true) final QString file() /*const*/ { return m_file; }
    final QUrl url() const { return m_url; }
    // final bool openFile(QFile &file, QIODevice.OpenMode flags) const;
private:
    QString m_file;
    QUrl m_url;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

version (QT_NO_TOOLBAR) {} else
{
class /+ Q_GUI_EXPORT +/ QToolBarChangeEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QToolBarChangeEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    /+ explicit +/this(bool t);
    ~this();

    override QToolBarChangeEvent clone() const {
        return cpp_new_copy!QToolBarChangeEvent(cast() this);
    }

    pragma(inline, true) final bool toggle() const { return m_toggle; }
private:
    bool m_toggle;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
}

/+ #if QT_CONFIG(shortcut) +/
/// Binding for C++ class [QShortcutEvent](https://doc.qt.io/qt-6/qshortcutevent.html).
class /+ Q_GUI_EXPORT +/ QShortcutEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QShortcutEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    this(ref const(QKeySequence) key, int id, bool ambiguous = false);
    ~this();

    override QShortcutEvent clone() const {
        return cpp_new_copy!QShortcutEvent(cast() this);
    }

    pragma(inline, true) final ref const(QKeySequence) key() const { return m_sequence; }
    pragma(inline, true) final int shortcutId() const { return m_shortcutId; }
    pragma(inline, true) final bool isAmbiguous() const { return m_ambiguous; }
protected:
    QKeySequence m_sequence;
    int  m_shortcutId;
    bool m_ambiguous;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #endif +/

/// Binding for C++ class [QWindowStateChangeEvent](https://doc.qt.io/qt-6/qwindowstatechangeevent.html).
class /+ Q_GUI_EXPORT +/ QWindowStateChangeEvent: QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QWindowStateChangeEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.WindowStates oldState, bool isOverride = false);
    ~this();

    override QWindowStateChangeEvent clone() const {
        return cpp_new_copy!QWindowStateChangeEvent(cast() this);
    }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.WindowStates oldState() const { return m_oldStates; }
    final bool isOverride() const;

private:
    /+ Qt:: +/qt.core.namespace.WindowStates m_oldStates;
    bool m_override;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QEvent *);
#endif +/

/// Binding for C++ class [QTouchEvent](https://doc.qt.io/qt-6/qtouchevent.html).
class /+ Q_GUI_EXPORT +/ QTouchEvent : QPointerEvent
{
    /+ Q_EVENT_DISABLE_COPY(QTouchEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    alias TouchPoint = QEventPoint; // source compat

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ explicit +/this(QEvent.Type eventType,
                             const(QPointingDevice) device = null,
                             /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier,
                             ref const(QList!(QEventPoint)) touchPoints = globalInitVar!(QList!(QEventPoint)));
    }));
/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_VERSION_X_6_0("Use another constructor") +/
        /+ explicit +/this(QEvent.Type eventType,
                             const(QPointingDevice) device,
                             /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers,
                             QEventPoint.States touchPointStates,
                             ref const(QList!(QEventPoint)) touchPoints = globalInitVar!(QList!(QEventPoint)));
    }));
/+ #endif +/
    ~this();

    override QTouchEvent clone() const {
        return cpp_new_copy!QTouchEvent(cast() this);
    }

    pragma(inline, true) final QObject target() /*const*/ { return m_target; }
    pragma(inline, true) final QEventPoint.States touchPointStates() const { return m_touchPointStates; }
/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use points()") +/
        final ref const(QList!(QEventPoint)) touchPoints() const { return points(); }
/+ #endif +/
    override bool isBeginEvent() const;
    override bool isUpdateEvent() const;
    override bool isEndEvent() const;

protected:
    QObject m_target = null;
    QEventPoint.States m_touchPointStates = QEventPoint.State.Unknown;
    /+ quint32 m_reserved : 24; +/
    uint bitfieldData_m_reserved;
    quint32 m_reserved() const
    {
        return (bitfieldData_m_reserved >> 0) & 0xffffff;
    }
    quint32 m_reserved(quint32 value)
    {
        bitfieldData_m_reserved = (bitfieldData_m_reserved & ~0xffffff) | ((value & 0xffffff) << 0);
        return value;
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QScrollPrepareEvent](https://doc.qt.io/qt-6/qscrollprepareevent.html).
class /+ Q_GUI_EXPORT +/ QScrollPrepareEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QScrollPrepareEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    /+ explicit +/this(ref const(QPointF) startPos);
    ~this();

    override QScrollPrepareEvent clone() const {
        return cpp_new_copy!QScrollPrepareEvent(cast() this);
    }

    final QPointF startPos() const { return m_startPos; }

    final QSizeF viewportSize() const { return m_viewportSize; }
    final QRectF contentPosRange() const { return m_contentPosRange; }
    final QPointF contentPos() const { return m_contentPos; }

    final void setViewportSize(ref const(QSizeF) size);
    final void setContentPosRange(ref const(QRectF) rect);
    final void setContentPos(ref const(QPointF) pos);

private:
    QRectF m_contentPosRange;
    QSizeF m_viewportSize;
    QPointF m_startPos;
    QPointF m_contentPos;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QScrollEvent](https://doc.qt.io/qt-6/qscrollevent.html).
class /+ Q_GUI_EXPORT +/ QScrollEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QScrollEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    enum ScrollState
    {
        ScrollStarted,
        ScrollUpdated,
        ScrollFinished
    }

    this(ref const(QPointF) contentPos, ref const(QPointF) overshoot, ScrollState scrollState);
    ~this();

    override QScrollEvent clone() const {
        return cpp_new_copy!QScrollEvent(cast() this);
    }

    final QPointF contentPos() const { return m_contentPos; }
    final QPointF overshootDistance() const { return m_overshoot; }
    final ScrollState scrollState() const { return m_state; }

private:
    QPointF m_contentPos;
    QPointF m_overshoot;
    ScrollState m_state;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

class /+ Q_GUI_EXPORT +/ QScreenOrientationChangeEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QScreenOrientationChangeEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    this(QScreen screen, /+ Qt:: +/qt.core.namespace.ScreenOrientation orientation);
    ~this();

    override QScreenOrientationChangeEvent clone() const {
        return cpp_new_copy!QScreenOrientationChangeEvent(cast() this);
    }

    final QScreen screen() /*const*/ { return m_screen; }
    final /+ Qt:: +/qt.core.namespace.ScreenOrientation orientation() const { return m_orientation; }

private:
    QScreen m_screen;
    /+ Qt:: +/qt.core.namespace.ScreenOrientation m_orientation;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

class /+ Q_GUI_EXPORT +/ QApplicationStateChangeEvent : QEvent
{
    /+ Q_EVENT_DISABLE_COPY(QApplicationStateChangeEvent) +/protected:/+ ; +/
    this(const typeof(this) other)
    {
        super(other);
        this.tupleof = (cast(typeof(this))other).tupleof;
    }
public:
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.ApplicationState state);

    override QApplicationStateChangeEvent clone() const {
        return cpp_new_copy!QApplicationStateChangeEvent(cast() this);
    }

    final /+ Qt:: +/qt.core.namespace.ApplicationState applicationState() const { return m_applicationState; }

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


