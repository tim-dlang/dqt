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
module qt.quick.item;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.global;
import qt.core.list;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.property;
import qt.core.rect;
import qt.core.sharedpointer_impl;
import qt.core.size;
import qt.core.string;
import qt.core.variant;
import qt.gui.cursor;
import qt.gui.event;
import qt.gui.transform;
import qt.helpers;
import qt.qml.component;
import qt.qml.jsvalue;
import qt.qml.parserstatus;

extern(C++, class) struct QQuickTransformPrivate;
abstract class /+ Q_QUICK_EXPORT +/ QQuickTransform : QObject
{
    mixin(Q_OBJECT);
    /+ QML_ANONYMOUS
    QML_ADDED_IN_VERSION(2, 0) +/
public:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QObject parent = null);
    }));
    ~this();

    final void appendToItem(QQuickItem );
    final void prependToItem(QQuickItem );

    /+ virtual +/ abstract void applyTo(QMatrix4x4* matrix) const;

protected /+ Q_SLOTS +/:
    @QSlot final void update();

protected:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QQuickTransformPrivate dd, QObject parent);
    }));

private:
    /+ Q_DECLARE_PRIVATE(QQuickTransform) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QQuickItemLayer;
extern(C++, class) struct QQuickState;
extern(C++, class) struct QQuickAnchorLine;
extern(C++, class) struct QQuickTransition;
extern(C++, class) struct QQuickKeyEvent;
extern(C++, class) struct QQuickAnchors;
extern(C++, class) struct QQuickItemPrivate;
extern(C++, class) struct QQuickWindow;
extern(C++, class) struct QSGNode;
extern(C++, class) struct QSGTransformNode;
extern(C++, class) struct QSGTextureProvider;
extern(C++, class) struct QQuickItemGrabResult;
extern(C++, class) struct QQuickPalette;

/// Binding for C++ class [QQuickItem](https://doc.qt.io/qt-6/qquickitem.html).
class /+ Q_QUICK_EXPORT +/ QQuickItem : QObject, QQmlParserStatusInterface
{
    QQmlParserStatusFakeInheritance baseQQmlParserStatus;

    mixin(Q_OBJECT);
    /+ Q_INTERFACES(QQmlParserStatus)

    Q_PROPERTY(QQuickItem *parent READ parentItem WRITE setParentItem NOTIFY parentChanged DESIGNABLE false FINAL)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQmlListProperty<QObject> data READ data DESIGNABLE false)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQmlListProperty<QObject> resources READ resources DESIGNABLE false)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQmlListProperty<QQuickItem> children READ children NOTIFY childrenChanged DESIGNABLE false)

    Q_PROPERTY(qreal x READ x WRITE setX NOTIFY xChanged BINDABLE bindableX FINAL)
    Q_PROPERTY(qreal y READ y WRITE setY NOTIFY yChanged BINDABLE bindableY FINAL)
    Q_PROPERTY(qreal z READ z WRITE setZ NOTIFY zChanged FINAL)
    Q_PROPERTY(qreal width READ width WRITE setWidth NOTIFY widthChanged RESET resetWidth BINDABLE bindableWidth FINAL)
    Q_PROPERTY(qreal height READ height WRITE setHeight NOTIFY heightChanged RESET resetHeight BINDABLE bindableHeight FINAL)

    Q_PROPERTY(qreal opacity READ opacity WRITE setOpacity NOTIFY opacityChanged FINAL)
    Q_PROPERTY(bool enabled READ isEnabled WRITE setEnabled NOTIFY enabledChanged)
    Q_PROPERTY(bool visible READ isVisible WRITE setVisible NOTIFY visibleChanged FINAL)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQuickPalette *palette READ palette WRITE setPalette RESET resetPalette NOTIFY paletteChanged REVISION(6, 0))
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQmlListProperty<QQuickItem> visibleChildren READ visibleChildren NOTIFY visibleChildrenChanged DESIGNABLE false)

    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQmlListProperty<QQuickState> states READ states DESIGNABLE false)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQmlListProperty<QQuickTransition> transitions READ transitions DESIGNABLE false)
    Q_PROPERTY(QString state READ state WRITE setState NOTIFY stateChanged)
    Q_PROPERTY(QRectF childrenRect READ childrenRect NOTIFY childrenRectChanged DESIGNABLE false FINAL)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQuickAnchors * anchors READ anchors DESIGNABLE false CONSTANT FINAL)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQuickAnchorLine left READ left CONSTANT FINAL)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQuickAnchorLine right READ right CONSTANT FINAL)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQuickAnchorLine horizontalCenter READ horizontalCenter CONSTANT FINAL)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQuickAnchorLine top READ top CONSTANT FINAL)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQuickAnchorLine bottom READ bottom CONSTANT FINAL)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQuickAnchorLine verticalCenter READ verticalCenter CONSTANT FINAL)
    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQuickAnchorLine baseline READ baseline CONSTANT FINAL)
    Q_PROPERTY(qreal baselineOffset READ baselineOffset WRITE setBaselineOffset NOTIFY baselineOffsetChanged)

    Q_PROPERTY(bool clip READ clip WRITE setClip NOTIFY clipChanged)

    Q_PROPERTY(bool focus READ hasFocus WRITE setFocus NOTIFY focusChanged FINAL)
    Q_PROPERTY(bool activeFocus READ hasActiveFocus NOTIFY activeFocusChanged FINAL)
    Q_PROPERTY(bool activeFocusOnTab READ activeFocusOnTab WRITE setActiveFocusOnTab NOTIFY activeFocusOnTabChanged FINAL REVISION(2, 1))

    Q_PROPERTY(qreal rotation READ rotation WRITE setRotation NOTIFY rotationChanged)
    Q_PROPERTY(qreal scale READ scale WRITE setScale NOTIFY scaleChanged)
    Q_PROPERTY(TransformOrigin transformOrigin READ transformOrigin WRITE setTransformOrigin NOTIFY transformOriginChanged)
    Q_PROPERTY(QPointF transformOriginPoint READ transformOriginPoint)  // deprecated - see QTBUG-26423
    Q_PROPERTY(QQmlListProperty<QQuickTransform> transform READ transform DESIGNABLE false FINAL)

    Q_PROPERTY(bool smooth READ smooth WRITE setSmooth NOTIFY smoothChanged)
    Q_PROPERTY(bool antialiasing READ antialiasing WRITE setAntialiasing NOTIFY antialiasingChanged RESET resetAntialiasing)
    Q_PROPERTY(qreal implicitWidth READ implicitWidth WRITE setImplicitWidth NOTIFY implicitWidthChanged)
    Q_PROPERTY(qreal implicitHeight READ implicitHeight WRITE setImplicitHeight NOTIFY implicitHeightChanged)
    Q_PROPERTY(QObject *containmentMask READ containmentMask WRITE setContainmentMask NOTIFY containmentMaskChanged REVISION(2, 11))

    Q_PRIVATE_PROPERTY(QQuickItem::d_func(), QQuickItemLayer *layer READ layer DESIGNABLE false CONSTANT FINAL)

    Q_CLASSINFO("DefaultProperty", "data")
    Q_CLASSINFO("ParentProperty", "parent")
    Q_CLASSINFO("qt_QmlJSWrapperFactoryMethod", "_q_createJSWrapper(QV4::ExecutionEngine*)")
    QML_NAMED_ELEMENT(Item)
    QML_ADDED_IN_VERSION(2, 0) +/

public:
    enum Flag {
        ItemClipsChildrenToShape  = 0x01,
/+ #if QT_CONFIG(im) +/
        ItemAcceptsInputMethod    = 0x02,
/+ #endif +/
        ItemIsFocusScope          = 0x04,
        ItemHasContents           = 0x08,
        ItemAcceptsDrops          = 0x10,
        ItemIsViewport            = 0x20,
        ItemObservesViewport      = 0x40,
        // Remember to increment the size of QQuickItemPrivate::flags
    }
    /+ Q_DECLARE_FLAGS(Flags, Flag) +/
alias Flags = QFlags!(Flag);    /+ Q_FLAG(Flags) +/

    enum ItemChange {
        ItemChildAddedChange,      // value.item
        ItemChildRemovedChange,    // value.item
        ItemSceneChange,           // value.window
        ItemVisibleHasChanged,     // value.boolValue
        ItemParentHasChanged,      // value.item
        ItemOpacityHasChanged,     // value.realValue
        ItemActiveFocusHasChanged, // value.boolValue
        ItemRotationHasChanged,    // value.realValue
        ItemAntialiasingHasChanged, // value.boolValue
        ItemDevicePixelRatioHasChanged, // value.realValue
        ItemEnabledHasChanged      // value.boolValue
    }

    union ItemChangeData {
        this(QQuickItem v)
        {
            this.item = v;
        }
        this(QQuickWindow* v)
        {
            this.window = v;
        }
        this(qreal v)
        {
            this.realValue = v;
        }
        this(bool v)
        {
            this.boolValue = v;
        }

        QQuickItem item;
        QQuickWindow* window;
        qreal realValue;
        bool boolValue;
    }

    enum TransformOrigin {
        TopLeft, Top, TopRight,
        Left, Center, Right,
        BottomLeft, Bottom, BottomRight
    }
    /+ Q_ENUM(TransformOrigin) +/

    /+ explicit +/this(QQuickItem parent = null);
    ~this();

    final QQuickWindow* window() const;
    final QQuickItem parentItem() const;
    final void setParentItem(QQuickItem parent);
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final void stackBefore(const(QQuickItem) );
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final void stackAfter(const(QQuickItem) );
    }));

    final QRectF childrenRect();
    final QList!(QQuickItem) childItems() const;

    final bool clip() const;
    final void setClip(bool);

    final QString state() const;
    final void setState(ref const(QString) );

    final qreal baselineOffset() const;
    final void setBaselineOffset(qreal);

    /+ QQmlListProperty<QQuickTransform> transform(); +/

    final qreal x() const;
    final qreal y() const;
    final QPointF position() const;
    final void setX(qreal);
    final void setY(qreal);
    final void setPosition(ref const(QPointF) );
    final QBindable!(qreal) bindableX();
    final QBindable!(qreal) bindableY();

    final qreal width() const;
    final void setWidth(qreal);
    final void resetWidth();
    final void setImplicitWidth(qreal);
    final qreal implicitWidth() const;
    final QBindable!(qreal) bindableWidth();

    final qreal height() const;
    final void setHeight(qreal);
    final void resetHeight();
    final void setImplicitHeight(qreal);
    final qreal implicitHeight() const;
    final QBindable!(qreal) bindableHeight();

    final QSizeF size() const;
    final void setSize(ref const(QSizeF) size);

    final TransformOrigin transformOrigin() const;
    final void setTransformOrigin(TransformOrigin);
    final QPointF transformOriginPoint() const;
    final void setTransformOriginPoint(ref const(QPointF) );

    final qreal z() const;
    final void setZ(qreal);

    final qreal rotation() const;
    final void setRotation(qreal);
    final qreal scale() const;
    final void setScale(qreal);

    final qreal opacity() const;
    final void setOpacity(qreal);

    final bool isVisible() const;
    final void setVisible(bool);

    final bool isEnabled() const;
    final void setEnabled(bool);

    final bool smooth() const;
    final void setSmooth(bool);

    final bool activeFocusOnTab() const;
    final void setActiveFocusOnTab(bool);

    final bool antialiasing() const;
    final void setAntialiasing(bool);
    final void resetAntialiasing();

    final Flags flags() const;
    /+ void setFlag(Flag flag, bool enabled = true); +/
    final void setFlags(Flags flags);

    /+ virtual +/ QRectF boundingRect() const;
    /+ virtual +/ QRectF clipRect() const;
    final QQuickItem viewportItem() const;

    final bool hasActiveFocus() const;
    final bool hasFocus() const;
    final void setFocus(bool);
    final void setFocus(bool focus, /+ Qt:: +/qt.core.namespace.FocusReason reason);
    final bool isFocusScope() const;
    final QQuickItem scopedFocusItem() const;

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final bool isAncestorOf(const(QQuickItem) child) const;
    }));

    final /+ Qt:: +/qt.core.namespace.MouseButtons acceptedMouseButtons() const;
    final void setAcceptedMouseButtons(/+ Qt:: +/qt.core.namespace.MouseButtons buttons);
    final bool acceptHoverEvents() const;
    final void setAcceptHoverEvents(bool enabled);
    final bool acceptTouchEvents() const;
    final void setAcceptTouchEvents(bool accept);

/+ #if QT_CONFIG(cursor) +/
    final QCursor cursor() const;
    final void setCursor(ref const(QCursor) cursor);
    final void unsetCursor();
/+ #endif +/

    final bool isUnderMouse() const;
    final void grabMouse();
    final void ungrabMouse();
    final bool keepMouseGrab() const;
    final void setKeepMouseGrab(bool);
    final bool filtersChildMouseEvents() const;
    final void setFiltersChildMouseEvents(bool filter);

    final void grabTouchPoints(ref const(QList!(int)) ids);
    final void ungrabTouchPoints();
    final bool keepTouchGrab() const;
    final void setKeepTouchGrab(bool);

    // implemented in qquickitemgrabresult.cpp
    /+ Q_REVISION(2, 4) +/ @QInvokable final bool grabToImage(ref const(QJSValue) callback, ref const(QSize) targetSize = globalInitVar!QSize);
    final QSharedPointer!(QQuickItemGrabResult) grabToImage(ref const(QSize) targetSize = globalInitVar!QSize);

    /+ virtual +/ @QInvokable bool contains(ref const(QPointF) point) const;
    final QObject containmentMask() const;
    final void setContainmentMask(QObject mask);

    final QTransform itemTransform(QQuickItem , bool* ) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QPointF mapToItem(const(QQuickItem) item, ref const(QPointF) point) const;
    }));
    final QPointF mapToScene(ref const(QPointF) point) const;
    final QPointF mapToGlobal(ref const(QPointF) point) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QRectF mapRectToItem(const(QQuickItem) item, ref const(QRectF) rect) const;
    }));
    final QRectF mapRectToScene(ref const(QRectF) rect) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QPointF mapFromItem(const(QQuickItem) item, ref const(QPointF) point) const;
    }));
    final QPointF mapFromScene(ref const(QPointF) point) const;
    final QPointF mapFromGlobal(ref const(QPointF) point) const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final QRectF mapRectFromItem(const(QQuickItem) item, ref const(QRectF) rect) const;
    }));
    final QRectF mapRectFromScene(ref const(QRectF) rect) const;

    final void polish();

    @QInvokable final void mapFromItem(QQmlV4Function*) const;
    @QInvokable final void mapToItem(QQmlV4Function*) const;
    /+ Q_REVISION(2, 7) +/ @QInvokable final void mapFromGlobal(QQmlV4Function*) const;
    /+ Q_REVISION(2, 7) +/ @QInvokable final void mapToGlobal(QQmlV4Function*) const;
    @QInvokable final void forceActiveFocus();
    @QInvokable final void forceActiveFocus(/+ Qt:: +/qt.core.namespace.FocusReason reason);
    /+ Q_REVISION(2, 1) +/ @QInvokable final QQuickItem nextItemInFocusChain(bool forward = true);
    @QInvokable final QQuickItem childAt(qreal x, qreal y) const;
    /+ Q_REVISION(6, 3) +/ @QInvokable final void ensurePolished();

    /+ Q_REVISION(6, 3) +/ @QInvokable final void dumpItemTree() const;

/+ #if QT_CONFIG(im) +/
    /+ virtual +/ QVariant inputMethodQuery(/+ Qt:: +/qt.core.namespace.InputMethodQuery query) const;
/+ #endif +/

    struct UpdatePaintNodeData; /+ {
       QSGTransformNode* transformNode;
    private:
       /+ friend class QQuickWindowPrivate; +/
       @disable this();
       pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
       void rawConstructor();
       static typeof(this) create()
       {
           typeof(this) r = typeof(this).init;
           r.rawConstructor();
           return r;
       }

    } +/

    /+ virtual +/ bool isTextureProvider() const;
    /+ virtual +/ QSGTextureProvider* textureProvider() const;

public /+ Q_SLOTS +/:
    @QSlot final void update();

/+ Q_SIGNALS +/public:
    @QSignal final void childrenRectChanged(ref const(QRectF) );
    @QSignal final void baselineOffsetChanged(qreal);
    @QSignal final void stateChanged(ref const(QString) );
    @QSignal final void focusChanged(bool);
    @QSignal final void activeFocusChanged(bool);
    /+ Q_REVISION(2, 1) +/ @QSignal final void activeFocusOnTabChanged(bool);
    @QSignal final void parentChanged(QQuickItem );
    @QSignal final void transformOriginChanged(TransformOrigin);
    @QSignal final void smoothChanged(bool);
    @QSignal final void antialiasingChanged(bool);
    @QSignal final void clipChanged(bool);
    /+ Q_REVISION(2, 1) +/ @QSignal final void windowChanged(QQuickWindow* window);

    @QSignal final void childrenChanged();
    @QSignal final void opacityChanged();
    @QSignal final void enabledChanged();
    @QSignal final void visibleChanged();
    @QSignal final void visibleChildrenChanged();
    @QSignal final void rotationChanged();
    @QSignal final void scaleChanged();

    @QSignal final void xChanged();
    @QSignal final void yChanged();
    @QSignal final void widthChanged();
    @QSignal final void heightChanged();
    @QSignal final void zChanged();
    @QSignal final void implicitWidthChanged();
    @QSignal final void implicitHeightChanged();
    /+ Q_REVISION(2, 11) +/ @QSignal final void containmentMaskChanged();

    /+ Q_REVISION(6, 0) +/ @QSignal final void paletteChanged();
    /+ Q_REVISION(6, 0) +/ @QSignal final void paletteCreated();

protected:
    override bool event(QEvent );

    final bool isComponentComplete() const;
    /+ virtual +/ void itemChange(ItemChange, ref const(ItemChangeData) );
    /+ virtual +/ void geometryChange(ref const(QRectF) newGeometry, ref const(QRectF) oldGeometry);

/+ #if QT_CONFIG(im) +/
    final void updateInputMethod(/+ Qt:: +/qt.core.namespace.InputMethodQueries queries = /+ Qt:: +/qt.core.namespace.InputMethodQuery.ImQueryInput);
/+ #endif +/

    final bool widthValid() const; // ### better name?
    final bool heightValid() const; // ### better name?
    final void setImplicitSize(qreal, qreal);

    override void classBegin();
    override void componentComplete();

    /+ virtual +/ void keyPressEvent(QKeyEvent event);
    /+ virtual +/ void keyReleaseEvent(QKeyEvent event);
/+ #if QT_CONFIG(im) +/
    /+ virtual +/ void inputMethodEvent(QInputMethodEvent );
/+ #endif +/
    /+ virtual +/ void focusInEvent(QFocusEvent );
    /+ virtual +/ void focusOutEvent(QFocusEvent );
    /+ virtual +/ void mousePressEvent(QMouseEvent event);
    /+ virtual +/ void mouseMoveEvent(QMouseEvent event);
    /+ virtual +/ void mouseReleaseEvent(QMouseEvent event);
    /+ virtual +/ void mouseDoubleClickEvent(QMouseEvent event);
    /+ virtual +/ void mouseUngrabEvent(); // XXX todo - params?
    /+ virtual +/ void touchUngrabEvent();
/+ #if QT_CONFIG(wheelevent) +/
    /+ virtual +/ void wheelEvent(QWheelEvent event);
/+ #endif +/
    /+ virtual +/ void touchEvent(QTouchEvent event);
    /+ virtual +/ void hoverEnterEvent(QHoverEvent event);
    /+ virtual +/ void hoverMoveEvent(QHoverEvent event);
    /+ virtual +/ void hoverLeaveEvent(QHoverEvent event);
/+ #if QT_CONFIG(quick_draganddrop) +/
    /+ virtual +/ void dragEnterEvent(QDragEnterEvent );
    /+ virtual +/ void dragMoveEvent(QDragMoveEvent );
    /+ virtual +/ void dragLeaveEvent(QDragLeaveEvent );
    /+ virtual +/ void dropEvent(QDropEvent );
/+ #endif +/
    /+ virtual +/ bool childMouseEventFilter(QQuickItem , QEvent );

    /+ virtual +/ QSGNode* updatePaintNode(QSGNode* , UpdatePaintNodeData* );
    /+ virtual +/ void releaseResources();
    /+ virtual +/ void updatePolish();

    this(ref QQuickItemPrivate dd, QQuickItem parent = null);

private:
    /+ Q_PRIVATE_SLOT(d_func(), void _q_resourceObjectDeleted(QObject *))
    Q_PRIVATE_SLOT(d_func(), quint64 _q_createJSWrapper(QV4::ExecutionEngine *)) +/

    /+ friend class QQuickWindowPrivate; +/
    /+ friend class QQuickDeliveryAgentPrivate; +/
    /+ friend class QSGRenderer; +/
    /+ friend class QAccessibleQuickItem; +/
    /+ friend class QQuickAccessibleAttached; +/
    /+ friend class QQuickAnchorChanges; +/
    /+ Q_DISABLE_COPY(QQuickItem) +/
    /+ Q_DECLARE_PRIVATE(QQuickItem) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QQuickItem.Flags.enum_type) operator |(QQuickItem.Flags.enum_type f1, QQuickItem.Flags.enum_type f2)nothrow{return QFlags!(QQuickItem.Flags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QQuickItem.Flags.enum_type) operator |(QQuickItem.Flags.enum_type f1, QFlags!(QQuickItem.Flags.enum_type) f2)nothrow{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QQuickItem.Flags.enum_type) operator &(QQuickItem.Flags.enum_type f1, QQuickItem.Flags.enum_type f2)nothrow{return QFlags!(QQuickItem.Flags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QQuickItem.Flags.enum_type) operator &(QQuickItem.Flags.enum_type f1, QFlags!(QQuickItem.Flags.enum_type) f2)nothrow{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QQuickItem.Flags.enum_type) operator ^(QQuickItem.Flags.enum_type f1, QQuickItem.Flags.enum_type f2)nothrow{return QFlags!(QQuickItem.Flags.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QQuickItem.Flags.enum_type) operator ^(QQuickItem.Flags.enum_type f1, QFlags!(QQuickItem.Flags.enum_type) f2)nothrow{return f2^f1;}+/
/+pragma(inline, true) void operator +(QQuickItem.Flags.enum_type f1, QQuickItem.Flags.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QQuickItem.Flags.enum_type f1, QFlags!(QQuickItem.Flags.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QQuickItem.Flags.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(QQuickItem.Flags.enum_type f1, QQuickItem.Flags.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QQuickItem.Flags.enum_type f1, QFlags!(QQuickItem.Flags.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QQuickItem.Flags.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QQuickItem.Flags.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QQuickItem.Flags.enum_type f1, int f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QQuickItem.Flags.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QQuickItem.Flags.enum_type f1, int f2)nothrow;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QQuickItem.Flags operator ~(QQuickItem.Flags.enum_type e)nothrow{return~QQuickItem.Flags(e);}+/
/+pragma(inline, true) void operator |(QQuickItem.Flags.enum_type f1, int f2)nothrow;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QQuickItem.Flags.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QQuickItem::Flags)
#ifndef Q_QDOC
template <> inline QQuickItem *qobject_cast<QQuickItem *>(QObject *o)
{
    if (!o || !o->isQuickItemType())
        return nullptr;
    return static_cast<QQuickItem *>(o);
}
template <> inline const QQuickItem *qobject_cast<const QQuickItem *>(const QObject *o)
{
    if (!o || !o->isQuickItemType())
        return nullptr;
    return static_cast<const QQuickItem *>(o);
}
#endif // !Q_QDOC

#ifndef QT_NO_DEBUG_STREAM
QDebug Q_QUICK_EXPORT operator<<(QDebug debug,
#if QT_VERSION >= QT_VERSION_CHECK(7, 0, 0)
                                 const
#endif
                                 QQuickItem *item);
#endif // QT_NO_DEBUG_STREAM


QML_DECLARE_TYPE(QQuickItem)
QML_DECLARE_TYPE(QQuickTransform) +/

