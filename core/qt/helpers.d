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
module qt.helpers;

import std.traits;
import std.conv;
import std.array;
import std.meta;

private string nextCodePart(string code)
{
    import std.ascii;

    size_t i;
    char c = code[0];
    if (c == '"' || c == '\'')
    {
        char stringDelim = c;
        i++;
        while (i < code.length && code[i] != stringDelim)
        {
            if (code[i] == '\\')
                i++;
            i++;
        }
    }
    else if (c == '/' && i + 1 < code.length && code[i + 1] == '/')
    {
        i++;
        i++;
        while (i < code.length && code[i] != '\n')
            i++;
    }
    else if (c == '/' && i + 1 < code.length && code[i + 1] == '*')
    {
        i++;
        i++;
        while (i < code.length)
        {
            if (i + 1 < code.length && code[i] == '*' && code[i + 1] == '/')
            {
                i++;
                break;
            }
            i++;
        }
    }
    else if (c == '/' && i + 1 < code.length && code[i + 1] == '+')
    {
        i++;
        i++;
        size_t nesting = 1;
        while (i < code.length && nesting)
        {
            if (i + 1 < code.length && code[i] == '+' && code[i + 1] == '/')
            {
                nesting--;
                i++;
                if (nesting == 0)
                    break;
            }
            else if (i + 1 < code.length && code[i] == '/' && code[i + 1] == '+')
            {
                nesting++;
                i++;
            }
            i++;
        }
    }
    else if (isAlphaNum(c) || c == '_')
    {
        while (i + 1 < code.length && (isAlphaNum(code[i + 1]) || code[i + 1] == '_'))
            i++;
    }
    else if (isWhite(c))
    {
        while (i + 1 < code.length && isWhite(code[i + 1]))
            i++;
    }
    i++;
    return code[0 .. i];
}

string interpolateMixin(string code)
{
    string r = "\"";
    for (size_t i = 0; i < code.length;)
    {
        string part = nextCodePart(code[i .. $]);
        if (i < code.length + 1 && code[i] == '$' && code[i + 1] == '(')
        {
            r ~= "\" ~ ";
            i += 2;
            size_t numParens = 1;
            while (i < code.length)
            {
                if (i + 1 < code.length && code[i] == 'q' && code[i + 1] == '{')
                {
                    i += 2;
                    size_t start = i;
                    size_t numBraces = 1;
                    while (i < code.length)
                    {
                        string part2 = nextCodePart(code[i .. $]);
                        if (code[i] == '{')
                            numBraces++;
                        else if (code[i] == '}')
                        {
                            numBraces--;
                            if (numBraces == 0)
                            {
                                r ~= interpolateMixin(code[start .. i]);
                                i++;
                                break;
                            }
                        }
                        i += part2.length;
                    }
                    continue;
                }
                if (code[i] == ')')
                {
                    numParens--;
                    if (numParens == 0)
                    {
                        i++;
                        break;
                    }
                }
                else if (code[i] == '(')
                    numParens++;
                string part2 = nextCodePart(code[i .. $]);
                r ~= part2;
                i += part2.length;
            }
            r ~= " ~ \"";
            continue;
        }
        else
        {
            foreach (char c; part)
            {
                if (c == '\\')
                    r ~= "\\\\";
                else if (c == '"')
                    r ~= "\\\"";
                else
                    r ~= c;
            }
        }
        i += part.length;
    }
    r ~= "\"";
    return r;
}

string stringifyMacroParameter(string s)
{
    string r = "\"";
    bool hasWS;
    for (size_t i = 0; i < s.length;)
    {
        string part = nextCodePart(s[i .. $]);
        if (part[0] == ' ' || part[0] == '\t' || part[0] == '\r' || part[0] == '\n'
                || (part.length >= 2 && part[0] == '/' && (part[1] == '/' || part[1] == '*')))
            hasWS = true;
        else
        {
            if (r.length > 1 && hasWS)
                r ~= " ";
            hasWS = false;
            foreach (char c; part)
            {
                if (c == '\"')
                    r ~= "\\\"";
                else if (c == '\\')
                    r ~= "\\\\";
                else
                    r ~= c;
            }
        }
        i += part.length;
    }
    r ~= "\"";
    return r;
}

template ExternCFunc(F) if (isSomeFunction!F)
{
    static if (variadicFunctionStyle!F == Variadic.c)
        alias ExternCFunc = extern(C) ReturnType!F function(ParameterTypeTuple!F, ...);
    else
        alias ExternCFunc = extern(C) ReturnType!F function(ParameterTypeTuple!F);
}

template ExternCPPFunc(F) if (isSomeFunction!F)
{
    static if (variadicFunctionStyle!F == Variadic.c)
        alias ExternCPPFunc = extern(C++) ReturnType!F function(ParameterTypeTuple!F, ...);
    else
        alias ExternCPPFunc = extern(C++) ReturnType!F function(ParameterTypeTuple!F);
}

T static_cast(T, S)(S x)
{
    static if (isCallable!T && isCallable!S)
    {
        static assert(functionLinkage!T == functionLinkage!S);
    }
    return cast(T) x;
}

T reinterpret_cast(T, S)(S x)
{
    return cast(T) x;
}

T const_cast(T, S)(S x)
{
    return cast(T) x;
}

private template globalInitVarImpl(T)
{
    __gshared T globalInitVar = T.init;
    shared static this()
    {
        (*cast(T*)&globalInitVar).rawConstructor;
    }
}

template globalInitVar(T)
{
    static if (__traits(hasMember, T, "rawConstructor"))
    {
        version (Windows)
            alias globalInitVar = const(globalInitVarImpl!T.globalInitVar);
        else
            static assert(0, "globalInitVar!" ~ T.stringof ~ " needs complex construction");
    }
    else static if (__traits(compiles, { T x; }))
        immutable __gshared T globalInitVar /* = immutable(T).init*/ ;
    else
        static assert(false, T.stringof);
}

private struct FunctionManglingCpp
{
    string prefix;
    string[] nameParts;
    string flags;
    string flags2;
    string returnType;
    string[] parameters;
    string suffix;
}

version (Windows)
{
    private string parseTypeManglingWin(ref string mangling, bool is64bit)
    {
        import std.exception, std.ascii, std.algorithm;

        bool inPointer;
        size_t i = 0;
        while (true)
        {
            enforce(i < mangling.length, text("Unexpected mangling ", __FILE__,
                    ":", __LINE__, ": ", mangling[0 .. i], " | ", mangling[i .. $]));
            if (mangling[i] == '_')
            {
                enforce(i + 1 < mangling.length, text("Unexpected mangling ",
                        __FILE__, ":", __LINE__, ": ", mangling[0 .. i], " | ", mangling[i .. $]));
                if (mangling[i + 1] == 'N')
                {
                    // basic types
                    i += 2;
                    break;
                }
            }
            else if ((mangling[i] >= 'C' && mangling[i] <= 'O') || mangling[i] == 'X')
            {
                // basic types
                i++;
                break;
            }
            else if (inPointer && mangling[i].among('6'))
            {
                // function type
                i++;
                enforce(i < mangling.length, text("Unexpected mangling ", __FILE__,
                        ":", __LINE__, ": ", mangling[0 .. i], " | ", mangling[i .. $]));
                enforce(mangling[i] == 'A', text("Unexpected mangling ", __FILE__,
                        ":", __LINE__, ": ", mangling[0 .. i], " | ", mangling[i .. $]));
                // return type and arguments
                while (true)
                {
                    enforce(i < mangling.length, text("Unexpected mangling ", __FILE__,
                            ":", __LINE__, ": ", mangling[0 .. i], " | ", mangling[i .. $]));
                    if (mangling[i] == 'Z')
                    {
                        i++;
                        break;
                    }
                    string mangling2 = mangling[i .. $];
                    string arg = parseTypeManglingWin(mangling2, is64bit);
                    i += arg.length;
                }
                break;
            }
            else if (mangling[i] >= '0' && mangling[i] <= '9')
            {
                // back references
                i++;
                break;
            }
            else if (mangling[i].among('A', 'B', 'P', 'Q', 'R', 'S'))
            {
                // modifiers
                if (mangling[i].among('P', 'Q'))
                    inPointer = true;
                i++;
                if (is64bit)
                {
                    if (i < mangling.length && mangling[i] == 'E')
                        i++;
                }
                continue;
            }
            else if (mangling.length >= i + 3 && mangling[i .. i + 2] == "$$"
                    && mangling[i + 2].among('Q', 'R', 'C'))
            {
                // modifiers
                i += 3;
                continue;
            }
            else if (mangling[i].among('T', 'U', 'V'))
            {
                // complex types
                i++;
                if (mangling[i] >= '0' && mangling[i] < '9')
                {
                    // back reference
                    i++;
                    enforce(i < mangling.length && mangling[i] == '@', text("Unexpected mangling ",
                            __FILE__, ":", __LINE__, ": ", mangling[0 .. i],
                            " | ", mangling[i .. $]));
                    i++;
                    break;
                }
                while (true)
                {
                    if (i + 1 < mangling.length && mangling[i] == '?' && mangling[i + 1] == '$')
                    {
                        // template
                        i += 2;

                        // template name
                        while (true)
                        {
                            enforce(i < mangling.length, text("Unexpected mangling ", __FILE__, ":",
                                    __LINE__, ": ", mangling[0 .. i], " | ", mangling[i .. $]));
                            enforce(mangling[i] == '@' || mangling[i] == '_' || isAlphaNum(mangling[i]),
                                    text("Unexpected mangling ", __FILE__, ":", __LINE__,
                                        ": ", mangling[0 .. i], " | ", mangling[i .. $]));
                            if (mangling[i] == '@')
                            {
                                i++;
                                break;
                            }
                            i++;
                        }

                        // template arguments
                        while (true)
                        {
                            enforce(i < mangling.length, text("Unexpected mangling ", __FILE__, ":",
                                    __LINE__, ": ", mangling[0 .. i], " | ", mangling[i .. $]));
                            if (mangling[i] == '@')
                            {
                                break;
                            }
                            string mangling2 = mangling[i .. $];
                            string arg = parseTypeManglingWin(mangling2, is64bit);
                            i += arg.length;
                        }
                    }
                    else if (i + 1 == mangling.length && mangling[i].among('A', 'B'))
                    {
                        break;
                    }
                    else
                    {
                        enforce(mangling[i] == '@' || mangling[i] == '_' || isAlphaNum(mangling[i]),
                                text("Unexpected mangling ", __FILE__, ":", __LINE__,
                                    ": ", mangling[0 .. i], " | ", mangling[i .. $]));
                        if (i + 1 < mangling.length && mangling[i] == '@' && mangling[i + 1] == '@')
                        {
                            i += 2;
                            break;
                        }
                        i++;
                    }
                }
                break;
            }
            else if (mangling[i] == 'W')
            {
                // enum type
                i++;
                enforce(i < mangling.length, text("Unexpected mangling ", __FILE__,
                        ":", __LINE__, ": ", mangling[0 .. i], " | ", mangling[i .. $]));
                enforce(mangling[i] >= '0' && mangling[i] <= '7', text("Unexpected mangling ",
                        __FILE__, ":", __LINE__, ": ", mangling[0 .. i], " | ", mangling[i .. $]));
                i++;
                if (mangling[i] >= '0' && mangling[i] < '9')
                {
                    // back reference
                    i++;
                    enforce(i < mangling.length && mangling[i] == '@', text("Unexpected mangling ",
                            __FILE__, ":", __LINE__, ": ", mangling[0 .. i],
                            " | ", mangling[i .. $]));
                    i++;
                    break;
                }
                while (true)
                {
                    enforce(i + 1 < mangling.length, text("Unexpected mangling ",
                            __FILE__, ":", __LINE__, ": ", mangling[0 .. i],
                            " | ", mangling[i .. $]));
                    enforce(mangling[i] == '@' || mangling[i] == '_' || isAlphaNum(mangling[i]),
                            text("Unexpected mangling ", __FILE__, ":", __LINE__,
                                ": ", mangling[0 .. i], " | ", mangling[i .. $]));
                    if (mangling[i] == '@' && mangling[i + 1] == '@')
                    {
                        i += 2;
                        break;
                    }
                    i++;
                }
                break;
            }
            enforce(false, text("Unexpected mangling ", __FILE__, ":",
                    __LINE__, ": ", mangling[0 .. i], " | ", mangling[i .. $]));
        }
        assert(i < mangling.length);
        string r = mangling[0 .. i];
        mangling = mangling[i .. $];
        return r;
    }
    /*private*/ FunctionManglingCpp parseFunctionManglingWin(string mangling, bool is64bit)
    {
        import std.exception, std.ascii, std.algorithm;

        FunctionManglingCpp r;
        enforce(mangling.length && mangling[0] == '?',
                text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
        size_t i = 1;
        while (true)
        {
            enforce(i + 1 < mangling.length, text("Unexpected mangling ",
                    __FILE__, ":", __LINE__, ": ", mangling[0 .. i], " | ", mangling[i .. $]));
            if (mangling[i] == '?' && mangling[i + 1].among('0', '1'))
            {
                i += 2;
                continue;
            }
            if (mangling[i] == '@' && mangling[i + 1] == '@')
            {
                i += 2;
                break;
            }
            enforce(mangling[i] == '@' || mangling[i] == '_' || isAlphaNum(mangling[i]),
                    text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ",
                        mangling[0 .. i], " | ", mangling[i .. $]));
            i++;
        }
        r.nameParts = [mangling[0 .. i]];
        mangling = mangling[i .. $];

        enforce(mangling.length >= 2, text("Unexpected mangling ", __FILE__,
                ":", __LINE__, ": ", mangling));
        if (mangling[0] >= 'A' && mangling[0] <= 'Z')
        {
            // function
            // private / protected / public / none
            uint accessLevel = (mangling[0] - 'A') / 8;
            // none / static / virtual / thunk
            uint functionType = ((mangling[0] - 'A') % 8) / 2;
            i = 1;
            if (is64bit && mangling[i] == 'E')
            {
                enforce(i + 1 < mangling.length, text("Unexpected mangling ",
                        __FILE__, ":", __LINE__, ": ", mangling));
                enforce(mangling[i] == 'E', text("Unexpected mangling ",
                        __FILE__, ":", __LINE__, ": ", mangling));
                i++;
            }
            if (functionType != 1)
            {
                enforce(i + 1 < mangling.length, text("Unexpected mangling ",
                        __FILE__, ":", __LINE__, ": ", mangling));
                enforce(mangling[i].among('A', 'B'), text("Unexpected mangling ",
                        __FILE__, ":", __LINE__, ": ", mangling));
                i++;
            }
            enforce(mangling[i].among('A', 'E'), text("Unexpected mangling ",
                    __FILE__, ":", __LINE__, ": ", mangling));
            i++;
            r.flags = mangling[0 .. i];
            mangling = mangling[i .. $];
            if (mangling.startsWith("?A") || mangling.startsWith("?B"))
            {
                r.flags2 = mangling[0 .. 2];
                mangling = mangling[2 .. $];
            }

            if (r.nameParts[$ - 1].startsWith("??1")) // destructor
            {
                enforce(mangling == "@XZ");
                r.suffix = mangling;
            }
            else
            {
                r.returnType = parseTypeManglingWin(mangling, is64bit);
                while (true)
                {
                    enforce(mangling.length, text("Unexpected mangling ",
                            __FILE__, ":", __LINE__, ": ", mangling));
                    if (mangling[0].among('Z', 'X', '@'))
                        break;
                    r.parameters ~= parseTypeManglingWin(mangling, is64bit);
                }
                foreach (char c; mangling)
                    enforce(c.among('Z', 'X', '@'), text("Unexpected mangling ",
                            __FILE__, ":", __LINE__, ": ", mangling));
                r.suffix = mangling;
            }
        }
        else if (mangling[0] >= '0' && mangling[0] <= '4')
        {
            // variable
            r.flags = mangling[0 .. 1];
            mangling = mangling[1 .. $];
            r.returnType = parseTypeManglingWin(mangling, is64bit);
            enforce(mangling.among("A", "B", "EA", "EB"),
                    text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
            r.suffix = mangling;
        }
        else
            enforce(false, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));

        return r;
    }
}
else
{
    /*private*/ FunctionManglingCpp parseFunctionManglingItanium(string mangling, bool is64bit)
    {
        import std.exception, std.ascii, std.algorithm, std.conv;

        FunctionManglingCpp r;
        enforce(mangling.startsWith("_ZN"), text("Unexpected mangling ",
                __FILE__, ":", __LINE__, ": ", mangling));
        r.prefix = mangling[0 .. 3];
        mangling = mangling[3 .. $];

        while (mangling.length)
        {
            if (mangling[0] >= '0' && mangling[0] <= '9')
            {
                size_t lengthBytes = 1;
                while (lengthBytes < mangling.length
                        && mangling[lengthBytes] >= '0' && mangling[lengthBytes] <= '9')
                    lengthBytes++;
                size_t length = to!size_t(mangling[0 .. lengthBytes]);
                enforce(mangling.length >= lengthBytes + length,
                        text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
                r.nameParts ~= mangling[0 .. lengthBytes + length];
                mangling = mangling[lengthBytes + length .. $];
            }
            else if (mangling.length >= 2 && mangling[0].among('C', 'D')
                    && mangling[1].among('0', '1'))
            {
                r.nameParts ~= mangling[0 .. 2];
                mangling = mangling[2 .. $];
            }
            else
                break;
        }

        r.suffix = mangling;

        return r;
    }
}

alias defaultConstructorMangling = function string(string name)
{
    version (Windows)
        static if (size_t.sizeof == 8)
            return "??0" ~ name ~ "@@QEAA@XZ";
        else
            return "??0" ~ name ~ "@@QAE@XZ";
    else
        return text("_ZN", name.length, name, "C1Ev");
};

private string replaceStart(string str, string from, string to)
{
    import std.algorithm;

    if (str.startsWith(from))
        str = to ~ str[from.length .. $];
    return str;
}

// Changes the mangling only on Windows.
// On Win32 it also converts it from 64 bit.
alias mangleWindows = function string(string mangling, string code)
{
    version (Windows)
    {
        import std.algorithm;

        static if (size_t.sizeof == 4)
        {
            auto parsed = parseFunctionManglingWin(mangling, true);
            static if (size_t.sizeof == 4)
            {
                if (parsed.flags[0] >= 'A' && parsed.flags[0] <= 'Z' && parsed.flags[1] == 'E')
                {
                    parsed.flags = parsed.flags[0 .. 1] ~ parsed.flags[2 .. $];
                    if (parsed.flags[$ - 1] == 'A')
                        parsed.flags = parsed.flags[0 .. $ - 1] ~ 'E';
                }
                parsed.returnType = parsed.returnType.replaceStart("PE", "P");
                parsed.returnType = parsed.returnType.replaceStart("QE", "Q");
                parsed.returnType = parsed.returnType.replaceStart("RE", "R");
                parsed.returnType = parsed.returnType.replaceStart("SE", "S");
                parsed.returnType = parsed.returnType.replaceStart("AE", "A");
                parsed.returnType = parsed.returnType.replaceStart("BE", "B");
            }
            foreach (ref param; parsed.parameters)
            {
                static if (size_t.sizeof == 4)
                {
                    param = param.replaceStart("PE", "P");
                    param = param.replaceStart("QE", "Q");
                    param = param.replaceStart("RE", "R");
                    param = param.replaceStart("SE", "S");
                    param = param.replaceStart("AE", "A");
                    param = param.replaceStart("BE", "B");
                }
            }
            static if (size_t.sizeof == 4)
            {
                parsed.suffix = parsed.suffix.replaceStart("EA", "A");
            }
            mangling = recreateCppMangling(parsed);
        }
        return "pragma(mangle, \"" ~ mangling ~ "\") " ~ code;
    }
    else
        return code;
};

// Changes the mangling only on platforms with Itanium C++ ABI.
alias mangleItanium = function string(string mangling, string code)
{
    version (Windows)
        return code;
    else
    {
        return "pragma(mangle, \"" ~ mangling ~ "\") " ~ code;
    }
};

alias mangleOpLess = function string(string name)
{
    version (Windows)
        static if (size_t.sizeof == 8)
            return "??M" ~ name ~ "@@UEBA_NAEBV0@@Z";
        else
            return "??M" ~ name ~ "@@UBE_NABV0@@Z";
    else
        return text("_ZNK", name.length, name, "ltERKS_");
};

package FunctionManglingCpp splitCppMangling(bool isClass, string attributes, string attributes2,
        string name, string dummyFunctionName, size_t numParameters, string mangling)
{
    import std.algorithm, std.exception, std.conv;

    version (Windows)
    {
        auto parsed = parseFunctionManglingWin(mangling, (void*).sizeof == 8);
        if (name == "~this")
            parsed.nameParts[0] = parsed.nameParts[0].replace(dummyFunctionName, "this");
        else
            parsed.nameParts[0] = parsed.nameParts[0].replace(dummyFunctionName, name);
        assert(parsed.parameters.length == numParameters);
        if (name == "this")
        {
            parsed.nameParts[$ - 1] = parsed.nameParts[$ - 1].replaceStart("?this@", "??0");
            assert(parsed.returnType == "X");
            parsed.returnType = "@";
            foreach (ref param; parsed.parameters)
            {
                if (param.length >= 2 && param[$ - 1] == '@'
                        && param[$ - 2] >= '1' && param[$ - 2] <= '9')
                {
                    // References have to be decremented, because the dummy function has a return type, but not the real constructor.
                    param = param[0 .. $ - 2] ~ cast(char)(param[$ - 2] - 1) ~ param[$ - 1];
                }
            }
        }
        if (name == "~this")
        {
            parsed.nameParts[$ - 1] = parsed.nameParts[$ - 1].replaceStart("?this@", "??1");
            assert(parsed.returnType == "X");
            parsed.returnType = "@";
        }
        if (!attributes.canFind("static"))
        {
            // private / protected / public / none
            uint accessLevel = (parsed.flags[0] - 'A') / 8;
            // none / static / virtual / thunk
            uint functionType = ((parsed.flags[0] - 'A') % 8) / 2;

            if (attributes.canFind("static"))
                functionType = 1;
            else if (attributes.canFind("final") || !isClass || name == "this")
                functionType = 0;
            else
                functionType = 2;

            parsed.flags = [cast(char)('A' + accessLevel * 8 + functionType * 2)];
            if (attributes2.canFind("const"))
            {
                static if (size_t.sizeof == 8)
                    parsed.flags ~= "EBA";
                else
                    parsed.flags ~= "BE";
            }
            else
            {
                static if (size_t.sizeof == 8)
                    parsed.flags ~= "EAA";
                else
                    parsed.flags ~= "AE";
            }
        }
    }
    else
    {
        FunctionManglingCpp parsed = parseFunctionManglingItanium(mangling, (void*).sizeof == 8);
        enforce(parsed.nameParts[$ - 1].endsWith(dummyFunctionName));
        if (name == "this")
            parsed.nameParts[$ - 1] = "C1";
        else if (name == "~this")
            parsed.nameParts[$ - 1] = "D1";
        else
            parsed.nameParts[$ - 1] = text(name.length, name);

        if (!attributes.canFind("static"))
        {
            if (attributes2.canFind("const"))
                parsed.prefix ~= "K";
        }
    }
    return parsed;
}

// Workaround for https://issues.dlang.org/show_bug.cgi?id=22550
package FunctionManglingCpp mangleClassesTailConst(FunctionManglingCpp parsed)
{
    version (Windows)
    {
        string makeTailConst(string mangling)
        {
            static if (size_t.sizeof == 8)
            {
                mangling = mangling.replaceStart("QEB", "PEB");
            }
            else
            {
                mangling = mangling.replaceStart("QB", "PB");
            }
            return mangling;
        }

        parsed.returnType = makeTailConst(parsed.returnType);
        foreach (ref param; parsed.parameters)
        {
            param = makeTailConst(param);
        }
    }
    return parsed;
}

package FunctionManglingCpp mangleChangeAccess(FunctionManglingCpp parsed, string access)
{
    version (Windows)
    {
        // private / protected / public / none
        uint accessLevel = (parsed.flags[0] - 'A') / 8;
        // none / static / virtual / thunk
        uint functionType = ((parsed.flags[0] - 'A') % 8) / 2;

        if (access == "private")
            accessLevel = 0;
        else if (access == "protected")
            accessLevel = 1;
        else if (access == "public")
            accessLevel = 2;
        else
            assert(false);

        parsed.flags = cast(char)('A' + accessLevel * 8 + functionType * 2) ~ parsed.flags[1 .. $];
    }
    return parsed;
}

package FunctionManglingCpp mangleChangeFunctionType(FunctionManglingCpp parsed,
        string functionTypeStr)
{
    version (Windows)
    {
        // private / protected / public / none
        uint accessLevel = (parsed.flags[0] - 'A') / 8;
        // none / static / virtual / thunk
        uint functionType = ((parsed.flags[0] - 'A') % 8) / 2;

        if (functionTypeStr == "none")
            functionType = 0;
        else if (functionTypeStr == "static")
            functionType = 1;
        else if (functionTypeStr == "virtual")
            functionType = 2;
        else
            assert(false);

        parsed.flags = cast(char)('A' + accessLevel * 8 + functionType * 2) ~ parsed.flags[1 .. $];
    }
    return parsed;
}

// Workaround for https://issues.dlang.org/show_bug.cgi?id=22636
package FunctionManglingCpp mangleConstructorBaseObject(FunctionManglingCpp parsed)
{
    version (Windows)
    {}
    else
    {
        import std.exception;

        enforce(parsed.nameParts[$ - 1] == "C1");
        parsed.nameParts[$ - 1] = "C2";
    }
    return parsed;
}

package FunctionManglingCpp mangleQWebEngineCallbackRef(FunctionManglingCpp parsed)
{
    version (Windows)
    {
        foreach (ref p; parsed.parameters)
        {
            p = p.replace("?$QWebEngineCallbackRef@$$CBV",
                    (size_t.sizeof == 8)
                        ? "?$QWebEngineCallback@AEBV"
                        : "?$QWebEngineCallback@ABV");
        }
    }
    else
    {
        parsed.suffix = parsed.suffix.replace("21QWebEngineCallbackRefIK",
                                              "18QWebEngineCallbackIRK");
    }
    return parsed;
}

string recreateCppMangling(FunctionManglingCpp parsed)
{
    string mangling;
    mangling = parsed.prefix;
    foreach (part; parsed.nameParts)
        mangling ~= part;
    mangling ~= parsed.flags;
    mangling ~= parsed.flags2;
    mangling ~= parsed.returnType;
    foreach (param; parsed.parameters)
    {
        mangling ~= param;
    }
    mangling ~= parsed.suffix;
    return mangling;
}

/*
    Changes the mangling of function declarations.
    It only uses a very simple parser and will only work for some declarations.
    The mangling could be wrong for some functions.
*/
package string changeCppMangling(bool debugHere = false)(string changeFuncs,
        string declaration, size_t line = __LINE__)
{
    import std.ascii, std.algorithm;

    string code;

    struct StartEnd
    {
        size_t start, end;
    }

    StartEnd[] parts;
    size_t parenCount;
    bool afterCombiner;
    bool afterSemicolon;
    for (size_t i = 0; i < declaration.length;)
    {
        string part = nextCodePart(declaration[i .. $]);
        bool mergeToLastPart;
        if (isWhite(part[0]) || part.startsWith("//") || part.startsWith("/*")
                || part.startsWith("/+"))
        {
            i += part.length;
            continue;
        }
        else
        {
            assert(!afterSemicolon);
            if (afterCombiner)
            {
                mergeToLastPart = true;
                afterCombiner = false;
            }

            if (part == "(")
            {
                if (parenCount)
                    mergeToLastPart = true;
                parenCount++;
            }
            else if (part == ")")
            {
                assert(parenCount);
                mergeToLastPart = true;
                parenCount--;
            }
            else if (parenCount)
            {
                mergeToLastPart = true;
            }
            else if (part == "." || part == "!")
            {
                mergeToLastPart = true;
                afterCombiner = true;
            }
            else if (part == "@")
            {
                afterCombiner = true;
            }
            else if (part == "~")
            {
                afterCombiner = true;
            }
            else if (part == ";")
            {
                afterSemicolon = true;
            }
            else
            {
            }
        }

        if (mergeToLastPart)
            parts[$ - 1].end = i + part.length;
        else
            parts ~= StartEnd(i, i + part.length);

        //code ~= "pragma(msg, q{" ~ part ~ "});";
        i += part.length;
    }

    /*foreach (i, part; parts)
        code ~= "pragma(msg, q{" ~ text(i, ": ") ~ declaration[part.start .. part.end] ~ "});";*/

    size_t attributesEnd;
    string usedAttributes;
    string attributesNoComments;
    while (parts.length)
    {
        string part = declaration[parts[0].start .. parts[0].end];
        if (part.among("static", "override", "final", "extern", "export",
                "__gshared") || part[0] == '@')
        {
            attributesEnd = parts[0].end;
            attributesNoComments ~= part ~ " ";
        }
        else if (part.among("const", "immutable", "shared",
            "private", "protected", "public", "package"))
        {
            usedAttributes ~= part ~ " ";
            attributesEnd = parts[0].end;
            attributesNoComments ~= part ~ " ";
        }
        else
            break;
        parts = parts[1 .. $];
    }
    string attributes = declaration[0 .. attributesEnd];
    assert(parts.length >= 3, text(parts.length));
    string returnType;
    if (declaration[parts[0].start .. parts[0].end] != "this"
            && declaration[parts[0].start .. parts[0].end] != "~this")
    {
        returnType = declaration[attributesEnd .. parts[0].end];
        parts = parts[1 .. $];
    }
    assert(parts.length >= 3, text(parts.length));
    string name = declaration[parts[0].start .. parts[0].end];
    parts = parts[1 .. $];
    assert(isAlphaNum(name[0]) || name[0] == '_' || name == "~this");
    string params = declaration[parts[0].start .. parts[0].end];
    parts = parts[1 .. $];
    assert(params.startsWith("("));
    string attributesUsedAfter;
    while (parts.length >= 2)
    {
        string part = declaration[parts[0].start .. parts[0].end];
        assert(part.among("const", "immutable", "shared"));
        attributesUsedAfter ~= part ~ " ";
        parts = parts[1 .. $];
    }
    assert(parts.length == 1);
    assert(declaration[parts[0].start .. parts[0].end].startsWith(";"));

    /*code ~= "pragma(msg, q{" ~ attributes ~ "});";
    code ~= "pragma(msg, q{" ~ returnType ~ "});";
    code ~= "pragma(msg, q{" ~ name ~ "});";
    code ~= "pragma(msg, q{" ~ params ~ "});";*/

    string dummyFunctionName;
    if (name == "~this")
        dummyFunctionName = text("dummyFunctionForChangingMangling", line, "_destructor");
    else
        dummyFunctionName = text("dummyFunctionForChangingMangling", line, "_", name);

    code ~= "static";
    code ~= " " ~ usedAttributes;
    code ~= " " ~ returnType;
    if (name == "this" || name == "~this")
        code ~= "void";
    code ~= " " ~ dummyFunctionName;
    code ~= params;
    //code ~= " " ~ attributesUsedAfter;
    code ~= ";\n";
    string codeSplitMangling;
    codeSplitMangling ~= "splitCppMangling(is(typeof(this) == class), ";
    codeSplitMangling ~= "q{" ~ attributesNoComments ~ "}, ";
    codeSplitMangling ~= "q{" ~ attributesUsedAfter ~ "}, ";
    codeSplitMangling ~= "q{" ~ name ~ "}, ";
    codeSplitMangling ~= "q{" ~ dummyFunctionName ~ "}, ";
    codeSplitMangling ~= "qt.helpers.FunctionParameters!" ~ dummyFunctionName ~ ".length, ";
    codeSplitMangling ~= dummyFunctionName ~ ".mangleof";
    codeSplitMangling ~= ")";
    if (debugHere)
    {
        code ~= "pragma(msg, " ~ dummyFunctionName ~ ".mangleof);\n";

        version (Windows)
            code ~= "pragma(msg, parseFunctionManglingWin(" ~ dummyFunctionName ~ ".mangleof, (void*).sizeof == 8));\n";
        else
            code ~= "pragma(msg, parseFunctionManglingItanium(" ~ dummyFunctionName ~ ".mangleof, (void*).sizeof == 8));\n";

        code ~= "pragma(msg, " ~ codeSplitMangling;
        code ~= ");\n";

        code ~= "pragma(msg, " ~ codeSplitMangling;
        code ~= "." ~ changeFuncs;
        code ~= ");\n";

        code ~= "pragma(msg, " ~ codeSplitMangling;
        code ~= "." ~ changeFuncs;
        code ~= ".recreateCppMangling";
        code ~= ");\n";
    }
    code ~= "static assert (" ~ codeSplitMangling;
    code ~= "." ~ changeFuncs;
    code ~= ".recreateCppMangling";
    code ~= " != " ~ codeSplitMangling ~ ".recreateCppMangling, \"Redundant use of changeCppMangling\");\n";

    code ~= "pragma(mangle, " ~ codeSplitMangling;
    code ~= "." ~ changeFuncs;
    code ~= ".recreateCppMangling";
    code ~= ")\n";

    code ~= declaration;
    return code;
}

package string changeCppManglingNoop(bool debugHere = false)(string changeFuncs,
        string declaration, size_t line = __LINE__)
{
    return declaration;
}

version (Windows)
{
    alias changeWindowsMangling = changeCppMangling;
    alias changeItaniumMangling = changeCppManglingNoop;
}
else
{
    alias changeWindowsMangling = changeCppManglingNoop;
    alias changeItaniumMangling = changeCppMangling;
}

// Workaround for https://issues.dlang.org/show_bug.cgi?id=19660, which can be removed later.
version (Windows)
    enum exportOnWindows = " export ";
else
    enum exportOnWindows = "";

/* Same as imported from druntime object.d.
 * Using a custom implementation also works with older druntime
 * and works around https://issues.dlang.org/show_bug.cgi?id=22651
 */
template dqtimported(string moduleName)
{
    mixin("import dqtimported = " ~ moduleName ~ ";");
}

/* UDA for constuctors, which should be used for implicit construction
 * when passing parameters. Mixin CREATE_CONVENIENCE_WRAPPERS will
 * create wrappers, which simulate these implicit conversions.
 *
 * Both the constructors and the surrounding class/struct need to have
 * the UDA SimulateImplicitConstructor. This makes the mixin a bit
 * faster and works around https://issues.dlang.org/show_bug.cgi?id=24386
 */
struct SimulateImplicitConstructor
{
}

template FunctionParameters(alias F)
{
    static if (is(typeof(F) P == __parameters))
        alias FunctionParameters = P;
}
template FunctionParameters2(F)
{
    static if (is(F P == __parameters))
        alias FunctionParameters2 = P;
}

private bool areStorageClassesOnlyRef(Args...)(Args storageClasses)
{
    static if (Args.length == 1)
        return storageClasses[0] == "ref";
    else
        return false;
}

private template isParamConstStructRef(F, size_t i)
{
    enum isParamConstStructRef = is(FunctionParameters2!F[i] == struct)
        && is(FunctionParameters2!F[i] == const)
        && areStorageClassesOnlyRef(__traits(getParameterStorageClasses, F, i));
}

private template hasUDASimulateImplicitConstructorImpl()
{
    enum hasUDASimulateImplicitConstructorImpl = false;
}
private template hasUDASimulateImplicitConstructorImpl(alias U, R...)
{
    static if (is(U == SimulateImplicitConstructor))
        enum hasUDASimulateImplicitConstructorImpl = true;
    else
        enum hasUDASimulateImplicitConstructorImpl = hasUDASimulateImplicitConstructorImpl!R;
}
private template hasUDASimulateImplicitConstructor(alias symbol)
{
    enum hasUDASimulateImplicitConstructor = hasUDASimulateImplicitConstructorImpl!(__traits(getAttributes, symbol));
}

private template anyParamNeedsWrapper(F, size_t i = 0)
{
    static if (i >= FunctionParameters2!F.length)
        enum anyParamNeedsWrapper = false;
    else static if (isParamConstStructRef!(F, i))
        enum anyParamNeedsWrapper = true;
    else static if (is(FunctionParameters2!F == struct) && hasUDASimulateImplicitConstructor!(FunctionParameters2!F[i]))
        enum anyParamNeedsWrapper = true;
    else
        enum anyParamNeedsWrapper = anyParamNeedsWrapper!(F, i + 1);
}

private template dummyFunctionWithSameArgs(alias F)
{
    static if (is(typeof(F) Params == __parameters))
        void dummyFunctionWithSameArgs(Params params);
}

private template callableWithNParameters(alias F, size_t n)
{
    enum callableWithNParameters = __traits(compiles, () {
        FunctionParameters!F[0 .. n] params = void;
        dummyFunctionWithSameArgs!F(params);
    });
}

template implicitCastAllowed(From, To)
{
    static if (!is(To == struct))
        enum implicitCastAllowed = false;
    else static if (!hasUDASimulateImplicitConstructor!To)
        enum implicitCastAllowed = false;
    else
        enum implicitCastAllowed = () {
            bool r = false;
            static if (__traits(hasMember, To, "__ctor"))
            {
                static foreach (o; __traits(getOverloads, To, "__ctor"))
                {
                    static if (hasUDASimulateImplicitConstructor!o)
                    {
                        static assert (callableWithNParameters!(o, 1), "@SimulateImplicitConstructor only allowed on constructors with one parameter.");
                        static if (is(From : FunctionParameters!o[0]))
                        {
                            r = true;
                        }
                    }
                }
            }
            return r;
        }();
}

/* Using this function is a bit faster, than directly comparing the string
 * in a static if, because a comparison is lowered to a function call
 */
private bool isPublic(string visibility)
{
    return visibility == "public";
}

enum isWrapperCallable(This, alias F, Params...) = () {
    static if (Params.length > FunctionParameters!F.length)
        return false;
    else static if (!isPublic(__traits(getVisibility, F)))
        return false;
    else static if (!callableWithNParameters!(F, Params.length))
        return false;
    else static if (FunctionParameters!F.length == 1 && is(const(FunctionParameters!F[0]) == const(This)))
        return false;
    else
    {
        bool callableWithoutWrapper = true;
        bool callableWithWrapper = true;
        // The parameter types have to be checked with if to work around https://issues.dlang.org/show_bug.cgi?id=13140
        static foreach (i; 0 .. Params.length)
        {
            if (!is(Params[i] : FunctionParameters!F[i]))
            {
                callableWithoutWrapper = false;
                if (!implicitCastAllowed!(Params[i], FunctionParameters!F[i]))
                {
                    callableWithWrapper = false;
                }
            }
        }

        // Workaround for https://issues.dlang.org/show_bug.cgi?id=12672
        static foreach (i; 0 .. Params.length)
        {
            static if (isParamConstStructRef!(typeof(F), i))
            {
                static if (!__traits(isRef, Params[i]))
                    callableWithoutWrapper = false;
            }
            // Ref parameters, which are not const structs should not use a temporary.
            else if (areStorageClassesOnlyRef(__traits(getParameterStorageClasses, F, i))
                    && !__traits(isRef, Params[i]))
            {
                callableWithoutWrapper = false;
                callableWithWrapper = false;
            }
        }
        uint r;
        if (callableWithoutWrapper)
            r |= 1;
        if (callableWithWrapper)
            r |= 2;
        return r;
    }
}();

template isAnyWrapperCallable(This, bool isStaticFunction, Overloads...)
{
    enum impl(Params...) = () {
        size_t numCallableWithoutWrapper;
        size_t numCallableWithWrapper;
        static foreach (Overload; Overloads)
        {
            static if (__traits(isStaticFunction, Overload) == isStaticFunction)
            {{
                int callable = isWrapperCallable!(This, Overload, Params);
                if (callable & 1)
                    numCallableWithoutWrapper++;
                if (callable & 2)
                    numCallableWithWrapper++;
            }}
        }
        return numCallableWithWrapper == 1 && numCallableWithoutWrapper == 0;
    }();
}

template generateWrapperCode(string member, bool isStaticFunction, alias Overload)
{
    enum impl(Params...) = () {
        string code;
        string paramsCode;
        static foreach (i; 0 .. Params.length)
        {
            if (!is(Params[i] : FunctionParameters!Overload[i])
                && implicitCastAllowed!(Params[i], FunctionParameters!Overload[i]))
            {
                code ~= text("auto param", i, " = FunctionParameters!Overload[", i, "](params[", i, "]);\n");
                paramsCode ~= text("param", i, ", ");
            }
            else
                paramsCode ~= text("params[", i, "], ");
        }
        if (member != "__ctor")
            code ~= "return ";
        code ~= "Overload(" ~ paramsCode ~ ");\n";
        return code;
    }();
}

private bool isAllowedWrapperNameImpl(string member)
{
    return (!(member.length >= 2 && member[0 .. 2] == "__") || member == "__ctor")
        && !(member.length >= 32 && member[0 .. 32] == "dummyFunctionForChangingMangling")
        && member != "rawConstructor";
}
template isAllowedWrapperName(string member)
{
    enum isAllowedWrapperName = isAllowedWrapperNameImpl(member);
}

private template overloadNeedsWrapper(bool isStaticFunction, alias Overload)
{
    static if (!isPublic(__traits(getVisibility, Overload)))
        enum overloadNeedsWrapper = false;
    else static if(__traits(isStaticFunction, Overload) != isStaticFunction)
        enum overloadNeedsWrapper = false;
    else
        enum overloadNeedsWrapper = anyParamNeedsWrapper!(typeof(Overload));
}

template anyOverloadNeedsWrapper(bool isStaticFunction)
{
    enum anyOverloadNeedsWrapper = false;
}
template anyOverloadNeedsWrapper(bool isStaticFunction, alias Overload0, Overloads...)
{
    static if (overloadNeedsWrapper!(isStaticFunction, Overload0))
        enum anyOverloadNeedsWrapper = true;
    else
        enum anyOverloadNeedsWrapper = anyOverloadNeedsWrapper!(isStaticFunction, Overloads);
}

string buildWrapperMixin(string member, bool isStaticFunction, bool inClass)
{
    string code;
    code ~= "public extern(D) pragma(inline, true) ";
    if (member == "__ctor")
        code ~= "this";
    else
    {
        if (isStaticFunction)
            code ~= "static ";
        else if (inClass)
            code ~= "final ";
        code ~= "auto " ~ member;
    }
    code ~= q{(Params...)(auto ref Params params)
        if (isAnyWrapperCallable!(typeof(this), isStaticFunction, __traits(getOverloads, typeof(this), member)).impl!(Params))
        {
            static foreach (Overload; __traits(getOverloads, typeof(this), member))
            {
                static if (__traits(isStaticFunction, Overload) == isStaticFunction)
                {
                    static if (isWrapperCallable!(typeof(this), Overload, Params) == 2)
                    {
                        mixin(generateWrapperCode!(member, isStaticFunction, Overload).impl!(Params));
                    }
                }
            }
        }
    };
    return code;
}

// Creates wrapper functions for every function in the current class / struct, which are callable with rvalues.
// Also simulates implicit casts of constructors with UDA @SimulateImplicitConstructor.
version (DQT_NO_CONVENIENCE_WRAPPERS)
    enum CREATE_CONVENIENCE_WRAPPERS = "";
else
    enum CREATE_CONVENIENCE_WRAPPERS = q{
        static foreach (member; __traits(derivedMembers, typeof(this)))
        {
            extern(D) static if (isAllowedWrapperName!member)
            {
                static foreach (isStaticFunction; [false, true])
                {
                    static if (anyOverloadNeedsWrapper!(isStaticFunction, __traits(getOverloads, typeof(this), member)))
                    {
                        static if (!__traits(isTemplate, __traits(getMember, typeof(this), member)))
                            mixin(buildWrapperMixin(member, isStaticFunction, is(typeof(this) == class)));
                    }
                }
            }
        }
    };

package alias parentOf(alias sym) = __traits(parent, sym);
package alias parentOf(alias sym : T!Args, alias T, Args...) = __traits(parent, T);

// Like std.traits.packageName, but allows modules without package.
package template packageName(alias T)
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

package template IsInQtPackage(alias S)
{
    enum IsInQtPackage = packageName!(S).length > 3 && packageName!(S)[0 .. 3] == "qt.";
}
