// QT_MODULES: gui
module testgui1;

import qt.config;
import qt.helpers;

unittest
{
    import qt.core.metatype;
    import qt.core.namespace;
    import qt.core.string;
    import qt.core.variant;
    import qt.gui.brush;
    import qt.gui.color;
    import qt.gui.standarditemmodel;

    QStandardItem item = new QStandardItem;
    QString tmp = QString("test");
    item.setText(tmp);
    QString text = item.text();
    assert(text == "test");
    assert(qMetaTypeId!(QString)() == QVariant.Type.String);
    assert(item.data(/+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole).userType() == qMetaTypeId!(QString)());
    QVariant variant = QVariant.fromValue(text);
    item.setData(variant, /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole);
    text = item.text();
    assert(text == "test");

    auto tmp2 = QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.red); QBrush brush = QBrush(tmp2);
    item.setBackground(brush);
    brush = item.background();
    assert(brush.color() == QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.red));
}
