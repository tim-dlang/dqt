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
module qt.webengine.navigationrequest;
extern(C++):

import qt.config;
import qt.core.object;
import qt.core.scopedpointer;
import qt.core.url;
import qt.helpers;

extern(C++, class) struct QWebEngineNavigationRequestPrivate;

/// Binding for C++ class [QWebEngineNavigationRequest](https://doc.qt.io/qt-6/qwebenginenavigationrequest.html).
class /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineNavigationRequest : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QUrl url READ url CONSTANT FINAL)
    Q_PROPERTY(bool isMainFrame READ isMainFrame CONSTANT FINAL)
    Q_PROPERTY(NavigationType navigationType READ navigationType CONSTANT FINAL) +/

public:
    ~this();

    // must match WebContentsAdapterClient::NavigationType
    enum NavigationType {
        LinkClickedNavigation,
        TypedNavigation,
        FormSubmittedNavigation,
        BackForwardNavigation,
        ReloadNavigation,
        OtherNavigation,
        RedirectNavigation,
    }
    /+ Q_ENUM(NavigationType) +/

    final QUrl url() const;
    final bool isMainFrame() const;
    final NavigationType navigationType() const;

    @QInvokable final void accept();
    @QInvokable final void reject();

/+ #if QT_DEPRECATED_SINCE(6, 2) +/
    enum NavigationRequestAction {
        AcceptRequest,
        IgnoreRequest = 0xFF
    }
    /+ Q_ENUM(NavigationRequestAction) +/

private:
    /+ Q_PROPERTY(NavigationRequestAction action READ action WRITE setAction NOTIFY actionChanged FINAL) +/

    /+ QT_DEPRECATED +/ final NavigationRequestAction action() const;
    /+ QT_DEPRECATED_X("Use accept/reject methods to handle the request") +/
        final void setAction(NavigationRequestAction action);

/+ Q_SIGNALS +/public:
    /+ QT_DEPRECATED +/ @QSignal final void actionChanged();
/+ #endif +/

private:
    this(ref const(QUrl) url, NavigationType navigationType, bool mainFrame,
                                    QObject parent = null);

    /+ friend class QWebEnginePagePrivate; +/
    /+ friend class QQuickWebEngineViewPrivate; +/
    final bool isAccepted() const;

    /+ Q_DECLARE_PRIVATE(QWebEngineNavigationRequest) +/
    QScopedPointer!(QWebEngineNavigationRequestPrivate) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

