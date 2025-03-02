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
module qt.multimedia.mediacapturesession;
extern(C++):

import qt.config;
import qt.core.object;
import qt.helpers;
import qt.multimedia.audioinput;
import qt.multimedia.audiooutput;
import qt.multimedia.camera;
import qt.multimedia.imagecapture;
import qt.multimedia.mediarecorder;
import qt.multimedia.videosink;


extern(C++, class) struct QMediaCaptureSessionPrivate;
/// Binding for C++ class [QMediaCaptureSession](https://doc.qt.io/qt-6/qmediacapturesession.html).
class /+ Q_MULTIMEDIA_EXPORT +/ QMediaCaptureSession : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QAudioInput *audioInput READ audioInput WRITE setAudioInput NOTIFY audioInputChanged)
    Q_PROPERTY(QAudioOutput *audioOutput READ audioOutput WRITE setAudioOutput NOTIFY audioOutputChanged)
    Q_PROPERTY(QCamera *camera READ camera WRITE setCamera NOTIFY cameraChanged)
    Q_PROPERTY(QImageCapture *imageCapture READ imageCapture WRITE setImageCapture NOTIFY imageCaptureChanged)
    Q_PROPERTY(QMediaRecorder *recorder READ recorder WRITE setRecorder NOTIFY recorderChanged)
    Q_PROPERTY(QObject *videoOutput READ videoOutput WRITE setVideoOutput NOTIFY videoOutputChanged) +/
public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    final QAudioInput audioInput() const;
    final void setAudioInput(QAudioInput input);

    final QCamera camera() const;
    final void setCamera(QCamera camera);

    final QImageCapture imageCapture();
    final void setImageCapture(QImageCapture imageCapture);

    final QMediaRecorder recorder();
    final void setRecorder(QMediaRecorder recorder);

    final void setVideoOutput(QObject output);
    final QObject videoOutput() const;

    final void setVideoSink(QVideoSink sink);
    final QVideoSink videoSink() const;

    final void setAudioOutput(QAudioOutput output);
    final QAudioOutput audioOutput() const;

    final QPlatformMediaCaptureSession* platformSession() const;

/+ Q_SIGNALS +/public:
    @QSignal final void audioInputChanged();
    @QSignal final void cameraChanged();
    @QSignal final void imageCaptureChanged();
    @QSignal final void recorderChanged();
    @QSignal final void videoOutputChanged();
    @QSignal final void audioOutputChanged();

private:
    QMediaCaptureSessionPrivate* d_ptr;
    /+ Q_DISABLE_COPY(QMediaCaptureSession) +/
    /+ Q_DECLARE_PRIVATE(QMediaCaptureSession) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

