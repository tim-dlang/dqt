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
module qt.widgets.scrollarea;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.object;
import qt.core.size;
import qt.gui.event;
import qt.helpers;
import qt.widgets.abstractscrollarea;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(scrollarea); +/


extern(C++, class) struct QScrollAreaPrivate;

class /+ Q_WIDGETS_EXPORT +/ QScrollArea : QAbstractScrollArea
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(bool widgetResizable READ widgetResizable WRITE setWidgetResizable)
    Q_PROPERTY(Qt::Alignment alignment READ alignment WRITE setAlignment) +/

public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    final QWidget widget() const;
    final void setWidget(QWidget widget);
    final QWidget takeWidget();

    final bool widgetResizable() const;
    final void setWidgetResizable(bool resizable);

    override QSize sizeHint() const;

    override bool focusNextPrevChild(bool next);

    final /+ Qt:: +/qt.core.namespace.Alignment alignment() const;
    final void setAlignment(/+ Qt:: +/qt.core.namespace.Alignment);

    final void ensureVisible(int x, int y, int xmargin = 50, int ymargin = 50);
    final void ensureWidgetVisible(QWidget childWidget, int xmargin = 50, int ymargin = 50);

protected:
    this(ref QScrollAreaPrivate dd, QWidget parent = null);
    override bool event(QEvent );
    override bool eventFilter(QObject , QEvent );
    override void resizeEvent(QResizeEvent );
    override void scrollContentsBy(int dx, int dy);

    override QSize viewportSizeHint() const;

private:
    /+ Q_DECLARE_PRIVATE(QScrollArea) +/
    /+ Q_DISABLE_COPY(QScrollArea) +/
}

