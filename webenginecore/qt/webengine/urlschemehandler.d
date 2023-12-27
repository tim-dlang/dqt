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
module qt.webengine.urlschemehandler;
extern(C++):

import qt.config;
import qt.core.object;
import qt.helpers;
import qt.webengine.urlrequestjob;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct URLRequestContextGetterQt;
}



/// Binding for C++ class [QWebEngineUrlSchemeHandler](https://doc.qt.io/qt-5/qwebengineurlschemehandler.html).
abstract class /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineUrlSchemeHandler : QObject {
    mixin(Q_OBJECT);
public:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(QObject parent = null);
    }));
    ~this();

    /+ virtual +/ abstract void requestStarted(QWebEngineUrlRequestJob );

private:
    /+ Q_DISABLE_COPY(QWebEngineUrlSchemeHandler) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

