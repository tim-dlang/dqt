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
module qt.widgets.pushbutton;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.point;
import qt.core.size;
import qt.core.string;
import qt.gui.event;
import qt.gui.icon;
import qt.helpers;
import qt.widgets.abstractbutton;
import qt.widgets.menu;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(pushbutton); +/



extern(C++, class) struct QPushButtonPrivate;
/+ class QMenu;
class QStyleOptionButton; +/

/// Binding for C++ class [QPushButton](https://doc.qt.io/qt-5/qpushbutton.html).
class /+ Q_WIDGETS_EXPORT +/ QPushButton : QAbstractButton
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(bool autoDefault READ autoDefault WRITE setAutoDefault)
    Q_PROPERTY(bool default READ isDefault WRITE setDefault)
    Q_PROPERTY(bool flat READ isFlat WRITE setFlat) +/

public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QString) text, QWidget parent = null);
    this(ref const(QIcon) icon, ref const(QString) text, QWidget parent = null);
    ~this();

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;

    final bool autoDefault() const;
    final void setAutoDefault(bool);
    final bool isDefault() const;
    final void setDefault(bool);

/+ #if QT_CONFIG(menu) +/
    final void setMenu(QMenu menu);
    final QMenu menu() const;
/+ #endif +/

    final void setFlat(bool);
    final bool isFlat() const;

public /+ Q_SLOTS +/:
/+ #if QT_CONFIG(menu) +/
    @QSlot final void showMenu();
/+ #endif +/

protected:
    override bool event(QEvent e);
    override void paintEvent(QPaintEvent );
    override void keyPressEvent(QKeyEvent );
    override void focusInEvent(QFocusEvent );
    override void focusOutEvent(QFocusEvent );
    final void initStyleOption(QStyleOptionButton* option) const;
    override bool hitButton(ref const(QPoint) pos) const;
    this(ref QPushButtonPrivate dd, QWidget parent = null);

public:

private:
    /+ Q_DISABLE_COPY(QPushButton) +/
    /+ Q_DECLARE_PRIVATE(QPushButton) +/
/+ #if QT_CONFIG(menu)
    Q_PRIVATE_SLOT(d_func(), void _q_popupPressed())
#endif +/
}

