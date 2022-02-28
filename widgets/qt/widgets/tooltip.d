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
module qt.widgets.tooltip;
extern(C++):

import qt.config;
import qt.core.point;
import qt.core.rect;
import qt.core.string;
import qt.gui.font;
import qt.gui.palette;
import qt.helpers;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(tooltip); +/

/// Binding for C++ class [QToolTip](https://doc.qt.io/qt-6/qtooltip.html).
extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QToolTip
{
private:
    @disable this();

public:
    static void showText(ref const(QPoint) pos, ref const(QString) text,
                             QWidget w = null, ref const(QRect) rect = globalInitVar!QRect, int msecShowTime = -1);
    pragma(inline, true) static void hideText() { auto tmp = QPoint(); auto tmp__1 = QString(); showText(tmp, tmp__1); }

    static bool isVisible();
    static QString text();

    static QPalette palette();
    static void setPalette(ref const(QPalette) );
    static QFont font();
    static void setFont(ref const(QFont) );
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

