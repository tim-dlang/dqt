/*
 * DQt - D bindings for the Qt Toolkit
 *
 * GNU Lesser General Public License Usage
 * This file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPL3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
 */
module qt.core.libraryinfo;
extern(C++):

import qt.config;
import qt.core.string;
import qt.core.stringlist;
import qt.core.versionnumber;
import qt.helpers;

/// Binding for C++ class [QLibraryInfo](https://doc.qt.io/qt-6/qlibraryinfo.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QLibraryInfo
{
public:
    static const(char)* build() nothrow;

    static bool isDebugBuild() nothrow/+ /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;

/+ #ifndef QT_BOOTSTRAPPED +/
    mixin(changeCppMangling(q{mangleChangeName("version")}, q{
    static QVersionNumber version_() nothrow/+ /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    }));
/+ #endif +/

    enum LibraryPath {
        PrefixPath = 0,
        DocumentationPath,
        HeadersPath,
        LibrariesPath,
        LibraryExecutablesPath,
        BinariesPath,
        PluginsPath,
        QmlImportsPath,
        Qml2ImportsPath = LibraryPath.QmlImportsPath,
        ArchDataPath,
        DataPath,
        TranslationsPath,
        ExamplesPath,
        TestsPath,
        // Insert new values above this line
        // Please read the comments in qconfig.cpp.in before adding
        SettingsPath = 100
    }
    static QString path(LibraryPath p);
/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    alias LibraryLocation = LibraryPath;
    /+ QT_DEPRECATED_VERSION_X_6_0("Use path()") +/
        static QString location(LibraryLocation location)
    { return path(location); }
/+ #endif +/
    static QStringList platformPluginArguments(ref const(QString) platformName);

private:
    @disable this();

    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

