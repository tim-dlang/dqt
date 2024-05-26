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
module qt.qml.private_;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.object;
import qt.core.objectdefs;
//import qt.core.pointer;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.qml.engine;
import qt.qml.jsengine;
import qt.qml.jsvalue;

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists purely as an
// implementation detail.  This header file may change from version to
// version without notice, or even be removed.
//
// We mean it.
//

/+ #define QML_GETTYPENAMES \
    const char *className = T::staticMetaObject.className(); \
    const int nameLen = int(strlen(className)); \
    QVarLengthArray<char,48> pointerName(nameLen+2); \
    memcpy(pointerName.data(), className, size_t(nameLen)); \
    pointerName[nameLen] = '*'; \
    pointerName[nameLen+1] = '\0'; \
    const int listLen = int(strlen("QQmlListProperty<")); \
    QVarLengthArray<char,64> listName(listLen + nameLen + 2); \
    memcpy(listName.data(), "QQmlListProperty<", size_t(listLen)); \
    memcpy(listName.data()+listLen, className, size_t(nameLen)); \
    listName[listLen+nameLen] = '>'; \
    listName[listLen+nameLen+1] = '\0'; +/


extern(C++, class) struct QQmlPropertyValueInterceptor;

extern(C++, "QQmlPrivate") {
alias QQmlAttachedPropertiesFuncP(A) = ExternCPPFunc!(A* function(QObject ));
alias QQmlAttachedPropertiesFuncC(A) = ExternCPPFunc!(A function(QObject ));
}

extern(C++, "QV4") {
extern(C++, "CompiledData") {
struct Unit;
struct CompilationUnit;
}
}
extern(C++, "QmlIR") {
struct Document;
alias IRLoaderFunction = ExternCPPFunc!(void function(Document* , const(/+ QQmlPrivate:: +/CachedQmlUnit)* ));
}

alias QQmlAttachedPropertiesFunc = /+ QQmlPrivate:: +/QQmlAttachedPropertiesFuncC!(QObject);

/+ inline uint qHash(QQmlAttachedPropertiesFunc func, uint seed = 0)
{
    return qHash(quintptr(func), seed);
} +/

extern(C++, class) struct QQmlTypeInfo(TYPE)
{
public:
    enum {
        hasAttachedProperties = 0
    }
}


extern(C++, class) struct QQmlCustomParser;
extern(C++, class) struct QQmlTypeNotAvailable;

QQmlCustomParser* qmlCreateCustomParser(T)()
{
    return null;
}

extern(C++, "QQmlPrivate")
{
    void /+ Q_QML_EXPORT +/ qdeclarativeelement_destructor(QObject );
    final class QQmlElement(T) : T
    {
    public:
        ~this() {
            /+ QQmlPrivate:: +/qdeclarativeelement_destructor(this);
        }
        /+static void operator delete(void* ptr) {
            // We allocate memory from this class in QQmlType::create
            // along with some additional memory.
            // So we override the operator delete in order to avoid the
            // sized operator delete to be called with a different size than
            // the size that was allocated.
            UnresolvedMergeConflict!(q{.operator delete},q{.operator delete}) (ptr);
        }+/
        /+static void operator delete(void* , void* ) {
            // Deliberately empty placement delete operator.
            // Silences MSVC warning C4291: no matching operator delete found
        }+/
    }

    bool isConstructible(T)()
    {
        return /+ std:: +/is_default_constructible!(T).value && /+ std:: +/is_base_of!(ValueClass!(QObject), T).value;
    }

    void createInto(T)(void* memory) {
        import core.lifetime;
        emplace!(QQmlElement!(T))(memory);
    }

    QObject createSingletonInstance(T)(QQmlEngine , QJSEngine ) {
        import core.stdcpp.new_;
        return cpp_new!T;
    }

    QObject createParent(T)(QObject p) {
        import core.stdcpp.new_;
        return cpp_new!T(p);
    }

    alias CreateIntoFunction = ExternCPPFunc!(void function(void* ));
    alias CreateSingletonFunction = ExternCPPFunc!(QObject function(QQmlEngine , QJSEngine ));
    alias CreateParentFunction = ExternCPPFunc!(QObject function(QObject ));

    /+ template<typename T, bool Constructible = isConstructible<T>()>
    struct Constructors;

    template<typename T>
    struct Constructors<T, true>
    {
        static constexpr CreateIntoFunction createInto
                = QQmlPrivate::createInto<T>;
        static constexpr CreateSingletonFunction createSingletonInstance
                = QQmlPrivate::createSingletonInstance<T>;
    };

    template<typename T>
    struct Constructors<T, false>
    {
        static constexpr CreateIntoFunction createInto = nullptr;
        static constexpr CreateSingletonFunction createSingletonInstance = nullptr;
    };

    template<typename T, bool IsVoid = std::is_void<T>::value>
    struct ExtendedType;

    // void means "not an extended type"
    template<typename T>
    struct ExtendedType<T, true>
    {
        static constexpr const CreateParentFunction createParent = nullptr;
        static constexpr const QMetaObject *staticMetaObject = nullptr;
    };

    // If it's not void, we actually want an error if the ctor or the metaobject is missing.
    template<typename T>
    struct ExtendedType<T, false>
    {
        static constexpr const CreateParentFunction createParent = QQmlPrivate::createParent<T>;
        static constexpr const QMetaObject *staticMetaObject = &T::staticMetaObject;
    }; +/

    struct StaticCastSelectorClass(From, To, int N)
    {
        pragma(inline, true) static int cast_() { return -1; }
    }

    /+ template<class From, class To>
    struct StaticCastSelectorClass<From, To, sizeof(int)>
    {
        static inline int cast() { return int(reinterpret_cast<quintptr>(static_cast<To *>(reinterpret_cast<From *>(0x10000000)))) - 0x10000000; }
    }; +/

    struct StaticCastSelector(From, To)
    {
        alias yes_type = int;
        alias no_type = char;

        static yes_type checkType(To* );
        static no_type checkType(...);

        pragma(inline, true) static int cast_()
        {
            return StaticCastSelectorClass!(From, To, (checkType(reinterpret_cast!(From*)(0))). sizeof).cast_();
        }
    }

    alias QmlVoidT = void;

    // You can prevent subclasses from using the same attached type by specialzing this.
    // This is reserved for internal types, though.
    struct OverridableAttachedType(T, A)
    {
        alias Type = A;
    }

    /+ struct QmlAttached(T, , bool OldStyle=QQmlTypeInfo!(T).hasAttachedProperties)
    {
        alias Type = void;
        alias Func = QQmlAttachedPropertiesFuncC!(QObject);
        static const(QMetaObject)* staticMetaObject() { return null; }
        static Func attachedPropertiesFunc() { return null; }
    }+/

    // Defined inline via QML_ATTACHED
    /+ template<class T>
    struct QmlAttached<T, QmlVoidT<typename OverridableAttachedType<T, typename T::QmlAttachedType>::Type>, false>
    {
        // Normal attached properties
        template <typename Parent, typename Attached>
        struct Properties
        {
            using Func = QQmlAttachedPropertiesFunc<Attached>;
            static const QMetaObject *staticMetaObject() { return &Attached::staticMetaObject; }
            static Func attachedPropertiesFunc() { return Parent::qmlAttachedProperties; }
        };

        // Disabled via OverridableAttachedType
        template<typename Parent>
        struct Properties<Parent, void>
        {
            using Func = QQmlAttachedPropertiesFunc<QObject>;
            static const QMetaObject *staticMetaObject() { return nullptr; };
            static Func attachedPropertiesFunc() { return nullptr; };
        };

        using Type = typename OverridableAttachedType<T, typename T::QmlAttachedType>::Type;
        using Func = typename Properties<T, Type>::Func;

        static const QMetaObject *staticMetaObject()
        {
            return Properties<T, Type>::staticMetaObject();
        }

        static Func attachedPropertiesFunc()
        {
            return Properties<T, Type>::attachedPropertiesFunc();
        }
    };

    // Separately defined via QQmlTypeInfo
    template<class T>
    struct QmlAttached<T, QmlVoidT<decltype(T::qmlAttachedProperties)>, true>
    {
        using Type = typename std::remove_pointer<decltype(T::qmlAttachedProperties(nullptr))>::type;
        using Func = QQmlAttachedPropertiesFunc<Type>;

        static const QMetaObject *staticMetaObject() { return &Type::staticMetaObject; }
        static Func attachedPropertiesFunc() { return T::qmlAttachedProperties; }
    }; +/

    // This is necessary because both the type containing a default template parameter and the type
    // instantiating the template need to have access to the default template parameter type. In
    // this case that's T::QmlAttachedType. The QML_FOREIGN macro needs to befriend specific other
    // types. Therefore we need some kind of "accessor". Because of compiler bugs in gcc and clang,
    // we cannot befriend attachedPropertiesFunc() directly. Wrapping the actual access into another
    // struct "fixes" that. For convenience we still want the free standing functions in addition.
    struct QmlAttachedAccessor(T)
    {
        static QQmlAttachedPropertiesFuncC!(QObject) attachedPropertiesFunc()
        {
            return QQmlAttachedPropertiesFuncC!(QObject)(QmlAttached!(T).attachedPropertiesFunc());
        }

        static const(QMetaObject)* staticMetaObject()
        {
            return QmlAttached!(T).staticMetaObject();
        }
    }

    pragma(inline, true) QQmlAttachedPropertiesFuncC!(QObject) attachedPropertiesFunc(T)()
    {
        return QmlAttachedAccessor!(T).attachedPropertiesFunc();
    }

    pragma(inline, true) const(QMetaObject)* attachedPropertiesMetaObject(T)()
    {
        return QmlAttachedAccessor!(T).staticMetaObject();
    }

    enum AutoParentResult { Parented, IncompatibleObject, IncompatibleParent }
    alias AutoParentFunction = ExternCPPFunc!(AutoParentResult function(QObject object, QObject parent));

    struct RegisterType {
        int version_;

        int typeId;
        int listId;
        int objectSize;
        ExternCPPFunc!(void function(void* )) create;
        QString noCreationReason;

        const(char)* uri;
        int versionMajor;
        int versionMinor;
        const(char)* elementName;
        const(QMetaObject)* metaObject;

        QQmlAttachedPropertiesFuncC!(QObject) attachedPropertiesFunction;
        const(QMetaObject)* attachedPropertiesMetaObject;

        int parserStatusCast;
        int valueSourceCast;
        int valueInterceptorCast;

        ExternCPPFunc!(QObject function(QObject )) extensionObjectCreate;
        const(QMetaObject)* extensionMetaObject;

        QQmlCustomParser* customParser;

        int revision;
        // If this is extended ensure "version" is bumped!!!
    }

    struct RegisterTypeAndRevisions {
        int version_;

        int typeId;
        int listId;
        int objectSize;
        ExternCPPFunc!(void function(void* )) create;

        const(char)* uri;
        int versionMajor;

        const(QMetaObject)* metaObject;
        const(QMetaObject)* classInfoMetaObject;

        QQmlAttachedPropertiesFuncC!(QObject) attachedPropertiesFunction;
        const(QMetaObject)* attachedPropertiesMetaObject;

        int parserStatusCast;
        int valueSourceCast;
        int valueInterceptorCast;

        ExternCPPFunc!(QObject function(QObject )) extensionObjectCreate;
        const(QMetaObject)* extensionMetaObject;

        ExternCPPFunc!(QQmlCustomParser* function()) customParserFactory;
    }

    struct RegisterInterface {
        int version_;

        int typeId;
        int listId;

        const(char)* iid;

        const(char)* uri;
        int versionMajor;
    }

    struct RegisterAutoParent {
        int version_;

        AutoParentFunction function_;
    }

/+    struct RegisterSingletonType {
        int version_;

        const(char)* uri;
        int versionMajor;
        int versionMinor;
        const(char)* typeName;

        ExternCPPFunc!(QJSValue function(QQmlEngine , QJSEngine )) scriptApi;
        ExternCPPFunc!(QObject function(QQmlEngine , QJSEngine )) qobjectApi;
        const(QMetaObject)* instanceMetaObject; // new in version 1
        int typeId; // new in version 2
        int revision; // new in version 2
        /+ std:: +/function_!(ExternCPPFunc!(QObject function(QQmlEngine , QJSEngine ))) generalizedQobjectApi; // new in version 3
        // If this is extended ensure "version" is bumped!!!
    }

    struct RegisterSingletonTypeAndRevisions {
        int version_;
        const(char)* uri;
        int versionMajor;

        ExternCPPFunc!(QJSValue function(QQmlEngine , QJSEngine )) scriptApi;
        const(QMetaObject)* instanceMetaObject;
        const(QMetaObject)* classInfoMetaObject;

        int typeId;
        /+ std:: +/function_!(ExternCPPFunc!(QObject function(QQmlEngine , QJSEngine ))) generalizedQobjectApi; // new in version 3
    }+/

    struct RegisterCompositeType {
        QUrl url;
        const(char)* uri;
        int versionMajor;
        int versionMinor;
        const(char)* typeName;
    }

    struct RegisterCompositeSingletonType {
        QUrl url;
        const(char)* uri;
        int versionMajor;
        int versionMinor;
        const(char)* typeName;
    }

    struct CachedQmlUnit {
        const(/+ QV4::CompiledData:: +/Unit)* qmlData;
        void* unused1;
        void* unused2;
    }

    alias QmlUnitCacheLookupFunction = ExternCPPFunc!(const(CachedQmlUnit)* function(ref const(QUrl) url));
    struct RegisterQmlUnitCacheHook {
        int version_;
        QmlUnitCacheLookupFunction lookupCachedQmlUnit;
    }

    enum RegistrationType {
        TypeRegistration       = 0,
        InterfaceRegistration  = 1,
        AutoParentRegistration = 2,
        SingletonRegistration  = 3,
        CompositeRegistration  = 4,
        CompositeSingletonRegistration = 5,
        QmlUnitCacheHookRegistration = 6,
        TypeAndRevisionsRegistration = 7,
        SingletonAndRevisionsRegistration = 8
    }

    int /+ Q_QML_EXPORT +/ qmlregister(RegistrationType, void* );
    void /+ Q_QML_EXPORT +/ qmlunregister(RegistrationType, quintptr);
/+    struct /+ Q_QML_EXPORT +/ RegisterSingletonFunctor
    {
        /+QObject operator ()(QQmlEngine , QJSEngine );+/

        QPointer!(ValueClass!(QObject)) m_object;
        bool alreadyCalled = false;
    }+/

    int indexOfOwnClassInfo(const(QMetaObject)* metaObject, const(char)* key)
    {
        import qt.core.bytearray;

        if (!metaObject || !key)
            return -1;

        const(int) offset = metaObject.classInfoOffset();
        for (int i = metaObject.classInfoCount() + offset - 1; i >= offset; --i)
            if (qstrcmp(key, metaObject.classInfo(i).name()) == 0) {
                return i;
        }
        return -1;
    }

    pragma(inline, true) const(char)* classInfo(const(QMetaObject)* metaObject, const(char)* key)
    {
        return metaObject.classInfo(indexOfOwnClassInfo(metaObject, key)).value();
    }

    pragma(inline, true) int intClassInfo(const(QMetaObject)* metaObject, const(char)* key, int defaultValue = 0)
    {
        import qt.core.bytearray;

        const(int) index = indexOfOwnClassInfo(metaObject, key);
        return (index == -1) ? defaultValue
                             : QByteArray(metaObject.classInfo(index).value()).toInt();
    }

/+    pragma(inline, true) bool boolClassInfo(const(QMetaObject)* metaObject, const(char)* key,
                                  bool defaultValue = false)
    {
        import qt.core.bytearray;

        const(int) index = indexOfOwnClassInfo(metaObject, key);
        return (index == -1) ? defaultValue
                             : (QByteArray(metaObject.classInfo(index).value()) == staticString!(const(char), "true"));
    }

    pragma(inline, true) const(char)* classElementName(const(QMetaObject)* metaObject)
    {
        import qt.core.bytearray;
        version (QT_NO_WARNING_OUTPUT) {} else
            import qt.core.logging;

        const(char)* elementName = classInfo(metaObject, "QML.Element");
        if (qstrcmp(elementName, "auto") == 0)
            return metaObject.className();
        if (qstrcmp(elementName, "anonymous") == 0)
            return null;

        if (!elementName || elementName[0] < 'A' || elementName[0] > 'Z') {
            static if (!versionIsSet!("QT_NO_WARNING_OUTPUT"))
            {
                mixin(qWarning)() << "Missing or unusable QML.Element class info \"" << elementName << "\""
                           << "for" << metaObject.className();
            }
            else
            {
    while(false)QMessageLogger().noDebug()<<"Missing or unusable QML.Element class info \""<<elementName<<"\""<<"for"<<metaObject.className();
            }
        }

        return elementName;
    }+/

    
        struct QmlExtended(T, )
    {
        alias Type = void;
    }

    /+ template<class T>
    struct QmlExtended<T, QmlVoidT<typename T::QmlExtendedType>>
    {
        using Type = typename T::QmlExtendedType;
    }; +/

    
        struct QmlResolved(T, )
    {
        alias Type = T;
    }

    /+ template<class T>
    struct QmlResolved<T, QmlVoidT<typename T::QmlForeignType>>
    {
        using Type = typename T::QmlForeignType;
    }; +/

    
        struct QmlSingleton(T, )
    {
        extern(D) static immutable bool Value = false;
    }

    /+ template<class T>
    struct QmlSingleton<T, QmlVoidT<typename T::QmlIsSingleton>>
    {
        static constexpr bool Value = bool(T::QmlIsSingleton::yes);
    }; +/

    
        struct QmlInterface(T, )
    {
        extern(D) static immutable bool Value = false;
    }

    /+ template<class T>
    struct QmlInterface<T, QmlVoidT<typename T::QmlIsInterface>>
    {
        static constexpr bool Value = bool(T::QmlIsInterface::yes);
    }; +/

    void qmlRegisterSingletonAndRevisions(T)(const(char)* uri, int versionMajor,
                                              const(QMetaObject)* classInfoMetaObject)
    {
        import core.stdc.string;
        import qt.core.metatype;

        /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
        RegisterSingletonTypeAndRevisions api = RegisterSingletonTypeAndRevisions(
            0,

            uri,
            versionMajor,

            null,

            &T.staticMetaObject,
            classInfoMetaObject,

            qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
            Constructors!(T).createSingletonInstance)
        ;

        qmlregister(RegistrationType.SingletonAndRevisionsRegistration, &api);
    }

    void qmlRegisterTypeAndRevisions(T, E)(const(char)* uri, int versionMajor,
                                         const(QMetaObject)* classInfoMetaObject)
    {
        import core.stdc.string;
        import qt.core.metatype;
        import qt.qml.list;
        import qt.qml.parserstatus;
        import qt.qml.propertyvaluesource;

        /+ QML_GETTYPENAMES +/
const(char)* className=T.staticMetaObject.className();const(int) nameLen=cast(int) (strlen(className));auto pointerName = QVarLengthArray!(char,48)(nameLen+2);memcpy(pointerName.data(),className,size_t(nameLen));pointerName[nameLen]='*';pointerName[nameLen+1]='\0';const(int) listLen=cast(int) (strlen("QQmlListProperty<"));auto listName = QVarLengthArray!(char,64)(listLen+nameLen+2);memcpy(listName.data(),"QQmlListProperty<".ptr,size_t(listLen));memcpy(listName.data()+listLen,className,size_t(nameLen));listName[listLen+nameLen]='>';listName[listLen+nameLen+1]='\0';
        RegisterTypeAndRevisions type = RegisterTypeAndRevisions(
            0,
            qRegisterNormalizedMetaType!(T*)(pointerName.constData()),
            qRegisterNormalizedMetaType!(QQmlListProperty!(T)) (listName.constData()),
            cast(int) (T.sizeof),
            Constructors!(T).createInto,

            uri,
            versionMajor,

            &T.staticMetaObject,
            classInfoMetaObject,

            attachedPropertiesFunc!(T)(),
            attachedPropertiesMetaObject!(T)(),

            StaticCastSelector!(T, ValueClass!(QQmlParserStatus)).cast_(),
            StaticCastSelector!(T, ValueClass!(QQmlPropertyValueSource)).cast_(),
            StaticCastSelector!(T, QQmlPropertyValueInterceptor).cast_(),

            ExtendedType!(E).createParent,
            ExtendedType!(E).staticMetaObject,

            &qmlCreateCustomParser!(T))
        ;

        qmlregister(RegistrationType.TypeAndRevisionsRegistration, &type);
    }

    /+ template<>
    void Q_QML_EXPORT qmlRegisterTypeAndRevisions<QQmlTypeNotAvailable, void>(
            const char *uri, int versionMajor, const QMetaObject *classInfoMetaObject); +/

} // namespace QQmlPrivate

