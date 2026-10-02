// QT_MODULES: core
module corelib.tools.tst_point;

import qt.core.point;
import qt.core.namespace;
import qt.core.global;
import std.stdio : writeln;
import std.conv : to;

/*
 * Port of qtbase/tests/auto/corelib/tools/qpoint/tst_qpoint.cpp.
 *
 * Conventions (same as tst_date.d):
 *   - each C++ `*_data` fixture is a separate D function placed immediately
 *     before the test that uses it;
 *   - functionality whose D binding is missing is emitted as commented-out code
 *     with a `// BINDING GAP:` note.
 *
 * BINDING GAP: `qHash(QPoint)` is not bound; the `qHash` check in
 * `operator_eq` is recorded.
 *
 * BINDING GAP: `QDataStream`'s `operator<<`/`operator>>` for `QPoint` are not
 * bound, so `stream` is recorded commented out.
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

// ---------------------------------------------------------------------------
// Fixtures and tests
// ---------------------------------------------------------------------------

// isNull
unittest
{
    QPoint point = QPoint(0, 0);
    assert(point.isNull());
    ++point.rx();
    assert(!point.isNull());
    point.rx() -= 2;
    assert(!point.isNull());
}

private struct PointIntRow
{
    QPoint point;
    int expected;
}
private PointIntRow[] manhattanLength_data()
{
    return [
        // (0, 0)
        PointIntRow(QPoint(0, 0), 0),
        // (10, 0)
        PointIntRow(QPoint(10, 0), 10),
        // (0, 10)
        PointIntRow(QPoint(0, 10), 10),
        // (10, 20)
        PointIntRow(QPoint(10, 20), 30),
        // (-10, -20)
        PointIntRow(QPoint(-10, -20), 30),
    ];
}

// manhattanLength
unittest
{
    foreach (i, r; manhattanLength_data())
    {
        assert(r.point.manhattanLength() == r.expected,
            "manhattanLength row " ~ i.to!string);
    }
}

private int[] getSet_data()
{
    return [0, int.min, int.max];
}

// getSet
unittest
{
    foreach (i, v; getSet_data())
    {
        QPoint point = QPoint.init;
        point.setX(v);
        assert(point.x() == v, "getSet x row " ~ i.to!string);
        point.setY(v);
        assert(point.y() == v, "getSet y row " ~ i.to!string);
    }
}

private struct ToPointFRow
{
    QPoint input;
    QPointF result;
}
private ToPointFRow[] toPointF_data()
{
    ToPointFRow[] rows;
    static immutable int[] samples = [-1, 0, 1];
    foreach (x; samples)
        foreach (y; samples)
            rows ~= ToPointFRow(QPoint(x, y), QPointF(x, y));
    return rows;
}

// toPointF
unittest
{
    foreach (i, r; toPointF_data())
    {
        QPointF got = r.input.toPointF();
        assert(got.x() == r.result.x() && got.y() == r.result.y(),
            "toPointF row " ~ i.to!string);
    }
}

// transposed
unittest
{
    assert((QPoint(1, 2).transposed() == QPoint(2, 1)));
}

// rx
unittest
{
    QPoint originalPoint = QPoint(-1, 0);
    QPoint point = originalPoint;
    ++point.rx();
    assert(point.x() == originalPoint.x() + 1);
}

// ry
unittest
{
    QPoint originalPoint = QPoint(0, -1);
    QPoint point = originalPoint;
    ++point.ry();
    assert(point.y() == originalPoint.y() + 1);
}

private struct PointPairRow
{
    QPoint point1, point2, expected;
}
private PointPairRow[] operator_add_data()
{
    return [
        // (0, 0) + (0, 0)
        PointPairRow(QPoint(0, 0), QPoint(0, 0), QPoint(0, 0)),
        // (0, 9) + (1, 0)
        PointPairRow(QPoint(0, 9), QPoint(1, 0), QPoint(1, 9)),
        // (INT_MIN, 0) + (1, 0)
        PointPairRow(QPoint(int.min, 0), QPoint(1, 0), QPoint(int.min + 1, 0)),
        // (INT_MAX, 0) + (-1, 0)
        PointPairRow(QPoint(int.max, 0), QPoint(-1, 0), QPoint(int.max - 1, 0)),
    ];
}

// operator_add
unittest
{
    foreach (i, r; operator_add_data())
    {
        string ctx = "operator_add row " ~ i.to!string;
        assert((r.point1 + r.point2 == r.expected), ctx);
        QPoint point1 = r.point1;
        point1 += r.point2;
        assert((point1 == r.expected), ctx);
    }
}

private PointPairRow[] operator_subtract_data()
{
    return [
        // (0, 0) - (0, 0)
        PointPairRow(QPoint(0, 0), QPoint(0, 0), QPoint(0, 0)),
        // (0, 9) - (1, 0)
        PointPairRow(QPoint(0, 9), QPoint(1, 0), QPoint(-1, 9)),
        // (INT_MAX, 0) - (1, 0)
        PointPairRow(QPoint(int.max, 0), QPoint(1, 0), QPoint(int.max - 1, 0)),
        // (INT_MIN, 0) - (-1, 0)
        PointPairRow(QPoint(int.min, 0), QPoint(-1, 0), QPoint(int.min - -1, 0)),
    ];
}

// operator_subtract
unittest
{
    foreach (i, r; operator_subtract_data())
    {
        string ctx = "operator_subtract row " ~ i.to!string;
        assert((r.point1 - r.point2 == r.expected), ctx);
        QPoint point1 = r.point1;
        point1 -= r.point2;
        assert((point1 == r.expected), ctx);
    }
}

private enum MulKind { Int, Float, Double }
private struct MulRow
{
    QPoint point;
    double factor;
    MulKind kind;
    QPoint expected;
}
private MulRow[] operator_multiply_data()
{
    return [
        // (0, 0) * 0.0
        MulRow(QPoint(0, 0), 0.0, MulKind.Double, QPoint(0, 0)),
        // (INT_MIN, 1) * 0.5
        MulRow(QPoint(int.min, 1), 0.5, MulKind.Double, QPoint(qRound(int.min * 0.5), 1)),
        // (INT_MAX, 2) * 0.5
        MulRow(QPoint(int.max, 2), 0.5, MulKind.Double, QPoint(qRound(int.max * 0.5), 1)),

        // (0, 0) * 0
        MulRow(QPoint(0, 0), 0.0, MulKind.Int, QPoint(0, 0)),
        // (INT_MIN + 1, 0) * -1
        MulRow(QPoint(int.min + 1, 0), -1.0, MulKind.Int, QPoint((int.min + 1) * -1, 0)),
        // (INT_MAX, 0) * -1
        MulRow(QPoint(int.max, 0), -1.0, MulKind.Int, QPoint(int.max * -1, 0)),

        // (0, 0) * 0.0f
        MulRow(QPoint(0, 0), 0.0, MulKind.Float, QPoint(0, 0)),
        // (INT_MIN, 0) * -0.5f
        MulRow(QPoint(int.min, 0), -0.5, MulKind.Float, QPoint(qRound(cast(float) int.min * -0.5f), 0)),
    ];
}

// operator_multiply
unittest
{
    foreach (i, r; operator_multiply_data())
    {
        string ctx = "operator_multiply row " ~ i.to!string;
        final switch (r.kind)
        {
            case MulKind.Int:
            {
                int f = cast(int) r.factor;
                assert((r.point * f == r.expected), ctx);
                assert((f * r.point == r.expected), ctx);
                QPoint point = r.point;
                point *= f;
                assert((point == r.expected), ctx);
                break;
            }
            case MulKind.Float:
            {
                float f = cast(float) r.factor;
                assert((r.point * f == r.expected), ctx);
                assert((f * r.point == r.expected), ctx);
                QPoint point = r.point;
                point *= f;
                assert((point == r.expected), ctx);
                break;
            }
            case MulKind.Double:
            {
                double f = r.factor;
                assert((r.point * f == r.expected), ctx);
                assert((f * r.point == r.expected), ctx);
                QPoint point = r.point;
                point *= f;
                assert((point == r.expected), ctx);
                break;
            }
        }
    }
}

private struct DivRow
{
    QPoint point;
    qreal divisor;
    QPoint expected;
}
private DivRow[] operator_divide_data()
{
    return [
        // (0, 0) / 1
        DivRow(QPoint(0, 0), 1, QPoint(0, 0)),
        // (0, 9) / 2
        DivRow(QPoint(0, 9), 2, QPoint(0, 5)),
        // (INT_MAX, 0) / 2
        DivRow(QPoint(int.max, 0), 2, QPoint(qRound(int.max / 2.0), 0)),
        // (INT_MIN, 0) / -1.5
        DivRow(QPoint(int.min, 0), -1.5, QPoint(qRound(int.min / -1.5), 0)),
    ];
}

// operator_divide
unittest
{
    foreach (i, r; operator_divide_data())
    {
        string ctx = "operator_divide row " ~ i.to!string;
        assert((r.point / r.divisor == r.expected), ctx);
        QPoint point = r.point;
        point /= r.divisor;
        assert((point == r.expected), ctx);
    }
}

private struct DotRow
{
    QPoint point1, point2;
    int expected;
}
private DotRow[] dotProduct_data()
{
    return [
        // (0, 0) dot (0, 0)
        DotRow(QPoint(0, 0), QPoint(0, 0), 0),
        // (10, 0) dot (0, 10)
        DotRow(QPoint(10, 0), QPoint(0, 10), 0),
        // (0, 10) dot (10, 0)
        DotRow(QPoint(0, 10), QPoint(10, 0), 0),
        // (10, 20) dot (-10, -20)
        DotRow(QPoint(10, 20), QPoint(-10, -20), -500),
        // (-10, -20) dot (10, 20)
        DotRow(QPoint(-10, -20), QPoint(10, 20), -500),
    ];
}

// dotProduct
unittest
{
    foreach (i, r; dotProduct_data())
    {
        assert(QPoint.dotProduct(r.point1, r.point2) == r.expected,
            "dotProduct row " ~ i.to!string);
    }
}

private struct UnaryRow
{
    QPoint point, expected;
}
private UnaryRow[] operator_unary_minus_data()
{
    return [
        // -(0, 0)
        UnaryRow(QPoint(0, 0), QPoint(0, 0)),
        // -(-1, 0)
        UnaryRow(QPoint(-1, 0), QPoint(1, 0)),
        // -(0, -1)
        UnaryRow(QPoint(0, -1), QPoint(0, 1)),
        // -(-INT_MAX, INT_MAX)
        UnaryRow(QPoint(-int.max, int.max), QPoint(int.max, -int.max)),
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

private struct PointEqRow
{
    QPoint point1, point2;
    bool equal;
}
private PointEqRow[] operator_eq_data()
{
    return [
        // (0, 0) == (0, 0)
        PointEqRow(QPoint(0, 0), QPoint(0, 0), true),
        // (-1, 0) == (-1, 0)
        PointEqRow(QPoint(-1, 0), QPoint(-1, 0), true),
        // (-1, 0) != (0, 0)
        PointEqRow(QPoint(-1, 0), QPoint(0, 0), false),
        // (-1, 0) != (0, -1)
        PointEqRow(QPoint(-1, 0), QPoint(0, -1), false),
        // (1, 99999) != (-1, 99999)
        PointEqRow(QPoint(1, 99_999), QPoint(-1, 99_999), false),
        // (INT_MIN, INT_MIN) == (INT_MIN, INT_MIN)
        PointEqRow(QPoint(int.min, int.min), QPoint(int.min, int.min), true),
        // (INT_MAX, INT_MAX) == (INT_MAX, INT_MAX)
        PointEqRow(QPoint(int.max, int.max), QPoint(int.max, int.max), true),
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
        // BINDING GAP: qHash(QPoint) is not bound; the source's qHash check is
        // recorded rather than run.
        // if (r.equal)
        //     assert(qHash(r.point1) == qHash(r.point2));
    }
}

// stream
unittest
{
    // BINDING GAP: QDataStream operator<< / operator>> for QPoint are not bound.
    // The ported test is recorded below instead of being run.
    //
    // private QPoint[] stream_data()
    // {
    //     return [
    //         QPoint(0, 0),
    //         QPoint(-1, 1),
    //         QPoint(1, -1),
    //         QPoint(int.min, int.max),
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
    //     QDataStream insertionStreamRef = stream.writePoint(point); // stream << point;
    //     assert(&insertionStreamRef == &stream, ctx);
    //
    //     tmp.seek(0);
    //     QPoint pointFromStream = QPoint.init;
    //     QDataStream extractionStreamRef = stream.readPoint(pointFromStream); // stream >> pointFromStream;
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
    //     QPoint p = QPoint(1, 2);
    //     // auto [x, y] = p;  // C++ structured binding, no D equivalent
    //     auto x = p.x();
    //     auto y = p.y();
    //     assert(x == 1);
    //     assert(y == 2);
    //
    //     p.setX(42);
    //     assert(x == 1);
    //     assert(y == 2);
    //
    //     p.setY(-123);
    //     assert(x == 1);
    //     assert(y == 2);
    // }
    // {
    //     QPoint p = QPoint(1, 2);
    //     // auto &[x, y] = p;
    //     ref int x = p.rx();
    //     ref int y = p.ry();
    //     assert(x == 1);
    //     assert(y == 2);
    //
    //     x = 42;
    //     assert(x == 42);
    //     assert(p.x() == 42);
    //     assert(p.rx() == 42);
    //     assert(y == 2);
    //     assert(p.y() == 2);
    //     assert(p.ry() == 2);
    //
    //     y = -123;
    //     assert(x == 42);
    //     assert(p.x() == 42);
    //     assert(p.rx() == 42);
    //     assert(y == -123);
    //     assert(p.y() == -123);
    //     assert(p.ry() == -123);
    //
    //     p.setX(0);
    //     assert(x == 0);
    //     assert(p.x() == 0);
    //     assert(p.rx() == 0);
    //     assert(y == -123);
    //     assert(p.y() == -123);
    //     assert(p.ry() == -123);
    //
    //     p.ry() = 10;
    //     assert(x == 0);
    //     assert(p.x() == 0);
    //     assert(p.rx() == 0);
    //     assert(y == 10);
    //     assert(p.y() == 10);
    //     assert(p.ry() == 10);
    // }
}
