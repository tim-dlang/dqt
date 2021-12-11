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
module qt.widgets.plaintextedit;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.global;
import qt.core.list;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.url;
import qt.core.variant;
import qt.gui.abstracttextdocumentlayout;
import qt.gui.event;
import qt.gui.pagedpaintdevice;
import qt.gui.painter;
import qt.gui.textcursor;
import qt.gui.textdocument;
import qt.gui.textformat;
import qt.gui.textobject;
import qt.gui.textoption;
import qt.helpers;
import qt.widgets.abstractscrollarea;
import qt.widgets.textedit;
import qt.widgets.widget;
version(QT_NO_CONTEXTMENU){}else
    import qt.widgets.menu;

/+ QT_REQUIRE_CONFIG(textedit);


class QStyleSheet;
class QTextDocument;
class QMenu; +/
extern(C++, class) struct QPlainTextEditPrivate;
/+ class QMimeData;
class QPagedPaintDevice;
class QRegularExpression; +/

/// Binding for C++ class [QPlainTextEdit](https://doc.qt.io/qt-5/qplaintextedit.html).
class /+ Q_WIDGETS_EXPORT +/ QPlainTextEdit : QAbstractScrollArea
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QPlainTextEdit) +/
    /+ Q_PROPERTY(bool tabChangesFocus READ tabChangesFocus WRITE setTabChangesFocus)
    Q_PROPERTY(QString documentTitle READ documentTitle WRITE setDocumentTitle)
    Q_PROPERTY(bool undoRedoEnabled READ isUndoRedoEnabled WRITE setUndoRedoEnabled)
    Q_PROPERTY(LineWrapMode lineWrapMode READ lineWrapMode WRITE setLineWrapMode)
    QDOC_PROPERTY(QTextOption::WrapMode wordWrapMode READ wordWrapMode WRITE setWordWrapMode)
    Q_PROPERTY(bool readOnly READ isReadOnly WRITE setReadOnly)
    Q_PROPERTY(QString plainText READ toPlainText WRITE setPlainText NOTIFY textChanged USER true)
    Q_PROPERTY(bool overwriteMode READ overwriteMode WRITE setOverwriteMode)
#if QT_DEPRECATED_SINCE(5, 10)
    Q_PROPERTY(int tabStopWidth READ tabStopWidth WRITE setTabStopWidth)
#endif
    Q_PROPERTY(qreal tabStopDistance READ tabStopDistance WRITE setTabStopDistance)
    Q_PROPERTY(int cursorWidth READ cursorWidth WRITE setCursorWidth)
    Q_PROPERTY(Qt::TextInteractionFlags textInteractionFlags READ textInteractionFlags WRITE setTextInteractionFlags)
    Q_PROPERTY(int blockCount READ blockCount)
    Q_PROPERTY(int maximumBlockCount READ maximumBlockCount WRITE setMaximumBlockCount)
    Q_PROPERTY(bool backgroundVisible READ backgroundVisible WRITE setBackgroundVisible)
    Q_PROPERTY(bool centerOnScroll READ centerOnScroll WRITE setCenterOnScroll)
    Q_PROPERTY(QString placeholderText READ placeholderText WRITE setPlaceholderText) +/
public:
    enum LineWrapMode {
        NoWrap,
        WidgetWidth
    }
    /+ Q_ENUM(LineWrapMode) +/

    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QString) text, QWidget parent = null);
    /+ virtual +/~this();

    final void setDocument(QTextDocument document);
    final QTextDocument document() const;

    final void setPlaceholderText(ref const(QString) placeholderText);
    final QString placeholderText() const;

    final void setTextCursor(ref const(QTextCursor) cursor);
    final QTextCursor textCursor() const;

    final bool isReadOnly() const;
    final void setReadOnly(bool ro);

    final void setTextInteractionFlags(/+ Qt:: +/qt.core.namespace.TextInteractionFlags flags);
    final /+ Qt:: +/qt.core.namespace.TextInteractionFlags textInteractionFlags() const;

    final void mergeCurrentCharFormat(ref const(QTextCharFormat) modifier);
    final void setCurrentCharFormat(ref const(QTextCharFormat) format);
    final QTextCharFormat currentCharFormat() const;

    final bool tabChangesFocus() const;
    final void setTabChangesFocus(bool b);

    pragma(inline, true) final void setDocumentTitle(ref const(QString) title)
    { document().setMetaInformation(QTextDocument.MetaInformation.DocumentTitle, title); }
    pragma(inline, true) final QString documentTitle() const
    { return document().metaInformation(QTextDocument.MetaInformation.DocumentTitle); }

    pragma(inline, true) final bool isUndoRedoEnabled() const
    { return document().isUndoRedoEnabled(); }
    pragma(inline, true) final void setUndoRedoEnabled(bool enable)
    { document().setUndoRedoEnabled(enable); }

    pragma(inline, true) final void setMaximumBlockCount(int maximum)
    { document().setMaximumBlockCount(maximum); }
    pragma(inline, true) final int maximumBlockCount() const
    { return document().maximumBlockCount(); }


    final LineWrapMode lineWrapMode() const;
    final void setLineWrapMode(LineWrapMode mode);

    final QTextOption.WrapMode wordWrapMode() const;
    final void setWordWrapMode(QTextOption.WrapMode policy);

    final void setBackgroundVisible(bool visible);
    final bool backgroundVisible() const;

    final void setCenterOnScroll(bool enabled);
    final bool centerOnScroll() const;

    /+ bool find(const QString &exp, QTextDocument::FindFlags options = QTextDocument::FindFlags()); +/
/+ #ifndef QT_NO_REGEXP +/
    version(QT_NO_REGEXP){}else
    {
        /+ bool find(const QRegExp &exp, QTextDocument::FindFlags options = QTextDocument::FindFlags()); +/
    }
/+ #endif
#if QT_CONFIG(regularexpression) +/
    /+ bool find(const QRegularExpression &exp, QTextDocument::FindFlags options = QTextDocument::FindFlags()); +/
/+ #endif +/

    pragma(inline, true) final QString toPlainText() const
    { return document().toPlainText(); }

    final void ensureCursorVisible();

    /+ virtual +/ QVariant loadResource(int type, ref const(QUrl) name);
    version(QT_NO_CONTEXTMENU){}else
    {
        final QMenu createStandardContextMenu();
        final QMenu createStandardContextMenu(ref const(QPoint) position);
    }

    final QTextCursor cursorForPosition(ref const(QPoint) pos) const;
    final QRect cursorRect(ref const(QTextCursor) cursor) const;
    final QRect cursorRect() const;

    final QString anchorAt(ref const(QPoint) pos) const;

    final bool overwriteMode() const;
    final void setOverwriteMode(bool overwrite);

/+ #if QT_DEPRECATED_SINCE(5, 10) +/
    /+ QT_DEPRECATED +/ final int tabStopWidth() const;
    /+ QT_DEPRECATED +/ final void setTabStopWidth(int width);
/+ #endif +/

    final qreal tabStopDistance() const;
    final void setTabStopDistance(qreal distance);

    final int cursorWidth() const;
    final void setCursorWidth(int width);

    final void setExtraSelections(ref const(QList!(QTextEdit.ExtraSelection)) selections);
    final QList!(QTextEdit.ExtraSelection) extraSelections() const;

    final void moveCursor(QTextCursor.MoveOperation operation, QTextCursor.MoveMode mode = QTextCursor.MoveMode.MoveAnchor);

    final bool canPaste() const;

    final void print(QPagedPaintDevice printer) const;

    final int blockCount() const;
    override QVariant inputMethodQuery(/+ Qt:: +/qt.core.namespace.InputMethodQuery property) const;
    @QInvokable final QVariant inputMethodQuery(/+ Qt:: +/qt.core.namespace.InputMethodQuery query, QVariant argument) const;

public /+ Q_SLOTS +/:

    @QSlot final void setPlainText(ref const(QString) text);
    final void setPlainText(const QString s){setPlainText(s);}

    version(QT_NO_CLIPBOARD){}else
    {
        @QSlot final void cut();
        /+ void copy(); +/
        @QSlot final void paste();
    }

    @QSlot final void undo();
    @QSlot final void redo();

    @QSlot final void clear();
    @QSlot final void selectAll();

    @QSlot final void insertPlainText(ref const(QString) text);

    @QSlot final void appendPlainText(ref const(QString) text);
    @QSlot final void appendPlainText(const(QString) text)
    {
        appendPlainText(text);
    }
    @QSlot final void appendHtml(ref const(QString) html);

    @QSlot final void centerCursor();

    @QSlot final void zoomIn(int range = 1);
    @QSlot final void zoomOut(int range = 1);

/+ Q_SIGNALS +/public:
    @QSignal final void textChanged();
    @QSignal final void undoAvailable(bool b);
    @QSignal final void redoAvailable(bool b);
    @QSignal final void copyAvailable(bool b);
    @QSignal final void selectionChanged();
    @QSignal final void cursorPositionChanged();

    @QSignal final void updateRequest(ref const(QRect) rect, int dy);
    @QSignal final void blockCountChanged(int newBlockCount);
    @QSignal final void modificationChanged(bool);

protected:
    /+ virtual +/ override bool event(QEvent e);
    /+ virtual +/ override void timerEvent(QTimerEvent e);
    /+ virtual +/ override void keyPressEvent(QKeyEvent e);
    /+ virtual +/ override void keyReleaseEvent(QKeyEvent e);
    /+ virtual +/ override void resizeEvent(QResizeEvent e);
    /+ virtual +/ override void paintEvent(QPaintEvent e);
    /+ virtual +/ override void mousePressEvent(QMouseEvent e);
    /+ virtual +/ override void mouseMoveEvent(QMouseEvent e);
    /+ virtual +/ override void mouseReleaseEvent(QMouseEvent e);
    /+ virtual +/ override void mouseDoubleClickEvent(QMouseEvent e);
    /+ virtual +/ override bool focusNextPrevChild(bool next);
/+ #ifndef QT_NO_CONTEXTMENU +/
    version(QT_NO_CONTEXTMENU){}else
    {
        /+ virtual +/ override void contextMenuEvent(QContextMenuEvent e);
    }
/+ #endif
#if QT_CONFIG(draganddrop) +/
    /+ virtual +/ override void dragEnterEvent(QDragEnterEvent e);
    /+ virtual +/ override void dragLeaveEvent(QDragLeaveEvent e);
    /+ virtual +/ override void dragMoveEvent(QDragMoveEvent e);
    /+ virtual +/ override void dropEvent(QDropEvent e);
/+ #endif +/
    /+ virtual +/ override void focusInEvent(QFocusEvent e);
    /+ virtual +/ override void focusOutEvent(QFocusEvent e);
    /+ virtual +/ override void showEvent(QShowEvent );
    /+ virtual +/ override void changeEvent(QEvent e);
/+ #if QT_CONFIG(wheelevent) +/
    /+ virtual +/ override void wheelEvent(QWheelEvent e);
/+ #endif +/

    /+ virtual +/ QMimeData createMimeDataFromSelection() const;
    mixin(mangleWindows("?canInsertFromMimeData@QPlainTextEdit@@MEBA_NPEBVQMimeData@@@Z", q{
    /+ virtual +/ bool canInsertFromMimeData(const(QMimeData) source) const;
    }));
    mixin(mangleWindows("?insertFromMimeData@QPlainTextEdit@@MEAAXPEBVQMimeData@@@Z", q{
    /+ virtual +/ void insertFromMimeData(const(QMimeData) source);
    }));

    /+ virtual +/ override void inputMethodEvent(QInputMethodEvent );

    this(ref QPlainTextEditPrivate dd, QWidget parent);

    /+ virtual +/ override void scrollContentsBy(int dx, int dy);
    /+ virtual +/ void doSetTextCursor(ref const(QTextCursor) cursor);

    final QTextBlock firstVisibleBlock() const;
    final QPointF contentOffset() const;
    final QRectF blockBoundingRect(ref const(QTextBlock) block) const;
    final QRectF blockBoundingGeometry(ref const(QTextBlock) block) const;
    final QAbstractTextDocumentLayout.PaintContext getPaintContext() const;

    final void zoomInF(float range);

private:
    /+ Q_DISABLE_COPY(QPlainTextEdit) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_repaintContents(const QRectF &r))
    Q_PRIVATE_SLOT(d_func(), void _q_textChanged())
    Q_PRIVATE_SLOT(d_func(), void _q_adjustScrollbars())
    Q_PRIVATE_SLOT(d_func(), void _q_verticalScrollbarActionTriggered(int))
    Q_PRIVATE_SLOT(d_func(), void _q_cursorPositionChanged()) +/

    /+ friend class QPlainTextEditControl; +/
}


extern(C++, class) struct QPlainTextDocumentLayoutPrivate;
/// Binding for C++ class [QPlainTextDocumentLayout](https://doc.qt.io/qt-5/qplaintextdocumentlayout.html).
class /+ Q_WIDGETS_EXPORT +/ QPlainTextDocumentLayout : QAbstractTextDocumentLayout
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QPlainTextDocumentLayout) +/
    /+ Q_PROPERTY(int cursorWidth READ cursorWidth WRITE setCursorWidth) +/

public:
    this(QTextDocument document);
    ~this();

    override void draw(QPainter* , ref const(PaintContext) );
    override int hitTest(ref const(QPointF) , /+ Qt:: +/qt.core.namespace.HitTestAccuracy ) const;

    override int pageCount() const;
    override QSizeF documentSize() const;

    override QRectF frameBoundingRect(QTextFrame ) const;
    override QRectF blockBoundingRect(ref const(QTextBlock) block) const;

    final void ensureBlockLayout(ref const(QTextBlock) block) const;

    final void setCursorWidth(int width);
    final int cursorWidth() const;

    final void requestUpdate();

protected:
    override void documentChanged(int from, int /*charsRemoved*/, int charsAdded);


private:
    final void setTextWidth(qreal newWidth);
    final qreal textWidth() const;
    final void layoutBlock(ref const(QTextBlock) block);
    final qreal blockWidth(ref const(QTextBlock) block);

    final QPlainTextDocumentLayoutPrivate* priv() const;

    /+ friend class QPlainTextEdit; +/
    /+ friend class QPlainTextEditPrivate; +/
}

