// QT_MODULES: widgets
import imports.testfiles;
import qt.widgets.application;
import qt.core.locale;
import qt.core.object;
import qt.core.objectdefs;
import qt.core.string;
import qt.widgets.layout;
import qt.widgets.layoutitem;
import qt.widgets.ui;
import qt.widgets.widget;
import std.algorithm;
import std.array;
import std.conv;
import std.file;
import std.path;
import std.process;
import std.stdio;
import std.string;
import std.traits;

void dumpObject(ref Appender!string appender, QObject obj, string indent)
{
    const QMetaObject *meta = obj.metaObject();
    appender.put(indent);
    appender.put(fromStringz(meta.className()));
    if(!obj.objectName().isEmpty())
    {
        appender.put(" ");
        appender.put(fromStringz(obj.objectName().toUtf8().data()));
    }
    appender.put("\n");
    int propertyCount = meta.propertyCount();
    for(int i = 0; i < propertyCount; i++)
    {
        auto propertyName = fromStringz(meta.property(i).name());
        if(propertyName == "objectName")
            continue;
        QString value = obj.property(propertyName.ptr).toString();
        /*if(value.isEmpty())
            continue;*/
        auto propertyType = fromStringz(obj.property(propertyName.ptr).typeName());
        if(propertyType == "QFont")
            value = QString("platform dependent");
        if(propertyName == "x" || propertyName == "y" || propertyName == "width" || propertyName == "height")
            value = QString("platform dependent");
        appender.put(indent);
        appender.put("    ");
        appender.put(propertyName);
        appender.put(" = ");
        appender.put(propertyType);
        appender.put("(");
        appender.put(fromStringz(value.toUtf8().data()));
        appender.put(")\n");
    }
    if(fromStringz(meta.className()) == "QComboBox")
        return;
    QLayout layout = qobject_cast!QLayout(obj);
    if(layout)
    {
        int left, top, right, bottom;
        layout.getContentsMargins(&left, &top, &right, &bottom);
        appender.put(text(indent, "  contentsMargins = (", left, ", ", top, ", ", right, ", ", bottom, ")\n"));
        int itemCount = layout.count();
        for(int i = 0; i < itemCount; i++)
        {
            QLayoutItem item = layout.itemAt(i);
            appender.put(text(indent, "  item[", i, "] = "));
            if(item.widget())
                appender.put(text("widget ", fromStringz(item.widget().metaObject().className()), " ", fromStringz(item.widget().objectName().toUtf8().data())));
            else if(item.spacerItem())
                appender.put("spacer");
            else if(item.layout())
                appender.put(text("layout ", fromStringz(item.layout().metaObject().className()), " ", fromStringz(item.layout().objectName().toUtf8().data())));
            appender.put("\n");
        }
    }
    const QObjectList children = obj.children();
    foreach(QObject c; children)
    {
        dumpObject(appender, c, indent ~ "    ");
    }
}

unittest
{
    import core.runtime;
    scope app = new QApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);

    QLocale locale = QLocale.c();
    QLocale.setDefault(locale);

    string dqtRoot = environment.get("DQT_ROOT");
    mkdirRecurse(buildPath("ui"));

    bool anyFailure;
    size_t countFiles;
    static foreach(filename; filesUi)
    {
        static if(filename.endsWith(".ui"))
        {{
            UIStruct!("ui/" ~ filename) ui;
            alias Root = Parameters!(ui.setupUi)[0];
            Root widget = new Root;
            ui.setupUi(widget);
            Appender!string appender;
            dumpObject(appender, widget, "");
            string resultPath = buildPath("ui", filename[0..$-3] ~ ".properties_result");
            std.file.write(resultPath, appender.data);
            string expectedPath = buildPath(dqtRoot, "tests", "ui", filename[0..$-3] ~ ".properties_expected");
            auto expected = readText(expectedPath);
            if(appender.data != expected)
            {
                stderr.writeln("Wrong properties for ", filename);
                stderr.writeln(appender.data);
                anyFailure = true;
            }
            countFiles++;
        }}
    }
    assert(!anyFailure);
    assert(countFiles > 0);
}
