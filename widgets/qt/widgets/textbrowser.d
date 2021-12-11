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
module qt.widgets.textbrowser;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.string;
import qt.core.stringlist;
import qt.core.url;
import qt.core.variant;
import qt.gui.event;
import qt.gui.textdocument;
import qt.helpers;
import qt.widgets.textedit;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(textbrowser); +/


extern(C++, class) struct QTextBrowserPrivate;

class /+ Q_WIDGETS_EXPORT +/ QTextBrowser : QTextEdit
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QUrl source READ source WRITE setSource)
    Q_PROPERTY(QTextDocument::ResourceType sourceType READ sourceType)
    Q_OVERRIDE(bool modified SCRIPTABLE false)
    Q_OVERRIDE(bool readOnly DESIGNABLE false SCRIPTABLE false)
    Q_OVERRIDE(bool undoRedoEnabled DESIGNABLE false SCRIPTABLE false)
    Q_PROPERTY(QStringList searchPaths READ searchPaths WRITE setSearchPaths)
    Q_PROPERTY(bool openExternalLinks READ openExternalLinks WRITE setOpenExternalLinks)
    Q_PROPERTY(bool openLinks READ openLinks WRITE setOpenLinks) +/

public:
    /+ explicit +/this(QWidget parent = null);
    /+ virtual +/~this();

    final QUrl source() const;
    final QTextDocument.ResourceType sourceType() const;

    final QStringList searchPaths() const;
    final void setSearchPaths(ref const(QStringList) paths);

    /+ virtual +/ override QVariant loadResource(int type, ref const(QUrl) name);

    final bool isBackwardAvailable() const;
    final bool isForwardAvailable() const;
    final void clearHistory();
    final QString historyTitle(int) const;
    final QUrl historyUrl(int) const;
    final int backwardHistoryCount() const;
    final int forwardHistoryCount() const;

    final bool openExternalLinks() const;
    final void setOpenExternalLinks(bool open);

    final bool openLinks() const;
    final void setOpenLinks(bool open);

public /+ Q_SLOTS +/:
/+ #if QT_VERSION < QT_VERSION_CHECK(6,0,0) +/
    /+ virtual +/ @QSlot void setSource(ref const(QUrl) name);
    @QSlot final void setSource(ref const(QUrl) name, QTextDocument.ResourceType type);
/+ #else
    void setSource(const QUrl &name, QTextDocument::ResourceType type = QTextDocument::UnknownResource);
#endif +/
    /+ virtual +/ @QSlot void backward();
    /+ virtual +/ @QSlot void forward();
    /+ virtual +/ @QSlot void home();
    /+ virtual +/ @QSlot void reload();

/+ Q_SIGNALS +/public:
    @QSignal final void backwardAvailable(bool);
    @QSignal final void forwardAvailable(bool);
    @QSignal final void historyChanged();
    @QSignal final void sourceChanged(ref const(QUrl) );
    @QSignal final void highlighted(ref const(QUrl) );
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+ QT_DEPRECATED_VERSION_X_5_15("Use QTextBrowser::highlighted(QUrl) instead") +/
        @QSignal final void highlighted(ref const(QString) );
/+ #endif +/
    @QSignal final void anchorClicked(ref const(QUrl) );

protected:
    override bool event(QEvent e);
    /+ virtual +/ override void keyPressEvent(QKeyEvent ev);
    /+ virtual +/ override void mouseMoveEvent(QMouseEvent ev);
    /+ virtual +/ override void mousePressEvent(QMouseEvent ev);
    /+ virtual +/ override void mouseReleaseEvent(QMouseEvent ev);
    /+ virtual +/ override void focusOutEvent(QFocusEvent ev);
    /+ virtual +/ override bool focusNextPrevChild(bool next);
    /+ virtual +/ override void paintEvent(QPaintEvent e);
/+ #if QT_VERSION >= QT_VERSION_CHECK(6,0,0)
    virtual
#endif +/
    final void doSetSource(ref const(QUrl) name, QTextDocument.ResourceType type = QTextDocument.ResourceType.UnknownResource);

private:
    /+ Q_DISABLE_COPY(QTextBrowser) +/
    /+ Q_DECLARE_PRIVATE(QTextBrowser) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_documentModified())
    Q_PRIVATE_SLOT(d_func(), void _q_activateAnchor(const QString &))
    Q_PRIVATE_SLOT(d_func(), void _q_highlightLink(const QString &)) +/
}

