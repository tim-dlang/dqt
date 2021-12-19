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
module qt.gui.keysequence;
extern(C++):

import qt.config;
import qt.core.metatype;
import qt.core.typeinfo;
import qt.helpers;
version(QT_NO_SHORTCUT){}else
{
    import qt.core.list;
    import qt.core.objectdefs;
    import qt.core.string;
    import qt.core.variant;
}

version(QT_NO_SHORTCUT){}else
{


/*****************************************************************************
  QKeySequence stream functions
 *****************************************************************************/
/+ #if !defined(QT_NO_DATASTREAM) || defined(Q_CLANG_QDOC)
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &in, const QKeySequence &ks);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &out, QKeySequence &ks);
#endif

#if defined(Q_CLANG_QDOC)
void qt_set_sequence_auto_mnemonic(bool b);
#endif +/

extern(C++, class) struct QKeySequencePrivate;

/+ Q_GUI_EXPORT Q_DECL_PURE_FUNCTION uint qHash(const QKeySequence &key, uint seed = 0) noexcept; +/

/// Binding for C++ class [QKeySequence](https://doc.qt.io/qt-5/qkeysequence.html).
@(QMetaType.Type.QKeySequence) @Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QKeySequence
{
    mixin(Q_GADGET);

public:
    enum StandardKey {
        UnknownKey,
        HelpContents,
        WhatsThis,
        Open,
        Close,
        Save,
        New,
        Delete,
        Cut,
        Copy,
        Paste,
        Undo,
        Redo,
        Back,
        Forward,
        Refresh,
        ZoomIn,
        ZoomOut,
        Print,
        AddTab,
        NextChild,
        PreviousChild,
        Find,
        FindNext,
        FindPrevious,
        Replace,
        SelectAll,
        Bold,
        Italic,
        Underline,
        MoveToNextChar,
        MoveToPreviousChar,
        MoveToNextWord,
        MoveToPreviousWord,
        MoveToNextLine,
        MoveToPreviousLine,
        MoveToNextPage,
        MoveToPreviousPage,
        MoveToStartOfLine,
        MoveToEndOfLine,
        MoveToStartOfBlock,
        MoveToEndOfBlock,
        MoveToStartOfDocument,
        MoveToEndOfDocument,
        SelectNextChar,
        SelectPreviousChar,
        SelectNextWord,
        SelectPreviousWord,
        SelectNextLine,
        SelectPreviousLine,
        SelectNextPage,
        SelectPreviousPage,
        SelectStartOfLine,
        SelectEndOfLine,
        SelectStartOfBlock,
        SelectEndOfBlock,
        SelectStartOfDocument,
        SelectEndOfDocument,
        DeleteStartOfWord,
        DeleteEndOfWord,
        DeleteEndOfLine,
        InsertParagraphSeparator,
        InsertLineSeparator,
        SaveAs,
        Preferences,
        Quit,
        FullScreen,
        Deselect,
        DeleteCompleteLine,
        Backspace,
        Cancel
     }
     /+ Q_ENUM(StandardKey) +/

    enum SequenceFormat {
        NativeText,
        PortableText
    }

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(ref const(QString) key, SequenceFormat format = SequenceFormat.NativeText);
    this(int k1, int k2 = 0, int k3 = 0, int k4 = 0);
    @disable this(this);
    this(ref const(QKeySequence) ks);
    this(StandardKey key);
    ~this();

    int count() const;
    bool isEmpty() const;

    enum SequenceMatch {
        NoMatch,
        PartialMatch,
        ExactMatch
    }

    QString toString(SequenceFormat format = SequenceFormat.PortableText) const;
    static QKeySequence fromString(ref const(QString) str, SequenceFormat format = SequenceFormat.PortableText);

    static QList!(QKeySequence) listFromString(ref const(QString) str, SequenceFormat format = SequenceFormat.PortableText);
    static QString listToString(ref const(QList!(QKeySequence)) list, SequenceFormat format = SequenceFormat.PortableText);

    SequenceMatch matches(ref const(QKeySequence) seq) const;
    static QKeySequence mnemonic(ref const(QString) text);
    static QList!(QKeySequence) keyBindings(StandardKey key);

/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED operator QString() const { return toString(QKeySequence::NativeText); }
    QT_DEPRECATED operator int() const { if (1 <= count()) return operator [](0); return 0; }
#endif +/
    /+auto opCast(T : QVariant)() const;+/
    /+int operator [](uint i) const;+/
    /+ref QKeySequence operator =(ref const(QKeySequence) other);+/
    /+ QKeySequence &operator=(QKeySequence &&other) noexcept { swap(other); return *this; } +/
    /+ void swap(QKeySequence &other) noexcept { qSwap(d, other.d); } +/

    /+bool operator ==(ref const(QKeySequence) other) const;+/
    /+pragma(inline, true) bool operator != (ref const(QKeySequence) other) const
    { return !(this == other); }+/
    /+bool operator < (ref const(QKeySequence) ks) const;+/
    /+pragma(inline, true) bool operator > (ref const(QKeySequence) other) const
    { return other < this; }+/
    /+pragma(inline, true) bool operator <= (ref const(QKeySequence) other) const
    { return !(other < this); }+/
    /+pragma(inline, true) bool operator >= (ref const(QKeySequence) other) const
    { return !(this < other); }+/

    bool isDetached() const;
private:
    static int decodeString(ref const(QString) ks);
    static QString encodeString(int key);
    int assign(ref const(QString) str);
    int assign(ref const(QString) str, SequenceFormat format);
    void setKey(int key, int index);

    QKeySequencePrivate* d;

    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &in, const QKeySequence &ks); +/
    /+ friend Q_GUI_EXPORT QDataStream &operator>>(QDataStream &in, QKeySequence &ks); +/
    /+ friend Q_GUI_EXPORT uint qHash(const QKeySequence &key, uint seed) noexcept; +/
    /+ friend class QShortcutMap; +/
    /+ friend class QShortcut; +/

public:
    alias DataPtr = QKeySequencePrivate*;
    pragma(inline, true) ref DataPtr data_ptr() return { return d; }
}

/+ Q_DECLARE_SHARED(QKeySequence)

#if !defined(QT_NO_DEBUG_STREAM) || defined(Q_CLANG_QDOC)
Q_GUI_EXPORT QDebug operator<<(QDebug, const QKeySequence &);
#endif +/

}
version(QT_NO_SHORTCUT)
{

/// Binding for C++ class [QKeySequence](https://doc.qt.io/qt-5/qkeysequence.html).
@(QMetaType.Type.QKeySequence) extern(C++, class) struct /+ Q_GUI_EXPORT +/ QKeySequence
{
public:
    @disable this();
    /+this() {}+/
    this(int) {}
}

}

