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
module qt.pdf.bookmarkmodel;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.bytearray;
import qt.core.hash;
import qt.core.namespace;
import qt.core.object;
import qt.core.variant;
import qt.helpers;
import qt.pdf.document;

struct QPdfBookmarkModelPrivate;

/// Binding for C++ class [QPdfBookmarkModel](https://doc.qt.io/qt-6/qpdfbookmarkmodel.html).
class /+ Q_PDF_EXPORT +/ QPdfBookmarkModel : QAbstractItemModel
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QPdfDocument* document READ document WRITE setDocument NOTIFY documentChanged) +/

public:
    enum /+ class +/ Role : int
    {
        Title = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole,
        Level,
        Page,
        Location,
        Zoom,
        NRoles
    }
    /+ Q_ENUM(Role) +/

    this()
    {
        this(null);
    }
    /+ explicit +/this(QObject parent);
    ~this();

    final QPdfDocument document() const;
    final void setDocument(QPdfDocument document);

    override QVariant data(ref const(QModelIndex) index, int role) const;
    override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex parent(ref const(QModelIndex) index) const;
    override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override int columnCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QHash!(int, QByteArray) roleNames() const;

/+ Q_SIGNALS +/public:
    @QSignal final void documentChanged(QPdfDocument document);

private:
    /+ std:: +/ /*unique_ptr!*/ QPdfBookmarkModelPrivate* d;

    /+ Q_PRIVATE_SLOT(d, void _q_documentStatusChanged()) +/

    /+ friend struct QPdfBookmarkModelPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

