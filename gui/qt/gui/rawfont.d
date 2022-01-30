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
module qt.gui.rawfont;
extern(C++):

import qt.config;
import qt.helpers;
version(QT_NO_RAWFONT){}else
{
    import qt.core.bytearray;
    import qt.core.flags;
    import qt.core.global;
    import qt.core.list;
    import qt.core.point;
    import qt.core.qchar;
    import qt.core.rect;
    import qt.core.shareddata;
    import qt.core.string;
    import qt.core.typeinfo;
    import qt.core.vector;
    import qt.gui.font;
    import qt.gui.fontdatabase;
    import qt.gui.image;
    import qt.gui.painterpath;
    import qt.gui.transform;
}

version(QT_NO_RAWFONT){}else
{



extern(C++, class) struct QRawFontPrivate;
/// Binding for C++ class [QRawFont](https://doc.qt.io/qt-5/qrawfont.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QRawFont
{
public:
    enum AntialiasingType {
        PixelAntialiasing,
        SubPixelAntialiasing
    }

    enum LayoutFlag {
        SeparateAdvances = 0,
        KernedAdvances = 1,
        UseDesignMetrics = 2
    }
    /+ Q_DECLARE_FLAGS(LayoutFlags, LayoutFlag) +/
alias LayoutFlags = QFlags!(LayoutFlag);
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(ref const(QString) fileName,
                 qreal pixelSize,
                 QFont.HintingPreference hintingPreference = QFont.HintingPreference.PreferDefaultHinting);
    this(ref const(QByteArray) fontData,
                 qreal pixelSize,
                 QFont.HintingPreference hintingPreference = QFont.HintingPreference.PreferDefaultHinting);
    @disable this(this);
    this(ref const(QRawFont) other);
    /+ QRawFont &operator=(QRawFont &&other) noexcept { swap(other); return *this; } +/
    /+ref QRawFont operator =(ref const(QRawFont) other);+/
    ~this();

    /+ void swap(QRawFont &other) noexcept { qSwap(d, other.d); } +/

    bool isValid() const;

    /+bool operator ==(ref const(QRawFont) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QRawFont) other) const
    { return !operator==(other); }+/

    QString familyName() const;
    QString styleName() const;

    QFont.Style style() const;
    int weight() const;

    QVector!(quint32) glyphIndexesForString(ref const(QString) text) const;
    pragma(inline, true) QVector!(QPointF) advancesForGlyphIndexes(ref const(QVector!(quint32)) glyphIndexes) const
    {
        return advancesForGlyphIndexes(glyphIndexes, QRawFont.LayoutFlags.SeparateAdvances);
    }
    pragma(inline, true) QVector!(QPointF) advancesForGlyphIndexes(ref const(QVector!(quint32)) glyphIndexes, LayoutFlags layoutFlags) const
    {
        QVector!QPointF advances = QVector!QPointF(glyphIndexes.size());
        if (advancesForGlyphIndexes(cast(const(quint32)*)(glyphIndexes.constData()), advances.data(), glyphIndexes.size(), layoutFlags))
            return advances;
        return QVector!(QPointF).create();
    }
    bool glyphIndexesForChars(const(QChar)* chars, int numChars, quint32* glyphIndexes, int* numGlyphs) const;
    bool advancesForGlyphIndexes(const(quint32)* glyphIndexes, QPointF* advances, int numGlyphs) const;
    bool advancesForGlyphIndexes(const(quint32)* glyphIndexes, QPointF* advances, int numGlyphs, LayoutFlags layoutFlags) const;

    QImage alphaMapForGlyph(quint32 glyphIndex,
                                AntialiasingType antialiasingType = AntialiasingType.SubPixelAntialiasing,
                                ref const(QTransform) transform = globalInitVar!QTransform) const;
    QPainterPath pathForGlyph(quint32 glyphIndex) const;
    QRectF boundingRect(quint32 glyphIndex) const;

    void setPixelSize(qreal pixelSize);
    qreal pixelSize() const;

    QFont.HintingPreference hintingPreference() const;

    qreal ascent() const;
    qreal capHeight() const;
    qreal descent() const;
    qreal leading() const;
    qreal xHeight() const;
    qreal averageCharWidth() const;
    qreal maxCharWidth() const;
    qreal lineThickness() const;
    qreal underlinePosition() const;

    qreal unitsPerEm() const;

    void loadFromFile(ref const(QString) fileName,
                          qreal pixelSize,
                          QFont.HintingPreference hintingPreference);

    void loadFromData(ref const(QByteArray) fontData,
                          qreal pixelSize,
                          QFont.HintingPreference hintingPreference);

    bool supportsCharacter(uint ucs4) const;
    bool supportsCharacter(QChar character) const;
    QList!(QFontDatabase.WritingSystem) supportedWritingSystems() const;

    QByteArray fontTable(const(char)* tagName) const;

    static QRawFont fromFont(ref const(QFont) font,
                                 QFontDatabase.WritingSystem writingSystem = QFontDatabase.WritingSystem.Any);

private:
    /+ friend class QRawFontPrivate; +/
    /+ friend class QTextLayout; +/
    /+ friend class QTextEngine; +/

    QExplicitlySharedDataPointer!(QRawFontPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QRawFont.LayoutFlags.enum_type) operator |(QRawFont.LayoutFlags.enum_type f1, QRawFont.LayoutFlags.enum_type f2)/+noexcept+/{return QFlags!(QRawFont.LayoutFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QRawFont.LayoutFlags.enum_type) operator |(QRawFont.LayoutFlags.enum_type f1, QFlags!(QRawFont.LayoutFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QRawFont.LayoutFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_SHARED(QRawFont)

Q_DECLARE_OPERATORS_FOR_FLAGS(QRawFont::LayoutFlags)
Q_GUI_EXPORT uint qHash(const QRawFont &font, uint seed = 0) noexcept; +/


}

