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
module qt.widgets.sizepolicy;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.global;
import qt.core.metamacros;
import qt.core.namespace;
import qt.core.typeinfo;
import qt.core.variant;
import qt.helpers;


/+ Q_DECL_CONST_FUNCTION inline size_t qHash(QSizePolicy key, size_t seed = 0) noexcept; +/

/// Binding for C++ class [QSizePolicy](https://doc.qt.io/qt-6/qsizepolicy.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct /+ Q_WIDGETS_EXPORT +/ QSizePolicy
{
    mixin(Q_GADGET);

public:
    enum PolicyFlag {
        GrowFlag = 1,
        ExpandFlag = 2,
        ShrinkFlag = 4,
        IgnoreFlag = 8
    }

    enum Policy {
        Fixed = 0,
        Minimum = PolicyFlag.GrowFlag,
        Maximum = PolicyFlag.ShrinkFlag,
        Preferred = PolicyFlag.GrowFlag | PolicyFlag.ShrinkFlag,
        MinimumExpanding = PolicyFlag.GrowFlag | PolicyFlag.ExpandFlag,
        Expanding = PolicyFlag.GrowFlag | PolicyFlag.ShrinkFlag | PolicyFlag.ExpandFlag,
        Ignored = PolicyFlag.ShrinkFlag | PolicyFlag.GrowFlag | PolicyFlag.IgnoreFlag
    }
    /+ Q_ENUM(Policy) +/

    enum ControlType {
        DefaultType      = 0x00000001,
        ButtonBox        = 0x00000002,
        CheckBox         = 0x00000004,
        ComboBox         = 0x00000008,
        Frame            = 0x00000010,
        GroupBox         = 0x00000020,
        Label            = 0x00000040,
        Line             = 0x00000080,
        LineEdit         = 0x00000100,
        PushButton       = 0x00000200,
        RadioButton      = 0x00000400,
        Slider           = 0x00000800,
        SpinBox          = 0x00001000,
        TabWidget        = 0x00002000,
        ToolButton       = 0x00004000
    }
    /+ Q_DECLARE_FLAGS(ControlTypes, ControlType) +/
alias ControlTypes = QFlags!(ControlType);    /+ Q_FLAG(ControlTypes) +/

    @disable this();
    /+this()/+ noexcept+/
    {
        this.data = 0;
    }+/

    this(Policy horizontal, Policy vertical, ControlType type = ControlType.DefaultType)/+ noexcept+/
    {
        this.bits.bitfieldData_horStretch = 0;
        this.bits.horPolicy = horizontal;
        this.bits.verPolicy = vertical;
        this.bits.ctype = type == ControlType.DefaultType ? 0 : toControlTypeFieldValue(type);
    }
    Policy horizontalPolicy() const/+ noexcept+/ { return static_cast!(Policy)(bits.horPolicy); }
    Policy verticalPolicy() const/+ noexcept+/ { return static_cast!(Policy)(bits.verPolicy); }
    ControlType controlType() const/+ noexcept+/;

    void setHorizontalPolicy(Policy d)/+ noexcept+/ { bits.horPolicy = d; }
    void setVerticalPolicy(Policy d)/+ noexcept+/ { bits.verPolicy = d; }
    void setControlType(ControlType type)/+ noexcept+/;

    // ### Qt 7: consider making Policy a QFlags and removing these casts
    /+ Qt:: +/qt.core.namespace.Orientations expandingDirections() const/+ noexcept+/ {
        return ( (verticalPolicy()   & static_cast!(Policy)(PolicyFlag.ExpandFlag)) ? /+ Qt:: +/qt.core.namespace.Orientations.Vertical   : /+ Qt:: +/qt.core.namespace.Orientations() )
             | ( (horizontalPolicy() & static_cast!(Policy)(PolicyFlag.ExpandFlag)) ? /+ Qt:: +/qt.core.namespace.Orientations.Horizontal : /+ Qt:: +/qt.core.namespace.Orientations() ) ;
    }

    void setHeightForWidth(bool b)/+ noexcept+/ { bits.hfw = b;  }
    bool hasHeightForWidth() const/+ noexcept+/ { return !!bits.hfw; }
    void setWidthForHeight(bool b)/+ noexcept+/ { bits.wfh = b;  }
    bool hasWidthForHeight() const/+ noexcept+/ { return !!bits.wfh; }

    /+bool operator ==(ref const(QSizePolicy) s) const/+ noexcept+/ { return data == s.data; }+/
    /+bool operator !=(ref const(QSizePolicy) s) const/+ noexcept+/ { return data != s.data; }+/

    /+ friend Q_DECL_CONST_FUNCTION size_t qHash(QSizePolicy key, size_t seed) noexcept { return qHash(key.data, seed); } +/

    /+auto opCast(T : QVariant)() const;+/

    int horizontalStretch() const/+ noexcept+/ { return static_cast!(int)(bits.horStretch); }
    int verticalStretch() const/+ noexcept+/ { return static_cast!(int)(bits.verStretch); }
    void setHorizontalStretch(int stretchFactor) { bits.horStretch = static_cast!(quint32)(qBound(0, stretchFactor, 255)); }
    void setVerticalStretch(int stretchFactor) { bits.verStretch = static_cast!(quint32)(qBound(0, stretchFactor, 255)); }

//    bool retainSizeWhenHidden() const/+ noexcept+/ { return bits.retainSizeWhenHidden; }
//    void setRetainSizeWhenHidden(bool retainSize)/+ noexcept+/ { bits.retainSizeWhenHidden = retainSize; }

//    void transpose()/+ noexcept+/ { this = transposed(); }
/+    /+ [[nodiscard]] +/ QSizePolicy transposed() const/+ noexcept+/
    {
        return QSizePolicy(bits.transposed());
    }+/

private:
    version(QT_NO_DATASTREAM){}else
    {
        /+ friend Q_WIDGETS_EXPORT QDataStream &operator<<(QDataStream &, const QSizePolicy &); +/
        /+ friend Q_WIDGETS_EXPORT QDataStream &operator>>(QDataStream &, QSizePolicy &); +/
    }
    this(int i)/+ noexcept+/
    {
        this.data = i;
    }
    /+
    struct Bits;
    +/
    /+/+ explicit +/this(Bits b)/+ noexcept+/
    {
        this.bits = b;
    }+/

    static quint32 toControlTypeFieldValue(ControlType type)/+ noexcept+/
    {
        import qt.core.algorithms;

        /*
          The control type is a flag type, with values 0x1, 0x2, 0x4, 0x8, 0x10,
          etc. In memory, we pack it onto the available bits (CTSize) in
          setControlType(), and unpack it here.

          Example:

          0x00000001 maps to 0
          0x00000002 maps to 1
          0x00000004 maps to 2
          0x00000008 maps to 3
          etc.
        */

        return qCountTrailingZeroBits(static_cast!(quint32)(type));
    }

    struct Bits {
        /+ quint32 horStretch : 8; +/
        uint bitfieldData_horStretch;
        final quint32 horStretch() const
        {
            return (bitfieldData_horStretch >> 0) & 0xff;
        }
        final quint32 horStretch(quint32 value)
        {
            bitfieldData_horStretch = (bitfieldData_horStretch & ~0xff) | ((value & 0xff) << 0);
            return value;
        }
        /+ quint32 verStretch : 8; +/
        final quint32 verStretch() const
        {
            return (bitfieldData_horStretch >> 8) & 0xff;
        }
        final quint32 verStretch(quint32 value)
        {
            bitfieldData_horStretch = (bitfieldData_horStretch & ~0xff00) | ((value & 0xff) << 8);
            return value;
        }
        /+ quint32 horPolicy : 4; +/
        final quint32 horPolicy() const
        {
            return (bitfieldData_horStretch >> 16) & 0xf;
        }
        final quint32 horPolicy(quint32 value)
        {
            bitfieldData_horStretch = (bitfieldData_horStretch & ~0xf0000) | ((value & 0xf) << 16);
            return value;
        }
        /+ quint32 verPolicy : 4; +/
        final quint32 verPolicy() const
        {
            return (bitfieldData_horStretch >> 20) & 0xf;
        }
        final quint32 verPolicy(quint32 value)
        {
            bitfieldData_horStretch = (bitfieldData_horStretch & ~0xf00000) | ((value & 0xf) << 20);
            return value;
        }
        /+ quint32 ctype : 5; +/
        final quint32 ctype() const
        {
            return (bitfieldData_horStretch >> 24) & 0x1f;
        }
        final quint32 ctype(quint32 value)
        {
            bitfieldData_horStretch = (bitfieldData_horStretch & ~0x1f000000) | ((value & 0x1f) << 24);
            return value;
        }
        /+ quint32 hfw : 1; +/
        final quint32 hfw() const
        {
            return (bitfieldData_horStretch >> 29) & 0x1;
        }
        final quint32 hfw(quint32 value)
        {
            bitfieldData_horStretch = (bitfieldData_horStretch & ~0x20000000) | ((value & 0x1) << 29);
            return value;
        }
        /+ quint32 wfh : 1; +/
        final quint32 wfh() const
        {
            return (bitfieldData_horStretch >> 30) & 0x1;
        }
        final quint32 wfh(quint32 value)
        {
            bitfieldData_horStretch = (bitfieldData_horStretch & ~0x40000000) | ((value & 0x1) << 30);
            return value;
        }
        /+ quint32 retainSizeWhenHidden : 1; +/
        final quint32 retainSizeWhenHidden() const
        {
            return (bitfieldData_horStretch >> 31) & 0x1;
        }
        final quint32 retainSizeWhenHidden(quint32 value)
        {
            bitfieldData_horStretch = (bitfieldData_horStretch & ~0x80000000) | ((value & 0x1) << 31);
            return value;
        }

/+        Bits transposed() const/+ noexcept+/
        {
            return Bits(verStretch, // \ swap
                    horStretch, // /
                    verPolicy, // \ swap
                    horPolicy, // /
                    ctype,
                    hfw, // \ don't swap (historic behavior)
                    wfh, // /
                    retainSizeWhenHidden);
        }+/
    }
    union {
        Bits bits;
        quint32 data;
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QSizePolicy.ControlTypes.enum_type) operator |(QSizePolicy.ControlTypes.enum_type f1, QSizePolicy.ControlTypes.enum_type f2)/+noexcept+/{return QFlags!(QSizePolicy.ControlTypes.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QSizePolicy.ControlTypes.enum_type) operator |(QSizePolicy.ControlTypes.enum_type f1, QFlags!(QSizePolicy.ControlTypes.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QSizePolicy.ControlTypes.enum_type) operator &(QSizePolicy.ControlTypes.enum_type f1, QSizePolicy.ControlTypes.enum_type f2)/+noexcept+/{return QFlags!(QSizePolicy.ControlTypes.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QSizePolicy.ControlTypes.enum_type) operator &(QSizePolicy.ControlTypes.enum_type f1, QFlags!(QSizePolicy.ControlTypes.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) void operator +(QSizePolicy.ControlTypes.enum_type f1, QSizePolicy.ControlTypes.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QSizePolicy.ControlTypes.enum_type f1, QFlags!(QSizePolicy.ControlTypes.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QSizePolicy.ControlTypes.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QSizePolicy.ControlTypes.enum_type f1, QSizePolicy.ControlTypes.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QSizePolicy.ControlTypes.enum_type f1, QFlags!(QSizePolicy.ControlTypes.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QSizePolicy.ControlTypes.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) QIncompatibleFlag operator |(QSizePolicy.ControlTypes.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+pragma(inline, true) void operator +(int f1, QSizePolicy.ControlTypes.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QSizePolicy.ControlTypes.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QSizePolicy.ControlTypes.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QSizePolicy.ControlTypes.enum_type f1, int f2)/+noexcept+/;+/

/+ Q_DECLARE_TYPEINFO(QSizePolicy, Q_PRIMITIVE_TYPE);

Q_DECLARE_OPERATORS_FOR_FLAGS(QSizePolicy::ControlTypes)
#ifndef QT_NO_DATASTREAM
Q_WIDGETS_EXPORT QDataStream &operator<<(QDataStream &, const QSizePolicy &);
Q_WIDGETS_EXPORT QDataStream &operator>>(QDataStream &, QSizePolicy &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_WIDGETS_EXPORT QDebug operator<<(QDebug dbg, const QSizePolicy &);
#endif +/

