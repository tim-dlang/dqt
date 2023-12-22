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
module qt.webengine.fullscreenrequest;
extern(C++):

import qt.config;
import qt.core.metamacros;
import qt.core.object;
import qt.core.shareddata;
import qt.core.url;
import qt.helpers;

extern(C++, class) struct QWebEngineFullScreenRequestPrivate;

extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineFullScreenRequest
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(bool toggleOn READ toggleOn CONSTANT)
    Q_PROPERTY(QUrl origin READ origin CONSTANT) +/

public:
    @disable this(this);
    this(ref const(QWebEngineFullScreenRequest) other);
    /+ref QWebEngineFullScreenRequest operator =(ref const(QWebEngineFullScreenRequest) other);+/
    /+ QWebEngineFullScreenRequest(QWebEngineFullScreenRequest &&other); +/
    /+ QWebEngineFullScreenRequest &operator=(QWebEngineFullScreenRequest &&other); +/
    ~this();

    @QInvokable void reject();
    @QInvokable void accept();
    bool toggleOn() const;
    QUrl origin() const;

private:
    /+ friend class QWebEnginePagePrivate; +/
    /+ friend class QQuickWebEngineViewPrivate; +/
    /+ QWebEngineFullScreenRequest(const QUrl &origin, bool toggleOn, const std::function<void (bool)> &setFullScreenCallback); +/
    QExplicitlySharedDataPointer!(QWebEngineFullScreenRequestPrivate) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

