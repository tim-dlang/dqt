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
module qt.qml.abstracturlinterceptor;
extern(C++):

import qt.config;
import qt.core.url;
import qt.helpers;

/// Binding for C++ class [QQmlAbstractUrlInterceptor](https://doc.qt.io/qt-6/qqmlabstracturlinterceptor.html).
abstract class /+ Q_QML_EXPORT +/ QQmlAbstractUrlInterceptor
{
public:
    enum DataType { //Matches QQmlDataBlob::Type
        QmlFile = 0,
        JavaScriptFile = 1,
        QmldirFile = 2,
        UrlString = 0x1000
    }

    /+ QQmlAbstractUrlInterceptor() = default; +/
    /+ virtual +/~this() {};
    /+ virtual +/ abstract QUrl intercept(ref const(QUrl) path, DataType type);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

