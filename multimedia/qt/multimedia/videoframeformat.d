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
module qt.multimedia.videoframeformat;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.global;
import qt.core.metatype;
import qt.core.rect;
import qt.core.shareddata;
import qt.core.size;
import qt.core.string;
import qt.core.typeinfo;
import qt.gui.image;
import qt.helpers;
import qt.multimedia.videoframe;

/+ class QDebug; +/

extern(C++, class) struct QVideoFrameFormatPrivate;

/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QVideoFrameFormatPrivate, Q_MULTIMEDIA_EXPORT) +/
/// Binding for C++ class [QVideoFrameFormat](https://doc.qt.io/qt-6/qvideoframeformat.html).
@Q_DECLARE_METATYPE @Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_MULTIMEDIA_EXPORT +/ QVideoFrameFormat
{
public:
    enum PixelFormat
    {
        Format_Invalid,
        Format_ARGB8888,
        Format_ARGB8888_Premultiplied,
        Format_XRGB8888,
        Format_BGRA8888,
        Format_BGRA8888_Premultiplied,
        Format_BGRX8888,
        Format_ABGR8888,
        Format_XBGR8888,
        Format_RGBA8888,
        Format_RGBX8888,

        Format_AYUV,
        Format_AYUV_Premultiplied,
        Format_YUV420P,
        Format_YUV422P,
        Format_YV12,
        Format_UYVY,
        Format_YUYV,
        Format_NV12,
        Format_NV21,
        Format_IMC1,
        Format_IMC2,
        Format_IMC3,
        Format_IMC4,
        Format_Y8,
        Format_Y16,

        Format_P010,
        Format_P016,

        Format_SamplerExternalOES,
        Format_Jpeg,
        Format_SamplerRect,

        Format_YUV420P10
    }
/+ #ifndef Q_QDOC +/
    extern(D) static immutable int NPixelFormats = PixelFormat.Format_YUV420P10 + 1;
/+ #endif +/

    enum Direction
    {
        TopToBottom,
        BottomToTop
    }

/+ #if QT_DEPRECATED_SINCE(6, 4) +/
    enum YCbCrColorSpace
    {
        YCbCr_Undefined = 0,
        YCbCr_BT601 = 1,
        YCbCr_BT709 = 2,
        YCbCr_xvYCC601 = 3,
        YCbCr_xvYCC709 = 4,
        YCbCr_JPEG = 5,
        YCbCr_BT2020 = 6
    }
/+ #endif +/

    // Keep values compatible with YCbCrColorSpace
    enum ColorSpace
    {
        ColorSpace_Undefined = 0,
        ColorSpace_BT601 = 1,
        ColorSpace_BT709 = 2,
        ColorSpace_AdobeRgb = 5,
        ColorSpace_BT2020 = 6
    }

    enum ColorTransfer
    {
        ColorTransfer_Unknown,
        ColorTransfer_BT709,
        ColorTransfer_BT601,
        ColorTransfer_Linear,
        ColorTransfer_Gamma22,
        ColorTransfer_Gamma28,
        ColorTransfer_ST2084,
        ColorTransfer_STD_B67,
    }

    enum ColorRange
    {
        ColorRange_Unknown,
        ColorRange_Video,
        ColorRange_Full
    }

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(ref const(QSize) size, PixelFormat pixelFormat);
    @disable this(this);
    this(ref const(QVideoFrameFormat) format);
    ~this();

    /+ QVideoFrameFormat(QVideoFrameFormat &&other) noexcept = default; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QVideoFrameFormat) +/
    /+ void swap(QVideoFrameFormat &other) noexcept
    { d.swap(other.d); } +/

    void detach();

    ref QVideoFrameFormat opAssign(ref const(QVideoFrameFormat) format);

    /+bool operator ==(ref const(QVideoFrameFormat) format) const;+/
    /+bool operator !=(ref const(QVideoFrameFormat) format) const;+/

    bool isValid() const;

    PixelFormat pixelFormat() const;

    QSize frameSize() const;
    void setFrameSize(ref const(QSize) size);
    void setFrameSize(int width, int height);

    int frameWidth() const;
    int frameHeight() const;

    int planeCount() const;

    QRect viewport() const;
    void setViewport(ref const(QRect) viewport);

    Direction scanLineDirection() const;
    void setScanLineDirection(Direction direction);

    qreal frameRate() const;
    void setFrameRate(qreal rate);

/+ #if QT_DEPRECATED_SINCE(6, 4) +/
    /+ QT_DEPRECATED_VERSION_X_6_4("Use colorSpace()") +/
        YCbCrColorSpace yCbCrColorSpace() const;
    /+ QT_DEPRECATED_VERSION_X_6_4("Use setColorSpace()") +/
        void setYCbCrColorSpace(YCbCrColorSpace colorSpace);
/+ #endif +/

    ColorSpace colorSpace() const;
    void setColorSpace(ColorSpace colorSpace);

    ColorTransfer colorTransfer() const;
    void setColorTransfer(ColorTransfer colorTransfer);

    ColorRange colorRange() const;
    void setColorRange(ColorRange range);

    bool isMirrored() const;
    void setMirrored(bool mirrored);

    QString vertexShaderFileName() const;
    QString fragmentShaderFileName() const;
    void updateUniformData(QByteArray* dst, ref const(QVideoFrame) frame, ref const(QMatrix4x4) transform, float opacity) const;

    float maxLuminance() const;
    void setMaxLuminance(float lum);

    static PixelFormat pixelFormatFromImageFormat(QImage.Format format);
    static QImage.Format imageFormatFromPixelFormat(PixelFormat format);

    static QString pixelFormatToString(PixelFormat pixelFormat);

private:
    QExplicitlySharedDataPointer!(QVideoFrameFormatPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QVideoFrameFormat)

#ifndef QT_NO_DEBUG_STREAM
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug, const QVideoFrameFormat &);
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug, QVideoFrameFormat::Direction);
#if QT_DEPRECATED_SINCE(6, 4)
QT_DEPRECATED_VERSION_X_6_4("Use QVideoFrameFormat::ColorSpace")
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug, QVideoFrameFormat::YCbCrColorSpace);
#endif
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug, QVideoFrameFormat::ColorSpace);
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug, QVideoFrameFormat::PixelFormat);
#endif


Q_DECLARE_METATYPE(QVideoFrameFormat) +/

