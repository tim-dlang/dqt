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
module qt.webengine.quotarequest;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.metamacros;
import qt.core.object;
import qt.core.sharedpointer_impl;
import qt.core.url;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct QuotaPermissionContextQt;
extern(C++, class) struct QuotaRequestController;
} // namespace QtWebEngineCore


extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineQuotaRequest
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(QUrl origin READ origin CONSTANT FINAL)
    Q_PROPERTY(qint64 requestedSize READ requestedSize CONSTANT FINAL) +/
public:
    @disable this();
    /+this() {}+/
    @QInvokable void accept();
    @QInvokable void reject();
    QUrl origin() const;
    qint64 requestedSize() const;
    /+bool operator ==(ref const(QWebEngineQuotaRequest) that) const { return d_ptr == that.d_ptr; }+/
    /+bool operator !=(ref const(QWebEngineQuotaRequest) that) const { return d_ptr != that.d_ptr; }+/

private:
    /*this(QSharedPointer!(/+ QtWebEngineCore:: +/QuotaRequestController));*/
    /+ friend QtWebEngineCore::QuotaPermissionContextQt; +/
    QSharedPointer!(/+ QtWebEngineCore:: +/QuotaRequestController) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

