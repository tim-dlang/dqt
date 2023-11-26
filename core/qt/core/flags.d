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
module qt.core.flags;
extern(C++):

import qt.config;
import qt.core.typeinfo;
import qt.helpers;
version(D_LP64){}else
    import core.stdc.config;

/+ #ifndef QFLAGS_H +/
/+ #define QFLAGS_H +/


/// Binding for C++ class [QFlag](https://doc.qt.io/qt-6/qflag.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct QFlag
{
private:
    int i;
public:
    pragma(inline, true) this(int value)/+ noexcept+/
    {
        this.i = value;
    }
    pragma(inline, true) /+ Q_IMPLICIT +/ auto opCast(T : int)() const/+ noexcept+/ { return i; }
    pragma(inline, true) int toInt() const/+ noexcept+/ { return i; }
    alias toInt this;

/+ #if !defined(Q_CC_MSVC)
    // Microsoft Visual Studio has buggy behavior when it comes to
    // unsigned enums: even if the enum is unsigned, the enum tags are
    // always signed
#  if !defined(__LP64__) && !defined(Q_CLANG_QDOC) +/
    version(D_LP64){}else
    {
        pragma(inline, true) this(cpp_long value)/+ noexcept+/
        {
            this.i = cast(int) (value);
        }
        pragma(inline, true) this(cpp_ulong value)/+ noexcept+/
        {
            this.i = cast(int) (long(value));
        }
    }
/+ #  endif +/
    pragma(inline, true) this(uint value)/+ noexcept+/
    {
        this.i = int(value);
    }
    pragma(inline, true) this(short value)/+ noexcept+/
    {
        this.i = int(value);
    }
    pragma(inline, true) this(ushort value)/+ noexcept+/
    {
        this.i = int(uint(value));
    }
    /+pragma(inline, true) /+ Q_IMPLICIT +/ auto opCast(T : uint)() const/+ noexcept+/ { return uint(i); }+/
/+ #endif +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QFlag, Q_PRIMITIVE_TYPE); +/

@Q_PRIMITIVE_TYPE extern(C++, class) struct QIncompatibleFlag
{
private:
    int i;
public:
    /+ explicit +/pragma(inline, true) this(int value)/+ noexcept+/
    {
        this.i = value;
    }
    /+pragma(inline, true) /+ Q_IMPLICIT +/ auto opCast(T : int)() const/+ noexcept+/ { return i; }+/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QIncompatibleFlag, Q_PRIMITIVE_TYPE); +/


/// Binding for C++ class [QFlags](https://doc.qt.io/qt-6/qflags.html).
extern(C++, class) struct QFlags(Enum)
{
private:
    static assert((Enum.sizeof <= int.sizeof),
                  "QFlags uses an int as storage, so an enum with underlying " ~
                  "long long will overflow.");
    static assert(is(Enum == enum), "QFlags is only usable on enumeration types.");

public:
/+ #if defined(Q_CC_MSVC) || defined(Q_CLANG_QDOC)
    // see above for MSVC
    // the definition below is too complex for qdoc
    typedef int Int;
#else +/
    /+ typename std::conditional<
                std::is_unsigned<typename std::underlying_type<Enum>::type>::value,
                unsigned int,
                signed int
            >::type +/alias Int = int;
/+ #endif +/
    alias enum_type = Enum;
    // compiler-generated copy/move ctor/assignment operators are fine!
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.i = 0;
    }+/
    pragma(inline, true) this(Enum flags)/+ noexcept+/
    {
        this.i = Int(flags);
    }
    pragma(inline, true) this(QFlag flag)/+ noexcept+/
    {
        this.i = flag;
    }

    /+ constexpr inline QFlags(std::initializer_list<Enum> flags) noexcept
        : i(initializer_list_helper(flags.begin(), flags.end())) {} +/

    pragma(inline, true) static QFlags fromInt(Int i)/+ noexcept+/ { return QFlags(QFlag(i)); }
    pragma(inline, true) Int toInt() const/+ noexcept+/ { return i; }

    pragma(inline, true) ref QFlags opOpAssign(string op)(int mask)/+ noexcept+/ if (op == "&") { i &= mask; return this; }
    pragma(inline, true) ref QFlags opOpAssign(string op)(uint mask)/+ noexcept+/ if (op == "&") { i &= mask; return this; }
    pragma(inline, true) ref QFlags opOpAssign(string op)(QFlags mask)/+ noexcept+/ if (op == "&") { i &= mask.i; return this; }
    pragma(inline, true) ref QFlags opOpAssign(string op)(Enum mask)/+ noexcept+/ if (op == "&") { i &= Int(mask); return this; }
    pragma(inline, true) ref QFlags opOpAssign(string op)(QFlags other)/+ noexcept+/ if (op == "|") { i |= other.i; return this; }
    pragma(inline, true) ref QFlags opOpAssign(string op)(Enum other)/+ noexcept+/ if (op == "|") { i |= Int(other); return this; }
    /+pragma(inline, true) ref QFlags operator ^=(QFlags other)/+ noexcept+/ { i ^= other.i; return this; }+/
    /+pragma(inline, true) ref QFlags operator ^=(Enum other)/+ noexcept+/ { i ^= Int(other); return this; }+/

    pragma(inline, true) auto opCast(T : Int)() const/+ noexcept+/ { return i; }
    alias toInt this;

    pragma(inline, true) QFlags opBinary(string op)(QFlags other) const/+ noexcept+/ if (op == "|") { return QFlags(QFlag(i | other.i)); }
    pragma(inline, true) QFlags opBinary(string op)(Enum other) const/+ noexcept+/ if (op == "|") { return QFlags(QFlag(i | Int(other))); }
    /+pragma(inline, true) QFlags operator ^(QFlags other) const/+ noexcept+/ { return QFlags(QFlag(i ^ other.i)); }+/
    /+pragma(inline, true) QFlags operator ^(Enum other) const/+ noexcept+/ { return QFlags(QFlag(i ^ Int(other))); }+/
    pragma(inline, true) QFlags opBinary(string op)(int mask) const/+ noexcept+/ if (op == "&") { return QFlags(QFlag(i & mask)); }
    pragma(inline, true) QFlags opBinary(string op)(uint mask) const/+ noexcept+/ if (op == "&") { return QFlags(QFlag(i & mask)); }
    pragma(inline, true) QFlags opBinary(string op)(QFlags other) const/+ noexcept+/ if (op == "&") { return QFlags(QFlag(i & other.i)); }
    pragma(inline, true) QFlags opBinary(string op)(Enum other) const/+ noexcept+/ if (op == "&") { return QFlags(QFlag(i & Int(other))); }
    /+pragma(inline, true) QFlags operator ~() const/+ noexcept+/ { return QFlags(QFlag(~i)); }+/

    pragma(inline, true) void opBinary(string op)(QFlags other) const/+ noexcept+/ if (op == "+") /+ = delete +/;
    pragma(inline, true) void opBinary(string op)(Enum other) const/+ noexcept+/ if (op == "+") /+ = delete +/;
    pragma(inline, true) void opBinary(string op)(int other) const/+ noexcept+/ if (op == "+") /+ = delete +/;
    pragma(inline, true) void opBinary(string op)(QFlags other) const/+ noexcept+/ if (op == "-") /+ = delete +/;
    pragma(inline, true) void opBinary(string op)(Enum other) const/+ noexcept+/ if (op == "-") /+ = delete +/;
    pragma(inline, true) void opBinary(string op)(int other) const/+ noexcept+/ if (op == "-") /+ = delete +/;

    /+pragma(inline, true) bool operator !() const/+ noexcept+/ { return !i; }+/

    pragma(inline, true) bool testFlag(Enum flag) const/+ noexcept+/ { return testFlags(QFlags(flag)); }
    pragma(inline, true) bool testFlags(QFlags flags) const/+ noexcept+/ { return flags.i ? ((i & flags.i) == flags.i) : i == Int(0); }
    pragma(inline, true) bool testAnyFlag(Enum flag) const/+ noexcept+/ { return testAnyFlags(QFlags(flag)); }
    pragma(inline, true) bool testAnyFlags(QFlags flags) const/+ noexcept+/ { return (i & flags.i) != Int(0); }
    /+ constexpr inline QFlags &setFlag(Enum flag, bool on = true) noexcept
    {
        return on ? (*this |= flag) : (*this &= ~QFlags(flag));
    } +/

    /+ friend constexpr inline bool operator==(QFlags lhs, QFlags rhs) noexcept
    { return lhs.i == rhs.i; } +/
    /+ friend constexpr inline bool operator!=(QFlags lhs, QFlags rhs) noexcept
    { return lhs.i != rhs.i; } +/
    /+ friend constexpr inline bool operator==(QFlags lhs, Enum rhs) noexcept
    { return lhs == QFlags(rhs); } +/
    /+ friend constexpr inline bool operator!=(QFlags lhs, Enum rhs) noexcept
    { return lhs != QFlags(rhs); } +/
    /+ friend constexpr inline bool operator==(Enum lhs, QFlags rhs) noexcept
    { return QFlags(lhs) == rhs; } +/
    /+ friend constexpr inline bool operator!=(Enum lhs, QFlags rhs) noexcept
    { return QFlags(lhs) != rhs; } +/

    template opDispatch(string name) if(__traits(hasMember, Enum, name))
    {
        enum opDispatch = QFlags(__traits(getMember, Enum, name));
    }

    bool opCast(T)() if (is(T == bool))
    {
        return i != 0;
    }

private:
    /+pragma(inline, true) static Int initializer_list_helper(/+ std:: +/initializer_list!(Enum).const_iterator it,
                                                                   /+ std:: +/initializer_list!(Enum).const_iterator end)/+
        noexcept+/
    {
        return (it == end ? Int(0) : (Int(*it) | initializer_list_helper(it + 1, end)));
    }+/

    Int i = 0;
}

/+ #ifndef Q_MOC_RUN
#define Q_DECLARE_FLAGS(Flags, Enum)\
typedef QFlags<Enum> Flags;
#endif

#define Q_DECLARE_OPERATORS_FOR_FLAGS(Flags) \
constexpr inline QFlags<Flags::enum_type> operator|(Flags::enum_type f1, Flags::enum_type f2) noexcept \
{ return QFlags<Flags::enum_type>(f1) | f2; } \
constexpr inline QFlags<Flags::enum_type> operator|(Flags::enum_type f1, QFlags<Flags::enum_type> f2) noexcept \
{ return f2 | f1; } \
constexpr inline QFlags<Flags::enum_type> operator&(Flags::enum_type f1, Flags::enum_type f2) noexcept \
{ return QFlags<Flags::enum_type>(f1) & f2; } \
constexpr inline QFlags<Flags::enum_type> operator&(Flags::enum_type f1, QFlags<Flags::enum_type> f2) noexcept \
{ return f2 & f1; } \
constexpr inline void operator+(Flags::enum_type f1, Flags::enum_type f2) noexcept = delete; \
constexpr inline void operator+(Flags::enum_type f1, QFlags<Flags::enum_type> f2) noexcept = delete; \
constexpr inline void operator+(int f1, QFlags<Flags::enum_type> f2) noexcept = delete; \
constexpr inline void operator-(Flags::enum_type f1, Flags::enum_type f2) noexcept = delete; \
constexpr inline void operator-(Flags::enum_type f1, QFlags<Flags::enum_type> f2) noexcept = delete; \
constexpr inline void operator-(int f1, QFlags<Flags::enum_type> f2) noexcept = delete; \
constexpr inline QIncompatibleFlag operator|(Flags::enum_type f1, int f2) noexcept \
{ return QIncompatibleFlag(int(f1) | f2); } \
constexpr inline void operator+(int f1, Flags::enum_type f2) noexcept = delete; \
constexpr inline void operator+(Flags::enum_type f1, int f2) noexcept = delete; \
constexpr inline void operator-(int f1, Flags::enum_type f2) noexcept = delete; \
constexpr inline void operator-(Flags::enum_type f1, int f2) noexcept = delete; +/


/+ #endif +/ // QFLAGS_H

template flagsFromStaticString(T, string str)
{
    enum flagsFromStaticString = (){
        T r;
        static foreach(element; dqtimported!q{std.array}.split(str, "|"))
        {
            r |= __traits(getMember, T.enum_type, dqtimported!q{std.array}.split(element, "::")[$-1]);
        }
        return r;
    }();
}
template enumFromStaticString(T, string str)
{
    enum enumFromStaticString = __traits(getMember, T, dqtimported!q{std.array}.split(str, "::")[$-1]);
}
