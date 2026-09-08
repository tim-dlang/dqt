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
module qt.widgets.styleditemdelegate;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.coreevent;
import qt.core.locale;
import qt.core.object;
import qt.core.size;
import qt.core.string;
import qt.core.variant;
import qt.gui.painter;
import qt.helpers;
import qt.widgets.abstractitemdelegate;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(itemviews); +/


extern(C++, class) struct QStyledItemDelegatePrivate;

/// Binding for C++ class [QStyledItemDelegate](https://doc.qt.io/qt-5/qstyleditemdelegate.html).
class /+ Q_WIDGETS_EXPORT +/ QStyledItemDelegate : QAbstractItemDelegate
{
    mixin(Q_OBJECT);

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    // painting
    override void paint(QPainter* painter,
                   ref const(QStyleOptionViewItem) option, ref const(QModelIndex) index) const;
    override QSize sizeHint(ref const(QStyleOptionViewItem) option,
                       ref const(QModelIndex) index) const;

    // editing
    override QWidget createEditor(QWidget parent,
                              ref const(QStyleOptionViewItem) option,
                              ref const(QModelIndex) index) const;

    override void setEditorData(QWidget editor, ref const(QModelIndex) index) const;
    override void setModelData(QWidget editor,
                          QAbstractItemModel model,
                          ref const(QModelIndex) index) const;

    override void updateEditorGeometry(QWidget editor,
                                  ref const(QStyleOptionViewItem) option,
                                  ref const(QModelIndex) index) const;

    // editor factory
    /+ QItemEditorFactory *itemEditorFactory() const; +/
    /+ void setItemEditorFactory(QItemEditorFactory *factory); +/

    /+ virtual +/ QString displayText(ref const(QVariant) value, ref const(QLocale) locale) const;

protected:
    /+ virtual +/ void initStyleOption(QStyleOptionViewItem* option,
                                    ref const(QModelIndex) index) const;

    override bool eventFilter(QObject object, QEvent event);
    override bool editorEvent(QEvent event, QAbstractItemModel model,
                         ref const(QStyleOptionViewItem) option, ref const(QModelIndex) index);

private:
    /+ Q_DECLARE_PRIVATE(QStyledItemDelegate) +/
    /+ Q_DISABLE_COPY(QStyledItemDelegate) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

