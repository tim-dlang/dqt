// QT_MODULES: core
module testcore1;

import qt.config;
import qt.core.coreapplication;
import qt.core.list;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.variant;
import qt.core.vector;
import qt.helpers;
import std.stdio;
import std.string;

QCoreApplication app;
bool sameRuntimeVersion;
shared static this()
{
    import core.runtime;
    import core.stdc.stdio;
    import core.stdcpp.new_;
    import qt.core.config;
    import qt.core.libraryinfo;
    import qt.core.versionnumber;

    app = new QCoreApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);
    assert(QCoreApplication.instance() is app);

    QVersionNumber runtimeVersion = QLibraryInfo.version_();
    printf("Qt runtime version: %d.%d.%d\n", runtimeVersion.majorVersion(), runtimeVersion.minorVersion(), runtimeVersion.microVersion());
    printf("Qt header version: %d.%d.%d\n", QT_VERSION_MAJOR, QT_VERSION_MINOR, QT_VERSION_PATCH);
    sameRuntimeVersion = runtimeVersion.majorVersion() == QT_VERSION_MAJOR && runtimeVersion.minorVersion() == QT_VERSION_MINOR;
    if (!sameRuntimeVersion)
        printf("Some tests are disabled, because the Qt runtime version is different from the header version.\n");
}

@Q_DECLARE_METATYPE extern(C++) struct CustomStruct1
{
    int i = 0;
    static __gshared int numConstructed;
    static __gshared int numCopied;
    static __gshared int numDestructed;

    this(int i)
    {
        this.i = i;

        numConstructed++;
    }
    @disable this(this);
    this(ref const(CustomStruct1) other)
    {
        this.i =  other.i;

        numCopied++;
    }
    ~this()
    {
        i = -1;
        numDestructed++;
    }
}
/+ Q_DECLARE_METATYPE(CustomStruct1); +/

class TestObject : QObject
{
    mixin(Q_OBJECT_D);
public:
    /+ explicit +/@QInvokable this(QObject parent = null)
    {
        super(parent);
        lastStr = QString.create;
        m_string1 = QString.create;
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
    @QInvokable final void emitSignalObjects(QObject o1, TestObject o2)
    {
        /+ emit +/ signalObjects(o1, o2);
    }
    @QInvokable final void emitSignalCustomStruct1(CustomStruct1 s)
    {
        /+ emit +/ signalCustomStruct1(s);
    }

/+ signals +/public:
    @QSignal final void signalVoid() {mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalInt(int i) {mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalInt3(int x, int y, int z) {mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalDouble(double d) {mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalString(ref const(QString) s) {mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalListInt(ref const(QList!(int)) l) {mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalVectorInt(ref const(QVector!(int)) v) {mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalPointerInt(int* p) {mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalObjects(QObject o1, TestObject o2) {mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalCustomStruct1(CustomStruct1 s) {mixin(Q_SIGNAL_IMPL_D);}

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
        for (int i=0; i<l.size(); i++)
            lastStr ~= " " ~ QString.number(l[i]);
    }
    @QSlot final void onSignalVectorInt(ref const(QVector!(int)) v)
    {
        lastStr = QString("QVector<int>");
        for (int i=0; i<v.size(); i++)
            lastStr ~= " " ~ QString.number(v[i]);
    }
    @QSlot final void onSignalPointerInt(int* p)
    {
        lastStr = "int* " ~ QString.number(*p) ~ " 0x" ~ QString.number(cast(ulong) p, 16);
    }
    @QSlot final void onSignalObjects(QObject o1, TestObject o2)
    {
        lastStr = "objects " ~ o1.objectName() ~ " " ~ QString(fromStringz(o1.metaObject().className())) ~ " 0x" ~ QString.number(cast(ulong) cast(void*) o1, 16)
                       ~ " " ~ o2.objectName() ~ " " ~ QString(fromStringz(o2.metaObject().className())) ~ " 0x" ~ QString.number(cast(ulong) cast(void*) o2, 16);
    }
    @QSlot final void onSignalCustomStruct1(CustomStruct1 s)
    {
        lastStr = "CustomStruct1 " ~ QString.number(s.i);
    }

    private bool m_bool1 = false;
    @QPropertyDef
    {
        final bool bool1() const
        {
            return m_bool1;
        }
        final void setBool1(bool bool1)
        {
            if (m_bool1 != bool1)
            {
                m_bool1 = bool1;
                /+ emit +/ bool1Changed();
            }
        }
        @QSignal final void bool1Changed() {mixin(Q_SIGNAL_IMPL_D);}
    }

    @QPropertyDef("notBool1", notify: "bool1Changed")
    {
        final bool notBool1() const
        {
            return !m_bool1;
        }
    }

    @QPropertyDef("bool2")
    {
        private bool m_bool2 = false;
        @QSignal final void bool2Changed() {mixin(Q_SIGNAL_IMPL_D);}
    }

    private QString m_string1;
    @QPropertyDef
    {
        final QString string1() const
        {
            return m_string1;
        }
        final void setString1(ref const(QString) string1)
        {
            if (m_string1 != string1)
            {
                m_string1 = string1;
                /+ emit +/ string1Changed();
            }
        }
        @QSignal final void string1Changed() {mixin(Q_SIGNAL_IMPL_D);}
    }

    @QPropertyDef(isConstant: true) final uint pointerSize()
    {
        return cast(uint) ((void*).sizeof);
    }

    @QInvokable final QString toUpper(ref const(QString) s)
    {
        return s.toUpper();
    }

    mixin(CREATE_CONVENIENCE_WRAPPERS);
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

void checkType(T, bool isDefined1, bool isDefined2, int id, int flags)()
{
    int realId = /+ QtPrivate:: +/qt.core.metatype.QMetaTypeIdHelper!(T).qt_metatype_id();
    /*string idName;
    if (/+ QtPrivate:: +/qt.core.metatype.QMetaTypeIdHelper!(T).qt_metatype_id() < 0)
        idName = "-1";
    else if (/+ QtPrivate:: +/qt.core.metatype.QMetaTypeIdHelper!(T).qt_metatype_id() < QMetaType.Type.User)
        idName = "QMetaType.Type." ~ T.stringof;
    else
        idName = "QMetaType.Type.User";
    writef("    checkType!(%s, %d, %d, %s, ", T.stringof, QMetaTypeId!T.Defined, QMetaTypeId2!T.Defined, idName);
    bool first = true;
    foreach (name; __traits(allMembers, QMetaType.TypeFlag))
    {
        if (name == "MovableType") // alias
            continue;
        if (QMetaTypeTypeFlags!T.Flags & __traits(getMember, QMetaType.TypeFlag, name))
        {
            if (!first)
                write(" | ");
            write("QMetaType.TypeFlag.", name);
            first = false;
        }
    }
    if (first)
        write("0");
    writeln(")();");*/

    enum bool relocatable = (flags & QMetaType.TypeFlag.RelocatableType) != 0;
    enum bool complex = (flags & QMetaType.TypeFlag.NeedsConstruction) != 0;

    static assert(QTypeInfo!(T).isRelocatable == relocatable);
    static assert(QTypeInfo!(T).isComplex == complex);
    static assert(QMetaTypeId!(T).Defined == isDefined1);
    static assert(QMetaTypeId2!(T).Defined == isDefined2);
    if (id < 0)
        assert(realId < 0);
    else if (id < QMetaType.Type.User)
        assert(realId == id);
    else
        assert(realId >= QMetaType.Type.User);
    static assert(/+ QtPrivate:: +/QMetaTypeTypeFlags!(T).Flags == flags);

    if (id >= 0)
    {
        import std.conv;
        QMetaType metaType = QMetaType(realId);
        assert(metaType.id() == realId);
        static if (!is(T == void))
            assert(metaType.sizeOf() == T.sizeof, text(T.stringof, " ", metaType.sizeOf(), " ", T.sizeof));
        if (sameRuntimeVersion)
            assert(metaType.flags() == flags, text(T.stringof, " ", metaType.flags(), " ", flags));

        T* instance = cast(T*) metaType.create();
        assert(instance || id == QMetaType.Type.Void);
        if (instance)
        {
            T* instance2 = cast(T*) metaType.create(instance);
            assert(instance2);
            assert(instance != instance2);
            metaType.destroy(instance);
            metaType.destroy(instance2);
        }
    }
}

unittest
{
    import core.stdc.wchar_;
    import qt.core.abstractitemmodel;
    import qt.core.bytearray;
    import qt.core.bytearraylist;
    import qt.core.flags;
    import qt.core.global;
    import qt.core.itemselectionmodel;
    import qt.core.line;
    import qt.core.locale;
    import qt.core.pair;
    import qt.core.point;
    import qt.core.qchar;
    import qt.core.size;
    import qt.core.stringlist;
    import qt.core.stringview;
    import qt.core.timezone;
    import qt.core.url;

    checkType!(float, 0, 1, QMetaType.Type.Float, QMetaType.TypeFlag.RelocatableType)();
    checkType!(double, 0, 1, QMetaType.Type.Double, QMetaType.TypeFlag.RelocatableType)();
    checkType!(qreal, 0, 1, QMetaType.Type.QReal, QMetaType.TypeFlag.RelocatableType)();
    checkType!(int, 0, 1, QMetaType.Type.Int, QMetaType.TypeFlag.RelocatableType)();
    checkType!(uint, 0, 1, QMetaType.Type.UInt, QMetaType.TypeFlag.RelocatableType)();
    checkType!(int*, 0, 0, -1, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsPointer)();
    checkType!(void*, 0, 1, QMetaType.Type.VoidStar, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsPointer)();
    checkType!(void, 0, 1, QMetaType.Type.Void, 0)();
    checkType!(char, 0, 1, QMetaType.Type.Char, QMetaType.TypeFlag.RelocatableType)();
    checkType!(ubyte, 0, 1, QMetaType.Type.UChar, QMetaType.TypeFlag.RelocatableType)();
    checkType!(wchar, 0, 1, QMetaType.Type.Char16, QMetaType.TypeFlag.RelocatableType)();
    checkType!(dchar, 0, 1, QMetaType.Type.Char32, QMetaType.TypeFlag.RelocatableType)();
    //checkType!(wchar_t, 0, 0, -1, QMetaType.TypeFlag.RelocatableType)();
    checkType!(QChar, 0, 1, QMetaType.Type.QChar, QMetaType.TypeFlag.RelocatableType)();
    checkType!(QLocale.Country, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsEnumeration | QMetaType.TypeFlag.IsUnsignedEnumeration)();
    checkType!(/+ Qt:: +/qt.core.namespace.DayOfWeek, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsEnumeration | QMetaType.TypeFlag.IsUnsignedEnumeration)();
    checkType!(QTimeZone.OffsetData, 0, 0, -1, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QByteArray, 0, 1, QMetaType.Type.QByteArray, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QItemSelectionRange, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QLine, 0, 1, QMetaType.Type.QLine, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QLineF, 0, 1, QMetaType.Type.QLineF, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QLocale, 1, 1, QMetaType.Type.QLocale, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsGadget)();
    checkType!(QLocale*, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.PointerToGadget | QMetaType.TypeFlag.IsPointer)();
    checkType!(QModelIndex, 0, 1, QMetaType.Type.QModelIndex, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QObject, 1, 1, QMetaType.Type.QObjectStar, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.PointerToQObject | QMetaType.TypeFlag.IsPointer)();
    checkType!(/+ std:: +/pair!(double, QSize), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QPersistentModelIndex, 0, 1, QMetaType.Type.QPersistentModelIndex, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QPoint, 0, 1, QMetaType.Type.QPoint, QMetaType.TypeFlag.RelocatableType)();
    checkType!(QPointF, 0, 1, QMetaType.Type.QPointF, QMetaType.TypeFlag.RelocatableType)();
    checkType!(QSize, 0, 1, QMetaType.Type.QSize, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QString, 0, 1, QMetaType.Type.QString, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QStringView, 0, 0, -1, QMetaType.TypeFlag.RelocatableType)();
    checkType!(QUrl, 0, 1, QMetaType.Type.QUrl, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QVariant, 0, 1, QMetaType.Type.QVariant, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QAbstractItemModel, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.PointerToQObject | QMetaType.TypeFlag.IsPointer)();
    checkType!(QTimeZone.OffsetData, 0, 0, -1, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QList!(int), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QList!(void*), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QList!(QSize), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QList!(QLocale), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QVector!(int), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QVector!(void*), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QVector!(QSize), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QVector!(QLocale), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QStringList, 1, 1, QMetaType.Type.QStringList, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QVariantList, 1, 1, QMetaType.Type.QVariantList, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(QByteArrayList, 1, 1, QMetaType.Type.QByteArrayList, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!(/+ Qt:: +/qt.core.namespace.Edge, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsEnumeration | QMetaType.TypeFlag.IsUnsignedEnumeration)();
    checkType!(QFlags!(/+ Qt:: +/qt.core.namespace.Edge), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsEnumeration)();
    checkType!(QList!(/+ Qt:: +/qt.core.namespace.Edge), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();
    checkType!( QList!(QFlags!(/+ Qt:: +/qt.core.namespace.Edge)), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType)();

    CustomStruct1.numConstructed = CustomStruct1.numCopied = CustomStruct1.numDestructed = 0;
    checkType!(CustomStruct1, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction)();
    assert(CustomStruct1.numConstructed == 0);
    assert(CustomStruct1.numCopied == 1);
    assert(CustomStruct1.numDestructed == 2);
}

unittest
{
    import core.stdc.string;
    import core.stdcpp.new_;
    import qt.core.metaobject;
    import qt.core.objectdefs;

    const(QMetaObject)* mo = &TestObject.staticMetaObject;
    assert(strcmp(mo.className(), "TestObject") == 0);
    //assert(mo->constructorCount() == 2);
    assert(mo.methodCount() - mo.methodOffset() == 10 + 10 + 10 + 3 + 1);

    TestObject a = cpp_new!TestObject();
    assert(a.metaObject() == mo);

    QMetaMethod method = mo.method(mo.methodOffset() + 0);
    assert(method.name().toConstCharArray() == "signalVoid");
    assert(method.methodSignature().toConstCharArray() == "signalVoid()");
    assert(method.parameterCount() == 0);

    method = mo.method(mo.methodOffset() + 1);
    assert(method.name().toConstCharArray() == "signalInt");
    assert(method.methodSignature().toConstCharArray() == "signalInt(int)");
    assert(method.parameterCount() == 1);
    assert(method.parameterType(0) == QMetaType.Type.Int);

    method = mo.method(mo.methodOffset() + 2);
    assert(method.name().toConstCharArray() == "signalInt3");
    assert(method.methodSignature().toConstCharArray() == "signalInt3(int,int,int)");
    assert(method.parameterCount() == 3);
    assert(method.parameterType(0) == QMetaType.Type.Int);
    assert(method.parameterType(1) == QMetaType.Type.Int);
    assert(method.parameterType(2) == QMetaType.Type.Int);

    method = mo.method(mo.methodOffset() + 3);
    assert(method.name().toConstCharArray() == "signalDouble");
    assert(method.methodSignature().toConstCharArray() == "signalDouble(double)");
    assert(method.parameterCount() == 1);
    assert(method.parameterType(0) == QMetaType.Type.Double);

    method = mo.method(mo.methodOffset() + 4);
    assert(method.name().toConstCharArray() == "signalString");
    assert(method.methodSignature().toConstCharArray() == "signalString(QString)");
    assert(method.parameterCount() == 1);
    assert(method.parameterType(0) == QMetaType.Type.QString);

    method = mo.method(mo.methodOffset() + 5);
    assert(method.name().toConstCharArray() == "signalListInt");
    assert(method.methodSignature().toConstCharArray() == "signalListInt(QList<int>)");
    assert(method.parameterCount() == 1);
    assert(method.parameterType(0) == qMetaTypeId!(QList!(int))());

    method = mo.method(mo.methodOffset() + 6);
    assert(method.name().toConstCharArray() == "signalVectorInt");
    assert(method.methodSignature().toConstCharArray() == "signalVectorInt(QList<int>)");
    assert(method.parameterCount() == 1);
    assert(method.parameterType(0) == qMetaTypeId!(QVector!(int))());

    method = mo.method(mo.methodOffset() + 7);
    assert(method.name().toConstCharArray() == "signalPointerInt");
    assert(method.methodSignature().toConstCharArray() == "signalPointerInt(int*)");
    assert(method.parameterCount() == 1);

    method = mo.method(mo.methodOffset() + 8);
    assert(method.name().toConstCharArray() == "signalObjects");
    assert(method.methodSignature().toConstCharArray() == "signalObjects(QObject*,TestObject*)");
    assert(method.parameterCount() == 2);
    assert(method.parameterType(0) == QMetaType.Type.QObjectStar);

    method = mo.method(mo.methodOffset() + 9);
    assert(method.name().toConstCharArray() == "signalCustomStruct1");
    assert(method.methodSignature().toConstCharArray() == "signalCustomStruct1(CustomStruct1)");
    assert(method.parameterCount() == 1);

    method = mo.method(mo.methodOffset() + 33);
    assert(method.name().toConstCharArray() == "toUpper");
    assert(method.methodSignature().toConstCharArray() == "toUpper(QString)");
    assert(method.parameterCount() == 1);
    assert(method.parameterType(0) == QMetaType.Type.QString);
    assert(method.returnType() == QMetaType.Type.QString);

    assert(mo.propertyCount() - mo.propertyOffset() == 5);
    QMetaProperty prop = mo.property(mo.propertyOffset() + 0);
    assert(fromStringz(prop.name()) == "bool1");
    assert(prop.typeId() == QMetaType.Type.Bool);
    assert(prop.isWritable());
    assert(prop.isReadable());
    assert(!prop.isConstant());
    assert(prop.hasNotifySignal());
    assert(prop.notifySignalIndex() == mo.methodOffset() + 10);
    assert(mo.method(prop.notifySignalIndex()).name().toConstCharArray() == "bool1Changed");

    prop = mo.property(mo.propertyOffset() + 1);
    assert(fromStringz(prop.name()) == "notBool1");
    assert(prop.typeId() == QMetaType.Type.Bool);
    assert(!prop.isWritable());
    assert(prop.isReadable());
    assert(!prop.isConstant());
    assert(prop.hasNotifySignal());
    assert(prop.notifySignalIndex() == mo.methodOffset() + 10);
    assert(mo.method(prop.notifySignalIndex()).name().toConstCharArray() == "bool1Changed");

    prop = mo.property(mo.propertyOffset() + 2);
    assert(fromStringz(prop.name()) == "bool2");
    assert(prop.typeId() == QMetaType.Type.Bool);
    assert(prop.isWritable());
    assert(prop.isReadable());
    assert(!prop.isConstant());
    assert(prop.hasNotifySignal());
    assert(prop.notifySignalIndex() == mo.methodOffset() + 11);
    assert(mo.method(prop.notifySignalIndex()).name().toConstCharArray() == "bool2Changed");

    prop = mo.property(mo.propertyOffset() + 3);
    assert(fromStringz(prop.name()) == "string1");
    assert(prop.typeId() == QMetaType.Type.QString);
    assert(prop.isWritable());
    assert(prop.isReadable());
    assert(!prop.isConstant());
    assert(prop.hasNotifySignal());
    assert(prop.notifySignalIndex() == mo.methodOffset() + 12);
    assert(mo.method(prop.notifySignalIndex()).name().toConstCharArray() == "string1Changed");

    prop = mo.property(mo.propertyOffset() + 4);
    assert(fromStringz(prop.name()) == "pointerSize");
    assert(prop.typeId() == QMetaType.Type.UInt);
    assert(!prop.isWritable());
    assert(prop.isReadable());
    assert(prop.isConstant());
    assert(!prop.hasNotifySignal());
}

void connectByString(TestObject a, TestObject b)
{
    import qt.core.object;
    import qt.core.objectdefs;

    QObject.connect(a, (mixin(SIGNAL(q{signalVoid()}))).ptr, b, (mixin(SLOT(q{onSignalVoid()}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalInt(int)}))).ptr, b, (mixin(SLOT(q{onSignalInt(int)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalInt3(int, int, int)}))).ptr, b, (mixin(SLOT(q{onSignalInt3(int, int, int)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalDouble(double)}))).ptr, b, (mixin(SLOT(q{onSignalDouble(double)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalString(const QString &)}))).ptr, b, (mixin(SLOT(q{onSignalString(const QString &)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalListInt(const QList<int> &)}))).ptr, b, (mixin(SLOT(q{onSignalListInt(const QList<int> &)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalVectorInt(const QVector<int> &)}))).ptr, b, (mixin(SLOT(q{onSignalVectorInt(const QVector<int> &)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalPointerInt(int *)}))).ptr, b, (mixin(SLOT(q{onSignalPointerInt(int *)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalObjects(QObject*,TestObject*)}))).ptr, b, (mixin(SLOT(q{onSignalObjects(QObject*,TestObject*)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalCustomStruct1(CustomStruct1)}))).ptr, b, (mixin(SLOT(q{onSignalCustomStruct1(CustomStruct1)}))).ptr);
}

void connectByPointer(TestObject a, TestObject b, /+ Qt:: +/qt.core.namespace.ConnectionType type = /+ Qt:: +/qt.core.namespace.ConnectionType.AutoConnection)
{
    import qt.core.list;
    import qt.core.object;
    import qt.core.vector;

    QObject.connect(a.signal!"signalVoid", b.slot!"onSignalVoid", type);
    QObject.connect(a.signal!"signalInt", b.slot!"onSignalInt", type);
    QObject.connect(a.signal!"signalInt3", b.slot!"onSignalInt3", type);
    QObject.connect(a.signal!"signalDouble", b.slot!"onSignalDouble", type);
    QObject.connect(a.signal!"signalString", b.slot!"onSignalString", type);
    QObject.connect(a.signal!"signalListInt", b.slot!"onSignalListInt", type);
    QObject.connect(a.signal!"signalVectorInt", b.slot!"onSignalVectorInt", type);
    QObject.connect(a.signal!"signalPointerInt", b.slot!"onSignalPointerInt", type);
    QObject.connect(a.signal!"signalObjects", b.slot!"onSignalObjects", type);
    QObject.connect(a.signal!"signalCustomStruct1", b.slot!"onSignalCustomStruct1", type);
}

void testSignals(TestObject a, void delegate(string) check)
{
    import core.stdcpp.new_;
    import qt.core.list;
    import qt.core.timer;
    import qt.core.vector;

    CustomStruct1.numConstructed = CustomStruct1.numCopied = CustomStruct1.numDestructed = 0;
    a.emitSignalVoid();
    check("void");
    a.emitSignalInt(5);
    check("int 5");
    a.emitSignalInt3(1, 2, 3);
    check("int3 1 2 3");
    a.emitSignalDouble(16.5);
    check("double 16.5");
    auto tmp = QString("test"); a.emitSignalString(tmp);
    check("QString test");
    QList!(int) l = QList!(int).create();
    l ~= 10;
    l ~= 11;
    l ~= 12;
    a.emitSignalListInt(l);
    check("QList<int> 10 11 12");
    QVector!(int) v = QVector!(int).create();
    v ~= 20;
    v ~= 21;
    v ~= 22;
    a.emitSignalVectorInt(v);
    check("QVector<int> 20 21 22");
    int *x = new int;
    *x = 30;
    a.emitSignalPointerInt(x);
    check(format("int* 30 0x%x", cast(ulong) x));
    QObject o1 = cpp_new!QTimer(a);
    o1.setObjectName("obj1");
    TestObject o2 = cpp_new!TestObject(a);
    o2.setObjectName("obj2");
    a.emitSignalObjects(o1, o2);
    check(format("objects obj1 QTimer 0x%x obj2 TestObject 0x%x", cast(ulong) cast(void*) o1, cast(ulong) cast(void*) o2));
    a.emitSignalCustomStruct1(CustomStruct1(50));
    check("CustomStruct1 50");
}

unittest
{
    import core.stdcpp.new_;

    TestObject a = cpp_new!TestObject();
    TestObject b = cpp_new!TestObject();
    connectByString(a, b);
    testSignals(a, (string expected) {
        assert(b.lastStr == expected);
    });
    assert(CustomStruct1.numConstructed == 1);
    assert(CustomStruct1.numCopied == 2);
    assert(CustomStruct1.numDestructed == 3);

    cpp_delete(a);
    cpp_delete(b);
}

unittest
{
    import core.stdcpp.new_;

    TestObject a = cpp_new!TestObject();
    TestObject b = cpp_new!TestObject();
    connectByPointer(a, b);
    testSignals(a, (string expected) {
        assert(b.lastStr == expected);
    });
    assert(CustomStruct1.numConstructed == 1);
    assert(CustomStruct1.numCopied == 2);
    assert(CustomStruct1.numDestructed == 3);

    cpp_delete(a);
    cpp_delete(b);
}

unittest
{
    import core.stdcpp.new_;
    import qt.core.eventloop;
    import qt.core.stringlist;
    import std.conv;

    scope eventLoop = new QEventLoop;
    TestObject a = cpp_new!TestObject();
    TestObject b = cpp_new!TestObject();
    connectByPointer(a, b, /+ Qt:: +/qt.core.namespace.ConnectionType.QueuedConnection);

    string[] receivedValues;
    string[] expectedValues;

    TestObject dummy = cpp_new!TestObject();
    QObject.connect(dummy.signal!"signalVoid", eventLoop, () {
        receivedValues ~= text(b.lastStr.toConstWString);
    }, /+ Qt:: +/qt.core.namespace.ConnectionType.QueuedConnection);

    TestObject dummy2 = cpp_new!TestObject();
    QObject.connect(dummy2.signal!"signalVoid", eventLoop.slot!"quit", /+ Qt:: +/qt.core.namespace.ConnectionType.QueuedConnection);

    testSignals(a, (string expected) {
        expectedValues ~= expected;
        dummy.emitSignalVoid();
    });

    dummy2.emitSignalVoid();

    assert(receivedValues.length == 0);
    assert(CustomStruct1.numConstructed == 1);
    assert(CustomStruct1.numCopied == 2);
    assert(CustomStruct1.numDestructed == 2);

    eventLoop.exec();

    assert(receivedValues == expectedValues);
    assert(CustomStruct1.numConstructed == 1);
    assert(CustomStruct1.numCopied == 3);
    assert(CustomStruct1.numDestructed == 4);

    cpp_delete(a);
    cpp_delete(b);
}

unittest
{
    import core.stdcpp.new_;
    import qt.core.stringlist;
    import qt.core.thread;
    import std.conv;

    QThread thread = cpp_new!QThread;
    TestObject a = cpp_new!TestObject();
    TestObject b = cpp_new!TestObject();
    b.moveToThread(thread);
    connectByPointer(a, b);

    string[] receivedValues;
    string[] expectedValues;

    TestObject dummy = cpp_new!TestObject();
    dummy.moveToThread(thread);
    QObject.connect(dummy.signal!"signalVoid", dummy, () {
        receivedValues ~= text(b.lastStr.toConstWString);
    });

    TestObject dummy2 = cpp_new!TestObject();
    dummy2.moveToThread(thread);
    QObject.connect(dummy.signal!"signalVoid", dummy2, () {
        thread.quit();
    });

    testSignals(a, (string expected) {
        expectedValues ~= expected;
        dummy.emitSignalVoid();
    });

    dummy2.emitSignalVoid();

    assert(receivedValues.length == 0);
    assert(CustomStruct1.numConstructed == 1);
    assert(CustomStruct1.numCopied == 2);
    assert(CustomStruct1.numDestructed == 2);

    thread.start();
    thread.wait();

    assert(receivedValues == expectedValues);
    assert(CustomStruct1.numConstructed == 1);
    assert(CustomStruct1.numCopied == 3);
    assert(CustomStruct1.numDestructed == 4);

    cpp_delete(a);
    cpp_delete(b);
}

void compareVariant(ref const(QVariant) v, const(char)* expected)
{
    import core.stdc.stdio;

    char[(v). sizeof * 3 + 1] buffer;
    size_t pos = 0;
    for (size_t i=0; i<(v). sizeof; i++)
    {
        snprintf(&buffer[pos], 3, "%02X", (cast(ubyte*)&v)[i]);
        pos += 2;
        if (i % 4 == 3 && i + 1 < (v). sizeof)
        {
            buffer[pos] = ' ';
            pos++;
        }
    }
    buffer[pos] = 0;
    bool different = false;
    for (size_t i=0; i<pos; i++)
    {
        if (!expected[i])
            break;
        if (expected[i] == '?')
            continue;
        if (buffer[i] != expected[i])
            different = true;
    }
    if (different)
    {
        printf("expected: %s\n", expected);
        printf("got:      %s\n", buffer.ptr);
        assert(false);
    }
}

unittest
{
    QVariant v;
    static if ((void*).sizeof == 8)
        compareVariant(v, "00000000 00000000 00000000 00000000 00000000 00000000 02000000 00000000");
    else
        compareVariant(v, "00000000 00000000 00000000 02000000");
    v = QVariant(5);
    static if ((void*).sizeof == 8)
        compareVariant(v, "05000000 00000000 00000000 00000000 00000000 00000000 ???????? ????????");
    else
        compareVariant(v, "05000000 00000000 00000000 ????????");
    v = QVariant(100.0f);
    static if ((void*).sizeof == 8)
        compareVariant(v, "0000C842 00000000 00000000 00000000 00000000 00000000 ???????? ????????");
    else
        compareVariant(v, "0000C842 00000000 00000000 ????????");
    v = QVariant(100.0);
    static if ((void*).sizeof == 8)
        compareVariant(v, "00000000 00005940 00000000 00000000 00000000 00000000 ???????? ????????");
    else
        compareVariant(v, "00000000 00005940 00000000 ????????");
    v = QVariant(cast(int)'A');
    static if ((void*).sizeof == 8)
        compareVariant(v, "41000000 00000000 00000000 00000000 00000000 00000000 ???????? ????????");
    else
        compareVariant(v, "41000000 00000000 00000000 ????????");
}

unittest
{
    import qt.core.objectdefs;

    size_t changeCount = 0;
    {
        scope QObject dummy = new QObject;
        QObject.connect(QCoreApplication.instance().signal!"applicationNameChanged", dummy, () {
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
    QMetaObject.Connection connection = QObject.connect(QCoreApplication.instance().signal!"applicationNameChanged", dummy, () {
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

unittest
{
    import qt.core.algorithms;

    assert(qPopulationCount(0U) == 0);
    assert(qPopulationCount(0xffffU) == 16);
    assert(qPopulationCount(0xffffffffU) == 32);
    assert(qPopulationCount(0xffffffffffffffffU) == 64);
    assert(qPopulationCount(0x8000000000000000U) == 1);

    assert(qCountTrailingZeroBits(cast(ubyte)0U) == 8);
    assert(qCountTrailingZeroBits(cast(ushort)0U) == 16);
    assert(qCountTrailingZeroBits(0U) == 32);
    assert(qCountTrailingZeroBits(cast(ulong)0U) == 64);
    assert(qCountTrailingZeroBits(0x10U) == 4);
    assert(qCountTrailingZeroBits(0x1000U) == 12);
    assert(qCountTrailingZeroBits(0x80000000U) == 31);
    assert(qCountTrailingZeroBits(0x8000000000000000U) == 63);
    assert(qCountTrailingZeroBits(0xffffffff80000000U) == 31);

    assert(qCountLeadingZeroBits(cast(ubyte)0U) == 8);
    assert(qCountLeadingZeroBits(cast(ushort)0U) == 16);
    assert(qCountLeadingZeroBits(0U) == 32);
    assert(qCountLeadingZeroBits(cast(ulong)0U) == 64);
    assert(qCountLeadingZeroBits(0x10U) == 27);
    assert(qCountLeadingZeroBits(0x1000U) == 19);
    assert(qCountLeadingZeroBits(0x80000000U) == 0);
    assert(qCountLeadingZeroBits(0x8000000000000000U) == 0);
    assert(qCountLeadingZeroBits(0xffffffff80000000U) == 0);
}

unittest
{
    import core.stdcpp.new_;
    import qt.core.stringlist;

    TestObject o = cpp_new!TestObject();

    string[] changes;
    QObject.connect(o.signal!"bool1Changed", o, () {
        changes ~= "bool1Changed";
    });
    QObject.connect(o.signal!"bool2Changed", o, () {
        changes ~= "bool2Changed";
    });
    QObject.connect(o.signal!"string1Changed", o, () {
        changes ~= "string1Changed";
    });

    assert(o.property("bool1").toString() == "false");
    assert(o.property("notBool1").toString() == "true");
    assert(o.property("bool2").toString() == "false");
    assert(o.property("string1").toString() == "");

    o.setBool1(true);
    assert(changes == ["bool1Changed"]);
    assert(o.property("bool1").toString() == "true");
    assert(o.property("notBool1").toString() == "false");

    changes = [];
    o.setBool1(true);
    assert(changes == []);

    o.setProperty("bool1", false);
    assert(changes == ["bool1Changed"]);
    assert(o.property("bool1").toString() == "false");
    assert(o.property("notBool1").toString() == "true");

    changes = [];
    o.setProperty("bool2", true);
    assert(changes == ["bool2Changed"]);
    assert(o.property("bool2").toBool());

    changes = [];
    o.setString1("test1");
    assert(changes == ["string1Changed"]);
    assert(o.property("string1").toString() == "test1");

    changes = [];
    o.setProperty("string1", "test2");
    assert(changes == ["string1Changed"]);
    assert(o.property("string1").toString() == "test2");

    changes = [];
    o.setProperty("string1", "test2");
    assert(changes == []);

    assert(o.property("pointerSize").value!uint() == (void*).sizeof);

    cpp_delete(o);
}

unittest
{
    import core.stdcpp.new_;
    import qt.core.objectdefs;

    TestObject o = cpp_new!TestObject();

    QString s = QString("Test");
    QString s2 = o.toUpper(s);
    assert(s2 == "TEST");

    QString s3 = QString.create;
    s = QString("abc");
    QMetaObject.invokeMethod(o, "toUpper", mixin(Q_RETURN_ARG(q{QString}, q{s3})), mixin(Q_ARG(q{QString}, q{s})));
    assert(s3 == "ABC");

    cpp_delete(o);
}
