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
module qt.multimedia.audiooutput;
extern(C++):

import qt.config;
import qt.core.object;
import qt.helpers;
import qt.multimedia.audiodevice;

extern(C++, class) struct QPlatformAudioOutput;

/// Binding for C++ class [QAudioOutput](https://doc.qt.io/qt-6/qaudiooutput.html).
class /+ Q_MULTIMEDIA_EXPORT +/ QAudioOutput : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QAudioDevice device READ device WRITE setDevice NOTIFY deviceChanged)
    Q_PROPERTY(float volume READ volume WRITE setVolume NOTIFY volumeChanged)
    Q_PROPERTY(bool muted READ isMuted WRITE setMuted NOTIFY mutedChanged) +/

public:
    /+ explicit +/this(QObject parent = null);
    /+ explicit +/this(ref const(QAudioDevice) device, QObject parent = null);
    ~this();

    final QAudioDevice device() const;
    final float volume() const;
    final bool isMuted() const;

public /+ Q_SLOTS +/:
    @QSlot final void setDevice(ref const(QAudioDevice) device);
    @QSlot final void setVolume(float volume);
    @QSlot final void setMuted(bool muted);

/+ Q_SIGNALS +/public:
    @QSignal final void deviceChanged();
    @QSignal final void volumeChanged(float volume);
    @QSignal final void mutedChanged(bool muted);

private:
    //final QPlatformAudioOutput* handle() const { return d; }
    /+ void setDisconnectFunction(std::function<void()> disconnectFunction); +/
    /+ friend class QMediaCaptureSession; +/
    /+ friend class QMediaPlayer; +/
    /+ Q_DISABLE_COPY(QAudioOutput) +/
    QPlatformAudioOutput* d = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

