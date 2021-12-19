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
module qt.core.dir;
extern(C++):

import qt.config;
import qt.core.fileinfo;
import qt.core.flags;
import qt.core.qchar;
import qt.core.shareddata;
import qt.core.string;
import qt.core.stringlist;
import qt.core.typeinfo;
import qt.helpers;

extern(C++, class) struct QDirPrivate;

/// Binding for C++ class [QDir](https://doc.qt.io/qt-5/qdir.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QDir
{
public:
    enum Filter { Dirs        = 0x001,
                  Files       = 0x002,
                  Drives      = 0x004,
                  NoSymLinks  = 0x008,
                  AllEntries  = Filter.Dirs | Filter.Files | Filter.Drives,
                  TypeMask    = 0x00f,

                  Readable    = 0x010,
                  Writable    = 0x020,
                  Executable  = 0x040,
                  PermissionMask    = 0x070,

                  Modified    = 0x080,
                  Hidden      = 0x100,
                  System      = 0x200,

                  AccessMask  = 0x3F0,

                  AllDirs       = 0x400,
                  CaseSensitive = 0x800,
                  NoDot         = 0x2000,
                  NoDotDot      = 0x4000,
                  NoDotAndDotDot = Filter.NoDot | Filter.NoDotDot,

                  NoFilter = -1
    }
    /+ Q_DECLARE_FLAGS(Filters, Filter) +/
alias Filters = QFlags!(Filter);
    enum SortFlag { Name        = 0x00,
                    Time        = 0x01,
                    Size        = 0x02,
                    Unsorted    = 0x03,
                    SortByMask  = 0x03,

                    DirsFirst   = 0x04,
                    Reversed    = 0x08,
                    IgnoreCase  = 0x10,
                    DirsLast    = 0x20,
                    LocaleAware = 0x40,
                    Type        = 0x80,
                    NoSort = -1
    }
    /+ Q_DECLARE_FLAGS(SortFlags, SortFlag) +/
alias SortFlags = QFlags!(SortFlag);
    @disable this(this);
    this(ref const(QDir) );
    @disable this();
    this(ref const(QString) path/* = globalInitVar!QString*/);
    this(ref const(QString) path, ref const(QString) nameFilter,
             SortFlags sort = SortFlags(SortFlag.Name | SortFlag.IgnoreCase), Filters filter = Filter.AllEntries);
    ~this();

    /+ref QDir operator =(ref const(QDir) );+/
/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+/+ QT_DEPRECATED_X("Use QDir::setPath() instead") +/
        ref QDir operator =(ref const(QString) path);+/
/+ #endif +/
    /+ QDir &operator=(QDir &&other) noexcept { swap(other); return *this; } +/

    /+ void swap(QDir &other) noexcept
    { qSwap(d_ptr, other.d_ptr); } +/

    void setPath(ref const(QString) path);
    QString path() const;
    QString absolutePath() const;
    QString canonicalPath() const;

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use QDir::addSearchPath() instead") +/
        static void addResourceSearchPath(ref const(QString) path);
/+ #endif +/

    static void setSearchPaths(ref const(QString) prefix, ref const(QStringList) searchPaths);
    static void addSearchPath(ref const(QString) prefix, ref const(QString) path);
    static QStringList searchPaths(ref const(QString) prefix);

    QString dirName() const;
    QString filePath(ref const(QString) fileName) const;
    QString absoluteFilePath(ref const(QString) fileName) const;
    QString relativeFilePath(ref const(QString) fileName) const;

    static QString toNativeSeparators(ref const(QString) pathName);
    static QString fromNativeSeparators(ref const(QString) pathName);

    bool cd(ref const(QString) dirName);
    bool cdUp();

    QStringList nameFilters() const;
    void setNameFilters(ref const(QStringList) nameFilters);

    Filters filter() const;
    void setFilter(Filters filter);
    SortFlags sorting() const;
    void setSorting(SortFlags sort);

    uint count() const;
    bool isEmpty(Filters filters = Filters(Filter.AllEntries | Filter.NoDotAndDotDot)) const;

    QString opIndex(int) const;

    static QStringList nameFiltersFromString(ref const(QString) nameFilter);

    QStringList entryList(Filters filters = Filter.NoFilter, SortFlags sort = SortFlag.NoSort) const;
    QStringList entryList(ref const(QStringList) nameFilters, Filters filters = Filter.NoFilter,
                              SortFlags sort = SortFlag.NoSort) const;

    QFileInfoList entryInfoList(Filters filters = Filter.NoFilter, SortFlags sort = SortFlag.NoSort) const;
    QFileInfoList entryInfoList(ref const(QStringList) nameFilters, Filters filters = Filter.NoFilter,
                                    SortFlags sort = SortFlag.NoSort) const;

    bool mkdir(ref const(QString) dirName) const;
    bool rmdir(ref const(QString) dirName) const;
    bool mkpath(ref const(QString) dirPath) const;
    bool rmpath(ref const(QString) dirPath) const;

    bool removeRecursively();

    bool isReadable() const;
    bool exists() const;
    bool isRoot() const;

    static bool isRelativePath(ref const(QString) path);
    pragma(inline, true) static bool isAbsolutePath(ref const(QString) path) { return !isRelativePath(path); }
    bool isRelative() const;
    pragma(inline, true) bool isAbsolute() const { return !isRelative(); }
    bool makeAbsolute();

    /+bool operator ==(ref const(QDir) dir) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QDir) dir) const {  return !operator==(dir); }+/

    bool remove(ref const(QString) fileName);
    bool rename(ref const(QString) oldName, ref const(QString) newName);
    bool exists(ref const(QString) name) const;

    static QFileInfoList drives();

    pragma(inline, true) static QChar listSeparator()/+ noexcept+/
    {
        static if((versionIsSet!("Windows") && !versionIsSet!("Cygwin")))
        {
            return QChar(QLatin1Char(';'));
        }
        else
        {
            return QChar(QLatin1Char(':'));
        }
    }

    static QChar separator(); // ### Qt6: Make it inline

    static bool setCurrent(ref const(QString) path);
    pragma(inline, true) static QDir current() { auto tmp = currentPath(); return QDir(tmp); }
    static QString currentPath();

    pragma(inline, true) static QDir home() { auto tmp = homePath(); return QDir(tmp); }
    static QString homePath();
    pragma(inline, true) static QDir root() { auto tmp = rootPath(); return QDir(tmp); }
    static QString rootPath();
    pragma(inline, true) static QDir temp() { auto tmp = tempPath(); return QDir(tmp); }
    static QString tempPath();

/+ #if QT_CONFIG(regularexpression) +/
    static bool match(ref const(QStringList) filters, ref const(QString) fileName);
    static bool match(ref const(QString) filter, ref const(QString) fileName);
/+ #endif +/

    static QString cleanPath(ref const(QString) path);
    void refresh() const;

protected:
    /+ explicit +/this(ref QDirPrivate d);

    QSharedDataPointer!(QDirPrivate) d_ptr;

private:
    /+ friend class QDirIterator; +/
    // Q_DECLARE_PRIVATE equivalent for shared data pointers
    /+ QDirPrivate* d_func(); +/
    /+ inline const QDirPrivate* d_func() const
    {
        return d_ptr.constData();
    } +/

}
/+pragma(inline, true) QFlags!(QDir.Filters.enum_type) operator |(QDir.Filters.enum_type f1, QDir.Filters.enum_type f2)/+noexcept+/{return QFlags!(QDir.Filters.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QDir.Filters.enum_type) operator |(QDir.Filters.enum_type f1, QFlags!(QDir.Filters.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QDir.Filters.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_SHARED(QDir)
Q_DECLARE_OPERATORS_FOR_FLAGS(QDir::Filters) +/
/+pragma(inline, true) QFlags!(QDir.SortFlags.enum_type) operator |(QDir.SortFlags.enum_type f1, QDir.SortFlags.enum_type f2)/+noexcept+/{return QFlags!(QDir.SortFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QDir.SortFlags.enum_type) operator |(QDir.SortFlags.enum_type f1, QFlags!(QDir.SortFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QDir.SortFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QDir::SortFlags)
#ifndef QT_NO_DEBUG_STREAM
class QDebug;
Q_CORE_EXPORT QDebug operator<<(QDebug debug, QDir::Filters filters);
Q_CORE_EXPORT QDebug operator<<(QDebug debug, const QDir &dir);
#endif +/

