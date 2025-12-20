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
module qt.gui.colortransform;
extern(C++):

import qt.config;
import qt.core.typeinfo;
import qt.gui.color;
import qt.gui.rgb;
import qt.gui.rgba64;
import qt.helpers;

extern(C++, class) struct QColorSpacePrivate;
extern(C++, class) struct QColorTransformPrivate;

/// Binding for C++ class [QColorTransform](https://doc.qt.io/qt-5/qcolortransform.html).
@Q_MOVABLE_TYPE extern(C++, class) struct QColorTransform
{
public:
    @disable this();
    /+this()/+ noexcept+/
    {
        this.d = null;
    }+/
    /+ Q_GUI_EXPORT +/~this();
    @disable this(this);
    /+ Q_GUI_EXPORT +/this(ref const(QColorTransform) colorTransform)/+ noexcept+/;
    /+ QColorTransform(QColorTransform &&colorTransform) noexcept
            : d{qExchange(colorTransform.d, nullptr)}
    { } +/
    /+ref QColorTransform opAssign(ref const(QColorTransform) other)/+ noexcept+/
    {
        QColorTransform(other).swap(this);
        return this;
    }+/
    /+ QColorTransform &operator=(QColorTransform &&other) noexcept
    {
        QColorTransform{std::move(other)}.swap(*this);
        return *this;
    } +/

    /+ void swap(QColorTransform &other) noexcept { qSwap(d, other.d); } +/

    /+ Q_GUI_EXPORT +/ QRgb map(QRgb argb) const;
    /+ Q_GUI_EXPORT +/ QRgba64 map(QRgba64 rgba64) const;
    /+ Q_GUI_EXPORT +/ QColor map(ref const(QColor) color) const;

private:
    /+ friend class QColorSpace; +/
    /+ friend class QColorSpacePrivate; +/
    /+ friend class QImage; +/

    const(QColorTransformPrivate)* d = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QColorTransform) +/

