// QT_MODULES: core
module testcore1;

import qt.config;
import qt.core.coreapplication;
import qt.core.list;
import qt.core.object;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.variant;
import qt.core.vector;
import qt.helpers;
import std.stdio;

QCoreApplication app;
shared static this()
{
    import core.runtime;
    app = new QCoreApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);
    assert(QCoreApplication.instance() is app);
}

class TestObject : QObject
{
    mixin(Q_OBJECT_D);
public:
    /+ explicit +/@QInvokable this(QObject parent = null)
    {
        super(parent);
        lastStr = QString.create;
    }

    QString lastStr;

    @QInvokable final void emitSignalVoid()
    {
        /+ emit +/ signalVoid();
    }
    @QInvokable final void emitSignalInt(int i)
    {
        /+ emit +/ signalInt(i);
    }
    @QInvokable final void emitSignalInt3(int x, int y, int z)
    {
        /+ emit +/ signalInt3(x, y, z);
    }
    @QInvokable final void emitSignalDouble(double d)
    {
        /+ emit +/ signalDouble(d);
    }
    @QInvokable final void emitSignalString(ref const(QString) s)
    {
        /+ emit +/ signalString(s);
    }
    @QInvokable final void emitSignalListInt(ref const(QList!(int)) l)
    {
        /+ emit +/ signalListInt(l);
    }
    @QInvokable final void emitSignalVectorInt(ref const(QVector!(int)) v)
    {
        /+ emit +/ signalVectorInt(v);
    }
    @QInvokable final void emitSignalPointerInt(int* p)
    {
        /+ emit +/ signalPointerInt(p);
    }

/+ signals +/public:
    @QSignal final void signalVoid(){mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalInt(int i){mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalInt3(int x, int y, int z){mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalDouble(double d){mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalString(ref const(QString) s){mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalListInt(ref const(QList!(int)) l){mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalVectorInt(ref const(QVector!(int)) v){mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalPointerInt(int* p){mixin(Q_SIGNAL_IMPL_D);}

public /+ slots +/:
    @QSlot final void onSignalVoid()
    {
        lastStr = QString("void");
    }
    @QSlot final void onSignalInt(int i)
    {
        lastStr = "int " ~ QString.number(i);
    }
    @QSlot final void onSignalInt3(int x, int y, int z)
    {
        lastStr = "int3 " ~ QString.number(x) ~ " " ~ QString.number(y) ~ " " ~ QString.number(z);
    }
    @QSlot final void onSignalDouble(double d)
    {
        lastStr = "double " ~ QString.number(d);
    }
    @QSlot final void onSignalString(ref const(QString) s)
    {
        lastStr = "QString " ~ s;
    }
    @QSlot final void onSignalListInt(ref const(QList!(int)) l)
    {
        lastStr = QString("QList<int>");
        for(int i=0; i<l.size(); i++)
            lastStr ~= " " ~ QString.number(l[i]);
    }
    @QSlot final void onSignalVectorInt(ref const(QVector!(int)) v)
    {
        lastStr = QString("QVector<int>");
        for(int i=0; i<v.size(); i++)
            lastStr ~= " " ~ QString.number(v[i]);
    }
    @QSlot final void onSignalPointerInt(int* p)
    {
        lastStr = "int* " ~ QString.number(*p);
    }

}

unittest
{
    QString s = QString.create;
    s = QString("QString(Utf8): abc äöüÄÖÜßẞ αβ ∃∀ ∨∧⊥¬ ≤≥≠ 𝕆🎵🎶");
    assert(s.toConstWString == "QString(Utf8): abc äöüÄÖÜßẞ αβ ∃∀ ∨∧⊥¬ ≤≥≠ 𝕆🎵🎶"w);

    s = QString.fromUtf8("QString::fromUtf8: abc äöüÄÖÜßẞ αβ ∃∀ ∨∧⊥¬ ≤≥≠ 𝕆🎵🎶".ptr);
    assert(s.toConstWString == "QString::fromUtf8: abc äöüÄÖÜßẞ αβ ∃∀ ∨∧⊥¬ ≤≥≠ 𝕆🎵🎶"w);

    s = QString("QString(Utf16): abc äöüÄÖÜßẞ αβ ∃∀ ∨∧⊥¬ ≤≥≠ 𝕆🎵🎶"w);
    assert(s.toConstWString == "QString(Utf16): abc äöüÄÖÜßẞ αβ ∃∀ ∨∧⊥¬ ≤≥≠ 𝕆🎵🎶"w);

    s = QString.fromUtf16("QString::fromUtf16: abc äöüÄÖÜßẞ αβ ∃∀ ∨∧⊥¬ ≤≥≠ 𝕆🎵🎶"w.ptr);
    assert(s.toConstWString == "QString::fromUtf16: abc äöüÄÖÜßẞ αβ ∃∀ ∨∧⊥¬ ≤≥≠ 𝕆🎵🎶"w);

    s = QString("QString(Utf32): abc äöüÄÖÜßẞ αβ ∃∀ ∨∧⊥¬ ≤≥≠ 𝕆🎵🎶"d);
    assert(s.toConstWString == "QString(Utf32): abc äöüÄÖÜßẞ αβ ∃∀ ∨∧⊥¬ ≤≥≠ 𝕆🎵🎶"w);

    s = QString.fromUcs4("QString::fromUcs4: abc äöüÄÖÜßẞ αβ ∃∀ ∨∧⊥¬ ≤≥≠ 𝕆🎵🎶"d.ptr);
    assert(s.toConstWString == "QString::fromUcs4: abc äöüÄÖÜßẞ αβ ∃∀ ∨∧⊥¬ ≤≥≠ 𝕆🎵🎶"w);
}

void checkType(T, bool relocatable, bool complex, bool static_)()
{
    //writefln("checkType!(%s, %d, %d, %d, %d)();", T.stringof, QTypeInfo!T.isRelocatable, QTypeInfo!T.isComplex, QTypeInfo!T.isStatic);
    static assert(QTypeInfo!(T).isRelocatable == relocatable);
    static assert(QTypeInfo!(T).isComplex == complex);
    static assert(QTypeInfo!(T).isStatic == static_);
    static assert(QTypeInfoQuery!(T).isRelocatable == relocatable);
    static assert(QTypeInfoQuery!(T).isComplex == complex);
    static assert(QTypeInfoQuery!(T).isStatic == static_);
}

unittest
{
    import qt.core.abstractitemmodel;
    import qt.core.bytearray;
    import qt.core.itemselectionmodel;
    import qt.core.line;
    import qt.core.locale;
    import qt.core.namespace;
    import qt.core.pair;
    import qt.core.point;
    import qt.core.size;
    import qt.core.timezone;
    import qt.core.url;

    checkType!(double, 1, 0, 0)();
    checkType!(int, 1, 0, 0)();
    checkType!(uint, 1, 0, 0)();
    checkType!(int*, 1, 0, 0)();
    checkType!(void*, 1, 0, 0)();
    checkType!(void, 0, 0, 0)();
    checkType!(QLocale.Country, 1, 0, 1)();
    checkType!(/+ Qt:: +/qt.core.namespace.DayOfWeek, 1, 0, 1)();
    checkType!(QTimeZone.OffsetData, 1, 1, 0)();
    checkType!(QByteArray, 1, 1, 0)();
    checkType!(QItemSelectionRange, 1, 1, 0)();
    checkType!(QLine, 1, 1, 0)();
    checkType!(QLineF, 1, 1, 0)();
    checkType!(QLocale, 1, 1, 0)();
    checkType!(QModelIndex, 1, 1, 0)();
    checkType!(QObject, 1, 0, 0)();
    checkType!(QPair!(double, QSize), 1, 1, 0)();
    checkType!(QPersistentModelIndex, 1, 1, 0)();
    checkType!(QPoint, 1, 1, 0)();
    checkType!(QPointF, 1, 1, 0)();
    checkType!(QSize, 1, 1, 0)();
    checkType!(QString, 1, 1, 0)();
    checkType!(QStringRef, 1, 0, 0)();
    checkType!(QUrl, 1, 1, 0)();
    checkType!(QVariant, 1, 1, 0)();
    checkType!(QAbstractItemModel, 1, 0, 0)();
    checkType!(QTimeZone.OffsetData, 1, 1, 0)();
    checkType!(QList!(int), 1, 1, 0)();
    checkType!(QList!(void*), 1, 1, 0)();
    checkType!(QList!(QSize), 1, 1, 0)();
    checkType!(QVector!(int), 1, 1, 0)();
    checkType!(QVector!(void*), 1, 1, 0)();
    checkType!(QVector!(QSize), 1, 1, 0)();
    checkType!(/+ Qt:: +/qt.core.namespace.Edge, 1, 0, 1)();
    checkType!(/+ Qt:: +/qt.core.namespace.Edges, 1, 0, 0)();
}

unittest
{
    import core.stdc.string;
    import qt.core.objectdefs;

    const(QMetaObject)* mo = &TestObject.staticMetaObject;
    assert(strcmp(mo.className(), "TestObject") == 0);
    //assert(mo->constructorCount() == 2);
    assert(mo.methodCount() - mo.methodOffset() == 8 + 8 + 8);
}

void connectByString(TestObject a, TestObject b)
{
    import qt.core.object;
    import qt.core.objectdefs;

    QObject.connect(a, (mixin(SIGNAL(q{signalVoid()}))).ptr, b, (mixin(SLOT(q{onSignalVoid()}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalInt(int)}))).ptr, b, (mixin(SLOT(q{onSignalInt(int)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalInt3(int,int,int)}))).ptr, b, (mixin(SLOT(q{onSignalInt3(int,int,int)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalDouble(double)}))).ptr, b, (mixin(SLOT(q{onSignalDouble(double)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalString(const QString&)}))).ptr, b, (mixin(SLOT(q{onSignalString(const QString&)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalListInt(const QList<int>&)}))).ptr, b, (mixin(SLOT(q{onSignalListInt(const QList<int>&)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalVectorInt(const QVector<int>&)}))).ptr, b, (mixin(SLOT(q{onSignalVectorInt(const QVector<int>&)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalPointerInt(int*)}))).ptr, b, (mixin(SLOT(q{onSignalPointerInt(int*)}))).ptr);
}

void connectByPointer(TestObject a, TestObject b)
{
    import qt.core.list;
    import qt.core.object;
    import qt.core.vector;

    QObject.connect(a.signal!"signalVoid", b.slot!"onSignalVoid");
    QObject.connect(a.signal!"signalInt", b.slot!"onSignalInt");
    QObject.connect(a.signal!"signalInt3", b.slot!"onSignalInt3");
    QObject.connect(a.signal!"signalDouble", b.slot!"onSignalDouble");
    QObject.connect(a.signal!"signalString", b.slot!"onSignalString");
    QObject.connect(a.signal!"signalListInt", b.slot!"onSignalListInt");
    QObject.connect(a.signal!"signalVectorInt", b.slot!"onSignalVectorInt");
    QObject.connect(a.signal!"signalPointerInt", b.slot!"onSignalPointerInt");
}

void testSignals(TestObject a, TestObject b)
{
    import qt.core.list;
    import qt.core.vector;

    a.emitSignalVoid();
    assert(b.lastStr == "void");
    a.emitSignalInt(5);
    assert(b.lastStr == "int 5");
    a.emitSignalInt3(1, 2, 3);
    assert(b.lastStr == "int3 1 2 3");
    a.emitSignalDouble(16.5);
    assert(b.lastStr == "double 16.5");
    auto tmp = QString("test"); a.emitSignalString(tmp);
    assert(b.lastStr == "QString test");
    QList!(int) l = QList!(int).create();
    l ~= 10;
    l ~= 11;
    l ~= 12;
    a.emitSignalListInt(l);
    assert(b.lastStr == "QList<int> 10 11 12");
    QVector!(int) v = QVector!(int).create();
    v ~= 20;
    v ~= 21;
    v ~= 22;
    a.emitSignalVectorInt(v);
    assert(b.lastStr == "QVector<int> 20 21 22");
    int x = 30;
    a.emitSignalPointerInt(&x);
    assert(b.lastStr == "int* 30");
}

unittest
{
    import core.stdcpp.new_;

    TestObject a = cpp_new!TestObject();
    TestObject b = cpp_new!TestObject();
    connectByString(a, b);
    testSignals(a, b);
}

unittest
{
    import core.stdcpp.new_;

    TestObject a = cpp_new!TestObject();
    TestObject b = cpp_new!TestObject();
    connectByPointer(a, b);
    testSignals(a, b);
}

void compareVariant(ref const(QVariant) v, const(char)* expected)
{
    import core.stdc.stdio;

    char[(v). sizeof * 3 + 1] buffer;
    size_t pos = 0;
    for(size_t i=0; i<(v). sizeof; i++)
    {
        snprintf(&buffer[pos], 3, "%02X", (cast(ubyte*)&v)[i]);
        pos += 2;
        if(i % 4 == 3 && i + 1 < (v). sizeof)
        {
            buffer[pos] = ' ';
            pos++;
        }
    }
    buffer[pos] = 0;
    bool different = false;
    for(size_t i=0; i<pos; i++)
    {
        if(!expected[i])
            break;
        if(expected[i] == '?')
            continue;
        if(buffer[i] != expected[i])
            different = true;
    }
    if(different)
    {
        printf("expected: %s\n", expected);
        printf("got:      %s\n", buffer.ptr);
        assert(false);
    }
}

unittest
{
    QVariant v;
    compareVariant(v, "00000000 ???????? 00000080");
    v = QVariant(5);
    compareVariant(v, "05000000 ???????? 02000000");
    v = QVariant(100.0f);
    compareVariant(v, "0000C842 ???????? 26000000");
    v = QVariant(100.0);
    compareVariant(v, "00000000 00005940 06000000");
    v = QVariant(cast(int)'A');
    compareVariant(v, "41000000 ???????? 02000000");
}

unittest
{
    import qt.core.objectdefs;

    size_t changeCount = 0;
    {
        scope QObject dummy = new QObject;
        QObject.connect(QCoreApplication.instance().signal!"applicationNameChanged", dummy, (){
            changeCount++;
        });
        assert(changeCount == 0);
        QCoreApplication.setApplicationName(QString("ApplicationName1"));
        assert(changeCount == 1);
    }
    QCoreApplication.setApplicationName(QString("ApplicationName2"));
    // Slot was not called again, because dummy is out of scope.
    assert(changeCount == 1);

    scope QObject dummy = new QObject;
    QMetaObject.Connection connection = QObject.connect(QCoreApplication.instance().signal!"applicationNameChanged", dummy, (){
        changeCount++;
    });
    assert(changeCount == 1);

    QCoreApplication.setApplicationName(QString("ApplicationName3"));
    assert(changeCount == 2);

    QObject.disconnect(connection);
    QCoreApplication.setApplicationName(QString("ApplicationName4"));
    assert(changeCount == 2);
}

unittest
{
    import core.stdcpp.new_;
    import qt.core.timer;

    QObject obj = cpp_new!QObject();
    assert(qobject_cast!(QObject)(obj) is obj);
    assert(qobject_cast!(TestObject)(obj) is null);
    assert(qobject_cast!(QTimer)(obj) is null);

    TestObject testObject = cpp_new!TestObject();
    assert(qobject_cast!(QObject)(testObject) is testObject);
    assert(qobject_cast!(TestObject)(testObject) is testObject);
    assert(qobject_cast!(QTimer)(testObject) is null);

    QTimer timer = cpp_new!QTimer();
    assert(qobject_cast!(QObject)(timer) is timer);
    assert(qobject_cast!(TestObject)(timer) is null);
    assert(qobject_cast!(QTimer)(timer) is timer);
}
