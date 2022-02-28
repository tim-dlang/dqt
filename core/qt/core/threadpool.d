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
module qt.core.threadpool;
extern(C++):

import qt.config;
import qt.core.object;
import qt.core.runnable;
import qt.core.thread;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(thread); +/


extern(C++, class) struct QThreadPoolPrivate;
/// Binding for C++ class [QThreadPool](https://doc.qt.io/qt-6/qthreadpool.html).
class /+ Q_CORE_EXPORT +/ QThreadPool : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QThreadPool) +/
    /+ Q_PROPERTY(int expiryTimeout READ expiryTimeout WRITE setExpiryTimeout)
    Q_PROPERTY(int maxThreadCount READ maxThreadCount WRITE setMaxThreadCount)
    Q_PROPERTY(int activeThreadCount READ activeThreadCount)
    Q_PROPERTY(uint stackSize READ stackSize WRITE setStackSize)
    Q_PROPERTY(QThread::Priority threadPriority READ threadPriority WRITE setThreadPriority) +/
    /+ friend class QFutureInterfaceBase; +/

public:
    this(QObject parent = null);
    ~this();

    static QThreadPool globalInstance();

    final void start(QRunnable runnable, int priority = 0);
    final bool tryStart(QRunnable runnable);

    /+ void start(std::function<void()> functionToRun, int priority = 0); +/
    /+ bool tryStart(std::function<void()> functionToRun); +/

    final int expiryTimeout() const;
    final void setExpiryTimeout(int expiryTimeout);

    final int maxThreadCount() const;
    final void setMaxThreadCount(int maxThreadCount);

    final int activeThreadCount() const;

    final void setStackSize(uint stackSize);
    final uint stackSize() const;

    final void setThreadPriority(QThread.Priority priority);
    final QThread.Priority threadPriority() const;

    final void reserveThread();
    final void releaseThread();

    final bool waitForDone(int msecs = -1);

    final void clear();

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final bool contains(const(QThread) thread) const;
    }));

    /+ [[nodiscard]] +/ final bool tryTake(QRunnable runnable);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

