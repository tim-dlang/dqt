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
module qt.widgets.dial;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.global;
import qt.core.size;
import qt.gui.event;
import qt.helpers;
import qt.widgets.abstractslider;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(dial); +/


extern(C++, class) struct QDialPrivate;
/+ class QStyleOptionSlider; +/

class /+ Q_WIDGETS_EXPORT +/ QDial: QAbstractSlider
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(bool wrapping READ wrapping WRITE setWrapping)
    Q_PROPERTY(int notchSize READ notchSize)
    Q_PROPERTY(qreal notchTarget READ notchTarget WRITE setNotchTarget)
    Q_PROPERTY(bool notchesVisible READ notchesVisible WRITE setNotchesVisible) +/
public:
    /+ explicit +/this(QWidget parent = null);

    ~this();

    final bool wrapping() const;

    final int notchSize() const;

    final void setNotchTarget(double target);
    final qreal notchTarget() const;
    final bool notchesVisible() const;

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;

public /+ Q_SLOTS +/:
    @QSlot final void setNotchesVisible(bool visible);
    @QSlot final void setWrapping(bool on);

protected:
    override bool event(QEvent e);
    override void resizeEvent(QResizeEvent re);
    override void paintEvent(QPaintEvent pe);

    override void mousePressEvent(QMouseEvent me);
    override void mouseReleaseEvent(QMouseEvent me);
    override void mouseMoveEvent(QMouseEvent me);

    override void sliderChange(SliderChange change);
    final void initStyleOption(QStyleOptionSlider* option) const;


private:
    /+ Q_DECLARE_PRIVATE(QDial) +/
    /+ Q_DISABLE_COPY(QDial) +/
}

