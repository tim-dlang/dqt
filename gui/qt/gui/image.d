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
module qt.gui.image;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.bytearrayview;
import qt.core.global;
import qt.core.iodevice;
import qt.core.list;
import qt.core.metamacros;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.stringlist;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.color;
import qt.gui.colorspace;
import qt.gui.colortransform;
import qt.gui.paintdevice;
import qt.gui.paintengine;
import qt.gui.pixelformat;
import qt.gui.rgb;
import qt.gui.transform;
import qt.helpers;
version (Cygwin) {} else
version (Windows)
    import qt.gui.windowdefs_win;

/+ #if defined(Q_OS_DARWIN) || defined(Q_QDOC)
Q_FORWARD_DECLARE_MUTABLE_CG_TYPE(CGImage);
#endif +/




struct QImageData;

alias QImageCleanupFunction = ExternCPPFunc!(void function(void*));

/// Binding for C++ class [QImage](https://doc.qt.io/qt-6/qimage.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QImage
{
private:
    immutable void *vtbl;
    QPaintDeviceFakeInheritance baseQPaintDeviceInterface;

    public QPaintDevice paintDevice() return
    {
        return cast(QPaintDevice)&this;
    }

    alias PaintDeviceMetric = QPaintDevice.PaintDeviceMetric;

    mixin(Q_GADGET);
public:
    enum InvertMode { InvertRgb, InvertRgba }
    enum Format {
        Format_Invalid,
        Format_Mono,
        Format_MonoLSB,
        Format_Indexed8,
        Format_RGB32,
        Format_ARGB32,
        Format_ARGB32_Premultiplied,
        Format_RGB16,
        Format_ARGB8565_Premultiplied,
        Format_RGB666,
        Format_ARGB6666_Premultiplied,
        Format_RGB555,
        Format_ARGB8555_Premultiplied,
        Format_RGB888,
        Format_RGB444,
        Format_ARGB4444_Premultiplied,
        Format_RGBX8888,
        Format_RGBA8888,
        Format_RGBA8888_Premultiplied,
        Format_BGR30,
        Format_A2BGR30_Premultiplied,
        Format_RGB30,
        Format_A2RGB30_Premultiplied,
        Format_Alpha8,
        Format_Grayscale8,
        Format_RGBX64,
        Format_RGBA64,
        Format_RGBA64_Premultiplied,
        Format_Grayscale16,
        Format_BGR888,
        Format_RGBX16FPx4,
        Format_RGBA16FPx4,
        Format_RGBA16FPx4_Premultiplied,
        Format_RGBX32FPx4,
        Format_RGBA32FPx4,
        Format_RGBA32FPx4_Premultiplied,
/+ #ifndef Q_QDOC +/
        NImageFormats
/+ #endif +/
    }
    /+ Q_ENUM(Format) +/

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor()/+ noexcept+/;
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(ref const(QSize) size, Format format);
    this(int width, int height, Format format);
    this(uchar* data, int width, int height, Format format, QImageCleanupFunction cleanupFunction = null, void* cleanupInfo = null);
    this(const(uchar)* data, int width, int height, Format format, QImageCleanupFunction cleanupFunction = null, void* cleanupInfo = null);
    this(uchar* data, int width, int height, qsizetype bytesPerLine, Format format, QImageCleanupFunction cleanupFunction = null, void* cleanupInfo = null);
    this(const(uchar)* data, int width, int height, qsizetype bytesPerLine, Format format, QImageCleanupFunction cleanupFunction = null, void* cleanupInfo = null);

    version (QT_NO_IMAGEFORMAT_XPM) {} else
    {
        /+ explicit +/this(const(char**) xpm);
    }
    /+ explicit +/this(ref const(QString) fileName, const(char)* format = null);

    @disable this(this);
    this(ref const(QImage) );
    /+ QImage(QImage &&other) noexcept
        : QPaintDevice(), d(qExchange(other.d, nullptr))
    {} +/
    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    ~this();
    }));

    /+ref QImage operator =(ref const(QImage) );+/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QImage) +/
    /+ void swap(QImage &other) noexcept
    { qt_ptr_swap(d, other.d); } +/

    bool isNull() const;

    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    int devType() const;
    }));

    /+bool operator ==(ref const(QImage) ) const;+/
    /+bool operator !=(ref const(QImage) ) const;+/
    /+auto opCast(T : QVariant)() const;+/
    void detach();
    bool isDetached() const;

    /+ [[nodiscard]] QImage copy(const QRect &rect = QRect()) const; +/
    /+ [[nodiscard]] QImage copy(int x, int y, int w, int h) const
    { return copy(QRect(x, y, w, h)); } +/

    Format format() const;

    /+ [[nodiscard]] +/ QImage convertToFormat(Format f, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor) const/+ &+/
    { return convertToFormat_helper(f, flags); }
    /+ [[nodiscard]] QImage convertToFormat(Format f, Qt::ImageConversionFlags flags = Qt::AutoColor) &&
    {
        if (convertToFormat_inplace(f, flags))
            return std::move(*this);
        else
            return convertToFormat_helper(f, flags);
    } +/
    /+ [[nodiscard]] +/ QImage convertToFormat(Format f, ref const(QList!(QRgb)) colorTable,
                                             /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor) const;

    bool reinterpretAsFormat(Format f);
    /+ [[nodiscard]] +/ QImage convertedTo(Format f, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor) const/+ &+/
    { return convertToFormat(f, flags); }
    /+ [[nodiscard]] QImage convertedTo(Format f, Qt::ImageConversionFlags flags = Qt::AutoColor) &&
    { return convertToFormat(f, flags); } +/
    void convertTo(Format f, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);

    int width() const;
    int height() const;
    QSize size() const;
    QRect rect() const;

    int depth() const;
    int colorCount() const;
    int bitPlaneCount() const;

    QRgb color(int i) const;
    void setColor(int i, QRgb c);
    void setColorCount(int);

    bool allGray() const;
    bool isGrayscale() const;

    uchar* bits();
    const(uchar)* bits() const;
    const(uchar)* constBits() const;

    qsizetype sizeInBytes() const;

    uchar* scanLine(int);
    const(uchar)* scanLine(int) const;
    const(uchar)* constScanLine(int) const;
    qsizetype bytesPerLine() const;

    bool valid(int x, int y) const;
    pragma(inline, true) bool valid(ref const(QPoint) pt) const { return valid(pt.x(), pt.y()); }

    int pixelIndex(int x, int y) const;
    pragma(inline, true) int pixelIndex(ref const(QPoint) pt) const { return pixelIndex(pt.x(), pt.y());}

    QRgb pixel(int x, int y) const;
    pragma(inline, true) QRgb pixel(ref const(QPoint) pt) const { return pixel(pt.x(), pt.y()); }

    void setPixel(int x, int y, uint index_or_rgb);
    pragma(inline, true) void setPixel(ref const(QPoint) pt, uint index_or_rgb) { setPixel(pt.x(), pt.y(), index_or_rgb); }

    QColor pixelColor(int x, int y) const;
    pragma(inline, true) QColor pixelColor(ref const(QPoint) pt) const { return pixelColor(pt.x(), pt.y()); }

    void setPixelColor(int x, int y, ref const(QColor) c);
    pragma(inline, true) void setPixelColor(ref const(QPoint) pt, ref const(QColor) c) { setPixelColor(pt.x(), pt.y(), c); }

    QList!(QRgb) colorTable() const;
    void setColorTable(ref const(QList!(QRgb)) colors);

    qreal devicePixelRatio() const;
    void setDevicePixelRatio(qreal scaleFactor);
    QSizeF deviceIndependentSize() const;

    void fill(uint pixel);
    void fill(ref const(QColor) color);
    void fill(/+ Qt:: +/qt.core.namespace.GlobalColor color);


    bool hasAlphaChannel() const;
    void setAlphaChannel(ref const(QImage) alphaChannel);
    /+ [[nodiscard]] +/ QImage createAlphaMask(/+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor) const;
    version (QT_NO_IMAGE_HEURISTIC_MASK) {} else
    {
        /+ [[nodiscard]] +/ QImage createHeuristicMask(bool clipTight = true) const;
    }
    /+ [[nodiscard]] +/ QImage createMaskFromColor(QRgb color, /+ Qt:: +/qt.core.namespace.MaskMode mode = /+ Qt:: +/qt.core.namespace.MaskMode.MaskInColor) const;

    /+ [[nodiscard]] +/ QImage scaled(int w, int h, /+ Qt:: +/qt.core.namespace.AspectRatioMode aspectMode = /+ Qt:: +/qt.core.namespace.AspectRatioMode.IgnoreAspectRatio,
                                    /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const
    { auto tmp = QSize(w, h); return scaled(tmp, aspectMode, mode); }
    /+ [[nodiscard]] +/ QImage scaled(ref const(QSize) s, /+ Qt:: +/qt.core.namespace.AspectRatioMode aspectMode = /+ Qt:: +/qt.core.namespace.AspectRatioMode.IgnoreAspectRatio,
                                    /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    /+ [[nodiscard]] +/ QImage scaledToWidth(int w, /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    /+ [[nodiscard]] +/ QImage scaledToHeight(int h, /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    /+ [[nodiscard]] +/ QImage transformed(ref const(QTransform) matrix, /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    static QTransform trueMatrix(ref const(QTransform) , int w, int h);

    /+ [[nodiscard]] +/ QImage mirrored(bool horizontally = false, bool vertically = true) const/+ &+/
    { return mirrored_helper(horizontally, vertically); }
    /+ [[nodiscard]] QImage mirrored(bool horizontally = false, bool vertically = true) &&
    { mirrored_inplace(horizontally, vertically); return std::move(*this); } +/
    /+ [[nodiscard]] +/ QImage rgbSwapped() const/+ &+/
    { return rgbSwapped_helper(); }
    /+ [[nodiscard]] QImage rgbSwapped() &&
    { rgbSwapped_inplace(); return std::move(*this); } +/
    void mirror(bool horizontally = false, bool vertically = true)
    { mirrored_inplace(horizontally, vertically); }
    void rgbSwap()
    { rgbSwapped_inplace(); }
    void invertPixels(InvertMode /+ = InvertRgb +/);

    QColorSpace colorSpace() const;
    /+ [[nodiscard]] +/ QImage convertedToColorSpace(ref const(QColorSpace) ) const;
    void convertToColorSpace(ref const(QColorSpace) );
    void setColorSpace(ref const(QColorSpace) );

    void applyColorTransform(ref const(QColorTransform) transform);

    bool load(QIODevice device, const(char)* format);
    bool load(ref const(QString) fileName, const(char)* format = null);
    bool loadFromData(QByteArrayView data, const(char)* format = null);
    bool loadFromData(const(uchar)* buf, int len, const(char)* format = null); // ### Qt 7: qsizetype
    bool loadFromData(ref const(QByteArray) data, const(char)* format = null) // ### Qt 7: drop
    { return loadFromData(QByteArrayView(data), format); }

    bool save(ref const(QString) fileName, const(char)* format = null, int quality = -1) const;
    bool save(QIODevice device, const(char)* format = null, int quality = -1) const;

    static QImage fromData(QByteArrayView data, const(char)* format = null);
    static QImage fromData(const(uchar)* data, int size, const(char)* format = null); // ### Qt 7: qsizetype
    static QImage fromData(ref const(QByteArray) data, const(char)* format = null)  // ### Qt 7: drop
    { return fromData(QByteArrayView(data), format); }

    qint64 cacheKey() const;

    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    QPaintEngine paintEngine() const;
    }));

    // Auxiliary data
    int dotsPerMeterX() const;
    int dotsPerMeterY() const;
    void setDotsPerMeterX(int);
    void setDotsPerMeterY(int);
    QPoint offset() const;
    void setOffset(ref const(QPoint));

    QStringList textKeys() const;
    QString text(ref const(QString) key = globalInitVar!QString) const;
    void setText(ref const(QString) key, ref const(QString) value);

    QPixelFormat pixelFormat() const/+ noexcept+/;
    static QPixelFormat toPixelFormat(Format format)/+ noexcept+/;
    static Format toImageFormat(QPixelFormat format)/+ noexcept+/;

    // Platform specific conversion functions
/+ #if defined(Q_OS_DARWIN) || defined(Q_QDOC) +/
    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ CGImageRef toCGImage() const Q_DECL_CF_RETURNS_RETAINED; +/
    }
/+ #endif
#if defined(Q_OS_WIN) || defined(Q_QDOC) +/
    version (Cygwin) {} else
    version (Windows)
    {
        HBITMAP toHBITMAP() const;
        HICON toHICON(ref const(QImage) mask /+ = {} +/) const;
        static QImage fromHBITMAP(HBITMAP hbitmap);
        static QImage fromHICON(HICON icon);
    }
/+ #endif +/

protected:
    mixin(changeWindowsMangling(q{mangleChangeFunctionType("virtual")}, q{
    /+ virtual +/ int metric(PaintDeviceMetric metric) const;
    }));
    QImage mirrored_helper(bool horizontal, bool vertical) const;
    QImage rgbSwapped_helper() const;
    void mirrored_inplace(bool horizontal, bool vertical);
    void rgbSwapped_inplace();
    QImage convertToFormat_helper(Format format, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags) const;
    bool convertToFormat_inplace(Format format, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags);
    QImage smoothScaled(int w, int h) const;

private:
    QImageData* d;

    /+ friend class QRasterPlatformPixmap; +/
    /+ friend class QBlittablePlatformPixmap; +/
    /+ friend class QPixmapCacheEntry; +/
    /+ friend struct QImageData; +/

public:
    alias DataPtr = QImageData*;
    pragma(inline, true) ref DataPtr data_ptr() return { return d; }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QImage)

// Inline functions...

// QImage stream functions

#if !defined(QT_NO_DATASTREAM)
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QImage &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QImage &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QImage &);
#endif +/

