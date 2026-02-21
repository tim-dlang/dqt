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
module qt.qml.engine;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.list;
import qt.core.object;
import qt.core.string;
import qt.core.stringlist;
import qt.core.url;
import qt.helpers;
import qt.qml.context;
import qt.qml.error;
import qt.qml.jsengine;

extern(C++, class) struct QQmlAbstractUrlInterceptor;

/// Binding for C++ class [QQmlImageProviderBase](https://doc.qt.io/qt-5/qqmlimageproviderbase.html).
abstract class /+ Q_QML_EXPORT +/ QQmlImageProviderBase
{
public:
    enum ImageType {
        Image,
        Pixmap,
        Texture,
        Invalid,
        ImageResponse
        // ### Qt6: reorder these, and give Invalid a fixed large value
    }

    enum Flag {
        ForceAsynchronousImageLoading  = 0x01
    }
    /+ Q_DECLARE_FLAGS(Flags, Flag) +/
alias Flags = QFlags!(Flag);
    /+ virtual +/~this();

    /+ virtual +/ abstract ImageType imageType() const;
    /+ virtual +/ abstract Flags flags() const;

private:
    /+ friend class QQuickImageProvider; +/
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this();
    }));
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QQmlImageProviderBase.Flags.enum_type) operator |(QQmlImageProviderBase.Flags.enum_type f1, QQmlImageProviderBase.Flags.enum_type f2)nothrow{return QFlags!(QQmlImageProviderBase.Flags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QQmlImageProviderBase.Flags.enum_type) operator |(QQmlImageProviderBase.Flags.enum_type f1, QFlags!(QQmlImageProviderBase.Flags.enum_type) f2)nothrow{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QQmlImageProviderBase.Flags.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/
/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QQmlImageProviderBase::Flags) +/
extern(C++, class) struct QQmlEnginePrivate;
extern(C++, class) struct QQmlImportsPrivate;
extern(C++, class) struct QQmlExpression;
extern(C++, class) struct QQmlType;
/+ #if QT_CONFIG(qml_network)
class QNetworkAccessManager;
class QQmlNetworkAccessManagerFactory;
#endif +/
extern(C++, class) struct QQmlIncubationController;
/// Binding for C++ class [QQmlEngine](https://doc.qt.io/qt-5/qqmlengine.html).
class /+ Q_QML_EXPORT +/ QQmlEngine : QJSEngine
{
    /+ Q_PROPERTY(QString offlineStoragePath READ offlineStoragePath WRITE setOfflineStoragePath) +/
    mixin(Q_OBJECT);
public:
    /+ explicit +/this(QObject p = null);
    ~this();

    final QQmlContext rootContext() const;

    final void clearComponentCache();
    final void trimComponentCache();

    final QStringList importPathList() const;
    final void setImportPathList(ref const(QStringList) paths);
    final void addImportPath(ref const(QString) dir);

    final QStringList pluginPathList() const;
    final void setPluginPathList(ref const(QStringList) paths);
    final void addPluginPath(ref const(QString) dir);

    final bool addNamedBundle(ref const(QString) name, ref const(QString) fileName);

/+ #if QT_CONFIG(library) +/
    final bool importPlugin(ref const(QString) filePath, ref const(QString) uri, QList!(QQmlError)* errors);
/+ #endif

#if QT_CONFIG(qml_network) +/
    /+ void setNetworkAccessManagerFactory(QQmlNetworkAccessManagerFactory *); +/
    /+ QQmlNetworkAccessManagerFactory *networkAccessManagerFactory() const; +/

    /+ QNetworkAccessManager *networkAccessManager() const; +/
/+ #endif +/

    final void setUrlInterceptor(QQmlAbstractUrlInterceptor* urlInterceptor);
    final QQmlAbstractUrlInterceptor* urlInterceptor() const;

    final void addImageProvider(ref const(QString) id, QQmlImageProviderBase );
    final QQmlImageProviderBase imageProvider(ref const(QString) id) const;
    final void removeImageProvider(ref const(QString) id);

    final void setIncubationController(QQmlIncubationController* );
    final QQmlIncubationController* incubationController() const;

    final void setOfflineStoragePath(ref const(QString) dir);
    final QString offlineStoragePath() const;
    final QString offlineStorageDatabaseFilePath(ref const(QString) databaseName) const;

    final QUrl baseUrl() const;
    final void setBaseUrl(ref const(QUrl) );

    final bool outputWarningsToStandardError() const;
    final void setOutputWarningsToStandardError(bool);

    /+ template<typename T> +/
    final T singletonInstance(T)(int qmlTypeId) {
        import qt.qml.jsvalue;

        return qobject_cast!(T)(singletonInstance!(QJSValue)(qmlTypeId).toQObject());
    }

public /+ Q_SLOTS +/:
    @QSlot final void retranslate();

public:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static QQmlContext contextForObject(const(QObject) );
    }));
    static void setContextForObject(QObject , QQmlContext );

    enum ObjectOwnership { CppOwnership, JavaScriptOwnership }
    static void setObjectOwnership(QObject , ObjectOwnership);
    static ObjectOwnership objectOwnership(QObject );
protected:
    this(ref QQmlEnginePrivate dd, QObject p);
    override bool event(QEvent );

/+ Q_SIGNALS +/public:
    @QSignal final void quit();
    @QSignal final void exit(int retCode);
    @QSignal final void warnings(ref const(QList!(QQmlError)) warnings);

private:
    /+ Q_DISABLE_COPY(QQmlEngine) +/
    /+ Q_DECLARE_PRIVATE(QQmlEngine) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ template<> +/
