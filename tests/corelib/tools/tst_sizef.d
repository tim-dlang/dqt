// QT_MODULES: core
module corelib.tools.tst_sizef;

import qt.core.size;
import qt.core.margins;
import qt.core.namespace;
import qt.core.global;
import std.stdio : writeln;
import std.conv : to;

/*
 * Port of qtbase/tests/auto/corelib/tools/qsizef/tst_qsizef.cpp.
 *
 * Conventions (same as tst_date.d):
 *   - each C++ `*_data` fixture is a separate D function placed immediately
 *     before the test that uses it;
 *   - functionality whose D binding is missing is emitted as commented-out code
 *     with a `// BINDING GAP:` note.
 *
 * BINDING GAP: `structuredBinding` exercises C++ structured bindings
 * (`auto [width, height] = size`), a C++-only construct with no D equivalent
 * here; it is recorded below instead of being run.
 *
 * BINDING GAP (rvalue parameters): these bound methods take `ref const(T)`
 * parameters, which D cannot bind to rvalue temporaries (C++ const references
 * accept them), so a temporary must be stored in a local first:
 *   - `QSize.opOpAssign`, `QSize.scale` (`ref const(QSize)`)
 *   - `QSizeF.opOpAssign`, `QSizeF.scale` (`ref const(QSizeF)`)
 *   - `QSizeF(this)` from `QSize` (`ref const(QSize)`)
 */

// ---------------------------------------------------------------------------
// Fixtures and tests
// ---------------------------------------------------------------------------

private struct IsNullRow
{
    double width, height;
    bool isNull_;
}
private IsNullRow[] isNull_data()
{
    return [
        IsNullRow(0.0, 0.0, true),
        IsNullRow(-0.0, -0.0, true),
        IsNullRow(0.0, -0.0, true),
        IsNullRow(-0.0, 0.0, true),
        IsNullRow(-0.1, 0.0, false),
        IsNullRow(0.0, -0.1, false),
        IsNullRow(0.1, 0.0, false),
        IsNullRow(0.0, 0.1, false),
    ];
}

// isNull
unittest
{
    foreach (i, r; isNull_data())
    {
        string ctx = "isNull row " ~ i.to!string;
        QSizeF size = QSizeF(r.width, r.height);
        assert(size.width() == r.width, ctx);
        assert(size.height() == r.height, ctx);
        assert(size.isNull() == r.isNull_, ctx);
    }
}

// scale
unittest
{
    QSizeF t1 = QSizeF(10.4, 12.8);
    t1.scale(60.6, 60.6, AspectRatioMode.IgnoreAspectRatio);
    assert((t1 == QSizeF(60.6, 60.6)));

    QSizeF t2 = QSizeF(10.4, 12.8);
    t2.scale(43.52, 43.52, AspectRatioMode.KeepAspectRatio);
    assert((t2 == QSizeF(35.36, 43.52)));

    QSizeF t3 = QSizeF(9.6, 12.48);
    t3.scale(31.68, 31.68, AspectRatioMode.KeepAspectRatioByExpanding);
    assert((t3 == QSizeF(31.68, 41.184)));

    QSizeF t4 = QSizeF(12.8, 10.4);
    t4.scale(43.52, 43.52, AspectRatioMode.KeepAspectRatio);
    assert((t4 == QSizeF(43.52, 35.36)));

    QSizeF t5 = QSizeF(12.48, 9.6);
    t5.scale(31.68, 31.68, AspectRatioMode.KeepAspectRatioByExpanding);
    assert((t5 == QSizeF(41.184, 31.68)));

    QSizeF t6 = QSizeF(0.0, 0.0);
    t6.scale(200, 240, AspectRatioMode.IgnoreAspectRatio);
    assert((t6 == QSizeF(200, 240)));

    QSizeF t7 = QSizeF(0.0, 0.0);
    t7.scale(200, 240, AspectRatioMode.KeepAspectRatio);
    assert((t7 == QSizeF(200, 240)));

    QSizeF t8 = QSizeF(0.0, 0.0);
    t8.scale(200, 240, AspectRatioMode.KeepAspectRatioByExpanding);
    assert((t8 == QSizeF(200, 240)));
}

private struct SizePairRow
{
    QSizeF input1, input2, expected;
}
private SizePairRow[] expandedTo_data()
{
    return [
        SizePairRow(QSizeF(10.4, 12.8), QSizeF(6.6, 4.4), QSizeF(10.4, 12.8)),
        SizePairRow(QSizeF(0.0, 0.0), QSizeF(6.6, 4.4), QSizeF(6.6, 4.4)),
        // This should pick the highest of w,h components independently of each other,
        // thus the result don't have to be equal to neither input1 nor input2.
        SizePairRow(QSizeF(6.6, 4.4), QSizeF(4.4, 6.6), QSizeF(6.6, 6.6)),
    ];
}

// expandedTo
unittest
{
    foreach (i, r; expandedTo_data())
    {
        assert((r.input1.expandedTo(r.input2) == r.expected),
            "expandedTo row " ~ i.to!string);
    }
}

private SizePairRow[] boundedTo_data()
{
    return [
        SizePairRow(QSizeF(10.4, 12.8), QSizeF(6.6, 4.4), QSizeF(6.6, 4.4)),
        SizePairRow(QSizeF(0.0, 0.0), QSizeF(6.6, 4.4), QSizeF(0.0, 0.0)),
        // This should pick the lowest of w,h components independently of each other,
        // thus the result don't have to be equal to neither input1 nor input2.
        SizePairRow(QSizeF(6.6, 4.4), QSizeF(4.4, 6.6), QSizeF(4.4, 4.4)),
    ];
}

// boundedTo
unittest
{
    foreach (i, r; boundedTo_data())
    {
        assert((r.input1.boundedTo(r.input2) == r.expected),
            "boundedTo row " ~ i.to!string);
    }
}

private struct GrownShrunkRow
{
    QSizeF input, grown, shrunk;
    QMarginsF margins;
}
private GrownShrunkRow[] grownOrShrunkBy_data()
{
    QSizeF zero = QSizeF(0, 0);
    QSizeF some = QSizeF(100, 200);
    QMarginsF zeroMargins = QMarginsF.init;
    QMarginsF negative = QMarginsF(-1, -2, -3, -4);
    QMarginsF positive = QMarginsF(1, 2, 3, 4);

    return [
        GrownShrunkRow(zero, zero, zero, zeroMargins),
        GrownShrunkRow(zero, QSizeF(-4, -6), QSizeF(4, 6), negative),
        GrownShrunkRow(zero, QSizeF(4, 6), QSizeF(-4, -6), positive),
        GrownShrunkRow(some, some, some, zeroMargins),
        GrownShrunkRow(some, QSizeF(96, 194), QSizeF(104, 206), negative),
        GrownShrunkRow(some, QSizeF(104, 206), QSizeF(96, 194), positive),
    ];
}

// grownOrShrunkBy
unittest
{
    foreach (i, r; grownOrShrunkBy_data())
    {
        string ctx = "grownOrShrunkBy row " ~ i.to!string;
        assert((r.input.grownBy(r.margins) == r.grown), ctx);
        assert((r.input.shrunkBy(r.margins) == r.shrunk), ctx);
        assert((r.grown.shrunkBy(r.margins) == r.input), ctx);
        assert((r.shrunk.grownBy(r.margins) == r.input), ctx);
    }
}

private struct TransposeRow
{
    QSizeF input1, expected;
}
private TransposeRow[] transpose_data()
{
    return [
        TransposeRow(QSizeF(10.4, 12.8), QSizeF(12.8, 10.4)),
        TransposeRow(QSizeF(0.0, 0.0), QSizeF(0.0, 0.0)),
        TransposeRow(QSizeF(6.6, 4.4), QSizeF(4.4, 6.6)),
    ];
}

// transpose
unittest
{
    foreach (i, r; transpose_data())
    {
        QSizeF input1 = r.input1;
        // transpose() works only inplace and returns nothing.
        input1.transpose();
        assert((input1 == r.expected), "transpose row " ~ i.to!string);
    }
}

// structuredBinding
unittest
{
    // BINDING GAP: C++ structured bindings (`auto [width, height] = size`) have
    // no D equivalent. The ported test is recorded below instead of being run.
    //
    // {
    //     QSizeF size = QSizeF(10.0, 20.0);
    //     // auto [width, height] = size;
    //     auto width = size.width();
    //     auto height = size.height();
    //     assert(width == 10.0);
    //     assert(height == 20.0);
    // }
    // {
    //     QSizeF size = QSizeF(30.0, 40.0);
    //     // auto &[width, height] = size;
    //     ref qreal width = size.rwidth();
    //     ref qreal height = size.rheight();
    //     assert(width == 30.0);
    //     assert(height == 40.0);
    //
    //     width = 100.0;
    //     height = 200.0;
    //     assert(size.width() == 100.0);
    //     assert(size.height() == 200.0);
    // }
}
