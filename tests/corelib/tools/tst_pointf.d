// QT_MODULES: core
module corelib.tools.tst_pointf;

import qt.core.point;
import qt.core.global;
import std.math : sqrt;
import std.stdio : writeln;
import std.conv : to;

/*
 * Port of qtbase/tests/auto/corelib/tools/qpointf/tst_qpointf.cpp.
 *
 * Conventions (same as tst_date.d):
 *   - each C++ `*_data` fixture is a separate D function placed immediately
 *     before the test that uses it;
 *   - functionality whose D binding is missing is emitted as commented-out code
 *     with a `// BINDING GAP:` note.
 *
 * BINDING GAP: `QDataStream`'s `operator<<`/`operator>>` for `QPointF` are not
 * bound, so `stream` is recorded.
 *
 * BINDING GAP: `structuredBinding` exercises C++ structured bindings
 * (`auto [x, y] = p`), a C++-only construct; it is recorded below.
 *
 * BINDING GAP (rvalue parameters): these bound methods take `ref const(T)`
 * parameters, which D cannot bind to rvalue temporaries (C++ const references
 * accept them), so a temporary must be stored in a local first:
 *   - `QPoint.opOpAssign`, `QPoint.dotProduct` (`ref const(QPoint)`)
 *   - `QPointF.opOpAssign`, `QPointF.dotProduct` (`ref const(QPointF)`)
 *   - `QPointF(this)` from `QPoint` (`ref const(QPoint)`)
 */

private enum qreal QREAL_MIN = double.min_normal;
private enum qreal QREAL_MAX = double.max;

// ---------------------------------------------------------------------------
// Fixtures and tests
// ---------------------------------------------------------------------------

// isNull
unittest
{
    QPointF point = QPointF(0, 0);
    assert(point.isNull());
    ++point.rx();
    assert(!point.isNull());
    point.rx() -= 2;
    assert(!point.isNull());

    QPointF nullNegativeZero = QPointF(-0.0, -0.0);
    assert(nullNegativeZero.x() == -0.0);
    assert(nullNegativeZero.y() == -0.0);
    assert(nullNegativeZero.isNull());
}

private struct PointRealRow
{
    QPointF point;
    qreal expected;
}
private PointRealRow[] manhattanLength_data()
{
    return [
        // (0, 0)
        PointRealRow(QPointF(0, 0), 0),
        // (10, 0)
        PointRealRow(QPointF(10, 0), 10),
        // (0, 10)
        PointRealRow(QPointF(0, 10), 10),
        // (10, 20)
        PointRealRow(QPointF(10, 20), 30),
        // (10.1, 20.2)
        PointRealRow(QPointF(10.1, 20.2), 30.3),
        // (-10.1, -20.2)
        PointRealRow(QPointF(-10.1, -20.2), 30.3),
    ];
}

// manhattanLength
unittest
{
    foreach (i, r; manhattanLength_data())
    {
        assert(qFuzzyCompare(r.point.manhattanLength(), r.expected),
            "manhattanLength row " ~ i.to!string);
    }
}

private qreal[] getSet_data()
{
    return [0, -1, 1, QREAL_MAX, QREAL_MIN];
}

// getSet
unittest
{
    foreach (i, v; getSet_data())
    {
        QPointF point = QPointF.init;
        point.setX(v);
        assert(qFuzzyCompare(point.x(), v), "getSet x row " ~ i.to!string);
        point.setY(v);
        assert(qFuzzyCompare(point.y(), v), "getSet y row " ~ i.to!string);
    }
}

// transposed
unittest
{
    assert((QPointF(1, 2).transposed() == QPointF(2, 1)));
}

// rx
unittest
{
    QPointF originalPoint = QPointF(-1, 0);
    QPointF point = originalPoint;
    ++point.rx();
    assert(point.x() == originalPoint.x() + 1);
}

// ry
unittest
{
    QPointF originalPoint = QPointF(0, -1);
    QPointF point = originalPoint;
    ++point.ry();
    assert(point.y() == originalPoint.y() + 1);
}

private struct PointFPairRow
{
    QPointF point1, point2, expected;
}
private PointFPairRow[] operator_add_data()
{
    return [
        // (0, 0) + (0, 0)
        PointFPairRow(QPointF(0, 0), QPointF(0, 0), QPointF(0, 0)),
        // (0, 9) + (1, 0)
        PointFPairRow(QPointF(0, 9), QPointF(1, 0), QPointF(1, 9)),
        // (QREAL_MIN, 0) + (1, 0)
        PointFPairRow(QPointF(QREAL_MIN, 0), QPointF(1, 0), QPointF(QREAL_MIN + 1, 0)),
        // (QREAL_MAX, 0) + (-1, 0)
        PointFPairRow(QPointF(QREAL_MAX, 0), QPointF(-1, 0), QPointF(QREAL_MAX - 1, 0)),
    ];
}

// operator_add
unittest
{
    foreach (i, r; operator_add_data())
    {
        string ctx = "operator_add row " ~ i.to!string;
        assert((r.point1 + r.point2 == r.expected), ctx);
        QPointF point1 = r.point1;
        point1 += r.point2;
        assert((point1 == r.expected), ctx);
    }
}

private PointFPairRow[] operator_subtract_data()
{
    return [
        // (0, 0) - (0, 0)
        PointFPairRow(QPointF(0, 0), QPointF(0, 0), QPointF(0, 0)),
        // (0, 9) - (1, 0)
        PointFPairRow(QPointF(0, 9), QPointF(1, 0), QPointF(-1, 9)),
        // (QREAL_MAX, 0) - (1, 0)
        PointFPairRow(QPointF(QREAL_MAX, 0), QPointF(1, 0), QPointF(QREAL_MAX - 1, 0)),
        // (QREAL_MIN, 0) - (-1, 0)
        PointFPairRow(QPointF(QREAL_MIN, 0), QPointF(-1, 0), QPointF(QREAL_MIN - -1, 0)),
    ];
}

// operator_subtract
unittest
{
    foreach (i, r; operator_subtract_data())
    {
        string ctx = "operator_subtract row " ~ i.to!string;
        assert((r.point1 - r.point2 == r.expected), ctx);
        QPointF point1 = r.point1;
        point1 -= r.point2;
        assert((point1 == r.expected), ctx);
    }
}

private struct MulFRow
{
    QPointF point;
    qreal factor;
    QPointF expected;
}
private MulFRow[] operator_multiply_data()
{
    return [
        // (0, 0) * 0.0
        MulFRow(QPointF(0, 0), qreal(0), QPointF(0, 0)),
        // (QREAL_MIN, 1) * 0.5
        MulFRow(QPointF(QREAL_MIN, 1), qreal(0.5), QPointF(QREAL_MIN * 0.5, 0.5)),
        // (QREAL_MAX, 2) * 0.5
        MulFRow(QPointF(QREAL_MAX, 2), qreal(0.5), QPointF(QREAL_MAX * 0.5, 1)),
    ];
}

// operator_multiply
unittest
{
    foreach (i, r; operator_multiply_data())
    {
        string ctx = "operator_multiply row " ~ i.to!string;
        assert((r.point * r.factor == r.expected), ctx);
        // Test with reversed argument version.
        assert((r.factor * r.point == r.expected), ctx);
        QPointF point = r.point;
        point *= r.factor;
        assert((point == r.expected), ctx);
    }
}

private struct DivFRow
{
    QPointF point;
    qreal divisor;
    QPointF expected;
}
private DivFRow[] operator_divide_data()
{
    return [
        // (0, 0) / 1
        DivFRow(QPointF(0, 0), qreal(1), QPointF(0, 0)),
        // (0, 9) / 2
        DivFRow(QPointF(0, 9), qreal(2), QPointF(0, 4.5)),
        // (QREAL_MAX, 0) / 2
        DivFRow(QPointF(QREAL_MAX, 0), qreal(2), QPointF(QREAL_MAX / qreal(2), 0)),
        // (QREAL_MIN, 0) / -1.5
        DivFRow(QPointF(QREAL_MIN, 0), qreal(-1.5), QPointF(QREAL_MIN / qreal(-1.5), 0)),
    ];
}

// operator_divide
unittest
{
    foreach (i, r; operator_divide_data())
    {
        string ctx = "operator_divide row " ~ i.to!string;
        assert((r.point / r.divisor == r.expected), ctx);
        QPointF point = r.point;
        point /= r.divisor;
        assert((point == r.expected), ctx);
    }
}

// division
unittest
{
    {
        QPointF p = QPointF(1e-14, 1e-14);
        p = p / sqrt(QPointF.dotProduct(p, p));
        assert(qFuzzyCompare(QPointF.dotProduct(p, p), 1.0));
    }
    {
        QPointF p = QPointF(1e-14, 1e-14);
        p /= sqrt(QPointF.dotProduct(p, p));
        assert(qFuzzyCompare(QPointF.dotProduct(p, p), 1.0));
    }
}

private struct DotRow
{
    QPointF point1, point2;
    qreal expected;
}
private DotRow[] dotProduct_data()
{
    return [
        // (0, 0) dot (0, 0)
        DotRow(QPointF(0, 0), QPointF(0, 0), 0),
        // (10, 0) dot (0, 10)
        DotRow(QPointF(10, 0), QPointF(0, 10), 0),
        // (0, 10) dot (10, 0)
        DotRow(QPointF(0, 10), QPointF(10, 0), 0),
        // (10, 20) dot (-10, -20)
        DotRow(QPointF(10, 20), QPointF(-10, -20), -500),
        // (10.1, 20.2) dot (-10.1, -20.2)
        DotRow(QPointF(10.1, 20.2), QPointF(-10.1, -20.2), -510.05),
        // (-10.1, -20.2) dot (10.1, 20.2)
        DotRow(QPointF(-10.1, -20.2), QPointF(10.1, 20.2), -510.05),
    ];
}

// dotProduct
unittest
{
    foreach (i, r; dotProduct_data())
    {
        assert(qFuzzyCompare(QPointF.dotProduct(r.point1, r.point2), r.expected),
            "dotProduct row " ~ i.to!string);
    }
}

private struct UnaryFRow
{
    QPointF point, expected;
}
private UnaryFRow[] operator_unary_minus_data()
{
    return [
        // -(0, 0)
        UnaryFRow(QPointF(0, 0), QPointF(0, 0)),
        // -(-1, 0)
        UnaryFRow(QPointF(-1, 0), QPointF(1, 0)),
        // -(0, -1)
        UnaryFRow(QPointF(0, -1), QPointF(0, 1)),
        // -(1.2345, 0)
        UnaryFRow(QPointF(1.2345, 0), QPointF(-1.2345, 0)),
        // -(-QREAL_MAX, QREAL_MAX)
        UnaryFRow(QPointF(-QREAL_MAX, QREAL_MAX), QPointF(QREAL_MAX, -QREAL_MAX)),
    ];
}

// operator_unary_plus
unittest
{
    foreach (i, r; operator_unary_minus_data())
        assert((+r.point == r.point), "operator_unary_plus row " ~ i.to!string);
}

// operator_unary_minus
unittest
{
    foreach (i, r; operator_unary_minus_data())
        assert((-r.point == r.expected), "operator_unary_minus row " ~ i.to!string);
}

private struct PointFEqRow
{
    QPointF point1, point2;
    bool equal;
}
private PointFEqRow[] operator_eq_data()
{
    return [
        // (0, 0) == (0, 0)
        PointFEqRow(QPointF(0, 0), QPointF(0, 0), true),
        // (-1, 0) == (-1, 0)
        PointFEqRow(QPointF(-1, 0), QPointF(-1, 0), true),
        // (-1, 0) != (0, 0)
        PointFEqRow(QPointF(-1, 0), QPointF(0, 0), false),
        // (-1, 0) != (0, -1)
        PointFEqRow(QPointF(-1, 0), QPointF(0, -1), false),
        // (-1.125, 0.25) == (-1.125, 0.25)
        PointFEqRow(QPointF(-1.125, 0.25), QPointF(-1.125, 0.25), true),
        // (QREAL_MIN, QREAL_MIN) == (QREAL_MIN, QREAL_MIN)
        PointFEqRow(QPointF(QREAL_MIN, QREAL_MIN), QPointF(QREAL_MIN, QREAL_MIN), true),
        // (QREAL_MAX, QREAL_MAX) == (QREAL_MAX, QREAL_MAX)
        PointFEqRow(QPointF(QREAL_MAX, QREAL_MAX), QPointF(QREAL_MAX, QREAL_MAX), true),
    ];
}

// operator_eq
unittest
{
    foreach (i, r; operator_eq_data())
    {
        string ctx = "operator_eq row " ~ i.to!string;
        assert((r.point1 == r.point2) == r.equal, ctx);
        assert((r.point1 != r.point2) == !r.equal, ctx);
    }
}

private struct ToPointRow
{
    QPointF pointf;
    QPoint expected;
}
private ToPointRow[] toPoint_data()
{
    return [
        // (0.0, 0.0) ==> (0, 0)
        ToPointRow(QPointF(0.0, 0.0), QPoint(0, 0)),
        // (0.5, 0.5) ==> (1, 1)
        ToPointRow(QPointF(0.5, 0.5), QPoint(1, 1)),
        // (-0.5, -0.5) ==> (-1, -1)
        ToPointRow(QPointF(-0.5, -0.5), QPoint(-1, -1)),
    ];
}

// toPoint
unittest
{
    foreach (i, r; toPoint_data())
    {
        QPoint got = r.pointf.toPoint();
        assert(got.x() == r.expected.x() && got.y() == r.expected.y(),
            "toPoint row " ~ i.to!string);
    }
}

// compare
unittest
{
    // First test we can scale and maintain difference.
    QPointF p1 = QPointF(2.0, 2.0);
    QPointF p2 = QPointF(3.0, 3.0);

    assert(p1 != p2);

    p1 /= 1e5;
    p2 /= 1e5;

    assert(!(p1 == p2));

    p1 /= 1e5;
    p2 /= 1e5;

    assert(p1 != p2);

    p1 /= 1e5;
    p2 /= 1e5;

    assert(!(p1 == p2));

    p1 /= 2;
    p2 /= 3;

    assert(p1 == p2);

    // Test we can compare with zero after inexact math
    QPointF p3 = QPointF(3.0, 3.0);
    p3 *= 0.1;
    p3 /= 3;
    // BINDING GAP (rvalue parameters): QPointF.opOpAssign("-") takes
    // `ref const(QPointF)`, which D cannot bind to an rvalue, so bind the
    // subtrahend to a local first (C++ accepts the rvalue directly).
    QPointF sub = QPointF(0.1, 0.1);
    p3 -= sub;

    assert(p3 == QPointF());

    // Test we can compare one dimension with hard zero
    assert(QPointF(1.9543e-14, -32.0) == QPointF(0.0, -32.0));
}

// stream
unittest
{
    // BINDING GAP: QDataStream operator<< / operator>> for QPointF are not
    // bound. The ported test is recorded below instead of being run.
    //
    // private QPointF[] stream_data()
    // {
    //     return [
    //         QPointF(0, 0.5),
    //         QPointF(-1, 1),
    //         QPointF(1, -1),
    //         QPointF(int.min, int.max),
    //     ];
    // }
    //
    // foreach (i, point; stream_data())
    // {
    //     string ctx = "stream row " ~ i.to!string;
    //     QBuffer tmp = QBuffer.create();
    //     assert(tmp.open(QIODevice.OpenModeFlag.ReadWrite), ctx);
    //     QDataStream stream = QDataStream(&tmp);
    //     // Ensure that stream returned is the same stream we inserted into.
    //     QDataStream insertionStreamRef = stream.writePointF(point); // stream << point;
    //     assert(&insertionStreamRef == &stream, ctx);
    //
    //     tmp.seek(0);
    //     QPointF pointFromStream = QPointF.init;
    //     QDataStream extractionStreamRef = stream.readPointF(pointFromStream); // stream >> pointFromStream;
    //     assert(&extractionStreamRef == &stream, ctx);
    //     assert(pointFromStream == point, ctx);
    // }
}

// structuredBinding
unittest
{
    // BINDING GAP: C++ structured bindings (`auto [x, y] = p`) have no D
    // equivalent. The ported test is recorded below instead of being run.
    //
    // {
    //     QPointF p = QPointF(1.5, 2.25);
    //     // auto [x, y] = p;
    //     auto x = p.x();
    //     auto y = p.y();
    //     assert(x == 1.5);
    //     assert(y == 2.25);
    //
    //     p.setX(42);
    //     assert(x == 1.5);
    //     assert(y == 2.25);
    //
    //     p.setY(-123);
    //     assert(x == 1.5);
    //     assert(y == 2.25);
    // }
    // {
    //     QPointF p = QPointF(1.5, 2.25);
    //     // auto &[x, y] = p;
    //     ref qreal x = p.rx();
    //     ref qreal y = p.ry();
    //     assert(x == 1.5);
    //     assert(y == 2.25);
    //
    //     x = 42.0;
    //     assert(x == 42.0);
    //     assert(p.x() == 42.0);
    //     assert(p.rx() == 42.0);
    //     assert(y == 2.25);
    //     assert(p.y() == 2.25);
    //     assert(p.ry() == 2.25);
    //
    //     y = -123.5;
    //     assert(x == 42.0);
    //     assert(p.x() == 42.0);
    //     assert(p.rx() == 42.0);
    //     assert(y == -123.5);
    //     assert(p.y() == -123.5);
    //     assert(p.ry() == -123.5);
    //
    //     p.setX(0.0);
    //     assert(x == 0.0);
    //     assert(p.x() == 0.0);
    //     assert(p.rx() == 0.0);
    //     assert(y == -123.5);
    //     assert(p.y() == -123.5);
    //     assert(p.ry() == -123.5);
    //
    //     p.ry() = 10.5;
    //     assert(x == 0.0);
    //     assert(p.x() == 0.0);
    //     assert(p.rx() == 0.0);
    //     assert(y == 10.5);
    //     assert(p.y() == 10.5);
    //     assert(p.ry() == 10.5);
    // }
}
