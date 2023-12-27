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
module qt.core.thread;
extern(C++):

import core.stdc.config;
import qt.config;
import qt.core.coreapplication;
import qt.core.coreevent;
import qt.core.deadlinetimer;
import qt.core.namespace;
import qt.core.object;
import qt.helpers;

// For QThread::create. The configure-time test just checks for the availability
// of std::future and std::async; for the C++17 codepath we perform some extra
// checks here (for std::invoke and C++14 lambdas).
/+ #if QT_CONFIG(cxx11_future)
#  if defined(__cpp_lib_invoke) && __cpp_lib_invoke >= 201411 \
      && defined(__cpp_init_captures) && __cpp_init_captures >= 201304 \
      && defined(__cpp_generic_lambdas) &&  __cpp_generic_lambdas >= 201304
#    define QTHREAD_HAS_VARIADIC_CREATE
#  endif
#endif +/



extern(C++, class) struct QThreadData;
extern(C++, class) struct QThreadPrivate;

/// Binding for C++ class [QThread](https://doc.qt.io/qt-5/qthread.html).
class /+ Q_CORE_EXPORT +/ QThread : QObject
{
    mixin(Q_OBJECT);
public:
    static /+ Qt:: +/qt.core.namespace.HANDLE currentThreadId()/+ noexcept /+ Q_DECL_PURE_FUNCTION +/__attribute__((pure))+/;
    static QThread currentThread();
    static int idealThreadCount()/+ noexcept+/;
    static void yieldCurrentThread();

    /+ explicit +/this(QObject parent = null);
    ~this();

    enum Priority {
        IdlePriority,

        LowestPriority,
        LowPriority,
        NormalPriority,
        HighPriority,
        HighestPriority,

        TimeCriticalPriority,

        InheritPriority
    }

    final void setPriority(Priority priority);
    final Priority priority() const;

    final bool isFinished() const;
    final bool isRunning() const;

    final void requestInterruption();
    final bool isInterruptionRequested() const;

    final void setStackSize(uint stackSize);
    final uint stackSize() const;

    final void exit(int retcode = 0);

    final QAbstractEventDispatcher* eventDispatcher() const;
    final void setEventDispatcher(QAbstractEventDispatcher* eventDispatcher);

    override bool event(QEvent event);
    final int loopLevel() const;

/+ #ifdef Q_CLANG_QDOC
    template <typename Function, typename... Args>
    static QThread *create(Function &&f, Args &&... args);
    template <typename Function>
    static QThread *create(Function &&f);
#else
#  if QT_CONFIG(cxx11_future)
#    ifdef QTHREAD_HAS_VARIADIC_CREATE +/
    static if (defined!"QTHREAD_HAS_VARIADIC_CREATE")
    {
        /+ template <typename Function, typename... Args> +/
        /+ static QThread *create(Function &&f, Args &&... args); +/
    }
    else
    {
    /+ #    else +/
        /+ template <typename Function> +/
        /+ static QThread *create(Function &&f); +/
    }
/+ #    endif // QTHREAD_HAS_VARIADIC_CREATE
#  endif // QT_CONFIG(cxx11_future)
#endif +/ // Q_CLANG_QDOC

public /+ Q_SLOTS +/:
    @QSlot final void start(Priority = Priority.InheritPriority);
    @QSlot final void terminate();
    @QSlot final void quit();

public:
    final bool wait(QDeadlineTimer deadline = QDeadlineTimer(QDeadlineTimer.ForeverConstant.Forever));
    // ### Qt6 inline this function
    final bool wait(cpp_ulong  time);

    static void sleep(cpp_ulong );
    static void msleep(cpp_ulong );
    static void usleep(cpp_ulong );

/+ Q_SIGNALS +/public:
    @QSignal final void started(QPrivateSignal);
    @QSignal final void finished(QPrivateSignal);

protected:
    /+ virtual +/ void run();
    final int exec();

    static void setTerminationEnabled(bool enabled = true);

protected:
    this(ref QThreadPrivate dd, QObject parent = null);

private:
    /+ Q_DECLARE_PRIVATE(QThread) +/

/+ #if QT_CONFIG(cxx11_future) +/
    /+ static QThread *createThreadImpl(std::future<void> &&future); +/
/+ #endif +/

    /+ friend class QCoreApplication; +/
    /+ friend class QThreadData; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #if QT_CONFIG(cxx11_future) +/

/+ #if defined(QTHREAD_HAS_VARIADIC_CREATE) || defined(Q_CLANG_QDOC)
// C++17: std::thread's constructor complying call
template <typename Function, typename... Args>
QThread *QThread::create(Function &&f, Args &&... args)
{
    using DecayedFunction = typename std::decay<Function>::type;
    auto threadFunction =
        [f = static_cast<DecayedFunction>(std::forward<Function>(f))](auto &&... largs) mutable -> void
        {
            (void)std::invoke(std::move(f), std::forward<decltype(largs)>(largs)...);
        };

    return createThreadImpl(std::async(std::launch::deferred,
                                       std::move(threadFunction),
                                       std::forward<Args>(args)...));
}
#elif defined(__cpp_init_captures) && __cpp_init_captures >= 201304
// C++14: implementation for just one callable
template <typename Function>
QThread *QThread::create(Function &&f)
{
    using DecayedFunction = typename std::decay<Function>::type;
    auto threadFunction =
        [f = static_cast<DecayedFunction>(std::forward<Function>(f))]() mutable -> void
        {
            (void)f();
        };

    return createThreadImpl(std::async(std::launch::deferred, std::move(threadFunction)));
}
#else +/
static if (!defined!"QTHREAD_HAS_VARIADIC_CREATE")
{
// C++11: same as C++14, but with a workaround for not having generalized lambda captures
extern(C++, "QtPrivate") {
struct Callable(Function)
{
    /+ explicit Callable(Function &&f)
        : m_function(std::forward<Function>(f))
    {
    } +/

    // Apply the same semantics of a lambda closure type w.r.t. the special
    // member functions, if possible: delete the copy assignment operator,
    // bring back all the others as per the RO5 (cf. §8.1.5.1/11 [expr.prim.lambda.closure])
    /+ ~Callable() = default; +/
    /+ Callable(const Callable &) = default; +/
    /+ Callable(Callable &&) = default; +/
    /+ref Callable operator =(ref const(Callable) ) /+ = delete +/;+/
    /+ Callable &operator=(Callable &&) = default; +/

    /+void operator ()()
    {
        cast(void)m_function();
    }+/

    /+ std:: +/decay!(Function).type m_function;
}
} // namespace QtPrivate

/+ template <typename Function>
QThread *QThread::create(Function &&f)
{
    return createThreadImpl(std::async(std::launch::deferred, QtPrivate::Callable<Function>(std::forward<Function>(f))));
} +/
}
/+ #endif +/ // QTHREAD_HAS_VARIADIC_CREATE

/+ #endif +/ // QT_CONFIG(cxx11_future)

