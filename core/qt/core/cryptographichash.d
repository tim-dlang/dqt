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
import qt.core.iodevice;
import qt.core.metamacros;
import qt.helpers;

extern(C++, class) struct QCryptographicHashPrivate;

/// Binding for C++ class [QCryptographicHash](https://doc.qt.io/qt-5/qcryptographichash.html).
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
        Sha3_512 = Algorithm.RealSha3_512
/+ #  else
        Sha3_224 = Keccak_224,
        Sha3_256 = Keccak_256,
        Sha3_384 = Keccak_384,
        Sha3_512 = Keccak_512
#  endif
#endif +/
    }
    /+ Q_ENUM(Algorithm) +/

    /+ explicit +/this(Algorithm method);
    ~this();

    void reset();

    void addData(const(char)* data, int length);
    void addData(ref const(QByteArray) data);
    bool addData(QIODevice device);

    QByteArray result() const;

    /+ static QByteArray hash(const QByteArray &data, Algorithm method); +/
    static int hashLength(Algorithm method);
private:
    /+ Q_DISABLE_COPY(QCryptographicHash) +/
@disable this(this);
/+@disable this(ref const(QCryptographicHash));+/@disable ref QCryptographicHash opAssign(ref const(QCryptographicHash));    QCryptographicHashPrivate* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

