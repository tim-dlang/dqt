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
module qt.gui.matrix;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.line;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.painterpath;
import qt.gui.polygon;
import qt.gui.region;
import qt.helpers;


/// Binding for C++ class [QMatrix](https://doc.qt.io/qt-5/qmatrix.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QMatrix // 2D transform matrix
{
public:
    /+ explicit +/pragma(inline, true) this(/+ Qt:: +/qt.core.namespace.Initialization) {}
    /+this();+/

    this(qreal m11, qreal m12, qreal m21, qreal m22,
                qreal dx, qreal dy);

/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    // ### Qt 6: remove; the compiler-generated ones are fine!
    /+ QMatrix &operator=(QMatrix &&other) noexcept // = default
    { memcpy(static_cast<void *>(this), static_cast<void *>(&other), sizeof(QMatrix)); return *this; } +/
    /+ref QMatrix opAssign(ref const(QMatrix) ) nothrow;+/ // = default
    /+ QMatrix(QMatrix &&other) noexcept // = default
    { memcpy(static_cast<void *>(this), static_cast<void *>(&other), sizeof(QMatrix)); } +/
    @disable this(this);
    this(ref const(QMatrix) other) nothrow; // = default
/+ #endif +/

    void setMatrix(qreal m11, qreal m12, qreal m21, qreal m22,
                       qreal dx, qreal dy);

    qreal m11() const { return _m11; }
    qreal m12() const { return _m12; }
    qreal m21() const { return _m21; }
    qreal m22() const { return _m22; }
    qreal dx() const { return _dx; }
    qreal dy() const { return _dy; }

    void map(int x, int y, int* tx, int* ty) const;
    void map(qreal x, qreal y, qreal* tx, qreal* ty) const;
    QRect mapRect(ref const(QRect) ) const;
    QRectF mapRect(ref const(QRectF) ) const;

    QPoint map(ref const(QPoint) p) const;
    QPointF map(ref const(QPointF) p) const;
    QLine map(ref const(QLine) l) const;
    QLineF map(ref const(QLineF) l) const;
    QPolygonF map(ref const(QPolygonF) a) const;
    QPolygon map(ref const(QPolygon) a) const;
    QRegion map(ref const(QRegion) r) const;
    QPainterPath map(ref const(QPainterPath) p) const;
    QPolygon mapToPolygon(ref const(QRect) r) const;

    void reset();
    pragma(inline, true) bool isIdentity() const
    {
        return qFuzzyIsNull(_m11 - 1) && qFuzzyIsNull(_m22 - 1) && qFuzzyIsNull(_m12)
               && qFuzzyIsNull(_m21) && qFuzzyIsNull(_dx) && qFuzzyIsNull(_dy);
    }

    ref QMatrix translate(qreal dx, qreal dy);
    ref QMatrix scale(qreal sx, qreal sy);
    ref QMatrix shear(qreal sh, qreal sv);
    ref QMatrix rotate(qreal a);

    bool isInvertible() const { return !qFuzzyIsNull(_m11*_m22 - _m12*_m21); }
    qreal determinant() const { return _m11*_m22 - _m12*_m21; }

    /+ Q_REQUIRED_RESULT +/ QMatrix inverted(bool* invertible = null) const;

    /+bool operator ==(ref const(QMatrix) ) const;+/
    /+bool operator !=(ref const(QMatrix) ) const;+/

    /+ref QMatrix operator *=(ref const(QMatrix) );+/
    /+QMatrix operator *(ref const(QMatrix) o) const;+/

    /+auto opCast(T : QVariant)() const;+/

package:
    pragma(inline, true) this(bool)
    {
        this._m11 = 1.;
        this._m12 = 0.;
        this._m21 = 0.;
        this._m22 = 1.;
        this._dx = 0.;
        this._dy = 0.;
    }
    pragma(inline, true) this(qreal am11, qreal am12, qreal am21, qreal am22, qreal adx, qreal ady, bool)
    {
        this._m11 = am11;
        this._m12 = am12;
        this._m21 = am21;
        this._m22 = am22;
        this._dx = adx;
        this._dy = ady;
    }
    /+ friend class QTransform; +/
    qreal _m11 = 1; qreal _m12 = 0;
    qreal _m21 = 0; qreal _m22 = 1;
    qreal _dx = 0; qreal _dy = 0;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QMatrix, Q_MOVABLE_TYPE);

Q_GUI_EXPORT Q_DECL_CONST_FUNCTION uint qHash(const QMatrix &key, uint seed = 0) noexcept; +/

// mathematical semantics
/+pragma(inline, true) QPoint operator *(ref const(QPoint) p, ref const(QMatrix) m)
{ return m.map(p); }+/
/+pragma(inline, true) QPointF operator *(ref const(QPointF) p, ref const(QMatrix) m)
{ return m.map(p); }+/
/+pragma(inline, true) QLineF operator *(ref const(QLineF) l, ref const(QMatrix) m)
{ return m.map(l); }+/
/+pragma(inline, true) QLine operator *(ref const(QLine) l, ref const(QMatrix) m)
{ return m.map(l); }+/
/+pragma(inline, true) QPolygon operator *(ref const(QPolygon) a, ref const(QMatrix) m)
{ return m.map(a); }+/
/+pragma(inline, true) QPolygonF operator *(ref const(QPolygonF) a, ref const(QMatrix) m)
{ return m.map(a); }+/
/+pragma(inline, true) QRegion operator *(ref const(QRegion) r, ref const(QMatrix) m)
{ return m.map(r); }+/
/+/+ Q_GUI_EXPORT +/ QPainterPath operator *(ref const(QPainterPath) p, ref const(QMatrix) m);+/

pragma(inline, true) bool qFuzzyCompare(ref const(QMatrix) m1, ref const(QMatrix) m2)
{
    return qt.core.global.qFuzzyCompare(m1.m11(), m2.m11())
        && qt.core.global.qFuzzyCompare(m1.m12(), m2.m12())
        && qt.core.global.qFuzzyCompare(m1.m21(), m2.m21())
        && qt.core.global.qFuzzyCompare(m1.m22(), m2.m22())
        && qt.core.global.qFuzzyCompare(m1.dx(), m2.dx())
        && qt.core.global.qFuzzyCompare(m1.dy(), m2.dy());
}


/*****************************************************************************
 QMatrix stream functions
 *****************************************************************************/

/+ #ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QMatrix &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QMatrix &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QMatrix &);
#endif +/

