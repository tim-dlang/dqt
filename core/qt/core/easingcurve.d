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
module qt.core.easingcurve;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.list;
import qt.core.metamacros;
import qt.core.point;
import qt.core.typeinfo;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(easingcurve); +/


extern(C++, class) struct QEasingCurvePrivate;
/// Binding for C++ class [QEasingCurve](https://doc.qt.io/qt-6/qeasingcurve.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QEasingCurve
{
    mixin(Q_GADGET);
public:
    enum Type {
        Linear,
        InQuad, OutQuad, InOutQuad, OutInQuad,
        InCubic, OutCubic, InOutCubic, OutInCubic,
        InQuart, OutQuart, InOutQuart, OutInQuart,
        InQuint, OutQuint, InOutQuint, OutInQuint,
        InSine, OutSine, InOutSine, OutInSine,
        InExpo, OutExpo, InOutExpo, OutInExpo,
        InCirc, OutCirc, InOutCirc, OutInCirc,
        InElastic, OutElastic, InOutElastic, OutInElastic,
        InBack, OutBack, InOutBack, OutInBack,
        InBounce, OutBounce, InOutBounce, OutInBounce,
        InCurve, OutCurve, SineCurve, CosineCurve,
        BezierSpline, TCBSpline, Custom, NCurveTypes
    }
    /+ Q_ENUM(Type) +/

    @disable this();
    this(Type type/+ = Type.Linear+/);
    @disable this(this);
    this(ref const(QEasingCurve) other);
    ~this();

    /+ref QEasingCurve operator =(ref const(QEasingCurve) other)
    { if ( &this != &other ) { auto copy = QEasingCurve(other); swap(copy); } return this; }+/
    /+ QEasingCurve(QEasingCurve &&other) noexcept : d_ptr(other.d_ptr) { other.d_ptr = nullptr; } +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QEasingCurve) +/

    /+ void swap(QEasingCurve &other) noexcept { qSwap(d_ptr, other.d_ptr); } +/

    /+bool operator ==(ref const(QEasingCurve) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QEasingCurve) other) const
    { return !(this.operator==(other)); }+/

    qreal amplitude() const;
    void setAmplitude(qreal amplitude);

    qreal period() const;
    void setPeriod(qreal period);

    qreal overshoot() const;
    void setOvershoot(qreal overshoot);

    void addCubicBezierSegment(ref const(QPointF) c1, ref const(QPointF) c2, ref const(QPointF) endPoint);
    void addTCBSegment(ref const(QPointF) nextPoint, qreal t, qreal c, qreal b);
    QList!(QPointF) toCubicSpline() const;

    Type type() const;
    void setType(Type type);
    alias EasingFunction = ExternCPPFunc!(qreal function(qreal progress));
    void setCustomType(EasingFunction func);
    EasingFunction customType() const;

    qreal valueForProgress(qreal progress) const;

private:
    QEasingCurvePrivate* d_ptr;
/+ #ifndef QT_NO_DEBUG_STREAM
    friend Q_CORE_EXPORT QDebug operator<<(QDebug debug, const QEasingCurve &item);
#endif
#ifndef QT_NO_DATASTREAM +/
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QEasingCurve &); +/
        /+ friend Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QEasingCurve &); +/
    }
/+ #endif +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED(QEasingCurve)

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug debug, const QEasingCurve &item);
#endif

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QEasingCurve &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QEasingCurve &);
#endif +/

