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
import qt.core.metamacros;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.url;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct UserScript;
} // namespace


@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineScript
{

    mixin(Q_GADGET);
    /+ Q_PROPERTY(QString name READ name WRITE setName FINAL)
    Q_PROPERTY(QUrl sourceUrl READ sourceUrl WRITE setSourceUrl FINAL)
    Q_PROPERTY(QString sourceCode READ sourceCode WRITE setSourceCode FINAL)
    Q_PROPERTY(InjectionPoint injectionPoint READ injectionPoint WRITE setInjectionPoint FINAL)
    Q_PROPERTY(quint32 worldId READ worldId WRITE setWorldId FINAL)
    Q_PROPERTY(bool runsOnSubFrames READ runsOnSubFrames WRITE setRunsOnSubFrames FINAL) +/

public:

    enum InjectionPoint {
        Deferred,
        DocumentReady,
        DocumentCreation
    }

    /+ Q_ENUM(InjectionPoint) +/

    enum ScriptWorldId {
        MainWorld = 0,
        ApplicationWorld,
        UserWorld
    }

    /+ Q_ENUM(ScriptWorldId) +/

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

    QString name() const;
    void setName(ref const(QString) );

    QUrl sourceUrl() const;
    void setSourceUrl(ref const(QUrl) url);

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
    this(ref const(/+ QtWebEngineCore:: +/UserScript) );

    QSharedDataPointer!(/+ QtWebEngineCore:: +/UserScript) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QWebEngineScript, Q_RELOCATABLE_TYPE);

#ifndef QT_NO_DEBUG_STREAM
Q_WEBENGINECORE_EXPORT QDebug operator<<(QDebug, const QWebEngineScript &);
#endif +/

