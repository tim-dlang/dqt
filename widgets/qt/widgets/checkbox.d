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
module qt.widgets.checkbox;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.point;
import qt.core.size;
import qt.core.string;
import qt.gui.event;
import qt.helpers;
import qt.widgets.abstractbutton;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(checkbox); +/



extern(C++, class) struct QCheckBoxPrivate;
/+ class QStyleOptionButton; +/

/// Binding for C++ class [QCheckBox](https://doc.qt.io/qt-5/qcheckbox.html).
class /+ Q_WIDGETS_EXPORT +/ QCheckBox : QAbstractButton
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(bool tristate READ isTristate WRITE setTristate) +/

public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QString) text, QWidget parent = null);
    ~this();

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;

    final void setTristate(bool y = true);
    final bool isTristate() const;

    final /+ Qt:: +/qt.core.namespace.CheckState checkState() const;
    final void setCheckState(/+ Qt:: +/qt.core.namespace.CheckState state);

/+ Q_SIGNALS +/public:
    @QSignal final void stateChanged(int);

protected:
    override bool event(QEvent e);
    override bool hitButton(ref const(QPoint) pos) const;
    override void checkStateSet();
    override void nextCheckState();
    override void paintEvent(QPaintEvent );
    override void mouseMoveEvent(QMouseEvent );
    final void initStyleOption(QStyleOptionButton* option) const;


private:
    /+ Q_DECLARE_PRIVATE(QCheckBox) +/
    /+ Q_DISABLE_COPY(QCheckBox) +/
    /+ friend class QAccessibleButton; +/
}

