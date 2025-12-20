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
module qt.webengine.urlrequestinfo;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.scopedpointer;
import qt.core.url;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct InterceptedRequest;
} // namespace QtWebEngineCore


extern(C++, class) struct QWebEngineUrlRequestInfoPrivate;

/// Binding for C++ class [QWebEngineUrlRequestInfo](https://doc.qt.io/qt-6/qwebengineurlrequestinfo.html).
extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineUrlRequestInfo
{
public:
    enum ResourceType {
        ResourceTypeMainFrame = 0,  // top level page
        ResourceTypeSubFrame,       // frame or iframe
        ResourceTypeStylesheet,     // a CSS stylesheet
        ResourceTypeScript,         // an external script
        ResourceTypeImage,          // an image (jpg/gif/png/etc)
        ResourceTypeFontResource,   // a font
        ResourceTypeSubResource,    // an "other" subresource.
        ResourceTypeObject,         // an object (or embed) tag for a plugin,
                                    // or a resource that a plugin requested.
        ResourceTypeMedia,          // a media resource.
        ResourceTypeWorker,         // the main resource of a dedicated worker.
        ResourceTypeSharedWorker,   // the main resource of a shared worker.
        ResourceTypePrefetch,       // an explicitly requested prefetch
        ResourceTypeFavicon,        // a favicon
        ResourceTypeXhr,            // a XMLHttpRequest
        ResourceTypePing,           // a ping request for <a ping>
        ResourceTypeServiceWorker,  // the main resource of a service worker.
        ResourceTypeCspReport,      // Content Security Policy (CSP) violation report
        ResourceTypePluginResource, // A resource requested by a plugin
        ResourceTypeNavigationPreloadMainFrame = 19, // A main-frame service worker navigation preload request
        ResourceTypeNavigationPreloadSubFrame,  // A sub-frame service worker navigation preload request
/+ #ifndef Q_QDOC +/
        ResourceTypeLast = ResourceType.ResourceTypeNavigationPreloadSubFrame,
/+ #endif +/
        ResourceTypeWebSocket = 254,
        ResourceTypeUnknown = 255
    }

    enum NavigationType {
        NavigationTypeLink,
        NavigationTypeTyped,
        NavigationTypeFormSubmitted,
        NavigationTypeBackForward,
        NavigationTypeReload,
        NavigationTypeOther,
        NavigationTypeRedirect,
    }

    ResourceType resourceType() const;
    NavigationType navigationType() const;

    QUrl requestUrl() const;
    QUrl firstPartyUrl() const;
    QUrl initiator() const;
    QByteArray requestMethod() const;
    bool changed() const;

    void block(bool shouldBlock);
    void redirect(ref const(QUrl) url);
    void setHttpHeader(ref const(QByteArray) name, ref const(QByteArray) value);

private:
    /+ friend class QtWebEngineCore::ContentBrowserClientQt; +/
    /+ friend class QtWebEngineCore::InterceptedRequest; +/
    /+ Q_DISABLE_COPY(QWebEngineUrlRequestInfo) +/
@disable this(this);
/+@disable this(ref const(QWebEngineUrlRequestInfo));+/@disable ref QWebEngineUrlRequestInfo opAssign(ref const(QWebEngineUrlRequestInfo));    /+ Q_DECLARE_PRIVATE(QWebEngineUrlRequestInfo) +/

    void resetChanged();

    @disable this();

    this(QWebEngineUrlRequestInfoPrivate* p);
    /+ QWebEngineUrlRequestInfo(QWebEngineUrlRequestInfo &&p); +/
    /+ QWebEngineUrlRequestInfo &operator=(QWebEngineUrlRequestInfo &&p); +/
    ~this();
    QScopedPointer!(QWebEngineUrlRequestInfoPrivate) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

