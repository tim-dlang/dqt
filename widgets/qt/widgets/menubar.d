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
module qt.widgets.menubar;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.gui.action;
import qt.gui.event;
import qt.gui.icon;
import qt.gui.keysequence;
import qt.helpers;
import qt.widgets.menu;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(menubar); +/


extern(C++, class) struct QMenuBarPrivate;
extern(C++, class) struct QWindowsStyle;
extern(C++, class) struct QPlatformMenuBar;

/// Binding for C++ class [QMenuBar](https://doc.qt.io/qt-6/qmenubar.html).
class /+ Q_WIDGETS_EXPORT +/ QMenuBar : QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(bool defaultUp READ isDefaultUp WRITE setDefaultUp)
    Q_PROPERTY(bool nativeMenuBar READ isNativeMenuBar WRITE setNativeMenuBar) +/

public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    version (QT_NO_ACTION) {} else
    {
    alias addAction = QWidget.addAction;
    }

    static if (defined!"QT_WIDGETS_BUILD_REMOVED_API")
    {
        final QAction addAction(ref const(QString) text);
        mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
        final QAction addAction(ref const(QString) text, const(QObject) receiver, const(char)* member);
        }));
    }

    final QAction addMenu(QMenu menu);
    final QMenu addMenu(ref const(QString) title);
    final QMenu addMenu(ref const(QIcon) icon, ref const(QString) title);


    final QAction addSeparator();
    final QAction insertSeparator(QAction before);

    final QAction insertMenu(QAction before, QMenu menu);

    final void clear();

    final QAction activeAction() const;
    final void setActiveAction(QAction action);

    final void setDefaultUp(bool);
    final bool isDefaultUp() const;

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;
    override int heightForWidth(int) const;

    final QRect actionGeometry(QAction ) const;
    final QAction actionAt(ref const(QPoint) ) const;

    final void setCornerWidget(QWidget w, /+ Qt:: +/qt.core.namespace.Corner corner = /+ Qt:: +/qt.core.namespace.Corner.TopRightCorner);
    final QWidget cornerWidget(/+ Qt:: +/qt.core.namespace.Corner corner = /+ Qt:: +/qt.core.namespace.Corner.TopRightCorner) const;

    version (OSX)
    {
        /+ NSMenu* toNSMenu(); +/
    }

    final bool isNativeMenuBar() const;
    final void setNativeMenuBar(bool nativeMenuBar);
    final QPlatformMenuBar* platformMenuBar();
public /+ Q_SLOTS +/:
    @QSlot override void setVisible(bool visible);

/+ Q_SIGNALS +/public:
    @QSignal final void triggered(QAction action);
    @QSignal final void hovered(QAction action);

protected:
    override void changeEvent(QEvent );
    override void keyPressEvent(QKeyEvent );
    override void mouseReleaseEvent(QMouseEvent );
    override void mousePressEvent(QMouseEvent );
    override void mouseMoveEvent(QMouseEvent );
    override void leaveEvent(QEvent );
    override void paintEvent(QPaintEvent );
    override void resizeEvent(QResizeEvent );
    override void actionEvent(QActionEvent );
    override void focusOutEvent(QFocusEvent );
    override void focusInEvent(QFocusEvent );
    override void timerEvent(QTimerEvent );
    override bool eventFilter(QObject , QEvent );
    override bool event(QEvent );
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ virtual +/ void initStyleOption(QStyleOptionMenuItem* option, const(QAction) action) const;
    }));

private:
    /+ Q_DECLARE_PRIVATE(QMenuBar) +/
    /+ Q_DISABLE_COPY(QMenuBar) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_actionTriggered())
    Q_PRIVATE_SLOT(d_func(), void _q_actionHovered())
    Q_PRIVATE_SLOT(d_func(), void _q_internalShortcutActivated(int))
    Q_PRIVATE_SLOT(d_func(), void _q_updateLayout()) +/

    /+ friend class QMenu; +/
    /+ friend class QMenuPrivate; +/
    /+ friend class QWindowsStyle; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

