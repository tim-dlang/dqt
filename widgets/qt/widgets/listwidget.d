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
module qt.widgets.listwidget;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.coreevent;
import qt.core.itemselectionmodel;
import qt.core.list;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.stringlist;
import qt.core.variant;
import qt.core.vector;
import qt.gui.brush;
import qt.gui.color;
import qt.gui.event;
import qt.gui.font;
import qt.gui.icon;
import qt.helpers;
import qt.widgets.abstractitemview;
import qt.widgets.listview;
import qt.widgets.widget;
version(QT_NO_DATASTREAM){}else
    import qt.core.datastream;

/+ QT_REQUIRE_CONFIG(listwidget);


class QListWidget; +/
extern(C++, class) struct QListModel;
extern(C++, class) struct QListWidgetItemPrivate;

class /+ Q_WIDGETS_EXPORT +/ QListWidgetItem
{
private:
    /+ friend class QListModel; +/
    /+ friend class QListWidget; +/
public:
    enum ItemType { Type = 0, UserType = 1000 }
    /+ explicit +/this(QListWidget listview = null, int type = ItemType.Type);
    /+ explicit +/this(ref const(QString) text, QListWidget listview = null, int type = ItemType.Type);
    /+ explicit +/this(ref const(QIcon) icon, ref const(QString) text,
                                 QListWidget listview = null, int type = ItemType.Type);
    /+ QListWidgetItem(const QListWidgetItem &other); +/
    /+ virtual +/~this();

    /+ virtual +/ QListWidgetItem clone() const;

    pragma(inline, true) final QListWidget listWidget() const { return cast(QListWidget)view; }

    final void setSelected(bool select);
    final bool isSelected() const;

    pragma(inline, true) final void setHidden(bool ahide)
    { if (view) view.setRowHidden(view.row(this), ahide); }
    pragma(inline, true) final bool isHidden() const
    { return (view ? view.isRowHidden(view.row(this)) : false); }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.ItemFlags flags() const { return itemFlags; }
    final void setFlags(/+ Qt:: +/qt.core.namespace.ItemFlags flags);

    pragma(inline, true) final QString text() const
        { return data(/+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole).toString(); }
    pragma(inline, true) final void setText(ref const(QString) atext)
    { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole, atext); }

/+    pragma(inline, true) final QIcon icon() const
        { return qvariant_cast!(QIcon)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.DecorationRole)); }
    pragma(inline, true) final void setIcon(ref const(QIcon) aicon)
    { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.DecorationRole, aicon); }+/

    pragma(inline, true) final QString statusTip() const
        { return data(/+ Qt:: +/qt.core.namespace.ItemDataRole.StatusTipRole).toString(); }
    pragma(inline, true) final void setStatusTip(ref const(QString) astatusTip)
    { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.StatusTipRole, astatusTip); }

/+ #ifndef QT_NO_TOOLTIP +/
    version(QT_NO_TOOLTIP){}else
    {
        pragma(inline, true) final QString toolTip() const
            { return data(/+ Qt:: +/qt.core.namespace.ItemDataRole.ToolTipRole).toString(); }
        pragma(inline, true) final void setToolTip(ref const(QString) atoolTip)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.ToolTipRole, atoolTip); }
    }
/+ #endif

#if QT_CONFIG(whatsthis) +/
    pragma(inline, true) final QString whatsThis() const
        { return data(/+ Qt:: +/qt.core.namespace.ItemDataRole.WhatsThisRole).toString(); }
    pragma(inline, true) final void setWhatsThis(ref const(QString) awhatsThis)
    { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.WhatsThisRole, awhatsThis); }
/+ #endif +/

    pragma(inline, true) final QFont font() const
        { return qvariant_cast!(QFont)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.FontRole)); }
    pragma(inline, true) final void setFont(ref const(QFont) afont)
    { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.FontRole, afont); }

    pragma(inline, true) final int textAlignment() const
        { return data(/+ Qt:: +/qt.core.namespace.ItemDataRole.TextAlignmentRole).toInt(); }
    pragma(inline, true) final void setTextAlignment(int alignment)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.TextAlignmentRole, alignment); }

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X ("Use QListWidgetItem::background() instead") +/
        pragma(inline, true) final QColor backgroundColor() const
        { return qvariant_cast!(QColor)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole)); }
/+ #endif +/
    // no QT_DEPRECATED_SINCE because it is a virtual function
    /+ QT_DEPRECATED_X ("Use QListWidgetItem::setBackground() instead") +/
        /+ virtual +/ void setBackgroundColor(ref const(QColor) color)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole, QVariant.fromValue(color)); }

    pragma(inline, true) final QBrush background() const
        { return qvariant_cast!(QBrush)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole)); }
    pragma(inline, true) final void setBackground(ref const(QBrush) brush)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole, brush.style() != /+ Qt:: +/qt.core.namespace.BrushStyle.NoBrush ? QVariant.fromValue(brush) : QVariant()); }

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X ("Use QListWidgetItem::foreground() instead") +/
        pragma(inline, true) final QColor textColor() const
        { return qvariant_cast!(QColor)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole)); }
    /+ QT_DEPRECATED_X ("Use QListWidgetItem::setForeground() instead") +/
        pragma(inline, true) final void setTextColor(ref const(QColor) color)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole, color); }
/+ #endif +/

    pragma(inline, true) final QBrush foreground() const
        { return qvariant_cast!(QBrush)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole)); }
    pragma(inline, true) final void setForeground(ref const(QBrush) brush)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole, brush.style() != /+ Qt:: +/qt.core.namespace.BrushStyle.NoBrush ? QVariant.fromValue(brush) : QVariant()); }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.CheckState checkState() const
        { return static_cast!(/+ Qt:: +/qt.core.namespace.CheckState)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.CheckStateRole).toInt()); }
    pragma(inline, true) final void setCheckState(/+ Qt:: +/qt.core.namespace.CheckState state)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.CheckStateRole, static_cast!(int)(state)); }

    pragma(inline, true) final QSize sizeHint() const
        { return qvariant_cast!(QSize)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.SizeHintRole)); }
    pragma(inline, true) final void setSizeHint(ref const(QSize) size)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.SizeHintRole, size.isValid() ? QVariant.fromValue(size) : QVariant()); }

    /+ virtual +/ QVariant data(int role) const;
    /+ virtual +/ void setData(int role, ref const(QVariant) value);
    final void setData(T)(int role, T value)
    {
        static if(is(const(T) == const(QVariant)))
            QVariant v = value;
        else
            QVariant v = QVariant.fromValue(value);
        setData(role, v);
    }

    pragma(mangle, mangleOpLess("QListWidgetItem"))
    bool opLess(const QListWidgetItem other) const;

    version(QT_NO_DATASTREAM){}else
    {
        /+ virtual +/ void read(ref QDataStream in_);
        /+ virtual +/ void write(ref QDataStream out_) const;
    }
    /+ QListWidgetItem &operator=(const QListWidgetItem &other); +/

    pragma(inline, true) final int type() const { return rtti; }

private:
    final QListModel* listModel() const;
    int rtti;
    QVector!(void*) dummy;
    QListWidget view;
    QListWidgetItemPrivate* d;
    /+ Qt:: +/qt.core.namespace.ItemFlags itemFlags;
}

/+ #ifndef QT_NO_TOOLTIP
#endif

#if QT_CONFIG(whatsthis)
#endif

#ifndef QT_NO_DATASTREAM
Q_WIDGETS_EXPORT QDataStream &operator<<(QDataStream &out, const QListWidgetItem &item);
Q_WIDGETS_EXPORT QDataStream &operator>>(QDataStream &in, QListWidgetItem &item);
#endif +/

extern(C++, class) struct QListWidgetPrivate;

class /+ Q_WIDGETS_EXPORT +/ QListWidget : QListView
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(int count READ count)
    Q_PROPERTY(int currentRow READ currentRow WRITE setCurrentRow NOTIFY currentRowChanged USER true)
    Q_PROPERTY(bool sortingEnabled READ isSortingEnabled WRITE setSortingEnabled) +/

    /+ friend class QListWidgetItem; +/
    /+ friend class QListModel; +/
public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    override void setSelectionModel(QItemSelectionModel selectionModel);

    final QListWidgetItem item(int row) const;
    mixin(mangleWindows("?row@QListWidget@@QEBAHPEBVQListWidgetItem@@@Z", q{
    final int row(const(QListWidgetItem) item) const;
    }));
    final void insertItem(int row, QListWidgetItem item);
    final void insertItem(int row, ref const(QString) label);
    final void insertItems(int row, ref const(QStringList) labels);
    pragma(inline, true) final void addItem(ref const(QString) label) { insertItem(count(), label); }
    pragma(inline, true) final void addItem(QListWidgetItem aitem)
    { insertItem(count(), aitem); }
    final void addItem(const(QString) label) { addItem(label); }
    pragma(inline, true) final void addItems(ref const(QStringList) labels) { insertItems(count(), labels); }
    final QListWidgetItem takeItem(int row);
    final int count() const;

    final QListWidgetItem currentItem() const;
    final void setCurrentItem(QListWidgetItem item);
    final void setCurrentItem(QListWidgetItem item, QItemSelectionModel.SelectionFlags command);

    final int currentRow() const;
    final void setCurrentRow(int row);
    final void setCurrentRow(int row, QItemSelectionModel.SelectionFlags command);

    final QListWidgetItem itemAt(ref const(QPoint) p) const;
    pragma(inline, true) final QListWidgetItem itemAt(int ax, int ay) const
    { auto tmp = QPoint(ax, ay); return itemAt(tmp); }
    final QRect visualItemRect(const(QListWidgetItem) item) const;

    final void sortItems(/+ Qt:: +/qt.core.namespace.SortOrder order = /+ Qt:: +/qt.core.namespace.SortOrder.AscendingOrder);
    final void setSortingEnabled(bool enable);
    final bool isSortingEnabled() const;

    final void editItem(QListWidgetItem item);
    final void openPersistentEditor(QListWidgetItem item);
    final void closePersistentEditor(QListWidgetItem item);
    /+ using QAbstractItemView::isPersistentEditorOpen; +/
    final bool isPersistentEditorOpen(QListWidgetItem item) const;

    final QWidget itemWidget(QListWidgetItem item) const;
    final void setItemWidget(QListWidgetItem item, QWidget widget);
    pragma(inline, true) final void removeItemWidget(QListWidgetItem aItem)
    { setItemWidget(aItem, null); }

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X ("Use QListWidgetItem::isSelected() instead") +/
        final bool isItemSelected(const(QListWidgetItem) item) const;
    /+ QT_DEPRECATED_X ("Use QListWidgetItem::setSelected() instead") +/
        final void setItemSelected(const(QListWidgetItem) item, bool select);
/+ #endif +/
    final QList!(QListWidgetItem) selectedItems() const;
    final QList!(QListWidgetItem) findItems(ref const(QString) text, /+ Qt:: +/qt.core.namespace.MatchFlags flags) const;

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X ("Use QListWidgetItem::isHidden() instead") +/
        final bool isItemHidden(const(QListWidgetItem) item) const;
    /+ QT_DEPRECATED_X ("Use QListWidgetItem::setHidden() instead") +/
        final void setItemHidden(const(QListWidgetItem) item, bool hide);
/+ #endif
#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
protected:
#endif
#if QT_CONFIG(draganddrop) +/
    override void dropEvent(QDropEvent event);
/+ #endif +/
public /+ Q_SLOTS +/:
    @QSlot final void scrollToItem(const(QListWidgetItem) item, QAbstractItemView.ScrollHint hint = ScrollHint.EnsureVisible);
    @QSlot final void clear();

/+ Q_SIGNALS +/public:
    @QSignal final void itemPressed(QListWidgetItem item);
    @QSignal final void itemClicked(QListWidgetItem item);
    @QSignal final void itemDoubleClicked(QListWidgetItem item);
    @QSignal final void itemActivated(QListWidgetItem item);
    @QSignal final void itemEntered(QListWidgetItem item);
    // ### Qt 6: add changed roles
    @QSignal final void itemChanged(QListWidgetItem item);

    @QSignal final void currentItemChanged(QListWidgetItem current, QListWidgetItem previous);
    @QSignal final void currentTextChanged(ref const(QString) currentText);
    @QSignal final void currentRowChanged(int currentRow);

    @QSignal final void itemSelectionChanged();

protected:
    override bool event(QEvent e);
    /+ virtual +/ QStringList mimeTypes() const;
/+ #if QT_VERSION >= QT_VERSION_CHECK(6,0,0)
    virtual QMimeData *mimeData(const QList<QListWidgetItem *> &items) const;
#else +/
    /+ virtual +/ QMimeData mimeData(const(QList!(QListWidgetItem)) items) const;
/+ #endif
#if QT_CONFIG(draganddrop) +/
    mixin(mangleWindows("?dropMimeData@QListWidget@@MEAA_NHPEBVQMimeData@@W4DropAction@Qt@@@Z", q{
    /+ virtual +/ bool dropMimeData(int index, const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action);
    }));
    /+ virtual +/ /+ Qt:: +/qt.core.namespace.DropActions supportedDropActions() const;
/+ #endif

#if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
public:
#else +/
protected:
/+ #endif +/
    final QList!(QListWidgetItem) items(const(QMimeData) data) const;

    final QModelIndex indexFromItem(const(QListWidgetItem) item) const;
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    final QModelIndex indexFromItem(QListWidgetItem item) const; // ### Qt 6: remove
/+ #endif +/
    final QListWidgetItem itemFromIndex(ref const(QModelIndex) index) const;

private:
    mixin(mangleWindows("?setModel@QListWidget@@EEAAXPEAVQAbstractItemModel@@@Z", q{
    protected override void setModel(QAbstractItemModel model);
    }));
    final /+ Qt:: +/qt.core.namespace.SortOrder sortOrder() const;

    /+ Q_DECLARE_PRIVATE(QListWidget) +/
    /+ Q_DISABLE_COPY(QListWidget) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_emitItemPressed(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemClicked(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemDoubleClicked(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemActivated(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemEntered(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemChanged(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitCurrentItemChanged(const QModelIndex &previous, const QModelIndex &current))
    Q_PRIVATE_SLOT(d_func(), void _q_sort())
    Q_PRIVATE_SLOT(d_func(), void _q_dataChanged(const QModelIndex &topLeft, const QModelIndex &bottomRight)) +/
}

