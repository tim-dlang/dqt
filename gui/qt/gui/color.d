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
import qt.core.global;
import qt.core.metatype;
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

/// Binding for C++ class [QColor](https://doc.qt.io/qt-5/qcolor.html).
@Q_RELOCATABLE_TYPE @(QMetaType.Type.QColor) extern(C++, class) struct /+ Q_GUI_EXPORT +/ QColor
{
public:
    enum Spec { Invalid, Rgb, Hsv, Cmyk, Hsl, ExtendedRgb }
    enum NameFormat { HexRgb, HexArgb }

    /+this()/+ noexcept+/
    {
        this.cspec = Spec.Invalid;
        this.ct = typeof(this.ct)(ushort.max, 0, 0, 0, 0);
    }+/
    this(/+ Qt:: +/qt.core.namespace.GlobalColor color)/+ noexcept+/;
    this(int r, int g, int b, int a = 255)/+ noexcept+/
    {
        this.cspec = isRgbaValid(r, g, b, a) ? Spec.Rgb : Spec.Invalid;
        this.ct = CT(CT.generated_qcolor_0(cast(ushort)(cspec == Spec.Rgb ? a * 0x0101 : 0),
                     cast(ushort)(cspec == Spec.Rgb ? r * 0x0101 : 0),
                     cast(ushort)(cspec == Spec.Rgb ? g * 0x0101 : 0),
                     cast(ushort)(cspec == Spec.Rgb ? b * 0x0101 : 0),
                     0));
    }
    this(QRgb rgb)/+ noexcept+/;
    this(QRgba64 rgba64)/+ noexcept+/;
    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        pragma(inline, true) this(ref const(QString) aname)
        { setNamedColor(aname); }
    }

    ~this(){} // Makes sure, that QColor as return type is passed as a hidden pointer parameter.

    /+ explicit +/ pragma(inline, true) this(QStringView aname)
    { setNamedColor(aname); }
    pragma(inline, true) this(const(char)* aname)
    {
        this(QLatin1String(aname));
    }
    pragma(inline, true) this(QLatin1String aname)
    { setNamedColor(aname); }
    this(Spec spec)/+ noexcept+/;

/+ #if QT_VERSION < QT_VERSION_CHECK(6,0,0) +/
    // ### Qt 6: remove all of these, the trivial ones are fine.
    /+@disable this(this);
    this(ref const(QColor) color)/+ noexcept+/
    {
        this.cspec = color.cspec;
        this.ct = color.ct;
    }+/
    /+ QColor(QColor &&other) noexcept : cspec(other.cspec), ct(other.ct) {} +/
    /+ QColor &operator=(QColor &&other) noexcept
    { cspec = other.cspec; ct = other.ct; return *this; } +/
    /+ref QColor operator =(ref const(QColor) )/+ noexcept+/;+/
/+ #endif +/ // Qt < 6

    /+ref QColor operator =(/+ Qt:: +/qt.core.namespace.GlobalColor color)/+ noexcept+/;+/

    pragma(inline, true) bool isValid() const/+ noexcept+/
    { return cspec != Spec.Invalid; }

    // ### Qt 6: merge overloads
    QString name() const;
    QString name(NameFormat format) const;

    static if(QT_STRINGVIEW_LEVEL < 2)
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

    qreal alphaF() const/+ noexcept+/;
    void setAlphaF(qreal alpha);

    int red() const/+ noexcept+/;
    int green() const/+ noexcept+/;
    int blue() const/+ noexcept+/;
    void setRed(int red);
    void setGreen(int green);
    void setBlue(int blue);

    qreal redF() const/+ noexcept+/;
    qreal greenF() const/+ noexcept+/;
    qreal blueF() const/+ noexcept+/;
    void setRedF(qreal red);
    void setGreenF(qreal green);
    void setBlueF(qreal blue);

    void getRgb(int* r, int* g, int* b, int* a = null) const;
    void setRgb(int r, int g, int b, int a = 255);

    void getRgbF(qreal* r, qreal* g, qreal* b, qreal* a = null) const;
    void setRgbF(qreal r, qreal g, qreal b, qreal a = 1.0);

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

    qreal hueF() const/+ noexcept+/; // 0.0 <= hueF < 360.0
    qreal saturationF() const/+ noexcept+/;
    qreal hsvHueF() const/+ noexcept+/; // 0.0 <= hueF < 360.0
    qreal hsvSaturationF() const/+ noexcept+/;
    qreal valueF() const/+ noexcept+/;

    void getHsv(int* h, int* s, int* v, int* a = null) const;
    void setHsv(int h, int s, int v, int a = 255);

    void getHsvF(qreal* h, qreal* s, qreal* v, qreal* a = null) const;
    void setHsvF(qreal h, qreal s, qreal v, qreal a = 1.0);

    int cyan() const/+ noexcept+/;
    int magenta() const/+ noexcept+/;
    int yellow() const/+ noexcept+/;
    int black() const/+ noexcept+/;

    qreal cyanF() const/+ noexcept+/;
    qreal magentaF() const/+ noexcept+/;
    qreal yellowF() const/+ noexcept+/;
    qreal blackF() const/+ noexcept+/;

    void getCmyk(int* c, int* m, int* y, int* k, int* a = null); // ### Qt 6: remove
    void getCmyk(int* c, int* m, int* y, int* k, int* a = null) const;
    void setCmyk(int c, int m, int y, int k, int a = 255);

    void getCmykF(qreal* c, qreal* m, qreal* y, qreal* k, qreal* a = null); // ### Qt 6: remove
    void getCmykF(qreal* c, qreal* m, qreal* y, qreal* k, qreal* a = null) const;
    void setCmykF(qreal c, qreal m, qreal y, qreal k, qreal a = 1.0);

    int hslHue() const/+ noexcept+/; // 0 <= hue < 360
    int hslSaturation() const/+ noexcept+/;
    int lightness() const/+ noexcept+/;

    qreal hslHueF() const/+ noexcept+/; // 0.0 <= hueF < 360.0
    qreal hslSaturationF() const/+ noexcept+/;
    qreal lightnessF() const/+ noexcept+/;

    void getHsl(int* h, int* s, int* l, int* a = null) const;
    void setHsl(int h, int s, int l, int a = 255);

    void getHslF(qreal* h, qreal* s, qreal* l, qreal* a = null) const;
    void setHslF(qreal h, qreal s, qreal l, qreal a = 1.0);

    QColor toRgb() const/+ noexcept+/;
    QColor toHsv() const/+ noexcept+/;
    QColor toCmyk() const/+ noexcept+/;
    QColor toHsl() const/+ noexcept+/;
    QColor toExtendedRgb() const/+ noexcept+/;

    /+ Q_REQUIRED_RESULT +/ QColor convertTo(Spec colorSpec) const/+ noexcept+/;

    static QColor fromRgb(QRgb rgb)/+ noexcept+/;
    static QColor fromRgba(QRgb rgba)/+ noexcept+/;

    static QColor fromRgb(int r, int g, int b, int a = 255);
    static QColor fromRgbF(qreal r, qreal g, qreal b, qreal a = 1.0);

    static QColor fromRgba64(ushort r, ushort g, ushort b, ushort a = ushort.max)/+ noexcept+/;
    static QColor fromRgba64(QRgba64 rgba)/+ noexcept+/;

    static QColor fromHsv(int h, int s, int v, int a = 255);
    static QColor fromHsvF(qreal h, qreal s, qreal v, qreal a = 1.0);

    static QColor fromCmyk(int c, int m, int y, int k, int a = 255);
    static QColor fromCmykF(qreal c, qreal m, qreal y, qreal k, qreal a = 1.0);

    static QColor fromHsl(int h, int s, int l, int a = 255);
    static QColor fromHslF(qreal h, qreal s, qreal l, qreal a = 1.0);

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use QColor::lighter() instead") +/
        /+ Q_REQUIRED_RESULT +/ QColor light(int f = 150) const/+ noexcept+/;
    /+ QT_DEPRECATED_X("Use QColor::darker() instead") +/
        /+ Q_REQUIRED_RESULT +/ QColor dark(int f = 200) const/+ noexcept+/;
/+ #endif +/
    /+ Q_REQUIRED_RESULT +/ QColor lighter(int f = 150) const/+ noexcept+/;
    /+ Q_REQUIRED_RESULT +/ QColor darker(int f = 200) const/+ noexcept+/;

    bool opEquals(ref const(QColor) c) const/+ noexcept+/;
    bool opEquals(const(QColor) c) const/+ noexcept+/
    {
        return opEquals(c);
    }
    /+bool operator !=(ref const(QColor) c) const/+ noexcept+/;+/

    /+auto opCast(T : QVariant)() const;+/

    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        static bool isValidColor(ref const(QString) name);
    }
    static bool isValidColor(QStringView)/+ noexcept+/;
    static bool isValidColor(QLatin1String)/+ noexcept+/;

private:

    void invalidate()/+ noexcept+/;
    /+ template <typename String> +/
    /+ bool setColorFromString(String name); +/

    static bool isRgbaValid(int r, int g, int b, int a = 255)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/
    __attribute__((const))+/    {
        return uint(r) <= 255 && uint(g) <= 255 && uint(b) <= 255 && uint(a) <= 255;
    }

    Spec cspec = Spec.Invalid;
    union CT {
/+ #ifdef Q_COMPILER_UNIFORM_INIT
        CT() {} // doesn't init anything, thus can't be constexpr
        explicit CT(ushort a1, ushort a2, ushort a3, ushort a4, ushort a5) noexcept
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

    /+ friend class QColormap; +/
/+ #ifndef QT_NO_DATASTREAM +/
    version(QT_NO_DATASTREAM){}else
    {
        /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QColor &); +/
        /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QColor &); +/
    }
/+ #endif

#ifdef Q_COMPILER_UNIFORM_INIT
public: // can't give friendship to a namespace, so it needs to be public
    explicit QColor(Spec spec, ushort a1, ushort a2, ushort a3, ushort a4, ushort a5=0) noexcept
        : cspec(spec), ct(a1, a2, a3, a4, a5) {}
#endif +/ // Q_COMPILER_UNIFORM_INIT
}
/+ Q_DECLARE_TYPEINFO(QColor, QT_VERSION >= QT_VERSION_CHECK(6,0,0) ? Q_MOVABLE_TYPE : Q_RELOCATABLE_TYPE);

#if QT_STRINGVIEW_LEVEL < 2
#endif +/

// define these namespaces even if the contents are ifdef'd out
extern(C++, "QColorConstants")
{

/+ namespace Svg {}

#if defined(Q_COMPILER_CONSTEXPR) & defined(Q_COMPILER_UNIFORM_INIT)
    // Qt::GlobalColor names
    constexpr Q_DECL_UNUSED QColor Color0      {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor Color1      {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor Black       {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor White       {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor DarkGray    {QColor::Rgb, 0xff * 0x101, 0x80 * 0x101, 0x80 * 0x101, 0x80 * 0x101};
    constexpr Q_DECL_UNUSED QColor Gray        {QColor::Rgb, 0xff * 0x101, 0xa0 * 0x101, 0xa0 * 0x101, 0xa4 * 0x101};
    constexpr Q_DECL_UNUSED QColor LightGray   {QColor::Rgb, 0xff * 0x101, 0xc0 * 0x101, 0xc0 * 0x101, 0xc0 * 0x101};
    constexpr Q_DECL_UNUSED QColor Red         {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor Green       {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0xff * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor Blue        {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor Cyan        {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0xff * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor Magenta     {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0x00 * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor Yellow      {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor DarkRed     {QColor::Rgb, 0xff * 0x101, 0x80 * 0x101, 0x00 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor DarkGreen   {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x80 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor DarkBlue    {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x80 * 0x101};
    constexpr Q_DECL_UNUSED QColor DarkCyan    {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x80 * 0x101, 0x80 * 0x101};
    constexpr Q_DECL_UNUSED QColor DarkMagenta {QColor::Rgb, 0xff * 0x101, 0x80 * 0x101, 0x00 * 0x101, 0x80 * 0x101};
    constexpr Q_DECL_UNUSED QColor DarkYellow  {QColor::Rgb, 0xff * 0x101, 0x80 * 0x101, 0x80 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor Transparent {QColor::Rgb, 0x00 * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x00 * 0x101};

    // SVG names supported by QColor (see qcolor.cpp).
namespace Svg {
    constexpr Q_DECL_UNUSED QColor aliceblue                {QColor::Rgb, 0xff * 0x101, 0xf0 * 0x101, 0xf8 * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor antiquewhite             {QColor::Rgb, 0xff * 0x101, 0xfa * 0x101, 0xeb * 0x101, 0xd7 * 0x101};
    constexpr Q_DECL_UNUSED QColor aqua                     {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0xff * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor aquamarine               {QColor::Rgb, 0xff * 0x101, 0x7f * 0x101, 0xff * 0x101, 0xd4 * 0x101};
    constexpr Q_DECL_UNUSED QColor azure                    {QColor::Rgb, 0xff * 0x101, 0xf0 * 0x101, 0xff * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor beige                    {QColor::Rgb, 0xff * 0x101, 0xf5 * 0x101, 0xf5 * 0x101, 0xdc * 0x101};
    constexpr Q_DECL_UNUSED QColor bisque                   {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xe4 * 0x101, 0xc4 * 0x101};
    constexpr Q_DECL_UNUSED QColor black                    {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor blanchedalmond           {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xeb * 0x101, 0xcd * 0x101};
    constexpr Q_DECL_UNUSED QColor blue                     {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor blueviolet               {QColor::Rgb, 0xff * 0x101, 0x8a * 0x101, 0x2b * 0x101, 0xe2 * 0x101};
    constexpr Q_DECL_UNUSED QColor brown                    {QColor::Rgb, 0xff * 0x101, 0xa5 * 0x101, 0x2a * 0x101, 0x2a * 0x101};
    constexpr Q_DECL_UNUSED QColor burlywood                {QColor::Rgb, 0xff * 0x101, 0xde * 0x101, 0xb8 * 0x101, 0x87 * 0x101};
    constexpr Q_DECL_UNUSED QColor cadetblue                {QColor::Rgb, 0xff * 0x101, 0x5f * 0x101, 0x9e * 0x101, 0xa0 * 0x101};
    constexpr Q_DECL_UNUSED QColor chartreuse               {QColor::Rgb, 0xff * 0x101, 0x7f * 0x101, 0xff * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor chocolate                {QColor::Rgb, 0xff * 0x101, 0xd2 * 0x101, 0x69 * 0x101, 0x1e * 0x101};
    constexpr Q_DECL_UNUSED QColor coral                    {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0x7f * 0x101, 0x50 * 0x101};
    constexpr Q_DECL_UNUSED QColor cornflowerblue           {QColor::Rgb, 0xff * 0x101, 0x64 * 0x101, 0x95 * 0x101, 0xed * 0x101};
    constexpr Q_DECL_UNUSED QColor cornsilk                 {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xf8 * 0x101, 0xdc * 0x101};
    constexpr Q_DECL_UNUSED QColor crimson                  {QColor::Rgb, 0xff * 0x101, 0xdc * 0x101, 0x14 * 0x101, 0x3c * 0x101};
    constexpr Q_DECL_UNUSED QColor cyan                     {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0xff * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor darkblue                 {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x8b * 0x101};
    constexpr Q_DECL_UNUSED QColor darkcyan                 {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x8b * 0x101, 0x8b * 0x101};
    constexpr Q_DECL_UNUSED QColor darkgoldenrod            {QColor::Rgb, 0xff * 0x101, 0xb8 * 0x101, 0x86 * 0x101, 0x0b * 0x101};
    constexpr Q_DECL_UNUSED QColor darkgray                 {QColor::Rgb, 0xff * 0x101, 0xa9 * 0x101, 0xa9 * 0x101, 0xa9 * 0x101};
    constexpr Q_DECL_UNUSED QColor darkgreen                {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x64 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor darkgrey                 {QColor::Rgb, 0xff * 0x101, 0xa9 * 0x101, 0xa9 * 0x101, 0xa9 * 0x101};
    constexpr Q_DECL_UNUSED QColor darkkhaki                {QColor::Rgb, 0xff * 0x101, 0xbd * 0x101, 0xb7 * 0x101, 0x6b * 0x101};
    constexpr Q_DECL_UNUSED QColor darkmagenta              {QColor::Rgb, 0xff * 0x101, 0x8b * 0x101, 0x00 * 0x101, 0x8b * 0x101};
    constexpr Q_DECL_UNUSED QColor darkolivegreen           {QColor::Rgb, 0xff * 0x101, 0x55 * 0x101, 0x6b * 0x101, 0x2f * 0x101};
    constexpr Q_DECL_UNUSED QColor darkorange               {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0x8c * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor darkorchid               {QColor::Rgb, 0xff * 0x101, 0x99 * 0x101, 0x32 * 0x101, 0xcc * 0x101};
    constexpr Q_DECL_UNUSED QColor darkred                  {QColor::Rgb, 0xff * 0x101, 0x8b * 0x101, 0x00 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor darksalmon               {QColor::Rgb, 0xff * 0x101, 0xe9 * 0x101, 0x96 * 0x101, 0x7a * 0x101};
    constexpr Q_DECL_UNUSED QColor darkseagreen             {QColor::Rgb, 0xff * 0x101, 0x8f * 0x101, 0xbc * 0x101, 0x8f * 0x101};
    constexpr Q_DECL_UNUSED QColor darkslateblue            {QColor::Rgb, 0xff * 0x101, 0x48 * 0x101, 0x3d * 0x101, 0x8b * 0x101};
    constexpr Q_DECL_UNUSED QColor darkslategray            {QColor::Rgb, 0xff * 0x101, 0x2f * 0x101, 0x4f * 0x101, 0x4f * 0x101};
    constexpr Q_DECL_UNUSED QColor darkslategrey            {QColor::Rgb, 0xff * 0x101, 0x2f * 0x101, 0x4f * 0x101, 0x4f * 0x101};
    constexpr Q_DECL_UNUSED QColor darkturquoise            {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0xce * 0x101, 0xd1 * 0x101};
    constexpr Q_DECL_UNUSED QColor darkviolet               {QColor::Rgb, 0xff * 0x101, 0x94 * 0x101, 0x00 * 0x101, 0xd3 * 0x101};
    constexpr Q_DECL_UNUSED QColor deeppink                 {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0x14 * 0x101, 0x93 * 0x101};
    constexpr Q_DECL_UNUSED QColor deepskyblue              {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0xbf * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor dimgray                  {QColor::Rgb, 0xff * 0x101, 0x69 * 0x101, 0x69 * 0x101, 0x69 * 0x101};
    constexpr Q_DECL_UNUSED QColor dimgrey                  {QColor::Rgb, 0xff * 0x101, 0x69 * 0x101, 0x69 * 0x101, 0x69 * 0x101};
    constexpr Q_DECL_UNUSED QColor dodgerblue               {QColor::Rgb, 0xff * 0x101, 0x1e * 0x101, 0x90 * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor firebrick                {QColor::Rgb, 0xff * 0x101, 0xb2 * 0x101, 0x22 * 0x101, 0x22 * 0x101};
    constexpr Q_DECL_UNUSED QColor floralwhite              {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xfa * 0x101, 0xf0 * 0x101};
    constexpr Q_DECL_UNUSED QColor forestgreen              {QColor::Rgb, 0xff * 0x101, 0x22 * 0x101, 0x8b * 0x101, 0x22 * 0x101};
    constexpr Q_DECL_UNUSED QColor fuchsia                  {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0x00 * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor gainsboro                {QColor::Rgb, 0xff * 0x101, 0xdc * 0x101, 0xdc * 0x101, 0xdc * 0x101};
    constexpr Q_DECL_UNUSED QColor ghostwhite               {QColor::Rgb, 0xff * 0x101, 0xf8 * 0x101, 0xf8 * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor gold                     {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xd7 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor goldenrod                {QColor::Rgb, 0xff * 0x101, 0xda * 0x101, 0xa5 * 0x101, 0x20 * 0x101};
    constexpr Q_DECL_UNUSED QColor gray                     {QColor::Rgb, 0xff * 0x101, 0x80 * 0x101, 0x80 * 0x101, 0x80 * 0x101};
    constexpr Q_DECL_UNUSED QColor green                    {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x80 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor greenyellow              {QColor::Rgb, 0xff * 0x101, 0xad * 0x101, 0xff * 0x101, 0x2f * 0x101};
    constexpr Q_DECL_UNUSED QColor grey                     {QColor::Rgb, 0xff * 0x101, 0x80 * 0x101, 0x80 * 0x101, 0x80 * 0x101};
    constexpr Q_DECL_UNUSED QColor honeydew                 {QColor::Rgb, 0xff * 0x101, 0xf0 * 0x101, 0xff * 0x101, 0xf0 * 0x101};
    constexpr Q_DECL_UNUSED QColor hotpink                  {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0x69 * 0x101, 0xb4 * 0x101};
    constexpr Q_DECL_UNUSED QColor indianred                {QColor::Rgb, 0xff * 0x101, 0xcd * 0x101, 0x5c * 0x101, 0x5c * 0x101};
    constexpr Q_DECL_UNUSED QColor indigo                   {QColor::Rgb, 0xff * 0x101, 0x4b * 0x101, 0x00 * 0x101, 0x82 * 0x101};
    constexpr Q_DECL_UNUSED QColor ivory                    {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0xf0 * 0x101};
    constexpr Q_DECL_UNUSED QColor khaki                    {QColor::Rgb, 0xff * 0x101, 0xf0 * 0x101, 0xe6 * 0x101, 0x8c * 0x101};
    constexpr Q_DECL_UNUSED QColor lavender                 {QColor::Rgb, 0xff * 0x101, 0xe6 * 0x101, 0xe6 * 0x101, 0xfa * 0x101};
    constexpr Q_DECL_UNUSED QColor lavenderblush            {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xf0 * 0x101, 0xf5 * 0x101};
    constexpr Q_DECL_UNUSED QColor lawngreen                {QColor::Rgb, 0xff * 0x101, 0x7c * 0x101, 0xfc * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor lemonchiffon             {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xfa * 0x101, 0xcd * 0x101};
    constexpr Q_DECL_UNUSED QColor lightblue                {QColor::Rgb, 0xff * 0x101, 0xad * 0x101, 0xd8 * 0x101, 0xe6 * 0x101};
    constexpr Q_DECL_UNUSED QColor lightcoral               {QColor::Rgb, 0xff * 0x101, 0xf0 * 0x101, 0x80 * 0x101, 0x80 * 0x101};
    constexpr Q_DECL_UNUSED QColor lightcyan                {QColor::Rgb, 0xff * 0x101, 0xe0 * 0x101, 0xff * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor lightgoldenrodyellow     {QColor::Rgb, 0xff * 0x101, 0xfa * 0x101, 0xfa * 0x101, 0xd2 * 0x101};
    constexpr Q_DECL_UNUSED QColor lightgray                {QColor::Rgb, 0xff * 0x101, 0xd3 * 0x101, 0xd3 * 0x101, 0xd3 * 0x101};
    constexpr Q_DECL_UNUSED QColor lightgreen               {QColor::Rgb, 0xff * 0x101, 0x90 * 0x101, 0xee * 0x101, 0x90 * 0x101};
    constexpr Q_DECL_UNUSED QColor lightgrey                {QColor::Rgb, 0xff * 0x101, 0xd3 * 0x101, 0xd3 * 0x101, 0xd3 * 0x101};
    constexpr Q_DECL_UNUSED QColor lightpink                {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xb6 * 0x101, 0xc1 * 0x101};
    constexpr Q_DECL_UNUSED QColor lightsalmon              {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xa0 * 0x101, 0x7a * 0x101};
    constexpr Q_DECL_UNUSED QColor lightseagreen            {QColor::Rgb, 0xff * 0x101, 0x20 * 0x101, 0xb2 * 0x101, 0xaa * 0x101};
    constexpr Q_DECL_UNUSED QColor lightskyblue             {QColor::Rgb, 0xff * 0x101, 0x87 * 0x101, 0xce * 0x101, 0xfa * 0x101};
    constexpr Q_DECL_UNUSED QColor lightslategray           {QColor::Rgb, 0xff * 0x101, 0x77 * 0x101, 0x88 * 0x101, 0x99 * 0x101};
    constexpr Q_DECL_UNUSED QColor lightslategrey           {QColor::Rgb, 0xff * 0x101, 0x77 * 0x101, 0x88 * 0x101, 0x99 * 0x101};
    constexpr Q_DECL_UNUSED QColor lightsteelblue           {QColor::Rgb, 0xff * 0x101, 0xb0 * 0x101, 0xc4 * 0x101, 0xde * 0x101};
    constexpr Q_DECL_UNUSED QColor lightyellow              {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0xe0 * 0x101};
    constexpr Q_DECL_UNUSED QColor lime                     {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0xff * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor limegreen                {QColor::Rgb, 0xff * 0x101, 0x32 * 0x101, 0xcd * 0x101, 0x32 * 0x101};
    constexpr Q_DECL_UNUSED QColor linen                    {QColor::Rgb, 0xff * 0x101, 0xfa * 0x101, 0xf0 * 0x101, 0xe6 * 0x101};
    constexpr Q_DECL_UNUSED QColor magenta                  {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0x00 * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor maroon                   {QColor::Rgb, 0xff * 0x101, 0x80 * 0x101, 0x00 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor mediumaquamarine         {QColor::Rgb, 0xff * 0x101, 0x66 * 0x101, 0xcd * 0x101, 0xaa * 0x101};
    constexpr Q_DECL_UNUSED QColor mediumblue               {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0xcd * 0x101};
    constexpr Q_DECL_UNUSED QColor mediumorchid             {QColor::Rgb, 0xff * 0x101, 0xba * 0x101, 0x55 * 0x101, 0xd3 * 0x101};
    constexpr Q_DECL_UNUSED QColor mediumpurple             {QColor::Rgb, 0xff * 0x101, 0x93 * 0x101, 0x70 * 0x101, 0xdb * 0x101};
    constexpr Q_DECL_UNUSED QColor mediumseagreen           {QColor::Rgb, 0xff * 0x101, 0x3c * 0x101, 0xb3 * 0x101, 0x71 * 0x101};
    constexpr Q_DECL_UNUSED QColor mediumslateblue          {QColor::Rgb, 0xff * 0x101, 0x7b * 0x101, 0x68 * 0x101, 0xee * 0x101};
    constexpr Q_DECL_UNUSED QColor mediumspringgreen        {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0xfa * 0x101, 0x9a * 0x101};
    constexpr Q_DECL_UNUSED QColor mediumturquoise          {QColor::Rgb, 0xff * 0x101, 0x48 * 0x101, 0xd1 * 0x101, 0xcc * 0x101};
    constexpr Q_DECL_UNUSED QColor mediumvioletred          {QColor::Rgb, 0xff * 0x101, 0xc7 * 0x101, 0x15 * 0x101, 0x85 * 0x101};
    constexpr Q_DECL_UNUSED QColor midnightblue             {QColor::Rgb, 0xff * 0x101, 0x19 * 0x101, 0x19 * 0x101, 0x70 * 0x101};
    constexpr Q_DECL_UNUSED QColor mintcream                {QColor::Rgb, 0xff * 0x101, 0xf5 * 0x101, 0xff * 0x101, 0xfa * 0x101};
    constexpr Q_DECL_UNUSED QColor mistyrose                {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xe4 * 0x101, 0xe1 * 0x101};
    constexpr Q_DECL_UNUSED QColor moccasin                 {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xe4 * 0x101, 0xb5 * 0x101};
    constexpr Q_DECL_UNUSED QColor navajowhite              {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xde * 0x101, 0xad * 0x101};
    constexpr Q_DECL_UNUSED QColor navy                     {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101, 0x80 * 0x101};
    constexpr Q_DECL_UNUSED QColor oldlace                  {QColor::Rgb, 0xff * 0x101, 0xfd * 0x101, 0xf5 * 0x101, 0xe6 * 0x101};
    constexpr Q_DECL_UNUSED QColor olive                    {QColor::Rgb, 0xff * 0x101, 0x80 * 0x101, 0x80 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor olivedrab                {QColor::Rgb, 0xff * 0x101, 0x6b * 0x101, 0x8e * 0x101, 0x23 * 0x101};
    constexpr Q_DECL_UNUSED QColor orange                   {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xa5 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor orangered                {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0x45 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor orchid                   {QColor::Rgb, 0xff * 0x101, 0xda * 0x101, 0x70 * 0x101, 0xd6 * 0x101};
    constexpr Q_DECL_UNUSED QColor palegoldenrod            {QColor::Rgb, 0xff * 0x101, 0xee * 0x101, 0xe8 * 0x101, 0xaa * 0x101};
    constexpr Q_DECL_UNUSED QColor palegreen                {QColor::Rgb, 0xff * 0x101, 0x98 * 0x101, 0xfb * 0x101, 0x98 * 0x101};
    constexpr Q_DECL_UNUSED QColor paleturquoise            {QColor::Rgb, 0xff * 0x101, 0xaf * 0x101, 0xee * 0x101, 0xee * 0x101};
    constexpr Q_DECL_UNUSED QColor palevioletred            {QColor::Rgb, 0xff * 0x101, 0xdb * 0x101, 0x70 * 0x101, 0x93 * 0x101};
    constexpr Q_DECL_UNUSED QColor papayawhip               {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xef * 0x101, 0xd5 * 0x101};
    constexpr Q_DECL_UNUSED QColor peachpuff                {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xda * 0x101, 0xb9 * 0x101};
    constexpr Q_DECL_UNUSED QColor peru                     {QColor::Rgb, 0xff * 0x101, 0xcd * 0x101, 0x85 * 0x101, 0x3f * 0x101};
    constexpr Q_DECL_UNUSED QColor pink                     {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xc0 * 0x101, 0xcb * 0x101};
    constexpr Q_DECL_UNUSED QColor plum                     {QColor::Rgb, 0xff * 0x101, 0xdd * 0x101, 0xa0 * 0x101, 0xdd * 0x101};
    constexpr Q_DECL_UNUSED QColor powderblue               {QColor::Rgb, 0xff * 0x101, 0xb0 * 0x101, 0xe0 * 0x101, 0xe6 * 0x101};
    constexpr Q_DECL_UNUSED QColor purple                   {QColor::Rgb, 0xff * 0x101, 0x80 * 0x101, 0x00 * 0x101, 0x80 * 0x101};
    constexpr Q_DECL_UNUSED QColor red                      {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0x00 * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor rosybrown                {QColor::Rgb, 0xff * 0x101, 0xbc * 0x101, 0x8f * 0x101, 0x8f * 0x101};
    constexpr Q_DECL_UNUSED QColor royalblue                {QColor::Rgb, 0xff * 0x101, 0x41 * 0x101, 0x69 * 0x101, 0xe1 * 0x101};
    constexpr Q_DECL_UNUSED QColor saddlebrown              {QColor::Rgb, 0xff * 0x101, 0x8b * 0x101, 0x45 * 0x101, 0x13 * 0x101};
    constexpr Q_DECL_UNUSED QColor salmon                   {QColor::Rgb, 0xff * 0x101, 0xfa * 0x101, 0x80 * 0x101, 0x72 * 0x101};
    constexpr Q_DECL_UNUSED QColor sandybrown               {QColor::Rgb, 0xff * 0x101, 0xf4 * 0x101, 0xa4 * 0x101, 0x60 * 0x101};
    constexpr Q_DECL_UNUSED QColor seagreen                 {QColor::Rgb, 0xff * 0x101, 0x2e * 0x101, 0x8b * 0x101, 0x57 * 0x101};
    constexpr Q_DECL_UNUSED QColor seashell                 {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xf5 * 0x101, 0xee * 0x101};
    constexpr Q_DECL_UNUSED QColor sienna                   {QColor::Rgb, 0xff * 0x101, 0xa0 * 0x101, 0x52 * 0x101, 0x2d * 0x101};
    constexpr Q_DECL_UNUSED QColor silver                   {QColor::Rgb, 0xff * 0x101, 0xc0 * 0x101, 0xc0 * 0x101, 0xc0 * 0x101};
    constexpr Q_DECL_UNUSED QColor skyblue                  {QColor::Rgb, 0xff * 0x101, 0x87 * 0x101, 0xce * 0x101, 0xeb * 0x101};
    constexpr Q_DECL_UNUSED QColor slateblue                {QColor::Rgb, 0xff * 0x101, 0x6a * 0x101, 0x5a * 0x101, 0xcd * 0x101};
    constexpr Q_DECL_UNUSED QColor slategray                {QColor::Rgb, 0xff * 0x101, 0x70 * 0x101, 0x80 * 0x101, 0x90 * 0x101};
    constexpr Q_DECL_UNUSED QColor slategrey                {QColor::Rgb, 0xff * 0x101, 0x70 * 0x101, 0x80 * 0x101, 0x90 * 0x101};
    constexpr Q_DECL_UNUSED QColor snow                     {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xfa * 0x101, 0xfa * 0x101};
    constexpr Q_DECL_UNUSED QColor springgreen              {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0xff * 0x101, 0x7f * 0x101};
    constexpr Q_DECL_UNUSED QColor steelblue                {QColor::Rgb, 0xff * 0x101, 0x46 * 0x101, 0x82 * 0x101, 0xb4 * 0x101};
    constexpr Q_DECL_UNUSED QColor tan                      {QColor::Rgb, 0xff * 0x101, 0xd2 * 0x101, 0xb4 * 0x101, 0x8c * 0x101};
    constexpr Q_DECL_UNUSED QColor teal                     {QColor::Rgb, 0xff * 0x101, 0x00 * 0x101, 0x80 * 0x101, 0x80 * 0x101};
    constexpr Q_DECL_UNUSED QColor thistle                  {QColor::Rgb, 0xff * 0x101, 0xd8 * 0x101, 0xbf * 0x101, 0xd8 * 0x101};
    constexpr Q_DECL_UNUSED QColor tomato                   {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0x63 * 0x101, 0x47 * 0x101};
    constexpr Q_DECL_UNUSED QColor turquoise                {QColor::Rgb, 0xff * 0x101, 0x40 * 0x101, 0xe0 * 0x101, 0xd0 * 0x101};
    constexpr Q_DECL_UNUSED QColor violet                   {QColor::Rgb, 0xff * 0x101, 0xee * 0x101, 0x82 * 0x101, 0xee * 0x101};
    constexpr Q_DECL_UNUSED QColor wheat                    {QColor::Rgb, 0xff * 0x101, 0xf5 * 0x101, 0xde * 0x101, 0xb3 * 0x101};
    constexpr Q_DECL_UNUSED QColor white                    {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101};
    constexpr Q_DECL_UNUSED QColor whitesmoke               {QColor::Rgb, 0xff * 0x101, 0xf5 * 0x101, 0xf5 * 0x101, 0xf5 * 0x101};
    constexpr Q_DECL_UNUSED QColor yellow                   {QColor::Rgb, 0xff * 0x101, 0xff * 0x101, 0xff * 0x101, 0x00 * 0x101};
    constexpr Q_DECL_UNUSED QColor yellowgreen              {QColor::Rgb, 0xff * 0x101, 0x9a * 0x101, 0xcd * 0x101, 0x32 * 0x101};
}  // namespace Svg
#endif +/ // Q_COMPILER_CONSTEXPR && Q_COMPILER_UNIFORM_INIT
}  // namespace QColorLiterals

