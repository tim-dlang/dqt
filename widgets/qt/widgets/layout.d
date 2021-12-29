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
module qt.widgets.layout;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.margins;
import qt.core.namespace;
import qt.core.object;
import qt.core.rect;
import qt.core.size;
import qt.helpers;
import qt.widgets.layoutitem;
import qt.widgets.sizepolicy;
import qt.widgets.widget;



extern(C++, class) struct QLayoutPrivate;

/// Binding for C++ class [QLayout](https://doc.qt.io/qt-5/qlayout.html).
class /+ Q_WIDGETS_EXPORT +/ QLayout : QObject, QLayoutItemInterface
{
    QLayoutItemFakeInheritance baseQLayoutItem;
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QLayout) +/

/+ #if QT_DEPRECATED_SINCE(5, 13)
    Q_PROPERTY(int margin READ margin WRITE setMargin)
#endif
    Q_PROPERTY(int spacing READ spacing WRITE setSpacing)
    Q_PROPERTY(SizeConstraint sizeConstraint READ sizeConstraint WRITE setSizeConstraint) +/
public:
    enum SizeConstraint {
        SetDefaultConstraint,
        SetNoConstraint,
        SetMinimumSize,
        SetFixedSize,
        SetMaximumSize,
        SetMinAndMaxSize
    }
    /+ Q_ENUM(SizeConstraint) +/

    this(QWidget parent);
    mixin(mangleItanium("_ZN7QLayoutC2Ev", q{
    this();
    }));
    ~this();

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    final int margin() const;
    final void setMargin(int);
/+ #endif +/

    final int spacing() const;
    final void setSpacing(int);

    final void setContentsMargins(int left, int top, int right, int bottom);
    final void setContentsMargins(ref const(QMargins) margins);
    final void getContentsMargins(int* left, int* top, int* right, int* bottom) const;
    final QMargins contentsMargins() const;
    final QRect contentsRect() const;

    final bool setAlignment(QWidget w, /+ Qt:: +/qt.core.namespace.Alignment alignment);
    final bool setAlignment(QLayout l, /+ Qt:: +/qt.core.namespace.Alignment alignment);
    /+ using QLayoutItem::setAlignment; +/

    final void setSizeConstraint(SizeConstraint);
    final SizeConstraint sizeConstraint() const;
    final void setMenuBar(QWidget w);
    final QWidget menuBar() const;

    final QWidget parentWidget() const;

    override void invalidate();
    override QRect geometry() const;
    final bool activate();
    final void update();

    final void addWidget(QWidget w);
    /+ virtual +/ abstract void addItem(QLayoutItem );

    final void removeWidget(QWidget w);
    final void removeItem(QLayoutItem );

    override /+ Qt:: +/qt.core.namespace.Orientations expandingDirections() const;
    override QSize minimumSize() const;
    override QSize maximumSize() const;
    /+ virtual +/ override void setGeometry(ref const(QRect));
    /+ virtual +/ abstract QLayoutItem itemAt(int index) const;
    /+ virtual +/ abstract QLayoutItem takeAt(int index);
    /+ virtual +/ int indexOf(QWidget ) const;
    /+ QT6_VIRTUAL +/ final int indexOf(QLayoutItem ) const;
    /+ virtual +/ abstract int count() const;
    override bool isEmpty() const;
    override QSizePolicy.ControlTypes controlTypes() const;

    /+ QT6_VIRTUAL +/ final QLayoutItem replaceWidget(QWidget from, QWidget to,
                                               /+ Qt:: +/qt.core.namespace.FindChildOptions options = /+ Qt:: +/qt.core.namespace.FindChildOption.FindChildrenRecursively);

    final int totalHeightForWidth(int w) const;
    final QSize totalMinimumSize() const;
    final QSize totalMaximumSize() const;
    final QSize totalSizeHint() const;
    override QLayout layout();

    final void setEnabled(bool);
    final bool isEnabled() const;


    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static QSize closestAcceptableSize(const(QWidget) w, ref const(QSize) s);
    }));

    override QSize sizeHint() const
    {
        assert(0);
    }
    override bool hasHeightForWidth() const
    {
        assert(0);
    }
    override int heightForWidth(int w) const
    {
        assert(0);
    }
    override int minimumHeightForWidth(int w) const
    {
        assert(0);
    }
    override QWidget widget()
    {
        assert(0);
    }
    override QSpacerItem spacerItem()
    {
        assert(0);
    }

protected:
    final void widgetEvent(QEvent );
    override void childEvent(QChildEvent e);
    final void addChildLayout(QLayout l);
    final void addChildWidget(QWidget w);
    final bool adoptLayout(QLayout layout);

    final QRect alignmentRect(ref const(QRect)) const;
protected:
    this(ref QLayoutPrivate d, QLayout, QWidget);

private:
    /+ Q_DISABLE_COPY(QLayout) +/

    static void activateRecursiveHelper(QLayoutItem item);

    /+ friend class QApplicationPrivate; +/
    /+ friend class QWidget; +/

}


//### support old includes

