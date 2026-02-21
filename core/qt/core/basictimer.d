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
module qt.core.basictimer;
extern(C++):

import qt.config;
import qt.core.namespace;
import qt.core.object;
import qt.core.typeinfo;
import qt.helpers;


/// Binding for C++ class [QBasicTimer](https://doc.qt.io/qt-6/qbasictimer.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QBasicTimer
{
private:
    int id;
    /+ Q_DISABLE_COPY(QBasicTimer) +/
@disable this(this);
/+@disable this(ref const(QBasicTimer));+/@disable ref QBasicTimer opAssign(ref const(QBasicTimer));
public:
    @disable this();
    /+this() nothrow
    {
        this.id = {0};
    }+/
    pragma(inline, true) ~this() { if (id) stop(); }

    /+ QBasicTimer(QBasicTimer &&other) noexcept
        : id{qExchange(other.id, 0)}
    {} +/

    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QBasicTimer) +/

    /+ void swap(QBasicTimer &other) noexcept { std::swap(id, other.id); } +/

    bool isActive() const nothrow { return id != 0; }
    int timerId() const nothrow { return id; }

    void start(int msec, QObject obj);
    void start(int msec, /+ Qt:: +/qt.core.namespace.TimerType timerType, QObject obj);
    void stop();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QBasicTimer, Q_RELOCATABLE_TYPE);

inline void swap(QBasicTimer &lhs, QBasicTimer &rhs) noexcept { lhs.swap(rhs); } +/

