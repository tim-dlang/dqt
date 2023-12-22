module examplebrowser.main;

import qt.config;
import qt.helpers;

int main()
{
    import core.runtime;
    import examplebrowser.mainwindow;
    import qt.widgets.application;

    scope a = new QApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);
    scope w = new MainWindow;
    w.show();
    return a.exec();
}

