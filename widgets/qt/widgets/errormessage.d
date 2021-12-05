/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.widgets.errormessage;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.string;
import qt.helpers;
import qt.widgets.dialog;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(errormessage); +/


extern(C++, class) struct QErrorMessagePrivate;

class /+ Q_WIDGETS_EXPORT +/ QErrorMessage: QDialog
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QErrorMessage) +/
public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    static QErrorMessage  qtHandler();

public /+ Q_SLOTS +/:
    @QSlot final void showMessage(ref const(QString) message);
    @QSlot final void showMessage(ref const(QString) message, ref const(QString) type);

protected:
    override void done(int);
    override void changeEvent(QEvent e);

private:
    /+ Q_DISABLE_COPY(QErrorMessage) +/
}

