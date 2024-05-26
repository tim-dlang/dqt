// QT_MODULES: quick
// EXTRA_ARGS: -version=DQT_NO_CONVENIENCE_WRAPPERS
// BUILD_ONLY
import imports.linkall;
import imports.qtmodules;

unittest
{
    size_t sum;
    static foreach (modulename; modulesQuick)
    {{
        mixin("static import m = " ~ modulename ~ ";");
        sum += linkAll!m();
    }}
}
