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
module qt.core.metamacros;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.flags;
import qt.core.object;
import qt.core.objectdefs;
import qt.core.point;
import qt.core.string;
import qt.helpers;
import std.traits;
import std.meta;

/+ #ifndef Q_MOC_OUTPUT_REVISION
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

version (QT_NO_TRANSLATION) {} else
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
version (QT_NO_TRANSLATION)
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
        static import qt.core.objectdefs;
        extern(C++) extern } ~ exportOnWindows ~ q{static __gshared const(qt.core.objectdefs.QMetaObject) staticMetaObject;
        extern(C++) override /+ virtual +/ const(qt.core.objectdefs.QMetaObject)* metaObject() const;
        extern(C++) override /+ virtual +/ void* qt_metacast(const(char)* );
        extern(C++) override /+ virtual +/ int qt_metacall(qt.core.objectdefs.QMetaObject.Call, int, void** );
        } ~ QT_TR_FUNCTIONS ~ q{
    private:
        /+ Q_OBJECT_NO_ATTRIBUTES_WARNING +/
        /+ Q_DECL_HIDDEN_STATIC_METACALL +/ static void qt_static_metacall(dqtimported!"qt.core.object".QObject , qt.core.objectdefs.QMetaObject.Call, int, void** );
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

template memberFunctionExternDeclaration(alias F)
{
    version (Windows)
    extern(D) mixin((){
            string code;
            version (Windows)
                static if (IsInQtPackage!(F))
                    code ~= "export ";
            code ~= "extern(" ~ functionLinkage!F ~ ")";
            code ~= q{pragma(mangle, F.mangleof) ReturnType!F memberFunctionExternDeclaration(__traits(parent, F), Parameters!F);};
            return code;
        }());
    else
        alias memberFunctionExternDeclaration = F;
}

extern(D) auto getMemberFunctionAddress(alias F)()
{
    version (Windows)
    version (LDC)
    {
        import core.sys.windows.windef: HMODULE;
        import core.sys.windows.winbase: GetModuleHandle, GetProcAddress;
        import std.algorithm: startsWith;
        import std.ascii: toLower;

        static foreach (qtmodule; ["Core", "Gui", "Widgets", "Network", "WebEngineCore", "WebEngineWidgets"])
        {{
            static if (qtmodule.startsWith("WebEngine"))
                enum prefix = "qt.webengine";
            else
                enum prefix = "qt." ~ qtmodule[0].toLower ~ qtmodule[1 .. $];
            enum dllName = "Qt5" ~ qtmodule;
            enum dllNamed = "Qt5" ~ qtmodule ~ "d";

            HMODULE hmodule;
            if (qt.helpers.packageName!F.startsWith(prefix))
            {
                hmodule = GetModuleHandle(dllName);
                if (hmodule is null)
                    hmodule = GetModuleHandle(dllNamed);
            }
            if (hmodule !is null)
            {
                auto signal = cast(typeof(&memberFunctionExternDeclaration!F)) GetProcAddress(hmodule, F.mangleof);
                if (signal !is null)
                    return signal;
            }
        }}

    }
    return &memberFunctionExternDeclaration!F;
}

enum NotIsConstructor(alias F) = __traits(identifier, F) != "__ctor";

template MetaObjectImpl(T)
{
    import qt.core.refcount;
    import qt.core.metatype;
    extern(D):

    alias Overloads(string name) = __traits(getOverloads, T, name);
    enum IsQEnumOrFlag(string name) = is(__traits(getMember, T, name) == enum) || is(__traits(getMember, T, name) : QFlags!X, X);
    //pragma(msg, staticMap!(Overloads, __traits(derivedMembers, T)));
    alias allFunctions = Filter!(NotIsConstructor, staticMap!(Overloads, __traits(derivedMembers, T)));
    alias allSignals = Filter!(IsQSignal, allFunctions);
    alias allSlots = Filter!(IsQSlot, allFunctions);
    alias allInvokables = Filter!(IsQInvokable, allFunctions);
    alias allMethods = std.meta.AliasSeq!(allSignals, allSlots, allInvokables);
    alias allFields = T.tupleof;
    alias allEnumsFlags = Filter!(IsQEnumOrFlag, __traits(derivedMembers, T));

    /*pragma(msg, allSignals);
    pragma(msg, allSlots);
    pragma(msg, allInvokables);*/

    template signalIndex(alias F)
    {
        enum signalIndex = staticIndexOf!(F, allSignals);
    }

    string generateCode()
    {
        import std.algorithm;
        import std.conv;
        import std.ascii;

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

        string typeToMetaComplex(T2)()
        {
            string r = fullyQualifiedNameCpp!(T2, QualifiedNameCppFlags.ignoreConst | QualifiedNameCppFlags.replaceQFlags);
            if (r.startsWith(__traits(identifier, T) ~ "::"))
                r = r[__traits(identifier, T).length + 2 .. $];
            return r;
        }
        string typeToMeta(T2)()
        {
            import qt.core.list: QList;
            import qt.core.vector: QVector;
            static if (is(T2 == int))
                return "QMetaType.Type.Int";
            else static if (is(T2 == uint))
                return "QMetaType.Type.UInt";
            else static if (is(T2 == bool))
                return "QMetaType.Type.Bool";
            else static if (is(T2 == double))
                return "QMetaType.Type.Double";
            else static if (is(T2 == void))
                return "QMetaType.Type.Void";
            else static if (is(const(T2) == const(QString)))
                return "QMetaType.Type.QString";
            else static if (is(const(T2) == const(QPoint)))
                return "QMetaType.Type.QPoint";
            else
                return text("0x80000000 | ", addString(typeToMetaComplex!T2), " /* ", typeToMetaComplex!T2, " */");
        }

        struct PropertyInfo
        {
            string name;
            string type;
            string typeCode;
            size_t readFunc = size_t.max;
            string readFuncCode;
            size_t writeFunc = size_t.max;
            string writeFuncCode;
            size_t notifyFunc = size_t.max;
            string notifyFuncCode;
            size_t field = size_t.max;
            bool isConstant;
        }
        PropertyInfo*[] allPropertyInfos;
        size_t[string] propertyInfoByName;
        PropertyInfo* getPropertyInfo(string name)
        {
            if (name in propertyInfoByName)
                return allPropertyInfos[propertyInfoByName[name]];
            allPropertyInfos ~= new PropertyInfo(name);
            propertyInfoByName[name] = allPropertyInfos.length - 1;
            return allPropertyInfos[$ - 1];
        }
        void updatePropertyInfo(PropertyInfo* propertyInfo, QObject.QPropertyDef prop, string typeName, string typeCode)
        {
            if (typeName != "")
            {
                assert(propertyInfo.type == "" || propertyInfo.type == typeName, text("Conflicting types for property ", propertyInfo.name, ": ", propertyInfo.type, " != ", typeName));
                propertyInfo.type = typeName;
            }
            if (propertyInfo.typeCode == "")
            {
                propertyInfo.typeCode = typeCode;
            }
            if (prop.notify)
            {
                static foreach (i, F; allSignals)
                {
                    if (__traits(identifier, F) == prop.notify)
                    {
                        if (Parameters!F.length)
                        {
                            assert(false, "Notify signal for property with parameters not supported");
                        }
                        else if (!(propertyInfo.notifyFunc == size_t.max || propertyInfo.notifyFunc == i))
                        {
                            assert(false, "Duplicate notify signals for property " ~ propertyInfo.name ~ ": " ~ __traits(identifier, F));
                        }
                        else
                        {
                            propertyInfo.notifyFunc = i;
                            propertyInfo.notifyFuncCode = __traits(identifier, F) ~ "()";
                        }
                    }
                }
            }
            if (prop.isConstant)
            {
                propertyInfo.isConstant = true;
            }
        }
        static foreach (i, F; allFunctions)
        {
            static foreach (prop_; getUDAs!(F, QObject.QPropertyDef))
            {{
                static if (is(prop_ == struct))
                    enum QObject.QPropertyDef prop = prop_.init;
                else
                    enum QObject.QPropertyDef prop = prop_;
                static if (IsQSignal!F)
                {
                    static if (prop.name.length)
                        enum name = prop.name;
                    else static if (__traits(identifier, F).endsWith("Changed"))
                        enum name = __traits(identifier, F)[0 .. $ - 7];
                    else
                        static assert(false, "No name for property signal " ~ __traits(identifier, F));

                    auto propertyInfo = getPropertyInfo(name);
                    // Handled in separate loop
                }
                else static if (Parameters!F.length == 0)
                {
                    static if (prop.name.length)
                        enum name = prop.name;
                    else
                        enum name = __traits(identifier, F);

                    string typeName = typeToMeta!(ReturnType!F);

                    auto propertyInfo = getPropertyInfo(name);
                    assert(propertyInfo.readFunc == size_t.max || propertyInfo.readFunc == i, "Duplicate getters for property " ~ name ~ ": " ~ __traits(identifier, F));
                    propertyInfo.readFunc = i;
                    updatePropertyInfo(propertyInfo, prop, typeName, text("ReturnType!(allFunctions[", i, "])"));
                    propertyInfo.readFuncCode = __traits(identifier, F) ~ "()";
                }
                else static if (Parameters!F.length == 1)
                {
                    static if (prop.name.length)
                        enum name = prop.name;
                    else static if (__traits(identifier, F).startsWith("set") && __traits(identifier, F).length >= 4)
                        enum name = toLower(__traits(identifier, F)[3]) ~ __traits(identifier, F)[4 .. $];
                    else
                        enum name = __traits(identifier, F);

                    string typeName = typeToMeta!(Parameters!F[0]);

                    auto propertyInfo = getPropertyInfo(name);
                    assert(propertyInfo.writeFunc == size_t.max || propertyInfo.writeFunc == i, "Duplicate setters for property " ~ name ~ ": " ~ __traits(identifier, F));
                    propertyInfo.writeFunc = i;
                    updatePropertyInfo(propertyInfo, prop, typeName, text("Parameters!(allFunctions[", i, "])[0]"));
                    propertyInfo.writeFuncCode = text("_t.", __traits(identifier, F), "(*cast(allPropertyTypes[", propertyInfoByName[name], "]*)(_v));");
                }
                else
                    static assert(false, "Unsupported function for property " ~ __traits(identifier, F));
            }}
        }
        static foreach (i, F; allSignals)
        {
            static foreach (prop_; getUDAs!(F, QObject.QPropertyDef))
            {{
                static if (is(prop_ == struct))
                    enum QObject.QPropertyDef prop = prop_.init;
                else
                    enum QObject.QPropertyDef prop = prop_;

                static assert(Parameters!F.length == 0, "Notify signal for property with parameters not supported");

                static if (prop.name.length)
                    enum name = prop.name;
                else static if (__traits(identifier, F).endsWith("Changed"))
                    enum name = __traits(identifier, F)[0 .. $ - 7];
                else
                    static assert(false, "No name for property signal " ~ __traits(identifier, F));

                auto propertyInfo = getPropertyInfo(name);
                assert(propertyInfo.notifyFunc == size_t.max || propertyInfo.notifyFunc == i, "Duplicate notify signals for property " ~ name ~ ": " ~ __traits(identifier, F));
                propertyInfo.notifyFunc = i;
                updatePropertyInfo(propertyInfo, prop, "", "");
                propertyInfo.notifyFuncCode = __traits(identifier, F) ~ "()";
            }}
        }
        static foreach (i, F; allFields)
        {
            static foreach (prop_; getUDAs!(F, QObject.QPropertyDef))
            {{
                static if (is(prop_ == struct))
                    enum QObject.QPropertyDef prop = prop_.init;
                else
                    enum QObject.QPropertyDef prop = prop_;

                static if (prop.name.length)
                    enum name = prop.name;
                else
                    enum name = __traits(identifier, F);

                string typeName = typeToMeta!(typeof(F));

                auto propertyInfo = getPropertyInfo(name);
                assert(propertyInfo.field == size_t.max, "Duplicate fields for property " ~ name ~ ": " ~ __traits(identifier, F));
                assert(propertyInfo.readFunc == size_t.max && propertyInfo.writeFunc == size_t.max,
                    "Field and getter/setter for property " ~ name ~ ": " ~ __traits(identifier, F));
                propertyInfo.field = i;
                propertyInfo.readFuncCode = __traits(identifier, F);
                updatePropertyInfo(propertyInfo, prop, typeName, text("typeof(allFields[", i, "])"));

                string value = text("*cast(allPropertyTypes[", propertyInfoByName[name], "]*)(_v)");
                propertyInfo.writeFuncCode = text("if (_t.", __traits(identifier, F), " != ", value, ") {");
                propertyInfo.writeFuncCode ~= text("_t.", __traits(identifier, F), " = ", value, ";");
                if (propertyInfo.notifyFuncCode != "")
                    propertyInfo.writeFuncCode ~= text(" /*emit*/ _t.", propertyInfo.notifyFuncCode, ";");
                propertyInfo.writeFuncCode ~= text("}");
            }}
        }

        size_t currentOutputIndex = 0;

        currentOutputIndex += 14;

        size_t methodsStartIndex = currentOutputIndex;

        string metaDataCode;

        assert(methodsStartIndex == currentOutputIndex);
        currentOutputIndex += 5 * allMethods.length;

        void addMethods(M...)(string typename, uint type)
        {
            if(M.length)
                metaDataCode ~= "    // " ~ typename ~ ": name, argc, parameters, tag, flags\n";
            static foreach (i; 0 .. M.length)
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
            static foreach (i; 0 .. M.length)
            {
                metaDataCode ~= text("                    ", typeToMeta!(ReturnType!(M[i])), ", ");
                foreach (P; Parameters!(M[i]))
                    metaDataCode ~= typeToMeta!(P) ~ ", ";
                foreach (j, P; Parameters!(M[i]))
                    metaDataCode ~= text(addString(ParameterIdentifierTuple!(M[i])[j]), ", ");
                metaDataCode ~= "// " ~ __traits(identifier, M[i]) ~ "\n";
            }
        }
        addMethodParameters!(allSignals)("signals");
        addMethodParameters!(allSlots)("slots");
        addMethodParameters!(allInvokables)("methods");

        size_t propertiesStartIndex = 0;
        string allPropertyTypesCode;
        string allReadFuncCode;
        string allWriteFuncCode;

        if (allPropertyInfos.length)
        {
            propertiesStartIndex = currentOutputIndex;
            metaDataCode ~= "    // properties: name, type, flags\n";
            foreach (propertyInfo; allPropertyInfos)
            {
                size_t nameId = addString(propertyInfo.name);
                uint flags = 0x00095000;
                if (propertyInfo.readFunc != size_t.max || propertyInfo.field != size_t.max)
                    flags |= 1;
                if (propertyInfo.writeFunc != size_t.max || propertyInfo.field != size_t.max)
                    flags |= 2;
                if (propertyInfo.notifyFunc != size_t.max)
                    flags |= 0x400000;
                if (propertyInfo.isConstant)
                    flags |= 0x400;
                assert(propertyInfo.type != "", "Missing type for property " ~ propertyInfo.name);
                assert(propertyInfo.isConstant || propertyInfo.notifyFunc != size_t.max, "Property " ~ propertyInfo.name ~ " has no notify signal and is not marked constant");
                metaDataCode ~= mixin(interpolateMixin(q{
                       $(text(nameId)), $(propertyInfo.type), $(text(flags)), $("// " ~ propertyInfo.name)
                }));
                currentOutputIndex += 3;
            }
            metaDataCode ~= "    // properties: notify_signal_id\n";
            foreach (propertyInfo; allPropertyInfos)
            {
                metaDataCode ~= mixin(interpolateMixin(q{
                       $(text(propertyInfo.notifyFunc != size_t.max ? propertyInfo.notifyFunc : 0)), $("// " ~ propertyInfo.name)
                }));
                currentOutputIndex += 1;
            }

            foreach (propertyInfo; allPropertyInfos)
            {
                if (allPropertyTypesCode.length)
                    allPropertyTypesCode ~= ", ";
                allPropertyTypesCode ~= propertyInfo.typeCode;

                if (allReadFuncCode.length)
                    allReadFuncCode ~= ", ";
                allReadFuncCode ~= "\"" ~ propertyInfo.readFuncCode ~ "\"";

                if (allWriteFuncCode.length)
                    allWriteFuncCode ~= ", ";
                allWriteFuncCode ~= "\"" ~ propertyInfo.writeFuncCode ~ "\"";
            }
        }

        size_t enumsStartIndex = 0;

        if (allEnumsFlags.length)
        {
            enumsStartIndex = currentOutputIndex;
            metaDataCode ~= "    // enums: name, alias, flags, count, data\n";
            currentOutputIndex += 5 * allEnumsFlags.length;
            string enumMembersCode = "    // enum data: key, value\n";
            foreach (name; allEnumsFlags)
            {
                uint flags = 0x2;
                static if (is(__traits(getMember, T, name) : QFlags!X, X))
                {
                    flags |= 0x1;
                    alias E = X;
                }
                else
                    alias E = __traits(getMember, T, name);

                size_t nameId = addString(name);
                size_t aliasId = addString(__traits(identifier, E));
                alias enumMembers = __traits(derivedMembers, E);
                metaDataCode ~= mixin(interpolateMixin(q{
                       $(text(nameId)), $(text(aliasId)), $(text(flags)), $(text(enumMembers.length)), $(text(currentOutputIndex)), $("// " ~ name)
                }));
                foreach (name2; enumMembers)
                {
                    size_t nameId2 = addString(name2);
                    uint value = cast(uint) __traits(getMember, E, name2);
                    enumMembersCode ~= mixin(interpolateMixin(q{
                           $(text(nameId2)), $(text(value)), $("// " ~ name)
                    }));
                    currentOutputIndex += 2;
                }
            }
            metaDataCode ~= enumMembersCode;
        }

        addString("");

        string concatenatedStringsCode = "\"";
        foreach (char c; concatenatedStrings)
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
             // content:
                   8,       // revision
                   0,       // classname
                   0,    0, // classinfo
                   $(text(allMethods.length)),   $(text(methodsStartIndex)), // methods
                   $(text(allPropertyInfos.length)),    $(text(propertiesStartIndex)), // properties
                   $(text(allEnumsFlags.length)),    $(text(enumsStartIndex)), // enums/sets
                   0,    0, // constructors
                   0,       // flags
                   $(text(allSignals.length)),       // signalCount

                    $(metaDataCode)
                   0        // eod
            ];

            version (Windows)
            {
                pragma(mangle, T.staticMetaObject.mangleof)
                extern(C++) static __gshared QMetaObject staticMetaObject = { {
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
                    staticMetaObject.d.superdata.direct = &BaseClassesTuple!(T)[0].staticMetaObject;
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

            alias allPropertyTypes = AliasSeq!($(allPropertyTypesCode));
            enum allReadFuncCode = [$(allReadFuncCode)];
            enum allWriteFuncCode = [$(allWriteFuncCode)];
        }));
    }
    //pragma(msg, generateCode());
    mixin(generateCode());
}

enum Q_OBJECT_D = q{
    public:
        static import qt.core.objectdefs;
        version (Windows)
            extern(C++) extern static __gshared qt.core.objectdefs.QMetaObject staticMetaObject;
        else
            extern(C++) extern static __gshared const(qt.core.objectdefs.QMetaObject) staticMetaObject;
        extern(C++) override const(qt.core.objectdefs.QMetaObject)* metaObject() const
        {
            import qt.core.object;
            return qt.core.object.QObject.d_ptr.metaObject ? qt.core.object.QObject.d_ptr.dynamicMetaObject() : &staticMetaObject;
        }
        extern(C++) override void * qt_metacast(const(char)* _clname)
        {
            import qt.core.metamacros;
            import qt.core.objectdefs;
            if (!_clname) return null;
            import core.stdc.string;
            if (!core.stdc.string.strcmp(_clname, qt.core.metamacros.MetaObjectImpl!(typeof(this)).stringdata.stringdata0.ptr))
                return static_cast!(void*)(this);
            return super.qt_metacast(_clname);
        }
        extern(C++) override int qt_metacall(qt.core.objectdefs.QMetaObject.Call  _c, int _id, void **_a)
        {
            import qt.core.metamacros;
            import qt.core.objectdefs;
            _id = super.qt_metacall(_c, _id, _a);
            if (_id < 0)
                return _id;
            alias allMethods = qt.core.metamacros.MetaObjectImpl!(typeof(this)).allMethods;
            if (_c == qt.core.objectdefs.QMetaObject.Call.InvokeMetaMethod) {
                if (_id < allMethods.length)
                    qt_static_metacall(this, _c, _id, _a);
                _id -= allMethods.length;
            } else if (_c == qt.core.objectdefs.QMetaObject.Call.RegisterMethodArgumentMetaType) {
                if (_id < allMethods.length)
                    *reinterpret_cast!(int*)(_a[0]) = -1;
                _id -= allMethods.length;
            }

            version(QT_NO_PROPERTIES) {}
            else
            {
                enum propertyCount = qt.core.metamacros.MetaObjectImpl!(typeof(this)).allPropertyTypes.length;
                if (_c == qt.core.objectdefs.QMetaObject.Call.ReadProperty || _c == qt.core.objectdefs.QMetaObject.Call.WriteProperty
                        || _c == qt.core.objectdefs.QMetaObject.Call.ResetProperty || _c == qt.core.objectdefs.QMetaObject.Call.RegisterPropertyMetaType) {
                    qt_static_metacall(this, _c, _id, _a);
                    _id -= propertyCount;
                } else if (_c == qt.core.objectdefs.QMetaObject.Call.QueryPropertyDesignable) {
                    _id -= propertyCount;
                } else if (_c == qt.core.objectdefs.QMetaObject.Call.QueryPropertyScriptable) {
                    _id -= propertyCount;
                } else if (_c == qt.core.objectdefs.QMetaObject.Call.QueryPropertyStored) {
                    _id -= propertyCount;
                } else if (_c == qt.core.objectdefs.QMetaObject.Call.QueryPropertyEditable) {
                    _id -= propertyCount;
                } else if (_c == qt.core.objectdefs.QMetaObject.Call.QueryPropertyUser) {
                    _id -= propertyCount;
                }
            }
            return _id;
        }
        extern(C++) static void qt_static_metacall(dqtimported!"qt.core.object".QObject _o, qt.core.objectdefs.QMetaObject.Call _c, int _id, void **_a)
        {
            import qt.core.metamacros;
            import qt.core.metatype;
            import qt.core.objectdefs;
            import std.conv;
            import std.traits;
            if (_c == qt.core.objectdefs.QMetaObject.Call.InvokeMetaMethod) {
                alias allMethods = qt.core.metamacros.MetaObjectImpl!(typeof(this)).allMethods;
                auto _t = static_cast!(typeof(this))(_o);
                //Q_UNUSED(_t)
                switch (_id) {
                    mixin((){
                            string methodCallCases;
                            static foreach (i; 0 .. allMethods.length)
                            {{
                                string call = text("_t.", __traits(identifier, allMethods[i]), "(");
                                static foreach (j, P; Parameters!(allMethods[i]))
                                {
                                    call ~= text("*cast(Parameters!(allMethods[", i, "])[", j, "]*)(_a[", j + 1, "]), ");
                                }
                                call ~= ")";
                                static if (is(ReturnType!(allMethods[i]) == void))
                                    methodCallCases ~= text("\n                    case ", i, ": ", call, "; break;");
                                else
                                    methodCallCases ~= text("\n                    case ", i, ": {if (_a[0]) *cast(ReturnType!(allMethods[", i, "])*)(_a[0]) = ", call, "; else ", call, ";} break;");
                            }}
                            return methodCallCases;
                        }());
                default: {}
                }
            } else if (_c == qt.core.objectdefs.QMetaObject.Call.RegisterMethodArgumentMetaType) {
                // TODO
            } else if (_c == qt.core.objectdefs.QMetaObject.Call.IndexOfMethod) {
                alias allSignals = qt.core.metamacros.MetaObjectImpl!(typeof(this)).allSignals;
                int *result = reinterpret_cast!(int *)(_a[0]);
                static foreach (i; 0 .. allSignals.length)
                {{
                    alias _t = qt.core.metamacros.CPPMemberFunctionPointer!(typeof(this));

                    auto fp = getMemberFunctionAddress!(allSignals[i]);
                    qt.core.metamacros.CPPMemberFunctionPointer!(typeof(this)) memberFunction = qt.core.metamacros.CPPMemberFunctionPointer!(typeof(this))(fp);

                    if (*reinterpret_cast!(_t *)(_a[1]) == memberFunction) {
                        *result = i;
                        return;
                    }
                }}
            }
            version(QT_NO_PROPERTIES) {}
            else
            {
                alias allPropertyTypes = qt.core.metamacros.MetaObjectImpl!(typeof(this)).allPropertyTypes;
                alias allFunctions = qt.core.metamacros.MetaObjectImpl!(typeof(this)).allFunctions;
                alias allFields = qt.core.metamacros.MetaObjectImpl!(typeof(this)).allFields;
                enum allReadFuncCode = qt.core.metamacros.MetaObjectImpl!(typeof(this)).allReadFuncCode;
                enum allWriteFuncCode = qt.core.metamacros.MetaObjectImpl!(typeof(this)).allWriteFuncCode;
                if (_c == qt.core.objectdefs.QMetaObject.Call.ReadProperty) {
                    auto _t = static_cast!(typeof(this))(_o);
                    void *_v = _a[0];
                    switch (_id) {
                        mixin((){
                                string cases;
                                static foreach (i; 0 .. allPropertyTypes.length)
                                {
                                    if (allReadFuncCode[i].length)
                                        cases ~= text("\n                    case ", i, ": *cast(allPropertyTypes[", i, "]*)(_v) = _t.", allReadFuncCode[i], "; break;");
                                }
                                return cases;
                            }());
                    default: {}
                    }
                } else if (_c == qt.core.objectdefs.QMetaObject.Call.WriteProperty) {
                    auto _t = static_cast!(typeof(this))(_o);
                    void *_v = _a[0];
                    switch (_id) {
                        mixin((){
                                string cases;
                                static foreach (i; 0 .. allPropertyTypes.length)
                                {
                                    if (allWriteFuncCode[i].length)
                                        cases ~= text("\n                    case ", i, ": ", allWriteFuncCode[i], " break;");
                                }
                                return cases;
                            }());
                    default: {}
                    }
                } else if (_c == qt.core.objectdefs.QMetaObject.Call.ResetProperty) {
                } else if (_c == qt.core.objectdefs.QMetaObject.Call.RegisterPropertyMetaType) {
                    switch (_id) {
                    default: *cast(int*)(_a[0]) = -1; break;
                        mixin((){
                                string cases;
                                static foreach (i; 0 .. allPropertyTypes.length)
                                {
                                    cases ~= text("\n                    case ", i, ": *cast(int*)(_a[0]) = qRegisterMetaType!(allPropertyTypes[", i, "])(); break;");
                                }
                                return cases;
                            }());
                    }
                }
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
    static import qt.core.objectdefs;
    void*[std.traits.Parameters!(__traits(parent, Dummy)).length + 1] _a = mixin((){
        string r = "[null";
        static foreach (i; 0 .. std.traits.Parameters!(__traits(parent, Dummy)).length)
        {{
            enum paramName = std.traits.ParameterIdentifierTuple!(__traits(parent, Dummy))[i];
            static assert(paramName != "", "Parameter for signal has no name");
            r ~= " , cast(void*)&" ~ paramName;
        }}
        r ~= "]";
        return r;
        }());
    qt.core.objectdefs.QMetaObject.activate(this, &staticMetaObject, dqtimported!q{qt.core.metamacros}.MetaObjectImpl!(typeof(this)).signalIndex!(__traits(parent, Dummy)), _a.ptr);
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
        static import qt.core.objectdefs;
        extern(C++) extern } ~ exportOnWindows ~ q{static __gshared const(qt.core.objectdefs.QMetaObject) staticMetaObject;
        /+ void qt_check_for_QGADGET_macro(); +/
        alias QtGadgetHelper = void;
    private:
        /+ QT_WARNING_PUSH
        Q_OBJECT_NO_ATTRIBUTES_WARNING +/
        /+ Q_DECL_HIDDEN_STATIC_METACALL +/ static void qt_static_metacall(dqtimported!q{qt.core.object}.QObject , qt.core.objectdefs.QMetaObject.Call, int, void** );};
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
#endif +/ //Q_MOC_RUN

