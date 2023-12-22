module examplebrowser.mainwindow;

import qt.config;
import qt.core.object;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.webengine.urlrequestinfo;
import qt.webengine.urlrequestinterceptor;
import qt.widgets.mainwindow;
import qt.widgets.ui;
import qt.widgets.widget;

class UrlRequestInterceptor : QWebEngineUrlRequestInterceptor
{
    mixin(Q_OBJECT_D);
public:
    /+ explicit +/this(QObject p = null)
    {
        super(p);
    }

    extern(C++) override void interceptRequest(ref QWebEngineUrlRequestInfo info)
    {
        QString method = QString.fromUtf8(info.requestMethod());
        QUrl url = info.requestUrl();
        /+ emit +/ requestIntercepted(method, url);
    }

/+ signals +/public:
    @QSignal final void requestIntercepted(ref const(QString) method, ref const(QUrl) url) {mixin(Q_SIGNAL_IMPL_D);}
}

class MainWindow : QMainWindow
{
    mixin(Q_OBJECT_D);

public:
    this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        import qt.gui.icon;
        import qt.gui.pixmap;
        import qt.webengine.page;
        import qt.webengine.view;
        import qt.widgets.lineedit;
        import qt.widgets.pushbutton;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);

        connect(ui.pushButtonBack.signal!"clicked", ui.webEngineView.slot!"back");
        connect(ui.pushButtonForward.signal!"clicked", ui.webEngineView.slot!"forward");
        connect(ui.lineEditAddress.signal!"returnPressed", this.slot!"on_pushButtonGo_clicked");

        connect(ui.webEngineView.signal!"loadStarted", this, () {
            ui.labelState.setText(QString("Loading"));
            ui.listWidgetRequests.clear();
            ui.labelIcon.setPixmap(QPixmap(0, 0));
            ui.labelTitle.setText(QString(""));
            updateView();
        });
        connect(ui.webEngineView.signal!"loadProgress", this, (int progress) {
            ui.progressBar.setValue(progress);
        });
        connect(ui.webEngineView.signal!"loadFinished", this, (bool ok) {
            ui.progressBar.setValue(ok ? 100 : 0);
            ui.labelState.setText(QString(ok ? "Finished" : "Error"));
            updateView();
        });
        connect(ui.webEngineView.signal!"urlChanged", this, (ref const QUrl url) {
            ui.lineEditAddress.setText(url.toString());
            updateView();
        });
        connect(ui.webEngineView.signal!"titleChanged", this, (ref const QString title) {
            ui.labelTitle.setText(title);
        });
        connect(ui.webEngineView.signal!"iconChanged", this, (ref const QIcon icon) {
            ui.labelIcon.setPixmap(icon.pixmap(32));
        });
        connect(ui.webEngineView.page().signal!"linkHovered", this, (ref const QString url) {
            ui.statusbar.showMessage(url);
        });

        auto interceptor = cpp_new!UrlRequestInterceptor(this);
        connect(interceptor.signal!"requestIntercepted", this, (ref const QString method, ref const QUrl url) {
            ui.listWidgetRequests.addItem(method ~ " " ~ url.toString());
        });
        ui.webEngineView.page().setUrlRequestInterceptor(interceptor);

        ui.splitter.setStretchFactor(0, 10);
        ui.splitter.setStretchFactor(1, 1);

        ui.lineEditAddress.setText(QString("https://dlang.org"));
        on_pushButtonGo_clicked();
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
    }

private /+ slots +/:
    @QSlot final void on_pushButtonGo_clicked()
    {
        ui.webEngineView.setUrl(QUrl(ui.lineEditAddress.text()));
        updateView();
    }

    @QSlot final void on_pushButtonReload_clicked()
    {
        ui.webEngineView.reload();
        updateView();
    }

    @QSlot final void updateView()
    {
        ui.pushButtonBack.setEnabled(ui.webEngineView.history().canGoBack());
        ui.pushButtonForward.setEnabled(ui.webEngineView.history().canGoForward());
    }

    @QSlot final void on_actionQuit_triggered()
    {
        close();
    }

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
        text ~= "Current CPU Architecture: " ~ QSysInfo.currentCpuArchitecture() ~ "\n";
        text ~= QString("\n");
        text ~= "User Agent: " ~ ui.webEngineView.page().profile().httpUserAgent();
        QMessageBox.information(this, QString("System Info"), text);
    }

private:
    UIStruct!"mainwindow.ui"* ui;
}

