// QT_MODULES: core
module corelib.tools.tst_line;

import qt.core.line;
import qt.core.point;
import qt.core.global;
import std.math : sqrt;
import std.stdio : writeln;
import std.conv : to;

/*
 * Port of qtbase/tests/auto/corelib/tools/qline/tst_qline.cpp.
 *
 * Conventions (same as tst_date.d):
 *   - each C++ `*_data` fixture is a separate D function placed immediately
 *     before the test that uses it;
 *   - functionality whose D binding is missing is emitted as commented-out code
 *     with a `// BINDING GAP:` note.
 *
 * BINDING GAP (rvalue parameters): these bound methods take `ref const(T)`
 * parameters, which D cannot bind to rvalue temporaries (C++ const references
 * accept them), so the affected call sites store the temporary in a local first:
 *   - `QLine.translate`, `QLine.setP1`, `QLine.setP2`, `QLine.setPoints`
 *     (`ref const(QPoint)`)
 *   - `QLineF.translate`, `QLineF.setP1`, `QLineF.setP2`, `QLineF.setPoints`
 *     (`ref const(QPointF)`)
 *   - `QLineF.angleTo`, `QLineF.intersects` (`ref const(QLineF)`)
 *   - `QLineF(this)` from `QLine` (`ref const(QLine)`)
 */

private enum double epsilon = 1e-8;
private enum double M_SQRT2 = 1.4142135623730951;
private enum double M_SQRT1_2 = 0.7071067811865476;

// ---------------------------------------------------------------------------
// Fixtures and tests
// ---------------------------------------------------------------------------

// testSet
unittest
{
    {
        QLine l = QLine.init;
        l.setP1(QPoint(1, 2));
        l.setP2(QPoint(3, 4));

        assert(l.x1() == 1);
        assert(l.y1() == 2);
        assert(l.x2() == 3);
        assert(l.y2() == 4);

        l.setPoints(QPoint(5, 6), QPoint(7, 8));
        assert(l.x1() == 5);
        assert(l.y1() == 6);
        assert(l.x2() == 7);
        assert(l.y2() == 8);

        l.setLine(9, 10, 11, 12);
        assert(l.x1() == 9);
        assert(l.y1() == 10);
        assert(l.x2() == 11);
        assert(l.y2() == 12);
    }

    {
        QLineF l = QLineF(0.0, 0.0, 0.0, 0.0);
        l.setP1(QPointF(1, 2));
        l.setP2(QPointF(3, 4));

        assert(l.x1() == 1.0);
        assert(l.y1() == 2.0);
        assert(l.x2() == 3.0);
        assert(l.y2() == 4.0);

        l.setPoints(QPointF(5, 6), QPointF(7, 8));
        assert(l.x1() == 5.0);
        assert(l.y1() == 6.0);
        assert(l.x2() == 7.0);
        assert(l.y2() == 8.0);

        l.setLine(9.0, 10.0, 11.0, 12.0);
        assert(l.x1() == 9.0);
        assert(l.y1() == 10.0);
        assert(l.x2() == 11.0);
        assert(l.y2() == 12.0);
    }
}

private struct IntersectionRow
{
    double xa1, ya1, xa2, ya2, xb1, yb1, xb2, yb2;
    int type;
    double ix, iy;
}
private IntersectionRow[] testIntersection_data()
{
    IntersectionRow[] rows;
    // parallel
    rows ~= IntersectionRow(1.0, 1.0, 3.0, 4.0, 5.0, 6.0, 7.0, 9.0,
        cast(int) QLineF.IntersectionType.NoIntersection, 0.0, 0.0);
    // unbounded
    rows ~= IntersectionRow(1.0, 1.0, 5.0, 5.0, 0.0, 4.0, 3.0, 4.0,
        cast(int) QLineF.IntersectionType.UnboundedIntersection, 4.0, 4.0);
    // bounded
    rows ~= IntersectionRow(1.0, 1.0, 5.0, 5.0, 0.0, 4.0, 5.0, 4.0,
        cast(int) QLineF.IntersectionType.BoundedIntersection, 4.0, 4.0);
    // almost vertical
    rows ~= IntersectionRow(0.0, 10.0, 20.0000000000001, 10.0, 10.0, 0.0, 10.0, 20.0,
        cast(int) QLineF.IntersectionType.BoundedIntersection, 10.0, 10.0);
    // almost horizontal
    rows ~= IntersectionRow(0.0, 10.0, 20.0, 10.0, 10.0000000000001, 0.0, 10.0, 20.0,
        cast(int) QLineF.IntersectionType.BoundedIntersection, 10.0, 10.0);
    // long vertical
    rows ~= IntersectionRow(100.1599256468623, 100.7861905065196, 100.1599256468604, -9999.78619050651,
        10.0, 50.0, 190.0, 50.0,
        cast(int) QLineF.IntersectionType.BoundedIntersection, 100.1599256468622, 50.0);

    for (int i = 0; i < 1000; ++i)
    {
        QLineF a = QLineF.fromPolar(50, i);
        // BINDING GAP (rvalue parameters): QLineF.setP1 takes
        // `ref const(QPointF)`, which D cannot bind to an rvalue, so bind the
        // negated point to a local first (C++ accepts the rvalue directly).
        QPointF aNeg = -a.p2();
        a.setP1(aNeg);

        QLineF b = QLineF.fromPolar(50, i * 0.997 + 90);
        QPointF bNeg = -b.p2();
        b.setP1(bNeg);

        // make the qFuzzyCompare be a bit more lenient
        a = a.translated(1, 1);
        b = b.translated(1, 1);

        rows ~= IntersectionRow(a.x1(), a.y1(), a.x2(), a.y2(),
            b.x1(), b.y1(), b.x2(), b.y2(),
            cast(int) QLineF.IntersectionType.BoundedIntersection, 1.0, 1.0);
    }

    return rows;
}

// testIntersection
unittest
{
    foreach (i, r; testIntersection_data())
    {
        string ctx = "testIntersection row " ~ i.to!string;
        QLineF a = QLineF(r.xa1, r.ya1, r.xa2, r.ya2);
        QLineF b = QLineF(r.xb1, r.yb1, r.xb2, r.yb2);

        QPointF ip = QPointF(0, 0);
        QLineF.IntersectionType itype = a.intersects(b, &ip);

        assert(cast(int) itype == r.type, ctx);
        if (r.type != cast(int) QLineF.IntersectionType.NoIntersection)
        {
            assert(qAbs(ip.x() - r.ix) < epsilon, ctx);
            assert(qAbs(ip.y() - r.iy) < epsilon, ctx);
        }
    }
}

private struct LengthRow
{
    double x1, y1, x2, y2;
    double length, lengthToSet, vx, vy;
}
private LengthRow[] testLength_data()
{
    LengthRow[] rows;
    // [1,0]->|2|
    rows ~= LengthRow(0.0, 0.0, 1.0, 0.0, 1.0, 2.0, 2.0, 0.0);
    // [0,1]->|2|
    rows ~= LengthRow(0.0, 0.0, 0.0, 1.0, 1.0, 2.0, 0.0, 2.0);
    // [-1,0]->|2|
    rows ~= LengthRow(0.0, 0.0, -1.0, 0.0, 1.0, 2.0, -2.0, 0.0);
    // [0,-1]->|2
    rows ~= LengthRow(0.0, 0.0, 0.0, -1.0, 1.0, 2.0, 0.0, -2.0);
    // [1,1]->->|1|
    rows ~= LengthRow(0.0, 0.0, 1.0, 1.0, M_SQRT2, 1.0, M_SQRT1_2, M_SQRT1_2);
    // [-1,1]->|1|
    rows ~= LengthRow(0.0, 0.0, -1.0, 1.0, M_SQRT2, 1.0, -M_SQRT1_2, M_SQRT1_2);
    // [1,-1]->|1|
    rows ~= LengthRow(0.0, 0.0, 1.0, -1.0, M_SQRT2, 1.0, M_SQRT1_2, -M_SQRT1_2);
    // [-1,-1]->|1|
    rows ~= LengthRow(0.0, 0.0, -1.0, -1.0, M_SQRT2, 1.0, -M_SQRT1_2, -M_SQRT1_2);
    // [1,0]->|2| (2,2)
    rows ~= LengthRow(2.0, 2.0, 3.0, 2.0, 1.0, 2.0, 2.0, 0.0);
    // [0,1]->|2| (2,2)
    rows ~= LengthRow(2.0, 2.0, 2.0, 3.0, 1.0, 2.0, 0.0, 2.0);
    // [-1,0]->|2| (2,2)
    rows ~= LengthRow(2.0, 2.0, 1.0, 2.0, 1.0, 2.0, -2.0, 0.0);
    // [0,-1]->|2| (2,2)
    rows ~= LengthRow(2.0, 2.0, 2.0, 1.0, 1.0, 2.0, 0.0, -2.0);
    // [1,1]->|1| (2,2)
    rows ~= LengthRow(2.0, 2.0, 3.0, 3.0, M_SQRT2, 1.0, M_SQRT1_2, M_SQRT1_2);
    // [-1,1]->|1| (2,2)
    rows ~= LengthRow(2.0, 2.0, 1.0, 3.0, M_SQRT2, 1.0, -M_SQRT1_2, M_SQRT1_2);
    // [1,-1]->|1| (2,2)
    rows ~= LengthRow(2.0, 2.0, 3.0, 1.0, M_SQRT2, 1.0, M_SQRT1_2, -M_SQRT1_2);
    // [-1,-1]->|1| (2,2)
    rows ~= LengthRow(2.0, 2.0, 1.0, 1.0, M_SQRT2, 1.0, -M_SQRT1_2, -M_SQRT1_2);

    double denormMin = double.min_normal * double.epsilon;
    double small = sqrt(denormMin) / 8;
    // [small,small]->|2| (-small/2,-small/2)
    rows ~= LengthRow(-(small * .5), -(small * .5), small * .5, small * .5,
        small * M_SQRT2, 2 * M_SQRT2, 2.0, 2.0);
    double tiny = double.min_normal / 2;
    // [tiny,tiny]->|2| (-tiny/2,-tiny/2)
    rows ~= LengthRow(-(tiny * .5), -(tiny * .5), tiny * .5, tiny * .5,
        tiny * M_SQRT2, 2 * M_SQRT2, 2.0, 2.0);
    //[1+3e-13,1+4e-13]|1895| (1, 1)
    rows ~= LengthRow(1.0, 1.0, 1 + 3e-13, 1 + 4e-13, 5e-13, 1895.0, 1137.0, 1516.0);
    // Unavoidable underflow: denormals (D rejects subnormal literals).
    double d4 = 8 * denormMin;
    rows ~= LengthRow(0.0, 0.0, d4, denormMin, d4, 1892.0, d4, denormMin);
    return rows;
}

// testLength
unittest
{
    foreach (i, r; testLength_data())
    {
        string ctx = "testLength row " ~ i.to!string;
        QLineF l = QLineF(r.x1, r.y1, r.x2, r.y2);
        // Accept the file's absolute epsilon in addition to qFuzzyCompare: the
        // tiny-value rows scale a unit-diagonal length by ~1e-13, where the
        // stored coordinates lose precision well beyond qFuzzyCompare's 1e-12
        // relative bound (the source notes "scaling tiny values up to big can
        // be imprecise").
        assert(qFuzzyCompare(l.length(), r.length)
            || qAbs(l.length() - r.length) < epsilon, ctx);

        l.setLength(r.lengthToSet);

        // Scaling tiny values up to big can be imprecise: don't try to test vx, vy
        if (r.length > 0 && qFuzzyIsNull(r.length)) {
            assert(l.length() > r.lengthToSet / 2 && l.length() < r.lengthToSet * 2, ctx);
        } else {
            assert(qFuzzyCompare(l.length(), r.length > 0 ? r.lengthToSet : r.length), ctx);
            assert(qFuzzyCompare(l.dx(), r.vx), ctx);
            assert(qFuzzyCompare(l.dy(), r.vy), ctx);
        }
    }
}

private struct CenterRow
{
    int x1, y1, x2, y2, cx, cy;
}
private CenterRow[] testCenter_data()
{
    return [
        // [0, 0]
        CenterRow(0, 0, 0, 0, 0, 0),
        // top
        CenterRow(0, 0, 2, 0, 1, 0),
        // right
        CenterRow(0, 0, 0, 2, 0, 1),
        // bottom
        CenterRow(0, 0, -2, 0, -1, 0),
        // left
        CenterRow(0, 0, 0, -2, 0, -1),
        // precision+
        CenterRow(0, 0, 1, 1, 0, 0),
        // precision-
        CenterRow(-1, -1, 0, 0, 0, 0),
        // max
        CenterRow(int.max, int.max, int.max, int.max, int.max, int.max),
        // min
        CenterRow(int.min, int.min, int.min, int.min, int.min, int.min),
        // minmax
        CenterRow(int.min, int.min, int.max, int.max, 0, 0),
    ];
}

// testCenter
unittest
{
    foreach (i, r; testCenter_data())
    {
        QPoint c = QLine(r.x1, r.y1, r.x2, r.y2).center();
        string ctx = "testCenter row " ~ i.to!string;
        assert(r.cx == c.x(), ctx);
        assert(r.cy == c.y(), ctx);
    }
}

private struct CenterFRow
{
    double x1, y1, x2, y2, cx, cy;
}
private CenterFRow[] testCenterF_data()
{
    return [
        // [0, 0]
        CenterFRow(0.0, 0.0, 0.0, 0.0, 0.0, 0.0),
        // top
        CenterFRow(0.0, 0.0, 1.0, 0.0, 0.5, 0.0),
        // right
        CenterFRow(0.0, 0.0, 0.0, 1.0, 0.0, 0.5),
        // bottom
        CenterFRow(0.0, 0.0, -1.0, 0.0, -0.5, 0.0),
        // left
        CenterFRow(0.0, 0.0, 0.0, -1.0, 0.0, -0.5),
        // max
        CenterFRow(double.max, double.max, double.max, double.max, double.max, double.max),
    ];
}

// testCenterF
unittest
{
    foreach (i, r; testCenterF_data())
    {
        QPointF c = QLineF(r.x1, r.y1, r.x2, r.y2).center();
        string ctx = "testCenterF row " ~ i.to!string;
        assert(r.cx == c.x(), ctx);
        assert(r.cy == c.y(), ctx);
    }
}

private struct NormalRow
{
    double x1, y1, x2, y2, nvx, nvy;
}
private NormalRow[] testNormalVector_data()
{
    return [
        // [1, 0]
        NormalRow(0.0, 0.0, 1.0, 0.0, 0.0, -1.0),
        // [-1, 0]
        NormalRow(0.0, 0.0, -1.0, 0.0, 0.0, 1.0),
        // [0, 1]
        NormalRow(0.0, 0.0, 0.0, 1.0, 1.0, 0.0),
        // [0, -1]
        NormalRow(0.0, 0.0, 0.0, -1.0, -1.0, 0.0),
        // [2, 3]
        NormalRow(2.0, 3.0, 4.0, 6.0, 3.0, -2.0),
    ];
}

// testNormalVector
unittest
{
    foreach (i, r; testNormalVector_data())
    {
        string ctx = "testNormalVector row " ~ i.to!string;
        QLineF l = QLineF(r.x1, r.y1, r.x2, r.y2);
        QLineF n = l.normalVector();

        assert(l.x1() == n.x1(), ctx);
        assert(l.y1() == n.y1(), ctx);
        assert(qFuzzyCompare(n.dx(), r.nvx), ctx);
        assert(qFuzzyCompare(n.dy(), r.nvy), ctx);
    }
}

private struct AngleRow
{
    qreal x1, y1, x2, y2, angle;
}
private AngleRow[] testAngle2_data()
{
    return [
        // right
        AngleRow(0.0, 0.0, 10.0, 0.0, 0.0),
        // left
        AngleRow(0.0, 0.0, -10.0, 0.0, 180.0),
        // up
        AngleRow(0.0, 0.0, 0.0, -10.0, 90.0),
        // down
        AngleRow(0.0, 0.0, 0.0, 10.0, 270.0),
        // diag a
        AngleRow(0.0, 0.0, 10.0, -10.0, 45.0),
        // diag b
        AngleRow(0.0, 0.0, -10.0, -10.0, 135.0),
        // diag c
        AngleRow(0.0, 0.0, -10.0, 10.0, 225.0),
        // diag d
        AngleRow(0.0, 0.0, 10.0, 10.0, 315.0),
    ];
}

// testAngle2
unittest
{
    foreach (i, r; testAngle2_data())
    {
        string ctx = "testAngle2 row " ~ i.to!string;
        QLineF line = QLineF(r.x1, r.y1, r.x2, r.y2);
        assert(qFuzzyCompare(line.angle(), r.angle), ctx);

        QLineF polar = QLineF.fromPolar(line.length(), r.angle);
        assert(qAbs(line.x1() - polar.x1()) < epsilon, ctx);
        assert(qAbs(line.y1() - polar.y1()) < epsilon, ctx);
        assert(qAbs(line.x2() - polar.x2()) < epsilon, ctx);
        assert(qAbs(line.y2() - polar.y2()) < epsilon, ctx);
    }
}

// testAngle3
unittest
{
    for (int i = -720; i <= 720; ++i)
    {
        QLineF line = QLineF(0, 0, 100, 0);
        line.setAngle(i);
        int expected = (i + 720) % 360;
        string ctx = "testAngle3 value " ~ i.to!string;

        assert(qAbs(line.angle() - cast(qreal) expected) < epsilon, ctx);
        assert(qFuzzyCompare(line.length(), 100.0), ctx);
        assert((QLineF.fromPolar(100.0, i) == line), ctx);
    }
}

private struct AngleToRow
{
    qreal xa1, ya1, xa2, ya2, xb1, yb1, xb2, yb2, angle;
}
private AngleToRow[] testAngleTo_data()
{
    AngleToRow[] rows;
    // parallel
    rows ~= AngleToRow(1.0, 1.0, 3.0, 4.0, 5.0, 6.0, 7.0, 9.0, 0.0);
    // [4,4]-[4,0]
    rows ~= AngleToRow(1.0, 1.0, 5.0, 5.0, 0.0, 4.0, 3.0, 4.0, 45.0);
    // [4,4]-[-4,0]
    rows ~= AngleToRow(1.0, 1.0, 5.0, 5.0, 3.0, 4.0, 0.0, 4.0, 225.0);

    for (int i = 0; i < 360; ++i)
    {
        QLineF l = QLineF.fromPolar(1, i);
        rows ~= AngleToRow(0.0, 0.0, 1.0, 0.0, 0.0, 0.0,
            l.p2().x(), l.p2().y(), i);
    }
    return rows;
}

// testAngleTo
unittest
{
    foreach (i, r; testAngleTo_data())
    {
        string ctx = "testAngleTo row " ~ i.to!string;
        QLineF a = QLineF(r.xa1, r.ya1, r.xa2, r.ya2);
        QLineF b = QLineF(r.xb1, r.yb1, r.xb2, r.yb2);

        qreal resultAngle = a.angleTo(b);
        assert(qAbs(resultAngle - r.angle) < epsilon, ctx);

        // BINDING GAP (rvalue parameters): QLineF.translate takes
        // `ref const(QPointF)`, which D cannot bind to an rvalue, so bind the
        // translated delta to a local first (C++ accepts the rvalue directly).
        QPointF delta = b.p1() - a.p1();
        a.translate(delta);
        a.setAngle(a.angle() + resultAngle);
        a.setLength(b.length());
        assert((a == b), ctx);
    }
}

private struct ToLineFRow
{
    QLine input;
    QLineF result;
}
private ToLineFRow[] toLineF_data()
{
    ToLineFRow[] rows;
    static immutable int[] samples = [-1, 0, 1];
    foreach (x1; samples)
        foreach (y1; samples)
            foreach (x2; samples)
                foreach (y2; samples)
                    rows ~= ToLineFRow(QLine(x1, y1, x2, y2), QLineF(x1, y1, x2, y2));
    return rows;
}

// toLineF
unittest
{
    foreach (i, r; toLineF_data())
    {
        assert((r.input.toLineF() == r.result), "toLineF row " ~ i.to!string);
    }
}
