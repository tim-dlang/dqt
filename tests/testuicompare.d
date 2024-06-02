// QT_MODULES: widgets
import imports.testfiles;
import qt.widgets.ui;
import std.algorithm;
import std.array;
import std.file;
import std.path;
import std.process;
import std.stdio;

unittest
{
    string dqtRoot = environment.get("DQT_ROOT");

    /*
    This folder is currently created in runtests.d, because it can
    currently not be created on Android armv7a, because of
    https://github.com/ldc-developers/ldc/issues/4677.
    */
    //mkdirRecurse(buildPath("ui"));

    bool anyFailure;
    size_t countFiles;
    foreach (filename; filesUi)
    {
        if (!filename.endsWith(".ui"))
            continue;
        auto xml = readText(buildPath(dqtRoot, "tests", "ui", filename));
        string code = generateUICode(xml);
        string resultPath = buildPath("ui", filename[0..$-3] ~ ".code_result");
        std.file.write(resultPath, code);
        string expectedPath = buildPath(dqtRoot, "tests", "ui", filename[0..$-3] ~ ".code_expected");
        auto expected = readText(expectedPath);
        if (code.replace("\r", "") != expected.replace("\r", ""))
        {
            stderr.writeln("Wrong code for ", filename);
            stderr.writeln(code);
            anyFailure = true;
        }
        countFiles++;
    }
    assert(!anyFailure);
    assert(countFiles > 0);
}
