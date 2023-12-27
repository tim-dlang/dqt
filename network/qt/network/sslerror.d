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
module qt.network.sslerror;
extern(C++):

import qt.config;
import qt.core.metamacros;
import qt.core.scopedpointer;
import qt.core.string;
import qt.core.typeinfo;
import qt.helpers;
import qt.network.sslcertificate;

/+ #ifndef QT_NO_SSL +/

extern(C++, class) struct QSslErrorPrivate;
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_NETWORK_EXPORT +/ QSslError
{
    mixin(Q_GADGET);
public:
    enum SslError {
        NoError,
        UnableToGetIssuerCertificate,
        UnableToDecryptCertificateSignature,
        UnableToDecodeIssuerPublicKey,
        CertificateSignatureFailed,
        CertificateNotYetValid,
        CertificateExpired,
        InvalidNotBeforeField,
        InvalidNotAfterField,
        SelfSignedCertificate,
        SelfSignedCertificateInChain,
        UnableToGetLocalIssuerCertificate,
        UnableToVerifyFirstCertificate,
        CertificateRevoked,
        InvalidCaCertificate,
        PathLengthExceeded,
        InvalidPurpose,
        CertificateUntrusted,
        CertificateRejected,
        SubjectIssuerMismatch, // hostname mismatch?
        AuthorityIssuerSerialNumberMismatch,
        NoPeerCertificate,
        HostNameMismatch,
        NoSslSupport,
        CertificateBlacklisted,
        CertificateStatusUnknown,
        OcspNoResponseFound,
        OcspMalformedRequest,
        OcspMalformedResponse,
        OcspInternalError,
        OcspTryLater,
        OcspSigRequred,
        OcspUnauthorized,
        OcspResponseCannotBeTrusted,
        OcspResponseCertIdUnknown,
        OcspResponseExpired,
        OcspStatusUnknown,
        UnspecifiedError = -1
    }
    /+ Q_ENUM(SslError) +/

    // RVCT compiler in debug build does not like about default values in const-
    // So as an workaround we define all constructor overloads here explicitly
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(SslError error);
    this(SslError error, ref const(QSslCertificate) certificate);

    @disable this(this);
    this(ref const(QSslError) other);

    /+ void swap(QSslError &other) noexcept
    { qSwap(d, other.d); } +/

    ~this();
    /+ QSslError &operator=(QSslError &&other) noexcept { swap(other); return *this; } +/
    /+ref QSslError operator =(ref const(QSslError) other);+/
    /+bool operator ==(ref const(QSslError) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QSslError) other) const
    { return !(this == other); }+/

    SslError error() const;
    QString errorString() const;
    QSslCertificate certificate() const;

private:
    QScopedPointer!(QSslErrorPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED(QSslError)

Q_NETWORK_EXPORT uint qHash(const QSslError &key, uint seed = 0) noexcept;

#ifndef QT_NO_DEBUG_STREAM
class QDebug;
Q_NETWORK_EXPORT QDebug operator<<(QDebug debug, const QSslError &error);
Q_NETWORK_EXPORT QDebug operator<<(QDebug debug, const QSslError::SslError &error);
#endif +/

/+ #endif // QT_NO_SSL


#ifndef QT_NO_SSL
Q_DECLARE_METATYPE(QList<QSslError>)
#endif +/

