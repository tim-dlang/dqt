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
module qt.gui.transform;
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


/// Binding for C++ class [QTransform](https://doc.qt.io/qt-6/qtransform.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTransform
{
public:
    enum TransformationType {
        TxNone      = 0x00,
        TxTranslate = 0x01,
        TxScale     = 0x02,
        TxRotate    = 0x04,
        TxShear     = 0x08,
        TxProject   = 0x10
    }

    /+ explicit +/pragma(inline, true) this(/+ Qt:: +/qt.core.namespace.Initialization) {}
    /+pragma(inline, true) this()
    {
        this.m_matrix = [ {1, 0, 0}, {0, 1, 0}, {0, 0, 1}] ;
        this.m_type = TransformationType.TxNone;
        this.m_dirty = TransformationType.TxNone;
    }+/
    this(qreal h11, qreal h12, qreal h13,
                   qreal h21, qreal h22, qreal h23,
                   qreal h31, qreal h32, qreal h33)
    {
        this.m_matrix = [ [h11, h12, h13], [h21, h22, h23], [h31, h32, h33]] ;
        this.m_type = TransformationType.TxNone;
        this.m_dirty = TransformationType.TxProject;
    }
    this(qreal h11, qreal h12, qreal h21,
                   qreal h22, qreal dx, qreal dy)
    {
        this.m_matrix = [ [h11, h12, 0], [h21, h22, 0], [dx, dy, 1]] ;
        this.m_type = TransformationType.TxNone;
        this.m_dirty = TransformationType.TxShear;
    }

    /+ QTransform &operator=(QTransform &&other) noexcept = default; +/
    /+ QTransform &operator=(const QTransform &) noexcept = default; +/
    /+ QTransform(QTransform &&other) noexcept = default; +/
    /+ QTransform(const QTransform &other) noexcept = default; +/

    pragma(inline, true) bool isAffine() const
    {
        return inline_type() < TransformationType.TxProject;
    }
    pragma(inline, true) bool isIdentity() const
    {
        return inline_type() == TransformationType.TxNone;
    }
    pragma(inline, true) bool isInvertible() const
    {
        return !qFuzzyIsNull(determinant());
    }
    pragma(inline, true) bool isScaling() const
    {
        return type() >= TransformationType.TxScale;
    }
    pragma(inline, true) bool isRotating() const
    {
        return inline_type() >= TransformationType.TxRotate;
    }
    pragma(inline, true) bool isTranslating() const
    {
        return inline_type() >= TransformationType.TxTranslate;
    }

    TransformationType type() const;

    pragma(inline, true) qreal determinant() const
    {
        return m_matrix[0][0] * (m_matrix[2][2] * m_matrix[1][1] - m_matrix[2][1] * m_matrix[1][2]) -
               m_matrix[1][0] * (m_matrix[2][2] * m_matrix[0][1] - m_matrix[2][1] * m_matrix[0][2]) +
               m_matrix[2][0] * (m_matrix[1][2] * m_matrix[0][1] - m_matrix[1][1] * m_matrix[0][2]);
    }

    pragma(inline, true) qreal m11() const
    {
        return m_matrix[0][0];
    }
    pragma(inline, true) qreal m12() const
    {
        return m_matrix[0][1];
    }
    pragma(inline, true) qreal m13() const
    {
        return m_matrix[0][2];
    }
    pragma(inline, true) qreal m21() const
    {
        return m_matrix[1][0];
    }
    pragma(inline, true) qreal m22() const
    {
        return m_matrix[1][1];
    }
    pragma(inline, true) qreal m23() const
    {
        return m_matrix[1][2];
    }
    pragma(inline, true) qreal m31() const
    {
        return m_matrix[2][0];
    }
    pragma(inline, true) qreal m32() const
    {
        return m_matrix[2][1];
    }
    pragma(inline, true) qreal m33() const
    {
        return m_matrix[2][2];
    }
    pragma(inline, true) qreal dx() const
    {
        return m_matrix[2][0];
    }
    pragma(inline, true) qreal dy() const
    {
        return m_matrix[2][1];
    }

    void setMatrix(qreal m11, qreal m12, qreal m13,
                       qreal m21, qreal m22, qreal m23,
                       qreal m31, qreal m32, qreal m33);

    /+ [[nodiscard]] +/ QTransform inverted(bool* invertible = null) const;
    /+ [[nodiscard]] +/ QTransform adjoint() const;
    /+ [[nodiscard]] +/ QTransform transposed() const;

    ref QTransform translate(qreal dx, qreal dy);
    ref QTransform scale(qreal sx, qreal sy);
    ref QTransform shear(qreal sh, qreal sv);
    ref QTransform rotate(qreal a, /+ Qt:: +/qt.core.namespace.Axis axis = /+ Qt:: +/qt.core.namespace.Axis.ZAxis);
    ref QTransform rotateRadians(qreal a, /+ Qt:: +/qt.core.namespace.Axis axis = /+ Qt:: +/qt.core.namespace.Axis.ZAxis);

    static bool squareToQuad(ref const(QPolygonF) square, ref QTransform result);
    static bool quadToSquare(ref const(QPolygonF) quad, ref QTransform result);
    static bool quadToQuad(ref const(QPolygonF) one,
                               ref const(QPolygonF) two,
                               ref QTransform result);

    /+bool operator ==(ref const(QTransform) ) const;+/
    /+bool operator !=(ref const(QTransform) ) const;+/

    /+ref QTransform operator *=(ref const(QTransform) );+/
    /+QTransform operator *(ref const(QTransform) o) const;+/

    /+auto opCast(T : QVariant)() const;+/

    void reset();
    QPoint       map(ref const(QPoint) p) const;
    QPointF      map(ref const(QPointF) p) const;
    QLine        map(ref const(QLine) l) const;
    QLineF       map(ref const(QLineF) l) const;
    QPolygonF    map(ref const(QPolygonF) a) const;
    QPolygon     map(ref const(QPolygon) a) const;
    QRegion      map(ref const(QRegion) r) const;
    QPainterPath map(ref const(QPainterPath) p) const;
    QPolygon     mapToPolygon(ref const(QRect) r) const;
    QRect mapRect(ref const(QRect) ) const;
    QRectF mapRect(ref const(QRectF) ) const;
    void map(int x, int y, int* tx, int* ty) const;
    void map(qreal x, qreal y, qreal* tx, qreal* ty) const;

    /+pragma(inline, true) ref QTransform operator *=(qreal num)
    {
        if (num == 1.)
            return this;
        m_matrix[0][0] *= num;
        m_matrix[0][1] *= num;
        m_matrix[0][2] *= num;
        m_matrix[1][0] *= num;
        m_matrix[1][1] *= num;
        m_matrix[1][2] *= num;
        m_matrix[2][0] *= num;
        m_matrix[2][1] *= num;
        m_matrix[2][2] *= num;
        if (m_dirty < TransformationType.TxScale)
            m_dirty = TransformationType.TxScale;
        return this;
    }+/
    /+pragma(inline, true) ref QTransform operator /=(qreal div)
    {
        if (div == 0)
            return this;
        div = 1/div;
        return operator*=(div);
    }+/
    pragma(inline, true) ref QTransform opOpAssign(string op)(qreal num) if(op == "+")
    {
        if (num == 0)
            return this;
        m_matrix[0][0] += num;
        m_matrix[0][1] += num;
        m_matrix[0][2] += num;
        m_matrix[1][0] += num;
        m_matrix[1][1] += num;
        m_matrix[1][2] += num;
        m_matrix[2][0] += num;
        m_matrix[2][1] += num;
        m_matrix[2][2] += num;
        m_dirty     = TransformationType.TxProject;
        return this;
    }
    pragma(inline, true) ref QTransform opOpAssign(string op)(qreal num) if(op == "-")
    {
        if (num == 0)
            return this;
        m_matrix[0][0] -= num;
        m_matrix[0][1] -= num;
        m_matrix[0][2] -= num;
        m_matrix[1][0] -= num;
        m_matrix[1][1] -= num;
        m_matrix[1][2] -= num;
        m_matrix[2][0] -= num;
        m_matrix[2][1] -= num;
        m_matrix[2][2] -= num;
        m_dirty     = TransformationType.TxProject;
        return this;
    }

    static QTransform fromTranslate(qreal dx, qreal dy);
    static QTransform fromScale(qreal dx, qreal dy);

private:
    /+ struct Affine {
             ref qreal[3][3]  m_matrix;
        } +/

public:
    //auto asAffineMatrix() { return Affine (m_matrix) ; }
    /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &s, Affine &m); +/
    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &s, const Affine &m); +/

private:
    /******* inlines *****/
    pragma(inline, true) TransformationType inline_type() const
    {
        if (m_dirty == TransformationType.TxNone)
            return static_cast!(TransformationType)(m_type);
        return type();
    }
    qreal[3][3] m_matrix = [[1, 0, 0], [0, 1, 0], [0, 0, 1]];

    /+ mutable uint m_type : 5; +/
    ushort bitfieldData_m_type = TransformationType.TxNone | (TransformationType.TxNone << 5);
    final uint m_type() const
    {
        return (bitfieldData_m_type >> 0) & 0x1f;
    }
    final uint m_type(uint value)
    {
        bitfieldData_m_type = (bitfieldData_m_type & ~0x1f) | ((value & 0x1f) << 0);
        return value;
    }
    /+ mutable uint m_dirty : 5; +/
    final uint m_dirty() const
    {
        return (bitfieldData_m_type >> 5) & 0x1f;
    }
    final uint m_dirty(uint value)
    {
        bitfieldData_m_type = (bitfieldData_m_type & ~0x3e0) | ((value & 0x1f) << 5);
        return value;
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QTransform, Q_RELOCATABLE_TYPE);

Q_GUI_EXPORT Q_DECL_CONST_FUNCTION size_t qHash(const QTransform &key, size_t seed = 0) noexcept;

QT_WARNING_PUSH
QT_WARNING_DISABLE_FLOAT_COMPARE

QT_WARNING_POP +/

pragma(inline, true) bool qFuzzyCompare(ref const(QTransform) t1, ref const(QTransform) t2)
{
    return qt.core.global.qFuzzyCompare(t1.m11(), t2.m11())
        && qt.core.global.qFuzzyCompare(t1.m12(), t2.m12())
        && qt.core.global.qFuzzyCompare(t1.m13(), t2.m13())
        && qt.core.global.qFuzzyCompare(t1.m21(), t2.m21())
        && qt.core.global.qFuzzyCompare(t1.m22(), t2.m22())
        && qt.core.global.qFuzzyCompare(t1.m23(), t2.m23())
        && qt.core.global.qFuzzyCompare(t1.m31(), t2.m31())
        && qt.core.global.qFuzzyCompare(t1.m32(), t2.m32())
        && qt.core.global.qFuzzyCompare(t1.m33(), t2.m33());
}


/****** stream functions *******************/
/+ #ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QTransform &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QTransform &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QTransform &);
#endif +/
/****** end stream functions *******************/

// mathematical semantics
/+pragma(inline, true) QPoint operator *(ref const(QPoint) p, ref const(QTransform) m)
{ return m.map(p); }+/
/+pragma(inline, true) QPointF operator *(ref const(QPointF) p, ref const(QTransform) m)
{ return m.map(p); }+/
/+pragma(inline, true) QLineF operator *(ref const(QLineF) l, ref const(QTransform) m)
{ return m.map(l); }+/
/+pragma(inline, true) QLine operator *(ref const(QLine) l, ref const(QTransform) m)
{ return m.map(l); }+/
/+pragma(inline, true) QPolygon operator *(ref const(QPolygon) a, ref const(QTransform) m)
{ return m.map(a); }+/
/+pragma(inline, true) QPolygonF operator *(ref const(QPolygonF) a, ref const(QTransform) m)
{ return m.map(a); }+/
/+pragma(inline, true) QRegion operator *(ref const(QRegion) r, ref const(QTransform) m)
{ return m.map(r); }+/

/+pragma(inline, true) QTransform operator *(ref const(QTransform) a, qreal n)
{ auto t = QTransform(a); t *= n; return t; }+/
/+pragma(inline, true) QTransform operator /(ref const(QTransform) a, qreal n)
{ auto t = QTransform(a); t /= n; return t; }+/
/+pragma(inline, true) QTransform operator +(ref const(QTransform) a, qreal n)
{ auto t = QTransform(a); t += n; return t; }+/
/+pragma(inline, true) QTransform operator -(ref const(QTransform) a, qreal n)
{ auto t = QTransform(a); t -= n; return t; }+/

