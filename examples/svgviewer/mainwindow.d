module svgviewer.mainwindow;
extern(C):

import qt.config;
import qt.core.string;
import qt.helpers;
import qt.widgets.mainwindow;
import qt.widgets.ui;
import qt.widgets.widget;

class MainWindow : QMainWindow
{
    mixin(Q_OBJECT_D);

public:
    this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);

        ui.svgWidget.setVisible(false);
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
    }

private /+ slots +/:
    @QSlot final void on_actionOpen_File_triggered()
    {
        import qt.widgets.filedialog;

        QString filename = QFileDialog.getOpenFileName(this, "Open SVG file", QString(), "SVG Images (*.svg *.svgz);;All files (*)");
        if (!filename.isEmpty())
            ui.svgWidget.load(filename);

        ui.svgWidget.setVisible(ui.svgWidget.renderer().isValid());
        ui.labelNoImageLoaded.setVisible(!ui.svgWidget.renderer().isValid());
    }

    @QSlot final void on_actionAbout_Qt_triggered()
    {
        import qt.widgets.messagebox;

        QMessageBox.aboutQt(this);
    }

private:
    UIStruct!"mainwindow.ui"* ui;
}

