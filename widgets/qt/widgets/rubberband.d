/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.widgets.rubberband;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.gui.event;
import qt.helpers;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(rubberband); +/


extern(C++, class) struct QRubberBandPrivate;
/+ class QStyleOptionRubberBand; +/

class /+ Q_WIDGETS_EXPORT +/ QRubberBand : QWidget
{
    mixin(Q_OBJECT);

public:
    enum Shape { Line, Rectangle }
    /+ explicit +/this(Shape, QWidget  /+ = nullptr +/);
    ~this();

    final Shape shape() const;

//    final void setGeometry(ref const(QRect) r);

/+    pragma(inline, true) final void setGeometry(int ax, int ay, int aw, int ah)
    { auto tmp = QRect(ax, ay, aw, ah); setGeometry(tmp); }
    pragma(inline, true) final void move(int ax, int ay)
    { setGeometry(ax, ay, width(), height()); }
    pragma(inline, true) final void move(ref const(QPoint) p)
    { move(p.x(), p.y()); }
    pragma(inline, true) final void resize(int w, int h)
    { setGeometry(geometry().x(), geometry().y(), w, h); }
    pragma(inline, true) final void resize(ref const(QSize) s)
    { resize(s.width(), s.height()); }+/

protected:
    override bool event(QEvent e);
    override void paintEvent(QPaintEvent );
    override void changeEvent(QEvent );
    override void showEvent(QShowEvent );
    override void resizeEvent(QResizeEvent );
    override void moveEvent(QMoveEvent );
    final void initStyleOption(QStyleOptionRubberBand* option) const;

private:
    /+ Q_DECLARE_PRIVATE(QRubberBand) +/
}

