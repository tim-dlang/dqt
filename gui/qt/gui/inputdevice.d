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
module qt.gui.inputdevice;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.global;
import qt.core.list;
import qt.core.object;
import qt.core.rect;
import qt.core.string;
import qt.core.stringlist;
import qt.helpers;

/+ class QDebug; +/
extern(C++, class) struct QInputDevicePrivate;

/// Binding for C++ class [QInputDevice](https://doc.qt.io/qt-6/qinputdevice.html).
class /+ Q_GUI_EXPORT +/ QInputDevice : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QInputDevice) +/
    /+ Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(DeviceType type READ type CONSTANT)
    Q_PROPERTY(Capabilities capabilities READ capabilities CONSTANT)
    Q_PROPERTY(qint64 systemId READ systemId CONSTANT)
    Q_PROPERTY(QString seatName READ seatName CONSTANT)
    Q_PROPERTY(QRect availableVirtualGeometry READ availableVirtualGeometry
               NOTIFY availableVirtualGeometryChanged) +/

public:
    enum /+ class +/ DeviceType {
        Unknown = 0x0000,
        Mouse = 0x0001,
        TouchScreen = 0x0002,
        TouchPad = 0x0004,
        Puck = 0x0008,
        Stylus = 0x0010,
        Airbrush = 0x0020,
        Keyboard = 0x1000,
        AllDevices = 0x7FFFFFFF
    }
    /+ Q_DECLARE_FLAGS(DeviceTypes, DeviceType) +/
alias DeviceTypes = QFlags!(DeviceType);    /+ Q_FLAG(DeviceTypes) +/

    enum /+ class +/ Capability {
        None = 0,
        Position = 0x0001,
        Area = 0x0002,
        Pressure = 0x0004,
        Velocity = 0x0008,
        NormalizedPosition = 0x0020,
        MouseEmulation = 0x0040,
        PixelScroll = 0x0080,
        Scroll      = 0x0100,
        Hover       = 0x0200,
        Rotation    = 0x0400,
        XTilt       = 0x0800,
        YTilt       = 0x1000,
        TangentialPressure = 0x2000,
        ZPosition   = 0x4000,
        All = 0x7FFFFFFF
    }
    /+ Q_DECLARE_FLAGS(Capabilities, Capability) +/
alias Capabilities = QFlags!(Capability);    /+ Q_FLAG(Capabilities) +/

    this(QObject parent = null);
    ~this();
    this(ref const(QString) name, qint64 systemId, DeviceType type,
                     ref const(QString) seatName = globalInitVar!QString, QObject parent = null);

    final QString name() const;
    final DeviceType type() const;
    final Capabilities capabilities() const;
    final bool hasCapability(Capability cap) const;
    final qint64 systemId() const;
    final QString seatName() const;
    final QRect availableVirtualGeometry() const;

    static QStringList seatNames();
    //static QList!(const(QInputDevice)) devices();
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static const(QInputDevice) primaryKeyboard(ref const(QString) seatName = globalInitVar!QString);
    }));

    /+final bool operator ==(ref const(ValueClass!(QInputDevice)) other) const;+/

/+ Q_SIGNALS +/public:
    @QSignal final void availableVirtualGeometryChanged(QRect area);

protected:
    this(ref QInputDevicePrivate d, QObject parent);

    /+ Q_DISABLE_COPY_MOVE(QInputDevice) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QInputDevice.DeviceTypes.enum_type) operator |(QInputDevice.DeviceTypes.enum_type f1, QInputDevice.DeviceTypes.enum_type f2)/+noexcept+/{return QFlags!(QInputDevice.DeviceTypes.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QInputDevice.DeviceTypes.enum_type) operator |(QInputDevice.DeviceTypes.enum_type f1, QFlags!(QInputDevice.DeviceTypes.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QInputDevice.DeviceTypes.enum_type) operator &(QInputDevice.DeviceTypes.enum_type f1, QInputDevice.DeviceTypes.enum_type f2)/+noexcept+/{return QFlags!(QInputDevice.DeviceTypes.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QInputDevice.DeviceTypes.enum_type) operator &(QInputDevice.DeviceTypes.enum_type f1, QFlags!(QInputDevice.DeviceTypes.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QInputDevice.DeviceTypes.enum_type) operator ^(QInputDevice.DeviceTypes.enum_type f1, QInputDevice.DeviceTypes.enum_type f2)/+noexcept+/{return QFlags!(QInputDevice.DeviceTypes.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QInputDevice.DeviceTypes.enum_type) operator ^(QInputDevice.DeviceTypes.enum_type f1, QFlags!(QInputDevice.DeviceTypes.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QInputDevice.DeviceTypes.enum_type f1, QInputDevice.DeviceTypes.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QInputDevice.DeviceTypes.enum_type f1, QFlags!(QInputDevice.DeviceTypes.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QInputDevice.DeviceTypes.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QInputDevice.DeviceTypes.enum_type f1, QInputDevice.DeviceTypes.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QInputDevice.DeviceTypes.enum_type f1, QFlags!(QInputDevice.DeviceTypes.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QInputDevice.DeviceTypes.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QInputDevice.DeviceTypes.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QInputDevice.DeviceTypes.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QInputDevice.DeviceTypes.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QInputDevice.DeviceTypes.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QInputDevice.DeviceTypes operator ~(QInputDevice.DeviceTypes.enum_type e)/+noexcept+/{return~QInputDevice.DeviceTypes(e);}+/
/+pragma(inline, true) void operator |(QInputDevice.DeviceTypes.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QInputDevice.DeviceTypes.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QInputDevice::DeviceTypes) +/
/+pragma(inline, true) QFlags!(QInputDevice.Capabilities.enum_type) operator |(QInputDevice.Capabilities.enum_type f1, QInputDevice.Capabilities.enum_type f2)/+noexcept+/{return QFlags!(QInputDevice.Capabilities.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QInputDevice.Capabilities.enum_type) operator |(QInputDevice.Capabilities.enum_type f1, QFlags!(QInputDevice.Capabilities.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QInputDevice.Capabilities.enum_type) operator &(QInputDevice.Capabilities.enum_type f1, QInputDevice.Capabilities.enum_type f2)/+noexcept+/{return QFlags!(QInputDevice.Capabilities.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QInputDevice.Capabilities.enum_type) operator &(QInputDevice.Capabilities.enum_type f1, QFlags!(QInputDevice.Capabilities.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QInputDevice.Capabilities.enum_type) operator ^(QInputDevice.Capabilities.enum_type f1, QInputDevice.Capabilities.enum_type f2)/+noexcept+/{return QFlags!(QInputDevice.Capabilities.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QInputDevice.Capabilities.enum_type) operator ^(QInputDevice.Capabilities.enum_type f1, QFlags!(QInputDevice.Capabilities.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QInputDevice.Capabilities.enum_type f1, QInputDevice.Capabilities.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QInputDevice.Capabilities.enum_type f1, QFlags!(QInputDevice.Capabilities.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QInputDevice.Capabilities.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QInputDevice.Capabilities.enum_type f1, QInputDevice.Capabilities.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QInputDevice.Capabilities.enum_type f1, QFlags!(QInputDevice.Capabilities.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QInputDevice.Capabilities.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QInputDevice.Capabilities.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QInputDevice.Capabilities.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QInputDevice.Capabilities.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QInputDevice.Capabilities.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QInputDevice.Capabilities operator ~(QInputDevice.Capabilities.enum_type e)/+noexcept+/{return~QInputDevice.Capabilities(e);}+/
/+pragma(inline, true) void operator |(QInputDevice.Capabilities.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QInputDevice.Capabilities.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}
/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QInputDevice::Capabilities)
#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QInputDevice *);
#endif +/

