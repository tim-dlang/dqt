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
module qt.qml.context;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.object;
import qt.core.string;
import qt.core.url;
import qt.core.variant;
import qt.helpers;
import qt.qml.engine;
import qt.qml.jsvalue;

extern(C++, class) struct QQmlRefCount;
extern(C++, class) struct QQmlContextPrivate;
extern(C++, class) struct QQmlCompositeTypeData;

/// Binding for C++ class [QQmlContext](https://doc.qt.io/qt-6/qqmlcontext.html).
class /+ Q_QML_EXPORT +/ QQmlContext : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QQmlContext) +/

public:
    //struct PropertyPair { QString name; QVariant value; }

    this(QQmlEngine parent, QObject objParent = null);
    this(QQmlContext parent, QObject objParent = null);
    ~this();

    final bool isValid() const;

    final QQmlEngine engine() const;
    final QQmlContext parentContext() const;

    final QObject contextObject() const;
    final void setContextObject(QObject );

    final QVariant contextProperty(ref const(QString) ) const;
    final void setContextProperty(ref const(QString) , QObject );
    extern(D) final void setContextProperty(string name, QObject o)
    {
        QString n = QString(name);
        setContextProperty(n, o);
    }
    final void setContextProperty(ref const(QString) , ref const(QVariant) );
    extern(D) final void setContextProperty(T)(string name, T value) if (!is(T : QObject))
    {
        QString n = QString(name);
        QVariant v = QVariant.fromValue(value);
        setContextProperty(n, v);
    }
    //final void setContextProperties(ref const(QList!(PropertyPair)) properties);

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QString nameForObject(const(QObject) ) const;
    }));
    final QObject objectForName(ref const(QString) ) const;

    final QUrl resolvedUrl(ref const(QUrl) ) const;

    final void setBaseUrl(ref const(QUrl) );
    final QUrl baseUrl() const;

    final QJSValue importedScript(ref const(QString) name) const;

private:
    /+ friend class QQmlEngine; +/
    /+ friend class QQmlEnginePrivate; +/
    /+ friend class QQmlExpression; +/
    /+ friend class QQmlExpressionPrivate; +/
    /+ friend class QQmlComponent; +/
    /+ friend class QQmlComponentPrivate; +/
    /+ friend class QQmlScriptPrivate; +/
    /+ friend class QQmlContextData; +/
    this(ref QQmlContextPrivate dd, QObject parent = null);
    this(QQmlEngine , bool);
    /+ Q_DISABLE_COPY(QQmlContext) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_METATYPE(QList<QObject*>) +/

