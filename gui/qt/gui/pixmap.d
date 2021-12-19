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
module qt.gui.pixmap;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.global;
import qt.core.iodevice;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.rect;
import qt.core.shareddata;
import qt.core.size;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.bitmap;
import qt.gui.color;
import qt.gui.image;
import qt.gui.imagereader;
import qt.gui.imagewriter;
import qt.gui.matrix;
import qt.gui.paintdevice;
import qt.gui.paintengine;
import qt.gui.region;
import qt.gui.transform;
import qt.gui.windowdefs;
import qt.helpers;

/+ class QImageWriter;
class QImageReader;
class QColor;
class QVariant; +/
extern(C++, class) struct QPlatformPixmap;

/// Binding for C++ class [QPixmap](https://doc.qt.io/qt-5/qpixmap.html).
@Q_MOVABLE_TYPE @(QMetaType.Type.QPixmap) extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPixmap
{
private:
    immutable void *vtbl;
    QPaintDeviceFakeInheritance baseQPaintDeviceInterface;

    public QPaintDevice paintDevice() return
    {
        return cast(QPaintDevice)&this;
    }

    alias PaintDeviceMetric = QPaintDevice.PaintDeviceMetric;

public:
    import qt.core.namespace;
    @disable this();
    /+this();+/

    /+ explicit +/this(QPlatformPixmap* data);
    this(int w, int h);
    /+ explicit +/this(ref const(QSize) );
    this(ref const(QString) fileName, const(char)* format = null, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);
    version(QT_NO_IMAGEFORMAT_XPM){}else
    {
        /+ explicit +/this(const(char)* /+ const +/ /+[0]+/* xpm);
    }
    @disable this(this);
    this(ref const(QPixmap) );
    mixin(mangleWindows("??1QPixmap@@UEAA@XZ", q{
    ~this();
    }));
    /+ref QPixmap operator =(ref const(QPixmap) );+/
    /+ inline QPixmap &operator=(QPixmap &&other) noexcept
    { qSwap(data, other.data); return *this; } +/
    /+ inline void swap(QPixmap &other) noexcept
    { qSwap(data, other.data); } +/

    /+auto opCast(T : QVariant)() const;+/

    bool isNull() const;
    int devType() const;

    int width() const;
    int height() const;
    QSize size() const;
    QRect rect() const;
    int depth() const;

    static int defaultDepth();

    void fill(ref const(QColor) fillColor /+ = Qt::white +/);
/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use QPainter or fill(QColor)") +/
        void fill(const(QPaintDevice) device, ref const(QPoint) ofs);
    /+ QT_DEPRECATED_X("Use QPainter or fill(QColor)") +/
        void fill(const(QPaintDevice) device, int xofs, int yofs);
/+ #endif +/

    QBitmap mask() const;
    void setMask(ref const(QBitmap) );

    qreal devicePixelRatio() const;
    void setDevicePixelRatio(qreal scaleFactor);

    bool hasAlpha() const;
    bool hasAlphaChannel() const;

    version(QT_NO_IMAGE_HEURISTIC_MASK){}else
    {
        QBitmap createHeuristicMask(bool clipTight = true) const;
    }
    QBitmap createMaskFromColor(ref const(QColor) maskColor, /+ Qt:: +/qt.core.namespace.MaskMode mode = /+ Qt:: +/qt.core.namespace.MaskMode.MaskInColor) const;

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use QScreen::grabWindow() instead") +/
        static QPixmap grabWindow(WId, int x = 0, int y = 0, int w = -1, int h = -1);
    /+ QT_DEPRECATED_X("Use QWidget::grab() instead") +/
        static QPixmap grabWidget(QObject widget, ref const(QRect) rect);
    /+ QT_DEPRECATED_X("Use QWidget::grab() instead") +/
        static QPixmap grabWidget(QObject widget, int x = 0, int y = 0, int w = -1, int h = -1);
/+ #endif +/

    pragma(inline, true) QPixmap scaled(int w, int h, /+ Qt:: +/qt.core.namespace.AspectRatioMode aspectMode = /+ Qt:: +/qt.core.namespace.AspectRatioMode.IgnoreAspectRatio,
                              /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const
        { auto tmp = QSize(w, h); return scaled(tmp, aspectMode, mode); }
    QPixmap scaled(ref const(QSize) s, /+ Qt:: +/qt.core.namespace.AspectRatioMode aspectMode = /+ Qt:: +/qt.core.namespace.AspectRatioMode.IgnoreAspectRatio,
                       /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    QPixmap scaledToWidth(int w, /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    QPixmap scaledToHeight(int h, /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+ QT_DEPRECATED_X("Use transformed(const QTransform &, Qt::TransformationMode mode)") +/
        QPixmap transformed(ref const(QMatrix) , /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    /+ QT_DEPRECATED_X("Use trueMatrix(const QTransform &m, int w, int h)") +/
        static QMatrix trueMatrix(ref const(QMatrix) m, int w, int h);
/+ #endif +/ // QT_DEPRECATED_SINCE(5, 15)
    QPixmap transformed(ref const(QTransform) , /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    static QTransform trueMatrix(ref const(QTransform) m, int w, int h);

    QImage toImage() const;
    static QPixmap fromImage(ref const(QImage) image, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);
    static QPixmap fromImageReader(QImageReader* imageReader, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);
    /+ static QPixmap fromImage(QImage &&image, Qt::ImageConversionFlags flags = Qt::AutoColor)
    {
        return fromImageInPlace(image, flags);
    } +/

    bool load(ref const(QString) fileName, const(char)* format = null, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);
    bool loadFromData(const(uchar)* buf, uint len, const(char)* format = null, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);
/+    pragma(inline, true) bool loadFromData(ref const(QByteArray) buf, const(char)* format = null, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor)
    {
        return loadFromData(reinterpret_cast!(const(uchar)*)(buf.constData()), buf.size(), format, flags);
    }+/
    bool save(ref const(QString) fileName, const(char)* format = null, int quality = -1) const;
    bool save(QIODevice device, const(char)* format = null, int quality = -1) const;

    bool convertFromImage(ref const(QImage) img, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);

    /+ inline QPixmap copy(int x, int y, int width, int height) const; +/
    /+ QPixmap copy(const QRect &rect = QRect()) const; +/

    pragma(inline, true) void scroll(int dx, int dy, int ax, int ay, int awidth, int aheight, QRegion* exposed = null)
    {
        auto tmp = QRect(ax, ay, awidth, aheight); scroll(dx, dy, tmp, exposed);
    }
    void scroll(int dx, int dy, ref const(QRect) rect, QRegion* exposed = null);

/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED inline int serialNumber() const { return cacheKey() >> 32; }
#endif +/
    qint64 cacheKey() const;

    bool isDetached() const;
    void detach();

    bool isQBitmap() const;

    QPaintEngine paintEngine() const;

    /+pragma(inline, true) bool operator !() const { return isNull(); }+/

/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED inline QPixmap alphaChannel() const;
    QT_DEPRECATED inline void setAlphaChannel(const QPixmap &);
#endif +/

protected:
    int metric(PaintDeviceMetric) const;
    static QPixmap fromImageInPlace(ref QImage image, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);

private:
    QExplicitlySharedDataPointer!(QPlatformPixmap) data;

    bool doImageIO(QImageWriter* io, int quality) const;

    this(ref const(QSize) s, int type);
    void doInit(int, int, int);
    /+ Q_DUMMY_COMPARISON_OPERATOR(QPixmap) +/
    /+ friend class QPlatformPixmap; +/
    /+ friend class QBitmap; +/
    /+ friend class QPaintDevice; +/
    /+ friend class QPainter; +/
    /+ friend class QOpenGLWidget; +/
    /+ friend class QWidgetPrivate; +/
    /+ friend class QRasterBuffer; +/
    version(QT_NO_DATASTREAM){}else
    {
        /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QPixmap &); +/
    }

public:
    QPlatformPixmap* handle() const;

public:
    alias DataPtr = QExplicitlySharedDataPointer!(QPlatformPixmap);
    pragma(inline, true) ref DataPtr data_ptr() return { return data; }
}

/+ Q_DECLARE_SHARED(QPixmap)

inline QPixmap QPixmap::copy(int ax, int ay, int awidth, int aheight) const
{
    return copy(QRect(ax, ay, awidth, aheight));
}

#if QT_DEPRECATED_SINCE(5, 0)
inline QPixmap QPixmap::alphaChannel() const
{
    QT_WARNING_PUSH
    QT_WARNING_DISABLE_DEPRECATED
    return QPixmap::fromImage(toImage().alphaChannel());
    QT_WARNING_POP
}

inline void QPixmap::setAlphaChannel(const QPixmap &p)
{
    QImage image = toImage();
    image.setAlphaChannel(p.toImage());
    *this = QPixmap::fromImage(image);

}
#endif

/*****************************************************************************
 QPixmap stream functions
*****************************************************************************/

#if !defined(QT_NO_DATASTREAM)
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QPixmap &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QPixmap &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QPixmap &);
#endif +/

