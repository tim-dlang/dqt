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
module qt.gui.abstracttextdocumentlayout;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.gui.paintdevice;
import qt.gui.painter;
import qt.gui.palette;
import qt.gui.textcursor;
import qt.gui.textdocument;
import qt.gui.textformat;
import qt.gui.textlayout;
import qt.gui.textobject;
import qt.helpers;

extern(C++, class) struct QAbstractTextDocumentLayoutPrivate;

/// Binding for C++ class [QAbstractTextDocumentLayout](https://doc.qt.io/qt-6/qabstracttextdocumentlayout.html).
abstract class /+ Q_GUI_EXPORT +/ QAbstractTextDocumentLayout : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QAbstractTextDocumentLayout) +/

public:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QTextDocument doc);
    }));
    ~this();

    struct Selection
    {
        QTextCursor cursor;
        QTextCharFormat format;
    }

    struct PaintContext
    {
        @disable this(this);
        int cursorPosition = -1;
        QPalette palette;
        QRectF clip;
        QList!(Selection) selections;
    }

    /+ virtual +/ abstract void draw(QPainter* painter, ref const(PaintContext) context);
    /+ virtual +/ abstract int hitTest(ref const(QPointF) point, /+ Qt:: +/qt.core.namespace.HitTestAccuracy accuracy) const;

    final QString anchorAt(ref const(QPointF) pos) const;
    final QString imageAt(ref const(QPointF) pos) const;
    final QTextFormat formatAt(ref const(QPointF) pos) const;
//    final QTextBlock blockWithMarkerAt(ref const(QPointF) pos) const;

    /+ virtual +/ abstract int pageCount() const;
    /+ virtual +/ abstract QSizeF documentSize() const;

    /+ virtual +/ abstract QRectF frameBoundingRect(QTextFrame frame) const;
    /+ virtual +/ abstract QRectF blockBoundingRect(ref const(QTextBlock) block) const;

    final void setPaintDevice(QPaintDevice device);
    final QPaintDevice paintDevice() const;

    final QTextDocument document() const;

    final void registerHandler(int objectType, QObject component);
    final void unregisterHandler(int objectType, QObject component = null);
    final QTextObjectInterface handlerForObject(int objectType) const;

/+ Q_SIGNALS +/public:
    @QSignal final void update(ref const(QRectF)  /+ = QRectF(0., 0., 1000000000., 1000000000.) +/);
    @QSignal final void updateBlock(ref const(QTextBlock) block);
    @QSignal final void documentSizeChanged(ref const(QSizeF) newSize);
    @QSignal final void pageCountChanged(int newPages);

protected:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QAbstractTextDocumentLayoutPrivate , QTextDocument );
    }));

    /+ virtual +/ abstract void documentChanged(int from, int charsRemoved, int charsAdded);

    /+ virtual +/ void resizeInlineObject(QTextInlineObject item, int posInDocument, ref const(QTextFormat) format);
    /+ virtual +/ void positionInlineObject(QTextInlineObject item, int posInDocument, ref const(QTextFormat) format);
    /+ virtual +/ void drawInlineObject(QPainter* painter, ref const(QRectF) rect, QTextInlineObject object, int posInDocument, ref const(QTextFormat) format);

    final int formatIndex(int pos);
    final QTextCharFormat format(int pos);

private:
    /+ friend class QWidgetTextControl; +/
    /+ friend class QTextDocument; +/
    /+ friend class QTextDocumentPrivate; +/
    /+ friend class QTextEngine; +/
    /+ friend class QTextLayout; +/
    /+ friend class QTextLine; +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_handlerDestroyed(QObject *obj))
    Q_PRIVATE_SLOT(d_func(), int _q_dynamicPageCountSlot())
    Q_PRIVATE_SLOT(d_func(), QSizeF _q_dynamicDocumentSizeSlot()) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QAbstractTextDocumentLayout::Selection,    Q_RELOCATABLE_TYPE);
Q_DECLARE_TYPEINFO(QAbstractTextDocumentLayout::PaintContext, Q_RELOCATABLE_TYPE); +/

/// Binding for C++ class [QTextObjectInterface](https://doc.qt.io/qt-6/qtextobjectinterface.html).
abstract class /+ Q_GUI_EXPORT +/ QTextObjectInterface
{
public:
    /+ virtual +/~this();
    /+ virtual +/ abstract QSizeF intrinsicSize(QTextDocument doc, int posInDocument, ref const(QTextFormat) format);
    /+ virtual +/ abstract void drawObject(QPainter* painter, ref const(QRectF) rect, QTextDocument doc, int posInDocument, ref const(QTextFormat) format);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef Q_CLANG_QDOC
Q_DECLARE_INTERFACE(QTextObjectInterface, "org.qt-project.Qt.QTextObjectInterface")
#endif +/

