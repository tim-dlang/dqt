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
module qt.qml.applicationengine;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.list;
import qt.core.object;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.qml.engine;

extern(C++, class) struct QQmlApplicationEnginePrivate;
/// Binding for C++ class [QQmlApplicationEngine](https://doc.qt.io/qt-5/qqmlapplicationengine.html).
class /+ Q_QML_EXPORT +/ QQmlApplicationEngine : QQmlEngine
{
    mixin(Q_OBJECT);
public:
    this(QObject parent = null);
    this(ref const(QUrl) url, QObject parent = null);
    this(ref const(QString) filePath, QObject parent = null);
    ~this();

/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    final QList!(QObject) rootObjects(); // ### Qt 6: remove
/+ #endif +/
    final QList!(QObject) rootObjects() const;

public /+ Q_SLOTS +/:
    @QSlot final void load(ref const(QUrl) url);
    @QSlot final void load(ref const(QString) filePath);
    /+ void setInitialProperties(const QVariantMap &initialProperties); +/
    @QSlot final void loadData(ref const(QByteArray) data, ref const(QUrl) url = globalInitVar!QUrl);

/+ Q_SIGNALS +/public:
    @QSignal final void objectCreated(QObject object, ref const(QUrl) url);

private:
    /+ Q_DISABLE_COPY(QQmlApplicationEngine) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_loadTranslations())
    Q_DECLARE_PRIVATE(QQmlApplicationEngine) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

