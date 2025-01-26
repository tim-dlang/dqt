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
module qt.core.stringlist;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.qchar;
import qt.core.regularexpression;
import qt.core.string;
import qt.core.stringview;
import qt.helpers;

/// Binding for C++ class [QStringList](https://doc.qt.io/qt-6/qstringlist.html).
alias QStringList = QList!(QString);
/+ #ifndef QSTRINGLIST_H +/
/+ #define QSTRINGLIST_H



#if !defined(QT_NO_JAVA_STYLE_ITERATORS)
using QStringListIterator = QListIterator<QString>;
using QMutableStringListIterator = QMutableListIterator<QString>;
#endif +/


extern(C++, "QtPrivate") {
    void /+ Q_CORE_EXPORT +/ QStringList_sort(QStringList* that, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
    qsizetype /+ Q_CORE_EXPORT +/ QStringList_removeDuplicates(QStringList* that);
    QString /+ Q_CORE_EXPORT +/ QStringList_join(const(QStringList)* that, QStringView sep);
    QString /+ Q_CORE_EXPORT +/ QStringList_join(const(QStringList)* that, const(QChar)* sep, qsizetype seplen);
    /+ Q_CORE_EXPORT +/ QString QStringList_join(ref const(QStringList) list, QLatin1String sep);
    QStringList /+ Q_CORE_EXPORT +/ QStringList_filter(const(QStringList)* that, QStringView str,
                                                   /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
    bool /+ Q_CORE_EXPORT +/ QStringList_contains(const(QStringList)* that, QStringView str, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
    bool /+ Q_CORE_EXPORT +/ QStringList_contains(const(QStringList)* that, QLatin1String str, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
    void /+ Q_CORE_EXPORT +/ QStringList_replaceInStrings(QStringList* that, QStringView before, QStringView after,
                                          /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);

/+ #if QT_CONFIG(regularexpression) +/
    void /+ Q_CORE_EXPORT +/ QStringList_replaceInStrings(QStringList* that, ref const(QRegularExpression) rx, ref const(QString) after);
    QStringList /+ Q_CORE_EXPORT +/ QStringList_filter(const(QStringList)* that, ref const(QRegularExpression) re);
    qsizetype /+ Q_CORE_EXPORT +/ QStringList_indexOf(const(QStringList)* that, ref const(QRegularExpression) re, qsizetype from);
    qsizetype /+ Q_CORE_EXPORT +/ QStringList_lastIndexOf(const(QStringList)* that, ref const(QRegularExpression) re, qsizetype from);
/+ #endif +/ // QT_CONFIG(regularexpression)
}

/+ #ifdef Q_QDOC
class QStringList : public QList<QString>
#else
template <> struct QListSpecialMethods<QString> : QListSpecialMethodsBase<QString>
#endif
{
#ifdef Q_QDOC
public:
    using QList<QString>::QList;
    QStringList(const QString &str);
    QStringList(const QList<QString> &other);
    QStringList(QList<QString> &&other);

    QStringList &operator=(const QList<QString> &other);
    QStringList &operator=(QList<QString> &&other);
    QStringList operator+(const QStringList &other) const;
    QStringList &operator<<(const QString &str);
    QStringList &operator<<(const QStringList &other);
    QStringList &operator<<(const QList<QString> &other);
private:
#endif

public:
    inline void sort(Qt::CaseSensitivity cs = Qt::CaseSensitive)
    { QtPrivate::QStringList_sort(self(), cs); }
    inline qsizetype removeDuplicates()
    { return QtPrivate::QStringList_removeDuplicates(self()); }

    inline QString join(QStringView sep) const
    { return QtPrivate::QStringList_join(self(), sep); }
    inline QString join(QLatin1String sep) const
    { return QtPrivate::QStringList_join(*self(), sep); }
    inline QString join(QChar sep) const
    { return QtPrivate::QStringList_join(self(), &sep, 1); }

    inline QStringList filter(QStringView str, Qt::CaseSensitivity cs = Qt::CaseSensitive) const
    { return QtPrivate::QStringList_filter(self(), str, cs); }
    inline QStringList &replaceInStrings(QStringView before, QStringView after, Qt::CaseSensitivity cs = Qt::CaseSensitive)
    {
        QtPrivate::QStringList_replaceInStrings(self(), before, after, cs);
        return *self();
    }

    inline QString join(const QString &sep) const
    { return QtPrivate::QStringList_join(self(), sep.constData(), sep.length()); }
    inline QStringList filter(const QString &str, Qt::CaseSensitivity cs = Qt::CaseSensitive) const
    { return QtPrivate::QStringList_filter(self(), str, cs); }
    inline QStringList &replaceInStrings(const QString &before, const QString &after, Qt::CaseSensitivity cs = Qt::CaseSensitive)
    {
        QtPrivate::QStringList_replaceInStrings(self(), before, after, cs);
        return *self();
    }
    inline QStringList &replaceInStrings(const QString &before, QStringView after, Qt::CaseSensitivity cs = Qt::CaseSensitive)
    {
        QtPrivate::QStringList_replaceInStrings(self(), before, after, cs);
        return *self();
    }
    inline QStringList &replaceInStrings(QStringView before, const QString &after, Qt::CaseSensitivity cs = Qt::CaseSensitive)
    {
        QtPrivate::QStringList_replaceInStrings(self(), before, after, cs);
        return *self();
    }
    using QListSpecialMethodsBase<QString>::contains;
    using QListSpecialMethodsBase<QString>::indexOf;
    using QListSpecialMethodsBase<QString>::lastIndexOf;

    inline bool contains(QLatin1String str, Qt::CaseSensitivity cs = Qt::CaseSensitive) const noexcept
    { return QtPrivate::QStringList_contains(self(), str, cs); }
    inline bool contains(QStringView str, Qt::CaseSensitivity cs = Qt::CaseSensitive) const noexcept
    { return QtPrivate::QStringList_contains(self(), str, cs); }

    inline bool contains(const QString &str, Qt::CaseSensitivity cs = Qt::CaseSensitive) const noexcept
    { return QtPrivate::QStringList_contains(self(), str, cs); }
    qsizetype indexOf(const QString &str, qsizetype from = 0) const noexcept
    { return indexOf(QStringView(str), from); }
    qsizetype lastIndexOf(const QString &str, qsizetype from = -1) const noexcept
    { return lastIndexOf(QStringView(str), from); }

#if QT_CONFIG(regularexpression)
    inline QStringList filter(const QRegularExpression &re) const
    { return QtPrivate::QStringList_filter(self(), re); }
    inline QStringList &replaceInStrings(const QRegularExpression &re, const QString &after)
    {
        QtPrivate::QStringList_replaceInStrings(self(), re, after);
        return *self();
    }
    inline qsizetype indexOf(const QRegularExpression &re, qsizetype from = 0) const
    { return QtPrivate::QStringList_indexOf(self(), re, from); }
    inline qsizetype lastIndexOf(const QRegularExpression &re, qsizetype from = -1) const
    { return QtPrivate::QStringList_lastIndexOf(self(), re, from); }
#endif // QT_CONFIG(regularexpression)
}; +/


/+ #endif +/ // QSTRINGLIST_H

