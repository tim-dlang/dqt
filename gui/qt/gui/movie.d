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
module qt.gui.movie;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.iodevice;
import qt.core.list;
import qt.core.object;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.gui.color;
import qt.gui.image;
import qt.gui.imagereader;
import qt.gui.pixmap;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(movie); +/



extern(C++, class) struct QMoviePrivate;
/// Binding for C++ class [QMovie](https://doc.qt.io/qt-5/qmovie.html).
class /+ Q_GUI_EXPORT +/ QMovie : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QMovie) +/
    /+ Q_PROPERTY(int speed READ speed WRITE setSpeed)
    Q_PROPERTY(CacheMode cacheMode READ cacheMode WRITE setCacheMode) +/
public:
    enum MovieState {
        NotRunning,
        Paused,
        Running
    }
    /+ Q_ENUM(MovieState) +/
    enum CacheMode {
        CacheNone,
        CacheAll
    }
    /+ Q_ENUM(CacheMode) +/

    /+ explicit +/this(QObject parent = null);
    /+ explicit +/this(QIODevice device, ref const(QByteArray) format = globalInitVar!QByteArray, QObject parent = null);
    /+ explicit +/this(ref const(QString) fileName, ref const(QByteArray) format = globalInitVar!QByteArray, QObject parent = null);
    ~this();

    static QList!(QByteArray) supportedFormats();

    final void setDevice(QIODevice device);
    final QIODevice device() const;

    final void setFileName(ref const(QString) fileName);
    final QString fileName() const;

    final void setFormat(ref const(QByteArray) format);
    final QByteArray format() const;

    final void setBackgroundColor(ref const(QColor) color);
    final QColor backgroundColor() const;

    final MovieState state() const;

    final QRect frameRect() const;
    final QImage currentImage() const;
    final QPixmap currentPixmap() const;

    final bool isValid() const;
    final QImageReader.ImageReaderError lastError() const;
    final QString lastErrorString() const;

    final bool jumpToFrame(int frameNumber);
    final int loopCount() const;
    final int frameCount() const;
    final int nextFrameDelay() const;
    final int currentFrameNumber() const;

    final int speed() const;

    final QSize scaledSize();
    final void setScaledSize(ref const(QSize) size);

    final CacheMode cacheMode() const;
    final void setCacheMode(CacheMode mode);

/+ Q_SIGNALS +/public:
    @QSignal final void started();
    @QSignal final void resized(ref const(QSize) size);
    @QSignal final void updated(ref const(QRect) rect);
    @QSignal final void stateChanged(MovieState state);
    @QSignal final void error(QImageReader.ImageReaderError error);
    @QSignal final void finished();
    @QSignal final void frameChanged(int frameNumber);

public /+ Q_SLOTS +/:
    @QSlot final void start();
    @QSlot final bool jumpToNextFrame();
    @QSlot final void setPaused(bool paused);
    @QSlot final void stop();
    @QSlot final void setSpeed(int percentSpeed);

private:
    /+ Q_DISABLE_COPY(QMovie) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_loadNextFrame()) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

