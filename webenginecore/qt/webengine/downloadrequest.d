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
module qt.webengine.downloadrequest;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.object;
import qt.core.scopedpointer;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.webengine.page;

extern(C++, class) struct QWebEngineDownloadRequestPrivate;
extern(C++, class) struct QWebEngineProfilePrivate;

class /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineDownloadRequest : QObject
{
    mixin(Q_OBJECT);
public:
    /+ Q_PROPERTY(quint32 id READ id CONSTANT FINAL)
    Q_PROPERTY(DownloadState state READ state NOTIFY stateChanged FINAL)
    Q_PROPERTY(SavePageFormat savePageFormat READ savePageFormat WRITE setSavePageFormat NOTIFY savePageFormatChanged FINAL)
    Q_PROPERTY(qint64 totalBytes READ totalBytes NOTIFY totalBytesChanged FINAL)
    Q_PROPERTY(qint64 receivedBytes READ receivedBytes NOTIFY receivedBytesChanged FINAL)
    Q_PROPERTY(QString mimeType READ mimeType FINAL)
    Q_PROPERTY(DownloadInterruptReason interruptReason READ interruptReason NOTIFY interruptReasonChanged FINAL)
    Q_PROPERTY(QString interruptReasonString READ interruptReasonString NOTIFY interruptReasonChanged FINAL)
    Q_PROPERTY(bool isFinished READ isFinished NOTIFY isFinishedChanged FINAL)
    Q_PROPERTY(bool isPaused READ isPaused NOTIFY isPausedChanged FINAL)
    Q_PROPERTY(bool isSavePageDownload READ isSavePageDownload CONSTANT FINAL)
    Q_PROPERTY(QUrl url READ url CONSTANT FINAL)
    Q_PROPERTY(QString suggestedFileName READ suggestedFileName CONSTANT FINAL)
    Q_PROPERTY(QString downloadDirectory READ downloadDirectory WRITE setDownloadDirectory NOTIFY downloadDirectoryChanged FINAL)
    Q_PROPERTY(QString downloadFileName READ downloadFileName WRITE setDownloadFileName NOTIFY downloadFileNameChanged FINAL) +/

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

    final quint32 id() const;
    final DownloadState state() const;
    final qint64 totalBytes() const;
    final qint64 receivedBytes() const;
    final QUrl url() const;
    final QString mimeType() const;
    final bool isFinished() const;
    final bool isPaused() const;
    final SavePageFormat savePageFormat() const;
    final void setSavePageFormat(SavePageFormat format);
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
    @QSignal final void stateChanged(DownloadState state);
    @QSignal final void savePageFormatChanged();
    @QSignal final void receivedBytesChanged();
    @QSignal final void totalBytesChanged();
    @QSignal final void interruptReasonChanged();
    @QSignal final void isFinishedChanged();
    @QSignal final void isPausedChanged();
    @QSignal final void downloadDirectoryChanged();
    @QSignal final void downloadFileNameChanged();

private:
    /+ Q_DISABLE_COPY(QWebEngineDownloadRequest) +/
    /+ Q_DECLARE_PRIVATE(QWebEngineDownloadRequest) +/

    /+ friend class QWebEngineProfilePrivate; +/

protected:
    this(QWebEngineDownloadRequestPrivate* , QObject parent = null);
    QScopedPointer!(QWebEngineDownloadRequestPrivate) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

