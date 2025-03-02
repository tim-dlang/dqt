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
module qt.multimedia.mediaplayer;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.iodevice;
import qt.core.object;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.multimedia.audiooutput;
import qt.multimedia.mediatimerange;
import qt.multimedia.videosink;

/+ class QMediaMetaData; +/

extern(C++, class) struct QMediaPlayerPrivate;
/// Binding for C++ class [QMediaPlayer](https://doc.qt.io/qt-6/qmediaplayer.html).
class /+ Q_MULTIMEDIA_EXPORT +/ QMediaPlayer : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(qint64 duration READ duration NOTIFY durationChanged)
    Q_PROPERTY(qint64 position READ position WRITE setPosition NOTIFY positionChanged)
    Q_PROPERTY(float bufferProgress READ bufferProgress NOTIFY bufferProgressChanged)
    Q_PROPERTY(bool hasAudio READ hasAudio NOTIFY hasAudioChanged)
    Q_PROPERTY(bool hasVideo READ hasVideo NOTIFY hasVideoChanged)
    Q_PROPERTY(bool seekable READ isSeekable NOTIFY seekableChanged)
    Q_PROPERTY(qreal playbackRate READ playbackRate WRITE setPlaybackRate NOTIFY playbackRateChanged)
    Q_PROPERTY(int loops READ loops WRITE setLoops NOTIFY loopsChanged)
    Q_PROPERTY(PlaybackState playbackState READ playbackState NOTIFY playbackStateChanged)
    Q_PROPERTY(MediaStatus mediaStatus READ mediaStatus NOTIFY mediaStatusChanged)
    Q_PROPERTY(QMediaMetaData metaData READ metaData NOTIFY metaDataChanged)
    Q_PROPERTY(Error error READ error NOTIFY errorChanged)
    Q_PROPERTY(QString errorString READ errorString NOTIFY errorChanged)
    Q_PROPERTY(QObject *videoOutput READ videoOutput WRITE setVideoOutput NOTIFY videoOutputChanged)
    Q_PROPERTY(QAudioOutput *audioOutput READ audioOutput WRITE setAudioOutput NOTIFY
                       audioOutputChanged)

    Q_PROPERTY(QList<QMediaMetaData> audioTracks READ audioTracks NOTIFY tracksChanged)
    Q_PROPERTY(QList<QMediaMetaData> videoTracks READ videoTracks NOTIFY tracksChanged)
    Q_PROPERTY(QList<QMediaMetaData> subtitleTracks READ subtitleTracks NOTIFY tracksChanged)

    Q_PROPERTY(int activeAudioTrack READ activeAudioTrack WRITE setActiveAudioTrack NOTIFY
                       activeTracksChanged)
    Q_PROPERTY(int activeVideoTrack READ activeVideoTrack WRITE setActiveVideoTrack NOTIFY
                       activeTracksChanged)
    Q_PROPERTY(int activeSubtitleTrack READ activeSubtitleTrack WRITE setActiveSubtitleTrack NOTIFY
                       activeTracksChanged) +/

public:
    enum PlaybackState
    {
        StoppedState,
        PlayingState,
        PausedState
    }
    /+ Q_ENUM(PlaybackState) +/

    enum MediaStatus
    {
        NoMedia,
        LoadingMedia,
        LoadedMedia,
        StalledMedia,
        BufferingMedia,
        BufferedMedia,
        EndOfMedia,
        InvalidMedia
    }
    /+ Q_ENUM(MediaStatus) +/

    enum Error
    {
        NoError,
        ResourceError,
        FormatError,
        NetworkError,
        AccessDeniedError
    }
    /+ Q_ENUM(Error) +/

    enum Loops
    {
        Infinite = -1,
        Once = 1
    }
    /+ Q_ENUM(Loops) +/

    /+ explicit +/this(QObject parent = null);
    ~this();

    /+ QList<QMediaMetaData> audioTracks() const; +/
    /+ QList<QMediaMetaData> videoTracks() const; +/
    /+ QList<QMediaMetaData> subtitleTracks() const; +/

    final int activeAudioTrack() const;
    final int activeVideoTrack() const;
    final int activeSubtitleTrack() const;

    final void setActiveAudioTrack(int index);
    final void setActiveVideoTrack(int index);
    final void setActiveSubtitleTrack(int index);

    final void setAudioOutput(QAudioOutput output);
    final QAudioOutput audioOutput() const;

    final void setVideoOutput(QObject );
    final QObject videoOutput() const;

    final void setVideoSink(QVideoSink sink);
    final QVideoSink videoSink() const;

    final QUrl source() const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final const(QIODevice) sourceDevice() const;
    }));

    final PlaybackState playbackState() const;
    final MediaStatus mediaStatus() const;

    final qint64 duration() const;
    final qint64 position() const;

    final bool hasAudio() const;
    final bool hasVideo() const;

    final float bufferProgress() const;
    final QMediaTimeRange bufferedTimeRange() const;

    final bool isSeekable() const;
    final qreal playbackRate() const;

    final int loops() const;
    final void setLoops(int loops);

    final Error error() const;
    final QString errorString() const;

    final bool isAvailable() const;
    /+ QMediaMetaData metaData() const; +/

public /+ Q_SLOTS +/:
    @QSlot final void play();
    @QSlot final void pause();
    @QSlot final void stop();

    @QSlot final void setPosition(qint64 position);

    @QSlot final void setPlaybackRate(qreal rate);

    @QSlot final void setSource(ref const(QUrl) source);
    @QSlot final void setSourceDevice(QIODevice device, ref const(QUrl) sourceUrl = globalInitVar!QUrl);

/+ Q_SIGNALS +/public:
    @QSignal final void sourceChanged(ref const(QUrl) media);
    @QSignal final void playbackStateChanged(PlaybackState newState);
    @QSignal final void mediaStatusChanged(MediaStatus status);

    @QSignal final void durationChanged(qint64 duration);
    @QSignal final void positionChanged(qint64 position);

    @QSignal final void hasAudioChanged(bool available);
    @QSignal final void hasVideoChanged(bool videoAvailable);

    @QSignal final void bufferProgressChanged(float progress);

    @QSignal final void seekableChanged(bool seekable);
    @QSignal final void playbackRateChanged(qreal rate);
    @QSignal final void loopsChanged();

    @QSignal final void metaDataChanged();
    @QSignal final void videoOutputChanged();
    @QSignal final void audioOutputChanged();

    @QSignal final void tracksChanged();
    @QSignal final void activeTracksChanged();

    @QSignal final void errorChanged();
    @QSignal final void errorOccurred(Error error, ref const(QString) errorString);

private:
    /+ Q_DISABLE_COPY(QMediaPlayer) +/
    /+ Q_DECLARE_PRIVATE(QMediaPlayer) +/
    /+ friend class QPlatformMediaPlayer; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ Q_MEDIA_ENUM_DEBUG(QMediaPlayer, PlaybackState)
Q_MEDIA_ENUM_DEBUG(QMediaPlayer, MediaStatus)
Q_MEDIA_ENUM_DEBUG(QMediaPlayer, Error) +/

