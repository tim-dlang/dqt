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
module qt.gui.undogroup;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.object;
import qt.core.string;
import qt.gui.undostack;
import qt.helpers;
version (QT_NO_ACTION) {} else
    import qt.gui.action;

/+ QT_REQUIRE_CONFIG(undogroup); +/


extern(C++, class) struct QUndoGroupPrivate;

/// Binding for C++ class [QUndoGroup](https://doc.qt.io/qt-6/qundogroup.html).
class /+ Q_GUI_EXPORT +/ QUndoGroup : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QUndoGroup) +/

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    final void addStack(QUndoStack stack);
    final void removeStack(QUndoStack stack);
    final QList!(QUndoStack) stacks() const;
    final QUndoStack activeStack() const;

    version (QT_NO_ACTION) {} else
    {
        final QAction createUndoAction(QObject parent, ref const(QString) prefix = globalInitVar!QString) const;
        final QAction createRedoAction(QObject parent, ref const(QString) prefix = globalInitVar!QString) const;
    }

    final bool canUndo() const;
    final bool canRedo() const;
    final QString undoText() const;
    final QString redoText() const;
    final bool isClean() const;

public /+ Q_SLOTS +/:
    @QSlot final void undo();
    @QSlot final void redo();
    @QSlot final void setActiveStack(QUndoStack stack);

/+ Q_SIGNALS +/public:
    @QSignal final void activeStackChanged(QUndoStack stack);
    @QSignal final void indexChanged(int idx);
    @QSignal final void cleanChanged(bool clean);
    @QSignal final void canUndoChanged(bool canUndo);
    @QSignal final void canRedoChanged(bool canRedo);
    @QSignal final void undoTextChanged(ref const(QString) undoText);
    @QSignal final void redoTextChanged(ref const(QString) redoText);

private:
    /+ Q_DISABLE_COPY(QUndoGroup) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

