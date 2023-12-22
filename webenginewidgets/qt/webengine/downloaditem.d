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
module qt.webengine.downloaditem;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.object;
import qt.core.scopedpointer;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.webengine.page;

extern(C++, class) struct QWebEngineDownloadItemPrivate;
extern(C++, class) struct QWebEngineProfilePrivate;

/// Binding for C++ class [QWebEngineDownloadItem](https://doc.qt.io/qt-5/qwebenginedownloaditem.html).
class /+ QWEBENGINEWIDGETS_EXPORT +/ QWebEngineDownloadItem : QObject
{
    mixin(Q_OBJECT);
public:
    ~this();

    enum DownloadState {
        DownloadRequested,
        DownloadInProgress,
        DownloadCompleted,
        DownloadCancelled,
        DownloadInterrupted
    }
    /+ Q_ENUM(DownloadState) +/

    enum SavePageFormat {
        UnknownSaveFormat = -1,
        SingleHtmlSaveFormat,
        CompleteHtmlSaveFormat,
        MimeHtmlSaveFormat
    }
    /+ Q_ENUM(SavePageFormat) +/

    enum DownloadInterruptReason {
        NoReason = 0,
        FileFailed = 1,
        FileAccessDenied = 2,
        FileNoSpace = 3,
        FileNameTooLong = 5,
        FileTooLarge = 6,
        FileVirusInfected = 7,
        FileTransientError = 10,
        FileBlocked = 11,
        FileSecurityCheckFailed = 12,
        FileTooShort = 13,
        FileHashMismatch = 14,
        NetworkFailed = 20,
        NetworkTimeout = 21,
        NetworkDisconnected = 22,
        NetworkServerDown = 23,
        NetworkInvalidRequest = 24,
        ServerFailed = 30,
        //ServerNoRange = 31,
        ServerBadContent = 33,
        ServerUnauthorized = 34,
        ServerCertProblem = 35,
        ServerForbidden = 36,
        ServerUnreachable = 37,
        UserCanceled = 40,
        //UserShutdown = 41,
        //Crash = 50
    }
    /+ Q_ENUM(DownloadInterruptReason) +/

    enum DownloadType {
        Attachment = 0,
        DownloadAttribute,
        UserRequested,
        SavePage
    }
    /+ Q_ENUM(DownloadType) +/

    final quint32 id() const;
    final DownloadState state() const;
    final qint64 totalBytes() const;
    final qint64 receivedBytes() const;
    final QUrl url() const;
    final QString mimeType() const;
/+ #if QT_DEPRECATED_SINCE(5, 14)
#if QT_VERSION >= QT_VERSION_CHECK(5, 14, 0) +/
    /+ QT_DEPRECATED_VERSION_X(5, 14, "Use downloadDirectory() and downloadFileName() instead") +/
        final QString path() const;
    /+ QT_DEPRECATED_VERSION_X(5, 14, "Use setDownloadDirectory() and setDownloadFileName() instead") +/
        final void setPath(QString path);
/+ #else
    QT_DEPRECATED_X("Use downloadDirectory() and downloadFileName() instead")
    QString path() const;
    QT_DEPRECATED_X("Use setDownloadDirectory() and setDownloadFileName() instead")
    void setPath(QString path);
#endif
#endif +/
    final bool isFinished() const;
    final bool isPaused() const;
    final SavePageFormat savePageFormat() const;
    final void setSavePageFormat(SavePageFormat format);
    final DownloadType /+ Q_DECL_DEPRECATED +/ type() const;
    final DownloadInterruptReason interruptReason() const;
    final QString interruptReasonString() const;
    final bool isSavePageDownload() const;
    final QString suggestedFileName() const;
    final QString downloadDirectory() const;
    final void setDownloadDirectory(ref const(QString) directory);
    final QString downloadFileName() const;
    final void setDownloadFileName(ref const(QString) fileName);

    final QWebEnginePage page() const;

public /+ Q_SLOTS +/:
    @QSlot final void accept();
    @QSlot final void cancel();
    @QSlot final void pause();
    @QSlot final void resume();

/+ Q_SIGNALS +/public:
    @QSignal final void finished();
    @QSignal final void stateChanged(DownloadState state);
    @QSignal final void downloadProgress(qint64 bytesReceived, qint64 bytesTotal);
    @QSignal final void isPausedChanged(bool isPaused);

private:
    /+ Q_DISABLE_COPY(QWebEngineDownloadItem) +/
    /+ Q_DECLARE_PRIVATE(QWebEngineDownloadItem) +/

    /+ friend class QWebEngineProfilePrivate; +/

    this(QWebEngineDownloadItemPrivate*, QObject parent = null);
    QScopedPointer!(QWebEngineDownloadItemPrivate) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

