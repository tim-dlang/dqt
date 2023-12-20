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
module qt.gui.textobject;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.core.typeinfo;
import qt.gui.textcursor;
import qt.gui.textdocument;
import qt.gui.textformat;
import qt.gui.textlayout;
import qt.gui.textlist;
import qt.helpers;
version (QT_NO_RAWFONT) {} else
    import qt.gui.glyphrun;

extern(C++, class) struct QTextObjectPrivate;

/// Binding for C++ class [QTextObject](https://doc.qt.io/qt-6/qtextobject.html).
class /+ Q_GUI_EXPORT +/ QTextObject : QObject
{
    mixin(Q_OBJECT);

protected:
    /+ explicit +/this(QTextDocument doc);
    mixin(mangleWindows("??1QTextObject@@MEAA@XZ", q{
    public ~this();
    }));

    final void setFormat(ref const(QTextFormat) format);

public:
    final QTextFormat format() const;
    final int formatIndex() const;

    final QTextDocument document() const;

    final int objectIndex() const;

protected:
    this(ref QTextObjectPrivate p, QTextDocument doc);

private:
    /+ Q_DECLARE_PRIVATE(QTextObject) +/
    /+ Q_DISABLE_COPY(QTextObject) +/
    /+ friend class QTextDocumentPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QTextBlockGroupPrivate;
/// Binding for C++ class [QTextBlockGroup](https://doc.qt.io/qt-6/qtextblockgroup.html).
class /+ Q_GUI_EXPORT +/ QTextBlockGroup : QTextObject
{
    mixin(Q_OBJECT);

protected:
    /+ explicit +/this(QTextDocument doc);
    ~this();

    /+ virtual +/ void blockInserted(ref const(QTextBlock) block);
    /+ virtual +/ void blockRemoved(ref const(QTextBlock) block);
    /+ virtual +/ void blockFormatChanged(ref const(QTextBlock) block);

    final QList!(QTextBlock) blockList() const;

protected:
    this(ref QTextBlockGroupPrivate p, QTextDocument doc);
private:
    /+ Q_DECLARE_PRIVATE(QTextBlockGroup) +/
    /+ Q_DISABLE_COPY(QTextBlockGroup) +/
    /+ friend class QTextDocumentPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

class /+ Q_GUI_EXPORT +/ QTextFrameLayoutData {
public:
    /+ virtual +/~this();
}

extern(C++, class) struct QTextFramePrivate;
/// Binding for C++ class [QTextFrame](https://doc.qt.io/qt-6/qtextframe.html).
class /+ Q_GUI_EXPORT +/ QTextFrame : QTextObject
{
    mixin(Q_OBJECT);

public:
    /+ explicit +/this(QTextDocument doc);
    ~this();

    pragma(inline, true) final void setFrameFormat(ref const(QTextFrameFormat) aformat)
    { QTextObject.setFormat(aformat); }
    final QTextFrameFormat frameFormat() const { return QTextObject.format().toFrameFormat(); }

    final QTextCursor firstCursorPosition() const;
    final QTextCursor lastCursorPosition() const;
    final int firstPosition() const;
    final int lastPosition() const;

    final QTextFrameLayoutData layoutData() const;
    final void setLayoutData(QTextFrameLayoutData data);

    final QList!(QTextFrame) childFrames() const;
    final QTextFrame parentFrame() const;

    extern(C++, class) struct iterator {
    private:
        QTextFrame f = null;
        int b = 0;
        int e = 0;
        QTextFrame cf = null;
        int cb = 0;

        /+ friend class QTextFrame; +/
        /+ friend class QTextTableCell; +/
        /+ friend class QTextDocumentLayoutPrivate; +/
        pragma(inline, true) this(QTextFrame frame, int block, int begin, int end)
        {
            this.f = frame;
            this.b = begin;
            this.e = end;
            this.cb = block;
        }
    public:
        /+ constexpr iterator() noexcept = default; +/
        //QTextFrame parentFrame() const { return f; }

        //QTextFrame currentFrame() const { return cf; }
        /+ Q_GUI_EXPORT +/ QTextBlock currentBlock() const;

        bool atEnd() const { return !cf && cb == e; }

        /+pragma(inline, true) bool operator ==(ref const(iterator) o) const { return f == o.f && cf == o.cf && cb == o.cb; }+/
        /+pragma(inline, true) bool operator !=(ref const(iterator) o) const { return f != o.f || cf != o.cf || cb != o.cb; }+/
        /+ Q_GUI_EXPORT +/ ref iterator opUnary(string op)() if (op == "++");
        /+pragma(inline, true) iterator operator ++(int) { iterator tmp = this; operator++(); return tmp; }+/
        /+ Q_GUI_EXPORT +/ ref iterator opUnary(string op)() if (op == "--");
        /+pragma(inline, true) iterator operator --(int) { iterator tmp = this; operator--(); return tmp; }+/
    }

    /+ friend class iterator; +/
    // more Qt
    alias Iterator = iterator;

    final iterator begin() const;
    final iterator end() const;

protected:
    this(ref QTextFramePrivate p, QTextDocument doc);
private:
    /+ friend class QTextDocumentPrivate; +/
    /+ Q_DECLARE_PRIVATE(QTextFrame) +/
    /+ Q_DISABLE_COPY(QTextFrame) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QTextFrame::iterator, Q_RELOCATABLE_TYPE); +/

/// Binding for C++ class [QTextBlockUserData](https://doc.qt.io/qt-6/qtextblockuserdata.html).
class /+ Q_GUI_EXPORT +/ QTextBlockUserData {
public:
    /+ virtual +/~this();
}

/// Binding for C++ class [QTextBlock](https://doc.qt.io/qt-6/qtextblock.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextBlock
{
private:
    /+ friend class QSyntaxHighlighter; +/
public:
    pragma(inline, true) this(QTextDocumentPrivate* priv, int b)
    {
        this.p = priv;
        this.n = b;
    }
    /+pragma(inline, true) this()
    {
        this.p = null;
        this.n = 0;
    }+/
    pragma(inline, true) this(ref const(QTextBlock) o)
    {
        this.p = cast(QTextDocumentPrivate*)o.p;
        this.n = o.n;
    }
    /+pragma(inline, true) ref QTextBlock operator =(ref const(QTextBlock) o) { p = o.p; n = o.n; return this; }+/

    bool isValid() const;

    /+pragma(inline, true) bool operator ==(ref const(QTextBlock) o) const { return p == o.p && n == o.n; }+/
    /+pragma(inline, true) bool operator !=(ref const(QTextBlock) o) const { return p != o.p || n != o.n; }+/
    /+pragma(inline, true) bool operator <(ref const(QTextBlock) o) const { return position() < o.position(); }+/

    int position() const;
    int length() const;
    bool contains(int position) const;

    QTextLayout* layout() const;
    void clearLayout();
    QTextBlockFormat blockFormat() const;
    int blockFormatIndex() const;
    QTextCharFormat charFormat() const;
    int charFormatIndex() const;

    /+ Qt:: +/qt.core.namespace.LayoutDirection textDirection() const;

    QString text() const;

    QList!(QTextLayout.FormatRange) textFormats() const;

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    const(QTextDocument) document() const;
    }));

    QTextList textList() const;

    QTextBlockUserData userData() const;
    void setUserData(QTextBlockUserData data);

    int userState() const;
    void setUserState(int state);

    int revision() const;
    void setRevision(int rev);

    bool isVisible() const;
    void setVisible(bool visible);

    int blockNumber() const;
    int firstLineNumber() const;

    void setLineCount(int count);
    int lineCount() const;

    extern(C++, class) struct iterator {
    private:
        const(QTextDocumentPrivate)* p = null;
        int b = 0;
        int e = 0;
        int n = 0;
        /+ friend class QTextBlock; +/
        this(const(QTextDocumentPrivate)* priv, int begin, int end, int f)
        {
            this.p = priv;
            this.b = begin;
            this.e = end;
            this.n = f;
        }
    public:
        /+ constexpr iterator() = default; +/

        /+ Q_GUI_EXPORT +/ QTextFragment fragment() const;

        bool atEnd() const { return n == e; }

        /+pragma(inline, true) bool operator ==(ref const(iterator) o) const { return p == o.p && n == o.n; }+/
        /+pragma(inline, true) bool operator !=(ref const(iterator) o) const { return p != o.p || n != o.n; }+/
        /+ Q_GUI_EXPORT +/ ref iterator opUnary(string op)() if (op == "++");
        /+pragma(inline, true) iterator operator ++(int) { iterator tmp = this; operator++(); return tmp; }+/
        /+ Q_GUI_EXPORT +/ ref iterator opUnary(string op)() if (op == "--");
        /+pragma(inline, true) iterator operator --(int) { iterator tmp = this; operator--(); return tmp; }+/
    }

    // more Qt
    alias Iterator = iterator;

    iterator begin() const;
    iterator end() const;

    QTextBlock next() const;
    QTextBlock previous() const;

    pragma(inline, true) int fragmentIndex() const { return n; }

private:
    QTextDocumentPrivate* p = null;
    int n = 0;
    /+ friend class QTextDocumentPrivate; +/
    /+ friend class QTextLayout; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QTextBlock, Q_RELOCATABLE_TYPE);
Q_DECLARE_TYPEINFO(QTextBlock::iterator, Q_RELOCATABLE_TYPE); +/


/// Binding for C++ class [QTextFragment](https://doc.qt.io/qt-6/qtextfragment.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextFragment
{
public:
    pragma(inline, true) this(const(QTextDocumentPrivate)* priv, int f, int fe)
    {
        this.p = priv;
        this.n = f;
        this.ne = fe;
    }
    @disable this();
    /+pragma(inline, true) this()
    {
        this.p = null;
        this.n = 0;
        this.ne = 0;
    }+/
    @disable this(this);
    pragma(inline, true) this(ref const(QTextFragment) o)
    {
        this.p = o.p;
        this.n = o.n;
        this.ne = o.ne;
    }
    /+pragma(inline, true) ref QTextFragment operator =(ref const(QTextFragment) o) { p = o.p; n = o.n; ne = o.ne; return this; }+/

    pragma(inline, true) bool isValid() const { return p && n; }

    /+pragma(inline, true) bool operator ==(ref const(QTextFragment) o) const { return p == o.p && n == o.n; }+/
    /+pragma(inline, true) bool operator !=(ref const(QTextFragment) o) const { return p != o.p || n != o.n; }+/
    /+pragma(inline, true) bool operator <(ref const(QTextFragment) o) const { return position() < o.position(); }+/

    int position() const;
    int length() const;
    bool contains(int position) const;

    QTextCharFormat charFormat() const;
    int charFormatIndex() const;
    QString text() const;

    version (QT_NO_RAWFONT) {} else
    {
        QList!(QGlyphRun) glyphRuns(int from = -1, int length = -1) const;
    }

private:
    const(QTextDocumentPrivate)* p = null;
    int n = 0;
    int ne = 0;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QTextFragment, Q_RELOCATABLE_TYPE); +/

