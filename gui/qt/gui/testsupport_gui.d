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
import qt.core.list;
import qt.core.namespace;
import qt.gui.eventpoint;
import qt.gui.inputdevice;
import qt.gui.pointingdevice;
import qt.gui.window;
import qt.helpers;


mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
/+ Q_GUI_EXPORT +/ void qt_handleTouchEvent(QWindow w, const(QPointingDevice) device,
                                ref const(QList!(QEventPoint)) points,
                                /+ Qt:: +/qt.core.namespace.KeyboardModifiers mods = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier);
}));

mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
/+ Q_GUI_EXPORT +/ bool qt_handleTouchEventv2(QWindow w, const(QPointingDevice) device,
                                ref const(QList!(QEventPoint)) points,
                                /+ Qt:: +/qt.core.namespace.KeyboardModifiers mods = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier);
}));

extern(C++, "QTest") {

/+ [[nodiscard]] +/ /+ Q_GUI_EXPORT +/ bool qWaitForWindowActive(QWindow window, int timeout = 5000);
/+ [[nodiscard]] +/ /+ Q_GUI_EXPORT +/ bool qWaitForWindowExposed(QWindow window, int timeout = 5000);

/+ Q_GUI_EXPORT +/ QPointingDevice  createTouchDevice(QInputDevice.DeviceType devType = QInputDevice.DeviceType.TouchScreen,
                                                 QInputDevice.Capabilities caps = QInputDevice.Capability.Position);

/+ class Q_GUI_EXPORT QTouchEventSequence
{
public:
    virtual ~QTouchEventSequence();
    QTouchEventSequence& press(int touchId, const QPoint &pt, QWindow *window = nullptr);
    QTouchEventSequence& move(int touchId, const QPoint &pt, QWindow *window = nullptr);
    QTouchEventSequence& release(int touchId, const QPoint &pt, QWindow *window = nullptr);
    virtual QTouchEventSequence& stationary(int touchId);

    virtual bool commit(bool processEvents = true);

protected:
    QTouchEventSequence(QWindow *window, QPointingDevice *aDevice, bool autoCommit);

    QPoint mapToScreen(QWindow *window, const QPoint &pt);

    QEventPoint &point(int touchId);

    QEventPoint &pointOrPreviousPoint(int touchId);

    QMap<int, QEventPoint> previousPoints;
    QMap<int, QEventPoint> points;
    QWindow *targetWindow;
    QPointingDevice *device;
    bool commitWhenDestroyed;
    friend QTouchEventSequence touchEvent(QWindow *window, QPointingDevice *device, bool autoCommit);
}; +/

} // namespace QTest

