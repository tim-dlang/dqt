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
module qt.qml.propertyvaluesource;
extern(C++):

import qt.config;
import qt.helpers;
import qt.qml.property;

/// Binding for C++ class [QQmlPropertyValueSource](https://doc.qt.io/qt-5/qqmlpropertyvaluesource.html).
abstract class /+ Q_QML_EXPORT +/ QQmlPropertyValueSource
{
public:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this();
    }));
    /+ virtual +/~this();
    /+ virtual +/ abstract void setTarget(ref const(QQmlProperty) );
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #define QQmlPropertyValueSource_iid "org.qt-project.Qt.QQmlPropertyValueSource" +/
enum QQmlPropertyValueSource_iid = "org.qt-project.Qt.QQmlPropertyValueSource";

/+ Q_DECLARE_INTERFACE(QQmlPropertyValueSource, QQmlPropertyValueSource_iid) +/

