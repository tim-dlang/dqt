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
module qt.core.stringview;
extern(C++):

import core.stdc.config;
import qt.config;
import qt.core.bytearray;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.qchar;
import qt.core.regularexpression;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.vector;
import qt.helpers;

/+ #ifndef QT_STRINGVIEW_LEVEL
#  define QT_STRINGVIEW_LEVEL 1
#endif


class QString;
class QStringRef;
class QRegularExpression;

namespace QtPrivate {
template <typename Char>
struct IsCompatibleCharTypeHelper
    : std::integral_constant<bool,
                             std::is_same<Char, QChar>::value ||
                             std::is_same<Char, ushort>::value ||
                             std::is_same<Char, char16_t>::value ||
                             (std::is_same<Char, wchar_t>::value && sizeof(wchar_t) == sizeof(QChar))> {};
template <typename Char>
struct IsCompatibleCharType
    : IsCompatibleCharTypeHelper<typename std::remove_cv<typename std::remove_reference<Char>::type>::type> {};

template <typename Array>
struct IsCompatibleArrayHelper : std::false_type {};
template <typename Char, size_t N>
struct IsCompatibleArrayHelper<Char[N]>
    : IsCompatibleCharType<Char> {};
template <typename Array>
struct IsCompatibleArray
    : IsCompatibleArrayHelper<typename std::remove_cv<typename std::remove_reference<Array>::type>::type> {};

template <typename Pointer>
struct IsCompatiblePointerHelper : std::false_type {};
template <typename Char>
struct IsCompatiblePointerHelper<Char*>
    : IsCompatibleCharType<Char> {};
template <typename Pointer>
struct IsCompatiblePointer
    : IsCompatiblePointerHelper<typename std::remove_cv<typename std::remove_reference<Pointer>::type>::type> {};

template <typename T>
struct IsCompatibleStdBasicStringHelper : std::false_type {};
template <typename Char, typename...Args>
struct IsCompatibleStdBasicStringHelper<std::basic_string<Char, Args...> >
    : IsCompatibleCharType<Char> {};

template <typename T>
struct IsCompatibleStdBasicString
    : IsCompatibleStdBasicStringHelper<
        typename std::remove_cv<typename std::remove_reference<T>::type>::type
      > {};

} +/ // namespace QtPrivate

@Q_PRIMITIVE_TYPE extern(C++, class) struct QStringView
{
    static import qt.core.stringalgorithms;
public:
    alias storage_type = wchar;
    alias value_type = const(QChar);
    alias difference_type = /+ std:: +/ptrdiff_t;
    alias size_type = qsizetype;
    /+ typedef value_type &reference; +/
    /+ typedef value_type &const_reference; +/
    alias pointer = value_type*;
    alias const_pointer = value_type*;

    alias iterator = pointer;
    alias const_iterator = const_pointer;
    /+ typedef std::reverse_iterator<iterator> reverse_iterator; +/
    /+ typedef std::reverse_iterator<const_iterator> const_reverse_iterator; +/

private:
    /+ template <typename Char> +/
    /+ using if_compatible_char = typename std::enable_if<QtPrivate::IsCompatibleCharType<Char>::value, bool>::type; +/

    /+ template <typename Array> +/
    /+ using if_compatible_array = typename std::enable_if<QtPrivate::IsCompatibleArray<Array>::value, bool>::type; +/

    /+ template <typename Pointer> +/
    /+ using if_compatible_pointer = typename std::enable_if<QtPrivate::IsCompatiblePointer<Pointer>::value, bool>::type; +/

    /+ template <typename T> +/
    /+ using if_compatible_string = typename std::enable_if<QtPrivate::IsCompatibleStdBasicString<T>::value, bool>::type; +/

    /+ template <typename T> +/
    /+ using if_compatible_qstring_like = typename std::enable_if<std::is_same<T, QString>::value || std::is_same<T, QStringRef>::value, bool>::type; +/

    /+ template <typename Char, size_t N> +/
    /+ static qsizetype lengthHelperArray(const Char (&)[N]) noexcept
    {
        return qsizetype(N - 1);
    } +/

    /+ template <typename Char> +/
    /+ static qsizetype lengthHelperPointer(const Char *str) noexcept
    {
#if defined(Q_CC_GNU) && !defined(Q_CC_CLANG) && !defined(Q_CC_INTEL)
        if (__builtin_constant_p(*str)) {
            qsizetype result = 0;
            while (*str++)
                ++result;
            return result;
        }
#endif
        return QtPrivate::qustrlen(reinterpret_cast<const ushort *>(str));
    } +/
    static qsizetype lengthHelperPointer(const(QChar)* str)/+ noexcept+/
    {
        import qt.core.stringalgorithms;

        return /+ QtPrivate:: +/qt.core.stringalgorithms.qustrlen(reinterpret_cast!(const(ushort)*)(str));
    }

    static const(storage_type) *castHelper(Char)(const Char *str) /*noexcept*/
    { return reinterpret_cast!(const storage_type*)(str); }
    static const(storage_type)* castHelper(const(storage_type)* str)/+ noexcept+/
    { return str; }

public:
    /+this()/+ noexcept+/
    {
        this.m_size = 0;
        this.m_data = null;
    }+/
    this(typeof(null))/+ noexcept+/
    {
        //this();
    }

    /+ template <typename Char, if_compatible_char<Char> = true> +/
    this(Char)(const Char *str, qsizetype len) if(is(Char == QChar) || is(Char == ushort) || is(Char == wchar))
    {
        assert(len >= 0);
        assert(str || !len);
        m_size = len;
        m_data = castHelper(str);
    }

    /+ template <typename Char, if_compatible_char<Char> = true> +/
    /+ QStringView(const Char *f, const Char *l)
        : QStringView(f, l - f) {} +/

/+ #ifdef Q_CLANG_QDOC
    template <typename Char, size_t N>
    QStringView(const Char (&array)[N]) noexcept;

    template <typename Char>
    QStringView(const Char *str) noexcept;
#else
#if QT_DEPRECATED_SINCE(5, 14) +/
    /+ template <typename Array, if_compatible_array<Array> = true> +/
    /+ QT_DEPRECATED_VERSION_X_5_14(R"(Use u"~~~" or QStringView(u"~~~") instead of QStringViewLiteral("~~~"))")
    QStringView(const Array &str, QtPrivate::Deprecated_t) noexcept
        : QStringView(str, lengthHelperArray(str)) {} +/
/+ #endif // QT_DEPRECATED_SINCE

    template <typename Array, if_compatible_array<Array> = true>
    QStringView(const Array &str) noexcept
        : QStringView(str, lengthHelperArray(str)) {}

    template <typename Pointer, if_compatible_pointer<Pointer> = true>
    QStringView(const Pointer &str) noexcept
        : QStringView(str, str ? lengthHelperPointer(str) : 0) {}
#endif

#ifdef Q_CLANG_QDOC
    QStringView(const QString &str) noexcept;
    QStringView(const QStringRef &str) noexcept;
#else +/
    /+ template <typename String, if_compatible_qstring_like<String> = true> +/
    /+ QStringView(const String &str) noexcept
        : QStringView(str.isNull() ? nullptr : str.data(), qsizetype(str.size())) {} +/
    this(String)(ref const String str) /*nothrow*/
    {
        this(str.isNull() ? null : str.data(), qsizetype(str.size()));
    }
/+ #endif +/

    /+ template <typename StdBasicString, if_compatible_string<StdBasicString> = true> +/
    /+ QStringView(const StdBasicString &str) noexcept
        : QStringView(str.data(), qsizetype(str.size())) {} +/

    //
    // QStringView inline members that require QString:
    //
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString toString() const
    { return (){ (mixin(Q_ASSERT(q{QStringView.size() == QStringView.length()})));
    return QString(data(), length());
    }(); } // defined in qstring.h

    /+ Q_REQUIRED_RESULT +/ qsizetype size() const/+ noexcept+/ { return m_size; }
    /+ Q_REQUIRED_RESULT +/ const_pointer data() const/+ noexcept+/ { return reinterpret_cast!(const_pointer)(m_data); }
    /+ Q_REQUIRED_RESULT +/ const(storage_type)* utf16() const/+ noexcept+/ { return m_data; }

    /+ Q_REQUIRED_RESULT +/ QChar opIndex(qsizetype n) const
    { return (){(){ (mixin(Q_ASSERT(q{n >= 0})));
return /+ Q_ASSERT(n < size()) +/ mixin(Q_ASSERT(q{n < QStringView.size()}));
}();
return QChar(m_data[n]);
}(); }

    //
    // QString API
    //

    /+ template <typename...Args> +/
    /+ Q_REQUIRED_RESULT inline QString arg(Args &&...args) const; +/ // defined in qstring.h

    /+ Q_REQUIRED_RESULT +/ QByteArray toLatin1() const {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.convertToLatin1(this);
    }
    /+ Q_REQUIRED_RESULT +/ QByteArray toUtf8() const {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.convertToUtf8(this);
    }
    /+ Q_REQUIRED_RESULT +/ QByteArray toLocal8Bit() const {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.convertToLocal8Bit(this);
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QVector!(uint) toUcs4() const {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.convertToUcs4(this);
    } // defined in qvector.h

    /+ Q_REQUIRED_RESULT +/ QChar at(qsizetype n) const { return (this)[n]; }

    /+ Q_REQUIRED_RESULT +/ QStringView mid(qsizetype pos) const
    {
        return QStringView(m_data + qBound(qsizetype(0), pos, m_size), m_size - qBound(qsizetype(0), pos, m_size));
    }
    /+ Q_REQUIRED_RESULT +/ QStringView mid(qsizetype pos, qsizetype n) const
    {
        return QStringView(m_data + qBound(qsizetype(0), pos, m_size), qBound(qsizetype(0), pos + n, m_size) - qBound(qsizetype(0), pos, m_size));
    }
    /+ Q_REQUIRED_RESULT +/ QStringView left(qsizetype n) const
    {
        return QStringView(m_data, (size_t(n) > size_t(m_size) ? m_size : n));
    }
    /+ Q_REQUIRED_RESULT +/ QStringView right(qsizetype n) const
    {
        return QStringView(m_data + m_size - (size_t(n) > size_t(m_size) ? m_size : n), (size_t(n) > size_t(m_size) ? m_size : n));
    }
    /+ Q_REQUIRED_RESULT +/ QStringView chopped(qsizetype n) const
    { return (){(){ (mixin(Q_ASSERT(q{n >= 0})));
return /+ Q_ASSERT(n <= size()) +/ mixin(Q_ASSERT(q{n <= QStringView.size()}));
}();
return QStringView(m_data, m_size - n);
}(); }

    void truncate(qsizetype n)
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QStringView.size()}))); m_size = n; }
    void chop(qsizetype n)
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QStringView.size()}))); m_size -= n; }

    /+ Q_REQUIRED_RESULT +/ QStringView trimmed() const/+ noexcept+/ {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.trimmed(this);
    }

    /+ Q_REQUIRED_RESULT +/ int compare(QStringView other, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(this, other, cs);
    }
    //
    // QStringView members that require QLatin1String:
    //
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) int compare(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(this, s, cs);
    }
    /+ Q_REQUIRED_RESULT +/ int compare(QChar c) const/+ noexcept+/
    { return size() >= 1 ? compare_single_char_helper(*utf16() - c.unicode()) : -1; }
    /+ Q_REQUIRED_RESULT +/ int compare(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(this, QStringView(&c, 1), cs);
    }

    /+ Q_REQUIRED_RESULT +/ bool startsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(this, s, cs);
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool startsWith(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(this, s, cs);
    }
    /+ Q_REQUIRED_RESULT +/ bool startsWith(QChar c) const/+ noexcept+/
    { return !empty() && front() == c; }
    /+ Q_REQUIRED_RESULT +/ bool startsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(this, QStringView(&c, 1), cs);
    }

    /+ Q_REQUIRED_RESULT +/ bool endsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(this, s, cs);
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool endsWith(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(this, s, cs);
    }
    /+ Q_REQUIRED_RESULT +/ bool endsWith(QChar c) const/+ noexcept+/
    { return !empty() && back() == c; }
    /+ Q_REQUIRED_RESULT +/ bool endsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(this, QStringView(&c, 1), cs);
    }

    /+ Q_REQUIRED_RESULT +/ qsizetype indexOf(QChar c, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.findString(this, from, QStringView(&c, 1), cs);
    }
    /+ Q_REQUIRED_RESULT +/ qsizetype indexOf(QStringView s, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.findString(this, from, s, cs);
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) qsizetype indexOf(QLatin1String s, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.findString(this, from, s, cs);
    }

    /+ Q_REQUIRED_RESULT +/ bool contains(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(QStringView(&c, 1), 0, cs) != qsizetype(-1); }
    /+ Q_REQUIRED_RESULT +/ bool contains(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(s, 0, cs) != qsizetype(-1); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool contains(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(s, 0, cs) != qsizetype(-1); }

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) qsizetype count(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return toString().count(c, cs); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) qsizetype count(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { auto tmp = s.toString(); return toString().count(tmp, cs); }

    /+ Q_REQUIRED_RESULT +/ qsizetype lastIndexOf(QChar c, qsizetype from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, from, QStringView(&c, 1), cs);
    }
    /+ Q_REQUIRED_RESULT +/ qsizetype lastIndexOf(QStringView s, qsizetype from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, from, s, cs);
    }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) qsizetype lastIndexOf(QLatin1String s, qsizetype from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, from, s, cs);
    }

    /+ Q_REQUIRED_RESULT +/ bool isRightToLeft() const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.isRightToLeft(this);
    }
    /+ Q_REQUIRED_RESULT +/ bool isValidUtf16() const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.isValidUtf16(this);
    }

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) short toShort(bool* ok = null, int base = 10) const
    { return toString().toShort(ok, base); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) ushort toUShort(bool* ok = null, int base = 10) const
    { return toString().toUShort(ok, base); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) int toInt(bool* ok = null, int base = 10) const
    { return toString().toInt(ok, base); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) uint toUInt(bool* ok = null, int base = 10) const
    { return toString().toUInt(ok, base); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) cpp_long toLong(bool* ok = null, int base = 10) const
    { return toString().toLong(ok, base); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) cpp_ulong toULong(bool* ok = null, int base = 10) const
    { return toString().toULong(ok, base); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) qlonglong toLongLong(bool* ok = null, int base = 10) const
    { return toString().toLongLong(ok, base); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) qulonglong toULongLong(bool* ok = null, int base = 10) const
    { return toString().toULongLong(ok, base); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) float toFloat(bool* ok = null) const
    { return toString().toFloat(ok); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) double toDouble(bool* ok = null) const
    { return toString().toDouble(ok); }

/+    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) int toWCharArray(wchar_t* array) const
    {
        import core.stdc.string;

        if (wchar_t.sizeof == QChar.sizeof) {
            if (auto src = data())
                memcpy(array, cast(const(void)*)(src), QChar.sizeof * size());
            return cast(int)(size());     // ### q6sizetype
        } else {
            return QString.toUcs4_helper(reinterpret_cast!(const(ushort)*)(data()), int(size()),
                                          reinterpret_cast!(uint*)(array));
        }
    } // defined in qstring.h +/

    // those methods need to be here, so they can be implemented inline
    /+ Q_REQUIRED_RESULT +/ 
/+        pragma(inline, true) QList!(QStringView) split(QStringView sep,
                                 /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts,
                                 /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    {
        (mixin(Q_ASSERT(q{cast(int)(QStringView.m_size) == QStringView.m_size})));
        QString s = QString.fromRawData(data(), cast(int)(m_size));
        const split = s.splitRef(sep.toString(), behavior, cs);
        QList!QStringView result;
        foreach (const ref QStringRef r; split)
            result.append(QStringView(m_data + r.position(), r.size()));
        return result;
    }+/
    /+ Q_REQUIRED_RESULT +/ 
/+        pragma(inline, true) QList!(QStringView) split(QChar sep, /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts,
                                 /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    {
        (mixin(Q_ASSERT(q{int(QStringView.m_size) == QStringView.m_size})));
        QString s = QString.fromRawData(data(), int(m_size));
        const split = s.splitRef(sep, behavior, cs);
        QList!QStringView result;
        foreach (const ref QStringRef r; split)
            result.append(QStringView(m_data + r.position(), r.size()));
        return result;
    }+/

/+ #if QT_CONFIG(regularexpression) +/
    // implementation here, so we have all required classes
    /+ Q_REQUIRED_RESULT +/ 
/+        pragma(inline, true) QList!(QStringView) split(ref const(QRegularExpression) sep, /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts) const
    {
        (mixin(Q_ASSERT(q{int(QStringView.m_size) == QStringView.m_size})));
        QString s = QString.fromRawData(data(), int(m_size));
        const split = s.splitRef(sep, behavior);
        QList!QStringView result;
        result.reserve(split.size());
        foreach(const ref QStringRef r; split)
            result.append(r);
        return result;
    }+/
/+ #endif +/

    //
    // STL compatibility API:
    //
    /+ Q_REQUIRED_RESULT +/ const_iterator begin()   const/+ noexcept+/ { return data(); }
    /+ Q_REQUIRED_RESULT +/ const_iterator end()     const/+ noexcept+/ { return data() + size(); }
    /+ Q_REQUIRED_RESULT +/ const_iterator cbegin()  const/+ noexcept+/ { return begin(); }
    /+ Q_REQUIRED_RESULT +/ const_iterator cend()    const/+ noexcept+/ { return end(); }
    /+ Q_REQUIRED_RESULT const_reverse_iterator rbegin()  const noexcept { return const_reverse_iterator(end()); } +/
    /+ Q_REQUIRED_RESULT const_reverse_iterator rend()    const noexcept { return const_reverse_iterator(begin()); } +/
    /+ Q_REQUIRED_RESULT const_reverse_iterator crbegin() const noexcept { return rbegin(); } +/
    /+ Q_REQUIRED_RESULT const_reverse_iterator crend()   const noexcept { return rend(); } +/

    /+ Q_REQUIRED_RESULT +/ bool empty() const/+ noexcept+/ { return size() == 0; }
    /+ Q_REQUIRED_RESULT +/ QChar front() const { return (){ (mixin(Q_ASSERT(q{!QStringView.empty()})));
return QChar(m_data[0]);
}(); }
    /+ Q_REQUIRED_RESULT +/ QChar back()  const { return (){ (mixin(Q_ASSERT(q{!QStringView.empty()})));
return QChar(m_data[m_size - 1]);
}(); }

    //
    // Qt compatibility API:
    //
    /+ Q_REQUIRED_RESULT +/ bool isNull() const/+ noexcept+/ { return !m_data; }
    /+ Q_REQUIRED_RESULT +/ bool isEmpty() const/+ noexcept+/ { return empty(); }
    /+ Q_REQUIRED_RESULT +/ int length() const /* not nothrow! */
    { return (){ (mixin(Q_ASSERT(q{cast(int)(QStringView.size()) == QStringView.size()})));
return cast(int)(size());
}(); }
    /+ Q_REQUIRED_RESULT +/ QChar first() const { return front(); }
    /+ Q_REQUIRED_RESULT +/ QChar last()  const { return back(); }
private:
    qsizetype m_size = 0;
    const(storage_type)* m_data = null;

    int compare_single_char_helper(int diff) const/+ noexcept+/
    { return diff ? diff : size() > 1 ? 1 : 0; }
}
/+ Q_DECLARE_TYPEINFO(QStringView, Q_PRIMITIVE_TYPE); +/

pragma(inline, true) QStringView qToStringViewIgnoringNull(QStringLike, /+ typename std::enable_if<
    std::is_same<QStringLike, QString>::value || std::is_same<QStringLike, QStringRef>::value,
    bool>::type +/ /+ = true +/)(ref const(QStringLike) s)/+ noexcept+/
{ return QStringView(s.data(), s.size()); }

