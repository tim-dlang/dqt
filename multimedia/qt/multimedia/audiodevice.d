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
module qt.multimedia.audiodevice;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.list;
import qt.core.metamacros;
import qt.core.shareddata;
import qt.core.string;
import qt.helpers;
import qt.multimedia.audioformat;

extern(C++, class) struct QAudioDevicePrivate;
/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QAudioDevicePrivate, Q_MULTIMEDIA_EXPORT) +/
/// Binding for C++ class [QAudioDevice](https://doc.qt.io/qt-6/qaudiodevice.html).
extern(C++, class) struct /+ Q_MULTIMEDIA_EXPORT +/ QAudioDevice
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(QByteArray id READ id CONSTANT)
    Q_PROPERTY(QString description READ description CONSTANT)
    Q_PROPERTY(bool isDefault READ isDefault CONSTANT)
    Q_PROPERTY(Mode mode READ mode CONSTANT) +/
public:
    enum Mode {
        Null,
        Input,
        Output
    }
    /+ Q_ENUM(Mode) +/

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QAudioDevice) other);
    ~this();

    /+ QAudioDevice(QAudioDevice &&other) noexcept = default; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QAudioDevice) +/
    /+ void swap(QAudioDevice &other) noexcept
    { d.swap(other.d); } +/

    ref QAudioDevice opAssign(ref const(QAudioDevice) other);

    /+bool operator ==(ref const(QAudioDevice) other) const;+/
    /+bool operator !=(ref const(QAudioDevice) other) const;+/

    bool isNull() const;

    QByteArray id() const;
    QString description() const;

    bool isDefault() const;
    Mode mode() const;

    bool isFormatSupported(ref const(QAudioFormat) format) const;
    QAudioFormat preferredFormat() const;

    int minimumSampleRate() const;
    int maximumSampleRate() const;
    int minimumChannelCount() const;
    int maximumChannelCount() const;
    QList!(QAudioFormat.SampleFormat) supportedSampleFormats() const;
    QAudioFormat.ChannelConfig channelConfiguration() const;

    const(QAudioDevicePrivate)* handle() const { return d.get(); }
private:
    /+ friend class QAudioDevicePrivate; +/
    this(QAudioDevicePrivate* p);
    QExplicitlySharedDataPointer!(QAudioDevicePrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug dbg, QAudioDevice::Mode mode);
#endif +/

