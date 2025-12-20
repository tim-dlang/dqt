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
module qt.webengine.httprequest;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.map;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.url;
import qt.core.vector;
import qt.helpers;

extern(C++, class) struct QWebEngineHttpRequestPrivate;

/// Binding for C++ class [QWebEngineHttpRequest](https://doc.qt.io/qt-5/qwebenginehttprequest.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineHttpRequest {
public:
    enum Method {
        Get,
        Post
    }

    @disable this();
    /+ explicit +/this(ref const(QUrl) url/* = globalInitVar!QUrl*/,
                                       ref const(Method) method /+ = QWebEngineHttpRequest::Get +/);
    @disable this(this);
    this(ref const(QWebEngineHttpRequest) other);
    ~this();
/+ #ifdef Q_COMPILER_RVALUE_REFS +/
    /+ QWebEngineHttpRequest &operator=(QWebEngineHttpRequest &&other) Q_DECL_NOTHROW
    {
        swap(other);
        return *this;
    } +/
/+ #endif +/
    ref QWebEngineHttpRequest opAssign(ref const(QWebEngineHttpRequest) other);

    //static QWebEngineHttpRequest postRequest(ref const(QUrl) url, ref const(QMap!(QString, QString)) postData);
    /+ void swap(QWebEngineHttpRequest &other) Q_DECL_NOTHROW { qSwap(d, other.d); } +/

    /+bool operator ==(ref const(QWebEngineHttpRequest) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QWebEngineHttpRequest) other) const { return !operator==(other); }+/

    Method method() const;
    void setMethod(Method method);

    QUrl url() const;
    void setUrl(ref const(QUrl) url);

    QByteArray postData() const;
    void setPostData(ref const(QByteArray) postData);

    bool hasHeader(ref const(QByteArray) headerName) const;
    QVector!(QByteArray) headers() const;
    QByteArray header(ref const(QByteArray) headerName) const;
    void setHeader(ref const(QByteArray) headerName, ref const(QByteArray) value);
    void unsetHeader(ref const(QByteArray) headerName);

private:
    QSharedDataPointer!(QWebEngineHttpRequestPrivate) d;
    /+ friend class QWebEngineHttpRequestPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QWebEngineHttpRequest) +/

