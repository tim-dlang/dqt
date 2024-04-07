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
module qt.core.line;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.point;
import qt.core.typeinfo;
import qt.helpers;

/*******************************************************************************
 * class QLine
 *******************************************************************************/

/// Binding for C++ class [QLine](https://doc.qt.io/qt-6/qline.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QLine
{
public:
    /+pragma(inline, true) this() { }+/
    pragma(inline, true) this(const(QPoint) pt1_, const(QPoint) pt2_)
    {
        this.pt1 = pt1_;
        this.pt2 = pt2_;
    }
    pragma(inline, true) this(int x1pos, int y1pos, int x2pos, int y2pos)
    {
        this.pt1 = QPoint(x1pos, y1pos);
        this.pt2 = QPoint(x2pos, y2pos);
    }

    pragma(inline, true) bool isNull() const
    {
        return pt1 == pt2;
    }

    pragma(inline, true) QPoint p1() const
    {
        return pt1;
    }
    pragma(inline, true) QPoint p2() const
    {
        return pt2;
    }

    pragma(inline, true) int x1() const
    {
        return pt1.x();
    }
    pragma(inline, true) int y1() const
    {
        return pt1.y();
    }

    pragma(inline, true) int x2() const
    {
        return pt2.x();
    }
    pragma(inline, true) int y2() const
    {
        return pt2.y();
    }

    pragma(inline, true) int dx() const
    {
        return pt2.x() - pt1.x();
    }
    pragma(inline, true) int dy() const
    {
        return pt2.y() - pt1.y();
    }

    pragma(inline, true) void translate(ref const(QPoint) point)
    {
        pt1 += point;
        pt2 += point;
    }
    pragma(inline, true) void translate(int adx, int ady)
    {
        auto tmp=QPoint(adx, ady); this.translate(tmp);
    }

    /+ [[nodiscard]] +/ pragma(inline, true) QLine translated(ref const(QPoint) p) const
    {
        return QLine(pt1 + p, pt2 + p);
    }
    /+ [[nodiscard]] +/ pragma(inline, true) QLine translated(int adx, int ady) const
    {
        auto tmp = QPoint(adx, ady); return translated(tmp);
    }

    /+ [[nodiscard]] +/ pragma(inline, true) QPoint center() const
    {
        return QPoint(cast(int) ((qint64(pt1.x()) + pt2.x()) / 2), cast(int) ((qint64(pt1.y()) + pt2.y()) / 2));
    }

    pragma(inline, true) void setP1(ref const(QPoint) aP1)
    {
        pt1 = aP1;
    }
    pragma(inline, true) void setP2(ref const(QPoint) aP2)
    {
        pt2 = aP2;
    }
    pragma(inline, true) void setPoints(ref const(QPoint) aP1, ref const(QPoint) aP2)
    {
        pt1 = aP1;
        pt2 = aP2;
    }
    pragma(inline, true) void setLine(int aX1, int aY1, int aX2, int aY2)
    {
        pt1 = QPoint(aX1, aY1);
        pt2 = QPoint(aX2, aY2);
    }

    /+pragma(inline, true) bool operator ==(ref const(QLine) d) const/+ noexcept+/
    {
        return pt1 == d.pt1 && pt2 == d.pt2;
    }+/
    /+pragma(inline, true) bool operator !=(ref const(QLine) d) const/+ noexcept+/ { return !(this == d); }+/

private:
    QPoint pt1; QPoint pt2;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QLine, Q_RELOCATABLE_TYPE);

/*******************************************************************************
 * class QLine inline members
 *******************************************************************************/

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug d, const QLine &p);
#endif

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QLine &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QLine &);
#endif +/

/*******************************************************************************
 * class QLineF
 *******************************************************************************/
/// Binding for C++ class [QLineF](https://doc.qt.io/qt-6/qlinef.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QLineF
{
public:

    enum IntersectionType { NoIntersection, BoundedIntersection, UnboundedIntersection }
    alias IntersectType = IntersectionType; // deprecated name

    /+pragma(inline, true) this()
    {
    }+/
    pragma(inline, true) this(const(QPointF) apt1, const(QPointF) apt2)
    {
        this.pt1 = apt1;
        this.pt2 = apt2;
    }
    pragma(inline, true) this(qreal x1pos, qreal y1pos, qreal x2pos, qreal y2pos)
    {
        this.pt1 = typeof(this.pt1)(x1pos, y1pos);
        this.pt2 = typeof(this.pt2)(x2pos, y2pos);
    }
    /+pragma(inline, true) this(ref const(QLine) line)
    {
        this.pt1 = line.p1();
        this.pt2 = line.p2();
    }+/

    /+ [[nodiscard]] +/ static QLineF fromPolar(qreal length, qreal angle);

    pragma(inline, true) bool isNull() const
    {
        return qFuzzyCompare(pt1.x(), pt2.x()) && qFuzzyCompare(pt1.y(), pt2.y());
    }

    pragma(inline, true) QPointF p1() const
    {
        return pt1;
    }
    pragma(inline, true) QPointF p2() const
    {
        return pt2;
    }

    pragma(inline, true) qreal x1() const
    {
        return pt1.x();
    }
    pragma(inline, true) qreal y1() const
    {
        return pt1.y();
    }

    pragma(inline, true) qreal x2() const
    {
        return pt2.x();
    }
    pragma(inline, true) qreal y2() const
    {
        return pt2.y();
    }

    pragma(inline, true) qreal dx() const
    {
        return pt2.x() - pt1.x();
    }
    pragma(inline, true) qreal dy() const
    {
        return pt2.y() - pt1.y();
    }

    qreal length() const;
/+    void setLength(qreal len)
    {
        import qt.core.numeric;

        (mixin(Q_ASSERT(q{qIsFinite(len)})));
        const(qreal) oldLength = length();
        (mixin(Q_ASSERT(q{qIsFinite(oldLength)})));
        // Scale len by dx() / length() and dy() / length(), two O(1) quantities,
        // rather than scaling dx() and dy() by len / length(), which might overflow.
        if (oldLength > 0)
            pt2 = QPointF(pt1.x() + len * (dx() / oldLength), pt1.y() + len * (dy() / oldLength));
    }+/

    qreal angle() const;
    void setAngle(qreal angle);

    qreal angleTo(ref const(QLineF) l) const;

    /+ [[nodiscard]] +/ QLineF unitVector() const;
    /+ [[nodiscard]] +/ pragma(inline, true) QLineF normalVector() const
    {
        auto tmp = p1(); return QLineF(tmp, p1() + QPointF(dy(), -dx()));
    }

    IntersectionType intersects(ref const(QLineF) l, QPointF* intersectionPoint = null) const;

    pragma(inline, true) QPointF pointAt(qreal t) const
    {
        return QPointF(pt1.x() + (pt2.x() - pt1.x()) * t, pt1.y() + (pt2.y() - pt1.y()) * t);
    }
    pragma(inline, true) void translate(ref const(QPointF) point)
    {
        pt1 += point;
        pt2 += point;
    }
    pragma(inline, true) void translate(qreal adx, qreal ady)
    {
        auto tmp = QPointF(adx, ady); this.translate(tmp);
    }

    /+ [[nodiscard]] +/ pragma(inline, true) QLineF translated(ref const(QPointF) p) const
    {
        return QLineF(pt1 + p, pt2 + p);
    }
    /+ [[nodiscard]] +/ pragma(inline, true) QLineF translated(qreal adx, qreal ady) const
    {
        auto tmp = QPointF(adx, ady); return translated(tmp);
    }

    /+ [[nodiscard]] +/ pragma(inline, true) QPointF center() const
    {
        return QPointF(0.5 * pt1.x() + 0.5 * pt2.x(), 0.5 * pt1.y() + 0.5 * pt2.y());
    }

    pragma(inline, true) void setP1(ref const(QPointF) aP1)
    {
        pt1 = aP1;
    }
    pragma(inline, true) void setP2(ref const(QPointF) aP2)
    {
        pt2 = aP2;
    }
    pragma(inline, true) void setPoints(ref const(QPointF) aP1, ref const(QPointF) aP2)
    {
        pt1 = aP1;
        pt2 = aP2;
    }
    pragma(inline, true) void setLine(qreal aX1, qreal aY1, qreal aX2, qreal aY2)
    {
        pt1 = QPointF(aX1, aY1);
        pt2 = QPointF(aX2, aY2);
    }

    /+pragma(inline, true) bool operator ==(ref const(QLineF) d) const
    {
        return pt1 == d.pt1 && pt2 == d.pt2;
    }+/
    /+pragma(inline, true) bool operator !=(ref const(QLineF) d) const { return !(this == d); }+/

    pragma(inline, true) QLine toLine() const
    {
        auto tmp = pt1.toPoint(); auto tmp__1 = pt2.toPoint(); return QLine(tmp, tmp__1);
    }

private:
    QPointF pt1; QPointF pt2;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QLineF, Q_RELOCATABLE_TYPE);

/*******************************************************************************
 * class QLineF inline members
 *******************************************************************************/





#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug d, const QLineF &p);
#endif

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QLineF &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QLineF &);
#endif +/

