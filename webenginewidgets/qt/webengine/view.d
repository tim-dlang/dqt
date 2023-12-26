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
module qt.webengine.view;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.coreevent;
import qt.core.global;
import qt.core.scopedpointer;
import qt.core.size;
import qt.core.string;
import qt.core.url;
import qt.gui.event;
import qt.gui.icon;
import qt.helpers;
import qt.webengine.callback;
import qt.webengine.history;
import qt.webengine.httprequest;
import qt.webengine.page;
import qt.webengine.settings;
import qt.widgets.widget;
version (QT_NO_ACTION) {} else
    import qt.widgets.action;

extern(C++, class) struct QWebEngineViewAccessible;
extern(C++, class) struct QWebEngineViewPrivate;

/// Binding for C++ class [QWebEngineView](https://doc.qt.io/qt-5/qwebengineview.html).
class /+ QWEBENGINEWIDGETS_EXPORT +/ QWebEngineView : QWidget {
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QString title READ title)
    Q_PROPERTY(QUrl url READ url WRITE setUrl)
    Q_PROPERTY(QUrl iconUrl READ iconUrl NOTIFY iconUrlChanged)
    Q_PROPERTY(QIcon icon READ icon NOTIFY iconChanged)
    Q_PROPERTY(QString selectedText READ selectedText)
    Q_PROPERTY(bool hasSelection READ hasSelection)
    Q_PROPERTY(qreal zoomFactor READ zoomFactor WRITE setZoomFactor) +/

public:
    /+ explicit +/this(QWidget parent = null);
    /+ virtual +/~this();

    final QWebEnginePage page() const;
    final void setPage(QWebEnginePage page);

    final void load(ref const(QUrl) url);
    final void load(ref const(QWebEngineHttpRequest) request);
    final void setHtml(ref const(QString) html, ref const(QUrl) baseUrl = globalInitVar!QUrl);
    final void setContent(ref const(QByteArray) data, ref const(QString) mimeType = globalInitVar!QString, ref const(QUrl) baseUrl = globalInitVar!QUrl);

    final QWebEngineHistory* history() const;

    final QString title() const;
    final void setUrl(ref const(QUrl) url);
    final QUrl url() const;
    final QUrl iconUrl() const;
    final QIcon icon() const;

    final bool hasSelection() const;
    final QString selectedText() const;

    version (QT_NO_ACTION) {} else
    {
        final QAction pageAction(QWebEnginePage.WebAction action) const;
    }
    final void triggerPageAction(QWebEnginePage.WebAction action, bool checked = false);

    final qreal zoomFactor() const;
    final void setZoomFactor(qreal factor);
    final void findText(ref const(QString) subString, QWebEnginePage.FindFlags options = QWebEnginePage.FindFlags(), ref const(QWebEngineCallback!(bool)) resultCallback = globalInitVar!(QWebEngineCallback!(bool)));

    override QSize sizeHint() const;
    final QWebEngineSettings* settings() const;

public /+ Q_SLOTS +/:
    @QSlot final void stop();
    @QSlot final void back();
    @QSlot final void forward();
    @QSlot final void reload();

/+ Q_SIGNALS +/public:
    @QSignal final void loadStarted();
    @QSignal final void loadProgress(int progress);
    @QSignal final void loadFinished(bool);
    @QSignal final void titleChanged(ref const(QString) title);
    @QSignal final void selectionChanged();
    @QSignal final void urlChanged(ref const(QUrl));
    @QSignal final void iconUrlChanged(ref const(QUrl));
    @QSignal final void iconChanged(ref const(QIcon));
    @QSignal final void renderProcessTerminated(QWebEnginePage.RenderProcessTerminationStatus terminationStatus,
                                 int exitCode);

protected:
    /+ virtual +/ QWebEngineView createWindow(QWebEnginePage.WebWindowType type);
/+ #if QT_CONFIG(contextmenu) +/
    override void contextMenuEvent(QContextMenuEvent);
/+ #endif +/ // QT_CONFIG(contextmenu)
    override bool event(QEvent);
    override void showEvent(QShowEvent );
    override void hideEvent(QHideEvent );
    override void closeEvent(QCloseEvent );
/+ #if QT_CONFIG(draganddrop) +/
    override void dragEnterEvent(QDragEnterEvent e);
    override void dragLeaveEvent(QDragLeaveEvent e);
    override void dragMoveEvent(QDragMoveEvent e);
    override void dropEvent(QDropEvent e);
/+ #endif +/ // QT_CONFIG(draganddrop)

private:
    /+ Q_DISABLE_COPY(QWebEngineView) +/
    /+ Q_DECLARE_PRIVATE(QWebEngineView) +/
    QScopedPointer!(QWebEngineViewPrivate) d_ptr;

    /+ friend class QWebEnginePage; +/
    /+ friend class QWebEnginePagePrivate; +/
/+ #if QT_CONFIG(accessibility) +/
    /+ friend class QWebEngineViewAccessible; +/
/+ #endif +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

