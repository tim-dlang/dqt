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
module qt.gui.rgba64;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.typeinfo;
import qt.helpers;

/// Binding for C++ class [QRgba64](https://doc.qt.io/qt-5/qrgba64.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct QRgba64 {
private:
    quint64 rgba;

    // Make sure that the representation always has the order: red green blue alpha, independent
    // of byte order. This way, vector operations that assume 4 16-bit values see the correct ones.
    mixin("enum Shifts {"
        ~ (versionIsSet!("BigEndian") ? q{
    /+ #if Q_BYTE_ORDER == Q_BIG_ENDIAN +/
            RedShift = 48,
            GreenShift = 32,
            BlueShift = 16,
            AlphaShift = 0
        }:q{
    /+ #else +/ // little endian:
            RedShift = 0,
            GreenShift = 16,
            BlueShift = 32,
            AlphaShift = 48
        /+ #endif +/
        })
        ~ "}"
    );

    /+ explicit +/ /+ Q_ALWAYS_INLINE +/ pragma(inline, true) this(quint64 c)
    {
        this.rgba = c;
    }
public:
    /+ QRgba64() = default; +/

    static QRgba64 fromRgba64(quint64 c)
    {
        return QRgba64(c);
    }
    static QRgba64 fromRgba64(quint16 red, quint16 green, quint16 blue, quint16 alpha)
    {
        return fromRgba64(quint64(red)   << Shifts.RedShift
                        | quint64(green) << Shifts.GreenShift
                        | quint64(blue)  << Shifts.BlueShift
                        | quint64(alpha) << Shifts.AlphaShift);
    }
    static QRgba64 fromRgba(quint8 red, quint8 green, quint8 blue, quint8 alpha)
    {
        QRgba64 rgb64 = fromRgba64(red, green, blue, alpha);
        // Expand the range so that 0x00 maps to 0x0000 and 0xff maps to 0xffff.
        rgb64.rgba |= rgb64.rgba << 8;
        return rgb64;
    }
/+    static QRgba64 fromArgb32(uint rgb)
    {
        return fromRgba(cast(quint8) (rgb >> 16), cast(quint8) (rgb >> 8), cast(quint8) (rgb), cast(quint8) (rgb >> 24));
    }
+/
    bool isOpaque() const
    {
        return (rgba & alphaMask()) == alphaMask();
    }
    bool isTransparent() const
    {
        return (rgba & alphaMask()) == 0;
    }

    quint16 red()   const { return cast(quint16) (rgba >> Shifts.RedShift);   }
    quint16 green() const { return cast(quint16) (rgba >> Shifts.GreenShift); }
    quint16 blue()  const { return cast(quint16) (rgba >> Shifts.BlueShift);  }
    quint16 alpha() const { return cast(quint16) (rgba >> Shifts.AlphaShift); }
    void setRed(quint16 _red)     { rgba = (rgba & ~(0xffffuL << Shifts.RedShift))   | (quint64(_red) << Shifts.RedShift); }
    void setGreen(quint16 _green) { rgba = (rgba & ~(0xffffuL << Shifts.GreenShift)) | (quint64(_green) << Shifts.GreenShift); }
    void setBlue(quint16 _blue)   { rgba = (rgba & ~(0xffffuL << Shifts.BlueShift))  | (quint64(_blue) << Shifts.BlueShift); }
    void setAlpha(quint16 _alpha) { rgba = (rgba & ~(0xffffuL << Shifts.AlphaShift)) | (quint64(_alpha) << Shifts.AlphaShift); }

    quint8 red8()   const { return div_257(red()); }
    quint8 green8() const { return div_257(green()); }
    quint8 blue8()  const { return div_257(blue()); }
    quint8 alpha8() const { return div_257(alpha()); }
    uint toArgb32() const
    {
/+ #if defined(__cpp_constexpr) && __cpp_constexpr-0 >= 201304 +/
        quint64 br = rgba & 0xffff0000ffffuL;
        quint64 ag = (rgba >> 16) & 0xffff0000ffffuL;
        br += 0x8000000080uL;
        ag += 0x8000000080uL;
        br = (br - ((br >> 8) & 0xffff0000ffffuL)) >> 8;
        ag = (ag - ((ag >> 8) & 0xffff0000ffffuL));
/+ #if Q_BYTE_ORDER == Q_BIG_ENDIAN +/
        static if (versionIsSet!("BigEndian"))
        {
            return cast(uint) (((br << 24) & 0xff000000)
                 | ((ag >> 24) & 0xff0000)
                 | ((br >> 24) & 0xff00)
                 | ((ag >> 8)  & 0xff));
        }
        else
        {
    /+ #else +/
            return cast(uint) (((ag >> 16) & 0xff000000)
                 | ((br << 16) & 0xff0000)
                 | (ag         & 0xff00)
                 | ((br >> 32) & 0xff));
        }
/+ #endif
#else
        return uint((alpha8() << 24) | (red8() << 16) | (green8() << 8) | blue8());
#endif +/
    }
    ushort toRgb16() const
    {
        return cast(ushort) ((red() & 0xf800) | ((green() >> 10) << 5) | (blue() >> 11));
    }

    QRgba64 premultiplied() const
    {
        if (isOpaque())
            return this;
        if (isTransparent())
            return QRgba64.fromRgba64(0);
        const(quint64) a = alpha();
        quint64 br = (rgba & 0xffff0000ffffuL) * a;
        quint64 ag = ((rgba >> 16) & 0xffff0000ffffuL) * a;
        br = (br + ((br >> 16) & 0xffff0000ffffuL) + 0x800000008000uL);
        ag = (ag + ((ag >> 16) & 0xffff0000ffffuL) + 0x800000008000uL);
        static if (versionIsSet!("BigEndian"))
        {
            ag = ag & 0xffff0000ffff0000uL;
            br = (br >> 16) & 0xffff00000000uL;
            return fromRgba64(a | br | ag);
        }
        else
        {
            br = (br >> 16) & 0xffff0000ffffuL;
            ag = ag & 0xffff0000uL;
            return fromRgba64((a << 48) | br | ag);
        }
    }

/+    QRgba64 unpremultiplied() const
    {
        static if (configValue!"Q_PROCESSOR_WORDSIZE" < 8)
        {
            return unpremultiplied_32bit();
        }
        else
        {
            return unpremultiplied_64bit();
        }
    }
+/
    /+auto opCast(T : quint64)() const
    {
        return rgba;
    }+/

    /+QRgba64 operator =(quint64 _rgba)
    {
        rgba = _rgba;
        return this;
    }+/

private:
    /+ Q_ALWAYS_INLINE +/ pragma(inline, true) static quint64 alphaMask() { return 0xffffuL << Shifts.AlphaShift; }

    /+ Q_ALWAYS_INLINE +/ pragma(inline, true) static quint8 div_257_floor(uint x) { return cast(quint8) ((x - (x >> 8)) >> 8); }
    /+ Q_ALWAYS_INLINE +/ pragma(inline, true) static quint8 div_257(quint16 x) { return div_257_floor(x + 128U); }
    /+ Q_ALWAYS_INLINE +/ pragma(inline, true) QRgba64 unpremultiplied_32bit() const
    {
        if (isOpaque() || isTransparent())
            return this;
        const(quint32) a = alpha();
        const(quint16) r = cast(quint16) ((red()   * 0xffff + a/2) / a);
        const(quint16) g = cast(quint16) ((green() * 0xffff + a/2) / a);
        const(quint16) b = cast(quint16) ((blue()  * 0xffff + a/2) / a);
        return fromRgba64(r, g, b, cast(quint16) (a));
    }
    /+ Q_ALWAYS_INLINE +/ pragma(inline, true) QRgba64 unpremultiplied_64bit() const
    {
        if (isOpaque() || isTransparent())
            return this;
        const(quint64) a = alpha();
        const(quint64) fa = (0xffff00008000uL + a/2) / a;
        const(quint16) r = cast(quint16) ((red()   * fa + 0x80000000) >> 32);
        const(quint16) g = cast(quint16) ((green() * fa + 0x80000000) >> 32);
        const(quint16) b = cast(quint16) ((blue()  * fa + 0x80000000) >> 32);
        return fromRgba64(r, g, b, cast(quint16) (a));
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QRgba64, Q_PRIMITIVE_TYPE); +/

pragma(inline, true) QRgba64 qRgba64(quint16 r, quint16 g, quint16 b, quint16 a)
{
    return QRgba64.fromRgba64(r, g, b, a);
}

pragma(inline, true) QRgba64 qRgba64(quint64 c)
{
    return QRgba64.fromRgba64(c);
}

/+pragma(inline, true) QRgba64 qPremultiply(QRgba64 c)
{
    return c.premultiplied();
}

pragma(inline, true) QRgba64 qUnpremultiply(QRgba64 c)
{
    return c.unpremultiplied();
}

pragma(inline, true) uint qRed(QRgba64 rgb)
{ return rgb.red8(); }

pragma(inline, true) uint qGreen(QRgba64 rgb)
{ return rgb.green8(); }

pragma(inline, true) uint qBlue(QRgba64 rgb)
{ return rgb.blue8(); }

pragma(inline, true) uint qAlpha(QRgba64 rgb)
{ return rgb.alpha8(); }
+/

