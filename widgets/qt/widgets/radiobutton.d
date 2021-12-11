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
module qt.widgets.radiobutton;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.point;
import qt.core.size;
import qt.core.string;
import qt.gui.event;
import qt.helpers;
import qt.widgets.abstractbutton;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(radiobutton); +/



extern(C++, class) struct QRadioButtonPrivate;
/+ class QStyleOptionButton; +/

/// Binding for C++ class [QRadioButton](https://doc.qt.io/qt-5/qradiobutton.html).
class /+ Q_WIDGETS_EXPORT +/ QRadioButton : QAbstractButton
{
    mixin(Q_OBJECT);

public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QString) text, QWidget parent = null);
    ~this();

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;

protected:
    override bool event(QEvent e);
    override bool hitButton(ref const(QPoint) ) const;
    override void paintEvent(QPaintEvent );
    override void mouseMoveEvent(QMouseEvent );
    final void initStyleOption(QStyleOptionButton* button) const;


private:
    /+ Q_DECLARE_PRIVATE(QRadioButton) +/
    /+ Q_DISABLE_COPY(QRadioButton) +/
    /+ friend class QAccessibleButton; +/
}

