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
module qt.core.deadlinetimer;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.pair;
import qt.core.typeinfo;
import qt.helpers;

/+ #ifdef max
// un-pollute the namespace. We need std::numeric_limits::max() and std::chrono::duration::max()
#  undef max
#endif

#if __has_include(<chrono>)
#endif +/


/// Binding for C++ class [QDeadlineTimer](https://doc.qt.io/qt-5/qdeadlinetimer.html).
@Q_DECLARE_METATYPE @Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QDeadlineTimer
{
public:
    enum ForeverConstant { Forever }

    @disable this();
    this(/+ Qt:: +/qt.core.namespace.TimerType type_/+ = /+ Qt:: +/qt.core.namespace.TimerType.CoarseTimer+/) nothrow
    {
        this.t1 = 0;
        this.t2 = 0;
        this.type = type_;
    }
    this(ForeverConstant, /+ Qt:: +/qt.core.namespace.TimerType type_ = /+ Qt:: +/qt.core.namespace.TimerType.CoarseTimer) nothrow
    {
        this.t1 = qint64.max;
        this.t2 = 0;
        this.type = type_;
    }
    /+ explicit +/this(qint64 msecs, /+ Qt:: +/qt.core.namespace.TimerType type = /+ Qt:: +/qt.core.namespace.TimerType.CoarseTimer) nothrow;

    /+ void swap(QDeadlineTimer &other) noexcept
    { qSwap(t1, other.t1); qSwap(t2, other.t2); qSwap(type, other.type); } +/

    bool isForever() const nothrow
    { return t1 == qint64.max; }
    bool hasExpired() const nothrow;

    /+ Qt:: +/qt.core.namespace.TimerType timerType() const nothrow
    { return cast(/+ Qt:: +/qt.core.namespace.TimerType) (type & 0xff); }
    void setTimerType(/+ Qt:: +/qt.core.namespace.TimerType type);

    qint64 remainingTime() const nothrow;
    qint64 remainingTimeNSecs() const nothrow;
    void setRemainingTime(qint64 msecs, /+ Qt:: +/qt.core.namespace.TimerType type = /+ Qt:: +/qt.core.namespace.TimerType.CoarseTimer) nothrow;
    void setPreciseRemainingTime(qint64 secs, qint64 nsecs = 0,
                                     /+ Qt:: +/qt.core.namespace.TimerType type = /+ Qt:: +/qt.core.namespace.TimerType.CoarseTimer) nothrow;

    qint64 deadline() const nothrow/+ /+ Q_DECL_PURE_FUNCTION +/__attribute__((pure))+/;
    qint64 deadlineNSecs() const nothrow/+ /+ Q_DECL_PURE_FUNCTION +/__attribute__((pure))+/;
    void setDeadline(qint64 msecs, /+ Qt:: +/qt.core.namespace.TimerType timerType = /+ Qt:: +/qt.core.namespace.TimerType.CoarseTimer) nothrow;
    void setPreciseDeadline(qint64 secs, qint64 nsecs = 0,
                                /+ Qt:: +/qt.core.namespace.TimerType type = /+ Qt:: +/qt.core.namespace.TimerType.CoarseTimer) nothrow;

    static QDeadlineTimer addNSecs(QDeadlineTimer dt, qint64 nsecs) nothrow/+ /+ Q_DECL_PURE_FUNCTION +/__attribute__((pure))+/;
    static QDeadlineTimer current(/+ Qt:: +/qt.core.namespace.TimerType timerType = /+ Qt:: +/qt.core.namespace.TimerType.CoarseTimer) nothrow;

    /+ friend bool operator==(QDeadlineTimer d1, QDeadlineTimer d2) noexcept
    { return d1.t1 == d2.t1 && d1.t2 == d2.t2; } +/
    /+ friend bool operator!=(QDeadlineTimer d1, QDeadlineTimer d2) noexcept
    { return !(d1 == d2); } +/
    /+ friend bool operator<(QDeadlineTimer d1, QDeadlineTimer d2) noexcept
    { return d1.t1 < d2.t1 || (d1.t1 == d2.t1 && d1.t2 < d2.t2); } +/
    /+ friend bool operator<=(QDeadlineTimer d1, QDeadlineTimer d2) noexcept
    { return d1 == d2 || d1 < d2; } +/
    /+ friend bool operator>(QDeadlineTimer d1, QDeadlineTimer d2) noexcept
    { return d2 < d1; } +/
    /+ friend bool operator>=(QDeadlineTimer d1, QDeadlineTimer d2) noexcept
    { return !(d1 < d2); } +/

    /+ friend Q_CORE_EXPORT QDeadlineTimer operator+(QDeadlineTimer dt, qint64 msecs); +/
    /+ friend QDeadlineTimer operator+(qint64 msecs, QDeadlineTimer dt)
    { return dt + msecs; } +/
    /+ friend QDeadlineTimer operator-(QDeadlineTimer dt, qint64 msecs)
    { return dt + (-msecs); } +/
    /+ friend qint64 operator-(QDeadlineTimer dt1, QDeadlineTimer dt2)
    { return (dt1.deadlineNSecs() - dt2.deadlineNSecs()) / (1000 * 1000); } +/
    ref QDeadlineTimer opOpAssign(string op)(qint64 msecs) if (op == "+")
    { this = this + msecs; return this; }
    ref QDeadlineTimer opOpAssign(string op)(qint64 msecs) if (op == "-")
    { this = this + (-msecs); return this; }

/+ #if __has_include(<chrono>) || defined(Q_CLANG_QDOC) +/
    /+ template <class Clock, class Duration> +/
    /+ QDeadlineTimer(std::chrono::time_point<Clock, Duration> deadline_,
                   Qt::TimerType type_ = Qt::CoarseTimer) : t2(0)
    { setDeadline(deadline_, type_); } +/
    /+ template <class Clock, class Duration> +/
    /+ QDeadlineTimer &operator=(std::chrono::time_point<Clock, Duration> deadline_)
    { setDeadline(deadline_); return *this; } +/

    /+ template <class Clock, class Duration> +/
    /+ void setDeadline(std::chrono::time_point<Clock, Duration> deadline_,
                     Qt::TimerType type_ = Qt::CoarseTimer)
    { setRemainingTime(deadline_ == deadline_.max() ? Duration::max() : deadline_ - Clock::now(), type_); } +/

    /+ template <class Clock, class Duration = typename Clock::duration> +/
    /+ std::chrono::time_point<Clock, Duration> deadline() const
    {
        auto val = std::chrono::nanoseconds(rawRemainingTimeNSecs()) + Clock::now();
        return std::chrono::time_point_cast<Duration>(val);
    } +/

    /+ template <class Rep, class Period> +/
    /+ QDeadlineTimer(std::chrono::duration<Rep, Period> remaining, Qt::TimerType type_ = Qt::CoarseTimer)
        : t2(0)
    { setRemainingTime(remaining, type_); } +/

    /+ template <class Rep, class Period> +/
    /+ QDeadlineTimer &operator=(std::chrono::duration<Rep, Period> remaining)
    { setRemainingTime(remaining); return *this; } +/

    /+ template <class Rep, class Period> +/
    /+ void setRemainingTime(std::chrono::duration<Rep, Period> remaining, Qt::TimerType type_ = Qt::CoarseTimer)
    {
        if (remaining == remaining.max())
            *this = QDeadlineTimer(Forever, type_);
        else
            setPreciseRemainingTime(0, std::chrono::nanoseconds(remaining).count(), type_);
    } +/

    /+ std::chrono::nanoseconds remainingTimeAsDuration() const noexcept
    {
        if (isForever())
            return std::chrono::nanoseconds::max();
        qint64 nsecs = rawRemainingTimeNSecs();
        if (nsecs <= 0)
            return std::chrono::nanoseconds::zero();
        return std::chrono::nanoseconds(nsecs);
    } +/

    /+ template <class Rep, class Period> +/
    /+ friend QDeadlineTimer operator+(QDeadlineTimer dt, std::chrono::duration<Rep, Period> value)
    { return QDeadlineTimer::addNSecs(dt, std::chrono::duration_cast<std::chrono::nanoseconds>(value).count()); } +/
    /+ template <class Rep, class Period> +/
    /+ friend QDeadlineTimer operator+(std::chrono::duration<Rep, Period> value, QDeadlineTimer dt)
    { return dt + value; } +/
    /+ template <class Rep, class Period> +/
    /+ friend QDeadlineTimer operator+=(QDeadlineTimer &dt, std::chrono::duration<Rep, Period> value)
    { return dt = dt + value; } +/
/+ #endif +/

private:
    qint64 t1;
    uint t2;
    uint type;

    qint64 rawRemainingTimeNSecs() const nothrow;

public:
    // This is not a public function, it's here only for Qt's internal convenience...
    QPair!(qint64, uint) _q_data() const { return qMakePair(t1, t2); }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QDeadlineTimer)


Q_DECLARE_METATYPE(QDeadlineTimer) +/

