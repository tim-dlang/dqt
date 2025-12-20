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
module qt.gui.textdocumentwriter;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.iodevice;
import qt.core.list;
import qt.core.string;
import qt.gui.textdocument;
import qt.gui.textdocumentfragment;
import qt.helpers;

extern(C++, class) struct QTextDocumentWriterPrivate;

/// Binding for C++ class [QTextDocumentWriter](https://doc.qt.io/qt-6/qtextdocumentwriter.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextDocumentWriter
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

    this(QIODevice device, ref const(QByteArray) format);
    /+ explicit +/this(ref const(QString) fileName, ref const(QByteArray) format = globalInitVar!QByteArray);
    ~this();

    void setFormat (ref const(QByteArray) format);
    QByteArray format () const;

    void setDevice (QIODevice device);
    QIODevice device () const;
    void setFileName (ref const(QString) fileName);
    QString fileName () const;

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    bool write(const(QTextDocument) document);
    }));
    bool write(ref const(QTextDocumentFragment) fragment);

    static QList!(QByteArray) supportedDocumentFormats();

private:
    /+ Q_DISABLE_COPY(QTextDocumentWriter) +/
@disable this(this);
/+@disable this(ref const(QTextDocumentWriter));+/@disable ref QTextDocumentWriter opAssign(ref const(QTextDocumentWriter));    QTextDocumentWriterPrivate* d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

