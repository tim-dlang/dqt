// Written in the D programming language

/+
    Copyright: Copyright 2017 - 2020
    License:   $(WEB www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
    Authors:   Jonathan M Davis
  +/
module qt.widgets.internal.dxml.internal;

import std.range : takeExactly;
import std.range.primitives;
import std.traits;
import std.utf : byCodeUnit;

package:

// Like std.algorithm.equal except that it won't decode string, and it allows
// comparing a string with a range with a character type other than char.
// However, the text must be ASCII.
bool equalCU(R)(R range, string text)
    if(isForwardRange!R && isSomeChar!(ElementType!R))
{
    static if(hasLength!R)
    {
        if(range.length != text.length)
            return false;
    }

    foreach(c; text)
    {
        if(range.empty || range.front != c)
            return false;
        range.popFront();
    }

    return range.empty;
}

unittest
{
    import std.algorithm : filter;
    import std.meta : AliasSeq;

    static foreach(str; AliasSeq!("hello world", "hello world"w, "hello world"d))
    {
        assert(equalCU(str, "hello world"));
        assert(equalCU(byCodeUnit(str), "hello world"));
        assert(equalCU(filter!"true"(str), "hello world"));
        assert(equalCU(filter!"true"(byCodeUnit(str)), "hello world"));

        assert(!equalCU(str, "hello worl"));
        assert(!equalCU(byCodeUnit(str), "hello worl"));
        assert(!equalCU(filter!"true"(str), "hello worl"));
        assert(!equalCU(filter!"true"(byCodeUnit(str)), "hello worl"));

        assert(!equalCU(str, "hello world "));
        assert(!equalCU(byCodeUnit(str), "hello world "));
        assert(!equalCU(filter!"true"(str), "hello world "));
        assert(!equalCU(filter!"true"(byCodeUnit(str)), "hello world "));
    }
}


/+
    This is used for the cases where we need to take a range and strip
    ByCodeUnit from it if it's a wrapped string and return the original
    otherwise - e.g. when we want to return a slice of the XML text via a
    property of EntityCursor.

    Typically, we're either operating on a string that we needed to wrap using
    byCodeUnit, or we're operating on a range that didn't need to be wrapped,
    but it's possible for someone to give us a range that's the result of
    calling byCodeUnit on a range that gets wrapped by byCodeUnit, and in that
    case, when we call byCodeUnit on it (e.g. in ParserState's constructor), it
    would just return the same type, meaning that if we just always stripped off
    the byCodeUnit wrapper with stripBCU, we wouldn't be returning the range
    type that we were given, which is the whole point of stripBCU. So, by taking
    into account the range type we were given with Orig, we're able to correctly
    determine whether we need to strip off the byCodeUnit wrapper.
  +/
pragma(inline, true) auto stripBCU(Orig, R)(R range)
    if(is(typeof(takeExactly(byCodeUnit(Orig.init), 42)) == R))
{
    static if(isNarrowString!Orig)
        return range.source;
    else
        return range;
}

unittest
{
    import std.algorithm : equal, filter;
    import std.range : takeExactly;

    auto bcu = byCodeUnit("hello");
    auto bcuResult = bcu.stripBCU!string();
    assert(equal(bcuResult, "hello"));
    static assert(is(typeof(bcuResult) == string));

    auto unstripped = bcu.stripBCU!(typeof(bcu))();
    assert(equal(bcuResult, "hello"));
    static assert(is(typeof(unstripped) == typeof(bcu)));

    auto filtered = filter!"true"("hello").takeExactly(3);
    auto filterResult = filtered.stripBCU!(typeof(filtered))();
    assert(equal(filterResult, "hel"));
    static assert(is(typeof(filterResult) == typeof(filtered)));
}


/+
    The purpose of this function is to work around problems related to ranges
    that either ar classes or contain classes, since their init values tend to
    blow up when anything is done with them.
 +/
// TODO create bug report, because this function cannot be inlined
/+pragma(inline, true)+/ auto checkedSave(R)(ref R range)
{
    return range is R.init ? R.init : range.save;
}


// Char ::= #x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] | [#x10000-#x10FFFF]
bool isXMLChar(dchar c) pure nothrow @safe @nogc
{
    // The rule says '\n' and not '\r', but we're not going to pass '\n' to
    // this function, because it has to be handled separately for keeping track
    // of TextPos. Look at the documentation for EntityRange for the
    // explanation of how we're treating '\r' and why.
    import std.ascii : isASCII;
    assert(c != '\n');
    return isASCII(c) ? c >= ' ' || c == '\t' || c == '\r'
                      : c > 127 && (c <= 0xD7FF || (c >= 0xE000 && c <= 0xFFFD) || (c >= 0x10000 && c <= 0x10FFFF));
}

pure nothrow @safe @nogc unittest
{
    import std.range : only;
    import std.typecons : tuple;

    foreach(c; char.min .. ' ')
    {
        if(c == '\n')
            continue;
        if(c == ' ' || c == '\t' || c == '\r')
            assert(isXMLChar(c));
        else
            assert(!isXMLChar(c));
    }
    foreach(dchar c; ' ' .. 256)
        assert(isXMLChar(c));

    assert(isXMLChar(0xD7FF - 1));
    assert(isXMLChar(0xD7FF));
    assert(!isXMLChar(0xD7FF + 1));

    foreach(t; only(tuple(0xE000, 0xFFFD),
                    tuple(0x10000, 0x10FFFF)))
    {
        assert(!isXMLChar(t[0] - 1));
        assert(isXMLChar(t[0]));
        assert(isXMLChar(t[0] + 1));
        assert(isXMLChar(t[0] + (t[1] - t[0])));
        assert(isXMLChar(t[1] - 1));
        assert(isXMLChar(t[1]));
        assert(!isXMLChar(t[1] + 1));
    }
}


// NameStartChar ::= ":" | [A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] | [#xF8-#x2FF] | [#x370-#x37D] |
//                   [#x37F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] |
//                   [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
bool isNameStartChar(dchar c) @safe pure nothrow @nogc
{
    import std.ascii : isAlpha;

    if(isAlpha(c))
        return true;
    if(c == ':' || c == '_')
        return true;
    if(c >= 0xC0 && c <= 0xD6)
        return true;
    if(c >= 0xD8 && c <= 0xF6)
        return true;
    if(c >= 0xF8 && c <= 0x2FF)
        return true;
    if(c >= 0x370 && c <= 0x37D)
        return true;
    if(c >= 0x37F && c <= 0x1FFF)
        return true;
    if(c >= 0x200C && c <= 0x200D)
        return true;
    if(c >= 0x2070 && c <= 0x218F)
        return true;
    if(c >= 0x2C00 && c <= 0x2FEF)
        return true;
    if(c >= 0x3001 && c <= 0xD7FF)
        return true;
    if(c >= 0xF900 && c <= 0xFDCF)
        return true;
    if(c >= 0xFDF0 && c <= 0xFFFD)
        return true;
    if(c >= 0x10000 && c <= 0xEFFFF)
        return true;
    return false;
}

pure nothrow @safe @nogc unittest
{
    import std.range : only;
    import std.typecons : tuple;

    foreach(c; char.min .. cast(char)128)
    {
        if(c == ':' || c == '_' || c >= 'a' && c <= 'z' || c >= 'A' && c <= 'Z')
            assert(isNameStartChar(c));
        else
            assert(!isNameStartChar(c));
    }

    foreach(t; only(tuple(0xC0, 0xD6),
                    tuple(0xD8, 0xF6),
                    tuple(0xF8, 0x2FF),
                    tuple(0x370, 0x37D),
                    tuple(0x37F, 0x1FFF),
                    tuple(0x200C, 0x200D),
                    tuple(0x2070, 0x218F),
                    tuple(0x2C00, 0x2FEF),
                    tuple(0x3001, 0xD7FF),
                    tuple(0xF900, 0xFDCF),
                    tuple(0xFDF0, 0xFFFD),
                    tuple(0x10000, 0xEFFFF)))
    {
        assert(!isNameStartChar(t[0] - 1));
        assert(isNameStartChar(t[0]));
        assert(isNameStartChar(t[0] + 1));
        assert(isNameStartChar(t[0] + (t[1] - t[0])));
        assert(isNameStartChar(t[1] - 1));
        assert(isNameStartChar(t[1]));
        assert(!isNameStartChar(t[1] + 1));
    }
}


// NameStartChar ::= ":" | [A-Z] | "_" | [a-z] | [#xC0-#xD6] | [#xD8-#xF6] | [#xF8-#x2FF] | [#x370-#x37D] |
//                   [#x37F-#x1FFF] | [#x200C-#x200D] | [#x2070-#x218F] | [#x2C00-#x2FEF] | [#x3001-#xD7FF] |
//                   [#xF900-#xFDCF] | [#xFDF0-#xFFFD] | [#x10000-#xEFFFF]
// NameChar      ::= NameStartChar | "-" | "." | [0-9] | #xB7 | [#x0300-#x036F] | [#x203F-#x2040]
bool isNameChar(dchar c) @safe pure nothrow @nogc
{
    import std.ascii : isDigit;
    return isNameStartChar(c) || isDigit(c) || c == '-' || c == '.' || c == 0xB7 ||
           c >= 0x0300 && c <= 0x036F || c >= 0x203F && c <= 0x2040;
}

pure nothrow @safe @nogc unittest
{
    import std.ascii : isAlphaNum;
    import std.range : only;
    import std.typecons : tuple;

    foreach(c; char.min .. cast(char)129)
    {
        if(isAlphaNum(c) || c == ':' || c == '_' || c == '-' || c == '.')
            assert(isNameChar(c));
        else
            assert(!isNameChar(c));
    }

    assert(!isNameChar(0xB7 - 1));
    assert(isNameChar(0xB7));
    assert(!isNameChar(0xB7 + 1));

    foreach(t; only(tuple(0xC0, 0xD6),
                    tuple(0xD8, 0xF6),
                    tuple(0xF8, 0x037D), // 0xF8 - 0x2FF, 0x0300 - 0x036F, 0x37 - 0x37D
                    tuple(0x37F, 0x1FFF),
                    tuple(0x200C, 0x200D),
                    tuple(0x2070, 0x218F),
                    tuple(0x2C00, 0x2FEF),
                    tuple(0x3001, 0xD7FF),
                    tuple(0xF900, 0xFDCF),
                    tuple(0xFDF0, 0xFFFD),
                    tuple(0x10000, 0xEFFFF),
                    tuple(0x203F, 0x2040)))
    {
        assert(!isNameChar(t[0] - 1));
        assert(isNameChar(t[0]));
        assert(isNameChar(t[0] + 1));
        assert(isNameChar(t[0] + (t[1] - t[0])));
        assert(isNameChar(t[1] - 1));
        assert(isNameChar(t[1]));
        assert(!isNameChar(t[1] + 1));
    }
}


//------------------------------------------------------------------------------
// Unit test helpers
//------------------------------------------------------------------------------

version(unittest):

struct FwdCharRange(C)
{
public:

    @property bool empty() @safe const pure nothrow @nogc
    {
        return _str.empty;
    }

    @property C front() @safe const pure nothrow @nogc
    {
        return _str[0];
    }

    void popFront() @safe pure nothrow @nogc
    {
        _str = _str[1 .. $];
    }

    auto save() @safe pure nothrow @nogc
    {
        return this;
    }

    this(C[] str)
    {
        _str = str;
    }

private:

    C[] _str;
}

auto fwdCharRange(R)(R range)
    if(isSomeString!R && !is(R == enum))
{
    return FwdCharRange!(ElementEncodingType!R)(range);
}

static assert(isForwardRange!(FwdCharRange!char));
static assert(!isBidirectionalRange!(FwdCharRange!char));

unittest
{
    auto range = fwdCharRange("hello world");
    range.popFront();
    assert(range._str == "ello world");
    auto unsaved = range;
    range.popFront();
    assert(range._str == "llo world");
    assert(unsaved._str == "ello world");
    auto saved = range.save;
    range.popFront();
    assert(range._str == "lo world");
    assert(saved._str == "llo world");
}


class FwdRefCharRange(C)
{
public:

    @property bool empty() @safe const pure nothrow @nogc
    {
        return _str.empty;
    }

    @property C front() @safe const pure nothrow @nogc
    {
        return _str[0];
    }

    void popFront() @safe pure nothrow @nogc
    {
        _str = _str[1 .. $];
    }

    auto save() @safe pure nothrow
    {
        return new FwdRefCharRange(_str);
    }

    this(C[] str)
    {
        _str = str;
    }

private:

    C[] _str;
}

auto fwdRefCharRange(R)(R range)
    if(isSomeString!R && !is(R == enum))
{
    return new FwdRefCharRange!(ElementEncodingType!R)(range);
}

static assert(isForwardRange!(FwdRefCharRange!char));
static assert(!isBidirectionalRange!(FwdRefCharRange!char));

unittest
{
    auto range = fwdRefCharRange("hello world");
    range.popFront();
    assert(range._str == "ello world");
    auto unsaved = range;
    range.popFront();
    assert(range._str == "llo world");
    assert(unsaved._str == "llo world");
    auto saved = range.save;
    range.popFront();
    assert(range._str == "lo world");
    assert(saved._str == "llo world");
}


struct RACharRange(C)
{
public:

    @property bool empty() @safe const pure nothrow @nogc
    {
        return _str.empty;
    }

    @property C front() @safe const pure nothrow @nogc
    {
        return _str[0];
    }

    void popFront() @safe pure nothrow @nogc
    {
        _str = _str[1 .. $];
    }

    auto save() @safe pure nothrow @nogc
    {
        return this;
    }

    @property C back() @safe const pure nothrow @nogc
    {
        return _str[$ - 1];
    }

    void popBack() @safe pure nothrow @nogc
    {
        _str = _str[0 .. $ - 1];
    }

    @property size_t length() @safe const pure nothrow @nogc
    {
        return _str.length;
    }

    C opIndex(size_t i) @safe const pure nothrow @nogc
    {
        return _str[i];
    }

    this(C[] str)
    {
        _str = str;
    }

private:

    C[] _str;
}

auto raCharRange(R)(R range)
    if(isSomeString!R && !is(R == enum))
{
    return RACharRange!(ElementEncodingType!R)(range);
}

static assert(isForwardRange!(RACharRange!char));
static assert(isRandomAccessRange!(RACharRange!char));
static assert(!hasSlicing!(RACharRange!char));

unittest
{
    auto range = raCharRange("hello world");
    range.popFront();
    assert(range._str == "ello world");
    auto unsaved = range;
    range.popFront();
    assert(range._str == "llo world");
    assert(unsaved._str == "ello world");
    auto saved = range.save;
    range.popFront();
    assert(range._str == "lo world");
    assert(saved._str == "llo world");
}


struct RASCharRange(C)
{
public:

    @property bool empty() @safe const pure nothrow @nogc
    {
        return _str.empty;
    }

    @property C front() @safe const pure nothrow @nogc
    {
        return _str[0];
    }

    void popFront() @safe pure nothrow @nogc
    {
        _str = _str[1 .. $];
    }

    auto save() @safe pure nothrow @nogc
    {
        return this;
    }

    @property C back() @safe const pure nothrow @nogc
    {
        return _str[$ - 1];
    }

    void popBack() @safe pure nothrow @nogc
    {
        _str = _str[0 .. $ - 1];
    }

    @property size_t length() @safe const pure nothrow @nogc
    {
        return _str.length;
    }

    C opIndex(size_t i) @safe const pure nothrow @nogc
    {
        return _str[i];
    }

    auto opSlice(size_t i, size_t j) @safe pure nothrow @nogc
    {
        return RASCharRange(_str[i .. j]);
    }

    this(C[] str)
    {
        _str = str;
    }

private:

    C[] _str;
}

auto rasCharRange(R)(R range)
    if(isSomeString!R && !is(R == enum))
{
    return RASCharRange!(ElementEncodingType!R)(range);
}

static assert(isForwardRange!(RASCharRange!char));
static assert(isRandomAccessRange!(RASCharRange!char));
static assert(hasSlicing!(RASCharRange!char));

unittest
{
    auto range = rasCharRange("hello world");
    range.popFront();
    assert(range._str == "ello world");
    auto unsaved = range;
    range.popFront();
    assert(range._str == "llo world");
    assert(unsaved._str == "ello world");
    auto saved = range.save;
    range.popFront();
    assert(range._str == "lo world");
    assert(saved._str == "llo world");
}


class RASRefCharRange(C)
{
public:

    @property bool empty() @safe const pure nothrow @nogc
    {
        return _str.empty;
    }

    @property C front() @safe const pure nothrow @nogc
    {
        return _str[0];
    }

    void popFront() @safe pure nothrow @nogc
    {
        _str = _str[1 .. $];
    }

    auto save() @safe pure nothrow
    {
        return new RASRefCharRange(_str);
    }

    @property C back() @safe const pure nothrow @nogc
    {
        return _str[$ - 1];
    }

    void popBack() @safe pure nothrow @nogc
    {
        _str = _str[0 .. $ - 1];
    }

    @property size_t length() @safe const pure nothrow @nogc
    {
        return _str.length;
    }

    C opIndex(size_t i) @safe const pure nothrow @nogc
    {
        return _str[i];
    }

    auto opSlice(size_t i, size_t j) @safe pure nothrow
    {
        return new RASRefCharRange(_str[i .. j]);
    }

    this(C[] str)
    {
        _str = str;
    }

private:

    C[] _str;
}

auto rasRefCharRange(R)(R range)
    if(isSomeString!R && !is(R == enum))
{
    return new RASRefCharRange!(ElementEncodingType!R)(range);
}

static assert(isForwardRange!(RASRefCharRange!char));
static assert(isRandomAccessRange!(RASRefCharRange!char));
static assert(hasSlicing!(RASRefCharRange!char));

unittest
{
    auto range = rasRefCharRange("hello world");
    range.popFront();
    assert(range._str == "ello world");
    auto unsaved = range;
    range.popFront();
    assert(range._str == "llo world");
    assert(unsaved._str == "llo world");
    auto saved = range.save;
    range.popFront();
    assert(range._str == "lo world");
    assert(saved._str == "llo world");
}


// Wrapping it like this rather than assigning testRangeFuncs directly
// allows us to avoid having the imports be at module-level, which is
// generally not desirable with version(unittest).
alias testRangeFuncs = _testRangeFuncs!();
template _testRangeFuncs()
{
    import std.conv : to;
    import std.algorithm.iteration : filter;
    import std.meta : AliasSeq;
    import std.utf : byCodeUnit;
    alias _testRangeFuncs = AliasSeq!(a => to!string(a), a => to!wstring(a), a => to!dstring(a), a => to!(char[])(a),
                                      a => filter!"true"(a), a => fwdCharRange(a), a => fwdRefCharRange(a),
                                      a => raCharRange(a), a => rasCharRange(a), a => rasRefCharRange(a),
                                      a => byCodeUnit(a));
}


template codeLen(alias func, string str)
{
    import std.utf : codeLength;
    enum codeLen = cast(int)codeLength!(ElementEncodingType!(typeof(func("hello"))))(str);
}


// This is for testing that code using an output range can be marked with @safe,
// pure, etc. so long as the output range itself supports them. With this type,
// we don't have to worry about what attributes something like Appender
// currently supports.
struct TestAttrOR
{
    void put(T)(T) @safe pure nothrow @nogc
    {
    }
}
