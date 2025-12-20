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
module qt.multimedia.mediaformat;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.metamacros;
import qt.core.object;
import qt.core.shareddata;
import qt.core.string;
import qt.helpers;

extern(C++, class) struct QMimeType;
extern(C++, class) struct QMediaFormatPrivate;

/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QMediaFormatPrivate, Q_MULTIMEDIA_EXPORT) +/
/// Binding for C++ class [QMediaFormat](https://doc.qt.io/qt-6/qmediaformat.html).
extern(C++, class) struct /+ Q_MULTIMEDIA_EXPORT +/ QMediaFormat
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(FileFormat fileFormat READ fileFormat WRITE setFileFormat)
    Q_PROPERTY(AudioCodec audioCodec READ audioCodec WRITE setAudioCodec)
    Q_PROPERTY(VideoCodec videoCodec READ videoCodec WRITE setVideoCodec)
    Q_CLASSINFO("RegisterEnumClassesUnscoped", "false") +/
public:
    enum FileFormat {
        UnspecifiedFormat = -1,
        // Video Formats
        WMV,
        AVI,
        Matroska,
        MPEG4,
        Ogg,
        QuickTime,
        WebM,
        // Audio Only Formats
        Mpeg4Audio,
        AAC,
        WMA,
        MP3,
        FLAC,
        Wave,
        LastFileFormat = FileFormat.Wave
    }
    /+ Q_ENUM(FileFormat) +/

    enum /+ class +/ AudioCodec {
        Unspecified = -1,
        MP3,
        AAC,
        AC3,
        EAC3,
        FLAC,
        DolbyTrueHD,
        Opus,
        Vorbis,
        Wave,
        WMA,
        ALAC,
        LastAudioCodec = ALAC
    }
    /+ Q_ENUM(AudioCodec) +/

    enum /+ class +/ VideoCodec {
        Unspecified = -1,
        MPEG1,
        MPEG2,
        MPEG4,
        H264,
        H265,
        VP8,
        VP9,
        AV1,
        Theora,
        WMV,
        MotionJPEG,
        LastVideoCodec = MotionJPEG
    }
    /+ Q_ENUM(VideoCodec) +/

    enum ConversionMode {
        Encode,
        Decode
    }
    /+ Q_ENUM(ConversionMode) +/

    enum ResolveFlags
    {
        NoFlags,
        RequiresVideo
    }

    this(FileFormat format/+ = FileFormat.UnspecifiedFormat+/);
    ~this();
    @disable this(this);
    this(ref const(QMediaFormat) other)/+ noexcept+/;
    ref QMediaFormat opAssign(ref const(QMediaFormat) other)/+ noexcept+/;

    /+ QMediaFormat(QMediaFormat &&other) noexcept = default; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QMediaFormat) +/
    /+ void swap(QMediaFormat &other) noexcept
    {
        std::swap(fmt, other.fmt);
        std::swap(audio, other.audio);
        std::swap(video, other.video);
        d.swap(other.d);
    } +/

    FileFormat fileFormat() const { return fmt; }
    void setFileFormat(FileFormat f) { fmt = f; }

    void setVideoCodec(VideoCodec codec) { video = codec; }
    VideoCodec videoCodec() const { return video; }

    void setAudioCodec(AudioCodec codec) { audio = codec; }
    AudioCodec audioCodec() const { return audio; }

    @QInvokable bool isSupported(ConversionMode mode) const;

    //QMimeType mimeType() const;

    @QInvokable QList!(FileFormat) supportedFileFormats(ConversionMode m);
    @QInvokable QList!(VideoCodec) supportedVideoCodecs(ConversionMode m);
    @QInvokable QList!(AudioCodec) supportedAudioCodecs(ConversionMode m);

    @QInvokable static QString fileFormatName(FileFormat fileFormat);
    @QInvokable static QString audioCodecName(AudioCodec codec);
    @QInvokable static QString videoCodecName(VideoCodec codec);

    @QInvokable static QString fileFormatDescription(FileFormat fileFormat);
    @QInvokable static QString audioCodecDescription(AudioCodec codec);
    @QInvokable static QString videoCodecDescription(VideoCodec codec);

    /+bool operator ==(ref const(QMediaFormat) other) const;+/
    /+bool operator !=(ref const(QMediaFormat) other) const
    { return !operator==(other); }+/

    void resolveForEncoding(ResolveFlags flags);

protected:
    /+ friend class QMediaFormatPrivate; +/
    FileFormat fmt = FileFormat.UnspecifiedFormat;
    AudioCodec audio = AudioCodec.Unspecified;
    VideoCodec video = VideoCodec.Unspecified;
    QExplicitlySharedDataPointer!(QMediaFormatPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

