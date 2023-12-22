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
module qt.webengine.script;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct UserScript;
} // namespace


/// Binding for C++ class [QWebEngineScript](https://doc.qt.io/qt-5/qwebenginescript.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ QWEBENGINEWIDGETS_EXPORT +/ QWebEngineScript {
public:
    enum InjectionPoint {
        Deferred,
        DocumentReady,
        DocumentCreation
    }

    enum ScriptWorldId {
        MainWorld = 0,
        ApplicationWorld,
        UserWorld
    }

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QWebEngineScript) other);
    ~this();

    /+ref QWebEngineScript operator =(ref const(QWebEngineScript) other);+/

    bool isNull() const;

    QString name() const;
    void setName(ref const(QString) );

    QString sourceCode() const;
    void setSourceCode(ref const(QString) );

    InjectionPoint injectionPoint() const;
    void setInjectionPoint(InjectionPoint);

    quint32 worldId() const;
    void setWorldId(quint32);

    bool runsOnSubFrames() const;
    void setRunsOnSubFrames(bool on);

    /+bool operator ==(ref const(QWebEngineScript) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QWebEngineScript) other) const
    { return !operator==(other); }+/
    /+ void swap(QWebEngineScript &other) { qSwap(d, other.d); } +/


private:
    /+ friend class QWebEngineScriptCollectionPrivate; +/
    /+ friend class QWebEngineScriptCollection; +/
    this(ref const(/+ QtWebEngineCore:: +/UserScript) );

    QSharedDataPointer!(/+ QtWebEngineCore:: +/UserScript) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED_NOT_MOVABLE_UNTIL_QT6(QWebEngineScript)

#ifndef QT_NO_DEBUG_STREAM
QWEBENGINEWIDGETS_EXPORT QDebug operator<<(QDebug, const QWebEngineScript &);
#endif +/

