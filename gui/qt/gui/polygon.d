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
module qt.gui.polygon;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.typeinfo;
import qt.core.variant;
import qt.helpers;



// We export each out-of-line method individually to prevent MSVC from
// exporting the whole QList class.
/// Binding for C++ class [QPolygon](https://doc.qt.io/qt-6/qpolygon.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct QPolygon
{
    public QList!(QPoint) base0;
    alias base0 this;
public:
    /+ using QList<QPoint>::QList; +/
    /+ QPolygon() = default; +/
    /+ Q_IMPLICIT +/ this(ref QList!(QPoint) v)
    {
        this.base0 = v;
    }
    /+ Q_IMPLICIT +/ /+ QPolygon(QList<QPoint> &&v) noexcept : QList<QPoint>(std::move(v)) { } +/
    /+ Q_IMPLICIT +/ /+ Q_GUI_EXPORT +/this(ref const(QRect) r, bool closed=false);
    /+ Q_GUI_EXPORT +/this(int nPoints, const(int)* points);
    /+ void swap(QPolygon &other) noexcept { QList<QPoint>::swap(other); } +/ // prevent QList<QPoint><->QPolygon swaps

    /+/+ Q_GUI_EXPORT +/ auto opCast(T : QVariant)() const;+/

    /+ Q_GUI_EXPORT +/ void translate(int dx, int dy);
    pragma(inline, true) void translate(ref const(QPoint) offset)
    { translate(offset.x(), offset.y()); }

    /+ [[nodiscard]] +/ /+ Q_GUI_EXPORT +/ QPolygon translated(int dx, int dy) const;
    /+ [[nodiscard]] +/ pragma(inline, true) QPolygon translated(ref const(QPoint) offset) const
    { return translated(offset.x(), offset.y()); }

    /+ Q_GUI_EXPORT +/ QRect boundingRect() const;

    /+ Q_GUI_EXPORT +/ void point(int i, int* x, int* y) const;
    pragma(inline, true) QPoint point(int index) const
    { return at(index); }
    /+ Q_GUI_EXPORT +/ void setPoint(int index, int x, int y);
    pragma(inline, true) void setPoint(int index, ref const(QPoint) pt)
    { setPoint(index, pt.x(), pt.y()); }
    /+ Q_GUI_EXPORT +/ void setPoints(int nPoints, const(int)* points);
    /+ Q_GUI_EXPORT +/ void setPoints(int nPoints, int firstx, int firsty, ...);
    /+ Q_GUI_EXPORT +/ void putPoints(int index, int nPoints, const(int)* points);
    /+ Q_GUI_EXPORT +/ void putPoints(int index, int nPoints, int firstx, int firsty, ...);
    /+ Q_GUI_EXPORT +/ void putPoints(int index, int nPoints, ref const(QPolygon)  from, int fromIndex=0);

    /+ Q_GUI_EXPORT +/ bool containsPoint(ref const(QPoint) pt, /+ Qt:: +/qt.core.namespace.FillRule fillRule) const;

    /+ [[nodiscard]] +/ /+ Q_GUI_EXPORT +/ QPolygon united(ref const(QPolygon) r) const;
    /+ [[nodiscard]] +/ /+ Q_GUI_EXPORT +/ QPolygon intersected(ref const(QPolygon) r) const;
    /+ [[nodiscard]] +/ /+ Q_GUI_EXPORT +/ QPolygon subtracted(ref const(QPolygon) r) const;

    /+ Q_GUI_EXPORT +/ bool intersects(ref const(QPolygon) r) const;

    /+ [[nodiscard]] +/ pragma(inline, true) QPolygonF toPolygonF() const { return QPolygonF(this); }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED(QPolygon)

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QPolygon &);
#endif

/*****************************************************************************
  QPolygon stream functions
 *****************************************************************************/
#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &stream, const QPolygon &polygon);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &stream, QPolygon &polygon);
#endif +/

/*****************************************************************************
  Misc. QPolygon functions
 *****************************************************************************/


/// Binding for C++ class [QPolygonF](https://doc.qt.io/qt-6/qpolygonf.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct QPolygonF
{
    public QList!(QPointF) base0;
    alias base0 this;
public:
    /+ using QList<QPointF>::QList; +/
    /+ QPolygonF() = default; +/
    /+ Q_IMPLICIT +/ this(ref QList!(QPointF) v)
    {
        this.base0 = v;
    }
    /+ Q_IMPLICIT +/ /+ QPolygonF(QList<QPointF> &&v) noexcept : QList<QPointF>(std::move(v)) { } +/
    /+ Q_IMPLICIT +/ /+ Q_GUI_EXPORT +/this(ref const(QRectF) r);
    /+ Q_IMPLICIT +/ /+ Q_GUI_EXPORT +/this(ref const(QPolygon) a);
    /+ inline void swap(QPolygonF &other) { QList<QPointF>::swap(other); } +/ // prevent QList<QPointF><->QPolygonF swaps

    /+/+ Q_GUI_EXPORT +/ auto opCast(T : QVariant)() const;+/

    pragma(inline, true) void translate(qreal dx, qreal dy)
    { auto tmp = QPointF(dx, dy); translate(tmp); }
    void /+ Q_GUI_EXPORT +/ translate(ref const(QPointF) offset);

    pragma(inline, true) QPolygonF translated(qreal dx, qreal dy) const
    { auto tmp = QPointF(dx, dy); return translated(tmp); }
    /+ [[nodiscard]] +/ /+ Q_GUI_EXPORT +/ QPolygonF translated(ref const(QPointF) offset) const;

    QPolygon /+ Q_GUI_EXPORT +/ toPolygon() const;

    //bool isClosed() const { return !isEmpty() && first() == last(); }

    QRectF /+ Q_GUI_EXPORT +/ boundingRect() const;

    /+ Q_GUI_EXPORT +/ bool containsPoint(ref const(QPointF) pt, /+ Qt:: +/qt.core.namespace.FillRule fillRule) const;

    /+ [[nodiscard]] +/ /+ Q_GUI_EXPORT +/ QPolygonF united(ref const(QPolygonF) r) const;
    /+ [[nodiscard]] +/ /+ Q_GUI_EXPORT +/ QPolygonF intersected(ref const(QPolygonF) r) const;
    /+ [[nodiscard]] +/ /+ Q_GUI_EXPORT +/ QPolygonF subtracted(ref const(QPolygonF) r) const;

    /+ Q_GUI_EXPORT +/ bool intersects(ref const(QPolygonF) r) const;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED(QPolygonF)

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QPolygonF &);
#endif

/*****************************************************************************
  QPolygonF stream functions
 *****************************************************************************/
#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &stream, const QPolygonF &array);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &stream, QPolygonF &array);
#endif +/

