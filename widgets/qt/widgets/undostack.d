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
module qt.widgets.undostack;
extern(C++):

import qt.config;
import qt.core.object;
import qt.core.string;
import qt.helpers;
version (QT_NO_ACTION) {} else
    import qt.widgets.action;

/+ QT_REQUIRE_CONFIG(undocommand); +/

extern(C++, class) struct QUndoCommandPrivate;
extern(C++, class) struct QUndoStackPrivate;

/// Binding for C++ class [QUndoCommand](https://doc.qt.io/qt-5/qundocommand.html).
class /+ Q_WIDGETS_EXPORT +/ QUndoCommand
{
private:
    QUndoCommandPrivate* d;

public:
    /+ explicit +/this(QUndoCommand parent = null);
    /+ explicit +/this(ref const(QString) text, QUndoCommand parent = null);
    /+ virtual +/~this();

    /+ virtual +/ void undo();
    /+ virtual +/ void redo();

    final QString text() const;
    final QString actionText() const;
    final void setText(ref const(QString) text);

    final bool isObsolete() const;
    final void setObsolete(bool obsolete);

    /+ virtual +/ int id() const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ virtual +/ bool mergeWith(const(QUndoCommand) other);
    }));

    final int childCount() const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final const(QUndoCommand) child(int index) const;
    }));

private:
    /+ Q_DISABLE_COPY(QUndoCommand) +/
    /+ friend class QUndoStack; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #if QT_CONFIG(undostack) +/

/// Binding for C++ class [QUndoStack](https://doc.qt.io/qt-5/qundostack.html).
class /+ Q_WIDGETS_EXPORT +/ QUndoStack : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QUndoStack) +/
    /+ Q_PROPERTY(bool active READ isActive WRITE setActive)
    Q_PROPERTY(int undoLimit READ undoLimit WRITE setUndoLimit)
    Q_PROPERTY(bool canUndo READ canUndo NOTIFY canUndoChanged)
    Q_PROPERTY(bool canRedo READ canRedo NOTIFY canRedoChanged)
    Q_PROPERTY(QString undoText READ undoText NOTIFY undoTextChanged)
    Q_PROPERTY(QString redoText READ redoText NOTIFY redoTextChanged)
    Q_PROPERTY(bool clean READ isClean NOTIFY cleanChanged) +/

public:
    /+ explicit +/this(QObject parent = null);
    ~this();
    final void clear();

    final void push(QUndoCommand cmd);

    final bool canUndo() const;
    final bool canRedo() const;
    final QString undoText() const;
    final QString redoText() const;

    final int count() const;
    final int index() const;
    final QString text(int idx) const;

    version (QT_NO_ACTION) {} else
    {
        final QAction createUndoAction(QObject parent,
                                        ref const(QString) prefix = globalInitVar!QString) const;
        final QAction createRedoAction(QObject parent,
                                        ref const(QString) prefix = globalInitVar!QString) const;
    }

    final bool isActive() const;
    final bool isClean() const;
    final int cleanIndex() const;

    final void beginMacro(ref const(QString) text);
    final void endMacro();

    final void setUndoLimit(int limit);
    final int undoLimit() const;

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final const(QUndoCommand) command(int index) const;
    }));

public /+ Q_SLOTS +/:
    @QSlot final void setClean();
    @QSlot final void resetClean();
    @QSlot final void setIndex(int idx);
    @QSlot final void undo();
    @QSlot final void redo();
    @QSlot final void setActive(bool active = true);

/+ Q_SIGNALS +/public:
    @QSignal final void indexChanged(int idx);
    @QSignal final void cleanChanged(bool clean);
    @QSignal final void canUndoChanged(bool canUndo);
    @QSignal final void canRedoChanged(bool canRedo);
    @QSignal final void undoTextChanged(ref const(QString) undoText);
    @QSignal final void redoTextChanged(ref const(QString) redoText);

private:
    /+ Q_DISABLE_COPY(QUndoStack) +/
    /+ friend class QUndoGroup; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #endif +/ // QT_CONFIG(undostack)

