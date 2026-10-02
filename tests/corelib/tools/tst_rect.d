// QT_MODULES: core
module corelib.tools.tst_rect;

import qt.core.rect;
import qt.core.point;
import qt.core.size;
import qt.core.margins;
import qt.core.global;
import std.stdio : writeln;
import std.conv : to;

/*
 * Port of qtbase/tests/auto/corelib/tools/qrect/tst_qrect.cpp.
 *
 * Conventions (same as tst_date.d):
 *   - each C++ `*_data` fixture is a separate D function placed immediately
 *     before the test that uses it;
 *   - functionality whose D binding is missing is emitted as commented-out code
 *     with a `// BINDING GAP:` note.
 *
 * BINDING GAP (rvalue parameters): these bound methods take `ref const(T)`
 * parameters, which D cannot bind to rvalue temporaries (C++ const references
 * accept them), so a temporary must be stored in a local first:
 *   - `QRect`: ctors from `QPoint`/`QSize`; `setTopLeft`/`setBottomRight`/
 *     `setTopRight`/`setBottomLeft`, `moveTopLeft`/`moveBottomRight`/
 *     `moveTopRight`/`moveBottomLeft`/`moveCenter`, `translate`, `moveTo`,
 *     `setSize`, `contains`, `intersects`, `opBinary`/`opOpAssign` for `|`/`&`,
 *     `marginsAdded`/`marginsRemoved`, margins `opOpAssign`, `span`
 *     (`ref const(QPoint)`/`QSize`/`QRect`/`QMargins`)
 *   - `QRectF`: the analogous ctors and `set*`/`move*`/`translate`/`moveTo`/
 *     `setSize`/`contains`/`intersects`/`opBinary`/`opOpAssign`/
 *     `marginsAdded`/`marginsRemoved` members
 *     (`ref const(QPointF)`/`QSizeF`/`QRectF`/`QMarginsF`)
 */

private enum int LARGE = 1_000_000_000;
private bool isLarge(int x) { return x > LARGE || x < -LARGE; }

private enum RectCase
{
    Invalid, Smallest, Middle, Largest, SmallestCoord, LargestCoord,
    Random, NegativeSize, NegativePoint, Null, Empty
}
private QRect rectCase(RectCase c)
{
    final switch (c)
    {
        case RectCase.Invalid:       return QRect(0, 0, 0, 0);
        case RectCase.Smallest:      return QRect(1, 1, 1, 1);
        case RectCase.Middle:        return QRect(QPoint(int.min / 2, int.min / 2), QPoint(int.max / 2, int.max / 2));
        case RectCase.Largest:       return QRect(QPoint(0, 0), QPoint(int.max - 1, int.max - 1));
        case RectCase.SmallestCoord: return QRect(QPoint(int.min, int.min), QSize(1, 1));
        case RectCase.LargestCoord:  return QRect(QPoint(int.min, int.min), QPoint(int.max, int.max));
        case RectCase.Random:        return QRect(100, 200, 11, 16);
        case RectCase.NegativeSize:  return QRect(1, 1, -10, -10);
        case RectCase.NegativePoint: return QRect(-10, -10, 5, 5);
        case RectCase.Null:          return QRect(5, 5, 0, 0);
        case RectCase.Empty:         return QRect(QPoint(2, 2), QPoint(1, 1));
    }
}

private int[] intCases()
{
    return [int.min, int.min / 2, 0, int.max / 2, int.max, 4953];
}

private QPoint[] pointCases()
{
    return [
        QPoint(0, 0),
        QPoint(int.min, int.min),
        QPoint(int.min / 2, int.min / 2),
        QPoint(int.max / 2, int.max / 2),
        QPoint(int.max, int.max),
        QPoint(-12, 7),
        QPoint(12, -7),
        QPoint(12, 7),
    ];
}

// ---------------------------------------------------------------------------
// isNull / newIsEmpty / newIsValid
// ---------------------------------------------------------------------------

private struct RectBoolRow
{
    QRect r;
    bool value;
}
private RectBoolRow[] isNull_data()
{
    static immutable bool[] v = [true, false, false, false, false, true, false, false, false, true, true];
    RectBoolRow[] rows;
    foreach (i; 0 .. 11)
        rows ~= RectBoolRow(rectCase(cast(RectCase) i), v[i]);
    return rows;
}

// isNull
unittest
{
    foreach (i, r; isNull_data())
    {
        string ctx = "isNull row " ~ i.to!string;
        QRectF rf = QRectF(r.r);
        assert(r.r.isNull() == r.value, ctx);
        assert(rf.isNull() == r.value, ctx);
    }
}

private RectBoolRow[] newIsEmpty_data()
{
    static immutable bool[] v = [true, false, false, false, false, false, false, true, false, true, true];
    RectBoolRow[] rows;
    foreach (i; 0 .. 11)
        rows ~= RectBoolRow(rectCase(cast(RectCase) i), v[i]);
    return rows;
}

// newIsEmpty
unittest
{
    foreach (i, r; newIsEmpty_data())
    {
        string ctx = "newIsEmpty row " ~ i.to!string;
        QRectF rf = QRectF(r.r);
        assert(r.r.isEmpty() == r.value, ctx);
        if (isLarge(r.r.x()) || isLarge(r.r.y()) || isLarge(r.r.width()) || isLarge(r.r.height()))
            continue;
        assert(rf.isEmpty() == r.value, ctx);
    }
}

private RectBoolRow[] newIsValid_data()
{
    static immutable bool[] v = [false, true, true, true, true, true, true, false, true, false, false];
    RectBoolRow[] rows;
    foreach (i; 0 .. 11)
        rows ~= RectBoolRow(rectCase(cast(RectCase) i), v[i]);
    return rows;
}

// newIsValid
unittest
{
    foreach (i, r; newIsValid_data())
    {
        string ctx = "newIsValid row " ~ i.to!string;
        QRectF rf = QRectF(r.r);
        assert(r.r.isValid() == r.value, ctx);
        if (isLarge(r.r.x()) || isLarge(r.r.y()) || isLarge(r.r.width()) || isLarge(r.r.height()))
            continue;
        assert(rf.isValid() == r.value, ctx);
    }
}

// ---------------------------------------------------------------------------
// normalized
// ---------------------------------------------------------------------------

private struct RectPairRow
{
    QRect r, nr;
}
private RectPairRow[] normalized_data()
{
    return [
        RectPairRow(rectCase(RectCase.Invalid), rectCase(RectCase.Invalid)),
        RectPairRow(rectCase(RectCase.Smallest), QRect(1, 1, 1, 1)),
        RectPairRow(rectCase(RectCase.Middle), QRect(QPoint(int.min / 2, int.min / 2), QPoint(int.max / 2, int.max / 2))),
        RectPairRow(rectCase(RectCase.Largest), QRect(QPoint(0, 0), QPoint(int.max - 1, int.max - 1))),
        RectPairRow(rectCase(RectCase.SmallestCoord), QRect(QPoint(int.min, int.min), QSize(1, 1))),
        RectPairRow(rectCase(RectCase.LargestCoord), rectCase(RectCase.LargestCoord)),
        RectPairRow(rectCase(RectCase.Random), QRect(100, 200, 11, 16)),
        RectPairRow(rectCase(RectCase.NegativeSize), QRect(-9, -9, 10, 10)),
        RectPairRow(rectCase(RectCase.NegativePoint), QRect(-10, -10, 5, 5)),
        RectPairRow(rectCase(RectCase.Null), rectCase(RectCase.Null)),
        RectPairRow(rectCase(RectCase.Empty), rectCase(RectCase.Empty)),
        RectPairRow(QRect(100, 200, 100, 0), QRect(100, 200, 100, 0)),
        RectPairRow(QRect(100, 200, 0, 100), QRect(100, 200, 0, 100)),
        RectPairRow(QRect(QPoint(200, 100), QSize(-1, 100)), QRect(QPoint(199, 100), QSize(1, 100))),
        RectPairRow(QRect(QPoint(100, 200), QSize(100, -1)), QRect(QPoint(100, 199), QSize(100, 1))),
        RectPairRow(QRect(QPoint(200, 100), QPoint(198, 199)), QRect(QPoint(199, 100), QPoint(199, 199))),
        RectPairRow(QRect(QPoint(100, 200), QPoint(199, 199)), QRect(QPoint(100, 200), QPoint(199, 199))),
        RectPairRow(QRect(QPoint(263, 113), QPoint(136, 112)), QRect(QPoint(137, 113), QPoint(262, 112))),
    ];
}

// normalized
unittest
{
    foreach (i, r; normalized_data())
    {
        assert((r.r.normalized() == r.nr), "normalized row " ~ i.to!string);
    }
}

// ---------------------------------------------------------------------------
// Coordinate accessors
// ---------------------------------------------------------------------------

private struct RectIntRow
{
    QRect r;
    int value;
}
private RectIntRow[] left_data()
{
    static immutable int[] v = [0, 1, int.min / 2, 0, int.min, int.min, 100, 1, -10, 5, 2];
    RectIntRow[] rows;
    foreach (i; 0 .. 11)
        rows ~= RectIntRow(rectCase(cast(RectCase) i), v[i]);
    return rows;
}

// left
unittest
{
    foreach (i, r; left_data())
    {
        string ctx = "left row " ~ i.to!string;
        QRectF rf = QRectF(r.r);
        assert(r.r.left() == r.value, ctx);
        assert(rf.left() == cast(qreal) r.value, ctx);
    }
}

private RectIntRow[] top_data()
{
    static immutable int[] v = [0, 1, int.min / 2, 0, int.min, int.min, 200, 1, -10, 5, 2];
    RectIntRow[] rows;
    foreach (i; 0 .. 11)
        rows ~= RectIntRow(rectCase(cast(RectCase) i), v[i]);
    return rows;
}

// top
unittest
{
    foreach (i, r; top_data())
    {
        string ctx = "top row " ~ i.to!string;
        assert(r.r.top() == r.value, ctx);
        assert(QRectF(r.r).top() == cast(qreal) r.value, ctx);
    }
}

private RectIntRow[] right_data()
{
    // The NullQRect case is not tested (return value is undefined).
    static immutable int[] v = [-1, 1, int.max / 2, int.max - 1, int.min, int.max, 110, -10, -6, 1];
    RectIntRow[] rows;
    foreach (i; 0 .. 10)
    {
        if (i < 9)
            rows ~= RectIntRow(rectCase(cast(RectCase) i), v[i]);
        else
            rows ~= RectIntRow(rectCase(RectCase.Empty), v[9]); // NullQRect omitted
    }
    return rows;
}

// right
unittest
{
    foreach (i, r; right_data())
    {
        assert(r.r.right() == r.value, "right row " ~ i.to!string);
        if (isLarge(r.r.width())) continue;
        if (r.r.left() < r.r.right() && r.r.width() < 0) continue;
        assert(QRectF(r.r).right() == cast(qreal)(r.value + 1));
    }
}

private RectIntRow[] bottom_data()
{
    static immutable int[] v = [-1, 1, int.max / 2, int.max - 1, int.min, int.max, 215, -10, -6, 1];
    RectIntRow[] rows;
    foreach (i; 0 .. 10)
    {
        if (i < 9)
            rows ~= RectIntRow(rectCase(cast(RectCase) i), v[i]);
        else
            rows ~= RectIntRow(rectCase(RectCase.Empty), v[9]);
    }
    return rows;
}

// bottom
unittest
{
    foreach (i, r; bottom_data())
    {
        assert(r.r.bottom() == r.value, "bottom row " ~ i.to!string);
        if (isLarge(r.r.height())) continue;
        if (r.r.top() < r.r.bottom() && r.r.height() < 0) continue;
        assert(QRectF(r.r).bottom() == cast(qreal)(r.value + 1));
    }
}

private RectIntRow[] x_data()
{
    static immutable int[] v = [0, 1, int.min / 2, 0, int.min, int.min, 100, 1, -10, 5, 2];
    RectIntRow[] rows;
    foreach (i; 0 .. 11)
        rows ~= RectIntRow(rectCase(cast(RectCase) i), v[i]);
    return rows;
}

// x
unittest
{
    foreach (i, r; x_data())
    {
        string ctx = "x row " ~ i.to!string;
        assert(r.r.x() == r.value, ctx);
        assert(QRectF(r.r).x() == cast(qreal) r.value, ctx);
    }
}

private RectIntRow[] y_data()
{
    static immutable int[] v = [0, 1, int.min / 2, 0, int.min, int.min, 200, 1, -10, 5, 2];
    RectIntRow[] rows;
    foreach (i; 0 .. 11)
        rows ~= RectIntRow(rectCase(cast(RectCase) i), v[i]);
    return rows;
}

// y
unittest
{
    foreach (i, r; y_data())
    {
        string ctx = "y row " ~ i.to!string;
        assert(r.r.y() == r.value, ctx);
        assert(QRectF(r.r).y() == cast(qreal) r.value, ctx);
    }
}

private struct WidthHeightRow
{
    int w, h;
}
private WidthHeightRow[] setWidthHeight_data()
{
    return [
        WidthHeightRow(10, 20),
        WidthHeightRow(-1, -1),
        WidthHeightRow(0, 0),
        WidthHeightRow(-10, -100),
    ];
}

// setWidthHeight
unittest
{
    foreach (i, r; setWidthHeight_data())
    {
        string ctx = "setWidthHeight row " ~ i.to!string;
        QRect r1 = QRect(0, 0, 0, 0);
        r1.setWidth(r.w);
        r1.setHeight(r.h);
        assert(r1.width() == r.w, ctx);
        assert(r1.height() == r.h, ctx);

        QRectF rf = QRectF(0, 0, 0, 0);
        rf.setWidth(r.w);
        rf.setHeight(r.h);
        assert(rf.width() == cast(qreal) r.w, ctx);
        assert(rf.height() == cast(qreal) r.h, ctx);
    }
}

// ---------------------------------------------------------------------------
// setLeft / setTop / setRight / setBottom (generated)
// ---------------------------------------------------------------------------

private struct RectIntRectRow
{
    QRect r;
    int value;
    QRect nr;
}
private RectIntRectRow[] setLeft_data()
{
    RectIntRectRow[] rows;
    foreach (rc; 0 .. 11)
    {
        QRect r = rectCase(cast(RectCase) rc);
        foreach (v; intCases())
            rows ~= RectIntRectRow(r, v, QRect(QPoint(v, r.top()), QPoint(r.right(), r.bottom())));
    }
    return rows;
}

// setLeft
unittest
{
    foreach (i, r; setLeft_data())
    {
        QRect got = r.r;
        got.setLeft(r.value);
        assert((got == r.nr), "setLeft row " ~ i.to!string);
    }
}

private RectIntRectRow[] setTop_data()
{
    RectIntRectRow[] rows;
    foreach (rc; 0 .. 11)
    {
        QRect r = rectCase(cast(RectCase) rc);
        foreach (v; intCases())
            rows ~= RectIntRectRow(r, v, QRect(QPoint(r.left(), v), QPoint(r.right(), r.bottom())));
    }
    return rows;
}

// setTop
unittest
{
    foreach (i, r; setTop_data())
    {
        QRect got = r.r;
        got.setTop(r.value);
        assert((got == r.nr), "setTop row " ~ i.to!string);
    }
}

private RectIntRectRow[] setRight_data()
{
    RectIntRectRow[] rows;
    foreach (rc; 0 .. 11)
    {
        QRect r = rectCase(cast(RectCase) rc);
        foreach (v; intCases())
            rows ~= RectIntRectRow(r, v, QRect(QPoint(r.left(), r.top()), QPoint(v, r.bottom())));
    }
    return rows;
}

// setRight
unittest
{
    foreach (i, r; setRight_data())
    {
        QRect got = r.r;
        got.setRight(r.value);
        assert((got == r.nr), "setRight row " ~ i.to!string);
    }
}

private RectIntRectRow[] setBottom_data()
{
    RectIntRectRow[] rows;
    foreach (rc; 0 .. 11)
    {
        QRect r = rectCase(cast(RectCase) rc);
        foreach (v; intCases())
            rows ~= RectIntRectRow(r, v, QRect(QPoint(r.left(), r.top()), QPoint(r.right(), v)));
    }
    return rows;
}

// setBottom
unittest
{
    foreach (i, r; setBottom_data())
    {
        QRect got = r.r;
        got.setBottom(r.value);
        assert((got == r.nr), "setBottom row " ~ i.to!string);
    }
}

// ---------------------------------------------------------------------------
// newSetTopLeft / newSetBottomRight / newSetTopRight / newSetBottomLeft
// ---------------------------------------------------------------------------

private struct RectPointRectRow
{
    QRect r;
    QPoint p;
    QRect nr;
}
private RectPointRectRow[] newSetTopLeft_data()
{
    RectPointRectRow[] rows;
    foreach (rc; 0 .. 11)
    {
        QRect r = rectCase(cast(RectCase) rc);
        foreach (p; pointCases())
            rows ~= RectPointRectRow(r, p, QRect(p, QPoint(r.right(), r.bottom())));
    }
    return rows;
}

// newSetTopLeft
unittest
{
    foreach (i, r; newSetTopLeft_data())
    {
        QRect got = r.r;
        got.setTopLeft(r.p);
        assert((got == r.nr), "newSetTopLeft row " ~ i.to!string);
    }
}

private RectPointRectRow[] newSetBottomRight_data()
{
    RectPointRectRow[] rows;
    foreach (rc; 0 .. 11)
    {
        QRect r = rectCase(cast(RectCase) rc);
        foreach (p; pointCases())
            rows ~= RectPointRectRow(r, p, QRect(QPoint(r.left(), r.top()), p));
    }
    return rows;
}

// newSetBottomRight
unittest
{
    foreach (i, r; newSetBottomRight_data())
    {
        QRect got = r.r;
        got.setBottomRight(r.p);
        assert((got == r.nr), "newSetBottomRight row " ~ i.to!string);
    }
}

private RectPointRectRow[] newSetTopRight_data()
{
    RectPointRectRow[] rows;
    foreach (rc; 0 .. 11)
    {
        QRect r = rectCase(cast(RectCase) rc);
        foreach (p; pointCases())
            rows ~= RectPointRectRow(r, p, QRect(QPoint(r.left(), p.y()), QPoint(p.x(), r.bottom())));
    }
    return rows;
}

// newSetTopRight
unittest
{
    foreach (i, r; newSetTopRight_data())
    {
        QRect got = r.r;
        got.setTopRight(r.p);
        assert((got == r.nr), "newSetTopRight row " ~ i.to!string);
    }
}

private RectPointRectRow[] newSetBottomLeft_data()
{
    RectPointRectRow[] rows;
    foreach (rc; 0 .. 11)
    {
        QRect r = rectCase(cast(RectCase) rc);
        foreach (p; pointCases())
            rows ~= RectPointRectRow(r, p, QRect(QPoint(p.x(), r.top()), QPoint(r.right(), p.y())));
    }
    return rows;
}

// newSetBottomLeft
unittest
{
    foreach (i, r; newSetBottomLeft_data())
    {
        QRect got = r.r;
        got.setBottomLeft(r.p);
        assert((got == r.nr), "newSetBottomLeft row " ~ i.to!string);
    }
}

// ---------------------------------------------------------------------------
// topLeft / bottomRight / topRight / bottomLeft / center
// ---------------------------------------------------------------------------

private struct RectPointRow
{
    QRect r;
    QPoint p;
}
private QPoint[] topLeftExpected()
{
    return [
        QPoint(0, 0), QPoint(1, 1), QPoint(int.min / 2, int.min / 2), QPoint(0, 0),
        QPoint(int.min, int.min), QPoint(int.min, int.min), QPoint(100, 200),
        QPoint(1, 1), QPoint(-10, -10), QPoint(5, 5), QPoint(2, 2),
    ];
}
private RectPointRow[] topLeft_data()
{
    RectPointRow[] rows;
    auto exp = topLeftExpected();
    foreach (i; 0 .. 11)
        rows ~= RectPointRow(rectCase(cast(RectCase) i), exp[i]);
    return rows;
}

// topLeft
unittest
{
    foreach (i, r; topLeft_data())
        assert(r.r.topLeft().x() == r.p.x() && r.r.topLeft().y() == r.p.y(), "topLeft row " ~ i.to!string);
}

private RectPointRow[] bottomRight_data()
{
    static immutable QPoint[] exp = [
        QPoint(-1, -1), QPoint(1, 1), QPoint(int.max / 2, int.max / 2), QPoint(int.max - 1, int.max - 1),
        QPoint(int.min, int.min), QPoint(int.max, int.max), QPoint(110, 215),
        QPoint(-10, -10), QPoint(-6, -6), QPoint(4, 4), QPoint(1, 1),
    ];
    RectPointRow[] rows;
    foreach (i; 0 .. 11)
        rows ~= RectPointRow(rectCase(cast(RectCase) i), exp[i]);
    return rows;
}

// bottomRight
unittest
{
    foreach (i, r; bottomRight_data())
    {
        QPoint got = r.r.bottomRight();
        assert(got.x() == r.p.x() && got.y() == r.p.y(), "bottomRight row " ~ i.to!string);
    }
}

private RectPointRow[] topRight_data()
{
    static immutable QPoint[] exp = [
        QPoint(-1, 0), QPoint(1, 1), QPoint(int.max / 2, int.min / 2), QPoint(int.max - 1, 0),
        QPoint(int.min, int.min), QPoint(int.max, int.min), QPoint(110, 200),
        QPoint(-10, 1), QPoint(-6, -10), QPoint(4, 5), QPoint(1, 2),
    ];
    RectPointRow[] rows;
    foreach (i; 0 .. 11)
        rows ~= RectPointRow(rectCase(cast(RectCase) i), exp[i]);
    return rows;
}

// topRight
unittest
{
    foreach (i, r; topRight_data())
    {
        QPoint got = r.r.topRight();
        assert(got.x() == r.p.x() && got.y() == r.p.y(), "topRight row " ~ i.to!string);
    }
}

private RectPointRow[] bottomLeft_data()
{
    static immutable QPoint[] exp = [
        QPoint(0, -1), QPoint(1, 1), QPoint(int.min / 2, int.max / 2), QPoint(0, int.max - 1),
        QPoint(int.min, int.min), QPoint(int.min, int.max), QPoint(100, 215),
        QPoint(1, -10), QPoint(-10, -6), QPoint(5, 4), QPoint(2, 1),
    ];
    RectPointRow[] rows;
    foreach (i; 0 .. 11)
        rows ~= RectPointRow(rectCase(cast(RectCase) i), exp[i]);
    return rows;
}

// bottomLeft
unittest
{
    foreach (i, r; bottomLeft_data())
    {
        QPoint got = r.r.bottomLeft();
        assert(got.x() == r.p.x() && got.y() == r.p.y(), "bottomLeft row " ~ i.to!string);
    }
}

private RectPointRow[] center_data()
{
    static immutable QPoint[] exp = [
        QPoint(0, 0), QPoint(1, 1), QPoint(0, 0), QPoint(int.max / 2, int.max / 2),
        QPoint(int.min, int.min), QPoint(0, 0), QPoint(105, 207),
        QPoint(-4, -4), QPoint(-8, -8), QPoint(4, 4), QPoint(1, 1),
    ];
    RectPointRow[] rows;
    foreach (i; 0 .. 11)
        rows ~= RectPointRow(rectCase(cast(RectCase) i), exp[i]);
    return rows;
}

// center
unittest
{
    foreach (i, r; center_data())
    {
        QPoint got = r.r.center();
        assert(got.x() == r.p.x() && got.y() == r.p.y(), "center row " ~ i.to!string);
    }
}

// ---------------------------------------------------------------------------
// getRect / getCoords
// ---------------------------------------------------------------------------

private struct GetRectRow
{
    QRect r;
    int x, y, w, h;
}
private GetRectRow[] getRect_data()
{
    return [
        GetRectRow(rectCase(RectCase.Invalid), 0, 0, 0, 0),
        GetRectRow(rectCase(RectCase.Smallest), 1, 1, 1, 1),
        GetRectRow(rectCase(RectCase.Largest), 0, 0, int.max, int.max),
        GetRectRow(rectCase(RectCase.SmallestCoord), int.min, int.min, 1, 1),
        GetRectRow(rectCase(RectCase.Random), 100, 200, 11, 16),
        GetRectRow(rectCase(RectCase.NegativeSize), 1, 1, -10, -10),
        GetRectRow(rectCase(RectCase.NegativePoint), -10, -10, 5, 5),
        GetRectRow(rectCase(RectCase.Null), 5, 5, 0, 0),
        GetRectRow(rectCase(RectCase.Empty), 2, 2, 0, 0),
    ];
}

// getRect
unittest
{
    foreach (i, r; getRect_data())
    {
        int x2, y2, w2, h2;
        r.r.getRect(&x2, &y2, &w2, &h2);
        string ctx = "getRect row " ~ i.to!string;
        assert(r.x == x2 && r.y == y2 && r.w == w2 && r.h == h2, ctx);
    }
}

private struct GetCoordsRow
{
    QRect r;
    int x1, y1, x2, y2;
}
private GetCoordsRow[] getCoords_data()
{
    return [
        GetCoordsRow(rectCase(RectCase.Invalid), 0, 0, -1, -1),
        GetCoordsRow(rectCase(RectCase.Smallest), 1, 1, 1, 1),
        GetCoordsRow(rectCase(RectCase.Middle), int.min / 2, int.min / 2, int.max / 2, int.max / 2),
        GetCoordsRow(rectCase(RectCase.Largest), 0, 0, int.max - 1, int.max - 1),
        GetCoordsRow(rectCase(RectCase.SmallestCoord), int.min, int.min, int.min, int.min),
        GetCoordsRow(rectCase(RectCase.LargestCoord), int.min, int.min, int.max, int.max),
        GetCoordsRow(rectCase(RectCase.Random), 100, 200, 110, 215),
        GetCoordsRow(rectCase(RectCase.NegativeSize), 1, 1, -10, -10),
        GetCoordsRow(rectCase(RectCase.NegativePoint), -10, -10, -6, -6),
        GetCoordsRow(rectCase(RectCase.Null), 5, 5, 4, 4),
        GetCoordsRow(rectCase(RectCase.Empty), 2, 2, 1, 1),
    ];
}

// getCoords
unittest
{
    foreach (i, r; getCoords_data())
    {
        int x12, y12, x22, y22;
        r.r.getCoords(&x12, &y12, &x22, &y22);
        string ctx = "getCoords row " ~ i.to!string;
        assert(r.x1 == x12 && r.y1 == y12 && r.x2 == x22 && r.y2 == y22, ctx);
    }
}

// ---------------------------------------------------------------------------
// newMoveLeft/Top/Right/Bottom (generated, source-skipped rows omitted)
// ---------------------------------------------------------------------------

private static immutable ubyte[2][] newMoveLeft_pairs = [[0,1], [0,2], [0,3], [0,4], [0,5], [1,0], [1,1], [1,2], [1,3], [1,4], [1,5], [2,0], [2,1], [2,2], [3,0], [3,1], [3,2], [4,1], [4,2], [4,3], [4,4], [4,5], [5,1], [5,2], [5,3], [5,4], [5,5], [6,0], [6,1], [6,2], [6,3], [6,5], [7,1], [7,2], [7,3], [7,4], [7,5], [8,0], [8,1], [8,2], [8,3], [8,5], [9,1], [9,2], [9,3], [9,4], [9,5], [10,1], [10,2], [10,3], [10,4], [10,5]];
private static immutable ubyte[2][] newMoveTop_pairs = [[0,1], [0,2], [0,3], [0,4], [0,5], [1,0], [1,1], [1,2], [1,3], [1,4], [1,5], [2,0], [2,1], [2,2], [3,0], [3,1], [3,2], [4,1], [4,2], [4,3], [4,4], [4,5], [5,1], [5,2], [5,3], [5,4], [5,5], [6,0], [6,1], [6,2], [6,3], [6,5], [7,1], [7,2], [7,3], [7,4], [7,5], [8,0], [8,1], [8,2], [8,3], [8,5], [9,1], [9,2], [9,3], [9,4], [9,5], [10,1], [10,2], [10,3], [10,4], [10,5]];
private static immutable ubyte[2][] newMoveRight_pairs = [[0,1], [0,2], [0,3], [0,5], [1,0], [1,1], [1,2], [1,3], [1,4], [1,5], [2,2], [2,3], [2,4], [2,5], [3,2], [3,3], [3,4], [3,5], [4,0], [4,1], [6,1], [6,2], [6,3], [6,4], [6,5], [7,0], [7,1], [7,2], [7,5], [8,1], [8,2], [8,3], [8,5], [9,1], [9,2], [9,3], [9,5], [10,0], [10,1], [10,2], [10,3], [10,5]];
private static immutable ubyte[2][] newMoveBottom_pairs = [[0,1], [0,2], [0,3], [0,5], [1,0], [1,1], [1,2], [1,3], [1,4], [1,5], [2,2], [2,3], [2,4], [2,5], [3,2], [3,3], [3,4], [3,5], [4,0], [4,1], [6,1], [6,2], [6,3], [6,4], [6,5], [7,0], [7,1], [7,2], [7,5], [8,1], [8,2], [8,3], [8,5], [9,1], [9,2], [9,3], [9,5], [10,0], [10,1], [10,2], [10,3], [10,5]];

private RectIntRectRow[] newMoveLeft_data()
{
    RectIntRectRow[] rows;
    auto ints = intCases();
    foreach (pair; newMoveLeft_pairs)
    {
        QRect r = rectCase(cast(RectCase) pair[0]);
        int v = ints[pair[1]];
        rows ~= RectIntRectRow(r, v, QRect(QPoint(v, r.top()), QPoint(v + r.width() - 1, r.bottom())));
    }
    return rows;
}

// newMoveLeft
unittest
{
    foreach (i, r; newMoveLeft_data())
    {
        QRect got = r.r;
        got.moveLeft(r.value);
        assert((got == r.nr), "newMoveLeft row " ~ i.to!string);
    }
}

private RectIntRectRow[] newMoveTop_data()
{
    RectIntRectRow[] rows;
    auto ints = intCases();
    foreach (pair; newMoveTop_pairs)
    {
        QRect r = rectCase(cast(RectCase) pair[0]);
        int v = ints[pair[1]];
        rows ~= RectIntRectRow(r, v, QRect(QPoint(r.left(), v), QPoint(r.right(), v + r.height() - 1)));
    }
    return rows;
}

// newMoveTop
unittest
{
    foreach (i, r; newMoveTop_data())
    {
        QRect got = r.r;
        got.moveTop(r.value);
        assert((got == r.nr), "newMoveTop row " ~ i.to!string);
    }
}

private RectIntRectRow[] newMoveRight_data()
{
    RectIntRectRow[] rows;
    auto ints = intCases();
    foreach (pair; newMoveRight_pairs)
    {
        QRect r = rectCase(cast(RectCase) pair[0]);
        int v = ints[pair[1]];
        rows ~= RectIntRectRow(r, v, QRect(QPoint(v - r.width() + 1, r.top()), QPoint(v, r.bottom())));
    }
    return rows;
}

// newMoveRight
unittest
{
    foreach (i, r; newMoveRight_data())
    {
        QRect got = r.r;
        got.moveRight(r.value);
        assert((got == r.nr), "newMoveRight row " ~ i.to!string);
    }
}

private RectIntRectRow[] newMoveBottom_data()
{
    RectIntRectRow[] rows;
    auto ints = intCases();
    foreach (pair; newMoveBottom_pairs)
    {
        QRect r = rectCase(cast(RectCase) pair[0]);
        int v = ints[pair[1]];
        rows ~= RectIntRectRow(r, v, QRect(QPoint(r.left(), v - r.height() + 1), QPoint(r.right(), v)));
    }
    return rows;
}

// newMoveBottom
unittest
{
    foreach (i, r; newMoveBottom_data())
    {
        QRect got = r.r;
        got.moveBottom(r.value);
        assert((got == r.nr), "newMoveBottom row " ~ i.to!string);
    }
}

private static immutable ubyte[2][] newMoveTopLeft_pairs = [[0,6], [0,8], [0,9], [0,10], [0,11], [0,12], [0,13], [1,6], [1,7], [1,8], [1,9], [1,10], [1,11], [1,12], [1,13], [2,6], [2,7], [2,8], [3,6], [3,7], [4,7], [4,8], [5,7], [6,6], [6,8], [6,9], [6,11], [6,12], [6,13], [7,6], [7,8], [7,9], [7,11], [7,12], [7,13], [8,6], [8,7], [8,8], [8,9], [8,11], [8,12], [8,13], [9,6], [9,8], [9,9], [9,10], [9,11], [9,12], [9,13], [10,6], [10,8], [10,9], [10,10], [10,11], [10,12], [10,13]];
private static immutable ubyte[2][] newMoveBottomRight_pairs = [[0,6], [0,7], [0,8], [0,9], [0,11], [0,12], [0,13], [1,6], [1,8], [1,9], [1,10], [1,11], [1,12], [1,13], [2,6], [2,9], [2,10], [2,13], [3,6], [3,9], [3,10], [3,13], [4,7], [4,8], [5,10], [6,6], [6,8], [6,9], [6,10], [6,11], [6,12], [6,13], [7,6], [7,7], [7,8], [7,9], [7,11], [7,12], [7,13], [8,6], [8,8], [8,9], [8,11], [8,12], [8,13], [9,6], [9,8], [9,9], [9,11], [9,12], [9,13], [10,6], [10,8], [10,9], [10,11], [10,12], [10,13]];

private RectPointRectRow[] newMoveTopLeft_data()
{
    RectPointRectRow[] rows;
    auto pts = pointCases();
    foreach (pair; newMoveTopLeft_pairs)
    {
        QRect r = rectCase(cast(RectCase) pair[0]);
        QPoint p = pts[pair[1] - 6];
        rows ~= RectPointRectRow(r, p, QRect(p, QSize(r.width(), r.height())));
    }
    return rows;
}

// newMoveTopLeft
unittest
{
    foreach (i, r; newMoveTopLeft_data())
    {
        QRect got = r.r;
        got.moveTopLeft(r.p);
        assert((got == r.nr), "newMoveTopLeft row " ~ i.to!string);
    }
}

private RectPointRectRow[] newMoveBottomRight_data()
{
    RectPointRectRow[] rows;
    auto pts = pointCases();
    foreach (pair; newMoveBottomRight_pairs)
    {
        QRect r = rectCase(cast(RectCase) pair[0]);
        QPoint p = pts[pair[1] - 6];
        rows ~= RectPointRectRow(r, p,
            QRect(QPoint(p.x() - r.width() + 1, p.y() - r.height() + 1), p));
    }
    return rows;
}

// newMoveBottomRight
unittest
{
    foreach (i, r; newMoveBottomRight_data())
    {
        QRect got = r.r;
        got.moveBottomRight(r.p);
        assert((got == r.nr), "newMoveBottomRight row " ~ i.to!string);
    }
}

// ---------------------------------------------------------------------------
// margins / marginsf
// ---------------------------------------------------------------------------

// margins
unittest
{
    QRect rectangle = QRect(QPoint(10, 10), QSize(50, 50));
    QMargins margins = QMargins(2, 3, 4, 5);

    assert((rectangle.marginsAdded(margins) == QRect(QPoint(8, 7), QSize(56, 58))));

    const QRect added = rectangle + margins;
    assert(added == QRect(QPoint(8, 7), QSize(56, 58)));
    assert(margins + rectangle == QRect(QPoint(8, 7), QSize(56, 58)));

    assert((rectangle.marginsRemoved(margins) == QRect(QPoint(12, 13), QSize(44, 42))));

    QRect a = rectangle;
    a += margins;
    assert((a == QRect(QPoint(8, 7), QSize(56, 58))));
    a = rectangle;
    a -= margins;
    assert((a == rectangle.marginsRemoved(margins)));
}

// marginsf
unittest
{
    QRectF rectangle = QRectF(QPointF(10.5, 10.5), QSizeF(50.5, 150.5));
    QMarginsF margins = QMarginsF(2.5, 3.5, 4.5, 5.5);

    assert((rectangle.marginsAdded(margins) == QRectF(QPointF(8.0, 7.0), QSizeF(57.5, 159.5))));

    const QRectF added = rectangle + margins;
    assert(added == QRectF(QPointF(8.0, 7.0), QSizeF(57.5, 159.5)));
    assert(margins + rectangle == QRectF(QPointF(8.0, 7.0), QSizeF(57.5, 159.5)));

    assert((rectangle.marginsRemoved(margins) == QRectF(QPointF(13.0, 14.0), QSizeF(43.5, 141.5))));

    QRectF a = rectangle;
    a += margins;
    assert((a == QRectF(QPointF(8.0, 7.0), QSizeF(57.5, 159.5))));
    a = rectangle;
    a -= margins;
    assert((a == rectangle.marginsRemoved(margins)));
}

// ---------------------------------------------------------------------------
// toRectF
// ---------------------------------------------------------------------------

private struct RectFPairRow
{
    QRect input;
    QRectF result;
}
private RectFPairRow[] toRectF_data()
{
    RectFPairRow[] rows;
    static immutable int[] s = [-1, 0, 1];
    foreach (x1; s) foreach (y1; s) foreach (w; s) foreach (h; s)
        rows ~= RectFPairRow(QRect(QPoint(x1, y1), QSize(w, h)),
            QRectF(QPointF(x1, y1), QSizeF(w, h)));
    return rows;
}

// toRectF
unittest
{
    foreach (i, r; toRectF_data())
    {
        assert((r.result.toRect() == r.input), "toRectF consistency row " ~ i.to!string);
        assert((r.input.toRectF() == r.result), "toRectF row " ~ i.to!string);
    }
}

// ---------------------------------------------------------------------------
// translate
// ---------------------------------------------------------------------------

private struct TranslateRow
{
    QRect r;
    QPoint delta;
    QRect result;
}
private TranslateRow[] translate_data()
{
    return [
        TranslateRow(QRect(10, 20, 5, 15), QPoint(3, 7), QRect(13, 27, 5, 15)),
        TranslateRow(QRect(0, 0, -1, -1), QPoint(3, 7), QRect(3, 7, -1, -1)),
        TranslateRow(QRect(0, 0, -1, -1), QPoint(0, 0), QRect(0, 0, -1, -1)),
        TranslateRow(QRect(10, 20, 5, 15), QPoint(3, 0), QRect(13, 20, 5, 15)),
        TranslateRow(QRect(10, 20, 5, 15), QPoint(0, 7), QRect(10, 27, 5, 15)),
        TranslateRow(QRect(10, 20, 5, 15), QPoint(-3, 7), QRect(7, 27, 5, 15)),
        TranslateRow(QRect(10, 20, 5, 15), QPoint(3, -7), QRect(13, 13, 5, 15)),
    ];
}

// translate
unittest
{
    foreach (i, row; translate_data())
    {
        string ctx = "translate row " ~ i.to!string;
        QRect oldr = row.r;
        QRect r2 = row.r;
        r2.translate(row.delta);
        assert((row.result == r2), ctx);
        r2 = row.r;
        r2.translate(row.delta.x(), row.delta.y());
        assert((row.result == r2), ctx);
        r2 = row.r.translated(row.delta);
        assert((row.result == r2), ctx);
        assert((oldr == row.r), ctx);
        r2 = row.r.translated(row.delta.x(), row.delta.y());
        assert((row.result == r2), ctx);
        assert((oldr == row.r), ctx);
    }
}

// transposed
unittest
{
    foreach (i; 0 .. 11)
    {
        string ctx = "transposed row " ~ i.to!string;
        QRect r = rectCase(cast(RectCase) i);
        QRect rt = r.transposed();
        assert(rt.height() == r.width(), ctx);
        assert(rt.width() == r.height(), ctx);
        assert(rt.topLeft().x() == r.topLeft().x() && rt.topLeft().y() == r.topLeft().y(), ctx);

        QRectF rf = QRectF(r);
        QRectF rtf = rf.transposed();
        assert(rtf.height() == rf.width(), ctx);
        assert(rtf.width() == rf.height(), ctx);
        assert((rtf == QRectF(rt)), ctx);
    }
}

// ---------------------------------------------------------------------------
// move* / set* (fixed single cases)
// ---------------------------------------------------------------------------

// moveTop
unittest
{
    QRect r = QRect(10, 10, 100, 100);
    r.moveTop(3);
    assert((r == QRect(10, 3, 100, 100)));
    r = QRect(10, 3, 100, 100);
    r.moveTop(-22);
    assert((r == QRect(10, -22, 100, 100)));

    QRectF rf = QRectF(10, 10, 100, 100);
    rf.moveTop(3);
    assert((rf == QRectF(10, 3, 100, 100)));
    rf = QRectF(10, 3, 100, 100);
    rf.moveTop(-22);
    assert((rf == QRectF(10, -22, 100, 100)));
}

// moveBottom
unittest
{
    QRect r = QRect(10, -22, 100, 100);
    r.moveBottom(104);
    assert((r == QRect(10, 5, 100, 100)));
    QRectF rf = QRectF(10, -22, 100, 100);
    rf.moveBottom(104);
    assert((rf == QRectF(10, 4, 100, 100)));
}

// moveLeft
unittest
{
    QRect r = QRect(10, 5, 100, 100);
    r.moveLeft(11);
    assert((r == QRect(11, 5, 100, 100)));
    QRectF rf = QRectF(10, 5, 100, 100);
    rf.moveLeft(11);
    assert((rf == QRectF(11, 5, 100, 100)));
}

// moveRight
unittest
{
    QRect r = QRect(11, 5, 100, 100);
    r.moveRight(106);
    assert((r == QRect(7, 5, 100, 100)));
    QRectF rf = QRectF(11, 5, 100, 100);
    rf.moveRight(106);
    assert((rf == QRectF(6, 5, 100, 100)));
}

// moveTopLeft
unittest
{
    QRect r = QRect(7, 5, 100, 100);
    r.moveTopLeft(QPoint(1, 2));
    assert((r == QRect(1, 2, 100, 100)));
    QRectF rf = QRectF(7, 5, 100, 100);
    rf.moveTopLeft(QPointF(1, 2));
    assert((rf == QRectF(1, 2, 100, 100)));
}

// moveTopRight
unittest
{
    QRect r = QRect(1, 2, 100, 100);
    r.moveTopRight(QPoint(103, 5));
    assert((r == QRect(4, 5, 100, 100)));
    QRectF rf = QRectF(1, 2, 100, 100);
    rf.moveTopRight(QPointF(103, 5));
    assert((rf == QRectF(3, 5, 100, 100)));
}

// moveBottomLeft
unittest
{
    QRect r = QRect(4, 5, 100, 100);
    r.moveBottomLeft(QPoint(3, 105));
    assert((r == QRect(3, 6, 100, 100)));
    QRectF rf = QRectF(4, 5, 100, 100);
    rf.moveBottomLeft(QPointF(3, 105));
    assert((rf == QRectF(3, 5, 100, 100)));
}

// moveBottomRight
unittest
{
    QRect r = QRect(3, 6, 100, 100);
    r.moveBottomRight(QPoint(103, 105));
    assert((r == QRect(4, 6, 100, 100)));
    QRectF rf = QRectF(3, 6, 100, 100);
    rf.moveBottomRight(QPointF(103, 105));
    assert((rf == QRectF(3, 5, 100, 100)));
}

// setTopLeft
unittest
{
    QRect r = QRect(20, 10, 200, 100);
    r.setTopLeft(QPoint(5, 7));
    assert((r == QRect(5, 7, 215, 103)));
    QRectF rf = QRectF(20, 10, 200, 100);
    rf.setTopLeft(QPointF(5, 7));
    assert((rf == QRectF(5, 7, 215, 103)));
}

// setTopRight
unittest
{
    QRect r = QRect(20, 10, 200, 100);
    r.setTopRight(QPoint(225, 7));
    assert((r == QRect(20, 7, 206, 103)));
    QRectF rf = QRectF(20, 10, 200, 100);
    rf.setTopRight(QPointF(225, 7));
    assert((rf == QRectF(20, 7, 205, 103)));
}

// setBottomLeft
unittest
{
    QRect r = QRect(20, 10, 200, 100);
    r.setBottomLeft(QPoint(5, 117));
    assert((r == QRect(5, 10, 215, 108)));
    QRectF rf = QRectF(20, 10, 200, 100);
    rf.setBottomLeft(QPointF(5, 117));
    assert((rf == QRectF(5, 10, 215, 107)));
}

// setBottomRight
unittest
{
    QRect r = QRect(20, 10, 200, 100);
    r.setBottomRight(QPoint(225, 117));
    assert((r == QRect(20, 10, 206, 108)));
    QRectF rf = QRectF(20, 10, 200, 100);
    rf.setBottomRight(QPointF(225, 117));
    assert((rf == QRectF(20, 10, 205, 107)));
}

// ---------------------------------------------------------------------------
// operator_amp / operator_amp_eq
// ---------------------------------------------------------------------------

// operator_amp
unittest
{
    QRect r = QRect(QPoint(20, 10), QPoint(200, 100));
    QRect r2 = QRect(QPoint(50, 50), QPoint(300, 300));
    QRect r3 = r & r2;
    assert((r3 == QRect(QPoint(50, 50), QPoint(200, 100))));
    assert(!r3.isEmpty());
    assert(r3.isValid());

    QRect r4 = QRect(QPoint(300, 300), QPoint(400, 400));
    QRect r5 = r & r4;
    assert(r5.isEmpty());
    assert(!r5.isValid());
}

// operator_amp_eq
unittest
{
    QRect r = QRect(QPoint(20, 10), QPoint(200, 100));
    QRect r2 = QRect(QPoint(50, 50), QPoint(300, 300));
    r &= r2;
    assert((r == QRect(QPoint(50, 50), QPoint(200, 100))));
    assert(!r.isEmpty());
    assert(r.isValid());

    QRect r3 = QRect(QPoint(300, 300), QPoint(400, 400));
    r &= r3;
    assert(r.isEmpty());
    assert(!r.isValid());
}

// ---------------------------------------------------------------------------
// isValid / isEmpty
// ---------------------------------------------------------------------------

// isValid
unittest
{
    QRect r = QRect(0, 0, 0, 0);
    assert(!r.isValid());
    assert(!QRect(0, 0, 0, 0).isValid());
    assert(QRect(100, 200, 300, 400).isValid());
}

// isEmpty
unittest
{
    assert(QRect(0, 0, 0, 0).isEmpty());
    assert(QRect(0, 0, 0, 0).isEmpty());
    assert(!QRect(100, 200, 300, 400).isEmpty());
    assert(QRect(QPoint(300, 100), QPoint(200, 200)).isEmpty());
    assert(QRect(QPoint(200, 200), QPoint(200, 100)).isEmpty());
    assert(QRect(QPoint(300, 200), QPoint(200, 100)).isEmpty());
}

// ---------------------------------------------------------------------------
// testAdjust
// ---------------------------------------------------------------------------

private struct AdjustRow
{
    QRect original;
    int x1, y1, x2, y2;
    QRect expected;
}
private AdjustRow[] testAdjust_data()
{
    AdjustRow[] rows;
    static immutable int[][4] positive = [[4, 0], [3, 0], [2, 0], [1, 0]];
    static immutable int[][4] negative = [[-4, 0], [-3, 0], [-2, 0], [-1, 0]];
    foreach (set; [positive, negative])
        foreach (a; set[0]) foreach (b; set[1]) foreach (c; set[2]) foreach (d; set[3])
            rows ~= AdjustRow(QRect(13, 12, 11, 10), a, b, c, d,
                QRect(13 + a, 12 + b, 11 - a + c, 10 - b + d));
    return rows;
}

// testAdjust
unittest
{
    foreach (i, row; testAdjust_data())
    {
        string ctx = "testAdjust row " ~ i.to!string;
        QRect r1 = row.original;
        r1.adjust(row.x1, row.y1, row.x2, row.y2);
        assert(r1.x() == row.expected.x() && r1.y() == row.expected.y()
            && r1.width() == row.expected.width() && r1.height() == row.expected.height(), ctx);
        QRect r2 = row.original.adjusted(row.x1, row.y1, row.x2, row.y2);
        assert(r2.x() == row.expected.x() && r2.y() == row.expected.y()
            && r2.width() == row.expected.width() && r2.height() == row.expected.height(), ctx);

        QRectF expectedF = QRectF(row.expected);
        QRectF f1 = QRectF(row.original);
        f1.adjust(row.x1, row.y1, row.x2, row.y2);
        assert(f1.x() == expectedF.x() && f1.y() == expectedF.y()
            && f1.width() == expectedF.width() && f1.height() == expectedF.height(), ctx);
        QRectF f2 = QRectF(row.original).adjusted(row.x1, row.y1, row.x2, row.y2);
        assert(f2.x() == expectedF.x() && f2.y() == expectedF.y()
            && f2.width() == expectedF.width() && f2.height() == expectedF.height(), ctx);
    }
}

// ---------------------------------------------------------------------------
// intersected / united / intersects / contains (rect + rectF)
// ---------------------------------------------------------------------------

private struct Rect2RectRow
{
    QRect a, b, r;
}
private Rect2RectRow[] intersectedRect_data()
{
    return [
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(2, 2, 6, 6), QRect(2, 2, 6, 6)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(0, 0, 10, 10), QRect(0, 0, 10, 10)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(2, 2, 10, 10), QRect(2, 2, 8, 8)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(20, 20, 10, 10), QRect(0, 0, 0, 0)),
        Rect2RectRow(QRect(10, 10, -10, -10), QRect(2, 2, 6, 6), QRect(2, 2, 6, 6)),
        Rect2RectRow(QRect(10, 10, -10, -10), QRect(0, 0, 10, 10), QRect(0, 0, 10, 10)),
        Rect2RectRow(QRect(10, 10, -10, -10), QRect(2, 2, 10, 10), QRect(2, 2, 8, 8)),
        Rect2RectRow(QRect(10, 10, -10, -10), QRect(20, 20, 10, 10), QRect(0, 0, 0, 0)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(6, 6, -4, -4), QRect(2, 2, 4, 4)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(10, 10, -10, -10), QRect(0, 0, 10, 10)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(12, 12, -10, -10), QRect(2, 2, 8, 8)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(30, 30, -10, -10), QRect(0, 0, 0, 0)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(0, 0, 0, 0), QRect(0, 0, 0, 0)),
        Rect2RectRow(QRect(0, 0, 0, 0), QRect(0, 0, 10, 10), QRect(0, 0, 0, 0)),
        Rect2RectRow(QRect(0, 0, 0, 0), QRect(0, 0, 0, 0), QRect(0, 0, 0, 0)),
        Rect2RectRow(QRect(2, 0, 1, 652), QRect(2, 0, 1, 652), QRect(2, 0, 1, 652)),
    ];
}

// intersectedRect
unittest
{
    foreach (i, row; intersectedRect_data())
    {
        string ctx = "intersectedRect row " ~ i.to!string;
        if (row.r.isValid())
            assert((row.a.intersected(row.b) == row.r), ctx);
        else
            assert(row.a.intersected(row.b).isEmpty(), ctx);
        // `rect1 & wayOutside` (QRect operator&) intersects with an empty
        // rectangle, as in the source.
        QRect wayOutside = QRect(row.a.right() + 100, row.a.bottom() + 100, 10, 10);
        QRect empty = row.a & wayOutside;
        assert(empty.intersected(row.b).isEmpty(), ctx);
    }
}

private struct RectF2RectFRow
{
    QRectF a, b, r;
}
private RectF2RectFRow[] intersectedRectF_data()
{
    return [
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(2, 2, 6, 6), QRectF(2, 2, 6, 6)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(0, 0, 10, 10), QRectF(0, 0, 10, 10)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(2, 2, 10, 10), QRectF(2, 2, 8, 8)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(20, 20, 10, 10), QRectF(0, 0, 0, 0)),
        RectF2RectFRow(QRectF(10, 10, -10, -10), QRectF(2, 2, 6, 6), QRectF(2, 2, 6, 6)),
        RectF2RectFRow(QRectF(10, 10, -10, -10), QRectF(0, 0, 10, 10), QRectF(0, 0, 10, 10)),
        RectF2RectFRow(QRectF(10, 10, -10, -10), QRectF(2, 2, 10, 10), QRectF(2, 2, 8, 8)),
        RectF2RectFRow(QRectF(10, 10, -10, -10), QRectF(20, 20, 10, 10), QRectF(0, 0, 0, 0)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(8, 8, -6, -6), QRectF(2, 2, 6, 6)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(10, 10, -10, -10), QRectF(0, 0, 10, 10)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(12, 12, -10, -10), QRectF(2, 2, 8, 8)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(30, 30, -10, -10), QRectF(0, 0, 0, 0)),
        RectF2RectFRow(QRectF(-1, 1, 10, 10), QRectF(0, 0, 0, 0), QRectF(0, 0, 0, 0)),
        RectF2RectFRow(QRectF(0, 0, 0, 0), QRectF(0, 0, 10, 10), QRectF(0, 0, 0, 0)),
        RectF2RectFRow(QRectF(0, 0, 0, 0), QRectF(0, 0, 0, 0), QRectF(0, 0, 0, 0)),
    ];
}

// intersectedRectF
unittest
{
    foreach (i, row; intersectedRectF_data())
    {
        string ctx = "intersectedRectF row " ~ i.to!string;
        if (row.r.isValid())
            assert((row.a.intersected(row.b) == row.r), ctx);
        else
            assert(row.a.intersected(row.b).isEmpty(), ctx);
        QRectF wayOutside = QRectF(row.a.right() + 100.0, row.a.bottom() + 100.0, 10.0, 10.0);
        QRectF empty = row.a & wayOutside;
        assert(empty.intersected(row.b).isEmpty(), ctx);
    }
}

private Rect2RectRow[] unitedRect_data()
{
    return [
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(2, 2, 6, 6), QRect(0, 0, 10, 10)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(0, 0, 10, 10), QRect(0, 0, 10, 10)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(2, 2, 10, 10), QRect(0, 0, 12, 12)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(20, 20, 10, 10), QRect(0, 0, 30, 30)),
        Rect2RectRow(QRect(10, 10, -10, -10), QRect(2, 2, 6, 6), QRect(0, 0, 10, 10)),
        Rect2RectRow(QRect(10, 10, -10, -10), QRect(0, 0, 10, 10), QRect(0, 0, 10, 10)),
        Rect2RectRow(QRect(10, 10, -10, -10), QRect(2, 2, 10, 10), QRect(0, 0, 12, 12)),
        Rect2RectRow(QRect(10, 10, -10, -10), QRect(20, 20, 10, 10), QRect(0, 0, 30, 30)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(7, 7, -4, -4), QRect(0, 0, 10, 10)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(9, 9, -8, -8), QRect(0, 0, 10, 10)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(12, 12, -8, -8), QRect(0, 0, 12, 12)),
        Rect2RectRow(QRect(0, 0, 10, 10), QRect(30, 30, -8, -8), QRect(0, 0, 30, 30)),
        Rect2RectRow(QRect(0, 0, 0, 0), QRect(10, 10, 10, 10), QRect(10, 10, 10, 10)),
        Rect2RectRow(QRect(10, 10, 10, 10), QRect(0, 0, 0, 0), QRect(10, 10, 10, 10)),
        Rect2RectRow(QRect(0, 0, 0, 0), QRect(0, 0, 0, 0), QRect(0, 0, 0, 0)),
        Rect2RectRow(QRect(0, 0, 100, 0), QRect(0, 0, 0, 100), QRect(0, 0, 100, 100)),
    ];
}

// unitedRect
unittest
{
    foreach (i, row; unitedRect_data())
        assert((row.a.united(row.b) == row.r), "unitedRect row " ~ i.to!string);
}

private RectF2RectFRow[] unitedRectF_data()
{
    return [
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(2, 2, 6, 6), QRectF(0, 0, 10, 10)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(0, 0, 10, 10), QRectF(0, 0, 10, 10)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(2, 2, 10, 10), QRectF(0, 0, 12, 12)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(20, 20, 10, 10), QRectF(0, 0, 30, 30)),
        RectF2RectFRow(QRectF(10, 10, -10, -10), QRectF(2, 2, 6, 6), QRectF(0, 0, 10, 10)),
        RectF2RectFRow(QRectF(10, 10, -10, -10), QRectF(0, 0, 10, 10), QRectF(0, 0, 10, 10)),
        RectF2RectFRow(QRectF(10, 10, -10, -10), QRectF(2, 2, 10, 10), QRectF(0, 0, 12, 12)),
        RectF2RectFRow(QRectF(10, 10, -10, -10), QRectF(20, 20, 10, 10), QRectF(0, 0, 30, 30)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(8, 8, -6, -6), QRectF(0, 0, 10, 10)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(10, 10, -10, -10), QRectF(0, 0, 10, 10)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(12, 12, -10, -10), QRectF(0, 0, 12, 12)),
        RectF2RectFRow(QRectF(0, 0, 10, 10), QRectF(30, 30, -10, -10), QRectF(0, 0, 30, 30)),
        RectF2RectFRow(QRectF(0, 0, 0, 0), QRectF(10, 10, 10, 10), QRectF(10, 10, 10, 10)),
        RectF2RectFRow(QRectF(10, 10, 10, 10), QRectF(0, 0, 0, 0), QRectF(10, 10, 10, 10)),
        RectF2RectFRow(QRectF(0, 0, 0, 0), QRectF(0, 0, 0, 0), QRectF(0, 0, 0, 0)),
        RectF2RectFRow(QRectF(0, 0, 100, 0), QRectF(0, 0, 0, 100), QRectF(0, 0, 100, 100)),
    ];
}

// unitedRectF
unittest
{
    foreach (i, row; unitedRectF_data())
        assert((row.a.united(row.b) == row.r), "unitedRectF row " ~ i.to!string);
}

private struct Rect2BoolRow
{
    QRect a, b;
    bool value;
}
private Rect2BoolRow[] intersectsRect_data()
{
    return [
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(2, 2, 6, 6), true),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(0, 0, 10, 10), true),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(2, 2, 10, 10), true),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(20, 20, 10, 10), false),
        Rect2BoolRow(QRect(9, 9, -8, -8), QRect(2, 2, 6, 6), true),
        Rect2BoolRow(QRect(9, 9, -8, -8), QRect(0, 0, 10, 10), true),
        Rect2BoolRow(QRect(9, 9, -8, -8), QRect(2, 2, 10, 10), true),
        Rect2BoolRow(QRect(9, 9, -8, -8), QRect(20, 20, 10, 10), false),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(7, 7, -4, -4), true),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(9, 9, -8, -8), true),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(11, 11, -8, -8), true),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(29, 29, -8, -8), false),
        Rect2BoolRow(QRect(0, 0, 0, 0), QRect(10, 10, 10, 10), false),
        Rect2BoolRow(QRect(10, 10, 10, 10), QRect(0, 0, 0, 0), false),
        Rect2BoolRow(QRect(0, 0, 0, 0), QRect(0, 0, 0, 0), false),
        Rect2BoolRow(QRect(10, 10, 10, 10), QRect(19, 15, 1, 5), true),
        Rect2BoolRow(QRect(10, 10, 10, 10), QRect(15, 19, 5, 1), true),
        Rect2BoolRow(QRect(2, 0, 1, 652), QRect(2, 0, 1, 652), true),
    ];
}

// intersectsRect
unittest
{
    foreach (i, row; intersectsRect_data())
        assert(row.a.intersects(row.b) == row.value, "intersectsRect row " ~ i.to!string);
}

private struct RectF2BoolRow
{
    QRectF a, b;
    bool value;
}
private RectF2BoolRow[] intersectsRectF_data()
{
    return [
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(2, 2, 6, 6), true),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(0, 0, 10, 10), true),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(2, 2, 10, 10), true),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(20, 20, 10, 10), false),
        RectF2BoolRow(QRectF(10, 10, -10, -10), QRectF(2, 2, 6, 6), true),
        RectF2BoolRow(QRectF(10, 10, -10, -10), QRectF(0, 0, 10, 10), true),
        RectF2BoolRow(QRectF(10, 10, -10, -10), QRectF(2, 2, 10, 10), true),
        RectF2BoolRow(QRectF(10, 10, -10, -10), QRectF(20, 20, 10, 10), false),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(8, 8, -6, -6), true),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(10, 10, -10, -10), true),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(12, 12, -10, -10), true),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(30, 30, -10, -10), false),
        RectF2BoolRow(QRectF(0, 0, 0, 0), QRectF(10, 10, 10, 10), false),
        RectF2BoolRow(QRectF(10, 10, 10, 10), QRectF(0, 0, 0, 0), false),
        RectF2BoolRow(QRectF(0, 0, 0, 0), QRectF(0, 0, 0, 0), false),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(10, 10, 10, 10), false),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(0, 10, 10, 10), false),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(10, 0, 10, 10), false),
    ];
}

// intersectsRectF
unittest
{
    foreach (i, row; intersectsRectF_data())
        assert(row.a.intersects(row.b) == row.value, "intersectsRectF row " ~ i.to!string);
}

private Rect2BoolRow[] containsRect_data()
{
    return [
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(2, 2, 6, 6), true),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(0, 0, 10, 10), true),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(2, 2, 10, 10), false),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(20, 20, 10, 10), false),
        Rect2BoolRow(QRect(9, 9, -9, -9), QRect(2, 2, 6, 6), true),
        Rect2BoolRow(QRect(9, 9, -9, -9), QRect(0, 0, 9, 9), true),
        Rect2BoolRow(QRect(9, 9, -9, -9), QRect(2, 2, 9, 9), false),
        Rect2BoolRow(QRect(9, 9, -9, -9), QRect(20, 20, 10, 10), false),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(7, 7, -4, -4), true),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(9, 9, -8, -8), true),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(11, 11, -8, -8), false),
        Rect2BoolRow(QRect(0, 0, 10, 10), QRect(29, 29, -8, -8), false),
        Rect2BoolRow(QRect(-1, 1, 10, 10), QRect(0, 0, 0, 0), false),
        Rect2BoolRow(QRect(0, 0, 0, 0), QRect(0, 0, 10, 10), false),
        Rect2BoolRow(QRect(0, 0, 0, 0), QRect(0, 0, 0, 0), false),
    ];
}

// containsRect
unittest
{
    foreach (i, row; containsRect_data())
        assert(row.a.contains(row.b) == row.value, "containsRect row " ~ i.to!string);
}

// containsRectNormalized
unittest
{
    QRect rect = QRect(QPoint(10, 10), QPoint(0, 0));
    QRect normalized = rect.normalized();
    for (int i = -2; i < 12; ++i)
        for (int j = -2; j < 12; ++j)
            for (int k = -2; k <= 2; ++k)
                assert(rect.contains(QRect(i, j, k, k)) == normalized.contains(QRect(i, j, k, k)));
}

private RectF2BoolRow[] containsRectF_data()
{
    return [
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(2, 2, 6, 6), true),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(0, 0, 10, 10), true),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(2, 2, 10, 10), false),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(20, 20, 10, 10), false),
        RectF2BoolRow(QRectF(10, 10, -10, -10), QRectF(2, 2, 6, 6), true),
        RectF2BoolRow(QRectF(10, 10, -10, -10), QRectF(0, 0, 10, 10), true),
        RectF2BoolRow(QRectF(10, 10, -10, -10), QRectF(2, 2, 10, 10), false),
        RectF2BoolRow(QRectF(10, 10, -10, -10), QRectF(20, 20, 10, 10), false),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(8, 8, -6, -6), true),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(10, 10, -10, -10), true),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(12, 12, -10, -10), false),
        RectF2BoolRow(QRectF(0, 0, 10, 10), QRectF(30, 30, -10, -10), false),
        RectF2BoolRow(QRectF(-1, 1, 10, 10), QRectF(0, 0, 0, 0), false),
        RectF2BoolRow(QRectF(0, 0, 0, 0), QRectF(0, 0, 10, 10), false),
        RectF2BoolRow(QRectF(0, 0, 0, 0), QRectF(0, 0, 0, 0), false),
    ];
}

// containsRectF
unittest
{
    foreach (i, row; containsRectF_data())
        assert(row.a.contains(row.b) == row.value, "containsRectF row " ~ i.to!string);
}

private struct ContainsPointRow
{
    QRect r;
    QPoint p;
    bool contains, containsProper;
}
private ContainsPointRow[] containsPoint_data()
{
    return [
        ContainsPointRow(QRect(0, 0, 10, 10), QPoint(0, 0), true, false),
        ContainsPointRow(QRect(0, 0, 10, 10), QPoint(0, 10), false, false),
        ContainsPointRow(QRect(0, 0, 10, 10), QPoint(10, 0), false, false),
        ContainsPointRow(QRect(0, 0, 10, 10), QPoint(10, 10), false, false),
        ContainsPointRow(QRect(0, 0, 10, 10), QPoint(0, 9), true, false),
        ContainsPointRow(QRect(0, 0, 10, 10), QPoint(9, 0), true, false),
        ContainsPointRow(QRect(0, 0, 10, 10), QPoint(9, 9), true, false),
        ContainsPointRow(QRect(0, 0, 10, 10), QPoint(1, 0), true, false),
        ContainsPointRow(QRect(0, 0, 10, 10), QPoint(9, 1), true, false),
        ContainsPointRow(QRect(0, 0, 10, 10), QPoint(1, 1), true, true),
        ContainsPointRow(QRect(0, 0, 10, 10), QPoint(1, 8), true, true),
        ContainsPointRow(QRect(0, 0, 10, 10), QPoint(8, 8), true, true),
        ContainsPointRow(QRect(9, 9, -9, -9), QPoint(0, 0), true, false),
        ContainsPointRow(QRect(9, 9, -9, -9), QPoint(0, 9), false, false),
        ContainsPointRow(QRect(9, 9, -9, -9), QPoint(9, 0), false, false),
        ContainsPointRow(QRect(9, 9, -9, -9), QPoint(9, 9), false, false),
        ContainsPointRow(QRect(9, 9, -9, -9), QPoint(0, 8), true, false),
        ContainsPointRow(QRect(9, 9, -9, -9), QPoint(8, 0), true, false),
        ContainsPointRow(QRect(9, 9, -9, -9), QPoint(8, 8), true, false),
        ContainsPointRow(QRect(9, 9, -9, -9), QPoint(1, 0), true, false),
        ContainsPointRow(QRect(9, 9, -9, -9), QPoint(8, 1), true, false),
        ContainsPointRow(QRect(9, 9, -9, -9), QPoint(1, 1), true, true),
        ContainsPointRow(QRect(9, 9, -9, -9), QPoint(1, 7), true, true),
        ContainsPointRow(QRect(9, 9, -9, -9), QPoint(7, 7), true, true),
        ContainsPointRow(QRect(-1, 1, 10, 10), QPoint(0, 0), false, false),
        ContainsPointRow(QRect(0, 0, 0, 0), QPoint(1, 1), false, false),
        ContainsPointRow(QRect(0, 0, 0, 0), QPoint(0, 0), false, false),
    ];
}

// containsPoint
unittest
{
    foreach (i, row; containsPoint_data())
    {
        string ctx = "containsPoint row " ~ i.to!string;
        assert(row.r.contains(row.p) == row.contains, ctx);
        assert(row.r.contains(row.p, true) == row.containsProper, ctx);
    }
}

// containsPointNormalized
unittest
{
    QRect rect = QRect(QPoint(10, 10), QPoint(0, 0));
    QRect normalized = rect.normalized();
    for (int i = 0; i < 10; ++i)
        for (int j = 0; j < 10; ++j)
            assert(rect.contains(QPoint(i, j)) == normalized.contains(QPoint(i, j)));
}

private struct ContainsPointFRow
{
    QRectF r;
    QPointF p;
    bool contains;
}
private ContainsPointFRow[] containsPointF_data()
{
    return [
        ContainsPointFRow(QRectF(0, 0, 0, 0), QPointF(0, 0), false),
        ContainsPointFRow(QRectF(0, 0, 10, 10), QPointF(0, 0), true),
        ContainsPointFRow(QRectF(0, 0, 10, 10), QPointF(0, 10), true),
        ContainsPointFRow(QRectF(0, 0, 10, 10), QPointF(10, 0), true),
        ContainsPointFRow(QRectF(0, 0, 10, 10), QPointF(10, 10), true),
        ContainsPointFRow(QRectF(0, 0, 10, 10), QPointF(0, 9), true),
        ContainsPointFRow(QRectF(0, 0, 10, 10), QPointF(9, 0), true),
        ContainsPointFRow(QRectF(0, 0, 10, 10), QPointF(9, 9), true),
        ContainsPointFRow(QRectF(0, 0, 10, 10), QPointF(1, 0), true),
        ContainsPointFRow(QRectF(0, 0, 10, 10), QPointF(9, 1), true),
        ContainsPointFRow(QRectF(0, 0, 10, 10), QPointF(1, 1), true),
        ContainsPointFRow(QRectF(0, 0, 10, 10), QPointF(1, 8), true),
        ContainsPointFRow(QRectF(0, 0, 10, 10), QPointF(8, 8), true),
        ContainsPointFRow(QRectF(10, 10, -10, -10), QPointF(0, 0), true),
        ContainsPointFRow(QRectF(10, 10, -10, -10), QPointF(0, 10), true),
        ContainsPointFRow(QRectF(10, 10, -10, -10), QPointF(10, 0), true),
        ContainsPointFRow(QRectF(10, 10, -10, -10), QPointF(10, 10), true),
        ContainsPointFRow(QRectF(10, 10, -10, -10), QPointF(0, 9), true),
        ContainsPointFRow(QRectF(10, 10, -10, -10), QPointF(9, 0), true),
        ContainsPointFRow(QRectF(10, 10, -10, -10), QPointF(9, 9), true),
        ContainsPointFRow(QRectF(10, 10, -10, -10), QPointF(1, 0), true),
        ContainsPointFRow(QRectF(10, 10, -10, -10), QPointF(9, 1), true),
        ContainsPointFRow(QRectF(10, 10, -10, -10), QPointF(1, 1), true),
        ContainsPointFRow(QRectF(10, 10, -10, -10), QPointF(1, 8), true),
        ContainsPointFRow(QRectF(10, 10, -10, -10), QPointF(8, 8), true),
        ContainsPointFRow(QRectF(-1, 1, 10, 10), QPointF(0, 0), false),
        ContainsPointFRow(QRectF(0, 0, 0, 0), QPointF(1, 1), false),
        ContainsPointFRow(QRectF(0, 0, 0, 0), QPointF(0, 0), false),
    ];
}

// containsPointF
unittest
{
    foreach (i, row; containsPointF_data())
        assert(row.r.contains(row.p) == row.contains, "containsPointF row " ~ i.to!string);
}

// smallRects
unittest
{
    const QRectF r1 = QRectF(0, 0, 1e-12, 1e-12);
    const QRectF r2 = QRectF(0, 0, 1e-14, 1e-14);

    // r2 is 10000 times bigger than r1
    assert(!(r1 == r2));
    assert(r1 != r2);
}

// toRect
unittest
{
    for (qreal x = 1.0; x < 2.0; x += 0.25)
        for (qreal y = 1.0; y < 2.0; y += 0.25)
            for (qreal w = 1.0; w < 2.0; w += 0.25)
                for (qreal h = 1.0; h < 2.0; h += 0.25)
                {
                    QRectF rectf = QRectF(x, y, w, h);
                    QRectF rect = rectf.toRect();
                    assert(qAbs(rect.x() - rectf.x()) <= 0.75);
                    assert(qAbs(rect.y() - rectf.y()) <= 0.75);
                    assert(qAbs(rect.width() - rectf.width()) <= 0.75);
                    assert(qAbs(rect.height() - rectf.height()) <= 0.75);
                    assert(qAbs(rect.right() - rectf.right()) <= 0.75);
                    assert(qAbs(rect.bottom() - rectf.bottom()) <= 0.75);

                    QRectF arect = rectf.toAlignedRect();
                    assert(qAbs(arect.x() - rectf.x()) < 1.0);
                    assert(qAbs(arect.y() - rectf.y()) < 1.0);
                    assert(qAbs(arect.width() - rectf.width()) < 2.0);
                    assert(qAbs(arect.height() - rectf.height()) < 2.0);
                    assert(qAbs(arect.right() - rectf.right()) < 1.0);
                    assert(qAbs(arect.bottom() - rectf.bottom()) < 1.0);

                    assert(arect.contains(rectf));
                    assert(arect.contains(rect));
                }
}

// span
unittest
{
    assert((QRect.span(QPoint(0, 1), QPoint(9, 10)) == QRect(QPoint(0, 1), QPoint(9, 10))));
    assert((QRect.span(QPoint(10, 9), QPoint(1, 0)) == QRect(QPoint(1, 0), QPoint(10, 9))));
    assert((QRect.span(QPoint(10, 1), QPoint(0, 9)) == QRect(QPoint(0, 1), QPoint(10, 9))));
    assert((QRect.span(QPoint(1, 10), QPoint(9, 0)) == QRect(QPoint(1, 0), QPoint(9, 10))));
}
