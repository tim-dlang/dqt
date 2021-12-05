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
module qt.gui.guiapplication;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.coreapplication;
import qt.core.coreevent;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.string;
import qt.gui.font;
import qt.gui.icon;
import qt.gui.inputmethod;
import qt.gui.palette;
import qt.gui.screen;
import qt.gui.stylehints;
import qt.gui.windowdefs;
import qt.helpers;
version(QT_NO_CLIPBOARD){}else
    import qt.gui.clipboard;
version(QT_NO_CURSOR){}else
    import qt.gui.cursor;

extern(C++, class) struct QSessionManager;
extern(C++, class) struct QGuiApplicationPrivate;
extern(C++, class) struct QPlatformNativeInterface;
extern(C++, class) struct QPlatformIntegration;
/+ class QPalette;
class QScreen;
class QStyleHints;

#if defined(qApp)
#undef qApp
#endif
#define qApp (static_cast<QGuiApplication *>(QCoreApplication::instance()))

#if defined(qGuiApp)
#undef qGuiApp
#endif
#define qGuiApp (static_cast<QGuiApplication *>(QCoreApplication::instance())) +/

class /+ Q_GUI_EXPORT +/ QGuiApplication : QCoreApplication
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QIcon windowIcon READ windowIcon WRITE setWindowIcon)
    Q_PROPERTY(QString applicationDisplayName READ applicationDisplayName WRITE setApplicationDisplayName NOTIFY applicationDisplayNameChanged)
    Q_PROPERTY(QString desktopFileName READ desktopFileName WRITE setDesktopFileName)
    Q_PROPERTY(Qt::LayoutDirection layoutDirection READ layoutDirection WRITE setLayoutDirection NOTIFY layoutDirectionChanged)
    Q_PROPERTY(QString platformName READ platformName STORED false)
    Q_PROPERTY(bool quitOnLastWindowClosed  READ quitOnLastWindowClosed WRITE setQuitOnLastWindowClosed)
    Q_PROPERTY(QScreen *primaryScreen READ primaryScreen NOTIFY primaryScreenChanged STORED false) +/

public:
/+ #ifdef Q_QDOC
    QGuiApplication(int &argc, char **argv);
#else +/
    this(ref int argc, char** argv, int = ApplicationFlags);
/+ #endif +/
    ~this();

    static void setApplicationDisplayName(ref const(QString) name);
    static QString applicationDisplayName();

    static void setDesktopFileName(ref const(QString) name);
    static QString desktopFileName();

    static QWindowList allWindows();
    static QWindowList topLevelWindows();
    static QWindow* topLevelAt(ref const(QPoint) pos);

    static void setWindowIcon(ref const(QIcon) icon);
    static QIcon windowIcon();

    static QString platformName();

    static QWindow* modalWindow();

    static QWindow* focusWindow();
    static QObject focusObject();

    static QScreen primaryScreen();
    static QList!(QScreen) screens();
    static QScreen screenAt(ref const(QPoint) point);

    final qreal devicePixelRatio() const;

    version(QT_NO_CURSOR){}else
    {
        static QCursor* overrideCursor();
        static void setOverrideCursor(ref const(QCursor) );
        static void changeOverrideCursor(ref const(QCursor) );
        static void restoreOverrideCursor();
    }

    static QFont font();
    static void setFont(ref const(QFont) );

    version(QT_NO_CLIPBOARD){}else
    {
        static QClipboard clipboard();
    }

    static QPalette palette();
    static void setPalette(ref const(QPalette) pal);

    static /+ Qt:: +/qt.core.namespace.KeyboardModifiers keyboardModifiers();
    static /+ Qt:: +/qt.core.namespace.KeyboardModifiers queryKeyboardModifiers();
    static /+ Qt:: +/qt.core.namespace.MouseButtons mouseButtons();

    static void setLayoutDirection(/+ Qt:: +/qt.core.namespace.LayoutDirection direction);
    static /+ Qt:: +/qt.core.namespace.LayoutDirection layoutDirection();

    pragma(inline, true) static bool isRightToLeft() { return layoutDirection() == /+ Qt:: +/qt.core.namespace.LayoutDirection.RightToLeft; }
    pragma(inline, true) static bool isLeftToRight() { return layoutDirection() == /+ Qt:: +/qt.core.namespace.LayoutDirection.LeftToRight; }

    static QStyleHints styleHints();
    static void setDesktopSettingsAware(bool on);
    static bool desktopSettingsAware();

    static QInputMethod inputMethod();

    static QPlatformNativeInterface* platformNativeInterface();

    static QFunctionPointer platformFunction(ref const(QByteArray) function_);

    static void setQuitOnLastWindowClosed(bool quit);
    static bool quitOnLastWindowClosed();

    static /+ Qt:: +/qt.core.namespace.ApplicationState applicationState();

    static void setHighDpiScaleFactorRoundingPolicy(/+ Qt:: +/qt.core.namespace.HighDpiScaleFactorRoundingPolicy policy);
    static /+ Qt:: +/qt.core.namespace.HighDpiScaleFactorRoundingPolicy highDpiScaleFactorRoundingPolicy();

    static int exec();
    override bool notify(QObject , QEvent );

    version(QT_NO_SESSIONMANAGER){}else
    {
        // session management
        final bool isSessionRestored() const;
        final QString sessionId() const;
        final QString sessionKey() const;
        final bool isSavingSession() const;

        static bool isFallbackSessionManagementEnabled();
        static void setFallbackSessionManagementEnabled(bool);
    }

    static void sync();
/+ Q_SIGNALS +/public:
    @QSignal final void fontDatabaseChanged();
    @QSignal final void screenAdded(QScreen screen);
    @QSignal final void screenRemoved(QScreen screen);
    @QSignal final void primaryScreenChanged(QScreen screen);
    @QSignal final void lastWindowClosed();
    @QSignal final void focusObjectChanged(QObject focusObject);
    @QSignal final void focusWindowChanged(QWindow* focusWindow);
    @QSignal final void applicationStateChanged(/+ Qt:: +/qt.core.namespace.ApplicationState state);
    @QSignal final void layoutDirectionChanged(/+ Qt:: +/qt.core.namespace.LayoutDirection direction);
    version(QT_NO_SESSIONMANAGER){}else
    {
        @QSignal final void commitDataRequest(ref QSessionManager sessionManager);
        @QSignal final void saveStateRequest(ref QSessionManager sessionManager);
    }
    @QSignal final void paletteChanged(ref const(QPalette) pal);
    @QSignal final void applicationDisplayNameChanged();
    @QSignal final void fontChanged(ref const(QFont) font);

protected:
    override bool event(QEvent );
    override bool compressEvent(QEvent , QObject receiver, QPostEventList* );

    this(ref QGuiApplicationPrivate p);

private:
    /+ Q_DISABLE_COPY(QGuiApplication) +/
    /+ Q_DECLARE_PRIVATE(QGuiApplication) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_updateFocusObject(QObject *object)) +/

    version(QT_NO_GESTURES){}else
    {
        /+ friend class QGestureManager; +/
    }
    /+ friend class QFontDatabasePrivate; +/
    /+ friend class QPlatformIntegration; +/
    version(QT_NO_SESSIONMANAGER){}else
    {
        /+ friend class QPlatformSessionManager; +/
    }
}

