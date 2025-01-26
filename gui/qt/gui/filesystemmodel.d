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
module qt.gui.filesystemmodel;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.bytearray;
import qt.core.coreevent;
import qt.core.datetime;
import qt.core.dir;
import qt.core.file;
import qt.core.fileinfo;
import qt.core.flags;
import qt.core.global;
import qt.core.hash;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.core.stringlist;
import qt.core.variant;
import qt.gui.abstractfileiconprovider;
import qt.gui.icon;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(filesystemmodel); +/


extern(C++, class) struct ExtendedInformation;
extern(C++, class) struct QFileSystemModelPrivate;

/// Binding for C++ class [QFileSystemModel](https://doc.qt.io/qt-6/qfilesystemmodel.html).
class /+ Q_GUI_EXPORT +/ QFileSystemModel : QAbstractItemModel
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool resolveSymlinks READ resolveSymlinks WRITE setResolveSymlinks)
    Q_PROPERTY(bool readOnly READ isReadOnly WRITE setReadOnly)
    Q_PROPERTY(bool nameFilterDisables READ nameFilterDisables WRITE setNameFilterDisables)
    Q_PROPERTY(Options options READ options WRITE setOptions) +/

/+ Q_SIGNALS +/public:
    @QSignal final void rootPathChanged(ref const(QString) newPath);
    @QSignal final void fileRenamed(ref const(QString) path, ref const(QString) oldName, ref const(QString) newName);
    @QSignal final void directoryLoaded(ref const(QString) path);

public:
    enum Roles {
        FileIconRole = uint(/+ Qt:: +/qt.core.namespace.ItemDataRole.DecorationRole),
        FilePathRole = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole + 1,
        FileNameRole = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole + 2,
        FilePermissions = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole + 3
    }

    enum Option
    {
        DontWatchForChanges         = 0x00000001,
        DontResolveSymlinks         = 0x00000002,
        DontUseCustomDirectoryIcons = 0x00000004
    }
    /+ Q_ENUM(Option) +/
    /+ Q_DECLARE_FLAGS(Options, Option) +/
alias Options = QFlags!(Option);
    /+ explicit +/this(QObject parent = null);
    ~this();

    override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    final QModelIndex index(ref const(QString) path, int column = 0) const;
    override QModelIndex parent(ref const(QModelIndex) child) const;
    /+ using QObject::parent; +/
    override QModelIndex sibling(int row, int column, ref const(QModelIndex) idx) const;
    override bool hasChildren(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override bool canFetchMore(ref const(QModelIndex) parent) const;
    override void fetchMore(ref const(QModelIndex) parent);

    override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override int columnCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;

    final QVariant myComputer(int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override QVariant data(ref const(QModelIndex) index, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override bool setData(ref const(QModelIndex) index, ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);

    override QVariant headerData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;

    override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;

    override void sort(int column, /+ Qt:: +/qt.core.namespace.SortOrder order = /+ Qt:: +/qt.core.namespace.SortOrder.AscendingOrder);

    override QStringList mimeTypes() const;
    override QMimeData mimeData(ref const(QModelIndexList) indexes) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    override bool dropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                          int row, int column, ref const(QModelIndex) parent);
    }));
    override /+ Qt:: +/qt.core.namespace.DropActions supportedDropActions() const;
    override QHash!(int, QByteArray) roleNames() const;

    // QFileSystemModel specific API
    final QModelIndex setRootPath(ref const(QString) path);
    final QString rootPath() const;
    final QDir rootDirectory() const;

    final void setIconProvider(QAbstractFileIconProvider provider);
    final QAbstractFileIconProvider iconProvider() const;

    final void setFilter(QDir.Filters filters);
    final QDir.Filters filter() const;

    final void setResolveSymlinks(bool enable);
    final bool resolveSymlinks() const;

    final void setReadOnly(bool enable);
    final bool isReadOnly() const;

    final void setNameFilterDisables(bool enable);
    final bool nameFilterDisables() const;

    final void setNameFilters(ref const(QStringList) filters);
    final QStringList nameFilters() const;

    final void setOption(Option option, bool on = true);
    final bool testOption(Option option) const;
    final void setOptions(Options options);
    final Options options() const;

    final QString filePath(ref const(QModelIndex) index) const;
    final bool isDir(ref const(QModelIndex) index) const;
    final qint64 size(ref const(QModelIndex) index) const;
    final QString type(ref const(QModelIndex) index) const;
    final QDateTime lastModified(ref const(QModelIndex) index) const;

    final QModelIndex mkdir(ref const(QModelIndex) parent, ref const(QString) name);
    final bool rmdir(ref const(QModelIndex) index);
    pragma(inline, true) final QString fileName(ref const(QModelIndex) aindex) const
    { return aindex.data(/+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole).toString(); }
    pragma(inline, true) final QIcon fileIcon(ref const(QModelIndex) aindex) const
    { return qvariant_cast!(QIcon)(aindex.data(/+ Qt:: +/qt.core.namespace.ItemDataRole.DecorationRole)); }
    final QFile.Permissions permissions(ref const(QModelIndex) index) const;
    final QFileInfo fileInfo(ref const(QModelIndex) index) const;
    final bool remove(ref const(QModelIndex) index);

protected:
    this(ref QFileSystemModelPrivate , QObject parent = null);
    override void timerEvent(QTimerEvent event);
    override bool event(QEvent event);

private:
    /+ Q_DECLARE_PRIVATE(QFileSystemModel) +/
    /+ Q_DISABLE_COPY(QFileSystemModel) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_directoryChanged(const QString &directory, const QStringList &list))
    Q_PRIVATE_SLOT(d_func(), void _q_performDelayedSort())
    Q_PRIVATE_SLOT(d_func(),
                   void _q_fileSystemChanged(const QString &path,
                                             const QList<QPair<QString, QFileInfo>> &))
    Q_PRIVATE_SLOT(d_func(), void _q_resolvedName(const QString &fileName, const QString &resolvedName)) +/

    /+ friend class QFileDialogPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QFileSystemModel.Options.enum_type) operator |(QFileSystemModel.Options.enum_type f1, QFileSystemModel.Options.enum_type f2)/+noexcept+/{return QFlags!(QFileSystemModel.Options.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QFileSystemModel.Options.enum_type) operator |(QFileSystemModel.Options.enum_type f1, QFlags!(QFileSystemModel.Options.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QFileSystemModel.Options.enum_type) operator &(QFileSystemModel.Options.enum_type f1, QFileSystemModel.Options.enum_type f2)/+noexcept+/{return QFlags!(QFileSystemModel.Options.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QFileSystemModel.Options.enum_type) operator &(QFileSystemModel.Options.enum_type f1, QFlags!(QFileSystemModel.Options.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QFileSystemModel.Options.enum_type) operator ^(QFileSystemModel.Options.enum_type f1, QFileSystemModel.Options.enum_type f2)/+noexcept+/{return QFlags!(QFileSystemModel.Options.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QFileSystemModel.Options.enum_type) operator ^(QFileSystemModel.Options.enum_type f1, QFlags!(QFileSystemModel.Options.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QFileSystemModel.Options.enum_type f1, QFileSystemModel.Options.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QFileSystemModel.Options.enum_type f1, QFlags!(QFileSystemModel.Options.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QFileSystemModel.Options.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QFileSystemModel.Options.enum_type f1, QFileSystemModel.Options.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QFileSystemModel.Options.enum_type f1, QFlags!(QFileSystemModel.Options.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QFileSystemModel.Options.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFileSystemModel.Options.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QFileSystemModel.Options.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFileSystemModel.Options.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QFileSystemModel.Options.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QFileSystemModel.Options operator ~(QFileSystemModel.Options.enum_type e)/+noexcept+/{return~QFileSystemModel.Options(e);}+/
/+pragma(inline, true) void operator |(QFileSystemModel.Options.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QFileSystemModel.Options.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QFileSystemModel::Options) +/
