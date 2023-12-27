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
module qt.webengine.registerprotocolhandlerrequest;
extern(C++):

import qt.config;
import qt.core.metamacros;
//import qt.core.sharedpointer_impl;
import qt.core.string;
import qt.core.url;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct RegisterProtocolHandlerRequestController;
extern(C++, class) struct WebContentsDelegateQt;
} // namespace QtWebEngineCore


/// Binding for C++ class [QWebEngineRegisterProtocolHandlerRequest](https://doc.qt.io/qt-5/qwebengineregisterprotocolhandlerrequest.html).
extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineRegisterProtocolHandlerRequest {
    mixin(Q_GADGET);
    /+ Q_PROPERTY(QUrl origin READ origin CONSTANT FINAL)
    Q_PROPERTY(QString scheme READ scheme CONSTANT FINAL) +/
public:
    @disable this();
    /+this() {}+/
    /*@QInvokable*/ void accept();
    /*@QInvokable*/ void reject();
    QUrl origin() const;
    QString scheme() const;
    /+bool operator ==(ref const(QWebEngineRegisterProtocolHandlerRequest) that) const { return d_ptr == that.d_ptr; }+/
    /+bool operator !=(ref const(QWebEngineRegisterProtocolHandlerRequest) that) const { return d_ptr != that.d_ptr; }+/

private:
    //this(QSharedPointer!(/+ QtWebEngineCore:: +/RegisterProtocolHandlerRequestController));
    /+ friend QtWebEngineCore::WebContentsDelegateQt; +/
    //QSharedPointer!(/+ QtWebEngineCore:: +/RegisterProtocolHandlerRequestController) d_ptr;
    void* d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

