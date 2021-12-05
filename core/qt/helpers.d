/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.helpers;

import std.traits;
import std.conv;
import std.array;

private string nextCodePart(string code)
{
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

alias mangleWindows = function string(string mangling, string code)
{
    version(Windows)
        static if(size_t.sizeof == 8)
            return "pragma(mangle, \"" ~ mangling ~ "\") " ~ code;
        else
            return "pragma(mangle, \""
                ~ mangling.replace("@@QEBAKPE", "@@QBEKP")
                    .replace("@@QEBAJPE", "@@QBEJP")
                    .replace("@@QEBAHPE", "@@QBEHP")
                    .replace("@@QEBAPEB", "@@QBEPB")
                    .replace("@@MEAA_NPE", "@@MAE_NP")
                    .replace("@@MEAA_NHHPE", "@@MAE_NHHP")
                    .replace("@@MEAA_NHPE", "@@MAE_NHP")
                    .replace("@@UEAA_NAE", "@@UAE_NA")
                    .replace("@@MEBA_NPE", "@@MBE_NP")
                    .replace("@@UEAAXPEA", "@@UAEXPA")
                    .replace("@@MEAAXPE", "@@MAEXP")
                    .replace("@@UEAA_NPE", "@@UAE_NP")
                    .replace("@@UEAA", "@@UAE")
                    .replace("@@QEBA", "@@QBE")
                    .replace("@@MEBA", "@@MBE")
                    .replace("@@0PEAV1@EA", "@@0PAV1@A")
                    .replace("@@PEBV1@PEAPEAX01PE", "@@PBV1@PAPAX01P")
                    .replace("@@PEBHPE", "@@PBHP")
                    .replace("@@MEAA_NAE", "@@MAE_NA")
                    .replace("@@MEAA", "@@MAE")
                    .replace("@@PEAXPE", "@@PAXP")
                    .replace("@@UEBA_NPE", "@@UBE_NP")
                    .replace("@@UEBA", "@@UBE")
                    .replace("@@AEBV", "@@ABV")
                    .replace("@@HPE", "@@HP")
                    .replace("@@EEAAXPE", "@@EAEXP")
                    .replace("@@PE", "@@P")
                    .replace("@@HHAE", "@@HHA")
                ~ "\") " ~ code;
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
