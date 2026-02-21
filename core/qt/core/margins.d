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
module qt.core.margins;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.typeinfo;
import qt.helpers;


/*****************************************************************************
  QMargins class
 *****************************************************************************/

/// Binding for C++ class [QMargins](https://doc.qt.io/qt-6/qmargins.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct QMargins
{
public:
    /+pragma(inline, true) this() nothrow
    {
        this.m_left = 0;
        this.m_top = 0;
        this.m_right = 0;
        this.m_bottom = 0;
    }+/
    pragma(inline, true) this(int aleft, int atop, int aright, int abottom) nothrow
    {
        this.m_left = aleft;
        this.m_top = atop;
        this.m_right = aright;
        this.m_bottom = abottom;
    }

    pragma(inline, true) bool isNull() const nothrow
    { return m_left==0 && m_top==0 && m_right==0 && m_bottom==0; }

    pragma(inline, true) int left() const nothrow
    { return m_left; }
    pragma(inline, true) int top() const nothrow
    { return m_top; }
    pragma(inline, true) int right() const nothrow
    { return m_right; }
    pragma(inline, true) int bottom() const nothrow
    { return m_bottom; }

    pragma(inline, true) void setLeft(int aleft) nothrow
    { m_left = aleft; }
    pragma(inline, true) void setTop(int atop) nothrow
    { m_top = atop; }
    pragma(inline, true) void setRight(int aright) nothrow
    { m_right = aright; }
    pragma(inline, true) void setBottom(int abottom) nothrow
    { m_bottom = abottom; }

    pragma(inline, true) ref QMargins opOpAssign(string op)(ref const(QMargins) margins) nothrow if (op == "+")
    {
        return (){return this = this + margins;
    }();
    }
    pragma(inline, true) ref QMargins opOpAssign(string op)(ref const(QMargins) margins) nothrow if (op == "-")
    {
        return (){return this = this - margins;
    }();
    }
    pragma(inline, true) ref QMargins opOpAssign(string op)(int margin) nothrow if (op == "+")
    {
        m_left += margin;
        m_top += margin;
        m_right += margin;
        m_bottom += margin;
        return this;
    }
    pragma(inline, true) ref QMargins opOpAssign(string op)(int margin) nothrow if (op == "-")
    {
        m_left -= margin;
        m_top -= margin;
        m_right -= margin;
        m_bottom -= margin;
        return this;
    }
    /+pragma(inline, true) ref QMargins operator *=(int factor) nothrow
    {
        return (){return this = this * factor;
    }();
    }+/
    /+pragma(inline, true) ref QMargins operator /=(int divisor)
    {
        return (){return this = this / divisor;
    }();
    }+/
    /+pragma(inline, true) ref QMargins operator *=(qreal factor) nothrow
    {
        return (){return this = this * factor;
    }();
    }+/
    /+pragma(inline, true) ref QMargins operator /=(qreal divisor)
    {
        return (){return this = this / divisor;
    }();
    }+/

    /+ [[nodiscard]] +/ pragma(inline, true) QMarginsF toMarginsF() const nothrow { return QMarginsF(this); }

private:
    int m_left = 0;
    int m_top = 0;
    int m_right = 0;
    int m_bottom = 0;

    /+ friend constexpr inline bool operator==(const QMargins &m1, const QMargins &m2) noexcept
    {
        return
                m1.m_left == m2.m_left &&
                m1.m_top == m2.m_top &&
                m1.m_right == m2.m_right &&
                m1.m_bottom == m2.m_bottom;
    } +/

    /+ friend constexpr inline bool operator!=(const QMargins &m1, const QMargins &m2) noexcept
    {
        return !(m1 == m2);
    } +/

    /+ template <std::size_t I,
              typename M,
              std::enable_if_t<(I < 4), bool> = true,
              std::enable_if_t<std::is_same_v<std::decay_t<M>, QMargins>, bool> = true> +/
    /+ friend constexpr decltype(auto) get(M &&m) noexcept
    {
        static if (I == 0)
            return (std::forward<M>(m).m_left);
        else static if (I == 1)
            return (std::forward<M>(m).m_top);
        else static if (I == 2)
            return (std::forward<M>(m).m_right);
        else static if (I == 3)
            return (std::forward<M>(m).m_bottom);
    } +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QMargins, Q_RELOCATABLE_TYPE);

/*****************************************************************************
  QMargins stream functions
 *****************************************************************************/
#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QMargins &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QMargins &);
#endif +/

/*****************************************************************************
  QMargins inline functions
 *****************************************************************************/


/+pragma(inline, true) QMargins operator +(ref const(QMargins) m1, ref const(QMargins) m2) nothrow
{
    return QMargins(m1.left() + m2.left(), m1.top() + m2.top(),
                    m1.right() + m2.right(), m1.bottom() + m2.bottom());
}+/

/+pragma(inline, true) QMargins operator -(ref const(QMargins) m1, ref const(QMargins) m2) nothrow
{
    return QMargins(m1.left() - m2.left(), m1.top() - m2.top(),
                    m1.right() - m2.right(), m1.bottom() - m2.bottom());
}+/

/+pragma(inline, true) QMargins operator +(ref const(QMargins) lhs, int rhs) nothrow
{
    return QMargins(lhs.left() + rhs, lhs.top() + rhs,
                    lhs.right() + rhs, lhs.bottom() + rhs);
}+/

/+pragma(inline, true) QMargins operator +(int lhs, ref const(QMargins) rhs) nothrow
{
    return QMargins(rhs.left() + lhs, rhs.top() + lhs,
                    rhs.right() + lhs, rhs.bottom() + lhs);
}+/

/+pragma(inline, true) QMargins operator -(ref const(QMargins) lhs, int rhs) nothrow
{
    return QMargins(lhs.left() - rhs, lhs.top() - rhs,
                    lhs.right() - rhs, lhs.bottom() - rhs);
}+/

/+pragma(inline, true) QMargins operator *(ref const(QMargins) margins, int factor) nothrow
{
    return QMargins(margins.left() * factor, margins.top() * factor,
                    margins.right() * factor, margins.bottom() * factor);
}+/

/+pragma(inline, true) QMargins operator *(int factor, ref const(QMargins) margins) nothrow
{
    return QMargins(margins.left() * factor, margins.top() * factor,
                    margins.right() * factor, margins.bottom() * factor);
}+/

/+pragma(inline, true) QMargins operator *(ref const(QMargins) margins, qreal factor) nothrow
{
    return QMargins(qRound(margins.left() * factor), qRound(margins.top() * factor),
                    qRound(margins.right() * factor), qRound(margins.bottom() * factor));
}+/

/+pragma(inline, true) QMargins operator *(qreal factor, ref const(QMargins) margins) nothrow
{
    return QMargins(qRound(margins.left() * factor), qRound(margins.top() * factor),
                    qRound(margins.right() * factor), qRound(margins.bottom() * factor));
}+/

/+pragma(inline, true) QMargins operator /(ref const(QMargins) margins, int divisor)
{
    return QMargins(margins.left() / divisor, margins.top() / divisor,
                    margins.right() / divisor, margins.bottom() / divisor);
}+/

/+pragma(inline, true) QMargins operator /(ref const(QMargins) margins, qreal divisor)
{
    return QMargins(qRound(margins.left() / divisor), qRound(margins.top() / divisor),
                    qRound(margins.right() / divisor), qRound(margins.bottom() / divisor));
}+/

/+pragma(inline, true) QMargins operator |(ref const(QMargins) m1, ref const(QMargins) m2) nothrow
{
    return QMargins(qMax(m1.left(), m2.left()), qMax(m1.top(), m2.top()),
                    qMax(m1.right(), m2.right()), qMax(m1.bottom(), m2.bottom()));
}+/

/+pragma(inline, true) QMargins operator +(ref const(QMargins) margins) nothrow
{
    return margins;
}+/

/+pragma(inline, true) QMargins operator -(ref const(QMargins) margins) nothrow
{
    return QMargins(-margins.left(), -margins.top(), -margins.right(), -margins.bottom());
}+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QMargins &);
#endif +/

/*****************************************************************************
  QMarginsF class
 *****************************************************************************/

/// Binding for C++ class [QMarginsF](https://doc.qt.io/qt-6/qmarginsf.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct QMarginsF
{
public:
    /+pragma(inline, true) this() nothrow
    {
        this.m_left = 0;
        this.m_top = 0;
        this.m_right = 0;
        this.m_bottom = 0;
    }+/
    pragma(inline, true) this(qreal aleft, qreal atop, qreal aright, qreal abottom) nothrow
    {
        this.m_left = aleft;
        this.m_top = atop;
        this.m_right = aright;
        this.m_bottom = abottom;
    }
    pragma(inline, true) this(ref const(QMargins) margins) nothrow
    {
        this.m_left = margins.left();
        this.m_top = margins.top();
        this.m_right = margins.right();
        this.m_bottom = margins.bottom();
    }

    pragma(inline, true) bool isNull() const nothrow
    { return qFuzzyIsNull(m_left) && qFuzzyIsNull(m_top) && qFuzzyIsNull(m_right) && qFuzzyIsNull(m_bottom); }

    pragma(inline, true) qreal left() const nothrow
    { return m_left; }
    pragma(inline, true) qreal top() const nothrow
    { return m_top; }
    pragma(inline, true) qreal right() const nothrow
    { return m_right; }
    pragma(inline, true) qreal bottom() const nothrow
    { return m_bottom; }

    pragma(inline, true) void setLeft(qreal aleft) nothrow
    { m_left = aleft; }
    pragma(inline, true) void setTop(qreal atop) nothrow
    { m_top = atop; }
    pragma(inline, true) void setRight(qreal aright) nothrow
    { m_right = aright; }
    pragma(inline, true) void setBottom(qreal abottom) nothrow
    { m_bottom = abottom; }

    pragma(inline, true) ref QMarginsF opOpAssign(string op)(ref const(QMarginsF) margins) nothrow if (op == "+")
    {
        return (){return this = this + margins;
    }();
    }
    pragma(inline, true) ref QMarginsF opOpAssign(string op)(ref const(QMarginsF) margins) nothrow if (op == "-")
    {
        return (){return this = this - margins;
    }();
    }
    pragma(inline, true) ref QMarginsF opOpAssign(string op)(qreal addend) nothrow if (op == "+")
    {
        m_left += addend;
        m_top += addend;
        m_right += addend;
        m_bottom += addend;
        return this;
    }
    pragma(inline, true) ref QMarginsF opOpAssign(string op)(qreal subtrahend) nothrow if (op == "-")
    {
        m_left -= subtrahend;
        m_top -= subtrahend;
        m_right -= subtrahend;
        m_bottom -= subtrahend;
        return this;
    }
    /+pragma(inline, true) ref QMarginsF operator *=(qreal factor) nothrow
    {
        return (){return this = this * factor;
    }();
    }+/
    /+pragma(inline, true) ref QMarginsF operator /=(qreal divisor)
    {
        return (){return this = this / divisor;
    }();
    }+/

    pragma(inline, true) QMargins toMargins() const nothrow
    {
        return QMargins(qRound(m_left), qRound(m_top), qRound(m_right), qRound(m_bottom));
    }

private:
    qreal m_left = 0;
    qreal m_top = 0;
    qreal m_right = 0;
    qreal m_bottom = 0;

    /+ friend constexpr inline bool operator==(const QMarginsF &lhs, const QMarginsF &rhs) noexcept
    {
        return qFuzzyCompare(lhs.left(), rhs.left())
            && qFuzzyCompare(lhs.top(), rhs.top())
            && qFuzzyCompare(lhs.right(), rhs.right())
            && qFuzzyCompare(lhs.bottom(), rhs.bottom());
    } +/

    /+ friend constexpr inline bool operator!=(const QMarginsF &lhs, const QMarginsF &rhs) noexcept
    {
        return !(lhs == rhs);
    } +/

    /+ template <std::size_t I,
              typename M,
              std::enable_if_t<(I < 4), bool> = true,
              std::enable_if_t<std::is_same_v<std::decay_t<M>, QMarginsF>, bool> = true> +/
    /+ friend constexpr decltype(auto) get(M &&m) noexcept
    {
        static if (I == 0)
            return (std::forward<M>(m).m_left);
        else static if (I == 1)
            return (std::forward<M>(m).m_top);
        else static if (I == 2)
            return (std::forward<M>(m).m_right);
        else static if (I == 3)
            return (std::forward<M>(m).m_bottom);
    } +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QMarginsF, Q_RELOCATABLE_TYPE);

/*****************************************************************************
  QMarginsF stream functions
 *****************************************************************************/

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QMarginsF &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QMarginsF &);
#endif +/

/*****************************************************************************
  QMarginsF inline functions
 *****************************************************************************/


/+pragma(inline, true) QMarginsF operator +(ref const(QMarginsF) lhs, ref const(QMarginsF) rhs) nothrow
{
    return QMarginsF(lhs.left() + rhs.left(), lhs.top() + rhs.top(),
                     lhs.right() + rhs.right(), lhs.bottom() + rhs.bottom());
}+/

/+pragma(inline, true) QMarginsF operator -(ref const(QMarginsF) lhs, ref const(QMarginsF) rhs) nothrow
{
    return QMarginsF(lhs.left() - rhs.left(), lhs.top() - rhs.top(),
                     lhs.right() - rhs.right(), lhs.bottom() - rhs.bottom());
}+/

/+pragma(inline, true) QMarginsF operator +(ref const(QMarginsF) lhs, qreal rhs) nothrow
{
    return QMarginsF(lhs.left() + rhs, lhs.top() + rhs,
                     lhs.right() + rhs, lhs.bottom() + rhs);
}+/

/+pragma(inline, true) QMarginsF operator +(qreal lhs, ref const(QMarginsF) rhs) nothrow
{
    return QMarginsF(rhs.left() + lhs, rhs.top() + lhs,
                     rhs.right() + lhs, rhs.bottom() + lhs);
}+/

/+pragma(inline, true) QMarginsF operator -(ref const(QMarginsF) lhs, qreal rhs) nothrow
{
    return QMarginsF(lhs.left() - rhs, lhs.top() - rhs,
                     lhs.right() - rhs, lhs.bottom() - rhs);
}+/

/+pragma(inline, true) QMarginsF operator *(ref const(QMarginsF) lhs, qreal rhs) nothrow
{
    return QMarginsF(lhs.left() * rhs, lhs.top() * rhs,
                     lhs.right() * rhs, lhs.bottom() * rhs);
}+/

/+pragma(inline, true) QMarginsF operator *(qreal lhs, ref const(QMarginsF) rhs) nothrow
{
    return QMarginsF(rhs.left() * lhs, rhs.top() * lhs,
                     rhs.right() * lhs, rhs.bottom() * lhs);
}+/

/+pragma(inline, true) QMarginsF operator /(ref const(QMarginsF) lhs, qreal divisor)
{
    (mixin(Q_ASSERT(q{divisor < 0 || divisor > 0})));
    return QMarginsF(lhs.left() / divisor, lhs.top() / divisor,
                     lhs.right() / divisor, lhs.bottom() / divisor);
}+/

/+pragma(inline, true) QMarginsF operator |(ref const(QMarginsF) m1, ref const(QMarginsF) m2) nothrow
{
    return QMarginsF(qMax(m1.left(), m2.left()), qMax(m1.top(), m2.top()),
                     qMax(m1.right(), m2.right()), qMax(m1.bottom(), m2.bottom()));
}+/

/+pragma(inline, true) QMarginsF operator +(ref const(QMarginsF) margins) nothrow
{
    return margins;
}+/

/+pragma(inline, true) QMarginsF operator -(ref const(QMarginsF) margins) nothrow
{
    return QMarginsF(-margins.left(), -margins.top(), -margins.right(), -margins.bottom());
}+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QMarginsF &);
#endif


/*****************************************************************************
  QMargins/QMarginsF tuple protocol
 *****************************************************************************/

namespace std {
    template <>
    class tuple_size<QT_PREPEND_NAMESPACE(QMargins)> : public integral_constant<size_t, 4> {};
    template <>
    class tuple_element<0, QT_PREPEND_NAMESPACE(QMargins)> { public: using type = int; };
    template <>
    class tuple_element<1, QT_PREPEND_NAMESPACE(QMargins)> { public: using type = int; };
    template <>
    class tuple_element<2, QT_PREPEND_NAMESPACE(QMargins)> { public: using type = int; };
    template <>
    class tuple_element<3, QT_PREPEND_NAMESPACE(QMargins)> { public: using type = int; };

    template <>
    class tuple_size<QT_PREPEND_NAMESPACE(QMarginsF)> : public integral_constant<size_t, 4> {};
    template <>
    class tuple_element<0, QT_PREPEND_NAMESPACE(QMarginsF)> { public: using type = QT_PREPEND_NAMESPACE(qreal); };
    template <>
    class tuple_element<1, QT_PREPEND_NAMESPACE(QMarginsF)> { public: using type = QT_PREPEND_NAMESPACE(qreal); };
    template <>
    class tuple_element<2, QT_PREPEND_NAMESPACE(QMarginsF)> { public: using type = QT_PREPEND_NAMESPACE(qreal); };
    template <>
    class tuple_element<3, QT_PREPEND_NAMESPACE(QMarginsF)> { public: using type = QT_PREPEND_NAMESPACE(qreal); };
} +/

