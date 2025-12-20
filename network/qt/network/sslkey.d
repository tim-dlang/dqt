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
module qt.network.sslkey;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.iodevice;
import qt.core.namespace;
import qt.core.shareddata;
import qt.core.typeinfo;
import qt.helpers;
import qt.network.ssl;

/+ #ifndef QT_NO_SSL +/


extern(C++, class) struct QSslKeyPrivate;
/// Binding for C++ class [QSslKey](https://doc.qt.io/qt-6/qsslkey.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_NETWORK_EXPORT +/ QSslKey
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(ref const(QByteArray) encoded, /+ QSsl:: +/qt.network.ssl.KeyAlgorithm algorithm,
                /+ QSsl:: +/qt.network.ssl.EncodingFormat format = /+ QSsl:: +/qt.network.ssl.EncodingFormat.Pem,
                /+ QSsl:: +/qt.network.ssl.KeyType type = /+ QSsl:: +/qt.network.ssl.KeyType.PrivateKey,
                ref const(QByteArray) passPhrase = globalInitVar!QByteArray);
    this(QIODevice device, /+ QSsl:: +/qt.network.ssl.KeyAlgorithm algorithm,
                /+ QSsl:: +/qt.network.ssl.EncodingFormat format = /+ QSsl:: +/qt.network.ssl.EncodingFormat.Pem,
                /+ QSsl:: +/qt.network.ssl.KeyType type = /+ QSsl:: +/qt.network.ssl.KeyType.PrivateKey,
                ref const(QByteArray) passPhrase = globalInitVar!QByteArray);
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.HANDLE handle, /+ QSsl:: +/qt.network.ssl.KeyType type = /+ QSsl:: +/qt.network.ssl.KeyType.PrivateKey);
    @disable this(this);
    this(ref const(QSslKey) other);
    /+ QSslKey(QSslKey &&other) noexcept; +/
    /+ QSslKey &operator=(QSslKey &&other) noexcept; +/
    ref QSslKey opAssign(ref const(QSslKey) other);
    ~this();

    /+ void swap(QSslKey &other) noexcept { d.swap(other.d); } +/

    bool isNull() const;
    void clear();

    int length() const;
    /+ QSsl:: +/qt.network.ssl.KeyType type() const;
    /+ QSsl:: +/qt.network.ssl.KeyAlgorithm algorithm() const;

    QByteArray toPem(ref const(QByteArray) passPhrase = globalInitVar!QByteArray) const;
    // ### Qt 7: drop passPhrase
    QByteArray toDer(ref const(QByteArray) passPhrase = globalInitVar!QByteArray) const;

    /+ Qt:: +/qt.core.namespace.HANDLE handle() const;

    /+bool operator ==(ref const(QSslKey) key) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QSslKey) key) const { return !operator==(key); }+/

private:
    QExplicitlySharedDataPointer!(QSslKeyPrivate) d;
    /+ friend class QTlsBackend; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QSslKey)

#ifndef QT_NO_DEBUG_STREAM
class QDebug;
Q_NETWORK_EXPORT QDebug operator<<(QDebug debug, const QSslKey &key);
#endif +/

/+ #endif +/ // QT_NO_SSL

