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
import qt.core.datetime;
import qt.core.list;
import qt.core.scopedpointer;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.url;
import qt.helpers;

extern(C++, class) struct QWebEngineHistoryItemPrivate;
extern(C++, class) struct QWebEnginePagePrivate;

/// Binding for C++ class [QWebEngineHistoryItem](https://doc.qt.io/qt-5/qwebenginehistoryitem.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ QWEBENGINEWIDGETS_EXPORT +/ QWebEngineHistoryItem {
public:
    @disable this(this);
    this(ref const(QWebEngineHistoryItem) other);
    ref QWebEngineHistoryItem opAssign(ref const(QWebEngineHistoryItem) other);
    ~this();

    QUrl originalUrl() const;
    QUrl url() const;

    QString title() const;
    QDateTime lastVisited() const;
    QUrl iconUrl() const;

    bool isValid() const;

    /+ void swap(QWebEngineHistoryItem &other) Q_DECL_NOTHROW { qSwap(d, other.d); } +/

private:
    this(QWebEngineHistoryItemPrivate* priv);
    /+ Q_DECLARE_PRIVATE_D(d.data(), QWebEngineHistoryItem) +/
    QExplicitlySharedDataPointer!(QWebEngineHistoryItemPrivate) d;
    /+ friend class QWebEngineHistory; +/
    /+ friend class QWebEngineHistoryPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED_NOT_MOVABLE_UNTIL_QT6(QWebEngineHistoryItem) +/

extern(C++, class) struct QWebEngineHistoryPrivate;
/// Binding for C++ class [QWebEngineHistory](https://doc.qt.io/qt-5/qwebenginehistory.html).
extern(C++, class) struct /+ QWEBENGINEWIDGETS_EXPORT +/ QWebEngineHistory {
public:
    void clear();

    QList!(QWebEngineHistoryItem) items() const;
    QList!(QWebEngineHistoryItem) backItems(int maxItems) const;
    QList!(QWebEngineHistoryItem) forwardItems(int maxItems) const;

    bool canGoBack() const;
    bool canGoForward() const;

    void back();
    void forward();
    void goToItem(ref const(QWebEngineHistoryItem) item);

    QWebEngineHistoryItem backItem() const;
    QWebEngineHistoryItem currentItem() const;
    QWebEngineHistoryItem forwardItem() const;
    QWebEngineHistoryItem itemAt(int i) const;

    int currentItemIndex() const;

    int count() const;

private:
    this(QWebEngineHistoryPrivate* d);
    ~this();

    /+ Q_DISABLE_COPY(QWebEngineHistory) +/
@disable this(this);
/+@disable this(ref const(QWebEngineHistory));+/@disable ref QWebEngineHistory opAssign(ref const(QWebEngineHistory));    /+ Q_DECLARE_PRIVATE(QWebEngineHistory) +/
    QScopedPointer!(QWebEngineHistoryPrivate) d_ptr;

    /+ friend QWEBENGINEWIDGETS_EXPORT QDataStream& operator>>(QDataStream&, QWebEngineHistory&); +/
    /+ friend QWEBENGINEWIDGETS_EXPORT QDataStream& operator<<(QDataStream&, const QWebEngineHistory&); +/
    /+ friend class QWebEnginePage; +/
    /+ friend class QWebEnginePagePrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ QWEBENGINEWIDGETS_EXPORT QDataStream& operator<<(QDataStream& stream, const QWebEngineHistory& history);
QWEBENGINEWIDGETS_EXPORT QDataStream& operator>>(QDataStream& stream, QWebEngineHistory& history); +/

