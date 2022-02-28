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
module qt.widgets.lineedit;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.margins;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.variant;
import qt.gui.action;
import qt.gui.event;
import qt.gui.icon;
import qt.helpers;
import qt.widgets.completer;
import qt.widgets.styleoption;
import qt.widgets.widget;
version(QT_NO_CONTEXTMENU){}else
    import qt.widgets.menu;
version(QT_NO_VALIDATOR){}else
    import qt.gui.validator;

/+ QT_REQUIRE_CONFIG(lineedit); +/

extern(C++, class) struct QLineEditPrivate;

/// Binding for C++ class [QLineEdit](https://doc.qt.io/qt-6/qlineedit.html).
class /+ Q_WIDGETS_EXPORT +/ QLineEdit : QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QString inputMask READ inputMask WRITE setInputMask)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged USER true)
    Q_PROPERTY(int maxLength READ maxLength WRITE setMaxLength)
    Q_PROPERTY(bool frame READ hasFrame WRITE setFrame)
    Q_PROPERTY(EchoMode echoMode READ echoMode WRITE setEchoMode)
    Q_PROPERTY(QString displayText READ displayText)
    Q_PROPERTY(int cursorPosition READ cursorPosition WRITE setCursorPosition)
    Q_PROPERTY(Qt::Alignment alignment READ alignment WRITE setAlignment)
    Q_PROPERTY(bool modified READ isModified WRITE setModified DESIGNABLE false)
    Q_PROPERTY(bool hasSelectedText READ hasSelectedText)
    Q_PROPERTY(QString selectedText READ selectedText)
    Q_PROPERTY(bool dragEnabled READ dragEnabled WRITE setDragEnabled)
    Q_PROPERTY(bool readOnly READ isReadOnly WRITE setReadOnly)
    Q_PROPERTY(bool undoAvailable READ isUndoAvailable)
    Q_PROPERTY(bool redoAvailable READ isRedoAvailable)
    Q_PROPERTY(bool acceptableInput READ hasAcceptableInput)
    Q_PROPERTY(QString placeholderText READ placeholderText WRITE setPlaceholderText)
    Q_PROPERTY(Qt::CursorMoveStyle cursorMoveStyle READ cursorMoveStyle WRITE setCursorMoveStyle)
    Q_PROPERTY(bool clearButtonEnabled READ isClearButtonEnabled WRITE setClearButtonEnabled) +/
public:
    enum ActionPosition {
        LeadingPosition,
        TrailingPosition
    }
    /+ Q_ENUM(ActionPosition) +/

    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QString) , QWidget parent = null);
    ~this();

    final QString text() const;

    final QString displayText() const;

    final QString placeholderText() const;
    final void setPlaceholderText(ref const(QString) );

    final int maxLength() const;
    final void setMaxLength(int);

    final void setFrame(bool);
    final bool hasFrame() const;

    final void setClearButtonEnabled(bool enable);
    final bool isClearButtonEnabled() const;

    enum EchoMode { Normal, NoEcho, Password, PasswordEchoOnEdit }
    /+ Q_ENUM(EchoMode) +/
    final EchoMode echoMode() const;
    final void setEchoMode(EchoMode);

    final bool isReadOnly() const;
    final void setReadOnly(bool);

/+ #ifndef QT_NO_VALIDATOR +/
    version(QT_NO_VALIDATOR){}else
    {
        mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
        final void setValidator(const(QValidator) );
        }));
        mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
        final const(QValidator)  validator() const;
        }));
    }
/+ #endif

#if QT_CONFIG(completer) +/
    final void setCompleter(QCompleter completer);
    final QCompleter completer() const;
/+ #endif +/

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;

    final int cursorPosition() const;
    final void setCursorPosition(int);
    final int cursorPositionAt(ref const(QPoint) pos);

    final void setAlignment(/+ Qt:: +/qt.core.namespace.Alignment flag);
    final /+ Qt:: +/qt.core.namespace.Alignment alignment() const;

    final void cursorForward(bool mark, int steps = 1);
    final void cursorBackward(bool mark, int steps = 1);
    final void cursorWordForward(bool mark);
    final void cursorWordBackward(bool mark);
    final void backspace();
    final void del();
    final void home(bool mark);
    final void end(bool mark);

    final bool isModified() const;
    final void setModified(bool);

    final void setSelection(int, int);
    final bool hasSelectedText() const;
    final QString selectedText() const;
    final int selectionStart() const;
    final int selectionEnd() const;
    final int selectionLength() const;

    final bool isUndoAvailable() const;
    final bool isRedoAvailable() const;

    final void setDragEnabled(bool b);
    final bool dragEnabled() const;

    final void setCursorMoveStyle(/+ Qt:: +/qt.core.namespace.CursorMoveStyle style);
    final /+ Qt:: +/qt.core.namespace.CursorMoveStyle cursorMoveStyle() const;

    final QString inputMask() const;
    final void setInputMask(ref const(QString) inputMask);
    final bool hasAcceptableInput() const;

    final void setTextMargins(int left, int top, int right, int bottom);
    final void setTextMargins(ref const(QMargins) margins);
    final QMargins textMargins() const;

/+ #if QT_CONFIG(action) +/
    /+ using QWidget::addAction; +/
    final void addAction(QAction action, ActionPosition position);
    final QAction addAction(ref const(QIcon) icon, ActionPosition position);
/+ #endif +/

public /+ Q_SLOTS +/:
    @QSlot final void setText(ref const(QString) );
    @QSlot final void clear();
    @QSlot final void selectAll();
    @QSlot final void undo();
    @QSlot final void redo();
    version(QT_NO_CLIPBOARD){}else
    {
        @QSlot final void cut();
        /+ void copy() const; +/
        @QSlot final void paste();
    }

public:
    final void deselect();
    final void insert(ref const(QString) );
    version(QT_NO_CONTEXTMENU){}else
    {
        final QMenu createStandardContextMenu();
    }

/+ Q_SIGNALS +/public:
    @QSignal final void textChanged(ref const(QString) );
    @QSignal final void textEdited(ref const(QString) );
    @QSignal final void cursorPositionChanged(int, int);
    @QSignal final void returnPressed();
    @QSignal final void editingFinished();
    @QSignal final void selectionChanged();
    @QSignal final void inputRejected();

protected:
    override void mousePressEvent(QMouseEvent );
    override void mouseMoveEvent(QMouseEvent );
    override void mouseReleaseEvent(QMouseEvent );
    override void mouseDoubleClickEvent(QMouseEvent );
    override void keyPressEvent(QKeyEvent );
    override void keyReleaseEvent(QKeyEvent );
    override void focusInEvent(QFocusEvent );
    override void focusOutEvent(QFocusEvent );
    override void paintEvent(QPaintEvent );
/+ #if QT_CONFIG(draganddrop) +/
    override void dragEnterEvent(QDragEnterEvent );
    override void dragMoveEvent(QDragMoveEvent e);
    override void dragLeaveEvent(QDragLeaveEvent e);
    override void dropEvent(QDropEvent );
/+ #endif +/
    override void changeEvent(QEvent );
    version(QT_NO_CONTEXTMENU){}else
    {
        override void contextMenuEvent(QContextMenuEvent );
    }

    override void inputMethodEvent(QInputMethodEvent );
    /+ virtual +/ void initStyleOption(QStyleOptionFrame* option) const;
public:
    override QVariant inputMethodQuery(/+ Qt:: +/qt.core.namespace.InputMethodQuery) const;
    @QInvokable final QVariant inputMethodQuery(/+ Qt:: +/qt.core.namespace.InputMethodQuery property, QVariant argument) const;
    override void timerEvent(QTimerEvent );
    override bool event(QEvent );
protected:
    final QRect cursorRect() const;

public:

private:
    /+ friend class QAbstractSpinBox; +/
    /+ friend class QAccessibleLineEdit; +/
    /+ friend class QComboBox; +/
    version(QT_KEYPAD_NAVIGATION)
    {
        /+ friend class QDateTimeEdit; +/
    }
    /+ Q_DISABLE_COPY(QLineEdit) +/
    /+ Q_DECLARE_PRIVATE(QLineEdit) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_handleWindowActivate())
    Q_PRIVATE_SLOT(d_func(), void _q_textEdited(const QString &))
    Q_PRIVATE_SLOT(d_func(), void _q_cursorPositionChanged(int, int))
#if QT_CONFIG(completer)
    Q_PRIVATE_SLOT(d_func(), void _q_completionHighlighted(const QString &))
#endif
#ifdef QT_KEYPAD_NAVIGATION
    Q_PRIVATE_SLOT(d_func(), void _q_editFocusChange(bool))
#endif
    Q_PRIVATE_SLOT(d_func(), void _q_selectionChanged())
    Q_PRIVATE_SLOT(d_func(), void _q_updateNeeded(const QRect &))
    Q_PRIVATE_SLOT(d_func(), void _q_textChanged(const QString &))
    Q_PRIVATE_SLOT(d_func(), void _q_clearButtonClicked())
    Q_PRIVATE_SLOT(d_func(), void _q_controlEditingFinished()) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

