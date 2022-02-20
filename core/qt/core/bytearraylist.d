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
import qt.core.list;
import qt.helpers;

/+ #ifndef QBYTEARRAYLIST_H +/
/+ #define QBYTEARRAYLIST_H


#if !defined(QT_NO_JAVA_STYLE_ITERATORS)
typedef QListIterator<QByteArray> QByteArrayListIterator;
typedef QMutableListIterator<QByteArray> QMutableByteArrayListIterator;
#endif

#ifndef Q_CLANG_QDOC +/
/// Binding for C++ class [QByteArrayList](https://doc.qt.io/qt-5/qbytearraylist.html).
alias QByteArrayList = QList!(QByteArray);

extern(C++, "QtPrivate") {
    QByteArray /+ Q_CORE_EXPORT +/ QByteArrayList_join(const(QByteArrayList)* that, const(char)* separator, int separatorLength);
    int /+ Q_CORE_EXPORT +/ QByteArrayList_indexOf(const(QByteArrayList)* that, const(char)* needle, int from);
}
/+ #endif

#ifdef Q_CLANG_QDOC
class QByteArrayList : public QList<QByteArray>
#else
template <> struct QListSpecialMethods<QByteArray>
#endif
{
#ifndef Q_CLANG_QDOC
protected:
    ~QListSpecialMethods() = default;
#endif
public:
    inline QByteArray join() const
    { return QtPrivate::QByteArrayList_join(self(), nullptr, 0); }
    inline QByteArray join(const QByteArray &sep) const
    { return QtPrivate::QByteArrayList_join(self(), sep.constData(), sep.size()); }
    inline QByteArray join(char sep) const
    { return QtPrivate::QByteArrayList_join(self(), &sep, 1); }

    inline int indexOf(const char *needle, int from = 0) const
    { return QtPrivate::QByteArrayList_indexOf(self(), needle, from); }

private:
    typedef QList<QByteArray> Self;
    Self *self() { return static_cast<Self *>(this); }
    const Self *self() const { return static_cast<const Self *>(this); }
}; +/


/+ #endif +/ // QBYTEARRAYLIST_H
/// Binding for C++ class [QByteArrayList](https://doc.qt.io/qt-5/qbytearraylist.html).
alias QByteArrayList__1 = QList!(QByteArray);
/+ typedef QList<QByteArray> QByteArrayList; +/

