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
module qt.core.fileinfo;
extern(C++):

import qt.config;
import qt.core.datetime;
import qt.core.dir;
import qt.core.file;
import qt.core.filedevice;
import qt.core.global;
import qt.core.list;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.helpers;

extern(C++, class) struct QDirIteratorPrivate;
extern(C++, class) struct QFileInfoPrivate;
static if (false)
{
/+ #define QFILEINFO_MAYBE_EXPLICIT Q_IMPLICIT +/
}
/+ #define QFILEINFO_MAYBE_EXPLICIT explicit +/

/// Binding for C++ class [QFileInfo](https://doc.qt.io/qt-6/qfileinfo.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QFileInfo
{
private:
    /+ friend class QDirIteratorPrivate; +/
public:
    /+ explicit +/this(QFileInfoPrivate* d);

/+ #ifdef QT_IMPLICIT_QFILEINFO_CONSTRUCTION
#define QFILEINFO_MAYBE_EXPLICIT Q_IMPLICIT
#else
#define QFILEINFO_MAYBE_EXPLICIT explicit
#endif +/

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ QFILEINFO_MAYBE_EXPLICIT +/this(ref const(QString) file);
    // /+ QFILEINFO_MAYBE_EXPLICIT +/this(const QFileDevice &file);
    /+ QFILEINFO_MAYBE_EXPLICIT +/this(ref const(QDir) dir, ref const(QString) file);
    @disable this(this);
    this(ref const(QFileInfo) fileinfo);
/+ #ifdef Q_CLANG_QDOC
    QFileInfo(const std::filesystem::path &file);
    QFileInfo(const QDir &dir, const std::filesystem::path &file);
#elif QT_CONFIG(cxx17_filesystem)
    template<typename T, QtPrivate::ForceFilesystemPath<T> = 0>
    QFILEINFO_MAYBE_EXPLICIT QFileInfo(const T &file) : QFileInfo(QtPrivate::fromFilesystemPath(file)) { }

    template<typename T, QtPrivate::ForceFilesystemPath<T> = 0>
    QFILEINFO_MAYBE_EXPLICIT QFileInfo(const QDir &dir, const T &file) : QFileInfo(dir, QtPrivate::fromFilesystemPath(file))
    {
    }
#endif // QT_CONFIG(cxx17_filesystem)

#undef QFILEINFO_MAYBE_EXPLICIT +/

    ~this();

    /+ref QFileInfo operator =(ref const(QFileInfo) fileinfo);+/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QFileInfo) +/

    /+ void swap(QFileInfo &other) noexcept
    { qSwap(d_ptr, other.d_ptr); } +/

    /+bool operator ==(ref const(QFileInfo) fileinfo) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QFileInfo) fileinfo) const { return !(operator==(fileinfo)); }+/

    void setFile(ref const(QString) file);
    //void setFile(const QFileDevice &file);
    void setFile(ref const(QDir) dir, ref const(QString) file);
/+ #ifdef Q_CLANG_QDOC
    void setFile(const std::filesystem::path &file);
#elif QT_CONFIG(cxx17_filesystem)
    template<typename T, QtPrivate::ForceFilesystemPath<T> = 0>
    void setFile(const T &file) { setFile(QtPrivate::fromFilesystemPath(file)); }
#endif +/ // QT_CONFIG(cxx17_filesystem)

    bool exists() const;
    static bool exists(ref const(QString) file);
    void refresh();

    QString filePath() const;
    QString absoluteFilePath() const;
    QString canonicalFilePath() const;
/+ #if QT_CONFIG(cxx17_filesystem) || defined(Q_CLANG_QDOC)
    std::filesystem::path filesystemFilePath() const
    { return QtPrivate::toFilesystemPath(filePath()); }
    std::filesystem::path filesystemAbsoluteFilePath() const
    { return QtPrivate::toFilesystemPath(absoluteFilePath()); }
    std::filesystem::path filesystemCanonicalFilePath() const
    { return QtPrivate::toFilesystemPath(canonicalFilePath()); }
#endif +/ // QT_CONFIG(cxx17_filesystem)
    QString fileName() const;
    QString baseName() const;
    QString completeBaseName() const;
    QString suffix() const;
    QString bundleName() const;
    QString completeSuffix() const;

    QString path() const;
    QString absolutePath() const;
    QString canonicalPath() const;
/+ #if QT_CONFIG(cxx17_filesystem) || defined(Q_CLANG_QDOC)
    std::filesystem::path filesystemPath() const { return QtPrivate::toFilesystemPath(path()); }
    std::filesystem::path filesystemAbsolutePath() const
    { return QtPrivate::toFilesystemPath(absolutePath()); }
    std::filesystem::path filesystemCanonicalPath() const
    { return QtPrivate::toFilesystemPath(canonicalPath()); }
#endif +/ // QT_CONFIG(cxx17_filesystem)
    QDir dir() const;
    QDir absoluteDir() const;

    bool isReadable() const;
    bool isWritable() const;
    bool isExecutable() const;
    bool isHidden() const;
    bool isNativePath() const;

    bool isRelative() const;
    pragma(inline, true) bool isAbsolute() const { return !isRelative(); }
    bool makeAbsolute();

    bool isFile() const;
    bool isDir() const;
    bool isSymLink() const;
    bool isSymbolicLink() const;
    bool isShortcut() const;
    bool isJunction() const;
    bool isRoot() const;
    bool isBundle() const;

    QString symLinkTarget() const;
    QString junctionTarget() const;

/+ #if QT_CONFIG(cxx17_filesystem) || defined(Q_CLANG_QDOC)
    std::filesystem::path filesystemSymLinkTarget() const
    { return QtPrivate::toFilesystemPath(symLinkTarget()); }

    std::filesystem::path filesystemJunctionTarget() const
    { return QtPrivate::toFilesystemPath(junctionTarget()); }
#endif +/ // QT_CONFIG(cxx17_filesystem)

    QString owner() const;
    uint ownerId() const;
    QString group() const;
    uint groupId() const;

    bool permission(QFile.Permissions permissions) const;
    QFile.Permissions permissions() const;

    qint64 size() const;

    QDateTime birthTime() const { return fileTime(QFile.FileTime.FileBirthTime); }
    QDateTime metadataChangeTime() const { return fileTime(QFile.FileTime.FileMetadataChangeTime); }
    QDateTime lastModified() const { return fileTime(QFile.FileTime.FileModificationTime); }
    QDateTime lastRead() const { return fileTime(QFile.FileTime.FileAccessTime); }
    QDateTime fileTime(QFile.FileTime time) const;

    bool caching() const;
    void setCaching(bool on);
    void stat();

protected:
    QSharedDataPointer!(QFileInfoPrivate) d_ptr;

private:
    /+ QFileInfoPrivate* d_func(); +/
    /+ inline const QFileInfoPrivate* d_func() const
    {
        return d_ptr.constData();
    } +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QFileInfo) +/

//alias QFileInfoList = QList!(QFileInfo);

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QFileInfo &);
#endif


Q_DECLARE_METATYPE(QFileInfo) +/

