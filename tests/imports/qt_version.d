module imports.qt_version;

import std.string : split, strip;

// The Qt version the tests are built/run against, written by `runtests.d` (or
// the CI workflow) into `.qt_version.txt` and read at compile time via `-J`
// (`stringImportPaths` in dub.json). It reflects the Qt library actually loaded
// (the container image), not DQt's compile-time header version (`QT_VERSION`),
// so the `Qt6_x` flags below can gate behaviour that differs between releases.
enum qtVersion = import(".qt_version.txt").strip;

// Parses a non-empty run of decimal digits; returns -1 otherwise.
private int parseComponent(string s)
{
    if (s.length == 0)
        return -1;

    int value = 0;
    foreach (c; s)
    {
        if (c < '0' || c > '9')
            return -1;
        value = value * 10 + (c - '0');
    }
    return value;
}

// -1 if `qtVersion` could not be parsed as "major.minor", otherwise 1 if the Qt
// version is at least major.minor and 0 if it is older.
private int versionAtLeast(int major, int minor)
{
    auto parts = qtVersion.split(".");
    if (parts.length < 2)
        return -1;

    const int mj = parseComponent(parts[0]);
    const int mn = parseComponent(parts[1]);
    if (mj < 0 || mn < 0)
        return -1;

    return (mj > major || (mj == major && mn >= minor)) ? 1 : 0;
}

enum Qt6_4  = versionAtLeast(6, 4) == 1;
enum Qt6_5  = versionAtLeast(6, 5) == 1;
enum Qt6_6  = versionAtLeast(6, 6) == 1;
enum Qt6_7  = versionAtLeast(6, 7) == 1;
enum Qt6_8  = versionAtLeast(6, 8) == 1;
enum Qt6_9  = versionAtLeast(6, 9) == 1;
enum Qt6_10 = versionAtLeast(6, 10) == 1;
enum Qt6_11 = versionAtLeast(6, 11) == 1;
enum Qt6_12 = versionAtLeast(6, 12) == 1;

// The workflow writes "unknown" into `.qt_version.txt` when it cannot determine
// the Qt version (or the file is otherwise unparsable). The Qt6_x flags above are
// then all false, so version-dependent checks gate (skip) instead of asserting a
// branch chosen for the wrong release.
enum Qt6_Unknown = versionAtLeast(6, 0) == -1;
