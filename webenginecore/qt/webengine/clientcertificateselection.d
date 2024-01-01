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
module qt.webengine.clientcertificateselection;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.sharedpointer_impl;
import qt.core.url;
import qt.helpers;
import qt.network.sslcertificate;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct ClientCertSelectController;
}


/// Binding for C++ class [QWebEngineClientCertificateSelection](https://doc.qt.io/qt-6/qwebengineclientcertificateselection.html).
extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineClientCertificateSelection
{
public:
    @disable this(this);
    this(ref const(QWebEngineClientCertificateSelection) );
    ~this();

    /+ref QWebEngineClientCertificateSelection operator =(ref const(QWebEngineClientCertificateSelection) );+/

    QUrl host() const;

    void select(ref const(QSslCertificate) certificate);
    void selectNone();
    QList!(QSslCertificate) certificates() const;

private:
    /+ friend class QWebEnginePagePrivate; +/

    this(
                QSharedPointer!(/+ QtWebEngineCore:: +/ClientCertSelectController));

    QSharedPointer!(/+ QtWebEngineCore:: +/ClientCertSelectController) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

