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
module qt.gui.testsupport_gui;
extern(C++):

import qt.config;
import qt.gui.window;
import qt.helpers;


extern(C++, "QTest") {
/+ Q_GUI_EXPORT +/ /+ Q_REQUIRED_RESULT +/ bool qWaitForWindowActive(QWindow window, int timeout = 5000);
/+ Q_GUI_EXPORT +/ /+ Q_REQUIRED_RESULT +/ bool qWaitForWindowExposed(QWindow window, int timeout = 5000);
}

