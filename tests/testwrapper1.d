// QT_MODULES: core
import qt.helpers;
import std.conv;

struct S
{
    string data;

    this(string data)
    {
        this.data = data;
    }
}

class C
{
    S s;

    void setS(ref const S s)
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
}
