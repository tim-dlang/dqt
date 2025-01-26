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
module qt.webengine.scriptcollection;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.scopedpointer;
import qt.helpers;
import qt.webengine.script;

extern(C++, class) struct QWebEngineScriptCollectionPrivate;

/// Binding for C++ class [QWebEngineScriptCollection](https://doc.qt.io/qt-6/qwebenginescriptcollection.html).
extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineScriptCollection
{
public:
    ~this();

    bool isEmpty() const { return !count(); }
    int count() const;
    bool contains(ref const(QWebEngineScript) value) const;
    /+ QList<QWebEngineScript> find(const QString &name) const; +/
    void insert(ref const(QWebEngineScript) );
    void insert(ref const(QList!(QWebEngineScript)) list);
    bool remove(ref const(QWebEngineScript) );
    void clear();

    QList!(QWebEngineScript) toList() const;

private:
    /+ Q_DISABLE_COPY(QWebEngineScriptCollection) +/
@disable this(this);
/+this(ref const(QWebEngineScriptCollection));+//+ref QWebEngineScriptCollection operator =(ref const(QWebEngineScriptCollection));+/    /+ friend class QWebEnginePagePrivate; +/
    /+ friend class QWebEngineProfilePrivate; +/
    /+ friend class QQuickWebEngineProfilePrivate; +/
    /+ friend class QQuickWebEngineViewPrivate; +/
    /+ friend class QQuickWebEngineScriptCollectionPrivate; +/
    this(QWebEngineScriptCollectionPrivate* );

    QScopedPointer!(QWebEngineScriptCollectionPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

