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

/+ #ifdef open
#error qfile.h must be included before any header file that defines open
#endif +/


extern(C++, class) struct QTemporaryFile;
extern(C++, class) struct QFilePrivate;

class /+ Q_CORE_EXPORT +/ QFile : QFileDevice
{
/+ #ifndef QT_NO_QOBJECT +/
    mixin(Q_OBJECT);
/+ #endif
    Q_DECLARE_PRIVATE(QFile) +/

public:
    this();
    this(ref const(QString) name);
/+ #ifndef QT_NO_QOBJECT +/
    /+ explicit +/this(QObject parent);
    this(ref const(QString) name, QObject parent);
/+ #endif +/
    ~this();

    override QString fileName() const;
    final void setFileName(ref const(QString) name);

/+ #if defined(Q_OS_DARWIN) +/
    // Mac always expects filenames in UTF-8... and decomposed...
    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
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
            return QString.fromLocal8Bit(localFileName);
        }
    }
/+ #endif

#if QT_DEPRECATED_SINCE(5,0)
    typedef QByteArray (*EncoderFn)(const QString &fileName);
    typedef QString (*DecoderFn)(const QByteArray &localfileName);
    QT_DEPRECATED static void setEncodingFunction(EncoderFn) {}
    QT_DEPRECATED static void setDecodingFunction(DecoderFn) {}
#endif +/

    final bool exists() const;
    static bool exists(ref const(QString) fileName);

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use QFile::symLinkTarget() instead") +/
        final QString readLink() const;
    /+ QT_DEPRECATED_X("Use QFile::symLinkTarget(QString) instead") +/
        static QString readLink(ref const(QString) fileName);
/+ #endif +/
    final QString symLinkTarget() const;
    static QString symLinkTarget(ref const(QString) fileName);

    final bool remove();
    static bool remove(ref const(QString) fileName);

    final bool moveToTrash();
    static bool moveToTrash(ref const(QString) fileName, QString* pathInTrash = null);

    final bool rename(ref const(QString) newName);
    static bool rename(ref const(QString) oldName, ref const(QString) newName);

    final bool link(ref const(QString) newName);
    static bool link(ref const(QString) oldname, ref const(QString) newName);

    /+ bool copy(const QString &newName); +/
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

protected:
/+ #ifdef QT_NO_QOBJECT
    QFile(QFilePrivate &dd);
#else +/
    this(ref QFilePrivate dd, QObject parent = null);
/+ #endif +/

private:
    /+ friend class QTemporaryFile; +/
    /+ Q_DISABLE_COPY(QFile) +/
}

