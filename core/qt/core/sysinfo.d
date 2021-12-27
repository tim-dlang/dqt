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
module qt.core.sysinfo;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.string;
import qt.helpers;

/+ #ifndef QSYSINFO_H +/
/+ #define QSYSINFO_H


/*
   System information
*/

/*
 * GCC (5-7) has a regression that causes it to emit wrong deprecated warnings:
 * https://gcc.gnu.org/bugzilla/show_bug.cgi?id=77849
 *
 * Try to work around it by defining our own macro.
 */

#ifdef QT_SYSINFO_DEPRECATED_X
#error "QT_SYSINFO_DEPRECATED_X already defined"
#endif

#ifdef Q_CC_GNU
#define QT_SYSINFO_DEPRECATED_X(x)
#else
#define QT_SYSINFO_DEPRECATED_X(x) QT_DEPRECATED_X(x)
#endif +/

/+ #define Q_MV_OSX(major, minor) (major == 10 ? minor + 2 : (major == 9 ? 1 : 0)) +/
extern(D) alias Q_MV_OSX = function string(string major, string minor)
{
    return mixin(interpolateMixin(q{($(major) == 10 ? $(minor) + 2 : ($(major) == 9 ? 1 : 0))}));
};
/+ #define Q_MV_IOS(major, minor) (QSysInfo::MV_IOS | major << 4 | minor) +/
extern(D) alias Q_MV_IOS = function string(string major, string minor)
{
    return mixin(interpolateMixin(q{(QSysInfo.MacVersion.MV_IOS | $(major) << 4 | $(minor))}));
};
/+ #define Q_MV_TVOS(major, minor) (QSysInfo::MV_TVOS | major << 4 | minor) +/
extern(D) alias Q_MV_TVOS = function string(string major, string minor)
{
    return mixin(interpolateMixin(q{(QSysInfo.MacVersion.MV_TVOS | $(major) << 4 | $(minor))}));
};
/+ #define Q_MV_WATCHOS(major, minor) (QSysInfo::MV_WATCHOS | major << 4 | minor) +/
extern(D) alias Q_MV_WATCHOS = function string(string major, string minor)
{
    return mixin(interpolateMixin(q{(QSysInfo.MacVersion.MV_WATCHOS | $(major) << 4 | $(minor))}));
};
/// Binding for C++ class [QSysInfo](https://doc.qt.io/qt-5/qsysinfo.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QSysInfo {
public:
    enum Sizes {
        WordSize = ((void*).sizeof<<3)
    }

/+ #if defined(QT_BUILD_QMAKE) +/
    version(QT_BUILD_QMAKE)
    {
        enum Endian {
            BigEndian,
            LittleEndian
        }
        /* needed to bootstrap qmake */
        extern static __gshared const(int) ByteOrder;
    }
    else
    {
    /+ #elif defined(Q_BYTE_ORDER) +/
        enum Endian {
            BigEndian,
            LittleEndian
        }
        version(BigEndian)
            enum ByteOrder = Endian.BigEndian;
        else version(LittleEndian)
            enum ByteOrder = Endian.LittleEndian;
        else
            static assert(0, "Undefined byte order");
    }
/+ #endif
#if QT_DEPRECATED_SINCE(5, 9) +/
    enum /+ QT_DEPRECATED_X("Use QOperatingSystemVersion") +/ WinVersion {
        WV_None     = 0x0000,

        WV_32s      = 0x0001,
        WV_95       = 0x0002,
        WV_98       = 0x0003,
        WV_Me       = 0x0004,
        WV_DOS_based= 0x000f,

        /* codenames */
        WV_NT       = 0x0010,
        WV_2000     = 0x0020,
        WV_XP       = 0x0030,
        WV_2003     = 0x0040,
        WV_VISTA    = 0x0080,
        WV_WINDOWS7 = 0x0090,
        WV_WINDOWS8 = 0x00a0,
        WV_WINDOWS8_1 = 0x00b0,
        WV_WINDOWS10 = 0x00c0,
        WV_NT_based = 0x00f0,

        /* version numbers */
        WV_4_0      = WinVersion.WV_NT,
        WV_5_0      = WinVersion.WV_2000,
        WV_5_1      = WinVersion.WV_XP,
        WV_5_2      = WinVersion.WV_2003,
        WV_6_0      = WinVersion.WV_VISTA,
        WV_6_1      = WinVersion.WV_WINDOWS7,
        WV_6_2      = WinVersion.WV_WINDOWS8,
        WV_6_3      = WinVersion.WV_WINDOWS8_1,
        WV_10_0     = WinVersion.WV_WINDOWS10,

        WV_CE       = 0x0100,
        WV_CENET    = 0x0200,
        WV_CE_5     = 0x0300,
        WV_CE_6     = 0x0400,
        WV_CE_based = 0x0f00
    }

/+ #define Q_MV_OSX(major, minor) (major == 10 ? minor + 2 : (major == 9 ? 1 : 0))
#define Q_MV_IOS(major, minor) (QSysInfo::MV_IOS | major << 4 | minor)
#define Q_MV_TVOS(major, minor) (QSysInfo::MV_TVOS | major << 4 | minor)
#define Q_MV_WATCHOS(major, minor) (QSysInfo::MV_WATCHOS | major << 4 | minor) +/
    enum /+ QT_DEPRECATED_X("Use QOperatingSystemVersion") +/ MacVersion {
        MV_None    = 0xffff,
        MV_Unknown = 0x0000,

        /* version */
        MV_9 = mixin(Q_MV_OSX(q{9}, q{0})),
        MV_10_0 = mixin(Q_MV_OSX(q{10}, q{0})),
        MV_10_1 = mixin(Q_MV_OSX(q{10}, q{1})),
        MV_10_2 = mixin(Q_MV_OSX(q{10}, q{2})),
        MV_10_3 = mixin(Q_MV_OSX(q{10}, q{3})),
        MV_10_4 = mixin(Q_MV_OSX(q{10}, q{4})),
        MV_10_5 = mixin(Q_MV_OSX(q{10}, q{5})),
        MV_10_6 = mixin(Q_MV_OSX(q{10}, q{6})),
        MV_10_7 = mixin(Q_MV_OSX(q{10}, q{7})),
        MV_10_8 = mixin(Q_MV_OSX(q{10}, q{8})),
        MV_10_9 = mixin(Q_MV_OSX(q{10}, q{9})),
        MV_10_10 = mixin(Q_MV_OSX(q{10}, q{10})),
        MV_10_11 = mixin(Q_MV_OSX(q{10}, q{11})),
        MV_10_12 = mixin(Q_MV_OSX(q{10}, q{12})),

        /* codenames */
        MV_CHEETAH = MacVersion.MV_10_0,
        MV_PUMA = MacVersion.MV_10_1,
        MV_JAGUAR = MacVersion.MV_10_2,
        MV_PANTHER = MacVersion.MV_10_3,
        MV_TIGER = MacVersion.MV_10_4,
        MV_LEOPARD = MacVersion.MV_10_5,
        MV_SNOWLEOPARD = MacVersion.MV_10_6,
        MV_LION = MacVersion.MV_10_7,
        MV_MOUNTAINLION = MacVersion.MV_10_8,
        MV_MAVERICKS = MacVersion.MV_10_9,
        MV_YOSEMITE = MacVersion.MV_10_10,
        MV_ELCAPITAN = MacVersion.MV_10_11,
        MV_SIERRA = MacVersion.MV_10_12,

        /* iOS */
        MV_IOS     = 1 << 8,
        MV_IOS_4_3 = mixin(Q_MV_IOS(q{4}, q{3})),
        MV_IOS_5_0 = mixin(Q_MV_IOS(q{5}, q{0})),
        MV_IOS_5_1 = mixin(Q_MV_IOS(q{5}, q{1})),
        MV_IOS_6_0 = mixin(Q_MV_IOS(q{6}, q{0})),
        MV_IOS_6_1 = mixin(Q_MV_IOS(q{6}, q{1})),
        MV_IOS_7_0 = mixin(Q_MV_IOS(q{7}, q{0})),
        MV_IOS_7_1 = mixin(Q_MV_IOS(q{7}, q{1})),
        MV_IOS_8_0 = mixin(Q_MV_IOS(q{8}, q{0})),
        MV_IOS_8_1 = mixin(Q_MV_IOS(q{8}, q{1})),
        MV_IOS_8_2 = mixin(Q_MV_IOS(q{8}, q{2})),
        MV_IOS_8_3 = mixin(Q_MV_IOS(q{8}, q{3})),
        MV_IOS_8_4 = mixin(Q_MV_IOS(q{8}, q{4})),
        MV_IOS_9_0 = mixin(Q_MV_IOS(q{9}, q{0})),
        MV_IOS_9_1 = mixin(Q_MV_IOS(q{9}, q{1})),
        MV_IOS_9_2 = mixin(Q_MV_IOS(q{9}, q{2})),
        MV_IOS_9_3 = mixin(Q_MV_IOS(q{9}, q{3})),
        MV_IOS_10_0 = mixin(Q_MV_IOS(q{10}, q{0})),

        /* tvOS */
        MV_TVOS     = 1 << 9,
        MV_TVOS_9_0 = mixin(Q_MV_TVOS(q{9}, q{0})),
        MV_TVOS_9_1 = mixin(Q_MV_TVOS(q{9}, q{1})),
        MV_TVOS_9_2 = mixin(Q_MV_TVOS(q{9}, q{2})),
        MV_TVOS_10_0 = mixin(Q_MV_TVOS(q{10}, q{0})),

        /* watchOS */
        MV_WATCHOS     = 1 << 10,
        MV_WATCHOS_2_0 = mixin(Q_MV_WATCHOS(q{2}, q{0})),
        MV_WATCHOS_2_1 = mixin(Q_MV_WATCHOS(q{2}, q{1})),
        MV_WATCHOS_2_2 = mixin(Q_MV_WATCHOS(q{2}, q{2})),
        MV_WATCHOS_3_0 = mixin(Q_MV_WATCHOS(q{3}, q{0}))
    }

/+ QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
#if defined(Q_OS_WIN) || defined(Q_OS_CYGWIN)
    QT_SYSINFO_DEPRECATED_X("Use QOperatingSystemVersion::current()") +/ 
    static if(versionIsSet!("Windows"))
    {
        extern export static __gshared const(WinVersion) WindowsVersion;
        /+ QT_SYSINFO_DEPRECATED_X("Use QOperatingSystemVersion::current()") +/ static WinVersion windowsVersion();
    }
    else
    {
    /+ #else
        QT_SYSINFO_DEPRECATED_X("Use QOperatingSystemVersion::current()") +/ extern(D) static __gshared const(WinVersion) WindowsVersion = WinVersion.WV_None;
        /+ QT_SYSINFO_DEPRECATED_X("Use QOperatingSystemVersion::current()") +/ static WinVersion windowsVersion() { return WinVersion.WV_None; }
    }
/+ #endif
#if defined(Q_OS_MAC)
    QT_SYSINFO_DEPRECATED_X("Use QOperatingSystemVersion::current()") +/ 
    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        extern static __gshared const(MacVersion) MacintoshVersion;
        /+ QT_SYSINFO_DEPRECATED_X("Use QOperatingSystemVersion::current()") +/ static MacVersion macVersion();
    }
    else
    {
    /+ #else
        QT_SYSINFO_DEPRECATED_X("Use QOperatingSystemVersion::current()") +/ extern(D) static __gshared const(MacVersion) MacintoshVersion = MacVersion.MV_None;
        /+ QT_SYSINFO_DEPRECATED_X("Use QOperatingSystemVersion::current()") +/ static MacVersion macVersion() { return MacVersion.MV_None; }
    }
/+ #endif
QT_WARNING_POP
#endif +/ // QT_DEPRECATED_SINCE(5, 9)

    static QString buildCpuArchitecture();
    static QString currentCpuArchitecture();
    static QString buildAbi();

    static QString kernelType();
    static QString kernelVersion();
    static QString productType();
    static QString productVersion();
    static QString prettyProductName();

    static QString machineHostName();
    static QByteArray machineUniqueId();
    static QByteArray bootUniqueId();
}

/+ #undef QT_SYSINFO_DEPRECATED_X +/

/+ #endif +/ // QSYSINFO_H

