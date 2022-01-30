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
module qt.widgets.abstractitemview;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.itemselectionmodel;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.variant;
import qt.core.vector;
import qt.gui.event;
import qt.gui.region;
import qt.helpers;
import qt.widgets.abstractitemdelegate;
import qt.widgets.abstractscrollarea;
import qt.widgets.styleoption;
import qt.widgets.widget;

extern(C++, class) struct tst_QAbstractItemView;
extern(C++, class) struct tst_QTreeView;

/+ QT_REQUIRE_CONFIG(itemviews); +/


extern(C++, class) struct QAbstractItemViewPrivate;

/// Binding for C++ class [QAbstractItemView](https://doc.qt.io/qt-5/qabstractitemview.html).
abstract class /+ Q_WIDGETS_EXPORT +/ QAbstractItemView : QAbstractScrollArea
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool autoScroll READ hasAutoScroll WRITE setAutoScroll)
    Q_PROPERTY(int autoScrollMargin READ autoScrollMargin WRITE setAutoScrollMargin)
    Q_PROPERTY(EditTriggers editTriggers READ editTriggers WRITE setEditTriggers)
    Q_PROPERTY(bool tabKeyNavigation READ tabKeyNavigation WRITE setTabKeyNavigation)
#if QT_CONFIG(draganddrop)
    Q_PROPERTY(bool showDropIndicator READ showDropIndicator WRITE setDropIndicatorShown)
    Q_PROPERTY(bool dragEnabled READ dragEnabled WRITE setDragEnabled)
    Q_PROPERTY(bool dragDropOverwriteMode READ dragDropOverwriteMode WRITE setDragDropOverwriteMode)
    Q_PROPERTY(DragDropMode dragDropMode READ dragDropMode WRITE setDragDropMode)
    Q_PROPERTY(Qt::DropAction defaultDropAction READ defaultDropAction WRITE setDefaultDropAction)
#endif
    Q_PROPERTY(bool alternatingRowColors READ alternatingRowColors WRITE setAlternatingRowColors)
    Q_PROPERTY(SelectionMode selectionMode READ selectionMode WRITE setSelectionMode)
    Q_PROPERTY(SelectionBehavior selectionBehavior READ selectionBehavior WRITE setSelectionBehavior)
    Q_PROPERTY(QSize iconSize READ iconSize WRITE setIconSize NOTIFY iconSizeChanged)
    Q_PROPERTY(Qt::TextElideMode textElideMode READ textElideMode WRITE setTextElideMode)
    Q_PROPERTY(ScrollMode verticalScrollMode READ verticalScrollMode WRITE setVerticalScrollMode RESET resetVerticalScrollMode)
    Q_PROPERTY(ScrollMode horizontalScrollMode READ horizontalScrollMode WRITE setHorizontalScrollMode RESET resetHorizontalScrollMode) +/

public:
    enum SelectionMode {
        NoSelection,
        SingleSelection,
        MultiSelection,
        ExtendedSelection,
        ContiguousSelection
    }
    /+ Q_ENUM(SelectionMode) +/

    enum SelectionBehavior {
        SelectItems,
        SelectRows,
        SelectColumns
    }
    /+ Q_ENUM(SelectionBehavior) +/

    enum ScrollHint {
        EnsureVisible,
        PositionAtTop,
        PositionAtBottom,
        PositionAtCenter
    }
    /+ Q_ENUM(ScrollHint) +/

    enum EditTrigger {
        NoEditTriggers = 0,
        CurrentChanged = 1,
        DoubleClicked = 2,
        SelectedClicked = 4,
        EditKeyPressed = 8,
        AnyKeyPressed = 16,
        AllEditTriggers = 31
    }

    /+ Q_DECLARE_FLAGS(EditTriggers, EditTrigger) +/
alias EditTriggers = QFlags!(EditTrigger);    /+ Q_FLAG(EditTriggers) +/

    enum ScrollMode {
        ScrollPerItem,
        ScrollPerPixel
    }
    /+ Q_ENUM(ScrollMode) +/

    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QWidget parent = null);
    }));
    ~this();

    /+ virtual +/ void setModel(QAbstractItemModel model);
    final QAbstractItemModel model() const;

    /+ virtual +/ void setSelectionModel(QItemSelectionModel selectionModel);
    final QItemSelectionModel selectionModel() const;

    final void setItemDelegate(QAbstractItemDelegate delegate_);
    final QAbstractItemDelegate itemDelegate() const;

    final void setSelectionMode(SelectionMode mode);
    final SelectionMode selectionMode() const;

    final void setSelectionBehavior(SelectionBehavior behavior);
    final SelectionBehavior selectionBehavior() const;

    final QModelIndex currentIndex() const;
    final QModelIndex rootIndex() const;

    final void setEditTriggers(EditTriggers triggers);
    final EditTriggers editTriggers() const;

    final void setVerticalScrollMode(ScrollMode mode);
    final ScrollMode verticalScrollMode() const;
    final void resetVerticalScrollMode();

    final void setHorizontalScrollMode(ScrollMode mode);
    final ScrollMode horizontalScrollMode() const;
    final void resetHorizontalScrollMode();

    final void setAutoScroll(bool enable);
    final bool hasAutoScroll() const;

    final void setAutoScrollMargin(int margin);
    final int autoScrollMargin() const;

    final void setTabKeyNavigation(bool enable);
    final bool tabKeyNavigation() const;

/+ #if QT_CONFIG(draganddrop) +/
    final void setDropIndicatorShown(bool enable);
    final bool showDropIndicator() const;

    final void setDragEnabled(bool enable);
    final bool dragEnabled() const;

    final void setDragDropOverwriteMode(bool overwrite);
    final bool dragDropOverwriteMode() const;

    enum DragDropMode {
        NoDragDrop,
        DragOnly,
        DropOnly,
        DragDrop,
        InternalMove
    }
    /+ Q_ENUM(DragDropMode) +/

    final void setDragDropMode(DragDropMode behavior);
    final DragDropMode dragDropMode() const;

    final void setDefaultDropAction(/+ Qt:: +/qt.core.namespace.DropAction dropAction);
    final /+ Qt:: +/qt.core.namespace.DropAction defaultDropAction() const;
/+ #endif +/

    final void setAlternatingRowColors(bool enable);
    final bool alternatingRowColors() const;

    final void setIconSize(ref const(QSize) size);
    final QSize iconSize() const;

    final void setTextElideMode(/+ Qt:: +/qt.core.namespace.TextElideMode mode);
    final /+ Qt:: +/qt.core.namespace.TextElideMode textElideMode() const;

    /+ virtual +/ void keyboardSearch(ref const(QString) search);

    /+ virtual +/ abstract QRect visualRect(ref const(QModelIndex) index) const;
    /+ virtual +/ abstract void scrollTo(ref const(QModelIndex) index, ScrollHint hint = ScrollHint.EnsureVisible);
    /+ virtual +/ abstract QModelIndex indexAt(ref const(QPoint) point) const;

    final QSize sizeHintForIndex(ref const(QModelIndex) index) const;
    /+ virtual +/ int sizeHintForRow(int row) const;
    /+ virtual +/ int sizeHintForColumn(int column) const;

    final void openPersistentEditor(ref const(QModelIndex) index);
    final void closePersistentEditor(ref const(QModelIndex) index);
    final bool isPersistentEditorOpen(ref const(QModelIndex) index) const;

    final void setIndexWidget(ref const(QModelIndex) index, QWidget widget);
    final QWidget indexWidget(ref const(QModelIndex) index) const;

    final void setItemDelegateForRow(int row, QAbstractItemDelegate delegate_);
    final QAbstractItemDelegate itemDelegateForRow(int row) const;

    final void setItemDelegateForColumn(int column, QAbstractItemDelegate delegate_);
    final QAbstractItemDelegate itemDelegateForColumn(int column) const;

    final QAbstractItemDelegate itemDelegate(ref const(QModelIndex) index) const;

    /+ virtual +/ override QVariant inputMethodQuery(/+ Qt:: +/qt.core.namespace.InputMethodQuery query) const;

    /+ using QAbstractScrollArea::update; +/

public /+ Q_SLOTS +/:
    /+ virtual +/ @QSlot void reset();
    /+ virtual +/ @QSlot void setRootIndex(ref const(QModelIndex) index);
    /+ virtual +/ @QSlot void doItemsLayout();
    /+ virtual +/ @QSlot void selectAll();
    @QSlot final void edit(ref const(QModelIndex) index);
    @QSlot final void clearSelection();
    @QSlot final void setCurrentIndex(ref const(QModelIndex) index);
    @QSlot final void scrollToTop();
    @QSlot final void scrollToBottom();
    @QSlot final void update(ref const(QModelIndex) index);

protected /+ Q_SLOTS +/:
    /+ virtual +/ @QSlot void dataChanged(ref const(QModelIndex) topLeft, ref const(QModelIndex) bottomRight, ref const(QVector!(int)) roles = globalInitVar!(QVector!(int)));
    /+ virtual +/ @QSlot void rowsInserted(ref const(QModelIndex) parent, int start, int end);
    /+ virtual +/ @QSlot void rowsAboutToBeRemoved(ref const(QModelIndex) parent, int start, int end);
    /+ virtual +/ @QSlot void selectionChanged(ref const(QItemSelection) selected, ref const(QItemSelection) deselected);
    /+ virtual +/ @QSlot void currentChanged(ref const(QModelIndex) current, ref const(QModelIndex) previous);
    /+ virtual +/ @QSlot void updateEditorData();
    /+ virtual +/ @QSlot void updateEditorGeometries();
    /+ virtual +/ @QSlot void updateGeometries();
    /+ virtual +/ @QSlot void verticalScrollbarAction(int action);
    /+ virtual +/ @QSlot void horizontalScrollbarAction(int action);
    /+ virtual +/ @QSlot void verticalScrollbarValueChanged(int value);
    /+ virtual +/ @QSlot void horizontalScrollbarValueChanged(int value);
    /+ virtual +/ @QSlot void closeEditor(QWidget editor, QAbstractItemDelegate.EndEditHint hint);
    /+ virtual +/ @QSlot void commitData(QWidget editor);
    /+ virtual +/ @QSlot void editorDestroyed(QObject editor);

/+ Q_SIGNALS +/public:
    @QSignal final void pressed(ref const(QModelIndex) index);
    @QSignal final void clicked(ref const(QModelIndex) index);
    @QSignal final void doubleClicked(ref const(QModelIndex) index);

    @QSignal final void activated(ref const(QModelIndex) index);
    @QSignal final void entered(ref const(QModelIndex) index);
    @QSignal final void viewportEntered();

    @QSignal final void iconSizeChanged(ref const(QSize) size);

protected:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QAbstractItemViewPrivate , QWidget parent = null);
    }));

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED +/ final void setHorizontalStepsPerItem(int steps);
    /+ QT_DEPRECATED +/ final int horizontalStepsPerItem() const;
    /+ QT_DEPRECATED +/ final void setVerticalStepsPerItem(int steps);
    /+ QT_DEPRECATED +/ final int verticalStepsPerItem() const;
/+ #endif +/

    enum CursorAction { MoveUp, MoveDown, MoveLeft, MoveRight,
                        MoveHome, MoveEnd, MovePageUp, MovePageDown,
                        MoveNext, MovePrevious }
    /+ virtual +/ abstract QModelIndex moveCursor(CursorAction cursorAction,
                                       /+ Qt:: +/qt.core.namespace.KeyboardModifiers modifiers);

    /+ virtual +/ abstract int horizontalOffset() const;
    /+ virtual +/ abstract int verticalOffset() const;

    /+ virtual +/ abstract bool isIndexHidden(ref const(QModelIndex) index) const;

    /+ virtual +/ abstract void setSelection(ref const(QRect) rect, QItemSelectionModel.SelectionFlags command);
    /+ virtual +/ abstract QRegion visualRegionForSelection(ref const(QItemSelection) selection) const;
    /+ virtual +/ QModelIndexList selectedIndexes() const;

    /+ virtual +/ bool edit(ref const(QModelIndex) index, EditTrigger trigger, QEvent event);

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ virtual +/ QItemSelectionModel.SelectionFlags selectionCommand(ref const(QModelIndex) index,
                                                                     const(QEvent) event = null) const;
    }));

/+ #if QT_CONFIG(draganddrop) +/
    /+ virtual +/ void startDrag(/+ Qt:: +/qt.core.namespace.DropActions supportedActions);
/+ #endif +/

    /+ virtual +/ QStyleOptionViewItem viewOptions() const;

    enum State {
        NoState,
        DraggingState,
        DragSelectingState,
        EditingState,
        ExpandingState,
        CollapsingState,
        AnimatingState
    }

    final State state() const;
    final void setState(State state);

    final void scheduleDelayedItemsLayout();
    final void executeDelayedItemsLayout();

    final void setDirtyRegion(ref const(QRegion) region);
    final void scrollDirtyRegion(int dx, int dy);
    final QPoint dirtyRegionOffset() const;

    final void startAutoScroll();
    final void stopAutoScroll();
    final void doAutoScroll();

    override bool focusNextPrevChild(bool next);
    override bool event(QEvent event);
    override bool viewportEvent(QEvent event);
    override void mousePressEvent(QMouseEvent event);
    override void mouseMoveEvent(QMouseEvent event);
    override void mouseReleaseEvent(QMouseEvent event);
    override void mouseDoubleClickEvent(QMouseEvent event);
/+ #if QT_CONFIG(draganddrop) +/
    override void dragEnterEvent(QDragEnterEvent event);
    override void dragMoveEvent(QDragMoveEvent event);
    override void dragLeaveEvent(QDragLeaveEvent event);
    override void dropEvent(QDropEvent event);
/+ #endif +/
    override void focusInEvent(QFocusEvent event);
    override void focusOutEvent(QFocusEvent event);
    override void keyPressEvent(QKeyEvent event);
    override void resizeEvent(QResizeEvent event);
    override void timerEvent(QTimerEvent event);
    override void inputMethodEvent(QInputMethodEvent event);
    override bool eventFilter(QObject object, QEvent event);

/+ #if QT_CONFIG(draganddrop) +/
    enum DropIndicatorPosition { OnItem, AboveItem, BelowItem, OnViewport }
    final DropIndicatorPosition dropIndicatorPosition() const;
/+ #endif +/

    override QSize viewportSizeHint() const;

private:
    /+ Q_DECLARE_PRIVATE(QAbstractItemView) +/
    /+ Q_DISABLE_COPY(QAbstractItemView) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_columnsAboutToBeRemoved(const QModelIndex&, int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_columnsRemoved(const QModelIndex&, int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_columnsInserted(const QModelIndex&, int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_rowsInserted(const QModelIndex&, int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_rowsRemoved(const QModelIndex&, int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_columnsMoved(const QModelIndex&, int, int, const QModelIndex&, int))
    Q_PRIVATE_SLOT(d_func(), void _q_rowsMoved(const QModelIndex&, int, int, const QModelIndex&, int))
    Q_PRIVATE_SLOT(d_func(), void _q_modelDestroyed())
    Q_PRIVATE_SLOT(d_func(), void _q_layoutChanged())
    Q_PRIVATE_SLOT(d_func(), void _q_headerDataChanged())
#if QT_CONFIG(gestures) && QT_CONFIG(scroller)
    Q_PRIVATE_SLOT(d_func(), void _q_scrollerStateChanged())
#endif +/

    /+ friend class ::tst_QAbstractItemView; +/
    /+ friend class ::tst_QTreeView; +/
    /+ friend class QTreeViewPrivate; +/ // needed to compile with MSVC
    /+ friend class QListModeViewBase; +/
    /+ friend class QListViewPrivate; +/
    /+ friend class QAbstractSlider; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QAbstractItemView.EditTriggers.enum_type) operator |(QAbstractItemView.EditTriggers.enum_type f1, QAbstractItemView.EditTriggers.enum_type f2)/+noexcept+/{return QFlags!(QAbstractItemView.EditTriggers.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QAbstractItemView.EditTriggers.enum_type) operator |(QAbstractItemView.EditTriggers.enum_type f1, QFlags!(QAbstractItemView.EditTriggers.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QAbstractItemView.EditTriggers.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QAbstractItemView::EditTriggers) +/
