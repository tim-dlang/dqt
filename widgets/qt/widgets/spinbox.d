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
module qt.widgets.spinbox;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.string;
import qt.helpers;
import qt.widgets.abstractspinbox;
import qt.widgets.widget;
version(QT_NO_VALIDATOR){}else
    import qt.gui.validator;

/+ QT_REQUIRE_CONFIG(spinbox); +/


extern(C++, class) struct QSpinBoxPrivate;
/// Binding for C++ class [QSpinBox](https://doc.qt.io/qt-5/qspinbox.html).
class /+ Q_WIDGETS_EXPORT +/ QSpinBox : QAbstractSpinBox
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QString suffix READ suffix WRITE setSuffix)
    Q_PROPERTY(QString prefix READ prefix WRITE setPrefix)
    Q_PROPERTY(QString cleanText READ cleanText)
    Q_PROPERTY(int minimum READ minimum WRITE setMinimum)
    Q_PROPERTY(int maximum READ maximum WRITE setMaximum)
    Q_PROPERTY(int singleStep READ singleStep WRITE setSingleStep)
    Q_PROPERTY(StepType stepType READ stepType WRITE setStepType)
    Q_PROPERTY(int value READ value WRITE setValue NOTIFY valueChanged USER true)
    Q_PROPERTY(int displayIntegerBase READ displayIntegerBase WRITE setDisplayIntegerBase) +/

public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    final int value() const;

    final QString prefix() const;
    final void setPrefix(ref const(QString) prefix);

    final QString suffix() const;
    final void setSuffix(ref const(QString) suffix);

    final QString cleanText() const;

    final int singleStep() const;
    final void setSingleStep(int val);

    final int minimum() const;
    final void setMinimum(int min);

    final int maximum() const;
    final void setMaximum(int max);

    final void setRange(int min, int max);

    final StepType stepType() const;
    final void setStepType(StepType stepType);

    final int displayIntegerBase() const;
    final void setDisplayIntegerBase(int base);

protected:
    override bool event(QEvent event);
    override QValidator.State validate(ref QString input, ref int pos) const;
    /+ virtual +/ int valueFromText(ref const(QString) text) const;
    /+ virtual +/ QString textFromValue(int val) const;
    override void fixup(ref QString str) const;


public /+ Q_SLOTS +/:
    @QSlot final void setValue(int val);

/+ Q_SIGNALS +/public:
    @QSignal final void valueChanged(int);
    @QSignal final void textChanged(ref const(QString) );
/+ #if QT_DEPRECATED_SINCE(5, 14) +/
    /+ QT_DEPRECATED_X("Use textChanged(QString) instead") +/
        @QSignal final void valueChanged(ref const(QString) );
/+ #endif +/

private:
    /+ Q_DISABLE_COPY(QSpinBox) +/
    /+ Q_DECLARE_PRIVATE(QSpinBox) +/
}

extern(C++, class) struct QDoubleSpinBoxPrivate;
/// Binding for C++ class [QDoubleSpinBox](https://doc.qt.io/qt-5/qdoublespinbox.html).
class /+ Q_WIDGETS_EXPORT +/ QDoubleSpinBox : QAbstractSpinBox
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QString prefix READ prefix WRITE setPrefix)
    Q_PROPERTY(QString suffix READ suffix WRITE setSuffix)
    Q_PROPERTY(QString cleanText READ cleanText)
    Q_PROPERTY(int decimals READ decimals WRITE setDecimals)
    Q_PROPERTY(double minimum READ minimum WRITE setMinimum)
    Q_PROPERTY(double maximum READ maximum WRITE setMaximum)
    Q_PROPERTY(double singleStep READ singleStep WRITE setSingleStep)
    Q_PROPERTY(StepType stepType READ stepType WRITE setStepType)
    Q_PROPERTY(double value READ value WRITE setValue NOTIFY valueChanged USER true) +/
public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    final double value() const;

    final QString prefix() const;
    final void setPrefix(ref const(QString) prefix);

    final QString suffix() const;
    final void setSuffix(ref const(QString) suffix);

    final QString cleanText() const;

    final double singleStep() const;
    final void setSingleStep(double val);

    final double minimum() const;
    final void setMinimum(double min);

    final double maximum() const;
    final void setMaximum(double max);

    final void setRange(double min, double max);

    final StepType stepType() const;
    final void setStepType(StepType stepType);

    final int decimals() const;
    final void setDecimals(int prec);

    override QValidator.State validate(ref QString input, ref int pos) const;
    /+ virtual +/ double valueFromText(ref const(QString) text) const;
    /+ virtual +/ QString textFromValue(double val) const;
    override void fixup(ref QString str) const;

public /+ Q_SLOTS +/:
    @QSlot final void setValue(double val);

/+ Q_SIGNALS +/public:
    @QSignal final void valueChanged(double);
    @QSignal final void textChanged(ref const(QString) );
/+ #if QT_DEPRECATED_SINCE(5, 14) +/
    /+ QT_DEPRECATED_X("Use textChanged(QString) instead") +/
        @QSignal final void valueChanged(ref const(QString) );
/+ #endif +/

private:
    /+ Q_DISABLE_COPY(QDoubleSpinBox) +/
    /+ Q_DECLARE_PRIVATE(QDoubleSpinBox) +/
}

