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
module qt.qml.parserstatus;
extern(C++):

import qt.config;
import qt.helpers;

interface QQmlParserStatusInterface
{
    // /+ virtual +/~this();

    /+ virtual +/ abstract void classBegin();
    /+ virtual +/ abstract void componentComplete();
}

/// Binding for C++ class [QQmlParserStatus](https://doc.qt.io/qt-6/qqmlparserstatus.html).
abstract class /+ Q_QML_EXPORT +/ QQmlParserStatus
{
public:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this();
    }));
    /+ virtual +/~this();

    /+ virtual +/ abstract void classBegin();
    /+ virtual +/ abstract void componentComplete();

private:
    /+ friend class QQmlComponent; +/
    /+ friend class QQmlComponentPrivate; +/
    /+ friend class QQmlEnginePrivate; +/
    /+ friend class QQmlObjectCreator; +/
    QQmlParserStatus* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #define QQmlParserStatus_iid "org.qt-project.Qt.QQmlParserStatus" +/
enum QQmlParserStatus_iid = "org.qt-project.Qt.QQmlParserStatus";
/+ Q_DECLARE_INTERFACE(QQmlParserStatus, QQmlParserStatus_iid) +/

static assert(__traits(classInstanceSize, QQmlParserStatus) == (void*).sizeof * 2);
struct QQmlParserStatusFakeInheritance
{
    static assert(__traits(classInstanceSize, QQmlParserStatus) % (void*).sizeof == 0);
    void*[__traits(classInstanceSize, QQmlParserStatus) / (void*).sizeof - 1] data;
}
