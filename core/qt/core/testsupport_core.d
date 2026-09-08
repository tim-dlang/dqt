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
module qt.core.testsupport_core;
extern(C++):

import qt.config;
import qt.helpers;

extern(C++, "QTest") {

/+ Q_CORE_EXPORT +/ void qSleep(int ms);

/+ [[nodiscard]] +/ bool qWaitFor(Functor)(Functor predicate, int timeout = 5000)
{
    import qt.core.coreapplication;
    import qt.core.coreevent;
    import qt.core.deadlinetimer;
    import qt.core.eventloop;
    import qt.core.global;
    import qt.core.namespace;
    import qt.core.object;

    // We should not spin the event loop in case the predicate is already true,
    // otherwise we might send new events that invalidate the predicate.
    if (predicate())
        return true;

    // qWait() is expected to spin the event loop, even when called with a small
    // timeout like 1ms, so we we can't use a simple while-loop here based on
    // the deadline timer not having timed out. Use do-while instead.

    int remaining = timeout;
    auto deadline = QDeadlineTimer(remaining, /+ Qt:: +/qt.core.namespace.TimerType.PreciseTimer);

    do {
        // We explicitly do not pass the remaining time to processEvents, as
        // that would keep spinning processEvents for the whole duration if
        // new events were posted as part of processing events, and we need
        // to return back to this function to check the predicate between
        // each pass of processEvents. Our own timer will take care of the
        // timeout.
        QCoreApplication.processEvents(QEventLoop.ProcessEventsFlag.AllEvents);
        QCoreApplication.sendPostedEvents(null, QEvent.Type.DeferredDelete);

        if (predicate())
            return true;

        remaining = cast(int) (deadline.remainingTime());
        if (remaining > 0)
            qSleep(qMin(10, remaining));
        remaining = cast(int) (deadline.remainingTime());
    } while (remaining > 0);

    return predicate(); // Last chance
}

/+ Q_CORE_EXPORT +/ void qWait(int ms);

} // namespace QTest

