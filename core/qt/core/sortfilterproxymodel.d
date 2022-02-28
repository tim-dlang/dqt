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
module qt.core.sortfilterproxymodel;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.abstractproxymodel;
import qt.core.itemselectionmodel;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.object;
import qt.core.property;
import qt.core.regularexpression;
import qt.core.size;
import qt.core.string;
import qt.core.stringlist;
import qt.core.variant;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(sortfilterproxymodel); +/



extern(C++, class) struct QSortFilterProxyModelPrivate;
extern(C++, class) struct QSortFilterProxyModelLessThan;
extern(C++, class) struct QSortFilterProxyModelGreaterThan;

/// Binding for C++ class [QSortFilterProxyModel](https://doc.qt.io/qt-6/qsortfilterproxymodel.html).
class /+ Q_CORE_EXPORT +/ QSortFilterProxyModel : QAbstractProxyModel
{
private:
    /+ friend class QSortFilterProxyModelLessThan; +/
    /+ friend class QSortFilterProxyModelGreaterThan; +/

    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QRegularExpression filterRegularExpression READ filterRegularExpression
               WRITE setFilterRegularExpression BINDABLE bindableFilterRegularExpression)
    Q_PROPERTY(int filterKeyColumn READ filterKeyColumn WRITE setFilterKeyColumn
               BINDABLE bindableFilterKeyColumn)
    Q_PROPERTY(bool dynamicSortFilter READ dynamicSortFilter WRITE setDynamicSortFilter
               BINDABLE bindableDynamicSortFilter)
    Q_PROPERTY(Qt::CaseSensitivity filterCaseSensitivity READ filterCaseSensitivity
               WRITE setFilterCaseSensitivity NOTIFY filterCaseSensitivityChanged
               BINDABLE bindableFilterCaseSensitivity)
    Q_PROPERTY(Qt::CaseSensitivity sortCaseSensitivity READ sortCaseSensitivity
               WRITE setSortCaseSensitivity NOTIFY sortCaseSensitivityChanged
               BINDABLE bindableSortCaseSensitivity)
    Q_PROPERTY(bool isSortLocaleAware READ isSortLocaleAware WRITE setSortLocaleAware
               NOTIFY sortLocaleAwareChanged BINDABLE bindableIsSortLocaleAware)
    Q_PROPERTY(int sortRole READ sortRole WRITE setSortRole NOTIFY sortRoleChanged
               BINDABLE bindableSortRole)
    Q_PROPERTY(int filterRole READ filterRole WRITE setFilterRole NOTIFY filterRoleChanged
               BINDABLE bindableFilterRole)
    Q_PROPERTY(bool recursiveFilteringEnabled READ isRecursiveFilteringEnabled
               WRITE setRecursiveFilteringEnabled NOTIFY recursiveFilteringEnabledChanged
               BINDABLE bindableRecursiveFilteringEnabled)
    Q_PROPERTY(bool autoAcceptChildRows READ autoAcceptChildRows WRITE setAutoAcceptChildRows
               NOTIFY autoAcceptChildRowsChanged BINDABLE bindableAutoAcceptChildRows) +/

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    override void setSourceModel(QAbstractItemModel sourceModel);

    override QModelIndex mapToSource(ref const(QModelIndex) proxyIndex) const;
    override QModelIndex mapFromSource(ref const(QModelIndex) sourceIndex) const;

    override QItemSelection mapSelectionToSource(ref const(QItemSelection) proxySelection) const;
    override QItemSelection mapSelectionFromSource(ref const(QItemSelection) sourceSelection) const;

    final QRegularExpression filterRegularExpression() const;
    //final QBindable!(QRegularExpression) bindableFilterRegularExpression();

    final int filterKeyColumn() const;
    final void setFilterKeyColumn(int column);
    final QBindable!(int) bindableFilterKeyColumn();

    final /+ Qt:: +/qt.core.namespace.CaseSensitivity filterCaseSensitivity() const;
    final void setFilterCaseSensitivity(/+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
    final QBindable!(/+ Qt:: +/qt.core.namespace.CaseSensitivity) bindableFilterCaseSensitivity();

    final /+ Qt:: +/qt.core.namespace.CaseSensitivity sortCaseSensitivity() const;
    final void setSortCaseSensitivity(/+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
    final QBindable!(/+ Qt:: +/qt.core.namespace.CaseSensitivity) bindableSortCaseSensitivity();

    final bool isSortLocaleAware() const;
    final void setSortLocaleAware(bool on);
    final QBindable!(bool) bindableIsSortLocaleAware();

    final int sortColumn() const;
    final /+ Qt:: +/qt.core.namespace.SortOrder sortOrder() const;

    final bool dynamicSortFilter() const;
    final void setDynamicSortFilter(bool enable);
    final QBindable!(bool) bindableDynamicSortFilter();

    final int sortRole() const;
    final void setSortRole(int role);
    final QBindable!(int) bindableSortRole();

    final int filterRole() const;
    final void setFilterRole(int role);
    final QBindable!(int) bindableFilterRole();

    final bool isRecursiveFilteringEnabled() const;
    final void setRecursiveFilteringEnabled(bool recursive);
    final QBindable!(bool) bindableRecursiveFilteringEnabled();

    final bool autoAcceptChildRows() const;
    final void setAutoAcceptChildRows(bool accept);
    final QBindable!(bool) bindableAutoAcceptChildRows();

public /+ Q_SLOTS +/:
    @QSlot final void setFilterRegularExpression(ref const(QString) pattern);
    @QSlot final void setFilterRegularExpression(ref const(QRegularExpression) regularExpression);
    @QSlot final void setFilterWildcard(ref const(QString) pattern);
    @QSlot final void setFilterFixedString(ref const(QString) pattern);
    @QSlot final void invalidate();

protected:
    /+ virtual +/ bool filterAcceptsRow(int source_row, ref const(QModelIndex) source_parent) const;
    /+ virtual +/ bool filterAcceptsColumn(int source_column, ref const(QModelIndex) source_parent) const;
    /+ virtual +/ bool lessThan(ref const(QModelIndex) source_left, ref const(QModelIndex) source_right) const;

    final void invalidateFilter();
    final void invalidateRowsFilter();
    final void invalidateColumnsFilter();

public:
    /+ using QObject::parent; +/

    override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex parent(ref const(QModelIndex) child) const;
    override QModelIndex sibling(int row, int column, ref const(QModelIndex) idx) const;

    override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override int columnCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override bool hasChildren(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;

    override QVariant data(ref const(QModelIndex) index, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override bool setData(ref const(QModelIndex) index, ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);

    override QVariant headerData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override bool setHeaderData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation,
                ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);

    override QMimeData mimeData(ref const(QModelIndexList) indexes) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    override bool dropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                          int row, int column, ref const(QModelIndex) parent);
    }));

    override bool insertRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool insertColumns(int column, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool removeRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool removeColumns(int column, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);

    override void fetchMore(ref const(QModelIndex) parent);
    override bool canFetchMore(ref const(QModelIndex) parent) const;
    override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;

    override QModelIndex buddy(ref const(QModelIndex) index) const;
    override QModelIndexList match(ref const(QModelIndex) start, int role,
                              ref const(QVariant) value, int hits = 1,
                              /+ Qt:: +/qt.core.namespace.MatchFlags flags =
                              /+ Qt:: +/qt.core.namespace.MatchFlags(/+ Qt:: +/qt.core.namespace.MatchFlag.MatchStartsWith|/+ Qt:: +/qt.core.namespace.MatchFlag.MatchWrap)) const;
    override QSize span(ref const(QModelIndex) index) const;
    override void sort(int column, /+ Qt:: +/qt.core.namespace.SortOrder order = /+ Qt:: +/qt.core.namespace.SortOrder.AscendingOrder);

    override QStringList mimeTypes() const;
    override /+ Qt:: +/qt.core.namespace.DropActions supportedDropActions() const;

/+ Q_SIGNALS +/public:
    @QSignal final void dynamicSortFilterChanged(bool dynamicSortFilter);
    @QSignal final void filterCaseSensitivityChanged(/+ Qt:: +/qt.core.namespace.CaseSensitivity filterCaseSensitivity);
    @QSignal final void sortCaseSensitivityChanged(/+ Qt:: +/qt.core.namespace.CaseSensitivity sortCaseSensitivity);
    @QSignal final void sortLocaleAwareChanged(bool sortLocaleAware);
    @QSignal final void sortRoleChanged(int sortRole);
    @QSignal final void filterRoleChanged(int filterRole);
    @QSignal final void recursiveFilteringEnabledChanged(bool recursiveFilteringEnabled);
    @QSignal final void autoAcceptChildRowsChanged(bool autoAcceptChildRows);

private:
    /+ Q_DECLARE_PRIVATE(QSortFilterProxyModel) +/
    /+ Q_DISABLE_COPY(QSortFilterProxyModel) +/

    /+ Q_PRIVATE_SLOT(d_func(),
                   void _q_sourceDataChanged(const QModelIndex &source_top_left, const QModelIndex &source_bottom_right,
                                             const QList<int> &roles))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceHeaderDataChanged(Qt::Orientation orientation, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceAboutToBeReset())
    Q_PRIVATE_SLOT(d_func(), void _q_sourceReset())
    Q_PRIVATE_SLOT(d_func(), void _q_sourceLayoutAboutToBeChanged(const QList<QPersistentModelIndex> &sourceParents, QAbstractItemModel::LayoutChangeHint hint))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceLayoutChanged(const QList<QPersistentModelIndex> &sourceParents, QAbstractItemModel::LayoutChangeHint hint))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceRowsAboutToBeInserted(const QModelIndex &source_parent, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceRowsInserted(const QModelIndex &source_parent, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceRowsAboutToBeRemoved(const QModelIndex &source_parent, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceRowsRemoved(const QModelIndex &source_parent, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceRowsAboutToBeMoved(QModelIndex,int,int,QModelIndex,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceRowsMoved(QModelIndex,int,int,QModelIndex,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceColumnsAboutToBeInserted(const QModelIndex &source_parent, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceColumnsInserted(const QModelIndex &source_parent, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceColumnsAboutToBeRemoved(const QModelIndex &source_parent, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceColumnsRemoved(const QModelIndex &source_parent, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceColumnsAboutToBeMoved(QModelIndex,int,int,QModelIndex,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceColumnsMoved(QModelIndex,int,int,QModelIndex,int))
    Q_PRIVATE_SLOT(d_func(), void _q_clearMapping()) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

