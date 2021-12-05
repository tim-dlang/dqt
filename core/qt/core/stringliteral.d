/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.core.stringliteral;
extern(C++):

import qt.config;
import qt.core.arraydata;
import qt.helpers;

/+ #if 0
#pragma qt_class(QStringLiteral)
#endif +/


alias QStringData = QTypedArrayData!(ushort);

// all our supported compilers support Unicode string literals,
// even if their Q_COMPILER_UNICODE_STRING has been revoked due
// to lacking stdlib support. But QStringLiteral only needs the
// core language feature, so just use u"" here unconditionally:

alias qunicodechar = wchar;

/+ Q_STATIC_ASSERT_X(sizeof(qunicodechar) == 2,
        "qunicodechar must typedef an integral type of size 2");

#define QT_UNICODE_LITERAL(str) u"" str
#define QStringLiteral(str) \
    ([]() noexcept -> QString { \
        enum { Size = sizeof(QT_UNICODE_LITERAL(str))/2 - 1 }; \
        static const QStaticStringData<Size> qstring_literal = { \
            Q_STATIC_STRING_DATA_HEADER_INITIALIZER(Size), \
            QT_UNICODE_LITERAL(str) }; \
        QStringDataPtr holder = { qstring_literal.data_ptr() }; \
        return QString(holder); \
    }()) \
    /**/

#define Q_STATIC_STRING_DATA_HEADER_INITIALIZER_WITH_OFFSET(size, offset) \
    { Q_REFCOUNT_INITIALIZE_STATIC, size, 0, 0, offset } \
    /**/

#define Q_STATIC_STRING_DATA_HEADER_INITIALIZER(size) \
    Q_STATIC_STRING_DATA_HEADER_INITIALIZER_WITH_OFFSET(size, sizeof(QStringData)) \
    /**/

#if QT_DEPRECATED_SINCE(5, 14)
# define QStringViewLiteral(str) QStringView(QT_UNICODE_LITERAL(str), QtPrivate::Deprecated)
#endif

template <int N>
struct QStaticStringData
{
    QArrayData str;
    qunicodechar data[N + 1];

    QStringData *data_ptr() const
    {
        Q_ASSERT(str.ref.isStatic());
        return const_cast<QStringData *>(static_cast<const QStringData*>(&str));
    }
}; +/

struct QStringDataPtr
{
    QStringData* ptr;
}

