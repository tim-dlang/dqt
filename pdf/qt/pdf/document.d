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
module qt.pdf.document;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.iodevice;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.scopedpointer;
import qt.core.size;
import qt.core.string;
import qt.core.variant;
import qt.gui.image;
import qt.helpers;
import qt.pdf.documentrenderoptions;
import qt.pdf.selection;

extern(C++, class) struct QPdfDocumentPrivate;

/// Binding for C++ class [QPdfDocument](https://doc.qt.io/qt-6/qpdfdocument.html).
class /+ Q_PDF_EXPORT +/ QPdfDocument : QObject
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(int pageCount READ pageCount NOTIFY pageCountChanged FINAL)
    Q_PROPERTY(QString password READ password WRITE setPassword NOTIFY passwordChanged FINAL)
    Q_PROPERTY(Status status READ status NOTIFY statusChanged FINAL)
    Q_PROPERTY(QAbstractListModel* pageModel READ pageModel NOTIFY pageModelChanged FINAL) +/

public:
    enum /+ class +/ Status {
        Null,
        Loading,
        Ready,
        Unloading,
        Error
    }
    /+ Q_ENUM(Status) +/

    enum /+ class +/ Error {
        None,
        Unknown,
        DataNotYetAvailable,
        FileNotFound,
        InvalidFileFormat,
        IncorrectPassword,
        UnsupportedSecurityScheme
    }
    /+ Q_ENUM(Error) +/

    enum /+ class +/ MetaDataField {
        Title,
        Subject,
        Author,
        Keywords,
        Producer,
        Creator,
        CreationDate,
        ModificationDate
    }
    /+ Q_ENUM(MetaDataField) +/

    enum /+ class +/ PageModelRole {
        Label = cast(uint) /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole,
        PointSize,
        NRoles
    }
    /+ Q_ENUM(PageModelRole) +/

    this()
    {
        this(null);
    }
    /+ explicit +/this(QObject parent);
    ~this();

    final Error load(ref const(QString) fileName);

    final Status status() const;

    final void load(QIODevice device);
    final void setPassword(ref const(QString) password);
    final QString password() const;

    final QVariant metaData(MetaDataField field) const;

    final Error error() const;

    final void close();

    final int pageCount() const;

    @QInvokable final QSizeF pagePointSize(int page) const;

    @QInvokable final QString pageLabel(int page);

    final QAbstractListModel pageModel();

    final QImage render(int page, QSize imageSize, QPdfDocumentRenderOptions options = QPdfDocumentRenderOptions());

    @QInvokable final QPdfSelection getSelection(int page, QPointF start, QPointF end);
    @QInvokable final QPdfSelection getSelectionAtIndex(int page, int startIndex, int maxLength);
    @QInvokable final QPdfSelection getAllText(int page);

/+ Q_SIGNALS +/public:
    @QSignal final void passwordChanged();
    @QSignal final void passwordRequired();
    @QSignal final void statusChanged(Status status);
    @QSignal final void pageCountChanged(int pageCount);
    @QSignal final void pageModelChanged();

private:
    /+ friend struct QPdfBookmarkModelPrivate; +/
    /+ friend class QPdfFile; +/
    /+ friend class QPdfLinkModelPrivate; +/
    /+ friend class QPdfPageModel; +/
    /+ friend class QPdfSearchModel; +/
    /+ friend class QPdfSearchModelPrivate; +/
    /+ friend class QQuickPdfSelection; +/

    final QString fileName() const;

    /+ Q_PRIVATE_SLOT(d, void _q_tryLoadingWithSizeFromContentHeader())
    Q_PRIVATE_SLOT(d, void _q_copyFromSequentialSourceDevice()) +/
    QScopedPointer!(QPdfDocumentPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

