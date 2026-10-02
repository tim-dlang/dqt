// QT_MODULES: core
module corelib.tools.tst_point_x;

import qt.core.point;
import qt.core.global;

/*
 * Supplemental coverage for the `QPoint`/`QPointF` bindings in
 * `qt/core/core/point.d`, covering members the mirrored
 * `tst_point.d`/`tst_pointf.d` (upstream `tst_qpoint.cpp`/`tst_qpointf.cpp`)
 * do not exercise.
 *
 * These cases are D-only: there is no upstream `*_data` fixture to mirror, so
 * expectations are derived from the Qt semantics the binding implements.
 *
 * Exclusions (not bound / not applicable): `qHash(QPoint)`; `QDebug` and
 * `QDataStream` streaming; Apple-only `fromCGPoint`/`toCGPoint`.
 *
 * BINDING GAP (rvalue parameters): `QPointF(const QPoint)` takes
 * `ref const(QPoint)`, which D cannot bind to an rvalue; the source point is
 * stored in a local below.
 */

// QPointF from QPoint
unittest
{
    QPoint p = QPoint(-3, 7);
    QPointF f = QPointF(p);
    assert(f.x() == -3.0 && f.y() == 7.0);
    assert(f == QPointF(-3, 7));

    // the conversion agrees with QPoint.toPointF()
    assert(p.toPointF() == f);
}
