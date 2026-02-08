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
module qt.gui.pdfwriter;
extern(C++):

import qt.config;
import qt.core.point;
import qt.gui.painter;
import qt.gui.paintdevice;
import qt.helpers;
static if (!defined!"QT_NO_PDF")
{
    import qt.core.bytearray;
    import qt.core.iodevice;
    import qt.core.object;
    import qt.core.size;
    import qt.core.string;
    import qt.gui.pagedpaintdevice;
    import qt.gui.paintengine;
}

static if (!defined!"QT_NO_PDF")
{


extern(C++, class) struct QPdfWriterPrivate;

/// Binding for C++ class [QPdfWriter](https://doc.qt.io/qt-5/qpdfwriter.html).
class /+ Q_GUI_EXPORT +/ QPdfWriter : QObject, QPagedPaintDeviceInterface
{
    QPagedPaintDeviceFakeInheritance baseQPagedPaintDeviceInterface;

    mixin(Q_OBJECT);
public:
    /+ explicit +/this(ref const(QString) filename);
    /+ explicit +/this(QIODevice device);
    ~this();

    final void setPdfVersion(PdfVersion version_);
    final PdfVersion pdfVersion() const;

    final QString title() const;
    final void setTitle(ref const(QString) title);

    final QString creator() const;
    final void setCreator(ref const(QString) creator);

    override bool newPage();

    final void setResolution(int resolution);
    final int resolution() const;

    final void setDocumentXmpMetadata(ref const(QByteArray) xmpMetadata);
    final QByteArray documentXmpMetadata() const;

    final void addFileAttachment(ref const(QString) fileName, ref const(QByteArray) data, ref const(QString) mimeType = globalInitVar!QString);

/+ #ifdef Q_QDOC
    bool setPageLayout(const QPageLayout &pageLayout);
    bool setPageSize(const QPageSize &pageSize);
    bool setPageOrientation(QPageLayout::Orientation orientation);
    bool setPageMargins(const QMarginsF &margins);
    bool setPageMargins(const QMarginsF &margins, QPageLayout::Unit units);
    QPageLayout pageLayout() const;
#else +/
    //alias setPageSize = QPagedPaintDevice.setPageSize;
/+ #endif

#if QT_DEPRECATED_SINCE(5, 14) +/
    /+ QT_DEPRECATED_X("Use setPageSize(QPageSize(id)) instead") +/
        override void setPageSize(PageSize size);
    /+ QT_DEPRECATED_X("Use setPageSize(QPageSize(size, QPageSize::Millimeter)) instead") +/
        override void setPageSizeMM(ref const(QSizeF) size);
    /+ QT_DEPRECATED_X("Use setPageMargins(QMarginsF(l, t, r, b), QPageLayout::Millimeter) instead") +/
        override void setMargins(ref const(Margins) m);
/+ #endif +/

protected:
    override QPaintEngine paintEngine() const;
    override int metric(PaintDeviceMetric id) const;

private:
    /+ Q_DISABLE_COPY(QPdfWriter) +/
    /+ Q_DECLARE_PRIVATE(QPdfWriter) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);

protected:
    final int devType() const
    {
        assert(false);
    }
    final void initPainter(QPainter * painter) const
    {
        assert(false);
    }
    final QPaintDevice redirected(QPoint* offset) const
    {
        assert(false);
    }
    final QPainter* sharedPainter() const
    {
        assert(false);
    }
}


}

