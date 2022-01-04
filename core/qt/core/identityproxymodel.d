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
module qt.core.identityproxymodel;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.abstractproxymodel;
import qt.core.itemselectionmodel;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.object;
import qt.core.variant;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(identityproxymodel); +/



extern(C++, class) struct QIdentityProxyModelPrivate;

/// Binding for C++ class [QIdentityProxyModel](https://doc.qt.io/qt-5/qidentityproxymodel.html).
class /+ Q_CORE_EXPORT +/ QIdentityProxyModel : QAbstractProxyModel
{
    mixin(Q_OBJECT);
public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    override int columnCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex mapFromSource(ref const(QModelIndex) sourceIndex) const;
    override QModelIndex mapToSource(ref const(QModelIndex) proxyIndex) const;
    override QModelIndex parent(ref const(QModelIndex) child) const;
    /+ using QObject::parent; +/
    override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QVariant headerData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    override bool dropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action, int row, int column, ref const(QModelIndex) parent);
    }));
    override QModelIndex sibling(int row, int column, ref const(QModelIndex) idx) const;

    override QItemSelection mapSelectionFromSource(ref const(QItemSelection) selection) const;
    override QItemSelection mapSelectionToSource(ref const(QItemSelection) selection) const;
    override QModelIndexList match(ref const(QModelIndex) start, int role, ref const(QVariant) value, int hits = 1, /+ Qt:: +/qt.core.namespace.MatchFlags flags = /+ Qt:: +/qt.core.namespace.MatchFlags(/+ Qt:: +/qt.core.namespace.MatchFlag.MatchStartsWith|/+ Qt:: +/qt.core.namespace.MatchFlag.MatchWrap)) const;
    override void setSourceModel(QAbstractItemModel sourceModel);

    override bool insertColumns(int column, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool insertRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool removeColumns(int column, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool removeRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool moveRows(ref const(QModelIndex) sourceParent, int sourceRow, int count, ref const(QModelIndex) destinationParent, int destinationChild);
    override bool moveColumns(ref const(QModelIndex) sourceParent, int sourceColumn, int count, ref const(QModelIndex) destinationParent, int destinationChild);

protected:
    this(ref QIdentityProxyModelPrivate dd, QObject parent);

private:
    /+ Q_DECLARE_PRIVATE(QIdentityProxyModel) +/
    /+ Q_DISABLE_COPY(QIdentityProxyModel) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_sourceRowsAboutToBeInserted(QModelIndex,int,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceRowsInserted(QModelIndex,int,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceRowsAboutToBeRemoved(QModelIndex,int,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceRowsRemoved(QModelIndex,int,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceRowsAboutToBeMoved(QModelIndex,int,int,QModelIndex,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceRowsMoved(QModelIndex,int,int,QModelIndex,int))

    Q_PRIVATE_SLOT(d_func(), void _q_sourceColumnsAboutToBeInserted(QModelIndex,int,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceColumnsInserted(QModelIndex,int,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceColumnsAboutToBeRemoved(QModelIndex,int,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceColumnsRemoved(QModelIndex,int,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceColumnsAboutToBeMoved(QModelIndex,int,int,QModelIndex,int))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceColumnsMoved(QModelIndex,int,int,QModelIndex,int))

    Q_PRIVATE_SLOT(d_func(), void _q_sourceDataChanged(QModelIndex,QModelIndex,QVector<int>))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceHeaderDataChanged(Qt::Orientation orientation, int first, int last))

    Q_PRIVATE_SLOT(d_func(), void _q_sourceLayoutAboutToBeChanged(const QList<QPersistentModelIndex> &sourceParents, QAbstractItemModel::LayoutChangeHint hint))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceLayoutChanged(const QList<QPersistentModelIndex> &sourceParents, QAbstractItemModel::LayoutChangeHint hint))
    Q_PRIVATE_SLOT(d_func(), void _q_sourceModelAboutToBeReset())
    Q_PRIVATE_SLOT(d_func(), void _q_sourceModelReset()) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

