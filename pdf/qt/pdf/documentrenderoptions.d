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
module qt.pdf.documentrenderoptions;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.global;
import qt.core.metatype;
import qt.core.rect;
import qt.core.size;
import qt.core.typeinfo;
import qt.helpers;

/// Binding for C++ class [QPdfDocumentRenderOptions](https://doc.qt.io/qt-6/qpdfdocumentrenderoptions.html).
@Q_DECLARE_METATYPE @Q_PRIMITIVE_TYPE extern(C++, class) struct QPdfDocumentRenderOptions
{
public:
    enum /+ class +/ Rotation {
        None,
        Clockwise90,
        Clockwise180,
        Clockwise270
    }

    enum /+ class +/ RenderFlag {
        None = 0x000,
        Annotations = 0x001,
        OptimizedForLcd = 0x002,
        Grayscale = 0x004,
        ForceHalftone = 0x008,
        TextAliased = 0x010,
        ImageAliased = 0x020,
        PathAliased = 0x040
    }
    /+ Q_DECLARE_FLAGS(RenderFlags, RenderFlag) +/
alias RenderFlags = QFlags!(RenderFlag);
    /+this()/+ noexcept+/
    {
        this.m_renderFlags = 0;
        this.m_rotation = 0;
        this.m_reserved = 0;
    }+/

    Rotation rotation() const/+ noexcept+/ { return static_cast!(Rotation)(m_rotation); }
    void setRotation(Rotation r)/+ noexcept+/ { m_rotation = quint32(r); }

    RenderFlags renderFlags() const/+ noexcept+/ { return RenderFlags(cast(RenderFlag) m_renderFlags); }
    void setRenderFlags(RenderFlags r)/+ noexcept+/ { m_renderFlags = quint32(r.toInt()); }

    QRect scaledClipRect() const/+ noexcept+/ { return m_clipRect; }
    void setScaledClipRect(ref const(QRect) r)/+ noexcept+/ { m_clipRect = r; }

    QSize scaledSize() const/+ noexcept+/ { return m_scaledSize; }
    void setScaledSize(ref const(QSize) s)/+ noexcept+/ { m_scaledSize = s; }

private:
    /+ friend constexpr inline bool operator==(const QPdfDocumentRenderOptions &lhs, const QPdfDocumentRenderOptions &rhs) noexcept; +/

    QRect m_clipRect;
    QSize m_scaledSize;

    /+ quint32 m_renderFlags : 8; +/
    uint bitfieldData_m_renderFlags;
    quint32 m_renderFlags() const
    {
        return (bitfieldData_m_renderFlags >> 0) & 0xff;
    }
    quint32 m_renderFlags(quint32 value)
    {
        bitfieldData_m_renderFlags = (bitfieldData_m_renderFlags & ~0xff) | ((value & 0xff) << 0);
        return value;
    }
    /+ quint32 m_rotation    : 3; +/
    quint32 m_rotation() const
    {
        return (bitfieldData_m_renderFlags >> 8) & 0x7;
    }
    quint32 m_rotation(quint32 value)
    {
        bitfieldData_m_renderFlags = (bitfieldData_m_renderFlags & ~0x700) | ((value & 0x7) << 8);
        return value;
    }
    /+ quint32 m_reserved    : 21; +/
    quint32 m_reserved() const
    {
        return (bitfieldData_m_renderFlags >> 11) & 0x1fffff;
    }
    quint32 m_reserved(quint32 value)
    {
        bitfieldData_m_renderFlags = (bitfieldData_m_renderFlags & ~0xfffff800) | ((value & 0x1fffff) << 11);
        return value;
    }
    quint32 m_reserved2 = 0;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) operator |(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, QPdfDocumentRenderOptions.RenderFlags.enum_type f2)/+noexcept+/{return QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) operator |(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) operator &(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, QPdfDocumentRenderOptions.RenderFlags.enum_type f2)/+noexcept+/{return QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) operator &(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) operator ^(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, QPdfDocumentRenderOptions.RenderFlags.enum_type f2)/+noexcept+/{return QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) operator ^(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, QPdfDocumentRenderOptions.RenderFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, QPdfDocumentRenderOptions.RenderFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QPdfDocumentRenderOptions.RenderFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QPdfDocumentRenderOptions.RenderFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QPdfDocumentRenderOptions.RenderFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QPdfDocumentRenderOptions.RenderFlags operator ~(QPdfDocumentRenderOptions.RenderFlags.enum_type e)/+noexcept+/{return~QPdfDocumentRenderOptions.RenderFlags(e);}+/
/+pragma(inline, true) void operator |(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QPdfDocumentRenderOptions.RenderFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_TYPEINFO(QPdfDocumentRenderOptions, Q_PRIMITIVE_TYPE);
Q_DECLARE_OPERATORS_FOR_FLAGS(QPdfDocumentRenderOptions::RenderFlags) +/
/+pragma(inline, true) bool operator ==(ref const(QPdfDocumentRenderOptions) lhs, ref const(QPdfDocumentRenderOptions) rhs)/+ noexcept+/
{
    return lhs.m_clipRect == rhs.m_clipRect && lhs.m_scaledSize == rhs.m_scaledSize &&
            lhs.m_renderFlags == rhs.m_renderFlags && lhs.m_rotation == rhs.m_rotation &&
            lhs.m_reserved == rhs.m_reserved && lhs.m_reserved2 == rhs.m_reserved2; // fix -Wunused-private-field
}+/

/+pragma(inline, true) bool operator !=(ref const(QPdfDocumentRenderOptions) lhs, ref const(QPdfDocumentRenderOptions) rhs)/+ noexcept+/
{
    return !operator==(lhs, rhs);
}+/


/+ Q_DECLARE_METATYPE(QPdfDocumentRenderOptions) +/

