module examplewidgets.main;

import qt.config;
import qt.core.coreevent;
import qt.core.object;
import qt.helpers;

class EventLogger : QObject
{
public:
    extern(C++) override bool eventFilter(QObject object, QEvent event)
    {
        import std.stdio, std.string;
        writeln("event ", cast(void*)object, " ", object.metaObject().className().fromStringz, " ", object.objectName().toConstWString, " ", event.type());

        return false;
    }
}

int main()
{
    import core.runtime;
    import qt.widgets.application;
    import examplewidgets.mainwindow;

    auto eventLogger = new EventLogger();
    scope a = new QApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);
    //a.installEventFilter(eventLogger);
    auto w = new MainWindow;
    w.show();
    return a.exec();
}

