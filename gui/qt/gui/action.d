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
module qt.gui.action;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.list;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.core.variant;
import qt.gui.actiongroup;
import qt.gui.font;
import qt.gui.icon;
import qt.gui.keysequence;
import qt.helpers;

/+ #if QT_CONFIG(shortcut)
#endif
QT_REQUIRE_CONFIG(action); +/


extern(C++, class) struct QActionPrivate;
/+ #if QT_DEPRECATED_SINCE(6,0) +/
extern(C++, class) struct QGraphicsWidget;
/+ #endif +/

/// Binding for C++ class [QAction](https://doc.qt.io/qt-6/qaction.html).
class /+ Q_GUI_EXPORT +/ QAction : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QAction) +/

    /+ Q_PROPERTY(bool checkable READ isCheckable WRITE setCheckable NOTIFY checkableChanged FINAL)
    Q_PROPERTY(bool checked READ isChecked WRITE setChecked NOTIFY toggled)
    Q_PROPERTY(bool enabled READ isEnabled WRITE setEnabled NOTIFY enabledChanged
               RESET resetEnabled FINAL)
    Q_PROPERTY(QIcon icon READ icon WRITE setIcon NOTIFY changed)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY changed)
    Q_PROPERTY(QString iconText READ iconText WRITE setIconText NOTIFY changed)
    Q_PROPERTY(QString toolTip READ toolTip WRITE setToolTip NOTIFY changed)
    Q_PROPERTY(QString statusTip READ statusTip WRITE setStatusTip NOTIFY changed)
    Q_PROPERTY(QString whatsThis READ whatsThis WRITE setWhatsThis NOTIFY changed)
    Q_PROPERTY(QFont font READ font WRITE setFont NOTIFY changed)
#if QT_CONFIG(shortcut)
    Q_PROPERTY(QKeySequence shortcut READ shortcut WRITE setShortcut NOTIFY changed)
    Q_PROPERTY(Qt::ShortcutContext shortcutContext READ shortcutContext WRITE setShortcutContext
               NOTIFY changed)
    Q_PROPERTY(bool autoRepeat READ autoRepeat WRITE setAutoRepeat NOTIFY changed)
#endif // QT_CONFIG(shortcut)
    Q_PROPERTY(bool visible READ isVisible WRITE setVisible NOTIFY visibleChanged FINAL)
    Q_PROPERTY(MenuRole menuRole READ menuRole WRITE setMenuRole NOTIFY changed)
    Q_PROPERTY(bool iconVisibleInMenu READ isIconVisibleInMenu WRITE setIconVisibleInMenu
               NOTIFY changed)
    Q_PROPERTY(bool shortcutVisibleInContextMenu READ isShortcutVisibleInContextMenu
               WRITE setShortcutVisibleInContextMenu NOTIFY changed)
    Q_PROPERTY(Priority priority READ priority WRITE setPriority NOTIFY changed) +/

public:
    // note this is copied into qplatformmenu.h, which must stay in sync
    enum MenuRole { NoRole = 0, TextHeuristicRole, ApplicationSpecificRole, AboutQtRole,
                    AboutRole, PreferencesRole, QuitRole }
    /+ Q_ENUM(MenuRole) +/
    enum Priority { LowPriority = 0,
                    NormalPriority = 128,
                    HighPriority = 256}
    /+ Q_ENUM(Priority) +/
    /+ explicit +/this(QObject parent = null);
    /+ explicit +/this(ref const(QString) text, QObject parent = null);
    /+ explicit +/this(ref const(QIcon) icon, ref const(QString) text, QObject parent = null);

    ~this();

    final QList!(QObject) associatedObjects() const;

/+ #if QT_DEPRECATED_SINCE(6,0)
#ifdef Q_CLANG_QDOC
    QWidget *parentWidget() const;
    QList<QWidget*> associatedWidgets() const;
    QList<QGraphicsWidget*> associatedGraphicsWidgets() const;
#else +/
    /*
        These are templates so that instantiation happens only in calling code, when
        QWidget, QMenu, and QGraphicsWidget can be expected to be fully defined.
    */
    /+ template<typename T = QWidget*> +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use parent() with qobject_cast() instead") +/
        final T parentWidget(T)() const
    {
        auto result = parent();
        while (result && !qobject_cast!(T)(result))
            result = result.parent();
        return static_cast!(T)(result);
    }

    /+ template<typename T = QWidget*> +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use associatedObjects() with qobject_cast() instead")
    QList<T> associatedWidgets() const
    {
        QList<T> result;
        for (auto object : associatedObjects())
            if (auto widget = qobject_cast<T>(object))
                result.append(widget);
        return result;
    } +/
    /+ template<typename T = QGraphicsWidget*> +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use associatedObjects() with qobject_cast() instead")
    QList<T> associatedGraphicsWidgets() const
    {
        QList<T> result;
        for (auto object : associatedObjects())
            if (auto graphicsWidget = qobject_cast<T>(object))
                result.append(graphicsWidget);
        return result;
    } +/
/+ #endif
#endif +/

    final void setActionGroup(QActionGroup group);
    final QActionGroup actionGroup() const;
    final void setIcon(ref const(QIcon) icon);
    final QIcon icon() const;

    final void setText(ref const(QString) text);
    final QString text() const;

    final void setIconText(ref const(QString) text);
    final QString iconText() const;

    final void setToolTip(ref const(QString) tip);
    final QString toolTip() const;

    final void setStatusTip(ref const(QString) statusTip);
    final QString statusTip() const;

    final void setWhatsThis(ref const(QString) what);
    final QString whatsThis() const;

    final void setPriority(Priority priority);
    final Priority priority() const;

    final void setSeparator(bool b);
    final bool isSeparator() const;

/+ #if QT_CONFIG(shortcut) +/
    final void setShortcut(ref const(QKeySequence) shortcut);
    final void setShortcut(const QString  shortcut)
    {
        auto tmp = QKeySequence(shortcut);
        setShortcut(tmp);
    }
    final QKeySequence shortcut() const;

    /+ final void setShortcuts(ref const(QList!(QKeySequence)) shortcuts);
    final void setShortcuts(QKeySequence.StandardKey);
    final QList!(QKeySequence) shortcuts() const; +/

    final void setShortcutContext(/+ Qt:: +/qt.core.namespace.ShortcutContext context);
    final /+ Qt:: +/qt.core.namespace.ShortcutContext shortcutContext() const;

    final void setAutoRepeat(bool);
    final bool autoRepeat() const;
/+ #endif +/ // QT_CONFIG(shortcut)

    final void setFont(ref const(QFont) font);
    final QFont font() const;

    final void setCheckable(bool);
    final bool isCheckable() const;

    final QVariant data() const;
    final void setData(ref const(QVariant) var);
    final void setData(T)(T value)
    {
        static if (is(const(T) == const(QVariant)))
            QVariant v = value;
        else
            QVariant v = QVariant.fromValue(value);
        setData(v);
    }

    final bool isChecked() const;

    final bool isEnabled() const;

    final bool isVisible() const;

    enum ActionEvent { Trigger, Hover }
    final void activate(ActionEvent event);

    final void setMenuRole(MenuRole menuRole);
    final MenuRole menuRole() const;

/+ #ifdef Q_CLANG_QDOC
    QMenu *menu() const;
    void setMenu(QMenu *menu);
#else +/
    /+ template<typename T = QMenu*> +/
    final T menu(T)() const
    {
        return qobject_cast!(T)(menuObject());
    }
    /+ template<typename T = QMenu*> +/
    final void setMenu(T)(T m)
    {
        setMenuObject(m);
    }
/+ #endif +/

    final void setIconVisibleInMenu(bool visible);
    final bool isIconVisibleInMenu() const;

    final void setShortcutVisibleInContextMenu(bool show);
    final bool isShortcutVisibleInContextMenu() const;

    final bool showStatusText(QObject object = null);

protected:
    override bool event(QEvent );
    this(ref QActionPrivate dd, QObject parent);

public /+ Q_SLOTS +/:
    @QSlot final void trigger() { activate(ActionEvent.Trigger); }
    @QSlot final void hover() { activate(ActionEvent.Hover); }
    @QSlot final void setChecked(bool);
    @QSlot final void toggle();
    @QSlot final void setEnabled(bool);
    @QSlot final void resetEnabled();
    pragma(inline, true) @QSlot final void setDisabled(bool b) { setEnabled(!b); }
    @QSlot final void setVisible(bool);

/+ Q_SIGNALS +/public:
    @QSignal final void changed();
    @QSignal final void enabledChanged(bool enabled);
    @QSignal final void checkableChanged(bool checkable);
    @QSignal final void visibleChanged();
    @QSignal final void triggered(bool checked = false);
    @QSignal final void hovered();
    @QSignal final void toggled(bool);

private:
    /+ Q_DISABLE_COPY(QAction) +/
    /+ friend class QActionGroup; +/
    /+ friend class QWidget; +/
    /+ friend class QMenu; +/
    /+ friend class QMenuPrivate; +/
    /+ friend class QToolButton; +/
    /+ friend class QGraphicsWidget; +/

    mixin(changeWindowsMangling(q{mangleChangeAccess("private")}, q{
    package(qt) final QObject menuObject() const;
    }));
    final void setMenuObject(QObject object);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QAction *);
#endif +/

