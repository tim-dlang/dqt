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
module qt.svg.widget;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.size;
import qt.core.string;
import qt.gui.event;
import qt.helpers;
import qt.svg.renderer;
import qt.widgets.widget;

extern(C++, class) struct QSvgWidgetPrivate;

/// Binding for C++ class [QSvgWidget](https://doc.qt.io/qt-6/qsvgwidget.html).
class /+ Q_SVGWIDGETS_EXPORT +/ QSvgWidget : QWidget
{
    mixin(Q_OBJECT);
public:
    this(QWidget parent = null);
    this(ref const(QString) file, QWidget parent = null);
    ~this();

    final QSvgRenderer renderer() const;

    override QSize sizeHint() const;
public /+ Q_SLOTS +/:
    @QSlot final void load(ref const(QString) file);
    @QSlot final void load(ref const(QByteArray) contents);
protected:
    override void paintEvent(QPaintEvent event);
private:
    /+ Q_DISABLE_COPY(QSvgWidget) +/
    /+ Q_DECLARE_PRIVATE(QSvgWidget) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

