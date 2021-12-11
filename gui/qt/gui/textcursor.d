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
module qt.gui.textcursor;
extern(C++):

import qt.config;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.gui.image;
import qt.gui.textdocument;
import qt.gui.textdocumentfragment;
import qt.gui.textformat;
import qt.gui.textlist;
import qt.gui.textobject;
import qt.gui.texttable;
import qt.helpers;

/+ class QTextDocument; +/
extern(C++, class) struct QTextCursorPrivate;
/+ class QTextDocumentFragment;
class QTextCharFormat;
class QTextBlockFormat;
class QTextListFormat;
class QTextTableFormat;
class QTextFrameFormat;
class QTextImageFormat;class QTextList;
class QTextTable;
class QTextFrame;
class QTextBlock; +/

@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextCursor
{
public:
    /+this();+/

    /+ explicit +/this(QTextDocument document);
    this(QTextDocumentPrivate* p, int pos);
    /+ explicit +/this(QTextCursorPrivate* d);
    /+ explicit +/this(QTextFrame frame);
    /+ explicit +/this(ref const(QTextBlock) block);
    //@disable this(this);
    //this(ref const(QTextCursor) cursor);
    /+ QTextCursor &operator=(QTextCursor &&other) noexcept { swap(other); return *this; } +/
    /+ref QTextCursor operator =(ref const(QTextCursor) other);+/
    ~this();

    /+ void swap(QTextCursor &other) noexcept { qSwap(d, other.d); } +/

    bool isNull() const;

    enum MoveMode {
        MoveAnchor,
        KeepAnchor
    }

    void setPosition(int pos, MoveMode mode = MoveMode.MoveAnchor);
    int position() const;
    int positionInBlock() const;

    int anchor() const;

    void insertText(ref const(QString) text);
    void insertText(ref const(QString) text, ref const(QTextCharFormat) format);

    enum MoveOperation {
        NoMove,

        Start,
        Up,
        StartOfLine,
        StartOfBlock,
        StartOfWord,
        PreviousBlock,
        PreviousCharacter,
        PreviousWord,
        Left,
        WordLeft,

        End,
        Down,
        EndOfLine,
        EndOfWord,
        EndOfBlock,
        NextBlock,
        NextCharacter,
        NextWord,
        Right,
        WordRight,

        NextCell,
        PreviousCell,
        NextRow,
        PreviousRow
    }

    bool movePosition(MoveOperation op, MoveMode /+ = MoveAnchor +/, int n = 1);

    bool visualNavigation() const;
    void setVisualNavigation(bool b);

    void setVerticalMovementX(int x);
    int verticalMovementX() const;

    void setKeepPositionOnInsert(bool b);
    bool keepPositionOnInsert() const;

    void deleteChar();
    void deletePreviousChar();

    enum SelectionType {
        WordUnderCursor,
        LineUnderCursor,
        BlockUnderCursor,
        Document
    }
    void select(SelectionType selection);

    bool hasSelection() const;
    bool hasComplexSelection() const;
    void removeSelectedText();
    void clearSelection();
    int selectionStart() const;
    int selectionEnd() const;

    QString selectedText() const;
    QTextDocumentFragment selection() const;
    void selectedTableCells(int* firstRow, int* numRows, int* firstColumn, int* numColumns) const;

    QTextBlock block() const;

    QTextCharFormat charFormat() const;
    void setCharFormat(ref const(QTextCharFormat) format);
    void mergeCharFormat(ref const(QTextCharFormat) modifier);

    QTextBlockFormat blockFormat() const;
    void setBlockFormat(ref const(QTextBlockFormat) format);
    void mergeBlockFormat(ref const(QTextBlockFormat) modifier);

    QTextCharFormat blockCharFormat() const;
    void setBlockCharFormat(ref const(QTextCharFormat) format);
    void mergeBlockCharFormat(ref const(QTextCharFormat) modifier);

    bool atBlockStart() const;
    bool atBlockEnd() const;
    bool atStart() const;
    bool atEnd() const;

    void insertBlock();
    void insertBlock(ref const(QTextBlockFormat) format);
    void insertBlock(ref const(QTextBlockFormat) format, ref const(QTextCharFormat) charFormat);

    QTextList insertList(ref const(QTextListFormat) format);
    QTextList insertList(QTextListFormat.Style style);

    QTextList createList(ref const(QTextListFormat) format);
    QTextList createList(QTextListFormat.Style style);
    QTextList currentList() const;

    QTextTable insertTable(int rows, int cols, ref const(QTextTableFormat) format);
    QTextTable insertTable(int rows, int cols);
    QTextTable currentTable() const;

    QTextFrame insertFrame(ref const(QTextFrameFormat) format);
    QTextFrame currentFrame() const;

    void insertFragment(ref const(QTextDocumentFragment) fragment);

    version(QT_NO_TEXTHTMLPARSER){}else
    {
        void insertHtml(ref const(QString) html);
    }

    void insertImage(ref const(QTextImageFormat) format, QTextFrameFormat.Position alignment);
    void insertImage(ref const(QTextImageFormat) format);
    void insertImage(ref const(QString) name);
    void insertImage(ref const(QImage) image, ref const(QString) name = globalInitVar!QString);

    void beginEditBlock();
    void joinPreviousEditBlock();
    void endEditBlock();

    /+bool operator !=(ref const(QTextCursor) rhs) const;+/
    /+bool operator <(ref const(QTextCursor) rhs) const;+/
    /+bool operator <=(ref const(QTextCursor) rhs) const;+/
    /+bool operator ==(ref const(QTextCursor) rhs) const;+/
    /+bool operator >=(ref const(QTextCursor) rhs) const;+/
    /+bool operator >(ref const(QTextCursor) rhs) const;+/

    bool isCopyOf(ref const(QTextCursor) other) const;

    int blockNumber() const;
    int columnNumber() const;

    QTextDocument document() const;

private:
    QSharedDataPointer!(QTextCursorPrivate) d;
    /+ friend class QTextCursorPrivate; +/
    /+ friend class QTextDocumentPrivate; +/
    /+ friend class QTextDocumentFragmentPrivate; +/
    /+ friend class QTextCopyHelper; +/
    /+ friend class QWidgetTextControlPrivate; +/
}

/+ Q_DECLARE_SHARED(QTextCursor) +/

