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
module qt.gui.region;
extern(C++):

import qt.config;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.refcount;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.bitmap;
import qt.gui.polygon;
import qt.helpers;
version (Cygwin) {} else
version (Windows)
    import qt.gui.windowdefs_win;
version (QT_NO_DATASTREAM) {} else
{
    import qt.core.bytearray;
    import qt.core.datastream;
}

/+ #ifndef QT_NO_DATASTREAM
#endif +/




struct QRegionPrivate;


/// Binding for C++ class [QRegion](https://doc.qt.io/qt-6/qregion.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QRegion
{
public:
    enum RegionType { Rectangle, Ellipse }

    version (Windows)
    {
        @disable this();
        pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
        ref typeof(this) rawConstructor();
        static typeof(this) create()
        {
            typeof(this) r = typeof(this).init;
            r.rawConstructor();
            return r;
        }
    }
    else
    {
        static typeof(this) create()
        {
            return typeof(this).init;
        }
    }

    this(int x, int y, int w, int h, RegionType t = RegionType.Rectangle);
    this(ref const(QRect) r, RegionType t = RegionType.Rectangle);
    this(ref const(QPolygon) pa, /+ Qt:: +/qt.core.namespace.FillRule fillRule = /+ Qt:: +/qt.core.namespace.FillRule.OddEvenFill);
    @disable this(this);
    this(ref const(QRegion) region);
    /+ QRegion(QRegion &&other) noexcept
        : d(qExchange(other.d, const_cast<QRegionData*>(&shared_empty))) {} +/
    this(ref const(QBitmap) bitmap);
    ~this();
    /+ref QRegion operator =(ref const(QRegion) );+/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QRegion) +//+ ; +/
    /+ inline void swap(QRegion &other) noexcept { qSwap(d, other.d); } +/
    bool isEmpty() const;
    bool isNull() const;

    alias const_iterator = const(QRect)*;
    /+ typedef std::reverse_iterator<const_iterator> const_reverse_iterator; +/

    const_iterator begin()  const/+ noexcept+/;
    const_iterator cbegin() const/+ noexcept+/ { return begin(); }
    const_iterator end()    const/+ noexcept+/;
    const_iterator cend()   const/+ noexcept+/ { return end(); }
    /+ const_reverse_iterator rbegin()  const noexcept { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator crbegin() const noexcept { return rbegin(); } +/
    /+ const_reverse_iterator rend()    const noexcept { return const_reverse_iterator(begin()); } +/
    /+ const_reverse_iterator crend()   const noexcept { return rend(); } +/

    bool contains(ref const(QPoint) p) const;
    bool contains(ref const(QRect) r) const;

    void translate(int dx, int dy);
    pragma(inline, true) void translate(ref const(QPoint) p) { translate(p.x(), p.y()); }
    /+ [[nodiscard]] +/ QRegion translated(int dx, int dy) const;
    /+ [[nodiscard]] +/ pragma(inline, true) QRegion translated(ref const(QPoint) p) const { return translated(p.x(), p.y()); }

    /+ [[nodiscard]] +/ QRegion united(ref const(QRegion) r) const;
    /+ [[nodiscard]] +/ QRegion united(ref const(QRect) r) const;
    /+ [[nodiscard]] +/ QRegion intersected(ref const(QRegion) r) const;
    /+ [[nodiscard]] +/ QRegion intersected(ref const(QRect) r) const;
    /+ [[nodiscard]] +/ QRegion subtracted(ref const(QRegion) r) const;
    /+ [[nodiscard]] +/ QRegion xored(ref const(QRegion) r) const;

    bool intersects(ref const(QRegion) r) const;
    bool intersects(ref const(QRect) r) const;

    QRect boundingRect() const/+ noexcept+/;
    void setRects(const(QRect)* rect, int num);
    int rectCount() const/+ noexcept+/;

    QRegion opBinary(string op)(ref const(QRegion) r) const if (op == "|");
    QRegion opBinary(string op)(ref const(QRegion) r) const if (op == "+");
    QRegion opBinary(string op)(ref const(QRect) r) const if (op == "+");
    QRegion opBinary(string op)(ref const(QRegion) r) const if (op == "&");
    QRegion opBinary(string op)(ref const(QRect) r) const if (op == "&");
    QRegion opBinary(string op)(ref const(QRegion) r) const if (op == "-");
    /+QRegion operator ^(ref const(QRegion) r) const;+/

    ref QRegion opOpAssign(string op)(ref const(QRegion) r) if (op == "|");
    ref QRegion opOpAssign(string op)(ref const(QRegion) r) if (op == "+");
    ref QRegion opOpAssign(string op)(ref const(QRect) r) if (op == "+");
    ref QRegion opOpAssign(string op)(ref const(QRegion) r) if (op == "&");
    ref QRegion opOpAssign(string op)(ref const(QRect) r) if (op == "&");
    ref QRegion opOpAssign(string op)(ref const(QRegion) r) if (op == "-");
    /+ref QRegion operator ^=(ref const(QRegion) r);+/

    /+bool operator ==(ref const(QRegion) r) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QRegion) r) const { return !(operator==(r)); }+/
    /+auto opCast(T : QVariant)() const;+/

    // Platform specific conversion functions
/+ #if defined(Q_OS_WIN) || defined(Q_QDOC) +/
    static if ((versionIsSet!("Windows") && !versionIsSet!("Cygwin")))
    {
        HRGN toHRGN() const;
        static QRegion fromHRGN(HRGN hrgn);
    }
/+ #endif

#ifndef QT_NO_DATASTREAM +/
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QRegion &); +/
        /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QRegion &); +/
    }
/+ #endif +/
private:
    /+ QRegion copy() const; +/   // helper of detach.
    void detach();
/+ Q_GUI_EXPORT
    friend bool qt_region_strictContains(const QRegion &region,
                                         const QRect &rect); +/
    /+ friend struct QRegionPrivate; +/

    version (QT_NO_DATASTREAM) {} else
    {
        void exec(ref const(QByteArray) ba, int ver = 0, QDataStream.ByteOrder byteOrder = QDataStream.ByteOrder.BigEndian);
    }
    // Workaround for https://issues.dlang.org/show_bug.cgi?id=20701
    extern(C++, struct) struct QRegionData {
        /+ QtPrivate:: +/qt.core.refcount.RefCount ref_;
        QRegionPrivate* qt_rgn;
    }
    version (Windows)
        QRegionData* d;
    else
    {
        union
        {
            const(QRegionData)* d2 = &shared_empty;
            QRegionData* d;
        }
    }
    mixin(mangleWindows("?shared_empty@QRegion@@0UQRegionData@1@B", exportOnWindows ~ q{
    extern static __gshared const(QRegionData) shared_empty;
    }));
    static void cleanUp(QRegionData* x);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED(QRegion)

/*****************************************************************************
  QRegion stream functions
 *****************************************************************************/

#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QRegion &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QRegion &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QRegion &);
#endif +/

