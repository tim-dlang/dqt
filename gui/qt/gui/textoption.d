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
module qt.gui.textoption;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.qchar;
import qt.helpers;

/+ template <typename T> class QList; +/
struct QTextOptionPrivate;

extern(C++, class) struct /+ Q_GUI_EXPORT +/ QTextOption
{
public:
    enum TabType {
        LeftTab,
        RightTab,
        CenterTab,
        DelimiterTab
    }

    struct /+ Q_GUI_EXPORT +/ Tab {
        @disable this();
        /+pragma(inline, true) this()
        {
            this.position = 80;
            this.type = QTextOption.TabType.LeftTab;
        }+/
        pragma(inline, true) this(qreal pos, TabType tabType, QChar delim = QChar())
        {
            this.position = pos;
            this.type = tabType;
            this.delimiter = delim;
        }

        /+pragma(inline, true) bool operator ==(ref const(Tab) other) const {
            return type == other.type
                   && qFuzzyCompare(position, other.position)
                   && delimiter == other.delimiter;
        }+/

        /+pragma(inline, true) bool operator !=(ref const(Tab) other) const {
            return !operator==(other);
        }+/

        qreal position = 80;
        TabType type = QTextOption.TabType.LeftTab;
        QChar delimiter;
    }

    /*@disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }*/

    /*implicit*/ this(/+ Qt:: +/qt.core.namespace.Alignment alignment);
    ~this();

    @disable this(this);
    this(ref const(QTextOption) o);
    /+ref QTextOption operator =(ref const(QTextOption) o);+/

    pragma(inline, true) void setAlignment(/+ Qt:: +/qt.core.namespace.Alignment aalignment)
    { align_ = cast(uint)(aalignment.toInt); }
    pragma(inline, true) /+ Qt:: +/qt.core.namespace.Alignment alignment() const { return /+ Qt:: +/qt.core.namespace.Alignment(cast(QFlag)(align_)); }

    pragma(inline, true) void setTextDirection(/+ Qt:: +/qt.core.namespace.LayoutDirection aDirection) { this.direction = aDirection; }
//    pragma(inline, true) /+ Qt:: +/qt.core.namespace.LayoutDirection textDirection() const { return /+ Qt:: +/qt.core.namespace.LayoutDirection(direction); }

    enum WrapMode {
        NoWrap,
        WordWrap,
        ManualWrap,
        WrapAnywhere,
        WrapAtWordBoundaryOrAnywhere
    }
    pragma(inline, true) void setWrapMode(WrapMode wrap) { wordWrap = wrap; }
    pragma(inline, true) WrapMode wrapMode() const { return static_cast!(WrapMode)(wordWrap); }

    enum Flag {
        ShowTabsAndSpaces = 0x1,
        ShowLineAndParagraphSeparators = 0x2,
        AddSpaceForLineAndParagraphSeparators = 0x4,
        SuppressColors = 0x8,
        ShowDocumentTerminator = 0x10,
        IncludeTrailingSpaces = 0x80000000
    }
    /+ Q_DECLARE_FLAGS(Flags, Flag) +/
alias Flags = QFlags!(Flag);    pragma(inline, true) void setFlags(Flags aflags)
{ f = cast(uint)(aflags); }
//    pragma(inline, true) Flags flags() const { return Flags(cast(QFlag)(f)); }

/+ #if QT_DEPRECATED_SINCE(5, 10) +/
    /+ QT_DEPRECATED +/ pragma(inline, true) void setTabStop(qreal atabStop)
    { setTabStopDistance(atabStop); }
    /+ QT_DEPRECATED +/ pragma(inline, true) qreal tabStop() const { return tabStopDistance(); }
/+ #endif +/

    pragma(inline, true) void setTabStopDistance(qreal atabStop)
    { tab = atabStop; }
    pragma(inline, true) qreal tabStopDistance() const { return tab; }

    void setTabArray(ref const(QList!(qreal)) tabStops);
    QList!(qreal) tabArray() const;

    void setTabs(ref const(QList!(Tab)) tabStops);
    QList!(Tab) tabs() const;

    void setUseDesignMetrics(bool b) { design = b; }
    bool useDesignMetrics() const { return (design) != 0; }

private:
    /+ uint align : 8; +/
    uint bitfieldData_align = (WrapMode.WordWrap << 8) | (AlignmentFlag.AlignLeft);
    final uint align_() const
    {
        return (bitfieldData_align >> 0) & 0xff;
    }
    final uint align_(uint value)
    {
        bitfieldData_align = (bitfieldData_align & ~0xff) | ((value & 0xff) << 0);
        return value;
    }
    /+ uint wordWrap : 4; +/
    final uint wordWrap() const
    {
        return (bitfieldData_align >> 8) & 0xf;
    }
    final uint wordWrap(uint value)
    {
        bitfieldData_align = (bitfieldData_align & ~0xf00) | ((value & 0xf) << 8);
        return value;
    }
    /+ uint design : 1; +/
    final uint design() const
    {
        return (bitfieldData_align >> 12) & 0x1;
    }
    final uint design(uint value)
    {
        bitfieldData_align = (bitfieldData_align & ~0x1000) | ((value & 0x1) << 12);
        return value;
    }
    /+ uint direction : 2; +/
    final uint direction() const
    {
        return (bitfieldData_align >> 13) & 0x3;
    }
    final uint direction(uint value)
    {
        bitfieldData_align = (bitfieldData_align & ~0x6000) | ((value & 0x3) << 13);
        return value;
    }
    /+ uint unused : 17; +/
    final uint unused() const
    {
        return (bitfieldData_align >> 15) & 0x1ffff;
    }
    final uint unused(uint value)
    {
        bitfieldData_align = (bitfieldData_align & ~0xffff8000) | ((value & 0x1ffff) << 15);
        return value;
    }
    uint unused2; // ### Qt 6: remove unnecessary, extra 32 bits
    uint f;
    qreal tab = -1;
    QTextOptionPrivate* d;
}
/+pragma(inline, true) QFlags!(QTextOption.Flags.enum_type) operator |(QTextOption.Flags.enum_type f1, QTextOption.Flags.enum_type f2)/+noexcept+/{return QFlags!(QTextOption.Flags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QTextOption.Flags.enum_type) operator |(QTextOption.Flags.enum_type f1, QFlags!(QTextOption.Flags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QTextOption.Flags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QTextOption::Flags)
#if QT_DEPRECATED_SINCE(5, 10)
#endif


Q_DECLARE_METATYPE( QTextOption::Tab ) +/

