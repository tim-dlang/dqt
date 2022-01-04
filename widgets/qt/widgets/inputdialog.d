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
module qt.widgets.inputdialog;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.namespace;
import qt.core.object;
import qt.core.size;
import qt.core.string;
import qt.core.stringlist;
import qt.helpers;
import qt.widgets.dialog;
import qt.widgets.lineedit;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(inputdialog); +/


extern(C++, class) struct QInputDialogPrivate;

/// Binding for C++ class [QInputDialog](https://doc.qt.io/qt-5/qinputdialog.html).
class /+ Q_WIDGETS_EXPORT +/ QInputDialog : QDialog
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QInputDialog) +/
//  Q_ENUMS(InputMode InputDialogOption)
    /+ QDOC_PROPERTY(InputMode inputMode READ inputMode WRITE setInputMode)
    QDOC_PROPERTY(QString labelText READ labelText WRITE setLabelText)
    QDOC_PROPERTY(InputDialogOptions options READ options WRITE setOptions)
    QDOC_PROPERTY(QString textValue READ textValue WRITE setTextValue NOTIFY textValueChanged)
    QDOC_PROPERTY(int intValue READ intValue WRITE setIntValue NOTIFY intValueChanged)
    QDOC_PROPERTY(int doubleValue READ doubleValue WRITE setDoubleValue NOTIFY doubleValueChanged)
    QDOC_PROPERTY(QLineEdit::EchoMode textEchoMode READ textEchoMode WRITE setTextEchoMode)
    QDOC_PROPERTY(bool comboBoxEditable READ isComboBoxEditable WRITE setComboBoxEditable)
    QDOC_PROPERTY(QStringList comboBoxItems READ comboBoxItems WRITE setComboBoxItems)
    QDOC_PROPERTY(int intMinimum READ intMinimum WRITE setIntMinimum)
    QDOC_PROPERTY(int intMaximum READ intMaximum WRITE setIntMaximum)
    QDOC_PROPERTY(int intStep READ intStep WRITE setIntStep)
    QDOC_PROPERTY(double doubleMinimum READ doubleMinimum WRITE setDoubleMinimum)
    QDOC_PROPERTY(double doubleMaximum READ doubleMaximum WRITE setDoubleMaximum)
    QDOC_PROPERTY(int doubleDecimals READ doubleDecimals WRITE setDoubleDecimals)
    QDOC_PROPERTY(QString okButtonText READ okButtonText WRITE setOkButtonText)
    QDOC_PROPERTY(QString cancelButtonText READ cancelButtonText WRITE setCancelButtonText)
    QDOC_PROPERTY(double doubleStep READ doubleStep WRITE setDoubleStep) +/

public:
    enum InputDialogOption {
        NoButtons                    = 0x00000001,
        UseListViewForComboBoxItems  = 0x00000002,
        UsePlainTextEditForTextInput = 0x00000004
    }

    /+ Q_DECLARE_FLAGS(InputDialogOptions, InputDialogOption) +/
alias InputDialogOptions = QFlags!(InputDialogOption);
    enum InputMode {
        TextInput,
        IntInput,
        DoubleInput
    }

    this(QWidget parent = null, /+ Qt:: +/qt.core.namespace.WindowFlags flags = /+ Qt:: +/qt.core.namespace.WindowFlags());
    ~this();

    final void setInputMode(InputMode mode);
    final InputMode inputMode() const;

    final void setLabelText(ref const(QString) text);
    final QString labelText() const;

    final void setOption(InputDialogOption option, bool on = true);
    final bool testOption(InputDialogOption option) const;
    final void setOptions(InputDialogOptions options);
    final InputDialogOptions options() const;

    final void setTextValue(ref const(QString) text);
    final QString textValue() const;

    final void setTextEchoMode(QLineEdit.EchoMode mode);
    final QLineEdit.EchoMode textEchoMode() const;

    final void setComboBoxEditable(bool editable);
    final bool isComboBoxEditable() const;

    final void setComboBoxItems(ref const(QStringList) items);
    final QStringList comboBoxItems() const;

    final void setIntValue(int value);
    final int intValue() const;

    final void setIntMinimum(int min);
    final int intMinimum() const;

    final void setIntMaximum(int max);
    final int intMaximum() const;

    final void setIntRange(int min, int max);

    final void setIntStep(int step);
    final int intStep() const;

    final void setDoubleValue(double value);
    final double doubleValue() const;

    final void setDoubleMinimum(double min);
    final double doubleMinimum() const;

    final void setDoubleMaximum(double max);
    final double doubleMaximum() const;

    final void setDoubleRange(double min, double max);

    final void setDoubleDecimals(int decimals);
    final int doubleDecimals() const;

    final void setOkButtonText(ref const(QString) text);
    final QString okButtonText() const;

    final void setCancelButtonText(ref const(QString) text);
    final QString cancelButtonText() const;

    /+ using QDialog::open; +/
    final void open(QObject receiver, const(char)* member);

    override QSize minimumSizeHint() const;
    override QSize sizeHint() const;

    override void setVisible(bool visible);

    static QString getText(QWidget parent, ref const(QString) title, ref const(QString) label,
                               QLineEdit.EchoMode echo = QLineEdit.EchoMode.Normal,
                               ref const(QString) text = globalInitVar!QString, bool* ok = null,
                               /+ Qt:: +/qt.core.namespace.WindowFlags flags = /+ Qt:: +/qt.core.namespace.WindowFlags(),
                               /+ Qt:: +/qt.core.namespace.InputMethodHints inputMethodHints = /+ Qt:: +/qt.core.namespace.InputMethodHint.ImhNone);
    static QString getMultiLineText(QWidget parent, ref const(QString) title, ref const(QString) label,
                                        ref const(QString) text = globalInitVar!QString, bool* ok = null,
                                        /+ Qt:: +/qt.core.namespace.WindowFlags flags = /+ Qt:: +/qt.core.namespace.WindowFlags(),
                                        /+ Qt:: +/qt.core.namespace.InputMethodHints inputMethodHints = /+ Qt:: +/qt.core.namespace.InputMethodHint.ImhNone);
    static QString getItem(QWidget parent, ref const(QString) title, ref const(QString) label,
                               ref const(QStringList) items, int current = 0, bool editable = true,
                               bool* ok = null, /+ Qt:: +/qt.core.namespace.WindowFlags flags = /+ Qt:: +/qt.core.namespace.WindowFlags(),
                               /+ Qt:: +/qt.core.namespace.InputMethodHints inputMethodHints = /+ Qt:: +/qt.core.namespace.InputMethodHint.ImhNone);

    static int getInt(QWidget parent, ref const(QString) title, ref const(QString) label, int value = 0,
                          int minValue = -2147483647, int maxValue = 2147483647,
                          int step = 1, bool* ok = null, /+ Qt:: +/qt.core.namespace.WindowFlags flags = /+ Qt:: +/qt.core.namespace.WindowFlags());

/+ #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0) || defined(Q_QDOC)
    static double getDouble(QWidget *parent, const QString &title, const QString &label, double value = 0,
                            double minValue = -2147483647, double maxValue = 2147483647,
                            int decimals = 1, bool *ok = nullptr, Qt::WindowFlags flags = Qt::WindowFlags(),
                            double step = 1);
#else +/
    static double getDouble(QWidget parent, ref const(QString) title, ref const(QString) label,
                                double value = 0, double minValue = -2147483647,
                                double maxValue = 2147483647, int decimals = 1, bool* ok = null,
                                /+ Qt:: +/qt.core.namespace.WindowFlags flags = /+ Qt:: +/qt.core.namespace.WindowFlags());
    static double getDouble(QWidget parent, ref const(QString) title, ref const(QString) label,
                                double value, double minValue, double maxValue, int decimals, bool* ok,
                                /+ Qt:: +/qt.core.namespace.WindowFlags flags, double step);
/+ #endif

#if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED static inline int getInteger(QWidget *parent, const QString &title, const QString &label, int value = 0,
                          int minValue = -2147483647, int maxValue = 2147483647,
                          int step = 1, bool *ok = nullptr, Qt::WindowFlags flags = Qt::WindowFlags())
    {
        return getInt(parent, title, label, value, minValue, maxValue, step, ok, flags);
    }
#endif +/

    final void setDoubleStep(double step);
    final double doubleStep() const;

/+ Q_SIGNALS +/public:
    // ### emit signals!
    @QSignal final void textValueChanged(ref const(QString) text);
    @QSignal final void textValueSelected(ref const(QString) text);
    @QSignal final void intValueChanged(int value);
    @QSignal final void intValueSelected(int value);
    @QSignal final void doubleValueChanged(double value);
    @QSignal final void doubleValueSelected(double value);

public:
    override void done(int result);

private:
    /+ Q_DISABLE_COPY(QInputDialog) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_textChanged(const QString&))
    Q_PRIVATE_SLOT(d_func(), void _q_plainTextEditTextChanged())
    Q_PRIVATE_SLOT(d_func(), void _q_currentRowChanged(const QModelIndex&, const QModelIndex&)) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QInputDialog.InputDialogOptions.enum_type) operator |(QInputDialog.InputDialogOptions.enum_type f1, QInputDialog.InputDialogOptions.enum_type f2)/+noexcept+/{return QFlags!(QInputDialog.InputDialogOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QInputDialog.InputDialogOptions.enum_type) operator |(QInputDialog.InputDialogOptions.enum_type f1, QFlags!(QInputDialog.InputDialogOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QInputDialog.InputDialogOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QInputDialog::InputDialogOptions) +/
