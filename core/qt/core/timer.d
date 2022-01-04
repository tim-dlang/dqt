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
module qt.core.timer;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.object;
import qt.helpers;

/+ #ifndef QT_NO_QOBJECT +/

/+ #if __has_include(<chrono>)
#endif +/



/// Binding for C++ class [QTimer](https://doc.qt.io/qt-5/qtimer.html).
class /+ Q_CORE_EXPORT +/ QTimer : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool singleShot READ isSingleShot WRITE setSingleShot)
    Q_PROPERTY(int interval READ interval WRITE setInterval)
    Q_PROPERTY(int remainingTime READ remainingTime)
    Q_PROPERTY(Qt::TimerType timerType READ timerType WRITE setTimerType)
    Q_PROPERTY(bool active READ isActive) +/
public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    pragma(inline, true) final bool isActive() const { return id >= 0; }
    final int timerId() const { return id; }

    final void setInterval(int msec);
    final int interval() const { return inter; }

    final int remainingTime() const;

    final void setTimerType(/+ Qt:: +/qt.core.namespace.TimerType atype) { this.type = atype; }
    final /+ Qt:: +/qt.core.namespace.TimerType timerType() const { return cast(/+ Qt:: +/qt.core.namespace.TimerType)(type); }

    pragma(inline, true) final void setSingleShot(bool asingleShot) { single = asingleShot; }
    pragma(inline, true) final bool isSingleShot() const { return (single) != 0; }

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static void singleShot(int msec, const(QObject) receiver, const(char)* member);
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static void singleShot(int msec, /+ Qt:: +/qt.core.namespace.TimerType timerType, const(QObject) receiver, const(char)* member);
    }));

/+ #ifdef Q_CLANG_QDOC
    template<typename PointerToMemberFunction>
    static void singleShot(int msec, const QObject *receiver, PointerToMemberFunction method);
    template<typename PointerToMemberFunction>
    static void singleShot(int msec, Qt::TimerType timerType, const QObject *receiver, PointerToMemberFunction method);
    template<typename Functor>
    static void singleShot(int msec, Functor functor);
    template<typename Functor>
    static void singleShot(int msec, Qt::TimerType timerType, Functor functor);
    template<typename Functor, int>
    static void singleShot(int msec, const QObject *context, Functor functor);
    template<typename Functor, int>
    static void singleShot(int msec, Qt::TimerType timerType, const QObject *context, Functor functor);
    template <typename Functor>
    QMetaObject::Connection callOnTimeout(Functor slot, Qt::ConnectionType connectionType = Qt::AutoConnection);
    template <typename Functor>
    QMetaObject::Connection callOnTimeout(const QObject *context, Functor slot, Qt::ConnectionType connectionType = Qt::AutoConnection);
    template <typename MemberFunction>
    QMetaObject::Connection callOnTimeout(const QObject *receiver, MemberFunction *slot, Qt::ConnectionType connectionType = Qt::AutoConnection);
#else +/
    // singleShot to a QObject slot
    /+ template <typename Duration, typename Func1> +/
    /+ static inline void singleShot(Duration interval, const typename QtPrivate::FunctionPointer<Func1>::Object *receiver, Func1 slot)
    {
        singleShot(interval, defaultTypeFor(interval), receiver, slot);
    } +/
    /+ template <typename Duration, typename Func1> +/
    /+ static inline void singleShot(Duration interval, Qt::TimerType timerType, const typename QtPrivate::FunctionPointer<Func1>::Object *receiver,
                                  Func1 slot)
    {
        typedef QtPrivate::FunctionPointer<Func1> SlotType;

        //compilation error if the slot has arguments.
        Q_STATIC_ASSERT_X(int(SlotType::ArgumentCount) == 0,
                          "The slot must not have any arguments.");

        singleShotImpl(interval, timerType, receiver,
                       new QtPrivate::QSlotObject<Func1, typename SlotType::Arguments, void>(slot));
    } +/
    // singleShot to a functor or function pointer (without context)
    /+ template <typename Duration, typename Func1> +/
    /+ static inline typename std::enable_if<!QtPrivate::FunctionPointer<Func1>::IsPointerToMemberFunction &&
                                          !std::is_same<const char*, Func1>::value, void>::type
            singleShot(Duration interval, Func1 slot)
    {
        singleShot(interval, defaultTypeFor(interval), nullptr, std::move(slot));
    } +/
    /+ template <typename Duration, typename Func1> +/
    /+ static inline typename std::enable_if<!QtPrivate::FunctionPointer<Func1>::IsPointerToMemberFunction &&
                                          !std::is_same<const char*, Func1>::value, void>::type
            singleShot(Duration interval, Qt::TimerType timerType, Func1 slot)
    {
        singleShot(interval, timerType, nullptr, std::move(slot));
    } +/
    // singleShot to a functor or function pointer (with context)
    /+ template <typename Duration, typename Func1> +/
    /+ static inline typename std::enable_if<!QtPrivate::FunctionPointer<Func1>::IsPointerToMemberFunction &&
                                          !std::is_same<const char*, Func1>::value, void>::type
            singleShot(Duration interval, const QObject *context, Func1 slot)
    {
        singleShot(interval, defaultTypeFor(interval), context, std::move(slot));
    } +/
    /+ template <typename Duration, typename Func1> +/
    /+ static inline typename std::enable_if<!QtPrivate::FunctionPointer<Func1>::IsPointerToMemberFunction &&
                                          !std::is_same<const char*, Func1>::value, void>::type
            singleShot(Duration interval, Qt::TimerType timerType, const QObject *context, Func1 slot)
    {
        //compilation error if the slot has arguments.
        typedef QtPrivate::FunctionPointer<Func1> SlotType;
        Q_STATIC_ASSERT_X(int(SlotType::ArgumentCount) <= 0,  "The slot must not have any arguments.");

        singleShotImpl(interval, timerType, context,
                       new QtPrivate::QFunctorSlotObject<Func1, 0,
                            typename QtPrivate::List_Left<void, 0>::Value, void>(std::move(slot)));
    } +/

    /+ template <typename ... Args> +/
    /+ QMetaObject::Connection callOnTimeout(Args && ...args)
    {
        return QObject::connect(this, &QTimer::timeout, std::forward<Args>(args)... );
    } +/

/+ #endif +/

public /+ Q_SLOTS +/:
    @QSlot final void start(int msec);

    @QSlot final void start();
    @QSlot final void stop();

/+ Q_SIGNALS +/public:
    @QSignal final void timeout(QPrivateSignal);

public:
/+ #if __has_include(<chrono>) || defined(Q_QDOC) +/
/+    final void setInterval(/+ std::chrono:: +/milliseconds value)
    {
        setInterval(int(value.count()));
    }

    final /+ std::chrono:: +/milliseconds intervalAsDuration() const
    {
        auto tmp = interval(); return /+ std:: +//+ chrono:: +/milliseconds(tmp);
    }

    final /+ std::chrono:: +/milliseconds remainingTimeAsDuration() const
    {
        auto tmp = remainingTime(); return /+ std:: +//+ chrono:: +/milliseconds(tmp);
    }

    static void singleShot(/+ std::chrono:: +/milliseconds value, const(QObject) receiver, const(char)* member)
    {
        singleShot(int(value.count()), receiver, member);
    }

    static void singleShot(/+ std::chrono:: +/milliseconds value, /+ Qt:: +/qt.core.namespace.TimerType timerType, const(QObject) receiver, const(char)* member)
    {
        singleShot(int(value.count()), timerType, receiver, member);
    }

    final void start(/+ std::chrono:: +/milliseconds value)
    {
        start(int(value.count()));
    }+/
/+ #endif +/

protected:
    override void timerEvent(QTimerEvent );

private:
    /+ Q_DISABLE_COPY(QTimer) +/

    pragma(inline, true) final int startTimer(int){ return -1;}
    pragma(inline, true) final void killTimer(int){}

    static /+ Qt:: +/qt.core.namespace.TimerType defaultTypeFor(int msecs)/+ noexcept+/
    { return msecs >= 2000 ? /+ Qt:: +/qt.core.namespace.TimerType.CoarseTimer : /+ Qt:: +/qt.core.namespace.TimerType.PreciseTimer; }
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static void singleShotImpl(int msec, /+ Qt:: +/qt.core.namespace.TimerType timerType,
                                   const(QObject) receiver, /+ QtPrivate:: +/dqtimported!q{qt.core.objectdefs_impl}.QSlotObjectBase* slotObj);
    }));

/+ #if __has_include(<chrono>) +/
/+    static /+ Qt:: +/qt.core.namespace.TimerType defaultTypeFor(/+ std::chrono:: +/milliseconds interval)
    { return defaultTypeFor(int(interval.count())); }+/

/+    static void singleShotImpl(/+ std::chrono:: +/milliseconds interval, /+ Qt:: +/qt.core.namespace.TimerType timerType,
                                   const(QObject) receiver, /+ QtPrivate:: +/qt.core.objectdefs_impl.QSlotObjectBase* slotObj)
    {
        singleShotImpl(int(interval.count()),
                       timerType, receiver, slotObj);
    }+/
/+ #endif +/

    int id; int inter; int del;
    /+ uint single : 1; +/
    ubyte bitfieldData_single;
    uint single() const
    {
        return (bitfieldData_single >> 0) & 0x1;
    }
    uint single(uint value)
    {
        bitfieldData_single = (bitfieldData_single & ~0x1) | ((value & 0x1) << 0);
        return value;
    }
    /+ uint nulltimer : 1; +/
    uint nulltimer() const
    {
        return (bitfieldData_single >> 1) & 0x1;
    }
    uint nulltimer(uint value)
    {
        bitfieldData_single = (bitfieldData_single & ~0x2) | ((value & 0x1) << 1);
        return value;
    }
    /+ uint type : 2; +/
    uint type() const
    {
        return (bitfieldData_single >> 2) & 0x3;
    }
    uint type(uint value)
    {
        bitfieldData_single = (bitfieldData_single & ~0xc) | ((value & 0x3) << 2);
        return value;
    }
    // reserved : 28
}


/+ #endif +/ // QT_NO_QOBJECT

