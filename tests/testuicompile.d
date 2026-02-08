// QT_MODULES: widgets
import imports.testfiles;
import qt.core.locale;
import qt.core.metatype;
import qt.core.object;
import qt.core.objectdefs;
import qt.core.string;
import qt.core.variant;
import qt.gui.keysequence;
import qt.widgets.application;
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

shared static this()
{
    version (Android)
    {
        import imports.androidhelpers;
        registerAndroidJVM();
    }
}

void dumpObject(ref Appender!string appender, QObject obj, string indent)
{
    const QMetaObject *meta = obj.metaObject();
    appender.put(indent);
    auto className = fromStringz(meta.className());
    appender.put(className);
    if (!obj.objectName().isEmpty())
    {
        appender.put(" ");
        appender.put(fromStringz(obj.objectName().toUtf8().data()));
    }
    appender.put("\n");
    int propertyCount = meta.propertyCount();
    for (int i = 0; i < propertyCount; i++)
    {
        auto propertyName = fromStringz(meta.property(i).name());
        if (propertyName == "objectName")
            continue;
        if (className == "QKeySequenceEdit" && propertyName.among("clearButtonEnabled", "maximumSequenceLength", "finishingKeyCombinations"))
            continue;
        if (propertyName.among("accessibleIdentifier", "labelDrawingMode", "horizontalSizeConstraint", "verticalSizeConstraint"))
            continue;
        if (className.among("QTimeEdit", "QDateEdit", "QDateTimeEdit") && propertyName.among("timeZone"))
            continue;
        QVariant valueVar = obj.property(propertyName.ptr);
        QString value = valueVar.toString();
        /*if (value.isEmpty())
            continue;*/
        auto propertyType = fromStringz(valueVar.typeName());
        if (valueVar.typeId() == QMetaType.Type.QFont)
            value = QString("platform dependent");
        if (valueVar.typeId() == QMetaType.Type.QKeySequence)
            value = valueVar.value!QKeySequence().toString(QKeySequence.SequenceFormat.PortableText);
        if (propertyName.among("x", "y", "width", "height"))
            value = QString("platform dependent");
        if (className == "QTimeEdit" && propertyName.among("date", "dateTime", "maximumDateTime", "minimumDateTime", "maximumDate", "minimumDate"))
            value = QString("platform dependent");
        if (className == "QDateEdit" && propertyName.among("time", "dateTime", "maximumDateTime", "minimumDateTime", "maximumDate", "minimumDate", "maximumTime", "minimumTime"))
            value = QString("platform dependent");
        if (propertyType.startsWith("QFlags"))
            value = QString.number(valueVar.toInt());
        appender.put(indent);
        appender.put("    ");
        appender.put(propertyName);
        appender.put(" = ");
        appender.put(propertyType);
        appender.put("(");
        appender.put(fromStringz(value.toUtf8().data()));
        appender.put(")\n");
    }
    if (fromStringz(meta.className()) == "QComboBox")
        return;
    if (fromStringz(meta.className()) == "QKeySequenceEdit")
        return;
    QLayout layout = qobject_cast!QLayout(obj);
    if (layout)
    {
        int left, top, right, bottom;
        layout.getContentsMargins(&left, &top, &right, &bottom);
        appender.put(text(indent, "  contentsMargins = (", left, ", ", top, ", ", right, ", ", bottom, ")\n"));
        int itemCount = layout.count();
        for (int i = 0; i < itemCount; i++)
        {
            QLayoutItem item = layout.itemAt(i);
            appender.put(text(indent, "  item[", i, "] = "));
            if (item.widget())
                appender.put(text("widget ", fromStringz(item.widget().metaObject().className()), " ", fromStringz(item.widget().objectName().toUtf8().data())));
            else if (item.spacerItem())
                appender.put("spacer");
            else if (item.layout())
                appender.put(text("layout ", fromStringz(item.layout().metaObject().className()), " ", fromStringz(item.layout().objectName().toUtf8().data())));
            appender.put("\n");
        }
    }
    const QObjectList children = obj.children();
    foreach (QObject c; children)
    {
        dumpObject(appender, c, indent ~ "    ");
    }
}

unittest
{
    import core.runtime;
    QString styleName = QString("Fusion");
    QApplication.setStyle(styleName);
    scope app = new QApplication(Runtime.cArgs.argc, Runtime.cArgs.argv);

    QLocale locale = QLocale.c();
    QLocale.setDefault(locale);

    string dqtRoot = environment.get("DQT_ROOT");
    mkdirRecurse(buildPath("ui"));

    bool anyFailure;
    size_t countFiles;
    static foreach (filename; filesUi)
    {
        static if (filename.endsWith(".ui"))
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
            if (appender.data.replace("\r", "") != expected.replace("\r", ""))
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
