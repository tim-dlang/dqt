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
module qt.network.sslcertificate;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.cryptographichash;
import qt.core.datetime;
import qt.core.iodevice;
import qt.core.list;
import qt.core.namespace;
import qt.core.shareddata;
import qt.core.string;
import qt.core.stringlist;
import qt.core.typeinfo;
import qt.helpers;
import qt.network.ssl;
import qt.network.sslcertificateextension;
import qt.network.sslerror;
import qt.network.sslkey;

/+ #ifdef verify
#undef verify
#endif



// qHash is a friend, but we can't use default arguments for friends (§8.3.6.4)
Q_NETWORK_EXPORT size_t qHash(const QSslCertificate &key, size_t seed = 0) noexcept; +/

extern(C++, class) struct QSslCertificatePrivate;
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_NETWORK_EXPORT +/ QSslCertificate
{
public:
    enum SubjectInfo {
        Organization,
        CommonName,
        LocalityName,
        OrganizationalUnitName,
        CountryName,
        StateOrProvinceName,
        DistinguishedNameQualifier,
        SerialNumber,
        EmailAddress
    }

    enum /+ class +/ PatternSyntax {
        RegularExpression,
        Wildcard,
        FixedString
    }


    /+ explicit +/this(QIODevice device, /+ QSsl:: +/qt.network.ssl.EncodingFormat format = /+ QSsl:: +/qt.network.ssl.EncodingFormat.Pem);
    @disable this();
    /+ explicit +/this(ref const(QByteArray) data/* = globalInitVar!QByteArray*/, /+ QSsl:: +/qt.network.ssl.EncodingFormat format = /+ QSsl:: +/qt.network.ssl.EncodingFormat.Pem);
    @disable this(this);
    this(ref const(QSslCertificate) other);
    ~this();
    /+ QSslCertificate &operator=(QSslCertificate &&other) noexcept { swap(other); return *this; } +/
    /+ref QSslCertificate operator =(ref const(QSslCertificate) other);+/

    /+ void swap(QSslCertificate &other) noexcept
    { qSwap(d, other.d); } +/

    /+bool operator ==(ref const(QSslCertificate) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QSslCertificate) other) const { return !operator==(other); }+/

    bool isNull() const;
    bool isBlacklisted() const;
    bool isSelfSigned() const;
    void clear();

    // Certificate info
    //QByteArray version_() const;
    QByteArray serialNumber() const;
    QByteArray digest(QCryptographicHash.Algorithm algorithm = QCryptographicHash.Algorithm.Md5) const;
    QStringList issuerInfo(SubjectInfo info) const;
    QStringList issuerInfo(ref const(QByteArray) attribute) const;
    QStringList subjectInfo(SubjectInfo info) const;
    QStringList subjectInfo(ref const(QByteArray) attribute) const;
    QString issuerDisplayName() const;
    QString subjectDisplayName() const;

    QList!(QByteArray) subjectInfoAttributes() const;
    QList!(QByteArray) issuerInfoAttributes() const;
//    QMultiMap!(/+ QSsl:: +/qt.network.ssl.AlternativeNameEntryType, QString) subjectAlternativeNames() const;
    QDateTime effectiveDate() const;
    QDateTime expiryDate() const;
/+ #ifndef QT_NO_SSL +/
    QSslKey publicKey() const;
/+ #endif +/
    QList!(QSslCertificateExtension) extensions() const;

    QByteArray toPem() const;
    QByteArray toDer() const;
    QString toText() const;

    static QList!(QSslCertificate) fromPath(ref const(QString) path,
                                               /+ QSsl:: +/qt.network.ssl.EncodingFormat format = /+ QSsl:: +/qt.network.ssl.EncodingFormat.Pem,
                                               PatternSyntax syntax = PatternSyntax.FixedString);

    static QList!(QSslCertificate) fromDevice(
            QIODevice device, /+ QSsl:: +/qt.network.ssl.EncodingFormat format = /+ QSsl:: +/qt.network.ssl.EncodingFormat.Pem);
    static QList!(QSslCertificate) fromData(
            ref const(QByteArray) data, /+ QSsl:: +/qt.network.ssl.EncodingFormat format = /+ QSsl:: +/qt.network.ssl.EncodingFormat.Pem);

/+ #ifndef QT_NO_SSL +/
    static QList!(QSslError) verify(ref const(QList!(QSslCertificate)) certificateChain, ref const(QString) hostName = globalInitVar!QString);
    static bool importPkcs12(QIODevice device,
                                 QSslKey* key, QSslCertificate* cert,
                                 QList!(QSslCertificate)* caCertificates = null,
                                 ref const(QByteArray) passPhrase=globalInitVar!QByteArray);
/+ #endif +/

    /+ Qt:: +/qt.core.namespace.HANDLE handle() const;

private:
    QExplicitlySharedDataPointer!(QSslCertificatePrivate) d;
    /+ friend class QTlsBackend; +/

    /+ friend Q_NETWORK_EXPORT size_t qHash(const QSslCertificate &key, size_t seed) noexcept; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED(QSslCertificate)

#ifndef QT_NO_DEBUG_STREAM
class QDebug;
Q_NETWORK_EXPORT QDebug operator<<(QDebug debug, const QSslCertificate &certificate);
Q_NETWORK_EXPORT QDebug operator<<(QDebug debug, QSslCertificate::SubjectInfo info);
#endif


Q_DECLARE_METATYPE(QSslCertificate) +/

