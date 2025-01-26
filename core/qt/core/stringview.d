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
import qt.helpers;

/*
    Obsolete.
*/
/+ #ifndef QT_STRINGVIEW_LEVEL
#  define QT_STRINGVIEW_LEVEL 1
#endif

#if defined(Q_OS_DARWIN) || defined(Q_QDOC)
Q_FORWARD_DECLARE_CF_TYPE(CFString);
Q_FORWARD_DECLARE_OBJC_CLASS(NSString);
#endif +/



extern(C++, "QtPrivate") {
/+ template <typename Char>
struct IsCompatibleCharTypeHelper
    : std::integral_constant<bool,
                             std::is_same<Char, QChar>::value ||
                             std::is_same<Char, ushort>::value ||
                             std::is_same<Char, char16_t>::value ||
                             (std::is_same<Char, wchar_t>::value && sizeof(wchar_t) == sizeof(QChar))> {};
template <typename Char>
struct IsCompatibleCharType
    : IsCompatibleCharTypeHelper<typename std::remove_cv<typename std::remove_reference<Char>::type>::type> {};

template <typename Pointer>
struct IsCompatiblePointerHelper : std::false_type {};
template <typename Char>
struct IsCompatiblePointerHelper<Char*>
    : IsCompatibleCharType<Char> {};
template <typename Pointer>
struct IsCompatiblePointer
    : IsCompatiblePointerHelper<typename std::remove_cv<typename std::remove_reference<Pointer>::type>::type> {}; +/

struct IsContainerCompatibleWithQStringView(T, Enable) {
    /+ std:: +/false_type base0;
    alias base0 this;
}

/+ template <typename T>
struct IsContainerCompatibleWithQStringView<T, std::enable_if_t<std::conjunction_v<
            // lacking concepts and ranges, we accept any T whose std::data yields a suitable pointer ...
            IsCompatiblePointer<decltype( std::data(std::declval<const T &>()) )>,
            // ... and that has a suitable size ...
            std::is_convertible<decltype( std::size(std::declval<const T &>()) ), qsizetype>,
            // ... and it's a range as it defines an iterator-like API
            IsCompatibleCharType<typename std::iterator_traits<decltype( std::begin(std::declval<const T &>()) )>::value_type>,
            std::is_convertible<
                decltype( std::begin(std::declval<const T &>()) != std::end(std::declval<const T &>()) ),
                bool>,

            // These need to be treated specially due to the empty vs null distinction
            std::negation<std::is_same<std::decay_t<T>, QString>>,

            // Don't make an accidental copy constructor
            std::negation<std::is_same<std::decay_t<T>, QStringView>>
        >>> : std::true_type {}; +/

} // namespace QtPrivate

/// Binding for C++ class [QStringView](https://doc.qt.io/qt-6/qstringview.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct QStringView
{
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

    /+ template <typename Pointer> +/
    /+ using if_compatible_pointer = typename std::enable_if<QtPrivate::IsCompatiblePointer<Pointer>::value, bool>::type; +/

    /+ template <typename T> +/
    /+ using if_compatible_qstring_like = typename std::enable_if<std::is_same<T, QString>::value, bool>::type; +/

    /+ template <typename T> +/
    /+ using if_compatible_container = typename std::enable_if<QtPrivate::IsContainerCompatibleWithQStringView<T>::value, bool>::type; +/

    /+ template <typename Char> +/
    /+ static constexpr qsizetype lengthHelperPointer(const Char *str) noexcept
    {
#if defined(__cpp_lib_is_constant_evaluated)
        if (std::is_constant_evaluated())
            return std::char_traits<Char>::length(str);
#elif defined(Q_CC_GNU) && !defined(Q_CC_CLANG) && !defined(Q_CC_INTEL)
        if (__builtin_constant_p(*str))
            return std::char_traits<Char>::length(str);
#endif
        return QtPrivate::qustrlen(reinterpret_cast<const char16_t *>(str));
    } +/
    /+ static qsizetype lengthHelperPointer(const QChar *str) noexcept
    {
        return QtPrivate::qustrlen(reinterpret_cast<const char16_t *>(str));
    } +/

    /+ template <typename Container> +/
    static qsizetype lengthHelperContainer(Container)(ref const(Container) c)/+ noexcept+/
    {
        return qsizetype(/+ std:: +/size(c));
    }

    /+ template <typename Char, size_t N> +/
    static qsizetype lengthHelperContainer(Char,size_t N)(ref const(Char)[N] str)/+ noexcept+/
    {
        const it = /+ std:: +/char_traits!(Char).find(str.ptr, N, Char(0));
        const end = it ? it : /+ std:: +/end(str);
        return qsizetype(/+ std:: +/distance(str, end));
    }

    /+ template <typename Char> +/
    static const(storage_type)* castHelper(Char)(const(Char)* str)/+ noexcept+/
    { return reinterpret_cast!(const(storage_type)*)(str); }
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
    this(Char,)(const(Char)* str, qsizetype len)
    {
        this.m_size = ((){(){ (mixin(Q_ASSERT(q{len >= 0})));
        return /+ Q_ASSERT(str || !len) +/ mixin(Q_ASSERT(q{str || !len}));
        }();
        return len;
        }());
        this.m_data = castHelper(str);
    }

    /+ template <typename Char, if_compatible_char<Char> = true> +/
    this(Char,)(const(Char)* f, const(Char)* l)
    {
        this(f, l - f);
    }

/+ #ifdef Q_CLANG_QDOC
    template <typename Char, size_t N>
    constexpr QStringView(const Char (&array)[N]) noexcept;

    template <typename Char>
    constexpr QStringView(const Char *str) noexcept;
#else +/

    /+ template <typename Pointer, if_compatible_pointer<Pointer> = true> +/
    this(Pointer,)(ref const(Pointer) str)/+ noexcept+/ if (is(Pointer: const(wchar)*))
    {
        this(str, str ? lengthHelperPointer(str) : 0);
    }
/+ #endif

#ifdef Q_CLANG_QDOC
    QStringView(const QString &str) noexcept;
#else +/
    /+ template <typename String, if_compatible_qstring_like<String> = true> +/
    this(String)(ref const(String) str)/+ noexcept+/
    {
        this(str.isNull() ? null : str.data(), qsizetype(str.size()));
    }
/+ #endif +/

    /+ template <typename Container, if_compatible_container<Container> = true> +/
    /+this(Container,)(ref const(Container) c)/+ noexcept+/
    {
        this(/+ std:: +/data(c), lengthHelperContainer(c));
    }+/

    /+ template <typename Char, size_t Size, if_compatible_char<Char> = true> +/
    /+ [[nodiscard]] +/ static QStringView fromArray(Char,size_t Size,)(ref const(Char)[Size] string)/+ noexcept+/
    { return QStringView(string.ptr, Size); }

    /+ [[nodiscard]] +/ pragma(inline, true) QString toString() const
    { return (){ (mixin(Q_ASSERT(q{QStringView.size() == QStringView.length()})));
    return QString(data(), length());
    }(); } // defined in qstring.h
    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        // defined in qcore_foundation.mm
        /+ [[nodiscard]] Q_CORE_EXPORT CFStringRef toCFString() const Q_DECL_CF_RETURNS_RETAINED; +/
        /+ [[nodiscard]] Q_CORE_EXPORT NSString *toNSString() const Q_DECL_NS_RETURNS_AUTORELEASED; +/
    }

    /+ [[nodiscard]] +/ qsizetype size() const/+ noexcept+/ { return m_size; }
    /+ [[nodiscard]] +/ const_pointer data() const/+ noexcept+/ { return reinterpret_cast!(const_pointer)(m_data); }
    /+ [[nodiscard]] +/ const_pointer constData() const/+ noexcept+/ { return data(); }
    /+ [[nodiscard]] +/ const(storage_type)* utf16() const/+ noexcept+/ { return m_data; }

    /+ [[nodiscard]] +/ QChar opIndex(qsizetype n) const
    { return (){(){ (mixin(Q_ASSERT(q{n >= 0})));
return /+ Q_ASSERT(n < size()) +/ mixin(Q_ASSERT(q{n < QStringView.size()}));
}();
return QChar(m_data[n]);
}(); }

    //
    // QString API
    //

    /+ template <typename...Args> +/
    /+ [[nodiscard]] inline QString arg(Args &&...args) const; +/ // defined in qstring.h

    /+ [[nodiscard]] +/ QByteArray toLatin1() const {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.convertToLatin1(this);
    }
    /+ [[nodiscard]] +/ QByteArray toUtf8() const {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.convertToUtf8(this);
    }
    /+ [[nodiscard]] +/ QByteArray toLocal8Bit() const {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.convertToLocal8Bit(this);
    }
    // ### Qt 7 char32_t
    /+ [[nodiscard]] +/ pragma(inline, true) QList!(uint) toUcs4() const {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.convertToUcs4(this);
    } // defined in qlist.h ### Qt 7 char32_t

    /+ [[nodiscard]] +/ QChar at(qsizetype n) const/+ noexcept+/ { return (this)[n]; }

/+    /+ [[nodiscard]] +/ QStringView mid(qsizetype pos, qsizetype n = -1) const/+ noexcept+/
    {
        //using namespace QtPrivate;
        auto result = QContainerImplHelper.mid(size(), &pos, &n);
        return result == QContainerImplHelper.Null ? QStringView() : QStringView(m_data + pos, n);
    }+/
    /+ [[nodiscard]] +/ QStringView left(qsizetype n) const/+ noexcept+/
    {
        if (size_t(n) >= size_t(size()))
            n = size();
        return QStringView(m_data, n);
    }
    /+ [[nodiscard]] +/ QStringView right(qsizetype n) const/+ noexcept+/
    {
        if (size_t(n) >= size_t(size()))
            n = size();
        return QStringView(m_data + m_size - n, n);
    }

    /+ [[nodiscard]] +/ QStringView first(qsizetype n) const/+ noexcept+/
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QStringView.size()}))); return QStringView(m_data, n); }
    /+ [[nodiscard]] +/ QStringView last(qsizetype n) const/+ noexcept+/
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QStringView.size()}))); return QStringView(m_data + size() - n, n); }
    /+ [[nodiscard]] +/ QStringView sliced(qsizetype pos) const/+ noexcept+/
    { (mixin(Q_ASSERT(q{pos >= 0}))); (mixin(Q_ASSERT(q{pos <= QStringView.size()}))); return QStringView(m_data + pos, size() - pos); }
    /+ [[nodiscard]] +/ QStringView sliced(qsizetype pos, qsizetype n) const/+ noexcept+/
    { (mixin(Q_ASSERT(q{pos >= 0}))); (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{size_t(pos) + size_t(n) <= size_t(QStringView.size())}))); return QStringView(m_data + pos, n); }
    /+ [[nodiscard]] +/ QStringView chopped(qsizetype n) const/+ noexcept+/
    { return (){(){ (mixin(Q_ASSERT(q{n >= 0})));
return /+ Q_ASSERT(n <= size()) +/ mixin(Q_ASSERT(q{n <= QStringView.size()}));
}();
return QStringView(m_data, m_size - n);
}(); }

    void truncate(qsizetype n)/+ noexcept+/
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QStringView.size()}))); m_size = n; }
    void chop(qsizetype n)/+ noexcept+/
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QStringView.size()}))); m_size -= n; }

    /+ [[nodiscard]] +/ QStringView trimmed() const/+ noexcept+/ {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.trimmed(this);
    }

    /+ template <typename Needle, typename...Flags> +/
    /+ [[nodiscard]] constexpr inline auto tokenize(Needle &&needle, Flags...flags) const
        noexcept(noexcept(qTokenize(std::declval<const QStringView&>(), std::forward<Needle>(needle), flags...)))
            -> decltype(qTokenize(*this, std::forward<Needle>(needle), flags...))
    { return qTokenize(*this, std::forward<Needle>(needle), flags...); } +/

    /+ [[nodiscard]] +/ int compare(QStringView other, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(this, other, cs);
    }
    //
    // QStringView members that require QLatin1String:
    //
    /+ [[nodiscard]] +/ pragma(inline, true) int compare(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(this, s, cs);
    }
    /+ [[nodiscard]] +/ int compare(QChar c) const/+ noexcept+/
    { return size() >= 1 ? compare_single_char_helper(*utf16() - c.unicode()) : -1; }
    /+ [[nodiscard]] +/ int compare(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(this, QStringView(&c, 1), cs);
    }

    /+ [[nodiscard]] +/ bool startsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(this, s, cs);
    }
    /+ [[nodiscard]] +/ pragma(inline, true) bool startsWith(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(this, s, cs);
    }
    /+ [[nodiscard]] +/ bool startsWith(QChar c) const/+ noexcept+/
    { return !empty() && front() == c; }
    /+ [[nodiscard]] +/ bool startsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(this, QStringView(&c, 1), cs);
    }

    /+ [[nodiscard]] +/ bool endsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(this, s, cs);
    }
    /+ [[nodiscard]] +/ pragma(inline, true) bool endsWith(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(this, s, cs);
    }
    /+ [[nodiscard]] +/ bool endsWith(QChar c) const/+ noexcept+/
    { return !empty() && back() == c; }
    /+ [[nodiscard]] +/ bool endsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(this, QStringView(&c, 1), cs);
    }

    /+ [[nodiscard]] +/ qsizetype indexOf(QChar c, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.findString(this, from, QStringView(&c, 1), cs);
    }
    /+ [[nodiscard]] +/ qsizetype indexOf(QStringView s, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.findString(this, from, s, cs);
    }
    /+ [[nodiscard]] +/ pragma(inline, true) qsizetype indexOf(QLatin1String s, qsizetype from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.findString(this, from, s, cs);
    }

    /+ [[nodiscard]] +/ bool contains(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(QStringView(&c, 1), 0, cs) != qsizetype(-1); }
    /+ [[nodiscard]] +/ bool contains(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(s, 0, cs) != qsizetype(-1); }
    /+ [[nodiscard]] +/ pragma(inline, true) bool contains(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(s, 0, cs) != qsizetype(-1); }

    /+ [[nodiscard]] +/ qsizetype count(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.count(this, c, cs);
    }
    /+ [[nodiscard]] +/ qsizetype count(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.count(this, s, cs);
    }

    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return lastIndexOf(c, -1, cs); }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QChar c, qsizetype from, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, from, QStringView(&c, 1), cs);
    }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return lastIndexOf(s, size(), cs); }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QStringView s, qsizetype from, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, from, s, cs);
    }
    /+ [[nodiscard]] +/ pragma(inline, true) qsizetype lastIndexOf(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, size(), s, cs);
    }
    /+ [[nodiscard]] +/ pragma(inline, true) qsizetype lastIndexOf(QLatin1String s, qsizetype from, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, from, s, cs);
    }

/+ #if QT_CONFIG(regularexpression) +/
    /+ [[nodiscard]] +/ qsizetype indexOf(ref const(QRegularExpression) re, qsizetype from = 0, QRegularExpressionMatch* rmatch = null) const
    {
        import qt.core.stringalgorithms;

        return /+ QtPrivate:: +/qt.core.stringalgorithms.indexOf(this, re, from, rmatch);
    }
/+ #ifdef Q_QDOC
    [[nodiscard]] qsizetype lastIndexOf(const QRegularExpression &re, QRegularExpressionMatch *rmatch = nullptr) const;
#else +/
    // prevent an ambiguity when called like this: lastIndexOf(re, 0)
    /+ template <typename T = QRegularExpressionMatch, std::enable_if_t<std::is_same_v<T, QRegularExpressionMatch>, bool> = false> +/
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(T,)(ref const(QRegularExpression) re, T* rmatch = null) const
    {
        import qt.core.stringalgorithms;

        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, re, size(), rmatch);
    }
/+ #endif +/
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(ref const(QRegularExpression) re, qsizetype from, QRegularExpressionMatch* rmatch = null) const
    {
        import qt.core.stringalgorithms;

        return /+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, re, from, rmatch);
    }
    /+ [[nodiscard]] +/ bool contains(ref const(QRegularExpression) re, QRegularExpressionMatch* rmatch = null) const
    {
        import qt.core.stringalgorithms;

        return /+ QtPrivate:: +/qt.core.stringalgorithms.contains(this, re, rmatch);
    }
    /+ [[nodiscard]] +/ qsizetype count(ref const(QRegularExpression) re) const
    {
        import qt.core.stringalgorithms;

        return /+ QtPrivate:: +/qt.core.stringalgorithms.count(this, re);
    }
/+ #endif +/

    /+ [[nodiscard]] +/ bool isRightToLeft() const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.isRightToLeft(this);
    }
    /+ [[nodiscard]] +/ bool isValidUtf16() const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.isValidUtf16(this);
    }

    /+ [[nodiscard]] +/ pragma(inline, true) short toShort(bool* ok = null, int base = 10) const
    { return QString.toIntegral_helper!(short)(this, ok, base); }
    /+ [[nodiscard]] +/ pragma(inline, true) ushort toUShort(bool* ok = null, int base = 10) const
    { return QString.toIntegral_helper!(ushort)(this, ok, base); }
    /+ [[nodiscard]] +/ pragma(inline, true) int toInt(bool* ok = null, int base = 10) const
    { return QString.toIntegral_helper!(int)(this, ok, base); }
    /+ [[nodiscard]] +/ pragma(inline, true) uint toUInt(bool* ok = null, int base = 10) const
    { return QString.toIntegral_helper!(uint)(this, ok, base); }
    /+ [[nodiscard]] +/ pragma(inline, true) cpp_long toLong(bool* ok = null, int base = 10) const
    { return QString.toIntegral_helper!(cpp_long)(this, ok, base); }
    /+ [[nodiscard]] +/ pragma(inline, true) cpp_ulong toULong(bool* ok = null, int base = 10) const
    { return QString.toIntegral_helper!(cpp_ulong)(this, ok, base); }
    /+ [[nodiscard]] +/ pragma(inline, true) qlonglong toLongLong(bool* ok = null, int base = 10) const
    /+pragma(inline, true) qint64 toLongLong(bool* ok, int base) const+/
    { return QString.toIntegral_helper!(qint64)(this, ok, base); }
    /+ [[nodiscard]] +/ pragma(inline, true) qulonglong toULongLong(bool* ok = null, int base = 10) const
    /+pragma(inline, true) quint64 toULongLong(bool* ok, int base) const+/
    { return QString.toIntegral_helper!(quint64)(this, ok, base); }
    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ float toFloat(bool* ok = null) const;
    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ double toDouble(bool* ok = null) const;

/+    /+ [[nodiscard]] +/ pragma(inline, true) qsizetype toWCharArray(wchar_t* array) const
    {
        import core.stdc.string;

        if (wchar_t.sizeof == QChar.sizeof) {
            if (auto src = data())
                memcpy(array, cast(const(void)*) (src), QChar.sizeof * size());
            return size();
        } else {
            return QString.toUcs4_helper(reinterpret_cast!(const(ushort)*)(data()), size(),
                                          reinterpret_cast!(uint*)(array));
        }
    } // defined in qstring.h +/


    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/
        QList!(QStringView) split(QStringView sep,
                                 /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts,
                                 /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/
        QList!(QStringView) split(QChar sep, /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts,
                                 /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;

/+ #if QT_CONFIG(regularexpression) +/
    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/
        QList!(QStringView) split(ref const(QRegularExpression) sep,
                                 /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts) const;
/+ #endif +/

    // QStringView <> QStringView
    /+ friend bool operator==(QStringView lhs, QStringView rhs) noexcept { return lhs.size() == rhs.size() && QtPrivate::equalStrings(lhs, rhs); } +/
    /+ friend bool operator!=(QStringView lhs, QStringView rhs) noexcept { return !(lhs == rhs); } +/
    /+ friend bool operator< (QStringView lhs, QStringView rhs) noexcept { return QtPrivate::compareStrings(lhs, rhs) <  0; } +/
    /+ friend bool operator<=(QStringView lhs, QStringView rhs) noexcept { return QtPrivate::compareStrings(lhs, rhs) <= 0; } +/
    /+ friend bool operator> (QStringView lhs, QStringView rhs) noexcept { return QtPrivate::compareStrings(lhs, rhs) >  0; } +/
    /+ friend bool operator>=(QStringView lhs, QStringView rhs) noexcept { return QtPrivate::compareStrings(lhs, rhs) >= 0; } +/

    // QStringView <> QChar
    /+ friend bool operator==(QStringView lhs, QChar rhs) noexcept { return lhs == QStringView(&rhs, 1); } +/
    /+ friend bool operator!=(QStringView lhs, QChar rhs) noexcept { return lhs != QStringView(&rhs, 1); } +/
    /+ friend bool operator< (QStringView lhs, QChar rhs) noexcept { return lhs <  QStringView(&rhs, 1); } +/
    /+ friend bool operator<=(QStringView lhs, QChar rhs) noexcept { return lhs <= QStringView(&rhs, 1); } +/
    /+ friend bool operator> (QStringView lhs, QChar rhs) noexcept { return lhs >  QStringView(&rhs, 1); } +/
    /+ friend bool operator>=(QStringView lhs, QChar rhs) noexcept { return lhs >= QStringView(&rhs, 1); } +/

    /+ friend bool operator==(QChar lhs, QStringView rhs) noexcept { return QStringView(&lhs, 1) == rhs; } +/
    /+ friend bool operator!=(QChar lhs, QStringView rhs) noexcept { return QStringView(&lhs, 1) != rhs; } +/
    /+ friend bool operator< (QChar lhs, QStringView rhs) noexcept { return QStringView(&lhs, 1) <  rhs; } +/
    /+ friend bool operator<=(QChar lhs, QStringView rhs) noexcept { return QStringView(&lhs, 1) <= rhs; } +/
    /+ friend bool operator> (QChar lhs, QStringView rhs) noexcept { return QStringView(&lhs, 1) >  rhs; } +/
    /+ friend bool operator>=(QChar lhs, QStringView rhs) noexcept { return QStringView(&lhs, 1) >= rhs; } +/

    //
    // STL compatibility API:
    //
    /+ [[nodiscard]] +/ const_iterator begin()   const/+ noexcept+/ { return data(); }
    /+ [[nodiscard]] +/ const_iterator end()     const/+ noexcept+/ { return data() + size(); }
    /+ [[nodiscard]] +/ const_iterator cbegin()  const/+ noexcept+/ { return begin(); }
    /+ [[nodiscard]] +/ const_iterator cend()    const/+ noexcept+/ { return end(); }
    /+ [[nodiscard]] const_reverse_iterator rbegin()  const noexcept { return const_reverse_iterator(end()); } +/
    /+ [[nodiscard]] const_reverse_iterator rend()    const noexcept { return const_reverse_iterator(begin()); } +/
    /+ [[nodiscard]] const_reverse_iterator crbegin() const noexcept { return rbegin(); } +/
    /+ [[nodiscard]] const_reverse_iterator crend()   const noexcept { return rend(); } +/

    /+ [[nodiscard]] +/ bool empty() const/+ noexcept+/ { return size() == 0; }
    /+ [[nodiscard]] +/ QChar front() const { return (){ (mixin(Q_ASSERT(q{!QStringView.empty()})));
return QChar(m_data[0]);
}(); }
    /+ [[nodiscard]] +/ QChar back()  const { return (){ (mixin(Q_ASSERT(q{!QStringView.empty()})));
return QChar(m_data[m_size - 1]);
}(); }

    //
    // Qt compatibility API:
    //
    /+ [[nodiscard]] +/ const_iterator constBegin() const/+ noexcept+/ { return begin(); }
    /+ [[nodiscard]] +/ const_iterator constEnd() const/+ noexcept+/ { return end(); }
    /+ [[nodiscard]] +/ bool isNull() const/+ noexcept+/ { return !m_data; }
    /+ [[nodiscard]] +/ bool isEmpty() const/+ noexcept+/ { return empty(); }
    /+ [[nodiscard]] +/ qsizetype length() const/+ noexcept+/
    { return size(); }
    /+ [[nodiscard]] +/ QChar first() const { return front(); }
    /+ [[nodiscard]] +/ QChar last()  const { return back(); }
private:
    qsizetype m_size = 0;
    const(storage_type)* m_data = null;

    int compare_single_char_helper(int diff) const/+ noexcept+/
    { return diff ? diff : size() > 1 ? 1 : 0; }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QStringView, Q_PRIMITIVE_TYPE); +/

pragma(inline, true) QStringView qToStringViewIgnoringNull(QStringLike, /+ typename std::enable_if<
    std::is_same<QStringLike, QString>::value,
    bool>::type +/ /+ = true +/)(ref const(QStringLike) s)/+ noexcept+/
{ return QStringView(s.data(), s.size()); }

// QChar inline functions:

