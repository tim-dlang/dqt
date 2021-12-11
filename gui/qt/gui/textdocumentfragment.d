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
version(QT_NO_TEXTHTMLPARSER){}else
    import qt.core.bytearray;

/+ class QTextStream;
class QTextDocument; +/
extern(C++, class) struct QTextDocumentFragmentPrivate;
/+ class QTextCursor; +/

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

    /+ explicit +/this(const(QTextDocument) document);
    /+ explicit +/this(ref const(QTextCursor) range);
    @disable this(this);
    this(ref const(QTextDocumentFragment) rhs);
    /+ref QTextDocumentFragment operator =(ref const(QTextDocumentFragment) rhs);+/
    ~this();

    bool isEmpty() const;

    QString toPlainText() const;
    version(QT_NO_TEXTHTMLPARSER){}else
    {
        QString toHtml(ref const(QByteArray) encoding = globalInitVar!QByteArray) const;
    }

    static QTextDocumentFragment fromPlainText(ref const(QString) plainText);
    version(QT_NO_TEXTHTMLPARSER){}else
    {
        static QTextDocumentFragment fromHtml(ref const(QString) html);
        static QTextDocumentFragment fromHtml(ref const(QString) html, const(QTextDocument) resourceProvider);
    }

private:
    QTextDocumentFragmentPrivate* d;
    /+ friend class QTextCursor; +/
    /+ friend class QTextDocumentWriter; +/
}

