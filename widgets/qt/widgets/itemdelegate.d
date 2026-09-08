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
module qt.widgets.itemdelegate;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.object;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.variant;
import qt.gui.font;
import qt.gui.painter;
import qt.gui.palette;
import qt.gui.pixmap;
import qt.helpers;
import qt.widgets.abstractitemdelegate;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(itemviews); +/


extern(C++, class) struct QItemDelegatePrivate;
extern(C++, class) struct QItemEditorFactory;

/// Binding for C++ class [QItemDelegate](https://doc.qt.io/qt-5/qitemdelegate.html).
class /+ Q_WIDGETS_EXPORT +/ QItemDelegate : QAbstractItemDelegate
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool clipping READ hasClipping WRITE setClipping) +/

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    final bool hasClipping() const;
    final void setClipping(bool clip);

    // painting
    override void paint(QPainter* painter,
                   ref const(QStyleOptionViewItem) option,
                   ref const(QModelIndex) index) const;
    override QSize sizeHint(ref const(QStyleOptionViewItem) option,
                       ref const(QModelIndex) index) const;

    // editing
    override QWidget createEditor(QWidget parent,
                              ref const(QStyleOptionViewItem) option,
                              ref const(QModelIndex) index) const;

    override void setEditorData(QWidget editor, ref const(QModelIndex) index) const;
    override void setModelData(QWidget editor, QAbstractItemModel model, ref const(QModelIndex) index) const;

    override void updateEditorGeometry(QWidget editor,
                                  ref const(QStyleOptionViewItem) option,
                                  ref const(QModelIndex) index) const;

    // editor factory
    /+ QItemEditorFactory *itemEditorFactory() const; +/
    /+ void setItemEditorFactory(QItemEditorFactory *factory); +/

protected:
    /+ virtual +/ void drawDisplay(QPainter* painter, ref const(QStyleOptionViewItem) option,
                                 ref const(QRect) rect, ref const(QString) text) const;
    /+ virtual +/ void drawDecoration(QPainter* painter, ref const(QStyleOptionViewItem) option,
                                    ref const(QRect) rect, ref const(QPixmap) pixmap) const;
    /+ virtual +/ void drawFocus(QPainter* painter, ref const(QStyleOptionViewItem) option,
                               ref const(QRect) rect) const;
    /+ virtual +/ void drawCheck(QPainter* painter, ref const(QStyleOptionViewItem) option,
                               ref const(QRect) rect, /+ Qt:: +/qt.core.namespace.CheckState state) const;
    final void drawBackground(QPainter* painter, ref const(QStyleOptionViewItem) option,
                            ref const(QModelIndex) index) const;

    final void doLayout(ref const(QStyleOptionViewItem) option,
                      QRect* checkRect, QRect* iconRect, QRect* textRect, bool hint) const;

    final QRect rect(ref const(QStyleOptionViewItem) option, ref const(QModelIndex) index, int role) const;

    override bool eventFilter(QObject object, QEvent event);
    override bool editorEvent(QEvent event, QAbstractItemModel model,
                         ref const(QStyleOptionViewItem) option, ref const(QModelIndex) index);

    final QStyleOptionViewItem setOptions(ref const(QModelIndex) index,
                                        ref const(QStyleOptionViewItem) option) const;

    final QPixmap decoration(ref const(QStyleOptionViewItem) option, ref const(QVariant) variant) const;

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use selectedPixmap() instead") +/
        final QPixmap* selected(ref const(QPixmap) pixmap, ref const(QPalette) palette, bool enabled) const;
/+ #endif +/
    static QPixmap selectedPixmap(ref const(QPixmap) pixmap, ref const(QPalette) palette, bool enabled);

    final QRect doCheck(ref const(QStyleOptionViewItem) option, ref const(QRect) bounding,
                    ref const(QVariant) variant) const;
    final QRect textRectangle(QPainter* painter, ref const(QRect) rect,
                            ref const(QFont) font, ref const(QString) text) const;

private:
    /+ Q_DECLARE_PRIVATE(QItemDelegate) +/
    /+ Q_DISABLE_COPY(QItemDelegate) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

