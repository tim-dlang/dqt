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
module qt.widgets.splitter;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.coreevent;
import qt.core.list;
import qt.core.namespace;
import qt.core.size;
import qt.gui.event;
import qt.helpers;
import qt.widgets.frame;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(splitter); +/


extern(C++, class) struct QSplitterPrivate;
/+ class QTextStream;
template <typename T> class QList;

class QSplitterHandle; +/

class /+ Q_WIDGETS_EXPORT +/ QSplitter : QFrame
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(Qt::Orientation orientation READ orientation WRITE setOrientation)
    Q_PROPERTY(bool opaqueResize READ opaqueResize WRITE setOpaqueResize)
    Q_PROPERTY(int handleWidth READ handleWidth WRITE setHandleWidth)
    Q_PROPERTY(bool childrenCollapsible READ childrenCollapsible WRITE setChildrenCollapsible) +/

public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.Orientation, QWidget parent = null);
    ~this();

    final void addWidget(QWidget widget);
    final void insertWidget(int index, QWidget widget);
    final QWidget replaceWidget(int index, QWidget widget);

    final void setOrientation(/+ Qt:: +/qt.core.namespace.Orientation);
    final /+ Qt:: +/qt.core.namespace.Orientation orientation() const;

    final void setChildrenCollapsible(bool);
    final bool childrenCollapsible() const;

    final void setCollapsible(int index, bool);
    final bool isCollapsible(int index) const;
    final void setOpaqueResize(bool opaque = true);
    final bool opaqueResize() const;
    final void refresh();

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;

    final QList!(int) sizes() const;
    final void setSizes(ref const(QList!(int)) list);

    final QByteArray saveState() const;
    final bool restoreState(ref const(QByteArray) state);

    final int handleWidth() const;
    final void setHandleWidth(int);

    final int indexOf(QWidget w) const;
    final QWidget widget(int index) const;
    final int count() const;

    final void getRange(int index, int* , int* ) const;
    final QSplitterHandle handle(int index) const;

    final void setStretchFactor(int index, int stretch);

/+ Q_SIGNALS +/public:
    @QSignal final void splitterMoved(int pos, int index);

protected:
    /+ virtual +/ QSplitterHandle createHandle();

    override void childEvent(QChildEvent );

    override bool event(QEvent );
    override void resizeEvent(QResizeEvent );

    override void changeEvent(QEvent );
    final void moveSplitter(int pos, int index);
    final void setRubberBand(int position);
    final int closestLegalPosition(int, int);


private:
    /+ Q_DISABLE_COPY(QSplitter) +/
    /+ Q_DECLARE_PRIVATE(QSplitter) +/
private:
    /+ friend class QSplitterHandle; +/
}

/+ #if QT_DEPRECATED_SINCE(5, 13)
QT_DEPRECATED_X("Use QSplitter::saveState() instead")
Q_WIDGETS_EXPORT QTextStream& operator<<(QTextStream&, const QSplitter&);
QT_DEPRECATED_X("Use QSplitter::restoreState() instead")
Q_WIDGETS_EXPORT QTextStream& operator>>(QTextStream&, QSplitter&);
#endif +/

extern(C++, class) struct QSplitterHandlePrivate;
class /+ Q_WIDGETS_EXPORT +/ QSplitterHandle : QWidget
{
    mixin(Q_OBJECT);
public:
    /+ explicit +/this(/+ Qt:: +/qt.core.namespace.Orientation o, QSplitter parent);
    ~this();

    final void setOrientation(/+ Qt:: +/qt.core.namespace.Orientation o);
    final /+ Qt:: +/qt.core.namespace.Orientation orientation() const;
    final bool opaqueResize() const;
    final QSplitter splitter() const;

    override QSize sizeHint() const;

protected:
    override void paintEvent(QPaintEvent );
    override void mouseMoveEvent(QMouseEvent );
    override void mousePressEvent(QMouseEvent );
    override void mouseReleaseEvent(QMouseEvent );
    override void resizeEvent(QResizeEvent );
    override bool event(QEvent );

    final void moveSplitter(int p);
    final int closestLegalPosition(int p);

private:
    /+ Q_DISABLE_COPY(QSplitterHandle) +/
    /+ Q_DECLARE_PRIVATE(QSplitterHandle) +/
}

