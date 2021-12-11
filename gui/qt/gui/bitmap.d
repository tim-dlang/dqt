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
module qt.gui.bitmap;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.shareddata;
import qt.core.size;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.color;
import qt.gui.image;
import qt.gui.matrix;
import qt.gui.pixmap;
import qt.gui.transform;
import qt.helpers;

/+ class QVariant; +/

@(QMetaType.Type.QBitmap) @Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QBitmap
{
    public QPixmap base0;
    alias base0 this;
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

    this(ref const(QPixmap) );
    this(int w, int h);
    /+ explicit +/this(ref const(QSize) );
    /+ explicit +/this(ref const(QString) fileName, const(char)* format = null);
    // ### Qt 6: don't inherit QPixmap
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    @disable this(this);
    this(ref const(QBitmap) other)
    {
        this.base0 = QPixmap(other.base0);
    }
    // QBitmap(QBitmap &&other) : QPixmap(std::move(other)) {} // QPixmap doesn't, yet, have a move ctor
    /+ref QBitmap operator =(ref const(QBitmap) other) { QPixmap.operator=(other); return this; }+/
    /+ QBitmap &operator=(QBitmap &&other) noexcept { QPixmap::operator=(std::move(other)); return *this; } +/
    extern(D) ~this()
    {
        // TODO
    }
/+ #endif +/

    /+ref QBitmap operator =(ref const(QPixmap) );+/
    /+ inline void swap(QBitmap &other) { QPixmap::swap(other); } +/ // prevent QBitmap<->QPixmap swaps
    /+auto opCast(T : QVariant)() const;+/

    pragma(inline, true) void clear() { auto tmp = QColor(qt.core.namespace.GlobalColor.color0); fill(tmp); }

    static QBitmap fromImage(ref const(QImage) image, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);
    /+ static QBitmap fromImage(QImage &&image, Qt::ImageConversionFlags flags = Qt::AutoColor); +/
    static QBitmap fromData(ref const(QSize) size, const(uchar)* bits,
                                QImage.Format monoFormat = QImage.Format.Format_MonoLSB);

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use QBitmap::transformed(QTransform) instead") +/
        QBitmap transformed(ref const(QMatrix) ) const;
/+ #endif +/
    QBitmap transformed(ref const(QTransform) matrix) const;

    alias DataPtr = QExplicitlySharedDataPointer!(QPlatformPixmap);
}
/+ Q_DECLARE_SHARED(QBitmap) +/

