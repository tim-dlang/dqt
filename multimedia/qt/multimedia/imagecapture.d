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
module qt.multimedia.imagecapture;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.object;
import qt.core.size;
import qt.core.string;
import qt.gui.image;
import qt.helpers;
import qt.multimedia.camera;
import qt.multimedia.mediacapturesession;
import qt.multimedia.videoframe;

/+ class QMediaMetaData; +/


extern(C++, class) struct QImageEncoderSettings;

extern(C++, class) struct QImageCapturePrivate;
extern(C++, class) struct QPlatformImageCapture;
/// Binding for C++ class [QImageCapture](https://doc.qt.io/qt-6/qimagecapture.html).
class /+ Q_MULTIMEDIA_EXPORT +/ QImageCapture : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool readyForCapture READ isReadyForCapture NOTIFY readyForCaptureChanged)
    Q_PROPERTY(QMediaMetaData metaData READ metaData WRITE setMetaData NOTIFY metaDataChanged)
    Q_PROPERTY(Error error READ error NOTIFY errorChanged)
    Q_PROPERTY(QString errorString READ errorString NOTIFY errorChanged)
    Q_PROPERTY(FileFormat fileFormat READ fileFormat NOTIFY setFileFormat NOTIFY fileFormatChanged)
    Q_PROPERTY(Quality quality READ quality NOTIFY setQuality NOTIFY qualityChanged) +/
public:
    enum Error
    {
        NoError,
        NotReadyError,
        ResourceError,
        OutOfSpaceError,
        NotSupportedFeatureError,
        FormatError
    }
    /+ Q_ENUM(Error) +/

    enum Quality
    {
        VeryLowQuality,
        LowQuality,
        NormalQuality,
        HighQuality,
        VeryHighQuality
    }
    /+ Q_ENUM(Quality) +/

    enum FileFormat {
        UnspecifiedFormat,
        JPEG,
        PNG,
        WebP,
        Tiff,
        LastFileFormat = FileFormat.Tiff
    }
    /+ Q_ENUM(FileFormat) +/

    /+ explicit +/this(QObject parent = null);
    ~this();

    final bool isAvailable() const;

    final QMediaCaptureSession captureSession() const;

    final Error error() const;
    final QString errorString() const;

    final bool isReadyForCapture() const;

    final FileFormat fileFormat() const;
    final void setFileFormat(FileFormat format);

    static QList!(FileFormat) supportedFormats();
    static QString fileFormatName(FileFormat c);
    static QString fileFormatDescription(FileFormat c);

    final QSize resolution() const;
    final void setResolution(ref const(QSize) );
    final void setResolution(int width, int height);

    final Quality quality() const;
    final void setQuality(Quality quality);

    /+ QMediaMetaData metaData() const; +/
    /+ void setMetaData(const QMediaMetaData &metaData); +/
    /+ void addMetaData(const QMediaMetaData &metaData); +/

public /+ Q_SLOTS +/:
    @QSlot final int captureToFile(ref const(QString) location = globalInitVar!QString);
    @QSlot final int capture();

/+ Q_SIGNALS +/public:
    @QSignal final void errorChanged();
    @QSignal final void errorOccurred(int id, Error error, ref const(QString) errorString);

    @QSignal final void readyForCaptureChanged(bool ready);
    @QSignal final void metaDataChanged();

    @QSignal final void fileFormatChanged();
    @QSignal final void qualityChanged();
    @QSignal final void resolutionChanged();

    @QSignal final void imageExposed(int id);
    @QSignal final void imageCaptured(int id, ref const(QImage) preview);
    /+ void imageMetadataAvailable(int id, const QMediaMetaData &metaData); +/
    @QSignal final void imageAvailable(int id, ref const(QVideoFrame) frame);
    @QSignal final void imageSaved(int id, ref const(QString) fileName);

private:
    // This is here to flag an incompatibilities with Qt 5
    @disable this(QCamera );

    /+ friend class QMediaCaptureSession; +/
    final QPlatformImageCapture* platformImageCapture();
    final void setCaptureSession(QMediaCaptureSession session);
    QImageCapturePrivate* d_ptr;
    /+ Q_DISABLE_COPY(QImageCapture) +/
    /+ Q_DECLARE_PRIVATE(QImageCapture) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_error(int, int, const QString &)) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ Q_MEDIA_ENUM_DEBUG(QImageCapture, Error) +/

