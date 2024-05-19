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
module qt.core.objectdefs;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.metaobject;
import qt.core.namespace;
import qt.core.object;
import qt.core.objectdefs_impl;
import qt.helpers;
import std.traits;
import std.meta;
version (QT_NO_TRANSLATION) {} else
    import qt.core.string;

/+ #if defined(__OBJC__) && !defined(__cplusplus)
#  warning "File built in Objective-C mode (.m), but using Qt requires Objective-C++ (.mm)"
#endif





#ifndef QT_NO_META_MACROS
// macro for onaming members
#ifdef METHOD
#undef METHOD
#endif
#ifdef SLOT
#undef SLOT
#endif
#ifdef SIGNAL
#undef SIGNAL
#endif
#endif +/ // QT_NO_META_MACROS

/+ Q_CORE_EXPORT +/ const(char)* qFlagLocation(const(char)* method);

/+ #ifndef QT_NO_META_MACROS +/
/+ #ifndef QT_NO_DEBUG
# define QLOCATION "\0" __FILE__ ":" QT_STRINGIFY(__LINE__)
# ifndef QT_NO_KEYWORDS
#  define METHOD(a)   qFlagLocation("0"#a QLOCATION)
# endif
# define SLOT(a)     qFlagLocation("1"#a QLOCATION)
# define SIGNAL(a)   qFlagLocation("2"#a QLOCATION)
#else +/
/+ # ifndef QT_NO_KEYWORDS
#  define METHOD(a)   "0"#a
# endif +/
/+ # define SLOT(a)     "1"#a +/
extern(D) alias SLOT = function string(string a)
{
    return     mixin(interpolateMixin(q{"1"~ $(stringifyMacroParameter(a))}));
};
/+ # define SIGNAL(a)   "2"#a +/
extern(D) alias SIGNAL = function string(string a)
{
    return   mixin(interpolateMixin(q{"2"~ $(stringifyMacroParameter(a))}));
};
/+ #endif

#define QMETHOD_CODE  0                        // member type codes
#define QSLOT_CODE    1
#define QSIGNAL_CODE  2 +/
/+ #endif +/ // QT_NO_META_MACROS

/+ #define Q_ARG(type, data) QArgument<type >(#type, data) +/
extern(D) alias Q_ARG = function string(string type, string data)
{
    return mixin(interpolateMixin(q{imported!q{qt.core.objectdefs}.QArgument!($(type)) ($(stringifyMacroParameter(type)), $(data))}));
};
/+ #define Q_RETURN_ARG(type, data) QReturnArgument<type >(#type, data) +/
extern(D) alias Q_RETURN_ARG = function string(string type, string data)
{
    return mixin(interpolateMixin(q{imported!q{qt.core.objectdefs}.QReturnArgument!($(type)) ($(stringifyMacroParameter(type)), $(data))}));
};



/// Binding for C++ class [QGenericArgument](https://doc.qt.io/qt-5/qgenericargument.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QGenericArgument
{
public:
    pragma(inline, true) this(const(char)* aName/+ = null+/, const(void)* aData = null)
    {
        this._data = aData;
        this._name = aName;
    }
    pragma(inline, true) void* data() const { return const_cast!(void*)(_data); }
    pragma(inline, true) const(char)* name() const { return _name; }

private:
    const(void)* _data = null;
    const(char)* _name = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QGenericReturnArgument](https://doc.qt.io/qt-5/qgenericreturnargument.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QGenericReturnArgument
{
    public QGenericArgument base0;
    alias base0 this;
public:
    pragma(inline, true) this(const(char)* aName/+ = null+/, void* aData = null)
    {
        this.base0 = QGenericArgument(aName, aData);
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QArgument(T)
{
    public QGenericArgument base0;
    alias base0 this;
public:
    pragma(inline, true) this(const(char)* aName, ref const(T) aData)
    {
        this.base0 = QGenericArgument(aName, static_cast!(const(void)*)(&aData));
    }
}
/+ template <class T>
class QArgument<T &>: public QGenericArgument
{
public:
    inline QArgument(const char *aName, T &aData)
        : QGenericArgument(aName, static_cast<const void *>(&aData))
        {}
}; +/


extern(C++, class) struct QReturnArgument(T)
{
    public QGenericReturnArgument base0;
    alias base0 this;
public:
    pragma(inline, true) this(const(char)* aName, ref T aData)
    {
        this.base0 = QGenericReturnArgument(aName, static_cast!(void*)(&aData));
    }
}

struct /+ Q_CORE_EXPORT +/ QMetaObject
{
    /+
    extern(C++, class) struct Connection;
    +/
    /// Binding for C++ class [QMetaObject::Connection](https://doc.qt.io/qt-5/qmetaobject-connection.html).
    extern(C++, class) struct /+ Q_CORE_EXPORT +/ Connection {
    private:
        void* d_ptr; //QObjectPrivate::Connection*
        /+ explicit +/this(void* data)
        {
            this.d_ptr = data;
        }
        /+ friend class QObject; +/
        /+ friend class QObjectPrivate; +/
        /+ friend struct QMetaObject; +/
        bool isConnected_helper() const;
    public:
        ~this();

        this(ref const(Connection) other);
        /+ref Connection operator =(ref const(Connection) other);+/
    /+ #ifdef Q_QDOC
        operator bool() const;
    #else +/
        alias RestrictedBool = void*/+ Connection::* +/*;
        /+auto opCast(T : RestrictedBool)() const { return d_ptr && isConnected_helper() ? &Connection.d_ptr : null; }+/
    /+ #endif +/

        /+ Connection(Connection &&o) noexcept : d_ptr(o.d_ptr) { o.d_ptr = nullptr; } +/
        /+ Connection &operator=(Connection &&other) noexcept
        { qSwap(d_ptr, other.d_ptr); return *this; } +/
        mixin(CREATE_CONVENIENCE_WRAPPERS);
    }

    const(char)* className() const;
/+    pragma(inline, true) const(QMetaObject)* superClass() const
    { return cast(const(QMetaObject)*) (d.superdata); }+/

    bool inherits(const(QMetaObject)* metaObject) const/+ noexcept+/;
    mixin(mangleWindows("?cast@QMetaObject@@QEBAPEAVQObject@@PEAV2@@Z", q{
    mixin(mangleItanium("_ZNK11QMetaObject4castEP7QObject", q{
    QObject cast_(QObject obj) const;
    }));
    }));
    //const(QObject) cast_(const(QObject) obj) const;

    version (QT_NO_TRANSLATION) {} else
    {
        QString tr(const(char)* s, const(char)* c, int n = -1) const;
    }

    int methodOffset() const;
    int enumeratorOffset() const;
    int propertyOffset() const;
    int classInfoOffset() const;

    int constructorCount() const;
    int methodCount() const;
    int enumeratorCount() const;
    int propertyCount() const;
    int classInfoCount() const;

    int indexOfConstructor(const(char)* constructor) const;
    int indexOfMethod(const(char)* method) const;
    int indexOfSignal(const(char)* signal) const;
    int indexOfSlot(const(char)* slot) const;
    int indexOfEnumerator(const(char)* name) const;
    int indexOfProperty(const(char)* name) const;
    int indexOfClassInfo(const(char)* name) const;

    QMetaMethod constructor(int index) const;
    QMetaMethod method(int index) const;
    QMetaEnum enumerator(int index) const;
    QMetaProperty property(int index) const;
    QMetaClassInfo classInfo(int index) const;
    QMetaProperty userProperty() const;

    static bool checkConnectArgs(const(char)* signal, const(char)* method);
    static bool checkConnectArgs(ref const(QMetaMethod) signal,
                                     ref const(QMetaMethod) method);
    static QByteArray normalizedSignature(const(char)* method);
    static QByteArray normalizedType(const(char)* type);

    // internal index-based connect
    /+ static Connection connect(const QObject *sender, int signal_index,
                        const QObject *receiver, int method_index,
                        int type = 0, int *types = nullptr); +/
    // internal index-based disconnect
    /+ static bool disconnect(const QObject *sender, int signal_index,
                           const QObject *receiver, int method_index); +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static bool disconnectOne(const(QObject) sender, int signal_index,
                                  const(QObject) receiver, int method_index);
    }));
    // internal slot-name based connect
    static void connectSlotsByName(QObject o);

    // internal index-based signal activation
    static void activate(QObject sender, int signal_index, void** argv);
    static void activate(QObject sender, const(QMetaObject)* , int local_signal_index, void** argv);
    static void activate(QObject sender, int signal_offset, int local_signal_index, void** argv);

    static bool invokeMethod(QObject obj, const(char)* member,
                                 /+ Qt:: +/qt.core.namespace.ConnectionType,
                                 QGenericReturnArgument ret,
                                 QGenericArgument val0 = QGenericArgument(null),
                                 QGenericArgument val1 = QGenericArgument(),
                                 QGenericArgument val2 = QGenericArgument(),
                                 QGenericArgument val3 = QGenericArgument(),
                                 QGenericArgument val4 = QGenericArgument(),
                                 QGenericArgument val5 = QGenericArgument(),
                                 QGenericArgument val6 = QGenericArgument(),
                                 QGenericArgument val7 = QGenericArgument(),
                                 QGenericArgument val8 = QGenericArgument(),
                                 QGenericArgument val9 = QGenericArgument());

    pragma(inline, true) static bool invokeMethod(QObject obj, const(char)* member,
                                 QGenericReturnArgument ret,
                                 QGenericArgument val0 = QGenericArgument(null),
                                 QGenericArgument val1 = QGenericArgument(),
                                 QGenericArgument val2 = QGenericArgument(),
                                 QGenericArgument val3 = QGenericArgument(),
                                 QGenericArgument val4 = QGenericArgument(),
                                 QGenericArgument val5 = QGenericArgument(),
                                 QGenericArgument val6 = QGenericArgument(),
                                 QGenericArgument val7 = QGenericArgument(),
                                 QGenericArgument val8 = QGenericArgument(),
                                 QGenericArgument val9 = QGenericArgument())
    {
        return invokeMethod(obj, member, /+ Qt:: +/qt.core.namespace.ConnectionType.AutoConnection, ret, val0, val1, val2, val3,
                val4, val5, val6, val7, val8, val9);
    }

/+    pragma(inline, true) static bool invokeMethod(QObject obj, const(char)* member,
                                 /+ Qt:: +/qt.core.namespace.ConnectionType type,
                                 QGenericArgument val0 = QGenericArgument(null),
                                 QGenericArgument val1 = QGenericArgument(),
                                 QGenericArgument val2 = QGenericArgument(),
                                 QGenericArgument val3 = QGenericArgument(),
                                 QGenericArgument val4 = QGenericArgument(),
                                 QGenericArgument val5 = QGenericArgument(),
                                 QGenericArgument val6 = QGenericArgument(),
                                 QGenericArgument val7 = QGenericArgument(),
                                 QGenericArgument val8 = QGenericArgument(),
                                 QGenericArgument val9 = QGenericArgument())
    {
        return invokeMethod(obj, member, type, QGenericReturnArgument(), val0, val1, val2,
                                 val3, val4, val5, val6, val7, val8, val9);
    }+/

/+    pragma(inline, true) static bool invokeMethod(QObject obj, const(char)* member,
                                 QGenericArgument val0 = QGenericArgument(null),
                                 QGenericArgument val1 = QGenericArgument(),
                                 QGenericArgument val2 = QGenericArgument(),
                                 QGenericArgument val3 = QGenericArgument(),
                                 QGenericArgument val4 = QGenericArgument(),
                                 QGenericArgument val5 = QGenericArgument(),
                                 QGenericArgument val6 = QGenericArgument(),
                                 QGenericArgument val7 = QGenericArgument(),
                                 QGenericArgument val8 = QGenericArgument(),
                                 QGenericArgument val9 = QGenericArgument())
    {
        return invokeMethod(obj, member, /+ Qt:: +/qt.core.namespace.ConnectionType.AutoConnection, QGenericReturnArgument(), val0,
                val1, val2, val3, val4, val5, val6, val7, val8, val9);
    }+/

/+ #ifdef Q_CLANG_QDOC
    template<typename Functor, typename FunctorReturnType>
    static bool invokeMethod(QObject *context, Functor function, Qt::ConnectionType type = Qt::AutoConnection, FunctorReturnType *ret = nullptr);
    template<typename Functor, typename FunctorReturnType>
    static bool invokeMethod(QObject *context, Functor function, FunctorReturnType *ret);
#else +/

    // invokeMethod() for member function pointer
    /+ template <typename Func> +/
    /+ static typename std::enable_if<QtPrivate::FunctionPointer<Func>::IsPointerToMemberFunction
                                   && !std::is_convertible<Func, const char*>::value
                                   && QtPrivate::FunctionPointer<Func>::ArgumentCount == 0, bool>::type
    invokeMethod(typename QtPrivate::FunctionPointer<Func>::Object *object,
                 Func function,
                 Qt::ConnectionType type = Qt::AutoConnection,
                 typename QtPrivate::FunctionPointer<Func>::ReturnType *ret = nullptr)
    {
        return invokeMethodImpl(object, new QtPrivate::QSlotObjectWithNoArgs<Func>(function), type, ret);
    } +/

    /+ template <typename Func> +/
    /+ static typename std::enable_if<QtPrivate::FunctionPointer<Func>::IsPointerToMemberFunction
                                   && !std::is_convertible<Func, const char*>::value
                                   && QtPrivate::FunctionPointer<Func>::ArgumentCount == 0, bool>::type
    invokeMethod(typename QtPrivate::FunctionPointer<Func>::Object *object,
                 Func function,
                 typename QtPrivate::FunctionPointer<Func>::ReturnType *ret)
    {
        return invokeMethodImpl(object, new QtPrivate::QSlotObjectWithNoArgs<Func>(function), Qt::AutoConnection, ret);
    } +/

    // invokeMethod() for function pointer (not member)
    /+ template <typename Func> +/
    /+ static typename std::enable_if<!QtPrivate::FunctionPointer<Func>::IsPointerToMemberFunction
                                   && !std::is_convertible<Func, const char*>::value
                                   && QtPrivate::FunctionPointer<Func>::ArgumentCount == 0, bool>::type
    invokeMethod(QObject *context, Func function,
                 Qt::ConnectionType type = Qt::AutoConnection,
                 typename QtPrivate::FunctionPointer<Func>::ReturnType *ret = nullptr)
    {
        return invokeMethodImpl(context, new QtPrivate::QFunctorSlotObjectWithNoArgsImplicitReturn<Func>(function), type, ret);
    } +/

    /+ template <typename Func> +/
    /+ static typename std::enable_if<!QtPrivate::FunctionPointer<Func>::IsPointerToMemberFunction
                                   && !std::is_convertible<Func, const char*>::value
                                   && QtPrivate::FunctionPointer<Func>::ArgumentCount == 0, bool>::type
    invokeMethod(QObject *context, Func function,
                 typename QtPrivate::FunctionPointer<Func>::ReturnType *ret)
    {
        return invokeMethodImpl(context, new QtPrivate::QFunctorSlotObjectWithNoArgsImplicitReturn<Func>(function), Qt::AutoConnection, ret);
    } +/

    // invokeMethod() for Functor
    /+ template <typename Func> +/
    /+ static typename std::enable_if<!QtPrivate::FunctionPointer<Func>::IsPointerToMemberFunction
                                   && QtPrivate::FunctionPointer<Func>::ArgumentCount == -1
                                   && !std::is_convertible<Func, const char*>::value, bool>::type
    invokeMethod(QObject *context, Func function,
                 Qt::ConnectionType type = Qt::AutoConnection, decltype(function()) *ret = nullptr)
    {
        return invokeMethodImpl(context,
                                new QtPrivate::QFunctorSlotObjectWithNoArgs<Func, decltype(function())>(std::move(function)),
                                type,
                                ret);
    } +/

    /+ template <typename Func> +/
    /+ static typename std::enable_if<!QtPrivate::FunctionPointer<Func>::IsPointerToMemberFunction
                                   && QtPrivate::FunctionPointer<Func>::ArgumentCount == -1
                                   && !std::is_convertible<Func, const char*>::value, bool>::type
    invokeMethod(QObject *context, Func function, decltype(function()) *ret)
    {
        return invokeMethodImpl(context,
                                new QtPrivate::QFunctorSlotObjectWithNoArgs<Func, decltype(function())>(std::move(function)),
                                Qt::AutoConnection,
                                ret);
    } +/

/+ #endif +/

    QObject newInstance(QGenericArgument val0 = QGenericArgument(null),
                             QGenericArgument val1 = QGenericArgument(),
                             QGenericArgument val2 = QGenericArgument(),
                             QGenericArgument val3 = QGenericArgument(),
                             QGenericArgument val4 = QGenericArgument(),
                             QGenericArgument val5 = QGenericArgument(),
                             QGenericArgument val6 = QGenericArgument(),
                             QGenericArgument val7 = QGenericArgument(),
                             QGenericArgument val8 = QGenericArgument(),
                             QGenericArgument val9 = QGenericArgument()) const;

    enum Call {
        InvokeMetaMethod,
        ReadProperty,
        WriteProperty,
        ResetProperty,
        QueryPropertyDesignable,
        QueryPropertyScriptable,
        QueryPropertyStored,
        QueryPropertyEditable,
        QueryPropertyUser,
        CreateInstance,
        IndexOfMethod,
        RegisterPropertyMetaType,
        RegisterMethodArgumentMetaType
    }

    int static_metacall(Call, int, void** ) const;
    static int metacall(QObject , Call, int, void** );

    static const(QMetaObject*) staticMetaObject(alias MO)()
    {
        return &MO;
    }

    struct SuperData {
        const(QMetaObject)* direct;
        /+ SuperData() = default; +/
        this(typeof(null))
        {
            this.direct = null;
        }
        this(const(QMetaObject)* mo)
        {
            this.direct = mo;
        }

        /+const(QMetaObject)* operator ->() const { return operator const QMetaObject *(); }+/

        version (QT_NO_DATA_RELOCATION)
        {
            alias Getter = ExternCPPFunc!(const(QMetaObject)* function());
            Getter indirect = null;
            this(Getter g)
            {
                this.direct = null;
                this.indirect = g;
            }
            /+auto opCast(T : const(QMetaObject))() const
            { return indirect ? indirect() : cast(const(QMetaObject)) (direct); }+/
            /+ template <const QMetaObject &MO> +/ /+ static constexpr SuperData link()
            { return SuperData(QMetaObject::staticMetaObject<MO>); } +/
        }
        else
        {
            /+auto opCast(T : const(QMetaObject))() const
            { return cast(const(QMetaObject)) (direct); }+/
            static SuperData link(alias MO)()
            { return SuperData(QMetaObject.staticMetaObject!(MO)()); }
        }
    }

    struct generated_qobjectdefs_0 { // private data
        SuperData superdata;
        const(void)* stringdata;
        const(uint)* data;
        alias StaticMetacallFunction = ExternCPPFunc!(void function(QObject , QMetaObject.Call, int, void** ));
        StaticMetacallFunction static_metacall;
        const(SuperData)* relatedMetaObjects;
        void* extradata; //reserved for future use
    }generated_qobjectdefs_0 d;

private:
    static bool invokeMethodImpl(QObject object, /+ QtPrivate:: +/qt.core.objectdefs_impl.QSlotObjectBase* slot, /+ Qt:: +/qt.core.namespace.ConnectionType type, void* ret);
    /+ friend class QTimer; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, "QtPrivate") {
    /* Trait that tells is a the Object has a Q_OBJECT macro */
    struct HasQ_OBJECT_Macro(Object) {
        /+ template <typename T> +/
        static char test(T)(ExternCPPFunc!(int function(QMetaObject.Call, int, void** ))/+ T::* +/ );
        static int test(ExternCPPFunc!(int function(QMetaObject.Call, int, void** ))/+ Object::* +/ );
        enum { Value =  (test(&Object.qt_metacall)). sizeof == int.sizeof }
    }
}

