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
module qt.widgets.abstractbutton;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.point;
import qt.core.size;
import qt.core.string;
import qt.gui.event;
import qt.gui.icon;
import qt.helpers;
import qt.widgets.buttongroup;
import qt.widgets.widget;
version (QT_NO_SHORTCUT) {} else
    import qt.gui.keysequence;

/+ #if QT_CONFIG(shortcut)
#endif
QT_REQUIRE_CONFIG(abstractbutton); +/



extern(C++, class) struct QAbstractButtonPrivate;

/// Binding for C++ class [QAbstractButton](https://doc.qt.io/qt-6/qabstractbutton.html).
abstract class /+ Q_WIDGETS_EXPORT +/ QAbstractButton : QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QString text READ text WRITE setText)
    Q_PROPERTY(QIcon icon READ icon WRITE setIcon)
    Q_PROPERTY(QSize iconSize READ iconSize WRITE setIconSize)
#ifndef QT_NO_SHORTCUT
    Q_PROPERTY(QKeySequence shortcut READ shortcut WRITE setShortcut)
#endif
    Q_PROPERTY(bool checkable READ isCheckable WRITE setCheckable)
    Q_PROPERTY(bool checked READ isChecked WRITE setChecked NOTIFY toggled USER true)
    Q_PROPERTY(bool autoRepeat READ autoRepeat WRITE setAutoRepeat)
    Q_PROPERTY(bool autoExclusive READ autoExclusive WRITE setAutoExclusive)
    Q_PROPERTY(int autoRepeatDelay READ autoRepeatDelay WRITE setAutoRepeatDelay)
    Q_PROPERTY(int autoRepeatInterval READ autoRepeatInterval WRITE setAutoRepeatInterval)
    Q_PROPERTY(bool down READ isDown WRITE setDown DESIGNABLE false) +/

public:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QWidget parent = null);
    }));
    ~this();

    final void setText(ref const(QString) text);
    final QString text() const;

    final void setIcon(ref const(QIcon) icon);
    final QIcon icon() const;

    final QSize iconSize() const;

    version (QT_NO_SHORTCUT) {} else
    {
        final void setShortcut(ref const(QKeySequence) key);
        final void setShortcut(const QString shortcut)
        {
            auto tmp = QKeySequence(shortcut);
            setShortcut(tmp);
        }
        final QKeySequence shortcut() const;
    }

    final void setCheckable(bool);
    final bool isCheckable() const;

    final bool isChecked() const;

    final void setDown(bool);
    final bool isDown() const;

    final void setAutoRepeat(bool);
    final bool autoRepeat() const;

    final void setAutoRepeatDelay(int);
    final int autoRepeatDelay() const;

    final void setAutoRepeatInterval(int);
    final int autoRepeatInterval() const;

    final void setAutoExclusive(bool);
    final bool autoExclusive() const;

/+ #if QT_CONFIG(buttongroup) +/
    final QButtonGroup group() const;
/+ #endif +/

public /+ Q_SLOTS +/:
    @QSlot final void setIconSize(ref const(QSize) size);
    @QSlot final void animateClick();
    @QSlot final void click();
    @QSlot final void toggle();
    @QSlot final void setChecked(bool);

/+ Q_SIGNALS +/public:
    @QSignal final void pressed();
    @QSignal final void released();
    @QSignal final void clicked(bool checked = false);
    @QSignal final void toggled(bool checked);

protected:
    abstract override void paintEvent(QPaintEvent e);
    /+ virtual +/ bool hitButton(ref const(QPoint) pos) const;
    /+ virtual +/ void checkStateSet();
    /+ virtual +/ void nextCheckState();

    override bool event(QEvent e);
    override void keyPressEvent(QKeyEvent e);
    override void keyReleaseEvent(QKeyEvent e);
    override void mousePressEvent(QMouseEvent e);
    override void mouseReleaseEvent(QMouseEvent e);
    override void mouseMoveEvent(QMouseEvent e);
    override void focusInEvent(QFocusEvent e);
    override void focusOutEvent(QFocusEvent e);
    override void changeEvent(QEvent e);
    override void timerEvent(QTimerEvent e);


protected:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QAbstractButtonPrivate dd, QWidget parent = null);
    }));

private:
    /+ Q_DECLARE_PRIVATE(QAbstractButton) +/
    /+ Q_DISABLE_COPY(QAbstractButton) +/
    /+ friend class QButtonGroup; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

