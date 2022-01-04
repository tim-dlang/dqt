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
module qt.core.diriterator;
extern(C++):

import qt.config;
import qt.core.dir;
import qt.core.fileinfo;
import qt.core.flags;
import qt.core.scopedpointer;
import qt.core.string;
import qt.core.stringlist;
import qt.helpers;

/// Binding for C++ class [QDirIterator](https://doc.qt.io/qt-5/qdiriterator.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QDirIterator {
public:
    enum IteratorFlag {
        NoIteratorFlags = 0x0,
        FollowSymlinks = 0x1,
        Subdirectories = 0x2
    }
    /+ Q_DECLARE_FLAGS(IteratorFlags, IteratorFlag) +/
alias IteratorFlags = QFlags!(IteratorFlag);
    this(ref const(QDir) dir, IteratorFlags flags = IteratorFlag.NoIteratorFlags);
    this(ref const(QString) path,
                     IteratorFlags flags = IteratorFlag.NoIteratorFlags);
    this(ref const(QString) path,
                     QDir.Filters filter,
                     IteratorFlags flags = IteratorFlag.NoIteratorFlags);
    this(ref const(QString) path,
                     ref const(QStringList) nameFilters,
                     QDir.Filters filters = QDir.Filter.NoFilter,
                     IteratorFlags flags = IteratorFlag.NoIteratorFlags);

    ~this();

    QString next();
    bool hasNext() const;

    QString fileName() const;
    QString filePath() const;
    QFileInfo fileInfo() const;
    QString path() const;

private:
    /+ Q_DISABLE_COPY(QDirIterator) +/
@disable this(this);
/+this(ref const(QDirIterator));+//+ref QDirIterator operator =(ref const(QDirIterator));+/
    QScopedPointer!(QDirIteratorPrivate) d;
    /+ friend class QDir; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QDirIterator.IteratorFlags.enum_type) operator |(QDirIterator.IteratorFlags.enum_type f1, QDirIterator.IteratorFlags.enum_type f2)/+noexcept+/{return QFlags!(QDirIterator.IteratorFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QDirIterator.IteratorFlags.enum_type) operator |(QDirIterator.IteratorFlags.enum_type f1, QFlags!(QDirIterator.IteratorFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QDirIterator.IteratorFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QDirIterator::IteratorFlags) +/
