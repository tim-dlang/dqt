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
module qt.gui.pagesize;
extern(C++):

import qt.config;
import qt.core.rect;
import qt.core.shareddata;
import qt.core.size;
import qt.core.string;
import qt.core.typeinfo;
import qt.helpers;

/+ #if defined(B0)
#undef B0 // Terminal hang-up.  We assume that you do not want that.
#endif +/

extern(C++, class) struct QPageSizePrivate;
/+ class QString;
class QSize;
class QSizeF; +/

@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPageSize
{
public:

    // ### Qt6 Re-order and remove duplicates
    // NOTE: Must keep in sync with QPagedPrintEngine and QPrinter
    enum PageSizeId {
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
        LastPageSize = PageSizeId.EnvelopeYou4,
        NPageSize = PageSizeId.LastPageSize,
        NPaperSize = PageSizeId.LastPageSize,

        // Convenience overloads for naming consistency
        AnsiA = PageSizeId.Letter,
        AnsiB = PageSizeId.Ledger,
        EnvelopeC5 = PageSizeId.C5E,
        EnvelopeDL = PageSizeId.DLE,
        Envelope10 = PageSizeId.Comm10E
    }

    // NOTE: Must keep in sync with QPageLayout::Unit and QPrinter::Unit
    enum Unit {
        Millimeter,
        Point,
        Inch,
        Pica,
        Didot,
        Cicero
    }

    enum SizeMatchPolicy {
        FuzzyMatch,
        FuzzyOrientationMatch,
        ExactMatch
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

    /+ explicit +/this(PageSizeId pageSizeId);
    /+ explicit +/this(ref const(QSize) pointSize,
                           ref const(QString) name = globalInitVar!QString,
                           SizeMatchPolicy matchPolicy = SizeMatchPolicy.FuzzyMatch);
    /+ explicit +/this(ref const(QSizeF) size, Unit units,
                           ref const(QString) name = globalInitVar!QString,
                           SizeMatchPolicy matchPolicy = SizeMatchPolicy.FuzzyMatch);
    @disable this(this);
    this(ref const(QPageSize) other);
    /+ QPageSize &operator=(QPageSize &&other) noexcept { swap(other); return *this; } +/
    /+ref QPageSize operator =(ref const(QPageSize) other);+/
    ~this();


    /+ void swap(QPageSize &other) noexcept { qSwap(d, other.d); } +/

    /+ friend Q_GUI_EXPORT bool operator==(const QPageSize &lhs, const QPageSize &rhs); +/
    bool isEquivalentTo(ref const(QPageSize) other) const;

    bool isValid() const;

    QString key() const;
    QString name() const;

    PageSizeId id() const;

    int windowsId() const;

    QSizeF definitionSize() const;
    Unit definitionUnits() const;

    QSizeF size(Unit units) const;
    QSize sizePoints() const;
    QSize sizePixels(int resolution) const;

    QRectF rect(Unit units) const;
    QRect rectPoints() const;
    QRect rectPixels(int resolution) const;

    static QString key(PageSizeId pageSizeId);
    static QString name(PageSizeId pageSizeId);

    static PageSizeId id(ref const(QSize) pointSize,
                             SizeMatchPolicy matchPolicy = SizeMatchPolicy.FuzzyMatch);
    static PageSizeId id(ref const(QSizeF) size, Unit units,
                             SizeMatchPolicy matchPolicy = SizeMatchPolicy.FuzzyMatch);

    static PageSizeId id(int windowsId);
    static int windowsId(PageSizeId pageSizeId);

    static QSizeF definitionSize(PageSizeId pageSizeId);
    static Unit definitionUnits(PageSizeId pageSizeId);

    static QSizeF size(PageSizeId pageSizeId, Unit units);
    static QSize sizePoints(PageSizeId pageSizeId);
    static QSize sizePixels(PageSizeId pageSizeId, int resolution);

private:
    /+ friend class QPageSizePrivate; +/
    /+ friend class QPlatformPrintDevice; +/
    this(ref const(QString) key, ref const(QSize) pointSize, ref const(QString) name);
    this(int windowsId, ref const(QSize) pointSize, ref const(QString) name);
    this(ref QPageSizePrivate dd);
    QSharedDataPointer!(QPageSizePrivate) d;
}

/+ Q_DECLARE_SHARED(QPageSize) +/

/+/+ Q_GUI_EXPORT +/ bool operator ==(ref const(QPageSize) lhs, ref const(QPageSize) rhs);+/
/+pragma(inline, true) bool operator !=(ref const(QPageSize) lhs, ref const(QPageSize) rhs)
{ return !operator==(lhs, rhs); }+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug dbg, const QPageSize &pageSize);
#endif


Q_DECLARE_METATYPE(QPageSize)
Q_DECLARE_METATYPE(QPageSize::PageSizeId)
Q_DECLARE_METATYPE(QPageSize::Unit) +/

