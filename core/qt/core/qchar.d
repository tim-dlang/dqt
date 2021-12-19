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
module qt.core.qchar;
extern(C++):

import core.stdc.stddef;
import qt.config;
import qt.core.global;
import qt.core.metatype;
import qt.core.string;
import qt.core.typeinfo;
import qt.helpers;


struct QLatin1Char
{
public:
    /+ explicit +/pragma(inline, true) this(char c)/+ noexcept+/
    {
        this.ch = c;
    }
    pragma(inline, true) char toLatin1() const/+ noexcept+/ { return ch; }
    pragma(inline, true) ushort unicode() const/+ noexcept+/ { return ushort(uchar(ch)); }

private:
    char ch;
}

/+pragma(inline, true) bool operator ==(char lhs, QLatin1Char rhs)/+ noexcept+/ { return lhs == rhs.toLatin1(); }+/
/+pragma(inline, true) bool operator !=(char lhs, QLatin1Char rhs)/+ noexcept+/ { return lhs != rhs.toLatin1(); }+/
/+pragma(inline, true) bool operator <=(char lhs, QLatin1Char rhs)/+ noexcept+/ { return lhs <= rhs.toLatin1(); }+/
/+pragma(inline, true) bool operator >=(char lhs, QLatin1Char rhs)/+ noexcept+/ { return lhs >= rhs.toLatin1(); }+/
/+pragma(inline, true) bool operator < (char lhs, QLatin1Char rhs)/+ noexcept+/ { return lhs <  rhs.toLatin1(); }+/
/+pragma(inline, true) bool operator > (char lhs, QLatin1Char rhs)/+ noexcept+/ { return lhs >  rhs.toLatin1(); }+/

/+pragma(inline, true) bool operator ==(QLatin1Char lhs, char rhs)/+ noexcept+/ { return lhs.toLatin1() == rhs; }+/
/+pragma(inline, true) bool operator !=(QLatin1Char lhs, char rhs)/+ noexcept+/ { return lhs.toLatin1() != rhs; }+/
/+pragma(inline, true) bool operator <=(QLatin1Char lhs, char rhs)/+ noexcept+/ { return lhs.toLatin1() <= rhs; }+/
/+pragma(inline, true) bool operator >=(QLatin1Char lhs, char rhs)/+ noexcept+/ { return lhs.toLatin1() >= rhs; }+/
/+pragma(inline, true) bool operator < (QLatin1Char lhs, char rhs)/+ noexcept+/ { return lhs.toLatin1() <  rhs; }+/
/+pragma(inline, true) bool operator > (QLatin1Char lhs, char rhs)/+ noexcept+/ { return lhs.toLatin1() >  rhs; }+/

/// Binding for C++ class [QChar](https://doc.qt.io/qt-5/qchar.html).
@Q_MOVABLE_TYPE @(QMetaType.Type.QChar) extern(C++, class) struct /+ Q_CORE_EXPORT +/ QChar {
public:
    enum SpecialCharacter {
        Null = 0x0000,
        Tabulation = 0x0009,
        LineFeed = 0x000a,
        FormFeed = 0x000c,
        CarriageReturn = 0x000d,
        Space = 0x0020,
        Nbsp = 0x00a0,
        SoftHyphen = 0x00ad,
        ReplacementCharacter = 0xfffd,
        ObjectReplacementCharacter = 0xfffc,
        ByteOrderMark = 0xfeff,
        ByteOrderSwapped = 0xfffe,
        ParagraphSeparator = 0x2029,
        LineSeparator = 0x2028,
        LastValidCodePoint = 0x10ffff
    }

    /+this()/+ noexcept+/
    {
        this.ucs = 0;
    }+/
    this(ushort rc)/+ noexcept+/
    {
        this.ucs = rc;
    } // implicit
    this(uchar c, uchar r)/+ noexcept+/
    {
        this.ucs = cast(ushort)((r << 8) | c);
    }
    this(short rc)/+ noexcept+/
    {
        this.ucs = ushort(rc);
    } // implicit
    this(uint rc)/+ noexcept+/
    {
        this.ucs = cast(ushort)(rc & 0xffff);
    }
    this(int rc)/+ noexcept+/
    {
        this.ucs = cast(ushort)(rc & 0xffff);
    }
    this(SpecialCharacter s)/+ noexcept+/
    {
        this.ucs = cast(ushort)(s);
    } // implicit
    this(QLatin1Char ch)/+ noexcept+/
    {
        this.ucs = ch.unicode();
    } // implicit
/+ #if defined(Q_COMPILER_UNICODE_STRINGS) +/
    this(wchar ch)/+ noexcept+/
    {
        this.ucs = ushort(ch);
    } // implicit
/+ #endif
#if defined(Q_OS_WIN) +/
    static if((versionIsSet!("Windows") && !versionIsSet!("Cygwin")))
    {
        mixin(Q_STATIC_ASSERT(q{wchar_t.sizeof == ushort.sizeof}));
    }
/+ #endif
#if defined(Q_OS_WIN) || defined(Q_CLANG_QDOC)
#   if !defined(_WCHAR_T_DEFINED) || defined(_NATIVE_WCHAR_T_DEFINED)
    QChar(wchar_t ch) noexcept : ucs(ushort(ch)) {} // implicit
#   endif
#endif

#ifndef QT_NO_CAST_FROM_ASCII
    QT_ASCII_CAST_WARN explicit QChar(char c) noexcept : ucs(uchar(c)) { }
#ifndef QT_RESTRICTED_CAST_FROM_ASCII
    QT_ASCII_CAST_WARN explicit QChar(uchar c) noexcept : ucs(c) { }
#endif
#endif +/
    this(char c)
    {
        this.ucs = c;
    }
    // Unicode information

    enum Category
    {
        Mark_NonSpacing,          //   Mn
        Mark_SpacingCombining,    //   Mc
        Mark_Enclosing,           //   Me

        Number_DecimalDigit,      //   Nd
        Number_Letter,            //   Nl
        Number_Other,             //   No

        Separator_Space,          //   Zs
        Separator_Line,           //   Zl
        Separator_Paragraph,      //   Zp

        Other_Control,            //   Cc
        Other_Format,             //   Cf
        Other_Surrogate,          //   Cs
        Other_PrivateUse,         //   Co
        Other_NotAssigned,        //   Cn

        Letter_Uppercase,         //   Lu
        Letter_Lowercase,         //   Ll
        Letter_Titlecase,         //   Lt
        Letter_Modifier,          //   Lm
        Letter_Other,             //   Lo

        Punctuation_Connector,    //   Pc
        Punctuation_Dash,         //   Pd
        Punctuation_Open,         //   Ps
        Punctuation_Close,        //   Pe
        Punctuation_InitialQuote, //   Pi
        Punctuation_FinalQuote,   //   Pf
        Punctuation_Other,        //   Po

        Symbol_Math,              //   Sm
        Symbol_Currency,          //   Sc
        Symbol_Modifier,          //   Sk
        Symbol_Other              //   So
    }

    enum Script
    {
        Script_Unknown,
        Script_Inherited,
        Script_Common,

        Script_Latin,
        Script_Greek,
        Script_Cyrillic,
        Script_Armenian,
        Script_Hebrew,
        Script_Arabic,
        Script_Syriac,
        Script_Thaana,
        Script_Devanagari,
        Script_Bengali,
        Script_Gurmukhi,
        Script_Gujarati,
        Script_Oriya,
        Script_Tamil,
        Script_Telugu,
        Script_Kannada,
        Script_Malayalam,
        Script_Sinhala,
        Script_Thai,
        Script_Lao,
        Script_Tibetan,
        Script_Myanmar,
        Script_Georgian,
        Script_Hangul,
        Script_Ethiopic,
        Script_Cherokee,
        Script_CanadianAboriginal,
        Script_Ogham,
        Script_Runic,
        Script_Khmer,
        Script_Mongolian,
        Script_Hiragana,
        Script_Katakana,
        Script_Bopomofo,
        Script_Han,
        Script_Yi,
        Script_OldItalic,
        Script_Gothic,
        Script_Deseret,
        Script_Tagalog,
        Script_Hanunoo,
        Script_Buhid,
        Script_Tagbanwa,
        Script_Coptic,

        // Unicode 4.0 additions
        Script_Limbu,
        Script_TaiLe,
        Script_LinearB,
        Script_Ugaritic,
        Script_Shavian,
        Script_Osmanya,
        Script_Cypriot,
        Script_Braille,

        // Unicode 4.1 additions
        Script_Buginese,
        Script_NewTaiLue,
        Script_Glagolitic,
        Script_Tifinagh,
        Script_SylotiNagri,
        Script_OldPersian,
        Script_Kharoshthi,

        // Unicode 5.0 additions
        Script_Balinese,
        Script_Cuneiform,
        Script_Phoenician,
        Script_PhagsPa,
        Script_Nko,

        // Unicode 5.1 additions
        Script_Sundanese,
        Script_Lepcha,
        Script_OlChiki,
        Script_Vai,
        Script_Saurashtra,
        Script_KayahLi,
        Script_Rejang,
        Script_Lycian,
        Script_Carian,
        Script_Lydian,
        Script_Cham,

        // Unicode 5.2 additions
        Script_TaiTham,
        Script_TaiViet,
        Script_Avestan,
        Script_EgyptianHieroglyphs,
        Script_Samaritan,
        Script_Lisu,
        Script_Bamum,
        Script_Javanese,
        Script_MeeteiMayek,
        Script_ImperialAramaic,
        Script_OldSouthArabian,
        Script_InscriptionalParthian,
        Script_InscriptionalPahlavi,
        Script_OldTurkic,
        Script_Kaithi,

        // Unicode 6.0 additions
        Script_Batak,
        Script_Brahmi,
        Script_Mandaic,

        // Unicode 6.1 additions
        Script_Chakma,
        Script_MeroiticCursive,
        Script_MeroiticHieroglyphs,
        Script_Miao,
        Script_Sharada,
        Script_SoraSompeng,
        Script_Takri,

        // Unicode 7.0 additions
        Script_CaucasianAlbanian,
        Script_BassaVah,
        Script_Duployan,
        Script_Elbasan,
        Script_Grantha,
        Script_PahawhHmong,
        Script_Khojki,
        Script_LinearA,
        Script_Mahajani,
        Script_Manichaean,
        Script_MendeKikakui,
        Script_Modi,
        Script_Mro,
        Script_OldNorthArabian,
        Script_Nabataean,
        Script_Palmyrene,
        Script_PauCinHau,
        Script_OldPermic,
        Script_PsalterPahlavi,
        Script_Siddham,
        Script_Khudawadi,
        Script_Tirhuta,
        Script_WarangCiti,

        // Unicode 8.0 additions
        Script_Ahom,
        Script_AnatolianHieroglyphs,
        Script_Hatran,
        Script_Multani,
        Script_OldHungarian,
        Script_SignWriting,

        // Unicode 9.0 additions
        Script_Adlam,
        Script_Bhaiksuki,
        Script_Marchen,
        Script_Newa,
        Script_Osage,
        Script_Tangut,

        // Unicode 10.0 additions
        Script_MasaramGondi,
        Script_Nushu,
        Script_Soyombo,
        Script_ZanabazarSquare,

        // Unicode 12.1 additions
        Script_Dogra,
        Script_GunjalaGondi,
        Script_HanifiRohingya,
        Script_Makasar,
        Script_Medefaidrin,
        Script_OldSogdian,
        Script_Sogdian,
        Script_Elymaic,
        Script_Nandinagari,
        Script_NyiakengPuachueHmong,
        Script_Wancho,

        // Unicode 13.0 additions
        Script_Chorasmian,
        Script_DivesAkuru,
        Script_KhitanSmallScript,
        Script_Yezidi,

        ScriptCount
    }

    enum Direction
    {
        DirL, DirR, DirEN, DirES, DirET, DirAN, DirCS, DirB, DirS, DirWS, DirON,
        DirLRE, DirLRO, DirAL, DirRLE, DirRLO, DirPDF, DirNSM, DirBN,
        DirLRI, DirRLI, DirFSI, DirPDI
    }

    enum Decomposition
    {
        NoDecomposition,
        Canonical,
        Font,
        NoBreak,
        Initial,
        Medial,
        Final,
        Isolated,
        Circle,
        Super,
        Sub,
        Vertical,
        Wide,
        Narrow,
        Small,
        Square,
        Compat,
        Fraction
    }

    enum JoiningType {
        Joining_None,
        Joining_Causing,
        Joining_Dual,
        Joining_Right,
        Joining_Left,
        Joining_Transparent
    }

/+ #if QT_DEPRECATED_SINCE(5, 3) +/
    enum Joining
    {
        OtherJoining, Dual, Right, Center
    }
/+ #endif +/

    enum CombiningClass
    {
        Combining_BelowLeftAttached       = 200,
        Combining_BelowAttached           = 202,
        Combining_BelowRightAttached      = 204,
        Combining_LeftAttached            = 208,
        Combining_RightAttached           = 210,
        Combining_AboveLeftAttached       = 212,
        Combining_AboveAttached           = 214,
        Combining_AboveRightAttached      = 216,

        Combining_BelowLeft               = 218,
        Combining_Below                   = 220,
        Combining_BelowRight              = 222,
        Combining_Left                    = 224,
        Combining_Right                   = 226,
        Combining_AboveLeft               = 228,
        Combining_Above                   = 230,
        Combining_AboveRight              = 232,

        Combining_DoubleBelow             = 233,
        Combining_DoubleAbove             = 234,
        Combining_IotaSubscript           = 240
    }

    enum UnicodeVersion {
        Unicode_Unassigned,
        Unicode_1_1,
        Unicode_2_0,
        Unicode_2_1_2,
        Unicode_3_0,
        Unicode_3_1,
        Unicode_3_2,
        Unicode_4_0,
        Unicode_4_1,
        Unicode_5_0,
        Unicode_5_1,
        Unicode_5_2,
        Unicode_6_0,
        Unicode_6_1,
        Unicode_6_2,
        Unicode_6_3,
        Unicode_7_0,
        Unicode_8_0,
        Unicode_9_0,
        Unicode_10_0,
        Unicode_11_0,
        Unicode_12_0,
        Unicode_12_1,
        Unicode_13_0
    }
    // ****** WHEN ADDING FUNCTIONS, CONSIDER ADDING TO QCharRef TOO

/+    pragma(inline, true) Category category() const/+ noexcept+/ { return QChar.category(ucs); }
    pragma(inline, true) Direction direction() const/+ noexcept+/ { return QChar.direction(ucs); }
    pragma(inline, true) JoiningType joiningType() const/+ noexcept+/ { return QChar.joiningType(ucs); }
/+ #if QT_DEPRECATED_SINCE(5, 3) +/
    /+ QT_DEPRECATED +/ pragma(inline, true) Joining joining() const/+ noexcept+/
    {
        switch (QChar.joiningType(ucs)) {
        case QChar.JoiningType.Joining_Causing: return QChar.Joining.Center;
        case QChar.JoiningType.Joining_Dual: return QChar.Joining.Dual;
        case QChar.JoiningType.Joining_Right: return QChar.Joining.Right;
        case QChar.JoiningType.Joining_None:
        case QChar.JoiningType.Joining_Left:
        case QChar.JoiningType.Joining_Transparent:
        default: return QChar.Joining.OtherJoining;
        }
    }
/+ #endif +/
    pragma(inline, true) ubyte  combiningClass() const/+ noexcept+/ { return QChar.combiningClass(ucs); }

    pragma(inline, true) QChar mirroredChar() const/+ noexcept+/ { return QChar(QChar.mirroredChar(ucs)); }
    pragma(inline, true) bool hasMirrored() const/+ noexcept+/ { return QChar.hasMirrored(ucs); }

    QString decomposition() const;
    pragma(inline, true) Decomposition decompositionTag() const/+ noexcept+/ { return QChar.decompositionTag(ucs); }

    pragma(inline, true) int digitValue() const/+ noexcept+/ { return QChar.digitValue(ucs); }
    pragma(inline, true) QChar toLower() const/+ noexcept+/ { return QChar(QChar.toLower(ucs)); }
    pragma(inline, true) QChar toUpper() const/+ noexcept+/ { return QChar(QChar.toUpper(ucs)); }
    pragma(inline, true) QChar toTitleCase() const/+ noexcept+/ { return QChar(QChar.toTitleCase(ucs)); }
    pragma(inline, true) QChar toCaseFolded() const/+ noexcept+/ { return QChar(QChar.toCaseFolded(ucs)); }

    pragma(inline, true) Script script() const/+ noexcept+/ { return QChar.script(ucs); }

    pragma(inline, true) UnicodeVersion unicodeVersion() const/+ noexcept+/ { return QChar.unicodeVersion(ucs); }+/

/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED inline char toAscii() const noexcept { return toLatin1(); }
#endif +/
    pragma(inline, true) char toLatin1() const/+ noexcept+/ { return ucs > 0xff ? '\0' : cast(char)(ucs); }
    pragma(inline, true) ushort unicode() const/+ noexcept+/ { return ucs; }
    pragma(inline, true) ref ushort unicode()/+ noexcept+/ return { return ucs; }

/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED static inline QChar fromAscii(char c) noexcept
    { return fromLatin1(c); }
#endif +/
    pragma(inline, true) static QChar fromLatin1(char c)/+ noexcept+/ { return QChar(ushort(uchar(c))); }

    pragma(inline, true) bool isNull() const/+ noexcept+/ { return ucs == 0; }

/+    pragma(inline, true) bool isPrint() const/+ noexcept+/ { return QChar.isPrint(ucs); }
    pragma(inline, true) bool isSpace() const/+ noexcept+/ { return QChar.isSpace(ucs); }
    pragma(inline, true) bool isMark() const/+ noexcept+/ { return QChar.isMark(ucs); }
    pragma(inline, true) bool isPunct() const/+ noexcept+/ { return QChar.isPunct(ucs); }
    pragma(inline, true) bool isSymbol() const/+ noexcept+/ { return QChar.isSymbol(ucs); }
    pragma(inline, true) bool isLetter() const/+ noexcept+/ { return QChar.isLetter(ucs); }
    pragma(inline, true) bool isNumber() const/+ noexcept+/ { return QChar.isNumber(ucs); }
    pragma(inline, true) bool isLetterOrNumber() const/+ noexcept+/ { return QChar.isLetterOrNumber(ucs); }
    pragma(inline, true) bool isDigit() const/+ noexcept+/ { return QChar.isDigit(ucs); }
    pragma(inline, true) bool isLower() const/+ noexcept+/ { return QChar.isLower(ucs); }
    pragma(inline, true) bool isUpper() const/+ noexcept+/ { return QChar.isUpper(ucs); }
    pragma(inline, true) bool isTitleCase() const/+ noexcept+/ { return QChar.isTitleCase(ucs); }

    pragma(inline, true) bool isNonCharacter() const/+ noexcept+/ { return QChar.isNonCharacter(ucs); }
    pragma(inline, true) bool isHighSurrogate() const/+ noexcept+/ { return QChar.isHighSurrogate(ucs); }
    pragma(inline, true) bool isLowSurrogate() const/+ noexcept+/ { return QChar.isLowSurrogate(ucs); }
    pragma(inline, true) bool isSurrogate() const/+ noexcept+/ { return QChar.isSurrogate(ucs); }

    pragma(inline, true) uchar cell() const/+ noexcept+/ { return cast(uchar)(ucs & 0xff); }
    pragma(inline, true) uchar row() const/+ noexcept+/ { return cast(uchar)((ucs>>8)&0xff); }
    pragma(inline, true) void setCell(uchar acell)/+ noexcept+/ { ucs = cast(ushort)((ucs & 0xff00) + acell); }
    pragma(inline, true) void setRow(uchar arow)/+ noexcept+/ { ucs = cast(ushort)((ushort(arow)<<8) + (ucs&0xff)); }+/

    pragma(inline, true) static bool isNonCharacter(uint ucs4)/+ noexcept+/
    {
        return ucs4 >= 0xfdd0 && (ucs4 <= 0xfdef || (ucs4 & 0xfffe) == 0xfffe);
    }
    pragma(inline, true) static bool isHighSurrogate(uint ucs4)/+ noexcept+/
    {
        return ((ucs4 & 0xfffffc00) == 0xd800);
    }
    pragma(inline, true) static bool isLowSurrogate(uint ucs4)/+ noexcept+/
    {
        return ((ucs4 & 0xfffffc00) == 0xdc00);
    }
    pragma(inline, true) static bool isSurrogate(uint ucs4)/+ noexcept+/
    {
        return (ucs4 - 0xd800u < 2048u);
    }
    pragma(inline, true) static bool requiresSurrogates(uint ucs4)/+ noexcept+/
    {
        return (ucs4 >= 0x10000);
    }
    pragma(inline, true) static uint surrogateToUcs4(ushort high, ushort low)/+ noexcept+/
    {
        return (uint(high)<<10) + low - 0x35fdc00;
    }
    pragma(inline, true) static uint surrogateToUcs4(QChar high, QChar low)/+ noexcept+/
    {
        return surrogateToUcs4(high.ucs, low.ucs);
    }
    pragma(inline, true) static ushort highSurrogate(uint ucs4)/+ noexcept+/
    {
        return cast(ushort)((ucs4>>10) + 0xd7c0);
    }
    pragma(inline, true) static ushort lowSurrogate(uint ucs4)/+ noexcept+/
    {
        return cast(ushort)(ucs4%0x400 + 0xdc00);
    }

/+    static Category /+ QT_FASTCALL +/ category(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    static Direction /+ QT_FASTCALL +/ direction(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    static JoiningType /+ QT_FASTCALL +/ joiningType(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
/+ #if QT_DEPRECATED_SINCE(5, 3) +/
    /+ QT_DEPRECATED +/ static Joining /+ QT_FASTCALL +/ joining(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
/+ #endif +/
    static ubyte  /+ QT_FASTCALL +/ combiningClass(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;

    static uint /+ QT_FASTCALL +/ mirroredChar(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    static bool /+ QT_FASTCALL +/ hasMirrored(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;

    static QString /+ QT_FASTCALL +/ decomposition(uint ucs4);
    static Decomposition /+ QT_FASTCALL +/ decompositionTag(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;

    static int /+ QT_FASTCALL +/ digitValue(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    static uint /+ QT_FASTCALL +/ toLower(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    static uint /+ QT_FASTCALL +/ toUpper(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    static uint /+ QT_FASTCALL +/ toTitleCase(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    static uint /+ QT_FASTCALL +/ toCaseFolded(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;

    static Script /+ QT_FASTCALL +/ script(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;

    static UnicodeVersion /+ QT_FASTCALL +/ unicodeVersion(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;

    static UnicodeVersion /+ QT_FASTCALL +/ currentUnicodeVersion()/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;

    static bool /+ QT_FASTCALL +/ isPrint(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    pragma(inline, true) static bool isSpace(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/
    __attribute__((const))+/    {
        // note that [0x09..0x0d] + 0x85 are exceptional Cc-s and must be handled explicitly
        return ucs4 == 0x20 || (ucs4 <= 0x0d && ucs4 >= 0x09)
                || (ucs4 > 127 && (ucs4 == 0x85 || ucs4 == 0xa0 || QChar.isSpace_helper(ucs4)));
    }
    static bool /+ QT_FASTCALL +/ isMark(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    static bool /+ QT_FASTCALL +/ isPunct(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    static bool /+ QT_FASTCALL +/ isSymbol(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    pragma(inline, true) static bool isLetter(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/
    __attribute__((const))+/    {
        return (ucs4 >= 'A' && ucs4 <= 'z' && (ucs4 >= 'a' || ucs4 <= 'Z'))
                || (ucs4 > 127 && QChar.isLetter_helper(ucs4));
    }
    pragma(inline, true) static bool isNumber(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/
    __attribute__((const))+/    { return (ucs4 <= '9' && ucs4 >= '0') || (ucs4 > 127 && QChar.isNumber_helper(ucs4)); }
    pragma(inline, true) static bool isLetterOrNumber(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/
    __attribute__((const))+/    {
        return (ucs4 >= 'A' && ucs4 <= 'z' && (ucs4 >= 'a' || ucs4 <= 'Z'))
                || (ucs4 >= '0' && ucs4 <= '9')
                || (ucs4 > 127 && QChar.isLetterOrNumber_helper(ucs4));
    }
    pragma(inline, true) static bool isDigit(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/
    __attribute__((const))+/    { return (ucs4 <= '9' && ucs4 >= '0') || (ucs4 > 127 && QChar.category(ucs4) == Category.Number_DecimalDigit); }
    pragma(inline, true) static bool isLower(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/
    __attribute__((const))+/    { return (ucs4 <= 'z' && ucs4 >= 'a') || (ucs4 > 127 && QChar.category(ucs4) == Category.Letter_Lowercase); }
    pragma(inline, true) static bool isUpper(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/
    __attribute__((const))+/    { return (ucs4 <= 'Z' && ucs4 >= 'A') || (ucs4 > 127 && QChar.category(ucs4) == Category.Letter_Uppercase); }
    pragma(inline, true) static bool isTitleCase(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/
    __attribute__((const))+/    { return ucs4 > 127 && QChar.category(ucs4) == Category.Letter_Titlecase; }
+/
private:
/*    static bool /+ QT_FASTCALL +/ isSpace_helper(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    static bool /+ QT_FASTCALL +/ isLetter_helper(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    static bool /+ QT_FASTCALL +/ isNumber_helper(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
    static bool /+ QT_FASTCALL +/ isLetterOrNumber_helper(uint ucs4)/+ noexcept /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;
*/
/+ #ifdef QT_NO_CAST_FROM_ASCII +/
    //this(char c)/+ noexcept+/;
    //this(uchar c)/+ noexcept+/;
/+ #endif +/

    /+ friend bool operator==(QChar, QChar) noexcept; +/
    /+ friend bool operator< (QChar, QChar) noexcept; +/
    ushort ucs = 0;
}

/+ Q_DECLARE_TYPEINFO(QChar, Q_MOVABLE_TYPE); +/

/+pragma(inline, true) bool operator ==(QChar c1, QChar c2)/+ noexcept+/ { return c1.ucs == c2.ucs; }+/
/+pragma(inline, true) bool operator < (QChar c1, QChar c2)/+ noexcept+/ { return c1.ucs <  c2.ucs; }+/

/+pragma(inline, true) bool operator !=(QChar c1, QChar c2)/+ noexcept+/ { return !operator==(c1, c2); }+/
/+pragma(inline, true) bool operator >=(QChar c1, QChar c2)/+ noexcept+/ { return !operator< (c1, c2); }+/
/+pragma(inline, true) bool operator > (QChar c1, QChar c2)/+ noexcept+/ { return  operator< (c2, c1); }+/
/+pragma(inline, true) bool operator <=(QChar c1, QChar c2)/+ noexcept+/ { return !operator< (c2, c1); }+/


/+pragma(inline, true) bool operator ==(QChar lhs, /+ std:: +/nullptr_t)/+ noexcept+/ { return lhs.isNull(); }+/
/+pragma(inline, true) bool operator < (QChar,     /+ std:: +/nullptr_t)/+ noexcept+/ { return false; }+/
/+pragma(inline, true) bool operator ==(/+ std:: +/nullptr_t, QChar rhs)/+ noexcept+/ { return rhs.isNull(); }+/
/+pragma(inline, true) bool operator < (/+ std:: +/nullptr_t, QChar rhs)/+ noexcept+/ { return !rhs.isNull(); }+/

/+pragma(inline, true) bool operator !=(QChar lhs, /+ std:: +/nullptr_t)/+ noexcept+/ { return !operator==(lhs, null); }+/
/+pragma(inline, true) bool operator >=(QChar lhs, /+ std:: +/nullptr_t)/+ noexcept+/ { return !operator< (lhs, null); }+/
/+pragma(inline, true) bool operator > (QChar lhs, /+ std:: +/nullptr_t)/+ noexcept+/ { return  operator< (null, lhs); }+/
/+pragma(inline, true) bool operator <=(QChar lhs, /+ std:: +/nullptr_t)/+ noexcept+/ { return !operator< (null, lhs); }+/

/+pragma(inline, true) bool operator !=(/+ std:: +/nullptr_t, QChar rhs)/+ noexcept+/ { return !operator==(null, rhs); }+/
/+pragma(inline, true) bool operator >=(/+ std:: +/nullptr_t, QChar rhs)/+ noexcept+/ { return !operator< (null, rhs); }+/
/+pragma(inline, true) bool operator > (/+ std:: +/nullptr_t, QChar rhs)/+ noexcept+/ { return  operator< (rhs, null); }+/
/+pragma(inline, true) bool operator <=(/+ std:: +/nullptr_t, QChar rhs)/+ noexcept+/ { return !operator< (rhs, null); }+/

/+ #ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, QChar);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QChar &);
#endif +/

