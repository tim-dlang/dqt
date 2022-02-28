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
module qt.gui.pagedpaintdevice;
extern(C++):

import qt.config;
import qt.core.margins;
import qt.gui.pagelayout;
import qt.gui.pageranges;
import qt.gui.pagesize;
import qt.gui.paintdevice;
import qt.helpers;

/+ #if defined(B0)
#undef B0 // Terminal hang-up.  We assume that you do not want that.
#endif +/

extern(C++, class) struct QPagedPaintDevicePrivate;

interface QPagedPaintDeviceInterface : QPaintDeviceInterface
{
    alias PdfVersion = QPagedPaintDevice.PdfVersion;

    /+ virtual +/ abstract bool newPage();
    /+ virtual +/ bool setPageLayout(ref const(QPageLayout) pageLayout);
    /+ virtual +/ bool setPageSize(ref const(QPageSize) pageSize);
    /+ virtual +/ bool setPageOrientation(QPageLayout.Orientation orientation);
    /+ virtual +/ bool setPageMargins(ref const(QMarginsF) margins, QPageLayout.Unit units = QPageLayout.Unit.Millimeter);
}

/// Binding for C++ class [QPagedPaintDevice](https://doc.qt.io/qt-6/qpagedpaintdevice.html).
abstract class /+ Q_GUI_EXPORT +/ QPagedPaintDevice : QPaintDevice
{
public:
    ~this();

    /+ virtual +/ abstract bool newPage();

    // keep in sync with QPdfEngine::PdfVersion!
    enum PdfVersion { PdfVersion_1_4, PdfVersion_A1b, PdfVersion_1_6 }

    /+ virtual +/ bool setPageLayout(ref const(QPageLayout) pageLayout);
    /+ virtual +/ bool setPageSize(ref const(QPageSize) pageSize);
    /+ virtual +/ bool setPageOrientation(QPageLayout.Orientation orientation);
    /+ virtual +/ bool setPageMargins(ref const(QMarginsF) margins, QPageLayout.Unit units = QPageLayout.Unit.Millimeter);
    final QPageLayout pageLayout() const;

    /+ virtual +/ void setPageRanges(ref const(QPageRanges) ranges);
    final QPageRanges pageRanges() const;

protected:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(QPagedPaintDevicePrivate* dd);
    }));
    final QPagedPaintDevicePrivate* dd();
    /+ friend class QPagedPaintDevicePrivate; +/
    QPagedPaintDevicePrivate* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

static assert(__traits(classInstanceSize, QPagedPaintDevice) == (void*).sizeof * 3);
struct QPagedPaintDeviceFakeInheritance
{
    static assert(__traits(classInstanceSize, QPagedPaintDevice) % (void*).sizeof == 0);
    void*[__traits(classInstanceSize, QPagedPaintDevice) / (void*).sizeof - 1] data;
}

