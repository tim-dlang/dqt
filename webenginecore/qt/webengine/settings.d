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
module qt.webengine.settings;
extern(C++):

import qt.config;
import qt.core.scopedpointer;
import qt.core.string;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct WebEngineSettings;
}


/// Binding for C++ class [QWebEngineSettings](https://doc.qt.io/qt-6/qwebenginesettings.html).
extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineSettings
{
public:
    enum FontFamily {
        StandardFont,
        FixedFont,
        SerifFont,
        SansSerifFont,
        CursiveFont,
        FantasyFont,
        PictographFont
    }

    enum WebAttribute {
        AutoLoadImages,
        JavascriptEnabled,
        JavascriptCanOpenWindows,
        JavascriptCanAccessClipboard,
        LinksIncludedInFocusChain,
        LocalStorageEnabled,
        LocalContentCanAccessRemoteUrls,
        XSSAuditingEnabled,
        SpatialNavigationEnabled,
        LocalContentCanAccessFileUrls,
        HyperlinkAuditingEnabled,
        ScrollAnimatorEnabled,
        ErrorPageEnabled,
        PluginsEnabled,
        FullScreenSupportEnabled,
        ScreenCaptureEnabled,
        WebGLEnabled,
        Accelerated2dCanvasEnabled,
        AutoLoadIconsForPage,
        TouchIconsEnabled,
        FocusOnNavigationEnabled,
        PrintElementBackgrounds,
        AllowRunningInsecureContent,
        AllowGeolocationOnInsecureOrigins,
        AllowWindowActivationFromJavaScript,
        ShowScrollBars,
        PlaybackRequiresUserGesture,
        WebRTCPublicInterfacesOnly,
        JavascriptCanPaste,
        DnsPrefetchEnabled,
        PdfViewerEnabled,
        NavigateOnDropEnabled,
    }

    enum FontSize {
        MinimumFontSize,
        MinimumLogicalFontSize,
        DefaultFontSize,
        DefaultFixedFontSize
    }

    enum UnknownUrlSchemePolicy {
        InheritedUnknownUrlSchemePolicy = 0, // TODO: hide
        DisallowUnknownUrlSchemes = 1,
        AllowUnknownUrlSchemesFromUserInteraction,
        AllowAllUnknownUrlSchemes
    }

public:
    ~this();
    void setFontFamily(FontFamily which, ref const(QString) family);
    QString fontFamily(FontFamily which) const;
    void resetFontFamily(FontFamily which);

    void setFontSize(FontSize type, int size);
    int fontSize(FontSize type) const;
    void resetFontSize(FontSize type);

    void setAttribute(WebAttribute attr, bool on);
    bool testAttribute(WebAttribute attr) const;
    void resetAttribute(WebAttribute attr);

    void setDefaultTextEncoding(ref const(QString) encoding);
    QString defaultTextEncoding() const;

    UnknownUrlSchemePolicy unknownUrlSchemePolicy() const;
    void setUnknownUrlSchemePolicy(UnknownUrlSchemePolicy policy);
    void resetUnknownUrlSchemePolicy();

private:
    @disable this();
    /+ explicit +/this(QWebEngineSettings* parentSettings/+ = null+/);
    void setParentSettings(QWebEngineSettings* parentSettings);
    /+ Q_DISABLE_COPY(QWebEngineSettings) +/
@disable this(this);
/+@disable this(ref const(QWebEngineSettings));+//+@disable ref QWebEngineSettings operator =(ref const(QWebEngineSettings));+/    alias QWebEngineSettingsPrivate = /+ ::QtWebEngineCore:: +/WebEngineSettings;
    QScopedPointer!(QWebEngineSettingsPrivate) d_ptr;
    /+ friend class QWebEnginePagePrivate; +/
    /+ friend class QWebEngineProfilePrivate; +/
    /+ friend class QQuickWebEngineSettings; +/
    /+ friend class QtWebEngineCore::WebEngineSettings; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

