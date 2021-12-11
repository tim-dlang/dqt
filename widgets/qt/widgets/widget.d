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
module qt.widgets.widget;
extern(C++):

import core.stdc.config;
import qt.config;
import qt.core.bytearray;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.global;
import qt.core.list;
import qt.core.locale;
import qt.core.margins;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.variant;
import qt.gui.bitmap;
import qt.gui.event;
import qt.gui.font;
import qt.gui.fontinfo;
import qt.gui.fontmetrics;
import qt.gui.icon;
import qt.gui.paintdevice;
import qt.gui.paintengine;
import qt.gui.painter;
import qt.gui.palette;
import qt.gui.pixmap;
import qt.gui.region;
import qt.gui.screen;
import qt.gui.windowdefs;
import qt.helpers;
import qt.widgets.layout;
import qt.widgets.sizepolicy;
import qt.widgets.style;
version(QT_NO_ACTION){}else
{
    import qt.widgets.action;
    import qt.widgets.event;
}
version(QT_NO_CURSOR){}else
    import qt.gui.cursor;
version(QT_NO_SHORTCUT){}else
    import qt.gui.keysequence;


alias QWidgetList = QList!(QWidget);
/+ #ifdef QT_INCLUDE_COMPAT
#endif



class QLayout; +/
extern(C++, class) struct QWSRegionManager;
/+ class QStyle;
class QVariant;
class QWindow;class QMouseEvent;
class QWheelEvent;
class QHoverEvent;
class QKeyEvent;
class QFocusEvent;
class QPaintEvent;
class QMoveEvent;
class QResizeEvent;
class QCloseEvent;
class QTabletEvent;
class QDragEnterEvent;
class QDragMoveEvent;
class QDragLeaveEvent;
class QDropEvent;
class QScreen;
class QShowEvent;
class QHideEvent;
class QIcon; +/
extern(C++, class) struct QBackingStore;
extern(C++, class) struct QPlatformWindow;
/+ class QLocale; +/
extern(C++, class) struct QGraphicsProxyWidget;
extern(C++, class) struct QGraphicsEffect;
extern(C++, class) struct QRasterWindowSurface;
extern(C++, class) struct QUnifiedToolbarSurface;
/+ class QPixmap;
#ifndef QT_NO_DEBUG_STREAM
class QDebug;
#endif +/

extern(C++, class) struct QWidgetData
{
public:
    WId winid;
    uint widget_attributes;
    /+ Qt:: +/qt.core.namespace.WindowFlags window_flags;
    /+ uint window_state : 4; +/
    uint bitfieldData_window_state;
    final uint window_state() const
    {
        return (bitfieldData_window_state >> 0) & 0xf;
    }
    final uint window_state(uint value)
    {
        bitfieldData_window_state = (bitfieldData_window_state & ~0xf) | ((value & 0xf) << 0);
        return value;
    }
    /+ uint focus_policy : 4; +/
    final uint focus_policy() const
    {
        return (bitfieldData_window_state >> 4) & 0xf;
    }
    final uint focus_policy(uint value)
    {
        bitfieldData_window_state = (bitfieldData_window_state & ~0xf0) | ((value & 0xf) << 4);
        return value;
    }
    /+ uint sizehint_forced :1; +/
    final uint sizehint_forced() const
    {
        return (bitfieldData_window_state >> 8) & 0x1;
    }
    final uint sizehint_forced(uint value)
    {
        bitfieldData_window_state = (bitfieldData_window_state & ~0x100) | ((value & 0x1) << 8);
        return value;
    }
    /+ uint is_closing :1; +/
    final uint is_closing() const
    {
        return (bitfieldData_window_state >> 9) & 0x1;
    }
    final uint is_closing(uint value)
    {
        bitfieldData_window_state = (bitfieldData_window_state & ~0x200) | ((value & 0x1) << 9);
        return value;
    }
    /+ uint in_show : 1; +/
    final uint in_show() const
    {
        return (bitfieldData_window_state >> 10) & 0x1;
    }
    final uint in_show(uint value)
    {
        bitfieldData_window_state = (bitfieldData_window_state & ~0x400) | ((value & 0x1) << 10);
        return value;
    }
    /+ uint in_set_window_state : 1; +/
    final uint in_set_window_state() const
    {
        return (bitfieldData_window_state >> 11) & 0x1;
    }
    final uint in_set_window_state(uint value)
    {
        bitfieldData_window_state = (bitfieldData_window_state & ~0x800) | ((value & 0x1) << 11);
        return value;
    }
    /+ mutable uint fstrut_dirty : 1; +/
    final uint fstrut_dirty() const
    {
        return (bitfieldData_window_state >> 12) & 0x1;
    }
    final uint fstrut_dirty(uint value)
    {
        bitfieldData_window_state = (bitfieldData_window_state & ~0x1000) | ((value & 0x1) << 12);
        return value;
    }
    /+ uint context_menu_policy : 3; +/
    final uint context_menu_policy() const
    {
        return (bitfieldData_window_state >> 13) & 0x7;
    }
    final uint context_menu_policy(uint value)
    {
        bitfieldData_window_state = (bitfieldData_window_state & ~0xe000) | ((value & 0x7) << 13);
        return value;
    }
    /+ uint window_modality : 2; +/
    final uint window_modality() const
    {
        return (bitfieldData_window_state >> 16) & 0x3;
    }
    final uint window_modality(uint value)
    {
        bitfieldData_window_state = (bitfieldData_window_state & ~0x30000) | ((value & 0x3) << 16);
        return value;
    }
    /+ uint in_destructor : 1; +/
    final uint in_destructor() const
    {
        return (bitfieldData_window_state >> 18) & 0x1;
    }
    final uint in_destructor(uint value)
    {
        bitfieldData_window_state = (bitfieldData_window_state & ~0x40000) | ((value & 0x1) << 18);
        return value;
    }
    /+ uint unused : 13; +/
    final uint unused() const
    {
        return (bitfieldData_window_state >> 19) & 0x1fff;
    }
    final uint unused(uint value)
    {
        bitfieldData_window_state = (bitfieldData_window_state & ~0xfff80000) | ((value & 0x1fff) << 19);
        return value;
    }
    QRect crect;
    /+ mutable +/ QPalette pal;
    QFont fnt;
    QRect wrect;
}

extern(C++, class) struct QWidgetPrivate;

class /+ Q_WIDGETS_EXPORT +/ QWidget : QObject, QPaintDeviceInterface
{
    import qt.core.namespace;
    QPaintDeviceFakeInheritance baseQPaintDeviceInterface;

    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QWidget) +/

    /+ Q_PROPERTY(bool modal READ isModal)
    Q_PROPERTY(Qt::WindowModality windowModality READ windowModality WRITE setWindowModality)
    Q_PROPERTY(bool enabled READ isEnabled WRITE setEnabled)
    Q_PROPERTY(QRect geometry READ geometry WRITE setGeometry)
    Q_PROPERTY(QRect frameGeometry READ frameGeometry)
    Q_PROPERTY(QRect normalGeometry READ normalGeometry)
    Q_PROPERTY(int x READ x)
    Q_PROPERTY(int y READ y)
    Q_PROPERTY(QPoint pos READ pos WRITE move DESIGNABLE false STORED false)
    Q_PROPERTY(QSize frameSize READ frameSize)
    Q_PROPERTY(QSize size READ size WRITE resize DESIGNABLE false STORED false)
    Q_PROPERTY(int width READ width)
    Q_PROPERTY(int height READ height)
    Q_PROPERTY(QRect rect READ rect)
    Q_PROPERTY(QRect childrenRect READ childrenRect)
    Q_PROPERTY(QRegion childrenRegion READ childrenRegion)
    Q_PROPERTY(QSizePolicy sizePolicy READ sizePolicy WRITE setSizePolicy)
    Q_PROPERTY(QSize minimumSize READ minimumSize WRITE setMinimumSize)
    Q_PROPERTY(QSize maximumSize READ maximumSize WRITE setMaximumSize)
    Q_PROPERTY(int minimumWidth READ minimumWidth WRITE setMinimumWidth STORED false DESIGNABLE false)
    Q_PROPERTY(int minimumHeight READ minimumHeight WRITE setMinimumHeight STORED false DESIGNABLE false)
    Q_PROPERTY(int maximumWidth READ maximumWidth WRITE setMaximumWidth STORED false DESIGNABLE false)
    Q_PROPERTY(int maximumHeight READ maximumHeight WRITE setMaximumHeight STORED false DESIGNABLE false)
    Q_PROPERTY(QSize sizeIncrement READ sizeIncrement WRITE setSizeIncrement)
    Q_PROPERTY(QSize baseSize READ baseSize WRITE setBaseSize)
    Q_PROPERTY(QPalette palette READ palette WRITE setPalette)
    Q_PROPERTY(QFont font READ font WRITE setFont)
#ifndef QT_NO_CURSOR
    Q_PROPERTY(QCursor cursor READ cursor WRITE setCursor RESET unsetCursor)
#endif
    Q_PROPERTY(bool mouseTracking READ hasMouseTracking WRITE setMouseTracking)
    Q_PROPERTY(bool tabletTracking READ hasTabletTracking WRITE setTabletTracking)
    Q_PROPERTY(bool isActiveWindow READ isActiveWindow)
    Q_PROPERTY(Qt::FocusPolicy focusPolicy READ focusPolicy WRITE setFocusPolicy)
    Q_PROPERTY(bool focus READ hasFocus)
    Q_PROPERTY(Qt::ContextMenuPolicy contextMenuPolicy READ contextMenuPolicy WRITE setContextMenuPolicy)
    Q_PROPERTY(bool updatesEnabled READ updatesEnabled WRITE setUpdatesEnabled DESIGNABLE false)
    Q_PROPERTY(bool visible READ isVisible WRITE setVisible DESIGNABLE false)
    Q_PROPERTY(bool minimized READ isMinimized)
    Q_PROPERTY(bool maximized READ isMaximized)
    Q_PROPERTY(bool fullScreen READ isFullScreen)
    Q_PROPERTY(QSize sizeHint READ sizeHint)
    Q_PROPERTY(QSize minimumSizeHint READ minimumSizeHint)
    Q_PROPERTY(bool acceptDrops READ acceptDrops WRITE setAcceptDrops)
    Q_PROPERTY(QString windowTitle READ windowTitle WRITE setWindowTitle NOTIFY windowTitleChanged)
    Q_PROPERTY(QIcon windowIcon READ windowIcon WRITE setWindowIcon NOTIFY windowIconChanged)
    Q_PROPERTY(QString windowIconText READ windowIconText WRITE setWindowIconText NOTIFY windowIconTextChanged) // deprecated
    Q_PROPERTY(double windowOpacity READ windowOpacity WRITE setWindowOpacity)
    Q_PROPERTY(bool windowModified READ isWindowModified WRITE setWindowModified)
#ifndef QT_NO_TOOLTIP
    Q_PROPERTY(QString toolTip READ toolTip WRITE setToolTip)
    Q_PROPERTY(int toolTipDuration READ toolTipDuration WRITE setToolTipDuration)
#endif
#if QT_CONFIG(statustip)
    Q_PROPERTY(QString statusTip READ statusTip WRITE setStatusTip)
#endif
#if QT_CONFIG(whatsthis)
    Q_PROPERTY(QString whatsThis READ whatsThis WRITE setWhatsThis)
#endif
#ifndef QT_NO_ACCESSIBILITY
    Q_PROPERTY(QString accessibleName READ accessibleName WRITE setAccessibleName)
    Q_PROPERTY(QString accessibleDescription READ accessibleDescription WRITE setAccessibleDescription)
#endif
    Q_PROPERTY(Qt::LayoutDirection layoutDirection READ layoutDirection WRITE setLayoutDirection RESET unsetLayoutDirection)
    QDOC_PROPERTY(Qt::WindowFlags windowFlags READ windowFlags WRITE setWindowFlags)
    Q_PROPERTY(bool autoFillBackground READ autoFillBackground WRITE setAutoFillBackground)
#ifndef QT_NO_STYLE_STYLESHEET
    Q_PROPERTY(QString styleSheet READ styleSheet WRITE setStyleSheet)
#endif
    Q_PROPERTY(QLocale locale READ locale WRITE setLocale RESET unsetLocale)
    Q_PROPERTY(QString windowFilePath READ windowFilePath WRITE setWindowFilePath)
    Q_PROPERTY(Qt::InputMethodHints inputMethodHints READ inputMethodHints WRITE setInputMethodHints) +/

public:
    enum RenderFlag {
        DrawWindowBackground = 0x1,
        DrawChildren = 0x2,
        IgnoreMask = 0x4
    }
    /+ Q_DECLARE_FLAGS(RenderFlags, RenderFlag) +/
alias RenderFlags = QFlags!(RenderFlag);
    /+ explicit +/this(QWidget parent = null, /+ Qt:: +/qt.core.namespace.WindowFlags f = /+ Qt:: +/qt.core.namespace.WindowFlags());
    ~this();

    override int devType() const;

    final WId winId() const;
    final void createWinId(); // internal, going away
    pragma(inline, true) final WId internalWinId() const { return data.winid; }
    final WId effectiveWinId() const;

    // GUI style setting
    final QStyle style() const;
    final void setStyle(QStyle );
    // Widget types and states

    pragma(inline, true) final bool isTopLevel() const
    { return (cast(bool)(windowType() & /+ Qt:: +/qt.core.namespace.WindowType.Window)); }
    pragma(inline, true) final bool isWindow() const
    { return (cast(bool)(windowType() & /+ Qt:: +/qt.core.namespace.WindowType.Window)); }

    pragma(inline, true) final bool isModal() const
    { return data.window_modality != /+ Qt:: +/qt.core.namespace.WindowModality.NonModal; }
    final /+ Qt:: +/qt.core.namespace.WindowModality windowModality() const;
    final void setWindowModality(/+ Qt:: +/qt.core.namespace.WindowModality windowModality);

    pragma(inline, true) final bool isEnabled() const
    { return !testAttribute(/+ Qt:: +/qt.core.namespace.WidgetAttribute.WA_Disabled); }
    final bool isEnabledTo(const(QWidget) ) const;
/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X ("Use isEnabled() instead") +/
        pragma(inline, true) final bool isEnabledToTLW() const
    { return isEnabled(); }
/+ #endif +/

public /+ Q_SLOTS +/:
    @QSlot final void setEnabled(bool);
    @QSlot final void setDisabled(bool);
    @QSlot final void setWindowModified(bool);

    // Widget coordinates

public:
    final QRect frameGeometry() const;
    pragma(inline, true) final ref const(QRect) geometry() const
    { return data.crect; }
    final QRect normalGeometry() const;

    final int x() const;
    final int y() const;
    final QPoint pos() const;
    final QSize frameSize() const;
    pragma(inline, true) final QSize size() const
    { return data.crect.size(); }
    pragma(inline, true) final int width() const
    { return data.crect.width(); }
    pragma(inline, true) final int height() const
    { return data.crect.height(); }
    pragma(inline, true) final QRect rect() const
    { return QRect(0,0,data.crect.width(),data.crect.height()); }
    final QRect childrenRect() const;
    final QRegion childrenRegion() const;

    final QSize minimumSize() const;
    final QSize maximumSize() const;
    pragma(inline, true) final int minimumWidth() const
    { return minimumSize().width(); }
    pragma(inline, true) final int minimumHeight() const
    { return minimumSize().height(); }
    pragma(inline, true) final int maximumWidth() const
    { return maximumSize().width(); }
    pragma(inline, true) final int maximumHeight() const
    { return maximumSize().height(); }
    pragma(inline, true) final void setMinimumSize(ref const(QSize) s)
    { setMinimumSize(s.width(),s.height()); }
    final void setMinimumSize(int minw, int minh);
    pragma(inline, true) final void setMaximumSize(ref const(QSize) s)
    { setMaximumSize(s.width(),s.height()); }
    final void setMaximumSize(int maxw, int maxh);
    final void setMinimumWidth(int minw);
    final void setMinimumHeight(int minh);
    final void setMaximumWidth(int maxw);
    final void setMaximumHeight(int maxh);

/+ #ifdef Q_QDOC
    void setupUi(QWidget *widget);
#endif +/

    final QSize sizeIncrement() const;
    pragma(inline, true) final void setSizeIncrement(ref const(QSize) s)
    { setSizeIncrement(s.width(),s.height()); }
    final void setSizeIncrement(int w, int h);
    final QSize baseSize() const;
    pragma(inline, true) final void setBaseSize(ref const(QSize) s)
    { setBaseSize(s.width(),s.height()); }
    final void setBaseSize(int basew, int baseh);

    final void setFixedSize(ref const(QSize) );
    final void setFixedSize(int w, int h);
    final void setFixedWidth(int w);
    final void setFixedHeight(int h);

    // Widget coordinate mapping

    final QPoint mapToGlobal(ref const(QPoint) ) const;
    final QPoint mapFromGlobal(ref const(QPoint) ) const;
    final QPoint mapToParent(ref const(QPoint) ) const;
    final QPoint mapFromParent(ref const(QPoint) ) const;
    final QPoint mapTo(const(QWidget) , ref const(QPoint) ) const;
    final QPoint mapFrom(const(QWidget) , ref const(QPoint) ) const;

    final QWidget window() const;
    final QWidget nativeParentWidget() const;
    pragma(inline, true) final QWidget topLevelWidget() const { return window(); }

    // Widget appearance functions
    final ref const(QPalette) palette() const;
    final void setPalette(ref const(QPalette) );

    final void setBackgroundRole(QPalette.ColorRole);
    final QPalette.ColorRole backgroundRole() const;

    final void setForegroundRole(QPalette.ColorRole);
    final QPalette.ColorRole foregroundRole() const;

    pragma(inline, true) final ref const(QFont) font() const
    { return data.fnt; }
    final void setFont(ref const(QFont) );
    pragma(inline, true) final QFontMetrics fontMetrics() const
    { auto tmp = data.fnt; return QFontMetrics(tmp); }
    pragma(inline, true) final QFontInfo fontInfo() const
    { auto tmp = data.fnt; return QFontInfo(tmp); }

    version(QT_NO_CURSOR){}else
    {
        final QCursor cursor() const;
        final void setCursor(ref const(QCursor) );
        final void unsetCursor();
    }

    pragma(inline, true) final void setMouseTracking(bool enable)
    { setAttribute(/+ Qt:: +/qt.core.namespace.WidgetAttribute.WA_MouseTracking, enable); }
    pragma(inline, true) final bool hasMouseTracking() const
    { return testAttribute(/+ Qt:: +/qt.core.namespace.WidgetAttribute.WA_MouseTracking); }
    pragma(inline, true) final bool underMouse() const
    { return testAttribute(/+ Qt:: +/qt.core.namespace.WidgetAttribute.WA_UnderMouse); }

    pragma(inline, true) final void setTabletTracking(bool enable)
    { setAttribute(/+ Qt:: +/qt.core.namespace.WidgetAttribute.WA_TabletTracking, enable); }
    pragma(inline, true) final bool hasTabletTracking() const
    { return testAttribute(/+ Qt:: +/qt.core.namespace.WidgetAttribute.WA_TabletTracking); }

    final void setMask(ref const(QBitmap) );
    final void setMask(ref const(QRegion) );
    final QRegion mask() const;
    final void clearMask();

    final void render(QPaintDevice target, ref const(QPoint) targetOffset = globalInitVar!QPoint,
                    ref const(QRegion) sourceRegion = globalInitVar!QRegion,
                    RenderFlags renderFlags = RenderFlags(RenderFlag.DrawWindowBackground | RenderFlag.DrawChildren));

    final void render(QPainter* painter, ref const(QPoint) targetOffset = globalInitVar!QPoint,
                    ref const(QRegion) sourceRegion = globalInitVar!QRegion,
                    RenderFlags renderFlags = RenderFlags(RenderFlag.DrawWindowBackground | RenderFlag.DrawChildren));

    @QInvokable final QPixmap grab(ref const(QRect) rectangle /+ = QRect(QPoint(0, 0), QSize(-1, -1)) +/);

/+ #if QT_CONFIG(graphicseffect) +/
    final QGraphicsEffect* graphicsEffect() const;
    final void setGraphicsEffect(QGraphicsEffect* effect);
/+ #endif // QT_CONFIG(graphicseffect)

#ifndef QT_NO_GESTURES +/
    version(QT_NO_GESTURES){}else
    {
        final void grabGesture(/+ Qt:: +/qt.core.namespace.GestureType type, /+ Qt:: +/qt.core.namespace.GestureFlags flags = /+ Qt:: +/qt.core.namespace.GestureFlags());
        final void ungrabGesture(/+ Qt:: +/qt.core.namespace.GestureType type);
    }
/+ #endif +/

public /+ Q_SLOTS +/:
    @QSlot final void setWindowTitle(ref const(QString) );
    final void setWindowTitle(const QString s){setWindowTitle(s);}
    version(QT_NO_STYLE_STYLESHEET){}else
    {
        @QSlot final void setStyleSheet(ref const(QString) styleSheet);
    }
public:
    version(QT_NO_STYLE_STYLESHEET){}else
    {
        final QString styleSheet() const;
    }
    final QString windowTitle() const;
    final void setWindowIcon(ref const(QIcon) icon);
    final QIcon windowIcon() const;
    final void setWindowIconText(ref const(QString) );
    final QString windowIconText() const;
    final void setWindowRole(ref const(QString) );
    final QString windowRole() const;
    final void setWindowFilePath(ref const(QString) filePath);
    final QString windowFilePath() const;

    final void setWindowOpacity(qreal level);
    final qreal windowOpacity() const;

    final bool isWindowModified() const;
/+ #ifndef QT_NO_TOOLTIP +/
    version(QT_NO_TOOLTIP){}else
    {
        final void setToolTip(ref const(QString) );
        final QString toolTip() const;
        final void setToolTipDuration(int msec);
        final int toolTipDuration() const;
    }
/+ #endif
#if QT_CONFIG(statustip) +/
    final void setStatusTip(ref const(QString) );
    final QString statusTip() const;
/+ #endif
#if QT_CONFIG(whatsthis) +/
    final void setWhatsThis(ref const(QString) );
    final QString whatsThis() const;
/+ #endif
#ifndef QT_NO_ACCESSIBILITY +/
    version(QT_NO_ACCESSIBILITY){}else
    {
        final QString accessibleName() const;
        final void setAccessibleName(ref const(QString) name);
        final QString accessibleDescription() const;
        final void setAccessibleDescription(ref const(QString) description);
    }
/+ #endif +/

    final void setLayoutDirection(/+ Qt:: +/qt.core.namespace.LayoutDirection direction);
    final /+ Qt:: +/qt.core.namespace.LayoutDirection layoutDirection() const;
    final void unsetLayoutDirection();

    final void setLocale(ref const(QLocale) locale);
    final QLocale locale() const;
    final void unsetLocale();

    pragma(inline, true) final bool isRightToLeft() const { return layoutDirection() == /+ Qt:: +/qt.core.namespace.LayoutDirection.RightToLeft; }
    pragma(inline, true) final bool isLeftToRight() const { return layoutDirection() == /+ Qt:: +/qt.core.namespace.LayoutDirection.LeftToRight; }

public /+ Q_SLOTS +/:
    pragma(inline, true) @QSlot final void setFocus() { setFocus(/+ Qt:: +/qt.core.namespace.FocusReason.OtherFocusReason); }

public:
    final bool isActiveWindow() const;
    final void activateWindow();
    final void clearFocus();

    final void setFocus(/+ Qt:: +/qt.core.namespace.FocusReason reason);
    final /+ Qt:: +/qt.core.namespace.FocusPolicy focusPolicy() const;
    final void setFocusPolicy(/+ Qt:: +/qt.core.namespace.FocusPolicy policy);
    final bool hasFocus() const;
    static void setTabOrder(QWidget , QWidget );
    final void setFocusProxy(QWidget );
    final QWidget focusProxy() const;
    final /+ Qt:: +/qt.core.namespace.ContextMenuPolicy contextMenuPolicy() const;
    final void setContextMenuPolicy(/+ Qt:: +/qt.core.namespace.ContextMenuPolicy policy);

    // Grab functions
    final void grabMouse();
    version(QT_NO_CURSOR){}else
    {
        final void grabMouse(ref const(QCursor) );
    }
    final void releaseMouse();
    final void grabKeyboard();
    final void releaseKeyboard();
    version(QT_NO_SHORTCUT){}else
    {
        final int grabShortcut(ref const(QKeySequence) key, /+ Qt:: +/qt.core.namespace.ShortcutContext context = /+ Qt:: +/qt.core.namespace.ShortcutContext.WindowShortcut);
        final void releaseShortcut(int id);
        final void setShortcutEnabled(int id, bool enable = true);
        final void setShortcutAutoRepeat(int id, bool enable = true);
    }
    static QWidget mouseGrabber();
    static QWidget keyboardGrabber();

    // Update/refresh functions
    pragma(inline, true) final bool updatesEnabled() const
    { return !testAttribute(/+ Qt:: +/qt.core.namespace.WidgetAttribute.WA_UpdatesDisabled); }
    final void setUpdatesEnabled(bool enable);

/+ #if QT_CONFIG(graphicsview) +/
    final QGraphicsProxyWidget* graphicsProxyWidget() const;
/+ #endif +/

public /+ Q_SLOTS +/:
    @QSlot final void update();
    @QSlot final void repaint();

public:
    pragma(inline, true) final void update(int ax, int ay, int aw, int ah)
    { auto tmp = QRect(ax, ay, aw, ah); update(tmp); }
    final void update(ref const(QRect));
    final void update(ref const(QRegion));

    final void repaint(int x, int y, int w, int h);
    final void repaint(ref const(QRect) );
    final void repaint(ref const(QRegion) );

public /+ Q_SLOTS +/:
    // Widget management functions

    /+ virtual +/ @QSlot void setVisible(bool visible);
    @QSlot final void setHidden(bool hidden);
    @QSlot final void show();
    @QSlot final void hide();

    @QSlot final void showMinimized();
    @QSlot final void showMaximized();
    @QSlot final void showFullScreen();
    @QSlot final void showNormal();

    @QSlot final bool close();
    @QSlot final void raise();
    @QSlot final void lower();

public:
    final void stackUnder(QWidget);
    pragma(inline, true) final void move(int ax, int ay)
    { auto tmp = QPoint(ax, ay); move(tmp); }
    final void move(ref const(QPoint) );
    final void move(const(QPoint) p)
    {
        move(p);
    }

    pragma(inline, true) final void resize(int w, int h)
    { auto tmp = QSize(w, h); resize(tmp); }
    final void resize(ref const(QSize) );
    pragma(inline, true) final void setGeometry(int ax, int ay, int aw, int ah)
    { auto tmp = QRect(ax, ay, aw, ah); setGeometry(tmp); }
    final void setGeometry(ref const(QRect) );
    final QByteArray saveGeometry() const;
    final bool restoreGeometry(ref const(QByteArray) geometry);
    final void adjustSize();
    pragma(inline, true) final bool isVisible() const
    { return testAttribute(/+ Qt:: +/qt.core.namespace.WidgetAttribute.WA_WState_Visible); }
    final bool isVisibleTo(const(QWidget) ) const;
    pragma(inline, true) final bool isHidden() const
    { return testAttribute(/+ Qt:: +/qt.core.namespace.WidgetAttribute.WA_WState_Hidden); }

    final bool isMinimized() const;
    final bool isMaximized() const;
    final bool isFullScreen() const;

    final /+ Qt:: +/qt.core.namespace.WindowStates windowState() const;
    final void setWindowState(/+ Qt:: +/qt.core.namespace.WindowStates state);
    final void overrideWindowState(/+ Qt:: +/qt.core.namespace.WindowStates state);

    /+ virtual +/ QSize sizeHint() const;
    /+ virtual +/ QSize minimumSizeHint() const;

    final QSizePolicy sizePolicy() const;
    final void setSizePolicy(QSizePolicy);
/+    pragma(inline, true) final void setSizePolicy(QSizePolicy.Policy hor, QSizePolicy.Policy ver)
    { setSizePolicy(QSizePolicy(hor, ver)); }
+/
    /+ virtual +/ int heightForWidth(int) const;
    /+ virtual +/ bool hasHeightForWidth() const;

    final QRegion visibleRegion() const;

    final void setContentsMargins(int left, int top, int right, int bottom);
    final void setContentsMargins(ref const(QMargins) margins);
/+ #if QT_DEPRECATED_SINCE(5, 14) +/
    /+ QT_DEPRECATED_X("use contentsMargins()") +/
        final void getContentsMargins(int* left, int* top, int* right, int* bottom) const;
/+ #endif +/
    final QMargins contentsMargins() const;

    final QRect contentsRect() const;

public:
    final QLayout layout() const;
    final void setLayout(QLayout );
    final void updateGeometry();

    final void setParent(QWidget parent);
    final void setParent(QWidget parent, /+ Qt:: +/qt.core.namespace.WindowFlags f);

    final void scroll(int dx, int dy);
    final void scroll(int dx, int dy, ref const(QRect));

    // Misc. functions

    final QWidget focusWidget() const;
    final QWidget nextInFocusChain() const;
    final QWidget previousInFocusChain() const;

    // drag and drop
    final bool acceptDrops() const;
    final void setAcceptDrops(bool on);

    version(QT_NO_ACTION){}else
    {
        //actions
        final void addAction(QAction action);
    /+ #if QT_VERSION >= QT_VERSION_CHECK(6,0,0)
        void addActions(const QList<QAction*> &actions);
        void insertActions(QAction *before, const QList<QAction*> &actions);
    #else +/
        final void addActions(QList!(QAction) actions);
        final void insertActions(QAction before, QList!(QAction) actions);
    /+ #endif +/
        final void insertAction(QAction before, QAction action);
        final void removeAction(QAction action);
        final QList!(QAction) actions() const;
    }

    pragma(inline, true) final QWidget parentWidget() const
    { return static_cast!(QWidget)(QObject.parent()); }

    final void setWindowFlags(/+ Qt:: +/qt.core.namespace.WindowFlags type);
    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.WindowFlags windowFlags() const
    { return data.window_flags; }
    final void setWindowFlag(/+ Qt:: +/qt.core.namespace.WindowType, bool on = true);
    final void overrideWindowFlags(/+ Qt:: +/qt.core.namespace.WindowFlags type);

    pragma(inline, true) final /+ Qt:: +/qt.core.namespace.WindowType windowType() const
    { return static_cast!(/+ Qt:: +/qt.core.namespace.WindowType)(int((data.window_flags & /+ Qt:: +/qt.core.namespace.WindowType.WindowType_Mask))); }

    /+ static QWidget *find(WId); +/
    pragma(inline, true) final QWidget childAt(int ax, int ay) const
    { auto tmp = QPoint(ax, ay); return childAt(tmp); }
    final QWidget childAt(ref const(QPoint) p) const;

    final void setAttribute(/+ Qt:: +/qt.core.namespace.WidgetAttribute, bool on = true);
    pragma(inline, true) final bool testAttribute(/+ Qt:: +/qt.core.namespace.WidgetAttribute attribute) const
    {
        if (attribute < cast(int)(8*uint.sizeof))
            return (data.widget_attributes & (1<<attribute)) != 0;
        return testAttribute_helper(attribute);
    }

    override QPaintEngine paintEngine() const;

    final void ensurePolished() const;

    final bool isAncestorOf(const(QWidget) child) const;

    version(QT_KEYPAD_NAVIGATION)
    {
        final bool hasEditFocus() const;
        final void setEditFocus(bool on);
    }

    final bool autoFillBackground() const;
    final void setAutoFillBackground(bool enabled);

    final QBackingStore* backingStore() const;

    final QWindow* windowHandle() const;
    final QScreen screen() const;

    static QWidget createWindowContainer(QWindow* window, QWidget parent=null, /+ Qt:: +/qt.core.namespace.WindowFlags flags=/+ Qt:: +/qt.core.namespace.WindowFlags());

    /+ friend class QDesktopScreenWidget; +/

/+ Q_SIGNALS +/public:
    @QSignal final void windowTitleChanged(ref const(QString) title);
    @QSignal final void windowIconChanged(ref const(QIcon) icon);
    @QSignal final void windowIconTextChanged(ref const(QString) iconText);
    @QSignal final void customContextMenuRequested(ref const(QPoint) pos);

protected:
    // Event handlers
    override bool event(QEvent event);
    /+ virtual +/ void mousePressEvent(QMouseEvent event);
    /+ virtual +/ void mouseReleaseEvent(QMouseEvent event);
    /+ virtual +/ void mouseDoubleClickEvent(QMouseEvent event);
    /+ virtual +/ void mouseMoveEvent(QMouseEvent event);
/+ #if QT_CONFIG(wheelevent) +/
    /+ virtual +/ void wheelEvent(QWheelEvent event);
/+ #endif +/
    /+ virtual +/ void keyPressEvent(QKeyEvent event);
    /+ virtual +/ void keyReleaseEvent(QKeyEvent event);
    /+ virtual +/ void focusInEvent(QFocusEvent event);
    /+ virtual +/ void focusOutEvent(QFocusEvent event);
    /+ virtual +/ void enterEvent(QEvent event);
    /+ virtual +/ void leaveEvent(QEvent event);
    /+ virtual +/ void paintEvent(QPaintEvent event);
    /+ virtual +/ void moveEvent(QMoveEvent event);
    /+ virtual +/ void resizeEvent(QResizeEvent event);
    /+ virtual +/ void closeEvent(QCloseEvent event);
/+ #ifndef QT_NO_CONTEXTMENU +/
    version(QT_NO_CONTEXTMENU){}else
    {
        /+ virtual +/ void contextMenuEvent(QContextMenuEvent event);
    }
/+ #endif
#if QT_CONFIG(tabletevent) +/
    /+ virtual +/ void tabletEvent(QTabletEvent event);
/+ #endif
#ifndef QT_NO_ACTION +/
    version(QT_NO_ACTION){}else
    {
        /+ virtual +/ void actionEvent(QActionEvent event);
    }
/+ #endif

#if QT_CONFIG(draganddrop) +/
    /+ virtual +/ void dragEnterEvent(QDragEnterEvent event);
    /+ virtual +/ void dragMoveEvent(QDragMoveEvent event);
    /+ virtual +/ void dragLeaveEvent(QDragLeaveEvent event);
    /+ virtual +/ void dropEvent(QDropEvent event);
/+ #endif +/

    /+ virtual +/ void showEvent(QShowEvent event);
    /+ virtual +/ void hideEvent(QHideEvent event);

/+ #if QT_VERSION >= QT_VERSION_CHECK(6, 0, 0)
    virtual bool nativeEvent(const QByteArray &eventType, void *message, qintptr *result);
#else +/
    /+ virtual +/ bool nativeEvent(ref const(QByteArray) eventType, void* message, cpp_long* result);
/+ #endif +/

    // Misc. protected functions
    /+ virtual +/ void changeEvent(QEvent );

    override int metric(PaintDeviceMetric) const;
    override void initPainter(QPainter* painter) const;
    override QPaintDevice redirected(QPoint* offset) const;
    override QPainter* sharedPainter() const;

    /+ virtual +/ void inputMethodEvent(QInputMethodEvent );
public:
    /+ virtual +/ QVariant inputMethodQuery(/+ Qt:: +/qt.core.namespace.InputMethodQuery) const;

    final /+ Qt:: +/qt.core.namespace.InputMethodHints inputMethodHints() const;
    final void setInputMethodHints(/+ Qt:: +/qt.core.namespace.InputMethodHints hints);

protected /+ Q_SLOTS +/:
    @QSlot final void updateMicroFocus();
protected:

    /+ void create(WId = 0, bool initializeWindow = true,
                         bool destroyOldWindow = true); +/
    final void destroy(bool destroyWindow = true,
                     bool destroySubWindows = true);

    /+ friend class QDataWidgetMapperPrivate; +/ // for access to focusNextPrevChild
    /+ virtual +/ bool focusNextPrevChild(bool next);
    pragma(inline, true) final bool focusNextChild() { return focusNextPrevChild(true); }
    pragma(inline, true) final bool focusPreviousChild() { return focusNextPrevChild(false); }

protected:
    this(ref QWidgetPrivate d, QWidget parent, /+ Qt:: +/qt.core.namespace.WindowFlags f);
private:
    final void setBackingStore(QBackingStore* store);

    final bool testAttribute_helper(/+ Qt:: +/qt.core.namespace.WidgetAttribute) const;

    final QLayout takeLayout();

    /+ friend class QBackingStoreDevice; +/
    /+ friend class QWidgetRepaintManager; +/
    /+ friend class QApplication; +/
    /+ friend class QApplicationPrivate; +/
    /+ friend class QGuiApplication; +/
    /+ friend class QGuiApplicationPrivate; +/
    /+ friend class QBaseApplication; +/
    /+ friend class QPainter; +/
    /+ friend class QPainterPrivate; +/
    /+ friend class QPixmap; +/ // for QPixmap::fill()
    /+ friend class QFontMetrics; +/
    /+ friend class QFontInfo; +/
    /+ friend class QLayout; +/
    /+ friend class QWidgetItem; +/
    /+ friend class QWidgetItemV2; +/
    /+ friend class QGLContext; +/
    /+ friend class QGLWidget; +/
    /+ friend class QGLWindowSurface; +/
    /+ friend class QX11PaintEngine; +/
    /+ friend class QWin32PaintEngine; +/
    /+ friend class QShortcutPrivate; +/
    /+ friend class QWindowSurface; +/
    /+ friend class QGraphicsProxyWidget; +/
    /+ friend class QGraphicsProxyWidgetPrivate; +/
    /+ friend class QStyleSheetStyle; +/
    /+ friend struct QWidgetExceptionCleaner; +/
    /+ friend class QWidgetWindow; +/
    /+ friend class QAccessibleWidget; +/
    /+ friend class QAccessibleTable; +/
    /+ friend class QAccessibleTabButton; +/
    version(QT_NO_GESTURES){}else
    {
        /+ friend class QGestureManager; +/
        /+ friend class QWinNativePanGestureRecognizer; +/
    }
    /+ friend class QWidgetEffectSourcePrivate; +/

    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ friend bool qt_mac_is_metal(const QWidget *w); +/
    }
    /+ friend Q_WIDGETS_EXPORT QWidgetData *qt_qwidget_data(QWidget *widget); +/
    /+ friend Q_WIDGETS_EXPORT QWidgetPrivate *qt_widget_private(QWidget *widget); +/

private:
    /+ Q_DISABLE_COPY(QWidget) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_showIfNotHidden()) +/

    QWidgetData* data;
}
/+pragma(inline, true) QFlags!(QWidget.RenderFlags.enum_type) operator |(QWidget.RenderFlags.enum_type f1, QWidget.RenderFlags.enum_type f2)/+noexcept+/{return QFlags!(QWidget.RenderFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QWidget.RenderFlags.enum_type) operator |(QWidget.RenderFlags.enum_type f1, QFlags!(QWidget.RenderFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QWidget.RenderFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QWidget::RenderFlags)
#ifndef Q_QDOC
template <> inline QWidget *qobject_cast<QWidget*>(QObject *o)
{
    if (!o || !o->isWidgetType()) return nullptr;
    return static_cast<QWidget*>(o);
}
template <> inline const QWidget *qobject_cast<const QWidget*>(const QObject *o)
{
    if (!o || !o->isWidgetType()) return nullptr;
    return static_cast<const QWidget*>(o);
}
#endif // !Q_QDOC

#if QT_DEPRECATED_SINCE(5, 13)
#endif


#define QWIDGETSIZE_MAX ((1<<24)-1)

#ifndef QT_NO_DEBUG_STREAM
Q_WIDGETS_EXPORT QDebug operator<<(QDebug, const QWidget *);
#endif +/

