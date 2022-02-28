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
module qt.widgets.application;
extern(C++):

import qt.config;
import qt.core.coreapplication;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.nativeinterface;
import qt.core.object;
import qt.core.point;
import qt.core.string;
import qt.gui.font;
import qt.gui.fontmetrics;
import qt.gui.guiapplication;
import qt.gui.palette;
import qt.helpers;
import qt.widgets.style;
import qt.widgets.widget;


extern(C++, class) struct QApplicationPrivate;
/+ #if defined(qApp)
#undef qApp
#endif
#define qApp (static_cast<QApplication *>(QCoreApplication::instance())) +/

/// Binding for C++ class [QApplication](https://doc.qt.io/qt-6/qapplication.html).
class /+ Q_WIDGETS_EXPORT +/ QApplication : QGuiApplication
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(int cursorFlashTime READ cursorFlashTime WRITE setCursorFlashTime)
    Q_PROPERTY(int doubleClickInterval  READ doubleClickInterval WRITE setDoubleClickInterval)
    Q_PROPERTY(int keyboardInputInterval READ keyboardInputInterval WRITE setKeyboardInputInterval)
#if QT_CONFIG(wheelevent)
    Q_PROPERTY(int wheelScrollLines  READ wheelScrollLines WRITE setWheelScrollLines)
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

    /+ using QGuiApplication::palette; +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static QPalette palette(const(QWidget) );
    }));
    static QPalette palette(const(char)* className);
    static void setPalette(ref const(QPalette) , const(char)* className = null);
    static QFont font();
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static QFont font(const(QWidget));
    }));
    static QFont font(const(char)* className);
    static void setFont(ref const(QFont) , const(char)* className = null);

/+ #if QT_DEPRECATED_SINCE(6,0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use the QFontMetricsF constructor instead.") +/
        static QFontMetrics fontMetrics();
/+ #endif +/

    static QWidgetList allWidgets();
    static QWidgetList topLevelWidgets();

    static QWidget activePopupWidget();
    static QWidget activeModalWidget();
    static QWidget focusWidget();

    static QWidget activeWindow();
    static void setActiveWindow(QWidget act);

    static QWidget widgetAt(ref const(QPoint) p);
    pragma(inline, true) static QWidget widgetAt(int x, int y) { auto tmp = QPoint(x, y); return widgetAt(tmp); }
    static QWidget topLevelAt(ref const(QPoint) p);
    pragma(inline, true) static QWidget topLevelAt(int x, int y)  { auto tmp = QPoint(x, y); return topLevelAt(tmp); }

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
/+ #endif +/

    static void setStartDragTime(int ms);
    static int startDragTime();
    static void setStartDragDistance(int l);
    static int startDragDistance();

    static bool isEffectEnabled(/+ Qt:: +/qt.core.namespace.UIEffect);
    static void setEffectEnabled(/+ Qt:: +/qt.core.namespace.UIEffect, bool enable = true);

    static int exec();
    override bool notify(QObject , QEvent );

    version(QT_KEYPAD_NAVIGATION)
    {
        static void setNavigationMode(/+ Qt:: +/qt.core.namespace.NavigationMode mode);
        static /+ Qt:: +/qt.core.namespace.NavigationMode navigationMode();
    }

    mixin(QT_DECLARE_NATIVE_INTERFACE_ACCESSOR(q{ValueClass!(QApplication)}));

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
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

