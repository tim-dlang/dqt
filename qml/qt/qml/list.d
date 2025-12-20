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
module qt.qml.list;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.metatype;
import qt.core.object;
import qt.core.objectdefs;
import qt.helpers;
import qt.qml.engine;


/+ #ifndef QQMLLISTPROPERTY +/
/+ #define QQMLLISTPROPERTY +/
/// Binding for C++ class [QQmlListProperty](https://doc.qt.io/qt-5/qqmllistproperty.html).
@Q_DECLARE_METATYPE extern(C++, class) struct QQmlListProperty(T) {
public:
    alias AppendFunction = ExternCPPFunc!(void function(QQmlListProperty!(T)* , T* ));
    alias CountFunction = ExternCPPFunc!(int function(QQmlListProperty!(T)* ));
    alias AtFunction = ExternCPPFunc!(T* function(QQmlListProperty!(T)* , int));
    alias ClearFunction = ExternCPPFunc!(void function(QQmlListProperty!(T)* ));
    alias ReplaceFunction = ExternCPPFunc!(void function(QQmlListProperty!(T)* , int, T* ));
    alias RemoveLastFunction = ExternCPPFunc!(void function(QQmlListProperty!(T)* ));

    /+ QQmlListProperty() = default; +/

/+ #if QT_DEPRECATED_SINCE(5,15) +/
    /+ QT_DEPRECATED_X("Use constructor taking QList pointer, and gain improved performance") +/this(QObject o, ref QList!(T*) list)
    {
        this.object = o;
        this.data = &list;
        this.append = qlist_append;
        this.count = qlist_count;
        this.at = qlist_at;
        this.clear = qlist_clear;
        this.replace = qslow_replace;
        this.removeLast = qslow_removeLast;
    }
/+ #endif +/

    this(QObject o, QList!(T*)* list)
    {
        this.object = o;
        this.data = list;
        this.append = qlist_append;
        this.count = qlist_count;
        this.at = qlist_at;
        this.clear = qlist_clear;
        this.replace = qlist_replace;
        this.removeLast = qlist_removeLast;
    }

    this(QObject o, void* d, AppendFunction a, CountFunction c, AtFunction t,
                        ClearFunction r )
    {
        this.object = o;
        this.data = d;
        this.append = a;
        this.count = c;
        this.at = t;
        this.clear = r;
        this.replace = (a && c && t && r) ? qslow_replace : null;
        this.removeLast = (a && c && t && r) ? qslow_removeLast : null;
    }

    this(QObject o, void* d, AppendFunction a, CountFunction c, AtFunction t,
                         ClearFunction r, ReplaceFunction s, RemoveLastFunction p)
    {
        this.object = o;
        this.data = d;
        this.append = a;
        this.count = c;
        this.at = t;
        this.clear = (!r && p && c) ? qslow_clear : r;
        this.replace = (!s && a && c && t && (r || p)) ? qslow_replace : s;
        this.removeLast = (!p && a && c && t && r) ? qslow_removeLast : p;
    }

    this(QObject o, void* d, CountFunction c, AtFunction a)
    {
        this.object = o;
        this.data = d;
        this.count = c;
        this.at = a;
    }

    /+bool operator ==(ref const(QQmlListProperty) o) const {
        return object == o.object &&
               data == o.data &&
               append == o.append &&
               count == o.count &&
               at == o.at &&
               clear == o.clear &&
               replace == o.replace &&
               removeLast == o.removeLast;
    }+/

    QObject object = null;
    void* data = null;

    AppendFunction append = null;
    CountFunction count = null;
    AtFunction at = null;
    ClearFunction clear = null;
    ReplaceFunction replace = null;
    RemoveLastFunction removeLast = null;

private:
    static void qlist_append(QQmlListProperty* p, T* v) {
        reinterpret_cast!(QList!(T*)*)(p.data).append(v);
    }
    static int qlist_count(QQmlListProperty* p) {
        return reinterpret_cast!(QList!(T*)*)(p.data).count();
    }
    static T* qlist_at(QQmlListProperty* p, int idx) {
        return reinterpret_cast!(QList!(T*)*)(p.data).at(idx);
    }
    static void qlist_clear(QQmlListProperty* p) {
        return reinterpret_cast!(QList!(T*)*)(p.data).clear();
    }
    static void qlist_replace(QQmlListProperty* p, int idx, T* v) {
        return reinterpret_cast!(QList!(T*)*)(p.data).replace(idx, v);
    }
    static void qlist_removeLast(QQmlListProperty* p) {
        return reinterpret_cast!(QList!(T*)*)(p.data).removeLast();
    }

    /+ static void qslow_replace(QQmlListProperty!(T)* list, int idx, T* v)
    {
        import qt.core.vector;

        const(int) length = list.count(list);
        if (idx < 0 || idx >= length)
            return;

        QVector!(T*) stash;
        if (list.clear != qslow_clear) {
            stash.reserve(length);
            for (int i = 0; i < length; ++i)
                stash.append(i == idx ? v : list.at(list, i));
            list.clear(list);
            for (T *item : qAsConst(stash))
                list.append(list, item);
        } else {
            stash.reserve(length - idx - 1);
            for (int i = length - 1; i > idx; --i) {
                stash.append(list.at(list, i));
                list.removeLast(list);
            }
            list.removeLast(list);
            list.append(list, v);
            while (!stash.isEmpty())
                list.append(list, stash.takeLast());
        }
    } +/

    static void qslow_clear(QQmlListProperty!(T)* list)
    {
        for (int i = 0, end = list.count(list); i < end; ++i)
            list.removeLast(list);
    }

    /+ static void qslow_removeLast(QQmlListProperty!(T)* list)
    {
        import qt.core.vector;

        const(int) length = list.count(list) - 1;
        if (length < 0)
            return;
        QVector!(T*) stash;
        stash.reserve(length);
        for (int i = 0; i < length; ++i)
            stash.append(list.at(list, i));
        list.clear(list);
        for (T *item : qAsConst(stash))
            list.append(list, item);
    } +/
}
/+ #endif +/

extern(C++, class) struct QQmlListReferencePrivate;
/// Binding for C++ class [QQmlListReference](https://doc.qt.io/qt-5/qqmllistreference.html).
@Q_DECLARE_METATYPE extern(C++, class) struct /+ Q_QML_EXPORT +/ QQmlListReference
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(QObject , const(char)* property, QQmlEngine  /+ = nullptr +/);
    @disable this(this);
    this(ref const(QQmlListReference) );
    ref QQmlListReference opAssign(ref const(QQmlListReference) );
    ~this();

    bool isValid() const;

    QObject object() const;
    const(QMetaObject)* listElementType() const;

    bool canAppend() const;
    bool canAt() const;
    bool canClear() const;
    bool canCount() const;
    bool canReplace() const;
    bool canRemoveLast() const;

    bool isManipulable() const;
    bool isReadable() const;

    bool append(QObject ) const;
    QObject at(int) const;
    bool clear() const;
    int count() const;
    bool replace(int, QObject ) const;
    bool removeLast() const;

private:
    /+ friend class QQmlListReferencePrivate; +/
    QQmlListReferencePrivate* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ Q_DECLARE_METATYPE(QQmlListReference) +/

