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
module qt.gui.vector4d;
extern(C++):

import qt.config;
import qt.helpers;
version(QT_NO_VECTOR2D){}else
version(QT_NO_VECTOR4D){}else
    import qt.gui.vector2d;
version(QT_NO_VECTOR3D){}else
version(QT_NO_VECTOR4D){}else
    import qt.gui.vector3d;
version(QT_NO_VECTOR4D){}else
{
    import qt.core.namespace;
    import qt.core.point;
    import qt.core.typeinfo;
    import qt.core.variant;
}

version(QT_NO_VECTOR4D)
{
extern(C++, class) struct QVector4D;
}

version(QT_NO_VECTOR4D){}else
{

/// Binding for C++ class [QVector4D](https://doc.qt.io/qt-5/qvector4d.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QVector4D
{
public:
    @disable this();
    /+pragma(inline, true) this()
    {
        this.v = [0.0f, 0.0f, 0.0f, 0.0f];
    }+/
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.Initialization) {}
    pragma(inline, true) this(float xpos, float ypos, float zpos, float wpos)
    {
        this.v = [xpos, ypos, zpos, wpos];
    }
    /+ explicit +/pragma(inline, true) this(ref const(QPoint) point)
    {
        this.v = [float(point.x()), float(point.y()), 0.0f, 0.0f];
    }
    /+ explicit +/pragma(inline, true) this(ref const(QPointF) point)
    {
        this.v = [float(point.x()), float(point.y()), 0.0f, 0.0f];
    }
/+ #ifndef QT_NO_VECTOR2D +/
    version(QT_NO_VECTOR2D){}else
    {
        this(ref const(QVector2D) vector);
        this(ref const(QVector2D) vector, float zpos, float wpos);
    }
/+ #endif
#ifndef QT_NO_VECTOR3D +/
    version(QT_NO_VECTOR3D){}else
    {
        this(ref const(QVector3D) vector);
        this(ref const(QVector3D) vector, float wpos);
    }
/+ #endif +/

    pragma(inline, true) bool isNull() const
    {
        import qt.core.global;

        return qIsNull(v[0]) && qIsNull(v[1]) && qIsNull(v[2]) && qIsNull(v[3]);
    }

    pragma(inline, true) float x() const { return v[0]; }
    pragma(inline, true) float y() const { return v[1]; }
    pragma(inline, true) float z() const { return v[2]; }
    pragma(inline, true) float w() const { return v[3]; }

    pragma(inline, true) void setX(float aX) { v[0] = aX; }
    pragma(inline, true) void setY(float aY) { v[1] = aY; }
    pragma(inline, true) void setZ(float aZ) { v[2] = aZ; }
    pragma(inline, true) void setW(float aW) { v[3] = aW; }

    /+pragma(inline, true) ref float operator [](int i)
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{uint(i) < 4u})));
        return v[i];
    }+/
    /+pragma(inline, true) float operator [](int i) const
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{uint(i) < 4u})));
        return v[i];
    }+/

    float length() const;
    float lengthSquared() const; //In Qt 6 convert to inline and constexpr

    /+ Q_REQUIRED_RESULT +/ QVector4D normalized() const;
    void normalize();

    /+pragma(inline, true) ref QVector4D operator +=(ref const(QVector4D) vector)
    {
        v[0] += vector.v[0];
        v[1] += vector.v[1];
        v[2] += vector.v[2];
        v[3] += vector.v[3];
        return this;
    }+/
    /+pragma(inline, true) ref QVector4D operator -=(ref const(QVector4D) vector)
    {
        v[0] -= vector.v[0];
        v[1] -= vector.v[1];
        v[2] -= vector.v[2];
        v[3] -= vector.v[3];
        return this;
    }+/
    /+pragma(inline, true) ref QVector4D operator *=(float factor)
    {
        v[0] *= factor;
        v[1] *= factor;
        v[2] *= factor;
        v[3] *= factor;
        return this;
    }+/
    /+pragma(inline, true) ref QVector4D operator *=(ref const(QVector4D) vector)
    {
        v[0] *= vector.v[0];
        v[1] *= vector.v[1];
        v[2] *= vector.v[2];
        v[3] *= vector.v[3];
        return this;
    }+/
    /+pragma(inline, true) ref QVector4D operator /=(float divisor)
    {
        v[0] /= divisor;
        v[1] /= divisor;
        v[2] /= divisor;
        v[3] /= divisor;
        return this;
    }+/
    /+pragma(inline, true) ref QVector4D operator /=(ref const(QVector4D) vector)
    {
        v[0] /= vector.v[0];
        v[1] /= vector.v[1];
        v[2] /= vector.v[2];
        v[3] /= vector.v[3];
        return this;
    }+/

    static float dotProduct(ref const(QVector4D) v1, ref const(QVector4D) v2); //In Qt 6 convert to inline and constexpr

    /+ friend inline bool operator==(const QVector4D &v1, const QVector4D &v2); +/
    /+ friend inline bool operator!=(const QVector4D &v1, const QVector4D &v2); +/
    /+ friend inline const QVector4D operator+(const QVector4D &v1, const QVector4D &v2); +/
    /+ friend inline const QVector4D operator-(const QVector4D &v1, const QVector4D &v2); +/
    /+ friend inline const QVector4D operator*(float factor, const QVector4D &vector); +/
    /+ friend inline const QVector4D operator*(const QVector4D &vector, float factor); +/
    /+ friend inline const QVector4D operator*(const QVector4D &v1, const QVector4D& v2); +/
    /+ friend inline const QVector4D operator-(const QVector4D &vector); +/
    /+ friend inline const QVector4D operator/(const QVector4D &vector, float divisor); +/
    /+ friend inline const QVector4D operator/(const QVector4D &vector, const QVector4D &divisor); +/

    /+ friend inline bool qFuzzyCompare(const QVector4D& v1, const QVector4D& v2); +/

/+ #ifndef QT_NO_VECTOR2D +/
    version(QT_NO_VECTOR2D){}else
    {
        QVector2D toVector2D() const;
        QVector2D toVector2DAffine() const;
    }
/+ #endif
#ifndef QT_NO_VECTOR3D +/
    version(QT_NO_VECTOR3D){}else
    {
        QVector3D toVector3D() const;
        QVector3D toVector3DAffine() const;
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
    float[4] v;

    /+ friend class QVector2D; +/
    /+ friend class QVector3D; +/
    static if (!defined!"QT_NO_MATRIX4X4")
    {
        /+ friend QVector4D operator*(const QVector4D& vector, const QMatrix4x4& matrix); +/
        /+ friend QVector4D operator*(const QMatrix4x4& matrix, const QVector4D& vector); +/
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QVector4D, Q_PRIMITIVE_TYPE);

QT_WARNING_PUSH
QT_WARNING_DISABLE_CLANG("-Wfloat-equal")
QT_WARNING_DISABLE_GCC("-Wfloat-equal")
QT_WARNING_DISABLE_INTEL(1572) +/
/+pragma(inline, true) bool operator ==(ref const(QVector4D) v1, ref const(QVector4D) v2)
{
    return v1.v[0] == v2.v[0] && v1.v[1] == v2.v[1] && v1.v[2] == v2.v[2] && v1.v[3] == v2.v[3];
}+/

/+pragma(inline, true) bool operator !=(ref const(QVector4D) v1, ref const(QVector4D) v2)
{
    return v1.v[0] != v2.v[0] || v1.v[1] != v2.v[1] || v1.v[2] != v2.v[2] || v1.v[3] != v2.v[3];
}+/
/+ QT_WARNING_POP +/

/+pragma(inline, true) const(QVector4D) operator +(ref const(QVector4D) v1, ref const(QVector4D) v2)
{
    return QVector4D(v1.v[0] + v2.v[0], v1.v[1] + v2.v[1], v1.v[2] + v2.v[2], v1.v[3] + v2.v[3]);
}+/

/+pragma(inline, true) const(QVector4D) operator -(ref const(QVector4D) v1, ref const(QVector4D) v2)
{
    return QVector4D(v1.v[0] - v2.v[0], v1.v[1] - v2.v[1], v1.v[2] - v2.v[2], v1.v[3] - v2.v[3]);
}+/

/+pragma(inline, true) const(QVector4D) operator *(float factor, ref const(QVector4D) vector)
{
    return QVector4D(vector.v[0] * factor, vector.v[1] * factor, vector.v[2] * factor, vector.v[3] * factor);
}+/

/+pragma(inline, true) const(QVector4D) operator *(ref const(QVector4D) vector, float factor)
{
    return QVector4D(vector.v[0] * factor, vector.v[1] * factor, vector.v[2] * factor, vector.v[3] * factor);
}+/

/+pragma(inline, true) const(QVector4D) operator *(ref const(QVector4D) v1, ref const(QVector4D) v2)
{
    return QVector4D(v1.v[0] * v2.v[0], v1.v[1] * v2.v[1], v1.v[2] * v2.v[2], v1.v[3] * v2.v[3]);
}+/

/+pragma(inline, true) const(QVector4D) operator -(ref const(QVector4D) vector)
{
    return QVector4D(-vector.v[0], -vector.v[1], -vector.v[2], -vector.v[3]);
}+/

/+pragma(inline, true) const(QVector4D) operator /(ref const(QVector4D) vector, float divisor)
{
    return QVector4D(vector.v[0] / divisor, vector.v[1] / divisor, vector.v[2] / divisor, vector.v[3] / divisor);
}+/

/+pragma(inline, true) const(QVector4D) operator /(ref const(QVector4D) vector, ref const(QVector4D) divisor)
{
    return QVector4D(vector.v[0] / divisor.v[0], vector.v[1] / divisor.v[1], vector.v[2] / divisor.v[2], vector.v[3] / divisor.v[3]);
}+/

pragma(inline, true) bool qFuzzyCompare(ref const(QVector4D) v1, ref const(QVector4D) v2)
{
    import qt.core.global;

    return qt.core.global.qFuzzyCompare(v1.v[0], v2.v[0]) &&
           qt.core.global.qFuzzyCompare(v1.v[1], v2.v[1]) &&
           qt.core.global.qFuzzyCompare(v1.v[2], v2.v[2]) &&
           qt.core.global.qFuzzyCompare(v1.v[3], v2.v[3]);
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug dbg, const QVector4D &vector);
#endif

#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QVector4D &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QVector4D &);
#endif +/

}

