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
module qt.widgets.treeview;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.coreevent;
import qt.core.itemselectionmodel;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.vector;
import qt.gui.event;
import qt.gui.painter;
import qt.gui.region;
import qt.helpers;
import qt.widgets.abstractitemview;
import qt.widgets.headerview;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ class tst_QTreeView;

QT_REQUIRE_CONFIG(treeview); +/


extern(C++, class) struct QTreeViewPrivate;
/+ class QHeaderView; +/

class /+ Q_WIDGETS_EXPORT +/ QTreeView : QAbstractItemView
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(int autoExpandDelay READ autoExpandDelay WRITE setAutoExpandDelay)
    Q_PROPERTY(int indentation READ indentation WRITE setIndentation RESET resetIndentation)
    Q_PROPERTY(bool rootIsDecorated READ rootIsDecorated WRITE setRootIsDecorated)
    Q_PROPERTY(bool uniformRowHeights READ uniformRowHeights WRITE setUniformRowHeights)
    Q_PROPERTY(bool itemsExpandable READ itemsExpandable WRITE setItemsExpandable)
    Q_PROPERTY(bool sortingEnabled READ isSortingEnabled WRITE setSortingEnabled)
    Q_PROPERTY(bool animated READ isAnimated WRITE setAnimated)
    Q_PROPERTY(bool allColumnsShowFocus READ allColumnsShowFocus WRITE setAllColumnsShowFocus)
    Q_PROPERTY(bool wordWrap READ wordWrap WRITE setWordWrap)
    Q_PROPERTY(bool headerHidden READ isHeaderHidden WRITE setHeaderHidden)
    Q_PROPERTY(bool expandsOnDoubleClick READ expandsOnDoubleClick WRITE setExpandsOnDoubleClick) +/

public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    override void setModel(QAbstractItemModel model);
    override void setRootIndex(ref const(QModelIndex) index);
    override void setSelectionModel(QItemSelectionModel selectionModel);

    final QHeaderView header() const;
    final void setHeader(QHeaderView header);

    final int autoExpandDelay() const;
    final void setAutoExpandDelay(int delay);

    final int indentation() const;
    final void setIndentation(int i);
    final void resetIndentation();

    final bool rootIsDecorated() const;
    final void setRootIsDecorated(bool show);

    final bool uniformRowHeights() const;
    final void setUniformRowHeights(bool uniform);

    final bool itemsExpandable() const;
    final void setItemsExpandable(bool enable);

    final bool expandsOnDoubleClick() const;
    final void setExpandsOnDoubleClick(bool enable);

    final int columnViewportPosition(int column) const;
    final int columnWidth(int column) const;
    final void setColumnWidth(int column, int width);
    final int columnAt(int x) const;

    final bool isColumnHidden(int column) const;
    final void setColumnHidden(int column, bool hide);

    final bool isHeaderHidden() const;
    final void setHeaderHidden(bool hide);

    final bool isRowHidden(int row, ref const(QModelIndex) parent) const;
    final void setRowHidden(int row, ref const(QModelIndex) parent, bool hide);

    final bool isFirstColumnSpanned(int row, ref const(QModelIndex) parent) const;
    final void setFirstColumnSpanned(int row, ref const(QModelIndex) parent, bool span);

    final bool isExpanded(ref const(QModelIndex) index) const;
    final void setExpanded(ref const(QModelIndex) index, bool expand);

    final void setSortingEnabled(bool enable);
    final bool isSortingEnabled() const;

    final void setAnimated(bool enable);
    final bool isAnimated() const;

    final void setAllColumnsShowFocus(bool enable);
    final bool allColumnsShowFocus() const;

    final void setWordWrap(bool on);
    final bool wordWrap() const;

    final void setTreePosition(int logicalIndex);
    final int treePosition() const;

    override void keyboardSearch(ref const(QString) search);

    override QRect visualRect(ref const(QModelIndex) index) const;
    override void scrollTo(ref const(QModelIndex) index, ScrollHint hint = ScrollHint.EnsureVisible);
    override QModelIndex indexAt(ref const(QPoint) p) const;
    final QModelIndex indexAbove(ref const(QModelIndex) index) const;
    final QModelIndex indexBelow(ref const(QModelIndex) index) const;

    override void doItemsLayout();
    override void reset();


    override void dataChanged(ref const(QModelIndex) topLeft, ref const(QModelIndex) bottomRight, ref const(QVector!(int)) roles = globalInitVar!(QVector!(int)));
    override void selectAll();

/+ Q_SIGNALS +/public:
    @QSignal final void expanded(ref const(QModelIndex) index);
    @QSignal final void collapsed(ref const(QModelIndex) index);

public /+ Q_SLOTS +/:
    @QSlot final void hideColumn(int column);
    @QSlot final void showColumn(int column);
    @QSlot final void expand(ref const(QModelIndex) index);
    @QSlot final void collapse(ref const(QModelIndex) index);
    @QSlot final void resizeColumnToContents(int column);
/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X ("Use QTreeView::sortByColumn(int column, Qt::SortOrder order) instead") +/
        @QSlot final void sortByColumn(int column);
/+ #endif +/
    @QSlot final void sortByColumn(int column, /+ Qt:: +/qt.core.namespace.SortOrder order);
    @QSlot final void expandAll();
    @QSlot final void expandRecursively(ref const(QModelIndex) index, int depth = -1);
    @QSlot final void collapseAll();
    @QSlot final void expandToDepth(int depth);

protected /+ Q_SLOTS +/:
    @QSlot final void columnResized(int column, int oldSize, int newSize);
    @QSlot final void columnCountChanged(int oldCount, int newCount);
    @QSlot final void columnMoved();
    @QSlot final void reexpand();
    @QSlot final void rowsRemoved(ref const(QModelIndex) parent, int first, int last);
    @QSlot override void verticalScrollbarValueChanged(int value);

protected:
    this(ref QTreeViewPrivate dd, QWidget parent = null);
    override void scrollContentsBy(int dx, int dy);
    override void rowsInserted(ref const(QModelIndex) parent, int start, int end);
    override void rowsAboutToBeRemoved(ref const(QModelIndex) parent, int start, int end);

    override QModelIndex moveCursor(CursorAction cursorAction, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers);
    override int horizontalOffset() const;
    override int verticalOffset() const;

    override void setSelection(ref const(QRect) rect, QItemSelectionModel.SelectionFlags command);
    override QRegion visualRegionForSelection(ref const(QItemSelection) selection) const;
    override QModelIndexList selectedIndexes() const;

    override void timerEvent(QTimerEvent event);
    override void paintEvent(QPaintEvent event);

    final void drawTree(QPainter* painter, ref const(QRegion) region) const;
    /+ virtual +/ void drawRow(QPainter* painter,
                             ref const(QStyleOptionViewItem) options,
                             ref const(QModelIndex) index) const;
    /+ virtual +/ void drawBranches(QPainter* painter,
                                  ref const(QRect) rect,
                                  ref const(QModelIndex) index) const;

    override void mousePressEvent(QMouseEvent event);
    override void mouseReleaseEvent(QMouseEvent event);
    override void mouseDoubleClickEvent(QMouseEvent event);
    override void mouseMoveEvent(QMouseEvent event);
    override void keyPressEvent(QKeyEvent event);
/+ #if QT_CONFIG(draganddrop) +/
    override void dragMoveEvent(QDragMoveEvent event);
/+ #endif +/
    override bool viewportEvent(QEvent event);

    override void updateGeometries();

    override QSize viewportSizeHint() const;

    override int sizeHintForColumn(int column) const;
    final int indexRowSizeHint(ref const(QModelIndex) index) const;
    final int rowHeight(ref const(QModelIndex) index) const;

    override void horizontalScrollbarAction(int action);

    override bool isIndexHidden(ref const(QModelIndex) index) const;
    override void selectionChanged(ref const(QItemSelection) selected,
                              ref const(QItemSelection) deselected);
    override void currentChanged(ref const(QModelIndex) current, ref const(QModelIndex) previous);

private:
    /+ friend class ::tst_QTreeView; +/
    /+ friend class QAccessibleTable; +/
    /+ friend class QAccessibleTree; +/
    /+ friend class QAccessibleTableCell; +/
    final int visualIndex(ref const(QModelIndex) index) const;

    /+ Q_DECLARE_PRIVATE(QTreeView) +/
    /+ Q_DISABLE_COPY(QTreeView) +/
/+ #if QT_CONFIG(animation)
    Q_PRIVATE_SLOT(d_func(), void _q_endAnimatedOperation())
#endif // animation
    Q_PRIVATE_SLOT(d_func(), void _q_modelAboutToBeReset())
    Q_PRIVATE_SLOT(d_func(), void _q_sortIndicatorChanged(int column, Qt::SortOrder order)) +/
}

