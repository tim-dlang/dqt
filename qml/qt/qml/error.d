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
module qt.qml.error;
extern(C++):

import qt.config;
import qt.core.object;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.url;
import qt.helpers;

// ### Qt 6: should this be called QQmlMessage, since it can have a message type?
/+ class QDebug; +/
extern(C++, class) struct QQmlErrorPrivate;
/// Binding for C++ class [QQmlError](https://doc.qt.io/qt-5/qqmlerror.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_QML_EXPORT +/ QQmlError
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QQmlError) );
    ref QQmlError opAssign(ref const(QQmlError) );
    ~this();

    bool isValid() const;

    QUrl url() const;
    void setUrl(ref const(QUrl) );
    QString description() const;
    void setDescription(ref const(QString) );
    int line() const;
    void setLine(int);
    int column() const;
    void setColumn(int);

    QObject object() const;
    void setObject(QObject );

    /+ QtMsgType messageType() const; +/
    /+ void setMessageType(QtMsgType messageType); +/

    QString toString() const;
private:
    QQmlErrorPrivate* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ QDebug Q_QML_EXPORT operator<<(QDebug debug, const QQmlError &error);

Q_DECLARE_TYPEINFO(QQmlError, Q_MOVABLE_TYPE); +/

