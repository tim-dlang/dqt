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
module qt.gui.screen;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.gui.pixmap;
import qt.gui.transform;
import qt.gui.windowdefs;
import qt.helpers;

extern(C++, class) struct QPlatformScreen;
extern(C++, class) struct QScreenPrivate;
/+ class QWindow;
class QRect;
class QPixmap;
#ifndef QT_NO_DEBUG_STREAM
class QDebug;
#endif +/

class /+ Q_GUI_EXPORT +/ QScreen : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QScreen) +/

    /+ Q_PROPERTY(QString name READ name CONSTANT)
    Q_PROPERTY(QString manufacturer READ manufacturer CONSTANT)
    Q_PROPERTY(QString model READ model CONSTANT)
    Q_PROPERTY(QString serialNumber READ serialNumber CONSTANT)
    Q_PROPERTY(int depth READ depth CONSTANT)
    Q_PROPERTY(QSize size READ size NOTIFY geometryChanged)
    Q_PROPERTY(QSize availableSize READ availableSize NOTIFY availableGeometryChanged)
    Q_PROPERTY(QSize virtualSize READ virtualSize NOTIFY virtualGeometryChanged)
    Q_PROPERTY(QSize availableVirtualSize READ availableVirtualSize NOTIFY virtualGeometryChanged)
    Q_PROPERTY(QRect geometry READ geometry NOTIFY geometryChanged)
    Q_PROPERTY(QRect availableGeometry READ availableGeometry NOTIFY availableGeometryChanged)
    Q_PROPERTY(QRect virtualGeometry READ virtualGeometry NOTIFY virtualGeometryChanged)
    Q_PROPERTY(QRect availableVirtualGeometry READ availableVirtualGeometry NOTIFY virtualGeometryChanged)
    Q_PROPERTY(QSizeF physicalSize READ physicalSize NOTIFY physicalSizeChanged)
    Q_PROPERTY(qreal physicalDotsPerInchX READ physicalDotsPerInchX NOTIFY physicalDotsPerInchChanged)
    Q_PROPERTY(qreal physicalDotsPerInchY READ physicalDotsPerInchY NOTIFY physicalDotsPerInchChanged)
    Q_PROPERTY(qreal physicalDotsPerInch READ physicalDotsPerInch NOTIFY physicalDotsPerInchChanged)
    Q_PROPERTY(qreal logicalDotsPerInchX READ logicalDotsPerInchX NOTIFY logicalDotsPerInchChanged)
    Q_PROPERTY(qreal logicalDotsPerInchY READ logicalDotsPerInchY NOTIFY logicalDotsPerInchChanged)
    Q_PROPERTY(qreal logicalDotsPerInch READ logicalDotsPerInch NOTIFY logicalDotsPerInchChanged)
    Q_PROPERTY(qreal devicePixelRatio READ devicePixelRatio NOTIFY physicalDotsPerInchChanged)
    Q_PROPERTY(Qt::ScreenOrientation primaryOrientation READ primaryOrientation NOTIFY primaryOrientationChanged)
    Q_PROPERTY(Qt::ScreenOrientation orientation READ orientation NOTIFY orientationChanged)
    Q_PROPERTY(Qt::ScreenOrientation nativeOrientation READ nativeOrientation)
    Q_PROPERTY(qreal refreshRate READ refreshRate NOTIFY refreshRateChanged) +/

public:
    ~this();
    final QPlatformScreen* handle() const;

    final QString name() const;

    final QString manufacturer() const;
    final QString model() const;
    final QString serialNumber() const;

    final int depth() const;

    final QSize size() const;
    final QRect geometry() const;

    final QSizeF physicalSize() const;

    final qreal physicalDotsPerInchX() const;
    final qreal physicalDotsPerInchY() const;
    final qreal physicalDotsPerInch() const;

    final qreal logicalDotsPerInchX() const;
    final qreal logicalDotsPerInchY() const;
    final qreal logicalDotsPerInch() const;

    final qreal devicePixelRatio() const;

    final QSize availableSize() const;
    final QRect availableGeometry() const;

    final QList!(QScreen) virtualSiblings() const;
    final QScreen virtualSiblingAt(QPoint point);

    final QSize virtualSize() const;
    final QRect virtualGeometry() const;

    final QSize availableVirtualSize() const;
    final QRect availableVirtualGeometry() const;

    final /+ Qt:: +/qt.core.namespace.ScreenOrientation primaryOrientation() const;
    final /+ Qt:: +/qt.core.namespace.ScreenOrientation orientation() const;
    final /+ Qt:: +/qt.core.namespace.ScreenOrientation nativeOrientation() const;

    final /+ Qt:: +/qt.core.namespace.ScreenOrientations orientationUpdateMask() const;
    final void setOrientationUpdateMask(/+ Qt:: +/qt.core.namespace.ScreenOrientations mask);

    final int angleBetween(/+ Qt:: +/qt.core.namespace.ScreenOrientation a, /+ Qt:: +/qt.core.namespace.ScreenOrientation b) const;
    final QTransform transformBetween(/+ Qt:: +/qt.core.namespace.ScreenOrientation a, /+ Qt:: +/qt.core.namespace.ScreenOrientation b, ref const(QRect) target) const;
    final QRect mapBetween(/+ Qt:: +/qt.core.namespace.ScreenOrientation a, /+ Qt:: +/qt.core.namespace.ScreenOrientation b, ref const(QRect) rect) const;

    final bool isPortrait(/+ Qt:: +/qt.core.namespace.ScreenOrientation orientation) const;
    final bool isLandscape(/+ Qt:: +/qt.core.namespace.ScreenOrientation orientation) const;

    final QPixmap grabWindow(WId window, int x = 0, int y = 0, int w = -1, int h = -1);

    final qreal refreshRate() const;

/+ Q_SIGNALS +/public:
    @QSignal final void geometryChanged(ref const(QRect) geometry);
    @QSignal final void availableGeometryChanged(ref const(QRect) geometry);
    @QSignal final void physicalSizeChanged(ref const(QSizeF) size);
    @QSignal final void physicalDotsPerInchChanged(qreal dpi);
    @QSignal final void logicalDotsPerInchChanged(qreal dpi);
    @QSignal final void virtualGeometryChanged(ref const(QRect) rect);
    @QSignal final void primaryOrientationChanged(/+ Qt:: +/qt.core.namespace.ScreenOrientation orientation);
    @QSignal final void orientationChanged(/+ Qt:: +/qt.core.namespace.ScreenOrientation orientation);
    @QSignal final void refreshRateChanged(qreal refreshRate);

private:
    /+ explicit +/this(QPlatformScreen* screen);

    /+ Q_DISABLE_COPY(QScreen) +/
    /+ friend class QGuiApplicationPrivate; +/
    /+ friend class QPlatformIntegration; +/
    /+ friend class QPlatformScreen; +/
    /+ friend class QHighDpiScaling; +/
    /+ friend class QWindowSystemInterface; +/
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QScreen *);
#endif +/

