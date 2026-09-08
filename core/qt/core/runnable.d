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
module qt.core.runnable;
extern(C++):

import qt.config;
import qt.helpers;

/// Binding for C++ class [QRunnable](https://doc.qt.io/qt-5/qrunnable.html).
abstract class /+ Q_CORE_EXPORT +/ QRunnable
{
private:
    int ref_ = 0; // Qt6: Make this a bool, or make autoDelete() virtual.

    /+ friend class QThreadPool; +/
    /+ friend class QThreadPoolPrivate; +/
    /+ friend class QThreadPoolThread; +/
/+ #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    Q_DISABLE_COPY(QRunnable)
#endif +/
public:
    /+ virtual +/ abstract void run();

    this()
    {
        this.ref_ = 0;
    }
    /+ virtual +/~this();
    /+ static QRunnable *create(std::function<void()> functionToRun); +/

    final bool autoDelete() const { return ref_ != -1; }
    final void setAutoDelete(bool _autoDelete) { ref_ = _autoDelete ? 0 : -1; }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

