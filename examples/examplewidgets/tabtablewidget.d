module examplewidgets.tabtablewidget;

import qt.config;
import qt.core.point;
import qt.core.string;
import qt.helpers;
import qt.widgets.ui;
import qt.widgets.widget;

class TabTableWidget : QWidget
{
    mixin(Q_OBJECT_D);

public:
    /+ explicit +/this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);

        ui.tableWidget.setColumnCount(3);
        ui.tableWidget.setRowCount(5);
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
    }

private /+ slots +/:
    @QSlot final void on_tableWidget_customContextMenuRequested(ref const(QPoint) pos)
    {
        import core.stdcpp.new_;
        import qt.gui.brush;
        import qt.gui.color;
        import qt.gui.font;
        import qt.widgets.action;
        import qt.widgets.colordialog;
        import qt.widgets.fontdialog;
        import qt.widgets.inputdialog;
        import qt.widgets.lineedit;
        import qt.widgets.menu;
        import qt.widgets.tablewidget;

        int currentRow = ui.tableWidget.rowAt(pos.y());
        int currentColumn = ui.tableWidget.columnAt(pos.x());
        QMenu menu = cpp_new!QMenu;
        if (currentRow >= 0)
        {
            QAction action = menu.addAction("Current row = " ~ QString.number(currentRow));
            action.setEnabled(false);

            action = menu.addAction("Remove row");
            connect(action.signal!"triggered", menu, () {
                ui.tableWidget.removeRow(currentRow);
            });

            action = menu.addAction("Add row before");
            connect(action.signal!"triggered", menu, () {
                ui.tableWidget.insertRow(currentRow);
            });

            action = menu.addAction("Add row after");
            connect(action.signal!"triggered", menu, () {
                ui.tableWidget.insertRow(currentRow + 1);
            });

            action = menu.addAction("Change row header");
            connect(action.signal!"triggered", menu, () {
                QTableWidgetItem item = ui.tableWidget.verticalHeaderItem(currentRow);
                bool ok;
                QString text = QString.create;
                if (item)
                    text = item.text();
                text = QInputDialog.getText(this, QString.create(), "Row header", QLineEdit.EchoMode.Normal, text, &ok);
                if (ok)
                {
                    if (text.isEmpty())
                    {
                        if (item)
                            cpp_delete(item);
                    }
                    else
                    {
                        if (!item)
                        {
                            item = cpp_new!QTableWidgetItem;
                            ui.tableWidget.setVerticalHeaderItem(currentRow, item);
                        }
                        item.setText(text);
                    }
                }
            });
        }
        else
        {
            QAction action = menu.addAction("No row selected");
            action.setEnabled(false);

            action = menu.addAction("Add row");
            connect(action.signal!"triggered", menu, () {
                ui.tableWidget.insertRow(ui.tableWidget.rowCount());
            });
        }

        if (currentColumn >= 0)
        {
            QAction action = menu.addAction("Current column = " ~ QString.number(currentColumn));
            action.setEnabled(false);

            action = menu.addAction("Remove column");
            connect(action.signal!"triggered", menu, () {
                ui.tableWidget.removeColumn(currentColumn);
            });

            action = menu.addAction("Add column before");
            connect(action.signal!"triggered", menu, () {
                ui.tableWidget.insertColumn(currentColumn);
            });

            action = menu.addAction("Add column after");
            connect(action.signal!"triggered", menu, () {
                ui.tableWidget.insertColumn(currentColumn + 1);
            });

            action = menu.addAction("Change column header");
            connect(action.signal!"triggered", menu, () {
                QTableWidgetItem item = ui.tableWidget.horizontalHeaderItem(currentColumn);
                bool ok;
                QString text = QString.create;
                if (item)
                    text = item.text();
                text = QInputDialog.getText(this, QString.create(), "Column header", QLineEdit.EchoMode.Normal, text, &ok);
                if (ok)
                {
                    if (text.isEmpty())
                    {
                        if (item)
                            cpp_delete(item);
                    }
                    else
                    {
                        if (!item)
                        {
                            item = cpp_new!QTableWidgetItem;
                            ui.tableWidget.setHorizontalHeaderItem(currentColumn, item);
                        }
                        item.setText(text);
                    }
                }
            });
        }
        else
        {
            QAction action = menu.addAction("No column selected");
            action.setEnabled(false);

            action = menu.addAction("Add column");
            connect(action.signal!"triggered", menu, () {
                ui.tableWidget.insertColumn(ui.tableWidget.columnCount());
            });
        }

        if (currentColumn >= 0 && currentRow >= 0)
        {
            QTableWidgetItem item = ui.tableWidget.item(currentRow, currentColumn);
            if (!item)
            {
                item = cpp_new!QTableWidgetItem();
                ui.tableWidget.setItem(currentRow, currentColumn, item);
            }

            QAction action = menu.addAction("Item");
            action.setEnabled(false);

            action = menu.addAction("Change font");
            connect(action.signal!"triggered", menu, () {
                QFont font = item.font();
                bool ok;
                font = QFontDialog.getFont(&ok, font, this);
                if (ok)
                    item.setFont(font);
            });

            action = menu.addAction("Change background color");
            connect(action.signal!"triggered", menu, () {
                QBrush brush = item.background();
                QColor color = QColorDialog.getColor(brush.color(), this);
                if (color.isValid())
                {
                    brush = QBrush(color);
                    item.setBackground(brush);
                }
            });
        }

        menu.exec(ui.tableWidget.mapToGlobal(pos));
        cpp_delete(menu);
    }

private:
    UIStruct!"tabtablewidget.ui"* ui;
}

