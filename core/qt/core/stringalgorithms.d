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
module qt.core.stringalgorithms;
extern(C++):

import qt.config;
import qt.core.anystringview;
import qt.core.bytearray;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.qchar;
import qt.core.regularexpression;
import qt.core.string;
import qt.core.stringview;
import qt.core.utf8stringview;
import qt.helpers;

/+ #if 0
#pragma qt_class(QStringAlgorithms)
#endif


#if QT_VERSION >= QT_VERSION_CHECK(7, 0, 0)
# define QT_BEGIN_HAS_CHAR8_T_NAMESPACE inline namespace q_has_char8_t {
# define QT_BEGIN_NO_CHAR8_T_NAMESPACE namespace q_no_char8_t {
#else
# define QT_BEGIN_HAS_CHAR8_T_NAMESPACE namespace q_has_char8_t {
# define QT_BEGIN_NO_CHAR8_T_NAMESPACE inline namespace q_no_char8_t {
#endif
#define QT_END_HAS_CHAR8_T_NAMESPACE }
#define QT_END_NO_CHAR8_T_NAMESPACE }


// declare namespaces:
QT_BEGIN_HAS_CHAR8_T_NAMESPACE
QT_END_HAS_CHAR8_T_NAMESPACE
QT_BEGIN_NO_CHAR8_T_NAMESPACE
QT_END_NO_CHAR8_T_NAMESPACE +/

extern(C++, "QtPrivate") {

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype qustrlen(const(wchar)* str)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ const(wchar)* qustrchr(QStringView str, wchar ch)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QStringView   lhs, QStringView   rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QStringView   lhs, QLatin1String rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QStringView   lhs, QBasicUtf8StringView!(false) rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QLatin1String lhs, QStringView   rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QLatin1String lhs, QLatin1String rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QLatin1String lhs, QBasicUtf8StringView!(false) rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QBasicUtf8StringView!(false) lhs, QStringView   rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QBasicUtf8StringView!(false) lhs, QLatin1String rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QBasicUtf8StringView!(false) lhs, QBasicUtf8StringView!(false) rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool equalStrings(QStringView   lhs, QStringView   rhs)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool equalStrings(QStringView   lhs, QLatin1String rhs)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool equalStrings(QStringView   lhs, QBasicUtf8StringView!(false) rhs)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool equalStrings(QLatin1String lhs, QStringView   rhs)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool equalStrings(QLatin1String lhs, QLatin1String rhs)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool equalStrings(QLatin1String lhs, QBasicUtf8StringView!(false) rhs)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool equalStrings(QBasicUtf8StringView!(false) lhs, QStringView   rhs)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool equalStrings(QBasicUtf8StringView!(false) lhs, QLatin1String rhs)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool equalStrings(QBasicUtf8StringView!(false) lhs, QBasicUtf8StringView!(false) rhs)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool startsWith(QStringView   haystack, QStringView   needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool startsWith(QStringView   haystack, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool startsWith(QLatin1String haystack, QStringView   needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool startsWith(QLatin1String haystack, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool endsWith(QStringView   haystack, QStringView   needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool endsWith(QStringView   haystack, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool endsWith(QLatin1String haystack, QStringView   needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool endsWith(QLatin1String haystack, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype findString(QStringView haystack, qsizetype from, QStringView needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype findString(QStringView haystack, qsizetype from, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype findString(QLatin1String haystack, qsizetype from, QStringView needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype findString(QLatin1String haystack, qsizetype from, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype lastIndexOf(QStringView haystack, qsizetype from, QStringView needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype lastIndexOf(QStringView haystack, qsizetype from, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype lastIndexOf(QLatin1String haystack, qsizetype from, QStringView needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype lastIndexOf(QLatin1String haystack, qsizetype from, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ QStringView   trimmed(QStringView   s)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ QLatin1String trimmed(QLatin1String s)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype count(QStringView haystack, QChar needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype count(QStringView haystack, QStringView needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;

/+ #if QT_CONFIG(regularexpression) +/
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ qsizetype indexOf(QStringView haystack,
                                              ref const(QRegularExpression) re,
                                              qsizetype from = 0,
                                              QRegularExpressionMatch* rmatch = null);
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ qsizetype lastIndexOf(QStringView haystack,
                                                  ref const(QRegularExpression) re,
                                                  qsizetype from = -1,
                                                  QRegularExpressionMatch* rmatch = null);
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ bool contains(QStringView haystack,
                                          ref const(QRegularExpression) re,
                                          QRegularExpressionMatch* rmatch = null);
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ qsizetype count(QStringView haystack, ref const(QRegularExpression) re);
/+ #endif +/

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ QString convertToQString(QAnyStringView s);

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ QByteArray convertToLatin1(QStringView str);
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ QByteArray convertToUtf8(QStringView str);
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ QByteArray convertToLocal8Bit(QStringView str);
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ QList!(uint) convertToUcs4(QStringView str); // ### Qt 7 char32_t

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool isRightToLeft(QStringView string)/+ noexcept+/;

/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool isAscii(QLatin1String s)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool isAscii(QStringView   s)/+ noexcept+/;
/+ [[nodiscard]] constexpr inline                   bool isLatin1(QLatin1String s) noexcept; +/
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool isLatin1(QStringView   s)/+ noexcept+/;
/+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool isValidUtf16(QStringView s)/+ noexcept+/;

} // namespace QtPRivate

