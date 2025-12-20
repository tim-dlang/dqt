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
module qt.network.sslcertificateextension;
extern(C++):

import qt.config;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.variant;
import qt.helpers;

extern(C++, class) struct QSslCertificateExtensionPrivate;

/// Binding for C++ class [QSslCertificateExtension](https://doc.qt.io/qt-5/qsslcertificateextension.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_NETWORK_EXPORT +/ QSslCertificateExtension
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

    @disable this(this);
    this(ref const(QSslCertificateExtension) other);
    /+ QSslCertificateExtension &operator=(QSslCertificateExtension &&other) noexcept { swap(other); return *this; } +/
    ref QSslCertificateExtension opAssign(ref const(QSslCertificateExtension) other);
    ~this();

    /+ void swap(QSslCertificateExtension &other) noexcept { qSwap(d, other.d); } +/

    QString oid() const;
    QString name() const;
    QVariant value() const;
    bool isCritical() const;

    bool isSupported() const;

private:
    /+ friend class QSslCertificatePrivate; +/
    QSharedDataPointer!(QSslCertificateExtensionPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QSslCertificateExtension) +/

