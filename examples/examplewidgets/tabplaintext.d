module examplewidgets.tabplaintext;

import qt.config;
import qt.core.coreevent;
import qt.helpers;
import qt.widgets.ui;
import qt.widgets.widget;

class TabPlainText : QWidget
{
    mixin(Q_OBJECT_D);

public:
    /+ explicit +/this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);

        connect(ui.plainTextEdit.signal!"undoAvailable", ui.pushButtonUndo.slot!"setEnabled");
        connect(ui.plainTextEdit.signal!"redoAvailable", ui.pushButtonRedo.slot!"setEnabled");
        connect(ui.pushButtonUndo.signal!"clicked", ui.plainTextEdit.slot!"undo");
        connect(ui.pushButtonRedo.signal!"clicked", ui.plainTextEdit.slot!"redo");

        on_plainTextEdit_textChanged();
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
    }

private /+ slots +/:
    @QSlot final void on_plainTextEdit_textChanged()
    {
        if(ui.comboBoxType.currentIndex() == 0)
            ui.textBrowser.setMarkdown(ui.plainTextEdit.toPlainText());
        if(ui.comboBoxType.currentIndex() == 1)
            ui.textBrowser.setHtml(ui.plainTextEdit.toPlainText());
        if(ui.comboBoxType.currentIndex() == 2)
            { auto tmp = ui.plainTextEdit.toPlainText(); ui.textBrowser.setPlainText(tmp);}
    }

    @QSlot final void on_comboBoxType_currentIndexChanged(int index)
    {
        on_plainTextEdit_textChanged();
    }

protected:
    override extern(C++) void changeEvent(QEvent event)
    {
        if(event.type() == QEvent.Type.LanguageChange)
            ui.retranslateUi(this);
        QWidget.changeEvent(event);
    }

private:
    UIStruct!"tabplaintext.ui"* ui;
}

