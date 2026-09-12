// QT_MODULES: test
module tests.testtest1;

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.coreapplication;
import qt.core.logging;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.core.variant;
import qt.gui.event;
import qt.gui.guiapplication;
import qt.gui.window;
import qt.helpers;
import std.range;
import std.conv;

QCoreApplication app;
shared static this()
{
    import core.runtime;
    import core.stdcpp.new_;
    import qt.core.metatype;

    qRegisterMetaType!(char[])("char[]");

    version (Android)
    {
        import imports.androidhelpers;
        registerAndroidJVM();
    }

    static __gshared int argc_copy; // Needs to be global, because the application stores a reference.
    argc_copy = Runtime.cArgs.argc;

    version (Android)
        app = cpp_new!QCoreApplication(argc_copy, Runtime.cArgs.argv);
    else
        app = cpp_new!QGuiApplication(argc_copy, Runtime.cArgs.argv);
}
shared static ~this()
{
    import core.stdcpp.new_;

    cpp_delete(app);
    app = null;
}

class TestModel : QAbstractItemModel
{
public:
    /+ explicit +/this()
    {
    }
    ~this()
    {
    }

    extern(C++) override int columnCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const
    {
        return 3;
    }
    extern(C++) override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const
    {
        if (!simulateWrongRowCount && parent.isValid())
            return 0;
        return 20;
    }
    extern(C++) override QVariant data(ref const(QModelIndex) index, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const
    {
        import std.conv;

        if (!index.isValid())
            return QVariant();

        if (role != /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole && role != /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole)
            return QVariant();

        return QVariant(QString(text(cast(char)('A' + index.column()), index.row() + 1)));
    }
    extern(C++) override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const
    {
        if (parent.isValid())
            return QModelIndex();

        return createIndex(row, column, null);
    }
    extern(C++) override QModelIndex parent(ref const(QModelIndex) index) const
    {
        return QModelIndex();
    }

    bool simulateWrongRowCount = false;
}

class TestSignalsObject : QObject
{
    mixin(Q_OBJECT_D);
public:

    final void emitSignalDString(string s)
    {
        /+ emit +/ signalDString(s);
    }

/+ signals +/public:
    @QSignal final void signalDString(string s) {mixin(Q_SIGNAL_IMPL_D);}
}

class EventTestWindow : QWindow
{
    mixin(Q_OBJECT_D);
public:
    /+ explicit +/this()
    {
        resize(400, 400);
    }
    ~this()
    {

    }

    string lastEvent;

    static string keyToString(/+ Qt:: +/qt.core.namespace.Key k)
    {
        switch (k)
        {
            static foreach (name; __traits(allMembers, qt.core.namespace.Key))
                static if (name.length > 4 && name[0 .. 4] == "Key_" && name != "Key_Any")
                    case __traits(getMember, qt.core.namespace.Key, name): return name[4 .. $];
        default: return text(cast(int) k);
        }
    }
    static string modifiersToString(/+ Qt:: +/qt.core.namespace.KeyboardModifiers m)
    {
        string r;
        if (m & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ShiftModifier)
            r ~= (r.empty ? "" : "|") ~ "Shift";
        if (m & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier)
            r ~= (r.empty ? "" : "|") ~ "Ctrl";
        if (m & /+ Qt:: +/qt.core.namespace.KeyboardModifier.AltModifier)
            r ~= (r.empty ? "" : "|") ~ "Alt";
        if (m & /+ Qt:: +/qt.core.namespace.KeyboardModifier.MetaModifier)
            r ~= (r.empty ? "" : "|") ~ "Meta";
        if (m & /+ Qt:: +/qt.core.namespace.KeyboardModifier.KeypadModifier)
            r ~= (r.empty ? "" : "|") ~ "Keypad";
        if (m & /+ Qt:: +/qt.core.namespace.KeyboardModifier.GroupSwitchModifier)
            r ~= (r.empty ? "" : "|") ~ "AltGr";
        if (r.empty)
            r = "None";
        return r;
    }
    static string mouseButtonToString(/+ Qt:: +/qt.core.namespace.MouseButton b)
    {
        switch (b)
        {
        case /+ Qt:: +/qt.core.namespace.MouseButton.NoButton: return "None";
        case /+ Qt:: +/qt.core.namespace.MouseButton.LeftButton: return "Left";
        case /+ Qt:: +/qt.core.namespace.MouseButton.RightButton: return "Left";
        case /+ Qt:: +/qt.core.namespace.MouseButton.MiddleButton: return "Left";
        case /+ Qt:: +/qt.core.namespace.MouseButton.BackButton: return "Left";
        default: return text(cast(int) b);
        }
    }

protected:
    extern(C++) override void keyPressEvent(QKeyEvent ev)
    {
        if (!lastEvent.empty)
            lastEvent ~= " -> ";
        /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = ev.modifiers();
        if (ev.key() == /+ Qt:: +/qt.core.namespace.Key.Key_Control
            || ev.key() == /+ Qt:: +/qt.core.namespace.Key.Key_Shift
            || ev.key() == /+ Qt:: +/qt.core.namespace.Key.Key_Alt
            || ev.key() == /+ Qt:: +/qt.core.namespace.Key.Key_Meta)
            modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifiers.NoModifier; // Normalize modifiers, because they seem to differ between Qt versions.
        lastEvent ~= text("keyPress ",
                     keyToString(cast(/+ Qt:: +/qt.core.namespace.Key) ev.key()),
                     " ", text(ev.text().toConstWString),
                     " ", modifiersToString(modifiers));
    }
    extern(C++) override void keyReleaseEvent(QKeyEvent ev)
    {
        if (!lastEvent.empty)
            lastEvent ~= " -> ";
        /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers = ev.modifiers();
        if (ev.key() == /+ Qt:: +/qt.core.namespace.Key.Key_Control
            || ev.key() == /+ Qt:: +/qt.core.namespace.Key.Key_Shift
            || ev.key() == /+ Qt:: +/qt.core.namespace.Key.Key_Alt
            || ev.key() == /+ Qt:: +/qt.core.namespace.Key.Key_Meta)
            modifiers = /+ Qt:: +/qt.core.namespace.KeyboardModifiers.NoModifier; // Normalize modifiers, because they seem to differ between Qt versions.
        lastEvent ~= text("keyRelease ",
                     keyToString(cast(/+ Qt:: +/qt.core.namespace.Key) ev.key()),
                     " ", text(ev.text().toConstWString),
                     " ", modifiersToString(modifiers));
    }
    extern(C++) override void mouseDoubleClickEvent(QMouseEvent ev)
    {
        if (!lastEvent.empty)
            lastEvent ~= " -> ";
        lastEvent ~= text("mouseDoubleClick " ~ mouseButtonToString(ev.button()),
                     " ", modifiersToString(ev.modifiers()),
                     " ", ev.pos().x(),
                     " ", ev.pos().y());
    }
    extern(C++) override void mouseMoveEvent(QMouseEvent ev)
    {
        if (!lastEvent.empty)
            lastEvent ~= " -> ";
        lastEvent ~= text("mouseMove " ~ mouseButtonToString(ev.button()),
                     " ", modifiersToString(ev.modifiers()),
                     " ", ev.pos().x(),
                     " ", ev.pos().y());
    }
    extern(C++) override void mousePressEvent(QMouseEvent ev)
    {
        if (!lastEvent.empty)
            lastEvent ~= " -> ";
        lastEvent ~= text("mousePress " ~ mouseButtonToString(ev.button()),
                     " ", modifiersToString(ev.modifiers()),
                     " ", ev.pos().x(),
                     " ", ev.pos().y());
    }
    extern(C++) override void mouseReleaseEvent(QMouseEvent ev)
    {
        if (!lastEvent.empty)
            lastEvent ~= " -> ";
        lastEvent ~= text("mouseRelease " ~ mouseButtonToString(ev.button()),
                     " ", modifiersToString(ev.modifiers()),
                     " ", ev.pos().x(),
                     " ", ev.pos().y());
    }
}

__gshared uint messageCount;
extern(C++) void testMessageHandler(QtMsgType type, ref const(QMessageLogContext) context, ref const(QString) msg)
{
    /*import std.stdio;
    writeln("testMessageHandler ", type, " ", msg.toConstWString);*/
    messageCount++;
}

unittest
{
    import core.stdcpp.new_;
    import qt.test.abstractitemmodeltester;

    messageCount = 0;
    auto prevHandler = qInstallMessageHandler(&testMessageHandler);
    scope(exit)
        qInstallMessageHandler(prevHandler);

    auto model = cpp_new!TestModel;
    scope tester = new QAbstractItemModelTester(model, QAbstractItemModelTester.FailureReportingMode.Warning);

    QModelIndex index = model.index(0, 0);
    assert(model.data(index).toString.toConstWString == "A1");
    index = model.index(0, 3);
    assert(model.data(index).toString.toConstWString == "D1");
    index = model.index(19, 0);
    assert(model.data(index).toString.toConstWString == "A20");
    index = model.index(19, 3);
    assert(model.data(index).toString.toConstWString == "D20");

    assert(messageCount == 0);

    version(OSX) {} else // TODO: Destructor crashes on macos.
        cpp_delete(model);
}

unittest
{
    import core.stdcpp.new_;
    import qt.test.abstractitemmodeltester;

    messageCount = 0;
    auto prevHandler = qInstallMessageHandler(&testMessageHandler);
    scope(exit)
        qInstallMessageHandler(prevHandler);

    auto model = cpp_new!TestModel;
    model.simulateWrongRowCount = true;
    scope tester = new QAbstractItemModelTester(model, QAbstractItemModelTester.FailureReportingMode.Warning);

    assert(messageCount == 2);

    version(OSX) {} else // TODO: Destructor crashes on macos.
        cpp_delete(model);
}

unittest
{
    import qt.test.testeventloop;

    scope l = new QTestEventLoop;
    assert(!l.timeout());
    l.enterLoopMSecs(10);
    assert(l.timeout());
}

unittest
{
    import qt.core.timer;
    import qt.test.testeventloop;

    scope l = new QTestEventLoop;
    assert(!l.timeout());
    scope timer = new QTimer;
    QObject.connect(timer.signal!"timeout", l.slot!"exitLoop");
    timer.start(10);
    l.enterLoopMSecs(20);
    assert(!l.timeout());
}

unittest
{
    import qt.core.objectdefs;
    import qt.core.timer;
    import qt.test.signalspy;

    scope timer = new QTimer;
    scope spy = new QSignalSpy(timer, mixin(SIGNAL(q{timeout()})));
    assert(spy.isValid());
    timer.start(10);
    assert(spy.wait(20));
}

unittest
{
    import qt.core.timer;
    import qt.test.signalspy;

    scope timer = new QTimer;
    scope spy = new QSignalSpy(timer.signal!"timeout");
    assert(spy.isValid());
    timer.start(10);
    assert(spy.wait(20));
}

unittest
{
    import core.stdcpp.new_;
    import qt.core.timer;
    import qt.core.vector;
    import qt.gui.standarditemmodel;
    import qt.test.signalspy;

    QStandardItemModel model = cpp_new!QStandardItemModel(4, 4);
    QTimer.singleShot(5, model, (){
        model.setData(model.index(0, 0), "test1");
    });
    QTimer.singleShot(20, model, (){
        model.setData(model.index(1, 3), "test2");
    });
    QTimer.singleShot(10, model, (){
        model.setData(model.index(2, 1), "test3");
    });
    QTimer.singleShot(50, model, (){
        model.setData(model.index(3, 2), "test4");
    });
    scope spy = new QSignalSpy(model.signal!"dataChanged");
    assert(spy.isValid());
    assert(spy.wait(10));
    assert(spy.collectedSignals.count() >= 1);
    assert(spy.collectedSignals[0][0].toModelIndex().row() == 0);
    assert(spy.collectedSignals[0][1].toModelIndex().column() == 0);
    assert(spy.wait(10));
    assert(spy.collectedSignals.count() >= 2);
    assert(spy.collectedSignals[1][0].toModelIndex().row() == 2);
    assert(spy.collectedSignals[1][1].toModelIndex().column() == 1);
    assert(spy.wait(10));
    assert(spy.collectedSignals.count() == 3);
    assert(spy.collectedSignals[2][0].toModelIndex().row() == 1);
    assert(spy.collectedSignals[2][1].toModelIndex().column() == 3);
    assert(!spy.wait(10));

    cpp_delete(model);
    model = null;
}

unittest
{
    import core.stdc.string;
    import qt.test.signalspy;

    scope obj = new TestSignalsObject;
    scope spy = new QSignalSpy(obj.signal!"signalDString");
    assert(spy.isValid());
    assert(spy.collectedSignals.count() == 0);

    obj.emitSignalDString("test");

    assert(spy.collectedSignals.count() == 1);
}

version (Android)
{}
else
unittest
{
    import qt.core.point;
    import qt.test.testkeyboard;
    import qt.test.testmouse;

    scope window = new EventTestWindow;
    window.show();

    /+ QTest:: +/qt.test.testkeyboard.keyPress(window, 'A');
    assert(window.lastEvent == "keyPress A A None");
    window.lastEvent = "";
    /+ QTest:: +/qt.test.testkeyboard.keyPress(window, 'B', /+ Qt:: +/qt.core.namespace.KeyboardModifiers.ControlModifier);
    assert(window.lastEvent == "keyPress Control  None -> keyPress B B Ctrl");
    window.lastEvent = "";
    /+ QTest:: +/qt.test.testkeyboard.keyPress(window, 'C', /+ Qt:: +/qt.core.namespace.KeyboardModifiers.AltModifier);
    assert(window.lastEvent == "keyPress Alt  None -> keyPress C C Alt");
    window.lastEvent = "";
    /+ QTest:: +/qt.test.testkeyboard.keyPress(window, 'D', /+ Qt:: +/qt.core.namespace.KeyboardModifiers.MetaModifier);
    assert(window.lastEvent == "keyPress Meta  None -> keyPress D D Meta");
    window.lastEvent = "";
    /+ QTest:: +/qt.test.testkeyboard.keyPress(window, '3', /+ Qt:: +/qt.core.namespace.KeyboardModifiers.KeypadModifier);
    assert(window.lastEvent == "keyPress 3 3 Keypad");
    window.lastEvent = "";
    /+ QTest:: +/qt.test.testkeyboard.keyPress(window, '0', /+ Qt:: +/qt.core.namespace.KeyboardModifiers.GroupSwitchModifier);
    assert(window.lastEvent == "keyPress 0 0 AltGr");
    window.lastEvent = "";
    /+ QTest:: +/qt.test.testkeyboard.keyPress(window, 'Z', /+ Qt:: +/qt.core.namespace.KeyboardModifiers.ControlModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.AltModifier);
    assert(window.lastEvent == "keyPress Control  None -> keyPress Alt  None -> keyPress Z Z Ctrl|Alt");
    window.lastEvent = "";
    /+ QTest:: +/qt.test.testkeyboard.keyPress(window, '9', /+ Qt:: +/qt.core.namespace.KeyboardModifiers.ControlModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.AltModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.MetaModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.KeypadModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.GroupSwitchModifier);
    assert(window.lastEvent == "keyPress Control  None -> keyPress Alt  None -> keyPress Meta  None -> keyPress 9 9 Ctrl|Alt|Meta|Keypad|AltGr");
    window.lastEvent = "";

    /+ QTest:: +/qt.test.testkeyboard.keyRelease(window, 'A');
    assert(window.lastEvent == "keyRelease A A None");
    window.lastEvent = "";
    /+ QTest:: +/qt.test.testkeyboard.keyRelease(window, 'B', /+ Qt:: +/qt.core.namespace.KeyboardModifiers.ControlModifier);
    assert(window.lastEvent == "keyRelease B B Ctrl -> keyRelease Control  None");
    window.lastEvent = "";

    /+ QTest:: +/qt.test.testkeyboard.keyClick(window, 'X', /+ Qt:: +/qt.core.namespace.KeyboardModifiers.ControlModifier | /+ Qt:: +/qt.core.namespace.KeyboardModifier.AltModifier);
    assert(window.lastEvent == "keyPress Control  None -> keyPress Alt  None -> keyPress X X Ctrl|Alt -> keyRelease X X Ctrl|Alt -> keyRelease Alt  None -> keyRelease Control  None");
    window.lastEvent = "";

    /+ QTest:: +/qt.test.testmouse.mousePress(window, /+ Qt:: +/qt.core.namespace.MouseButton.RightButton, /+ Qt:: +/qt.core.namespace.KeyboardModifiers.ControlModifier, QPoint(40, 50));
    assert(window.lastEvent == "mouseMove None Ctrl 40 50 -> mousePress Left Ctrl 40 50");
    window.lastEvent = "";

    /+ QTest:: +/qt.test.testmouse.mouseDClick(window, /+ Qt:: +/qt.core.namespace.MouseButton.LeftButton, /+ Qt:: +/qt.core.namespace.KeyboardModifiers.AltModifier, QPoint(60, 30));
    assert(window.lastEvent == "mouseMove None Alt 60 30 -> mousePress Left Alt 60 30 -> mouseRelease Left Alt 60 30 -> mousePress Left Alt 60 30 -> mouseDoubleClick Left Alt 60 30 -> mouseRelease Left Alt 60 30");
    window.lastEvent = "";

    /+ QTest:: +/qt.test.testmouse.mouseMove(window, QPoint(70, 50));
    assert(window.lastEvent == "mouseMove None None 70 50");
    window.lastEvent = "";
}
