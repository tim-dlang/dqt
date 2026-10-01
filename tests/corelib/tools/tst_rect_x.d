// QT_MODULES: core
module corelib.tools.tst_rect_x;

import qt.core.rect;
import qt.core.point;
import qt.core.size;
import qt.core.global;

/*
 * Supplemental coverage for the `QRect`/`QRectF` bindings in
 * `qt/core/core/rect.d`, covering members the mirrored `tst_rect.d`
 * (upstream `tst_qrect.cpp`) does not exercise.
 *
 * These cases are D-only: there is no upstream `*_data` fixture to mirror, so
 * expectations are derived from the Qt semantics the binding implements.
 *
 * Exclusions (not bound / not applicable): `qHash(QRect)`; `QDebug` and
 * `QDataStream` streaming; Apple-only `toCGRect`/`fromCGRect`.
 *
 * BINDING GAP (rvalue parameters): `QRect`/`QRectF` `moveCenter`, `moveTo`,
 * `setSize`, and the `translated` overloads taking a point/`QSize` take
 * `ref const(T)`, which D cannot bind to rvalues; the arguments are stored in
 * locals below.
 */

// ---------------------------------------------------------------------------
// QRect
// ---------------------------------------------------------------------------

// setX / setY
unittest
{
    QRect r = QRect(10, 20, 30, 40);
    assert(r.right() == 39 && r.bottom() == 59);
    r.setX(5);
    assert(r.x() == 5 && r.left() == 5);
    // setX moves only the left edge; the right edge is unchanged
    assert(r.right() == 39);

    QRect r2 = QRect(10, 20, 30, 40);
    r2.setY(7);
    assert(r2.y() == 7 && r2.top() == 7);
    assert(r2.bottom() == 59);
}

// moveCenter
unittest
{
    QRect r = QRect(0, 0, 10, 10);
    int w = r.width();
    int h = r.height();
    QPoint c = QPoint(5, 5);
    r.moveCenter(c);
    assert(r.center() == c);
    assert(r.width() == w && r.height() == h);
}

// moveTo
unittest
{
    QRect r = QRect(0, 0, 10, 10);
    r.moveTo(100, 200);
    assert(r.x() == 100 && r.y() == 200);
    assert(r.width() == 10 && r.height() == 10);

    QRect r2 = QRect(0, 0, 10, 10);
    QPoint p = QPoint(100, 200);
    r2.moveTo(p);
    assert(r2.x() == 100 && r2.y() == 200);
}

// setRect
unittest
{
    QRect r = QRect.init;
    r.setRect(1, 2, 10, 20);
    assert(r.x() == 1 && r.y() == 2 && r.width() == 10 && r.height() == 20);
}

// setRect / getRect round-trip
unittest
{
    QRect r = QRect.init;
    r.setRect(1, 2, 10, 20);
    int x, y, w, h;
    r.getRect(&x, &y, &w, &h);
    assert(x == 1 && y == 2 && w == 10 && h == 20);
}

// setCoords / getCoords round-trip
unittest
{
    QRect r = QRect.init;
    r.setCoords(1, 2, 11, 21);
    assert(r.left() == 1 && r.top() == 2 && r.right() == 11 && r.bottom() == 21);
    int x1, y1, x2, y2;
    r.getCoords(&x1, &y1, &x2, &y2);
    assert(x1 == 1 && y1 == 2 && x2 == 11 && y2 == 21);
}

// size
unittest
{
    assert(QRect(0, 0, 10, 20).size() == QSize(10, 20));
}

// setSize
unittest
{
    QRect r = QRect(5, 6, 1, 1);
    QSize s = QSize(10, 20);
    r.setSize(s);
    assert(r.width() == 10 && r.height() == 20);
    assert(r.x() == 5 && r.y() == 6);
}

// translated(QPoint)
unittest
{
    QRect r = QRect(1, 2, 5, 6);
    QPoint delta = QPoint(10, 20);
    assert(r.translated(delta) == QRect(11, 22, 5, 6));
    // the original is unchanged
    assert(r == QRect(1, 2, 5, 6));
}

// ---------------------------------------------------------------------------
// QRectF
// ---------------------------------------------------------------------------

// direct edge setters
unittest
{
    QRectF a = QRectF(0, 0, 10, 10);
    a.setLeft(2);
    assert(qFuzzyCompare(a.left(), 2.0));
    assert(qFuzzyCompare(a.right(), 10.0));
    assert(qFuzzyCompare(a.width(), 8.0));

    QRectF b = QRectF(0, 0, 10, 10);
    b.setTop(3);
    assert(qFuzzyCompare(b.top(), 3.0));
    assert(qFuzzyCompare(b.bottom(), 10.0));
    assert(qFuzzyCompare(b.height(), 7.0));

    QRectF c = QRectF(0, 0, 10, 10);
    c.setRight(8);
    assert(qFuzzyCompare(c.right(), 8.0));
    assert(qFuzzyCompare(c.width(), 8.0));

    QRectF d = QRectF(0, 0, 10, 10);
    d.setBottom(7);
    assert(qFuzzyCompare(d.bottom(), 7.0));
    assert(qFuzzyCompare(d.height(), 7.0));
}

// setX / setY (aliases of setLeft / setTop)
unittest
{
    QRectF f = QRectF(0, 0, 10, 10);
    f.setX(2);
    assert(qFuzzyCompare(f.left(), 2.0) && qFuzzyCompare(f.width(), 8.0));

    QRectF g = QRectF(0, 0, 10, 10);
    g.setY(3);
    assert(qFuzzyCompare(g.top(), 3.0) && qFuzzyCompare(g.height(), 7.0));
}

// moveCenter
unittest
{
    QRectF f = QRectF(0, 0, 10, 10);
    QPointF c = QPointF(5, 5);
    f.moveCenter(c);
    assert(f.center() == c);
    assert(qFuzzyCompare(f.width(), 10.0) && qFuzzyCompare(f.height(), 10.0));
}

// moveTo
unittest
{
    QRectF f = QRectF(0, 0, 10, 10);
    f.moveTo(100, 200);
    assert(f.x() == 100.0 && f.y() == 200.0);

    QRectF g = QRectF(0, 0, 10, 10);
    QPointF p = QPointF(100, 200);
    g.moveTo(p);
    assert(g.x() == 100.0 && g.y() == 200.0);
}

// setRect / getRect round-trip
unittest
{
    QRectF f = QRectF.init;
    f.setRect(1, 2, 10, 20);
    assert(f.x() == 1.0 && f.y() == 2.0 && f.width() == 10.0 && f.height() == 20.0);
    qreal x, y, w, h;
    f.getRect(&x, &y, &w, &h);
    assert(x == 1.0 && y == 2.0 && w == 10.0 && h == 20.0);
}

// setCoords / getCoords round-trip
unittest
{
    QRectF f = QRectF.init;
    f.setCoords(1, 2, 11, 22);
    assert(f.left() == 1.0 && f.top() == 2.0 && f.right() == 11.0 && f.bottom() == 22.0);
    qreal x1, y1, x2, y2;
    f.getCoords(&x1, &y1, &x2, &y2);
    assert(x1 == 1.0 && y1 == 2.0 && x2 == 11.0 && y2 == 22.0);
}

// size
unittest
{
    assert(QRectF(0, 0, 10.5, 20.5).size() == QSizeF(10.5, 20.5));
}

// setSize
unittest
{
    QRectF f = QRectF(5, 6, 1, 1);
    QSizeF s = QSizeF(10.5, 20.5);
    f.setSize(s);
    assert(f.width() == 10.5 && f.height() == 20.5);
    assert(f.x() == 5.0 && f.y() == 6.0);
}

// translated(QPointF)
unittest
{
    QRectF f = QRectF(1, 2, 5, 6);
    QPointF delta = QPointF(10, 20);
    assert(f.translated(delta) == QRectF(11, 22, 5, 6));
    // the original is unchanged
    assert(f == QRectF(1, 2, 5, 6));
}
