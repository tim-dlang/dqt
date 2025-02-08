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
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.object;
import qt.core.size;
import qt.core.stringlist;
import qt.core.typeinfo;
import qt.core.variant;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(itemmodel); +/


/// Binding for C++ class [QModelRoleData](https://doc.qt.io/qt-6/qmodelroledata.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct QModelRoleData
{
private:
    int m_role;
    QVariant m_data;

public:
    /+ explicit +/this(int role)/+ noexcept+/
    {
        this.m_role = role;
    }

    int role() const/+ noexcept+/ { return m_role; }
    ref QVariant data()/+ noexcept+/ return { return m_data; }
    ref const(QVariant) data() const/+ noexcept+/ return { return m_data; }

    /+ template <typename T> +/
    /+ constexpr void setData(T &&value) noexcept(noexcept(m_data.setValue(std::forward<T>(value))))
    { m_data.setValue(std::forward<T>(value)); } +/

    void clearData()/+ noexcept+/ { m_data.clear(); }
}

/+ Q_DECLARE_TYPEINFO(QModelRoleData, Q_RELOCATABLE_TYPE); +/


extern(C++, "QtPrivate") {
struct IsContainerCompatibleWithModelRoleDataSpan(T, Enable) {
    /+ std:: +/false_type base0;
    alias base0 this;
}

/+ template <typename T>
struct IsContainerCompatibleWithModelRoleDataSpan<T, std::enable_if_t<std::conjunction_v<
            // lacking concepts and ranges, we accept any T whose std::data yields a suitable pointer ...
            std::is_convertible<decltype( std::data(std::declval<T &>()) ), QModelRoleData *>,
            // ... and that has a suitable size ...
            std::is_convertible<decltype( std::size(std::declval<T &>()) ), qsizetype>,
            // ... and it's a range as it defines an iterator-like API
            std::is_convertible<
                typename std::iterator_traits<decltype( std::begin(std::declval<T &>()) )>::value_type,
                QModelRoleData
            >,
            std::is_convertible<
                decltype( std::begin(std::declval<T &>()) != std::end(std::declval<T &>()) ),
                bool>,
            // Don't make an accidental copy constructor
            std::negation<std::is_same<std::decay_t<T>, QModelRoleDataSpan>>
        >>> : std::true_type {}; +/
} // namespace QtPrivate

/// Binding for C++ class [QModelRoleDataSpan](https://doc.qt.io/qt-6/qmodelroledataspan.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct QModelRoleDataSpan
{
private:
    QModelRoleData* m_modelRoleData = null;
    qsizetype m_len = 0;

    /+ template <typename T> +/
    /+ using if_compatible_container = std::enable_if_t<QtPrivate::IsContainerCompatibleWithModelRoleDataSpan<T>::value, bool>; +/

public:
    @disable this();
    /+this()/+ noexcept+/ {}+/

    this(ref QModelRoleData modelRoleData)/+ noexcept+/
    {
        this.m_modelRoleData = &modelRoleData;
        this.m_len = 1;
    }

    this(QModelRoleData* modelRoleData, qsizetype len)
    {
        this.m_modelRoleData = modelRoleData;
        this.m_len = len;
    }

    /+ template <typename Container, if_compatible_container<Container> = true> +/
    this(Container,)(ref Container c) /+ noexcept(noexcept(std::data(c)) && noexcept(std::size(c))) +/
    {
        this.m_modelRoleData = /+ std:: +/data(c);
        this.m_len = qsizetype(/+ std:: +/size(c));
    }

    qsizetype size() const/+ noexcept+/ { return m_len; }
    qsizetype length() const/+ noexcept+/ { return m_len; }
    QModelRoleData* data() /*const*/ /+ noexcept+/ { return m_modelRoleData; }
    QModelRoleData* begin() /*const*/ /+ noexcept+/ { return m_modelRoleData; }
    QModelRoleData* end() /*const*/ /+ noexcept+/ { return m_modelRoleData + m_len; }
    ref QModelRoleData opIndex(qsizetype index) /*const*/ { return m_modelRoleData[index]; }

/+    QVariant* dataForRole(int role) const
    {
        static if (defined!"__cpp_lib_constexpr_algorithms")
        {
            auto result = /+ std:: +/find_if(begin(), end(), [role](const QModelRoleData &roleData) {
                return roleData.role() == role;
            });
        }
        else
        {
            auto result = begin();
            const e = end();
            for (; result != e; ++result) {
                if (result.role() == role)
                    break;
            }
        }

        return (){ (mixin(Q_ASSERT(q{cast(QModelRoleData*) (result) != QModelRoleDataSpan.end()})));
return &result.data();
}();
    }+/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QModelRoleDataSpan, Q_RELOCATABLE_TYPE); +/


/// Binding for C++ class [QModelIndex](https://doc.qt.io/qt-6/qmodelindex.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct QModelIndex
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
    pragma(inline, true) const(void)* constInternalPointer() const/+ noexcept+/ { return reinterpret_cast!(const(void)*)(i); }
    pragma(inline, true) QModelIndex parent() const
    { return m ? m.parent(this) : QModelIndex(); }
    pragma(inline, true) QModelIndex sibling(int arow, int acolumn) const
    { auto r = m ? (r == arow && c == acolumn) ? this : m.sibling(arow, acolumn, this) : QModelIndex(); return *cast(QModelIndex*)&r; }
    pragma(inline, true) QModelIndex siblingAtColumn(int acolumn) const
    { auto r = m ? (c == acolumn) ? this : m.sibling(r, acolumn, this) : QModelIndex(); return *cast(QModelIndex*)&r; }
    pragma(inline, true) QModelIndex siblingAtRow(int arow) const
    { auto r = m ? (r == arow) ? this : m.sibling(arow, c, this) : QModelIndex(); return *cast(QModelIndex*)&r;  }
    pragma(inline, true) QVariant data(int arole = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const
    { return m ? m.data(this, arole) : QVariant(); }
    pragma(inline, true) void multiData(QModelRoleDataSpan roleDataSpan) const
    { if (m) m.multiData(this, roleDataSpan); }
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
    pragma(inline, true) this(int arow, int acolumn, const(void)* ptr, const(QAbstractItemModel) amodel)/+ noexcept+/
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
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QModelIndex, Q_RELOCATABLE_TYPE);

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QModelIndex &);
#endif +/

extern(C++, class) struct QPersistentModelIndexData;

// qHash is a friend, but we can't use default arguments for friends (§8.3.6.4)
/+ size_t qHash(const QPersistentModelIndex &index, size_t seed = 0) noexcept; +/

/// Binding for C++ class [QPersistentModelIndex](https://doc.qt.io/qt-6/qpersistentmodelindex.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QPersistentModelIndex
{
public:

    this(ref const(QModelIndex) index);
    this(ref const(QPersistentModelIndex) other);
    ~this();
    /+bool operator <(ref const(QPersistentModelIndex) other) const;+/
    /+bool operator ==(ref const(QPersistentModelIndex) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QPersistentModelIndex) other) const
    { return !operator==(other); }+/
    /+ref QPersistentModelIndex operator =(ref const(QPersistentModelIndex) other);+/
    /+ inline QPersistentModelIndex(QPersistentModelIndex &&other) noexcept
        : d(qExchange(other.d, nullptr)) {} +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QPersistentModelIndex) +/
    /+ void swap(QPersistentModelIndex &other) noexcept { qt_ptr_swap(d, other.d); } +/
    /+bool operator ==(ref const(QModelIndex) other) const;+/
    /+bool operator !=(ref const(QModelIndex) other) const;+/
    /+ref QPersistentModelIndex operator =(ref const(QModelIndex) other);+/
    /+auto opCast(T : QModelIndex)() const;+/
    int row() const;
    int column() const;
    void* internalPointer() const;
    const(void)* constInternalPointer() const;
    quintptr internalId() const;
    QModelIndex parent() const;
    QModelIndex sibling(int row, int column) const;
    QVariant data(int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    void multiData(QModelRoleDataSpan roleDataSpan) const;
    /+ Qt:: +/qt.core.namespace.ItemFlags flags() const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    const(QAbstractItemModel) model() const;
    }));
    bool isValid() const;
private:
    QPersistentModelIndexData* d;
    /+ friend size_t qHash(const QPersistentModelIndex &, size_t seed) noexcept; +/
    /+ friend bool qHashEquals(const QPersistentModelIndex &a, const QPersistentModelIndex &b) noexcept
    { return a.d == b.d; } +/
/+ #ifndef QT_NO_DEBUG_STREAM
    friend Q_CORE_EXPORT QDebug operator<<(QDebug, const QPersistentModelIndex &);
#endif +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED(QPersistentModelIndex)

inline size_t qHash(const QPersistentModelIndex &index, size_t seed) noexcept
{ return qHash(index.d, seed); }


#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QPersistentModelIndex &);
#endif +/

alias QModelIndexList = QList!(QModelIndex);

extern(C++, class) struct QAbstractItemModelPrivate;
extern(C++, class) struct QTransposeProxyModelPrivate;


/// Binding for C++ class [QAbstractItemModel](https://doc.qt.io/qt-6/qabstractitemmodel.html).
abstract class /+ Q_CORE_EXPORT +/ QAbstractItemModel : QObject
{
    mixin(Q_OBJECT);

    /+ friend class QPersistentModelIndexData; +/
    /+ friend class QAbstractItemViewPrivate; +/
    /+ friend class QAbstractProxyModel; +/
public:

    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QObject parent = null);
    }));
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

    /+ virtual +/ QMap!(int, QVariant) itemData(ref const(QModelIndex) index) const;
    /+ virtual +/ bool setItemData(ref const(QModelIndex) index, ref const(QMap!(int, QVariant)) roles);
    /+ virtual +/ bool clearItemData(ref const(QModelIndex) index);

    /+ virtual +/ QStringList mimeTypes() const;
    /+ virtual +/ QMimeData mimeData(ref const(QModelIndexList) indexes) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ virtual +/ bool canDropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                                     int row, int column, ref const(QModelIndex) parent) const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    /+ virtual +/ bool dropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                                  int row, int column, ref const(QModelIndex) parent);
    }));
    /+ virtual +/ /+ Qt:: +/qt.core.namespace.DropActions supportedDropActions() const;
    /+ virtual +/ /+ Qt:: +/qt.core.namespace.DropActions supportedDragActions() const;

    /+ Q_REVISION(6, 4) +/ /+ virtual +/ @QInvokable bool insertRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    /+ Q_REVISION(6, 4) +/ /+ virtual +/ @QInvokable bool insertColumns(int column, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    /+ Q_REVISION(6, 4) +/ /+ virtual +/ @QInvokable bool removeRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    /+ Q_REVISION(6, 4) +/ /+ virtual +/ @QInvokable bool removeColumns(int column, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    /+ Q_REVISION(6, 4) +/ /+ virtual +/ @QInvokable bool moveRows(ref const(QModelIndex) sourceParent, int sourceRow, int count,
                              ref const(QModelIndex) destinationParent, int destinationChild);
    /+ Q_REVISION(6, 4) +/ /+ virtual +/ @QInvokable bool moveColumns(ref const(QModelIndex) sourceParent, int sourceColumn, int count,
                                 ref const(QModelIndex) destinationParent, int destinationChild);

    /+ Q_REVISION(6, 4) +/ pragma(inline, true) @QInvokable final bool insertRow(int arow, ref const(QModelIndex) aparent = globalInitVar!QModelIndex)
    { return insertRows(arow, 1, aparent); }
    /+ Q_REVISION(6, 4) +/ pragma(inline, true) @QInvokable final bool insertColumn(int acolumn, ref const(QModelIndex) aparent = globalInitVar!QModelIndex)
    { return insertColumns(acolumn, 1, aparent); }
    /+ Q_REVISION(6, 4) +/ pragma(inline, true) @QInvokable final bool removeRow(int arow, ref const(QModelIndex) aparent = globalInitVar!QModelIndex)
    { return removeRows(arow, 1, aparent); }
    /+ Q_REVISION(6, 4) +/ pragma(inline, true) @QInvokable final bool removeColumn(int acolumn, ref const(QModelIndex) aparent = globalInitVar!QModelIndex)
    { return removeColumns(acolumn, 1, aparent); }
    /+ Q_REVISION(6, 4) +/ pragma(inline, true) @QInvokable final bool moveRow(ref const(QModelIndex) sourceParent, int sourceRow,
                            ref const(QModelIndex) destinationParent, int destinationChild)
    { return moveRows(sourceParent, sourceRow, 1, destinationParent, destinationChild); }
    /+ Q_REVISION(6, 4) +/ pragma(inline, true) @QInvokable final bool moveColumn(ref const(QModelIndex) sourceParent, int sourceColumn,
                               ref const(QModelIndex) destinationParent, int destinationChild)
    { return moveColumns(sourceParent, sourceColumn, 1, destinationParent, destinationChild); }

    /+ virtual +/ @QInvokable void fetchMore(ref const(QModelIndex) parent);
    /+ virtual +/ @QInvokable bool canFetchMore(ref const(QModelIndex) parent) const;
    /+ virtual +/ @QInvokable /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;
    /+ Q_REVISION(6, 4) +/ /+ virtual +/ @QInvokable void sort(int column, /+ Qt:: +/qt.core.namespace.SortOrder order = /+ Qt:: +/qt.core.namespace.SortOrder.AscendingOrder);
    /+ virtual +/ QModelIndex buddy(ref const(QModelIndex) index) const;
    /+ virtual +/ @QInvokable QModelIndexList match(ref const(QModelIndex) start, int role,
                                                  ref const(QVariant) value, int hits = 1,
                                                  /+ Qt:: +/qt.core.namespace.MatchFlags flags =
                                                  /+ Qt:: +/qt.core.namespace.MatchFlags(/+ Qt:: +/qt.core.namespace.MatchFlag.MatchStartsWith|/+ Qt:: +/qt.core.namespace.MatchFlag.MatchWrap)) const;
    /+ virtual +/ QSize span(ref const(QModelIndex) index) const;

    /+ virtual +/ QHash!(int,QByteArray) roleNames() const;

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
    /+ [[nodiscard]] +/ final bool checkIndex(ref const(QModelIndex) index, CheckIndexOptions options = CheckIndexOption.NoOption) const;

    /+ virtual +/ void multiData(ref const(QModelIndex) index, QModelRoleDataSpan roleDataSpan) const;

/+ Q_SIGNALS +/public:
    @QSignal final void dataChanged(ref const(QModelIndex) topLeft, ref const(QModelIndex) bottomRight,
                         ref const(QList!(int)) roles = globalInitVar!(QList!(int)));
    @QSignal final void headerDataChanged(/+ Qt:: +/qt.core.namespace.Orientation orientation, int first, int last);
    @QSignal final void layoutChanged(ref const(QList!(QPersistentModelIndex)) parents = globalInitVar!(QList!(QPersistentModelIndex)), LayoutChangeHint hint = LayoutChangeHint.NoLayoutChangeHint);
    @QSignal final void layoutAboutToBeChanged(ref const(QList!(QPersistentModelIndex)) parents = globalInitVar!(QList!(QPersistentModelIndex)), LayoutChangeHint hint = LayoutChangeHint.NoLayoutChangeHint);

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
    @QSignal final void rowsMoved( ref const(QModelIndex) sourceParent, int sourceStart, int sourceEnd, ref const(QModelIndex) destinationParent, int destinationRow, QPrivateSignal);

    @QSignal final void columnsAboutToBeMoved( ref const(QModelIndex) sourceParent, int sourceStart, int sourceEnd, ref const(QModelIndex) destinationParent, int destinationColumn, QPrivateSignal);
    @QSignal final void columnsMoved( ref const(QModelIndex) sourceParent, int sourceStart, int sourceEnd, ref const(QModelIndex) destinationParent, int destinationColumn, QPrivateSignal);

public /+ Q_SLOTS +/:
    /+ virtual +/ @QSlot bool submit();
    /+ virtual +/ @QSlot void revert();

protected /+ Q_SLOTS +/:
    /+ virtual +/ @QSlot void resetInternalData();

protected:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QAbstractItemModelPrivate dd, QObject parent = null);
    }));

    pragma(inline, true) final QModelIndex createIndex(int arow, int acolumn, const(void)* adata = null) const
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

    final void beginResetModel();
    final void endResetModel();

    final void changePersistentIndex(ref const(QModelIndex) from, ref const(QModelIndex) to);
    final void changePersistentIndexList(ref const(QModelIndexList) from, ref const(QModelIndexList) to);
    final QModelIndexList persistentIndexList() const;

private:
    /+ Q_DECLARE_PRIVATE(QAbstractItemModel) +/
    /+ Q_DISABLE_COPY(QAbstractItemModel) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) operator |(QAbstractItemModel.CheckIndexOptions.enum_type f1, QAbstractItemModel.CheckIndexOptions.enum_type f2)/+noexcept+/{return QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) operator |(QAbstractItemModel.CheckIndexOptions.enum_type f1, QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) operator &(QAbstractItemModel.CheckIndexOptions.enum_type f1, QAbstractItemModel.CheckIndexOptions.enum_type f2)/+noexcept+/{return QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) operator &(QAbstractItemModel.CheckIndexOptions.enum_type f1, QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) operator ^(QAbstractItemModel.CheckIndexOptions.enum_type f1, QAbstractItemModel.CheckIndexOptions.enum_type f2)/+noexcept+/{return QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) operator ^(QAbstractItemModel.CheckIndexOptions.enum_type f1, QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QAbstractItemModel.CheckIndexOptions.enum_type f1, QAbstractItemModel.CheckIndexOptions.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QAbstractItemModel.CheckIndexOptions.enum_type f1, QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QAbstractItemModel.CheckIndexOptions.enum_type f1, QAbstractItemModel.CheckIndexOptions.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QAbstractItemModel.CheckIndexOptions.enum_type f1, QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QAbstractItemModel.CheckIndexOptions.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QAbstractItemModel.CheckIndexOptions.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QAbstractItemModel.CheckIndexOptions.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QAbstractItemModel.CheckIndexOptions.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QAbstractItemModel.CheckIndexOptions.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QAbstractItemModel.CheckIndexOptions operator ~(QAbstractItemModel.CheckIndexOptions.enum_type e)/+noexcept+/{return~QAbstractItemModel.CheckIndexOptions(e);}+/
/+pragma(inline, true) void operator |(QAbstractItemModel.CheckIndexOptions.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QAbstractItemModel.CheckIndexOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QAbstractItemModel::CheckIndexOptions) +/
/// Binding for C++ class [QAbstractTableModel](https://doc.qt.io/qt-6/qabstracttablemodel.html).
abstract class /+ Q_CORE_EXPORT +/ QAbstractTableModel : QAbstractItemModel
{
    mixin(Q_OBJECT);

public:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QObject parent = null);
    }));
    ~this();

    override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex sibling(int row, int column, ref const(QModelIndex) idx) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    override bool dropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                          int row, int column, ref const(QModelIndex) parent);
    }));

    override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;

    /+ using QObject::parent; +/

protected:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QAbstractItemModelPrivate dd, QObject parent);
    }));

private:
    /+ Q_DISABLE_COPY(QAbstractTableModel) +/
    mixin(changeWindowsMangling(q{mangleChangeAccess("private")}, q{
    protected override QModelIndex parent(ref const(QModelIndex) child) const;
    }));
    mixin(changeWindowsMangling(q{mangleChangeAccess("private")}, q{
    protected override bool hasChildren(ref const(QModelIndex) parent) const;
    }));
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QAbstractListModel](https://doc.qt.io/qt-6/qabstractlistmodel.html).
abstract class /+ Q_CORE_EXPORT +/ QAbstractListModel : QAbstractItemModel
{
    mixin(Q_OBJECT);

public:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QObject parent = null);
    }));
    ~this();

    override QModelIndex index(int row, int column = 0, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex sibling(int row, int column, ref const(QModelIndex) idx) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    override bool dropMimeData(const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action,
                          int row, int column, ref const(QModelIndex) parent);
    }));

    override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;

    /+ using QObject::parent; +/

protected:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QAbstractItemModelPrivate dd, QObject parent);
    }));

private:
    /+ Q_DISABLE_COPY(QAbstractListModel) +/
    mixin(changeWindowsMangling(q{mangleChangeAccess("private")}, q{
    protected override QModelIndex parent(ref const(QModelIndex) child) const;
    }));
    mixin(changeWindowsMangling(q{mangleChangeAccess("private")}, q{
    protected override int columnCount(ref const(QModelIndex) parent) const;
    }));
    mixin(changeWindowsMangling(q{mangleChangeAccess("private")}, q{
    protected override bool hasChildren(ref const(QModelIndex) parent) const;
    }));
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

// inline implementations

/+ inline size_t qHash(const QModelIndex &index, size_t seed = 0) noexcept
{ return size_t((size_t(index.row()) << 4) + size_t(index.column()) + index.internalId()) ^ seed; }


QT_DECL_METATYPE_EXTERN(QModelIndexList, Q_CORE_EXPORT) +/

