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
module qt.gui.pointingdevice;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.global;
import qt.core.metamacros;
import qt.core.object;
import qt.core.string;
import qt.core.typeinfo;
import qt.gui.event;
import qt.gui.eventpoint;
import qt.gui.inputdevice;
import qt.helpers;

/+ class QDebug; +/
extern(C++, class) struct QPointingDevicePrivate;

/// Binding for C++ class [QPointingDeviceUniqueId](https://doc.qt.io/qt-6/qpointingdeviceuniqueid.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPointingDeviceUniqueId
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(qint64 numericId READ numericId CONSTANT) +/
public:
    /+/+ Q_ALWAYS_INLINE +/
        pragma(inline, true) this() nothrow
        {
            this.m_numericId = -1;
        }+/
    // compiler-generated copy/move ctor/assignment operators are ok!
    // compiler-generated dtor is ok!

    static QPointingDeviceUniqueId fromNumericId(qint64 id);

    /+ Q_ALWAYS_INLINE +/ pragma(inline, true) bool isValid() const nothrow { return m_numericId != -1; }
    qint64 numericId() const nothrow;

private:
    /+ friend bool operator==(QPointingDeviceUniqueId lhs, QPointingDeviceUniqueId rhs) noexcept
    { return lhs.numericId() == rhs.numericId(); } +/
    /+ friend bool operator!=(QPointingDeviceUniqueId lhs, QPointingDeviceUniqueId rhs) noexcept
    { return lhs.numericId() != rhs.numericId(); } +/

    // TODO: for TUIO 2, or any other type of complex token ID, an internal
    // array (or hash) can be added to hold additional properties.
    // In this case, m_numericId will then turn into an index into that array (or hash).
    qint64 m_numericId = -1;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QPointingDeviceUniqueId, Q_RELOCATABLE_TYPE);

Q_GUI_EXPORT size_t qHash(QPointingDeviceUniqueId key, size_t seed = 0) noexcept; +/

/// Binding for C++ class [QPointingDevice](https://doc.qt.io/qt-6/qpointingdevice.html).
class /+ Q_GUI_EXPORT +/ QPointingDevice : QInputDevice
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QPointingDevice) +/
    /+ Q_PROPERTY(PointerType pointerType READ pointerType CONSTANT)
    Q_PROPERTY(int maximumPoints READ maximumPoints CONSTANT)
    Q_PROPERTY(int buttonCount READ buttonCount CONSTANT)
    Q_PROPERTY(QPointingDeviceUniqueId uniqueId READ uniqueId CONSTANT) +/

public:
    enum /+ class +/ PointerType {
        Unknown = 0,
        Generic = 0x0001,   // mouse or similar
        Finger = 0x0002,    // touchscreen or pad
        Pen = 0x0004,       // stylus on a tablet
        Eraser = 0x0008,    // eraser end of a stylus
        Cursor = 0x0010,    // digitizer with crosshairs
        AllPointerTypes = 0x7FFF
    }
    /+ Q_DECLARE_FLAGS(PointerTypes, PointerType) +/
alias PointerTypes = QFlags!(PointerType);    /+ Q_FLAG(PointerTypes) +/

    enum GrabTransition {
        GrabPassive = 0x01,
        UngrabPassive = 0x02,
        CancelGrabPassive = 0x03,
        OverrideGrabPassive = 0x04,
        GrabExclusive = 0x10,
        UngrabExclusive = 0x20,
        CancelGrabExclusive = 0x30,
    }
    /+ Q_ENUM(GrabTransition) +/

    this(QObject parent = null);
    ~this();
    this(ref const(QString) name, qint64 systemId, QInputDevice.DeviceType devType,
                        PointerType pType, Capabilities caps, int maxPoints, int buttonCount,
                        ref const(QString) seatName = globalInitVar!QString,
                        QPointingDeviceUniqueId uniqueId = QPointingDeviceUniqueId(),
                        QObject parent = null);

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use the constructor") +/
        final void setType(DeviceType devType);
    /+ QT_DEPRECATED_VERSION_X_6_0("Use the constructor") +/
        final void setCapabilities(QInputDevice.Capabilities caps);
    /+ QT_DEPRECATED_VERSION_X_6_0("Use the constructor") +/
        final void setMaximumTouchPoints(int c);
/+ #endif +/

    final PointerType pointerType() const;
    final int maximumPoints() const;
    final int buttonCount() const;
    final QPointingDeviceUniqueId uniqueId() const;

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static const(QPointingDevice) primaryPointingDevice(ref const(QString) seatName = globalInitVar!QString);
    }));

    /+final bool operator ==(ref const(ValueClass!(QPointingDevice)) other) const;+/

/+ Q_SIGNALS +/public:
    // Workaround for https://issues.dlang.org/show_bug.cgi?id=22620
    private enum dummyNamespaceQEventPoint = __traits(getCppNamespaces, QEventPoint);

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    @QSignal final void grabChanged(QObject grabber, GrabTransition transition, const(QPointerEvent) event, ref const(QEventPoint) point) const;
    }));

protected:
    this(ref QPointingDevicePrivate d, QObject parent);

    /+ Q_DISABLE_COPY_MOVE(QPointingDevice) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QPointingDevice.PointerTypes.enum_type) operator |(QPointingDevice.PointerTypes.enum_type f1, QPointingDevice.PointerTypes.enum_type f2)nothrow{return QFlags!(QPointingDevice.PointerTypes.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QPointingDevice.PointerTypes.enum_type) operator |(QPointingDevice.PointerTypes.enum_type f1, QFlags!(QPointingDevice.PointerTypes.enum_type) f2)nothrow{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QPointingDevice.PointerTypes.enum_type) operator &(QPointingDevice.PointerTypes.enum_type f1, QPointingDevice.PointerTypes.enum_type f2)nothrow{return QFlags!(QPointingDevice.PointerTypes.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QPointingDevice.PointerTypes.enum_type) operator &(QPointingDevice.PointerTypes.enum_type f1, QFlags!(QPointingDevice.PointerTypes.enum_type) f2)nothrow{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QPointingDevice.PointerTypes.enum_type) operator ^(QPointingDevice.PointerTypes.enum_type f1, QPointingDevice.PointerTypes.enum_type f2)nothrow{return QFlags!(QPointingDevice.PointerTypes.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QPointingDevice.PointerTypes.enum_type) operator ^(QPointingDevice.PointerTypes.enum_type f1, QFlags!(QPointingDevice.PointerTypes.enum_type) f2)nothrow{return f2^f1;}+/
/+pragma(inline, true) void operator +(QPointingDevice.PointerTypes.enum_type f1, QPointingDevice.PointerTypes.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QPointingDevice.PointerTypes.enum_type f1, QFlags!(QPointingDevice.PointerTypes.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QPointingDevice.PointerTypes.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(QPointingDevice.PointerTypes.enum_type f1, QPointingDevice.PointerTypes.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QPointingDevice.PointerTypes.enum_type f1, QFlags!(QPointingDevice.PointerTypes.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QPointingDevice.PointerTypes.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QPointingDevice.PointerTypes.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QPointingDevice.PointerTypes.enum_type f1, int f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QPointingDevice.PointerTypes.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QPointingDevice.PointerTypes.enum_type f1, int f2)nothrow;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QPointingDevice.PointerTypes operator ~(QPointingDevice.PointerTypes.enum_type e)nothrow{return~QPointingDevice.PointerTypes(e);}+/
/+pragma(inline, true) void operator |(QPointingDevice.PointerTypes.enum_type f1, int f2)nothrow;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QPointingDevice.PointerTypes.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QPointingDevice::PointerTypes)
#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QPointingDevice *);
#endif +/

//typedef QPointingDevice QTouchDevice; // Qt 5 source compatibility if we need it? or could be "using"

