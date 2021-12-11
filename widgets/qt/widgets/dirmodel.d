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
module qt.widgets.dirmodel;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.dir;
import qt.core.fileinfo;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.core.stringlist;
import qt.core.variant;
import qt.gui.icon;
import qt.helpers;
import qt.widgets.fileiconprovider;

/+ #if QT_DEPRECATED_SINCE(5, 15) +/

/+ QT_REQUIRE_CONFIG(dirmodel); +/


extern(C++, class) struct QDirModelPrivate;

class /+ Q_WIDGETS_EXPORT +/ QDirModel : QAbstractItemModel
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool resolveSymlinks READ resolveSymlinks WRITE setResolveSymlinks)
    Q_PROPERTY(bool readOnly READ isReadOnly WRITE setReadOnly)
    Q_PROPERTY(bool lazyChildCount READ lazyChildCount WRITE setLazyChildCount) +/

public:
/*    enum Roles {
        FileIconRole = /+ Qt:: +/qt.core.namespace.ItemDataRole.DecorationRole,
        FilePathRole = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole + 1,
        FileNameRole
    }*/

    /+ QT_DEPRECATED_VERSION_X_5_15("Use QFileSystemModel") +/this(ref const(QStringList) nameFilters,
                  QDir.Filters filters, QDir.SortFlags sort,
                  QObject parent = null);
    /+ QT_DEPRECATED_VERSION_X_5_15("Use QFileSystemModel") +/ /+ explicit +/this(QObject parent = null);
    ~this();

    override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex parent(ref const(QModelIndex) child) const;

    override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override int columnCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;

    override QVariant data(ref const(QModelIndex) index, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override bool setData(ref const(QModelIndex) index, ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);

    override QVariant headerData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;

    override bool hasChildren(ref const(QModelIndex) index = globalInitVar!QModelIndex) const;
    override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;

    override void sort(int column, /+ Qt:: +/qt.core.namespace.SortOrder order = /+ Qt:: +/qt.core.namespace.SortOrder.AscendingOrder);

    override QStringList mimeTypes() const;
    override QMimeData mimeData(ref const(QModelIndexList) indexes) const;
    override bool dropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                          int row, int column, ref const(QModelIndex) parent);
    override /+ Qt:: +/qt.core.namespace.DropActions supportedDropActions() const;

    // QDirModel specific API

    final void setIconProvider(QFileIconProvider provider);
    final QFileIconProvider iconProvider() const;

    final void setNameFilters(ref const(QStringList) filters);
    final QStringList nameFilters() const;

    final void setFilter(QDir.Filters filters);
    final QDir.Filters filter() const;

    final void setSorting(QDir.SortFlags sort);
    final QDir.SortFlags sorting() const;

    final void setResolveSymlinks(bool enable);
    final bool resolveSymlinks() const;

    final void setReadOnly(bool enable);
    final bool isReadOnly() const;

    final void setLazyChildCount(bool enable);
    final bool lazyChildCount() const;

    final QModelIndex index(ref const(QString) path, int column = 0) const;

    final bool isDir(ref const(QModelIndex) index) const;
    final QModelIndex mkdir(ref const(QModelIndex) parent, ref const(QString) name);
    final bool rmdir(ref const(QModelIndex) index);
    final bool remove(ref const(QModelIndex) index);

    final QString filePath(ref const(QModelIndex) index) const;
    final QString fileName(ref const(QModelIndex) index) const;
    final QIcon fileIcon(ref const(QModelIndex) index) const;
    final QFileInfo fileInfo(ref const(QModelIndex) index) const;

    /+ using QObject::parent; +/

public /+ Q_SLOTS +/:
    @QSlot final void refresh(ref const(QModelIndex) parent = globalInitVar!QModelIndex);

protected:
    this(ref QDirModelPrivate , QObject parent = null);
    /+ friend class QFileDialogPrivate; +/

private:
    /+ Q_DECLARE_PRIVATE(QDirModel) +/
    /+ Q_DISABLE_COPY(QDirModel) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_refresh()) +/
}


/+ #endif +/ // QT_DEPRECATED_SINCE(5, 15)

