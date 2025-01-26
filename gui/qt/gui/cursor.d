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
import qt.core.point;
import qt.core.typeinfo;
import qt.gui.screen;
import qt.helpers;
version (QT_NO_CURSOR) {} else
{
    import qt.core.namespace;
    import qt.core.variant;
    import qt.gui.bitmap;
    import qt.gui.pixmap;
}


/*
  ### The fake cursor has to go first with old qdoc.
*/
version (QT_NO_CURSOR)
{

/// Binding for C++ class [QCursor](https://doc.qt.io/qt-6/qcursor.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QCursor
{
public:
    static QPoint pos();
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static QPoint pos(const(QScreen) screen);
    }));
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

    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

}

version (QT_NO_CURSOR) {} else
{

extern(C++, class) struct QCursorData;


/// Binding for C++ class [QCursor](https://doc.qt.io/qt-6/qcursor.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QCursor
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
    /+ explicit +/this(ref const(QPixmap) pixmap, int hotX=-1, int hotY=-1);
    @disable this(this);
    this(ref const(QCursor) cursor);
    ~this();
    /+ref QCursor operator =(ref const(QCursor) cursor);+/
    /+ QCursor(QCursor &&other) noexcept : d(qExchange(other.d, nullptr)) {} +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QCursor) +/

    /+ void swap(QCursor &other) noexcept { qt_ptr_swap(d, other.d); } +/

    /+auto opCast(T : QVariant)() const;+/

    /+ Qt:: +/qt.core.namespace.CursorShape shape() const;
    void setShape(/+ Qt:: +/qt.core.namespace.CursorShape newShape);

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use the overload without argument instead.") +/
        QBitmap bitmap(/+ Qt:: +/qt.core.namespace.ReturnByValueConstant) const { return bitmap(); }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use the overload without argument instead.") +/
        QBitmap mask(/+ Qt:: +/qt.core.namespace.ReturnByValueConstant) const { return mask(); }
/+ #endif +/ // QT_DEPRECATED_SINCE(6, 0)
    QBitmap bitmap() const;
    QBitmap mask() const;

    QPixmap pixmap() const;
    QPoint hotSpot() const;

    static QPoint pos();
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static QPoint pos(const(QScreen) screen);
    }));
    static void setPos(int x, int y);
    static void setPos(QScreen screen, int x, int y);
    pragma(inline, true) static void setPos(ref const(QPoint) p) { setPos(p.x(), p.y()); }
    pragma(inline, true) static void setPos(QScreen screen, ref const(QPoint) p) { setPos(screen, p.x(), p.y()); }

private:
    /+ friend Q_GUI_EXPORT bool operator==(const QCursor &lhs, const QCursor &rhs) noexcept; +/
    /+ friend inline bool operator!=(const QCursor &lhs, const QCursor &rhs) noexcept { return !(lhs == rhs); } +/
    QCursorData* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED(QCursor)

/*****************************************************************************
  QCursor stream functions
 *****************************************************************************/
#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &outS, const QCursor &cursor);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &inS, QCursor &cursor);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QCursor &);
#endif +/

}

