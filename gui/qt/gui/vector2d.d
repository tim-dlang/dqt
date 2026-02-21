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
version (QT_NO_VECTOR2D) {} else
version (QT_NO_VECTOR3D) {} else
    import qt.gui.vector3d;
version (QT_NO_VECTOR2D) {} else
version (QT_NO_VECTOR4D) {} else
    import qt.gui.vector4d;
version (QT_NO_VECTOR2D) {} else
{
    import qt.core.namespace;
    import qt.core.point;
    import qt.core.typeinfo;
    import qt.core.variant;
}

version (QT_NO_VECTOR2D)
{
extern(C++, class) struct QVector2D;
}
/+ #if 0
#pragma qt_sync_stop_processing
#endif +/
version (QT_NO_VECTOR2D) {} else
{

/// Binding for C++ class [QVector2D](https://doc.qt.io/qt-6/qvector2d.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct QVector2D
{
public:
    /+pragma(inline, true) this() nothrow
    {
        this.v = [0.0f, 0.0f];
    }+/
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.Initialization) nothrow {}
    pragma(inline, true) this(float xpos, float ypos) nothrow
    {
        this.v = [xpos, ypos];
    }
    /+ explicit +/pragma(inline, true) this(QPoint point) nothrow
    {
        this.v = [float(point.x()), float(point.y())];
    }
    /+ explicit +/pragma(inline, true) this(QPointF point) nothrow
    {
        this.v = [float(point.x()), float(point.y())];
    }
/+ #ifndef QT_NO_VECTOR3D +/
    version (QT_NO_VECTOR3D) {} else
    {
/*        /+ explicit +/pragma(inline, true) this(QVector3D vector) nothrow
        {
            this.v = [vector[0], vector[1]];
        }*/
    }
/+ #endif
#ifndef QT_NO_VECTOR4D +/
    version (QT_NO_VECTOR4D) {} else
    {
/*        /+ explicit +/pragma(inline, true) this(QVector4D vector) nothrow
        {
            this.v = [vector[0], vector[1]];
        }*/
    }
/+ #endif +/

    pragma(inline, true) bool isNull() const nothrow
    {
        import qt.core.global;

        return qIsNull(v[0]) && qIsNull(v[1]);
    }

    pragma(inline, true) float x() const nothrow { return v[0]; }
    pragma(inline, true) float y() const nothrow { return v[1]; }

    pragma(inline, true) void setX(float aX) nothrow { v[0] = aX; }
    pragma(inline, true) void setY(float aY) nothrow { v[1] = aY; }

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

    /+ /+ [[nodiscard]] +/ pragma(inline, true) float length() const nothrow
    {
        return qHypot(v[0], v[1]);
    } +/
    /+ [[nodiscard]] +/ pragma(inline, true) float lengthSquared() const nothrow
    {
        return v[0] * v[0] + v[1] * v[1];
    }

    /+ /+ [[nodiscard]] +/ pragma(inline, true) QVector2D normalized() const nothrow
    {
        import qt.core.global;

        const(float) len = length();
        return qFuzzyIsNull(len - 1.0f) ? this : qFuzzyIsNull(len) ? QVector2D()
            : QVector2D(v[0] / len, v[1] / len);
    }
    pragma(inline, true) void normalize() nothrow
    {
        import qt.core.global;

        const(float) len = length();
        if (qFuzzyIsNull(len - 1.0f) || qFuzzyIsNull(len))
            return;

        v[0] /= len;
        v[1] /= len;
    } +/

    /+ /+ [[nodiscard]] +/ pragma(inline, true) float distanceToPoint(QVector2D point) const nothrow
    {
        return (this - point).length();
    }
    /+ [[nodiscard]] +/ pragma(inline, true) float distanceToLine(QVector2D point, QVector2D direction) const nothrow
    {
        if (direction.isNull())
            return (this - point).length();
        QVector2D p = cast(QVector2D) (point + dotProduct(this - point, direction) * direction);
        return (this - p).length();
    } +/

    /+pragma(inline, true) ref QVector2D operator +=(QVector2D vector) nothrow
    {
        v[0] += vector.v[0];
        v[1] += vector.v[1];
        return this;
    }+/
    /+pragma(inline, true) ref QVector2D operator -=(QVector2D vector) nothrow
    {
        v[0] -= vector.v[0];
        v[1] -= vector.v[1];
        return this;
    }+/
    /+pragma(inline, true) ref QVector2D operator *=(float factor) nothrow
    {
        v[0] *= factor;
        v[1] *= factor;
        return this;
    }+/
    /+pragma(inline, true) ref QVector2D operator *=(QVector2D vector) nothrow
    {
        v[0] *= vector.v[0];
        v[1] *= vector.v[1];
        return this;
    }+/
    /+pragma(inline, true) ref QVector2D operator /=(float divisor)
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{divisor < 0 || divisor > 0})));
        v[0] /= divisor;
        v[1] /= divisor;
        return this;
    }+/
    /+pragma(inline, true) ref QVector2D operator /=(QVector2D vector)
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{vector.v[0] > 0 || vector.v[0] < 0})));
        (mixin(Q_ASSERT(q{vector.v[1] > 0 || vector.v[1] < 0})));
        v[0] /= vector.v[0];
        v[1] /= vector.v[1];
        return this;
    }+/

    /+ [[nodiscard]] +/ pragma(inline, true) static float dotProduct(QVector2D v1, QVector2D v2) nothrow
    {
        return v1.v[0] * v2.v[0] + v1.v[1] * v2.v[1];
    }

/+ QT_WARNING_PUSH
QT_WARNING_DISABLE_FLOAT_COMPARE +/
    /+ constexpr friend inline bool operator==(QVector2D v1, QVector2D v2) noexcept
    {
        return v1.v[0] == v2.v[0] && v1.v[1] == v2.v[1];
    } +/

    /+ constexpr friend inline bool operator!=(QVector2D v1, QVector2D v2) noexcept
    {
        return v1.v[0] != v2.v[0] || v1.v[1] != v2.v[1];
    } +/
/+ QT_WARNING_POP +/

    /+ constexpr friend inline QVector2D operator+(QVector2D v1, QVector2D v2) noexcept
    {
        return QVector2D(v1.v[0] + v2.v[0], v1.v[1] + v2.v[1]);
    } +/

    /+ constexpr friend inline QVector2D operator-(QVector2D v1, QVector2D v2) noexcept
    {
        return QVector2D(v1.v[0] - v2.v[0], v1.v[1] - v2.v[1]);
    } +/

    /+ constexpr friend inline QVector2D operator*(float factor, QVector2D vector) noexcept
    {
        return QVector2D(vector.v[0] * factor, vector.v[1] * factor);
    } +/

    /+ constexpr friend inline QVector2D operator*(QVector2D vector, float factor) noexcept
    {
        return QVector2D(vector.v[0] * factor, vector.v[1] * factor);
    } +/

    /+ constexpr friend inline QVector2D operator*(QVector2D v1, QVector2D v2) noexcept
    {
        return QVector2D(v1.v[0] * v2.v[0], v1.v[1] * v2.v[1]);
    } +/

    /+ constexpr friend inline QVector2D operator-(QVector2D vector) noexcept
    {
        return QVector2D(-vector.v[0], -vector.v[1]);
    } +/

    /+ constexpr friend inline QVector2D operator/(QVector2D vector, float divisor)
    {
        Q_ASSERT(divisor < 0 || divisor > 0);
        return QVector2D(vector.v[0] / divisor, vector.v[1] / divisor);
    } +/

    /+ constexpr friend inline QVector2D operator/(QVector2D vector, QVector2D divisor)
    {
        Q_ASSERT(divisor.v[0] < 0 || divisor.v[0] > 0);
        Q_ASSERT(divisor.v[1] < 0 || divisor.v[1] > 0);
        return QVector2D(vector.v[0] / divisor.v[0], vector.v[1] / divisor.v[1]);
    } +/

    /+ friend Q_GUI_EXPORT bool qFuzzyCompare(QVector2D v1, QVector2D v2) noexcept; +/

/+ #ifndef QT_NO_VECTOR3D +/
    version (QT_NO_VECTOR3D) {} else
    {
        pragma(inline, true) QVector3D toVector3D() const nothrow
        {
            return QVector3D(v[0], v[1], 0.0f);
        }
    }
/+ #endif
#ifndef QT_NO_VECTOR4D +/
    version (QT_NO_VECTOR4D) {} else
    {
        pragma(inline, true) QVector4D toVector4D() const nothrow
        {
            return QVector4D(v[0], v[1], 0.0f, 0.0f);
        }
    }
/+ #endif +/

    pragma(inline, true) QPoint toPoint() const nothrow
    {
        import qt.core.global;

        return QPoint(qRound(v[0]), qRound(v[1]));
    }
    pragma(inline, true) QPointF toPointF() const nothrow
    {
        import qt.core.global;

        return QPointF(qreal(v[0]), qreal(v[1]));
    }

    /+/+ Q_GUI_EXPORT +/ auto opCast(T : QVariant)() const;+/

private:
    float[2] v = [0.0f, 0.0f];

    /+ friend class QVector3D; +/
    /+ friend class QVector4D; +/

    /+ template <std::size_t I,
              typename V,
              std::enable_if_t<(I < 2), bool> = true,
              std::enable_if_t<std::is_same_v<std::decay_t<V>, QVector2D>, bool> = true> +/
    /+ friend constexpr decltype(auto) get(V &&vec) noexcept
    {
        static if (I == 0)
            return (std::forward<V>(vec).v[0]);
        else static if (I == 1)
            return (std::forward<V>(vec).v[1]);
    } +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
}

