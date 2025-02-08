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
module qt.webengine.loadinginfo;
extern(C++):

import qt.config;
import qt.core.metamacros;
import qt.core.shareddata;
import qt.core.string;
import qt.core.url;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct WebContentsAdapter;
}


/// Binding for C++ class [QWebEngineLoadingInfo](https://doc.qt.io/qt-6/qwebengineloadinginfo.html).
extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineLoadingInfo
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(QUrl url READ url CONSTANT FINAL)
    Q_PROPERTY(bool isErrorPage READ isErrorPage CONSTANT FINAL)
    Q_PROPERTY(LoadStatus status READ status CONSTANT FINAL)
    Q_PROPERTY(QString errorString READ errorString CONSTANT FINAL)
    Q_PROPERTY(ErrorDomain errorDomain READ errorDomain CONSTANT FINAL)
    Q_PROPERTY(int errorCode READ errorCode CONSTANT FINAL) +/

public:
    enum LoadStatus {
        LoadStartedStatus,
        LoadStoppedStatus,
        LoadSucceededStatus,
        LoadFailedStatus
    }
    /+ Q_ENUM(LoadStatus) +/

    enum ErrorDomain {
         NoErrorDomain,
         InternalErrorDomain,
         ConnectionErrorDomain,
         CertificateErrorDomain,
         HttpErrorDomain,
         FtpErrorDomain,
         DnsErrorDomain,
         HttpStatusCodeDomain
    }
    /+ Q_ENUM(ErrorDomain) +/

    @disable this(this);
    this(ref const(QWebEngineLoadingInfo) other);
    /+ref QWebEngineLoadingInfo operator =(ref const(QWebEngineLoadingInfo) other);+/
    /+ QWebEngineLoadingInfo(QWebEngineLoadingInfo &&other); +/
    /+ QWebEngineLoadingInfo &operator=(QWebEngineLoadingInfo &&other); +/
    ~this();

    QUrl url() const;
    bool isErrorPage() const;
    LoadStatus status() const;
    QString errorString() const;
    ErrorDomain errorDomain() const;
    int errorCode() const;

private:
    /*this(ref const(QUrl) url, LoadStatus status, bool isErrorPage = false,
                              ref const(QString) errorString = globalInitVar!QString, int errorCode = 0,
                              ErrorDomain errorDomain = ErrorDomain.NoErrorDomain);*/
    extern(C++, class) struct QWebEngineLoadingInfoPrivate;
    /+ Q_DECLARE_PRIVATE(QWebEngineLoadingInfo) +/
    QExplicitlySharedDataPointer!(QWebEngineLoadingInfoPrivate) d_ptr;
    /+ friend class QQuickWebEngineViewPrivate; +/
    /+ friend class QtWebEngineCore::WebContentsAdapter; +/
    /+ friend class QtWebEngineCore::WebContentsDelegateQt; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

