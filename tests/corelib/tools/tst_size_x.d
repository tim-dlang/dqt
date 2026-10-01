// QT_MODULES: core
module corelib.tools.tst_size_x;

import qt.core.size;
import qt.core.namespace;
import qt.core.global;

/*
 * Supplemental coverage for the `QSize`/`QSizeF` bindings in
 * `qt/core/core/size.d`.
 *
 * These cases are D-only: the upstream `tst_qsize.cpp`/`tst_qsizef.cpp` have no
 * operator cases and skip several predicates, so there is no `*_data` fixture
 * to mirror; expectations come from the Qt semantics the binding implements.
 *
 * Exclusions (not bound): `qHash(QSize)`; `QDebug` and `QDataStream`
 * streaming; Apple-only `fromCGSize`/`toCGSize`.
 *
 * BINDING GAP (rvalue parameters): `QSize.scaled(QSize, mode)`,
 * `QSizeF.scaled(QSizeF, mode)`, `QSizeF(const QSize)`, and the same-type
 * `opOpAssign` (`+=`/`-=`) take `ref const(QSize)`/`ref const(QSizeF)`, which D
 * cannot bind to rvalues; the arguments are stored in locals below.
 */

// ---------------------------------------------------------------------------
// QSize
// ---------------------------------------------------------------------------

// isNull
unittest
{
    assert(QSize(0, 0).isNull());
    assert(!QSize(1, 0).isNull());
    assert(!QSize(0, 1).isNull());
}

// isEmpty
unittest
{
    assert(QSize(0, 5).isEmpty());
    assert(QSize(-1, 5).isEmpty());
    assert(!QSize(1, 1).isEmpty());
}

// isValid
unittest
{
    assert(QSize(0, 0).isValid());
    assert(QSize(1, 1).isValid());
    assert(!QSize(-1, 1).isValid());
    assert(!QSize(1, -1).isValid());
}

// transposed
unittest
{
    assert(QSize(2, 3).transposed() == QSize(3, 2));
}

// scaled
unittest
{
    assert(QSize(10, 12).scaled(60, 60, AspectRatioMode.IgnoreAspectRatio) == QSize(60, 60));
    assert(QSize(10, 12).scaled(60, 60, AspectRatioMode.KeepAspectRatio) == QSize(50, 60));

    QSize target = QSize(60, 60);
    assert(QSize(10, 12).scaled(target, AspectRatioMode.KeepAspectRatio) == QSize(50, 60));
}

// rwidth / rheight
unittest
{
    QSize s = QSize(1, 2);
    s.rwidth() = 5;
    s.rheight() = 6;
    assert(s == QSize(5, 6));

    ++s.rwidth();
    assert(s.width() == 6);
}

// operator_eq
unittest
{
    assert(QSize(1, 2) == QSize(1, 2));
    assert(QSize(1, 2) != QSize(1, 3));
    assert(QSize(1, 2) != QSize(3, 2));
}

// operators
unittest
{
    assert(QSize(1, 2) + QSize(3, 4) == QSize(4, 6));
    assert(QSize(5, 6) - QSize(1, 2) == QSize(4, 4));
    assert(QSize(3, 4) * 2.0 == QSize(6, 8));
    assert(2.0 * QSize(3, 4) == QSize(6, 8));
    assert(QSize(6, 8) / 2.0 == QSize(3, 4));

    // scalar multiply/divide round with qRound
    assert(QSize(3, 5) * 0.5 == QSize(2, 3));

    QSize a = QSize(1, 2);
    QSize add = QSize(3, 4);
    a += add;
    assert(a == QSize(4, 6));
    QSize sub = QSize(1, 1);
    a -= sub;
    assert(a == QSize(3, 5));
    a *= 2.0;
    assert(a == QSize(6, 10));
    a /= 2.0;
    assert(a == QSize(3, 5));
    a *= 2;
    assert(a == QSize(6, 10));
}

// ---------------------------------------------------------------------------
// QSizeF
// ---------------------------------------------------------------------------

// constructor from QSize
unittest
{
    QSize s = QSize(3, 4);
    QSizeF f = QSizeF(s);
    assert(f.width() == 3.0 && f.height() == 4.0);
    assert(f == QSizeF(3, 4));
}

// setWidth / setHeight
unittest
{
    QSizeF f = QSizeF(0, 0);
    f.setWidth(1.5);
    f.setHeight(2.5);
    assert(f.width() == 1.5 && f.height() == 2.5);
}

// isEmpty
unittest
{
    assert(QSizeF(0, 5).isEmpty());
    assert(QSizeF(-0.5, 5).isEmpty());
    assert(!QSizeF(0.5, 0.5).isEmpty());
}

// isValid
unittest
{
    assert(QSizeF(0, 0).isValid());
    assert(QSizeF(0.5, 0.5).isValid());
    assert(!QSizeF(-0.5, 1).isValid());
    assert(!QSizeF(1, -0.5).isValid());
}

// transposed
unittest
{
    assert(QSizeF(2.5, 3.5).transposed() == QSizeF(3.5, 2.5));
}

// scaled
unittest
{
    assert(QSizeF(10, 12).scaled(60, 60, AspectRatioMode.KeepAspectRatio) == QSizeF(50, 60));

    QSizeF target = QSizeF(60, 60);
    assert(QSizeF(10, 12).scaled(target, AspectRatioMode.KeepAspectRatio) == QSizeF(50, 60));
}

// rwidth / rheight
unittest
{
    QSizeF f = QSizeF(1, 2);
    f.rwidth() = 5.5;
    f.rheight() = 6.5;
    assert(f == QSizeF(5.5, 6.5));
}

// toSize
unittest
{
    assert(QSizeF(1.4, 2.6).toSize() == QSize(1, 3));
    assert(QSizeF(-1.4, -2.6).toSize() == QSize(-1, -3));
}

// operator_eq
unittest
{
    assert(QSizeF(1, 2) == QSizeF(1, 2));
    assert(QSizeF(1, 2) != QSizeF(1, 2.5));
}

// operators
unittest
{
    assert(QSizeF(1, 2) + QSizeF(3, 4) == QSizeF(4, 6));
    assert(QSizeF(5, 6) - QSizeF(1, 2) == QSizeF(4, 4));
    assert(QSizeF(3, 4) * 0.5 == QSizeF(1.5, 2));
    assert(0.5 * QSizeF(3, 4) == QSizeF(1.5, 2));
    assert(QSizeF(3, 4) / 2.0 == QSizeF(1.5, 2));

    QSizeF a = QSizeF(1, 2);
    QSizeF add = QSizeF(3, 4);
    a += add;
    assert(a == QSizeF(4, 6));
    QSizeF sub = QSizeF(1, 1);
    a -= sub;
    assert(a == QSizeF(3, 5));
    a *= 2.0;
    assert(a == QSizeF(6, 10));
    a /= 2.0;
    assert(a == QSizeF(3, 5));
}
