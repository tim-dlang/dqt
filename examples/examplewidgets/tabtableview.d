module examplewidgets.tabtableview;

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.map;
import qt.core.namespace;
import qt.core.pair;
import qt.core.string;
import qt.core.variant;
import qt.core.vector;
import qt.helpers;
import qt.widgets.ui;
import qt.widgets.widget;

class SimpleTableModel : QAbstractItemModel
{
public:
    /+ explicit +/this()
    {
    }
    ~this()
    {
    }

    extern(C++) override int columnCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const
    {
        return 256;
    }
    extern(C++) override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const
    {
        return 65536;
    }
    extern(C++) override QVariant data(ref const(QModelIndex) index, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const
    {
        if (!index.isValid())
            return QVariant();

        if (role != /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole && role != /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole)
            return QVariant();

        int[2] key = [index.column(), index.row()];
        if (key in content)
            return QVariant(content[key]);

        return QVariant(QString(""));
    }
    extern(C++) override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const
    {
        if (!index.isValid())
            return /+ Qt:: +/qt.core.namespace.ItemFlags.NoItemFlags;

        return QAbstractItemModel.flags(index) | /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsEditable;
    }
    extern(C++) override bool setData(ref const(QModelIndex) index, ref const(QVariant) value, int role)
    {
        if (role != /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole)
            return false;

        int[2] key = [index.column(), index.row()];
        content[key] = value.toString();
        QVector!(int) roles = QVector!(int).create();
        roles.append(qt.core.namespace.ItemDataRole.DisplayRole);
        roles.append(qt.core.namespace.ItemDataRole.EditRole);
        /+ emit +/ dataChanged(index, index, roles);

        return true;
    }
    extern(C++) override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const
    {
        if (parent.isValid())
            return QModelIndex();

        return createIndex(row, column, null);
    }
    extern(C++) override QModelIndex parent(ref const(QModelIndex) index) const
    {
        return QModelIndex();
    }
    extern(C++) override QVariant headerData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, int role) const
    {
        if (orientation == /+ Qt:: +/qt.core.namespace.Orientation.Horizontal && role == /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole)
        {
            char[3] text;
            if (section < 26)
            {
                text[0] = cast(char) ('A' + section);
                text[1] = 0;
                return QVariant(QString.fromUtf8(text.ptr));
            }
            if (section - 26 < 26 * 26)
            {
                text[0] = cast(char) ('A' + (section - 26) / 26);
                text[1] = cast(char) ('A' + (section - 26) % 26);
                text[2] = 0;
                return QVariant(QString.fromUtf8(text.ptr));
            }
        }

        if (orientation == /+ Qt:: +/qt.core.namespace.Orientation.Vertical && role == /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole)
        {
            return QVariant(QString.number(section + 1));
        }

        return QVariant();
    }

private:
    QString[int[2]] content;
}

class TabTableView : QWidget
{
    mixin(Q_OBJECT_D);

public:
    /+ explicit +/this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);
        model = cpp_new!SimpleTableModel();
        ui.tableView.setModel(model);
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
        cpp_delete(model);
    }

private:
    UIStruct!"tabtableview.ui"* ui;
    SimpleTableModel model;
}

