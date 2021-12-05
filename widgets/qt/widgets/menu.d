/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.widgets.menu;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.list;
import qt.core.object;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.gui.event;
import qt.gui.icon;
import qt.gui.keysequence;
import qt.helpers;
import qt.widgets.action;
import qt.widgets.styleoption;
import qt.widgets.widget;
version(QT_NO_ACTION){}else
    import qt.widgets.event;

/+ #if defined(Q_OS_MACOS) || defined(Q_CLANG_QDOC)
Q_FORWARD_DECLARE_OBJC_CLASS(NSMenu);
#endif

QT_REQUIRE_CONFIG(menu); +/


extern(C++, class) struct QMenuPrivate;
/+ class QStyleOptionMenuItem; +/
extern(C++, class) struct QPlatformMenu;

class /+ Q_WIDGETS_EXPORT +/ QMenu : QWidget
{
private:
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QMenu) +/

    /+ Q_PROPERTY(bool tearOffEnabled READ isTearOffEnabled WRITE setTearOffEnabled)
    Q_PROPERTY(QString title READ title WRITE setTitle)
    Q_PROPERTY(QIcon icon READ icon WRITE setIcon)
    Q_PROPERTY(bool separatorsCollapsible READ separatorsCollapsible WRITE setSeparatorsCollapsible)
    Q_PROPERTY(bool toolTipsVisible READ toolTipsVisible WRITE setToolTipsVisible) +/

public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QString) title, QWidget parent = null);
    ~this();

    /+ using QWidget::addAction; +/
    alias addAction = QWidget.addAction;
    final QAction addAction(ref const(QString) text);
    final QAction addAction(const(QString) text) { return addAction(text); }
    final QAction addAction(ref const(QIcon) icon, ref const(QString) text);
    final QAction addAction(ref const(QString) text, const(QObject) receiver, const(char)* member, ref const(QKeySequence) shortcut /+ = 0 +/);
    final QAction addAction(ref const(QIcon) icon, ref const(QString) text, const(QObject) receiver, const(char)* member, ref const(QKeySequence) shortcut /+ = 0 +/);

/+ #ifdef Q_CLANG_QDOC
    template<typename Functor>
    QAction *addAction(const QString &text, Functor functor, const QKeySequence &shortcut = 0);
    template<typename Functor>
    QAction *addAction(const QString &text, const QObject *context, Functor functor, const QKeySequence &shortcut = 0);
    template<typename Functor>
    QAction *addAction(const QIcon &icon, const QString &text, Functor functor, const QKeySequence &shortcut = 0);
    template<typename Functor>
    QAction *addAction(const QIcon &icon, const QString &text, const QObject *context, Functor functor, const QKeySequence &shortcut = 0);
#else +/
    // addAction(QString): Connect to a QObject slot / functor or function pointer (with context)
    /+ template<class Obj, typename Func1> +/
    /+ inline typename std::enable_if<!std::is_same<const char*, Func1>::value
        && QtPrivate::IsPointerToTypeDerivedFromQObject<Obj*>::Value, QAction *>::type
        addAction(const QString &text, const Obj *object, Func1 slot, const QKeySequence &shortcut = 0)
    {
        QAction *result = addAction(text);
#ifdef QT_NO_SHORTCUT
        Q_UNUSED(shortcut)
#else
        result->setShortcut(shortcut);
#endif
        connect(result, &QAction::triggered, object, std::move(slot));
        return result;
    } +/
    // addAction(QString): Connect to a functor or function pointer (without context)
    /+ template <typename Func1> +/
    /+ inline QAction *addAction(const QString &text, Func1 slot, const QKeySequence &shortcut = 0)
    {
        QAction *result = addAction(text);
#ifdef QT_NO_SHORTCUT
        Q_UNUSED(shortcut)
#else
        result->setShortcut(shortcut);
#endif
        connect(result, &QAction::triggered, std::move(slot));
        return result;
    } +/
    // addAction(QIcon, QString): Connect to a QObject slot / functor or function pointer (with context)
    /+ template<class Obj, typename Func1> +/
    /+ inline typename std::enable_if<!std::is_same<const char*, Func1>::value
        && QtPrivate::IsPointerToTypeDerivedFromQObject<Obj*>::Value, QAction *>::type
        addAction(const QIcon &actionIcon, const QString &text, const Obj *object, Func1 slot, const QKeySequence &shortcut = 0)
    {
        QAction *result = addAction(actionIcon, text);
#ifdef QT_NO_SHORTCUT
        Q_UNUSED(shortcut)
#else
        result->setShortcut(shortcut);
#endif
        connect(result, &QAction::triggered, object, std::move(slot));
        return result;
    } +/
    // addAction(QIcon, QString): Connect to a functor or function pointer (without context)
    /+ template <typename Func1> +/
    /+ inline QAction *addAction(const QIcon &actionIcon, const QString &text, Func1 slot, const QKeySequence &shortcut = 0)
    {
        QAction *result = addAction(actionIcon, text);
#ifdef QT_NO_SHORTCUT
        Q_UNUSED(shortcut)
#else
        result->setShortcut(shortcut);
#endif
        connect(result, &QAction::triggered, std::move(slot));
        return result;
    } +/
/+ #endif +/ // !Q_CLANG_QDOC

    final QAction addMenu(QMenu menu);
    final QMenu addMenu(ref const(QString) title);
    final QMenu addMenu(ref const(QIcon) icon, ref const(QString) title);

    final QAction addSeparator();

    final QAction addSection(ref const(QString) text);
    final QAction addSection(ref const(QIcon) icon, ref const(QString) text);

    final QAction insertMenu(QAction before, QMenu menu);
    final QAction insertSeparator(QAction before);
    final QAction insertSection(QAction before, ref const(QString) text);
    final QAction insertSection(QAction before, ref const(QIcon) icon, ref const(QString) text);

    final bool isEmpty() const;
    final void clear();

    final void setTearOffEnabled(bool);
    final bool isTearOffEnabled() const;

    final bool isTearOffMenuVisible() const;
    final void showTearOffMenu();
    final void showTearOffMenu(ref const(QPoint) pos);
    final void hideTearOffMenu();

    final void setDefaultAction(QAction );
    final QAction defaultAction() const;

    final void setActiveAction(QAction act);
    final QAction activeAction() const;

    final void popup(ref const(QPoint) pos, QAction at = null);
    final QAction exec();
    final QAction exec(ref const(QPoint) pos, QAction at = null);
    final QAction exec(const(QPoint) pos, QAction at = null) {return exec(pos, at);}

/+ #if QT_VERSION >= QT_VERSION_CHECK(6,0,0)
    static QAction *exec(const QList<QAction *> &actions, const QPoint &pos, QAction *at = nullptr, QWidget *parent = nullptr);
#else +/
    static QAction exec(QList!(QAction) actions, ref const(QPoint) pos, QAction at = null, QWidget parent = null);
/+ #endif +/

    override QSize sizeHint() const;

    final QRect actionGeometry(QAction ) const;
    final QAction actionAt(ref const(QPoint) ) const;

    final QAction menuAction() const;

    final QString title() const;
    final void setTitle(ref const(QString) title);
    final void setTitle(const(QString) title)
    {
        setTitle(title);
    }

    final QIcon icon() const;
    final void setIcon(ref const(QIcon) icon);

    final void setNoReplayFor(QWidget widget);
    final QPlatformMenu* platformMenu();
    final void setPlatformMenu(QPlatformMenu* platformMenu);

    version(OSX)
    {
        /+ NSMenu* toNSMenu(); +/
        final void setAsDockMenu();
    }

    final bool separatorsCollapsible() const;
    final void setSeparatorsCollapsible(bool collapse);

    final bool toolTipsVisible() const;
    final void setToolTipsVisible(bool visible);

/+ Q_SIGNALS +/public:
    @QSignal final void aboutToShow();
    @QSignal final void aboutToHide();
    @QSignal final void triggered(QAction action);
    @QSignal final void hovered(QAction action);

protected:
    final int columnCount() const;

    override void changeEvent(QEvent );
    override void keyPressEvent(QKeyEvent );
    override void mouseReleaseEvent(QMouseEvent );
    override void mousePressEvent(QMouseEvent );
    override void mouseMoveEvent(QMouseEvent );
/+ #if QT_CONFIG(wheelevent) +/
    override void wheelEvent(QWheelEvent );
/+ #endif +/
    override void enterEvent(QEvent );
    override void leaveEvent(QEvent );
    override void hideEvent(QHideEvent );
    override void paintEvent(QPaintEvent );
    override void actionEvent(QActionEvent );
    override void timerEvent(QTimerEvent );
    override bool event(QEvent );
    override bool focusNextPrevChild(bool next);
    final void initStyleOption(QStyleOptionMenuItem* option, const(QAction) action) const;

private /+ Q_SLOTS +/:
    @QSlot final void internalDelayedPopup();

private:
    /+ Q_PRIVATE_SLOT(d_func(), void _q_actionTriggered())
    Q_PRIVATE_SLOT(d_func(), void _q_actionHovered())
    Q_PRIVATE_SLOT(d_func(), void _q_overrideMenuActionDestroyed())
    Q_PRIVATE_SLOT(d_func(), void _q_platformMenuAboutToShow()) +/

protected:
    this(ref QMenuPrivate dd, QWidget parent = null);

private:
    /+ Q_DISABLE_COPY(QMenu) +/

    /+ friend class QMenuBar; +/
    /+ friend class QMenuBarPrivate; +/
    /+ friend class QTornOffMenu; +/
    /+ friend class QComboBox; +/
    /+ friend class QAction; +/
    /+ friend class QToolButtonPrivate; +/
    /+ friend void qt_mac_emit_menuSignals(QMenu *menu, bool show); +/
    /+ friend void qt_mac_menu_emit_hovered(QMenu *menu, QAction *action); +/
}

version(OSX)
{
// ### Qt 4 compatibility; remove in Qt 6
/+ QT_DEPRECATED +/ pragma(inline, true) void qt_mac_set_dock_menu(QMenu menu) { menu.setAsDockMenu(); }
}

