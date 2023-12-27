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
module qt.network.ssl;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.helpers;

extern(C++, "QSsl") {
    enum KeyType {
        PrivateKey,
        PublicKey
    }

    enum EncodingFormat {
        Pem,
        Der
    }

    enum KeyAlgorithm {
        Opaque,
        Rsa,
        Dsa,
        Ec,
        Dh,
    }

    enum AlternativeNameEntryType {
        EmailEntry,
        DnsEntry,
        IpAddressEntry
    }

/+ #if QT_DEPRECATED_SINCE(5,0)
    typedef AlternativeNameEntryType AlternateNameEntryType;
#endif +/

    enum SslProtocol {
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
        SslV3,
        SslV2,
/+ #endif +/
        TlsV1_0 = 2,
/+ #if QT_DEPRECATED_SINCE(5,0)
        TlsV1 = TlsV1_0,
#endif +/
        TlsV1_1,
        TlsV1_2,
        AnyProtocol,
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
        TlsV1SslV3,
/+ #endif +/
        SecureProtocols = SslProtocol.AnyProtocol + 2,

        TlsV1_0OrLater,
        TlsV1_1OrLater,
        TlsV1_2OrLater,

        DtlsV1_0,
        DtlsV1_0OrLater,
        DtlsV1_2,
        DtlsV1_2OrLater,

        TlsV1_3,
        TlsV1_3OrLater,

        UnknownProtocol = -1
    }

    enum SslOption {
        SslOptionDisableEmptyFragments = 0x01,
        SslOptionDisableSessionTickets = 0x02,
        SslOptionDisableCompression = 0x04,
        SslOptionDisableServerNameIndication = 0x08,
        SslOptionDisableLegacyRenegotiation = 0x10,
        SslOptionDisableSessionSharing = 0x20,
        SslOptionDisableSessionPersistence = 0x40,
        SslOptionDisableServerCipherPreference = 0x80
    }
alias SslOptions = QFlags!(SslOption);
    /+ Q_DECLARE_FLAGS(SslOptions, SslOption) +/
    }
/+pragma(inline, true) QFlags!(SslOptions.enum_type) operator |(SslOptions.enum_type f1, SslOptions.enum_type f2)/+noexcept+/{return QFlags!(SslOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(SslOptions.enum_type) operator |(SslOptions.enum_type f1, QFlags!(SslOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(SslOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QSsl::SslOptions) +/
