import core.thread;
import std.algorithm;
import std.conv;
import std.datetime.stopwatch;
import std.file;
import std.path;
import std.process;
import std.range;
import std.stdio;
import std.string;
static import std.system;
import std.typecons;

struct Test
{
    string name;
    string[] qtModules;
    string[] extraArgs;
    bool buildOnly;
}

string[] dependencyClosure(string[] modules, string[][string] dependencies)
{
    string[] r;
    bool[string] done;
    void add(string[] modules)
    {
        foreach (m; modules)
        {
            if (m in done)
                continue;
            done[m] = true;
            auto d = toLower(m) in dependencies;
            if (d)
                add(*d);
            r ~= m;
        }
    }

    add(modules);
    return r;
}

version (Windows)
{
    enum os = "win";
    enum libExt = ".lib";
    enum exeExt = ".exe";
}
else
{
    enum os = text(std.system.os);
    enum libExt = ".a";
    enum exeExt = "";
}

auto executeTimeout(string[] args, Duration timeout, const string[string] env = null, string workDir = null)
{
    auto pipes = pipeProcess(args, Redirect.stdin | Redirect.stdout | Redirect.stderrToStdout, env, Config.none, workDir);
    pipes.stdin.close();

    auto sw = StopWatch(AutoStart.yes);
    while (true)
    {
        auto status = pipes.pid.tryWait();
        if (status.terminated || sw.peek > timeout)
        {
            if (!status.terminated)
            {
                kill(pipes.pid);
            }
            Appender!string app;
            foreach (ubyte[] chunk; pipes.stdout.byChunk(4096))
                app.put(chunk);
            if (!status.terminated)
                status.status = -1;
            return Tuple!(bool, "terminated", int, "status", string, "output")(status.terminated, status.status, app.data);
        }
        Thread.sleep(1.seconds);
    }
}

int main(string[] args)
{
    bool anyFailure;

    string model;
    static if (size_t.sizeof == 8)
        model = "64";
    else static if (size_t.sizeof == 4)
        model = "32";
    else
        static assert("Unknown size of size_t");

    string compiler = "dmd";
    string qtPath;
    string dxmlPath;
    bool verbose;
    bool github;

    for (size_t i = 1; i < args.length; i++)
    {
        if (args[i].startsWith("-m"))
        {
            model = args[i][2 .. $];
        }
        else if (args[i].startsWith("--compiler="))
        {
            compiler = args[i]["--compiler=".length .. $];
        }
        else if (args[i].startsWith("--qt-path="))
        {
            qtPath = args[i]["--qt-path=".length .. $];
        }
        else if (args[i].startsWith("--dxml-path="))
        {
            dxmlPath = args[i]["--dxml-path=".length .. $];
        }
        else if (args[i] == "-v")
        {
            verbose = true;
        }
        else if (args[i] == "--github")
        {
            github = true;
        }
        else
        {
            stderr.writeln("Unknown argument ", args[i]);
            return 1;
        }
    }

    version (Windows)
    {
        if (qtPath.length == 0)
        {
            if (model == "64")
                qtPath = "C:\\Qt\\5.15.2\\msvc2019_64";
            else
                qtPath = "C:\\Qt\\5.15.2\\msvc2019";
        }
    }

    version (Windows)
    {
        import core.sys.windows.winbase : SetErrorMode, SEM_NOGPFAULTERRORBOX;

        uint dwMode = SetErrorMode(SEM_NOGPFAULTERRORBOX);
        SetErrorMode(dwMode | SEM_NOGPFAULTERRORBOX);
    }

    string[][string] moduleDependencies;
    moduleDependencies["widgets"] = ["gui"];
    moduleDependencies["gui"] = ["core"];
    moduleDependencies["network"] = ["core"];
    moduleDependencies["webenginecore"] = ["gui", "network"];
    moduleDependencies["webenginewidgets"] = ["webenginecore", "widgets"];

    immutable allQtModules = [
        "Core", "Gui", "Widgets", "Network", "WebEngineCore", "WebEngineWidgets"
    ];
    string getCapitalizedModuleName(string m)
    {
        foreach (m2; allQtModules)
            if (toLower(m2) == toLower(m))
                return m2;
        return m;
    }

    // Collect tests
    Test[] tests;
    foreach (DirEntry e; dirEntries("tests", "*.d", SpanMode.shallow))
    {
        tests ~= Test(e.name, [], [
            "-main", "-unittest", "-Itests",
            "-I" ~ buildPath("test_results", os ~ model, "tests"), "-Jtests"
        ]);
        File f = File(e.name, "r");
        foreach (line; f.byLine)
        {
            if (!line.startsWith("//"))
                break;
            if (line.startsWith("// QT_MODULES:"))
            {
                tests[$ - 1].qtModules = line["// QT_MODULES:".length .. $].splitter()
                    .filter!(m => m.length)
                    .map!(m => m.idup)
                    .array;
            }
            else if (line.startsWith("// BUILD_ONLY"))
            {
                tests[$ - 1].buildOnly = true;
            }
            else
            {
                stderr.writeln("Unknown comment at start of file ", e.name, ": ", line);
            }
        }
    }
    tests ~= Test(buildPath("examples", "helloworld", "main.d"), ["widgets"],
            ["-Iexamples"], true);
    tests ~= Test(buildPath("examples", "examplewidgets", "main.d"), ["widgets"],
            ["-Iexamples", "-J" ~ buildPath("examples", "examplewidgets")], true);
    tests ~= Test(buildPath("examples", "examplebrowser", "main.d"), ["webenginewidgets"],
            ["-Iexamples", "-J" ~ buildPath("examples", "examplebrowser")], true);

    foreach (ref test; tests)
        test.qtModules = dependencyClosure(test.qtModules, moduleDependencies);
    tests.sort!((a, b) => a.qtModules.length < b.qtModules.length);

    // Create module qtmodules.d, which contains lists of all D modules per Qt module.
    {
        mkdirRecurse(buildPath("test_results", os ~ model, "tests", "imports"));
        File moduleListFile = File(buildPath("test_results", os ~ model,
                "tests", "imports", "qtmodules.d"), "w");
        moduleListFile.writeln("module imports.qtmodules;");
        foreach (m; allQtModules)
        {
            moduleListFile.writeln("immutable string[] modules", m, " = [");
            string[] modules;
            string path;
            if (m.startsWith("WebEngine"))
                path = buildPath(toLower(m), "qt", "webengine");
            else
                path = buildPath(toLower(m), "qt", toLower(m));
            foreach (DirEntry e; dirEntries(path, "*.d", SpanMode.depth))
            {
                string m2 = e.name[0 .. $ - 2].replace("/", ".").replace("\\", ".");
                assert(m2.startsWith(toLower(m) ~ "."));
                m2 = m2[toLower(m).length + 1 .. $];
                if (m2.startsWith("qt.widgets.internal.dxml."))
                    continue;
                modules ~= m2;
            }
            modules.sort();
            foreach (m2; modules)
                moduleListFile.writeln("    \"", m2, "\",");
            moduleListFile.writeln("];");
        }
    }

    // Create module testfiles.d, which contains lists of files in the test files.
    {
        File fileListFile = File(buildPath("test_results", os ~ model, "tests",
                "imports", "testfiles.d"), "w");
        fileListFile.writeln("module imports.testfiles;");
        foreach (m; ["Ui"])
        {
            fileListFile.writeln("immutable string[] files", m, " = [");
            string[] files;
            foreach (DirEntry e; dirEntries(buildPath("tests", toLower(m)), "*", SpanMode.shallow))
            {
                files ~= baseName(e.name);
            }
            files.sort();
            foreach (m2; files)
                fileListFile.writeln("    \"", m2, "\",");
            fileListFile.writeln("];");
        }
    }

    // Precompile static libraries for the bindings.
    bool[string] moduleCompiled;
    foreach (m; allQtModules)
    {
        auto sw = StopWatch(AutoStart.yes);

        string[] dmdArgs = [compiler, "-lib", "-g", "-w", "-m" ~ model];
        string path;
        if (m.startsWith("WebEngine"))
            path = buildPath(toLower(m), "qt", "webengine");
        else
            path = buildPath(toLower(m), "qt", toLower(m));
        foreach (DirEntry e; dirEntries(path, "*.d", SpanMode.depth))
        {
            dmdArgs ~= e.name;
        }
        if (m == "Core")
            dmdArgs ~= buildPath("core", "qt", "helpers.d");
        if (m == "Widgets" && dxmlPath != "")
            dmdArgs ~= "-I" ~ dxmlPath;
        foreach_reverse (m2; dependencyClosure([m], moduleDependencies))
        {
            dmdArgs ~= "-I" ~ toLower(m2);
            if (m2 == "Widgets" && dxmlPath != "")
                dmdArgs ~= "-I" ~ dxmlPath;
        }
        dmdArgs ~= "-od" ~ buildPath("test_results", os ~ model);
        if (compiler.endsWith("ldc2"))
            dmdArgs ~= "-of" ~ buildPath("test_results", os ~ model, "libdqt" ~ toLower(m) ~ libExt);
        else
            dmdArgs ~= "-of" ~ "libdqt" ~ toLower(m) ~ libExt;

        auto dmdRes = execute(dmdArgs);
        if (dmdRes.status || verbose)
        {
            stderr.writeln(escapeShellCommand(dmdArgs));
        }
        if (dmdRes.output.length)
            stderr.writeln(dmdRes.output.strip());
        if (dmdRes.status)
        {
            sw.stop();
            stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000,
                    sw.peek.total!"msecs" % 1000);
            stderr.writeln("Failure compiling module ", m);
            anyFailure = true;
        }
        else
        {
            moduleCompiled[toLower(m)] = true;
            sw.stop();
            stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000,
                    sw.peek.total!"msecs" % 1000);
            stderr.writeln("Compiled ", m);
        }
    }

    // Compile and run the tests
    foreach (ref test; tests)
    {
        auto sw = StopWatch(AutoStart.yes);

        bool canTest = true;
        foreach_reverse (m; test.qtModules)
            if (m !in moduleCompiled)
                canTest = false;

        if (!canTest)
        {
            sw.stop();
            stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000,
                    sw.peek.total!"msecs" % 1000);
            stderr.writeln("Skipping ", test.name);
            continue;
        }

        string resultDir = buildPath("test_results", os ~ model, dirName(test.name));
        string executable = buildPath(resultDir, baseName(test.name, ".d") ~ exeExt);

        string[] dmdArgs = [compiler];
        string[string] env;
        env["DQT_ROOT"] = getcwd();
        env["QT_QPA_PLATFORM"] = "offscreen";
        //env["QT_DEBUG_PLUGINS"] = "1";
        dmdArgs ~= "-i=-qt";
        dmdArgs ~= "-g";
        dmdArgs ~= "-w";
        dmdArgs ~= "-m" ~ model;
        dmdArgs ~= test.name;
        version (Windows) {}
        else version (OSX)
            dmdArgs ~= "-L-lc++";
        else
            dmdArgs ~= "-L-lstdc++";
        foreach_reverse (m; test.qtModules)
        {
            dmdArgs ~= "-I" ~ m;
            if (getCapitalizedModuleName(m) == "Widgets" && dxmlPath != "")
                dmdArgs ~= "-I" ~ dxmlPath;
        }
        foreach_reverse (m; test.qtModules)
        {
            dmdArgs ~= buildPath("test_results", os ~ model, "libdqt" ~ m ~ libExt);
        }
        foreach_reverse (m; test.qtModules)
        {
            version (Windows)
                dmdArgs ~= "Qt5" ~ getCapitalizedModuleName(m) ~ ".lib";
            else version (OSX)
            {
                dmdArgs ~= "-L-framework";
                dmdArgs ~= "-LQt" ~ getCapitalizedModuleName(m);
            }
            else
                dmdArgs ~= "-L-lQt5" ~ getCapitalizedModuleName(m);
        }
        dmdArgs ~= "-od" ~ resultDir;
        dmdArgs ~= "-of" ~ executable;
        dmdArgs ~= test.extraArgs;
        if (qtPath.length)
        {
            version (Windows)
            {
                dmdArgs ~= "-L/LIBPATH:" ~ qtPath ~ "\\lib";
                env["PATH"] = absolutePath(qtPath) ~ "\\bin";
            }
            else version (OSX)
            {
                dmdArgs ~= "-L-F" ~ qtPath ~ "/lib";
            }
            else
            {
                dmdArgs ~= "-L-L" ~ qtPath ~ "/lib";
                env["LD_LIBRARY_PATH"] = absolutePath(qtPath) ~ "/lib";
            }
        }

        auto dmdRes = execute(dmdArgs);
        if (dmdRes.status || verbose)
        {
            stderr.writeln(escapeShellCommand(dmdArgs));
        }
        if (dmdRes.output.length)
            stderr.writeln(dmdRes.output.strip());
        if (dmdRes.status)
        {
            sw.stop();
            stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000,
                    sw.peek.total!"msecs" % 1000);
            stderr.writeln("Failure compiling ", test.name);
            anyFailure = true;
            continue;
        }

        version (OSX)
        {
            if (qtPath.length)
            {
                string[] rpathArgs = [
                    "install_name_tool", "-add_rpath",
                    absolutePath(qtPath) ~ "/lib", absolutePath(executable)
                ];
                auto rpathRes = execute(rpathArgs);
                if (rpathRes.status || verbose)
                {
                    stderr.writeln(escapeShellCommand(rpathArgs));
                    if (rpathRes.output.length)
                        stderr.writeln(rpathRes.output.strip());
                }
                if (rpathRes.status)
                {
                    sw.stop();
                    stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000,
                            sw.peek.total!"msecs" % 1000);
                    stderr.writeln("Failure setting rpath for ", test.name);
                    anyFailure = true;
                    continue;
                }
            }
        }

        version (OSX) {}
        else
        {
            // This test currently does not work with GitHub Actions
            if (github && test.name.replace("\\", "/") == "tests/testwebenginewidgets1.d")
            {
                sw.stop();
                stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000,
                        sw.peek.total!"msecs" % 1000);
                stderr.writeln("Skipping ", test.name);
                continue;
            }
        }

        string testOutput;
        if (!test.buildOnly)
        {
            string[] testArgs = [absolutePath(executable)];
            auto testRes = executeTimeout(testArgs, 2.minutes, env, resultDir);
            if (testRes.status || verbose)
            {
                stderr.writeln(escapeShellCommand(testArgs));
                if (testRes.output.length)
                    stderr.writeln(testRes.output.strip());
            }
            if (testRes.status)
            {
                sw.stop();
                stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000,
                        sw.peek.total!"msecs" % 1000);
                stderr.writeln("Failure executing ", test.name, testRes.terminated ? text(" (status=", testRes.status, ")") : " (timeout)");
                anyFailure = true;
                continue;
            }
            testOutput = testRes.output.strip();
        }
        sw.stop();
        stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000, sw.peek.total!"msecs" % 1000);
        stderr.writeln("Done ", test.name, testOutput.length ? ": " : "", testOutput);
    }

    return anyFailure;
}
