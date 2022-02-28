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
module qt.widgets.fileiconprovider;
extern(C++):

import qt.config;
import qt.core.fileinfo;
import qt.gui.abstractfileiconprovider;
import qt.gui.icon;
import qt.helpers;

extern(C++, class) struct QFileIconProviderPrivate;

/// Binding for C++ class [QFileIconProvider](https://doc.qt.io/qt-6/qfileiconprovider.html).
class /+ Q_WIDGETS_EXPORT +/ QFileIconProvider : QAbstractFileIconProvider
{
public:
    this();
    ~this();

    override QIcon icon(IconType type) const;
    override QIcon icon(ref const(QFileInfo) info) const;

private:
    /+ Q_DECLARE_PRIVATE(QFileIconProvider) +/
    /+ Q_DISABLE_COPY(QFileIconProvider) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

