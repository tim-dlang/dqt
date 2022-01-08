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
import qt.core.metatype;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.refcount;
import qt.core.typeinfo;
import qt.core.variant;
import qt.core.vector;
import qt.gui.bitmap;
import qt.gui.polygon;
import qt.helpers;
version(QT_NO_DATASTREAM){}else
{
    import qt.core.bytearray;
    import qt.core.datastream;
}

/+ #ifndef QT_NO_DATASTREAM
#endif +/



struct QRegionPrivate;


/// Binding for C++ class [QRegion](https://doc.qt.io/qt-5/qregion.html).
@Q_RELOCATABLE_TYPE @(QMetaType.Type.QRegion) extern(C++, class) struct /+ Q_GUI_EXPORT +/ QRegion
{
public:
    enum RegionType { Rectangle, Ellipse }

    version(Windows)
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
        : d(other.d) { other.d = const_cast<QRegionData*>(&shared_empty); } +/
    this(ref const(QBitmap) bitmap);
    ~this();
    /+ref QRegion operator =(ref const(QRegion) );+/
    /+ inline QRegion &operator=(QRegion &&other) noexcept
    { qSwap(d, other.d); return *this; } +/
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
    /+ Q_REQUIRED_RESULT +/ QRegion translated(int dx, int dy) const;
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QRegion translated(ref const(QPoint) p) const { return translated(p.x(), p.y()); }

    /+ Q_REQUIRED_RESULT +/ QRegion united(ref const(QRegion) r) const;
    /+ Q_REQUIRED_RESULT +/ QRegion united(ref const(QRect) r) const;
    /+ Q_REQUIRED_RESULT +/ QRegion intersected(ref const(QRegion) r) const;
    /+ Q_REQUIRED_RESULT +/ QRegion intersected(ref const(QRect) r) const;
    /+ Q_REQUIRED_RESULT +/ QRegion subtracted(ref const(QRegion) r) const;
    /+ Q_REQUIRED_RESULT +/ QRegion xored(ref const(QRegion) r) const;

/+ #if QT_DEPRECATED_SINCE(5, 0)
    Q_REQUIRED_RESULT inline QT_DEPRECATED QRegion unite(const QRegion &r) const { return united(r); }
    Q_REQUIRED_RESULT inline QT_DEPRECATED QRegion unite(const QRect &r) const { return united(r); }
    Q_REQUIRED_RESULT inline QT_DEPRECATED QRegion intersect(const QRegion &r) const { return intersected(r); }
    Q_REQUIRED_RESULT inline QT_DEPRECATED QRegion intersect(const QRect &r) const { return intersected(r); }
    Q_REQUIRED_RESULT inline QT_DEPRECATED QRegion subtract(const QRegion &r) const { return subtracted(r); }
    Q_REQUIRED_RESULT inline QT_DEPRECATED QRegion eor(const QRegion &r) const { return xored(r); }
#endif +/

    bool intersects(ref const(QRegion) r) const;
    bool intersects(ref const(QRect) r) const;

    QRect boundingRect() const/+ noexcept+/;
/+ #if QT_DEPRECATED_SINCE(5, 11) +/
    /+ QT_DEPRECATED_X("Use begin()/end() instead") +/
        QVector!(QRect) rects() const;
/+ #endif +/
    void setRects(const(QRect)* rect, int num);
    int rectCount() const/+ noexcept+/;
    static if(defined!"Q_COMPILER_MANGLES_RETURN_TYPE")
    {
        // ### Qt 6: remove these, they're kept for MSVC compat
        /+const(QRegion) operator |(ref const(QRegion) r) const;+/
        /+const(QRegion) operator +(ref const(QRegion) r) const;+/
        /+const(QRegion) operator +(ref const(QRect) r) const;+/
        /+const(QRegion) operator &(ref const(QRegion) r) const;+/
        /+const(QRegion) operator &(ref const(QRect) r) const;+/
        /+const(QRegion) operator -(ref const(QRegion) r) const;+/
        /+const(QRegion) operator ^(ref const(QRegion) r) const;+/
    }
    else
    {
        /+QRegion operator |(ref const(QRegion) r) const;+/
        /+QRegion operator +(ref const(QRegion) r) const;+/
        /+QRegion operator +(ref const(QRect) r) const;+/
        /+QRegion operator &(ref const(QRegion) r) const;+/
        /+QRegion operator &(ref const(QRect) r) const;+/
        /+QRegion operator -(ref const(QRegion) r) const;+/
        /+QRegion operator ^(ref const(QRegion) r) const;+/
    }
    ref QRegion opOpAssign(string op)(ref const(QRegion) r) if(op == "|");
    ref QRegion opOpAssign(string op)(ref const(QRegion) r) if(op == "+");
    ref QRegion opOpAssign(string op)(ref const(QRect) r) if(op == "+");
    ref QRegion opOpAssign(string op)(ref const(QRegion) r) if(op == "&");
    ref QRegion opOpAssign(string op)(ref const(QRect) r) if(op == "&");
    ref QRegion opOpAssign(string op)(ref const(QRegion) r) if(op == "-");
    /+ref QRegion operator ^=(ref const(QRegion) r);+/

    /+bool operator ==(ref const(QRegion) r) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QRegion) r) const { return !(operator==(r)); }+/
    /+auto opCast(T : QVariant)() const;+/

    version(QT_NO_DATASTREAM){}else
    {
        /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QRegion &); +/
        /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QRegion &); +/
    }
private:
    /+ QRegion copy() const; +/   // helper of detach.
    void detach();
/+ Q_GUI_EXPORT
    friend bool qt_region_strictContains(const QRegion &region,
                                         const QRect &rect); +/
    /+ friend struct QRegionPrivate; +/

    version(QT_NO_DATASTREAM){}else
    {
        void exec(ref const(QByteArray) ba, int ver = 0, QDataStream.ByteOrder byteOrder = QDataStream.ByteOrder.BigEndian);
    }
    struct QRegionData {
        /+ QtPrivate:: +/qt.core.refcount.RefCount ref_;
        QRegionPrivate* qt_rgn;
    }
    version(Windows)
        QRegionData* d;
    else
    {
        union
        {
            const(QRegionData)* d2 = &shared_empty;
            QRegionData* d;
        }
    }
    extern static __gshared const(QRegionData) shared_empty;
    static void cleanUp(QRegionData* x);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED_NOT_MOVABLE_UNTIL_QT6(QRegion)

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

