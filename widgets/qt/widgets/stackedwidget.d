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
module qt.widgets.stackedwidget;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.helpers;
import qt.widgets.frame;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(stackedwidget); +/


extern(C++, class) struct QStackedWidgetPrivate;

/// Binding for C++ class [QStackedWidget](https://doc.qt.io/qt-6/qstackedwidget.html).
class /+ Q_WIDGETS_EXPORT +/ QStackedWidget : QFrame
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentChanged)
    Q_PROPERTY(int count READ count) +/
public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    final int addWidget(QWidget w);
    final int insertWidget(int index, QWidget w);
    final void removeWidget(QWidget w);

    final QWidget currentWidget() const;
    final int currentIndex() const;

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final int indexOf(const(QWidget) ) const;
    }));
    final QWidget widget(int) const;
    final int count() const;

public /+ Q_SLOTS +/:
    @QSlot final void setCurrentIndex(int index);
    @QSlot final void setCurrentWidget(QWidget w);

/+ Q_SIGNALS +/public:
    @QSignal final void currentChanged(int);
    @QSignal final void widgetRemoved(int index);

protected:
    override bool event(QEvent e);

private:
    /+ Q_DISABLE_COPY(QStackedWidget) +/
    /+ Q_DECLARE_PRIVATE(QStackedWidget) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

