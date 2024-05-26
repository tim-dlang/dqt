module exampleqml.main;

import qt.config;
import qt.helpers;

int main()
{
    import core.runtime;
    import exampleqml.logic;
    import qt.core.coreapplication;
    import qt.core.namespace;
    import qt.core.object;
    import qt.core.string;
    import qt.core.url;
    import qt.gui.guiapplication;
    import qt.qml.applicationengine;
    import qt.quickcontrols2.style;
    import std.path;

/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif +/
    scope app = new QGuiApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);

    QQuickStyle.setStyle("Fusion");

    scope engine = new QQmlApplicationEngine;

    Logic logic = new Logic(app);
    engine.rootContext().setContextProperty("appTitle", "DQt ExampleQML");
    engine.rootContext().setContextProperty("logic", logic);

    auto url = QUrl.fromLocalFile(buildNormalizedPath(absolutePath("examples/exampleqml/main.qml")));
    QObject.connect(
        engine.signal!"objectCreated",
        app,
        (QObject obj, ref const QUrl objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication.exit(-1);
        },
        /+ Qt:: +/qt.core.namespace.ConnectionType.QueuedConnection);
    engine.load(url);

    return app.exec();
}

