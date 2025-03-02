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
module qt.multimedia.audiodecoder;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.iodevice;
import qt.core.object;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.multimedia.audiobuffer;
import qt.multimedia.audioformat;

extern(C++, class) struct QPlatformAudioDecoder;
/// Binding for C++ class [QAudioDecoder](https://doc.qt.io/qt-6/qaudiodecoder.html).
class /+ Q_MULTIMEDIA_EXPORT +/ QAudioDecoder : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QUrl source READ source WRITE setSource NOTIFY sourceChanged)
    Q_PROPERTY(bool isDecoding READ isDecoding NOTIFY isDecodingChanged)
    Q_PROPERTY(QString error READ errorString)
    Q_PROPERTY(bool bufferAvailable READ bufferAvailable NOTIFY bufferAvailableChanged) +/

public:
    enum Error
    {
        NoError,
        ResourceError,
        FormatError,
        AccessDeniedError,
        NotSupportedError
    }
    /+ Q_ENUM(Error) +/

    /+ explicit +/this(QObject parent = null);
    ~this();

    final bool isSupported() const;
    final bool isDecoding() const;

    final QUrl source() const;
    final void setSource(ref const(QUrl) fileName);

    final QIODevice sourceDevice() const;
    final void setSourceDevice(QIODevice device);

    final QAudioFormat audioFormat() const;
    final void setAudioFormat(ref const(QAudioFormat) format);

    final Error error() const;
    final QString errorString() const;

    final QAudioBuffer read() const;
    final bool bufferAvailable() const;

    final qint64 position() const;
    final qint64 duration() const;

public /+ Q_SLOTS +/:
    @QSlot final void start();
    @QSlot final void stop();

/+ Q_SIGNALS +/public:
    @QSignal final void bufferAvailableChanged(bool);
    @QSignal final void bufferReady();
    @QSignal final void finished();
    @QSignal final void isDecodingChanged(bool);

    @QSignal final void formatChanged(ref const(QAudioFormat) format);

    @QSignal final void error(Error error);

    @QSignal final void sourceChanged();

    @QSignal final void positionChanged(qint64 position);
    @QSignal final void durationChanged(qint64 duration);

private:
    /+ Q_DISABLE_COPY(QAudioDecoder) +/
    QPlatformAudioDecoder* decoder = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ Q_MEDIA_ENUM_DEBUG(QAudioDecoder, Error) +/

