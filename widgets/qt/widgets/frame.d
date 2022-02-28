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
module qt.widgets.frame;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.rect;
import qt.core.size;
import qt.gui.event;
import qt.gui.painter;
import qt.helpers;
import qt.widgets.styleoption;
import qt.widgets.widget;

extern(C++, class) struct QFramePrivate;

/// Binding for C++ class [QFrame](https://doc.qt.io/qt-6/qframe.html).
class /+ Q_WIDGETS_EXPORT +/ QFrame : QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(Shape frameShape READ frameShape WRITE setFrameShape)
    Q_PROPERTY(Shadow frameShadow READ frameShadow WRITE setFrameShadow)
    Q_PROPERTY(int lineWidth READ lineWidth WRITE setLineWidth)
    Q_PROPERTY(int midLineWidth READ midLineWidth WRITE setMidLineWidth)
    Q_PROPERTY(int frameWidth READ frameWidth)
    Q_PROPERTY(QRect frameRect READ frameRect WRITE setFrameRect DESIGNABLE false) +/

public:
    /+ explicit +/this(QWidget parent = null, /+ Qt:: +/qt.core.namespace.WindowFlags f = /+ Qt:: +/qt.core.namespace.WindowFlags());
    ~this();

    final int frameStyle() const;
    final void setFrameStyle(int);

    final int frameWidth() const;

    override QSize sizeHint() const;

    enum Shape {
        NoFrame  = 0, // no frame
        Box = 0x0001, // rectangular box
        Panel = 0x0002, // rectangular panel
        WinPanel = 0x0003, // rectangular panel (Windows)
        HLine = 0x0004, // horizontal line
        VLine = 0x0005, // vertical line
        StyledPanel = 0x0006 // rectangular panel depending on the GUI style
    }
    /+ Q_ENUM(Shape) +/
    enum Shadow {
        Plain = 0x0010, // plain line
        Raised = 0x0020, // raised shadow effect
        Sunken = 0x0030 // sunken shadow effect
    }
    /+ Q_ENUM(Shadow) +/

    enum StyleMask {
        Shadow_Mask = 0x00f0, // mask for the shadow
        Shape_Mask = 0x000f // mask for the shape
    }

    final Shape frameShape() const;
    final void setFrameShape(Shape);
    final Shadow frameShadow() const;
    final void setFrameShadow(Shadow);

    final int lineWidth() const;
    final void setLineWidth(int);

    final int midLineWidth() const;
    final void setMidLineWidth(int);

    final QRect frameRect() const;
    final void setFrameRect(ref const(QRect) );

protected:
    override bool event(QEvent e);
    override void paintEvent(QPaintEvent );
    override void changeEvent(QEvent );
    final void drawFrame(QPainter* );


protected:
    this(ref QFramePrivate dd, QWidget parent = null, /+ Qt:: +/qt.core.namespace.WindowFlags f = /+ Qt:: +/qt.core.namespace.WindowFlags());
    /+ virtual +/ void initStyleOption(QStyleOptionFrame* option) const;

private:
    /+ Q_DISABLE_COPY(QFrame) +/
    /+ Q_DECLARE_PRIVATE(QFrame) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

