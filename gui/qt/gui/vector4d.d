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
version (QT_NO_VECTOR2D) {} else
version (QT_NO_VECTOR4D) {} else
    import qt.gui.vector2d;
version (QT_NO_VECTOR3D) {} else
version (QT_NO_VECTOR4D) {} else
    import qt.gui.vector3d;
version (QT_NO_VECTOR4D) {} else
{
    import qt.core.namespace;
    import qt.core.point;
    import qt.core.typeinfo;
    import qt.core.variant;
}

version (QT_NO_VECTOR4D)
{
extern(C++, class) struct QVector4D;
}
/+ #if 0
#pragma qt_sync_stop_processing
#endif +/
version (QT_NO_VECTOR4D) {} else
{

/// Binding for C++ class [QVector4D](https://doc.qt.io/qt-6/qvector4d.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct QVector4D
{
public:
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.v = [0.0f, 0.0f, 0.0f, 0.0f];
    }+/
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.Initialization)/+ noexcept+/ {}
    pragma(inline, true) this(float xpos, float ypos, float zpos, float wpos)/+ noexcept+/
    {
        this.v = [xpos, ypos, zpos, wpos];
    }
    /+ explicit +/pragma(inline, true) this(QPoint point)/+ noexcept+/
    {
        this.v = [float(point.x()), float(point.y()), 0.0f, 0.0f];
    }
    /+ explicit +/pragma(inline, true) this(QPointF point)/+ noexcept+/
    {
        this.v = [float(point.x()), float(point.y()), 0.0f, 0.0f];
    }
/+ #ifndef QT_NO_VECTOR2D +/
    version (QT_NO_VECTOR2D) {} else
    {
        /+ /+ explicit +/this(QVector2D vector)/+ noexcept+/
        {
            this.v = [vector[0], vector[1], 0.0f, 0.0f];
        }
        this(QVector2D vector, float zpos, float wpos)/+ noexcept+/
        {
            this.v = [vector[0], vector[1], zpos, wpos];
        } +/
    }
/+ #endif
#ifndef QT_NO_VECTOR3D +/
    version (QT_NO_VECTOR3D) {} else
    {
        /+ /+ explicit +/this(QVector3D vector)/+ noexcept+/
        {
            this.v = [vector[0], vector[1], vector[2], 0.0f];
        }
        this(QVector3D vector, float wpos)/+ noexcept+/
        {
            this.v = [vector[0], vector[1], vector[2], wpos];
        } +/
    }
/+ #endif +/

    pragma(inline, true) bool isNull() const/+ noexcept+/
    {
        import qt.core.global;

        return qIsNull(v[0]) && qIsNull(v[1]) && qIsNull(v[2]) && qIsNull(v[3]);
    }

    pragma(inline, true) float x() const/+ noexcept+/ { return v[0]; }
    pragma(inline, true) float y() const/+ noexcept+/ { return v[1]; }
    pragma(inline, true) float z() const/+ noexcept+/ { return v[2]; }
    pragma(inline, true) float w() const/+ noexcept+/ { return v[3]; }

    pragma(inline, true) void setX(float aX)/+ noexcept+/ { v[0] = aX; }
    pragma(inline, true) void setY(float aY)/+ noexcept+/ { v[1] = aY; }
    pragma(inline, true) void setZ(float aZ)/+ noexcept+/ { v[2] = aZ; }
    pragma(inline, true) void setW(float aW)/+ noexcept+/ { v[3] = aW; }

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

    /+ /+ [[nodiscard]] +/ pragma(inline, true) float length() const/+ noexcept+/
    {
        return qHypot(v[0], v[1], v[2], v[3]);
    }
    /+ [[nodiscard]] +/ pragma(inline, true) float lengthSquared() const/+ noexcept+/
    {
        return v[0] * v[0] + v[1] * v[1] + v[2] * v[2] + v[3] * v[3];
    }

    /+ [[nodiscard]] +/ pragma(inline, true) QVector4D normalized() const/+ noexcept+/
    {
        import qt.core.global;

        const(float) len = length();
        return qFuzzyIsNull(len - 1.0f) ? this : qFuzzyIsNull(len) ? QVector4D()
            : QVector4D(v[0] / len, v[1] / len, v[2] / len, v[3] / len);
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
        v[3] /= len;
    } +/

    /+pragma(inline, true) ref QVector4D operator +=(QVector4D vector)/+ noexcept+/
    {
        v[0] += vector.v[0];
        v[1] += vector.v[1];
        v[2] += vector.v[2];
        v[3] += vector.v[3];
        return this;
    }+/
    /+pragma(inline, true) ref QVector4D operator -=(QVector4D vector)/+ noexcept+/
    {
        v[0] -= vector.v[0];
        v[1] -= vector.v[1];
        v[2] -= vector.v[2];
        v[3] -= vector.v[3];
        return this;
    }+/
    /+pragma(inline, true) ref QVector4D operator *=(float factor)/+ noexcept+/
    {
        v[0] *= factor;
        v[1] *= factor;
        v[2] *= factor;
        v[3] *= factor;
        return this;
    }+/
    /+pragma(inline, true) ref QVector4D operator *=(QVector4D vector)/+ noexcept+/
    {
        v[0] *= vector.v[0];
        v[1] *= vector.v[1];
        v[2] *= vector.v[2];
        v[3] *= vector.v[3];
        return this;
    }+/
    /+pragma(inline, true) ref QVector4D operator /=(float divisor)
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{divisor < 0 || divisor > 0})));
        v[0] /= divisor;
        v[1] /= divisor;
        v[2] /= divisor;
        v[3] /= divisor;
        return this;
    }+/
    /+pragma(inline, true) ref QVector4D operator /=(QVector4D vector)
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{vector.v[0] > 0 || vector.v[0] < 0})));
        (mixin(Q_ASSERT(q{vector.v[1] > 0 || vector.v[1] < 0})));
        (mixin(Q_ASSERT(q{vector.v[2] > 0 || vector.v[2] < 0})));
        (mixin(Q_ASSERT(q{vector.v[3] > 0 || vector.v[3] < 0})));
        v[0] /= vector.v[0];
        v[1] /= vector.v[1];
        v[2] /= vector.v[2];
        v[3] /= vector.v[3];
        return this;
    }+/

    /+ [[nodiscard]] +/ static float dotProduct(QVector4D v1, QVector4D v2)/+ noexcept+/
    {
        return v1.v[0] * v2.v[0] + v1.v[1] * v2.v[1] + v1.v[2] * v2.v[2] + v1.v[3] * v2.v[3];
    }

/+ QT_WARNING_PUSH
QT_WARNING_DISABLE_FLOAT_COMPARE +/
    /+ constexpr friend inline bool operator==(QVector4D v1, QVector4D v2) noexcept
    {
        return v1.v[0] == v2.v[0] && v1.v[1] == v2.v[1] && v1.v[2] == v2.v[2] && v1.v[3] == v2.v[3];
    } +/

    /+ constexpr friend inline bool operator!=(QVector4D v1, QVector4D v2) noexcept
    {
        return v1.v[0] != v2.v[0] || v1.v[1] != v2.v[1] || v1.v[2] != v2.v[2] || v1.v[3] != v2.v[3];
    } +/
/+ QT_WARNING_POP +/
    /+ constexpr friend inline QVector4D operator+(QVector4D v1, QVector4D v2) noexcept
    {
        return QVector4D(v1.v[0] + v2.v[0], v1.v[1] + v2.v[1], v1.v[2] + v2.v[2], v1.v[3] + v2.v[3]);
    } +/

    /+ constexpr friend inline QVector4D operator-(QVector4D v1, QVector4D v2) noexcept
    {
        return QVector4D(v1.v[0] - v2.v[0], v1.v[1] - v2.v[1], v1.v[2] - v2.v[2], v1.v[3] - v2.v[3]);
    } +/

    /+ constexpr friend inline QVector4D operator*(float factor, QVector4D vector) noexcept
    {
        return QVector4D(vector.v[0] * factor, vector.v[1] * factor, vector.v[2] * factor, vector.v[3] * factor);
    } +/

    /+ constexpr friend inline QVector4D operator*(QVector4D vector, float factor) noexcept
    {
        return QVector4D(vector.v[0] * factor, vector.v[1] * factor, vector.v[2] * factor, vector.v[3] * factor);
    } +/

    /+ constexpr friend inline QVector4D operator*(QVector4D v1, QVector4D v2) noexcept
    {
        return QVector4D(v1.v[0] * v2.v[0], v1.v[1] * v2.v[1], v1.v[2] * v2.v[2], v1.v[3] * v2.v[3]);
    } +/

    /+ constexpr friend inline QVector4D operator-(QVector4D vector) noexcept
    {
        return QVector4D(-vector.v[0], -vector.v[1], -vector.v[2], -vector.v[3]);
    } +/

    /+ constexpr friend inline QVector4D operator/(QVector4D vector, float divisor)
    {
        Q_ASSERT(divisor < 0 || divisor > 0);
        return QVector4D(vector.v[0] / divisor, vector.v[1] / divisor, vector.v[2] / divisor, vector.v[3] / divisor);
    } +/

    /+ constexpr friend inline QVector4D operator/(QVector4D vector, QVector4D divisor)
    {
        Q_ASSERT(divisor.v[0] > 0 || divisor.v[0] < 0);
        Q_ASSERT(divisor.v[1] > 0 || divisor.v[1] < 0);
        Q_ASSERT(divisor.v[2] > 0 || divisor.v[2] < 0);
        Q_ASSERT(divisor.v[3] > 0 || divisor.v[3] < 0);
        return QVector4D(vector.v[0] / divisor.v[0], vector.v[1] / divisor.v[1],
                         vector.v[2] / divisor.v[2], vector.v[3] / divisor.v[3]);
    } +/

    /+ friend Q_GUI_EXPORT bool qFuzzyCompare(QVector4D v1, QVector4D v2) noexcept; +/

/+ #ifndef QT_NO_VECTOR2D +/
    version (QT_NO_VECTOR2D) {} else
    {
        pragma(inline, true) QVector2D toVector2D() const/+ noexcept+/
        {
            return QVector2D(v[0], v[1]);
        }
        pragma(inline, true) QVector2D toVector2DAffine() const/+ noexcept+/
        {
            import qt.core.global;

            if (qIsNull(v[3]))
                return QVector2D();
            return QVector2D(v[0] / v[3], v[1] / v[3]);
        }
    }
/+ #endif
#ifndef QT_NO_VECTOR3D +/
    version (QT_NO_VECTOR3D) {} else
    {
        pragma(inline, true) QVector3D toVector3D() const/+ noexcept+/
        {
            return QVector3D(v[0], v[1], v[2]);
        }
        QVector3D toVector3DAffine() const/+ noexcept+/
        {
            import qt.core.global;

            if (qIsNull(v[3]))
                return QVector3D();
            return QVector3D(v[0] / v[3], v[1] / v[3], v[2] / v[3]);
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
    float[4] v = [0.0f, 0.0f, 0.0f, 0.0f];

    /+ friend class QVector2D; +/
    /+ friend class QVector3D; +/
    /+ friend class QMatrix4x4; +/
    static if (!defined!"QT_NO_MATRIX4X4")
    {
        /+ friend QVector4D operator*(const QVector4D& vector, const QMatrix4x4& matrix); +/
        /+ friend QVector4D operator*(const QMatrix4x4& matrix, const QVector4D& vector); +/
    }

    /+ template <std::size_t I,
              typename V,
              std::enable_if_t<(I < 4), bool> = true,
              std::enable_if_t<std::is_same_v<std::decay_t<V>, QVector4D>, bool> = true> +/
    /+ friend constexpr decltype(auto) get(V &&vec) noexcept
    {
        static if (I == 0)
            return (std::forward<V>(vec).v[0]);
        else static if (I == 1)
            return (std::forward<V>(vec).v[1]);
        else static if (I == 2)
            return (std::forward<V>(vec).v[2]);
        else static if (I == 3)
            return (std::forward<V>(vec).v[3]);
    } +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
}

