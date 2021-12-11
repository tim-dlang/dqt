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
module qt.widgets.boxlayout;
extern(C++):

import qt.config;
import qt.core.namespace;
import qt.core.rect;
import qt.core.size;
import qt.helpers;
import qt.widgets.layout;
import qt.widgets.layoutitem;
import qt.widgets.widget;

/+ #ifdef QT_INCLUDE_COMPAT
#endif +/



extern(C++, class) struct QBoxLayoutPrivate;

/// Binding for C++ class [QBoxLayout](https://doc.qt.io/qt-5/qboxlayout.html).
class /+ Q_WIDGETS_EXPORT +/ QBoxLayout : QLayout
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QBoxLayout) +/
public:
    enum Direction { LeftToRight, RightToLeft, TopToBottom, BottomToTop,
                     Down = Direction.TopToBottom, Up = Direction.BottomToTop }

    /+ explicit +/this(Direction, QWidget parent = null);

    ~this();

    final Direction direction() const;
    final void setDirection(Direction);

    final void addSpacing(int size);
    final void addStretch(int stretch = 0);
    final void addSpacerItem(QSpacerItem spacerItem);
    final void addWidget(QWidget , int stretch = 0, /+ Qt:: +/qt.core.namespace.Alignment alignment = /+ Qt:: +/qt.core.namespace.Alignment());
    final void addLayout(QLayout layout, int stretch = 0);
    final void addStrut(int);
    override void addItem(QLayoutItem );

    final void insertSpacing(int index, int size);
    final void insertStretch(int index, int stretch = 0);
    final void insertSpacerItem(int index, QSpacerItem spacerItem);
    final void insertWidget(int index, QWidget widget, int stretch = 0, /+ Qt:: +/qt.core.namespace.Alignment alignment = /+ Qt:: +/qt.core.namespace.Alignment());
    final void insertLayout(int index, QLayout layout, int stretch = 0);
    final void insertItem(int index, QLayoutItem );

//    final int spacing() const;
//    final void setSpacing(int spacing);

    final bool setStretchFactor(QWidget w, int stretch);
    final bool setStretchFactor(QLayout l, int stretch);
    final void setStretch(int index, int stretch);
    final int stretch(int index) const;

    override QSize sizeHint() const;
    override QSize minimumSize() const;
    override QSize maximumSize() const;

    override bool hasHeightForWidth() const;
    override int heightForWidth(int) const;
    override int minimumHeightForWidth(int) const;

    override /+ Qt:: +/qt.core.namespace.Orientations expandingDirections() const;
    override void invalidate();
    override QLayoutItem itemAt(int) const;
    override QLayoutItem takeAt(int);
    override int count() const;
    override void setGeometry(ref const(QRect));

private:
    /+ Q_DISABLE_COPY(QBoxLayout) +/
}

/// Binding for C++ class [QHBoxLayout](https://doc.qt.io/qt-5/qhboxlayout.html).
class /+ Q_WIDGETS_EXPORT +/ QHBoxLayout : QBoxLayout
{
    mixin(Q_OBJECT);
public:
    this();
    /+ explicit +/this(QWidget parent);
    ~this();


private:
    /+ Q_DISABLE_COPY(QHBoxLayout) +/
}

/// Binding for C++ class [QVBoxLayout](https://doc.qt.io/qt-5/qvboxlayout.html).
class /+ Q_WIDGETS_EXPORT +/ QVBoxLayout : QBoxLayout
{
    mixin(Q_OBJECT);
public:
    this();
    /+ explicit +/this(QWidget parent);
    ~this();


private:
    /+ Q_DISABLE_COPY(QVBoxLayout) +/
}

