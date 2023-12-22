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



/// Binding for C++ class [QWebEngineSettings](https://doc.qt.io/qt-5/qwebenginesettings.html).
extern(C++, class) struct /+ QWEBENGINEWIDGETS_EXPORT +/ QWebEngineSettings {
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
    }

    enum FontSize {
        MinimumFontSize,
        MinimumLogicalFontSize,
        DefaultFontSize,
        DefaultFixedFontSize
    }

    enum UnknownUrlSchemePolicy {
        DisallowUnknownUrlSchemes = 1,
        AllowUnknownUrlSchemesFromUserInteraction,
        AllowAllUnknownUrlSchemes
    }

/+ #if QT_DEPRECATED_SINCE(5, 5) +/
    static QWebEngineSettings* globalSettings();
/+ #endif +/
    static QWebEngineSettings* defaultSettings();

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
    /+ Q_DISABLE_COPY(QWebEngineSettings) +/
@disable this(this);
/+this(ref const(QWebEngineSettings));+//+ref QWebEngineSettings operator =(ref const(QWebEngineSettings));+/    alias QWebEngineSettingsPrivate = /+ ::QtWebEngineCore:: +/WebEngineSettings;
    /+ QWebEngineSettingsPrivate* d_func() { return d_ptr.data(); } +/
    /+ const QWebEngineSettingsPrivate* d_func() const { return d_ptr.data(); } +/
    QScopedPointer!(QWebEngineSettingsPrivate) d_ptr;
    /+ friend class QWebEnginePagePrivate; +/
    /+ friend class QWebEngineProfilePrivate; +/

    ~this();
    @disable this();
    /+ explicit +/this(QWebEngineSettings* parentSettings/+ = null+/);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

