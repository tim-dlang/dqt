module examplewidgets.tabtreewidget;

import qt.config;
import qt.core.point;
import qt.core.string;
import qt.helpers;
import qt.widgets.ui;
import qt.widgets.widget;

class TabTreeWidget : QWidget
{
    mixin(Q_OBJECT_D);

public:
    /+ explicit +/this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);
        ui.treeWidget.setColumnWidth(0, 200);
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
    }

private /+ slots +/:
    @QSlot final void on_treeWidget_customContextMenuRequested(ref const(QPoint) pos)
    {
        import core.stdcpp.new_;
        import qt.core.namespace;
        import qt.gui.brush;
        import qt.gui.color;
        import qt.gui.font;
        import qt.widgets.action;
        import qt.widgets.colordialog;
        import qt.widgets.fontdialog;
        import qt.widgets.menu;
        import qt.widgets.treewidget;

        QTreeWidgetItem item = ui.treeWidget.itemAt(pos);
        QMenu menu = cpp_new!QMenu;
        if (item)
        {
            QAction action = menu.addAction("Selected: " ~ item.text(0));
            action.setEnabled(false);

            action = menu.addAction(QString("Remove"));
            connect(action.signal!"triggered", menu, () {
                cpp_delete(item);
            });

            action = menu.addAction(QString("Add child"));
            connect(action.signal!"triggered", menu, () {
                QTreeWidgetItem child = cpp_new!QTreeWidgetItem();
                child.setText(0, QString("New child"));
                child.setFlags(child.flags() | /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsEditable);
                item.addChild(child);
                ui.treeWidget.setCurrentItem(child);
                ui.treeWidget.editItem(child, 0);
            });

            action = menu.addAction(QString("Add sibling before"));
            connect(action.signal!"triggered", menu, () {
                QTreeWidgetItem sibling = cpp_new!QTreeWidgetItem();
                sibling.setText(0, QString("New sibling"));
                sibling.setFlags(sibling.flags() | /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsEditable);
                if (item.parent())
                    item.parent().insertChild(item.parent().indexOfChild(item), sibling);
                else
                    ui.treeWidget.insertTopLevelItem(ui.treeWidget.indexOfTopLevelItem(item), sibling);
                ui.treeWidget.setCurrentItem(sibling);
                ui.treeWidget.editItem(sibling, 0);
            });

            action = menu.addAction(QString("Add sibling after"));
            connect(action.signal!"triggered", menu, () {
                QTreeWidgetItem sibling = cpp_new!QTreeWidgetItem();
                sibling.setText(0, QString("New sibling"));
                sibling.setFlags(sibling.flags() | /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsEditable);
                if (item.parent())
                    item.parent().insertChild(item.parent().indexOfChild(item) + 1, sibling);
                else
                    ui.treeWidget.insertTopLevelItem(ui.treeWidget.indexOfTopLevelItem(item) + 1, sibling);
                ui.treeWidget.setCurrentItem(sibling);
                ui.treeWidget.editItem(sibling, 0);
            });

            action = menu.addAction(QString("Change font"));
            connect(action.signal!"triggered", menu, () {
                QFont font = item.font(0);
                bool ok;
                font = QFontDialog.getFont(&ok, font, this);
                if (ok)
                {
                    item.setFont(0, font);
                    item.setFont(1, font);
                }
            });

            action = menu.addAction(QString("Change background color"));
            connect(action.signal!"triggered", menu, () {
                QBrush brush = item.background(0);
                QColor color = QColorDialog.getColor(brush.color(), this);
                if (color.isValid())
                {
                    brush.setColor(color);
                    brush = QBrush(color);
                    item.setBackground(0, brush);
                    item.setBackground(1, brush);
                }
            });
        }
        else
        {
            QAction action = menu.addAction(QString("No item selected"));
            action.setEnabled(false);

            action = menu.addAction(QString("Add top level item"));
            connect(action.signal!"triggered", menu, () {
                QTreeWidgetItem item2 = cpp_new!QTreeWidgetItem();
                item2.setText(0, QString("New item"));
                item2.setFlags(item2.flags() | /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsEditable);
                    ui.treeWidget.addTopLevelItem(item2);
                ui.treeWidget.setCurrentItem(item2);
                ui.treeWidget.editItem(item2, 0);
            });
        }

        menu.exec(ui.treeWidget.mapToGlobal(pos));
        cpp_delete(menu);
    }

private:
    UIStruct!"tabtreewidget.ui"* ui;
}

