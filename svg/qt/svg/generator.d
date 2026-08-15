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
module qt.svg.generator;
extern(C++):

import qt.config;
import qt.helpers;
static if (!defined!"QT_NO_SVGGENERATOR")
{
    import qt.core.iodevice;
    import qt.core.rect;
    import qt.core.scopedpointer;
    import qt.core.size;
    import qt.core.string;
    import qt.gui.paintdevice;
    import qt.gui.paintengine;
}

static if (!defined!"QT_NO_SVGGENERATOR")
{



extern(C++, class) struct QSvgGeneratorPrivate;

/// Binding for C++ class [QSvgGenerator](https://doc.qt.io/qt-6/qsvggenerator.html).
class /+ Q_SVG_EXPORT +/ QSvgGenerator : QPaintDevice
{
private:
    /+ Q_DECLARE_PRIVATE(QSvgGenerator) +/

    /+ Q_PROPERTY(QSize size READ size WRITE setSize)
    Q_PROPERTY(QRectF viewBox READ viewBoxF WRITE setViewBox)
    Q_PROPERTY(QString title READ title WRITE setTitle)
    Q_PROPERTY(QString description READ description WRITE setDescription)
    Q_PROPERTY(QString fileName READ fileName WRITE setFileName)
    Q_PROPERTY(QIODevice* outputDevice READ outputDevice WRITE setOutputDevice)
    Q_PROPERTY(int resolution READ resolution WRITE setResolution) +/
public:
    this();
    ~this();

    final QString title() const;
    final void setTitle(ref const(QString) title);

    final QString description() const;
    final void setDescription(ref const(QString) description);

    final QSize size() const;
    final void setSize(ref const(QSize) size);

    final QRect viewBox() const;
    final QRectF viewBoxF() const;
    final void setViewBox(ref const(QRect) viewBox);
    final void setViewBox(ref const(QRectF) viewBox);

    final QString fileName() const;
    final void setFileName(ref const(QString) fileName);

    final QIODevice outputDevice() const;
    final void setOutputDevice(QIODevice outputDevice);

    final void setResolution(int dpi);
    final int resolution() const;
protected:
    override QPaintEngine paintEngine() const;
    override int metric(QPaintDevice.PaintDeviceMetric metric) const;

private:
    QScopedPointer!(QSvgGeneratorPrivate) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


}

