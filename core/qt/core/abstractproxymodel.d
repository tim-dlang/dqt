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
module qt.core.abstractproxymodel;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.itemselectionmodel;
import qt.core.map;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.object;
import qt.core.size;
import qt.core.stringlist;
import qt.core.variant;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(proxymodel); +/


extern(C++, class) struct QAbstractProxyModelPrivate;

/// Binding for C++ class [QAbstractProxyModel](https://doc.qt.io/qt-5/qabstractproxymodel.html).
abstract class /+ Q_CORE_EXPORT +/ QAbstractProxyModel : QAbstractItemModel
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QAbstractItemModel* sourceModel READ sourceModel WRITE setSourceModel NOTIFY sourceModelChanged) +/

public:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QObject parent = null);
    }));
    ~this();

    /+ virtual +/ void setSourceModel(QAbstractItemModel sourceModel);
    final QAbstractItemModel sourceModel() const;

    /+ virtual +/ @QInvokable abstract QModelIndex mapToSource(ref const(QModelIndex) proxyIndex) const;
    /+ virtual +/ @QInvokable abstract QModelIndex mapFromSource(ref const(QModelIndex) sourceIndex) const;

    /+ virtual +/ @QInvokable QItemSelection mapSelectionToSource(ref const(QItemSelection) selection) const;
    /+ virtual +/ @QInvokable QItemSelection mapSelectionFromSource(ref const(QItemSelection) selection) const;

    override bool submit();
    override void revert();

    override QVariant data(ref const(QModelIndex) proxyIndex, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override QVariant headerData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override QMap!(int, QVariant) itemData(ref const(QModelIndex) index) const;
    override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;

    override bool setData(ref const(QModelIndex) index, ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);
    override bool setItemData(ref const(QModelIndex) index, ref const(QMap!(int, QVariant)) roles);
    override bool setHeaderData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);
/+ #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    bool clearItemData(const QModelIndex &index) override;
#endif +/

    override QModelIndex buddy(ref const(QModelIndex) index) const;
    override bool canFetchMore(ref const(QModelIndex) parent) const;
    override void fetchMore(ref const(QModelIndex) parent);
    override void sort(int column, /+ Qt:: +/qt.core.namespace.SortOrder order = /+ Qt:: +/qt.core.namespace.SortOrder.AscendingOrder);
    override QSize span(ref const(QModelIndex) index) const;
    override bool hasChildren(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex sibling(int row, int column, ref const(QModelIndex) idx) const;

    override QMimeData mimeData(ref const(QModelIndexList) indexes) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    override bool canDropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                             int row, int column, ref const(QModelIndex) parent) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    override bool dropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                          int row, int column, ref const(QModelIndex) parent);
    }));
    override QStringList mimeTypes() const;
    override /+ Qt:: +/qt.core.namespace.DropActions supportedDragActions() const;
    override /+ Qt:: +/qt.core.namespace.DropActions supportedDropActions() const;

/+ Q_SIGNALS +/public:
    @QSignal final void sourceModelChanged(QPrivateSignal);

protected /+ Q_SLOTS +/:
//    @QSlot final void resetInternalData();

protected:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QAbstractProxyModelPrivate , QObject parent);
    }));

private:
    /+ Q_DECLARE_PRIVATE(QAbstractProxyModel) +/
    /+ Q_DISABLE_COPY(QAbstractProxyModel) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_sourceModelDestroyed()) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

