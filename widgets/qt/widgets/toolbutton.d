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
module qt.widgets.toolbutton;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.point;
import qt.core.size;
import qt.gui.event;
import qt.helpers;
import qt.widgets.abstractbutton;
import qt.widgets.action;
import qt.widgets.menu;
import qt.widgets.styleoption;
import qt.widgets.widget;
version(QT_NO_ACTION){}else
    import qt.widgets.event;

/+ QT_REQUIRE_CONFIG(toolbutton); +/


extern(C++, class) struct QToolButtonPrivate;
/+ class QMenu;
class QStyleOptionToolButton; +/

class /+ Q_WIDGETS_EXPORT +/ QToolButton : QAbstractButton
{
    mixin(Q_OBJECT);
    /+ Q_ENUMS(Qt::ToolButtonStyle Qt::ArrowType)
#if QT_CONFIG(menu)
    Q_PROPERTY(ToolButtonPopupMode popupMode READ popupMode WRITE setPopupMode)
#endif
    Q_PROPERTY(Qt::ToolButtonStyle toolButtonStyle READ toolButtonStyle WRITE setToolButtonStyle)
    Q_PROPERTY(bool autoRaise READ autoRaise WRITE setAutoRaise)
    Q_PROPERTY(Qt::ArrowType arrowType READ arrowType WRITE setArrowType) +/

public:
    enum ToolButtonPopupMode {
        DelayedPopup,
        MenuButtonPopup,
        InstantPopup
    }
    /+ Q_ENUM(ToolButtonPopupMode) +/

    /+ explicit +/this(QWidget parent = null);
    ~this();

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;

    final /+ Qt:: +/qt.core.namespace.ToolButtonStyle toolButtonStyle() const;

    final /+ Qt:: +/qt.core.namespace.ArrowType arrowType() const;
    final void setArrowType(/+ Qt:: +/qt.core.namespace.ArrowType type);

/+ #if QT_CONFIG(menu) +/
    final void setMenu(QMenu menu);
    final QMenu menu() const;

    final void setPopupMode(ToolButtonPopupMode mode);
    final ToolButtonPopupMode popupMode() const;
/+ #endif +/

    final QAction defaultAction() const;

    final void setAutoRaise(bool enable);
    final bool autoRaise() const;

public /+ Q_SLOTS +/:
/+ #if QT_CONFIG(menu) +/
    @QSlot final void showMenu();
/+ #endif +/
    @QSlot final void setToolButtonStyle(/+ Qt:: +/qt.core.namespace.ToolButtonStyle style);
    @QSlot final void setDefaultAction(QAction );

/+ Q_SIGNALS +/public:
    @QSignal final void triggered(QAction );

protected:
    override bool event(QEvent e);
    override void mousePressEvent(QMouseEvent );
    override void mouseReleaseEvent(QMouseEvent );
    override void paintEvent(QPaintEvent );
    override void actionEvent(QActionEvent );

    override void enterEvent(QEvent );
    override void leaveEvent(QEvent );
    override void timerEvent(QTimerEvent );
    override void changeEvent(QEvent );

    override bool hitButton(ref const(QPoint) pos) const;
    override void nextCheckState();
    final void initStyleOption(QStyleOptionToolButton* option) const;

private:
    /+ Q_DISABLE_COPY(QToolButton) +/
    /+ Q_DECLARE_PRIVATE(QToolButton) +/
/+ #if QT_CONFIG(menu)
    Q_PRIVATE_SLOT(d_func(), void _q_buttonPressed())
    Q_PRIVATE_SLOT(d_func(), void _q_buttonReleased())
    Q_PRIVATE_SLOT(d_func(), void _q_updateButtonDown())
    Q_PRIVATE_SLOT(d_func(), void _q_menuTriggered(QAction*))
#endif
    Q_PRIVATE_SLOT(d_func(), void _q_actionTriggered()) +/

}

