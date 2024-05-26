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
module qt.quickcontrols2.style;
extern(C++):

import qt.config;
import qt.core.string;
import qt.core.stringlist;
import qt.helpers;

/// Binding for C++ class [QQuickStyle](https://doc.qt.io/qt-5/qquickstyle.html).
extern(C++, class) struct /+ Q_QUICKCONTROLS2_EXPORT +/ QQuickStyle
{
public:
    static QString name();
    static QString path();
    static void setStyle(ref const(QString) style);
    static void setFallbackStyle(ref const(QString) style);
    static QStringList availableStyles();
    static QStringList stylePathList();
    static void addStylePath(ref const(QString) path);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

