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
/+ #define QSYSINFO_H +/


/*
   System information
*/

/// Binding for C++ class [QSysInfo](https://doc.qt.io/qt-6/qsysinfo.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QSysInfo
{
public:
    enum Sizes {
        WordSize = ((void*).sizeof<<3)
    }

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
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #endif +/ // QSYSINFO_H

