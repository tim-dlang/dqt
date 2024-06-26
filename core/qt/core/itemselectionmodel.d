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
module qt.core.itemselectionmodel;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.flags;
import qt.core.list;
import qt.core.metatype;
import qt.core.object;
import qt.core.typeinfo;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(itemmodel); +/


/// Binding for C++ class [QItemSelectionRange](https://doc.qt.io/qt-5/qitemselectionrange.html).
@Q_DECLARE_METATYPE @Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QItemSelectionRange
{

public:
/+ #if QT_VERSION < QT_VERSION_CHECK(6,0,0) +/
    // ### Qt 6: remove them all, the compiler-generated ones are fine
    @disable this(this);
    pragma(inline, true) this(ref const(QItemSelectionRange) other)
    {
        this.tl = other.tl;
        this.br = other.br;
    }
    /+ QItemSelectionRange(QItemSelectionRange &&other) noexcept
        : tl(std::move(other.tl)), br(std::move(other.br)) {} +/
    /+ QItemSelectionRange &operator=(QItemSelectionRange &&other) noexcept
    { tl = std::move(other.tl); br = std::move(other.br); return *this; } +/
    /+ref QItemSelectionRange operator =(ref const(QItemSelectionRange) other)
    { tl = other.tl; br = other.br; return this; }+/
/+ #endif +/ // Qt < 6
    this(ref const(QModelIndex) topL, ref const(QModelIndex) bottomR)
    {
        this.tl = topL;
        this.br = bottomR;
    }
    /+ explicit +/this(ref const(QModelIndex) index)
    {
        this.tl = index;
        this.br = tl;
    }

    /+ void swap(QItemSelectionRange &other) noexcept
    {
        qSwap(tl, other.tl);
        qSwap(br, other.br);
    } +/

    pragma(inline, true) int top() const { return tl.row(); }
    pragma(inline, true) int left() const { return tl.column(); }
    pragma(inline, true) int bottom() const { return br.row(); }
    pragma(inline, true) int right() const { return br.column(); }
    pragma(inline, true) int width() const { return br.column() - tl.column() + 1; }
    pragma(inline, true) int height() const { return br.row() - tl.row() + 1; }

    pragma(inline, true) ref const(QPersistentModelIndex) topLeft() const return { return tl; }
    pragma(inline, true) ref const(QPersistentModelIndex) bottomRight() const return { return br; }
    pragma(inline, true) QModelIndex parent() const { return tl.parent(); }
    pragma(inline, true) const(QAbstractItemModel) model() const { return tl.model(); }

    pragma(inline, true) bool contains(ref const(QModelIndex) index) const
    {
        return (parent() == index.parent()
                && tl.row() <= index.row() && tl.column() <= index.column()
                && br.row() >= index.row() && br.column() >= index.column());
    }

    pragma(inline, true) bool contains(int row, int column, ref const(QModelIndex) parentIndex) const
    {
        return (parent() == parentIndex
                && tl.row() <= row && tl.column() <= column
                && br.row() >= row && br.column() >= column);
    }

    bool intersects(ref const(QItemSelectionRange) other) const;
/+ #if QT_DEPRECATED_SINCE(5, 0)
    inline QItemSelectionRange intersect(const QItemSelectionRange &other) const
        { return intersected(other); }
#endif +/
    QItemSelectionRange intersected(ref const(QItemSelectionRange) other) const;


    /+pragma(inline, true) bool operator ==(ref const(QItemSelectionRange) other) const
        { return (tl == other.tl && br == other.br); }+/
    /+pragma(inline, true) bool operator !=(ref const(QItemSelectionRange) other) const
        { return !operator==(other); }+/
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+/+ QT_DEPRECATED +/ bool operator <(ref const(QItemSelectionRange) other) const;+/
/+ #endif +/

    pragma(inline, true) bool isValid() const
    {
        return (tl.isValid() && br.isValid() && tl.parent() == br.parent()
                && top() <= bottom() && left() <= right());
    }

    bool isEmpty() const;

    QModelIndexList indexes() const;

private:
    QPersistentModelIndex tl; QPersistentModelIndex br;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QItemSelectionRange, Q_MOVABLE_TYPE); +/

extern(C++, class) struct QItemSelectionModelPrivate;

/// Binding for C++ class [QItemSelectionModel](https://doc.qt.io/qt-5/qitemselectionmodel.html).
class /+ Q_CORE_EXPORT +/ QItemSelectionModel : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QAbstractItemModel *model READ model WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(bool hasSelection READ hasSelection NOTIFY selectionChanged STORED false DESIGNABLE false)
    Q_PROPERTY(QModelIndex currentIndex READ currentIndex NOTIFY currentChanged STORED false DESIGNABLE false)
    Q_PROPERTY(QItemSelection selection READ selection NOTIFY selectionChanged STORED false DESIGNABLE false)
    Q_PROPERTY(QModelIndexList selectedIndexes READ selectedIndexes NOTIFY selectionChanged STORED false DESIGNABLE false)

    Q_DECLARE_PRIVATE(QItemSelectionModel) +/

public:

    enum SelectionFlag {
        NoUpdate       = 0x0000,
        Clear          = 0x0001,
        Select         = 0x0002,
        Deselect       = 0x0004,
        Toggle         = 0x0008,
        Current        = 0x0010,
        Rows           = 0x0020,
        Columns        = 0x0040,
        SelectCurrent  = SelectionFlag.Select | SelectionFlag.Current,
        ToggleCurrent  = SelectionFlag.Toggle | SelectionFlag.Current,
        ClearAndSelect = SelectionFlag.Clear | SelectionFlag.Select
    }

    /+ Q_DECLARE_FLAGS(SelectionFlags, SelectionFlag) +/
alias SelectionFlags = QFlags!(SelectionFlag);    /+ Q_FLAG(SelectionFlags) +/

    /+ explicit +/this(QAbstractItemModel model = null);
    /+ explicit +/this(QAbstractItemModel model, QObject parent);
    /+ virtual +/~this();

    final QModelIndex currentIndex() const;

    @QInvokable final bool isSelected(ref const(QModelIndex) index) const;
    @QInvokable final bool isRowSelected(int row, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    @QInvokable final bool isColumnSelected(int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;

    @QInvokable final bool rowIntersectsSelection(int row, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    @QInvokable final bool columnIntersectsSelection(int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;

    final bool hasSelection() const;

    final QModelIndexList selectedIndexes() const;
    @QInvokable final QModelIndexList selectedRows(int column = 0) const;
    @QInvokable final QModelIndexList selectedColumns(int row = 0) const;
    mixin(mangleWindows("?selection@QItemSelectionModel@@QEBA?BVQItemSelection@@XZ", q{
    final const(QItemSelection) selection() const;
    }));

    // ### Qt 6: Merge these two as "QAbstractItemModel *model() const"
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final const(QAbstractItemModel) model() const;
    }));
    final QAbstractItemModel model();

    final void setModel(QAbstractItemModel model);

public /+ Q_SLOTS +/:
    /+ virtual +/ @QSlot void setCurrentIndex(ref const(QModelIndex) index, SelectionFlags command);
    /+ virtual +/ @QSlot void select(ref const(QModelIndex) index, SelectionFlags command);
    /+ virtual +/ @QSlot void select(ref const(QItemSelection) selection, SelectionFlags command);
    /+ virtual +/ @QSlot void clear();
    /+ virtual +/ @QSlot void reset();

    @QSlot final void clearSelection();
    /+ virtual +/ @QSlot void clearCurrentIndex();

/+ Q_SIGNALS +/public:
    @QSignal final void selectionChanged(ref const(QItemSelection) selected, ref const(QItemSelection) deselected);
    @QSignal final void currentChanged(ref const(QModelIndex) current, ref const(QModelIndex) previous);
    @QSignal final void currentRowChanged(ref const(QModelIndex) current, ref const(QModelIndex) previous);
    @QSignal final void currentColumnChanged(ref const(QModelIndex) current, ref const(QModelIndex) previous);
    @QSignal final void modelChanged(QAbstractItemModel model);

protected:
    this(ref QItemSelectionModelPrivate dd, QAbstractItemModel model);
    final void emitSelectionChanged(ref const(QItemSelection) newSelection, ref const(QItemSelection) oldSelection);

private:
    /+ Q_DISABLE_COPY(QItemSelectionModel) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_columnsAboutToBeRemoved(const QModelIndex&, int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_rowsAboutToBeRemoved(const QModelIndex&, int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_columnsAboutToBeInserted(const QModelIndex&, int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_rowsAboutToBeInserted(const QModelIndex&, int, int))
    Q_PRIVATE_SLOT(d_func(), void _q_layoutAboutToBeChanged(const QList<QPersistentModelIndex> &parents = QList<QPersistentModelIndex>(), QAbstractItemModel::LayoutChangeHint hint = QAbstractItemModel::NoHint))
    Q_PRIVATE_SLOT(d_func(), void _q_layoutChanged(const QList<QPersistentModelIndex> &parents = QList<QPersistentModelIndex>(), QAbstractItemModel::LayoutChangeHint hint = QAbstractItemModel::NoHint)) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QItemSelectionModel.SelectionFlags.enum_type) operator |(QItemSelectionModel.SelectionFlags.enum_type f1, QItemSelectionModel.SelectionFlags.enum_type f2)/+noexcept+/{return QFlags!(QItemSelectionModel.SelectionFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QItemSelectionModel.SelectionFlags.enum_type) operator |(QItemSelectionModel.SelectionFlags.enum_type f1, QFlags!(QItemSelectionModel.SelectionFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QItemSelectionModel.SelectionFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QItemSelectionModel::SelectionFlags)
// dummy implentation of qHash() necessary for instantiating QList<QItemSelectionRange>::toSet() with MSVC
inline uint qHash(const QItemSelectionRange &) { return 0; }

#ifdef Q_CC_MSVC

/*
   ### Qt 6:
   ### This needs to be removed for next releases of Qt. It is a workaround for vc++ because
   ### Qt exports QItemSelection that inherits QList<QItemSelectionRange>.
*/

# ifndef Q_TEMPLATE_EXTERN
#  if defined(QT_BUILD_CORE_LIB)
#   define Q_TEMPLATE_EXTERN
#  else
#   define Q_TEMPLATE_EXTERN extern
#  endif
# endif
Q_TEMPLATE_EXTERN template class Q_CORE_EXPORT QList<QItemSelectionRange>;
#endif +/ // Q_CC_MSVC

/// Binding for C++ class [QItemSelection](https://doc.qt.io/qt-5/qitemselection.html).
@Q_DECLARE_METATYPE @Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QItemSelection
{
    public QList!(QItemSelectionRange) base0;
    alias base0 this;
public:
    @disable this();
    /+this()/+ noexcept+/
    {
        this.QList!(QItemSelectionRange) = typeof(this.QList!(QItemSelectionRange))();
    }+/
    this(ref const(QModelIndex) topLeft, ref const(QModelIndex) bottomRight);

    // reusing QList::swap() here is OK!

    void select(ref const(QModelIndex) topLeft, ref const(QModelIndex) bottomRight);
    bool contains(ref const(QModelIndex) index) const;
    QModelIndexList indexes() const;
    void merge(ref const(QItemSelection) other, QItemSelectionModel.SelectionFlags command);
    static void split(ref const(QItemSelectionRange) range,
                          ref const(QItemSelectionRange) other,
                          QItemSelection* result);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED_NOT_MOVABLE_UNTIL_QT6(QItemSelection)

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QItemSelectionRange &);
#endif


Q_DECLARE_METATYPE(QItemSelectionRange)
Q_DECLARE_METATYPE(QItemSelection) +/

