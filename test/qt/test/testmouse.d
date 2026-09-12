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

    /+ Q_TESTLIB_EXPORT +/ extern export __gshared int lastMouseTimestamp;

    int /+ Q_TESTLIB_EXPORT +/ defaultMouseDelay();

    // This value is used to emulate timestamps to avoid creating double clicks by mistake.
    // Use this constant instead of QStyleHints::mouseDoubleClickInterval property to avoid tests
    // to depend on platform themes.
    extern(D) static __gshared const(int) mouseDoubleClickInterval = 500;

    /*! \internal
        This function creates a QPA mouse event of type specified by \a action
        and calls QWindowSystemInterface::handleMouseEvent(), simulating the
        windowing system and bypassing the platform plugin. \a delay is the
        amount of time to be added to the simulated clock so that
        QInputEvent::timestamp() will be greater than that of the previous
        event. We expect all event-handling code to rely on the event
        timestamps, not the system clock; therefore tests can be run faster
        than real-time.
    */
    void mouseEvent(MouseAction action, QWindow window, /+ Qt:: +/qt.core.namespace.MouseButton button,
                               /+ Qt:: +/qt.core.namespace.KeyboardModifiers stateKey, QPoint pos, int delay=-1)
    {
        import qt.core.coreapplication;
        import qt.core.global;
        import qt.core.logging;
        //import qt.core.pointer;
        import qt.core.size;
        //import qt.test.testassert;

        assert(window);

        // pos is in window local coordinates
        const(QSize) windowSize = window.geometry().size();
        if (windowSize.width() <= pos.x() || windowSize.height() <= pos.y()) {
            mixin(qWarning)("Mouse event at %d, %d occurs outside target window (%dx%d).".ptr,
                     pos.x(), pos.y(), windowSize.width(), windowSize.height());
        }

        if (delay == -1 || delay < defaultMouseDelay())
            delay = defaultMouseDelay();
        lastMouseTimestamp += qMax(1, delay);

        if (pos.isNull())
            pos = QPoint(window.width() / 2, window.height() / 2);

        assert(!stateKey || stateKey & /+ Qt:: +/qt.core.namespace.KeyboardModifier.KeyboardModifierMask);

        stateKey &= /+ Qt:: +/qt.core.namespace.KeyboardModifier.KeyboardModifierMask;

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
                                stateKey, lastMouseTimestamp);
            qtestMouseButtons.setFlag(button, false);
            qt_handleMouseEvent(cast(QWindow) (w), local, global, qtestMouseButtons, button, QEvent.Type.MouseButtonRelease,
                                stateKey, lastMouseTimestamp);
            lastMouseTimestamp++; // Needed for compatibility with newer Qt binaries, see https://code.qt.io/cgit/qt/qtbase.git/commit/?id=fb9817741181894ca82a283a6c15466af886ac92.
            /+ Q_FALLTHROUGH(); +/
        goto case;
        case MouseAction.MousePress:
        goto case;
        case MouseAction.MouseClick:
            qtestMouseButtons.setFlag(button, true);
            qt_handleMouseEvent(cast(QWindow) (w), local, global, qtestMouseButtons, button, QEvent.Type.MouseButtonPress,
                                stateKey, lastMouseTimestamp);
            if (action == MouseAction.MousePress)
                break;
            /+ Q_FALLTHROUGH(); +/
        goto case;
        case MouseAction.MouseRelease:
            qtestMouseButtons.setFlag(button, false);
            qt_handleMouseEvent(cast(QWindow) (w), local, global, qtestMouseButtons, button, QEvent.Type.MouseButtonRelease,
                                stateKey, lastMouseTimestamp);
            lastMouseTimestamp += mouseDoubleClickInterval; // avoid double clicks being generated
            break;
        case MouseAction.MouseMove:
            qt_handleMouseEvent(cast(QWindow) (w), local, global, qtestMouseButtons, /+ Qt:: +/qt.core.namespace.MouseButton.NoButton, QEvent.Type.MouseMove,
                                stateKey, lastMouseTimestamp);
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
            import qt.core.global;
            import qt.core.logging;
            import qt.gui.cursor;
            import qt.gui.event;
            import qt.gui.pointingdevice;
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
            lastMouseTimestamp += qMax(1, delay);

            if (action == MouseAction.MouseClick) {
                mouseEvent(MouseAction.MousePress, widget, button, stateKey, pos);
                mouseEvent(MouseAction.MouseRelease, widget, button, stateKey, pos);
                return;
            }

            mixin(QTEST_ASSERT(q{!stateKey || stateKey & /+ Qt:: +/qt.core.namespace.KeyboardModifier.KeyboardModifierMask}));

            stateKey &= /+ Qt:: +/qt.core.namespace.KeyboardModifier.KeyboardModifierMask;

            QEvent.Type meType;
            /+ using namespace QTestPrivate; +/
            switch (action)
            {
                case MouseAction.MousePress:
                    qtestMouseButtons.setFlag(button, true);
                    meType = QEvent.Type.MouseButtonPress;
                    break;
                case MouseAction.MouseRelease:
                    qtestMouseButtons.setFlag(button, false);
                    meType = QEvent.Type.MouseButtonRelease;
                    break;
                case MouseAction.MouseDClick:
                    qtestMouseButtons.setFlag(button, true);
                    meType = QEvent.Type.MouseButtonDblClick;
                    break;
                case MouseAction.MouseMove:
                    // ### Qt 7: compatibility with < Qt 6.3, we should not rely on QCursor::setPos
                    // for generating mouse move events, and code that depends on QCursor::pos should
                    // be tested using QCursor::setPos explicitly.
                    if (qtestMouseButtons == /+ Qt:: +/qt.core.namespace.MouseButton.NoButton) {
                        auto tmp = widget.mapToGlobal(pos); QCursor.setPos(tmp);
                        mixin(qApp).processEvents();
                        return;
                    }
                    meType = QEvent.Type.MouseMove;
                    break;
                default:
                    mixin(QTEST_ASSERT(q{false}));
            }
            auto me = ValueClass!(QMouseEvent)(meType, pos, widget.mapToGlobal(pos), button, qtestMouseButtons, stateKey, QPointingDevice.primaryPointingDevice());
            me.setTimestamp(lastMouseTimestamp);
            if (action == MouseAction.MouseRelease) // avoid double clicks being generated
                lastMouseTimestamp += mouseDoubleClickInterval;

            QSpontaneKeyEvent.setSpontaneous(&me);
            if (! mixin(qApp).notify(widget, &me)) {
                extern(D) static __gshared /+ const(char* )[0]  +/ auto mouseActionNames =
                    mixin(buildStaticArray!(q{const(char*)}, q{ "MousePress".ptr, "MouseRelease".ptr, "MouseClick".ptr, "MouseDClick".ptr, "MouseMove".ptr})) ;
                mixin(qWarning)("Mouse event \"%s\" not accepted by receiving widget".ptr,
                         mouseActionNames. ptr[static_cast!(int)(action)]);
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

