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
module qt.multimedia.videosink;
extern(C++):

import qt.config;
import qt.core.object;
import qt.core.size;
import qt.core.string;
import qt.helpers;
import qt.multimedia.videoframe;


extern(C++, class) struct QVideoSinkPrivate;
extern(C++, class) struct QPlatformVideoSink;

/// Binding for C++ class [QVideoSink](https://doc.qt.io/qt-6/qvideosink.html).
class /+ Q_MULTIMEDIA_EXPORT +/ QVideoSink : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QString subtitleText READ subtitleText WRITE setSubtitleText NOTIFY subtitleTextChanged)
    Q_PROPERTY(QSize videoSize READ videoSize NOTIFY videoSizeChanged) +/
public:
    this(QObject parent = null);
    ~this();

    final QRhi* rhi() const;
    final void setRhi(QRhi* rhi);

    final QSize videoSize() const;

    final QString subtitleText() const;
    final void setSubtitleText(ref const(QString) subtitle);

    final void setVideoFrame(ref const(QVideoFrame) frame);
    final QVideoFrame videoFrame() const;

    final QPlatformVideoSink* platformVideoSink() const;
/+ Q_SIGNALS +/public:
    @QSignal final void videoFrameChanged(ref const(QVideoFrame) frame) const;
    @QSignal final void subtitleTextChanged(ref const(QString) subtitleText) const;

    @QSignal final void videoSizeChanged();

private:
    /+ friend class QMediaPlayerPrivate; +/
    /+ friend class QMediaCaptureSessionPrivate; +/
    final void setSource(QObject source);

    QVideoSinkPrivate* d = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

