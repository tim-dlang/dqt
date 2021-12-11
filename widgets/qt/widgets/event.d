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
module qt.widgets.event;
extern(C++):

import qt.config;
import qt.helpers;
version(QT_NO_ACTION){}else
{
    import qt.core.coreevent;
    import qt.widgets.action;
}

version(QT_NO_ACTION){}else
{
/// Binding for C++ class [QActionEvent](https://doc.qt.io/qt-5/qactionevent.html).
class /+ Q_GUI_EXPORT +/ QActionEvent : QEvent
{
private:
    QAction act; QAction bef;
public:
    this(int type, QAction action, QAction before = null);
    ~this();

    pragma(inline, true) final QAction action() const { return cast(QAction)act; }
    pragma(inline, true) final QAction before() const { return cast(QAction)bef; }
}
}

version(QT_NO_ACTION)
{
class QActionEvent;
}


