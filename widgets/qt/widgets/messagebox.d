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
module qt.widgets.messagebox;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.list;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.gui.event;
import qt.gui.pixmap;
import qt.helpers;
import qt.widgets.abstractbutton;
import qt.widgets.checkbox;
import qt.widgets.dialog;
import qt.widgets.pushbutton;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(messagebox); +/


extern(C++, class) struct QMessageBoxPrivate;

/// Binding for C++ class [QMessageBox](https://doc.qt.io/qt-6/qmessagebox.html).
class /+ Q_WIDGETS_EXPORT +/ QMessageBox : QDialog
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QString text READ text WRITE setText)
    Q_PROPERTY(Icon icon READ icon WRITE setIcon)
    Q_PROPERTY(QPixmap iconPixmap READ iconPixmap WRITE setIconPixmap)
    Q_PROPERTY(Qt::TextFormat textFormat READ textFormat WRITE setTextFormat)
    Q_PROPERTY(StandardButtons standardButtons READ standardButtons WRITE setStandardButtons)
#if QT_CONFIG(textedit)
    Q_PROPERTY(QString detailedText READ detailedText WRITE setDetailedText)
#endif
    Q_PROPERTY(QString informativeText READ informativeText WRITE setInformativeText)
    Q_PROPERTY(Qt::TextInteractionFlags textInteractionFlags READ textInteractionFlags
               WRITE setTextInteractionFlags) +/

public:
    enum Icon {
        // keep this in sync with QMessageDialogOptions::Icon
        NoIcon = 0,
        Information = 1,
        Warning = 2,
        Critical = 3,
        Question = 4
    }
    /+ Q_ENUM(Icon) +/

    enum ButtonRole {
        // keep this in sync with QDialogButtonBox::ButtonRole and QPlatformDialogHelper::ButtonRole
        InvalidRole = -1,
        AcceptRole,
        RejectRole,
        DestructiveRole,
        ActionRole,
        HelpRole,
        YesRole,
        NoRole,
        ResetRole,
        ApplyRole,

        NRoles
    }

    enum StandardButton {
        // keep this in sync with QDialogButtonBox::StandardButton and QPlatformDialogHelper::StandardButton
        NoButton           = 0x00000000,
        Ok                 = 0x00000400,
        Save               = 0x00000800,
        SaveAll            = 0x00001000,
        Open               = 0x00002000,
        Yes                = 0x00004000,
        YesToAll           = 0x00008000,
        No                 = 0x00010000,
        NoToAll            = 0x00020000,
        Abort              = 0x00040000,
        Retry              = 0x00080000,
        Ignore             = 0x00100000,
        Close              = 0x00200000,
        Cancel             = 0x00400000,
        Discard            = 0x00800000,
        Help               = 0x01000000,
        Apply              = 0x02000000,
        Reset              = 0x04000000,
        RestoreDefaults    = 0x08000000,

        FirstButton        = StandardButton.Ok,                // internal
        LastButton         = StandardButton.RestoreDefaults,   // internal

        YesAll             = StandardButton.YesToAll,          // obsolete
        NoAll              = StandardButton.NoToAll,           // obsolete

        Default            = 0x00000100,        // obsolete
        Escape             = 0x00000200,        // obsolete
        FlagMask           = 0x00000300,        // obsolete
        ButtonMask         = ~StandardButton.FlagMask          // obsolete
    }
/+ #if QT_VERSION < QT_VERSION_CHECK(7, 0, 0) +/
    alias Button = StandardButton;
/+ #endif

    Q_DECLARE_FLAGS(StandardButtons, StandardButton) +/
alias StandardButtons = QFlags!(StandardButton);    /+ Q_FLAG(StandardButtons) +/

    /+ explicit +/this(QWidget parent = null);
    this(Icon icon, ref const(QString) title, ref const(QString) text,
                    StandardButtons buttons = StandardButton.NoButton, QWidget parent = null,
                    /+ Qt:: +/qt.core.namespace.WindowFlags flags = /+ Qt:: +/qt.core.namespace.WindowType.Dialog | /+ Qt:: +/qt.core.namespace.WindowType.MSWindowsFixedSizeDialogHint);
    ~this();

    final void addButton(QAbstractButton button, ButtonRole role);
    final QPushButton addButton(ref const(QString) text, ButtonRole role);
    final QPushButton addButton(StandardButton button);
    final void removeButton(QAbstractButton button);

    /+ using QDialog::open; +/
    final void open(QObject receiver, const(char)* member);

    final QList!(QAbstractButton) buttons() const;
    final ButtonRole buttonRole(QAbstractButton button) const;

    final void setStandardButtons(StandardButtons buttons);
    final StandardButtons standardButtons() const;
    final StandardButton standardButton(QAbstractButton button) const;
    final QAbstractButton button(StandardButton which) const;

    final QPushButton defaultButton() const;
    final void setDefaultButton(QPushButton button);
    final void setDefaultButton(StandardButton button);

    final QAbstractButton escapeButton() const;
    final void setEscapeButton(QAbstractButton button);
    final void setEscapeButton(StandardButton button);

    final QAbstractButton clickedButton() const;

    final QString text() const;
    final void setText(ref const(QString) text);

    final Icon icon() const;
    final void setIcon(Icon);

    final QPixmap iconPixmap() const;
    final void setIconPixmap(ref const(QPixmap) pixmap);

    final /+ Qt:: +/qt.core.namespace.TextFormat textFormat() const;
    final void setTextFormat(/+ Qt:: +/qt.core.namespace.TextFormat format);

    final void setTextInteractionFlags(/+ Qt:: +/qt.core.namespace.TextInteractionFlags flags);
    final /+ Qt:: +/qt.core.namespace.TextInteractionFlags textInteractionFlags() const;

    final void setCheckBox(QCheckBox cb);
    final QCheckBox checkBox() const;

    static StandardButton information(QWidget parent, ref const(QString) title,
             ref const(QString) text, StandardButtons buttons = StandardButton.Ok,
             StandardButton defaultButton = StandardButton.NoButton);
/+ #if QT_VERSION < QT_VERSION_CHECK(7, 0, 0) +/ // needed as long as we have int overloads
    pragma(inline, true) static StandardButton information(QWidget parent, ref const(QString) title,
                                      ref const(QString) text,
                                      StandardButton button0, StandardButton button1 = StandardButton.NoButton)
    { return information(parent, title, text, StandardButtons(button0), button1); }
/+ #endif +/

    static StandardButton question(QWidget parent, ref const(QString) title,
             ref const(QString) text, StandardButtons buttons = StandardButtons(StandardButton.Yes | StandardButton.No),
             StandardButton defaultButton = StandardButton.NoButton);
/+ #if QT_VERSION < QT_VERSION_CHECK(7, 0, 0) +/
    pragma(inline, true) static int question(QWidget parent, ref const(QString) title,
                                   ref const(QString) text,
                                   StandardButton button0, StandardButton button1)
    { return question(parent, title, text, StandardButtons(button0), button1); }
/+ #endif +/

    static StandardButton warning(QWidget parent, ref const(QString) title,
             ref const(QString) text, StandardButtons buttons = StandardButton.Ok,
             StandardButton defaultButton = StandardButton.NoButton);
/+ #if QT_VERSION < QT_VERSION_CHECK(7, 0, 0) +/
    pragma(inline, true) static int warning(QWidget parent, ref const(QString) title,
                                  ref const(QString) text,
                                  StandardButton button0, StandardButton button1)
    { return warning(parent, title, text, StandardButtons(button0), button1); }
/+ #endif +/

    static StandardButton critical(QWidget parent, ref const(QString) title,
             ref const(QString) text, StandardButtons buttons = StandardButton.Ok,
             StandardButton defaultButton = StandardButton.NoButton);
/+ #if QT_VERSION < QT_VERSION_CHECK(7, 0, 0) +/
    pragma(inline, true) static int critical(QWidget parent, ref const(QString) title,
                                   ref const(QString) text,
                                   StandardButton button0, StandardButton button1)
    { return critical(parent, title, text, StandardButtons(button0), button1); }
/+ #endif +/

    static void about(QWidget parent, ref const(QString) title, ref const(QString) text);
    static void aboutQt(QWidget parent, ref const(QString) title = globalInitVar!QString);

/+ #if QT_DEPRECATED_SINCE(6,2) +/
    // the following functions are obsolete:
    /+ QT_DEPRECATED_VERSION_X_6_2("Use the overload taking StandardButtons instead.") +/this(ref const(QString) title, ref const(QString) text, Icon icon,
                      int button0, int button1, int button2,
                      QWidget parent = null,
                      /+ Qt:: +/qt.core.namespace.WindowFlags f = /+ Qt:: +/qt.core.namespace.WindowType.Dialog | /+ Qt:: +/qt.core.namespace.WindowType.MSWindowsFixedSizeDialogHint);

    /+ QT_DEPRECATED_VERSION_X_6_2("Use the overload taking StandardButtons instead.") +/
        static int information(QWidget parent, ref const(QString) title,
                               ref const(QString) text,
                               int button0, int button1 = 0, int button2 = 0);
    /+ QT_DEPRECATED_VERSION_X_6_2("Use the overload taking StandardButtons instead.") +/
        static int information(QWidget parent, ref const(QString) title,
                               ref const(QString) text,
                               ref const(QString) button0Text,
                               ref const(QString) button1Text = globalInitVar!QString,
                               ref const(QString) button2Text = globalInitVar!QString,
                               int defaultButtonNumber = 0,
                               int escapeButtonNumber = -1);

    /+ QT_DEPRECATED_VERSION_X_6_2("Use the overload taking StandardButtons instead.") +/
        static int question(QWidget parent, ref const(QString) title,
                            ref const(QString) text,
                            int button0, int button1 = 0, int button2 = 0);
    /+ QT_DEPRECATED_VERSION_X_6_2("Use the overload taking StandardButtons instead.") +/
        static int question(QWidget parent, ref const(QString) title,
                            ref const(QString) text,
                            ref const(QString) button0Text,
                            ref const(QString) button1Text = globalInitVar!QString,
                            ref const(QString) button2Text = globalInitVar!QString,
                            int defaultButtonNumber = 0,
                            int escapeButtonNumber = -1);

    /+ QT_DEPRECATED_VERSION_X_6_2("Use the overload taking StandardButtons instead.") +/
        static int warning(QWidget parent, ref const(QString) title,
                           ref const(QString) text,
                           int button0, int button1, int button2 = 0);
    /+ QT_DEPRECATED_VERSION_X_6_2("Use the overload taking StandardButtons instead.") +/
        static int warning(QWidget parent, ref const(QString) title,
                           ref const(QString) text,
                           ref const(QString) button0Text,
                           ref const(QString) button1Text = globalInitVar!QString,
                           ref const(QString) button2Text = globalInitVar!QString,
                           int defaultButtonNumber = 0,
                           int escapeButtonNumber = -1);

    /+ QT_DEPRECATED_VERSION_X_6_2("Use the overload taking StandardButtons instead.") +/
        static int critical(QWidget parent, ref const(QString) title,
                            ref const(QString) text,
                            int button0, int button1, int button2 = 0);
    /+ QT_DEPRECATED_VERSION_X_6_2("Use the overload taking StandardButtons instead.") +/
        static int critical(QWidget parent, ref const(QString) title,
                            ref const(QString) text,
                            ref const(QString) button0Text,
                            ref const(QString) button1Text = globalInitVar!QString,
                            ref const(QString) button2Text = globalInitVar!QString,
                            int defaultButtonNumber = 0,
                            int escapeButtonNumber = -1);

    /+ QT_DEPRECATED_VERSION_X_6_2("Use button() and QPushButton::text() instead.") +/
        final QString buttonText(int button) const;
    /+ QT_DEPRECATED_VERSION_X_6_2("Use addButton() instead.") +/
        final void setButtonText(int button, ref const(QString) text);
/+ #endif +/

    final QString informativeText() const;
    final void setInformativeText(ref const(QString) text);

/+ #if QT_CONFIG(textedit) +/
    final QString detailedText() const;
    final void setDetailedText(ref const(QString) text);
/+ #endif +/

//    final void setWindowTitle(ref const(QString) title);
//    final void setWindowModality(/+ Qt:: +/qt.core.namespace.WindowModality windowModality);

/+ #if QT_DEPRECATED_SINCE(6,2) +/
    /+ QT_DEPRECATED_VERSION_X_6_2("Use QStyle::standardIcon() instead.") +/
        static QPixmap standardIcon(Icon icon);
/+ #endif +/

/+ Q_SIGNALS +/public:
    @QSignal final void buttonClicked(QAbstractButton button);

/+ #ifdef Q_CLANG_QDOC
public Q_SLOTS:
    int exec() override;
#endif +/

protected:
    override bool event(QEvent e);
    override void resizeEvent(QResizeEvent event);
    override void showEvent(QShowEvent event);
    override void closeEvent(QCloseEvent event);
    override void keyPressEvent(QKeyEvent event);
    override void changeEvent(QEvent event);

private:
    /+ Q_PRIVATE_SLOT(d_func(), void _q_buttonClicked(QAbstractButton *))
    Q_PRIVATE_SLOT(d_func(), void _q_clicked(QPlatformDialogHelper::StandardButton, QPlatformDialogHelper::ButtonRole))

    Q_DISABLE_COPY(QMessageBox) +/
    /+ Q_DECLARE_PRIVATE(QMessageBox) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QMessageBox.StandardButtons.enum_type) operator |(QMessageBox.StandardButtons.enum_type f1, QMessageBox.StandardButtons.enum_type f2)/+noexcept+/{return QFlags!(QMessageBox.StandardButtons.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QMessageBox.StandardButtons.enum_type) operator |(QMessageBox.StandardButtons.enum_type f1, QFlags!(QMessageBox.StandardButtons.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QMessageBox.StandardButtons.enum_type) operator &(QMessageBox.StandardButtons.enum_type f1, QMessageBox.StandardButtons.enum_type f2)/+noexcept+/{return QFlags!(QMessageBox.StandardButtons.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QMessageBox.StandardButtons.enum_type) operator &(QMessageBox.StandardButtons.enum_type f1, QFlags!(QMessageBox.StandardButtons.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QMessageBox.StandardButtons.enum_type) operator ^(QMessageBox.StandardButtons.enum_type f1, QMessageBox.StandardButtons.enum_type f2)/+noexcept+/{return QFlags!(QMessageBox.StandardButtons.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QMessageBox.StandardButtons.enum_type) operator ^(QMessageBox.StandardButtons.enum_type f1, QFlags!(QMessageBox.StandardButtons.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QMessageBox.StandardButtons.enum_type f1, QMessageBox.StandardButtons.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QMessageBox.StandardButtons.enum_type f1, QFlags!(QMessageBox.StandardButtons.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QMessageBox.StandardButtons.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QMessageBox.StandardButtons.enum_type f1, QMessageBox.StandardButtons.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QMessageBox.StandardButtons.enum_type f1, QFlags!(QMessageBox.StandardButtons.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QMessageBox.StandardButtons.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QMessageBox.StandardButtons.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QMessageBox.StandardButtons.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QMessageBox.StandardButtons.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QMessageBox.StandardButtons.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QMessageBox.StandardButtons operator ~(QMessageBox.StandardButtons.enum_type e)/+noexcept+/{return~QMessageBox.StandardButtons(e);}+/
/+pragma(inline, true) void operator |(QMessageBox.StandardButtons.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QMessageBox.StandardButtons.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QMessageBox::StandardButtons)
#define QT_REQUIRE_VERSION(argc, argv, str) { QString s = QString::fromLatin1(str);\
QString sq = QString::fromLatin1(qVersion()); \
if ((sq.section(QChar::fromLatin1('.'),0,0).toInt()<<16)+\
(sq.section(QChar::fromLatin1('.'),1,1).toInt()<<8)+\
sq.section(QChar::fromLatin1('.'),2,2).toInt()<(s.section(QChar::fromLatin1('.'),0,0).toInt()<<16)+\
(s.section(QChar::fromLatin1('.'),1,1).toInt()<<8)+\
s.section(QChar::fromLatin1('.'),2,2).toInt()) { \
if (!qApp){ \
    new QApplication(argc,argv); \
} \
QString s = QApplication::tr("Executable '%1' requires Qt "\
 "%2, found Qt %3.").arg(qAppName()).arg(QString::fromLatin1(\
str)).arg(QString::fromLatin1(qVersion())); QMessageBox::critical(0, QApplication::tr(\
"Incompatible Qt Library Error"), s, QMessageBox::Abort, 0); qFatal("%s", s.toLatin1().data()); }} +/


