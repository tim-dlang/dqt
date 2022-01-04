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
module qt.widgets.actiongroup;
extern(C++):

import qt.config;
import qt.helpers;
version(QT_NO_ACTION){}else
{
    import qt.core.list;
    import qt.core.object;
    import qt.core.string;
    import qt.gui.icon;
    import qt.widgets.action;
}

version(QT_NO_ACTION){}else
{

extern(C++, class) struct QActionGroupPrivate;

/// Binding for C++ class [QActionGroup](https://doc.qt.io/qt-5/qactiongroup.html).
class /+ Q_WIDGETS_EXPORT +/ QActionGroup : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QActionGroup) +/

    /+ Q_PROPERTY(QActionGroup::ExclusionPolicy exclusionPolicy READ exclusionPolicy WRITE setExclusionPolicy)
    Q_PROPERTY(bool enabled READ isEnabled WRITE setEnabled)
    Q_PROPERTY(bool visible READ isVisible WRITE setVisible) +/

public:
    enum /+ class +/ ExclusionPolicy {
        None,
        Exclusive,
        ExclusiveOptional
    }
    /+ Q_ENUM(ExclusionPolicy) +/

    /+ explicit +/this(QObject parent);
    ~this();

    final QAction addAction(QAction a);
    final QAction addAction(ref const(QString) text);
    final QAction addAction(ref const(QIcon) icon, ref const(QString) text);
    final void removeAction(QAction a);
    final QList!(QAction) actions() const;

    final QAction checkedAction() const;
    final bool isExclusive() const;
    final bool isEnabled() const;
    final bool isVisible() const;
    final ExclusionPolicy exclusionPolicy() const;


public /+ Q_SLOTS +/:
    @QSlot final void setEnabled(bool);
    pragma(inline, true) @QSlot final void setDisabled(bool b) { setEnabled(!b); }
    @QSlot final void setVisible(bool);
    @QSlot final void setExclusive(bool);
    @QSlot final void setExclusionPolicy(ExclusionPolicy policy);

/+ Q_SIGNALS +/public:
    @QSignal final void triggered(QAction );
    @QSignal final void hovered(QAction );

private:
    /+ Q_DISABLE_COPY(QActionGroup) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_actionTriggered())
    Q_PRIVATE_SLOT(d_func(), void _q_actionChanged())
    Q_PRIVATE_SLOT(d_func(), void _q_actionHovered()) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

}

