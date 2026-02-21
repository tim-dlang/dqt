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
module qt.widgets.fontdialog;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.object;
import qt.core.string;
import qt.gui.font;
import qt.helpers;
import qt.widgets.dialog;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(fontdialog); +/


extern(C++, class) struct QFontDialogPrivate;

/// Binding for C++ class [QFontDialog](https://doc.qt.io/qt-5/qfontdialog.html).
class /+ Q_WIDGETS_EXPORT +/ QFontDialog : QDialog
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QFontDialog) +/
    /+ Q_PROPERTY(QFont currentFont READ currentFont WRITE setCurrentFont NOTIFY currentFontChanged)
    Q_PROPERTY(FontDialogOptions options READ options WRITE setOptions) +/

public:
    enum FontDialogOption {
        NoButtons           = 0x00000001,
        DontUseNativeDialog = 0x00000002,
        ScalableFonts       = 0x00000004,
        NonScalableFonts    = 0x00000008,
        MonospacedFonts     = 0x00000010,
        ProportionalFonts   = 0x00000020
    }
    /+ Q_ENUM(FontDialogOption) +/

    /+ Q_DECLARE_FLAGS(FontDialogOptions, FontDialogOption) +/
alias FontDialogOptions = QFlags!(FontDialogOption);
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QFont) initial, QWidget parent = null);
    ~this();

    final void setCurrentFont(ref const(QFont) font);
    final QFont currentFont() const;

    final QFont selectedFont() const;

    final void setOption(FontDialogOption option, bool on = true);
    final bool testOption(FontDialogOption option) const;
    final void setOptions(FontDialogOptions options);
    final FontDialogOptions options() const;

    alias open = QDialog.open;
    final void open(QObject receiver, const(char)* member);

    override void setVisible(bool visible);

    static QFont getFont(bool* ok, QWidget parent = null);
    static QFont getFont(bool* ok, ref const(QFont) initial, QWidget parent = null, ref const(QString) title = globalInitVar!QString,
                             FontDialogOptions options = FontDialogOptions());

/+ Q_SIGNALS +/public:
    @QSignal final void currentFontChanged(ref const(QFont) font);
    @QSignal final void fontSelected(ref const(QFont) font);

protected:
    override void changeEvent(QEvent event);
    override void done(int result);
    override bool eventFilter(QObject object, QEvent event);

private:
    /+ Q_DISABLE_COPY(QFontDialog) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_sizeChanged(const QString &))
    Q_PRIVATE_SLOT(d_func(), void _q_familyHighlighted(int))
    Q_PRIVATE_SLOT(d_func(), void _q_writingSystemHighlighted(int))
    Q_PRIVATE_SLOT(d_func(), void _q_styleHighlighted(int))
    Q_PRIVATE_SLOT(d_func(), void _q_sizeHighlighted(int))
    Q_PRIVATE_SLOT(d_func(), void _q_updateSample()) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QFontDialog.FontDialogOptions.enum_type) operator |(QFontDialog.FontDialogOptions.enum_type f1, QFontDialog.FontDialogOptions.enum_type f2)nothrow{return QFlags!(QFontDialog.FontDialogOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QFontDialog.FontDialogOptions.enum_type) operator |(QFontDialog.FontDialogOptions.enum_type f1, QFlags!(QFontDialog.FontDialogOptions.enum_type) f2)nothrow{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QFontDialog.FontDialogOptions.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QFontDialog::FontDialogOptions) +/
