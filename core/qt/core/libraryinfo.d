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
import qt.core.datetime;
import qt.core.string;
import qt.core.stringlist;
import qt.core.versionnumber;
import qt.helpers;


/// Binding for C++ class [QLibraryInfo](https://doc.qt.io/qt-5/qlibraryinfo.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QLibraryInfo
{
public:
/+ #if QT_DEPRECATED_SINCE(5, 8) +/
    /+ QT_DEPRECATED +/ static QString licensee();
    /+ QT_DEPRECATED +/ static QString licensedProducts();
/+ #endif

#if QT_CONFIG(datestring)
#if QT_DEPRECATED_SINCE(5, 5) +/
    /+ QT_DEPRECATED +/ static QDate buildDate();
/+ #endif // QT_DEPRECATED_SINCE(5, 5)
#endif +/ // datestring

    static const(char)*  build()/+ noexcept+/;

    static bool isDebugBuild();

/+ #ifndef QT_BOOTSTRAPPED +/
    mixin(changeCppMangling(q{mangleChangeName("version")}, q{
    static QVersionNumber version_()/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    }));
/+ #endif +/

    mixin(q{enum LibraryLocation
            
        }
        ~ "{"
        ~ q{

            PrefixPath = 0,
            DocumentationPath,
            HeadersPath,
            LibrariesPath,
            LibraryExecutablesPath,
            BinariesPath,
            PluginsPath,
            ImportsPath,
            Qml2ImportsPath,
            ArchDataPath,
            DataPath,
            TranslationsPath,
            ExamplesPath,
            TestsPath,
        }
        ~ (versionIsSet!("QT_BUILD_QMAKE") ? q{
            // Insert new values above this line
            // Please read the comments in qlibraryinfo.cpp before adding
    /+ #ifdef QT_BUILD_QMAKE +/
            // These are not subject to binary compatibility constraints
            SysrootPath,
            SysrootifyPrefixPath,
            HostBinariesPath,
            HostLibrariesPath,
            HostDataPath,
            TargetSpecPath,
            HostSpecPath,
            HostPrefixPath,
            LastHostPath = LibraryLocation.HostPrefixPath,
        }:"")
        ~ q{
    /+ #endif +/
            SettingsPath = 100
            
        }
        ~ "}"
    );
    static QString location(LibraryLocation); // ### Qt 6: consider renaming it to path()
    version (QT_BUILD_QMAKE)
    {
        enum PathGroup { FinalPaths, EffectivePaths, EffectiveSourcePaths, DevicePaths }
        static QString rawLocation(LibraryLocation, PathGroup);
        static void reload();
        static void sysrootify(QString* path);
    }

    static QStringList platformPluginArguments(ref const(QString) platformName);

private:
    @disable this();

    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

