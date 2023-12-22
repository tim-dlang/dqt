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
module qt.webengine.profile;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.list;
import qt.core.object;
import qt.core.scopedpointer;
import qt.core.string;
import qt.core.stringlist;
import qt.core.url;
import qt.helpers;
import qt.webengine.clientcertificatestore;
import qt.webengine.cookiestore;
import qt.webengine.downloaditem;
import qt.webengine.scriptcollection;
import qt.webengine.settings;
import qt.webengine.urlrequestinterceptor;
import qt.webengine.urlschemehandler;


/// Binding for C++ class [QWebEngineProfile](https://doc.qt.io/qt-5/qwebengineprofile.html).
class /+ QWEBENGINEWIDGETS_EXPORT +/ QWebEngineProfile : QObject {
    mixin(Q_OBJECT);
public:
    /+ explicit +/this(QObject parent = null);
    /+ explicit +/this(ref const(QString) name, QObject parent = null);
    /+ virtual +/~this();

    enum HttpCacheType {
        MemoryHttpCache,
        DiskHttpCache,
        NoCache
    }
    /+ Q_ENUM(HttpCacheType) +/

    enum PersistentCookiesPolicy {
        NoPersistentCookies,
        AllowPersistentCookies,
        ForcePersistentCookies
    }
    /+ Q_ENUM(PersistentCookiesPolicy) +/

    final QString storageName() const;
    final bool isOffTheRecord() const;

    final QString persistentStoragePath() const;
    final void setPersistentStoragePath(ref const(QString) path);

    final QString cachePath() const;
    final void setCachePath(ref const(QString) path);

    final QString httpUserAgent() const;
    final void setHttpUserAgent(ref const(QString) userAgent);

    final HttpCacheType httpCacheType() const;
    final void setHttpCacheType(HttpCacheType);

    final void setHttpAcceptLanguage(ref const(QString) httpAcceptLanguage);
    final QString httpAcceptLanguage() const;

    final PersistentCookiesPolicy persistentCookiesPolicy() const;
    final void setPersistentCookiesPolicy(PersistentCookiesPolicy);

    final int httpCacheMaximumSize() const;
    final void setHttpCacheMaximumSize(int maxSize);

    final QWebEngineCookieStore cookieStore();
/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    final void setRequestInterceptor(QWebEngineUrlRequestInterceptor interceptor);
/+ #endif +/
    final void setUrlRequestInterceptor(QWebEngineUrlRequestInterceptor interceptor);

    final void clearAllVisitedLinks();
    final void clearVisitedLinks(ref const(QList!(QUrl)) urls);
    final bool visitedLinksContainsUrl(ref const(QUrl) url) const;

    final QWebEngineSettings* settings() const;
    final QWebEngineScriptCollection* scripts() const;

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final const(QWebEngineUrlSchemeHandler) urlSchemeHandler(ref const(QByteArray) ) const;
    }));
    final void installUrlSchemeHandler(ref const(QByteArray) scheme, QWebEngineUrlSchemeHandler );
    final void removeUrlScheme(ref const(QByteArray) scheme);
    final void removeUrlSchemeHandler(QWebEngineUrlSchemeHandler );
    final void removeAllUrlSchemeHandlers();

    final void clearHttpCache();

    final void setSpellCheckLanguages(ref const(QStringList) languages);
    final QStringList spellCheckLanguages() const;
    final void setSpellCheckEnabled(bool enabled);
    final bool isSpellCheckEnabled() const;

    final void setUseForGlobalCertificateVerification(bool enabled = true);
    final bool isUsedForGlobalCertificateVerification() const;

    final QString downloadPath() const;
    final void setDownloadPath(ref const(QString) path);

    /+ void setNotificationPresenter(std::function<void(std::unique_ptr<QWebEngineNotification>)> notificationPresenter); +/

    final QWebEngineClientCertificateStore* clientCertificateStore();

    static QWebEngineProfile defaultProfile();

/+ Q_SIGNALS +/public:
    @QSignal final void downloadRequested(QWebEngineDownloadItem download);

private:
    /+ Q_DISABLE_COPY(QWebEngineProfile) +/
    /+ Q_DECLARE_PRIVATE(QWebEngineProfile) +/
    this(QWebEngineProfilePrivate* , QObject parent = null);

    /+ friend class QWebEnginePage; +/
    /+ friend class QWebEnginePagePrivate; +/
    /+ friend class QWebEngineUrlSchemeHandler; +/
    QScopedPointer!(QWebEngineProfilePrivate) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

