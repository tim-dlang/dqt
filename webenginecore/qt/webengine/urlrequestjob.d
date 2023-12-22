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
module qt.webengine.urlrequestjob;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.iodevice;
import qt.core.map;
import qt.core.object;
import qt.core.url;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct URLRequestCustomJobDelegate;
extern(C++, class) struct URLRequestCustomJobProxy;
} // namespace QtWebEngineCore



/// Binding for C++ class [QWebEngineUrlRequestJob](https://doc.qt.io/qt-5/qwebengineurlrequestjob.html).
class /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineUrlRequestJob : QObject {
    mixin(Q_OBJECT);
public:
    ~this();

    enum Error {
        NoError = 0,
        UrlNotFound,
        UrlInvalid,
        RequestAborted,
        RequestDenied,
        RequestFailed
    }
    /+ Q_ENUM(Error) +/

    final QUrl requestUrl() const;
    final QByteArray requestMethod() const;
    final QUrl initiator() const;
    //final QMap!(QByteArray, QByteArray) requestHeaders() const;

    final void reply(ref const(QByteArray) contentType, QIODevice device);
    final void fail(Error error);
    final void redirect(ref const(QUrl) url);

private:
    this(/+ QtWebEngineCore:: +/URLRequestCustomJobDelegate* );
    /+ friend class QtWebEngineCore::URLRequestCustomJobProxy; +/

    /+ QtWebEngineCore:: +/URLRequestCustomJobDelegate* d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

