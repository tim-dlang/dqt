// QT_MODULES: webenginewidgets
module tests.testwebenginewidgets1;

import qt.config;
import qt.helpers;

unittest
{
    import qt.core.eventloop;
    import qt.core.object;
    import qt.core.string;
    import qt.core.variant;
    import qt.webengine.view;
    import qt.widgets.application;

    int argc = 1;
    char*[1] argv = ["test\0".dup.ptr];
    scope a = new QApplication(argc, argv.ptr);

    scope view = new QWebEngineView();

    scope eventLoop = new QEventLoop();
    QObject.connect(view.signal!"loadFinished", eventLoop.slot!"quit");

    view.setHtml(QString("<html><head><title>TestTitle</title></head><body></body></html>"));
    view.show();
    eventLoop.exec();
    assert(view.title() == "TestTitle");

    QObject.connect(view.signal!"titleChanged", eventLoop.slot!"quit");
    view.page().runJavaScript(QString("document.title = \"New Title from JS\""));
    eventLoop.exec();
    assert(view.title() == "New Title from JS");

    int valueFromJS = 0;
    view.page().runJavaScript(QString("1+2"), (ref const QVariant v) {
        valueFromJS = v.toInt();
        eventLoop.quit();
    });
    eventLoop.exec();
    assert(valueFromJS == 3);
}
