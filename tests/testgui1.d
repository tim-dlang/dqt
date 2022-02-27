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

    QColor color2 = QColor.fromRgb(101, 102, 103, 104);
    assert(color2.red() == 101);
    assert(color2.green() == 102);
    assert(color2.blue() == 103);
    assert(color2.alpha() == 104);

    QBrush brush2 = QBrush(color2);
    item.setBackground(brush2);
    brush2 = item.background();
    assert(brush2.color() == color2);
}

unittest
{
    import qt.core.list;
    import qt.core.variant;
    import qt.gui.brush;
    import qt.gui.color;

    QBrushData* data;
    {
        QBrush b = QBrush(QColor(1, 2, 3));
        data = *cast(QBrushData**)&b;
        assert(data.ref_.loadRelaxed() == 1);
        data.ref_.ref_(); // Add reference, so it is not freed and we can check the count at the end.
        assert(data.ref_.loadRelaxed() == 2);
        QBrush b2 = b;
        assert(data.ref_.loadRelaxed() == 3);
    }
    assert(data.ref_.loadRelaxed() == 1); // Only our extra reference remains.
    {
        QBrush b = QBrush(QColor(1, 2, 3));
        data = *cast(QBrushData**)&b;
        assert(data.ref_.loadRelaxed() == 1);
        data.ref_.ref_(); // Add reference, so it is not freed and we can check the count at the end.
        assert(data.ref_.loadRelaxed() == 2);
        QVariant v = QVariant.fromValue(b);
        assert(data.ref_.loadRelaxed() == 3);
        QVariant v2 = v;
        assert(data.ref_.loadRelaxed() == 4);
    }
    assert(data.ref_.loadRelaxed() == 1); // Only our extra reference remains.
    {
        QBrush b = QBrush(QColor(1, 2, 3));
        data = *cast(QBrushData**)&b;
        assert(data.ref_.loadRelaxed() == 1);
        data.ref_.ref_(); // Add reference, so it is not freed and we can check the count at the end.
        assert(data.ref_.loadRelaxed() == 2);
        QList!(QBrush) l = QList!(QBrush).create();
        l.append(b);
        assert(data.ref_.loadRelaxed() == 3);
    }
    assert(data.ref_.loadRelaxed() == 1); // Only our extra reference remains.
}
