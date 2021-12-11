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
module qt.widgets.layoutitem;
extern(C++):

import qt.config;
import qt.core.namespace;
import qt.core.rect;
import qt.core.size;
import qt.helpers;
import qt.widgets.layout;
import qt.widgets.sizepolicy;
import qt.widgets.widget;

/+ Q_DECL_UNUSED +/ extern(D) static __gshared const(int) QLAYOUTSIZE_MAX = int.max/256/16;

/+ class QLayout;
class QLayoutItem;
class QSpacerItem;
class QWidget;
class QSize; +/

interface QLayoutItemInterface
{
//    ~this();
    /+ virtual +/ QSize sizeHint() const;
    /+ virtual +/ QSize minimumSize() const;
    /+ virtual +/ QSize maximumSize() const;
    /+ virtual +/ /+ Qt::Orientations +/abstract qt.core.namespace.Orientations expandingDirections() const;
    /+ virtual +/ void setGeometry(ref const(QRect) );
    /+ virtual +/ QRect geometry() const;
    /+ virtual +/ bool isEmpty() const;
    /+ virtual +/ bool hasHeightForWidth() const;
    /+ virtual +/ int heightForWidth(int) const;
    /+ virtual +/ int minimumHeightForWidth(int) const;
    /+ virtual +/ void invalidate();
    /+ virtual +/ QWidget widget();
    /+ virtual +/ QLayout layout();
    /+ virtual +/ QSpacerItem spacerItem();
    /+ virtual +/ /+ QSizePolicy::ControlTypes +/QSizePolicy.ControlTypes controlTypes() const;
}

/// Binding for C++ class [QLayoutItem](https://doc.qt.io/qt-5/qlayoutitem.html).
class /+ Q_WIDGETS_EXPORT +/ QLayoutItem
{
public:
    /+ explicit +/pragma(inline, true) this(/+ Qt:: +/qt.core.namespace.Alignment aalignment = /+ Qt:: +/qt.core.namespace.Alignment())
    {
        this.align_ = aalignment;
    }
    /+ virtual +/~this();
    /+ virtual +/ abstract QSize sizeHint() const;
    /+ virtual +/ abstract QSize minimumSize() const;
    /+ virtual +/ abstract QSize maximumSize() const;
    /+ virtual +/ abstract /+ Qt:: +/qt.core.namespace.Orientations expandingDirections() const;
    /+ virtual +/ abstract void setGeometry(ref const(QRect));
    /+ virtual +/ abstract QRect geometry() const;
    /+ virtual +/ abstract bool isEmpty() const;
    /+ virtual +/ bool hasHeightForWidth() const;
    /+ virtual +/ int heightForWidth(int) const;
    /+ virtual +/ int minimumHeightForWidth(int) const;
    /+ virtual +/ void invalidate();

/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    /+ virtual +/ QWidget widget();
/+ #else
    virtual QWidget *widget() const;
#endif +/
    /+ virtual +/ QLayout layout();
    /+ virtual +/ QSpacerItem spacerItem();

    final /+ Qt:: +/qt.core.namespace.Alignment alignment() const { return align_; }
    final void setAlignment(/+ Qt:: +/qt.core.namespace.Alignment a);
    /+ virtual +/ QSizePolicy.ControlTypes controlTypes() const;

protected:
    /+ Qt:: +/qt.core.namespace.Alignment align_;
}

/// Binding for C++ class [QSpacerItem](https://doc.qt.io/qt-5/qspaceritem.html).
class /+ Q_WIDGETS_EXPORT +/ QSpacerItem : QLayoutItem
{
public:
    this(int w, int h,
                     QSizePolicy.Policy hData = QSizePolicy.Policy.Minimum,
                     QSizePolicy.Policy vData = QSizePolicy.Policy.Minimum)
    {
        this.width = w;
        this.height = h;
        this.sizeP = typeof(this.sizeP)(hData, vData);
    }
    ~this();

    final void changeSize(int w, int h,
                         QSizePolicy.Policy hData = QSizePolicy.Policy.Minimum,
                         QSizePolicy.Policy vData = QSizePolicy.Policy.Minimum);
    override QSize sizeHint() const;
    override QSize minimumSize() const;
    override QSize maximumSize() const;
    override /+ Qt:: +/qt.core.namespace.Orientations expandingDirections() const;
    override bool isEmpty() const;
    override void setGeometry(ref const(QRect));
    override QRect geometry() const;
    override QSpacerItem spacerItem();
    final QSizePolicy sizePolicy() const { return sizeP; }

private:
    int width;
    int height;
    QSizePolicy sizeP;
    QRect rect;
}

/// Binding for C++ class [QWidgetItem](https://doc.qt.io/qt-5/qwidgetitem.html).
class /+ Q_WIDGETS_EXPORT +/ QWidgetItem : QLayoutItem
{
private:
    /+ Q_DISABLE_COPY(QWidgetItem) +/

public:
    /+ explicit +/this(QWidget w)
    {
        this.wid = w;
    }
    ~this();

    override QSize sizeHint() const;
    override QSize minimumSize() const;
    override QSize maximumSize() const;
    override /+ Qt:: +/qt.core.namespace.Orientations expandingDirections() const;
    override bool isEmpty() const;
    override void setGeometry(ref const(QRect));
    override QRect geometry() const;
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    override QWidget widget();
/+ #else
    QWidget *widget() const override;
#endif +/

    override bool hasHeightForWidth() const;
    override int heightForWidth(int) const;
    override QSizePolicy.ControlTypes controlTypes() const;
protected:
    QWidget wid;
}

class /+ Q_WIDGETS_EXPORT +/ QWidgetItemV2 : QWidgetItem
{
public:
    /+ explicit +/this(QWidget widget);
    ~this();

    override QSize sizeHint() const;
    override QSize minimumSize() const;
    override QSize maximumSize() const;
    override int heightForWidth(int width) const;

private:
    enum { Dirty = -123, HfwCacheMaxSize = 3 }

    pragma(inline, true) final bool useSizeCache() const;
    final void updateCacheIfNecessary() const;
    pragma(inline, true) final void invalidateSizeCache() {
        q_cachedMinimumSize.setWidth(Dirty);
        q_hfwCacheSize = 0;
    }

    /+ mutable +/ QSize q_cachedMinimumSize;
    /+ mutable +/ QSize q_cachedSizeHint;
    /+ mutable +/ QSize q_cachedMaximumSize;
    /+ mutable +/ QSize[HfwCacheMaxSize] q_cachedHfws;
    /+ mutable +/ short q_firstCachedHfw;
    /+ mutable +/ short q_hfwCacheSize;
    void* d;

    /+ friend class QWidgetPrivate; +/

    /+ Q_DISABLE_COPY(QWidgetItemV2) +/
}

static assert(__traits(classInstanceSize, QLayoutItem) == (void*).sizeof + 4);
struct QLayoutItemFakeInheritance
{
    void*[(__traits(classInstanceSize, QLayoutItem) + (void*).sizeof - 1) / (void*).sizeof - 1] data;
}

