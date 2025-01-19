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
module qt.gui.paintengine;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.global;
import qt.core.line;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.scopedpointer;
import qt.core.size;
import qt.core.string;
import qt.core.typeinfo;
import qt.gui.brush;
import qt.gui.font;
import qt.gui.image;
import qt.gui.paintdevice;
import qt.gui.painter;
import qt.gui.painterpath;
import qt.gui.pen;
import qt.gui.pixmap;
import qt.gui.region;
import qt.gui.transform;
import qt.helpers;

extern(C++, class) struct QPaintEnginePrivate;
struct QGlyphLayout;
extern(C++, class) struct QTextItemInt;

/// Binding for C++ class [QTextItem](https://doc.qt.io/qt-6/qtextitem.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextItem {
public:
    enum RenderFlag {
        RightToLeft = 0x1,
        Overline = 0x10,
        Underline = 0x20,
        StrikeOut = 0x40,

        Dummy = 0xffffffff
    }
    /+ Q_DECLARE_FLAGS(RenderFlags, RenderFlag) +/
alias RenderFlags = QFlags!(RenderFlag);    qreal descent() const;
    qreal ascent() const;
    qreal width() const;

    RenderFlags renderFlags() const;
    QString text() const;
    QFont font() const;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QTextItem, Q_PRIMITIVE_TYPE); +/


/// Binding for C++ class [QPaintEngine](https://doc.qt.io/qt-6/qpaintengine.html).
abstract class /+ Q_GUI_EXPORT +/ QPaintEngine
{
private:
    /+ Q_DECLARE_PRIVATE(QPaintEngine) +/
public:
    enum PaintEngineFeature {
        PrimitiveTransform          = 0x00000001, // Can transform primitives brushes
        PatternTransform            = 0x00000002, // Can transform pattern brushes
        PixmapTransform             = 0x00000004, // Can transform pixmaps
        PatternBrush                = 0x00000008, // Can fill with pixmaps and standard patterns
        LinearGradientFill          = 0x00000010, // Can fill gradient areas
        RadialGradientFill          = 0x00000020, // Can render radial gradients
        ConicalGradientFill         = 0x00000040, // Can render conical gradients
        AlphaBlend                  = 0x00000080, // Can do source over alpha blend
        PorterDuff                  = 0x00000100, // Can do general porter duff compositions
        PainterPaths                = 0x00000200, // Can fill, outline and clip paths
        Antialiasing                = 0x00000400, // Can antialias lines
        BrushStroke                 = 0x00000800, // Can render brush based pens
        ConstantOpacity             = 0x00001000, // Can render at constant opacity
        MaskedBrush                 = 0x00002000, // Can fill with textures that has an alpha channel or mask
        PerspectiveTransform        = 0x00004000, // Can do perspective transformations
        BlendModes                  = 0x00008000, // Can do extended Porter&Duff composition
        ObjectBoundingModeGradients = 0x00010000, // Can do object bounding mode gradients
        RasterOpModes               = 0x00020000, // Can do logical raster operations
        PaintOutsidePaintEvent      = 0x20000000, // Engine is capable of painting outside paint events
        /*                          0x10000000, // Used for emulating
                                    QGradient::StretchToDevice,
                                    defined in qpainter.cpp

                                    0x40000000, // Used internally for emulating opaque backgrounds
        */

        AllFeatures               = 0xffffffff  // For convenience
    }
    /+ Q_DECLARE_FLAGS(PaintEngineFeatures, PaintEngineFeature) +/
alias PaintEngineFeatures = QFlags!(PaintEngineFeature);
    enum DirtyFlag {
        DirtyPen                = 0x0001,
        DirtyBrush              = 0x0002,
        DirtyBrushOrigin        = 0x0004,
        DirtyFont               = 0x0008,
        DirtyBackground         = 0x0010,
        DirtyBackgroundMode     = 0x0020,
        DirtyTransform          = 0x0040,
        DirtyClipRegion         = 0x0080,
        DirtyClipPath           = 0x0100,
        DirtyHints              = 0x0200,
        DirtyCompositionMode    = 0x0400,
        DirtyClipEnabled        = 0x0800,
        DirtyOpacity            = 0x1000,

        AllDirty                = 0xffff
    }
    /+ Q_DECLARE_FLAGS(DirtyFlags, DirtyFlag) +/
alias DirtyFlags = QFlags!(DirtyFlag);
    enum PolygonDrawMode {
        OddEvenMode,
        WindingMode,
        ConvexMode,
        PolylineMode
    }

    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(PaintEngineFeatures features=PaintEngineFeatures());
    }));
    /+ virtual +/~this();

    final bool isActive() const { return (active) != 0; }
    final void setActive(bool newState) { active = newState; }

    /+ virtual +/ abstract bool begin(QPaintDevice pdev);
    /+ virtual +/ abstract bool end();

    /+ virtual +/ abstract void updateState(ref const(QPaintEngineState) state);

    /+ virtual +/ void drawRects(const(QRect)* rects, int rectCount);
    /+ virtual +/ void drawRects(const(QRectF)* rects, int rectCount);

    /+ virtual +/ void drawLines(const(QLine)* lines, int lineCount);
    /+ virtual +/ void drawLines(const(QLineF)* lines, int lineCount);

    /+ virtual +/ void drawEllipse(ref const(QRectF) r);
    /+ virtual +/ void drawEllipse(ref const(QRect) r);

    /+ virtual +/ void drawPath(ref const(QPainterPath) path);

    /+ virtual +/ void drawPoints(const(QPointF)* points, int pointCount);
    /+ virtual +/ void drawPoints(const(QPoint)* points, int pointCount);

    /+ virtual +/ void drawPolygon(const(QPointF)* points, int pointCount, PolygonDrawMode mode);
    /+ virtual +/ void drawPolygon(const(QPoint)* points, int pointCount, PolygonDrawMode mode);

    /+ virtual +/ abstract void drawPixmap(ref const(QRectF) r, ref const(QPixmap) pm, ref const(QRectF) sr);
    /+ virtual +/ void drawTextItem(ref const(QPointF) p, ref const(QTextItem) textItem);
    /+ virtual +/ void drawTiledPixmap(ref const(QRectF) r, ref const(QPixmap) pixmap, ref const(QPointF) s);
    /+ virtual +/ void drawImage(ref const(QRectF) r, ref const(QImage) pm, ref const(QRectF) sr,
                               /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);

    final void setPaintDevice(QPaintDevice device);
    final QPaintDevice paintDevice() const;

    final void setSystemClip(ref const(QRegion) baseClip);
    final QRegion systemClip() const;

    final void setSystemRect(ref const(QRect) rect);
    final QRect systemRect() const;


    /+ virtual +/ QPoint coordinateOffset() const;

    enum Type {
        X11,
        Windows,
        QuickDraw, CoreGraphics, MacPrinter,
        QWindowSystem,
        OpenGL,
        Picture,
        SVG,
        Raster,
        Direct3D,
        Pdf,
        OpenVG,
        OpenGL2,
        PaintBuffer,
        Blitter,
        Direct2D,

        User = 50,    // first user type id
        MaxUser = 100 // last user type id
    }
    /+ virtual +/ abstract Type type() const;

    pragma(inline, true) final void fix_neg_rect(int* x, int* y, int* w, int* h)
    {
        if (*w < 0) {
            *w = -*w;
            *x -= *w - 1;
        }
        if (*h < 0) {
            *h = -*h;
            *y -= *h - 1;
        }
    }

    pragma(inline, true) final bool testDirty(DirtyFlags df) {
        (mixin(Q_ASSERT(q{QPaintEngine.state})));
        return (state.dirtyFlags & df) != 0;
    }
    pragma(inline, true) final void setDirty(DirtyFlags df) {
        (mixin(Q_ASSERT(q{QPaintEngine.state})));
        state.dirtyFlags |= df;
    }
    pragma(inline, true) final void clearDirty(DirtyFlags df)
    {
        (mixin(Q_ASSERT(q{QPaintEngine.state})));
        state.dirtyFlags &= ~static_cast!(uint)(df);
    }

    final bool hasFeature(PaintEngineFeatures feature) const { return cast(bool) (gccaps & feature); }

    final QPainter* painter() const;

    final void syncState();
    pragma(inline, true) final bool isExtended() const { return (extended) != 0; }

    /+ virtual +/ QPixmap createPixmap(QSize size);
    /+ virtual +/ QPixmap createPixmapFromImage(QImage image, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);

protected:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QPaintEnginePrivate data, PaintEngineFeatures devcaps=PaintEngineFeatures());
    }));

    QPaintEngineState* state;
    PaintEngineFeatures gccaps;

    /+ uint active : 1; +/
    ubyte bitfieldData_active;
    final uint active() const
    {
        return (bitfieldData_active >> 0) & 0x1;
    }
    final uint active(uint value)
    {
        bitfieldData_active = (bitfieldData_active & ~0x1) | ((value & 0x1) << 0);
        return value;
    }
    /+ uint selfDestruct : 1; +/
    final uint selfDestruct() const
    {
        return (bitfieldData_active >> 1) & 0x1;
    }
    final uint selfDestruct(uint value)
    {
        bitfieldData_active = (bitfieldData_active & ~0x2) | ((value & 0x1) << 1);
        return value;
    }
    /+ uint extended : 1; +/
    final uint extended() const
    {
        return (bitfieldData_active >> 2) & 0x1;
    }
    final uint extended(uint value)
    {
        bitfieldData_active = (bitfieldData_active & ~0x4) | ((value & 0x1) << 2);
        return value;
    }

    QScopedPointer!(QPaintEnginePrivate) d_ptr;

private:
    final void setAutoDestruct(bool autoDestr) { selfDestruct = autoDestr; }
    final bool autoDestruct() const { return (selfDestruct) != 0; }
    /+ Q_DISABLE_COPY(QPaintEngine) +/

    /+ friend class QPainterReplayer; +/
    /+ friend class QFontEngineBox; +/
    /+ friend class QFontEngineMac; +/
    /+ friend class QFontEngineWin; +/
    /+ friend class QMacPrintEngine; +/
    /+ friend class QMacPrintEnginePrivate; +/
    /+ friend class QFontEngineQPF2; +/
    /+ friend class QPainter; +/
    /+ friend class QPainterPrivate; +/
    /+ friend class QWidget; +/
    /+ friend class QWidgetPrivate; +/
    /+ friend class QWin32PaintEngine; +/
    /+ friend class QWin32PaintEnginePrivate; +/
    /+ friend class QMacCGContext; +/
    /+ friend class QPreviewPaintEngine; +/
    /+ friend class QX11GLPlatformPixmap; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/// Binding for C++ class [QPaintEngineState](https://doc.qt.io/qt-6/qpaintenginestate.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPaintEngineState
{
public:
    QPaintEngine.DirtyFlags state() const { return dirtyFlags; }

    QPen pen() const;
    QBrush brush() const;
    QPointF brushOrigin() const;
    QBrush backgroundBrush() const;
    /+ Qt:: +/qt.core.namespace.BGMode backgroundMode() const;
    QFont font() const;
    QTransform transform() const;

    /+ Qt:: +/qt.core.namespace.ClipOperation clipOperation() const;
    QRegion clipRegion() const;
    QPainterPath clipPath() const;
    bool isClipEnabled() const;

    QPainter.RenderHints renderHints() const;
    QPainter.CompositionMode compositionMode() const;
    qreal opacity() const;

    QPainter* painter() const;

    bool brushNeedsResolving() const;
    bool penNeedsResolving() const;

protected:
    /+ friend class QPaintEngine; +/
    /+ friend class QRasterPaintEngine; +/
    /+ friend class QWidget; +/
    /+ friend class QPainter; +/
    /+ friend class QPainterPrivate; +/
    /+ friend class QMacPrintEnginePrivate; +/

    QPaintEngine.DirtyFlags dirtyFlags;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

//
// inline functions
//
/+pragma(inline, true) QFlags!(QTextItem.RenderFlags.enum_type) operator |(QTextItem.RenderFlags.enum_type f1, QTextItem.RenderFlags.enum_type f2)/+noexcept+/{return QFlags!(QTextItem.RenderFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QTextItem.RenderFlags.enum_type) operator |(QTextItem.RenderFlags.enum_type f1, QFlags!(QTextItem.RenderFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QTextItem.RenderFlags.enum_type) operator &(QTextItem.RenderFlags.enum_type f1, QTextItem.RenderFlags.enum_type f2)/+noexcept+/{return QFlags!(QTextItem.RenderFlags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QTextItem.RenderFlags.enum_type) operator &(QTextItem.RenderFlags.enum_type f1, QFlags!(QTextItem.RenderFlags.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) void operator +(QTextItem.RenderFlags.enum_type f1, QTextItem.RenderFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QTextItem.RenderFlags.enum_type f1, QFlags!(QTextItem.RenderFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QTextItem.RenderFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QTextItem.RenderFlags.enum_type f1, QTextItem.RenderFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QTextItem.RenderFlags.enum_type f1, QFlags!(QTextItem.RenderFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QTextItem.RenderFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) QIncompatibleFlag operator |(QTextItem.RenderFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+pragma(inline, true) void operator +(int f1, QTextItem.RenderFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QTextItem.RenderFlags.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QTextItem.RenderFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QTextItem.RenderFlags.enum_type f1, int f2)/+noexcept+/;+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QTextItem::RenderFlags) +/
/+pragma(inline, true) QFlags!(QPaintEngine.PaintEngineFeatures.enum_type) operator |(QPaintEngine.PaintEngineFeatures.enum_type f1, QPaintEngine.PaintEngineFeatures.enum_type f2)/+noexcept+/{return QFlags!(QPaintEngine.PaintEngineFeatures.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QPaintEngine.PaintEngineFeatures.enum_type) operator |(QPaintEngine.PaintEngineFeatures.enum_type f1, QFlags!(QPaintEngine.PaintEngineFeatures.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QPaintEngine.PaintEngineFeatures.enum_type) operator &(QPaintEngine.PaintEngineFeatures.enum_type f1, QPaintEngine.PaintEngineFeatures.enum_type f2)/+noexcept+/{return QFlags!(QPaintEngine.PaintEngineFeatures.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QPaintEngine.PaintEngineFeatures.enum_type) operator &(QPaintEngine.PaintEngineFeatures.enum_type f1, QFlags!(QPaintEngine.PaintEngineFeatures.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) void operator +(QPaintEngine.PaintEngineFeatures.enum_type f1, QPaintEngine.PaintEngineFeatures.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QPaintEngine.PaintEngineFeatures.enum_type f1, QFlags!(QPaintEngine.PaintEngineFeatures.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QPaintEngine.PaintEngineFeatures.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QPaintEngine.PaintEngineFeatures.enum_type f1, QPaintEngine.PaintEngineFeatures.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QPaintEngine.PaintEngineFeatures.enum_type f1, QFlags!(QPaintEngine.PaintEngineFeatures.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QPaintEngine.PaintEngineFeatures.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) QIncompatibleFlag operator |(QPaintEngine.PaintEngineFeatures.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+pragma(inline, true) void operator +(int f1, QPaintEngine.PaintEngineFeatures.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QPaintEngine.PaintEngineFeatures.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QPaintEngine.PaintEngineFeatures.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QPaintEngine.PaintEngineFeatures.enum_type f1, int f2)/+noexcept+/;+/
/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QPaintEngine::PaintEngineFeatures) +/
/+pragma(inline, true) QFlags!(QPaintEngine.DirtyFlags.enum_type) operator |(QPaintEngine.DirtyFlags.enum_type f1, QPaintEngine.DirtyFlags.enum_type f2)/+noexcept+/{return QFlags!(QPaintEngine.DirtyFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QPaintEngine.DirtyFlags.enum_type) operator |(QPaintEngine.DirtyFlags.enum_type f1, QFlags!(QPaintEngine.DirtyFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QPaintEngine.DirtyFlags.enum_type) operator &(QPaintEngine.DirtyFlags.enum_type f1, QPaintEngine.DirtyFlags.enum_type f2)/+noexcept+/{return QFlags!(QPaintEngine.DirtyFlags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QPaintEngine.DirtyFlags.enum_type) operator &(QPaintEngine.DirtyFlags.enum_type f1, QFlags!(QPaintEngine.DirtyFlags.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) void operator +(QPaintEngine.DirtyFlags.enum_type f1, QPaintEngine.DirtyFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QPaintEngine.DirtyFlags.enum_type f1, QFlags!(QPaintEngine.DirtyFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QPaintEngine.DirtyFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QPaintEngine.DirtyFlags.enum_type f1, QPaintEngine.DirtyFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QPaintEngine.DirtyFlags.enum_type f1, QFlags!(QPaintEngine.DirtyFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QPaintEngine.DirtyFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) QIncompatibleFlag operator |(QPaintEngine.DirtyFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+pragma(inline, true) void operator +(int f1, QPaintEngine.DirtyFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QPaintEngine.DirtyFlags.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QPaintEngine.DirtyFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QPaintEngine.DirtyFlags.enum_type f1, int f2)/+noexcept+/;+/
/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QPaintEngine::DirtyFlags) +/
