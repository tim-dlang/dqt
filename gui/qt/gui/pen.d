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
module qt.gui.pen;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.namespace;
import qt.core.typeinfo;
import qt.core.variant;
import qt.core.vector;
import qt.gui.brush;
import qt.gui.color;
import qt.helpers;

extern(C++, class) struct QPenPrivate;

/+ #ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QPen &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QPen &);
#endif +/

/// Binding for C++ class [QPen](https://doc.qt.io/qt-5/qpen.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPen
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

    this(/+ Qt:: +/qt.core.namespace.PenStyle);
    this(ref const(QColor) color);
    this(ref const(QBrush) brush, qreal width, /+ Qt:: +/qt.core.namespace.PenStyle s = /+ Qt:: +/qt.core.namespace.PenStyle.SolidLine,
             /+ Qt:: +/qt.core.namespace.PenCapStyle c = /+ Qt:: +/qt.core.namespace.PenCapStyle.SquareCap, /+ Qt:: +/qt.core.namespace.PenJoinStyle j = /+ Qt:: +/qt.core.namespace.PenJoinStyle.BevelJoin);
    @disable this(this);
    this(ref const(QPen) pen)/+ noexcept+/;

    ~this();

    /+ref QPen operator =(ref const(QPen) pen)/+ noexcept+/;+/
    /+ QPen(QPen &&other) noexcept
        : d(other.d) { other.d = nullptr; } +/
    /+ QPen &operator=(QPen &&other) noexcept
    { qSwap(d, other.d); return *this; } +/
    /+ void swap(QPen &other) noexcept { qSwap(d, other.d); } +/

    /+ Qt:: +/qt.core.namespace.PenStyle style() const;
    void setStyle(/+ Qt:: +/qt.core.namespace.PenStyle);

    QVector!(qreal) dashPattern() const;
    void setDashPattern(ref const(QVector!(qreal)) pattern);

    qreal dashOffset() const;
    void setDashOffset(qreal doffset);

    qreal miterLimit() const;
    void setMiterLimit(qreal limit);

    qreal widthF() const;
    void setWidthF(qreal width);

    int width() const;
    void setWidth(int width);

    QColor color() const;
    void setColor(ref const(QColor) color);

    QBrush brush() const;
    void setBrush(ref const(QBrush) brush);

    bool isSolid() const;

    /+ Qt:: +/qt.core.namespace.PenCapStyle capStyle() const;
    void setCapStyle(/+ Qt:: +/qt.core.namespace.PenCapStyle pcs);

    /+ Qt:: +/qt.core.namespace.PenJoinStyle joinStyle() const;
    void setJoinStyle(/+ Qt:: +/qt.core.namespace.PenJoinStyle pcs);

    bool isCosmetic() const;
    void setCosmetic(bool cosmetic);

    /+bool operator ==(ref const(QPen) p) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QPen) p) const { return !(operator==(p)); }+/
    /+auto opCast(T : QVariant)() const;+/

    bool isDetached();
private:
    /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QPen &); +/
    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QPen &); +/

    void detach();
    QPenPrivate* d;

public:
    alias DataPtr = QPenPrivate*;
    pragma(inline, true) ref DataPtr data_ptr() return { return d; }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QPen)

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QPen &);
#endif +/

