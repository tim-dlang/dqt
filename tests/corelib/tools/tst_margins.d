// QT_MODULES: core
module corelib.tools.tst_margins;

import qt.core.margins;
import qt.core.global;
import std.stdio : writeln;
import std.conv : to;

/*
 * Port of qtbase/tests/auto/corelib/tools/qmargins/tst_qmargins.cpp.
 *
 * Conventions (same as tst_date.d):
 *   - each C++ `*_data` fixture is a separate D function placed immediately
 *     before the test that uses it;
 *   - functionality whose D binding is missing is emitted as commented-out code
 *     with a `// BINDING GAP:` note.
 *
 * BINDING GAP: the `QDebug` and `QDataStream` operators for the margins types
 * are not bound, so `debugStreamCheck`/`debugStreamCheckF` and
 * `dataStreamCheck`/`dataStreamCheckF` are recorded.
 *
 * BINDING GAP: `structuredBinding` exercises C++ structured bindings
 * (`auto [left, top, right, bottom] = m`), a C++-only construct; it is recorded.
 *
 * BINDING GAP (rvalue parameters): `QMarginsF(this)` from `QMargins` takes a
 * `ref const(QMargins)` parameter, which D cannot bind to an rvalue (C++ const
 * references accept them), so a temporary must be stored in a local first.
 */

// ---------------------------------------------------------------------------
// Fixtures and tests
// ---------------------------------------------------------------------------

// getSetCheck
unittest
{
    QMargins margins = QMargins.init;
    margins.setLeft(0);
    assert(margins.left() == 0);
    margins.setTop(int.min);
    assert(margins.top() == int.min);
    margins.setBottom(int.max);
    assert(margins.bottom() == int.max);
    margins.setRight(int.max);
    assert(margins.right() == int.max);

    margins = QMargins.init;
    assert(margins.isNull());
    margins.setLeft(5);
    margins.setRight(5);
    assert(!margins.isNull());
    assert((margins == QMargins(5, 0, 5, 0)));
}

// operators
unittest
{
    const QMargins m1 = QMargins(12, 14, 16, 18);
    const QMargins m2 = QMargins(2, 3, 4, 5);

    const QMargins added = m1 + m2;
    assert(added == QMargins(14, 17, 20, 23));
    QMargins a = m1;
    a += m2;
    assert(a == added);

    const QMargins subtracted = m1 - m2;
    assert(subtracted == QMargins(10, 11, 12, 13));
    a = m1;
    a -= m2;
    assert(a == subtracted);

    QMargins h = m1;
    h += 2;
    assert(h == QMargins(14, 16, 18, 20));
    h -= 2;
    assert(h == m1);

    const QMargins doubled = m1 * 2;
    assert(doubled == QMargins(24, 28, 32, 36));
    assert(2 * m1 == doubled);
    assert(qreal(2) * m1 == doubled);
    assert(m1 * qreal(2) == doubled);

    a = m1;
    a *= 2;
    assert(a == doubled);
    a = m1;
    a *= qreal(2);
    assert(a == doubled);

    const QMargins halved = m1 / 2;
    assert(halved == QMargins(6, 7, 8, 9));

    a = m1;
    a /= 2;
    assert(a == halved);
    a = m1;
    a /= qreal(2);
    assert(a == halved);

    assert(m1 + (-m1) == QMargins.init);

    QMargins m3 = QMargins(10, 11, 12, 13);
    assert(m3 + 1 == QMargins(11, 12, 13, 14));
    assert(1 + m3 == QMargins(11, 12, 13, 14));
    assert(m3 - 1 == QMargins(9, 10, 11, 12));
    assert(+m3 == QMargins(10, 11, 12, 13));
    assert(-m3 == QMargins(-10, -11, -12, -13));
}

// debugStreamCheck
unittest
{
    // BINDING GAP: QDebug operator<< for QMargins is not bound. The ported test
    // is recorded below instead of being run.
    //
    // QMargins m = QMargins(10, 11, 12, 13);
    // QString expected = QString("QMargins(10, 11, 12, 13)");
    // QString result;
    // QDebug(&result).nospace() << m;
    // assert(result == expected);
}

// dataStreamCheck
unittest
{
    // BINDING GAP: QDataStream operator<< / operator>> for QMargins are not
    // bound. The ported test is recorded below instead of being run.
    //
    // QByteArray buffer;
    //
    // // stream out
    // {
    //     QMargins marginsOut = QMargins(0, int.min, int.max, 6852);
    //     QDataStream streamOut = QDataStream(&buffer, QIODevice.OpenModeFlag.WriteOnly);
    //     streamOut.writeMarging(marginsOut); // streamOut << marginsOut;
    // }
    //
    // // stream in & compare
    // {
    //     QMargins marginsIn = QMargins.init;
    //     QDataStream streamIn = QDataStream(&buffer, QIODevice.OpenModeFlag.ReadOnly);
    //     streamIn.readMargins(marginsIn); // streamIn >> marginsIn;
    //
    //     assert(marginsIn.left() == 0);
    //     assert(marginsIn.top() == int.min);
    //     assert(marginsIn.right() == int.max);
    //     assert(marginsIn.bottom() == 6852);
    // }
}

// getSetCheckF
unittest
{
    QMarginsF margins = QMarginsF.init;
    margins.setLeft(1.1);
    assert(qFuzzyCompare(margins.left(), 1.1));
    margins.setTop(2.2);
    assert(qFuzzyCompare(margins.top(), 2.2));
    margins.setBottom(3.3);
    assert(qFuzzyCompare(margins.bottom(), 3.3));
    margins.setRight(4.4);
    assert(qFuzzyCompare(margins.right(), 4.4));

    margins = QMarginsF.init;
    assert(margins.isNull());
    margins.setLeft(5.5);
    margins.setRight(5.5);
    assert(!margins.isNull());
    assert((margins == QMarginsF(5.5, 0.0, 5.5, 0.0)));
}

// operatorsF
unittest
{
    const QMarginsF m1 = QMarginsF(12.1, 14.1, 16.1, 18.1);
    const QMarginsF m2 = QMarginsF(2.1, 3.1, 4.1, 5.1);

    const QMarginsF added = m1 + m2;
    assert(added == QMarginsF(14.2, 17.2, 20.2, 23.2));
    QMarginsF a = m1;
    a += m2;
    assert(a == added);

    const QMarginsF subtracted = m1 - m2;
    assert(subtracted == QMarginsF(10.0, 11.0, 12.0, 13.0));
    a = m1;
    a -= m2;
    assert(a == subtracted);

    QMarginsF h = m1;
    h += 2.1;
    assert(h == QMarginsF(14.2, 16.2, 18.2, 20.2));
    h -= 2.1;
    assert(h == m1);

    const QMarginsF doubled = m1 * 2.0;
    assert(doubled == QMarginsF(24.2, 28.2, 32.2, 36.2));
    assert(2.0 * m1 == doubled);
    assert(m1 * 2.0 == doubled);

    a = m1;
    a *= 2.0;
    assert(a == doubled);

    const QMarginsF halved = m1 / 2.0;
    assert(halved == QMarginsF(6.05, 7.05, 8.05, 9.05));

    a = m1;
    a /= 2.0;
    assert(a == halved);

    assert(m1 + (-m1) == QMarginsF.init);

    QMarginsF m3 = QMarginsF(10.3, 11.4, 12.5, 13.6);
    assert(m3 + 1.1 == QMarginsF(11.4, 12.5, 13.6, 14.7));
    assert(1.1 + m3 == QMarginsF(11.4, 12.5, 13.6, 14.7));
    assert(m3 - 1.1 == QMarginsF(9.2, 10.3, 11.4, 12.5));
    assert(+m3 == QMarginsF(10.3, 11.4, 12.5, 13.6));
    assert(-m3 == QMarginsF(-10.3, -11.4, -12.5, -13.6));
}

// dataStreamCheckF
unittest
{
    // BINDING GAP: QDataStream operator<< / operator>> for QMarginsF are not
    // bound. The ported test is recorded below instead of being run.
    //
    // QByteArray buffer;
    //
    // // stream out
    // {
    //     QMarginsF marginsOut = QMarginsF(1.1, 2.2, 3.3, 4.4);
    //     QDataStream streamOut = QDataStream(&buffer, QIODevice.OpenModeFlag.WriteOnly);
    //     streamOut.writeMarginsF(marginsOut); // streamOut << marginsOut;
    // }
    //
    // // stream in & compare
    // {
    //     QMarginsF marginsIn = QMarginsF.init;
    //     QDataStream streamIn = QDataStream(&buffer, QIODevice.OpenModeFlag.ReadOnly);
    //     streamOut.readMarginsF(marginsOut); // streamIn >> marginsIn;
    //
    //     assert(marginsIn.left() == 1.1);
    //     assert(marginsIn.top() == 2.2);
    //     assert(marginsIn.right() == 3.3);
    //     assert(marginsIn.bottom() == 4.4);
    // }
}

// debugStreamCheckF
unittest
{
    // BINDING GAP: QDebug operator<< for QMarginsF is not bound. The ported test
    // is recorded below instead of being run.
    //
    // QMarginsF m = QMarginsF(10.1, 11.2, 12.3, 13.4);
    // QString expected = QString("QMarginsF(10.1, 11.2, 12.3, 13.4)");
    // QString result;
    // QDebug(&result).nospace() << m;
    // assert(result == expected);
}

// structuredBinding
unittest
{
    // BINDING GAP: C++ structured bindings (`auto [left, top, right, bottom] = m`)
    // have no D equivalent. The ported test is recorded below instead of being
    // run.
    //
    // {
    //     QMargins m = QMargins(1, 2, 3, 4);
    //     auto left = m.left();
    //     auto top = m.top();
    //     auto right = m.right();
    //     auto bottom = m.bottom();
    //     assert(left == 1);
    //     assert(top == 2);
    //     assert(right == 3);
    //     assert(bottom == 4);
    // }
    // {
    //     QMargins m = QMargins(1, 2, 3, 4);
    //     ref int left = m.rleft();
    //     ref int top = m.rtop();
    //     ref int right = m.rright();
    //     ref int bottom = m.rbottom();
    //     assert(left == 1);
    //     assert(top == 2);
    //     assert(right == 3);
    //     assert(bottom == 4);
    //
    //     left = 10;
    //     top = 20;
    //     right = 30;
    //     bottom = 40;
    //     assert(m.left() == 10);
    //     assert(m.top() == 20);
    //     assert(m.right() == 30);
    //     assert(m.bottom() == 40);
    // }
    // {
    //     QMarginsF m = QMarginsF(1.0, 2.0, 3.0, 4.0);
    //     auto left = m.left();
    //     auto top = m.top();
    //     auto right = m.right();
    //     auto bottom = m.bottom();
    //     assert(left == 1.0);
    //     assert(top == 2.0);
    //     assert(right == 3.0);
    //     assert(bottom == 4.0);
    // }
    // {
    //     QMarginsF m = QMarginsF(1.0, 2.0, 3.0, 4.0);
    //     ref qreal left = m.rleft();
    //     ref qreal top = m.rtop();
    //     ref qreal right = m.rright();
    //     ref qreal bottom = m.rbottom();
    //     assert(left == 1.0);
    //     assert(top == 2.0);
    //     assert(right == 3.0);
    //     assert(bottom == 4.0);
    //
    //     left = 10.0;
    //     top = 20.0;
    //     right = 30.0;
    //     bottom = 40.0;
    //     assert(m.left() == 10.0);
    //     assert(m.top() == 20.0);
    //     assert(m.right() == 30.0);
    //     assert(m.bottom() == 40.0);
    // }
}

private struct ToMarginsFRow
{
    QMargins input;
    QMarginsF result;
}
private ToMarginsFRow[] toMarginsF_data()
{
    ToMarginsFRow[] rows;
    static immutable int[] samples = [-1, 0, 1];
    foreach (x1; samples)
        foreach (y1; samples)
            foreach (x2; samples)
                foreach (y2; samples)
                    rows ~= ToMarginsFRow(QMargins(x1, y1, x2, y2), QMarginsF(x1, y1, x2, y2));
    return rows;
}

// toMarginsF
unittest
{
    foreach (i, r; toMarginsF_data())
    {
        assert((r.input.toMarginsF() == r.result), "toMarginsF row " ~ i.to!string);
    }
}
