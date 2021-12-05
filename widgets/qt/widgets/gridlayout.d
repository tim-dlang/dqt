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
module qt.widgets.gridlayout;
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



extern(C++, class) struct QGridLayoutPrivate;

class /+ Q_WIDGETS_EXPORT +/ QGridLayout : QLayout
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QGridLayout) +/
    /+ QDOC_PROPERTY(int horizontalSpacing READ horizontalSpacing WRITE setHorizontalSpacing)
    QDOC_PROPERTY(int verticalSpacing READ verticalSpacing WRITE setVerticalSpacing) +/

public:
    /+ explicit +/this(QWidget parent);
    this();

    ~this();

    override QSize sizeHint() const;
    override QSize minimumSize() const;
    override QSize maximumSize() const;

    final void setHorizontalSpacing(int spacing);
    final int horizontalSpacing() const;
    final void setVerticalSpacing(int spacing);
    final int verticalSpacing() const;
//    final void setSpacing(int spacing);
//    final int spacing() const;

    final void setRowStretch(int row, int stretch);
    final void setColumnStretch(int column, int stretch);
    final int rowStretch(int row) const;
    final int columnStretch(int column) const;

    final void setRowMinimumHeight(int row, int minSize);
    final void setColumnMinimumWidth(int column, int minSize);
    final int rowMinimumHeight(int row) const;
    final int columnMinimumWidth(int column) const;

    final int columnCount() const;
    final int rowCount() const;

    final QRect cellRect(int row, int column) const;

    override bool hasHeightForWidth() const;
    override int heightForWidth(int) const;
    override int minimumHeightForWidth(int) const;

    override /+ Qt:: +/qt.core.namespace.Orientations expandingDirections() const;
    override void invalidate();

    // pragma(inline, true) final void addWidget(QWidget w) { QLayout.addWidget(w); }
    final void addWidget(QWidget , int row, int column, /+ Qt:: +/qt.core.namespace.Alignment = globalInitVar!Alignment);
    final void addWidget(QWidget , int row, int column, int rowSpan, int columnSpan, /+ Qt:: +/qt.core.namespace.Alignment = globalInitVar!Alignment);
    final void addLayout(QLayout , int row, int column, /+ Qt:: +/qt.core.namespace.Alignment = globalInitVar!Alignment);
    final void addLayout(QLayout , int row, int column, int rowSpan, int columnSpan, /+ Qt:: +/qt.core.namespace.Alignment = globalInitVar!Alignment);

    final void setOriginCorner(/+ Qt:: +/qt.core.namespace.Corner);
    final /+ Qt:: +/qt.core.namespace.Corner originCorner() const;

    override QLayoutItem itemAt(int index) const;
    final QLayoutItem itemAtPosition(int row, int column) const;
    override QLayoutItem takeAt(int index);
    override int count() const;
    override void setGeometry(ref const(QRect));

    final void addItem(QLayoutItem item, int row, int column, int rowSpan = 1, int columnSpan = 1, /+ Qt:: +/qt.core.namespace.Alignment = globalInitVar!(qt.core.namespace.Alignment));

    final void setDefaultPositioning(int n, /+ Qt:: +/qt.core.namespace.Orientation orient);
    final void getItemPosition(int idx, int* row, int* column, int* rowSpan, int* columnSpan) const;

protected:
    override void addItem(QLayoutItem );

private:
    /+ Q_DISABLE_COPY(QGridLayout) +/

}

