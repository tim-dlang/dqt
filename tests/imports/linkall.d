import std.algorithm, std.traits;
import std.array;

// Workaround for https://issues.dlang.org/show_bug.cgi?id=18026
private bool simpleStartsWith(string a, string b)
{
    if(b.length > a.length)
        return false;
    return a[0..b.length] == b;
}

// Accesses all functions in module m, so a wrong mangling will become a linker error.
size_t linkAll(alias m)()
{
    size_t sum;

    static foreach(s; __traits(allMembers, m))
    {{
        static if(is(__traits(getMember, m, s) == struct) || is(__traits(getMember, m, s) == union) || is(__traits(getMember, m, s) == class))
        {
            alias S = __traits(getMember, m, s);
            static if(__traits(getVisibility, __traits(getMember, m, s)) == "public")
            {{
                //pragma(msg, "=== ", s);
                static if(__traits(compiles, mixin("new m." ~ s)))
                    auto inst = mixin("new m." ~ s);
                else static if(is(__traits(getMember, m, s) == class))
                    mixin("m." ~ s ~ " inst;");
                else
                    mixin("m." ~ s ~ "* inst;");
                sum += cast(size_t)cast(void*)inst;
                static foreach(field; __traits(allMembers, S))
                {
                    static if(field != "qt_static_metacall" && field != "__postblit" && field != "qt_check_for_QGADGET_macro"
                            && !field.simpleStartsWith("dummyFunctionForChangingMangling"))
                    {
                        //pragma(msg, "   ", field);
                        static if(__traits(getOverloads, S, field).length == 0)
                        {
                            static if(__traits(compiles, &__traits(getMember, inst, field)))
                            {{
                                auto x = &__traits(getMember, inst, field);
                                sum += cast(size_t)cast(void*)x;
                            }}
                        }
                        static foreach(o; __traits(getOverloads, S, field))
                        {
                            //pragma(msg, "    ", typeof(o));
                            static if(__traits(isDisabled, o) || __traits(isAbstractFunction, o))
                            {
                            }
                            else static if(is(typeof(o) == function))
                            {
                                sum += cast(size_t)cast(void*)&o;
                            }
                            else
                            {{
                                auto x = &__traits(getMember, inst, field);
                                static if(is(typeof(x) == delegate))
                                    sum += cast(size_t)x.funcptr;
                                else
                                    sum += cast(size_t)cast(void*)x;
                            }}
                        }
                    }
                }
            }}
        }
        // Don't link functions with extern(D) linkage, because alias to lambda does not work with separate compilation.
        static if(is(typeof(__traits(getMember, m, s)) == function) && __traits(getLinkage, __traits(getMember, m, s)) != "D"
            && !s.simpleStartsWith("dummyFunctionForChangingMangling"))
        {
            sum += cast(size_t)&__traits(getMember, m, s);
        }
    }}

    return sum;
}
