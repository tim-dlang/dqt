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
module qt.test.testmouse;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.point;
import qt.gui.window;
import qt.helpers;
// import qt.widgets.widget;

/+ #if 0
// inform syncqt
#pragma qt_no_master_include
#endif

#ifdef QT_WIDGETS_LIB
#endif +/


/+ Q_GUI_EXPORT +/ void qt_handleMouseEvent(QWindow window, ref const(QPointF) local, ref const(QPointF) global,
                                      /+ Qt:: +/qt.core.namespace.MouseButtons state, /+ Qt:: +/qt.core.namespace.MouseButton button,
                                      QEvent.Type type, /+ Qt:: +/qt.core.namespace.KeyboardModifiers mods, int timestamp);

extern(C++, "QTestPrivate")
{
    /+ Q_TESTLIB_EXPORT +/ extern export __gshared /+ Qt:: +/qt.core.namespace.MouseButtons qtestMouseButtons;
}

extern(C++, "QTest")
{
    enum MouseAction { MousePress, MouseRelease, MouseClick, MouseDClick, MouseMove }

    /+ Q_TESTLIB_EXPORT +/ extern export __gshared /+ Qt:: +/qt.core.namespace.MouseButton lastMouseButton; // ### unsued
    /+ Q_TESTLIB_EXPORT +/ extern export __gshared int lastMouseTimestamp;

    int /+ Q_TESTLIB_EXPORT +/ defaultMouseDelay();

    // This value is used to emulate timestamps to avoid creating double clicks by mistake.
    // Use this constant instead of QStyleHints::mouseDoubleClickInterval property to avoid tests
    // to depend on platform themes.
    extern(D) static __gshared const(int) mouseDoubleClickInterval = 500;

/*! \internal

    This function mocks all mouse events by bypassing the windowing system. The
    result is that the mouse events do not come from the system via Qt platform
    plugins, but are created on the spot and immediately available for processing
    by Qt.
*/
    void mouseEvent(MouseAction action, QWindow window, /+ Qt:: +/qt.core.namespace.MouseButton button,
                               /+ Qt:: +/qt.core.namespace.KeyboardModifiers stateKey, QPoint pos, int delay=-1)
    {
        import qt.core.coreapplication;
        import qt.core.global;
        //import qt.core.pointer;
        import qt.core.size;
        import qt.core.string;
        import qt.core.testsupport_core;
        //import qt.test.testassert;
        import qt.test.testcase;

        assert(window);

        // pos is in window local coordinates
        const(QSize) windowSize = window.geometry().size();
        if (windowSize.width() <= pos.x() || windowSize.height() <= pos.y()) {
            /+ /+ QTest:: +/qt.test.testcase.qWarn(mixin(qPrintable(q{QString.fromLatin1("Mouse event at %1, %2 occurs outside of target window (%3x%4).")
                    .arg(pos.x()).arg(pos.y()).arg(windowSize.width()).arg(windowSize.height())}))); +/
        }

        if (delay == -1 || delay < defaultMouseDelay())
            delay = defaultMouseDelay();
        if (delay > 0) {
            /+ QTest:: +/qt.core.testsupport_core.qWait(delay);
            lastMouseTimestamp += delay;
        }

        if (pos.isNull())
            pos = QPoint(window.width() / 2, window.height() / 2);

        assert(cast(uint) (stateKey) == 0 || stateKey & /+ Qt:: +/qt.core.namespace.KeyboardModifier.KeyboardModifierMask);

        stateKey &= static_cast!(uint)(/+ Qt:: +/qt.core.namespace.KeyboardModifier.KeyboardModifierMask);

        QPoint global2 = window.mapToGlobal(pos);
        QPointF global = QPointF(global2);
        QPointF local = QPointF(pos);
        auto w = /*QPointer!(ValueClass!(QWindow))*/(window);

        /+ using namespace QTestPrivate; +/
        switch (action)
        {
        case MouseAction.MouseDClick:
            qtestMouseButtons.setFlag(button, true);
            qt_handleMouseEvent(cast(QWindow) (w), local, global, qtestMouseButtons, button, QEvent.Type.MouseButtonPress,
                                stateKey, ++lastMouseTimestamp);
            qtestMouseButtons.setFlag(button, false);
            qt_handleMouseEvent(cast(QWindow) (w), local, global, qtestMouseButtons, button, QEvent.Type.MouseButtonRelease,
                                stateKey, ++lastMouseTimestamp);
            /+ Q_FALLTHROUGH(); +/
        goto case;
        case MouseAction.MousePress:
        goto case;
        case MouseAction.MouseClick:
            qtestMouseButtons.setFlag(button, true);
            qt_handleMouseEvent(cast(QWindow) (w), local, global, qtestMouseButtons, button, QEvent.Type.MouseButtonPress,
                                stateKey, ++lastMouseTimestamp);
            lastMouseButton = button; // ### unsued
            if (action == MouseAction.MousePress)
                break;
            /+ Q_FALLTHROUGH(); +/
        goto case;
        case MouseAction.MouseRelease:
            qtestMouseButtons.setFlag(button, false);
            qt_handleMouseEvent(cast(QWindow) (w), local, global, qtestMouseButtons, button, QEvent.Type.MouseButtonRelease,
                                stateKey, ++lastMouseTimestamp);
            lastMouseTimestamp += mouseDoubleClickInterval; // avoid double clicks being generated
            lastMouseButton = /+ Qt:: +/qt.core.namespace.MouseButton.NoButton; // ### unsued
            break;
        case MouseAction.MouseMove:
            qt_handleMouseEvent(cast(QWindow) (w), local, global, qtestMouseButtons, /+ Qt:: +/qt.core.namespace.MouseButton.NoButton, QEvent.Type.MouseMove,
                                stateKey, ++lastMouseTimestamp);
            break;
        default:
            assert(false);
        }
        QCoreApplication.instance().processEvents();
    }

    pragma(inline, true) void mousePress(QWindow window, /+ Qt:: +/qt.core.namespace.MouseButton button,
                               /+ Qt:: +/qt.core.namespace.KeyboardModifiers stateKey = /+ Qt:: +/qt.core.namespace.KeyboardModifiers(),
                               QPoint pos = QPoint(), int delay=-1)
    { mouseEvent(MouseAction.MousePress, window, button, stateKey, pos, delay); }
    pragma(inline, true) void mouseRelease(QWindow window, /+ Qt:: +/qt.core.namespace.MouseButton button,
                                 /+ Qt:: +/qt.core.namespace.KeyboardModifiers stateKey = /+ Qt:: +/qt.core.namespace.KeyboardModifiers(),
                                 QPoint pos = QPoint(), int delay=-1)
    { mouseEvent(MouseAction.MouseRelease, window, button, stateKey, pos, delay); }
    pragma(inline, true) void mouseClick(QWindow window, /+ Qt:: +/qt.core.namespace.MouseButton button,
                               /+ Qt:: +/qt.core.namespace.KeyboardModifiers stateKey = /+ Qt:: +/qt.core.namespace.KeyboardModifiers(),
                               QPoint pos = QPoint(), int delay=-1)
    { mouseEvent(MouseAction.MouseClick, window, button, stateKey, pos, delay); }
    pragma(inline, true) void mouseDClick(QWindow window, /+ Qt:: +/qt.core.namespace.MouseButton button,
                                /+ Qt:: +/qt.core.namespace.KeyboardModifiers stateKey = /+ Qt:: +/qt.core.namespace.KeyboardModifiers(),
                                QPoint pos = QPoint(), int delay=-1)
    { mouseEvent(MouseAction.MouseDClick, window, button, stateKey, pos, delay); }
    pragma(inline, true) void mouseMove(QWindow window, QPoint pos = QPoint(), int delay=-1)
    { mouseEvent(MouseAction.MouseMove, window, /+ Qt:: +/qt.core.namespace.MouseButton.NoButton, /+ Qt:: +/qt.core.namespace.KeyboardModifiers(), pos, delay); }

/+ #ifdef QT_WIDGETS_LIB +/
    /+ void mouseEvent(MouseAction action, QWidget widget, /+ Qt:: +/qt.core.namespace.MouseButton button,
                               /+ Qt:: +/qt.core.namespace.KeyboardModifiers stateKey, QPoint pos, int delay=-1)
    {
        import qt.test.testassert;
        static if (!defined!"QTEST_QPA_MOUSE_HANDLING")
        {
            import qt.core.string;
            import qt.core.testsupport_core;
            import qt.gui.cursor;
            import qt.gui.event;
            import qt.test.testcase;
            import qt.test.testspontaneevent;
            import qt.widgets.application;
        }

        mixin(QTEST_ASSERT(q{widget}));

        if (pos.isNull())
            pos = widget.rect().center();

        static if (defined!"QTEST_QPA_MOUSE_HANDLING")
        {
            QWindow w = widget.window().windowHandle();
            mixin(QTEST_ASSERT(q{w}));
            mouseEvent(action, w, button, stateKey, w.mapFromGlobal(widget.mapToGlobal(pos)), delay);
        }
        else
        {
            int /+ Q_TESTLIB_EXPORT +/ defaultMouseDelay();

            if (delay == -1 || delay < defaultMouseDelay())
                delay = defaultMouseDelay();
            if (delay > 0) {
                /+ QTest:: +/qt.core.testsupport_core.qWait(delay);
                lastMouseTimestamp += delay;
            }

            if (action == MouseAction.MouseClick) {
                mouseEvent(MouseAction.MousePress, widget, button, stateKey, pos);
                mouseEvent(MouseAction.MouseRelease, widget, button, stateKey, pos);
                return;
            }

            mixin(QTEST_ASSERT(q{stateKey == 0 || stateKey & /+ Qt:: +/qt.core.namespace.KeyboardModifier.KeyboardModifierMask}));

            stateKey &= static_cast!(uint)(/+ Qt:: +/qt.core.namespace.KeyboardModifier.KeyboardModifierMask);

            auto me = ValueClass!(QMouseEvent)(QEvent.Type.User, QPoint(), /+ Qt:: +/qt.core.namespace.MouseButton.LeftButton, button, stateKey);
            switch (action)
            {
                case MouseAction.MousePress:
                    me = QMouseEvent(QEvent.Type.MouseButtonPress, pos, widget.mapToGlobal(pos), button, button, stateKey);
                    me.setTimestamp(++lastMouseTimestamp);
                    break;
                case MouseAction.MouseRelease:
                    me = QMouseEvent(QEvent.Type.MouseButtonRelease, pos, widget.mapToGlobal(pos), button, /+ Qt:: +/qt.core.namespace.MouseButton(), stateKey);
                    me.setTimestamp(++lastMouseTimestamp);
                    lastMouseTimestamp += mouseDoubleClickInterval; // avoid double clicks being generated
                    break;
                case MouseAction.MouseDClick:
                    me = QMouseEvent(QEvent.Type.MouseButtonDblClick, pos, widget.mapToGlobal(pos), button, button, stateKey);
                    me.setTimestamp(++lastMouseTimestamp);
                    break;
                case MouseAction.MouseMove:
                    auto tmp = widget.mapToGlobal(pos); QCursor.setPos(tmp);
                    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
                    {
                        /+ QTest:: +/qt.core.testsupport_core.qWait(20);
                    }
                    else
                    {
                        mixin(qApp).processEvents();
                    }
                    return;
                default:
                    mixin(QTEST_ASSERT(q{false}));
            }

            QSpontaneKeyEvent.setSpontaneous(cast(QEvent) (&me));
            if (! mixin(qApp).notify(widget, &me)) {
                extern(D) static __gshared /+ const(char* )[0]  +/ auto mouseActionNames =
                    mixin(buildStaticArray!(q{const(char*)}, q{ "MousePress".ptr, "MouseRelease".ptr, "MouseClick".ptr, "MouseDClick".ptr, "MouseMove".ptr})) ;
                QString warning = QString.fromLatin1("Mouse event \"%1\" not accepted by receiving widget");
                /+ QTest:: +/qt.test.testcase.qWarn(warning.arg(cast(Identity!(mixin((QT_STRINGVIEW_LEVEL >= 2)?q{Args && }:q{ref const(QString)}))) (QString.fromLatin1(cast(const(char)*) (mouseActionNames. ptr[static_cast!(int)(action)])))).toLatin1().data());
            }
        }
    }

    pragma(inline, true) void mousePress(QWidget widget, /+ Qt:: +/qt.core.namespace.MouseButton button,
                               /+ Qt:: +/qt.core.namespace.KeyboardModifiers stateKey = /+ Qt:: +/qt.core.namespace.KeyboardModifiers(),
                               QPoint pos = QPoint(), int delay=-1)
    { mouseEvent(MouseAction.MousePress, widget, button, stateKey, pos, delay); }
    pragma(inline, true) void mouseRelease(QWidget widget, /+ Qt:: +/qt.core.namespace.MouseButton button,
                                 /+ Qt:: +/qt.core.namespace.KeyboardModifiers stateKey = /+ Qt:: +/qt.core.namespace.KeyboardModifiers(),
                                 QPoint pos = QPoint(), int delay=-1)
    { mouseEvent(MouseAction.MouseRelease, widget, button, stateKey, pos, delay); }
    pragma(inline, true) void mouseClick(QWidget widget, /+ Qt:: +/qt.core.namespace.MouseButton button,
                               /+ Qt:: +/qt.core.namespace.KeyboardModifiers stateKey = /+ Qt:: +/qt.core.namespace.KeyboardModifiers(),
                               QPoint pos = QPoint(), int delay=-1)
    { mouseEvent(MouseAction.MouseClick, widget, button, stateKey, pos, delay); }
    pragma(inline, true) void mouseDClick(QWidget widget, /+ Qt:: +/qt.core.namespace.MouseButton button,
                                /+ Qt:: +/qt.core.namespace.KeyboardModifiers stateKey = /+ Qt:: +/qt.core.namespace.KeyboardModifiers(),
                                QPoint pos = QPoint(), int delay=-1)
    { mouseEvent(MouseAction.MouseDClick, widget, button, stateKey, pos, delay); }
    pragma(inline, true) void mouseMove(QWidget widget, QPoint pos = QPoint(), int delay=-1)
    { mouseEvent(MouseAction.MouseMove, widget, /+ Qt:: +/qt.core.namespace.MouseButton.NoButton, /+ Qt:: +/qt.core.namespace.KeyboardModifiers(), pos, delay); } +/
/+ #endif +/ // QT_WIDGETS_LIB
}

