module examplewidgets.tabdialogs;

import qt.config;
import qt.core.string;
import qt.helpers;
import qt.widgets.errormessage;
import qt.widgets.ui;
import qt.widgets.widget;
import core.stdcpp.new_;

class TabDialogs : QWidget
{
    mixin(Q_OBJECT_D);

public:
    /+ explicit +/this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        import qt.widgets.spinbox;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);

        errorMessage = cpp_new!QErrorMessage(this);

        connect(ui.spinBoxRed.signal!("valueChanged", int), this.slot!"updateColor");
        connect(ui.spinBoxGreen.signal!("valueChanged", int), this.slot!"updateColor");
        connect(ui.spinBoxBlue.signal!("valueChanged", int), this.slot!"updateColor");
        updateColor();
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
    }

private /+ slots +/:
    @QSlot final void on_pushButtonShowMessageBox_clicked()
    {
        import qt.widgets.messagebox;

        QMessageBox msgBox = cpp_new!QMessageBox;
        msgBox.setIcon(cast(/+ QMessageBox::Icon +/QMessageBox.Icon)ui.comboBoxIcon.currentIndex());
        msgBox.setText(ui.plainTextEditText.toPlainText());
        auto tmp = ui.plainTextEditDetailed.toPlainText(); msgBox.setDetailedText(tmp);
        QMessageBox.StandardButtons buttons;
        if(ui.checkBoxOK.isChecked())
            buttons |= QMessageBox.StandardButton.Ok;
        if(ui.checkBoxCancel.isChecked())
            buttons |= QMessageBox.StandardButton.Cancel;
        if(ui.checkBoxYes.isChecked())
            buttons |= QMessageBox.StandardButton.Yes;
        if(ui.checkBoxNo.isChecked())
            buttons |= QMessageBox.StandardButton.No;
        msgBox.setStandardButtons(buttons);
        int ret = msgBox.exec();
        const(char)* buttonName;
        switch(ret)
        {
        case QMessageBox.StandardButton.Ok:
            buttonName = "OK";
            break;
        case QMessageBox.StandardButton.Cancel:
            buttonName = "Cancel";
            break;
        case QMessageBox.StandardButton.Yes:
            buttonName = "Yes";
            break;
        case QMessageBox.StandardButton.No:
            buttonName = "No";
            break;
        default:
            buttonName = "Unknown";
        }
        QString text = QString("Clicked: ") ~ buttonName;
        ui.labelResult.setText(text);
        cpp_delete(msgBox);
    }

    @QSlot final void on_pushButtonShowColorDialog_clicked()
    {
        import qt.gui.color;
        import qt.widgets.colordialog;

        QColor color = QColor.fromRgb(ui.spinBoxRed.value(), ui.spinBoxGreen.value(), ui.spinBoxBlue.value());
        color = QColorDialog.getColor(color, this, globalInitVar!QString);
        ui.spinBoxRed.setValue(color.red());
        ui.spinBoxGreen.setValue(color.green());
        ui.spinBoxBlue.setValue(color.blue());
    }

    @QSlot final void updateColor()
    {
        import qt.gui.color;
        import qt.gui.palette;

        QColor color = QColor.fromRgb(ui.spinBoxRed.value(), ui.spinBoxGreen.value(), ui.spinBoxBlue.value());
        QPalette palette = QPalette(color);
        palette.setColor(QPalette.ColorRole.Window, color);
        ui.widgetColor.setPalette(palette);
        ui.widgetColor.update();
    }

    @QSlot final void on_pushButtonShowError_clicked()
    {
        auto tmp = ui.plainTextEditErrorMessage.toPlainText(); errorMessage.showMessage(tmp);
    }

    @QSlot final void on_pushButtonOpenFile_clicked()
    {
        import qt.widgets.filedialog;

        QString path = ui.lineEditPath.text();
        path = QFileDialog.getOpenFileName(this, globalInitVar!QString, path);
        ui.lineEditPath.setText(path);
    }

    @QSlot final void on_pushButtonSaveFile_clicked()
    {
        import qt.widgets.filedialog;

        QString path = ui.lineEditPath.text();
        path = QFileDialog.getSaveFileName(this, globalInitVar!QString, path);
        ui.lineEditPath.setText(path);
    }

    @QSlot final void on_pushButtonSelectDirectory_clicked()
    {
        import qt.widgets.filedialog;

        QString path = ui.lineEditPath.text();
        path = QFileDialog.getExistingDirectory(this, globalInitVar!QString, path);
        ui.lineEditPath.setText(path);
    }

private:
    UIStruct!"tabdialogs.ui"* ui;
    QErrorMessage errorMessage;
}

