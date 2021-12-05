module examplewidgets.mainwindow;

import qt.config;
import qt.core.string;
import qt.helpers;
import qt.widgets.mainwindow;
import qt.widgets.ui;
import qt.widgets.widget;

// Using MainWindowUI instead of UIStruct!"mainwindow.ui" prevents a forward referencing error.
struct MainWindowUI
{
    mixin(generateUICode(import("mainwindow.ui"), "examplewidgets"));
}

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
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
    }

private /+ slots +/:
    @QSlot final void on_actionAbout_Qt_triggered()
    {
        import qt.widgets.messagebox;

        QMessageBox.aboutQt(this);
    }

    @QSlot final void on_actionSystem_Info_triggered()
    {
        import qt.core.sysinfo;
        import qt.widgets.messagebox;

        QString text = QString.create;
        text ~= "Hostname: " ~ QSysInfo.machineHostName() ~ "\n";
        text ~= "Pretty Product Name: " ~ QSysInfo.prettyProductName() ~ "\n";
        text ~= "Product: " ~ QSysInfo.productType() ~ " " ~ QSysInfo.productVersion() ~ "\n";
        text ~= "Kernel: " ~ QSysInfo.kernelType() ~ " " ~ QSysInfo.kernelVersion() ~ "\n";
        text ~= "Build ABI: " ~ QSysInfo.buildAbi() ~ "\n";
        text ~= "CPU Architecture: " ~ QSysInfo.buildCpuArchitecture() ~ "\n";
        text ~= "Current CPU Architecture: " ~ QSysInfo.currentCpuArchitecture();
        QString title = "System Info";
        QMessageBox.information(this, title, text);
    }

private:
    MainWindowUI* ui;
}

