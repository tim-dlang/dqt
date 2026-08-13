// QT_MODULES: widgets
module tests.testwidgets1;

import qt.config;
import qt.gui.event;
import qt.gui.paintdevice;
import qt.helpers;
import qt.widgets.application;
import qt.widgets.gridlayout;
import qt.widgets.widget;

QApplication app;
version (Android)
{}
else
{
shared static this()
{
    import core.runtime;
    import core.stdcpp.new_;

    static __gshared int argc_copy; // Needs to be global, because the application stores a reference.
    argc_copy = Runtime.cArgs.argc;

    app = cpp_new!QApplication(argc_copy, Runtime.cArgs.argv);
}
shared static ~this()
{
    import core.stdcpp.new_;

    cpp_delete(app);
    app = null;
}
}

class TestWidget : QWidget
{
    mixin(Q_OBJECT_D);
public:
    /+ explicit +/this()
    {
        // Restore interface vtbl pointer as workaround for https://github.com/dlang/dmd/issues/23551
        (cast(void**) this)[baseQPaintDeviceInterface.offsetof / (void*).sizeof - 1] = (cast(void**) __traits(initSymbol, TestWidget))[baseQPaintDeviceInterface.offsetof / (void*).sizeof - 1];

        resize(400, 300);
    }
    ~this()
    {
    }

    int extraScale = 1;

    extern(C++) override int metric(PaintDeviceMetric metric) const
    {
        // Workaround for https://github.com/dlang/dmd/issues/23569
        auto super_metric = &QWidget.metric;
        version (CppRuntime_Microsoft)
            super_metric.ptr = cast(void*)cast(QPaintDeviceInterface)this;

        switch (metric)
        {
        case PaintDeviceMetric.PdmDevicePixelRatio:
        case PaintDeviceMetric.PdmDevicePixelRatioScaled:
            return super_metric(metric) * extraScale;
        default:
            return super_metric(metric);
        }
    }

protected:
    extern(C++) override void paintEvent(QPaintEvent  e)
    {
        import qt.core.namespace;
        import qt.core.rect;
        import qt.gui.brush;
        import qt.gui.color;
        import qt.gui.paintdevice;
        import qt.gui.painter;

        auto rect = QRect(0, 0, width(), height());

        QPaintDeviceInterface device = this;
        auto painter = QPainter(device);
        painter.setRenderHint(QPainter.RenderHint.Antialiasing);

        painter.fillRect(QRectF(0, 0, width(), height()), QBrush(QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.blue)));
        painter.fillRect(QRectF(10, 10, 50, 50), QBrush(QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.red)));

        painter.end();

        /+ emit +/ rendered();
    }

/+ signals +/public:
    @QSignal final void rendered() {mixin(Q_SIGNAL_IMPL_D);}
}

// Needs to be extern(C++) for LDC on x86 as a workaround for https://github.com/ldc-developers/ldc/issues/5260
extern(C++) class TestLayout : QGridLayout
{
    mixin(Q_OBJECT_D);
public:
    /+ explicit +/this()
    {
        // Restore interface vtbl pointer as workaround for https://github.com/dlang/dmd/issues/23551
        (cast(void**) this)[baseQLayoutItem.offsetof / (void*).sizeof - 1] = (cast(void**) __traits(initSymbol, TestLayout))[baseQLayoutItem.offsetof / (void*).sizeof - 1];

        numConstructed++;
    }
    ~this()
    {
        numDestroyed++;
    }

    static __gshared int numConstructed;
    static __gshared int numDestroyed;
}

version(DigitalMars)
version(X86)
    version = DigitalMars_X86;

version (Android)
{}
else version (DigitalMars_X86)
    pragma(msg, __FILE__, ":", __LINE__, ": Test skipped for DMD X86");
else
unittest
{
    import qt.core.eventloop;
    import qt.core.namespace;
    import qt.core.object;
    import qt.gui.color;
    import qt.gui.image;

    scope window = new TestWidget;
    window.show();

    scope eventLoop = new QEventLoop;
    QObject.connect(window.signal!"rendered", eventLoop.slot!"quit", /+ Qt:: +/qt.core.namespace.ConnectionType.QueuedConnection);
    eventLoop.exec();

    assert(window.devType() == QInternal.PaintDeviceFlags.Widget);
    assert(window.width() == 400);
    assert(window.height() == 300);

    const(QPaintDeviceInterface) device2 = window;
    //assert(device2.devType() == QInternal.PaintDeviceFlags.Widget);

    const(QPaintDevice) device = cast(QPaintDevice) cast(void*) device2;
    assert(device.devType() == QInternal.PaintDeviceFlags.Widget);
    assert(device.width() == 400);
    assert(device.height() == 300);

    QImage image = window.grab(window.rect()).toImage();
    assert(!image.isNull());

    assert(image.width() == 400);
    assert(image.height() == 300);

    assert(image.pixelColor(5, 5) == QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.blue));
    assert(image.pixelColor(30, 30) == QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.red));

    window.extraScale = 4;
    window.update();

    eventLoop.exec();

    image = window.grab(window.rect()).toImage();
    assert(!image.isNull());

    assert(image.width() == 1600);
    assert(image.height() == 1200);

    assert(image.pixelColor(5, 5) == QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.blue));
    assert(image.pixelColor(30, 30) == QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.blue));
    assert(image.pixelColor(120, 120) == QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.red));
}

version (Android)
{}
else version (DigitalMars_X86)
    pragma(msg, __FILE__, ":", __LINE__, ": Test skipped for DMD X86");
else
unittest
{
    import core.stdcpp.new_;
    import qt.core.object;
    import qt.widgets.boxlayout;
    import qt.widgets.layoutitem;

    QWidget window = cpp_new!QWidget();
    window.show();

    TestLayout layout1 = cpp_new!TestLayout();
    window.setLayout(layout1);

    TestLayout layout2 = cpp_new!TestLayout();
    QLayoutItem layout2Item = cast(QLayoutItem) cast(void*) cast(QLayoutItemInterface) layout2;
    layout1.addItem(layout2Item, 0, 0);

    QVBoxLayout layout3 = cpp_new!QVBoxLayout();
    QLayoutItem layout3Item = cast(QLayoutItem) cast(void*) cast(QLayoutItemInterface) layout3;
    layout1.addItem(layout3Item, 0, 1);

    QWidget widget2 = cpp_new!QWidget();
    layout1.addWidget(widget2, 1, 0);

    QWidget widget3 = cpp_new!QWidget();
    layout2.addWidget(widget3, 0, 0);

    int layout1Destroyed = 0;
    QObject.connect(layout1.signal!"destroyed", layout1, (){ layout1Destroyed++; });

    int layout2Destroyed = 0;
    QObject.connect(layout2.signal!"destroyed", layout2, (){ layout2Destroyed++; });

    int layout3Destroyed = 0;
    QObject.connect(layout3.signal!"destroyed", layout3, (){ layout3Destroyed++; });

    int widget2Destroyed = 0;
    QObject.connect(widget2.signal!"destroyed", widget2, (){ widget2Destroyed++; });

    int widget3Destroyed = 0;
    QObject.connect(widget3.signal!"destroyed", widget3, (){ widget3Destroyed++; });

    assert(layout1.itemAtPosition(0, 0) is layout2Item);
    assert(layout1.itemAtPosition(0, 1) is layout3Item);
    assert(layout1.itemAtPosition(1, 0).widget() is widget2);
    assert(layout2.itemAtPosition(0, 0).widget() is widget3);

    cpp_delete(window);

    assert(layout1Destroyed == 1);
    assert(layout2Destroyed == 1);
    assert(layout3Destroyed == 1);
    assert(widget2Destroyed == 1);
    // TODO: assert(widget3Destroyed == 1);
    assert(TestLayout.numConstructed == 2);
    assert(TestLayout.numDestroyed == 2);
}
