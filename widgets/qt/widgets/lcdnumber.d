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
module qt.widgets.lcdnumber;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.size;
import qt.core.string;
import qt.gui.event;
import qt.helpers;
import qt.widgets.frame;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(lcdnumber); +/

extern(C++, class) struct QLCDNumberPrivate;
/// Binding for C++ class [QLCDNumber](https://doc.qt.io/qt-5/qlcdnumber.html).
class /+ Q_WIDGETS_EXPORT +/ QLCDNumber : QFrame // LCD number widget
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool smallDecimalPoint READ smallDecimalPoint WRITE setSmallDecimalPoint)
    Q_PROPERTY(int digitCount READ digitCount WRITE setDigitCount)
    Q_PROPERTY(Mode mode READ mode WRITE setMode)
    Q_PROPERTY(SegmentStyle segmentStyle READ segmentStyle WRITE setSegmentStyle)
    Q_PROPERTY(double value READ value WRITE display)
    Q_PROPERTY(int intValue READ intValue WRITE display) +/

public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(uint numDigits, QWidget parent = null);
    ~this();

    enum Mode {
        Hex, Dec, Oct, Bin
    }
    /+ Q_ENUM(Mode) +/
    enum SegmentStyle {
        Outline, Filled, Flat
    }
    /+ Q_ENUM(SegmentStyle) +/

    final bool smallDecimalPoint() const;
    final int digitCount() const;
    final void setDigitCount(int nDigits);

    final bool checkOverflow(double num) const;
    final bool checkOverflow(int num) const;

    final Mode mode() const;
    final void setMode(Mode);

    final SegmentStyle segmentStyle() const;
    final void setSegmentStyle(SegmentStyle);

    final double value() const;
    final int intValue() const;
 
    final void setValue(double val)
    {
        setProperty("value", val);
    }
    final void setIntValue(int val)
    {
        setProperty("intValue", val);
    }

    override QSize sizeHint() const;

public /+ Q_SLOTS +/:
    @QSlot final void display(ref const(QString) str);
    @QSlot final void display(int num);
    @QSlot final void display(double num);
    @QSlot final void setHexMode();
    @QSlot final void setDecMode();
    @QSlot final void setOctMode();
    @QSlot final void setBinMode();
    @QSlot final void setSmallDecimalPoint(bool);

/+ Q_SIGNALS +/public:
    @QSignal final void overflow();

protected:
    override bool event(QEvent e);
    override void paintEvent(QPaintEvent );

public:

private:
    /+ Q_DISABLE_COPY(QLCDNumber) +/
    /+ Q_DECLARE_PRIVATE(QLCDNumber) +/
}

