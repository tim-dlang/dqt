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
module qt.widgets.colordialog;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.gui.color;
import qt.gui.rgb;
import qt.helpers;
import qt.widgets.dialog;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(colordialog); +/


extern(C++, class) struct QColorDialogPrivate;

/// Binding for C++ class [QColorDialog](https://doc.qt.io/qt-5/qcolordialog.html).
class /+ Q_WIDGETS_EXPORT +/ QColorDialog : QDialog
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QColorDialog) +/
    /+ Q_PROPERTY(QColor currentColor READ currentColor WRITE setCurrentColor
               NOTIFY currentColorChanged)
    Q_PROPERTY(ColorDialogOptions options READ options WRITE setOptions) +/

public:
    enum ColorDialogOption {
        ShowAlphaChannel    = 0x00000001,
        NoButtons           = 0x00000002,
        DontUseNativeDialog = 0x00000004
    }
    /+ Q_ENUM(ColorDialogOption) +/

    /+ Q_DECLARE_FLAGS(ColorDialogOptions, ColorDialogOption) +/
alias ColorDialogOptions = QFlags!(ColorDialogOption);
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QColor) initial, QWidget parent = null);
    ~this();

    final void setCurrentColor(ref const(QColor) color);
    final QColor currentColor() const;

    final QColor selectedColor() const;

    final void setOption(ColorDialogOption option, bool on = true);
    final bool testOption(ColorDialogOption option) const;
    final void setOptions(ColorDialogOptions options);
    final ColorDialogOptions options() const;

    alias open = QDialog.open;
    final void open(QObject receiver, const(char)* member);

    override void setVisible(bool visible);

    static QColor getColor(ref const(QColor) initial /+ = Qt::white +/,
                               QWidget parent = null,
                               ref const(QString) title = globalInitVar!QString,
                               ColorDialogOptions options = ColorDialogOptions());

/+ #if QT_DEPRECATED_SINCE(5, 12) +/
    /+ QT_DEPRECATED_X("Use getColor()") +/ static QRgb getRgba(QRgb rgba = 0xffffffff, bool* ok = null, QWidget parent = null);
/+ #endif +/

    static int customCount();
    static QColor customColor(int index);
    static void setCustomColor(int index, QColor color);
    static QColor standardColor(int index);
    static void setStandardColor(int index, QColor color);

/+ Q_SIGNALS +/public:
    @QSignal final void currentColorChanged(ref const(QColor) color);
    @QSignal final void colorSelected(ref const(QColor) color);

protected:
    override void changeEvent(QEvent event);
    override void done(int result);

private:
    /+ Q_DISABLE_COPY(QColorDialog) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_addCustom())
    Q_PRIVATE_SLOT(d_func(), void _q_newHsv(int h, int s, int v))
    Q_PRIVATE_SLOT(d_func(), void _q_newColorTypedIn(QRgb rgb))
    Q_PRIVATE_SLOT(d_func(), void _q_nextCustom(int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_newCustom(int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_newStandard(int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_pickScreenColor())
    Q_PRIVATE_SLOT(d_func(), void _q_updateColorPicking()) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QColorDialog.ColorDialogOptions.enum_type) operator |(QColorDialog.ColorDialogOptions.enum_type f1, QColorDialog.ColorDialogOptions.enum_type f2)/+noexcept+/{return QFlags!(QColorDialog.ColorDialogOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QColorDialog.ColorDialogOptions.enum_type) operator |(QColorDialog.ColorDialogOptions.enum_type f1, QFlags!(QColorDialog.ColorDialogOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QColorDialog.ColorDialogOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QColorDialog::ColorDialogOptions) +/
