module examplewidgets.mainwindow;

import qt.config;
import qt.core.coreevent;
import qt.core.string;
import qt.core.translator;
import qt.gui.event;
import qt.helpers;
import qt.widgets.action;
import qt.widgets.mainwindow;
import qt.widgets.menu;
import qt.widgets.systemtrayicon;
import qt.widgets.ui;
import qt.widgets.widget;

// Using MainWindowUI instead of UIStruct!"mainwindow.ui" prevents a forward referencing error.
struct MainWindowUI
{
    mixin(generateUICode(import("mainwindow.ui"), "examplewidgets"));
}

immutable string[2][] languages = [
    ["English", "en"],
    ["Deutsch", "de"]
];

class MainWindow : QMainWindow
{
    mixin(Q_OBJECT_D);

public:
    this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        import qt.core.coreapplication;
        import qt.widgets.actiongroup;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);

        /* Create a menu for selecting the language.
         * The menu will contain entries for English and German.
         * Only some parts of the UI are translated as an example.
         * English is the default and already used in the *.ui files.
         * See https://doc.qt.io/qt-5/internationalization.html for
         * general information about translating Qt applications. The
         * translatable texts are first collected with the following
         * commands:
         * lupdate examples/examplewidgets/*.ui -locations none -no-obsolete -ts examples/examplewidgets/examplewidgets_en.ts
         * lupdate examples/examplewidgets/*.ui -locations none -no-obsolete -ts examples/examplewidgets/examplewidgets_de.ts
         *
         * The translations can then be changed with linguist (https://doc.qt.io/qt-5/qtlinguist-index.html).
         * No changes are used for English, because that is the default.
         * The *.ts files now have to be converted to *.qm files, which
         * are used by the application:
         * lrelease examples/examplewidgets/examplewidgets*.ts
         *
         * The last step would normally be part of the build process,
         * but the repository already contains the *.qm files for this
         * example.
         */
        QActionGroup actionGroupLanguage = cpp_new!QActionGroup(this);
        foreach (lang; languages)
        {
            QString name = QString(lang[0]);
            QAction action = actionGroupLanguage.addAction(name);
            action.setCheckable(true);
            action.setData(lang[1]);
        }
        ui.menuLanguage.addActions(actionGroupLanguage.actions());
        actionGroupLanguage.actions()[0].setChecked(true);
        connect(actionGroupLanguage.signal!"triggered", this.slot!"onLanguageActionTriggered");

        translator = cpp_new!QTranslator(this);
        QCoreApplication.instance().installTranslator(translator);
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
        QMessageBox.information(this, "System Info", text);
    }

    @QSlot final void onLanguageActionTriggered(QAction action)
    {
        QString lang = action.data().toString();
        QString filename = "examplewidgets_" ~ lang;
        QString dir = QString("examples/examplewidgets");
        /* Change the used translation file. The will also trigger
         * the LanguageChange event for all widgets and is used to
         * retranslate the UIs.
         */
        translator.load(filename, dir);
    }

    @QSlot final void on_actionTray_Icon_changed()
    {
        import core.stdcpp.new_;
        import qt.widgets.application;
        import qt.widgets.messagebox;

        if (ui.actionTray_Icon.isChecked() && !trayIcon)
        {
            if (!QSystemTrayIcon.isSystemTrayAvailable())
            {
                QMessageBox.warning(this, QString.create(), "No system tray available");
                ui.actionTray_Icon.setChecked(false);
                return;
            }

            if (!trayMenu)
            {
                trayMenu = cpp_new!QMenu(this);
                auto actionShow = trayMenu.addAction("Show");
                auto actionQuit = trayMenu.addAction("Quit");
                connect(actionShow.signal!"triggered", this.slot!"onTrayMenuShowTriggered");
                connect(actionQuit.signal!"triggered", this.slot!"close");
            }

            trayIcon = cpp_new!QSystemTrayIcon(this);
            trayIcon.setIcon(windowIcon());
            trayIcon.setToolTip("DQt example tray icon");
            trayIcon.setContextMenu(trayMenu);
            connect(trayIcon.signal!"activated", this.slot!"onTrayIconActivated");
            trayIcon.show();
        }
        if (!ui.actionTray_Icon.isChecked() && trayIcon)
        {
            cpp_delete(trayIcon);
            trayIcon = null;
        }
    }

    @QSlot final void onTrayIconActivated(QSystemTrayIcon.ActivationReason reason)
    {
        if (reason == QSystemTrayIcon.ActivationReason.Trigger
            || reason == QSystemTrayIcon.ActivationReason.DoubleClick)
        {
            if (isVisible() && isActiveWindow())
            {
                hide();
            }
            else
            {
                show();
                raise();
                activateWindow();
            }
        }
    }

    @QSlot final void onTrayMenuShowTriggered()
    {
        show();
        raise();
        activateWindow();
    }

protected:
    override extern(C++) void changeEvent(QEvent event)
    {
        if (event.type() == QEvent.Type.LanguageChange)
            ui.retranslateUi(this);
        QMainWindow.changeEvent(event);
    }
    extern(C++) override void closeEvent(QCloseEvent event)
    {
        if (trayIcon && event.spontaneous())
        {
            hide();
            event.ignore();
            trayIcon.showMessage(QString.create(), "Window closed");
            return;
        }
        event.accept();
    }

private:
    MainWindowUI* ui;
    QTranslator translator;
    QSystemTrayIcon trayIcon = null;
    QMenu trayMenu = null;
}
