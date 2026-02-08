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
module qt.qml.qml;
extern(C++):

import qt.config;
import qt.core.object;
import qt.core.objectdefs;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.qml.context;
import qt.qml.engine;
import qt.qml.private_;

/+ #define QML_VERSION     0x020000
#define QML_VERSION_STR "2.0"

#define QML_PRIVATE_NAMESPACE \
    QT_PREPEND_NAMESPACE(QQmlPrivate)

#define QML_REGISTER_TYPES_AND_REVISIONS \
    QT_PREPEND_NAMESPACE(qmlRegisterTypesAndRevisions)

#define QML_DECLARE_TYPE(TYPE) \
    Q_DECLARE_METATYPE(TYPE *) \
    Q_DECLARE_METATYPE(QQmlListProperty<TYPE>)

#define QML_DECLARE_TYPE_HASMETATYPE(TYPE) \
    Q_DECLARE_METATYPE(QQmlListProperty<TYPE>)

#define QML_DECLARE_INTERFACE(INTERFACE) \
    QML_DECLARE_TYPE(INTERFACE)

#define QML_DECLARE_INTERFACE_HASMETATYPE(INTERFACE) \
    QML_DECLARE_TYPE_HASMETATYPE(INTERFACE)

#define QML_ELEMENT \
    Q_CLASSINFO("QML.Element", "auto")

#define QML_ANONYMOUS \
    Q_CLASSINFO("QML.Element", "anonymous")

#define QML_NAMED_ELEMENT(NAME) \
    Q_CLASSINFO("QML.Element", #NAME)

#define QML_UNCREATABLE(REASON) \
    Q_CLASSINFO("QML.Creatable", "false") \
    Q_CLASSINFO("QML.UncreatableReason", REASON)

#define QML_SINGLETON \
    Q_CLASSINFO("QML.Singleton", "true") \
    enum class QmlIsSingleton {yes = true}; \
    template<typename, typename> friend struct QML_PRIVATE_NAMESPACE::QmlSingleton; \
    template<typename T, typename... Args> \
    friend void QML_REGISTER_TYPES_AND_REVISIONS(const char *uri, int versionMajor);

#define QML_ADDED_IN_MINOR_VERSION(VERSION) \
    Q_CLASSINFO("QML.AddedInMinorVersion", #VERSION)

#define QML_REMOVED_IN_MINOR_VERSION(VERSION) \
    Q_CLASSINFO("QML.RemovedInMinorVersion", #VERSION)

#define QML_ATTACHED(ATTACHED_TYPE) \
    Q_CLASSINFO("QML.Attached", #ATTACHED_TYPE) \
    using QmlAttachedType = ATTACHED_TYPE; \
    template<class, class, bool> friend struct QML_PRIVATE_NAMESPACE::QmlAttached; \
    template<class> friend struct QML_PRIVATE_NAMESPACE::QmlAttachedAccessor;

#define QML_EXTENDED(EXTENDED_TYPE) \
    Q_CLASSINFO("QML.Extended", #EXTENDED_TYPE) \
    using QmlExtendedType = EXTENDED_TYPE; \
    template<class, class> friend struct QML_PRIVATE_NAMESPACE::QmlExtended; \
    template<typename T, typename... Args> \
    friend void QML_REGISTER_TYPES_AND_REVISIONS(const char *uri, int versionMajor);

#define QML_FOREIGN(FOREIGN_TYPE) \
    Q_CLASSINFO("QML.Foreign", #FOREIGN_TYPE) \
    using QmlForeignType = FOREIGN_TYPE; \
    template<class, class> friend struct QML_PRIVATE_NAMESPACE::QmlResolved; \
    template<typename T, typename... Args> \
    friend void QML_REGISTER_TYPES_AND_REVISIONS(const char *uri, int versionMajor);

#define QML_INTERFACE \
    Q_CLASSINFO("QML.Element", "anonymous") \
    enum class QmlIsInterface {yes = true}; \
    template<typename, typename> friend struct QML_PRIVATE_NAMESPACE::QmlInterface; \
    template<typename T, typename... Args> \
    friend void QML_REGISTER_TYPES_AND_REVISIONS(const char *uri, int versionMajor);

#define QML_UNAVAILABLE \
    QML_FOREIGN(QQmlTypeNotAvailable) +/

enum { /* TYPEINFO flags */
    QML_HAS_ATTACHED_PROPERTIES = 0x01
}

/+ #define QML_DECLARE_TYPEINFO(TYPE, FLAGS) \
QT_BEGIN_NAMESPACE \
template <> \
class QQmlTypeInfo<TYPE > \
{ \
public: \
    enum { \
        hasAttachedProperties = (((FLAGS) & QML_HAS_ATTACHED_PROPERTIES) == QML_HAS_ATTACHED_PROPERTIES) \
    }; \
}; \
QT_END_NAMESPACE +/


void /+ Q_QML_EXPORT +/ qmlClearTypeRegistrations();

/+ template<class T>
QQmlCustomParser *qmlCreateCustomParser(); +/

int qmlRegisterAnonymousType(T)(const(char)* uri, int versionMajor)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        0,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        0,
        null,
        QString(),

        uri, versionMajor, 0, null, &T.staticMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        null,
        0)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

/+ #if QT_DEPRECATED_SINCE(5, 14) +/
/+ QT_DEPRECATED_VERSION_X_5_14("Use qmlRegisterAnonymousType instead") +/ int qmlRegisterType(T)()
{
    return qmlRegisterAnonymousType!(T)("", 1);
}
/+ #endif +/

int /+ Q_QML_EXPORT +/ qmlRegisterTypeNotAvailable(const(char)* uri, int versionMajor, int versionMinor,
                                             const(char)* qmlName, ref const(QString) message);

int qmlRegisterUncreatableType(T)(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName, ref const(QString) reason)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        0,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        0,
        null,
        reason,

        uri, versionMajor, versionMinor, qmlName, &T.staticMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        null,
        0)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterUncreatableType(T, int metaObjectRevision)(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName, ref const(QString) reason)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        0,
        null,
        reason,

        uri, versionMajor, versionMinor, qmlName, &T.staticMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        null,
        metaObjectRevision)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterExtendedUncreatableType(T, E)(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName, ref const(QString) reason)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    QQmlAttachedPropertiesFunc attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(E)();
    const(QMetaObject)*  attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(E)();
    if (!attached) {
        attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)();
        attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)();
    }

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        0,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        0,
        null,
        reason,

        uri, versionMajor, versionMinor, qmlName, &T.staticMetaObject,

        attached,
        attachedMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        &/+ QQmlPrivate:: +/qt.qml.private_.createParent!(E), &E.staticMetaObject,

        null,
        0)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterExtendedUncreatableType(T, E, int metaObjectRevision)(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName, ref const(QString) reason)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    QQmlAttachedPropertiesFunc attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(E)();
    const(QMetaObject)*  attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(E)();
    if (!attached) {
        attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)();
        attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)();
    }

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        0,
        null,
        reason,

        uri, versionMajor, versionMinor, qmlName, &T.staticMetaObject,

        attached,
        attachedMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        &/+ QQmlPrivate:: +/qt.qml.private_.createParent!(E), &E.staticMetaObject,

        null,
        metaObjectRevision)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

/+ Q_QML_EXPORT +/ int qmlRegisterUncreatableMetaObject(ref const(QMetaObject) staticMetaObject, const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName, ref const(QString) reason);

int qmlRegisterType(T)(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        0,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        cast(int) (T.sizeof), &/+ QQmlPrivate:: +/qt.qml.private_.createInto!(T),
        QString(),

        uri, versionMajor, versionMinor, qmlName, &T.staticMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        null,
        0)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterType(T, int metaObjectRevision)(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        cast(int) (T.sizeof), &/+ QQmlPrivate:: +/qt.qml.private_.createInto!(T),
        QString(),

        uri, versionMajor, versionMinor, qmlName, &T.staticMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        null,
        metaObjectRevision)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterRevision(T, int metaObjectRevision)(const(char)* uri, int versionMajor, int versionMinor)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        cast(int) (T.sizeof), &/+ QQmlPrivate:: +/qt.qml.private_.createInto!(T),
        QString(),

        uri, versionMajor, versionMinor, null, &T.staticMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        null,
        metaObjectRevision)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterExtendedType(T, E)(const(char)* uri, int versionMajor)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        0,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        0,
        null,
        QString(),

        uri, versionMajor, 0, null, &T.staticMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        &/+ QQmlPrivate:: +/qt.qml.private_.createParent!(E), &E.staticMetaObject,

        null,
        0)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

/+ #if QT_DEPRECATED_SINCE(5, 15) +/
/+ QT_DEPRECATED_VERSION_X_5_15("Use qmlRegisterExtendedType(uri, versionMajor) instead") +/
int qmlRegisterExtendedType(T, E)()
{
    return qmlRegisterExtendedType!(T, E)("", 0);
}
/+ #endif +/

int qmlRegisterExtendedType(T, E)(const(char)* uri, int versionMajor, int versionMinor,
                            const(char)* qmlName)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    QQmlAttachedPropertiesFunc attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(E)();
    const(QMetaObject)*  attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(E)();
    if (!attached) {
        attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)();
        attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)();
    }

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        0,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        cast(int) (T.sizeof), &/+ QQmlPrivate:: +/qt.qml.private_.createInto!(T),
        QString(),

        uri, versionMajor, versionMinor, qmlName, &T.staticMetaObject,

        attached,
        attachedMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        &/+ QQmlPrivate:: +/qt.qml.private_.createParent!(E), &E.staticMetaObject,

        null,
        0)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

/+ #if QT_DEPRECATED_SINCE(5, 15) +/
/+ QT_DEPRECATED_VERSION_X_5_15("Use qmlRegisterInterface(uri, versionMajor) instead") +/
int qmlRegisterInterface(T)(const(char)* typeName)
{
    import qt.core.bytearray;
    import qt.core.metatype;
    import qt.qml.list;

    auto name = QByteArray(typeName);

    auto pointerName = QByteArray(name ~ '*');
    auto listName = QByteArray("QQmlListProperty<".ptr ~ name + '>');

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterInterface qmlInterface = qt.qml.private_.RegisterInterface(
        1,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),

        qobject_interface_iid!(T*)(),
        "".ptr,
        0)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.InterfaceRegistration, &qmlInterface);
}
/+ #endif +/

int qmlRegisterInterface(T)(const(char)* uri, int versionMajor)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    /+ QQmlPrivate:: +/qt.qml.private_.RegisterInterface qmlInterface = qt.qml.private_.RegisterInterface(
        1,
        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T))(listName.constData()),
        qobject_interface_iid!(T*)(),

        uri,
        versionMajor)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.InterfaceRegistration, &qmlInterface);
}

int qmlRegisterCustomType(T)(const(char)* uri, int versionMajor, int versionMinor,
                          const(char)* qmlName, QQmlCustomParser* parser)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        0,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        cast(int) (T.sizeof), &/+ QQmlPrivate:: +/qt.qml.private_.createInto!(T),
        QString(),

        uri, versionMajor, versionMinor, qmlName, &T.staticMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        parser,
        0)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterCustomType(T, int metaObjectRevision)(const(char)* uri, int versionMajor, int versionMinor,
                          const(char)* qmlName, QQmlCustomParser* parser)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        cast(int) (T.sizeof), &/+ QQmlPrivate:: +/qt.qml.private_.createInto!(T),
        QString(),

        uri, versionMajor, versionMinor, qmlName, &T.staticMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        parser,
        metaObjectRevision)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterCustomExtendedType(T, E)(const(char)* uri, int versionMajor, int versionMinor,
                          const(char)* qmlName, QQmlCustomParser* parser)
{
    import core.stdc.string;
    import qt.core.metatype;
    import qt.qml.list;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
    QQmlAttachedPropertiesFunc attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(E)();
    const(QMetaObject)*  attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(E)();
    if (!attached) {
        attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)();
        attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)();
    }

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        0,

        qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
        qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
        cast(int) (T.sizeof), &/+ QQmlPrivate:: +/qt.qml.private_.createInto!(T),
        QString(),

        uri, versionMajor, versionMinor, qmlName, &T.staticMetaObject,

        attached,
        attachedMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        &/+ QQmlPrivate:: +/qt.qml.private_.createParent!(E), &E.staticMetaObject,

        parser,
        0)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}


/+ #ifndef Q_QDOC +/
extern(C++, "QtQml") {
/+ #endif +/
    // declared in namespace to avoid symbol conflicts with QtDeclarative
    /+ Q_QML_EXPORT +/ void qmlExecuteDeferred(QObject );
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ Q_QML_EXPORT +/ QQmlContext qmlContext(const(QObject) );
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ Q_QML_EXPORT +/ QQmlEngine qmlEngine(const(QObject) );
    }));
/+ #if QT_DEPRECATED_SINCE(5, 14) +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ Q_QML_EXPORT +/ /+ QT_DEPRECATED_VERSION_X_5_14("Use qmlAttachedPropertiesObject(QObject *, QQmlAttachedPropertiesFunc, bool") +/
        QObject qmlAttachedPropertiesObjectById(int, const(QObject) , bool create = true);
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ Q_QML_EXPORT +/ /+ QT_DEPRECATED_VERSION_X_5_14("Use qmlAttachedPropertiesObject(QObject *, QQmlAttachedPropertiesFunc, bool") +/
        QObject qmlAttachedPropertiesObject(
                int* , const(QObject) , const(QMetaObject)* , bool create);
    }));
/+ #endif +/
    /+ Q_QML_EXPORT +/ QQmlAttachedPropertiesFunc qmlAttachedPropertiesFunction(QObject ,
                                                                              const(QMetaObject)* );
    /+ Q_QML_EXPORT +/ QObject qmlAttachedPropertiesObject(QObject , QQmlAttachedPropertiesFunc func,
                                                          bool create = true);
/+ #ifndef Q_QDOC +/
}

/+ QT_WARNING_PUSH
QT_WARNING_DISABLE_CLANG("-Wheader-hygiene")

// This is necessary to allow for QtQuick1 and QtQuick2 scenes in a single application.
using namespace QtQml;

QT_WARNING_POP +/

/+ #endif +/ // Q_QDOC

//The C++ version of protected namespaces in qmldir
/+ Q_QML_EXPORT +/ bool qmlProtectModule(const(char)* uri, int majVersion);
/+ Q_QML_EXPORT +/ void qmlRegisterModule(const(char)* uri, int versionMajor, int versionMinor);

QObject qmlAttachedPropertiesObject(T)(const(QObject) obj, bool create = true)
{
    // We don't need a concrete object to resolve the function. As T is a C++ type, it and all its
    // super types should be registered as CppType (or not at all). We only need the object and its
    // QML engine to resolve composite types. Therefore, the function is actually a static property
    // of the C++ type system and we can cache it here for improved performance on further lookups.
    extern(D) static __gshared const func = qmlAttachedPropertiesFunction(null, &T.staticMetaObject);
    return qmlAttachedPropertiesObject(const_cast!(QObject)(obj), func, create);
}

/+ inline int qmlRegisterSingletonType(const char *uri, int versionMajor, int versionMinor, const char *typeName,
                                QJSValue (*callback)(QQmlEngine *, QJSEngine *))
{
    QQmlPrivate::RegisterSingletonType api = {
        0,

        uri, versionMajor, versionMinor, typeName,

        callback, nullptr, nullptr, 0, 0, {}
    };

    return QQmlPrivate::qmlregister(QQmlPrivate::SingletonRegistration, &api);
} +/

enum { QmlCurrentSingletonTypeRegistrationVersion = 3 }
/+ template <typename T>
inline int qmlRegisterSingletonType(const char *uri, int versionMajor, int versionMinor, const char *typeName,
                                QObject *(*callback)(QQmlEngine *, QJSEngine *))
{
    QML_GETTYPENAMES

    QQmlPrivate::RegisterSingletonType api = {
        QmlCurrentSingletonTypeRegistrationVersion,

        uri, versionMajor, versionMinor, typeName,

        nullptr, nullptr, &T::staticMetaObject, qRegisterNormalizedMetaType<T *>(pointerName.constData()), 0, callback
    };

    return QQmlPrivate::qmlregister(QQmlPrivate::SingletonRegistration, &api);
}

#ifdef Q_QDOC
template <typename T>
int qmlRegisterSingletonType(const char *uri, int versionMajor, int versionMinor, const char *typeName, std::function<QObject*(QQmlEngine *, QJSEngine *)> callback)
#else
template <typename T, typename F, typename std::enable_if<std::is_convertible<F, std::function<QObject *(QQmlEngine *, QJSEngine *)>>::value
                                                 && !std::is_convertible<F, QObject *(*)(QQmlEngine *, QJSEngine *)>::value, void>::type* = nullptr>
inline int qmlRegisterSingletonType(const char *uri, int versionMajor, int versionMinor, const char *typeName,
                                    F&& callback)
#endif
{

    QML_GETTYPENAMES

    QQmlPrivate::RegisterSingletonType api = {
        QmlCurrentSingletonTypeRegistrationVersion,

        uri, versionMajor, versionMinor, typeName,

        nullptr, nullptr, &T::staticMetaObject, qRegisterNormalizedMetaType<T *>(pointerName.constData()), 0, callback
    };

    return QQmlPrivate::qmlregister(QQmlPrivate::SingletonRegistration, &api);
}

#ifdef Q_QDOC +/
static if (false)
{
/+ int qmlRegisterSingletonInstance(const char *uri, int versionMajor, int versionMinor, const char *typeName, QObject *cppObject) +/
}
/+ #else +/
pragma(inline, true) auto qmlRegisterSingletonInstance(T)(const(char)* uri, int versionMajor, int versionMinor,
                                         const(char)* typeName, T* cppObject) /+ -> typename std::enable_if<std::is_base_of<QObject, T>::value, int>::type +/
/+ #endif +/
{
    import qt.core.pointer;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterSingletonFunctor registrationFunctor;
    registrationFunctor.m_object = cast(QPointer!(ValueClass!(QObject))) (cppObject);
    return qmlRegisterSingletonType!(T)(uri, versionMajor, versionMinor, typeName, registrationFunctor);
}

/+ inline int qmlRegisterSingletonType(const QUrl &url, const char *uri, int versionMajor, int versionMinor, const char *qmlName)
{
    if (url.isRelative()) {
        // User input check must go here, because QQmlPrivate::qmlregister is also used internally for composite types
        qWarning("qmlRegisterSingletonType requires absolute URLs.");
        return 0;
    }

    QQmlPrivate::RegisterCompositeSingletonType type = {
        url,
        uri,
        versionMajor,
        versionMinor,
        qmlName
    };

    return QQmlPrivate::qmlregister(QQmlPrivate::CompositeSingletonRegistration, &type);
} +/

/+ pragma(inline, true) int qmlRegisterType(ref const(QUrl) url, const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName)
{
    version (QT_NO_WARNING_OUTPUT) {} else
        import qt.core.logging;

    if (url.isRelative()) {
        // User input check must go here, because QQmlPrivate::qmlregister is also used internally for composite types
        static if (!versionIsSet!("QT_NO_WARNING_OUTPUT"))
        {
            mixin(qWarning)("qmlRegisterType requires absolute URLs.");
        }
        else
        {
    while(false)QMessageLogger().noDebug("qmlRegisterType requires absolute URLs.");
        }
        return 0;
    }

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterCompositeType type = qt.qml.private_.RegisterCompositeType(
        url,
        uri,
        versionMajor,
        versionMinor,
        qmlName)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.CompositeRegistration, &type);
}+/

/+ template<class T, class Resolved, class Extended, bool Singleton, bool Interface>
struct QmlTypeAndRevisionsRegistration;

template<class T, class Resolved, class Extended>
struct QmlTypeAndRevisionsRegistration<T, Resolved, Extended, false, false> {
    static void registerTypeAndRevisions(const char *uri, int versionMajor)
    {
        QQmlPrivate::qmlRegisterTypeAndRevisions<Resolved, Extended>(
                    uri, versionMajor, &T::staticMetaObject);
    }
};

template<class T, class Resolved>
struct QmlTypeAndRevisionsRegistration<T, Resolved, void, true, false> {
    static void registerTypeAndRevisions(const char *uri, int versionMajor)
    {
        QQmlPrivate::qmlRegisterSingletonAndRevisions<Resolved>(
                    uri, versionMajor, &T::staticMetaObject);
    }
};

template<class T, class Resolved>
struct QmlTypeAndRevisionsRegistration<T, Resolved, void, false, true> {
    static void registerTypeAndRevisions(const char *uri, int versionMajor)
    {
        qmlRegisterInterface<Resolved>(uri, versionMajor);
    }
};

template<typename T = void, typename... Args>
void qmlRegisterTypesAndRevisions(const char *uri, int versionMajor);

template<typename T, typename... Args>
void qmlRegisterTypesAndRevisions(const char *uri, int versionMajor)
{
    QmlTypeAndRevisionsRegistration<
            T, typename QQmlPrivate::QmlResolved<T>::Type,
            typename QQmlPrivate::QmlExtended<T>::Type,
            QQmlPrivate::QmlSingleton<T>::Value,
            QQmlPrivate::QmlInterface<T>::Value>
            ::registerTypeAndRevisions(uri, versionMajor);
    qmlRegisterTypesAndRevisions<Args...>(uri, versionMajor);
}

template<>
inline void qmlRegisterTypesAndRevisions<>(const char *, int) {} +/

pragma(inline, true) void qmlRegisterNamespaceAndRevisions(const(QMetaObject)* metaObject,
                                             const(char)* uri, int versionMajor)
{
    /+ QQmlPrivate:: +/qt.qml.private_.RegisterTypeAndRevisions type = qt.qml.private_.RegisterTypeAndRevisions(
        0,
        0,
        0,
        0,
        null,

        uri,
        versionMajor,

        metaObject,
        metaObject,

        cast(qt.qml.private_.QQmlAttachedPropertiesFuncC!(QObject)) (null),
        null,

        -1,
        -1,
        -1,

        null,
        null,

        &qmlCreateCustomParser!(void))
    ;

    qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeAndRevisionsRegistration, &type);
}

int /+ Q_QML_EXPORT +/ qmlTypeId(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName);


/+ QML_DECLARE_TYPE(QObject)
Q_DECLARE_METATYPE(QVariant) +/

