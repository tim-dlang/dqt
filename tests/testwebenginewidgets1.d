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

    int argc = 0;
    char*[1] argv = ["test".dup.ptr];
    scope a = new QApplication(argc, argv.ptr);

    scope view = new QWebEngineView();

    scope eventLoop = new QEventLoop();
    QObject.connect(view.signal!"loadFinished", eventLoop.slot!"quit");

    view.setHtml(QString("<html><head><title>TestTitle</title></head><body></body></html>"));
    view.show();
    eventLoop.exec();
    assert(view.title() == "TestTitle");
}
