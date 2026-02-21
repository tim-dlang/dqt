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

/// Binding for C++ class [QElapsedTimer](https://doc.qt.io/qt-6/qelapsedtimer.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QElapsedTimer
{
public:
    enum ClockType {
        SystemTime,
        MonotonicClock,
        TickCounter /+ Q_DECL_ENUMERATOR_DEPRECATED_X(
                "Not supported anymore. Use PerformanceCounter instead.") +/,
        MachAbsoluteTime,
        PerformanceCounter
    }

    @disable this();
    /+this()
    {
        this.t1 = 0x8000000000000000L;
        this.t2 = 0x8000000000000000L;
    }+/

    static ClockType clockType() nothrow;
    static bool isMonotonic() nothrow;

    void start() nothrow;
    qint64 restart() nothrow;
    void invalidate() nothrow;
    bool isValid() const nothrow;

    qint64 nsecsElapsed() const nothrow;
    qint64 elapsed() const nothrow;
    bool hasExpired(qint64 timeout) const nothrow;

    qint64 msecsSinceReference() const nothrow;
    qint64 msecsTo(ref const(QElapsedTimer) other) const nothrow;
    qint64 secsTo(ref const(QElapsedTimer) other) const nothrow;

    /+ friend bool operator==(const QElapsedTimer &lhs, const QElapsedTimer &rhs) noexcept
    { return lhs.t1 == rhs.t1 && lhs.t2 == rhs.t2; } +/
    /+ friend bool operator!=(const QElapsedTimer &lhs, const QElapsedTimer &rhs) noexcept
    { return !(lhs == rhs); } +/

    /+ friend bool Q_CORE_EXPORT operator<(const QElapsedTimer &lhs, const QElapsedTimer &rhs) noexcept; +/

private:
    qint64 t1 = 0x8000000000000000L;
    qint64 t2 = 0x8000000000000000L;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

