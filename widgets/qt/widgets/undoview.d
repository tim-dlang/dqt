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
module qt.widgets.undoview;
extern(C++):

import qt.config;
import qt.core.string;
import qt.gui.icon;
import qt.gui.undogroup;
import qt.gui.undostack;
import qt.helpers;
import qt.widgets.listview;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(undoview); +/


extern(C++, class) struct QUndoViewPrivate;


/// Binding for C++ class [QUndoView](https://doc.qt.io/qt-6/qundoview.html).
class /+ Q_WIDGETS_EXPORT +/ QUndoView : QListView
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QUndoView) +/
    /+ Q_PROPERTY(QString emptyLabel READ emptyLabel WRITE setEmptyLabel)
    Q_PROPERTY(QIcon cleanIcon READ cleanIcon WRITE setCleanIcon) +/

public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(QUndoStack stack, QWidget parent = null);
/+ #if QT_CONFIG(undogroup) +/
    /+ explicit +/this(QUndoGroup group, QWidget parent = null);
/+ #endif +/
    ~this();

    final QUndoStack stack() const;
/+ #if QT_CONFIG(undogroup) +/
    final QUndoGroup group() const;
/+ #endif +/

    final void setEmptyLabel(ref const(QString) label);
    final QString emptyLabel() const;

    final void setCleanIcon(ref const(QIcon) icon);
    final QIcon cleanIcon() const;

public /+ Q_SLOTS +/:
    @QSlot final void setStack(QUndoStack stack);
/+ #if QT_CONFIG(undogroup) +/
    @QSlot final void setGroup(QUndoGroup group);
/+ #endif +/

private:
    /+ Q_DISABLE_COPY(QUndoView) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

