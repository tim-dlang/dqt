import dxml.dom;
import std.algorithm;
import std.array;
import std.conv;
import std.exception;
import std.file;
import std.process;
import std.string;
import std.stdio;

void runCommand(string[] args)
{
    writeln("Running: ", escapeShellCommand(args));

    auto pipes = pipeProcess(args, Redirect.stdin, null, Config.none);
    pipes.stdin.close();

    auto status = pipes.pid.wait();

    if (status)
    {
        throw new Exception(text("Command ", args[0], " failed with status ", status));
    }
}

void downloadFile(string url, string filename)
{
    if (!exists(filename))
    {
        runCommand(["wget", "--no-verbose", url, "-O", filename ~ ".part"]);
        rename(filename ~ ".part", filename);
    }
}

int main(string[] args)
{
    string qtVersion;
    string qtArch;
    string qtArchUrl;
    string qtPlatform;

    for (size_t i = 1; i < args.length; i++)
    {
        if (args[i].startsWith("-v"))
        {
            qtVersion = args[i][2 .. $];
        }
        else if (args[i].startsWith("-a"))
        {
            qtArch = args[i][2 .. $];
        }
        else if (args[i].startsWith("-u"))
        {
            qtArchUrl = args[i][2 .. $];
        }
        else if (args[i].startsWith("-p"))
        {
            qtPlatform = args[i][2 .. $];
        }
        else
        {
            stderr.writeln("Unknown argument ", args[i]);
            return 1;
        }
    }

    if (qtVersion == "" || qtArch == "" || qtPlatform == "")
    {
        stderr.writeln("Missing arguments");
        return 1;
    }

    int[] versionParts = qtVersion.split(".").map!(s => s.to!int).array;
    if (versionParts.length != 3)
    {
        stderr.writeln("Invalid version ", qtVersion);
        return 1;
    }

    string qtArch2;
    if (qtArch.startsWith("android_") && qtVersion.startsWith("6."))
        qtArch2 = qtArch[7 .. $];

    if (qtArchUrl == "")
        qtArchUrl = qtArch;

    string urlPrefix = text("https://download.qt.io/online/qtsdkrepository/",
            qtPlatform, "/qt", qtVersion[0], "_", qtVersion.replace(".", ""), qtArch2, "/");
    if (versionParts[0] * 100 + versionParts[2] >= 608)
        urlPrefix ~= text("qt", qtVersion[0], "_", qtVersion.replace(".", ""), "/");
    string packageNamePrefix = text("qt.qt", qtVersion[0], ".", qtVersion.replace(".", ""), ".");
    string updatesFile = text("Qt-Updates-", qtPlatform.replace("/", "-"), "-", qtVersion, qtArch2, ".xml");

    downloadFile(urlPrefix ~ "Updates.xml", updatesFile);

    auto dom = parseDOM!simpleXML(readText(updatesFile));

    enforce(dom.children.length == 1);
    auto root = dom.children[0];
    enforce(root.name == "Updates");

    struct Archive
    {
        string packageName;
        string version_;
        string archiveName;
    }

    Archive[string] archives;
    string[string] archiveExtractPath;

    foreach (ref c; root.children)
    {
        if (c.name != "PackageUpdate")
            continue;
        string name;
        string version_;
        string[] archiveNames;
        foreach (ref c2; c.children)
        {
            string textContent()
            {
                if (c2.children.length)
                    return c2.children[0].text;
                return "";
            }

            if (c2.name == "Name")
                name = textContent;
            else if (c2.name == "Version")
                version_ = textContent;
            else if (c2.name == "DownloadableArchives")
                archiveNames = textContent.split(",").map!(s => s.strip).array;
            else if (c2.name == "Operations")
            {
                foreach (ref o; c2.children)
                {
                    if (o.name == "Operation")
                    {
                        string[string] attributes;
                        foreach (attr; o.attributes)
                        {
                            attributes[attr.name] = attr.value;
                        }
                        string[] arguments;
                        foreach (ref a; o.children)
                        {
                            if (a.name == "Argument")
                                arguments ~= a.children[0].text;
                        }
                        if (attributes["name"] == "Extract" && arguments.length == 2 && arguments[0].startsWith("@TargetDir@/"))
                        {
                            archiveExtractPath[arguments[1]] = arguments[0]["@TargetDir@/".length .. $] ~ "/";
                        }
                    }
                }
            }
        }

        string name2 = name;
        if (!name2.startsWith(packageNamePrefix))
            continue;
        name2 = name2[packageNamePrefix.length .. $];

        if (name2.endsWith("." ~ qtArchUrl))
            name2 = name2[0 .. $ - qtArchUrl.length - 1];
        else if (name2 == qtArchUrl)
            name2 = "";
        else
            continue;

        foreach (archive; archiveNames)
        {
            string shortName = archive.split("-")[0];
            if (name2.length)
                shortName = name2 ~ "." ~ shortName;
            enforce(shortName !in archives, text("Duplicate archive ", shortName));
            archives[shortName] = Archive(name, version_, archive);
        }
    }

    bool anyFailure;
    void downloadArchive(string shortName)
    {
        if (shortName !in archives)
        {
            writeln("Missing: ", shortName);
            anyFailure = true;
            return;
        }
        Archive archive = archives[shortName];
        downloadFile(urlPrefix ~ archive.packageName ~ "/" ~ archive.version_ ~ archive.archiveName,
                archive.version_ ~ archive.archiveName);
        string archivePrefix = qtVersion ~ "/" ~ qtArch ~ "/";
        string extractPrefix = archiveExtractPath.get(archive.archiveName, "");
        if (extractPrefix.length > archivePrefix.length)
            enforce(extractPrefix.startsWith(archivePrefix));
        else
            enforce(archivePrefix.startsWith(extractPrefix));
        string[] extractPaths;
        bool extractFull;
        foreach (d; [
            "lib",
            "bin",
            "plugins/platforms",
            "libexec",
            "resources"])
        {
            if (extractPrefix.length <= archivePrefix.length)
                extractPaths ~= archivePrefix[extractPrefix.length .. $] ~ d;
            else if ((d ~ "/").startsWith(extractPrefix[archivePrefix.length .. $]))
            {
                if (d[extractPrefix.length - archivePrefix.length - 1 .. $].length)
                    extractPaths ~= d[extractPrefix.length - archivePrefix.length - 1 .. $];
                else
                    extractFull = true;
            }
        }
        if (!extractFull && extractPaths.length == 0)
        {
            writeln("Missing path in ", shortName);
            anyFailure = true;
            return;
        }
        if (extractFull)
            extractPaths = [];
        runCommand([
            "7z", "x", archive.version_ ~ archive.archiveName,
            ] ~ extractPaths ~ [
            "-oqt-lib/" ~ extractPrefix
        ]);
    }

    downloadArchive("qtbase");
    if ("icu" in archives)
        downloadArchive("icu");
    downloadArchive("qtdeclarative");
    if (qtVersion.startsWith("5."))
    {
        downloadArchive("qtquickcontrols2");
        downloadArchive("qtlocation");
        downloadArchive("qtwebchannel");
        if (!qtArch.startsWith("android"))
            downloadArchive("qtwebengine.qtwebengine");
    }
    else if (qtVersion.startsWith("6."))
    {
        downloadArchive("addons.qtpositioning.qtpositioning");
        downloadArchive("addons.qtwebchannel.qtwebchannel");
        if (!qtArch.startsWith("android") && qtArch != "gcc_arm64")
            downloadArchive("addons.qtwebengine.qtwebengine");
        downloadArchive("addons.qtmultimedia.qtmultimedia");
        if (!qtArch.startsWith("android") && qtArch != "gcc_arm64")
            downloadArchive("addons.qtpdf.qtpdf");
    }

    return anyFailure;
}
