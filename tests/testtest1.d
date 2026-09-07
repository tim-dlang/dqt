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
import qt.helpers;

QCoreApplication app;
shared static this()
{
    import core.runtime;
    import core.stdcpp.new_;
    import qt.core.metatype;

    version (Android)
    {
        import imports.androidhelpers;
        registerAndroidJVM();
    }

    static __gshared int argc_copy; // Needs to be global, because the application stores a reference.
    argc_copy = Runtime.cArgs.argc;

    app = cpp_new!QCoreApplication(argc_copy, Runtime.cArgs.argv);
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
    import qt.core.list;
    import qt.core.timer;
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
