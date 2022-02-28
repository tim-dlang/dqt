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
module qt.gui.textlayout;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.string;
import qt.gui.font;
import qt.gui.paintdevice;
import qt.gui.painter;
import qt.gui.textformat;
import qt.gui.textobject;
import qt.gui.textoption;
import qt.helpers;
version(QT_NO_RAWFONT){}else
{
    import qt.gui.glyphrun;
    import qt.gui.rawfont;
}

extern(C++, class) struct QTextEngine;
/+ #ifndef QT_NO_RAWFONT
class QRawFont;
#endif +/

/// Binding for C++ class [QTextInlineObject](https://doc.qt.io/qt-6/qtextinlineobject.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextInlineObject
{
public:
    this(int i, QTextEngine* e)
    {
        this.itm = i;
        this.eng = e;
    }
    @disable this();
    /+pragma(inline, true) this()
    {
        this.itm = 0;
        this.eng = null;
    }+/
    pragma(inline, true) bool isValid() const { return cast(bool)(eng); }

    QRectF rect() const;
    qreal width() const;
    qreal ascent() const;
    qreal descent() const;
    qreal height() const;

    /+ Qt:: +/qt.core.namespace.LayoutDirection textDirection() const;

    void setWidth(qreal w);
    void setAscent(qreal a);
    void setDescent(qreal d);

    int textPosition() const;

    int formatIndex() const;
    QTextFormat format() const;

private:
    /+ friend class QTextLayout; +/
    int itm = 0;
    QTextEngine* eng = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QTextLayout](https://doc.qt.io/qt-6/qtextlayout.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextLayout
{
public:
    // does itemization
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(ref const(QString) text);
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    this(ref const(QString) text, ref const(QFont) font, const(QPaintDevice) paintdevice = null);
    }));
    this(ref const(QTextBlock) b);
    ~this();

    void setFont(ref const(QFont) f);
    QFont font() const;

    version(QT_NO_RAWFONT){}else
    {
        void setRawFont(ref const(QRawFont) rawFont);
    }

    void setText(ref const(QString) string);
    QString text() const;

    void setTextOption(ref const(QTextOption) option);
    ref const(QTextOption) textOption() const;

    void setPreeditArea(int position, ref const(QString) text);
    int preeditAreaPosition() const;
    QString preeditAreaText() const;

    // Workaround for https://issues.dlang.org/show_bug.cgi?id=20701
    extern(C++, struct) struct FormatRange {
        int start;
        int length;
        QTextCharFormat format;

        /+ friend bool operator==(const FormatRange &lhs, const FormatRange &rhs)
        { return lhs.start == rhs.start && lhs.length == rhs.length && lhs.format == rhs.format; } +/
        /+ friend bool operator!=(const FormatRange &lhs, const FormatRange &rhs)
        { return !operator==(lhs, rhs); } +/
    }
    void setFormats(ref const(QList!(FormatRange)) overrides);
    QList!(FormatRange) formats() const;
    void clearFormats();

    void setCacheEnabled(bool enable);
    bool cacheEnabled() const;

    void setCursorMoveStyle(/+ Qt:: +/qt.core.namespace.CursorMoveStyle style);
    /+ Qt:: +/qt.core.namespace.CursorMoveStyle cursorMoveStyle() const;

    void beginLayout();
    void endLayout();
    void clearLayout();

    QTextLine createLine();

    int lineCount() const;
    QTextLine lineAt(int i) const;
    QTextLine lineForTextPosition(int pos) const;

    enum CursorMode {
        SkipCharacters,
        SkipWords
    }
    bool isValidCursorPosition(int pos) const;
    int nextCursorPosition(int oldPos, CursorMode mode = CursorMode.SkipCharacters) const;
    int previousCursorPosition(int oldPos, CursorMode mode = CursorMode.SkipCharacters) const;
    int leftCursorPosition(int oldPos) const;
    int rightCursorPosition(int oldPos) const;

    void draw(QPainter* p, ref const(QPointF) pos,
                  ref const(QList!(FormatRange)) selections = globalInitVar!(QList!(FormatRange)),
                  ref const(QRectF) clip = globalInitVar!QRectF) const;
    void drawCursor(QPainter* p, ref const(QPointF) pos, int cursorPosition) const;
    void drawCursor(QPainter* p, ref const(QPointF) pos, int cursorPosition, int width) const;

    QPointF position() const;
    void setPosition(ref const(QPointF) p);

    QRectF boundingRect() const;

    qreal minimumWidth() const;
    qreal maximumWidth() const;

    version(QT_NO_RAWFONT){}else
    {
        QList!(QGlyphRun) glyphRuns(int from = -1, int length = -1) const;
    }

//    QTextEngine* engine() const { return d; }
    void setFlags(int flags);
private:
    this(QTextEngine* e)
    {
        this.d = e;
    }
    /+ Q_DISABLE_COPY(QTextLayout) +/
@disable this(this);
/+this(ref const(QTextLayout));+//+ref QTextLayout operator =(ref const(QTextLayout));+/
    /+ friend class QPainter; +/
    /+ friend class QGraphicsSimpleTextItemPrivate; +/
    /+ friend class QGraphicsSimpleTextItem; +/
    /+ friend void qt_format_text(const QFont &font, const QRectF &_r, int tf, const QTextOption *, const QString& str,
                               QRectF *brect, int tabstops, int* tabarray, int tabarraylen,
                               QPainter *painter); +/
    QTextEngine* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QTextLayout::FormatRange, Q_RELOCATABLE_TYPE); +/


/// Binding for C++ class [QTextLine](https://doc.qt.io/qt-6/qtextline.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextLine
{
public:
    @disable this();
    /+pragma(inline, true) this()
    {
        this.index = 0;
        this.eng = null;
    }+/
    pragma(inline, true) bool isValid() const { return cast(bool)(eng); }

    QRectF rect() const;
    qreal x() const;
    qreal y() const;
    qreal width() const;
    qreal ascent() const;
    qreal descent() const;
    qreal height() const;
    qreal leading() const;

    void setLeadingIncluded(bool included);
    bool leadingIncluded() const;

    qreal naturalTextWidth() const;
    qreal horizontalAdvance() const;
    QRectF naturalTextRect() const;

    enum Edge {
        Leading,
        Trailing
    }
    enum CursorPosition {
        CursorBetweenCharacters,
        CursorOnCharacter
    }

    /* cursorPos gets set to the valid position */
    qreal cursorToX(int* cursorPos, Edge edge = Edge.Leading) const;
    pragma(inline, true) qreal cursorToX(int cursorPos, Edge edge = Edge.Leading) const { return cursorToX(&cursorPos, edge); }
    int xToCursor(qreal x, CursorPosition /+ = CursorBetweenCharacters +/) const;

    void setLineWidth(qreal width);
    void setNumColumns(int columns);
    void setNumColumns(int columns, qreal alignmentWidth);

    void setPosition(ref const(QPointF) pos);
    QPointF position() const;

    int textStart() const;
    int textLength() const;

    int lineNumber() const { return index; }

    void draw(QPainter* painter, ref const(QPointF) position) const;

    version(QT_NO_RAWFONT){}else
    {
        QList!(QGlyphRun) glyphRuns(int from = -1, int length = -1) const;
    }

private:
    this(int line, QTextEngine* e)
    {
        this.index = line;
        this.eng = e;
    }
    void layout_helper(int numGlyphs);
    void draw_internal(QPainter* p, ref const(QPointF) pos,
                           const(QTextLayout.FormatRange)* selection) const;

    /+ friend class QTextLayout; +/
    /+ friend class QTextFragment; +/
    int index = 0;
    QTextEngine* eng = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

