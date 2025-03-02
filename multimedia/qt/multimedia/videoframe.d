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
module qt.multimedia.videoframe;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.global;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.rect;
import qt.core.shareddata;
import qt.core.size;
import qt.core.string;
import qt.core.typeinfo;
import qt.gui.color;
import qt.gui.image;
import qt.gui.painter;
import qt.helpers;
import qt.multimedia.videoframeformat;

extern(C++, class) struct QVideoFramePrivate;
extern(C++, class) struct QVideoFrameTextures;
extern(C++, class) struct QAbstractVideoBuffer;
extern(C++, class) struct QRhi;
extern(C++, class) struct QRhiResourceUpdateBatch;
extern(C++, class) struct QRhiTexture;

/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QVideoFramePrivate, Q_MULTIMEDIA_EXPORT) +/
/// Binding for C++ class [QVideoFrame](https://doc.qt.io/qt-6/qvideoframe.html).
@Q_DECLARE_METATYPE @Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_MULTIMEDIA_EXPORT +/ QVideoFrame
{
public:

    enum HandleType
    {
        NoHandle,
        RhiTextureHandle
    }

    enum MapMode
    {
        NotMapped = 0x00,
        ReadOnly  = 0x01,
        WriteOnly = 0x02,
        ReadWrite = MapMode.ReadOnly | MapMode.WriteOnly
    }

    enum RotationAngle
    {
        Rotation0 = 0,
        Rotation90 = 90,
        Rotation180 = 180,
        Rotation270 = 270
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

    this(ref const(QVideoFrameFormat) format);
    @disable this(this);
    this(ref const(QVideoFrame) other);
    ~this();

    /+ QVideoFrame(QVideoFrame &&other) noexcept = default; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QVideoFrame) +/
    /+ void swap(QVideoFrame &other) noexcept
    { d.swap(other.d); } +/


    /+ref QVideoFrame operator =(ref const(QVideoFrame) other);+/
    /+bool operator ==(ref const(QVideoFrame) other) const;+/
    /+bool operator !=(ref const(QVideoFrame) other) const;+/

    bool isValid() const;

    QVideoFrameFormat.PixelFormat pixelFormat() const;

    QVideoFrameFormat surfaceFormat() const;
    HandleType handleType() const;

    QSize size() const;
    int width() const;
    int height() const;

    bool isMapped() const;
    bool isReadable() const;
    bool isWritable() const;

    MapMode mapMode() const;

    bool map(MapMode mode);
    void unmap();

    int bytesPerLine(int plane) const;

    uchar* bits(int plane);
    const(uchar)* bits(int plane) const;
    int mappedBytes(int plane) const;
    int planeCount() const;

    qint64 startTime() const;
    void setStartTime(qint64 time);

    qint64 endTime() const;
    void setEndTime(qint64 time);

    /*void setRotationAngle(RotationAngle);
    RotationAngle rotationAngle() const;*/

    void setMirrored(bool);
    bool mirrored() const;

    QImage toImage() const;

    /*struct PaintOptions {
        QColor backgroundColor = /+ Qt:: +/qt.core.namespace.GlobalColor.transparent;
        /+ Qt:: +/qt.core.namespace.AspectRatioMode aspectRatioMode = /+ Qt:: +/qt.core.namespace.AspectRatioMode.KeepAspectRatio;
        enum PaintFlag {
            DontDrawSubtitles = 0x1
        }
        /+ Q_DECLARE_FLAGS(PaintFlags, PaintFlag) +/
alias PaintFlags = QFlags!(PaintFlag);        PaintFlags paintFlags = {};
    }*/

    QString subtitleText() const;
    void setSubtitleText(ref const(QString) text);

    //void paint(QPainter* painter, ref const(QRectF) rect, ref const(PaintOptions) options);

    this(QAbstractVideoBuffer* buffer, ref const(QVideoFrameFormat) format);

    QAbstractVideoBuffer* videoBuffer() const;
private:
    QExplicitlySharedDataPointer!(QVideoFramePrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QVideoFrame)

#ifndef QT_NO_DEBUG_STREAM
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug, const QVideoFrame&);
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug, QVideoFrame::HandleType);
#endif


Q_DECLARE_METATYPE(QVideoFrame) +/

