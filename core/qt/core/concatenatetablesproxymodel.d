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
module qt.core.concatenatetablesproxymodel;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.list;
import qt.core.map;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.object;
import qt.core.size;
import qt.core.stringlist;
import qt.core.variant;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(concatenatetablesproxymodel); +/


extern(C++, class) struct QConcatenateTablesProxyModelPrivate;

/// Binding for C++ class [QConcatenateTablesProxyModel](https://doc.qt.io/qt-5/qconcatenatetablesproxymodel.html).
class /+ Q_CORE_EXPORT +/ QConcatenateTablesProxyModel : QAbstractItemModel
{
    mixin(Q_OBJECT);

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    final QList!(QAbstractItemModel) sourceModels() const;
    /+ Q_SCRIPTABLE +/ @QScriptable final void addSourceModel(QAbstractItemModel sourceModel);
    /+ Q_SCRIPTABLE +/ @QScriptable final void removeSourceModel(QAbstractItemModel sourceModel);

    final QModelIndex mapFromSource(ref const(QModelIndex) sourceIndex) const;
    final QModelIndex mapToSource(ref const(QModelIndex) proxyIndex) const;

    override QVariant data(ref const(QModelIndex) index, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override bool setData(ref const(QModelIndex) index, ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);
    override QMap!(int, QVariant) itemData(ref const(QModelIndex) proxyIndex) const;
    override bool setItemData(ref const(QModelIndex) index, ref const(QMap!(int, QVariant)) roles);
    override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;
    override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex parent(ref const(QModelIndex) index) const;
    override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QVariant headerData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override int columnCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QStringList mimeTypes() const;
    override QMimeData mimeData(ref const(QModelIndexList) indexes) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    override bool canDropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action, int row, int column, ref const(QModelIndex) parent) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    override bool dropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action, int row, int column, ref const(QModelIndex) parent);
    }));
    override QSize span(ref const(QModelIndex) index) const;

private:
    /+ Q_DECLARE_PRIVATE(QConcatenateTablesProxyModel) +/
    /+ Q_DISABLE_COPY(QConcatenateTablesProxyModel) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_slotRowsAboutToBeInserted(const QModelIndex &, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_slotRowsInserted(const QModelIndex &, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_slotRowsAboutToBeRemoved(const QModelIndex &, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_slotRowsRemoved(const QModelIndex &, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_slotColumnsAboutToBeInserted(const QModelIndex &parent, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_slotColumnsInserted(const QModelIndex &parent, int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_slotColumnsAboutToBeRemoved(const QModelIndex &parent, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_slotColumnsRemoved(const QModelIndex &parent, int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_slotDataChanged(const QModelIndex &from, const QModelIndex &to, const QVector<int> &roles))
    Q_PRIVATE_SLOT(d_func(), void _q_slotSourceLayoutAboutToBeChanged(QList<QPersistentModelIndex>, QAbstractItemModel::LayoutChangeHint))
    Q_PRIVATE_SLOT(d_func(), void _q_slotSourceLayoutChanged(const QList<QPersistentModelIndex> &, QAbstractItemModel::LayoutChangeHint))
    Q_PRIVATE_SLOT(d_func(), void _q_slotModelAboutToBeReset())
    Q_PRIVATE_SLOT(d_func(), void _q_slotModelReset()) +/
}

