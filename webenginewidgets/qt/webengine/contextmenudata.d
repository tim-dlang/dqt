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
module qt.webengine.contextmenudata;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.metamacros;
import qt.core.point;
import qt.core.string;
import qt.core.stringlist;
import qt.core.url;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct WebEngineContextMenuData;
}


/// Binding for C++ class [QWebEngineContextMenuData](https://doc.qt.io/qt-5/qwebenginecontextmenudata.html).
extern(C++, class) struct /+ QWEBENGINEWIDGETS_EXPORT +/ QWebEngineContextMenuData {
    mixin(Q_GADGET);

public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QWebEngineContextMenuData) other);
    ref QWebEngineContextMenuData opAssign(ref const(QWebEngineContextMenuData) other);
    ~this();

    enum MediaType {
        MediaTypeNone,
        MediaTypeImage,
        MediaTypeVideo,
        MediaTypeAudio,
        MediaTypeCanvas,
        MediaTypeFile,
        MediaTypePlugin
    }

    // Must match QWebEngineCore::WebEngineContextMenuData::MediaFlags:
    enum MediaFlag {
        MediaInError = 0x1,
        MediaPaused = 0x2,
        MediaMuted = 0x4,
        MediaLoop = 0x8,
        MediaCanSave = 0x10,
        MediaHasAudio = 0x20,
        MediaCanToggleControls = 0x40,
        MediaControls = 0x80,
        MediaCanPrint = 0x100,
        MediaCanRotate = 0x200,
    }
    /+ Q_DECLARE_FLAGS(MediaFlags, MediaFlag) +/
alias MediaFlags = QFlags!(MediaFlag);    /+ Q_FLAG(MediaFlags) +/

    // Must match QWebEngineCore::WebEngineContextMenuData::EditFlags:
    enum EditFlag {
        CanUndo = 0x1,
        CanRedo = 0x2,
        CanCut = 0x4,
        CanCopy = 0x8,
        CanPaste = 0x10,
        CanDelete = 0x20,
        CanSelectAll = 0x40,
        CanTranslate = 0x80,
        CanEditRichly = 0x100,
    }
    /+ Q_DECLARE_FLAGS(EditFlags, EditFlag) +/
alias EditFlags = QFlags!(EditFlag);    /+ Q_FLAG(EditFlags) +/

    bool isValid() const;

    QPoint position() const;
    QString selectedText() const;
    QString linkText() const;
    QUrl linkUrl() const;
    QUrl mediaUrl() const;
    MediaType mediaType() const;
    bool isContentEditable() const;
    QString misspelledWord() const;
    QStringList spellCheckerSuggestions() const;
    MediaFlags mediaFlags() const;
    EditFlags editFlags() const;

private:
    void reset();
    alias QWebEngineContextDataPrivate = /+ QtWebEngineCore:: +/WebEngineContextMenuData;
    ref QWebEngineContextMenuData opAssign(ref const(QWebEngineContextDataPrivate) priv);
    const(QWebEngineContextDataPrivate)* d;

    /+ friend class QWebEnginePagePrivate; +/
    /+ friend class QWebEnginePage; +/
}
/+pragma(inline, true) QFlags!(QWebEngineContextMenuData.MediaFlags.enum_type) operator |(QWebEngineContextMenuData.MediaFlags.enum_type f1, QWebEngineContextMenuData.MediaFlags.enum_type f2)/+noexcept+/{return QFlags!(QWebEngineContextMenuData.MediaFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QWebEngineContextMenuData.MediaFlags.enum_type) operator |(QWebEngineContextMenuData.MediaFlags.enum_type f1, QFlags!(QWebEngineContextMenuData.MediaFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QWebEngineContextMenuData.MediaFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QWebEngineContextMenuData::MediaFlags) +/
/+pragma(inline, true) QFlags!(QWebEngineContextMenuData.EditFlags.enum_type) operator |(QWebEngineContextMenuData.EditFlags.enum_type f1, QWebEngineContextMenuData.EditFlags.enum_type f2)/+noexcept+/{return QFlags!(QWebEngineContextMenuData.EditFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QWebEngineContextMenuData.EditFlags.enum_type) operator |(QWebEngineContextMenuData.EditFlags.enum_type f1, QFlags!(QWebEngineContextMenuData.EditFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QWebEngineContextMenuData.EditFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QWebEngineContextMenuData::EditFlags) +/
