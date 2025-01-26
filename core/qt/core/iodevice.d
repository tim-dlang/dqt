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
module qt.core.iodevice;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.flags;
import qt.core.global;
import qt.core.iodevicebase;
import qt.core.object;
import qt.core.string;
import qt.helpers;

/+ #ifndef QT_NO_QOBJECT
#else
#endif
#ifdef open
#error qiodevice.h must be included before any header file that defines open
#endif +/



extern(C++, class) struct QIODevicePrivate;

/// Binding for C++ class [QIODevice](https://doc.qt.io/qt-6/qiodevice.html).
abstract class /+ Q_CORE_EXPORT +/ QIODevice
/+ #ifndef QT_NO_QOBJECT +/
    : QObject
/+ #else
    :
#endif +/
    //  QIODeviceBase
{
/+ #ifndef QT_NO_QOBJECT +/
    mixin(Q_OBJECT);
/+ #endif +/
    alias OpenModeFlag = QIODeviceBase.OpenModeFlag;
    alias OpenMode = QIODeviceBase.OpenMode;
public:

    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this();
    }));
/+ #ifndef QT_NO_QOBJECT +/
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QObject parent);
    }));
/+ #endif +/
    /+ virtual +/~this();

    final QIODeviceBase.OpenMode openMode() const;

    final void setTextModeEnabled(bool enabled);
    final bool isTextModeEnabled() const;

    final bool isOpen() const;
    final bool isReadable() const;
    final bool isWritable() const;
    /+ virtual +/ bool isSequential() const;

    final int readChannelCount() const;
    final int writeChannelCount() const;
    final int currentReadChannel() const;
    final void setCurrentReadChannel(int channel);
    final int currentWriteChannel() const;
    final void setCurrentWriteChannel(int channel);

    /+ virtual +/ bool open(QIODeviceBase.OpenMode mode);
    /+ virtual +/ void close();

    // ### Qt 7 - QTBUG-76492: pos() and seek() should not be virtual, and
    // ### seek() should call a virtual seekData() function.
    /+ virtual +/ qint64 pos() const;
    /+ virtual +/ qint64 size() const;
    /+ virtual +/ bool seek(qint64 pos);
    /+ virtual +/ bool atEnd() const;
    /+ virtual +/ bool reset();

    /+ virtual +/ qint64 bytesAvailable() const;
    /+ virtual +/ qint64 bytesToWrite() const;

    final qint64 read(char* data, qint64 maxlen);
    final QByteArray read(qint64 maxlen);
    final QByteArray readAll();
    final qint64 readLine(char* data, qint64 maxlen);
    final QByteArray readLine(qint64 maxlen = 0);
    /+ virtual +/ bool canReadLine() const;

    final void startTransaction();
    final void commitTransaction();
    final void rollbackTransaction();
    final bool isTransactionStarted() const;

    final qint64 write(const(char)* data, qint64 len);
    final qint64 write(const(char)* data);
    final qint64 write(ref const(QByteArray) data);

    final qint64 peek(char* data, qint64 maxlen);
    final QByteArray peek(qint64 maxlen);
    final qint64 skip(qint64 maxSize);

    /+ virtual +/ bool waitForReadyRead(int msecs);
    /+ virtual +/ bool waitForBytesWritten(int msecs);

    final void ungetChar(char c);
    final bool putChar(char c);
    final bool getChar(char* c);

    final QString errorString() const;

/+ #ifndef QT_NO_QOBJECT +/
/+ Q_SIGNALS +/public:
    @QSignal final void readyRead();
    @QSignal final void channelReadyRead(int channel);
    @QSignal final void bytesWritten(qint64 bytes);
    @QSignal final void channelBytesWritten(int channel, qint64 bytes);
    @QSignal final void aboutToClose();
    @QSignal final void readChannelFinished();
/+ #endif +/

protected:
/+ #ifdef QT_NO_QOBJECT
    QIODevice(QIODevicePrivate &dd);
#else +/
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QIODevicePrivate dd, QObject parent = null);
    }));
/+ #endif +/
    /+ virtual +/ abstract qint64 readData(char* data, qint64 maxlen);
    /+ virtual +/ qint64 readLineData(char* data, qint64 maxlen);
    /+ virtual +/ qint64 skipData(qint64 maxSize);
    /+ virtual +/ abstract qint64 writeData(const(char)* data, qint64 len);

    final void setOpenMode(QIODeviceBase.OpenMode openMode);

    final void setErrorString(ref const(QString) errorString);

/+ #ifdef QT_NO_QOBJECT
    QScopedPointer<QIODevicePrivate> d_ptr;
#endif +/

private:
    /+ Q_DECLARE_PRIVATE(QIODevice) +/
    /+ Q_DISABLE_COPY(QIODevice) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QIODevice.OpenMode.enum_type) operator |(QIODevice.OpenMode.enum_type f1, QIODevice.OpenMode.enum_type f2)/+noexcept+/{return QFlags!(QIODevice.OpenMode.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QIODevice.OpenMode.enum_type) operator |(QIODevice.OpenMode.enum_type f1, QFlags!(QIODevice.OpenMode.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QIODevice.OpenMode.enum_type) operator &(QIODevice.OpenMode.enum_type f1, QIODevice.OpenMode.enum_type f2)/+noexcept+/{return QFlags!(QIODevice.OpenMode.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QIODevice.OpenMode.enum_type) operator &(QIODevice.OpenMode.enum_type f1, QFlags!(QIODevice.OpenMode.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QIODevice.OpenMode.enum_type) operator ^(QIODevice.OpenMode.enum_type f1, QIODevice.OpenMode.enum_type f2)/+noexcept+/{return QFlags!(QIODevice.OpenMode.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QIODevice.OpenMode.enum_type) operator ^(QIODevice.OpenMode.enum_type f1, QFlags!(QIODevice.OpenMode.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QIODevice.OpenMode.enum_type f1, QIODevice.OpenMode.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QIODevice.OpenMode.enum_type f1, QFlags!(QIODevice.OpenMode.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QIODevice.OpenMode.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QIODevice.OpenMode.enum_type f1, QIODevice.OpenMode.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QIODevice.OpenMode.enum_type f1, QFlags!(QIODevice.OpenMode.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QIODevice.OpenMode.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QIODevice.OpenMode.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QIODevice.OpenMode.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QIODevice.OpenMode.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QIODevice.OpenMode.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIODevice.OpenMode operator ~(QIODevice.OpenMode.enum_type e)/+noexcept+/{return~QIODevice.OpenMode(e);}+/
/+pragma(inline, true) void operator |(QIODevice.OpenMode.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QIODevice.OpenMode.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QIODevice::OpenMode)
#if !defined(QT_NO_DEBUG_STREAM)
class QDebug;
Q_CORE_EXPORT QDebug operator<<(QDebug debug, QIODevice::OpenMode modes);
#endif +/

