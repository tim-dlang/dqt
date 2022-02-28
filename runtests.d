import std.stdio, std.conv, std.string, std.path, std.process, std.file, std.algorithm, std.range;
static import std.system;
import std.datetime.stopwatch;

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
        foreach(m; modules)
        {
            if(m in done)
                continue;
            done[m] = true;
            auto d = m in dependencies;
            if(d)
                add(*d);
            r ~= m;
        }
    }
    add(modules);
    return r;
}

version(Windows)
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

int main(string[] args)
{
    bool anyFailure;

    string model;
    static if(size_t.sizeof == 8)
        model = "64";
    else static if(size_t.sizeof == 4)
        model = "32";
    else static assert("Unknown size of size_t");

    string compiler = "dmd";
    string qtPath;
    bool verbose;

    for(size_t i = 1; i < args.length; i++)
    {
        if(args[i].startsWith("-m"))
        {
            model = args[i][2..$];
        }
        else if(args[i].startsWith("--compiler="))
        {
            compiler = args[i]["--compiler=".length..$];
        }
        else if(args[i].startsWith("--qt-path="))
        {
            qtPath = args[i]["--qt-path=".length..$];
        }
        else if(args[i] == "-v")
        {
            verbose = true;
        }
        else
        {
            stderr.writeln("Unknown argument ", args[i]);
            return 1;
        }
    }

    version(Windows)
    {
        if(qtPath.length == 0)
        {
            if(model == "64")
                qtPath = "C:\\Qt\\6.2.3\\msvc2019_64";
            else
                qtPath = "C:\\Qt\\6.2.3\\msvc2019";
        }
    }

    version(Windows)
    {
        import core.sys.windows.winbase: SetErrorMode, SEM_NOGPFAULTERRORBOX;
        uint dwMode = SetErrorMode(SEM_NOGPFAULTERRORBOX);
        SetErrorMode(dwMode | SEM_NOGPFAULTERRORBOX);
    }

    string[][string] moduleDependencies;
    moduleDependencies["widgets"] = ["gui"];
    moduleDependencies["gui"] = ["core"];

    // Collect tests
    Test[] tests;
    foreach (DirEntry e; dirEntries("tests", "*.d", SpanMode.shallow))
    {
        tests ~= Test(e.name, [], ["-main", "-unittest", "-Itests", "-I" ~ buildPath("test_results", os ~ model, "tests"), "-Jtests"]);
        File f = File(e.name, "r");
        foreach(line; f.byLine)
        {
            if(!line.startsWith("//"))
                break;
            if(line.startsWith("// QT_MODULES:"))
            {
                tests[$-1].qtModules = line["// QT_MODULES:".length..$].splitter().filter!(m => m.length).map!(m => m.idup).array;
            }
            else if(line.startsWith("// BUILD_ONLY"))
            {
                tests[$-1].buildOnly = true;
            }
            else
            {
                stderr.writeln("Unknown comment at start of file ", e.name, ": ", line);
            }
        }
    }
    tests ~= Test(buildPath("examples", "helloworld", "main.d"), ["widgets"], ["-Iexamples"], true);
    tests ~= Test(buildPath("examples", "examplewidgets", "main.d"), ["widgets"], ["-Iexamples", "-J" ~ buildPath("examples", "examplewidgets")], true);

    foreach(ref test; tests)
        test.qtModules = dependencyClosure(test.qtModules, moduleDependencies);
    tests.sort!((a, b) => a.qtModules.length < b.qtModules.length);

    // Create module qtmodules.d, which contains lists of all D modules per Qt module.
    {
        mkdirRecurse(buildPath("test_results", os ~ model, "tests", "imports"));
        File moduleListFile = File(buildPath("test_results", os ~ model, "tests", "imports", "qtmodules.d"), "w");
        moduleListFile.writeln("module imports.qtmodules;");
        foreach(m; ["core", "gui", "widgets"])
        {
            moduleListFile.writeln("immutable string[] modules", capitalize(m), " = [");
            string[] modules;
            foreach (DirEntry e; dirEntries(buildPath(m, "qt", m), "*.d", SpanMode.depth))
            {
                string m2 = e.name[0..$-2].replace("/", ".").replace("\\", ".");
                assert(m2.startsWith(m ~ "."));
                m2 = m2[m.length+1..$];
                if(m2.startsWith("qt.widgets.internal.dxml."))
                    continue;
                modules ~= m2;
            }
            modules.sort();
            foreach(m2; modules)
                moduleListFile.writeln("    \"", m2, "\",");
            moduleListFile.writeln("];");
        }
    }

    // Create module testfiles.d, which contains lists of files in the test files.
    {
        File fileListFile = File(buildPath("test_results", os ~ model, "tests", "imports", "testfiles.d"), "w");
        fileListFile.writeln("module imports.testfiles;");
        foreach(m; ["ui"])
        {
            fileListFile.writeln("immutable string[] files", capitalize(m), " = [");
            string[] files;
            foreach (DirEntry e; dirEntries(buildPath("tests", m), "*", SpanMode.shallow))
            {
                files ~= baseName(e.name);
            }
            files.sort();
            foreach(m2; files)
                fileListFile.writeln("    \"", m2, "\",");
            fileListFile.writeln("];");
        }
    }

    // Precompile static libraries for the bindings.
    bool[string] moduleCompiled;
    foreach(m; ["core", "gui", "widgets"])
    {
        auto sw = StopWatch(AutoStart.yes);

        string[] dmdArgs = [compiler, "-lib", "-g", "-w", "-m" ~ model];
        foreach (DirEntry e; dirEntries(buildPath(m, "qt", m), "*.d", SpanMode.depth))
        {
            dmdArgs ~= e.name;
        }
        if(m == "core")
            dmdArgs ~= buildPath("core", "qt", "helpers.d");
        foreach_reverse(m2; dependencyClosure([m], moduleDependencies))
        {
            dmdArgs ~= "-I" ~ m2;
        }
        dmdArgs ~= "-od" ~ buildPath("test_results", os ~ model);
        if(compiler.endsWith("ldc2"))
            dmdArgs ~= "-of" ~ buildPath("test_results", os ~ model, "libdqt" ~ m ~ libExt);
        else
            dmdArgs ~= "-of" ~ "libdqt" ~ m ~ libExt;

        auto dmdRes = execute(dmdArgs);
        if(dmdRes.status || verbose)
        {
            stderr.writeln(escapeShellCommand(dmdArgs));
            if(dmdRes.output.length)
                stderr.writeln(dmdRes.output.strip());
        }
        if(dmdRes.status)
        {
            sw.stop();
            stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000, sw.peek.total!"msecs" % 1000);
            stderr.writeln("Failure compiling module ", m);
            anyFailure = true;
        }
        else
        {
            moduleCompiled[m] = true;
            sw.stop();
            stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000, sw.peek.total!"msecs" % 1000);
            stderr.writeln("Compiled ", m);
        }
    }

    // Compile and run the tests
    foreach(ref test; tests)
    {
        auto sw = StopWatch(AutoStart.yes);

        bool canTest = true;
        foreach_reverse(m; test.qtModules)
            if(m !in moduleCompiled)
                canTest = false;

        if(!canTest)
        {
            sw.stop();
            stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000, sw.peek.total!"msecs" % 1000);
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
        version(Windows){}else
            dmdArgs ~= "-L-lstdc++";
        foreach_reverse(m; test.qtModules)
        {
            dmdArgs ~= "-I" ~ m;
        }
        foreach_reverse(m; test.qtModules)
        {
            dmdArgs ~= buildPath("test_results", os ~ model, "libdqt" ~ m ~ libExt);
        }
        foreach_reverse(m; test.qtModules)
        {
            version(Windows)
                dmdArgs ~= "Qt6" ~ capitalize(m) ~ "d.lib";
            else version(OSX)
            {
                dmdArgs ~= "-L-framework";
                dmdArgs ~= "-LQt" ~ capitalize(m);
            }
            else
                dmdArgs ~= "-L-lQt6" ~ capitalize(m);
        }
        dmdArgs ~= "-od" ~ resultDir;
        dmdArgs ~= "-of" ~ executable;
        dmdArgs ~= test.extraArgs;
        if(qtPath.length)
        {
            version(Windows)
            {
                dmdArgs ~= "-L/LIBPATH:" ~ qtPath ~ "\\lib";
                env["PATH"] = absolutePath(qtPath) ~ "\\bin";
            }
            else version(OSX)
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
        if(dmdRes.status || verbose)
        {
            stderr.writeln(escapeShellCommand(dmdArgs));
            if(dmdRes.output.length)
                stderr.writeln(dmdRes.output.strip());
        }
        if(dmdRes.status)
        {
            sw.stop();
            stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000, sw.peek.total!"msecs" % 1000);
            stderr.writeln("Failure compiling ", test.name);
            anyFailure = true;
            continue;
        }

        version(OSX)
        {
            if(qtPath.length)
            {
                string[] rpathArgs = ["install_name_tool", "-add_rpath", absolutePath(qtPath) ~ "/lib", absolutePath(executable)];
                auto rpathRes = execute(rpathArgs);
                if(rpathRes.status || verbose)
                {
                    stderr.writeln(escapeShellCommand(rpathArgs));
                    if(rpathRes.output.length)
                        stderr.writeln(rpathRes.output.strip());
                }
                if(rpathRes.status)
                {
                    sw.stop();
                    stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000, sw.peek.total!"msecs" % 1000);
                    stderr.writeln("Failure setting rpath for ", test.name);
                    anyFailure = true;
                    continue;
                }
            }
        }

        string testOutput;
        if(!test.buildOnly)
        {
            string[] testArgs = [absolutePath(executable)];
            auto testRes = execute(testArgs, env, Config.none, size_t.max, resultDir);
            if(testRes.status || verbose)
            {
                stderr.writeln(escapeShellCommand(testArgs));
                if(testRes.output.length)
                    stderr.writeln(testRes.output.strip());
            }
            if(testRes.status)
            {
                sw.stop();
                stderr.writef("[%d.%03d] ", sw.peek.total!"msecs" / 1000, sw.peek.total!"msecs" % 1000);
                stderr.writeln("Failure executing ", test.name);
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
