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
        writeln("event ", cast(void*) object, " ", object.metaObject().className().fromStringz, " ", object.objectName().toConstWString, " ", event.type());

        return false;
    }
}

int main()
{
    import core.runtime;
    import examplewidgets.mainwindow;
    import qt.core.resource;
    import qt.core.string;
    import qt.widgets.application;

    /* The file resources.rcc can be created from resources.qrc with the
     * following command:
     * rcc -binary resources.qrc -o resources.rcc
     * Normally that would be part of the build process, but it is already
     * included in the repository for this example.
     * Alternatively it would also be possible to generate qrc_resources.cpp
     * and compile it as part of the project, but that would add a C++
     * compiler as a dependency.
     */
    QResource.registerResource(QString("examples/examplewidgets/resources.rcc"));

    auto eventLogger = new EventLogger();
    scope a = new QApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);
    //a.installEventFilter(eventLogger);
    scope w = new MainWindow;
    w.show();
    return a.exec();
}

