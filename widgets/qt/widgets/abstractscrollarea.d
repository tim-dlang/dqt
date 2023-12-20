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
module qt.widgets.abstractscrollarea;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.margins;
import qt.core.namespace;
import qt.core.object;
import qt.core.size;
import qt.gui.event;
import qt.helpers;
import qt.widgets.frame;
import qt.widgets.scrollbar;
import qt.widgets.widget;

/+ #if QT_CONFIG(scrollarea) +/

extern(C++, class) struct QAbstractScrollAreaPrivate;

/// Binding for C++ class [QAbstractScrollArea](https://doc.qt.io/qt-5/qabstractscrollarea.html).
class /+ Q_WIDGETS_EXPORT +/ QAbstractScrollArea : QFrame
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(Qt::ScrollBarPolicy verticalScrollBarPolicy READ verticalScrollBarPolicy WRITE setVerticalScrollBarPolicy)
    Q_PROPERTY(Qt::ScrollBarPolicy horizontalScrollBarPolicy READ horizontalScrollBarPolicy WRITE setHorizontalScrollBarPolicy)
    Q_PROPERTY(SizeAdjustPolicy sizeAdjustPolicy READ sizeAdjustPolicy WRITE setSizeAdjustPolicy) +/

public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    enum SizeAdjustPolicy {
        AdjustIgnored,
        AdjustToContentsOnFirstShow,
        AdjustToContents
    }
    /+ Q_ENUM(SizeAdjustPolicy) +/

    final /+ Qt:: +/qt.core.namespace.ScrollBarPolicy verticalScrollBarPolicy() const;
    final void setVerticalScrollBarPolicy(/+ Qt:: +/qt.core.namespace.ScrollBarPolicy);
    final QScrollBar verticalScrollBar() const;
    final void setVerticalScrollBar(QScrollBar scrollbar);

    final /+ Qt:: +/qt.core.namespace.ScrollBarPolicy horizontalScrollBarPolicy() const;
    final void setHorizontalScrollBarPolicy(/+ Qt:: +/qt.core.namespace.ScrollBarPolicy);
    final QScrollBar horizontalScrollBar() const;
    final void setHorizontalScrollBar(QScrollBar scrollbar);

    final QWidget cornerWidget() const;
    final void setCornerWidget(QWidget widget);

    final void addScrollBarWidget(QWidget widget, /+ Qt:: +/qt.core.namespace.Alignment alignment);
    final QWidgetList scrollBarWidgets(/+ Qt:: +/qt.core.namespace.Alignment alignment);

    final QWidget viewport() const;
    final void setViewport(QWidget widget);
    final QSize maximumViewportSize() const;

    override QSize minimumSizeHint() const;

    override QSize sizeHint() const;

    /+ virtual +/ void setupViewport(QWidget viewport);

    final SizeAdjustPolicy sizeAdjustPolicy() const;
    final void setSizeAdjustPolicy(SizeAdjustPolicy policy);

protected:
    this(ref QAbstractScrollAreaPrivate dd, QWidget parent = null);
    final void setViewportMargins(int left, int top, int right, int bottom);
    final void setViewportMargins(ref const(QMargins) margins);
    final QMargins viewportMargins() const;

    override bool eventFilter(QObject , QEvent );
    override bool event(QEvent );
    /+ virtual +/ bool viewportEvent(QEvent );

    override void resizeEvent(QResizeEvent );
    override void paintEvent(QPaintEvent );
    override void mousePressEvent(QMouseEvent );
    override void mouseReleaseEvent(QMouseEvent );
    override void mouseDoubleClickEvent(QMouseEvent );
    override void mouseMoveEvent(QMouseEvent );
/+ #if QT_CONFIG(wheelevent) +/
    override void wheelEvent(QWheelEvent );
/+ #endif
#ifndef QT_NO_CONTEXTMENU +/
    version (QT_NO_CONTEXTMENU) {} else
    {
        override void contextMenuEvent(QContextMenuEvent );
    }
/+ #endif
#if QT_CONFIG(draganddrop) +/
    override void dragEnterEvent(QDragEnterEvent );
    override void dragMoveEvent(QDragMoveEvent );
    override void dragLeaveEvent(QDragLeaveEvent );
    override void dropEvent(QDropEvent );
/+ #endif +/

    override void keyPressEvent(QKeyEvent );

    /+ virtual +/ void scrollContentsBy(int dx, int dy);

    /+ virtual +/ QSize viewportSizeHint() const;

private:
    /+ Q_DECLARE_PRIVATE(QAbstractScrollArea) +/
    /+ Q_DISABLE_COPY(QAbstractScrollArea) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_hslide(int))
    Q_PRIVATE_SLOT(d_func(), void _q_vslide(int))
    Q_PRIVATE_SLOT(d_func(), void _q_showOrHideScrollBars()) +/

    /+ friend class QStyleSheetStyle; +/
    /+ friend class QWidgetPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #endif +/ // QT_CONFIG(scrollarea)

