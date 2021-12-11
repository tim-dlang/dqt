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
module qt.core.rect;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.margins;
import qt.core.metatype;
import qt.core.point;
import qt.core.size;
import qt.core.typeinfo;
import qt.helpers;

/+ #ifdef topLeft
#error qrect.h must be included before any header file that defines topLeft
#endif

#if defined(Q_OS_DARWIN) || defined(Q_QDOC)
struct CGRect;
#endif +/


/// Binding for C++ class [QRect](https://doc.qt.io/qt-5/qrect.html).
@(QMetaType.Type.QRect) @Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QRect
{
public:
    /+this()/+ noexcept+/
    {
        this.x1 = 0;
        this.y1 = 0;
        this.x2 = -1;
        this.y2 = -1;
    }+/
    pragma(inline, true) this(ref const(QPoint) atopLeft, ref const(QPoint) abottomRight)/+ noexcept+/
    {
        this.x1 = atopLeft.x();
        this.y1 = atopLeft.y();
        this.x2 = abottomRight.x();
        this.y2 = abottomRight.y();
    }
    pragma(inline, true) this(const(QPoint) atopLeft, const(QSize) asize)/+ noexcept+/
    {
        this.x1 = atopLeft.x();
        this.y1 = atopLeft.y();
        this.x2 = atopLeft.x()+asize.width() - 1;
        this.y2 = atopLeft.y()+asize.height() - 1;
    }
    pragma(inline, true) this(int aleft, int atop, int awidth, int aheight)/+ noexcept+/
    {
        this.x1 = aleft;
        this.y1 = atop;
        this.x2 = aleft + awidth - 1;
        this.y2 = atop + aheight - 1;
    }

    pragma(inline, true) bool isNull() const/+ noexcept+/
    { return x2 == x1 - 1 && y2 == y1 - 1; }
    pragma(inline, true) bool isEmpty() const/+ noexcept+/
    { return x1 > x2 || y1 > y2; }
    pragma(inline, true) bool isValid() const/+ noexcept+/
    { return x1 <= x2 && y1 <= y2; }

    pragma(inline, true) int left() const/+ noexcept+/
    { return x1; }
    pragma(inline, true) int top() const/+ noexcept+/
    { return y1; }
    pragma(inline, true) int right() const/+ noexcept+/
    { return x2; }
    pragma(inline, true) int bottom() const/+ noexcept+/
    { return y2; }
    /+ Q_REQUIRED_RESULT +/ QRect normalized() const/+ noexcept+/;

    pragma(inline, true) int x() const/+ noexcept+/
    { return x1; }
    pragma(inline, true) int y() const/+ noexcept+/
    { return y1; }
    pragma(inline, true) void setLeft(int pos)/+ noexcept+/
    { x1 = pos; }
    pragma(inline, true) void setTop(int pos)/+ noexcept+/
    { y1 = pos; }
    pragma(inline, true) void setRight(int pos)/+ noexcept+/
    { x2 = pos; }
    pragma(inline, true) void setBottom(int pos)/+ noexcept+/
    { y2 = pos; }
    pragma(inline, true) void setX(int ax)/+ noexcept+/
    { x1 = ax; }
    pragma(inline, true) void setY(int ay)/+ noexcept+/
    { y1 = ay; }

    pragma(inline, true) void setTopLeft(ref const(QPoint) p)/+ noexcept+/
    { x1 = p.x(); y1 = p.y(); }
    pragma(inline, true) void setBottomRight(ref const(QPoint) p)/+ noexcept+/
    { x2 = p.x(); y2 = p.y(); }
    pragma(inline, true) void setTopRight(ref const(QPoint) p)/+ noexcept+/
    { x2 = p.x(); y1 = p.y(); }
    pragma(inline, true) void setBottomLeft(ref const(QPoint) p)/+ noexcept+/
    { x1 = p.x(); y2 = p.y(); }

    pragma(inline, true) QPoint topLeft() const/+ noexcept+/
    { return QPoint(x1, y1); }
    pragma(inline, true) QPoint bottomRight() const/+ noexcept+/
    { return QPoint(x2, y2); }
    pragma(inline, true) QPoint topRight() const/+ noexcept+/
    { return QPoint(x2, y1); }
    pragma(inline, true) QPoint bottomLeft() const/+ noexcept+/
    { return QPoint(x1, y2); }
    pragma(inline, true) QPoint center() const/+ noexcept+/
    { return QPoint(cast(int)((qint64(x1)+x2)/2), cast(int)((qint64(y1)+y2)/2)); } // cast avoids overflow on addition


    pragma(inline, true) void moveLeft(int pos)/+ noexcept+/
    { x2 += (pos - x1); x1 = pos; }
    pragma(inline, true) void moveTop(int pos)/+ noexcept+/
    { y2 += (pos - y1); y1 = pos; }
    pragma(inline, true) void moveRight(int pos)/+ noexcept+/
    {
        x1 += (pos - x2);
        x2 = pos;
    }
    pragma(inline, true) void moveBottom(int pos)/+ noexcept+/
    {
        y1 += (pos - y2);
        y2 = pos;
    }
    pragma(inline, true) void moveTopLeft(ref const(QPoint) p)/+ noexcept+/
    {
        moveLeft(p.x());
        moveTop(p.y());
    }
    pragma(inline, true) void moveBottomRight(ref const(QPoint) p)/+ noexcept+/
    {
        moveRight(p.x());
        moveBottom(p.y());
    }
    pragma(inline, true) void moveTopRight(ref const(QPoint) p)/+ noexcept+/
    {
        moveRight(p.x());
        moveTop(p.y());
    }
    pragma(inline, true) void moveBottomLeft(ref const(QPoint) p)/+ noexcept+/
    {
        moveLeft(p.x());
        moveBottom(p.y());
    }
    pragma(inline, true) void moveCenter(ref const(QPoint) p)/+ noexcept+/
    {
        int w = x2 - x1;
        int h = y2 - y1;
        x1 = p.x() - w/2;
        y1 = p.y() - h/2;
        x2 = x1 + w;
        y2 = y1 + h;
    }

    pragma(inline, true) void translate(int dx, int dy)/+ noexcept+/
    {
        x1 += dx;
        y1 += dy;
        x2 += dx;
        y2 += dy;
    }
    pragma(inline, true) void translate(ref const(QPoint) p)/+ noexcept+/
    {
        x1 += p.x();
        y1 += p.y();
        x2 += p.x();
        y2 += p.y();
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRect translated(int dx, int dy) const/+ noexcept+/
    { auto tmp = QPoint(x1 + dx, y1 + dy); auto tmp__1 = QPoint(x2 + dx, y2 + dy); return QRect(tmp, tmp__1); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRect translated(ref const(QPoint) p) const/+ noexcept+/
    { auto tmp = QPoint(x1 + p.x(), y1 + p.y()); auto tmp__1 = QPoint(x2 + p.x(), y2 + p.y()); return QRect(tmp, tmp__1); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRect transposed() const/+ noexcept+/
    { auto tmp = topLeft(); auto tmp__1 = size().transposed(); return QRect(tmp, tmp__1); }

    pragma(inline, true) void moveTo(int ax, int ay)/+ noexcept+/
    {
        x2 += ax - x1;
        y2 += ay - y1;
        x1 = ax;
        y1 = ay;
    }
    pragma(inline, true) void moveTo(ref const(QPoint) p)/+ noexcept+/
    {
        x2 += p.x() - x1;
        y2 += p.y() - y1;
        x1 = p.x();
        y1 = p.y();
    }

    pragma(inline, true) void setRect(int ax, int ay, int aw, int ah)/+ noexcept+/
    {
        x1 = ax;
        y1 = ay;
        x2 = (ax + aw - 1);
        y2 = (ay + ah - 1);
    }
    pragma(inline, true) void getRect(int* ax, int* ay, int* aw, int* ah) const
    {
        *ax = x1;
        *ay = y1;
        *aw = x2 - x1 + 1;
        *ah = y2 - y1 + 1;
    }

    pragma(inline, true) void setCoords(int xp1, int yp1, int xp2, int yp2)/+ noexcept+/
    {
        x1 = xp1;
        y1 = yp1;
        x2 = xp2;
        y2 = yp2;
    }
    pragma(inline, true) void getCoords(int* xp1, int* yp1, int* xp2, int* yp2) const
    {
        *xp1 = x1;
        *yp1 = y1;
        *xp2 = x2;
        *yp2 = y2;
    }

    pragma(inline, true) void adjust(int dx1, int dy1, int dx2, int dy2)/+ noexcept+/
    {
        x1 += dx1;
        y1 += dy1;
        x2 += dx2;
        y2 += dy2;
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRect adjusted(int xp1, int yp1, int xp2, int yp2) const/+ noexcept+/
    { auto tmp = QPoint(x1 + xp1, y1 + yp1); auto tmp__1 = QPoint(x2 + xp2, y2 + yp2); return QRect(tmp, tmp__1); }

    pragma(inline, true) QSize size() const/+ noexcept+/
    { return QSize(width(), height()); }
    pragma(inline, true) int width() const/+ noexcept+/
    { return  x2 - x1 + 1; }
    pragma(inline, true) int height() const/+ noexcept+/
    { return  y2 - y1 + 1; }
    pragma(inline, true) void setWidth(int w)/+ noexcept+/
    { x2 = (x1 + w - 1); }
    pragma(inline, true) void setHeight(int h)/+ noexcept+/
    { y2 = (y1 + h - 1); }
    pragma(inline, true) void setSize(ref const(QSize) s)/+ noexcept+/
    {
        x2 = (s.width()  + x1 - 1);
        y2 = (s.height() + y1 - 1);
    }

    QRect opBinary(string op)(ref const(QRect) r) const/+ noexcept+/ if(op == "|");
    QRect opBinary(string op)(ref const(QRect) r) const/+ noexcept+/ if(op == "&");
    pragma(inline, true) ref QRect opOpAssign(string op)(ref const(QRect) r)/+ noexcept+/ if(op == "|")
    {
        this = this | r;
        return this;
    }
    pragma(inline, true) ref QRect opOpAssign(string op)(ref const(QRect) r)/+ noexcept+/ if(op == "&")
    {
        this = this & r;
        return this;
    }

    bool contains(ref const(QRect) r, bool proper = false) const/+ noexcept+/;
    bool contains(ref const(QPoint) p, bool proper=false) const/+ noexcept+/;
    pragma(inline, true) bool contains(int ax, int ay) const/+ noexcept+/
    {
        auto tmp = QPoint(ax, ay); return contains(tmp, false);
    }
    pragma(inline, true) bool contains(int ax, int ay, bool aproper) const/+ noexcept+/
    {
        auto tmp = QPoint(ax, ay); return contains(tmp, aproper);
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRect united(ref const(QRect) r) const/+ noexcept+/
    {
        return this | r;
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRect intersected(ref const(QRect) other) const/+ noexcept+/
    {
        return this & other;
    }
    bool intersects(ref const(QRect) r) const/+ noexcept+/;

    pragma(inline, true) QRect marginsAdded(ref const(QMargins) margins) const/+ noexcept+/
    {
        auto tmp = QPoint(x1 - margins.left(), y1 - margins.top()); auto tmp__1 = QPoint(x2 + margins.right(), y2 + margins.bottom()); return QRect(tmp,
                     tmp__1);
    }
    pragma(inline, true) QRect marginsRemoved(ref const(QMargins) margins) const/+ noexcept+/
    {
        auto tmp = QPoint(x1 + margins.left(), y1 + margins.top()); auto tmp__1 = QPoint(x2 - margins.right(), y2 - margins.bottom()); return QRect(tmp,
                     tmp__1);
    }
    pragma(inline, true) ref QRect opOpAssign(string op)(ref const(QMargins) margins)/+ noexcept+/ if(op == "+")
    {
        this = marginsAdded(margins);
        return this;
    }
    pragma(inline, true) ref QRect opOpAssign(string op)(ref const(QMargins) margins)/+ noexcept+/ if(op == "-")
    {
        this = marginsRemoved(margins);
        return this;
    }

/+ #if QT_DEPRECATED_SINCE(5, 0)
    Q_REQUIRED_RESULT QT_DEPRECATED QRect unite(const QRect &r) const noexcept { return united(r); }
    Q_REQUIRED_RESULT QT_DEPRECATED QRect intersect(const QRect &r) const noexcept { return intersected(r); }
#endif +/

    /+ friend inline bool operator==(const QRect &, const QRect &) noexcept; +/
    /+ friend inline bool operator!=(const QRect &, const QRect &) noexcept; +/

    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ Q_REQUIRED_RESULT CGRect toCGRect() const noexcept; +/
    }

private:
    int x1 = 0;
    int y1 = 0;
    int x2 = -1;
    int y2 = -1;
}
/+ Q_DECLARE_TYPEINFO(QRect, Q_MOVABLE_TYPE);

inline bool operator==(const QRect &, const QRect &) noexcept;
inline bool operator!=(const QRect &, const QRect &) noexcept;


/*****************************************************************************
  QRect stream functions
 *****************************************************************************/
#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QRect &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QRect &);
#endif +/

/*****************************************************************************
  QRect inline member functions
 *****************************************************************************/

/+pragma(inline, true) bool operator ==(ref const(QRect) r1, ref const(QRect) r2)/+ noexcept+/
{
    return r1.x1==r2.x1 && r1.x2==r2.x2 && r1.y1==r2.y1 && r1.y2==r2.y2;
}+/

/+pragma(inline, true) bool operator !=(ref const(QRect) r1, ref const(QRect) r2)/+ noexcept+/
{
    return r1.x1!=r2.x1 || r1.x2!=r2.x2 || r1.y1!=r2.y1 || r1.y2!=r2.y2;
}+/

/+pragma(inline, true) QRect operator +(ref const(QRect) rectangle, ref const(QMargins) margins)/+ noexcept+/
{
    auto tmp = QPoint(rectangle.left() - margins.left(), rectangle.top() - margins.top()); auto tmp__1 = QPoint(rectangle.right() + margins.right(), rectangle.bottom() + margins.bottom()); return QRect(tmp,
                 tmp__1);
}+/

/+pragma(inline, true) QRect operator +(ref const(QMargins) margins, ref const(QRect) rectangle)/+ noexcept+/
{
    auto tmp = QPoint(rectangle.left() - margins.left(), rectangle.top() - margins.top()); auto tmp__1 = QPoint(rectangle.right() + margins.right(), rectangle.bottom() + margins.bottom()); return QRect(tmp,
                 tmp__1);
}+/

/+pragma(inline, true) QRect operator -(ref const(QRect) lhs, ref const(QMargins) rhs)/+ noexcept+/
{
    auto tmp = QPoint(lhs.left() + rhs.left(), lhs.top() + rhs.top()); auto tmp__1 = QPoint(lhs.right() - rhs.right(), lhs.bottom() - rhs.bottom()); return QRect(tmp,
                 tmp__1);
}+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QRect &);
#endif +/


/// Binding for C++ class [QRectF](https://doc.qt.io/qt-5/qrectf.html).
@(QMetaType.Type.QRectF) @Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QRectF
{
public:
    /+this()/+ noexcept+/
    {
        this.xp = 0.;
        this.yp = 0.;
        this.w = 0.;
        this.h = 0.;
    }+/
    pragma(inline, true) this(ref const(QPointF) atopLeft, ref const(QSizeF) asize)/+ noexcept+/
    {
        this.xp = atopLeft.x();
        this.yp = atopLeft.y();
        this.w = asize.width();
        this.h = asize.height();
    }
    pragma(inline, true) this(const(QPointF) atopLeft, const(QPointF) abottomRight)/+ noexcept+/
    {
        this.xp = atopLeft.x();
        this.yp = atopLeft.y();
        this.w = abottomRight.x() - atopLeft.x();
        this.h = abottomRight.y() - atopLeft.y();
    }
    pragma(inline, true) this(qreal aleft, qreal atop, qreal awidth, qreal aheight)/+ noexcept+/
    {
        this.xp = aleft;
        this.yp = atop;
        this.w = awidth;
        this.h = aheight;
    }
    pragma(inline, true) this(ref const(QRect) r)/+ noexcept+/
    {
        this.xp = r.x();
        this.yp = r.y();
        this.w = r.width();
        this.h = r.height();
    }

    pragma(inline, true) bool isNull() const/+ noexcept+/
    { return w == 0. && h == 0.; }
    pragma(inline, true) bool isEmpty() const/+ noexcept+/
    { return w <= 0. || h <= 0.; }
    pragma(inline, true) bool isValid() const/+ noexcept+/
    { return w > 0. && h > 0.; }
    /+ Q_REQUIRED_RESULT +/ QRectF normalized() const/+ noexcept+/;

    pragma(inline, true) qreal left() const/+ noexcept+/ { return xp; }
    pragma(inline, true) qreal top() const/+ noexcept+/ { return yp; }
    pragma(inline, true) qreal right() const/+ noexcept+/ { return xp + w; }
    pragma(inline, true) qreal bottom() const/+ noexcept+/ { return yp + h; }

    pragma(inline, true) qreal x() const/+ noexcept+/
    { return xp; }
    pragma(inline, true) qreal y() const/+ noexcept+/
    { return yp; }
    pragma(inline, true) void setLeft(qreal pos)/+ noexcept+/
    { qreal diff = pos - xp; xp += diff; w -= diff; }
    pragma(inline, true) void setTop(qreal pos)/+ noexcept+/
    { qreal diff = pos - yp; yp += diff; h -= diff; }
    pragma(inline, true) void setRight(qreal pos)/+ noexcept+/
    { w = pos - xp; }
    pragma(inline, true) void setBottom(qreal pos)/+ noexcept+/
    { h = pos - yp; }
    pragma(inline, true) void setX(qreal pos)/+ noexcept+/ { setLeft(pos); }
    pragma(inline, true) void setY(qreal pos)/+ noexcept+/ { setTop(pos); }

    pragma(inline, true) QPointF topLeft() const/+ noexcept+/ { return QPointF(xp, yp); }
    pragma(inline, true) QPointF bottomRight() const/+ noexcept+/ { return QPointF(xp+w, yp+h); }
    pragma(inline, true) QPointF topRight() const/+ noexcept+/ { return QPointF(xp+w, yp); }
    pragma(inline, true) QPointF bottomLeft() const/+ noexcept+/ { return QPointF(xp, yp+h); }
    pragma(inline, true) QPointF center() const/+ noexcept+/
    { return QPointF(xp + w/2, yp + h/2); }

    pragma(inline, true) void setTopLeft(ref const(QPointF) p)/+ noexcept+/
    { setLeft(p.x()); setTop(p.y()); }
    pragma(inline, true) void setBottomRight(ref const(QPointF) p)/+ noexcept+/
    { setRight(p.x()); setBottom(p.y()); }
    pragma(inline, true) void setTopRight(ref const(QPointF) p)/+ noexcept+/
    { setRight(p.x()); setTop(p.y()); }
    pragma(inline, true) void setBottomLeft(ref const(QPointF) p)/+ noexcept+/
    { setLeft(p.x()); setBottom(p.y()); }

    pragma(inline, true) void moveLeft(qreal pos)/+ noexcept+/
    { xp = pos; }
    pragma(inline, true) void moveTop(qreal pos)/+ noexcept+/
    { yp = pos; }
    pragma(inline, true) void moveRight(qreal pos)/+ noexcept+/
    { xp = pos - w; }
    pragma(inline, true) void moveBottom(qreal pos)/+ noexcept+/
    { yp = pos - h; }
    pragma(inline, true) void moveTopLeft(ref const(QPointF) p)/+ noexcept+/
    { moveLeft(p.x()); moveTop(p.y()); }
    pragma(inline, true) void moveBottomRight(ref const(QPointF) p)/+ noexcept+/
    { moveRight(p.x()); moveBottom(p.y()); }
    pragma(inline, true) void moveTopRight(ref const(QPointF) p)/+ noexcept+/
    { moveRight(p.x()); moveTop(p.y()); }
    pragma(inline, true) void moveBottomLeft(ref const(QPointF) p)/+ noexcept+/
    { moveLeft(p.x()); moveBottom(p.y()); }
    pragma(inline, true) void moveCenter(ref const(QPointF) p)/+ noexcept+/
    { xp = p.x() - w/2; yp = p.y() - h/2; }

    pragma(inline, true) void translate(qreal dx, qreal dy)/+ noexcept+/
    {
        xp += dx;
        yp += dy;
    }
    pragma(inline, true) void translate(ref const(QPointF) p)/+ noexcept+/
    {
        xp += p.x();
        yp += p.y();
    }

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRectF translated(qreal dx, qreal dy) const/+ noexcept+/
    { return QRectF(xp + dx, yp + dy, w, h); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRectF translated(ref const(QPointF) p) const/+ noexcept+/
    { return QRectF(xp + p.x(), yp + p.y(), w, h); }

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRectF transposed() const/+ noexcept+/
    { auto tmp = topLeft(); auto tmp__1 = size().transposed(); return QRectF(tmp, tmp__1); }

    pragma(inline, true) void moveTo(qreal ax, qreal ay)/+ noexcept+/
    {
        xp = ax;
        yp = ay;
    }
    pragma(inline, true) void moveTo(ref const(QPointF) p)/+ noexcept+/
    {
        xp = p.x();
        yp = p.y();
    }

    pragma(inline, true) void setRect(qreal ax, qreal ay, qreal aaw, qreal aah)/+ noexcept+/
    {
        this.xp = ax;
        this.yp = ay;
        this.w = aaw;
        this.h = aah;
    }
    pragma(inline, true) void getRect(qreal* ax, qreal* ay, qreal* aaw, qreal* aah) const
    {
        *ax = this.xp;
        *ay = this.yp;
        *aaw = this.w;
        *aah = this.h;
    }

    pragma(inline, true) void setCoords(qreal xp1, qreal yp1, qreal xp2, qreal yp2)/+ noexcept+/
    {
        xp = xp1;
        yp = yp1;
        w = xp2 - xp1;
        h = yp2 - yp1;
    }
    pragma(inline, true) void getCoords(qreal* xp1, qreal* yp1, qreal* xp2, qreal* yp2) const
    {
        *xp1 = xp;
        *yp1 = yp;
        *xp2 = xp + w;
        *yp2 = yp + h;
    }

    pragma(inline, true) void adjust(qreal xp1, qreal yp1, qreal xp2, qreal yp2)/+ noexcept+/
    { xp += xp1; yp += yp1; w += xp2 - xp1; h += yp2 - yp1; }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRectF adjusted(qreal xp1, qreal yp1, qreal xp2, qreal yp2) const/+ noexcept+/
    { return QRectF(xp + xp1, yp + yp1, w + xp2 - xp1, h + yp2 - yp1); }

    pragma(inline, true) QSizeF size() const/+ noexcept+/
    { return QSizeF(w, h); }
    pragma(inline, true) qreal width() const/+ noexcept+/
    { return w; }
    pragma(inline, true) qreal height() const/+ noexcept+/
    { return h; }
    pragma(inline, true) void setWidth(qreal aw)/+ noexcept+/
    { this.w = aw; }
    pragma(inline, true) void setHeight(qreal ah)/+ noexcept+/
    { this.h = ah; }
    pragma(inline, true) void setSize(ref const(QSizeF) s)/+ noexcept+/
    {
        w = s.width();
        h = s.height();
    }

    QRectF opBinary(string op)(ref const(QRectF) r) const/+ noexcept+/ if(op == "|");
    QRectF opBinary(string op)(ref const(QRectF) r) const/+ noexcept+/ if(op == "&");
    pragma(inline, true) ref QRectF opOpAssign(string op)(ref const(QRectF) r)/+ noexcept+/ if(op == "|")
    {
        this = this | r;
        return this;
    }
    pragma(inline, true) ref QRectF opOpAssign(string op)(ref const(QRectF) r)/+ noexcept+/ if(op == "&")
    {
        this = this & r;
        return this;
    }

    bool contains(ref const(QRectF) r) const/+ noexcept+/;
    bool contains(ref const(QPointF) p) const/+ noexcept+/;
    pragma(inline, true) bool contains(qreal ax, qreal ay) const/+ noexcept+/
    {
        auto tmp = QPointF(ax, ay); return contains(tmp);
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRectF united(ref const(QRectF) r) const/+ noexcept+/
    {
        return this | r;
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRectF intersected(ref const(QRectF) r) const/+ noexcept+/
    {
        return this & r;
    }
    bool intersects(ref const(QRectF) r) const/+ noexcept+/;

    pragma(inline, true) QRectF marginsAdded(ref const(QMarginsF) margins) const/+ noexcept+/
    {
        auto tmp = QPointF(xp - margins.left(), yp - margins.top()); auto tmp__1 = QSizeF(w + margins.left() + margins.right(), h + margins.top() + margins.bottom()); return QRectF(tmp,
                      tmp__1);
    }
    pragma(inline, true) QRectF marginsRemoved(ref const(QMarginsF) margins) const/+ noexcept+/
    {
        auto tmp = QPointF(xp + margins.left(), yp + margins.top()); auto tmp__1 = QSizeF(w - margins.left() - margins.right(), h - margins.top() - margins.bottom()); return QRectF(tmp,
                      tmp__1);
    }
    pragma(inline, true) ref QRectF opOpAssign(string op)(ref const(QMarginsF) margins)/+ noexcept+/ if(op == "+")
    {
        this = marginsAdded(margins);
        return this;
    }
    pragma(inline, true) ref QRectF opOpAssign(string op)(ref const(QMarginsF) margins)/+ noexcept+/ if(op == "-")
    {
        this = marginsRemoved(margins);
        return this;
    }

/+ #if QT_DEPRECATED_SINCE(5, 0)
    Q_REQUIRED_RESULT QT_DEPRECATED QRectF unite(const QRectF &r) const noexcept { return united(r); }
    Q_REQUIRED_RESULT QT_DEPRECATED QRectF intersect(const QRectF &r) const noexcept { return intersected(r); }
#endif +/

    /+ friend inline bool operator==(const QRectF &, const QRectF &) noexcept; +/
    /+ friend inline bool operator!=(const QRectF &, const QRectF &) noexcept; +/

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRect toRect() const/+ noexcept+/
    {
        auto tmp = QPoint(qRound(xp), qRound(yp)); auto tmp__1 = QPoint(qRound(xp + w) - 1, qRound(yp + h) - 1); return QRect(tmp, tmp__1);
    }
    /+ Q_REQUIRED_RESULT +/ QRect toAlignedRect() const/+ noexcept+/;

    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ Q_REQUIRED_RESULT static QRectF fromCGRect(CGRect rect) noexcept; +/
        /+ Q_REQUIRED_RESULT CGRect toCGRect() const noexcept; +/
    }

private:
    qreal xp = 0.;
    qreal yp = 0.;
    qreal w = 0.;
    qreal h = 0.;
}
/+ Q_DECLARE_TYPEINFO(QRectF, Q_MOVABLE_TYPE);

inline bool operator==(const QRectF &, const QRectF &) noexcept;
inline bool operator!=(const QRectF &, const QRectF &) noexcept;


/*****************************************************************************
  QRectF stream functions
 *****************************************************************************/
#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QRectF &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QRectF &);
#endif

/*****************************************************************************
  QRectF inline member functions
 *****************************************************************************/


QT_WARNING_PUSH
QT_WARNING_DISABLE_CLANG("-Wfloat-equal")
QT_WARNING_DISABLE_GCC("-Wfloat-equal")
QT_WARNING_DISABLE_INTEL(1572)

QT_WARNING_POP +/

/+pragma(inline, true) bool operator ==(ref const(QRectF) r1, ref const(QRectF) r2)/+ noexcept+/
{
    return qFuzzyCompare(r1.xp, r2.xp) && qFuzzyCompare(r1.yp, r2.yp)
           && qFuzzyCompare(r1.w, r2.w) && qFuzzyCompare(r1.h, r2.h);
}+/

/+pragma(inline, true) bool operator !=(ref const(QRectF) r1, ref const(QRectF) r2)/+ noexcept+/
{
    return !qFuzzyCompare(r1.xp, r2.xp) || !qFuzzyCompare(r1.yp, r2.yp)
           || !qFuzzyCompare(r1.w, r2.w) || !qFuzzyCompare(r1.h, r2.h);
}+/

/+pragma(inline, true) QRectF operator +(ref const(QRectF) lhs, ref const(QMarginsF) rhs)/+ noexcept+/
{
    auto tmp = QPointF(lhs.left() - rhs.left(), lhs.top() - rhs.top()); auto tmp__1 = QSizeF(lhs.width() + rhs.left() + rhs.right(), lhs.height() + rhs.top() + rhs.bottom()); return QRectF(tmp,
                  tmp__1);
}+/

/+pragma(inline, true) QRectF operator +(ref const(QMarginsF) lhs, ref const(QRectF) rhs)/+ noexcept+/
{
    auto tmp = QPointF(rhs.left() - lhs.left(), rhs.top() - lhs.top()); auto tmp__1 = QSizeF(rhs.width() + lhs.left() + lhs.right(), rhs.height() + lhs.top() + lhs.bottom()); return QRectF(tmp,
                  tmp__1);
}+/

/+pragma(inline, true) QRectF operator -(ref const(QRectF) lhs, ref const(QMarginsF) rhs)/+ noexcept+/
{
    auto tmp = QPointF(lhs.left() + rhs.left(), lhs.top() + rhs.top()); auto tmp__1 = QSizeF(lhs.width() - rhs.left() - rhs.right(), lhs.height() - rhs.top() - rhs.bottom()); return QRectF(tmp,
                  tmp__1);
}+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QRectF &);
#endif +/

