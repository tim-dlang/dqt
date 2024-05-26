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
module qt.qml.component;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.global;
import qt.core.list;
import qt.core.object;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.qml.context;
import qt.qml.engine;
import qt.qml.error;
import qt.qml.private_;

extern(C++, class) struct QQmlIncubator;
extern(C++, class) struct QQmlV4Function;
extern(C++, class) struct QQmlComponentPrivate;
extern(C++, class) struct QQmlComponentAttached;

/+ namespace QV4 {
class ExecutableCompilationUnit} +/

/// Binding for C++ class [QQmlComponent](https://doc.qt.io/qt-6/qqmlcomponent.html).
class /+ Q_QML_EXPORT +/ QQmlComponent : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QQmlComponent) +/

    /+ Q_PROPERTY(qreal progress READ progress NOTIFY progressChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)
    Q_PROPERTY(QUrl url READ url CONSTANT)
    QML_NAMED_ELEMENT(Component)
    QML_ADDED_IN_VERSION(2, 0)
    QML_ATTACHED(QQmlComponentAttached) +/

public:
    enum CompilationMode { PreferSynchronous, Asynchronous }
    /+ Q_ENUM(CompilationMode) +/

    this(QObject parent = null);
    this(QQmlEngine , QObject parent = null);
    this(QQmlEngine , ref const(QString) fileName, QObject parent = null);
    this(QQmlEngine , ref const(QString) fileName, CompilationMode mode, QObject parent = null);
    this(QQmlEngine , ref const(QUrl) url, QObject parent = null);
    this(QQmlEngine , ref const(QUrl) url, CompilationMode mode, QObject parent = null);
    ~this();

    enum Status { Null, Ready, Loading, Error }
    /+ Q_ENUM(Status) +/
    final Status status() const;

    final bool isNull() const;
    final bool isReady() const;
    final bool isError() const;
    final bool isLoading() const;

    final QList!(QQmlError) errors() const;
    @QInvokable final QString errorString() const;

    final qreal progress() const;

    final QUrl url() const;

    /+ virtual +/ QObject create(QQmlContext context = null);
    /+ QObject *createWithInitialProperties(const QVariantMap& initialProperties, QQmlContext *context = nullptr); +/
    /+ void setInitialProperties(QObject *component, const QVariantMap &properties); +/
    /+ virtual +/ QObject beginCreate(QQmlContext );
    /+ virtual +/ void completeCreate();

    /+ void create(QQmlIncubator &, QQmlContext *context = nullptr,
                QQmlContext *forContext = nullptr); +/

    final QQmlContext creationContext() const;
    final QQmlEngine engine() const;

    static QQmlComponentAttached* qmlAttachedProperties(QObject );

public /+ Q_SLOTS +/:
    @QSlot final void loadUrl(ref const(QUrl) url);
    @QSlot final void loadUrl(ref const(QUrl) url, CompilationMode mode);
    @QSlot final void setData(ref const(QByteArray) , ref const(QUrl) baseUrl);

/+ Q_SIGNALS +/public:
    @QSignal final void statusChanged(Status);
    @QSignal final void progressChanged(qreal);

protected:
    this(ref QQmlComponentPrivate dd, QObject parent);
    @QInvokable final void createObject(QQmlV4Function* );
    @QInvokable final void incubateObject(QQmlV4Function* );

private:
    this(QQmlEngine , /+ QV4:: +/qt.qml.private_.ExecutableCompilationUnit* compilationUnit, int,
                      QObject parent);

    /+ Q_DISABLE_COPY(QQmlComponent) +/
    /+ friend class QQmlTypeData; +/
    /+ friend class QQmlObjectCreator; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


// Don't do this at home.
/+ namespace QQmlPrivate {

// Generally you cannot use QQmlComponentAttached as attached properties object in derived classes.
// It is private.
template<class T>
struct OverridableAttachedType<T, QQmlComponentAttached>
{
    using Type = void;
};

// QQmlComponent itself is allowed to use QQmlComponentAttached, though.
template<>
struct OverridableAttachedType<QQmlComponent, QQmlComponentAttached>
{
    using Type = QQmlComponentAttached;
};

} // namespace QQmlPrivate


QML_DECLARE_TYPE(QQmlComponent) +/

