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
module qt.gui.vector3d;
extern(C++):

import qt.config;
import qt.helpers;
version(QT_NO_VECTOR2D){}else
version(QT_NO_VECTOR3D){}else
    import qt.gui.vector2d;
version(QT_NO_VECTOR3D){}else
version(QT_NO_VECTOR4D){}else
    import qt.gui.vector4d;
version(QT_NO_VECTOR3D){}else
{
    import qt.core.metatype;
    import qt.core.namespace;
    import qt.core.point;
    import qt.core.rect;
    import qt.core.variant;
}

version(QT_NO_VECTOR3D)
{
extern(C++, class) struct QVector3D;
}

version(QT_NO_VECTOR3D){}else
{

/// Binding for C++ class [QVector3D](https://doc.qt.io/qt-5/qvector3d.html).
@(QMetaType.Type.QVector3D) extern(C++, class) struct /+ Q_GUI_EXPORT +/ QVector3D
{
public:
    @disable this();
    /+pragma(inline, true) this()
    {
        this.v = [0.0f, 0.0f, 0.0f];
    }+/
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.Initialization) {}
    this(float xpos, float ypos, float zpos)
    {
        this.v = [xpos, ypos, zpos];
    }

    /+ explicit +/pragma(inline, true) this(ref const(QPoint) point)
    {
        this.v = [float(point.x()), float(point.y()), float(0.0f)];
    }
    /+ explicit +/pragma(inline, true) this(ref const(QPointF) point)
    {
        this.v = [float(point.x()), float(point.y()), 0.0f];
    }
/+ #ifndef QT_NO_VECTOR2D +/
    version(QT_NO_VECTOR2D){}else
    {
        this(ref const(QVector2D) vector);
        this(ref const(QVector2D) vector, float zpos);
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

        return qIsNull(v[0]) && qIsNull(v[1]) && qIsNull(v[2]);
    }

    pragma(inline, true) float x() const { return v[0]; }
    pragma(inline, true) float y() const { return v[1]; }
    pragma(inline, true) float z() const { return v[2]; }

    pragma(inline, true) void setX(float aX) { v[0] = aX; }
    pragma(inline, true) void setY(float aY) { v[1] = aY; }
    pragma(inline, true) void setZ(float aZ) { v[2] = aZ; }

    /+pragma(inline, true) ref float operator [](int i)
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{uint(i) < 3u})));
        return v[i];
    }+/
    /+pragma(inline, true) float operator [](int i) const
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{uint(i) < 3u})));
        return v[i];
    }+/

    float length() const;
    float lengthSquared() const;

    QVector3D normalized() const;
    void normalize();

    /+pragma(inline, true) ref QVector3D operator +=(ref const(QVector3D) vector)
    {
        v[0] += vector.v[0];
        v[1] += vector.v[1];
        v[2] += vector.v[2];
        return this;
    }+/
    /+pragma(inline, true) ref QVector3D operator -=(ref const(QVector3D) vector)
    {
        v[0] -= vector.v[0];
        v[1] -= vector.v[1];
        v[2] -= vector.v[2];
        return this;
    }+/
    /+pragma(inline, true) ref QVector3D operator *=(float factor)
    {
        v[0] *= factor;
        v[1] *= factor;
        v[2] *= factor;
        return this;
    }+/
    /+pragma(inline, true) ref QVector3D operator *=(ref const(QVector3D) vector)
    {
        v[0] *= vector.v[0];
        v[1] *= vector.v[1];
        v[2] *= vector.v[2];
        return this;
    }+/
    /+pragma(inline, true) ref QVector3D operator /=(float divisor)
    {
        v[0] /= divisor;
        v[1] /= divisor;
        v[2] /= divisor;
        return this;
    }+/
    /+pragma(inline, true) ref QVector3D operator /=(ref const(QVector3D) vector)
    {
        v[0] /= vector.v[0];
        v[1] /= vector.v[1];
        v[2] /= vector.v[2];
        return this;
    }+/

    static float dotProduct(ref const(QVector3D) v1, ref const(QVector3D) v2); //In Qt 6 convert to inline and constexpr
    static QVector3D crossProduct(ref const(QVector3D) v1, ref const(QVector3D) v2); //in Qt 6 convert to inline and constexpr

    static QVector3D normal(ref const(QVector3D) v1, ref const(QVector3D) v2);
    static QVector3D normal
            (ref const(QVector3D) v1, ref const(QVector3D) v2, ref const(QVector3D) v3);

    QVector3D project(ref const(QMatrix4x4) modelView, ref const(QMatrix4x4) projection, ref const(QRect) viewport) const;
    QVector3D unproject(ref const(QMatrix4x4) modelView, ref const(QMatrix4x4) projection, ref const(QRect) viewport) const;

    float distanceToPoint(ref const(QVector3D) point) const;
    float distanceToPlane(ref const(QVector3D) plane, ref const(QVector3D) normal) const;
    float distanceToPlane(ref const(QVector3D) plane1, ref const(QVector3D) plane2, ref const(QVector3D) plane3) const;
    float distanceToLine(ref const(QVector3D) point, ref const(QVector3D) direction) const;

    /+ friend inline bool operator==(const QVector3D &v1, const QVector3D &v2); +/
    /+ friend inline bool operator!=(const QVector3D &v1, const QVector3D &v2); +/
    /+ friend inline const QVector3D operator+(const QVector3D &v1, const QVector3D &v2); +/
    /+ friend inline const QVector3D operator-(const QVector3D &v1, const QVector3D &v2); +/
    /+ friend inline const QVector3D operator*(float factor, const QVector3D &vector); +/
    /+ friend inline const QVector3D operator*(const QVector3D &vector, float factor); +/
    /+ friend const QVector3D operator*(const QVector3D &v1, const QVector3D& v2); +/
    /+ friend inline const QVector3D operator-(const QVector3D &vector); +/
    /+ friend inline const QVector3D operator/(const QVector3D &vector, float divisor); +/
    /+ friend inline const QVector3D operator/(const QVector3D &vector, const QVector3D &divisor); +/

    /+ friend inline bool qFuzzyCompare(const QVector3D& v1, const QVector3D& v2); +/

/+ #ifndef QT_NO_VECTOR2D +/
    version(QT_NO_VECTOR2D){}else
    {
        QVector2D toVector2D() const;
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
    float[3] v;

    /+ friend class QVector2D; +/
    /+ friend class QVector4D; +/
    static if(!defined!"QT_NO_MATRIX4X4")
    {
        /+ friend QVector3D operator*(const QVector3D& vector, const QMatrix4x4& matrix); +/
        /+ friend QVector3D operator*(const QMatrix4x4& matrix, const QVector3D& vector); +/
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QVector3D, Q_PRIMITIVE_TYPE);

QT_WARNING_PUSH
QT_WARNING_DISABLE_CLANG("-Wfloat-equal")
QT_WARNING_DISABLE_GCC("-Wfloat-equal")
QT_WARNING_DISABLE_INTEL(1572) +/
/+pragma(inline, true) bool operator ==(ref const(QVector3D) v1, ref const(QVector3D) v2)
{
    return v1.v[0] == v2.v[0] && v1.v[1] == v2.v[1] && v1.v[2] == v2.v[2];
}+/

/+pragma(inline, true) bool operator !=(ref const(QVector3D) v1, ref const(QVector3D) v2)
{
    return v1.v[0] != v2.v[0] || v1.v[1] != v2.v[1] || v1.v[2] != v2.v[2];
}+/
/+ QT_WARNING_POP +/

/+pragma(inline, true) const(QVector3D) operator +(ref const(QVector3D) v1, ref const(QVector3D) v2)
{
    return QVector3D(v1.v[0] + v2.v[0], v1.v[1] + v2.v[1], v1.v[2] + v2.v[2]);
}+/

/+pragma(inline, true) const(QVector3D) operator -(ref const(QVector3D) v1, ref const(QVector3D) v2)
{
    return QVector3D(v1.v[0] - v2.v[0], v1.v[1] - v2.v[1], v1.v[2] - v2.v[2]);
}+/

/+pragma(inline, true) const(QVector3D) operator *(float factor, ref const(QVector3D) vector)
{
    return QVector3D(vector.v[0] * factor, vector.v[1] * factor, vector.v[2] * factor);
}+/

/+pragma(inline, true) const(QVector3D) operator *(ref const(QVector3D) vector, float factor)
{
    return QVector3D(vector.v[0] * factor, vector.v[1] * factor, vector.v[2] * factor);
}+/

/+pragma(inline, true) const(QVector3D) operator *(ref const(QVector3D) v1, ref const(QVector3D) v2)
{
    return QVector3D(v1.v[0] * v2.v[0], v1.v[1] * v2.v[1], v1.v[2] * v2.v[2]);
}+/

/+pragma(inline, true) const(QVector3D) operator -(ref const(QVector3D) vector)
{
    return QVector3D(-vector.v[0], -vector.v[1], -vector.v[2]);
}+/

/+pragma(inline, true) const(QVector3D) operator /(ref const(QVector3D) vector, float divisor)
{
    return QVector3D(vector.v[0] / divisor, vector.v[1] / divisor, vector.v[2] / divisor);
}+/

/+pragma(inline, true) const(QVector3D) operator /(ref const(QVector3D) vector, ref const(QVector3D) divisor)
{
    return QVector3D(vector.v[0] / divisor.v[0], vector.v[1] / divisor.v[1], vector.v[2] / divisor.v[2]);
}+/

pragma(inline, true) bool qFuzzyCompare(ref const(QVector3D) v1, ref const(QVector3D) v2)
{
    import qt.core.global;

    return qt.core.global.qFuzzyCompare(v1.v[0], v2.v[0]) &&
           qt.core.global.qFuzzyCompare(v1.v[1], v2.v[1]) &&
           qt.core.global.qFuzzyCompare(v1.v[2], v2.v[2]);
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug dbg, const QVector3D &vector);
#endif

#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QVector3D &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QVector3D &);
#endif +/

}

