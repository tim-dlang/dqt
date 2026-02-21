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
module qt.multimedia.audiobuffer;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.global;
import qt.core.metatype;
import qt.core.shareddata;
import qt.helpers;
import qt.multimedia.audioformat;

extern(C++, "QtPrivate") {
/*struct AudioSampleFormatHelper(/+ QAudioFormat::SampleFormat +/)
{
}*/

struct AudioSampleFormatHelper(QAudioFormat.SampleFormat format) if (format == QAudioFormat.SampleFormat.UInt8)
{
    alias value_type = ubyte;
    enum value_type Default = 128;
}

struct AudioSampleFormatHelper(QAudioFormat.SampleFormat format) if (format == QAudioFormat.SampleFormat.Int16)
{
    alias value_type = short;
    enum value_type Default = 0;
}

struct AudioSampleFormatHelper(QAudioFormat.SampleFormat format) if (format == QAudioFormat.SampleFormat.Int32)
{
    alias value_type = int;
    enum value_type Default = 0;
}

struct AudioSampleFormatHelper(QAudioFormat.SampleFormat format) if (format == QAudioFormat.SampleFormat.Float)
{
    alias value_type = float;
    enum value_type Default = 0.;
}

}

struct QAudioFrame(QAudioFormat.ChannelConfig config, QAudioFormat.SampleFormat format)
{
private:
    // popcount in qalgorithms.h is unfortunately not constexpr on MSVC.
    // Use this here as a fallback
    static int constexprPopcount(quint32 i)
    {
        i = i - ((i >> 1) & 0x55555555);        // add pairs of bits
        i = (i & 0x33333333) + ((i >> 2) & 0x33333333);  // quads
        i = (i + (i >> 4)) & 0x0F0F0F0F;        // groups of 8
        return (i * 0x01010101) >> 24;          // horizontal sum of bytes
    }
    extern(D) static immutable int nChannels = constexprPopcount(config);
public:
    alias value_type = /+ QtPrivate:: +/AudioSampleFormatHelper!(format).value_type;
    value_type[nChannels] channels;
    static int positionToIndex(QAudioFormat.AudioChannelPosition pos)
    {
        import qt.core.algorithms;

        if (!(config & (1u << pos)))
            return -1;

        uint maskedChannels = config & ((1u << pos) - 1);
        return qPopulationCount(maskedChannels);
    }


    value_type value(QAudioFormat.AudioChannelPosition pos) const {
        int idx = positionToIndex(pos);
        if (idx < 0)
            return /+ QtPrivate:: +/AudioSampleFormatHelper!(format).Default;
        return channels[idx];
    }
    void setValue(QAudioFormat.AudioChannelPosition pos, value_type val) {
        int idx = positionToIndex(pos);
        if (idx < 0)
            return;
        channels[idx] = val;
    }
    value_type opIndex(QAudioFormat.AudioChannelPosition pos) const {
        return value(pos);
    }
    void clear() {
        for (int i = 0; i < nChannels; ++i)
            channels[i] = /+ QtPrivate:: +/AudioSampleFormatHelper!(format).Default;
    }
}

alias QAudioFrameMono(QAudioFormat.SampleFormat Format) = QAudioFrame!(QAudioFormat.ChannelConfig.ChannelConfigMono, Format);

alias QAudioFrameStereo(QAudioFormat.SampleFormat Format) = QAudioFrame!(QAudioFormat.ChannelConfig.ChannelConfigStereo, Format);

alias QAudioFrame2Dot1(QAudioFormat.SampleFormat Format) = QAudioFrame!(QAudioFormat.ChannelConfig.ChannelConfig2Dot1, Format);

alias QAudioFrameSurround5Dot1(QAudioFormat.SampleFormat Format) = QAudioFrame!(QAudioFormat.ChannelConfig.ChannelConfigSurround5Dot1, Format);

alias QAudioFrameSurround7Dot1(QAudioFormat.SampleFormat Format) = QAudioFrame!(QAudioFormat.ChannelConfig.ChannelConfigSurround7Dot1, Format);


extern(C++, class) struct QAudioBufferPrivate;
/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QAudioBufferPrivate, Q_MULTIMEDIA_EXPORT) +/
/// Binding for C++ class [QAudioBuffer](https://doc.qt.io/qt-6/qaudiobuffer.html).
@Q_DECLARE_METATYPE extern(C++, class) struct /+ Q_MULTIMEDIA_EXPORT +/ QAudioBuffer
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor() nothrow;
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QAudioBuffer) other) nothrow;
    this(ref const(QByteArray) data, ref const(QAudioFormat) format, qint64 startTime = -1);
    this(int numFrames, ref const(QAudioFormat) format, qint64 startTime = -1); // Initialized to empty
    ~this();

    ref QAudioBuffer opAssign(ref const(QAudioBuffer) other);

    /+ QAudioBuffer(QAudioBuffer &&other) noexcept = default; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QAudioBuffer) +/
    /+ void swap(QAudioBuffer &other) noexcept
    { d.swap(other.d); } +/

    bool isValid() const nothrow { return d.get() !is null; }

    void detach();

    QAudioFormat format() const nothrow;

    qsizetype frameCount() const nothrow;
    qsizetype sampleCount() const nothrow;
    qsizetype byteCount() const nothrow;

    qint64 duration() const nothrow;
    qint64 startTime() const nothrow;

    // Structures for easier access to data
    alias U8M = QAudioFrameMono!(QAudioFormat.SampleFormat.UInt8);
    alias S16M = QAudioFrameMono!(QAudioFormat.SampleFormat.Int16);
    alias S32M = QAudioFrameMono!(QAudioFormat.SampleFormat.Int32);
    alias F32M = QAudioFrameMono!(QAudioFormat.SampleFormat.Float);

    alias U8S = QAudioFrameStereo!(QAudioFormat.SampleFormat.UInt8);
    alias S16S = QAudioFrameStereo!(QAudioFormat.SampleFormat.Int16);
    alias S32S = QAudioFrameStereo!(QAudioFormat.SampleFormat.Int32);
    alias F32S = QAudioFrameStereo!(QAudioFormat.SampleFormat.Float);

    /+ template <typename T> +/ const(T)* constData(T)() const {
        return static_cast!(const(T)*)(constData());
    }
    /+ template <typename T> +/ const(T)* data(T)() const {
        return static_cast!(const(T)*)(data());
    }
    /+ template <typename T> +/ T* data(T)() {
        return static_cast!(T*)(data());
    }
private:
    const(void)* constData() const nothrow;
    const(void)* data() const nothrow;
    void* data();

    QExplicitlySharedDataPointer!(QAudioBufferPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ Q_DECLARE_METATYPE(QAudioBuffer) +/

