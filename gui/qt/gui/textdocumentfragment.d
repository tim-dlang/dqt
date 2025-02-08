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
module qt.gui.textdocumentfragment;
extern(C++):

import qt.config;
import qt.core.string;
import qt.gui.textcursor;
import qt.gui.textdocument;
import qt.helpers;

/+ class QTextStream; +/
extern(C++, class) struct QTextDocumentFragmentPrivate;

/// Binding for C++ class [QTextDocumentFragment](https://doc.qt.io/qt-6/qtextdocumentfragment.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextDocumentFragment
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ explicit +/this(const(QTextDocument) document);
    }));
    /+ explicit +/this(ref const(QTextCursor) range);
    @disable this(this);
    this(ref const(QTextDocumentFragment) rhs);
    /+ref QTextDocumentFragment operator =(ref const(QTextDocumentFragment) rhs);+/
    ~this();

    bool isEmpty() const;

    QString toPlainText() const;
    QString toRawText() const;
/+ #ifndef QT_NO_TEXTHTMLPARSER +/
    version (QT_NO_TEXTHTMLPARSER) {} else
    {
        QString toHtml() const;
    }
/+ #endif // QT_NO_TEXTHTMLPARSER
#if QT_CONFIG(textmarkdownwriter) +/
    QString toMarkdown(QTextDocument.MarkdownFeatures features = QTextDocument.MarkdownFeature.MarkdownDialectGitHub) const;
/+ #endif +/

    static QTextDocumentFragment fromPlainText(ref const(QString) plainText);
/+ #ifndef QT_NO_TEXTHTMLPARSER +/
    version (QT_NO_TEXTHTMLPARSER) {} else
    {
        mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
        static QTextDocumentFragment fromHtml(ref const(QString) html, const(QTextDocument) resourceProvider = null);
        }));
    }
/+ #endif // QT_NO_TEXTHTMLPARSER
#if QT_CONFIG(textmarkdownreader) +/
    static QTextDocumentFragment fromMarkdown(ref const(QString) markdown,
                                                  QTextDocument.MarkdownFeatures features = QTextDocument.MarkdownFeature.MarkdownDialectGitHub);
/+ #endif +/

private:
    QTextDocumentFragmentPrivate* d;
    /+ friend class QTextCursor; +/
    /+ friend class QTextDocumentWriter; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

