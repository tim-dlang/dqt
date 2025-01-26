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
module qt.widgets.abstractspinbox;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.namespace;
import qt.core.size;
import qt.core.string;
import qt.core.variant;
import qt.gui.event;
import qt.gui.validator;
import qt.helpers;
import qt.widgets.lineedit;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(spinbox); +/



extern(C++, class) struct QAbstractSpinBoxPrivate;

/// Binding for C++ class [QAbstractSpinBox](https://doc.qt.io/qt-6/qabstractspinbox.html).
class /+ Q_WIDGETS_EXPORT +/ QAbstractSpinBox : QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(bool wrapping READ wrapping WRITE setWrapping)
    Q_PROPERTY(bool frame READ hasFrame WRITE setFrame)
    Q_PROPERTY(Qt::Alignment alignment READ alignment WRITE setAlignment)
    Q_PROPERTY(bool readOnly READ isReadOnly WRITE setReadOnly)
    Q_PROPERTY(ButtonSymbols buttonSymbols READ buttonSymbols WRITE setButtonSymbols)
    Q_PROPERTY(QString specialValueText READ specialValueText WRITE setSpecialValueText)
    Q_PROPERTY(QString text READ text)
    Q_PROPERTY(bool accelerated READ isAccelerated WRITE setAccelerated)
    Q_PROPERTY(CorrectionMode correctionMode READ correctionMode WRITE setCorrectionMode)
    Q_PROPERTY(bool acceptableInput READ hasAcceptableInput)
    Q_PROPERTY(bool keyboardTracking READ keyboardTracking WRITE setKeyboardTracking)
    Q_PROPERTY(bool showGroupSeparator READ isGroupSeparatorShown WRITE setGroupSeparatorShown) +/
public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    enum StepEnabledFlag { StepNone = 0x00, StepUpEnabled = 0x01,
                           StepDownEnabled = 0x02 }
    /+ Q_DECLARE_FLAGS(StepEnabled, StepEnabledFlag) +/
alias StepEnabled = QFlags!(StepEnabledFlag);
    enum ButtonSymbols { UpDownArrows, PlusMinus, NoButtons }
    /+ Q_ENUM(ButtonSymbols) +/

    final ButtonSymbols buttonSymbols() const;
    final void setButtonSymbols(ButtonSymbols bs);

    enum CorrectionMode  { CorrectToPreviousValue, CorrectToNearestValue }
    /+ Q_ENUM(CorrectionMode) +/

    final void setCorrectionMode(CorrectionMode cm);
    final CorrectionMode correctionMode() const;

    final bool hasAcceptableInput() const;
    final QString text() const;

    final QString specialValueText() const;
    final void setSpecialValueText(ref const(QString) txt);

    final bool wrapping() const;
    final void setWrapping(bool w);

    final void setReadOnly(bool r);
    final bool isReadOnly() const;

    final void setKeyboardTracking(bool kt);
    final bool keyboardTracking() const;

    final void setAlignment(/+ Qt:: +/qt.core.namespace.Alignment flag);
    final /+ Qt:: +/qt.core.namespace.Alignment alignment() const;

    final void setFrame(bool);
    final bool hasFrame() const;

    final void setAccelerated(bool on);
    final bool isAccelerated() const;

    final void setGroupSeparatorShown(bool shown);
    final bool isGroupSeparatorShown() const;

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;
    final void interpretText();
    override bool event(QEvent event);

    override QVariant inputMethodQuery(/+ Qt:: +/qt.core.namespace.InputMethodQuery) const;

    /+ virtual +/ QValidator.State validate(ref QString input, ref int pos) const;
    /+ virtual +/ void fixup(ref QString input) const;

    /+ virtual +/ void stepBy(int steps);

    enum StepType {
        DefaultStepType,
        AdaptiveDecimalStepType
    }
    /+ Q_ENUM(StepType) +/

public /+ Q_SLOTS +/:
    @QSlot final void stepUp();
    @QSlot final void stepDown();
    @QSlot final void selectAll();
    /+ virtual +/ @QSlot void clear();
protected:
    override void resizeEvent(QResizeEvent event);
    override void keyPressEvent(QKeyEvent event);
    override void keyReleaseEvent(QKeyEvent event);
/+ #if QT_CONFIG(wheelevent) +/
    override void wheelEvent(QWheelEvent event);
/+ #endif +/
    override void focusInEvent(QFocusEvent event);
    override void focusOutEvent(QFocusEvent event);
/+ #if QT_CONFIG(contextmenu) +/
    override void contextMenuEvent(QContextMenuEvent event);
/+ #endif +/
    override void changeEvent(QEvent event);
    override void closeEvent(QCloseEvent event);
    override void hideEvent(QHideEvent event);
    override void mousePressEvent(QMouseEvent event);
    override void mouseReleaseEvent(QMouseEvent event);
    override void mouseMoveEvent(QMouseEvent event);
    override void timerEvent(QTimerEvent event);
    override void paintEvent(QPaintEvent event);
    override void showEvent(QShowEvent event);
    /+ virtual +/ void initStyleOption(QStyleOptionSpinBox* option) const;

    final QLineEdit lineEdit() const;
    final void setLineEdit(QLineEdit edit);

    /+ virtual +/ StepEnabled stepEnabled() const;
/+ Q_SIGNALS +/public:
    @QSignal final void editingFinished();
protected:
    this(ref QAbstractSpinBoxPrivate dd, QWidget parent = null);

private:
    /+ Q_PRIVATE_SLOT(d_func(), void _q_editorTextChanged(const QString &))
    Q_PRIVATE_SLOT(d_func(), void _q_editorCursorPositionChanged(int, int))

    Q_DECLARE_PRIVATE(QAbstractSpinBox) +/
    /+ Q_DISABLE_COPY(QAbstractSpinBox) +/
    /+ friend class QAccessibleAbstractSpinBox; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QAbstractSpinBox.StepEnabled.enum_type) operator |(QAbstractSpinBox.StepEnabled.enum_type f1, QAbstractSpinBox.StepEnabled.enum_type f2)/+noexcept+/{return QFlags!(QAbstractSpinBox.StepEnabled.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QAbstractSpinBox.StepEnabled.enum_type) operator |(QAbstractSpinBox.StepEnabled.enum_type f1, QFlags!(QAbstractSpinBox.StepEnabled.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QAbstractSpinBox.StepEnabled.enum_type) operator &(QAbstractSpinBox.StepEnabled.enum_type f1, QAbstractSpinBox.StepEnabled.enum_type f2)/+noexcept+/{return QFlags!(QAbstractSpinBox.StepEnabled.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QAbstractSpinBox.StepEnabled.enum_type) operator &(QAbstractSpinBox.StepEnabled.enum_type f1, QFlags!(QAbstractSpinBox.StepEnabled.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QAbstractSpinBox.StepEnabled.enum_type) operator ^(QAbstractSpinBox.StepEnabled.enum_type f1, QAbstractSpinBox.StepEnabled.enum_type f2)/+noexcept+/{return QFlags!(QAbstractSpinBox.StepEnabled.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QAbstractSpinBox.StepEnabled.enum_type) operator ^(QAbstractSpinBox.StepEnabled.enum_type f1, QFlags!(QAbstractSpinBox.StepEnabled.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QAbstractSpinBox.StepEnabled.enum_type f1, QAbstractSpinBox.StepEnabled.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QAbstractSpinBox.StepEnabled.enum_type f1, QFlags!(QAbstractSpinBox.StepEnabled.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QAbstractSpinBox.StepEnabled.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QAbstractSpinBox.StepEnabled.enum_type f1, QAbstractSpinBox.StepEnabled.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QAbstractSpinBox.StepEnabled.enum_type f1, QFlags!(QAbstractSpinBox.StepEnabled.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QAbstractSpinBox.StepEnabled.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QAbstractSpinBox.StepEnabled.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QAbstractSpinBox.StepEnabled.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QAbstractSpinBox.StepEnabled.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QAbstractSpinBox.StepEnabled.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QAbstractSpinBox.StepEnabled operator ~(QAbstractSpinBox.StepEnabled.enum_type e)/+noexcept+/{return~QAbstractSpinBox.StepEnabled(e);}+/
/+pragma(inline, true) void operator |(QAbstractSpinBox.StepEnabled.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QAbstractSpinBox.StepEnabled.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}
/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QAbstractSpinBox::StepEnabled) +/
