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
import qt.core.metamacros;
import qt.core.object;
import qt.core.sharedpointer_impl;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.network.sslcertificate;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct WebContentsDelegateQt;
extern(C++, class) struct CertificateErrorController;
}


/// Binding for C++ class [QWebEngineCertificateError](https://doc.qt.io/qt-6/qwebenginecertificateerror.html).
extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineCertificateError
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(QUrl url READ url CONSTANT FINAL)
    Q_PROPERTY(Type type READ type CONSTANT FINAL)
    Q_PROPERTY(QString description READ description CONSTANT FINAL)
    Q_PROPERTY(bool overridable READ isOverridable CONSTANT FINAL) +/

public:
    @disable this(this);
    this(ref const(QWebEngineCertificateError) other);
    /+ref QWebEngineCertificateError operator =(ref const(QWebEngineCertificateError) other);+/
    ~this();

    // Keep this identical to NET_ERROR in net_error_list.h, or add mapping layer.
    enum Type {
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
        CertificateSymantecLegacy = -215,
        CertificateKnownInterceptionBlocked = -217,
        SslObsoleteVersion = -218,
    }
    /+ Q_ENUM(Type) +/

    Type type() const;
    QUrl url() const;
    bool isOverridable() const;
    QString description() const;

    @QInvokable void defer();
    @QInvokable void rejectCertificate();
    @QInvokable void acceptCertificate();

    QList!(QSslCertificate) certificateChain() const;

private:
    /+ friend class QtWebEngineCore::WebContentsDelegateQt; +/
    this(
                ref const(QSharedPointer!(/+ QtWebEngineCore:: +/CertificateErrorController)) controller);
    QSharedPointer!(/+ QtWebEngineCore:: +/CertificateErrorController) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ Q_DECLARE_METATYPE(QWebEngineCertificateError) +/

