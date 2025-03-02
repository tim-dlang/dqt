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
module qt.multimedia.audio;
extern(C++):

import qt.config;
import qt.helpers;

//QTM_SYNC_HEADER_EXPORT QAudio

// Class forward declaration required for QDoc bug
extern(C++, "QAudio")
{
    enum Error { NoError, OpenError, IOError, UnderrunError, FatalError }
    enum State { ActiveState, SuspendedState, StoppedState, IdleState }

    enum VolumeScale {
        LinearVolumeScale,
        CubicVolumeScale,
        LogarithmicVolumeScale,
        DecibelVolumeScale
    }

    /+ Q_MULTIMEDIA_EXPORT +/ float convertVolume(float volume, VolumeScale from, VolumeScale to);
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug dbg, QAudio::Error error);
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug dbg, QAudio::State state);
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug dbg, QAudio::VolumeScale role);
#endif +/

