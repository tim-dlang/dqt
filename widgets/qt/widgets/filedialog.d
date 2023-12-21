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
module qt.widgets.filedialog;
extern(C++):

import qt.config;
import qt.core.abstractproxymodel;
import qt.core.bytearray;
import qt.core.coreevent;
import qt.core.dir;
import qt.core.flags;
import qt.core.list;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.core.stringlist;
import qt.core.url;
import qt.helpers;
import qt.widgets.abstractitemdelegate;
import qt.widgets.dialog;
import qt.widgets.fileiconprovider;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(filedialog); +/


struct QFileDialogArgs;
extern(C++, class) struct QFileDialogPrivate;

/// Binding for C++ class [QFileDialog](https://doc.qt.io/qt-5/qfiledialog.html).
class /+ Q_WIDGETS_EXPORT +/ QFileDialog : QDialog
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(ViewMode viewMode READ viewMode WRITE setViewMode)
    Q_PROPERTY(FileMode fileMode READ fileMode WRITE setFileMode)
    Q_PROPERTY(AcceptMode acceptMode READ acceptMode WRITE setAcceptMode)
    Q_PROPERTY(QString defaultSuffix READ defaultSuffix WRITE setDefaultSuffix)
#if QT_DEPRECATED_SINCE(5, 13)
    Q_PROPERTY(bool readOnly READ isReadOnly WRITE setReadOnly DESIGNABLE false)
    Q_PROPERTY(bool confirmOverwrite READ confirmOverwrite WRITE setConfirmOverwrite DESIGNABLE false)
    Q_PROPERTY(bool resolveSymlinks READ resolveSymlinks WRITE setResolveSymlinks DESIGNABLE false)
    Q_PROPERTY(bool nameFilterDetailsVisible READ isNameFilterDetailsVisible
               WRITE setNameFilterDetailsVisible DESIGNABLE false)
#endif
    Q_PROPERTY(Options options READ options WRITE setOptions)
    Q_PROPERTY(QStringList supportedSchemes READ supportedSchemes WRITE setSupportedSchemes) +/

public:
    enum ViewMode { Detail, List }
    /+ Q_ENUM(ViewMode) +/
    enum FileMode { AnyFile, ExistingFile, Directory, ExistingFiles,
                    DirectoryOnly /+ Q_DECL_ENUMERATOR_DEPRECATED_X("Use setOption(ShowDirsOnly, true) instead") +/}
    /+ Q_ENUM(FileMode) +/
    enum AcceptMode { AcceptOpen, AcceptSave }
    /+ Q_ENUM(AcceptMode) +/
    enum DialogLabel { LookIn, FileName, FileType, Accept, Reject }

    enum Option
    {
        ShowDirsOnly                = 0x00000001,
        DontResolveSymlinks         = 0x00000002,
        DontConfirmOverwrite        = 0x00000004,
/+ #if QT_DEPRECATED_SINCE(5, 14) +/
        DontUseSheet /+ Q_DECL_ENUMERATOR_DEPRECATED +/ = 0x00000008,
/+ #endif +/
        DontUseNativeDialog         = 0x00000010,
        ReadOnly                    = 0x00000020,
        HideNameFilterDetails       = 0x00000040,
        DontUseCustomDirectoryIcons = 0x00000080
    }
    /+ Q_ENUM(Option) +/
    /+ Q_DECLARE_FLAGS(Options, Option) +/
alias Options = QFlags!(Option);    /+ Q_FLAG(Options) +/

    this(QWidget parent, /+ Qt:: +/qt.core.namespace.WindowFlags f);
    /+ explicit +/this(QWidget parent = null,
                             ref const(QString) caption = globalInitVar!QString,
                             ref const(QString) directory = globalInitVar!QString,
                             ref const(QString) filter = globalInitVar!QString);
    ~this();

    final void setDirectory(ref const(QString) directory);
    pragma(inline, true) final void setDirectory(ref const(QDir) adirectory)
    { auto tmp = adirectory.absolutePath(); setDirectory(tmp); }
    final QDir directory() const;

    final void setDirectoryUrl(ref const(QUrl) directory);
    final QUrl directoryUrl() const;

    final void selectFile(ref const(QString) filename);
    final QStringList selectedFiles() const;

    final void selectUrl(ref const(QUrl) url);
    //final QList!(QUrl) selectedUrls() const;

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use setOption(HideNameFilterDetails, !enabled) instead") +/
        final void setNameFilterDetailsVisible(bool enabled);
    /+ QT_DEPRECATED_X("Use !testOption(HideNameFilterDetails) instead") +/
        final bool isNameFilterDetailsVisible() const;
/+ #endif +/

    final void setNameFilter(ref const(QString) filter);
    final void setNameFilters(ref const(QStringList) filters);
    final QStringList nameFilters() const;
    final void selectNameFilter(ref const(QString) filter);
    final QString selectedMimeTypeFilter() const;
    final QString selectedNameFilter() const;

/+ #if QT_CONFIG(mimetype) +/
    final void setMimeTypeFilters(ref const(QStringList) filters);
    final QStringList mimeTypeFilters() const;
    final void selectMimeTypeFilter(ref const(QString) filter);
/+ #endif +/

    final QDir.Filters filter() const;
    final void setFilter(QDir.Filters filters);

    final void setViewMode(ViewMode mode);
    final ViewMode viewMode() const;

    final void setFileMode(FileMode mode);
    final FileMode fileMode() const;

    final void setAcceptMode(AcceptMode mode);
    final AcceptMode acceptMode() const;

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    final void setReadOnly(bool enabled);
    final bool isReadOnly() const;

    /+ QT_DEPRECATED_X("Use setOption(DontResolveSymlinks, !enabled) instead") +/
        final void setResolveSymlinks(bool enabled);
    /+ QT_DEPRECATED_X("Use !testOption(DontResolveSymlinks) instead") +/
        final bool resolveSymlinks() const;
/+ #endif +/

    //final void setSidebarUrls(ref const(QList!(QUrl)) urls);
    //final QList!(QUrl) sidebarUrls() const;

    final QByteArray saveState() const;
    final bool restoreState(ref const(QByteArray) state);

/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use setOption(DontConfirmOverwrite, !enabled) instead") +/
        final void setConfirmOverwrite(bool enabled);
    /+ QT_DEPRECATED_X("Use !testOption(DontConfirmOverwrite) instead") +/
        final bool confirmOverwrite() const;
/+ #endif +/

    final void setDefaultSuffix(ref const(QString) suffix);
    final QString defaultSuffix() const;

    final void setHistory(ref const(QStringList) paths);
    final QStringList history() const;

    final void setItemDelegate(QAbstractItemDelegate delegate_);
    final QAbstractItemDelegate itemDelegate() const;

    final void setIconProvider(QFileIconProvider provider);
    final QFileIconProvider iconProvider() const;

    final void setLabelText(DialogLabel label, ref const(QString) text);
    final QString labelText(DialogLabel label) const;

    final void setSupportedSchemes(ref const(QStringList) schemes);
    final QStringList supportedSchemes() const;

/+ #if QT_CONFIG(proxymodel) +/
    final void setProxyModel(QAbstractProxyModel model);
    final QAbstractProxyModel proxyModel() const;
/+ #endif +/

    final void setOption(Option option, bool on = true);
    final bool testOption(Option option) const;
    final void setOptions(Options options);
    final Options options() const;

    /+ using QDialog::open; +/
    final void open(QObject receiver, const(char)* member);
    override void setVisible(bool visible);

/+ Q_SIGNALS +/public:
    @QSignal final void fileSelected(ref const(QString) file);
    @QSignal final void filesSelected(ref const(QStringList) files);
    @QSignal final void currentChanged(ref const(QString) path);
    @QSignal final void directoryEntered(ref const(QString) directory);

    @QSignal final void urlSelected(ref const(QUrl) url);
    //@QSignal final void urlsSelected(ref const(QList!(QUrl)) urls);
    @QSignal final void currentUrlChanged(ref const(QUrl) url);
    @QSignal final void directoryUrlEntered(ref const(QUrl) directory);

    @QSignal final void filterSelected(ref const(QString) filter);

public:

    static QString getOpenFileName(QWidget parent = null,
                                       ref const(QString) caption = globalInitVar!QString,
                                       ref const(QString) dir = globalInitVar!QString,
                                       ref const(QString) filter = globalInitVar!QString,
                                       QString* selectedFilter = null,
                                       Options options = Options());

    static QUrl getOpenFileUrl(QWidget parent = null,
                                   ref const(QString) caption = globalInitVar!QString,
                                   ref const(QUrl) dir = globalInitVar!QUrl,
                                   ref const(QString) filter = globalInitVar!QString,
                                   QString* selectedFilter = null,
                                   Options options = Options(),
                                   ref const(QStringList) supportedSchemes = globalInitVar!QStringList);

    static QString getSaveFileName(QWidget parent = null,
                                       ref const(QString) caption = globalInitVar!QString,
                                       ref const(QString) dir = globalInitVar!QString,
                                       ref const(QString) filter = globalInitVar!QString,
                                       QString* selectedFilter = null,
                                       Options options = Options());

    static QUrl getSaveFileUrl(QWidget parent = null,
                                   ref const(QString) caption = globalInitVar!QString,
                                   ref const(QUrl) dir = globalInitVar!QUrl,
                                   ref const(QString) filter = globalInitVar!QString,
                                   QString* selectedFilter = null,
                                   Options options = Options(),
                                   ref const(QStringList) supportedSchemes = globalInitVar!QStringList);

    static QString getExistingDirectory(QWidget parent = null,
                                            ref const(QString) caption = globalInitVar!QString,
                                            ref const(QString) dir = globalInitVar!QString,
                                            Options options = Option.ShowDirsOnly);

    static QUrl getExistingDirectoryUrl(QWidget parent = null,
                                            ref const(QString) caption = globalInitVar!QString,
                                            ref const(QUrl) dir = globalInitVar!QUrl,
                                            Options options = Option.ShowDirsOnly,
                                            ref const(QStringList) supportedSchemes = globalInitVar!QStringList);

    static QStringList getOpenFileNames(QWidget parent = null,
                                            ref const(QString) caption = globalInitVar!QString,
                                            ref const(QString) dir = globalInitVar!QString,
                                            ref const(QString) filter = globalInitVar!QString,
                                            QString* selectedFilter = null,
                                            Options options = Options());

    /*static QList!(QUrl) getOpenFileUrls(QWidget parent = null,
                                           ref const(QString) caption = globalInitVar!QString,
                                           ref const(QUrl) dir = globalInitVar!QUrl,
                                           ref const(QString) filter = globalInitVar!QString,
                                           QString* selectedFilter = null,
                                           Options options = Options(),
                                           ref const(QStringList) supportedSchemes = globalInitVar!QStringList);*/

    /+ static void getOpenFileContent(const QString &nameFilter,
                                   const std::function<void(const QString &, const QByteArray &)> &fileContentsReady); +/
    static void saveFileContent(ref const(QByteArray) fileContent, ref const(QString) fileNameHint = globalInitVar!QString);

protected:
    this(ref const(QFileDialogArgs) args);
    override void done(int result);
    override void accept();
    override void changeEvent(QEvent e);

private:
    /+ Q_DECLARE_PRIVATE(QFileDialog) +/
    /+ Q_DISABLE_COPY(QFileDialog) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_pathChanged(const QString &))

    Q_PRIVATE_SLOT(d_func(), void _q_navigateBackward())
    Q_PRIVATE_SLOT(d_func(), void _q_navigateForward())
    Q_PRIVATE_SLOT(d_func(), void _q_navigateToParent())
    Q_PRIVATE_SLOT(d_func(), void _q_createDirectory())
    Q_PRIVATE_SLOT(d_func(), void _q_showListView())
    Q_PRIVATE_SLOT(d_func(), void _q_showDetailsView())
    Q_PRIVATE_SLOT(d_func(), void _q_showContextMenu(const QPoint &))
    Q_PRIVATE_SLOT(d_func(), void _q_renameCurrent())
    Q_PRIVATE_SLOT(d_func(), void _q_deleteCurrent())
    Q_PRIVATE_SLOT(d_func(), void _q_showHidden())
    Q_PRIVATE_SLOT(d_func(), void _q_updateOkButton())
    Q_PRIVATE_SLOT(d_func(), void _q_currentChanged(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_enterDirectory(const QModelIndex &index))
    Q_PRIVATE_SLOT(d_func(), void _q_emitUrlSelected(const QUrl &))
    Q_PRIVATE_SLOT(d_func(), void _q_emitUrlsSelected(const QList<QUrl> &))
    Q_PRIVATE_SLOT(d_func(), void _q_nativeCurrentChanged(const QUrl &))
    Q_PRIVATE_SLOT(d_func(), void _q_nativeEnterDirectory(const QUrl&))
    Q_PRIVATE_SLOT(d_func(), void _q_goToDirectory(const QString &path))
    Q_PRIVATE_SLOT(d_func(), void _q_useNameFilter(int index))
    Q_PRIVATE_SLOT(d_func(), void _q_selectionChanged())
    Q_PRIVATE_SLOT(d_func(), void _q_goToUrl(const QUrl &url))
    Q_PRIVATE_SLOT(d_func(), void _q_goHome())
    Q_PRIVATE_SLOT(d_func(), void _q_showHeader(QAction *))
    Q_PRIVATE_SLOT(d_func(), void _q_autoCompleteFileName(const QString &text))
    Q_PRIVATE_SLOT(d_func(), void _q_rowsInserted(const QModelIndex & parent))
    Q_PRIVATE_SLOT(d_func(), void _q_fileRenamed(const QString &path,
                                                 const QString &oldName,
                                                 const QString &newName)) +/
    /+ friend class QPlatformDialogHelper; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QFileDialog.Options.enum_type) operator |(QFileDialog.Options.enum_type f1, QFileDialog.Options.enum_type f2)/+noexcept+/{return QFlags!(QFileDialog.Options.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QFileDialog.Options.enum_type) operator |(QFileDialog.Options.enum_type f1, QFlags!(QFileDialog.Options.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QFileDialog.Options.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QFileDialog::Options) +/
