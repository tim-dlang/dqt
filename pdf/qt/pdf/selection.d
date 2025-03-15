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
module qt.pdf.selection;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.object;
import qt.core.objectdefs;
import qt.core.rect;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.gui.polygon;
import qt.helpers;
version (QT_NO_CLIPBOARD)
    import qt.gui.windowdefs;
version (QT_NO_CLIPBOARD) {} else
    import qt.gui.clipboard;

extern(C++, class) struct QPdfSelectionPrivate;

/// Binding for C++ class [QPdfSelection](https://doc.qt.io/qt-6/qpdfselection.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct QPdfSelection
{
    /+ Q_GADGET_EXPORT(Q_PDF_EXPORT) +/
    /+ Q_PROPERTY(bool valid READ isValid)
    Q_PROPERTY(QList<QPolygonF> bounds READ bounds)
    Q_PROPERTY(QRectF boundingRectangle READ boundingRectangle)
    Q_PROPERTY(QString text READ text)
    Q_PROPERTY(int startIndex READ startIndex)
    Q_PROPERTY(int endIndex READ endIndex) +/

public:
    /+ Q_PDF_EXPORT +/~this();
    @disable this(this);
    /+ Q_PDF_EXPORT +/this(ref const(QPdfSelection) other);
    /+/+ Q_PDF_EXPORT +/ ref QPdfSelection operator =(ref const(QPdfSelection) other);+/

    /+ Q_PDF_EXPORT QPdfSelection(QPdfSelection &&other) noexcept; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QPdfSelection) +/

    /+ void swap(QPdfSelection &other) noexcept { d.swap(other.d); } +/

    /+ Q_PDF_EXPORT +/ bool isValid() const;
    /+ Q_PDF_EXPORT +/ QList!(QPolygonF) bounds() const;
    /+ Q_PDF_EXPORT +/ QString text() const;
    /+ Q_PDF_EXPORT +/ QRectF boundingRectangle() const;
    /+ Q_PDF_EXPORT +/ int startIndex() const;
    /+ Q_PDF_EXPORT +/ int endIndex() const;
/+ #if QT_CONFIG(clipboard) +/
    /+ Q_PDF_EXPORT +/ void copyToClipboard(mixin((!versionIsSet!("QT_NO_CLIPBOARD")) ? q{QClipboard.Mode } : q{AliasSeq!()}) mode /+ = QClipboard::Clipboard +/) const;
/+ #endif +/

private:
    @disable this();

    //this(ref const(QString) text, QList!(QPolygonF) bounds, QRectF boundingRect, int startIndex, int endIndex);
    //this(QPdfSelectionPrivate* d);
    /+ friend class QPdfDocument; +/
    /+ friend class QQuickPdfSelection; +/

private:
    QExplicitlySharedDataPointer!(QPdfSelectionPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED(QPdfSelection) +/

