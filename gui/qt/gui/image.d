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
import qt.core.global;
import qt.core.iodevice;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.objectdefs;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.stringlist;
import qt.core.typeinfo;
import qt.core.variant;
import qt.core.vector;
import qt.gui.color;
import qt.gui.colorspace;
import qt.gui.colortransform;
import qt.gui.matrix;
import qt.gui.paintdevice;
import qt.gui.paintengine;
import qt.gui.pixelformat;
import qt.gui.rgb;
import qt.gui.transform;
import qt.helpers;

/+ #if QT_DEPRECATED_SINCE(5, 0)
#endif

#if defined(Q_OS_DARWIN) || defined(Q_QDOC)
Q_FORWARD_DECLARE_MUTABLE_CG_TYPE(CGImage);
#endif



class QColorSpace;
class QColorTransform;
class QIODevice;
class QMatrix;
class QStringList;
class QTransform;
class QVariant;
template <class T> class QList;
template <class T> class QVector; +/

struct QImageData;
extern(C++, class) struct QImageDataMisc; // internal
/+ #if QT_DEPRECATED_SINCE(5, 0)
class QImageTextKeyLang {
public:
    QT_DEPRECATED QImageTextKeyLang(const char* k, const char* l) : key(k), lang(l) { }
    QT_DEPRECATED QImageTextKeyLang() { }

    QByteArray key;
    QByteArray lang;

    bool operator< (const QImageTextKeyLang& other) const
        { return key < other.key || (key==other.key && lang < other.lang); }
    bool operator== (const QImageTextKeyLang& other) const
        { return key==other.key && lang==other.lang; }
    inline bool operator!= (const QImageTextKeyLang &other) const
        { return !operator==(other); }
private:
    friend class QImage;
    QImageTextKeyLang(bool /*dummy*/) {}
};
#endif +/

alias QImageCleanupFunction = ExternCPPFunc!(void function(void*));

/// Binding for C++ class [QImage](https://doc.qt.io/qt-5/qimage.html).
@Q_MOVABLE_TYPE @(QMetaType.Type.QImage) extern(C++, class) struct /+ Q_GUI_EXPORT +/ QImage
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
    this(uchar* data, int width, int height, int bytesPerLine, Format format, QImageCleanupFunction cleanupFunction = null, void* cleanupInfo = null);
    this(const(uchar)* data, int width, int height, int bytesPerLine, Format format, QImageCleanupFunction cleanupFunction = null, void* cleanupInfo = null);

    version(QT_NO_IMAGEFORMAT_XPM){}else
    {
        /+ explicit +/this(const(char)* /+ const +/ /+[0]+/* xpm);
    }
    /+ explicit +/this(ref const(QString) fileName, const(char)* format = null);

    @disable this(this);
    this(ref const(QImage) );
    /+ inline QImage(QImage &&other) noexcept
        : QPaintDevice(), d(nullptr)
    { qSwap(d, other.d); } +/
    mixin(mangleWindows("??1QImage@@UEAA@XZ", q{
    ~this();
    }));

    /+ref QImage operator =(ref const(QImage) );+/
    /+ inline QImage &operator=(QImage &&other) noexcept
    { qSwap(d, other.d); return *this; } +/
    /+ inline void swap(QImage &other) noexcept
    { qSwap(d, other.d); } +/

    bool isNull() const;

    int devType() const;

    /+bool operator ==(ref const(QImage) ) const;+/
    /+bool operator !=(ref const(QImage) ) const;+/
    /+auto opCast(T : QVariant)() const;+/
    void detach();
    bool isDetached() const;

    /+ QImage copy(const QRect &rect = QRect()) const; +/
    /+ inline QImage copy(int x, int y, int w, int h) const
        { return copy(QRect(x, y, w, h)); } +/

    Format format() const;

/+    static if((!versionIsSet!("QT_COMPILING_QIMAGE_COMPAT_CPP") && defined!"Q_COMPILER_REF_QUALIFIERS"))
    {
        /+ Q_REQUIRED_RESULT +/ /+ Q_ALWAYS_INLINE +/ pragma(inline, true) QImage convertToFormat(Format f, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor) const/+ &+/
        { return convertToFormat_helper(f, flags); }
        /+ Q_REQUIRED_RESULT +/ /+ Q_ALWAYS_INLINE +/ pragma(inline, true) QImage convertToFormat(Format f, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor)/+ &&+/
        {
            if (convertToFormat_inplace(f, flags))
                return cast(QImage)(/+ std:: +/move(this));
            else
                return convertToFormat_helper(f, flags);
        }
    }
    else
    {
        /+ Q_REQUIRED_RESULT +/ QImage convertToFormat(Format f, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor) const;
    }
+/
    /+ Q_REQUIRED_RESULT +/ QImage convertToFormat(Format f, ref const(QVector!(QRgb)) colorTable, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor) const;
    bool reinterpretAsFormat(Format f);

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

/+ #if QT_DEPRECATED_SINCE(5, 10) +/
    /+ QT_DEPRECATED_X("Use sizeInBytes") +/ int byteCount() const;
/+ #endif +/
    qsizetype sizeInBytes() const;

    uchar* scanLine(int);
    const(uchar)* scanLine(int) const;
    const(uchar)* constScanLine(int) const;
/+ #if QT_VERSION >= QT_VERSION_CHECK(6,0,0)
    qsizetype bytesPerLine() const;
#else +/
    int bytesPerLine() const;
/+ #endif +/

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

    QVector!(QRgb) colorTable() const;
/+ #if QT_VERSION >= QT_VERSION_CHECK(6,0,0)
    void setColorTable(const QVector<QRgb> &colors);
#else +/
    void setColorTable(const(QVector!(QRgb)) colors);
/+ #endif +/

    qreal devicePixelRatio() const;
    void setDevicePixelRatio(qreal scaleFactor);

    void fill(uint pixel);
    void fill(ref const(QColor) color);
    void fill(/+ Qt:: +/qt.core.namespace.GlobalColor color);


    bool hasAlphaChannel() const;
    void setAlphaChannel(ref const(QImage) alphaChannel);
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+ QT_DEPRECATED_X("Use convertToFormat(QImage::Format_Alpha8)") +/
        QImage alphaChannel() const;
/+ #endif +/
    QImage createAlphaMask(/+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor) const;
    version(QT_NO_IMAGE_HEURISTIC_MASK){}else
    {
        QImage createHeuristicMask(bool clipTight = true) const;
    }
    QImage createMaskFromColor(QRgb color, /+ Qt:: +/qt.core.namespace.MaskMode mode = /+ Qt:: +/qt.core.namespace.MaskMode.MaskInColor) const;

    pragma(inline, true) QImage scaled(int w, int h, /+ Qt:: +/qt.core.namespace.AspectRatioMode aspectMode = /+ Qt:: +/qt.core.namespace.AspectRatioMode.IgnoreAspectRatio,
                            /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const
        { auto tmp = QSize(w, h); return scaled(tmp, aspectMode, mode); }
    QImage scaled(ref const(QSize) s, /+ Qt:: +/qt.core.namespace.AspectRatioMode aspectMode = /+ Qt:: +/qt.core.namespace.AspectRatioMode.IgnoreAspectRatio,
                     /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    QImage scaledToWidth(int w, /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    QImage scaledToHeight(int h, /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+ QT_DEPRECATED_X("Use transformed(const QTransform &matrix, Qt::TransformationMode mode)") +/
        QImage transformed(ref const(QMatrix) matrix, /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    /+ QT_DEPRECATED_X("trueMatrix(const QTransform &, int w, int h)") +/
        static QMatrix trueMatrix(ref const(QMatrix) , int w, int h);
/+ #endif +/ // QT_DEPRECATED_SINCE(5, 15)
    QImage transformed(ref const(QTransform) matrix, /+ Qt:: +/qt.core.namespace.TransformationMode mode = /+ Qt:: +/qt.core.namespace.TransformationMode.FastTransformation) const;
    static QTransform trueMatrix(ref const(QTransform) , int w, int h);
    static if((!versionIsSet!("QT_COMPILING_QIMAGE_COMPAT_CPP") && defined!"Q_COMPILER_REF_QUALIFIERS"))
    {
        QImage mirrored(bool horizontally = false, bool vertically = true) const/+ &+/
            { return mirrored_helper(horizontally, vertically); }
        /+ QImage &&mirrored(bool horizontally = false, bool vertically = true) &&
            { mirrored_inplace(horizontally, vertically); return std::move(*this); } +/
        QImage rgbSwapped() const/+ &+/
            { return rgbSwapped_helper(); }
        /+ QImage &&rgbSwapped() &&
            { rgbSwapped_inplace(); return std::move(*this); } +/
    }
    else
    {
        QImage mirrored(bool horizontally = false, bool vertically = true) const;
        QImage rgbSwapped() const;
    }
    void invertPixels(InvertMode /+ = InvertRgb +/);

    QColorSpace colorSpace() const;
    QImage convertedToColorSpace(ref const(QColorSpace) ) const;
    void convertToColorSpace(ref const(QColorSpace) );
    void setColorSpace(ref const(QColorSpace) );

    void applyColorTransform(ref const(QColorTransform) transform);

    bool load(QIODevice device, const(char)* format);
    bool load(ref const(QString) fileName, const(char)* format = null);
    bool loadFromData(const(uchar)* buf, int len, const(char)* format = null);
    pragma(inline, true) bool loadFromData(ref const(QByteArray) data, const(char)* aformat = null)
        { return loadFromData(reinterpret_cast!(const(uchar)*)(data.constData()), data.size(), aformat); }

    bool save(ref const(QString) fileName, const(char)* format = null, int quality = -1) const;
    bool save(QIODevice device, const(char)* format = null, int quality = -1) const;

    static QImage fromData(const(uchar)* data, int size, const(char)* format = null);
    pragma(inline, true) static QImage fromData(ref const(QByteArray) data, const(char)* format = null)
        { return fromData(reinterpret_cast!(const(uchar)*)(data.constData()), data.size(), format); }

/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED inline int serialNumber() const { return cacheKey() >> 32; }
#endif +/
    qint64 cacheKey() const;

    QPaintEngine paintEngine() const;

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
    static QPixelFormat toPixelFormat(QImage.Format format)/+ noexcept+/;
    static QImage.Format toImageFormat(QPixelFormat format)/+ noexcept+/;

    // Platform specific conversion functions
/+ #if defined(Q_OS_DARWIN) || defined(Q_QDOC) +/
    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ CGImageRef toCGImage() const Q_DECL_CF_RETURNS_RETAINED; +/
    }
/+ #endif

#if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED inline QString text(const char *key, const char *lang = nullptr) const;
    QT_DEPRECATED inline QList<QImageTextKeyLang> textList() const;
    QT_DEPRECATED inline QStringList textLanguages() const;
    QT_DEPRECATED inline QString text(const QImageTextKeyLang&) const;
    QT_DEPRECATED inline void setText(const char* key, const char* lang, const QString&);
#endif

#if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED inline int numColors() const;
    QT_DEPRECATED inline void setNumColors(int);
    QT_DEPRECATED inline int numBytes() const;
#endif +/

protected:
    /+ virtual +/ int metric(PaintDeviceMetric metric) const;
    QImage mirrored_helper(bool horizontal, bool vertical) const;
    QImage rgbSwapped_helper() const;
    void mirrored_inplace(bool horizontal, bool vertical);
    void rgbSwapped_inplace();
    QImage convertToFormat_helper(Format format, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags) const;
    bool convertToFormat_inplace(Format format, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags);
    QImage smoothScaled(int w, int h) const;

private:
    /+ friend class QWSOnScreenSurface; +/
    QImageData* d;

    /+ friend class QRasterPlatformPixmap; +/
    /+ friend class QBlittablePlatformPixmap; +/
    /+ friend class QPixmapCacheEntry; +/
    /+ friend struct QImageData; +/

public:
    alias DataPtr = QImageData*;
    pragma(inline, true) ref DataPtr data_ptr() return { return d; }
}

/+ Q_DECLARE_SHARED(QImage)

// Inline functions...

#if QT_DEPRECATED_SINCE(5, 0)

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED

inline QString QImage::text(const char* key, const char* lang) const
{
    if (!d)
        return QString();
    QString k = QString::fromLatin1(key);
    if (lang && *lang)
        k += QLatin1Char('/') + QString::fromLatin1(lang);
    return text(k);
}

inline QList<QImageTextKeyLang> QImage::textList() const
{
    QList<QImageTextKeyLang> imageTextKeys;
    if (!d)
        return imageTextKeys;
    QStringList keys = textKeys();
    for (int i = 0; i < keys.size(); ++i) {
        int index = keys.at(i).indexOf(QLatin1Char('/'));
        if (index > 0) {
            QImageTextKeyLang tkl(true);
            tkl.key = keys.at(i).left(index).toLatin1();
            tkl.lang = keys.at(i).mid(index+1).toLatin1();
            imageTextKeys += tkl;
        }
    }

    return imageTextKeys;
}

inline QStringList QImage::textLanguages() const
{
    if (!d)
        return QStringList();
    QStringList keys = textKeys();
    QStringList languages;
    for (int i = 0; i < keys.size(); ++i) {
        int index = keys.at(i).indexOf(QLatin1Char('/'));
        if (index > 0)
            languages += keys.at(i).mid(index+1);
    }

    return languages;
}

inline QString QImage::text(const QImageTextKeyLang&kl) const
{
    if (!d)
        return QString();
    QString k = QString::fromLatin1(kl.key.constData());
    if (!kl.lang.isEmpty())
        k += QLatin1Char('/') + QString::fromLatin1(kl.lang.constData());
    return text(k);
}

inline void QImage::setText(const char* key, const char* lang, const QString &s)
{
    if (!d)
        return;
    detach();

    // In case detach() ran out of memory
    if (!d)
        return;

    QString k = QString::fromLatin1(key);
    if (lang && *lang)
        k += QLatin1Char('/') + QString::fromLatin1(lang);
    setText(k, s);
}

QT_WARNING_POP

inline int QImage::numColors() const
{
    return colorCount();
}

inline void QImage::setNumColors(int n)
{
    setColorCount(n);
}

inline int QImage::numBytes() const
{
    return int(sizeInBytes());
}
#endif

// QImage stream functions

#if !defined(QT_NO_DATASTREAM)
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QImage &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QImage &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QImage &);
#endif +/

