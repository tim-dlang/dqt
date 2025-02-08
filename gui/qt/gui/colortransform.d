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
//import qt.core.float16;
import qt.core.shareddata;
import qt.core.typeinfo;
import qt.gui.color;
import qt.gui.rgb;
import qt.gui.rgba64;
import qt.helpers;

extern(C++, class) struct QColorSpacePrivate;
extern(C++, class) struct QColorTransformPrivate;
//extern(C++, class) struct QRgbaFloat;

//alias QRgbaFloat16 = QRgbaFloat!(qfloat16);
//alias QRgbaFloat32 = QRgbaFloat!(float);

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
        QColorTransform(other).swap(this);
        return this;
    }+/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QColorTransform) +/

    /+ void swap(QColorTransform &other) noexcept { d.swap(other.d); } +/
    /+ Q_GUI_EXPORT +/ bool isIdentity() const/+ noexcept+/;

    /+ Q_GUI_EXPORT +/ QRgb map(QRgb argb) const;
    /+ Q_GUI_EXPORT +/ QRgba64 map(QRgba64 rgba64) const;
    // /+ Q_GUI_EXPORT +/ QRgbaFloat16 map(QRgbaFloat16 rgbafp16) const;
    // /+ Q_GUI_EXPORT +/ QRgbaFloat32 map(QRgbaFloat32 rgbafp32) const;
    /+ Q_GUI_EXPORT +/ QColor map(ref const(QColor) color) const;

    /+ friend bool operator==(const QColorTransform &ct1, const QColorTransform &ct2)
    { return ct1.compare(ct2); } +/
    /+ friend bool operator!=(const QColorTransform &ct1, const QColorTransform &ct2)
    { return !ct1.compare(ct2); } +/

private:
    /+ friend class QColorSpacePrivate; +/
    /+ friend class QColorTransformPrivate; +/
    /+ Q_GUI_EXPORT +/ bool compare(ref const(QColorTransform) other) const;

    QExplicitlySharedDataPointer!(QColorTransformPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QColorTransform) +/

