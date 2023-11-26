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
module qt.core.file;
extern(C++):

import core.stdc.stdio;
import qt.config;
import qt.core.bytearray;
import qt.core.filedevice;
import qt.core.global;
import qt.core.object;
import qt.core.string;
import qt.helpers;

/+ #if QT_CONFIG(cxx17_filesystem)
#elif defined(Q_CLANG_QDOC)
namespace std {
    namespace filesystem {
        class path {
        };
    };
};
#endif

#ifdef open
#error qfile.h must be included before any header file that defines open
#endif


#if QT_CONFIG(cxx17_filesystem)
namespace QtPrivate {
inline QString fromFilesystemPath(const std::filesystem::path &path)
{
#ifdef Q_OS_WIN
    return QString::fromStdWString(path.native());
#else
    return QString::fromStdString(path.native());
#endif
}

inline std::filesystem::path toFilesystemPath(const QString &path)
{
    return std::filesystem::path(reinterpret_cast<const char16_t *>(path.cbegin()),
                                 reinterpret_cast<const char16_t *>(path.cend()));
}

// Both std::filesystem::path and QString (without QT_NO_CAST_FROM_ASCII) can be implicitly
// constructed from string literals so we force the std::fs::path parameter to only
// accept std::fs::path with no implicit conversions.
template<typename T>
using ForceFilesystemPath = typename std::enable_if_t<std::is_same_v<std::filesystem::path, T>, int>;
}
#endif +/ // QT_CONFIG(cxx17_filesystem)

extern(C++, class) struct QTemporaryFile;
extern(C++, class) struct QFilePrivate;

/// Binding for C++ class [QFile](https://doc.qt.io/qt-6/qfile.html).
class /+ Q_CORE_EXPORT +/ QFile : QFileDevice
{
/+ #ifndef QT_NO_QOBJECT +/
    mixin(Q_OBJECT);
/+ #endif
    Q_DECLARE_PRIVATE(QFile) +/

public:
    this();
    this(ref const(QString) name);
/+ #ifdef Q_CLANG_QDOC
    QFile(const std::filesystem::path &name);
#elif QT_CONFIG(cxx17_filesystem)
    template<typename T, QtPrivate::ForceFilesystemPath<T> = 0>
    QFile(const T &name) : QFile(QtPrivate::fromFilesystemPath(name))
    {
    }
#endif // QT_CONFIG(cxx17_filesystem)

#ifndef QT_NO_QOBJECT +/
    /+ explicit +/this(QObject parent);
    this(ref const(QString) name, QObject parent);

/+ #ifdef Q_CLANG_QDOC
    QFile(const std::filesystem::path &path, QObject *parent);
#elif QT_CONFIG(cxx17_filesystem)
    template<typename T, QtPrivate::ForceFilesystemPath<T> = 0>
    QFile(const T &path, QObject *parent) : QFile(QtPrivate::fromFilesystemPath(path), parent)
    {
    }
#endif // QT_CONFIG(cxx17_filesystem)
#endif +/ // !QT_NO_QOBJECT
    ~this();

    override QString fileName() const;
/+ #if QT_CONFIG(cxx17_filesystem) || defined(Q_CLANG_QDOC)
    std::filesystem::path filesystemFileName() const
    { return QtPrivate::toFilesystemPath(fileName()); }
#endif +/
    final void setFileName(ref const(QString) name);
/+ #ifdef Q_CLANG_QDOC
    void setFileName(const std::filesystem::path &name);
#elif QT_CONFIG(cxx17_filesystem)
    template<typename T, QtPrivate::ForceFilesystemPath<T> = 0>
    void setFileName(const T &name)
    {
        setFileName(QtPrivate::fromFilesystemPath(name));
    }
#endif // QT_CONFIG(cxx17_filesystem)

#if defined(Q_OS_DARWIN) +/
    // Mac always expects filenames in UTF-8... and decomposed...
    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        pragma(inline, true) static QByteArray encodeName(ref const(QString) fileName)
        {
            return fileName.normalized(QString.NormalizationForm.NormalizationForm_D).toUtf8();
        }
        static QString decodeName(ref const(QByteArray) localFileName)
        {
            // note: duplicated in qglobal.cpp (qEnvironmentVariable)
            return QString.fromUtf8(localFileName).normalized(QString.NormalizationForm.NormalizationForm_C);
        }
        pragma(inline, true) static QString decodeName(const(char)* localFileName)
        {
            return QString.fromUtf8(localFileName).normalized(QString.NormalizationForm.NormalizationForm_C);
        }
    }
    else
    {
    /+ #else +/
        pragma(inline, true) static QByteArray encodeName(ref const(QString) fileName)
        {
            return fileName.toLocal8Bit();
        }
        static QString decodeName(ref const(QByteArray) localFileName)
        {
            return QString.fromLocal8Bit(localFileName);
        }
        pragma(inline, true) static QString decodeName(const(char)* localFileName)
        {
            import qt.core.bytearrayview;

            return QString.fromLocal8Bit(cast(QByteArrayView) (localFileName));
        }
    }
/+ #endif +/

    final bool exists() const;
    static bool exists(ref const(QString) fileName);

    final QString symLinkTarget() const;
    static QString symLinkTarget(ref const(QString) fileName);

    final bool remove();
    static bool remove(ref const(QString) fileName);

    final bool moveToTrash();
    static bool moveToTrash(ref const(QString) fileName, QString* pathInTrash = null);

    final bool rename(ref const(QString) newName);
/+ #ifdef Q_CLANG_QDOC
    bool rename(const std::filesystem::path &newName);
#elif QT_CONFIG(cxx17_filesystem)
    template<typename T, QtPrivate::ForceFilesystemPath<T> = 0>
    bool rename(const T &newName)
    {
        return rename(QtPrivate::fromFilesystemPath(newName));
    }
#endif +/ // QT_CONFIG(cxx17_filesystem)
    static bool rename(ref const(QString) oldName, ref const(QString) newName);

    final bool link(ref const(QString) newName);
/+ #ifdef Q_CLANG_QDOC
    bool link(const std::filesystem::path &newName);
#elif QT_CONFIG(cxx17_filesystem)
    template<typename T, QtPrivate::ForceFilesystemPath<T> = 0>
    bool link(const T &newName)
    {
        return link(QtPrivate::fromFilesystemPath(newName));
    }
#endif +/ // QT_CONFIG(cxx17_filesystem)
    static bool link(ref const(QString) oldname, ref const(QString) newName);

    /+ bool copy(const QString &newName); +/
/+ #ifdef Q_CLANG_QDOC
    bool copy(const std::filesystem::path &newName);
#elif QT_CONFIG(cxx17_filesystem)
    template<typename T, QtPrivate::ForceFilesystemPath<T> = 0>
    bool copy(const T &newName)
    {
        return copy(QtPrivate::fromFilesystemPath(newName));
    }
#endif +/ // QT_CONFIG(cxx17_filesystem)
    /+ static bool copy(const QString &fileName, const QString &newName); +/

    override bool open(OpenMode flags);
    //final bool open(FILE* f, OpenMode ioFlags, FileHandleFlags handleFlags=FileHandleFlag.DontCloseHandle);
    final bool open(int fd, OpenMode ioFlags, FileHandleFlags handleFlags=FileHandleFlag.DontCloseHandle);

    override qint64 size() const;

    override bool resize(qint64 sz);
    static bool resize(ref const(QString) filename, qint64 sz);

    override Permissions permissions() const;
    static Permissions permissions(ref const(QString) filename);
    override bool setPermissions(Permissions permissionSpec);
    static bool setPermissions(ref const(QString) filename, Permissions permissionSpec);
/+ #ifdef Q_CLANG_QDOC
    static Permissions permissions(const std::filesystem::path &filename);
    static bool setPermissions(const std::filesystem::path &filename, Permissions permissionSpec);
#elif QT_CONFIG(cxx17_filesystem)
    template<typename T,  QtPrivate::ForceFilesystemPath<T> = 0>
    static Permissions permissions(const T &filename)
    {
        return permissions(QtPrivate::fromFilesystemPath(filename));
    }
    template<typename T, QtPrivate::ForceFilesystemPath<T> = 0>
    static bool setPermissions(const T &filename, Permissions permissionSpec)
    {
        return setPermissions(QtPrivate::fromFilesystemPath(filename), permissionSpec);
    }
#endif +/ // QT_CONFIG(cxx17_filesystem)

protected:
/+ #ifdef QT_NO_QOBJECT
    QFile(QFilePrivate &dd);
#else +/
    this(ref QFilePrivate dd, QObject parent = null);
/+ #endif +/

private:
    /+ friend class QTemporaryFile; +/
    /+ Q_DISABLE_COPY(QFile) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

