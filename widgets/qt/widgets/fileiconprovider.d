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
module qt.widgets.fileiconprovider;
extern(C++):

import qt.config;
import qt.core.fileinfo;
import qt.core.flags;
import qt.core.scopedpointer;
import qt.core.string;
import qt.gui.icon;
import qt.helpers;

extern(C++, class) struct QFileIconProviderPrivate;

/// Binding for C++ class [QFileIconProvider](https://doc.qt.io/qt-5/qfileiconprovider.html).
class /+ Q_WIDGETS_EXPORT +/ QFileIconProvider
{
public:
    this();
    /+ virtual +/~this();
    enum IconType { Computer, Desktop, Trashcan, Network, Drive, Folder, File }

    enum Option {
        DontUseCustomDirectoryIcons = 0x00000001
    }
    /+ Q_DECLARE_FLAGS(Options, Option) +/
alias Options = QFlags!(Option);
    /+ virtual +/ QIcon icon(IconType type) const;
    /+ virtual +/ QIcon icon(ref const(QFileInfo) info) const;
    /+ virtual +/ QString type(ref const(QFileInfo) info) const;

    final void setOptions(Options options);
    final Options options() const;

private:
    /+ Q_DECLARE_PRIVATE(QFileIconProvider) +/
    QScopedPointer!(QFileIconProviderPrivate) d_ptr;
    /+ Q_DISABLE_COPY(QFileIconProvider) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QFileIconProvider.Options.enum_type) operator |(QFileIconProvider.Options.enum_type f1, QFileIconProvider.Options.enum_type f2)/+noexcept+/{return QFlags!(QFileIconProvider.Options.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QFileIconProvider.Options.enum_type) operator |(QFileIconProvider.Options.enum_type f1, QFlags!(QFileIconProvider.Options.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QFileIconProvider.Options.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QFileIconProvider::Options) +/
