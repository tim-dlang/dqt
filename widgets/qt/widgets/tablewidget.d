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
import qt.gui.brush;
import qt.gui.event;
import qt.gui.font;
import qt.gui.icon;
import qt.helpers;
import qt.widgets.abstractitemview;
import qt.widgets.tableview;
import qt.widgets.widget;
import qt.widgets.widgetitemdata;
version (QT_NO_DATASTREAM) {} else
    import qt.core.datastream;

/+ QT_REQUIRE_CONFIG(tablewidget); +/


/// Binding for C++ class [QTableWidgetSelectionRange](https://doc.qt.io/qt-6/qtablewidgetselectionrange.html).
extern(C++, class) struct QTableWidgetSelectionRange
{
public:
    /+ QTableWidgetSelectionRange() = default; +/
    this(int top, int left, int bottom, int right)
    {
        this.m_top = top;
        this.m_left = left;
        this.m_bottom = bottom;
        this.m_right = right;
    }

    /+ friend bool operator==(const QTableWidgetSelectionRange &lhs,
                           const QTableWidgetSelectionRange &rhs) noexcept
    { return lhs.m_top == rhs.m_top && lhs.m_left == rhs.m_left
          && lhs.m_bottom == rhs.m_bottom && lhs.m_right == rhs.m_right; } +/
    /+ friend bool operator!=(const QTableWidgetSelectionRange &lhs,
                           const QTableWidgetSelectionRange &rhs) noexcept
    { return !(lhs == rhs); } +/

    pragma(inline, true) int topRow() const { return m_top; }
    pragma(inline, true) int bottomRow() const { return m_bottom; }
    pragma(inline, true) int leftColumn() const { return m_left; }
    pragma(inline, true) int rightColumn() const { return m_right; }
    pragma(inline, true) int rowCount() const { return m_bottom - m_top + 1; }
    pragma(inline, true) int columnCount() const { return m_right - m_left + 1; }
private:
    int m_top = -1; int m_left = -1; int m_bottom = -2; int m_right = -2;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QTableModel;
extern(C++, class) struct QTableWidgetItemPrivate;

/// Binding for C++ class [QTableWidgetItem](https://doc.qt.io/qt-6/qtablewidgetitem.html).
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

/+ #if QT_CONFIG(tooltip) +/
    pragma(inline, true) final QString toolTip() const
        { return data(/+ Qt:: +/qt.core.namespace.ItemDataRole.ToolTipRole).toString(); }
    pragma(inline, true) final void setToolTip(ref const(QString) atoolTip)
    { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.ToolTipRole, atoolTip); }
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

/+ #if QT_VERSION < QT_VERSION_CHECK(7, 0, 0) +/
    pragma(inline, true) final int textAlignment() const
        { return data(/+ Qt:: +/qt.core.namespace.ItemDataRole.TextAlignmentRole).toInt(); }
/+ #else
    inline Qt::Alignment textAlignment() const
    { return qvariant_cast<Qt::Alignment>(data(Qt::TextAlignmentRole)); }
#endif
#if QT_DEPRECATED_SINCE(6, 4) +/
    /+ QT_DEPRECATED_VERSION_X_6_4("Use the overload taking Qt::Alignment") +/
        pragma(inline, true) final void setTextAlignment(int alignment)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.TextAlignmentRole, alignment); }
    pragma(inline, true) final void setTextAlignment(/+ Qt:: +/qt.core.namespace.AlignmentFlag alignment)
        { auto tmp = QVariant.fromValue(/+ Qt:: +/qt.core.namespace.Alignment(alignment)); setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.TextAlignmentRole, tmp); }
/+ #endif +/
    pragma(inline, true) final void setTextAlignment(/+ Qt:: +/qt.core.namespace.Alignment alignment)
        { auto tmp = QVariant.fromValue(alignment); setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.TextAlignmentRole, tmp); }

    pragma(inline, true) final QBrush background() const
        { return qvariant_cast!(QBrush)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole)); }
    pragma(inline, true) final void setBackground(ref const(QBrush) brush)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole, brush.style() != /+ Qt:: +/qt.core.namespace.BrushStyle.NoBrush ? QVariant.fromValue(brush) : QVariant()); }

    pragma(inline, true) final QBrush foreground() const
        { return qvariant_cast!(QBrush)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole)); }
    pragma(inline, true) final void setForeground(ref const(QBrush) brush)
        { setData(/+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole, brush.style() != /+ Qt:: +/qt.core.namespace.BrushStyle.NoBrush ? QVariant.fromValue(brush) : QVariant()); }

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.CheckState checkState() const
        { return qvariant_cast!(/+ Qt:: +/qt.core.namespace.CheckState)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.CheckStateRole)); }
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

    version (QT_NO_DATASTREAM) {} else
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
    QList!(QWidgetItemData) values;
    QTableWidget view;
    QTableWidgetItemPrivate* d;
    /+ Qt:: +/qt.core.namespace.ItemFlags itemFlags;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #if QT_CONFIG(tooltip)
#endif

#if QT_CONFIG(whatsthis)
#endif

#ifndef QT_NO_DATASTREAM
Q_WIDGETS_EXPORT QDataStream &operator>>(QDataStream &in, QTableWidgetItem &item);
Q_WIDGETS_EXPORT QDataStream &operator<<(QDataStream &out, const QTableWidgetItem &item);
#endif +/

extern(C++, class) struct QTableWidgetPrivate;

/// Binding for C++ class [QTableWidget](https://doc.qt.io/qt-6/qtablewidget.html).
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
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QList!(QTableWidgetItem) items(const(QMimeData) data) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QModelIndex indexFromItem(const(QTableWidgetItem) item) const;
    }));
    final QTableWidgetItem itemFromIndex(ref const(QModelIndex) index) const;

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
    alias isPersistentEditorOpen = QAbstractItemView.isPersistentEditorOpen;
    final bool isPersistentEditorOpen(QTableWidgetItem item) const;

    final QWidget cellWidget(int row, int column) const;
    final void setCellWidget(int row, int column, QWidget widget);
    pragma(inline, true) final void removeCellWidget(int arow, int acolumn)
    { setCellWidget(arow, acolumn, null); }

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
    /+ virtual +/ QMimeData mimeData(ref const(QList!(QTableWidgetItem)) items) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ virtual +/ bool dropMimeData(int row, int column, const(QMimeData) data, qt.core.namespace.DropAction action);
    }));
    /+ virtual +/ /+ Qt:: +/qt.core.namespace.DropActions supportedDropActions() const;

protected:
/+ #if QT_CONFIG(draganddrop) +/
    override void dropEvent(QDropEvent event);
/+ #endif +/
private:
    mixin(changeWindowsMangling(q{mangleChangeAccess("private")}, q{
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

