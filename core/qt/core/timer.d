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
import qt.core.metamacros;
import qt.core.namespace;
import qt.core.object;
import qt.core.objectdefs_impl;
import qt.core.property;
import qt.helpers;
import std.traits;

/+ #ifndef QT_NO_QOBJECT +/


extern(C++, class) struct QTimerPrivate;
/// Binding for C++ class [QTimer](https://doc.qt.io/qt-6/qtimer.html).
class /+ Q_CORE_EXPORT +/ QTimer : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool singleShot READ isSingleShot WRITE setSingleShot BINDABLE bindableSingleShot)
    Q_PROPERTY(int interval READ interval WRITE setInterval BINDABLE bindableInterval)
    Q_PROPERTY(int remainingTime READ remainingTime)
    Q_PROPERTY(Qt::TimerType timerType READ timerType WRITE setTimerType BINDABLE bindableTimerType)
    Q_PROPERTY(bool active READ isActive STORED false BINDABLE bindableActive) +/
public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    final bool isActive() const;
    final QBindable!(bool) bindableActive();
    final int timerId() const;

    final void setInterval(int msec);
    final int interval() const;
    final QBindable!(int) bindableInterval();

    final int remainingTime() const;

    final void setTimerType(/+ Qt:: +/qt.core.namespace.TimerType atype);
    final /+ Qt:: +/qt.core.namespace.TimerType timerType() const;
    final QBindable!(/+ Qt:: +/qt.core.namespace.TimerType) bindableTimerType();

    final void setSingleShot(bool singleShot);
    final bool isSingleShot() const;
    final QBindable!(bool) bindableSingleShot();

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
        static_assert(int(SlotType::ArgumentCount) == 0,
                          "The slot must not have any arguments.");

        singleShotImpl(interval, timerType, receiver,
                       new QtPrivate::QSlotObject<Func1, typename SlotType::Arguments, void>(slot));
    } +/

    /++
        Creates a single-shot timer that calls a slot after a delay.

        Params:
            msec      = Delay in milliseconds.
            timerType = Type of timer.
            receiver  = Slot to be called.
    +/
    static extern(D) void singleShot(Slot)(int msec, /+ Qt:: +/qt.core.namespace.TimerType timerType, Slot receiver) if (is(Slot: DQtMember!P, P...))
    {
        import core.stdcpp.new_;

        static assert(Slot.Members.length == 1, "QTimer.singleShot only implemented for one slot."); // TODO: Select best slot if multiple are available
        alias Slot0 = Slot.Members[0];
        static assert(Parameters!(Slot0).length == 0, "The slot must not have any arguments."); // TODO: allow default arguments

        auto slot = getMemberFunctionAddress!(Slot0);

        alias UsedParams = Parameters!(Slot0);

        auto slotObj = cpp_new!(DQtMemberSlotObject!(typeof(Slot.obj), Slot0, UsedParams))(0);

        singleShotImpl(msec, timerType, receiver.obj, &slotObj.base);
    }
    /// ditto
    static extern(D) void singleShot(Slot)(int msec, Slot receiver) if (is(Slot: DQtMember!P, P...))
    {
        singleShot(msec, defaultTypeFor(msec), receiver);
    }

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
        static_assert(int(SlotType::ArgumentCount) <= 0,  "The slot must not have any arguments.");

        singleShotImpl(interval, timerType, context,
                       new QtPrivate::QFunctorSlotObject<Func1, 0,
                            typename QtPrivate::List_Left<void, 0>::Value, void>(std::move(slot)));
    } +/

    /++
        Creates a single-shot timer that calls a delegate after a delay.

        Params:
            msec      = Delay in milliseconds.
            timerType = Type of timer.
            context   = Context object. Timer is stopped if context is destroyed.
            dg        = Delegate to be called.
    +/
    static extern(D) void singleShot(Dg)(int msec, /+ Qt:: +/qt.core.namespace.TimerType timerType, const(QObject) context, Dg dg) if (is(Dg == delegate))
    {
        import core.stdcpp.new_;

        static assert(Parameters!(Dg).length == 0, "The delegate must not have any arguments."); // TODO: allow default arguments

        alias UsedParams = Parameters!(Dg);

        const(int)* types = null;

        auto slotObj = cpp_new!(DQtStaticSlotObject!(Dg, UsedParams))(dg);

        singleShotImpl(msec, timerType, context, &slotObj.base);
    }
    /// ditto
    static extern(D) void singleShot(Dg)(int msec, Dg dg) if (is(Dg == delegate))
    {
        singleShot(msec, defaultTypeFor(msec), null, dg);
    }
    /// ditto
    static extern(D) void singleShot(Dg)(int msec, /+ Qt:: +/qt.core.namespace.TimerType timerType, Dg dg) if (is(Dg == delegate))
    {
        singleShot(msec, timerType, null, dg);
    }
    /// ditto
    static extern(D) void singleShot(Dg)(int msec, const(QObject) context, Dg dg) if (is(Dg == delegate))
    {
        singleShot(msec, defaultTypeFor(msec), context, dg);
    }

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
    /+ void setInterval(std::chrono::milliseconds value)
    {
        setInterval(int(value.count()));
    } +/

    /+ std::chrono::milliseconds intervalAsDuration() const
    {
        return std::chrono::milliseconds(interval());
    } +/

    /+ std::chrono::milliseconds remainingTimeAsDuration() const
    {
        return std::chrono::milliseconds(remainingTime());
    } +/

    /+ static void singleShot(std::chrono::milliseconds value, const QObject *receiver, const char *member)
    {
        singleShot(int(value.count()), receiver, member);
    } +/

    /+ static void singleShot(std::chrono::milliseconds value, Qt::TimerType timerType, const QObject *receiver, const char *member)
    {
        singleShot(int(value.count()), timerType, receiver, member);
    } +/

    /+ void start(std::chrono::milliseconds value)
    {
        start(int(value.count()));
    } +/

protected:
    override void timerEvent(QTimerEvent );

private:
    /+ Q_DISABLE_COPY(QTimer) +/
    /+ Q_DECLARE_PRIVATE(QTimer) +/

    pragma(inline, true) final int startTimer(int){ return -1;}
    pragma(inline, true) final void killTimer(int){}

    static /+ Qt:: +/qt.core.namespace.TimerType defaultTypeFor(int msecs) nothrow
    { return msecs >= 2000 ? /+ Qt:: +/qt.core.namespace.TimerType.CoarseTimer : /+ Qt:: +/qt.core.namespace.TimerType.PreciseTimer; }
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static void singleShotImpl(int msec, /+ Qt:: +/qt.core.namespace.TimerType timerType,
                                   const(QObject) receiver, /+ QtPrivate:: +/dqtimported!q{qt.core.objectdefs_impl}.QSlotObjectBase* slotObj);
    }));

    /+ static Qt::TimerType defaultTypeFor(std::chrono::milliseconds interval)
    { return defaultTypeFor(int(interval.count())); } +/

    /+ static void singleShotImpl(std::chrono::milliseconds interval, Qt::TimerType timerType,
                               const QObject *receiver, QtPrivate::QSlotObjectBase *slotObj)
    {
        singleShotImpl(int(interval.count()),
                       timerType, receiver, slotObj);
    } +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ #endif +/ // QT_NO_QOBJECT

