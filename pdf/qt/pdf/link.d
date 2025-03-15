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
module qt.pdf.link;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.list;
import qt.core.metatype;
import qt.core.object;
import qt.core.objectdefs;
import qt.core.point;
import qt.core.rect;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.url;
import qt.helpers;
version (QT_NO_CLIPBOARD)
    import qt.gui.windowdefs;
version (QT_NO_CLIPBOARD) {} else
    import qt.gui.clipboard;

/+ class QDebug; +/
extern(C++, class) struct QPdfLinkPrivate;

/// Binding for C++ class [QPdfLink](https://doc.qt.io/qt-6/qpdflink.html).
@Q_DECLARE_METATYPE @Q_RELOCATABLE_TYPE extern(C++, class) struct QPdfLink
{
    /+ Q_GADGET_EXPORT(Q_PDF_EXPORT) +/
    /+ Q_PROPERTY(bool valid READ isValid)
    Q_PROPERTY(int page READ page)
    Q_PROPERTY(QPointF location READ location)
    Q_PROPERTY(qreal zoom READ zoom)
    Q_PROPERTY(QUrl url READ url)
    Q_PROPERTY(QString contextBefore READ contextBefore)
    Q_PROPERTY(QString contextAfter READ contextAfter)
    Q_PROPERTY(QList<QRectF> rectangles READ rectangles) +/

public:
    @disable this();
    /+ Q_PDF_EXPORT +/pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ Q_PDF_EXPORT +/~this();
    /+/+ Q_PDF_EXPORT +/ ref QPdfLink operator =(ref const(QPdfLink) other);+/

    @disable this(this);
    /+ Q_PDF_EXPORT +/this(ref const(QPdfLink) other)/+ noexcept+/;
    /+ Q_PDF_EXPORT QPdfLink(QPdfLink &&other) noexcept; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QPdfLink) +/

    /+ void swap(QPdfLink &other) noexcept { d.swap(other.d); } +/

    /+ Q_PDF_EXPORT +/ bool isValid() const;
    /+ Q_PDF_EXPORT +/ int page() const;
    /+ Q_PDF_EXPORT +/ QPointF location() const;
    /+ Q_PDF_EXPORT +/ qreal zoom() const;
    /+ Q_PDF_EXPORT +/ QUrl url() const;
    /+ Q_PDF_EXPORT +/ QString contextBefore() const;
    /+ Q_PDF_EXPORT +/ QString contextAfter() const;
    /+ Q_PDF_EXPORT +/ QList!(QRectF) rectangles() const;
    /+ Q_PDF_EXPORT +/ @QInvokable QString toString() const;
    /+ Q_PDF_EXPORT +/ @QInvokable void copyToClipboard(mixin((!versionIsSet!("QT_NO_CLIPBOARD")) ? q{QClipboard.Mode } : q{AliasSeq!()}) mode /+ = QClipboard::Clipboard +/) const;

private: // methods
    //this(int page, QPointF location, qreal zoom);
    //this(int page, QList!(QRectF) rects, QString contextBefore, QString contextAfter);
    //this(QPdfLinkPrivate* d);
    /+ friend class QPdfDocument; +/
    /+ friend class QPdfLinkModelPrivate; +/
    /+ friend class QPdfSearchModelPrivate; +/
    /+ friend class QPdfPageNavigator; +/
    /+ friend class QQuickPdfPageNavigator; +/

private: // storage
    QExplicitlySharedDataPointer!(QPdfLinkPrivate) d;

    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED(QPdfLink)

#ifndef QT_NO_DEBUG_STREAM
Q_PDF_EXPORT QDebug operator<<(QDebug, const QPdfLink &);
#endif


Q_DECLARE_METATYPE(QPdfLink) +/

