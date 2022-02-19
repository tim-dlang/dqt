module examplewidgets.tabtreeview;

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.namespace;
import qt.core.string;
import qt.core.variant;
import qt.core.vector;
import qt.helpers;
import qt.widgets.ui;
import qt.widgets.widget;

extern(C++, class) struct RandomTreeItem
{
public:
    ~this()
    {
        import qt.core.algorithms;

        qDeleteAll(childs);
    }
    this(int dummy)
    {
        name = QString.create;
        desc = QString.create;
        childs = QVector!(RandomTreeItem*).create();
    }
    QString name;
    QString desc;
    QVector!(RandomTreeItem*) childs;
    RandomTreeItem* parent = null;
    int row = 0;
}

class RandomTreeModel : QAbstractItemModel
{
public:
    /+ explicit +/this()
    {
        root = createItem(null, 0);
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(root);
    }

    final RandomTreeItem* getItem(ref const(QModelIndex) index) const
    {
        if (index.isValid()) {
            RandomTreeItem* parentItem = static_cast!(RandomTreeItem*)(index.internalPointer());
            if (parentItem) {
                int row = index.row();
                if(row >= 0 && row < parentItem.childs.length()) {
                    if(!parentItem.childs[row])
                        parentItem.childs[row] = createItem(parentItem, row);
                    return parentItem.childs[row];
                }
            }
        }
        return cast(RandomTreeItem*)root;
    }
    extern(C++) override int columnCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const
    {
        return 2;
    }
    extern(C++) override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const
    {
        RandomTreeItem* item = getItem(parent);
        if(item)
            return item.childs.length();
        return 0;
    }
    extern(C++) override QVariant data(ref const(QModelIndex) index, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const
    {
        if (!index.isValid())
            return QVariant();

        if (role != /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole && role != /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole)
            return QVariant();

        RandomTreeItem* item = getItem(index);
        if(index.column())
            return QVariant(item.desc);
        else
            return QVariant(item.name);
    }
    extern(C++) override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const
    {
        if (!index.isValid())
            return /+ Qt:: +/qt.core.namespace.ItemFlags.NoItemFlags;

        /+ Qt:: +/qt.core.namespace.ItemFlags r = QAbstractItemModel.flags(index);
        if (index.column() == 1)
            r |= /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsEditable;
        return r;
    }
    extern(C++) override bool setData(ref const(QModelIndex) index, ref const(QVariant) value, int role)
    {
        if (role != /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole)
            return false;

        RandomTreeItem* item = getItem(index);
        if (item && index.column() == 1) {
            item.desc = value.toString();
            QVector!(int) roles = QVector!(int).create();
            roles.append(qt.core.namespace.ItemDataRole.DisplayRole);
            roles.append(qt.core.namespace.ItemDataRole.EditRole);
            /+ emit +/ dataChanged(index, index, roles);
            return true;
        }

        return false;
    }
    extern(C++) override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const
    {
        if (parent.isValid() && parent.column() != 0)
            return QModelIndex();

        RandomTreeItem* parentItem = getItem(parent);
        if (!parentItem)
            return QModelIndex();

        return createIndex(row, column, parentItem);
    }
    extern(C++) override QModelIndex parent(ref const(QModelIndex) index) const
    {
        if (!index.isValid())
            return QModelIndex();
        RandomTreeItem* parentItem = static_cast!(RandomTreeItem*)(index.internalPointer());
        if(parentItem)
            return createIndex(parentItem.row, 0, parentItem.parent);
        return QModelIndex();
    }
    extern(C++) override QVariant headerData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, int role) const
    {
        if (orientation == /+ Qt:: +/qt.core.namespace.Orientation.Horizontal && role == /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) {
            if(section == 0)
                return QVariant(QString("Name"));
            else if(section == 1)
                return QVariant(QString("Description"));
        }

        return QVariant();
    }

private:
    RandomTreeItem* root;

    final RandomTreeItem* createItem(RandomTreeItem* parent, int row) const
    {
        import core.stdcpp.new_;
        import core.stdc.stdlib;

        RandomTreeItem* item = cpp_new!RandomTreeItem(0);
        item.parent = parent;
        item.row = row;
        item.childs.resize(5);
        item.name = QString.number(rand());
        return item;
    }
}

class TabTreeView : QWidget
{
    mixin(Q_OBJECT_D);

public:
    /+ explicit +/this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);
        model = cpp_new!RandomTreeModel();
        ui.treeView.setModel(model);
        ui.treeView.setColumnWidth(0, 200);
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
        cpp_delete(model);
    }

private:
    UIStruct!"tabtreeview.ui"* ui;
    RandomTreeModel model;
}

