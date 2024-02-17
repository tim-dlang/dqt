// QT_MODULES: core
import qt.helpers;
import std.conv;

@SimulateImplicitConstructor struct S
{
    string data;

    @SimulateImplicitConstructor this(string data)
    {
        this.data = data;
    }

    @SimulateImplicitConstructor this(int i)
    {
        this.data = text("int:", i);
    }
}

class C
{
    S s;

    void setS(ref const S s)
    {
        this.s = s;
    }

    void setS2(ref const S s)
    {
        this.s = s;
    }
    void setS2(int i)
    {
        this.s = S(text("overload int:", i));
    }

    void setS3(ref S s)
    {
        this.s = s;
    }

    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

unittest 
{
    C c = new C();
    c.setS(S("test1"));
    assert(c.s.data == "test1");

    c = new C();
    c.setS("test2");
    assert(c.s.data == "test2");

    c = new C();
    c.setS(3);
    assert(c.s.data == "int:3");

    c = new C();
    c.setS2("test4");
    assert(c.s.data == "test4");

    c = new C();
    c.setS2(5);
    assert(c.s.data == "overload int:5");

    c = new C();
    c.setS2(ubyte(6));
    assert(c.s.data == "overload int:6");

    static assert(!__traits(compiles, c.setS3(S(7))));
    static assert(!__traits(compiles, c.setS3(7)));
}
