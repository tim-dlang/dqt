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
#endif +/


// all our supported compilers support Unicode string literals,
// even if their Q_COMPILER_UNICODE_STRING has been revoked due
// to lacking stdlib support. But QStringLiteral only needs the
// core language feature, so just use u"" here unconditionally:

/+ #define QT_UNICODE_LITERAL(str) u"" str +/
template QT_UNICODE_LITERAL(params...) if (params.length == 1)
{
    enum str = params[0];
    enum QT_UNICODE_LITERAL = ""w ~ str;
}

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
extern(D) alias QStringLiteral = function string(string str)
{
    return
            mixin(interpolateMixin(q{(imported!q{qt.core.string}.QString(/+ QtPrivate:: +/qt.core.stringliteral.qMakeStringPrivate(staticString!(const(wchar), imported!q{qt.core.stringliteral}.QT_UNICODE_LITERAL!($(str))))))}));
            /**/
};


