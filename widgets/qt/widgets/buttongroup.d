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
module qt.widgets.buttongroup;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.object;
import qt.helpers;
import qt.widgets.abstractbutton;

/+ QT_REQUIRE_CONFIG(buttongroup);


class QAbstractButton;
class QAbstractButtonPrivate; +/
extern(C++, class) struct QButtonGroupPrivate;

class /+ Q_WIDGETS_EXPORT +/ QButtonGroup : QObject
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(bool exclusive READ exclusive WRITE setExclusive) +/
public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    final void setExclusive(bool);
    final bool exclusive() const;

    final void addButton(QAbstractButton , int id = -1);
    final void removeButton(QAbstractButton );

    final QList!(QAbstractButton) buttons() const;

    final QAbstractButton  checkedButton() const;
    // no setter on purpose!

    final QAbstractButton button(int id) const;
    final void setId(QAbstractButton button, int id);
    final int id(QAbstractButton button) const;
    final int checkedId() const;

/+ Q_SIGNALS +/public:
    @QSignal final void buttonClicked(QAbstractButton );
    @QSignal final void buttonPressed(QAbstractButton );
    @QSignal final void buttonReleased(QAbstractButton );
    @QSignal final void buttonToggled(QAbstractButton , bool);
    @QSignal final void idClicked(int);
    @QSignal final void idPressed(int);
    @QSignal final void idReleased(int);
    @QSignal final void idToggled(int, bool);
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+ QT_DEPRECATED_VERSION_X_5_15("Use QButtonGroup::idClicked(int) instead") +/
        @QSignal final void buttonClicked(int);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use QButtonGroup::idPressed(int) instead") +/
        @QSignal final void buttonPressed(int);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use QButtonGroup::idReleased(int) instead") +/
        @QSignal final void buttonReleased(int);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use QButtonGroup::idToggled(int, bool) instead") +/
        @QSignal final void buttonToggled(int, bool);
/+ #endif +/

private:
    /+ Q_DISABLE_COPY(QButtonGroup) +/
    /+ Q_DECLARE_PRIVATE(QButtonGroup) +/
    /+ friend class QAbstractButton; +/
    /+ friend class QAbstractButtonPrivate; +/
}

