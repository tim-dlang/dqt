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
module qt.widgets.combobox;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.size;
import qt.core.string;
import qt.core.stringlist;
import qt.core.variant;
import qt.gui.event;
import qt.gui.icon;
import qt.helpers;
import qt.widgets.abstractitemdelegate;
import qt.widgets.abstractitemview;
import qt.widgets.completer;
import qt.widgets.lineedit;
import qt.widgets.styleoption;
import qt.widgets.widget;
version(QT_NO_VALIDATOR){}else
    import qt.gui.validator;

/+ QT_REQUIRE_CONFIG(combobox); +/


extern(C++, class) struct QComboBoxPrivate;

/// Binding for C++ class [QComboBox](https://doc.qt.io/qt-6/qcombobox.html).
class /+ Q_WIDGETS_EXPORT +/ QComboBox : QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(bool editable READ isEditable WRITE setEditable)
    Q_PROPERTY(int count READ count)
    Q_PROPERTY(QString currentText READ currentText WRITE setCurrentText NOTIFY currentTextChanged
               USER true)
    Q_PROPERTY(int currentIndex READ currentIndex WRITE setCurrentIndex NOTIFY currentIndexChanged)
    Q_PROPERTY(QVariant currentData READ currentData)
    Q_PROPERTY(int maxVisibleItems READ maxVisibleItems WRITE setMaxVisibleItems)
    Q_PROPERTY(int maxCount READ maxCount WRITE setMaxCount)
    Q_PROPERTY(InsertPolicy insertPolicy READ insertPolicy WRITE setInsertPolicy)
    Q_PROPERTY(SizeAdjustPolicy sizeAdjustPolicy READ sizeAdjustPolicy WRITE setSizeAdjustPolicy)
    Q_PROPERTY(int minimumContentsLength READ minimumContentsLength WRITE setMinimumContentsLength)
    Q_PROPERTY(QSize iconSize READ iconSize WRITE setIconSize)
    Q_PROPERTY(QString placeholderText READ placeholderText WRITE setPlaceholderText)
    Q_PROPERTY(bool duplicatesEnabled READ duplicatesEnabled WRITE setDuplicatesEnabled)
    Q_PROPERTY(bool frame READ hasFrame WRITE setFrame)
    Q_PROPERTY(int modelColumn READ modelColumn WRITE setModelColumn) +/

public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    final int maxVisibleItems() const;
    final void setMaxVisibleItems(int maxItems);

    final int count() const;
    final void setMaxCount(int max);
    final int maxCount() const;

    final bool duplicatesEnabled() const;
    final void setDuplicatesEnabled(bool enable);

    final void setFrame(bool);
    final bool hasFrame() const;

/+    pragma(inline, true) final int findText(ref const(QString) text,
                            /+ Qt:: +/qt.core.namespace.MatchFlags flags = static_cast!(/+ Qt:: +/qt.core.namespace.MatchFlags)(/+ Qt:: +/qt.core.namespace.MatchFlag.MatchExactly|/+ Qt:: +/qt.core.namespace.MatchFlag.MatchCaseSensitive)) const
        { return findData(text, /+ Qt:: +/qt.core.namespace.ItemDataRole.DisplayRole, flags); }
    final int findData(ref const(QVariant) data, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole,
                     /+ Qt:: +/qt.core.namespace.MatchFlags flags = static_cast!(/+ Qt:: +/qt.core.namespace.MatchFlags)(/+ Qt:: +/qt.core.namespace.MatchFlag.MatchExactly|/+ Qt:: +/qt.core.namespace.MatchFlag.MatchCaseSensitive)) const;
+/
    enum InsertPolicy {
        NoInsert,
        InsertAtTop,
        InsertAtCurrent,
        InsertAtBottom,
        InsertAfterCurrent,
        InsertBeforeCurrent,
        InsertAlphabetically
    }
    /+ Q_ENUM(InsertPolicy) +/

    final InsertPolicy insertPolicy() const;
    final void setInsertPolicy(InsertPolicy policy);

    enum SizeAdjustPolicy {
        AdjustToContents,
        AdjustToContentsOnFirstShow,
        AdjustToMinimumContentsLengthWithIcon
    }
    /+ Q_ENUM(SizeAdjustPolicy) +/

    final SizeAdjustPolicy sizeAdjustPolicy() const;
    final void setSizeAdjustPolicy(SizeAdjustPolicy policy);
    final int minimumContentsLength() const;
    final void setMinimumContentsLength(int characters);
    final QSize iconSize() const;
    final void setIconSize(ref const(QSize) size);

    final void setPlaceholderText(ref const(QString) placeholderText);
    final QString placeholderText() const;

    final bool isEditable() const;
    final void setEditable(bool editable);
    final void setLineEdit(QLineEdit edit);
    final QLineEdit lineEdit() const;
/+ #ifndef QT_NO_VALIDATOR +/
    version(QT_NO_VALIDATOR){}else
    {
        mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
        final void setValidator(const(QValidator) v);
        }));
        mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
        final const(QValidator) validator() const;
        }));
    }
/+ #endif

#if QT_CONFIG(completer) +/
    final void setCompleter(QCompleter c);
    final QCompleter completer() const;
/+ #endif +/

    final QAbstractItemDelegate itemDelegate() const;
    final void setItemDelegate(QAbstractItemDelegate delegate_);

    final QAbstractItemModel model() const;
    /+ virtual +/ void setModel(QAbstractItemModel model);

    final QModelIndex rootModelIndex() const;
    final void setRootModelIndex(ref const(QModelIndex) index);

    final int modelColumn() const;
    final void setModelColumn(int visibleColumn);

    final int currentIndex() const;
    final QString currentText() const;
    final QVariant currentData(int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole) const;

    final QString itemText(int index) const;
    final QIcon itemIcon(int index) const;
    final QVariant itemData(int index, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole) const;

    pragma(inline, true) final void addItem(ref const(QString) atext, ref const(QVariant) auserData = globalInitVar!QVariant)
    { insertItem(count(), atext, auserData); }
    pragma(inline, true) final void addItem(ref const(QIcon) aicon, ref const(QString) atext,
                            ref const(QVariant) auserData = globalInitVar!QVariant)
    { insertItem(count(), aicon, atext, auserData); }
    pragma(inline, true) final void addItems(ref const(QStringList) texts)
        { insertItems(count(), texts); }

    pragma(inline, true) final void insertItem(int aindex, ref const(QString) atext, ref const(QVariant) auserData = globalInitVar!QVariant)
    { auto tmp = QIcon(); insertItem(aindex, tmp, atext, auserData); }
    final void insertItem(int index, ref const(QIcon) icon, ref const(QString) text,
                        ref const(QVariant) userData = globalInitVar!QVariant);
    final void insertItems(int index, ref const(QStringList) texts);
    final void insertSeparator(int index);

    final void removeItem(int index);

    final void setItemText(int index, ref const(QString) text);
    final void setItemIcon(int index, ref const(QIcon) icon);
    final void setItemData(int index, ref const(QVariant) value, int role = /+ Qt:: +/qt.core.namespace.ItemDataRole.UserRole);

    final QAbstractItemView view() const;
    final void setView(QAbstractItemView itemView);

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;

    /+ virtual +/ void showPopup();
    /+ virtual +/ void hidePopup();

    override bool event(QEvent event);
    override QVariant inputMethodQuery(/+ Qt:: +/qt.core.namespace.InputMethodQuery) const;
    @QInvokable final QVariant inputMethodQuery(/+ Qt:: +/qt.core.namespace.InputMethodQuery query, ref const(QVariant) argument) const;

public /+ Q_SLOTS +/:
    @QSlot final void clear();
    @QSlot final void clearEditText();
    @QSlot final void setEditText(ref const(QString) text);
    @QSlot final void setCurrentIndex(int index);
    @QSlot final void setCurrentText(ref const(QString) text);

/+ Q_SIGNALS +/public:
    @QSignal final void editTextChanged(ref const(QString) );
    @QSignal final void activated(int index);
    @QSignal final void textActivated(ref const(QString) );
    @QSignal final void highlighted(int index);
    @QSignal final void textHighlighted(ref const(QString) );
    @QSignal final void currentIndexChanged(int index);
    @QSignal final void currentTextChanged(ref const(QString) );

protected:
    override void focusInEvent(QFocusEvent e);
    override void focusOutEvent(QFocusEvent e);
    override void changeEvent(QEvent e);
    override void resizeEvent(QResizeEvent e);
    override void paintEvent(QPaintEvent e);
    override void showEvent(QShowEvent e);
    override void hideEvent(QHideEvent e);
    override void mousePressEvent(QMouseEvent e);
    override void mouseReleaseEvent(QMouseEvent e);
    override void keyPressEvent(QKeyEvent e);
    override void keyReleaseEvent(QKeyEvent e);
/+ #if QT_CONFIG(wheelevent) +/
    override void wheelEvent(QWheelEvent e);
/+ #endif
#ifndef QT_NO_CONTEXTMENU +/
    version(QT_NO_CONTEXTMENU){}else
    {
        override void contextMenuEvent(QContextMenuEvent e);
    }
/+ #endif +/ // QT_NO_CONTEXTMENU
    override void inputMethodEvent(QInputMethodEvent );
    /+ virtual +/ void initStyleOption(QStyleOptionComboBox* option) const;


protected:
    this(ref QComboBoxPrivate , QWidget );

private:
    /+ Q_DECLARE_PRIVATE(QComboBox) +/
    /+ Q_DISABLE_COPY(QComboBox) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_itemSelected(const QModelIndex &item))
    Q_PRIVATE_SLOT(d_func(), void _q_emitHighlighted(const QModelIndex &))
    Q_PRIVATE_SLOT(d_func(), void _q_emitCurrentIndexChanged(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_editingFinished())
    Q_PRIVATE_SLOT(d_func(), void _q_returnPressed())
    Q_PRIVATE_SLOT(d_func(), void _q_resetButton())
    Q_PRIVATE_SLOT(d_func(), void _q_dataChanged(const QModelIndex &, const QModelIndex &))
    Q_PRIVATE_SLOT(d_func(), void _q_updateIndexBeforeChange())
    Q_PRIVATE_SLOT(d_func(), void _q_rowsInserted(const QModelIndex & parent, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_rowsRemoved(const QModelIndex & parent, int start, int end))
    Q_PRIVATE_SLOT(d_func(), void _q_modelDestroyed())
    Q_PRIVATE_SLOT(d_func(), void _q_modelReset())
#if QT_CONFIG(completer)
    Q_PRIVATE_SLOT(d_func(), void _q_completerActivated(const QModelIndex &index))
#endif +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

