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
module qt.core.bytearraylist;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.global;
import qt.core.list;
import qt.helpers;

/+ #ifndef QBYTEARRAYLIST_H +/
/+ #define QBYTEARRAYLIST_H


#if !defined(QT_NO_JAVA_STYLE_ITERATORS)
typedef QListIterator<QByteArray> QByteArrayListIterator;
typedef QMutableListIterator<QByteArray> QMutableByteArrayListIterator;
#endif

#ifndef Q_CLANG_QDOC +/

extern(C++, "QtPrivate") {
static if (defined!"QT_CORE_BUILD_REMOVED_API" && ((configValue!"__SIZEOF_POINTER__" != 4 && defined!"__SIZEOF_POINTER__") || (!defined!"__SIZEOF_POINTER__" && (configValue!"Q_PROCESSOR_WORDSIZE" != 4 || versionIsSet!("D_LP64") || versionIsSet!("D_LP64")))))
{
    QByteArray /+ Q_CORE_EXPORT +/ QByteArrayList_join(const(QByteArrayList)* that, const(char)* separator, int separatorLength);
}
    QByteArray /+ Q_CORE_EXPORT +/ QByteArrayList_join(const(QByteArrayList)* that, const(char)* sep, qsizetype len);
}
/+ #endif

#ifdef Q_CLANG_QDOC
class QByteArrayList : public QList<QByteArray>
#else
template <> struct QListSpecialMethods<QByteArray> : QListSpecialMethodsBase<QByteArray>
#endif
{
#ifndef Q_CLANG_QDOC
protected:
    ~QListSpecialMethods() = default;
#endif
public:
    using QListSpecialMethodsBase<QByteArray>::indexOf;
    using QListSpecialMethodsBase<QByteArray>::lastIndexOf;
    using QListSpecialMethodsBase<QByteArray>::contains;

    QByteArray join(QByteArrayView sep = {}) const
    {
        return QtPrivate::QByteArrayList_join(self(), sep.data(), sep.size());
    }
    Q_WEAK_OVERLOAD
    inline QByteArray join(const QByteArray &sep) const
    { return join(qToByteArrayViewIgnoringNull(sep)); }
    inline QByteArray join(char sep) const
    { return join({&sep, 1}); }
}; +/


/+ #endif +/ // QBYTEARRAYLIST_H
/// Binding for C++ class [QByteArrayList](https://doc.qt.io/qt-6/qbytearraylist.html).
alias QByteArrayList = QList!(QByteArray);

