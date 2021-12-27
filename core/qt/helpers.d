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

private string nextCodePart(string code)
{
    import std.ascii;

    size_t i;
    char c = code[0];
    if(c == '"' || c == '\'')
    {
        char stringDelim = c;
        i++;
        while(i < code.length && code[i] != stringDelim)
        {
            if(code[i] == '\\')
                i++;
            i++;
        }
    }
    else if(c == '/' && i + 1 < code.length && code[i + 1] == '/')
    {
        i++;
        i++;
        while(i < code.length && code[i] != '\n')
            i++;
    }
    else if(c == '/' && i + 1 < code.length && code[i + 1] == '*')
    {
        i++;
        i++;
        while(i < code.length)
        {
            if(i + 1 < code.length && code[i] == '*' && code[i+1] == '/')
            {
                i++;
                break;
            }
            i++;
        }
    }
    else if(c == '/' && i + 1 < code.length && code[i + 1] == '+')
    {
        i++;
        i++;
        size_t nesting = 1;
        while(i < code.length && nesting)
        {
            if(i + 1 < code.length && code[i] == '+' && code[i+1] == '/')
            {
                nesting--;
                i++;
                if(nesting == 0)
                    break;
            }
            else if(i + 1 < code.length && code[i] == '/' && code[i+1] == '+')
            {
                nesting++;
                i++;
            }
            i++;
        }
    }
    else if(isAlphaNum(c) || c == '_')
    {
        while(i + 1 < code.length && (isAlphaNum(code[i + 1]) || code[i + 1] == '_'))
            i++;
    }
    else if(isWhite(c))
    {
        while(i + 1 < code.length && isWhite(code[i + 1]))
            i++;
    }
    i++;
    return code[0..i];
}

string interpolateMixin(string code)
{
    string r = "\"";
    for(size_t i=0; i<code.length;)
    {
        string part = nextCodePart(code[i..$]);
        if(i < code.length + 1 && code[i] == '$' && code[i+1] == '(')
        {
            r ~= "\" ~ ";
            i += 2;
            size_t numParens = 1;
            while(i < code.length)
            {
                if(i + 1 < code.length && code[i] == 'q' && code[i+1] == '{')
                {
                    i += 2;
                    size_t start = i;
                    size_t numBraces = 1;
                    while(i < code.length)
                    {
                        string part2 = nextCodePart(code[i..$]);
                        if(code[i] == '{')
                            numBraces++;
                        else if(code[i] == '}')
                        {
                            numBraces--;
                            if(numBraces == 0)
                            {
                                r ~= interpolateMixin(code[start..i]);
                                i++;
                                break;
                            }
                        }
                        i += part2.length;
                    }
                    continue;
                }
                if(code[i] == ')')
                {
                    numParens--;
                    if(numParens == 0)
                    {
                        i++;
                        break;
                    }
                }
                else if(code[i] == '(')
                    numParens++;
                string part2 = nextCodePart(code[i..$]);
                r ~= part2;
                i += part2.length;
            }
            r ~= " ~ \"";
            continue;
        }
        else
        {
            foreach(char c; part)
            {
                if(c == '\\')
                    r ~= "\\\\";
                else if(c == '"')
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
    for(size_t i=0; i<s.length;)
    {
        string part = nextCodePart(s[i..$]);
        if(part[0] == ' ' || part[0] == '\t' || part[0] == '\r' || part[0] == '\n'
            || (part.length >= 2 && part[0] == '/' && (part[1] == '/' || part[1] == '*')))
            hasWS = true;
        else
        {
            if(r.length > 1 && hasWS)
                r ~= " ";
            hasWS = false;
            foreach(char c; part)
            {
                if(c == '\"')
                    r ~= "\\\"";
                else if(c == '\\')
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

template ExternCFunc(F)// if(is(F == function))
{
    static if(variadicFunctionStyle!F == Variadic.c)
        alias ExternCFunc = extern(C) ReturnType!F function(ParameterTypeTuple!F, ...);
    else
        alias ExternCFunc = extern(C) ReturnType!F function(ParameterTypeTuple!F);
}

template ExternCPPFunc(F)// if(is(F == function))
{
    static if(variadicFunctionStyle!F == Variadic.c)
        alias ExternCPPFunc = extern(C++) ReturnType!F function(ParameterTypeTuple!F, ...);
    else
        alias ExternCPPFunc = extern(C++) ReturnType!F function(ParameterTypeTuple!F);
}

T static_cast(T, S)(S x)
{
    static if(isCallable!T && isCallable!S)
    {
        static assert(functionLinkage!T == functionLinkage!S);
    }
    return cast(T)x;
}

T reinterpret_cast(T, S)(S x)
{
    return cast(T)x;
}

T const_cast(T, S)(S x)
{
    return cast(T)x;
}

private template globalInitVarImpl(T)
{
    immutable __gshared T globalInitVar = immutable(T).init;
    shared static this()
    {
        (*cast(T*)&globalInitVar).rawConstructor;
    }
}

template globalInitVar(T)
{
    static if(__traits(hasMember, T, "rawConstructor"))
    {
        version(Windows)
            alias globalInitVar = globalInitVarImpl!T.globalInitVar;
        else
            static assert(0, "globalInitVar!"~T.stringof~" needs complex construction");
    }
    else static if(__traits(compiles, {T x;}))
        immutable __gshared T globalInitVar/* = immutable(T).init*/;
    else
        static assert(false, T.stringof);
}

version(Windows)
{
    private struct FunctionManglingWin
    {
        string name;
        string flags;
        string flags2;
        string returnType;
        string[] parameters;
        string suffix;
    }

    private string parseTypeManglingWin(ref string mangling, bool is64bit)
    {
        import std.exception, std.ascii, std.algorithm;
        size_t i = 0;
        while(true)
        {
            enforce(i < mangling.length, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
            if(mangling[i] == '_')
            {
                enforce(i + 1 < mangling.length, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
                if(mangling[i + 1] == 'N')
                {
                    // basic types
                    i += 2;
                    break;
                }
            }
            else if((mangling[i] >= 'C' && mangling[i] <= 'O') || mangling[i] == 'X')
            {
                // basic types
                i++;
                break;
            }
            else if(mangling[i] >= '0' && mangling[i] <= '9')
            {
                // back references
                i++;
                break;
            }
            else if(mangling[i].among('A', 'B'))
            {
                // modifiers
                i++;
                continue;
            }
            else if(mangling[i].among('P', 'Q', 'R', 'S'))
            {
                // modifiers
                i++;
                if(is64bit)
                {
                    if(i < mangling.length && mangling[i] == 'E')
                        i++;
                }
                continue;
            }
            else if(mangling[i].among('T', 'U', 'V'))
            {
                // complex types
                i++;
                if(mangling[i] >= '0' && mangling[i] < '9')
                {
                    // back reference
                    i++;
                    enforce(i < mangling.length && mangling[i] == '@', text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
                    i++;
                    break;
                }
                while(true)
                {
                    if(i + 1 < mangling.length && mangling[i] == '?' && mangling[i + 1] == '$')
                    {
                        // template
                        i += 2;

                        // template name
                        while(true)
                        {
                            enforce(i < mangling.length, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
                            enforce(mangling[i] == '@' || mangling[i] == '_' || isAlphaNum(mangling[i]), text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
                            if(mangling[i] == '@')
                            {
                                i++;
                                break;
                            }
                            i++;
                        }

                        // template arguments
                        while(true)
                        {
                            enforce(i < mangling.length, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
                            if(mangling[i] == '@')
                            {
                                break;
                            }
                            string mangling2 = mangling[i..$];
                            string arg = parseTypeManglingWin(mangling2, is64bit);
                            i += arg.length;
                        }
                    }
                    else if(i + 1 == mangling.length && mangling[i].among('A', 'B'))
                    {
                        break;
                    }
                    else
                    {
                        enforce(mangling[i] == '@' || mangling[i] == '_' || isAlphaNum(mangling[i]), text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
                        if(i + 1 < mangling.length && mangling[i] == '@' && mangling[i + 1] == '@')
                        {
                            i += 2;
                            break;
                        }
                        i++;
                    }
                }
                break;
            }
            else if(mangling[i] == 'W')
            {
                // enum type
                i++;
                enforce(i < mangling.length, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
                enforce(mangling[i] >= '0' && mangling[i] <= '7', text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
                i++;
                if(mangling[i] >= '0' && mangling[i] < '9')
                {
                    // back reference
                    i++;
                    enforce(i < mangling.length && mangling[i] == '@', text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
                    i++;
                    break;
                }
                while(true)
                {
                    enforce(i + 1 < mangling.length, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
                    enforce(mangling[i] == '@' || mangling[i] == '_' || isAlphaNum(mangling[i]), text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
                    if(mangling[i] == '@' && mangling[i + 1] == '@')
                    {
                        i += 2;
                        break;
                    }
                    i++;
                }
                break;
            }
            enforce(false, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
        }
        string r = mangling[0..i];
        mangling = mangling[i..$];
        return r;
    }
    /*private*/ FunctionManglingWin parseFunctionManglingWin(string mangling, bool is64bit)
    {
        import std.exception, std.ascii, std.algorithm;
        FunctionManglingWin r;
        enforce(mangling.length && mangling[0] == '?', text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
        size_t i = 1;
        while(true)
        {
            enforce(i + 1 < mangling.length, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
            if(mangling[i] == '?' && mangling[i + 1].among('0', '1'))
            {
                i += 2;
                continue;
            }
            if(mangling[i] == '@' && mangling[i + 1] == '@')
            {
                i += 2;
                break;
            }
            enforce(mangling[i] == '@' || mangling[i] == '_' || isAlphaNum(mangling[i]), text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling[0..i], " | ", mangling[i..$]));
            i++;
        }
        r.name = mangling[0..i];
        mangling = mangling[i..$];

        enforce(mangling.length >= 2, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
        if(mangling[0] >= 'A' && mangling[0] <= 'Z')
        {
            // function
            // private / protected / public / none
            uint accessLevel = (mangling[0] - 'A') / 8;
            // none / static / virtual / thunk
            uint functionType = ((mangling[0] - 'A') % 8) / 2;
            i = 1;
            if(is64bit && mangling[i] == 'E')
            {
                enforce(i + 1 < mangling.length, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
                enforce(mangling[i] == 'E', text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
                i++;
            }
            if(functionType != 1)
            {
                enforce(i + 1 < mangling.length, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
                enforce(mangling[i].among('A', 'B'), text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
                i++;
            }
            enforce(mangling[i].among('A', 'E'), text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
            i++;
            r.flags = mangling[0..i];
            mangling = mangling[i..$];
            if(mangling.startsWith("?A") || mangling.startsWith("?B"))
            {
                r.flags2 = mangling[0..2];
                mangling = mangling[2..$];
            }

            if(r.name.startsWith("??1")) // destructor
            {
                enforce(mangling == "@XZ");
                r.suffix = mangling;
            }
            else
            {
                r.returnType = parseTypeManglingWin(mangling, is64bit);
                while(true)
                {
                    enforce(mangling.length, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
                    if(mangling[0].among('Z', 'X', '@'))
                        break;
                    r.parameters ~= parseTypeManglingWin(mangling, is64bit);
                }
                foreach(char c; mangling)
                    enforce(c.among('Z', 'X', '@'), text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
                r.suffix = mangling;
            }
        }
        else if(mangling[0] >= '0' && mangling[0] <= '4')
        {
            // variable
            r.flags = mangling[0..1];
            mangling = mangling[1..$];
            r.returnType = parseTypeManglingWin(mangling, is64bit);
            enforce(mangling.among("A", "B", "EA", "EB"), text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));
            r.suffix = mangling;
        }
        else
            enforce(false, text("Unexpected mangling ", __FILE__, ":", __LINE__, ": ", mangling));

        return r;
    }
}

alias defaultConstructorMangling = function string(string name)
{
    version(Windows)
        static if(size_t.sizeof == 8)
            return "??0" ~ name ~ "@@QEAA@XZ";
        else
            return "??0" ~ name ~ "@@QAE@XZ";
    else
        return text("_ZN", name.length, name, "C1Ev");
};

private string replaceStart(string str, string from, string to)
{
    import std.algorithm;
    if(str.startsWith(from))
        str = to ~ str[from.length..$];
    return str;
}

// Changes the mangling only on Windows.
// On Win32 it also converts it from 64 bit.
alias mangleWindows = function string(string mangling, string code)
{
    version(Windows)
    {
        import std.algorithm;
        static if(size_t.sizeof == 4)
        {
            auto parsed = parseFunctionManglingWin(mangling, true);
            static if(size_t.sizeof == 4)
            {
                if(parsed.flags[0] >= 'A' && parsed.flags[0] <= 'Z' && parsed.flags[1] == 'E')
                {
                    parsed.flags = parsed.flags[0..1] ~ parsed.flags[2..$];
                    if(parsed.flags[$-1] == 'A')
                        parsed.flags = parsed.flags[0..$-1] ~ 'E';
                }
                parsed.returnType = parsed.returnType.replaceStart("PE", "P");
                parsed.returnType = parsed.returnType.replaceStart("QE", "Q");
                parsed.returnType = parsed.returnType.replaceStart("RE", "R");
                parsed.returnType = parsed.returnType.replaceStart("SE", "S");
            }
            mangling = parsed.name;
            mangling ~= parsed.flags;
            mangling ~= parsed.flags2;
            mangling ~= parsed.returnType;
            foreach(param; parsed.parameters)
            {
                static if(size_t.sizeof == 4)
                {
                    param = param.replaceStart("PE", "P");
                    param = param.replaceStart("QE", "Q");
                    param = param.replaceStart("RE", "R");
                    param = param.replaceStart("SE", "S");
                }
                mangling ~= param;
            }
            static if(size_t.sizeof == 4)
            {
                parsed.suffix = parsed.suffix.replaceStart("EA", "A");
            }
            mangling ~= parsed.suffix;
        }
        return "pragma(mangle, \"" ~ mangling ~ "\") " ~ code;
    }
    else
        return code;
};

alias mangleOpLess = function string(string name)
{
    version(Windows)
        static if(size_t.sizeof == 8)
            return "??M" ~ name ~ "@@UEBA_NAEBV0@@Z";
        else
            return "??M" ~ name ~ "@@UBE_NABV0@@Z";
    else
        return text("_ZNK", name.length, name, "ltERKS_");
};

version(Windows)
package FunctionManglingWin splitWindowsCppMangling(bool isClass, string attributes, string attributes2, string name, string dummyFunctionName, string mangling)
{
    import std.algorithm;

    mangling = mangling.replace(dummyFunctionName, name);
    auto parsed = parseFunctionManglingWin(mangling, (void*).sizeof == 8);
    if(name == "this")
    {
        parsed.name = parsed.name.replaceStart("?this@", "??0");
        assert(parsed.returnType == "X");
        parsed.returnType = "@";
    }
    if(!attributes.canFind("static"))
    {
        // private / protected / public / none
        uint accessLevel = (parsed.flags[0] - 'A') / 8;
        // none / static / virtual / thunk
        uint functionType = ((parsed.flags[0] - 'A') % 8) / 2;

        if(attributes.canFind("static"))
            functionType = 1;
        else if(attributes.canFind("final") || !isClass)
            functionType = 0;
        else
            functionType = 2;

        parsed.flags = [cast(char)('A' + accessLevel * 8 + functionType * 2)];
        if(attributes2.canFind("const"))
        {
            static if(size_t.sizeof == 8)
                parsed.flags ~= "EBA";
            else
                parsed.flags ~= "BE";
        }
        else
        {
            static if(size_t.sizeof == 8)
                parsed.flags ~= "EAA";
            else
                parsed.flags ~= "AE";
        }
    }
    return parsed;
}

version(Windows)
package FunctionManglingWin mangleClassesTailConst(FunctionManglingWin parsed)
{
    string makeTailConst(string mangling)
    {
        static if(size_t.sizeof == 8)
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
    foreach(ref param; parsed.parameters)
    {
        param = makeTailConst(param);
    }
    return parsed;
}

version(Windows)
package FunctionManglingWin mangleChangeAccess(FunctionManglingWin parsed, string access)
{
    // private / protected / public / none
    uint accessLevel = (parsed.flags[0] - 'A') / 8;
    // none / static / virtual / thunk
    uint functionType = ((parsed.flags[0] - 'A') % 8) / 2;

    if(access == "private")
        accessLevel = 0;
    else if(access == "protected")
        accessLevel = 1;
    else if(access == "public")
        accessLevel = 2;
    else
        assert(false);

    parsed.flags = cast(char)('A' + accessLevel * 8 + functionType * 2) ~ parsed.flags[1..$];
    return parsed;
}

version(Windows)
string recreateWindowsCppMangling(FunctionManglingWin parsed)
{
    string mangling;
    mangling = parsed.name;
    mangling ~= parsed.flags;
    mangling ~= parsed.flags2;
    mangling ~= parsed.returnType;
    foreach(param; parsed.parameters)
    {
        mangling ~= param;
    }
    mangling ~= parsed.suffix;
    return mangling;
}

/*
    Workaround for https://issues.dlang.org/show_bug.cgi?id=22550
    Changes the mangling of function declarations.
    It only uses a very simple parser and will only work for some declarations.
    The mangling could be wrong for some functions.
*/
package string changeWindowsMangling(string changeFuncs, string declaration, size_t line = __LINE__)
{
    string code;
    version(Windows)
    {
        import std.ascii, std.algorithm;

        struct StartEnd
        {
            size_t start, end;
        }
        StartEnd[] parts;
        size_t parenCount;
        bool afterCombiner;
        bool afterSemicolon;
        for(size_t i = 0; i < declaration.length;)
        {
            string part = nextCodePart(declaration[i..$]);
            bool mergeToLastPart;
            if(isWhite(part[0]) || part.startsWith("//") || part.startsWith("/*") || part.startsWith("/+"))
            {
                i += part.length;
                continue;
            }
            else
            {
                assert(!afterSemicolon);
                if(afterCombiner)
                {
                    mergeToLastPart = true;
                    afterCombiner = false;
                }

                if(part == "(")
                {
                    if(parenCount)
                        mergeToLastPart = true;
                    parenCount++;
                }
                else if(part == ")")
                {
                    assert(parenCount);
                    mergeToLastPart = true;
                    parenCount--;
                }
                else if(parenCount)
                {
                    mergeToLastPart = true;
                }
                else if(part == "." || part == "!")
                {
                    mergeToLastPart = true;
                    afterCombiner = true;
                }
                else if(part == "@")
                {
                    afterCombiner = true;
                }
                else if(part == ";")
                {
                    afterSemicolon = true;
                }
                else
                {
                }
            }

            if(mergeToLastPart)
                parts[$-1].end = i + part.length;
            else
                parts ~= StartEnd(i, i + part.length);

            //code ~= "pragma(msg, q{" ~ part ~ "});";
            i += part.length;
        }

        /*foreach(i, part; parts)
            code ~= "pragma(msg, q{" ~ text(i, ": ") ~ declaration[part.start..part.end] ~ "});";*/

        size_t attributesEnd;
        string usedAttributes;
        string attributesNoComments;
        while(parts.length)
        {
            string part = declaration[parts[0].start..parts[0].end];
            if(part.among("static", "override", "final", "extern", "export", "__gshared",
                "private", "protected", "public", "package")
                || part[0] == '@')
            {
                attributesEnd = parts[0].end;
                attributesNoComments ~= part ~ " ";
            }
            else if(part.among("const", "immutable", "shared"))
            {
                usedAttributes ~= part ~ " ";
                attributesEnd = parts[0].end;
                attributesNoComments ~= part ~ " ";
            }
            else
                break;
            parts = parts[1..$];
        }
        string attributes = declaration[0..attributesEnd];
        assert(parts.length >= 3, text(parts.length));
        string returnType;
        if(declaration[parts[0].start..parts[0].end] != "this")
        {
            returnType = declaration[attributesEnd..parts[0].end];
            parts = parts[1..$];
        }
        assert(parts.length >= 3, text(parts.length));
        string name = declaration[parts[0].start..parts[0].end];
        parts = parts[1..$];
        assert(isAlphaNum(name[0]) || name[0] == '_');
        string params = declaration[parts[0].start..parts[0].end];
        parts = parts[1..$];
        assert(params.startsWith("("));
        string attributesUsedAfter;
        while(parts.length >= 2)
        {
            string part = declaration[parts[0].start..parts[0].end];
            assert(part.among("const", "immutable", "shared"));
            attributesUsedAfter ~= part ~ " ";
            parts = parts[1..$];
        }
        assert(parts.length == 1);
        assert(declaration[parts[0].start..parts[0].end].startsWith(";"));

        /*code ~= "pragma(msg, q{" ~ attributes ~ "});";
        code ~= "pragma(msg, q{" ~ returnType ~ "});";
        code ~= "pragma(msg, q{" ~ name ~ "});";
        code ~= "pragma(msg, q{" ~ params ~ "});";*/

        string dummyFunctionName = text("dummyFunctionForChangingMangling", line, "_", name);

        code ~= "static";
        code ~= " " ~ usedAttributes;
        code ~= " " ~ returnType;
        if(name == "this")
            code ~= "void";
        code ~= " " ~ dummyFunctionName;
        code ~= params;
        //code ~= " " ~ attributesUsedAfter;
        code ~= ";\n";
        //code ~= "pragma(msg, " ~ dummyFunctionName ~ ".mangleof);\n";
        //code ~= "pragma(msg, parseFunctionManglingWin(" ~ dummyFunctionName ~ ".mangleof, (void*).sizeof));\n";
        code ~= "pragma(mangle, splitWindowsCppMangling(is(typeof(this) == class), ";
        code ~= "q{" ~ attributesNoComments ~ "}, ";
        code ~= "q{" ~ attributesUsedAfter ~ "}, ";
        code ~= "q{" ~ name ~ "}, ";
        code ~= "q{" ~ dummyFunctionName ~ "}, ";
        code ~= dummyFunctionName ~ ".mangleof";
        code ~= ")";
        code ~= "." ~ changeFuncs;
        code ~= ".recreateWindowsCppMangling";
        code ~= ")\n";
    }

    code ~= declaration;
    return code;
}

// Workaround for https://issues.dlang.org/show_bug.cgi?id=19660, which can be removed later.
version(Windows)
    enum exportOnWindows = " export ";
else
    enum exportOnWindows = "";

// TODO: can be removed when a released dmd contains imported.
static if(!__traits(compiles, imported))
template imported(string moduleName)
{
    mixin("import imported = " ~ moduleName ~ ";");
}
