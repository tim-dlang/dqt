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
module qt.multimedia.wavedecoder;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.iodevice;
import qt.core.object;
import qt.helpers;
import qt.multimedia.audioformat;

class /+ Q_MULTIMEDIA_EXPORT +/ QWaveDecoder : QIODevice
{
    mixin(Q_OBJECT);

public:
    /+ explicit +/this(QIODevice device, QObject parent = null);
    /+ explicit +/this(QIODevice device, ref const(QAudioFormat) format,
                            QObject parent = null);
    ~this();

    final QAudioFormat audioFormat() const;
    final QIODevice getDevice();
    final int duration() const;
    static qint64 headerLength();

    override bool open(QIODevice.OpenMode mode);
    override void close();
    override bool seek(qint64 pos);
    override qint64 pos() const;
    //final void setIODevice(QIODevice device);
    override qint64 size() const;
    override bool isSequential() const;
    override qint64 bytesAvailable() const;

/+ Q_SIGNALS +/public:
    @QSignal final void formatKnown();
    @QSignal final void parsingError();

private /+ Q_SLOTS +/:
    @QSlot final void handleData();

private:
    mixin(changeWindowsMangling(q{mangleChangeAccess("private")}, q{
    protected override qint64 readData(char* data, qint64 maxlen);
    }));
    mixin(changeWindowsMangling(q{mangleChangeAccess("private")}, q{
    protected override qint64 writeData(const(char)* data, qint64 len);
    }));

    final bool writeHeader();
    final bool writeDataLength();
    final bool enoughDataAvailable();
    final bool findChunk(const(char)* chunkId);
    final void discardBytes(qint64 numBytes);
    final void parsingFailed();

    enum State {
        InitialState,
        WaitingForFormatState,
        WaitingForDataState
    }

    struct chunk
    {
        char[4]        id;
        quint32     size;
    }
    final bool peekChunk(chunk* pChunk, bool handleEndianness = true);

    struct RIFFHeader
    {
        chunk       descriptor;
        char[4]        type;
    }
    struct WAVEHeader
    {
        chunk       descriptor;
        quint16     audioFormat;
        quint16     numChannels;
        quint32     sampleRate;
        quint32     byteRate;
        quint16     blockAlign;
        quint16     bitsPerSample;
    }

    struct DATAHeader
    {
        chunk       descriptor;
    }

    struct CombinedHeader
    {
        RIFFHeader  riff;
        WAVEHeader  wave;
        DATAHeader  data;
    }
    extern(D) static __gshared const(int) HeaderLength = CombinedHeader.sizeof;

    bool haveFormat = false;
    bool haveHeader = false;
    qint64 dataSize = 0;
    QIODevice device = null;
    QAudioFormat format;
    State state = State.InitialState;
    quint32 junkToSkip = 0;
    bool bigEndian = false;
    bool byteSwap = false;
    int bps = 0;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

