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
module qt.svg.renderer;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.namespace;
import qt.core.object;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.gui.painter;
import qt.gui.transform;
import qt.helpers;

/+ #ifndef QT_NO_SVGRENDERER +/



extern(C++, class) struct QSvgRendererPrivate;

/// Binding for C++ class [QSvgRenderer](https://doc.qt.io/qt-6/qsvgrenderer.html).
class /+ Q_SVG_EXPORT +/ QSvgRenderer : QObject
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QRectF viewBox READ viewBoxF WRITE setViewBox)
    Q_PROPERTY(int framesPerSecond READ framesPerSecond WRITE setFramesPerSecond)
    Q_PROPERTY(int currentFrame READ currentFrame WRITE setCurrentFrame)
    Q_PROPERTY(Qt::AspectRatioMode aspectRatioMode READ aspectRatioMode WRITE setAspectRatioMode) +/
public:
    this(QObject parent = null);
    this(ref const(QString) filename, QObject parent = null);
    this(ref const(QByteArray) contents, QObject parent = null);
    //this(QXmlStreamReader* contents, QObject parent = null);
    ~this();

    final bool isValid() const;

    final QSize defaultSize() const;

    final QRect viewBox() const;
    final QRectF viewBoxF() const;
    final void setViewBox(ref const(QRect) viewbox);
    final void setViewBox(ref const(QRectF) viewbox);

    final /+ Qt:: +/qt.core.namespace.AspectRatioMode aspectRatioMode() const;
    final void setAspectRatioMode(/+ Qt:: +/qt.core.namespace.AspectRatioMode mode);

    final bool animated() const;
    final int framesPerSecond() const;
    final void setFramesPerSecond(int num);
    final int currentFrame() const;
    final void setCurrentFrame(int);
    final int animationDuration() const;//in seconds

    final QRectF boundsOnElement(ref const(QString) id) const;
    final bool elementExists(ref const(QString) id) const;
    final QTransform transformForElement(ref const(QString) id) const;

public /+ Q_SLOTS +/:
    @QSlot final bool load(ref const(QString) filename);
    @QSlot final bool load(ref const(QByteArray) contents);
    //@QSlot final bool load(QXmlStreamReader* contents);
    @QSlot final void render(QPainter* p);
    @QSlot final void render(QPainter* p, ref const(QRectF) bounds);

    @QSlot final void render(QPainter* p, ref const(QString) elementId,
                    ref const(QRectF) bounds=globalInitVar!QRectF);

/+ Q_SIGNALS +/public:
    @QSignal final void repaintNeeded();

private:
    /+ Q_DECLARE_PRIVATE(QSvgRenderer) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ #endif +/ // QT_NO_SVGRENDERER

