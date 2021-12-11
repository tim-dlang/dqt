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
module qt.widgets.completer;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.object;
import qt.core.rect;
import qt.core.string;
import qt.core.stringlist;
import qt.helpers;
import qt.widgets.abstractitemview;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(completer); +/


extern(C++, class) struct QCompleterPrivate;
/+ class QAbstractItemView;
class QAbstractProxyModel;
class QWidget; +/

class /+ Q_WIDGETS_EXPORT +/ QCompleter : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QString completionPrefix READ completionPrefix WRITE setCompletionPrefix)
    Q_PROPERTY(ModelSorting modelSorting READ modelSorting WRITE setModelSorting)
    Q_PROPERTY(Qt::MatchFlags filterMode READ filterMode WRITE setFilterMode)
    Q_PROPERTY(CompletionMode completionMode READ completionMode WRITE setCompletionMode)
    Q_PROPERTY(int completionColumn READ completionColumn WRITE setCompletionColumn)
    Q_PROPERTY(int completionRole READ completionRole WRITE setCompletionRole)
    Q_PROPERTY(int maxVisibleItems READ maxVisibleItems WRITE setMaxVisibleItems)
    Q_PROPERTY(Qt::CaseSensitivity caseSensitivity READ caseSensitivity WRITE setCaseSensitivity)
    Q_PROPERTY(bool wrapAround READ wrapAround WRITE setWrapAround) +/

public:
    enum CompletionMode {
        PopupCompletion,
        UnfilteredPopupCompletion,
        InlineCompletion
    }
    /+ Q_ENUM(CompletionMode) +/

    enum ModelSorting {
        UnsortedModel = 0,
        CaseSensitivelySortedModel,
        CaseInsensitivelySortedModel
    }
    /+ Q_ENUM(ModelSorting) +/

    this(QObject parent = null);
    this(QAbstractItemModel model, QObject parent = null);
/+ #if QT_CONFIG(stringlistmodel) +/
    this(ref const(QStringList) completions, QObject parent = null);
/+ #endif +/
    ~this();

    final void setWidget(QWidget widget);
    final QWidget widget() const;

    final void setModel(QAbstractItemModel c);
    final QAbstractItemModel model() const;

    final void setCompletionMode(CompletionMode mode);
    final CompletionMode completionMode() const;

    final void setFilterMode(/+ Qt:: +/qt.core.namespace.MatchFlags filterMode);
    final /+ Qt:: +/qt.core.namespace.MatchFlags filterMode() const;

    final QAbstractItemView popup() const;
    final void setPopup(QAbstractItemView popup);

    final void setCaseSensitivity(/+ Qt:: +/qt.core.namespace.CaseSensitivity caseSensitivity);
    final /+ Qt:: +/qt.core.namespace.CaseSensitivity caseSensitivity() const;

    final void setModelSorting(ModelSorting sorting);
    final ModelSorting modelSorting() const;

    final void setCompletionColumn(int column);
    final int  completionColumn() const;

    final void setCompletionRole(int role);
    final int  completionRole() const;

    final bool wrapAround() const;

    final int maxVisibleItems() const;
    final void setMaxVisibleItems(int maxItems);

    final int completionCount() const;
    final bool setCurrentRow(int row);
    final int currentRow() const;

    final QModelIndex currentIndex() const;
    final QString currentCompletion() const;

    final QAbstractItemModel completionModel() const;

    final QString completionPrefix() const;

public /+ Q_SLOTS +/:
    @QSlot final void setCompletionPrefix(ref const(QString) prefix);
    @QSlot final void complete(ref const(QRect) rect = globalInitVar!QRect);
    @QSlot final void setWrapAround(bool wrap);

public:
    /+ virtual +/ QString pathFromIndex(ref const(QModelIndex) index) const;
    /+ virtual +/ QStringList splitPath(ref const(QString) path) const;

protected:
    override bool eventFilter(QObject o, QEvent e);
    override bool event(QEvent );

/+ Q_SIGNALS +/public:
    @QSignal final void activated(ref const(QString) text);
    @QSignal final void activated(ref const(QModelIndex) index);
    @QSignal final void highlighted(ref const(QString) text);
    @QSignal final void highlighted(ref const(QModelIndex) index);

private:
    /+ Q_DISABLE_COPY(QCompleter) +/
    /+ Q_DECLARE_PRIVATE(QCompleter) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_complete(QModelIndex))
    Q_PRIVATE_SLOT(d_func(), void _q_completionSelected(const QItemSelection&))
    Q_PRIVATE_SLOT(d_func(), void _q_autoResizePopup())
    Q_PRIVATE_SLOT(d_func(), void _q_fileSystemModelDirectoryLoaded(const QString&)) +/
}

