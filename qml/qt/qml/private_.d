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
import qt.core.list;
//import qt.core.metacontainer;
import qt.core.metatype;
import qt.core.object;
import qt.core.objectdefs;
//import qt.core.pointer;
import qt.core.string;
import qt.core.url;
import qt.core.variant;
import qt.core.vector;
import qt.core.versionnumber;
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


extern(C++, class) struct QQmlPropertyValueInterceptor;
extern(C++, class) struct QQmlContextData;
extern(C++, class) struct QQmlFinalizerHook;

extern(C++, "QQmlPrivate") {
alias QQmlAttachedPropertiesFuncP(A) = ExternCPPFunc!(A* function(QObject ));
alias QQmlAttachedPropertiesFuncC(A) = ExternCPPFunc!(A function(QObject ));
}

extern(C++, "QV4") {
extern(C++, class) struct ExecutableCompilationUnit;
extern(C++, "CompiledData") {
struct Unit;
}
}
extern(C++, "QmlIR") {
struct Document;
//alias IRLoaderFunction = ExternCPPFunc!(void function(Document* , const(/+ QQmlPrivate:: +/CachedQmlUnit)* ));
}

alias QQmlAttachedPropertiesFunc = /+ QQmlPrivate:: +/QQmlAttachedPropertiesFuncC!(QObject);

/+ inline size_t qHash(QQmlAttachedPropertiesFunc func, size_t seed = 0)
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

    enum /+ class +/ ConstructionMode
    {
        None,
        Constructor,
        Factory,
        FactoryWrapper
    }

    
        struct HasSingletonFactory(T, WrapperT, )
    {
        extern(D) static immutable bool value = false;
    }

    /+ template<typename T, typename WrapperT>
    struct HasSingletonFactory<T, WrapperT, std::void_t<decltype(WrapperT::create(
                                                               static_cast<QQmlEngine *>(nullptr),
                                                               static_cast<QJSEngine *>(nullptr)))>>
    {
        static constexpr bool value = std::is_same_v<
            decltype(WrapperT::create(static_cast<QQmlEngine *>(nullptr),
                               static_cast<QJSEngine *>(nullptr))), T *>;
    }; +/

    ConstructionMode constructionMode(T, WrapperT)()
    {
        static if (!/+ std:: +/is_base_of!(ValueClass!(QObject), T).value)
            return ConstructionMode.None;
        static if (!/+ std:: +/is_same_v!(T, WrapperT) && HasSingletonFactory!(T, WrapperT).value)
            return ConstructionMode.FactoryWrapper;
        static if (/+ std:: +/is_default_constructible!(T).value)
            return ConstructionMode.Constructor;
        static if (HasSingletonFactory!(T).value)
            return ConstructionMode.Factory;

        return ConstructionMode.None;
    }

    void createInto(T)(void* memory, void* ) {
        import core.lifetime;
        emplace!(QQmlElement!(T))(memory);
    }

    QObject createSingletonInstance(T, WrapperT, ConstructionMode Mode)(QQmlEngine q, QJSEngine j)
    {
        import core.stdcpp.new_;

        /+ Q_UNUSED(q) +/
        /+ Q_UNUSED(j) +/
        static if (Mode == ConstructionMode.Constructor)
            return cpp_new!T;
        else static if (Mode == ConstructionMode.Factory)
            return T.create(q, j);
        else static if (Mode == ConstructionMode.FactoryWrapper)
            return WrapperT.create(q, j);
        else
            return null;
    }

    QObject createParent(T)(QObject p) {
        import core.stdcpp.new_;
        return cpp_new!T(p);
    }

    alias CreateIntoFunction = ExternCPPFunc!(void function(void* , void* ));
    alias CreateSingletonFunction = ExternCPPFunc!(QObject function(QQmlEngine , QJSEngine ));
    alias CreateParentFunction = ExternCPPFunc!(QObject function(QObject ));
    alias CreateValueTypeFunction = ExternCPPFunc!(QVariant function(ref const(QJSValue) ));

    /+ template<typename T, typename WrapperT = T, ConstructionMode Mode = constructionMode<T, WrapperT>()>
    struct Constructors;

    template<typename T, typename WrapperT>
    struct Constructors<T, WrapperT, ConstructionMode::Constructor>
    {
        static constexpr CreateIntoFunction createInto
                = QQmlPrivate::createInto<T>;
        static constexpr CreateSingletonFunction createSingletonInstance
                = QQmlPrivate::createSingletonInstance<T, WrapperT, ConstructionMode::Constructor>;
    };

    template<typename T, typename WrapperT>
    struct Constructors<T, WrapperT, ConstructionMode::None>
    {
        static constexpr CreateIntoFunction createInto = nullptr;
        static constexpr CreateSingletonFunction createSingletonInstance = nullptr;
    };

    template<typename T, typename WrapperT>
    struct Constructors<T, WrapperT, ConstructionMode::Factory>
    {
        static constexpr CreateIntoFunction createInto = nullptr;
        static constexpr CreateSingletonFunction createSingletonInstance
                = QQmlPrivate::createSingletonInstance<T, WrapperT, ConstructionMode::Factory>;
    };

    template<typename T, typename WrapperT>
    struct Constructors<T, WrapperT, ConstructionMode::FactoryWrapper>
    {
        static constexpr CreateIntoFunction createInto = nullptr;
        static constexpr CreateSingletonFunction createSingletonInstance
                = QQmlPrivate::createSingletonInstance<T, WrapperT, ConstructionMode::FactoryWrapper>;
    };

    template<typename T,
             bool IsObject = std::is_base_of<QObject, T>::value,
             bool IsGadget = QtPrivate::IsGadgetHelper<T>::IsRealGadget>
    struct ExtendedType;

    template<typename T>
    struct ExtendedType<T, false, false>
    {
        static constexpr const CreateParentFunction createParent = nullptr;
        static const QMetaObject *staticMetaObject() { return nullptr; }
    };

    // If it's a QObject, we actually want an error if the ctor or the metaobject is missing.
    template<typename T>
    struct ExtendedType<T, true, false>
    {
        static constexpr const CreateParentFunction createParent = QQmlPrivate::createParent<T>;
        static const QMetaObject *staticMetaObject() { return &T::staticMetaObject; }
    };

    // If it's a Q_GADGET, we don't want the ctor.
    template<typename T>
    struct ExtendedType<T, false, true>
    {
        static constexpr const CreateParentFunction createParent = nullptr;
        static const QMetaObject *staticMetaObject() { return &T::staticMetaObject; }
    }; +/

    struct ValueTypeFactory(F, Result)
    {
        /+ static constexpr const Result (*create)(const QJSValue &) = nullptr; +/
    }

    /+ template<typename F>
    struct ValueTypeFactory<F, std::void_t<decltype(F::create(QJSValue()))>>
    {
        static decltype(F::create(QJSValue())) create(const QJSValue &params)
        {
            return F::create(params);
        }
    };

    template<typename T, typename F,
             bool HasCtor = std::is_constructible_v<T, QJSValue>,
             bool HasFactory = std::is_constructible_v<
                 QVariant, decltype(ValueTypeFactory<F>::create(QJSValue()))>>
    struct ValueType;

    template<typename T, typename F>
    struct ValueType<T, F, false, false>
    {
        static constexpr const CreateValueTypeFunction create = nullptr;
    };

    template<typename T, typename F, bool HasCtor>
    struct ValueType<T, F, HasCtor, true>
    {
        static QVariant create(const QJSValue &params)
        {
            return F::create(params);
        }
    };

    template<typename T, typename F>
    struct ValueType<T, F, true, false>
    {
        static QVariant create(const QJSValue &params)
        {
            return QVariant::fromValue(T(params));
        }
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
    struct QmlAttached<T, std::void_t<typename OverridableAttachedType<T, typename T::QmlAttachedType>::Type>, false>
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
    struct QmlAttached<T, std::void_t<decltype(T::qmlAttachedProperties)>, true>
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
        int structVersion;

        QMetaType typeId;
        QMetaType listId;
        int objectSize;
        // The second parameter of create is for userdata
        ExternCPPFunc!(void function(void* , void* )) create;
        void* userdata;
        QString noCreationReason;

        ExternCPPFunc!(QVariant function(ref const(QJSValue) )) createValueType;

        const(char)* uri;
        QTypeRevision version_;
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

        QTypeRevision revision;
        int finalizerCast;
        // If this is extended ensure "version" is bumped!!!
    }

    struct RegisterTypeAndRevisions {
        int structVersion;

        QMetaType typeId;
        QMetaType listId;
        int objectSize;
        ExternCPPFunc!(void function(void* , void* )) create;
        void* userdata;

        ExternCPPFunc!(QVariant function(ref const(QJSValue) )) createValueType;

        const(char)* uri;
        QTypeRevision version_;

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
        QVector!(int)* qmlTypeIds;
        int finalizerCast;

        bool forceAnonymous;
    }

    struct RegisterInterface {
        int structVersion;

        QMetaType typeId;
        QMetaType listId;

        const(char)* iid;

        const(char)* uri;
        QTypeRevision version_;
    }

    struct RegisterAutoParent {
        int structVersion;

        AutoParentFunction function_;
    }

/+    struct RegisterSingletonType {
        int structVersion;

        const(char)* uri;
        QTypeRevision version_;
        const(char)* typeName;

        /+ std:: +/function_!(ExternCPPFunc!(QJSValue function(QQmlEngine , QJSEngine ))) scriptApi;
        /+ std:: +/function_!(ExternCPPFunc!(QObject function(QQmlEngine , QJSEngine ))) qObjectApi;

        const(QMetaObject)* instanceMetaObject;
        QMetaType typeId;

        ExternCPPFunc!(QObject function(QObject )) extensionObjectCreate;
        const(QMetaObject)* extensionMetaObject;

        QTypeRevision revision;
    }

    struct RegisterSingletonTypeAndRevisions {
        int structVersion;
        const(char)* uri;
        QTypeRevision version_;

        /+ std:: +/function_!(ExternCPPFunc!(QObject function(QQmlEngine , QJSEngine ))) qObjectApi;

        const(QMetaObject)* instanceMetaObject;
        const(QMetaObject)* classInfoMetaObject;

        QMetaType typeId;

        ExternCPPFunc!(QObject function(QObject )) extensionObjectCreate;
        const(QMetaObject)* extensionMetaObject;

        QVector!(int)* qmlTypeIds;
    }+/

    struct RegisterCompositeType {
        int structVersion;
        QUrl url;
        const(char)* uri;
        QTypeRevision version_;
        const(char)* typeName;
    }

    struct RegisterCompositeSingletonType {
        int structVersion;
        QUrl url;
        const(char)* uri;
        QTypeRevision version_;
        const(char)* typeName;
    }

/+    struct RegisterSequentialContainer {
        int structVersion;
        const(char)* uri;
        QTypeRevision version_;
        const(char)* typeName;
        QMetaType typeId;
        QMetaSequence metaSequence;
        QTypeRevision revision;
    }

    struct RegisterSequentialContainerAndRevisions {
        int structVersion;
        const(char)* uri;
        QTypeRevision version_;

        const(QMetaObject)* classInfoMetaObject;
        QMetaType typeId;
        QMetaSequence metaSequence;

        QVector!(int)* qmlTypeIds;
    }+/

    /+ struct /+ Q_QML_EXPORT +/ AOTCompiledContext {
        enum uint_: uint { InvalidStringId = (/+ std:: +/numeric_limits!(uint_).max)() }

        QQmlContextData* qmlContext;
        QObject qmlScopeObject;
        QJSEngine engine;
        /+ QV4:: +/ExecutableCompilationUnit* compilationUnit;

        QQmlEngine qmlEngine() const;

        QJSValue jsMetaType(int index) const;
        void setInstructionPointer(int offset) const;
        void setReturnValueUndefined() const;

        // Run QQmlPropertyCapture::captureProperty() without retrieving the value.
        bool captureLookup(uint_ index, QObject object) const;
        bool captureQmlContextPropertyLookup(uint_ index) const;
        QMetaType lookupResultMetaType(uint_ index) const;
        void storeNameSloppy(uint_ nameIndex, void* value, QMetaType type) const;
        QJSValue javaScriptGlobalProperty(uint_ nameIndex) const;

        // All of these lookup functions should be used as follows:
        //
        // while (!fooBarLookup(...)) {
        //     setInstructionPointer(...);
        //     initFooBarLookup(...);
        //     if (engine->hasException()) {
        //         ...
        //         break;
        //     }
        // }
        //
        // The bool-returning *Lookup functions exclusively run the happy path and return false if
        // that fails in any way. The failure may either be in the lookup structs not being
        // initialized or an exception being thrown.
        // The init*Lookup functions initialize the lookup structs and amend any exceptions
        // previously thrown with line numbers. They might also throw their own exceptions. If an
        // exception is present after the initialization there is no way to carry out the lookup and
        // the exception should be propagated. If not, the original lookup can be tried again.

        bool callQmlContextPropertyLookup(
                        uint_ index, void** args, const(QMetaType)* types, int argc) const;
        void initCallQmlContextPropertyLookup(uint_ index) const;

        bool loadContextIdLookup(uint_ index, void* target) const;
        void initLoadContextIdLookup(uint_ index) const;

        bool callObjectPropertyLookup(uint_ index, QObject object,
                                              void** args, const(QMetaType)* types, int argc) const;
        void initCallObjectPropertyLookup(uint_ index) const;

        bool callGlobalLookup(uint_ index, void** args, const(QMetaType)* types, int argc) const;
        void initCallGlobalLookup(uint_ index) const;

        bool loadGlobalLookup(uint_ index, void* target, QMetaType type) const;
        void initLoadGlobalLookup(uint_ index) const;

        bool loadScopeObjectPropertyLookup(uint_ index, void* target) const;
        void initLoadScopeObjectPropertyLookup(uint_ index, QMetaType type) const;

        bool loadSingletonLookup(uint_ index, void* target) const;
        void initLoadSingletonLookup(uint_ index, uint_ importNamespace) const;

        bool loadAttachedLookup(uint_ index, QObject object, void* target) const;
        void initLoadAttachedLookup(uint_ index, uint_ importNamespace, QObject object) const;

        bool loadTypeLookup(uint_ index, void* target) const;
        void initLoadTypeLookup(uint_ index, uint_ importNamespace) const;

        bool getObjectLookup(uint_ index, QObject object, void* target) const;
        void initGetObjectLookup(uint_ index, QObject object, QMetaType type) const;

        bool getValueLookup(uint_ index, void* value, void* target) const;
        void initGetValueLookup(uint_ index, const(QMetaObject)* metaObject, QMetaType type) const;

        bool getEnumLookup(uint_ index, int* target) const;
        void initGetEnumLookup(uint_ index, const(QMetaObject)* metaObject,
                                       const(char)* enumerator, const(char)* enumValue) const;

        bool setObjectLookup(uint_ index, QObject object, void* value) const;
        void initSetObjectLookup(uint_ index, QObject object, QMetaType type) const;

        bool setValueLookup(uint_ index, void* target, void* value) const;
        void initSetValueLookup(uint_ index, const(QMetaObject)* metaObject, QMetaType type) const;
    }

    struct AOTCompiledFunction {
        int index;
        QMetaType returnType;
        QList!(QMetaType) argumentTypes;
        ExternCPPFunc!(void function(const(AOTCompiledContext)* context, void* resultPtr, void** arguments)) functionPtr;
    }

    struct CachedQmlUnit {
        const(/+ QV4::CompiledData:: +/Unit)* qmlData;
        const(AOTCompiledFunction)* aotCompiledFunctions;
        void* unused2;
    }

    alias QmlUnitCacheLookupFunction = ExternCPPFunc!(const(CachedQmlUnit)* function(ref const(QUrl) url));
    struct RegisterQmlUnitCacheHook {
        int structVersion;
        QmlUnitCacheLookupFunction lookupCachedQmlUnit;
    }+/

    enum RegistrationType {
        TypeRegistration       = 0,
        InterfaceRegistration  = 1,
        AutoParentRegistration = 2,
        SingletonRegistration  = 3,
        CompositeRegistration  = 4,
        CompositeSingletonRegistration = 5,
        QmlUnitCacheHookRegistration = 6,
        TypeAndRevisionsRegistration = 7,
        SingletonAndRevisionsRegistration = 8,
        SequentialContainerRegistration = 9,
        SequentialContainerAndRevisionsRegistration = 10,
    }

    int /+ Q_QML_EXPORT +/ qmlregister(RegistrationType, void* );
    void /+ Q_QML_EXPORT +/ qmlunregister(RegistrationType, quintptr);

/+ #if QT_DEPRECATED_SINCE(6, 3) +/
/+    struct /+ Q_QML_EXPORT +/ SingletonFunctor
    {
        /+/+ QT_DEPRECATED +/ QObject operator ()(QQmlEngine , QJSEngine );+/
        QPointer!(ValueClass!(QObject)) m_object;
        bool alreadyCalled = false;
    }+/
/+ #endif +/

/+    struct /+ Q_QML_EXPORT +/ SingletonInstanceFunctor
    {
        /+QObject operator ()(QQmlEngine , QJSEngine );+/

        QPointer!(ValueClass!(QObject)) m_object;

        // Not a QPointer, so that you cannot assign it to a different
        // engine when the first one is deleted.
        // That would mess up the QML contexts.
        QQmlEngine m_engine = null;
    }+/

    int indexOfOwnClassInfo(const(QMetaObject)* metaObject, const(char)* key, int startOffset = -1)
    {
        import qt.core.bytearrayalgorithms;

        if (!metaObject || !key)
            return -1;

        const(int) offset = metaObject.classInfoOffset();
        const(int) start = (startOffset == -1)
                ? (metaObject.classInfoCount() + offset - 1)
                : startOffset;
        for (int i = start; i >= offset; --i)
            if (qstrcmp(key, metaObject.classInfo(i).name()) == 0) {
                return i;
        }
        return -1;
    }

    pragma(inline, true) const(char)* classInfo(const(QMetaObject)* metaObject, const(char)* key)
    {
        return metaObject.classInfo(indexOfOwnClassInfo(metaObject, key)).value();
    }

    /+pragma(inline, true) QTypeRevision revisionClassInfo(const(QMetaObject)* metaObject, const(char)* key,
                                           QTypeRevision defaultValue = QTypeRevision())
    {
        import qt.core.bytearray;

        const(int) index = indexOfOwnClassInfo(metaObject, key);
        return (index == -1) ? defaultValue
                             : QTypeRevision.fromEncodedVersion(
                                   QByteArray(metaObject.classInfo(index).value()).toInt());
    }

    pragma(inline, true) QList!(QTypeRevision) revisionClassInfos(const(QMetaObject)* metaObject, const(char)* key)
    {
        import qt.core.bytearray;

        QList!(QTypeRevision) revisions;
        for (int index = indexOfOwnClassInfo(metaObject, key); index != -1;
             index = indexOfOwnClassInfo(metaObject, key, index - 1)) {
            revisions.push_back(QTypeRevision.fromEncodedVersion(
                          QByteArray(metaObject.classInfo(index).value()).toInt()));
        }
        return revisions;
    }+/

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
        import qt.core.bytearrayalgorithms;
        version (QT_NO_WARNING_OUTPUT) {} else
            import qt.core.logging;

        const(char)* elementName = classInfo(metaObject, "QML.Element");
        if (qstrcmp(elementName, "auto") == 0) {
            const(char)* strippedClassName = metaObject.className();
            for (const(char)* c = strippedClassName; *c != '\0'; c++) {
                if (*c == ':')
                    strippedClassName = c + 1;
            }

            return strippedClassName;
        }
        if (qstrcmp(elementName, "anonymous") == 0)
            return null;

        if (!elementName) {
            static if (!versionIsSet!("QT_NO_WARNING_OUTPUT"))
            {
                mixin(qWarning)().nospace() << "Missing QML.Element class info \"" << elementName << "\""
                                     << " for " << metaObject.className();
            }
            else
            {
    while(false)QMessageLogger().noDebug().nospace()<<"Missing QML.Element class info \""<<elementName<<"\""<<" for "<<metaObject.className();
            }
        }

        return elementName;
    }+/

    
        struct QmlExtended(T, )
    {
        alias Type = void;
    }

    /+ template<class T>
    struct QmlExtended<T, std::void_t<typename T::QmlExtendedType>>
    {
        using Type = typename T::QmlExtendedType;
    }; +/

    
        struct QmlExtendedNamespace(T, )
    {
        static const(QMetaObject)* metaObject() { return null; }
    }

    /+ template<class T>
    struct QmlExtendedNamespace<T, std::void_t<decltype(T::qmlExtendedNamespace())>>
    {
        static constexpr const QMetaObject *metaObject() { return T::qmlExtendedNamespace(); }
    }; +/

    
        struct QmlResolved(T, )
    {
        alias Type = T;
    }

    /+ template<class T>
    struct QmlResolved<T, std::void_t<typename T::QmlForeignType>>
    {
        using Type = typename T::QmlForeignType;
    }; +/

    
        struct QmlSingleton(T, )
    {
        extern(D) static immutable bool Value = false;
    }

    /+ template<class T>
    struct QmlSingleton<T, std::void_t<typename T::QmlIsSingleton>>
    {
        static constexpr bool Value = bool(T::QmlIsSingleton::yes);
    }; +/

    
        struct QmlSequence(T, )
    {
        extern(D) static immutable bool Value = false;
    }

    /+ template<class T>
    struct QmlSequence<T, std::void_t<typename T::QmlIsSequence>>
    {
        Q_STATIC_ASSERT((std::is_same_v<typename T::QmlSequenceValueType,
                                        typename QmlResolved<T>::Type::value_type>));
        static constexpr bool Value = bool(T::QmlIsSequence::yes);
    }; +/

    
        struct QmlInterface(T, )
    {
        extern(D) static immutable bool Value = false;
    }

    /+ template<class T>
    struct QmlInterface<T, std::void_t<typename T::QmlIsInterface>>
    {
        static constexpr bool Value = bool(T::QmlIsInterface::yes);
    }; +/

    
        struct StaticMetaObject(T, )
    {
        static const(QMetaObject)* staticMetaObject() { return null; }
    }

    /+ template<class T>
    struct StaticMetaObject<T, std::void_t<decltype(T::staticMetaObject)>>
    {
        static const QMetaObject *staticMetaObject() { return &T::staticMetaObject; }
    }; +/

    struct QmlMetaType(T)
    {
        static QMetaType self()
        {
            static if (/+ std:: +/is_base_of_v!(ValueClass!(QObject), T))
                return QMetaType.fromType!(T*)();
            else
                return QMetaType.fromType!(T)();
        }

        static QMetaType list()
        {
            import qt.qml.list;

            static if (/+ std:: +/is_base_of_v!(ValueClass!(QObject), T))
                return QMetaType.fromType!(QQmlListProperty!(T))();
            else
                return QMetaType();
        }
    }

    void qmlRegisterSingletonAndRevisions(T, E, WrapperT)(const(char)* uri, int versionMajor,
                                              const(QMetaObject)* classInfoMetaObject,
                                              QVector!(int)* qmlTypeIds, const(QMetaObject)* extension)
    {
        RegisterSingletonTypeAndRevisions api = RegisterSingletonTypeAndRevisions(
            0,

            uri,
            QTypeRevision.fromMajorVersion(versionMajor),

            Constructors!(T, WrapperT).createSingletonInstance,

            StaticMetaObject!(T).staticMetaObject(),
            classInfoMetaObject,

            QmlMetaType!(T).self(),

            ExtendedType!(E).createParent,
            extension ? extension : ExtendedType!(E).staticMetaObject(),

            qmlTypeIds)
        ;

        qmlregister(RegistrationType.SingletonAndRevisionsRegistration, &api);
    }

    void qmlRegisterTypeAndRevisions(T, E)(const(char)* uri, int versionMajor,
                                         const(QMetaObject)* classInfoMetaObject,
                                         QVector!(int)* qmlTypeIds, const(QMetaObject)* extension,
                                         bool forceAnonymous = false)
    {
        import qt.qml.parserstatus;
        import qt.qml.propertyvaluesource;

        RegisterTypeAndRevisions type = RegisterTypeAndRevisions(
            2,
            QmlMetaType!(T).self(),
            QmlMetaType!(T).list(),
            cast(int) (T.sizeof),
            Constructors!(T).createInto,
            null,
            ValueType!(T, E).create,

            uri,
            QTypeRevision.fromMajorVersion(versionMajor),

            StaticMetaObject!(T).staticMetaObject(),
            classInfoMetaObject,

            attachedPropertiesFunc!(T)(),
            attachedPropertiesMetaObject!(T)(),

            StaticCastSelector!(T, ValueClass!(QQmlParserStatus)).cast_(),
            StaticCastSelector!(T, ValueClass!(QQmlPropertyValueSource)).cast_(),
            StaticCastSelector!(T, QQmlPropertyValueInterceptor).cast_(),

            ExtendedType!(E).createParent,
            extension ? extension : ExtendedType!(E).staticMetaObject(),

            &qmlCreateCustomParser!(T),
            qmlTypeIds,
            StaticCastSelector!(T, QQmlFinalizerHook).cast_(),

            forceAnonymous)
        ;

        // Initialize the extension so that we can find it by name or ID.
        qMetaTypeId!(E)();

        qmlregister(RegistrationType.TypeAndRevisionsRegistration, &type);
    }

    void qmlRegisterSequenceAndRevisions(T)(const(char)* uri, int versionMajor,
                                             const(QMetaObject)* classInfoMetaObject,
                                             QVector!(int)* qmlTypeIds)
    {
        RegisterSequentialContainerAndRevisions type = RegisterSequentialContainerAndRevisions(
            0,
            uri,
            QTypeRevision.fromMajorVersion(versionMajor),
            classInfoMetaObject,
            QMetaType.fromType!(T)(),
            QMetaSequence.fromContainer!(T)(),
            qmlTypeIds)
        ;

        qmlregister(RegistrationType.SequentialContainerAndRevisionsRegistration, &type);
    }

    /+ template<>
    void Q_QML_EXPORT qmlRegisterTypeAndRevisions<QQmlTypeNotAvailable, void>(
            const char *uri, int versionMajor, const QMetaObject *classInfoMetaObject,
            QVector<int> *qmlTypeIds, const QMetaObject *, bool); +/

   /+ /+ QtPrivate:: +/qt.core.metatype.QMetaTypeInterface metaTypeForNamespace(
                ref const(/+ QtPrivate:: +/qt.core.metatype.QMetaTypeInterface.MetaObjectFn) metaObjectFunction, const(char)* name)
    {
        return qt.core.metatype.QMetaTypeInterface(
            /*.revision=*/ 0,
            /*.alignment=*/ 0,
            /*.size=*/ 0,
            /*.flags=*/ 0,
            /*.typeId=*/ {},
            /*.metaObject=*/ metaObjectFunction,
            /*.name=*/ name,
            /*.defaultCtr=*/ null,
            /*.copyCtr=*/ null,
            /*.moveCtr=*/ null,
            /*.dtor=*/ null,
            /*.equals*/ null,
            /*.lessThan*/ null,
            /*.debugStream=*/ null,
            /*.dataStreamOut=*/ null,
            /*.dataStreamIn=*/ null,
            /*.legacyRegisterOp=*/ null)
        ;
    }+/

} // namespace QQmlPrivate

