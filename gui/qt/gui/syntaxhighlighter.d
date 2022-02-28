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
module qt.gui.syntaxhighlighter;
extern(C++):

import qt.config;
import qt.helpers;
static if(!defined!"QT_NO_SYNTAXHIGHLIGHTER")
{
    import qt.core.object;
    import qt.core.string;
    import qt.gui.color;
    import qt.gui.font;
    import qt.gui.textdocument;
    import qt.gui.textformat;
    import qt.gui.textobject;
}

static if(!defined!"QT_NO_SYNTAXHIGHLIGHTER")
{



extern(C++, class) struct QSyntaxHighlighterPrivate;

/// Binding for C++ class [QSyntaxHighlighter](https://doc.qt.io/qt-6/qsyntaxhighlighter.html).
abstract class /+ Q_GUI_EXPORT +/ QSyntaxHighlighter : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QSyntaxHighlighter) +/
public:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QObject parent);
    }));
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QTextDocument parent);
    }));
    ~this();

    final void setDocument(QTextDocument doc);
    final QTextDocument document() const;

public /+ Q_SLOTS +/:
    @QSlot final void rehighlight();
    @QSlot final void rehighlightBlock(ref const(QTextBlock) block);

protected:
    /+ virtual +/ abstract void highlightBlock(ref const(QString) text);

    final void setFormat(int start, int count, ref const(QTextCharFormat) format);
    final void setFormat(int start, int count, ref const(QColor) color);
    final void setFormat(int start, int count, ref const(QFont) font);
    final QTextCharFormat format(int pos) const;

    final int previousBlockState() const;
    final int currentBlockState() const;
    final void setCurrentBlockState(int newState);

    final void setCurrentBlockUserData(QTextBlockUserData data);
    final QTextBlockUserData currentBlockUserData() const;

    final QTextBlock currentBlock() const;

private:
    /+ Q_DISABLE_COPY(QSyntaxHighlighter) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_reformatBlocks(int from, int charsRemoved, int charsAdded))
    Q_PRIVATE_SLOT(d_func(), void _q_delayedRehighlight()) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


}

