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
module qt.widgets.commandlinkbutton;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.size;
import qt.core.string;
import qt.gui.event;
import qt.helpers;
import qt.widgets.pushbutton;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(commandlinkbutton); +/



extern(C++, class) struct QCommandLinkButtonPrivate;

/// Binding for C++ class [QCommandLinkButton](https://doc.qt.io/qt-6/qcommandlinkbutton.html).
class /+ Q_WIDGETS_EXPORT +/ QCommandLinkButton: QPushButton
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QString description READ description WRITE setDescription)
    Q_PROPERTY(bool flat READ isFlat WRITE setFlat DESIGNABLE false) +/

public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QString) text, QWidget parent = null);
    /+ explicit +/this(ref const(QString) text, ref const(QString) description, QWidget parent = null);
    ~this();

    final QString description() const;
    final void setDescription(ref const(QString) description);

    override QSize sizeHint() const;
    override int heightForWidth(int) const;
    override QSize minimumSizeHint() const;
    override void initStyleOption(QStyleOptionButton* option) const;

protected:
    override bool event(QEvent e);
    override void paintEvent(QPaintEvent );

private:
    /+ Q_DISABLE_COPY(QCommandLinkButton) +/
    /+ Q_DECLARE_PRIVATE(QCommandLinkButton) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

