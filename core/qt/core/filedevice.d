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
module qt.core.filedevice;
extern(C++):

import qt.config;
import qt.core.datetime;
import qt.core.flags;
import qt.core.global;
import qt.core.iodevice;
import qt.core.object;
import qt.core.string;
import qt.helpers;

/+ class QDateTime; +/
extern(C++, class) struct QFileDevicePrivate;

/// Binding for C++ class [QFileDevice](https://doc.qt.io/qt-5/qfiledevice.html).
class /+ Q_CORE_EXPORT +/ QFileDevice : QIODevice
{
/+ #ifndef QT_NO_QOBJECT +/
    mixin(Q_OBJECT);
/+ #endif
    Q_DECLARE_PRIVATE(QFileDevice) +/

public:
    enum FileError {
        NoError = 0,
        ReadError = 1,
        WriteError = 2,
        FatalError = 3,
        ResourceError = 4,
        OpenError = 5,
        AbortError = 6,
        TimeOutError = 7,
        UnspecifiedError = 8,
        RemoveError = 9,
        RenameError = 10,
        PositionError = 11,
        ResizeError = 12,
        PermissionsError = 13,
        CopyError = 14
    }

    enum FileTime {
        FileAccessTime,
        FileBirthTime,
        FileMetadataChangeTime,
        FileModificationTime
    }

    enum Permission {
        ReadOwner = 0x4000, WriteOwner = 0x2000, ExeOwner = 0x1000,
        ReadUser  = 0x0400, WriteUser  = 0x0200, ExeUser  = 0x0100,
        ReadGroup = 0x0040, WriteGroup = 0x0020, ExeGroup = 0x0010,
        ReadOther = 0x0004, WriteOther = 0x0002, ExeOther = 0x0001
    }
    /+ Q_DECLARE_FLAGS(Permissions, Permission) +/
alias Permissions = QFlags!(Permission);
    enum FileHandleFlag {
        AutoCloseHandle = 0x0001,
        DontCloseHandle = 0
    }
    /+ Q_DECLARE_FLAGS(FileHandleFlags, FileHandleFlag) +/
alias FileHandleFlags = QFlags!(FileHandleFlag);
    ~this();

    final FileError error() const;
    final void unsetError();

    override void close();

    override bool isSequential() const;

    final int handle() const;
    /+ virtual +/ QString fileName() const;

    override qint64 pos() const;
    override bool seek(qint64 offset);
    override bool atEnd() const;
    final bool flush();

    override qint64 size() const;

    /+ virtual +/ bool resize(qint64 sz);
    /+ virtual +/ Permissions permissions() const;
    /+ virtual +/ bool setPermissions(Permissions permissionSpec);

    // ### Qt 6: rename to MemoryMapFlag & make it a QFlags
    enum MemoryMapFlags {
        NoOptions = 0,
        MapPrivateOption = 0x0001
    }

    final uchar* map(qint64 offset, qint64 size, MemoryMapFlags flags = MemoryMapFlags.NoOptions);
    final bool unmap(uchar* address);

    final QDateTime fileTime(QFileDevice.FileTime time) const;
    final bool setFileTime(ref const(QDateTime) newDate, QFileDevice.FileTime fileTime);

protected:
    this();
/+ #ifdef QT_NO_QOBJECT
    QFileDevice(QFileDevicePrivate &dd);
#else +/
    /+ explicit +/this(QObject parent);
    this(ref QFileDevicePrivate dd, QObject parent = null);
/+ #endif +/

    override qint64 readData(char* data, qint64 maxlen);
    override qint64 writeData(const(char)* data, qint64 len);
    override qint64 readLineData(char* data, qint64 maxlen);

private:
    /+ Q_DISABLE_COPY(QFileDevice) +/
}
/+pragma(inline, true) QFlags!(QFileDevice.Permissions.enum_type) operator |(QFileDevice.Permissions.enum_type f1, QFileDevice.Permissions.enum_type f2)/+noexcept+/{return QFlags!(QFileDevice.Permissions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QFileDevice.Permissions.enum_type) operator |(QFileDevice.Permissions.enum_type f1, QFlags!(QFileDevice.Permissions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QFileDevice.Permissions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QFileDevice::Permissions) +/
