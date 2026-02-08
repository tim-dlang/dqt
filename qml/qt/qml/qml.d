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

#define QML_DECLARE_TYPE(TYPE) \
    Q_DECLARE_METATYPE(TYPE*) \
    Q_DECLARE_METATYPE(QQmlListProperty<TYPE>)

#define QML_DECLARE_TYPE_HASMETATYPE(TYPE) \
    Q_DECLARE_METATYPE(QQmlListProperty<TYPE>)

#define QML_DECLARE_INTERFACE(INTERFACE) \
    QML_DECLARE_TYPE(INTERFACE)

#define QML_DECLARE_INTERFACE_HASMETATYPE(INTERFACE) \
    QML_DECLARE_TYPE_HASMETATYPE(INTERFACE) +/

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
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        0,
        null, null,
        QString(),
        /+ QQmlPrivate:: +/ValueType!(T, void).create,

        uri, QTypeRevision.fromVersion(versionMajor, 0), null,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        null,
        QTypeRevision.zero(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

//! \internal
int qmlRegisterAnonymousType(T, int metaObjectRevisionMinor)(const(char)* uri, int versionMajor)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        0,
        null,
        null,
        QString(),
        /+ QQmlPrivate:: +/ValueType!(T, void).create,

        uri,
        QTypeRevision.fromVersion(versionMajor, 0),
        null,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T, ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T, ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T, QQmlPropertyValueInterceptor).cast_(),

        null,
        null,

        null,
        QTypeRevision.fromMinorVersion(metaObjectRevisionMinor),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T, QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

//! \internal
void qmlRegisterAnonymousTypesAndRevisions(T)(const(char)* uri, int versionMajor)
{
    import qt.core.vector;

    /+ QQmlPrivate:: +/qt.qml.private_.qmlRegisterTypeAndRevisions!(T, void)(
            uri, versionMajor, /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(), null,
            null, true);
}

int /+ Q_QML_EXPORT +/ qmlRegisterTypeNotAvailable(const(char)* uri, int versionMajor, int versionMinor,
                                             const(char)* qmlName, ref const(QString) message);

int qmlRegisterUncreatableType(T)(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName, ref const(QString) reason)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        0,
        null,
        null,
        reason,
        /+ QQmlPrivate:: +/ValueType!(T, void).create,

        uri, QTypeRevision.fromVersion(versionMajor, versionMinor), qmlName,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        null,
        QTypeRevision.zero(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterUncreatableType(T, int metaObjectRevision)(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName, ref const(QString) reason)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        0,
        null,
        null,
        reason,
        /+ QQmlPrivate:: +/ValueType!(T, void).create,

        uri, QTypeRevision.fromVersion(versionMajor, versionMinor), qmlName,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        null,
        QTypeRevision.fromMinorVersion(metaObjectRevision),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterExtendedUncreatableType(T, E)(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName, ref const(QString) reason)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    QQmlAttachedPropertiesFunc attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(E)();
    const(QMetaObject)*  attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(E)();
    if (!attached) {
        attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)();
        attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)();
    }

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        0,
        null,
        null,
        reason,
        /+ QQmlPrivate:: +/ValueType!(T, E).create,

        uri, QTypeRevision.fromVersion(versionMajor, versionMinor), qmlName,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        attached,
        attachedMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        /+ QQmlPrivate:: +/ExtendedType!(E).createParent, /+ QQmlPrivate:: +/ExtendedType!(E).staticMetaObject(),

        null,
        QTypeRevision.zero(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterExtendedUncreatableType(T, E, int metaObjectRevision)(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName, ref const(QString) reason)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    QQmlAttachedPropertiesFunc attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(E)();
    const(QMetaObject)*  attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(E)();
    if (!attached) {
        attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)();
        attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)();
    }

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        0,
        null,
        null,
        reason,
        /+ QQmlPrivate:: +/ValueType!(T, E).create,

        uri, QTypeRevision.fromVersion(versionMajor, versionMinor), qmlName,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        attached,
        attachedMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        /+ QQmlPrivate:: +/ExtendedType!(E).createParent, /+ QQmlPrivate:: +/ExtendedType!(E).staticMetaObject(),

        null,
        QTypeRevision.fromMinorVersion(metaObjectRevision),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

/+ Q_QML_EXPORT +/ int qmlRegisterUncreatableMetaObject(ref const(QMetaObject) staticMetaObject, const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName, ref const(QString) reason);

int qmlRegisterType(T)(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        cast(int) (T.sizeof), /+ QQmlPrivate:: +/Constructors!(T).createInto, null,
        QString(),
        /+ QQmlPrivate:: +/ValueType!(T, void).create,

        uri, QTypeRevision.fromVersion(versionMajor, versionMinor), qmlName,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        null,
        QTypeRevision.zero(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterType(T, int metaObjectRevision)(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        cast(int) (T.sizeof), /+ QQmlPrivate:: +/Constructors!(T).createInto, null,
        QString(),
        /+ QQmlPrivate:: +/ValueType!(T, void).create,

        uri, QTypeRevision.fromVersion(versionMajor, versionMinor), qmlName,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        null,
        QTypeRevision.fromMinorVersion(metaObjectRevision),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterRevision(T, int metaObjectRevision)(const(char)* uri, int versionMajor, int versionMinor)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        cast(int) (T.sizeof), /+ QQmlPrivate:: +/Constructors!(T).createInto, null,
        QString(),
        /+ QQmlPrivate:: +/ValueType!(T, void).create,

        uri, QTypeRevision.fromVersion(versionMajor, versionMinor), null,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        null,
        QTypeRevision.fromMinorVersion(metaObjectRevision),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterExtendedType(T, E)(const(char)* uri, int versionMajor)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        0,
        null,
        null,
        QString(),
        /+ QQmlPrivate:: +/ValueType!(T, E).create,

        uri, QTypeRevision.fromVersion(versionMajor, 0), null,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        /+ QQmlPrivate:: +/ExtendedType!(E).createParent, /+ QQmlPrivate:: +/ExtendedType!(E).staticMetaObject(),

        null,
        QTypeRevision.zero(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterExtendedType(T, E)(const(char)* uri, int versionMajor, int versionMinor,
                            const(char)* qmlName)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    QQmlAttachedPropertiesFunc attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(E)();
    const(QMetaObject)*  attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(E)();
    if (!attached) {
        attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)();
        attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)();
    }

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        cast(int) (T.sizeof), /+ QQmlPrivate:: +/Constructors!(T).createInto, null,
        QString(),
        /+ QQmlPrivate:: +/ValueType!(T, E).create,

        uri, QTypeRevision.fromVersion(versionMajor, versionMinor), qmlName,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        attached,
        attachedMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        /+ QQmlPrivate:: +/ExtendedType!(E).createParent, /+ QQmlPrivate:: +/ExtendedType!(E).staticMetaObject(),

        null,
        QTypeRevision.zero(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterInterface(T)(const(char)* uri, int versionMajor)
{
    import qt.core.metatype;
    import qt.core.versionnumber;
    import qt.qml.list;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterInterface qmlInterface = qt.qml.private_.RegisterInterface(
        0,
        // An interface is not a QObject itself but is typically casted to one.
        // Therefore, we still want the pointer.
        QMetaType.fromType!(T*)(),
        QMetaType.fromType!(QQmlListProperty!(T)) (),
        qobject_interface_iid!(T*)(),

        uri,
        QTypeRevision.fromVersion(versionMajor, 0))
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.InterfaceRegistration, &qmlInterface);
}

int qmlRegisterCustomType(T)(const(char)* uri, int versionMajor, int versionMinor,
                          const(char)* qmlName, QQmlCustomParser* parser)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        cast(int) (T.sizeof), /+ QQmlPrivate:: +/Constructors!(T).createInto, null,
        QString(),
        /+ QQmlPrivate:: +/ValueType!(T, void).create,

        uri, QTypeRevision.fromVersion(versionMajor, versionMinor), qmlName,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        parser,
        QTypeRevision.zero(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterCustomType(T, int metaObjectRevision)(const(char)* uri, int versionMajor, int versionMinor,
                          const(char)* qmlName, QQmlCustomParser* parser)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        cast(int) (T.sizeof), /+ QQmlPrivate:: +/Constructors!(T).createInto, null,
        QString(),
        /+ QQmlPrivate:: +/ValueType!(T, void).create,

        uri, QTypeRevision.fromVersion(versionMajor, versionMinor), qmlName,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)(),
        /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)(),

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        null, null,

        parser,
        QTypeRevision.fromMinorVersion(metaObjectRevision),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}

int qmlRegisterCustomExtendedType(T, E)(const(char)* uri, int versionMajor, int versionMinor,
                          const(char)* qmlName, QQmlCustomParser* parser)
{
    import qt.core.versionnumber;
    import qt.qml.parserstatus;
    import qt.qml.propertyvaluesource;

    QQmlAttachedPropertiesFunc attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(E)();
    const(QMetaObject)*  attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(E)();
    if (!attached) {
        attached = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesFunc!(T)();
        attachedMetaObject = /+ QQmlPrivate:: +/qt.qml.private_.attachedPropertiesMetaObject!(T)();
    }

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterType type = qt.qml.private_.RegisterType(
        1,
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).self(),
        /+ QQmlPrivate:: +/qt.qml.private_.QmlMetaType!(T).list(),
        cast(int) (T.sizeof), /+ QQmlPrivate:: +/Constructors!(T).createInto, null,
        QString(),
        /+ QQmlPrivate:: +/ValueType!(T, E).create,

        uri, QTypeRevision.fromVersion(versionMajor, versionMinor), qmlName,
        /+ QQmlPrivate:: +/qt.qml.private_.StaticMetaObject!(T).staticMetaObject(),

        attached,
        attachedMetaObject,

        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlParserStatus)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,ValueClass!(QQmlPropertyValueSource)).cast_(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlPropertyValueInterceptor).cast_(),

        /+ QQmlPrivate:: +/ExtendedType!(E).createParent, /+ QQmlPrivate:: +/ExtendedType!(E).staticMetaObject(),

        parser,
        QTypeRevision.zero(),
        /+ QQmlPrivate:: +/qt.qml.private_.StaticCastSelector!(T,QQmlFinalizerHook).cast_())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.TypeRegistration, &type);
}


/+ Q_QML_EXPORT +/ void qmlExecuteDeferred(QObject );
mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
/+ Q_QML_EXPORT +/ QQmlContext qmlContext(const(QObject) );
}));
mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
/+ Q_QML_EXPORT +/ QQmlEngine qmlEngine(const(QObject) );
}));
/+ Q_QML_EXPORT +/ QQmlAttachedPropertiesFunc qmlAttachedPropertiesFunction(QObject ,
                                                                      const(QMetaObject)* );
/+ Q_QML_EXPORT +/ QObject qmlAttachedPropertiesObject(QObject , QQmlAttachedPropertiesFunc func,
                                                  bool create = true);
/+ Q_QML_EXPORT +/ QObject qmlExtendedObject(QObject );

//The C++ version of protected namespaces in qmldir
/+ Q_QML_EXPORT +/ bool qmlProtectModule(const(char)* uri, int majVersion);
/+ Q_QML_EXPORT +/ void qmlRegisterModule(const(char)* uri, int versionMajor, int versionMinor);

enum QQmlModuleImportSpecialVersions: int {
    QQmlModuleImportModuleAny = -1,
    QQmlModuleImportLatest = -1,
    QQmlModuleImportAuto = -2
}

/+ Q_QML_EXPORT +/ void qmlRegisterModuleImport(const(char)* uri, int moduleMajor,
                                          const(char)* import_,
                                          int importMajor = QQmlModuleImportSpecialVersions.QQmlModuleImportLatest,
                                          int importMinor = QQmlModuleImportSpecialVersions.QQmlModuleImportLatest);
/+ Q_QML_EXPORT +/ void qmlUnregisterModuleImport(const(char)* uri, int moduleMajor,
                                            const(char)* import_,
                                            int importMajor = QQmlModuleImportSpecialVersions.QQmlModuleImportLatest,
                                            int importMinor = QQmlModuleImportSpecialVersions.QQmlModuleImportLatest);

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

        uri, QTypeRevision::fromVersion(versionMajor, versionMinor), typeName,

        callback,
        nullptr, nullptr, QMetaType(),
        nullptr, nullptr,
        QTypeRevision::zero()
    };

    return QQmlPrivate::qmlregister(QQmlPrivate::SingletonRegistration, &api);
}

template <typename T>
inline int qmlRegisterSingletonType(
        const char *uri, int versionMajor, int versionMinor,  const char *typeName,
        QObject *(*callback)(QQmlEngine *, QJSEngine *))
{
    QQmlPrivate::RegisterSingletonType api = {
        0,
        uri,
        QTypeRevision::fromVersion(versionMajor, versionMinor),
        typeName,
        nullptr,
        callback,
        QQmlPrivate::StaticMetaObject<T>::staticMetaObject(),
        QQmlPrivate::QmlMetaType<T>::self(),
        nullptr, nullptr,
        QTypeRevision::zero()
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
    QQmlPrivate::RegisterSingletonType api = {
        0,
        uri,
        QTypeRevision::fromVersion(versionMajor, versionMinor),
        typeName,
        nullptr,
        callback,
        QQmlPrivate::StaticMetaObject<T>::staticMetaObject(),
        QQmlPrivate::QmlMetaType<T>::self(),
        nullptr, nullptr,
        QTypeRevision::zero()
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

    /+ QQmlPrivate:: +/qt.qml.private_.SingletonInstanceFunctor registrationFunctor;
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
        0,
        url,
        uri,
        QTypeRevision::fromVersion(versionMajor, versionMinor),
        qmlName
    };

    return QQmlPrivate::qmlregister(QQmlPrivate::CompositeSingletonRegistration, &type);
} +/

/+ pragma(inline, true) int qmlRegisterType(ref const(QUrl) url, const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName)
{
    import qt.core.versionnumber;
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
        0,
        url,
        uri,
        QTypeRevision.fromVersion(versionMajor, versionMinor),
        qmlName)
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.CompositeRegistration, &type);
}+/

pragma(inline, true) int qmlRegisterAnonymousSequentialContainer(Container)(const(char)* uri, int versionMajor)
{
    import qt.core.metacontainer;
    import qt.core.metatype;
    import qt.core.versionnumber;

    /+ QQmlPrivate:: +/qt.qml.private_.RegisterSequentialContainer type = qt.qml.private_.RegisterSequentialContainer(
        0,
        uri,
        QTypeRevision.fromMajorVersion(versionMajor),
        null,
        QMetaType.fromType!(Container)(),
        QMetaSequence.fromContainer!(Container)(),
        QTypeRevision.zero())
    ;

    return /+ QQmlPrivate:: +/qt.qml.private_.qmlregister(/+ QQmlPrivate:: +/qt.qml.private_.RegistrationType.SequentialContainerRegistration, &type);
}

/+ template<class T, class Resolved, class Extended, bool Singleton, bool Interface, bool Sequence>
struct QmlTypeAndRevisionsRegistration;

template<class T, class Resolved, class Extended>
struct QmlTypeAndRevisionsRegistration<T, Resolved, Extended, false, false, false> {
    static void registerTypeAndRevisions(const char *uri, int versionMajor, QList<int> *qmlTypeIds,
                                         const QMetaObject *extension)
    {
        QQmlPrivate::qmlRegisterTypeAndRevisions<Resolved, Extended>(
                    uri, versionMajor, QQmlPrivate::StaticMetaObject<T>::staticMetaObject(),
                    qmlTypeIds, extension);
    }
};

template<class T, class Resolved>
struct QmlTypeAndRevisionsRegistration<T, Resolved, void, false, false, true> {
    static void registerTypeAndRevisions(const char *uri, int versionMajor, QList<int> *qmlTypeIds,
                                         const QMetaObject *)
    {
        QQmlPrivate::qmlRegisterSequenceAndRevisions<Resolved>(
                    uri, versionMajor, QQmlPrivate::StaticMetaObject<T>::staticMetaObject(),
                    qmlTypeIds);
    }
};

template<class T, class Resolved, class Extended>
struct QmlTypeAndRevisionsRegistration<T, Resolved, Extended, true, false, false> {
    static void registerTypeAndRevisions(const char *uri, int versionMajor, QList<int> *qmlTypeIds,
                                         const QMetaObject *extension)
    {
        QQmlPrivate::qmlRegisterSingletonAndRevisions<Resolved, Extended, T>(
                    uri, versionMajor, QQmlPrivate::StaticMetaObject<T>::staticMetaObject(),
                    qmlTypeIds, extension);
    }
};

template<class T, class Resolved>
struct QmlTypeAndRevisionsRegistration<T, Resolved, void, false, true, false> {
    static void registerTypeAndRevisions(const char *uri, int versionMajor, QList<int> *qmlTypeIds,
                                         const QMetaObject *)
    {
        const int id = qmlRegisterInterface<Resolved>(uri, versionMajor);
        if (qmlTypeIds)
            qmlTypeIds->append(id);
    }
};

template<typename... T>
void qmlRegisterTypesAndRevisions(const char *uri, int versionMajor, QList<int> *qmlTypeIds)
{
    (QmlTypeAndRevisionsRegistration<
            T, typename QQmlPrivate::QmlResolved<T>::Type,
            typename QQmlPrivate::QmlExtended<T>::Type,
            QQmlPrivate::QmlSingleton<T>::Value,
            QQmlPrivate::QmlInterface<T>::Value,
            QQmlPrivate::QmlSequence<T>::Value>
            ::registerTypeAndRevisions(uri, versionMajor, qmlTypeIds,
                                       QQmlPrivate::QmlExtendedNamespace<T>::metaObject()), ...);
}

inline void qmlRegisterNamespaceAndRevisions(const QMetaObject *metaObject,
                                             const char *uri, int versionMajor,
                                             QList<int> *qmlTypeIds,
                                             const QMetaObject *classInfoMetaObject,
                                             const QMetaObject *extensionMetaObject)
{
    QQmlPrivate::RegisterTypeAndRevisions type = {
        3,
        QMetaType(),
        QMetaType(),
        0,
        nullptr,
        nullptr,
        nullptr,

        uri,
        QTypeRevision::fromMajorVersion(versionMajor),

        metaObject,
        (classInfoMetaObject ? classInfoMetaObject : metaObject),

        nullptr,
        nullptr,

        -1,
        -1,
        -1,

        nullptr,
        extensionMetaObject,

        &qmlCreateCustomParser<void>,
        qmlTypeIds,
        -1,
        false,
        QMetaSequence()
    };

    qmlregister(QQmlPrivate::TypeAndRevisionsRegistration, &type);
}

inline void qmlRegisterNamespaceAndRevisions(const QMetaObject *metaObject,
                                             const char *uri, int versionMajor,
                                             QList<int> *qmlTypeIds = nullptr,
                                             const QMetaObject *classInfoMetaObject = nullptr)
{
    qmlRegisterNamespaceAndRevisions(metaObject, uri, versionMajor, qmlTypeIds,
                                     classInfoMetaObject, nullptr);
} +/

int /+ Q_QML_EXPORT +/ qmlTypeId(const(char)* uri, int versionMajor, int versionMinor, const(char)* qmlName);

