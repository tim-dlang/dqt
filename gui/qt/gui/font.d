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
module qt.gui.font;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.metamacros;
import qt.core.shareddata;
import qt.core.string;
import qt.core.stringlist;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.paintdevice;
import qt.helpers;

extern(C++, class) struct QFontPrivate;                                     /* don't touch */

/// Binding for C++ class [QFont](https://doc.qt.io/qt-6/qfont.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QFont
{
    mixin(Q_GADGET);
public:
    enum StyleHint {
        Helvetica,  SansSerif = StyleHint.Helvetica,
        Times,      Serif = StyleHint.Times,
        Courier,    TypeWriter = StyleHint.Courier,
        OldEnglish, Decorative = StyleHint.OldEnglish,
        System,
        AnyStyle,
        Cursive,
        Monospace,
        Fantasy
    }
    /+ Q_ENUM(StyleHint) +/

    enum StyleStrategy {
        PreferDefault       = 0x0001,
        PreferBitmap        = 0x0002,
        PreferDevice        = 0x0004,
        PreferOutline       = 0x0008,
        ForceOutline        = 0x0010,
        PreferMatch         = 0x0020,
        PreferQuality       = 0x0040,
        PreferAntialias     = 0x0080,
        NoAntialias         = 0x0100,
        NoSubpixelAntialias = 0x0800,
        PreferNoShaping     = 0x1000,
        NoFontMerging       = 0x8000
    }
    /+ Q_ENUM(StyleStrategy) +/

    enum HintingPreference {
        PreferDefaultHinting        = 0,
        PreferNoHinting             = 1,
        PreferVerticalHinting       = 2,
        PreferFullHinting           = 3
    }
    /+ Q_ENUM(HintingPreference) +/

    enum Weight {
        Thin = 100,
        ExtraLight = 200,
        Light = 300,
        Normal = 400,
        Medium = 500,
        DemiBold = 600,
        Bold = 700,
        ExtraBold = 800,
        Black = 900
    }
    /+ Q_ENUM(Weight) +/

    enum Style {
        StyleNormal,
        StyleItalic,
        StyleOblique
    }
    /+ Q_ENUM(Style) +/

    enum Stretch {
        AnyStretch     =   0,
        UltraCondensed =  50,
        ExtraCondensed =  62,
        Condensed      =  75,
        SemiCondensed  =  87,
        Unstretched    = 100,
        SemiExpanded   = 112,
        Expanded       = 125,
        ExtraExpanded  = 150,
        UltraExpanded  = 200
    }
    /+ Q_ENUM(Stretch) +/

    enum Capitalization {
        MixedCase,
        AllUppercase,
        AllLowercase,
        SmallCaps,
        Capitalize
    }
    /+ Q_ENUM(Capitalization) +/

    enum SpacingType {
        PercentageSpacing,
        AbsoluteSpacing
    }
    /+ Q_ENUM(SpacingType) +/

    enum ResolveProperties {
        NoPropertiesResolved        = 0x0000,
        FamilyResolved              = 0x0001,
        SizeResolved                = 0x0002,
        StyleHintResolved           = 0x0004,
        StyleStrategyResolved       = 0x0008,
        WeightResolved              = 0x0010,
        StyleResolved               = 0x0020,
        UnderlineResolved           = 0x0040,
        OverlineResolved            = 0x0080,
        StrikeOutResolved           = 0x0100,
        FixedPitchResolved          = 0x0200,
        StretchResolved             = 0x0400,
        KerningResolved             = 0x0800,
        CapitalizationResolved      = 0x1000,
        LetterSpacingResolved       = 0x2000,
        WordSpacingResolved         = 0x4000,
        HintingPreferenceResolved   = 0x8000,
        StyleNameResolved           = 0x10000,
        FamiliesResolved            = 0x20000,
        AllPropertiesResolved       = 0x3ffff
    }
    /+ Q_ENUM(ResolveProperties) +/

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }


    this(ref const(QString) family, int pointSize = -1, int weight = -1, bool italic = false);
    /+ explicit +/this(ref const(QStringList) families, int pointSize = -1, int weight = -1, bool italic = false);
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(ref const(QFont) font, const(QPaintDevice) pd);
    }));
    @disable this(this);
    this(ref const(QFont) font);
    ~this();

    /+ void swap(QFont &other)
    { qSwap(d, other.d); qSwap(resolve_mask, other.resolve_mask); } +/

    QString family() const;
    void setFamily(ref const(QString) );

    QStringList families() const;
    void setFamilies(ref const(QStringList) );

    QString styleName() const;
    void setStyleName(ref const(QString) );

    int pointSize() const;
    void setPointSize(int);
    qreal pointSizeF() const;
    void setPointSizeF(qreal);

    int pixelSize() const;
    void setPixelSize(int);

    Weight weight() const;
    void setWeight(Weight weight);

    pragma(inline, true) bool bold() const
    { return weight() > Weight.Medium; }
    pragma(inline, true) void setBold(bool enable)
    { setWeight(enable ? Weight.Bold : Weight.Normal); }

    void setStyle(Style style);
    Style style() const;

    pragma(inline, true) bool italic() const
    {
        return (style() != Style.StyleNormal);
    }
    pragma(inline, true) void setItalic(bool b) {
        setStyle(b ? Style.StyleItalic : Style.StyleNormal);
    }

    bool underline() const;
    void setUnderline(bool);

    bool overline() const;
    void setOverline(bool);

    bool strikeOut() const;
    void setStrikeOut(bool);

    bool fixedPitch() const;
    void setFixedPitch(bool);

    bool kerning() const;
    void setKerning(bool);

    StyleHint styleHint() const;
    StyleStrategy styleStrategy() const;
    void setStyleHint(StyleHint, StyleStrategy /+ = PreferDefault +/);
    void setStyleStrategy(StyleStrategy s);

    int stretch() const;
    void setStretch(int);

    qreal letterSpacing() const;
    SpacingType letterSpacingType() const;
    void setLetterSpacing(SpacingType type, qreal spacing);

    qreal wordSpacing() const;
    void setWordSpacing(qreal spacing);

    void setCapitalization(Capitalization);
    Capitalization capitalization() const;

    void setHintingPreference(HintingPreference hintingPreference);
    HintingPreference hintingPreference() const;

    // dupicated from QFontInfo
    bool exactMatch() const;

    /+ref QFont operator =(ref const(QFont) );+/
    /+bool operator ==(ref const(QFont) ) const;+/
    /+bool operator !=(ref const(QFont) ) const;+/
    /+bool operator <(ref const(QFont) ) const;+/
    /+auto opCast(T : QVariant)() const;+/
    bool isCopyOf(ref const(QFont) ) const;
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QFont) +/

    QString key() const;

    QString toString() const;
    bool fromString(ref const(QString) );

    static QString substitute(ref const(QString) );
    static QStringList substitutes(ref const(QString) );
    static QStringList substitutions();
    static void insertSubstitution(ref const(QString), ref const(QString) );
    static void insertSubstitutions(ref const(QString), ref const(QStringList) );
    static void removeSubstitutions(ref const(QString) );
    static void initialize();
    static void cleanup();
    static void cacheStatistics();

    QString defaultFamily() const;

    QFont resolve(ref const(QFont) ) const;
    pragma(inline, true) uint resolveMask() const { return resolve_mask; }
    pragma(inline, true) void setResolveMask(uint mask) { resolve_mask = mask; }

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use setWeight() instead") +/ void setLegacyWeight(int legacyWeight);
    /+ QT_DEPRECATED_VERSION_X_6_0("Use weight() instead") +/ int legacyWeight() const;
/+ #endif +/

private:
    /+ explicit +/this(QFontPrivate* );

    void detach();


    /+ friend class QFontPrivate; +/
    /+ friend class QFontDialogPrivate; +/
    /+ friend class QFontMetrics; +/
    /+ friend class QFontMetricsF; +/
    /+ friend class QFontInfo; +/
    /+ friend class QPainter; +/
    /+ friend class QPainterPrivate; +/
    /+ friend class QApplication; +/
    /+ friend class QWidget; +/
    /+ friend class QWidgetPrivate; +/
    /+ friend class QTextLayout; +/
    /+ friend class QTextEngine; +/
    /+ friend class QStackTextEngine; +/
    /+ friend class QTextLine; +/
    /+ friend struct QScriptLine; +/
    /+ friend class QOpenGLContext; +/
    /+ friend class QWin32PaintEngine; +/
    /+ friend class QAlphaPaintEngine; +/
    /+ friend class QPainterPath; +/
    /+ friend class QTextItemInt; +/
    /+ friend class QPicturePaintEngine; +/
    /+ friend class QPainterReplayer; +/
    /+ friend class QPaintBufferEngine; +/
    /+ friend class QCommandLinkButtonPrivate; +/
    /+ friend class QFontEngine; +/

/+ #ifndef QT_NO_DATASTREAM +/
    version(QT_NO_DATASTREAM){}else
    {
        /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QFont &); +/
        /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QFont &); +/
    }
/+ #endif

#ifndef QT_NO_DEBUG_STREAM
    friend Q_GUI_EXPORT QDebug operator<<(QDebug, const QFont &);
#endif +/

    QExplicitlySharedDataPointer!(QFontPrivate) d;
    uint resolve_mask;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QFont)

Q_GUI_EXPORT size_t qHash(const QFont &font, size_t seed = 0) noexcept;



/*****************************************************************************
  QFont stream functions
 *****************************************************************************/

#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QFont &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QFont &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QFont &);
#endif +/

