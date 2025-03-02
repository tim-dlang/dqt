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
module qt.multimedia.soundeffect;
extern(C++):

import qt.config;
import qt.core.object;
import qt.core.stringlist;
import qt.core.url;
import qt.helpers;
import qt.multimedia.audiodevice;

extern(C++, class) struct QSoundEffectPrivate;

/// Binding for C++ class [QSoundEffect](https://doc.qt.io/qt-6/qsoundeffect.html).
class /+ Q_MULTIMEDIA_EXPORT +/ QSoundEffect : QObject
{
    mixin(Q_OBJECT);
    /+ Q_CLASSINFO("DefaultMethod", "play()")
    Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(int loops READ loopCount WRITE setLoopCount NOTIFY loopCountChanged)
    Q_PROPERTY(int loopsRemaining READ loopsRemaining NOTIFY loopsRemainingChanged)
    Q_PROPERTY(float volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(bool muted READ isMuted WRITE setMuted NOTIFY mutedChanged)
    Q_PROPERTY(bool playing READ isPlaying NOTIFY playingChanged)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged)
    Q_PROPERTY(QAudioDevice audioDevice READ audioDevice WRITE setAudioDevice NOTIFY audioDeviceChanged) +/

public:
    enum Loop
    {
        Infinite = -2
    }
    /+ Q_ENUM(Loop) +/

    enum Status
    {
        Null,
        Loading,
        Ready,
        Error
    }
    /+ Q_ENUM(Status) +/

    /+ explicit +/this(QObject parent = null);
    /+ explicit +/this(ref const(QAudioDevice) audioDevice, QObject parent = null);
    ~this();

    static QStringList supportedMimeTypes();

    final QUrl source() const;
    final void setSource(ref const(QUrl) url);

    final int loopCount() const;
    final int loopsRemaining() const;
    final void setLoopCount(int loopCount);

    final QAudioDevice audioDevice();
    final void setAudioDevice(ref const(QAudioDevice) device);

    final float volume() const;
    final void setVolume(float volume);

    final bool isMuted() const;
    final void setMuted(bool muted);

    final bool isLoaded() const;

    final bool isPlaying() const;
    final Status status() const;

/+ Q_SIGNALS +/public:
    @QSignal final void sourceChanged();
    @QSignal final void loopCountChanged();
    @QSignal final void loopsRemainingChanged();
    @QSignal final void volumeChanged();
    @QSignal final void mutedChanged();
    @QSignal final void loadedChanged();
    @QSignal final void playingChanged();
    @QSignal final void statusChanged();
    @QSignal final void audioDeviceChanged();

public /+ Q_SLOTS +/:
    @QSlot final void play();
    @QSlot final void stop();

private:
    /+ Q_DISABLE_COPY(QSoundEffect) +/
    QSoundEffectPrivate* d = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

