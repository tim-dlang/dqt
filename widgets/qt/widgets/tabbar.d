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
module qt.widgets.tabbar;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.variant;
import qt.gui.color;
import qt.gui.event;
import qt.gui.icon;
import qt.helpers;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(tabbar); +/


extern(C++, class) struct QTabBarPrivate;

/// Binding for C++ class [QTabBar](https://doc.qt.io/qt-5/qtabbar.html).
class /+ Q_WIDGETS_EXPORT +/ QTabBar: QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(Shape shape READ shape WRITE setShape)
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentChanged)
    Q_PROPERTY(int count READ count)
    Q_PROPERTY(bool drawBase READ drawBase WRITE setDrawBase)
    Q_PROPERTY(QSize iconSize READ iconSize WRITE setIconSize)
    Q_PROPERTY(Qt::TextElideMode elideMode READ elideMode WRITE setElideMode)
    Q_PROPERTY(bool usesScrollButtons READ usesScrollButtons WRITE setUsesScrollButtons)
    Q_PROPERTY(bool tabsClosable READ tabsClosable WRITE setTabsClosable)
    Q_PROPERTY(SelectionBehavior selectionBehaviorOnRemove READ selectionBehaviorOnRemove WRITE setSelectionBehaviorOnRemove)
    Q_PROPERTY(bool expanding READ expanding WRITE setExpanding)
    Q_PROPERTY(bool movable READ isMovable WRITE setMovable)
    Q_PROPERTY(bool documentMode READ documentMode WRITE setDocumentMode)
    Q_PROPERTY(bool autoHide READ autoHide WRITE setAutoHide)
    Q_PROPERTY(bool changeCurrentOnDrag READ changeCurrentOnDrag WRITE setChangeCurrentOnDrag) +/

public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    enum Shape { RoundedNorth, RoundedSouth, RoundedWest, RoundedEast,
                 TriangularNorth, TriangularSouth, TriangularWest, TriangularEast
    }
    /+ Q_ENUM(Shape) +/

    enum ButtonPosition {
        LeftSide,
        RightSide
    }

    enum SelectionBehavior {
        SelectLeftTab,
        SelectRightTab,
        SelectPreviousTab
    }

    final Shape shape() const;
    final void setShape(Shape shape);

    final int addTab(ref const(QString) text);
    final int addTab(ref const(QIcon) icon, ref const(QString) text);

    final int insertTab(int index, ref const(QString) text);
    final int insertTab(int index, ref const(QIcon) icon, ref const(QString) text);

    final void removeTab(int index);
    final void moveTab(int from, int to);

    final bool isTabEnabled(int index) const;
    final void setTabEnabled(int index, bool enabled);

    final bool isTabVisible(int index) const;
    final void setTabVisible(int index, bool visible);

    final QString tabText(int index) const;
    final void setTabText(int index, ref const(QString) text);

    final QColor tabTextColor(int index) const;
    final void setTabTextColor(int index, ref const(QColor) color);

    final QIcon tabIcon(int index) const;
    final void setTabIcon(int index, ref const(QIcon) icon);

    final /+ Qt:: +/qt.core.namespace.TextElideMode elideMode() const;
    final void setElideMode(/+ Qt:: +/qt.core.namespace.TextElideMode mode);

/+ #ifndef QT_NO_TOOLTIP +/
    version(QT_NO_TOOLTIP){}else
    {
        final void setTabToolTip(int index, ref const(QString) tip);
        final QString tabToolTip(int index) const;
    }
/+ #endif

#if QT_CONFIG(whatsthis) +/
    final void setTabWhatsThis(int index, ref const(QString) text);
    final QString tabWhatsThis(int index) const;
/+ #endif +/

    final void setTabData(int index, ref const(QVariant) data);
    final QVariant tabData(int index) const;

    final QRect tabRect(int index) const;
    final int tabAt(ref const(QPoint) pos) const;

    final int currentIndex() const;
    final int count() const;

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;

    final void setDrawBase(bool drawTheBase);
    final bool drawBase() const;

    final QSize iconSize() const;
    final void setIconSize(ref const(QSize) size);

    final bool usesScrollButtons() const;
    final void setUsesScrollButtons(bool useButtons);

    final bool tabsClosable() const;
    final void setTabsClosable(bool closable);

    final void setTabButton(int index, ButtonPosition position, QWidget widget);
    final QWidget tabButton(int index, ButtonPosition position) const;

    final SelectionBehavior selectionBehaviorOnRemove() const;
    final void setSelectionBehaviorOnRemove(SelectionBehavior behavior);

    final bool expanding() const;
    final void setExpanding(bool enabled);

    final bool isMovable() const;
    final void setMovable(bool movable);

    final bool documentMode() const;
    final void setDocumentMode(bool set);

    final bool autoHide() const;
    final void setAutoHide(bool hide);

    final bool changeCurrentOnDrag() const;
    final void setChangeCurrentOnDrag(bool change);

    version(QT_NO_ACCESSIBILITY){}else
    {
        final QString accessibleTabName(int index) const;
        final void setAccessibleTabName(int index, ref const(QString) name);
    }

public /+ Q_SLOTS +/:
    @QSlot final void setCurrentIndex(int index);

/+ Q_SIGNALS +/public:
    @QSignal final void currentChanged(int index);
    @QSignal final void tabCloseRequested(int index);
    @QSignal final void tabMoved(int from, int to);
    @QSignal final void tabBarClicked(int index);
    @QSignal final void tabBarDoubleClicked(int index);

protected:
    /+ virtual +/ QSize tabSizeHint(int index) const;
    /+ virtual +/ QSize minimumTabSizeHint(int index) const;
    /+ virtual +/ void tabInserted(int index);
    /+ virtual +/ void tabRemoved(int index);
    /+ virtual +/ void tabLayoutChange();

    override bool event(QEvent );
    override void resizeEvent(QResizeEvent );
    override void showEvent(QShowEvent );
    override void hideEvent(QHideEvent );
    override void paintEvent(QPaintEvent );
    override void mousePressEvent (QMouseEvent );
    override void mouseMoveEvent (QMouseEvent );
    override void mouseReleaseEvent (QMouseEvent );
/+ #if QT_CONFIG(wheelevent) +/
    override void wheelEvent(QWheelEvent event);
/+ #endif +/
    override void keyPressEvent(QKeyEvent );
    override void changeEvent(QEvent );
    override void timerEvent(QTimerEvent event);
    final void initStyleOption(QStyleOptionTab* option, int tabIndex) const;

    version(QT_NO_ACCESSIBILITY){}else
    {
        /+ friend class QAccessibleTabBar; +/
    }
private:
    /+ Q_DISABLE_COPY(QTabBar) +/
    /+ Q_DECLARE_PRIVATE(QTabBar) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_scrollTabs())
    Q_PRIVATE_SLOT(d_func(), void _q_closeTab()) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

