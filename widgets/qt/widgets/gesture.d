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
module qt.widgets.gesture;
extern(C++):

import qt.config;
import qt.helpers;
version (QT_NO_GESTURES) {} else
{
    import qt.core.coreevent;
    import qt.core.flags;
    import qt.core.global;
    import qt.core.list;
    import qt.core.map;
    import qt.core.metatype;
    import qt.core.namespace;
    import qt.core.object;
    import qt.core.point;
    import qt.widgets.widget;
}

version (QT_NO_GESTURES) {} else
{

/+ Q_DECLARE_METATYPE(Qt::GestureState)
Q_DECLARE_METATYPE(Qt::GestureType) +/



extern(C++, class) struct QGesturePrivate;
/// Binding for C++ class [QGesture](https://doc.qt.io/qt-6/qgesture.html).
class /+ Q_WIDGETS_EXPORT +/ QGesture : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QGesture) +/

    /+ Q_PROPERTY(Qt::GestureState state READ state)
    Q_PROPERTY(Qt::GestureType gestureType READ gestureType)
    Q_PROPERTY(QGesture::GestureCancelPolicy gestureCancelPolicy READ gestureCancelPolicy
               WRITE setGestureCancelPolicy)
    Q_PROPERTY(QPointF hotSpot READ hotSpot WRITE setHotSpot RESET unsetHotSpot)
    Q_PROPERTY(bool hasHotSpot READ hasHotSpot) +/

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    final /+ Qt:: +/qt.core.namespace.GestureType gestureType() const;

    final /+ Qt:: +/qt.core.namespace.GestureState state() const;

    final QPointF hotSpot() const;
    final void setHotSpot(ref const(QPointF) value);
    final bool hasHotSpot() const;
    final void unsetHotSpot();

    enum GestureCancelPolicy {
        CancelNone = 0,
        CancelAllInContext
    }

    final void setGestureCancelPolicy(GestureCancelPolicy policy);
    final GestureCancelPolicy gestureCancelPolicy() const;

protected:
    this(ref QGesturePrivate dd, QObject parent);

private:
    /+ friend class QGestureEvent; +/
    /+ friend class QGestureRecognizer; +/
    /+ friend class QGestureManager; +/
    /+ friend class QGraphicsScenePrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QPanGesturePrivate;
/// Binding for C++ class [QPanGesture](https://doc.qt.io/qt-6/qpangesture.html).
class /+ Q_WIDGETS_EXPORT +/ QPanGesture : QGesture
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QPanGesture) +/

    /+ Q_PROPERTY(QPointF lastOffset READ lastOffset WRITE setLastOffset)
    Q_PROPERTY(QPointF offset READ offset WRITE setOffset)
    Q_PROPERTY(QPointF delta READ delta STORED false)
    Q_PROPERTY(qreal acceleration READ acceleration WRITE setAcceleration)
    Q_PRIVATE_PROPERTY(QPanGesture::d_func(), qreal horizontalVelocity READ horizontalVelocity WRITE setHorizontalVelocity)
    Q_PRIVATE_PROPERTY(QPanGesture::d_func(), qreal verticalVelocity READ verticalVelocity WRITE setVerticalVelocity) +/

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    final QPointF lastOffset() const;
    final QPointF offset() const;
    final QPointF delta() const;
    final qreal acceleration() const;

    final void setLastOffset(ref const(QPointF) value);
    final void setOffset(ref const(QPointF) value);
    final void setAcceleration(qreal value);

    /+ friend class QPanGestureRecognizer; +/
    /+ friend class QWinNativePanGestureRecognizer; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QPinchGesturePrivate;
/// Binding for C++ class [QPinchGesture](https://doc.qt.io/qt-6/qpinchgesture.html).
class /+ Q_WIDGETS_EXPORT +/ QPinchGesture : QGesture
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QPinchGesture) +/

public:
    enum ChangeFlag {
        ScaleFactorChanged = 0x1,
        RotationAngleChanged = 0x2,
        CenterPointChanged = 0x4
    }
    /+ Q_ENUM(ChangeFlag) +/
    /+ Q_DECLARE_FLAGS(ChangeFlags, ChangeFlag) +/
alias ChangeFlags = QFlags!(ChangeFlag);    /+ Q_FLAG(ChangeFlags) +/

    /+ Q_PROPERTY(ChangeFlags totalChangeFlags READ totalChangeFlags WRITE setTotalChangeFlags)
    Q_PROPERTY(ChangeFlags changeFlags READ changeFlags WRITE setChangeFlags)

    Q_PROPERTY(qreal totalScaleFactor READ totalScaleFactor WRITE setTotalScaleFactor)
    Q_PROPERTY(qreal lastScaleFactor READ lastScaleFactor WRITE setLastScaleFactor)
    Q_PROPERTY(qreal scaleFactor READ scaleFactor WRITE setScaleFactor)

    Q_PROPERTY(qreal totalRotationAngle READ totalRotationAngle WRITE setTotalRotationAngle)
    Q_PROPERTY(qreal lastRotationAngle READ lastRotationAngle WRITE setLastRotationAngle)
    Q_PROPERTY(qreal rotationAngle READ rotationAngle WRITE setRotationAngle)

    Q_PROPERTY(QPointF startCenterPoint READ startCenterPoint WRITE setStartCenterPoint)
    Q_PROPERTY(QPointF lastCenterPoint READ lastCenterPoint WRITE setLastCenterPoint)
    Q_PROPERTY(QPointF centerPoint READ centerPoint WRITE setCenterPoint) +/

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    final ChangeFlags totalChangeFlags() const;
    final void setTotalChangeFlags(ChangeFlags value);

    final ChangeFlags changeFlags() const;
    final void setChangeFlags(ChangeFlags value);

    final QPointF startCenterPoint() const;
    final QPointF lastCenterPoint() const;
    final QPointF centerPoint() const;
    final void setStartCenterPoint(ref const(QPointF) value);
    final void setLastCenterPoint(ref const(QPointF) value);
    final void setCenterPoint(ref const(QPointF) value);

    final qreal totalScaleFactor() const;
    final qreal lastScaleFactor() const;
    final qreal scaleFactor() const;
    final void setTotalScaleFactor(qreal value);
    final void setLastScaleFactor(qreal value);
    final void setScaleFactor(qreal value);

    final qreal totalRotationAngle() const;
    final qreal lastRotationAngle() const;
    final qreal rotationAngle() const;
    final void setTotalRotationAngle(qreal value);
    final void setLastRotationAngle(qreal value);
    final void setRotationAngle(qreal value);

    /+ friend class QPinchGestureRecognizer; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QPinchGesture.ChangeFlags.enum_type) operator |(QPinchGesture.ChangeFlags.enum_type f1, QPinchGesture.ChangeFlags.enum_type f2)/+noexcept+/{return QFlags!(QPinchGesture.ChangeFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QPinchGesture.ChangeFlags.enum_type) operator |(QPinchGesture.ChangeFlags.enum_type f1, QFlags!(QPinchGesture.ChangeFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QPinchGesture.ChangeFlags.enum_type) operator &(QPinchGesture.ChangeFlags.enum_type f1, QPinchGesture.ChangeFlags.enum_type f2)/+noexcept+/{return QFlags!(QPinchGesture.ChangeFlags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QPinchGesture.ChangeFlags.enum_type) operator &(QPinchGesture.ChangeFlags.enum_type f1, QFlags!(QPinchGesture.ChangeFlags.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QPinchGesture.ChangeFlags.enum_type) operator ^(QPinchGesture.ChangeFlags.enum_type f1, QPinchGesture.ChangeFlags.enum_type f2)/+noexcept+/{return QFlags!(QPinchGesture.ChangeFlags.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QPinchGesture.ChangeFlags.enum_type) operator ^(QPinchGesture.ChangeFlags.enum_type f1, QFlags!(QPinchGesture.ChangeFlags.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QPinchGesture.ChangeFlags.enum_type f1, QPinchGesture.ChangeFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QPinchGesture.ChangeFlags.enum_type f1, QFlags!(QPinchGesture.ChangeFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QPinchGesture.ChangeFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QPinchGesture.ChangeFlags.enum_type f1, QPinchGesture.ChangeFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QPinchGesture.ChangeFlags.enum_type f1, QFlags!(QPinchGesture.ChangeFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QPinchGesture.ChangeFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QPinchGesture.ChangeFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QPinchGesture.ChangeFlags.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QPinchGesture.ChangeFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QPinchGesture.ChangeFlags.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QPinchGesture.ChangeFlags operator ~(QPinchGesture.ChangeFlags.enum_type e)/+noexcept+/{return~QPinchGesture.ChangeFlags(e);}+/
/+pragma(inline, true) void operator |(QPinchGesture.ChangeFlags.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QPinchGesture.ChangeFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QPinchGesture::ChangeFlags)

Q_DECLARE_METATYPE(QPinchGesture::ChangeFlags) +/


extern(C++, class) struct QSwipeGesturePrivate;
/// Binding for C++ class [QSwipeGesture](https://doc.qt.io/qt-6/qswipegesture.html).
class /+ Q_WIDGETS_EXPORT +/ QSwipeGesture : QGesture
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QSwipeGesture) +/

    /+ Q_PROPERTY(SwipeDirection horizontalDirection READ horizontalDirection STORED false)
    Q_PROPERTY(SwipeDirection verticalDirection READ verticalDirection STORED false)
    Q_PROPERTY(qreal swipeAngle READ swipeAngle WRITE setSwipeAngle)
    Q_PRIVATE_PROPERTY(QSwipeGesture::d_func(), qreal velocity READ velocity WRITE setVelocity) +/

public:
    enum SwipeDirection { NoDirection, Left, Right, Up, Down }
    /+ Q_ENUM(SwipeDirection) +/

    /+ explicit +/this(QObject parent = null);
    ~this();

    final SwipeDirection horizontalDirection() const;
    final SwipeDirection verticalDirection() const;

    final qreal swipeAngle() const;
    final void setSwipeAngle(qreal value);

    /+ friend class QSwipeGestureRecognizer; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QTapGesturePrivate;
/// Binding for C++ class [QTapGesture](https://doc.qt.io/qt-6/qtapgesture.html).
class /+ Q_WIDGETS_EXPORT +/ QTapGesture : QGesture
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QTapGesture) +/

    /+ Q_PROPERTY(QPointF position READ position WRITE setPosition) +/

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    final QPointF position() const;
    final void setPosition(ref const(QPointF) pos);

    /+ friend class QTapGestureRecognizer; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QTapAndHoldGesturePrivate;
/// Binding for C++ class [QTapAndHoldGesture](https://doc.qt.io/qt-6/qtapandholdgesture.html).
class /+ Q_WIDGETS_EXPORT +/ QTapAndHoldGesture : QGesture
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QTapAndHoldGesture) +/

    /+ Q_PROPERTY(QPointF position READ position WRITE setPosition) +/

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    final QPointF position() const;
    final void setPosition(ref const(QPointF) pos);

    static void setTimeout(int msecs);
    static int timeout();

    /+ friend class QTapAndHoldGestureRecognizer; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QGestureEventPrivate;
/+
/// Binding for C++ class [QGestureEvent](https://doc.qt.io/qt-6/qgestureevent.html).
class /+ Q_WIDGETS_EXPORT +/ QGestureEvent : QEvent
{
public:
    /+ explicit +/this(ref const(QList!(QGesture)) gestures);
    ~this();

    final QList!(QGesture) gestures() const;
    final QGesture gesture(/+ Qt:: +/qt.core.namespace.GestureType type) const;

    final QList!(QGesture) activeGestures() const;
    final QList!(QGesture) canceledGestures() const;

    /+ using QEvent::setAccepted; +/
    /+ using QEvent::isAccepted; +/
    /+ using QEvent::accept; +/
    /+ using QEvent::ignore; +/

    final void setAccepted(QGesture , bool);
    final void accept(QGesture );
    final void ignore(QGesture );
    final bool isAccepted(QGesture ) const;

    final void setAccepted(/+ Qt:: +/qt.core.namespace.GestureType, bool);
    final void accept(/+ Qt:: +/qt.core.namespace.GestureType);
    final void ignore(/+ Qt:: +/qt.core.namespace.GestureType);
    final bool isAccepted(/+ Qt:: +/qt.core.namespace.GestureType) const;

    final void setWidget(QWidget widget);
    final QWidget widget() const;

/+ #if QT_CONFIG(graphicsview) +/
    final QPointF mapToGraphicsScene(ref const(QPointF) gesturePoint) const;
/+ #endif +/

private:
    QList!(QGesture) m_gestures;
    QWidget m_widget;
    QMap!(/+ Qt:: +/qt.core.namespace.GestureType, bool) m_accepted;
    QMap!(/+ Qt:: +/qt.core.namespace.GestureType, QWidget) m_targetWidgets;

    /+ friend class QApplication; +/
    /+ friend class QGestureManager; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}+/

/+ #  ifndef QT_NO_DEBUG_STREAM
Q_WIDGETS_EXPORT QDebug operator<<(QDebug, const QGesture *);
Q_WIDGETS_EXPORT QDebug operator<<(QDebug, const QGestureEvent *);
#  endif


Q_DECLARE_METATYPE(QGesture::GestureCancelPolicy) +/
}

