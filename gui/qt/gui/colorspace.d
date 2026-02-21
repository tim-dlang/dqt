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
module qt.gui.colorspace;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.metamacros;
import qt.core.point;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.colortransform;
import qt.helpers;


/// Binding for C++ class [QColorSpace](https://doc.qt.io/qt-5/qcolorspace.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QColorSpace
{
    mixin(Q_GADGET);
public:
    enum NamedColorSpace {
        SRgb = 1,
        SRgbLinear,
        AdobeRgb,
        DisplayP3,
        ProPhotoRgb
    }
    /+ Q_ENUM(NamedColorSpace) +/
    enum /+ class +/ Primaries {
        Custom = 0,
        SRgb,
        AdobeRgb,
        DciP3D65,
        ProPhotoRgb
    }
    /+ Q_ENUM(Primaries) +/
    enum /+ class +/ TransferFunction {
        Custom = 0,
        Linear,
        Gamma,
        SRgb,
        ProPhotoRgb
    }
    /+ Q_ENUM(TransferFunction) +/

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(NamedColorSpace namedColorSpace);
    this(Primaries primaries, TransferFunction fun, float gamma = 0.0f);
    this(Primaries primaries, float gamma);
    this(ref const(QPointF) whitePoint, ref const(QPointF) redPoint,
                    ref const(QPointF) greenPoint, ref const(QPointF) bluePoint,
                    TransferFunction fun, float gamma = 0.0f);
    ~this();

    @disable this(this);
    this(ref const(QColorSpace) colorSpace);
    ref QColorSpace opAssign(ref const(QColorSpace) colorSpace);

    /+ QColorSpace(QColorSpace &&colorSpace) noexcept
            : d_ptr(qExchange(colorSpace.d_ptr, nullptr))
    { } +/
    /+ QColorSpace &operator=(QColorSpace &&colorSpace) noexcept
    {
        // Make the deallocation of this->d_ptr happen in ~QColorSpace()
        QColorSpace(std::move(colorSpace)).swap(*this);
        return *this;
    } +/

    /+ void swap(QColorSpace &colorSpace) noexcept
    { qSwap(d_ptr, colorSpace.d_ptr); } +/

    Primaries primaries() const nothrow;
    TransferFunction transferFunction() const nothrow;
    float gamma() const nothrow;

    void setTransferFunction(TransferFunction transferFunction, float gamma = 0.0f);
    QColorSpace withTransferFunction(TransferFunction transferFunction, float gamma = 0.0f) const;

    void setPrimaries(Primaries primariesId);
    void setPrimaries(ref const(QPointF) whitePoint, ref const(QPointF) redPoint,
                          ref const(QPointF) greenPoint, ref const(QPointF) bluePoint);

    bool isValid() const nothrow;

    /+ friend Q_GUI_EXPORT bool operator==(const QColorSpace &colorSpace1, const QColorSpace &colorSpace2); +/
    /+ friend inline bool operator!=(const QColorSpace &colorSpace1, const QColorSpace &colorSpace2); +/

    static QColorSpace fromIccProfile(ref const(QByteArray) iccProfile);
    QByteArray iccProfile() const;

    QColorTransform transformationToColorSpace(ref const(QColorSpace) colorspace) const;

    /+auto opCast(T : QVariant)() const;+/

private:
    /+ Q_DECLARE_PRIVATE(QColorSpace) +/
    QColorSpacePrivate* d_ptr = null;

/+ #ifndef QT_NO_DEBUG_STREAM
    friend Q_GUI_EXPORT QDebug operator<<(QDebug dbg, const QColorSpace &colorSpace);
#endif +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+bool /+ Q_GUI_EXPORT +/ operator ==(ref const(QColorSpace) colorSpace1, ref const(QColorSpace) colorSpace2);+/
/+pragma(inline, true) bool operator !=(ref const(QColorSpace) colorSpace1, ref const(QColorSpace) colorSpace2)
{
    return !(colorSpace1 == colorSpace2);
}+/

/+ Q_DECLARE_SHARED(QColorSpace)

// QColorSpace stream functions
#if !defined(QT_NO_DATASTREAM)
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QColorSpace &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QColorSpace &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QColorSpace &);
#endif +/

