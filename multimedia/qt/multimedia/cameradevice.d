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
module qt.multimedia.cameradevice;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.list;
import qt.core.metamacros;
import qt.core.shareddata;
import qt.core.size;
import qt.core.string;
import qt.helpers;
import qt.multimedia.videoframeformat;

extern(C++, class) struct QCameraFormatPrivate;
/// Binding for C++ class [QCameraFormat](https://doc.qt.io/qt-6/qcameraformat.html).
extern(C++, class) struct /+ Q_MULTIMEDIA_EXPORT +/ QCameraFormat
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(QSize resolution READ resolution CONSTANT)
    Q_PROPERTY(QVideoFrameFormat::PixelFormat pixelFormat READ pixelFormat CONSTANT)
    Q_PROPERTY(float minFrameRate READ minFrameRate CONSTANT)
    Q_PROPERTY(float maxFrameRate READ maxFrameRate CONSTANT) +/
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor()/+ noexcept+/;
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QCameraFormat) other)/+ noexcept+/;
    ref QCameraFormat opAssign(ref const(QCameraFormat) other)/+ noexcept+/;
    ~this();

    QVideoFrameFormat.PixelFormat pixelFormat() const/+ noexcept+/;
    QSize resolution() const/+ noexcept+/;
    float minFrameRate() const/+ noexcept+/;
    float maxFrameRate() const/+ noexcept+/;

    bool isNull() const/+ noexcept+/ { return !d.get; }

    /+bool operator ==(ref const(QCameraFormat) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QCameraFormat) other) const
    { return !operator==(other); }+/

private:
    /+ friend class QCameraFormatPrivate; +/
    this(QCameraFormatPrivate* p);
    QExplicitlySharedDataPointer!(QCameraFormatPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QCameraDevicePrivate;
/// Binding for C++ class [QCameraDevice](https://doc.qt.io/qt-6/qcameradevice.html).
extern(C++, class) struct /+ Q_MULTIMEDIA_EXPORT +/ QCameraDevice
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(QByteArray id READ id CONSTANT)
    Q_PROPERTY(QString description READ description CONSTANT)
    Q_PROPERTY(bool isDefault READ isDefault CONSTANT)
    Q_PROPERTY(Position position READ position CONSTANT)
    Q_PROPERTY(QList<QCameraFormat> videoFormats READ videoFormats CONSTANT) +/
public:
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
    this(ref const(QCameraDevice) other);
    ref QCameraDevice opAssign(ref const(QCameraDevice) other);
    ~this();

    /+bool operator ==(ref const(QCameraDevice) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QCameraDevice) other) const { return !operator==(other); }+/

    bool isNull() const;

    QByteArray id() const;
    QString description() const;

    // ### Add here and to QAudioDevice
//    QByteArray groupId() const;
//    QString groupDescription() const;

    bool isDefault() const;

    enum Position
    {
        UnspecifiedPosition,
        BackFace,
        FrontFace
    }
    /+ Q_ENUM(Position) +/

    Position position() const;

    QList!(QSize) photoResolutions() const;
    QList!(QCameraFormat) videoFormats() const;

    // ### Add zoom and other camera information

private:
    /+ friend class QCameraDevicePrivate; +/
    this(QCameraDevicePrivate* p);
    QExplicitlySharedDataPointer!(QCameraDevicePrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug, const QCameraDevice&);
#endif +/

