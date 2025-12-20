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
module qt.webengine.history;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.bytearray;
import qt.core.datetime;
import qt.core.hash;
import qt.core.list;
import qt.core.namespace;
import qt.core.object;
import qt.core.scopedpointer;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.url;
import qt.core.variant;
import qt.helpers;

extern(C++, class) struct QWebEngineHistoryPrivate;
extern(C++, class) struct QWebEngineHistoryItemPrivate;
extern(C++, class) struct QWebEngineHistoryModelPrivate;
extern(C++, class) struct QWebEnginePagePrivate;
extern(C++, class) struct QQuickWebEngineViewPrivate;

/// Binding for C++ class [QWebEngineHistoryItem](https://doc.qt.io/qt-6/qwebenginehistoryitem.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineHistoryItem
{
public:
    @disable this(this);
    this(ref const(QWebEngineHistoryItem) other);
    /+ QWebEngineHistoryItem(QWebEngineHistoryItem &&other); +/
    ref QWebEngineHistoryItem opAssign(ref const(QWebEngineHistoryItem) other);
    /+ QWebEngineHistoryItem &operator=(QWebEngineHistoryItem &&other); +/
    ~this();

    QUrl originalUrl() const;
    QUrl url() const;

    QString title() const;
    QDateTime lastVisited() const;
    QUrl iconUrl() const;

    bool isValid() const;

    /+ void swap(QWebEngineHistoryItem &other) noexcept { d.swap(other.d); } +/

private:
    this(QWebEngineHistoryItemPrivate* priv);
    /+ Q_DECLARE_PRIVATE_D(d.data(), QWebEngineHistoryItem) +/
    QExplicitlySharedDataPointer!(QWebEngineHistoryItemPrivate) d;
    /+ friend class QWebEngineHistory; +/
    /+ friend class QWebEngineHistoryPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QWebEngineHistoryItem) +/

/// Binding for C++ class [QWebEngineHistoryModel](https://doc.qt.io/qt-6/qwebenginehistorymodel.html).
class /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineHistoryModel : QAbstractListModel
{
    mixin(Q_OBJECT);

public:
    enum Roles {
        UrlRole = cast(int) /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole,
        TitleRole,
        OffsetRole,
        IconUrlRole,
    }

    override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QVariant data(ref const(QModelIndex) index, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override QHash!(int, QByteArray) roleNames() const;
    final void reset();

private:
    this(QWebEngineHistoryModelPrivate* );
    /+ virtual +/~this();

    /+ Q_DISABLE_COPY(QWebEngineHistoryModel) +/
    /+ Q_DECLARE_PRIVATE(QWebEngineHistoryModel) +/
    QScopedPointer!(QWebEngineHistoryModelPrivate) d_ptr;

    /+ friend class QWebEngineHistory; +/
    /+ friend class QWebEngineHistoryPrivate; +/
    /+ friend void QScopedPointerDeleter<QWebEngineHistoryModel>::cleanup(QWebEngineHistoryModel *) noexcept; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QWebEngineHistory](https://doc.qt.io/qt-6/qwebenginehistory.html).
class /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineHistory : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QWebEngineHistoryModel *items READ itemsModel CONSTANT FINAL)
    Q_PROPERTY(QWebEngineHistoryModel *backItems READ backItemsModel CONSTANT FINAL)
    Q_PROPERTY(QWebEngineHistoryModel *forwardItems READ forwardItemsModel CONSTANT FINAL) +/

public:
    /+ Q_REVISION(1) +/ @QInvokable final void clear();

    final QList!(QWebEngineHistoryItem) items() const;
    final QList!(QWebEngineHistoryItem) backItems(int maxItems) const;
    final QList!(QWebEngineHistoryItem) forwardItems(int maxItems) const;

    final bool canGoBack() const;
    final bool canGoForward() const;

    final void back();
    final void forward();
    final void goToItem(ref const(QWebEngineHistoryItem) item);

    final QWebEngineHistoryItem backItem() const;
    final QWebEngineHistoryItem currentItem() const;
    final QWebEngineHistoryItem forwardItem() const;
    final QWebEngineHistoryItem itemAt(int i) const;

    final int currentItemIndex() const;

    final int count() const;

    final QWebEngineHistoryModel itemsModel() const;
    final QWebEngineHistoryModel backItemsModel() const;
    final QWebEngineHistoryModel forwardItemsModel() const;

private:
    this(QWebEngineHistoryPrivate* d);
    ~this();

    /+ Q_DISABLE_COPY(QWebEngineHistory) +/
    /+ Q_DECLARE_PRIVATE(QWebEngineHistory) +/
    QScopedPointer!(QWebEngineHistoryPrivate) d_ptr;

    final void reset();

    /+ friend Q_WEBENGINECORE_EXPORT QDataStream &operator>>(QDataStream &, QWebEngineHistory &); +/
    /+ friend Q_WEBENGINECORE_EXPORT QDataStream &operator<<(QDataStream &, const QWebEngineHistory &); +/
    /+ friend class QWebEnginePagePrivate; +/
    /+ friend class QQuickWebEngineViewPrivate; +/
    /+ friend void QScopedPointerDeleter<QWebEngineHistory>::cleanup(QWebEngineHistory *) noexcept; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

