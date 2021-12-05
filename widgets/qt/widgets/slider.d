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
module qt.widgets.slider;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.size;
import qt.gui.event;
import qt.helpers;
import qt.widgets.abstractslider;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(slider); +/


extern(C++, class) struct QSliderPrivate;
/+ class QStyleOptionSlider; +/
class /+ Q_WIDGETS_EXPORT +/ QSlider : QAbstractSlider
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(TickPosition tickPosition READ tickPosition WRITE setTickPosition)
    Q_PROPERTY(int tickInterval READ tickInterval WRITE setTickInterval) +/

public:
    enum TickPosition {
        NoTicks = 0,
        TicksAbove = 1,
        TicksLeft = TickPosition.TicksAbove,
        TicksBelow = 2,
        TicksRight = TickPosition.TicksBelow,
        TicksBothSides = 3
    }
    /+ Q_ENUM(TickPosition) +/

    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.Orientation orientation, QWidget parent = null);

    ~this();

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;

    final void setTickPosition(TickPosition position);
    final TickPosition tickPosition() const;

    final void setTickInterval(int ti);
    final int tickInterval() const;

    override bool event(QEvent event);

protected:
    override void paintEvent(QPaintEvent ev);
    override void mousePressEvent(QMouseEvent ev);
    override void mouseReleaseEvent(QMouseEvent ev);
    override void mouseMoveEvent(QMouseEvent ev);
    final void initStyleOption(QStyleOptionSlider* option) const;


private:
    /+ friend Q_WIDGETS_EXPORT QStyleOptionSlider qt_qsliderStyleOption(QSlider *slider); +/

    /+ Q_DISABLE_COPY(QSlider) +/
    /+ Q_DECLARE_PRIVATE(QSlider) +/
}

