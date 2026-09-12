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
module qt.test.testkeyboard;
extern(C++):

import core.stdc.config;
import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.gui.keysequence;
import qt.gui.window;
import qt.helpers;
// import qt.widgets.widget;

/+ #if 0
// inform syncqt
#pragma qt_no_master_include
#endif

#if QT_CONFIG(shortcut)
#endif

#ifdef QT_WIDGETS_LIB
#endif +/


/+ Q_GUI_EXPORT +/ void qt_handleKeyEvent(QWindow w, QEvent.Type t, int k, /+ Qt:: +/qt.core.namespace.KeyboardModifiers mods, ref const(QString)  text = globalInitVar!QString, bool autorep = false, ushort count = 1);
/+ Q_GUI_EXPORT +/ bool qt_sendShortcutOverrideEvent(QObject o, cpp_ulong timestamp, int k, /+ Qt:: +/qt.core.namespace.KeyboardModifiers mods, ref const(QString) text = globalInitVar!QString, bool autorep = false, ushort count = 1);

extern(C++, "QTest")
{
    enum KeyAction { Press, Release, Click, Shortcut }

    void simulateEvent(QWindow window, bool press, int code,
                                  /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier, QString text, bool repeat, int delay=-1)
    {
        import qt.core.coreapplication;

        QEvent.Type type;
        type = press ? QEvent.Type.KeyPress : QEvent.Type.KeyRelease;
        qt_handleKeyEvent(window, type, code, modifier, text, repeat, cast(ushort) (delay));
        QCoreApplication.instance().processEvents();
    }

    void sendKeyEvent(KeyAction action, QWindow window, /+ Qt:: +/qt.core.namespace.Key code,
                                 QString text, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier, int delay=-1)
    {
        import qt.core.coreapplication;
        //import qt.core.pointer;
        import qt.gui.guiapplication;
        //import qt.test.testassert;

        assert(QCoreApplication.instance());

        if (!window)
            window = QGuiApplication.focusWindow();

        assert(window);


        if (action == KeyAction.Click) {
            auto ptr = /*QPointer!(ValueClass!(QWindow))*/(window);
            sendKeyEvent(KeyAction.Press, window, code, text, modifier, delay);
            if (!ptr)
                return;
            sendKeyEvent(KeyAction.Release, window, code, text, modifier, delay);
            return;
        }

        bool repeat = false;

        if (action == KeyAction.Shortcut) {
            int timestamp = 0;
            qt_sendShortcutOverrideEvent(window, timestamp, code, modifier, text, repeat);
            return;
        }

        if (action == KeyAction.Press) {
            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier)
                simulateEvent(window, true, /+ Qt:: +/qt.core.namespace.Key.Key_Shift, /+ Qt:: +/qt.core.namespace.KeyboardModifiers(), QString(), false, delay);

            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier)
                simulateEvent(window, true, /+ Qt:: +/qt.core.namespace.Key.Key_Control, modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier, QString(), false, delay);

            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.AltModifier)
                simulateEvent(window, true, /+ Qt:: +/qt.core.namespace.Key.Key_Alt,
                              modifier & (/+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier), QString(), false, delay);
            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.MetaModifier)
                simulateEvent(window, true, /+ Qt:: +/qt.core.namespace.Key.Key_Meta, modifier & (/+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier
                                                                      | /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.AltModifier), QString(), false, delay);
            simulateEvent(window, true, code, modifier, text, repeat, delay);
        } else if (action == KeyAction.Release) {
            simulateEvent(window, false, code, modifier, text, repeat, delay);

            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.MetaModifier)
                simulateEvent(window, false, /+ Qt:: +/qt.core.namespace.Key.Key_Meta, modifier, QString(), false, delay);
            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.AltModifier)
                simulateEvent(window, false, /+ Qt:: +/qt.core.namespace.Key.Key_Alt, modifier &
                              (/+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.AltModifier), QString(), false, delay);

            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier)
                simulateEvent(window, false, /+ Qt:: +/qt.core.namespace.Key.Key_Control,
                              modifier & (/+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier), QString(), false, delay);

            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier)
                simulateEvent(window, false, /+ Qt:: +/qt.core.namespace.Key.Key_Shift, modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier, QString(), false, delay);
        }
    }

    // Convenience function
    void sendKeyEvent(KeyAction action, QWindow window, /+ Qt:: +/qt.core.namespace.Key code,
                                 char ascii, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier, int delay=-1)
    {
        import qt.core.qchar;

        QString text;
        if (ascii)
            text = QString(QChar.fromLatin1(ascii));
        sendKeyEvent(action, window, code, text, modifier, delay);
    }

    pragma(inline, true) void keyEvent(KeyAction action, QWindow window, char ascii,
                                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    {
        import qt.test.testcase;
        sendKeyEvent(action, window, qt.test.testcase.asciiToKey(ascii), ascii, modifier, delay);
    }
    pragma(inline, true) void keyEvent(KeyAction action, QWindow window, /+ Qt:: +/qt.core.namespace.Key key,
                                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    {
        import qt.test.testcase;
        sendKeyEvent(action, window, key, qt.test.testcase.keyToAscii(key), modifier, delay);
    }

    /+ [[maybe_unused]] +/ pragma(inline, true) void keyClick(QWindow window, /+ Qt:: +/qt.core.namespace.Key key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    { keyEvent(KeyAction.Click, window, key, modifier, delay); }
    /+ [[maybe_unused]] +/ pragma(inline, true) void keyClick(QWindow window, char key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    { keyEvent(KeyAction.Click, window, key, modifier, delay); }
    /+ [[maybe_unused]] +/ pragma(inline, true) void keyRelease(QWindow window, char key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    { keyEvent(KeyAction.Release, window, key, modifier, delay); }
    /+ [[maybe_unused]] +/ pragma(inline, true) void keyRelease(QWindow window, /+ Qt:: +/qt.core.namespace.Key key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    { keyEvent(KeyAction.Release, window, key, modifier, delay); }
    /+ [[maybe_unused]] +/ pragma(inline, true) void keyPress(QWindow window, char key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    { keyEvent(KeyAction.Press, window, key, modifier, delay); }
    /+ [[maybe_unused]] +/ pragma(inline, true) void keyPress(QWindow window, /+ Qt:: +/qt.core.namespace.Key key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    { keyEvent(KeyAction.Press, window, key, modifier, delay); }

/+ #if QT_CONFIG(shortcut) +/
    /+ [[maybe_unused]] +/ pragma(inline, true) void keySequence(QWindow window, ref const(QKeySequence) keySequence__1)
    {
        for (int i = 0; i < keySequence__1.count(); ++i) {
            const(/+ Qt:: +/qt.core.namespace.Key) key = keySequence__1[i].key();
            const(/+ Qt:: +/qt.core.namespace.KeyboardModifiers) modifiers = keySequence__1[i].keyboardModifiers();
            keyClick(window, key, modifiers);
        }
    }
/+ #endif

#ifdef QT_WIDGETS_LIB +/
    /+ void simulateEvent(QWidget widget, bool press, int code,
                                  /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier, QString text, bool repeat, int delay=-1)
    {
        import qt.core.logging;
        import qt.core.testsupport_core;
        import qt.gui.event;
        import qt.test.testassert;
        import qt.test.testspontaneevent;
        import qt.gui.guiapplication;

        mixin(QTEST_ASSERT(q{widget}));
        int /+ Q_TESTLIB_EXPORT +/ defaultKeyDelay();

        if (delay == -1 || delay < defaultKeyDelay())
            delay = defaultKeyDelay();
        if (delay > 0)
            /+ QTest:: +/qt.core.testsupport_core.qWait(delay);

        auto a = ValueClass!(QKeyEvent)(press ? QEvent.Type.KeyPress : QEvent.Type.KeyRelease, code, modifier, text, repeat);
        QSpontaneKeyEvent.setSpontaneous(&a);

        if (press && qt_sendShortcutOverrideEvent(widget, cast(cpp_ulong) (a.timestamp()), code, modifier, text, repeat))
            return;
        if (! mixin(qt.widgets.application.qApp).notify(widget, &a))
            mixin(qWarning)("Keyboard event not accepted by receiving widget");
    }

    void sendKeyEvent(KeyAction action, QWidget widget, /+ Qt:: +/qt.core.namespace.Key code,
                                 QString text, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier, int delay=-1)
    {
        import qt.core.pointer;
        import qt.gui.guiapplication;
        import qt.test.testassert;
        import qt.widgets.application;

        mixin(QTEST_ASSERT(qt.widgets.application.qApp));

        if (!widget)
            widget = QWidget.keyboardGrabber();
        if (!widget) {
            // Popup widgets stealthily steal the keyboard grab
            if (QWidget apw = QApplication.activePopupWidget())
                widget = apw.focusWidget() ? apw.focusWidget() : apw;
        }
        if (!widget) {
            QWindow window = QGuiApplication.focusWindow();
            if (window) {
                sendKeyEvent(action, window, code, text, modifier, delay);
                return;
            }
        }
        if (!widget)
            widget = QApplication.focusWidget();
        if (!widget)
            widget = QApplication.activeWindow();

        mixin(QTEST_ASSERT(q{widget}));

        if (action == KeyAction.Click) {
            auto ptr = QPointer!(ValueClass!(QWidget))(widget);
            sendKeyEvent(KeyAction.Press, widget, code, text, modifier, delay);
            if (!ptr) {
                // if we send key-events to embedded widgets, they might be destroyed
                // when the user presses Return
                return;
            }
            sendKeyEvent(KeyAction.Release, widget, code, text, modifier, delay);
            return;
        }

        bool repeat = false;

        if (action == KeyAction.Press) {
            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier)
                simulateEvent(widget, true, /+ Qt:: +/qt.core.namespace.Key.Key_Shift, /+ Qt:: +/qt.core.namespace.KeyboardModifiers(), QString(), false, delay);

            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier)
                simulateEvent(widget, true, /+ Qt:: +/qt.core.namespace.Key.Key_Control, modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier, QString(), false, delay);

            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.AltModifier)
                simulateEvent(widget, true, /+ Qt:: +/qt.core.namespace.Key.Key_Alt,
                              modifier & (/+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier), QString(), false, delay);
            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.MetaModifier)
                simulateEvent(widget, true, /+ Qt:: +/qt.core.namespace.Key.Key_Meta, modifier & (/+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier
                                                                      | /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.AltModifier), QString(), false, delay);
            simulateEvent(widget, true, code, modifier, text, repeat, delay);
        } else if (action == KeyAction.Release) {
            simulateEvent(widget, false, code, modifier, text, repeat, delay);

            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.MetaModifier)
                simulateEvent(widget, false, /+ Qt:: +/qt.core.namespace.Key.Key_Meta, modifier, QString(), false, delay);
            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.AltModifier)
                simulateEvent(widget, false, /+ Qt:: +/qt.core.namespace.Key.Key_Alt, modifier &
                              (/+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.AltModifier), QString(), false, delay);

            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier)
                simulateEvent(widget, false, /+ Qt:: +/qt.core.namespace.Key.Key_Control,
                              modifier & (/+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier), QString(), false, delay);

            if (modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier)
                simulateEvent(widget, false, /+ Qt:: +/qt.core.namespace.Key.Key_Shift, modifier & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier, QString(), false, delay);
        }
    }

    // Convenience function
    void sendKeyEvent(KeyAction action, QWidget widget, /+ Qt:: +/qt.core.namespace.Key code,
                                 char ascii, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier, int delay=-1)
    {
        import qt.core.qchar;

        QString text;
        if (ascii)
            text = QString(QChar.fromLatin1(ascii));
        sendKeyEvent(action, widget, code, text, modifier, delay);
    }

    pragma(inline, true) void keyEvent(KeyAction action, QWidget widget, char ascii,
                                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    {
        import qt.test.testcase;
        sendKeyEvent(action, widget, qt.test.testcase.asciiToKey(ascii), ascii, modifier, delay);
    }
    pragma(inline, true) void keyEvent(KeyAction action, QWidget widget, /+ Qt:: +/qt.core.namespace.Key key,
                                    /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    {
        import qt.test.testcase;
        sendKeyEvent(action, widget, key, qt.test.testcase.keyToAscii(key), modifier, delay);
    }

    pragma(inline, true) void keyClicks(QWidget widget, ref const(QString) sequence,
                                     /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    {
        for (int i=0; i < sequence.size(); i++)
            keyEvent(KeyAction.Click, widget, sequence.at(i).toLatin1(), modifier, delay);
    }

    pragma(inline, true) void keyPress(QWidget widget, char key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    { keyEvent(KeyAction.Press, widget, key, modifier, delay); }
    pragma(inline, true) void keyRelease(QWidget widget, char key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    { keyEvent(KeyAction.Release, widget, key, modifier, delay); }
    pragma(inline, true) void keyClick(QWidget widget, char key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    { keyEvent(KeyAction.Click, widget, key, modifier, delay); }
    pragma(inline, true) void keyPress(QWidget widget, /+ Qt:: +/qt.core.namespace.Key key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    { keyEvent(KeyAction.Press, widget, key, modifier, delay); }
    pragma(inline, true) void keyRelease(QWidget widget, /+ Qt:: +/qt.core.namespace.Key key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    { keyEvent(KeyAction.Release, widget, key, modifier, delay); }
    pragma(inline, true) void keyClick(QWidget widget, /+ Qt:: +/qt.core.namespace.Key key, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifier = /+ Qt:: +/qt.core.namespace.KeyboardModifier.NoModifier, int delay=-1)
    { keyEvent(KeyAction.Click, widget, key, modifier, delay); }

/+ #if QT_CONFIG(shortcut) +/
    pragma(inline, true) void keySequence(QWidget widget, ref const(QKeySequence) keySequence__1)
    {
        for (int i = 0; i < keySequence__1.count(); ++i) {
            const(/+ Qt:: +/qt.core.namespace.Key) key = keySequence__1[i].key();
            const(/+ Qt:: +/qt.core.namespace.KeyboardModifiers) modifiers = keySequence__1[i].keyboardModifiers();
            keyClick(widget, key, modifiers);
        }
    } +/
/+ #endif +/

/+ #endif +/ // QT_WIDGETS_LIB

}

