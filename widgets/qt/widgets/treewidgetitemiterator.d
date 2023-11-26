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
module qt.widgets.treewidgetitemiterator;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.scopedpointer;
import qt.helpers;
import qt.widgets.treewidget;

/+ QT_REQUIRE_CONFIG(treewidget); +/


extern(C++, class) struct QTreeModel;

extern(C++, class) struct QTreeWidgetItemIteratorPrivate;
/// Binding for C++ class [QTreeWidgetItemIterator](https://doc.qt.io/qt-6/qtreewidgetitemiterator.html).
extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QTreeWidgetItemIterator
{
private:
    /+ friend class QTreeModel; +/

public:
    enum IteratorFlag {
        All           = 0x00000000,
        Hidden        = 0x00000001,
        NotHidden     = 0x00000002,
        Selected      = 0x00000004,
        Unselected    = 0x00000008,
        Selectable    = 0x00000010,
        NotSelectable = 0x00000020,
        DragEnabled   = 0x00000040,
        DragDisabled  = 0x00000080,
        DropEnabled   = 0x00000100,
        DropDisabled  = 0x00000200,
        HasChildren   = 0x00000400,
        NoChildren    = 0x00000800,
        Checked       = 0x00001000,
        NotChecked    = 0x00002000,
        Enabled       = 0x00004000,
        Disabled      = 0x00008000,
        Editable      = 0x00010000,
        NotEditable   = 0x00020000,
        UserFlag      = 0x01000000 // The first flag that can be used by the user.
    }
    /+ Q_DECLARE_FLAGS(IteratorFlags, IteratorFlag) +/
alias IteratorFlags = QFlags!(IteratorFlag);
    @disable this(this);
    this(ref const(QTreeWidgetItemIterator) it);
    /+ explicit +/this(QTreeWidget widget, IteratorFlags flags = IteratorFlag.All);
    /+ explicit +/this(QTreeWidgetItem item, IteratorFlags flags = IteratorFlag.All);
    ~this();

    /+ref QTreeWidgetItemIterator operator =(ref const(QTreeWidgetItemIterator) it);+/

    ref QTreeWidgetItemIterator opUnary(string op)() if (op == "++");
    /+pragma(inline, true) const(QTreeWidgetItemIterator) operator ++(int)
    {
        QTreeWidgetItemIterator it = this;
        ++(this);
        return it;
    }+/
    pragma(inline, true) ref QTreeWidgetItemIterator opOpAssign(string op)(int n) if (op == "+")
    {
        if (n < 0)
            return (this) -= (-n);
        while (current && n--)
            ++(this);
        return this;
    }

    ref QTreeWidgetItemIterator opUnary(string op)() if (op == "--");
    /+pragma(inline, true) const(QTreeWidgetItemIterator) operator --(int)
    {
        QTreeWidgetItemIterator it = this;
        --(this);
        return it;
    }+/
    pragma(inline, true) ref QTreeWidgetItemIterator opOpAssign(string op)(int n) if (op == "-")
    {
        if (n < 0)
            return (this) += (-n);
        while (current && n--)
            --(this);
        return this;
    }

    pragma(inline, true) QTreeWidgetItem opUnary(string op)() const if (op == "*")
    {
        return current;
    }

private:
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    bool matchesFlags(const(QTreeWidgetItem) item) const;
    }));
    QScopedPointer!(QTreeWidgetItemIteratorPrivate) d_ptr;
    QTreeWidgetItem current;
    IteratorFlags flags;
    /+ Q_DECLARE_PRIVATE(QTreeWidgetItemIterator) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QTreeWidgetItemIterator.IteratorFlags.enum_type) operator |(QTreeWidgetItemIterator.IteratorFlags.enum_type f1, QTreeWidgetItemIterator.IteratorFlags.enum_type f2)/+noexcept+/{return QFlags!(QTreeWidgetItemIterator.IteratorFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QTreeWidgetItemIterator.IteratorFlags.enum_type) operator |(QTreeWidgetItemIterator.IteratorFlags.enum_type f1, QFlags!(QTreeWidgetItemIterator.IteratorFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QTreeWidgetItemIterator.IteratorFlags.enum_type) operator &(QTreeWidgetItemIterator.IteratorFlags.enum_type f1, QTreeWidgetItemIterator.IteratorFlags.enum_type f2)/+noexcept+/{return QFlags!(QTreeWidgetItemIterator.IteratorFlags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QTreeWidgetItemIterator.IteratorFlags.enum_type) operator &(QTreeWidgetItemIterator.IteratorFlags.enum_type f1, QFlags!(QTreeWidgetItemIterator.IteratorFlags.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) void operator +(QTreeWidgetItemIterator.IteratorFlags.enum_type f1, QTreeWidgetItemIterator.IteratorFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QTreeWidgetItemIterator.IteratorFlags.enum_type f1, QFlags!(QTreeWidgetItemIterator.IteratorFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QTreeWidgetItemIterator.IteratorFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QTreeWidgetItemIterator.IteratorFlags.enum_type f1, QTreeWidgetItemIterator.IteratorFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QTreeWidgetItemIterator.IteratorFlags.enum_type f1, QFlags!(QTreeWidgetItemIterator.IteratorFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QTreeWidgetItemIterator.IteratorFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) QIncompatibleFlag operator |(QTreeWidgetItemIterator.IteratorFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+pragma(inline, true) void operator +(int f1, QTreeWidgetItemIterator.IteratorFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QTreeWidgetItemIterator.IteratorFlags.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QTreeWidgetItemIterator.IteratorFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QTreeWidgetItemIterator.IteratorFlags.enum_type f1, int f2)/+noexcept+/;+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QTreeWidgetItemIterator::IteratorFlags) +/
