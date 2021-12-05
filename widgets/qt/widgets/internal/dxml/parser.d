// Written in the D programming language

/++
    This implements a range-based
    $(LINK2 https://en.wikipedia.org/wiki/StAX, StAX _parser) for XML 1.0 (which
    will work with XML 1.1 documents assuming that they don't use any
    1.1-specific features). For the sake of simplicity, sanity, and efficiency,
    the $(LINK2 https://en.wikipedia.org/wiki/Document_type_definition, DTD)
    section is not supported beyond what is required to parse past it.

    Start tags, end tags, comments, cdata sections, and processing instructions
    are all supported and reported to the application. Anything in the DTD is
    skipped (though it's parsed enough to parse past it correctly, and that
    $(I can) result in an $(LREF XMLParsingException) if that XML isn't valid
    enough to be correctly skipped), and the
    $(LINK2 http://www.w3.org/TR/REC-xml/#NT-XMLDecl, XML declaration) at the
    top is skipped if present (XML 1.1 requires that it be there, but XML 1.0
    does not).

    Regardless of what the XML declaration says (if present), any range of
    $(K_CHAR) will be treated as being encoded in UTF-8, any range of $(K_WCHAR)
    will be treated as being encoded in UTF-16, and any range of $(K_DCHAR) will
    be treated as having been encoded in UTF-32. Strings will be treated as
    ranges of their code units, not code points.

    Since the DTD is skipped, entity references other than the five which are
    predefined by the XML spec cannot be fully processed (since wherever they
    were used in the document would be replaced by what they referred to, which
    could be arbitrarily complex XML). As such, by default, if any entity
    references which are not predefined are encountered outside of the DTD, an
    $(LREF XMLParsingException) will be thrown (see
    $(LREF Config.throwOnEntityRef) for how that can be configured). The
    predefined entity references and any character references encountered will
    be checked to verify that they're valid, but they will not be replaced
    (since that does not work with returning slices of the original input).

    However, $(REF_ALTTEXT decodeXML, decodeXML, dxml, util) or
    $(REF_ALTTEXT parseStdEntityRef, parseStdEntityRef, dxml, util) from
    $(MREF dxml, util) can be used to convert the predefined entity references
    to what the refer to, and $(REF_ALTTEXT decodeXML, decodeXML, dxml, util) or
    $(REF_ALTTEXT parseCharRef, parseCharRef, dxml, util) from
    $(MREF dxml, util) can be used to convert character references to what they
    refer to.

    $(H3 Primary Symbols)
    $(TABLE
        $(TR $(TH Symbol) $(TH Description))
        $(TR $(TD $(LREF parseXML))
             $(TD The function used to initiate the parsing of an XML
                  document.))
        $(TR $(TD $(LREF EntityRange))
             $(TD The range returned by $(LREF parseXML).))
        $(TR $(TD $(LREF EntityRange.Entity))
             $(TD The element type of $(LREF EntityRange).))
    )

    $(H3 Parser Configuration Helpers)
    $(TABLE
        $(TR $(TH Symbol) $(TH Description))
        $(TR $(TD $(LREF Config))
             $(TD Used to configure how $(LREF EntityRange) parses the XML.))
        $(TR $(TD $(LREF simpleXML))
             $(TD A user-friendly configuration for when the application just
                  wants the element tags and the data in between them.))
        $(TR $(TD $(LREF makeConfig))
             $(TD A convenience function for constructing a custom
                  $(LREF Config).))
        $(TR $(TD $(LREF SkipComments))
             $(TD A $(PHOBOS_REF Flag, std, typecons) used with $(LREF Config)
                  to tell the parser to skip comments.))
        $(TR $(TD $(LREF SkipPI))
             $(TD A $(PHOBOS_REF Flag, std, typecons) used with $(LREF Config)
                  to tell the parser to skip processing instructions.))
        $(TR $(TD $(LREF SplitEmpty))
             $(TD A $(PHOBOS_REF Flag, std, typecons) used with $(LREF Config)
                  to configure how the parser deals with empty element tags.))
    )

    $(H3 Helper Types Used When Parsing)
    $(TABLE
        $(TR $(TH Symbol) $(TH Description))
        $(TR $(TD $(LREF EntityType))
             $(TD The type of an entity in the XML (e.g. a
                  $(LREF_ALTTEXT start tag, EntityType.elementStart) or a
                  $(LREF_ALTTEXT comment, EntityType.comment)).))
        $(TR $(TD $(LREF TextPos))
             $(TD Gives the line and column number in the XML document.))
        $(TR $(TD $(LREF XMLParsingException))
             $(TD Thrown by $(LREF EntityRange) when it encounters invalid
                  XML.))
    )

    $(H3 Helper Functions Used When Parsing)
    $(TABLE
        $(TR $(TH Symbol) $(TH Description))
        $(TR $(TD $(LREF getAttrs))
             $(TD A function similar to $(PHOBOS_REF getopt, std, getopt) which
                  allows for the easy processing of start tag attributes.))
        $(TR $(TD $(LREF skipContents))
             $(TD Iterates an $(LREF EntityRange) from a start tag to its
                  matching end tag.))
        $(TR $(TD $(LREF skipToPath))
             $(TD Used to navigate from one start tag to another as if the start
                  tag names formed a file path.))
        $(TR $(TD $(LREF skipToEntityType))
             $(TD Skips to the next entity of the given type in the range.))
        $(TR $(TD $(LREF skipToParentEndTag))
             $(TD Iterates an $(LREF EntityRange) until it reaches the end tag
                  that matches the start tag which is the parent of the
                  current entity.))
    )

    $(H3 Helper Traits)
    $(TABLE
        $(TR $(TH Symbol) $(TH Description))
        $(TR $(TD $(LREF isAttrRange))
             $(TD Whether the given range is a range of attributes.)))

    Copyright: Copyright 2017 - 2020
    License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
    Authors:   $(HTTPS jmdavisprog.com, Jonathan M Davis)
    Source:    $(LINK_TO_SRC dxml/_parser.d)

    See_Also: $(LINK2 http://www.w3.org/TR/REC-xml/, Official Specification for XML 1.0)
  +/
module qt.widgets.internal.dxml.parser;

///
unittest
{
    auto xml = "<!-- comment -->\n" ~
               "<root>\n" ~
               "    <foo>some text<whatever/></foo>\n" ~
               "    <bar/>\n" ~
               "    <baz></baz>\n" ~
               "</root>";
    {
        auto range = parseXML(xml);
        assert(range.front.type == EntityType.comment);
        assert(range.front.text == " comment ");
        range.popFront();

        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "root");
        range.popFront();

        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "foo");
        range.popFront();

        assert(range.front.type == EntityType.text);
        assert(range.front.text == "some text");
        range.popFront();

        assert(range.front.type == EntityType.elementEmpty);
        assert(range.front.name == "whatever");
        range.popFront();

        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "foo");
        range.popFront();

        assert(range.front.type == EntityType.elementEmpty);
        assert(range.front.name == "bar");
        range.popFront();

        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "baz");
        range.popFront();

        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "baz");
        range.popFront();

        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "root");
        range.popFront();

        assert(range.empty);
    }
    {
        auto range = parseXML!simpleXML(xml);

        // simpleXML skips comments

        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "root");
        range.popFront();

        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "foo");
        range.popFront();

        assert(range.front.type == EntityType.text);
        assert(range.front.text == "some text");
        range.popFront();

        // simpleXML splits empty element tags into a start tag and end tag
        // so that the code doesn't have to care whether a start tag with no
        // content is an empty tag or a start tag and end tag with nothing but
        // whitespace in between.
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "whatever");
        range.popFront();

        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "whatever");
        range.popFront();

        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "foo");
        range.popFront();

        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "bar");
        range.popFront();

        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "bar");
        range.popFront();

        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "baz");
        range.popFront();

        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "baz");
        range.popFront();

        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "root");
        range.popFront();

        assert(range.empty);
    }
}


import std.range.primitives;
import std.traits;
import std.typecons : Flag;


/++
    The exception type thrown when the XML parser encounters invalid XML.
  +/
class XMLParsingException : Exception
{
    /++
        The position in the XML input where the problem is.
      +/
    TextPos pos;

package:

    this(string msg, TextPos textPos, string file = __FILE__, size_t line = __LINE__) @safe pure
    {
        import std.format : format;
        super(format!"[%s:%s]: %s"(textPos.line, textPos.col, msg), file, line);
        pos = textPos;
    }
}


/++
    Where in the XML document an entity is.

    The line and column numbers are 1-based.

    The primary use case for TextPos is $(LREF XMLParsingException), but an
    application may have other uses for it. The TextPos for an
    $(LREF2 Entity, EntityRange) can be obtained from
    $(LREF2 Entity.pos, EntityRange).

    See_Also: $(LREF XMLParsingException.pos)$(BR)
              $(LREF EntityRange.Entity.pos)
  +/
struct TextPos
{
    /// A line number in the XML file.
    int line = 1;

    /++
        A column number in a line of the XML file.

        Each code unit is considered a column, so depending on what a program
        is looking to do with the column number, it may need to examine the
        actual text on that line and calculate the number that represents
        what the program wants to display (e.g. the number of graphemes).
      +/
    int col = 1;
}


/++
    Used to configure how the parser works.

    See_Also:
        $(LREF makeConfig)$(BR)
        $(LREF parseXML)$(BR)
        $(LREF simpleXML)
  +/
struct Config
{
    /++
        Whether the comments should be skipped while parsing.

        If $(D skipComments == SkipComments.yes), any entities of type
        $(LREF EntityType.comment) will be omitted from the parsing results,
        and they will not be validated beyond what is required to parse past
        them.

        Defaults to $(D SkipComments.no).
      +/
    auto skipComments = SkipComments.no;

    /++
        Whether processing instructions should be skipped.

        If $(D skipPI == SkipPI.yes), any entities of type
        $(LREF EntityType.pi) will be skipped, and they will not be validated
        beyond what is required to parse past them.

        Defaults to $(D SkipPI.no).
      +/
    auto skipPI = SkipPI.no;

    /++
        Whether the parser should report empty element tags as if they were a
        start tag followed by an end tag with nothing in between.

        If $(D splitEmpty == SplitEmpty.yes),  then whenever an
        $(LREF EntityType.elementEmpty) is encountered, the parser will claim
        that that entity is an $(LREF EntityType.elementStart), and then it
        will provide an $(LREF EntityType.elementEnd) as the next entity before
        the entity that actually follows it.

        The purpose of this is to simplify the code using the parser, since most
        code does not care about the difference between an empty tag and a start
        and end tag with nothing in between. But since some code may care about
        the difference, the behavior is configurable.

        Defaults to $(D SplitEmpty.no).
      +/
    auto splitEmpty = SplitEmpty.no;

    ///
    unittest
    {
        enum configSplitYes = makeConfig(SplitEmpty.yes);

        {
            auto range = parseXML("<root></root>");
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "root");
            range.popFront();
            assert(range.front.type == EntityType.elementEnd);
            assert(range.front.name == "root");
            range.popFront();
            assert(range.empty);
        }
        {
            // No difference if the tags are already split.
            auto range = parseXML!configSplitYes("<root></root>");
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "root");
            range.popFront();
            assert(range.front.type == EntityType.elementEnd);
            assert(range.front.name == "root");
            range.popFront();
            assert(range.empty);
        }
        {
            // This treats <root></root> and <root/> as distinct.
            auto range = parseXML("<root/>");
            assert(range.front.type == EntityType.elementEmpty);
            assert(range.front.name == "root");
            range.popFront();
            assert(range.empty);
        }
        {
            // This is parsed as if it were <root></root> insead of <root/>.
            auto range = parseXML!configSplitYes("<root/>");
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "root");
            range.popFront();
            assert(range.front.type == EntityType.elementEnd);
            assert(range.front.name == "root");
            range.popFront();
            assert(range.empty);
        }
    }

    /++
        Whether the parser should throw when it encounters any entity references
        other than the five entity references defined in the XML standard.

        Any other entity references would have to be defined in the DTD in
        order to be valid. And in order to know what XML they represent (which
        could be arbitrarily complex, even effectively inserting entire XML
        documents into the middle of the XML), the DTD would have to be parsed.
        However, dxml does not support parsing the DTD beyond what is required
        to correctly parse past it, and replacing entity references with what
        they represent would not work with the slicing semantics that
        $(LREF EntityRange) provides. As such, it is not possible for dxml to
        correctly handle any entity references other than the five which are
        defined in the XML standard, and even those are only parsed by using
        $(REF decodeXML, dxml, util) or $(REF parseStdEntityRef, dxml, util).
        $(LREF EntityRange) always validates that entity references are one
        of the five, predefined entity references, but otherwise, it lets them
        pass through as normal text. It does not replace them with what they
        represent.

        As such, the default behavior of $(LREF EntityRange) is to throw an
        $(LREF XMLParsingException) when it encounters an entity reference
        which is not one of the five defined by the XML standard. With that
        behavior, there is no risk of processing an XML document as if it had
        no entity references and ending up with what the program using the
        parser would probably consider incorrect results. However, there are
        cases where a program may find it acceptable to treat entity references
        as normal text and ignore them. As such, if a program wishes to take
        that approach, it can set throwOnEntityRef to $(D ThrowOnEntityRef.no).

        If $(D throwOnEntityRef == ThrowOnEntityRef.no), then any entity
        reference that it encounters will be validated to ensure that it is
        syntactically valid (i.e. that the characters it contains form what
        could be a valid entity reference assuming that the DTD declared it
        properly), but otherwise, $(LREF EntityRange) will treat it as normal
        text, just like it treats the five, predefined entity references as
        normal text.

        Note that any valid XML entity reference which contains start or end
        tags must contain matching start or end tags, and entity references
        cannot contain incomplete fragments of XML (e.g. the start or end of a
        comment). So, missing entity references should only affect the data in
        the XML document and not its overall structure (if that were not _true,
        attempting to ignore entity references such as $(D ThrowOnEntityRef.no)
        does would be a disaster in the making). However, how reasonable it is
        to miss that data depends entirely on the application and what the XML
        documents it's parsing contain - hence, the behavior is configurable.

        See_Also: $(REF StdEntityRef, dxml, util)$(BR)
                  $(REF parseStdEntityRef, dxml, util)$(BR)
                  $(REF parseCharRef, dxml, util)$(BR)
                  $(REF encodeCharRef, dxml, util)$(BR)
                  $(REF decodeXML, dxml, util)$(BR)
                  $(REF asDecodedXML, dxml, util)
      +/
    auto throwOnEntityRef = ThrowOnEntityRef.yes;

    ///
    unittest
    {
        import std.exception : assertThrown;
        import qt.widgets.internal.dxml.util : decodeXML;

        auto xml = "<root>\n" ~
                   "    <std>&amp;&apos;&gt;&lt;&quot;</std>\n" ~
                   "    <other>&foobar;</other>\n" ~
                   "    <invalid>&--;</invalid>\n" ~
                   "</root>";

        // ThrowOnEntityRef.yes
        {
            auto range = parseXML(xml);
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "root");

            range.popFront();
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "std");

            range.popFront();
            assert(range.front.type == EntityType.text);
            assert(range.front.text == "&amp;&apos;&gt;&lt;&quot;");
            assert(range.front.text.decodeXML() == `&'><"`);

            range.popFront();
            assert(range.front.type == EntityType.elementEnd);
            assert(range.front.name == "std");

            range.popFront();
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "other");

            // Attempted to parse past "&foobar;", which is syntactically
            // valid, but it's not one of the five predefined entity references.
            assertThrown!XMLParsingException(range.popFront());
        }

        // ThrowOnEntityRef.no
        {
            auto range = parseXML!(makeConfig(ThrowOnEntityRef.no))(xml);
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "root");

            range.popFront();
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "std");

            range.popFront();
            assert(range.front.type == EntityType.text);
            assert(range.front.text == "&amp;&apos;&gt;&lt;&quot;");
            assert(range.front.text.decodeXML() == `&'><"`);

            range.popFront();
            assert(range.front.type == EntityType.elementEnd);
            assert(range.front.name == "std");

            range.popFront();
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "other");

            // Doesn't throw, because "&foobar;" is syntactically valid.
            range.popFront();
            assert(range.front.type == EntityType.text);
            assert(range.front.text == "&foobar;");

            // decodeXML has no effect on non-standard entity references.
            assert(range.front.text.decodeXML() == "&foobar;");

            range.popFront();
            assert(range.front.type == EntityType.elementEnd);
            assert(range.front.name == "other");

            range.popFront();
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "invalid");

            // Attempted to parse past "&--;", which is not syntactically valid,
            // because -- is not a valid name for an entity reference.
            assertThrown!XMLParsingException(range.popFront());
        }
    }
}


/// See_Also: $(LREF2 skipComments, Config)
alias SkipComments = Flag!"SkipComments";

/// See_Also: $(LREF2 skipPI, Config)
alias SkipPI = Flag!"SkipPI";

/// See_Also: $(LREF2 splitEmpty, Config)
alias SplitEmpty = Flag!"SplitEmpty";

/// See_Also: $(LREF2 throwOnEntityRef, Config)
alias ThrowOnEntityRef = Flag!"ThrowOnEntityRef";


/++
    Helper function for creating a custom config. It makes it easy to set one
    or more of the member variables to something other than the default without
    having to worry about explicitly setting them individually or setting them
    all at once via a constructor.

    The order of the arguments does not matter. The types of each of the members
    of Config are unique, so that information alone is sufficient to determine
    which argument should be assigned to which member.
  +/
Config makeConfig(Args...)(Args args)
{
    import std.format : format;
    import std.meta : AliasSeq, staticIndexOf, staticMap;

    template isValid(T, Types...)
    {
        static if(Types.length == 0)
            enum isValid = false;
        else static if(is(T == Types[0]))
            enum isValid = true;
        else
            enum isValid = isValid!(T, Types[1 .. $]);
    }

    Config config;

    alias TypeOfMember(string memberName) = typeof(__traits(getMember, config, memberName));
    alias MemberTypes = staticMap!(TypeOfMember, AliasSeq!(__traits(allMembers, Config)));

    foreach(i, arg; args)
    {
        static assert(isValid!(typeof(arg), MemberTypes),
                      format!"Argument %s does not match the type of any members of Config"(i));

        static foreach(j, Other; Args)
        {
            static if(i != j)
                static assert(!is(typeof(arg) == Other), format!"Argument %s and %s have the same type"(i, j));
        }

        foreach(memberName; __traits(allMembers, Config))
        {
            static if(is(typeof(__traits(getMember, config, memberName)) == typeof(arg)))
                mixin("config." ~ memberName ~ " = arg;");
        }
    }

    return config;
}

///
@safe pure nothrow @nogc unittest
{
    {
        auto config = makeConfig(SkipComments.yes);
        assert(config.skipComments == SkipComments.yes);
        assert(config.skipPI == Config.init.skipPI);
        assert(config.splitEmpty == Config.init.splitEmpty);
        assert(config.throwOnEntityRef == Config.init.throwOnEntityRef);
    }
    {
        auto config = makeConfig(SkipComments.yes, SkipPI.yes);
        assert(config.skipComments == SkipComments.yes);
        assert(config.skipPI == SkipPI.yes);
        assert(config.splitEmpty == Config.init.splitEmpty);
        assert(config.throwOnEntityRef == Config.init.throwOnEntityRef);
    }
    {
        auto config = makeConfig(SplitEmpty.yes, SkipComments.yes, ThrowOnEntityRef.no);
        assert(config.skipComments == SkipComments.yes);
        assert(config.skipPI == Config.init.skipPI);
        assert(config.splitEmpty == SplitEmpty.yes);
        assert(config.throwOnEntityRef == ThrowOnEntityRef.no);
    }
}

unittest
{
    import std.typecons : Flag;
    static assert(!__traits(compiles, makeConfig(42)));
    static assert(!__traits(compiles, makeConfig("hello")));
    static assert(!__traits(compiles, makeConfig(Flag!"SomeOtherFlag".yes)));
    static assert(!__traits(compiles, makeConfig(SplitEmpty.yes, SplitEmpty.no)));
}


/++
    This $(LREF Config) is intended for making it easy to parse XML by skipping
    everything that isn't the actual data as well as making it simpler to deal
    with empty element tags by treating them the same as a start tag and end
    tag with nothing but whitespace between them.
  +/
enum simpleXML = makeConfig(SkipComments.yes, SkipPI.yes, SplitEmpty.yes);

///
@safe pure nothrow @nogc unittest
{
    static assert(simpleXML.skipComments == SkipComments.yes);
    static assert(simpleXML.skipPI == SkipPI.yes);
    static assert(simpleXML.splitEmpty == SplitEmpty.yes);
    static assert(simpleXML.throwOnEntityRef == ThrowOnEntityRef.yes);
}


/++
    Represents the type of an XML entity. Used by $(LREF EntityRange.Entity).
  +/
enum EntityType
{
    /++
        A cdata section: `<![CDATA[ ... ]]>`.

        See_Also: $(LINK http://www.w3.org/TR/REC-xml/#sec-cdata-sect)
      +/
    cdata,

    /++
        An XML comment: `<!-- ... -->`.

        See_Also: $(LINK http://www.w3.org/TR/REC-xml/#sec-comments)
      +/
    comment,

    /++
        The start tag for an element. e.g. `<foo name="value">`.

        See_Also: $(LINK http://www.w3.org/TR/REC-xml/#sec-starttags)
      +/
    elementStart,

    /++
        The end tag for an element. e.g. `</foo>`.

        See_Also: $(LINK http://www.w3.org/TR/REC-xml/#sec-starttags)
      +/
    elementEnd,

    /++
        The tag for an element with no contents or matching end tag. e.g.
        `<foo name="value"/>`.

        See_Also: $(LINK http://www.w3.org/TR/REC-xml/#sec-starttags)
      +/
    elementEmpty,

    /++
        A processing instruction such as `<?foo?>`. Note that the
        `<?xml ... ?>` is skipped and not treated as an $(LREF EntityType._pi).

        See_Also: $(LINK http://www.w3.org/TR/REC-xml/#sec-pi)
      +/
    pi,

    /++
        The content of an element tag that is simple text.

        If there is an entity other than the end tag following the text, then
        the text includes up to that entity.

        Note however that character references (e.g.
        $(D_CODE_STRING "$(AMP)#42")) and the predefined entity references (e.g.
        $(D_CODE_STRING "$(AMP)apos;")) are left unprocessed in the text. In
        order for them to be processed, the text should be passed to either
        $(REF_ALTTEXT decodeXML, decodeXML, dxml, util) or
        $(REF_ALTTEXT asDecodedXML, asDecodedXML, dxml, util). Entity references
        which are not predefined are considered invalid XML, because the DTD
        section is skipped, and thus they cannot be processed properly.

        See_Also: $(LINK http://www.w3.org/TR/REC-xml/#sec-starttags)$(BR)
                  $(REF decodeXML, dxml, util)$(BR)
                  $(REF asDecodedXML, dxml, util)$(BR)
                  $(REF parseStdEntityRef, dxml, util)$(BR)
                  $(REF parseCharRef, dxml, util)$(BR)
                  $(LREF EntityRange.Entity._text)
      +/
    text,
}


/++
    Lazily parses the given range of characters as an XML document.

    EntityRange is essentially a
    $(LINK2 https://en.wikipedia.org/wiki/StAX, StAX) parser, though it evolved
    into that rather than being based on what Java did, and it's range-based
    rather than iterator-based, so its API is likely to differ from other
    implementations. The basic concept should be the same though.

    One of the core design goals of this parser is to slice the original input
    rather than having to allocate strings for the output or wrap it in a lazy
    range that produces a mutated version of the data. So, all of the text that
    the parser provides is either a slice or
    $(PHOBOS_REF takeExactly, std, range) of the input. However, in some cases,
    for the parser to be fully compliant with the XML spec,
    $(REF decodeXML, dxml, util) must be called on the text to mutate certain
    constructs (e.g. removing any $(D_CODE_STRING '\r') in the text or
    converting $(D_CODE_STRING "$(AMP)lt;") to $(D_CODE_STRING '<')). But
    that's left up to the application.

    The parser is not $(K_NOGC), but it allocates memory very minimally. It
    allocates some of its state on the heap so it can validate attributes and
    end tags. However, that state is shared among all the ranges that came from
    the same call to parseXML (only the range farthest along in parsing
    validates attributes or end tags), so $(LREF2 save, _EntityRange) does not
    allocate memory unless $(D save) on the underlying range allocates memory.
    The shared state currently uses a couple of dynamic arrays to validate the
    tags and attributes, and if the document has a particularly deep tag depth
    or has a lot of attributes on a start tag, then some reallocations may
    occur until the maximum is reached, but enough is reserved that for most
    documents, no reallocations will occur. The only other times that the
    parser would allocate would be if an exception were thrown or if the range
    that was passed to parseXML allocates for any reason when calling any of the
    range primitives.

    If invalid XML is encountered at any point during the parsing process, an
    $(LREF XMLParsingException) will be thrown. If an exception has been thrown,
    then the parser is in an invalid state, and it is an error to call any
    functions on it.

    However, note that XML validation is reduced for any entities that are
    skipped (e.g. for anything in the DTD, validation is reduced to what is
    required to correctly parse past it, and when
    $(D Config.skipPI == SkipPI.yes), processing instructions are only validated
    enough to correctly skip past them).

    As the module documentation says, this parser does not provide any DTD
    support. It is not possible to properly support the DTD while returning
    slices of the original input, and the DTD portion of the spec makes parsing
    XML far, far more complicated.

    A quick note about carriage returns$(COLON) per the XML spec, they are all
    supposed to either be stripped out or replaced with newlines or spaces
    before the XML parser even processes the text. That doesn't work when the
    parser is slicing the original text and not mutating it at all. So, for the
    purposes of parsing, this parser treats all carriage returns as if they
    were newlines or spaces (though they won't count as newlines when counting
    the lines for $(LREF TextPos)). However, they $(I will) appear in any text
    fields or attribute values if they are in the document (since the text
    fields and attribute values are slices of the original text).
    $(REF decodeXML, dxml, util) can be used to strip them along with
    converting any character references in the text. Alternatively, the
    application can remove them all before calling parseXML, but it's not
    necessary.
  +/
struct EntityRange(Config cfg, R)
    if(isForwardRange!R && isSomeChar!(ElementType!R))
{
    import std.algorithm : canFind;
    import std.range : only, takeExactly;
    import std.typecons : Nullable;
    import std.utf : byCodeUnit;

    enum compileInTests = is(R == EntityRangeCompileTests);

public:

    /// The Config used for when parsing the XML.
    alias config = cfg;

    /// The type of the range that EntityRange is parsing.
    alias Input = R;

    /++
        The type used when any slice of the original input is used. If $(D R)
        is a string or supports slicing, then SliceOfR is the same as $(D R);
        otherwise, it's the result of calling
        $(PHOBOS_REF takeExactly, std, range) on the input.

        ---
        import std.algorithm : filter;
        import std.range : takeExactly;

        static assert(is(EntityRange!(Config.init, string).SliceOfR == string));

        auto range = filter!(a => true)("some xml");

        static assert(is(EntityRange!(Config.init, typeof(range)).SliceOfR ==
                         typeof(takeExactly(range, 42))));
        ---
      +/
    static if(isDynamicArray!R || hasSlicing!R)
        alias SliceOfR = R;
    else
        alias SliceOfR = typeof(takeExactly(R.init, 42));

    // https://issues.dlang.org/show_bug.cgi?id=11133 prevents this from being
    // a ddoc-ed unit test.
    static if(compileInTests) @safe unittest
    {
        import std.algorithm : filter;
        import std.range : takeExactly;

        static assert(is(EntityRange!(Config.init, string).SliceOfR == string));

        auto range = filter!(a => true)("some xml");

        static assert(is(EntityRange!(Config.init, typeof(range)).SliceOfR ==
                         typeof(takeExactly(range, 42))));
    }


    /++
        Represents an entity in the XML document.

        Note that the $(LREF2 type, EntityRange._Entity) determines which
        properties can be used, and it can determine whether functions which
        an Entity or $(LREF EntityRange) is passed to are allowed to be called.
        Each function lists which $(LREF EntityType)s are allowed, and it is an
        error to call them with any other $(LREF EntityType).
      +/
    struct Entity
    {
    public:

        import std.typecons : Tuple;

        /++
            The exact instantiation of $(PHOBOS_REF Tuple, std, typecons) that
            $(LREF2 attributes, EntityRange.EntityType) returns a range of.

            See_Also: $(LREF2 attributes, EntityRange.Entity)
          +/
        alias Attribute = Tuple!(SliceOfR, "name", SliceOfR, "value", TextPos,  "pos");


        /++
            The $(LREF EntityType) for this Entity.
          +/
        @property EntityType type() @safe const pure nothrow @nogc
        {
            return _type;
        }

        ///
        static if(compileInTests) unittest
        {
            auto xml = "<root>\n" ~
                       "    <!--no comment-->\n" ~
                       "    <![CDATA[cdata run]]>\n" ~
                       "    <text>I am text!</text>\n" ~
                       "    <empty/>\n" ~
                       "    <?pi?>\n" ~
                       "</root>";

            auto range = parseXML(xml);
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "root");
            range.popFront();

            assert(range.front.type == EntityType.comment);
            assert(range.front.text == "no comment");
            range.popFront();

            assert(range.front.type == EntityType.cdata);
            assert(range.front.text == "cdata run");
            range.popFront();

            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "text");
            range.popFront();

            assert(range.front.type == EntityType.text);
            assert(range.front.text == "I am text!");
            range.popFront();

            assert(range.front.type == EntityType.elementEnd);
            assert(range.front.name == "text");
            range.popFront();

            assert(range.front.type == EntityType.elementEmpty);
            assert(range.front.name == "empty");
            range.popFront();

            assert(range.front.type == EntityType.pi);
            assert(range.front.name == "pi");
            range.popFront();

            assert(range.front.type == EntityType.elementEnd);
            assert(range.front.name == "root");
            range.popFront();

            assert(range.empty);
        }


        /++
            The position in the the original text where the entity starts.

            See_Also: $(LREF TextPos)$(BR)
                      $(LREF XMLParsingException._pos)
          +/
        @property TextPos pos() @safe const pure nothrow @nogc
        {
            return _pos;
        }

        ///
        static if(compileInTests) unittest
        {
            auto xml = "<root>\n" ~
                       "    <foo>\n" ~
                       "        Foo and bar. Always foo and bar...\n" ~
                       "    </foo>\n" ~
                       "</root>";

            auto range = parseXML(xml);
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "root");
            assert(range.front.pos == TextPos(1, 1));
            range.popFront();

            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "foo");
            assert(range.front.pos == TextPos(2, 5));
            range.popFront();

            assert(range.front.type == EntityType.text);
            assert(range.front.text ==
                   "\n" ~
                   "        Foo and bar. Always foo and bar...\n" ~
                   "    ");
            assert(range.front.pos == TextPos(2, 10));
            range.popFront();

            assert(range.front.type == EntityType.elementEnd);
            assert(range.front.name == "foo");
            assert(range.front.pos == TextPos(4, 5));
            range.popFront();

            assert(range.front.type == EntityType.elementEnd);
            assert(range.front.name == "root");
            assert(range.front.pos == TextPos(5, 1));
            range.popFront();

            assert(range.empty);
        }

        static if(compileInTests) unittest
        {
            import core.exception : AssertError;
            import std.exception : enforce;

            static void test(ER)(ref ER range, EntityType type, int row, int col, size_t line = __LINE__)
            {
                enforce!AssertError(!range.empty, "unittest failure 1", __FILE__, line);
                enforce!AssertError(range.front.type == type, "unittest failure 2", __FILE__, line);
                enforce!AssertError(range.front.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
                range.popFront();
            }

            auto xml = "<?xml?>\n" ~
                       "   <!--comment-->\n" ~
                       "   <?pi?>\n" ~
                       " <root>\n" ~
                       "          <!--comment--><!--comment-->\n" ~
                       "       <?pi?>\n" ~
                       "  <![CDATA[]]>\n" ~
                       "              <empty/>     </root>\n" ~
                       " <!--comment-->\n" ~
                       " <?pi?>\n";

            {
                auto range = parseXML(xml);
                test(range, EntityType.comment, 2, 4);
                test(range, EntityType.pi, 3, 4);
                test(range, EntityType.elementStart, 4, 2);
                test(range, EntityType.comment, 5, 11);
                test(range, EntityType.comment, 5, 25);
                test(range, EntityType.pi, 6, 8);
                test(range, EntityType.cdata, 7, 3);
                test(range, EntityType.elementEmpty, 8, 15);
                test(range, EntityType.elementEnd, 8, 28);
                test(range, EntityType.comment, 9, 2);
                test(range, EntityType.pi, 10, 2);
            }

            auto range = parseXML!simpleXML(xml);
            test(range, EntityType.elementStart, 4, 2);
            test(range, EntityType.cdata, 7, 3);
            test(range, EntityType.elementStart, 8, 15);
            test(range, EntityType.elementEnd, 8, 15);
            test(range, EntityType.elementEnd, 8, 28);
        }


        /++
            Gives the name of this Entity.

            Note that this is the direct name in the XML for this entity and
            does not contain any of the names of any of the parent entities that
            this entity has. If an application wants the full "path" of the
            entity, then it will have to keep track of that itself. The parser
            does not do that as it would require allocating memory.

            $(TABLE
                $(TR $(TH Supported $(LREF EntityType)s:))
                $(TR $(TD $(LREF2 elementStart, EntityType)))
                $(TR $(TD $(LREF2 elementEnd, EntityType)))
                $(TR $(TD $(LREF2 elementEmpty, EntityType)))
                $(TR $(TD $(LREF2 pi, EntityType)))
            )
          +/
        @property SliceOfR name()
        {
            import qt.widgets.internal.dxml.internal : checkedSave, stripBCU;
            with(EntityType)
            {
                import std.format : format;
                assert(only(elementStart, elementEnd, elementEmpty, pi).canFind(_type),
                       format("name cannot be called with %s", _type));
            }
            return stripBCU!R(checkedSave(_name));
        }

        ///
        static if(compileInTests) unittest
        {
            auto xml = "<root>\n" ~
                       "    <empty/>\n" ~
                       "    <?pi?>\n" ~
                       "</root>";

            auto range = parseXML(xml);
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "root");
            range.popFront();

            assert(range.front.type == EntityType.elementEmpty);
            assert(range.front.name == "empty");
            range.popFront();

            assert(range.front.type == EntityType.pi);
            assert(range.front.name == "pi");
            range.popFront();

            assert(range.front.type == EntityType.elementEnd);
            assert(range.front.name == "root");
            range.popFront();

            assert(range.empty);
        }


        /++
            Returns a lazy range of attributes for a start tag where each
            attribute is represented as a$(BR)
            $(D $(PHOBOS_REF_ALTTEXT Tuple, Tuple, std, typecons)!(
                      $(LREF2 SliceOfR, EntityRange), $(D_STRING "name"),
                      $(LREF2 SliceOfR, EntityRange), $(D_STRING "value"),
                      $(LREF TextPos), $(D_STRING "pos"))).

            $(TABLE
                $(TR $(TH Supported $(LREF EntityType)s:))
                $(TR $(TD $(LREF2 elementStart, EntityType)))
                $(TR $(TD $(LREF2 elementEmpty, EntityType)))
            )

            See_Also: $(LREF2 Attribute, EntityRange.Entity)$(BR)
                      $(REF decodeXML, dxml, util)$(BR)
                      $(REF asDecodedXML, dxml, util)
          +/
        @property auto attributes()
        {
            with(EntityType)
            {
                import std.format : format;
                assert(_type == elementStart || _type == elementEmpty,
                       format("attributes cannot be called with %s", _type));
            }

            // STag         ::= '<' Name (S Attribute)* S? '>'
            // Attribute    ::= Name Eq AttValue
            // EmptyElemTag ::= '<' Name (S Attribute)* S? '/>'

            static struct AttributeRange
            {
                @property Attribute front()
                {
                    return _front;
                }

                void popFront()
                {
                    import qt.widgets.internal.dxml.internal : stripBCU;

                    stripWS(_text);
                    if(_text.input.empty)
                    {
                        empty = true;
                        return;
                    }

                    immutable pos = _text.pos;
                    auto name = stripBCU!R(_text.takeName!'='());
                    stripWS(_text);
                    popFrontAndIncCol(_text);
                    stripWS(_text);
                    _front = Attribute(name, stripBCU!R(takeEnquotedText(_text)), pos);
                }

                @property auto save()
                {
                    import qt.widgets.internal.dxml.internal : checkedSave;
                    auto retval = this;
                    retval._front = Attribute(_front[0].save, checkedSave(_front[1]), _front[2]);
                    retval._text.input = checkedSave(retval._text.input);
                    return retval;
                }

                this(typeof(_text) text)
                {
                    _front = Attribute.init; // This is utterly stupid. https://issues.dlang.org/show_bug.cgi?id=13945
                    _text = text;
                    if(_text.input.empty)
                        empty = true;
                    else
                        popFront();
                }

                bool empty;
                Attribute _front;
                typeof(_savedText) _text;
            }

            return AttributeRange(_savedText.save);
        }

        ///
        static if(compileInTests) unittest
        {
            import std.algorithm.comparison : equal;
            import std.algorithm.iteration : filter;
            {
                auto xml = "<root/>";
                auto range = parseXML(xml);
                assert(range.front.type == EntityType.elementEmpty);
                assert(range.front.attributes.empty);

                static assert(is(ElementType!(typeof(range.front.attributes)) ==
                                 typeof(range).Entity.Attribute));
            }
            {
                auto xml = "<root a='42' q='29' w='hello'/>";
                auto range = parseXML(xml);
                assert(range.front.type == EntityType.elementEmpty);

                auto attrs = range.front.attributes;
                assert(attrs.front.name == "a");
                assert(attrs.front.value == "42");
                assert(attrs.front.pos == TextPos(1, 7));
                attrs.popFront();

                assert(attrs.front.name == "q");
                assert(attrs.front.value == "29");
                assert(attrs.front.pos == TextPos(1, 14));
                attrs.popFront();

                assert(attrs.front.name == "w");
                assert(attrs.front.value == "hello");
                assert(attrs.front.pos == TextPos(1, 21));
                attrs.popFront();

                assert(attrs.empty);
            }
            // Because the type of name and value is SliceOfR, == with a string
            // only works if the range passed to parseXML was string.
            {
                auto xml = filter!(a => true)("<root a='42' q='29' w='hello'/>");
                auto range = parseXML(xml);
                assert(range.front.type == EntityType.elementEmpty);

                auto attrs = range.front.attributes;
                assert(equal(attrs.front.name, "a"));
                assert(equal(attrs.front.value, "42"));
                assert(attrs.front.pos == TextPos(1, 7));
                attrs.popFront();

                assert(equal(attrs.front.name, "q"));
                assert(equal(attrs.front.value, "29"));
                assert(attrs.front.pos == TextPos(1, 14));
                attrs.popFront();

                assert(equal(attrs.front.name, "w"));
                assert(equal(attrs.front.value, "hello"));
                assert(attrs.front.pos == TextPos(1, 21));
                attrs.popFront();

                assert(attrs.empty);
            }
        }

        static if(compileInTests) unittest
        {
            import core.exception : AssertError;
            import std.algorithm.comparison : equal;
            import std.exception : assertNotThrown, collectException, enforce;
            import std.typecons : Tuple, tuple;
            import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

            static bool cmpAttr(T, U)(T lhs, U rhs)
            {
                return equal(lhs[0].save, rhs[0].save) &&
                       equal(lhs[1].save, rhs[1].save);
            }

            static void test(alias func, ThrowOnEntityRef toer)(string text, EntityType type,
                                                                Tuple!(string, string)[] expected,
                                                                int row, int col, size_t line = __LINE__)
            {
                auto range = assertNotThrown!XMLParsingException(parseXML!(makeConfig(toer))(func(text)),
                                                                 "unittest 1", __FILE__, line);
                enforce!AssertError(range.front.type == type, "unittest failure 2", __FILE__, line);
                enforce!AssertError(equal!cmpAttr(range.front.attributes, expected),
                                    "unittest failure 3", __FILE__, line);
                enforce!AssertError(range._text.pos == TextPos(row, col), "unittest failure 4", __FILE__, line);
            }

            static void testFail(alias func, ThrowOnEntityRef toer)(string text,
                                                                    int row, int col, size_t line = __LINE__)
            {
                auto e = collectException!XMLParsingException(parseXML!(makeConfig(toer))(func(text)));
                enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
                enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
            }

            static foreach(func; testRangeFuncs)
            {
                static foreach(toer; [ThrowOnEntityRef.yes, ThrowOnEntityRef.no])
                {
                    test!(func, toer)("<root a='b'/>", EntityType.elementEmpty, [tuple("a", "b")], 1, 14);
                    test!(func, toer)("<root a = 'b' />", EntityType.elementEmpty, [tuple("a", "b")], 1, 17);
                    test!(func, toer)("<root \n\n a \n\n = \n\n 'b' \n\n />", EntityType.elementEmpty,
                                      [tuple("a", "b")], 9, 4);
                    test!(func, toer)("<root a='b'></root>", EntityType.elementStart, [tuple("a", "b")], 1, 13);
                    test!(func, toer)("<root a = 'b' ></root>", EntityType.elementStart, [tuple("a", "b")], 1, 16);
                    test!(func, toer)("<root \n a \n = \n 'b' \n ></root>", EntityType.elementStart,
                                      [tuple("a", "b")], 5, 3);

                    test!(func, toer)("<root foo='\n\n\n'/>", EntityType.elementEmpty, [tuple("foo", "\n\n\n")], 4, 4);
                    test!(func, toer)(`<root foo='"""'/>`, EntityType.elementEmpty, [tuple("foo", `"""`)], 1, 18);
                    test!(func, toer)(`<root foo="'''"/>`, EntityType.elementEmpty, [tuple("foo", `'''`)], 1, 18);
                    test!(func, toer)(`<root foo.=""/>`, EntityType.elementEmpty, [tuple("foo.", "")], 1, 16);
                    test!(func, toer)(`<root foo="bar="/>`, EntityType.elementEmpty, [tuple("foo", "bar=")], 1, 19);

                    test!(func, toer)("<root foo='bar' a='b' hello='world'/>", EntityType.elementEmpty,
                              [tuple("foo", "bar"), tuple("a", "b"), tuple("hello", "world")], 1, 38);
                    test!(func, toer)(`<root foo="bar" a='b' hello="world"/>`, EntityType.elementEmpty,
                              [tuple("foo", "bar"), tuple("a", "b"), tuple("hello", "world")], 1, 38);

                    test!(func, toer)(`<root foo="&#42;" a='&#x42;' hello="%foo"/>`, EntityType.elementEmpty,
                              [tuple("foo", "&#42;"), tuple("a", "&#x42;"), tuple("hello", "%foo")], 1, 44);

                    test!(func, toer)(`<root foo="&amp;" a='vector&lt;int&gt;'></root>`, EntityType.elementStart,
                              [tuple("foo", "&amp;"), tuple("a", "vector&lt;int&gt;"),], 1, 41);

                    test!(func, toer)(`<foo 京都市="ディラン"/>`, EntityType.elementEmpty,
                              [tuple("京都市", "ディラン")], 1, codeLen!(func, `<foo 京都市="ディラン"/>`) + 1);

                    test!(func, toer)(`<root foo=">"/>`, EntityType.elementEmpty, [tuple("foo", ">")], 1, 16);
                    test!(func, toer)(`<root foo=">>>>>>"/>`, EntityType.elementEmpty, [tuple("foo", ">>>>>>")], 1, 21);
                    test!(func, toer)(`<root foo=">"></root>`, EntityType.elementStart, [tuple("foo", ">")], 1, 15);
                    test!(func, toer)(`<root foo=">>>>>>"></root>`, EntityType.elementStart, [tuple("foo", ">>>>>>")], 1, 20);

                    test!(func, toer)(`<root foo="bar" foos="ball"/>`, EntityType.elementEmpty,
                              [tuple("foo", "bar"), tuple("foos", "ball")], 1, 30);

                    testFail!(func, toer)(`<root a="""/>`, 1, 11);
                    testFail!(func, toer)(`<root a='''/>`, 1, 11);
                    testFail!(func, toer)("<root a=/>", 1, 9);
                    testFail!(func, toer)("<root a='/>", 1, 9);
                    testFail!(func, toer)("<root a='/>", 1, 9);
                    testFail!(func, toer)("<root =''/>", 1, 7);
                    testFail!(func, toer)(`<root a ""/>`, 1, 9);
                    testFail!(func, toer)(`<root a""/>`, 1, 8);
                    testFail!(func, toer)(`<root a/>`, 1, 8);
                    testFail!(func, toer)("<root foo='bar' a=/>", 1, 19);
                    testFail!(func, toer)("<root foo='bar' a='/>", 1, 19);
                    testFail!(func, toer)("<root foo='bar' a='/>", 1, 19);
                    testFail!(func, toer)("<root foo='bar' =''/>", 1, 17);
                    testFail!(func, toer)("<root foo='bar' a= hello='world'/>", 1, 20);
                    // It's 33 rather than 28, because it throws when processing the start tag and not when processing
                    // the attributes. So, the mismatched quotes are detected before the attributes are checked.
                    testFail!(func, toer)("<root foo='bar' a=' hello='world'/>", 1, 33);
                    testFail!(func, toer)("<root foo='bar' ='' hello='world'/>", 1, 17);
                    testFail!(func, toer)("<root foo='bar'a='b'/>", 1, 16);
                    testFail!(func, toer)(`<root .foo="bar"/>`, 1, 7);

                    testFail!(func, toer)(`<root foo="<"/>`, 1, 12);
                    testFail!(func, toer)(`<root foo="<world"/>`, 1, 12);
                    testFail!(func, toer)(`<root foo="hello<world"/>`, 1, 17);
                    testFail!(func, toer)(`<root foo="&"/>`, 1, 12);
                    testFail!(func, toer)(`<root foo="hello&"/>`, 1, 17);
                    testFail!(func, toer)(`<root foo="hello&world"/>`, 1, 17);
                    testFail!(func, toer)(`<root foo="&;"/>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#;"/>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#x;"/>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#A;"/>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#xG;"/>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#42"/>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#x42"/>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#x12;"/>`, 1, 12);

                    testFail!(func, toer)("<root\n\nfoo='\nbar&#x42'></root>", 4, 4);

                    testFail!(func, toer)(`<root a="""></root>`, 1, 11);
                    testFail!(func, toer)(`<root a='''></root>`, 1, 11);
                    testFail!(func, toer)("<root a=></root>", 1, 9);
                    testFail!(func, toer)("<root a='></root>", 1, 9);
                    testFail!(func, toer)("<root a='></root>", 1, 9);
                    testFail!(func, toer)("<root =''></root>", 1, 7);
                    testFail!(func, toer)(`<root a ""></root>`, 1, 9);
                    testFail!(func, toer)(`<root a""></root>`, 1, 8);
                    testFail!(func, toer)(`<root a></root>`, 1, 8);
                    testFail!(func, toer)("<root foo='bar' a=></root>", 1, 19);
                    testFail!(func, toer)("<root foo='bar' a='></root>", 1, 19);
                    testFail!(func, toer)("<root foo='bar' a='></root>", 1, 19);
                    testFail!(func, toer)("<root foo='bar' =''></root>", 1, 17);
                    testFail!(func, toer)("<root foo='bar' a= hello='world'></root>", 1, 20);
                    testFail!(func, toer)("<root foo='bar' a=' hello='world'></root>", 1, 33);
                    testFail!(func, toer)("<root foo='bar' ='' hello='world'></root>", 1, 17);
                    testFail!(func, toer)("<root foo='bar'a='b'></root>", 1, 16);
                    testFail!(func, toer)(`<root .foo='bar'></root>`, 1, 7);

                    testFail!(func, toer)(`<root foo="<"></root>`, 1, 12);
                    testFail!(func, toer)(`<root foo="<world"></root>`, 1, 12);
                    testFail!(func, toer)(`<root foo="hello<world"></root>`, 1, 17);
                    testFail!(func, toer)(`<root foo="&"></root>`, 1, 12);
                    testFail!(func, toer)(`<root foo="hello&"></root>`, 1, 17);
                    testFail!(func, toer)(`<root foo="hello&world"></root>`, 1, 17);
                    testFail!(func, toer)(`<root foo="&;"></root>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#;"></root>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#x;"></root>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#A;"></root>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#xG;"></root>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#42"></root>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#x42"></root>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&#x12;"></root>`, 1, 12);

                    testFail!(func, toer)(`<root a='42' a='19'/>`, 1, 14);
                    testFail!(func, toer)(`<root a='42' b='hello' a='19'/>`, 1, 24);
                    testFail!(func, toer)(`<root a='42' b='hello' a='19' c=''/>`, 1, 24);
                    testFail!(func, toer)(`<root a='' b='' c='' d='' e='' f='' g='' e='' h=''/>`, 1, 42);
                    testFail!(func, toer)(`<root foo='bar' foo='bar'/>`, 1, 17);

                    test!(func, toer)(`<root foo="&amp;"></root>`, EntityType.elementStart,
                                      [tuple("foo", "&amp;")], 1, 19);
                    test!(func, toer)(`<root foo="foo&amp;&lt;&gt;&apos;&quot;bar"></root>`, EntityType.elementStart,
                                      [tuple("foo", "foo&amp;&lt;&gt;&apos;&quot;bar")], 1, 45);
                    testFail!(func, toer)("<root foo='&;'></root>", 1, 12);
                    testFail!(func, toer)("<root foo='&.;'></root>", 1, 12);
                    testFail!(func, toer)("<root foo='\n &amp ule'></root>", 2, 2);
                    testFail!(func, toer)("<root foo='\n &foo bar'></root>", 2, 2);
                }
                {
                    alias toer = ThrowOnEntityRef.yes;
                    testFail!(func, toer)(`<root foo="&foo;"/>`, 1, 12);
                    testFail!(func, toer)(`<root foo="&foo;"></root>`, 1, 12);
                    testFail!(func, toer)("<root foo='foo&bar.;'></root>", 1, 15);
                    testFail!(func, toer)(`<root foo="hello &a; world"></root>`, 1, 18);
                    testFail!(func, toer)("<root foo='hello \n &a; \n world'></root>", 2, 2);
                }
                {
                    alias toer = ThrowOnEntityRef.no;
                    test!(func, toer)(`<root foo="&foo;"/>`, EntityType.elementEmpty,
                                      [tuple("foo", "&foo;")], 1, 20);
                    test!(func, toer)(`<root foo="&foo;"></root>`, EntityType.elementStart,
                                      [tuple("foo", "&foo;")], 1, 19);
                    test!(func, toer)("<root foo='foo&bar.;'></root>", EntityType.elementStart,
                                      [tuple("foo", "foo&bar.;")], 1, 23);
                    test!(func, toer)(`<root foo="hello &a; world"></root>`, EntityType.elementStart,
                                        [tuple("foo", "hello &a; world")], 1, 29);
                    test!(func, toer)("<root foo='hello \n &a; \n world'></root>", EntityType.elementStart,
                                        [tuple("foo", "hello \n &a; \n world")], 3, 9);
                }
            }
        }


        /++
            Returns the textual value of this Entity.

            In the case of $(LREF EntityType.pi), this is the
            text that follows the name, whereas in the other cases, the text is
            the entire contents of the entity (save for the delimeters on the
            ends if that entity has them).

            $(TABLE
                $(TR $(TH Supported $(LREF EntityType)s:))
                $(TR $(TD $(LREF2 cdata, EntityType)))
                $(TR $(TD $(LREF2 comment, EntityType)))
                $(TR $(TD $(LREF2 pi, EntityType)))
                $(TR $(TD $(LREF2 _text, EntityType)))
            )

            See_Also: $(REF decodeXML, dxml, util)$(BR)
                      $(REF asDecodedXML, dxml, util)$(BR)
                      $(REF stripIndent, dxml, util)$(BR)
                      $(REF withoutIndent, dxml, util)
          +/
        @property SliceOfR text()
        {
            import qt.widgets.internal.dxml.internal : checkedSave, stripBCU;
            with(EntityType)
            {
                import std.format : format;
                assert(only(cdata, comment, pi, text).canFind(_type),
                       format("text cannot be called with %s", _type));
            }
            return stripBCU!R(checkedSave(_savedText.input));
        }

        ///
        static if(compileInTests) unittest
        {
            import std.range.primitives : empty;

            auto xml = "<?xml version='1.0'?>\n" ~
                       "<?instructionName?>\n" ~
                       "<?foo here is something to say?>\n" ~
                       "<root>\n" ~
                       "    <![CDATA[ Yay! random text >> << ]]>\n" ~
                       "    <!-- some random comment -->\n" ~
                       "    <p>something here</p>\n" ~
                       "    <p>\n" ~
                       "       something else\n" ~
                       "       here</p>\n" ~
                       "</root>";
            auto range = parseXML(xml);

            // "<?instructionName?>\n" ~
            assert(range.front.type == EntityType.pi);
            assert(range.front.name == "instructionName");
            assert(range.front.text.empty);

            // "<?foo here is something to say?>\n" ~
            range.popFront();
            assert(range.front.type == EntityType.pi);
            assert(range.front.name == "foo");
            assert(range.front.text == "here is something to say");

            // "<root>\n" ~
            range.popFront();
            assert(range.front.type == EntityType.elementStart);

            // "    <![CDATA[ Yay! random text >> << ]]>\n" ~
            range.popFront();
            assert(range.front.type == EntityType.cdata);
            assert(range.front.text == " Yay! random text >> << ");

            // "    <!-- some random comment -->\n" ~
            range.popFront();
            assert(range.front.type == EntityType.comment);
            assert(range.front.text == " some random comment ");

            // "    <p>something here</p>\n" ~
            range.popFront();
            assert(range.front.type == EntityType.elementStart);
            assert(range.front.name == "p");

            range.popFront();
            assert(range.front.type == EntityType.text);
            assert(range.front.text == "something here");

            range.popFront();
            assert(range.front.type == EntityType.elementEnd);
            assert(range.front.name == "p");

            // "    <p>\n" ~
            // "       something else\n" ~
            // "       here</p>\n" ~
            range.popFront();
            assert(range.front.type == EntityType.elementStart);

            range.popFront();
            assert(range.front.type == EntityType.text);
            assert(range.front.text == "\n       something else\n       here");

            range.popFront();
            assert(range.front.type == EntityType.elementEnd);

            // "</root>"
            range.popFront();
            assert(range.front.type == EntityType.elementEnd);

            range.popFront();
            assert(range.empty);
        }


        // Reduce the chance of bugs if reference-type ranges are involved.
        static if(!isDynamicArray!R) this(this)
        {
            with(EntityType) final switch(_type)
            {
                case cdata: break;
                case comment: break;
                case elementStart:
                {
                    _name = _name.save;
                    break;
                }
                case elementEnd: goto case elementStart;
                case elementEmpty: goto case elementStart;
                case text: break;
                case pi: goto case elementStart;
            }

            if(_type != EntityType.elementEnd)
                _savedText = _savedText.save;
        }

        static if(compileInTests) unittest
        {
            import std.algorithm.comparison : equal;
            import qt.widgets.internal.dxml.internal : testRangeFuncs;

            static bool cmpAttr(T)(T lhs, T rhs)
            {
                return equal(lhs.name.save, rhs.name.save) &&
                       equal(lhs.value.save, rhs.value.save);
            }

            {
                auto xml = "<root>\n" ~
                           "    <foo a='42'/>\n" ~
                           "    <foo b='42'/>\n" ~
                           "    <nocomment>nothing to say</nocomment>\n" ~
                           "</root>";

                // The duplicate lines aren't typos. We want to ensure that the
                // values are independent and that nothing was consumed.
                static foreach(func; testRangeFuncs)
                {{
                     auto range = parseXML(func(xml));
                     range.popFront();
                     {
                         auto entity = range.front;
                         auto entity2 = entity;
                         assert(entity.pos == entity2.pos);
                         assert(equal(entity.name, entity2.name));
                         assert(equal(entity.name, entity2.name));
                         assert(equal!cmpAttr(entity.attributes, entity2.attributes));
                         assert(equal!cmpAttr(entity.attributes, entity2.attributes));
                         range.popFront();
                         assert(entity.pos == entity2.pos);
                         assert(entity.pos != range.front.pos);
                     }
                     range.popFront();
                     range.popFront();
                     {
                         auto entity = range.front;
                         auto entity2 = entity;
                         assert(entity.pos == entity2.pos);
                         assert(equal(entity.text, entity2.text));
                         assert(equal(entity.text, entity2.text));
                         range.popFront();
                         assert(entity.pos == entity2.pos);
                         assert(entity.pos != range.front.pos);
                     }
                }}
            }
            {
                auto xml = "<root>\n" ~
                           "    <![CDATA[whatever]]>\n" ~
                           "    <?pi?>\n" ~
                           "    <!--comment-->\n" ~
                           "    <empty/>\n" ~
                           "    <noend a='foo' b='bar'/>\n" ~
                           "    <foo baz='42'></foo>\n" ~
                           "</root>";

                static foreach(func; testRangeFuncs)
                {
                    for(auto range = parseXML(func(xml)); !range.empty; range.popFront())
                    {
                        auto entity = range.front;
                        auto entity2 = entity;

                        assert(entity.pos == range.front.pos);
                        assert(entity.pos == entity2.pos);
                        assert(entity.type == range.front.type);
                        assert(entity.type == entity2.type);

                        with(EntityType) final switch(entity.type)
                        {
                            case cdata: goto case text;
                            case comment: goto case text;
                            case elementStart:
                            {
                                assert(equal!cmpAttr(entity.attributes, range.front.attributes));
                                assert(equal!cmpAttr(entity.attributes, entity2.attributes));
                                goto case elementEnd;
                            }
                            case elementEnd:
                            {
                                assert(equal(entity.name, range.front.name));
                                assert(equal(entity.name, entity2.name));
                                break;
                            }
                            case elementEmpty: goto case elementStart;
                            case text:
                            {
                                assert(equal(entity.text, range.front.text));
                                assert(equal(entity.text, entity2.text));
                                break;
                            }
                            case pi:
                            {
                                assert(equal(entity.name, range.front.name));
                                assert(equal(entity.name, entity2.name));
                                goto case text;
                            }
                        }
                    }
                }
            }
        }


    private:

        this(EntityType type)
        {
            _type = type;

            // None of these initializations should be required. https://issues.dlang.org/show_bug.cgi?id=13945
            _name = typeof(_name).init;
            _savedText = typeof(_savedText).init;
        }

        EntityType _type;
        TextPos _pos;
        Taken _name;
        typeof(EntityRange._savedText) _savedText;
    }


    /++
        Returns the $(LREF Entity) representing the entity in the XML document
        which was most recently parsed.
      +/
    @property Entity front()
    {
        auto retval = Entity(_type);
        with(EntityType) final switch(_type)
        {
            case cdata: retval._savedText = _savedText.save; break;
            case comment: goto case cdata;
            case elementStart: retval._name = _name.save; retval._savedText = _savedText.save; break;
            case elementEnd: retval._name = _name.save; break;
            case elementEmpty: goto case elementStart;
            case text: goto case cdata;
            case pi: goto case elementStart;
        }
        retval._pos = _entityPos;
        return retval;
    }


    /++
        Move to the next entity.

        The next entity is the next one that is linearly in the XML document.
        So, if the current entity has child entities, the next entity will be
        the first child entity, whereas if it has no child entities, it will be
        the next entity at the same level.

        Throws: $(LREF XMLParsingException) on invalid XML.
      +/
    void popFront()
    {
        final switch(_grammarPos) with(GrammarPos)
        {
            case documentStart: _parseDocumentStart(); break;
            case prologMisc1: _parseAtPrologMisc!1(); break;
            case prologMisc2: _parseAtPrologMisc!2(); break;
            case splittingEmpty:
            {
                _type = EntityType.elementEnd;
                _tagStack.sawEntity();
                _grammarPos = _tagStack.depth == 0 ? GrammarPos.endMisc : GrammarPos.contentCharData2;
                break;
            }
            case contentCharData1:
            {
                assert(_type == EntityType.elementStart);
                _tagStack.pushTag(_name.save);
                _parseAtContentCharData();
                break;
            }
            case contentMid: _parseAtContentMid(); break;
            case contentCharData2: _parseAtContentCharData(); break;
            case endTag: _parseElementEnd(); break;
            case endMisc: _parseAtEndMisc(); break;
            case documentEnd: assert(0, "It's illegal to call popFront() on an empty EntityRange.");
        }
    }


    /++
        Whether the end of the XML document has been reached.

        Note that because an $(LREF XMLParsingException) will be thrown an
        invalid XML, it's actually possible to call
        $(LREF2 front, EntityRange) and $(LREF2 popFront, EntityRange) without
        checking empty if the only way that empty would be true is if the XML
        were invalid (e.g. if at a start tag, it's a given that there's at
        least one end tag left in the document unless it's invalid XML).

        However, of course, caution should be used to ensure that incorrect
        assumptions are not made that allow the document to reach its end
        earlier than predicted without throwing an $(LREF XMLParsingException),
        since it's still an error to call $(LREF2 front, EntityRange) or
        $(LREF2 popFront, EntityRange) if empty would return false.
      +/
    @property bool empty() @safe const pure nothrow @nogc
    {
        return _grammarPos == GrammarPos.documentEnd;
    }


    /++
        Forward range function for obtaining a copy of the range which can then
        be iterated independently of the original.
      +/
    @property auto save()
    {
        // The init check nonsense is because of ranges whose init values blow
        // up when save is called (e.g. a range that's a class).
        auto retval = this;
        if(retval._name !is typeof(retval._name).init)
            retval._name = _name.save;
        if(retval._text.input !is typeof(retval._text.input).init)
            retval._text.input = _text.input.save;
        if(retval._savedText.input !is typeof(retval._savedText.input).init)
            retval._savedText.input = _savedText.input.save;
        return retval;
    }

    static if(compileInTests) unittest
    {
        import std.algorithm.comparison : equal;
        import std.exception : assertNotThrown;
        import qt.widgets.internal.dxml.internal : testRangeFuncs;

        static bool cmpAttr(T)(T lhs, T rhs)
        {
            return equal(lhs.name.save, rhs.name.save) &&
                   equal(lhs.value.save, rhs.value.save);
        }

        static void testEqual(ER)(ER one, ER two)
        {
             while(!one.empty && !two.empty)
             {
                 auto left = one.front;
                 auto right = two.front;

                 assert(left.pos == right.pos);
                 assert(left.type == right.type);

                 with(EntityType) final switch(left.type)
                 {
                     case cdata: goto case text;
                     case comment: goto case text;
                     case elementStart:
                     {
                         assert(equal!cmpAttr(left.attributes, right.attributes));
                         goto case elementEnd;
                     }
                     case elementEnd: assert(equal(left.name, right.name)); break;
                     case elementEmpty: goto case elementStart;
                     case text: assert(equal(left.text, right.text)); break;
                     case pi: assert(equal(left.name, right.name)); goto case text;
                 }

                 one.popFront();
                 two.popFront();
             }

             assert(one.empty);
             assert(two.empty);
        }

         auto xml = "<root>\n" ~
                    "    <!-- comment -->\n" ~
                    "    <something>\n" ~
                    "         <else/>\n" ~
                    "         somet text <i>goes</i> here\n" ~
                    "    </something>\n" ~
                    "</root>";

        static foreach(i, func; testRangeFuncs)
        {{
             auto text = func(xml);
             testEqual(parseXML(text.save), parseXML(text.save));
             auto range = parseXML(text.save);
             testEqual(range.save, range.save);
        }}
    }


    /++
        Returns an empty range. This corresponds to
        $(PHOBOS_REF _takeNone, std, range) except that it doesn't create a
        wrapper type.
      +/
    EntityRange takeNone()
    {
        auto retval = save;
        retval._grammarPos = GrammarPos.documentEnd;
        return retval;
    }


private:

    void _parseDocumentStart()
    {
        auto orig = _text.save;
        immutable wasWS = _text.stripWS();
        if(_text.stripStartsWith("<?xml"))
        {
            if(wasWS)
                throw new XMLParsingException("Cannot have whitespace before the <?xml...?> declaration", TextPos.init);
            checkNotEmpty(_text);
            if(_text.input.front == '?' || isSpace(_text.input.front))
                _text.skipUntilAndDrop!"?>"();
            else
                _text = orig;
        }
        _grammarPos = GrammarPos.prologMisc1;
        _parseAtPrologMisc!1();
    }

    static if(compileInTests) unittest
    {
        import core.exception : AssertError;
        import std.exception : assertNotThrown, enforce;
        import qt.widgets.internal.dxml.internal : testRangeFuncs;

        static void test(alias func)(string xml, int row, int col, size_t line = __LINE__)
        {
            auto range = assertNotThrown!XMLParsingException(parseXML(func(xml)));
            enforce!AssertError(range._type == EntityType.elementEmpty, "unittest failure 1", __FILE__, line);
            enforce!AssertError(range._text.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }

        static foreach(func; testRangeFuncs)
        {
            test!func("<root/>", 1, 8);
            test!func("\n\t\n <root/>   \n", 3, 9);
            test!func("<?xml\n\n\nversion='1.8'\n\n\n\nencoding='UTF-8'\n\n\nstandalone='yes'\n?><root/>", 12, 10);
            test!func("<?xml\n\n\n    \r\r\r\n\nversion='1.8'?><root/>", 6, 23);
            test!func("<?xml\n\n\n    \r\r\r\n\nversion='1.8'?>\n     <root/>", 7, 13);
            test!func("<root/>", 1, 8);
            test!func("\n\t\n <root/>   \n", 3, 9);
        }
    }


    // Parse at GrammarPos.prologMisc1 or GrammarPos.prologMisc2.
    void _parseAtPrologMisc(int miscNum)()
    {
        static assert(miscNum == 1 || miscNum == 2);

        // document ::= prolog element Misc*
        // prolog   ::= XMLDecl? Misc* (doctypedecl Misc*)?
        // Misc ::= Comment | PI | S

        stripWS(_text);
        checkNotEmpty(_text);
        if(_text.input.front != '<')
            throw new XMLParsingException("Expected <", _text.pos);
        popFrontAndIncCol(_text);
        checkNotEmpty(_text);

        switch(_text.input.front)
        {
            // Comment     ::= '<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'
            // doctypedecl ::= '<!DOCTYPE' S Name (S ExternalID)? S? ('[' intSubset ']' S?)? '>'
            case '!':
            {
                immutable bangPos = _text.pos;
                popFrontAndIncCol(_text);
                if(_text.stripStartsWith("--"))
                {
                    _parseComment();
                    static if(config.skipComments == SkipComments.yes)
                        _parseAtPrologMisc!miscNum();
                    break;
                }
                static if(miscNum == 1)
                {
                    if(_text.stripStartsWith("DOCTYPE"))
                    {
                        if(!_text.stripWS())
                            throw new XMLParsingException("Whitespace must follow <!DOCTYPE", _text.pos);
                        _parseDoctypeDecl();
                        break;
                    }
                    throw new XMLParsingException("Expected Comment or DOCTYPE section", bangPos);
                }
                else
                {
                    if(_text.stripStartsWith("DOCTYPE"))
                    {
                        throw new XMLParsingException("Only one <!DOCTYPE ...> declaration allowed per XML document",
                                                      bangPos);
                    }
                    throw new XMLParsingException("Expected Comment", bangPos);
                }
            }
            // PI ::= '<?' PITarget (S (Char* - (Char* '?>' Char*)))? '?>'
            case '?':
            {
                _parsePI();
                static if(config.skipPI == SkipPI.yes)
                    popFront();
                break;
            }
            // element ::= EmptyElemTag | STag content ETag
            default:
            {
                _parseElementStart();
                break;
            }
        }
    }


    // Comment ::= '<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'
    // Parses a comment. <!-- was already removed from the front of the input.
    void _parseComment()
    {
        static if(config.skipComments == SkipComments.yes)
            _text.skipUntilAndDrop!"--"();
        else
        {
            _entityPos = TextPos(_text.pos.line, _text.pos.col - 4);
            _type = EntityType.comment;
            _tagStack.sawEntity();
            _savedText.pos = _text.pos;
            _savedText.input = _text.takeUntilAndDrop!"--"();
        }
        if(_text.input.empty || _text.input.front != '>')
            throw new XMLParsingException("Comments cannot contain -- and cannot be terminated by --->", _text.pos);
        // This is here rather than at the end of the previous static if block
        // so that the error message for improperly terminating a comment takes
        // precedence over the one involving invalid characters in the comment.
        static if(config.skipComments == SkipComments.no)
            checkText!true(_savedText);
        popFrontAndIncCol(_text);
    }

    static if(compileInTests) unittest
    {
        import core.exception : AssertError;
        import std.algorithm.comparison : equal;
        import std.exception : assertNotThrown, assertThrown, collectException, enforce;
        import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

        static void test(alias func)(string text, string expected, int row, int col, size_t line = __LINE__)
        {
            auto range = assertNotThrown!XMLParsingException(parseXML(func(text ~ "<root/>")));
            enforce!AssertError(range.front.type == EntityType.comment, "unittest failure 1", __FILE__, line);
            enforce!AssertError(equal(range.front.text, expected), "unittest failure 2", __FILE__, line);
            enforce!AssertError(range._text.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
        }

        static void testFail(alias func)(string text, int row, int col, size_t line = __LINE__)
        {
            auto e = collectException!XMLParsingException(parseXML(func(text ~ "<root/>")));
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }

        static foreach(func; testRangeFuncs)
        {
            test!func("<!--foo-->", "foo", 1, 11);
            test!func("<!-- foo -->", " foo ", 1, 13);
            test!func("<!-- -->", " ", 1, 9);
            test!func("<!---->", "", 1, 8);
            test!func("<!--- comment -->", "- comment ", 1, 18);
            test!func("<!-- \n foo \n -->", " \n foo \n ", 3, 5);
            test!func("<!--京都市 ディラン-->", "京都市 ディラン", 1, codeLen!(func, "<!--京都市 ディラン-->") + 1);
            test!func("<!--&-->", "&", 1, 9);
            test!func("<!--<-->", "<", 1, 9);
            test!func("<!-->-->", ">", 1, 9);
            test!func("<!--->-->", "->", 1, 10);

            testFail!func("<!", 1, 2);
            testFail!func("<!- comment -->", 1, 2);
            testFail!func("<!-- comment ->", 1, 5);
            testFail!func("<!-- comment --->", 1, 16);
            testFail!func("<!---- comment -->", 1, 7);
            testFail!func("<!-- comment -- comment -->", 1, 16);
            testFail!func("<!->", 1, 2);
            testFail!func("<!-->", 1, 5);
            testFail!func("<!--->", 1, 5);
            testFail!func("<!----->", 1, 7);
            testFail!func("<!blah>", 1, 2);
            testFail!func("<! blah>", 1, 2);
            testFail!func("<!-- \n\n   \v \n -->", 3, 4);
            testFail!func("<!--京都市 ディラン\v-->", 1, codeLen!(func, "<!--京都市 ディラン\v"));

            {
                auto xml = func("<!DOCTYPE foo><!-- comment --><root/>");
                auto range = assertNotThrown!XMLParsingException(parseXML(xml));
                assert(range.front.type == EntityType.comment);
                assert(equal(range.front.text, " comment "));
            }
            {
                auto xml = func("<root><!-- comment --></root>");
                auto range = assertNotThrown!XMLParsingException(parseXML(xml));
                assertNotThrown!XMLParsingException(range.popFront());
                assert(range.front.type == EntityType.comment);
                assert(equal(range.front.text, " comment "));
            }
            {
                auto xml = func("<root/><!-- comment -->");
                auto range = assertNotThrown!XMLParsingException(parseXML(xml));
                assertNotThrown!XMLParsingException(range.popFront());
                assert(range.front.type == EntityType.comment);
                assert(equal(range.front.text, " comment "));
            }

            static foreach(comment; ["<!foo>", "<! foo>", "<!->", "<!-->", "<!--->"])
            {
                {
                    auto xml = func("<!DOCTYPE foo>" ~ comment ~ "<root/>");
                    assertThrown!XMLParsingException(parseXML(xml));
                }
                {
                    auto xml = func("<root>" ~ comment ~ "<root>");
                    auto range = assertNotThrown!XMLParsingException(parseXML(xml));
                    assertThrown!XMLParsingException(range.popFront());
                }
                {
                    auto xml = func("<root/>" ~ comment);
                    auto range = assertNotThrown!XMLParsingException(parseXML(xml));
                    assertThrown!XMLParsingException(range.popFront());
                }
            }

            {
                auto xml = "<!--one-->\n" ~
                           "<!--two-->\n" ~
                           "<root>\n" ~
                           "    <!--three-->\n" ~
                           "    <!--four-->\n" ~
                           "</root>\n" ~
                           "<!--five-->\n" ~
                           "<!--six-->";

                auto text = func(xml);
                {
                    auto range = parseXML(text.save);
                    assert(range.front.type == EntityType.comment);
                    assert(equal(range.front.text, "one"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.comment);
                    assert(equal(range.front.text, "two"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.elementStart);
                    assert(equal(range.front.name, "root"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.comment);
                    assert(equal(range.front.text, "three"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.comment);
                    assert(equal(range.front.text, "four"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.elementEnd);
                    assert(equal(range.front.name, "root"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.comment);
                    assert(equal(range.front.text, "five"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.comment);
                    assert(equal(range.front.text, "six"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.empty);
                }
                {
                    auto range = parseXML!simpleXML(text.save);
                    assert(range.front.type == EntityType.elementStart);
                    assert(equal(range.front.name, "root"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.elementEnd);
                    assert(equal(range.front.name, "root"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.empty);
                }
            }
        }
    }


    // PI       ::= '<?' PITarget (S (Char* - (Char* '?>' Char*)))? '?>'
    // PITarget ::= Name - (('X' | 'x') ('M' | 'm') ('L' | 'l'))
    // Parses a processing instruction. < was already removed from the input.
    void _parsePI()
    {
        _entityPos = TextPos(_text.pos.line, _text.pos.col - 1);
        assert(_text.input.front == '?');
        popFrontAndIncCol(_text);
        static if(config.skipPI == SkipPI.yes)
            _text.skipUntilAndDrop!"?>"();
        else
        {
            immutable posAtName = _text.pos;
            if(_text.input.empty)
                throw new XMLParsingException("Unterminated processing instruction", posAtName);
            _type = EntityType.pi;
            _tagStack.sawEntity();
            _name = takeName!'?'(_text);
            immutable posAtWS = _text.pos;
            stripWS(_text);
            checkNotEmpty(_text);
            _savedText.pos = _text.pos;
            _savedText.input = _text.takeUntilAndDrop!"?>"();
            checkText!true(_savedText);
            if(walkLength(_name.save) == 3)
            {
                // FIXME icmp doesn't compile right now due to an issue with
                // byUTF that needs to be looked into.
                /+
                import std.uni : icmp;
                if(icmp(_name.save, "xml") == 0)
                    throw new XMLParsingException("Processing instructions cannot be named xml", posAtName);
                +/
                auto temp = _name.save;
                if(temp.front == 'x' || temp.front == 'X')
                {
                    temp.popFront();
                    if(temp.front == 'm' || temp.front == 'M')
                    {
                        temp.popFront();
                        if(temp.front == 'l' || temp.front == 'L')
                            throw new XMLParsingException("Processing instructions cannot be named xml", posAtName);
                    }
                }
            }
        }
    }

    static if(compileInTests) unittest
    {
        import core.exception : AssertError;
        import std.algorithm.comparison : equal;
        import std.exception : assertNotThrown, assertThrown, collectException, enforce;
        import std.utf : byUTF;
        import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

        static void test(alias func)(string text, string name, string expected,
                                     int row, int col, size_t line = __LINE__)
        {
            auto range = assertNotThrown!XMLParsingException(parseXML(func(text ~ "<root/>")),
                                                             "unittest failure 1", __FILE__, line);
            enforce!AssertError(range.front.type == EntityType.pi, "unittest failure 2", __FILE__, line);
            enforce!AssertError(equal(range.front.name, name), "unittest failure 3", __FILE__, line);
            enforce!AssertError(equal(range.front.text, expected), "unittest failure 4", __FILE__, line);
            enforce!AssertError(range._text.pos == TextPos(row, col), "unittest failure 5", __FILE__, line);
        }

        static void testFail(alias func)(string text, int row, int col, size_t line = __LINE__)
        {
            auto e = collectException!XMLParsingException(parseXML(func(text ~ "<root/>")));
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }

        static foreach(func; testRangeFuncs)
        {
            test!func("<?a?>", "a", "", 1, 6);
            test!func("<?foo?>", "foo", "", 1, 8);
            test!func("<?foo.?>", "foo.", "", 1, 9);
            test!func("<?foo bar?>", "foo", "bar", 1, 12);
            test!func("<?xmf bar?>", "xmf", "bar", 1, 12);
            test!func("<?xmlfoo bar?>", "xmlfoo", "bar", 1, 15);
            test!func("<?foo bar baz?>", "foo", "bar baz", 1, 16);
            test!func("<?foo\nbar baz?>", "foo", "bar baz", 2, 10);
            test!func("<?foo \n bar baz?>", "foo", "bar baz", 2, 11);
            test!func("<?foo bar\nbaz?>", "foo", "bar\nbaz", 2, 6);
            test!func("<?dlang is awesome?>", "dlang", "is awesome", 1, 21);
            test!func("<?dlang is awesome! ?>", "dlang", "is awesome! ", 1, 23);
            test!func("<?dlang\n\nis\n\nawesome\n\n?>", "dlang", "is\n\nawesome\n\n", 7, 3);
            test!func("<?京都市 ディラン?>", "京都市", "ディラン", 1, codeLen!(func, "<?京都市 ディラン?>") + 1);
            test!func("<?foo bar&baz?>", "foo", "bar&baz", 1, 16);
            test!func("<?foo bar<baz?>", "foo", "bar<baz", 1, 16);
            test!func("<?pi ?>", "pi", "", 1, 8);
            test!func("<?pi\n?>", "pi", "", 2, 3);
            test!func("<?foo ??>", "foo", "?", 1, 10);
            test!func("<?pi some data ? > <??>", "pi", "some data ? > <?", 1, 24);

            testFail!func("<?", 1, 3);
            testFail!func("<??>", 1, 3);
            testFail!func("<? ?>", 1, 3);
            testFail!func("<?xml?><?xml?>", 1, 10);
            testFail!func("<?XML?>", 1, 3);
            testFail!func("<?xMl?>", 1, 3);
            testFail!func("<?foo>", 1, 6);
            testFail!func("<? foo?>", 1, 3);
            testFail!func("<?\nfoo?>", 1, 3);
            testFail!func("<??foo?>", 1, 3);
            testFail!func("<?.foo?>", 1, 3);
            testFail!func("<?foo bar\vbaz?>", 1, 10);

            {
                auto xml = func("<!DOCTYPE foo><?foo bar?><root/>");
                auto range = assertNotThrown!XMLParsingException(parseXML(xml));
                assert(range.front.type == EntityType.pi);
                assert(equal(range.front.name, "foo"));
                assert(equal(range.front.text, "bar"));
            }
            {
                auto xml = func("<root><?foo bar?></root>");
                auto range = assertNotThrown!XMLParsingException(parseXML(xml));
                assertNotThrown!XMLParsingException(range.popFront());
                assert(equal(range.front.name, "foo"));
                assert(equal(range.front.text, "bar"));
            }
            {
                auto xml = func("<root/><?foo bar?>");
                auto range = assertNotThrown!XMLParsingException(parseXML(xml));
                assertNotThrown!XMLParsingException(range.popFront());
                assert(equal(range.front.name, "foo"));
                assert(equal(range.front.text, "bar"));
            }

            static foreach(pi; ["<?foo>", "<foo?>", "<? foo>"])
            {
                {
                    auto xml = func("<!DOCTYPE foo>" ~ pi ~ "<root/>");
                    assertThrown!XMLParsingException(parseXML(xml));
                }
                {
                    auto xml = func("<root>" ~ pi ~ "<root>");
                    auto range = assertNotThrown!XMLParsingException(parseXML(xml));
                    assertThrown!XMLParsingException(range.popFront());
                }
                {
                    auto xml = func("<root/>" ~ pi);
                    auto range = assertNotThrown!XMLParsingException(parseXML(xml));
                    assertThrown!XMLParsingException(range.popFront());
                }
            }

            {
                auto xml = "<?one?>\n" ~
                           "<?two?>\n" ~
                           "<root>\n" ~
                           "    <?three?>\n" ~
                           "    <?four?>\n" ~
                           "</root>\n" ~
                           "<?five?>\n" ~
                           "<?six?>";

                auto text = func(xml);
                {
                    auto range = parseXML(text.save);
                    assert(range.front.type == EntityType.pi);
                    assert(equal(range.front.name, "one"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.pi);
                    assert(equal(range.front.name, "two"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.elementStart);
                    assert(equal(range.front.name, "root"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.pi);
                    assert(equal(range.front.name, "three"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.pi);
                    assert(equal(range.front.name, "four"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.elementEnd);
                    assert(equal(range.front.name, "root"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.pi);
                    assert(equal(range.front.name, "five"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.pi);
                    assert(equal(range.front.name, "six"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.empty);
                }
                {
                    auto range = parseXML!simpleXML(text.save);
                    assert(range.front.type == EntityType.elementStart);
                    assert(equal(range.front.name, "root"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.front.type == EntityType.elementEnd);
                    assert(equal(range.front.name, "root"));
                    assertNotThrown!XMLParsingException(range.popFront());
                    assert(range.empty);
                }
            }
        }
    }


    // CDSect  ::= CDStart CData CDEnd
    // CDStart ::= '<![CDATA['
    // CData   ::= (Char* - (Char* ']]>' Char*))
    // CDEnd   ::= ']]>'
    // Parses a CDATA. <![CDATA[ was already removed from the front of the input.
    void _parseCDATA()
    {
        _entityPos = TextPos(_text.pos.line, _text.pos.col - cast(int)"<![CDATA[".length);
        _type = EntityType.cdata;
        _tagStack.sawEntity();
        _savedText.pos = _text.pos;
        _savedText.input = _text.takeUntilAndDrop!"]]>";
        checkText!true(_savedText);
        _grammarPos = GrammarPos.contentCharData2;
    }

    static if(compileInTests) unittest
    {
        import core.exception : AssertError;
        import std.algorithm.comparison : equal;
        import std.exception : assertNotThrown, collectException, enforce;
        import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

        static void test(alias func)(string text, string expected, int row, int col, size_t line = __LINE__)
        {
            auto pos = TextPos(row, col + (row == 1 ? cast(int)"<root>".length : 0));
            auto range = parseXML(func("<root>" ~ text ~ "<root/>"));
            assertNotThrown!XMLParsingException(range.popFront());
            enforce!AssertError(range.front.type == EntityType.cdata, "unittest failure 1", __FILE__, line);
            enforce!AssertError(equal(range.front.text, expected), "unittest failure 2", __FILE__, line);
            enforce!AssertError(range._text.pos == pos, "unittest failure 3", __FILE__, line);
        }

        static void testFail(alias func)(string text, int row, int col, size_t line = __LINE__)
        {
            auto pos = TextPos(row, col + (row == 1 ? cast(int)"<root>".length : 0));
            auto range = parseXML(func("<root>" ~ text ~ "<root/>"));
            auto e = collectException!XMLParsingException(range.popFront());
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == pos, "unittest failure 2", __FILE__, line);
        }

        static foreach(func; testRangeFuncs)
        {
            test!func("<![CDATA[]]>", "", 1, 13);
            test!func("<![CDATA[hello world]]>", "hello world", 1, 24);
            test!func("<![CDATA[\nhello\n\nworld\n]]>", "\nhello\n\nworld\n", 5, 4);
            test!func("<![CDATA[京都市]]>", "京都市", 1, codeLen!(func, "<![CDATA[京都市]>") + 2);
            test!func("<![CDATA[<><><><><<<<>>>>>> ] ] ]> <]> <<>> ][][] >> ]]>",
                      "<><><><><<<<>>>>>> ] ] ]> <]> <<>> ][][] >> ", 1, 57);
            test!func("<![CDATA[&]]>", "&", 1, 14);

            testFail!func("<[CDATA[]>", 1, 2);
            testFail!func("<![CDAT[]>", 1, 2);
            testFail!func("<![CDATA]>", 1, 2);
            testFail!func("<![CDATA[>", 1, 10);
            testFail!func("<![CDATA[]", 1, 10);
            testFail!func("<![CDATA[]>", 1, 10);
            testFail!func("<![CDATA[ \v ]]>", 1, 11);
            testFail!func("<![CDATA[ \n\n \v \n ]]>", 3, 2);
        }
    }


    // doctypedecl ::= '<!DOCTYPE' S Name (S ExternalID)? S? ('[' intSubset ']' S?)? '>'
    // DeclSep     ::= PEReference | S
    // intSubset   ::= (markupdecl | DeclSep)*
    // markupdecl  ::= elementdecl | AttlistDecl | EntityDecl | NotationDecl | PI | Comment
    // Parse doctypedecl after GrammarPos.prologMisc1.
    // <!DOCTYPE and any whitespace after it should have already been removed
    // from the input.
    void _parseDoctypeDecl()
    {
        outer: while(true)
        {
            _text.skipToOneOf!('"', '\'', '[', '>')();
            switch(_text.input.front)
            {
                static foreach(quote; ['"', '\''])
                {
                    case quote:
                    {
                        popFrontAndIncCol(_text);
                        _text.skipUntilAndDrop!([quote])();
                        continue outer;
                    }
                }
                case '[':
                {
                    popFrontAndIncCol(_text);
                    while(true)
                    {
                        checkNotEmpty(_text);
                        _text.skipToOneOf!('"', '\'', ']')();
                        switch(_text.input.front)
                        {
                            case '"':
                            {
                                popFrontAndIncCol(_text);
                                _text.skipUntilAndDrop!`"`();
                                continue;
                            }
                            case '\'':
                            {
                                popFrontAndIncCol(_text);
                                _text.skipUntilAndDrop!`'`();
                                continue;
                            }
                            case ']':
                            {
                                popFrontAndIncCol(_text);
                                stripWS(_text);
                                if(_text.input.empty || _text.input.front != '>')
                                    throw new XMLParsingException("Incorrectly terminated <!DOCTYPE> section.", _text.pos);
                                popFrontAndIncCol(_text);
                                _parseAtPrologMisc!2();
                                return;
                            }
                            default: assert(0);
                        }
                    }
                }
                case '>':
                {
                    popFrontAndIncCol(_text);
                    _parseAtPrologMisc!2();
                    break;
                }
                default: assert(0);
            }
            break;
        }
    }

    static if(compileInTests) unittest
    {
        import core.exception : AssertError;
        import std.exception : assertNotThrown, collectException, enforce;
        import qt.widgets.internal.dxml.internal : testRangeFuncs;

        static void test(alias func)(string text, int row, int col, size_t line = __LINE__)
        {
            auto pos = TextPos(row, col + cast(int)"<root/>".length);
            auto range = assertNotThrown!XMLParsingException(parseXML(func(text ~ "<root/>")),
                                                             "unittest failure 1", __FILE__, line);
            enforce!AssertError(range.front.type == EntityType.elementEmpty, "unittest failure 2", __FILE__, line);
            enforce!AssertError(range._text.pos == pos, "unittest failure 3", __FILE__, line);
        }

        static void testFail(alias func)(string text, int row, int col, size_t line = __LINE__)
        {
            auto e = collectException!XMLParsingException(parseXML(func(text ~ "<root/>")));
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }

        static foreach(func; testRangeFuncs)
        {
            test!func("<!DOCTYPE name>", 1, 16);
            test!func("<!DOCTYPE \n\n\n name>", 4, 7);
            test!func("<!DOCTYPE name \n\n\n >", 4, 3);

            test!func("<!DOCTYPE name []>", 1, 19);
            test!func("<!DOCTYPE \n\n\n name []>", 4, 10);
            test!func("<!DOCTYPE name \n\n\n []>", 4, 5);

            test!func(`<!DOCTYPE name PUBLIC "'''" '"""'>`, 1, 35);
            test!func(`<!DOCTYPE name PUBLIC "'''" '"""' []>`, 1, 38);
            test!func(`<!DOCTYPE name PUBLIC 'foo' "'''">`, 1, 35);
            test!func(`<!DOCTYPE name PUBLIC 'foo' '"""' []>`, 1, 38);

            test!func("<!DOCTYPE name [ <!ELEMENT foo EMPTY > ]>", 1, 42);
            test!func("<!DOCTYPE name [ <!ELEMENT bar ANY > ]>", 1, 40);
            test!func("<!DOCTYPE name [ <!ELEMENT mixed (#PCDATA) > ]>", 1, 48);
            test!func("<!DOCTYPE name [ <!ELEMENT mixed (#PCDATA | foo)> ]>", 1, 53);
            test!func("<!DOCTYPE name [ <!ELEMENT kids (foo) > ]>", 1, 43);
            test!func("<!DOCTYPE name [ <!ELEMENT kids (foo | bar)> ]>", 1, 48);

            test!func("<!DOCTYPE name [ <!ATTLIST foo> ]>", 1, 35);
            test!func("<!DOCTYPE name [ <!ATTLIST foo def CDATA #REQUIRED> ]>", 1, 55);

            test!func(`<!DOCTYPE name [ <!ENTITY foo "bar"> ]>`, 1, 40);
            test!func(`<!DOCTYPE name [ <!ENTITY foo 'bar'> ]>`, 1, 40);
            test!func(`<!DOCTYPE name [ <!ENTITY foo SYSTEM 'sys'> ]>`, 1, 47);
            test!func(`<!DOCTYPE name [ <!ENTITY foo PUBLIC "'''" 'sys'> ]>`, 1, 53);

            test!func(`<!DOCTYPE name [ <!NOTATION note PUBLIC 'blah'> ]>`, 1, 51);

            test!func("<!DOCTYPE name [ <?pi> ]>", 1, 26);

            test!func("<!DOCTYPE name [ <!-- coment --> ]>", 1, 36);

            test!func("<!DOCTYPE name [ <?pi> <!----> <!ELEMENT blah EMPTY> ]>", 1, 56);
            test!func("<!DOCTYPE \nname\n[\n<?pi> \n <!---->\n<!ENTITY foo '\n\n'\n>\n]>", 10, 3);

            test!func("<!DOCTYPE doc [\n" ~
                      "<!ENTITY e '<![CDATA[Tim Michael]]>'>\n" ~
                      "]>\n", 4, 1);

            testFail!func("<!DOCTYP name>", 1, 2);
            testFail!func("<!DOCTYPEname>", 1, 10);
            testFail!func("<!DOCTYPE name1><!DOCTYPE name2>", 1, 18);
            testFail!func("<!DOCTYPE\n\nname1><!DOCTYPE name2>", 3, 8);
            testFail!func("<!DOCTYPE name [ ]<!--comment-->", 1, 19);

            // FIXME This really should have the exception point at the quote and
            // say that it couldn't find the matching quote rather than point at
            // the character after it and say that it couldn't find a quote, but
            // that requires reworking some helper functions with better error
            // messages in mind.
            testFail!func(`<!DOCTYPE student SYSTEM "student".dtd"[` ~
                          "\n<!ELEMENT student (#PCDATA)>\n" ~
                          "]>", 1, 40);
        }
    }


    // Parse a start tag or empty element tag. It could be the root element, or
    // it could be a sub-element.
    // < was already removed from the front of the input.
    void _parseElementStart()
    {
        _entityPos = TextPos(_text.pos.line, _text.pos.col - 1);
        _savedText.pos = _text.pos;
        _savedText.input = _text.takeUntilAndDrop!(">", true)();

        if(_savedText.input.empty)
            throw new XMLParsingException("Tag missing name", _savedText.pos);
        if(_savedText.input.front == '/')
            throw new XMLParsingException("Invalid end tag", _savedText.pos);

        if(_savedText.input.length > 1)
        {
            auto temp = _savedText.input.save;
            temp.popFrontN(temp.length - 1);
            if(temp.front == '/')
            {
                _savedText.input = _savedText.input.takeExactly(_savedText.input.length - 1);

                static if(config.splitEmpty == SplitEmpty.no)
                {
                    _type = EntityType.elementEmpty;
                    _tagStack.sawEntity();
                    _grammarPos = _tagStack.depth == 0 ? GrammarPos.endMisc : GrammarPos.contentCharData2;
                }
                else
                {
                    _type = EntityType.elementStart;
                    _tagStack.sawEntity();
                    _grammarPos = GrammarPos.splittingEmpty;
                }
            }
            else
            {
                _type = EntityType.elementStart;
                _tagStack.sawEntity();
                _grammarPos = GrammarPos.contentCharData1;
            }
        }
        else
        {
            _type = EntityType.elementStart;
            _tagStack.sawEntity();
            _grammarPos = GrammarPos.contentCharData1;
        }

        _name = _savedText.takeName();
        // The attributes should be all that's left in savedText.
        if(_tagStack.atMax)
        {
            auto temp = _savedText.save;
            auto attrChecker = _tagStack.attrChecker;

            while(true)
            {
                immutable wasWS = stripWS(temp);
                if(temp.input.empty)
                    break;
                if(!wasWS)
                    throw new XMLParsingException("Whitespace missing before attribute name", temp.pos);

                immutable attrPos = temp.pos;
                attrChecker.pushAttr(temp.takeName!'='(), attrPos);
                stripWS(temp);

                checkNotEmpty(temp);
                if(temp.input.front != '=')
                    throw new XMLParsingException("= missing", temp.pos);
                popFrontAndIncCol(temp);

                stripWS(temp);
                temp.takeAttValue();
            }

            attrChecker.checkAttrs();
        }
    }

    static if(compileInTests) unittest
    {
        import core.exception : AssertError;
        import std.algorithm.comparison : equal;
        import std.exception : assertNotThrown, collectException, enforce;
        import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

        static void test(alias func)(string text, EntityType type, string name,
                                     int row, int col, size_t line = __LINE__)
        {
            auto range = assertNotThrown!XMLParsingException(parseXML(func(text)));
            enforce!AssertError(range.front.type == type, "unittest failure 1", __FILE__, line);
            enforce!AssertError(equal(range.front.name, name), "unittest failure 2", __FILE__, line);
            enforce!AssertError(range._text.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
        }

        static void testFail(alias func)(string text, int row, int col, size_t line = __LINE__)
        {
            auto xml = func(text);
            auto e = collectException!XMLParsingException(parseXML(func(text)));
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }

        static foreach(func; testRangeFuncs)
        {
            test!func("<a/>", EntityType.elementEmpty, "a", 1, 5);
            test!func("<a></a>", EntityType.elementStart, "a", 1, 4);
            test!func("<root/>", EntityType.elementEmpty, "root", 1, 8);
            test!func("<root></root>", EntityType.elementStart, "root", 1, 7);
            test!func("<foo/>", EntityType.elementEmpty, "foo", 1, 7);
            test!func("<foo></foo>", EntityType.elementStart, "foo", 1, 6);
            test!func("<foo       />", EntityType.elementEmpty, "foo", 1, 14);
            test!func("<foo       ></foo>", EntityType.elementStart, "foo", 1, 13);
            test!func("<foo  \n\n\n />", EntityType.elementEmpty, "foo", 4, 4);
            test!func("<foo  \n\n\n ></foo>", EntityType.elementStart, "foo", 4, 3);
            test!func("<foo.></foo.>", EntityType.elementStart, "foo.", 1, 7);
            test!func(`<京都市></京都市>`, EntityType.elementStart, "京都市", 1, codeLen!(func, `<京都市>`) + 1);

            testFail!func(`<.foo/>`, 1, 2);
            testFail!func(`<>`, 1, 2);
            testFail!func(`</>`, 1, 2);
            testFail!func(`</foo>`, 1, 2);

            {
                auto range = assertNotThrown!XMLParsingException(parseXML!simpleXML(func("<root/>")));
                assert(range.front.type == EntityType.elementStart);
                assert(equal(range.front.name, "root"));
                assert(range._text.pos == TextPos(1, 8));
                assertNotThrown!XMLParsingException(range.popFront());
                assert(range.front.type == EntityType.elementEnd);
                assert(equal(range.front.name, "root"));
                assert(range._text.pos == TextPos(1, 8));
            }
        }
    }


    // Parse an end tag. It could be the root element, or it could be a
    // sub-element.
    // </ was already removed from the front of the input.
    void _parseElementEnd()
    {
        if(_text.input.empty)
            throw new XMLParsingException("Unterminated end tag", _text.pos);
        _entityPos = TextPos(_text.pos.line, _text.pos.col - 2);
        _type = EntityType.elementEnd;
        _tagStack.sawEntity();
        immutable namePos = _text.pos;
        _name = _text.takeName!'>'();
        stripWS(_text);
        if(_text.input.empty || _text.input.front != '>')
        {
            throw new XMLParsingException("There can only be whitespace between an end tag's name and the >",
                                          _text.pos);
        }
        popFrontAndIncCol(_text);
        _tagStack.popTag(_name.save, namePos);
        _grammarPos = _tagStack.depth == 0 ? GrammarPos.endMisc : GrammarPos.contentCharData2;
    }

    static if(compileInTests) unittest
    {
        import core.exception : AssertError;
        import std.algorithm.comparison : equal;
        import std.exception : assertNotThrown, collectException, enforce;
        import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

        static void test(alias func)(string text, string name, int row, int col, size_t line = __LINE__)
        {
            auto range = assertNotThrown!XMLParsingException(parseXML(func(text)));
            range.popFront();
            enforce!AssertError(range.front.type == EntityType.elementEnd, "unittest failure 1", __FILE__, line);
            enforce!AssertError(equal(range.front.name, name), "unittest failure 2", __FILE__, line);
            enforce!AssertError(range._text.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
        }

        static void testFail(alias func)(string text, int row, int col, size_t line = __LINE__)
        {
            auto range = parseXML(func(text));
            auto e = collectException!XMLParsingException(range.popFront());
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }

        static foreach(func; testRangeFuncs)
        {
            test!func("<a></a>", "a", 1, 8);
            test!func("<foo></foo>", "foo", 1, 12);
            test!func("<foo    ></foo    >", "foo", 1, 20);
            test!func("<foo \n ></foo \n >", "foo", 3, 3);
            test!func("<foo>\n\n\n</foo>", "foo", 4, 7);
            test!func("<foo.></foo.>", "foo.", 1, 14);
            test!func(`<京都市></京都市>`, "京都市", 1, codeLen!(func, `<京都市></京都市>`) + 1);

            testFail!func(`<foo></ foo>`, 1, 8);
            testFail!func(`<foo></bar>`, 1, 8);
            testFail!func(`<foo></fo>`, 1, 8);
            testFail!func(`<foo></food>`, 1, 8);
            testFail!func(`<a></>`, 1, 6);
            testFail!func(`<a></`, 1, 6);
            testFail!func(`<a><`, 1, 5);
            testFail!func(`<a></a b='42'>`, 1, 8);
        }
    }


    // GrammarPos.contentCharData1
    // content ::= CharData? ((element | Reference | CDSect | PI | Comment) CharData?)*
    // Parses at either CharData?. Nothing from the CharData? (or what's after it
    // if it's not there) has been consumed.
    void _parseAtContentCharData()
    {
        checkNotEmpty(_text);
        auto orig = _text.save;
        stripWS(_text);
        checkNotEmpty(_text);
        if(_text.input.front != '<')
        {
            _text = orig;
            _entityPos = _text.pos;
            _type = EntityType.text;
            _tagStack.sawEntity();
            _savedText.pos = _text.pos;
            _savedText.input = _text.takeUntilAndDrop!"<"();
            checkText!false(_savedText);
            checkNotEmpty(_text);
            if(_text.input.front == '/')
            {
                popFrontAndIncCol(_text);
                _grammarPos = GrammarPos.endTag;
            }
            else
                _grammarPos = GrammarPos.contentMid;
        }
        else
        {
            popFrontAndIncCol(_text);
            checkNotEmpty(_text);
            if(_text.input.front == '/')
            {
                popFrontAndIncCol(_text);
                _parseElementEnd();
            }
            else
                _parseAtContentMid();
        }
    }

    static if(compileInTests) unittest
    {
        import core.exception : AssertError;
        import std.algorithm.comparison : equal;
        import std.exception : assertNotThrown, collectException, enforce;
        import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

        static void test(alias func, ThrowOnEntityRef toer)(string text, int row, int col, size_t line = __LINE__)
        {
            auto pos = TextPos(row, col + (cast(int)(row == 1 ? "<root></" : "</").length));
            auto range = parseXML!(makeConfig(toer))(func("<root>" ~ text ~ "</root>"));
            assertNotThrown!XMLParsingException(range.popFront());
            enforce!AssertError(range.front.type == EntityType.text, "unittest failure 1", __FILE__, line);
            enforce!AssertError(equal(range.front.text, text), "unittest failure 2", __FILE__, line);
            enforce!AssertError(range._text.pos == pos, "unittest failure 3", __FILE__, line);
        }

        static void testFail(alias func, ThrowOnEntityRef toer)(string text, int row, int col, size_t line = __LINE__)
        {
            auto pos = TextPos(row, col + (row == 1 ? cast(int)"<root>".length : 0));
            auto range = parseXML!(makeConfig(toer))(func("<root>" ~ text ~ "</root>"));
            auto e = collectException!XMLParsingException(range.popFront());
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == pos, "unittest failure 2", __FILE__, line);
        }

        static foreach(func; testRangeFuncs)
        {
            static foreach(toer; [ThrowOnEntityRef.yes, ThrowOnEntityRef.no])
            {
                test!(func, toer)("hello world", 1, 12);
                test!(func, toer)("\nhello\n\nworld", 4, 6);
                test!(func, toer)("京都市", 1, codeLen!(func, "京都市") + 1);
                test!(func, toer)("&#x42;", 1, 7);
                test!(func, toer)("]", 1, 2);
                test!(func, toer)("]]", 1, 3);
                test!(func, toer)("]>", 1, 3);
                test!(func, toer)("foo \n\n &lt; \n bar", 4, 5);

                testFail!(func, toer)("&", 1, 1);
                testFail!(func, toer)("&;", 1, 1);
                testFail!(func, toer)("&f", 1, 1);
                testFail!(func, toer)("\v", 1, 1);
                testFail!(func, toer)("hello&world", 1, 6);
                testFail!(func, toer)("hello\vworld", 1, 6);
                testFail!(func, toer)("hello&;world", 1, 6);
                testFail!(func, toer)("hello&#;world", 1, 6);
                testFail!(func, toer)("hello&#x;world", 1, 6);
                testFail!(func, toer)("hello&.;world", 1, 6);
                testFail!(func, toer)("\n\nfoo\nbar&.;", 4, 4);

                testFail!(func, toer)("]]>", 1, 1);
                testFail!(func, toer)("foo]]>bar", 1, 4);

                static if(toer == ThrowOnEntityRef.yes)
                {
                    testFail!(func, toer)("&foo; &bar baz", 1, 1);
                    testFail!(func, toer)("foo \n\n &ampe; \n bar", 3, 2);
                }
                else
                {
                    testFail!(func, toer)("&foo; &bar baz", 1, 7);
                    test!(func, toer)("foo \n\n &ampe; \n bar", 4, 5);
                }
            }
        }
    }


    // GrammarPos.contentMid
    // content     ::= CharData? ((element | Reference | CDSect | PI | Comment) CharData?)*
    // The text right after the start tag was what was parsed previously. So,
    // that first CharData? was what was parsed last, and this parses starting
    // right after. The < should have already been removed from the input.
    void _parseAtContentMid()
    {
        // Note that References are treated as part of the CharData and not
        // parsed out by the EntityRange (see EntityRange.text).

        switch(_text.input.front)
        {
            // Comment ::= '<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'
            // CDSect  ::= CDStart CData CDEnd
            // CDStart ::= '<![CDATA['
            // CData   ::= (Char* - (Char* ']]>' Char*))
            // CDEnd   ::= ']]>'
            case '!':
            {
                popFrontAndIncCol(_text);
                if(_text.stripStartsWith("--"))
                {
                    _parseComment();
                    static if(config.skipComments == SkipComments.yes)
                        _parseAtContentCharData();
                    else
                        _grammarPos = GrammarPos.contentCharData2;
                }
                else if(_text.stripStartsWith("[CDATA["))
                    _parseCDATA();
                else
                {
                    immutable bangPos = TextPos(_text.pos.line, _text.pos.col - 1);
                    throw new XMLParsingException("Expected Comment or CDATA section", bangPos);
                }
                break;
            }
            // PI ::= '<?' PITarget (S (Char* - (Char* '?>' Char*)))? '?>'
            case '?':
            {
                _parsePI();
                _grammarPos = GrammarPos.contentCharData2;
                static if(config.skipPI == SkipPI.yes)
                    popFront();
                break;
            }
            // element ::= EmptyElemTag | STag content ETag
            default:
            {
                _parseElementStart();
                break;
            }
        }
    }


    // This parses the Misc* that come after the root element.
    void _parseAtEndMisc()
    {
        // Misc ::= Comment | PI | S

        stripWS(_text);

        if(_text.input.empty)
        {
            _grammarPos = GrammarPos.documentEnd;
            return;
        }

        if(_text.input.front != '<')
            throw new XMLParsingException("Expected <", _text.pos);
        popFrontAndIncCol(_text);
        checkNotEmpty(_text);

        switch(_text.input.front)
        {
            // Comment ::= '<!--' ((Char - '-') | ('-' (Char - '-')))* '-->'
            case '!':
            {
                popFrontAndIncCol(_text);
                if(_text.stripStartsWith("--"))
                {
                    _parseComment();
                    static if(config.skipComments == SkipComments.yes)
                        _parseAtEndMisc();
                    break;
                }
                immutable bangPos = TextPos(_text.pos.line, _text.pos.col - 1);
                throw new XMLParsingException("Expected Comment", bangPos);
            }
            // PI ::= '<?' PITarget (S (Char* - (Char* '?>' Char*)))? '?>'
            case '?':
            {
                _parsePI();
                static if(config.skipPI == SkipPI.yes)
                    popFront();
                break;
            }
            default: throw new XMLParsingException("Must be a comment or PI", _text.pos);
        }
    }

    // Used for keeping track of the names of start tags so that end tags can be
    // verified as well as making it possible to avoid redoing other validation.
    // We keep track of the total number of entities which have been parsed thus
    // far so that only whichever EntityRange is farthest along in parsing
    // actually adds or removes tags from the TagStack, and the parser can skip
    // some of the validation for ranges that are farther behind. That way, the
    // end tags get verified, but we only have one stack. If the stack were
    // duplicated with every call to save, then there would be a lot more
    // allocations, which we don't want. But because we only need to verify the
    // end tags once, we can get away with having a shared tag stack. The cost
    // is that we have to keep track of how many tags we've parsed so that we
    // know if an EntityRange should actually be pushing or popping tags from
    // the stack, but that's a lot cheaper than duplicating the stack, and it's
    // a lot less annoying then making EntityRange an input range and not a
    // forward range or making it a cursor rather than a range.
    struct TagStack
    {
        void pushTag(Taken tagName)
        {
            if(entityCount++ == state.maxEntities)
            {
                ++state.maxEntities;
                put(state.tags, tagName);
            }
            ++depth;
        }

        void popTag(Taken tagName, TextPos pos)
        {
            import std.algorithm : equal;
            import std.format : format;
            if(entityCount++ == state.maxEntities)
            {
                assert(!state.tags.data.empty);
                if(!equal(state.tags.data.back.save, tagName.save))
                {
                    enum fmt = "Name of end tag </%s> does not match corresponding start tag <%s>";
                    throw new XMLParsingException(format!fmt(tagName, state.tags.data.back), pos);
                }
                ++state.maxEntities;
                state.tags.shrinkTo(state.tags.data.length - 1);
            }
            --depth;
        }

        @property auto attrChecker()
        {
            assert(atMax);

            static struct AttrChecker
            {
                void pushAttr(Taken attrName, TextPos attrPos)
                {
                    put(state.attrs, Attribute(attrName, attrPos));
                }

                void checkAttrs()
                {
                    import std.algorithm.comparison : cmp, equal;
                    import std.algorithm.sorting : sort;
                    import std.conv : to;

                    if(state.attrs.data.length < 2)
                        return;

                    sort!((a,b) => cmp(a.taken.save, b.taken.save) < 0)(state.attrs.data);
                    auto prev = state.attrs.data.front;
                    foreach(attr; state.attrs.data[1 .. $])
                    {
                        if(equal(prev.taken, attr.taken))
                            throw new XMLParsingException("Duplicate attribute name", attr.pos);
                        prev = attr;
                    }
                }

                ~this()
                {
                    state.attrs.clear();
                }

                SharedState* state;
            }

            return AttrChecker(state);
        }

        void sawEntity()
        {
            if(entityCount++ == state.maxEntities)
                ++state.maxEntities;
        }

        @property bool atMax()
        {
            return entityCount == state.maxEntities;
        }

        struct Attribute
        {
            Taken taken;
            TextPos pos;
        }

        struct SharedState
        {
            import std.array : Appender;

            Appender!(Taken[]) tags;
            Appender!(Attribute[]) attrs;
            size_t maxEntities;
        }

        static create()
        {
            TagStack tagStack;
            tagStack.state = new SharedState;
            tagStack.state.tags.reserve(10);
            tagStack.state.attrs.reserve(10);
            return tagStack;
        }

        SharedState* state;
        size_t entityCount;
        int depth;
    }

    static if(compileInTests) unittest
    {
        import core.exception : AssertError;
        import std.algorithm.comparison : equal;
        import std.exception : assertNotThrown, collectException, enforce;
        import qt.widgets.internal.dxml.internal : testRangeFuncs;

        static void test(alias func)(string text, size_t line = __LINE__)
        {
            auto xml = func(text);
            static foreach(config; someTestConfigs)
            {{
                auto range = assertNotThrown!XMLParsingException(parseXML!config(xml.save), "unittest failure 1",
                                                                 __FILE__, line);
                assertNotThrown!XMLParsingException(walkLength(range), "unittest failure 2", __FILE__, line);
            }}
        }

        static void testFail(alias func)(string text, int row, int col, size_t line = __LINE__)
        {
            auto xml = func(text);
            static foreach(config; someTestConfigs)
            {{
                auto range = assertNotThrown!XMLParsingException(parseXML!config(xml.save), "unittest failure 1",
                                                                 __FILE__, line);
                auto e = collectException!XMLParsingException(walkLength(range));
                enforce!AssertError(e !is null, "unittest failure 2", __FILE__, line);
                enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
            }}
        }

        static foreach(func; testRangeFuncs)
        {
            test!func("<root></root>");
            test!func("<root><a></a></root>");
            test!func("<root><a><b></b></a></root>");
            test!func("<root><a><b></b></a></root>");
            test!func("<root><a><b></b></a><foo><bar></bar></foo></root>");
            test!func("<a>\n" ~
                      "    <b>\n" ~
                      "        <c>\n" ~
                      "            <d>\n" ~
                      "                <e>\n" ~
                      "                    <f>\n" ~
                      "                        <g>\n" ~
                      "                            <h>\n" ~
                      "                                 <i><i><i><i>\n" ~
                      "                                 </i></i></i></i>\n" ~
                      "                                 <i>\n" ~
                      "                                     <j>\n" ~
                      "                                         <k>\n" ~
                      "                                             <l>\n" ~
                      "                                                 <m>\n" ~
                      "                                                     <n>\n" ~
                      "                                                         <o>\n" ~
                      "                                                             <p>\n" ~
                      "                                                                 <q>\n" ~
                      "                                                                     <r>\n" ~
                      "                                                                         <s>\n" ~
                      "          <!-- comment --> <?pi?> <t><u><v></v></u></t>\n" ~
                      "                                                                         </s>\n" ~
                      "                                                                     </r>\n" ~
                      "                                                                 </q>\n" ~
                      "                                                </p></o></n></m>\n" ~
                      "                                                               </l>\n" ~
                      "                    </k>\n" ~
                      "           </j>\n" ~
                      "</i></h>" ~
                      "                        </g>\n" ~
                      "                    </f>\n" ~
                      "                </e>\n" ~
                      "            </d>\n" ~
                      "        </c>\n" ~
                      "    </b>\n" ~
                      "</a>");
            test!func(`<京都市></京都市>`);

            testFail!func(`<a>`, 1, 4);
            testFail!func(`<foo></foobar>`, 1, 8);
            testFail!func(`<foobar></foo>`, 1, 11);
            testFail!func(`<a><\a>`, 1, 5);
            testFail!func(`<a><a/>`, 1, 8);
            testFail!func(`<a><b>`, 1, 7);
            testFail!func(`<a><b><c>`, 1, 10);
            testFail!func(`<a></a><b>`, 1, 9);
            testFail!func(`<a></a><b></b>`, 1, 9);
            testFail!func(`<a><b></a></b>`, 1, 9);
            testFail!func(`<a><b><c></c><b></a>`, 1, 19);
            testFail!func(`<a><b></c><c></b></a>`, 1, 9);
            testFail!func(`<a><b></c></b></a>`, 1, 9);
            testFail!func("<a>\n" ~
                          "    <b>\n" ~
                          "        <c>\n" ~
                          "            <d>\n" ~
                          "                <e>\n" ~
                          "                    <f>\n" ~
                          "                    </f>\n" ~
                          "                </e>\n" ~
                          "            </d>\n" ~
                          "        </c>\n" ~
                          "    </b>\n" ~
                          "<a>", 12, 4);
            testFail!func("<a>\n" ~
                          "    <b>\n" ~
                          "        <c>\n" ~
                          "            <d>\n" ~
                          "                <e>\n" ~
                          "                    <f>\n" ~
                          "                    </f>\n" ~
                          "                </e>\n" ~
                          "            </d>\n" ~
                          "        </c>\n" ~
                          "    </b>\n" ~
                          "</q>", 12, 3);
        }
    }


    struct Text(R)
    {
        alias config = cfg;
        alias Input = R;

        Input input;
        TextPos pos;

        @property save() { return typeof(this)(input.save, pos); }
    }


    alias Taken = typeof(takeExactly(byCodeUnit(R.init), 42));


    EntityType _type;
    TextPos _entityPos;
    auto _grammarPos = GrammarPos.documentStart;

    Taken _name;
    TagStack _tagStack;

    Text!(typeof(byCodeUnit(R.init))) _text;
    Text!Taken _savedText;


    this(R xmlText)
    {
        _tagStack = TagStack.create();
        _text.input = byCodeUnit(xmlText);

        // None of these initializations should be required. https://issues.dlang.org/show_bug.cgi?id=13945
        _savedText = typeof(_savedText).init;
        _name = typeof(_name).init;

        popFront();
    }
}

/// Ditto
EntityRange!(config, R) parseXML(Config config = Config.init, R)(R xmlText)
    if(isForwardRange!R && isSomeChar!(ElementType!R))
{
    return EntityRange!(config, R)(xmlText);
}

///
unittest
{
    import std.range.primitives : walkLength;

    auto xml = "<?xml version='1.0'?>\n" ~
               "<?instruction start?>\n" ~
               "<foo attr='42'>\n" ~
               "    <bar/>\n" ~
               "    <!-- no comment -->\n" ~
               "    <baz hello='world'>\n" ~
               "    nothing to say.\n" ~
               "    nothing at all...\n" ~
               "    </baz>\n" ~
               "</foo>\n" ~
               "<?some foo?>";

    {
        auto range = parseXML(xml);
        assert(range.front.type == EntityType.pi);
        assert(range.front.name == "instruction");
        assert(range.front.text == "start");

        range.popFront();
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "foo");

        {
            auto attrs = range.front.attributes;
            assert(walkLength(attrs.save) == 1);
            assert(attrs.front.name == "attr");
            assert(attrs.front.value == "42");
        }

        range.popFront();
        assert(range.front.type == EntityType.elementEmpty);
        assert(range.front.name == "bar");

        range.popFront();
        assert(range.front.type == EntityType.comment);
        assert(range.front.text == " no comment ");

        range.popFront();
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "baz");

        {
            auto attrs = range.front.attributes;
            assert(walkLength(attrs.save) == 1);
            assert(attrs.front.name == "hello");
            assert(attrs.front.value == "world");
        }

        range.popFront();
        assert(range.front.type == EntityType.text);
        assert(range.front.text ==
               "\n    nothing to say.\n    nothing at all...\n    ");

        range.popFront();
        assert(range.front.type == EntityType.elementEnd); // </baz>
        range.popFront();
        assert(range.front.type == EntityType.elementEnd); // </foo>

        range.popFront();
        assert(range.front.type == EntityType.pi);
        assert(range.front.name == "some");
        assert(range.front.text == "foo");

        range.popFront();
        assert(range.empty);
    }
    {
        auto range = parseXML!simpleXML(xml);

        // simpleXML is set to skip processing instructions.

        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "foo");

        {
            auto attrs = range.front.attributes;
            assert(walkLength(attrs.save) == 1);
            assert(attrs.front.name == "attr");
            assert(attrs.front.value == "42");
        }

        // simpleXML is set to split empty tags so that <bar/> is treated
        // as the same as <bar></bar> so that code does not have to
        // explicitly handle empty tags.
        range.popFront();
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "bar");
        range.popFront();
        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "bar");

        // simpleXML is set to skip comments.

        range.popFront();
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "baz");

        {
            auto attrs = range.front.attributes;
            assert(walkLength(attrs.save) == 1);
            assert(attrs.front.name == "hello");
            assert(attrs.front.value == "world");
        }

        range.popFront();
        assert(range.front.type == EntityType.text);
        assert(range.front.text ==
               "\n    nothing to say.\n    nothing at all...\n    ");

        range.popFront();
        assert(range.front.type == EntityType.elementEnd); // </baz>
        range.popFront();
        assert(range.front.type == EntityType.elementEnd); // </foo>
        range.popFront();
        assert(range.empty);
    }
}

// Test the state of the range immediately after parseXML returns.
unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {
        static foreach(config; someTestConfigs)
        {{
            auto range = parseXML!config("<?xml?><root></root>");
            assert(!range.empty);
            assert(range.front.type == EntityType.elementStart);
            assert(equal(range.front.name, "root"));
        }}

        static foreach(config; [Config.init, makeConfig(SkipPI.yes)])
        {{
            auto range = parseXML!config("<!--no comment--><root></root>");
            assert(!range.empty);
            assert(range.front.type == EntityType.comment);
            assert(equal(range.front.text, "no comment"));
        }}
        static foreach(config; [simpleXML, makeConfig(SkipComments.yes)])
        {{
            auto range = parseXML!config("<!--no comment--><root></root>");
            assert(!range.empty);
            assert(range.front.type == EntityType.elementStart);
            assert(equal(range.front.name, "root"));
        }}

        static foreach(config; [Config.init, makeConfig(SkipComments.yes)])
        {{
            auto range = parseXML!config("<?private eye?><root></root>");
            assert(!range.empty);
            assert(range.front.type == EntityType.pi);
            assert(equal(range.front.name, "private"));
            assert(equal(range.front.text, "eye"));
        }}
        static foreach(config; [simpleXML, makeConfig(SkipPI.yes)])
        {{
            auto range = parseXML!config("<?private eye?><root></root>");
            assert(!range.empty);
            assert(range.front.type == EntityType.elementStart);
            assert(equal(range.front.name, "root"));
        }}

        static foreach(config; someTestConfigs)
        {{
            auto range = parseXML!config("<root></root>");
            assert(!range.empty);
            assert(range.front.type == EntityType.elementStart);
            assert(equal(range.front.name, "root"));
        }}
    }
}

// Test various invalid states that didn't seem to fit well into tests elsewhere.
unittest
{
    import core.exception : AssertError;
    import std.exception : collectException, enforce;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static void testFail(alias func)(string text, int row, int col, size_t line = __LINE__)
    {
        auto xml = func(text);
        static foreach(config; someTestConfigs)
        {{
            auto e = collectException!XMLParsingException(
                {
                    auto range = parseXML!config(xml.save);
                    while(!range.empty)
                        range.popFront();
                }());
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }}
    }

    static foreach(func; testRangeFuncs)
    {{
        testFail!func("<root></root><invalid></invalid>", 1, 15);
        testFail!func("<root></root><invalid/>", 1, 15);
        testFail!func("<root/><invalid></invalid>", 1, 9);
        testFail!func("<root/><invalid/>", 1, 9);

        testFail!func("<root></root>invalid", 1, 14);
        testFail!func("<root/>invalid", 1, 8);

        testFail!func("<root/><?pi?>invalid", 1, 14);
        testFail!func("<root/><?pi?><invalid/>", 1, 15);

        testFail!func("<root/><!DOCTYPE foo>", 1, 9);
        testFail!func("<root/></root>", 1, 9);

        testFail!func("invalid<root></root>", 1, 1);
        testFail!func("invalid<?xml?><root></root>", 1, 1);
        testFail!func("invalid<!DOCTYPE foo><root></root>", 1, 1);
        testFail!func("invalid<!--comment--><root></root>", 1, 1);
        testFail!func("invalid<?Poirot?><root></root>", 1, 1);

        testFail!func("<?xml?>invalid<root></root>", 1, 8);
        testFail!func("<!DOCTYPE foo>invalid<root></root>", 1, 15);
        testFail!func("<!--comment-->invalid<root></root>", 1, 15);
        testFail!func("<?Poirot?>invalid<root></root>", 1, 11);

        testFail!func("<?xml?>", 1, 8);
        testFail!func("<!DOCTYPE name>", 1, 16);
        testFail!func("<?Sherlock?>", 1, 13);
        testFail!func("<?Poirot?><?Sherlock?><?Holmes?>", 1, 33);
        testFail!func("<?Poirot?></Poirot>", 1, 12);
        testFail!func("</Poirot>", 1, 2);
        testFail!func("<", 1, 2);
        testFail!func(`</`, 1, 2);
        testFail!func(`</a`, 1, 2);
        testFail!func(`</a>`, 1, 2);


        testFail!func("<doc>]]></doc>", 1, 6);

        testFail!func(" <?xml?><root/>", 1, 1);
        testFail!func("\n<?xml?><root/>", 1, 1);
    }}
}

// Test that parseXML and EntityRange's properties work with @safe.
// pure would be nice too, but at minimum, the use of format for exception
// messages, and the use of assumeSafeAppend prevent it. It may or may not be
// worth trying to fix that.
@safe unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    auto xml = "<root>\n" ~
               "    <![CDATA[nothing]]>\n" ~
               "    <foo a='42'/>\n" ~
               "</root>";

    static foreach(func; testRangeFuncs)
    {{
        auto range = parseXML(xml);
        assert(range.front.type == EntityType.elementStart);
        assert(equal(range.front.name, "root"));
        range.popFront();
        assert(!range.empty);
        assert(range.front.type == EntityType.cdata);
        assert(equal(range.front.text, "nothing"));
        range.popFront();
        assert(!range.empty);
        assert(range.front.type == EntityType.elementEmpty);
        assert(equal(range.front.name, "foo"));
        {
            auto attrs = range.front.attributes;
            auto saved = attrs.save;
            auto attr = attrs.front;
            assert(attr.name == "a");
            assert(attr.value == "42");
            attrs.popFront();
            assert(attrs.empty);
        }
        auto saved = range.save;
    }}
}


// This is purely to provide a way to trigger the unittest blocks in EntityRange
// without compiling them in normally.
struct EntityRangeCompileTests
{
    @property bool empty() @safe pure nothrow @nogc { assert(0); }
    @property char front() @safe pure nothrow @nogc { assert(0); }
    void popFront() @safe pure nothrow @nogc { assert(0); }
    @property typeof(this) save() @safe pure nothrow @nogc { assert(0); }
}

unittest
{
    EntityRange!(Config.init, EntityRangeCompileTests) _entityRangeTests;
}


/++
    Whether the given type is a forward range of attributes.

    Essentially, an attribute range must be a forward range where

    $(UL
        $(LI each element has the members $(D name), $(D value), and $(D pos))
        $(LI $(D name) and $(D value) are forward ranges of characters)
        $(LI $(D name) and $(D value) have the same type)
        $(LI $(D pos) is a $(LREF TextPos)))

    Normally, an attribute range would come from
    $(LREF EntityRange.Entity.attributes) or
    $(REF_ALTTEXT DOMEntity.attributes, DOMEntity.attributes, dxml, dom), but
    as long as a range has the correct API, it qualifies as an attribute range.

    See_Also: $(LREF EntityRange.Entity.Attribute)$(BR)
              $(LREF EntityRange.Entity.attributes)$(BR)
              $(REF_ALTTEXT DOMEntity.Attribute, DOMEntity.Attribute, dxml, dom)$(BR)
              $(REF_ALTTEXT DOMEntity.attributes, DOMEntity.attributes, dxml, dom)
  +/
template isAttrRange(R)
{
    static if(isForwardRange!R &&
              is(typeof(R.init.front.name)) &&
              is(typeof(R.init.front.value)) &&
              is(ReturnType!((R r) => r.front.pos) == TextPos))
    {
        alias NameType  = ReturnType!((R r) => r.front.name);
        alias ValueType = ReturnType!((R r) => r.front.value);

        enum isAttrRange = is(NameType == ValueType) &&
                           isForwardRange!NameType &&
                           isSomeChar!(ElementType!NameType);
    }
    else
        enum isAttrRange = false;
}

///
unittest
{
    import std.typecons : Tuple;
    import qt.widgets.internal.dxml.dom : parseDOM;

    alias R1 = typeof(parseXML("<root/>").front.attributes);
    static assert(isAttrRange!R1);

    alias R2 = typeof(parseDOM("<root/>").children[0].attributes);
    static assert(isAttrRange!R2);

    alias T = Tuple!(string, "name", string, "value", TextPos, "pos");
    static assert(isAttrRange!(T[]));

    static assert(!isAttrRange!string);
}

unittest
{
    import std.typecons : Tuple;
    {
        alias T = Tuple!(string, "nam", string, "value", TextPos, "pos");
        static assert(!isAttrRange!(T[]));
    }
    {
        alias T = Tuple!(string, "name", string, "valu", TextPos, "pos");
        static assert(!isAttrRange!(T[]));
    }
    {
        alias T = Tuple!(string, "name", string, "value", TextPos, "po");
        static assert(!isAttrRange!(T[]));
    }
    {
        alias T = Tuple!(string, "name", wstring, "value", TextPos, "pos");
        static assert(!isAttrRange!(T[]));
    }
    {
        alias T = Tuple!(string, "name", string, "value");
        static assert(!isAttrRange!(T[]));
    }
    {
        alias T = Tuple!(int, "name", string, "value", TextPos, "pos");
        static assert(!isAttrRange!(T[]));
    }
    {
        alias T = Tuple!(string, "name", int, "value", TextPos, "pos");
        static assert(!isAttrRange!(T[]));
    }
    {
        alias T = Tuple!(string, "name", string, "value", int, "pos");
        static assert(!isAttrRange!(T[]));
    }
}


/++
    A helper function for processing start tag attributes.

    It functions similarly to $(PHOBOS_REF getopt, std, getopt). It takes a
    range of attributes and a list of alternating strings and pointers where
    each string represents the name of the attribute to parse and the pointer
    immediately after it is assigned the value that corresponds to the attribute
    name (if present). If the given pointer does not point to the same type as
    the range of characters used in the attributes, then
    $(PHOBOS_REF to, std, conv) is used to convert the value to the type the
    pointer points to.

    If a $(D Nullable!T*) is given rather than a $(D T*), then it will be
    treated the same as if it had been $(D T*). So, $(D to!T) will be used to
    convert the attribute value if the matching attribute name is present. The
    advantage of passing $(D Nullable!T*) instead of $(D T*) is that it's
    possible to distinguish between an attribute that wasn't present and one
    where it was present but was equivalent to $(D T.init).

    Unlike $(PHOBOS_REF getopt, std, getopt), the given range is consumed
    rather than taking it by $(K_REF) and leaving the attributes that weren't
    matched in the range (since that really doesn't work with an arbitrary
    range as opposed to a dynamic array). However, if the second argument of
    getAttrs is not a $(K_STRING) but is instead an output range that accepts
    the element type of the range, then any attributes which aren't matched are
    put into the output range.

    Params:
        attrRange = A range of attributes (see $(LREF isAttrRange)).
        unmatched = An output range that any _unmatched attributes from the
                    range are put into (optional argument).
        args = An alternating list of strings and pointers where the names
               represent the attribute names to get the value of, and the
               corresponding values get assigned to what the pointers point to.

    Throws: $(LREF XMLParsingException) if $(PHOBOS_REF to, std, conv) fails to
            convert an attribute value.

    See_Also: $(LREF isAttrRange)$(BR)
              $(LREF EntityRange.Entity.attributes)$(BR)
              $(REF_ALTTEXT DOMEntity.attributes, DOMEntity.attributes, dxml, dom)
  +/
void getAttrs(R, Args...)(R attrRange, Args args)
    if(isAttrRange!R && Args.length % 2 == 0)
{
    mixin(_genGetAttrs(false));
}

/// Ditto
void getAttrs(R, OR, Args...)(R attrRange, ref OR unmatched, Args args)
    if(isAttrRange!R && isOutputRange!(OR, ElementType!R) && Args.length % 2 == 0)
{
    mixin(_genGetAttrs(true));
}

private string _genGetAttrs(bool includeUnmatched)
{
    auto retval =
`    import std.algorithm.comparison : equal;
    import std.conv : ConvException, to;
    import std.format : format;
    import std.typecons : Nullable;
    import std.utf : byChar;

    alias Attr = ElementType!R;
    alias SliceOfR = ElementType!(typeof(Attr.init.name));

    outer: foreach(attr; attrRange)
    {
        static foreach(i, arg; args)
        {
            static if(i % 2 == 0)
                static assert(is(Args[i] == string), format!"Expected string for args[%s]"(i));
            else
            {
                static assert(isPointer!(Args[i]), format!"Expected pointer for args[%s]"(i));

                if(equal(attr.name, args[i - 1].byChar()))
                {
                    alias ArgType = typeof(*arg);

                    static if(isInstanceOf!(Nullable, ArgType))
                        alias TargetType = TemplateArgsOf!ArgType;
                    else
                        alias TargetType = typeof(*arg);

                    try
                        *arg = to!TargetType(attr.value);
                    catch(ConvException ce)
                    {
                        enum fmt = "Failed to convert %s: %s";
                        throw new XMLParsingException(format!fmt(attr.name, ce.msg), attr.pos);
                    }

                    continue outer;
                }
            }
        }`;

    if(includeUnmatched)
        retval ~= "\n        put(unmatched, attr);";
    retval ~= "\n    }";

    return retval;
}

unittest
{
    import std.array : appender;
    import std.exception : collectException;
    import std.typecons : Nullable;

    {
        auto xml = `<root a="foo" b="19" c="true" d="rocks"/>`;
        auto range = parseXML(xml);
        assert(range.front.type == EntityType.elementEmpty);

        string a;
        int b;
        bool c;

        getAttrs(range.front.attributes, "a", &a, "b", &b, "c", &c);
        assert(a == "foo");
        assert(b == 19);
        assert(c == true);
    }

    // Nullable!T* accepts the same as T*.
    {
        auto xml = `<root a="foo" c="true" d="rocks"/>`;
        auto range = parseXML(xml);
        assert(range.front.type == EntityType.elementEmpty);

        Nullable!string a;
        Nullable!int b;
        bool c;

        getAttrs(range.front.attributes, "c", &c, "b", &b, "a", &a);
        assert(a == "foo");
        assert(b.isNull);
        assert(c == true);
    }

    // If an output range of attributes is provided, then the ones that
    // weren't matched are put in it.
    {
        auto xml = `<root foo="42" bar="silly" d="rocks" q="t"/>`;
        auto range = parseXML(xml);
        assert(range.front.type == EntityType.elementEmpty);

        alias Attribute = typeof(range).Entity.Attribute;
        auto unmatched = appender!(Attribute[])();
        int i;
        string s;

        getAttrs(range.front.attributes, unmatched, "foo", &i, "bar", &s);
        assert(i == 42);
        assert(s == "silly");
        assert(unmatched.data.length == 2);
        assert(unmatched.data[0] == Attribute("d", "rocks", TextPos(1, 28)));
        assert(unmatched.data[1] == Attribute("q", "t", TextPos(1, 38)));
    }

    // An XMLParsingException gets thrown if a conversion fails.
    {
        auto xml = `<root foo="bar" false="true" d="rocks"/>`;
        auto range = parseXML(xml);
        assert(range.front.type == EntityType.elementEmpty);

        int i;

        auto xpe = collectException!XMLParsingException(
            getAttrs(range.front.attributes, "d", &i));
        assert(xpe.pos == TextPos(1, 30));
    }

    // Test parsing attributes with CTFE.
    enum dummy = (){
        auto xml = `<root a="foo" d="rocks" c="true" b="19" />`;
        auto range = parseXML(xml);
        assert(range.front.type == EntityType.elementEmpty);

        string a;
        int b;
        bool c;

        getAttrs(range.front.attributes, "a", &a, "b", &b, "c", &c);
        assert(a == "foo");
        assert(b == 19);
        assert(c == true);
        return 0;
    }();
}

unittest
{
    auto range = parseXML("<root/>");
    auto attrs = range.front.attributes;
    int i;
    static assert(!__traits(compiles, getAttrs(attrs, "foo")));
    static assert(!__traits(compiles, getAttrs(attrs, "foo", "bar")));
    static assert(!__traits(compiles, getAttrs(attrs, "foo", "bar", &i)));
    static assert(!__traits(compiles, getAttrs(attrs, "foo", "bar", &i, &i)));
    static assert(!__traits(compiles, getAttrs(attrs, &i, "foo")));
    static assert(!__traits(compiles, getAttrs(attrs, &i, "foo", &i)));
    static assert(!__traits(compiles, getAttrs(attrs, &i, "foo", &i, "bar")));
}

@safe pure unittest
{
    import std.typecons : Nullable;

    static test(R)(R range, int* i, Nullable!int* j) @safe pure
    {
        getAttrs(range.front.attributes, "foo", i, "bar", j);
    }

    test(parseXML("<root/>"), null, null);
}


/++
    Takes an $(LREF EntityRange) which is at a start tag and iterates it until
    it is at its corresponding end tag. It is an error to call skipContents when
    the current entity is not $(LREF EntityType.elementStart).

    $(TABLE
        $(TR $(TH Supported $(LREF EntityType)s:))
        $(TR $(TD $(LREF2 elementStart, EntityType)))
    )

    Returns: The range with its $(D front) now at the end tag corresponding to
             the start tag that was $(D front) when the function was called.

    Throws: $(LREF XMLParsingException) on invalid XML.
  +/
R skipContents(R)(R entityRange)
    if(isInstanceOf!(EntityRange, R))
{
    assert(entityRange._type == EntityType.elementStart);

    // We don't bother calling empty, because the only way for the entityRange
    // to be empty would be for it to reach the end of the document, and an
    // XMLParsingException would be thrown if the end of the document were
    // reached before we reached the corresponding end tag.
    for(int tagDepth = 1; tagDepth != 0;)
    {
        entityRange.popFront();
        immutable type = entityRange._type;
        if(type == EntityType.elementStart)
            ++tagDepth;
        else if(type == EntityType.elementEnd)
            --tagDepth;
    }

    return entityRange;
}

///
unittest
{
    auto xml = "<root>\n" ~
               "    <foo>\n" ~
               "        <bar>\n" ~
               "        Some text\n" ~
               "        </bar>\n" ~
               "    </foo>\n" ~
               "    <!-- no comment -->\n" ~
               "</root>";

    auto range = parseXML(xml);
    assert(range.front.type == EntityType.elementStart);
    assert(range.front.name == "root");

    range.popFront();
    assert(range.front.type == EntityType.elementStart);
    assert(range.front.name == "foo");

    range = range.skipContents();
    assert(range.front.type == EntityType.elementEnd);
    assert(range.front.name == "foo");

    range.popFront();
    assert(range.front.type == EntityType.comment);
    assert(range.front.text == " no comment ");

    range.popFront();
    assert(range.front.type == EntityType.elementEnd);
    assert(range.front.name == "root");

    range.popFront();
    assert(range.empty);
}


/++
    Skips entities until the given $(LREF EntityType) is reached.

    If multiple $(LREF EntityType)s are given, then any one of them counts as
    a match.

    The current entity is skipped regardless of whether it is the given
    $(LREF EntityType).

    This is essentially a slightly optimized equivalent to

    ---
    if(!range.empty())
    {
        range.popFront();
        range = range.find!((a, b) => a.type == b.type)(entityTypes);
    }
    ---

    Returns: The given range with its $(D front) now at the first entity which
             matched one of the given $(LREF EntityType)s or an empty range if
             none were found.

    Throws: $(LREF XMLParsingException) on invalid XML.
  +/
R skipToEntityType(R)(R entityRange, EntityType[] entityTypes...)
    if(isInstanceOf!(EntityRange, R))
{
    if(entityRange.empty)
        return entityRange;
    entityRange.popFront();
    for(; !entityRange.empty; entityRange.popFront())
    {
        immutable type = entityRange._type;
        foreach(entityType; entityTypes)
        {
            if(type == entityType)
                return entityRange;
        }
    }
    return entityRange;
}

///
unittest
{
    auto xml = "<root>\n" ~
               "    <!-- blah blah blah -->\n" ~
               "    <foo>nothing to say</foo>\n" ~
               "</root>";

    auto range = parseXML(xml);
    assert(range.front.type == EntityType.elementStart);
    assert(range.front.name == "root");

    range = range.skipToEntityType(EntityType.elementStart,
                                   EntityType.elementEmpty);
    assert(range.front.type == EntityType.elementStart);
    assert(range.front.name == "foo");

    assert(range.skipToEntityType(EntityType.comment).empty);

    // skipToEntityType will work on an empty range but will always
    // return an empty range.
    assert(range.takeNone().skipToEntityType(EntityType.comment).empty);
}


/++
    Skips entities until the end tag is reached that corresponds to the start
    tag that is the parent of the current entity.

    Returns: The given range with its $(D front) now at the end tag which
             corresponds to the parent start tag of the entity that was
             $(D front) when skipToParentEndTag was called. If the current
             entity does not have a parent start tag (which means that it's
             either the root element or a comment or PI outside of the root
             element), then an empty range is returned.

    Throws: $(LREF XMLParsingException) on invalid XML.
  +/
R skipToParentEndTag(R)(R entityRange)
    if(isInstanceOf!(EntityRange, R))
{
    with(EntityType) final switch(entityRange._type)
    {
        case cdata:
        case comment:
        {
            entityRange = entityRange.skipToEntityType(elementStart, elementEnd);
            if(entityRange.empty || entityRange._type == elementEnd)
                return entityRange;
            goto case elementStart;
        }
        case elementStart:
        {
            while(true)
            {
                entityRange = entityRange.skipContents();
                entityRange.popFront();
                if(entityRange.empty || entityRange._type == elementEnd)
                    return entityRange;
                if(entityRange._type == elementStart)
                    continue;
                goto case comment;
            }
            assert(0); // the compiler isn't smart enough to see that this is unreachable.
        }
        case elementEnd:
        case elementEmpty:
        case pi:
        case text: goto case comment;
    }
}

///
unittest
{
    auto xml = "<root>\n" ~
               "    <foo>\n" ~
               "        <!-- comment -->\n" ~
               "        <bar>exam</bar>\n" ~
               "    </foo>\n" ~
               "    <!-- another comment -->\n" ~
               "</root>";
    {
        auto range = parseXML(xml);
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "root");

        range.popFront();
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "foo");

        range.popFront();
        assert(range.front.type == EntityType.comment);
        assert(range.front.text == " comment ");

        range = range.skipToParentEndTag();
        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "foo");

        range = range.skipToParentEndTag();
        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "root");

        range = range.skipToParentEndTag();
        assert(range.empty);
    }
    {
        auto range = parseXML(xml);
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "root");

        range.popFront();
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "foo");

        range.popFront();
        assert(range.front.type == EntityType.comment);
        assert(range.front.text == " comment ");

        range.popFront();
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "bar");

        range.popFront();
        assert(range.front.type == EntityType.text);
        assert(range.front.text == "exam");

        range = range.skipToParentEndTag();
        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "bar");

        range = range.skipToParentEndTag();
        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "foo");

        range.popFront();
        assert(range.front.type == EntityType.comment);
        assert(range.front.text == " another comment ");

        range = range.skipToParentEndTag();
        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "root");

        assert(range.skipToParentEndTag().empty);
    }
    {
        auto range = parseXML("<root><foo>bar</foo></root>");
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "root");
        assert(range.skipToParentEndTag().empty);
    }
}

unittest
{
    import core.exception : AssertError;
    import std.algorithm.comparison : equal;
    import std.exception : enforce;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static void popAndCheck(R)(ref R range, EntityType type, size_t line = __LINE__)
    {
        range.popFront();
        enforce!AssertError(!range.empty, "unittest 1", __FILE__, line);
        enforce!AssertError(range.front.type == type, "unittest 2", __FILE__, line);
    }

    static foreach(func; testRangeFuncs)
    {{
        // cdata
        {
            auto xml = "<root>\n" ~
                       "    <![CDATA[ cdata run ]]>\n" ~
                       "    <nothing/>\n" ~
                       "    <![CDATA[ cdata have its bits flipped ]]>\n" ~
                       "    <foo></foo>\n" ~
                       "    <![CDATA[ cdata play violin ]]>\n" ~
                       "</root>";

            auto range = parseXML(func(xml));
            assert(range.front.type == EntityType.elementStart);
            popAndCheck(range, EntityType.cdata);
            assert(equal(range.front.text, " cdata run "));
            {
                auto temp = range.save.skipToParentEndTag();
                assert(temp._type == EntityType.elementEnd);
                assert(equal(temp.front.name, "root"));
            }
            popAndCheck(range, EntityType.elementEmpty);
            popAndCheck(range, EntityType.cdata);
            assert(equal(range.front.text, " cdata have its bits flipped "));
            {
                auto temp = range.save.skipToParentEndTag();
                assert(temp._type == EntityType.elementEnd);
                assert(equal(temp.front.name, "root"));
            }
            popAndCheck(range, EntityType.elementStart);
            range = range.skipContents();
            popAndCheck(range, EntityType.cdata);
            assert(equal(range.front.text, " cdata play violin "));
            range = range.skipToParentEndTag();
            assert(range._type == EntityType.elementEnd);
            assert(equal(range.front.name, "root"));
        }
        // comment
        {
            auto xml = "<!-- before -->\n" ~
                       "<root>\n" ~
                       "    <!-- comment 1 -->\n" ~
                       "    <nothing/>\n" ~
                       "    <!-- comment 2 -->\n" ~
                       "    <foo></foo>\n" ~
                       "    <!-- comment 3 -->\n" ~
                       "</root>\n" ~
                       "<!-- after -->" ~
                       "<!-- end -->";

            auto text = func(xml);
            assert(parseXML(text.save).skipToParentEndTag().empty);
            {
                auto range = parseXML(text.save);
                assert(range.front.type == EntityType.comment);
                popAndCheck(range, EntityType.elementStart);
                popAndCheck(range, EntityType.comment);
                assert(equal(range.front.text, " comment 1 "));
                {
                    auto temp = range.save.skipToParentEndTag();
                    assert(temp._type == EntityType.elementEnd);
                    assert(equal(temp.front.name, "root"));
                }
                popAndCheck(range, EntityType.elementEmpty);
                popAndCheck(range, EntityType.comment);
                assert(equal(range.front.text, " comment 2 "));
                {
                    auto temp = range.save.skipToParentEndTag();
                    assert(temp._type == EntityType.elementEnd);
                    assert(equal(temp.front.name, "root"));
                }
                popAndCheck(range, EntityType.elementStart);
                range = range.skipContents();
                popAndCheck(range, EntityType.comment);
                assert(equal(range.front.text, " comment 3 "));
                range = range.skipToParentEndTag();
                assert(range._type == EntityType.elementEnd);
                assert(equal(range.front.name, "root"));
            }
            {
                auto range = parseXML(text.save);
                assert(range.front.type == EntityType.comment);
                popAndCheck(range, EntityType.elementStart);
                range = range.skipContents();
                popAndCheck(range, EntityType.comment);
                assert(equal(range.front.text, " after "));
                assert(range.save.skipToParentEndTag().empty);
                popAndCheck(range, EntityType.comment);
                assert(equal(range.front.text, " end "));
                assert(range.skipToParentEndTag().empty);
            }
        }
        // elementStart
        {
            auto xml = "<root>\n" ~
                       "    <a><b>foo</b></a>\n" ~
                       "    <nothing/>\n" ~
                       "    <c></c>\n" ~
                       "    <d>\n" ~
                       "        <e>\n" ~
                       "        </e>\n" ~
                       "        <f>\n" ~
                       "            <g>\n" ~
                       "            </g>\n" ~
                       "        </f>\n" ~
                       "    </d>\n" ~
                       "</root>";

            auto range = parseXML(func(xml));
            assert(range.front.type == EntityType.elementStart);
            assert(equal(range.front.name, "root"));
            assert(range.save.skipToParentEndTag().empty);
            popAndCheck(range, EntityType.elementStart);
            assert(equal(range.front.name, "a"));
            {
                auto temp = range.save.skipToParentEndTag();
                assert(temp._type == EntityType.elementEnd);
                assert(equal(temp.front.name, "root"));
            }
            popAndCheck(range, EntityType.elementStart);
            assert(equal(range.front.name, "b"));
            {
                auto temp = range.save.skipToParentEndTag();
                assert(temp._type == EntityType.elementEnd);
                assert(equal(temp.front.name, "a"));
            }
            popAndCheck(range, EntityType.text);
            popAndCheck(range, EntityType.elementEnd);
            popAndCheck(range, EntityType.elementEnd);
            popAndCheck(range, EntityType.elementEmpty);
            popAndCheck(range, EntityType.elementStart);
            assert(equal(range.front.name, "c"));
            {
                auto temp = range.save.skipToParentEndTag();
                assert(temp._type == EntityType.elementEnd);
                assert(equal(temp.front.name, "root"));
            }
            popAndCheck(range, EntityType.elementEnd);
            popAndCheck(range, EntityType.elementStart);
            assert(equal(range.front.name, "d"));
            popAndCheck(range, EntityType.elementStart);
            assert(equal(range.front.name, "e"));
            range = range.skipToParentEndTag();
            assert(range._type == EntityType.elementEnd);
            assert(equal(range.front.name, "d"));
            range = range.skipToParentEndTag();
            assert(range._type == EntityType.elementEnd);
            assert(equal(range.front.name, "root"));
        }
        // elementEnd
        {
            auto xml = "<root>\n" ~
                       "    <a><b>foo</b></a>\n" ~
                       "    <nothing/>\n" ~
                       "    <c></c>\n" ~
                       "</root>";

            auto range = parseXML(func(xml));
            assert(range.front.type == EntityType.elementStart);
            popAndCheck(range, EntityType.elementStart);
            popAndCheck(range, EntityType.elementStart);
            popAndCheck(range, EntityType.text);
            popAndCheck(range, EntityType.elementEnd);
            assert(equal(range.front.name, "b"));
            {
                auto temp = range.save.skipToParentEndTag();
                assert(temp._type == EntityType.elementEnd);
                assert(equal(temp.front.name, "a"));
            }
            popAndCheck(range, EntityType.elementEnd);
            assert(equal(range.front.name, "a"));
            {
                auto temp = range.save.skipToParentEndTag();
                assert(temp._type == EntityType.elementEnd);
                assert(equal(temp.front.name, "root"));
            }
            popAndCheck(range, EntityType.elementEmpty);
            popAndCheck(range, EntityType.elementStart);
            popAndCheck(range, EntityType.elementEnd);
            assert(equal(range.front.name, "c"));
            {
                auto temp = range.save.skipToParentEndTag();
                assert(temp._type == EntityType.elementEnd);
                assert(equal(temp.front.name, "root"));
            }
            popAndCheck(range, EntityType.elementEnd);
            assert(range.skipToParentEndTag().empty);
        }
        // elementEmpty
        {
            auto range = parseXML(func("<root/>"));
            assert(range.front.type == EntityType.elementEmpty);
            assert(range.skipToParentEndTag().empty);
        }
        {
            auto xml = "<root>\n" ~
                       "    <a><b>foo</b></a>\n" ~
                       "    <nothing/>\n" ~
                       "    <c></c>\n" ~
                       "    <whatever/>\n" ~
                       "</root>";

            auto range = parseXML(func(xml));
            popAndCheck(range, EntityType.elementStart);
            assert(range.front.type == EntityType.elementStart);
            range = range.skipContents();
            popAndCheck(range, EntityType.elementEmpty);
            assert(equal(range.front.name, "nothing"));
            {
                auto temp = range.save;
                popAndCheck(temp, EntityType.elementStart);
                popAndCheck(temp, EntityType.elementEnd);
                popAndCheck(temp, EntityType.elementEmpty);
                assert(equal(temp.front.name, "whatever"));
            }
            range = range.skipToParentEndTag();
            assert(range._type == EntityType.elementEnd);
            assert(equal(range.front.name, "root"));
        }
        // pi
        {
            auto xml = "<?Sherlock?>\n" ~
                       "<root>\n" ~
                       "    <?Foo?>\n" ~
                       "    <nothing/>\n" ~
                       "    <?Bar?>\n" ~
                       "    <foo></foo>\n" ~
                       "    <?Baz?>\n" ~
                       "</root>\n" ~
                       "<?Poirot?>\n" ~
                       "<?Conan?>";

            auto range = parseXML(func(xml));
            assert(range.front.type == EntityType.pi);
            assert(equal(range.front.name, "Sherlock"));
            assert(range.save.skipToParentEndTag().empty);
            popAndCheck(range, EntityType.elementStart);
            popAndCheck(range, EntityType.pi);
            assert(equal(range.front.name, "Foo"));
            {
                auto temp = range.save.skipToParentEndTag();
                assert(temp._type == EntityType.elementEnd);
                assert(equal(temp.front.name, "root"));
            }
            popAndCheck(range, EntityType.elementEmpty);
            popAndCheck(range, EntityType.pi);
            assert(equal(range.front.name, "Bar"));
            {
                auto temp = range.save.skipToParentEndTag();
                assert(temp._type == EntityType.elementEnd);
                assert(equal(temp.front.name, "root"));
            }
            popAndCheck(range, EntityType.elementStart);
            popAndCheck(range, EntityType.elementEnd);
            popAndCheck(range, EntityType.pi);
            assert(equal(range.front.name, "Baz"));
            range = range.skipToParentEndTag();
            assert(range._type == EntityType.elementEnd);
            assert(equal(range.front.name, "root"));
            popAndCheck(range, EntityType.pi);
            assert(equal(range.front.name, "Poirot"));
            assert(range.save.skipToParentEndTag().empty);
            popAndCheck(range, EntityType.pi);
            assert(equal(range.front.name, "Conan"));
            assert(range.skipToParentEndTag().empty);
        }
        // text
        {
            auto xml = "<root>\n" ~
                       "    nothing to say\n" ~
                       "    <nothing/>\n" ~
                       "    nothing whatsoever\n" ~
                       "    <foo></foo>\n" ~
                       "    but he keeps talking\n" ~
                       "</root>";

            auto range = parseXML(func(xml));
            assert(range.front.type == EntityType.elementStart);
            popAndCheck(range, EntityType.text);
            assert(equal(range.front.text, "\n    nothing to say\n    "));
            {
                auto temp = range.save.skipToParentEndTag();
                assert(temp._type == EntityType.elementEnd);
                assert(equal(temp.front.name, "root"));
            }
            popAndCheck(range, EntityType.elementEmpty);
            popAndCheck(range, EntityType.text);
            assert(equal(range.front.text, "\n    nothing whatsoever\n    "));
            {
                auto temp = range.save.skipToParentEndTag();
                assert(temp._type == EntityType.elementEnd);
                assert(equal(temp.front.name, "root"));
            }
            popAndCheck(range, EntityType.elementStart);
            range = range.skipContents();
            popAndCheck(range, EntityType.text);
            assert(equal(range.front.text, "\n    but he keeps talking\n"));
            range = range.skipToParentEndTag();
            assert(range._type == EntityType.elementEnd);
            assert(equal(range.front.name, "root"));
        }
    }}
}


/++
    Treats the given string like a file path except that each directory
    corresponds to the name of a start tag. Note that this does $(I not) try to
    implement XPath as that would be quite complicated, and it really doesn't
    fit with a StAX parser.

    A start tag should be thought of as a directory, with its child start tags
    as the directories it contains.

    All paths should be relative. $(LREF EntityRange) can only move forward
    through the document, so using an absolute path would only make sense at
    the beginning of the document. As such, absolute paths are treated as
    invalid paths.

    $(D_CODE_STRING "./") and $(D_CODE_STRING "../") are supported. Repeated
    slashes such as in $(D_CODE_STRING "foo//bar") are not supported and are
    treated as an invalid path.

    If $(D range.front.type == EntityType.elementStart), then
    $(D range._skiptoPath($(D_STRING "foo"))) will search for the first child
    start tag (be it $(LREF EntityType.elementStart) or
    $(LREF EntityType.elementEmpty)) with the $(LREF2 name, EntityRange.Entity)
    $(D_CODE_STRING "foo"). That start tag must be a direct child of the current
    start tag.

    If $(D range.front.type) is any other $(LREF EntityType), then
    $(D range._skipToPath($(D_STRING "foo"))) will return an empty range,
    because no other $(LREF EntityType)s have child start tags.

    For any $(LREF EntityType), $(D range._skipToPath($(D_STRING "../foo")))
    will search for the first start tag with the
    $(LREF2 name, EntityRange.Entity) $(D_CODE_STRING "foo") at the same level
    as the current entity. If the current entity is a start tag with the name
    $(D_CODE_STRING "foo"), it will not be considered a match.

    $(D range._skipToPath($(D_STRING "./"))) is a no-op. However,
    $(D range._skipToPath($(D_STRING "../"))) will result in the empty range
    (since it doesn't target a specific start tag).

    $(D range._skipToPath($(D_STRING "foo/bar"))) is equivalent to
    $(D range._skipToPath($(D_STRING "foo"))._skipToPath($(D_STRING "bar"))),
    and $(D range._skipToPath($(D_STRING "../foo/bar"))) is equivalent to
    $(D range._skipToPath($(D_STRING "../foo"))._skipToPath($(D_STRING "bar"))).

    Returns: The given range with its $(D front) now at the requested entity if
             the path is valid; otherwise, an empty range is returned.

    Throws: $(LREF XMLParsingException) on invalid XML.
  +/
R skipToPath(R)(R entityRange, string path)
    if(isInstanceOf!(EntityRange, R))
{
    import std.algorithm.comparison : equal;
    import std.path : pathSplitter;

    if(entityRange.empty)
        return entityRange;
    if(path.empty || path[0] == '/')
        return entityRange.takeNone();

    with(EntityType)
    {
        static if(R.config.splitEmpty == SplitEmpty.yes)
            EntityType[2] startOrEnd = [elementStart, elementEnd];
        else
            EntityType[3] startOrEnd = [elementStart, elementEnd, elementEmpty];

        R findOnCurrLevel(string name)
        {
            if(entityRange._type == elementStart)
                entityRange = entityRange.skipContents();
            while(true)
            {
                entityRange = entityRange.skipToEntityType(startOrEnd[]);
                if(entityRange.empty)
                    return entityRange;
                if(entityRange._type == elementEnd)
                    return entityRange.takeNone();

                if(equal(name, entityRange._name.save))
                    return entityRange;

                static if(R.config.splitEmpty == SplitEmpty.no)
                {
                    if(entityRange._type == elementEmpty)
                        continue;
                }
                entityRange = entityRange.skipContents();
            }
        }

        for(auto pieces = path.pathSplitter(); !pieces.empty; pieces.popFront())
        {
            if(pieces.front == ".")
                continue;
            else if(pieces.front == "..")
            {
                pieces.popFront();
                if(pieces.empty)
                    return entityRange.takeNone();

                while(pieces.front == "..")
                {
                    pieces.popFront();
                    if(pieces.empty)
                        return entityRange.takeNone();
                    entityRange = entityRange.skipToParentEndTag();
                    if(entityRange.empty)
                        return entityRange;
                }

                entityRange = findOnCurrLevel(pieces.front);
                if(entityRange.empty)
                    return entityRange;
            }
            else
            {
                if(entityRange._type != elementStart)
                    return entityRange.takeNone();

                entityRange = entityRange.skipToEntityType(startOrEnd[]);
                assert(!entityRange.empty);
                if(entityRange._type == elementEnd)
                    return entityRange.takeNone();

                if(!equal(pieces.front, entityRange._name.save))
                {
                    entityRange = findOnCurrLevel(pieces.front);
                    if(entityRange.empty)
                        return entityRange;
                }
            }
        }

        return entityRange;
    }
}

///
unittest
{
    {
        auto xml = "<carrot>\n" ~
                   "    <foo>\n" ~
                   "        <bar>\n" ~
                   "            <baz/>\n" ~
                   "            <other/>\n" ~
                   "        </bar>\n" ~
                   "    </foo>\n" ~
                   "</carrot>";

        auto range = parseXML(xml);
        // "<carrot>"
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "carrot");

        range = range.skipToPath("foo/bar");
        // "        <bar>
        assert(!range.empty);
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "bar");

        range = range.skipToPath("baz");
        // "            <baz/>
        assert(!range.empty);
        assert(range.front.type == EntityType.elementEmpty);

        // other is not a child element of baz
        assert(range.skipToPath("other").empty);

        range = range.skipToPath("../other");
        // "            <other/>"
        assert(!range.empty);
        assert(range.front.type == EntityType.elementEmpty);
    }
    {
        auto xml = "<potato>\n" ~
                   "    <foo>\n" ~
                   "        <bar>\n "~
                   "        </bar>\n" ~
                   "        <crazy>\n" ~
                   "        </crazy>\n" ~
                   "        <fou/>\n" ~
                   "    </foo>\n" ~
                   "    <buzz/>\n" ~
                   "</potato>";

        auto range = parseXML(xml);
        // "<potato>"
        assert(range.front.type == EntityType.elementStart);

        range = range.skipToPath("./");
        // "<potato>"
        assert(!range.empty);
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "potato");

        range = range.skipToPath("./foo/bar");
        // "        <bar>"
        assert(!range.empty);
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "bar");

        range = range.skipToPath("../crazy");
        // "        <crazy>"
        assert(!range.empty);
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "crazy");

        // Whether popFront is called here before the call to
        // range.skipToPath("../fou") below, the result is the same, because
        // both <crazy> and </crazy> are at the same level.
        range.popFront();
        // "        </crazy>"
        assert(!range.empty);
        assert(range.front.type == EntityType.elementEnd);
        assert(range.front.name == "crazy");

        range = range.skipToPath("../fou");
        // "        <fou/>"
        assert(!range.empty);
        assert(range.front.type == EntityType.elementEmpty);
    }
    // Searching stops at the first matching start tag.
    {
        auto xml = "<beet>\n" ~
                   "    <foo a='42'>\n" ~
                   "    </foo>\n" ~
                   "    <foo b='451'>\n" ~
                   "    </foo>\n" ~
                   "</beet>";

        auto range = parseXML(xml);
        range = range.skipToPath("foo");
        assert(!range.empty);
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "foo");

        {
            auto attrs = range.front.attributes;
            assert(attrs.front.name == "a");
            assert(attrs.front.value == "42");
        }

        range = range.skipToPath("../foo");
        assert(!range.empty);
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "foo");

        {
            auto attrs = range.front.attributes;
            assert(attrs.front.name == "b");
            assert(attrs.front.value == "451");
        }
    }
    // skipToPath will work on an empty range but will always return an
    // empty range.
    {
        auto range = parseXML("<root/>");
        assert(range.takeNone().skipToPath("nowhere").empty);
    }
    // Empty and absolute paths will also result in an empty range as will
    // "../" without any actual tag name on the end.
    {
        auto range = parseXML("<root/>");
        assert(range.skipToPath("").empty);
        assert(range.skipToPath("/").empty);
        assert(range.skipToPath("../").empty);
    }
    // Only non-empty start tags have children; all other EntityTypes result
    // in an empty range unless "../" is used.
    {
        auto xml = "<!-- comment -->\n" ~
                   "<root>\n" ~
                   "    <foo/>\n" ~
                   "</root>";
        auto range = parseXML(xml);
        assert(range.skipToPath("root").empty);
        assert(range.skipToPath("foo").empty);

        range = range.skipToPath("../root");
        assert(!range.empty);
        assert(range.front.type == EntityType.elementStart);
        assert(range.front.name == "root");
    }
}

unittest
{
    import core.exception : AssertError;
    import std.algorithm.comparison : equal;
    import std.exception : assertNotThrown, enforce;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static void testPath(R)(R range, string path, EntityType type, string name, size_t line = __LINE__)
    {
        auto result = assertNotThrown!XMLParsingException(range.skipToPath(path), "unittest 1", __FILE__, line);
        enforce!AssertError(!result.empty, "unittest 2", __FILE__, line);
        enforce!AssertError(result.front.type == type, "unittest 3", __FILE__, line);
        enforce!AssertError(equal(result.front.name, name), "unittest 4", __FILE__, line);
    }

    static void popEmpty(R)(ref R range)
    {
        range.popFront();
        static if(range.config.splitEmpty == SplitEmpty.yes)
            range.popFront();
    }

    auto xml = "<superuser>\n" ~
               "    <!-- comment -->\n" ~
               "    <?pi?>\n" ~
               "    <![CDATA[cdata]]>\n" ~
               "    <foo/>\n" ~
               "    <bar/>\n" ~
               "    <!-- comment -->\n" ~
               "    <!-- comment -->\n" ~
               "    <baz/>\n" ~
               "    <frobozz>\n" ~
               "        <!-- comment -->\n" ~
               "        <!-- comment -->\n" ~
               "        <whatever/>\n" ~
               "        <!-- comment -->\n" ~
               "        <!-- comment -->\n" ~
               "    </frobozz>\n" ~
               "    <!-- comment -->\n" ~
               "    <!-- comment -->\n" ~
               "    <xyzzy/>\n" ~
               "</superuser>";

    static foreach(func; testRangeFuncs)
    {{
        auto text = func(xml);

        static foreach(config; someTestConfigs)
        {{
            static if(config.splitEmpty == SplitEmpty.yes)
                enum empty = EntityType.elementStart;
            else
                enum empty = EntityType.elementEmpty;

            auto range = parseXML!config(text.save);

            assert(range.save.skipToPath("whatever").empty);
            assert(range.save.skipToPath("frobozz/whateve").empty);

            testPath(range.save, "foo", empty, "foo");
            testPath(range.save, "bar", empty, "bar");
            testPath(range.save, "baz", empty, "baz");
            testPath(range.save, "frobozz", EntityType.elementStart, "frobozz");
            testPath(range.save, "frobozz/whatever", empty, "whatever");
            testPath(range.save, "xyzzy", empty, "xyzzy");

            range.popFront();
            for(; range.front.type != empty; range.popFront())
            {
                assert(range.save.skipToPath("foo").empty);
                testPath(range.save, "../foo", empty, "foo");
                testPath(range.save, "../bar", empty, "bar");
                testPath(range.save, "../baz", empty, "baz");
                testPath(range.save, "../frobozz", EntityType.elementStart, "frobozz");
                testPath(range.save, "../frobozz/whatever", empty, "whatever");
                testPath(range.save, "../xyzzy", empty, "xyzzy");
            }
            assert(equal(range.front.name, "foo"));
            assert(range.save.skipToPath("foo").empty);
            assert(range.save.skipToPath("./foo").empty);
            assert(range.save.skipToPath("../foo").empty);
            assert(range.save.skipToPath("bar").empty);
            assert(range.save.skipToPath("baz").empty);
            assert(range.save.skipToPath("frobozz").empty);
            assert(range.save.skipToPath("whatever").empty);
            assert(range.save.skipToPath("../").empty);
            assert(range.save.skipToPath("../../").empty);

            testPath(range.save, "../bar", empty, "bar");
            testPath(range.save, "../baz", empty, "baz");
            testPath(range.save, "../frobozz", EntityType.elementStart, "frobozz");
            testPath(range.save, "../frobozz/whatever", empty, "whatever");
            testPath(range.save, "../xyzzy", empty, "xyzzy");

            popEmpty(range);
            assert(range.save.skipToPath("bar").empty);
            testPath(range.save, "../baz", empty, "baz");
            testPath(range.save, "../frobozz", EntityType.elementStart, "frobozz");
            testPath(range.save, "../frobozz/whatever", empty, "whatever");
            testPath(range.save, "../xyzzy", empty, "xyzzy");

            range.popFront();
            for(; range.front.type != empty; range.popFront())
            {
                assert(range.save.skipToPath("baz").empty);
                testPath(range.save, "../baz", empty, "baz");
                testPath(range.save, "../frobozz", EntityType.elementStart, "frobozz");
                testPath(range.save, "../frobozz/whatever", empty, "whatever");
                testPath(range.save, "../xyzzy", empty, "xyzzy");
            }
            assert(equal(range.front.name, "baz"));

            testPath(range.save, "../frobozz", EntityType.elementStart, "frobozz");
            testPath(range.save, "../frobozz/whatever", empty, "whatever");
            testPath(range.save, "../xyzzy", empty, "xyzzy");

            popEmpty(range);
            assert(equal(range.front.name, "frobozz"));
            assert(range.save.skipToPath("wizard").empty);
            testPath(range.save, "whatever", empty, "whatever");
            testPath(range.save, "../xyzzy", empty, "xyzzy");

            range.popFront();
            for(; range.front.type != empty; range.popFront())
            {
                assert(range.save.skipToPath("whatever").empty);
                testPath(range.save, "../whatever", empty, "whatever");
                testPath(range.save, "../../xyzzy", empty, "xyzzy");
            }
            assert(equal(range.front.name, "whatever"));
            assert(range.save.skipToPath("frobozz").empty);
            assert(range.save.skipToPath("../frobozz").empty);
            assert(range.save.skipToPath("../xyzzy").empty);
            assert(range.save.skipToPath("../../frobozz").empty);

            testPath(range.save, "../../xyzzy", empty, "xyzzy");

            popEmpty(range);
            for(; range.front.type != EntityType.elementEnd; range.popFront())
            {
                assert(range.save.skipToPath("xyzzy").empty);
                assert(range.save.skipToPath("../xyzzy").empty);
                testPath(range.save, "../../xyzzy", empty, "xyzzy");
            }
            assert(equal(range.front.name, "frobozz"));

            range.popFront();
            for(; range.front.type != empty; range.popFront())
            {
                assert(range.save.skipToPath("xyzzy").empty);
                testPath(range.save, "../xyzzy", empty, "xyzzy");
            }
            assert(equal(range.front.name, "xyzzy"));

            popEmpty(range);
            assert(equal(range.front.name, "superuser"));
            assert(range.save.skipToPath("superuser").empty);
            assert(range.save.skipToPath("foo").empty);
            assert(range.save.skipToPath("../foo").empty);
            assert(range.save.skipToPath("../../foo").empty);
        }}
    }}
}


//------------------------------------------------------------------------------
// Private Section
//------------------------------------------------------------------------------
private:


auto testParser(Config config = Config.init, R)(R xmlText) @trusted pure nothrow @nogc
{
    import std.utf : byCodeUnit;
    typeof(EntityRange!(config, R)._text) text;
    text.input = byCodeUnit(xmlText);
    return text;
}


// toCmpType is to make it easy for tests to convert the expected result to a
// range with the correct element type, since comparing with equal won't do
// the right thing if the result doesn't have dchar as its element type.
auto toCmpType(alias func)(string str)
{
    import std.range : takeExactly;
    import std.utf : byUTF;

    return str.byUTF!(immutable ElementType!(typeof(testParser(func(str)).input.takeExactly(1))))();
}

auto toCmpType(alias func, ThrowOnEntityRef toer)(string str)
{
    import std.range : takeExactly;
    import std.utf : byUTF;

    return str.byUTF!(immutable ElementType!(typeof(testParser!(makeConfig(toer))(func(str)).input.takeExactly(1))))();
}


// Used to indicate where in the grammar we're currently parsing.
enum GrammarPos
{
    // Nothing has been parsed yet.
    documentStart,

    // document ::= prolog element Misc*
    // prolog   ::= XMLDecl? Misc* (doctypedecl Misc*)?
    // This is that first Misc*. The next entity to parse is either a Misc, the
    // doctypedecl, or the root element which follows the prolog.
    prologMisc1,

    // document ::= prolog element Misc*
    // prolog   ::= XMLDecl? Misc* (doctypedecl Misc*)
    // This is that second Misc*. The next entity to parse is either a Misc or
    // the root element which follows the prolog.
    prologMisc2,

    // Used with SplitEmpty.yes to tell the parser that we're currently at an
    // empty element tag that we're treating as a start tag, so the next entity
    // will be an end tag even though we didn't actually parse one.
    splittingEmpty,

    // element  ::= EmptyElemTag | STag content ETag
    // content ::= CharData? ((element | Reference | CDSect | PI | Comment) CharData?)*
    // This is at the beginning of content at the first CharData?. The next
    // thing to parse will be a CharData, element, CDSect, PI, Comment, or ETag.
    // References are treated as part of the CharData and not parsed out by the
    // EntityRange (see EntityRange.Entity.text).
    contentCharData1,

    // element  ::= EmptyElemTag | STag content ETag
    // content ::= CharData? ((element | Reference | CDSect | PI | Comment) CharData?)*
    // This is after the first CharData?. The next thing to parse will be a
    // element, CDSect, PI, Comment, or ETag.
    // References are treated as part of the CharData and not parsed out by the
    // EntityRange (see EntityRange.Entity.text).
    contentMid,

    // element  ::= EmptyElemTag | STag content ETag
    // content ::= CharData? ((element | Reference | CDSect | PI | Comment) CharData?)*
    // This is at the second CharData?. The next thing to parse will be a
    // CharData, element, CDSect, PI, Comment, or ETag.
    // References are treated as part of the CharData and not parsed out by the
    // EntityRange (see EntityRange.Entity.text).
    contentCharData2,

    // element  ::= EmptyElemTag | STag content ETag
    // content ::= CharData? ((element | Reference | CDSect | PI | Comment) CharData?)*
    // This is after the second CharData?. The next thing to parse is an ETag.
    endTag,

    // document ::= prolog element Misc*
    // This is the Misc* at the end of the document. The next thing to parse is
    // either another Misc, or we will hit the end of the document.
    endMisc,

    // The end of the document (and the grammar) has been reached.
    documentEnd
}


// Wrapper around skipOver which takes an EntityParser.Text and handles
// incrementing pos.
//
// It is assumed that there are no newlines.
bool stripStartsWith(Text)(ref Text text, string needle)
{
    import std.algorithm.searching : skipOver;
    import std.utf : byCodeUnit;

    //TODO In the case where we're parsing an array of char, if we can cleanly
    // strip off any byCodeUnit and takeExactly wrappers, then we should be able
    // to have skipOver compare the string being parsed and the needle with ==.
    // It may happen in some cases right now when text.input is a byCodeUnit
    // result, but it won't happen in all cases where it ideally would. We may
    // also want to look into using byUTF on the needle so that it matches the
    // encoding of text.input or even make needle match the encoding when it's
    // passed in instead of always being string.
    if(!text.input.skipOver(needle.byCodeUnit()))
        return false;

    text.pos.col += needle.length;

    return true;
}

unittest
{
    import core.exception : AssertError;
    import std.exception : enforce;
    import qt.widgets.internal.dxml.internal : equalCU, testRangeFuncs;

    static void test(alias func)(string origHaystack, string needle, string remainder, bool startsWith,
                                 int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        {
            auto text = testParser(haystack.save);
            enforce!AssertError(text.stripStartsWith(needle) == startsWith, "unittest failure 1", __FILE__, line);
            enforce!AssertError(equalCU(text.input, remainder), "unittest failure 2", __FILE__, line);
            enforce!AssertError(text.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            enforce!AssertError(text.stripStartsWith(needle) == startsWith, "unittest failure 4", __FILE__, line);
            enforce!AssertError(equalCU(text.input, remainder), "unittest failure 5", __FILE__, line);
            enforce!AssertError(text.pos == pos, "unittest failure 6", __FILE__, line);
        }
    }

    static foreach(func; testRangeFuncs)
    {
        test!func("hello world", "hello", " world", true, 1, "hello".length + 1);
        test!func("hello world", "hello world", "", true, 1, "hello world".length + 1);
        test!func("hello world", "foo", "hello world", false, 1, 1);
        test!func("hello world", "hello sally", "hello world", false, 1, 1);
        test!func("hello world", "hello world ", "hello world", false, 1, 1);
    }
}

@safe pure unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {{
        auto xml = func(`foo`);
        auto text = testParser!simpleXML(xml);
        assert(text.stripStartsWith("fo"));
    }}
}


// Strips whitespace while dealing with text.pos accordingly. Newlines are not
// ignored.
// Returns whether any whitespace was stripped.
bool stripWS(Text)(ref Text text)
{
    bool strippedSpace = false;

    static if(hasLength!(Text.Input))
        size_t lineStart = text.input.length;

    loop: while(!text.input.empty)
    {
        switch(text.input.front)
        {
            case ' ':
            case '\t':
            case '\r':
            {
                strippedSpace = true;
                text.input.popFront();
                static if(!hasLength!(Text.Input))
                    ++text.pos.col;
                break;
            }
            case '\n':
            {
                strippedSpace = true;
                text.input.popFront();
                static if(hasLength!(Text.Input))
                    lineStart = text.input.length;
                nextLine!(Text.config)(text.pos);
                break;
            }
            default: break loop;
        }
    }

    static if(hasLength!(Text.Input))
        text.pos.col += lineStart - text.input.length;

    return strippedSpace;
}

unittest
{
    import core.exception : AssertError;
    import std.exception : enforce;
    import qt.widgets.internal.dxml.internal : equalCU;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static void test(alias func)(string origHaystack, string remainder, bool stripped,
                                 int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        {
            auto text = testParser(haystack.save);
            enforce!AssertError(text.stripWS() == stripped, "unittest failure 1", __FILE__, line);
            enforce!AssertError(equalCU(text.input, remainder), "unittest failure 2", __FILE__, line);
            enforce!AssertError(text.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            enforce!AssertError(text.stripWS() == stripped, "unittest failure 4", __FILE__, line);
            enforce!AssertError(equalCU(text.input, remainder), "unittest failure 5", __FILE__, line);
            enforce!AssertError(text.pos == pos, "unittest failure 6", __FILE__, line);
        }
    }

    static foreach(func; testRangeFuncs)
    {
        test!func("  \t\rhello world", "hello world", true, 1, 5);
        test!func("  \n \n \n  \nhello world", "hello world", true, 5, 1);
        test!func("  \n \n \n  \n  hello world", "hello world", true, 5, 3);
        test!func("hello world", "hello world", false, 1, 1);
    }
}

@safe pure unittest
{
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {{
        auto xml = func(`foo`);
        auto text = testParser!simpleXML(xml);
        assert(!text.stripWS());
    }}
}


// Returns a slice (or takeExactly) of text.input up to but not including the
// given needle, removing both that slice and the given needle from text.input
// in the process. If the needle is not found, then an XMLParsingException is
// thrown.
auto takeUntilAndDrop(string needle, bool skipQuotedText = false, Text)(ref Text text)
{
    return _takeUntil!(true, needle, skipQuotedText, Text)(text);
}

unittest
{
    import core.exception : AssertError;
    import std.algorithm.comparison : equal;
    import std.exception : collectException, enforce;
    import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

    static void test(alias func, string needle, bool sqt)(string origHaystack, string expected, string remainder,
                                                          int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        auto adjExpected = expected.toCmpType!func();
        {
            auto text = testParser(haystack.save);
            auto temp = text.save;
            enforce!AssertError(equal(text.takeUntilAndDrop!(needle, sqt)(), adjExpected.save),
                                "unittest failure 1", __FILE__, line);
            enforce!AssertError(equal(text.input, remainder), "unittest failure 2", __FILE__, line);
            enforce!AssertError(text.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            enforce!AssertError(equal(text.takeUntilAndDrop!(needle, sqt)(), adjExpected),
                                "unittest failure 4", __FILE__, line);
            enforce!AssertError(equal(text.input, remainder), "unittest failure 5", __FILE__, line);
            enforce!AssertError(text.pos == pos, "unittest failure 6", __FILE__, line);
        }
    }

    static void testFail(alias func, string needle, bool sqt)
                        (string origHaystack, int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        {
            auto text = testParser(haystack.save);
            auto e = collectException!XMLParsingException(text.takeUntilAndDrop!(needle, sqt)());
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            auto e = collectException!XMLParsingException(text.takeUntilAndDrop!(needle, sqt)());
            enforce!AssertError(e !is null, "unittest failure 3", __FILE__, line);
            enforce!AssertError(e.pos == pos, "unittest failure 4", __FILE__, line);
        }
    }

    static foreach(func; testRangeFuncs)
    {
        static foreach(sqt; [false, true])
        {
            {
                auto haystack = "hello world";
                enum needle = "world";

                static foreach(i; 1 .. needle.length)
                    test!(func, needle[0 .. i], sqt)(haystack, "hello ", needle[i .. $], 1, 7 + i);
            }

            test!(func, "l", sqt)("lello world", "", "ello world", 1, 2);
            test!(func, "ll", sqt)("lello world", "le", "o world", 1, 5);
            test!(func, "le", sqt)("llello world", "l", "llo world", 1, 4);
            {
                enum needle = "great";
                enum expected = "プログラミング in D is ";
                static foreach(i; 1 .. needle.length)
                {
                    test!(func, needle[0 .. i], sqt)("プログラミング in D is great indeed", expected,
                                                     "great indeed"[i .. $], 1, codeLen!(func, expected) + i + 1);
                }
            }
            static foreach(haystack; ["", "a", "hello", "ディラン"])
                testFail!(func, "x", sqt)(haystack, 1, 1);
            static foreach(haystack; ["", "l", "lte", "world", "nomatch"])
                testFail!(func, "le", sqt)(haystack, 1, 1);
            static foreach(haystack; ["", "w", "we", "wew", "bwe", "we b", "hello we go", "nomatch"])
                testFail!(func, "web", sqt)(haystack, 1, 1);
        }

        test!(func, "*", false)(`hello '*' "*" * world`, `hello '`, `' "*" * world`, 1, 9);
        test!(func, "*", false)(`hello '"*' * world`, `hello '"`, `' * world`, 1, 10);
        test!(func, "*", false)(`hello "'*" * world`, `hello "'`, `" * world`, 1, 10);
        test!(func, "*", false)(`hello ''' * world`, `hello ''' `, ` world`, 1, 12);
        test!(func, "*", false)(`hello """ * world`, `hello """ `, ` world`, 1, 12);
        testFail!(func, "*", false)("foo\n\n   '   \n\nbar", 1, 1);
        testFail!(func, "*", false)(`ディラン   "   `, 1, 1);

        test!(func, "*", true)(`hello '*' "*" * world`, `hello '*' "*" `, ` world`, 1, 16);
        test!(func, "*", true)(`hello '"*' * world`, `hello '"*' `, ` world`, 1, 13);
        test!(func, "*", true)(`hello "'*" * world`, `hello "'*" `, ` world`, 1, 13);
        testFail!(func, "*", true)(`hello ''' * world`, 1, 9);
        testFail!(func, "*", true)(`hello """ * world`, 1, 9);
        testFail!(func, "*", true)("foo\n\n   '   \n\nbar", 3, 4);
        testFail!(func, "*", true)(`ディラン   "   `, 1, codeLen!(func, `ディラン   "`));

        test!(func, "*", true)(`hello '' "" * world`, `hello '' "" `, ` world`, 1, 14);
        test!(func, "*", true)("foo '\n \n \n' bar*", "foo '\n \n \n' bar", "", 4, 7);
    }
}

@safe pure unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {{
        auto xml = func(`foo`);
        auto text = testParser!simpleXML(xml);
        assert(equal(text.takeUntilAndDrop!"o"(), "f"));
    }}
}

// Variant of takeUntilAndDrop which does not return a slice. It's intended for
// when the config indicates that something should be skipped.
void skipUntilAndDrop(string needle, bool skipQuotedText = false, Text)(ref Text text)
{
    _takeUntil!(false, needle, skipQuotedText, Text)(text);
}

unittest
{
    import core.exception : AssertError;
    import std.algorithm.comparison : equal;
    import std.exception : assertNotThrown, collectException, enforce;
    import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

    static void test(alias func, string needle, bool sqt)(string origHaystack, string remainder,
                                                          int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        {
            auto text = testParser(haystack.save);
            assertNotThrown!XMLParsingException(text.skipUntilAndDrop!(needle, sqt)(), "unittest failure 1",
                                                __FILE__, line);
            enforce!AssertError(equal(text.input, remainder), "unittest failure 2", __FILE__, line);
            enforce!AssertError(text.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            assertNotThrown!XMLParsingException(text.skipUntilAndDrop!(needle, sqt)(), "unittest failure 4",
                                                __FILE__, line);
            enforce!AssertError(equal(text.input, remainder), "unittest failure 5", __FILE__, line);
            enforce!AssertError(text.pos == pos, "unittest failure 6", __FILE__, line);
        }
    }

    static void testFail(alias func, string needle, bool sqt)
                        (string origHaystack, int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        {
            auto text = testParser(haystack.save);
            auto e = collectException!XMLParsingException(text.skipUntilAndDrop!(needle, sqt)());
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            auto e = collectException!XMLParsingException(text.skipUntilAndDrop!(needle, sqt)());
            enforce!AssertError(e !is null, "unittest failure 3", __FILE__, line);
            enforce!AssertError(e.pos == pos, "unittest failure 4", __FILE__, line);
        }
    }

    static foreach(func; testRangeFuncs)
    {
        static foreach(sqt; [false, true])
        {
            {
                enum needle = "world";
                static foreach(i; 1 .. needle.length)
                    test!(func, needle[0 .. i], sqt)("hello world", needle[i .. $], 1, 7 + i);
            }

            test!(func, "l", sqt)("lello world", "ello world", 1, 2);
            test!(func, "ll", sqt)("lello world", "o world", 1, 5);
            test!(func, "le", sqt)("llello world", "llo world", 1, 4);

            {
                enum needle = "great";
                static foreach(i; 1 .. needle.length)
                {
                    test!(func, needle[0 .. i], sqt)("プログラミング in D is great indeed", "great indeed"[i .. $],
                                                     1, codeLen!(func, "プログラミング in D is ") + i + 1);
                }
            }

            static foreach(haystack; ["", "a", "hello", "ディラン"])
                testFail!(func, "x", sqt)(haystack, 1, 1);
            static foreach(haystack; ["", "l", "lte", "world", "nomatch"])
                testFail!(func, "le", sqt)(haystack, 1, 1);
            static foreach(haystack; ["", "w", "we", "wew", "bwe", "we b", "hello we go", "nomatch"])
                testFail!(func, "web", sqt)(haystack, 1, 1);
        }

        test!(func, "*", false)(`hello '*' "*" * world`, `' "*" * world`, 1, 9);
        test!(func, "*", false)(`hello '"*' * world`, `' * world`, 1, 10);
        test!(func, "*", false)(`hello "'*" * world`, `" * world`, 1, 10);
        test!(func, "*", false)(`hello ''' * world`, ` world`, 1, 12);
        test!(func, "*", false)(`hello """ * world`, ` world`, 1, 12);
        testFail!(func, "*", false)("foo\n\n   '   \n\nbar", 1, 1);
        testFail!(func, "*", false)(`ディラン   "   `, 1, 1);

        test!(func, "*", true)(`hello '*' "*" * world`, ` world`, 1, 16);
        test!(func, "*", true)(`hello '"*' * world`, ` world`, 1, 13);
        test!(func, "*", true)(`hello "'*" * world`, ` world`, 1, 13);
        testFail!(func, "*", true)(`hello ''' * world`, 1, 9);
        testFail!(func, "*", true)(`hello """ * world`, 1, 9);
        testFail!(func, "*", true)("foo\n\n   '   \n\nbar", 3, 4);
        testFail!(func, "*", true)(`ディラン   "   `, 1, codeLen!(func, `ディラン   "`));

        test!(func, "*", true)(`hello '' "" * world`, ` world`, 1, 14);
        test!(func, "*", true)("foo '\n \n \n' bar*", "", 4, 7);
    }
}

@safe pure unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {{
        auto xml = func(`foo`);
        auto text = testParser!simpleXML(xml);
        text.skipUntilAndDrop!"o"();
        assert(equal(text.input, "o"));
    }}
}

auto _takeUntil(bool retSlice, string needle, bool skipQuotedText, Text)(ref Text text)
{
    import std.algorithm : find;
    import std.ascii : isWhite;
    import std.range : takeExactly;

    static assert(needle.find!isWhite().empty);

    auto orig = text.save;
    bool found = false;
    size_t takeLen = 0;
    size_t lineStart = 0;

    void processNewline()
    {
        ++takeLen;
        nextLine!(Text.config)(text.pos);
        lineStart = takeLen;
    }

    loop: while(!text.input.empty)
    {
        switch(text.input.front)
        {
            case cast(ElementType!(Text.Input))needle[0]:
            {
                static if(needle.length == 1)
                {
                    found = true;
                    text.input.popFront();
                    break loop;
                }
                else static if(needle.length == 2)
                {
                    text.input.popFront();
                    if(!text.input.empty && text.input.front == needle[1])
                    {
                        found = true;
                        text.input.popFront();
                        break loop;
                    }
                    ++takeLen;
                    continue;
                }
                else
                {
                    text.input.popFront();
                    auto saved = text.input.save;
                    foreach(i, c; needle[1 .. $])
                    {
                        if(text.input.empty)
                        {
                            takeLen += i + 1;
                            break loop;
                        }
                        if(text.input.front != c)
                        {
                            text.input = saved;
                            ++takeLen;
                            continue loop;
                        }
                        text.input.popFront();
                    }
                    found = true;
                    break loop;
                }
            }
            static if(skipQuotedText)
            {
                static foreach(quote; ['\'', '"'])
                {
                    case quote:
                    {
                        auto quotePos = text.pos;
                        quotePos.col += takeLen - lineStart;
                        ++takeLen;
                        while(true)
                        {
                            text.input.popFront();
                            if(text.input.empty)
                                throw new XMLParsingException("Failed to find matching quote", quotePos);
                            switch(text.input.front)
                            {
                                case quote:
                                {
                                    ++takeLen;
                                    text.input.popFront();
                                    continue loop;
                                }
                                case '\n':
                                {
                                    processNewline();
                                    break;
                                }
                                default:
                                {
                                    ++takeLen;
                                    break;
                                }
                            }
                        }
                        assert(0); // the compiler isn't smart enough to see that this is unreachable.
                    }
                }
            }
            case '\n':
            {
                processNewline();
                break;
            }
            default:
            {
                ++takeLen;
                break;
            }
        }

        text.input.popFront();
    }

    text.pos.col += takeLen - lineStart + needle.length;

    if(!found)
        throw new XMLParsingException("Failed to find: " ~ needle, orig.pos);

    static if(retSlice)
        return takeExactly(orig.input, takeLen);
}


// Okay, this name kind of sucks, because it's too close to skipUntilAndDrop,
// but I'd rather do this than be passing template arguments to choose between
// behaviors - especially when the logic is so different. It skips until it
// reaches one of the delimiter characters. If it finds one of them, then the
// first character in the input is the delimiter that was found, and if it
// doesn't find either, then it throws.
template skipToOneOf(delims...)
{
    static foreach(delim; delims)
    {
        static assert(is(typeof(delim) == char));
        static assert(!isSpace(delim));
    }

    void skipToOneOf(Text)(ref Text text)
    {
        while(!text.input.empty)
        {
            switch(text.input.front)
            {
                static foreach(delim; delims)
                    case delim: return;
                case '\n':
                {
                    nextLine!(Text.config)(text.pos);
                    text.input.popFront();
                    break;
                }
                default:
                {
                    popFrontAndIncCol(text);
                    break;
                }
            }
        }
        throw new XMLParsingException("Prematurely reached end of document", text.pos);
    }
}

unittest
{
    import core.exception : AssertError;
    import std.algorithm.comparison : equal;
    import std.exception : assertNotThrown, collectException, enforce;
    import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

    static void test(alias func, delims...)(string origHaystack, string remainder,
                                            int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        {
            auto text = testParser(haystack.save);
            assertNotThrown!XMLParsingException(text.skipToOneOf!delims(), "unittest 1", __FILE__, line);
            enforce!AssertError(equal(text.input, remainder), "unittest failure 2", __FILE__, line);
            enforce!AssertError(text.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            assertNotThrown!XMLParsingException(text.skipToOneOf!delims(), "unittest 4", __FILE__, line);
            enforce!AssertError(equal(text.input, remainder), "unittest failure 5", __FILE__, line);
            enforce!AssertError(text.pos == pos, "unittest failure 6", __FILE__, line);
        }
    }

    static void testFail(alias func, delims...)(string origHaystack, int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        {
            auto text = testParser(haystack.save);
            auto e = collectException!XMLParsingException(text.skipToOneOf!delims());
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            auto e = collectException!XMLParsingException(text.skipToOneOf!delims());
            enforce!AssertError(e !is null, "unittest failure 3", __FILE__, line);
            enforce!AssertError(e.pos == pos, "unittest failure 4", __FILE__, line);
        }
    }

    static foreach(func; testRangeFuncs)
    {
        test!(func, 'o', 'w')("hello world", "o world", 1, 5);
        test!(func, 'r', 'w', '1', '+', '*')("hello world", "world", 1, 7);
        test!(func, 'z', 'y')("abc\n\n\n  \n\n   wxyzzy \nf\ng", "yzzy \nf\ng", 6, 6);
        test!(func, 'o', 'g')("abc\n\n\n  \n\n   wxyzzy \nf\ng", "g", 8, 1);
        test!(func, 'g', 'x')("プログラミング in D is great indeed", "great indeed",
                              1, codeLen!(func, "プログラミング in D is ") + 1);

        testFail!(func, 'a', 'b')("hello world", 1, 12);
        testFail!(func, 'a', 'b')("hello\n\nworld", 3, 6);
        testFail!(func, 'a', 'b')("プログラミング",  1, codeLen!(func, "プログラミング") + 1);
    }
}

@safe pure unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {{
        auto xml = func(`foo`);
        auto text = testParser!simpleXML(xml);
        text.skipToOneOf!('o')();
        assert(equal(text.input, "oo"));
    }}
}


// The front of the input should be text surrounded by single or double quotes.
// This returns a slice of the input containing that text, and the input is
// advanced to one code unit beyond the quote.
auto takeEnquotedText(Text)(ref Text text)
{
    checkNotEmpty(text);
    immutable quote = text.input.front;
    static foreach(quoteChar; [`"`, `'`])
    {
        // This would be a bit simpler if takeUntilAndDrop took a runtime
        // argument, but in all other cases, a compile-time argument makes more
        // sense, so this seemed like a reasonable way to handle this one case.
        if(quote == quoteChar[0])
        {
            popFrontAndIncCol(text);
            return takeUntilAndDrop!quoteChar(text);
        }
    }
    throw new XMLParsingException("Expected quoted text", text.pos);
}

unittest
{
    import core.exception : AssertError;
    import std.algorithm.comparison : equal;
    import std.exception : assertThrown, enforce;
    import std.range : only;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static void test(alias func)(string origHaystack, string expected, string remainder,
                                 int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        auto adjExpected = expected.toCmpType!func();
        {
            auto text = testParser(haystack.save);
            enforce!AssertError(equal(takeEnquotedText(text), adjExpected.save), "unittest failure 1", __FILE__, line);
            enforce!AssertError(equal(text.input, remainder), "unittest failure 2", __FILE__, line);
            enforce!AssertError(text.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            enforce!AssertError(equal(takeEnquotedText(text), adjExpected), "unittest failure 3", __FILE__, line);
            enforce!AssertError(equal(text.input, remainder), "unittest failure 4", __FILE__, line);
            enforce!AssertError(text.pos == pos, "unittest failure 3", __FILE__, line);
        }
    }

    static void testFail(alias func)(string origHaystack, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        auto text = testParser(haystack);
        assertThrown!XMLParsingException(text.takeEnquotedText(), "unittest failure", __FILE__, line);
    }

    static foreach(func; testRangeFuncs)
    {
        foreach(quote; only("\"", "'"))
        {
            test!func(quote ~ quote, "", "", 1, 3);
            test!func(quote ~ "hello world" ~ quote, "hello world", "", 1, 14);
            test!func(quote ~ "hello world" ~ quote ~ " foo", "hello world", " foo", 1, 14);
            {
                import std.utf : codeLength;
                auto haystack = quote ~ "プログラミング " ~ quote ~ "in D";
                enum len = cast(int)codeLength!(ElementEncodingType!(typeof(func(haystack))))("プログラミング ");
                test!func(haystack, "プログラミング ", "in D", 1, len + 3);
            }
        }

        foreach(str; only(`hello`, `"hello'`, `"hello`, `'hello"`, `'hello`, ``, `"'`, `"`, `'"`, `'`))
            testFail!func(str);
    }
}


// This removes a name per the Name grammar rule from the front of the input and
// returns it.
// The parsing continues until either one of the given delimiters or an XML
// whitespace character is encountered. The delimiter/whitespace is not returned
// as part of the name and is left at the front of the input.
template takeName(delims...)
{
    static foreach(delim; delims)
    {
        static assert(is(typeof(delim) == char), delim);
        static assert(!isSpace(delim));
    }

    auto takeName(Text)(ref Text text)
    {
        import std.format : format;
        import std.range : takeExactly;
        import std.utf : decodeFront, UseReplacementDchar;
        import qt.widgets.internal.dxml.internal : isNameStartChar, isNameChar;

        assert(!text.input.empty);

        auto orig = text.input.save;
        size_t takeLen;
        {
            immutable decodedC = text.input.decodeFront!(UseReplacementDchar.yes)(takeLen);
            if(!isNameStartChar(decodedC))
                throw new XMLParsingException(format!"Name contains invalid character: 0x%0x"(decodedC), text.pos);
        }

        if(text.input.empty)
        {
            text.pos.col += takeLen;
            return takeExactly(orig, takeLen);
        }

        loop: while(true)
        {
            immutable c = text.input.front;
            if(isSpace(c))
                break;
            static foreach(delim; delims)
            {
                if(c == delim)
                    break loop;
            }

            size_t numCodeUnits;
            immutable decodedC = text.input.decodeFront!(UseReplacementDchar.yes)(numCodeUnits);
            if(!isNameChar(decodedC))
            {
                text.pos.col += takeLen;
                throw new XMLParsingException(format!"Name contains invalid character: 0x%0x"(decodedC), text.pos);
            }
            takeLen += numCodeUnits;

            if(text.input.empty)
                break;
        }

        text.pos.col += takeLen;

        return takeExactly(orig, takeLen);
    }
}

unittest
{
    import core.exception : AssertError;
    import std.algorithm.comparison : equal;
    import std.exception : collectException, enforce;
    import std.typecons : tuple;
    import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

    static void test(alias func, delim...)(string origHaystack, string expected, string remainder,
                                           int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        auto adjExpected = expected.toCmpType!func();
        {
            auto text = testParser(haystack.save);
            enforce!AssertError(equal(text.takeName!delim(), adjExpected.save),
                                "unittest failure 1", __FILE__, line);
            enforce!AssertError(equal(text.input, remainder), "unittest failure 2", __FILE__, line);
            enforce!AssertError(text.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            enforce!AssertError(equal(text.takeName!delim(), adjExpected),
                                "unittest failure 4", __FILE__, line);
            enforce!AssertError(equal(text.input, remainder), "unittest failure 5", __FILE__, line);
            enforce!AssertError(text.pos == pos, "unittest failure 6", __FILE__, line);
        }
    }

    static void testFail(alias func, delim...)(string origHaystack, int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        {
            auto text = testParser(haystack.save);
            auto e = collectException!XMLParsingException(text.takeName!delim());
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            auto e = collectException!XMLParsingException(text.takeName!delim());
            enforce!AssertError(e !is null, "unittest failure 3", __FILE__, line);
            enforce!AssertError(e.pos == pos, "unittest failure 4", __FILE__, line);
        }
    }

    static foreach(func; testRangeFuncs)
    {
        static foreach(str; ["hello", "プログラミング", "h_:llo-.42", "_.", "_-", "_42"])
        {{
            enum len = codeLen!(func, str);

            static foreach(remainder; ["", " ", "\t", "\r", "\n", " foo", "\tfoo", "\rfoo", "\nfoo",  "  foo \n \r "])
            {{
                enum strRem = str ~ remainder;
                enum delimRem = '>' ~ remainder;
                enum hay = str ~ delimRem;
                test!func(strRem, str, remainder, 1, len + 1);
                test!(func, '=')(strRem, str, remainder, 1, len + 1);
                test!(func, '>', '|')(hay, str, delimRem, 1, len + 1);
                test!(func, '|', '>')(hay, str, delimRem, 1, len + 1);
            }}
        }}

        static foreach(t; [tuple(" ", 1, 1), tuple("<", 1, 1), tuple("foo!", 1, 4), tuple("foo!<", 1, 4)])
        {{
            testFail!func(t[0], t[1], t[2]);
            testFail!func(t[0] ~ '>', t[1], t[2]);
            testFail!(func, '?')(t[0], t[1], t[2]);
            testFail!(func, '=')(t[0] ~ '=', t[1], t[2]);
        }}

        testFail!(func, '>')(">", 1, 1);
        testFail!(func, '?')("?", 1, 1);
        testFail!(func, '?')("プログ&ラミング", 1, codeLen!(func, "プログ&"));

        static foreach(t; [tuple("42", 1, 1), tuple(".", 1, 1), tuple(".a", 1, 1)])
        {
            testFail!func(t[0], t[1], t[2]);
            testFail!(func, '>')(t[0], t[1], t[2]);
        }
    }
}

@safe pure unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {{
        auto xml = func(`foo`);
        auto text = testParser!simpleXML(xml);
        assert(equal(text.takeName(), "foo"));
    }}
}


// This removes an attribute value from the front of the input, partially
// validates it, and returns it. The validation that is not done is whether
// the value in a character reference is valid. It's checked for whether the
// characters used in it are valid but not whether the number they form is a
// valid Unicode character. Checking the number doesn't seem worth the extra
// complication, and it's not required for the XML to be "well-formed."
// dxml.util.parseCharRef will check that it is fully correct if it is used.
auto takeAttValue(Text)(ref Text text)
{
    // AttValue    ::= '"' ([^<&"] | Reference)* '"' | "'" ([^<&'] | Reference)* "'"
    // Reference   ::= EntityRef | CharRef
    // EntityRef   ::= '&' Name ';'
    // PEReference ::= '%' Name ';'

    import std.range : only;

    checkNotEmpty(text);
    immutable quote = text.input.front;
    immutable quotePos = text.pos;
    foreach(quoteChar; only('"', '\''))
    {
        // This would be a bit simpler if takeUntilAndDrop took a runtime
        // argument, but in all other cases, a compile-time argument makes more
        // sense, so this seemed like a reasonable way to handle this one case.
        if(quote == quoteChar)
        {
            popFrontAndIncCol(text);
            size_t lineStart = 0;
            auto orig = text.input.save;
            size_t takeLen;
            loop: while(true)
            {
                if(text.input.empty)
                    throw new XMLParsingException("Unterminated attribute value", quotePos);
                switch(text.input.front)
                {
                    case '"':
                    {
                        if(quote == '"')
                        {
                            text.input.popFront();
                            goto done;
                        }
                        goto default;
                    }
                    case '\'':
                    {
                        if(quote == '\'')
                        {
                            text.input.popFront();
                            goto done;
                        }
                        goto default;
                    }
                    case '&':
                    {
                        {
                            import qt.widgets.internal.dxml.util : parseCharRef;
                            auto temp = text.input.save;
                            auto charRef = parseCharRef(temp);
                            if(!charRef.isNull)
                            {
                                static if(hasLength!(Text.Input))
                                {
                                    takeLen += text.input.length - temp.length;
                                    text.input = temp;
                                }
                                else
                                {
                                    while(text.input.front != ';')
                                    {
                                        ++takeLen;
                                        text.input.popFront();
                                    }
                                    ++takeLen;
                                    text.input.popFront();
                                }
                                continue;
                            }
                        }

                        immutable ampLen = takeLen - lineStart;
                        ++takeLen;
                        text.input.popFront();

                        // Std Entity References
                        static if(Text.config.throwOnEntityRef == ThrowOnEntityRef.yes)
                        {
                            import std.algorithm.searching : startsWith;

                            static foreach(entRef; ["amp;", "apos;", "quot;", "lt;", "gt;"])
                            {
                                if(text.input.save.startsWith(entRef))
                                {
                                    takeLen += entRef.length;
                                    text.input.popFrontN(entRef.length);
                                    continue loop;
                                }
                            }

                            text.pos.col += ampLen;
                            throw new XMLParsingException("& is only legal in an attribute value as part of a " ~
                                                          "reference, and this parser only supports entity " ~
                                                          "references if they're predefined by the spec. This is not " ~
                                                          "a valid character reference or one of the predefined " ~
                                                          "entity references.", text.pos);
                        }
                        // All Entity References
                        else
                        {
                            import std.utf : decodeFront, UseReplacementDchar;
                            import qt.widgets.internal.dxml.internal : isNameStartChar, isNameChar;

                            if(text.input.empty || text.input.front == quote)
                                goto failedEntityRef;

                            {
                                size_t numCodeUnits;
                                immutable decodedC = text.input.decodeFront!(UseReplacementDchar.yes)(numCodeUnits);
                                if(!isNameStartChar(decodedC))
                                    goto failedEntityRef;
                                takeLen += numCodeUnits;
                            }

                            while(true)
                            {
                                if(text.input.empty)
                                    goto failedEntityRef;
                                immutable c = text.input.front;
                                if(c == ';')
                                {
                                    ++takeLen;
                                    break;
                                }
                                size_t numCodeUnits;
                                immutable decodedC = text.input.decodeFront!(UseReplacementDchar.yes)(numCodeUnits);
                                if(!isNameChar(decodedC))
                                    goto failedEntityRef;
                                takeLen += numCodeUnits;
                            }
                            break;

                            failedEntityRef:
                            text.pos.col += ampLen;
                            throw new XMLParsingException("& is only legal in an attribute value as part of a " ~
                                                          "character or entity reference, and this is not a valid " ~
                                                          "character or entity reference.", text.pos);
                        }
                    }
                    case '<':
                    {
                        text.pos.col += takeLen - lineStart;
                        throw new XMLParsingException("< is not legal in an attribute name", text.pos);
                    }
                    case '\n':
                    {
                        ++takeLen;
                        nextLine!(Text.config)(text.pos);
                        lineStart = takeLen;
                        break;
                    }
                    default:
                    {
                        import std.ascii : isASCII;
                        import std.format : format;
                        import qt.widgets.internal.dxml.internal : isXMLChar;

                        immutable c = text.input.front;
                        if(isASCII(c))
                        {
                            if(!isXMLChar(c))
                            {
                                throw new XMLParsingException(format!"Character is not legal in an XML File: 0x%0x"(c),
                                                              text.pos);
                            }
                            ++takeLen;
                            break;
                        }
                        import std.utf : decodeFront, UseReplacementDchar, UTFException;
                        // Annoyngly, letting decodeFront throw is the easier way to handle this, since the
                        // replacement character is considered valid XML, and if we decoded using it, then
                        // all of the invalid Unicode characters would come out as the replacement character
                        // and then be treated as valid instead of being caught, which isn't all bad, but
                        // the spec requires that they be treated as invalid instead of playing nice and
                        // using the replacement character.
                        try
                        {
                            size_t numCodeUnits;
                            immutable decodedC = text.input.decodeFront!(UseReplacementDchar.no)(numCodeUnits);
                            if(!isXMLChar(decodedC))
                            {
                                enum fmt = "Character is not legal in an XML File: 0x%0x";
                                throw new XMLParsingException(format!fmt(decodedC), text.pos);
                            }
                            takeLen += numCodeUnits;
                        }
                        catch(UTFException e)
                            throw new XMLParsingException("Invalid Unicode character", text.pos);
                        continue;
                    }
                }
                text.input.popFront();
            }
            done:
            {
                import std.range : takeExactly;
                text.pos.col += takeLen - lineStart + 1;
                return takeExactly(orig, takeLen);
            }
        }
    }
    throw new XMLParsingException("Expected quoted text", text.pos);
}

unittest
{
    import core.exception : AssertError;
    import std.algorithm.comparison : equal;
    import std.exception : collectException, enforce;
    import std.range : only;
    import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

    static void test(alias func, ThrowOnEntityRef toer)(string origHaystack, string expected, string remainder,
                                                        int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        auto adjExpected = expected.toCmpType!(func, toer)();
        {
            auto text = testParser!(makeConfig(toer))(haystack.save);
            enforce!AssertError(equal(text.takeAttValue(), adjExpected.save),
                                "unittest failure 1", __FILE__, line);
            enforce!AssertError(equal(text.input, remainder), "unittest failure 2", __FILE__, line);
            enforce!AssertError(text.pos == TextPos(row, col), "unittest failure 3", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser!(makeConfig(toer))(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            enforce!AssertError(equal(text.takeAttValue(), adjExpected),
                                "unittest failure 4", __FILE__, line);
            enforce!AssertError(equal(text.input, remainder), "unittest failure 5", __FILE__, line);
            enforce!AssertError(text.pos == pos, "unittest failure 6", __FILE__, line);
        }
    }

    static void testFail(alias func, ThrowOnEntityRef toer)(string origHaystack,
                                                            int row, int col, size_t line = __LINE__)
    {
        auto haystack = func(origHaystack);
        {
            auto text = testParser!(makeConfig(toer))(haystack.save);
            auto e = collectException!XMLParsingException(text.takeAttValue());
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto text = testParser!(makeConfig(toer))(haystack);
            text.pos.line += 3;
            text.pos.col += 7;
            auto e = collectException!XMLParsingException(text.takeAttValue());
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == pos, "unittest failure 2", __FILE__, line);
        }
    }

    static foreach(i, func; testRangeFuncs)
    {
        static foreach(toer; [ThrowOnEntityRef.yes, ThrowOnEntityRef.no])
        {
            test!(func, toer)(`""`, "", "", 1, 3);
            test!(func, toer)(`"J"`, "J", "", 1, 4);
            test!(func, toer)(`"foo"`, "foo", "", 1, 6);
            test!(func, toer)(`"プログラミング"`, "プログラミング", "", 1, codeLen!(func, "プログラミング") + 3);
            test!(func, toer)(`"foo"bar`, "foo", "bar", 1, 6);
            test!(func, toer)(`"プログラミング" after`, "プログラミング", " after", 1, codeLen!(func, "プログラミング") + 3);

            test!(func, toer)(`''`, "", "", 1, 3);
            test!(func, toer)(`'J'`, "J", "", 1, 4);
            test!(func, toer)(`'foo'`, "foo", "", 1, 6);
            test!(func, toer)(`'プログラミング'`, "プログラミング", "", 1, codeLen!(func, "プログラミング") + 3);
            test!(func, toer)(`'foo'bar`, "foo", "bar", 1, 6);
            test!(func, toer)(`'プログラミング' after`, "プログラミング", " after", 1, codeLen!(func, "プログラミング") + 3);

            test!(func, toer)(`"&amp;&gt;&lt;"`, "&amp;&gt;&lt;", "", 1, 16);
            test!(func, toer)(`"&apos;&quot;"`, "&apos;&quot;", "", 1, 15);
            test!(func, toer)(`"hello&amp;&gt;&lt;world"`, "hello&amp;&gt;&lt;world", "", 1, 26);
            test!(func, toer)(`".....&amp;&gt;&lt;....."`, ".....&amp;&gt;&lt;.....", "", 1, 26);
            test!(func, toer)(`"&#12487;&#12451;&#12521;&#12531;"`, "&#12487;&#12451;&#12521;&#12531;", "", 1, 35);
            test!(func, toer)(`"hello&#xAF;&#77;&amp;world"`, "hello&#xAF;&#77;&amp;world", "", 1, 29);

            test!(func, toer)(`'&amp;&gt;&lt;'`, "&amp;&gt;&lt;", "", 1, 16);
            test!(func, toer)(`'hello&amp;&gt;&lt;world'`, "hello&amp;&gt;&lt;world", "", 1, 26);
            test!(func, toer)(`'&apos;&quot;'`, "&apos;&quot;", "", 1, 15);
            test!(func, toer)(`'.....&amp;&gt;&lt;.....'`, ".....&amp;&gt;&lt;.....", "", 1, 26);
            test!(func, toer)(`'&#12487;&#12451;&#12521;&#12531;'`, "&#12487;&#12451;&#12521;&#12531;", "", 1, 35);
            test!(func, toer)(`'hello&#xAF;&#77;&amp;world'`, "hello&#xAF;&#77;&amp;world", "", 1, 29);

            test!(func, toer)("'hello\nworld'", "hello\nworld", "", 2, 7);
            test!(func, toer)("'hello\nworld\n'", "hello\nworld\n", "", 3, 2);

            test!(func, toer)(`"'''"whatever`, "'''", "whatever", 1, 6);
            test!(func, toer)(`'"""'whatever`, `"""`, "whatever", 1, 6);

            test!(func, toer)(`"&#42;"`, "&#42;", "", 1, 8);
            test!(func, toer)(`"&#x42;"`, "&#x42;", "", 1, 9);
            test!(func, toer)(`"%foo"`, "%foo", "", 1, 7);

            testFail!(func, toer)(`"`, 1, 1);
            testFail!(func, toer)(`"foo`, 1, 1);
            testFail!(func, toer)(`"foo'`, 1, 1);
            testFail!(func, toer)(`"<"`, 1, 2);
            testFail!(func, toer)(`"&`, 1, 2);
            testFail!(func, toer)(`"&"`, 1, 2);
            testFail!(func, toer)(`"&x"`, 1, 2);
            testFail!(func, toer)(`"&.;"`, 1, 2);
            testFail!(func, toer)(`"&&;"`, 1, 2);
            testFail!(func, toer)(`"&a"`, 1, 2);
            testFail!(func, toer)(`"&a`, 1, 2);
            testFail!(func, toer)(`"hello&;"`, 1, 7);
            testFail!(func, toer)(`"hello&;world"`,1, 7);
            testFail!(func, toer)(`"hello&<;world"`,1, 7);
            testFail!(func, toer)(`"hello&world"`,1, 7);
            testFail!(func, toer)(`"hello<world"`,1, 7);
            testFail!(func, toer)(`"hello world&"`, 1, 13);
            testFail!(func, toer)(`"hello world&;"`, 1, 13);
            testFail!(func, toer)(`"hello world&foo"`, 1, 13);
            testFail!(func, toer)(`"foo<"`, 1, 5);
            testFail!(func, toer)(`"&#`, 1, 2);
            testFail!(func, toer)(`"&#"`, 1, 2);
            testFail!(func, toer)(`"&#;"`, 1, 2);
            testFail!(func, toer)(`"&#x;"`, 1, 2);
            testFail!(func, toer)(`"&#AF;"`, 1, 2);
            testFail!(func, toer)(`"&#x`, 1, 2);
            testFail!(func, toer)(`"&#77`, 1, 2);
            testFail!(func, toer)(`"&#77;`, 1, 1);
            testFail!(func, toer)(`"&#x0`, 1, 2);
            testFail!(func, toer)(`"&#x0;`, 1, 2);
            testFail!(func, toer)(`"&#x0;"`, 1, 2);

            testFail!(func, toer)(`'`, 1, 1);
            testFail!(func, toer)(`'foo`, 1, 1);
            testFail!(func, toer)(`'foo"`, 1, 1);
            testFail!(func, toer)(`'<'`, 1, 2);
            testFail!(func, toer)("'\v'", 1, 2);
            testFail!(func, toer)("'\uFFFE'", 1, 2);
            testFail!(func, toer)(`'&`, 1, 2);
            testFail!(func, toer)(`'&'`, 1, 2);
            testFail!(func, toer)(`'&x'`, 1, 2);
            testFail!(func, toer)(`'&.;'`, 1, 2);
            testFail!(func, toer)(`'&&;'`, 1, 2);
            testFail!(func, toer)(`'&a'`, 1, 2);
            testFail!(func, toer)(`'&a`, 1, 2);
            testFail!(func, toer)(`'hello&;'`, 1, 7);
            testFail!(func, toer)(`'hello&;world'`, 1, 7);
            testFail!(func, toer)(`'hello&<;world'`, 1, 7);
            testFail!(func, toer)(`'hello&world'`, 1, 7);
            testFail!(func, toer)(`'hello<world'`, 1, 7);
            testFail!(func, toer)(`'hello world&'`, 1, 13);
            testFail!(func, toer)(`'hello world&;'`, 1, 13);
            testFail!(func, toer)(`'hello world&foo'`, 1, 13);
            testFail!(func, toer)(`'foo<'`, 1, 5);
            testFail!(func, toer)(`'&#`, 1, 2);
            testFail!(func, toer)(`'&#'`, 1, 2);
            testFail!(func, toer)(`'&#;'`, 1, 2);
            testFail!(func, toer)(`'&#x;'`, 1, 2);
            testFail!(func, toer)(`'&#AF;'`, 1, 2);
            testFail!(func, toer)(`'&#x`, 1, 2);
            testFail!(func, toer)(`'&#77`, 1, 2);
            testFail!(func, toer)(`'&#77;`, 1, 1);
            testFail!(func, toer)(`'&#x0`, 1, 2);
            testFail!(func, toer)(`'&#x0;`, 1, 2);
            testFail!(func, toer)(`'&#x0;'`, 1, 2);
            testFail!(func, toer)("'&#xA\nF;'", 1, 2);
            testFail!(func, toer)("'&amp\n;'", 1, 2);
            testFail!(func, toer)("'&\namp;'", 1, 2);
            testFail!(func, toer)("'\n&amp;&;'", 2, 6);
        }
        {
            alias toer = ThrowOnEntityRef.yes;
            testFail!(func, toer)(`"&foo;"`, 1, 2);
            testFail!(func, toer)(`"hello world&foo;"`, 1, 13);
            testFail!(func, toer)(`"hello &foo; world"`, 1, 8);
            testFail!(func, toer)(`"&am;"`, 1, 2);
            testFail!(func, toer)(`"&ampe;"`, 1, 2);
            testFail!(func, toer)(`"&l;"`, 1, 2);
            testFail!(func, toer)(`"&lte;"`, 1, 2);
            testFail!(func, toer)(`"&g;"`, 1, 2);
            testFail!(func, toer)(`"&gte;"`, 1, 2);
            testFail!(func, toer)(`"&apo;"`, 1, 2);
            testFail!(func, toer)(`"&aposs;"`, 1, 2);
            testFail!(func, toer)(`"&quo;"`, 1, 2);
            testFail!(func, toer)(`"&quote;"`, 1, 2);

            testFail!(func, toer)(`'&foo;'`, 1, 2);
            testFail!(func, toer)(`'hello world&foo;'`, 1, 13);
            testFail!(func, toer)(`'hello &foo; world'`, 1, 8);
            testFail!(func, toer)(`'&am;'`, 1, 2);
            testFail!(func, toer)(`'&ampe;'`, 1, 2);
            testFail!(func, toer)(`'&l;'`, 1, 2);
            testFail!(func, toer)(`'&lte;'`, 1, 2);
            testFail!(func, toer)(`'&g;'`, 1, 2);
            testFail!(func, toer)(`'&gte;'`, 1, 2);
            testFail!(func, toer)(`'&apo;'`, 1, 2);
            testFail!(func, toer)(`'&aposs;'`, 1, 2);
            testFail!(func, toer)(`'&quo;'`, 1, 2);
            testFail!(func, toer)(`'&quote;'`, 1, 2);
        }
        {
            alias toer = ThrowOnEntityRef.no;
            test!(func, toer)(`"&foo;"`, "&foo;", "", 1, 8);
            test!(func, toer)(`"hello world&foo;"`, "hello world&foo;", "", 1, 19);
            test!(func, toer)(`"hello &foo; world"`, "hello &foo; world", "", 1, 20);
            test!(func, toer)(`"&am;"`, "&am;", "", 1, 7);
            test!(func, toer)(`"&ampe;"`, "&ampe;", "", 1, 9);
            test!(func, toer)(`"&l;"`, "&l;", "", 1, 6);
            test!(func, toer)(`"&lte;"`, "&lte;", "", 1, 8);
            test!(func, toer)(`"&g;"`, "&g;", "", 1, 6);
            test!(func, toer)(`"&gte;"`, "&gte;", "", 1, 8);
            test!(func, toer)(`"&apo;"`, "&apo;", "", 1, 8);
            test!(func, toer)(`"&aposs;"`, "&aposs;", "", 1, 10);
            test!(func, toer)(`"&quo;"`, "&quo;", "", 1, 8);
            test!(func, toer)(`"&quote;"`, "&quote;", "", 1, 10);

            test!(func, toer)(`'&foo;'`, "&foo;", "", 1, 8);
            test!(func, toer)(`'hello world&foo;'`, "hello world&foo;", "", 1, 19);
            test!(func, toer)(`'hello &foo; world'`, "hello &foo; world", "", 1, 20);
            test!(func, toer)(`'&am;'`, "&am;", "", 1, 7);
            test!(func, toer)(`'&ampe;'`, "&ampe;", "", 1, 9);
            test!(func, toer)(`'&l;'`, "&l;", "", 1, 6);
            test!(func, toer)(`'&lte;'`, "&lte;", "", 1, 8);
            test!(func, toer)(`'&g;'`, "&g;", "", 1, 6);
            test!(func, toer)(`'&gte;'`, "&gte;", "", 1, 8);
            test!(func, toer)(`'&apo;'`, "&apo;", "", 1, 8);
            test!(func, toer)(`'&aposs;'`, "&aposs;", "", 1, 10);
            test!(func, toer)(`'&quo;'`, "&quo;", "", 1, 8);
            test!(func, toer)(`'&quote;'`, "&quote;", "", 1, 10);
        }
    }

    // These can't be tested with testFail, because attempting to convert
    // invalid Unicode results in UnicodeExceptions before parseXML even
    // gets called.
    import std.meta : AliasSeq;
    static foreach(str; AliasSeq!("'" ~ cast(string)[255] ~ "'",
                                  "'"w ~ cast(wstring)[0xD800] ~ "'",
                                  "'"d ~ cast(dstring)[0xD800] ~ "'"))
    {{
        auto text = testParser(str);
        auto e = collectException!XMLParsingException(text.takeAttValue());
        assert(e ! is null);
        assert(e.pos == TextPos(1, 2));
    }}
}

@safe pure unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {
        static foreach(config; [Config.init, simpleXML, makeConfig(ThrowOnEntityRef.no)])
        {{
            auto xml = func(`'foo'`);
            auto text = testParser!simpleXML(xml);
            assert(equal(text.takeAttValue(), "foo"));
        }}
    }
}


// Validates an EntityType.text field to verify that it does not contain invalid
// characters.
void checkText(bool allowRestrictedChars, Text)(ref Text orig)
{
    import std.format : format;
    import std.utf : decodeFront, UseReplacementDchar;

    auto text = orig.save;
    loop: while(!text.input.empty)
    {
        switch(text.input.front)
        {
            static if(!allowRestrictedChars)
            {
                case '&':
                {
                    import qt.widgets.internal.dxml.util : parseCharRef;

                    {
                        auto temp = text.input.save;
                        auto charRef = parseCharRef(temp);
                        if(!charRef.isNull)
                        {
                            static if(hasLength!(Text.Input))
                            {
                                text.pos.col += text.input.length - temp.length;
                                text.input = temp;
                            }
                            else
                            {
                                while(text.input.front != ';')
                                    popFrontAndIncCol(text);
                                popFrontAndIncCol(text);
                            }
                            continue;
                        }
                    }

                    immutable ampPos = text.pos;
                    popFrontAndIncCol(text);

                    // Std Entity References
                    static if(Text.config.throwOnEntityRef == ThrowOnEntityRef.yes)
                    {
                        static foreach(entRef; ["amp;", "apos;", "quot;", "lt;", "gt;"])
                        {
                            if(text.stripStartsWith(entRef))
                                continue loop;
                        }

                        throw new XMLParsingException("& is only legal in an EntitType.text entity as part of a " ~
                                                      "reference, and this parser only supports entity references if " ~
                                                      "they're predefined by the spec. This is not a valid character " ~
                                                      "reference or one of the predefined entity references.", ampPos);
                    }
                    // All Entity References
                    else
                    {
                        import std.utf : decodeFront, UseReplacementDchar;
                        import qt.widgets.internal.dxml.internal : isNameStartChar, isNameChar;

                        if(text.input.empty)
                            goto failedEntityRef;
                        {
                            size_t numCodeUnits;
                            immutable decodedC = text.input.decodeFront!(UseReplacementDchar.yes)(numCodeUnits);
                            if(!isNameStartChar(decodedC))
                                goto failedEntityRef;
                            text.pos.col += numCodeUnits;
                        }
                        while(true)
                        {
                            if(text.input.empty)
                                goto failedEntityRef;
                            immutable c = text.input.front;
                            if(c == ';')
                                break;
                            size_t numCodeUnits;
                            immutable decodedC = text.input.decodeFront!(UseReplacementDchar.yes)(numCodeUnits);
                            if(!isNameChar(decodedC))
                                goto failedEntityRef;
                            text.pos.col += numCodeUnits;
                        }
                        assert(text.input.front == ';');
                        popFrontAndIncCol(text);
                        continue;

                        failedEntityRef:
                        throw new XMLParsingException("& is only legal in an attribute value as part of a " ~
                                                      "character or entity reference, and this is not a valid " ~
                                                      "character or entity reference.", ampPos);
                    }
                }
                case '<': throw new XMLParsingException("< is not legal in EntityType.text", text.pos);
                case ']':
                {
                    popFrontAndIncCol(text);
                    if(text.stripStartsWith("]>"))
                    {
                        text.pos.col -= 3;
                        throw new XMLParsingException("]]> is not legal in EntityType.text", text.pos);
                    }
                    break;
                }
            }
            case '\n':
            {
                nextLine!(text.config)(text.pos);
                text.input.popFront();
                break;
            }
            default:
            {
                import std.ascii : isASCII;
                import qt.widgets.internal.dxml.internal : isXMLChar;
                immutable c = text.input.front;
                if(isASCII(c))
                {
                    if(!isXMLChar(c))
                    {
                        throw new XMLParsingException(format!"Character is not legal in an XML File: 0x%0x"(c),
                                                      text.pos);
                    }
                    popFrontAndIncCol(text);
                }
                else
                {
                    import std.utf : UTFException;
                    // Annoyngly, letting decodeFront throw is the easier way to handle this, since the
                    // replacement character is considered valid XML, and if we decoded using it, then
                    // all of the invalid Unicode characters would come out as the replacement character
                    // and then be treated as valid instead of being caught, which isn't all bad, but
                    // the spec requires that they be treated as invalid instead of playing nice and
                    // using the replacement character.
                    try
                    {
                        size_t numCodeUnits;
                        immutable decodedC = text.input.decodeFront!(UseReplacementDchar.no)(numCodeUnits);
                        if(!isXMLChar(decodedC))
                        {
                            enum fmt = "Character is not legal in an XML File: 0x%0x";
                            throw new XMLParsingException(format!fmt(decodedC), text.pos);
                        }
                        text.pos.col += numCodeUnits;
                    }
                    catch(UTFException)
                        throw new XMLParsingException("Invalid Unicode character", text.pos);
                }
                break;
            }
        }
    }
}

unittest
{
    import core.exception : AssertError;
    import std.exception : assertNotThrown, collectException, enforce;
    import qt.widgets.internal.dxml.internal : codeLen, testRangeFuncs;

    static void test(alias func, bool arc, ThrowOnEntityRef toer)(string text, size_t line = __LINE__)
    {
        auto xml = func(text);
        auto range = testParser!(makeConfig(toer))(xml);
        assertNotThrown(checkText!arc(range), "unittest failure", __FILE__, line);
    }

    static void testFail(alias func, bool arc, ThrowOnEntityRef toer)(string text, int row, int col, size_t line = __LINE__)
    {
        auto xml = func(text);
        {
            auto range = testParser!(makeConfig(toer))(xml.save);
            auto e = collectException!XMLParsingException(checkText!arc(range));
            enforce!AssertError(e !is null, "unittest failure 1", __FILE__, line);
            enforce!AssertError(e.pos == TextPos(row, col), "unittest failure 2", __FILE__, line);
        }
        {
            auto pos = TextPos(row + 3, row == 1 ? col + 7 : col);
            auto range = testParser!(makeConfig(toer))(xml);
            range.pos.line += 3;
            range.pos.col += 7;
            auto e = collectException!XMLParsingException(checkText!arc(range));
            enforce!AssertError(e !is null, "unittest failure 3", __FILE__, line);
            enforce!AssertError(e.pos == pos, "unittest failure 4", __FILE__, line);
        }
    }

    static foreach(func; testRangeFuncs)
    {
        static foreach(toer; [ThrowOnEntityRef.yes, ThrowOnEntityRef.no])
        {
            static foreach(arc; [false, true])
            {
                test!(func, arc, toer)("");
                test!(func, arc, toer)("J",);
                test!(func, arc, toer)("foo");
                test!(func, arc, toer)("プログラミング");

                test!(func, arc, toer)("&amp;&gt;&lt;");
                test!(func, arc, toer)("hello&amp;&gt;&lt;world");
                test!(func, arc, toer)(".....&apos;&quot;&amp;.....");
                test!(func, arc, toer)("&#12487;&#12451;&#12521;&#12531;");
                test!(func, arc, toer)("hello&#xAF;&#42;&quot;world");

                test!(func, arc, toer)("]]");
                test!(func, arc, toer)("]>");
                test!(func, arc, toer)("foo]]bar");
                test!(func, arc, toer)("foo]>bar");
                test!(func, arc, toer)("]] >");

                testFail!(func, arc, toer)("\v", 1, 1);
                testFail!(func, arc, toer)("\uFFFE", 1, 1);
                testFail!(func, arc, toer)("hello\vworld", 1, 6);
                testFail!(func, arc, toer)("he\nllo\vwo\nrld", 2, 4);
            }

            testFail!(func, false, toer)("<", 1, 1);
            testFail!(func, false, toer)("&", 1, 1);
            testFail!(func, false, toer)("&", 1, 1);
            testFail!(func, false, toer)("&x", 1, 1);
            testFail!(func, false, toer)("&&;", 1, 1);
            testFail!(func, false, toer)("&a", 1, 1);
            testFail!(func, false, toer)("hello&;", 1, 6);
            testFail!(func, false, toer)("hello&;world", 1, 6);
            testFail!(func, false, toer)("hello&<;world", 1, 6);
            testFail!(func, false, toer)("hello&world", 1, 6);
            testFail!(func, false, toer)("hello world&", 1, 12);
            testFail!(func, false, toer)("hello world&;", 1, 12);
            testFail!(func, false, toer)("hello world&foo", 1, 12);
            testFail!(func, false, toer)("&#;", 1, 1);
            testFail!(func, false, toer)("&#x;", 1, 1);
            testFail!(func, false, toer)("&#AF;", 1, 1);
            testFail!(func, false, toer)("&#x", 1, 1);
            testFail!(func, false, toer)("&#42", 1, 1);
            testFail!(func, false, toer)("&#x42", 1, 1);
            testFail!(func, false, toer)("&#12;", 1, 1);
            testFail!(func, false, toer)("&#x12;", 1, 1);
            testFail!(func, false, toer)("&#42;foo\nbar&#;", 2, 4);
            testFail!(func, false, toer)("&#42;foo\nbar&#x;", 2, 4);
            testFail!(func, false, toer)("&#42;foo\nbar&#AF;", 2, 4);
            testFail!(func, false, toer)("&#42;foo\nbar&#x", 2, 4);
            testFail!(func, false, toer)("&#42;foo\nbar&#42", 2, 4);
            testFail!(func, false, toer)("&#42;foo\nbar&#x42", 2, 4);
            testFail!(func, false, toer)("プログラミング&", 1, codeLen!(func, "プログラミング&"));

            static if(toer == ThrowOnEntityRef.yes)
            {
                testFail!(func, false, toer)("&a;", 1, 1);
                testFail!(func, false, toer)(`&am;`, 1, 1);
                testFail!(func, false, toer)(`&ampe;`, 1, 1);
                testFail!(func, false, toer)(`&l;`, 1, 1);
                testFail!(func, false, toer)(`&lte;`, 1, 1);
                testFail!(func, false, toer)(`&g;`, 1, 1);
                testFail!(func, false, toer)(`&gte;`, 1, 1);
                testFail!(func, false, toer)(`&apo;`, 1, 1);
                testFail!(func, false, toer)(`&aposs;`, 1, 1);
                testFail!(func, false, toer)(`&quo;`, 1, 1);
                testFail!(func, false, toer)(`&quote;`, 1, 1);
                testFail!(func, false, toer)(`hello &foo; world`, 1, 7);
                testFail!(func, false, toer)("hello\n &foo; \nworld", 2, 2);
            }
            else
            {
                test!(func, false, toer)("&a;");
                test!(func, false, toer)(`&am;`);
                test!(func, false, toer)(`&ampe;`);
                test!(func, false, toer)(`&l;`);
                test!(func, false, toer)(`&lte;`);
                test!(func, false, toer)(`&g;`);
                test!(func, false, toer)(`&gte;`);
                test!(func, false, toer)(`&apo;`);
                test!(func, false, toer)(`&aposs;`);
                test!(func, false, toer)(`&quo;`);
                test!(func, false, toer)(`&quote;`);
                test!(func, false, toer)(`hello &foo; world`);
                test!(func, false, toer)("hello\n &foo; \nworld");
            }

            testFail!(func, false, toer)("]]>", 1, 1);
            testFail!(func, false, toer)("foo]]>bar", 1, 4);

            test!(func, true, toer)("]]>");
            test!(func, true, toer)("foo]]>bar");

            test!(func, true, toer)("<");
            test!(func, true, toer)("&");
            test!(func, true, toer)("&x");
            test!(func, true, toer)("&&;");
            test!(func, true, toer)("&a");
            test!(func, true, toer)("&a;");
            test!(func, true, toer)(`&am;`);
            test!(func, true, toer)(`&ampe;`);
            test!(func, true, toer)(`&l;`);
            test!(func, true, toer)(`&lte;`);
            test!(func, true, toer)(`&g;`);
            test!(func, true, toer)(`&gte;`);
            test!(func, true, toer)(`&apo;`);
            test!(func, true, toer)(`&aposs;`);
            test!(func, true, toer)(`&quo;`);
            test!(func, true, toer)(`&quote;`);
            test!(func, true, toer)("hello&;");
            test!(func, true, toer)("hello&;world");
            test!(func, true, toer)("hello&<;world");
            test!(func, true, toer)("hello&world");
            test!(func, true, toer)("hello world&");
            test!(func, true, toer)("hello world&;");
            test!(func, true, toer)("hello world&foo");
            test!(func, true, toer)("&#;");
            test!(func, true, toer)("&#x;");
            test!(func, true, toer)("&#AF;");
            test!(func, true, toer)("&#x");
            test!(func, true, toer)("&#42");
            test!(func, true, toer)("&#x42");
            test!(func, true, toer)("&#12;");
            test!(func, true, toer)("&#x12;");
            test!(func, true, toer)("&#42;foo\nbar&#;");
            test!(func, true, toer)("&#42;foo\nbar&#x;");
            test!(func, true, toer)("&#42;foo\nbar&#AF;");
            test!(func, true, toer)("&#42;foo\nbar&#x");
            test!(func, true, toer)("&#42;foo\nbar&#42");
            test!(func, true, toer)("&#42;foo\nbar&#x42");
            test!(func, true, toer)("プログラミング&");
        }
    }

    // These can't be tested with testFail, because attempting to convert
    // invalid Unicode results in UnicodeExceptions before parseXML even
    // gets called.
    import std.meta : AliasSeq;
    static foreach(str; AliasSeq!(cast(string)[255], cast(wstring)[0xD800], cast(dstring)[0xD800]))
    {
        static foreach(arc; [false, true])
        {{
            auto text = testParser(str);
            auto e = collectException!XMLParsingException(text.checkText!arc());
            assert(e ! is null);
            assert(e.pos == TextPos(1, 1));
        }}
    }
}

@safe unittest
{
    import qt.widgets.internal.dxml.internal : testRangeFuncs;

    static foreach(func; testRangeFuncs)
    {
        static foreach(arc; [false, true])
        {
            static foreach(config; [Config.init, simpleXML, makeConfig(ThrowOnEntityRef.no)])
            {{
                auto xml = func("foo");
                auto text = testParser!config(xml);
                checkText!arc(text);
            }}
        }
    }
}


// S := (#x20 | #x9 | #xD | #XA)+
bool isSpace(C)(C c) @safe pure nothrow @nogc
    if(isSomeChar!C)
{
    switch(c)
    {
        case ' ':
        case '\t':
        case '\r':
        case '\n': return true;
        default : return false;
    }
}

pure nothrow @safe @nogc unittest
{
    foreach(char c; char.min .. char.max)
    {
        if(c == ' ' || c == '\t' || c == '\r' || c == '\n')
            assert(isSpace(c));
        else
            assert(!isSpace(c));
    }
    foreach(wchar c; wchar.min .. wchar.max / 100)
    {
        if(c == ' ' || c == '\t' || c == '\r' || c == '\n')
            assert(isSpace(c));
        else
            assert(!isSpace(c));
    }
    foreach(dchar c; dchar.min .. dchar.max / 1000)
    {
        if(c == ' ' || c == '\t' || c == '\r' || c == '\n')
            assert(isSpace(c));
        else
            assert(!isSpace(c));
    }
}


pragma(inline, true) void popFrontAndIncCol(Text)(ref Text text)
{
    text.input.popFront();
    ++text.pos.col;
}

pragma(inline, true) void nextLine(Config config)(ref TextPos pos)
{
    ++pos.line;
    pos.col = 1;
}

// TODO create bug report, because this function cannot be inlined
/+pragma(inline, true)+/ void checkNotEmpty(Text)(ref Text text, size_t line = __LINE__)
{
    if(text.input.empty)
        throw new XMLParsingException("Prematurely reached end of document", text.pos, __FILE__, line);
}


version(unittest)
    enum someTestConfigs = [Config.init, simpleXML, makeConfig(SkipComments.yes), makeConfig(SkipPI.yes)];


// Fuzz-testing failures
unittest
{
    static void parseEverything(string xml)
    {
        with(EntityType) foreach(entity; parseXML(xml))
        {
            final switch(entity.type)
            {
                case cdata: break;
                case comment: break;
                case elementStart: auto name = entity.name; break;
                case elementEnd: goto case elementStart;
                case elementEmpty: goto case elementStart;
                case pi: goto case elementStart;
                case text: break;
            }

            final switch(entity.type)
            {
                case cdata: auto text = entity.text; break;
                case comment: goto case cdata;
                case elementStart:
                {
                    foreach(attr; entity.attributes)
                    {
                        auto name = attr.name;
                        auto value = attr.value;
                    }
                    break;
                }
                case elementEnd: break;
                case elementEmpty: goto case elementStart;
                case pi: goto case cdata;
                case text: goto case cdata;
            }
        }
    }

    static void testFail(string xml, size_t line = __LINE__)
    {
        import std.exception : assertThrown;
        assertThrown!XMLParsingException(parseEverything(xml));
    }

    testFail([0x3c, 0xff, 0x3e, 0x3e, 0x3a, 0x3c, 0x2f, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
              0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
              0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
              0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
              0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x31, 0xff,
              0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xd8, 0xd8, 0xd8, 0xd8, 0xd8, 0xff, 0xff,
              0xff]);
}
