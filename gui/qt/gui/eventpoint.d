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
module qt.gui.eventpoint;
extern(C++):

import core.stdc.config;
import qt.config;
import qt.core.flags;
import qt.core.global;
import qt.core.metamacros;
import qt.core.namespace;
import qt.core.point;
import qt.core.shareddata;
import qt.core.size;
import qt.core.typeinfo;
import qt.gui.pointingdevice;
import qt.gui.vector2d;
import qt.helpers;

extern(C++, class) struct QEventPointPrivate;
/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QEventPointPrivate, Q_GUI_EXPORT) +/
extern(C++, class) struct QMutableEventPoint;

/// Binding for C++ class [QEventPoint](https://doc.qt.io/qt-6/qeventpoint.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QEventPoint
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(bool accepted READ isAccepted WRITE setAccepted)
    QDOC_PROPERTY(QPointingDevice *device READ device CONSTANT) // qdoc doesn't know const
    Q_PROPERTY(const QPointingDevice *device READ device CONSTANT)
    Q_PROPERTY(int id READ id CONSTANT)
    Q_PROPERTY(QPointingDeviceUniqueId uniqueId READ uniqueId CONSTANT)
    Q_PROPERTY(State state READ state CONSTANT)
    Q_PROPERTY(ulong timestamp READ timestamp CONSTANT)
    Q_PROPERTY(ulong pressTimestamp READ pressTimestamp CONSTANT)
    Q_PROPERTY(ulong lastTimestamp READ lastTimestamp CONSTANT)
    Q_PROPERTY(qreal timeHeld READ timeHeld CONSTANT)
    Q_PROPERTY(qreal pressure READ pressure CONSTANT)
    Q_PROPERTY(qreal rotation READ rotation CONSTANT)
    Q_PROPERTY(QSizeF ellipseDiameters READ ellipseDiameters CONSTANT)
    Q_PROPERTY(QVector2D velocity READ velocity CONSTANT)
    Q_PROPERTY(QPointF position READ position CONSTANT)
    Q_PROPERTY(QPointF pressPosition READ pressPosition CONSTANT)
    Q_PROPERTY(QPointF grabPosition READ grabPosition CONSTANT)
    Q_PROPERTY(QPointF lastPosition READ lastPosition CONSTANT)
    Q_PROPERTY(QPointF scenePosition READ scenePosition CONSTANT)
    Q_PROPERTY(QPointF scenePressPosition READ scenePressPosition CONSTANT)
    Q_PROPERTY(QPointF sceneGrabPosition READ sceneGrabPosition CONSTANT)
    Q_PROPERTY(QPointF sceneLastPosition READ sceneLastPosition CONSTANT)
    Q_PROPERTY(QPointF globalPosition READ globalPosition CONSTANT)
    Q_PROPERTY(QPointF globalPressPosition READ globalPressPosition CONSTANT)
    Q_PROPERTY(QPointF globalGrabPosition READ globalGrabPosition CONSTANT)
    Q_PROPERTY(QPointF globalLastPosition READ globalLastPosition CONSTANT) +/
public:
    enum State : quint8 {
        Unknown     = /+ Qt:: +/qt.core.namespace.TouchPointState.TouchPointUnknownState,
        Stationary  = /+ Qt:: +/qt.core.namespace.TouchPointState.TouchPointStationary,
        Pressed     = /+ Qt:: +/qt.core.namespace.TouchPointState.TouchPointPressed,
        Updated     = /+ Qt:: +/qt.core.namespace.TouchPointState.TouchPointMoved,
        Released    = /+ Qt:: +/qt.core.namespace.TouchPointState.TouchPointReleased
    }
    /+ Q_DECLARE_FLAGS(States, State) +/
alias States = QFlags!(State);    /+ Q_FLAG(States) +/

    @disable this();
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ explicit +/this(int id/+ = -1+/, const(QPointingDevice) device = null);
    }));
    this(int pointId, State state, ref const(QPointF) scenePosition, ref const(QPointF) globalPosition);
    @disable this(this);
    this(ref const(QEventPoint) other) nothrow;
    ref QEventPoint opAssign(ref const(QEventPoint) other) nothrow;
    /+ QEventPoint(QEventPoint && other) noexcept = default; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QEventPoint) +/
    /+bool operator ==(ref const(QEventPoint) other) const nothrow;+/
    /+bool operator !=(ref const(QEventPoint) other) const nothrow { return !operator==(other); }+/
    ~this();
    /+ inline void swap(QEventPoint &other) noexcept
    { d.swap(other.d); } +/

    QPointF position() const;
    QPointF pressPosition() const;
    QPointF grabPosition() const;
    QPointF lastPosition() const;
    QPointF scenePosition() const;
    QPointF scenePressPosition() const;
    QPointF sceneGrabPosition() const;
    QPointF sceneLastPosition() const;
    QPointF globalPosition() const;
    QPointF globalPressPosition() const;
    QPointF globalGrabPosition() const;
    QPointF globalLastPosition() const;
    QPointF normalizedPosition() const;

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    // QEventPoint replaces QTouchEvent::TouchPoint, so we need all its old accessors, for now
    /+ QT_DEPRECATED_VERSION_X_6_0("Use position()") +/
        QPointF pos() const { return position(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use pressPosition()") +/
        QPointF startPos() const { return pressPosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use scenePosition()") +/
        QPointF scenePos() const { return scenePosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use scenePressPosition()") +/
        QPointF startScenePos() const { return scenePressPosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPosition()") +/
        QPointF screenPos() const { return globalPosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPressPosition()") +/
        QPointF startScreenPos() const { return globalPressPosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use globalPressPosition()") +/
        QPointF startNormalizedPos() const;
    /+ QT_DEPRECATED_VERSION_X_6_0("Use normalizedPosition()") +/
        QPointF normalizedPos() const { return normalizedPosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use lastPosition()") +/
        QPointF lastPos() const { return lastPosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use sceneLastPosition()") +/
        QPointF lastScenePos() const { return sceneLastPosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use globalLastPosition()") +/
        QPointF lastScreenPos() const { return globalLastPosition(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use globalLastPosition()") +/
        QPointF lastNormalizedPos() const;
/+ #endif +/ // QT_DEPRECATED_SINCE(6, 0)
    QVector2D velocity() const;
    State state() const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    const(QPointingDevice) device() const;
    }));
    int id() const;
    QPointingDeviceUniqueId uniqueId() const;
    cpp_ulong timestamp() const;
    cpp_ulong lastTimestamp() const;
    cpp_ulong pressTimestamp() const;
    qreal timeHeld() const;
    qreal pressure() const;
    qreal rotation() const;
    QSizeF ellipseDiameters() const;

    bool isAccepted() const;
    void setAccepted(bool accepted = true);

private:
    QExplicitlySharedDataPointer!(QEventPointPrivate) d;
    /+ friend class QMutableEventPoint; +/
    /+ friend class QPointerEvent; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QEventPoint *);
Q_GUI_EXPORT QDebug operator<<(QDebug, const QEventPoint &);
#endif

Q_DECLARE_SHARED(QEventPoint) +/

