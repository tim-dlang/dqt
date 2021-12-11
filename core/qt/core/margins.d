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

/// Binding for C++ class [QMargins](https://doc.qt.io/qt-5/qmargins.html).
@Q_MOVABLE_TYPE extern(C++, class) struct QMargins
{
public:
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.m_left = 0;
        this.m_top = 0;
        this.m_right = 0;
        this.m_bottom = 0;
    }+/
    pragma(inline, true) this(int aleft, int atop, int aright, int abottom)/+ noexcept+/
    {
        this.m_left = aleft;
        this.m_top = atop;
        this.m_right = aright;
        this.m_bottom = abottom;
    }

    pragma(inline, true) bool isNull() const/+ noexcept+/
    { return m_left==0 && m_top==0 && m_right==0 && m_bottom==0; }

    pragma(inline, true) int left() const/+ noexcept+/
    { return m_left; }
    pragma(inline, true) int top() const/+ noexcept+/
    { return m_top; }
    pragma(inline, true) int right() const/+ noexcept+/
    { return m_right; }
    pragma(inline, true) int bottom() const/+ noexcept+/
    { return m_bottom; }

    pragma(inline, true) void setLeft(int aleft)/+ noexcept+/
    { m_left = aleft; }
    pragma(inline, true) void setTop(int atop)/+ noexcept+/
    { m_top = atop; }
    pragma(inline, true) void setRight(int aright)/+ noexcept+/
    { m_right = aright; }
    pragma(inline, true) void setBottom(int abottom)/+ noexcept+/
    { m_bottom = abottom; }

    pragma(inline, true) ref QMargins opOpAssign(string op)(ref const(QMargins) margins)/+ noexcept+/ if(op == "+")
    {
        return (){return this = this + margins;
    }();
    }
    pragma(inline, true) ref QMargins opOpAssign(string op)(ref const(QMargins) margins)/+ noexcept+/ if(op == "-")
    {
        return (){return this = this - margins;
    }();
    }
    pragma(inline, true) ref QMargins opOpAssign(string op)(int margin)/+ noexcept+/ if(op == "+")
    {
        m_left += margin;
        m_top += margin;
        m_right += margin;
        m_bottom += margin;
        return this;
    }
    pragma(inline, true) ref QMargins opOpAssign(string op)(int margin)/+ noexcept+/ if(op == "-")
    {
        m_left -= margin;
        m_top -= margin;
        m_right -= margin;
        m_bottom -= margin;
        return this;
    }
    /+pragma(inline, true) ref QMargins operator *=(int factor)/+ noexcept+/
    {
        return (){return this = this * factor;
    }();
    }+/
    /+pragma(inline, true) ref QMargins operator /=(int divisor)
    {
        return (){return this = this / divisor;
    }();
    }+/
    /+pragma(inline, true) ref QMargins operator *=(qreal factor)/+ noexcept+/
    {
        return (){return this = this * factor;
    }();
    }+/
    /+pragma(inline, true) ref QMargins operator /=(qreal divisor)
    {
        return (){return this = this / divisor;
    }();
    }+/

private:
    int m_left = 0;
    int m_top = 0;
    int m_right = 0;
    int m_bottom = 0;

    /+ friend inline bool operator==(const QMargins &, const QMargins &) noexcept; +/
    /+ friend inline bool operator!=(const QMargins &, const QMargins &) noexcept; +/
}

/+ Q_DECLARE_TYPEINFO(QMargins, Q_MOVABLE_TYPE);

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


/+pragma(inline, true) bool operator ==(ref const(QMargins) m1, ref const(QMargins) m2)/+ noexcept+/
{
    return
            m1.m_left == m2.m_left &&
            m1.m_top == m2.m_top &&
            m1.m_right == m2.m_right &&
            m1.m_bottom == m2.m_bottom;
}+/

/+pragma(inline, true) bool operator !=(ref const(QMargins) m1, ref const(QMargins) m2)/+ noexcept+/
{
    return
            m1.m_left != m2.m_left ||
            m1.m_top != m2.m_top ||
            m1.m_right != m2.m_right ||
            m1.m_bottom != m2.m_bottom;
}+/

/+pragma(inline, true) QMargins operator +(ref const(QMargins) m1, ref const(QMargins) m2)/+ noexcept+/
{
    return QMargins(m1.left() + m2.left(), m1.top() + m2.top(),
                    m1.right() + m2.right(), m1.bottom() + m2.bottom());
}+/

/+pragma(inline, true) QMargins operator -(ref const(QMargins) m1, ref const(QMargins) m2)/+ noexcept+/
{
    return QMargins(m1.left() - m2.left(), m1.top() - m2.top(),
                    m1.right() - m2.right(), m1.bottom() - m2.bottom());
}+/

/+pragma(inline, true) QMargins operator +(ref const(QMargins) lhs, int rhs)/+ noexcept+/
{
    return QMargins(lhs.left() + rhs, lhs.top() + rhs,
                    lhs.right() + rhs, lhs.bottom() + rhs);
}+/

/+pragma(inline, true) QMargins operator +(int lhs, ref const(QMargins) rhs)/+ noexcept+/
{
    return QMargins(rhs.left() + lhs, rhs.top() + lhs,
                    rhs.right() + lhs, rhs.bottom() + lhs);
}+/

/+pragma(inline, true) QMargins operator -(ref const(QMargins) lhs, int rhs)/+ noexcept+/
{
    return QMargins(lhs.left() - rhs, lhs.top() - rhs,
                    lhs.right() - rhs, lhs.bottom() - rhs);
}+/

/+pragma(inline, true) QMargins operator *(ref const(QMargins) margins, int factor)/+ noexcept+/
{
    return QMargins(margins.left() * factor, margins.top() * factor,
                    margins.right() * factor, margins.bottom() * factor);
}+/

/+pragma(inline, true) QMargins operator *(int factor, ref const(QMargins) margins)/+ noexcept+/
{
    return QMargins(margins.left() * factor, margins.top() * factor,
                    margins.right() * factor, margins.bottom() * factor);
}+/

/+pragma(inline, true) QMargins operator *(ref const(QMargins) margins, qreal factor)/+ noexcept+/
{
    return QMargins(qRound(margins.left() * factor), qRound(margins.top() * factor),
                    qRound(margins.right() * factor), qRound(margins.bottom() * factor));
}+/

/+pragma(inline, true) QMargins operator *(qreal factor, ref const(QMargins) margins)/+ noexcept+/
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

/+pragma(inline, true) QMargins operator +(ref const(QMargins) margins)/+ noexcept+/
{
    return margins;
}+/

/+pragma(inline, true) QMargins operator -(ref const(QMargins) margins)/+ noexcept+/
{
    return QMargins(-margins.left(), -margins.top(), -margins.right(), -margins.bottom());
}+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QMargins &);
#endif +/

/*****************************************************************************
  QMarginsF class
 *****************************************************************************/

/// Binding for C++ class [QMarginsF](https://doc.qt.io/qt-5/qmarginsf.html).
@Q_MOVABLE_TYPE extern(C++, class) struct QMarginsF
{
public:
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.m_left = 0;
        this.m_top = 0;
        this.m_right = 0;
        this.m_bottom = 0;
    }+/
    pragma(inline, true) this(qreal aleft, qreal atop, qreal aright, qreal abottom)/+ noexcept+/
    {
        this.m_left = aleft;
        this.m_top = atop;
        this.m_right = aright;
        this.m_bottom = abottom;
    }
    pragma(inline, true) this(ref const(QMargins) margins)/+ noexcept+/
    {
        this.m_left = margins.left();
        this.m_top = margins.top();
        this.m_right = margins.right();
        this.m_bottom = margins.bottom();
    }

    pragma(inline, true) bool isNull() const/+ noexcept+/
    { return qFuzzyIsNull(m_left) && qFuzzyIsNull(m_top) && qFuzzyIsNull(m_right) && qFuzzyIsNull(m_bottom); }

    pragma(inline, true) qreal left() const/+ noexcept+/
    { return m_left; }
    pragma(inline, true) qreal top() const/+ noexcept+/
    { return m_top; }
    pragma(inline, true) qreal right() const/+ noexcept+/
    { return m_right; }
    pragma(inline, true) qreal bottom() const/+ noexcept+/
    { return m_bottom; }

    pragma(inline, true) void setLeft(qreal aleft)/+ noexcept+/
    { m_left = aleft; }
    pragma(inline, true) void setTop(qreal atop)/+ noexcept+/
    { m_top = atop; }
    pragma(inline, true) void setRight(qreal aright)/+ noexcept+/
    { m_right = aright; }
    pragma(inline, true) void setBottom(qreal abottom)/+ noexcept+/
    { m_bottom = abottom; }

    pragma(inline, true) ref QMarginsF opOpAssign(string op)(ref const(QMarginsF) margins)/+ noexcept+/ if(op == "+")
    {
        return (){return this = this + margins;
    }();
    }
    pragma(inline, true) ref QMarginsF opOpAssign(string op)(ref const(QMarginsF) margins)/+ noexcept+/ if(op == "-")
    {
        return (){return this = this - margins;
    }();
    }
    pragma(inline, true) ref QMarginsF opOpAssign(string op)(qreal addend)/+ noexcept+/ if(op == "+")
    {
        m_left += addend;
        m_top += addend;
        m_right += addend;
        m_bottom += addend;
        return this;
    }
    pragma(inline, true) ref QMarginsF opOpAssign(string op)(qreal subtrahend)/+ noexcept+/ if(op == "-")
    {
        m_left -= subtrahend;
        m_top -= subtrahend;
        m_right -= subtrahend;
        m_bottom -= subtrahend;
        return this;
    }
    /+pragma(inline, true) ref QMarginsF operator *=(qreal factor)/+ noexcept+/
    {
        return (){return this = this * factor;
    }();
    }+/
    /+pragma(inline, true) ref QMarginsF operator /=(qreal divisor)
    {
        return (){return this = this / divisor;
    }();
    }+/

    pragma(inline, true) QMargins toMargins() const/+ noexcept+/
    {
        return QMargins(qRound(m_left), qRound(m_top), qRound(m_right), qRound(m_bottom));
    }

private:
    qreal m_left = 0;
    qreal m_top = 0;
    qreal m_right = 0;
    qreal m_bottom = 0;
}

/+ Q_DECLARE_TYPEINFO(QMarginsF, Q_MOVABLE_TYPE);

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


/+pragma(inline, true) bool operator ==(ref const(QMarginsF) lhs, ref const(QMarginsF) rhs)/+ noexcept+/
{
    return qFuzzyCompare(lhs.left(), rhs.left())
           && qFuzzyCompare(lhs.top(), rhs.top())
           && qFuzzyCompare(lhs.right(), rhs.right())
           && qFuzzyCompare(lhs.bottom(), rhs.bottom());
}+/

/+pragma(inline, true) bool operator !=(ref const(QMarginsF) lhs, ref const(QMarginsF) rhs)/+ noexcept+/
{
    return !operator==(lhs, rhs);
}+/

/+pragma(inline, true) QMarginsF operator +(ref const(QMarginsF) lhs, ref const(QMarginsF) rhs)/+ noexcept+/
{
    return QMarginsF(lhs.left() + rhs.left(), lhs.top() + rhs.top(),
                     lhs.right() + rhs.right(), lhs.bottom() + rhs.bottom());
}+/

/+pragma(inline, true) QMarginsF operator -(ref const(QMarginsF) lhs, ref const(QMarginsF) rhs)/+ noexcept+/
{
    return QMarginsF(lhs.left() - rhs.left(), lhs.top() - rhs.top(),
                     lhs.right() - rhs.right(), lhs.bottom() - rhs.bottom());
}+/

/+pragma(inline, true) QMarginsF operator +(ref const(QMarginsF) lhs, qreal rhs)/+ noexcept+/
{
    return QMarginsF(lhs.left() + rhs, lhs.top() + rhs,
                     lhs.right() + rhs, lhs.bottom() + rhs);
}+/

/+pragma(inline, true) QMarginsF operator +(qreal lhs, ref const(QMarginsF) rhs)/+ noexcept+/
{
    return QMarginsF(rhs.left() + lhs, rhs.top() + lhs,
                     rhs.right() + lhs, rhs.bottom() + lhs);
}+/

/+pragma(inline, true) QMarginsF operator -(ref const(QMarginsF) lhs, qreal rhs)/+ noexcept+/
{
    return QMarginsF(lhs.left() - rhs, lhs.top() - rhs,
                     lhs.right() - rhs, lhs.bottom() - rhs);
}+/

/+pragma(inline, true) QMarginsF operator *(ref const(QMarginsF) lhs, qreal rhs)/+ noexcept+/
{
    return QMarginsF(lhs.left() * rhs, lhs.top() * rhs,
                     lhs.right() * rhs, lhs.bottom() * rhs);
}+/

/+pragma(inline, true) QMarginsF operator *(qreal lhs, ref const(QMarginsF) rhs)/+ noexcept+/
{
    return QMarginsF(rhs.left() * lhs, rhs.top() * lhs,
                     rhs.right() * lhs, rhs.bottom() * lhs);
}+/

/+pragma(inline, true) QMarginsF operator /(ref const(QMarginsF) lhs, qreal divisor)
{
    return QMarginsF(lhs.left() / divisor, lhs.top() / divisor,
                     lhs.right() / divisor, lhs.bottom() / divisor);
}+/

/+pragma(inline, true) QMarginsF operator +(ref const(QMarginsF) margins)/+ noexcept+/
{
    return margins;
}+/

/+pragma(inline, true) QMarginsF operator -(ref const(QMarginsF) margins)/+ noexcept+/
{
    return QMarginsF(-margins.left(), -margins.top(), -margins.right(), -margins.bottom());
}+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QMarginsF &);
#endif +/

