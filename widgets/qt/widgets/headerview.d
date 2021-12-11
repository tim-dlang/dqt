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
module qt.widgets.headerview;
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
import qt.gui.painter;
import qt.gui.region;
import qt.helpers;
import qt.widgets.abstractitemview;
import qt.widgets.styleoption;
import qt.widgets.widget;
version(QT_NO_DATASTREAM){}else
    import qt.core.bytearray;

/+ QT_REQUIRE_CONFIG(itemviews); +/


extern(C++, class) struct QHeaderViewPrivate;
/+ class QStyleOptionHeader; +/

class /+ Q_WIDGETS_EXPORT +/ QHeaderView : QAbstractItemView
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool firstSectionMovable READ isFirstSectionMovable WRITE setFirstSectionMovable)
    Q_PROPERTY(bool showSortIndicator READ isSortIndicatorShown WRITE setSortIndicatorShown)
    Q_PROPERTY(bool highlightSections READ highlightSections WRITE setHighlightSections)
    Q_PROPERTY(bool stretchLastSection READ stretchLastSection WRITE setStretchLastSection)
    Q_PROPERTY(bool cascadingSectionResizes READ cascadingSectionResizes WRITE setCascadingSectionResizes)
    Q_PROPERTY(int defaultSectionSize READ defaultSectionSize WRITE setDefaultSectionSize RESET resetDefaultSectionSize)
    Q_PROPERTY(int minimumSectionSize READ minimumSectionSize WRITE setMinimumSectionSize)
    Q_PROPERTY(int maximumSectionSize READ maximumSectionSize WRITE setMaximumSectionSize)
    Q_PROPERTY(Qt::Alignment defaultAlignment READ defaultAlignment WRITE setDefaultAlignment) +/

public:

    enum ResizeMode
    {
        Interactive,
        Stretch,
        Fixed,
        ResizeToContents,
        Custom = ResizeMode.Fixed
    }
    /+ Q_ENUM(ResizeMode) +/

    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.Orientation orientation, QWidget parent = null);
    /+ virtual +/~this();

    override void setModel(QAbstractItemModel model);

    final /+ Qt:: +/qt.core.namespace.Orientation orientation() const;
    final int offset() const;
    final int length() const;
    override QSize sizeHint() const;
    override void setVisible(bool v);
    final int sectionSizeHint(int logicalIndex) const;

    final int visualIndexAt(int position) const;
    final int logicalIndexAt(int position) const;

    pragma(inline, true) final int logicalIndexAt(int ax, int ay) const
    { return orientation() == /+ Qt:: +/qt.core.namespace.Orientation.Horizontal ? logicalIndexAt(ax) : logicalIndexAt(ay); }
    pragma(inline, true) final int logicalIndexAt(ref const(QPoint) apos) const
    { return logicalIndexAt(apos.x(), apos.y()); }

    final int sectionSize(int logicalIndex) const;
    final int sectionPosition(int logicalIndex) const;
    final int sectionViewportPosition(int logicalIndex) const;

    final void moveSection(int from, int to);
    final void swapSections(int first, int second);
    final void resizeSection(int logicalIndex, int size);
    final void resizeSections(QHeaderView.ResizeMode mode);

    final bool isSectionHidden(int logicalIndex) const;
    final void setSectionHidden(int logicalIndex, bool hide);
    final int hiddenSectionCount() const;

    pragma(inline, true) final void hideSection(int alogicalIndex)
    { setSectionHidden(alogicalIndex, true); }
    pragma(inline, true) final void showSection(int alogicalIndex)
    { setSectionHidden(alogicalIndex, false); }

    final int count() const;
    final int visualIndex(int logicalIndex) const;
    final int logicalIndex(int visualIndex) const;

    final void setSectionsMovable(bool movable);
    final bool sectionsMovable() const;
/+ #if QT_DEPRECATED_SINCE(5, 0)
    inline QT_DEPRECATED void setMovable(bool movable) { setSectionsMovable(movable); }
    inline QT_DEPRECATED bool isMovable() const { return sectionsMovable(); }
#endif +/
    final void setFirstSectionMovable(bool movable);
    final bool isFirstSectionMovable() const;

    final void setSectionsClickable(bool clickable);
    final bool sectionsClickable() const;
/+ #if QT_DEPRECATED_SINCE(5, 0)
    inline QT_DEPRECATED void setClickable(bool clickable) { setSectionsClickable(clickable); }
    inline QT_DEPRECATED bool isClickable() const { return sectionsClickable(); }
#endif +/

    final void setHighlightSections(bool highlight);
    final bool highlightSections() const;

    final ResizeMode sectionResizeMode(int logicalIndex) const;
    final void setSectionResizeMode(ResizeMode mode);
    final void setSectionResizeMode(int logicalIndex, ResizeMode mode);

    final void setResizeContentsPrecision(int precision);
    final int  resizeContentsPrecision() const;

/+ #if QT_DEPRECATED_SINCE(5, 0)
    inline QT_DEPRECATED void setResizeMode(ResizeMode mode)
        { setSectionResizeMode(mode); }
    inline QT_DEPRECATED void setResizeMode(int logicalindex, ResizeMode mode)
        { setSectionResizeMode(logicalindex, mode); }
    inline QT_DEPRECATED ResizeMode resizeMode(int logicalindex) const
        { return sectionResizeMode(logicalindex); }
#endif +/

    final int stretchSectionCount() const;

    final void setSortIndicatorShown(bool show);
    final bool isSortIndicatorShown() const;

    final void setSortIndicator(int logicalIndex, /+ Qt:: +/qt.core.namespace.SortOrder order);
    final int sortIndicatorSection() const;
    final /+ Qt:: +/qt.core.namespace.SortOrder sortIndicatorOrder() const;

    final bool stretchLastSection() const;
    final void setStretchLastSection(bool stretch);

    final bool cascadingSectionResizes() const;
    final void setCascadingSectionResizes(bool enable);

    final int defaultSectionSize() const;
    final void setDefaultSectionSize(int size);
    final void resetDefaultSectionSize();

    final int minimumSectionSize() const;
    final void setMinimumSectionSize(int size);
    final int maximumSectionSize() const;
    final void setMaximumSectionSize(int size);

    final /+ Qt:: +/qt.core.namespace.Alignment defaultAlignment() const;
    final void setDefaultAlignment(/+ Qt:: +/qt.core.namespace.Alignment alignment);

    override void doItemsLayout();
    final bool sectionsMoved() const;
    final bool sectionsHidden() const;

    version(QT_NO_DATASTREAM){}else
    {
        final QByteArray saveState() const;
        final bool restoreState(ref const(QByteArray) state);
    }

    override void reset();

public /+ Q_SLOTS +/:
    @QSlot final void setOffset(int offset);
    @QSlot final void setOffsetToSectionPosition(int visualIndex);
    @QSlot final void setOffsetToLastSection();
    @QSlot final void headerDataChanged(/+ Qt:: +/qt.core.namespace.Orientation orientation, int logicalFirst, int logicalLast);

/+ Q_SIGNALS +/public:
    @QSignal final void sectionMoved(int logicalIndex, int oldVisualIndex, int newVisualIndex);
    @QSignal final void sectionResized(int logicalIndex, int oldSize, int newSize);
    @QSignal final void sectionPressed(int logicalIndex);
    @QSignal final void sectionClicked(int logicalIndex);
    @QSignal final void sectionEntered(int logicalIndex);
    @QSignal final void sectionDoubleClicked(int logicalIndex);
    @QSignal final void sectionCountChanged(int oldCount, int newCount);
    @QSignal final void sectionHandleDoubleClicked(int logicalIndex);
    @QSignal final void geometriesChanged();
    @QSignal final void sortIndicatorChanged(int logicalIndex, /+ Qt:: +/qt.core.namespace.SortOrder order);

protected /+ Q_SLOTS +/:
    @QSlot final void updateSection(int logicalIndex);
    @QSlot final void resizeSections();
    @QSlot final void sectionsInserted(ref const(QModelIndex) parent, int logicalFirst, int logicalLast);
    @QSlot final void sectionsAboutToBeRemoved(ref const(QModelIndex) parent, int logicalFirst, int logicalLast);

protected:
    this(ref QHeaderViewPrivate dd, /+ Qt:: +/qt.core.namespace.Orientation orientation, QWidget parent = null);
    final void initialize();

    final void initializeSections();
    final void initializeSections(int start, int end);
    override void currentChanged(ref const(QModelIndex) current, ref const(QModelIndex) old);

    override bool event(QEvent e);
    override void paintEvent(QPaintEvent e);
    override void mousePressEvent(QMouseEvent e);
    override void mouseMoveEvent(QMouseEvent e);
    override void mouseReleaseEvent(QMouseEvent e);
    override void mouseDoubleClickEvent(QMouseEvent e);
    override bool viewportEvent(QEvent e);

    /+ virtual +/ void paintSection(QPainter* painter, ref const(QRect) rect, int logicalIndex) const;
    /+ virtual +/ QSize sectionSizeFromContents(int logicalIndex) const;

    override int horizontalOffset() const;
    override int verticalOffset() const;
    override void updateGeometries();
    override void scrollContentsBy(int dx, int dy);

    override void dataChanged(ref const(QModelIndex) topLeft, ref const(QModelIndex) bottomRight, ref const(QVector!(int)) roles = globalInitVar!(QVector!(int)));
    override void rowsInserted(ref const(QModelIndex) parent, int start, int end);

    override QRect visualRect(ref const(QModelIndex) index) const;
    override void scrollTo(ref const(QModelIndex) index, ScrollHint hint);

    override QModelIndex indexAt(ref const(QPoint) p) const;
    override bool isIndexHidden(ref const(QModelIndex) index) const;

    override QModelIndex moveCursor(CursorAction, /+ Qt:: +/qt.core.namespace.KeyboardModifiers);
    override void setSelection(ref const(QRect) rect, QItemSelectionModel.SelectionFlags flags);
    override QRegion visualRegionForSelection(ref const(QItemSelection) selection) const;
    final void initStyleOption(QStyleOptionHeader* option) const;

    /+ friend class QTableView; +/
    /+ friend class QTreeView; +/

private:
    // ### Qt6: make them protected slots in QHeaderViewPrivate
    /+ Q_PRIVATE_SLOT(d_func(), void _q_sectionsRemoved(const QModelIndex &parent, int logicalFirst, int logicalLast))
    Q_PRIVATE_SLOT(d_func(), void _q_sectionsAboutToBeMoved(const QModelIndex &sourceParent, int logicalStart, int logicalEnd, const QModelIndex &destinationParent, int logicalDestination))
    Q_PRIVATE_SLOT(d_func(), void _q_sectionsMoved(const QModelIndex &sourceParent, int logicalStart, int logicalEnd, const QModelIndex &destinationParent, int logicalDestination))
    Q_PRIVATE_SLOT(d_func(), void _q_sectionsAboutToBeChanged(const QList<QPersistentModelIndex> &parents = QList<QPersistentModelIndex>(),
                                                              QAbstractItemModel::LayoutChangeHint hint = QAbstractItemModel::NoLayoutChangeHint))
    Q_PRIVATE_SLOT(d_func(), void _q_sectionsChanged(const QList<QPersistentModelIndex> &parents = QList<QPersistentModelIndex>(),
                                                     QAbstractItemModel::LayoutChangeHint hint = QAbstractItemModel::NoLayoutChangeHint))
    Q_DECLARE_PRIVATE(QHeaderView) +/
    /+ Q_DISABLE_COPY(QHeaderView) +/
}

