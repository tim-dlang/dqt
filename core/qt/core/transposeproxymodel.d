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
module qt.core.transposeproxymodel;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.abstractproxymodel;
import qt.core.map;
import qt.core.namespace;
import qt.core.object;
import qt.core.size;
import qt.core.variant;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(transposeproxymodel); +/



/// Binding for C++ class [QTransposeProxyModel](https://doc.qt.io/qt-6/qtransposeproxymodel.html).
class /+ Q_CORE_EXPORT +/ QTransposeProxyModel : QAbstractProxyModel
{
    mixin(Q_OBJECT);
    /+ Q_DISABLE_COPY(QTransposeProxyModel) +/
    /+ Q_DECLARE_PRIVATE(QTransposeProxyModel) +/
public:
    /+ explicit +/this(QObject parent = null);
    ~this();
    override void setSourceModel(QAbstractItemModel newSourceModel);
    override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override int columnCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QVariant headerData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override bool setHeaderData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);
    override bool setItemData(ref const(QModelIndex) index, ref const(QMap!(int, QVariant)) roles);
    override QSize span(ref const(QModelIndex) index) const;
    override QMap!(int, QVariant) itemData(ref const(QModelIndex) index) const;
    override QModelIndex mapFromSource(ref const(QModelIndex) sourceIndex) const;
    override QModelIndex mapToSource(ref const(QModelIndex) proxyIndex) const;
    override QModelIndex parent(ref const(QModelIndex) index) const;
    override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override bool insertRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool removeRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool moveRows(ref const(QModelIndex) sourceParent, int sourceRow, int count, ref const(QModelIndex) destinationParent, int destinationChild);
    override bool insertColumns(int column, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool removeColumns(int column, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool moveColumns(ref const(QModelIndex) sourceParent, int sourceColumn, int count, ref const(QModelIndex) destinationParent, int destinationChild);
    override void sort(int column, /+ Qt:: +/qt.core.namespace.SortOrder order = /+ Qt:: +/qt.core.namespace.SortOrder.AscendingOrder);
protected:
    this(ref QTransposeProxyModelPrivate , QObject parent);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

