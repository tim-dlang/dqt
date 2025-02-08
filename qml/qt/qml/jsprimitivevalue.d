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
module qt.qml.jsprimitivevalue;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.metatype;
import qt.core.string;
import qt.core.variant;
import qt.helpers;

struct QJSPrimitiveUndefined {}
struct QJSPrimitiveNull {}

/// Binding for C++ class [QJSPrimitiveValue](https://doc.qt.io/qt-6/qjsprimitivevalue.html).
extern(C++, class) struct QJSPrimitiveValue
{
private:
    /+ template<typename Concrete> +/
    struct StringNaNOperators(Concrete)
    {
        static double op(ref const(QString) , QJSPrimitiveUndefined)
        {
            return /+ std:: +/numeric_limits!(double).quiet_NaN();
        }

        static double op(QJSPrimitiveUndefined, ref const(QString) )
        {
            return /+ std:: +/numeric_limits!(double).quiet_NaN();
        }

        static double op(ref const(QString) lhs, QJSPrimitiveNull) { return op(lhs, 0); }
        static double op(QJSPrimitiveNull, ref const(QString) rhs) { return op(0, rhs); }

        /+ template<typename T> +/
        static double op(T)(ref const(QString) lhs, T rhs)
        {
            return Concrete.op(fromString(lhs).toDouble(), rhs);
        }

        /+ template<typename T> +/
        static double op(T)(T lhs, ref const(QString) rhs)
        {
            return Concrete.op(lhs, fromString(rhs).toDouble());
        }

        static double op(ref const(QString) lhs, ref const(QString) rhs)
        {
            return Concrete.op(fromString(lhs).toDouble(), fromString(rhs).toDouble());
        }
    }

/+    struct AddOperators {
        static double op(double lhs, double rhs) { return lhs + rhs; }
        static bool opOverflow(int lhs, int rhs, int* result)
        {
            return cast(bool) (qAddOverflow(lhs, rhs, cast(T*) (result)));
        }

        /+ template<typename T> +/
        static QString op(T)(ref const(QString) lhs, T rhs)
        {
            return lhs + QJSPrimitiveValue(rhs).toString();
        }

        /+ template<typename T> +/
        static QString op(T)(T lhs, ref const(QString) rhs)
        {
            return QJSPrimitiveValue(lhs).toString() + rhs;
        }

        static QString op(ref const(QString) lhs, ref const(QString) rhs) { return lhs + rhs; }
    }

    struct SubOperators {
        private StringNaNOperators!(UnresolvedMergeConflict!(q{UnknownType!q{SubOperators}},q{SubOperators})) base0;
        alias base0 this;
        static double op(double lhs, double rhs) { return lhs - rhs; }
        static bool opOverflow(int lhs, int rhs, int* result)
        {
            return cast(bool) (qSubOverflow(lhs, rhs, cast(T*) (result)));
        }

        /+ using StringNaNOperators::op; +/
    }

    struct MulOperators {
        private StringNaNOperators!(UnresolvedMergeConflict!(q{UnknownType!q{MulOperators}},q{MulOperators})) base0;
        alias base0 this;
        static double op(double lhs, double rhs) { return lhs * rhs; }
        static bool opOverflow(int lhs, int rhs, int* result)
        {
            return cast(bool) (qMulOverflow(lhs, rhs, cast(T*) (result)));
        }

        /+ using StringNaNOperators::op; +/
    }

    struct DivOperators {
        private StringNaNOperators!(UnresolvedMergeConflict!(q{UnknownType!q{DivOperators}},q{DivOperators})) base0;
        alias base0 this;
        static double op(double lhs, double rhs)  { return lhs / rhs; }
        static bool opOverflow(int, int, int* )
        {
            return true;
        }

        /+ using StringNaNOperators::op; +/
    }+/

public:
    enum Type : quint8 {
        Undefined,
        Null,
        Boolean,
        Integer,
        Double,
        String
    }

    Type type() const { return Type(d.type()); }

    /+ Q_IMPLICIT +/ /+ constexpr QJSPrimitiveValue() noexcept = default; +/
    /+ Q_IMPLICIT +/ this(QJSPrimitiveUndefined undefined)/+ noexcept+/
    {
        this.d = undefined;
    }
    /+ Q_IMPLICIT +/ this(QJSPrimitiveNull null_)/+ noexcept+/
    {
        this.d = null_;
    }
    /+ Q_IMPLICIT +/ this(bool value)/+ noexcept+/
    {
        this.d = value;
    }
    /+ Q_IMPLICIT +/ this(int value)/+ noexcept+/
    {
        this.d = value;
    }
    /+ Q_IMPLICIT +/ this(double value)/+ noexcept+/
    {
        this.d = value;
    }
/+    /+ Q_IMPLICIT +/ this(QString string)/+ noexcept+/
    {
        this.d = /+ std:: +/move(cast(_Tp && ) (string));
    }+/

/+    /+ explicit +/this(const(QMetaType) type, const(void)* value)/+ noexcept+/
    {
        switch (type.id()) {
        case QMetaType.Type.UnknownType:
            d = QJSPrimitiveUndefined();
            break;
        case QMetaType.Type.Nullptr:
            d = QJSPrimitiveNull();
            break;
        case QMetaType.Type.Bool:
            d = *static_cast!(const(bool)*)(value);
            break;
        case QMetaType.Type.Int:
            d = *static_cast!(const(int)*)(value);
            break;
        case QMetaType.Type.Double:
            d = *static_cast!(const(double)*)(value);
            break;
        case QMetaType.Type.QString:
            d = *static_cast!(const(QString)*)(value);
            break;
        default:
            // Unsupported. Remains undefined.
            break;
        }
    }

    /+ explicit +/this(ref const(QVariant) variant)/+ noexcept+/
    {
        this(variant.metaType(), variant.data());
    }

    bool toBoolean() const
    {
        import qt.core.compilerdetection;
        import qt.qml.jsnumbercoercion;

        switch (type()) {
        case Type.Undefined: return false;
        case Type.Null:      return false;
        case Type.Boolean:   return asBoolean();
        case Type.Integer:   return asInteger() != 0;
        case Type.Double: {
            const(double) v = asDouble();
            return !QJSNumberCoercion.equals(v, 0) && !/+ std:: +/isnan(v);
        }
        case Type.String:    return !asString().isEmpty();
        default:        mixin(Q_UNREACHABLE());
        }

        return false;
    }

    int toInteger() const
    {
        import qt.core.compilerdetection;
        import qt.qml.jsnumbercoercion;

        switch (type()) {
        case Type.Undefined: return 0;
        case Type.Null:      return 0;
        case Type.Boolean:   return asBoolean();
        case Type.Integer:   return asInteger();
        case Type.Double:    return QJSNumberCoercion.toInteger(asDouble());
        case Type.String:    return fromString(asString()).toInteger();
        default:        mixin(Q_UNREACHABLE());
        }

        return 0;
    }

    double toDouble() const
    {
        import qt.core.compilerdetection;

        switch (type()) {
        case Type.Undefined: return /+ std:: +/numeric_limits!(double).quiet_NaN();
        case Type.Null:      return 0;
        case Type.Boolean:   return asBoolean();
        case Type.Integer:   return asInteger();
        case Type.Double:    return asDouble();
        case Type.String:    return fromString(asString()).toDouble();
        default:        mixin(Q_UNREACHABLE());
        }

        return {};
    }

    QString toString() const
    {
        import qt.core.compilerdetection;
        import qt.core.stringliteral;

        switch (type()) {
        case Type.Undefined: return mixin(QStringLiteral(q{"undefined"}));
        case Type.Null:      return mixin(QStringLiteral(q{"null"}));
        case Type.Boolean:   return asBoolean() ? mixin(QStringLiteral(q{"true"})) : mixin(QStringLiteral(q{"false"}));
        case Type.Integer:   return QString.number(asInteger());
        case Type.Double: {
            const(double) result = asDouble();
            if (/+ std:: +/isnan(result))
                return mixin(QStringLiteral(q{"NaN"}));
            if (/+ std:: +/isfinite(result))
                return toString(result);
            if (result > 0)
                return mixin(QStringLiteral(q{"Infinity"}));
            return mixin(QStringLiteral(q{"-Infinity"}));
        }
        case Type.String: return asString();default:

        }

        mixin(Q_UNREACHABLE());
        return QString();
    }

    QVariant toVariant() const
    {
        import qt.core.compilerdetection;

        switch (type()) {
        case Type.Undefined: return QVariant();
        case Type.Null:      return cast(QVariant) (QVariant.fromValue!(/+ std:: +/nullptr_t)(null));
        case Type.Boolean:   return QVariant(asBoolean());
        case Type.Integer:   return QVariant(asInteger());
        case Type.Double:    return QVariant(asDouble());
        case Type.String:    auto tmp = asString(); return QVariant(tmp);default:

        }

        mixin(Q_UNREACHABLE());
        return QVariant();
    }+/

    /+ friend inline QJSPrimitiveValue operator+(const QJSPrimitiveValue &lhs,
                                              const QJSPrimitiveValue &rhs)
    {
        return operate<AddOperators>(lhs, rhs);
    } +/

    /+ friend inline QJSPrimitiveValue operator-(const QJSPrimitiveValue &lhs,
                                              const QJSPrimitiveValue &rhs)
    {
        return operate<SubOperators>(lhs, rhs);
    } +/

    /+ friend inline QJSPrimitiveValue operator*(const QJSPrimitiveValue &lhs,
                                              const QJSPrimitiveValue &rhs)
    {
        return operate<MulOperators>(lhs, rhs);
    } +/

    /+ friend inline QJSPrimitiveValue operator/(const QJSPrimitiveValue &lhs,
                                              const QJSPrimitiveValue &rhs)
    {
        return operate<DivOperators>(lhs, rhs);
    } +/

    /+ friend inline QJSPrimitiveValue operator%(const QJSPrimitiveValue &lhs,
                                              const QJSPrimitiveValue &rhs)
    {
        switch (lhs.type()) {
        case Null:
        case Boolean:
        case Integer:
            switch (rhs.type()) {
            case Boolean:
            case Integer: {
                const int leftInt = lhs.toInteger();
                const int rightInt = rhs.toInteger();
                if (leftInt >= 0 && rightInt > 0)
                    return leftInt % rightInt;
                Q_FALLTHROUGH();
            }
            default:
                break;
            }
            Q_FALLTHROUGH();
        default:
            break;
        }

        return std::fmod(lhs.toDouble(), rhs.toDouble());
    } +/

    ref QJSPrimitiveValue opUnary(string op)() if (op == "++")
    {
        // ++a is modeled as a -= (-1) to avoid the potential string concatenation
        auto tmp = QJSPrimitiveValue(-1);
        return this = operate!(SubOperators)(this, tmp);
    }

    /+QJSPrimitiveValue operator ++(int)
    {
        // a++ is modeled as a -= (-1) to avoid the potential string concatenation
        QJSPrimitiveValue other = operate!(SubOperators)(this, cast(ref const(QJSPrimitiveValue)) (-1));
        /+ std:: +/swap(other, this);
        return +other; // We still need to coerce the original value.
    }+/

    ref QJSPrimitiveValue opUnary(string op)() if (op == "--")
    {
        auto tmp = QJSPrimitiveValue(-1);
        return operate!(SubOperators)(this, tmp);
    }

    /+QJSPrimitiveValue operator --(int)
    {
        QJSPrimitiveValue other = operate!(SubOperators)(this, cast(ref const(QJSPrimitiveValue)) (1));
        /+ std:: +/swap(other, this);
        return +other; // We still need to coerce the original value.
    }+/

    /+QJSPrimitiveValue operator +()
    {
        // +a is modeled as a -= 0. That should force it to number.
        return ((){return this = operate!(SubOperators)(this, cast(ref const(QJSPrimitiveValue)) (0));
}());
    }+/

    /+QJSPrimitiveValue operator -()
    {
        return ((){return this = operate!(MulOperators)(this, cast(ref const(QJSPrimitiveValue)) (-1));
}());
    }+/

/+    bool strictlyEquals(ref const(QJSPrimitiveValue) other) const
    {
        import qt.qml.jsnumbercoercion;

        const(Type) myType = type();
        const(Type) otherType = other.type();

        if (myType != otherType) {
            // int -> double promotion is OK in strict mode
            if (myType == Type.Double && otherType == Type.Integer)
                { auto tmp = QJSPrimitiveValue(double(other.asInteger())); return strictlyEquals(tmp);}
            if (myType == Type.Integer && otherType == Type.Double)
                return QJSPrimitiveValue(double(asInteger())).strictlyEquals(other);
            return false;
        }

        switch (myType) {
        case Type.Undefined:
        case Type.Null:
            return true;
        case Type.Boolean:
            return asBoolean() == other.asBoolean();
        case Type.Integer:
            return asInteger() == other.asInteger();
        case Type.Double: {
            const(double) l = asDouble();
            const(double) r = other.asDouble();
            if (/+ std:: +/isnan(l) || /+ std:: +/isnan(r))
                return false;
            if (qIsNull(l) && qIsNull(r))
                return true;
            return QJSNumberCoercion.equals(l, r);
        }
        case Type.String:
            return asString() == other.asString();default:

        }

        return false;
    }+/

    // Loose operator==, in contrast to strict ===
/+    bool equals(ref const(QJSPrimitiveValue) other) const
    {
        const(Type) myType = type();
        const(Type) otherType = other.type();

        if (myType == otherType)
            return strictlyEquals(other);

        switch (myType) {
        case Type.Undefined:
            return otherType == Type.Null;
        case Type.Null:
            return otherType == Type.Undefined;
        case Type.Boolean:
            return QJSPrimitiveValue(int(asBoolean())).equals(other);
        case Type.Integer:
            // prefer rhs bool -> int promotion over promoting both to double
            return otherType == Type.Boolean
                    ? QJSPrimitiveValue(asInteger()).equals(QJSPrimitiveValue(int(other.asBoolean())))
                    : QJSPrimitiveValue(double(asInteger())).equals(other);
        case Type.Double:
            // Promote the other side to double (or recognize lhs as undefined/null)
            return other.equals(this);
        case Type.String:
            return fromString(asString()).parsedEquals(other);default:

        }

        return false;
    }+/

    /+ friend constexpr inline bool operator==(const QJSPrimitiveValue &lhs, const
                                            QJSPrimitiveValue &rhs)
    {
        return lhs.strictlyEquals(rhs);
    } +/

    /+ friend constexpr inline bool operator!=(const QJSPrimitiveValue &lhs,
                                            const QJSPrimitiveValue &rhs)
    {
        return !lhs.strictlyEquals(rhs);
    } +/

    /+ friend constexpr inline bool operator<(const QJSPrimitiveValue &lhs,
                                           const QJSPrimitiveValue &rhs)
    {
        switch (lhs.type()) {
        case Undefined:
            return false;
        case Null: {
            switch (rhs.type()) {
            case Undefined: return false;
            case Null:      return false;
            case Boolean:   return 0 < int(rhs.asBoolean());
            case Integer:   return 0 < rhs.asInteger();
            case Double:    return double(0) < rhs.asDouble();
            case String:    return double(0) < rhs.toDouble();
            }
            break;
        }
        case Boolean: {
            switch (rhs.type()) {
            case Undefined: return false;
            case Null:      return int(lhs.asBoolean()) < 0;
            case Boolean:   return lhs.asBoolean() < rhs.asBoolean();
            case Integer:   return int(lhs.asBoolean()) < rhs.asInteger();
            case Double:    return double(lhs.asBoolean()) < rhs.asDouble();
            case String:    return double(lhs.asBoolean()) < rhs.toDouble();
            }
            break;
        }
        case Integer: {
            switch (rhs.type()) {
            case Undefined: return false;
            case Null:      return lhs.asInteger() < 0;
            case Boolean:   return lhs.asInteger() < int(rhs.asBoolean());
            case Integer:   return lhs.asInteger() < rhs.asInteger();
            case Double:    return double(lhs.asInteger()) < rhs.asDouble();
            case String:    return double(lhs.asInteger()) < rhs.toDouble();
            }
            break;
        }
        case Double: {
            switch (rhs.type()) {
            case Undefined: return false;
            case Null:      return lhs.asDouble() < double(0);
            case Boolean:   return lhs.asDouble() < double(rhs.asBoolean());
            case Integer:   return lhs.asDouble() < double(rhs.asInteger());
            case Double:    return lhs.asDouble() < rhs.asDouble();
            case String:    return lhs.asDouble() < rhs.toDouble();
            }
            break;
        }
        case String: {
            switch (rhs.type()) {
            case Undefined: return false;
            case Null:      return lhs.toDouble() < double(0);
            case Boolean:   return lhs.toDouble() < double(rhs.asBoolean());
            case Integer:   return lhs.toDouble() < double(rhs.asInteger());
            case Double:    return lhs.toDouble() < rhs.asDouble();
            case String:    return lhs.asString() < rhs.asString();
            }
            break;
        }
        }

        return false;
    } +/

    /+ friend constexpr inline bool operator>(const QJSPrimitiveValue &lhs, const QJSPrimitiveValue &rhs)
    {
        return rhs < lhs;
    } +/

    /+ friend constexpr inline bool operator<=(const QJSPrimitiveValue &lhs, const QJSPrimitiveValue &rhs)
    {
        if (lhs.type() == String) {
           if (rhs.type() == String)
               return lhs.asString() <= rhs.asString();
           else
               return fromString(lhs.asString()) <= rhs;
        }
        if (rhs.type() == String)
            return lhs <= fromString(rhs.asString());

        if (lhs.isNanOrUndefined() || rhs.isNanOrUndefined())
            return false;
        return !(lhs > rhs);
    } +/

    /+ friend constexpr inline bool operator>=(const QJSPrimitiveValue &lhs, const QJSPrimitiveValue &rhs)
    {
        if (lhs.type() == String) {
           if (rhs.type() == String)
               return lhs.asString() >= rhs.asString();
           else
               return fromString(lhs.asString()) >= rhs;
        }
        if (rhs.type() == String)
            return lhs >= fromString(rhs.asString());

        if (lhs.isNanOrUndefined() || rhs.isNanOrUndefined())
            return false;
        return !(lhs < rhs);
    } +/

private:
    /+ friend class QJSManagedValue; +/
    /+ friend class QJSValue; +/

    bool asBoolean() const { return d.getBool(); }
    int asInteger() const { return d.getInt(); }
    double asDouble() const { return d.getDouble(); }
    const(QString) asString() const { return d.getString(); }

/+    bool parsedEquals(ref const(QJSPrimitiveValue) other) const
    {
        return type() != Type.Undefined && equals(other);
    }+/

/+    static QJSPrimitiveValue fromString(ref const(QString) string)
    {
        import qt.core.stringliteral;

        bool ok;
        const(int) intValue = string.toInt(&ok);
        if (ok)
            return cast(QJSPrimitiveValue) (intValue);

        const(double) doubleValue = string.toDouble(&ok);
        if (ok)
            return cast(QJSPrimitiveValue) (doubleValue);
        if (string == mixin(QStringLiteral(q{"Infinity"})))
            return /+ std:: +/numeric_limits!(double).infinity();
        if (string == mixin(QStringLiteral(q{"-Infinity"})))
            return -/+ std:: +/numeric_limits!(double).infinity();
        if (string == mixin(QStringLiteral(q{"NaN"})))
            return /+ std:: +/numeric_limits!(double).quiet_NaN();
        return QJSPrimitiveUndefined();
    }+/

    /+ Q_QML_EXPORT +/ static QString toString(double d);

    /+ template<typename Operators, typename Lhs, typename Rhs> +/
/+    static QJSPrimitiveValue operateOnIntegers(Operators,Lhs,Rhs)(ref const(QJSPrimitiveValue) lhs,
                                                   ref const(QJSPrimitiveValue) rhs)
    {
        int result;
        if (Operators.opOverflow(lhs.d.get<LhsLhs>(), rhs.d.get<RhsRhs>(), &result))
            return Operators.op(lhs.d.get<LhsLhs>(), rhs.d.get<RhsRhs>());
        return cast(QJSPrimitiveValue) (result);
    }+/

    /+ template<typename Operators> +/
/+    static QJSPrimitiveValue operate(Operators)(ref const(QJSPrimitiveValue) lhs, ref const(QJSPrimitiveValue) rhs)
    {
        import qt.core.compilerdetection;

        switch (lhs.type()) {
        case Type.Undefined:
            switch (rhs.type()) {
            case Type.Undefined: return /+ std:: +/numeric_limits!(double).quiet_NaN();
            case Type.Null:      return /+ std:: +/numeric_limits!(double).quiet_NaN();
            case Type.Boolean:   return /+ std:: +/numeric_limits!(double).quiet_NaN();
            case Type.Integer:   return /+ std:: +/numeric_limits!(double).quiet_NaN();
            case Type.Double:    return /+ std:: +/numeric_limits!(double).quiet_NaN();
            case Type.String:    return Operators.op(QJSPrimitiveUndefined(), rhs.asString());default:

            }
            break;
        case Type.Null:
            switch (rhs.type()) {
            case Type.Undefined: return /+ std:: +/numeric_limits!(double).quiet_NaN();
            case Type.Null:      return operateOnIntegers!(Operators, int, int)(QJSPrimitiveValue(0), QJSPrimitiveValue(0));
            case Type.Boolean:   return operateOnIntegers!(Operators, int, bool)(QJSPrimitiveValue(0), rhs);
            case Type.Integer:   return operateOnIntegers!(Operators, int, int)(QJSPrimitiveValue(0), rhs);
            case Type.Double:    return Operators.op(0, rhs.asDouble());
            case Type.String:    return Operators.op(QJSPrimitiveNull(), rhs.asString());default:

            }
            break;
        case Type.Boolean:
            switch (rhs.type()) {
            case Type.Undefined: return /+ std:: +/numeric_limits!(double).quiet_NaN();
            case Type.Null:      return operateOnIntegers!(Operators, bool, int)(lhs, QJSPrimitiveValue(0));
            case Type.Boolean:   return operateOnIntegers!(Operators, bool, bool)(lhs, rhs);
            case Type.Integer:   return operateOnIntegers!(Operators, bool, int)(lhs, rhs);
            case Type.Double:    return Operators.op(lhs.asBoolean(), rhs.asDouble());
            case Type.String:    return Operators.op(lhs.asBoolean(), rhs.asString());default:

            }
            break;
        case Type.Integer:
            switch (rhs.type()) {
            case Type.Undefined: return /+ std:: +/numeric_limits!(double).quiet_NaN();
            case Type.Null:      return operateOnIntegers!(Operators, int, int)(lhs, QJSPrimitiveValue(0));
            case Type.Boolean:   return operateOnIntegers!(Operators, int, bool)(lhs, rhs);
            case Type.Integer:   return operateOnIntegers!(Operators, int, int)(lhs, rhs);
            case Type.Double:    return Operators.op(lhs.asInteger(), rhs.asDouble());
            case Type.String:    return Operators.op(lhs.asInteger(), rhs.asString());default:

            }
            break;
        case Type.Double:
            switch (rhs.type()) {
            case Type.Undefined: return /+ std:: +/numeric_limits!(double).quiet_NaN();
            case Type.Null:      return Operators.op(lhs.asDouble(), 0);
            case Type.Boolean:   return Operators.op(lhs.asDouble(), rhs.asBoolean());
            case Type.Integer:   return Operators.op(lhs.asDouble(), rhs.asInteger());
            case Type.Double:    return Operators.op(lhs.asDouble(), rhs.asDouble());
            case Type.String:    return Operators.op(lhs.asDouble(), rhs.asString());default:

            }
            break;
        case Type.String:
            switch (rhs.type()) {
            case Type.Undefined: return Operators.op(lhs.asString(), QJSPrimitiveUndefined());
            case Type.Null:      return Operators.op(lhs.asString(), QJSPrimitiveNull());
            case Type.Boolean:   return Operators.op(lhs.asString(), rhs.asBoolean());
            case Type.Integer:   return Operators.op(lhs.asString(), rhs.asInteger());
            case Type.Double:    return Operators.op(lhs.asString(), rhs.asDouble());
            case Type.String:    return Operators.op(lhs.asString(), rhs.asString());default:

            }
            break;default:

        }

        mixin(Q_UNREACHABLE());
        return QJSPrimitiveUndefined();
    }+/

/+    bool isNanOrUndefined() const
    {
        switch (type()) {
        case Type.Undefined: return true;
        case Type.Double:    return /+ std:: +/isnan(asDouble());
        default:        return false;
        }
    }+/

    struct QJSPrimitiveValuePrivate
    {
        // Can't be default because QString has a non-trivial ctor.
        @disable this();
        /+this()/+ noexcept+/ {}+/

        /+ Q_IMPLICIT +/ this(QJSPrimitiveUndefined)/+ noexcept+/  {}
        /+ Q_IMPLICIT +/ this(QJSPrimitiveNull)/+ noexcept+/
        {
            this.m_type = Type.Null;
        }
        /+ Q_IMPLICIT +/ this(bool b)/+ noexcept+/
        {
            this.m_bool = b;
            this.m_type = Type.Boolean;
        }
        /+ Q_IMPLICIT +/ this(int i)/+ noexcept+/
        {
            this.m_int = i;
            this.m_type = Type.Integer;
        }
        /+ Q_IMPLICIT +/ this(double d)/+ noexcept+/
        {
            this.m_double = d;
            this.m_type = Type.Double;
        }
        /+ /+ Q_IMPLICIT +/ this(QString s)/+ noexcept+/
        {
            this.m_string = /+ std:: +/move(cast(_Tp && ) (s));
            this.m_type = Type.String;
        }+/

        @disable this(this);
/+        this(ref const(QJSPrimitiveValuePrivate) other)/+ noexcept+/
        {
            import core.lifetime;
            this.m_type = other.m_type;

            // Not copy-and-swap since swap() would be much more complicated.
            if (!assignSimple(other))
                emplace!QString(&m_string, other.m_string);
        }+/

        /+ constexpr QJSPrimitiveValuePrivate(QJSPrimitiveValuePrivate &&other) noexcept
            : m_type(other.m_type)
        {
            // Not move-and-swap since swap() would be much more complicated.
            if (!assignSimple(other))
                new (&m_string) QString(std::move(other.m_string));
        } +/

        /+ref QJSPrimitiveValuePrivate operator =(ref const(QJSPrimitiveValuePrivate) other)/+ noexcept+/
        {
            import core.lifetime;

            if (&this == &other)
                return this;

            if (m_type == Type.String) {
                if (other.m_type == Type.String) {
                    m_type = other.m_type;
                    m_string = other.m_string;
                    return this;
                }
                destroy!false(m_string);
            }

            m_type = other.m_type;
            if (!assignSimple(other))
                emplace!QString(&m_string, other.m_string);
            return this;
        }+/

        /+ constexpr QJSPrimitiveValuePrivate &operator=(QJSPrimitiveValuePrivate &&other) noexcept
        {
            if (this == &other)
                return *this;

            if (m_type == String) {
                if (other.m_type == String) {
                    m_type = other.m_type;
                    m_string = std::move(other.m_string);
                    return *this;
                }
                m_string.~QString();
            }

            m_type = other.m_type;
            if (!assignSimple(other))
                new (&m_string) QString(std::move(other.m_string));
            return *this;
        } +/

        ~this()
        {
            if (m_type == Type.String)
                destroy!false(m_string);
        }

        Type type() const/+ noexcept+/ { return m_type; }
        bool getBool() const/+ noexcept+/ { return m_bool; }
        int getInt() const/+ noexcept+/ { return m_int; }
        double getDouble() const/+ noexcept+/ { return m_double; }
        const(QString) getString() const/+ noexcept+/ { return m_string; }

        /+ template<typename T> +/
        T get(T)() const/+ noexcept+/ {
            import qt.core.compilerdetection;

            static if (/+ std:: +/is_same_v!(T, QJSPrimitiveUndefined))
                return QJSPrimitiveUndefined();
            else static if (/+ std:: +/is_same_v!(T, QJSPrimitiveNull))
                return QJSPrimitiveNull();
            else static if (/+ std:: +/is_same_v!(T, bool))
                return getBool();
            else static if (/+ std:: +/is_same_v!(T, int))
                return getInt();
            else static if (/+ std:: +/is_same_v!(T, double))
                return getDouble();
            else static if (/+ std:: +/is_same_v!(T, QString))
                return getString();

            mixin(Q_UNREACHABLE());
            return T();
        }

    private:
        /+bool assignSimple(ref const(QJSPrimitiveValuePrivate) other)/+ noexcept+/
        {
            import qt.core.compilerdetection;

            switch (other.m_type) {
            case Type.Undefined:
            case Type.Null:
                return true;
            case Type.Boolean:
                m_bool = other.m_bool;
                return true;
            case Type.Integer:
                m_int = other.m_int;
                return true;
            case Type.Double:
                m_double = other.m_double;
                return true;
            case Type.String:
                return false;
            default:
                mixin(Q_UNREACHABLE());
            }
            return false;
        }+/

        union {
            bool m_bool = false;
            int m_int;
            double m_double;
            QString m_string;
        }

        Type m_type = Type.Undefined;
    }

    QJSPrimitiveValuePrivate d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, "QQmlPrivate") {
    // TODO: Make this constexpr once std::isnan is constexpr.
    /+ pragma(inline, true) double jsExponentiate(double base, double exponent)
    {
        import qt.qml.jsnumbercoercion;

        immutable double qNaN = /+ std:: +/numeric_limits!(double).quiet_NaN();
        immutable double inf = /+ std:: +/numeric_limits!(double).infinity();

        if (qIsNull(exponent))
            return 1.0;

        if (/+ std:: +//+ isnan(exponent) +/__builtin_isnan(exponent))
            return qNaN;

        if (QJSNumberCoercion.equals(base, 1.0) || QJSNumberCoercion.equals(base, -1.0))
            return /+ std:: +//+ isinf(exponent) +/__builtin_isinf_sign(exponent) ? qNaN : /+ std:: +/pow(base, exponent);

        if (!qIsNull(base))
            return /+ std:: +/pow(base, exponent);

        if ( mixin(((versionIsSet!("Windows") && configValue!"_MSVCR_VER" < 140 && defined!"_MSVCR_VER" && !defined!"_UCRT" && !versionIsSet!("Cygwin"))) ? q{
                /+ std:: +//+ copysign(1.0, base) +/_copysign(1.0,base)
            } : q{
        copysign(1.0,base)
            }) > 0.0)
            return exponent < 0.0 ? inf : /+ std:: +/pow(base, exponent);

        if (exponent < 0.0)
            return QJSNumberCoercion.equals(/+ std:: +/fmod(-exponent, 2.0), 1.0) ? -inf : inf;

        return QJSNumberCoercion.equals(/+ std:: +/fmod(exponent, 2.0), 1.0)
                ? mixin(((versionIsSet!("Windows") && configValue!"_MSVCR_VER" < 140 && defined!"_MSVCR_VER" && !defined!"_UCRT" && !versionIsSet!("Cygwin"))) ? q{
                        /+ std:: +//+ copysign(0, -1.0) +/
        _copysign(0,-1.0)
                    } : q{
        copysign(0,-1.0)
                    })                : 0.0;
    } +/
}

