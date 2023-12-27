/*
 * DQt - D bindings for the Qt Toolkit
 *
 * GNU Lesser General Public License Usage
 * This file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPL3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
 */
module qt.widgets.ui;

import qt.helpers;
import std.array;

private void writeStringLiteral(R)(ref Appender!string code, R str)
{
    code.put("\"");
    foreach (dchar c; str)
    {
        if (c == '\"')
            code.put("\\\"");
        else if (c == '\n')
            code.put("\\n\" ~\n\"");
        else if (c == '\r')
            code.put("\\r");
        else if (c == '\\')
            code.put("\\\\");
        else
            code.put(c);
    }
    code.put("\"");
}

private struct UICodeWriter()
{
    import dxml.dom;
    import dxml.util;
    import std.ascii;
    import std.uni;
    import std.conv;
    import std.algorithm;
    import std.exception;
    import std.string;
    alias DOMEntity = dxml.dom.DOMEntity!string;

    string customWidgetPackage;
    Appender!string codeVars;
    Appender!string codeSetup;
    Appender!string codeSetupAddActions;
    Appender!string codeSetupConnect;
    Appender!string codeSetupDelayed;
    Appender!string codeRetranslate;
    size_t[string] tmpCountSetup;
    size_t[string] tmpCountRetranslate;
    string[string] widgetTypes;

    string createTmpVar(ref size_t[string] tmpCount, string prefix)
    {
        string r;
        if (prefix !in tmpCount)
        {
            r = prefix;
            tmpCount[prefix] = 1;
        }
        else
        {
            r = text(prefix, tmpCount[prefix]);
            tmpCount[prefix]++;
        }
        return r;
    }

    struct WidgetInfo
    {
        string xmlName;
        string name;
        string className;
    }

    WidgetInfo rootWidgetInfo;

    WidgetInfo getWidgetInfo(DOMEntity widget)
    {
        WidgetInfo info;
        info.xmlName = widget.name;
        foreach (attr; widget.attributes)
        {
            if (attr.name == "class")
                info.className = attr.value;
            else if (attr.name == "name")
                info.name = attr.value;
        }
        if (widget.name == "action")
            info.className = "QAction";
        if (widget.name == "spacer")
            info.className = "QSpacerItem";
        return info;
    }

    string getWidgetModule(string name)
    {
        if (name == "QSpacerItem")
            return "qt.widgets.layoutitem";
        if (name == "QVBoxLayout")
            return "qt.widgets.boxlayout";
        if (name == "QHBoxLayout")
            return "qt.widgets.boxlayout";
        if (name == "QTimeEdit")
            return "qt.widgets.datetimeedit";
        if (name == "QDateEdit")
            return "qt.widgets.datetimeedit";
        if (name == "QDoubleSpinBox")
            return "qt.widgets.spinbox";
        if (name == "QWebEngineView")
            return "qt.webengine.view";

        if (name.startsWith("Q"))
            return "qt.widgets." ~ std.uni.toLower(name[1..$]);

        if (customWidgetPackage.length)
            return customWidgetPackage ~ "." ~ name.toLower;
        else
            return name.toLower;
    }

    void addProperty(DOMEntity property, string widgetName, string widgetType, bool isTopLevel, string extraArg)
    {
        string name;
        foreach (attr; property.attributes)
        {
            if (attr.name == "name")
                name = attr.value;
        }

        enforce(property.children.length == 1);

        bool noTr;
        string comment;
        foreach (attr; property.children[0].attributes)
        {
            if (attr.name == "notr" && attr.value == "true")
                noTr = true;
            if (attr.name == "comment")
                comment = attr.value;
        }

        Appender!string* code = &codeSetup;
        size_t[string]* tmpCount = &tmpCountSetup;
        if (property.children[0].name == "string" && !noTr)
        {
            code = &codeRetranslate;
            tmpCount = &tmpCountRetranslate;
        }
        else if (name == "currentIndex")
            code = &codeSetupDelayed;

        if (widgetType == "Line" && name == "orientation")
        {
            enforce(property.children[0].name == "enum");
            enforce(property.children[0].children.length == 1);
            enforce(property.children[0].children[0].type == EntityType.text);
            string value = property.children[0].children[0].text;

            code.put("        ");
            code.put(widgetName);
            code.put(".setFrameShape(dqtimported!q{qt.widgets.frame}.QFrame.Shape.");
            if (value == "Qt::Horizontal")
                code.put("HLine");
            else if (value == "Qt::Vertical")
                code.put("VLine");
            else
                enforce(false);
            code.put(");\n");

            code.put("        ");
            code.put(widgetName);
            code.put(".");
            code.put("setFrameShadow(dqtimported!q{qt.widgets.frame}.QFrame.Shadow.Sunken);\n");
            return;
        }

        Appender!string codeValue;
        bool needTmp;
        string methodName = "set" ~ std.ascii.toUpper(name[0]) ~ name[1..$];
        if (name == "showGroupSeparator")
            methodName = "setGroupSeparatorShown";
        if (property.children[0].name == "rect")
        {
            if (isTopLevel)
            {
                methodName = "resize";
                foreach (i, c; property.children[0].children)
                {
                    if (i < 2)
                        continue;
                    if (i > 2)
                        codeValue.put(", ");
                    enforce(c.children.length == 1);
                    enforce(c.children[0].type == EntityType.text);
                    codeValue.put(c.children[0].text);
                }
            }
            else
            {
                codeValue.put("dqtimported!q{qt.core.rect}.QRect(");
                foreach (i, c; property.children[0].children)
                {
                    if (i)
                        codeValue.put(", ");
                    enforce(c.children.length == 1);
                    enforce(c.children[0].type == EntityType.text);
                    codeValue.put(c.children[0].text);
                }
                codeValue.put(")");
                needTmp = true;
            }
        }
        else if (property.children[0].name == "color")
        {
            codeValue.put("dqtimported!q{qt.gui.color}.QColor(");
            foreach (i, c; property.children[0].children)
            {
                if (i)
                    codeValue.put(", ");
                enforce(c.children.length == 1);
                enforce(c.children[0].type == EntityType.text);
                codeValue.put(c.children[0].text);
            }
            codeValue.put(")");
        }
        else if (property.children[0].name.among("bool", "number", "double"))
        {
            enforce(property.children[0].children.length == 1);
            enforce(property.children[0].children[0].type == EntityType.text);
            codeValue.put(property.children[0].children[0].text);
        }
        else if (property.children[0].name == "set")
        {
            enforce(property.children[0].children.length == 1);
            enforce(property.children[0].children[0].type == EntityType.text);
            codeValue.put("dqtimported!q{qt.core.flags}.flagsFromStaticString!(typeof(");
            codeValue.put(widgetName);
            codeValue.put(".");
            codeValue.put(name);
            codeValue.put("()), q{");
            codeValue.put(property.children[0].children[0].text);
            codeValue.put("})");
        }
        else if (property.children[0].name == "enum")
        {
            enforce(property.children[0].children.length == 1);
            enforce(property.children[0].children[0].type == EntityType.text);
            codeValue.put("dqtimported!q{qt.core.flags}.enumFromStaticString!(typeof(");
            codeValue.put(widgetName);
            codeValue.put(".");
            codeValue.put(name);
            codeValue.put("()), q{");
            codeValue.put(property.children[0].children[0].text);
            codeValue.put("})");
        }
        else if (property.children[0].name == "string")
        {
            string value;
            if (property.children[0].children.length)
            {
                enforce(property.children[0].children.length == 1);
                enforce(property.children[0].children[0].type == EntityType.text);
                value = property.children[0].children[0].text;
            }
            if (name == "title" && property.name == "attribute")
                methodName = "setTabText";
            if (name == "text" && widgetType == "QComboBox")
                methodName = "setItemText";
            if (value.length == 0)
            {
                if (widgetType == "QTreeWidget")
                    return;
                codeValue.put("dqtimported!q{qt.core.string}.QString.create()");
            }
            else if (noTr)
            {
                codeValue.put("dqtimported!q{qt.core.string}.QString.fromUtf8(");
                writeStringLiteral(codeValue, value.asDecodedXML);
                codeValue.put(")");
            }
            else
            {
                codeValue.put("dqtimported!q{qt.core.coreapplication}.QCoreApplication.translate(\"");
                codeValue.put(rootWidgetInfo.name);
                codeValue.put("\", ");
                writeStringLiteral(codeValue, value.asDecodedXML);
                codeValue.put(", ");
                if (comment.length)
                    writeStringLiteral(codeValue, comment.asDecodedXML);
                else
                    codeValue.put("null");
                codeValue.put(")");
            }
            needTmp = true;
        }
        else if (property.children[0].name == "size")
        {
            string width, height;
            foreach (i, c; property.children[0].children)
            {
                enforce(c.children.length == 1);
                enforce(c.children[0].type == EntityType.text);
                if (c.name == "width")
                    width = c.children[0].text;
                else if (c.name == "height")
                    height = c.children[0].text;
                else
                    enforce(false);
            }

            codeValue.put("dqtimported!q{qt.core.size}.QSize(");
            codeValue.put(width);
            codeValue.put(", ");
            codeValue.put(height);
            codeValue.put(")");
            needTmp = true;
        }
        else if (property.children[0].name == "sizepolicy")
        {
            string hsizetype="Expanding", vsizetype="Expanding";
            foreach (attr; property.children[0].attributes)
            {
                if (attr.name == "hsizetype")
                    hsizetype = attr.value;
                if (attr.name == "vsizetype")
                    vsizetype = attr.value;
            }

            string sizePolicyVar = createTmpVar(*tmpCount, "sizePolicy");
            code.put("        auto ");
            code.put(sizePolicyVar);
            code.put(" = dqtimported!q{qt.widgets.sizepolicy}.QSizePolicy(dqtimported!q{qt.widgets.sizepolicy}.QSizePolicy.Policy.");
            code.put(hsizetype);
            code.put(", dqtimported!q{qt.widgets.sizepolicy}.QSizePolicy.Policy.");
            code.put(vsizetype);
            code.put(");\n");

            foreach (i, c; property.children[0].children)
            {
                enforce(c.children.length == 1);
                enforce(c.children[0].type == EntityType.text);
                code.put("        ");
                code.put(sizePolicyVar);
                code.put(".");
                if (c.name == "horstretch")
                    code.put("setHorizontalStretch");
                else if (c.name == "verstretch")
                    code.put("setVerticalStretch");
                else
                    enforce(false);
                code.put("(");
                code.put(c.children[0].text);
                code.put(");\n");
            }

            code.put("        ");
            code.put(sizePolicyVar);
            code.put(".");
            code.put("setHeightForWidth");
            code.put("(");
            code.put(widgetName);
            code.put(".sizePolicy().hasHeightForWidth());\n");

            codeValue.put(sizePolicyVar);
        }
        else if (property.children[0].name == "font")
        {
            string fontVar = createTmpVar(*tmpCount, "font");
            code.put("        auto ");
            code.put(fontVar);
            code.put(" = dqtimported!q{qt.gui.font}.QFont.create();\n");

            foreach (i, c; property.children[0].children)
            {
                enforce(c.children.length == 1);
                enforce(c.children[0].type == EntityType.text);
                code.put("        ");
                code.put(fontVar);
                code.put(".");
                if (c.name == "pointsize")
                    code.put("setPointSize");
                else
                {
                    code.put("set");
                    code.put(c.name.capitalize);
                }
                code.put("(");
                code.put(c.children[0].text);
                code.put(");\n");
            }

            codeValue.put(fontVar);
        }
        else if (property.children[0].name == "pixmap")
        {
            enforce(property.children[0].children.length == 1);
            enforce(property.children[0].children[0].type == EntityType.text);
            codeValue.put("dqtimported!q{qt.gui.pixmap}.QPixmap(dqtimported!q{qt.core.string}.QString(");
            writeStringLiteral(codeValue, property.children[0].children[0].text);
            codeValue.put("))");
        }
        else if (property.children[0].name == "cursorShape")
        {
            enforce(property.children[0].children.length == 1);
            enforce(property.children[0].children[0].type == EntityType.text);
            codeValue.put("dqtimported!q{qt.gui.cursor}.QCursor(dqtimported!q{qt.core.namespace}.CursorShape.");
            codeValue.put(property.children[0].children[0].text);
            codeValue.put(")");
            needTmp = true;
        }
        else if (property.children[0].name == "datetime")
        {
            string year, month, day, hour, minute, second;
            foreach (i, c; property.children[0].children)
            {
                enforce(c.children.length == 1);
                enforce(c.children[0].type == EntityType.text);
                if (c.name == "year")
                    year = c.children[0].text;
                else if (c.name == "month")
                    month = c.children[0].text;
                else if (c.name == "day")
                    day = c.children[0].text;
                else if (c.name == "hour")
                    hour = c.children[0].text;
                else if (c.name == "minute")
                    minute = c.children[0].text;
                else if (c.name == "second")
                    second = c.children[0].text;
                else
                    enforce(false);
            }

            string var = createTmpVar(*tmpCount, "datetime");
            code.put("        auto ");
            code.put(var);
            code.put(" = ");
            code.put("dqtimported!q{qt.core.datetime}.QDateTime(");
            code.put("dqtimported!q{qt.core.datetime}.QDate(");
            code.put(year);
            code.put(", ");
            code.put(month);
            code.put(", ");
            code.put(day);
            code.put("),");
            code.put("dqtimported!q{qt.core.datetime}.QTime(");
            code.put(hour);
            code.put(", ");
            code.put(minute);
            code.put(", ");
            code.put(second);
            code.put(")");
            code.put(");\n");
            codeValue.put(var);
        }
        else if (property.children[0].name == "date")
        {
            string year, month, day;
            foreach (i, c; property.children[0].children)
            {
                enforce(c.children.length == 1);
                enforce(c.children[0].type == EntityType.text);
                if (c.name == "year")
                    year = c.children[0].text;
                else if (c.name == "month")
                    month = c.children[0].text;
                else if (c.name == "day")
                    day = c.children[0].text;
                else
                    enforce(false);
            }

            string var = createTmpVar(*tmpCount, "date");
            code.put("        auto ");
            code.put(var);
            code.put(" = ");
            code.put("dqtimported!q{qt.core.datetime}.QDate(");
            code.put(year);
            code.put(", ");
            code.put(month);
            code.put(", ");
            code.put(day);
            code.put(");\n");
            codeValue.put(var);
        }
        else if (property.children[0].name == "time")
        {
            string hour, minute, second;
            foreach (i, c; property.children[0].children)
            {
                enforce(c.children.length == 1);
                enforce(c.children[0].type == EntityType.text);
                if (c.name == "hour")
                    hour = c.children[0].text;
                else if (c.name == "minute")
                    minute = c.children[0].text;
                else if (c.name == "second")
                    second = c.children[0].text;
                else
                    enforce(false);
            }

            string var = createTmpVar(*tmpCount, "time");
            code.put("        auto ");
            code.put(var);
            code.put(" = ");
            code.put("dqtimported!q{qt.core.datetime}.QTime(");
            code.put(hour);
            code.put(", ");
            code.put(minute);
            code.put(", ");
            code.put(second);
            code.put(");\n");
            codeValue.put(var);
        }
        else if (property.children[0].name == "iconset")
        {
            string iconVar = createTmpVar(*tmpCount, "iconVar");

            code.put("        dqtimported!q{qt.gui.icon}.QIcon ");
            code.put(iconVar);
            code.put(";\n");

            string theme;
            foreach (attr; property.children[0].attributes)
            {
                if (attr.name == "theme")
                    theme = attr.value;
            }

            if (theme.length)
            {
                string iconNameVar = createTmpVar(*tmpCount, "iconThemeName");

                code.put("          auto ");
                code.put(iconNameVar);
                code.put(" = dqtimported!q{qt.core.string}.QString(");
                writeStringLiteral(*code, theme);
                code.put(");\n");
                code.put("        if (dqtimported!q{qt.gui.icon}.QIcon.hasThemeIcon(");
                code.put(iconNameVar);
                code.put(")) {\n");
                code.put("        ");
                code.put(iconVar);
                code.put(" = dqtimported!q{qt.gui.icon}.QIcon.fromTheme(");
                code.put(iconNameVar);
                code.put(");\n");
                code.put("        } else {\n");
            }

            foreach (i, c; property.children[0].children)
            {
                if (c.type == EntityType.text)
                    continue;
                enforce(c.children.length == 1);
                enforce(c.children[0].type == EntityType.text);

                string type = c.name;
                string mode, state;
                if (type.endsWith("on"))
                {
                    mode = type[0..$-2];
                    state = type[$-2..$];
                }
                else if (type.endsWith("off"))
                {
                    mode = type[0..$-3];
                    state = type[$-3..$];
                }
                else
                    enforce(false);

                if (theme.length)
                    code.put("  ");
                code.put("        ");
                code.put(iconVar);
                code.put(".addFile(dqtimported!q{qt.core.string}.QString(");
                writeStringLiteral(*code, c.children[0].text);
                code.put("), globalInitVar!(dqtimported!q{qt.core.size}.QSize), dqtimported!q{qt.gui.icon}.QIcon.Mode.");
                code.put(mode.capitalize);
                code.put(", dqtimported!q{qt.gui.icon}.QIcon.State.");
                code.put(state.capitalize);
                code.put(");\n");
            }

            if (theme.length)
                code.put("        }\n");
            codeValue.put(iconVar);
        }
        else
            enforce(false, "Unsupported property type " ~ property.children[0].name);

        code.put("        ");
        string tmpVar;
        if (needTmp)
        {
            tmpVar = createTmpVar(*tmpCount, "tmp");
            code.put("auto ");
            code.put(tmpVar);
            code.put(" = ");
            code.put(codeValue.data);
            code.put(";\n");
            code.put("        ");
        }
        code.put(widgetName);
        code.put(".");
        code.put(methodName);
        code.put("(");
        code.put(extraArg);
        if (needTmp)
            code.put(tmpVar);
        else
            code.put(codeValue.data);
        code.put(");\n");
    }

    WidgetInfo addItem(DOMEntity widget, string parentName, string parentType, bool isRoot, size_t itemIndex)
    {
        WidgetInfo info = getWidgetInfo(widget);

        string extraArg;
        string name;
        if (parentType == "QComboBox")
        {
            codeSetup.put("        ");
            codeSetup.put(parentName);
            codeSetup.put(".addItem(dqtimported!q{qt.core.string}.QString.create());\n");
            extraArg = text(itemIndex, ", ");
            name = parentName;
        }
        else if (parentType == "QTreeWidget")
        {
            name = createTmpVar(tmpCountSetup, "__qtreewidgetitem");
            codeSetup.put("        dqtimported!q{qt.widgets.treewidget}.QTreeWidgetItem ");
            codeSetup.put(name);
            codeSetup.put(" = cpp_new!(dqtimported!q{qt.widgets.treewidget}.QTreeWidgetItem)(");
            codeSetup.put(parentName);
            codeSetup.put(");\n");

            codeRetranslate.put("        dqtimported!q{qt.widgets.treewidget}.QTreeWidgetItem ");
            codeRetranslate.put(name);
            codeRetranslate.put(" = ");
            codeRetranslate.put(parentName);
            codeRetranslate.put(isRoot ? ".topLevelItem(" : ".child(");
            codeRetranslate.put(text(itemIndex));
            codeRetranslate.put(");\n");
        }
        else if (parentType == "column")
        {
            extraArg = text(itemIndex, ", ");
            name = parentName;
        }
        size_t[string] columnByProperty;
        foreach (property; widget.children)
        {
            if (parentType == "QTreeWidget")
            {
                string propName;
                foreach (attr; property.attributes)
                {
                    if (attr.name == "name")
                        propName = attr.value;
                }
                if (propName == "flags")
                    extraArg = "";
                else
                {
                    size_t col = columnByProperty.get(propName, 0);
                    extraArg = text(col, ", ");
                    columnByProperty[propName] = col + 1;
                }
            }
            if (property.name == "property")
                addProperty(property, name, parentType, false, extraArg);
        }
        size_t childItemCount;
        foreach (c; widget.children)
        {
            if (c.name == "item")
            {
                addItem(c, name, parentType, false, childItemCount);
                childItemCount++;
            }
        }
        return info;
    }

    WidgetInfo addWidget(DOMEntity widget, string parentName, WidgetInfo parentInfo, WidgetInfo parentParentInfo)
    {
        WidgetInfo info = getWidgetInfo(widget);

        if (info.name.length)
        {
            widgetTypes[info.name] = info.className;
        }

        if (widget.name == "spacer")
        {
            string orientation;
            string sizeType = "Expanding";
            string width = "0";
            string height = "0";

            foreach (property; widget.children)
            {
                if (property.name == "property")
                {
                    string propName;
                    foreach (attr; property.attributes)
                    {
                        if (attr.name == "name")
                            propName = attr.value;
                    }

                    if (propName == "orientation")
                    {
                        enforce(property.children.length == 1);
                        enforce(property.children[0].name == "enum");
                        enforce(property.children[0].children.length == 1);
                        orientation = property.children[0].children[0].text;
                    }
                    else if (propName == "sizeType")
                    {
                        enforce(property.children.length == 1);
                        enforce(property.children[0].name == "enum");
                        enforce(property.children[0].children.length == 1);
                        sizeType = property.children[0].children[0].text;
                        enforce(sizeType.startsWith("QSizePolicy::"));
                        sizeType = sizeType["QSizePolicy::".length..$];
                    }
                    else if (propName == "sizeHint")
                    {
                        enforce(property.children.length == 1);
                        enforce(property.children[0].name == "size");
                        enforce(property.children[0].children.length == 2);
                        enforce(property.children[0].children[0].name == "width");
                        enforce(property.children[0].children[1].name == "height");
                        width = property.children[0].children[0].children[0].text;
                        height = property.children[0].children[1].children[0].text;
                    }
                }
            }

            codeVars.put("    ");
            codeVars.put("dqtimported!q{");
            codeVars.put(getWidgetModule(info.className));
            codeVars.put("}.");
            codeVars.put(info.className);
            codeVars.put(" ");
            codeVars.put(info.name);
            codeVars.put(";\n");

            codeSetup.put("        ");
            codeSetup.put(info.name);
            codeSetup.put(" = cpp_new!(dqtimported!q{");
            codeSetup.put(getWidgetModule(info.className));
            codeSetup.put("}.");
            codeSetup.put(info.className);
            codeSetup.put(")(");
            codeSetup.put(width);
            codeSetup.put(", ");
            codeSetup.put(height);
            codeSetup.put(", ");
            if (orientation == "Qt::Horizontal")
            {
                codeSetup.put("dqtimported!q{qt.widgets.sizepolicy}.QSizePolicy.Policy.");
                codeSetup.put(sizeType);
                codeSetup.put(", ");
                codeSetup.put("dqtimported!q{qt.widgets.sizepolicy}.QSizePolicy.Policy.Minimum");
            }
            else if (orientation == "Qt::Vertical")
            {
                codeSetup.put("dqtimported!q{qt.widgets.sizepolicy}.QSizePolicy.Policy.Minimum");
                codeSetup.put(", ");
                codeSetup.put("dqtimported!q{qt.widgets.sizepolicy}.QSizePolicy.Policy.");
                codeSetup.put(sizeType);
            }
            else
                enforce(false);
            codeSetup.put(");\n");
            return info;
        }

        if (info.name.length)
        {
            codeVars.put("    ");
            if (info.className == "Line")
            {
                codeVars.put("dqtimported!q{qt.widgets.frame}.QFrame");
            }
            else
            {
                codeVars.put("dqtimported!q{");
                codeVars.put(getWidgetModule(info.className));
                codeVars.put("}.");
                codeVars.put(info.className);
            }
            codeVars.put(" ");
            codeVars.put(info.name);
            codeVars.put(";\n");

            codeSetup.put("        ");
            codeSetup.put(info.name);
            codeSetup.put(" = cpp_new!(");
            if (info.className == "Line")
            {
                codeSetup.put("dqtimported!q{qt.widgets.frame}.QFrame");
            }
            else
            {
                codeSetup.put("dqtimported!q{");
                codeSetup.put(getWidgetModule(info.className));
                codeSetup.put("}.");
                codeSetup.put(info.className);
            }
            codeSetup.put(")(");
            if (!(parentInfo.xmlName == "layout" && widget.name == "layout"))
                codeSetup.put(parentName);
            codeSetup.put(");\n");
        }
        string sortingEnabledVar;
        if (info.className == "QTreeWidget")
        {
            string headerName = createTmpVar(tmpCountSetup, "__qtreewidgetitem");
            codeSetup.put("        dqtimported!q{qt.widgets.treewidget}.QTreeWidgetItem ");
            codeSetup.put(headerName);
            codeSetup.put(" = cpp_new!(dqtimported!q{qt.widgets.treewidget}.QTreeWidgetItem)(");
            codeSetup.put(");\n");

            codeRetranslate.put("        dqtimported!q{qt.widgets.treewidget}.QTreeWidgetItem ");
            codeRetranslate.put(headerName);
            codeRetranslate.put(" = ");
            codeRetranslate.put(info.name);
            codeRetranslate.put(".headerItem();\n");

            size_t childItemCount;
            foreach (c; widget.children)
            {
                if (c.name == "column")
                {
                    WidgetInfo childInfo = addItem(c, headerName, "column", true, childItemCount);
                    childItemCount++;
                }
            }

            codeSetup.put("        ");
            codeSetup.put(info.name);
            codeSetup.put(".setHeaderItem(");
            codeSetup.put(headerName);
            codeSetup.put(");\n");

            sortingEnabledVar = createTmpVar(tmpCountRetranslate, "__sortingEnabled");
            codeRetranslate.put("        const(bool) ");
            codeRetranslate.put(sortingEnabledVar);
            codeRetranslate.put(" = ");
            codeRetranslate.put(info.name);
            codeRetranslate.put(".isSortingEnabled();\n");

            codeRetranslate.put("        ");
            codeRetranslate.put(info.name);
            codeRetranslate.put(".setSortingEnabled(false);\n");
        }
        size_t childItemCount;
        foreach (c; widget.children)
        {
            if (c.name == "item" && widget.name != "layout")
            {
                WidgetInfo childInfo = addItem(c, info.name, info.className, true, childItemCount);
                childItemCount++;
            }
        }
        if (info.name.length)
        {
            codeSetup.put("        ");
            codeSetup.put(info.name);
            codeSetup.put(".setObjectName(\"");
            codeSetup.put(info.name);
            codeSetup.put("\");\n");
        }

        string constructorArg = info.name;
        if (info.className == "QTabWidget")
            constructorArg = "";
        if (info.className == "QScrollArea")
            constructorArg = "";
        if (widget.name == "layout")
            constructorArg = parentName;
        if (widget.name == "item")
            constructorArg = parentName;
        string[string] margins;
        foreach (property; widget.children)
        {
            if (property.name == "property")
            {
                string name;
                foreach (attr; property.attributes)
                {
                    if (attr.name == "name")
                        name = attr.value;
                }
                if (name.among("leftMargin", "topMargin", "rightMargin", "bottomMargin"))
                {
                    enforce(property.children[0].name == "number");
                    enforce(property.children[0].children.length == 1);
                    enforce(property.children[0].children[0].type == EntityType.text);
                    margins[name] = property.children[0].children[0].text;
                }
                else
                    addProperty(property, info.name, info.className, false, "");
            }
        }
        bool inLayoutInSplitter = parentInfo.className == "QWidget" && parentParentInfo.className == "QSplitter" && info.xmlName == "layout";
        if (margins !is null || inLayoutInSplitter)
        {
            string defaultMargin = (parentInfo.xmlName == "layout") ? "0" : "-1";
            if (inLayoutInSplitter)
                defaultMargin = "0";
            codeSetup.put("        ");
            codeSetup.put(info.name);
            codeSetup.put(".setContentsMargins(");
            codeSetup.put(margins.get("leftMargin", defaultMargin));
            codeSetup.put(", ");
            codeSetup.put(margins.get("topMargin", defaultMargin));
            codeSetup.put(", ");
            codeSetup.put(margins.get("rightMargin", defaultMargin));
            codeSetup.put(", ");
            codeSetup.put(margins.get("bottomMargin", defaultMargin));
            codeSetup.put(");\n");
        }
        foreach (c; widget.children)
        {
            WidgetInfo childInfo = addChildWidget(widget, info, c, constructorArg, info, parentInfo);
            if (info.className == "QTabWidget")
            {
                foreach (property; c.children)
                {
                    if (property.name == "attribute")
                        addProperty(property, info.name, info.className, false, info.name ~ ".indexOf(" ~ childInfo.name ~ "), ");
                }
            }
        }
        if (info.className == "QTreeWidget")
        {
            codeRetranslate.put("        ");
            codeRetranslate.put(info.name);
            codeRetranslate.put(".setSortingEnabled(");
            codeRetranslate.put(sortingEnabledVar);
            codeRetranslate.put(");\n");
        }
        return info;
    }

    WidgetInfo addChildWidget(DOMEntity widget, WidgetInfo info, DOMEntity c, string constructorArg, WidgetInfo parentInfo, WidgetInfo parentParentInfo)
    {
        if (c.name == "item" && widget.name == "layout")
        {
            enforce(c.children.length == 1);
            WidgetInfo childInfo = addWidget(c.children[0], constructorArg, parentInfo, parentParentInfo);

            string row, column, rowspan = "1", colspan = "1";
            foreach (attr; c.attributes)
            {
                if (attr.name == "row")
                    row = attr.value;
                if (attr.name == "column")
                    column = attr.value;
                if (attr.name == "rowspan")
                    rowspan = attr.value;
                if (attr.name == "colspan")
                    colspan = attr.value;
            }

            codeSetup.put("\n        ");
            codeSetup.put(info.name);
            if (info.className == "QFormLayout")
            {
                if (c.children[0].name == "layout")
                    codeSetup.put(".setLayout(");
                else if (c.children[0].name == "spacer")
                    codeSetup.put(".setItem(");
                else
                    codeSetup.put(".setWidget(");

                codeSetup.put(row);
                codeSetup.put(", dqtimported!q{qt.widgets.formlayout}.QFormLayout.ItemRole.");
                codeSetup.put((column == "1") ? "FieldRole" : "LabelRole");
                codeSetup.put(", ");
            }
            else
            {
                if (c.children[0].name == "layout")
                    codeSetup.put(".addLayout(");
                else if (c.children[0].name == "spacer")
                    codeSetup.put(".addItem(");
                else
                    codeSetup.put(".addWidget(");
            }
            codeSetup.put(childInfo.name);
            if (info.className == "QGridLayout")
            {
                codeSetup.put(", ");
                codeSetup.put(row);
                codeSetup.put(", ");
                codeSetup.put(column);
                codeSetup.put(", ");
                codeSetup.put(rowspan);
                codeSetup.put(", ");
                codeSetup.put(colspan);
            }
            codeSetup.put(");\n\n");
            return childInfo;
        }
        else if (c.name == "widget" || c.name == "layout")
        {
            WidgetInfo childInfo = addWidget(c, constructorArg, parentInfo, parentParentInfo);

            if (info.className == "QTabWidget")
            {
                codeSetup.put("        ");
                codeSetup.put(info.name);
                codeSetup.put(".addTab(");
                codeSetup.put(childInfo.name);
                codeSetup.put(", ");
                codeSetup.put("dqtimported!q{qt.core.string}.QString.create()"); // TODO: not translateable strings
                codeSetup.put(");\n");
            }
            else if (info.className == "QMainWindow")
            {
                if (childInfo.className != "QMenuBar" && childInfo.className != "QStatusBar")
                    codeSetup.put("\n");
                codeSetup.put("        ");
                codeSetup.put(info.name);
                if (childInfo.className == "QMenuBar")
                    codeSetup.put(".setMenuBar(");
                else if (childInfo.className == "QStatusBar")
                    codeSetup.put(".setStatusBar(");
                else
                    codeSetup.put(".setCentralWidget(");
                codeSetup.put(childInfo.name);
                codeSetup.put(");\n");
            }
            else if (info.className == "QSplitter")
            {
                codeSetup.put("        ");
                codeSetup.put(info.name);
                codeSetup.put(".addWidget(");
                codeSetup.put(childInfo.name);
                codeSetup.put(");\n");
            }
            else if (info.className == "QScrollArea")
            {
                codeSetup.put("        ");
                codeSetup.put(info.name);
                codeSetup.put(".setWidget(");
                codeSetup.put(childInfo.name);
                codeSetup.put(");\n");
            }
            return childInfo;
        }
        else if (c.name == "addaction")
        {
            string name;
            foreach (attr; c.attributes)
            {
                if (attr.name == "name")
                    name = attr.value;
            }

            codeSetupAddActions.put("        ");
            codeSetupAddActions.put(info.name);
            codeSetupAddActions.put(".addAction(");
            codeSetupAddActions.put(name);
            if (name in widgetTypes && widgetTypes[name].among("QMenu", "QMenuBar"))
                codeSetupAddActions.put(".menuAction()");
            codeSetupAddActions.put(");\n");
        }
        return WidgetInfo.init;
    }

    void addConnection(DOMEntity connection)
    {
        string sender, signal, receiver, slot;
        foreach (ref c; connection.children)
        {
            if (c.name == "sender")
            {
                enforce(c.children.length == 1);
                enforce(c.children[0].type == EntityType.text);
                sender = c.children[0].text;
            }
            else if (c.name == "signal")
            {
                enforce(c.children.length == 1);
                enforce(c.children[0].type == EntityType.text);
                signal = c.children[0].text;
            }
            else if (c.name == "receiver")
            {
                enforce(c.children.length == 1);
                enforce(c.children[0].type == EntityType.text);
                receiver = c.children[0].text;
            }
            else if (c.name == "slot")
            {
                enforce(c.children.length == 1);
                enforce(c.children[0].type == EntityType.text);
                slot = c.children[0].text;
            }
        }

        // Ignore parameter types for signal and slot for now.
        foreach (i, char c; signal)
            if (c == '(')
            {
                signal = signal[0..i];
                break;
            }
        foreach (i, char c; slot)
            if (c == '(')
            {
                slot = slot[0..i];
                break;
            }

        codeSetupConnect.put("        dqtimported!q{qt.core.object}.QObject.connect(");
        codeSetupConnect.put(sender);
        codeSetupConnect.put(".signal!\"");
        codeSetupConnect.put(signal);
        codeSetupConnect.put("\", ");
        codeSetupConnect.put(receiver);
        codeSetupConnect.put(".slot!\"");
        codeSetupConnect.put(slot);
        codeSetupConnect.put("\");\n");
    }

    string convert(string xml, string customWidgetPackage)
    {
        this.customWidgetPackage = customWidgetPackage;
        auto dom = parseDOM!simpleXML(xml);
        assert(dom.type == EntityType.elementStart);

        enforce(dom.children.length == 1);
        auto root = dom.children[0];
        enforce(root.name == "ui");

        DOMEntity* rootWidget;
        foreach (ref c; root.children)
        {
            if (c.name == "widget")
            {
                enforce(rootWidget is null, "Multpile root widgets");
                rootWidget = &c;
            }
        }
        enforce(rootWidget !is null);
        rootWidgetInfo = getWidgetInfo(*rootWidget);

        codeSetup.put("        if (");
        codeSetup.put(rootWidgetInfo.name);
        codeSetup.put(".objectName().isEmpty())\n");
        codeSetup.put("            ");
        codeSetup.put(rootWidgetInfo.name);
        codeSetup.put(".setObjectName(\"");
        codeSetup.put(rootWidgetInfo.name);
        codeSetup.put("\");\n");

        foreach (c; rootWidget.children)
        {
            if (c.name == "property")
                addProperty(c, rootWidgetInfo.name, rootWidgetInfo.className, true, "");
        }

        foreach (c; rootWidget.children)
        {
            if (c.name == "action")
            {
                addWidget(c, rootWidgetInfo.name, WidgetInfo(), WidgetInfo());
            }
        }

        foreach (c; rootWidget.children)
        {
            addChildWidget(*rootWidget, rootWidgetInfo, c, rootWidgetInfo.name, WidgetInfo(), WidgetInfo());
        }

        foreach (c; root.children)
        {
            if (c.name == "connections")
            {
                foreach (c2; c.children)
                {
                    if (c2.name == "connection")
                    {
                        addConnection(c2);
                    }
                }
            }
        }

        codeVars.put("\n");
        codeVars.put("    void setupUi(");
        codeVars.put("dqtimported!q{");
        codeVars.put(getWidgetModule(rootWidgetInfo.className));
        codeVars.put("}.");
        codeVars.put(rootWidgetInfo.className);
        codeVars.put(" ");
        codeVars.put(rootWidgetInfo.name);
        codeVars.put(")\n");
        codeVars.put("    {\n");
        codeVars.put("        import core.stdcpp.new_: cpp_new;\n");
        codeVars.put(codeSetup.data);
        codeVars.put(codeSetupAddActions.data);
        codeVars.put("\n        retranslateUi(");
        codeVars.put(rootWidgetInfo.name);
        codeVars.put(");\n");
        codeVars.put(codeSetupConnect.data);
        codeVars.put(codeSetupDelayed.data);
        codeVars.put("\n        dqtimported!q{qt.core.objectdefs}.QMetaObject.connectSlotsByName(");
        codeVars.put(rootWidgetInfo.name);
        codeVars.put(");\n");
        codeVars.put("    } // setupUi\n");
        codeVars.put("\n");
        codeVars.put("    void retranslateUi(");
        codeVars.put("dqtimported!q{");
        codeVars.put(getWidgetModule(rootWidgetInfo.className));
        codeVars.put("}.");
        codeVars.put(rootWidgetInfo.className);
        codeVars.put(" ");
        codeVars.put(rootWidgetInfo.name);
        codeVars.put(")\n");
        codeVars.put("    {\n");
        codeVars.put(codeRetranslate.data);
        codeVars.put("    } // retranslateUi\n");
        return codeVars.data;
    }
}


/++
    Generates code from *.ui file created with [Qt Designer](https://doc.qt.io/qt-5/qtdesigner-manual.html).

    The generated code contains multiple declarations:
    Every widget in the *.ui file is declared as a variable.
    The function `setupUi` is created, which creates and configures all
    widgets.
    The function `retranslateUi` sets all translatable strings.

    Params:
        xml        = Content of *.ui file.
        customWidgetPackage = Package for custom widgets used in *.ui file.

    Returns:
        D code for use in mixin.
+/
string generateUICode()(string xml, string customWidgetPackage = "")
{
    return UICodeWriter!()().convert(xml, customWidgetPackage);
}

/++
    Struct for using a *.ui file created with [Qt Designer](https://doc.qt.io/qt-5/qtdesigner-manual.html).

    The *.ui file is read at compile time with the [import expression](https://dlang.org/spec/expression.html#import_expressions).
    Use the dmd option -J for setting the search path for those files.
    The members of the struct are created with `generateUICode`.

    Params:
        filename   = Filename of *.ui file.
        customWidgetPackage = Package for custom widgets used in *.ui file.
+/
struct UIStruct(string filename, string customWidgetPackage = "")
{
    mixin(generateUICode(import(filename), customWidgetPackage));
}
