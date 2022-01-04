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
module qt.gui.textdocument;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.flags;
import qt.core.global;
import qt.core.namespace;
import qt.core.object;
import qt.core.qchar;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.textcodec;
import qt.core.url;
import qt.core.variant;
import qt.core.vector;
import qt.gui.abstracttextdocumentlayout;
import qt.gui.font;
import qt.gui.painter;
import qt.gui.textcursor;
import qt.gui.textformat;
import qt.gui.textobject;
import qt.gui.textoption;
import qt.helpers;
version(QT_NO_PRINTER){}else
    import qt.gui.pagedpaintdevice;

extern(C++, class) struct QTextDocumentPrivate;

extern(C++, "Qt")
{
    /+ Q_GUI_EXPORT +/ bool mightBeRichText(ref const(QString));
    /+ Q_GUI_EXPORT +/ QString convertFromPlainText(ref const(QString) plain, qt.core.namespace.WhiteSpaceMode mode = qt.core.namespace.WhiteSpaceMode.WhiteSpacePre);

/+ #if QT_CONFIG(textcodec) || defined(Q_CLANG_QDOC) +/
    /+ Q_GUI_EXPORT +/ QTextCodec codecForHtml(ref const(QByteArray) ba);
/+ #endif +/
}

class /+ Q_GUI_EXPORT +/ QAbstractUndoItem
{
public:
    /+ virtual +//*abstract*/ ~this(){}
    /+ virtual +/ abstract void undo();
    /+ virtual +/ abstract void redo();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QTextDocument](https://doc.qt.io/qt-5/qtextdocument.html).
class /+ Q_GUI_EXPORT +/ QTextDocument : QObject
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(bool undoRedoEnabled READ isUndoRedoEnabled WRITE setUndoRedoEnabled)
    Q_PROPERTY(bool modified READ isModified WRITE setModified DESIGNABLE false)
    Q_PROPERTY(QSizeF pageSize READ pageSize WRITE setPageSize)
    Q_PROPERTY(QFont defaultFont READ defaultFont WRITE setDefaultFont)
    Q_PROPERTY(bool useDesignMetrics READ useDesignMetrics WRITE setUseDesignMetrics)
    Q_PROPERTY(QSizeF size READ size)
    Q_PROPERTY(qreal textWidth READ textWidth WRITE setTextWidth)
    Q_PROPERTY(int blockCount READ blockCount)
    Q_PROPERTY(qreal indentWidth READ indentWidth WRITE setIndentWidth)
#ifndef QT_NO_CSSPARSER
    Q_PROPERTY(QString defaultStyleSheet READ defaultStyleSheet WRITE setDefaultStyleSheet)
#endif
    Q_PROPERTY(int maximumBlockCount READ maximumBlockCount WRITE setMaximumBlockCount)
    Q_PROPERTY(qreal documentMargin READ documentMargin WRITE setDocumentMargin)
    QDOC_PROPERTY(QTextOption defaultTextOption READ defaultTextOption WRITE setDefaultTextOption)
    Q_PROPERTY(QUrl baseUrl READ baseUrl WRITE setBaseUrl NOTIFY baseUrlChanged) +/

public:
    /+ explicit +/this(QObject parent = null);
    /+ explicit +/this(ref const(QString) text, QObject parent = null);
    ~this();

    final QTextDocument clone(QObject parent = null) const;

    final bool isEmpty() const;
    /+ virtual +/ void clear();

    final void setUndoRedoEnabled(bool enable);
    final bool isUndoRedoEnabled() const;

    final bool isUndoAvailable() const;
    final bool isRedoAvailable() const;

    final int availableUndoSteps() const;
    final int availableRedoSteps() const;

    final int revision() const;

    final void setDocumentLayout(QAbstractTextDocumentLayout layout);
    final QAbstractTextDocumentLayout documentLayout() const;

    enum MetaInformation {
        DocumentTitle,
        DocumentUrl
    }
    final void setMetaInformation(MetaInformation info, ref const(QString) );
    final QString metaInformation(MetaInformation info) const;

/+ #ifndef QT_NO_TEXTHTMLPARSER +/
    version(QT_NO_TEXTHTMLPARSER){}else
    {
        final QString toHtml(ref const(QByteArray) encoding = globalInitVar!QByteArray) const;
        final void setHtml(ref const(QString) html);
    }
/+ #endif

#if QT_CONFIG(textmarkdownwriter) || QT_CONFIG(textmarkdownreader) +/
    enum MarkdownFeature {
        MarkdownNoHTML = 0x0020 | 0x0040,
        MarkdownDialectCommonMark = 0,
        MarkdownDialectGitHub = 0x0004 | 0x0008 | 0x0400 | 0x0100 | 0x0200 | 0x0800
    }
    /+ Q_DECLARE_FLAGS(MarkdownFeatures, MarkdownFeature) +/
alias MarkdownFeatures = QFlags!(MarkdownFeature);    /+ Q_FLAG(MarkdownFeatures) +/
/+ #endif

#if QT_CONFIG(textmarkdownwriter) +/
    final QString toMarkdown(MarkdownFeatures features = MarkdownFeature.MarkdownDialectGitHub) const;
/+ #endif

#if QT_CONFIG(textmarkdownreader) +/
    final void setMarkdown(ref const(QString) markdown, MarkdownFeatures features = MarkdownFeature.MarkdownDialectGitHub);
/+ #endif +/

    final QString toRawText() const;
    final QString toPlainText() const;
    final void setPlainText(ref const(QString) text);

    final QChar characterAt(int pos) const;

    enum FindFlag
    {
        FindBackward        = 0x00001,
        FindCaseSensitively = 0x00002,
        FindWholeWords      = 0x00004
    }
    /+ Q_DECLARE_FLAGS(FindFlags, FindFlag) +/
alias FindFlags = QFlags!(FindFlag);
    /+ QTextCursor find(const QString &subString, int from = 0, FindFlags options = FindFlags()) const; +/
    /+ QTextCursor find(const QString &subString, const QTextCursor &cursor, FindFlags options = FindFlags()) const; +/

/+ #ifndef QT_NO_REGEXP +/
    version(QT_NO_REGEXP){}else
    {
        /+ QTextCursor find(const QRegExp &expr, int from = 0, FindFlags options = FindFlags()) const; +/
        /+ QTextCursor find(const QRegExp &expr, const QTextCursor &cursor, FindFlags options = FindFlags()) const; +/
    }
/+ #endif

#if QT_CONFIG(regularexpression) +/
    /+ QTextCursor find(const QRegularExpression &expr, int from = 0, FindFlags options = FindFlags()) const; +/
    /+ QTextCursor find(const QRegularExpression &expr, const QTextCursor &cursor, FindFlags options = FindFlags()) const; +/
/+ #endif +/

    final QTextFrame frameAt(int pos) const;
    final QTextFrame rootFrame() const;

    final QTextObject object(int objectIndex) const;
    final QTextObject objectForFormat(ref const(QTextFormat) ) const;

    final QTextBlock findBlock(int pos) const;
    final QTextBlock findBlockByNumber(int blockNumber) const;
    final QTextBlock findBlockByLineNumber(int blockNumber) const;
    final QTextBlock begin() const;
    final QTextBlock end() const;

    final QTextBlock firstBlock() const;
    final QTextBlock lastBlock() const;

    final void setPageSize(ref const(QSizeF) size);
    final QSizeF pageSize() const;

    final void setDefaultFont(ref const(QFont) font);
    final QFont defaultFont() const;

    final int pageCount() const;

    final bool isModified() const;

    version(QT_NO_PRINTER){}else
    {
        final void print(QPagedPaintDevice printer) const;
    }

    enum ResourceType {
        UnknownResource = 0,
        HtmlResource  = 1,
        ImageResource = 2,
        StyleSheetResource = 3,
        MarkdownResource = 4,

        UserResource  = 100
    }
    /+ Q_ENUM(ResourceType) +/

    final QVariant resource(int type, ref const(QUrl) name) const;
    final void addResource(int type, ref const(QUrl) name, ref const(QVariant) resource);

    final QVector!(QTextFormat) allFormats() const;

    final void markContentsDirty(int from, int length);

    final void setUseDesignMetrics(bool b);
    final bool useDesignMetrics() const;

    final void drawContents(QPainter* painter, ref const(QRectF) rect = globalInitVar!QRectF);

    final void setTextWidth(qreal width);
    final qreal textWidth() const;

    final qreal idealWidth() const;

    final qreal indentWidth() const;
    final void setIndentWidth(qreal width);

    final qreal documentMargin() const;
    final void setDocumentMargin(qreal margin);

    final void adjustSize();
    final QSizeF size() const;

    final int blockCount() const;
    final int lineCount() const;
    final int characterCount() const;

    version(QT_NO_CSSPARSER){}else
    {
        final void setDefaultStyleSheet(ref const(QString) sheet);
        final QString defaultStyleSheet() const;
    }

    final void undo(QTextCursor* cursor);
    final void redo(QTextCursor* cursor);

    enum Stacks {
        UndoStack = 0x01,
        RedoStack = 0x02,
        UndoAndRedoStacks = Stacks.UndoStack | Stacks.RedoStack
    }
    final void clearUndoRedoStacks(Stacks historyToClear = Stacks.UndoAndRedoStacks);

    final int maximumBlockCount() const;
    final void setMaximumBlockCount(int maximum);

    final QTextOption defaultTextOption() const;
    final void setDefaultTextOption(ref const(QTextOption) option);

    final QUrl baseUrl() const;
    final void setBaseUrl(ref const(QUrl) url);

    final /+ Qt:: +/qt.core.namespace.CursorMoveStyle defaultCursorMoveStyle() const;
    final void setDefaultCursorMoveStyle(/+ Qt:: +/qt.core.namespace.CursorMoveStyle style);

/+ Q_SIGNALS +/public:
    @QSignal final void contentsChange(int from, int charsRemoved, int charsAdded);
    @QSignal final void contentsChanged();
    @QSignal final void undoAvailable(bool);
    @QSignal final void redoAvailable(bool);
    @QSignal final void undoCommandAdded();
    @QSignal final void modificationChanged(bool m);
    @QSignal final void cursorPositionChanged(ref const(QTextCursor) cursor);
    @QSignal final void blockCountChanged(int newBlockCount);
    @QSignal final void baseUrlChanged(ref const(QUrl) url);
    @QSignal final void documentLayoutChanged();

public /+ Q_SLOTS +/:
    @QSlot final void undo();
    @QSlot final void redo();
    @QSlot final void appendUndoItem(QAbstractUndoItem );
    @QSlot final void setModified(bool m = true);

protected:
    /+ virtual +/ QTextObject createObject(ref const(QTextFormat) f);
    /+ virtual +/ @QInvokable QVariant loadResource(int type, ref const(QUrl) name);

    this(ref QTextDocumentPrivate dd, QObject parent);
public:
    final QTextDocumentPrivate* docHandle() const;
private:
    /+ Q_DISABLE_COPY(QTextDocument) +/
    /+ Q_DECLARE_PRIVATE(QTextDocument) +/
    /+ friend class QTextObjectPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QTextDocument.FindFlags.enum_type) operator |(QTextDocument.FindFlags.enum_type f1, QTextDocument.FindFlags.enum_type f2)/+noexcept+/{return QFlags!(QTextDocument.FindFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QTextDocument.FindFlags.enum_type) operator |(QTextDocument.FindFlags.enum_type f1, QFlags!(QTextDocument.FindFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QTextDocument.FindFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QTextDocument::FindFlags) +/
