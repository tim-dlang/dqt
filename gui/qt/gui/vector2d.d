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
module qt.gui.vector2d;
extern(C++):

import qt.config;
import qt.helpers;
version(QT_NO_VECTOR2D){}else
version(QT_NO_VECTOR3D){}else
    import qt.gui.vector3d;
version(QT_NO_VECTOR2D){}else
version(QT_NO_VECTOR4D){}else
    import qt.gui.vector4d;
version(QT_NO_VECTOR2D){}else
{
    import qt.core.metatype;
    import qt.core.namespace;
    import qt.core.point;
    import qt.core.variant;
}

version(QT_NO_VECTOR2D)
{
extern(C++, class) struct QVector2D;
}
/+ class QVector3D;
class QVector4D;
class QVariant; +/

version(QT_NO_VECTOR2D){}else
{

@(QMetaType.Type.QVector2D) extern(C++, class) struct /+ Q_GUI_EXPORT +/ QVector2D
{
public:
    @disable this();
    /+pragma(inline, true) this()
    {
        this.v = [0.0f, 0.0f];
    }+/
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.Initialization) {}
    pragma(inline, true) this(float xpos, float ypos)
    {
        this.v = [xpos, ypos];
    }
    /+ explicit +/pragma(inline, true) this(ref const(QPoint) point)
    {
        this.v = [float(point.x()), float(point.y())];
    }
    /+ explicit +/pragma(inline, true) this(ref const(QPointF) point)
    {
        this.v = [float(point.x()), float(point.y())];
    }
/+ #ifndef QT_NO_VECTOR3D +/
    version(QT_NO_VECTOR3D){}else
    {
        /+ explicit +/this(ref const(QVector3D) vector);
    }
/+ #endif
#ifndef QT_NO_VECTOR4D +/
    version(QT_NO_VECTOR4D){}else
    {
        /+ explicit +/this(ref const(QVector4D) vector);
    }
/+ #endif +/

    pragma(inline, true) bool isNull() const
    {
        import qt.core.global;

        return qIsNull(v[0]) && qIsNull(v[1]);
    }

    pragma(inline, true) float x() const { return v[0]; }
    pragma(inline, true) float y() const { return v[1]; }

    pragma(inline, true) void setX(float aX) { v[0] = aX; }
    pragma(inline, true) void setY(float aY) { v[1] = aY; }

    /+pragma(inline, true) ref float operator [](int i)
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{uint(i) < 2u})));
        return v[i];
    }+/
    /+pragma(inline, true) float operator [](int i) const
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{uint(i) < 2u})));
        return v[i];
    }+/

    float length() const;
    float lengthSquared() const; //In Qt 6 convert to inline and constexpr

    /+ Q_REQUIRED_RESULT +/ QVector2D normalized() const;
    void normalize();

    float distanceToPoint(ref const(QVector2D) point) const;
    float distanceToLine(ref const(QVector2D) point, ref const(QVector2D) direction) const;

    /+pragma(inline, true) ref QVector2D operator +=(ref const(QVector2D) vector)
    {
        v[0] += vector.v[0];
        v[1] += vector.v[1];
        return this;
    }+/
    /+pragma(inline, true) ref QVector2D operator -=(ref const(QVector2D) vector)
    {
        v[0] -= vector.v[0];
        v[1] -= vector.v[1];
        return this;
    }+/
    /+pragma(inline, true) ref QVector2D operator *=(float factor)
    {
        v[0] *= factor;
        v[1] *= factor;
        return this;
    }+/
    /+pragma(inline, true) ref QVector2D operator *=(ref const(QVector2D) vector)
    {
        v[0] *= vector.v[0];
        v[1] *= vector.v[1];
        return this;
    }+/
    /+pragma(inline, true) ref QVector2D operator /=(float divisor)
    {
        v[0] /= divisor;
        v[1] /= divisor;
        return this;
    }+/
    /+pragma(inline, true) ref QVector2D operator /=(ref const(QVector2D) vector)
    {
        v[0] /= vector.v[0];
        v[1] /= vector.v[1];
        return this;
    }+/

    static float dotProduct(ref const(QVector2D) v1, ref const(QVector2D) v2); //In Qt 6 convert to inline and constexpr

    /+ friend inline bool operator==(const QVector2D &v1, const QVector2D &v2); +/
    /+ friend inline bool operator!=(const QVector2D &v1, const QVector2D &v2); +/
    /+ friend inline const QVector2D operator+(const QVector2D &v1, const QVector2D &v2); +/
    /+ friend inline const QVector2D operator-(const QVector2D &v1, const QVector2D &v2); +/
    /+ friend inline const QVector2D operator*(float factor, const QVector2D &vector); +/
    /+ friend inline const QVector2D operator*(const QVector2D &vector, float factor); +/
    /+ friend inline const QVector2D operator*(const QVector2D &v1, const QVector2D &v2); +/
    /+ friend inline const QVector2D operator-(const QVector2D &vector); +/
    /+ friend inline const QVector2D operator/(const QVector2D &vector, float divisor); +/
    /+ friend inline const QVector2D operator/(const QVector2D &vector, const QVector2D &divisor); +/

    /+ friend inline bool qFuzzyCompare(const QVector2D& v1, const QVector2D& v2); +/

/+ #ifndef QT_NO_VECTOR3D +/
    version(QT_NO_VECTOR3D){}else
    {
        QVector3D toVector3D() const;
    }
/+ #endif
#ifndef QT_NO_VECTOR4D +/
    version(QT_NO_VECTOR4D){}else
    {
        QVector4D toVector4D() const;
    }
/+ #endif +/

    pragma(inline, true) QPoint toPoint() const
    {
        import qt.core.global;

        return QPoint(qRound(v[0]), qRound(v[1]));
    }
    pragma(inline, true) QPointF toPointF() const
    {
        import qt.core.global;

        return QPointF(qreal(v[0]), qreal(v[1]));
    }

    /+auto opCast(T : QVariant)() const;+/

private:
    float[2] v;

    /+ friend class QVector3D; +/
    /+ friend class QVector4D; +/
}

/+ Q_DECLARE_TYPEINFO(QVector2D, Q_PRIMITIVE_TYPE);

QT_WARNING_PUSH
QT_WARNING_DISABLE_CLANG("-Wfloat-equal")
QT_WARNING_DISABLE_GCC("-Wfloat-equal")
QT_WARNING_DISABLE_INTEL(1572) +/
/+pragma(inline, true) bool operator ==(ref const(QVector2D) v1, ref const(QVector2D) v2)
{
    return v1.v[0] == v2.v[0] && v1.v[1] == v2.v[1];
}+/

/+pragma(inline, true) bool operator !=(ref const(QVector2D) v1, ref const(QVector2D) v2)
{
    return v1.v[0] != v2.v[0] || v1.v[1] != v2.v[1];
}+/
/+ QT_WARNING_POP +/

/+pragma(inline, true) const(QVector2D) operator +(ref const(QVector2D) v1, ref const(QVector2D) v2)
{
    return QVector2D(v1.v[0] + v2.v[0], v1.v[1] + v2.v[1]);
}+/

/+pragma(inline, true) const(QVector2D) operator -(ref const(QVector2D) v1, ref const(QVector2D) v2)
{
    return QVector2D(v1.v[0] - v2.v[0], v1.v[1] - v2.v[1]);
}+/

/+pragma(inline, true) const(QVector2D) operator *(float factor, ref const(QVector2D) vector)
{
    return QVector2D(vector.v[0] * factor, vector.v[1] * factor);
}+/

/+pragma(inline, true) const(QVector2D) operator *(ref const(QVector2D) vector, float factor)
{
    return QVector2D(vector.v[0] * factor, vector.v[1] * factor);
}+/

/+pragma(inline, true) const(QVector2D) operator *(ref const(QVector2D) v1, ref const(QVector2D) v2)
{
    return QVector2D(v1.v[0] * v2.v[0], v1.v[1] * v2.v[1]);
}+/

/+pragma(inline, true) const(QVector2D) operator -(ref const(QVector2D) vector)
{
    return QVector2D(-vector.v[0], -vector.v[1]);
}+/

/+pragma(inline, true) const(QVector2D) operator /(ref const(QVector2D) vector, float divisor)
{
    return QVector2D(vector.v[0] / divisor, vector.v[1] / divisor);
}+/

/+pragma(inline, true) const(QVector2D) operator /(ref const(QVector2D) vector, ref const(QVector2D) divisor)
{
    return QVector2D(vector.v[0] / divisor.v[0], vector.v[1] / divisor.v[1]);
}+/

pragma(inline, true) bool qFuzzyCompare(ref const(QVector2D) v1, ref const(QVector2D) v2)
{
    import qt.core.global;

    return qt.core.global.qFuzzyCompare(v1.v[0], v2.v[0]) && qt.core.global.qFuzzyCompare(v1.v[1], v2.v[1]);
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug dbg, const QVector2D &vector);
#endif

#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QVector2D &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QVector2D &);
#endif +/

}

