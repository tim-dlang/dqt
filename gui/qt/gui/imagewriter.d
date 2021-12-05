/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.gui.imagewriter;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.coreapplication;
import qt.core.iodevice;
import qt.core.list;
import qt.core.string;
import qt.gui.image;
import qt.gui.imageiohandler;
import qt.helpers;

/+ class QIODevice;
class QImage; +/

extern(C++, class) struct QImageWriterPrivate;
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QImageWriter
{
    /+ Q_DECLARE_TR_FUNCTIONS(QImageWriter) +/
public:pragma(inline, true) static QString tr(const(char)* sourceText, const(char)* disambiguation=null, int n=-1){return QCoreApplication.translate("QImageWriter",sourceText,disambiguation,n);} mixin(QT_DECLARE_DEPRECATED_TR_FUNCTIONS(q{QImageWriter}));private:public:
    enum ImageWriterError {
        UnknownError,
        DeviceError,
        UnsupportedFormatError,
        InvalidImageError
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

    /+ explicit +/this(QIODevice device, ref const(QByteArray) format);
    /+ explicit +/this(ref const(QString) fileName, ref const(QByteArray) format = globalInitVar!QByteArray);
    ~this();

    void setFormat(ref const(QByteArray) format);
    QByteArray format() const;

    void setDevice(QIODevice device);
    QIODevice device() const;

    void setFileName(ref const(QString) fileName);
    QString fileName() const;

    void setQuality(int quality);
    int quality() const;

    void setCompression(int compression);
    int compression() const;

/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+ QT_DEPRECATED_VERSION_X_5_15("Use QColorSpace instead") +/
        void setGamma(float gamma);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use QColorSpace instead") +/
        float gamma() const;
/+ #endif +/

    void setSubType(ref const(QByteArray) type);
    QByteArray subType() const;
    QList!(QByteArray) supportedSubTypes() const;

    void setOptimizedWrite(bool optimize);
    bool optimizedWrite() const;

    void setProgressiveScanWrite(bool progressive);
    bool progressiveScanWrite() const;

    QImageIOHandler.Transformations transformation() const;
    void setTransformation(QImageIOHandler.Transformations orientation);

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use QImageWriter::setText() instead") +/
        void setDescription(ref const(QString) description);
    /+ QT_DEPRECATED_X("Use QImageReader::text() instead") +/
        QString description() const;
/+ #endif +/

    void setText(ref const(QString) key, ref const(QString) text);

    bool canWrite() const;
    bool write(ref const(QImage) image);

    ImageWriterError error() const;
    QString errorString() const;

    bool supportsOption(QImageIOHandler.ImageOption option) const;

    static QList!(QByteArray) supportedImageFormats();
    static QList!(QByteArray) supportedMimeTypes();
    static QList!(QByteArray) imageFormatsForMimeType(ref const(QByteArray) mimeType);

private:
    /+ Q_DISABLE_COPY(QImageWriter) +/
@disable this(this);
/+this(ref const(QImageWriter));+//+ref QImageWriter operator =(ref const(QImageWriter));+/    QImageWriterPrivate* d;
}

