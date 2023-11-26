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
    import qt.core.typeinfo;
    import qt.core.variant;
}

version(QT_NO_VECTOR3D)
{
extern(C++, class) struct QVector3D;
}
/+ #if 0
#pragma qt_sync_stop_processing
#endif +/
version(QT_NO_VECTOR3D){}else
{

/// Binding for C++ class [QVector3D](https://doc.qt.io/qt-6/qvector3d.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct QVector3D
{
public:
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.v = [0.0f, 0.0f, 0.0f];
    }+/
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.Initialization)/+ noexcept+/ {}
    this(float xpos, float ypos, float zpos)/+ noexcept+/
    {
        this.v = [xpos, ypos, zpos];
    }

    /+ explicit +/pragma(inline, true) this(QPoint point)/+ noexcept+/
    {
        this.v = [float(point.x()), float(point.y()), 0.0f];
    }
    /+ explicit +/pragma(inline, true) this(QPointF point)/+ noexcept+/
    {
        this.v = [float(point.x()), float(point.y()), 0.0f];
    }
/+ #ifndef QT_NO_VECTOR2D +/
    version(QT_NO_VECTOR2D){}else
    {
        /+ /+ explicit +/pragma(inline, true) this(QVector2D vector)/+ noexcept+/
        {
            this.v = [vector[0], vector[1], 0.0f];
        }
        pragma(inline, true) this(QVector2D vector, float zpos)/+ noexcept+/
        {
            this.v = [vector[0], vector[1], zpos];
        } +/
    }
/+ #endif
#ifndef QT_NO_VECTOR4D +/
    version(QT_NO_VECTOR4D){}else
    {
        /+ /+ explicit +/pragma(inline, true) this(QVector4D vector)/+ noexcept+/
        {
            this.v = [vector[0], vector[1], vector[2]];
        } +/
    }
/+ #endif +/

    pragma(inline, true) bool isNull() const/+ noexcept+/
    {
        import qt.core.global;

        return qIsNull(v[0]) && qIsNull(v[1]) && qIsNull(v[2]);
    }

    pragma(inline, true) float x() const/+ noexcept+/ { return v[0]; }
    pragma(inline, true) float y() const/+ noexcept+/ { return v[1]; }
    pragma(inline, true) float z() const/+ noexcept+/ { return v[2]; }

    pragma(inline, true) void setX(float aX)/+ noexcept+/ { v[0] = aX; }
    pragma(inline, true) void setY(float aY)/+ noexcept+/ { v[1] = aY; }
    pragma(inline, true) void setZ(float aZ)/+ noexcept+/ { v[2] = aZ; }

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

    /+ /+ [[nodiscard]] +/ pragma(inline, true) float length() const/+ noexcept+/
    {
        return qHypot(v[0], v[1], v[2]);
    }
    /+ [[nodiscard]] +/ pragma(inline, true) float lengthSquared() const/+ noexcept+/
    {
        return v[0] * v[0] + v[1] * v[1] + v[2] * v[2];
    }

    /+ [[nodiscard]] +/ pragma(inline, true) QVector3D normalized() const/+ noexcept+/
    {
        import qt.core.global;

        const(float) len = length();
        return qFuzzyIsNull(len - 1.0f) ? this : qFuzzyIsNull(len) ? QVector3D()
            : QVector3D(v[0] / len, v[1] / len, v[2] / len);
    }
    pragma(inline, true) void normalize()/+ noexcept+/
    {
        import qt.core.global;

        const(float) len = length();
        if (qFuzzyIsNull(len - 1.0f) || qFuzzyIsNull(len))
            return;

        v[0] /= len;
        v[1] /= len;
        v[2] /= len;
    } +/

    /+pragma(inline, true) ref QVector3D operator +=(QVector3D vector)/+ noexcept+/
    {
        v[0] += vector.v[0];
        v[1] += vector.v[1];
        v[2] += vector.v[2];
        return this;
    }+/
    /+pragma(inline, true) ref QVector3D operator -=(QVector3D vector)/+ noexcept+/
    {
        v[0] -= vector.v[0];
        v[1] -= vector.v[1];
        v[2] -= vector.v[2];
        return this;
    }+/
    /+pragma(inline, true) ref QVector3D operator *=(float factor)/+ noexcept+/
    {
        v[0] *= factor;
        v[1] *= factor;
        v[2] *= factor;
        return this;
    }+/
    /+pragma(inline, true) ref QVector3D operator *=(QVector3D vector)/+ noexcept+/
    {
        v[0] *= vector.v[0];
        v[1] *= vector.v[1];
        v[2] *= vector.v[2];
        return this;
    }+/
    /+pragma(inline, true) ref QVector3D operator /=(float divisor)
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{divisor < 0 || divisor > 0})));
        v[0] /= divisor;
        v[1] /= divisor;
        v[2] /= divisor;
        return this;
    }+/
    /+pragma(inline, true) ref QVector3D operator /=(QVector3D vector)
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{vector.v[0] > 0 || vector.v[0] < 0})));
        (mixin(Q_ASSERT(q{vector.v[1] > 0 || vector.v[1] < 0})));
        (mixin(Q_ASSERT(q{vector.v[2] > 0 || vector.v[2] < 0})));
        v[0] /= vector.v[0];
        v[1] /= vector.v[1];
        v[2] /= vector.v[2];
        return this;
    }+/

    /+ [[nodiscard]] +/ pragma(inline, true) static float dotProduct(QVector3D v1, QVector3D v2)/+ noexcept+/
    {
        return v1.v[0] * v2.v[0] + v1.v[1] * v2.v[1] + v1.v[2] * v2.v[2];
    }
    /+ [[nodiscard]] +/ pragma(inline, true) static QVector3D crossProduct(QVector3D v1, QVector3D v2)/+ noexcept+/
    {
        return QVector3D(v1.v[1] * v2.v[2] - v1.v[2] * v2.v[1],
                         v1.v[2] * v2.v[0] - v1.v[0] * v2.v[2],
                         v1.v[0] * v2.v[1] - v1.v[1] * v2.v[0]);
    }

    /+ /+ [[nodiscard]] +/ pragma(inline, true) static QVector3D normal(QVector3D v1, QVector3D v2)/+ noexcept+/
    {
        return crossProduct(v1, v2).normalized();
    }
    /+ [[nodiscard]] +/ pragma(inline, true) static QVector3D normal(QVector3D v1, QVector3D v2, QVector3D v3)/+ noexcept+/
    {
        return crossProduct((v2 - v1), (v3 - v1)).normalized();
    } +/

    /+ Q_GUI_EXPORT +/ QVector3D project(ref const(QMatrix4x4) modelView, ref const(QMatrix4x4) projection, ref const(QRect) viewport) const;
    /+ Q_GUI_EXPORT +/ QVector3D unproject(ref const(QMatrix4x4) modelView, ref const(QMatrix4x4) projection, ref const(QRect) viewport) const;

/+ QT_WARNING_PUSH
QT_WARNING_DISABLE_FLOAT_COMPARE +/
    /+ constexpr friend inline bool operator==(QVector3D v1, QVector3D v2) noexcept
    {
        return v1.v[0] == v2.v[0] && v1.v[1] == v2.v[1] && v1.v[2] == v2.v[2];
    } +/

    /+ constexpr friend inline bool operator!=(QVector3D v1, QVector3D v2) noexcept
    {
        return v1.v[0] != v2.v[0] || v1.v[1] != v2.v[1] || v1.v[2] != v2.v[2];
    } +/
/+ QT_WARNING_POP +/
    /+ pragma(inline, true) float distanceToPoint(QVector3D point) const/+ noexcept+/
    {
        return (this - point).length();
    }
    pragma(inline, true) float distanceToPlane(QVector3D plane, QVector3D normal) const/+ noexcept+/
    {
        return dotProduct(this - plane, normal);
    }
    pragma(inline, true) float distanceToPlane(QVector3D plane1, QVector3D plane2, QVector3D plane3) const/+ noexcept+/
    {
        QVector3D n = normal(plane2 - plane1, plane3 - plane1);
        return dotProduct(this - plane1, n);
    }
    pragma(inline, true) float distanceToLine(QVector3D point, QVector3D direction) const/+ noexcept+/
    {
        if (direction.isNull())
            return (this - point).length();
        QVector3D p = cast(QVector3D) (point + dotProduct(this - point, direction) * direction);
        return (this - p).length();
    } +/


    /+ constexpr friend inline QVector3D operator+(QVector3D v1, QVector3D v2) noexcept
    {
        return QVector3D(v1.v[0] + v2.v[0], v1.v[1] + v2.v[1], v1.v[2] + v2.v[2]);
    } +/

    /+ constexpr friend inline QVector3D operator-(QVector3D v1, QVector3D v2) noexcept
    {
        return QVector3D(v1.v[0] - v2.v[0], v1.v[1] - v2.v[1], v1.v[2] - v2.v[2]);
    } +/

    /+ constexpr friend inline QVector3D operator*(float factor, QVector3D vector) noexcept
    {
        return QVector3D(vector.v[0] * factor, vector.v[1] * factor, vector.v[2] * factor);
    } +/

    /+ constexpr friend inline QVector3D operator*(QVector3D vector, float factor) noexcept
    {
        return QVector3D(vector.v[0] * factor, vector.v[1] * factor, vector.v[2] * factor);
    } +/

    /+ constexpr friend inline QVector3D operator*(QVector3D v1, QVector3D v2) noexcept
    {
        return QVector3D(v1.v[0] * v2.v[0], v1.v[1] * v2.v[1], v1.v[2] * v2.v[2]);
    } +/

    /+ constexpr friend inline QVector3D operator-(QVector3D vector) noexcept
    {
        return QVector3D(-vector.v[0], -vector.v[1], -vector.v[2]);
    } +/

    /+ constexpr friend inline QVector3D operator/(QVector3D vector, float divisor)
    {
        Q_ASSERT(divisor < 0 || divisor > 0);
        return QVector3D(vector.v[0] / divisor, vector.v[1] / divisor, vector.v[2] / divisor);
    } +/

    /+ constexpr friend inline QVector3D operator/(QVector3D vector, QVector3D divisor)
    {
        Q_ASSERT(divisor.v[0] > 0 || divisor.v[0] < 0);
        Q_ASSERT(divisor.v[1] > 0 || divisor.v[1] < 0);
        Q_ASSERT(divisor.v[2] > 0 || divisor.v[2] < 0);
        return QVector3D(vector.v[0] / divisor.v[0], vector.v[1] / divisor.v[1],
                         vector.v[2] / divisor.v[2]);
    } +/

    /+ friend Q_GUI_EXPORT bool qFuzzyCompare(QVector3D v1, QVector3D v2) noexcept; +/

/+ #ifndef QT_NO_VECTOR2D +/
    version(QT_NO_VECTOR2D){}else
    {
        pragma(inline, true) QVector2D toVector2D() const/+ noexcept+/
        {
            return QVector2D(v[0], v[1]);
        }
    }
/+ #endif
#ifndef QT_NO_VECTOR4D +/
    version(QT_NO_VECTOR4D){}else
    {
        pragma(inline, true) QVector4D toVector4D() const/+ noexcept+/
        {
            return QVector4D(v[0], v[1], v[2], 0.0f);
        }
    }
/+ #endif +/

    pragma(inline, true) QPoint toPoint() const/+ noexcept+/
    {
        import qt.core.global;

        return QPoint(qRound(v[0]), qRound(v[1]));
    }
    pragma(inline, true) QPointF toPointF() const/+ noexcept+/
    {
        import qt.core.global;

        return QPointF(qreal(v[0]), qreal(v[1]));
    }

    /+/+ Q_GUI_EXPORT +/ auto opCast(T : QVariant)() const;+/

private:
    float[3] v = [0.0f, 0.0f, 0.0f];

    /+ friend class QVector2D; +/
    /+ friend class QVector4D; +/
    static if (!defined!"QT_NO_MATRIX4X4")
    {
        /+ friend QVector3D operator*(const QVector3D& vector, const QMatrix4x4& matrix); +/
        /+ friend QVector3D operator*(const QMatrix4x4& matrix, const QVector3D& vector); +/
    }

    /+ template <std::size_t I,
              typename V,
              std::enable_if_t<(I < 3), bool> = true,
              std::enable_if_t<std::is_same_v<std::decay_t<V>, QVector3D>, bool> = true> +/
    /+ friend constexpr decltype(auto) get(V &&vec) noexcept
    {
        static if (I == 0)
            return (std::forward<V>(vec).v[0]);
        else static if (I == 1)
            return (std::forward<V>(vec).v[1]);
        else static if (I == 2)
            return (std::forward<V>(vec).v[2]);
    } +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
}

