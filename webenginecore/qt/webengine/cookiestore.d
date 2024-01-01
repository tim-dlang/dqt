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
module qt.webengine.cookiestore;
extern(C++):

import qt.config;
import qt.core.object;
import qt.core.scopedpointer;
import qt.core.url;
import qt.helpers;
import qt.network.networkcookie;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct ContentBrowserClientQt;
extern(C++, class) struct CookieMonsterDelegateQt;
} // namespace QtWebEngineCore


extern(C++, class) struct QWebEngineCookieStorePrivate;
/// Binding for C++ class [QWebEngineCookieStore](https://doc.qt.io/qt-6/qwebenginecookiestore.html).
class /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineCookieStore : QObject
{
    mixin(Q_OBJECT);

public:
    struct FilterRequest {
        QUrl firstPartyUrl;
        QUrl origin;
        bool thirdParty;
        bool _reservedFlag;
        ushort _reservedType;
    }
    /+ virtual +/~this();

    /+ void setCookieFilter(const std::function<bool(const FilterRequest &)> &filterCallback); +/
    /+ void setCookieFilter(std::function<bool(const FilterRequest &)> &&filterCallback); +/
    final void setCookie(ref const(QNetworkCookie) cookie, ref const(QUrl) origin = globalInitVar!QUrl);
    final void deleteCookie(ref const(QNetworkCookie) cookie, ref const(QUrl) origin = globalInitVar!QUrl);
    final void deleteSessionCookies();
    final void deleteAllCookies();
    final void loadAllCookies();

/+ Q_SIGNALS +/public:
    @QSignal final void cookieAdded(ref const(QNetworkCookie) cookie);
    @QSignal final void cookieRemoved(ref const(QNetworkCookie) cookie);

private:
    /+ explicit +/this(QObject parent = null);
    /+ friend class QtWebEngineCore::ContentBrowserClientQt; +/
    /+ friend class QtWebEngineCore::CookieMonsterDelegateQt; +/
    /+ friend class QtWebEngineCore::ProfileAdapter; +/
    /+ Q_DISABLE_COPY(QWebEngineCookieStore) +/
    /+ Q_DECLARE_PRIVATE(QWebEngineCookieStore) +/
    QScopedPointer!(QWebEngineCookieStorePrivate) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ Q_DECLARE_METATYPE(QWebEngineCookieStore *) +/

