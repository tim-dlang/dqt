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
module qt.widgets.textedit;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.global;
import qt.core.list;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.string;
import qt.core.url;
import qt.core.variant;
import qt.gui.color;
import qt.gui.event;
import qt.gui.font;
import qt.gui.pagedpaintdevice;
import qt.gui.textcursor;
import qt.gui.textdocument;
import qt.gui.textformat;
import qt.gui.textoption;
import qt.helpers;
import qt.widgets.abstractscrollarea;
import qt.widgets.widget;
version (QT_NO_CONTEXTMENU) {} else
    import qt.widgets.menu;

/+ QT_REQUIRE_CONFIG(textedit); +/


extern(C++, class) struct QStyleSheet;
extern(C++, class) struct QTextEditPrivate;

/// Binding for C++ class [QTextEdit](https://doc.qt.io/qt-5/qtextedit.html).
class /+ Q_WIDGETS_EXPORT +/ QTextEdit : QAbstractScrollArea
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QTextEdit) +/
    /+ Q_PROPERTY(AutoFormatting autoFormatting READ autoFormatting WRITE setAutoFormatting)
    Q_PROPERTY(bool tabChangesFocus READ tabChangesFocus WRITE setTabChangesFocus)
    Q_PROPERTY(QString documentTitle READ documentTitle WRITE setDocumentTitle)
    Q_PROPERTY(bool undoRedoEnabled READ isUndoRedoEnabled WRITE setUndoRedoEnabled)
    Q_PROPERTY(LineWrapMode lineWrapMode READ lineWrapMode WRITE setLineWrapMode)
    QDOC_PROPERTY(QTextOption::WrapMode wordWrapMode READ wordWrapMode WRITE setWordWrapMode)
    Q_PROPERTY(int lineWrapColumnOrWidth READ lineWrapColumnOrWidth WRITE setLineWrapColumnOrWidth)
    Q_PROPERTY(bool readOnly READ isReadOnly WRITE setReadOnly)
#if QT_CONFIG(textmarkdownreader) && QT_CONFIG(textmarkdownwriter)
    Q_PROPERTY(QString markdown READ toMarkdown WRITE setMarkdown NOTIFY textChanged)
#endif
#ifndef QT_NO_TEXTHTMLPARSER
    Q_PROPERTY(QString html READ toHtml WRITE setHtml NOTIFY textChanged USER true)
#endif
    Q_PROPERTY(QString plainText READ toPlainText WRITE setPlainText DESIGNABLE false)
    Q_PROPERTY(bool overwriteMode READ overwriteMode WRITE setOverwriteMode)
#if QT_DEPRECATED_SINCE(5, 10)
    Q_PROPERTY(int tabStopWidth READ tabStopWidth WRITE setTabStopWidth)
#endif
    Q_PROPERTY(qreal tabStopDistance READ tabStopDistance WRITE setTabStopDistance)
    Q_PROPERTY(bool acceptRichText READ acceptRichText WRITE setAcceptRichText)
    Q_PROPERTY(int cursorWidth READ cursorWidth WRITE setCursorWidth)
    Q_PROPERTY(Qt::TextInteractionFlags textInteractionFlags READ textInteractionFlags WRITE setTextInteractionFlags)
    Q_PROPERTY(QTextDocument *document READ document WRITE setDocument DESIGNABLE false)
    Q_PROPERTY(QString placeholderText READ placeholderText WRITE setPlaceholderText) +/
public:
    enum LineWrapMode {
        NoWrap,
        WidgetWidth,
        FixedPixelWidth,
        FixedColumnWidth
    }
    /+ Q_ENUM(LineWrapMode) +/

    enum AutoFormattingFlag {
        AutoNone = 0,
        AutoBulletList = 0x00000001,
        AutoAll = 0xffffffff
    }

    /+ Q_DECLARE_FLAGS(AutoFormatting, AutoFormattingFlag) +/
alias AutoFormatting = QFlags!(AutoFormattingFlag);    /+ Q_FLAG(AutoFormatting) +/

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

    final qreal fontPointSize() const;
    final QString fontFamily() const;
    final int fontWeight() const;
    final bool fontUnderline() const;
    final bool fontItalic() const;
    final QColor textColor() const;
    final QColor textBackgroundColor() const;
    final QFont currentFont() const;
    final /+ Qt:: +/qt.core.namespace.Alignment alignment() const;

    final void mergeCurrentCharFormat(ref const(QTextCharFormat) modifier);

    final void setCurrentCharFormat(ref const(QTextCharFormat) format);
    final QTextCharFormat currentCharFormat() const;

    final AutoFormatting autoFormatting() const;
    final void setAutoFormatting(AutoFormatting features);

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

    final LineWrapMode lineWrapMode() const;
    final void setLineWrapMode(LineWrapMode mode);

    final int lineWrapColumnOrWidth() const;
    final void setLineWrapColumnOrWidth(int w);

    final QTextOption.WrapMode wordWrapMode() const;
    final void setWordWrapMode(QTextOption.WrapMode policy);

    /+ bool find(const QString &exp, QTextDocument::FindFlags options = QTextDocument::FindFlags()); +/
/+ #ifndef QT_NO_REGEXP +/
    version (QT_NO_REGEXP) {} else
    {
        /+ bool find(const QRegExp &exp, QTextDocument::FindFlags options = QTextDocument::FindFlags()); +/
    }
/+ #endif
#if QT_CONFIG(regularexpression) +/
    /+ bool find(const QRegularExpression &exp, QTextDocument::FindFlags options = QTextDocument::FindFlags()); +/
/+ #endif +/

    final QString toPlainText() const;
/+ #ifndef QT_NO_TEXTHTMLPARSER +/
    version (QT_NO_TEXTHTMLPARSER) {} else
    {
        final QString toHtml() const;
    }
/+ #endif
#if QT_CONFIG(textmarkdownwriter) +/
    final QString toMarkdown(QTextDocument.MarkdownFeatures features = QTextDocument.MarkdownFeature.MarkdownDialectGitHub) const;
/+ #endif +/

    final void ensureCursorVisible();

    /+ virtual +/ @QInvokable QVariant loadResource(int type, ref const(QUrl) name);
    version (QT_NO_CONTEXTMENU) {} else
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

    final bool acceptRichText() const;
    final void setAcceptRichText(bool accept);

    struct ExtraSelection
    {
        QTextCursor cursor;
        QTextCharFormat format;
    }
    final void setExtraSelections(ref const(QList!(ExtraSelection)) selections);
    final QList!(ExtraSelection) extraSelections() const;

    final void moveCursor(QTextCursor.MoveOperation operation, QTextCursor.MoveMode mode = QTextCursor.MoveMode.MoveAnchor);

    final bool canPaste() const;

    final void print(QPagedPaintDevice printer) const;

    override QVariant inputMethodQuery(/+ Qt:: +/qt.core.namespace.InputMethodQuery property) const;
    @QInvokable final QVariant inputMethodQuery(/+ Qt:: +/qt.core.namespace.InputMethodQuery query, QVariant argument) const;

public /+ Q_SLOTS +/:
    @QSlot final void setFontPointSize(qreal s);
    @QSlot final void setFontFamily(ref const(QString) fontFamily);
    @QSlot final void setFontWeight(int w);
    @QSlot final void setFontUnderline(bool b);
    @QSlot final void setFontItalic(bool b);
    @QSlot final void setTextColor(ref const(QColor) c);
    @QSlot final void setTextBackgroundColor(ref const(QColor) c);
    @QSlot final void setCurrentFont(ref const(QFont) f);
    @QSlot final void setAlignment(/+ Qt:: +/qt.core.namespace.Alignment a);

    @QSlot final void setPlainText(ref const(QString) text);
/+ #ifndef QT_NO_TEXTHTMLPARSER +/
    version (QT_NO_TEXTHTMLPARSER) {} else
    {
        @QSlot final void setHtml(ref const(QString) text);
    }
/+ #endif
#if QT_CONFIG(textmarkdownreader) +/
    @QSlot final void setMarkdown(ref const(QString) markdown);
/+ #endif +/
    @QSlot final void setText(ref const(QString) text);

    version (QT_NO_CLIPBOARD) {} else
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
    version (QT_NO_TEXTHTMLPARSER) {} else
    {
        @QSlot final void insertHtml(ref const(QString) text);
    }

    @QSlot final void append(ref const(QString) text);

    @QSlot final void scrollToAnchor(ref const(QString) name);

    @QSlot final void zoomIn(int range = 1);
    @QSlot final void zoomOut(int range = 1);

/+ Q_SIGNALS +/public:
    @QSignal final void textChanged();
    @QSignal final void undoAvailable(bool b);
    @QSignal final void redoAvailable(bool b);
    @QSignal final void currentCharFormatChanged(ref const(QTextCharFormat) format);
    @QSignal final void copyAvailable(bool b);
    @QSignal final void selectionChanged();
    @QSignal final void cursorPositionChanged();

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
    version (QT_NO_CONTEXTMENU) {} else
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
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ virtual +/ bool canInsertFromMimeData(const(QMimeData) source) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ virtual +/ void insertFromMimeData(const(QMimeData) source);
    }));

    /+ virtual +/ override void inputMethodEvent(QInputMethodEvent );

    this(ref QTextEditPrivate dd, QWidget parent);

    /+ virtual +/ override void scrollContentsBy(int dx, int dy);
    /+ virtual +/ void doSetTextCursor(ref const(QTextCursor) cursor);

    final void zoomInF(float range);

private:
    /+ Q_DISABLE_COPY(QTextEdit) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_repaintContents(const QRectF &r))
    Q_PRIVATE_SLOT(d_func(), void _q_currentCharFormatChanged(const QTextCharFormat &))
    Q_PRIVATE_SLOT(d_func(), void _q_adjustScrollbars())
    Q_PRIVATE_SLOT(d_func(), void _q_ensureVisible(const QRectF &))
    Q_PRIVATE_SLOT(d_func(), void _q_cursorPositionChanged())
#if QT_CONFIG(cursor)
    Q_PRIVATE_SLOT(d_func(), void _q_hoveredBlockWithMarkerChanged(const QTextBlock &))
#endif +/
    /+ friend class QTextEditControl; +/
    /+ friend class QTextDocument; +/
    /+ friend class QWidgetTextControl; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QTextEdit.AutoFormatting.enum_type) operator |(QTextEdit.AutoFormatting.enum_type f1, QTextEdit.AutoFormatting.enum_type f2)/+noexcept+/{return QFlags!(QTextEdit.AutoFormatting.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QTextEdit.AutoFormatting.enum_type) operator |(QTextEdit.AutoFormatting.enum_type f1, QFlags!(QTextEdit.AutoFormatting.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QTextEdit.AutoFormatting.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QTextEdit::AutoFormatting) +/
