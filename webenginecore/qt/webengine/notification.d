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
module qt.webengine.notification;
extern(C++):

import qt.config;
import qt.core.namespace;
import qt.core.object;
import qt.core.scopedpointer;
//import qt.core.sharedpointer_impl;
import qt.core.string;
import qt.core.url;
import qt.gui.image;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct UserNotificationController;
}


extern(C++, class) struct QWebEngineNotificationPrivate;

/// Binding for C++ class [QWebEngineNotification](https://doc.qt.io/qt-5/qwebenginenotification.html).
class /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineNotification : QObject {
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QUrl origin READ origin CONSTANT FINAL)
    Q_PROPERTY(QString title READ title CONSTANT FINAL)
    Q_PROPERTY(QString message READ message CONSTANT FINAL)
    Q_PROPERTY(QString tag READ tag CONSTANT FINAL)
    Q_PROPERTY(QString language READ language CONSTANT FINAL)
    Q_PROPERTY(Qt::LayoutDirection direction READ direction CONSTANT FINAL) +/

public:
    /+ virtual +/ ~this();

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final bool matches(const(QWebEngineNotification) other) const;
    }));

    final QUrl origin() const;
    final QImage icon() const;
    final QString title() const;
    final QString message() const;
    final QString tag() const;
    final QString language() const;
    final /+ Qt:: +/qt.core.namespace.LayoutDirection direction() const;

public /+ Q_SLOTS +/:
    @QSlot final void show() const;
    @QSlot final void click() const;
    @QSlot final void close() const;

/+ Q_SIGNALS +/public:
    @QSignal final void closed();

private:
    /+ Q_DISABLE_COPY(QWebEngineNotification) +/
    /+ Q_DECLARE_PRIVATE(QWebEngineNotification) +/
    //this(ref const(QSharedPointer!(/+ QtWebEngineCore:: +/UserNotificationController)) controller);
    QScopedPointer!(QWebEngineNotificationPrivate) d_ptr;
    /+ friend class QQuickWebEngineProfilePrivate; +/
    /+ friend class QWebEngineProfilePrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

