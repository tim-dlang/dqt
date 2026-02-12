// QT_MODULES: core
module testcore1;

import qt.config;
import qt.core.coreapplication;
import qt.core.flags;
import qt.core.list;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.variant;
import qt.core.vector;
import qt.helpers;
import std.conv;
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

    version (Android)
    {
        import imports.androidhelpers;
        registerAndroidJVM();
    }

    app = cpp_new!QCoreApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);
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
    string s;
    int id = 0;
    static __gshared int numConstructed;
    extern(D) static __gshared string[] log;

    extern(D) this(string s)
    {
        this.s = s;

        id = ++numConstructed;
        log ~= text("construct ", id, " ", s);
    }
    @disable this(this);
    this(ref const(CustomStruct1) other)
    {
        this.s = other.s;

        id = ++numConstructed;
        log ~= text("copy ", other.id, " -> ", id, " ", s);
    }
    ~this()
    {
        log ~= text("destruct ", id, " ", s);
        s = "destroyed";
    }
    ref CustomStruct1 opAssign()(auto ref const(CustomStruct1) other)
    {
        if (!id) {
            id = ++numConstructed;
            log ~= text("assign first ", id, " = ", other.id, " ", other.s);
        } else {
            log ~= text("assign ", id, " = ", other.id, " ", other.s);
        }
        s = other.s;
        return this;
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

    enum CustomEnum
    {
        a,
        b,
        c = 100,
        d
    }
    /+ Q_ENUM(CustomEnum) +/

    enum CustomFlag
    {
        a = 1,
        b = 2,
        c = 4,
        d = 8,
        e = 16
    }
    /+ Q_ENUM(CustomFlag) +/
    /+ Q_DECLARE_FLAGS(CustomFlags, CustomFlag) +/
    alias CustomFlags = QFlags!(CustomFlag);    /+ Q_FLAG(CustomFlags) +/

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
    @QInvokable final void emitSignalCustomStruct1ConstRef(ref const(CustomStruct1) s)
    {
        /+ emit +/ signalCustomStruct1ConstRef(s);
    }
    @QInvokable final void emitSignalCustomEnum(CustomEnum e)
    {
        /+ emit +/ signalCustomEnum(e);
    }
    @QInvokable final void emitSignalCustomFlags(CustomFlags f)
    {
        /+ emit +/ signalCustomFlags(f);
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
    @QSignal final void signalCustomStruct1ConstRef(ref const(CustomStruct1) s) {mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalCustomEnum(CustomEnum e) {mixin(Q_SIGNAL_IMPL_D);}
    @QSignal final void signalCustomFlags(CustomFlags f) {mixin(Q_SIGNAL_IMPL_D);}

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
        lastStr = QString("CustomStruct1 " ~ s.s);
    }
    @QSlot final void onSignalCustomStruct1ConstRef(ref const(CustomStruct1) s)
    {
        lastStr = QString("const ref CustomStruct1 " ~ s.s);
    }
    @QSlot final void onSignalCustomEnum(CustomEnum e)
    {
        lastStr = cast(QString) ("CustomEnum ".ptr ~ QString.number(cast(int)e));
    }
    @QSlot final void onSignalCustomFlags(CustomFlags f)
    {
        lastStr = cast(QString) ("CustomFlags ".ptr ~ QString.number(cast(int)f));
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

    private CustomStruct1 m_customStruct1;
    @QPropertyDef
    {
        final CustomStruct1 customStruct1() const
        {
            CustomStruct1.log ~= text("TestObject get customStruct1 ", m_customStruct1.id, " ", m_customStruct1.s);
            return m_customStruct1;
        }
        final void setCustomStruct1(ref const(CustomStruct1) customStruct1)
        {
            CustomStruct1.log ~= text("TestObject set customStruct1 ", m_customStruct1.id, " ", m_customStruct1.s, " -> ", customStruct1.id, " ", customStruct1.s);
            if (m_customStruct1.s != customStruct1.s)
            {
                m_customStruct1 = customStruct1;
                /+ emit +/ customStruct1Changed();
            }
        }
        @QSignal final void customStruct1Changed() {mixin(Q_SIGNAL_IMPL_D);}
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

void checkType(T, bool isDefined1, bool isDefined2, int id, int flags, string expectedName)()
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
    QMetaType.TypeFlag leftFlags = cast(QMetaType.TypeFlag) QMetaTypeTypeFlags!T.Flags;
    foreach (name; __traits(allMembers, QMetaType.TypeFlag))
    {
        if (name == "MovableType") // alias
            continue;
        if (leftFlags & __traits(getMember, QMetaType.TypeFlag, name))
        {
            if (!first)
                write(" | ");
            write("QMetaType.TypeFlag.", name);
            first = false;
            leftFlags &= ~__traits(getMember, QMetaType.TypeFlag, name);
        }
    }
    if (leftFlags)
    {
        if (!first)
            write(" | ");
        writef("%d", leftFlags);
        first = false;
    }
    if (first)
        write("0");

    write(", ");
    if (realId >= 0)
    {
        QMetaType metaType = QMetaType(realId);
        writef("\"%s\"", metaType.name().fromStringz);
    }
    else
        write("\"\"");
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
        QMetaType metaType = QMetaType(realId);
        assert(metaType.id() == realId);
        assert(metaType.name().fromStringz == expectedName, text(metaType.name().fromStringz, " ", expectedName));
        static if (!is(T == void))
            assert(metaType.sizeOf() == T.sizeof, text(T.stringof, " ", metaType.sizeOf(), " ", T.sizeof));
        if (sameRuntimeVersion && (flags & QMetaType.TypeFlag.IsConst) == 0)
            assert(metaType.flags() == flags, text(T.stringof, " ", metaType.flags(), " ", flags));

        T* instance = cast(T*) metaType.create();
        assert(instance || id == QMetaType.Type.Void);
        if (instance)
        {
            T* instance2 = cast(T*) metaType.create(instance);
            assert(instance2);
            assert(instance != instance2);
            metaType.destroy(cast(void*) instance);
            metaType.destroy(cast(void*) instance2);
        }
    }
    else
    {
        assert(expectedName == "");
    }
}

unittest
{
    import core.stdc.wchar_;
    import qt.core.abstractitemmodel;
    import qt.core.bytearray;
    import qt.core.bytearraylist;
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

    checkType!(float, 0, 1, QMetaType.Type.Float, QMetaType.TypeFlag.RelocatableType, "float")();
    checkType!(double, 0, 1, QMetaType.Type.Double, QMetaType.TypeFlag.RelocatableType, "double")();
    checkType!(qreal, 0, 1, QMetaType.Type.QReal, QMetaType.TypeFlag.RelocatableType, "double")();
    checkType!(int, 0, 1, QMetaType.Type.Int, QMetaType.TypeFlag.RelocatableType, "int")();
    checkType!(const(int), 0, 0, -1, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsConst, "")();
    checkType!(uint, 0, 1, QMetaType.Type.UInt, QMetaType.TypeFlag.RelocatableType, "uint")();
    checkType!(int*, 0, 0, -1, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsPointer, "")();
    checkType!(const(int)*, 0, 0, -1, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsPointer | QMetaType.TypeFlag.IsConst, "")();
    checkType!(const(int*), 0, 0, -1, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsPointer | QMetaType.TypeFlag.IsConst, "")();
    checkType!(void*, 0, 1, QMetaType.Type.VoidStar, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsPointer, "void*")();
    checkType!(const(void)*, 0, 0, -1, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsPointer | QMetaType.TypeFlag.IsConst, "")();
    checkType!(void, 0, 1, QMetaType.Type.Void, 0, "void")();
    checkType!(char, 0, 1, QMetaType.Type.Char, QMetaType.TypeFlag.RelocatableType, "char")();
    checkType!(ubyte, 0, 1, QMetaType.Type.UChar, QMetaType.TypeFlag.RelocatableType, "uchar")();
    checkType!(wchar, 0, 1, QMetaType.Type.Char16, QMetaType.TypeFlag.RelocatableType, "char16_t")();
    checkType!(dchar, 0, 1, QMetaType.Type.Char32, QMetaType.TypeFlag.RelocatableType, "char32_t")();
    //checkType!(wchar_t, 0, 0, -1, QMetaType.TypeFlag.RelocatableType, "")();
    checkType!(QChar, 0, 1, QMetaType.Type.QChar, QMetaType.TypeFlag.RelocatableType, "QChar")();
    checkType!(QLocale.Country, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsEnumeration | QMetaType.TypeFlag.IsUnsignedEnumeration, "QLocale::Country")();
    checkType!(/+ Qt:: +/qt.core.namespace.DayOfWeek, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsEnumeration | QMetaType.TypeFlag.IsUnsignedEnumeration, "Qt::DayOfWeek")();
    checkType!(QTimeZone.OffsetData, 0, 0, -1, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "")();
    checkType!(QByteArray, 0, 1, QMetaType.Type.QByteArray, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QByteArray")();
    checkType!(QItemSelectionRange, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QItemSelectionRange")();
    checkType!(QLine, 0, 1, QMetaType.Type.QLine, QMetaType.TypeFlag.RelocatableType, "QLine")();
    checkType!(QLineF, 0, 1, QMetaType.Type.QLineF, QMetaType.TypeFlag.RelocatableType, "QLineF")();
    checkType!(QLocale, 1, 1, QMetaType.Type.QLocale, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsGadget, "QLocale")();
    checkType!(const(QLocale), 1, 1, QMetaType.Type.QLocale, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.IsGadget | QMetaType.TypeFlag.IsConst, "QLocale")();
    checkType!(QLocale*, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.PointerToGadget | QMetaType.TypeFlag.IsPointer, "QLocale*")();
    checkType!(const(QLocale)*, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.PointerToGadget | QMetaType.TypeFlag.IsPointer | QMetaType.TypeFlag.IsConst, "const QLocale*")();
    checkType!(QModelIndex, 0, 1, QMetaType.Type.QModelIndex, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QModelIndex")();
    checkType!(QObject, 1, 1, QMetaType.Type.QObjectStar, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.PointerToQObject | QMetaType.TypeFlag.IsPointer, "QObject*")();
    // checkType!(tail const(QObject), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.PointerToQObject | QMetaType.TypeFlag.IsPointer | QMetaType.TypeFlag.IsConst, "const QObject*")();
    checkType!(const(QObject), 0, 0, -1, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsPointer | QMetaType.TypeFlag.IsConst, "")();
    checkType!(/+ std:: +/pair!(double, QSize), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "std::pair<double,QSize>")();
    checkType!(QPersistentModelIndex, 0, 1, QMetaType.Type.QPersistentModelIndex, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QPersistentModelIndex")();
    checkType!(QPoint, 0, 1, QMetaType.Type.QPoint, QMetaType.TypeFlag.RelocatableType, "QPoint")();
    checkType!(const(QPoint), 0, 0, -1, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsConst, "")();
    checkType!(QPointF, 0, 1, QMetaType.Type.QPointF, QMetaType.TypeFlag.RelocatableType, "QPointF")();
    checkType!(QSize, 0, 1, QMetaType.Type.QSize, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QSize")();
    checkType!(QString, 0, 1, QMetaType.Type.QString, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QString")();
    checkType!(QStringView, 0, 0, -1, QMetaType.TypeFlag.RelocatableType, "")();
    checkType!(QUrl, 0, 1, QMetaType.Type.QUrl, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QUrl")();
    checkType!(QVariant, 0, 1, QMetaType.Type.QVariant, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QVariant")();
    checkType!(QAbstractItemModel, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.PointerToQObject | QMetaType.TypeFlag.IsPointer, "QAbstractItemModel*")();
    checkType!(QTimeZone.OffsetData, 0, 0, -1, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "")();
    checkType!(QList!(int), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QList<int>")();
    checkType!(QList!(void*), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QList<void*>")();
    checkType!(QList!(QSize), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QList<QSize>")();
    checkType!(QList!(QLocale), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QList<QLocale>")();
    checkType!(QVector!(int), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QList<int>")();
    checkType!(QVector!(void*), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QList<void*>")();
    checkType!(QVector!(QSize), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QList<QSize>")();
    checkType!(QVector!(QLocale), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QList<QLocale>")();
    checkType!(QStringList, 1, 1, QMetaType.Type.QStringList, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QStringList")();
    checkType!(QVariantList, 1, 1, QMetaType.Type.QVariantList, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QVariantList")();
    checkType!(QByteArrayList, 1, 1, QMetaType.Type.QByteArrayList, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QByteArrayList")();
    checkType!(/+ Qt:: +/qt.core.namespace.Edge, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsEnumeration | QMetaType.TypeFlag.IsUnsignedEnumeration, "Qt::Edge")();
    checkType!(QFlags!(/+ Qt:: +/qt.core.namespace.Edge), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsEnumeration, "QFlags<Qt::Edge>")();
    checkType!(QList!(/+ Qt:: +/qt.core.namespace.Edge), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QList<Qt::Edge>")();
    checkType!(QList!(QFlags!(/+ Qt:: +/qt.core.namespace.Edge)), 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction | QMetaType.TypeFlag.RelocatableType, "QList<QFlags<Qt::Edge>>")();
    checkType!(TestObject.CustomEnum, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsEnumeration | QMetaType.TypeFlag.IsUnsignedEnumeration, "TestObject::CustomEnum")();
    checkType!(TestObject.CustomFlags, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.RelocatableType | QMetaType.TypeFlag.IsEnumeration, "QFlags<TestObject::CustomFlag>")();

    CustomStruct1.numConstructed = 0;
    CustomStruct1.log = [];
    checkType!(CustomStruct1, 1, 1, QMetaType.Type.User, QMetaType.TypeFlag.NeedsConstruction | QMetaType.TypeFlag.NeedsDestruction, "CustomStruct1")();
    assert(CustomStruct1.log == [
               "copy 0 -> 1 ",
               "destruct 0 ",
               "destruct 1 "]);
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
    const(int) numSignalSlotTests = 13;
    assert(mo.methodCount() - mo.methodOffset() == numSignalSlotTests * 3 + 4 + 1);

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

    method = mo.method(mo.methodOffset() + 10);
    assert(method.name().toConstCharArray() == "signalCustomStruct1ConstRef");
    assert(method.methodSignature().toConstCharArray() == "signalCustomStruct1ConstRef(CustomStruct1)");
    assert(method.parameterCount() == 1);

    method = mo.method(mo.methodOffset() + 11);
    assert(method.name().toConstCharArray() == "signalCustomEnum");
    assert(method.methodSignature().toConstCharArray() == "signalCustomEnum(CustomEnum)");
    assert(method.parameterCount() == 1);

    method = mo.method(mo.methodOffset() + 12);
    assert(method.name().toConstCharArray() == "signalCustomFlags");
    assert(method.methodSignature().toConstCharArray() == "signalCustomFlags(CustomFlags)");
    assert(method.parameterCount() == 1);

    method = mo.method(mo.methodOffset() + numSignalSlotTests * 3 + 4);
    assert(method.name().toConstCharArray() == "toUpper");
    assert(method.methodSignature().toConstCharArray() == "toUpper(QString)");
    assert(method.parameterCount() == 1);
    assert(method.parameterType(0) == QMetaType.Type.QString);
    assert(method.returnType() == QMetaType.Type.QString);

    assert(mo.enumeratorCount() == 3);
    QMetaEnum e = mo.enumerator(mo.enumeratorOffset() + 0);
    assert(e.enumName().fromStringz == "CustomEnum");
    assert(e.name().fromStringz == "CustomEnum");
    assert(e.isValid());
    assert(!e.isFlag());
    assert(e.isScoped());
    assert(e.keyCount() == 4);
    assert(e.key(0).fromStringz == "a");
    assert(e.key(1).fromStringz == "b");
    assert(e.key(2).fromStringz == "c");
    assert(e.key(3).fromStringz == "d");
    assert(e.value(0) == 0);
    assert(e.value(1) == 1);
    assert(e.value(2) == 100);
    assert(e.value(3) == 101);

    e = mo.enumerator(mo.enumeratorOffset() + 1);
    assert(e.enumName().fromStringz == "CustomFlag");
    assert(e.name().fromStringz == "CustomFlag");
    assert(e.isValid());
    assert(!e.isFlag());
    assert(e.isScoped());
    assert(e.keyCount() == 5);
    assert(e.key(0).fromStringz == "a");
    assert(e.key(1).fromStringz == "b");
    assert(e.key(2).fromStringz == "c");
    assert(e.key(3).fromStringz == "d");
    assert(e.key(4).fromStringz == "e");
    assert(e.value(0) == 1);
    assert(e.value(1) == 2);
    assert(e.value(2) == 4);
    assert(e.value(3) == 8);
    assert(e.value(4) == 16);

    e = mo.enumerator(mo.enumeratorOffset() + 2);
    assert(e.enumName().fromStringz == "CustomFlag");
    assert(e.name().fromStringz == "CustomFlags");
    assert(e.isValid());
    assert(e.isFlag());
    assert(e.isScoped());
    assert(e.keyCount() == 5);
    assert(e.key(0).fromStringz == "a");
    assert(e.key(1).fromStringz == "b");
    assert(e.key(2).fromStringz == "c");
    assert(e.key(3).fromStringz == "d");
    assert(e.key(4).fromStringz == "e");
    assert(e.value(0) == 1);
    assert(e.value(1) == 2);
    assert(e.value(2) == 4);
    assert(e.value(3) == 8);
    assert(e.value(4) == 16);

    assert(mo.propertyCount() - mo.propertyOffset() == 6);
    QMetaProperty prop = mo.property(mo.propertyOffset() + 0);
    assert(fromStringz(prop.name()) == "bool1");
    assert(prop.typeId() == QMetaType.Type.Bool);
    assert(prop.isWritable());
    assert(prop.isReadable());
    assert(!prop.isConstant());
    assert(prop.hasNotifySignal());
    assert(prop.notifySignalIndex() == mo.methodOffset() + numSignalSlotTests);
    assert(mo.method(prop.notifySignalIndex()).name().toConstCharArray() == "bool1Changed");

    prop = mo.property(mo.propertyOffset() + 1);
    assert(fromStringz(prop.name()) == "notBool1");
    assert(prop.typeId() == QMetaType.Type.Bool);
    assert(!prop.isWritable());
    assert(prop.isReadable());
    assert(!prop.isConstant());
    assert(prop.hasNotifySignal());
    assert(prop.notifySignalIndex() == mo.methodOffset() + numSignalSlotTests);
    assert(mo.method(prop.notifySignalIndex()).name().toConstCharArray() == "bool1Changed");

    prop = mo.property(mo.propertyOffset() + 2);
    assert(fromStringz(prop.name()) == "bool2");
    assert(prop.typeId() == QMetaType.Type.Bool);
    assert(prop.isWritable());
    assert(prop.isReadable());
    assert(!prop.isConstant());
    assert(prop.hasNotifySignal());
    assert(prop.notifySignalIndex() == mo.methodOffset() + numSignalSlotTests + 1);
    assert(mo.method(prop.notifySignalIndex()).name().toConstCharArray() == "bool2Changed");

    prop = mo.property(mo.propertyOffset() + 3);
    assert(fromStringz(prop.name()) == "string1");
    assert(prop.typeId() == QMetaType.Type.QString);
    assert(prop.isWritable());
    assert(prop.isReadable());
    assert(!prop.isConstant());
    assert(prop.hasNotifySignal());
    assert(prop.notifySignalIndex() == mo.methodOffset() + numSignalSlotTests + 2);
    assert(mo.method(prop.notifySignalIndex()).name().toConstCharArray() == "string1Changed");

    prop = mo.property(mo.propertyOffset() + 4);
    assert(fromStringz(prop.name()) == "pointerSize");
    assert(prop.typeId() == QMetaType.Type.UInt);
    assert(!prop.isWritable());
    assert(prop.isReadable());
    assert(prop.isConstant());
    assert(!prop.hasNotifySignal());

    prop = mo.property(mo.propertyOffset() + 5);
    assert(fromStringz(prop.name()) == "customStruct1");
    assert(fromStringz(prop.typeName()) == "CustomStruct1");
    assert(prop.isWritable());
    assert(prop.isReadable());
    assert(!prop.isConstant());
    assert(prop.hasNotifySignal());
    assert(prop.notifySignalIndex() == mo.methodOffset() + numSignalSlotTests + 3);
    assert(mo.method(prop.notifySignalIndex()).name().toConstCharArray() == "customStruct1Changed");
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
    QObject.connect(a, (mixin(SIGNAL(q{signalCustomStruct1ConstRef(CustomStruct1)}))).ptr, b, (mixin(SLOT(q{onSignalCustomStruct1ConstRef(CustomStruct1)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalCustomEnum(CustomEnum)}))).ptr, b, (mixin(SLOT(q{onSignalCustomEnum(CustomEnum)}))).ptr);
    QObject.connect(a, (mixin(SIGNAL(q{signalCustomFlags(CustomFlags)}))).ptr, b, (mixin(SLOT(q{onSignalCustomFlags(CustomFlags)}))).ptr);
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
    QObject.connect(a.signal!"signalCustomStruct1ConstRef", b.slot!"onSignalCustomStruct1ConstRef", type);
    QObject.connect(a.signal!"signalCustomEnum", b.slot!"onSignalCustomEnum", type);
    QObject.connect(a.signal!"signalCustomFlags", b.slot!"onSignalCustomFlags", type);
}

void testSignals(TestObject a, void delegate(string) check)
{
    import core.stdcpp.new_;
    import qt.core.list;
    import qt.core.timer;
    import qt.core.vector;

    CustomStruct1.numConstructed = 0;
    CustomStruct1.log = [];
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
    a.emitSignalCustomStruct1(CustomStruct1("signal1"));
    check("CustomStruct1 signal1");
    a.emitSignalCustomStruct1(CustomStruct1("signalconstref1"));
    check("CustomStruct1 signalconstref1");
    a.emitSignalCustomEnum(TestObject.CustomEnum.d);
    check("CustomEnum 101");
    a.emitSignalCustomFlags(TestObject.CustomFlags.b | TestObject.CustomFlags.c);
    check("CustomFlags 6");
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
    assert(CustomStruct1.log == [
            "construct 1 signal1",
            "copy 1 -> 2 signal1",
            "copy 2 -> 3 signal1",
            "destruct 3 signal1",
            "destruct 2 signal1",
            "destruct 1 signal1",
            "construct 4 signalconstref1",
            "copy 4 -> 5 signalconstref1",
            "copy 5 -> 6 signalconstref1",
            "destruct 6 signalconstref1",
            "destruct 5 signalconstref1",
            "destruct 4 signalconstref1"]);

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
    assert(CustomStruct1.log == [
            "construct 1 signal1",
            "copy 1 -> 2 signal1",
            "copy 2 -> 3 signal1",
            "destruct 3 signal1",
            "destruct 2 signal1",
            "destruct 1 signal1",
            "construct 4 signalconstref1",
            "copy 4 -> 5 signalconstref1",
            "copy 5 -> 6 signalconstref1",
            "destruct 6 signalconstref1",
            "destruct 5 signalconstref1",
            "destruct 4 signalconstref1"]);

    cpp_delete(a);
    cpp_delete(b);
}

unittest
{
    import core.stdcpp.new_;
    import qt.core.eventloop;

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
    assert(CustomStruct1.log == [
            "construct 1 signal1",
            "copy 1 -> 2 signal1",
            "copy 2 -> 3 signal1",
            "destruct 2 signal1",
            "destruct 1 signal1",
            "construct 4 signalconstref1",
            "copy 4 -> 5 signalconstref1",
            "copy 5 -> 6 signalconstref1",
            "destruct 5 signalconstref1",
            "destruct 4 signalconstref1"]);
    CustomStruct1.log = [];

    eventLoop.exec();

    assert(receivedValues == expectedValues);
    assert(CustomStruct1.log == [
            "copy 3 -> 7 signal1",
            "destruct 7 signal1",
            "destruct 3 signal1",
            "copy 6 -> 8 signalconstref1",
            "destruct 8 signalconstref1",
            "destruct 6 signalconstref1"]);

    cpp_delete(a);
    cpp_delete(b);
}

unittest
{
    import core.memory;
    import core.stdcpp.new_;
    import qt.core.thread;

    GC.disable(); // Disable GC, because this test uses a separate thread, which is not tracked by the GC

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
    assert(CustomStruct1.log == [
            "construct 1 signal1",
            "copy 1 -> 2 signal1",
            "copy 2 -> 3 signal1",
            "destruct 2 signal1",
            "destruct 1 signal1",
            "construct 4 signalconstref1",
            "copy 4 -> 5 signalconstref1",
            "copy 5 -> 6 signalconstref1",
            "destruct 5 signalconstref1",
            "destruct 4 signalconstref1"]);
    CustomStruct1.log = [];

    thread.start();
    thread.wait();

    assert(receivedValues == expectedValues);
    assert(CustomStruct1.log == [
            "copy 3 -> 7 signal1",
            "destruct 7 signal1",
            "destruct 3 signal1",
            "copy 6 -> 8 signalconstref1",
            "destruct 8 signalconstref1",
            "destruct 6 signalconstref1"]);

    cpp_delete(a);
    cpp_delete(b);

    GC.enable();
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
    else version (Android)
        compareVariant(v, "00000000 00000000 00000000 ???????? 02000000 ????????");
    else
        compareVariant(v, "00000000 00000000 00000000 02000000");
    v = QVariant(5);
    static if ((void*).sizeof == 8)
        compareVariant(v, "05000000 00000000 00000000 00000000 00000000 00000000 ???????? ????????");
    else version (Android)
        compareVariant(v, "05000000 00000000 00000000 ???????? ???????? ????????");
    else
        compareVariant(v, "05000000 00000000 00000000 ????????");
    v = QVariant(100.0f);
    static if ((void*).sizeof == 8)
        compareVariant(v, "0000C842 00000000 00000000 00000000 00000000 00000000 ???????? ????????");
    else version (Android)
        compareVariant(v, "0000C842 00000000 00000000 ???????? ???????? ????????");
    else
        compareVariant(v, "0000C842 00000000 00000000 ????????");
    v = QVariant(100.0);
    static if ((void*).sizeof == 8)
        compareVariant(v, "00000000 00005940 00000000 00000000 00000000 00000000 ???????? ????????");
    else version (Android)
        compareVariant(v, "00000000 00005940 00000000 ???????? ???????? ????????");
    else
        compareVariant(v, "00000000 00005940 00000000 ????????");
    v = QVariant(cast(int)'A');
    static if ((void*).sizeof == 8)
        compareVariant(v, "41000000 00000000 00000000 00000000 00000000 00000000 ???????? ????????");
    else version (Android)
        compareVariant(v, "41000000 00000000 00000000 ???????? ???????? ????????");
    else
        compareVariant(v, "41000000 00000000 00000000 ????????");
}

unittest
{
    CustomStruct1.numConstructed = 0;
    CustomStruct1.log = [];

    QVariant v = QVariant.fromValue(CustomStruct1("variant1"));
    assert(CustomStruct1.log == [
            "construct 1 variant1",
            "copy 1 -> 2 variant1",
            "destruct 1 variant1"]);
    CustomStruct1.log = [];

    assert(v.value!CustomStruct1().s == "variant1");
    assert(CustomStruct1.log == [
            "copy 2 -> 3 variant1",
            "destruct 3 variant1"]);
    CustomStruct1.log = [];

    v.clear();
    assert(CustomStruct1.log == [
            "destruct 2 variant1"]);
    CustomStruct1.log = [];

    v = QVariant(QMetaType.fromType!(CustomStruct1)(), null);
    *cast(CustomStruct1*) v.data() = CustomStruct1("variant2");
    assert(CustomStruct1.log == [
            "construct 4 variant2",
            "assign first 5 = 4 variant2",
            "destruct 4 variant2"]);
    CustomStruct1.log = [];

    v.clear();
    assert(CustomStruct1.log == [
            "destruct 5 variant2"]);
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

    CustomStruct1.numConstructed = 0;
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

    CustomStruct1.log = [];
    o.setProperty("customStruct1", CustomStruct1("properties1"));
    assert(CustomStruct1.log == [
            "construct 1 properties1",
            "copy 1 -> 2 properties1",
            "copy 2 -> 3 properties1",
            "TestObject set customStruct1 0  -> 3 properties1",
            "assign first 4 = 3 properties1",
            "destruct 3 properties1",
            "destruct 2 properties1",
            "destruct 1 properties1"]);
    CustomStruct1.log = [];

    assert(o.customStruct1().s == "properties1");
    assert(CustomStruct1.log == [
            "TestObject get customStruct1 4 properties1",
            "copy 4 -> 5 properties1",
            "destruct 5 properties1"]);
    CustomStruct1.log = [];

    assert(o.property("customStruct1").value!CustomStruct1().s == "properties1");
    assert(CustomStruct1.log == [
            "TestObject get customStruct1 4 properties1",
            "copy 4 -> 6 properties1",
            "assign first 7 = 6 properties1",
            "destruct 6 properties1",
            "copy 7 -> 8 properties1",
            "destruct 8 properties1",
            "destruct 7 properties1"]);

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

unittest
{
    import qt.core.locale;

    QLocale.Language l = QLocale.Language.English;
    QVariant v = QVariant.fromValue(l);
    assert(v.typeName().fromStringz == "QLocale::Language");
    assert(v.metaType().name().fromStringz == "QLocale::Language");
    assert(v.metaType().metaObject().className().fromStringz == "QLocale");
    assert(v.toString() == "English");
    assert(v.toInt() == cast(int)l);
    assert(v.value!(QLocale.Language)() == l);
}

unittest
{
    /+ Qt:: +/qt.core.namespace.Orientation o = /+ Qt:: +/qt.core.namespace.Orientation.Vertical;
    QVariant v = QVariant.fromValue(o);
    assert(v.typeName().fromStringz == "Qt::Orientation");
    assert(v.metaType().name().fromStringz == "Qt::Orientation");
    assert(v.metaType().metaObject().className().fromStringz == "Qt");
    assert(v.toString() == "Vertical");
    assert(v.toInt() == cast(int)o);
    assert(v.value!(/+ Qt:: +/qt.core.namespace.Orientation)() == o);
}

unittest
{
    TestObject.CustomEnum e = TestObject.CustomEnum.d;
    QVariant v = QVariant.fromValue(e);
    assert(v.typeName().fromStringz == "TestObject::CustomEnum");
    assert(v.metaType().name().fromStringz == "TestObject::CustomEnum");
    assert(v.metaType().metaObject().className().fromStringz == "TestObject");
    assert(v.toString() == "d");
    assert(v.toInt() == cast(int)e);
    assert(v.value!(TestObject.CustomEnum)() == e);
}

unittest
{
    /+ Qt:: +/qt.core.namespace.Alignment a = /+ Qt:: +/qt.core.namespace.Alignment.AlignLeft | /+ Qt:: +/qt.core.namespace.Alignment.AlignBottom;
    QVariant v = QVariant.fromValue(a);
    assert(v.typeName().fromStringz == "QFlags<Qt::AlignmentFlag>");
    assert(v.metaType().name().fromStringz == "QFlags<Qt::AlignmentFlag>");
    assert(v.metaType().metaObject().className().fromStringz == "Qt");
    assert(v.toInt() == cast(int)a);
    assert(v.value!(/+ Qt:: +/qt.core.namespace.Alignment)() == a);
}

unittest
{
    TestObject.CustomFlags f = TestObject.CustomFlags.b | TestObject.CustomFlags.c;
    QVariant v = QVariant.fromValue(f);
    assert(v.typeName().fromStringz == "QFlags<TestObject::CustomFlag>");
    assert(v.metaType().name().fromStringz == "QFlags<TestObject::CustomFlag>");
    assert(v.metaType().metaObject().className().fromStringz == "TestObject");
    assert(v.toInt() == cast(int)f);
    assert(v.value!(TestObject.CustomFlags)() == f);
}
