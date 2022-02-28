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
module qt.gui.imagereader;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.coreapplication;
import qt.core.iodevice;
import qt.core.list;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.stringlist;
import qt.gui.color;
import qt.gui.image;
import qt.gui.imageiohandler;
import qt.helpers;


extern(C++, class) struct QImageReaderPrivate;
/// Binding for C++ class [QImageReader](https://doc.qt.io/qt-6/qimagereader.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QImageReader
{
    mixin(Q_DECLARE_TR_FUNCTIONS(q{QImageReader}));
public:
    enum ImageReaderError {
        UnknownError,
        FileNotFoundError,
        DeviceError,
        UnsupportedFormatError,
        InvalidDataError
    }

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ explicit +/this(QIODevice device, ref const(QByteArray) format = globalInitVar!QByteArray);
    /+ explicit +/this(ref const(QString) fileName, ref const(QByteArray) format = globalInitVar!QByteArray);
    ~this();

    void setFormat(ref const(QByteArray) format);
    QByteArray format() const;

    void setAutoDetectImageFormat(bool enabled);
    bool autoDetectImageFormat() const;

    void setDecideFormatFromContent(bool ignored);
    bool decideFormatFromContent() const;

    void setDevice(QIODevice device);
    QIODevice device() const;

    void setFileName(ref const(QString) fileName);
    QString fileName() const;

    QSize size() const;

    QImage.Format imageFormat() const;

    QStringList textKeys() const;
    QString text(ref const(QString) key) const;

    void setClipRect(ref const(QRect) rect);
    QRect clipRect() const;

    void setScaledSize(ref const(QSize) size);
    QSize scaledSize() const;

    void setQuality(int quality);
    int quality() const;

    void setScaledClipRect(ref const(QRect) rect);
    QRect scaledClipRect() const;

    void setBackgroundColor(ref const(QColor) color);
    QColor backgroundColor() const;

    bool supportsAnimation() const;

    QImageIOHandler.Transformations transformation() const;

    void setAutoTransform(bool enabled);
    bool autoTransform() const;

    QByteArray subType() const;
    QList!(QByteArray) supportedSubTypes() const;

    bool canRead() const;
    QImage read();
    bool read(QImage* image);

    bool jumpToNextImage();
    bool jumpToImage(int imageNumber);
    int loopCount() const;
    int imageCount() const;
    int nextImageDelay() const;
    int currentImageNumber() const;
    QRect currentImageRect() const;

    ImageReaderError error() const;
    QString errorString() const;

    bool supportsOption(QImageIOHandler.ImageOption option) const;

    static QByteArray imageFormat(ref const(QString) fileName);
    static QByteArray imageFormat(QIODevice device);
    static QList!(QByteArray) supportedImageFormats();
    static QList!(QByteArray) supportedMimeTypes();
    static QList!(QByteArray) imageFormatsForMimeType(ref const(QByteArray) mimeType);
    static int allocationLimit();
    static void setAllocationLimit(int mbLimit);

private:
    /+ Q_DISABLE_COPY(QImageReader) +/
@disable this(this);
/+this(ref const(QImageReader));+//+ref QImageReader operator =(ref const(QImageReader));+/    QImageReaderPrivate* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

