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
module qt.webengine.newwindowrequest;
extern(C++):

import qt.config;
import qt.core.object;
import qt.core.rect;
import qt.core.scopedpointer;
import qt.core.sharedpointer_impl;
import qt.core.url;
import qt.helpers;
import qt.webengine.loadinginfo;
import qt.webengine.page;

/+ namespace QtWebEngineCore {
class WebContentsAdapter} +/


struct QWebEngineNewWindowRequestPrivate;

/// Binding for C++ class [QWebEngineNewWindowRequest](https://doc.qt.io/qt-6/qwebenginenewwindowrequest.html).
class /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineNewWindowRequest : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(DestinationType destination READ destination CONSTANT FINAL)
    Q_PROPERTY(QUrl requestedUrl READ requestedUrl CONSTANT FINAL)
    Q_PROPERTY(QRect requestedGeometry READ requestedGeometry CONSTANT FINAL)
    Q_PROPERTY(bool userInitiated READ isUserInitiated CONSTANT FINAL) +/
public:
    ~this();

    enum DestinationType {
        InNewWindow,
        InNewTab,
        InNewDialog,
        InNewBackgroundTab
    }
    /+ Q_ENUM(DestinationType) +/

    final DestinationType destination() const;
    final QUrl requestedUrl() const;
    final QRect requestedGeometry() const;
    final bool isUserInitiated() const;

    final void openIn(QWebEnginePage );

protected:
    this(DestinationType, ref const(QRect) , ref const(QUrl) , bool,
                                   QSharedPointer!(/+ QtWebEngineCore:: +/qt.webengine.loadinginfo.WebContentsAdapter),
                                   QObject  /+ = nullptr +/);

    QScopedPointer!(QWebEngineNewWindowRequestPrivate) d_ptr;
    /+ friend class QWebEnginePage; +/
    /+ friend class QWebEnginePagePrivate; +/
    /+ friend class QQuickWebEngineView; +/
    /+ friend class QQuickWebEngineViewPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

