module examplewidgets.tablistwidget;

import qt.config;
import qt.helpers;
import qt.widgets.ui;
import qt.widgets.widget;

class TabListWidget : QWidget
{
    mixin(Q_OBJECT_D);

public:
    /+ explicit +/this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
    }

private /+ slots +/:
    @QSlot final void on_listWidget_currentRowChanged(int currentRow)
    {
        ui.pushButtonRemove.setEnabled(currentRow >= 0);
    }

    @QSlot final void on_pushButtonAdd_clicked()
    {
        ui.listWidget.addItem(ui.lineEditNew.text());
    }

    @QSlot final void on_pushButtonRemove_clicked()
    {
        import core.stdcpp.new_;
        import qt.widgets.listwidget;

        QListWidgetItem item = ui.listWidget.currentItem();
        if (item)
            cpp_delete(item);
    }

private:
    UIStruct!"tablistwidget.ui"* ui;
}

