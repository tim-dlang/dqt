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
module qt.widgets.dialog;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.object;
import qt.core.size;
import qt.gui.event;
import qt.helpers;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(dialog); +/



extern(C++, class) struct QDialogPrivate;

/// Binding for C++ class [QDialog](https://doc.qt.io/qt-6/qdialog.html).
class /+ Q_WIDGETS_EXPORT +/ QDialog : QWidget
{
    mixin(Q_OBJECT);
    /+ friend class QPushButton; +/

    /+ Q_PROPERTY(bool sizeGripEnabled READ isSizeGripEnabled WRITE setSizeGripEnabled)
    Q_PROPERTY(bool modal READ isModal WRITE setModal) +/

public:
    /+ explicit +/this(QWidget parent = null, /+ Qt:: +/qt.core.namespace.WindowFlags f = /+ Qt:: +/qt.core.namespace.WindowFlags());
    ~this();

    enum DialogCode { Rejected, Accepted }

    final int result() const;

    override void setVisible(bool visible);

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;

    final void setSizeGripEnabled(bool);
    final bool isSizeGripEnabled() const;

    final void setModal(bool modal);
    final void setResult(int r);

/+ Q_SIGNALS +/public:
    @QSignal final void finished(int result);
    @QSignal final void accepted();
    @QSignal final void rejected();

public /+ Q_SLOTS +/:
    /+ virtual +/ @QSlot void open();
    /+ virtual +/ @QSlot int exec();
    /+ virtual +/ @QSlot void done(int);
    /+ virtual +/ @QSlot void accept();
    /+ virtual +/ @QSlot void reject();

protected:
    this(ref QDialogPrivate , QWidget parent, /+ Qt:: +/qt.core.namespace.WindowFlags f = /+ Qt:: +/qt.core.namespace.WindowFlags());

    override void keyPressEvent(QKeyEvent );
    override void closeEvent(QCloseEvent );
    override void showEvent(QShowEvent );
    override void resizeEvent(QResizeEvent );
    version(QT_NO_CONTEXTMENU){}else
    {
        override void contextMenuEvent(QContextMenuEvent );
    }
    override bool eventFilter(QObject , QEvent );
    final void adjustPosition(QWidget);
private:
    /+ Q_DECLARE_PRIVATE(QDialog) +/
    /+ Q_DISABLE_COPY(QDialog) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

