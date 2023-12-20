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
import std.traits;
version (D_LP64) {} else
    import core.stdc.config;

/+ #ifndef QFLAGS_H +/
/+ #define QFLAGS_H +/


/// Binding for C++ class [QFlag](https://doc.qt.io/qt-5/qflag.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct QFlag
{
private:
    int i;
public:
    pragma(inline, true) this(int value)/+ noexcept+/
    {
        this.i = value;
    }
    pragma(inline, true) auto opCast(T : int)() const/+ noexcept+/ { return i; }
    pragma(inline, true) int toInt() const/+ noexcept+/ { return i; }
    alias toInt this;

/+ #if !defined(Q_CC_MSVC)
    // Microsoft Visual Studio has buggy behavior when it comes to
    // unsigned enums: even if the enum is unsigned, the enum tags are
    // always signed
#  if !defined(__LP64__) && !defined(Q_CLANG_QDOC) +/
    version (D_LP64) {} else
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
    /+pragma(inline, true) auto opCast(T : uint)() const/+ noexcept+/ { return uint(i); }+/
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
    /+pragma(inline, true) auto opCast(T : int)() const/+ noexcept+/ { return i; }+/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QIncompatibleFlag, Q_PRIMITIVE_TYPE);


#ifndef Q_NO_TYPESAFE_FLAGS +/

/// Binding for C++ class [QFlags](https://doc.qt.io/qt-5/qflags.html).
extern(C++, class) struct QFlags(Enum)
{
private:
    static assert(Enum.sizeof <= int.sizeof,
                          "QFlags uses an int as storage, so an enum with underlying " ~
                          "long long will overflow.");
    static assert(is(Enum == enum), "QFlags is only usable on enumeration types.");

/+ #if QT_DEPRECATED_SINCE(5,15) +/
    struct Private;
    alias Zero = int/+ Private::* +/*;
/+ #endif +/
    /+ template <typename E> +/ /+ friend QDataStream &operator>>(QDataStream &, QFlags<E> &); +/
    /+ template <typename E> +/ /+ friend QDataStream &operator<<(QDataStream &, QFlags<E>); +/
public:
/+ #if defined(Q_CC_MSVC) || defined(Q_CLANG_QDOC)
    // see above for MSVC
    // the definition below is too complex for qdoc
    typedef int Int;
#else +/
    static if (isUnsigned!(OriginalType!Enum))
        alias Int = uint;
    else
        alias Int = int;
/+ #endif +/
    alias enum_type = Enum;
    // compiler-generated copy/move ctor/assignment operators are fine!
/+ #ifdef Q_CLANG_QDOC
    inline QFlags(const QFlags &other);
    inline QFlags &operator=(const QFlags &other);
#endif +/
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.i = 0;
    }+/
    pragma(inline, true) this(Enum flags)/+ noexcept+/
    {
        this.i = Int(flags);
    }
/+ #if QT_DEPRECATED_SINCE(5,15) +/
    /+ QT_DEPRECATED_X("Use default constructor instead") +/ pragma(inline, true) this(Zero)/+ noexcept+/
    {
        this.i = 0;
    }
/+ #endif +/
    pragma(inline, true) this(QFlag flag)/+ noexcept+/
    {
        this.i = flag;
    }

    /+ inline QFlags(std::initializer_list<Enum> flags) noexcept
        : i(initializer_list_helper(flags.begin(), flags.end())) {} +/

    pragma(inline, true) ref QFlags opOpAssign(string op)(int mask)/+ noexcept+/ if (op == "&") { i &= mask; return this; }
    pragma(inline, true) ref QFlags opOpAssign(string op)(uint mask)/+ noexcept+/ if (op == "&") { i &= mask; return this; }
    pragma(inline, true) ref QFlags opOpAssign(string op)(Enum mask)/+ noexcept+/ if (op == "&") { i &= Int(mask); return this; }
    pragma(inline, true) ref QFlags opOpAssign(string op)(QFlags other)/+ noexcept+/ if (op == "|") { i |= other.i; return this; }
    pragma(inline, true) ref QFlags opOpAssign(string op)(Enum other)/+ noexcept+/ if (op == "|") { i |= Int(other); return this; }
    /+pragma(inline, true) ref QFlags operator ^=(QFlags other)/+ noexcept+/ { i ^= other.i; return this; }+/
    /+pragma(inline, true) ref QFlags operator ^=(Enum other)/+ noexcept+/ { i ^= Int(other); return this; }+/

    pragma(inline, true) auto opCast(T : Int)() const/+ noexcept+/ { return i; }
    pragma(inline, true) Int toInt() const/+ noexcept+/ { return i; }
    alias toInt this;

    pragma(inline, true) QFlags opBinary(string op)(QFlags other) const/+ noexcept+/ if (op == "|") { return QFlags(QFlag(i | other.i)); }
    pragma(inline, true) QFlags opBinary(string op)(Enum other) const/+ noexcept+/ if (op == "|") { return QFlags(QFlag(i | Int(other))); }
    /+pragma(inline, true) QFlags operator ^(QFlags other) const/+ noexcept+/ { return QFlags(QFlag(i ^ other.i)); }+/
    /+pragma(inline, true) QFlags operator ^(Enum other) const/+ noexcept+/ { return QFlags(QFlag(i ^ Int(other))); }+/
    pragma(inline, true) QFlags opBinary(string op)(int mask) const/+ noexcept+/ if (op == "&") { return QFlags(QFlag(i & mask)); }
    pragma(inline, true) QFlags opBinary(string op)(uint mask) const/+ noexcept+/ if (op == "&") { return QFlags(QFlag(i & mask)); }
    pragma(inline, true) QFlags opBinary(string op)(Enum other) const/+ noexcept+/ if (op == "&") { return QFlags(QFlag(i & Int(other))); }
    QFlags opBinary(string op)(QFlags other) const if (op == "&") { return QFlags(QFlag(i & other.i)); }
    /+pragma(inline, true) QFlags operator ~() const/+ noexcept+/ { return QFlags(QFlag(~i)); }+/

    /+pragma(inline, true) bool operator !() const/+ noexcept+/ { return !i; }+/

    pragma(inline, true) bool testFlag(Enum flag) const/+ noexcept+/ { return (i & Int(flag)) == Int(flag) && (Int(flag) != 0 || i == Int(flag) ); }
    /+ inline QFlags &setFlag(Enum flag, bool on = true) noexcept
    {
        return on ? (*this |= flag) : (*this &= ~Int(flag));
    } +/

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

#define Q_DECLARE_INCOMPATIBLE_FLAGS(Flags) \
Q_DECL_CONSTEXPR inline QIncompatibleFlag operator|(Flags::enum_type f1, int f2) noexcept \
{ return QIncompatibleFlag(int(f1) | f2); }

#define Q_DECLARE_OPERATORS_FOR_FLAGS(Flags) \
Q_DECL_CONSTEXPR inline QFlags<Flags::enum_type> operator|(Flags::enum_type f1, Flags::enum_type f2) noexcept \
{ return QFlags<Flags::enum_type>(f1) | f2; } \
Q_DECL_CONSTEXPR inline QFlags<Flags::enum_type> operator|(Flags::enum_type f1, QFlags<Flags::enum_type> f2) noexcept \
{ return f2 | f1; } Q_DECLARE_INCOMPATIBLE_FLAGS(Flags) +/


/+ #else /* Q_NO_TYPESAFE_FLAGS */

#ifndef Q_MOC_RUN
#define Q_DECLARE_FLAGS(Flags, Enum)\
typedef uint Flags;
#endif

#define Q_DECLARE_OPERATORS_FOR_FLAGS(Flags)

#endif +/ /* Q_NO_TYPESAFE_FLAGS */


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
