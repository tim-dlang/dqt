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
module qt.widgets.application;
extern(C++):

import qt.config;
import qt.core.coreapplication;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.size;
import qt.core.string;
import qt.gui.font;
import qt.gui.fontmetrics;
import qt.gui.guiapplication;
import qt.gui.icon;
import qt.gui.palette;
import qt.helpers;
import qt.widgets.desktopwidget;
import qt.widgets.style;
import qt.widgets.widget;

/+ #ifdef QT_INCLUDE_COMPAT
#endif


class QDesktopWidget;
class QStyle;
class QEventLoop;
class QIcon;
template <typename T> class QList;
class QLocale;
class QPlatformNativeInterface;

class QApplication; +/
extern(C++, class) struct QApplicationPrivate;
/+ #if defined(qApp)
#undef qApp
#endif +/
/+ #define qApp (static_cast<QApplication *>(QCoreApplication::instance())) +/
enum qApp = q{(static_cast!(QApplication)(QCoreApplication.instance()))};

class /+ Q_WIDGETS_EXPORT +/ QApplication : QGuiApplication
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QIcon windowIcon READ windowIcon WRITE setWindowIcon)
    Q_PROPERTY(int cursorFlashTime READ cursorFlashTime WRITE setCursorFlashTime)
    Q_PROPERTY(int doubleClickInterval  READ doubleClickInterval WRITE setDoubleClickInterval)
    Q_PROPERTY(int keyboardInputInterval READ keyboardInputInterval WRITE setKeyboardInputInterval)
#if QT_CONFIG(wheelevent)
    Q_PROPERTY(int wheelScrollLines  READ wheelScrollLines WRITE setWheelScrollLines)
#endif
#if QT_DEPRECATED_SINCE(5, 15)
    Q_PROPERTY(QSize globalStrut READ globalStrut WRITE setGlobalStrut)
#endif
    Q_PROPERTY(int startDragTime  READ startDragTime WRITE setStartDragTime)
    Q_PROPERTY(int startDragDistance  READ startDragDistance WRITE setStartDragDistance)
#ifndef QT_NO_STYLE_STYLESHEET
    Q_PROPERTY(QString styleSheet READ styleSheet WRITE setStyleSheet)
#endif
    Q_PROPERTY(bool autoSipEnabled READ autoSipEnabled WRITE setAutoSipEnabled) +/

public:
/+ #ifdef Q_QDOC
    QApplication(int &argc, char **argv);
#else +/
    this(ref int argc, char** argv, int = ApplicationFlags);
/+ #endif +/
    /+ virtual +/~this();

    static QStyle style();
    static void setStyle(QStyle);
    static QStyle setStyle(ref const(QString));
    enum ColorSpec { NormalColor=0, CustomColor=1, ManyColor=2 }
/+ #if QT_DEPRECATED_SINCE(5, 8) +/
    /+ QT_DEPRECATED +/ static int colorSpec();
    /+ QT_DEPRECATED +/ static void setColorSpec(int);
/+ #endif // QT_DEPRECATED_SINCE(5, 8)
#if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED static inline void setGraphicsSystem(const QString &) {}
#endif +/

    /+ using QGuiApplication::palette; +/
    static QPalette palette(const(QWidget) );
    static QPalette palette(const(char)* className);
    static void setPalette(ref const(QPalette) , const(char)* className = null);
    static QFont font();
    static QFont font(const(QWidget));
    static QFont font(const(char)* className);
    static void setFont(ref const(QFont) , const(char)* className = null);
    static QFontMetrics fontMetrics();

/+ #if QT_VERSION < 0x060000 +/ // remove these forwarders in Qt 6
    static void setWindowIcon(ref const(QIcon) icon);
    static QIcon windowIcon();
/+ #endif +/

    static QWidgetList allWidgets();
    static QWidgetList topLevelWidgets();

    static QDesktopWidget desktop();

    static QWidget activePopupWidget();
    static QWidget activeModalWidget();
    static QWidget focusWidget();

    static QWidget activeWindow();
    static void setActiveWindow(QWidget act);

    static QWidget widgetAt(ref const(QPoint) p);
    pragma(inline, true) static QWidget widgetAt(int x, int y) { auto tmp = QPoint(x, y); return widgetAt(tmp); }
    static QWidget topLevelAt(ref const(QPoint) p);
    pragma(inline, true) static QWidget topLevelAt(int x, int y)  { auto tmp = QPoint(x, y); return topLevelAt(tmp); }

/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED static inline void syncX() {}
#endif +/
    static void beep();
    static void alert(QWidget widget, int duration = 0);

    static void setCursorFlashTime(int);
    static int cursorFlashTime();

    static void setDoubleClickInterval(int);
    static int doubleClickInterval();

    static void setKeyboardInputInterval(int);
    static int keyboardInputInterval();

/+ #if QT_CONFIG(wheelevent) +/
    static void setWheelScrollLines(int);
    static int wheelScrollLines();
/+ #endif
#if QT_DEPRECATED_SINCE(5, 15) +/
    static void setGlobalStrut(ref const(QSize) );
    static QSize globalStrut();
/+ #endif +/

    static void setStartDragTime(int ms);
    static int startDragTime();
    static void setStartDragDistance(int l);
    static int startDragDistance();

    static bool isEffectEnabled(/+ Qt:: +/qt.core.namespace.UIEffect);
    static void setEffectEnabled(/+ Qt:: +/qt.core.namespace.UIEffect, bool enable = true);

/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED static QLocale keyboardInputLocale()
    { return qApp ? QGuiApplication::inputMethod()->locale() : QLocale::c(); }
    QT_DEPRECATED static Qt::LayoutDirection keyboardInputDirection()
    { return qApp ? QGuiApplication::inputMethod()->inputDirection() : Qt::LeftToRight; }
#endif +/

    static int exec();
    override bool notify(QObject , QEvent );

/+ #ifdef QT_KEYPAD_NAVIGATION
# if QT_DEPRECATED_SINCE(5, 13) +/
    version(QT_KEYPAD_NAVIGATION)
    {
        /+ QT_DEPRECATED_X ("Use QApplication::setNavigationMode() instead") +/
            static void setKeypadNavigationEnabled(bool);
        /+ QT_DEPRECATED_X ("Use QApplication::navigationMode() instead") +/
            static bool keypadNavigationEnabled();
    /+ # endif +/
        static void setNavigationMode(/+ Qt:: +/qt.core.namespace.NavigationMode mode);
        static /+ Qt:: +/qt.core.namespace.NavigationMode navigationMode();
    }
/+ #endif +/

/+ Q_SIGNALS +/public:
    @QSignal final void focusChanged(QWidget old, QWidget now);

public:
    final QString styleSheet() const;
public /+ Q_SLOTS +/:
    version(QT_NO_STYLE_STYLESHEET){}else
    {
        @QSlot final void setStyleSheet(ref const(QString) sheet);
    }
    @QSlot final void setAutoSipEnabled(const(bool) enabled);
    @QSlot final bool autoSipEnabled() const;
    @QSlot static void closeAllWindows();
    @QSlot static void aboutQt();

protected:
    override bool event(QEvent );
    override bool compressEvent(QEvent , QObject receiver, QPostEventList* );

private:
    /+ Q_DISABLE_COPY(QApplication) +/
    /+ Q_DECLARE_PRIVATE(QApplication) +/

    /+ friend class QGraphicsWidget; +/
    /+ friend class QGraphicsItem; +/
    /+ friend class QGraphicsScene; +/
    /+ friend class QGraphicsScenePrivate; +/
    /+ friend class QWidget; +/
    /+ friend class QWidgetPrivate; +/
    /+ friend class QWidgetWindow; +/
    /+ friend class QTranslator; +/
    /+ friend class QWidgetAnimator; +/
    version(QT_NO_SHORTCUT){}else
    {
        /+ friend class QShortcut; +/
        /+ friend class QLineEdit; +/
        /+ friend class QWidgetTextControl; +/
    }
    /+ friend class QAction; +/

    version(QT_NO_GESTURES){}else
    {
        /+ friend class QGestureManager; +/
    }
}

