module examplewidgets.tabsimple;

import qt.config;
import qt.helpers;
import qt.widgets.ui;
import qt.widgets.widget;
import core.stdcpp.new_;

class TabSimple : QWidget
{
    mixin(Q_OBJECT_D);

public:
    /+ explicit +/this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);

        connect(ui.dateTimeEdit.signal!"dateChanged", ui.dateEdit.slot!"setDate");
        connect(ui.dateEdit.signal!"dateChanged", ui.dateTimeEdit.slot!"setDate");
        connect(ui.dateEdit.signal!"dateChanged", ui.calendarWidget.slot!"setSelectedDate");
        connect(ui.calendarWidget.signal!"clicked", ui.dateEdit.slot!"setDate");
        connect(ui.dateTimeEdit.signal!"timeChanged", ui.timeEdit.slot!"setTime");
        connect(ui.timeEdit.signal!"timeChanged", ui.dateTimeEdit.slot!"setTime");

        connect(ui.spinBox.signal!"valueChanged", ui.lcdNumber.slot!("display", int));

        connect(ui.horizontalSlider.signal!"valueChanged", ui.horizontalScrollBar.slot!"setValue");
        connect(ui.horizontalSlider.signal!"valueChanged", ui.dial.slot!"setValue");
        connect(ui.horizontalSlider.signal!"valueChanged", ui.progressBar.slot!"setValue");
        connect(ui.horizontalScrollBar.signal!"valueChanged", ui.horizontalSlider.slot!"setValue");
        connect(ui.dial.signal!"valueChanged", ui.horizontalSlider.slot!"setValue");
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
    }

private:
    UIStruct!"tabsimple.ui"* ui;
}

