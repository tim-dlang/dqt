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
module qt.widgets.statusbar;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.string;
import qt.gui.event;
import qt.helpers;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(statusbar); +/


extern(C++, class) struct QStatusBarPrivate;

/// Binding for C++ class [QStatusBar](https://doc.qt.io/qt-5/qstatusbar.html).
class /+ Q_WIDGETS_EXPORT +/ QStatusBar: QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(bool sizeGripEnabled READ isSizeGripEnabled WRITE setSizeGripEnabled) +/

public:
    /+ explicit +/this(QWidget parent = null);
    /+ virtual +/~this();

    final void addWidget(QWidget widget, int stretch = 0);
    final int insertWidget(int index, QWidget widget, int stretch = 0);
    final void addPermanentWidget(QWidget widget, int stretch = 0);
    final int insertPermanentWidget(int index, QWidget widget, int stretch = 0);
    final void removeWidget(QWidget widget);

    final void setSizeGripEnabled(bool);
    final bool isSizeGripEnabled() const;

    final QString currentMessage() const;

public /+ Q_SLOTS +/:
    @QSlot final void showMessage(ref const(QString) text, int timeout = 0);
    @QSlot final void clearMessage();


/+ Q_SIGNALS +/public:
    @QSignal final void messageChanged(ref const(QString) text);

protected:
    override void showEvent(QShowEvent );
    override void paintEvent(QPaintEvent );
    override void resizeEvent(QResizeEvent );

    final void reformat();
    final void hideOrShow();
    override bool event(QEvent );

private:
    /+ Q_DISABLE_COPY(QStatusBar) +/
    /+ Q_DECLARE_PRIVATE(QStatusBar) +/
}

