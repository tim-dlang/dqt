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
module qt.multimedia.mediarecorder;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.object;
import qt.core.size;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.multimedia.mediacapturesession;
import qt.multimedia.mediaformat;

extern(C++, class) struct QPlatformMediaRecorder;

extern(C++, class) struct QMediaRecorderPrivate;
/// Binding for C++ class [QMediaRecorder](https://doc.qt.io/qt-6/qmediarecorder.html).
class /+ Q_MULTIMEDIA_EXPORT +/ QMediaRecorder : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QMediaRecorder::RecorderState recorderState READ recorderState NOTIFY recorderStateChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(QUrl outputLocation READ outputLocation WRITE setOutputLocation)
    Q_PROPERTY(QUrl actualLocation READ actualLocation NOTIFY actualLocationChanged)
    Q_PROPERTY(QMediaMetaData metaData READ metaData WRITE setMetaData NOTIFY metaDataChanged)
    Q_PROPERTY(QMediaRecorder::Error error READ error NOTIFY errorChanged)
    Q_PROPERTY(QString errorString READ errorString NOTIFY errorChanged)
    Q_PROPERTY(QMediaFormat mediaFormat READ mediaFormat WRITE setMediaFormat NOTIFY mediaFormatChanged)
    Q_PROPERTY(Quality quality READ quality WRITE setQuality) +/
public:
    enum Quality
    {
        VeryLowQuality,
        LowQuality,
        NormalQuality,
        HighQuality,
        VeryHighQuality
    }
    /+ Q_ENUM(Quality) +/

    enum EncodingMode
    {
        ConstantQualityEncoding,
        ConstantBitRateEncoding,
        AverageBitRateEncoding,
        TwoPassEncoding
    }
    /+ Q_ENUM(EncodingMode) +/

    enum RecorderState
    {
        StoppedState,
        RecordingState,
        PausedState
    }
    /+ Q_ENUM(RecorderState) +/

    enum Error
    {
        NoError,
        ResourceError,
        FormatError,
        OutOfSpaceError,
        LocationNotWritable
    }
    /+ Q_ENUM(Error) +/

    this(QObject parent = null);
    ~this();

    final bool isAvailable() const;

    final QUrl outputLocation() const;
    final void setOutputLocation(ref const(QUrl) location);

    final QUrl actualLocation() const;

    final RecorderState recorderState() const;

    final Error error() const;
    final QString errorString() const;

    final qint64 duration() const;

    final QMediaFormat mediaFormat() const;
    final void setMediaFormat(ref const(QMediaFormat) format);

    final EncodingMode encodingMode() const;
    final void setEncodingMode(EncodingMode);

    final Quality quality() const;
    final void setQuality(Quality quality);

    final QSize videoResolution() const;
    final void setVideoResolution(ref const(QSize) );
    final void setVideoResolution(int width, int height) { auto tmp = QSize(width, height); setVideoResolution(tmp); }

    final qreal videoFrameRate() const;
    final void setVideoFrameRate(qreal frameRate);

    final int videoBitRate() const;
    final void setVideoBitRate(int bitRate);

    final int audioBitRate() const;
    final void setAudioBitRate(int bitRate);

    final int audioChannelCount() const;
    final void setAudioChannelCount(int channels);

    final int audioSampleRate() const;
    final void setAudioSampleRate(int sampleRate);

    /+ QMediaMetaData metaData() const; +/
    /+ void setMetaData(const QMediaMetaData &metaData); +/
    /+ void addMetaData(const QMediaMetaData &metaData); +/

    final QMediaCaptureSession captureSession() const;
    final QPlatformMediaRecorder* platformRecoder() const;

public /+ Q_SLOTS +/:
    @QSlot final void record();
    @QSlot final void pause();
    @QSlot final void stop();

/+ Q_SIGNALS +/public:
    @QSignal final void recorderStateChanged(RecorderState state);
    @QSignal final void durationChanged(qint64 duration);
    @QSignal final void actualLocationChanged(ref const(QUrl) location);
    @QSignal final void encoderSettingsChanged();

    @QSignal final void errorOccurred(Error error, ref const(QString) errorString);
    @QSignal final void errorChanged();

    @QSignal final void metaDataChanged();

    @QSignal final void mediaFormatChanged();
    @QSignal final void encodingModeChanged();
    @QSignal final void qualityChanged();
    @QSignal final void videoResolutionChanged();
    @QSignal final void videoFrameRateChanged();
    @QSignal final void videoBitRateChanged();
    @QSignal final void audioBitRateChanged();
    @QSignal final void audioChannelCountChanged();
    @QSignal final void audioSampleRateChanged();

private:
    QMediaRecorderPrivate* d_ptr;
    /+ friend class QMediaCaptureSession; +/
    final void setCaptureSession(QMediaCaptureSession session);
    /+ Q_DISABLE_COPY(QMediaRecorder) +/
    /+ Q_DECLARE_PRIVATE(QMediaRecorder) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ Q_MEDIA_ENUM_DEBUG(QMediaRecorder, RecorderState)
Q_MEDIA_ENUM_DEBUG(QMediaRecorder, Error) +/

