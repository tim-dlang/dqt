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
module qt.gui.palette;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.metamacros;
import qt.core.namespace;
import qt.core.typeinfo;
import qt.core.variant;
import qt.gui.brush;
import qt.gui.color;
import qt.helpers;

extern(C++, class) struct QPalettePrivate;

/// Binding for C++ class [QPalette](https://doc.qt.io/qt-5/qpalette.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPalette
{
    mixin(Q_GADGET);
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(ref const(QColor) button);
    this(/+ Qt:: +/qt.core.namespace.GlobalColor button);
    this(ref const(QColor) button, ref const(QColor) window);
    this(ref const(QBrush) windowText, ref const(QBrush) button, ref const(QBrush) light,
                 ref const(QBrush) dark, ref const(QBrush) mid, ref const(QBrush) text,
                 ref const(QBrush) bright_text, ref const(QBrush) base, ref const(QBrush) window);
    this(ref const(QColor) windowText, ref const(QColor) window, ref const(QColor) light,
                 ref const(QColor) dark, ref const(QColor) mid, ref const(QColor) text, ref const(QColor) base);
    @disable this(this);
    this(ref const(QPalette) palette);
    ~this();
    /+ref QPalette operator =(ref const(QPalette) palette);+/
    /+ QPalette(QPalette &&other) noexcept
        : d(other.d), data(other.data)
    { other.d = nullptr; } +/
    /+ inline QPalette &operator=(QPalette &&other) noexcept
    {
        for_faster_swapping_dont_use = other.for_faster_swapping_dont_use;
        qSwap(d, other.d); return *this;
    } +/

    /+ void swap(QPalette &other) noexcept
    {
        qSwap(d, other.d);
        qSwap(for_faster_swapping_dont_use, other.for_faster_swapping_dont_use);
    } +/

    /+auto opCast(T : QVariant)() const;+/

    // Do not change the order, the serialization format depends on it
    enum ColorGroup { Active, Disabled, Inactive, NColorGroups, Current, All, Normal = ColorGroup.Active }
    /+ Q_ENUM(ColorGroup) +/
    enum ColorRole { WindowText, Button, Light, Midlight, Dark, Mid,
                     Text, BrightText, ButtonText, Base, Window, Shadow,
                     Highlight, HighlightedText,
                     Link, LinkVisited,
                     AlternateBase,
                     NoRole,
                     ToolTipBase, ToolTipText,
                     PlaceholderText,
                     NColorRoles = ColorRole.PlaceholderText + 1,
/+ #if QT_DEPRECATED_SINCE(5, 13) +/
                     Foreground /+ Q_DECL_ENUMERATOR_DEPRECATED_X("Use QPalette::WindowText instead") +/ = ColorRole.WindowText,
                     Background /+ Q_DECL_ENUMERATOR_DEPRECATED_X("Use QPalette::Window instead") +/ = ColorRole.Window
/+ #endif +/
                   }
    /+ Q_ENUM(ColorRole) +/

    pragma(inline, true) ColorGroup currentColorGroup() const { return static_cast!(ColorGroup)(data.current_group); }
    pragma(inline, true) void setCurrentColorGroup(ColorGroup cg) { data.current_group = cg; }

    pragma(inline, true) ref const(QColor) color(ColorGroup cg, ColorRole cr) const
    { return brush(cg, cr).color(); }
    ref const(QBrush) brush(ColorGroup cg, ColorRole cr) const;
    pragma(inline, true) void setColor(ColorGroup acg, ColorRole acr, ref const(QColor) acolor)
    { auto tmp = QBrush(acolor); setBrush(acg, acr, tmp); }
    pragma(inline, true) void setColor(ColorRole acr, ref const(QColor) acolor)
    { setColor(ColorGroup.All, acr, acolor); }
    pragma(inline, true) void setBrush(ColorRole acr, ref const(QBrush) abrush)
    { setBrush(ColorGroup.All, acr, abrush); }
    bool isBrushSet(ColorGroup cg, ColorRole cr) const;
    void setBrush(ColorGroup cg, ColorRole cr, ref const(QBrush) brush);
    void setColorGroup(ColorGroup cr, ref const(QBrush) windowText, ref const(QBrush) button,
                           ref const(QBrush) light, ref const(QBrush) dark, ref const(QBrush) mid,
                           ref const(QBrush) text, ref const(QBrush) bright_text, ref const(QBrush) base,
                           ref const(QBrush) window);
    bool isEqual(ColorGroup cr1, ColorGroup cr2) const;

    pragma(inline, true) ref const(QColor) color(ColorRole cr) const { return color(ColorGroup.Current, cr); }
    pragma(inline, true) ref const(QBrush) brush(ColorRole cr) const { return brush(ColorGroup.Current, cr); }
    pragma(inline, true) ref const(QBrush) windowText() const { return brush(ColorRole.WindowText); }
    pragma(inline, true) ref const(QBrush) button() const { return brush(ColorRole.Button); }
    pragma(inline, true) ref const(QBrush) light() const { return brush(ColorRole.Light); }
    pragma(inline, true) ref const(QBrush) dark() const { return brush(ColorRole.Dark); }
    pragma(inline, true) ref const(QBrush) mid() const { return brush(ColorRole.Mid); }
    pragma(inline, true) ref const(QBrush) text() const { return brush(ColorRole.Text); }
    pragma(inline, true) ref const(QBrush) base() const { return brush(ColorRole.Base); }
    pragma(inline, true) ref const(QBrush) alternateBase() const { return brush(ColorRole.AlternateBase); }
    pragma(inline, true) ref const(QBrush) toolTipBase() const { return brush(ColorRole.ToolTipBase); }
    pragma(inline, true) ref const(QBrush) toolTipText() const { return brush(ColorRole.ToolTipText); }
    pragma(inline, true) ref const(QBrush) window() const { return brush(ColorRole.Window); }
    pragma(inline, true) ref const(QBrush) midlight() const { return brush(ColorRole.Midlight); }
    pragma(inline, true) ref const(QBrush) brightText() const { return brush(ColorRole.BrightText); }
    pragma(inline, true) ref const(QBrush) buttonText() const { return brush(ColorRole.ButtonText); }
    pragma(inline, true) ref const(QBrush) shadow() const { return brush(ColorRole.Shadow); }
    pragma(inline, true) ref const(QBrush) highlight() const { return brush(ColorRole.Highlight); }
    pragma(inline, true) ref const(QBrush) highlightedText() const { return brush(ColorRole.HighlightedText); }
    pragma(inline, true) ref const(QBrush) link() const { return brush(ColorRole.Link); }
    pragma(inline, true) ref const(QBrush) linkVisited() const { return brush(ColorRole.LinkVisited); }
    pragma(inline, true) ref const(QBrush) placeholderText() const { return brush(ColorRole.PlaceholderText); }
/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use QPalette::windowText() instead") +/
        pragma(inline, true) ref const(QBrush) foreground() const { return windowText(); }
    /+ QT_DEPRECATED_X("Use QPalette::window() instead") +/
        pragma(inline, true) ref const(QBrush) background() const { return window(); }
/+ #endif +/

    /+bool operator ==(ref const(QPalette) p) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QPalette) p) const { return !(operator==(p)); }+/
    bool isCopyOf(ref const(QPalette) p) const;

/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED inline int serialNumber() const { return cacheKey() >> 32; }
#endif +/
    qint64 cacheKey() const;

    QPalette resolve(ref const(QPalette) ) const;
    pragma(inline, true) uint resolve() const { return data.resolve_mask; }
    pragma(inline, true) void resolve(uint mask) { data.resolve_mask = mask; }

private:
    void setColorGroup(ColorGroup cr, ref const(QBrush) windowText, ref const(QBrush) button,
                           ref const(QBrush) light, ref const(QBrush) dark, ref const(QBrush) mid,
                           ref const(QBrush) text, ref const(QBrush) bright_text,
                           ref const(QBrush) base, ref const(QBrush) alternate_base,
                           ref const(QBrush) window, ref const(QBrush) midlight,
                           ref const(QBrush) button_text, ref const(QBrush) shadow,
                           ref const(QBrush) highlight, ref const(QBrush) highlighted_text,
                           ref const(QBrush) link, ref const(QBrush) link_visited);
    void setColorGroup(ColorGroup cr, ref const(QBrush) windowText, ref const(QBrush) button,
                           ref const(QBrush) light, ref const(QBrush) dark, ref const(QBrush) mid,
                           ref const(QBrush) text, ref const(QBrush) bright_text,
                           ref const(QBrush) base, ref const(QBrush) alternate_base,
                           ref const(QBrush) window, ref const(QBrush) midlight,
                           ref const(QBrush) button_text, ref const(QBrush) shadow,
                           ref const(QBrush) highlight, ref const(QBrush) highlighted_text,
                           ref const(QBrush) link, ref const(QBrush) link_visited,
                           ref const(QBrush) toolTipBase, ref const(QBrush) toolTipText);
    //void init_();
    void detach();

    QPalettePrivate* d;
    struct Data {
        /+ uint current_group : 4; +/
        uint bitfieldData_current_group;
        final uint current_group() const
        {
            return (bitfieldData_current_group >> 0) & 0xf;
        }
        final uint current_group(uint value)
        {
            bitfieldData_current_group = (bitfieldData_current_group & ~0xf) | ((value & 0xf) << 0);
            return value;
        }
        /+ uint resolve_mask : 28; +/
        final uint resolve_mask() const
        {
            return (bitfieldData_current_group >> 4) & 0xfffffff;
        }
        final uint resolve_mask(uint value)
        {
            bitfieldData_current_group = (bitfieldData_current_group & ~0xfffffff0) | ((value & 0xfffffff) << 4);
            return value;
        }
    }
    union {
        Data data;
        quint32 for_faster_swapping_dont_use;
    }
    /+ friend Q_GUI_EXPORT QDataStream &operator<<(QDataStream &s, const QPalette &p); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QPalette)

/*****************************************************************************
  QPalette stream functions
 *****************************************************************************/
#ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &ds, const QPalette &p);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &ds, QPalette &p);
#endif // QT_NO_DATASTREAM

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug, const QPalette &);
#endif +/

