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
import qt.core.list;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.qchar;
import qt.core.regularexpression;
import qt.core.string;
import qt.core.stringview;
import qt.core.typeinfo;
import qt.helpers;
version(QT_NO_REGEXP){}else
    import qt.core.regexp;

/+ #ifndef QSTRINGLIST_H +/
/+ #define QSTRINGLIST_H


class QRegExp;
class QRegularExpression;

#if !defined(QT_NO_JAVA_STYLE_ITERATORS)
typedef QListIterator<QString> QStringListIterator;
typedef QMutableListIterator<QString> QMutableStringListIterator;
#endif

class QStringList;

#ifdef Q_QDOC
class QStringList : public QList<QString>
#else
template <> struct QListSpecialMethods<QString>
#endif
{
#ifndef Q_QDOC
protected:
    ~QListSpecialMethods() = default;
#endif
public:
    inline void sort(Qt::CaseSensitivity cs = Qt::CaseSensitive);
    inline int removeDuplicates();

#if QT_STRINGVIEW_LEVEL < 2
    inline QString join(const QString &sep) const;
#endif
    inline QString join(QStringView sep) const;
    inline QString join(QLatin1String sep) const;
    inline QString join(QChar sep) const;

    inline QStringList filter(QStringView str, Qt::CaseSensitivity cs = Qt::CaseSensitive) const;
    inline QStringList &replaceInStrings(QStringView before, QStringView after, Qt::CaseSensitivity cs = Qt::CaseSensitive);
#if QT_STRINGVIEW_LEVEL < 2
    inline QStringList filter(const QString &str, Qt::CaseSensitivity cs = Qt::CaseSensitive) const;
    inline QStringList &replaceInStrings(const QString &before, const QString &after, Qt::CaseSensitivity cs = Qt::CaseSensitive);
    inline QStringList &replaceInStrings(const QString &before, QStringView after, Qt::CaseSensitivity cs = Qt::CaseSensitive);
    inline QStringList &replaceInStrings(QStringView before, const QString &after, Qt::CaseSensitivity cs = Qt::CaseSensitive);
#endif

#ifndef QT_NO_REGEXP
    inline QStringList filter(const QRegExp &rx) const;
    inline QStringList &replaceInStrings(const QRegExp &rx, const QString &after);
#endif

#if QT_CONFIG(regularexpression)
    inline QStringList filter(const QRegularExpression &re) const;
    inline QStringList &replaceInStrings(const QRegularExpression &re, const QString &after);
#endif // QT_CONFIG(regularexpression)

#ifndef Q_QDOC
private:
    inline QStringList *self();
    inline const QStringList *self() const;
}; +/

// ### Qt6: check if there's a better way
/// Binding for C++ class [QStringList](https://doc.qt.io/qt-5/qstringlist.html).
@(QMetaType.Type.QStringList) @Q_MOVABLE_TYPE extern(C++, class) struct QStringList
{
    public QList!(QString) base0;
    alias base0 this;
/+ #endif +/
public:
    version(Windows)
        @disable this();
    /+pragma(inline, true) this()/+ noexcept+/ { }+/

    static QStringList create()
    {
        QStringList r = QStringList.init;
        r.base0 = QList!QString.create;
        return r;
    }

    /+ explicit +/pragma(inline, true) this(ref const(QString) i)
    {
        base0 = QList!QString.create;
        append(i); 
    }
    pragma(inline, true) this(ref const(QList!(QString)) l)
    {
        this.base0 = *cast(QList!(QString)*)&l;
    }
    /+ inline QStringList(QList<QString> &&l) noexcept : QList<QString>(std::move(l)) { } +/
    /+ inline QStringList(std::initializer_list<QString> args) : QList<QString>(args) { } +/
    /+ template <typename InputIterator, QtPrivate::IfIsInputIterator<InputIterator> = true> +/
    /+ inline QStringList(InputIterator first, InputIterator last)
        : QList<QString>(first, last) { } +/

    /+ref QStringList operator =(ref const(QList!(QString)) other)
    { QList!(QString).operator=(other); return this; }+/
    /+ QStringList &operator=(QList<QString> &&other) noexcept
    { QList<QString>::operator=(std::move(other)); return *this; } +/

    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        pragma(inline, true) bool contains(ref const(QString) str, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
        {
            return /+ QtPrivate:: +/QStringList_contains(&this, str, cs);
        }
    }
    pragma(inline, true) bool contains(QLatin1String str, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    {
        return /+ QtPrivate:: +/QStringList_contains(&this, str, cs);
    }

    auto opSlice() const
    {
        return base0.opSlice();
    }

    pragma(inline, true) bool contains(QStringView str, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    {
        return /+ QtPrivate:: +/QStringList_contains(&this, str, cs);
    }

    extern(D) pragma(inline, true) QStringList opBinary(string op)(ref const(QStringList) other) const if(op == "~")
    { QStringList n = this; n ~= other; return n; }
    /+pragma(inline, true) ref QStringList operator <<(ref const(QString) str)
    { append(str); return this; }+/
    /+pragma(inline, true) ref QStringList operator <<(ref const(QStringList) l)
    { this += l; return this; }+/
    /+pragma(inline, true) ref QStringList operator <<(ref const(QList!(QString)) l)
    { this += l; return this; }+/

    pragma(inline, true) int indexOf(QStringView string, int from = 0) const
    {
        return /+ QtPrivate:: +/qt.core.list.indexOf!(QString, QStringView)(this, string, from);
    }
    pragma(inline, true) int indexOf(QLatin1String string, int from = 0) const
    {
        return /+ QtPrivate:: +/qt.core.list.indexOf!(QString, QLatin1String)(this, string, from);
    }

    pragma(inline, true) int lastIndexOf(QStringView string, int from = -1) const
    {
        return /+ QtPrivate:: +/qt.core.list.lastIndexOf!(QString, QStringView)(this, string, from);
    }
    pragma(inline, true) int lastIndexOf(QLatin1String string, int from = -1) const
    {
        return /+ QtPrivate:: +/qt.core.list.lastIndexOf!(QString, QLatin1String)(this, string, from);
    }

/+ #ifndef QT_NO_REGEXP +/
    version(QT_NO_REGEXP){}else
    {
        pragma(inline, true) int indexOf(ref const(QRegExp) rx, int from = 0) const
        {
            return /+ QtPrivate:: +/QStringList_indexOf(&this, rx, from);
        }
        pragma(inline, true) int lastIndexOf(ref const(QRegExp) rx, int from = -1) const
        {
            return /+ QtPrivate:: +/QStringList_lastIndexOf(&this, rx, from);
        }
        pragma(inline, true) int indexOf(ref QRegExp rx, int from = 0) const
        {
            return /+ QtPrivate:: +/QStringList_indexOf(&this, rx, from);
        }
        pragma(inline, true) int lastIndexOf(ref QRegExp rx, int from = -1) const
        {
            return /+ QtPrivate:: +/QStringList_lastIndexOf(&this, rx, from);
        }
    }
/+ #endif

#if QT_CONFIG(regularexpression) +/
    pragma(inline, true) int indexOf(ref const(QRegularExpression) rx, int from = 0) const
    {
        return /+ QtPrivate:: +/QStringList_indexOf(&this, rx, from);
    }
    pragma(inline, true) int lastIndexOf(ref const(QRegularExpression) rx, int from = -1) const
    {
        return /+ QtPrivate:: +/QStringList_lastIndexOf(&this, rx, from);
    }
/+ #endif +/ // QT_CONFIG(regularexpression)

    /+ using QList<QString>::indexOf; +/
    /+ using QList<QString>::lastIndexOf; +/
}

/+ Q_DECLARE_TYPEINFO(QStringList, Q_MOVABLE_TYPE);

#ifndef Q_QDOC +/

extern(C++, "QtPrivate") {
    void /+ Q_CORE_EXPORT +/ QStringList_sort(QStringList* that, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
    int /+ Q_CORE_EXPORT +/ QStringList_removeDuplicates(QStringList* that);
    QString /+ Q_CORE_EXPORT +/ QStringList_join(const(QStringList)* that, QStringView sep);
    QString /+ Q_CORE_EXPORT +/ QStringList_join(const(QStringList)* that, const(QChar)* sep, int seplen);
    /+ Q_CORE_EXPORT +/ QString QStringList_join(ref const(QStringList) list, QLatin1String sep);
    QStringList /+ Q_CORE_EXPORT +/ QStringList_filter(const(QStringList)* that, QStringView str,
                                                   /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    QStringList /+ Q_CORE_EXPORT +/ QStringList_filter(const(QStringList)* that, ref const(QString) str,
                                                   /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
/+ #endif

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    bool /+ Q_CORE_EXPORT +/ QStringList_contains(const(QStringList)* that, ref const(QString) str, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
/+ #endif +/
    bool /+ Q_CORE_EXPORT +/ QStringList_contains(const(QStringList)* that, QStringView str, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
    bool /+ Q_CORE_EXPORT +/ QStringList_contains(const(QStringList)* that, QLatin1String str, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
    void /+ Q_CORE_EXPORT +/ QStringList_replaceInStrings(QStringList* that, QStringView before, QStringView after,
                                          /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    void /+ Q_CORE_EXPORT +/ QStringList_replaceInStrings(QStringList* that, ref const(QString) before, ref const(QString) after,
                                          /+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
/+ #endif +/

version(QT_NO_REGEXP){}else
{
    void /+ Q_CORE_EXPORT +/ QStringList_replaceInStrings(QStringList* that, ref const(QRegExp) rx, ref const(QString) after);
    QStringList /+ Q_CORE_EXPORT +/ QStringList_filter(const(QStringList)* that, ref const(QRegExp) re);
    int /+ Q_CORE_EXPORT +/ QStringList_indexOf(const(QStringList)* that, ref const(QRegExp) rx, int from);
    int /+ Q_CORE_EXPORT +/ QStringList_lastIndexOf(const(QStringList)* that, ref const(QRegExp) rx, int from);
    int /+ Q_CORE_EXPORT +/ QStringList_indexOf(const(QStringList)* that, ref QRegExp rx, int from);
    int /+ Q_CORE_EXPORT +/ QStringList_lastIndexOf(const(QStringList)* that, ref QRegExp rx, int from);
}

/+ #if QT_CONFIG(regularexpression) +/
    void /+ Q_CORE_EXPORT +/ QStringList_replaceInStrings(QStringList* that, ref const(QRegularExpression) rx, ref const(QString) after);
    QStringList /+ Q_CORE_EXPORT +/ QStringList_filter(const(QStringList)* that, ref const(QRegularExpression) re);
    int /+ Q_CORE_EXPORT +/ QStringList_indexOf(const(QStringList)* that, ref const(QRegularExpression) re, int from);
    int /+ Q_CORE_EXPORT +/ QStringList_lastIndexOf(const(QStringList)* that, ref const(QRegularExpression) re, int from);
/+ #endif +/ // QT_CONFIG(regularexpression)
}

/+ #if QT_STRINGVIEW_LEVEL < 2
#endif

#if QT_STRINGVIEW_LEVEL < 2
#endif

#if QT_STRINGVIEW_LEVEL < 2
#endif

#if QT_STRINGVIEW_LEVEL < 2
#endif +/

/+pragma(inline, true) QStringList operator +(ref const(QList!(QString)) one, ref const(QStringList) other)
{
    QStringList n = one;
    n ~= other;
    return n;
}+/

/+ #ifndef QT_NO_REGEXP
#endif

#if QT_CONFIG(regularexpression)
#endif +/ // QT_CONFIG(regularexpression)
/+ #endif +/ // Q_QDOC


/+ #endif +/ // QSTRINGLIST_H

