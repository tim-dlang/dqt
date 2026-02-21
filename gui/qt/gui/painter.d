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
module qt.gui.painter;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.global;
import qt.core.line;
import qt.core.list;
import qt.core.metamacros;
import qt.core.namespace;
import qt.core.point;
import qt.core.rect;
import qt.core.string;
import qt.gui.brush;
import qt.gui.color;
import qt.gui.font;
import qt.gui.fontinfo;
import qt.gui.fontmetrics;
import qt.gui.image;
import qt.gui.paintdevice;
import qt.gui.paintengine;
import qt.gui.painterpath;
import qt.gui.pen;
import qt.gui.pixmap;
import qt.gui.polygon;
import qt.gui.region;
import qt.gui.statictext;
import qt.gui.textoption;
import qt.gui.transform;
import qt.helpers;
version (QT_NO_PICTURE) {} else
    import qt.gui.picture;
version (QT_NO_RAWFONT) {} else
    import qt.gui.glyphrun;

/+ #ifndef QT_INCLUDE_COMPAT
#endif +/



extern(C++, class) struct QPainterPrivate;

extern(C++, class) struct QPainterPrivateDeleter;

/// Binding for C++ class [QPainter](https://doc.qt.io/qt-6/qpainter.html).
extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPainter
{
private:
    /+ Q_DECLARE_PRIVATE(QPainter) +/
    mixin(Q_GADGET);

public:
    enum RenderHint {
        Antialiasing = 0x01,
        TextAntialiasing = 0x02,
        SmoothPixmapTransform = 0x04,
        VerticalSubpixelPositioning = 0x08,
        LosslessImageRendering = 0x40,
        NonCosmeticBrushPatterns = 0x80
    }
    /+ Q_ENUM(RenderHint) +/

    /+ Q_DECLARE_FLAGS(RenderHints, RenderHint) +/
alias RenderHints = QFlags!(RenderHint);    /+ Q_FLAG(RenderHints) +/

    /// Binding for C++ class [QPainter::PixmapFragment](https://doc.qt.io/qt-6/qpainter-pixmapfragment.html).
    extern(C++, class) struct PixmapFragment {
    public:
        qreal x;
        qreal y;
        qreal sourceLeft;
        qreal sourceTop;
        qreal width;
        qreal height;
        qreal scaleX;
        qreal scaleY;
        qreal rotation;
        qreal opacity;
        /+ static PixmapFragment Q_GUI_EXPORT create(const QPointF &pos, const QRectF &sourceRect,
                                            qreal scaleX = 1, qreal scaleY = 1,
                                            qreal rotation = 0, qreal opacity = 1); +/
    }

    enum PixmapFragmentHint {
        OpaqueHint = 0x01
    }

    /+ Q_DECLARE_FLAGS(PixmapFragmentHints, PixmapFragmentHint) +/
alias PixmapFragmentHints = QFlags!(PixmapFragmentHint);
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ explicit +/this(QPaintDevice );
    /+ explicit +/this(QPaintDeviceInterface dev)
    {
        this(cast(QPaintDevice)cast(void*)dev);
    }
    ~this();

    QPaintDevice device() const;

    bool begin(QPaintDevice );
    bool end();
    bool isActive() const;

    enum CompositionMode {
        CompositionMode_SourceOver,
        CompositionMode_DestinationOver,
        CompositionMode_Clear,
        CompositionMode_Source,
        CompositionMode_Destination,
        CompositionMode_SourceIn,
        CompositionMode_DestinationIn,
        CompositionMode_SourceOut,
        CompositionMode_DestinationOut,
        CompositionMode_SourceAtop,
        CompositionMode_DestinationAtop,
        CompositionMode_Xor,

        //svg 1.2 blend modes
        CompositionMode_Plus,
        CompositionMode_Multiply,
        CompositionMode_Screen,
        CompositionMode_Overlay,
        CompositionMode_Darken,
        CompositionMode_Lighten,
        CompositionMode_ColorDodge,
        CompositionMode_ColorBurn,
        CompositionMode_HardLight,
        CompositionMode_SoftLight,
        CompositionMode_Difference,
        CompositionMode_Exclusion,

        // ROPs
        RasterOp_SourceOrDestination,
        RasterOp_SourceAndDestination,
        RasterOp_SourceXorDestination,
        RasterOp_NotSourceAndNotDestination,
        RasterOp_NotSourceOrNotDestination,
        RasterOp_NotSourceXorDestination,
        RasterOp_NotSource,
        RasterOp_NotSourceAndDestination,
        RasterOp_SourceAndNotDestination,
        RasterOp_NotSourceOrDestination,
        RasterOp_SourceOrNotDestination,
        RasterOp_ClearDestination,
        RasterOp_SetDestination,
        RasterOp_NotDestination
    }
    void setCompositionMode(CompositionMode mode);
    CompositionMode compositionMode() const;

    ref const(QFont) font() const;
    void setFont(ref const(QFont) f);

    QFontMetrics fontMetrics() const;
    QFontInfo fontInfo() const;

    void setPen(ref const(QColor) color);
    void setPen(ref const(QPen) pen);
    void setPen(/+ Qt:: +/qt.core.namespace.PenStyle style);
    ref const(QPen) pen() const;

    void setBrush(ref const(QBrush) brush);
    void setBrush(/+ Qt:: +/qt.core.namespace.BrushStyle style);
    ref const(QBrush) brush() const;

    // attributes/modes
    void setBackgroundMode(/+ Qt:: +/qt.core.namespace.BGMode mode);
    /+ Qt:: +/qt.core.namespace.BGMode backgroundMode() const;

    QPoint brushOrigin() const;
    pragma(inline, true) void setBrushOrigin(int x, int y)
    {
        auto tmp = QPoint(x, y); setBrushOrigin(tmp);
    }
    pragma(inline, true) void setBrushOrigin(ref const(QPoint) p)
    {
        auto tmp = QPointF(p); setBrushOrigin(tmp);
    }
    void setBrushOrigin(ref const(QPointF) );

    void setBackground(ref const(QBrush) bg);
    ref const(QBrush) background() const;

    qreal opacity() const;
    void setOpacity(qreal opacity);

    // Clip functions
    QRegion clipRegion() const;
    QPainterPath clipPath() const;

    void setClipRect(ref const(QRectF) , /+ Qt:: +/qt.core.namespace.ClipOperation op = /+ Qt:: +/qt.core.namespace.ClipOperation.ReplaceClip);
    void setClipRect(ref const(QRect) , /+ Qt:: +/qt.core.namespace.ClipOperation op = /+ Qt:: +/qt.core.namespace.ClipOperation.ReplaceClip);
    pragma(inline, true) void setClipRect(int x, int y, int w, int h, /+ Qt:: +/qt.core.namespace.ClipOperation op = /+ Qt:: +/qt.core.namespace.ClipOperation.ReplaceClip)
    {
        auto tmp = QRect(x, y, w, h); setClipRect(tmp, op);
    }

    void setClipRegion(ref const(QRegion) , /+ Qt:: +/qt.core.namespace.ClipOperation op = /+ Qt:: +/qt.core.namespace.ClipOperation.ReplaceClip);

    void setClipPath(ref const(QPainterPath) path, /+ Qt:: +/qt.core.namespace.ClipOperation op = /+ Qt:: +/qt.core.namespace.ClipOperation.ReplaceClip);

    void setClipping(bool enable);
    bool hasClipping() const;

    QRectF clipBoundingRect() const;

    void save();
    void restore();

    // XForm functions
    void setTransform(ref const(QTransform) transform, bool combine = false);
    ref const(QTransform) transform() const;
    ref const(QTransform) deviceTransform() const;
    void resetTransform();

    void setWorldTransform(ref const(QTransform) matrix, bool combine = false);
    ref const(QTransform) worldTransform() const;

    QTransform combinedTransform() const;

    void setWorldMatrixEnabled(bool enabled);
    bool worldMatrixEnabled() const;

    void scale(qreal sx, qreal sy);
    void shear(qreal sh, qreal sv);
    void rotate(qreal a);

    void translate(ref const(QPointF) offset);
    pragma(inline, true) void translate(ref const(QPoint) offset)
    {
        translate(offset.x(), offset.y());
    }
    pragma(inline, true) void translate(qreal dx, qreal dy)
    {
        auto tmp = QPointF(dx, dy); translate(tmp);
    }

    QRect window() const;
    void setWindow(ref const(QRect) window);
    pragma(inline, true) void setWindow(int x, int y, int w, int h)
    {
        auto tmp = QRect(x, y, w, h); setWindow(tmp);
    }

    QRect viewport() const;
    void setViewport(ref const(QRect) viewport);
    pragma(inline, true) void setViewport(int x, int y, int w, int h)
    {
        auto tmp = QRect(x, y, w, h); setViewport(tmp);
    }

    void setViewTransformEnabled(bool enable);
    bool viewTransformEnabled() const;

    // drawing functions
    void strokePath(ref const(QPainterPath) path, ref const(QPen) pen);
    void fillPath(ref const(QPainterPath) path, ref const(QBrush) brush);
    void drawPath(ref const(QPainterPath) path);

    pragma(inline, true) void drawPoint(ref const(QPointF) p)
    {
        drawPoints(&p, 1);
    }
    pragma(inline, true) void drawPoint(ref const(QPoint) p)
    {
        drawPoints(&p, 1);
    }
    pragma(inline, true) void drawPoint(int x, int y)
    {
        auto p = QPoint(x, y);
        drawPoints(&p, 1);
    }

    void drawPoints(const(QPointF)* points, int pointCount);
    pragma(inline, true) void drawPoints(ref const(QPolygonF) points)
    {
        drawPoints(points.constData(), cast(int)(points.size()));
    }
    void drawPoints(const(QPoint)* points, int pointCount);
    pragma(inline, true) void drawPoints(ref const(QPolygon) points)
    {
        drawPoints(points.constData(), cast(int)(points.size()));
    }

    //
    // functions
    //
    pragma(inline, true) void drawLine(ref const(QLineF) l)
    {
        drawLines(&l, 1);
    }
    pragma(inline, true) void drawLine(ref const(QLine) line)
    {
        drawLines(&line, 1);
    }
    pragma(inline, true) void drawLine(int x1, int y1, int x2, int y2)
    {
        auto l = QLine(x1, y1, x2, y2);
        drawLines(&l, 1);
    }
    pragma(inline, true) void drawLine(ref const(QPoint) p1, ref const(QPoint) p2)
    {
        auto l = QLine(p1, p2);
        drawLines(&l, 1);
    }
    pragma(inline, true) void drawLine(ref const(QPointF) p1, ref const(QPointF) p2)
    {
        auto tmp = QLineF(p1, p2); drawLine(tmp);
    }

    void drawLines(const(QLineF)* lines, int lineCount);
    pragma(inline, true) void drawLines(ref const(QList!(QLineF)) lines)
    {
        drawLines(lines.constData(), cast(int)(lines.size()));
    }
    void drawLines(const(QPointF)* pointPairs, int lineCount);
    pragma(inline, true) void drawLines(ref const(QList!(QPointF)) pointPairs)
    {
        drawLines(pointPairs.constData(), cast(int)(pointPairs.size() / 2));
    }
    void drawLines(const(QLine)* lines, int lineCount);
    pragma(inline, true) void drawLines(ref const(QList!(QLine)) lines)
    {
        drawLines(lines.constData(), cast(int)(lines.size()));
    }
    void drawLines(const(QPoint)* pointPairs, int lineCount);
    pragma(inline, true) void drawLines(ref const(QList!(QPoint)) pointPairs)
    {
        drawLines(pointPairs.constData(), cast(int)(pointPairs.size() / 2));
    }

    pragma(inline, true) void drawRect(ref const(QRectF) rect)
    {
        drawRects(&rect, 1);
    }
    pragma(inline, true) void drawRect(int x, int y, int w, int h)
    {
        auto r = QRect(x, y, w, h);
        drawRects(&r, 1);
    }
    pragma(inline, true) void drawRect(ref const(QRect) r)
    {
        drawRects(&r, 1);
    }

    void drawRects(const(QRectF)* rects, int rectCount);
    pragma(inline, true) void drawRects(ref const(QList!(QRectF)) rects)
    {
        drawRects(rects.constData(), cast(int)(rects.size()));
    }
    void drawRects(const(QRect)* rects, int rectCount);
    pragma(inline, true) void drawRects(ref const(QList!(QRect)) rects)
    {
        drawRects(rects.constData(), cast(int)(rects.size()));
    }

    void drawEllipse(ref const(QRectF) r);
    void drawEllipse(ref const(QRect) r);
    pragma(inline, true) void drawEllipse(int x, int y, int w, int h)
    {
        auto tmp = QRect(x, y, w, h); drawEllipse(tmp);
    }

    pragma(inline, true) void drawEllipse(ref const(QPointF) center, qreal rx, qreal ry)
    {
        auto tmp = QRectF(center.x() - rx, center.y() - ry, 2 * rx, 2 * ry); drawEllipse(tmp);
    }
    pragma(inline, true) void drawEllipse(ref const(QPoint) center, int rx, int ry)
    {
        auto tmp = QRect(center.x() - rx, center.y() - ry, 2 * rx, 2 * ry); drawEllipse(tmp);
    }

    void drawPolyline(const(QPointF)* points, int pointCount);
    pragma(inline, true) void drawPolyline(ref const(QPolygonF) polyline)
    {
        drawPolyline(polyline.constData(), cast(int)(polyline.size()));
    }
    void drawPolyline(const(QPoint)* points, int pointCount);
    pragma(inline, true) void drawPolyline(ref const(QPolygon) polyline)
    {
        drawPolyline(polyline.constData(), cast(int)(polyline.size()));
    }

    void drawPolygon(const(QPointF)* points, int pointCount, /+ Qt:: +/qt.core.namespace.FillRule fillRule = /+ Qt:: +/qt.core.namespace.FillRule.OddEvenFill);
    pragma(inline, true) void drawPolygon(ref const(QPolygonF) polygon, /+ Qt:: +/qt.core.namespace.FillRule fillRule = /+ Qt:: +/qt.core.namespace.FillRule.OddEvenFill)
    {
        drawPolygon(polygon.constData(), cast(int)(polygon.size()), fillRule);
    }
    void drawPolygon(const(QPoint)* points, int pointCount, /+ Qt:: +/qt.core.namespace.FillRule fillRule = /+ Qt:: +/qt.core.namespace.FillRule.OddEvenFill);
    pragma(inline, true) void drawPolygon(ref const(QPolygon) polygon, /+ Qt:: +/qt.core.namespace.FillRule fillRule = /+ Qt:: +/qt.core.namespace.FillRule.OddEvenFill)
    {
        drawPolygon(polygon.constData(), cast(int)(polygon.size()), fillRule);
    }

    void drawConvexPolygon(const(QPointF)* points, int pointCount);
    pragma(inline, true) void drawConvexPolygon(ref const(QPolygonF) poly)
    {
        drawConvexPolygon(poly.constData(), cast(int)(poly.size()));
    }
    void drawConvexPolygon(const(QPoint)* points, int pointCount);
    pragma(inline, true) void drawConvexPolygon(ref const(QPolygon) poly)
    {
        drawConvexPolygon(poly.constData(), cast(int)(poly.size()));
    }

    void drawArc(ref const(QRectF) rect, int a, int alen);
    pragma(inline, true) void drawArc(ref const(QRect) r, int a, int alen)
    {
        auto tmp = QRectF(r); drawArc(tmp, a, alen);
    }
    pragma(inline, true) void drawArc(int x, int y, int w, int h, int a, int alen)
    {
        auto tmp = QRectF(x, y, w, h); drawArc(tmp, a, alen);
    }

    void drawPie(ref const(QRectF) rect, int a, int alen);
    pragma(inline, true) void drawPie(int x, int y, int w, int h, int a, int alen)
    {
        auto tmp = QRectF(x, y, w, h); drawPie(tmp, a, alen);
    }
    pragma(inline, true) void drawPie(ref const(QRect) rect, int a, int alen)
    {
        auto tmp = QRectF(rect); drawPie(tmp, a, alen);
    }

    void drawChord(ref const(QRectF) rect, int a, int alen);
    pragma(inline, true) void drawChord(int x, int y, int w, int h, int a, int alen)
    {
        auto tmp = QRectF(x, y, w, h); drawChord(tmp, a, alen);
    }
    pragma(inline, true) void drawChord(ref const(QRect) rect, int a, int alen)
    {
        auto tmp = QRectF(rect); drawChord(tmp, a, alen);
    }

    void drawRoundedRect(ref const(QRectF) rect, qreal xRadius, qreal yRadius,
                             /+ Qt:: +/qt.core.namespace.SizeMode mode = /+ Qt:: +/qt.core.namespace.SizeMode.AbsoluteSize);
    pragma(inline, true) void drawRoundedRect(int x, int y, int w, int h, qreal xRadius, qreal yRadius,
                                    /+ Qt:: +/qt.core.namespace.SizeMode mode = /+ Qt:: +/qt.core.namespace.SizeMode.AbsoluteSize)
    {
        auto tmp = QRectF(x, y, w, h); drawRoundedRect(tmp, xRadius, yRadius, mode);
    }
    pragma(inline, true) void drawRoundedRect(ref const(QRect) rect, qreal xRadius, qreal yRadius,
                                    /+ Qt:: +/qt.core.namespace.SizeMode mode = /+ Qt:: +/qt.core.namespace.SizeMode.AbsoluteSize)
    {
        auto tmp = QRectF(rect); drawRoundedRect(tmp, xRadius, yRadius, mode);
    }

    void drawTiledPixmap(ref const(QRectF) rect, ref const(QPixmap) pm, ref const(QPointF) offset = globalInitVar!QPointF);
    pragma(inline, true) void drawTiledPixmap(int x, int y, int w, int h, ref const(QPixmap) pm, int sx=0, int sy=0)
    {
        auto tmp = QRectF(x, y, w, h); auto tmp__1 = QPointF(sx, sy); drawTiledPixmap(tmp, pm, tmp__1);
    }
    pragma(inline, true) void drawTiledPixmap(ref const(QRect) rect, ref const(QPixmap) pm, ref const(QPoint) offset /+ = QPoint() +/)
    {
        auto tmp = QRectF(rect); auto tmp__1 = QPointF(offset); drawTiledPixmap(tmp, pm, tmp__1);
    }
    version (QT_NO_PICTURE) {} else
    {
        void drawPicture(ref const(QPointF) p, ref const(QPicture) picture);
        pragma(inline, true) void drawPicture(int x, int y, ref const(QPicture) p)
        {
            auto tmp = QPoint(x, y); drawPicture(tmp, p);
        }
        pragma(inline, true) void drawPicture(ref const(QPoint) pt, ref const(QPicture) p)
        {
            auto tmp = QPointF(pt); drawPicture(tmp, p);
        }
    }

    void drawPixmap(ref const(QRectF) targetRect, ref const(QPixmap) pixmap, ref const(QRectF) sourceRect);
    pragma(inline, true) void drawPixmap(ref const(QRect) targetRect, ref const(QPixmap) pixmap, ref const(QRect) sourceRect)
    {
        auto tmp = QRectF(targetRect); auto tmp__1 = QRectF(sourceRect); drawPixmap(tmp, pixmap, tmp__1);
    }
    pragma(inline, true) void drawPixmap(int x, int y, int w, int h, ref const(QPixmap) pm,
                               int sx, int sy, int sw, int sh)
    {
        auto tmp = QRectF(x, y, w, h); auto tmp__1 = QRectF(sx, sy, sw, sh); drawPixmap(tmp, pm, tmp__1);
    }
    pragma(inline, true) void drawPixmap(int x, int y, ref const(QPixmap) pm,
                               int sx, int sy, int sw, int sh)
    {
        auto tmp = QRectF(x, y, -1, -1); auto tmp__1 = QRectF(sx, sy, sw, sh); drawPixmap(tmp, pm, tmp__1);
    }
    pragma(inline, true) void drawPixmap(ref const(QPointF) p, ref const(QPixmap) pm, ref const(QRectF) sr)
    {
        auto tmp = QRectF(p.x(), p.y(), -1, -1); drawPixmap(tmp, pm, sr);
    }
    pragma(inline, true) void drawPixmap(ref const(QPoint) p, ref const(QPixmap) pm, ref const(QRect) sr)
    {
        auto tmp = QRectF(p.x(), p.y(), -1, -1); auto tmp2 = QRectF(sr); drawPixmap(tmp, pm, tmp2);
    }
    void drawPixmap(ref const(QPointF) p, ref const(QPixmap) pm);
    pragma(inline, true) void drawPixmap(ref const(QPoint) p, ref const(QPixmap) pm)
    {
        auto tmp = QPointF(p); drawPixmap(tmp, pm);
    }
    pragma(inline, true) void drawPixmap(int x, int y, ref const(QPixmap) pm)
    {
        auto tmp = QPointF(x, y); drawPixmap(tmp, pm);
    }
    pragma(inline, true) void drawPixmap(ref const(QRect) r, ref const(QPixmap) pm)
    {
        auto tmp = QRectF(r); auto tmp__1 = QRectF(); drawPixmap(tmp, pm, tmp__1);
    }
    pragma(inline, true) void drawPixmap(int x, int y, int w, int h, ref const(QPixmap) pm)
    {
        auto tmp = QRectF(x, y, w, h); auto tmp__1 = QRectF(); drawPixmap(tmp, pm, tmp__1);
    }

    void drawPixmapFragments(const(PixmapFragment)* fragments, int fragmentCount,
                                 ref const(QPixmap) pixmap, PixmapFragmentHints hints = PixmapFragmentHints());

    void drawImage(ref const(QRectF) targetRect, ref const(QImage) image, ref const(QRectF) sourceRect,
                       /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor);
    pragma(inline, true) void drawImage(ref const(QRect) targetRect, ref const(QImage) image, ref const(QRect) sourceRect,
                              /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor)
    {
        auto tmp = QRectF(targetRect); auto tmp__1 = QRectF(sourceRect); drawImage(tmp, image, tmp__1, flags);
    }
    pragma(inline, true) void drawImage(ref const(QPointF) p, ref const(QImage) image, ref const(QRectF) sr,
                              /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor)
    {
        auto tmp = QRectF(p.x(), p.y(), -1, -1); drawImage(tmp, image, sr, flags);
    }
    pragma(inline, true) void drawImage(ref const(QPoint) p, ref const(QImage) image, ref const(QRect) sr,
                              /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor)
    {
        auto tmp = QRect(p.x(), p.y(), -1, -1); drawImage(tmp, image, sr, flags);
    }
    pragma(inline, true) void drawImage(ref const(QRectF) r, ref const(QImage) image)
    {
        auto tmp = QRectF(0, 0, image.width(), image.height()); drawImage(r, image, tmp);
    }
    pragma(inline, true) void drawImage(ref const(QRect) r, ref const(QImage) image)
    {
        auto tmp0 = QRectF(r); auto tmp = QRectF(0, 0, image.width(), image.height()); drawImage(tmp0, image, tmp);
    }
    void drawImage(ref const(QPointF) p, ref const(QImage) image);
    pragma(inline, true) void drawImage(ref const(QPoint) p, ref const(QImage) image)
    {
        auto tmp = QPointF(p); drawImage(tmp, image);
    }
    pragma(inline, true) void drawImage(int x, int y, ref const(QImage) image, int sx = 0, int sy = 0,
                              int sw = -1, int sh = -1, /+ Qt:: +/qt.core.namespace.ImageConversionFlags flags = /+ Qt:: +/qt.core.namespace.ImageConversionFlag.AutoColor)
    {
        if (sx == 0 && sy == 0 && sw == -1 && sh == -1 && flags == /+ Qt:: +/qt.core.namespace.ImageConversionFlags.AutoColor)
            { auto tmp = QPointF(x, y); drawImage(tmp, image);}
        else
            { auto tmp__1 = QRectF(x, y, -1, -1); auto tmp__2 = QRectF(sx, sy, sw, sh); drawImage(tmp__1, image, tmp__2, flags);}
    }

    void setLayoutDirection(/+ Qt:: +/qt.core.namespace.LayoutDirection direction);
    /+ Qt:: +/qt.core.namespace.LayoutDirection layoutDirection() const;

    version (QT_NO_RAWFONT) {} else
    {
        void drawGlyphRun(ref const(QPointF) position, ref const(QGlyphRun) glyphRun);
    }

    void drawStaticText(ref const(QPointF) topLeftPosition, ref const(QStaticText) staticText);
    pragma(inline, true) void drawStaticText(ref const(QPoint) p, ref const(QStaticText) staticText)
    {
        auto tmp = QPointF(p); drawStaticText(tmp, staticText);
    }
    pragma(inline, true) void drawStaticText(int x, int y, ref const(QStaticText) staticText)
    {
        auto tmp = QPointF(x, y); drawStaticText(tmp, staticText);
    }

    void drawText(ref const(QPointF) p, ref const(QString) s);
    pragma(inline, true) void drawText(ref const(QPoint) p, ref const(QString) s)
    {
        auto tmp = QPointF(p); drawText(tmp, s);
    }
    pragma(inline, true) void drawText(int x, int y, ref const(QString) s)
    {
        auto tmp = QPointF(x, y); drawText(tmp, s);
    }

    void drawText(ref const(QPointF) p, ref const(QString) str, int tf, int justificationPadding);

    void drawText(ref const(QRectF) r, int flags, ref const(QString) text, QRectF* br = null);
    void drawText(ref const(QRect) r, int flags, ref const(QString) text, QRect* br = null);
    pragma(inline, true) void drawText(int x, int y, int w, int h, int flags, ref const(QString) str, QRect* br = null)
    {
        auto tmp = QRect(x, y, w, h); drawText(tmp, flags, str, br);
    }

    void drawText(ref const(QRectF) r, ref const(QString) text, ref const(QTextOption) o = globalInitVar!QTextOption);

    QRectF boundingRect(ref const(QRectF) rect, int flags, ref const(QString) text);
    QRect boundingRect(ref const(QRect) rect, int flags, ref const(QString) text);
    pragma(inline, true) QRect boundingRect(int x, int y, int w, int h, int flags, ref const(QString) text)
    {
        auto tmp = QRect(x, y, w, h); return boundingRect(tmp, flags, text);
    }

    QRectF boundingRect(ref const(QRectF) rect, ref const(QString) text, ref const(QTextOption) o = globalInitVar!QTextOption);

    void drawTextItem(ref const(QPointF) p, ref const(QTextItem) ti);
    pragma(inline, true) void drawTextItem(int x, int y, ref const(QTextItem) ti)
    {
        auto tmp = QPointF(x, y); drawTextItem(tmp, ti);
    }
    pragma(inline, true) void drawTextItem(ref const(QPoint) p, ref const(QTextItem) ti)
    {
        auto tmp = QPointF(p); drawTextItem(tmp, ti);
    }

    void fillRect(ref const(QRectF) , ref const(QBrush) );
    pragma(inline, true) void fillRect(int x, int y, int w, int h, ref const(QBrush) b)
    {
        auto tmp = QRect(x, y, w, h); fillRect(tmp, b);
    }
    void fillRect(ref const(QRect) , ref const(QBrush) );

    void fillRect(ref const(QRectF) , ref const(QColor) color);
    pragma(inline, true) void fillRect(int x, int y, int w, int h, ref const(QColor) b)
    {
        auto tmp = QRect(x, y, w, h); fillRect(tmp, b);
    }
    void fillRect(ref const(QRect) , ref const(QColor) color);

    pragma(inline, true) void fillRect(int x, int y, int w, int h, /+ Qt:: +/qt.core.namespace.GlobalColor c)
    {
        auto tmp = QRect(x, y, w, h); auto tmp__1 = QColor(c); fillRect(tmp, tmp__1);
    }
    pragma(inline, true) void fillRect(ref const(QRect) r, /+ Qt:: +/qt.core.namespace.GlobalColor c)
    {
        auto tmp = QColor(c); fillRect(r, tmp);
    }
    pragma(inline, true) void fillRect(ref const(QRectF) r, /+ Qt:: +/qt.core.namespace.GlobalColor c)
    {
        auto tmp = QColor(c); fillRect(r, tmp);
    }

    pragma(inline, true) void fillRect(int x, int y, int w, int h, /+ Qt:: +/qt.core.namespace.BrushStyle style)
    {
        auto tmp = QRectF(x, y, w, h); auto tmp__1 = QBrush(style); fillRect(tmp, tmp__1);
    }
    pragma(inline, true) void fillRect(ref const(QRect) r, /+ Qt:: +/qt.core.namespace.BrushStyle style)
    {
        auto tmp = QRectF(r); auto tmp__1 = QBrush(style); fillRect(tmp, tmp__1);
    }
    pragma(inline, true) void fillRect(ref const(QRectF) r, /+ Qt:: +/qt.core.namespace.BrushStyle style)
    {
        auto tmp = QBrush(style); fillRect(r, tmp);
    }

/+    pragma(inline, true) void fillRect(int x, int y, int w, int h, QGradient.Preset p)
    {
        auto tmp = QRect(x, y, w, h); auto tmp2 = QGradient(p); fillRect(tmp, tmp2);
    }
    pragma(inline, true) void fillRect(ref const(QRect) r, QGradient.Preset p)
    {
        auto tmp = QGradient(p); fillRect(r, tmp);
    }
    pragma(inline, true) void fillRect(ref const(QRectF) r, QGradient.Preset p)
    {
        auto tmp = QGradient(p); fillRect(r, tmp);
    }+/

    void eraseRect(ref const(QRectF) );
    pragma(inline, true) void eraseRect(int x, int y, int w, int h)
    {
        auto tmp = QRectF(x, y, w, h); eraseRect(tmp);
    }
    pragma(inline, true) void eraseRect(ref const(QRect) rect)
    {
        auto tmp = QRectF(rect); eraseRect(tmp);
    }

    void setRenderHint(RenderHint hint, bool on = true);
    void setRenderHints(RenderHints hints, bool on = true);
    RenderHints renderHints() const;
    pragma(inline, true) bool testRenderHint(RenderHint hint) const { return cast(bool) (renderHints() & hint); }

    QPaintEngine paintEngine() const;

    void beginNativePainting();
    void endNativePainting();

private:
    /+ Q_DISABLE_COPY(QPainter) +/
@disable this(this);
/+@disable this(ref const(QPainter));+/@disable ref QPainter opAssign(ref const(QPainter));
    /+ std:: +//*unique_ptr!(QPainterPrivate)*/ QPainterPrivate* d_ptr;

    /+ friend class QWidget; +/
    /+ friend class QFontEngine; +/
    /+ friend class QFontEngineBox; +/
    /+ friend class QFontEngineFT; +/
    /+ friend class QFontEngineMac; +/
    /+ friend class QFontEngineWin; +/
    /+ friend class QPaintEngine; +/
    /+ friend class QPaintEngineExPrivate; +/
    /+ friend class QOpenGLPaintEngine; +/
    /+ friend class QWin32PaintEngine; +/
    /+ friend class QWin32PaintEnginePrivate; +/
    /+ friend class QRasterPaintEngine; +/
    /+ friend class QAlphaPaintEngine; +/
    /+ friend class QPreviewPaintEngine; +/
    /+ friend class QTextEngine; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QPainter.RenderHints.enum_type) operator |(QPainter.RenderHints.enum_type f1, QPainter.RenderHints.enum_type f2)nothrow{return QFlags!(QPainter.RenderHints.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QPainter.RenderHints.enum_type) operator |(QPainter.RenderHints.enum_type f1, QFlags!(QPainter.RenderHints.enum_type) f2)nothrow{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QPainter.RenderHints.enum_type) operator &(QPainter.RenderHints.enum_type f1, QPainter.RenderHints.enum_type f2)nothrow{return QFlags!(QPainter.RenderHints.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QPainter.RenderHints.enum_type) operator &(QPainter.RenderHints.enum_type f1, QFlags!(QPainter.RenderHints.enum_type) f2)nothrow{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QPainter.RenderHints.enum_type) operator ^(QPainter.RenderHints.enum_type f1, QPainter.RenderHints.enum_type f2)nothrow{return QFlags!(QPainter.RenderHints.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QPainter.RenderHints.enum_type) operator ^(QPainter.RenderHints.enum_type f1, QFlags!(QPainter.RenderHints.enum_type) f2)nothrow{return f2^f1;}+/
/+pragma(inline, true) void operator +(QPainter.RenderHints.enum_type f1, QPainter.RenderHints.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QPainter.RenderHints.enum_type f1, QFlags!(QPainter.RenderHints.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QPainter.RenderHints.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(QPainter.RenderHints.enum_type f1, QPainter.RenderHints.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QPainter.RenderHints.enum_type f1, QFlags!(QPainter.RenderHints.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QPainter.RenderHints.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QPainter.RenderHints.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QPainter.RenderHints.enum_type f1, int f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QPainter.RenderHints.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QPainter.RenderHints.enum_type f1, int f2)nothrow;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QPainter.RenderHints operator ~(QPainter.RenderHints.enum_type e)nothrow{return~QPainter.RenderHints(e);}+/
/+pragma(inline, true) void operator |(QPainter.RenderHints.enum_type f1, int f2)nothrow;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QPainter.RenderHints.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/
}
/+ Q_DECLARE_TYPEINFO(QPainter::PixmapFragment, Q_RELOCATABLE_TYPE);

Q_DECLARE_OPERATORS_FOR_FLAGS(QPainter::RenderHints)

#ifndef QT_NO_PICTURE
#endif +/

