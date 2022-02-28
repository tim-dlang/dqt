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

/+ #if 0
#pragma qt_class(QByteArrayAlgorithms)
#endif +/



extern(C++, "QtPrivate") {

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/
bool startsWith(QByteArrayView haystack, QByteArrayView needle)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/
bool endsWith(QByteArrayView haystack, QByteArrayView needle)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/
qsizetype findByteArray(QByteArrayView haystack, qsizetype from, QByteArrayView needle)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/
qsizetype lastIndexOf(QByteArrayView haystack, qsizetype from, QByteArrayView needle)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/
qsizetype count(QByteArrayView haystack, QByteArrayView needle)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ int compareMemory(QByteArrayView lhs, QByteArrayView rhs);

} // namespace QtPrivate

/*****************************************************************************
  Safe and portable C string functions; extensions to standard string.h
 *****************************************************************************/

/+ Q_CORE_EXPORT +/ char* qstrdup(const(char)* );

pragma(inline, true) size_t qstrlen(const(char)* str)
{
    import core.stdc.string;

    /+ QT_WARNING_PUSH
#if defined(Q_CC_GNU) && Q_CC_GNU >= 900 && Q_CC_GNU < 1000
    // spurious compiler warning (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=91490#c6)
    // when Q_DECLARE_METATYPE_TEMPLATE_1ARG is used
    QT_WARNING_DISABLE_GCC("-Wstringop-overflow")
#endif +/
    return str ? strlen(str) : 0;
    /+ QT_WARNING_POP +/
}

pragma(inline, true) size_t qstrnlen(const(char)* str, size_t maxlen)
{
    size_t length = 0;
    if (str) {
        while (length < maxlen && *str++)
            length++;
    }
    return length;
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

