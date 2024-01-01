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
module qt.webengine.clientcertificatestore;
extern(C++):

import qt.config;
import qt.core.list;
import qt.helpers;
import qt.network.sslcertificate;
import qt.network.sslkey;

/+ #if QT_CONFIG(ssl) +/
extern(C++, "QtWebEngineCore") {
struct ClientCertificateStoreData;
extern(C++, class) struct ProfileAdapter;
} // namespace QtWebEngineCore


/// Binding for C++ class [QWebEngineClientCertificateStore](https://doc.qt.io/qt-6/qwebengineclientcertificatestore.html).
extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineClientCertificateStore
{

public:
    void add(ref const(QSslCertificate) certificate, ref const(QSslKey) privateKey);
    QList!(QSslCertificate) certificates() const;
    void remove(ref const(QSslCertificate) certificate);
    void clear();

private:
    /+ friend class QtWebEngineCore::ProfileAdapter; +/
    /+ Q_DISABLE_COPY(QWebEngineClientCertificateStore) +/
@disable this(this);
/+this(ref const(QWebEngineClientCertificateStore));+//+ref QWebEngineClientCertificateStore operator =(ref const(QWebEngineClientCertificateStore));+/
    this(/+ QtWebEngineCore:: +/ClientCertificateStoreData* storeData);
    ~this();
    /+ QtWebEngineCore:: +/ClientCertificateStoreData* m_storeData;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ #endif +/ // QT_CONFIG(ssl)

