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
module qt.widgets.mainwindow;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.list;
import qt.core.namespace;
import qt.core.point;
import qt.core.size;
import qt.core.string;
import qt.helpers;
import qt.widgets.dockwidget;
import qt.widgets.menu;
import qt.widgets.menubar;
import qt.widgets.statusbar;
import qt.widgets.tabwidget;
import qt.widgets.toolbar;
import qt.widgets.widget;
version(QT_NO_CONTEXTMENU){}else
    import qt.gui.event;

/+ #if QT_CONFIG(tabwidget)
#endif

QT_REQUIRE_CONFIG(mainwindow);


class QDockWidget; +/
extern(C++, class) struct QMainWindowPrivate;
/+ class QMenuBar;
class QStatusBar;
class QToolBar;
class QMenu; +/

class /+ Q_WIDGETS_EXPORT +/ QMainWindow : QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QSize iconSize READ iconSize WRITE setIconSize)
    Q_PROPERTY(Qt::ToolButtonStyle toolButtonStyle READ toolButtonStyle WRITE setToolButtonStyle)
#if QT_CONFIG(dockwidget)
    Q_PROPERTY(bool animated READ isAnimated WRITE setAnimated)
#if QT_CONFIG(tabbar)
    Q_PROPERTY(bool documentMode READ documentMode WRITE setDocumentMode)
#endif // QT_CONFIG(tabbar)
#if QT_CONFIG(tabwidget)
    Q_PROPERTY(QTabWidget::TabShape tabShape READ tabShape WRITE setTabShape)
#endif // QT_CONFIG(tabwidget)
    Q_PROPERTY(bool dockNestingEnabled READ isDockNestingEnabled WRITE setDockNestingEnabled)
#endif // QT_CONFIG(dockwidget)
    Q_PROPERTY(DockOptions dockOptions READ dockOptions WRITE setDockOptions)
#if QT_CONFIG(toolbar)
    Q_PROPERTY(bool unifiedTitleAndToolBarOnMac READ unifiedTitleAndToolBarOnMac WRITE setUnifiedTitleAndToolBarOnMac)
#endif +/

public:
    enum DockOption {
        AnimatedDocks = 0x01,
        AllowNestedDocks = 0x02,
        AllowTabbedDocks = 0x04,
        ForceTabbedDocks = 0x08,  // implies AllowTabbedDocks, !AllowNestedDocks
        VerticalTabs = 0x10,      // implies AllowTabbedDocks
        GroupedDragging = 0x20    // implies AllowTabbedDocks
    }
    /+ Q_ENUM(DockOption) +/
    /+ Q_DECLARE_FLAGS(DockOptions, DockOption) +/
alias DockOptions = QFlags!(DockOption);    /+ Q_FLAG(DockOptions) +/

    /+ explicit +/this(QWidget parent = null, /+ Qt:: +/qt.core.namespace.WindowFlags flags = /+ Qt:: +/qt.core.namespace.WindowFlags());
    ~this();

    final QSize iconSize() const;
    final void setIconSize(ref const(QSize) iconSize);

    final /+ Qt:: +/qt.core.namespace.ToolButtonStyle toolButtonStyle() const;
    final void setToolButtonStyle(/+ Qt:: +/qt.core.namespace.ToolButtonStyle toolButtonStyle);

/+ #if QT_CONFIG(dockwidget) +/
    final bool isAnimated() const;
    final bool isDockNestingEnabled() const;
/+ #endif

#if QT_CONFIG(tabbar) +/
    final bool documentMode() const;
    final void setDocumentMode(bool enabled);
/+ #endif

#if QT_CONFIG(tabwidget) +/
    final QTabWidget.TabShape tabShape() const;
    final void setTabShape(QTabWidget.TabShape tabShape);
    final QTabWidget.TabPosition tabPosition(/+ Qt:: +/qt.core.namespace.DockWidgetArea area) const;
    final void setTabPosition(/+ Qt:: +/qt.core.namespace.DockWidgetAreas areas, QTabWidget.TabPosition tabPosition);
/+ #endif +/ // QT_CONFIG(tabwidget)

    final void setDockOptions(DockOptions options);
    final DockOptions dockOptions() const;

    final bool isSeparator(ref const(QPoint) pos) const;

/+ #if QT_CONFIG(menubar) +/
    final QMenuBar menuBar() const;
    final void setMenuBar(QMenuBar menubar);

    final QWidget  menuWidget() const;
    final void setMenuWidget(QWidget menubar);
/+ #endif

#if QT_CONFIG(statusbar) +/
    final QStatusBar statusBar() const;
    final void setStatusBar(QStatusBar statusbar);
/+ #endif +/

    final QWidget centralWidget() const;
    final void setCentralWidget(QWidget widget);

    final QWidget takeCentralWidget();

/+ #if QT_CONFIG(dockwidget) +/
    final void setCorner(/+ Qt:: +/qt.core.namespace.Corner corner, /+ Qt:: +/qt.core.namespace.DockWidgetArea area);
    final /+ Qt:: +/qt.core.namespace.DockWidgetArea corner(/+ Qt:: +/qt.core.namespace.Corner corner) const;
/+ #endif

#if QT_CONFIG(toolbar) +/
    final void addToolBarBreak(/+ Qt:: +/qt.core.namespace.ToolBarArea area = /+ Qt:: +/qt.core.namespace.ToolBarArea.TopToolBarArea);
    final void insertToolBarBreak(QToolBar before);

    final void addToolBar(/+ Qt:: +/qt.core.namespace.ToolBarArea area, QToolBar toolbar);
    final void addToolBar(QToolBar toolbar);
    final QToolBar addToolBar(ref const(QString) title);
    final void insertToolBar(QToolBar before, QToolBar toolbar);
    final void removeToolBar(QToolBar toolbar);
    final void removeToolBarBreak(QToolBar before);

    final bool unifiedTitleAndToolBarOnMac() const;

    final /+ Qt:: +/qt.core.namespace.ToolBarArea toolBarArea(
    /+ #if QT_VERSION >= QT_VERSION_CHECK(6,0,0)
            const
    #endif +/
            QToolBar toolbar) const;
    final bool toolBarBreak(QToolBar toolbar) const;
/+ #endif
#if QT_CONFIG(dockwidget) +/
    final void addDockWidget(/+ Qt:: +/qt.core.namespace.DockWidgetArea area, QDockWidget dockwidget);
    final void addDockWidget(/+ Qt:: +/qt.core.namespace.DockWidgetArea area, QDockWidget dockwidget,
                           /+ Qt:: +/qt.core.namespace.Orientation orientation);
    final void splitDockWidget(QDockWidget after, QDockWidget dockwidget,
                             /+ Qt:: +/qt.core.namespace.Orientation orientation);
/+ #if QT_CONFIG(tabbar) +/
    final void tabifyDockWidget(QDockWidget first, QDockWidget second);
    final QList!(QDockWidget) tabifiedDockWidgets(QDockWidget dockwidget) const;
/+ #endif +/
    final void removeDockWidget(QDockWidget dockwidget);
    final bool restoreDockWidget(QDockWidget dockwidget);

    final /+ Qt:: +/qt.core.namespace.DockWidgetArea dockWidgetArea(QDockWidget dockwidget) const;

    final void resizeDocks(ref const(QList!(QDockWidget)) docks,
                         ref const(QList!(int)) sizes, /+ Qt:: +/qt.core.namespace.Orientation orientation);
/+ #endif +/ // QT_CONFIG(dockwidget)

    final QByteArray saveState(int version_ = 0) const;
    final bool restoreState(ref const(QByteArray) state, int version_ = 0);

/+ #if QT_CONFIG(menu) +/
    /+ virtual +/ QMenu createPopupMenu();
/+ #endif +/

public /+ Q_SLOTS +/:
/+ #if QT_CONFIG(dockwidget) +/
    @QSlot final void setAnimated(bool enabled);
    @QSlot final void setDockNestingEnabled(bool enabled);
/+ #endif
#if QT_CONFIG(toolbar) +/
    @QSlot final void setUnifiedTitleAndToolBarOnMac(bool set);
/+ #endif +/

/+ Q_SIGNALS +/public:
    @QSignal final void iconSizeChanged(ref const(QSize) iconSize);
    @QSignal final void toolButtonStyleChanged(/+ Qt:: +/qt.core.namespace.ToolButtonStyle toolButtonStyle);
/+ #if QT_CONFIG(dockwidget) +/
    @QSignal final void tabifiedDockWidgetActivated(QDockWidget dockWidget);
/+ #endif +/

protected:
    version(QT_NO_CONTEXTMENU){}else
    {
        override void contextMenuEvent(QContextMenuEvent event);
    }
    override bool event(QEvent event);

private:
    /+ Q_DECLARE_PRIVATE(QMainWindow) +/
    /+ Q_DISABLE_COPY(QMainWindow) +/
}
/+pragma(inline, true) QFlags!(QMainWindow.DockOptions.enum_type) operator |(QMainWindow.DockOptions.enum_type f1, QMainWindow.DockOptions.enum_type f2)/+noexcept+/{return QFlags!(QMainWindow.DockOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QMainWindow.DockOptions.enum_type) operator |(QMainWindow.DockOptions.enum_type f1, QFlags!(QMainWindow.DockOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QMainWindow.DockOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QMainWindow::DockOptions) +/
