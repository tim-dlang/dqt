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
import qt.core.metatype;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.typeinfo;
import qt.core.variant;
import qt.core.vector;
import qt.helpers;


/// Binding for C++ class [QPolygon](https://doc.qt.io/qt-5/qpolygon.html).
@Q_RELOCATABLE_TYPE @(QMetaType.Type.QPolygon) extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPolygon
{
    public QVector!(QPoint) base0;
    alias base0 this;
public:
    @disable this();
    /+pragma(inline, true) this() {}+/
    pragma(inline, true) ~this() {}
    /+/+ explicit +/pragma(inline, true) this(int asize)
    {
        this.QVector!(QPoint) = asize;
    }
    pragma(inline, true) this(ref const(QVector!(QPoint)) v)
    {
        this.QVector!(QPoint) = v;
    }+/
    /*implicit*/ /+ QPolygon(QVector<QPoint> &&v) noexcept : QVector<QPoint>(std::move(v)) {} +/
    this(ref const(QRect) r, bool closed=false);
    this(int nPoints, const(int)* points);
    @disable this(this);
    this(ref const(QPolygon) other)
    {
        this.base0 = *cast(QVector!QPoint*)&other.base0;
    }
    /+ QPolygon(QPolygon &&other) noexcept : QVector<QPoint>(std::move(other)) {} +/
    /+ QPolygon &operator=(QPolygon &&other) noexcept { swap(other); return *this; } +/
    /+ref QPolygon operator =(ref const(QPolygon) other) { QVector!(QPoint).operator=(other); return this; }+/
    /+ void swap(QPolygon &other) noexcept { QVector<QPoint>::swap(other); } +/ // prevent QVector<QPoint><->QPolygon swaps

    /+auto opCast(T : QVariant)() const;+/

    void translate(int dx, int dy);
    pragma(inline, true) void translate(ref const(QPoint) offset)
    { translate(offset.x(), offset.y()); }

    /+ Q_REQUIRED_RESULT +/ QPolygon translated(int dx, int dy) const;
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QPolygon translated(ref const(QPoint) offset) const
    { return translated(offset.x(), offset.y()); }

    QRect boundingRect() const;

    void point(int i, int* x, int* y) const;
    pragma(inline, true) QPoint point(int index) const
    { return at(index); }
    pragma(inline, true) void setPoint(int index, int x, int y)
    { (this)[index] = QPoint(x, y); }
    pragma(inline, true) void setPoint(int index, ref const(QPoint) pt)
    { (this)[index] = pt; }
    void setPoints(int nPoints, const(int)* points);
    void setPoints(int nPoints, int firstx, int firsty, ...);
    void putPoints(int index, int nPoints, const(int)* points);
    void putPoints(int index, int nPoints, int firstx, int firsty, ...);
    void putPoints(int index, int nPoints, ref const(QPolygon)  from, int fromIndex=0);

    bool containsPoint(ref const(QPoint) pt, /+ Qt:: +/qt.core.namespace.FillRule fillRule) const;

    /+ Q_REQUIRED_RESULT +/ QPolygon united(ref const(QPolygon) r) const;
    /+ Q_REQUIRED_RESULT +/ QPolygon intersected(ref const(QPolygon) r) const;
    /+ Q_REQUIRED_RESULT +/ QPolygon subtracted(ref const(QPolygon) r) const;

    bool intersects(ref const(QPolygon) r) const;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED_NOT_MOVABLE_UNTIL_QT6(QPolygon)

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


/// Binding for C++ class [QPolygonF](https://doc.qt.io/qt-5/qpolygonf.html).
@Q_RELOCATABLE_TYPE @(QMetaType.Type.QPolygonF) extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPolygonF
{
    public QVector!(QPointF) base0;
    alias base0 this;
public:
    @disable this();
    /+pragma(inline, true) this() {}+/
    pragma(inline, true) ~this() {}
    /+/+ explicit +/pragma(inline, true) this(int asize)
    {
        this.QVector!(QPointF) = asize;
    }
    pragma(inline, true) this(ref const(QVector!(QPointF)) v)
    {
        this.QVector!(QPointF) = v;
    }+/
    /* implicit */ /+ QPolygonF(QVector<QPointF> &&v) noexcept : QVector<QPointF>(std::move(v)) {} +/
    this(ref const(QRectF) r);
    /*implicit*/ this(ref const(QPolygon) a);
    //@disable this(this);
    /+pragma(inline, true) this(ref const(QPolygonF) a)
    {
        this.QVector!(QPointF) = a;
    }+/
    /+ QPolygonF(QPolygonF &&other) noexcept : QVector<QPointF>(std::move(other)) {} +/
    /+ QPolygonF &operator=(QPolygonF &&other) noexcept { swap(other); return *this; } +/
    /+ref QPolygonF operator =(ref const(QPolygonF) other) { QVector!(QPointF).operator=(other); return this; }+/
    /+ inline void swap(QPolygonF &other) { QVector<QPointF>::swap(other); } +/ // prevent QVector<QPointF><->QPolygonF swaps

    /+auto opCast(T : QVariant)() const;+/

    pragma(inline, true) void translate(qreal dx, qreal dy)
    { auto tmp = QPointF(dx, dy); translate(tmp); }
    void translate(ref const(QPointF) offset);

    pragma(inline, true) QPolygonF translated(qreal dx, qreal dy) const
    { auto tmp = QPointF(dx, dy); return translated(tmp); }
    /+ Q_REQUIRED_RESULT +/ QPolygonF translated(ref const(QPointF) offset) const;

    QPolygon toPolygon() const;

    bool isClosed() const { return !isEmpty() && first() == last(); }

    QRectF boundingRect() const;

    bool containsPoint(ref const(QPointF) pt, /+ Qt:: +/qt.core.namespace.FillRule fillRule) const;

    /+ Q_REQUIRED_RESULT +/ QPolygonF united(ref const(QPolygonF) r) const;
    /+ Q_REQUIRED_RESULT +/ QPolygonF intersected(ref const(QPolygonF) r) const;
    /+ Q_REQUIRED_RESULT +/ QPolygonF subtracted(ref const(QPolygonF) r) const;

    bool intersects(ref const(QPolygonF) r) const;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED_NOT_MOVABLE_UNTIL_QT6(QPolygonF)

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

