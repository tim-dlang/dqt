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
module qt.webengine.fullscreenrequest;
extern(C++):

import qt.config;
import qt.core.metamacros;
//import qt.core.pointer;
import qt.core.url;
import qt.helpers;
import qt.webengine.page;


/// Binding for C++ class [QWebEngineFullScreenRequest](https://doc.qt.io/qt-5/qwebenginefullscreenrequest.html).
extern(C++, class) struct /+ QWEBENGINEWIDGETS_EXPORT +/ QWebEngineFullScreenRequest {
    mixin(Q_GADGET);
    /+ Q_PROPERTY(bool toggleOn READ toggleOn CONSTANT)
    Q_PROPERTY(QUrl origin READ origin CONSTANT) +/
public:
    /*@QInvokable*/ void reject();
    /*@QInvokable*/ void accept();
    bool toggleOn() const { return m_toggleOn; }
    ref const(QUrl) origin() const { return m_origin; }

private:
    this(QWebEnginePage page, ref const(QUrl) origin, bool toggleOn);
    void* /*QPointer!(ValueClass!(QWebEnginePage))*/ m_page;
    const(QUrl) m_origin;
    const(bool) m_toggleOn;
    /+ friend class QWebEnginePagePrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

