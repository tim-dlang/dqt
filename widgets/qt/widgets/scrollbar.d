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
module qt.widgets.scrollbar;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.size;
import qt.gui.event;
import qt.helpers;
import qt.widgets.abstractslider;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(scrollbar); +/


extern(C++, class) struct QScrollBarPrivate;

/// Binding for C++ class [QScrollBar](https://doc.qt.io/qt-5/qscrollbar.html).
class /+ Q_WIDGETS_EXPORT +/ QScrollBar : QAbstractSlider
{
    mixin(Q_OBJECT);
public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.Orientation, QWidget parent = null);
    ~this();

    override QSize sizeHint() const;
    override bool event(QEvent event);

protected:
/+ #if QT_CONFIG(wheelevent) +/
    override void wheelEvent(QWheelEvent );
/+ #endif +/
    override void paintEvent(QPaintEvent );
    override void mousePressEvent(QMouseEvent );
    override void mouseReleaseEvent(QMouseEvent );
    override void mouseMoveEvent(QMouseEvent );
    override void hideEvent(QHideEvent);
    override void sliderChange(SliderChange change);
    version(QT_NO_CONTEXTMENU){}else
    {
        override void contextMenuEvent(QContextMenuEvent );
    }
    final void initStyleOption(QStyleOptionSlider* option) const;


private:
    /+ friend class QAbstractScrollAreaPrivate; +/
    /+ friend Q_WIDGETS_EXPORT QStyleOptionSlider qt_qscrollbarStyleOption(QScrollBar *scrollBar); +/

    /+ Q_DISABLE_COPY(QScrollBar) +/
    /+ Q_DECLARE_PRIVATE(QScrollBar) +/
/+ #if QT_CONFIG(itemviews) +/
    /+ friend class QTableView; +/
    /+ friend class QTreeViewPrivate; +/
    /+ friend class QCommonListViewBase; +/
    /+ friend class QListModeViewBase; +/
    /+ friend class QAbstractItemView; +/
/+ #endif +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

