// QT_MODULES: widgets
// BUILD_ONLY
import imports.linkall;
import imports.qtmodules;

unittest
{
    size_t sum;
    static foreach (modulename; modulesWidgets)
    {{
        mixin("static import m = " ~ modulename ~ ";");
        sum += linkAll!m();
    }}
}
