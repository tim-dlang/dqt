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
module qt.core.resource;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.datetime;
import qt.core.global;
import qt.core.locale;
import qt.core.scopedpointer;
import qt.core.string;
import qt.core.stringlist;
import qt.helpers;

extern(C++, class) struct QResourcePrivate;

/// Binding for C++ class [QResource](https://doc.qt.io/qt-5/qresource.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QResource
{
public:
    enum Compression {
        NoCompression,
        ZlibCompression,
        ZstdCompression
    }

    @disable this();
    this(ref const(QString) file, ref const(QLocale) locale);
    this(ref const(QString) file)
    {
        const(QLocale) locale = QLocale.create();
        this(file, locale);
    }
    ~this();

    void setFileName(ref const(QString) file);
    QString fileName() const;
    QString absoluteFilePath() const;

    void setLocale(ref const(QLocale) locale);
    QLocale locale() const;

    bool isValid() const;

    Compression compressionAlgorithm() const;
    qint64 size() const;
    const(uchar)* data() const;
    qint64 uncompressedSize() const;
    QByteArray uncompressedData() const;
    QDateTime lastModified() const;

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use QDir::addSearchPath() instead") +/
        static void addSearchPath(ref const(QString) path);
    /+ QT_DEPRECATED_X("Use QDir::searchPaths() instead") +/
        static QStringList searchPaths();
/+ #endif
#if QT_DEPRECATED_SINCE(5, 15) +/
    /+ QT_DEPRECATED_VERSION_X_5_15("Use QResource::compressionAlgorithm() instead") +/
        bool isCompressed() const;
/+ #endif +/

    static bool registerResource(ref const(QString) rccFilename, ref const(QString) resourceRoot=globalInitVar!QString);
    static bool unregisterResource(ref const(QString) rccFilename, ref const(QString) resourceRoot=globalInitVar!QString);

    static bool registerResource(const(uchar)* rccData, ref const(QString) resourceRoot=globalInitVar!QString);
    static bool unregisterResource(const(uchar)* rccData, ref const(QString) resourceRoot=globalInitVar!QString);

protected:
    /+ friend class QResourceFileEngine; +/
    /+ friend class QResourceFileEngineIterator; +/
    bool isDir() const;
    pragma(inline, true) bool isFile() const { return !isDir(); }
    QStringList children() const;

protected:
    QScopedPointer!(QResourcePrivate) d_ptr;

private:
    /+ Q_DECLARE_PRIVATE(QResource) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

