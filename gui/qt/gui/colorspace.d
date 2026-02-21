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
import qt.core.list;
import qt.core.metamacros;
import qt.core.point;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.colortransform;
import qt.helpers;


/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QColorSpacePrivate, Q_GUI_EXPORT) +/
/// Binding for C++ class [QColorSpace](https://doc.qt.io/qt-6/qcolorspace.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QColorSpace
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

    /+ QColorSpace() noexcept = default; +/
    this(NamedColorSpace namedColorSpace);
    this(Primaries primaries, TransferFunction transferFunction, float gamma = 0.0f);
    this(Primaries primaries, float gamma);
    this(Primaries primaries, ref const(QList!(ushort)) transferFunctionTable);
    this(ref const(QPointF) whitePoint, ref const(QPointF) redPoint,
                    ref const(QPointF) greenPoint, ref const(QPointF) bluePoint,
                    TransferFunction transferFunction, float gamma = 0.0f);
    this(ref const(QPointF) whitePoint, ref const(QPointF) redPoint,
                    ref const(QPointF) greenPoint, ref const(QPointF) bluePoint,
                    ref const(QList!(ushort)) transferFunctionTable);
    this(ref const(QPointF) whitePoint, ref const(QPointF) redPoint,
                    ref const(QPointF) greenPoint, ref const(QPointF) bluePoint,
                    ref const(QList!(ushort)) redTransferFunctionTable,
                    ref const(QList!(ushort)) greenTransferFunctionTable,
                    ref const(QList!(ushort)) blueTransferFunctionTable);
    ~this();

    @disable this(this);
    this(ref const(QColorSpace) colorSpace) nothrow;
    /+ref QColorSpace opAssign(ref const(QColorSpace) colorSpace) nothrow
    {
        auto copy = QColorSpace(colorSpace);
        swap(copy);
        return this;
    }+/

    /+ QColorSpace(QColorSpace &&colorSpace) noexcept = default; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QColorSpace) +/

    /+ void swap(QColorSpace &colorSpace) noexcept
    { d_ptr.swap(colorSpace.d_ptr); } +/

    Primaries primaries() const nothrow;
    TransferFunction transferFunction() const nothrow;
    float gamma() const nothrow;

    QString description() const nothrow;
    void setDescription(ref const(QString) description);

    void setTransferFunction(TransferFunction transferFunction, float gamma = 0.0f);
    void setTransferFunction(ref const(QList!(ushort)) transferFunctionTable);
    void setTransferFunctions(ref const(QList!(ushort)) redTransferFunctionTable,
                                  ref const(QList!(ushort)) greenTransferFunctionTable,
                                  ref const(QList!(ushort)) blueTransferFunctionTable);
    QColorSpace withTransferFunction(TransferFunction transferFunction, float gamma = 0.0f) const;
    QColorSpace withTransferFunction(ref const(QList!(ushort)) transferFunctionTable) const;
    QColorSpace withTransferFunctions(ref const(QList!(ushort)) redTransferFunctionTable,
                                          ref const(QList!(ushort)) greenTransferFunctionTable,
                                          ref const(QList!(ushort)) blueTransferFunctionTable) const;

    void setPrimaries(Primaries primariesId);
    void setPrimaries(ref const(QPointF) whitePoint, ref const(QPointF) redPoint,
                          ref const(QPointF) greenPoint, ref const(QPointF) bluePoint);

    void detach();
    bool isValid() const nothrow;

    /+ friend inline bool operator==(const QColorSpace &colorSpace1, const QColorSpace &colorSpace2)
    { return colorSpace1.equals(colorSpace2); } +/
    /+ friend inline bool operator!=(const QColorSpace &colorSpace1, const QColorSpace &colorSpace2)
    { return !(colorSpace1 == colorSpace2); } +/

    static QColorSpace fromIccProfile(ref const(QByteArray) iccProfile);
    QByteArray iccProfile() const;

    QColorTransform transformationToColorSpace(ref const(QColorSpace) colorspace) const;

    /+auto opCast(T : QVariant)() const;+/

private:
    /+ friend class QColorSpacePrivate; +/
    bool equals(ref const(QColorSpace) other) const;

    QExplicitlySharedDataPointer!(QColorSpacePrivate) d_ptr;

/+ #ifndef QT_NO_DEBUG_STREAM
    friend Q_GUI_EXPORT QDebug operator<<(QDebug dbg, const QColorSpace &colorSpace);
#endif +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QColorSpace)

// QColorSpace stream functions
#if !defined(QT_NO_DATASTREAM)
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QColorSpace &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QColorSpace &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QColorSpace &);
#endif +/

