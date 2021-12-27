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
module qt.gui.standarditemmodel;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.bytearray;
import qt.core.hash;
import qt.core.list;
import qt.core.map;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.object;
import qt.core.scopedpointer;
import qt.core.size;
import qt.core.string;
import qt.core.stringlist;
import qt.core.variant;
import qt.gui.brush;
import qt.gui.font;
import qt.gui.icon;
import qt.helpers;
version(QT_NO_DATASTREAM){}else
    import qt.core.datastream;

/+ #ifndef QT_NO_DATASTREAM
#endif

QT_REQUIRE_CONFIG(standarditemmodel); +/




extern(C++, class) struct QStandardItemPrivate;
/// Binding for C++ class [QStandardItem](https://doc.qt.io/qt-5/qstandarditem.html).
class /+ Q_GUI_EXPORT +/ QStandardItem
{
public:
    this();
    /+ explicit +/this(ref const(QString) text);
    this(ref const(QIcon) icon, ref const(QString) text);
    /+ explicit +/this(int rows, int columns = 1);
    /+ virtual +/~this();

    /+ virtual +/ QVariant data(int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole + 1) const;
    /+ virtual +/ void setData(ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole + 1);
    /+ virtual +/ void setData(T)(T value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole + 1)
    {
        static if(is(const(T) == const(QVariant)))
            QVariant v = value;
        else
            QVariant v = QVariant.fromValue(value);
        setData(v, role);
    }
    final void clearData();

    pragma(inline, true) final QString text() const {
        return qvariant_cast!(QString)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole));
    }
    pragma(inline, true) final void setText(ref const(QString) atext)
    { setData(atext, /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole); }
    pragma(inline, true) final void setText(const(QString) atext)
    { setText(atext); }

    pragma(inline, true) final QIcon icon() const {
        return qvariant_cast!(QIcon)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.DecorationRole));
    }
    pragma(inline, true) final void setIcon(ref const(QIcon) aicon)
    { setData(aicon, /+ Qt:: +/qt.core.namespace.ItemDataRole.DecorationRole); }

/+ #ifndef QT_NO_TOOLTIP +/
    version(QT_NO_TOOLTIP){}else
    {
        pragma(inline, true) final QString toolTip() const {
            return qvariant_cast!(QString)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.ToolTipRole));
        }
        pragma(inline, true) final void setToolTip(ref const(QString) atoolTip)
        { setData(atoolTip, /+ Qt:: +/qt.core.namespace.ItemDataRole.ToolTipRole); }
    }
/+ #endif

#ifndef QT_NO_STATUSTIP +/
    version(QT_NO_STATUSTIP){}else
    {
        pragma(inline, true) final QString statusTip() const {
            return qvariant_cast!(QString)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.StatusTipRole));
        }
        pragma(inline, true) final void setStatusTip(ref const(QString) astatusTip)
        { setData(astatusTip, /+ Qt:: +/qt.core.namespace.ItemDataRole.StatusTipRole); }
    }
/+ #endif

#if QT_CONFIG(whatsthis) +/
    pragma(inline, true) final QString whatsThis() const {
        return qvariant_cast!(QString)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.WhatsThisRole));
    }
    pragma(inline, true) final void setWhatsThis(ref const(QString) awhatsThis)
    { setData(awhatsThis, /+ Qt:: +/qt.core.namespace.ItemDataRole.WhatsThisRole); }
/+ #endif +/

    pragma(inline, true) final QSize sizeHint() const {
        return qvariant_cast!(QSize)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.SizeHintRole));
    }
    pragma(inline, true) final void setSizeHint(ref const(QSize) asizeHint)
    { setData(asizeHint, /+ Qt:: +/qt.core.namespace.ItemDataRole.SizeHintRole); }

    pragma(inline, true) final QFont font() const {
        return qvariant_cast!(QFont)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.FontRole));
    }
    pragma(inline, true) final void setFont(ref const(QFont) afont)
    { setData(afont, /+ Qt:: +/qt.core.namespace.ItemDataRole.FontRole); }

/+    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.Alignment textAlignment() const {
        return /+ Qt:: +/qt.core.namespace.Alignment(qvariant_cast!(int)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.TextAlignmentRole)));
    }
    pragma(inline, true) final void setTextAlignment(/+ Qt:: +/qt.core.namespace.Alignment atextAlignment)
    { auto tmp = const(QVariant)(cast(int)(atextAlignment)); setData(tmp, /+ Qt:: +/qt.core.namespace.ItemDataRole.TextAlignmentRole); }+/

    pragma(inline, true) final QBrush background() const {
        return qvariant_cast!(QBrush)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole));
    }
    pragma(inline, true) final void setBackground(ref const(QBrush) abrush)
    { setData(abrush, /+ Qt:: +/qt.core.namespace.ItemDataRole.BackgroundRole); }

    pragma(inline, true) final QBrush foreground() const {
        return qvariant_cast!(QBrush)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole));
    }
    pragma(inline, true) final void setForeground(ref const(QBrush) abrush)
    { setData(abrush, /+ Qt:: +/qt.core.namespace.ItemDataRole.ForegroundRole); }

/+    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.CheckState checkState() const {
        return /+ Qt:: +/qt.core.namespace.CheckState(qvariant_cast!(int)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.CheckStateRole)));
    }
    pragma(inline, true) final void setCheckState(/+ Qt:: +/qt.core.namespace.CheckState acheckState)
    { setData(acheckState, /+ Qt:: +/qt.core.namespace.ItemDataRole.CheckStateRole); }+/

    pragma(inline, true) final QString accessibleText() const {
        return qvariant_cast!(QString)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.AccessibleTextRole));
    }
    pragma(inline, true) final void setAccessibleText(ref const(QString) aaccessibleText)
    { setData(aaccessibleText, /+ Qt:: +/qt.core.namespace.ItemDataRole.AccessibleTextRole); }

    pragma(inline, true) final QString accessibleDescription() const {
        return qvariant_cast!(QString)(data(/+ Qt:: +/qt.core.namespace.ItemDataRole.AccessibleDescriptionRole));
    }
    pragma(inline, true) final void setAccessibleDescription(ref const(QString) aaccessibleDescription)
    { setData(aaccessibleDescription, /+ Qt:: +/qt.core.namespace.ItemDataRole.AccessibleDescriptionRole); }

    final /+ Qt:: +/qt.core.namespace.ItemFlags flags() const;
    final void setFlags(/+ Qt:: +/qt.core.namespace.ItemFlags flags);

/+    pragma(inline, true) final bool isEnabled() const {
        return (flags() & /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsEnabled) != 0;
    }
    final void setEnabled(bool enabled);

    pragma(inline, true) final bool isEditable() const {
        return (flags() & /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsEditable) != 0;
    }
    final void setEditable(bool editable);

    pragma(inline, true) final bool isSelectable() const {
        return (flags() & /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsSelectable) != 0;
    }
    final void setSelectable(bool selectable);

    pragma(inline, true) final bool isCheckable() const {
        return (flags() & /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsUserCheckable) != 0;
    }
    final void setCheckable(bool checkable);

    pragma(inline, true) final bool isAutoTristate() const {
        return (flags() & /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsAutoTristate) != 0;
    }
    final void setAutoTristate(bool tristate);

    pragma(inline, true) final bool isUserTristate() const {
        return (flags() & /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsUserTristate) != 0;
    }
    final void setUserTristate(bool tristate);

/+ #if QT_DEPRECATED_SINCE(5, 6) +/
    /+ QT_DEPRECATED +/ final bool isTristate() const { return isAutoTristate(); }
    /+ QT_DEPRECATED +/ final void setTristate(bool tristate);
/+ #endif

#if QT_CONFIG(draganddrop) +/
    pragma(inline, true) final bool isDragEnabled() const {
        return (flags() & /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsDragEnabled) != 0;
    }
    final void setDragEnabled(bool dragEnabled);

    pragma(inline, true) final bool isDropEnabled() const {
        return (flags() & /+ Qt:: +/qt.core.namespace.ItemFlag.ItemIsDropEnabled) != 0;
    }
    final void setDropEnabled(bool dropEnabled);+/
/+ #endif +/ // QT_CONFIG(draganddrop)

    final QStandardItem parent() const;
    final int row() const;
    final int column() const;
    final QModelIndex index() const;
    final QStandardItemModel model() const;

    final int rowCount() const;
    final void setRowCount(int rows);
    final int columnCount() const;
    final void setColumnCount(int columns);

    final bool hasChildren() const;
    final QStandardItem child(int row, int column = 0) const;
    final void setChild(int row, int column, QStandardItem item);
    pragma(inline, true) final void setChild(int arow, QStandardItem aitem)
    { setChild(arow, 0, aitem); }

    final void insertRow(int row, ref const(QList!(QStandardItem)) items);
    final void insertColumn(int column, ref const(QList!(QStandardItem)) items);
    final void insertRows(int row, ref const(QList!(QStandardItem)) items);
    final void insertRows(int row, int count);
    final void insertColumns(int column, int count);

    final void removeRow(int row);
    final void removeColumn(int column);
    final void removeRows(int row, int count);
    final void removeColumns(int column, int count);

    pragma(inline, true) final void appendRow(ref const(QList!(QStandardItem)) aitems)
    { insertRow(rowCount(), aitems); }
    pragma(inline, true) final void appendRows(ref const(QList!(QStandardItem)) aitems)
    { insertRows(rowCount(), aitems); }
    pragma(inline, true) final void appendColumn(ref const(QList!(QStandardItem)) aitems)
    { insertColumn(columnCount(), aitems); }
/+    pragma(inline, true) final void insertRow(int arow, QStandardItem aitem)
    { insertRow(arow, cast(QStandardItem)(QList!(QStandardItem)() << aitem)); }
    pragma(inline, true) final void appendRow(QStandardItem aitem)
    { insertRow(rowCount(), aitem); }
+/

    final QStandardItem takeChild(int row, int column = 0);
    final QList!(QStandardItem) takeRow(int row);
    final QList!(QStandardItem) takeColumn(int column);

    final void sortChildren(int column, /+ Qt:: +/qt.core.namespace.SortOrder order = /+ Qt:: +/qt.core.namespace.SortOrder.AscendingOrder);

    /+ virtual +/ QStandardItem clone() const;

    enum ItemType { Type = 0, UserType = 1000 }
    /+ virtual +/ int type() const;

    version(QT_NO_DATASTREAM){}else
    {
        /+ virtual +/ void read(ref QDataStream in_);
        /+ virtual +/ void write(ref QDataStream out_) const;
    }
    pragma(mangle, mangleOpLess("QStandardItem"))
    bool opLess(const QStandardItem other) const;

protected:
    /+ QStandardItem(const QStandardItem &other); +/
    this(ref QStandardItemPrivate dd);
    /+ QStandardItem &operator=(const QStandardItem &other); +/
    QScopedPointer!(QStandardItemPrivate) d_ptr;

    final void emitDataChanged();

private:
    /+ Q_DECLARE_PRIVATE(QStandardItem) +/
    /+ friend class QStandardItemModelPrivate; +/
    /+ friend class QStandardItemModel; +/
}

/+ #ifndef QT_NO_TOOLTIP
#endif

#ifndef QT_NO_STATUSTIP
#endif

#if QT_CONFIG(whatsthis)
#endif +/

extern(C++, class) struct QStandardItemModelPrivate;

/// Binding for C++ class [QStandardItemModel](https://doc.qt.io/qt-5/qstandarditemmodel.html).
class /+ Q_GUI_EXPORT +/ QStandardItemModel : QAbstractItemModel
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(int sortRole READ sortRole WRITE setSortRole) +/

public:
    /+ explicit +/this(QObject parent = null);
    this(int rows, int columns, QObject parent = null);
    ~this();

    final void setItemRoleNames(ref const(QHash!(int,QByteArray)) roleNames);

    override QModelIndex index(int row, int column, ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override QModelIndex parent(ref const(QModelIndex) child) const;

    override int rowCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override int columnCount(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    override bool hasChildren(ref const(QModelIndex) parent = globalInitVar!QModelIndex) const;
    // Qt 6: Remove
    override QModelIndex sibling(int row, int column, ref const(QModelIndex) idx) const;

    override QVariant data(ref const(QModelIndex) index, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override bool setData(ref const(QModelIndex) index, ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);
    // Qt 6: add override keyword
    final bool clearItemData(ref const(QModelIndex) index);

    override QVariant headerData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation,
                            int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole) const;
    override bool setHeaderData(int section, /+ Qt:: +/qt.core.namespace.Orientation orientation, ref const(QVariant) value,
                           int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.EditRole);

    override bool insertRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool insertColumns(int column, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool removeRows(int row, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);
    override bool removeColumns(int column, int count, ref const(QModelIndex) parent = globalInitVar!QModelIndex);

    override /+ Qt:: +/qt.core.namespace.ItemFlags flags(ref const(QModelIndex) index) const;
    override /+ Qt:: +/qt.core.namespace.DropActions supportedDropActions() const;

    override QMap!(int, QVariant) itemData(ref const(QModelIndex) index) const;
    override bool setItemData(ref const(QModelIndex) index, ref const(QMap!(int, QVariant)) roles);

    final void clear();

    /+ using QObject::parent; +/

    override void sort(int column, /+ Qt:: +/qt.core.namespace.SortOrder order = /+ Qt:: +/qt.core.namespace.SortOrder.AscendingOrder);

    final QStandardItem itemFromIndex(ref const(QModelIndex) index) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QModelIndex indexFromItem(const(QStandardItem) item) const;
    }));

    final QStandardItem item(int row, int column = 0) const;
    final void setItem(int row, int column, QStandardItem item);
    pragma(inline, true) final void setItem(int arow, QStandardItem aitem)
    { setItem(arow, 0, aitem); }
    final QStandardItem invisibleRootItem() const;

    final QStandardItem horizontalHeaderItem(int column) const;
    final void setHorizontalHeaderItem(int column, QStandardItem item);
    final QStandardItem verticalHeaderItem(int row) const;
    final void setVerticalHeaderItem(int row, QStandardItem item);

    final void setHorizontalHeaderLabels(ref const(QStringList) labels);
    final void setVerticalHeaderLabels(ref const(QStringList) labels);

    final void setRowCount(int rows);
    final void setColumnCount(int columns);

    final void appendRow(ref const(QList!(QStandardItem)) items);
    final void appendColumn(ref const(QList!(QStandardItem)) items);
/+    pragma(inline, true) final void appendRow(QStandardItem aitem)
    { appendRow(cast(QStandardItem)(QList!(QStandardItem)() << aitem)); }
+/

    final void insertRow(int row, ref const(QList!(QStandardItem)) items);
    final void insertColumn(int column, ref const(QList!(QStandardItem)) items);
/+    pragma(inline, true) final void insertRow(int arow, QStandardItem aitem)
    { insertRow(arow, cast(QStandardItem)(QList!(QStandardItem)() << aitem)); }
+/

/+    pragma(inline, true) final bool insertRow(int arow, ref const(QModelIndex) aparent = globalInitVar!QModelIndex)
    { return QAbstractItemModel.insertRow(arow, aparent); }
    pragma(inline, true) final bool insertColumn(int acolumn, ref const(QModelIndex) aparent = globalInitVar!QModelIndex)
    { return QAbstractItemModel.insertColumn(acolumn, aparent); }+/

    final QStandardItem takeItem(int row, int column = 0);
    final QList!(QStandardItem) takeRow(int row);
    final QList!(QStandardItem) takeColumn(int column);

    final QStandardItem takeHorizontalHeaderItem(int column);
    final QStandardItem takeVerticalHeaderItem(int row);

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final const(QStandardItem) itemPrototype() const;
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final void setItemPrototype(const(QStandardItem) item);
    }));

    final QList!(QStandardItem) findItems(ref const(QString) text,
                                        /+ Qt:: +/qt.core.namespace.MatchFlags flags = /+ Qt:: +/qt.core.namespace.MatchFlag.MatchExactly,
                                        int column = 0) const;

    final int sortRole() const;
    final void setSortRole(int role);

    override QStringList mimeTypes() const;
    override QMimeData mimeData(ref const(QModelIndexList) indexes) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    override bool dropMimeData (const(QMimeData) data, /+ Qt:: +/qt.core.namespace.DropAction action, int row, int column, ref const(QModelIndex) parent);
    }));

/+ Q_SIGNALS +/public:
    // ### Qt 6: add changed roles
    @QSignal final void itemChanged(QStandardItem item);

protected:
    this(ref QStandardItemModelPrivate dd, QObject parent = null);

private:
    /+ friend class QStandardItemPrivate; +/
    /+ friend class QStandardItem; +/
    /+ Q_DISABLE_COPY(QStandardItemModel) +/
    /+ Q_DECLARE_PRIVATE(QStandardItemModel) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_emitItemChanged(const QModelIndex &topLeft,
                                                     const QModelIndex &bottomRight)) +/
}

/+ #ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &in, QStandardItem &item);
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &out, const QStandardItem &item);
#endif +/

