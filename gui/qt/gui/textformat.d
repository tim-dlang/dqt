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
module qt.gui.textformat;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.global;
import qt.core.list;
import qt.core.map;
import qt.core.metamacros;
import qt.core.namespace;
import qt.core.shareddata;
import qt.core.string;
import qt.core.stringlist;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.brush;
import qt.gui.color;
import qt.gui.font;
import qt.gui.pen;
import qt.gui.textoption;
import qt.helpers;


extern(C++, class) struct QTextFormatPrivate;

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QTextLength &);
#endif +/

/// Binding for C++ class [QTextLength](https://doc.qt.io/qt-6/qtextlength.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextLength
{
public:
    enum Type { VariableLength = 0, FixedLength, PercentageLength }

    /+pragma(inline, true) this()
    {
        this.lengthType = Type.VariableLength;
        this.fixedValueOrPercentage = 0;
    }+/

    /+ explicit +/pragma(inline, true) this(Type atype, qreal avalue)
    {
        this.lengthType = atype;
        this.fixedValueOrPercentage = avalue;
    }

    pragma(inline, true) Type type() const { return lengthType; }
    pragma(inline, true) qreal value(qreal maximumLength) const
    {
        switch (lengthType) {
            case Type.FixedLength: return fixedValueOrPercentage;
            case Type.VariableLength: return maximumLength;
            case Type.PercentageLength: return fixedValueOrPercentage * maximumLength / qreal(100);default:

        }
        return -1;
    }

    pragma(inline, true) qreal rawValue() const { return fixedValueOrPercentage; }

    /+pragma(inline, true) bool operator ==(ref const(QTextLength) other) const
    { return lengthType == other.lengthType
             && qFuzzyCompare(fixedValueOrPercentage, other.fixedValueOrPercentage); }+/
    /+pragma(inline, true) bool operator !=(ref const(QTextLength) other) const
    { return lengthType != other.lengthType
             || !qFuzzyCompare(fixedValueOrPercentage, other.fixedValueOrPercentage); }+/
    /+auto opCast(T : QVariant)() const;+/

private:
    Type lengthType = Type.VariableLength;
    qreal fixedValueOrPercentage = 0;
    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QTextLength &); +/
    /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QTextLength &); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QTextLength, Q_PRIMITIVE_TYPE);

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QTextFormat &);
#endif +/

/// Binding for C++ class [QTextFormat](https://doc.qt.io/qt-6/qtextformat.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextFormat
{
    mixin(Q_GADGET);
public:
    enum FormatType {
        InvalidFormat = -1,
        BlockFormat = 1,
        CharFormat = 2,
        ListFormat = 3,
        FrameFormat = 5,

        UserFormat = 100
    }
    /+ Q_ENUM(FormatType) +/

    enum Property {
        ObjectIndex = 0x0,

        // paragraph and char
        CssFloat = 0x0800,
        LayoutDirection = 0x0801,

        OutlinePen = 0x810,
        BackgroundBrush = 0x820,
        ForegroundBrush = 0x821,
        // Internal to qtextlayout.cpp: ObjectSelectionBrush = 0x822
        BackgroundImageUrl = 0x823,

        // paragraph
        BlockAlignment = 0x1010,
        BlockTopMargin = 0x1030,
        BlockBottomMargin = 0x1031,
        BlockLeftMargin = 0x1032,
        BlockRightMargin = 0x1033,
        TextIndent = 0x1034,
        TabPositions = 0x1035,
        BlockIndent = 0x1040,
        LineHeight = 0x1048,
        LineHeightType = 0x1049,
        BlockNonBreakableLines = 0x1050,
        BlockTrailingHorizontalRulerWidth = 0x1060,
        HeadingLevel = 0x1070,
        BlockQuoteLevel = 0x1080,
        BlockCodeLanguage = 0x1090,
        BlockCodeFence = 0x1091,
        BlockMarker = 0x10A0,

        // character properties
        FirstFontProperty = 0x1FE0,
        FontCapitalization = Property.FirstFontProperty,
        FontLetterSpacing = 0x1FE1,
        FontWordSpacing = 0x1FE2,
        FontStyleHint = 0x1FE3,
        FontStyleStrategy = 0x1FE4,
        FontKerning = 0x1FE5,
        FontHintingPreference = 0x1FE6,
        FontFamilies = 0x1FE7,
        FontStyleName = 0x1FE8,
        FontLetterSpacingType = 0x1FE9,
        FontStretch = 0x1FEA,
/+ #if QT_DEPRECATED_SINCE(6, 0) +/
        FontFamily = 0x2000,
/+ #endif +/
        FontPointSize = 0x2001,
        FontSizeAdjustment = 0x2002,
        FontSizeIncrement = Property.FontSizeAdjustment, // old name, compat
        FontWeight = 0x2003,
        FontItalic = 0x2004,
        FontUnderline = 0x2005, // deprecated, use TextUnderlineStyle instead
        FontOverline = 0x2006,
        FontStrikeOut = 0x2007,
        FontFixedPitch = 0x2008,
        FontPixelSize = 0x2009,
        LastFontProperty = Property.FontPixelSize,

        TextUnderlineColor = 0x2020,
        TextVerticalAlignment = 0x2021,
        TextOutline = 0x2022,
        TextUnderlineStyle = 0x2023,
        TextToolTip = 0x2024,
        TextSuperScriptBaseline = 0x2025,
        TextSubScriptBaseline = 0x2026,
        TextBaselineOffset = 0x2027,

        IsAnchor = 0x2030,
        AnchorHref = 0x2031,
        AnchorName = 0x2032,

        // Included for backwards compatibility with old QDataStreams.
        // Should not be referenced in user code.
        OldFontLetterSpacingType = 0x2033,
        OldFontStretch = 0x2034,
        OldTextUnderlineColor = 0x2010,
        OldFontFamily = 0x2000, // same as FontFamily

        ObjectType = 0x2f00,

        // list properties
        ListStyle = 0x3000,
        ListIndent = 0x3001,
        ListNumberPrefix = 0x3002,
        ListNumberSuffix = 0x3003,

        // table and frame properties
        FrameBorder = 0x4000,
        FrameMargin = 0x4001,
        FramePadding = 0x4002,
        FrameWidth = 0x4003,
        FrameHeight = 0x4004,
        FrameTopMargin    = 0x4005,
        FrameBottomMargin = 0x4006,
        FrameLeftMargin   = 0x4007,
        FrameRightMargin  = 0x4008,
        FrameBorderBrush = 0x4009,
        FrameBorderStyle = 0x4010,

        TableColumns = 0x4100,
        TableColumnWidthConstraints = 0x4101,
        TableCellSpacing = 0x4102,
        TableCellPadding = 0x4103,
        TableHeaderRowCount = 0x4104,
        TableBorderCollapse = 0x4105,

        // table cell properties
        TableCellRowSpan = 0x4810,
        TableCellColumnSpan = 0x4811,

        TableCellTopPadding = 0x4812,
        TableCellBottomPadding = 0x4813,
        TableCellLeftPadding = 0x4814,
        TableCellRightPadding = 0x4815,

        TableCellTopBorder = 0x4816,
        TableCellBottomBorder = 0x4817,
        TableCellLeftBorder = 0x4818,
        TableCellRightBorder = 0x4819,

        TableCellTopBorderStyle = 0x481a,
        TableCellBottomBorderStyle = 0x481b,
        TableCellLeftBorderStyle = 0x481c,
        TableCellRightBorderStyle = 0x481d,

        TableCellTopBorderBrush = 0x481e,
        TableCellBottomBorderBrush = 0x481f,
        TableCellLeftBorderBrush = 0x4820,
        TableCellRightBorderBrush = 0x4821,

        // image properties
        ImageName = 0x5000,
        ImageTitle = 0x5001,
        ImageAltText = 0x5002,
        ImageWidth = 0x5010,
        ImageHeight = 0x5011,
        ImageQuality = 0x5014,

        // internal
        /*
           SuppressText = 0x5012,
           SuppressBackground = 0x513
        */

        // selection properties
        FullWidthSelection = 0x06000,

        // page break properties
        PageBreakPolicy = 0x7000,

        // --
        UserProperty = 0x100000
    }
    /+ Q_ENUM(Property) +/

    enum ObjectTypes {
        NoObject,
        ImageObject,
        TableObject,
        TableCellObject,

        UserObject = 0x1000
    }
    /+ Q_ENUM(ObjectTypes) +/

    enum PageBreakFlag {
        PageBreak_Auto = 0,
        PageBreak_AlwaysBefore = 0x001,
        PageBreak_AlwaysAfter  = 0x010
        // PageBreak_AlwaysInside = 0x100
    }
    /+ Q_DECLARE_FLAGS(PageBreakFlags, PageBreakFlag) +/
alias PageBreakFlags = QFlags!(PageBreakFlag);
    /+this();+/

    /+ explicit +/this(int type)
    {
        format_type = type;
    }

    //@disable this(this);
    //this(ref const(QTextFormat) rhs);
    /+ref QTextFormat operator =(ref const(QTextFormat) rhs);+/
    ~this();

    /+ void swap(QTextFormat &other)
    { d.swap(other.d); std::swap(format_type, other.format_type); } +/

    void merge(ref const(QTextFormat) other);

    pragma(inline, true) bool isValid() const { return type() != FormatType.InvalidFormat; }
    pragma(inline, true) bool isEmpty() const { return propertyCount() == 0; }

    int type() const;

    int objectIndex() const;
    void setObjectIndex(int object);

    QVariant property(int propertyId) const;
    void setProperty(int propertyId, ref const(QVariant) value);
    void setProperty(T)(int propertyId, T value)
    {
        static if (is(T==enum))
            QVariant v = QVariant(cast(int)value);
        else
            QVariant v = QVariant.fromValue(value);
        setProperty(propertyId, v);
    }
    void clearProperty(int propertyId);
    bool hasProperty(int propertyId) const;

    bool boolProperty(int propertyId) const;
    int intProperty(int propertyId) const;
    qreal doubleProperty(int propertyId) const;
    QString stringProperty(int propertyId) const;
    QColor colorProperty(int propertyId) const;
    QPen penProperty(int propertyId) const;
    QBrush brushProperty(int propertyId) const;
    QTextLength lengthProperty(int propertyId) const;
    QList!(QTextLength) lengthVectorProperty(int propertyId) const;

    void setProperty(int propertyId, ref const(QList!(QTextLength)) lengths);

//    QMap!(int, QVariant) properties() const;
    int propertyCount() const;

    pragma(inline, true) void setObjectType(int atype)
    { setProperty(Property.ObjectType, atype); }
    pragma(inline, true) int objectType() const
    { return intProperty(Property.ObjectType); }

    pragma(inline, true) bool isCharFormat() const { return type() == FormatType.CharFormat; }
    pragma(inline, true) bool isBlockFormat() const { return type() == FormatType.BlockFormat; }
    pragma(inline, true) bool isListFormat() const { return type() == FormatType.ListFormat; }
    pragma(inline, true) bool isFrameFormat() const { return type() == FormatType.FrameFormat; }
    pragma(inline, true) bool isImageFormat() const { return type() == FormatType.CharFormat && objectType() == ObjectTypes.ImageObject; }
    pragma(inline, true) bool isTableFormat() const { return type() == FormatType.FrameFormat && objectType() == ObjectTypes.TableObject; }
    pragma(inline, true) bool isTableCellFormat() const { return type() == FormatType.CharFormat && objectType() == ObjectTypes.TableCellObject; }

    QTextBlockFormat toBlockFormat() const;
    QTextCharFormat toCharFormat() const;
    QTextListFormat toListFormat() const;
    QTextTableFormat toTableFormat() const;
    QTextFrameFormat toFrameFormat() const;
    QTextImageFormat toImageFormat() const;
    QTextTableCellFormat toTableCellFormat() const;

    /+bool operator ==(ref const(QTextFormat) rhs) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QTextFormat) rhs) const { return !operator==(rhs); }+/
    /+auto opCast(T : QVariant)() const;+/

    pragma(inline, true) void setLayoutDirection(/+ Qt:: +/qt.core.namespace.LayoutDirection direction)
        { setProperty(QTextFormat.Property.LayoutDirection, direction); }
    pragma(inline, true) /+ Qt:: +/qt.core.namespace.LayoutDirection layoutDirection() const
        { return cast(/+ Qt:: +/qt.core.namespace.LayoutDirection) (intProperty(QTextFormat.Property.LayoutDirection)); }

/*    pragma(inline, true) void setBackground(ref const(QBrush) brush)
    { setProperty(Property.BackgroundBrush, brush); }*/
    pragma(inline, true) QBrush background() const
    { return brushProperty(Property.BackgroundBrush); }
    pragma(inline, true) void clearBackground()
    { clearProperty(Property.BackgroundBrush); }

/+    pragma(inline, true) void setForeground(ref const(QBrush) brush)
    { setProperty(Property.ForegroundBrush, brush); }+/
    pragma(inline, true) QBrush foreground() const
    { return brushProperty(Property.ForegroundBrush); }
    pragma(inline, true) void clearForeground()
    { clearProperty(Property.ForegroundBrush); }

private:
    QSharedDataPointer!(QTextFormatPrivate) d;
    qint32 format_type = FormatType.InvalidFormat;

    /+ friend class QTextFormatCollection; +/
    /+ friend class QTextCharFormat; +/
    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QTextFormat &); +/
    /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QTextFormat &); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QTextFormat) +/
/+pragma(inline, true) QFlags!(QTextFormat.PageBreakFlags.enum_type) operator |(QTextFormat.PageBreakFlags.enum_type f1, QTextFormat.PageBreakFlags.enum_type f2)/+noexcept+/{return QFlags!(QTextFormat.PageBreakFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QTextFormat.PageBreakFlags.enum_type) operator |(QTextFormat.PageBreakFlags.enum_type f1, QFlags!(QTextFormat.PageBreakFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QTextFormat.PageBreakFlags.enum_type) operator &(QTextFormat.PageBreakFlags.enum_type f1, QTextFormat.PageBreakFlags.enum_type f2)/+noexcept+/{return QFlags!(QTextFormat.PageBreakFlags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QTextFormat.PageBreakFlags.enum_type) operator &(QTextFormat.PageBreakFlags.enum_type f1, QFlags!(QTextFormat.PageBreakFlags.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QTextFormat.PageBreakFlags.enum_type) operator ^(QTextFormat.PageBreakFlags.enum_type f1, QTextFormat.PageBreakFlags.enum_type f2)/+noexcept+/{return QFlags!(QTextFormat.PageBreakFlags.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QTextFormat.PageBreakFlags.enum_type) operator ^(QTextFormat.PageBreakFlags.enum_type f1, QFlags!(QTextFormat.PageBreakFlags.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QTextFormat.PageBreakFlags.enum_type f1, QTextFormat.PageBreakFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QTextFormat.PageBreakFlags.enum_type f1, QFlags!(QTextFormat.PageBreakFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QTextFormat.PageBreakFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QTextFormat.PageBreakFlags.enum_type f1, QTextFormat.PageBreakFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QTextFormat.PageBreakFlags.enum_type f1, QFlags!(QTextFormat.PageBreakFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QTextFormat.PageBreakFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QTextFormat.PageBreakFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QTextFormat.PageBreakFlags.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QTextFormat.PageBreakFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QTextFormat.PageBreakFlags.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QTextFormat.PageBreakFlags operator ~(QTextFormat.PageBreakFlags.enum_type e)/+noexcept+/{return~QTextFormat.PageBreakFlags(e);}+/
/+pragma(inline, true) void operator |(QTextFormat.PageBreakFlags.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QTextFormat.PageBreakFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QTextFormat::PageBreakFlags) +/
/// Binding for C++ class [QTextCharFormat](https://doc.qt.io/qt-6/qtextcharformat.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextCharFormat
{
    public QTextFormat base0 = QTextFormat(QTextFormat.FormatType.CharFormat);
    alias base0 this;
public:
    enum VerticalAlignment {
        AlignNormal = 0,
        AlignSuperScript,
        AlignSubScript,
        AlignMiddle,
        AlignTop,
        AlignBottom,
        AlignBaseline
    }
    enum UnderlineStyle { // keep in sync with Qt::PenStyle!
        NoUnderline,
        SingleUnderline,
        DashUnderline,
        DotLine,
        DashDotLine,
        DashDotDotLine,
        WaveUnderline,
        SpellCheckUnderline
    }

    /+this();+/

    bool isValid() const { return isCharFormat(); }

    enum FontPropertiesInheritanceBehavior {
        FontPropertiesSpecifiedOnly,
        FontPropertiesAll
    }
    void setFont(ref const(QFont) font, FontPropertiesInheritanceBehavior behavior = FontPropertiesInheritanceBehavior.FontPropertiesAll);
    QFont font() const;

/+ #if QT_DEPRECATED_SINCE(6, 1) +/
    /+ /+ QT_DEPRECATED_VERSION_X_6_1("Use setFontFamilies instead") +/ pragma(inline, true) void setFontFamily(ref const(QString) family)
    { auto tmp = QVariant(QStringList(family)); setProperty(Property.FontFamilies, tmp); }
    /+ QT_DEPRECATED_VERSION_X_6_1("Use fontFamilies instead") +/ pragma(inline, true) QString fontFamily() const
    { return property(Property.FontFamilies).toStringList().first(); } +/
/+ #endif +/

    pragma(inline, true) void setFontFamilies(ref const(QStringList) families)
    { auto tmp = QVariant(families); setProperty(Property.FontFamilies, tmp); }
/+ #if QT_VERSION < QT_VERSION_CHECK(7, 0, 0) +/
    pragma(inline, true) QVariant fontFamilies() const
    { return property(Property.FontFamilies); }
/+ #else
    inline QStringList fontFamilies() const
    { return property(FontFamilies).toStringList(); }
#endif +/

    pragma(inline, true) void setFontStyleName(ref const(QString) styleName)
    { setProperty(Property.FontStyleName, styleName); }
/+ #if QT_VERSION < QT_VERSION_CHECK(7, 0, 0) +/
    pragma(inline, true) QVariant fontStyleName() const
    { return property(Property.FontStyleName); }
/+ #else
    inline QStringList fontStyleName() const
    { return property(FontStyleName).toStringList(); }
#endif +/

    pragma(inline, true) void setFontPointSize(qreal size)
    { setProperty(Property.FontPointSize, size); }
    pragma(inline, true) qreal fontPointSize() const
    { return doubleProperty(Property.FontPointSize); }

    pragma(inline, true) void setFontWeight(int weight)
    { setProperty(Property.FontWeight, weight); }
    pragma(inline, true) int fontWeight() const
    { return hasProperty(Property.FontWeight) ? intProperty(Property.FontWeight) : QFont.Weight.Normal; }
    pragma(inline, true) void setFontItalic(bool italic)
    { setProperty(Property.FontItalic, italic); }
    pragma(inline, true) bool fontItalic() const
    { return boolProperty(Property.FontItalic); }
    pragma(inline, true) void setFontCapitalization(QFont.Capitalization capitalization)
    { setProperty(Property.FontCapitalization, capitalization); }
    pragma(inline, true) QFont.Capitalization fontCapitalization() const
    { return static_cast!(QFont.Capitalization)(intProperty(Property.FontCapitalization)); }
    pragma(inline, true) void setFontLetterSpacingType(QFont.SpacingType letterSpacingType)
    { setProperty(Property.FontLetterSpacingType, letterSpacingType); }
    pragma(inline, true) QFont.SpacingType fontLetterSpacingType() const
    { return static_cast!(QFont.SpacingType)(intProperty(Property.FontLetterSpacingType)); }
    pragma(inline, true) void setFontLetterSpacing(qreal spacing)
    { setProperty(Property.FontLetterSpacing, spacing); }
    pragma(inline, true) qreal fontLetterSpacing() const
    { return doubleProperty(Property.FontLetterSpacing); }
    pragma(inline, true) void setFontWordSpacing(qreal spacing)
    { setProperty(Property.FontWordSpacing, spacing); }
    pragma(inline, true) qreal fontWordSpacing() const
    { return doubleProperty(Property.FontWordSpacing); }

    pragma(inline, true) void setFontUnderline(bool underline)
    { setProperty(Property.TextUnderlineStyle, underline ? UnderlineStyle.SingleUnderline : UnderlineStyle.NoUnderline); }
    bool fontUnderline() const;

    pragma(inline, true) void setFontOverline(bool overline)
    { setProperty(Property.FontOverline, overline); }
    pragma(inline, true) bool fontOverline() const
    { return boolProperty(Property.FontOverline); }

    pragma(inline, true) void setFontStrikeOut(bool strikeOut)
    { setProperty(Property.FontStrikeOut, strikeOut); }
    pragma(inline, true) bool fontStrikeOut() const
    { return boolProperty(Property.FontStrikeOut); }

    pragma(inline, true) void setUnderlineColor(ref const(QColor) color)
    { setProperty(Property.TextUnderlineColor, color); }
    pragma(inline, true) QColor underlineColor() const
    { return colorProperty(Property.TextUnderlineColor); }

    pragma(inline, true) void setFontFixedPitch(bool fixedPitch)
    { setProperty(Property.FontFixedPitch, fixedPitch); }
    pragma(inline, true) bool fontFixedPitch() const
    { return boolProperty(Property.FontFixedPitch); }

    pragma(inline, true) void setFontStretch(int factor)
    { setProperty(Property.FontStretch, factor); }
    pragma(inline, true) int fontStretch() const
    { return intProperty(Property.FontStretch); }

    pragma(inline, true) void setFontStyleHint(QFont.StyleHint hint, QFont.StyleStrategy strategy = QFont.StyleStrategy.PreferDefault)
    { setProperty(Property.FontStyleHint, hint); setProperty(Property.FontStyleStrategy, strategy); }
    pragma(inline, true) void setFontStyleStrategy(QFont.StyleStrategy strategy)
    { setProperty(Property.FontStyleStrategy, strategy); }
    QFont.StyleHint fontStyleHint() const
    { return static_cast!(QFont.StyleHint)(intProperty(Property.FontStyleHint)); }
    QFont.StyleStrategy fontStyleStrategy() const
    { return static_cast!(QFont.StyleStrategy)(intProperty(Property.FontStyleStrategy)); }

    pragma(inline, true) void setFontHintingPreference(QFont.HintingPreference hintingPreference)
    {
        setProperty(Property.FontHintingPreference, hintingPreference);
    }

    pragma(inline, true) QFont.HintingPreference fontHintingPreference() const
    {
        return static_cast!(QFont.HintingPreference)(intProperty(Property.FontHintingPreference));
    }

    pragma(inline, true) void setFontKerning(bool enable)
    { setProperty(Property.FontKerning, enable); }
    pragma(inline, true) bool fontKerning() const
    { return boolProperty(Property.FontKerning); }

    void setUnderlineStyle(UnderlineStyle style);
    pragma(inline, true) UnderlineStyle underlineStyle() const
    { return static_cast!(UnderlineStyle)(intProperty(Property.TextUnderlineStyle)); }

    pragma(inline, true) void setVerticalAlignment(VerticalAlignment alignment)
    { setProperty(Property.TextVerticalAlignment, alignment); }
    pragma(inline, true) VerticalAlignment verticalAlignment() const
    { return static_cast!(VerticalAlignment)(intProperty(Property.TextVerticalAlignment)); }

/*    pragma(inline, true) void setTextOutline(ref const(QPen) pen)
    { setProperty(Property.TextOutline, pen); }
    pragma(inline, true) QPen textOutline() const
    { return penProperty(Property.TextOutline); }*/

    pragma(inline, true) void setToolTip(ref const(QString) tip)
    { setProperty(Property.TextToolTip, tip); }
    pragma(inline, true) QString toolTip() const
    { return stringProperty(Property.TextToolTip); }

    pragma(inline, true) void setSuperScriptBaseline(qreal baseline)
    { setProperty(Property.TextSuperScriptBaseline, baseline); }
    pragma(inline, true) qreal superScriptBaseline() const
    { return hasProperty(Property.TextSuperScriptBaseline) ? doubleProperty(Property.TextSuperScriptBaseline) : 50.0; }

    pragma(inline, true) void setSubScriptBaseline(qreal baseline)
    { setProperty(Property.TextSubScriptBaseline, baseline); }
    pragma(inline, true) qreal subScriptBaseline() const
    { return hasProperty(Property.TextSubScriptBaseline) ? doubleProperty(Property.TextSubScriptBaseline) : 100.0 / 6.0; }

    pragma(inline, true) void setBaselineOffset(qreal baseline)
    { setProperty(Property.TextBaselineOffset, baseline); }
    pragma(inline, true) qreal baselineOffset() const
    { return hasProperty(Property.TextBaselineOffset) ? doubleProperty(Property.TextBaselineOffset) : 0.0; }

    pragma(inline, true) void setAnchor(bool anchor)
    { setProperty(Property.IsAnchor, anchor); }
    pragma(inline, true) bool isAnchor() const
    { return boolProperty(Property.IsAnchor); }

    pragma(inline, true) void setAnchorHref(ref const(QString) value)
    { setProperty(Property.AnchorHref, value); }
    pragma(inline, true) QString anchorHref() const
    { return stringProperty(Property.AnchorHref); }

/+    pragma(inline, true) void setAnchorNames(ref const(QStringList) names)
    { base0.setProperty!(const(QStringList))(Property.AnchorName, names); }
    QStringList anchorNames() const;+/

    pragma(inline, true) void setTableCellRowSpan(int _tableCellRowSpan)
    {
        if (_tableCellRowSpan <= 1)
            clearProperty(Property.TableCellRowSpan); // the getter will return 1 here.
        else
            setProperty(Property.TableCellRowSpan, _tableCellRowSpan);
    }
    pragma(inline, true) int tableCellRowSpan() const
    { int s = intProperty(Property.TableCellRowSpan); if (s == 0) s = 1; return s; }
    pragma(inline, true) void setTableCellColumnSpan(int _tableCellColumnSpan)
    {
        if (_tableCellColumnSpan <= 1)
            clearProperty(Property.TableCellColumnSpan); // the getter will return 1 here.
        else
            setProperty(Property.TableCellColumnSpan, _tableCellColumnSpan);
    }
    pragma(inline, true) int tableCellColumnSpan() const
    { int s = intProperty(Property.TableCellColumnSpan); if (s == 0) s = 1; return s; }

protected:
    /+ explicit +/this(ref const(QTextFormat) fmt);
    /+ friend class QTextFormat; +/
    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QTextCharFormat &); +/
    /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QTextCharFormat &); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QTextCharFormat) +/

/// Binding for C++ class [QTextBlockFormat](https://doc.qt.io/qt-6/qtextblockformat.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextBlockFormat
{
    public QTextFormat base0 = QTextFormat(QTextFormat.FormatType.BlockFormat);
    alias base0 this;
    alias PageBreakFlags = QTextFormat.PageBreakFlags;
public:
    enum LineHeightTypes {
        SingleHeight = 0,
        ProportionalHeight = 1,
        FixedHeight = 2,
        MinimumHeight = 3,
        LineDistanceHeight = 4
    }

    enum /+ class +/ MarkerType {
        NoMarker = 0,
        Unchecked = 1,
        Checked = 2
    }

    @disable this();
    /+this();+/

    bool isValid() const { return isBlockFormat(); }

    pragma(inline, true) void setAlignment(/+ Qt:: +/qt.core.namespace.Alignment aalignment)
    { auto tmp = aalignment.toInt(); setProperty(Property.BlockAlignment, tmp); }
    pragma(inline, true) /+ Qt:: +/qt.core.namespace.Alignment alignment() const
    { int a = intProperty(Property.BlockAlignment); if (a == 0) a = /+ Qt:: +/qt.core.namespace.AlignmentFlag.AlignLeft; return qt.core.namespace.Alignment(QFlag(a)); }

    pragma(inline, true) void setTopMargin(qreal margin)
    { setProperty(Property.BlockTopMargin, margin); }
    pragma(inline, true) qreal topMargin() const
    { return doubleProperty(Property.BlockTopMargin); }

    pragma(inline, true) void setBottomMargin(qreal margin)
    { setProperty(Property.BlockBottomMargin, margin); }
    pragma(inline, true) qreal bottomMargin() const
    { return doubleProperty(Property.BlockBottomMargin); }

    pragma(inline, true) void setLeftMargin(qreal margin)
    { setProperty(Property.BlockLeftMargin, margin); }
    pragma(inline, true) qreal leftMargin() const
    { return doubleProperty(Property.BlockLeftMargin); }

    pragma(inline, true) void setRightMargin(qreal margin)
    { setProperty(Property.BlockRightMargin, margin); }
    pragma(inline, true) qreal rightMargin() const
    { return doubleProperty(Property.BlockRightMargin); }

    pragma(inline, true) void setTextIndent(qreal aindent)
    { setProperty(Property.TextIndent, aindent); }
    pragma(inline, true) qreal textIndent() const
    { return doubleProperty(Property.TextIndent); }

    pragma(inline, true) void setIndent(int aindent)
    { setProperty(Property.BlockIndent, aindent); }
    pragma(inline, true) int indent() const
    { return intProperty(Property.BlockIndent); }

    pragma(inline, true) void setHeadingLevel(int alevel)
    { setProperty(Property.HeadingLevel, alevel); }
    pragma(inline, true) int headingLevel() const
    { return intProperty(Property.HeadingLevel); }

    pragma(inline, true) void setLineHeight(qreal height, int heightType)
    { setProperty(Property.LineHeight, height); setProperty(Property.LineHeightType, heightType); }
    pragma(inline, true) qreal lineHeight(qreal scriptLineHeight, qreal scaling) const
    /+pragma(inline, true) qreal lineHeight(qreal scriptLineHeight, qreal scaling = 1.0) const+/
    {
      switch(intProperty(Property.LineHeightType)) {
        case LineHeightTypes.SingleHeight:
          return(scriptLineHeight);
        case LineHeightTypes.ProportionalHeight:
          return(scriptLineHeight * doubleProperty(Property.LineHeight) / 100.0);
        case LineHeightTypes.FixedHeight:
          return(doubleProperty(Property.LineHeight) * scaling);
        case LineHeightTypes.MinimumHeight:
          return(qMax(scriptLineHeight, doubleProperty(Property.LineHeight) * scaling));
        case LineHeightTypes.LineDistanceHeight:
          return(scriptLineHeight + doubleProperty(Property.LineHeight) * scaling);default:

      }
      return(0);
    }

    pragma(inline, true) qreal lineHeight() const
    { return doubleProperty(Property.LineHeight); }
    pragma(inline, true) int lineHeightType() const
    { return intProperty(Property.LineHeightType); }

    pragma(inline, true) void setNonBreakableLines(bool b)
    { setProperty(Property.BlockNonBreakableLines, b); }
    pragma(inline, true) bool nonBreakableLines() const
    { return boolProperty(Property.BlockNonBreakableLines); }

    pragma(inline, true) void setPageBreakPolicy(PageBreakFlags flags)
    { auto tmp = flags.toInt(); setProperty(Property.PageBreakPolicy, tmp); }
    pragma(inline, true) PageBreakFlags pageBreakPolicy() const
    { return PageBreakFlags(cast(QFlag) (intProperty(Property.PageBreakPolicy))); }

    void setTabPositions(ref const(QList!(QTextOption.Tab)) tabs);
    QList!(QTextOption.Tab) tabPositions() const;

    pragma(inline, true) void setMarker(MarkerType marker)
    { auto tmp = int(marker); setProperty(Property.BlockMarker, tmp); }
    pragma(inline, true) MarkerType marker() const
    { return cast(MarkerType) (intProperty(Property.BlockMarker)); }

protected:
    /+ explicit +/this(ref const(QTextFormat) fmt);
    /+ friend class QTextFormat; +/
    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QTextBlockFormat &); +/
    /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QTextBlockFormat &); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QTextBlockFormat) +/

/// Binding for C++ class [QTextListFormat](https://doc.qt.io/qt-6/qtextlistformat.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextListFormat
{
    public QTextFormat base0 = QTextFormat(QTextFormat.FormatType.ListFormat);
    alias base0 this;
public:
    /+this();+/

    bool isValid() const { return isListFormat(); }

    enum Style {
        ListDisc = -1,
        ListCircle = -2,
        ListSquare = -3,
        ListDecimal = -4,
        ListLowerAlpha = -5,
        ListUpperAlpha = -6,
        ListLowerRoman = -7,
        ListUpperRoman = -8,
        ListStyleUndefined = 0
    }

    pragma(inline, true) void setStyle(Style astyle)
    { setProperty(Property.ListStyle, astyle); }
    pragma(inline, true) Style style() const
    { return static_cast!(Style)(intProperty(Property.ListStyle)); }

    pragma(inline, true) void setIndent(int aindent)
    { setProperty(Property.ListIndent, aindent); }
    pragma(inline, true) int indent() const
    { return intProperty(Property.ListIndent); }

    pragma(inline, true) void setNumberPrefix(ref const(QString) np)
    { setProperty(Property.ListNumberPrefix, np); }
    pragma(inline, true) QString numberPrefix() const
    { return stringProperty(Property.ListNumberPrefix); }

    pragma(inline, true) void setNumberSuffix(ref const(QString) ns)
    { setProperty(Property.ListNumberSuffix, ns); }
    pragma(inline, true) QString numberSuffix() const
    { return stringProperty(Property.ListNumberSuffix); }

protected:
    /+ explicit +/this(ref const(QTextFormat) fmt);
    /+ friend class QTextFormat; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QTextListFormat) +/

/// Binding for C++ class [QTextImageFormat](https://doc.qt.io/qt-6/qtextimageformat.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextImageFormat
{
    public QTextCharFormat base0;
    alias base0 this;
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }


    bool isValid() const { return isImageFormat(); }

    pragma(inline, true) void setName(ref const(QString) aname)
    { setProperty(Property.ImageName, aname); }
    pragma(inline, true) QString name() const
    { return stringProperty(Property.ImageName); }

    pragma(inline, true) void setWidth(qreal awidth)
    { setProperty(Property.ImageWidth, awidth); }
    pragma(inline, true) qreal width() const
    { return doubleProperty(Property.ImageWidth); }

    pragma(inline, true) void setHeight(qreal aheight)
    { setProperty(Property.ImageHeight, aheight); }
    pragma(inline, true) qreal height() const
    { return doubleProperty(Property.ImageHeight); }

    pragma(inline, true) void setQuality(int aquality)
    { setProperty(Property.ImageQuality, aquality); }
/+ #if QT_DEPRECATED_SINCE(6, 3) +/
    /+ QT_DEPRECATED_VERSION_X_6_3("Pass a quality value, the default is 100") +/ pragma(inline, true) void setQuality()
    { setQuality(100); }
/+ #endif +/
    pragma(inline, true) int quality() const
    { return intProperty(Property.ImageQuality); }

protected:
    /+ explicit +/this(ref const(QTextFormat) format);
    /+ friend class QTextFormat; +/
    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QTextListFormat &); +/
    /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QTextListFormat &); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QTextImageFormat) +/

/// Binding for C++ class [QTextFrameFormat](https://doc.qt.io/qt-6/qtextframeformat.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextFrameFormat
{
    public QTextFormat base0 = QTextFormat(QTextFormat.FormatType.FrameFormat);
    alias base0 this;
    alias PageBreakFlags = QTextFormat.PageBreakFlags;
public:
    @disable this();
    /+this();+/

    bool isValid() const { return isFrameFormat(); }

    enum Position {
        InFlow,
        FloatLeft,
        FloatRight
        // ######
//        Absolute
    }

    enum BorderStyle {
        BorderStyle_None,
        BorderStyle_Dotted,
        BorderStyle_Dashed,
        BorderStyle_Solid,
        BorderStyle_Double,
        BorderStyle_DotDash,
        BorderStyle_DotDotDash,
        BorderStyle_Groove,
        BorderStyle_Ridge,
        BorderStyle_Inset,
        BorderStyle_Outset
    }

    pragma(inline, true) void setPosition(Position f)
    { setProperty(Property.CssFloat, f); }
    pragma(inline, true) Position position() const
    { return static_cast!(Position)(intProperty(Property.CssFloat)); }

    pragma(inline, true) void setBorder(qreal aborder)
    { setProperty(Property.FrameBorder, aborder); }
    pragma(inline, true) qreal border() const
    { return doubleProperty(Property.FrameBorder); }

    pragma(inline, true) void setBorderBrush(ref const(QBrush) brush)
    { setProperty(Property.FrameBorderBrush, brush); }
    pragma(inline, true) QBrush borderBrush() const
    { return brushProperty(Property.FrameBorderBrush); }

    pragma(inline, true) void setBorderStyle(BorderStyle style)
    { setProperty(Property.FrameBorderStyle, style); }
    pragma(inline, true) BorderStyle borderStyle() const
    { return static_cast!(BorderStyle)(intProperty(Property.FrameBorderStyle)); }

    void setMargin(qreal margin);
    pragma(inline, true) qreal margin() const
    { return doubleProperty(Property.FrameMargin); }

    pragma(inline, true) void setTopMargin(qreal amargin)
    { setProperty(Property.FrameTopMargin, amargin); }
    qreal topMargin() const;

    pragma(inline, true) void setBottomMargin(qreal amargin)
    { setProperty(Property.FrameBottomMargin, amargin); }
    qreal bottomMargin() const;

    pragma(inline, true) void setLeftMargin(qreal amargin)
    { setProperty(Property.FrameLeftMargin, amargin); }
    qreal leftMargin() const;

    pragma(inline, true) void setRightMargin(qreal amargin)
    { setProperty(Property.FrameRightMargin, amargin); }
    qreal rightMargin() const;

    pragma(inline, true) void setPadding(qreal apadding)
    { setProperty(Property.FramePadding, apadding); }
    pragma(inline, true) qreal padding() const
    { return doubleProperty(Property.FramePadding); }

    pragma(inline, true) void setWidth(qreal awidth)
    { setProperty(Property.FrameWidth, QTextLength(QTextLength.Type.FixedLength, awidth)); }
    pragma(inline, true) void setWidth(ref const(QTextLength) length)
    { setProperty(Property.FrameWidth, length); }
    pragma(inline, true) QTextLength width() const
    { return lengthProperty(Property.FrameWidth); }

    pragma(inline, true) void setHeight(qreal aheight)
    { setProperty(Property.FrameHeight, QTextLength(QTextLength.Type.FixedLength, aheight)); }
    pragma(inline, true) void setHeight(ref const(QTextLength) aheight)
    { setProperty(Property.FrameHeight, aheight); }
    pragma(inline, true) QTextLength height() const
    { return lengthProperty(Property.FrameHeight); }

    pragma(inline, true) void setPageBreakPolicy(PageBreakFlags flags)
    { auto tmp = flags.toInt(); setProperty(Property.PageBreakPolicy, tmp); }
    pragma(inline, true) PageBreakFlags pageBreakPolicy() const
    { return PageBreakFlags(cast(QFlag) (intProperty(Property.PageBreakPolicy))); }

protected:
    /+ explicit +/this(ref const(QTextFormat) fmt);
    /+ friend class QTextFormat; +/
    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QTextFrameFormat &); +/
    /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QTextFrameFormat &); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QTextFrameFormat) +/

/// Binding for C++ class [QTextTableFormat](https://doc.qt.io/qt-6/qtexttableformat.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextTableFormat
{
    public QTextFrameFormat base0;
    alias base0 this;
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }


    pragma(inline, true) bool isValid() const { return isTableFormat(); }

    pragma(inline, true) int columns() const
    { int cols = intProperty(Property.TableColumns); if (cols == 0) cols = 1; return cols; }
    pragma(inline, true) void setColumns(int acolumns)
    {
        if (acolumns == 1)
            acolumns = 0;
        setProperty(Property.TableColumns, acolumns);
    }

    pragma(inline, true) void setColumnWidthConstraints(ref const(QList!(QTextLength)) constraints)
    { setProperty(Property.TableColumnWidthConstraints, constraints); }

    pragma(inline, true) QList!(QTextLength) columnWidthConstraints() const
    { return lengthVectorProperty(Property.TableColumnWidthConstraints); }

    pragma(inline, true) void clearColumnWidthConstraints()
    { clearProperty(Property.TableColumnWidthConstraints); }

    pragma(inline, true) qreal cellSpacing() const
    { return doubleProperty(Property.TableCellSpacing); }
    pragma(inline, true) void setCellSpacing(qreal spacing)
    { setProperty(Property.TableCellSpacing, spacing); }

    pragma(inline, true) qreal cellPadding() const
    { return doubleProperty(Property.TableCellPadding); }
    pragma(inline, true) void setCellPadding(qreal apadding)
    { setProperty(Property.TableCellPadding, apadding); }

    pragma(inline, true) void setAlignment(/+ Qt:: +/qt.core.namespace.Alignment aalignment)
    { auto tmp = aalignment.toInt(); setProperty(Property.BlockAlignment, tmp); }
    pragma(inline, true) /+ Qt:: +/qt.core.namespace.Alignment alignment() const
    { return qt.core.namespace.Alignment(QFlag(intProperty(Property.BlockAlignment))); }

    pragma(inline, true) void setHeaderRowCount(int count)
    { setProperty(Property.TableHeaderRowCount, count); }
    pragma(inline, true) int headerRowCount() const
    { return intProperty(Property.TableHeaderRowCount); }

    pragma(inline, true) void setBorderCollapse(bool borderCollapse)
    { setProperty(Property.TableBorderCollapse, borderCollapse); }
    pragma(inline, true) bool borderCollapse() const
    { return boolProperty(Property.TableBorderCollapse); }

protected:
    /+ explicit +/this(ref const(QTextFormat) fmt);
    /+ friend class QTextFormat; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QTextTableFormat) +/

/// Binding for C++ class [QTextTableCellFormat](https://doc.qt.io/qt-6/qtexttablecellformat.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextTableCellFormat
{
    public QTextCharFormat base0;
    alias base0 this;
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }


    pragma(inline, true) bool isValid() const { return isTableCellFormat(); }

    pragma(inline, true) void setTopPadding(qreal padding)
    {
        setProperty(Property.TableCellTopPadding, padding);
    }
    pragma(inline, true) qreal topPadding() const
    {
        return doubleProperty(Property.TableCellTopPadding);
    }

    pragma(inline, true) void setBottomPadding(qreal padding)
    {
        setProperty(Property.TableCellBottomPadding, padding);
    }
    pragma(inline, true) qreal bottomPadding() const
    {
        return doubleProperty(Property.TableCellBottomPadding);
    }

    pragma(inline, true) void setLeftPadding(qreal padding)
    {
        setProperty(Property.TableCellLeftPadding, padding);
    }
    pragma(inline, true) qreal leftPadding() const
    {
        return doubleProperty(Property.TableCellLeftPadding);
    }

    pragma(inline, true) void setRightPadding(qreal padding)
    {
        setProperty(Property.TableCellRightPadding, padding);
    }
    pragma(inline, true) qreal rightPadding() const
    {
        return doubleProperty(Property.TableCellRightPadding);
    }

    pragma(inline, true) void setPadding(qreal padding)
    {
        setTopPadding(padding);
        setBottomPadding(padding);
        setLeftPadding(padding);
        setRightPadding(padding);
    }

    pragma(inline, true) void setTopBorder(qreal width)
    { setProperty(Property.TableCellTopBorder, width); }
    pragma(inline, true) qreal topBorder() const
    { return doubleProperty(Property.TableCellTopBorder); }

    pragma(inline, true) void setBottomBorder(qreal width)
    { setProperty(Property.TableCellBottomBorder, width); }
    pragma(inline, true) qreal bottomBorder() const
    { return doubleProperty(Property.TableCellBottomBorder); }

    pragma(inline, true) void setLeftBorder(qreal width)
    { setProperty(Property.TableCellLeftBorder, width); }
    pragma(inline, true) qreal leftBorder() const
    { return doubleProperty(Property.TableCellLeftBorder); }

    pragma(inline, true) void setRightBorder(qreal width)
    { setProperty(Property.TableCellRightBorder, width); }
    pragma(inline, true) qreal rightBorder() const
    { return doubleProperty(Property.TableCellRightBorder); }

    pragma(inline, true) void setBorder(qreal width)
    {
        setTopBorder(width);
        setBottomBorder(width);
        setLeftBorder(width);
        setRightBorder(width);
    }

    pragma(inline, true) void setTopBorderStyle(QTextFrameFormat.BorderStyle style)
    { setProperty(Property.TableCellTopBorderStyle, style); }
    pragma(inline, true) QTextFrameFormat.BorderStyle topBorderStyle() const
    { return static_cast!(QTextFrameFormat.BorderStyle)(intProperty(Property.TableCellTopBorderStyle)); }

    pragma(inline, true) void setBottomBorderStyle(QTextFrameFormat.BorderStyle style)
    { setProperty(Property.TableCellBottomBorderStyle, style); }
    pragma(inline, true) QTextFrameFormat.BorderStyle bottomBorderStyle() const
    { return static_cast!(QTextFrameFormat.BorderStyle)(intProperty(Property.TableCellBottomBorderStyle)); }

    pragma(inline, true) void setLeftBorderStyle(QTextFrameFormat.BorderStyle style)
    { setProperty(Property.TableCellLeftBorderStyle, style); }
    pragma(inline, true) QTextFrameFormat.BorderStyle leftBorderStyle() const
    { return static_cast!(QTextFrameFormat.BorderStyle)(intProperty(Property.TableCellLeftBorderStyle)); }

    pragma(inline, true) void setRightBorderStyle(QTextFrameFormat.BorderStyle style)
    { setProperty(Property.TableCellRightBorderStyle, style); }
    pragma(inline, true) QTextFrameFormat.BorderStyle rightBorderStyle() const
    { return static_cast!(QTextFrameFormat.BorderStyle)(intProperty(Property.TableCellRightBorderStyle)); }

    pragma(inline, true) void setBorderStyle(QTextFrameFormat.BorderStyle style)
    {
        setTopBorderStyle(style);
        setBottomBorderStyle(style);
        setLeftBorderStyle(style);
        setRightBorderStyle(style);
    }

    pragma(inline, true) void setTopBorderBrush(ref const(QBrush) brush)
    { setProperty(Property.TableCellTopBorderBrush, brush); }
    pragma(inline, true) QBrush topBorderBrush() const
    { return brushProperty(Property.TableCellTopBorderBrush); }

    pragma(inline, true) void setBottomBorderBrush(ref const(QBrush) brush)
    { setProperty(Property.TableCellBottomBorderBrush, brush); }
    pragma(inline, true) QBrush bottomBorderBrush() const
    { return brushProperty(Property.TableCellBottomBorderBrush); }

    pragma(inline, true) void setLeftBorderBrush(ref const(QBrush) brush)
    { setProperty(Property.TableCellLeftBorderBrush, brush); }
    pragma(inline, true) QBrush leftBorderBrush() const
    { return brushProperty(Property.TableCellLeftBorderBrush); }

    pragma(inline, true) void setRightBorderBrush(ref const(QBrush) brush)
    { setProperty(Property.TableCellRightBorderBrush, brush); }
    pragma(inline, true) QBrush rightBorderBrush() const
    { return brushProperty(Property.TableCellRightBorderBrush); }

    pragma(inline, true) void setBorderBrush(ref const(QBrush) brush)
    {
        setTopBorderBrush(brush);
        setBottomBorderBrush(brush);
        setLeftBorderBrush(brush);
        setRightBorderBrush(brush);
    }

protected:
    /+ explicit +/this(ref const(QTextFormat) fmt);
    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QTextTableCellFormat &); +/
    /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QTextTableCellFormat &); +/
    /+ friend class QTextFormat; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QTextTableCellFormat) +/

