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
module qt.webengine.page;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.global;
import qt.core.margins;
import qt.core.object;
import qt.core.point;
import qt.core.rect;
import qt.core.scopedpointer;
import qt.core.size;
import qt.core.string;
import qt.core.stringlist;
import qt.core.url;
import qt.gui.color;
import qt.gui.icon;
import qt.gui.pagelayout;
import qt.gui.pageranges;
import qt.gui.pagesize;
import qt.helpers;
import qt.network.authenticator;
import qt.webengine.certificateerror;
import qt.webengine.clientcertificateselection;
import qt.webengine.downloadrequest;
import qt.webengine.findtextresult;
import qt.webengine.fullscreenrequest;
import qt.webengine.history;
import qt.webengine.httprequest;
import qt.webengine.loadinginfo;
import qt.webengine.navigationrequest;
import qt.webengine.newwindowrequest;
import qt.webengine.profile;
import qt.webengine.quotarequest;
import qt.webengine.registerprotocolhandlerrequest;
import qt.webengine.scriptcollection;
import qt.webengine.settings;
import qt.webengine.urlrequestinterceptor;
version (QT_NO_ACTION) {} else
    import qt.gui.action;

extern(C++, class) struct QContextMenuBuilder;
extern(C++, class) struct QWebChannel;

class /+ Q_WEBENGINECORE_EXPORT +/ QWebEnginePage : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QString selectedText READ selectedText)
    Q_PROPERTY(bool hasSelection READ hasSelection)
    Q_PROPERTY(QUrl requestedUrl READ requestedUrl)
    Q_PROPERTY(qreal zoomFactor READ zoomFactor WRITE setZoomFactor)
    Q_PROPERTY(QString title READ title)
    Q_PROPERTY(QUrl url READ url WRITE setUrl)
    Q_PROPERTY(QUrl iconUrl READ iconUrl NOTIFY iconUrlChanged)
    Q_PROPERTY(QIcon icon READ icon NOTIFY iconChanged)
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor)
    Q_PROPERTY(QSizeF contentsSize READ contentsSize NOTIFY contentsSizeChanged)
    Q_PROPERTY(QPointF scrollPosition READ scrollPosition NOTIFY scrollPositionChanged)
    Q_PROPERTY(bool audioMuted READ isAudioMuted WRITE setAudioMuted NOTIFY audioMutedChanged)
    Q_PROPERTY(bool recentlyAudible READ recentlyAudible NOTIFY recentlyAudibleChanged)
    Q_PROPERTY(bool visible READ isVisible WRITE setVisible NOTIFY visibleChanged)
    Q_PROPERTY(LifecycleState lifecycleState READ lifecycleState WRITE setLifecycleState NOTIFY lifecycleStateChanged)
    Q_PROPERTY(LifecycleState recommendedState READ recommendedState NOTIFY recommendedStateChanged)
    Q_PROPERTY(qint64 renderProcessPid READ renderProcessPid NOTIFY renderProcessPidChanged)
    Q_PROPERTY(bool loading READ isLoading NOTIFY loadingChanged FINAL) +/

public:
    enum WebAction {
        NoWebAction = - 1,
        Back,
        Forward,
        Stop,
        Reload,

        Cut,
        Copy,
        Paste,

        Undo,
        Redo,
        SelectAll,
        ReloadAndBypassCache,

        PasteAndMatchStyle,

        OpenLinkInThisWindow,
        OpenLinkInNewWindow,
        OpenLinkInNewTab,
        CopyLinkToClipboard,
        DownloadLinkToDisk,

        CopyImageToClipboard,
        CopyImageUrlToClipboard,
        DownloadImageToDisk,

        CopyMediaUrlToClipboard,
        ToggleMediaControls,
        ToggleMediaLoop,
        ToggleMediaPlayPause,
        ToggleMediaMute,
        DownloadMediaToDisk,

        InspectElement,
        ExitFullScreen,
        RequestClose,
        Unselect,
        SavePage,
        OpenLinkInNewBackgroundTab,
        ViewSource,

        ToggleBold,
        ToggleItalic,
        ToggleUnderline,
        ToggleStrikethrough,

        AlignLeft,
        AlignCenter,
        AlignRight,
        AlignJustified,
        Indent,
        Outdent,

        InsertOrderedList,
        InsertUnorderedList,

        WebActionCount
    }
    /+ Q_ENUM(WebAction) +/

    enum FindFlag {
        FindBackward = 1,
        FindCaseSensitively = 2,
    }
    /+ Q_DECLARE_FLAGS(FindFlags, FindFlag) +/
alias FindFlags = QFlags!(FindFlag);
    enum WebWindowType {
        WebBrowserWindow,
        WebBrowserTab,
        WebDialog,
        WebBrowserBackgroundTab
    }
    /+ Q_ENUM(WebWindowType) +/

    enum PermissionPolicy {
        PermissionUnknown,
        PermissionGrantedByUser,
        PermissionDeniedByUser
    }
    /+ Q_ENUM(PermissionPolicy) +/

    // must match WebContentsAdapterClient::NavigationType
    enum NavigationType {
        NavigationTypeLinkClicked,
        NavigationTypeTyped,
        NavigationTypeFormSubmitted,
        NavigationTypeBackForward,
        NavigationTypeReload,
        NavigationTypeOther,
        NavigationTypeRedirect,
    }
    /+ Q_ENUM(NavigationType) +/

    enum Feature {
        Notifications = 0,
        Geolocation = 1,
        MediaAudioCapture = 2,
        MediaVideoCapture,
        MediaAudioVideoCapture,
        MouseLock,
        DesktopVideoCapture,
        DesktopAudioVideoCapture
    }
    /+ Q_ENUM(Feature) +/

    // Ex-QWebFrame enum

    enum FileSelectionMode {
        FileSelectOpen,
        FileSelectOpenMultiple,
        FileSelectUploadFolder,
    }
    /+ Q_ENUM(FileSelectionMode) +/

    // must match WebContentsAdapterClient::JavaScriptConsoleMessageLevel
    enum JavaScriptConsoleMessageLevel {
        InfoMessageLevel = 0,
        WarningMessageLevel,
        ErrorMessageLevel
    }
    /+ Q_ENUM(JavaScriptConsoleMessageLevel) +/

    // must match WebContentsAdapterClient::RenderProcessTerminationStatus
    enum RenderProcessTerminationStatus {
        NormalTerminationStatus = 0,
        AbnormalTerminationStatus,
        CrashedTerminationStatus,
        KilledTerminationStatus
    }
    /+ Q_ENUM(RenderProcessTerminationStatus) +/

    // must match WebContentsAdapterClient::LifecycleState
    enum /+ class +/ LifecycleState {
        Active,
        Frozen,
        Discarded,
    }
    /+ Q_ENUM(LifecycleState) +/

    /+ explicit +/this(QObject parent = null);
    this(QWebEngineProfile profile, QObject parent = null);
    ~this();
    final QWebEngineHistory history() const;

    final bool hasSelection() const;
    final QString selectedText() const;

    final QWebEngineProfile profile() const;

    version (QT_NO_ACTION) {} else
    {
        final QAction action(WebAction action) const;
    }
    /+ virtual +/ void triggerAction(WebAction action, bool checked = false);

    final void replaceMisspelledWord(ref const(QString) replacement);

    override bool event(QEvent);

    /+ void findText(const QString &subString, FindFlags options = {}, const std::function<void(const QWebEngineFindTextResult &)> &resultCallback = std::function<void(const QWebEngineFindTextResult &)>()); +/

    final void setFeaturePermission(ref const(QUrl) securityOrigin, Feature feature, PermissionPolicy policy);

    final bool isLoading() const;

    final void load(ref const(QUrl) url);
    final void load(ref const(QWebEngineHttpRequest) request);
    final void download(ref const(QUrl) url, ref const(QString) filename = globalInitVar!QString);
    final void setHtml(ref const(QString) html, ref const(QUrl) baseUrl = globalInitVar!QUrl);
    final void setContent(ref const(QByteArray) data, ref const(QString) mimeType = globalInitVar!QString, ref const(QUrl) baseUrl = globalInitVar!QUrl);

    /+ void toHtml(const std::function<void(const QString &)> &resultCallback) const; +/
    /+ void toPlainText(const std::function<void(const QString &)> &resultCallback) const; +/

    final QString title() const;
    final void setUrl(ref const(QUrl) url);
    final QUrl url() const;
    final QUrl requestedUrl() const;
    final QUrl iconUrl() const;
    final QIcon icon() const;

    final qreal zoomFactor() const;
    final void setZoomFactor(qreal factor);

    final QPointF scrollPosition() const;
    final QSizeF contentsSize() const;

    /+ void runJavaScript(const QString &scriptSource, const std::function<void(const QVariant &)> &resultCallback); +/
    /+ void runJavaScript(const QString &scriptSource, quint32 worldId = 0, const std::function<void(const QVariant &)> &resultCallback = {}); +/
    final ref QWebEngineScriptCollection scripts();
    final QWebEngineSettings* settings() const;

    final QWebChannel* webChannel() const;
    final void setWebChannel(QWebChannel* , quint32 worldId = 0);
    final QColor backgroundColor() const;
    final void setBackgroundColor(ref const(QColor) color);

    final void save(ref const(QString) filePath, QWebEngineDownloadRequest.SavePageFormat format
                                                    = QWebEngineDownloadRequest.SavePageFormat.MimeHtmlSaveFormat) const;

    final bool isAudioMuted() const;
    final void setAudioMuted(bool muted);
    final bool recentlyAudible() const;
    final qint64 renderProcessPid() const;

    final void printToPdf(ref const(QString) filePath,
                        ref const(QPageLayout) layout /+ = QPageLayout(QPageSize(QPageSize::A4), QPageLayout::Portrait, QMarginsF()) +/,
                        ref const(QPageRanges) ranges /+ = {} +/);
    /+ void printToPdf(const std::function<void(const QByteArray&)> &resultCallback,
                    const QPageLayout &layout = QPageLayout(QPageSize(QPageSize::A4), QPageLayout::Portrait, QMarginsF()),
                    const QPageRanges &ranges = {}); +/

    final void setInspectedPage(QWebEnginePage page);
    final QWebEnginePage inspectedPage() const;
    final void setDevToolsPage(QWebEnginePage page);
    final QWebEnginePage devToolsPage() const;

    final void setUrlRequestInterceptor(QWebEngineUrlRequestInterceptor interceptor);

    final LifecycleState lifecycleState() const;
    final void setLifecycleState(LifecycleState state);

    final LifecycleState recommendedState() const;

    final bool isVisible() const;
    final void setVisible(bool visible);

    //final void acceptAsNewWindow(ref ValueClass!(QWebEngineNewWindowRequest) request);

/+ Q_SIGNALS +/public:
    @QSignal final void loadStarted();
    @QSignal final void loadProgress(int progress);
    @QSignal final void loadFinished(bool ok);
    @QSignal final void loadingChanged(ref const(QWebEngineLoadingInfo) loadingInfo);

    @QSignal final void linkHovered(ref const(QString) url);
    @QSignal final void selectionChanged();
    @QSignal final void geometryChangeRequested(ref const(QRect) geom);
    @QSignal final void windowCloseRequested();

    @QSignal final void featurePermissionRequested(ref const(QUrl) securityOrigin, Feature feature);
    @QSignal final void featurePermissionRequestCanceled(ref const(QUrl) securityOrigin, Feature feature);
    @QSignal final void fullScreenRequested(QWebEngineFullScreenRequest fullScreenRequest);
    @QSignal final void quotaRequested(QWebEngineQuotaRequest quotaRequest);
    @QSignal final void registerProtocolHandlerRequested(QWebEngineRegisterProtocolHandlerRequest request);
    @QSignal final void selectClientCertificate(QWebEngineClientCertificateSelection clientCertSelection);
    @QSignal final void authenticationRequired(ref const(QUrl) requestUrl, QAuthenticator* authenticator);
    @QSignal final void proxyAuthenticationRequired(ref const(QUrl) requestUrl, QAuthenticator* authenticator, ref const(QString) proxyHost);

    @QSignal final void renderProcessTerminated(RenderProcessTerminationStatus terminationStatus, int exitCode);
    @QSignal final void certificateError(ref const(QWebEngineCertificateError) certificateError);
    //@QSignal final void navigationRequested(ref ValueClass!(QWebEngineNavigationRequest) request);
    //@QSignal final void newWindowRequested(ref ValueClass!(QWebEngineNewWindowRequest) request);

    // Ex-QWebFrame signals
    @QSignal final void titleChanged(ref const(QString) title);
    @QSignal final void urlChanged(ref const(QUrl) url);
    @QSignal final void iconUrlChanged(ref const(QUrl) url);
    @QSignal final void iconChanged(ref const(QIcon) icon);

    @QSignal final void scrollPositionChanged(ref const(QPointF) position);
    @QSignal final void contentsSizeChanged(ref const(QSizeF) size);
    @QSignal final void audioMutedChanged(bool muted);
    @QSignal final void recentlyAudibleChanged(bool recentlyAudible);
    @QSignal final void renderProcessPidChanged(qint64 pid);

    @QSignal final void pdfPrintingFinished(ref const(QString) filePath, bool success);
    @QSignal final void printRequested();

    @QSignal final void visibleChanged(bool visible);

    @QSignal final void lifecycleStateChanged(LifecycleState state);
    @QSignal final void recommendedStateChanged(LifecycleState state);

    @QSignal final void findTextFinished(ref const(QWebEngineFindTextResult) result);

    // TODO: fixme / rewrite bindPageToView
    @QSignal final void _q_aboutToDelete();

protected:
    /+ virtual +/ QWebEnginePage createWindow(WebWindowType type);
    /+ virtual +/ QStringList chooseFiles(FileSelectionMode mode, ref const(QStringList) oldFiles,
                                        ref const(QStringList) acceptedMimeTypes);
    /+ virtual +/ void javaScriptAlert(ref const(QUrl) securityOrigin, ref const(QString) msg);
    /+ virtual +/ bool javaScriptConfirm(ref const(QUrl) securityOrigin, ref const(QString) msg);
    /+ virtual +/ bool javaScriptPrompt(ref const(QUrl) securityOrigin, ref const(QString) msg,
                                      ref const(QString) defaultValue, QString* result);
    /+ virtual +/ void javaScriptConsoleMessage(JavaScriptConsoleMessageLevel level,
                                              ref const(QString) message, int lineNumber,
                                              ref const(QString) sourceID);
    /+ virtual +/ bool acceptNavigationRequest(ref const(QUrl) url, NavigationType type, bool isMainFrame);

private:
    /+ Q_DISABLE_COPY(QWebEnginePage) +/
    /+ Q_DECLARE_PRIVATE(QWebEnginePage) +/
    QScopedPointer!(QWebEnginePagePrivate) d_ptr;
/+ #ifndef QT_NO_ACTION
    Q_PRIVATE_SLOT(d_func(), void _q_webActionTriggered(bool checked))
#endif +/

    /+ friend class QContextMenuBuilder; +/
    /+ friend class QWebEngineView; +/
    /+ friend class QWebEngineViewPrivate; +/
    version (QT_NO_ACCESSIBILITY) {} else
    {
        /+ friend class QWebEngineViewAccessible; +/
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QWebEnginePage.FindFlags.enum_type) operator |(QWebEnginePage.FindFlags.enum_type f1, QWebEnginePage.FindFlags.enum_type f2)/+noexcept+/{return QFlags!(QWebEnginePage.FindFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QWebEnginePage.FindFlags.enum_type) operator |(QWebEnginePage.FindFlags.enum_type f1, QFlags!(QWebEnginePage.FindFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QWebEnginePage.FindFlags.enum_type) operator &(QWebEnginePage.FindFlags.enum_type f1, QWebEnginePage.FindFlags.enum_type f2)/+noexcept+/{return QFlags!(QWebEnginePage.FindFlags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QWebEnginePage.FindFlags.enum_type) operator &(QWebEnginePage.FindFlags.enum_type f1, QFlags!(QWebEnginePage.FindFlags.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) void operator +(QWebEnginePage.FindFlags.enum_type f1, QWebEnginePage.FindFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QWebEnginePage.FindFlags.enum_type f1, QFlags!(QWebEnginePage.FindFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QWebEnginePage.FindFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QWebEnginePage.FindFlags.enum_type f1, QWebEnginePage.FindFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QWebEnginePage.FindFlags.enum_type f1, QFlags!(QWebEnginePage.FindFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QWebEnginePage.FindFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) QIncompatibleFlag operator |(QWebEnginePage.FindFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+pragma(inline, true) void operator +(int f1, QWebEnginePage.FindFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QWebEnginePage.FindFlags.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QWebEnginePage.FindFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QWebEnginePage.FindFlags.enum_type f1, int f2)/+noexcept+/;+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QWebEnginePage::FindFlags)
Q_WEBENGINECORE_EXPORT QDataStream &operator<<(QDataStream &stream,
                                               const QWebEngineHistory &history);
Q_WEBENGINECORE_EXPORT QDataStream &operator>>(QDataStream &stream, QWebEngineHistory &history); +/

