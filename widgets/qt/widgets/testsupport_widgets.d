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

/+ [[nodiscard]] +/ /+ Q_WIDGETS_EXPORT +/ bool qWaitForWindowActive(QWidget widget, int timeout = 5000);
/+ [[nodiscard]] +/ /+ Q_WIDGETS_EXPORT +/ bool qWaitForWindowExposed(QWidget widget, int timeout = 5000);

/+ class Q_WIDGETS_EXPORT QTouchEventWidgetSequence : public QTouchEventSequence
{
public:
    ~QTouchEventWidgetSequence() override;
    QTouchEventWidgetSequence& press(int touchId, const QPoint &pt, QWidget *widget = nullptr);
    QTouchEventWidgetSequence& move(int touchId, const QPoint &pt, QWidget *widget = nullptr);
    QTouchEventWidgetSequence& release(int touchId, const QPoint &pt, QWidget *widget = nullptr);
    QTouchEventWidgetSequence& stationary(int touchId) override;

    bool commit(bool processEvents = true) override;

private:
    QTouchEventWidgetSequence(QWidget *widget, QPointingDevice *aDevice, bool autoCommit);

    QPoint mapToScreen(QWidget *widget, const QPoint &pt);

    QWidget *targetWidget = nullptr;

    friend QTouchEventWidgetSequence touchEvent(QWidget *widget, QPointingDevice *device, bool autoCommit);
}; +/

} // namespace QTest

