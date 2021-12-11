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
module qt.gui.desktopservices;
extern(C++):

import qt.config;
import qt.helpers;
static if(!defined!"QT_NO_DESKTOPSERVICES" && !defined!"QT_NO_STANDARDPATHS")
    import qt.core.standardpaths;
static if(!defined!"QT_NO_DESKTOPSERVICES")
{
    import qt.core.object;
    import qt.core.string;
    import qt.core.url;
}

static if(!defined!"QT_NO_DESKTOPSERVICES")
{

/+ class QStringList;
class QUrl;
class QObject; +/

/// Binding for C++ class [QDesktopServices](https://doc.qt.io/qt-5/qdesktopservices.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QDesktopServices
{
public:
    static bool openUrl(ref const(QUrl) url);
    static void setUrlHandler(ref const(QString) scheme, QObject receiver, const(char)* method);
    static void unsetUrlHandler(ref const(QString) scheme);

/+ #if QT_DEPRECATED_SINCE(5, 0)
    //Must match QStandardPaths::StandardLocation
    enum StandardLocation {
        DesktopLocation,
        DocumentsLocation,
        FontsLocation,
        ApplicationsLocation,
        MusicLocation,
        MoviesLocation,
        PicturesLocation,
        TempLocation,
        HomeLocation,
        DataLocation,
        CacheLocation
    };

    QT_DEPRECATED static QString storageLocation(StandardLocation type) {
        return storageLocationImpl(static_cast<QStandardPaths::StandardLocation>(type));
    }
    QT_DEPRECATED static QString displayName(StandardLocation type) {
        return QStandardPaths::displayName(static_cast<QStandardPaths::StandardLocation>(type));
    }
#endif +/
private:
    static QString storageLocationImpl(mixin((!defined!"QT_NO_STANDARDPATHS") ? q{QStandardPaths.StandardLocation } : q{AliasSeq!()}) type);
}

}

