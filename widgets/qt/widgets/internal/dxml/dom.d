// Written in the D programming language

/++
    This implements a DOM for representing an XML 1.0 document. $(LREF parseDOM)
    uses an $(REF EntityRange, dxml, parser) to parse the document, and
    $(LREF DOMEntity) recursively represents the DOM tree.

    See the documentation for $(MREF dxml, parser) and
    $(REF EntityRange, dxml, parser) for details on the parser and its
    configuration options.

    For convenience, $(REF EntityType, dxml, parser) and
    $(REF simpleXML, dxml, parser) are publicly imported by this module,
    since $(REF_ALTTEXT EntityType, EntityType, dxml, parser) is required
    to correctly use $(LREF DOMEntity), and
    $(REF_ALTTEXT simpleXML, simpleXML, dxml, parser) is highly likely to
    be used when calling $(LREF parseDOM).

    Copyright: Copyright 2018 - 2020
    License:   $(HTTP www.boost.org/LICENSE_1_0.txt, Boost License 1.0).
    Authors:   $(HTTPS jmdavisprog.com, Jonathan M Davis)
    Source:    $(LINK_TO_SRC dxml/_dom.d)

    See_Also: $(LINK2 http://www.w3.org/TR/REC-xml/, Official Specification for XML 1.0)
  +/
module qt.widgets.internal.dxml.dom;

///
unittest
{
    import std.range.primitives : empty;

    auto xml = "<!-- comment -->\n" ~
               "<root>\n" ~
               "    <foo>some text<whatever/></foo>\n" ~
               "    <bar/>\n" ~
               "    <baz></baz>\n" ~
               "</root>";
    {
        auto dom = parseDOM(xml);
        assert(dom.type == EntityType.elementStart);
        assert(dom.name.empty);
        assert(dom.children.length == 2);

        assert(dom.children[0].type == EntityType.comment);
        assert(dom.children[0].text == " comment ");

        auto root = dom.children[1];
        assert(root.type == EntityType.elementStart);
        assert(root.name == "root");
        assert(root.children.length == 3);

        auto foo = root.children[0];
        assert(foo.type == EntityType.elementStart);
        assert(foo.name == "foo");
        assert(foo.children.length == 2);

        assert(foo.children[0].type == EntityType.text);
        assert(foo.children[0].text == "some text");

        assert(foo.children[1].type == EntityType.elementEmpty);
        assert(foo.children[1].name == "whatever");

        assert(root.children[1].type == EntityType.elementEmpty);
        assert(root.children[1].name == "bar");

        assert(root.children[2].type == EntityType.elementStart);
        assert(root.children[2].name == "baz");
        assert(root.children[2].children.length == 0);
    }
    {
        auto dom = parseDOM!simpleXML(xml);
        assert(dom.type == EntityType.elementStart);
        assert(dom.name.empty);
        assert(dom.children.length == 1);

        auto root = dom.children[0];
        assert(root.type == EntityType.elementStart);
        assert(root.name == "root");
        assert(root.children.length == 3);

        auto foo = root.children[0];
        assert(foo.type == EntityType.elementStart);
        assert(foo.name == "foo");
        assert(foo.children.length == 2);

        assert(foo.children[0].type == EntityType.text);
        assert(foo.children[0].text == "some text");

        assert(foo.children[1].type == EntityType.elementStart);
        assert(foo.children[1].name == "whatever");
        assert(foo.children[1].children.length == 0);

        assert(root.children[1].type == EntityType.elementStart);
        assert(root.children[1].name == "bar");
        assert(root.children[1].children.length == 0);

        assert(root.children[2].type == EntityType.elementStart);
        assert(root.children[2].name == "baz");
        assert(root.children[2].children.length == 0);
    }
}


import std.range.primitives;
import std.traits;

public import qt.widgets.internal.dxml.parser : EntityType, simpleXML;
import qt.widgets.internal.dxml.parser : Config, EntityRange;


/++
    Represents an entity in an XML document as a DOM tree.

    parseDOM either takes a range of characters or an
    $(REF EntityRange, dxml, parser) and generates a DOMEntity from that XML.

    When parseDOM processes the XML, it returns a DOMEntity representing the
    entire document. Even though the XML document itself isn't technically an
    entity in the XML document, it's simplest to treat it as if it were an
    $(REF_ALTTEXT EntityType.elementStart, EntityType.elementStart, dxml, parser)
    with an empty $(LREF2 name, _DOMEntity.name). That DOMEntity then contains
    child entities that recursively define the DOM tree through their children.

    For DOMEntities of type
    $(REF_ALTTEXT EntityType.elementStart, EntityType.elementStart, dxml, parser),
    $(LREF _DOMEntity.children) gives access to all of the child entities of
    that start tag. Other DOMEntities have no children.

    Note that the $(LREF2 type, _DOMEntity.type) determines which
    properties of the DOMEntity can be used, and it can determine whether
    functions which a DOMEntity is passed to are allowed to be called. Each
    function lists which $(REF_ALTTEXT EntityType, EntityType, dxml, parser)s
    are allowed, and it is an error to call them with any other
    $(REF_ALTTEXT EntityType, EntityType, dxml, parser).

    If parseDOM is given a range of characters, it in turn passes that to
    $(REF parseXML, dxml, parser) to do the actual XML parsing. As such, that
    overload accepts an optional $(REF Config, dxml, parser) as a template
    argument to configure the parser.

    If parseDOM is given an
    $(REF_ALTTEXT EntityRange, EntityRange, dxml, parser), the range does
    not have to be at the start of the document. It can be used to create a DOM
    for a portion of the document. When a character range is passed to it, it
    will return a DOMEntity with the $(LREF2 type, _DOMEntity.type)
    $(REF_ALTTEXT EntityType.elementStart, EntityType.elementStart, dxml, parser)
    and an empty $(LREF2 name, _DOMEntity.name). It will iterate the range until
    it either reaches the end of the range, or it reaches the end tag which
    matches the start tag which is the parent of the entity that was the
    $(D front) of the range when it was passed to parseDOM. The
    $(REF_ALTTEXT EntityType.elementStart, EntityType.elementStart, dxml, parser)
    is passed by $(K_REF), so if it was not at the top level when it was passed
    to parseDOM (and thus still has elements in it when parseDOM returns), the
    range will then be at the entity after that matching end tag, and the
    application can continue to process the range after that if it so chooses.

    Params:
        config = The $(REF Config, dxml, parser) to use with
                 $(REF parseXML, dxml, parser) if the range passed to parseDOM
                 is a range of characters.
        range = Either a range of characters representing an entire XML document
                or a $(REF EntityRange, dxml, parser) which may refer to some
                or all of an XML document.

    Returns: A DOMEntity representing the DOM tree from the point in the
             document that was passed to parseDOM (the start of the document if
             a range of characters was passed, and wherever in the document the
             range was if an
             $(REF_ALTTEXT EntityRange, EntityRange dxml, parser) was passed).

    Throws: $(REF_ALTTEXT XMLParsingException, XMLParsingException, dxml, parser)
            if the parser encounters invalid XML.
  +/
struct DOMEntity(R)
{
public:

    import std.algorithm.searching : canFind;
    import std.range : only, takeExactly;
    import std.typecons : Tuple;
    import qt.widgets.internal.dxml.parser : TextPos;

    private enum compileInTests = is(R == DOMCompileTests);

    /++
        The type used when any slice of the original range of characters is
        used. If the range was a string or supports slicing, then SliceOfR is
        the same type as the range; otherwise, it's the result of calling
        $(PHOBOS_REF takeExactly, std, range) on it.

        ---
        import std.algorithm : filter;
        import std.range : takeExactly;

        static assert(is(DOMEntity!string.SliceOfR == string));

        auto range = filter!(a => true)("some xml");

        static assert(is(DOMEntity!(typeof(range)).SliceOfR ==
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

        static assert(is(DOMEntity!string.SliceOfR == string));

        auto range = filter!(a => true)("some xml");

        static assert(is(DOMEntity!(typeof(range)).SliceOfR ==
                         typeof(takeExactly(range, 42))));
    }


    /++
        The exact instantiation of $(PHOBOS_REF Tuple, std, typecons) that
        $(LREF2 attributes, DOMEntity) returns a range of.

        See_Also: $(LREF2 attributes, DOMEntity)
      +/
    alias Attribute = Tuple!(SliceOfR, "name", SliceOfR, "value", TextPos,  "pos");


    /++
        The $(REF_ALTTEXT EntityType, EntityType, dxml, parser) for this
        DOMEntity.

        The type can never be
        $(REF_ALTTEXT EntityType.elementEnd, EntityType.elementEnd, dxml, parser),
        because the end of $(LREF2 children, DOMEntity.children) already
        indicates where the contents of the start tag end.

        type determines which properties of the DOMEntity can be used, and it
        can determine whether functions which a DOMEntity is passed to are
        allowed to be called. Each function lists which
        $(REF_ALTTEXT EntityType, EntityType, dxml, parser)s are allowed, and it
        is an error to call them with any other
        $(REF_ALTTEXT EntityType, EntityType, dxml, parser).
      +/
    @property EntityType type() @safe const pure nothrow @nogc
    {
        return _type;
    }

    ///
    static if(compileInTests) unittest
    {
        import std.range.primitives;

        auto xml = "<root>\n" ~
                   "    <!--no comment-->\n" ~
                   "    <![CDATA[cdata run]]>\n" ~
                   "    <text>I am text!</text>\n" ~
                   "    <empty/>\n" ~
                   "    <?pi?>\n" ~
                   "</root>";

        auto dom = parseDOM(xml);
        assert(dom.type == EntityType.elementStart);
        assert(dom.name.empty);
        assert(dom.children.length == 1);

        auto root = dom.children[0];
        assert(root.type == EntityType.elementStart);
        assert(root.name == "root");
        assert(root.children.length == 5);

        assert(root.children[0].type == EntityType.comment);
        assert(root.children[0].text == "no comment");

        assert(root.children[1].type == EntityType.cdata);
        assert(root.children[1].text == "cdata run");

        auto textTag = root.children[2];
        assert(textTag.type == EntityType.elementStart);
        assert(textTag.name == "text");
        assert(textTag.children.length == 1);

        assert(textTag.children[0].type == EntityType.text);
        assert(textTag.children[0].text == "I am text!");

        assert(root.children[3].type == EntityType.elementEmpty);
        assert(root.children[3].name == "empty");

        assert(root.children[4].type == EntityType.pi);
        assert(root.children[4].name == "pi");
    }


    /++
        The position in the the original text where the entity starts.

        See_Also: $(REF_ALTTEXT TextPos, TextPos, dxml, parser)$(BR)
                  $(REF_ALTTEXT XMLParsingException._pos, XMLParsingException._pos, dxml, parser)
      +/
    @property TextPos pos() @safe const pure nothrow @nogc
    {
        return _pos;
    }

    ///
    static if(compileInTests) unittest
    {
        import std.range.primitives : empty;
        import qt.widgets.internal.dxml.parser : TextPos;
        import qt.widgets.internal.dxml.util : stripIndent;

        auto xml = "<root>\n" ~
                   "    <foo>\n" ~
                   "        Foo and bar. Always foo and bar...\n" ~
                   "    </foo>\n" ~
                   "</root>";

        auto dom = parseDOM(xml);
        assert(dom.type == EntityType.elementStart);
        assert(dom.name.empty);
        assert(dom.pos == TextPos(1, 1));

        auto root = dom.children[0];
        assert(root.type == EntityType.elementStart);
        assert(root.name == "root");
        assert(root.pos == TextPos(1, 1));

        auto foo = root.children[0];
        assert(foo.type == EntityType.elementStart);
        assert(foo.name == "foo");
        assert(foo.pos == TextPos(2, 5));

        auto text = foo.children[0];
        assert(text.type == EntityType.text);
        assert(text.text.stripIndent() ==
               "Foo and bar. Always foo and bar...");
        assert(text.pos == TextPos(2, 10));
    }


    /++
        Gives the name of this DOMEntity.

        Note that this is the direct name in the XML for this entity and
        does not contain any of the names of any of the parent entities that
        this entity has.

        $(TABLE
            $(TR $(TH Supported $(LREF EntityType)s:))
            $(TR $(TD $(REF_ALTTEXT elementStart, EntityType.elementStart, dxml, parser)))
            $(TR $(TD $(REF_ALTTEXT elementEnd, EntityType.elementEnd, dxml, parser)))
            $(TR $(TD $(REF_ALTTEXT elementEmpty, EntityType.elementEmpty, dxml, parser)))
            $(TR $(TD $(REF_ALTTEXT pi, EntityType.pi, dxml, parser)))
        )

        See_Also: $(LREF2 path, DOMEntity.path)
      +/
    @property SliceOfR name()
    {
        import qt.widgets.internal.dxml.internal : checkedSave;
        with(EntityType)
        {
            import std.format : format;
            assert(only(elementStart, elementEnd, elementEmpty, pi).canFind(_type),
                   format("name cannot be called with %s", _type));
        }
        return checkedSave(_name);
    }

    ///
    static if(compileInTests) unittest
    {
        import std.range.primitives : empty;

        auto xml = "<root>\n" ~
                   "    <empty/>\n" ~
                   "    <?pi?>\n" ~
                   "</root>";

        auto dom = parseDOM(xml);
        assert(dom.type == EntityType.elementStart);
        assert(dom.name.empty);

        auto root = dom.children[0];
        assert(root.type == EntityType.elementStart);
        assert(root.name == "root");

        assert(root.children[0].type == EntityType.elementEmpty);
        assert(root.children[0].name == "empty");

        assert(root.children[1].type == EntityType.pi);
        assert(root.children[1].name == "pi");
    }


    /++
        Gives the list of the names of the parent start tags of this DOMEntity.

        The name of the current entity (if it has one) is not included in the
        path.

        Note that if parseDOM were given an
        $(REF_ALTTEXT EntityRange, EntityRange, dxml, parser), the path
        starts where the range started. So, it doesn't necessarily contain the
        entire path from the start of the XML document.

        See_Also: $(LREF2 name, DOMEntity.name)
      +/
    @property SliceOfR[] path()
    {
        return _path;
    }

    ///
    static if(compileInTests) unittest
    {
        import std.range.primitives : empty;

        auto xml = "<root>\n" ~
                   "    <bar>\n" ~
                   "        <baz>\n" ~
                   "            <xyzzy/>\n" ~
                   "        </baz>\n" ~
                   "        <frobozz>\n" ~
                   "            <!-- comment -->\n" ~
                   "            It's magic!\n" ~
                   "        </frobozz>\n" ~
                   "    </bar>\n" ~
                   "    <foo></foo>\n" ~
                   "</root>";

        auto dom = parseDOM(xml);
        assert(dom.type == EntityType.elementStart);
        assert(dom.name.empty);
        assert(dom.path.empty);

        auto root = dom.children[0];
        assert(root.type == EntityType.elementStart);
        assert(root.name == "root");
        assert(root.path.empty);

        auto bar = root.children[0];
        assert(bar.type == EntityType.elementStart);
        assert(bar.name == "bar");
        assert(bar.path == ["root"]);

        auto baz = bar.children[0];
        assert(baz.type == EntityType.elementStart);
        assert(baz.name == "baz");
        assert(baz.path == ["root", "bar"]);

        auto xyzzy = baz.children[0];
        assert(xyzzy.type == EntityType.elementEmpty);
        assert(xyzzy.name == "xyzzy");
        assert(xyzzy.path == ["root", "bar", "baz"]);

        auto frobozz = bar.children[1];
        assert(frobozz.type == EntityType.elementStart);
        assert(frobozz.name == "frobozz");
        assert(frobozz.path == ["root", "bar"]);

        auto comment = frobozz.children[0];
        assert(comment.type == EntityType.comment);
        assert(comment.text == " comment ");
        assert(comment.path == ["root", "bar", "frobozz"]);

        auto text = frobozz.children[1];
        assert(text.type == EntityType.text);
        assert(text.text == "\n            It's magic!\n        ");
        assert(text.path == ["root", "bar", "frobozz"]);

        auto foo = root.children[1];
        assert(foo.type == EntityType.elementStart);
        assert(foo.name == "foo");
        assert(foo.path == ["root"]);
    }


    /++
        Returns a dynamic array of attributes for a start tag where each
        attribute is represented as a$(BR)
        $(D $(PHOBOS_REF_ALTTEXT Tuple, Tuple, std, typecons)!(
                  $(LREF2 SliceOfR, EntityRange), $(D_STRING "name"),
                  $(LREF2 SliceOfR, EntityRange), $(D_STRING "value"),
                  $(REF_ALTTEXT TextPos, TextPos, dxml, parser), $(D_STRING "pos"))).

        $(TABLE
            $(TR $(TH Supported $(LREF EntityType)s:))
            $(TR $(TD $(REF_ALTTEXT elementStart, EntityType.elementStart, dxml, parser)))
            $(TR $(TD $(REF_ALTTEXT elementEmpty, EntityType.elementEmpty, dxml, parser)))
        )

        See_Also: $(LREF DomEntity.Attribute)$(BR)
                  $(REF normalize, dxml, util)$(BR)
                  $(REF asNormalized, dxml, util)
      +/
    @property auto attributes()
    {
        with(EntityType)
        {
            import std.format : format;
            assert(_type == elementStart || _type == elementEmpty,
                   format("attributes cannot be called with %s", _type));
        }
        return _attributes;
    }

    ///
    static if(compileInTests) unittest
    {
        import std.algorithm.comparison : equal;
        import std.algorithm.iteration : filter;
        import std.range.primitives : empty;
        import qt.widgets.internal.dxml.parser : TextPos;

        {
            auto xml = "<root/>";
            auto root = parseDOM(xml).children[0];
            assert(root.type == EntityType.elementEmpty);
            assert(root.attributes.empty);

            static assert(is(ElementType!(typeof(root.attributes)) ==
                             typeof(root).Attribute));
        }
        {
            auto xml = "<root a='42' q='29' w='hello'/>";
            auto root = parseDOM(xml).children[0];
            assert(root.type == EntityType.elementEmpty);

            auto attrs = root.attributes;
            assert(attrs.length == 3);

            assert(attrs[0].name == "a");
            assert(attrs[0].value == "42");
            assert(attrs[0].pos == TextPos(1, 7));

            assert(attrs[1].name == "q");
            assert(attrs[1].value == "29");
            assert(attrs[1].pos == TextPos(1, 14));

            assert(attrs[2].name == "w");
            assert(attrs[2].value == "hello");
            assert(attrs[2].pos == TextPos(1, 21));
        }
        // Because the type of name and value is SliceOfR, == with a string
        // only works if the range passed to parseXML was string.
        {
            auto xml = filter!"true"("<root a='42' q='29' w='hello'/>");
            auto root = parseDOM(xml).children[0];
            assert(root.type == EntityType.elementEmpty);

            auto attrs = root.attributes;
            assert(attrs.length == 3);

            assert(equal(attrs[0].name, "a"));
            assert(equal(attrs[0].value, "42"));
            assert(attrs[0].pos == TextPos(1, 7));

            assert(equal(attrs[1].name, "q"));
            assert(equal(attrs[1].value, "29"));
            assert(attrs[1].pos == TextPos(1, 14));

            assert(equal(attrs[2].name, "w"));
            assert(equal(attrs[2].value, "hello"));
            assert(attrs[2].pos == TextPos(1, 21));
        }
    }


    /++
        Returns the textual value of this DOMEntity.

        In the case of
        $(REF_ALTTEXT EntityType.pi, EntityType.pi, dxml, parser), this is the
        text that follows the name, whereas in the other cases, the text is the
        entire contents of the entity (save for the delimeters on the ends if
        that entity has them).

        $(TABLE
            $(TR $(TH Supported $(LREF EntityType)s:))
            $(TR $(TD $(REF_ALTTEXT cdata, EntityType.cdata, dxml, parser)))
            $(TR $(TD $(REF_ALTTEXT comment, EntityType.comment, dxml, parser)))
            $(TR $(TD $(REF_ALTTEXT pi, EntityType.pi, dxml, parser)))
            $(TR $(TD $(REF_ALTTEXT _text, EntityType._text, dxml, parser)))
        )

        See_Also: $(REF normalize, dxml, util)$(BR)
                  $(REF asNormalized, dxml, util)$(BR)
                  $(REF stripIndent, dxml, util)$(BR)
                  $(REF withoutIndent, dxml, util)
      +/
    @property SliceOfR text()
    {
        import qt.widgets.internal.dxml.internal : checkedSave;
        with(EntityType)
        {
            import std.format : format;
            assert(only(cdata, comment, pi, text).canFind(_type),
                   format("text cannot be called with %s", _type));
        }
        return checkedSave(_text);
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
        auto dom = parseDOM(xml);

        // "<?instructionName?>\n" ~
        auto pi1 = dom.children[0];
        assert(pi1.type == EntityType.pi);
        assert(pi1.name == "instructionName");
        assert(pi1.text.empty);

        // "<?foo here is something to say?>\n" ~
        auto pi2 = dom.children[1];
        assert(pi2.type == EntityType.pi);
        assert(pi2.name == "foo");
        assert(pi2.text == "here is something to say");

        // "<root>\n" ~
        auto root = dom.children[2];
        assert(root.type == EntityType.elementStart);

        // "    <![CDATA[ Yay! random text >> << ]]>\n" ~
        auto cdata = root.children[0];
        assert(cdata.type == EntityType.cdata);
        assert(cdata.text == " Yay! random text >> << ");

        // "    <!-- some random comment -->\n" ~
        auto comment = root.children[1];
        assert(comment.type == EntityType.comment);
        assert(comment.text == " some random comment ");

        // "    <p>something here</p>\n" ~
        auto p1 = root.children[2];
        assert(p1.type == EntityType.elementStart);
        assert(p1.name == "p");

        assert(p1.children[0].type == EntityType.text);
        assert(p1.children[0].text == "something here");

        // "    <p>\n" ~
        // "       something else\n" ~
        // "       here</p>\n" ~
        auto p2 = root.children[3];
        assert(p2.type == EntityType.elementStart);

        assert(p2.children[0].type == EntityType.text);
        assert(p2.children[0].text == "\n       something else\n       here");
    }


    /++
        Returns the child entities of the current entity.

        They are in the same order that they were in the XML document.

        $(TABLE
            $(TR $(TH Supported $(LREF EntityType)s:))
            $(TR $(TD $(REF_ALTTEXT elementStart, elementStart.elementStart, dxml, parser)))
        )
      +/
    @property DOMEntity[] children()
    {
        import std.format : format;
        assert(_type == EntityType.elementStart,
               format!"children cannot be called with %s"(_type));
        return _children;
    }

    ///
    static if(compileInTests) unittest
    {
        auto xml = "<potato>\n" ~
                   "    <!--comment-->\n" ~
                   "    <foo>bar</foo>\n" ~
                   "    <tag>\n" ~
                   "        <silly>you</silly>\n" ~
                   "        <empty/>\n" ~
                   "        <nocontent></nocontent>\n" ~
                   "    </tag>\n" ~
                   "</potato>\n" ~
                   "<!--the end-->";
        auto dom = parseDOM(xml);
        assert(dom.children.length == 2);

        auto potato = dom.children[0];
        assert(potato.type == EntityType.elementStart);
        assert(potato.name == "potato");
        assert(potato.children.length == 3);

        auto comment = potato.children[0];
        assert(comment.type == EntityType.comment);
        assert(comment.text == "comment");

        auto foo = potato.children[1];
        assert(foo.type == EntityType.elementStart);
        assert(foo.name == "foo");
        assert(foo.children.length == 1);

        assert(foo.children[0].type == EntityType.text);
        assert(foo.children[0].text == "bar");

        auto tag = potato.children[2];
        assert(tag.type == EntityType.elementStart);
        assert(tag.name == "tag");
        assert(tag.children.length == 3);

        auto silly = tag.children[0];
        assert(silly.type == EntityType.elementStart);
        assert(silly.name == "silly");
        assert(silly.children.length == 1);

        assert(silly.children[0].type == EntityType.text);
        assert(silly.children[0].text == "you");

        auto empty = tag.children[1];
        assert(empty.type == EntityType.elementEmpty);
        assert(empty.name == "empty");

        auto nocontent = tag.children[2];
        assert(nocontent.type == EntityType.elementStart);
        assert(nocontent.name == "nocontent");
        assert(nocontent.children.length == 0);

        auto endComment = dom.children[1];
        assert(endComment.type == EntityType.comment);
        assert(endComment.text == "the end");
    }


    // Reduce the chance of bugs if reference-type ranges are involved.
    static if(!isDynamicArray!R) this(this)
    {
        with(EntityType) final switch(_type)
        {
            case cdata: goto case text;
            case comment: goto case text;
            case elementStart:
            {
                _name = _name.save;
                break;
            }
            case elementEnd: goto case elementStart;
            case elementEmpty: goto case elementStart;
            case text:
            {
                _text = _text.save;
                break;
            }
            case pi:
            {
                _text = _text.save;
                goto case elementStart;
            }
        }
    }


private:

    this(EntityType type, TextPos pos)
    {
        _type = type;
        _pos = pos;

        // None of these initializations should be required. https://issues.dlang.org/show_bug.cgi?id=13945
        _name = typeof(_name).init;
        _text = typeof(_text).init;
    }

    auto _type = EntityType.elementStart;
    TextPos _pos;
    SliceOfR _name;
    SliceOfR[] _path;
    Attribute[] _attributes;
    SliceOfR _text;
    DOMEntity[] _children;
}

/// Ditto
DOMEntity!R parseDOM(Config config = Config.init, R)(R range)
    if(isForwardRange!R && isSomeChar!(ElementType!R))
{
    import qt.widgets.internal.dxml.parser : parseXML;
    auto entityRange = parseXML!config(range);
    typeof(return) retval;
    _parseDOM(entityRange, retval);
    return retval;
}

/// Ditto
DOMEntity!(ER.Input) parseDOM(ER)(ref ER range)
    if(isInstanceOf!(EntityRange, ER))
{
    typeof(return) retval;
    if(range.empty)
        return retval;
    retval._pos = range.front.pos;
    if(range.front.type == EntityType.elementEnd)
        return retval;
    _parseDOM(range, retval);
    return retval;
}

/++
    parseDOM with the default $(REF_ALTTEXT Config, Config, dxml, parser) and a
    range of characters.
  +/
@safe unittest
{
    import std.range.primitives;

    auto xml = "<root>\n" ~
               "    <!-- no comment -->\n" ~
               "    <foo></foo>\n" ~
               "    <baz>\n" ~
               "        <xyzzy>It's an adventure!</xyzzy>\n" ~
               "    </baz>\n" ~
               "    <tag/>\n" ~
               "</root>";

    auto dom = parseDOM(xml);
    assert(dom.type == EntityType.elementStart);
    assert(dom.name.empty);
    assert(dom.children.length == 1);

    auto root = dom.children[0];
    assert(root.type == EntityType.elementStart);
    assert(root.name == "root");
    assert(root.children.length == 4);

    assert(root.children[0].type == EntityType.comment);
    assert(root.children[0].text == " no comment ");

    assert(root.children[1].type == EntityType.elementStart);
    assert(root.children[1].name == "foo");
    assert(root.children[1].children.length == 0);

    auto baz = root.children[2];
    assert(baz.type == EntityType.elementStart);
    assert(baz.name == "baz");
    assert(baz.children.length == 1);

    auto xyzzy = baz.children[0];
    assert(xyzzy.type == EntityType.elementStart);
    assert(xyzzy.name == "xyzzy");
    assert(xyzzy.children.length == 1);

    assert(xyzzy.children[0].type == EntityType.text);
    assert(xyzzy.children[0].text == "It's an adventure!");

    assert(root.children[3].type == EntityType.elementEmpty);
    assert(root.children[3].name == "tag");
}

/++
    parseDOM with $(REF_ALTTEXT simpleXML, simpleXML, dxml, parser) and a range
    of characters.
  +/
unittest
{
    import std.range.primitives : empty;

    auto xml = "<root>\n" ~
               "    <!-- no comment -->\n" ~
               "    <foo></foo>\n" ~
               "    <baz>\n" ~
               "        <xyzzy>It's an adventure!</xyzzy>\n" ~
               "    </baz>\n" ~
               "    <tag/>\n" ~
               "</root>";

    auto dom = parseDOM!simpleXML(xml);
    assert(dom.type == EntityType.elementStart);
    assert(dom.name.empty);
    assert(dom.children.length == 1);

    auto root = dom.children[0];
    assert(root.type == EntityType.elementStart);
    assert(root.name == "root");
    assert(root.children.length == 3);

    assert(root.children[0].type == EntityType.elementStart);
    assert(root.children[0].name == "foo");
    assert(root.children[0].children.length == 0);

    auto baz = root.children[1];
    assert(baz.type == EntityType.elementStart);
    assert(baz.name == "baz");
    assert(baz.children.length == 1);

    auto xyzzy = baz.children[0];
    assert(xyzzy.type == EntityType.elementStart);
    assert(xyzzy.name == "xyzzy");
    assert(xyzzy.children.length == 1);

    assert(xyzzy.children[0].type == EntityType.text);
    assert(xyzzy.children[0].text == "It's an adventure!");

    assert(root.children[2].type == EntityType.elementStart);
    assert(root.children[2].name == "tag");
    assert(root.children[2].children.length == 0);
}

/++
    parseDOM with $(REF_ALTTEXT simpleXML, simpleXML, dxml, parser) and an
    $(REF_ALTTEXT EntityRange, EntityRange, dxml, parser).
  +/
unittest
{
    import std.range.primitives : empty;
    import qt.widgets.internal.dxml.parser : parseXML;

    auto xml = "<root>\n" ~
               "    <!-- no comment -->\n" ~
               "    <foo></foo>\n" ~
               "    <baz>\n" ~
               "        <xyzzy>It's an adventure!</xyzzy>\n" ~
               "    </baz>\n" ~
               "    <tag/>\n" ~
               "</root>";

    auto range = parseXML!simpleXML(xml);
    auto dom = parseDOM(range);
    assert(range.empty);

    assert(dom.type == EntityType.elementStart);
    assert(dom.name.empty);
    assert(dom.children.length == 1);

    auto root = dom.children[0];
    assert(root.type == EntityType.elementStart);
    assert(root.name == "root");
    assert(root.children.length == 3);

    assert(root.children[0].type == EntityType.elementStart);
    assert(root.children[0].name == "foo");
    assert(root.children[0].children.length == 0);

    auto baz = root.children[1];
    assert(baz.type == EntityType.elementStart);
    assert(baz.name == "baz");
    assert(baz.children.length == 1);

    auto xyzzy = baz.children[0];
    assert(xyzzy.type == EntityType.elementStart);
    assert(xyzzy.name == "xyzzy");
    assert(xyzzy.children.length == 1);

    assert(xyzzy.children[0].type == EntityType.text);
    assert(xyzzy.children[0].text == "It's an adventure!");

    assert(root.children[2].type == EntityType.elementStart);
    assert(root.children[2].name == "tag");
    assert(root.children[2].children.length == 0);
}

/++
    parseDOM with an $(REF_ALTTEXT EntityRange, EntityRange, dxml, parser)
    which is not at the start of the document.
  +/
unittest
{
    import std.range.primitives : empty;
    import qt.widgets.internal.dxml.parser : parseXML, skipToPath;

    auto xml = "<root>\n" ~
               "    <!-- no comment -->\n" ~
               "    <foo></foo>\n" ~
               "    <baz>\n" ~
               "        <xyzzy>It's an adventure!</xyzzy>\n" ~
               "    </baz>\n" ~
               "    <tag/>\n" ~
               "</root>";

    auto range = parseXML!simpleXML(xml).skipToPath("baz/xyzzy");
    assert(range.front.type == EntityType.elementStart);
    assert(range.front.name == "xyzzy");

    auto dom = parseDOM(range);
    assert(range.front.type == EntityType.elementStart);
    assert(range.front.name == "tag");

    assert(dom.type == EntityType.elementStart);
    assert(dom.name.empty);
    assert(dom.children.length == 1);

    auto xyzzy = dom.children[0];
    assert(xyzzy.type == EntityType.elementStart);
    assert(xyzzy.name == "xyzzy");
    assert(xyzzy.children.length == 1);

    assert(xyzzy.children[0].type == EntityType.text);
    assert(xyzzy.children[0].text == "It's an adventure!");
}

/// parseDOM at compile-time
unittest
{
    enum xml = "<!-- comment -->\n" ~
               "<root>\n" ~
               "    <foo>some text<whatever/></foo>\n" ~
               "    <bar/>\n" ~
               "    <baz></baz>\n" ~
               "</root>";

    enum dom = parseDOM(xml);
    static assert(dom.type == EntityType.elementStart);
    static assert(dom.name.empty);
    static assert(dom.children.length == 2);

    static assert(dom.children[0].type == EntityType.comment);
    static assert(dom.children[0].text == " comment ");
}

// This is purely to provide a way to trigger the unittest blocks in DOMEntity
// without compiling them in normally.
private struct DOMCompileTests
{
    @property bool empty() @safe pure nothrow @nogc { assert(0); }
    @property char front() @safe pure nothrow @nogc { assert(0); }
    void popFront() @safe pure nothrow @nogc { assert(0); }
    @property typeof(this) save() @safe pure nothrow @nogc { assert(0); }
}

unittest
{
    DOMEntity!DOMCompileTests _domTests;
}


private:

void _parseDOM(ER, DE)(ref ER range, ref DE parent, ER.SliceOfR[] path = null)
{
    assert(!range.empty);
    assert(range.front.type != EntityType.elementEnd);

    import std.array : appender, array;
    auto children = appender!(DE[])();

    while(!range.empty)
    {
        auto entity = range.front;
        range.popFront();
        if(entity.type == EntityType.elementEnd)
            break;

        auto child = DE(entity.type, entity.pos);
        child._path = path;

        with(EntityType) final switch(entity.type)
        {
            case cdata: goto case text;
            case comment: goto case text;
            case elementStart:
            {
                child._name = entity.name;
                child._attributes = entity.attributes.array();

                if(range.front.type == EntityType.elementEnd)
                    range.popFront();
                else
                {
                    if(!entity.name.empty)
                        path ~= entity.name;
                    // TODO The explicit instantiation doesn't hurt, but it
                    // shouldn't be necessary, and if it's not there, we get
                    // a compiler error. It should be reduced and reported.
                    _parseDOM!(ER, DE)(range, child, path);
                    --path.length;
                }
                break;
            }
            case elementEnd: assert(0);
            case elementEmpty:
            {
                child._name = entity.name;
                child._attributes = entity.attributes.array();
                break;
            }
            case text:
            {
                child._text = entity.text;
                break;
            }
            case pi:
            {
                child._name = entity.name;
                child._text = entity.text;
                break;
            }
        }

        put(children, child);
    }

    parent._children = children.data;
}

unittest
{
    import std.algorithm.comparison : equal;
    import qt.widgets.internal.dxml.internal : testRangeFuncs;
    import qt.widgets.internal.dxml.parser : parseXML, TextPos;

    static void testChildren(ER, size_t line = __LINE__)(ref ER entityRange, int row, int col, EntityType[] expected...)
    {
        import core.exception : AssertError;
        import std.exception : enforce;
        auto temp = entityRange.save;
        auto dom = parseDOM(temp);
        enforce!AssertError(dom.type == EntityType.elementStart, "unittest 1", __FILE__, line);
        enforce!AssertError(dom.children.length == expected.length, "unittest 2", __FILE__, line);
        foreach(i; 0 .. dom._children.length)
            enforce!AssertError(dom._children[i].type == expected[i], "unittest 3", __FILE__, line);
        enforce!AssertError(dom.pos == TextPos(row, col), "unittest 4", __FILE__, line);
        if(!entityRange.empty)
            entityRange.popFront();
    }

    static foreach(func; testRangeFuncs)
    {{
        {
            foreach(i, xml; ["<!-- comment -->\n" ~
                             "<?pi foo?>\n" ~
                             "<su></su>",
                            "<!-- comment -->\n" ~
                             "<?pi foo?>\n" ~
                             "<su/>"])
            {
                auto range = parseXML(func(xml));
                foreach(j; 0 .. 4 - i)
                {
                    auto temp = range.save;
                    auto dom = parseDOM(temp);
                    assert(dom.type == EntityType.elementStart);
                    assert(dom.children.length == 3 - j);
                    if(j <= 2)
                    {
                        assert(dom.children[2 - j].type ==
                               (i == 0 ? EntityType.elementStart : EntityType.elementEmpty));
                        assert(equal(dom.children[2 - j].name, "su"));
                        if(j <= 1)
                        {
                            assert(dom.children[1 - j].type == EntityType.pi);
                            assert(equal(dom.children[1 - j].name, "pi"));
                            assert(equal(dom.children[1 - j].text, "foo"));
                            if(j == 0)
                            {
                                assert(dom.children[0].type == EntityType.comment);
                                assert(equal(dom.children[0].text, " comment "));
                            }
                        }
                    }
                    range.popFront();
                }
                assert(range.empty);
                auto dom = parseDOM(range);
                assert(dom.type == EntityType.elementStart);
                assert(dom.name is typeof(dom.name).init);
                assert(dom.children.length == 0);
            }
        }
        {
            auto xml = "<root>\n" ~
                       "    <foo>\n" ~
                       "        <bar>\n" ~
                       "            <baz>\n" ~
                       "            It's silly, Charley\n" ~
                       "            </baz>\n" ~
                       "            <frobozz>\n" ~
                       "                <is>the Wiz</is>\n" ~
                       "            </frobozz>\n" ~
                       "            <empty></empty>\n" ~
                       "            <xyzzy/>\n" ~
                       "        </bar>\n" ~
                       "    </foo>\n" ~
                       "    <!--This isn't the end-->\n" ~
                       "</root>\n" ~
                       "<?Poirot?>\n" ~
                       "<!--It's the end!-->";

            {
                auto range = parseXML(func(xml));
                with(EntityType)
                {
                    testChildren(range, 1, 1, elementStart, pi, comment); // <root>
                    testChildren(range, 2, 5, elementStart, comment); // <foo>
                    testChildren(range, 3, 9, elementStart); // <bar>
                    testChildren(range, 4, 13, elementStart, elementStart, elementStart, elementEmpty); // <baz>
                    testChildren(range, 4, 18, text); // It's silly, Charley
                    testChildren(range, 6, 13); // </baz>
                    testChildren(range, 7, 13, elementStart, elementStart, elementEmpty); // <frobozz>
                    testChildren(range, 8, 17, elementStart); // <is>
                    testChildren(range, 8, 21, text); // the Wiz
                    testChildren(range, 8, 28); // </is>
                    testChildren(range, 9, 13); // </frobozz>
                    testChildren(range, 10, 13, elementStart, elementEmpty); // <empty>
                    testChildren(range, 10, 20); // </empty>
                    testChildren(range, 11, 13, elementEmpty); // <xyzzy/>
                    testChildren(range, 12, 9); // </bar>
                    testChildren(range, 13, 5); // </foo>
                    testChildren(range, 14, 5, comment); // <!--This isn't the end-->
                    testChildren(range, 15, 1); // </root>
                    testChildren(range, 16, 1, pi, comment); // <?Poirot?>
                    testChildren(range, 17, 1, comment); // <!--It's the end-->"
                    testChildren(range, 1, 1); // empty range
                }
            }
            {
                auto dom = parseDOM(func(xml));
                assert(dom.children.length == 3);

                auto root = dom.children[0];
                assert(root.type == EntityType.elementStart);
                assert(root.pos == TextPos(1, 1));
                assert(root.children.length == 2);
                assert(equal(root.name, "root"));

                auto foo = root.children[0];
                assert(foo.type == EntityType.elementStart);
                assert(foo.pos == TextPos(2, 5));
                assert(foo.children.length == 1);
                assert(equal(foo.name, "foo"));

                auto bar = foo.children[0];
                assert(bar.type == EntityType.elementStart);
                assert(bar.pos == TextPos(3, 9));
                assert(bar.children.length == 4);
                assert(equal(bar.name, "bar"));

                auto baz = bar.children[0];
                assert(baz.type == EntityType.elementStart);
                assert(baz.pos == TextPos(4, 13));
                assert(baz.children.length == 1);
                assert(equal(baz.name, "baz"));

                auto silly = baz.children[0];
                assert(silly.type == EntityType.text);
                assert(silly.pos == TextPos(4, 18));
                assert(equal(silly.text, "\n            It's silly, Charley\n            "));

                auto frobozz = bar.children[1];
                assert(frobozz.type == EntityType.elementStart);
                assert(frobozz.pos == TextPos(7, 13));
                assert(frobozz.children.length == 1);
                assert(equal(frobozz.name, "frobozz"));

                auto is_ = frobozz.children[0];
                assert(is_.type == EntityType.elementStart);
                assert(is_.pos == TextPos(8, 17));
                assert(is_.children.length == 1);
                assert(equal(is_.name, "is"));

                auto wiz = is_.children[0];
                assert(wiz.type == EntityType.text);
                assert(wiz.pos == TextPos(8, 21));
                assert(equal(wiz.text, "the Wiz"));

                auto empty = bar.children[2];
                assert(empty.type == EntityType.elementStart);
                assert(empty.pos == TextPos(10, 13));
                assert(empty.children.length == 0);
                assert(equal(empty.name, "empty"));

                auto xyzzy = bar.children[3];
                assert(xyzzy.type == EntityType.elementEmpty);
                assert(xyzzy.pos == TextPos(11, 13));
                assert(equal(xyzzy.name, "xyzzy"));

                auto comment = root.children[1];
                assert(comment.type == EntityType.comment);
                assert(comment.pos == TextPos(14, 5));
                assert(equal(comment.text, "This isn't the end"));

                auto poirot = dom.children[1];
                assert(poirot.type == EntityType.pi);
                assert(poirot.pos == TextPos(16, 1));
                assert(equal(poirot.name, "Poirot"));
                assert(poirot.text.empty);

                auto endComment = dom.children[2];
                assert(endComment.type == EntityType.comment);
                assert(endComment.pos == TextPos(17, 1));
                assert(equal(endComment.text, "It's the end!"));
            }
        }
    }}
}
