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
module qt.multimedia.camera;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.object;
import qt.core.point;
import qt.core.string;
import qt.helpers;
import qt.multimedia.cameradevice;
import qt.multimedia.mediacapturesession;

extern(C++, class) struct QPlatformMediaCaptureSession;

extern(C++, class) struct QCameraPrivate;
extern(C++, class) struct QPlatformCamera;
/// Binding for C++ class [QCamera](https://doc.qt.io/qt-6/qcamera.html).
class /+ Q_MULTIMEDIA_EXPORT +/ QCamera : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool active READ isActive WRITE setActive NOTIFY activeChanged)
    // Qt 7: rename to device
    Q_PROPERTY(QCameraDevice cameraDevice READ cameraDevice WRITE setCameraDevice NOTIFY cameraDeviceChanged)
    Q_PROPERTY(Error error READ error NOTIFY errorChanged)
    Q_PROPERTY(QString errorString READ errorString NOTIFY errorChanged)
    Q_PROPERTY(QCameraFormat cameraFormat READ cameraFormat WRITE setCameraFormat NOTIFY cameraFormatChanged)

    Q_PROPERTY(FocusMode focusMode READ focusMode WRITE setFocusMode)
    Q_PROPERTY(QPointF focusPoint READ focusPoint NOTIFY focusPointChanged)
    Q_PROPERTY(QPointF customFocusPoint READ customFocusPoint WRITE setCustomFocusPoint NOTIFY customFocusPointChanged)
    Q_PROPERTY(float focusDistance READ focusDistance WRITE setFocusDistance NOTIFY focusDistanceChanged)

    Q_PROPERTY(float minimumZoomFactor READ minimumZoomFactor NOTIFY minimumZoomFactorChanged)
    Q_PROPERTY(float maximumZoomFactor READ maximumZoomFactor NOTIFY maximumZoomFactorChanged)
    Q_PROPERTY(float zoomFactor READ zoomFactor WRITE setZoomFactor NOTIFY zoomFactorChanged)
    Q_PROPERTY(float exposureTime READ exposureTime NOTIFY exposureTimeChanged)
    Q_PROPERTY(int manualExposureTime READ manualExposureTime WRITE setManualExposureTime NOTIFY manualExposureTimeChanged)
    Q_PROPERTY(int isoSensitivity READ isoSensitivity NOTIFY isoSensitivityChanged)
    Q_PROPERTY(int manualIsoSensitivity READ manualIsoSensitivity WRITE setManualIsoSensitivity NOTIFY manualIsoSensitivityChanged)
    Q_PROPERTY(float exposureCompensation READ exposureCompensation WRITE setExposureCompensation NOTIFY exposureCompensationChanged)
    Q_PROPERTY(QCamera::ExposureMode exposureMode READ exposureMode WRITE setExposureMode NOTIFY exposureModeChanged)
    Q_PROPERTY(bool flashReady READ isFlashReady NOTIFY flashReady)
    Q_PROPERTY(QCamera::FlashMode flashMode READ flashMode WRITE setFlashMode NOTIFY flashModeChanged)
    Q_PROPERTY(QCamera::TorchMode torchMode READ torchMode WRITE setTorchMode NOTIFY torchModeChanged)

    Q_PROPERTY(WhiteBalanceMode whiteBalanceMode READ whiteBalanceMode WRITE setWhiteBalanceMode NOTIFY whiteBalanceModeChanged)
    Q_PROPERTY(int colorTemperature READ colorTemperature WRITE setColorTemperature NOTIFY colorTemperatureChanged)
    Q_PROPERTY(Features supportedFeatures READ supportedFeatures NOTIFY supportedFeaturesChanged) +/

public:
    enum Error
    {
        NoError,
        CameraError
    }
    /+ Q_ENUM(Error) +/

    enum FocusMode {
        FocusModeAuto,
        FocusModeAutoNear,
        FocusModeAutoFar,
        FocusModeHyperfocal,
        FocusModeInfinity,
        FocusModeManual
    }
    /+ Q_ENUM(FocusMode) +/

    enum FlashMode {
        FlashOff,
        FlashOn,
        FlashAuto
    }
    /+ Q_ENUM(FlashMode) +/

    enum TorchMode {
        TorchOff,
        TorchOn,
        TorchAuto
    }
    /+ Q_ENUM(TorchMode) +/

    enum ExposureMode {
        ExposureAuto,
        ExposureManual,
        ExposurePortrait,
        ExposureNight,
        ExposureSports,
        ExposureSnow,
        ExposureBeach,
        ExposureAction,
        ExposureLandscape,
        ExposureNightPortrait,
        ExposureTheatre,
        ExposureSunset,
        ExposureSteadyPhoto,
        ExposureFireworks,
        ExposureParty,
        ExposureCandlelight,
        ExposureBarcode
    }
    /+ Q_ENUM(ExposureMode) +/

    enum WhiteBalanceMode {
        WhiteBalanceAuto = 0,
        WhiteBalanceManual = 1,
        WhiteBalanceSunlight = 2,
        WhiteBalanceCloudy = 3,
        WhiteBalanceShade = 4,
        WhiteBalanceTungsten = 5,
        WhiteBalanceFluorescent = 6,
        WhiteBalanceFlash = 7,
        WhiteBalanceSunset = 8
    }
    /+ Q_ENUM(WhiteBalanceMode) +/

    enum /+ class +/ Feature {
        ColorTemperature = 0x1,
        ExposureCompensation = 0x2,
        IsoSensitivity = 0x4,
        ManualExposureTime = 0x8,
        CustomFocusPoint = 0x10,
        FocusDistance = 0x20
    }
    /+ Q_DECLARE_FLAGS(Features, Feature) +/
alias Features = QFlags!(Feature);
    /+ explicit +/this(QObject parent = null);
    /+ explicit +/this(ref const(QCameraDevice) cameraDevice, QObject parent = null);
    /+ explicit +/this(QCameraDevice.Position position, QObject parent = null);
    ~this();

    final bool isAvailable() const;
    final bool isActive() const;

    final QMediaCaptureSession captureSession() const;

    final QCameraDevice cameraDevice() const;
    final void setCameraDevice(ref const(QCameraDevice) cameraDevice);

    final QCameraFormat cameraFormat() const;
    final void setCameraFormat(ref const(QCameraFormat) format);

    final Error error() const;
    final QString errorString() const;

    final Features supportedFeatures() const;

    final FocusMode focusMode() const;
    final void setFocusMode(FocusMode mode);
    @QInvokable final bool isFocusModeSupported(FocusMode mode) const;

    final QPointF focusPoint() const;

    final QPointF customFocusPoint() const;
    final void setCustomFocusPoint(ref const(QPointF) point);

    final void setFocusDistance(float d);
    final float focusDistance() const;

    final float minimumZoomFactor() const;
    final float maximumZoomFactor() const;
    final float zoomFactor() const;
    final void setZoomFactor(float factor);

    final FlashMode flashMode() const;
    @QInvokable final bool isFlashModeSupported(FlashMode mode) const;
    @QInvokable final bool isFlashReady() const;

    final TorchMode torchMode() const;
    @QInvokable final bool isTorchModeSupported(TorchMode mode) const;

    final ExposureMode exposureMode() const;
    @QInvokable final bool isExposureModeSupported(ExposureMode mode) const;

    final float exposureCompensation() const;

    final int isoSensitivity() const;
    final int manualIsoSensitivity() const;

    final float exposureTime() const;
    final float manualExposureTime() const;

    final int minimumIsoSensitivity() const;
    final int maximumIsoSensitivity() const;

    final float minimumExposureTime() const;
    final float maximumExposureTime() const;

    final WhiteBalanceMode whiteBalanceMode() const;
    @QInvokable final bool isWhiteBalanceModeSupported(WhiteBalanceMode mode) const;

    final int colorTemperature() const;

public /+ Q_SLOTS +/:
    @QSlot final void setActive(bool active);
    @QSlot extern(D) final void start() { setActive(true); }
    @QSlot extern(D) final void stop() { setActive(false); }

    @QSlot final void zoomTo(float zoom, float rate);

    @QSlot final void setFlashMode(FlashMode mode);
    @QSlot final void setTorchMode(TorchMode mode);
    @QSlot final void setExposureMode(ExposureMode mode);

    @QSlot final void setExposureCompensation(float ev);

    @QSlot final void setManualIsoSensitivity(int iso);
    @QSlot final void setAutoIsoSensitivity();

    @QSlot final void setManualExposureTime(float seconds);
    @QSlot final void setAutoExposureTime();

    @QSlot final void setWhiteBalanceMode(WhiteBalanceMode mode);
    @QSlot final void setColorTemperature(int colorTemperature);

/+ Q_SIGNALS +/public:
    @QSignal final void activeChanged(bool);
    @QSignal final void errorChanged();
    @QSignal final void errorOccurred(Error error, ref const(QString) errorString);
    @QSignal final void cameraDeviceChanged();
    @QSignal final void cameraFormatChanged();
    @QSignal final void supportedFeaturesChanged();

    @QSignal final void focusModeChanged();
    @QSignal final void zoomFactorChanged(float);
    @QSignal final void minimumZoomFactorChanged(float);
    @QSignal final void maximumZoomFactorChanged(float);
    @QSignal final void focusDistanceChanged(float);
    @QSignal final void focusPointChanged();
    @QSignal final void customFocusPointChanged();

    @QSignal final void flashReady(bool);
    @QSignal final void flashModeChanged();
    @QSignal final void torchModeChanged();

    @QSignal final void exposureTimeChanged(float speed);
    @QSignal final void manualExposureTimeChanged(float speed);
    @QSignal final void isoSensitivityChanged(int);
    @QSignal final void manualIsoSensitivityChanged(int);
    @QSignal final void exposureCompensationChanged(float);
    @QSignal final void exposureModeChanged();

    @QSignal final void whiteBalanceModeChanged() const;
    @QSignal final void colorTemperatureChanged() const;

    @QSignal final void brightnessChanged();
    @QSignal final void contrastChanged();
    @QSignal final void saturationChanged();
    @QSignal final void hueChanged();

private:
    final QPlatformCamera* platformCamera();
    final void setCaptureSession(QMediaCaptureSession session);
    /+ friend class QMediaCaptureSession; +/
    /+ Q_DISABLE_COPY(QCamera) +/
    /+ Q_DECLARE_PRIVATE(QCamera) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_error(int, const QString &)) +/
    /+ friend class QCameraDevice; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QCamera.Features.enum_type) operator |(QCamera.Features.enum_type f1, QCamera.Features.enum_type f2)/+noexcept+/{return QFlags!(QCamera.Features.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QCamera.Features.enum_type) operator |(QCamera.Features.enum_type f1, QFlags!(QCamera.Features.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QCamera.Features.enum_type) operator &(QCamera.Features.enum_type f1, QCamera.Features.enum_type f2)/+noexcept+/{return QFlags!(QCamera.Features.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QCamera.Features.enum_type) operator &(QCamera.Features.enum_type f1, QFlags!(QCamera.Features.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QCamera.Features.enum_type) operator ^(QCamera.Features.enum_type f1, QCamera.Features.enum_type f2)/+noexcept+/{return QFlags!(QCamera.Features.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QCamera.Features.enum_type) operator ^(QCamera.Features.enum_type f1, QFlags!(QCamera.Features.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QCamera.Features.enum_type f1, QCamera.Features.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QCamera.Features.enum_type f1, QFlags!(QCamera.Features.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QCamera.Features.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QCamera.Features.enum_type f1, QCamera.Features.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QCamera.Features.enum_type f1, QFlags!(QCamera.Features.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QCamera.Features.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QCamera.Features.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QCamera.Features.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QCamera.Features.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QCamera.Features.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QCamera.Features operator ~(QCamera.Features.enum_type e)/+noexcept+/{return~QCamera.Features(e);}+/
/+pragma(inline, true) void operator |(QCamera.Features.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QCamera.Features.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QCamera::Features)

Q_MEDIA_ENUM_DEBUG(QCamera, Error) +/

