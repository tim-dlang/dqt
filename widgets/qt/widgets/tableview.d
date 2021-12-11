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
module qt.widgets.tableview;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.coreevent;
import qt.core.itemselectionmodel;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.gui.event;
import qt.gui.region;
import qt.helpers;
import qt.widgets.abstractitemview;
import qt.widgets.headerview;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(tableview);


class QHeaderView; +/
extern(C++, class) struct QTableViewPrivate;

/// Binding for C++ class [QTableView](https://doc.qt.io/qt-5/qtableview.html).
class /+ Q_WIDGETS_EXPORT +/ QTableView : QAbstractItemView
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool showGrid READ showGrid WRITE setShowGrid)
    Q_PROPERTY(Qt::PenStyle gridStyle READ gridStyle WRITE setGridStyle)
    Q_PROPERTY(bool sortingEnabled READ isSortingEnabled WRITE setSortingEnabled)
    Q_PROPERTY(bool wordWrap READ wordWrap WRITE setWordWrap)
#if QT_CONFIG(abstractbutton)
    Q_PROPERTY(bool cornerButtonEnabled READ isCornerButtonEnabled WRITE setCornerButtonEnabled)
#endif +/

public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    override void setModel(QAbstractItemModel model);
    override void setRootIndex(ref const(QModelIndex) index);
    override void setSelectionModel(QItemSelectionModel selectionModel);
    override void doItemsLayout();

    final QHeaderView horizontalHeader() const;
    final QHeaderView verticalHeader() const;
    final void setHorizontalHeader(QHeaderView header);
    final void setVerticalHeader(QHeaderView header);

    final int rowViewportPosition(int row) const;
    final int rowAt(int y) const;

    final void setRowHeight(int row, int height);
    final int rowHeight(int row) const;

    final int columnViewportPosition(int column) const;
    final int columnAt(int x) const;

    final void setColumnWidth(int column, int width);
    final int columnWidth(int column) const;

    final bool isRowHidden(int row) const;
    final void setRowHidden(int row, bool hide);

    final bool isColumnHidden(int column) const;
    final void setColumnHidden(int column, bool hide);

    final void setSortingEnabled(bool enable);
    final bool isSortingEnabled() const;

    final bool showGrid() const;

    final /+ Qt:: +/qt.core.namespace.PenStyle gridStyle() const;
    final void setGridStyle(/+ Qt:: +/qt.core.namespace.PenStyle style);

    final void setWordWrap(bool on);
    final bool wordWrap() const;

/+ #if QT_CONFIG(abstractbutton) +/
    final void setCornerButtonEnabled(bool enable);
    final bool isCornerButtonEnabled() const;
/+ #endif +/

    override QRect visualRect(ref const(QModelIndex) index) const;
    override void scrollTo(ref const(QModelIndex) index, ScrollHint hint = ScrollHint.EnsureVisible);
    override QModelIndex indexAt(ref const(QPoint) p) const;

    final void setSpan(int row, int column, int rowSpan, int columnSpan);
    final int rowSpan(int row, int column) const;
    final int columnSpan(int row, int column) const;
    final void clearSpans();


public /+ Q_SLOTS +/:
    @QSlot final void selectRow(int row);
    @QSlot final void selectColumn(int column);
    @QSlot final void hideRow(int row);
    @QSlot final void hideColumn(int column);
    @QSlot final void showRow(int row);
    @QSlot final void showColumn(int column);
    @QSlot final void resizeRowToContents(int row);
    @QSlot final void resizeRowsToContents();
    @QSlot final void resizeColumnToContents(int column);
    @QSlot final void resizeColumnsToContents();
/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X ("Use QTableView::sortByColumn(int column, Qt::SortOrder order) instead") +/
        @QSlot final void sortByColumn(int column);
/+ #endif +/
    @QSlot final void sortByColumn(int column, /+ Qt:: +/qt.core.namespace.SortOrder order);
    @QSlot final void setShowGrid(bool show);

protected /+ Q_SLOTS +/:
    @QSlot final void rowMoved(int row, int oldIndex, int newIndex);
    @QSlot final void columnMoved(int column, int oldIndex, int newIndex);
    @QSlot final void rowResized(int row, int oldHeight, int newHeight);
    @QSlot final void columnResized(int column, int oldWidth, int newWidth);
    @QSlot final void rowCountChanged(int oldCount, int newCount);
    @QSlot final void columnCountChanged(int oldCount, int newCount);

protected:
    this(ref QTableViewPrivate , QWidget parent);
    override void scrollContentsBy(int dx, int dy);

    override QStyleOptionViewItem viewOptions() const;
    override void paintEvent(QPaintEvent e);

    override void timerEvent(QTimerEvent event);

    override int horizontalOffset() const;
    override int verticalOffset() const;
    override QModelIndex moveCursor(CursorAction cursorAction, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers);

    override void setSelection(ref const(QRect) rect, QItemSelectionModel.SelectionFlags command);
    override QRegion visualRegionForSelection(ref const(QItemSelection) selection) const;
    override QModelIndexList selectedIndexes() const;

    override void updateGeometries();

    override QSize viewportSizeHint() const;

    override int sizeHintForRow(int row) const;
    override int sizeHintForColumn(int column) const;

    override void verticalScrollbarAction(int action);
    override void horizontalScrollbarAction(int action);

    override bool isIndexHidden(ref const(QModelIndex) index) const;

    override void selectionChanged(ref const(QItemSelection) selected,
                              ref const(QItemSelection) deselected);
    override void currentChanged(ref const(QModelIndex) current,
                              ref const(QModelIndex) previous);

private:
    /+ friend class QAccessibleItemView; +/
    final int visualIndex(ref const(QModelIndex) index) const;

    /+ Q_DECLARE_PRIVATE(QTableView) +/
    /+ Q_DISABLE_COPY(QTableView) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_selectRow(int))
    Q_PRIVATE_SLOT(d_func(), void _q_selectColumn(int))
    Q_PRIVATE_SLOT(d_func(), void _q_updateSpanInsertedRows(QModelIndex,int,int))
    Q_PRIVATE_SLOT(d_func(), void _q_updateSpanInsertedColumns(QModelIndex,int,int))
    Q_PRIVATE_SLOT(d_func(), void _q_updateSpanRemovedRows(QModelIndex,int,int))
    Q_PRIVATE_SLOT(d_func(), void _q_updateSpanRemovedColumns(QModelIndex,int,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sortIndicatorChanged(int column, Qt::SortOrder order)) +/
}

