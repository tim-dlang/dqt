// QT_MODULES: core
module corelib.tools.tst_line_x;

import qt.core.line;
import qt.core.point;
import qt.core.global;

/*
 * Supplemental coverage for the `QLine`/`QLineF` bindings in
 * `qt/core/core/line.d`, covering members the mirrored `tst_line.d`
 * (upstream `tst_qline.cpp`) does not exercise.
 *
 * These cases are D-only: there is no upstream `*_data` fixture to mirror, so
 * expectations are derived from the Qt semantics the binding implements.
 *
 * Exclusions (not bound): `QDebug` and `QDataStream` streaming operators for
 * `QLine`/`QLineF`.
 *
 * BINDING GAP (rvalue parameters): `QLine.translate`/`translated` and
 * `QLineF.translate`/`translated` take `ref const(QPoint)`/`ref const(QPointF)`,
 * which D cannot bind to rvalues; the temporaries are stored in locals below.
 */

// isNull
unittest
{
    assert(QLine(1, 2, 1, 2).isNull());
    assert(!QLine(1, 2, 3, 4).isNull());
}

// p1 / p2
unittest
{
    QLine l = QLine(1, 2, 3, 4);
    QPoint p1 = l.p1();
    QPoint p2 = l.p2();
    assert(p1 == QPoint(1, 2));
    assert(p2 == QPoint(3, 4));
}

// dx / dy
unittest
{
    QLine l = QLine(1, 2, 4, 6);
    assert(l.dx() == 3);
    assert(l.dy() == 4);
}

// translate
unittest
{
    QLine l = QLine(1, 2, 3, 4);
    QPoint delta = QPoint(10, 20);
    l.translate(delta);
    assert(l == QLine(11, 22, 13, 24));

    QLine l2 = QLine(1, 2, 3, 4);
    l2.translate(10, 20);
    assert(l2 == QLine(11, 22, 13, 24));
}

// translated
unittest
{
    QLine l = QLine(1, 2, 3, 4);
    QPoint delta = QPoint(10, 20);
    assert(l.translated(delta) == QLine(11, 22, 13, 24));
    assert(l.translated(10, 20) == QLine(11, 22, 13, 24));
    // the original is unchanged
    assert(l == QLine(1, 2, 3, 4));
}

// operator_eq
unittest
{
    assert(QLine(1, 2, 3, 4) == QLine(1, 2, 3, 4));
    assert(QLine(1, 2, 3, 4) != QLine(1, 2, 3, 5));
    assert(QLine(1, 2, 3, 4) != QLine(2, 2, 3, 4));
}

// constructor from two points
unittest
{
    QPoint p1 = QPoint(1, 2);
    QPoint p2 = QPoint(3, 4);
    assert(QLine(p1, p2) == QLine(1, 2, 3, 4));
}

// ---------------------------------------------------------------------------
// QLineF
// ---------------------------------------------------------------------------

// isNull
unittest
{
    assert(QLineF(1, 2, 1, 2).isNull());
    assert(!QLineF(1, 2, 3, 4).isNull());
}

// unitVector
unittest
{
    QLineF horizontal = QLineF(0, 0, 100, 0).unitVector();
    assert(qFuzzyCompare(horizontal.length(), 1.0));
    assert(qFuzzyCompare(horizontal.dx(), 1.0));
    assert(qFuzzyCompare(horizontal.dy(), 0.0));

    QLineF diagonal = QLineF(0, 0, 3, 4).unitVector();
    assert(qFuzzyCompare(diagonal.length(), 1.0));
    assert(qFuzzyCompare(diagonal.x1(), 0.0) && qFuzzyCompare(diagonal.y1(), 0.0));
    assert(qFuzzyCompare(diagonal.dx(), 0.6) && qFuzzyCompare(diagonal.dy(), 0.8));
}

// pointAt
unittest
{
    QLineF l = QLineF(0, 0, 10, 20);
    assert(l.pointAt(0.0) == QPointF(0, 0));
    assert(l.pointAt(0.5) == QPointF(5, 10));
    assert(l.pointAt(1.0) == QPointF(10, 20));
    assert(l.pointAt(-1.0) == QPointF(-10, -20));
}

// toLine
unittest
{
    QLineF l = QLineF(1.4, 2.6, -3.2, 4.8);
    assert(l.toLine() == QLine(1, 3, -3, 5));
}
