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
module qt.widgets.systemtrayicon;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.object;
import qt.core.rect;
import qt.core.string;
import qt.gui.icon;
import qt.helpers;
import qt.widgets.menu;

/+ QT_REQUIRE_CONFIG(systemtrayicon); +/


extern(C++, class) struct QSystemTrayIconPrivate;

/// Binding for C++ class [QSystemTrayIcon](https://doc.qt.io/qt-6/qsystemtrayicon.html).
class /+ Q_WIDGETS_EXPORT +/ QSystemTrayIcon : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QString toolTip READ toolTip WRITE setToolTip)
    Q_PROPERTY(QIcon icon READ icon WRITE setIcon)
    Q_PROPERTY(bool visible READ isVisible WRITE setVisible DESIGNABLE false) +/
    /+ Q_DECLARE_PRIVATE(QSystemTrayIcon) +/

public:
    enum ActivationReason {
        Unknown,
        Context,
        DoubleClick,
        Trigger,
        MiddleClick
    }
    /+ Q_ENUM(ActivationReason) +/

    enum MessageIcon {
        NoIcon,
        Information,
        Warning,
        Critical
    }
    /+ Q_ENUM(MessageIcon) +/

    /+ explicit +/this(QObject parent = null);
    this(ref const(QIcon) icon, QObject parent = null);
    ~this();

    version (QT_NO_MENU) {} else
    {
        final void setContextMenu(QMenu menu);
        final QMenu contextMenu() const;
    }

    final QIcon icon() const;
    final void setIcon(ref const(QIcon) icon);

    final QString toolTip() const;
    final void setToolTip(ref const(QString) tip);

    static bool isSystemTrayAvailable();
    static bool supportsMessages();

    final QRect geometry() const;
    final bool isVisible() const;

public /+ Q_SLOTS +/:
    @QSlot final void setVisible(bool visible);
    pragma(inline, true) final void show() { setVisible(true); }
    pragma(inline, true) final void hide() { setVisible(false); }
    @QSlot final void showMessage(ref const(QString) title, ref const(QString) msg,
            ref const(QIcon) icon, int msecs = 10000);
    @QSlot final void showMessage(ref const(QString) title, ref const(QString) msg,
            MessageIcon icon = MessageIcon.Information, int msecs = 10000);

/+ Q_SIGNALS +/public:
    @QSignal final void activated(ActivationReason reason);
    @QSignal final void messageClicked();

protected:
    override bool event(QEvent event);

private:
    /+ Q_DISABLE_COPY(QSystemTrayIcon) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_emitActivated(QPlatformSystemTrayIcon::ActivationReason)) +/
    /+ friend class QSystemTrayIconSys; +/
    /+ friend class QBalloonTip; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
