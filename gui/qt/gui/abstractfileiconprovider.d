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
module qt.gui.abstractfileiconprovider;
extern(C++):

import qt.config;
import qt.core.fileinfo;
import qt.core.flags;
import qt.core.scopedpointer;
import qt.core.string;
import qt.gui.icon;
import qt.helpers;

extern(C++, class) struct QAbstractFileIconProviderPrivate;

/// Binding for C++ class [QAbstractFileIconProvider](https://doc.qt.io/qt-6/qabstractfileiconprovider.html).
class /+ Q_GUI_EXPORT +/ QAbstractFileIconProvider
{
public:
    enum IconType { Computer, Desktop, Trashcan, Network, Drive, Folder, File }
    enum Option {
        DontUseCustomDirectoryIcons = 0x00000001
    }
    /+ Q_DECLARE_FLAGS(Options, Option) +/
alias Options = QFlags!(Option);
    this();
    /+ virtual +/~this();

    /+ virtual +/ QIcon icon(IconType) const;
    /+ virtual +/ QIcon icon(ref const(QFileInfo) ) const;
    /+ virtual +/ QString type(ref const(QFileInfo) ) const;

    /+ virtual +/ void setOptions(Options);
    /+ virtual +/ Options options() const;

protected:
    this(ref QAbstractFileIconProviderPrivate dd);
    QScopedPointer!(QAbstractFileIconProviderPrivate) d_ptr;

private:
    /+ Q_DECLARE_PRIVATE(QAbstractFileIconProvider) +/
    /+ Q_DISABLE_COPY(QAbstractFileIconProvider) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QAbstractFileIconProvider.Options.enum_type) operator |(QAbstractFileIconProvider.Options.enum_type f1, QAbstractFileIconProvider.Options.enum_type f2)nothrow{return QFlags!(QAbstractFileIconProvider.Options.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QAbstractFileIconProvider.Options.enum_type) operator |(QAbstractFileIconProvider.Options.enum_type f1, QFlags!(QAbstractFileIconProvider.Options.enum_type) f2)nothrow{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QAbstractFileIconProvider.Options.enum_type) operator &(QAbstractFileIconProvider.Options.enum_type f1, QAbstractFileIconProvider.Options.enum_type f2)nothrow{return QFlags!(QAbstractFileIconProvider.Options.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QAbstractFileIconProvider.Options.enum_type) operator &(QAbstractFileIconProvider.Options.enum_type f1, QFlags!(QAbstractFileIconProvider.Options.enum_type) f2)nothrow{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QAbstractFileIconProvider.Options.enum_type) operator ^(QAbstractFileIconProvider.Options.enum_type f1, QAbstractFileIconProvider.Options.enum_type f2)nothrow{return QFlags!(QAbstractFileIconProvider.Options.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QAbstractFileIconProvider.Options.enum_type) operator ^(QAbstractFileIconProvider.Options.enum_type f1, QFlags!(QAbstractFileIconProvider.Options.enum_type) f2)nothrow{return f2^f1;}+/
/+pragma(inline, true) void operator +(QAbstractFileIconProvider.Options.enum_type f1, QAbstractFileIconProvider.Options.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QAbstractFileIconProvider.Options.enum_type f1, QFlags!(QAbstractFileIconProvider.Options.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QAbstractFileIconProvider.Options.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(QAbstractFileIconProvider.Options.enum_type f1, QAbstractFileIconProvider.Options.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QAbstractFileIconProvider.Options.enum_type f1, QFlags!(QAbstractFileIconProvider.Options.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QAbstractFileIconProvider.Options.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QAbstractFileIconProvider.Options.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QAbstractFileIconProvider.Options.enum_type f1, int f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QAbstractFileIconProvider.Options.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QAbstractFileIconProvider.Options.enum_type f1, int f2)nothrow;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QAbstractFileIconProvider.Options operator ~(QAbstractFileIconProvider.Options.enum_type e)nothrow{return~QAbstractFileIconProvider.Options(e);}+/
/+pragma(inline, true) void operator |(QAbstractFileIconProvider.Options.enum_type f1, int f2)nothrow;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QAbstractFileIconProvider.Options.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QAbstractFileIconProvider::Options) +/
