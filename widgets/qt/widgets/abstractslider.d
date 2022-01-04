/*
 * DQt - D bindings for the Qt Toolkit
 *
 * GNU Lesser General Public License Usage
 * This file may be used under the terms of the GNU Lesser
 * General Public License version 3 as published by the Free Software
 * Foundation and appearing in the file LICENSE.LGPL3 included in the
 * packaging of this file. Please review the following information to
 * ensure the GNU Lesser General Public License version 3 requirements
 * will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
 */
module qt.widgets.abstractslider;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.gui.event;
import qt.helpers;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(abstractslider); +/



extern(C++, class) struct QAbstractSliderPrivate;

/// Binding for C++ class [QAbstractSlider](https://doc.qt.io/qt-5/qabstractslider.html).
class /+ Q_WIDGETS_EXPORT +/ QAbstractSlider : QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(int minimum READ minimum WRITE setMinimum)
    Q_PROPERTY(int maximum READ maximum WRITE setMaximum)
    Q_PROPERTY(int singleStep READ singleStep WRITE setSingleStep)
    Q_PROPERTY(int pageStep READ pageStep WRITE setPageStep)
    Q_PROPERTY(int value READ value WRITE setValue NOTIFY valueChanged USER true)
    Q_PROPERTY(int sliderPosition READ sliderPosition WRITE setSliderPosition NOTIFY sliderMoved)
    Q_PROPERTY(bool tracking READ hasTracking WRITE setTracking)
    Q_PROPERTY(Qt::Orientation orientation READ orientation WRITE setOrientation)
    Q_PROPERTY(bool invertedAppearance READ invertedAppearance WRITE setInvertedAppearance)
    Q_PROPERTY(bool invertedControls READ invertedControls WRITE setInvertedControls)
    Q_PROPERTY(bool sliderDown READ isSliderDown WRITE setSliderDown DESIGNABLE false) +/

public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    final /+ Qt:: +/qt.core.namespace.Orientation orientation() const;

    final void setMinimum(int);
    final int minimum() const;

    final void setMaximum(int);
    final int maximum() const;

    final void setSingleStep(int);
    final int singleStep() const;

    final void setPageStep(int);
    final int pageStep() const;

    final void setTracking(bool enable);
    final bool hasTracking() const;

    final void setSliderDown(bool);
    final bool isSliderDown() const;

    final void setSliderPosition(int);
    final int sliderPosition() const;

    final void setInvertedAppearance(bool);
    final bool invertedAppearance() const;

    final void setInvertedControls(bool);
    final bool invertedControls() const;

    enum SliderAction {
        SliderNoAction,
        SliderSingleStepAdd,
        SliderSingleStepSub,
        SliderPageStepAdd,
        SliderPageStepSub,
        SliderToMinimum,
        SliderToMaximum,
        SliderMove
    }

    final int value() const;

    final void triggerAction(SliderAction action);

public /+ Q_SLOTS +/:
    @QSlot final void setValue(int);
    @QSlot final void setOrientation(/+ Qt:: +/qt.core.namespace.Orientation);
    @QSlot final void setRange(int min, int max);

/+ Q_SIGNALS +/public:
    @QSignal final void valueChanged(int value);

    @QSignal final void sliderPressed();
    @QSignal final void sliderMoved(int position);
    @QSignal final void sliderReleased();

    @QSignal final void rangeChanged(int min, int max);

    @QSignal final void actionTriggered(int action);

protected:
    override bool event(QEvent e);

    final void setRepeatAction(SliderAction action, int thresholdTime = 500, int repeatTime = 50);
    final SliderAction repeatAction() const;

    enum SliderChange {
        SliderRangeChange,
        SliderOrientationChange,
        SliderStepsChange,
        SliderValueChange
    }
    /+ virtual +/ void sliderChange(SliderChange change);

    override void keyPressEvent(QKeyEvent ev);
    override void timerEvent(QTimerEvent );
/+ #if QT_CONFIG(wheelevent) +/
    override void wheelEvent(QWheelEvent e);
/+ #endif +/
    override void changeEvent(QEvent e);


protected:
    this(ref QAbstractSliderPrivate dd, QWidget parent = null);

private:
    /+ Q_DISABLE_COPY(QAbstractSlider) +/
    /+ Q_DECLARE_PRIVATE(QAbstractSlider) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

