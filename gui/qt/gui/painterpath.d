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
module qt.gui.painterpath;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.scopedpointer;
import qt.core.string;
import qt.core.vector;
import qt.gui.font;
import qt.gui.matrix;
import qt.gui.pen;
import qt.gui.polygon;
import qt.gui.region;
import qt.gui.transform;
import qt.helpers;

/+ class QFont; +/
extern(C++, class) struct QPainterPathPrivate;
struct QPainterPathPrivateDeleter;
extern(C++, class) struct QPainterPathData;
extern(C++, class) struct QPainterPathStrokerPrivate;
/+ class QPen;
class QPolygonF;
class QRegion; +/
extern(C++, class) struct QVectorPath;

/// Binding for C++ class [QPainterPath](https://doc.qt.io/qt-5/qpainterpath.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPainterPath
{
public:
    enum ElementType {
        MoveToElement,
        LineToElement,
        CurveToElement,
        CurveToDataElement
    }

    extern(C++, class) struct Element {
    public:
        qreal x;
        qreal y;
        ElementType type;

        bool isMoveTo() const { return type == ElementType.MoveToElement; }
        bool isLineTo() const { return type == ElementType.LineToElement; }
        bool isCurveTo() const { return type == ElementType.CurveToElement; }

        /+auto opCast(T : QPointF) () const { return QPointF(x, y); }+/

        /+bool operator ==(ref const(Element) e) const { return qt.core.global.qFuzzyCompare(x, e.x)
            && qt.core.global.qFuzzyCompare(y, e.y) && type == e.type; }+/
        /+pragma(inline, true) bool operator !=(ref const(Element) e) const { return !operator==(e); }+/
    }

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor()/+ noexcept+/;
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ explicit +/this(ref const(QPointF) startPoint);
    @disable this(this);
    this(ref const(QPainterPath) other);
    /+ref QPainterPath operator =(ref const(QPainterPath) other);+/
    /+ inline QPainterPath &operator=(QPainterPath &&other) noexcept
    { qSwap(d_ptr, other.d_ptr); return *this; } +/
    ~this();

    /+ inline void swap(QPainterPath &other) noexcept { d_ptr.swap(other.d_ptr); } +/

    void clear();
    void reserve(int size);
    int capacity() const;

    void closeSubpath();

    void moveTo(ref const(QPointF) p);
    pragma(inline, true) void moveTo(qreal x, qreal y)
    {
        auto tmp = QPointF(x, y); moveTo(tmp);
    }

    void lineTo(ref const(QPointF) p);
    pragma(inline, true) void lineTo(qreal x, qreal y)
    {
        auto tmp = QPointF(x, y); lineTo(tmp);
    }

    void arcMoveTo(ref const(QRectF) rect, qreal angle);
    pragma(inline, true) void arcMoveTo(qreal x, qreal y, qreal w, qreal h, qreal angle)
    {
        auto tmp = QRectF(x, y, w, h); arcMoveTo(tmp, angle);
    }

    void arcTo(ref const(QRectF) rect, qreal startAngle, qreal arcLength);
    pragma(inline, true) void arcTo(qreal x, qreal y, qreal w, qreal h, qreal startAngle, qreal arcLength)
    {
        auto tmp = QRectF(x, y, w, h); arcTo(tmp, startAngle, arcLength);
    }

    void cubicTo(ref const(QPointF) ctrlPt1, ref const(QPointF) ctrlPt2, ref const(QPointF) endPt);
    pragma(inline, true) void cubicTo(qreal ctrlPt1x, qreal ctrlPt1y, qreal ctrlPt2x, qreal ctrlPt2y,
                            qreal endPtx, qreal endPty)
    {
        auto tmp = QPointF(ctrlPt1x, ctrlPt1y); auto tmp__1 = QPointF(ctrlPt2x, ctrlPt2y); auto tmp__2 = QPointF(endPtx, endPty); cubicTo(tmp, tmp__1,
                tmp__2);
    }
    void quadTo(ref const(QPointF) ctrlPt, ref const(QPointF) endPt);
    pragma(inline, true) void quadTo(qreal ctrlPtx, qreal ctrlPty, qreal endPtx, qreal endPty)
    {
        auto tmp = QPointF(ctrlPtx, ctrlPty); auto tmp__1 = QPointF(endPtx, endPty); quadTo(tmp, tmp__1);
    }

    QPointF currentPosition() const;

    void addRect(ref const(QRectF) rect);
    pragma(inline, true) void addRect(qreal x, qreal y, qreal w, qreal h)
    {
        auto tmp = QRectF(x, y, w, h); addRect(tmp);
    }
    void addEllipse(ref const(QRectF) rect);
/+    pragma(inline, true) void addEllipse(qreal x, qreal y, qreal w, qreal h)
    {
        auto tmp = QRectF(x, y, w, h); addEllipse(tmp);
    }
    pragma(inline, true) void addEllipse(ref const(QPointF) center, qreal rx, qreal ry)
    {
        auto tmp = QRectF(center.x() - rx, center.y() - ry, 2 * rx, 2 * ry); addEllipse(tmp);
    }+/
    void addPolygon(ref const(QPolygonF) polygon);
    void addText(ref const(QPointF) point, ref const(QFont) f, ref const(QString) text);
    pragma(inline, true) void addText(qreal x, qreal y, ref const(QFont) f, ref const(QString) text)
    {
        auto tmp = QPointF(x, y); addText(tmp, f, text);
    }
    void addPath(ref const(QPainterPath) path);
    void addRegion(ref const(QRegion) region);

    void addRoundedRect(ref const(QRectF) rect, qreal xRadius, qreal yRadius,
                            /+ Qt:: +/qt.core.namespace.SizeMode mode = /+ Qt:: +/qt.core.namespace.SizeMode.AbsoluteSize);
    pragma(inline, true) void addRoundedRect(qreal x, qreal y, qreal w, qreal h,
                                   qreal xRadius, qreal yRadius,
                                   /+ Qt:: +/qt.core.namespace.SizeMode mode = /+ Qt:: +/qt.core.namespace.SizeMode.AbsoluteSize)
    {
        auto tmp = QRectF(x, y, w, h); addRoundedRect(tmp, xRadius, yRadius, mode);
    }

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use addRoundedRect(..., Qt::RelativeSize) instead") +/
        void addRoundRect(ref const(QRectF) rect, int xRnd, int yRnd);
    /+ QT_DEPRECATED_X("Use addRoundedRect(..., Qt::RelativeSize) instead") +/
        void addRoundRect(qreal x, qreal y, qreal w, qreal h,
                          int xRnd, int yRnd);
    /+ QT_DEPRECATED_X("Use addRoundedRect(..., Qt::RelativeSize) instead") +/
        void addRoundRect(ref const(QRectF) rect, int roundness);
    /+ QT_DEPRECATED_X("Use addRoundedRect(..., Qt::RelativeSize) instead") +/
        void addRoundRect(qreal x, qreal y, qreal w, qreal h,
                          int roundness);
/+ #endif +/

    void connectPath(ref const(QPainterPath) path);

    bool contains(ref const(QPointF) pt) const;
    bool contains(ref const(QRectF) rect) const;
    bool intersects(ref const(QRectF) rect) const;

    void translate(qreal dx, qreal dy);
    pragma(inline, true) void translate(ref const(QPointF) offset)
    { translate(offset.x(), offset.y()); }

    /+ Q_REQUIRED_RESULT +/ QPainterPath translated(qreal dx, qreal dy) const;
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QPainterPath translated(ref const(QPointF) offset) const
    { return translated(offset.x(), offset.y()); }

    QRectF boundingRect() const;
    QRectF controlPointRect() const;

    /+ Qt:: +/qt.core.namespace.FillRule fillRule() const;
    void setFillRule(/+ Qt:: +/qt.core.namespace.FillRule fillRule);

    bool isEmpty() const;

    /+ Q_REQUIRED_RESULT +/ QPainterPath toReversed() const;

/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+ QT_DEPRECATED_X("Use toSubpathPolygons(const QTransform &)") +/
        QList!(QPolygonF) toSubpathPolygons(ref const(QMatrix) matrix) const;
    /+ QT_DEPRECATED_X("Use toFillPolygons(const QTransform &") +/
        QList!(QPolygonF) toFillPolygons(ref const(QMatrix) matrix) const;
    /+ QT_DEPRECATED_X("Use toFillPolygon(const QTransform &)") +/
        QPolygonF toFillPolygon(ref const(QMatrix) matrix) const;
/+ #endif +/ // QT_DEPRECATED_SINCE(5, 15)
    QList!(QPolygonF) toSubpathPolygons(ref const(QTransform) matrix = globalInitVar!QTransform) const;
    QList!(QPolygonF) toFillPolygons(ref const(QTransform) matrix = globalInitVar!QTransform) const;
    QPolygonF toFillPolygon(ref const(QTransform) matrix = globalInitVar!QTransform) const;

    int elementCount() const;
    QPainterPath.Element elementAt(int i) const;
    void setElementPositionAt(int i, qreal x, qreal y);

    qreal   length() const;
    qreal   percentAtLength(qreal t) const;
    QPointF pointAtPercent(qreal t) const;
    qreal   angleAtPercent(qreal t) const;
    qreal   slopeAtPercent(qreal t) const;

    bool intersects(ref const(QPainterPath) p) const;
    bool contains(ref const(QPainterPath) p) const;
    /+ Q_REQUIRED_RESULT +/ QPainterPath united(ref const(QPainterPath) r) const;
    /+ Q_REQUIRED_RESULT +/ QPainterPath intersected(ref const(QPainterPath) r) const;
    /+ Q_REQUIRED_RESULT +/ QPainterPath subtracted(ref const(QPainterPath) r) const;
/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use r.subtracted() instead") +/
        /+ Q_REQUIRED_RESULT +/ QPainterPath subtractedInverted(ref const(QPainterPath) r) const;
/+ #endif +/

    /+ Q_REQUIRED_RESULT +/ QPainterPath simplified() const;

    /+bool operator ==(ref const(QPainterPath) other) const;+/
    /+bool operator !=(ref const(QPainterPath) other) const;+/

    QPainterPath opBinary(string op)(ref const(QPainterPath) other) const if(op == "&");
    QPainterPath opBinary(string op)(ref const(QPainterPath) other) const if(op == "|");
    QPainterPath opBinary(string op)(ref const(QPainterPath) other) const if(op == "+");
    QPainterPath opBinary(string op)(ref const(QPainterPath) other) const if(op == "-");
    ref QPainterPath opOpAssign(string op)(ref const(QPainterPath) other) if(op == "&");
    ref QPainterPath opOpAssign(string op)(ref const(QPainterPath) other) if(op == "|");
    ref QPainterPath opOpAssign(string op)(ref const(QPainterPath) other) if(op == "+");
    ref QPainterPath opOpAssign(string op)(ref const(QPainterPath) other) if(op == "-");

private:
    QScopedPointer!(QPainterPathPrivate, QPainterPathPrivateDeleter) d_ptr;

//    pragma(inline, true) void ensureData() { if (!d_ptr) ensureData_helper(); }
    void ensureData_helper();
    void detach();
    void detach_helper();
    void setDirty(bool);
    void computeBoundingRect() const;
    void computeControlPointRect() const;

    /+ QPainterPathData *d_func() const { return reinterpret_cast<QPainterPathData *>(d_ptr.data()); } +/

    /+ friend class QPainterPathData; +/
    /+ friend class QPainterPathStroker; +/
    /+ friend class QPainterPathStrokerPrivate; +/
    /+ friend class QMatrix; +/
    /+ friend class QTransform; +/
    /+ friend class QVectorPath; +/
    /+ friend Q_GUI_EXPORT const QVectorPath &qtVectorPathForPath(const QPainterPath &); +/

    version(QT_NO_DATASTREAM){}else
    {
        /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QPainterPath &); +/
        /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QPainterPath &); +/
    }
}

/+ Q_DECLARE_SHARED_NOT_MOVABLE_UNTIL_QT6(QPainterPath)
Q_DECLARE_TYPEINFO(QPainterPath::Element, Q_PRIMITIVE_TYPE);

#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QPainterPath &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QPainterPath &);
#endif +/

/// Binding for C++ class [QPainterPathStroker](https://doc.qt.io/qt-5/qpainterpathstroker.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPainterPathStroker
{
private:
    /+ Q_DECLARE_PRIVATE(QPainterPathStroker) +/
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ explicit +/this(ref const(QPen) pen);
    ~this();

    void setWidth(qreal width);
    qreal width() const;

    void setCapStyle(/+ Qt:: +/qt.core.namespace.PenCapStyle style);
    /+ Qt:: +/qt.core.namespace.PenCapStyle capStyle() const;

    void setJoinStyle(/+ Qt:: +/qt.core.namespace.PenJoinStyle style);
    /+ Qt:: +/qt.core.namespace.PenJoinStyle joinStyle() const;

    void setMiterLimit(qreal length);
    qreal miterLimit() const;

    void setCurveThreshold(qreal threshold);
    qreal curveThreshold() const;

    void setDashPattern(/+ Qt:: +/qt.core.namespace.PenStyle);
    void setDashPattern(ref const(QVector!(qreal)) dashPattern);
    QVector!(qreal) dashPattern() const;

    void setDashOffset(qreal offset);
    qreal dashOffset() const;

    QPainterPath createStroke(ref const(QPainterPath) path) const;

private:
    /+ Q_DISABLE_COPY(QPainterPathStroker) +/
@disable this(this);
/+this(ref const(QPainterPathStroker));+//+ref QPainterPathStroker operator =(ref const(QPainterPathStroker));+/
    /+ friend class QX11PaintEngine; +/

    QScopedPointer!(QPainterPathStrokerPrivate) d_ptr;
}

/+pragma(inline, true) QPainterPath operator *(ref const(QPainterPath) p, ref const(QTransform) m)
{ return m.map(p); }+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QPainterPath &);
#endif +/

