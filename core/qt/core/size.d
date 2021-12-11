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
module qt.core.size;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.margins;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.typeinfo;
import qt.helpers;

/+ #if defined(Q_OS_DARWIN) || defined(Q_QDOC)
struct CGSize;
#endif +/



/// Binding for C++ class [QSize](https://doc.qt.io/qt-5/qsize.html).
@(QMetaType.Type.QSize) @Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QSize
{
public:
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.wd = -1;
        this.ht = -1;
    }+/
    pragma(inline, true) this(int w, int h)/+ noexcept+/
    {
        this.wd = w;
        this.ht = h;
    }

    pragma(inline, true) bool isNull() const/+ noexcept+/
    { return wd==0 && ht==0; }
    pragma(inline, true) bool isEmpty() const/+ noexcept+/
    { return wd<1 || ht<1; }
    pragma(inline, true) bool isValid() const/+ noexcept+/
    { return wd>=0 && ht>=0; }

    pragma(inline, true) int width() const/+ noexcept+/
    { return wd; }
    pragma(inline, true) int height() const/+ noexcept+/
    { return ht; }
    pragma(inline, true) void setWidth(int w)/+ noexcept+/
    { wd = w; }
    pragma(inline, true) void setHeight(int h)/+ noexcept+/
    { ht = h; }
    void transpose()/+ noexcept+/;
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QSize transposed() const/+ noexcept+/
    { return QSize(ht, wd); }

    pragma(inline, true) void scale(int w, int h, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode)/+ noexcept+/
    { auto tmp = QSize(w, h); scale(tmp, mode); }
    pragma(inline, true) void scale(ref const(QSize) s, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode)/+ noexcept+/
    { this = scaled(s, mode); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QSize scaled(int w, int h, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode) const/+ noexcept+/
    { auto tmp = QSize(w, h); return scaled(tmp, mode); }
    /+ Q_REQUIRED_RESULT +/ QSize scaled(ref const(QSize) s, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode) const/+ noexcept+/;

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QSize expandedTo(ref const(QSize) otherSize) const/+ noexcept+/
    {
        return QSize(qMax(wd,otherSize.wd), qMax(ht,otherSize.ht));
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QSize boundedTo(ref const(QSize) otherSize) const/+ noexcept+/
    {
        return QSize(qMin(wd,otherSize.wd), qMin(ht,otherSize.ht));
    }

    /+ Q_REQUIRED_RESULT +/ QSize grownBy(QMargins m) const/+ noexcept+/
    { return QSize(width() + m.left() + m.right(), height() + m.top() + m.bottom()); }
    /+ Q_REQUIRED_RESULT +/ QSize shrunkBy(QMargins m) const/+ noexcept+/
    { return QSize(width() - m.left() - m.right(), height() - m.top() - m.bottom()); }

    pragma(inline, true) ref int rwidth()/+ noexcept+/ return
    { return wd; }
    pragma(inline, true) ref int rheight()/+ noexcept+/ return
    { return ht; }

    pragma(inline, true) ref QSize opOpAssign(string op)(ref const(QSize) s)/+ noexcept+/ if(op == "+")
    { wd+=s.wd; ht+=s.ht; return this; }
    pragma(inline, true) ref QSize opOpAssign(string op)(ref const(QSize) s)/+ noexcept+/ if(op == "-")
    { wd-=s.wd; ht-=s.ht; return this; }
    /+pragma(inline, true) ref QSize operator *=(qreal c)/+ noexcept+/
    { wd = qRound(wd*c); ht = qRound(ht*c); return this; }+/
    /+pragma(inline, true) ref QSize operator /=(qreal c)
    {
        (mixin(Q_ASSERT(q{!qFuzzyIsNull(c)})));
        wd = qRound(wd/c); ht = qRound(ht/c);
        return this;
    }+/

    /+ friend inline bool operator==(const QSize &, const QSize &) noexcept; +/
    /+ friend inline bool operator!=(const QSize &, const QSize &) noexcept; +/
    /+ friend inline const QSize operator+(const QSize &, const QSize &) noexcept; +/
    /+ friend inline const QSize operator-(const QSize &, const QSize &) noexcept; +/
    /+ friend inline const QSize operator*(const QSize &, qreal) noexcept; +/
    /+ friend inline const QSize operator*(qreal, const QSize &) noexcept; +/
    /+ friend inline const QSize operator/(const QSize &, qreal); +/

    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ Q_REQUIRED_RESULT CGSize toCGSize() const noexcept; +/
    }

private:
    int wd = -1;
    int ht = -1;
}
/+ Q_DECLARE_TYPEINFO(QSize, Q_MOVABLE_TYPE);

/*****************************************************************************
  QSize stream functions
 *****************************************************************************/

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QSize &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QSize &);
#endif +/


/*****************************************************************************
  QSize inline functions
 *****************************************************************************/

/+pragma(inline, true) bool operator ==(ref const(QSize) s1, ref const(QSize) s2)/+ noexcept+/
{ return s1.wd == s2.wd && s1.ht == s2.ht; }+/

/+pragma(inline, true) bool operator !=(ref const(QSize) s1, ref const(QSize) s2)/+ noexcept+/
{ return s1.wd != s2.wd || s1.ht != s2.ht; }+/

/+pragma(inline, true) const(QSize) operator +(ref const(QSize)  s1, ref const(QSize)  s2)/+ noexcept+/
{ return QSize(s1.wd+s2.wd, s1.ht+s2.ht); }+/

/+pragma(inline, true) const(QSize) operator -(ref const(QSize) s1, ref const(QSize) s2)/+ noexcept+/
{ return QSize(s1.wd-s2.wd, s1.ht-s2.ht); }+/

/+pragma(inline, true) const(QSize) operator *(ref const(QSize) s, qreal c)/+ noexcept+/
{ return QSize(qRound(s.wd*c), qRound(s.ht*c)); }+/

/+pragma(inline, true) const(QSize) operator *(qreal c, ref const(QSize) s)/+ noexcept+/
{ return QSize(qRound(s.wd*c), qRound(s.ht*c)); }+/

/+pragma(inline, true) const(QSize) operator /(ref const(QSize) s, qreal c)
{
    (mixin(Q_ASSERT(q{!qFuzzyIsNull(c)})));
    return QSize(qRound(s.wd/c), qRound(s.ht/c));
}+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QSize &);
#endif +/


/// Binding for C++ class [QSizeF](https://doc.qt.io/qt-5/qsizef.html).
@(QMetaType.Type.QSizeF) @Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QSizeF
{
public:
    @disable this();
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.wd = -1.;
        this.ht = -1.;
    }+/
    pragma(inline, true) this(ref const(QSize) sz)/+ noexcept+/
    {
        this.wd = sz.width();
        this.ht = sz.height();
    }
    pragma(inline, true) this(qreal w, qreal h)/+ noexcept+/
    {
        this.wd = w;
        this.ht = h;
    }

    pragma(inline, true) bool isNull() const/+ noexcept+/
    { return qIsNull(wd) && qIsNull(ht); }
    pragma(inline, true) bool isEmpty() const/+ noexcept+/
    { return wd <= 0. || ht <= 0.; }
    pragma(inline, true) bool isValid() const/+ noexcept+/
    { return wd >= 0. && ht >= 0.; }

    pragma(inline, true) qreal width() const/+ noexcept+/
    { return wd; }
    pragma(inline, true) qreal height() const/+ noexcept+/
    { return ht; }
    pragma(inline, true) void setWidth(qreal w)/+ noexcept+/
    { wd = w; }
    pragma(inline, true) void setHeight(qreal h)/+ noexcept+/
    { ht = h; }
    void transpose()/+ noexcept+/;
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QSizeF transposed() const/+ noexcept+/
    { return QSizeF(ht, wd); }

    pragma(inline, true) void scale(qreal w, qreal h, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode)/+ noexcept+/
    { auto tmp = QSizeF(w, h); scale(tmp, mode); }
    pragma(inline, true) void scale(ref const(QSizeF) s, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode)/+ noexcept+/
    { this = scaled(s, mode); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QSizeF scaled(qreal w, qreal h, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode) const/+ noexcept+/
    { auto tmp = QSizeF(w, h); return scaled(tmp, mode); }
    /+ Q_REQUIRED_RESULT +/ QSizeF scaled(ref const(QSizeF) s, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode) const/+ noexcept+/;

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QSizeF expandedTo(ref const(QSizeF) otherSize) const/+ noexcept+/
    {
        return QSizeF(qMax(wd,otherSize.wd), qMax(ht,otherSize.ht));
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QSizeF boundedTo(ref const(QSizeF) otherSize) const/+ noexcept+/
    {
        return QSizeF(qMin(wd,otherSize.wd), qMin(ht,otherSize.ht));
    }

    /+ Q_REQUIRED_RESULT +/ QSizeF grownBy(QMarginsF m) const/+ noexcept+/
    { return QSizeF(width() + m.left() + m.right(), height() + m.top() + m.bottom()); }
    /+ Q_REQUIRED_RESULT +/ QSizeF shrunkBy(QMarginsF m) const/+ noexcept+/
    { return QSizeF(width() - m.left() - m.right(), height() - m.top() - m.bottom()); }

    pragma(inline, true) ref qreal rwidth()/+ noexcept+/ return
    { return wd; }
    pragma(inline, true) ref qreal rheight()/+ noexcept+/ return
    { return ht; }

    pragma(inline, true) ref QSizeF opOpAssign(string op)(ref const(QSizeF) s)/+ noexcept+/ if(op == "+")
    { wd += s.wd; ht += s.ht; return this; }
    pragma(inline, true) ref QSizeF opOpAssign(string op)(ref const(QSizeF) s)/+ noexcept+/ if(op == "-")
    { wd -= s.wd; ht -= s.ht; return this; }
    /+pragma(inline, true) ref QSizeF operator *=(qreal c)/+ noexcept+/
    { wd *= c; ht *= c; return this; }+/
    /+pragma(inline, true) ref QSizeF operator /=(qreal c)
    {
        (mixin(Q_ASSERT(q{!qFuzzyIsNull(c)})));
        wd = wd/c; ht = ht/c;
        return this;
    }+/

    /+ friend inline bool operator==(const QSizeF &, const QSizeF &) noexcept; +/
    /+ friend inline bool operator!=(const QSizeF &, const QSizeF &) noexcept; +/
    /+ friend inline const QSizeF operator+(const QSizeF &, const QSizeF &) noexcept; +/
    /+ friend inline const QSizeF operator-(const QSizeF &, const QSizeF &) noexcept; +/
    /+ friend inline const QSizeF operator*(const QSizeF &, qreal) noexcept; +/
    /+ friend inline const QSizeF operator*(qreal, const QSizeF &) noexcept; +/
    /+ friend inline const QSizeF operator/(const QSizeF &, qreal); +/

    pragma(inline, true) QSize toSize() const/+ noexcept+/
    {
        return QSize(qRound(wd), qRound(ht));
    }

    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ Q_REQUIRED_RESULT static QSizeF fromCGSize(CGSize size) noexcept; +/
        /+ Q_REQUIRED_RESULT CGSize toCGSize() const noexcept; +/
    }

private:
    qreal wd = -1.;
    qreal ht = -1.;
}
/+ Q_DECLARE_TYPEINFO(QSizeF, Q_MOVABLE_TYPE);


/*****************************************************************************
  QSizeF stream functions
 *****************************************************************************/

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QSizeF &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QSizeF &);
#endif +/


/*****************************************************************************
  QSizeF inline functions
 *****************************************************************************/

/+pragma(inline, true) bool operator ==(ref const(QSizeF) s1, ref const(QSizeF) s2)/+ noexcept+/
{ return qFuzzyCompare(s1.wd, s2.wd) && qFuzzyCompare(s1.ht, s2.ht); }+/

/+pragma(inline, true) bool operator !=(ref const(QSizeF) s1, ref const(QSizeF) s2)/+ noexcept+/
{ return !qFuzzyCompare(s1.wd, s2.wd) || !qFuzzyCompare(s1.ht, s2.ht); }+/

/+pragma(inline, true) const(QSizeF) operator +(ref const(QSizeF)  s1, ref const(QSizeF)  s2)/+ noexcept+/
{ return QSizeF(s1.wd+s2.wd, s1.ht+s2.ht); }+/

/+pragma(inline, true) const(QSizeF) operator -(ref const(QSizeF) s1, ref const(QSizeF) s2)/+ noexcept+/
{ return QSizeF(s1.wd-s2.wd, s1.ht-s2.ht); }+/

/+pragma(inline, true) const(QSizeF) operator *(ref const(QSizeF) s, qreal c)/+ noexcept+/
{ return QSizeF(s.wd*c, s.ht*c); }+/

/+pragma(inline, true) const(QSizeF) operator *(qreal c, ref const(QSizeF) s)/+ noexcept+/
{ return QSizeF(s.wd*c, s.ht*c); }+/

/+pragma(inline, true) const(QSizeF) operator /(ref const(QSizeF) s, qreal c)
{
    (mixin(Q_ASSERT(q{!qFuzzyIsNull(c)})));
    return QSizeF(s.wd/c, s.ht/c);
}+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QSizeF &);
#endif +/

