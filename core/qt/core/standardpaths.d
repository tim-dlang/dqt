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
module qt.core.standardpaths;
extern(C++):

import qt.config;
import qt.helpers;
static if(!defined!"QT_NO_STANDARDPATHS")
{
    import qt.core.flags;
    import qt.core.objectdefs;
    import qt.core.string;
    import qt.core.stringlist;
}

static if(!defined!"QT_NO_STANDARDPATHS")
{

abstract class /+ Q_CORE_EXPORT +/ QStandardPaths
{
    mixin(Q_GADGET);

public:
    // Do not re-order, must match QDesktopServices
    enum StandardLocation {
        DesktopLocation,
        DocumentsLocation,
        FontsLocation,
        ApplicationsLocation,
        MusicLocation,
        MoviesLocation,
        PicturesLocation,
        TempLocation,
        HomeLocation,
        DataLocation,
        CacheLocation,
        GenericDataLocation,
        RuntimeLocation,
        ConfigLocation,
        DownloadLocation,
        GenericCacheLocation,
        GenericConfigLocation,
        AppDataLocation,
        AppConfigLocation,
        AppLocalDataLocation = StandardLocation.DataLocation
    }
    /+ Q_ENUM(StandardLocation) +/

    static QString writableLocation(StandardLocation type);
    static QStringList standardLocations(StandardLocation type);

    enum LocateOption {
        LocateFile = 0x0,
        LocateDirectory = 0x1
    }
    /+ Q_DECLARE_FLAGS(LocateOptions, LocateOption) +/
alias LocateOptions = QFlags!(LocateOption);    /+ Q_FLAG(LocateOptions) +/

    static QString locate(StandardLocation type, ref const(QString) fileName, LocateOptions options = LocateOption.LocateFile);
    static QStringList locateAll(StandardLocation type, ref const(QString) fileName, LocateOptions options = LocateOption.LocateFile);
/+ #ifndef QT_BOOTSTRAPPED +/
    static QString displayName(StandardLocation type);
/+ #endif +/

    static QString findExecutable(ref const(QString) executableName, ref const(QStringList) paths = globalInitVar!QStringList);

/+ #if QT_DEPRECATED_SINCE(5, 2) +/
    /+ QT_DEPRECATED +/ static void enableTestMode(bool testMode);
/+ #endif +/
    static void setTestModeEnabled(bool testMode);
    static bool isTestModeEnabled();

private:
    // prevent construction
    @disable this();
    //@disable ~this();
}
/+pragma(inline, true) QFlags!(QStandardPaths.LocateOptions.enum_type) operator |(QStandardPaths.LocateOptions.enum_type f1, QStandardPaths.LocateOptions.enum_type f2)/+noexcept+/{return QFlags!(QStandardPaths.LocateOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QStandardPaths.LocateOptions.enum_type) operator |(QStandardPaths.LocateOptions.enum_type f1, QFlags!(QStandardPaths.LocateOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QStandardPaths.LocateOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QStandardPaths::LocateOptions) +/
}

