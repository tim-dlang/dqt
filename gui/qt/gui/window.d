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
module qt.gui.window;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.coreevent;
import qt.core.global;
import qt.core.margins;
import qt.core.namespace;
import qt.core.nativeinterface;
import qt.core.object;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.gui.event;
import qt.gui.icon;
import qt.gui.region;
import qt.gui.screen;
import qt.gui.surface;
import qt.gui.surfaceformat;
import qt.gui.windowdefs;
import qt.helpers;
version (QT_NO_CURSOR) {} else
    import qt.gui.cursor;

/+ #ifndef QT_NO_CURSOR
#endif +/



extern(C++, class) struct QWindowPrivate;

/+ #if QT_CONFIG(wheelevent)
class QWheelEvent;
#endif
#if QT_CONFIG(tabletevent)
class QTabletEvent;
#endif +/

extern(C++, class) struct QPlatformWindow;
extern(C++, class) struct QAccessibleInterface;
extern(C++, class) struct QWindowContainer;
/+ #ifndef QT_NO_DEBUG_STREAM
class QDebug;
#endif
#if QT_CONFIG(vulkan) || defined(Q_CLANG_QDOC) +/
extern(C++, class) struct QVulkanInstance;
/+ #endif +/

/// Binding for C++ class [QWindow](https://doc.qt.io/qt-6/qwindow.html).
class /+ Q_GUI_EXPORT +/ QWindow : QObject, QSurfaceInterface
{
    QSurfaceFakeInheritance baseQSurfaceInterface;

    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QWindow) +/

    // All properties which are declared here are inherited by QQuickWindow and therefore available in QML.
    // So please think carefully about what it does to the QML namespace if you add any new ones,
    // particularly the possible meanings these names might have in any specializations of Window.
    // For example "state" (meaning windowState) is not a good property to declare, because it has
    // a different meaning in QQuickItem, and users will tend to assume it is the same for Window.

    // Any new properties which you add here MUST be versioned and MUST be documented both as
    // C++ properties in qwindow.cpp AND as QML properties in qquickwindow.cpp.
    // https://doc.qt.io/qt/qtqml-cppintegration-definetypes.html#type-revisions-and-versions

    /+ Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY windowTitleChanged)
    Q_PROPERTY(Qt::WindowModality modality READ modality WRITE setModality NOTIFY modalityChanged)
    Q_PROPERTY(Qt::WindowFlags flags READ flags WRITE setFlags)
    Q_PROPERTY(int x READ x WRITE setX NOTIFY xChanged)
    Q_PROPERTY(int y READ y WRITE setY NOTIFY yChanged)
    Q_PROPERTY(int width READ width WRITE setWidth NOTIFY widthChanged)
    Q_PROPERTY(int height READ height WRITE setHeight NOTIFY heightChanged)
    Q_PROPERTY(int minimumWidth READ minimumWidth WRITE setMinimumWidth NOTIFY minimumWidthChanged)
    Q_PROPERTY(int minimumHeight READ minimumHeight WRITE setMinimumHeight
               NOTIFY minimumHeightChanged)
    Q_PROPERTY(int maximumWidth READ maximumWidth WRITE setMaximumWidth NOTIFY maximumWidthChanged)
    Q_PROPERTY(int maximumHeight READ maximumHeight WRITE setMaximumHeight
               NOTIFY maximumHeightChanged)
    Q_PROPERTY(bool visible READ isVisible WRITE setVisible NOTIFY visibleChanged)
    Q_PROPERTY(bool active READ isActive NOTIFY activeChanged REVISION(2, 1))
    Q_PROPERTY(Visibility visibility READ visibility WRITE setVisibility NOTIFY visibilityChanged
               REVISION(2, 1))
    Q_PROPERTY(Qt::ScreenOrientation contentOrientation READ contentOrientation
               WRITE reportContentOrientationChange NOTIFY contentOrientationChanged)
    Q_PROPERTY(qreal opacity READ opacity WRITE setOpacity NOTIFY opacityChanged REVISION(2, 1))
#ifdef Q_QDOC
    Q_PROPERTY(QWindow* transientParent READ transientParent WRITE setTransientParent NOTIFY transientParentChanged)
#else
    Q_PRIVATE_PROPERTY(QWindow::d_func(), QWindow* transientParent MEMBER transientParent
                       WRITE setTransientParent NOTIFY transientParentChanged REVISION(2, 13))
#endif +/

public:
    enum Visibility {
        Hidden = 0,
        AutomaticVisibility,
        Windowed,
        Minimized,
        Maximized,
        FullScreen
    }
    /+ Q_ENUM(Visibility) +/

    enum AncestorMode {
        ExcludeTransients,
        IncludeTransients
    }
    /+ Q_ENUM(AncestorMode) +/

    /+ explicit +/this(QScreen screen = null);
    /+ explicit +/this(QWindow parent);
    ~this();

    final void setSurfaceType(SurfaceType surfaceType);
    override SurfaceType surfaceType() const;

    final bool isVisible() const;

    final Visibility visibility() const;
    final void setVisibility(Visibility v);

    /+ void create(); +/

    final WId winId() const;

    final QWindow parent(AncestorMode mode = AncestorMode.ExcludeTransients) const;
    final void setParent(QWindow parent);

    final bool isTopLevel() const;

    final bool isModal() const;
    final /+ Qt:: +/qt.core.namespace.WindowModality modality() const;
    final void setModality(/+ Qt:: +/qt.core.namespace.WindowModality modality);

    final void setFormat(ref const(QSurfaceFormat) format);
    override QSurfaceFormat format() const;
    final QSurfaceFormat requestedFormat() const;

    final void setFlags(/+ Qt:: +/qt.core.namespace.WindowFlags flags);
    final /+ Qt:: +/qt.core.namespace.WindowFlags flags() const;
    /+ void setFlag(Qt::WindowType, bool on = true); +/
    final /+ Qt:: +/qt.core.namespace.WindowType type() const;

    final QString title() const;

    final void setOpacity(qreal level);
    final qreal opacity() const;

    final void setMask(ref const(QRegion) region);
    final QRegion mask() const;

    final bool isActive() const;

    final void reportContentOrientationChange(/+ Qt:: +/qt.core.namespace.ScreenOrientation orientation);
    final /+ Qt:: +/qt.core.namespace.ScreenOrientation contentOrientation() const;

    final qreal devicePixelRatio() const;

    final /+ Qt:: +/qt.core.namespace.WindowState windowState() const;
    final /+ Qt:: +/qt.core.namespace.WindowStates windowStates() const;
    final void setWindowState(/+ Qt:: +/qt.core.namespace.WindowState state);
    final void setWindowStates(/+ Qt:: +/qt.core.namespace.WindowStates states);

    final void setTransientParent(QWindow parent);
    final QWindow transientParent() const;

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final bool isAncestorOf(const(QWindow) child, AncestorMode mode = AncestorMode.IncludeTransients) const;
    }));

    final bool isExposed() const;

    pragma(inline, true) final int minimumWidth() const { return minimumSize().width(); }
    pragma(inline, true) final int minimumHeight() const { return minimumSize().height(); }
    pragma(inline, true) final int maximumWidth() const { return maximumSize().width(); }
    pragma(inline, true) final int maximumHeight() const { return maximumSize().height(); }

    final QSize minimumSize() const;
    final QSize maximumSize() const;
    final QSize baseSize() const;
    final QSize sizeIncrement() const;

    final void setMinimumSize(ref const(QSize) size);
    final void setMaximumSize(ref const(QSize) size);
    final void setBaseSize(ref const(QSize) size);
    final void setSizeIncrement(ref const(QSize) size);

    final QRect geometry() const;

    final QMargins frameMargins() const;
    final QRect frameGeometry() const;

    final QPoint framePosition() const;
    final void setFramePosition(ref const(QPoint) point);

    pragma(inline, true) final int width() const { return geometry().width(); }
    pragma(inline, true) final int height() const { return geometry().height(); }
    pragma(inline, true) final int x() const { return geometry().x(); }
    pragma(inline, true) final int y() const { return geometry().y(); }

    override QSize size() const { return geometry().size(); }
    pragma(inline, true) final QPoint position() const { return geometry().topLeft(); }

    final void setPosition(ref const(QPoint) pt);
    final void setPosition(int posx, int posy);

    final void resize(ref const(QSize) newSize);
    final void resize(int w, int h);

    final void setFilePath(ref const(QString) filePath);
    final QString filePath() const;

    final void setIcon(ref const(QIcon) icon);
    final QIcon icon() const;

    final void destroy();

    final QPlatformWindow* handle() const;

    final bool setKeyboardGrabEnabled(bool grab);
    final bool setMouseGrabEnabled(bool grab);

    final QScreen screen() const;
    final void setScreen(QScreen screen);

    /+ virtual +/ QAccessibleInterface* accessibleRoot() const;
    /+ virtual +/ QObject focusObject() const;

    final QPointF mapToGlobal(ref const(QPointF) pos) const;
    final QPointF mapFromGlobal(ref const(QPointF) pos) const;
    final QPoint mapToGlobal(ref const(QPoint) pos) const;
    final QPoint mapFromGlobal(ref const(QPoint) pos) const;

    version (QT_NO_CURSOR) {} else
    {
        final QCursor cursor() const;
        final void setCursor(ref const(QCursor) );
        final void unsetCursor();
    }

    static QWindow fromWinId(WId id);

/+ #if QT_CONFIG(vulkan) || defined(Q_CLANG_QDOC) +/
    /*final void setVulkanInstance(QVulkanInstance* instance);
    final QVulkanInstance* vulkanInstance() const;*/
/+ #endif +/

    mixin(QT_DECLARE_NATIVE_INTERFACE_ACCESSOR(q{ValueClass!(QWindow)}));

public /+ Q_SLOTS +/:
    /+ Q_REVISION(2, 1) +/ @QSlot final void requestActivate();

    @QSlot final void setVisible(bool visible);

    @QSlot final void show();
    @QSlot final void hide();

    @QSlot final void showMinimized();
    @QSlot final void showMaximized();
    @QSlot final void showFullScreen();
    @QSlot final void showNormal();

    @QSlot final bool close();
    @QSlot final void raise();
    @QSlot final void lower();
    @QSlot final bool startSystemResize(/+ Qt:: +/qt.core.namespace.Edges edges);
    @QSlot final bool startSystemMove();

    @QSlot final void setTitle(ref const(QString) );

    @QSlot final void setX(int arg);
    @QSlot final void setY(int arg);
    @QSlot final void setWidth(int arg);
    @QSlot final void setHeight(int arg);
    @QSlot final void setGeometry(int posx, int posy, int w, int h);
    @QSlot final void setGeometry(ref const(QRect) rect);

    @QSlot final void setMinimumWidth(int w);
    @QSlot final void setMinimumHeight(int h);
    @QSlot final void setMaximumWidth(int w);
    @QSlot final void setMaximumHeight(int h);

    /+ Q_REVISION(2, 1) +/ @QSlot final void alert(int msec);

    /+ Q_REVISION(2, 3) +/ @QSlot final void requestUpdate();

/+ Q_SIGNALS +/public:
    @QSignal final void screenChanged(QScreen screen);
    @QSignal final void modalityChanged(/+ Qt:: +/qt.core.namespace.WindowModality modality);
    @QSignal final void windowStateChanged(/+ Qt:: +/qt.core.namespace.WindowState windowState);
    /+ Q_REVISION(2, 2) +/ @QSignal final void windowTitleChanged(ref const(QString) title);

    @QSignal final void xChanged(int arg);
    @QSignal final void yChanged(int arg);

    @QSignal final void widthChanged(int arg);
    @QSignal final void heightChanged(int arg);

    @QSignal final void minimumWidthChanged(int arg);
    @QSignal final void minimumHeightChanged(int arg);
    @QSignal final void maximumWidthChanged(int arg);
    @QSignal final void maximumHeightChanged(int arg);

    @QSignal final void visibleChanged(bool arg);
    /+ Q_REVISION(2, 1) +/ @QSignal final void visibilityChanged(Visibility visibility);
    /+ Q_REVISION(2, 1) +/ @QSignal final void activeChanged();
    @QSignal final void contentOrientationChanged(/+ Qt:: +/qt.core.namespace.ScreenOrientation orientation);

    @QSignal final void focusObjectChanged(QObject object);

    /+ Q_REVISION(2, 1) +/ @QSignal final void opacityChanged(qreal opacity);

    /+ Q_REVISION(2, 13) +/ @QSignal final void transientParentChanged(QWindow transientParent);

    mixin(IMPLEMENT_FAKE_INTERFACE_DESTRUCTOR);

protected:
    /+ virtual +/ void exposeEvent(QExposeEvent );
    /+ virtual +/ void resizeEvent(QResizeEvent );
    /+ virtual +/ void paintEvent(QPaintEvent );
    /+ virtual +/ void moveEvent(QMoveEvent );
    /+ virtual +/ void focusInEvent(QFocusEvent );
    /+ virtual +/ void focusOutEvent(QFocusEvent );

    /+ virtual +/ void showEvent(QShowEvent );
    /+ virtual +/ void hideEvent(QHideEvent );
    /+ virtual +/ void closeEvent(QCloseEvent );

    /+ virtual +/ override bool event(QEvent );
    /+ virtual +/ void keyPressEvent(QKeyEvent );
    /+ virtual +/ void keyReleaseEvent(QKeyEvent );
    /+ virtual +/ void mousePressEvent(QMouseEvent );
    /+ virtual +/ void mouseReleaseEvent(QMouseEvent );
    /+ virtual +/ void mouseDoubleClickEvent(QMouseEvent );
    /+ virtual +/ void mouseMoveEvent(QMouseEvent );
/+ #if QT_CONFIG(wheelevent) +/
    /+ virtual +/ void wheelEvent(QWheelEvent );
/+ #endif +/
    /+ virtual +/ void touchEvent(QTouchEvent );
/+ #if QT_CONFIG(tabletevent) +/
    /+ virtual +/ void tabletEvent(QTabletEvent );
/+ #endif +/
    /+ virtual +/ bool nativeEvent(ref const(QByteArray) eventType, void* message, qintptr* result);

    this(ref QWindowPrivate dd, QWindow parent);

private:
    /+ Q_PRIVATE_SLOT(d_func(), void _q_clearAlert()) +/
    mixin(changeWindowsMangling(q{mangleChangeAccess("private")}, q{
    protected override QPlatformSurface* surfaceHandle() const;
    }));

    /+ Q_DISABLE_COPY(QWindow) +/

    /+ friend class QGuiApplication; +/
    /+ friend class QGuiApplicationPrivate; +/
    /+ friend class QWindowContainer; +/
    /+ friend Q_GUI_EXPORT QWindowPrivate *qt_window_private(QWindow *window); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef Q_QDOC
// should these be seen by clang-qdoc?
template <> inline QWindow *qobject_cast<QWindow*>(QObject *o)
{
    if (!o || !o->isWindowType()) return nullptr;
    return static_cast<QWindow*>(o);
}
template <> inline const QWindow *qobject_cast<const QWindow*>(const QObject *o)
{
    if (!o || !o->isWindowType()) return nullptr;
    return static_cast<const QWindow*>(o);
}
#endif // !Q_QDOC

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QWindow *);
#endif +/

