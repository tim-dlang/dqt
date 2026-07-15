// QT_MODULES: core gui
import qt.core.locale;
import qt.core.metatype;
import qt.core.string;
import qt.core.variant;
import qt.core.vector;
import qt.core.flags;
import qt.core.namespace;
import qt.core.bytearray;
import qt.core.datetime;
import qt.core.rect;
import qt.core.size;
import qt.core.line;
import qt.core.point;
import qt.core.url;
import qt.helpers;
import qt.gui.color;
import qt.gui.font;
import qt.gui.pen;
import qt.gui.brush;
import qt.gui.palette;
import qt.gui.transform;
import qt.core.stringlist;
import core.stdcpp.new_;
import std.conv;
import std.stdio;
import std.string;

unittest
{
    bool anyFailure = false;

    // Primitive types
    anyFailure |= fromValueFailure!bool(true);
    anyFailure |= fromValueFailure!int(42);
    anyFailure |= fromValueFailure!uint(42u);
    anyFailure |= fromValueFailure!long(42L);
    anyFailure |= fromValueFailure!ulong(42UL);
    anyFailure |= fromValueFailure!double(3.14);
    anyFailure |= fromValueFailure!float(1.5f);
    anyFailure |= fromValueFailure!char('A');

    // Core value types
    anyFailure |= fromValueFailure!QString(QString("Hello"));
    anyFailure |= fromValueFailure!QByteArray(QByteArray("bytes"));
    anyFailure |= fromValueFailure!QDate(QDate(2026, 7, 15));
    anyFailure |= fromValueFailure!QTime(QTime(10, 30, 0));
    anyFailure |= fromValueFailure!QDateTime(QDateTime(QDate(2026, 7, 15), QTime(10, 30, 0)));
    anyFailure |= fromValueFailure!QUrl(QUrl("https://dqt.example.com"));
    anyFailure |= fromValueFailure!QLocale(QLocale(QLocale.Language.English, QLocale.Country.UnitedKingdom));

    // Geometry types
    anyFailure |= fromValueFailure!QRect(QRect(10, 20, 100, 200));
    anyFailure |= fromValueFailure!QRectF(QRectF(1.5, 2.5, 10.0, 20.0));
    anyFailure |= fromValueFailure!QSize(QSize(640, 480));
    anyFailure |= fromValueFailure!QSizeF(QSizeF(3.5, 2.0));
    anyFailure |= fromValueFailure!QLine(QLine(0, 0, 100, 100));
    anyFailure |= fromValueFailure!QLineF(QLineF(0.0, 0.0, 1.0, 1.0));
    anyFailure |= fromValueFailure!QPoint(QPoint(7, 11));
    anyFailure |= fromValueFailure!QPointF(QPointF(2.5, -1.0));

    // GUI value types
    anyFailure |= fromValueFailure!QFont(QFont("Sans", 12));
    anyFailure |= fromValueFailure!QColor(QColor(128, 64, 255));
    anyFailure |= fromValueFailure!QPen(QPen(QColor(255, 0, 0), 2.0));
    anyFailure |= fromValueFailure!QBrush(QBrush(QColor(0, 255, 0)));
    anyFailure |= fromValueFailure!QTransform(QTransform(1, 0, 0, 0, 1, 0, 0, 0, 1));
    
    // Enum and flags types
    QLocale.Language lang = QLocale.Language.English;
    anyFailure |= fromValueFailure!(QLocale.Language)(lang);
    anyFailure |= fromValueFailure!(qt.core.namespace.Orientation)(
        qt.core.namespace.Orientation.Vertical);
    anyFailure |= fromValueFailure!(qt.core.namespace.Alignment)(qt.core.namespace.Alignment.AlignCenter);

    // Container / list types
    auto sl = QStringList.create();
    sl ~= QString("alpha");
    sl ~= QString("beta");
    anyFailure |= fromValueFailure!QStringList(sl);
    
    assert(!anyFailure);
}

bool fromValueFailure(T)(T value)
{
    QVariant v = QVariant.fromValue!T(value);
    bool isValid = v.isValid();
    if (!isValid)
    {
        stderr.writeln("  FAIL: ", typeof(value).stringof, " -> QVariant INVALID (typeId=", v.metaType().id(), ")");
    }
    return !isValid;
}
