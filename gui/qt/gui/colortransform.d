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
import qt.core.shareddata;
import qt.core.typeinfo;
import qt.gui.color;
import qt.gui.rgb;
import qt.gui.rgba64;
import qt.helpers;

extern(C++, class) struct QColorSpacePrivate;
extern(C++, class) struct QColorTransformPrivate;
/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QColorTransformPrivate, Q_GUI_EXPORT) +/
/// Binding for C++ class [QColorTransform](https://doc.qt.io/qt-6/qcolortransform.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct QColorTransform
{
public:
    /+ QColorTransform() noexcept = default; +/
    /+ Q_GUI_EXPORT +/~this();
    @disable this(this);
    /+ Q_GUI_EXPORT +/this(ref const(QColorTransform) colorTransform)/+ noexcept+/;
    /+ QColorTransform(QColorTransform &&colorTransform) = default; +/
    /+ref QColorTransform operator =(ref const(QColorTransform) other)/+ noexcept+/
    {
        QColorTransform{other}.swap(this);
        return this;
    }+/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QColorTransform) +/

    /+ void swap(QColorTransform &other) noexcept { qSwap(d, other.d); } +/

    /+ Q_GUI_EXPORT +/ QRgb map(QRgb argb) const;
    /+ Q_GUI_EXPORT +/ QRgba64 map(QRgba64 rgba64) const;
    /+ Q_GUI_EXPORT +/ QColor map(ref const(QColor) color) const;

private:
    /+ friend class QColorSpace; +/
    /+ friend class QColorSpacePrivate; +/
    /+ friend class QColorTransformPrivate; +/
    /+ friend class QImage; +/

    QExplicitlySharedDataPointer!(QColorTransformPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QColorTransform) +/

