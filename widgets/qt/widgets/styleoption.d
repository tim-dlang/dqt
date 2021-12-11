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
module qt.widgets.styleoption;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.flags;
import qt.core.global;
import qt.core.locale;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.core.rect;
import qt.core.size;
import qt.core.string;
import qt.core.variant;
import qt.gui.brush;
import qt.gui.color;
import qt.gui.font;
import qt.gui.fontmetrics;
import qt.gui.icon;
import qt.gui.matrix;
import qt.gui.palette;
import qt.gui.region;
import qt.gui.transform;
import qt.helpers;
import qt.widgets.abstractspinbox;
import qt.widgets.frame;
import qt.widgets.rubberband;
import qt.widgets.slider;
import qt.widgets.style;
import qt.widgets.tabbar;
import qt.widgets.widget;

/+ #if QT_CONFIG(spinbox)
#endif
#if QT_CONFIG(slider)
#endif
#if QT_CONFIG(tabbar)
#endif
#if QT_CONFIG(tabwidget)
#endif
#if QT_CONFIG(rubberband)
#endif
#if QT_CONFIG(itemviews)
#endif



class QDebug; +/

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOption
{
public:
    enum OptionType {
                      SO_Default, SO_FocusRect, SO_Button, SO_Tab, SO_MenuItem,
                      SO_Frame, SO_ProgressBar, SO_ToolBox, SO_Header,
                      SO_DockWidget, SO_ViewItem, SO_TabWidgetFrame,
                      SO_TabBarBase, SO_RubberBand, SO_ToolBar, SO_GraphicsItem,

                      SO_Complex = 0xf0000, SO_Slider, SO_SpinBox, SO_ToolButton, SO_ComboBox,
                      SO_TitleBar, SO_GroupBox, SO_SizeGrip,

                      SO_CustomBase = 0xf00,
                      SO_ComplexCustomBase = 0xf000000
                    }

    enum StyleOptionType { Type = OptionType.SO_Default }
    enum StyleOptionVersion { Version = 1 }

    int version_;
    int type;
    QStyle.State state;
    /+ Qt:: +/qt.core.namespace.LayoutDirection direction;
    QRect rect;
    QFontMetrics fontMetrics;
    QPalette palette;
    QObject styleObject;

    @disable this();
    this(int version_/+ = QStyleOption.StyleOptionVersion.Version+/, int type = OptionType.SO_Default);
    @disable this(this);
    this(ref const(QStyleOption) other);
    ~this();

    //void init_(const(QWidget) w);
    // pragma(inline, true) void initFrom(const(QWidget) w) { init_(w); }
    /+ref QStyleOption operator =(ref const(QStyleOption) other);+/
}

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionFocusRect
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_FocusRect }
    enum StyleOptionVersion { Version = 1 }

    QColor backgroundColor;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionFocusRect) other)
    {
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionFocusRect &operator=(const QStyleOptionFocusRect &) = default; +/

protected:
    this(int version_);
}

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionFrame
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_Frame }
    enum StyleOptionVersion { Version = 3 }

    int lineWidth;
    int midLineWidth;
    enum FrameFeature {
        None = 0x00,
        Flat = 0x01,
        Rounded = 0x02
    }
    /+ Q_DECLARE_FLAGS(FrameFeatures, FrameFeature) +/
alias FrameFeatures = QFlags!(FrameFeature);    FrameFeatures features;
    QFrame.Shape frameShape;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionFrame) other)
    {
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionFrame &operator=(const QStyleOptionFrame &) = default; +/

protected:
    this(int version_);
}
/+pragma(inline, true) QFlags!(QStyleOptionFrame.FrameFeatures.enum_type) operator |(QStyleOptionFrame.FrameFeatures.enum_type f1, QStyleOptionFrame.FrameFeatures.enum_type f2)/+noexcept+/{return QFlags!(QStyleOptionFrame.FrameFeatures.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QStyleOptionFrame.FrameFeatures.enum_type) operator |(QStyleOptionFrame.FrameFeatures.enum_type f1, QFlags!(QStyleOptionFrame.FrameFeatures.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QStyleOptionFrame.FrameFeatures.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QStyleOptionFrame::FrameFeatures) +/
/+ Q_DECL_DEPRECATED +/ alias QStyleOptionFrameV2 = QStyleOptionFrame;
/+ Q_DECL_DEPRECATED +/ alias QStyleOptionFrameV3 = QStyleOptionFrame;

/+ #if QT_CONFIG(tabwidget) +/
extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionTabWidgetFrame
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_TabWidgetFrame }
    enum StyleOptionVersion { Version = 2 }

    int lineWidth;
    int midLineWidth;
    QTabBar.Shape shape;
    QSize tabBarSize;
    QSize rightCornerWidgetSize;
    QSize leftCornerWidgetSize;
    QRect tabBarRect;
    QRect selectedTabRect;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    pragma(inline, true) this(ref const(QStyleOptionTabWidgetFrame) other)
    {
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionTabWidgetFrame &operator=(const QStyleOptionTabWidgetFrame &) = default; +/

protected:
    this(int version_);
}

/+ Q_DECL_DEPRECATED +/ alias QStyleOptionTabWidgetFrameV2 = QStyleOptionTabWidgetFrame;
/+ #endif // QT_CONFIG(tabwidget)


#if QT_CONFIG(tabbar) +/
extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionTabBarBase
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_TabBarBase }
    enum StyleOptionVersion { Version = 2 }

    QTabBar.Shape shape;
    QRect tabBarRect;
    QRect selectedTabRect;
    bool documentMode;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionTabBarBase) other)
    {
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionTabBarBase &operator=(const QStyleOptionTabBarBase &) = default; +/

protected:
    this(int version_);
}

/+ Q_DECL_DEPRECATED +/ alias QStyleOptionTabBarBaseV2 = QStyleOptionTabBarBase;
/+ #endif +/ // QT_CONFIG(tabbar)

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionHeader
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_Header }
    enum StyleOptionVersion { Version = 1 }

    enum SectionPosition { Beginning, Middle, End, OnlyOneSection }
    enum SelectedPosition { NotAdjacent, NextIsSelected, PreviousIsSelected,
                            NextAndPreviousAreSelected }
    enum SortIndicator { None, SortUp, SortDown }

    int section;
    QString text;
    /+ Qt:: +/qt.core.namespace.Alignment textAlignment;
    QIcon icon;
    /+ Qt:: +/qt.core.namespace.Alignment iconAlignment;
    SectionPosition position;
    SelectedPosition selectedPosition;
    SortIndicator sortIndicator;
    /+ Qt:: +/qt.core.namespace.Orientation orientation;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionHeader) other)
    {
        text = QString.create;
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionHeader &operator=(const QStyleOptionHeader &) = default; +/

protected:
    this(int version_);
}

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionButton
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_Button }
    enum StyleOptionVersion { Version = 1 }

    enum ButtonFeature { None = 0x00, Flat = 0x01, HasMenu = 0x02, DefaultButton = 0x04,
                         AutoDefaultButton = 0x08, CommandLinkButton = 0x10  }
    /+ Q_DECLARE_FLAGS(ButtonFeatures, ButtonFeature) +/
alias ButtonFeatures = QFlags!(ButtonFeature);
    ButtonFeatures features;
    QString text;
    QIcon icon;
    QSize iconSize;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionButton) other)
    {
        text = QString.create;
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionButton &operator=(const QStyleOptionButton &) = default; +/

protected:
    this(int version_);
}
/+pragma(inline, true) QFlags!(QStyleOptionButton.ButtonFeatures.enum_type) operator |(QStyleOptionButton.ButtonFeatures.enum_type f1, QStyleOptionButton.ButtonFeatures.enum_type f2)/+noexcept+/{return QFlags!(QStyleOptionButton.ButtonFeatures.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QStyleOptionButton.ButtonFeatures.enum_type) operator |(QStyleOptionButton.ButtonFeatures.enum_type f1, QFlags!(QStyleOptionButton.ButtonFeatures.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QStyleOptionButton.ButtonFeatures.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QStyleOptionButton::ButtonFeatures)
#if QT_CONFIG(tabbar) +/
extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionTab
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_Tab }
    enum StyleOptionVersion { Version = 3 }

    enum TabPosition { Beginning, Middle, End, OnlyOneTab }
    enum SelectedPosition { NotAdjacent, NextIsSelected, PreviousIsSelected }
    enum CornerWidget { NoCornerWidgets = 0x00, LeftCornerWidget = 0x01,
                        RightCornerWidget = 0x02 }
    enum TabFeature { None = 0x00, HasFrame = 0x01 }
    /+ Q_DECLARE_FLAGS(CornerWidgets, CornerWidget) +/
alias CornerWidgets = QFlags!(CornerWidget);    /+ Q_DECLARE_FLAGS(TabFeatures, TabFeature) +/
alias TabFeatures = QFlags!(TabFeature);
    QTabBar.Shape shape;
    QString text;
    QIcon icon;
    int row;
    TabPosition position;
    SelectedPosition selectedPosition;
    CornerWidgets cornerWidgets;
    QSize iconSize;
    bool documentMode;
    QSize leftButtonSize;
    QSize rightButtonSize;
    TabFeatures features;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionTab) other)
    {
        text = QString.create(); 
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionTab &operator=(const QStyleOptionTab &) = default; +/

protected:
    this(int version_);
}

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionTabV4
{
    public QStyleOptionTab base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionVersion { Version = 4 }
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    int tabIndex = -1;
}
/+pragma(inline, true) QFlags!(QStyleOptionTab.CornerWidgets.enum_type) operator |(QStyleOptionTab.CornerWidgets.enum_type f1, QStyleOptionTab.CornerWidgets.enum_type f2)/+noexcept+/{return QFlags!(QStyleOptionTab.CornerWidgets.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QStyleOptionTab.CornerWidgets.enum_type) operator |(QStyleOptionTab.CornerWidgets.enum_type f1, QFlags!(QStyleOptionTab.CornerWidgets.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QStyleOptionTab.CornerWidgets.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QStyleOptionTab::CornerWidgets) +/
/+ Q_DECL_DEPRECATED +/ alias QStyleOptionTabV2 = QStyleOptionTab;
/+ Q_DECL_DEPRECATED +/ alias QStyleOptionTabV3 = QStyleOptionTab;
/+ #endif // QT_CONFIG(tabbar)


#if QT_CONFIG(toolbar) +/

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionToolBar
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_ToolBar }
    enum StyleOptionVersion { Version = 1 }
    enum ToolBarPosition { Beginning, Middle, End, OnlyOne }
    enum ToolBarFeature { None = 0x0, Movable = 0x1 }
    /+ Q_DECLARE_FLAGS(ToolBarFeatures, ToolBarFeature) +/
alias ToolBarFeatures = QFlags!(ToolBarFeature);    ToolBarPosition positionOfLine; // The toolbar line position
    ToolBarPosition positionWithinLine; // The position within a toolbar
    /+ Qt:: +/qt.core.namespace.ToolBarArea toolBarArea; // The toolbar docking area
    ToolBarFeatures features;
    int lineWidth;
    int midLineWidth;
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionToolBar) other)
    {
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionToolBar &operator=(const QStyleOptionToolBar &) = default; +/

protected:
    this(int version_);
}
/+pragma(inline, true) QFlags!(QStyleOptionToolBar.ToolBarFeatures.enum_type) operator |(QStyleOptionToolBar.ToolBarFeatures.enum_type f1, QStyleOptionToolBar.ToolBarFeatures.enum_type f2)/+noexcept+/{return QFlags!(QStyleOptionToolBar.ToolBarFeatures.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QStyleOptionToolBar.ToolBarFeatures.enum_type) operator |(QStyleOptionToolBar.ToolBarFeatures.enum_type f1, QFlags!(QStyleOptionToolBar.ToolBarFeatures.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QStyleOptionToolBar.ToolBarFeatures.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QStyleOptionToolBar::ToolBarFeatures) +/
/+ #endif +/ // QT_CONFIG(toolbar)

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionProgressBar
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_ProgressBar }
    enum StyleOptionVersion { Version = 2 }

    int minimum;
    int maximum;
    int progress;
    QString text;
    /+ Qt:: +/qt.core.namespace.Alignment textAlignment;
    bool textVisible;
    /+ Qt:: +/qt.core.namespace.Orientation orientation; // ### Qt 6: remove
    bool invertedAppearance;
    bool bottomToTop;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionProgressBar) other)
    {
        text = QString.create();
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionProgressBar &operator=(const QStyleOptionProgressBar &) = default; +/

protected:
    this(int version_);
}

/+ Q_DECL_DEPRECATED +/ alias QStyleOptionProgressBarV2 = QStyleOptionProgressBar;

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionMenuItem
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_MenuItem }
    enum StyleOptionVersion { Version = 1 }

    enum MenuItemType { Normal, DefaultItem, Separator, SubMenu, Scroller, TearOff, Margin,
                        EmptyArea }
    enum CheckType { NotCheckable, Exclusive, NonExclusive }

    MenuItemType menuItemType;
    CheckType checkType;
    bool checked;
    bool menuHasCheckableItems;
    QRect menuRect;
    QString text;
    QIcon icon;
    int maxIconWidth;
    int tabWidth; // ### Qt 6: rename to reservedShortcutWidth
    QFont font;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionMenuItem) other)
    {
        text = QString.create;
        font = QFont.create;
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionMenuItem &operator=(const QStyleOptionMenuItem &) = default; +/

protected:
    this(int version_);
}

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionDockWidget
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_DockWidget }
    enum StyleOptionVersion { Version = 2 }

    QString title;
    bool closable;
    bool movable;
    bool floatable;
    bool verticalTitleBar;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionDockWidget) other)
    {
        title = QString.create();
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionDockWidget &operator=(const QStyleOptionDockWidget &) = default; +/

protected:
    this(int version_);
}

/+ Q_DECL_DEPRECATED +/ alias QStyleOptionDockWidgetV2 = QStyleOptionDockWidget;

/+ #if QT_CONFIG(itemviews) +/

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionViewItem
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_ViewItem }
    enum StyleOptionVersion { Version = 4 }

    enum Position { Left, Right, Top, Bottom }

    /+ Qt:: +/qt.core.namespace.Alignment displayAlignment;
    /+ Qt:: +/qt.core.namespace.Alignment decorationAlignment;
    /+ Qt:: +/qt.core.namespace.TextElideMode textElideMode;
    Position decorationPosition;
    QSize decorationSize;
    QFont font;
    bool showDecorationSelected;

    enum ViewItemFeature {
        None = 0x00,
        WrapText = 0x01,
        Alternate = 0x02,
        HasCheckIndicator = 0x04,
        HasDisplay = 0x08,
        HasDecoration = 0x10
    }
    /+ Q_DECLARE_FLAGS(ViewItemFeatures, ViewItemFeature) +/
alias ViewItemFeatures = QFlags!(ViewItemFeature);
    ViewItemFeatures features;

    QLocale locale;
    /*const*/ QWidget widget;

    enum ViewItemPosition { Invalid, Beginning, Middle, End, OnlyOne }

    QModelIndex index;
    /+ Qt:: +/qt.core.namespace.CheckState checkState;
    QIcon icon;
    QString text;
    ViewItemPosition viewItemPosition;
    QBrush backgroundBrush;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionViewItem) other)
    {
        font = QFont.create;
        text = QString.create;
        locale = QLocale.create;
        backgroundBrush = QBrush.create;
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionViewItem &operator=(const QStyleOptionViewItem &) = default; +/

protected:
    this(int version_);
}
/+pragma(inline, true) QFlags!(QStyleOptionViewItem.ViewItemFeatures.enum_type) operator |(QStyleOptionViewItem.ViewItemFeatures.enum_type f1, QStyleOptionViewItem.ViewItemFeatures.enum_type f2)/+noexcept+/{return QFlags!(QStyleOptionViewItem.ViewItemFeatures.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QStyleOptionViewItem.ViewItemFeatures.enum_type) operator |(QStyleOptionViewItem.ViewItemFeatures.enum_type f1, QFlags!(QStyleOptionViewItem.ViewItemFeatures.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QStyleOptionViewItem.ViewItemFeatures.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QStyleOptionViewItem::ViewItemFeatures) +/
/+ Q_DECL_DEPRECATED +/ alias QStyleOptionViewItemV2 = QStyleOptionViewItem;
/+ Q_DECL_DEPRECATED +/ alias QStyleOptionViewItemV3 = QStyleOptionViewItem;
/+ Q_DECL_DEPRECATED +/ alias QStyleOptionViewItemV4 = QStyleOptionViewItem;

/+ #endif +/ // QT_CONFIG(itemviews)

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionToolBox
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_ToolBox }
    enum StyleOptionVersion { Version = 2 }

    QString text;
    QIcon icon;

    enum TabPosition { Beginning, Middle, End, OnlyOneTab }
    enum SelectedPosition { NotAdjacent, NextIsSelected, PreviousIsSelected }

    TabPosition position;
    SelectedPosition selectedPosition;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionToolBox) other)
    {
        text = QString.create;
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionToolBox &operator=(const QStyleOptionToolBox &) = default; +/

protected:
    this(int version_);
}

/+ Q_DECL_DEPRECATED +/ alias QStyleOptionToolBoxV2 = QStyleOptionToolBox;

/+ #if QT_CONFIG(rubberband) +/
extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionRubberBand
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_RubberBand }
    enum StyleOptionVersion { Version = 1 }

    QRubberBand.Shape shape;
    bool opaque;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionRubberBand) other)
    {
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionRubberBand &operator=(const QStyleOptionRubberBand &) = default; +/

protected:
    this(int version_);
}
/+ #endif +/ // QT_CONFIG(rubberband)

// -------------------------- Complex style options -------------------------------
extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionComplex
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_Complex }
    enum StyleOptionVersion { Version = 1 }

    QStyle.SubControls subControls;
    QStyle.SubControls activeSubControls;

    @disable this();
    this(int version_/+ = QStyleOptionComplex.StyleOptionVersion.Version+/, int type = OptionType.SO_Complex);
    @disable this(this);
    this(ref const(QStyleOptionComplex) other)
    {
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionComplex &operator=(const QStyleOptionComplex &) = default; +/
}

/+ #if QT_CONFIG(slider) +/
extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionSlider
{
    public QStyleOptionComplex base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_Slider }
    enum StyleOptionVersion { Version = 1 }

    /+ Qt:: +/qt.core.namespace.Orientation orientation;
    int minimum;
    int maximum;
    QSlider.TickPosition tickPosition;
    int tickInterval;
    bool upsideDown;
    int sliderPosition;
    int sliderValue;
    int singleStep;
    int pageStep;
    qreal notchTarget;
    bool dialWrapping;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionSlider) other)
    {
        this.base0 = QStyleOptionComplex(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionSlider &operator=(const QStyleOptionSlider &) = default; +/

protected:
    this(int version_);
}
/+ #endif // QT_CONFIG(slider)

#if QT_CONFIG(spinbox) +/
extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionSpinBox
{
    public QStyleOptionComplex base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_SpinBox }
    enum StyleOptionVersion { Version = 1 }

    QAbstractSpinBox.ButtonSymbols buttonSymbols;
    QAbstractSpinBox.StepEnabled stepEnabled;
    bool frame;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionSpinBox) other)
    {
        this.base0 = QStyleOptionComplex(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionSpinBox &operator=(const QStyleOptionSpinBox &) = default; +/

protected:
    this(int version_);
}
/+ #endif +/ // QT_CONFIG(spinbox)

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionToolButton
{
    public QStyleOptionComplex base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_ToolButton }
    enum StyleOptionVersion { Version = 1 }

    enum ToolButtonFeature { None = 0x00, Arrow = 0x01, Menu = 0x04, MenuButtonPopup = ToolButtonFeature.Menu, PopupDelay = 0x08,
                             HasMenu = 0x10 }
    /+ Q_DECLARE_FLAGS(ToolButtonFeatures, ToolButtonFeature) +/
alias ToolButtonFeatures = QFlags!(ToolButtonFeature);
    ToolButtonFeatures features;
    QIcon icon;
    QSize iconSize;
    QString text;
    /+ Qt:: +/qt.core.namespace.ArrowType arrowType;
    /+ Qt:: +/qt.core.namespace.ToolButtonStyle toolButtonStyle;
    QPoint pos;
    QFont font;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionToolButton) other)
    {
        text = QString.create;
        font = QFont.create;
        this.base0 = QStyleOptionComplex(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionToolButton &operator=(const QStyleOptionToolButton &) = default; +/

protected:
    this(int version_);
}
/+pragma(inline, true) QFlags!(QStyleOptionToolButton.ToolButtonFeatures.enum_type) operator |(QStyleOptionToolButton.ToolButtonFeatures.enum_type f1, QStyleOptionToolButton.ToolButtonFeatures.enum_type f2)/+noexcept+/{return QFlags!(QStyleOptionToolButton.ToolButtonFeatures.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QStyleOptionToolButton.ToolButtonFeatures.enum_type) operator |(QStyleOptionToolButton.ToolButtonFeatures.enum_type f1, QFlags!(QStyleOptionToolButton.ToolButtonFeatures.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QStyleOptionToolButton.ToolButtonFeatures.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QStyleOptionToolButton::ToolButtonFeatures) +/
extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionComboBox
{
    public QStyleOptionComplex base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_ComboBox }
    enum StyleOptionVersion { Version = 1 }

    bool editable;
    QRect popupRect;
    bool frame;
    QString currentText;
    QIcon currentIcon;
    QSize iconSize;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionComboBox) other)
    {
        currentText = QString.create;
        this.base0 = QStyleOptionComplex(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionComboBox &operator=(const QStyleOptionComboBox &) = default; +/

protected:
    this(int version_);
}

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionTitleBar
{
    public QStyleOptionComplex base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_TitleBar }
    enum StyleOptionVersion { Version = 1 }

    QString text;
    QIcon icon;
    int titleBarState;
    /+ Qt:: +/qt.core.namespace.WindowFlags titleBarFlags;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionTitleBar) other)
    {
        text = QString.create;
        this.base0 = QStyleOptionComplex(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionTitleBar &operator=(const QStyleOptionTitleBar &) = default; +/

protected:
    this(int version_);
}

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionGroupBox
{
    public QStyleOptionComplex base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_GroupBox }
    enum StyleOptionVersion { Version = 1 }

    QStyleOptionFrame.FrameFeatures features;
    QString text;
    /+ Qt:: +/qt.core.namespace.Alignment textAlignment;
    QColor textColor;
    int lineWidth;
    int midLineWidth;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionGroupBox) other)
    {
        text = QString.create;
        this.base0 = QStyleOptionComplex(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionGroupBox &operator=(const QStyleOptionGroupBox &) = default; +/
protected:
    this(int version_);
}

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionSizeGrip
{
    public QStyleOptionComplex base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_SizeGrip }
    enum StyleOptionVersion { Version = 1 }

    /+ Qt:: +/qt.core.namespace.Corner corner;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionSizeGrip) other)
    {
        this.base0 = QStyleOptionComplex(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionSizeGrip &operator=(const QStyleOptionSizeGrip &) = default; +/
protected:
    this(int version_);
}

extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleOptionGraphicsItem
{
    public QStyleOption base0;
    alias base0 this;
    alias OptionType = QStyleOption.OptionType;
public:
    enum StyleOptionType { Type = OptionType.SO_GraphicsItem }
    enum StyleOptionVersion { Version = 1 }

    QRectF exposedRect;
    QMatrix matrix;
    qreal levelOfDetail;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QStyleOptionGraphicsItem) other)
    {
        this.base0 = QStyleOption(StyleOptionVersion.Version, StyleOptionType.Type);
        this = other;
    }
    /+ QStyleOptionGraphicsItem &operator=(const QStyleOptionGraphicsItem &) = default; +/
    static qreal levelOfDetailFromTransform(ref const(QTransform) worldTransform);
protected:
    this(int version_);
}

T qstyleoption_cast(T)(const(QStyleOption)* opt)
{
    /+ typename std::remove_cv<typename std::remove_pointer<T>::type>::type +/alias Opt = type;
    if (opt && opt.version_ >= Opt.Version && (opt.type == Opt.Type
        || int(Opt.Type) == QStyleOption.OptionType.SO_Default
        || (int(Opt.Type) == QStyleOption.OptionType.SO_Complex
            && opt.type > QStyleOption.OptionType.SO_Complex)))
        return static_cast!(T)(opt);
    return null;
}

T qstyleoption_cast(T)(QStyleOption* opt)
{
    /+ typename std::remove_cv<typename std::remove_pointer<T>::type>::type +/alias Opt = type;
    if (opt && opt.version_ >= Opt.Version && (opt.type == Opt.Type
        || int(Opt.Type) == QStyleOption.OptionType.SO_Default
        || (int(Opt.Type) == QStyleOption.OptionType.SO_Complex
            && opt.type > QStyleOption.OptionType.SO_Complex)))
        return static_cast!(T)(opt);
    return null;
}

// -------------------------- QStyleHintReturn -------------------------------
extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QStyleHintReturn {
public:
    enum HintReturnType {
        SH_Default=0xf000, SH_Mask, SH_Variant
    }

    enum StyleOptionType { Type = HintReturnType.SH_Default }
    enum StyleOptionVersion { Version = 1 }

    @disable this();
    this(int version_/+ = QStyleOption.StyleOptionVersion.Version+/, int type = HintReturnType.SH_Default);
    ~this();

    int version_;
    int type;
}

/+class /+ Q_WIDGETS_EXPORT +/ QStyleHintReturnMask : QStyleHintReturn {
public:
    enum StyleOptionType { Type = HintReturnType.SH_Mask }
    enum StyleOptionVersion { Version = 1 }

    this();
    ~this();

    QRegion region;
}

class /+ Q_WIDGETS_EXPORT +/ QStyleHintReturnVariant : QStyleHintReturn {
public:
    enum StyleOptionType { Type = HintReturnType.SH_Variant }
    enum StyleOptionVersion { Version = 1 }

    this();
    ~this();

    QVariant variant;
}
+/

T qstyleoption_cast(T)(const(QStyleHintReturn)* hint)
{
    /+ typename std::remove_cv<typename std::remove_pointer<T>::type>::type +/alias Opt = type;
    if (hint && hint.version_ <= Opt.Version &&
        (hint.type == Opt.Type || int(Opt.Type) == QStyleHintReturn.HintReturnType.SH_Default))
        return static_cast!(T)(hint);
    return null;
}

T qstyleoption_cast(T)(QStyleHintReturn* hint)
{
    /+ typename std::remove_cv<typename std::remove_pointer<T>::type>::type +/alias Opt = type;
    if (hint && hint.version_ <= Opt.Version &&
        (hint.type == Opt.Type || int(Opt.Type) == QStyleHintReturn.HintReturnType.SH_Default))
        return static_cast!(T)(hint);
    return null;
}

/+ #if !defined(QT_NO_DEBUG_STREAM)
Q_WIDGETS_EXPORT QDebug operator<<(QDebug debug, const QStyleOption::OptionType &optionType);
Q_WIDGETS_EXPORT QDebug operator<<(QDebug debug, const QStyleOption &option);
#endif +/

