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
module qt.gui.cursor;
extern(C++):

import qt.config;
import qt.core.metatype;
import qt.core.point;
import qt.gui.screen;
import qt.helpers;
version(QT_NO_CURSOR){}else
{
    import qt.core.namespace;
    import qt.core.variant;
    import qt.gui.bitmap;
    import qt.gui.pixmap;
}

/+ class QVariant;
class QScreen; +/

/*
  ### The fake cursor has to go first with old qdoc.
*/
version(QT_NO_CURSOR)
{

@(QMetaType.Type.QCursor) extern(C++, class) struct /+ Q_GUI_EXPORT +/ QCursor
{
public:
    static QPoint pos();
    static QPoint pos(const(QScreen) screen);
    static void setPos(int x, int y);
    static void setPos(QScreen screen, int x, int y);
    pragma(inline, true) static void setPos(ref const(QPoint) p) { setPos(p.x(), p.y()); }
private:
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

}

version(QT_NO_CURSOR){}else
{

extern(C++, class) struct QCursorData;
/+ class QBitmap;
class QPixmap; +/


@(QMetaType.Type.QCursor) extern(C++, class) struct /+ Q_GUI_EXPORT +/ QCursor
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(/+ Qt:: +/qt.core.namespace.CursorShape shape);
    this(ref const(QBitmap) bitmap, ref const(QBitmap) mask, int hotX=-1, int hotY=-1);
    this(ref const(QPixmap) pixmap, int hotX=-1, int hotY=-1);
    @disable this(this);
    this(ref const(QCursor) cursor);
    ~this();
    /+ref QCursor operator =(ref const(QCursor) cursor);+/
    /+ QCursor(QCursor &&other) noexcept : d(other.d) { other.d = nullptr; } +/
    /+ inline QCursor &operator=(QCursor &&other) noexcept
    { swap(other); return *this; } +/

    /+ void swap(QCursor &other) noexcept { qSwap(d, other.d); } +/

    /+auto opCast(T : QVariant)() const;+/

    /+ Qt:: +/qt.core.namespace.CursorShape shape() const;
    void setShape(/+ Qt:: +/qt.core.namespace.CursorShape newShape);

/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+ QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QBitmap by-value") +/
        const(QBitmap)* bitmap() const; // ### Qt 7: Remove function

    /+ QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QBitmap by-value") +/
        const(QBitmap)* mask() const; // ### Qt 7: Remove function

    QBitmap bitmap(/+ Qt:: +/qt.core.namespace.ReturnByValueConstant) const;
    QBitmap mask(/+ Qt:: +/qt.core.namespace.ReturnByValueConstant) const;
/+ #else
    QBitmap bitmap(Qt::ReturnByValueConstant = Qt::ReturnByValue) const; // ### Qt 7: Remove arg
    QBitmap mask(Qt::ReturnByValueConstant = Qt::ReturnByValue) const; // ### Qt 7: Remove arg
#endif +/ // QT_DEPRECATED_SINCE(5, 15)
    QPixmap pixmap() const;
    QPoint hotSpot() const;

    static QPoint pos();
    static QPoint pos(const(QScreen) screen);
    static void setPos(int x, int y);
    static void setPos(QScreen screen, int x, int y);
    pragma(inline, true) static void setPos(ref const(QPoint) p) { setPos(p.x(), p.y()); }
    pragma(inline, true) static void setPos(QScreen screen, ref const(QPoint) p) { setPos(screen, p.x(), p.y()); }

private:
    /+ friend Q_GUI_EXPORT bool operator==(const QCursor &lhs, const QCursor &rhs) noexcept; +/
    QCursorData* d;
}
/+ Q_DECLARE_SHARED_NOT_MOVABLE_UNTIL_QT6(QCursor) +/

/+/+ Q_GUI_EXPORT +/ bool operator ==(ref const(QCursor) lhs, ref const(QCursor) rhs)/+ noexcept+/;+/
/+pragma(inline, true) bool operator !=(ref const(QCursor) lhs, ref const(QCursor) rhs)/+ noexcept+/ { return !(lhs == rhs); }+/

/*****************************************************************************
  QCursor stream functions
 *****************************************************************************/
/+ #ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &outS, const QCursor &cursor);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &inS, QCursor &cursor);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QCursor &);
#endif +/

}

