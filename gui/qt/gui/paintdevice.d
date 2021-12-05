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
module qt.gui.paintdevice;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.point;
import qt.gui.paintengine;
import qt.gui.painter;
import qt.helpers;

/+ class QPaintEngine; +/
extern(C++, class) struct QPaintDevicePrivate;

interface QPaintDeviceInterface
{
    alias PaintDeviceMetric = QPaintDevice.PaintDeviceMetric;

  //  /+ virtual +/~this();
    /+ virtual +/ int devType() const;
    /+ virtual +/ QPaintEngine paintEngine() const /+ = 0 +/;
protected:
    /+ virtual +/ int metric(PaintDeviceMetric metric) const;
    /+ virtual +/ void initPainter(QPainter * painter) const;
    /+ virtual +/ QPaintDevice redirected(QPoint * offset) const;
    /+ virtual +/ QPainter * sharedPainter() const;
}

class /+ Q_GUI_EXPORT +/ QPaintDevice//: QPaintDeviceInterface                                // device for QPainter
{
public:
    enum PaintDeviceMetric {
        PdmWidth = 1,
        PdmHeight,
        PdmWidthMM,
        PdmHeightMM,
        PdmNumColors,
        PdmDepth,
        PdmDpiX,
        PdmDpiY,
        PdmPhysicalDpiX,
        PdmPhysicalDpiY,
        PdmDevicePixelRatio,
        PdmDevicePixelRatioScaled
    }

    /+ virtual +/~this();

    /+ virtual +/ pragma(inline, true) int devType() const
    {
        import qt.core.namespace;
        return QInternal.PaintDeviceFlags.UnknownDevice;
    }
    pragma(inline, true) final bool paintingActive() const
    { return painters != 0; }
    /+ virtual +/ abstract QPaintEngine paintEngine() const;

    final int width() const { return metric(PaintDeviceMetric.PdmWidth); }
    final int height() const { return metric(PaintDeviceMetric.PdmHeight); }
    final int widthMM() const { return metric(PaintDeviceMetric.PdmWidthMM); }
    final int heightMM() const { return metric(PaintDeviceMetric.PdmHeightMM); }
    final int logicalDpiX() const { return metric(PaintDeviceMetric.PdmDpiX); }
    final int logicalDpiY() const { return metric(PaintDeviceMetric.PdmDpiY); }
    final int physicalDpiX() const { return metric(PaintDeviceMetric.PdmPhysicalDpiX); }
    final int physicalDpiY() const { return metric(PaintDeviceMetric.PdmPhysicalDpiY); }
    final int devicePixelRatio() const { return metric(PaintDeviceMetric.PdmDevicePixelRatio); }
    final qreal devicePixelRatioF()  const { return metric(PaintDeviceMetric.PdmDevicePixelRatioScaled) / devicePixelRatioFScale(); }
    final int colorCount() const { return metric(PaintDeviceMetric.PdmNumColors); }
    final int depth() const { return metric(PaintDeviceMetric.PdmDepth); }

    pragma(inline, true) static qreal devicePixelRatioFScale() { return 0x10000; }
protected:
    this()/+ noexcept+/;
    /+ virtual +/ int metric(PaintDeviceMetric metric) const;
    package /+ virtual +/ void initPainter(QPainter* painter) const;
    package /+ virtual +/ QPaintDevice redirected(QPoint* offset) const;
    package /+ virtual +/ QPainter* sharedPainter() const;

    ushort        painters;                        // refcount
private:
    /+ Q_DISABLE_COPY(QPaintDevice) +/

    QPaintDevicePrivate* reserved;

    /+ friend class QPainter; +/
    /+ friend class QPainterPrivate; +/
    /+ friend class QFontEngineMac; +/
    /+ friend class QX11PaintEngine; +/
    /+ friend Q_GUI_EXPORT int qt_paint_device_metric(const QPaintDevice *device, PaintDeviceMetric metric); +/
}

/*****************************************************************************
  Inline functions
 *****************************************************************************/

static assert(__traits(classInstanceSize, QPaintDevice) == (void*).sizeof * 3);
struct QPaintDeviceFakeInheritance
{
    static assert(__traits(classInstanceSize, QPaintDevice) % (void*).sizeof == 0);
    void*[__traits(classInstanceSize, QPaintDevice) / (void*).sizeof - 1] data;
}
