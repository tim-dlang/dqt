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
module qt.core.object;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.list;
import qt.core.metaobject;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.objectdefs;
import qt.core.objectdefs_impl;
import qt.core.regexp;
import qt.core.regularexpression;
import qt.core.scopedpointer;
import qt.core.string;
import qt.core.thread;
import qt.helpers;
import std.traits;
import std.meta;
version(QT_NO_PROPERTIES){}else
{
    import qt.core.bytearray;
    import qt.core.variant;
}

/+ #ifndef QT_NO_QOBJECT +/

/+ #ifdef QT_INCLUDE_COMPAT
#endif
#if __has_include(<chrono>)
#endif



class QEvent;
class QTimerEvent;
class QChildEvent;
struct QMetaObject;
class QVariant; +/
extern(C++, class) struct QObjectPrivate;
/+ class QObject;
class QThread;
class QWidget; +/
extern(C++, class) struct QAccessibleWidget;
/+ #ifndef QT_NO_REGEXP
class QRegExp;
#endif
#if QT_CONFIG(regularexpression)
class QRegularExpression;
#endif
#if !QT_DEPRECATED_SINCE(5, 14) || QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
# define QT_NO_USERDATA
#endif
#ifndef QT_NO_USERDATA
class QObjectUserData;
#endif +/
struct QDynamicMetaObjectData;

alias QObjectList = QList!(QObject);

/+ Q_CORE_EXPORT +/ void qt_qFindChildren_helper(const(QObject) parent, ref const(QString) name,
                                           ref const(QMetaObject) mo, QList!(void*)* list, /+ Qt:: +/qt.core.namespace.FindChildOptions options);
/+ Q_CORE_EXPORT +/ void qt_qFindChildren_helper(const(QObject) parent, ref const(QRegExp) re,
                                           ref const(QMetaObject) mo, QList!(void*)* list, /+ Qt:: +/qt.core.namespace.FindChildOptions options);
/+ Q_CORE_EXPORT +/ void qt_qFindChildren_helper(const(QObject) parent, ref const(QRegularExpression) re,
                                           ref const(QMetaObject) mo, QList!(void*)* list, /+ Qt:: +/qt.core.namespace.FindChildOptions options);
/+ Q_CORE_EXPORT +/ QObject qt_qFindChild_helper(const(QObject) parent, ref const(QString) name, ref const(QMetaObject) mo, /+ Qt:: +/qt.core.namespace.FindChildOptions options);

class /+ Q_CORE_EXPORT +/ QObjectData {
private:
    /+ Q_DISABLE_COPY(QObjectData) +/
public:
    /+ QObjectData() = default; +/
    this()
    {
        children = QObjectList.create();
    }
    /+ virtual +/ /*abstract*/ ~this();
    QObject q_ptr;
    QObject parent;
    QObjectList children;

    /+ uint isWidget : 1; +/
    uint bitfieldData_isWidget;
    final bool isWidget() const
    {
        return (bitfieldData_isWidget >> 0) & 0x1;
    }
    final bool isWidget(bool value)
    {
        bitfieldData_isWidget = (bitfieldData_isWidget & ~0x1) | ((value & 0x1) << 0);
        return value;
    }
    /+ uint blockSig : 1; +/
    final bool blockSig() const
    {
        return (bitfieldData_isWidget >> 1) & 0x1;
    }
    final bool blockSig(bool value)
    {
        bitfieldData_isWidget = (bitfieldData_isWidget & ~0x2) | ((value & 0x1) << 1);
        return value;
    }
    /+ uint wasDeleted : 1; +/
    final uint wasDeleted() const
    {
        return (bitfieldData_isWidget >> 2) & 0x1;
    }
    final uint wasDeleted(uint value)
    {
        bitfieldData_isWidget = (bitfieldData_isWidget & ~0x4) | ((value & 0x1) << 2);
        return value;
    }
    /+ uint isDeletingChildren : 1; +/
    final uint isDeletingChildren() const
    {
        return (bitfieldData_isWidget >> 3) & 0x1;
    }
    final uint isDeletingChildren(uint value)
    {
        bitfieldData_isWidget = (bitfieldData_isWidget & ~0x8) | ((value & 0x1) << 3);
        return value;
    }
    /+ uint sendChildEvents : 1; +/
    final uint sendChildEvents() const
    {
        return (bitfieldData_isWidget >> 4) & 0x1;
    }
    final uint sendChildEvents(uint value)
    {
        bitfieldData_isWidget = (bitfieldData_isWidget & ~0x10) | ((value & 0x1) << 4);
        return value;
    }
    /+ uint receiveChildEvents : 1; +/
    final uint receiveChildEvents() const
    {
        return (bitfieldData_isWidget >> 5) & 0x1;
    }
    final uint receiveChildEvents(uint value)
    {
        bitfieldData_isWidget = (bitfieldData_isWidget & ~0x20) | ((value & 0x1) << 5);
        return value;
    }
    /+ uint isWindow : 1; +/ //for QWindow
    final bool isWindow() const
    {
        return (bitfieldData_isWidget >> 6) & 0x1;
    }
    final bool isWindow(bool value)
    {
        bitfieldData_isWidget = (bitfieldData_isWidget & ~0x40) | ((value & 0x1) << 6);
        return value;
    }
    /+ uint deleteLaterCalled : 1; +/
    final uint deleteLaterCalled() const
    {
        return (bitfieldData_isWidget >> 7) & 0x1;
    }
    final uint deleteLaterCalled(uint value)
    {
        bitfieldData_isWidget = (bitfieldData_isWidget & ~0x80) | ((value & 0x1) << 7);
        return value;
    }
    /+ uint unused : 24; +/
    final uint unused() const
    {
        return (bitfieldData_isWidget >> 8) & 0xffffff;
    }
    final uint unused(uint value)
    {
        bitfieldData_isWidget = (bitfieldData_isWidget & ~0xffffff00) | ((value & 0xffffff) << 8);
        return value;
    }
    int postedEvents;
    QDynamicMetaObjectData* metaObject;
    final QMetaObject* dynamicMetaObject() const;

    version(QT_DEBUG)
    {
        enum { CheckForParentChildLoopsWarnDepth = 4096 }
    }
}

extern(D) struct DQtMember(T, Members_...) if(is(T: QObject))
{
    alias Type = T;
    alias Members = Members_;
    T obj;
}

template parametersSame(Params...)
{
    template parametersSame(alias O)
    {
        enum parametersSame = is(Parameters!O == Params);
    }
}

/// Binding for C++ class [QObject](https://doc.qt.io/qt-5/qobject.html).
@(QMetaType.Type.QObjectStar) class /+ Q_CORE_EXPORT +/ QObject
{
    mixin((){import std.array; return Q_OBJECT.replace("override", "");}());

    /+ Q_PROPERTY(QString objectName READ objectName WRITE setObjectName NOTIFY objectNameChanged)
    Q_DECLARE_PRIVATE(QObject) +/

public:
    /+ explicit +/@QInvokable this(QObject parent=null);
    /+ virtual +/~this();

protected:
    struct QSignal{}
    struct QSlot{}
    struct QInvokable{}
    struct QScriptable{}
    enum Q_OBJECT = qt.core.objectdefs.Q_OBJECT;
    enum Q_OBJECT_D = qt.core.objectdefs.Q_OBJECT_D;
    enum Q_SIGNAL_IMPL_D = qt.core.objectdefs.Q_SIGNAL_IMPL_D;

public:

    /+ virtual +/ bool event(QEvent event);
    /+ virtual +/ bool eventFilter(QObject watched, QEvent event);

/+ #if defined(QT_NO_TRANSLATION) || defined(Q_CLANG_QDOC) +/
    version(QT_NO_TRANSLATION)
    {
        static QString tr(const(char)* sourceText, const(char)*  /+ = nullptr +/, int /+ = -1 +/)
            { return QString.fromUtf8(sourceText); }
    }
/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED static QString trUtf8(const char *sourceText, const char * = nullptr, int = -1)
        { return QString::fromUtf8(sourceText); }
#endif
#endif +/ //QT_NO_TRANSLATION

    final QString objectName() const;
    final void setObjectName(ref const(QString) name);
    extern(D) final void setObjectName(const(char)[] name)
    {
        QString s = QString.fromUtf8(name.ptr, cast(int)name.length);
        setObjectName(s);
    }

    pragma(inline, true) final bool isWidgetType() const { return d_ptr.isWidget; }
    pragma(inline, true) final bool isWindowType() const { return d_ptr.isWindow; }

    pragma(inline, true) final bool signalsBlocked() const/+ noexcept+/ { return d_ptr.blockSig; }
    final bool blockSignals(bool b)/+ noexcept+/;

    final QThread thread() const;
    final void moveToThread(QThread thread);

    final int startTimer(int interval, /+ Qt:: +/qt.core.namespace.TimerType timerType = /+ Qt:: +/qt.core.namespace.TimerType.CoarseTimer);
/+ #if __has_include(<chrono>) +/
    /+ Q_ALWAYS_INLINE +/
/+        pragma(inline, true) final int startTimer(/+ std::chrono:: +/milliseconds time, /+ Qt:: +/qt.core.namespace.TimerType timerType = /+ Qt:: +/qt.core.namespace.TimerType.CoarseTimer)
    {
        return startTimer(int(time.count()), timerType);
    }+/
/+ #endif +/
    final void killTimer(int id);

    /+ template<typename T> +/
    /+ inline T findChild(const QString &aName = QString(), Qt::FindChildOptions options = Qt::FindChildrenRecursively) const
    {
        typedef typename std::remove_cv<typename std::remove_pointer<T>::type>::type ObjType;
        return static_cast<T>(qt_qFindChild_helper(this, aName, ObjType::staticMetaObject, options));
    } +/

    /+ template<typename T> +/
    /+ inline QList<T> findChildren(const QString &aName = QString(), Qt::FindChildOptions options = Qt::FindChildrenRecursively) const
    {
        typedef typename std::remove_cv<typename std::remove_pointer<T>::type>::type ObjType;
        QList<T> list;
        qt_qFindChildren_helper(this, aName, ObjType::staticMetaObject,
                                reinterpret_cast<QList<void *> *>(&list), options);
        return list;
    } +/

/+ #ifndef QT_NO_REGEXP
#if QT_DEPRECATED_SINCE(5, 13) +/
    version(QT_NO_REGEXP){}else
    {
        /+ template<typename T> +/
        /+ QT_DEPRECATED_X("Use findChildren(const QRegularExpression &, ...) instead.")
        inline QList<T> findChildren(const QRegExp &re, Qt::FindChildOptions options = Qt::FindChildrenRecursively) const
        {
            typedef typename std::remove_cv<typename std::remove_pointer<T>::type>::type ObjType;
            QList<T> list;
            qt_qFindChildren_helper(this, re, ObjType::staticMetaObject,
                                    reinterpret_cast<QList<void *> *>(&list), options);
            return list;
        } +/
    }
/+ #endif
#endif

#if QT_CONFIG(regularexpression) +/
    /+ template<typename T> +/
    /+ inline QList<T> findChildren(const QRegularExpression &re, Qt::FindChildOptions options = Qt::FindChildrenRecursively) const
    {
        typedef typename std::remove_cv<typename std::remove_pointer<T>::type>::type ObjType;
        QList<T> list;
        qt_qFindChildren_helper(this, re, ObjType::staticMetaObject,
                                reinterpret_cast<QList<void *> *>(&list), options);
        return list;
    } +/
/+ #endif +/ // QT_CONFIG(regularexpression)

    pragma(inline, true) final ref const(QObjectList) children() const { return d_ptr.children; }

    final void setParent(QObject parent);
    final void installEventFilter(QObject filterObj);
    final void removeEventFilter(QObject obj);

    static QMetaObject.Connection connect(const QObject sender, const char *signal,
                        const QObject receiver, const char *member, ConnectionType = ConnectionType.AutoConnection);

    /+ static QMetaObject::Connection connect(const QObject *sender, const QMetaMethod &signal,
                        const QObject *receiver, const QMetaMethod &method,
                        Qt::ConnectionType type = Qt::AutoConnection); +/

    /+ inline QMetaObject::Connection connect(const QObject *sender, const char *signal,
                        const char *member, Qt::ConnectionType type = Qt::AutoConnection) const; +/

/+ #ifdef Q_CLANG_QDOC
    template<typename PointerToMemberFunction>
    static QMetaObject::Connection connect(const QObject *sender, PointerToMemberFunction signal, const QObject *receiver, PointerToMemberFunction method, Qt::ConnectionType type = Qt::AutoConnection);
    template<typename PointerToMemberFunction, typename Functor>
    static QMetaObject::Connection connect(const QObject *sender, PointerToMemberFunction signal, Functor functor);
    template<typename PointerToMemberFunction, typename Functor>
    static QMetaObject::Connection connect(const QObject *sender, PointerToMemberFunction signal, const QObject *context, Functor functor, Qt::ConnectionType type = Qt::AutoConnection);
#else +/
    //Connect a signal to a pointer to qobject member function
    /+ template <typename Func1, typename Func2> +/
    /+ static inline QMetaObject::Connection connect(const typename QtPrivate::FunctionPointer<Func1>::Object *sender, Func1 signal,
                                     const typename QtPrivate::FunctionPointer<Func2>::Object *receiver, Func2 slot,
                                     Qt::ConnectionType type = Qt::AutoConnection)
    {
        typedef QtPrivate::FunctionPointer<Func1> SignalType;
        typedef QtPrivate::FunctionPointer<Func2> SlotType;

        Q_STATIC_ASSERT_X(QtPrivate::HasQ_OBJECT_Macro<typename SignalType::Object>::Value,
                          "No Q_OBJECT in the class with the signal");

        //compilation error if the arguments does not match.
        Q_STATIC_ASSERT_X(int(SignalType::ArgumentCount) >= int(SlotType::ArgumentCount),
                          "The slot requires more arguments than the signal provides.");
        Q_STATIC_ASSERT_X((QtPrivate::CheckCompatibleArguments<typename SignalType::Arguments, typename SlotType::Arguments>::value),
                          "Signal and slot arguments are not compatible.");
        Q_STATIC_ASSERT_X((QtPrivate::AreArgumentsCompatible<typename SlotType::ReturnType, typename SignalType::ReturnType>::value),
                          "Return type of the slot is not compatible with the return type of the signal.");

        const int *types = nullptr;
        if (type == Qt::QueuedConnection || type == Qt::BlockingQueuedConnection)
            types = QtPrivate::ConnectionTypes<typename SignalType::Arguments>::types();

        return connectImpl(sender, reinterpret_cast<void **>(&signal),
                           receiver, reinterpret_cast<void **>(&slot),
                           new QtPrivate::QSlotObject<Func2, typename QtPrivate::List_Left<typename SignalType::Arguments, SlotType::ArgumentCount>::Value,
                                           typename SignalType::ReturnType>(slot),
                            type, types, &SignalType::Object::staticMetaObject);
    } +/

    //connect to a function pointer  (not a member)
    /+ template <typename Func1, typename Func2> +/
    /+ static inline typename std::enable_if<int(QtPrivate::FunctionPointer<Func2>::ArgumentCount) >= 0, QMetaObject::Connection>::type
            connect(const typename QtPrivate::FunctionPointer<Func1>::Object *sender, Func1 signal, Func2 slot)
    {
        return connect(sender, signal, sender, slot, Qt::DirectConnection);
    } +/

    //connect to a function pointer  (not a member)
    /+ template <typename Func1, typename Func2> +/
    /+ static inline typename std::enable_if<int(QtPrivate::FunctionPointer<Func2>::ArgumentCount) >= 0 &&
                                          !QtPrivate::FunctionPointer<Func2>::IsPointerToMemberFunction, QMetaObject::Connection>::type
            connect(const typename QtPrivate::FunctionPointer<Func1>::Object *sender, Func1 signal, const QObject *context, Func2 slot,
                    Qt::ConnectionType type = Qt::AutoConnection)
    {
        typedef QtPrivate::FunctionPointer<Func1> SignalType;
        typedef QtPrivate::FunctionPointer<Func2> SlotType;

        Q_STATIC_ASSERT_X(QtPrivate::HasQ_OBJECT_Macro<typename SignalType::Object>::Value,
                          "No Q_OBJECT in the class with the signal");

        //compilation error if the arguments does not match.
        Q_STATIC_ASSERT_X(int(SignalType::ArgumentCount) >= int(SlotType::ArgumentCount),
                          "The slot requires more arguments than the signal provides.");
        Q_STATIC_ASSERT_X((QtPrivate::CheckCompatibleArguments<typename SignalType::Arguments, typename SlotType::Arguments>::value),
                          "Signal and slot arguments are not compatible.");
        Q_STATIC_ASSERT_X((QtPrivate::AreArgumentsCompatible<typename SlotType::ReturnType, typename SignalType::ReturnType>::value),
                          "Return type of the slot is not compatible with the return type of the signal.");

        const int *types = nullptr;
        if (type == Qt::QueuedConnection || type == Qt::BlockingQueuedConnection)
            types = QtPrivate::ConnectionTypes<typename SignalType::Arguments>::types();

        return connectImpl(sender, reinterpret_cast<void **>(&signal), context, nullptr,
                           new QtPrivate::QStaticSlotObject<Func2,
                                                 typename QtPrivate::List_Left<typename SignalType::Arguments, SlotType::ArgumentCount>::Value,
                                                 typename SignalType::ReturnType>(slot),
                           type, types, &SignalType::Object::staticMetaObject);
    } +/

    //connect to a functor
    /+ template <typename Func1, typename Func2> +/
    /+ static inline typename std::enable_if<QtPrivate::FunctionPointer<Func2>::ArgumentCount == -1, QMetaObject::Connection>::type
            connect(const typename QtPrivate::FunctionPointer<Func1>::Object *sender, Func1 signal, Func2 slot)
    {
        return connect(sender, signal, sender, std::move(slot), Qt::DirectConnection);
    } +/

    //connect to a functor, with a "context" object defining in which event loop is going to be executed
    /+ template <typename Func1, typename Func2> +/
    /+ static inline typename std::enable_if<QtPrivate::FunctionPointer<Func2>::ArgumentCount == -1, QMetaObject::Connection>::type
            connect(const typename QtPrivate::FunctionPointer<Func1>::Object *sender, Func1 signal, const QObject *context, Func2 slot,
                    Qt::ConnectionType type = Qt::AutoConnection)
    {
        typedef QtPrivate::FunctionPointer<Func1> SignalType;
        const int FunctorArgumentCount = QtPrivate::ComputeFunctorArgumentCount<Func2 , typename SignalType::Arguments>::Value;

        Q_STATIC_ASSERT_X((FunctorArgumentCount >= 0),
                          "Signal and slot arguments are not compatible.");
        const int SlotArgumentCount = (FunctorArgumentCount >= 0) ? FunctorArgumentCount : 0;
        typedef typename QtPrivate::FunctorReturnType<Func2, typename QtPrivate::List_Left<typename SignalType::Arguments, SlotArgumentCount>::Value>::Value SlotReturnType;

        Q_STATIC_ASSERT_X((QtPrivate::AreArgumentsCompatible<SlotReturnType, typename SignalType::ReturnType>::value),
                          "Return type of the slot is not compatible with the return type of the signal.");

        Q_STATIC_ASSERT_X(QtPrivate::HasQ_OBJECT_Macro<typename SignalType::Object>::Value,
                          "No Q_OBJECT in the class with the signal");

        const int *types = nullptr;
        if (type == Qt::QueuedConnection || type == Qt::BlockingQueuedConnection)
            types = QtPrivate::ConnectionTypes<typename SignalType::Arguments>::types();

        return connectImpl(sender, reinterpret_cast<void **>(&signal), context, nullptr,
                           new QtPrivate::QFunctorSlotObject<Func2, SlotArgumentCount,
                                typename QtPrivate::List_Left<typename SignalType::Arguments, SlotArgumentCount>::Value,
                                typename SignalType::ReturnType>(std::move(slot)),
                           type, types, &SignalType::Object::staticMetaObject);
    } +/
/+ #endif +/ //Q_CLANG_QDOC

    /+ static bool disconnect(const QObject *sender, const char *signal,
                           const QObject *receiver, const char *member); +/
    /+ static bool disconnect(const QObject *sender, const QMetaMethod &signal,
                           const QObject *receiver, const QMetaMethod &member); +/
    /+ inline bool disconnect(const char *signal = nullptr,
                           const QObject *receiver = nullptr, const char *member = nullptr) const
        { return disconnect(this, signal, receiver, member); } +/
    /+ inline bool disconnect(const QObject *receiver, const char *member = nullptr) const
        { return disconnect(this, nullptr, receiver, member); } +/
    /+ static bool disconnect(const QMetaObject::Connection &); +/

/+ #ifdef Q_CLANG_QDOC
    template<typename PointerToMemberFunction>
    static bool disconnect(const QObject *sender, PointerToMemberFunction signal, const QObject *receiver, PointerToMemberFunction method);
#else +/
    /+ template <typename Func1, typename Func2> +/
    /+ static inline bool disconnect(const typename QtPrivate::FunctionPointer<Func1>::Object *sender, Func1 signal,
                                  const typename QtPrivate::FunctionPointer<Func2>::Object *receiver, Func2 slot)
    {
        typedef QtPrivate::FunctionPointer<Func1> SignalType;
        typedef QtPrivate::FunctionPointer<Func2> SlotType;

        Q_STATIC_ASSERT_X(QtPrivate::HasQ_OBJECT_Macro<typename SignalType::Object>::Value,
                          "No Q_OBJECT in the class with the signal");

        //compilation error if the arguments does not match.
        Q_STATIC_ASSERT_X((QtPrivate::CheckCompatibleArguments<typename SignalType::Arguments, typename SlotType::Arguments>::value),
                          "Signal and slot arguments are not compatible.");

        return disconnectImpl(sender, reinterpret_cast<void **>(&signal), receiver, reinterpret_cast<void **>(&slot),
                              &SignalType::Object::staticMetaObject);
    } +/
    /+ template <typename Func1> +/
    /+ static inline bool disconnect(const typename QtPrivate::FunctionPointer<Func1>::Object *sender, Func1 signal,
                                  const QObject *receiver, void **zero)
    {
        // This is the overload for when one wish to disconnect a signal from any slot. (slot=nullptr)
        // Since the function template parameter cannot be deduced from '0', we use a
        // dummy void ** parameter that must be equal to 0
        Q_ASSERT(!zero);
        typedef QtPrivate::FunctionPointer<Func1> SignalType;
        return disconnectImpl(sender, reinterpret_cast<void **>(&signal), receiver, zero,
                              &SignalType::Object::staticMetaObject);
    } +/
/+ #endif +/ //Q_CLANG_QDOC

    template signal(string name, Params...)
    {
        extern(D) auto signal(this T)()
        {
            import std.meta;
            static if(Params.length)
                return DQtMember!(T, Filter!(parametersSame!Params, __traits(getOverloads, T, name)))(cast(T)this);
            else
                return DQtMember!(T, __traits(getOverloads, T, name))(cast(T)this);
        }
    }
    template slot(string name, Params...)
    {
        extern(D) auto slot(this T)()
        {
            import std.meta;
            static if(Params.length)
                return DQtMember!(T, Filter!(parametersSame!Params, __traits(getOverloads, T, name)))(cast(T)this);
            else
                return DQtMember!(T, __traits(getOverloads, T, name))(cast(T)this);
        }
    }

        /+ template <typename Func1, typename Func2>
     +//+ static inline typename std::enable_if<int(QtPrivate::FunctionPointer<Func2>::ArgumentCount) >= 0 &&
                                          !QtPrivate::FunctionPointer<Func2>::IsPointerToMemberFunction, QMetaObject::Connection>::type
            connect(const typename QtPrivate::FunctionPointer<Func1>::Object *sender, Func1 signal, const QObject *context, Func2 slot,
                    Qt::ConnectionType type = Qt::AutoConnection)
+/
    static extern(D) QMetaObject.Connection connect(Signal, Dg)(Signal sender, Dg dg, ConnectionType type = ConnectionType.AutoConnection) if(is(Signal: DQtMember!P, P...) && !is(Dg: DQtMember!P2, P2...))
    {
        return connect(sender, sender.obj, dg, type);
    }
    static extern(D) QMetaObject.Connection connect(Signal, Dg)(Signal sender, QObject context, Dg dg, ConnectionType type = ConnectionType.AutoConnection) if(is(Signal: DQtMember!P, P...) && !is(Dg: DQtMember!P2, P2...))
    {
        import core.stdcpp.new_;

        /*typedef QtPrivate::FunctionPointer<Func1> SignalType;
        typedef QtPrivate::FunctionPointer<Func2> SlotType;

        Q_STATIC_ASSERT_X(QtPrivate::HasQ_OBJECT_Macro<typename SignalType::Object>::Value,
                          "No Q_OBJECT in the class with the signal");*/

        //compilation error if the arguments does not match.
        /*Q_STATIC_ASSERT_X(int(SignalType::ArgumentCount) >= int(SlotType::ArgumentCount),
                          "The slot requires more arguments than the signal provides.");
        Q_STATIC_ASSERT_X((QtPrivate::CheckCompatibleArguments<typename SignalType::Arguments, typename SlotType::Arguments>::value),
                          "Signal and slot arguments are not compatible.");
        Q_STATIC_ASSERT_X((QtPrivate::AreArgumentsCompatible<typename SlotType::ReturnType, typename SignalType::ReturnType>::value),
                          "Return type of the slot is not compatible with the return type of the signal.");*/

        const int *types = null;
        if (type == ConnectionType.QueuedConnection || type == ConnectionType.BlockingQueuedConnection)
        {
            assert(false);
            //types = QtPrivate::ConnectionTypes<typename SignalType::Arguments>::types();
        }

        static assert(Signal.Members.length == 1);

        auto signal = &memberFunctionExternDeclaration!(Signal.Members[0]);

        auto slotObj = cpp_new!(DQtStaticSlotObject!(Parameters!Dg))(dg);

        //pragma(msg, __traits(parent, Signal.Type.staticMetaObject));

        auto mo = &Signal.Type.staticMetaObject;

        // TODO: ABI for virtual functions is different.
        CPPMemberFunctionPointer!(Signal.Type) memberFunction = CPPMemberFunctionPointer!(Signal.Type)(signal);

        return connectImpl(sender.obj, cast(void**)&memberFunction, context, null,
                           &slotObj.base,
                           type, types, mo);
    }

    static extern(D) QMetaObject.Connection connect(Signal, Slot)(Signal sender, Slot receiver, ConnectionType type = ConnectionType.AutoConnection) if(is(Signal: DQtMember!P, P...) && is(Slot: DQtMember!P2, P2...))
    {
       import core.stdcpp.new_;

       /+ typedef QtPrivate::FunctionPointer<Func1> SignalType;
        typedef QtPrivate::FunctionPointer<Func2> SlotType;

        Q_STATIC_ASSERT_X(QtPrivate::HasQ_OBJECT_Macro<typename SignalType::Object>::Value,
                          "No Q_OBJECT in the class with the signal");

        //compilation error if the arguments does not match.
        Q_STATIC_ASSERT_X(int(SignalType::ArgumentCount) >= int(SlotType::ArgumentCount),
                          "The slot requires more arguments than the signal provides.");
        Q_STATIC_ASSERT_X((QtPrivate::CheckCompatibleArguments<typename SignalType::Arguments, typename SlotType::Arguments>::value),
                          "Signal and slot arguments are not compatible.");
        Q_STATIC_ASSERT_X((QtPrivate::AreArgumentsCompatible<typename SlotType::ReturnType, typename SignalType::ReturnType>::value),
                          "Return type of the slot is not compatible with the return type of the signal.");+/

        const int *types = null;
        if (type == ConnectionType.QueuedConnection || type == ConnectionType.BlockingQueuedConnection)
        {
            assert(false); // TODO
            //types = QtPrivate::ConnectionTypes<typename SignalType::Arguments>::types();
        }

        enum size_t[2] overloadIndices = delegate size_t[2](){
            size_t[2] r = [size_t.max, size_t.max];
            size_t numPossible;
            static foreach(i, signal; Signal.Members)
            static foreach(j, slot; Slot.Members)
            {
                //pragma(msg, i, " ", j, " ", __traits(identifier, signal), " ", __traits(identifier, slot));
                static if(Parameters!(signal).length >= Parameters!(slot).length) // TODO: allow default arguments
                {{
                    bool possible = true;
                    static foreach(k; 0..Parameters!(slot).length)
                    {
                        static if(!__traits(compiles, {Parameters!(slot)[k] p = Parameters!(signal)[k].init;}))
                        {
                            //pragma(msg, " param ", k, " not compatible ", Parameters!(signal)[k], " ", Parameters!(slot)[k]);
                            possible = false;
                        }
                        else
                        {
                            //pragma(msg, " param ", k, " compatible ", Parameters!(signal)[k], " ", Parameters!(slot)[k]);
                        }
                    }
                    if(possible)
                    {
                        r = [i, j];
                        numPossible++;
                    }
                }}
            }
            if(numPossible == 1)
                return r;
            return [size_t.max, size_t.max];
        }();

        static if(overloadIndices[0] == size_t.max || overloadIndices[1] == size_t.max)
        {
            pragma(msg, "Signals:");
            static foreach(signal; Signal.Members)
                pragma(msg, __traits(identifier, signal), " ", Parameters!(signal));
            pragma(msg, "Slots:");
            static foreach(slot; Slot.Members)
                pragma(msg, __traits(identifier, slot), " ", Parameters!(slot));
        }
        static assert(overloadIndices[0] != size_t.max);
        static assert(overloadIndices[1] != size_t.max);

        auto signal = &memberFunctionExternDeclaration!(Signal.Members[overloadIndices[0]]);

        auto slot = &memberFunctionExternDeclaration!(Slot.Members[overloadIndices[1]]);

        alias UsedParams = Parameters!(Signal.Members[overloadIndices[0]])[0..Parameters!(Slot.Members[overloadIndices[1]]).length];

        auto slotObj = cpp_new!(DQtMemberSlotObject!(typeof(Slot.obj), Slot.Members[overloadIndices[1]], UsedParams))(0);

        auto mo = &Signal.Type.staticMetaObject;

        // TODO: ABI for virtual functions is different.
        CPPMemberFunctionPointer!(Signal.Type) memberFunction = CPPMemberFunctionPointer!(Signal.Type)(signal);
        CPPMemberFunctionPointer!(Slot.Type) memberFunction2 = CPPMemberFunctionPointer!(Slot.Type)(slot);

        return connectImpl(sender.obj, cast(void**)&memberFunction,
                           receiver.obj, cast(void**)&memberFunction2,
                           &slotObj.base,
                            type, types, mo);
    }

/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    final void dumpObjectTree(); // ### Qt 6: remove
    final void dumpObjectInfo(); // ### Qt 6: remove
/+ #endif +/
    final void dumpObjectTree() const;
    final void dumpObjectInfo() const;

/+ #ifndef QT_NO_PROPERTIES +/
    version(QT_NO_PROPERTIES){}else
    {
        final bool setProperty(const(char)* name, ref const(QVariant) value);
        final bool setProperty(T)(const(char)* name, auto ref T value)
        {
            QVariant v = QVariant(value);
            return setProperty(name, v);
        }
        final QVariant property(const(char)* name) const;
        final QList!(QByteArray) dynamicPropertyNames() const;
    }
/+ #endif // QT_NO_PROPERTIES

#ifndef QT_NO_USERDATA +/
    version(QT_NO_USERDATA){}else
    {
        /+ QT_DEPRECATED_VERSION_5_14 +/
            static uint registerUserData();
        /+ QT_DEPRECATED_VERSION_X_5_14("Use setProperty()") +/
            final void setUserData(uint id, QObjectUserData data);
        /+ QT_DEPRECATED_VERSION_X_5_14("Use property()") +/
            final QObjectUserData userData(uint id) const;
    }
/+ #endif +/ // QT_NO_USERDATA

/+ Q_SIGNALS +/public:
    @QSignal final void destroyed(QObject  /+ = nullptr +/);
    @QSignal final void objectNameChanged(ref const(QString) objectName, QPrivateSignal);

public:
    pragma(inline, true) final QObject parent() const { return d_ptr.data.parent; }

    pragma(inline, true) final bool inherits(const(char)* classname) const
        { return const_cast!(QObject)(this).qt_metacast(classname) !is null; }

public /+ Q_SLOTS +/:
    @QSlot final void deleteLater();

protected:
    final QObject sender() const;
    final int senderSignalIndex() const;
    final int receivers(const(char)* signal) const;
    final bool isSignalConnected(ref const(QMetaMethod) signal) const;

    /+ virtual +/ void timerEvent(QTimerEvent event);
    /+ virtual +/ void childEvent(QChildEvent event);
    /+ virtual +/ void customEvent(QEvent event);

    /+ virtual +/ void connectNotify(ref const(QMetaMethod) signal);
    /+ virtual +/ void disconnectNotify(ref const(QMetaMethod) signal);

protected:
    this(ref QObjectPrivate dd, QObject parent = null);

protected:
    QScopedPointer!(QObjectData) d_ptr;

    mixin(mangleWindows("?staticQtMetaObject@QObject@@1UQMetaObject@@B", exportOnWindows ~ q{
    extern static __gshared const(QMetaObject) staticQtMetaObject;
    }));
    /+ friend inline const QMetaObject *qt_getQtMetaObject() noexcept; +/

    /+ friend struct QMetaObject; +/
    /+ friend struct QMetaObjectPrivate; +/
    /+ friend class QMetaCallEvent; +/
    /+ friend class QApplication; +/
    /+ friend class QApplicationPrivate; +/
    /+ friend class QCoreApplication; +/
    /+ friend class QCoreApplicationPrivate; +/
    /+ friend class QWidget; +/
    /+ friend class QAccessibleWidget; +/
    /+ friend class QThreadData; +/

private:
    /+ Q_DISABLE_COPY(QObject) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_reregisterTimers(void *)) +/

private:
    mixin(mangleWindows("?connectImpl@QObject@@CA?AVConnection@QMetaObject@@PEBV1@PEAPEAX01PEAVQSlotObjectBase@QtPrivate@@W4ConnectionType@Qt@@PEBHPEBU3@@Z", q{
    static QMetaObject.Connection connectImpl(const(QObject) sender, void** signal,
                                                   const(QObject) receiver, void** slotPtr,
                                                   /+ QtPrivate:: +/qt.core.objectdefs_impl.QSlotObjectBase* slot, /+ Qt:: +/qt.core.namespace.ConnectionType type,
                                                   const(int)* types, const(QMetaObject)* senderMetaObject);
    }));

    static bool disconnectImpl(const(QObject) sender, void** signal, const(QObject) receiver, void** slot,
                                   const(QMetaObject)* senderMetaObject);

}

/+ inline QMetaObject::Connection QObject::connect(const QObject *asender, const char *asignal,
                                            const char *amember, Qt::ConnectionType atype) const
{ return connect(asender, asignal, this, amember, atype); } +/

pragma(inline, true) const(QMetaObject)* qt_getQtMetaObject()/+ noexcept+/
{ return &QObject.staticQtMetaObject; }

version(QT_NO_USERDATA){}else
{
class /+ Q_CORE_EXPORT +/ QObjectUserData {
private:
    /+ Q_DISABLE_COPY(QObjectUserData) +/
public:
    /+ QObjectUserData() = default; +/
    /+ virtual +/~this();
}
}

/+ #if QT_DEPRECATED_SINCE(5, 0)
template<typename T>
inline QT_DEPRECATED T qFindChild(const QObject *o, const QString &name = QString())
{ return o->findChild<T>(name); }

template<typename T>
inline QT_DEPRECATED QList<T> qFindChildren(const QObject *o, const QString &name = QString())
{
    return o->findChildren<T>(name);
}

#if !defined(QT_NO_REGEXP) || defined(Q_CLANG_QDOC)
template<typename T>
inline QT_DEPRECATED QList<T> qFindChildren(const QObject *o, const QRegExp &re)
{
    return o->findChildren<T>(re);
}
#endif

#endif //QT_DEPRECATED

template <class T>
inline T qobject_cast(QObject *object)
{
    typedef typename std::remove_cv<typename std::remove_pointer<T>::type>::type ObjType;
    Q_STATIC_ASSERT_X(QtPrivate::HasQ_OBJECT_Macro<ObjType>::Value,
                    "qobject_cast requires the type to have a Q_OBJECT macro");
    return static_cast<T>(ObjType::staticMetaObject.cast(object));
}

template <class T>
inline T qobject_cast(const QObject *object)
{
    typedef typename std::remove_cv<typename std::remove_pointer<T>::type>::type ObjType;
    Q_STATIC_ASSERT_X(QtPrivate::HasQ_OBJECT_Macro<ObjType>::Value,
                      "qobject_cast requires the type to have a Q_OBJECT macro");
    return static_cast<T>(ObjType::staticMetaObject.cast(object));
}


template <class T> inline const char * qobject_interface_iid()
{ return nullptr; }


#if defined(Q_CLANG_QDOC)
#  define Q_DECLARE_INTERFACE(IFace, IId)
#elif !defined(Q_MOC_RUN)
#  define Q_DECLARE_INTERFACE(IFace, IId) \
    template <> inline const char *qobject_interface_iid<IFace *>() \
    { return IId; } \
    template <> inline IFace *qobject_cast<IFace *>(QObject *object) \
    { return reinterpret_cast<IFace *>((object ? object->qt_metacast(IId) : nullptr)); } \
    template <> inline IFace *qobject_cast<IFace *>(const QObject *object) \
    { return reinterpret_cast<IFace *>((object ? const_cast<QObject *>(object)->qt_metacast(IId) : nullptr)); }
#endif // Q_MOC_RUN

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QObject *);
#endif

class QSignalBlocker
{
public:
    inline explicit QSignalBlocker(QObject *o) noexcept;
    inline explicit QSignalBlocker(QObject &o) noexcept;
    inline ~QSignalBlocker();

    inline QSignalBlocker(QSignalBlocker &&other) noexcept;
    inline QSignalBlocker &operator=(QSignalBlocker &&other) noexcept;

    inline void reblock() noexcept;
    inline void unblock() noexcept;
private:
    Q_DISABLE_COPY(QSignalBlocker)
    QObject * m_o;
    bool m_blocked;
    bool m_inhibited;
};

QSignalBlocker::QSignalBlocker(QSignalBlocker &&other) noexcept
    : m_o(other.m_o),
      m_blocked(other.m_blocked),
      m_inhibited(other.m_inhibited)
{
    other.m_o = nullptr;
}

QSignalBlocker &QSignalBlocker::operator=(QSignalBlocker &&other) noexcept
{
    if (this != &other) {
        // if both *this and other block the same object's signals:
        // unblock *this iff our dtor would unblock, but other's wouldn't
        if (m_o != other.m_o || (!m_inhibited && other.m_inhibited))
            unblock();
        m_o = other.m_o;
        m_blocked = other.m_blocked;
        m_inhibited = other.m_inhibited;
        // disable other:
        other.m_o = nullptr;
    }
    return *this;
}

namespace QtPrivate {
    inline QObject & deref_for_methodcall(QObject &o) { return  o; }
    inline QObject & deref_for_methodcall(QObject *o) { return *o; }
}
#define Q_SET_OBJECT_NAME(obj) QT_PREPEND_NAMESPACE(QtPrivate)::deref_for_methodcall(obj).setObjectName(QLatin1String(#obj)) +/


/+ #endif +/

template IsQSignal(alias F)
{
    enum IsQSignal = getUDAs!(F, QObject.QSignal).length > 0;
}
template IsQSlot(alias F)
{
    enum IsQSlot = getUDAs!(F, QObject.QSlot).length > 0;
}
template IsQInvokable(alias F)
{
    enum IsQInvokable = getUDAs!(F, QObject.QInvokable).length > 0;
}
template IsQScriptable(alias F)
{
    enum IsQScriptable = getUDAs!(F, QObject.Scriptable).length > 0;
}
