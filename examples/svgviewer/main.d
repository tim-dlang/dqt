module svgviewer.main;

import qt.config;
import qt.helpers;

int main(string[] args)
{
    import core.runtime;
    import qt.widgets.application;
    import svgviewer.mainwindow;

    int argc = Runtime.cArgs.argc; // Reference needs to be valid for lifetime of application object.
    char** argv = Runtime.cArgs.argv;
    scope a = new QApplication(argc, argv);
    scope w = new MainWindow;
    w.show();
    return a.exec();
}

