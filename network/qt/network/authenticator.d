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
module qt.network.authenticator;
extern(C++):

import qt.config;
import qt.core.string;
import qt.core.variant;
import qt.helpers;

extern(C++, class) struct QAuthenticatorPrivate;

extern(C++, class) struct /+ Q_NETWORK_EXPORT +/ QAuthenticator
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

    ~this();

    @disable this(this);
    this(ref const(QAuthenticator) other);
    /+ref QAuthenticator operator =(ref const(QAuthenticator) other);+/

    /+bool operator ==(ref const(QAuthenticator) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QAuthenticator) other) const { return !operator==(other); }+/

    QString user() const;
    void setUser(ref const(QString) user);

    QString password() const;
    void setPassword(ref const(QString) password);

    QString realm() const;
    void setRealm(ref const(QString) realm);

    QVariant option(ref const(QString) opt) const;
//    QVariantHash options() const;
    void setOption(ref const(QString) opt, ref const(QVariant) value);

    bool isNull() const;
    void detach();
private:
    /+ friend class QAuthenticatorPrivate; +/
    QAuthenticatorPrivate* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

