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
import qt.core.namespace;
import qt.core.typeinfo;
import qt.helpers;

/+ #if defined(Q_OS_DARWIN) || defined(Q_QDOC)
struct CGSize;
#endif +/



/// Binding for C++ class [QSize](https://doc.qt.io/qt-6/qsize.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QSize
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
    { return wd == 0 && ht == 0; }
    pragma(inline, true) bool isEmpty() const/+ noexcept+/
    { return wd < 1 || ht < 1; }
    pragma(inline, true) bool isValid() const/+ noexcept+/
    { return wd >= 0 && ht >= 0; }

    pragma(inline, true) int width() const/+ noexcept+/
    { return wd; }
    pragma(inline, true) int height() const/+ noexcept+/
    { return ht; }
    pragma(inline, true) void setWidth(int w)/+ noexcept+/
    { wd = w; }
    pragma(inline, true) void setHeight(int h)/+ noexcept+/
    { ht = h; }
    void transpose()/+ noexcept+/;
    /+ [[nodiscard]] +/ pragma(inline, true) QSize transposed() const/+ noexcept+/
    { return QSize(ht, wd); }

    pragma(inline, true) void scale(int w, int h, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode)/+ noexcept+/
    { auto tmp = QSize(w, h); scale(tmp, mode); }
    pragma(inline, true) void scale(ref const(QSize) s, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode)/+ noexcept+/
    { this = scaled(s, mode); }
    /+ [[nodiscard]] +/ pragma(inline, true) QSize scaled(int w, int h, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode) const/+ noexcept+/
    { auto tmp = QSize(w, h); return scaled(tmp, mode); }
    /+ [[nodiscard]] +/ QSize scaled(ref const(QSize) s, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode) const/+ noexcept+/;

    /+ [[nodiscard]] +/ pragma(inline, true) QSize expandedTo(ref const(QSize) otherSize) const/+ noexcept+/
    {
        return QSize(qMax(wd,otherSize.wd), qMax(ht,otherSize.ht));
    }
    /+ [[nodiscard]] +/ pragma(inline, true) QSize boundedTo(ref const(QSize) otherSize) const/+ noexcept+/
    {
        return QSize(qMin(wd,otherSize.wd), qMin(ht,otherSize.ht));
    }

    /+ [[nodiscard]] +/ QSize grownBy(QMargins m) const/+ noexcept+/
    { return QSize(width() + m.left() + m.right(), height() + m.top() + m.bottom()); }
    /+ [[nodiscard]] +/ QSize shrunkBy(QMargins m) const/+ noexcept+/
    { return QSize(width() - m.left() - m.right(), height() - m.top() - m.bottom()); }

    pragma(inline, true) ref int rwidth()/+ noexcept+/ return
    { return wd; }
    pragma(inline, true) ref int rheight()/+ noexcept+/ return
    { return ht; }

    pragma(inline, true) ref QSize opOpAssign(string op)(ref const(QSize) s)/+ noexcept+/ if (op == "+")
    {
        wd += s.wd;
        ht += s.ht;
        return this;
    }
    pragma(inline, true) ref QSize opOpAssign(string op)(ref const(QSize) s)/+ noexcept+/ if (op == "-")
    {
        wd -= s.wd;
        ht -= s.ht;
        return this;
    }
    /+pragma(inline, true) ref QSize operator *=(qreal c)/+ noexcept+/
    {
        wd = qRound(wd * c);
        ht = qRound(ht * c);
        return this;
    }+/
    /+pragma(inline, true) ref QSize operator /=(qreal c)
    {
        (mixin(Q_ASSERT(q{!qFuzzyIsNull(c)})));
        wd = qRound(wd / c);
        ht = qRound(ht / c);
        return this;
    }+/

    /+ friend inline constexpr bool operator==(const QSize &s1, const QSize &s2) noexcept
    { return s1.wd == s2.wd && s1.ht == s2.ht; } +/
    /+ friend inline constexpr bool operator!=(const QSize &s1, const QSize &s2) noexcept
    { return s1.wd != s2.wd || s1.ht != s2.ht; } +/
    /+ friend inline constexpr QSize operator+(const QSize &s1, const QSize &s2) noexcept
    { return QSize(s1.wd + s2.wd, s1.ht + s2.ht); } +/
    /+ friend inline constexpr QSize operator-(const QSize &s1, const QSize &s2) noexcept
    { return QSize(s1.wd - s2.wd, s1.ht - s2.ht); } +/
    /+ friend inline constexpr QSize operator*(const QSize &s, qreal c) noexcept
    { return QSize(qRound(s.wd * c), qRound(s.ht * c)); } +/
    /+ friend inline constexpr QSize operator*(qreal c, const QSize &s) noexcept
    { return s * c; } +/
    /+ friend inline QSize operator/(const QSize &s, qreal c)
    { Q_ASSERT(!qFuzzyIsNull(c)); return QSize(qRound(s.wd / c), qRound(s.ht / c)); } +/
    /+ friend inline constexpr size_t qHash(const QSize &, size_t) noexcept; +/

    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ [[nodiscard]] CGSize toCGSize() const noexcept; +/
    }

    /+ [[nodiscard]] +/ pragma(inline, true) QSizeF toSizeF() const/+ noexcept+/ { return QSizeF(this); }

private:
    int wd = -1;
    int ht = -1;

    /+ template <std::size_t I,
              typename S,
              std::enable_if_t<(I < 2), bool> = true,
              std::enable_if_t<std::is_same_v<std::decay_t<S>, QSize>, bool> = true> +/
    /+ friend constexpr decltype(auto) get(S &&s) noexcept
    {
        static if (I == 0)
            return (std::forward<S>(s).wd);
        else static if (I == 1)
            return (std::forward<S>(s).ht);
    } +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QSize, Q_RELOCATABLE_TYPE);

/*****************************************************************************
  QSize stream functions
 *****************************************************************************/

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QSize &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QSize &);
#endif


/*****************************************************************************
  QSize inline functions
 *****************************************************************************/

constexpr inline size_t qHash(const QSize &s, size_t seed = 0) noexcept
{ return qHashMulti(seed, s.wd, s.ht); }

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QSize &);
#endif +/


/// Binding for C++ class [QSizeF](https://doc.qt.io/qt-6/qsizef.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QSizeF
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
    /+ [[nodiscard]] +/ pragma(inline, true) QSizeF transposed() const/+ noexcept+/
    { return QSizeF(ht, wd); }

    pragma(inline, true) void scale(qreal w, qreal h, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode)/+ noexcept+/
    { auto tmp = QSizeF(w, h); scale(tmp, mode); }
    pragma(inline, true) void scale(ref const(QSizeF) s, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode)/+ noexcept+/
    { this = scaled(s, mode); }
    /+ [[nodiscard]] +/ pragma(inline, true) QSizeF scaled(qreal w, qreal h, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode) const/+ noexcept+/
    { auto tmp = QSizeF(w, h); return scaled(tmp, mode); }
    /+ [[nodiscard]] +/ QSizeF scaled(ref const(QSizeF) s, /+ Qt:: +/qt.core.namespace.AspectRatioMode mode) const/+ noexcept+/;

    /+ [[nodiscard]] +/ pragma(inline, true) QSizeF expandedTo(ref const(QSizeF) otherSize) const/+ noexcept+/
    {
        return QSizeF(qMax(wd, otherSize.wd), qMax(ht, otherSize.ht));
    }
    /+ [[nodiscard]] +/ pragma(inline, true) QSizeF boundedTo(ref const(QSizeF) otherSize) const/+ noexcept+/
    {
        return QSizeF(qMin(wd, otherSize.wd), qMin(ht, otherSize.ht));
    }

    /+ [[nodiscard]] +/ QSizeF grownBy(QMarginsF m) const/+ noexcept+/
    { return QSizeF(width() + m.left() + m.right(), height() + m.top() + m.bottom()); }
    /+ [[nodiscard]] +/ QSizeF shrunkBy(QMarginsF m) const/+ noexcept+/
    { return QSizeF(width() - m.left() - m.right(), height() - m.top() - m.bottom()); }

    pragma(inline, true) ref qreal rwidth()/+ noexcept+/ return
    { return wd; }
    pragma(inline, true) ref qreal rheight()/+ noexcept+/ return
    { return ht; }

    pragma(inline, true) ref QSizeF opOpAssign(string op)(ref const(QSizeF) s)/+ noexcept+/ if (op == "+")
    {
        wd += s.wd;
        ht += s.ht;
        return this;
    }
    pragma(inline, true) ref QSizeF opOpAssign(string op)(ref const(QSizeF) s)/+ noexcept+/ if (op == "-")
    {
        wd -= s.wd;
        ht -= s.ht;
        return this;
    }
    /+pragma(inline, true) ref QSizeF operator *=(qreal c)/+ noexcept+/
    {
        wd *= c;
        ht *= c;
        return this;
    }+/
    /+pragma(inline, true) ref QSizeF operator /=(qreal c)
    {
        import qt.core.numeric;

        (mixin(Q_ASSERT(q{!qFuzzyIsNull(c) && qIsFinite(c)})));
        wd = wd / c;
        ht = ht / c;
        return this;
    }+/

    /+ QT_WARNING_PUSH
    QT_WARNING_DISABLE_FLOAT_COMPARE +/
    /+ friend constexpr inline bool operator==(const QSizeF &s1, const QSizeF &s2)
    {
        return ((!s1.wd || !s2.wd) ? qFuzzyIsNull(s1.wd - s2.wd) : qFuzzyCompare(s1.wd, s2.wd))
            && ((!s1.ht || !s2.ht) ? qFuzzyIsNull(s1.ht - s2.ht) : qFuzzyCompare(s1.ht, s2.ht));
    } +/
    /+ QT_WARNING_POP +/
    /+ friend constexpr inline bool operator!=(const QSizeF &s1, const QSizeF &s2)
    { return !(s1 == s2); } +/
    /+ friend constexpr inline QSizeF operator+(const QSizeF &s1, const QSizeF &s2) noexcept
    { return QSizeF(s1.wd + s2.wd, s1.ht + s2.ht); } +/
    /+ friend constexpr inline QSizeF operator-(const QSizeF &s1, const QSizeF &s2) noexcept
    { return QSizeF(s1.wd - s2.wd, s1.ht - s2.ht); } +/
    /+ friend constexpr inline QSizeF operator*(const QSizeF &s, qreal c) noexcept
    { return QSizeF(s.wd * c, s.ht * c); } +/
    /+ friend constexpr inline QSizeF operator*(qreal c, const QSizeF &s) noexcept
    { return s * c; } +/
    /+ friend inline QSizeF operator/(const QSizeF &s, qreal c)
    { Q_ASSERT(!qFuzzyIsNull(c)); return QSizeF(s.wd / c, s.ht / c); } +/

    pragma(inline, true) QSize toSize() const/+ noexcept+/
    {
        return QSize(qRound(wd), qRound(ht));
    }

    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ [[nodiscard]] static QSizeF fromCGSize(CGSize size) noexcept; +/
        /+ [[nodiscard]] CGSize toCGSize() const noexcept; +/
    }

private:
    qreal wd = -1.;
    qreal ht = -1.;

    /+ template <std::size_t I,
              typename S,
              std::enable_if_t<(I < 2), bool> = true,
              std::enable_if_t<std::is_same_v<std::decay_t<S>, QSizeF>, bool> = true> +/
    /+ friend constexpr decltype(auto) get(S &&s) noexcept
    {
        static if (I == 0)
            return (std::forward<S>(s).wd);
        else static if (I == 1)
            return (std::forward<S>(s).ht);
    } +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QSizeF, Q_RELOCATABLE_TYPE);


/*****************************************************************************
  QSizeF stream functions
 *****************************************************************************/

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QSizeF &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QSizeF &);
#endif


/*****************************************************************************
  QSizeF inline functions
 *****************************************************************************/

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QSizeF &);
#endif


/*****************************************************************************
  QSize/QSizeF tuple protocol
 *****************************************************************************/

namespace std {
    template <>
    class tuple_size<QT_PREPEND_NAMESPACE(QSize)> : public integral_constant<size_t, 2> {};
    template <>
    class tuple_element<0, QT_PREPEND_NAMESPACE(QSize)> { public: using type = int; };
    template <>
    class tuple_element<1, QT_PREPEND_NAMESPACE(QSize)> { public: using type = int; };

    template <>
    class tuple_size<QT_PREPEND_NAMESPACE(QSizeF)> : public integral_constant<size_t, 2> {};
    template <>
    class tuple_element<0, QT_PREPEND_NAMESPACE(QSizeF)> { public: using type = QT_PREPEND_NAMESPACE(qreal); };
    template <>
    class tuple_element<1, QT_PREPEND_NAMESPACE(QSizeF)> { public: using type = QT_PREPEND_NAMESPACE(qreal); };
} +/

