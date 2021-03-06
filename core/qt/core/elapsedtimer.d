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
module qt.core.elapsedtimer;
extern(C++):

import qt.config;
import qt.core.global;
import qt.helpers;

/// Binding for C++ class [QElapsedTimer](https://doc.qt.io/qt-5/qelapsedtimer.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QElapsedTimer
{
public:
    enum ClockType {
        SystemTime,
        MonotonicClock,
        TickCounter,
        MachAbsoluteTime,
        PerformanceCounter
    }

    @disable this();
    /+this()
    {
        this.t1 = 0x8000000000000000L;
        this.t2 = 0x8000000000000000L;
    }+/

    static ClockType clockType()/+ noexcept+/;
    static bool isMonotonic()/+ noexcept+/;

    void start()/+ noexcept+/;
    qint64 restart()/+ noexcept+/;
    void invalidate()/+ noexcept+/;
    bool isValid() const/+ noexcept+/;

    qint64 nsecsElapsed() const/+ noexcept+/;
    qint64 elapsed() const/+ noexcept+/;
    bool hasExpired(qint64 timeout) const/+ noexcept+/;

    qint64 msecsSinceReference() const/+ noexcept+/;
    qint64 msecsTo(ref const(QElapsedTimer) other) const/+ noexcept+/;
    qint64 secsTo(ref const(QElapsedTimer) other) const/+ noexcept+/;

    /+bool operator ==(ref const(QElapsedTimer) other) const/+ noexcept+/
    { return t1 == other.t1 && t2 == other.t2; }+/
    /+bool operator !=(ref const(QElapsedTimer) other) const/+ noexcept+/
    { return !(this == other); }+/

    /+ friend bool Q_CORE_EXPORT operator<(const QElapsedTimer &v1, const QElapsedTimer &v2) noexcept; +/

private:
    qint64 t1 = 0x8000000000000000L;
    qint64 t2 = 0x8000000000000000L;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

