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



/// Binding for C++ class [QPoint](https://doc.qt.io/qt-5/qpoint.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QPoint
{
public:
    /+pragma(inline, true) this()
    {
        this.xp = 0;
        this.yp = 0;
    }+/
    pragma(inline, true) this(int xpos, int ypos)
    {
        this.xp = xpos;
        this.yp = ypos;
    }

    pragma(inline, true) bool isNull() const
    { return xp == 0 && yp == 0; }

    pragma(inline, true) int x() const
    { return xp; }
    pragma(inline, true) int y() const
    { return yp; }
    pragma(inline, true) void setX(int xpos)
    { xp = xpos; }
    pragma(inline, true) void setY(int ypos)
    { yp = ypos; }

    pragma(inline, true) int manhattanLength() const
    { return qAbs(x())+qAbs(y()); }

    QPoint transposed() const/+ noexcept+/ { return QPoint(yp, xp); }

    pragma(inline, true) ref int rx() return
    { return xp; }
    pragma(inline, true) ref int ry() return
    { return yp; }

    pragma(inline, true) ref QPoint opOpAssign(string op)(ref const(QPoint) p) if (op == "+")
    { xp+=p.xp; yp+=p.yp; return this; }
    pragma(inline, true) ref QPoint opOpAssign(string op)(ref const(QPoint) p) if (op == "-")
    { xp-=p.xp; yp-=p.yp; return this; }

    /+pragma(inline, true) ref QPoint operator *=(float factor)
    { xp = qRound(xp*factor); yp = qRound(yp*factor); return this; }+/
    /+pragma(inline, true) ref QPoint operator *=(double factor)
    { xp = qRound(xp*factor); yp = qRound(yp*factor); return this; }+/
    /+pragma(inline, true) ref QPoint operator *=(int factor)
    { xp = xp*factor; yp = yp*factor; return this; }+/

    /+pragma(inline, true) ref QPoint operator /=(qreal c)
    {
        xp = qRound(xp/c);
        yp = qRound(yp/c);
        return this;
    }+/

    pragma(inline, true) static int dotProduct(ref const(QPoint) p1, ref const(QPoint) p2)
    { return p1.xp * p2.xp + p1.yp * p2.yp; }

    /+ friend inline bool operator==(const QPoint &, const QPoint &); +/
    /+ friend inline bool operator!=(const QPoint &, const QPoint &); +/
    /+ friend inline const QPoint operator+(const QPoint &, const QPoint &); +/

    /+ Q_DECL_CONSTEXPR +/ pragma(inline, true) const(QPoint) opBinary(string op)(const(QPoint)  p2) const if (op == "+")
    { return QPoint(this.xp+p2.xp, this.yp+p2.yp); }

    /+ friend inline const QPoint operator-(const QPoint &, const QPoint &); +/
    /+ friend inline const QPoint operator*(const QPoint &, float); +/
    /+ friend inline const QPoint operator*(float, const QPoint &); +/
    /+ friend inline const QPoint operator*(const QPoint &, double); +/
    /+ friend inline const QPoint operator*(double, const QPoint &); +/
    /+ friend inline const QPoint operator*(const QPoint &, int); +/
    /+ friend inline const QPoint operator*(int, const QPoint &); +/
    /+ friend inline const QPoint operator+(const QPoint &); +/
    /+ friend inline const QPoint operator-(const QPoint &); +/
    /+ friend inline const QPoint operator/(const QPoint &, qreal); +/

    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ Q_REQUIRED_RESULT CGPoint toCGPoint() const noexcept; +/
    }



    pragma(inline, true) const(QPoint) opBinary(string op)(const(QPoint) p2) const if (op == "-")
    { return QPoint(xp-p2.xp, yp-p2.yp); }


private:
    /+ friend class QTransform; +/
    int xp = 0;
    int yp = 0;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QPoint, Q_MOVABLE_TYPE);

/*****************************************************************************
  QPoint stream functions
 *****************************************************************************/
#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QPoint &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QPoint &);
#endif +/

/*****************************************************************************
  QPoint inline functions
 *****************************************************************************/

/+pragma(inline, true) bool operator ==(ref const(QPoint) p1, ref const(QPoint) p2)
{ return p1.xp == p2.xp && p1.yp == p2.yp; }+/

/+pragma(inline, true) bool operator !=(ref const(QPoint) p1, ref const(QPoint) p2)
{ return p1.xp != p2.xp || p1.yp != p2.yp; }+/


/+pragma(inline, true) const(QPoint) operator *(ref const(QPoint) p, float factor)
{ return QPoint(qRound(p.xp*factor), qRound(p.yp*factor)); }+/

/+pragma(inline, true) const(QPoint) operator *(ref const(QPoint) p, double factor)
{ return QPoint(qRound(p.xp*factor), qRound(p.yp*factor)); }+/

/+pragma(inline, true) const(QPoint) operator *(ref const(QPoint) p, int factor)
{ return QPoint(p.xp*factor, p.yp*factor); }+/

/+pragma(inline, true) const(QPoint) operator *(float factor, ref const(QPoint) p)
{ return QPoint(qRound(p.xp*factor), qRound(p.yp*factor)); }+/

/+pragma(inline, true) const(QPoint) operator *(double factor, ref const(QPoint) p)
{ return QPoint(qRound(p.xp*factor), qRound(p.yp*factor)); }+/

/+pragma(inline, true) const(QPoint) operator *(int factor, ref const(QPoint) p)
{ return QPoint(p.xp*factor, p.yp*factor); }+/

/+pragma(inline, true) const(QPoint) operator +(ref const(QPoint) p)
{ return p; }+/

/+pragma(inline, true) const(QPoint) operator -(ref const(QPoint) p)
{ return QPoint(-p.xp, -p.yp); }+/

/+pragma(inline, true) const(QPoint) operator /(ref const(QPoint) p, qreal c)
{
    return QPoint(qRound(p.xp/c), qRound(p.yp/c));
}+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QPoint &);
#endif +/





/// Binding for C++ class [QPointF](https://doc.qt.io/qt-5/qpointf.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QPointF
{
public:
    /+pragma(inline, true) this()
    {
        this.xp = 0;
        this.yp = 0;
    }+/
    pragma(inline, true) this(ref const(QPoint) p)
    {
        this.xp = p.x();
        this.yp = p.y();
    }
    pragma(inline, true) this(qreal xpos, qreal ypos)
    {
        this.xp = xpos;
        this.yp = ypos;
    }

    pragma(inline, true) qreal manhattanLength() const
    {
        return qAbs(x())+qAbs(y());
    }

    pragma(inline, true) bool isNull() const
    {
        return qIsNull(xp) && qIsNull(yp);
    }

    pragma(inline, true) qreal x() const
    {
        return xp;
    }
    pragma(inline, true) qreal y() const
    {
        return yp;
    }
    pragma(inline, true) void setX(qreal xpos)
    {
        xp = xpos;
    }
    pragma(inline, true) void setY(qreal ypos)
    {
        yp = ypos;
    }

    QPointF transposed() const/+ noexcept+/ { return QPointF(yp, xp); }

    pragma(inline, true) ref qreal rx() return
    {
        return xp;
    }
    pragma(inline, true) ref qreal ry() return
    {
        return yp;
    }

    pragma(inline, true) ref QPointF opOpAssign(string op)(ref const(QPointF) p) if (op == "+")
    {
        xp+=p.xp;
        yp+=p.yp;
        return this;
    }
    pragma(inline, true) ref QPointF opOpAssign(string op)(ref const(QPointF) p) if (op == "-")
    {
        xp-=p.xp; yp-=p.yp; return this;
    }
    /+pragma(inline, true) ref QPointF operator *=(qreal c)
    {
        xp*=c; yp*=c; return this;
    }+/
    /+pragma(inline, true) ref QPointF operator /=(qreal divisor)
    {
        xp/=divisor;
        yp/=divisor;
        return this;
    }+/

    pragma(inline, true) static qreal dotProduct(ref const(QPointF) p1, ref const(QPointF) p2)
    { return p1.xp * p2.xp + p1.yp * p2.yp; }

    /+ friend inline bool operator==(const QPointF &, const QPointF &); +/
    /+ friend inline bool operator!=(const QPointF &, const QPointF &); +/
    /+ friend inline const QPointF operator+(const QPointF &, const QPointF &); +/

    pragma(inline, true) const(QPointF) opBinary(string op)(const(QPointF)  p2) const if (op == "+")
    {
        return QPointF(this.xp+p2.xp, this.yp+p2.yp);
    }

    /+ friend inline const QPointF operator-(const QPointF &, const QPointF &); +/
    /+ friend inline const QPointF operator*(qreal, const QPointF &); +/
    /+ friend inline const QPointF operator*(const QPointF &, qreal); +/
    /+ friend inline const QPointF operator+(const QPointF &); +/
    /+ friend inline const QPointF operator-(const QPointF &); +/
    /+ friend inline const QPointF operator/(const QPointF &, qreal); +/

    pragma(inline, true) QPoint toPoint() const
    {
        return QPoint(qRound(xp), qRound(yp));
    }

    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ Q_REQUIRED_RESULT static QPointF fromCGPoint(CGPoint point) noexcept; +/
        /+ Q_REQUIRED_RESULT CGPoint toCGPoint() const noexcept; +/
    }

private:
    /+ friend class QMatrix; +/
    /+ friend class QTransform; +/

    qreal xp = 0;
    qreal yp = 0;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QPointF, Q_MOVABLE_TYPE);

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

QT_WARNING_PUSH
QT_WARNING_DISABLE_CLANG("-Wfloat-equal")
QT_WARNING_DISABLE_GCC("-Wfloat-equal")
QT_WARNING_DISABLE_INTEL(1572) +/

/+pragma(inline, true) bool operator ==(ref const(QPointF) p1, ref const(QPointF) p2)
{
    return ((!p1.xp || !p2.xp) ? qFuzzyIsNull(p1.xp - p2.xp) : qFuzzyCompare(p1.xp, p2.xp))
        && ((!p1.yp || !p2.yp) ? qFuzzyIsNull(p1.yp - p2.yp) : qFuzzyCompare(p1.yp, p2.yp));
}+/

/+pragma(inline, true) bool operator !=(ref const(QPointF) p1, ref const(QPointF) p2)
{
    return !(p1 == p2);
}+/

/+ QT_WARNING_POP +/

/+pragma(inline, true) const(QPointF) operator +(ref const(QPointF) p1, ref const(QPointF) p2)
{
    return QPointF(p1.xp+p2.xp, p1.yp+p2.yp);
}+/

/+pragma(inline, true) const(QPointF) operator -(ref const(QPointF) p1, ref const(QPointF) p2)
{
    return QPointF(p1.xp-p2.xp, p1.yp-p2.yp);
}+/

/+pragma(inline, true) const(QPointF) operator *(ref const(QPointF) p, qreal c)
{
    return QPointF(p.xp*c, p.yp*c);
}+/

/+pragma(inline, true) const(QPointF) operator *(qreal c, ref const(QPointF) p)
{
    return QPointF(p.xp*c, p.yp*c);
}+/

/+pragma(inline, true) const(QPointF) operator +(ref const(QPointF) p)
{
    return p;
}+/

/+pragma(inline, true) const(QPointF) operator -(ref const(QPointF) p)
{
    return QPointF(-p.xp, -p.yp);
}+/

/+pragma(inline, true) const(QPointF) operator /(ref const(QPointF) p, qreal divisor)
{
    return QPointF(p.xp/divisor, p.yp/divisor);
}+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug d, const QPointF &p);
#endif +/

