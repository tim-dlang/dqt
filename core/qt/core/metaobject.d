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
module qt.core.metaobject;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.list;
import qt.core.namespace;
import qt.core.object;
import qt.core.objectdefs;
import qt.core.typeinfo;
import qt.core.variant;
import qt.helpers;


/+ #define Q_METAMETHOD_INVOKE_MAX_ARGS 10 +/

/// Binding for C++ class [QMetaMethod](https://doc.qt.io/qt-5/qmetamethod.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QMetaMethod
{
public:
    @disable this();
    /+pragma(inline, true) this()
    {
        this.mobj = null;
        this.handle = 0;
    }+/

    QByteArray methodSignature() const;
    QByteArray name() const;
    const(char)* typeName() const;
    int returnType() const;
    int parameterCount() const;
    int parameterType(int index) const;
    void getParameterTypes(int* types) const;
    QList!(QByteArray) parameterTypes() const;
    QList!(QByteArray) parameterNames() const;
    const(char)* tag() const;
    enum Access { Private, Protected, Public }
    Access access() const;
    enum MethodType { Method, Signal, Slot, Constructor }
    MethodType methodType() const;
    enum Attributes { Compatibility = 0x1, Cloned = 0x2, Scriptable = 0x4 }
    int attributes() const;
    int methodIndex() const;
    int revision() const;

    pragma(inline, true) const(QMetaObject)* enclosingMetaObject() const { return mobj; }

    bool invoke(QObject object,
                    /+ Qt:: +/qt.core.namespace.ConnectionType connectionType,
                    QGenericReturnArgument returnValue,
                    QGenericArgument val0 = QGenericArgument(null),
                    QGenericArgument val1 = QGenericArgument(),
                    QGenericArgument val2 = QGenericArgument(),
                    QGenericArgument val3 = QGenericArgument(),
                    QGenericArgument val4 = QGenericArgument(),
                    QGenericArgument val5 = QGenericArgument(),
                    QGenericArgument val6 = QGenericArgument(),
                    QGenericArgument val7 = QGenericArgument(),
                    QGenericArgument val8 = QGenericArgument(),
                    QGenericArgument val9 = QGenericArgument()) const;
    pragma(inline, true) bool invoke(QObject object,
                           QGenericReturnArgument returnValue,
                           QGenericArgument val0 = QGenericArgument(null),
                           QGenericArgument val1 = QGenericArgument(),
                           QGenericArgument val2 = QGenericArgument(),
                           QGenericArgument val3 = QGenericArgument(),
                           QGenericArgument val4 = QGenericArgument(),
                           QGenericArgument val5 = QGenericArgument(),
                           QGenericArgument val6 = QGenericArgument(),
                           QGenericArgument val7 = QGenericArgument(),
                           QGenericArgument val8 = QGenericArgument(),
                           QGenericArgument val9 = QGenericArgument()) const
    {
        return invoke(object, /+ Qt:: +/qt.core.namespace.ConnectionType.AutoConnection, returnValue,
                      val0, val1, val2, val3, val4, val5, val6, val7, val8, val9);
    }
    pragma(inline, true) bool invoke(QObject object,
                           /+ Qt:: +/qt.core.namespace.ConnectionType connectionType,
                           QGenericArgument val0 = QGenericArgument(null),
                           QGenericArgument val1 = QGenericArgument(),
                           QGenericArgument val2 = QGenericArgument(),
                           QGenericArgument val3 = QGenericArgument(),
                           QGenericArgument val4 = QGenericArgument(),
                           QGenericArgument val5 = QGenericArgument(),
                           QGenericArgument val6 = QGenericArgument(),
                           QGenericArgument val7 = QGenericArgument(),
                           QGenericArgument val8 = QGenericArgument(),
                           QGenericArgument val9 = QGenericArgument()) const
    {
        return invoke(object, connectionType, QGenericReturnArgument(),
                      val0, val1, val2, val3, val4, val5, val6, val7, val8, val9);
    }
    pragma(inline, true) bool invoke(QObject object,
                           QGenericArgument val0 = QGenericArgument(null),
                           QGenericArgument val1 = QGenericArgument(),
                           QGenericArgument val2 = QGenericArgument(),
                           QGenericArgument val3 = QGenericArgument(),
                           QGenericArgument val4 = QGenericArgument(),
                           QGenericArgument val5 = QGenericArgument(),
                           QGenericArgument val6 = QGenericArgument(),
                           QGenericArgument val7 = QGenericArgument(),
                           QGenericArgument val8 = QGenericArgument(),
                           QGenericArgument val9 = QGenericArgument()) const
    {
        return invoke(object, /+ Qt:: +/qt.core.namespace.ConnectionType.AutoConnection, QGenericReturnArgument(),
                      val0, val1, val2, val3, val4, val5, val6, val7, val8, val9);
    }
    bool invokeOnGadget(void* gadget,
                            QGenericReturnArgument returnValue,
                            QGenericArgument val0 = QGenericArgument(null),
                            QGenericArgument val1 = QGenericArgument(),
                            QGenericArgument val2 = QGenericArgument(),
                            QGenericArgument val3 = QGenericArgument(),
                            QGenericArgument val4 = QGenericArgument(),
                            QGenericArgument val5 = QGenericArgument(),
                            QGenericArgument val6 = QGenericArgument(),
                            QGenericArgument val7 = QGenericArgument(),
                            QGenericArgument val8 = QGenericArgument(),
                            QGenericArgument val9 = QGenericArgument()) const;
    pragma(inline, true) bool invokeOnGadget(void* gadget,
                                   QGenericArgument val0 = QGenericArgument(null),
                                   QGenericArgument val1 = QGenericArgument(),
                                   QGenericArgument val2 = QGenericArgument(),
                                   QGenericArgument val3 = QGenericArgument(),
                                   QGenericArgument val4 = QGenericArgument(),
                                   QGenericArgument val5 = QGenericArgument(),
                                   QGenericArgument val6 = QGenericArgument(),
                                   QGenericArgument val7 = QGenericArgument(),
                                   QGenericArgument val8 = QGenericArgument(),
                                   QGenericArgument val9 = QGenericArgument()) const
    {
        return invokeOnGadget(gadget, QGenericReturnArgument(),
                              val0, val1, val2, val3, val4, val5, val6, val7, val8, val9);
    }

    pragma(inline, true) bool isValid() const { return mobj !is null; }

    /+ template <typename PointerToMemberFunction> +/
    /+ static inline QMetaMethod fromSignal(PointerToMemberFunction signal)
    {
        typedef QtPrivate::FunctionPointer<PointerToMemberFunction> SignalType;
        Q_STATIC_ASSERT_X(QtPrivate::HasQ_OBJECT_Macro<typename SignalType::Object>::Value,
                          "No Q_OBJECT in the class with the signal");
        return fromSignalImpl(&SignalType::Object::staticMetaObject,
                              reinterpret_cast<void **>(&signal));
    } +/

private:
/+ #if QT_DEPRECATED_SINCE(5,0)
    // signature() has been renamed to methodSignature() in Qt 5.
    // Warning, that function returns a QByteArray; check the life time if
    // you convert to char*.
    char *signature(struct renamedInQt5_warning_checkTheLifeTime * = nullptr) = delete;
#endif +/
    static QMetaMethod fromSignalImpl(const(QMetaObject)* , void** );

    const(QMetaObject)* mobj = null;
    uint handle = 0;
    /+ friend class QMetaMethodPrivate; +/
    /+ friend struct QMetaObject; +/
    /+ friend struct QMetaObjectPrivate; +/
    /+ friend class QObject; +/
    /+ friend bool operator==(const QMetaMethod &m1, const QMetaMethod &m2); +/
    /+ friend bool operator!=(const QMetaMethod &m1, const QMetaMethod &m2); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QMetaMethod, Q_MOVABLE_TYPE); +/

/+pragma(inline, true) bool operator ==(ref const(QMetaMethod) m1, ref const(QMetaMethod) m2)
{ return m1.mobj == m2.mobj && m1.handle == m2.handle; }+/
/+pragma(inline, true) bool operator !=(ref const(QMetaMethod) m1, ref const(QMetaMethod) m2)
{ return !(m1 == m2); }+/

/// Binding for C++ class [QMetaEnum](https://doc.qt.io/qt-5/qmetaenum.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QMetaEnum
{
public:
    @disable this();
    /+pragma(inline, true) this()
    {
        this.mobj = null;
        this.handle = 0;
    }+/

    const(char)* name() const;
    const(char)* enumName() const;
    bool isFlag() const;
    bool isScoped() const;

    int keyCount() const;
    const(char)* key(int index) const;
    int value(int index) const;

    //const(char)* scope_() const;

    int keyToValue(const(char)* key, bool* ok = null) const;
    const(char)* valueToKey(int value) const;
    int keysToValue(const(char)*  keys, bool* ok = null) const;
    QByteArray valueToKeys(int value) const;

    pragma(inline, true) const(QMetaObject)* enclosingMetaObject() const { return mobj; }

    pragma(inline, true) bool isValid() const { return name() !is null; }

    /+ template<typename T> +/ /+ static QMetaEnum fromType() {
        Q_STATIC_ASSERT_X(QtPrivate::IsQEnumHelper<T>::Value,
                          "QMetaEnum::fromType only works with enums declared as "
                          "Q_ENUM, Q_ENUM_NS, Q_FLAG or Q_FLAG_NS");
        const QMetaObject *metaObject = qt_getEnumMetaObject(T());
        const char *name = qt_getEnumName(T());
        return metaObject->enumerator(metaObject->indexOfEnumerator(name));
    } +/

private:
    const(QMetaObject)* mobj = null;
    uint handle = 0;
    /+ friend struct QMetaObject; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QMetaEnum, Q_MOVABLE_TYPE); +/

/// Binding for C++ class [QMetaProperty](https://doc.qt.io/qt-5/qmetaproperty.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QMetaProperty
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }


    const(char)* name() const;
    const(char)* typeName() const;
    QVariant.Type type() const;
    int userType() const;
    int propertyIndex() const;
    int relativePropertyIndex() const;

    bool isReadable() const;
    bool isWritable() const;
    bool isResettable() const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    bool isDesignable(const(QObject) obj = null) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    bool isScriptable(const(QObject) obj = null) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    bool isStored(const(QObject) obj = null) const;
    }));
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_VERSION_5_15 +/ bool isEditable(const(QObject) obj = null) const;
    }));
/+ #endif +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    bool isUser(const(QObject) obj = null) const;
    }));
    bool isConstant() const;
    bool isFinal() const;
    bool isRequired() const;

    bool isFlagType() const;
    bool isEnumType() const;
    QMetaEnum enumerator() const;

    bool hasNotifySignal() const;
    QMetaMethod notifySignal() const;
    int notifySignalIndex() const;

    int revision() const;

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    QVariant read(const(QObject) obj) const;
    }));
    bool write(QObject obj, ref const(QVariant) value) const;
    bool reset(QObject obj) const;

    QVariant readOnGadget(const(void)* gadget) const;
    bool writeOnGadget(void* gadget, ref const(QVariant) value) const;
    bool resetOnGadget(void* gadget) const;

    bool hasStdCppSet() const;
    pragma(inline, true) bool isValid() const { return isReadable(); }
    pragma(inline, true) const(QMetaObject)* enclosingMetaObject() const { return mobj; }

private:
    int registerPropertyType() const;

    const(QMetaObject)* mobj;
    uint handle;
    int idx;
    QMetaEnum menum;
    /+ friend struct QMetaObject; +/
    /+ friend struct QMetaObjectPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QMetaClassInfo](https://doc.qt.io/qt-5/qmetaclassinfo.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QMetaClassInfo
{
public:
    @disable this();
    /+pragma(inline, true) this()
    {
        this.mobj = null;
        this.handle = 0;
    }+/
    const(char)* name() const;
    const(char)* value() const;
    pragma(inline, true) const(QMetaObject)* enclosingMetaObject() const { return mobj; }
private:
    const(QMetaObject)* mobj = null;
    uint handle = 0;
    /+ friend struct QMetaObject; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QMetaClassInfo, Q_MOVABLE_TYPE); +/

