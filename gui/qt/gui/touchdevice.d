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
module qt.gui.touchdevice;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.list;
import qt.core.objectdefs;
import qt.core.string;
import qt.helpers;

/+ class QDebug; +/
extern(C++, class) struct QTouchDevicePrivate;

extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTouchDevice
{
    mixin(Q_GADGET);
public:
    enum DeviceType {
        TouchScreen,
        TouchPad
    }
    /+ Q_ENUM(DeviceType) +/

    enum CapabilityFlag {
        Position = 0x0001,
        Area = 0x0002,
        Pressure = 0x0004,
        Velocity = 0x0008,
        RawPositions = 0x0010,
        NormalizedPosition = 0x0020,
        MouseEmulation = 0x0040
    }
    /+ Q_FLAG(CapabilityFlag) +/
    /+ Q_DECLARE_FLAGS(Capabilities, CapabilityFlag) +/
alias Capabilities = QFlags!(CapabilityFlag);
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    ~this();

    static QList!(const(QTouchDevice)*) devices();

    QString name() const;
    DeviceType type() const;
    Capabilities capabilities() const;
    int maximumTouchPoints() const;

    void setName(ref const(QString) name);
    void setType(DeviceType devType);
    void setCapabilities(Capabilities caps);
    void setMaximumTouchPoints(int max);

private:
    QTouchDevicePrivate* d;
    /+ friend class QTouchDevicePrivate; +/
}
/+pragma(inline, true) QFlags!(QTouchDevice.Capabilities.enum_type) operator |(QTouchDevice.Capabilities.enum_type f1, QTouchDevice.Capabilities.enum_type f2)/+noexcept+/{return QFlags!(QTouchDevice.Capabilities.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QTouchDevice.Capabilities.enum_type) operator |(QTouchDevice.Capabilities.enum_type f1, QFlags!(QTouchDevice.Capabilities.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QTouchDevice.Capabilities.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QTouchDevice::Capabilities)
#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QTouchDevice *);
#endif +/

