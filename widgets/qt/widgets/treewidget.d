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
module qt.widgets.treewidget;
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
import qt.widgets.treeview;
import qt.widgets.treewidgetitemiterator;
import qt.widgets.widget;
import qt.widgets.widgetitemdata;
version (QT_NO_DATASTREAM) {} else
    import qt.core.datastream;

/+ QT_REQUIRE_CONFIG(treewidget); +/


extern(C++, class) struct QTreeWidgetItemPrivate;

/// Binding for C++ class [QTreeWidgetItem](https://doc.qt.io/qt-5/qtreewidgetitem.html).
class /+ Q_WIDGETS_EXPORT +/ QTreeWidgetItem
{
private:
    /+ friend class QTreeModel; +/
    /+ friend class QTreeWidget; +/
    /+ friend class QTreeWidgetPrivate; +/
    /+ friend class QTreeWidgetItemIterator; +/
    /+ friend class QTreeWidgetItemPrivate; +/
public:
    enum ItemType { Type = 0, UserType = 1000 }
    /+ explicit +/this(int type = ItemType.Type);
    /+ explicit +/this(ref const(QStringList) strings, int type = ItemType.Type);
    /+ explicit +/this(QTreeWidget treeview, int type = ItemType.Type);
    this(QTreeWidget treeview, ref const(QStringList) strings, int type = ItemType.Type);
    this(QTreeWidget treeview, QTreeWidgetItem after, int type = ItemType.Type);
    /+ explicit +/this(QTreeWidgetItem parent, int type = ItemType.Type);
    this(QTreeWidgetItem parent, ref const(QStringList) strings, int type = ItemType.Type);
    this(QTreeWidgetItem parent, QTreeWidgetItem after, int type = ItemType.Type);
    /+ QTreeWidgetItem(const QTreeWidgetItem &other); +/
    /+ virtual +/~this();

    /+ virtual +/ QTreeWidgetItem clone() const;

    pragma(inline, true) final QTreeWidget treeWidget() const { return cast(QTreeWidget)view; }

    final void setSelected(bool select);
    final bool isSelected() const;

    final void setHidden(bool hide);
    final bool isHidden() const;

    final void setExpanded(bool expand);
    final bool isExpanded() const;

    final void setFirstColumnSpanned(bool span);
    final bool isFirstColumnSpanned() const;

    pragma(inline, true) final void setDisabled(bool disabled)
    { setFlags(disabled ? (flags() & ~/+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsEnabled) : flags() | /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsEnabled); }
    pragma(inline, true) final bool isDisabled() const
    { return !(flags() & /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsEnabled); }

    enum ChildIndicatorPolicy { ShowIndicator, DontShowIndicator, DontShowIndicatorWhenChildless }
    final void setChildIndicatorPolicy(ChildIndicatorPolicy policy);
    final ChildIndicatorPolicy childIndicatorPolicy() const;

    final /+ Qt:: +/qt.core.namespace.ItemFlags flags() const;
    final void setFlags(/+ Qt:: +/qt.core.namespace.ItemFlags flags);

    pragma(inline, true) final QString text(int column) const
        { return data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole).toString(); }
    pragma(inline, true) final void setText(int column, ref const(QString) atext)
    { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole, atext); }

    pragma(inline, true) final QIcon icon(int column) const
        { return qvariant_cast!(QIcon)(data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.DecorationRole)); }
    pragma(inline, true) final void setIcon(int column, ref const(QIcon) aicon)
    { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.DecorationRole, aicon); }

    pragma(inline, true) final QString statusTip(int column) const
        { return data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.StatusTipRole).toString(); }
    pragma(inline, true) final void setStatusTip(int column, ref const(QString) astatusTip)
    { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.StatusTipRole, astatusTip); }

/+ #ifndef QT_NO_TOOLTIP +/
    version (QT_NO_TOOLTIP) {} else
    {
        pragma(inline, true) final QString toolTip(int column) const
            { return data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.ToolTipRole).toString(); }
        pragma(inline, true) final void setToolTip(int column, ref const(QString) atoolTip)
        { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.ToolTipRole, atoolTip); }
    }
/+ #endif

#if QT_CONFIG(whatsthis) +/
    pragma(inline, true) final QString whatsThis(int column) const
        { return data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.WhatsThisRole).toString(); }
    pragma(inline, true) final void setWhatsThis(int column, ref const(QString) awhatsThis)
    { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.WhatsThisRole, awhatsThis); }
/+ #endif +/

    pragma(inline, true) final QFont font(int column) const
        { return qvariant_cast!(QFont)(data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.FontRole)); }
    pragma(inline, true) final void setFont(int column, ref const(QFont) afont)
    { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.FontRole, afont); }

    pragma(inline, true) final int textAlignment(int column) const
        { return data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.TextAlignmentRole).toInt(); }
    pragma(inline, true) final void setTextAlignment(int column, int alignment)
        { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.TextAlignmentRole, alignment); }

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X ("Use QTreeWidgetItem::background() instead") +/
        pragma(inline, true) final QColor backgroundColor(int column) const
        { return qvariant_cast!(QColor)(data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole)); }
    /+ QT_DEPRECATED_X ("Use QTreeWidgetItem::setBackground() instead") +/
        pragma(inline, true) final void setBackgroundColor(int column, ref const(QColor) color)
        { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole, color); }
/+ #endif +/

    pragma(inline, true) final QBrush background(int column) const
        { return qvariant_cast!(QBrush)(data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole)); }
    pragma(inline, true) final void setBackground(int column, ref const(QBrush) brush)
        { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole, brush.style() != /+ Qt:: +/qt.core.namespace.BrushStyle.NoBrush ? QVariant.fromValue(brush) : QVariant()); }
    pragma(inline, true) final void setBackground(int column, const(QColor) color)
        { setBackground(column, QBrush(color)); }

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X ("Use QTreeWidgetItem::foreground() instead") +/
        pragma(inline, true) final QColor textColor(int column) const
        { return qvariant_cast!(QColor)(data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole)); }
    /+ QT_DEPRECATED_X ("Use QTreeWidgetItem::setForeground() instead") +/
        pragma(inline, true) final void setTextColor(int column, ref const(QColor) color)
        { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole, color); }
/+ #endif +/

    pragma(inline, true) final QBrush foreground(int column) const
        { return qvariant_cast!(QBrush)(data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole)); }
    pragma(inline, true) final void setForeground(int column, ref const(QBrush) brush)
        { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole, brush.style() != /+ Qt:: +/qt.core.namespace.BrushStyle.NoBrush ? QVariant.fromValue(brush) : QVariant()); }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.CheckState checkState(int column) const
        { return static_cast!(/+ Qt:: +/qt.core.namespace.CheckState)(data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.CheckStateRole).toInt()); }
    pragma(inline, true) final void setCheckState(int column, /+ Qt:: +/qt.core.namespace.CheckState state)
        { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.CheckStateRole, cast(int)state); }

    pragma(inline, true) final QSize sizeHint(int column) const
        { return qvariant_cast!(QSize)(data(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.SizeHintRole)); }
    pragma(inline, true) final void setSizeHint(int column, ref const(QSize) size)
        { setData(column, /+ Qt:: +/qt.core.namespace.ItemDataRole.SizeHintRole, size.isValid() ? QVariant(size) : QVariant()); }

    /+ virtual +/ QVariant data(int column, int role) const;
    /+ virtual +/ void setData(int column, int role, ref const(QVariant) value);
    final void setData(T)(int column, int role, T value)
    {
        static if (is(const(T) == const(QVariant)))
            QVariant v = value;
        else
            QVariant v = QVariant.fromValue(value);
        setData(column, role, v);
    }

    pragma(mangle, mangleOpLess("QTreeWidgetItem"))
    bool opLess(const(QTreeWidgetItem) other) const;

    version (QT_NO_DATASTREAM) {} else
    {
        /+ virtual +/ void read(ref QDataStream in_);
        /+ virtual +/ void write(ref QDataStream out_) const;
    }
    /+ QTreeWidgetItem &operator=(const QTreeWidgetItem &other); +/

    pragma(inline, true) final QTreeWidgetItem parent() const { return cast(QTreeWidgetItem)par; }
    pragma(inline, true) final QTreeWidgetItem child(int index) const {
        if (index < 0 || index >= children.size())
            return null;
        executePendingSort();
        return cast(QTreeWidgetItem)children.at(index);
    }
    pragma(inline, true) final int childCount() const { return children.count(); }
    pragma(inline, true) final int columnCount() const { return values.count(); }
    pragma(inline, true) final int indexOfChild(QTreeWidgetItem achild) const
    { executePendingSort(); return children.indexOf(achild); }

    final void addChild(QTreeWidgetItem child);
    final void insertChild(int index, QTreeWidgetItem child);
    final void removeChild(QTreeWidgetItem child);
    final QTreeWidgetItem takeChild(int index);

    final void addChildren(ref const(QList!(QTreeWidgetItem)) children);
    final void insertChildren(int index, ref const(QList!(QTreeWidgetItem)) children);
    final QList!(QTreeWidgetItem) takeChildren();

    pragma(inline, true) final int type() const { return rtti; }
    pragma(inline, true) final void sortChildren(int column, /+ Qt:: +/qt.core.namespace.SortOrder order)
        { sortChildren(column, order, false); }

protected:
    final void emitDataChanged();

private:
    final void sortChildren(int column, /+ Qt:: +/qt.core.namespace.SortOrder order, bool climb);
    final QVariant childrenCheckState(int column) const;
    final void itemChanged();
    final void executePendingSort() const;
    final QTreeModel* treeModel(QTreeWidget v = null) const;

    int rtti;
    // One item has a vector of column entries. Each column has a vector of (role, value) pairs.
     QVector!( QVector!(QWidgetItemData)) values;
    QTreeWidget view;
    QTreeWidgetItemPrivate* d;
    QTreeWidgetItem par;
    QList!(QTreeWidgetItem) children;
    /+ Qt:: +/qt.core.namespace.ItemFlags itemFlags;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #if QT_CONFIG(statustip)
#endif

#ifndef QT_NO_TOOLTIP
#endif

#if QT_CONFIG(whatsthis)
#endif

#ifndef QT_NO_DATASTREAM
Q_WIDGETS_EXPORT QDataStream &operator<<(QDataStream &out, const QTreeWidgetItem &item);
Q_WIDGETS_EXPORT QDataStream &operator>>(QDataStream &in, QTreeWidgetItem &item);
#endif +/

extern(C++, class) struct QTreeWidgetPrivate;

/// Binding for C++ class [QTreeWidget](https://doc.qt.io/qt-5/qtreewidget.html).
class /+ Q_WIDGETS_EXPORT +/ QTreeWidget : QTreeView
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(int columnCount READ columnCount WRITE setColumnCount)
    Q_PROPERTY(int topLevelItemCount READ topLevelItemCount) +/

    /+ friend class QTreeModel; +/
    /+ friend class QTreeWidgetItem; +/
public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    final int columnCount() const;
    final void setColumnCount(int columns);

    final QTreeWidgetItem invisibleRootItem() const;
    final QTreeWidgetItem topLevelItem(int index) const;
    final int topLevelItemCount() const;
    final void insertTopLevelItem(int index, QTreeWidgetItem item);
    final void addTopLevelItem(QTreeWidgetItem item);
    final QTreeWidgetItem takeTopLevelItem(int index);
    final int indexOfTopLevelItem(QTreeWidgetItem item) const;

    final void insertTopLevelItems(int index, ref const(QList!(QTreeWidgetItem)) items);
    final void addTopLevelItems(ref const(QList!(QTreeWidgetItem)) items);

    final QTreeWidgetItem headerItem() const;
    final void setHeaderItem(QTreeWidgetItem item);
    final void setHeaderLabels(ref const(QStringList) labels);
/+    pragma(inline, true) final void setHeaderLabel(ref const(QString) alabel)
    { auto tmp = QStringList(alabel); setHeaderLabels(tmp); }+/

    final QTreeWidgetItem currentItem() const;
    final int currentColumn() const;
    final void setCurrentItem(QTreeWidgetItem item);
    final void setCurrentItem(QTreeWidgetItem item, int column);
    final void setCurrentItem(QTreeWidgetItem item, int column, QItemSelectionModel.SelectionFlags command);

    final QTreeWidgetItem itemAt(ref const(QPoint) p) const;
    pragma(inline, true) final QTreeWidgetItem itemAt(int ax, int ay) const
    { auto tmp = QPoint(ax, ay); return itemAt(tmp); }
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QRect visualItemRect(const(QTreeWidgetItem) item) const;
    }));

    final int sortColumn() const;
    final void sortItems(int column, /+ Qt:: +/qt.core.namespace.SortOrder order);

    final void editItem(QTreeWidgetItem item, int column = 0);
    final void openPersistentEditor(QTreeWidgetItem item, int column = 0);
    final void closePersistentEditor(QTreeWidgetItem item, int column = 0);
    /+ using QAbstractItemView::isPersistentEditorOpen; +/
    final bool isPersistentEditorOpen(QTreeWidgetItem item, int column = 0) const;

    final QWidget itemWidget(QTreeWidgetItem item, int column) const;
    final void setItemWidget(QTreeWidgetItem item, int column, QWidget widget);
    pragma(inline, true) final void removeItemWidget(QTreeWidgetItem item, int column)
    { setItemWidget(item, column, null); }

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_X ("Use QTreeWidgetItem::isSelected() instead") +/
        final bool isItemSelected(const(QTreeWidgetItem) item) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_X ("Use QTreeWidgetItem::setSelected() instead") +/
        final void setItemSelected(const(QTreeWidgetItem) item, bool select);
    }));
/+ #endif +/
    final QList!(QTreeWidgetItem) selectedItems() const;
    final QList!(QTreeWidgetItem) findItems(ref const(QString) text, /+ Qt:: +/qt.core.namespace.MatchFlags flags,
                                          int column = 0) const;

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_X ("Use QTreeWidgetItem::isHidden() instead") +/
        final bool isItemHidden(const(QTreeWidgetItem) item) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_X ("Use QTreeWidgetItem::setHidden() instead") +/
        final void setItemHidden(const(QTreeWidgetItem) item, bool hide);
    }));

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_X ("Use QTreeWidgetItem::isExpanded() instead") +/
        final bool isItemExpanded(const(QTreeWidgetItem) item) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_X ("Use QTreeWidgetItem::setExpanded() instead") +/
        final void setItemExpanded(const(QTreeWidgetItem) item, bool expand);
    }));

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_X ("Use QTreeWidgetItem::isFirstColumnSpanned() instead") +/
        final bool isFirstItemColumnSpanned(const(QTreeWidgetItem) item) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_X ("Use QTreeWidgetItem::setFirstColumnSpanned() instead") +/
        final void setFirstItemColumnSpanned(const(QTreeWidgetItem) item, bool span);
    }));
/+ #endif +/

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QTreeWidgetItem itemAbove(const(QTreeWidgetItem) item) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QTreeWidgetItem itemBelow(const(QTreeWidgetItem) item) const;
    }));

    override void setSelectionModel(QItemSelectionModel selectionModel);

public /+ Q_SLOTS +/:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    @QSlot final void scrollToItem(const(QTreeWidgetItem) item,
                          QAbstractItemView.ScrollHint hint = ScrollHint.EnsureVisible);
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    @QSlot final void expandItem(const(QTreeWidgetItem) item);
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    @QSlot final void collapseItem(const(QTreeWidgetItem) item);
    }));
    @QSlot final void clear();

/+ Q_SIGNALS +/public:
    @QSignal final void itemPressed(QTreeWidgetItem item, int column);
    @QSignal final void itemClicked(QTreeWidgetItem item, int column);
    @QSignal final void itemDoubleClicked(QTreeWidgetItem item, int column);
    @QSignal final void itemActivated(QTreeWidgetItem item, int column);
    @QSignal final void itemEntered(QTreeWidgetItem item, int column);
    // ### Qt 6: add changed roles
    @QSignal final void itemChanged(QTreeWidgetItem item, int column);
    @QSignal final void itemExpanded(QTreeWidgetItem item);
    @QSignal final void itemCollapsed(QTreeWidgetItem item);
    @QSignal final void currentItemChanged(QTreeWidgetItem current, QTreeWidgetItem previous);
    @QSignal final void itemSelectionChanged();

protected:
    override bool event(QEvent e);
    /+ virtual +/ QStringList mimeTypes() const;
/+ #if QT_VERSION >= QT_VERSION_CHECK(6,0,0)
    virtual QMimeData *mimeData(const QList<QTreeWidgetItem *> &items) const;
#else +/
    /+ virtual +/ QMimeData mimeData(const(QList!(QTreeWidgetItem)) items) const;
/+ #endif +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ virtual +/ bool dropMimeData(QTreeWidgetItem parent, int index,
                                  const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action);
    }));
    /+ virtual +/ /+ Qt:: +/qt.core.namespace.DropActions supportedDropActions() const;

/+ #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
public:
#else +/
protected:
/+ #endif +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QList!(QTreeWidgetItem) items(const(QMimeData) data) const;
    }));

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QModelIndex indexFromItem(const(QTreeWidgetItem) item, int column = 0) const;
    }));
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    final QModelIndex indexFromItem(QTreeWidgetItem item, int column = 0) const; // ### Qt 6: remove
/+ #endif +/
    final QTreeWidgetItem itemFromIndex(ref const(QModelIndex) index) const;

protected:
/+ #if QT_CONFIG(draganddrop) +/
    override void dropEvent(QDropEvent event);
/+ #endif +/
private:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    protected override void setModel(QAbstractItemModel model);
    }));

    /+ Q_DECLARE_PRIVATE(QTreeWidget) +/
    /+ Q_DISABLE_COPY(QTreeWidget) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_emitItemPressed(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemClicked(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemDoubleClicked(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemActivated(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemEntered(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemChanged(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemExpanded(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemCollapsed(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitCurrentItemChanged(const QModelIndex &previous, const QModelIndex &current))
    Q_PRIVATE_SLOT(d_func(), void _q_sort())
    Q_PRIVATE_SLOT(d_func(), void _q_dataChanged(const QModelIndex &topLeft, const QModelIndex &bottomRight))
    Q_PRIVATE_SLOT(d_func(), void _q_selectionChanged(const QItemSelection &selected, const QItemSelection &deselected)) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

