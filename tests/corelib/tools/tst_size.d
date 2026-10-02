// QT_MODULES: core
module corelib.tools.tst_size;

import qt.core.size;
import qt.core.margins;
import qt.core.namespace;
import qt.core.global;
import std.stdio : writeln;
import std.conv : to;

/*
 * Port of qtbase/tests/auto/corelib/tools/qsize/tst_qsize.cpp.
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

// getSetCheck
unittest
{
    QSize obj1 = QSize.init;
    obj1.setWidth(0);
    assert(obj1.width() == 0);
    obj1.setWidth(int.min);
    assert(obj1.width() == int.min);
    obj1.setWidth(int.max);
    assert(obj1.width() == int.max);

    obj1.setHeight(0);
    assert(obj1.height() == 0);
    obj1.setHeight(int.min);
    assert(obj1.height() == int.min);
    obj1.setHeight(int.max);
    assert(obj1.height() == int.max);

    QSizeF obj2 = QSizeF(0.0, 0.0);
    obj2.setWidth(0.0);
    assert(obj2.width() == 0.0);
    obj2.setWidth(1.1);
    assert(obj2.width() == 1.1);

    obj2.setHeight(0.0);
    assert(obj2.height() == 0.0);
    obj2.setHeight(1.1);
    assert(obj2.height() == 1.1);
}

// scale
unittest
{
    QSize t1 = QSize(10, 12);
    t1.scale(60, 60, AspectRatioMode.IgnoreAspectRatio);
    assert((t1 == QSize(60, 60)));

    QSize t2 = QSize(10, 12);
    t2.scale(60, 60, AspectRatioMode.KeepAspectRatio);
    assert((t2 == QSize(50, 60)));

    QSize t3 = QSize(10, 12);
    t3.scale(60, 60, AspectRatioMode.KeepAspectRatioByExpanding);
    assert((t3 == QSize(60, 72)));

    QSize t4 = QSize(12, 10);
    t4.scale(60, 60, AspectRatioMode.KeepAspectRatio);
    assert((t4 == QSize(60, 50)));

    QSize t5 = QSize(12, 10);
    t5.scale(60, 60, AspectRatioMode.KeepAspectRatioByExpanding);
    assert((t5 == QSize(72, 60)));

    // test potential int overflow
    QSize t6 = QSize(88_473, 88_473);
    t6.scale(141_817, 141_817, AspectRatioMode.KeepAspectRatio);
    assert((t6 == QSize(141_817, 141_817)));

    QSize t7 = QSize(800, 600);
    t7.scale(400, int.max, AspectRatioMode.KeepAspectRatio);
    assert((t7 == QSize(400, 300)));

    QSize t8 = QSize(800, 600);
    t8.scale(int.max, 150, AspectRatioMode.KeepAspectRatio);
    assert((t8 == QSize(200, 150)));

    QSize t9 = QSize(600, 800);
    t9.scale(300, int.max, AspectRatioMode.KeepAspectRatio);
    assert((t9 == QSize(300, 400)));

    QSize t10 = QSize(600, 800);
    t10.scale(int.max, 200, AspectRatioMode.KeepAspectRatio);
    assert((t10 == QSize(150, 200)));

    QSize t11 = QSize(0, 0);
    t11.scale(240, 200, AspectRatioMode.IgnoreAspectRatio);
    assert((t11 == QSize(240, 200)));

    QSize t12 = QSize(0, 0);
    t12.scale(240, 200, AspectRatioMode.KeepAspectRatio);
    assert((t12 == QSize(240, 200)));

    QSize t13 = QSize(0, 0);
    t13.scale(240, 200, AspectRatioMode.KeepAspectRatioByExpanding);
    assert((t13 == QSize(240, 200)));
}

private struct SizePairRow
{
    QSize input1, input2, expected;
}
private SizePairRow[] expandedTo_data()
{
    return [
        SizePairRow(QSize(10, 12), QSize(6, 4), QSize(10, 12)),
        SizePairRow(QSize(0, 0), QSize(6, 4), QSize(6, 4)),
        // This should pick the highest of w,h components independently of each other,
        // thus the results don't have to be equal to neither input1 nor input2.
        SizePairRow(QSize(6, 4), QSize(4, 6), QSize(6, 6)),
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
        SizePairRow(QSize(10, 12), QSize(6, 4), QSize(6, 4)),
        SizePairRow(QSize(0, 0), QSize(6, 4), QSize(0, 0)),
        // This should pick the lowest of w,h components independently of each other,
        // thus the results don't have to be equal to neither input1 nor input2.
        SizePairRow(QSize(6, 4), QSize(4, 6), QSize(4, 4)),
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
    QSize input, grown, shrunk;
    QMargins margins;
}
private GrownShrunkRow[] grownOrShrunkBy_data()
{
    QSize zero = QSize(0, 0);
    QSize some = QSize(100, 200);
    QMargins zeroMargins = QMargins.init;
    QMargins negative = QMargins(-1, -2, -3, -4);
    QMargins positive = QMargins(1, 2, 3, 4);

    return [
        GrownShrunkRow(zero, zero, zero, zeroMargins),
        GrownShrunkRow(zero, QSize(-4, -6), QSize(4, 6), negative),
        GrownShrunkRow(zero, QSize(4, 6), QSize(-4, -6), positive),
        GrownShrunkRow(some, some, some, zeroMargins),
        GrownShrunkRow(some, QSize(96, 194), QSize(104, 206), negative),
        GrownShrunkRow(some, QSize(104, 206), QSize(96, 194), positive),
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

private struct ToSizeFRow
{
    QSize input;
    QSizeF result;
}
private ToSizeFRow[] toSizeF_data()
{
    ToSizeFRow[] rows;
    static immutable int[] samples = [-1, 0, 1];
    foreach (w; samples)
        foreach (h; samples)
            rows ~= ToSizeFRow(QSize(w, h), QSizeF(w, h));
    return rows;
}

// toSizeF
unittest
{
    foreach (i, r; toSizeF_data())
    {
        QSizeF got = r.input.toSizeF();
        assert(got.width() == r.result.width() && got.height() == r.result.height(),
            "toSizeF row " ~ i.to!string);
    }
}

private struct TransposeRow
{
    QSize input1, expected;
}
private TransposeRow[] transpose_data()
{
    return [
        TransposeRow(QSize(10, 12), QSize(12, 10)),
        TransposeRow(QSize(0, 0), QSize(0, 0)),
        TransposeRow(QSize(6, 4), QSize(4, 6)),
    ];
}

// transpose
unittest
{
    foreach (i, r; transpose_data())
    {
        QSize input1 = r.input1;
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
    //     QSize size = QSize(10, 20);
    //     // auto [width, height] = size;
    //     auto width = size.width();
    //     auto height = size.height();
    //     assert(width == 10);
    //     assert(height == 20);
    // }
    // {
    //     QSize size = QSize(30, 40);
    //     // auto &[width, height] = size;
    //     ref int width = size.rwidth();
    //     ref int height = size.rheight();
    //     assert(width == 30);
    //     assert(height == 40);
    //
    //     width = 100;
    //     height = 200;
    //     assert(size.width() == 100);
    //     assert(size.height() == 200);
    // }
}
