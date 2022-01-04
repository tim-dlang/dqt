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
module qt.widgets.dialogbuttonbox;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.list;
import qt.core.namespace;
import qt.core.string;
import qt.helpers;
import qt.widgets.abstractbutton;
import qt.widgets.pushbutton;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(dialogbuttonbox); +/



extern(C++, class) struct QDialogButtonBoxPrivate;

/// Binding for C++ class [QDialogButtonBox](https://doc.qt.io/qt-5/qdialogbuttonbox.html).
class /+ Q_WIDGETS_EXPORT +/ QDialogButtonBox : QWidget
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(Qt::Orientation orientation READ orientation WRITE setOrientation)
    Q_PROPERTY(StandardButtons standardButtons READ standardButtons WRITE setStandardButtons)
    Q_PROPERTY(bool centerButtons READ centerButtons WRITE setCenterButtons) +/

public:
    enum ButtonRole {
        // keep this in sync with QMessageBox::ButtonRole and QPlatformDialogHelper::ButtonRole
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
        // keep this in sync with QMessageBox::StandardButton and QPlatformDialogHelper::StandardButton
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

/+ #ifndef Q_MOC_RUN +/
        FirstButton        = StandardButton.Ok,
        LastButton         = StandardButton.RestoreDefaults
/+ #endif +/
    }

    /+ Q_DECLARE_FLAGS(StandardButtons, StandardButton) +/
alias StandardButtons = QFlags!(StandardButton);    /+ Q_FLAG(StandardButtons) +/

    enum ButtonLayout {
        // keep this in sync with QPlatformDialogHelper::ButtonLayout
        WinLayout,
        MacLayout,
        KdeLayout,
        GnomeLayout,
        // MacModelessLayout,
        AndroidLayout = ButtonLayout.GnomeLayout + 2 // ### Qt 6: reorder
    }

    this(QWidget parent = null);
    this(/+ Qt:: +/qt.core.namespace.Orientation orientation, QWidget parent = null);
    /+ explicit +/this(StandardButtons buttons, QWidget parent = null);
    this(StandardButtons buttons, /+ Qt:: +/qt.core.namespace.Orientation orientation,
                         QWidget parent = null);
    ~this();

    final void setOrientation(/+ Qt:: +/qt.core.namespace.Orientation orientation);
    final /+ Qt:: +/qt.core.namespace.Orientation orientation() const;

    final void addButton(QAbstractButton button, ButtonRole role);
    final QPushButton addButton(ref const(QString) text, ButtonRole role);
    final QPushButton addButton(StandardButton button);
    final void removeButton(QAbstractButton button);
    final void clear();

    final QList!(QAbstractButton) buttons() const;
    final ButtonRole buttonRole(QAbstractButton button) const;

    final void setStandardButtons(StandardButtons buttons);
    final StandardButtons standardButtons() const;
    final StandardButton standardButton(QAbstractButton button) const;
    final QPushButton button(StandardButton which) const;

    final void setCenterButtons(bool center);
    final bool centerButtons() const;

/+ Q_SIGNALS +/public:
    @QSignal final void clicked(QAbstractButton button);
    @QSignal final void accepted();
    @QSignal final void helpRequested();
    @QSignal final void rejected();

protected:
    override void changeEvent(QEvent event);
    override bool event(QEvent event);

private:
    /+ Q_DISABLE_COPY(QDialogButtonBox) +/
    /+ Q_DECLARE_PRIVATE(QDialogButtonBox) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_handleButtonClicked())
    Q_PRIVATE_SLOT(d_func(), void _q_handleButtonDestroyed()) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QDialogButtonBox.StandardButtons.enum_type) operator |(QDialogButtonBox.StandardButtons.enum_type f1, QDialogButtonBox.StandardButtons.enum_type f2)/+noexcept+/{return QFlags!(QDialogButtonBox.StandardButtons.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QDialogButtonBox.StandardButtons.enum_type) operator |(QDialogButtonBox.StandardButtons.enum_type f1, QFlags!(QDialogButtonBox.StandardButtons.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QDialogButtonBox.StandardButtons.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QDialogButtonBox::StandardButtons) +/
