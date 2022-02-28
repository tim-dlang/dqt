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
module qt.core.point;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.typeinfo;
import qt.helpers;

/+ #if defined(Q_OS_DARWIN) || defined(Q_QDOC)
struct CGPoint;
#endif +/


/// Binding for C++ class [QPoint](https://doc.qt.io/qt-6/qpoint.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct QPoint
{
public:
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.xp = 0;
        this.yp = 0;
    }+/
    pragma(inline, true) this(int xpos, int ypos)/+ noexcept+/
    {
        this.xp = xpos;
        this.yp = ypos;
    }

    pragma(inline, true) bool isNull() const/+ noexcept+/
    {
        return xp == 0 && yp == 0;
    }

    pragma(inline, true) int x() const/+ noexcept+/
    {
        return xp;
    }
    pragma(inline, true) int y() const/+ noexcept+/
    {
        return yp;
    }
    pragma(inline, true) void setX(int xpos)/+ noexcept+/
    {
        xp = xpos;
    }
    pragma(inline, true) void setY(int ypos)/+ noexcept+/
    {
        yp = ypos;
    }

    pragma(inline, true) int manhattanLength() const
    {
        return qAbs(x()) + qAbs(y());
    }

    QPoint transposed() const/+ noexcept+/ { return QPoint(yp, xp); }

    pragma(inline, true) ref int rx()/+ noexcept+/ return
    {
        return xp;
    }
    pragma(inline, true) ref int ry()/+ noexcept+/ return
    {
        return yp;
    }

    pragma(inline, true) ref QPoint opOpAssign(string op)(ref const(QPoint) p) if(op == "+")
    {
        xp += p.xp;
        yp += p.yp;
        return this;
    }
    pragma(inline, true) ref QPoint opOpAssign(string op)(ref const(QPoint) p) if(op == "-")
    {
        xp -= p.xp;
        yp -= p.yp;
        return this;
    }

    /+pragma(inline, true) ref QPoint operator *=(float factor)
    {
        xp = qRound(xp * factor);
        yp = qRound(yp * factor);
        return this;
    }+/
    /+pragma(inline, true) ref QPoint operator *=(double factor)
    {
        xp = qRound(xp * factor);
        yp = qRound(yp * factor);
        return this;
    }+/
    /+pragma(inline, true) ref QPoint operator *=(int factor)
    {
        xp = xp * factor;
        yp = yp * factor;
        return this;
    }+/

    /+pragma(inline, true) ref QPoint operator /=(qreal c)
    {
        xp = qRound(xp / c);
        yp = qRound(yp / c);
        return this;
    }+/

    pragma(inline, true) static int dotProduct(ref const(QPoint) p1, ref const(QPoint) p2)
    { return p1.xp * p2.xp + p1.yp * p2.yp; }

    /+ friend constexpr inline bool operator==(const QPoint &p1, const QPoint &p2) noexcept
    { return p1.xp == p2.xp && p1.yp == p2.yp; } +/
    /+ friend constexpr inline bool operator!=(const QPoint &p1, const QPoint &p2) noexcept
    { return p1.xp != p2.xp || p1.yp != p2.yp; } +/
    /+ friend constexpr inline QPoint operator+(const QPoint &p1, const QPoint &p2) noexcept
    { return QPoint(p1.xp + p2.xp, p1.yp + p2.yp); } +/
    /+ friend constexpr inline QPoint operator-(const QPoint &p1, const QPoint &p2) noexcept
    { return QPoint(p1.xp - p2.xp, p1.yp - p2.yp); } +/
    /+ friend constexpr inline QPoint operator*(const QPoint &p, float factor)
    { return QPoint(qRound(p.xp * factor), qRound(p.yp * factor)); } +/
    /+ friend constexpr inline QPoint operator*(const QPoint &p, double factor)
    { return QPoint(qRound(p.xp * factor), qRound(p.yp * factor)); } +/
    /+ friend constexpr inline QPoint operator*(const QPoint &p, int factor) noexcept
    { return QPoint(p.xp * factor, p.yp * factor); } +/
    /+ friend constexpr inline QPoint operator*(float factor, const QPoint &p)
    { return QPoint(qRound(p.xp * factor), qRound(p.yp * factor)); } +/
    /+ friend constexpr inline QPoint operator*(double factor, const QPoint &p)
    { return QPoint(qRound(p.xp * factor), qRound(p.yp * factor)); } +/
    /+ friend constexpr inline QPoint operator*(int factor, const QPoint &p) noexcept
    { return QPoint(p.xp * factor, p.yp * factor); } +/
    /+ friend constexpr inline QPoint operator+(const QPoint &p) noexcept
    { return p; } +/
    /+ friend constexpr inline QPoint operator-(const QPoint &p) noexcept
    { return QPoint(-p.xp, -p.yp); } +/
    /+ friend constexpr inline QPoint operator/(const QPoint &p, qreal c)
    { return QPoint(qRound(p.xp / c), qRound(p.yp / c)); } +/

    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ [[nodiscard]] Q_CORE_EXPORT CGPoint toCGPoint() const noexcept; +/
    }


    pragma(inline, true) const(QPoint) opBinary(string op)(const(QPoint) p2) const if(op == "+")
    { return QPoint(xp+p2.xp, yp+p2.yp); }

    pragma(inline, true) const(QPoint) opBinary(string op)(const(QPoint) p2) const if(op == "-")
    { return QPoint(xp-p2.xp, yp-p2.yp); }


private:
    /+ friend class QTransform; +/
    int xp = 0;
    int yp = 0;

    /+ template <std::size_t I,
              typename P,
              std::enable_if_t<(I < 2), bool> = true,
              std::enable_if_t<std::is_same_v<std::decay_t<P>, QPoint>, bool> = true> +/
    /+ friend constexpr decltype(auto) get(P &&p) noexcept
    {
        static if (I == 0)
            return (std::forward<P>(p).xp);
        else static if (I == 1)
            return (std::forward<P>(p).yp);
    } +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QPoint, Q_PRIMITIVE_TYPE);

/*****************************************************************************
  QPoint stream functions
 *****************************************************************************/
#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QPoint &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QPoint &);
#endif

/*****************************************************************************
  QPoint inline functions
 *****************************************************************************/

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QPoint &);
#endif

Q_CORE_EXPORT size_t qHash(QPoint key, size_t seed = 0) noexcept; +/




/// Binding for C++ class [QPointF](https://doc.qt.io/qt-6/qpointf.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct QPointF
{
public:
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.xp = 0;
        this.yp = 0;
    }+/
    pragma(inline, true) this(ref const(QPoint) p)/+ noexcept+/
    {
        this.xp = p.x();
        this.yp = p.y();
    }
    pragma(inline, true) this(qreal xpos, qreal ypos)/+ noexcept+/
    {
        this.xp = xpos;
        this.yp = ypos;
    }

    pragma(inline, true) qreal manhattanLength() const
    {
        return qAbs(x()) + qAbs(y());
    }

    pragma(inline, true) bool isNull() const/+ noexcept+/
    {
        return qIsNull(xp) && qIsNull(yp);
    }

    pragma(inline, true) qreal x() const/+ noexcept+/
    {
        return xp;
    }
    pragma(inline, true) qreal y() const/+ noexcept+/
    {
        return yp;
    }
    pragma(inline, true) void setX(qreal xpos)/+ noexcept+/
    {
        xp = xpos;
    }
    pragma(inline, true) void setY(qreal ypos)/+ noexcept+/
    {
        yp = ypos;
    }

    QPointF transposed() const/+ noexcept+/ { return QPointF(yp, xp); }

    pragma(inline, true) ref qreal rx() return /+ noexcept+/
    {
        return xp;
    }
    pragma(inline, true) ref qreal ry() return /+ noexcept+/
    {
        return yp;
    }

    pragma(inline, true) ref QPointF opOpAssign(string op)(ref const(QPointF) p) if(op == "+")
    {
        xp += p.xp;
        yp += p.yp;
        return this;
    }
    pragma(inline, true) ref QPointF opOpAssign(string op)(ref const(QPointF) p) if(op == "-")
    {
        xp -= p.xp;
        yp -= p.yp;
        return this;
    }
    /+pragma(inline, true) ref QPointF operator *=(qreal c)
    {
        xp *= c;
        yp *= c;
        return this;
    }+/
    /+pragma(inline, true) ref QPointF operator /=(qreal divisor)
    {
        (mixin(Q_ASSERT(q{divisor > 0 || divisor < 0})));
        xp /= divisor;
        yp /= divisor;
        return this;
    }+/

    pragma(inline, true) static qreal dotProduct(ref const(QPointF) p1, ref const(QPointF) p2)
    {
        return p1.xp * p2.xp + p1.yp * p2.yp;
    }

    /+ QT_WARNING_PUSH
    QT_WARNING_DISABLE_FLOAT_COMPARE +/
    /+ friend constexpr inline bool operator==(const QPointF &p1, const QPointF &p2)
    {
        return ((!p1.xp || !p2.xp) ? qFuzzyIsNull(p1.xp - p2.xp) : qFuzzyCompare(p1.xp, p2.xp))
            && ((!p1.yp || !p2.yp) ? qFuzzyIsNull(p1.yp - p2.yp) : qFuzzyCompare(p1.yp, p2.yp));
    } +/
    /+ friend constexpr inline bool operator!=(const QPointF &p1, const QPointF &p2)
    {
        return !(p1 == p2);
    } +/
    /+ QT_WARNING_POP +/

    /+ friend constexpr inline QPointF operator+(const QPointF &p1, const QPointF &p2)
    { return QPointF(p1.xp + p2.xp, p1.yp + p2.yp); } +/
    /+ friend constexpr inline QPointF operator-(const QPointF &p1, const QPointF &p2)
    { return QPointF(p1.xp - p2.xp, p1.yp - p2.yp); } +/
    /+ friend constexpr inline QPointF operator*(const QPointF &p, qreal c)
    { return QPointF(p.xp * c, p.yp * c); } +/
    /+ friend constexpr inline QPointF operator*(qreal c, const QPointF &p)
    { return QPointF(p.xp * c, p.yp * c); } +/
    /+ friend constexpr inline QPointF operator+(const QPointF &p)
    { return p; } +/
    /+ friend constexpr inline QPointF operator-(const QPointF &p)
    { return QPointF(-p.xp, -p.yp); } +/
    /+ friend constexpr inline QPointF operator/(const QPointF &p, qreal divisor)
    {
        Q_ASSERT(divisor < 0 || divisor > 0);
        return QPointF(p.xp / divisor, p.yp / divisor);
    } +/

    pragma(inline, true) QPoint toPoint() const
    {
        return QPoint(qRound(xp), qRound(yp));
    }

    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ [[nodiscard]] Q_CORE_EXPORT static QPointF fromCGPoint(CGPoint point) noexcept; +/
        /+ [[nodiscard]] Q_CORE_EXPORT CGPoint toCGPoint() const noexcept; +/
    }

    pragma(inline, true) const(QPointF) opBinary(string op)(const(QPointF) p2) const if(op == "+")
    { return QPointF(xp+p2.xp, yp+p2.yp); }

    pragma(inline, true) const(QPointF) opBinary(string op)(const(QPointF) p2) const if(op == "-")
    { return QPointF(xp-p2.xp, yp-p2.yp); }

private:
    /+ friend class QTransform; +/

    qreal xp = 0;
    qreal yp = 0;

    /+ template <std::size_t I,
              typename P,
              std::enable_if_t<(I < 2), bool> = true,
              std::enable_if_t<std::is_same_v<std::decay_t<P>, QPointF>, bool> = true> +/
    /+ friend constexpr decltype(auto) get(P &&p) noexcept
    {
        static if (I == 0)
            return (std::forward<P>(p).xp);
        else static if (I == 1)
            return (std::forward<P>(p).yp);
    } +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QPointF, Q_PRIMITIVE_TYPE);

size_t qHash(QPointF, size_t seed = 0) = delete;

/*****************************************************************************
  QPointF stream functions
 *****************************************************************************/
#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QPointF &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QPointF &);
#endif

/*****************************************************************************
  QPointF inline functions
 *****************************************************************************/

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug d, const QPointF &p);
#endif


/*****************************************************************************
  QPoint/QPointF tuple protocol
 *****************************************************************************/

namespace std {
    template <>
    class tuple_size<QT_PREPEND_NAMESPACE(QPoint)> : public integral_constant<size_t, 2> {};
    template <>
    class tuple_element<0, QT_PREPEND_NAMESPACE(QPoint)> { public: using type = int; };
    template <>
    class tuple_element<1, QT_PREPEND_NAMESPACE(QPoint)> { public: using type = int; };

    template <>
    class tuple_size<QT_PREPEND_NAMESPACE(QPointF)> : public integral_constant<size_t, 2> {};
    template <>
    class tuple_element<0, QT_PREPEND_NAMESPACE(QPointF)> { public: using type = QT_PREPEND_NAMESPACE(qreal); };
    template <>
    class tuple_element<1, QT_PREPEND_NAMESPACE(QPointF)> { public: using type = QT_PREPEND_NAMESPACE(qreal); };
} +/

