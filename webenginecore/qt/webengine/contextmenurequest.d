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
module qt.webengine.contextmenurequest;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.object;
import qt.core.point;
import qt.core.scopedpointer;
import qt.core.string;
import qt.core.stringlist;
import qt.core.url;
import qt.helpers;

extern(C++, "extensions") {
extern(C++, class) struct MimeHandlerViewGuestDelegateQt;
}

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct RenderViewContextMenuQt;
extern(C++, class) struct WebContentsViewQt;

// Must match blink::WebReferrerPolicy
enum /+ class +/ ReferrerPolicy {
    Always,
    Default,
    NoReferrerWhenDowngrade,
    Never,
    Origin,
    OriginWhenCrossOrigin,
    NoReferrerWhenDowngradeOriginWhenCrossOrigin,
    SameOrigin,
    StrictOrigin,
    Last = ReferrerPolicy.StrictOrigin,
}
}


extern(C++, class) struct QWebEngineContextMenuRequestPrivate;
class /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineContextMenuRequest : QObject
{
    mixin(Q_OBJECT);
public:
    // Must match blink::mojom::ContextMenuDataMediaType:
    enum MediaType {
        MediaTypeNone,
        MediaTypeImage,
        MediaTypeVideo,
        MediaTypeAudio,
        MediaTypeCanvas,
        MediaTypeFile,
        MediaTypePlugin
    }
    /+ Q_ENUM(MediaType) +/

    // Must match blink::ContextMenuData::MediaFlags:
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

    // Must match blink::ContextMenuDataEditFlags:
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

    /+ Q_PROPERTY(QPoint position READ position CONSTANT FINAL)
    Q_PROPERTY(QString selectedText READ selectedText CONSTANT FINAL)
    Q_PROPERTY(QString linkText READ linkText CONSTANT FINAL)
    Q_PROPERTY(QUrl linkUrl READ linkUrl CONSTANT FINAL)
    Q_PROPERTY(QUrl mediaUrl READ mediaUrl CONSTANT FINAL)
    Q_PROPERTY(MediaType mediaType READ mediaType CONSTANT FINAL)
    Q_PROPERTY(bool isContentEditable READ isContentEditable CONSTANT FINAL)
    Q_PROPERTY(QString misspelledWord READ misspelledWord CONSTANT FINAL)
    Q_PROPERTY(QStringList spellCheckerSuggestions READ spellCheckerSuggestions CONSTANT FINAL)
    Q_PROPERTY(bool accepted READ isAccepted WRITE setAccepted FINAL)
    Q_PROPERTY(MediaFlags mediaFlags READ mediaFlags CONSTANT FINAL REVISION(1, 1))
    Q_PROPERTY(EditFlags editFlags READ editFlags CONSTANT FINAL REVISION(1, 1)) +/

    /+ virtual +/~this();
    final QPoint position() const;
    final QString selectedText() const;
    final QString linkText() const;
    final QUrl linkUrl() const;
    final QUrl mediaUrl() const;
    final MediaType mediaType() const;
    final bool isContentEditable() const;
    final QString misspelledWord() const;
    final QStringList spellCheckerSuggestions() const;
    final bool isAccepted() const;
    final void setAccepted(bool accepted);
    final MediaFlags mediaFlags() const;
    final EditFlags editFlags() const;

private:
    final QUrl filteredLinkUrl() const;
    final QString altText() const;
    final QString titleText() const;
    final QUrl referrerUrl() const;
    final /+ QtWebEngineCore:: +/ReferrerPolicy referrerPolicy() const;
    final bool hasImageContent() const;
    final QString suggestedFileName() const;

private:
    this(QWebEngineContextMenuRequestPrivate* d);
    QScopedPointer!(QWebEngineContextMenuRequestPrivate) d;
    /+ friend class QtWebEngineCore::WebContentsViewQt; +/
    /+ friend class QtWebEngineCore::RenderViewContextMenuQt; +/
    /+ friend class extensions::MimeHandlerViewGuestDelegateQt; +/
    /+ friend class QQuickWebEngineViewPrivate; +/
    /+ friend class QQuickWebEngineView; +/
    /+ friend class QWebEnginePage; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

