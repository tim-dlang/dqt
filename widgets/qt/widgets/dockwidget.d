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
module qt.widgets.dockwidget;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.namespace;
import qt.core.string;
import qt.gui.event;
import qt.helpers;
import qt.widgets.styleoption;
import qt.widgets.widget;
version(QT_NO_ACTION){}else
    import qt.widgets.action;

/+ QT_REQUIRE_CONFIG(dockwidget); +/


extern(C++, class) struct QDockAreaLayout;
extern(C++, class) struct QDockWidgetPrivate;
/+ class QMainWindow;
class QStyleOptionDockWidget; +/

class /+ Q_WIDGETS_EXPORT +/ QDockWidget : QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(bool floating READ isFloating WRITE setFloating)
    Q_PROPERTY(DockWidgetFeatures features READ features WRITE setFeatures NOTIFY featuresChanged)
    Q_PROPERTY(Qt::DockWidgetAreas allowedAreas READ allowedAreas
               WRITE setAllowedAreas NOTIFY allowedAreasChanged)
    Q_PROPERTY(QString windowTitle READ windowTitle WRITE setWindowTitle DESIGNABLE true) +/

public:
    /+ explicit +/this(ref const(QString) title, QWidget parent = null,
                             /+ Qt:: +/qt.core.namespace.WindowFlags flags = /+ Qt:: +/qt.core.namespace.WindowFlags());
    /+ explicit +/this(QWidget parent = null, /+ Qt:: +/qt.core.namespace.WindowFlags flags = /+ Qt:: +/qt.core.namespace.WindowFlags());
    ~this();

    final QWidget widget() const;
    final void setWidget(QWidget widget);

    enum DockWidgetFeature {
        DockWidgetClosable    = 0x01,
        DockWidgetMovable     = 0x02,
        DockWidgetFloatable   = 0x04,
        DockWidgetVerticalTitleBar = 0x08,

        DockWidgetFeatureMask = 0x0f,
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
        AllDockWidgetFeatures /+ Q_DECL_ENUMERATOR_DEPRECATED +/ =
            DockWidgetFeature.DockWidgetClosable|DockWidgetFeature.DockWidgetMovable|DockWidgetFeature.DockWidgetFloatable, // ### Qt 6: remove
/+ #endif +/
        NoDockWidgetFeatures  = 0x00,

        Reserved              = 0xff
    }
    /+ Q_DECLARE_FLAGS(DockWidgetFeatures, DockWidgetFeature) +/
alias DockWidgetFeatures = QFlags!(DockWidgetFeature);    /+ Q_FLAG(DockWidgetFeatures) +/

    final void setFeatures(DockWidgetFeatures features);
    final DockWidgetFeatures features() const;

    final void setFloating(bool floating);
    pragma(inline, true) final bool isFloating() const { return isWindow(); }

    final void setAllowedAreas(/+ Qt:: +/qt.core.namespace.DockWidgetAreas areas);
    final /+ Qt:: +/qt.core.namespace.DockWidgetAreas allowedAreas() const;

    final void setTitleBarWidget(QWidget widget);
    final QWidget titleBarWidget() const;

    pragma(inline, true) final bool isAreaAllowed(/+ Qt:: +/qt.core.namespace.DockWidgetArea area) const
    { return (allowedAreas() & area) == qt.core.namespace.DockWidgetAreas(area); }

    version(QT_NO_ACTION){}else
    {
        final QAction toggleViewAction() const;
    }

/+ Q_SIGNALS +/public:
    @QSignal final void featuresChanged(QDockWidget.DockWidgetFeatures features);
    @QSignal final void topLevelChanged(bool topLevel);
    @QSignal final void allowedAreasChanged(/+ Qt:: +/qt.core.namespace.DockWidgetAreas allowedAreas);
    @QSignal final void visibilityChanged(bool visible);
    @QSignal final void dockLocationChanged(/+ Qt:: +/qt.core.namespace.DockWidgetArea area);

protected:
    override void changeEvent(QEvent event);
    override void closeEvent(QCloseEvent event);
    override void paintEvent(QPaintEvent event);
    override bool event(QEvent event);
//    final void initStyleOption(QStyleOptionDockWidget* option) const;

private:
    /+ Q_DECLARE_PRIVATE(QDockWidget) +/
    /+ Q_DISABLE_COPY(QDockWidget) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_toggleView(bool))
    Q_PRIVATE_SLOT(d_func(), void _q_toggleTopLevel()) +/
    /+ friend class QDockAreaLayout; +/
    /+ friend class QDockWidgetItem; +/
    /+ friend class QMainWindowLayout; +/
    /+ friend class QDockWidgetLayout; +/
    /+ friend class QDockAreaLayoutInfo; +/
}
/+pragma(inline, true) QFlags!(QDockWidget.DockWidgetFeatures.enum_type) operator |(QDockWidget.DockWidgetFeatures.enum_type f1, QDockWidget.DockWidgetFeatures.enum_type f2)/+noexcept+/{return QFlags!(QDockWidget.DockWidgetFeatures.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QDockWidget.DockWidgetFeatures.enum_type) operator |(QDockWidget.DockWidgetFeatures.enum_type f1, QFlags!(QDockWidget.DockWidgetFeatures.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QDockWidget.DockWidgetFeatures.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QDockWidget::DockWidgetFeatures) +/
