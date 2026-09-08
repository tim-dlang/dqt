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
module qt.widgets.testsupport_widgets;
extern(C++):

import qt.config;
import qt.helpers;
import qt.widgets.widget;


extern(C++, "QTest") {
/+ Q_WIDGETS_EXPORT +/ /+ Q_REQUIRED_RESULT +/ bool qWaitForWindowActive(QWidget widget, int timeout = 5000);
/+ Q_WIDGETS_EXPORT +/ /+ Q_REQUIRED_RESULT +/ bool qWaitForWindowExposed(QWidget widget, int timeout = 5000);

/+ #if QT_DEPRECATED_SINCE(5, 0)
QT_DEPRECATED Q_REQUIRED_RESULT inline static bool qWaitForWindowShown(QWidget *widget, int timeout = 5000)
{ return QTest::qWaitForWindowExposed(widget, timeout); }
#endif +/
}

