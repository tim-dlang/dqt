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
module qt.core.stringlistmodel;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.map;
import qt.core.namespace;
import qt.core.object;
import qt.core.stringlist;
import qt.core.variant;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(stringlistmodel); +/


/// Binding for C++ class [QStringListModel](https://doc.qt.io/qt-5/qstringlistmodel.html).
class /+ Q_CORE_EXPORT +/ QStringListModel : QAbstractListModel
{
    mixin(Q_OBJECT);
public:
    /+ explicit +/this(QObject parent = null);
    /+ explicit +/this(ref const(QStringList) strings, QObject parent = null);

    override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex sibling(int row, int column, ref const(QModelIndex) idx) const;

    override QVariant data(ref const(QModelIndex) index, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override bool setData(ref const(QModelIndex) index, ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);
/+ #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    bool clearItemData(const QModelIndex &index) override;
#endif +/

    override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;

    override bool insertRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool removeRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool moveRows(ref const(QModelIndex) sourceParent, int sourceRow, int count, ref const(QModelIndex) destinationParent, int destinationChild);

    override QMap!(int, QVariant) itemData(ref const(QModelIndex) index) const;
    override bool setItemData(ref const(QModelIndex) index, ref const(QMap!(int, QVariant)) roles);

    override void sort(int column, /+ Qt:: +/qt.core.namespace.SortOrder order = /+ Qt:: +/qt.core.namespace.SortOrder.AscendingOrder);

    final QStringList stringList() const;
    final void setStringList(ref const(QStringList) strings);

    override /+ Qt:: +/qt.core.namespace.DropActions supportedDropActions() const;

private:
    /+ Q_DISABLE_COPY(QStringListModel) +/
    QStringList lst;
}

