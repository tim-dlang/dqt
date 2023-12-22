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
module qt.webengine.certificateerror;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.shareddata;
//import qt.core.sharedpointer_impl;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.network.sslcertificate;

extern(C++, class) struct CertificateErrorController;
extern(C++, class) struct QWebEngineCertificateErrorPrivate;

/// Binding for C++ class [QWebEngineCertificateError](https://doc.qt.io/qt-5/qwebenginecertificateerror.html).
extern(C++, class) struct /+ QWEBENGINEWIDGETS_EXPORT +/ QWebEngineCertificateError {
public:
    this(int error, QUrl url, bool overridable, QString errorDescription);
    ~this();

    // Keep this identical to CertificateErrorController::CertificateError, or add mapping layer.
    enum Error {
        SslPinnedKeyNotInCertificateChain = -150,
        CertificateCommonNameInvalid = -200,
        CertificateDateInvalid = -201,
        CertificateAuthorityInvalid = -202,
        CertificateContainsErrors = -203,
        CertificateNoRevocationMechanism = -204,
        CertificateUnableToCheckRevocation = -205,
        CertificateRevoked = -206,
        CertificateInvalid = -207,
        CertificateWeakSignatureAlgorithm = -208,
        CertificateNonUniqueName = -210,
        CertificateWeakKey = -211,
        CertificateNameConstraintViolation = -212,
        CertificateValidityTooLong = -213,
        CertificateTransparencyRequired = -214,
        CertificateKnownInterceptionBlocked = -217,
    }

    Error error() const;
    QUrl url() const;
    bool isOverridable() const;
    QString errorDescription() const;

    @disable this(this);
    this(ref const(QWebEngineCertificateError) other);
    /+ref QWebEngineCertificateError operator =(ref const(QWebEngineCertificateError) other);+/

    void defer();
    bool deferred() const;

    void rejectCertificate();
    void ignoreCertificateError();
    bool answered() const;

    QList!(QSslCertificate) certificateChain() const;

private:
    /+ friend class QWebEnginePagePrivate; +/
    //this(ref const(QSharedPointer!(CertificateErrorController)) controller);
    QExplicitlySharedDataPointer!(QWebEngineCertificateErrorPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

