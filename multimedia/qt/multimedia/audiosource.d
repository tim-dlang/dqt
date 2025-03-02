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
module qt.multimedia.audiosource;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.iodevice;
import qt.core.object;
import qt.helpers;
import qt.multimedia.audio;
import qt.multimedia.audiodevice;
import qt.multimedia.audioformat;

extern(C++, class) struct QPlatformAudioSource;

/// Binding for C++ class [QAudioSource](https://doc.qt.io/qt-6/qaudiosource.html).
class /+ Q_MULTIMEDIA_EXPORT +/ QAudioSource : QObject
{
    mixin(Q_OBJECT);

public:
    /+ explicit +/this(ref const(QAudioFormat) format = globalInitVar!QAudioFormat, QObject parent = null);
    /+ explicit +/this(ref const(QAudioDevice) audioDeviceInfo, ref const(QAudioFormat) format = globalInitVar!QAudioFormat, QObject parent = null);
    ~this();

    final bool isNull() const { return !d; }

    final QAudioFormat format() const;

    final void start(QIODevice device);
    final QIODevice start();

    final void stop();
    final void reset();
    final void suspend();
    final void resume();

    final void setBufferSize(qsizetype bytes);
    final qsizetype bufferSize() const;

    final qsizetype bytesAvailable() const;

    final void setVolume(qreal volume);
    final qreal volume() const;

    final qint64 processedUSecs() const;
    final qint64 elapsedUSecs() const;

    final /+ QAudio:: +/qt.multimedia.audio.Error error() const;
    final /+ QAudio:: +/qt.multimedia.audio.State state() const;

/+ Q_SIGNALS +/public:
    @QSignal final void stateChanged(/+ QAudio:: +/qt.multimedia.audio.State state);

private:
    /+ Q_DISABLE_COPY(QAudioSource) +/

    QPlatformAudioSource* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

