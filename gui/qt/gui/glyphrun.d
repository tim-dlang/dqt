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
module qt.gui.glyphrun;
extern(C++):

import qt.config;
import qt.helpers;
version(QT_NO_RAWFONT){}else
{
    import qt.core.flags;
    import qt.core.global;
    import qt.core.point;
    import qt.core.rect;
    import qt.core.shareddata;
    import qt.core.vector;
    import qt.gui.rawfont;
}

version(QT_NO_RAWFONT){}else
{



extern(C++, class) struct QGlyphRunPrivate;
/// Binding for C++ class [QGlyphRun](https://doc.qt.io/qt-5/qglyphrun.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QGlyphRun
{
public:
    enum GlyphRunFlag {
        Overline        = 0x01,
        Underline       = 0x02,
        StrikeOut       = 0x04,
        RightToLeft     = 0x08,
        SplitLigature   = 0x10
    }
    /+ Q_DECLARE_FLAGS(GlyphRunFlags, GlyphRunFlag) +/
alias GlyphRunFlags = QFlags!(GlyphRunFlag);
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QGlyphRun) other);
    /+ QGlyphRun &operator=(QGlyphRun &&other) noexcept { swap(other); return *this; } +/
    /+ref QGlyphRun operator =(ref const(QGlyphRun) other);+/
    ~this();

    /+ void swap(QGlyphRun &other) noexcept { qSwap(d, other.d); } +/

    QRawFont rawFont() const;
    void setRawFont(ref const(QRawFont) rawFont);

    void setRawData(const(quint32)* glyphIndexArray,
                        const(QPointF)* glyphPositionArray,
                        int size);

    QVector!(quint32) glyphIndexes() const;
    void setGlyphIndexes(ref const(QVector!(quint32)) glyphIndexes);

    QVector!(QPointF) positions() const;
    void setPositions(ref const(QVector!(QPointF)) positions);

    void clear();

    /+bool operator ==(ref const(QGlyphRun) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QGlyphRun) other) const
    { return !operator==(other); }+/

    void setOverline(bool overline);
    bool overline() const;

    void setUnderline(bool underline);
    bool underline() const;

    void setStrikeOut(bool strikeOut);
    bool strikeOut() const;

    void setRightToLeft(bool on);
    bool isRightToLeft() const;

    /+ void setFlag(GlyphRunFlag flag, bool enabled = true); +/
    void setFlags(GlyphRunFlags flags);
    GlyphRunFlags flags() const;

    void setBoundingRect(ref const(QRectF) boundingRect);
    QRectF boundingRect() const;

    bool isEmpty() const;

private:
    /+ friend class QGlyphRunPrivate; +/
    /+ friend class QTextLine; +/

    /+QGlyphRun operator +(ref const(QGlyphRun) other) const;+/
    /+ref QGlyphRun operator +=(ref const(QGlyphRun) other);+/

    void detach();
    QExplicitlySharedDataPointer!(QGlyphRunPrivate) d;
}

/+ Q_DECLARE_SHARED(QGlyphRun) +/


}
version(QT_NO_RAWFONT)
{
extern(C++, class) struct QGlyphRun;
}


