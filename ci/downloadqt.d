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

    string qtArch2;
    if (qtArch.startsWith("android_") && qtVersion.startsWith("6."))
        qtArch2 = qtArch[7 .. $];

    if (qtArchUrl == "")
        qtArchUrl = qtArch;

    string urlPrefix = text("https://download.qt.io/online/qtsdkrepository/",
            qtPlatform, "/qt", qtVersion[0], "_", qtVersion.replace(".", ""), qtArch2, "/");
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

    foreach (ref c; root.children)
    {
        if (c.name != "PackageUpdate")
            continue;
        string name;
        string version_;
        string[] archiveNames;
        foreach (ref c2; c.children)
        {
            string textContent;
            if (c2.children.length)
                textContent = c2.children[0].text;

            if (c2.name == "Name")
                name = textContent;
            else if (c2.name == "Version")
                version_ = textContent;
            else if (c2.name == "DownloadableArchives")
                archiveNames = textContent.split(",").map!(s => s.strip).array;
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
        runCommand([
            "7z", "x", archive.version_ ~ archive.archiveName,
            qtVersion ~ "/" ~ qtArch ~ "/lib",
            qtVersion ~ "/" ~ qtArch ~ "/bin",
            qtVersion ~ "/" ~ qtArch ~ "/plugins/platforms",
            qtVersion ~ "/" ~ qtArch ~ "/libexec",
            qtVersion ~ "/" ~ qtArch ~ "/resources",
            "-oqt-lib"
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
        if (!qtArch.startsWith("android"))
            downloadArchive("addons.qtwebengine.qtwebengine");
    }

    return anyFailure;
}
