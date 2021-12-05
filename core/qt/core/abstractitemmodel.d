/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.core.abstractitemmodel;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.datastream;
import qt.core.flags;
import qt.core.global;
import qt.core.hash;
import qt.core.list;
import qt.core.map;
import qt.core.metatype;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.object;
import qt.core.size;
import qt.core.stringlist;
import qt.core.typeinfo;
import qt.core.variant;
import qt.core.vector;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(itemmodel);



class QAbstractItemModel;
class QPersistentModelIndex; +/

@(QMetaType.Type.QModelIndex) @Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QModelIndex
{
private:
    /+ friend class QAbstractItemModel; +/
public:
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.r = -1;
        this.c = -1;
        this.i = 0;
        this.m = null;
    }+/
    // compiler-generated copy/move ctors/assignment operators are fine!
    pragma(inline, true) int row() const/+ noexcept+/ { return r; }
    pragma(inline, true) int column() const/+ noexcept+/ { return c; }
    pragma(inline, true) quintptr internalId() const/+ noexcept+/ { return i; }
    pragma(inline, true) void* internalPointer() const/+ noexcept+/ { return reinterpret_cast!(void*)(i); }
    pragma(inline, true) QModelIndex parent() const
    { return m ? m.parent(this) : QModelIndex(); }
    pragma(inline, true) QModelIndex sibling(int arow, int acolumn) const
    { auto r = m ? (r == arow && c == acolumn) ? this : m.sibling(arow, acolumn, this) : QModelIndex(); return *cast(QModelIndex*)&r; }
    pragma(inline, true) QModelIndex siblingAtColumn(int acolumn) const
    { auto r = m ? (c == acolumn) ? this : m.sibling(r, acolumn, this) : QModelIndex(); return *cast(QModelIndex*)&r; }
    pragma(inline, true) QModelIndex siblingAtRow(int arow) const
    { auto r = m ? (r == arow) ? this : m.sibling(arow, c, this) : QModelIndex(); return *cast(QModelIndex*)&r;  }
/+ #if QT_DEPRECATED_SINCE(5, 8) +/
    /+ QT_DEPRECATED_X("Use QAbstractItemModel::index") +/ pragma(inline, true) QModelIndex child(int arow, int acolumn) const
    { return m ? m.index(arow, acolumn, this) : QModelIndex(); }
/+ #endif +/
    pragma(inline, true) QVariant data(int arole = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const
    { return m ? m.data(this, arole) : QVariant(); }
    pragma(inline, true) /+ Qt:: +/qt.core.namespace.ItemFlags flags() const
    { return m ? m.flags(this) : /+ Qt:: +/qt.core.namespace.ItemFlags(); }
    pragma(inline, true) const(QAbstractItemModel) model() const/+ noexcept+/ { return m; }
    pragma(inline, true) bool isValid() const/+ noexcept+/ { return (r >= 0) && (c >= 0) && (m !is null); }
    /+pragma(inline, true) bool operator ==(ref const(QModelIndex) other) const/+ noexcept+/
        { return (other.r == r) && (other.i == i) && (other.c == c) && (other.m == m); }+/
    /+pragma(inline, true) bool operator !=(ref const(QModelIndex) other) const/+ noexcept+/
        { return !(this == other); }+/
    /+pragma(inline, true) bool operator <(ref const(QModelIndex) other) const/+ noexcept+/
        {
            return  r <  other.r
                || (r == other.r && (c <  other.c
                                 || (c == other.c && (i <  other.i
                                                  || (i == other.i && /+ std:: +/less!(const(QAbstractItemModel))()(m, other.m))))));
        }+/
private:
    pragma(inline, true) this(int arow, int acolumn, void* ptr, const(QAbstractItemModel) amodel)/+ noexcept+/
    {
        this.r = arow;
        this.c = acolumn;
        this.i = reinterpret_cast!(quintptr)(ptr);
        this.m = *cast(QAbstractItemModel*)&amodel;
    }
    pragma(inline, true) this(int arow, int acolumn, quintptr id, const(QAbstractItemModel) amodel)/+ noexcept+/
    {
        this.r = arow;
        this.c = acolumn;
        this.i = id;
        this.m = *cast(QAbstractItemModel*)&amodel;
    }
    int r = -1; int c = -1;
    quintptr i = 0;
    /*const*/ QAbstractItemModel m = null;
}
/+ Q_DECLARE_TYPEINFO(QModelIndex, Q_MOVABLE_TYPE);

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QModelIndex &);
#endif +/

extern(C++, class) struct QPersistentModelIndexData;

// qHash is a friend, but we can't use default arguments for friends (§8.3.6.4)
/+ uint qHash(const QPersistentModelIndex &index, uint seed = 0) noexcept; +/

@(QMetaType.Type.QPersistentModelIndex) @Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QPersistentModelIndex
{
public:

    this(ref const(QModelIndex) index);
    @disable this(this);
    this(ref const(QPersistentModelIndex) other);
    ~this();
    /+bool operator <(ref const(QPersistentModelIndex) other) const;+/
    /+bool operator ==(ref const(QPersistentModelIndex) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QPersistentModelIndex) other) const
    { return !operator==(other); }+/
    /+ref QPersistentModelIndex operator =(ref const(QPersistentModelIndex) other);+/
    /+ inline QPersistentModelIndex(QPersistentModelIndex &&other) noexcept
        : d(other.d) { other.d = nullptr; } +/
    /+ inline QPersistentModelIndex &operator=(QPersistentModelIndex &&other) noexcept
    { qSwap(d, other.d); return *this; } +/
    /+ inline void swap(QPersistentModelIndex &other) noexcept { qSwap(d, other.d); } +/
    /+bool operator ==(ref const(QModelIndex) other) const;+/
    /+bool operator !=(ref const(QModelIndex) other) const;+/
    /+ref QPersistentModelIndex operator =(ref const(QModelIndex) other);+/
    /+auto opCast(T : const(QModelIndex))() const;+/
    int row() const;
    int column() const;
    void* internalPointer() const;
    quintptr internalId() const;
    QModelIndex parent() const;
    QModelIndex sibling(int row, int column) const;
/+ #if QT_DEPRECATED_SINCE(5, 8) +/
    /+ QT_DEPRECATED_X("Use QAbstractItemModel::index") +/ QModelIndex child(int row, int column) const;
/+ #endif +/
    QVariant data(int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    /+ Qt:: +/qt.core.namespace.ItemFlags flags() const;
    mixin(mangleWindows("?model@QPersistentModelIndex@@QEBAPEBVQAbstractItemModel@@XZ", q{
    const(QAbstractItemModel) model() const;
    }));
    bool isValid() const;
private:
    QPersistentModelIndexData* d;
    /+ friend uint qHash(const QPersistentModelIndex &, uint seed) noexcept; +/
/+ #ifndef QT_NO_DEBUG_STREAM
    friend Q_CORE_EXPORT QDebug operator<<(QDebug, const QPersistentModelIndex &);
#endif +/
}
/+ Q_DECLARE_SHARED(QPersistentModelIndex)

inline uint qHash(const QPersistentModelIndex &index, uint seed) noexcept
{ return qHash(index.d, seed); }


#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QPersistentModelIndex &);
#endif

template<typename T> class QList; +/
alias QModelIndexList = QList!(QModelIndex);

/+ class QMimeData; +/
extern(C++, class) struct QAbstractItemModelPrivate;
extern(C++, class) struct QTransposeProxyModelPrivate;
/+ template <class Key, class T> class QMap; +/


class /+ Q_CORE_EXPORT +/ QAbstractItemModel : QObject
{
    mixin(Q_OBJECT);

    /+ friend class QPersistentModelIndexData; +/
    /+ friend class QAbstractItemViewPrivate; +/
    /+ friend class QIdentityProxyModel; +/
    /+ friend class QTransposeProxyModelPrivate; +/
public:

    /+ explicit +/this(QObject parent = null);
    /+ virtual +/~this();

    @QInvokable final bool hasIndex(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    /+ virtual +/ @QInvokable abstract QModelIndex index(int row, int column,
                                  ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    /+ virtual +/ @QInvokable abstract QModelIndex parent(ref const(QModelIndex) child) const;

    /+ virtual +/ @QInvokable QModelIndex sibling(int row, int column, ref const(QModelIndex) idx) const;
    /+ virtual +/ @QInvokable abstract int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    /+ virtual +/ @QInvokable abstract int columnCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    /+ virtual +/ @QInvokable bool hasChildren(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;

    /+ virtual +/ @QInvokable abstract QVariant data(ref const(QModelIndex) index, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    /+ virtual +/ @QInvokable bool setData(ref const(QModelIndex) index, ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);

    /+ virtual +/ @QInvokable QVariant headerData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation,
                                    int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    /+ virtual +/ bool setHeaderData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, ref const(QVariant) value,
                                   int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);

    mixin(mangleWindows("?itemData@QAbstractItemModel@@UEBA?AV?$QMap@HVQVariant@@@@AEBVQModelIndex@@@Z", q{
    /+ virtual +/ QMap!(int, QVariant) itemData(ref const(QModelIndex) index) const;
    }));
    mixin(mangleWindows("?setItemData@QAbstractItemModel@@UEAA_NAEBVQModelIndex@@AEBV?$QMap@HVQVariant@@@@@Z", q{
    /+ virtual +/ bool setItemData(ref const(QModelIndex) index, ref const(QMap!(int, QVariant)) roles);
    }));
/+ #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    virtual bool clearItemData(const QModelIndex &index);
#endif +/

    /+ virtual +/ QStringList mimeTypes() const;
    /+ virtual +/ QMimeData mimeData(ref const(QModelIndexList) indexes) const;
    mixin(mangleWindows("?canDropMimeData@QAbstractItemModel@@UEBA_NPEBVQMimeData@@W4DropAction@Qt@@HHAEBVQModelIndex@@@Z", q{
    /+ virtual +/ bool canDropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                                     int row, int column, ref const(QModelIndex) parent) const;
    }));
    mixin(mangleWindows("?dropMimeData@QAbstractItemModel@@UEAA_NPEBVQMimeData@@W4DropAction@Qt@@HHAEBVQModelIndex@@@Z", q{
    /+ virtual +/ bool dropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                                  int row, int column, ref const(QModelIndex) parent);
    }));
    /+ virtual +/ /+ Qt:: +/qt.core.namespace.DropActions supportedDropActions() const;

    /+ virtual +/ /+ Qt:: +/qt.core.namespace.DropActions supportedDragActions() const;
/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED void setSupportedDragActions(Qt::DropActions actions)
    { doSetSupportedDragActions(actions); }
#endif +/

    /+ virtual +/ bool insertRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    /+ virtual +/ bool insertColumns(int column, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    /+ virtual +/ bool removeRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    /+ virtual +/ bool removeColumns(int column, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    /+ virtual +/ bool moveRows(ref const(QModelIndex) sourceParent, int sourceRow, int count,
                              ref const(QModelIndex) destinationParent, int destinationChild);
    /+ virtual +/ bool moveColumns(ref const(QModelIndex) sourceParent, int sourceColumn, int count,
                                 ref const(QModelIndex) destinationParent, int destinationChild);

    pragma(inline, true) final bool insertRow(int arow, ref const(QModelIndex) aparent = globalInitVar!QModelIndex)
    { return insertRows(arow, 1, aparent); }
    pragma(inline, true) final bool insertColumn(int acolumn, ref const(QModelIndex) aparent = globalInitVar!QModelIndex)
    { return insertColumns(acolumn, 1, aparent); }
    pragma(inline, true) final bool removeRow(int arow, ref const(QModelIndex) aparent = globalInitVar!QModelIndex)
    { return removeRows(arow, 1, aparent); }
    pragma(inline, true) final bool removeColumn(int acolumn, ref const(QModelIndex) aparent = globalInitVar!QModelIndex)
    { return removeColumns(acolumn, 1, aparent); }
    pragma(inline, true) final bool moveRow(ref const(QModelIndex) sourceParent, int sourceRow,
                            ref const(QModelIndex) destinationParent, int destinationChild)
    { return moveRows(sourceParent, sourceRow, 1, destinationParent, destinationChild); }
    pragma(inline, true) final bool moveColumn(ref const(QModelIndex) sourceParent, int sourceColumn,
                               ref const(QModelIndex) destinationParent, int destinationChild)
    { return moveColumns(sourceParent, sourceColumn, 1, destinationParent, destinationChild); }

    /+ virtual +/ @QInvokable void fetchMore(ref const(QModelIndex) parent);
    /+ virtual +/ @QInvokable bool canFetchMore(ref const(QModelIndex) parent) const;
    /+ virtual +/ @QInvokable /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;
    /+ virtual +/ void sort(int column, /+ Qt:: +/qt.core.namespace.SortOrder order = /+ Qt:: +/qt.core.namespace.SortOrder.AscendingOrder);
    /+ virtual +/ QModelIndex buddy(ref const(QModelIndex) index) const;
    /+ virtual +/ @QInvokable QModelIndexList match(ref const(QModelIndex) start, int role,
                                                  ref const(QVariant) value, int hits = 1,
                                                  /+ Qt:: +/qt.core.namespace.MatchFlags flags =
                                                  /+ Qt:: +/qt.core.namespace.MatchFlags(/+ Qt:: +/qt.core.namespace.MatchFlag.MatchStartsWith|/+ Qt:: +/qt.core.namespace.MatchFlag.MatchWrap)) const;
    /+ virtual +/ QSize span(ref const(QModelIndex) index) const;

    mixin(mangleWindows("?roleNames@QAbstractItemModel@@UEBA?AV?$QHash@HVQByteArray@@@@XZ", q{
    /+ virtual +/ QHash!(int,QByteArray) roleNames() const;
    }));

    /+ using QObject::parent; +/

    enum LayoutChangeHint
    {
        NoLayoutChangeHint,
        VerticalSortHint,
        HorizontalSortHint
    }
    /+ Q_ENUM(LayoutChangeHint) +/

    enum /+ class +/ CheckIndexOption {
        NoOption         = 0x0000,
        IndexIsValid     = 0x0001,
        DoNotUseParent   = 0x0002,
        ParentIsInvalid  = 0x0004,
    }
    /+ Q_ENUM(CheckIndexOption) +/
    /+ Q_DECLARE_FLAGS(CheckIndexOptions, CheckIndexOption) +/
alias CheckIndexOptions = QFlags!(CheckIndexOption);
    /+ Q_REQUIRED_RESULT +/ final bool checkIndex(ref const(QModelIndex) index, CheckIndexOptions options = CheckIndexOption.NoOption) const;

/+ Q_SIGNALS +/public:
    @QSignal final void dataChanged(ref const(QModelIndex) topLeft, ref const(QModelIndex) bottomRight, ref const(QVector!(int)) roles = globalInitVar!(QVector!(int)));
    @QSignal final void headerDataChanged(/+ Qt:: +/qt.core.namespace.Orientation orientation, int first, int last);
    @QSignal final void layoutChanged(ref const(QList!(QPersistentModelIndex)) parents = globalInitVar!(QList!(QPersistentModelIndex)), QAbstractItemModel.LayoutChangeHint hint = QAbstractItemModel.LayoutChangeHint.NoLayoutChangeHint);
    @QSignal final void layoutAboutToBeChanged(ref const(QList!(QPersistentModelIndex)) parents = globalInitVar!(QList!(QPersistentModelIndex)), QAbstractItemModel.LayoutChangeHint hint = QAbstractItemModel.LayoutChangeHint.NoLayoutChangeHint);

    @QSignal final void rowsAboutToBeInserted(ref const(QModelIndex) parent, int first, int last, QPrivateSignal);
    @QSignal final void rowsInserted(ref const(QModelIndex) parent, int first, int last, QPrivateSignal);

    @QSignal final void rowsAboutToBeRemoved(ref const(QModelIndex) parent, int first, int last, QPrivateSignal);
    @QSignal final void rowsRemoved(ref const(QModelIndex) parent, int first, int last, QPrivateSignal);

    @QSignal final void columnsAboutToBeInserted(ref const(QModelIndex) parent, int first, int last, QPrivateSignal);
    @QSignal final void columnsInserted(ref const(QModelIndex) parent, int first, int last, QPrivateSignal);

    @QSignal final void columnsAboutToBeRemoved(ref const(QModelIndex) parent, int first, int last, QPrivateSignal);
    @QSignal final void columnsRemoved(ref const(QModelIndex) parent, int first, int last, QPrivateSignal);

    @QSignal final void modelAboutToBeReset(QPrivateSignal);
    @QSignal final void modelReset(QPrivateSignal);

    @QSignal final void rowsAboutToBeMoved( ref const(QModelIndex) sourceParent, int sourceStart, int sourceEnd, ref const(QModelIndex) destinationParent, int destinationRow, QPrivateSignal);
    @QSignal final void rowsMoved( ref const(QModelIndex) parent, int start, int end, ref const(QModelIndex) destination, int row, QPrivateSignal);

    @QSignal final void columnsAboutToBeMoved( ref const(QModelIndex) sourceParent, int sourceStart, int sourceEnd, ref const(QModelIndex) destinationParent, int destinationColumn, QPrivateSignal);
    @QSignal final void columnsMoved( ref const(QModelIndex) parent, int start, int end, ref const(QModelIndex) destination, int column, QPrivateSignal);

public /+ Q_SLOTS +/:
    /+ virtual +/ @QSlot bool submit();
    /+ virtual +/ @QSlot void revert();

protected /+ Q_SLOTS +/:
/+ #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    virtual
#endif +/
    @QSlot final void resetInternalData();

protected:
    this(ref QAbstractItemModelPrivate dd, QObject parent = null);

    pragma(inline, true) final QModelIndex createIndex(int arow, int acolumn, void* adata = null) const
    { return QModelIndex(arow, acolumn, adata, this); }
    pragma(inline, true) final QModelIndex createIndex(int arow, int acolumn, quintptr aid) const
    { return QModelIndex(arow, acolumn, aid, this); }

    final void encodeData(ref const(QModelIndexList) indexes, ref QDataStream stream) const;
    final bool decodeData(int row, int column, ref const(QModelIndex) parent, ref QDataStream stream);

    final void beginInsertRows(ref const(QModelIndex) parent, int first, int last);
    final void endInsertRows();

    final void beginRemoveRows(ref const(QModelIndex) parent, int first, int last);
    final void endRemoveRows();

    final bool beginMoveRows(ref const(QModelIndex) sourceParent, int sourceFirst, int sourceLast, ref const(QModelIndex) destinationParent, int destinationRow);
    final void endMoveRows();

    final void beginInsertColumns(ref const(QModelIndex) parent, int first, int last);
    final void endInsertColumns();

    final void beginRemoveColumns(ref const(QModelIndex) parent, int first, int last);
    final void endRemoveColumns();

    final bool beginMoveColumns(ref const(QModelIndex) sourceParent, int sourceFirst, int sourceLast, ref const(QModelIndex) destinationParent, int destinationColumn);
    final void endMoveColumns();


/+ #if QT_DEPRECATED_SINCE(5,0)
    QT_DEPRECATED void reset()
    {
        beginResetModel();
        endResetModel();
    }
#endif +/

    final void beginResetModel();
    final void endResetModel();

    final void changePersistentIndex(ref const(QModelIndex) from, ref const(QModelIndex) to);
    final void changePersistentIndexList(ref const(QModelIndexList) from, ref const(QModelIndexList) to);
    final QModelIndexList persistentIndexList() const;

/+ #if QT_DEPRECATED_SINCE(5,0)
    QT_DEPRECATED void setRoleNames(const QHash<int,QByteArray> &theRoleNames)
    {
        doSetRoleNames(theRoleNames);
    }
#endif +/

private:
    final void doSetRoleNames(ref const(QHash!(int,QByteArray)) roleNames);
    final void doSetSupportedDragActions(/+ Qt:: +/qt.core.namespace.DropActions actions);

    /+ Q_DECLARE_PRIVATE(QAbstractItemModel) +/
    /+ Q_DISABLE_COPY(QAbstractItemModel) +/
}
/+pragma(inline, true) QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) operator |(QAbstractItemModel.CheckIndexOptions.enum_type f1, QAbstractItemModel.CheckIndexOptions.enum_type f2)/+noexcept+/{return QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) operator |(QAbstractItemModel.CheckIndexOptions.enum_type f1, QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QAbstractItemModel.CheckIndexOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QAbstractItemModel::CheckIndexOptions) +/
class /+ Q_CORE_EXPORT +/ QAbstractTableModel : QAbstractItemModel
{
    mixin(Q_OBJECT);

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex sibling(int row, int column, ref const(QModelIndex) idx) const;
    override bool dropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                          int row, int column, ref const(QModelIndex) parent);

    override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;

    /+ using QObject::parent; +/

protected:
    this(ref QAbstractItemModelPrivate dd, QObject parent);

/*private:*/
    /+ Q_DISABLE_COPY(QAbstractTableModel) +/
    override QModelIndex parent(ref const(QModelIndex) child) const;
    override bool hasChildren(ref const(QModelIndex) parent) const;
}

class /+ Q_CORE_EXPORT +/ QAbstractListModel : QAbstractItemModel
{
    mixin(Q_OBJECT);

public:
    /+ explicit +/this(QObject parent = null);
    ~this();

    override QModelIndex index(int row, int column = 0, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex sibling(int row, int column, ref const(QModelIndex) idx) const;
    override bool dropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                          int row, int column, ref const(QModelIndex) parent);

    override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;

    /+ using QObject::parent; +/

protected:
    this(ref QAbstractItemModelPrivate dd, QObject parent);

/*private:*/
    /+ Q_DISABLE_COPY(QAbstractListModel) +/
    override QModelIndex parent(ref const(QModelIndex) child) const;
    override int columnCount(ref const(QModelIndex) parent) const;
    override bool hasChildren(ref const(QModelIndex) parent) const;
}

// inline implementations

/+ #if QT_DEPRECATED_SINCE(5, 8)
#endif

inline uint qHash(const QModelIndex &index) noexcept
{ return uint((uint(index.row()) << 4) + index.column() + index.internalId()); }


Q_DECLARE_METATYPE(QModelIndexList) +/

