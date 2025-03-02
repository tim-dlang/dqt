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
module qt.multimedia.videowidget;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.size;
import qt.gui.event;
import qt.helpers;
import qt.multimedia.videosink;
import qt.widgets.widget;


extern(C++, class) struct QVideoWidgetPrivate;
/// Binding for C++ class [QVideoWidget](https://doc.qt.io/qt-6/qvideowidget.html).
class /+ Q_MULTIMEDIAWIDGETS_EXPORT +/ QVideoWidget : QWidget
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool fullScreen READ isFullScreen WRITE setFullScreen NOTIFY fullScreenChanged)
    Q_PROPERTY(Qt::AspectRatioMode aspectRatioMode READ aspectRatioMode WRITE setAspectRatioMode NOTIFY aspectRatioModeChanged) +/

public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    @QInvokable final QVideoSink videoSink() const;

/+ #ifdef Q_QDOC
    bool isFullScreen() const;
#endif +/

    final /+ Qt:: +/qt.core.namespace.AspectRatioMode aspectRatioMode() const;

    override QSize sizeHint() const;

public /+ Q_SLOTS +/:
    @QSlot final void setFullScreen(bool fullScreen);
    @QSlot final void setAspectRatioMode(/+ Qt:: +/qt.core.namespace.AspectRatioMode mode);

/+ Q_SIGNALS +/public:
    @QSignal final void fullScreenChanged(bool fullScreen);
    @QSignal final void aspectRatioModeChanged(/+ Qt:: +/qt.core.namespace.AspectRatioMode mode);

protected:
    override bool event(QEvent event);
    override void showEvent(QShowEvent event);
    override void hideEvent(QHideEvent event);
    override void resizeEvent(QResizeEvent event);
    override void moveEvent(QMoveEvent event);
    QVideoWidgetPrivate* d_ptr;

private:
    /+ Q_DECLARE_PRIVATE(QVideoWidget) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

