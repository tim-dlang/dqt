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
module qt.core.bytearrayalgorithms;
extern(C++):

import qt.config;
import qt.core.bytearrayview;
import qt.core.global;
import qt.core.namespace;
import qt.helpers;
import std.traits;

/+ #if 0
#pragma qt_class(QByteArrayAlgorithms)
#endif +/



extern(C++, "QtPrivate") {

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/
bool startsWith(QByteArrayView haystack, QByteArrayView needle) nothrow;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/
bool endsWith(QByteArrayView haystack, QByteArrayView needle) nothrow;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/
qsizetype findByteArray(QByteArrayView haystack, qsizetype from, QByteArrayView needle) nothrow;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/
qsizetype lastIndexOf(QByteArrayView haystack, qsizetype from, QByteArrayView needle) nothrow;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/
qsizetype count(QByteArrayView haystack, QByteArrayView needle) nothrow;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ int compareMemory(QByteArrayView lhs, QByteArrayView rhs);

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ QByteArrayView trimmed(QByteArrayView s) nothrow;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool isValidUtf8(QByteArrayView s) nothrow;

extern(C++, class) struct ParsedNumber(T)
{
private:
    T m_value;
    /+ quint32 m_error : 1; +/
    uint bitfieldData_m_error = 1;
    quint32 m_error() const nothrow
    {
        return (bitfieldData_m_error >> 0) & 0x1;
    }
    quint32 m_error(quint32 value) nothrow
    {
        bitfieldData_m_error = (bitfieldData_m_error & ~0x1) | ((value & 0x1) << 0);
        return value;
    }
    /+ quint32 m_reserved : 31; +/
    quint32 m_reserved() const nothrow
    {
        return (bitfieldData_m_error >> 1) & 0x7fffffff;
    }
    quint32 m_reserved(quint32 value) nothrow
    {
        bitfieldData_m_error = (bitfieldData_m_error & ~0xfffffffe) | ((value & 0x7fffffff) << 1);
        return value;
    }
    void* m_reserved2 = null;
public:
    @disable this();
    /+this() nothrow
    {
        this.m_value = typeof(this.m_value)();
        this.m_error = true;
        this.m_reserved = 0;
    }+/
    /+ explicit +/this(T v)
    {
        this.m_value = v;
        this.m_error = false;
        this.m_reserved = 0;
    }

    // minimal optional-like API:
    /+ explicit +/ auto opCast(T : bool)() const nothrow { return !m_error; }
    ref T opUnary(string op)() if (op == "*") { (mixin(Q_ASSERT(q{*this}))); return m_value; }
    ref const(T) opUnary(string op)() const if (op == "*") { (mixin(Q_ASSERT(q{*this}))); return m_value; }
    /+T* operator ->() nothrow { return this ? &m_value : null; }+/
    /+const(T)* operator ->() const nothrow { return this ? &m_value : null; }+/
    /+ template <typename U> +/ // not = T, as that'd allow calls that are incompatible with std::optional
    /+ T value_or(U &&u) const { return *this ? m_value : T(std::forward<U>(u)); } +/
    T value_or(U)(U u) const { return *this ? m_value : T(u); }
}

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ ParsedNumber!(double) toDouble(QByteArrayView a) nothrow;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ ParsedNumber!(float) toFloat(QByteArrayView a) nothrow;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ ParsedNumber!(qlonglong) toSignedInteger(QByteArrayView data, int base);
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ ParsedNumber!(qulonglong) toUnsignedInteger(QByteArrayView data, int base);

// QByteArrayView has incomplete type here, and we can't include qbytearrayview.h,
// since it includes qbytearrayalgorithms.h. Use the ByteArrayView template type as
// a workaround.
pragma(inline, true) T toIntegral(T, ByteArrayView,
          )(ByteArrayView data, bool* ok, int base)
{
    static if (isUnsigned!(T))
        const val = toUnsignedInteger(data, base);
    else
        const val = toSignedInteger(data, base);
    const(bool) failed = !val || cast(T)(*val) != *val;
    if (ok)
        *ok = !failed;
    if (failed)
        return 0;
    return cast(T)(*val);
}

} // namespace QtPrivate

/*****************************************************************************
  Safe and portable C string functions; extensions to standard string.h
 *****************************************************************************/

/+ Q_CORE_EXPORT +/ char* qstrdup(const(char)* );

pragma(inline, true) size_t qstrlen(const(char)* str) nothrow
{
    import core.stdc.string;

    /+ QT_WARNING_PUSH
#if defined(Q_CC_GNU_ONLY) && Q_CC_GNU >= 900 && Q_CC_GNU < 1000
    // spurious compiler warning (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91490#c6)
    // when Q_DECLARE_METATYPE_TEMPLATE_1ARG is used
    QT_WARNING_DISABLE_GCC("-Wstringop-overflow")
#endif +/
    return str ? strlen(str) : 0;
    /+ QT_WARNING_POP +/
}

pragma(inline, true) size_t qstrnlen(const(char)* str, size_t maxlen) nothrow
{
    import core.stdc.string;

    if (!str)
        return 0;
    auto end = static_cast!(const(char)*)(memchr(str, '\0', maxlen));
    return end ? end - str : maxlen;
}

// implemented in qbytearray.cpp
/+ Q_CORE_EXPORT +/ char* qstrcpy(char* dst, const(char)* src);
/+ Q_CORE_EXPORT +/ char* qstrncpy(char* dst, const(char)* src, size_t len);

/+ Q_CORE_EXPORT +/ int qstrcmp(const(char)* str1, const(char)* str2);

pragma(inline, true) int qstrncmp(const(char)* str1, const(char)* str2, size_t len)
{
    import core.stdc.string;

    return (str1 && str2) ? strncmp(str1, str2, len)
        : (str1 ? 1 : (str2 ? -1 : 0));
}
/+ Q_CORE_EXPORT +/ int qstricmp(const(char)* , const(char)* );
/+ Q_CORE_EXPORT +/ int qstrnicmp(const(char)* , const(char)* , size_t len);
/+ Q_CORE_EXPORT +/ int qstrnicmp(const(char)* , qsizetype, const(char)* , qsizetype /+ = -1 +/);

// implemented in qvsnprintf.cpp
// /+ Q_CORE_EXPORT +/ int qvsnprintf(char* str, size_t n, const(char)* fmt, va_list ap);
// /+ Q_CORE_EXPORT +/ int qsnprintf(char* str, size_t n, const(char)* fmt, ...);

// qChecksum: Internet checksum
/+ Q_CORE_EXPORT +/ quint16 qChecksum(QByteArrayView data, /+ Qt:: +/qt.core.namespace.ChecksumType standard = /+ Qt:: +/qt.core.namespace.ChecksumType.ChecksumIso3309);

