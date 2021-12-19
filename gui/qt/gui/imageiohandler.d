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
module qt.gui.imageiohandler;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.flags;
import qt.core.iodevice;
import qt.core.rect;
import qt.core.scopedpointer;
import qt.core.variant;
import qt.gui.image;
import qt.helpers;
static if(!defined!"QT_NO_IMAGEFORMATPLUGIN")
    import qt.core.object;


extern(C++, class) struct QImageIOHandlerPrivate;
/// Binding for C++ class [QImageIOHandler](https://doc.qt.io/qt-5/qimageiohandler.html).
class /+ Q_GUI_EXPORT +/ QImageIOHandler
{
private:
    /+ Q_DECLARE_PRIVATE(QImageIOHandler) +/
public:
    this();
    /+ virtual +/~this();

    final void setDevice(QIODevice device);
    final QIODevice device() const;

    final void setFormat(ref const(QByteArray) format);
    final void setFormat(ref const(QByteArray) format) const;
    final QByteArray format() const;

    /+ QT_DEPRECATED_X("Use QImageIOHandler::format() instead") +/
        /+ virtual +/ QByteArray name() const;

    /+ virtual +/ abstract bool canRead() const;
    /+ virtual +/ abstract bool read(QImage* image);
    /+ virtual +/ bool write(ref const(QImage) image);

    enum ImageOption {
        Size,
        ClipRect,
        Description,
        ScaledClipRect,
        ScaledSize,
        CompressionRatio,
        Gamma,
        Quality,
        Name,
        SubType,
        IncrementalReading,
        Endianness,
        Animation,
        BackgroundColor,
        ImageFormat,
        SupportedSubTypes,
        OptimizedWrite,
        ProgressiveScanWrite,
        ImageTransformation
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
        , TransformedByDefault
/+ #endif +/
    }

    enum Transformation {
        TransformationNone = 0,
        TransformationMirror = 1,
        TransformationFlip = 2,
        TransformationRotate180 = Transformation.TransformationMirror | Transformation.TransformationFlip,
        TransformationRotate90 = 4,
        TransformationMirrorAndRotate90 = Transformation.TransformationMirror | Transformation.TransformationRotate90,
        TransformationFlipAndRotate90 = Transformation.TransformationFlip | Transformation.TransformationRotate90,
        TransformationRotate270 = Transformation.TransformationRotate180 | Transformation.TransformationRotate90
    }
    /+ Q_DECLARE_FLAGS(Transformations, Transformation) +/
alias Transformations = QFlags!(Transformation);
    /+ virtual +/ QVariant option(ImageOption option) const;
    /+ virtual +/ void setOption(ImageOption option, ref const(QVariant) value);
    /+ virtual +/ bool supportsOption(ImageOption option) const;

    // incremental loading
    /+ virtual +/ bool jumpToNextImage();
    /+ virtual +/ bool jumpToImage(int imageNumber);
    /+ virtual +/ int loopCount() const;
    /+ virtual +/ int imageCount() const;
    /+ virtual +/ int nextImageDelay() const;
    /+ virtual +/ int currentImageNumber() const;
    /+ virtual +/ QRect currentImageRect() const;

protected:
    this(ref QImageIOHandlerPrivate dd);
    QScopedPointer!(QImageIOHandlerPrivate) d_ptr;
private:
    /+ Q_DISABLE_COPY(QImageIOHandler) +/
}

static if(!defined!"QT_NO_IMAGEFORMATPLUGIN")
{

/+ #define QImageIOHandlerFactoryInterface_iid "org.qt-project.Qt.QImageIOHandlerFactoryInterface" +/

/// Binding for C++ class [QImageIOPlugin](https://doc.qt.io/qt-5/qimageioplugin.html).
class /+ Q_GUI_EXPORT +/ QImageIOPlugin : QObject
{
    mixin(Q_OBJECT);
public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    enum Capability {
        CanRead = 0x1,
        CanWrite = 0x2,
        CanReadIncremental = 0x4
    }
    /+ Q_DECLARE_FLAGS(Capabilities, Capability) +/
alias Capabilities = QFlags!(Capability);
    /+ virtual +/ abstract Capabilities capabilities(QIODevice device, ref const(QByteArray) format) const;
    /+ virtual +/ abstract QImageIOHandler create(QIODevice device, ref const(QByteArray) format = globalInitVar!QByteArray) const;
}
/+pragma(inline, true) QFlags!(QImageIOPlugin.Capabilities.enum_type) operator |(QImageIOPlugin.Capabilities.enum_type f1, QImageIOPlugin.Capabilities.enum_type f2)/+noexcept+/{return QFlags!(QImageIOPlugin.Capabilities.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QImageIOPlugin.Capabilities.enum_type) operator |(QImageIOPlugin.Capabilities.enum_type f1, QFlags!(QImageIOPlugin.Capabilities.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QImageIOPlugin.Capabilities.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QImageIOPlugin::Capabilities) +/
}

