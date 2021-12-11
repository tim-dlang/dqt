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
module qt.widgets.listview;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.coreevent;
import qt.core.itemselectionmodel;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.vector;
import qt.gui.event;
import qt.gui.region;
import qt.helpers;
import qt.widgets.abstractitemview;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(listview); +/


extern(C++, class) struct QListViewPrivate;

class /+ Q_WIDGETS_EXPORT +/ QListView : QAbstractItemView
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(Movement movement READ movement WRITE setMovement)
    Q_PROPERTY(Flow flow READ flow WRITE setFlow)
    Q_PROPERTY(bool isWrapping READ isWrapping WRITE setWrapping)
    Q_PROPERTY(ResizeMode resizeMode READ resizeMode WRITE setResizeMode)
    Q_PROPERTY(LayoutMode layoutMode READ layoutMode WRITE setLayoutMode)
    Q_PROPERTY(int spacing READ spacing WRITE setSpacing)
    Q_PROPERTY(QSize gridSize READ gridSize WRITE setGridSize)
    Q_PROPERTY(ViewMode viewMode READ viewMode WRITE setViewMode)
    Q_PROPERTY(int modelColumn READ modelColumn WRITE setModelColumn)
    Q_PROPERTY(bool uniformItemSizes READ uniformItemSizes WRITE setUniformItemSizes)
    Q_PROPERTY(int batchSize READ batchSize WRITE setBatchSize)
    Q_PROPERTY(bool wordWrap READ wordWrap WRITE setWordWrap)
    Q_PROPERTY(bool selectionRectVisible READ isSelectionRectVisible WRITE setSelectionRectVisible)
    Q_PROPERTY(Qt::Alignment itemAlignment READ itemAlignment WRITE setItemAlignment) +/

public:
    enum Movement { Static, Free, Snap }
    /+ Q_ENUM(Movement) +/
    enum Flow { LeftToRight, TopToBottom }
    /+ Q_ENUM(Flow) +/
    enum ResizeMode { Fixed, Adjust }
    /+ Q_ENUM(ResizeMode) +/
    enum LayoutMode { SinglePass, Batched }
    /+ Q_ENUM(LayoutMode) +/
    enum ViewMode { ListMode, IconMode }
    /+ Q_ENUM(ViewMode) +/

    /+ explicit +/this(QWidget parent = null);
    ~this();

    final void setMovement(Movement movement);
    final Movement movement() const;

    final void setFlow(Flow flow);
    final Flow flow() const;

    final void setWrapping(bool enable);
    final bool isWrapping() const;

    final void setResizeMode(ResizeMode mode);
    final ResizeMode resizeMode() const;

    final void setLayoutMode(LayoutMode mode);
    final LayoutMode layoutMode() const;

    final void setSpacing(int space);
    final int spacing() const;

    final void setBatchSize(int batchSize);
    final int batchSize() const;

    final void setGridSize(ref const(QSize) size);
    final QSize gridSize() const;

    final void setViewMode(ViewMode mode);
    final ViewMode viewMode() const;

    final void clearPropertyFlags();

    final bool isRowHidden(int row) const;
    final void setRowHidden(int row, bool hide);

    final void setModelColumn(int column);
    final int modelColumn() const;

    final void setUniformItemSizes(bool enable);
    final bool uniformItemSizes() const;

    final void setWordWrap(bool on);
    final bool wordWrap() const;

    final void setSelectionRectVisible(bool show);
    final bool isSelectionRectVisible() const;

    final void setItemAlignment(/+ Qt:: +/qt.core.namespace.Alignment alignment);
    final /+ Qt:: +/qt.core.namespace.Alignment itemAlignment() const;

    override QRect visualRect(ref const(QModelIndex) index) const;
    override void scrollTo(ref const(QModelIndex) index, ScrollHint hint = ScrollHint.EnsureVisible);
    override QModelIndex indexAt(ref const(QPoint) p) const;

    override void doItemsLayout();
    override void reset();
    override void setRootIndex(ref const(QModelIndex) index);

/+ Q_SIGNALS +/public:
    @QSignal final void indexesMoved(ref const(QModelIndexList) indexes);

protected:
    this(ref QListViewPrivate , QWidget parent = null);

    override bool event(QEvent e);

    override void scrollContentsBy(int dx, int dy);

    final void resizeContents(int width, int height);
    final QSize contentsSize() const;

    override void dataChanged(ref const(QModelIndex) topLeft, ref const(QModelIndex) bottomRight, ref const(QVector!(int)) roles = globalInitVar!(QVector!(int)));
    override void rowsInserted(ref const(QModelIndex) parent, int start, int end);
    override void rowsAboutToBeRemoved(ref const(QModelIndex) parent, int start, int end);

    override void mouseMoveEvent(QMouseEvent e);
    override void mouseReleaseEvent(QMouseEvent e);
/+ #if QT_CONFIG(wheelevent) +/
    override void wheelEvent(QWheelEvent e);
/+ #endif +/

    override void timerEvent(QTimerEvent e);
    override void resizeEvent(QResizeEvent e);
/+ #if QT_CONFIG(draganddrop) +/
    override void dragMoveEvent(QDragMoveEvent e);
    override void dragLeaveEvent(QDragLeaveEvent e);
    override void dropEvent(QDropEvent e);
    override void startDrag(/+ Qt:: +/qt.core.namespace.DropActions supportedActions);
/+ #endif +/ // QT_CONFIG(draganddrop)

    override QStyleOptionViewItem viewOptions() const;
    override void paintEvent(QPaintEvent e);

    override int horizontalOffset() const;
    override int verticalOffset() const;
    override QModelIndex moveCursor(CursorAction cursorAction, /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers);
    final QRect rectForIndex(ref const(QModelIndex) index) const;
    final void setPositionForIndex(ref const(QPoint) position, ref const(QModelIndex) index);

    override void setSelection(ref const(QRect) rect, QItemSelectionModel.SelectionFlags command);
    override QRegion visualRegionForSelection(ref const(QItemSelection) selection) const;
    override QModelIndexList selectedIndexes() const;

    override void updateGeometries();

    override bool isIndexHidden(ref const(QModelIndex) index) const;

    override void selectionChanged(ref const(QItemSelection) selected, ref const(QItemSelection) deselected);
    override void currentChanged(ref const(QModelIndex) current, ref const(QModelIndex) previous);

    override QSize viewportSizeHint() const;

private:
    final int visualIndex(ref const(QModelIndex) index) const;

    /+ Q_DECLARE_PRIVATE(QListView) +/
    /+ Q_DISABLE_COPY(QListView) +/
}

