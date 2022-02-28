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

/// Binding for C++ class [QRunnable](https://doc.qt.io/qt-6/qrunnable.html).
abstract class /+ Q_CORE_EXPORT +/ QRunnable
{
private:
    bool m_autoDelete = true;

    /+ Q_DISABLE_COPY(QRunnable) +/
public:
    /+ virtual +/ abstract void run();

    /+ constexpr QRunnable() noexcept = default; +/
    /+ virtual +/~this();
    /+ static QRunnable *create(std::function<void()> functionToRun); +/

    final bool autoDelete() const { return m_autoDelete; }
    final void setAutoDelete(bool autoDelete) { m_autoDelete = autoDelete; }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

