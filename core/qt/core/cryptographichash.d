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
module qt.core.cryptographichash;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.bytearrayview;
import qt.core.global;
import qt.core.iodevice;
import qt.core.metamacros;
import qt.helpers;

extern(C++, class) struct QCryptographicHashPrivate;

/// Binding for C++ class [QCryptographicHash](https://doc.qt.io/qt-6/qcryptographichash.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QCryptographicHash
{
    mixin(Q_GADGET);
public:
    enum Algorithm {
/+ #ifndef QT_CRYPTOGRAPHICHASH_ONLY_SHA1 +/
        Md4,
        Md5,
/+ #endif +/
        Sha1 = 2,
/+ #ifndef QT_CRYPTOGRAPHICHASH_ONLY_SHA1 +/
        Sha224,
        Sha256,
        Sha384,
        Sha512,

        Keccak_224 = 7,
        Keccak_256,
        Keccak_384,
        Keccak_512,
        RealSha3_224 = 11,
        RealSha3_256,
        RealSha3_384,
        RealSha3_512,
/+ #  ifndef QT_SHA3_KECCAK_COMPAT +/
        Sha3_224 = Algorithm.RealSha3_224,
        Sha3_256 = Algorithm.RealSha3_256,
        Sha3_384 = Algorithm.RealSha3_384,
        Sha3_512 = Algorithm.RealSha3_512,
/+ #  else
        Sha3_224 = Keccak_224,
        Sha3_256 = Keccak_256,
        Sha3_384 = Keccak_384,
        Sha3_512 = Keccak_512,
#  endif +/

        Blake2b_160 = 15,
        Blake2b_256,
        Blake2b_384,
        Blake2b_512,
        Blake2s_128,
        Blake2s_160,
        Blake2s_224,
        Blake2s_256,
/+ #endif +/
    }
    /+ Q_ENUM(Algorithm) +/

    /+ explicit +/this(Algorithm method);
    ~this();

    void reset()/+ noexcept+/;

/+ #if QT_DEPRECATED_SINCE(6, 4) +/
    /+ QT_DEPRECATED_VERSION_X_6_4("Use the QByteArrayView overload instead") +/
        void addData(const(char)* data, qsizetype length);
/+ #endif
#if QT_CORE_REMOVED_SINCE(6, 3) +/
    static if (defined!"QT_CORE_BUILD_REMOVED_API")
    {
        void addData(ref const(QByteArray) data);
    }
/+ #endif +/
    void addData(QByteArrayView data)/+ noexcept+/;
    bool addData(QIODevice device);

    QByteArray result() const;
    QByteArrayView resultView() const/+ noexcept+/;

    static if (defined!"QT_CORE_BUILD_REMOVED_API")
    {
        /+ static QByteArray hash(const QByteArray &data, Algorithm method); +/
    }
    /+ static QByteArray hash(QByteArrayView data, Algorithm method); +/
    static int hashLength(Algorithm method);
private:
    /+ Q_DISABLE_COPY(QCryptographicHash) +/
@disable this(this);
/+@disable this(ref const(QCryptographicHash));+/@disable ref QCryptographicHash opAssign(ref const(QCryptographicHash));    QCryptographicHashPrivate* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

