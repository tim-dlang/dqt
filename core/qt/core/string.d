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
module qt.core.string;
extern(C++):

import core.stdc.config;
import core.stdc.stddef;
import core.vararg;
import qt.config;
import qt.core.arraydata;
import qt.core.bytearray;
import qt.core.bytearrayview;
import qt.core.flags;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.qchar;
import qt.core.regularexpression;
import qt.core.stringlist;
import qt.core.stringliteral;
import qt.core.stringview;
import qt.core.typeinfo;
import qt.helpers;

/+ #if defined(QT_NO_CAST_FROM_ASCII) && defined(QT_RESTRICTED_CAST_FROM_ASCII)
#error QT_NO_CAST_FROM_ASCII and QT_RESTRICTED_CAST_FROM_ASCII must not be defined at the same time
#endif

#ifdef truncate
#error qstring.h must be included before any header file that defines truncate
#endif

#if defined(Q_OS_DARWIN) || defined(Q_QDOC)
Q_FORWARD_DECLARE_CF_TYPE(CFString);
Q_FORWARD_DECLARE_OBJC_CLASS(NSString);
#endif

#if 0
// Workaround for generating forward headers
#pragma qt_class(QLatin1String)
#pragma qt_class(QLatin1StringView)
#endif



namespace QtPrivate {
template <bool...B> class BoolList;
}

#if QT_VERSION >= QT_VERSION_CHECK(7, 0, 0) || defined(QT_BOOTSTRAPPED) || defined(Q_CLANG_QDOC) +/
static if (false)
{
/+ #    define Q_L1S_VIEW_IS_PRIMARY
class QLatin1StringView +/
}
/+ #else +/
/// Binding for C++ class [QLatin1String](https://doc.qt.io/qt-6/qlatin1string.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct QLatin1String
/+ #endif +/
{
public:
/+ #ifdef Q_L1S_VIEW_IS_PRIMARY
    constexpr inline QLatin1StringView() noexcept : m_size(0), m_data(nullptr) {}
    constexpr QLatin1StringView(std::nullptr_t) noexcept : QLatin1StringView() {}
    constexpr inline explicit QLatin1StringView(const char *s) noexcept
        : m_size(s ? qsizetype(QtPrivate::lengthHelperPointer(s)) : 0), m_data(s) {}
    constexpr QLatin1StringView(const char *f, const char *l)
        : QLatin1StringView(f, qsizetype(l - f)) {}
    constexpr inline QLatin1StringView(const char *s, qsizetype sz) noexcept : m_size(sz), m_data(s) {}
    explicit QLatin1StringView(const QByteArray &s) noexcept : m_size(s.size()), m_data(s.constData()) {}
    constexpr explicit QLatin1StringView(QByteArrayView s) noexcept : m_size(s.size()), m_data(s.data()) {}
#else +/
    @disable this();
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.m_size = 0;
        this.m_data = null;
    }+/
    /+ Q_WEAK_OVERLOAD +/
    this(/+ std:: +/nullptr_t)/+ noexcept+/
    {
        //this();
    }
    /+ explicit +/pragma(inline, true) this(const(char)* s)/+ noexcept+/
    {
        import core.stdc.string;
        this.m_size = s ? qsizetype(strlen(s)) : 0;
        this.m_data = s;
    }
    this(const(char)* f, const(char)* l)
    {
        this(f, qsizetype(l - f));
    }
    pragma(inline, true) this(const(char)* s, qsizetype sz)/+ noexcept+/
    {
        this.m_size = sz;
        this.m_data = s;
    }
    /+ explicit +/this(ref const(QByteArray) s)/+ noexcept+/
    {
        this.m_size = s.size();
        this.m_data = s.constData();
    }
    /+ explicit +/this(QByteArrayView s)/+ noexcept+/
    {
        this.m_size = s.size();
        this.m_data = s.data();
    }
/+ #endif +/ // !Q_L1S_VIEW_IS_PRIMARY

    pragma(inline, true) QString toString() const { return QString(this); }

    const(char)* latin1() const/+ noexcept+/ { return m_data; }
    qsizetype size() const/+ noexcept+/ { return m_size; }
    const(char)* data() const/+ noexcept+/ { return m_data; }
    /+ [[nodiscard]] +/ const(char)* constData() const/+ noexcept+/ { return data(); }
    /+ [[nodiscard]] +/ const(char)* constBegin() const/+ noexcept+/ { return begin(); }
    /+ [[nodiscard]] +/ const(char)* constEnd() const/+ noexcept+/ { return end(); }

    /+ [[nodiscard]] +/ QLatin1Char first() const { return front(); }
    /+ [[nodiscard]] +/ QLatin1Char last() const { return back(); }

    /+ [[nodiscard]] +/ qsizetype length() const/+ noexcept+/ { return size(); }

    bool isNull() const/+ noexcept+/ { return !data(); }
    bool isEmpty() const/+ noexcept+/ { return !size(); }

    /+ [[nodiscard]] +/ bool empty() const/+ noexcept+/ { return size() == 0; }

    /+ template <typename...Args> +/
    /+ [[nodiscard]] inline QString arg(Args &&...args) const; +/

    /+ [[nodiscard]] +/ QLatin1Char at(qsizetype i) const
    { return (){(){ (mixin(Q_ASSERT(q{i >= 0})));
return /+ Q_ASSERT(i < size()) +/ mixin(Q_ASSERT(q{i < QLatin1String.size()}));
}();
return QLatin1Char(m_data[i]);
}(); }
    /+ [[nodiscard]] +/ QLatin1Char opIndex(qsizetype i) const { return at(i); }

    /+ [[nodiscard]] +/ QLatin1Char front() const { return at(0); }
    /+ [[nodiscard]] +/ QLatin1Char back() const { return at(size() - 1); }

    /+ [[nodiscard]] +/ int compare(QStringView other, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(this, other, cs);
    }
    /+ [[nodiscard]] +/ int compare(QLatin1StringView other, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(this, other, cs);
    }
/+    /+ [[nodiscard]] +/ int compare(QChar c) const/+ noexcept+/
    { return isEmpty() ? -1 : front() == c ? int(size() > 1) : uchar(m_data[0]) - c.unicode(); }
    /+ [[nodiscard]] +/ int compare(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(this, QStringView(&c, 1), cs);
    }+/

    /+ [[nodiscard]] +/ bool startsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(this, s, cs);
    }
    /+ [[nodiscard]] +/ bool startsWith(QLatin1StringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(this, s, cs);
    }
    /+ [[nodiscard]] +/ bool startsWith(QChar c) const/+ noexcept+/
    { return !isEmpty() && front().unicode == c.unicode; }
    /+ [[nodiscard]] +/ pragma(inline, true) bool startsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(this, QStringView(&c, 1), cs);
    }

    /+ [[nodiscard]] +/ bool endsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(this, s, cs);
    }
    /+ [[nodiscard]] +/ bool endsWith(QLatin1StringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(this, s, cs);
    }
    /+ [[nodiscard]] +/ bool endsWith(QChar c) const/+ noexcept+/
    { return !isEmpty() && back().unicode == c.unicode; }
    /+ [[nodiscard]] +/ pragma(inline, true) bool endsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(this, QStringView(&c, 1), cs);
    }

    /+ [[nodiscard]] +/ qsizetype indexOf(QStringView s, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.findString(this, from, s, cs);
    }
    /+ [[nodiscard]] +/ qsizetype indexOf(QLatin1StringView s, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.findString(this, from, s, cs);
    }
    /+ [[nodiscard]] +/ qsizetype indexOf(QChar c, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.findString(this, from, QStringView(&c, 1), cs);
    }

    /+ [[nodiscard]] +/ bool contains(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(s, 0, cs) != -1; }
    /+ [[nodiscard]] +/ bool contains(QLatin1StringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(s, 0, cs) != -1; }
    /+ [[nodiscard]] +/ pragma(inline, true) bool contains(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(QStringView(&c, 1), 0, cs) != -1; }

    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return lastIndexOf(s, size(), cs); }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QStringView s, qsizetype from, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, from, s, cs);
    }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QLatin1StringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return lastIndexOf(s, size(), cs); }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QLatin1StringView s, qsizetype from, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, from, s, cs);
    }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return lastIndexOf(c, -1, cs); }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QChar c, qsizetype from, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, from, QStringView(&c, 1), cs);
    }

    /+ [[nodiscard]] +/ qsizetype count(QStringView str, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.count(this, str, cs);
    }
    /+ [[nodiscard]] +/ qsizetype count(QLatin1StringView str, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.count(this, str, cs);
    }
    /+ [[nodiscard]] +/ qsizetype count(QChar ch, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.count(this, ch, cs);
    }

    /+ [[nodiscard]] +/ short toShort(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(short)(QByteArrayView(this), ok, base);
    }
    /+ [[nodiscard]] +/ ushort toUShort(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(ushort)(QByteArrayView(this), ok, base);
    }
    /+ [[nodiscard]] +/ int toInt(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(int)(QByteArrayView(this), ok, base);
    }
    /+ [[nodiscard]] +/ uint toUInt(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(uint)(QByteArrayView(this), ok, base);
    }
    /+ [[nodiscard]] +/ cpp_long toLong(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(cpp_long)(QByteArrayView(this), ok, base);
    }
    /+ [[nodiscard]] +/ cpp_ulong toULong(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(cpp_ulong)(QByteArrayView(this), ok, base);
    }
    /+ [[nodiscard]] +/ qlonglong toLongLong(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(qlonglong)(QByteArrayView(this), ok, base);
    }
    /+ [[nodiscard]] +/ qulonglong toULongLong(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(qulonglong)(QByteArrayView(this), ok, base);
    }
    /+ [[nodiscard]] +/ float toFloat(bool* ok = null) const
    {
        import qt.core.bytearrayalgorithms;

        const r = /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toFloat(QByteArrayView(this));
        if (ok)
            *ok = r.opCast!bool;
        return r.value_or(0.0f);
    }
    /+ [[nodiscard]] +/ double toDouble(bool* ok = null) const
    {
        import qt.core.bytearrayalgorithms;

        const r = /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toDouble(QByteArrayView(this));
        if (ok)
            *ok = r.opCast!bool;
        return r.value_or(0.0);
    }

    alias value_type = const(char);
    /+ using reference = value_type&; +/
    /+ using const_reference = reference; +/
    alias iterator = value_type*;
    alias const_iterator = iterator;
    alias difference_type = qsizetype; // violates Container concept requirements
    alias size_type = qsizetype;       // violates Container concept requirements

    const_iterator begin() const/+ noexcept+/ { return data(); }
    const_iterator cbegin() const/+ noexcept+/ { return data(); }
    const_iterator end() const/+ noexcept+/ { return data() + size(); }
    const_iterator cend() const/+ noexcept+/ { return data() + size(); }

    /+ using reverse_iterator = std::reverse_iterator<iterator>; +/
    /+ using const_reverse_iterator = reverse_iterator; +/

    /+ const_reverse_iterator rbegin() const noexcept { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator crbegin() const noexcept { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator rend() const noexcept { return const_reverse_iterator(begin()); } +/
    /+ const_reverse_iterator crend() const noexcept { return const_reverse_iterator(begin()); } +/

/+    /+ [[nodiscard]] +/ QLatin1StringView mid(qsizetype pos, qsizetype n = -1) const
    {
        //using namespace QtPrivate;
        auto result = QContainerImplHelper.mid(size(), &pos, &n);
        return result == QContainerImplHelper.Null ? QLatin1StringView()
                                                    : QLatin1StringView(m_data + pos, n);
    }
    /+ [[nodiscard]] +/ QLatin1StringView left(qsizetype n) const
    {
        if (size_t(n) >= size_t(size()))
            n = size();
        return {m_data, n};
    }
    /+ [[nodiscard]] +/ QLatin1StringView right(qsizetype n) const
    {
        if (size_t(n) >= size_t(size()))
            n = size();
        return {m_data + m_size - n, n};
    }+/

    /+ [[nodiscard]] +/ QLatin1StringView sliced(qsizetype pos) const
    { verify(pos); return QLatin1StringView(m_data + pos, m_size - pos); }
    /+ [[nodiscard]] +/ QLatin1StringView sliced(qsizetype pos, qsizetype n) const
    { verify(pos, n); return QLatin1StringView(m_data + pos, n); }
    /+ [[nodiscard]] +/ QLatin1StringView first(qsizetype n) const
    { verify(n); return QLatin1StringView(m_data, n); }
    /+ [[nodiscard]] +/ QLatin1StringView last(qsizetype n) const
    { verify(n); return QLatin1StringView(m_data + size() - n, n); }
    /+ [[nodiscard]] +/ QLatin1StringView chopped(qsizetype n) const
    { verify(n); return QLatin1StringView(m_data, size() - n); }

    void chop(qsizetype n)
    { verify(n); m_size -= n; }
    void truncate(qsizetype n)
    { verify(n); m_size = n; }

    /+ [[nodiscard]] +/ QLatin1StringView trimmed() const/+ noexcept+/ {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.trimmed(this);
    }

    /+ template <typename Needle, typename...Flags> +/
    /+ [[nodiscard]] inline constexpr auto tokenize(Needle &&needle, Flags...flags) const
        noexcept(noexcept(qTokenize(std::declval<const QLatin1StringView &>(),
                                    std::forward<Needle>(needle), flags...)))
            -> decltype(qTokenize(*this, std::forward<Needle>(needle), flags...))
    { return qTokenize(*this, std::forward<Needle>(needle), flags...); } +/

    /+ friend inline bool operator==(QLatin1StringView s1, QLatin1StringView s2) noexcept
    { return s1.size() == s2.size() && (!s1.size() || !memcmp(s1.latin1(), s2.latin1(), s1.size())); } +/
    /+ friend inline bool operator!=(QLatin1StringView s1, QLatin1StringView s2) noexcept
    { return !(s1 == s2); } +/
    /+ friend inline bool operator<(QLatin1StringView s1, QLatin1StringView s2) noexcept
    {
        const qsizetype len = qMin(s1.size(), s2.size());
        const int r = len ? memcmp(s1.latin1(), s2.latin1(), len) : 0;
        return r < 0 || (r == 0 && s1.size() < s2.size());
    } +/
    /+ friend inline bool operator>(QLatin1StringView s1, QLatin1StringView s2) noexcept
    { return s2 < s1; } +/
    /+ friend inline bool operator<=(QLatin1StringView s1, QLatin1StringView s2) noexcept
    { return !(s1 > s2); } +/
    /+ friend inline bool operator>=(QLatin1StringView s1, QLatin1StringView s2) noexcept
    { return !(s1 < s2); } +/

    // QChar <> QLatin1StringView
    /+ friend inline bool operator==(QChar lhs, QLatin1StringView rhs) noexcept { return rhs.size() == 1 && lhs == rhs.front(); } +/
    /+ friend inline bool operator< (QChar lhs, QLatin1StringView rhs) noexcept { return compare_helper(&lhs, 1, rhs) < 0; } +/
    /+ friend inline bool operator> (QChar lhs, QLatin1StringView rhs) noexcept { return compare_helper(&lhs, 1, rhs) > 0; } +/
    /+ friend inline bool operator!=(QChar lhs, QLatin1StringView rhs) noexcept { return !(lhs == rhs); } +/
    /+ friend inline bool operator<=(QChar lhs, QLatin1StringView rhs) noexcept { return !(lhs >  rhs); } +/
    /+ friend inline bool operator>=(QChar lhs, QLatin1StringView rhs) noexcept { return !(lhs <  rhs); } +/

    /+ friend inline bool operator==(QLatin1StringView lhs, QChar rhs) noexcept { return   rhs == lhs; } +/
    /+ friend inline bool operator!=(QLatin1StringView lhs, QChar rhs) noexcept { return !(rhs == lhs); } +/
    /+ friend inline bool operator< (QLatin1StringView lhs, QChar rhs) noexcept { return   rhs >  lhs; } +/
    /+ friend inline bool operator> (QLatin1StringView lhs, QChar rhs) noexcept { return   rhs <  lhs; } +/
    /+ friend inline bool operator<=(QLatin1StringView lhs, QChar rhs) noexcept { return !(rhs <  lhs); } +/
    /+ friend inline bool operator>=(QLatin1StringView lhs, QChar rhs) noexcept { return !(rhs >  lhs); } +/

    // QStringView <> QLatin1StringView
    /+ friend inline bool operator==(QStringView lhs, QLatin1StringView rhs) noexcept
    { return lhs.size() == rhs.size() && QtPrivate::equalStrings(lhs, rhs); } +/
    /+ friend inline bool operator!=(QStringView lhs, QLatin1StringView rhs) noexcept { return !(lhs == rhs); } +/
    /+ friend inline bool operator< (QStringView lhs, QLatin1StringView rhs) noexcept { return QtPrivate::compareStrings(lhs, rhs) <  0; } +/
    /+ friend inline bool operator<=(QStringView lhs, QLatin1StringView rhs) noexcept { return QtPrivate::compareStrings(lhs, rhs) <= 0; } +/
    /+ friend inline bool operator> (QStringView lhs, QLatin1StringView rhs) noexcept { return QtPrivate::compareStrings(lhs, rhs) >  0; } +/
    /+ friend inline bool operator>=(QStringView lhs, QLatin1StringView rhs) noexcept { return QtPrivate::compareStrings(lhs, rhs) >= 0; } +/

    /+ friend inline bool operator==(QLatin1StringView lhs, QStringView rhs) noexcept
    { return lhs.size() == rhs.size() && QtPrivate::equalStrings(lhs, rhs); } +/
    /+ friend inline bool operator!=(QLatin1StringView lhs, QStringView rhs) noexcept { return !(lhs == rhs); } +/
    /+ friend inline bool operator< (QLatin1StringView lhs, QStringView rhs) noexcept { return QtPrivate::compareStrings(lhs, rhs) <  0; } +/
    /+ friend inline bool operator<=(QLatin1StringView lhs, QStringView rhs) noexcept { return QtPrivate::compareStrings(lhs, rhs) <= 0; } +/
    /+ friend inline bool operator> (QLatin1StringView lhs, QStringView rhs) noexcept { return QtPrivate::compareStrings(lhs, rhs) >  0; } +/
    /+ friend inline bool operator>=(QLatin1StringView lhs, QStringView rhs) noexcept { return QtPrivate::compareStrings(lhs, rhs) >= 0; } +/


/+ #if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
    QT_ASCII_CAST_WARN inline bool operator==(const char *s) const;
    QT_ASCII_CAST_WARN inline bool operator!=(const char *s) const;
    QT_ASCII_CAST_WARN inline bool operator<(const char *s) const;
    QT_ASCII_CAST_WARN inline bool operator>(const char *s) const;
    QT_ASCII_CAST_WARN inline bool operator<=(const char *s) const;
    QT_ASCII_CAST_WARN inline bool operator>=(const char *s) const;

    QT_ASCII_CAST_WARN inline bool operator==(const QByteArray &s) const;
    QT_ASCII_CAST_WARN inline bool operator!=(const QByteArray &s) const;
    QT_ASCII_CAST_WARN inline bool operator<(const QByteArray &s) const;
    QT_ASCII_CAST_WARN inline bool operator>(const QByteArray &s) const;
    QT_ASCII_CAST_WARN inline bool operator<=(const QByteArray &s) const;
    QT_ASCII_CAST_WARN inline bool operator>=(const QByteArray &s) const;

    QT_ASCII_CAST_WARN friend bool operator==(const char *s1, QLatin1StringView s2) { return compare_helper(s2, s1) == 0; }
    QT_ASCII_CAST_WARN friend bool operator!=(const char *s1, QLatin1StringView s2) { return compare_helper(s2, s1) != 0; }
    QT_ASCII_CAST_WARN friend bool operator< (const char *s1, QLatin1StringView s2) { return compare_helper(s2, s1) >  0; }
    QT_ASCII_CAST_WARN friend bool operator> (const char *s1, QLatin1StringView s2) { return compare_helper(s2, s1) <  0; }
    QT_ASCII_CAST_WARN friend bool operator<=(const char *s1, QLatin1StringView s2) { return compare_helper(s2, s1) >= 0; }
    QT_ASCII_CAST_WARN friend bool operator>=(const char *s1, QLatin1StringView s2) { return compare_helper(s2, s1) <= 0; }
#endif +/ // !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)

private:
/+ #if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
    static inline int compare_helper(const QLatin1StringView &s1, const char *s2);
#endif +/
    /+ Q_ALWAYS_INLINE +/ pragma(inline, true) void verify(qsizetype pos, qsizetype n = 0) const
    {
        (mixin(Q_ASSERT(q{pos >= 0})));
        (mixin(Q_ASSERT(q{pos <= QLatin1String.size()})));
        (mixin(Q_ASSERT(q{n >= 0})));
        (mixin(Q_ASSERT(q{n <= QLatin1String.size() - pos})));
    }
    /+ Q_CORE_EXPORT +/ static int compare_helper(const(QChar)* data1, qsizetype length1,
                                                QLatin1StringView s2,
                                                /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
    qsizetype m_size = 0;
    const(char)* m_data = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #ifdef Q_L1S_VIEW_IS_PRIMARY
Q_DECLARE_TYPEINFO(QLatin1StringView, Q_RELOCATABLE_TYPE);
#else
Q_DECLARE_TYPEINFO(QLatin1String, Q_RELOCATABLE_TYPE);
#endif +/

// Qt 4.x compatibility

//
// QLatin1StringView inline implementations
//
bool isLatin1(QLatin1StringView)/+ noexcept+/
{ return true; }


//
// QAnyStringView members that require QLatin1StringView
//

/+ template <typename Visitor>
constexpr decltype(auto) QAnyStringView::visit(Visitor &&v) const
{
    if (isUtf16())
        return std::forward<Visitor>(v)(asStringView());
    else if (isLatin1())
        return std::forward<Visitor>(v)(asLatin1StringView());
    else
        return std::forward<Visitor>(v)(asUtf8StringView());
} +/

//
// QAnyStringView members that require QAnyStringView::visit()
//


/// Binding for C++ class [QString](https://doc.qt.io/qt-6/qstring.html).
@SimulateImplicitConstructor @Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QString
{
private:
    alias Data = QTypedArrayData!(wchar);
public:
    alias DataPointer = QStringPrivate;

    //pragma(inline, true) void this()/+ noexcept+/ {}
    static typeof(this) create()
    {
        return typeof(this).init;
    }

    /+ explicit +/this(const(QChar)* unicode, qsizetype size = -1);
    this(QChar c);
    this(qsizetype size, QChar c);

    @SimulateImplicitConstructor extern(D) this(const(wchar)[] unicode)
    {
        this(cast(const(QChar)*) unicode.ptr, unicode.length);
    }

    @SimulateImplicitConstructor extern(D) this(const(char)[] unicode)
    {
        QString s = fromUtf8(QByteArrayView(unicode.ptr, unicode.length));
        this.d = s.d;
    }

    @SimulateImplicitConstructor extern(D) this(const(dchar)[] unicode)
    {
        QString s = fromUcs4(unicode.ptr, unicode.length);
        this.d = s.d;
    }

    @disable this(this);
    this(ref const(QString) s)
    {
        d = (cast(QString*) &s).d;
    }

    //
    // QString inline members
    //
    pragma(inline, true) this(QLatin1StringView latin1)
    { this = QString.fromLatin1(latin1.data(), latin1.size()); }
/+ #if defined(__cpp_char8_t) || defined(Q_CLANG_QDOC) +/
    /+ Q_WEAK_OVERLOAD +/
    /+ pragma(inline, true) this(const(char)* str)
    {
        this(fromUtf8(str));
    } +/
/+ #endif +/
    pragma(inline, true) ~this() {}
    /+ref QString operator =(QChar c);+/
    /+ref QString operator =(ref const(QString) )/+ noexcept+/;+/
    /+ref QString operator =(QLatin1StringView latin1);+/
    /+ inline QString(QString &&other) noexcept
        = default; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QString) +/
    /+ void swap(QString &other) noexcept { d.swap(other.d); } +/
    pragma(inline, true) qsizetype size() const { return d.size; }
/+ #if QT_DEPRECATED_SINCE(6, 4) +/
    /+ QT_DEPRECATED_VERSION_X_6_4("Use size() or length() instead.") +/
        pragma(inline, true) qsizetype count() const { return d.size; }
/+ #endif +/
    pragma(inline, true) qsizetype length() const { return d.size; }
    pragma(inline, true) bool isEmpty() const
    { return d.size == 0; }
    void resize(qsizetype size);
    void resize(qsizetype size, QChar fillChar);

    ref QString fill(QChar c, qsizetype size = -1);
    void truncate(qsizetype pos);
    void chop(qsizetype n);

    pragma(inline, true) qsizetype capacity() const { return qsizetype(d.constAllocatedCapacity()); }
    pragma(inline, true) void reserve(qsizetype asize)
    {
        if (d.needsDetach() || asize >= capacity() - d.freeSpaceAtBegin())
            reallocData(qMax(asize, size()), QArrayData.AllocationOption.KeepSize);
        if (d.constAllocatedCapacity())
            d.setFlag(Data.ArrayOptions.CapacityReserved);
    }
    pragma(inline, true) void squeeze()
    {
        if (!d.isMutable())
            return;
        if (d.needsDetach() || size() < capacity())
            reallocData(d.size, QArrayData.AllocationOption.KeepSize);
        if (d.constAllocatedCapacity())
            d.clearFlag(Data.ArrayOptions.CapacityReserved);
    }

    pragma(inline, true) const(QChar)* unicode() const
    { return data(); }
    pragma(inline, true) QChar* data()
    {
        detach();
        (mixin(Q_ASSERT(q{QString.d.data()})));
        return reinterpret_cast!(QChar*)(d.data());
    }
    pragma(inline, true) const(QChar)* data() const
    {
        static if ((configValue!"QT5_NULL_STRINGS" == 1 || !defined!"QT5_NULL_STRINGS"))
        {
            return reinterpret_cast!(const(QChar)*)(d.data() ? d.data() : &_empty);
        }
        else
        {
            return reinterpret_cast!(const(QChar)*)(d.data());
        }
    }
    pragma(inline, true) const(QChar)* constData() const
    { return data(); }

    extern(D) const(wchar)[] toConstWString() const
    {
        return (cast(const(wchar)*)constData())[0..length];
    }

    pragma(inline, true) void detach()
    { if (d.needsDetach()) reallocData(d.size, QArrayData.AllocationOption.KeepSize); }
    pragma(inline, true) bool isDetached() const
    { return !d.isShared(); }
    pragma(inline, true) bool isSharedWith(ref const(QString) other) const { return d.isSharedWith(other.d); }
    pragma(inline, true) void clear()
    { if (!isNull()) this = QString.create(); }

    pragma(inline, true) const(QChar) at(qsizetype i) const
    { (mixin(Q_ASSERT(q{size_t(i) < size_t(QString.size())}))); return QChar(d.data()[i]); }
    pragma(inline, true) const(QChar) opIndex(qsizetype i) const
    { (mixin(Q_ASSERT(q{size_t(i) < size_t(QString.size())}))); return QChar(d.data()[i]); }
    /+ [[nodiscard]] +/ pragma(inline, true) ref QChar opIndex(qsizetype i)
    { (mixin(Q_ASSERT(q{i >= 0 && i < QString.size()}))); return data()[i]; }

    /+ [[nodiscard]] +/ pragma(inline, true) QChar front() const { return at(0); }
    /+ [[nodiscard]] +/ pragma(inline, true) ref QChar front() { return opIndex(0); }
    /+ [[nodiscard]] +/ pragma(inline, true) QChar back() const { return at(size() - 1); }
    /+ [[nodiscard]] +/ pragma(inline, true) ref QChar back() { return opIndex(size() - 1); }

    /+ [[nodiscard]] +/ QString arg(qlonglong a, int fieldwidth=0, int base=10,
                    QChar fillChar = QChar(' ')) const;
    /+ [[nodiscard]] +/ QString arg(qulonglong a, int fieldwidth=0, int base=10,
                    QChar fillChar = QChar(' ')) const;
    /+ [[nodiscard]] +/ pragma(inline, true) QString arg(cpp_long a, int fieldWidth=0, int base=10,
                    QChar fillChar = QChar(' ')) const
    { return arg(qlonglong(a), fieldWidth, base, fillChar); }
    /+ [[nodiscard]] +/ pragma(inline, true) QString arg(cpp_ulong a, int fieldWidth=0, int base=10,
                    QChar fillChar = QChar(' ')) const
    { return arg(qulonglong(a), fieldWidth, base, fillChar); }
    /+ [[nodiscard]] +/ pragma(inline, true) QString arg(int a, int fieldWidth = 0, int base = 10,
                    QChar fillChar = QChar(' ')) const
    { return arg(qlonglong(a), fieldWidth, base, fillChar); }
    /+ [[nodiscard]] +/ pragma(inline, true) QString arg(uint a, int fieldWidth = 0, int base = 10,
                    QChar fillChar = QChar(' ')) const
    { return arg(qulonglong(a), fieldWidth, base, fillChar); }
    /+ [[nodiscard]] +/ pragma(inline, true) QString arg(short a, int fieldWidth = 0, int base = 10,
                    QChar fillChar = QChar(' ')) const
    { return arg(qlonglong(a), fieldWidth, base, fillChar); }
    /+ [[nodiscard]] +/ pragma(inline, true) QString arg(ushort a, int fieldWidth = 0, int base = 10,
                    QChar fillChar = QChar(' ')) const
    { return arg(qulonglong(a), fieldWidth, base, fillChar); }
    /+ [[nodiscard]] +/ QString arg(double a, int fieldWidth = 0, char format = 'g', int precision = -1,
                    QChar fillChar = QChar(' ')) const;
    /+ [[nodiscard]] +/ QString arg(char a, int fieldWidth = 0,
                    QChar fillChar = QChar(' ')) const;
    /+ [[nodiscard]] +/ QString arg(QChar a, int fieldWidth = 0,
                    QChar fillChar = QChar(' ')) const;
    /+ [[nodiscard]] +/ QString arg(ref const(QString) a, int fieldWidth = 0,
                    QChar fillChar = QChar(' ')) const;
    /+ [[nodiscard]] +/ QString arg(QStringView a, int fieldWidth = 0,
                    QChar fillChar = QChar(' ')) const;
    /+ [[nodiscard]] +/ QString arg(QLatin1StringView a, int fieldWidth = 0,
                    QChar fillChar = QChar(' ')) const;
private:
    /+ template <typename T> +/
    /+ struct is_convertible_to_view_or_qstring_helper
        : std::integral_constant<bool,
            std::is_convertible<T, QString>::value ||
            std::is_convertible<T, QStringView>::value ||
            std::is_convertible<T, QLatin1StringView>::value> {}; +/
    /+ template <typename T> +/
    struct is_convertible_to_view_or_qstring(T)
 {
        is_convertible_to_view_or_qstring_helper!(/+ std:: +/decay!(T).type) base0;
        alias base0 this;
}
public:
    /+ template <typename...Args> +/
    /+ [[nodiscard]]
#ifdef Q_CLANG_QDOC
    QString
#else
    typename std::enable_if<
        sizeof...(Args) >= 2 && std::is_same<
            QtPrivate::BoolList<is_convertible_to_view_or_qstring<Args>::value..., true>,
            QtPrivate::BoolList<true, is_convertible_to_view_or_qstring<Args>::value...>
        >::value,
        QString
    >::type
#endif
    arg(Args &&...args) const
    { return qToStringViewIgnoringNull(*this).arg(std::forward<Args>(args)...); } +/

    static QString vasprintf(const(char)* format, va_list ap) /+ Q_ATTRIBUTE_FORMAT_PRINTF(1, 0) +/;
    static QString asprintf(const(char)* format, ...) /+ Q_ATTRIBUTE_FORMAT_PRINTF(1, 2) +/;

    /+ [[nodiscard]] +/ qsizetype indexOf(QChar c, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ [[nodiscard]] +/ qsizetype indexOf(QLatin1StringView s, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ [[nodiscard]] +/ qsizetype indexOf(ref const(QString) s, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ [[nodiscard]] +/ qsizetype indexOf(QStringView s, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.findString(QStringView(this), from, s, cs);
    }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return lastIndexOf(c, -1, cs); }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QChar c, qsizetype from, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QLatin1StringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    { return lastIndexOf(s, size(), cs); }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QLatin1StringView s, qsizetype from, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    { return lastIndexOf(s, size(), cs); }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(ref const(QString) s, qsizetype from, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;

    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return lastIndexOf(s, size(), cs); }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QStringView s, qsizetype from, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(QStringView(this), from, s, cs);
    }

    /+ [[nodiscard]] +/ pragma(inline, true) bool contains(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    { return indexOf(c, 0, cs) != -1; }
    /+ [[nodiscard]] +/ pragma(inline, true) bool contains(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    { return indexOf(s, 0, cs) != -1; }
    /+ [[nodiscard]] +/ pragma(inline, true) bool contains(QLatin1StringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    { return indexOf(s, 0, cs) != -1; }
    /+ [[nodiscard]] +/ pragma(inline, true) bool contains(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(s, 0, cs) != -1; }
    /+ [[nodiscard]] +/ qsizetype count(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ [[nodiscard]] +/ qsizetype count(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ [[nodiscard]] +/ qsizetype count(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;

/+ #if QT_CONFIG(regularexpression) +/
    /+ [[nodiscard]] +/ qsizetype indexOf(ref const(QRegularExpression) re, qsizetype from = 0,
                                        QRegularExpressionMatch* rmatch = null) const;
/+ #ifdef Q_QDOC
    [[nodiscard]] qsizetype lastIndexOf(const QRegularExpression &re, QRegularExpressionMatch *rmatch = nullptr) const;
#else +/
    // prevent an ambiguity when called like this: lastIndexOf(re, 0)
    /+ template <typename T = QRegularExpressionMatch, std::enable_if_t<std::is_same_v<T, QRegularExpressionMatch>, bool> = false> +/
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(T,)(ref const(QRegularExpression) re, T* rmatch = null) const
    { return lastIndexOf(re, size(), rmatch); }
/+ #endif +/
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(ref const(QRegularExpression) re, qsizetype from,
                                            QRegularExpressionMatch* rmatch = null) const;
    /+ [[nodiscard]] +/ bool contains(ref const(QRegularExpression) re, QRegularExpressionMatch* rmatch = null) const;
    /+ [[nodiscard]] +/ qsizetype count(ref const(QRegularExpression) re) const;
/+ #endif +/

    enum SectionFlag {
        SectionDefault             = 0x00,
        SectionSkipEmpty           = 0x01,
        SectionIncludeLeadingSep   = 0x02,
        SectionIncludeTrailingSep  = 0x04,
        SectionCaseInsensitiveSeps = 0x08
    }
    /+ Q_DECLARE_FLAGS(SectionFlags, SectionFlag) +/
alias SectionFlags = QFlags!(SectionFlag);
    /+ [[nodiscard]] +/ pragma(inline, true) QString section(QChar asep, qsizetype astart, qsizetype aend = -1, SectionFlags aflags = SectionFlag.SectionDefault) const
    { auto tmp = QString(asep); return section(tmp, astart, aend, aflags); }
    /+ [[nodiscard]] +/ QString section(ref const(QString) in_sep, qsizetype start, qsizetype end = -1, SectionFlags flags = SectionFlag.SectionDefault) const;
/+ #if QT_CONFIG(regularexpression) +/
    /+ [[nodiscard]] +/ QString section(ref const(QRegularExpression) re, qsizetype start, qsizetype end = -1, SectionFlags flags = SectionFlag.SectionDefault) const;
/+ #endif +/
    /+ [[nodiscard]] +/ QString left(qsizetype n) const;
    /+ [[nodiscard]] +/ QString right(qsizetype n) const;
    /+ [[nodiscard]] +/ QString mid(qsizetype position, qsizetype n = -1) const;

    /+ [[nodiscard]] +/ QString first(qsizetype n) const
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QString.size()}))); return QString(data(), n); }
    /+ [[nodiscard]] +/ QString last(qsizetype n) const
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QString.size()}))); return QString(data() + size() - n, n); }
    /+ [[nodiscard]] +/ QString sliced(qsizetype pos) const
    { (mixin(Q_ASSERT(q{pos >= 0}))); (mixin(Q_ASSERT(q{pos <= QString.size()}))); return QString(data() + pos, size() - pos); }
    /+ [[nodiscard]] +/ QString sliced(qsizetype pos, qsizetype n) const
    { (mixin(Q_ASSERT(q{pos >= 0}))); (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{size_t(pos) + size_t(n) <= size_t(QString.size())}))); return QString(data() + pos, n); }
    /+ [[nodiscard]] +/ QString chopped(qsizetype n) const
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QString.size()}))); return first(size() - n); }


    bool startsWith(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ [[nodiscard]] +/ bool startsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(QStringView(this), s, cs);
    }
    bool startsWith(QLatin1StringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    bool startsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;

    bool endsWith(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ [[nodiscard]] +/ bool endsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(QStringView(this), s, cs);
    }
    bool endsWith(QLatin1StringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    bool endsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;

    bool isUpper() const;
    bool isLower() const;

    /+ [[nodiscard]] +/ QString leftJustified(qsizetype width, QChar fill = QChar(' '), bool trunc = false) const;
    /+ [[nodiscard]] +/ QString rightJustified(qsizetype width, QChar fill = QChar(' '), bool trunc = false) const;

/+ #if !defined(Q_CLANG_QDOC) +/
    /+ [[nodiscard]] +/ QString toLower() const/+ &+/
    { return toLower_helper(this); }
    /+ [[nodiscard]] QString toLower() &&
    { return toLower_helper(*this); } +/
    /+ [[nodiscard]] +/ QString toUpper() const/+ &+/
    { return toUpper_helper(this); }
    /+ [[nodiscard]] QString toUpper() &&
    { return toUpper_helper(*this); } +/
    /+ [[nodiscard]] +/ QString toCaseFolded() const/+ &+/
    { return toCaseFolded_helper(this); }
    /+ [[nodiscard]] QString toCaseFolded() &&
    { return toCaseFolded_helper(*this); } +/
    /+ [[nodiscard]] +/ QString trimmed() const/+ &+/
    { return trimmed_helper(this); }
    /+ [[nodiscard]] QString trimmed() &&
    { return trimmed_helper(*this); } +/
    /+ [[nodiscard]] +/ QString simplified() const/+ &+/
    { return simplified_helper(this); }
    /+ [[nodiscard]] QString simplified() &&
    { return simplified_helper(*this); } +/
/+ #else
    [[nodiscard]] QString toLower() const;
    [[nodiscard]] QString toUpper() const;
    [[nodiscard]] QString toCaseFolded() const;
    [[nodiscard]] QString trimmed() const;
    [[nodiscard]] QString simplified() const;
#endif +/
    /+ [[nodiscard]] +/ QString toHtmlEscaped() const;

    ref QString insert(qsizetype i, QChar c);
    ref QString insert(qsizetype i, const(QChar)* uc, qsizetype len);
    pragma(inline, true) ref QString insert(qsizetype i, ref const(QString) s) { return insert(i, s.constData(), s.size()); }
    pragma(inline, true) ref QString insert(qsizetype i, QStringView v) { return insert(i, v.data(), v.size()); }
    ref QString insert(qsizetype i, QLatin1StringView s);

    ref QString append(QChar c);
    ref QString append(const(QChar)* uc, qsizetype len);
    ref QString append(ref const(QString) s);
    pragma(inline, true) ref QString append(QStringView v) { return append(v.data(), v.size()); }
    ref QString append(QLatin1StringView s);

    pragma(inline, true) ref QString prepend(QChar c) { return insert(0, c); }
    pragma(inline, true) ref QString prepend(const(QChar)* uc, qsizetype len) { return insert(0, uc, len); }
    pragma(inline, true) ref QString prepend(ref const(QString) s) { return insert(0, s); }
    pragma(inline, true) ref QString prepend(QStringView v) { return prepend(v.data(), v.size()); }
    pragma(inline, true) ref QString prepend(QLatin1StringView s) { return insert(0, s); }

    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(QChar c) if (op == "~") { return append(c); }

    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(ref const(QString) s) if (op == "~") { return append(s); }
    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(QStringView v) if (op == "~") { return append(v); }
    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(const QString s) if (op == "~") { return append(s); }
    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(QLatin1StringView s) if (op == "~") { return append(s); }
    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(string s) if (op == "~") { auto tmp = QString(s); return append(tmp); }

    ref QString remove(qsizetype i, qsizetype len);
    ref QString remove(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString remove(QLatin1StringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString remove(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    /+ template <typename Predicate> +/
    ref QString removeIf(Predicate)(Predicate pred)
    {
        import qt.core.containertools_impl;

        /+ QtPrivate:: +/qt.core.containertools_impl.sequential_erase_if(this, pred);
        return this;
    }
    ref QString replace(qsizetype i, qsizetype len, QChar after);
    ref QString replace(qsizetype i, qsizetype len, const(QChar)* s, qsizetype slen);
    ref QString replace(qsizetype i, qsizetype len, ref const(QString) after);
    ref QString replace(QChar before, QChar after, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(const(QChar)* before, qsizetype blen, const(QChar)* after, qsizetype alen, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(QLatin1StringView before, QLatin1StringView after, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(QLatin1StringView before, ref const(QString) after, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(ref const(QString) before, QLatin1StringView after, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(ref const(QString) before, ref const(QString) after,
                         /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(QChar c, ref const(QString) after, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(QChar c, QLatin1StringView after, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
/+ #if QT_CONFIG(regularexpression) +/
    ref QString replace(ref const(QRegularExpression) re, ref const(QString)  after);
    pragma(inline, true) ref QString remove(ref const(QRegularExpression) re)
    { auto tmp = QString(); return replace(re, tmp); }
/+ #endif +/

public:
    /+ [[nodiscard]] +/
        QStringList split(ref const(QString) sep, /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts,
                          /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ [[nodiscard]] +/
        QStringList split(QChar sep, /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts,
                          /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    version (QT_NO_REGULAREXPRESSION) {} else
    {
        /+ [[nodiscard]] +/
            QStringList split(ref const(QRegularExpression) sep,
                              /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts) const;
    }

    /+ template <typename Needle, typename...Flags> +/
    /+ [[nodiscard]] inline auto tokenize(Needle &&needle, Flags...flags) const &
        noexcept(noexcept(qTokenize(std::declval<const QString &>(), std::forward<Needle>(needle), flags...)))
            -> decltype(qTokenize(*this, std::forward<Needle>(needle), flags...))
    { return qTokenize(qToStringViewIgnoringNull(*this), std::forward<Needle>(needle), flags...); } +/

    /+ template <typename Needle, typename...Flags> +/
    /+ [[nodiscard]] inline auto tokenize(Needle &&needle, Flags...flags) const &&
        noexcept(noexcept(qTokenize(std::declval<const QString>(), std::forward<Needle>(needle), flags...)))
            -> decltype(qTokenize(std::move(*this), std::forward<Needle>(needle), flags...))
    { return qTokenize(std::move(*this), std::forward<Needle>(needle), flags...); } +/

    /+ template <typename Needle, typename...Flags> +/
    /+ [[nodiscard]] inline auto tokenize(Needle &&needle, Flags...flags) &&
        noexcept(noexcept(qTokenize(std::declval<QString>(), std::forward<Needle>(needle), flags...)))
            -> decltype(qTokenize(std::move(*this), std::forward<Needle>(needle), flags...))
    { return qTokenize(std::move(*this), std::forward<Needle>(needle), flags...); } +/


    enum NormalizationForm {
        NormalizationForm_D,
        NormalizationForm_C,
        NormalizationForm_KD,
        NormalizationForm_KC
    }
    /+ [[nodiscard]] +/ QString normalized(NormalizationForm mode, QChar.UnicodeVersion version_ = QChar.UnicodeVersion.Unicode_Unassigned) const;

    /+ [[nodiscard]] +/ QString repeated(qsizetype times) const;

    const(ushort)* utf16() const; // ### Qt 7 char16_t

/+ #if !defined(Q_CLANG_QDOC) +/
    /+ [[nodiscard]] +/ QByteArray toLatin1() const/+ &+/
    { return toLatin1_helper(this); }
    /+ [[nodiscard]] QByteArray toLatin1() &&
    { return toLatin1_helper_inplace(*this); } +/
    /+ [[nodiscard]] +/ QByteArray toUtf8() const/+ &+/
    { return toUtf8_helper(this); }
    /+ [[nodiscard]] QByteArray toUtf8() &&
    { return toUtf8_helper(*this); } +/
    /+ [[nodiscard]] +/ QByteArray toLocal8Bit() const/+ &+/
    { return toLocal8Bit_helper(isNull() ? null : constData(), size()); }
    /+ [[nodiscard]] QByteArray toLocal8Bit() &&
    { return toLocal8Bit_helper(isNull() ? nullptr : constData(), size()); } +/
/+ #else
    [[nodiscard]] QByteArray toLatin1() const;
    [[nodiscard]] QByteArray toUtf8() const;
    [[nodiscard]] QByteArray toLocal8Bit() const;
#endif +/
    /+ [[nodiscard]] +/ QList!(uint) toUcs4() const; // ### Qt 7 char32_t

    // note - this are all inline so we can benefit from strlen() compile time optimizations
    static QString fromLatin1(QByteArrayView ba);
    /+ Q_WEAK_OVERLOAD +/
    pragma(inline, true) static QString fromLatin1(ref const(QByteArray) ba) { return fromLatin1(QByteArrayView(ba)); }
    pragma(inline, true) static QString fromLatin1(const(char)* str, qsizetype size)
    {
        import qt.core.bytearrayalgorithms;

        return fromLatin1(QByteArrayView(str, !str || size < 0 ? qstrlen(str) : size));
    }
    static QString fromUtf8(QByteArrayView utf8);
    /+ Q_WEAK_OVERLOAD +/
    pragma(inline, true) static QString fromUtf8(ref const(QByteArray) ba) { return fromUtf8(QByteArrayView(ba)); }
    pragma(inline, true) static QString fromUtf8(const(char)* utf8, qsizetype size = -1)
    {
        import qt.core.bytearrayalgorithms;

        return fromUtf8(QByteArrayView(utf8, !utf8 || size < 0 ? qstrlen(utf8) : size));
    }
/+ #if defined(__cpp_char8_t) || defined(Q_CLANG_QDOC) +/
    /+ Q_WEAK_OVERLOAD +/
    /+pragma(inline, true) static QString fromUtf8(const(char)* str)
    { return fromUtf8(reinterpret_cast!(const(char)*)(str)); }+/
    /+ Q_WEAK_OVERLOAD +/
    /+ pragma(inline, true) static QString fromUtf8(const(char)* str, qsizetype size)
    { return fromUtf8(reinterpret_cast!(const(char)*)(str), size); } +/
/+ #endif +/
    static QString fromLocal8Bit(QByteArrayView ba);
    /+ Q_WEAK_OVERLOAD +/
    pragma(inline, true) static QString fromLocal8Bit(ref const(QByteArray) ba) { return fromLocal8Bit(QByteArrayView(ba)); }
    pragma(inline, true) static QString fromLocal8Bit(const(char)* str, qsizetype size)
    {
        import qt.core.bytearrayalgorithms;

        return fromLocal8Bit(QByteArrayView(str, !str || size < 0 ? qstrlen(str) : size));
    }
    static QString fromUtf16(const(wchar)* , qsizetype size = -1);
    static QString fromUcs4(const(dchar)* , qsizetype size = -1);
    static QString fromRawData(const(QChar)* , qsizetype size);

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use char16_t* overload.") +/
        static QString fromUtf16(const(ushort)* str, qsizetype size = -1)
    { return fromUtf16(reinterpret_cast!(const(wchar)*)(str), size); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use char32_t* overload.") +/
        static QString fromUcs4(const(uint)* str, qsizetype size = -1)
    { return fromUcs4(reinterpret_cast!(const(dchar)*)(str), size); }
/+ #endif +/

/+    pragma(inline, true) qsizetype toWCharArray(wchar_t* array) const
    {
        return qToStringViewIgnoringNull(this).toWCharArray(array);
    }+/
    /+ [[nodiscard]] +/ pragma(inline, true) static QString fromWCharArray(const(wchar_t)* string, qsizetype size = -1)
    {
        return wchar_t.sizeof == QChar.sizeof ? fromUtf16(reinterpret_cast!(const(wchar)*)(string), size)
                                                : fromUcs4(reinterpret_cast!(const(dchar)*)(string), size);
    }

    ref QString setRawData(const(QChar)* unicode, qsizetype size);
    ref QString setUnicode(const(QChar)* unicode, qsizetype size);
    pragma(inline, true) ref QString setUtf16(const(ushort)* autf16, qsizetype asize)
    { return setUnicode(reinterpret_cast!(const(QChar)*)(autf16), asize); } // ### Qt 7 char16_t

    int compare(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/;
    int compare(QLatin1StringView other, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/;
    pragma(inline, true) int compare(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return -s.compare(QStringView(this), cs); }
    int compare(QChar ch, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return compare(QStringView(&ch, 1), cs); }

    pragma(inline, true) static int compare(ref const(QString) s1, ref const(QString) s2,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/
    { return s1.compare(s2, cs); }

    pragma(inline, true) static int compare(ref const(QString) s1, QLatin1StringView s2,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/
    { return s1.compare(s2, cs); }
    pragma(inline, true) static int compare(QLatin1StringView s1, ref const(QString) s2,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/
    { return -s2.compare(s1, cs); }
    static int compare(ref const(QString) s1, QStringView s2, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/
    { return s1.compare(s2, cs); }
    static int compare(QStringView s1, ref const(QString) s2, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/
    { return -s2.compare(s1, cs); }

    int localeAwareCompare(ref const(QString) s) const;
    pragma(inline, true) int localeAwareCompare(QStringView s) const
    { return localeAwareCompare_helper(constData(), size(), s.constData(), s.size()); }
    static int localeAwareCompare(ref const(QString) s1, ref const(QString) s2)
    { return s1.localeAwareCompare(s2); }

    pragma(inline, true) static int localeAwareCompare(QStringView s1, QStringView s2)
    { return localeAwareCompare_helper(s1.constData(), s1.size(), s2.constData(), s2.size()); }

    short toShort(bool* ok=null, int base=10) const
    { return toIntegral_helper!(short)(QStringView(this), ok, base); }
    ushort toUShort(bool* ok=null, int base=10) const
    { return toIntegral_helper!(ushort)(QStringView(this), ok, base); }
    int toInt(bool* ok=null, int base=10) const
    { return toIntegral_helper!(int)(QStringView(this), ok, base); }
    uint toUInt(bool* ok=null, int base=10) const
    { return toIntegral_helper!(uint)(QStringView(this), ok, base); }
    cpp_long toLong(bool* ok=null, int base=10) const
    { return toIntegral_helper!(cpp_long)(QStringView(this), ok, base); }
    cpp_ulong toULong(bool* ok=null, int base=10) const
    { return toIntegral_helper!(cpp_ulong)(QStringView(this), ok, base); }
    qlonglong toLongLong(bool* ok=null, int base=10) const;
    qulonglong toULongLong(bool* ok=null, int base=10) const;
    float toFloat(bool* ok=null) const;
    double toDouble(bool* ok=null) const;

    pragma(inline, true) ref QString setNum(short n, int base=10)
    { return setNum(qlonglong(n), base); }
    pragma(inline, true) ref QString setNum(ushort n, int base=10)
    { return setNum(qulonglong(n), base); }
    pragma(inline, true) ref QString setNum(int n, int base=10)
    { return setNum(qlonglong(n), base); }
    pragma(inline, true) ref QString setNum(uint n, int base=10)
    { return setNum(qulonglong(n), base); }
    pragma(inline, true) ref QString setNum(cpp_long n, int base=10)
    { return setNum(qlonglong(n), base); }
    pragma(inline, true) ref QString setNum(cpp_ulong n, int base=10)
    { return setNum(qulonglong(n), base); }
    ref QString setNum(qlonglong, int base=10);
    ref QString setNum(qulonglong, int base=10);
    pragma(inline, true) ref QString setNum(float n, char f='g', int prec=6)
    { return setNum(double(n),f,prec); }
    ref QString setNum(double, char format='g', int precision=6);

    static QString number(int, int base=10);
    static QString number(uint, int base=10);
    static QString number(cpp_long, int base=10);
    static QString number(cpp_ulong, int base=10);
    static QString number(qlonglong, int base=10);
    static QString number(qulonglong, int base=10);
    static QString number(double, char format='g', int precision=6);

    /+ friend bool operator==(const QString &s1, const QString &s2) noexcept
    { return (s1.size() == s2.size()) && QtPrivate::compareStrings(s1, s2, Qt::CaseSensitive) == 0; } +/
    /+ friend bool operator< (const QString &s1, const QString &s2) noexcept
    { return QtPrivate::compareStrings(s1, s2, Qt::CaseSensitive) < 0; } +/
    /+ friend bool operator> (const QString &s1, const QString &s2) noexcept { return s2 < s1; } +/
    /+ friend bool operator!=(const QString &s1, const QString &s2) noexcept { return !(s1 == s2); } +/
    /+ friend bool operator<=(const QString &s1, const QString &s2) noexcept { return !(s1 > s2); } +/
    /+ friend bool operator>=(const QString &s1, const QString &s2) noexcept { return !(s1 < s2); } +/

    /+ friend bool operator==(const QString &s1, QLatin1StringView s2) noexcept
    { return (s1.size() == s2.size()) && QtPrivate::compareStrings(s1, s2, Qt::CaseSensitive) == 0; } +/
    /+ friend bool operator< (const QString &s1, QLatin1StringView s2) noexcept
    { return QtPrivate::compareStrings(s1, s2, Qt::CaseSensitive) < 0; } +/
    /+ friend bool operator> (const QString &s1, QLatin1StringView s2) noexcept
    { return QtPrivate::compareStrings(s1, s2, Qt::CaseSensitive) > 0; } +/
    /+ friend bool operator!=(const QString &s1, QLatin1StringView s2) noexcept { return !(s1 == s2); } +/
    /+ friend bool operator<=(const QString &s1, QLatin1StringView s2) noexcept { return !(s1 > s2); } +/
    /+ friend bool operator>=(const QString &s1, QLatin1StringView s2) noexcept { return !(s1 < s2); } +/

    /+ friend bool operator==(QLatin1StringView s1, const QString &s2) noexcept { return s2 == s1; } +/
    /+ friend bool operator< (QLatin1StringView s1, const QString &s2) noexcept { return s2 > s1; } +/
    /+ friend bool operator> (QLatin1StringView s1, const QString &s2) noexcept { return s2 < s1; } +/
    /+ friend bool operator!=(QLatin1StringView s1, const QString &s2) noexcept { return s2 != s1; } +/
    /+ friend bool operator<=(QLatin1StringView s1, const QString &s2) noexcept { return s2 >= s1; } +/
    /+ friend bool operator>=(QLatin1StringView s1, const QString &s2) noexcept { return s2 <= s1; } +/

    // Check isEmpty() instead of isNull() for backwards compatibility.
    /+ friend bool operator==(const QString &s1, std::nullptr_t) noexcept { return s1.isEmpty(); } +/
    /+ friend bool operator!=(const QString &s1, std::nullptr_t) noexcept { return !s1.isEmpty(); } +/
    /+ friend bool operator< (const QString &  , std::nullptr_t) noexcept { return false; } +/
    /+ friend bool operator> (const QString &s1, std::nullptr_t) noexcept { return !s1.isEmpty(); } +/
    /+ friend bool operator<=(const QString &s1, std::nullptr_t) noexcept { return s1.isEmpty(); } +/
    /+ friend bool operator>=(const QString &  , std::nullptr_t) noexcept { return true; } +/
    /+ friend bool operator==(std::nullptr_t, const QString &s2) noexcept { return s2 == nullptr; } +/
    /+ friend bool operator!=(std::nullptr_t, const QString &s2) noexcept { return s2 != nullptr; } +/
    /+ friend bool operator< (std::nullptr_t, const QString &s2) noexcept { return s2 >  nullptr; } +/
    /+ friend bool operator> (std::nullptr_t, const QString &s2) noexcept { return s2 <  nullptr; } +/
    /+ friend bool operator<=(std::nullptr_t, const QString &s2) noexcept { return s2 >= nullptr; } +/
    /+ friend bool operator>=(std::nullptr_t, const QString &s2) noexcept { return s2 <= nullptr; } +/

    /+ friend bool operator==(const QString &s1, const char16_t *s2) noexcept { return s1 == QStringView(s2); } +/
    /+ friend bool operator!=(const QString &s1, const char16_t *s2) noexcept { return s1 != QStringView(s2); } +/
    /+ friend bool operator< (const QString &s1, const char16_t *s2) noexcept { return s1 <  QStringView(s2); } +/
    /+ friend bool operator> (const QString &s1, const char16_t *s2) noexcept { return s1 >  QStringView(s2); } +/
    /+ friend bool operator<=(const QString &s1, const char16_t *s2) noexcept { return s1 <= QStringView(s2); } +/
    /+ friend bool operator>=(const QString &s1, const char16_t *s2) noexcept { return s1 >= QStringView(s2); } +/

    /+ friend bool operator==(const char16_t *s1, const QString &s2) noexcept { return s2 == s1; } +/
    /+ friend bool operator!=(const char16_t *s1, const QString &s2) noexcept { return s2 != s1; } +/
    /+ friend bool operator< (const char16_t *s1, const QString &s2) noexcept { return s2 >  s1; } +/
    /+ friend bool operator> (const char16_t *s1, const QString &s2) noexcept { return s2 <  s1; } +/
    /+ friend bool operator<=(const char16_t *s1, const QString &s2) noexcept { return s2 >= s1; } +/
    /+ friend bool operator>=(const char16_t *s1, const QString &s2) noexcept { return s2 <= s1; } +/

    // QChar <> QString
    /+ friend inline bool operator==(QChar lhs, const QString &rhs) noexcept
    { return rhs.size() == 1 && lhs == rhs.front(); } +/
    /+ friend inline bool operator< (QChar lhs, const QString &rhs) noexcept
    { return compare_helper(&lhs, 1, rhs.data(), rhs.size()) < 0; } +/
    /+ friend inline bool operator> (QChar lhs, const QString &rhs) noexcept
    { return compare_helper(&lhs, 1, rhs.data(), rhs.size()) > 0; } +/

    /+ friend inline bool operator!=(QChar lhs, const QString &rhs) noexcept { return !(lhs == rhs); } +/
    /+ friend inline bool operator<=(QChar lhs, const QString &rhs) noexcept { return !(lhs >  rhs); } +/
    /+ friend inline bool operator>=(QChar lhs, const QString &rhs) noexcept { return !(lhs <  rhs); } +/

    /+ friend inline bool operator==(const QString &lhs, QChar rhs) noexcept { return   rhs == lhs; } +/
    /+ friend inline bool operator!=(const QString &lhs, QChar rhs) noexcept { return !(rhs == lhs); } +/
    /+ friend inline bool operator< (const QString &lhs, QChar rhs) noexcept { return   rhs >  lhs; } +/
    /+ friend inline bool operator> (const QString &lhs, QChar rhs) noexcept { return   rhs <  lhs; } +/
    /+ friend inline bool operator<=(const QString &lhs, QChar rhs) noexcept { return !(rhs <  lhs); } +/
    /+ friend inline bool operator>=(const QString &lhs, QChar rhs) noexcept { return !(rhs >  lhs); } +/

    // ASCII compatibility
/+ #if defined(QT_RESTRICTED_CAST_FROM_ASCII) +/
    version (QT_RESTRICTED_CAST_FROM_ASCII)
    {
        /+ template <qsizetype N> +/
        pragma(inline, true) this(qsizetype N)(ref const(char)[N] ch)
        {
            this(fromUtf8(ch));
        }
        /+ template <qsizetype N> +/
        this(qsizetype N)(ref char[N] ) /+ = delete +/;
        /+ template <qsizetype N> +/
        /+pragma(inline, true) ref QString operator =(qsizetype N)(ref const(char)[N] ch)
        { return ((){return this = fromUtf8(ch.ptr, N - 1);
    }()); }+/
        /+ template <qsizetype N> +/
        /+ref QString operator =(qsizetype N)(ref char[N] ) /+ = delete +/;+/
    }
/+ #endif
#if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
    QT_ASCII_CAST_WARN inline QString(const char *ch)
        : QString(fromUtf8(ch))
    {}
    QT_ASCII_CAST_WARN inline QString(const QByteArray &a)
        : QString(fromUtf8(a))
    {}
    QT_ASCII_CAST_WARN inline QString &operator=(const char *ch)
    { return (*this = fromUtf8(ch)); }
    QT_ASCII_CAST_WARN inline QString &operator=(const QByteArray &a)
    { return (*this = fromUtf8(a)); }

    // these are needed, so it compiles with STL support enabled
    QT_ASCII_CAST_WARN inline QString &prepend(const char *s)
    { return prepend(QString::fromUtf8(s)); }
    QT_ASCII_CAST_WARN inline QString &prepend(const QByteArray &s)
    { return prepend(QString::fromUtf8(s)); }
    QT_ASCII_CAST_WARN inline QString &append(const char *s)
    { return append(QString::fromUtf8(s)); }
    QT_ASCII_CAST_WARN inline QString &append(const QByteArray &s)
    { return append(QString::fromUtf8(s)); }
    QT_ASCII_CAST_WARN inline QString &insert(qsizetype i, const char *s)
    { return insert(i, QString::fromUtf8(s)); }
    QT_ASCII_CAST_WARN inline QString &insert(qsizetype i, const QByteArray &s)
    { return insert(i, QString::fromUtf8(s)); }
    QT_ASCII_CAST_WARN inline QString &operator+=(const char *s)
    { return append(QString::fromUtf8(s)); }
    QT_ASCII_CAST_WARN inline QString &operator+=(const QByteArray &s)
    { return append(QString::fromUtf8(s)); }

    QT_ASCII_CAST_WARN inline bool operator==(const char *s) const;
    QT_ASCII_CAST_WARN inline bool operator!=(const char *s) const;
    QT_ASCII_CAST_WARN inline bool operator<(const char *s) const;
    QT_ASCII_CAST_WARN inline bool operator<=(const char *s) const;
    QT_ASCII_CAST_WARN inline bool operator>(const char *s) const;
    QT_ASCII_CAST_WARN inline bool operator>=(const char *s) const;

    QT_ASCII_CAST_WARN inline bool operator==(const QByteArray &s) const;
    QT_ASCII_CAST_WARN inline bool operator!=(const QByteArray &s) const;
    QT_ASCII_CAST_WARN inline bool operator<(const QByteArray &s) const;
    QT_ASCII_CAST_WARN inline bool operator>(const QByteArray &s) const;
    QT_ASCII_CAST_WARN inline bool operator<=(const QByteArray &s) const;
    QT_ASCII_CAST_WARN inline bool operator>=(const QByteArray &s) const;

    QT_ASCII_CAST_WARN friend bool operator==(const char *s1, const QString &s2)
    { return QString::compare_helper(s2.constData(), s2.size(), s1, -1) == 0; }
    QT_ASCII_CAST_WARN friend bool operator!=(const char *s1, const QString &s2)
    { return QString::compare_helper(s2.constData(), s2.size(), s1, -1) != 0; }
    QT_ASCII_CAST_WARN friend bool operator< (const char *s1, const QString &s2)
    { return QString::compare_helper(s2.constData(), s2.size(), s1, -1) > 0; }
    QT_ASCII_CAST_WARN friend bool operator> (const char *s1, const QString &s2)
    { return QString::compare_helper(s2.constData(), s2.size(), s1, -1) < 0; }
    QT_ASCII_CAST_WARN friend bool operator<=(const char *s1, const QString &s2)
    { return QString::compare_helper(s2.constData(), s2.size(), s1, -1) >= 0; }
    QT_ASCII_CAST_WARN friend bool operator>=(const char *s1, const QString &s2)
    { return QString::compare_helper(s2.constData(), s2.size(), s1, -1) <= 0; }
#endif +/

    /*extern(D) bool opEquals(const char *s) const
    {
        auto r = compare_helper(constData(), size(), s, -1);
        return r == 0;
    }*/
    extern(D) bool opEquals(const(char)[] s) const
    {
        auto r = compare_helper(constData(), size(), s.ptr, cast(int)s.length);
        return r == 0;
    }
    extern(D) bool opEquals(const(wchar)[] s) const
    {
        return (cast(wchar*)constData())[0..size()] == s;
    }
    extern(D) bool opEquals(const ref QString s) const
    {
        return compare_helper(constData(), size(), s.constData, s.size()) == 0;
    }
    extern(D) bool opEquals(const QString s) const
    {
        return compare_helper(constData(), size(), s.constData, s.size()) == 0;
    }

    alias iterator = QChar*;
    alias const_iterator = const(QChar)*;
    alias Iterator = iterator;
    alias ConstIterator = const_iterator;
    /+ typedef std::reverse_iterator<iterator> reverse_iterator; +/
    /+ typedef std::reverse_iterator<const_iterator> const_reverse_iterator; +/
    pragma(inline, true) iterator begin()
    { detach(); return reinterpret_cast!(QChar*)(d.data()); }
    pragma(inline, true) const_iterator begin() const
    { return reinterpret_cast!(const(QChar)*)(d.data()); }
    pragma(inline, true) const_iterator cbegin() const
    { return reinterpret_cast!(const(QChar)*)(d.data()); }
    pragma(inline, true) const_iterator constBegin() const
    { return reinterpret_cast!(const(QChar)*)(d.data()); }
    pragma(inline, true) iterator end()
    { detach(); return reinterpret_cast!(QChar*)(d.data() + d.size); }
    pragma(inline, true) const_iterator end() const
    { return reinterpret_cast!(const(QChar)*)(d.data() + d.size); }
    pragma(inline, true) const_iterator cend() const
    { return reinterpret_cast!(const(QChar)*)(d.data() + d.size); }
    pragma(inline, true) const_iterator constEnd() const
    { return reinterpret_cast!(const(QChar)*)(d.data() + d.size); }
    /+ reverse_iterator rbegin() { return reverse_iterator(end()); } +/
    /+ reverse_iterator rend() { return reverse_iterator(begin()); } +/
    /+ const_reverse_iterator rbegin() const { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator rend() const { return const_reverse_iterator(begin()); } +/
    /+ const_reverse_iterator crbegin() const { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator crend() const { return const_reverse_iterator(begin()); } +/

    // STL compatibility
    alias size_type = qsizetype;
    alias difference_type = qptrdiff;
    /+ typedef const QChar & const_reference; +/
    /+ typedef QChar & reference; +/
    alias pointer = QChar*;
    alias const_pointer = const(QChar)*;
    alias value_type = QChar;
    pragma(inline, true) void push_back(QChar c) { append(c); }
    pragma(inline, true) void push_back(ref const(QString) s) { append(s); }
    pragma(inline, true) void push_front(QChar c) { prepend(c); }
    pragma(inline, true) void push_front(ref const(QString) s) { prepend(s); }
    void shrink_to_fit() { squeeze(); }
    iterator erase(const_iterator first, const_iterator last);

    /+ static inline QString fromStdString(const std::string &s); +/
    /+ inline std::string toStdString() const; +/
    /+ static inline QString fromStdWString(const std::wstring &s); +/
    /+ inline std::wstring toStdWString() const; +/

    /+ static inline QString fromStdU16String(const std::u16string &s); +/
    /+ inline std::u16string toStdU16String() const; +/
    /+ static inline QString fromStdU32String(const std::u32string &s); +/
    /+ inline std::u32string toStdU32String() const; +/

    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ static QString fromCFString(CFStringRef string); +/
        /+ CFStringRef toCFString() const Q_DECL_CF_RETURNS_RETAINED; +/
        /+ static QString fromNSString(const NSString *string); +/
        /+ NSString *toNSString() const Q_DECL_NS_RETURNS_AUTORELEASED; +/
    }

    pragma(inline, true) bool isNull() const { return d.isNull(); }


    //bool isSimpleText() const;
    bool isRightToLeft() const;
    /+ [[nodiscard]] +/ bool isValidUtf16() const/+ noexcept+/
    { return QStringView(this).isValidUtf16(); }

    this(qsizetype size, /+ Qt:: +/qt.core.namespace.Initialization);
    /+ explicit QString(DataPointer &&dd) : d(std::move(dd)) {} +/

    extern(D) QString opBinary(string op)(const ref QString s2) const if (op == "~")
    {
        QString t = *cast(QString*)&this; t ~= s2; return t;
    }
    extern(D) QString opBinary(string op)(const QString s2) const if (op == "~")
    {
        QString t = *cast(QString*)&this; t ~= s2; return t;
    }
    extern(D) QString opBinary(string op)(const char *s2) const if (op == "~")
    {
        QString t = *cast(QString*)&this; auto tmp = QString.fromUtf8(s2, -1); t ~= tmp; return t;
    }
    extern(D) QString opBinaryRight(string op)(const char *s1) const if (op == "~")
    {
        QString t = QString.fromUtf8(s1, -1); t ~= this; return t;
    }

    pragma(inline, true) bool opEquals(QStringView rhs)/+ noexcept+/ {
        import qt.core.stringalgorithms;
        return this.size() == rhs.size() && /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(QStringView(this), rhs) == 0;
    }

    pragma(inline, true) bool opEquals(QLatin1String rhs)/+ noexcept+/ {
        import qt.core.stringalgorithms;
        return this.size() == rhs.size() && /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(QStringView(this), rhs) == 0;
    }


private:
/+ #if defined(QT_NO_CAST_FROM_ASCII) +/
    extern(D) ref QString opOpAssign(string op)(const(char)* s) if (op == "~");
    extern(D) ref QString opOpAssign(string op)(ref const(QByteArray) s) if (op == "~");
    //this(const(char)* ch);
    //this(ref const(QByteArray) a);
    /+ref QString operator =(const(char)*  ch);+/
    /+ref QString operator =(ref const(QByteArray) a);+/
/+ #endif +/

    DataPointer d;
    mixin(mangleWindows("?_empty@QString@@0_SB", exportOnWindows ~ q{
    extern static __gshared const(wchar) _empty;
    }));

    void reallocData(qsizetype alloc, QArrayData.AllocationOption option);
    void reallocGrowData(qsizetype n);
    static int compare_helper(const(QChar)* data1, qsizetype length1,
                                  const(QChar)* data2, qsizetype length2,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
    static int compare_helper(const(QChar)* data1, qsizetype length1,
                                  const(char)* data2, qsizetype length2,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
    static int localeAwareCompare_helper(const(QChar)* data1, qsizetype length1,
                                             const(QChar)* data2, qsizetype length2);
    static QString toLower_helper(ref const(QString) str);
    static QString toLower_helper(ref QString str);
    static QString toUpper_helper(ref const(QString) str);
    static QString toUpper_helper(ref QString str);
    static QString toCaseFolded_helper(ref const(QString) str);
    static QString toCaseFolded_helper(ref QString str);
    static QString trimmed_helper(ref const(QString) str);
    static QString trimmed_helper(ref QString str);
    static QString simplified_helper(ref const(QString) str);
    static QString simplified_helper(ref QString str);
    static QByteArray toLatin1_helper(ref const(QString) );
    static QByteArray toLatin1_helper_inplace(ref QString );
    static QByteArray toUtf8_helper(ref const(QString) );
    static QByteArray toLocal8Bit_helper(const(QChar)* data, qsizetype size);
    static qsizetype toUcs4_helper(const(ushort)* uc, qsizetype length, uint* out_); // ### Qt 7 char16_t
    version (Windows)
    {
    pragma(mangle, "?toIntegral_helper@QString@@CA_JVQStringView@@PEA_NH@Z")
    package static qlonglong toIntegral_helper(QStringView string, bool* ok, int base);
    pragma(mangle, "?toIntegral_helper@QString@@CA_KVQStringView@@PEA_NI@Z")
    package static qulonglong toIntegral_helper(QStringView string, bool* ok, uint base);
    }
    else
    {
    package static qlonglong toIntegral_helper(QStringView string, bool* ok, int base);
    package static qulonglong toIntegral_helper(QStringView string, bool* ok, uint base);
    }
    /+ void replace_helper(size_t *indices, qsizetype nIndices, qsizetype blen, const QChar *after, qsizetype alen); +/
    /+ friend class QStringView; +/
    /+ friend class QByteArray; +/
    /+ friend struct QAbstractConcatenable; +/

    /+ template <typename T> +/ 
        static T toIntegral_helper(T)(QStringView string, bool* ok, int base)
    {
        import std.traits;
        static if (isUnsigned!T)
        {
            alias Int64 = qulonglong;
            alias Int32 = uint;
        }
        else
        {
            alias Int64 = qlonglong;
            alias Int32 = int;
        }

        // we select the right overload by casting base to int or uint
        Int64 val = toIntegral_helper(string, ok, Int32(base));
        if (cast(T)(val) != val) {
            if (ok)
                *ok = false;
            val = 0;
        }
        return cast(T)(val);
    }

public:
    pragma(inline, true) ref DataPointer data_ptr() return { return d; }
    pragma(inline, true) ref const(DataPointer) data_ptr() const return { return d; }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

//
// QLatin1StringView inline members that require QString:
//

//
// QStringView inline members that require QString:
//

//
// QUtf8StringView inline members that require QString:
//

//
// QAnyStringView inline members that require QString:
//

/+ QT_WARNING_PUSH
QT_WARNING_DISABLE_MSVC(4127)   // "conditional expression is constant"
QT_WARNING_DISABLE_INTEL(111)   // "statement is unreachable"

QT_WARNING_POP

#if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
inline bool QString::operator==(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) == 0; }
inline bool QString::operator!=(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) != 0; }
inline bool QString::operator<(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) < 0; }
inline bool QString::operator>(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) > 0; }
inline bool QString::operator<=(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) <= 0; }
inline bool QString::operator>=(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) >= 0; }

QT_ASCII_CAST_WARN inline bool QLatin1StringView::operator==(const char *s) const
{ return QString::fromUtf8(s) == *this; }
QT_ASCII_CAST_WARN inline bool QLatin1StringView::operator!=(const char *s) const
{ return QString::fromUtf8(s) != *this; }
QT_ASCII_CAST_WARN inline bool QLatin1StringView::operator<(const char *s) const
{ return QString::fromUtf8(s) > *this; }
QT_ASCII_CAST_WARN inline bool QLatin1StringView::operator>(const char *s) const
{ return QString::fromUtf8(s) < *this; }
QT_ASCII_CAST_WARN inline bool QLatin1StringView::operator<=(const char *s) const
{ return QString::fromUtf8(s) >= *this; }
QT_ASCII_CAST_WARN inline bool QLatin1StringView::operator>=(const char *s) const
{ return QString::fromUtf8(s) <= *this; }

QT_ASCII_CAST_WARN inline bool QLatin1StringView::operator==(const QByteArray &s) const
{ return QString::fromUtf8(s) == *this; }
QT_ASCII_CAST_WARN inline bool QLatin1StringView::operator!=(const QByteArray &s) const
{ return QString::fromUtf8(s) != *this; }
QT_ASCII_CAST_WARN inline bool QLatin1StringView::operator<(const QByteArray &s) const
{ return QString::fromUtf8(s) > *this; }
QT_ASCII_CAST_WARN inline bool QLatin1StringView::operator>(const QByteArray &s) const
{ return QString::fromUtf8(s) < *this; }
QT_ASCII_CAST_WARN inline bool QLatin1StringView::operator<=(const QByteArray &s) const
{ return QString::fromUtf8(s) >= *this; }
QT_ASCII_CAST_WARN inline bool QLatin1StringView::operator>=(const QByteArray &s) const
{ return QString::fromUtf8(s) <= *this; }

inline int QLatin1StringView::compare_helper(const QLatin1StringView &s1, const char *s2)
{
    return QString::compare(s1, QString::fromUtf8(s2));
}

QT_ASCII_CAST_WARN inline bool QString::operator==(const QByteArray &s) const
{ return QString::compare_helper(constData(), size(), s.constData(), s.size()) == 0; }
QT_ASCII_CAST_WARN inline bool QString::operator!=(const QByteArray &s) const
{ return QString::compare_helper(constData(), size(), s.constData(), s.size()) != 0; }
QT_ASCII_CAST_WARN inline bool QString::operator<(const QByteArray &s) const
{ return QString::compare_helper(constData(), size(), s.constData(), s.size()) < 0; }
QT_ASCII_CAST_WARN inline bool QString::operator>(const QByteArray &s) const
{ return QString::compare_helper(constData(), size(), s.constData(), s.size()) > 0; }
QT_ASCII_CAST_WARN inline bool QString::operator<=(const QByteArray &s) const
{ return QString::compare_helper(constData(), size(), s.constData(), s.size()) <= 0; }
QT_ASCII_CAST_WARN inline bool QString::operator>=(const QByteArray &s) const
{ return QString::compare_helper(constData(), size(), s.constData(), s.size()) >= 0; }

inline bool QByteArray::operator==(const QString &s) const
{ return QString::compare_helper(s.constData(), s.size(), constData(), size()) == 0; }
inline bool QByteArray::operator!=(const QString &s) const
{ return QString::compare_helper(s.constData(), s.size(), constData(), size()) != 0; }
inline bool QByteArray::operator<(const QString &s) const
{ return QString::compare_helper(s.constData(), s.size(), constData(), size()) > 0; }
inline bool QByteArray::operator>(const QString &s) const
{ return QString::compare_helper(s.constData(), s.size(), constData(), size()) < 0; }
inline bool QByteArray::operator<=(const QString &s) const
{ return QString::compare_helper(s.constData(), s.size(), constData(), size()) >= 0; }
inline bool QByteArray::operator>=(const QString &s) const
{ return QString::compare_helper(s.constData(), s.size(), constData(), size()) <= 0; }
#endif +/ // !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)

version (QT_USE_FAST_OPERATOR_PLUS) {} else
version (QT_USE_QSTRINGBUILDER) {} else
{
/+pragma(inline, true) const(QString) operator +(ref const(QString) s1, ref const(QString) s2)
{ auto t = QString(s1); t ~= s2; return t; }+/
/+pragma(inline, true) const(QString) operator +(ref const(QString) s1, QChar s2)
{ auto t = QString(s1); t ~= s2; return t; }+/
/+pragma(inline, true) const(QString) operator +(QChar s1, ref const(QString) s2)
{ auto t = QString(s1); t ~= s2; return t; }+/
/+ #  if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
QT_ASCII_CAST_WARN inline const QString operator+(const QString &s1, const char *s2)
{ QString t(s1); t += QString::fromUtf8(s2); return t; }
QT_ASCII_CAST_WARN inline const QString operator+(const char *s1, const QString &s2)
{ QString t = QString::fromUtf8(s1); t += s2; return t; }
QT_ASCII_CAST_WARN inline const QString operator+(const QByteArray &ba, const QString &s)
{ QString t = QString::fromUtf8(ba); t += s; return t; }
QT_ASCII_CAST_WARN inline const QString operator+(const QString &s, const QByteArray &ba)
{ QString t(s); t += QString::fromUtf8(ba); return t; }
#  endif +/ // QT_NO_CAST_FROM_ASCII
}

/+ inline std::string QString::toStdString() const
{ return toUtf8().toStdString(); }

inline QString QString::fromStdString(const std::string &s)
{ return fromUtf8(s.data(), qsizetype(s.size())); }

inline std::wstring QString::toStdWString() const
{
    std::wstring str;
    str.resize(size());
    str.resize(toWCharArray(str.data()));
    return str;
}

inline QString QString::fromStdWString(const std::wstring &s)
{ return fromWCharArray(s.data(), qsizetype(s.size())); }

inline QString QString::fromStdU16String(const std::u16string &s)
{ return fromUtf16(s.data(), qsizetype(s.size())); }

inline std::u16string QString::toStdU16String() const
{ return std::u16string(reinterpret_cast<const char16_t*>(data()), size()); }

inline QString QString::fromStdU32String(const std::u32string &s)
{ return fromUcs4(s.data(), qsizetype(s.size())); }

inline std::u32string QString::toStdU32String() const
{
    std::u32string u32str(size(), char32_t(0));
    qsizetype len = toUcs4_helper(reinterpret_cast<const ushort *>(constData()),
                                  size(), reinterpret_cast<uint*>(&u32str[0]));
    u32str.resize(len);
    return u32str;
}

#if !defined(QT_NO_DATASTREAM) || defined(QT_BOOTSTRAPPED)
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QString &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QString &);
#endif +/
/+pragma(inline, true) QFlags!(QString.SectionFlags.enum_type) operator |(QString.SectionFlags.enum_type f1, QString.SectionFlags.enum_type f2)/+noexcept+/{return QFlags!(QString.SectionFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QString.SectionFlags.enum_type) operator |(QString.SectionFlags.enum_type f1, QFlags!(QString.SectionFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QString.SectionFlags.enum_type) operator &(QString.SectionFlags.enum_type f1, QString.SectionFlags.enum_type f2)/+noexcept+/{return QFlags!(QString.SectionFlags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QString.SectionFlags.enum_type) operator &(QString.SectionFlags.enum_type f1, QFlags!(QString.SectionFlags.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QString.SectionFlags.enum_type) operator ^(QString.SectionFlags.enum_type f1, QString.SectionFlags.enum_type f2)/+noexcept+/{return QFlags!(QString.SectionFlags.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QString.SectionFlags.enum_type) operator ^(QString.SectionFlags.enum_type f1, QFlags!(QString.SectionFlags.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QString.SectionFlags.enum_type f1, QString.SectionFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QString.SectionFlags.enum_type f1, QFlags!(QString.SectionFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QString.SectionFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QString.SectionFlags.enum_type f1, QString.SectionFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QString.SectionFlags.enum_type f1, QFlags!(QString.SectionFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QString.SectionFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QString.SectionFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QString.SectionFlags.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QString.SectionFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QString.SectionFlags.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QString.SectionFlags operator ~(QString.SectionFlags.enum_type e)/+noexcept+/{return~QString.SectionFlags(e);}+/
/+pragma(inline, true) void operator |(QString.SectionFlags.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QString.SectionFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_SHARED(QString)
Q_DECLARE_OPERATORS_FOR_FLAGS(QString::SectionFlags) +/
extern(C++, "QtPrivate") {
// used by qPrintable() and qUtf8Printable() macros
// pragma(inline, true) ref const(QString) asString(ref const(QString) s)    { return s; }
/+ inline QString &&asString(QString &&s)              { return std::move(s); } +/
}

//
// QStringView::arg() implementation
//

extern(C++, "QtPrivate") {

struct ArgBase {
    enum Tag : uchar { L1, U8, U16 }Tag tag;
}

/+struct QStringViewArg {
    ArgBase base0;
    alias base0 this;
    QStringView string;
    /+ QStringViewArg() = default; +/
    /+ explicit +/this(QStringView v)/+ noexcept+/
    {
        this.base0 = ArgBase(ArgBase(Tag.U16));
        this.string = typeof(this.string)(QStringView(v));
    }
}+/

/+struct QLatin1StringArg {
    ArgBase base0;
    alias base0 this;
    QLatin1StringView string;
    /+ QLatin1StringArg() = default; +/
    /+ explicit +/this(QLatin1StringView v)/+ noexcept+/
    {
        this.base0 = ArgBase(ArgBase(Tag.L1));
        this.string = typeof(this.string)({v});
    }
}+/

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ QString argToQString(QStringView pattern, size_t n, const(ArgBase)** args);
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ QString argToQString(QLatin1StringView pattern, size_t n, const(ArgBase)** args);

/+
/+ [[nodiscard]] +/ /+ Q_ALWAYS_INLINE +/ pragma(inline, true) QString argToQStringDispatch(StringView, Args)(StringView pattern, ref const(Args) args)
{
    /+ const(ArgBase)*[0]  +/ auto argBases = mixin(buildStaticArray!(q{const(ArgBase)*}, q{&args..., /* avoid zero-sized array */ null}));
    return /+ QtPrivate:: +/argToQString(pattern, sizeof...(Args), argBases.ptr);
}+/

/+
          pragma(inline, true) QStringViewArg   qStringLikeToArg(ref const(QString) s)/+ noexcept+/ { return QStringViewArg(qToStringViewIgnoringNull(s)); }
pragma(inline, true) QStringViewArg   qStringLikeToArg(QStringView s)/+ noexcept+/ { return QStringViewArg(s); }
          pragma(inline, true) QStringViewArg   qStringLikeToArg(ref const(QChar) c)/+ noexcept+/ { return QStringViewArg(QStringView(&c, 1)); }
pragma(inline, true) QLatin1StringArg qStringLikeToArg(QLatin1StringView s)/+ noexcept+/ { return QLatin1StringArg(s); }
+/
} // namespace QtPrivate

/+ template <typename...Args>
Q_ALWAYS_INLINE
QString QStringView::arg(Args &&...args) const
{
    return QtPrivate::argToQStringDispatch(*this, QtPrivate::qStringLikeToArg(args)...);
}

template <typename...Args>
Q_ALWAYS_INLINE
QString QLatin1StringView::arg(Args &&...args) const
{
    return QtPrivate::argToQStringDispatch(*this, QtPrivate::qStringLikeToArg(args)...);
} +/

qsizetype erase(T)(ref QString s, ref const(T) t)
{
    import qt.core.containertools_impl;

    return /+ QtPrivate:: +/qt.core.containertools_impl.sequential_erase(s, t);
}

qsizetype erase_if(Predicate)(ref QString s, Predicate pred)
{
    import qt.core.containertools_impl;

    return /+ QtPrivate:: +/qt.core.containertools_impl.sequential_erase_if(s, pred);
}

/+ extern(C++, "Qt") {
/+ inline +/ 
inlineextern(C++, "Literals") {
/+ inline namespace StringLiterals {

} +/ // StringLiterals
} // Literals
} +/ // Qt

/+ inline namespace QtLiterals {
#if QT_DEPRECATED_SINCE(6, 8)

#endif // QT_DEPRECATED_SINCE(6, 8)
} // QtLiterals


#if defined(QT_USE_FAST_OPERATOR_PLUS) || defined(QT_USE_QSTRINGBUILDER)
#endif

#ifdef Q_L1S_VIEW_IS_PRIMARY
#    undef Q_L1S_VIEW_IS_PRIMARY
#endif +/
/// Binding for C++ class [QLatin1StringView](https://doc.qt.io/qt-6/qlatin1stringview.html).
alias QLatin1StringView = QLatin1String;

