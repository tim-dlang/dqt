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
import qt.core.global;
import qt.core.margins;
import qt.core.size;
import qt.gui.pagelayout;
import qt.gui.pagesize;
import qt.gui.paintdevice;
import qt.helpers;

/+ #if defined(B0)
#undef B0 // Terminal hang-up.  We assume that you do not want that.
#endif +/

extern(C++, class) struct QPagedPaintDevicePrivate;

interface QPagedPaintDeviceInterface : QPaintDeviceInterface
{
    alias PageSize = QPagedPaintDevice.PageSize;
    alias Margins = QPagedPaintDevice.Margins;
    alias PdfVersion = QPagedPaintDevice.PdfVersion;

    /+ virtual +/ abstract bool newPage();
    /+ QT_DEPRECATED_VERSION_X_5_15("Use setPageSize(QPageSize) instead.") +/
        /+ virtual +/ void setPageSize(PageSize size);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use setPageSize(QPageSize) instead.") +/
        /+ virtual +/ void setPageSizeMM(ref const(QSizeF) size);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use setPageMargins(QMarginsF, QPageLayout::Unit) instead.") +/
        /+ virtual +/ void setMargins(ref const(Margins) margins);
}

/// Binding for C++ class [QPagedPaintDevice](https://doc.qt.io/qt-5/qpagedpaintdevice.html).
class /+ Q_GUI_EXPORT +/ QPagedPaintDevice : QPaintDevice
{
public:
    mixin(mangleItanium("_ZN17QPagedPaintDeviceC2Ev", q{
    /+ QT_DEPRECATED +/this();
    }));
    ~this();

    /+ virtual +/ abstract bool newPage();

    // ### Qt6 Remove in favor of QPage::PageSize
    // NOTE: Must keep in sync with QPageSize and QPrinter
    enum PageSize {
        // Existing Qt sizes
        A4,
        B5,
        Letter,
        Legal,
        Executive,
        A0,
        A1,
        A2,
        A3,
        A5,
        A6,
        A7,
        A8,
        A9,
        B0,
        B1,
        B10,
        B2,
        B3,
        B4,
        B6,
        B7,
        B8,
        B9,
        C5E,
        Comm10E,
        DLE,
        Folio,
        Ledger,
        Tabloid,
        Custom,

        // New values derived from PPD standard
        A10,
        A3Extra,
        A4Extra,
        A4Plus,
        A4Small,
        A5Extra,
        B5Extra,

        JisB0,
        JisB1,
        JisB2,
        JisB3,
        JisB4,
        JisB5,
        JisB6,
        JisB7,
        JisB8,
        JisB9,
        JisB10,

        // AnsiA = Letter,
        // AnsiB = Ledger,
        AnsiC,
        AnsiD,
        AnsiE,
        LegalExtra,
        LetterExtra,
        LetterPlus,
        LetterSmall,
        TabloidExtra,

        ArchA,
        ArchB,
        ArchC,
        ArchD,
        ArchE,

        Imperial7x9,
        Imperial8x10,
        Imperial9x11,
        Imperial9x12,
        Imperial10x11,
        Imperial10x13,
        Imperial10x14,
        Imperial12x11,
        Imperial15x11,

        ExecutiveStandard,
        Note,
        Quarto,
        Statement,
        SuperA,
        SuperB,
        Postcard,
        DoublePostcard,
        Prc16K,
        Prc32K,
        Prc32KBig,

        FanFoldUS,
        FanFoldGerman,
        FanFoldGermanLegal,

        EnvelopeB4,
        EnvelopeB5,
        EnvelopeB6,
        EnvelopeC0,
        EnvelopeC1,
        EnvelopeC2,
        EnvelopeC3,
        EnvelopeC4,
        // EnvelopeC5 = C5E,
        EnvelopeC6,
        EnvelopeC65,
        EnvelopeC7,
        // EnvelopeDL = DLE,

        Envelope9,
        // Envelope10 = Comm10E,
        Envelope11,
        Envelope12,
        Envelope14,
        EnvelopeMonarch,
        EnvelopePersonal,

        EnvelopeChou3,
        EnvelopeChou4,
        EnvelopeInvite,
        EnvelopeItalian,
        EnvelopeKaku2,
        EnvelopeKaku3,
        EnvelopePrc1,
        EnvelopePrc2,
        EnvelopePrc3,
        EnvelopePrc4,
        EnvelopePrc5,
        EnvelopePrc6,
        EnvelopePrc7,
        EnvelopePrc8,
        EnvelopePrc9,
        EnvelopePrc10,
        EnvelopeYou4,

        // Last item, with commonly used synynoms from QPagedPrintEngine / QPrinter
        LastPageSize = PageSize.EnvelopeYou4,
        NPageSize = PageSize.LastPageSize,
        NPaperSize = PageSize.LastPageSize,

        // Convenience overloads for naming consistency
        AnsiA = PageSize.Letter,
        AnsiB = PageSize.Ledger,
        EnvelopeC5 = PageSize.C5E,
        EnvelopeDL = PageSize.DLE,
        Envelope10 = PageSize.Comm10E
    }

    // keep in sync with QPdfEngine::PdfVersion!
    enum PdfVersion { PdfVersion_1_4, PdfVersion_A1b, PdfVersion_1_6 }

    // ### Qt6 Make these virtual
    final bool setPageLayout(ref const(QPageLayout) pageLayout);
    final bool setPageSize(ref const(QPageSize) pageSize);
    final bool setPageOrientation(QPageLayout.Orientation orientation);
    final bool setPageMargins(ref const(QMarginsF) margins);
    final bool setPageMargins(ref const(QMarginsF) margins, QPageLayout.Unit units);
    final QPageLayout pageLayout() const;

/+ #if QT_DEPRECATED_SINCE(5,15) +/
    /+ QT_DEPRECATED_VERSION_X_5_15("Use setPageSize(QPageSize) instead.") +/
        /+ virtual +/ void setPageSize(PageSize size);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use pageLayout().pageSize().id() instead.") +/
        final PageSize pageSize() const;

    /+ QT_DEPRECATED_VERSION_X_5_15("Use setPageSize(QPageSize) instead.") +/
        /+ virtual +/ void setPageSizeMM(ref const(QSizeF) size);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use pageLayout().pageSize() instead.") +/
        final QSizeF pageSizeMM() const;
/+ #endif +/

    // ### Qt6 Remove in favor of QMarginsF
    struct Margins {
        qreal left;
        qreal right;
        qreal top;
        qreal bottom;
    }

/+ #if QT_DEPRECATED_SINCE(5,15) +/
    /+ QT_DEPRECATED_VERSION_X_5_15("Use setPageMargins(QMarginsF, QPageLayout::Unit) instead.") +/
        /+ virtual +/ void setMargins(ref const(Margins) margins);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use pageLayout().margins() instead.") +/
        final Margins margins() const;
/+ #endif +/

protected:
    this(QPagedPaintDevicePrivate* dd);
    final QPagedPaintDevicePrivate* dd();
    /+ QT_DEPRECATED +/ final QPageLayout devicePageLayout() const;
    /+ QT_DEPRECATED +/ final ref QPageLayout devicePageLayout();
    /+ friend class QPagedPaintDevicePrivate; +/
    QPagedPaintDevicePrivate* d;
}

static assert(__traits(classInstanceSize, QPagedPaintDevice) == (void*).sizeof * 4);
struct QPagedPaintDeviceFakeInheritance
{
    static assert(__traits(classInstanceSize, QPagedPaintDevice) % (void*).sizeof == 0);
    void*[__traits(classInstanceSize, QPagedPaintDevice) / (void*).sizeof - 1] data;
}

