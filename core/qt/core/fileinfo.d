/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.core.fileinfo;
extern(C++):

import qt.config;
import qt.core.datetime;
import qt.core.dir;
import qt.core.file;
import qt.core.global;
import qt.core.list;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.helpers;

/+ class QDir; +/
extern(C++, class) struct QDirIteratorPrivate;
/+ class QDateTime; +/
extern(C++, class) struct QFileInfoPrivate;

@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QFileInfo
{
private:
    /+ friend class QDirIteratorPrivate; +/
public:
    /+ explicit +/this(QFileInfoPrivate* d);

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(ref const(QString) file);
    //this(const QFile &file);
    this(ref const(QDir) dir, ref const(QString) file);
    @disable this(this);
    this(ref const(QFileInfo) fileinfo);
    ~this();

    /+ref QFileInfo operator =(ref const(QFileInfo) fileinfo);+/
    /+ QFileInfo &operator=(QFileInfo &&other) noexcept { swap(other); return *this; } +/

    /+ void swap(QFileInfo &other) noexcept
    { qSwap(d_ptr, other.d_ptr); } +/

    /+bool operator ==(ref const(QFileInfo) fileinfo) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QFileInfo) fileinfo) const { return !(operator==(fileinfo)); }+/

    void setFile(ref const(QString) file);
    //void setFile(const QFile &file);
    void setFile(ref const(QDir) dir, ref const(QString) file);
    bool exists() const;
    static bool exists(ref const(QString) file);
    void refresh();

    QString filePath() const;
    QString absoluteFilePath() const;
    QString canonicalFilePath() const;
    QString fileName() const;
    QString baseName() const;
    QString completeBaseName() const;
    QString suffix() const;
    QString bundleName() const;
    QString completeSuffix() const;

    QString path() const;
    QString absolutePath() const;
    QString canonicalPath() const;
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

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use QFileInfo::symLinkTarget() instead") +/
        QString readLink() const;
/+ #endif +/
    QString symLinkTarget() const;

    QString owner() const;
    uint ownerId() const;
    QString group() const;
    uint groupId() const;

    bool permission(QFile.Permissions permissions) const;
    QFile.Permissions permissions() const;

    qint64 size() const;

    // ### Qt6: inline these functions
/+ #if QT_DEPRECATED_SINCE(5, 10) +/
    /+ QT_DEPRECATED_X("Use either birthTime() or metadataChangeTime()") +/
        QDateTime created() const;
/+ #endif +/
    QDateTime birthTime() const;
    QDateTime metadataChangeTime() const;
    QDateTime lastModified() const;
    QDateTime lastRead() const;
    QDateTime fileTime(QFile.FileTime time) const;

    bool caching() const;
    void setCaching(bool on);

protected:
    QSharedDataPointer!(QFileInfoPrivate) d_ptr;

private:
    /+ friend class QFileInfoGatherer; +/
    void stat();
    /+ QFileInfoPrivate* d_func(); +/
    /+ inline const QFileInfoPrivate* d_func() const
    {
        return d_ptr.constData();
    } +/
}

/+ Q_DECLARE_SHARED(QFileInfo) +/

alias QFileInfoList = QList!(QFileInfo);

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QFileInfo &);
#endif


Q_DECLARE_METATYPE(QFileInfo) +/

