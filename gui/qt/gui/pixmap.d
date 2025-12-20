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
import qt.core.namespace;
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
import qt.gui.paintdevice;
import qt.gui.paintengine;
import qt.gui.region;
import qt.gui.transform;
import qt.helpers;

extern(C++, class) struct QPlatformPixmap;
/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QPlatformPixmap, Q_GUI_EXPORT) +/
/// Binding for C++ class [QPixmap](https://doc.qt.io/qt-6/qpixmap.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPixmap
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
    version (QT_NO_IMAGEFORMAT_XPM) {} else
    {
        /+ explicit +/this(const(char**) xpm);
    }
    @disable this(this);
    this(ref const(QPixmap) );
    /+ QPixmap(QPixmap &&other) noexcept : QPaintDevice(), data(std::move(other.data)) {} +/
    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    ~this();
    }));

    /+ref QPixmap operator =(ref const(QPixmap) );+/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QPixmap) +/
    /+ inline void swap(QPixmap &other) noexcept
    { data.swap(other.data); } +/
    /+@disable bool operator ==(ref const(QPixmap) ) const;+/
    /+@disable bool operator !=(ref const(QPixmap) ) const;+/

    /+auto opCast(T : QVariant)() const;+/

    bool isNull() const;
    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    int devType() const;
    }));

    int width() const;
    int height() const;
    QSize size() const;
    QRect rect() const;
    int depth() const;

    static int defaultDepth();

    void fill(ref const(QColor) fillColor /+ = Qt::white +/);

    QBitmap mask() const;
    void setMask(ref const(QBitmap) );

    qreal devicePixelRatio() const;
    void setDevicePixelRatio(qreal scaleFactor);
    QSizeF deviceIndependentSize() const;

    bool hasAlpha() const;
    bool hasAlphaChannel() const;

    version (QT_NO_IMAGE_HEURISTIC_MASK) {} else
    {
        QBitmap createHeuristicMask(bool clipTight = true) const;
    }
    QBitmap createMaskFromColor(ref const(QColor) maskColor, /+ Qt:: +/qt.core.namespace.MaskMode mode = /+ Qt:: +/qt.core.namespace.MaskMode.MaskInColor) const;

    pragma(inline, true) QPixmap scaled(int w, int h, /+ Qt:: +/qt.core.namespace.AspectRatioMode aspectMode = /+ Qt:: +/qt.core.namespace.AspectRatioMode.IgnoreAspectRatio,
                              /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const
        { auto tmp = QSize(w, h); return scaled(tmp, aspectMode, mode); }
    QPixmap scaled(ref const(QSize) s, /+ Qt:: +/qt.core.namespace.AspectRatioMode aspectMode = /+ Qt:: +/qt.core.namespace.AspectRatioMode.IgnoreAspectRatio,
                       /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    QPixmap scaledToWidth(int w, /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    QPixmap scaledToHeight(int h, /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
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

    qint64 cacheKey() const;

    bool isDetached() const;
    void detach();

    bool isQBitmap() const;

    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    QPaintEngine paintEngine() const;
    }));

    /+pragma(inline, true) bool operator !() const { return isNull(); }+/

protected:
    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    int metric(PaintDeviceMetric) const;
    }));
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
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QPixmap &); +/
    }

public:
    QPlatformPixmap* handle() const;

public:
    alias DataPtr = QExplicitlySharedDataPointer!(QPlatformPixmap);
    pragma(inline, true) ref DataPtr data_ptr() return { return data; }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QPixmap)

inline QPixmap QPixmap::copy(int ax, int ay, int awidth, int aheight) const
{
    return copy(QRect(ax, ay, awidth, aheight));
}


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

