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
module qt.widgets.tablewidget;
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
import qt.widgets.tableview;
import qt.widgets.widget;
import qt.widgets.widgetitemdata;
version(QT_NO_DATASTREAM){}else
    import qt.core.datastream;

/+ QT_REQUIRE_CONFIG(tablewidget); +/


// ### Qt6 unexport the class, remove the user-defined special 3 and make it a literal type.
/// Binding for C++ class [QTableWidgetSelectionRange](https://doc.qt.io/qt-5/qtablewidgetselectionrange.html).
extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QTableWidgetSelectionRange
{
public:
    this(int top, int left, int bottom, int right);
    ~this();

    pragma(inline, true) int topRow() const { return top; }
    pragma(inline, true) int bottomRow() const { return bottom; }
    pragma(inline, true) int leftColumn() const { return left; }
    pragma(inline, true) int rightColumn() const { return right; }
    pragma(inline, true) int rowCount() const { return bottom - top + 1; }
    pragma(inline, true) int columnCount() const { return right - left + 1; }

private:
    int top = -1; int left = -1; int bottom = -2; int right = -2;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QTableModel;
extern(C++, class) struct QTableWidgetItemPrivate;

/// Binding for C++ class [QTableWidgetItem](https://doc.qt.io/qt-5/qtablewidgetitem.html).
class /+ Q_WIDGETS_EXPORT +/ QTableWidgetItem
{
private:
    /+ friend class QTableWidget; +/
    /+ friend class QTableModel; +/
public:
    enum ItemType { Type = 0, UserType = 1000 }
    /+ explicit +/this(int type = ItemType.Type);
    /+ explicit +/this(ref const(QString) text, int type = ItemType.Type);
    /+ explicit +/this(ref const(QIcon) icon, ref const(QString) text, int type = ItemType.Type);
    /+ QTableWidgetItem(const QTableWidgetItem &other); +/
    /+ virtual +/~this();

    /+ virtual +/ QTableWidgetItem clone() const;

    pragma(inline, true) final QTableWidget tableWidget() const { return cast(QTableWidget)view; }

    pragma(inline, true) final int row() const
    { return (view ? view.row(this) : -1); }
    pragma(inline, true) final int column() const
    { return (view ? view.column(this) : -1); }

    final void setSelected(bool select);
    final bool isSelected() const;

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.ItemFlags flags() const { return itemFlags; }
    final void setFlags(/+ Qt:: +/qt.core.namespace.ItemFlags flags);

    pragma(inline, true) final QString text() const
        { return data(/+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole).toString(); }
    pragma(inline, true) final void setText(ref const(QString) atext)
    { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole, atext); }

    pragma(inline, true) final QIcon icon() const
        { return qvariant_cast!(QIcon)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.DecorationRole)); }
    pragma(inline, true) final void setIcon(ref const(QIcon) aicon)
    { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.DecorationRole, aicon); }

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
    /+ QT_DEPRECATED_X ("Use QTableWidgetItem::background() instead") +/
        pragma(inline, true) final QColor backgroundColor() const
        { return qvariant_cast!(QColor)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole)); }
    /+ QT_DEPRECATED_X ("Use QTableWidgetItem::setBackground() instead") +/
        pragma(inline, true) final void setBackgroundColor(ref const(QColor) color)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole, color); }
/+ #endif +/

    pragma(inline, true) final QBrush background() const
        { return qvariant_cast!(QBrush)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole)); }
    pragma(inline, true) final void setBackground(ref const(QBrush) brush)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole, brush.style() != /+ Qt:: +/qt.core.namespace.BrushStyle.NoBrush ? QVariant.fromValue(brush) : QVariant()); }

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X ("Use QTableWidgetItem::foreground() instead") +/
        pragma(inline, true) final QColor textColor() const
        { return qvariant_cast!(QColor)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole)); }
    /+ QT_DEPRECATED_X ("Use QTableWidgetItem::setForeground() instead") +/
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
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.CheckStateRole, cast(int)state); }

    pragma(inline, true) final QSize sizeHint() const
        { return qvariant_cast!(QSize)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.SizeHintRole)); }
    pragma(inline, true) final void setSizeHint(ref const(QSize) size)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.SizeHintRole, size.isValid() ? QVariant(size) : QVariant()); }

    /+ virtual +/ QVariant data(int role) const;
    /+ virtual +/ void setData(int role, ref const(QVariant) value);
    final void setData(T)(int role, T value)
    {
        static if (is(const(T) == const(QVariant)))
            QVariant v = value;
        else
            QVariant v = QVariant.fromValue(value);
        setData(role, v);
    }

    pragma(mangle, mangleOpLess("QTableWidgetItem"))
    bool opLess(const QTableWidgetItem other) const;

    version(QT_NO_DATASTREAM){}else
    {
        /+ virtual +/ void read(ref QDataStream in_);
        /+ virtual +/ void write(ref QDataStream out_) const;
    }
    /+ QTableWidgetItem &operator=(const QTableWidgetItem &other); +/

    pragma(inline, true) final int type() const { return rtti; }

private:
    final QTableModel* tableModel() const;

private:
    int rtti;
    QVector!(QWidgetItemData) values;
    QTableWidget view;
    QTableWidgetItemPrivate* d;
    /+ Qt:: +/qt.core.namespace.ItemFlags itemFlags;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef QT_NO_TOOLTIP
#endif

#if QT_CONFIG(whatsthis)
#endif

#ifndef QT_NO_DATASTREAM
Q_WIDGETS_EXPORT QDataStream &operator>>(QDataStream &in, QTableWidgetItem &item);
Q_WIDGETS_EXPORT QDataStream &operator<<(QDataStream &out, const QTableWidgetItem &item);
#endif +/

extern(C++, class) struct QTableWidgetPrivate;

/// Binding for C++ class [QTableWidget](https://doc.qt.io/qt-5/qtablewidget.html).
class /+ Q_WIDGETS_EXPORT +/ QTableWidget : QTableView
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(int rowCount READ rowCount WRITE setRowCount)
    Q_PROPERTY(int columnCount READ columnCount WRITE setColumnCount) +/

    /+ friend class QTableModel; +/
public:
    /+ explicit +/this(QWidget parent = null);
    this(int rows, int columns, QWidget parent = null);
    ~this();

    final void setRowCount(int rows);
    final int rowCount() const;

    final void setColumnCount(int columns);
    final int columnCount() const;

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final int row(const(QTableWidgetItem) item) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final int column(const(QTableWidgetItem) item) const;
    }));

    final QTableWidgetItem item(int row, int column) const;
    final void setItem(int row, int column, QTableWidgetItem item);
    final QTableWidgetItem takeItem(int row, int column);

    final QTableWidgetItem verticalHeaderItem(int row) const;
    final void setVerticalHeaderItem(int row, QTableWidgetItem item);
    final QTableWidgetItem takeVerticalHeaderItem(int row);

    final QTableWidgetItem horizontalHeaderItem(int column) const;
    final void setHorizontalHeaderItem(int column, QTableWidgetItem item);
    final QTableWidgetItem takeHorizontalHeaderItem(int column);
    final void setVerticalHeaderLabels(ref const(QStringList) labels);
    final void setHorizontalHeaderLabels(ref const(QStringList) labels);

    final int currentRow() const;
    final int currentColumn() const;
    final QTableWidgetItem currentItem() const;
    final void setCurrentItem(QTableWidgetItem item);
    final void setCurrentItem(QTableWidgetItem item, QItemSelectionModel.SelectionFlags command);
    final void setCurrentCell(int row, int column);
    final void setCurrentCell(int row, int column, QItemSelectionModel.SelectionFlags command);

    final void sortItems(int column, /+ Qt:: +/qt.core.namespace.SortOrder order = /+ Qt:: +/qt.core.namespace.SortOrder.AscendingOrder);
//    final void setSortingEnabled(bool enable);
//    final bool isSortingEnabled() const;

    final void editItem(QTableWidgetItem item);
    final void openPersistentEditor(QTableWidgetItem item);
    final void closePersistentEditor(QTableWidgetItem item);
    /+ using QAbstractItemView::isPersistentEditorOpen; +/
    final bool isPersistentEditorOpen(QTableWidgetItem item) const;

    final QWidget cellWidget(int row, int column) const;
    final void setCellWidget(int row, int column, QWidget widget);
    pragma(inline, true) final void removeCellWidget(int arow, int acolumn)
    { setCellWidget(arow, acolumn, null); }

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_X ("Use QTableWidgetItem::isSelected() instead") +/
        final bool isItemSelected(const(QTableWidgetItem) item) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ QT_DEPRECATED_X ("Use QTableWidgetItem::setSelected() instead") +/
        final void setItemSelected(const(QTableWidgetItem) item, bool select);
    }));
/+ #endif +/
    final void setRangeSelected(ref const(QTableWidgetSelectionRange) range, bool select);

    final QList!(QTableWidgetSelectionRange) selectedRanges() const;
    final QList!(QTableWidgetItem) selectedItems() const;
    final QList!(QTableWidgetItem) findItems(ref const(QString) text, /+ Qt:: +/qt.core.namespace.MatchFlags flags) const;

    final int visualRow(int logicalRow) const;
    final int visualColumn(int logicalColumn) const;

    final QTableWidgetItem itemAt(ref const(QPoint) p) const;
    pragma(inline, true) final QTableWidgetItem itemAt(int ax, int ay) const
    { auto tmp = QPoint(ax, ay); return itemAt(tmp); }
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QRect visualItemRect(const(QTableWidgetItem) item) const;
    }));

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final const(QTableWidgetItem) itemPrototype() const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final void setItemPrototype(const(QTableWidgetItem) item);
    }));

public /+ Q_SLOTS +/:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    @QSlot final void scrollToItem(const(QTableWidgetItem) item, QAbstractItemView.ScrollHint hint = ScrollHint.EnsureVisible);
    }));
    @QSlot final void insertRow(int row);
    @QSlot final void insertColumn(int column);
    @QSlot final void removeRow(int row);
    @QSlot final void removeColumn(int column);
    @QSlot final void clear();
    @QSlot final void clearContents();

/+ Q_SIGNALS +/public:
    @QSignal final void itemPressed(QTableWidgetItem item);
    @QSignal final void itemClicked(QTableWidgetItem item);
    @QSignal final void itemDoubleClicked(QTableWidgetItem item);

    @QSignal final void itemActivated(QTableWidgetItem item);
    @QSignal final void itemEntered(QTableWidgetItem item);
    // ### Qt 6: add changed roles
    @QSignal final void itemChanged(QTableWidgetItem item);

    @QSignal final void currentItemChanged(QTableWidgetItem current, QTableWidgetItem previous);
    @QSignal final void itemSelectionChanged();

    @QSignal final void cellPressed(int row, int column);
    @QSignal final void cellClicked(int row, int column);
    @QSignal final void cellDoubleClicked(int row, int column);

    @QSignal final void cellActivated(int row, int column);
    @QSignal final void cellEntered(int row, int column);
    @QSignal final void cellChanged(int row, int column);

    @QSignal final void currentCellChanged(int currentRow, int currentColumn, int previousRow, int previousColumn);

protected:
    override bool event(QEvent e);
    /+ virtual +/ QStringList mimeTypes() const;
/+ #if QT_VERSION >= QT_VERSION_CHECK(6,0,0)
    virtual QMimeData *mimeData(const QList<QTableWidgetItem *> &items) const;
#else +/
    /+ virtual +/ QMimeData mimeData(const(QList!(QTableWidgetItem)) items) const;
/+ #endif +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ virtual +/ bool dropMimeData(int row, int column, const(QMimeData) data, qt.core.namespace.DropAction action);
    }));
    /+ virtual +/ /+ Qt:: +/qt.core.namespace.DropActions supportedDropActions() const;

/+ #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
public:
#else +/
protected:
/+ #endif +/
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QList!(QTableWidgetItem) items(const(QMimeData) data) const;
    }));

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QModelIndex indexFromItem(const(QTableWidgetItem) item) const;
    }));
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    final QModelIndex indexFromItem(QTableWidgetItem item) const; // ### Qt 6: remove
/+ #endif +/
    final QTableWidgetItem itemFromIndex(ref const(QModelIndex) index) const;

protected:
/+ #if QT_CONFIG(draganddrop) +/
    override void dropEvent(QDropEvent event);
/+ #endif +/
private:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    protected override void setModel(QAbstractItemModel model);
    }));

    /+ Q_DECLARE_PRIVATE(QTableWidget) +/
    /+ Q_DISABLE_COPY(QTableWidget) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_emitItemPressed(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemClicked(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemDoubleClicked(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemActivated(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemEntered(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitItemChanged(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitCurrentItemChanged(const QModelIndex &previous, const QModelIndex &current))
    Q_PRIVATE_SLOT(d_func(), void _q_sort())
    Q_PRIVATE_SLOT(d_func(), void _q_dataChanged(const QModelIndex &topLeft, const QModelIndex &bottomRight)) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

