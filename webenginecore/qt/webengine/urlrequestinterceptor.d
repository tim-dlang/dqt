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
module qt.webengine.urlrequestinterceptor;
extern(C++):

import qt.config;
import qt.core.object;
import qt.helpers;
import qt.webengine.urlrequestinfo;

/// Binding for C++ class [QWebEngineUrlRequestInterceptor](https://doc.qt.io/qt-5/qwebengineurlrequestinterceptor.html).
abstract class /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineUrlRequestInterceptor : QObject {
    mixin(Q_OBJECT);
    /+ Q_DISABLE_COPY(QWebEngineUrlRequestInterceptor) +/
public:
    /+ explicit +/this(QObject p = null)
    {
        super(p);
    }

    /+ virtual +/ abstract void interceptRequest(ref QWebEngineUrlRequestInfo info);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

