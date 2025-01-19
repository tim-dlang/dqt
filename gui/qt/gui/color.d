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
module qt.gui.color;
extern(C++):

import qt.config;
import qt.core.namespace;
import qt.core.string;
import qt.core.stringlist;
import qt.core.stringview;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.rgb;
import qt.gui.rgba64;
import qt.helpers;

extern(C++, class) struct QColormap;

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QColor &);
#endif
#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QColor &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QColor &);
#endif +/

/// Binding for C++ class [QColor](https://doc.qt.io/qt-6/qcolor.html).
@SimulateImplicitConstructor @Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QColor
{
public:
    enum Spec { Invalid, Rgb, Hsv, Cmyk, Hsl, ExtendedRgb }
    enum NameFormat { HexRgb, HexArgb }

    /+this()/+ noexcept+/
    {
        this.cspec = Spec.Invalid;
        this.ct = typeof(this.ct)(ushort.max, 0, 0, 0, 0);
    }+/
    @SimulateImplicitConstructor this(/+ Qt:: +/qt.core.namespace.GlobalColor color)/+ noexcept+/;
    this(int r, int g, int b, int a = 255)/+ noexcept+/
    {
        this.cspec = isRgbaValid(r, g, b, a) ? Spec.Rgb : Spec.Invalid;
        this.ct = CT(CT.generated_qcolor_0(cast(ushort) (cspec == Spec.Rgb ? a * 0x0101 : 0),
                     cast(ushort) (cspec == Spec.Rgb ? r * 0x0101 : 0),
                     cast(ushort) (cspec == Spec.Rgb ? g * 0x0101 : 0),
                     cast(ushort) (cspec == Spec.Rgb ? b * 0x0101 : 0),
                     0));
    }
    this(QRgb rgb)/+ noexcept+/;
    this(QRgba64 rgba64)/+ noexcept+/;
    static if (QT_STRINGVIEW_LEVEL < 2)
    {
        pragma(inline, true) this(ref const(QString) aname)
        { setNamedColor(aname); }
    }
    /+ explicit +/ pragma(inline, true) this(QStringView aname)
    { setNamedColor(aname); }
    pragma(inline, true) this(const(char)* aname)
    {
        this(QLatin1String(aname));
    }
    pragma(inline, true) this(QLatin1String aname)
    { setNamedColor(aname); }
    this(Spec spec)/+ noexcept+/;

    /+ref QColor operator =(/+ Qt:: +/qt.core.namespace.GlobalColor color)/+ noexcept+/;+/

    pragma(inline, true) bool isValid() const/+ noexcept+/
    { return cspec != Spec.Invalid; }

    QString name(NameFormat format = NameFormat.HexRgb) const;

    static if (QT_STRINGVIEW_LEVEL < 2)
    {
        void setNamedColor(ref const(QString) name);
    }
    void setNamedColor(QStringView name);
    void setNamedColor(QLatin1String name);

    static QStringList colorNames();

    pragma(inline, true) Spec spec() const/+ noexcept+/
    { return cspec; }

    int alpha() const/+ noexcept+/;
    void setAlpha(int alpha);

    float alphaF() const/+ noexcept+/;
    void setAlphaF(float alpha);

    int red() const/+ noexcept+/;
    int green() const/+ noexcept+/;
    int blue() const/+ noexcept+/;
    void setRed(int red);
    void setGreen(int green);
    void setBlue(int blue);

    float redF() const/+ noexcept+/;
    float greenF() const/+ noexcept+/;
    float blueF() const/+ noexcept+/;
    void setRedF(float red);
    void setGreenF(float green);
    void setBlueF(float blue);

    void getRgb(int* r, int* g, int* b, int* a = null) const;
    void setRgb(int r, int g, int b, int a = 255);

    void getRgbF(float* r, float* g, float* b, float* a = null) const;
    void setRgbF(float r, float g, float b, float a = 1.0);

    QRgba64 rgba64() const/+ noexcept+/;
    void setRgba64(QRgba64 rgba)/+ noexcept+/;

    QRgb rgba() const/+ noexcept+/;
    void setRgba(QRgb rgba)/+ noexcept+/;

    QRgb rgb() const/+ noexcept+/;
    void setRgb(QRgb rgb)/+ noexcept+/;

    int hue() const/+ noexcept+/; // 0 <= hue < 360
    int saturation() const/+ noexcept+/;
    int hsvHue() const/+ noexcept+/; // 0 <= hue < 360
    int hsvSaturation() const/+ noexcept+/;
    int value() const/+ noexcept+/;

    float hueF() const/+ noexcept+/; // 0.0 <= hueF < 360.0
    float saturationF() const/+ noexcept+/;
    float hsvHueF() const/+ noexcept+/; // 0.0 <= hueF < 360.0
    float hsvSaturationF() const/+ noexcept+/;
    float valueF() const/+ noexcept+/;

    void getHsv(int* h, int* s, int* v, int* a = null) const;
    void setHsv(int h, int s, int v, int a = 255);

    void getHsvF(float* h, float* s, float* v, float* a = null) const;
    void setHsvF(float h, float s, float v, float a = 1.0);

    int cyan() const/+ noexcept+/;
    int magenta() const/+ noexcept+/;
    int yellow() const/+ noexcept+/;
    int black() const/+ noexcept+/;

    float cyanF() const/+ noexcept+/;
    float magentaF() const/+ noexcept+/;
    float yellowF() const/+ noexcept+/;
    float blackF() const/+ noexcept+/;

    void getCmyk(int* c, int* m, int* y, int* k, int* a = null) const;
    void setCmyk(int c, int m, int y, int k, int a = 255);

    void getCmykF(float* c, float* m, float* y, float* k, float* a = null) const;
    void setCmykF(float c, float m, float y, float k, float a = 1.0);

    int hslHue() const/+ noexcept+/; // 0 <= hue < 360
    int hslSaturation() const/+ noexcept+/;
    int lightness() const/+ noexcept+/;

    float hslHueF() const/+ noexcept+/; // 0.0 <= hueF < 360.0
    float hslSaturationF() const/+ noexcept+/;
    float lightnessF() const/+ noexcept+/;

    void getHsl(int* h, int* s, int* l, int* a = null) const;
    void setHsl(int h, int s, int l, int a = 255);

    void getHslF(float* h, float* s, float* l, float* a = null) const;
    void setHslF(float h, float s, float l, float a = 1.0);

    QColor toRgb() const/+ noexcept+/;
    QColor toHsv() const/+ noexcept+/;
    QColor toCmyk() const/+ noexcept+/;
    QColor toHsl() const/+ noexcept+/;
    QColor toExtendedRgb() const/+ noexcept+/;

    /+ [[nodiscard]] +/ QColor convertTo(Spec colorSpec) const/+ noexcept+/;

    static QColor fromRgb(QRgb rgb)/+ noexcept+/;
    static QColor fromRgba(QRgb rgba)/+ noexcept+/;

    static QColor fromRgb(int r, int g, int b, int a = 255);
    static QColor fromRgbF(float r, float g, float b, float a = 1.0);

    static QColor fromRgba64(ushort r, ushort g, ushort b, ushort a = ushort.max)/+ noexcept+/;
    static QColor fromRgba64(QRgba64 rgba)/+ noexcept+/;

    static QColor fromHsv(int h, int s, int v, int a = 255);
    static QColor fromHsvF(float h, float s, float v, float a = 1.0);

    static QColor fromCmyk(int c, int m, int y, int k, int a = 255);
    static QColor fromCmykF(float c, float m, float y, float k, float a = 1.0);

    static QColor fromHsl(int h, int s, int l, int a = 255);
    static QColor fromHslF(float h, float s, float l, float a = 1.0);

    /+ [[nodiscard]] +/ QColor lighter(int f = 150) const/+ noexcept+/;
    /+ [[nodiscard]] +/ QColor darker(int f = 200) const/+ noexcept+/;

    bool opEquals(ref const(QColor) c) const/+ noexcept+/;
    bool opEquals(const(QColor) c) const/+ noexcept+/
    {
        return opEquals(c);
    }
    /+bool operator !=(ref const(QColor) c) const/+ noexcept+/;+/

    /+auto opCast(T : QVariant)() const;+/

    static if (QT_STRINGVIEW_LEVEL < 2)
    {
        static bool isValidColor(ref const(QString) name);
    }
    static bool isValidColor(QStringView)/+ noexcept+/;
    static bool isValidColor(QLatin1String)/+ noexcept+/;

private:

    void invalidate()/+ noexcept+/;
    /+ template <typename String> +/
    bool setColorFromString(String)(String name);

    static bool isRgbaValid(int r, int g, int b, int a = 255)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/
    __attribute__((const))+/    {
        return uint(r) <= 255 && uint(g) <= 255 && uint(b) <= 255 && uint(a) <= 255;
    }

    Spec cspec = Spec.Invalid;
    union CT {
/+ #ifdef Q_COMPILER_UNIFORM_INIT
        CT() {} // doesn't init anything, thus can't be constexpr
        constexpr explicit CT(ushort a1, ushort a2, ushort a3, ushort a4, ushort a5) noexcept
            : array{a1, a2, a3, a4, a5} {}
#endif +/
        struct generated_qcolor_0 {
            ushort alpha;
            ushort red;
            ushort green;
            ushort blue;
            ushort pad;
        }generated_qcolor_0 argb;
        struct generated_qcolor_1 {
            ushort alpha;
            ushort hue;
            ushort saturation;
            ushort value;
            ushort pad;
        }generated_qcolor_1 ahsv;
        struct generated_qcolor_2 {
            ushort alpha;
            ushort cyan;
            ushort magenta;
            ushort yellow;
            ushort black;
        }generated_qcolor_2 acmyk;
        struct generated_qcolor_3 {
            ushort alpha;
            ushort hue;
            ushort saturation;
            ushort lightness;
            ushort pad;
        }generated_qcolor_3 ahsl;
        struct generated_qcolor_4 {
            ushort alphaF16;
            ushort redF16;
            ushort greenF16;
            ushort blueF16;
            ushort pad;
        }generated_qcolor_4 argbExtended;
        ushort[5] array;
    }CT ct = CT(CT.generated_qcolor_0(ushort.max, 0, 0, 0, 0));

    static QColor fromRGBInternal(ushort alpha, ushort red, ushort green, ushort blue)
    {
        QColor r;
        r.cspec = Spec.Rgb;
        r.ct = CT(CT.generated_qcolor_0(alpha, red, green, blue, 0));
        return r;
    }

    /+ friend class QColormap; +/
/+ #ifndef QT_NO_DATASTREAM +/
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QColor &); +/
        /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QColor &); +/
    }
/+ #endif

#ifdef Q_COMPILER_UNIFORM_INIT
public: // can't give friendship to a namespace, so it needs to be public
    constexpr explicit QColor(Spec spec, ushort a1, ushort a2, ushort a3, ushort a4, ushort a5=0) noexcept
        : cspec(spec), ct(a1, a2, a3, a4, a5) {}
#endif +/ // Q_COMPILER_UNIFORM_INIT
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QColor, Q_RELOCATABLE_TYPE);

#if QT_STRINGVIEW_LEVEL < 2
#endif +/

extern(D)
//extern(C++, "QColorConstants")
{
    // Qt::GlobalColor names
    immutable QColor Color0       = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x00 * 0x101);
    immutable QColor Color1       = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101);
    immutable QColor Black        = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x00 * 0x101);
    immutable QColor White        = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101);
    immutable QColor DarkGray     = QColor.fromRGBInternal(0xff * 0x101, 0x80 * 0x101, 0x80 * 0x101, 0x80 * 0x101);
    immutable QColor Gray         = QColor.fromRGBInternal(0xff * 0x101, 0xa0 * 0x101, 0xa0 * 0x101, 0xa4 * 0x101);
    immutable QColor LightGray    = QColor.fromRGBInternal(0xff * 0x101, 0xc0 * 0x101, 0xc0 * 0x101, 0xc0 * 0x101);
    immutable QColor Red          = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101);
    immutable QColor Green        = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0xff * 0x101, 0x00 * 0x101);
    immutable QColor Blue         = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0xff * 0x101);
    immutable QColor Cyan         = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0xff * 0x101, 0xff * 0x101);
    immutable QColor Magenta      = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0x00 * 0x101, 0xff * 0x101);
    immutable QColor Yellow       = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0x00 * 0x101);
    immutable QColor DarkRed      = QColor.fromRGBInternal(0xff * 0x101, 0x80 * 0x101, 0x00 * 0x101, 0x00 * 0x101);
    immutable QColor DarkGreen    = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x80 * 0x101, 0x00 * 0x101);
    immutable QColor DarkBlue     = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x80 * 0x101);
    immutable QColor DarkCyan     = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x80 * 0x101, 0x80 * 0x101);
    immutable QColor DarkMagenta  = QColor.fromRGBInternal(0xff * 0x101, 0x80 * 0x101, 0x00 * 0x101, 0x80 * 0x101);
    immutable QColor DarkYellow   = QColor.fromRGBInternal(0xff * 0x101, 0x80 * 0x101, 0x80 * 0x101, 0x00 * 0x101);
    immutable QColor Transparent  = QColor.fromRGBInternal(0x00 * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x00 * 0x101);

    // SVG names supported by QColor (see qcolor.cpp).
//extern(C++, "Svg") {
    immutable QColor aliceblue                 = QColor.fromRGBInternal(0xff * 0x101, 0xf0 * 0x101, 0xf8 * 0x101, 0xff * 0x101);
    immutable QColor antiquewhite              = QColor.fromRGBInternal(0xff * 0x101, 0xfa * 0x101, 0xeb * 0x101, 0xd7 * 0x101);
    immutable QColor aqua                      = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0xff * 0x101, 0xff * 0x101);
    immutable QColor aquamarine                = QColor.fromRGBInternal(0xff * 0x101, 0x7f * 0x101, 0xff * 0x101, 0xd4 * 0x101);
    immutable QColor azure                     = QColor.fromRGBInternal(0xff * 0x101, 0xf0 * 0x101, 0xff * 0x101, 0xff * 0x101);
    immutable QColor beige                     = QColor.fromRGBInternal(0xff * 0x101, 0xf5 * 0x101, 0xf5 * 0x101, 0xdc * 0x101);
    immutable QColor bisque                    = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xe4 * 0x101, 0xc4 * 0x101);
    immutable QColor black                     = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x00 * 0x101);
    immutable QColor blanchedalmond            = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xeb * 0x101, 0xcd * 0x101);
    immutable QColor blue                      = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0xff * 0x101);
    immutable QColor blueviolet                = QColor.fromRGBInternal(0xff * 0x101, 0x8a * 0x101, 0x2b * 0x101, 0xe2 * 0x101);
    immutable QColor brown                     = QColor.fromRGBInternal(0xff * 0x101, 0xa5 * 0x101, 0x2a * 0x101, 0x2a * 0x101);
    immutable QColor burlywood                 = QColor.fromRGBInternal(0xff * 0x101, 0xde * 0x101, 0xb8 * 0x101, 0x87 * 0x101);
    immutable QColor cadetblue                 = QColor.fromRGBInternal(0xff * 0x101, 0x5f * 0x101, 0x9e * 0x101, 0xa0 * 0x101);
    immutable QColor chartreuse                = QColor.fromRGBInternal(0xff * 0x101, 0x7f * 0x101, 0xff * 0x101, 0x00 * 0x101);
    immutable QColor chocolate                 = QColor.fromRGBInternal(0xff * 0x101, 0xd2 * 0x101, 0x69 * 0x101, 0x1e * 0x101);
    immutable QColor coral                     = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0x7f * 0x101, 0x50 * 0x101);
    immutable QColor cornflowerblue            = QColor.fromRGBInternal(0xff * 0x101, 0x64 * 0x101, 0x95 * 0x101, 0xed * 0x101);
    immutable QColor cornsilk                  = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xf8 * 0x101, 0xdc * 0x101);
    immutable QColor crimson                   = QColor.fromRGBInternal(0xff * 0x101, 0xdc * 0x101, 0x14 * 0x101, 0x3c * 0x101);
    immutable QColor cyan                      = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0xff * 0x101, 0xff * 0x101);
    immutable QColor darkblue                  = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x8b * 0x101);
    immutable QColor darkcyan                  = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x8b * 0x101, 0x8b * 0x101);
    immutable QColor darkgoldenrod             = QColor.fromRGBInternal(0xff * 0x101, 0xb8 * 0x101, 0x86 * 0x101, 0x0b * 0x101);
    immutable QColor darkgray                  = QColor.fromRGBInternal(0xff * 0x101, 0xa9 * 0x101, 0xa9 * 0x101, 0xa9 * 0x101);
    immutable QColor darkgreen                 = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x64 * 0x101, 0x00 * 0x101);
    immutable QColor darkgrey                  = QColor.fromRGBInternal(0xff * 0x101, 0xa9 * 0x101, 0xa9 * 0x101, 0xa9 * 0x101);
    immutable QColor darkkhaki                 = QColor.fromRGBInternal(0xff * 0x101, 0xbd * 0x101, 0xb7 * 0x101, 0x6b * 0x101);
    immutable QColor darkmagenta               = QColor.fromRGBInternal(0xff * 0x101, 0x8b * 0x101, 0x00 * 0x101, 0x8b * 0x101);
    immutable QColor darkolivegreen            = QColor.fromRGBInternal(0xff * 0x101, 0x55 * 0x101, 0x6b * 0x101, 0x2f * 0x101);
    immutable QColor darkorange                = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0x8c * 0x101, 0x00 * 0x101);
    immutable QColor darkorchid                = QColor.fromRGBInternal(0xff * 0x101, 0x99 * 0x101, 0x32 * 0x101, 0xcc * 0x101);
    immutable QColor darkred                   = QColor.fromRGBInternal(0xff * 0x101, 0x8b * 0x101, 0x00 * 0x101, 0x00 * 0x101);
    immutable QColor darksalmon                = QColor.fromRGBInternal(0xff * 0x101, 0xe9 * 0x101, 0x96 * 0x101, 0x7a * 0x101);
    immutable QColor darkseagreen              = QColor.fromRGBInternal(0xff * 0x101, 0x8f * 0x101, 0xbc * 0x101, 0x8f * 0x101);
    immutable QColor darkslateblue             = QColor.fromRGBInternal(0xff * 0x101, 0x48 * 0x101, 0x3d * 0x101, 0x8b * 0x101);
    immutable QColor darkslategray             = QColor.fromRGBInternal(0xff * 0x101, 0x2f * 0x101, 0x4f * 0x101, 0x4f * 0x101);
    immutable QColor darkslategrey             = QColor.fromRGBInternal(0xff * 0x101, 0x2f * 0x101, 0x4f * 0x101, 0x4f * 0x101);
    immutable QColor darkturquoise             = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0xce * 0x101, 0xd1 * 0x101);
    immutable QColor darkviolet                = QColor.fromRGBInternal(0xff * 0x101, 0x94 * 0x101, 0x00 * 0x101, 0xd3 * 0x101);
    immutable QColor deeppink                  = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0x14 * 0x101, 0x93 * 0x101);
    immutable QColor deepskyblue               = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0xbf * 0x101, 0xff * 0x101);
    immutable QColor dimgray                   = QColor.fromRGBInternal(0xff * 0x101, 0x69 * 0x101, 0x69 * 0x101, 0x69 * 0x101);
    immutable QColor dimgrey                   = QColor.fromRGBInternal(0xff * 0x101, 0x69 * 0x101, 0x69 * 0x101, 0x69 * 0x101);
    immutable QColor dodgerblue                = QColor.fromRGBInternal(0xff * 0x101, 0x1e * 0x101, 0x90 * 0x101, 0xff * 0x101);
    immutable QColor firebrick                 = QColor.fromRGBInternal(0xff * 0x101, 0xb2 * 0x101, 0x22 * 0x101, 0x22 * 0x101);
    immutable QColor floralwhite               = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xfa * 0x101, 0xf0 * 0x101);
    immutable QColor forestgreen               = QColor.fromRGBInternal(0xff * 0x101, 0x22 * 0x101, 0x8b * 0x101, 0x22 * 0x101);
    immutable QColor fuchsia                   = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0x00 * 0x101, 0xff * 0x101);
    immutable QColor gainsboro                 = QColor.fromRGBInternal(0xff * 0x101, 0xdc * 0x101, 0xdc * 0x101, 0xdc * 0x101);
    immutable QColor ghostwhite                = QColor.fromRGBInternal(0xff * 0x101, 0xf8 * 0x101, 0xf8 * 0x101, 0xff * 0x101);
    immutable QColor gold                      = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xd7 * 0x101, 0x00 * 0x101);
    immutable QColor goldenrod                 = QColor.fromRGBInternal(0xff * 0x101, 0xda * 0x101, 0xa5 * 0x101, 0x20 * 0x101);
    immutable QColor gray                      = QColor.fromRGBInternal(0xff * 0x101, 0x80 * 0x101, 0x80 * 0x101, 0x80 * 0x101);
    immutable QColor green                     = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x80 * 0x101, 0x00 * 0x101);
    immutable QColor greenyellow               = QColor.fromRGBInternal(0xff * 0x101, 0xad * 0x101, 0xff * 0x101, 0x2f * 0x101);
    immutable QColor grey                      = QColor.fromRGBInternal(0xff * 0x101, 0x80 * 0x101, 0x80 * 0x101, 0x80 * 0x101);
    immutable QColor honeydew                  = QColor.fromRGBInternal(0xff * 0x101, 0xf0 * 0x101, 0xff * 0x101, 0xf0 * 0x101);
    immutable QColor hotpink                   = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0x69 * 0x101, 0xb4 * 0x101);
    immutable QColor indianred                 = QColor.fromRGBInternal(0xff * 0x101, 0xcd * 0x101, 0x5c * 0x101, 0x5c * 0x101);
    immutable QColor indigo                    = QColor.fromRGBInternal(0xff * 0x101, 0x4b * 0x101, 0x00 * 0x101, 0x82 * 0x101);
    immutable QColor ivory                     = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0xf0 * 0x101);
    immutable QColor khaki                     = QColor.fromRGBInternal(0xff * 0x101, 0xf0 * 0x101, 0xe6 * 0x101, 0x8c * 0x101);
    immutable QColor lavender                  = QColor.fromRGBInternal(0xff * 0x101, 0xe6 * 0x101, 0xe6 * 0x101, 0xfa * 0x101);
    immutable QColor lavenderblush             = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xf0 * 0x101, 0xf5 * 0x101);
    immutable QColor lawngreen                 = QColor.fromRGBInternal(0xff * 0x101, 0x7c * 0x101, 0xfc * 0x101, 0x00 * 0x101);
    immutable QColor lemonchiffon              = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xfa * 0x101, 0xcd * 0x101);
    immutable QColor lightblue                 = QColor.fromRGBInternal(0xff * 0x101, 0xad * 0x101, 0xd8 * 0x101, 0xe6 * 0x101);
    immutable QColor lightcoral                = QColor.fromRGBInternal(0xff * 0x101, 0xf0 * 0x101, 0x80 * 0x101, 0x80 * 0x101);
    immutable QColor lightcyan                 = QColor.fromRGBInternal(0xff * 0x101, 0xe0 * 0x101, 0xff * 0x101, 0xff * 0x101);
    immutable QColor lightgoldenrodyellow      = QColor.fromRGBInternal(0xff * 0x101, 0xfa * 0x101, 0xfa * 0x101, 0xd2 * 0x101);
    immutable QColor lightgray                 = QColor.fromRGBInternal(0xff * 0x101, 0xd3 * 0x101, 0xd3 * 0x101, 0xd3 * 0x101);
    immutable QColor lightgreen                = QColor.fromRGBInternal(0xff * 0x101, 0x90 * 0x101, 0xee * 0x101, 0x90 * 0x101);
    immutable QColor lightgrey                 = QColor.fromRGBInternal(0xff * 0x101, 0xd3 * 0x101, 0xd3 * 0x101, 0xd3 * 0x101);
    immutable QColor lightpink                 = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xb6 * 0x101, 0xc1 * 0x101);
    immutable QColor lightsalmon               = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xa0 * 0x101, 0x7a * 0x101);
    immutable QColor lightseagreen             = QColor.fromRGBInternal(0xff * 0x101, 0x20 * 0x101, 0xb2 * 0x101, 0xaa * 0x101);
    immutable QColor lightskyblue              = QColor.fromRGBInternal(0xff * 0x101, 0x87 * 0x101, 0xce * 0x101, 0xfa * 0x101);
    immutable QColor lightslategray            = QColor.fromRGBInternal(0xff * 0x101, 0x77 * 0x101, 0x88 * 0x101, 0x99 * 0x101);
    immutable QColor lightslategrey            = QColor.fromRGBInternal(0xff * 0x101, 0x77 * 0x101, 0x88 * 0x101, 0x99 * 0x101);
    immutable QColor lightsteelblue            = QColor.fromRGBInternal(0xff * 0x101, 0xb0 * 0x101, 0xc4 * 0x101, 0xde * 0x101);
    immutable QColor lightyellow               = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0xe0 * 0x101);
    immutable QColor lime                      = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0xff * 0x101, 0x00 * 0x101);
    immutable QColor limegreen                 = QColor.fromRGBInternal(0xff * 0x101, 0x32 * 0x101, 0xcd * 0x101, 0x32 * 0x101);
    immutable QColor linen                     = QColor.fromRGBInternal(0xff * 0x101, 0xfa * 0x101, 0xf0 * 0x101, 0xe6 * 0x101);
    immutable QColor magenta                   = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0x00 * 0x101, 0xff * 0x101);
    immutable QColor maroon                    = QColor.fromRGBInternal(0xff * 0x101, 0x80 * 0x101, 0x00 * 0x101, 0x00 * 0x101);
    immutable QColor mediumaquamarine          = QColor.fromRGBInternal(0xff * 0x101, 0x66 * 0x101, 0xcd * 0x101, 0xaa * 0x101);
    immutable QColor mediumblue                = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0xcd * 0x101);
    immutable QColor mediumorchid              = QColor.fromRGBInternal(0xff * 0x101, 0xba * 0x101, 0x55 * 0x101, 0xd3 * 0x101);
    immutable QColor mediumpurple              = QColor.fromRGBInternal(0xff * 0x101, 0x93 * 0x101, 0x70 * 0x101, 0xdb * 0x101);
    immutable QColor mediumseagreen            = QColor.fromRGBInternal(0xff * 0x101, 0x3c * 0x101, 0xb3 * 0x101, 0x71 * 0x101);
    immutable QColor mediumslateblue           = QColor.fromRGBInternal(0xff * 0x101, 0x7b * 0x101, 0x68 * 0x101, 0xee * 0x101);
    immutable QColor mediumspringgreen         = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0xfa * 0x101, 0x9a * 0x101);
    immutable QColor mediumturquoise           = QColor.fromRGBInternal(0xff * 0x101, 0x48 * 0x101, 0xd1 * 0x101, 0xcc * 0x101);
    immutable QColor mediumvioletred           = QColor.fromRGBInternal(0xff * 0x101, 0xc7 * 0x101, 0x15 * 0x101, 0x85 * 0x101);
    immutable QColor midnightblue              = QColor.fromRGBInternal(0xff * 0x101, 0x19 * 0x101, 0x19 * 0x101, 0x70 * 0x101);
    immutable QColor mintcream                 = QColor.fromRGBInternal(0xff * 0x101, 0xf5 * 0x101, 0xff * 0x101, 0xfa * 0x101);
    immutable QColor mistyrose                 = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xe4 * 0x101, 0xe1 * 0x101);
    immutable QColor moccasin                  = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xe4 * 0x101, 0xb5 * 0x101);
    immutable QColor navajowhite               = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xde * 0x101, 0xad * 0x101);
    immutable QColor navy                      = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x80 * 0x101);
    immutable QColor oldlace                   = QColor.fromRGBInternal(0xff * 0x101, 0xfd * 0x101, 0xf5 * 0x101, 0xe6 * 0x101);
    immutable QColor olive                     = QColor.fromRGBInternal(0xff * 0x101, 0x80 * 0x101, 0x80 * 0x101, 0x00 * 0x101);
    immutable QColor olivedrab                 = QColor.fromRGBInternal(0xff * 0x101, 0x6b * 0x101, 0x8e * 0x101, 0x23 * 0x101);
    immutable QColor orange                    = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xa5 * 0x101, 0x00 * 0x101);
    immutable QColor orangered                 = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0x45 * 0x101, 0x00 * 0x101);
    immutable QColor orchid                    = QColor.fromRGBInternal(0xff * 0x101, 0xda * 0x101, 0x70 * 0x101, 0xd6 * 0x101);
    immutable QColor palegoldenrod             = QColor.fromRGBInternal(0xff * 0x101, 0xee * 0x101, 0xe8 * 0x101, 0xaa * 0x101);
    immutable QColor palegreen                 = QColor.fromRGBInternal(0xff * 0x101, 0x98 * 0x101, 0xfb * 0x101, 0x98 * 0x101);
    immutable QColor paleturquoise             = QColor.fromRGBInternal(0xff * 0x101, 0xaf * 0x101, 0xee * 0x101, 0xee * 0x101);
    immutable QColor palevioletred             = QColor.fromRGBInternal(0xff * 0x101, 0xdb * 0x101, 0x70 * 0x101, 0x93 * 0x101);
    immutable QColor papayawhip                = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xef * 0x101, 0xd5 * 0x101);
    immutable QColor peachpuff                 = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xda * 0x101, 0xb9 * 0x101);
    immutable QColor peru                      = QColor.fromRGBInternal(0xff * 0x101, 0xcd * 0x101, 0x85 * 0x101, 0x3f * 0x101);
    immutable QColor pink                      = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xc0 * 0x101, 0xcb * 0x101);
    immutable QColor plum                      = QColor.fromRGBInternal(0xff * 0x101, 0xdd * 0x101, 0xa0 * 0x101, 0xdd * 0x101);
    immutable QColor powderblue                = QColor.fromRGBInternal(0xff * 0x101, 0xb0 * 0x101, 0xe0 * 0x101, 0xe6 * 0x101);
    immutable QColor purple                    = QColor.fromRGBInternal(0xff * 0x101, 0x80 * 0x101, 0x00 * 0x101, 0x80 * 0x101);
    immutable QColor red                       = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101);
    immutable QColor rosybrown                 = QColor.fromRGBInternal(0xff * 0x101, 0xbc * 0x101, 0x8f * 0x101, 0x8f * 0x101);
    immutable QColor royalblue                 = QColor.fromRGBInternal(0xff * 0x101, 0x41 * 0x101, 0x69 * 0x101, 0xe1 * 0x101);
    immutable QColor saddlebrown               = QColor.fromRGBInternal(0xff * 0x101, 0x8b * 0x101, 0x45 * 0x101, 0x13 * 0x101);
    immutable QColor salmon                    = QColor.fromRGBInternal(0xff * 0x101, 0xfa * 0x101, 0x80 * 0x101, 0x72 * 0x101);
    immutable QColor sandybrown                = QColor.fromRGBInternal(0xff * 0x101, 0xf4 * 0x101, 0xa4 * 0x101, 0x60 * 0x101);
    immutable QColor seagreen                  = QColor.fromRGBInternal(0xff * 0x101, 0x2e * 0x101, 0x8b * 0x101, 0x57 * 0x101);
    immutable QColor seashell                  = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xf5 * 0x101, 0xee * 0x101);
    immutable QColor sienna                    = QColor.fromRGBInternal(0xff * 0x101, 0xa0 * 0x101, 0x52 * 0x101, 0x2d * 0x101);
    immutable QColor silver                    = QColor.fromRGBInternal(0xff * 0x101, 0xc0 * 0x101, 0xc0 * 0x101, 0xc0 * 0x101);
    immutable QColor skyblue                   = QColor.fromRGBInternal(0xff * 0x101, 0x87 * 0x101, 0xce * 0x101, 0xeb * 0x101);
    immutable QColor slateblue                 = QColor.fromRGBInternal(0xff * 0x101, 0x6a * 0x101, 0x5a * 0x101, 0xcd * 0x101);
    immutable QColor slategray                 = QColor.fromRGBInternal(0xff * 0x101, 0x70 * 0x101, 0x80 * 0x101, 0x90 * 0x101);
    immutable QColor slategrey                 = QColor.fromRGBInternal(0xff * 0x101, 0x70 * 0x101, 0x80 * 0x101, 0x90 * 0x101);
    immutable QColor snow                      = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xfa * 0x101, 0xfa * 0x101);
    immutable QColor springgreen               = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0xff * 0x101, 0x7f * 0x101);
    immutable QColor steelblue                 = QColor.fromRGBInternal(0xff * 0x101, 0x46 * 0x101, 0x82 * 0x101, 0xb4 * 0x101);
    immutable QColor tan                       = QColor.fromRGBInternal(0xff * 0x101, 0xd2 * 0x101, 0xb4 * 0x101, 0x8c * 0x101);
    immutable QColor teal                      = QColor.fromRGBInternal(0xff * 0x101, 0x00 * 0x101, 0x80 * 0x101, 0x80 * 0x101);
    immutable QColor thistle                   = QColor.fromRGBInternal(0xff * 0x101, 0xd8 * 0x101, 0xbf * 0x101, 0xd8 * 0x101);
    immutable QColor tomato                    = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0x63 * 0x101, 0x47 * 0x101);
    immutable QColor turquoise                 = QColor.fromRGBInternal(0xff * 0x101, 0x40 * 0x101, 0xe0 * 0x101, 0xd0 * 0x101);
    immutable QColor violet                    = QColor.fromRGBInternal(0xff * 0x101, 0xee * 0x101, 0x82 * 0x101, 0xee * 0x101);
    immutable QColor wheat                     = QColor.fromRGBInternal(0xff * 0x101, 0xf5 * 0x101, 0xde * 0x101, 0xb3 * 0x101);
    immutable QColor white                     = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101);
    immutable QColor whitesmoke                = QColor.fromRGBInternal(0xff * 0x101, 0xf5 * 0x101, 0xf5 * 0x101, 0xf5 * 0x101);
    immutable QColor yellow                    = QColor.fromRGBInternal(0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0x00 * 0x101);
    immutable QColor yellowgreen               = QColor.fromRGBInternal(0xff * 0x101, 0x9a * 0x101, 0xcd * 0x101, 0x32 * 0x101);
//}  // namespace Svg
}  // namespace QColorLiterals

