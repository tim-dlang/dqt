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
module qt.core.iodevicebase;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.helpers;

/// Binding for C++ class [QIODeviceBase](https://doc.qt.io/qt-6/qiodevicebase.html).
extern(C++, class) struct QIODeviceBase
{
public:
    enum OpenModeFlag {
        NotOpen = 0x0000,
        ReadOnly = 0x0001,
        WriteOnly = 0x0002,
        ReadWrite = OpenModeFlag.ReadOnly | OpenModeFlag.WriteOnly,
        Append = 0x0004,
        Truncate = 0x0008,
        Text = 0x0010,
        Unbuffered = 0x0020,
        NewOnly = 0x0040,
        ExistingOnly = 0x0080
    }
    /+ Q_DECLARE_FLAGS(OpenMode, OpenModeFlag) +/
alias OpenMode = QFlags!(OpenModeFlag);}

