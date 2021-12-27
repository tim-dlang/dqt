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
module qt.widgets.desktopwidget;
extern(C++):

import qt.config;
import qt.core.point;
import qt.core.rect;
import qt.gui.event;
import qt.helpers;
import qt.widgets.widget;

extern(C++, class) struct QDesktopWidgetPrivate;

/// Binding for C++ class [QDesktopWidget](https://doc.qt.io/qt-5/qdesktopwidget.html).
class /+ Q_WIDGETS_EXPORT +/ QDesktopWidget : QWidget
{
    mixin(Q_OBJECT);
/+ #if QT_DEPRECATED_SINCE(5, 11)
    Q_PROPERTY(bool virtualDesktop READ isVirtualDesktop)
    Q_PROPERTY(int screenCount READ screenCount NOTIFY screenCountChanged)
    Q_PROPERTY(int primaryScreen READ primaryScreen NOTIFY primaryScreenChanged)
#endif +/
public:
    this();
    ~this();

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final int screenNumber(const(QWidget) widget = null) const;
    }));
    mixin(mangleWindows("?screenGeometry@QDesktopWidget@@QEBA?BVQRect@@PEBVQWidget@@@Z", q{
    final const(QRect) screenGeometry(const(QWidget) widget) const;
    }));
    mixin(mangleWindows("?availableGeometry@QDesktopWidget@@QEBA?BVQRect@@PEBVQWidget@@@Z", q{
    final const(QRect) availableGeometry(const(QWidget) widget) const;
    }));

/+ #if QT_DEPRECATED_SINCE(5, 11) +/
    /+ QT_DEPRECATED_X("Use QScreen::virtualSiblings() of primary screen") +/  final bool isVirtualDesktop() const;

    /+ QT_DEPRECATED_X("Use QGuiApplication::screens()") +/ final int numScreens() const;
    /+ QT_DEPRECATED_X("Use QGuiApplication::screens()") +/ pragma(inline, true) final int screenCount() const
    {
    /+ QT_WARNING_PUSH
    QT_WARNING_DISABLE_DEPRECATED +/
        return numScreens();
    /+ QT_WARNING_POP +/
    }
    /+ QT_DEPRECATED_X("Use QGuiApplication::primaryScreen()") +/ final int primaryScreen() const;

    /+ QT_DEPRECATED_X("Use QGuiApplication::screenAt()") +/ final int screenNumber(ref const(QPoint) ) const;

    /+ QT_DEPRECATED_X("Use QScreen") +/ final QWidget screen(int screen = -1);

    mixin(mangleWindows("?screenGeometry@QDesktopWidget@@QEBA?BVQRect@@H@Z", q{
    /+ QT_DEPRECATED_X("Use QGuiApplication::screens()") +/ final const(QRect) screenGeometry(int screen = -1) const;
    }));
    /+ QT_DEPRECATED_X("Use QGuiApplication::screenAt()") +/ final const(QRect) screenGeometry(ref const(QPoint) point) const
    {
/+ QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED +/
        return screenGeometry(screenNumber(point));
/+ QT_WARNING_POP +/
    }

    mixin(mangleWindows("?availableGeometry@QDesktopWidget@@QEBA?BVQRect@@H@Z", q{
    /+ QT_DEPRECATED_X("Use QGuiApplication::screens()") +/ final const(QRect) availableGeometry(int screen = -1) const;
    }));
    /+ QT_DEPRECATED_X("Use QGuiApplication::screenAt()") +/ final const(QRect) availableGeometry(ref const(QPoint) point) const
    {
/+ QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED +/
    return availableGeometry(screenNumber(point));
/+ QT_WARNING_POP +/
    }

/+ Q_SIGNALS +/public:
    /+ QT_DEPRECATED_X("Use QScreen::geometryChanged()") +/ @QSignal final void resized(int);
    /+ QT_DEPRECATED_X("Use QScreen::availableGeometryChanged()") +/ @QSignal final void workAreaResized(int);
    /+ QT_DEPRECATED_X("Use QGuiApplication::screenAdded/Removed()") +/ @QSignal final void screenCountChanged(int);
    /+ QT_DEPRECATED_X("Use QGuiApplication::primaryScreenChanged()") +/ @QSignal final void primaryScreenChanged();
/+ #endif +/

protected:
    override void resizeEvent(QResizeEvent e);

private:
    /+ Q_DISABLE_COPY(QDesktopWidget) +/
    /+ Q_DECLARE_PRIVATE(QDesktopWidget) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_updateScreens())
    Q_PRIVATE_SLOT(d_func(), void _q_availableGeometryChanged()) +/

    /+ friend class QApplication; +/
    /+ friend class QApplicationPrivate; +/
}

/+ #if QT_DEPRECATED_SINCE(5, 11)
#endif +/

