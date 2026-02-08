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
module qt.core.anystringview;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.global;
import qt.core.namespace;
import qt.core.qchar;
import qt.core.string;
import qt.core.stringview;
import qt.core.typeinfo;
import qt.core.utf8stringview;
import qt.helpers;

/+ #ifdef __cpp_impl_three_way_comparison
#endif +/
extern(C++, class) struct tst_QAnyStringView;


/+ template <typename, typename> class QStringBuilder;
template <typename> struct QConcatenable; +/

/// Binding for C++ class [QAnyStringView](https://doc.qt.io/qt-6/qanystringview.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct QAnyStringView
{
public:
    alias difference_type = qptrdiff;
    alias size_type = qsizetype;
private:
    /+ template <typename Char> +/
    /+ using if_compatible_char = std::enable_if_t<std::disjunction_v<
        QtPrivate::IsCompatibleCharType<Char>,
        QtPrivate::IsCompatibleChar8Type<Char>
    >, bool>; +/
    enum if_compatible_char(Char) = is(const(Char) == const(wchar)) || is(const(Char) == const(char)) || is(const(Char) == const(QChar));

    /+ template <typename Pointer> +/
    /+ using if_compatible_pointer = std::enable_if_t<std::disjunction_v<
        QtPrivate::IsCompatiblePointer<Pointer>,
        QtPrivate::IsCompatiblePointer8<Pointer>
    >, bool>; +/
    enum if_compatible_pointer(Pointer) = is(const(Pointer) == const(wchar*)) || is(const(Pointer) == const(char*)) || is(const(Pointer) == const(QChar*));

    /+ template <typename T> +/
    /+ using if_compatible_container = std::enable_if_t<std::disjunction_v<
        QtPrivate::IsContainerCompatibleWithQStringView<T>,
        QtPrivate::IsContainerCompatibleWithQUtf8StringView<T>
    >, bool>; +/

    // confirm we don't make an accidental copy constructor:
//    static assert(/+ QtPrivate:: +/qt.core.stringview.IsContainerCompatibleWithQStringView!(QAnyStringView).value == false);
//    static assert(/+ QtPrivate:: +/qt.core.utf8stringview.IsContainerCompatibleWithQUtf8StringView!(QAnyStringView).value == false);

    /+ template<typename Char> +/
    static bool isAsciiOnlyCharsAtCompileTime(Char)(Char* str, qsizetype sz)/+ noexcept+/
    {
        // do not perform check if not at compile time
/+ #if !(defined(__cpp_lib_is_constant_evaluated) || defined(Q_CC_GNU))
        Q_UNUSED(str);
        Q_UNUSED(sz);
        return false;
#else
#  if defined(__cpp_lib_is_constant_evaluated) +/
        static if (defined!"__cpp_lib_is_constant_evaluated")
        {
            if (!__ctfe)
                return false;
        }
        else
        {
    /+ #  elif defined(Q_CC_GNU) && !defined(Q_CC_CLANG) +/
            if (!str/* || !__builtin_constant_p(*str)*/)
                return false;
        }
/+ #  endif +/
        static if (Char.sizeof != char.sizeof) {
            /+ Q_UNUSED(str) +/
            /+ Q_UNUSED(sz) +/
            return false;
        } else {
            for (qsizetype i = 0; i < sz; ++i) {
                if (uchar(str[i]) > 0x7f)
                    return false;
            }
            return true;
        }
/+ #endif +/
    }

    /+ template<typename Char> +/
    static /+ std:: +/size_t encodeType(Char)(const(Char)* str, qsizetype sz)/+ noexcept+/
    {
        // Utf16 if 16 bit, Latin1 if ASCII, else Utf8
        (mixin(Q_ASSERT(q{sz >= 0})));
        (mixin(Q_ASSERT(q{sz <= qsizetype(SizeMask)})));
        (mixin(Q_ASSERT(q{str || !sz})));
        return /+ std:: +/size_t(sz) | uint(Char.sizeof == wchar.sizeof) * Tag.Utf16
                | uint(isAsciiOnlyCharsAtCompileTime(cast(Char*) (str), sz)) * Tag.Latin1;
    }

    /+ template <typename Char> +/
    static qsizetype lengthHelperPointer(Char)(const Char* str)/+ noexcept+/
    {
/+ #if defined(Q_CC_GNU) && !defined(Q_CC_CLANG)
        if (__builtin_constant_p(*str)) {
            qsizetype result = 0;
            while (*str++ != '\0')
                ++result;
            return result;
        }
#endif +/
        import core.stdc.string: strlen;
        static if (Char.sizeof == wchar.sizeof)
            return /+ QtPrivate:: +/qustrlen(cast(const char16_t*)(str));
        else
            return qsizetype(strlen(cast(const char*)(str)));
    }

    /+ template <typename Container> +/
    static qsizetype lengthHelperContainer(Container)(ref const(Container) c)/+ noexcept+/
    {
        return qsizetype(c.size());
    }

    /+ template <typename Char, size_t N> +/
    /+ static qsizetype lengthHelperContainer(Char,size_t N)(ref const(Char)[N] str)/+ noexcept+/
    {
        const it = /+ std:: +/char_traits!(Char).find(str.ptr, N, Char(0));
        const end = it ? it : /+ std:: +/next(str, N);
        return qsizetype(/+ std:: +/distance(str, end));
    } +/

    static QChar toQChar(char ch)/+ noexcept+/ { return toQChar(QLatin1Char(ch)); } // we don't handle UTF-8 multibytes
    static QChar toQChar(QChar ch)/+ noexcept+/ { return ch; }
    static QChar toQChar(QLatin1Char ch)/+ noexcept+/ { return QChar(ch); }

/+    /+ explicit +/ this(const(void)* d, qsizetype n, /+ std:: +/size_t sizeAndType)/+ noexcept+/
    {
        this.m_data = typeof(this.m_data)({d});
        this.m_size = {/+ std:: +/size_t(n) | (sizeAndType & TypeMask)};
    }+/
public:
    @disable this();
    /+this()/+ noexcept+/
    {
        this.m_data = typeof(this.m_data)({null});
        this.m_size = {0};
    }+/
    this(typeof(null))/+ noexcept+/
    {
        //this();
    }

    /+ template <typename Char, if_compatible_char<Char> = true> +/
    this(Char)(const(Char)* str, qsizetype len) if (if_compatible_char!Char)
    {
        this.m_data = typeof(this.m_data)(str);
        this.m_size = encodeType!(Char)(str, len);
    }

    /+ template <typename Char, if_compatible_char<Char> = true> +/
    this(Char,)(const(Char)* f, const(Char)* l) if (if_compatible_char!Char)
    {
        this(f, l - f);
    }

/+ #ifdef Q_CLANG_QDOC
    template <typename Char, size_t N>
    constexpr QAnyStringView(const Char (&array)[N]) noexcept;

    template <typename Char>
    constexpr QAnyStringView(const Char *str) noexcept;
#else +/

    /+ template <typename Pointer, if_compatible_pointer<Pointer> = true> +/
    this(Pointer,)(ref const(Pointer) str)/+ noexcept+/ if (if_compatible_pointer!Pointer)
    {
        this = QAnyStringView(str, str ? lengthHelperPointer(str) : 0);
    }
/+ #endif +/

    // defined in qstring.h
    /+pragma(inline, true) this(ref const(QByteArray) str)/+ noexcept+/
    {
        this(QAnyStringView(str.isNull() ? null : str.data(), str.size()));
    }+/ // TODO: Should we have this at all? Remove?
    pragma(inline, true) this(ref const(QString) str)/+ noexcept+/
    {
        this(str.isNull() ? null : str.data(), str.size());
    }
    pragma(inline, true) this(QLatin1StringView str)/+ noexcept+/
    {
        this.m_data = typeof(this.m_data)(str.data());
        this.m_size = size_t(str.size()) | Tag.Latin1;
    }

    // defined in qstringbuilder.h
    /+ template <typename A, typename B> +/
    /+ inline QAnyStringView(const QStringBuilder<A, B> &expr,
                          typename QConcatenable<QStringBuilder<A, B>>::ConvertTo &&capacity = {}); +/

    /+ template <typename Container, if_compatible_container<Container> = true> +/
    /*this(Container,)(ref const(Container) c)/+ noexcept+/
    {
        this(/+ std:: +/data(c), lengthHelperContainer(c));
    }*/

    /+ template <typename Char, if_compatible_char<Char> = true> +/
    this(Char,)(ref const(Char) c)/+ noexcept+/ if (if_compatible_char!Char)
    {
        this(&c, 1);
    }
    this(ref const(QChar) c)/+ noexcept+/
    {
        this(&c, 1);
    }

    /+ template <typename Char, typename Container = decltype(QChar::fromUcs4(U'x')),
              std::enable_if_t<std::is_same_v<Char, char32_t>, bool> = true> +/
    /+ constexpr QAnyStringView(Char c, Container &&capacity = {})
        : QAnyStringView(capacity = QChar::fromUcs4(c)) {} +/

    this(QStringView v)/+ noexcept+/
    {
        this(v.data(), lengthHelperContainer(v));
    }

    /+ template <bool UseChar8T> +/
    this(bool UseChar8T)(QBasicUtf8StringView!(UseChar8T) v)/+ noexcept+/
    {
        this(v.data(), lengthHelperContainer(v));
    }

    /+ template <typename Char, size_t Size, if_compatible_char<Char> = true> +/
    /+ [[nodiscard]] +/ static QAnyStringView fromArray(Char,size_t Size,)(ref const(Char)[Size] string)/+ noexcept+/ if (if_compatible_char!Char)
    { return QAnyStringView(string, Size); }

    // defined in qstring.h:
    /+ template <typename Visitor> +/
    /+ inline constexpr decltype(auto) visit(Visitor &&v) const; +/

    /+ [[nodiscard]] +/ pragma(inline, true) QString toString() const
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.convertToQString(this);
    } // defined in qstring.h

    /+ [[nodiscard]] +/ qsizetype size() const/+ noexcept+/ { return qsizetype(m_size & SizeMask); }
    /+ [[nodiscard]] +/ const(void)* data() const/+ noexcept+/ { return m_data; }

    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ static int compare(QAnyStringView lhs, QAnyStringView rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ static bool equal(QAnyStringView lhs, QAnyStringView rhs)/+ noexcept+/;

    extern(D) static immutable bool detects_US_ASCII_at_compile_time =
/+ #ifdef __cpp_lib_is_constant_evaluated +/
            mixin((defined!"__cpp_lib_is_constant_evaluated") ? q{
                    true
                } : q{
        /+ #else +/
                    false
                })/+ #endif +/
                ;
    //
    // STL compatibility API:
    //
/+    /+ [[nodiscard]] +/ QChar front() const
    {
        return visit(/+ [] +/ (auto that) { return QAnyStringView.toQChar(that.front()); });
    } // NOT noexcept!
    /+ [[nodiscard]] +/ QChar back() const
    {
        return visit(/+ [] +/ (auto that) { return QAnyStringView.toQChar(that.back()); });
    } +/ // NOT noexcept!
    /+ [[nodiscard]] +/ bool empty() const/+ noexcept+/ { return size() == 0; }
    /+ [[nodiscard]] +/ qsizetype size_bytes() const/+ noexcept+/
    { return size() * charSize(); }

    //
    // Qt compatibility API:
    //
    /+ [[nodiscard]] +/ bool isNull() const/+ noexcept+/ { return !m_data; }
    /+ [[nodiscard]] +/ bool isEmpty() const/+ noexcept+/ { return empty(); }
    /+ [[nodiscard]] +/ qsizetype length() const/+ noexcept+/
    { return size(); }

private:
    /+ [[nodiscard]] friend inline bool operator==(QAnyStringView lhs, QAnyStringView rhs) noexcept
    { return QAnyStringView::equal(lhs, rhs); } +/
    /+ [[nodiscard]] friend inline bool operator!=(QAnyStringView lhs, QAnyStringView rhs) noexcept
    { return !QAnyStringView::equal(lhs, rhs); } +/

/+ #if defined(__cpp_impl_three_way_comparison) && !defined(Q_QDOC)
    [[nodiscard]] friend inline auto operator<=>(QAnyStringView lhs, QAnyStringView rhs) noexcept
    { return QAnyStringView::compare(lhs, rhs) <=> 0; }
#else +/
    /+ [[nodiscard]] friend inline bool operator<=(QAnyStringView lhs, QAnyStringView rhs) noexcept
    { return QAnyStringView::compare(lhs, rhs) <= 0; } +/
    /+ [[nodiscard]] friend inline bool operator>=(QAnyStringView lhs, QAnyStringView rhs) noexcept
    { return QAnyStringView::compare(lhs, rhs) >= 0; } +/
    /+ [[nodiscard]] friend inline bool operator<(QAnyStringView lhs, QAnyStringView rhs) noexcept
    { return QAnyStringView::compare(lhs, rhs) < 0; } +/
    /+ [[nodiscard]] friend inline bool operator>(QAnyStringView lhs, QAnyStringView rhs) noexcept
    { return QAnyStringView::compare(lhs, rhs) > 0; } +/
/+ #endif +/

    // TODO: Optimize by inverting and storing the flags in the low bits and
    //       the size in the high.
    //static assert(/+ std:: +/is_same_v!(/+ std:: +/size_t, size_t));
    static assert(size_t.sizeof == qsizetype.sizeof);
    extern(D) static immutable size_t SizeMask = size_t.max / 4;
    extern(D) static immutable size_t Latin1Flag = SizeMask + 1;
    extern(D) static immutable size_t TwoByteCodePointFlag = Latin1Flag << 1;
    extern(D) static immutable size_t TypeMask = size_t.max & ~SizeMask;
    static assert(TypeMask == (Latin1Flag|TwoByteCodePointFlag));
    // HI HI LO LO ...
    //  0  0 SZ SZ  Utf8
    //  0  1 SZ SZ  Latin1
    //  1  0 SZ SZ  Utf16
    //  1  1 SZ SZ  Unused
    //  ^  ^ latin1
    //  | sizeof code-point == 2
    enum Tag : size_t {
        Utf8     = 0,
        Latin1   = Latin1Flag,
        Utf16    = TwoByteCodePointFlag,
        Unused   = TypeMask,
    }
    /+ [[nodiscard]] +/ Tag tag() const/+ noexcept+/ { return cast(Tag)(m_size & TypeMask); }
    /+ [[nodiscard]] +/ bool isUtf16() const/+ noexcept+/ { return tag() == Tag.Utf16; }
    /+ [[nodiscard]] +/ bool isUtf8() const/+ noexcept+/ { return tag() == Tag.Utf8; }
    /+ [[nodiscard]] +/ bool isLatin1() const/+ noexcept+/ { return tag() == Tag.Latin1; }
    /+ [[nodiscard]] +/ QStringView asStringView() const
    { return (){ (mixin(Q_ASSERT(q{QAnyStringView.isUtf16()})));
return QStringView(m_data_utf16, size());
}(); }
    /+ [[nodiscard]] +/ /+ q_no_char8_t:: +/QUtf8StringView asUtf8StringView() const
    { return (){ (mixin(Q_ASSERT(q{QAnyStringView.isUtf8()})));
return /+ q_no_char8_t:: +/qt.core.utf8stringview.QUtf8StringView(m_data_utf8, size());
}(); }
    /+ [[nodiscard]] +/ pragma(inline, true) QLatin1StringView asLatin1StringView() const
    {
        (mixin(Q_ASSERT(q{QAnyStringView.isLatin1()})));
        return QLatin1StringView(m_data_utf8, size());
    }
    /+ [[nodiscard]] +/ size_t charSize() const/+ noexcept+/ { return isUtf16() ? 2 : 1; }
    /+ Q_ALWAYS_INLINE +/ pragma(inline, true) void verify(qsizetype pos, qsizetype n = 0) const
    {
        (mixin(Q_ASSERT(q{pos >= 0})));
        (mixin(Q_ASSERT(q{pos <= QAnyStringView.size()})));
        (mixin(Q_ASSERT(q{n >= 0})));
        (mixin(Q_ASSERT(q{n <= QAnyStringView.size() - pos})));
    }
    union {
        const(void)* m_data;
        const(char)* m_data_utf8;
        const(wchar)* m_data_utf16;
    }
    size_t m_size;
    /+ friend class ::tst_QAnyStringView; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QAnyStringView, Q_PRIMITIVE_TYPE); +/

/+ [[nodiscard]] +/ pragma(inline, true) QAnyStringView qToAnyStringViewIgnoringNull(QStringLike, /+ std::enable_if_t<std::disjunction_v<
        std::is_same<QStringLike, QString>,
        std::is_same<QStringLike, QByteArray>
    >, bool> +/ /+ = true +/)(ref const(QStringLike) s)/+ noexcept+/
{ return QAnyStringView(s.data(), s.size()); }

