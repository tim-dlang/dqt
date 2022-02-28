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
module qt.gui.textlist;
extern(C++):

import qt.config;
import qt.core.string;
import qt.gui.textdocument;
import qt.gui.textformat;
import qt.gui.textobject;
import qt.helpers;

extern(C++, class) struct QTextListPrivate;

/// Binding for C++ class [QTextList](https://doc.qt.io/qt-6/qtextlist.html).
class /+ Q_GUI_EXPORT +/ QTextList : QTextBlockGroup
{
    mixin(Q_OBJECT);
public:
    /+ explicit +/this(QTextDocument doc);
    ~this();

    final int count() const;

    final QTextBlock item(int i) const;

    final int itemNumber(ref const(QTextBlock) ) const;
    final QString itemText(ref const(QTextBlock) ) const;

    final void removeItem(int i);
    final void remove(ref const(QTextBlock) );

    final void add(ref const(QTextBlock) block);

    pragma(inline, true) final void setFormat(ref const(QTextListFormat) aformat)
    { QTextObject.setFormat(aformat); }
    final QTextListFormat format() const { return QTextObject.format().toListFormat(); }

private:
    /+ Q_DISABLE_COPY(QTextList) +/
    /+ Q_DECLARE_PRIVATE(QTextList) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

