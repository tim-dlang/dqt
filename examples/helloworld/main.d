module helloworld.main;

import qt.config;
import qt.helpers;

int main()
{
    import core.runtime;
    import core.stdcpp.new_;
    import qt.core.object;
    import qt.widgets.application;
    import qt.widgets.boxlayout;
    import qt.widgets.label;
    import qt.widgets.pushbutton;
    import qt.widgets.widget;

    scope a = new QApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);

    QWidget window = cpp_new!QWidget();
    window.setWindowTitle("Hello World");
    window.resize(400, 300);
    window.move(window.screen().geometry().center() - window.frameGeometry().center());

    QVBoxLayout verticalLayout = cpp_new!QVBoxLayout(window);

    QLabel label = cpp_new!QLabel(window);
    label.setText("Hello World");
    verticalLayout.addWidget(label);

    QPushButton pushButton = cpp_new!QPushButton(window);
    pushButton.setText("Close");
    QObject.connect(pushButton.signal!"clicked", window.slot!"close");
    verticalLayout.addWidget(pushButton);

    window.show();
    return a.exec();
}

