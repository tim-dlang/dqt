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
module qt.widgets.tabwidget;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.size;
import qt.core.string;
import qt.gui.event;
import qt.gui.icon;
import qt.helpers;
import qt.widgets.styleoption;
import qt.widgets.tabbar;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(tabwidget);


class QTabBar; +/
extern(C++, class) struct QTabWidgetPrivate;
/+ class QStyleOptionTabWidgetFrame; +/

class /+ Q_WIDGETS_EXPORT +/ QTabWidget : QWidget
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(TabPosition tabPosition READ tabPosition WRITE setTabPosition)
    Q_PROPERTY(TabShape tabShape READ tabShape WRITE setTabShape)
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentChanged)
    Q_PROPERTY(int count READ count)
    Q_PROPERTY(QSize iconSize READ iconSize WRITE setIconSize)
    Q_PROPERTY(Qt::TextElideMode elideMode READ elideMode WRITE setElideMode)
    Q_PROPERTY(bool usesScrollButtons READ usesScrollButtons WRITE setUsesScrollButtons)
    Q_PROPERTY(bool documentMode READ documentMode WRITE setDocumentMode)
    Q_PROPERTY(bool tabsClosable READ tabsClosable WRITE setTabsClosable)
    Q_PROPERTY(bool movable READ isMovable WRITE setMovable)
    Q_PROPERTY(bool tabBarAutoHide READ tabBarAutoHide WRITE setTabBarAutoHide) +/

public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    final int addTab(QWidget widget, ref const(QString) );
    final int addTab(QWidget widget, const(QString) label)
    {
        return addTab(widget, label);
    }
    final int addTab(QWidget widget, ref const(QIcon) icon, ref const(QString) label);
    final int addTab(QWidget widget, const(QIcon) icon, const(QString) label)
    {
        return addTab(widget, icon, label);
    }

    final int insertTab(int index, QWidget widget, ref const(QString) );
    final int insertTab(int index, QWidget widget, ref const(QIcon) icon, ref const(QString) label);

    final void removeTab(int index);

    final bool isTabEnabled(int index) const;
    final void setTabEnabled(int index, bool enabled);

    final bool isTabVisible(int index) const;
    final void setTabVisible(int index, bool visible);

    final QString tabText(int index) const;
    final void setTabText(int index, ref const(QString) text);
    final void setTabText(int index, const(QString) text)
    {
        setTabText(index, text);
    }

    final QIcon tabIcon(int index) const;
    final void setTabIcon(int index, ref const(QIcon)  icon);

/+ #ifndef QT_NO_TOOLTIP +/
    version(QT_NO_TOOLTIP){}else
    {
        final void setTabToolTip(int index, ref const(QString)  tip);
        final QString tabToolTip(int index) const;
    }
/+ #endif

#if QT_CONFIG(whatsthis) +/
    final void setTabWhatsThis(int index, ref const(QString) text);
    final QString tabWhatsThis(int index) const;
/+ #endif +/

    final int currentIndex() const;
    final QWidget currentWidget() const;
    final QWidget widget(int index) const;
    final int indexOf(QWidget widget) const;
    final int count() const;

    enum TabPosition { North, South, West, East }
    /+ Q_ENUM(TabPosition) +/
    final TabPosition tabPosition() const;
    final void setTabPosition(TabPosition position);

    final bool tabsClosable() const;
    final void setTabsClosable(bool closeable);

    final bool isMovable() const;
    final void setMovable(bool movable);

    enum TabShape { Rounded, Triangular }
    /+ Q_ENUM(TabShape) +/
    final TabShape tabShape() const;
    final void setTabShape(TabShape s);

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;
    override int heightForWidth(int width) const;
    override bool hasHeightForWidth() const;

    final void setCornerWidget(QWidget  w, /+ Qt:: +/qt.core.namespace.Corner corner = /+ Qt:: +/qt.core.namespace.Corner.TopRightCorner);
    final QWidget  cornerWidget(/+ Qt:: +/qt.core.namespace.Corner corner = /+ Qt:: +/qt.core.namespace.Corner.TopRightCorner) const;

    final /+ Qt:: +/qt.core.namespace.TextElideMode elideMode() const;
    final void setElideMode(/+ Qt:: +/qt.core.namespace.TextElideMode mode);

    final QSize iconSize() const;
    final void setIconSize(ref const(QSize) size);

    final bool usesScrollButtons() const;
    final void setUsesScrollButtons(bool useButtons);

    final bool documentMode() const;
    final void setDocumentMode(bool set);

    final bool tabBarAutoHide() const;
    final void setTabBarAutoHide(bool enabled);

    final void clear();

    final QTabBar tabBar() const;

public /+ Q_SLOTS +/:
    @QSlot final void setCurrentIndex(int index);
    @QSlot final void setCurrentWidget(QWidget widget);

/+ Q_SIGNALS +/public:
    @QSignal final void currentChanged(int index);
    @QSignal final void tabCloseRequested(int index);
    @QSignal final void tabBarClicked(int index);
    @QSignal final void tabBarDoubleClicked(int index);

protected:
    /+ virtual +/ void tabInserted(int index);
    /+ virtual +/ void tabRemoved(int index);

    override void showEvent(QShowEvent );
    override void resizeEvent(QResizeEvent );
    override void keyPressEvent(QKeyEvent );
    override void paintEvent(QPaintEvent );
    final void setTabBar(QTabBar );
    override void changeEvent(QEvent );
    override bool event(QEvent );
    final void initStyleOption(QStyleOptionTabWidgetFrame* option) const;


private:
    /+ Q_DECLARE_PRIVATE(QTabWidget) +/
    /+ Q_DISABLE_COPY(QTabWidget) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_showTab(int))
    Q_PRIVATE_SLOT(d_func(), void _q_removeTab(int))
    Q_PRIVATE_SLOT(d_func(), void _q_tabMoved(int, int)) +/
    final void setUpLayout(bool /+ = false +/);
}

