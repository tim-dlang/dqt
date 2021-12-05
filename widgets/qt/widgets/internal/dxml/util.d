// Written in the D programming language

/++
    This module contains helper functions which aren't specific to the parser,
    the DOM, or the writer.

    $(TABLE
        $(TR $(TH Symbol) $(TH Description))
        $(TR $(TD $(LREF decodeXML))
             $(TD Takes a range of characters, strips carriage returns from it,
                  and converts both character references and the predefined
                  entity references in the range into the characters that they
                  refer to.))
        $(TR $(TD $(LREF asDecodedXML))
             $(TD The version of $(LREF decodeXML) that returns a lazy range.))
        $(TR $(TD $(LREF parseCharRef))
             $(TD Parses a character reference from the front of a range of
                  characters.))
        $(TR $(TD $(LREF parseStdEntityRef))
             $(TD Parses one of the predefined entity references from the start
                  of a range of characters.))
        $(TR $(TD $(LREF stripIndent))
             $(TD Removes the indent from the front of each line of a range of
                  characters that was XML text which was formatted for
                  human-readability.))
        $(TR $(TD $(LREF withoutIndent))
             $(TD The version of $(LREF stripIndent) that returns a lazy
                  range.))
        $(TR $(TD $(LREF StdEntityRef))
             $(TD Enum containing the string representations of the five,
                  predefined entity references.))
        $(TR $(TD $(LREF encodeText))
             $(TD Encodes characters which cannot appear in
                  $(REF_ALTTEXT EntityType.text, EntityType.text, dxml, parser)
                  in their literal form.))
        $(TR $(TD $(LREF encodeAttr))
             $(TD Encodes characters which cannot appear in the attribute value
                  of an element start tag in their literal form.))
        $(TR $(TD $(LREF encodeCharRef))
             $(TD Encodes a character as a character reference.))
    )

    Copyright: Copyright 2018 - 2020
    License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
    Authors:   $(HTTPS jmdavisprog.com, Jonathan M Davis)
    Source:    $(LINK_TO_SRC dxml/_util.d)

    See_Also: $(LINK2 http://www.w3.org/TR/REC-xml/, Official Specification for XML 1.0)
  +/
module qt.widgets.internal.dxml.util;

import std.range.primitives;
import std.traits;
import std.typecons : Nullable;

/++
    Decodes any XML character references and standard XML entity references in
    the text as well as removing any carriage returns. It's intended to be used
    on the text fields of element tags and on the values of start tag
    attributes.

    There are a number of characters that either can't be directly represented
    in the text fields or attribute values in XML or which can sometimes be
    directly represented but not always (e.g. an attribute value can contain
    either a single quote or a double quote, but it can't contain both at the
    same time, because one of them would match the opening quote). So, those
    characters have alternate representations in order to be allowed (e.g.
    $(D_CODE_STRING "$(AMP)lt;") for $(D_CODE_STRING '<'), because
    $(D_CODE_STRING '<') would normally be the beginning of an entity).
    Technically, they're entity references, but the ones handled by decodeXML
    are the ones explicitly defined in the XML standard and which don't require
    a DTD section.

    Ideally, the parser would transform all such alternate representations to
    what they represent when providing the text to the application, but that
    would make it impossible to return slices of the original text from the
    properties of an $(REF_ALTTEXT Entity, EntityRange.Entity, dxml, parser).
    So, instead of having those properties do the transformation themselves,
    decodeXML and asDecodedXML do that so that the application can choose to do
    it or not (in many cases, there is nothing to decode, making the calls
    unnecessary).

    Similarly, an application can choose to encode a character as a character
    reference (e.g. $(D_CODE_STRING '$(AMP)#65") or
    $(D_CODE_STRING '$(AMP)#x40") for $(D_CODE_STRING 'A')). decodeXML will
    decode such character references to their corresponding characters.

    However, decodeXML does not handle any entity references beyond the five
    predefined ones listed below. All others are left unprocessed. Processing
    them properly would require handling the DTD section, which dxml does not
    support. The parser considers any entity references other than the
    predefined ones to be invalid XML, so unless the text being passed to
    decodeXML doesn't come from dxml's parser, it can't have any entity
    references in it other than the predefined ones. Similarly, invalid
    character references are left unprocessed as well as any character that is
    not valid in an XML document. decodeXML never throws on invalid XML.

    Also, $(D_CODE_STRING '\r') is not supposed to appear in an XML document
    except as a character reference unless it's in a CDATA section. So, it
    really should be stripped out before being handed off to the application,
    but again, that doesn't work with slices. So, decodeXML also handles that.

    Specifically, what decodeXML and asDecodedXML do is

    $(TABLE
        $(TR $(TD convert $(D_CODE_STRING $(AMP)amp;) to $(D_CODE_STRING &)))
        $(TR $(TD convert $(D_CODE_STRING $(AMP)gt;) to $(D_CODE_STRING >)))
        $(TR $(TD convert $(D_CODE_STRING $(AMP)lt;) to $(D_CODE_STRING <)))
        $(TR $(TD convert $(D_CODE_STRING $(AMP)apos;) to $(D_CODE_STRING ')))
        $(TR $(TD convert $(D_CODE_STRING $(AMP)quot;) to $(D_CODE_STRING ")))
        $(TR $(TD remove all instances of $(D_CODE_STRING \r)))
        $(TR $(TD convert all character references (e.g.
                  $(D_CODE_STRING $(AMP)#xA;)) to the characters that they
                  represent))
    )

    All other entity references are left untouched, and any $(D_CODE_STRING '&')
    which is not used in one of the constructs listed in the table as well as
    any malformed constructs (e.g. $(D_CODE_STRING "&Amp;") or
    $(D_CODE_STRING "&#xGGA2;")) are left untouched.

    The difference between decodeXML and asDecodedXML is that decodeXML returns
    a $(K_STRING), whereas asDecodedXML returns a lazy _range of code
    units. In the case where a $(K_STRING) is passed to decodeXML, it
    will simply return the original $(K_STRING) if there is no text to decode
    (whereas in other cases, decodeXML and asDecodedXML are forced to return
    new ranges even if there is no text to decode).

    Params:
        range = The _range of characters to decodeXML.

    Returns: The decoded text. decodeXML returns a $(K_STRING), whereas
             asDecodedXML returns a lazy _range of code units (so it could be a
             _range of $(K_CHAR) or $(K_WCHAR) and not just $(K_DCHAR); which it
             is depends on the code units of the _range being passed in).

    See_Also: $(LINK http://www.w3.org/TR/REC-xml/#dt-chardata)$(BR)
              $(LREF parseStdEntityRef)$(BR)
              $(LREF parseCharRef)$(BR)
              $(REF EntityRange.Entity.attributes, dxml, parser)$(BR)
              $(REF EntityRange.Entity.text, dxml, parser)$(BR)
              $(LREF encodeAttr)$(BR)
              $(LREF encodeText)
  +/
string decodeXML(R)(R range)
    if(isForwardRange!R && isSomeChar!(ElementType!R))
{
    import std.conv : to;

    static if(isDynamicArray!R && is(Unqual!(ElementEncodingType!R) == char))
    {
        import std.algorithm.searching : find, startsWith;
        import std.array : appender;
        import std.meta : AliasSeq;

        auto found = range.find('&', '\r');
        if(found[1] == 0)
            return range.to!string();

        auto retval = appender!string();
        retval.reserve(range.length);
        put(retval, range[0 .. $ - found[0].length]);
        range = range[$ - found[0].length .. $];

        size_t i = 0;
        loop: for(; i != range.length;)
        {
            switch(range[i])
            {
                case '&':
                {
                    if(i + 1 == range.length)
                    {
                        ++i;
                        break loop;
                    }
                    put(retval, range[0 .. i]);
                    range = range[i .. $];
                    i = 0;
                    static foreach(func; AliasSeq!(parseStdEntityRef, parseCharRef))
                    {{
                        immutable c = func(range);
                        if(!c.isNull)
                        {
                            put(retval, c.get);
                            continue loop;
                        }
                    }}
                    put(retval, '&');
                    range = range[1 .. $];
                    continue;
                }
                case '\r':
                {
                    if(i != 0)
                    {
                        put(retval, range[0 .. i]);
                        range = range[i + 1 .. $];
                        i = 0;
                    }
                    else
                        range = range[1 .. $];
                    continue;
                }
                default: ++i; continue;
            }
        }

        if(i != 0)
            put(retval, range[0 .. i]);

        return retval.data;
    }
    else
        return range.asDecodedXML().to!string();
}


/// Ditto
auto asDecodedXML(R)(R range)
    if(isForwardRange!R && isSomeChar!(ElementType!R))
{
    import std.meta : AliasSeq;
    import std.utf : byCodeUnit, encode, UseReplacementDchar;

    static struct DecodedXML
    {
    public:

        @property empty() { return _range.empty && _begin == _end; }

        void popFront()
        {
            if(_begin != _end)
            {
                if(++_begin != _end)
                    return;
            }
            else
                _range.popFront();
            _popFrontImpl();
        }

        @property save()
        {
            auto retval = this;
            retval._range = _range.save;
            return retval;
        }

    private:

        void _popFrontImpl()
        {
            while(!_range.empty)
            {
                switch(_range.front)
                {
                    case '&':
                    {
                        static foreach(func; AliasSeq!(parseStdEntityRef, parseCharRef))
                        {{
                            immutable c = func(_range);
                            if(!c.isNull)
                            {
                                _begin = 0;
                                _end = _buffer.encode!(UseReplacementDchar.yes)(c.get);
                                return;
                            }
                        }}
                        goto default;
                    }
                    case '\r':
                    {
                        assert(_begin == _end);
                        _range.popFront();
                        continue;
                    }
                    default:
                    {
                        assert(_begin == _end);
                        return;
                    }
                }
            }
        }

        this(R range) @safe
        {
            _range = byCodeUnit(range);
            _popFrontImpl();
        }

        typeof(byCodeUnit(R.init)) _range;
        static if(is(Unqual!(ElementEncodingType!R) == char))
            char[4] _buffer;
        else static if(is(Unqual!(ElementEncodingType!R) == wchar))
            wchar[2] _buffer;
        else
            dchar[1] _buffer;
        size_t _begin;
        size_t _end;

    public:

        // FIXME A compiler bug prevents this from going with the public declarations
        // above. If it's there, the compiler thinks that _buffer isn't defined when
        // it tries to compile front. It needs to be reduced and reported.
        @property typeof(_buffer[0]) front() { return _begin == _end ? _range.front : _buffer[_begin]; }
    }

    return DecodedXML(range);
}

///
unittest
{
    assert(decodeXML("hello world &amp;&gt;&lt;&apos;&quot; \r\r\r\r\r foo") ==
           `hello world &><'"  foo`);

    assert(decodeXML("if(foo &amp;&amp; bar)\r\n" ~
                     "    left = right;") ==
           "if(foo && bar)\n" ~
           "    left = right;");

    assert(decodeXML("&#12487;&#12451;&#12521;&#12531;") == "ディラン");
    assert(decodeXML("foo") == "foo");
    assert(decodeXML("&#   ;") == "&#   ;");

    {
        import std.algorithm.comparison : equal;
        auto range = asDecodedXML("hello world &amp;&gt;&lt;&apos;&quot; " ~
                                  "\r\r\r\r\r foo");
        assert(equal(range, `hello world &><'"  foo`));
    }

    {
        import qt.widgets.internal.dxml.parser;
        auto xml = "<root>\n" ~
                   "    <function return='vector&lt;int&gt;' name='foo'>\r\n" ~
                   "        <doc_comment>This function does something really\r\n" ~
                   "                 fancy, and you will love it.</doc_comment>\r\n" ~
                   "        <param type='int' name='i'>\r\n" ~
                   "        <param type='const std::string&amp;' name='s'>\r\n" ~
                   "    </function>\n" ~
                   "</root>";
        auto range = parseXML!simpleXML(xml);
        range.popFront();
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "function");
        {
            auto attrs = range.front.attributes;
            assert(attrs.front.name == "return");
            assert(attrs.front.value == "vector&lt;int&gt;");
            assert(decodeXML(attrs.front.value) == "vector<int>");
            attrs.popFront();
            assert(attrs.front.name == "name");
            assert(attrs.front.value == "foo");
            assert(decodeXML(attrs.front.value) == "foo");
        }
        range.popFront();

        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "doc_comment");
        range.popFront();

        assert(range.front.text ==
               "This function does something really\r\n" ~
               "                 fancy, and you will love it.");
        assert(decodeXML(range.front.text) ==
               "This function does something really\n" ~
               "                 fancy, and you will love it.");
        range.popFront();

        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "doc_comment");
        range.popFront();

        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "param");
        {
            auto attrs = range.front.attributes;
            assert(attrs.front.name == "type");
            assert(attrs.front.value == "int");
            assert(decodeXML(attrs.front.value) == "int");
            attrs.popFront();
            assert(attrs.front.name == "name");
            assert(attrs.front.value == "i");
            assert(decodeXML(attrs.front.value) == "i");
        }
        range.popFront();

        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "param");
        {
            auto attrs = range.front.attributes;
            assert(attrs.front.name == "type");
            assert(attrs.front.value == "const std::string&amp;");
            assert(decodeXML(attrs.front.value) == "const std::string&");
            attrs.popFront();
            assert(attrs.front.name == "name");
            assert(attrs.front.value == "s");
            assert(decodeXML(attrs.front.value) == "s");
        }
    }
}

unittest
{
    import core.exception : AssertError;
    import std.algorithm.comparison : equal;
    import std.exception : enforce;
    import std.utf : byUTF;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static void test(alias func)(string text, string expected, size_t line = __LINE__)
    {
        auto range = func(text);
        enforce!AssertError(range.save.decodeXML() == expected, "unittest failed 1", __FILE__, line);
        alias C = ElementType!(typeof(range.save.asDecodedXML()));
        enforce!AssertError(equal(range.save.asDecodedXML(), expected.byUTF!C), "unittest failed 2", __FILE__, line);
    }

    static foreach(func; testRangeFuncs)
    {{
        test!func("hello world &amp;  &gt;  &lt;  &apos;  &quot; \r\r\r\r\r foo", `hello world &  >  <  '  "  foo`);
        test!func("&amp", "&amp");
        test!func("&#01234567890;", "&#01234567890;");
        test!func("&", "&");
        test!func("&&&&", "&&&&");
        test!func("&&&&amp;", "&&&&");
        test!func("&#", "&#");
        test!func("&#;", "&#;");
        test!func("&#0", "&#0");
        test!func("&#0;", "&#0;");
        test!func("&#48;", "0");
        test!func("&#0amp;", "&#0amp;");
        test!func("&#amp;", "&#amp;");
        test!func("&#x", "&#x");
        test!func("&#x;", "&#x;");
        test!func("&#x0;", "&#x0;");
        test!func("&#x9;", "\t");
        test!func("&#x20;", " ");
        test!func("&#12487;&#12451;&#12521;&#12531;", "ディラン");
    }}
}

@safe pure unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {{
        assert(decodeXML(func("foo")) == "foo");
        assert(equal(asDecodedXML(func("foo")), "foo"));
    }}
}


/++
    This parses one of the five, predefined entity references mention in the XML
    spec from the front of a range of characters.

    If the given range starts with one of the five, predefined entity
    references, then it is removed from the range, and the corresponding
    character is returned.

    If the range does not start with one of those references, then the return
    value is null, and the range is unchanged.

    $(TABLE
        $(TR $(TH Std Entity Ref)$(TH Converts To))
        $(TR $(TD $(D_CODE_STRING $(AMP)amp;))$(TD $(D_CODE_STRING &)))
        $(TR $(TD $(D_CODE_STRING $(AMP)gt;))$(TD $(D_CODE_STRING >)))
        $(TR $(TD $(D_CODE_STRING $(AMP)lt;))$(TD $(D_CODE_STRING $(LT))))
        $(TR $(TD $(D_CODE_STRING $(AMP)apos;))$(TD $(D_CODE_STRING ')))
        $(TR $(TD $(D_CODE_STRING $(AMP)quot;))$(TD $(D_CODE_STRING ")))
    )

    Any other entity references would require processing a DTD section in order
    to be handled and are untouched by parseStdEntityRef as are any other types
    of references.

    Params:
        range = A range of characters.

    Returns: The character represented by the predefined entity reference that
             was parsed from the front of the given range or null if the range
             did not start with one of the five predefined entity references.

    See_Also: $(LINK http://www.w3.org/TR/REC-xml/#dt-chardata)$(BR)
              $(LREF parseCharRef)$(BR)
              $(LREF decodeXML)$(BR)
              $(LREF asDecodedXML)
  +/
Nullable!dchar parseStdEntityRef(R)(ref R range)
    if(isForwardRange!R && isSomeChar!(ElementType!R))
{
    import std.algorithm.searching : startsWith;
    import std.typecons : nullable, tuple;
    import std.utf : byCodeUnit;

    auto orig = range.save;

    static if(isNarrowString!R)
        auto cuRange = range.byCodeUnit();
    else
        alias cuRange = range;

    if(!cuRange.save.startsWith('&'))
        return typeof(return).init;
    cuRange.popFront();

    if(cuRange.empty)
        goto invalid;

    static foreach(t; [tuple("amp;", '&'), tuple("gt;", '>'), tuple("lt;", '<'),
                       tuple("apos;", '\''), tuple("quot;", '"')])
    {
        if(cuRange.save.startsWith(t[0]))
        {
            cuRange.popFrontN(t[0].length);
            static if(isNarrowString!R)
                range = cuRange.source;
            return nullable(cast(dchar)t[1]);
        }
    }

    invalid: range = orig;
    return typeof(return).init;
}

///
unittest
{
    {
        auto range = "&amp;foo";
        assert(range.parseStdEntityRef() == '&');
        assert(range == "foo");
    }
    {
        auto range = "&gt;bar";
        assert(range.parseStdEntityRef() == '>');
        assert(range == "bar");
    }
    {
        auto range = "&lt;baz";
        assert(range.parseStdEntityRef() == '<');
        assert(range == "baz");
    }
    {
        auto range = "&apos;dlang";
        assert(range.parseStdEntityRef() == '\'');
        assert(range == "dlang");
    }
    {
        auto range = "&quot;rocks";
        assert(range.parseStdEntityRef() == '"');
        assert(range == "rocks");
    }
    {
        auto range = " &amp;foo";
        assert(range.parseStdEntityRef().isNull);
        assert(range == " &amp;foo");
    }
    {
        auto range = "&Amp;hello";
        assert(range.parseStdEntityRef().isNull);
        assert(range == "&Amp;hello");
    }
    {
        auto range = "&nbsp;foo";
        assert(range.parseStdEntityRef().isNull);
        assert(range == "&nbsp;foo");
    }
    {
        auto range = "hello world";
        assert(range.parseStdEntityRef().isNull);
        assert(range == "hello world");
    }
}

unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {
        for(auto range = func(";Amp;amp;&#amp;&copy;& amp;"); !range.empty; range.popFront())
        {
            auto temp = range.save;
            assert(temp.parseStdEntityRef().isNull);
            assert(equal(range.save, temp.save));
        }
        {
            auto range = func("&amp");
            assert(range.parseStdEntityRef().isNull);
            assert(equal(range.save, "&amp"));
        }
        {
            auto range = func(" &amp;&gt;&lt;&apos;&quot;");
            assert(range.parseStdEntityRef().isNull);
            assert(equal(range.save, " &amp;&gt;&lt;&apos;&quot;"));
            range.popFront();

            assert(range.parseStdEntityRef() == '&');
            assert(equal(range.save, "&gt;&lt;&apos;&quot;"));
            assert(range.parseStdEntityRef() == '>');
            assert(equal(range.save, "&lt;&apos;&quot;"));
            assert(range.parseStdEntityRef() == '<');
            assert(equal(range.save, "&apos;&quot;"));
            assert(range.parseStdEntityRef() == '\'');
            assert(equal(range.save, "&quot;"));
            assert(range.parseStdEntityRef() == '"');
            assert(range.empty);
        }
    }
}

@safe pure unittest
{
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {{
        auto range = func("foo");
        assert(range.parseStdEntityRef().isNull);
    }}
}


/++
    If the given range starts with a valid, XML, character reference, it is
    removed from the range, and the corresponding character is returned.

    If the range does not start with a valid, XML, character reference, then
    the return value is null, and the range is unchanged.

    Params:
        range = A range of characters.

    Returns: The character represented by the character reference that was
             parsed from the front of the given range or null if the range did
             not start with a valid, XML, character reference.

    See_Also: $(LINK http://www.w3.org/TR/REC-xml/#NT-CharRef)$(BR)
              $(LREF parseStdEntityRef)$(BR)
              $(LREF decodeXML)$(BR)
              $(LREF asDecodedXML)$(BR)
              $(LREF encodeCharRef)
  +/
Nullable!dchar parseCharRef(R)(ref R range)
    if(isForwardRange!R && isSomeChar!(ElementType!R))
{
    import std.algorithm.searching : startsWith;
    import std.conv : ConvException, parse, to;
    import std.range : popFrontN;
    import std.typecons : nullable;
    import std.utf : byCodeUnit;
    import qt.widgets.internal.dxml.internal : isXMLChar;

    auto orig = range.save;

    static if(isNarrowString!R)
        auto cuRange = range.byCodeUnit();
    else
        alias cuRange = range;

    if(!cuRange.save.startsWith("&#"))
        return typeof(return).init;
    cuRange.popFrontN(2);

    if(cuRange.empty)
        goto invalid;

    {
        bool hex = false;
        if(cuRange.front == 'x')
        {
            cuRange.popFront();
            hex = true;
            // https://issues.dlang.org/show_bug.cgi?id=18248
            import std.ascii : isHexDigit;
            if(cuRange.empty || !isHexDigit(cuRange.front))
                goto invalid;
        }
        try
        {
            immutable c = to!dchar(cuRange.parse!uint(hex ? 16 : 10));
            if(!cuRange.startsWith(';') || (c != '\n' && !isXMLChar(c)))
                goto invalid;
            cuRange.popFront();
            static if(isNarrowString!R)
                range = cuRange.source;
            return nullable(cast()c);
        }
        catch(ConvException)
        {}
    }

    invalid: range = orig;
    return typeof(return).init;
}

///
unittest
{
    import std.range.primitives : empty;

    {
        auto range = "&#48; hello world";
        assert(parseCharRef(range) == '0');
        assert(range == " hello world");
    }
    {
        auto range = "&#x30; hello world";
        assert(parseCharRef(range) == '0');
        assert(range == " hello world");
    }
    {
        auto range = "&#12487;&#12451;&#12521;&#12531;";
        assert(parseCharRef(range) == 'デ');
        assert(range == "&#12451;&#12521;&#12531;");
        assert(parseCharRef(range) == 'ィ');
        assert(range == "&#12521;&#12531;");
        assert(parseCharRef(range) == 'ラ');
        assert(range == "&#12531;");
        assert(parseCharRef(range) == 'ン');
        assert(range.empty);
    }
    {
        auto range = "&#x;foo";
        assert(parseCharRef(range).isNull);
        assert(range == "&#x;foo");
    }
    {
        auto range = "foobar";
        assert(parseCharRef(range).isNull);
        assert(range == "foobar");
    }
    {
        auto range = " &x48;";
        assert(parseCharRef(range).isNull);
        assert(range == " &x48;");
    }
}

unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {
        for(auto range = func(";;&#;&#G;&#1234567890;&#F;"); !range.empty; range.popFront())
        {
            auto temp = range.save;
            assert(temp.parseCharRef().isNull);
            assert(equal(range.save, temp.save));
        }
        {
            auto range = func("&#65");
            assert(range.parseCharRef().isNull);
            assert(equal(range.save, "&#65"));
        }
        {
            auto range = func(" &#65;&#x42;&#67; &#x4EAC;&#x90FD;&#x5E02;");
            assert(range.parseCharRef().isNull);
            assert(equal(range.save, " &#65;&#x42;&#67; &#x4EAC;&#x90FD;&#x5E02;"));
            range.popFront();

            assert(range.parseCharRef() == 'A');
            assert(equal(range.save, "&#x42;&#67; &#x4EAC;&#x90FD;&#x5E02;"));
            assert(range.parseCharRef() == 'B');
            assert(equal(range.save, "&#67; &#x4EAC;&#x90FD;&#x5E02;"));
            assert(range.parseCharRef() == 'C');
            assert(equal(range.save, " &#x4EAC;&#x90FD;&#x5E02;"));

            assert(range.parseCharRef().isNull);
            assert(equal(range.save, " &#x4EAC;&#x90FD;&#x5E02;"));
            range.popFront();

            assert(range.parseCharRef() == '京');
            assert(equal(range.save, "&#x90FD;&#x5E02;"));
            assert(range.parseCharRef() == '都');
            assert(equal(range.save, "&#x5E02;"));
            assert(range.parseCharRef() == '市');
            assert(range.empty);
        }
    }
}

@safe pure unittest
{
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {{
        auto range = func("foo");
        assert(range.parseCharRef().isNull);
    }}
}


/++
    Strips the indent from a character range (most likely from
    $(REF_ALTTEXT Entity.text, EntityRange.Entity.text, dxml, parser)).
    The idea is that if the XML is formatted to be human-readable, and it's
    multiple lines long, the lines are likely to be indented, but the
    application probably doesn't want that extra whitespace. So, stripIndent
    and withoutIndent attempt to intelligently strip off the leading
    whitespace.

    For these functions, whitespace is considered to be some combination of
    $(D_CODE_STRING ' '), $(D_CODE_STRING '\t'), and $(D_CODE_STRING '\r')
    ($(D_CODE_STRING '\n') is used to delineate lines, so it's not considered
     whitespace).

    Whitespace characters are stripped from the start of the first line, and
    then those same number of whitespace characters are stripped from the
    beginning of each subsequent line (or up to the first non-whitespace
    character if the line starts with fewer whitespace characters).

    If the first line has no leading whitespace, then the leading whitespace on
    the second line is treated as the indent. This is done to handle case where
    there is text immediately after a start tag and then subsequent lines are
    indented rather than the text starting on the line after the start tag.

    If neither of the first two lines has any leading whitespace, then no
    whitespace is stripped.

    So, if the text is well-formatted, then the indent should be cleanly
    removed, and if it's unformatted or badly formatted, then no characters
    other than leading whitespace will be removed, and in principle, no real
    data will have been lost - though of course, it's up to the programmer to
    decide whether it's better for the application to try to cleanly strip the
    indent or to leave the text as-is.

    The difference between stripIndent and withoutIndent is that stripIndent
    returns a $(K_STRING), whereas withoutIndent returns a lazy range
    of code units. In the case where a $(K_STRING) is passed to
    stripIndent, it will simply return the original string if there is no
    indent (whereas in other cases, stripIndent and withoutIndent are forced to
    return new ranges).

    Params:
        range = A range of characters.

    Returns: The text with the indent stripped from each line. stripIndent
             returns a $(K_STRING), whereas withoutIndent returns a lazy range
             of code units (so it could be a range of $(K_CHAR) or $(K_WCHAR)
             and not just $(K_DCHAR); which it is depends on the code units of
             the range being passed in).

    See_Also: $(REF EntityRange.Entity.text, dxml, parser)
  +/
string stripIndent(R)(R range)
    if(isForwardRange!R && isSomeChar!(ElementType!R))
{
    import std.conv : to;

    static if(isDynamicArray!R && is(Unqual!(ElementEncodingType!R) == char))
    {
        static bool notHWhite(char c)
        {
            switch(c)
            {
                case ' ':
                case '\t':
                case '\r': return false;
                default : return true;
            }
        }

        import std.algorithm.searching : find;
        import std.utf : byCodeUnit;

        if(range.empty)
            return range.to!string();

        auto orig = range.save;
        auto text = range.byCodeUnit();
        ElementEncodingType!R[] firstLine;

        if(notHWhite(text.front))
        {
            text = text.find('\n');
            if(text.empty)
                return orig.to!string();
            text.popFront();
            firstLine = orig[0 .. orig.length - text.length];
        }

        immutable beforeIndent = text.length;
        text = text.find!notHWhite();
        if(text.empty)
            return firstLine.empty ? "" : firstLine[0 .. $ - 1].to!string();
        immutable indent = beforeIndent - text.length;

        if(indent == 0)
            return orig.to!string();

        import std.array : appender;
        auto retval = appender!string();
        retval.reserve(orig.length / 3);

        // > 1 because we don't want a newline by itself.
        if(firstLine.length > 1)
            put(retval, firstLine);

        outer: while(true)
        {
            auto start = text.save;
            text = text.find('\n');
            if(text.empty)
            {
                if(!start.empty)
                    put(retval, start);
                return retval.data;
            }
            text.popFront();
            auto line = start[0 .. $ - text.length];
            foreach(_; 0 .. indent)
            {
                if(text.empty)
                    goto isEmpty;
                if(notHWhite(text.front))
                    goto notEmpty;
                text.popFront();
            }
            if(text.empty)
            {
                isEmpty: put(retval, line[0 .. $ - 1]);
                return retval.data;
            }
            notEmpty: put(retval, line);
        }
        // The compiler is not smart enough to realize that this line is unreachable.
        assert(0);
    }
    else
        return range.withoutIndent().to!string();
}

/// Ditto
auto withoutIndent(R)(R range)
    if(isForwardRange!R && isSomeChar!(ElementType!R))
{
    import std.utf : byCodeUnit;

    static struct WithoutIndent
    {
    public:

        @property empty() { return _line.empty; }

        @property front() { return _line.front; }

        void popFront()
        {
            if(_indent == 0)
            {
                _line.popFront();
                return;
            }

            if(_line.front == '\n')
                _nextLine();
            else
                _line.popFront();
            // Skip last newline
            if(_range.empty && !_line.empty && _line.front == '\n')
                _line = _range;
        }

        @property save()
        {
            auto retval = this;
            retval._line = _line.save;
            retval._range = _range.save;
            return retval;
        }

    private:

        static bool notHWhite(ElementEncodingType!R c)
        {
            switch(c)
            {
                case ' ':
                case '\t':
                case '\r': return false;
                default : return true;
            }
        }

        void _nextLine()
        {
            import std.algorithm.searching : find;
            _line = _range.save;
            _range = _range.find('\n');
            if(_range.empty)
                return;
            _range.popFront();
            _popIndent();
        }

        void _popIndent()
        {
            foreach(_; 0 .. _indent)
            {
                if(_range.empty)
                    return;
                if(notHWhite(_range.front))
                    return;
                _range.popFront();
            }
        }

        this(R range)
        {
            import std.algorithm : countUntil, find;
            import std.range : popFrontN;

            _range = byCodeUnit(range);
            if(_range.empty)
            {
                _line = _range;
                return;
            }

            auto orig = _range.save;
            immutable noFirstIndent = notHWhite(_range.front);
            if(noFirstIndent)
            {
                _range = _range.find('\n');
                if(_range.empty)
                    goto noIndent;
                _range.popFront();
            }

            _indent = _range.save.countUntil!(a => notHWhite(a))();
            if(_indent == 0)
            {
                noIndent: _line = orig;
                return;
            }
            if(noFirstIndent && orig.front != '\n')
            {
                _range = orig;
                _popIndent();
            }
            else
                _range.popFrontN(_indent);
            _nextLine();
        }

        typeof(byCodeUnit(R.init)) _range;
        typeof(byCodeUnit(R.init)) _line;
        size_t _indent;
    }

    return WithoutIndent(range);
}

///
unittest
{
    import std.algorithm.comparison : equal;

    // The prime use case for these two functions is for an Entity.text section
    // that is formatted to be human-readable, and the rules of what whitespace
    // is stripped from the beginning or end of the range are geared towards
    // the text coming from a well-formatted Entity.text section.
    {
        import qt.widgets.internal.dxml.parser;
        auto xml = "<root>\n" ~
                   "    <code>\n" ~
                   "    bool isASCII(string str)\n" ~
                   "    {\n" ~
                   "        import std.algorithm : all;\n" ~
                   "        import std.ascii : isASCII;\n" ~
                   "        return str.all!isASCII();\n" ~
                   "    }\n" ~
                   "    </code>\n" ~
                   "<root>";
        auto range = parseXML(xml);
        range.popFront();
        range.popFront();
        assert(range.front.type == EntityType.text);
        assert(range.front.text ==
               "\n" ~
               "    bool isASCII(string str)\n" ~
               "    {\n" ~
               "        import std.algorithm : all;\n" ~
               "        import std.ascii : isASCII;\n" ~
               "        return str.all!isASCII();\n" ~
               "    }\n" ~
               "    ");
        assert(range.front.text.stripIndent() ==
               "bool isASCII(string str)\n" ~
               "{\n" ~
               "    import std.algorithm : all;\n" ~
               "    import std.ascii : isASCII;\n" ~
               "    return str.all!isASCII();\n" ~
               "}");
    }

    // The indent that is stripped matches the amount of whitespace at the front
    // of the first line.
    assert(("    start\n" ~
            "    foo\n" ~
            "    bar\n" ~
            "        baz\n" ~
            "        xyzzy\n" ~
            "           ").stripIndent() ==
           "start\n" ~
           "foo\n" ~
           "bar\n" ~
           "    baz\n" ~
           "    xyzzy\n" ~
           "       ");

    // If the first line has no leading whitespace but the second line does,
    // then the second line's leading whitespace is treated as the indent.
    assert(("foo\n" ~
            "    bar\n" ~
            "        baz\n" ~
            "        xyzzy").stripIndent() ==
           "foo\n" ~
           "bar\n" ~
           "    baz\n" ~
           "    xyzzy");

    assert(("\n" ~
            "    foo\n" ~
            "    bar\n" ~
            "        baz\n" ~
            "        xyzzy").stripIndent() ==
           "foo\n" ~
           "bar\n" ~
           "    baz\n" ~
           "    xyzzy");

    // If neither of the first two lines has leading whitespace, then nothing
    // is stripped.
    assert(("foo\n" ~
            "bar\n" ~
            "    baz\n" ~
            "    xyzzy\n" ~
            "    ").stripIndent() ==
           "foo\n" ~
           "bar\n" ~
           "    baz\n" ~
           "    xyzzy\n" ~
           "    ");

    // If a subsequent line starts with less whitespace than the indent, then
    // all of its leading whitespace is stripped but no other characters are
    // stripped.
    assert(("      foo\n" ~
            "         bar\n" ~
            "   baz\n" ~
            "         xyzzy").stripIndent() ==
           "foo\n" ~
           "   bar\n" ~
           "baz\n" ~
           "   xyzzy");

    // If the last line is just the indent, then it and the newline before it
    // are stripped.
    assert(("    foo\n" ~
            "       bar\n" ~
            "    ").stripIndent() ==
           "foo\n" ~
           "   bar");

    // If the last line is just whitespace, but it's more than the indent, then
    // the whitespace after the indent is kept.
    assert(("    foo\n" ~
            "       bar\n" ~
            "       ").stripIndent() ==
           "foo\n" ~
           "   bar\n" ~
           "   ");

    // withoutIndent does the same as stripIndent but with a lazy range.
    assert(equal(("  foo\n" ~
                  "    bar\n" ~
                  "    baz\n").withoutIndent(),
                 "foo\n" ~
                 "  bar\n" ~
                 "  baz"));
}

unittest
{
    import core.exception : AssertError;
    import std.algorithm.comparison : equal;
    import std.exception : enforce;
    import std.utf : byUTF;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static void test(alias func)(string text, string expected, size_t line = __LINE__)
    {
        auto range = func(text);
        enforce!AssertError(range.save.stripIndent() == expected, "unittest failed 1", __FILE__, line);
        alias C = ElementType!(typeof(range.save.withoutIndent()));
        enforce!AssertError(equal(range.save.withoutIndent(), expected.byUTF!C), "unittest failed 2", __FILE__, line);
    }

    static foreach(func; testRangeFuncs)
    {
        test!func("", "");
        test!func("     ", "");
        test!func("foo", "foo");
        test!func("\nfoo", "\nfoo");
        test!func("    foo", "foo");
        test!func("\n    foo", "foo");
        test!func("\n    foo\n", "foo");
        test!func("\n    foo\n    ", "foo");
        test!func("\n    foo\n     ", "foo\n ");
        test!func("foo\n      ", "foo");

        test!func("  foo\n  bar  \n    baz", "foo\nbar  \n  baz");
        test!func("  foo\nbar\n  baz", "foo\nbar\nbaz");
        test!func("  foo\n bar\n  baz", "foo\nbar\nbaz");
        test!func("  foo\n  bar\n  baz", "foo\nbar\nbaz");
        test!func("  foo\n   bar\n  baz", "foo\n bar\nbaz");
        test!func("  foo\n    bar\n  baz", "foo\n  bar\nbaz");
        test!func("  foo\n     bar\n  baz", "foo\n   bar\nbaz");
        test!func("  foo\n     bar\n  baz\n\n\n\n\n", "foo\n   bar\nbaz\n\n\n\n");

        test!func("     foo\n  bar\n       baz", "foo\nbar\n  baz");

        test!func("foo\n     bar\n      baz", "foo\nbar\n baz");
        test!func("foo\nbar\n      baz\n", "foo\nbar\n      baz\n");
    }
}

@safe pure unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {{
        assert(stripIndent(func("foo")) == "foo");
        assert(equal(withoutIndent(func("foo")), "foo"));
    }}
}


/++
    The string representations of the five, entity references predefined by the
    XML spec.

    See_Also: $(LINK http://www.w3.org/TR/REC-xml/#dt-chardata)$(BR)
              $(LREF parseStdEntityRef)
  +/
enum StdEntityRef
{
    /// Entity reference for $(D_CODE_STRING $(AMP))
    amp = "&amp;",

    /// Entity reference for $(D_CODE_STRING >)
    gt = "&gt;",

    /// Entity reference for $(D_CODE_STRING <)
    lt = "&lt;",

    /// Entity reference for $(D_CODE_STRING ')
    apos = "&apos;",

    /// Entity reference for $(D_CODE_STRING ")
    quot = "&quot;",
}


/++
    Returns a lazy range of code units which encodes any characters which cannot
    be put in an $(REF EntityType._text, dxml, parser) in their literal form.

    encodeText is intended primarily to be used with
    $(REF XMLWriter.writeText, dxml, writer) to ensure that characters which
    cannot appear in their literal form do not appear in their literal form.

    Specifically, what encodeText does is

    $(TABLE
        $(TR $(TD convert $(D_CODE_STRING &) to $(D_CODE_STRING $(AMP)amp;) ))
        $(TR $(TD convert $(D_CODE_STRING <) to $(D_CODE_STRING $(AMP)lt;) ))
        $(TR $(TD convert $(D_CODE_STRING ]]>) to $(D_CODE_STRING ]]$(AMP)gt;) ))
    )

    See_Also: $(REF XMLWriter.writeText, dxml, writer)$(BR)
              $(LREF encodeAttr)$(BR)
              $(LREF decodeXML)$(BR)
              $(LREF asDecodedXML)
  +/
auto encodeText(R)(R text)
    if(isForwardRange!R && isSomeChar!(ElementType!R))
{
    import std.utf : byCodeUnit;

    static struct EncodeText
    {
    public:

        @property front() { return _len == 0 ? _text.front : cast(ElementEncodingType!R)_buffer[_len - 1]; }

        @property empty() { return _text.empty; }

        void popFront()
        {
            if(_len != 0)
            {
                if(--_len != 0)
                    return;
            }
            _text.popFront();
            _handleEntity();
        }

        @property save()
        {
            auto retval = this;
            retval._text = _text.save;
            return retval;
        }

    private:

        void _handleEntity()
        {
            if(_text.empty)
                return;
            switch(_text.front)
            {
                case '&':
                {
                    enum entity = ";pma&";
                    _buffer = entity;
                    _len = entity.length;
                    return;
                }
                case '<':
                {
                    enum entity = ";tl&";
                    _buffer = entity;
                    _len = entity.length;
                    return;
                }
                case ']':
                {
                    import std.range : dropOne;

                    // FIXME This should use startsWith, but for some reason,
                    // startsWith doesn't currently work with @nogc or nothrow
                    // even when this code should be able to be @nogc and/or
                    // nothrow.
                    auto temp = _text.save.dropOne();
                    if(!temp.empty && temp.front == ']')
                    {
                        temp.popFront();
                        if(!temp.empty && temp.front == '>')
                        {
                            _text = temp;
                            enum entity = ";tg&]]";
                            _buffer = entity;
                            _len = entity.length;
                        }
                    }
                    return;
                }
                default: return;
            }
        }

        this(R text)
        {
            _text = byCodeUnit(text);
            _handleEntity();
        }

        char["]]&gt;".length] _buffer;
        size_t _len;
        typeof(byCodeUnit(R.init)) _text;
    }

    return EncodeText(text);
}

///
@safe pure nothrow @nogc unittest
{
    import std.algorithm.comparison : equal;

    assert(equal(encodeText(`foo & bar`), `foo &amp; bar`));
    assert(equal(encodeText(`foo < bar`), `foo &lt; bar`));
    assert(equal(encodeText(`foo > bar`), `foo > bar`));
    assert(equal(encodeText(`foo ' bar`), `foo ' bar`));
    assert(equal(encodeText(`foo " bar`), `foo " bar`));
    assert(equal(encodeText("foo ]]> bar"), "foo ]]&gt; bar"));

    assert(equal(encodeText("hello world"), "hello world"));
}

@safe pure unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {{
        assert(encodeText(func("")).empty);
        assert(equal(encodeText(func(`& < > ' "`)), `&amp; &lt; > ' "`));
        assert(equal(encodeText(func("&&&")), "&amp;&amp;&amp;"));

        auto range = encodeText(func(`&&<<>>''""hello ] ]> world"">><<&&`));
        assert(equal(range.save, range.save));
        assert(equal(range.save, `&amp;&amp;&lt;&lt;>>''""hello ] ]> world"">>&lt;&lt;&amp;&amp;`));
    }}
}


/++
    Returns a lazy range of code units which encodes any characters which cannot
    be put in an attribute value of an element tag in their literal form.

    encodeAttr is intended primarily to be used with
    $(REF XMLWriter.writeAttr, dxml, writer) to ensure that characters
    which cannot appear in their literal form do not appear in their literal
    form.

    Specifically, what encodeAttr does is

    $(TABLE
        $(TR $(TD convert $(D_CODE_STRING &) to $(D_CODE_STRING $(AMP)amp;) ))
        $(TR $(TD convert $(D_CODE_STRING <) to $(D_CODE_STRING $(AMP)lt;) ))
        $(TR $(TD convert $(D_CODE_STRING ') to $(D_CODE_STRING $(AMP)pos;) if
              $(D quote == $(D_STRING '\''))))
        $(TR $(TD convert $(D_CODE_STRING ") to $(D_CODE_STRING $(AMP)quot;) if
              $(D quote == $(D_STRING '"'))))
    )

    See_Also: $(REF XMLWriter.writeAttr, dxml, writer)$(BR)
              $(LREF encodeText)$(BR)
              $(LREF decodeXML)$(BR)
              $(LREF asDecodedXML)
  +/
auto encodeAttr(char quote = '"', R)(R text)
    if((quote == '"' || quote == '\'') && isForwardRange!R && isSomeChar!(ElementType!R))
{
    import std.utf : byCodeUnit;

    static struct EncodeAttr
    {
    public:

        @property front() { return _len == 0 ? _text.front : cast(ElementEncodingType!R)_buffer[_len - 1]; }

        @property empty() { return _text.empty; }

        void popFront()
        {
            if(_len != 0)
            {
                if(--_len != 0)
                    return;
            }
            _text.popFront();
            _handleEntity();
        }

        @property save()
        {
            auto retval = this;
            retval._text = _text.save;
            return retval;
        }

    private:

        void _handleEntity()
        {
            if(_text.empty)
                return;
            switch(_text.front)
            {
                case '&':
                {
                    enum entity = ";pma&";
                    _buffer = entity;
                    _len = entity.length;
                    return;
                }
                case '<':
                {
                    enum entity = ";tl&";
                    _buffer = entity;
                    _len = entity.length;
                    return;
                }
                case quote:
                {
                    static if(quote == '"')
                        enum entity = ";touq&";
                    else
                        enum entity = ";sopa&";
                    _buffer = entity;
                    _len = entity.length;
                    return;
                }
                default: return;
            }
        }

        this(R text)
        {
            _text = byCodeUnit(text);
            _handleEntity();
        }

        char["&quot;".length] _buffer;
        size_t _len;
        typeof(byCodeUnit(R.init)) _text;
    }

    return EncodeAttr(text);
}

///
@safe pure nothrow @nogc unittest
{
    import std.algorithm.comparison : equal;

    assert(equal(encodeAttr(`foo & bar`), `foo &amp; bar`));
    assert(equal(encodeAttr(`foo < bar`), `foo &lt; bar`));
    assert(equal(encodeAttr(`foo > bar`), `foo > bar`));
    assert(equal(encodeAttr(`foo ' bar`), `foo ' bar`));
    assert(equal(encodeAttr(`foo " bar`), `foo &quot; bar`));

    assert(equal(encodeAttr!'\''(`foo ' bar`), `foo &apos; bar`));
    assert(equal(encodeAttr!'\''(`foo " bar`), `foo " bar`));

    assert(equal(encodeAttr("hello world"), "hello world"));
}

@safe pure unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {{
        assert(encodeAttr(func("")).empty);
        assert(encodeAttr!'\''(func("")).empty);
        assert(equal(encodeAttr(func(`& < > ' "`)), `&amp; &lt; > ' &quot;`));
        assert(equal(encodeAttr!'\''(func(`& < > ' "`)), `&amp; &lt; > &apos; "`));
        assert(equal(encodeAttr(func("&&&")), "&amp;&amp;&amp;"));

        {
            auto range = encodeAttr(func(`&&<<>>''""hello world"">><<&&`));
            assert(equal(range.save, range.save));
            assert(equal(range.save, `&amp;&amp;&lt;&lt;>>''&quot;&quot;hello world&quot;&quot;>>&lt;&lt;&amp;&amp;`));
        }

        {
            auto range = encodeAttr!'\''(func(`&&<<>>''""hello world"">><<&&`));
            assert(equal(range.save, range.save));
            assert(equal(range.save, `&amp;&amp;&lt;&lt;>>&apos;&apos;""hello world"">>&lt;&lt;&amp;&amp;`));
        }
    }}
}


/++
    Returns a range of $(K_CHAR) containing the character reference
    corresponding to the given character.

    Params:
        c = The character to encode.

    See_Also: $(LREF parseCharRef)
  +/
auto encodeCharRef(dchar c)
{
    static struct EncodeCharRef
    {
    public:

        @property front() { return _buffer[_index]; }

        @property empty() { return _buffer[_index] == '$'; }

        void popFront() { ++_index; }

        @property save() { return this; }

    private:

        import std.conv : to;

        char[to!string(cast(uint)dchar.max).length + 5] _buffer;
        size_t _index;
    }

    import std.format : formattedWrite;
    import std.string : representation;

    EncodeCharRef retval;
    formattedWrite!"&#x%x;$"(retval._buffer[].representation, c);
    return retval;
}

///
unittest
{
    import std.algorithm.comparison : equal;

    assert(equal(encodeCharRef(' '), "&#x20;"));
    assert(equal(encodeCharRef('A'), "&#x41;"));
    assert(equal(encodeCharRef('\u2424'), "&#x2424;"));

    auto range = encodeCharRef('*');
    assert(parseCharRef(range) == '*');
}

unittest
{
    import std.algorithm.comparison : equal;

    enum pound = "&#x23;";
    auto range = encodeCharRef('#');
    assert(equal(range.save, range.save));
    assert(equal(range.save, pound));
}
