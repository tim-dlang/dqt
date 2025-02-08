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
module qt.widgets.formlayout;
extern(C++):

import qt.config;
import qt.core.namespace;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.helpers;
import qt.widgets.layout;
import qt.widgets.layoutitem;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(formlayout); +/



extern(C++, class) struct QFormLayoutPrivate;

/// Binding for C++ class [QFormLayout](https://doc.qt.io/qt-6/qformlayout.html).
class /+ Q_WIDGETS_EXPORT +/ QFormLayout : QLayout
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QFormLayout) +/
    /+ Q_PROPERTY(FieldGrowthPolicy fieldGrowthPolicy READ fieldGrowthPolicy WRITE setFieldGrowthPolicy
               RESET resetFieldGrowthPolicy)
    Q_PROPERTY(RowWrapPolicy rowWrapPolicy READ rowWrapPolicy WRITE setRowWrapPolicy
               RESET resetRowWrapPolicy)
    Q_PROPERTY(Qt::Alignment labelAlignment READ labelAlignment WRITE setLabelAlignment
               RESET resetLabelAlignment)
    Q_PROPERTY(Qt::Alignment formAlignment READ formAlignment WRITE setFormAlignment
               RESET resetFormAlignment)
    Q_PROPERTY(int horizontalSpacing READ horizontalSpacing WRITE setHorizontalSpacing)
    Q_PROPERTY(int verticalSpacing READ verticalSpacing WRITE setVerticalSpacing) +/

public:
    enum FieldGrowthPolicy {
        FieldsStayAtSizeHint,
        ExpandingFieldsGrow,
        AllNonFixedFieldsGrow
    }
    /+ Q_ENUM(FieldGrowthPolicy) +/

    enum RowWrapPolicy {
        DontWrapRows,
        WrapLongRows,
        WrapAllRows
    }
    /+ Q_ENUM(RowWrapPolicy) +/

    enum ItemRole {
        LabelRole = 0,
        FieldRole = 1,
        SpanningRole = 2
    }
    /+ Q_ENUM(ItemRole) +/

    struct TakeRowResult {
        QLayoutItem labelItem;
        QLayoutItem fieldItem;
    }

    /+ explicit +/this(QWidget parent = null);
    ~this();

    final void setFieldGrowthPolicy(FieldGrowthPolicy policy);
    final FieldGrowthPolicy fieldGrowthPolicy() const;
    final void setRowWrapPolicy(RowWrapPolicy policy);
    final RowWrapPolicy rowWrapPolicy() const;
    final void setLabelAlignment(/+ Qt:: +/qt.core.namespace.Alignment alignment);
    final /+ Qt:: +/qt.core.namespace.Alignment labelAlignment() const;
    final void setFormAlignment(/+ Qt:: +/qt.core.namespace.Alignment alignment);
    final /+ Qt:: +/qt.core.namespace.Alignment formAlignment() const;

    final void setHorizontalSpacing(int spacing);
    final int horizontalSpacing() const;
    final void setVerticalSpacing(int spacing);
    final int verticalSpacing() const;

    override int spacing() const;
    override void setSpacing(int);

    final void addRow(QWidget label, QWidget field);
    final void addRow(QWidget label, QLayout field);
    final void addRow(ref const(QString) labelText, QWidget field);
    final void addRow(ref const(QString) labelText, QLayout field);
    final void addRow(QWidget widget);
    final void addRow(QLayout layout);

    final void insertRow(int row, QWidget label, QWidget field);
    final void insertRow(int row, QWidget label, QLayout field);
    final void insertRow(int row, ref const(QString) labelText, QWidget field);
    final void insertRow(int row, ref const(QString) labelText, QLayout field);
    final void insertRow(int row, QWidget widget);
    final void insertRow(int row, QLayout layout);

    final void removeRow(int row);
    final void removeRow(QWidget widget);
    final void removeRow(QLayout layout);

    final TakeRowResult takeRow(int row);
    final TakeRowResult takeRow(QWidget widget);
    final TakeRowResult takeRow(QLayout layout);

    final void setItem(int row, ItemRole role, QLayoutItem item);
    final void setWidget(int row, ItemRole role, QWidget widget);
    final void setLayout(int row, ItemRole role, QLayout layout);

    final void setRowVisible(int row, bool on);
    final void setRowVisible(QWidget widget, bool on);
    final void setRowVisible(QLayout layout, bool on);

    final bool isRowVisible(int row) const;
    final bool isRowVisible(QWidget widget) const;
    final bool isRowVisible(QLayout layout) const;

    final QLayoutItem itemAt(int row, ItemRole role) const;
    final void getItemPosition(int index, int* rowPtr, ItemRole* rolePtr) const;
    final void getWidgetPosition(QWidget widget, int* rowPtr, ItemRole* rolePtr) const;
    final void getLayoutPosition(QLayout layout, int* rowPtr, ItemRole* rolePtr) const;
    final QWidget labelForField(QWidget field) const;
    final QWidget labelForField(QLayout field) const;

    // reimplemented from QLayout
    override void addItem(QLayoutItem item);
    override QLayoutItem itemAt(int index) const;
    override QLayoutItem takeAt(int index);

    override void setGeometry(ref const(QRect) rect);
    override QSize minimumSize() const;
    override QSize sizeHint() const;
    override void invalidate();

    override bool hasHeightForWidth() const;
    override int heightForWidth(int width) const;
    override /+ Qt:: +/qt.core.namespace.Orientations expandingDirections() const;
    override int count() const;

    final int rowCount() const;

/+ #if 0
    void dump() const;
#endif +/

private:
    final void resetFieldGrowthPolicy();
    final void resetRowWrapPolicy();
    final void resetLabelAlignment();
    final void resetFormAlignment();
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QFormLayout::TakeRowResult, Q_PRIMITIVE_TYPE); +/

