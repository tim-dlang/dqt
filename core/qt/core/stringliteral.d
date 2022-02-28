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
module qt.core.stringliteral;
extern(C++):

import qt.config;
import qt.core.arraydatapointer;
import qt.core.global;
import qt.helpers;

/+ #if 0
#pragma qt_class(QStringLiteral)
#endif


// all our supported compilers support Unicode string literals,
// even if their Q_COMPILER_UNICODE_STRING has been revoked due
// to lacking stdlib support. But QStringLiteral only needs the
// core language feature, so just use u"" here unconditionally:

#define QT_UNICODE_LITERAL(str) u"" str +/

alias QStringPrivate = QArrayDataPointer!(wchar);

extern(C++, "QtPrivate") {
/+ /+ Q_ALWAYS_INLINE +/ pragma(inline, true) QStringPrivate qMakeStringPrivate(qsizetype N)(ref const(wchar)[N] literal)
{
    // NOLINTNEXTLINE(cppcoreguidelines-pro-type-const-cast)
    auto str = const_cast!(wchar*)(literal);
    return { null, str, N - 1} ;
}+/
}

/+ #define QStringLiteral(str) \
    (QString(QtPrivate::qMakeStringPrivate(QT_UNICODE_LITERAL(str)))) \
    /**/ +/


