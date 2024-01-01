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
module qt.network.sslpresharedkeyauthenticator;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.shareddata;
import qt.core.typeinfo;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(ssl); +/


extern(C++, class) struct QSslPreSharedKeyAuthenticatorPrivate;
/// Binding for C++ class [QSslPreSharedKeyAuthenticator](https://doc.qt.io/qt-6/qsslpresharedkeyauthenticator.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct QSslPreSharedKeyAuthenticator
{
public:
    @disable this();
    /+ Q_NETWORK_EXPORT +/pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ Q_NETWORK_EXPORT +/~this();
    @disable this(this);
    /+ Q_NETWORK_EXPORT +/this(ref const(QSslPreSharedKeyAuthenticator) authenticator);
    /+/+ Q_NETWORK_EXPORT +/ ref QSslPreSharedKeyAuthenticator operator =(ref const(QSslPreSharedKeyAuthenticator) authenticator);+/

    /+ QSslPreSharedKeyAuthenticator &operator=(QSslPreSharedKeyAuthenticator &&other) noexcept { swap(other); return *this; } +/

    /+ void swap(QSslPreSharedKeyAuthenticator &other) noexcept { qSwap(d, other.d); } +/

    /+ Q_NETWORK_EXPORT +/ QByteArray identityHint() const;

    /+ Q_NETWORK_EXPORT +/ void setIdentity(ref const(QByteArray) identity);
    /+ Q_NETWORK_EXPORT +/ QByteArray identity() const;
    /+ Q_NETWORK_EXPORT +/ int maximumIdentityLength() const;

    /+ Q_NETWORK_EXPORT +/ void setPreSharedKey(ref const(QByteArray) preSharedKey);
    /+ Q_NETWORK_EXPORT +/ QByteArray preSharedKey() const;
    /+ Q_NETWORK_EXPORT +/ int maximumPreSharedKeyLength() const;

private:
    /+ Q_NETWORK_EXPORT +/ bool isEqual(ref const(QSslPreSharedKeyAuthenticator) other) const;

    /+ friend class QTlsBackend; +/

    /+ friend bool operator==(const QSslPreSharedKeyAuthenticator &lhs, const QSslPreSharedKeyAuthenticator &rhs)
    { return lhs.isEqual(rhs); } +/
    /+ friend bool operator!=(const QSslPreSharedKeyAuthenticator &lhs, const QSslPreSharedKeyAuthenticator &rhs)
    { return !lhs.isEqual(rhs); } +/

    QSharedDataPointer!(QSslPreSharedKeyAuthenticatorPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ Q_DECLARE_SHARED(QSslPreSharedKeyAuthenticator)


Q_DECLARE_METATYPE(QSslPreSharedKeyAuthenticator)
Q_DECLARE_METATYPE(QSslPreSharedKeyAuthenticator*) +/

