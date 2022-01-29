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
module qt.core.objectdefs;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.metaobject;
import qt.core.namespace;
import qt.core.object;
import qt.core.objectdefs_impl;
import qt.core.point;
import qt.helpers;
import std.traits;
import std.meta;
version(QT_NO_TRANSLATION){}else
    import qt.core.string;

/+ #if defined(__OBJC__) && !defined(__cplusplus)
#  warning "File built in Objective-C mode (.m), but using Qt requires Objective-C++ (.mm)"
#endif




#ifndef Q_MOC_OUTPUT_REVISION
#define Q_MOC_OUTPUT_REVISION 67
#endif

// The following macros can be defined by tools that understand Qt
// to have the information from the macro.
#ifndef QT_ANNOTATE_CLASS
# define QT_ANNOTATE_CLASS(type, ...)
#endif
#ifndef QT_ANNOTATE_CLASS2
# define QT_ANNOTATE_CLASS2(type, a1, a2)
#endif
#ifndef QT_ANNOTATE_FUNCTION
# define QT_ANNOTATE_FUNCTION(x)
#endif
#ifndef QT_ANNOTATE_ACCESS_SPECIFIER
# define QT_ANNOTATE_ACCESS_SPECIFIER(x)
#endif

// The following macros are our "extensions" to C++
// They are used, strictly speaking, only by the moc.

#ifndef Q_MOC_RUN +/
/+ #ifndef QT_NO_META_MACROS
# if defined(QT_NO_KEYWORDS)
#  define QT_NO_EMIT
# else
#   ifndef QT_NO_SIGNALS_SLOTS_KEYWORDS
#     define slots Q_SLOTS
#     define signals Q_SIGNALS
#   endif
# endif
# define Q_SLOTS QT_ANNOTATE_ACCESS_SPECIFIER(qt_slot)
# define Q_SIGNALS public QT_ANNOTATE_ACCESS_SPECIFIER(qt_signal)
# define Q_PRIVATE_SLOT(d, signature) QT_ANNOTATE_CLASS2(qt_private_slot, d, signature)
# define Q_EMIT
#ifndef QT_NO_EMIT
# define emit
#endif
#ifndef Q_CLASSINFO
# define Q_CLASSINFO(name, value)
#endif
#define Q_PLUGIN_METADATA(x) QT_ANNOTATE_CLASS(qt_plugin_metadata, x)
#define Q_INTERFACES(x) QT_ANNOTATE_CLASS(qt_interfaces, x)
#define Q_PROPERTY(...) QT_ANNOTATE_CLASS(qt_property, __VA_ARGS__)
#define Q_PRIVATE_PROPERTY(d, text) QT_ANNOTATE_CLASS2(qt_private_property, d, text)
#ifndef Q_REVISION
# define Q_REVISION(v)
#endif
#define Q_OVERRIDE(text) QT_ANNOTATE_CLASS(qt_override, text)
#define QDOC_PROPERTY(text) QT_ANNOTATE_CLASS(qt_qdoc_property, text)
#define Q_ENUMS(x) QT_ANNOTATE_CLASS(qt_enums, x)
#define Q_FLAGS(x) QT_ANNOTATE_CLASS(qt_enums, x)
#define Q_ENUM_IMPL(ENUM) \
    friend Q_DECL_CONSTEXPR const QMetaObject *qt_getEnumMetaObject(ENUM) noexcept { return &staticMetaObject; } \
    friend Q_DECL_CONSTEXPR const char *qt_getEnumName(ENUM) noexcept { return #ENUM; }
#define Q_ENUM(x) Q_ENUMS(x) Q_ENUM_IMPL(x)
#define Q_FLAG(x) Q_FLAGS(x) Q_ENUM_IMPL(x)
#define Q_ENUM_NS_IMPL(ENUM) \
    inline Q_DECL_CONSTEXPR const QMetaObject *qt_getEnumMetaObject(ENUM) noexcept { return &staticMetaObject; } \
    inline Q_DECL_CONSTEXPR const char *qt_getEnumName(ENUM) noexcept { return #ENUM; }
#define Q_ENUM_NS(x) Q_ENUMS(x) Q_ENUM_NS_IMPL(x)
#define Q_FLAG_NS(x) Q_FLAGS(x) Q_ENUM_NS_IMPL(x)
#define Q_SCRIPTABLE QT_ANNOTATE_FUNCTION(qt_scriptable)
#define Q_INVOKABLE  QT_ANNOTATE_FUNCTION(qt_invokable)
#define Q_SIGNAL QT_ANNOTATE_FUNCTION(qt_signal)
#define Q_SLOT QT_ANNOTATE_FUNCTION(qt_slot)
#endif +/ // QT_NO_META_MACROS

version(QT_NO_TRANSLATION){}else
{
// full set of tr functions
/+ #  define QT_TR_FUNCTIONS \
    static inline QString tr(const char *s, const char *c = nullptr, int n = -1) \
        { return staticMetaObject.tr(s, c, n); } \
    QT_DEPRECATED static inline QString trUtf8(const char *s, const char *c = nullptr, int n = -1) \
        { return staticMetaObject.tr(s, c, n); } +/
enum QT_TR_FUNCTIONS =
        q{pragma(inline, true) static dqtimported!"qt.core.string".QString tr(const(char)* s, const(char)* c = null, int n = -1)
            { return staticMetaObject.tr(s, c, n); }
        /+ QT_DEPRECATED +/ pragma(inline, true) static dqtimported!"qt.core.string".QString trUtf8(const(char)* s, const(char)* c = null, int n = -1)
            { return staticMetaObject.tr(s, c, n); }};
}
version(QT_NO_TRANSLATION)
{
// inherit the ones from QObject
/+ # define QT_TR_FUNCTIONS +/
}

/+ #ifdef Q_CLANG_QDOC
#define QT_TR_FUNCTIONS
#endif

// ### Qt6: remove
#define Q_OBJECT_CHECK  /* empty, unused since Qt 5.2 */

#if defined(Q_CC_INTEL)
// Cannot redefine the visibility of a method in an exported class
# define Q_DECL_HIDDEN_STATIC_METACALL
#else
# define Q_DECL_HIDDEN_STATIC_METACALL Q_DECL_HIDDEN
#endif

#if defined(Q_CC_CLANG) && Q_CC_CLANG >= 306
#  define Q_OBJECT_NO_OVERRIDE_WARNING      QT_WARNING_DISABLE_CLANG("-Winconsistent-missing-override")
#elif defined(Q_CC_GNU) && !defined(Q_CC_INTEL) && Q_CC_GNU >= 501
#  define Q_OBJECT_NO_OVERRIDE_WARNING      QT_WARNING_DISABLE_GCC("-Wsuggest-override")
#else
#  define Q_OBJECT_NO_OVERRIDE_WARNING
#endif

#if defined(Q_CC_GNU) && !defined(Q_CC_INTEL) && Q_CC_GNU >= 600
#  define Q_OBJECT_NO_ATTRIBUTES_WARNING    QT_WARNING_DISABLE_GCC("-Wattributes")
#else
#  define Q_OBJECT_NO_ATTRIBUTES_WARNING
#endif +/

/* qmake ignore Q_OBJECT */
/+ #define Q_OBJECT \
public: \
    QT_WARNING_PUSH \
    Q_OBJECT_NO_OVERRIDE_WARNING \
    static const QMetaObject staticMetaObject; \
    virtual const QMetaObject *metaObject() const; \
    virtual void *qt_metacast(const char *); \
    virtual int qt_metacall(QMetaObject::Call, int, void **); \
    QT_TR_FUNCTIONS \
private: \
    Q_OBJECT_NO_ATTRIBUTES_WARNING \
    Q_DECL_HIDDEN_STATIC_METACALL static void qt_static_metacall(QObject *, QMetaObject::Call, int, void **); \
    QT_WARNING_POP \
    struct QPrivateSignal {}; \
    QT_ANNOTATE_CLASS(qt_qobject, "") +/
enum Q_OBJECT =
q{    public:
        /+ QT_WARNING_PUSH
        Q_OBJECT_NO_OVERRIDE_WARNING +/
        extern(C++) extern } ~ exportOnWindows ~ q{static __gshared const(dqtimported!q{qt.core.objectdefs}.QMetaObject) staticMetaObject;
        extern(C++) override /+ virtual +/ const(dqtimported!q{qt.core.objectdefs}.QMetaObject)* metaObject() const;
        extern(C++) override /+ virtual +/ void* qt_metacast(const(char)* );
        extern(C++) override /+ virtual +/ int qt_metacall(dqtimported!q{qt.core.objectdefs}.QMetaObject.Call, int, void** );
        } ~ QT_TR_FUNCTIONS ~ q{
    private:
        /+ Q_OBJECT_NO_ATTRIBUTES_WARNING +/
        /+ Q_DECL_HIDDEN_STATIC_METACALL +/ static void qt_static_metacall(dqtimported!"qt.core.object".QObject , dqtimported!q{qt.core.objectdefs}.QMetaObject.Call, int, void** );
        /+ QT_WARNING_POP +/
        extern(C++) struct QPrivateSignal {}};
        /+ QT_ANNOTATE_CLASS(qt_qobject, "") +/

/* qmake ignore Q_OBJECT */
/+ #define Q_OBJECT_FAKE Q_OBJECT QT_ANNOTATE_CLASS(qt_fake, "")

#ifndef QT_NO_META_MACROS +/
/* qmake ignore Q_GADGET */

struct CPPMemberFunctionPointer(T)
{
    void *ptr;
    uint adj;
}

private alias parentOf(alias sym) = __traits(parent, sym);
private alias parentOf(alias sym : T!Args, alias T, Args...) = __traits(parent, T);

// Like std.traits.packageName, but allows modules without package.
private template packageName(alias T)
{
    import std.algorithm.searching : startsWith;

    enum bool isNotFunc = !isSomeFunction!(T);

    static if (__traits(compiles, parentOf!T))
        enum parent = packageName!(parentOf!T);
    else
        enum string parent = null;

    static if (isNotFunc && T.stringof.startsWith("package "))
        enum packageName = (parent.length ? parent ~ '.' : "") ~ T.stringof[8 .. $];
    else static if (parent)
        enum packageName = parent;
    else
        enum packageName = "";
}

private template IsInQtPackage(alias S)
{
    enum IsInQtPackage = packageName!(S).length > 3 && packageName!(S)[0..3] == "qt.";
}

template memberFunctionExternDeclaration(alias F)
{
    version(Windows)
    mixin((){
            string code;
            version(Windows)
                static if(IsInQtPackage!(F))
                    code ~= "export ";
            code ~= "extern(" ~ functionLinkage!F ~ ")";
            code ~= q{pragma(mangle, F.mangleof) ReturnType!F memberFunctionExternDeclaration(__traits(parent, F), Parameters!F);};
            return code;
        }());
    else
        alias memberFunctionExternDeclaration = F;
}

enum NotIsConstructor(alias F) = __traits(identifier, F) != "__ctor";

template MetaObjectImpl(T)
{
    import qt.core.refcount;
    import qt.core.metatype;
    extern(D):

    alias Overloads(string name) = __traits(getOverloads, T, name);
    //pragma(msg, staticMap!(Overloads, __traits(derivedMembers, T)));
    alias allFunctions = Filter!(NotIsConstructor, staticMap!(Overloads, __traits(derivedMembers, T)));
    alias allSignals = Filter!(IsQSignal, allFunctions);
    alias allSlots = Filter!(IsQSlot, allFunctions);
    alias allInvokables = Filter!(IsQInvokable, allFunctions);
    alias allMethods = std.meta.AliasSeq!(allSignals, allSlots, allInvokables);

    /*pragma(msg, allSignals);
    pragma(msg, allSlots);
    pragma(msg, allInvokables);*/

    template signalIndex(alias F)
    {
        enum signalIndex = staticIndexOf!(F, allSignals);
    }

    enum CODE = (){
        import std.conv;

        string concatenatedStrings;
        string stringLiteralsCode;
        size_t numStrings;
        size_t[string] stringCache;

        size_t addString(string s)
        {
            if(s in stringCache)
                return stringCache[s];
            stringLiteralsCode ~= text("QT_MOC_LITERAL(", numStrings, ", ", concatenatedStrings.length, ", " , s.length, "),\n");
            concatenatedStrings ~= s;
            concatenatedStrings ~= "\0";
            stringCache[s] = numStrings;
            return numStrings++;
        }

        addString(__traits(identifier, T));

        size_t currentOutputIndex = 0;

        currentOutputIndex += 14;

        size_t methodsStartIndex = currentOutputIndex;

        string metaDataCode = mixin(interpolateMixin(q{
             // content:
                   8,       // revision
                   0,       // classname
                   0,    0, // classinfo
                   $(text(allMethods.length)),   $(text(methodsStartIndex)), // methods
                   0,    0, // properties
                   0,    0, // enums/sets
                   0,    0, // constructors
                   0,       // flags
                   $(text(allSignals.length)),       // signalCount

        }));

        assert(methodsStartIndex == currentOutputIndex);
        currentOutputIndex += 5 * allMethods.length;

        string typeToMeta(T2)()
        {
            import qt.core.list: QList;
            import qt.core.vector: QVector;
            static if(is(T2 == int))
                return "QMetaType.Type.Int";
            else static if(is(T2 == uint))
                return "QMetaType.Type.UInt";
            else static if(is(T2 == bool))
                return "QMetaType.Type.Bool";
            else static if(is(T2 == double))
                return "QMetaType.Type.Double";
            else static if(is(const(T2) == const(QString)))
                return "QMetaType.Type.QString";
            else static if(is(const(T2) == const(QList!int)))
                return text("0x80000000 | ", addString("QList<int>"));
            else static if(is(const(T2) == const(QVector!int)))
                return text("0x80000000 | ", addString("QVector<int>"));
            else static if(is(const(T2) == const(QPoint)))
                return "QMetaType.Type.QPoint";
            else static if(is(T2 == int*))
                return text("0x80000000 | ", addString("int*"));
            else static if(is(T2 == class) && __traits(getLinkage, T2) == "C++")
                return text("0x80000000 | ", addString(__traits(identifier, T2) ~ "*"));
            else
                static assert("TODO: Type not yet supported ", T2.stringof);
        }

        void addMethods(M...)(string typename, uint type)
        {
            if(M.length)
                metaDataCode ~= "    // " ~ typename ~ ": name, argc, parameters, tag, flags\n";
            static foreach(i; 0..M.length)
            {{
                size_t nameId = addString(__traits(identifier, M[i]));
                size_t parameterCount = Parameters!(M[i]).length;
                uint flags;
                flags |= 2; // Public // TODO
                metaDataCode ~= mixin(interpolateMixin(q{
                       $(text(nameId)),    $(text(parameterCount)),   $(text(currentOutputIndex)),    2, $(text(flags)), $("// " ~ __traits(identifier, M[i]))
                }));
                currentOutputIndex += 1 + 2 * parameterCount;
            }}
        }
        addMethods!(allSignals)("signals", 4);
        addMethods!(allSlots)("slots", 8);
        addMethods!(allInvokables)("methods", 0);
        void addMethodParameters(M...)(string typename)
        {
            if(M.length)
                metaDataCode ~= "    // " ~ typename ~ ": parameters\n";
            static foreach(i; 0..M.length)
            {
                metaDataCode ~= "                    QMetaType.Type.Void, "; // TODO: correct return type
                foreach(P; Parameters!(M[i]))
                    metaDataCode ~= typeToMeta!(P) ~ ", ";
                foreach(j, P; Parameters!(M[i]))
                    metaDataCode ~= text(addString(ParameterIdentifierTuple!(M[i])[j]), ", ");
                metaDataCode ~= "// " ~ __traits(identifier, M[i]) ~ "\n";
            }
        }
        addMethodParameters!(allSignals)("signals");
        addMethodParameters!(allSlots)("slots");
        addMethodParameters!(allInvokables)("methods");

        addString("");

        string concatenatedStringsCode = "\"";
        foreach(char c; concatenatedStrings)
        {
            if(c == '\0')
                concatenatedStringsCode ~= "\\0";
            else if(c == '\\')
                concatenatedStringsCode ~= "\\\\";
            else if(c == '\n')
                concatenatedStringsCode ~= "\\n";
            else if(c == '\r')
                concatenatedStringsCode ~= "\\r";
            else if(c == '\"')
                concatenatedStringsCode ~= "\\\"";
            else if(c == '\'')
                concatenatedStringsCode ~= "\\\'";
            else
                concatenatedStringsCode ~= c;
        }
        concatenatedStringsCode ~= "\"";

        return mixin(interpolateMixin(q{
            extern(C++) struct stringdata_t {
                QByteArrayData[$(text(numStrings))] data;
                char[$(text(concatenatedStrings.length))] stringdata0;
            };

            extern(C++) const(QByteArrayData) Q_STATIC_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(int size, size_t offset)
            {
                return const(QByteArrayData)(Q_REFCOUNT_INITIALIZE_STATIC, size, 0,/* 0,*/ offset);
            }

            extern(C++) const(QByteArrayData) QT_MOC_LITERAL(size_t idx, size_t ofs, int len)
            {
                return Q_STATIC_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len,
                    ptrdiff_t(stringdata_t.stringdata0.offsetof + ofs
                        - idx * QByteArrayData.sizeof)
                    );
            }

            extern(C++) static __gshared const stringdata_t stringdata = {
                [
                    $(stringLiteralsCode)
                ],
                $(concatenatedStringsCode)
            };

            extern(C++) static __gshared const uint[$(text(currentOutputIndex + 1))] meta_data = [
                    $(metaDataCode)
                   0        // eod
            ];

            version(Windows)
            {
                pragma(mangle, T.staticMetaObject.mangleof)
                extern(C++) static __gshared const(QMetaObject) staticMetaObject = { {
                    null,
                    &stringdata,
                    meta_data.ptr,
                    &T.qt_static_metacall,
                    null,
                    null
                } };
                shared static this()
                {
                    // Necessary for Windows, because staticMetaObject from a DLL can't be used directly.
                    (cast(QMetaObject*)&staticMetaObject).d.superdata.direct = &BaseClassesTuple!(T)[0].staticMetaObject;
                }
            }
            else
            {
                pragma(mangle, T.staticMetaObject.mangleof)
                extern(C++) static __gshared const(QMetaObject) staticMetaObject = { {
                    QMetaObject.SuperData.link!(BaseClassesTuple!(T)[0].staticMetaObject)(),
                    &stringdata,
                    meta_data.ptr,
                    &T.qt_static_metacall,
                    null,
                    null
                } };
            }
        }));
    }();
    //pragma(msg, CODE);
    mixin(CODE);
}

enum Q_OBJECT_D = q{
    public:
        extern(C++) extern static __gshared const(dqtimported!q{qt.core.objectdefs}.QMetaObject) staticMetaObject;
        extern(C++) override const(dqtimported!q{qt.core.objectdefs}.QMetaObject)* metaObject() const
        {
            import qt.core.object;
            return qt.core.object.QObject.d_ptr.metaObject ? qt.core.object.QObject.d_ptr.dynamicMetaObject() : &staticMetaObject;
        }
        extern(C++) override void * qt_metacast(const(char)* _clname)
        {
            import qt.core.objectdefs;
            if (!_clname) return null;
            import core.stdc.string;
            if (!core.stdc.string.strcmp(_clname, qt.core.objectdefs.MetaObjectImpl!(typeof(this)).stringdata.stringdata0.ptr))
                return static_cast!(void*)(this);
            return super.qt_metacast(_clname);
        }
        extern(C++) override int qt_metacall(dqtimported!q{qt.core.objectdefs}.QMetaObject.Call  _c, int _id, void **_a)
        {
            import qt.core.objectdefs;
            _id = super.qt_metacall(_c, _id, _a);
            if (_id < 0)
                return _id;
            alias allMethods = qt.core.objectdefs.MetaObjectImpl!(typeof(this)).allMethods;
            if (_c == qt.core.objectdefs.QMetaObject.Call.InvokeMetaMethod) {
                if (_id < allMethods.length)
                    qt_static_metacall(this, _c, _id, _a);
                _id -= allMethods.length;
            } else if (_c == qt.core.objectdefs.QMetaObject.Call.RegisterMethodArgumentMetaType) {
                if (_id < allMethods.length)
                    *reinterpret_cast!(int*)(_a[0]) = -1;
                _id -= allMethods.length;
            }
            return _id;
        }
        extern(C++) static void qt_static_metacall(dqtimported!"qt.core.object".QObject _o, dqtimported!q{qt.core.objectdefs}.QMetaObject.Call _c, int _id, void **_a)
        {
            import qt.core.objectdefs;
            if (_c == qt.core.objectdefs.QMetaObject.Call.InvokeMetaMethod) {
                alias allMethods = qt.core.objectdefs.MetaObjectImpl!(typeof(this)).allMethods;
                import std.conv, std.traits;
                auto _t = static_cast!(typeof(this))(_o);
                //Q_UNUSED(_t)
                switch (_id) {
                    mixin((){
                            string methodCallCases;
                            static foreach(i; 0..allMethods.length)
                            {{
                                methodCallCases ~= text("\n                    case ", i, ": _t.", __traits(identifier, allMethods[i]), "(");
                                static foreach(j, P; Parameters!(allMethods[i]))
                                {
                                    methodCallCases ~= text("*cast(Parameters!(allMethods[", i, "])[", j, "]*)(_a[", j + 1, "]), ");
                                }
                                methodCallCases ~= "); break;";
                            }}
                            return methodCallCases;
                        }());
                default: {}
                }
            } else if (_c == qt.core.objectdefs.QMetaObject.Call.RegisterMethodArgumentMetaType) {
                // TODO
            } else if (_c == qt.core.objectdefs.QMetaObject.Call.IndexOfMethod) {
                alias allSignals = qt.core.objectdefs.MetaObjectImpl!(typeof(this)).allSignals;
                int *result = reinterpret_cast!(int *)(_a[0]);
                static foreach(i; 0..allSignals.length)
                {{
                    alias _t = qt.core.objectdefs.CPPMemberFunctionPointer!(typeof(this));

                    auto fp = &memberFunctionExternDeclaration!(allSignals[i]);
                    qt.core.objectdefs.CPPMemberFunctionPointer!(typeof(this)) memberFunction = qt.core.objectdefs.CPPMemberFunctionPointer!(typeof(this))(fp);

                    if (*reinterpret_cast!(_t *)(_a[1]) == memberFunction) {
                        *result = i;
                        return;
                    }
                }}
            }
            //Q_UNUSED(_a);
        }
        } ~ QT_TR_FUNCTIONS ~ q{
    private:
        struct QPrivateSignal {}
};

enum Q_SIGNAL_IMPL_D = q{
    struct Dummy{}
    import std.traits;
    void*[std.traits.Parameters!(__traits(parent, Dummy)).length + 1] _a = mixin((){
        string r = "[null";
        static foreach(i; 0..std.traits.Parameters!(__traits(parent, Dummy)).length)
            r ~= " , cast(void*)&" ~ std.traits.ParameterIdentifierTuple!(__traits(parent, Dummy))[i];
        r ~= "]";
        return r;
        }());
    dqtimported!q{qt.core.objectdefs}.QMetaObject.activate(this, &staticMetaObject, dqtimported!q{qt.core.objectdefs}.MetaObjectImpl!(typeof(this)).signalIndex!(__traits(parent, Dummy)), _a.ptr);
};

/+ #define Q_GADGET \
public: \
    static const QMetaObject staticMetaObject; \
    void qt_check_for_QGADGET_macro(); \
    typedef void QtGadgetHelper; \
private: \
    QT_WARNING_PUSH \
    Q_OBJECT_NO_ATTRIBUTES_WARNING \
    Q_DECL_HIDDEN_STATIC_METACALL static void qt_static_metacall(QObject *, QMetaObject::Call, int, void **); \
    QT_WARNING_POP \
    QT_ANNOTATE_CLASS(qt_qgadget, "") \
    /*end*/ +/
enum Q_GADGET =
q{    public:
        extern(C++) extern } ~ exportOnWindows ~ q{static __gshared const(dqtimported!q{qt.core.objectdefs}.QMetaObject) staticMetaObject;
        /+ void qt_check_for_QGADGET_macro(); +/
        alias QtGadgetHelper = void;
    private:
        /+ QT_WARNING_PUSH
        Q_OBJECT_NO_ATTRIBUTES_WARNING +/
        /+ Q_DECL_HIDDEN_STATIC_METACALL +/ static void qt_static_metacall(dqtimported!q{qt.core.object}.QObject , dqtimported!q{qt.core.objectdefs}.QMetaObject.Call, int, void** );};
        /+ QT_WARNING_POP
        QT_ANNOTATE_CLASS(qt_qgadget, "") +/
        /*end*/

/* qmake ignore Q_NAMESPACE_EXPORT */
/+ #define Q_NAMESPACE_EXPORT(...) \
    extern __VA_ARGS__ const QMetaObject staticMetaObject; \
    QT_ANNOTATE_CLASS(qt_qnamespace, "") \
    /*end*/

/* qmake ignore Q_NAMESPACE */
#define Q_NAMESPACE Q_NAMESPACE_EXPORT() \
    /*end*/ +/

/+ #endif +/ // QT_NO_META_MACROS

/+ #else // Q_MOC_RUN
#define slots slots
#define signals signals
#define Q_SLOTS Q_SLOTS
#define Q_SIGNALS Q_SIGNALS
#define Q_CLASSINFO(name, value) Q_CLASSINFO(name, value)
#define Q_INTERFACES(x) Q_INTERFACES(x)
#define Q_PROPERTY(text) Q_PROPERTY(text)
#define Q_PRIVATE_PROPERTY(d, text) Q_PRIVATE_PROPERTY(d, text)
#define Q_REVISION(v) Q_REVISION(v)
#define Q_OVERRIDE(text) Q_OVERRIDE(text)
#define Q_ENUMS(x) Q_ENUMS(x)
#define Q_FLAGS(x) Q_FLAGS(x)
#define Q_ENUM(x) Q_ENUM(x)
#define Q_FLAGS(x) Q_FLAGS(x)
 /* qmake ignore Q_OBJECT */
#define Q_OBJECT Q_OBJECT
 /* qmake ignore Q_OBJECT */
#define Q_OBJECT_FAKE Q_OBJECT_FAKE
 /* qmake ignore Q_GADGET */
#define Q_GADGET Q_GADGET
#define Q_SCRIPTABLE Q_SCRIPTABLE
#define Q_INVOKABLE Q_INVOKABLE
#define Q_SIGNAL Q_SIGNAL
#define Q_SLOT Q_SLOT
#endif //Q_MOC_RUN

#ifndef QT_NO_META_MACROS
// macro for onaming members
#ifdef METHOD
#undef METHOD
#endif
#ifdef SLOT
#undef SLOT
#endif
#ifdef SIGNAL
#undef SIGNAL
#endif
#endif +/ // QT_NO_META_MACROS

/+ Q_CORE_EXPORT +/ const(char)* qFlagLocation(const(char)* method);

/+ #ifndef QT_NO_META_MACROS +/
/+ #ifndef QT_NO_DEBUG
# define QLOCATION "\0" __FILE__ ":" QT_STRINGIFY(__LINE__)
# ifndef QT_NO_KEYWORDS
#  define METHOD(a)   qFlagLocation("0"#a QLOCATION)
# endif
# define SLOT(a)     qFlagLocation("1"#a QLOCATION)
# define SIGNAL(a)   qFlagLocation("2"#a QLOCATION)
#else +/
/+ # ifndef QT_NO_KEYWORDS
#  define METHOD(a)   "0"#a
# endif +/
/+ # define SLOT(a)     "1"#a +/
extern(D) alias SLOT = function string(string a)
{
    return     mixin(interpolateMixin(q{"1" ~$(stringifyMacroParameter(a))}));
};
/+ # define SIGNAL(a)   "2"#a +/
extern(D) alias SIGNAL = function string(string a)
{
    return   mixin(interpolateMixin(q{"2" ~$(stringifyMacroParameter(a))}));
};
/+ #endif

#define QMETHOD_CODE  0                        // member type codes
#define QSLOT_CODE    1
#define QSIGNAL_CODE  2 +/
/+ #endif // QT_NO_META_MACROS

#define Q_ARG(type, data) QArgument<type >(#type, data)
#define Q_RETURN_ARG(type, data) QReturnArgument<type >(#type, data) +/



/// Binding for C++ class [QGenericArgument](https://doc.qt.io/qt-5/qgenericargument.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QGenericArgument
{
public:
    pragma(inline, true) this(const(char)* aName/+ = null+/, const(void)* aData = null)
    {
        this._data = aData;
        this._name = aName;
    }
    pragma(inline, true) void* data() const { return const_cast!(void*)(_data); }
    pragma(inline, true) const(char)* name() const { return _name; }

private:
    const(void)* _data = null;
    const(char)* _name = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QGenericReturnArgument](https://doc.qt.io/qt-5/qgenericreturnargument.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QGenericReturnArgument
{
    public QGenericArgument base0;
    alias base0 this;
public:
    pragma(inline, true) this(const(char)* aName/+ = null+/, void* aData = null)
    {
        this.base0 = QGenericArgument(aName, aData);
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

class QArgument(T): QGenericArgument
{
public:
    pragma(inline, true) this(const(char)* aName, ref const(T) aData)
    {
        super(aName, static_cast!(const(void)*)(&aData));
    }
}
/+ template <class T>
class QArgument<T &>: public QGenericArgument
{
public:
    inline QArgument(const char *aName, T &aData)
        : QGenericArgument(aName, static_cast<const void *>(&aData))
        {}
}; +/


class QReturnArgument(T): QGenericReturnArgument
{
public:
    pragma(inline, true) this(const(char)* aName, ref T aData)
    {
        super(aName, static_cast!(void*)(&aData));
    }
}

struct /+ Q_CORE_EXPORT +/ QMetaObject
{
    /+
    extern(C++, class) struct Connection;
    +/
    /// Binding for C++ class [Connection](https://doc.qt.io/qt-5/qmetaobject-connection.html).
    extern(C++, class) struct /+ Q_CORE_EXPORT +/ Connection {
    private:
        void* d_ptr; //QObjectPrivate::Connection*
        /+ explicit +/this(void* data)
        {
            this.d_ptr = data;
        }
        /+ friend class QObject; +/
        /+ friend class QObjectPrivate; +/
        /+ friend struct QMetaObject; +/
        bool isConnected_helper() const;
    public:
        ~this();

        this(ref const(Connection) other);
        /+ref Connection operator =(ref const(Connection) other);+/
    /+ #ifdef Q_QDOC
        operator bool() const;
    #else +/
        alias RestrictedBool = void*/+ Connection::* +/*;
        /+auto opCast(T : RestrictedBool)() const { return d_ptr && isConnected_helper() ? &Connection.d_ptr : null; }+/
    /+ #endif +/

        /+ Connection(Connection &&o) noexcept : d_ptr(o.d_ptr) { o.d_ptr = nullptr; } +/
        /+ Connection &operator=(Connection &&other) noexcept
        { qSwap(d_ptr, other.d_ptr); return *this; } +/
        mixin(CREATE_CONVENIENCE_WRAPPERS);
    }

    const(char)* className() const;
/+    pragma(inline, true) const(QMetaObject)* superClass() const
    { return cast(const(QMetaObject)*)(d.superdata); }+/

    bool inherits(const(QMetaObject)* metaObject) const/+ noexcept+/;
    mixin(mangleWindows("?cast@QMetaObject@@QEBAPEAVQObject@@PEAV2@@Z", q{
    mixin(mangleItanium("_ZNK11QMetaObject4castEP7QObject", q{
    QObject cast_(QObject obj) const;
    }));
    }));
    //const(QObject) cast_(const(QObject) obj) const;

    version(QT_NO_TRANSLATION){}else
    {
        QString tr(const(char)* s, const(char)* c, int n = -1) const;
    }

    int methodOffset() const;
    int enumeratorOffset() const;
    int propertyOffset() const;
    int classInfoOffset() const;

    int constructorCount() const;
    int methodCount() const;
    int enumeratorCount() const;
    int propertyCount() const;
    int classInfoCount() const;

    int indexOfConstructor(const(char)* constructor) const;
    int indexOfMethod(const(char)* method) const;
    int indexOfSignal(const(char)* signal) const;
    int indexOfSlot(const(char)* slot) const;
    int indexOfEnumerator(const(char)* name) const;
    int indexOfProperty(const(char)* name) const;
    int indexOfClassInfo(const(char)* name) const;

    QMetaMethod constructor(int index) const;
    QMetaMethod method(int index) const;
    QMetaEnum enumerator(int index) const;
    QMetaProperty property(int index) const;
    QMetaClassInfo classInfo(int index) const;
    QMetaProperty userProperty() const;

    static bool checkConnectArgs(const(char)* signal, const(char)* method);
    static bool checkConnectArgs(ref const(QMetaMethod) signal,
                                     ref const(QMetaMethod) method);
    static QByteArray normalizedSignature(const(char)* method);
    static QByteArray normalizedType(const(char)* type);

    // internal index-based connect
    /+ static Connection connect(const QObject *sender, int signal_index,
                        const QObject *receiver, int method_index,
                        int type = 0, int *types = nullptr); +/
    // internal index-based disconnect
    /+ static bool disconnect(const QObject *sender, int signal_index,
                           const QObject *receiver, int method_index); +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static bool disconnectOne(const(QObject) sender, int signal_index,
                                  const(QObject) receiver, int method_index);
    }));
    // internal slot-name based connect
    static void connectSlotsByName(QObject o);

    // internal index-based signal activation
    static void activate(QObject sender, int signal_index, void** argv);
    static void activate(QObject sender, const(QMetaObject)* , int local_signal_index, void** argv);
    static void activate(QObject sender, int signal_offset, int local_signal_index, void** argv);

    static bool invokeMethod(QObject obj, const(char)* member,
                                 /+ Qt:: +/qt.core.namespace.ConnectionType,
                                 QGenericReturnArgument ret,
                                 QGenericArgument val0 = QGenericArgument(null),
                                 QGenericArgument val1 = QGenericArgument(),
                                 QGenericArgument val2 = QGenericArgument(),
                                 QGenericArgument val3 = QGenericArgument(),
                                 QGenericArgument val4 = QGenericArgument(),
                                 QGenericArgument val5 = QGenericArgument(),
                                 QGenericArgument val6 = QGenericArgument(),
                                 QGenericArgument val7 = QGenericArgument(),
                                 QGenericArgument val8 = QGenericArgument(),
                                 QGenericArgument val9 = QGenericArgument());

/+    pragma(inline, true) static bool invokeMethod(QObject obj, const(char)* member,
                                 QGenericReturnArgument ret,
                                 QGenericArgument val0 = QGenericArgument(null),
                                 QGenericArgument val1 = QGenericArgument(),
                                 QGenericArgument val2 = QGenericArgument(),
                                 QGenericArgument val3 = QGenericArgument(),
                                 QGenericArgument val4 = QGenericArgument(),
                                 QGenericArgument val5 = QGenericArgument(),
                                 QGenericArgument val6 = QGenericArgument(),
                                 QGenericArgument val7 = QGenericArgument(),
                                 QGenericArgument val8 = QGenericArgument(),
                                 QGenericArgument val9 = QGenericArgument())
    {
        return invokeMethod(obj, member, /+ Qt:: +/qt.core.namespace.ConnectionType.AutoConnection, ret, val0, val1, val2, val3,
                val4, val5, val6, val7, val8, val9);
    }+/

/+    pragma(inline, true) static bool invokeMethod(QObject obj, const(char)* member,
                                 /+ Qt:: +/qt.core.namespace.ConnectionType type,
                                 QGenericArgument val0 = QGenericArgument(null),
                                 QGenericArgument val1 = QGenericArgument(),
                                 QGenericArgument val2 = QGenericArgument(),
                                 QGenericArgument val3 = QGenericArgument(),
                                 QGenericArgument val4 = QGenericArgument(),
                                 QGenericArgument val5 = QGenericArgument(),
                                 QGenericArgument val6 = QGenericArgument(),
                                 QGenericArgument val7 = QGenericArgument(),
                                 QGenericArgument val8 = QGenericArgument(),
                                 QGenericArgument val9 = QGenericArgument())
    {
        return invokeMethod(obj, member, type, QGenericReturnArgument(), val0, val1, val2,
                                 val3, val4, val5, val6, val7, val8, val9);
    }+/

/+    pragma(inline, true) static bool invokeMethod(QObject obj, const(char)* member,
                                 QGenericArgument val0 = QGenericArgument(null),
                                 QGenericArgument val1 = QGenericArgument(),
                                 QGenericArgument val2 = QGenericArgument(),
                                 QGenericArgument val3 = QGenericArgument(),
                                 QGenericArgument val4 = QGenericArgument(),
                                 QGenericArgument val5 = QGenericArgument(),
                                 QGenericArgument val6 = QGenericArgument(),
                                 QGenericArgument val7 = QGenericArgument(),
                                 QGenericArgument val8 = QGenericArgument(),
                                 QGenericArgument val9 = QGenericArgument())
    {
        return invokeMethod(obj, member, /+ Qt:: +/qt.core.namespace.ConnectionType.AutoConnection, QGenericReturnArgument(), val0,
                val1, val2, val3, val4, val5, val6, val7, val8, val9);
    }+/

/+ #ifdef Q_CLANG_QDOC
    template<typename Functor, typename FunctorReturnType>
    static bool invokeMethod(QObject *context, Functor function, Qt::ConnectionType type = Qt::AutoConnection, FunctorReturnType *ret = nullptr);
    template<typename Functor, typename FunctorReturnType>
    static bool invokeMethod(QObject *context, Functor function, FunctorReturnType *ret);
#else +/

    // invokeMethod() for member function pointer
    /+ template <typename Func> +/
    /+ static typename std::enable_if<QtPrivate::FunctionPointer<Func>::IsPointerToMemberFunction
                                   && !std::is_convertible<Func, const char*>::value
                                   && QtPrivate::FunctionPointer<Func>::ArgumentCount == 0, bool>::type
    invokeMethod(typename QtPrivate::FunctionPointer<Func>::Object *object,
                 Func function,
                 Qt::ConnectionType type = Qt::AutoConnection,
                 typename QtPrivate::FunctionPointer<Func>::ReturnType *ret = nullptr)
    {
        return invokeMethodImpl(object, new QtPrivate::QSlotObjectWithNoArgs<Func>(function), type, ret);
    } +/

    /+ template <typename Func> +/
    /+ static typename std::enable_if<QtPrivate::FunctionPointer<Func>::IsPointerToMemberFunction
                                   && !std::is_convertible<Func, const char*>::value
                                   && QtPrivate::FunctionPointer<Func>::ArgumentCount == 0, bool>::type
    invokeMethod(typename QtPrivate::FunctionPointer<Func>::Object *object,
                 Func function,
                 typename QtPrivate::FunctionPointer<Func>::ReturnType *ret)
    {
        return invokeMethodImpl(object, new QtPrivate::QSlotObjectWithNoArgs<Func>(function), Qt::AutoConnection, ret);
    } +/

    // invokeMethod() for function pointer (not member)
    /+ template <typename Func> +/
    /+ static typename std::enable_if<!QtPrivate::FunctionPointer<Func>::IsPointerToMemberFunction
                                   && !std::is_convertible<Func, const char*>::value
                                   && QtPrivate::FunctionPointer<Func>::ArgumentCount == 0, bool>::type
    invokeMethod(QObject *context, Func function,
                 Qt::ConnectionType type = Qt::AutoConnection,
                 typename QtPrivate::FunctionPointer<Func>::ReturnType *ret = nullptr)
    {
        return invokeMethodImpl(context, new QtPrivate::QFunctorSlotObjectWithNoArgsImplicitReturn<Func>(function), type, ret);
    } +/

    /+ template <typename Func> +/
    /+ static typename std::enable_if<!QtPrivate::FunctionPointer<Func>::IsPointerToMemberFunction
                                   && !std::is_convertible<Func, const char*>::value
                                   && QtPrivate::FunctionPointer<Func>::ArgumentCount == 0, bool>::type
    invokeMethod(QObject *context, Func function,
                 typename QtPrivate::FunctionPointer<Func>::ReturnType *ret)
    {
        return invokeMethodImpl(context, new QtPrivate::QFunctorSlotObjectWithNoArgsImplicitReturn<Func>(function), Qt::AutoConnection, ret);
    } +/

    // invokeMethod() for Functor
    /+ template <typename Func> +/
    /+ static typename std::enable_if<!QtPrivate::FunctionPointer<Func>::IsPointerToMemberFunction
                                   && QtPrivate::FunctionPointer<Func>::ArgumentCount == -1
                                   && !std::is_convertible<Func, const char*>::value, bool>::type
    invokeMethod(QObject *context, Func function,
                 Qt::ConnectionType type = Qt::AutoConnection, decltype(function()) *ret = nullptr)
    {
        return invokeMethodImpl(context,
                                new QtPrivate::QFunctorSlotObjectWithNoArgs<Func, decltype(function())>(std::move(function)),
                                type,
                                ret);
    } +/

    /+ template <typename Func> +/
    /+ static typename std::enable_if<!QtPrivate::FunctionPointer<Func>::IsPointerToMemberFunction
                                   && QtPrivate::FunctionPointer<Func>::ArgumentCount == -1
                                   && !std::is_convertible<Func, const char*>::value, bool>::type
    invokeMethod(QObject *context, Func function, decltype(function()) *ret)
    {
        return invokeMethodImpl(context,
                                new QtPrivate::QFunctorSlotObjectWithNoArgs<Func, decltype(function())>(std::move(function)),
                                Qt::AutoConnection,
                                ret);
    } +/

/+ #endif +/

    QObject newInstance(QGenericArgument val0 = QGenericArgument(null),
                             QGenericArgument val1 = QGenericArgument(),
                             QGenericArgument val2 = QGenericArgument(),
                             QGenericArgument val3 = QGenericArgument(),
                             QGenericArgument val4 = QGenericArgument(),
                             QGenericArgument val5 = QGenericArgument(),
                             QGenericArgument val6 = QGenericArgument(),
                             QGenericArgument val7 = QGenericArgument(),
                             QGenericArgument val8 = QGenericArgument(),
                             QGenericArgument val9 = QGenericArgument()) const;

    enum Call {
        InvokeMetaMethod,
        ReadProperty,
        WriteProperty,
        ResetProperty,
        QueryPropertyDesignable,
        QueryPropertyScriptable,
        QueryPropertyStored,
        QueryPropertyEditable,
        QueryPropertyUser,
        CreateInstance,
        IndexOfMethod,
        RegisterPropertyMetaType,
        RegisterMethodArgumentMetaType
    }

    int static_metacall(Call, int, void** ) const;
    static int metacall(QObject , Call, int, void** );

    static const(QMetaObject*) staticMetaObject(alias MO)()
    {
        return &MO;
    }

    struct SuperData {
        const(QMetaObject)* direct;
        /+ SuperData() = default; +/
        this(typeof(null))
        {
            this.direct = null;
        }
        this(const(QMetaObject)* mo)
        {
            this.direct = mo;
        }

        /+const(QMetaObject)* operator ->() const { return operator const QMetaObject *(); }+/

        version(QT_NO_DATA_RELOCATION)
        {
            alias Getter = ExternCPPFunc!(const(QMetaObject)* function());
            Getter indirect = null;
            this(Getter g)
            {
                this.direct = null;
                this.indirect = g;
            }
            /+auto opCast(T : const(QMetaObject))() const
            { return indirect ? indirect() : cast(const(QMetaObject))(direct); }+/
            /+ template <const QMetaObject &MO> +/ /+ static constexpr SuperData link()
            { return SuperData(QMetaObject::staticMetaObject<MO>); } +/
        }
        else
        {
            /+auto opCast(T : const(QMetaObject))() const
            { return cast(const(QMetaObject))(direct); }+/
            static SuperData link(alias MO)()
            { return SuperData(QMetaObject.staticMetaObject!(MO)()); }
        }
    }

    struct generated_qobjectdefs_0 { // private data
        SuperData superdata;
        const(void)* stringdata;
        const(uint)* data;
        alias StaticMetacallFunction = ExternCPPFunc!(void function(QObject , QMetaObject.Call, int, void** ));
        StaticMetacallFunction static_metacall;
        const(SuperData)* relatedMetaObjects;
        void* extradata; //reserved for future use
    }generated_qobjectdefs_0 d;

private:
    static bool invokeMethodImpl(QObject object, /+ QtPrivate:: +/qt.core.objectdefs_impl.QSlotObjectBase* slot, /+ Qt:: +/qt.core.namespace.ConnectionType type, void* ret);
    /+ friend class QTimer; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, "QtPrivate") {
    /* Trait that tells is a the Object has a Q_OBJECT macro */
    struct HasQ_OBJECT_Macro(Object) {
        /+ template <typename T> +/
        static char test(T)(ExternCPPFunc!(int function(QMetaObject.Call, int, void** ))/+ T::* +/ );
        static int test(ExternCPPFunc!(int function(QMetaObject.Call, int, void** ))/+ Object::* +/ );
        enum { Value =  (test(&Object.qt_metacall)). sizeof == int.sizeof }
    }
}

