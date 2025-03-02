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
module qt.multimedia.mediadevices;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.object;
import qt.helpers;
import qt.multimedia.audiodevice;
import qt.multimedia.cameradevice;


extern(C++, class) struct QMediaDevicesPrivate;

/// Binding for C++ class [QMediaDevices](https://doc.qt.io/qt-6/qmediadevices.html).
class /+ Q_MULTIMEDIA_EXPORT +/ QMediaDevices : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QList<QAudioDevice> audioInputs READ audioInputs NOTIFY audioInputsChanged)
    Q_PROPERTY(QList<QAudioDevice> audioOutputs READ audioOutputs NOTIFY audioOutputsChanged)
    Q_PROPERTY(QList<QCameraDevice> videoInputs READ videoInputs NOTIFY videoInputsChanged)
    Q_PROPERTY(QAudioDevice defaultAudioInput READ defaultAudioInput NOTIFY audioInputsChanged)
    Q_PROPERTY(QAudioDevice defaultAudioOutput READ defaultAudioOutput NOTIFY audioOutputsChanged)
    Q_PROPERTY(QCameraDevice defaultVideoInput READ defaultVideoInput NOTIFY videoInputsChanged) +/

public:
    this(QObject parent = null);
    ~this();

    static QList!(QAudioDevice) audioInputs();
    static QList!(QAudioDevice) audioOutputs();
    static QList!(QCameraDevice) videoInputs();

    static QAudioDevice defaultAudioInput();
    static QAudioDevice defaultAudioOutput();
    static QCameraDevice defaultVideoInput();

/+ Q_SIGNALS +/public:
    @QSignal final void audioInputsChanged();
    @QSignal final void audioOutputsChanged();
    @QSignal final void videoInputsChanged();

private:
    /+ friend class QMediaDevicesPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

