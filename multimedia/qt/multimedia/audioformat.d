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
module qt.multimedia.audioformat;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.metatype;
import qt.helpers;

extern(C++, class) struct QAudioFormatPrivate;

extern(C++, "QtPrivate") {
int channelConfig(Args...)(Args values) {
    int r = 0;
    static foreach (v; values)
        r |= 1u << v;
    return r;
}
}

/// Binding for C++ class [QAudioFormat](https://doc.qt.io/qt-6/qaudioformat.html).
@Q_DECLARE_METATYPE extern(C++, class) struct QAudioFormat
{
public:
    enum SampleFormat : quint16 {
        Unknown,
        UInt8,
        Int16,
        Int32,
        Float,
        NSampleFormats
    }

    // This matches the speaker positions of a 22.2 audio layout. Stereo, Surround 5.1 and Surround 7.1 are subsets of these
    enum AudioChannelPosition {
        UnknownPosition,
        FrontLeft,
        FrontRight,
        FrontCenter,
        LFE,
        BackLeft,
        BackRight,
        FrontLeftOfCenter,
        FrontRightOfCenter,
        BackCenter,
        SideLeft,
        SideRight,
        TopCenter,
        TopFrontLeft,
        TopFrontCenter,
        TopFrontRight,
        TopBackLeft,
        TopBackCenter,
        TopBackRight,
        LFE2,
        TopSideLeft,
        TopSideRight,
        BottomFrontCenter,
        BottomFrontLeft,
        BottomFrontRight
    }
    extern(D) static immutable int NChannelPositions = AudioChannelPosition.BottomFrontRight + 1;

    enum ChannelConfig : quint32 {
        ChannelConfigUnknown = 0,
        ChannelConfigMono = /+ QtPrivate:: +/channelConfig(AudioChannelPosition.FrontCenter),
        ChannelConfigStereo = /+ QtPrivate:: +/channelConfig(AudioChannelPosition.FrontLeft, AudioChannelPosition.FrontRight),
        ChannelConfig2Dot1 = /+ QtPrivate:: +/channelConfig(AudioChannelPosition.FrontLeft, AudioChannelPosition.FrontRight, AudioChannelPosition.LFE),
        ChannelConfig3Dot0 = /+ QtPrivate:: +/channelConfig(AudioChannelPosition.FrontLeft, AudioChannelPosition.FrontRight, AudioChannelPosition.FrontCenter),
        ChannelConfig3Dot1 = /+ QtPrivate:: +/channelConfig(AudioChannelPosition.FrontLeft, AudioChannelPosition.FrontRight, AudioChannelPosition.FrontCenter, AudioChannelPosition.LFE),
        ChannelConfigSurround5Dot0 = /+ QtPrivate:: +/channelConfig(AudioChannelPosition.FrontLeft, AudioChannelPosition.FrontRight, AudioChannelPosition.FrontCenter, AudioChannelPosition.BackLeft, AudioChannelPosition.BackRight),
        ChannelConfigSurround5Dot1 = /+ QtPrivate:: +/channelConfig(AudioChannelPosition.FrontLeft, AudioChannelPosition.FrontRight, AudioChannelPosition.FrontCenter, AudioChannelPosition.LFE, AudioChannelPosition.BackLeft, AudioChannelPosition.BackRight),
        ChannelConfigSurround7Dot0 = /+ QtPrivate:: +/channelConfig(AudioChannelPosition.FrontLeft, AudioChannelPosition.FrontRight, AudioChannelPosition.FrontCenter, AudioChannelPosition.BackLeft, AudioChannelPosition.BackRight, AudioChannelPosition.SideLeft, AudioChannelPosition.SideRight),
        ChannelConfigSurround7Dot1 = /+ QtPrivate:: +/channelConfig(AudioChannelPosition.FrontLeft, AudioChannelPosition.FrontRight, AudioChannelPosition.FrontCenter, AudioChannelPosition.LFE, AudioChannelPosition.BackLeft, AudioChannelPosition.BackRight, AudioChannelPosition.SideLeft, AudioChannelPosition.SideRight),
    }

    /+ template <typename... Args> +/
    static ChannelConfig channelConfig(Args...)(Args channels)
    {
        return cast(ChannelConfig) (/+ QtPrivate:: +/.channelConfig(channels));
    }

    bool isValid() const/+ noexcept+/
    {
        return m_sampleRate > 0 && m_channelCount > 0 && m_sampleFormat != SampleFormat.Unknown;
    }

    void setSampleRate(int sampleRate)/+ noexcept+/ { m_sampleRate = sampleRate; }
    int sampleRate() const/+ noexcept+/ { return m_sampleRate; }

    /+ Q_MULTIMEDIA_EXPORT +/ void setChannelConfig(ChannelConfig config)/+ noexcept+/;
    ChannelConfig channelConfig() const/+ noexcept+/ { return m_channelConfig; }

    void setChannelCount(int channelCount)/+ noexcept+/ { m_channelConfig = ChannelConfig.ChannelConfigUnknown; m_channelCount = cast(short) (channelCount); }
    int channelCount() const/+ noexcept+/ { return m_channelCount; }

    /+ Q_MULTIMEDIA_EXPORT +/ int channelOffset(AudioChannelPosition channel) const/+ noexcept+/;

    void setSampleFormat(SampleFormat f)/+ noexcept+/ { m_sampleFormat = f; }
    SampleFormat sampleFormat() const/+ noexcept+/ { return m_sampleFormat; }

    // Helper functions
    /+ Q_MULTIMEDIA_EXPORT +/ qint32 bytesForDuration(qint64 microseconds) const;
    /+ Q_MULTIMEDIA_EXPORT +/ qint64 durationForBytes(qint32 byteCount) const;

    /+ Q_MULTIMEDIA_EXPORT +/ qint32 bytesForFrames(qint32 frameCount) const;
    /+ Q_MULTIMEDIA_EXPORT +/ qint32 framesForBytes(qint32 byteCount) const;

    /+ Q_MULTIMEDIA_EXPORT +/ qint32 framesForDuration(qint64 microseconds) const;
    /+ Q_MULTIMEDIA_EXPORT +/ qint64 durationForFrames(qint32 frameCount) const;

    int bytesPerFrame() const { return bytesPerSample()*channelCount(); }
    int bytesPerSample() const/+ noexcept+/
    {
        switch (m_sampleFormat) {
        case SampleFormat.Unknown:
        case SampleFormat.NSampleFormats: return 0;
        case SampleFormat.UInt8: return 1;
        case SampleFormat.Int16: return 2;
        case SampleFormat.Int32:
        case SampleFormat.Float: return 4;default:

        }
        return 0;
    }

    /+ Q_MULTIMEDIA_EXPORT +/ float normalizedSampleValue(const(void)* sample) const;

    /+ friend bool operator==(const QAudioFormat &a, const QAudioFormat &b)
    {
        return a.m_sampleRate == b.m_sampleRate &&
               a.m_channelCount == b.m_channelCount &&
               a.m_sampleFormat == b.m_sampleFormat;
    } +/
    /+ friend bool operator!=(const QAudioFormat &a, const QAudioFormat &b)
    {
        return !(a == b);
    } +/

    /+ Q_MULTIMEDIA_EXPORT +/ static ChannelConfig defaultChannelConfigForChannelCount(int channelCount);

private:
    SampleFormat m_sampleFormat = SampleFormat.Unknown;
    short m_channelCount = 0;
    ChannelConfig m_channelConfig = ChannelConfig.ChannelConfigUnknown;
    int m_sampleRate = 0;
    quint64 reserved = 0;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug, const QAudioFormat &);
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug, QAudioFormat::SampleFormat);
#endif


Q_DECLARE_METATYPE(QAudioFormat) +/

