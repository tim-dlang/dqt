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

/+ class QObject; +/

@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QBasicTimer
{
private:
    int id;
/+ #if QT_VERSION >= QT_VERSION_CHECK(6,0,0)
    Q_DISABLE_COPY(QBasicTimer)
#elif QT_DEPRECATED_SINCE(5, 14) +/
public:
    // Just here to preserve BC, we can't remove them yet
    @disable this(this);
    /+ QT_DEPRECATED_X("copy-construction is unsupported; use move-construction instead") +/this(ref const(QBasicTimer) );
    /+/+ QT_DEPRECATED_X("copy-assignment is unsupported; use move-assignment instead") +/
        ref QBasicTimer operator =(ref const(QBasicTimer) );+/
/+ #endif +/

public:
    @disable this();
    /+/+ constexpr +/this()/+ noexcept+/
    {
        this.id = {0};
    }+/
    pragma(inline, true) ~this() { if (id) stop(); }

    /+ QBasicTimer(QBasicTimer &&other) noexcept
        : id{qExchange(other.id, 0)}
    {} +/

    /+ QBasicTimer& operator=(QBasicTimer &&other) noexcept
    {
        QBasicTimer{std::move(other)}.swap(*this);
        return *this;
    } +/

    /+ void swap(QBasicTimer &other) noexcept { qSwap(id, other.id); } +/

    bool isActive() const/+ noexcept+/ { return id != 0; }
    int timerId() const/+ noexcept+/ { return id; }

    void start(int msec, QObject obj);
    void start(int msec, /+ Qt:: +/qt.core.namespace.TimerType timerType, QObject obj);
    void stop();
}
/+ Q_DECLARE_TYPEINFO(QBasicTimer, Q_MOVABLE_TYPE);

inline void swap(QBasicTimer &lhs, QBasicTimer &rhs) noexcept { lhs.swap(rhs); } +/

