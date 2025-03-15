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
module qt.pdf.searchmodel;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.bytearray;
import qt.core.coreevent;
import qt.core.hash;
import qt.core.list;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.core.variant;
import qt.helpers;
import qt.pdf.document;
import qt.pdf.link;

extern(C++, class) struct QPdfSearchModelPrivate;

/// Binding for C++ class [QPdfSearchModel](https://doc.qt.io/qt-6/qpdfsearchmodel.html).
class /+ Q_PDF_EXPORT +/ QPdfSearchModel : QAbstractListModel
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QPdfDocument *document READ document WRITE setDocument NOTIFY documentChanged)
    Q_PROPERTY(QString searchString READ searchString WRITE setSearchString NOTIFY searchStringChanged) +/

public:
    enum /+ class +/ Role : int {
        Page = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole,
        IndexOnPage,
        Location,
        ContextBefore,
        ContextAfter,
        NRoles
    }
    /+ Q_ENUM(Role) +/
    this()
    {
        this(null);
    }
    /+ explicit +/this(QObject parent);
    ~this();

    final QList!(QPdfLink) resultsOnPage(int page) const;
    final QPdfLink resultAtIndex(int index) const;

    final QPdfDocument document() const;
    final QString searchString() const;

    override QHash!(int, QByteArray) roleNames() const;
    override int rowCount(ref const(QModelIndex) parent) const;
    override QVariant data(ref const(QModelIndex) index, int role) const;

public /+ Q_SLOTS +/:
    @QSlot final void setSearchString(ref const(QString) searchString);
    @QSlot final void setDocument(QPdfDocument document);

/+ Q_SIGNALS +/public:
    @QSignal final void documentChanged();
    @QSignal final void searchStringChanged();

protected:
    final void updatePage(int page);
    override void timerEvent(QTimerEvent event);

private:
    QHash!(int, QByteArray) m_roleNames;
    /+ Q_DECLARE_PRIVATE(QPdfSearchModel) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

