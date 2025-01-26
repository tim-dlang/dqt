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
module qt.core.utf8stringview;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.global;
import qt.core.string;
import qt.helpers;


extern(C++, "QtPrivate") {
/+alias IsCompatibleChar8TypeHelper(Char) = /+ std:: +/
    disjunction!(
/+ #ifdef __cpp_char8_t +/
        /+ std:: +/is_same!(Char, char8_t),
/+ #endif +/
        /+ std:: +/is_same!(Char, char),
        /+ std:: +/is_same!(Char, uchar),
        /+ std:: +/is_same!(Char, byte));
alias IsCompatibleChar8Type(Char)
    = IsCompatibleChar8TypeHelper!(/+ std:: +/remove_cv_t!(/+ std:: +/remove_reference_t!(Char)));

struct IsCompatiblePointer8Helper(Pointer) {
    /+ std:: +/false_type base0;
    alias base0 this;
}
/+ template <typename Char>
struct IsCompatiblePointer8Helper<Char*>
    : IsCompatibleChar8Type<Char> {}; +/
alias IsCompatiblePointer8(Pointer)
    = IsCompatiblePointer8Helper!(/+ std:: +/remove_cv_t!(/+ std:: +/remove_reference_t!(Pointer)));
+/
struct IsContainerCompatibleWithQUtf8StringView(T, Enable) {
    /+ std:: +/false_type base0;
    alias base0 this;
}

/+ template <typename T>
struct IsContainerCompatibleWithQUtf8StringView<T, std::enable_if_t<std::conjunction_v<
        // lacking concepts and ranges, we accept any T whose std::data yields a suitable pointer ...
        IsCompatiblePointer8<decltype(std::data(std::declval<const T &>()))>,
        // ... and that has a suitable size ...
        std::is_convertible<
            decltype(std::size(std::declval<const T &>())),
            qsizetype
        >,
        // ... and it's a range as it defines an iterator-like API
        IsCompatibleChar8Type<typename std::iterator_traits<
            decltype(std::begin(std::declval<const T &>()))>::value_type
        >,
        std::is_convertible<
            decltype( std::begin(std::declval<const T &>()) != std::end(std::declval<const T &>()) ),
            bool
        >,

        // This needs to be treated specially due to the empty vs null distinction
        std::negation<std::is_same<std::decay_t<T>, QByteArray>>,

        // This has a compatible value_type, but explicitly a different encoding
        std::negation<std::is_same<std::decay_t<T>, QLatin1String>>,

        // Don't make an accidental copy constructor
        std::negation<std::disjunction<
            std::is_same<std::decay_t<T>, QBasicUtf8StringView<true>>,
            std::is_same<std::decay_t<T>, QBasicUtf8StringView<false>>
        >>
    >>> : std::true_type {}; +/

struct hide_char8_t {
/+ #ifdef __cpp_char8_t +/
    alias type = char;
/+ #endif +/
}

struct wrap_char { alias type = char; }

} // namespace QtPrivate

/+ #ifdef Q_CLANG_QDOC +/
static if (false)
{
/+ #define QBasicUtf8StringView QUtf8StringView +/
}
/+ #else +/
/+ #endif +/
extern(C++, class) struct QBasicUtf8StringView(bool UseChar8T)
{
public:
/+ #ifndef Q_CLANG_QDOC +/
/+    alias storage_type = /+ typename std::conditional<UseChar8T,
                QtPrivate::hide_char8_t,
                QtPrivate::wrap_char
            >::type::type +/UnknownType!q{};+/
    alias storage_type = char;
/+ #else
    using storage_type = typename QtPrivate::hide_char8_t;
#endif +/
    alias value_type = const(storage_type);
    alias difference_type = qptrdiff;
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
    /+ using if_compatible_char = std::enable_if_t<QtPrivate::IsCompatibleChar8Type<Char>::value, bool>; +/

    /+ template <typename Pointer> +/
    /+ using if_compatible_pointer = std::enable_if_t<QtPrivate::IsCompatiblePointer8<Pointer>::value, bool>; +/

    /+ template <typename T> +/
    /+ using if_compatible_qstring_like = std::enable_if_t<std::is_same_v<T, QByteArray>, bool>; +/

    /+ template <typename T> +/
    /+ using if_compatible_container = std::enable_if_t<QtPrivate::IsContainerCompatibleWithQUtf8StringView<T>::value, bool>; +/

    /+ template <typename Container> +/
    static qsizetype lengthHelperContainer(Container)(ref const(Container) c)/+ noexcept+/
    {
        return qsizetype(/+ std:: +/size(c));
    }

    // Note: Do not replace with std::size(const Char (&)[N]), cause the result
    // will be of by one.
    /+ template <typename Char, size_t N> +/
    static qsizetype lengthHelperContainer(Char,size_t N)(ref const(Char)[N] str)/+ noexcept+/
    {
        const it = /+ std:: +/char_traits!(Char).find(str.ptr, N, Char(0));
        const end = it ? it : /+ std:: +/next(str, N);
        return qsizetype(/+ std:: +/distance(str, end));
    }

    /+ template <typename Char> +/
    static const(storage_type)* castHelper(Char)(const(Char)* str)/+ noexcept+/
    { return reinterpret_cast!(const(storage_type)*)(str); }
    static const(storage_type)* castHelper(const(storage_type)* str)/+ noexcept+/
    { return str; }

public:
    @disable this();
    /+this()/+ noexcept+/
    {
        this.m_data = null;
        this.m_size = 0;
    }+/
    this(typeof(null))/+ noexcept+/
    {
    }

    /+ template <typename Char, if_compatible_char<Char> = true> +/
    this(Char,)(const(Char)* str, qsizetype len)
    {
        this.m_data = castHelper(str);
        this.m_size = ((){(){ (mixin(Q_ASSERT(q{len >= 0})));
        return /+ Q_ASSERT(str || !len) +/ mixin(Q_ASSERT(q{str || !len}));
        }();
        return len;
        }());
    }

    /+ template <typename Char, if_compatible_char<Char> = true> +/
    this(Char,)(const(Char)* f, const(Char)* l)
    {
        this(f, l - f);
    }

/+ #ifdef Q_CLANG_QDOC
    template <typename Char, size_t N>
    constexpr QBasicUtf8StringView(const Char (&array)[N]) noexcept;

    template <typename Char>
    constexpr QBasicUtf8StringView(const Char *str) noexcept;
#else +/
    /+ template <typename Pointer, if_compatible_pointer<Pointer> = true> +/
    this(Pointer,)(ref const(Pointer) str)/+ noexcept+/
    {
        this(str,
                    str ? /+ std:: +/char_traits!(/+ std:: +/remove_cv_t!(/+ std:: +/remove_pointer_t!(Pointer))).length(str) : 0);
    }
/+ #endif

#ifdef Q_CLANG_QDOC
    QBasicUtf8StringView(const QByteArray &str) noexcept;
#else +/
    /+ template <typename String, if_compatible_qstring_like<String> = true> +/
    this(String,)(ref const(String) str)/+ noexcept+/
    {
        this(str.isNull() ? null : str.data(), qsizetype(str.size()));
    }
/+ #endif +/

    /+ template <typename Container, if_compatible_container<Container> = true> +/
    this(Container,)(ref const(Container) c)/+ noexcept+/
    {
        this(/+ std:: +/data(c), lengthHelperContainer(c));
    }

/+ #ifdef __cpp_char8_t +/
    this(QBasicUtf8StringView!(!UseChar8T) other)
    {
        this(other.data(), other.size());
    }
/+ #endif +/

    /+ template <typename Char, size_t Size, if_compatible_char<Char> = true> +/
    /+ [[nodiscard]] +/ static QBasicUtf8StringView fromArray(Char,size_t Size,)(ref const(Char)[Size] string)/+ noexcept+/
    { return QBasicUtf8StringView(string.ptr, Size); }

    /+ [[nodiscard]] +/ pragma(inline, true) QString toString() const
    {
        return QString.fromUtf8(data(), size());
    } // defined in qstring.h

    /+ [[nodiscard]] +/ qsizetype size() const/+ noexcept+/ { return m_size; }
    /+ [[nodiscard]] +/ const_pointer data() const/+ noexcept+/ { return reinterpret_cast!(const_pointer)(m_data); }
/+ #if defined(__cpp_char8_t) || defined(Q_CLANG_QDOC) +/
    /+ [[nodiscard]] +/ const(char)* utf8() const/+ noexcept+/ { return reinterpret_cast!(const(char)*)(m_data); }
/+ #endif +/

    /+ [[nodiscard]] +/ storage_type opIndex(qsizetype n) const
    { return (){(){ (mixin(Q_ASSERT(q{n >= 0})));
return /+ Q_ASSERT(n < size()) +/ mixin(Q_ASSERT(q{n < QBasicUtf8StringView.size()}));
}();
return m_data[n];
}(); }

    //
    // QString API
    //

    /+ [[nodiscard]] +/ storage_type at(qsizetype n) const { return (this)[n]; }

/+    /+ [[nodiscard]] +/
        QBasicUtf8StringView mid(qsizetype pos, qsizetype n = -1) const
    {
        //using namespace QtPrivate;
        auto result = QContainerImplHelper.mid(size(), &pos, &n);
        return result == QContainerImplHelper.Null ? QBasicUtf8StringView() : QBasicUtf8StringView(m_data + pos, n);
    }+/
    /+ [[nodiscard]] +/
        QBasicUtf8StringView left(qsizetype n) const
    {
        if (size_t(n) >= size_t(size()))
            n = size();
        return QBasicUtf8StringView(m_data, n);
    }
    /+ [[nodiscard]] +/
        QBasicUtf8StringView right(qsizetype n) const
    {
        if (size_t(n) >= size_t(size()))
            n = size();
        return QBasicUtf8StringView(m_data + m_size - n, n);
    }

    /+ [[nodiscard]] +/ QBasicUtf8StringView sliced(qsizetype pos) const
    { verify(pos); return QBasicUtf8StringView(m_data + pos, m_size - pos); }
    /+ [[nodiscard]] +/ QBasicUtf8StringView sliced(qsizetype pos, qsizetype n) const
    { verify(pos, n); return QBasicUtf8StringView(m_data + pos, n); }
    /+ [[nodiscard]] +/ QBasicUtf8StringView first(qsizetype n) const
    { verify(n); return QBasicUtf8StringView(m_data, n); }
    /+ [[nodiscard]] +/ QBasicUtf8StringView last(qsizetype n) const
    { verify(n); return QBasicUtf8StringView(m_data + m_size - n, n); }
    /+ [[nodiscard]] +/ QBasicUtf8StringView chopped(qsizetype n) const
    { verify(n); return QBasicUtf8StringView(m_data, m_size - n); }

    void truncate(qsizetype n)
    { verify(n); m_size = n; }
    void chop(qsizetype n)
    { verify(n); m_size -= n; }

    /+ [[nodiscard]] +/ pragma(inline, true) bool isValidUtf8() const/+ noexcept+/
    {
        import qt.core.bytearrayview;

        return QByteArrayView(reinterpret_cast!(const(char)*)(data()), size()).isValidUtf8();
    }

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
    /+ [[nodiscard]] +/ storage_type front() const { return (){ (mixin(Q_ASSERT(q{!QBasicUtf8StringView.empty()})));
return m_data[0];
}(); }
    /+ [[nodiscard]] +/ storage_type back()  const { return (){ (mixin(Q_ASSERT(q{!QBasicUtf8StringView.empty()})));
return m_data[m_size - 1];
}(); }

    //
    // Qt compatibility API:
    //
    /+ [[nodiscard]] +/ bool isNull() const/+ noexcept+/ { return !m_data; }
    /+ [[nodiscard]] +/ bool isEmpty() const/+ noexcept+/ { return empty(); }
    /+ [[nodiscard]] +/ qsizetype length() const/+ noexcept+/
    { return size(); }

private:
    /+ /+ [[nodiscard]] +/ pragma(inline, true) static int compare(QBasicUtf8StringView lhs, QBasicUtf8StringView rhs)/+ noexcept+/
    {
        import qt.core.stringalgorithms;

        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(QBasicUtf8StringView!(false)(lhs.data(), lhs.size()),
                                         QBasicUtf8StringView!(false)(rhs.data(), rhs.size()));
    }+/

    /+ [[nodiscard]] friend inline bool operator==(QBasicUtf8StringView lhs, QBasicUtf8StringView rhs) noexcept
    {
        return lhs.size() == rhs.size()
               && QtPrivate::equalStrings(QBasicUtf8StringView<false>(lhs.data(), lhs.size()),
                                          QBasicUtf8StringView<false>(rhs.data(), rhs.size()));
    } +/
    /+ [[nodiscard]] friend inline bool operator!=(QBasicUtf8StringView lhs, QBasicUtf8StringView rhs) noexcept
    { return !operator==(lhs, rhs); } +/

/+ #ifdef __cpp_impl_three_way_comparison
    [[nodiscard]] friend inline auto operator<=>(QBasicUtf8StringView lhs, QBasicUtf8StringView rhs) noexcept
    { return QBasicUtf8StringView::compare(lhs, rhs) <=> 0; }
#else +/
    /+ [[nodiscard]] friend inline bool operator<=(QBasicUtf8StringView lhs, QBasicUtf8StringView rhs) noexcept
    { return QBasicUtf8StringView::compare(lhs, rhs) <= 0; } +/
    /+ [[nodiscard]] friend inline bool operator>=(QBasicUtf8StringView lhs, QBasicUtf8StringView rhs) noexcept
    { return QBasicUtf8StringView::compare(lhs, rhs) >= 0; } +/
    /+ [[nodiscard]] friend inline bool operator<(QBasicUtf8StringView lhs, QBasicUtf8StringView rhs) noexcept
    { return QBasicUtf8StringView::compare(lhs, rhs) < 0; } +/
    /+ [[nodiscard]] friend inline bool operator>(QBasicUtf8StringView lhs, QBasicUtf8StringView rhs) noexcept
    { return QBasicUtf8StringView::compare(lhs, rhs) > 0; } +/
/+ #endif +/

    /+ Q_ALWAYS_INLINE +/ pragma(inline, true) void verify(qsizetype pos, qsizetype n = 0) const
    {
        (mixin(Q_ASSERT(q{pos >= 0})));
        (mixin(Q_ASSERT(q{pos <= QBasicUtf8StringView.size()})));
        (mixin(Q_ASSERT(q{n >= 0})));
        (mixin(Q_ASSERT(q{n <= QBasicUtf8StringView.size() - pos})));
    }
    const(storage_type)* m_data = null;
    qsizetype m_size = 0;
}

/+ #ifdef Q_CLANG_QDOC
#undef QBasicUtf8StringView
#else +/
/+ inline +/ extern(C++,"q_no_char8_t"){
/+ template <bool UseChar8T>
Q_DECLARE_TYPEINFO_BODY(QBasicUtf8StringView<UseChar8T>, Q_PRIMITIVE_TYPE);

// ### Qt 7: remove the non-char8_t version of QUtf8StringView
QT_BEGIN_NO_CHAR8_T_NAMESPACE +/
//alias QUtf8StringView = QBasicUtf8StringView!(false);
}
/+ QT_END_NO_CHAR8_T_NAMESPACE +/
extern(C++,"q_has_char8_t"){

/+ QT_BEGIN_HAS_CHAR8_T_NAMESPACE +/
alias QUtf8StringView = QBasicUtf8StringView!(true);
}
/+ QT_END_HAS_CHAR8_T_NAMESPACE +/
/+ #endif +/ // Q_CLANG_QDOC

/+ [[nodiscard]] +/ pragma(inline, true) /+ q_no_char8_t:: +/QUtf8StringView qToUtf8StringViewIgnoringNull(QStringLike, /+ std::enable_if_t<std::is_same_v<QStringLike, QByteArray>, bool> +/ /+ = true +/)(ref const(QStringLike) s)/+ noexcept+/
{ return /+ q_no_char8_t:: +/QUtf8StringView(s.data(), s.size()); }

