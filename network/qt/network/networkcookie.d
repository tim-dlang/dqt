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
module qt.network.networkcookie;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.datetime;
import qt.core.list;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.url;
import qt.helpers;


extern(C++, class) struct QNetworkCookiePrivate;
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_NETWORK_EXPORT +/ QNetworkCookie
{
public:
    enum RawForm {
        NameAndValueOnly,
        Full
    }

    @disable this();
    /+ explicit +/this(ref const(QByteArray) name/* = globalInitVar!QByteArray*/, ref const(QByteArray) value = globalInitVar!QByteArray);
    @disable this(this);
    this(ref const(QNetworkCookie) other);
    ~this();
    /+ QNetworkCookie &operator=(QNetworkCookie &&other) noexcept { swap(other); return *this; } +/
    /+ref QNetworkCookie operator =(ref const(QNetworkCookie) other);+/

    /+ void swap(QNetworkCookie &other) noexcept { qSwap(d, other.d); } +/

    /+bool operator ==(ref const(QNetworkCookie) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QNetworkCookie) other) const
    { return !(this == other); }+/

    bool isSecure() const;
    void setSecure(bool enable);
    bool isHttpOnly() const;
    void setHttpOnly(bool enable);

    bool isSessionCookie() const;
    QDateTime expirationDate() const;
    void setExpirationDate(ref const(QDateTime) date);

    QString domain() const;
    void setDomain(ref const(QString) domain);

    QString path() const;
    void setPath(ref const(QString) path);

    QByteArray name() const;
    void setName(ref const(QByteArray) cookieName);

    QByteArray value() const;
    void setValue(ref const(QByteArray) value);

    QByteArray toRawForm(RawForm form = RawForm.Full) const;

    bool hasSameIdentifier(ref const(QNetworkCookie) other) const;
    void normalize(ref const(QUrl) url);

    static QList!(QNetworkCookie) parseCookies(ref const(QByteArray) cookieString);

private:
    QSharedDataPointer!(QNetworkCookiePrivate) d;
    /+ friend class QNetworkCookiePrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QNetworkCookie)

#ifndef QT_NO_DEBUG_STREAM
class QDebug;
Q_NETWORK_EXPORT QDebug operator<<(QDebug, const QNetworkCookie &);
#endif


Q_DECLARE_METATYPE(QNetworkCookie) +/

