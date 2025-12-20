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
//import qt.core.sharedpointer_impl;
import qt.core.url;
import qt.core.vector;
import qt.helpers;
import qt.network.sslcertificate;

/+ #if !defined(QT_NO_SSL) || QT_VERSION >= QT_VERSION_CHECK(5, 12, 0) +/

extern(C++, class) struct ClientCertSelectController;

/// Binding for C++ class [QWebEngineClientCertificateSelection](https://doc.qt.io/qt-5/qwebengineclientcertificateselection.html).
/+extern(C++, class) struct /+ QWEBENGINEWIDGETS_EXPORT +/ QWebEngineClientCertificateSelection {
public:
    @disable this(this);
    this(ref const(QWebEngineClientCertificateSelection) );
    ~this();

    ref QWebEngineClientCertificateSelection opAssign(ref const(QWebEngineClientCertificateSelection) );

    QUrl host() const;

    void select(ref const(QSslCertificate) certificate);
    void selectNone();
    QVector!(QSslCertificate) certificates() const;

private:
    /+ friend class QWebEnginePagePrivate; +/

    this(QSharedPointer!(ClientCertSelectController));

    QSharedPointer!(ClientCertSelectController) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}+/


/+ #endif +/ // !defined(QT_NO_SSL) || QT_VERSION >= QT_VERSION_CHECK(5, 12, 0)

