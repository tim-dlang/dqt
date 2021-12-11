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
import qt.core.bytearray;
import qt.core.global;
import qt.core.namespace;
import qt.core.string;
import qt.core.stringview;
import qt.core.vector;
import qt.helpers;

/+ #if 0
#pragma qt_class(QStringAlgorithms)
#endif


class QByteArray;
class QLatin1String;
class QStringView;
class QChar;
template <typename T> class QVector; +/

extern(C++, "QtPrivate") {

/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype qustrlen(const(ushort)* str)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ const(ushort)* qustrchr(QStringView str, ushort ch)/+ noexcept+/;

/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QStringView   lhs, QStringView   rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QStringView   lhs, QLatin1String rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QLatin1String lhs, QStringView   rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ int compareStrings(QLatin1String lhs, QLatin1String rhs, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;


/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool startsWith(QStringView   haystack, QStringView   needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool startsWith(QStringView   haystack, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool startsWith(QLatin1String haystack, QStringView   needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool startsWith(QLatin1String haystack, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;

/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool endsWith(QStringView   haystack, QStringView   needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool endsWith(QStringView   haystack, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool endsWith(QLatin1String haystack, QStringView   needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool endsWith(QLatin1String haystack, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;

/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype findString(QStringView haystack, qsizetype from, QStringView needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype findString(QStringView haystack, qsizetype from, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype findString(QLatin1String haystack, qsizetype from, QStringView needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype findString(QLatin1String haystack, qsizetype from, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;

/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype lastIndexOf(QStringView haystack, qsizetype from, QStringView needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype lastIndexOf(QStringView haystack, qsizetype from, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype lastIndexOf(QLatin1String haystack, qsizetype from, QStringView needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ qsizetype lastIndexOf(QLatin1String haystack, qsizetype from, QLatin1String needle, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;

/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ QStringView   trimmed(QStringView   s)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ QLatin1String trimmed(QLatin1String s)/+ noexcept+/;

/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ QByteArray convertToLatin1(QStringView str);
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ QByteArray convertToUtf8(QStringView str);
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ QByteArray convertToLocal8Bit(QStringView str);
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ QVector!(uint) convertToUcs4(QStringView str);

/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool isRightToLeft(QStringView string)/+ noexcept+/;

/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool isAscii(QLatin1String s)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool isAscii(QStringView   s)/+ noexcept+/;
/+ Q_REQUIRED_RESULT inline            bool isLatin1(QLatin1String s) noexcept; +/
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool isLatin1(QStringView   s)/+ noexcept+/;
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ bool isValidUtf16(QStringView s)/+ noexcept+/;

} // namespace QtPRivate

