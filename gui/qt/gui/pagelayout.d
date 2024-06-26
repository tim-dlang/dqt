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
module qt.gui.pagelayout;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.margins;
import qt.core.metatype;
import qt.core.rect;
import qt.core.shareddata;
import qt.core.typeinfo;
import qt.gui.pagesize;
import qt.helpers;

extern(C++, class) struct QPageLayoutPrivate;

/// Binding for C++ class [QPageLayout](https://doc.qt.io/qt-5/qpagelayout.html).
@Q_DECLARE_METATYPE @Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPageLayout
{
public:

    // NOTE: Must keep in sync with QPageSize::Unit and QPrinter::Unit
    enum Unit {
        Millimeter,
        Point,
        Inch,
        Pica,
        Didot,
        Cicero
    }

    // NOTE: Must keep in sync with QPrinter::Orientation
    enum Orientation {
        Portrait,
        Landscape
    }

    enum Mode {
        StandardMode,  // Paint Rect includes margins
        FullPageMode   // Paint Rect excludes margins
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

    this(ref const(QPageSize) pageSize, Orientation orientation,
                    ref const(QMarginsF) margins, Unit units = Unit.Point,
                    ref const(QMarginsF) minMargins = globalInitVar!QMarginsF);
    @disable this(this);
    this(ref const(QPageLayout) other);
    /+ QPageLayout &operator=(QPageLayout &&other) noexcept { swap(other); return *this; } +/
    /+ref QPageLayout operator =(ref const(QPageLayout) other);+/
    ~this();

    /+ void swap(QPageLayout &other) noexcept { qSwap(d, other.d); } +/

    /+ friend Q_GUI_EXPORT bool operator==(const QPageLayout &lhs, const QPageLayout &rhs); +/
    bool isEquivalentTo(ref const(QPageLayout) other) const;

    bool isValid() const;

    void setMode(Mode mode);
    Mode mode() const;

    void setPageSize(ref const(QPageSize) pageSize,
                         ref const(QMarginsF) minMargins /+ = QMarginsF(0, 0, 0, 0) +/);
    QPageSize pageSize() const;

    void setOrientation(Orientation orientation);
    Orientation orientation() const;

    void setUnits(Unit units);
    Unit units() const;

    bool setMargins(ref const(QMarginsF) margins);
    bool setLeftMargin(qreal leftMargin);
    bool setRightMargin(qreal rightMargin);
    bool setTopMargin(qreal topMargin);
    bool setBottomMargin(qreal bottomMargin);

    QMarginsF margins() const;
    QMarginsF margins(Unit units) const;
    QMargins marginsPoints() const;
    QMargins marginsPixels(int resolution) const;

    void setMinimumMargins(ref const(QMarginsF) minMargins);
    QMarginsF minimumMargins() const;
    QMarginsF maximumMargins() const;

    QRectF fullRect() const;
    QRectF fullRect(Unit units) const;
    QRect fullRectPoints() const;
    QRect fullRectPixels(int resolution) const;

    QRectF paintRect() const;
    QRectF paintRect(Unit units) const;
    QRect paintRectPoints() const;
    QRect paintRectPixels(int resolution) const;

private:
    /+ friend class QPageLayoutPrivate; +/
    QExplicitlySharedDataPointer!(QPageLayoutPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QPageLayout) +/

/+/+ Q_GUI_EXPORT +/ bool operator ==(ref const(QPageLayout) lhs, ref const(QPageLayout) rhs);+/
/+pragma(inline, true) bool operator !=(ref const(QPageLayout) lhs, ref const(QPageLayout) rhs)
{ return !operator==(lhs, rhs); }+/

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug dbg, const QPageLayout &pageLayout);
#endif


Q_DECLARE_METATYPE(QPageLayout)
Q_DECLARE_METATYPE(QPageLayout::Unit)
Q_DECLARE_METATYPE(QPageLayout::Orientation) +/

