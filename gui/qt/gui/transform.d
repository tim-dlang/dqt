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
import qt.gui.matrix;
import qt.gui.painterpath;
import qt.gui.polygon;
import qt.gui.region;
import qt.helpers;


/// Binding for C++ class [QTransform](https://doc.qt.io/qt-5/qtransform.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTransform
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

    /+ explicit +/pragma(inline, true) this(/+ Qt:: +/qt.core.namespace.Initialization)
    {
        this.affine = /+ Qt:: +/qt.core.namespace.Initialization.Uninitialized;
    }
    /+this();+/

    this(qreal h11, qreal h12, qreal h13,
                   qreal h21, qreal h22, qreal h23,
                   qreal h31, qreal h32, qreal h33 = 1.0);
    this(qreal h11, qreal h12, qreal h21,
                   qreal h22, qreal dx, qreal dy);
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+ explicit +/this(ref const(QMatrix) mtx);
/+ #endif // QT_DEPRECATED_SINCE(5, 15)

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    // ### Qt 6: remove; the compiler-generated ones are fine!
    /+ QTransform &operator=(QTransform &&other) noexcept // = default
    { memcpy(static_cast<void *>(this), static_cast<void *>(&other), sizeof(QTransform)); return *this; } +/
    /+ref QTransform operator =(ref const(QTransform) )/+ noexcept+/;+/ // = default
    /+ QTransform(QTransform &&other) noexcept // = default
        : affine(Qt::Uninitialized)
    { memcpy(static_cast<void *>(this), static_cast<void *>(&other), sizeof(QTransform)); } +/
    @disable this(this);
    this(ref const(QTransform) other)/+ noexcept+/// = default
{
    import core.stdc.string;
    this.affine = /+ Qt:: +/qt.core.namespace.Initialization.Uninitialized;
    memcpy(static_cast!(void*)(&this), static_cast!(const(void)*)(&other), QTransform.sizeof);
}
/+ #endif +/

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
        return affine._m11*(m_33*affine._m22-affine._dy*m_23) -
            affine._m21*(m_33*affine._m12-affine._dy*m_13)+affine._dx*(m_23*affine._m12-affine._m22*m_13);
    }
/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use determinant() instead") +/
        pragma(inline, true) qreal det() const
    {
        return determinant();
    }
/+ #endif +/

    pragma(inline, true) qreal m11() const
    {
        return affine._m11;
    }
    pragma(inline, true) qreal m12() const
    {
        return affine._m12;
    }
    pragma(inline, true) qreal m13() const
    {
        return m_13;
    }
    pragma(inline, true) qreal m21() const
    {
        return affine._m21;
    }
    pragma(inline, true) qreal m22() const
    {
        return affine._m22;
    }
    pragma(inline, true) qreal m23() const
    {
        return m_23;
    }
    pragma(inline, true) qreal m31() const
    {
        return affine._dx;
    }
    pragma(inline, true) qreal m32() const
    {
        return affine._dy;
    }
    pragma(inline, true) qreal m33() const
    {
        return m_33;
    }
    pragma(inline, true) qreal dx() const
    {
        return affine._dx;
    }
    pragma(inline, true) qreal dy() const
    {
        return affine._dy;
    }

    void setMatrix(qreal m11, qreal m12, qreal m13,
                       qreal m21, qreal m22, qreal m23,
                       qreal m31, qreal m32, qreal m33);

    /+ Q_REQUIRED_RESULT +/ QTransform inverted(bool* invertible = null) const;
    /+ Q_REQUIRED_RESULT +/ QTransform adjoint() const;
    /+ Q_REQUIRED_RESULT +/ QTransform transposed() const;

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

/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    ref const(QMatrix) toAffine() const;
/+ #endif +/ // QT_DEPRECATED_SINCE(5, 15)

    /+pragma(inline, true) ref QTransform operator *=(qreal num)
    {
        if (num == 1.)
            return this;
        affine._m11 *= num;
        affine._m12 *= num;
        m_13        *= num;
        affine._m21 *= num;
        affine._m22 *= num;
        m_23        *= num;
        affine._dx  *= num;
        affine._dy  *= num;
        m_33        *= num;
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
    pragma(inline, true) ref QTransform opOpAssign(string op)(qreal num) if (op == "+")
    {
        if (num == 0)
            return this;
        affine._m11 += num;
        affine._m12 += num;
        m_13        += num;
        affine._m21 += num;
        affine._m22 += num;
        m_23        += num;
        affine._dx  += num;
        affine._dy  += num;
        m_33        += num;
        m_dirty     = TransformationType.TxProject;
        return this;
    }
    pragma(inline, true) ref QTransform opOpAssign(string op)(qreal num) if (op == "-")
    {
        if (num == 0)
            return this;
        affine._m11 -= num;
        affine._m12 -= num;
        m_13        -= num;
        affine._m21 -= num;
        affine._m22 -= num;
        m_23        -= num;
        affine._dx  -= num;
        affine._dy  -= num;
        m_33        -= num;
        m_dirty     = TransformationType.TxProject;
        return this;
    }

    static QTransform fromTranslate(qreal dx, qreal dy);
    static QTransform fromScale(qreal dx, qreal dy);

private:
    pragma(inline, true) this(qreal h11, qreal h12, qreal h13,
                          qreal h21, qreal h22, qreal h23,
                          qreal h31, qreal h32, qreal h33, bool)
    {
        this.affine = QMatrix(h11, h12, h21, h22, h31, h32, true);
        this.m_13 = h13; this.m_23 = h23; this.m_33 = h33;
        this.m_type = TransformationType.TxNone;
        this.m_dirty = TransformationType.TxProject;
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
        this.d = null;
/+ #endif +/
    }
    pragma(inline, true) this(bool)
    {
        this.affine = true;
        this.m_13 = 0;
        this.m_23 = 0;
        this.m_33 = 1;
        this.m_type = TransformationType.TxNone;
        this.m_dirty = TransformationType.TxNone;
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
        this.d = null;
/+ #endif +/
}
    /******* inlines *****/
    pragma(inline, true) TransformationType inline_type() const
    {
        if (m_dirty == TransformationType.TxNone)
            return static_cast!(TransformationType)(m_type);
        return type();
    }
    QMatrix affine;
    qreal   m_13 = 0;
    qreal   m_23 = 0;
    qreal   m_33 = 1;

    /+ mutable uint m_type : 5; +/
    ushort bitfieldData_m_type;
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
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    extern(C++, class) struct Private;
    Private* d;
/+ #endif +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QTransform, Q_MOVABLE_TYPE);

Q_GUI_EXPORT Q_DECL_CONST_FUNCTION uint qHash(const QTransform &key, uint seed = 0) noexcept;
#if QT_DEPRECATED_SINCE(5, 13)
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_CLANG("-Wfloat-equal")
QT_WARNING_DISABLE_GCC("-Wfloat-equal")
QT_WARNING_DISABLE_INTEL(1572)

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

