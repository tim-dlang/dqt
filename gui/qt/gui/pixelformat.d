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
module qt.gui.pixelformat;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.typeinfo;
import qt.helpers;

@Q_PRIMITIVE_TYPE extern(C++, class) struct QPixelFormat
{
private:
    // QPixelFormat basically is a glorified quint64, split into several fields.
    // We could use bit-fields, but GCC at least generates horrible, horrible code for them,
    // so we do the bit-twiddling ourselves.
    enum FieldWidth {
        ModelFieldWidth = 4,
        FirstFieldWidth = 6,
        SecondFieldWidth = FieldWidth.FirstFieldWidth,
        ThirdFieldWidth = FieldWidth.FirstFieldWidth,
        FourthFieldWidth = FieldWidth.FirstFieldWidth,
        FifthFieldWidth = FieldWidth.FirstFieldWidth,
        AlphaFieldWidth = FieldWidth.FirstFieldWidth,
        AlphaUsageFieldWidth = 1,
        AlphaPositionFieldWidth = 1,
        PremulFieldWidth = 1,
        TypeInterpretationFieldWidth = 4,
        ByteOrderFieldWidth = 2,
        SubEnumFieldWidth = 6,
        UnusedFieldWidth = 9,

        TotalFieldWidthByWidths = FieldWidth.ModelFieldWidth + FieldWidth.FirstFieldWidth + FieldWidth.SecondFieldWidth + FieldWidth.ThirdFieldWidth +
                                  FieldWidth.FourthFieldWidth + FieldWidth.FifthFieldWidth + FieldWidth.AlphaFieldWidth + FieldWidth.AlphaUsageFieldWidth +
                                  FieldWidth.AlphaPositionFieldWidth + FieldWidth.PremulFieldWidth + FieldWidth.TypeInterpretationFieldWidth +
                                  FieldWidth.ByteOrderFieldWidth + FieldWidth.SubEnumFieldWidth + FieldWidth.UnusedFieldWidth
    }

    enum Field {
        ModelField = 0,
        // work around bug in old clang versions: when building webkit
        // with XCode 4.6 and older this fails compilation, thus cast to int
        FirstField = Field.ModelField + int(FieldWidth.ModelFieldWidth),
        SecondField = Field.FirstField + int(FieldWidth.FirstFieldWidth),
        ThirdField = Field.SecondField + int(FieldWidth.SecondFieldWidth),
        FourthField = Field.ThirdField + int(FieldWidth.ThirdFieldWidth),
        FifthField = Field.FourthField + int(FieldWidth.FourthFieldWidth),
        AlphaField = Field.FifthField + int(FieldWidth.FifthFieldWidth),
        AlphaUsageField = Field.AlphaField + int(FieldWidth.AlphaFieldWidth),
        AlphaPositionField = Field.AlphaUsageField + int(FieldWidth.AlphaUsageFieldWidth),
        PremulField = Field.AlphaPositionField + int(FieldWidth.AlphaPositionFieldWidth),
        TypeInterpretationField = Field.PremulField + int(FieldWidth.PremulFieldWidth),
        ByteOrderField = Field.TypeInterpretationField + int(FieldWidth.TypeInterpretationFieldWidth),
        SubEnumField = Field.ByteOrderField + int(FieldWidth.ByteOrderFieldWidth),
        UnusedField = Field.SubEnumField + int(FieldWidth.SubEnumFieldWidth),

        TotalFieldWidthByOffsets = Field.UnusedField + int(FieldWidth.UnusedFieldWidth)
    }

    mixin(Q_STATIC_ASSERT(q{uint(QPixelFormat.FieldWidth.TotalFieldWidthByWidths) == uint(QPixelFormat.Field.TotalFieldWidthByOffsets)}));
    mixin(Q_STATIC_ASSERT(q{uint(QPixelFormat.FieldWidth.TotalFieldWidthByWidths) == 8 * quint64.sizeof}));

    pragma(inline, true) uchar get(Field offset, FieldWidth width) const/+ noexcept+/
    { return cast(uchar)((data >> uint(offset)) & ((1uL << uint(width)) - 1uL)); }
    pragma(inline, true) static quint64 set(Field offset, FieldWidth width, uchar value)
    { return (quint64(value) & ((1uL << uint(width)) - 1uL)) << uint(offset); }

public:
    enum ColorModel {
        RGB,
        BGR,
        Indexed,
        Grayscale,
        CMYK,
        HSL,
        HSV,
        YUV,
        Alpha
    }

    enum AlphaUsage {
        UsesAlpha,
        IgnoresAlpha
    }

    enum AlphaPosition {
        AtBeginning,
        AtEnd
    }

    enum AlphaPremultiplied {
        NotPremultiplied,
        Premultiplied
    }

    enum TypeInterpretation {
        UnsignedInteger,
        UnsignedShort,
        UnsignedByte,
        FloatingPoint
    }

    enum YUVLayout {
        YUV444,
        YUV422,
        YUV411,
        YUV420P,
        YUV420SP,
        YV12,
        UYVY,
        YUYV,
        NV12,
        NV21,
        IMC1,
        IMC2,
        IMC3,
        IMC4,
        Y8,
        Y16
    }

    enum ByteOrder {
        LittleEndian,
        BigEndian,
        CurrentSystemEndian
    }

    @disable this();
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.data = 0;
    }+/
/+    pragma(inline, true) this(ColorModel mdl,
                                               uchar firstSize,
                                               uchar secondSize,
                                               uchar thirdSize,
                                               uchar fourthSize,
                                               uchar fifthSize,
                                               uchar alfa,
                                               AlphaUsage usage,
                                               AlphaPosition position,
                                               AlphaPremultiplied premult,
                                               TypeInterpretation typeInterp,
                                               ByteOrder b_order = ByteOrder.CurrentSystemEndian,
                                               uchar s_enum = 0)/+ noexcept+/
    {
        this.data = set(Field.ModelField, FieldWidth.ModelFieldWidth, cast(uchar)(mdl)) |
                   set(Field.FirstField, FieldWidth.FirstFieldWidth, firstSize) |
                   set(Field.SecondField, FieldWidth.SecondFieldWidth, secondSize) |
                   set(Field.ThirdField, FieldWidth.ThirdFieldWidth, thirdSize) |
                   set(Field.FourthField, FieldWidth.FourthFieldWidth, fourthSize) |
                   set(Field.FifthField, FieldWidth.FifthFieldWidth, fifthSize) |
                   set(Field.AlphaField, FieldWidth.AlphaFieldWidth, alfa) |
                   set(Field.AlphaUsageField, FieldWidth.AlphaUsageFieldWidth, cast(uchar)(usage)) |
                   set(Field.AlphaPositionField, FieldWidth.AlphaPositionFieldWidth, cast(uchar)(position)) |
                   set(Field.PremulField, FieldWidth.PremulFieldWidth, cast(uchar)(premult)) |
                   set(Field.TypeInterpretationField, FieldWidth.TypeInterpretationFieldWidth, cast(uchar)(typeInterp)) |
                   set(Field.ByteOrderField, FieldWidth.ByteOrderFieldWidth, cast(uchar)(resolveByteOrder(b_order))) |
                   set(Field.SubEnumField, FieldWidth.SubEnumFieldWidth, s_enum) |
                   set(Field.UnusedField, FieldWidth.UnusedFieldWidth, 0);
    }+/

    pragma(inline, true) ColorModel colorModel() const/+  noexcept+/ { return cast(ColorModel)(get(Field.ModelField, FieldWidth.ModelFieldWidth)); }
    pragma(inline, true) uchar channelCount() const/+ noexcept+/ { return cast(uchar)((get(Field.FirstField, FieldWidth.FirstFieldWidth) > 0) +
                                                                                 (get(Field.SecondField, FieldWidth.SecondFieldWidth) > 0) +
                                                                                 (get(Field.ThirdField, FieldWidth.ThirdFieldWidth) > 0) +
                                                                                 (get(Field.FourthField, FieldWidth.FourthFieldWidth) > 0) +
                                                                                 (get(Field.FifthField, FieldWidth.FifthFieldWidth) > 0) +
                                                                                 (get(Field.AlphaField, FieldWidth.AlphaFieldWidth) > 0)); }

    pragma(inline, true) uchar redSize() const/+ noexcept+/ { return get(Field.FirstField, FieldWidth.FirstFieldWidth); }
    pragma(inline, true) uchar greenSize() const/+ noexcept+/ { return get(Field.SecondField, FieldWidth.SecondFieldWidth); }
    pragma(inline, true) uchar blueSize() const/+ noexcept+/ { return get(Field.ThirdField, FieldWidth.ThirdFieldWidth); }

    pragma(inline, true) uchar cyanSize() const/+ noexcept+/ { return get(Field.FirstField, FieldWidth.FirstFieldWidth); }
    pragma(inline, true) uchar magentaSize() const/+ noexcept+/ { return get(Field.SecondField, FieldWidth.SecondFieldWidth); }
    pragma(inline, true) uchar yellowSize() const/+ noexcept+/ { return get(Field.ThirdField, FieldWidth.ThirdFieldWidth); }
    pragma(inline, true) uchar blackSize() const/+ noexcept+/ { return get(Field.FourthField, FieldWidth.FourthFieldWidth); }

    pragma(inline, true) uchar hueSize() const/+ noexcept+/ { return get(Field.FirstField, FieldWidth.FirstFieldWidth); }
    pragma(inline, true) uchar saturationSize() const/+ noexcept+/ { return get(Field.SecondField, FieldWidth.SecondFieldWidth); }
    pragma(inline, true) uchar lightnessSize() const/+ noexcept+/ { return get(Field.ThirdField, FieldWidth.ThirdFieldWidth); }
    pragma(inline, true) uchar brightnessSize() const/+ noexcept+/ { return get(Field.ThirdField, FieldWidth.ThirdFieldWidth); }

    pragma(inline, true) uchar alphaSize() const/+ noexcept+/ { return get(Field.AlphaField, FieldWidth.AlphaFieldWidth); }

    pragma(inline, true) uchar bitsPerPixel() const/+ noexcept+/ { return cast(uchar)(get(Field.FirstField, FieldWidth.FirstFieldWidth) +
                                                                                 get(Field.SecondField, FieldWidth.SecondFieldWidth) +
                                                                                 get(Field.ThirdField, FieldWidth.ThirdFieldWidth) +
                                                                                 get(Field.FourthField, FieldWidth.FourthFieldWidth) +
                                                                                 get(Field.FifthField, FieldWidth.FifthFieldWidth) +
                                                                                 get(Field.AlphaField, FieldWidth.AlphaFieldWidth)); }

    pragma(inline, true) AlphaUsage alphaUsage() const/+ noexcept+/ { return cast(AlphaUsage)(get(Field.AlphaUsageField, FieldWidth.AlphaUsageFieldWidth)); }
    pragma(inline, true) AlphaPosition alphaPosition() const/+ noexcept+/ { return cast(AlphaPosition)(get(Field.AlphaPositionField, FieldWidth.AlphaPositionFieldWidth)); }
    pragma(inline, true) AlphaPremultiplied premultiplied() const/+ noexcept+/ { return cast(AlphaPremultiplied)(get(Field.PremulField, FieldWidth.PremulFieldWidth)); }
    pragma(inline, true) TypeInterpretation typeInterpretation() const/+ noexcept+/ { return cast(TypeInterpretation)(get(Field.TypeInterpretationField, FieldWidth.TypeInterpretationFieldWidth)); }
    pragma(inline, true) ByteOrder byteOrder() const/+ noexcept+/ { return cast(ByteOrder)(get(Field.ByteOrderField, FieldWidth.ByteOrderFieldWidth)); }

    pragma(inline, true) YUVLayout yuvLayout() const/+ noexcept+/ { return cast(YUVLayout)(get(Field.SubEnumField, FieldWidth.SubEnumFieldWidth)); }
    pragma(inline, true) uchar subEnum() const/+ noexcept+/ { return get(Field.SubEnumField, FieldWidth.SubEnumFieldWidth); }

private:
    pragma(inline, true) static ByteOrder resolveByteOrder(ByteOrder bo)
    {
        return bo == ByteOrder.CurrentSystemEndian ? versionIsSet!"LittleEndian" ? ByteOrder.LittleEndian : ByteOrder.BigEndian : bo ;
    }

private:
    quint64 data = 0;

    /+ friend Q_DECL_CONST_FUNCTION inline bool operator==(QPixelFormat fmt1, QPixelFormat fmt2)
    { return fmt1.data == fmt2.data; } +/

    /+ friend Q_DECL_CONST_FUNCTION inline bool operator!=(QPixelFormat fmt1, QPixelFormat fmt2)
    { return !(fmt1 == fmt2); } +/
}
/+ Q_STATIC_ASSERT(sizeof(QPixelFormat) == sizeof(quint64));
Q_DECLARE_TYPEINFO(QPixelFormat, Q_PRIMITIVE_TYPE); +/


extern(C++, "QtPrivate") {
    QPixelFormat /+ Q_GUI_EXPORT +/ QPixelFormat_createYUV(QPixelFormat.YUVLayout yuvLayout,
                                                         uchar alphaSize,
                                                         QPixelFormat.AlphaUsage alphaUsage,
                                                         QPixelFormat.AlphaPosition alphaPosition,
                                                         QPixelFormat.AlphaPremultiplied premultiplied,
                                                         QPixelFormat.TypeInterpretation typeInterpretation,
                                                         QPixelFormat.ByteOrder byteOrder);
}

/+pragma(inline, true) QPixelFormat qPixelFormatRgba(uchar red,
                                                      uchar green,
                                                      uchar blue,
                                                      uchar alfa,
                                                      QPixelFormat.AlphaUsage usage,
                                                      QPixelFormat.AlphaPosition position,
                                                      QPixelFormat.AlphaPremultiplied pmul=QPixelFormat.AlphaPremultiplied.NotPremultiplied,
                                                      QPixelFormat.TypeInterpretation typeInt=QPixelFormat.TypeInterpretation.UnsignedInteger)/+ noexcept+/
{
    return QPixelFormat(QPixelFormat.ColorModel.RGB,
                        red,
                        green,
                        blue,
                        0,
                        0,
                        alfa,
                        usage,
                        position,
                        pmul,
                        typeInt);
}

pragma(inline, true) QPixelFormat qPixelFormatGrayscale(uchar channelSize,
                                                           QPixelFormat.TypeInterpretation typeInt=QPixelFormat.TypeInterpretation.UnsignedInteger)/+ noexcept+/
{
    return QPixelFormat(QPixelFormat.ColorModel.Grayscale,
                        channelSize,
                        0,
                        0,
                        0,
                        0,
                        0,
                        QPixelFormat.AlphaUsage.IgnoresAlpha,
                        QPixelFormat.AlphaPosition.AtBeginning,
                        QPixelFormat.AlphaPremultiplied.NotPremultiplied,
                        typeInt);
}

pragma(inline, true) QPixelFormat qPixelFormatAlpha(uchar channelSize,
                                                       QPixelFormat.TypeInterpretation typeInt=QPixelFormat.TypeInterpretation.UnsignedInteger)/+ noexcept+/
{
    return QPixelFormat(QPixelFormat.ColorModel.Alpha,
                        0,
                        0,
                        0,
                        0,
                        0,
                        channelSize,
                        QPixelFormat.AlphaUsage.UsesAlpha,
                        QPixelFormat.AlphaPosition.AtBeginning,
                        QPixelFormat.AlphaPremultiplied.NotPremultiplied,
                        typeInt);
}

pragma(inline, true) QPixelFormat qPixelFormatCmyk(uchar channelSize,
                                                      uchar alfa=0,
                                                      QPixelFormat.AlphaUsage usage=QPixelFormat.AlphaUsage.IgnoresAlpha,
                                                      QPixelFormat.AlphaPosition position=QPixelFormat.AlphaPosition.AtBeginning,
                                                      QPixelFormat.TypeInterpretation typeInt=QPixelFormat.TypeInterpretation.UnsignedInteger)/+ noexcept+/
{
    return QPixelFormat(QPixelFormat.ColorModel.CMYK,
                        channelSize,
                        channelSize,
                        channelSize,
                        channelSize,
                        0,
                        alfa,
                        usage,
                        position,
                        QPixelFormat.AlphaPremultiplied.NotPremultiplied,
                        typeInt);
}

pragma(inline, true) QPixelFormat qPixelFormatHsl(uchar channelSize,
                                                     uchar alfa=0,
                                                     QPixelFormat.AlphaUsage usage=QPixelFormat.AlphaUsage.IgnoresAlpha,
                                                     QPixelFormat.AlphaPosition position=QPixelFormat.AlphaPosition.AtBeginning,
                                                     QPixelFormat.TypeInterpretation typeInt=QPixelFormat.TypeInterpretation.FloatingPoint)/+ noexcept+/
{
    return QPixelFormat(QPixelFormat.ColorModel.HSL,
                        channelSize,
                        channelSize,
                        channelSize,
                        0,
                        0,
                        alfa,
                        usage,
                        position,
                        QPixelFormat.AlphaPremultiplied.NotPremultiplied,
                        typeInt);
}

pragma(inline, true) QPixelFormat qPixelFormatHsv(uchar channelSize,
                                                     uchar alfa=0,
                                                     QPixelFormat.AlphaUsage usage=QPixelFormat.AlphaUsage.IgnoresAlpha,
                                                     QPixelFormat.AlphaPosition position=QPixelFormat.AlphaPosition.AtBeginning,
                                                     QPixelFormat.TypeInterpretation typeInt=QPixelFormat.TypeInterpretation.FloatingPoint)/+ noexcept+/
{
    return QPixelFormat(QPixelFormat.ColorModel.HSV,
                        channelSize,
                        channelSize,
                        channelSize,
                        0,
                        0,
                        alfa,
                        usage,
                        position,
                        QPixelFormat.AlphaPremultiplied.NotPremultiplied,
                        typeInt);
}

pragma(inline, true) QPixelFormat qPixelFormatYuv(QPixelFormat.YUVLayout layout,
                                    uchar alfa=0,
                                    QPixelFormat.AlphaUsage usage=QPixelFormat.AlphaUsage.IgnoresAlpha,
                                    QPixelFormat.AlphaPosition position=QPixelFormat.AlphaPosition.AtBeginning,
                                    QPixelFormat.AlphaPremultiplied p_mul=QPixelFormat.AlphaPremultiplied.NotPremultiplied,
                                    QPixelFormat.TypeInterpretation typeInt=QPixelFormat.TypeInterpretation.UnsignedByte,
                                    QPixelFormat.ByteOrder b_order=QPixelFormat.ByteOrder.LittleEndian)
{
    return /+ QtPrivate:: +/QPixelFormat_createYUV(layout,
                                             alfa,
                                             usage,
                                             position,
                                             p_mul,
                                             typeInt,
                                             b_order);
}
+/

