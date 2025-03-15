module pdfreader.main;

import qt.config;
import qt.helpers;

int main(string[] args)
{
    import core.runtime;
    import pdfreader.mainwindow;
    import qt.core.string;
    import qt.widgets.application;

    scope a = new QApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);
    string filename;
    if (args.length >= 2)
        filename = args[1];
    scope w = new MainWindow(filename);
    w.show();
    return a.exec();
}

