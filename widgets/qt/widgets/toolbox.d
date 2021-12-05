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
module qt.widgets.toolbox;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.string;
import qt.gui.event;
import qt.gui.icon;
import qt.helpers;
import qt.widgets.frame;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(toolbox); +/


extern(C++, class) struct QToolBoxPrivate;

class /+ Q_WIDGETS_EXPORT +/ QToolBox : QFrame
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentChanged)
    Q_PROPERTY(int count READ count) +/

public:
    /+ explicit +/this(QWidget parent = null, /+ Qt:: +/qt.core.namespace.WindowFlags f = /+ Qt:: +/qt.core.namespace.WindowFlags());
    ~this();

    pragma(inline, true) final int addItem(QWidget item, ref const(QString) text)
    { auto tmp = QIcon(); return insertItem(-1, item, tmp, text); }
    pragma(inline, true) final int addItem(QWidget item, ref const(QIcon) iconSet, ref const(QString) text)
    { return insertItem(-1, item, iconSet, text); }
    pragma(inline, true) final int insertItem(int index, QWidget item, ref const(QString) text)
    { auto tmp = QIcon(); return insertItem(index, item, tmp, text); }
    final int insertItem(int index, QWidget widget, ref const(QIcon) icon, ref const(QString) text);

    final void removeItem(int index);

    final void setItemEnabled(int index, bool enabled);
    final bool isItemEnabled(int index) const;

    final void setItemText(int index, ref const(QString) text);
    final QString itemText(int index) const;

    final void setItemIcon(int index, ref const(QIcon) icon);
    final QIcon itemIcon(int index) const;

    version(QT_NO_TOOLTIP){}else
    {
        final void setItemToolTip(int index, ref const(QString) toolTip);
        final QString itemToolTip(int index) const;
    }

    final int currentIndex() const;
    final QWidget currentWidget() const;
    final QWidget widget(int index) const;
    final int indexOf(QWidget widget) const;
    final int count() const;

public /+ Q_SLOTS +/:
    @QSlot final void setCurrentIndex(int index);
    @QSlot final void setCurrentWidget(QWidget widget);

/+ Q_SIGNALS +/public:
    @QSignal final void currentChanged(int index);

protected:
    override bool event(QEvent e);
    /+ virtual +/ void itemInserted(int index);
    /+ virtual +/ void itemRemoved(int index);
    override void showEvent(QShowEvent e);
    override void changeEvent(QEvent );


private:
    /+ Q_DECLARE_PRIVATE(QToolBox) +/
    /+ Q_DISABLE_COPY(QToolBox) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_buttonClicked())
    Q_PRIVATE_SLOT(d_func(), void _q_widgetDestroyed(QObject*)) +/
}


