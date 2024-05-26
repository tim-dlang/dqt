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
module qt.quick.textdocument;
extern(C++):

import qt.config;
import qt.core.object;
import qt.gui.textdocument;
import qt.helpers;
import qt.quick.item;

extern(C++, class) struct QQuickTextDocumentPrivate;
/// Binding for C++ class [QQuickTextDocument](https://doc.qt.io/qt-5/qquicktextdocument.html).
class /+ Q_QUICK_EXPORT +/ QQuickTextDocument : QObject
{
    mixin(Q_OBJECT);
    /+ QML_ANONYMOUS +/

public:
    this(QQuickItem parent);
    final QTextDocument textDocument() const;

private:
    /+ Q_DISABLE_COPY(QQuickTextDocument) +/
    /+ Q_DECLARE_PRIVATE(QQuickTextDocument) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ QML_DECLARE_TYPE(QQuickTextDocument) +/

