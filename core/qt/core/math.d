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
module qt.core.math;
extern(C++):

version(Windows) {} else
    version = NotWindowsOrCygwin;
version(Cygwin)
    version = NotWindowsOrCygwin;

import qt.config;
import qt.core.global;
import qt.helpers;

/+ #if 0
#pragma qt_class(QtMath)
#endif

#if __has_include(<bit>) && __cplusplus > 201703L
#endif

#ifndef _USE_MATH_DEFINES
#  define _USE_MATH_DEFINES
#  define undef_USE_MATH_DEFINES
#endif

#ifdef undef_USE_MATH_DEFINES
#  undef _USE_MATH_DEFINES
#  undef undef_USE_MATH_DEFINES
#endif +/


/+ #define QT_SINE_TABLE_SIZE 256 +/
enum QT_SINE_TABLE_SIZE = 256;

/+ Q_CORE_EXPORT +/ extern __gshared const(qreal)[ QT_SINE_TABLE_SIZE] qt_sine_table;

int qCeil(T)(T v)
{
    version(Cygwin){}else
    version(Windows)
        import libc.math;
    version(NotWindowsOrCygwin)
        import libc.mathcalls;

    /+ using std::ceil; +/
    return cast(int) (ceil(v));
}

int qFloor(T)(T v)
{
    version(Cygwin){}else
    version(Windows)
        import libc.math;
    version(NotWindowsOrCygwin)
        import libc.mathcalls;

    /+ using std::floor; +/
    return cast(int) (floor(v));
}

auto qFabs(T)(T v)
{
    version(Cygwin){}else
    version(Windows)
        import libc.math;
    version(NotWindowsOrCygwin)
        import libc.mathcalls;

    /+ using std::fabs; +/
    return fabs(v);
}

auto qSin(T)(T v)
{
    version(Cygwin){}else
    version(Windows)
        import libc.math;
    version(NotWindowsOrCygwin)
        import libc.mathcalls;

    /+ using std::sin; +/
    return sin(v);
}

auto qCos(T)(T v)
{
    version(Cygwin){}else
    version(Windows)
        import libc.math;
    version(NotWindowsOrCygwin)
        import libc.mathcalls;

    /+ using std::cos; +/
    return cos(v);
}

auto qTan(T)(T v)
{
    version(Cygwin){}else
    version(Windows)
        import libc.math;
    version(NotWindowsOrCygwin)
        import libc.mathcalls;

    /+ using std::tan; +/
    return tan(v);
}

auto qAcos(T)(T v)
{
    version(Cygwin){}else
    version(Windows)
        import libc.math;
    version(NotWindowsOrCygwin)
        import libc.mathcalls;

    /+ using std::acos; +/
    return acos(v);
}

auto qAsin(T)(T v)
{
    version(Cygwin){}else
    version(Windows)
        import libc.math;
    version(NotWindowsOrCygwin)
        import libc.mathcalls;

    /+ using std::asin; +/
    return asin(v);
}

auto qAtan(T)(T v)
{
    version(Cygwin){}else
    version(Windows)
        import libc.math;
    version(NotWindowsOrCygwin)
        import libc.mathcalls;

    /+ using std::atan; +/
    return atan(v);
}

auto qAtan2(T1, T2)(T1 y, T2 x)
{
    version(Cygwin){}else
    version(Windows)
        import libc.math;
    version(NotWindowsOrCygwin)
        import libc.mathcalls;

    /+ using std::atan2; +/
    return atan2(y, x);
}

auto qSqrt(T)(T v)
{
    version(Cygwin){}else
    version(Windows)
        import libc.math;
    version(NotWindowsOrCygwin)
        import libc.mathcalls;

    /+ using std::sqrt; +/
    return sqrt(v);
}

/+ namespace QtPrivate {
template <typename R, typename F> // For qfloat16 to specialize
struct QHypotType { using type = decltype(std::hypot(R(1), F(1))); };

// Implements hypot() without limiting number of arguments:
template <typename T>
class QHypotHelper
{
    T scale, total;
    template <typename F> friend class QHypotHelper;
    QHypotHelper(T first, T prior) : scale(first), total(prior) {}
public:
    QHypotHelper(T first) : scale(qAbs(first)), total(1) {}
    T result() const
    { return qIsFinite(scale) ? scale > 0 ? scale * T(std::sqrt(total)) : T(0) : scale; }

    template<typename F, typename ...Fs>
    auto add(F first, Fs... rest) const
    { return add(first).add(rest...); }

    template<typename F, typename R = typename QHypotType<T, F>::type>
    QHypotHelper<R> add(F next) const
    {
        if (qIsInf(scale) || (qIsNaN(scale) && !qIsInf(next)))
            return QHypotHelper<R>(scale, R(1));
        if (qIsNaN(next))
            return QHypotHelper<R>(next, R(1));
        const R val = qAbs(next);
        if (!(scale > 0) || qIsInf(next))
            return QHypotHelper<R>(val, R(1));
        if (!(val > 0))
            return QHypotHelper<R>(scale, total);
        if (val > scale) {
            const R ratio = scale / next;
            return QHypotHelper<R>(val, total * ratio * ratio + 1);
        }
        const R ratio = next / scale;
        return QHypotHelper<R>(scale, total + ratio * ratio);
    }
};
} // QtPrivate

template<typename F, typename ...Fs>
auto qHypot(F first, Fs... rest)
{
    return QtPrivate::QHypotHelper<F>(first).add(rest...).result();
}

// However, where possible, use the standard library implementations:
template <typename Tx, typename Ty>
auto qHypot(Tx x, Ty y)
{
    // C99 has hypot(), hence C++11 has std::hypot()
    using std::hypot;
    return hypot(x, y);
}

#if __cpp_lib_hypot >= 201603L // Expected to be true
template <typename Tx, typename Ty, typename Tz>
auto qHypot(Tx x, Ty y, Tz z)
{
    using std::hypot;
    return hypot(x, y, z);
}
#endif +/ // else: no need to over-ride the arbitrarily-many-arg form

auto qLn(T)(T v)
{
    import core.stdc.math;

    /+ using std::log; +/
    return log(v);
}

auto qExp(T)(T v)
{
    import core.stdc.math;

    /+ using std::exp; +/
    return exp(v);
}

auto qPow(T1, T2)(T1 x, T2 y)
{
    version(Cygwin){}else
    version(Windows)
        import libc.math;
    version(NotWindowsOrCygwin)
        import libc.mathcalls;

    /+ using std::pow; +/
    return pow(x, y);
}

// TODO: use template variables (e.g. Qt::pi<type>) for these once we have C++14 support:

/+ #ifndef M_E
#define M_E (2.7182818284590452354)
#endif

#ifndef M_LOG2E
#define M_LOG2E (1.4426950408889634074)
#endif

#ifndef M_LOG10E
#define M_LOG10E (0.43429448190325182765)
#endif

#ifndef M_LN2
#define M_LN2 (0.69314718055994530942)
#endif

#ifndef M_LN10
#define M_LN10 (2.30258509299404568402)
#endif +/

static if (versionIsSet!("Windows") && !defined!"M_PI" && !defined!"_BSD_SOURCE" && !defined!"_GNU_SOURCE" && !defined!"_POSIX_C_SOURCE" && !defined!"_POSIX_SOURCE" && !defined!"_USE_MATH_DEFINES" && !defined!"_XOPEN_SOURCE" && !versionIsSet!("Cygwin") && defined!"__STRICT_ANSI__")
{
/+ #define M_PI (3.14159265358979323846) +/
enum M_PI = (3.14159265358979323846);
}

/+ #ifndef M_PI_2
#define M_PI_2 (1.57079632679489661923)
#endif

#ifndef M_PI_4
#define M_PI_4 (0.78539816339744830962)
#endif

#ifndef M_1_PI
#define M_1_PI (0.31830988618379067154)
#endif

#ifndef M_2_PI
#define M_2_PI (0.63661977236758134308)
#endif

#ifndef M_2_SQRTPI
#define M_2_SQRTPI (1.12837916709551257390)
#endif

#ifndef M_SQRT2
#define M_SQRT2 (1.41421356237309504880)
#endif

#ifndef M_SQRT1_2
#define M_SQRT1_2 (0.70710678118654752440)
#endif +/

/+pragma(inline, true) qreal qFastSin(qreal x)
{
    int si = cast(int) (x * (0.5 * QT_SINE_TABLE_SIZE / mixin(((versionIsSet!("Windows") && !versionIsSet!("Cygwin") && (defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || !defined!"__STRICT_ANSI__"))) ? q{
            M_PI
        } : ((!versionIsSet!("Windows") || versionIsSet!("Cygwin"))) ? q{
        M_PI
        } : ((versionIsSet!("Windows") && !defined!"M_PI" && !defined!"_BSD_SOURCE" && !defined!"_GNU_SOURCE" && !defined!"_POSIX_C_SOURCE" && !defined!"_POSIX_SOURCE" && !defined!"_USE_MATH_DEFINES" && !defined!"_XOPEN_SOURCE" && !versionIsSet!("Cygwin") && defined!"__STRICT_ANSI__")) ? q{
        M_PI
        } : q{
        M_PI
        }))); // Would be more accurate with qRound, but slower.
    qreal d = x - si * (2.0 * mixin(((versionIsSet!("Windows") && !versionIsSet!("Cygwin") && (defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || !defined!"__STRICT_ANSI__"))) ? q{
            M_PI
        } : ((!versionIsSet!("Windows") || versionIsSet!("Cygwin"))) ? q{
        M_PI
        } : ((versionIsSet!("Windows") && !defined!"M_PI" && !defined!"_BSD_SOURCE" && !defined!"_GNU_SOURCE" && !defined!"_POSIX_C_SOURCE" && !defined!"_POSIX_SOURCE" && !defined!"_USE_MATH_DEFINES" && !defined!"_XOPEN_SOURCE" && !versionIsSet!("Cygwin") && defined!"__STRICT_ANSI__")) ? q{
        M_PI
        } : q{
        M_PI
        }) / QT_SINE_TABLE_SIZE);
    int ci = si + QT_SINE_TABLE_SIZE / 4;
    si &= QT_SINE_TABLE_SIZE - 1;
    ci &= QT_SINE_TABLE_SIZE - 1;
    return qt_sine_table[si] + (qt_sine_table[ci] - 0.5 * qt_sine_table[si] * d) * d;
}+/

/+pragma(inline, true) qreal qFastCos(qreal x)
{
    int ci = cast(int) (x * (0.5 * QT_SINE_TABLE_SIZE / mixin(((versionIsSet!("Windows") && !versionIsSet!("Cygwin") && (defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || !defined!"__STRICT_ANSI__"))) ? q{
            M_PI
        } : ((!versionIsSet!("Windows") || versionIsSet!("Cygwin"))) ? q{
        M_PI
        } : ((versionIsSet!("Windows") && !defined!"M_PI" && !defined!"_BSD_SOURCE" && !defined!"_GNU_SOURCE" && !defined!"_POSIX_C_SOURCE" && !defined!"_POSIX_SOURCE" && !defined!"_USE_MATH_DEFINES" && !defined!"_XOPEN_SOURCE" && !versionIsSet!("Cygwin") && defined!"__STRICT_ANSI__")) ? q{
        M_PI
        } : q{
        M_PI
        }))); // Would be more accurate with qRound, but slower.
    qreal d = x - ci * (2.0 * mixin(((versionIsSet!("Windows") && !versionIsSet!("Cygwin") && (defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || !defined!"__STRICT_ANSI__"))) ? q{
            M_PI
        } : ((!versionIsSet!("Windows") || versionIsSet!("Cygwin"))) ? q{
        M_PI
        } : ((versionIsSet!("Windows") && !defined!"M_PI" && !defined!"_BSD_SOURCE" && !defined!"_GNU_SOURCE" && !defined!"_POSIX_C_SOURCE" && !defined!"_POSIX_SOURCE" && !defined!"_USE_MATH_DEFINES" && !defined!"_XOPEN_SOURCE" && !versionIsSet!("Cygwin") && defined!"__STRICT_ANSI__")) ? q{
        M_PI
        } : q{
        M_PI
        }) / QT_SINE_TABLE_SIZE);
    int si = ci + QT_SINE_TABLE_SIZE / 4;
    si &= QT_SINE_TABLE_SIZE - 1;
    ci &= QT_SINE_TABLE_SIZE - 1;
    return qt_sine_table[si] - (qt_sine_table[ci] + 0.5 * qt_sine_table[si] * d) * d;
}+/

/+pragma(inline, true) float qDegreesToRadians(float degrees)
{
    static if (!versionIsSet!("Windows") || defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || versionIsSet!("Cygwin") || !defined!"__STRICT_ANSI__")
        import libc.math;

    return degrees * float( mixin(((versionIsSet!("Windows") && !versionIsSet!("Cygwin") && (defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || !defined!"__STRICT_ANSI__"))) ? q{
            M_PI
        } : ((!versionIsSet!("Windows") || versionIsSet!("Cygwin"))) ? q{
        M_PI
        } : ((versionIsSet!("Windows") && !defined!"M_PI" && !defined!"_BSD_SOURCE" && !defined!"_GNU_SOURCE" && !defined!"_POSIX_C_SOURCE" && !defined!"_POSIX_SOURCE" && !defined!"_USE_MATH_DEFINES" && !defined!"_XOPEN_SOURCE" && !versionIsSet!("Cygwin") && defined!"__STRICT_ANSI__")) ? q{
        M_PI
        } : q{
        M_PI
        }) / 180);
}

pragma(inline, true) double qDegreesToRadians(double degrees)
{
    static if (!versionIsSet!("Windows") || defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || versionIsSet!("Cygwin") || !defined!"__STRICT_ANSI__")
        import libc.math;

    return degrees * ( mixin(((versionIsSet!("Windows") && !versionIsSet!("Cygwin") && (defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || !defined!"__STRICT_ANSI__"))) ? q{
            M_PI
        } : ((!versionIsSet!("Windows") || versionIsSet!("Cygwin"))) ? q{
        M_PI
        } : ((versionIsSet!("Windows") && !defined!"M_PI" && !defined!"_BSD_SOURCE" && !defined!"_GNU_SOURCE" && !defined!"_POSIX_C_SOURCE" && !defined!"_POSIX_SOURCE" && !defined!"_USE_MATH_DEFINES" && !defined!"_XOPEN_SOURCE" && !versionIsSet!("Cygwin") && defined!"__STRICT_ANSI__")) ? q{
        M_PI
        } : q{
        M_PI
        }) / 180);
}

pragma(inline, true) real  qDegreesToRadians(real  degrees)
{
    static if (!versionIsSet!("Windows") || defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || versionIsSet!("Cygwin") || !defined!"__STRICT_ANSI__")
        import libc.math;

    return degrees * ( mixin(((versionIsSet!("Windows") && !versionIsSet!("Cygwin") && (defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || !defined!"__STRICT_ANSI__"))) ? q{
            M_PI
        } : ((!versionIsSet!("Windows") || versionIsSet!("Cygwin"))) ? q{
        M_PI
        } : ((versionIsSet!("Windows") && !defined!"M_PI" && !defined!"_BSD_SOURCE" && !defined!"_GNU_SOURCE" && !defined!"_POSIX_C_SOURCE" && !defined!"_POSIX_SOURCE" && !defined!"_USE_MATH_DEFINES" && !defined!"_XOPEN_SOURCE" && !versionIsSet!("Cygwin") && defined!"__STRICT_ANSI__")) ? q{
        M_PI
        } : q{
        M_PI
        }) / 180);
}

pragma(inline, true) double qDegreesToRadians(T, /+ std::enable_if_t<std::is_integral_v<T>, bool> +/ /+ = true +/)(T degrees)
{
    return qDegreesToRadians(static_cast!(double)(degrees));
}

pragma(inline, true) float qRadiansToDegrees(float radians)
{
    static if (!versionIsSet!("Windows") || defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || versionIsSet!("Cygwin") || !defined!"__STRICT_ANSI__")
        import libc.math;

    return radians * float(180 / mixin(((versionIsSet!("Windows") && !versionIsSet!("Cygwin") && (defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || !defined!"__STRICT_ANSI__"))) ? q{
            M_PI
        } : ((!versionIsSet!("Windows") || versionIsSet!("Cygwin"))) ? q{
        M_PI
        } : ((versionIsSet!("Windows") && !defined!"M_PI" && !defined!"_BSD_SOURCE" && !defined!"_GNU_SOURCE" && !defined!"_POSIX_C_SOURCE" && !defined!"_POSIX_SOURCE" && !defined!"_USE_MATH_DEFINES" && !defined!"_XOPEN_SOURCE" && !versionIsSet!("Cygwin") && defined!"__STRICT_ANSI__")) ? q{
        M_PI
        } : q{
        M_PI
        }));
}

pragma(inline, true) double qRadiansToDegrees(double radians)
{
    static if (!versionIsSet!("Windows") || defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || versionIsSet!("Cygwin") || !defined!"__STRICT_ANSI__")
        import libc.math;

    return radians * (180 / mixin(((versionIsSet!("Windows") && !versionIsSet!("Cygwin") && (defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || !defined!"__STRICT_ANSI__"))) ? q{
            M_PI
        } : ((!versionIsSet!("Windows") || versionIsSet!("Cygwin"))) ? q{
        M_PI
        } : ((versionIsSet!("Windows") && !defined!"M_PI" && !defined!"_BSD_SOURCE" && !defined!"_GNU_SOURCE" && !defined!"_POSIX_C_SOURCE" && !defined!"_POSIX_SOURCE" && !defined!"_USE_MATH_DEFINES" && !defined!"_XOPEN_SOURCE" && !versionIsSet!("Cygwin") && defined!"__STRICT_ANSI__")) ? q{
        M_PI
        } : q{
        M_PI
        }));
}

pragma(inline, true) real  qRadiansToDegrees(real  radians)
{
    static if (!versionIsSet!("Windows") || defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || versionIsSet!("Cygwin") || !defined!"__STRICT_ANSI__")
        import libc.math;

    return radians * (180 / mixin(((versionIsSet!("Windows") && !versionIsSet!("Cygwin") && (defined!"_BSD_SOURCE" || defined!"_GNU_SOURCE" || defined!"_POSIX_C_SOURCE" || defined!"_POSIX_SOURCE" || defined!"_USE_MATH_DEFINES" || defined!"_XOPEN_SOURCE" || !defined!"__STRICT_ANSI__"))) ? q{
            M_PI
        } : ((!versionIsSet!("Windows") || versionIsSet!("Cygwin"))) ? q{
        M_PI
        } : ((versionIsSet!("Windows") && !defined!"M_PI" && !defined!"_BSD_SOURCE" && !defined!"_GNU_SOURCE" && !defined!"_POSIX_C_SOURCE" && !defined!"_POSIX_SOURCE" && !defined!"_USE_MATH_DEFINES" && !defined!"_XOPEN_SOURCE" && !versionIsSet!("Cygwin") && defined!"__STRICT_ANSI__")) ? q{
        M_PI
        } : q{
        M_PI
        }));
}+/

// A qRadiansToDegrees(Integral) overload isn't here; it's extremely
// questionable that someone is manipulating quantities in radians
// using integral datatypes...

extern(C++, "QtPrivate") {
pragma(inline, true) quint32 qConstexprNextPowerOfTwo(quint32 v)
{
    v |= v >> 1;
    v |= v >> 2;
    v |= v >> 4;
    v |= v >> 8;
    v |= v >> 16;
    ++v;
    return v;
}

pragma(inline, true) quint64 qConstexprNextPowerOfTwo(quint64 v)
{
    v |= v >> 1;
    v |= v >> 2;
    v |= v >> 4;
    v |= v >> 8;
    v |= v >> 16;
    v |= v >> 32;
    ++v;
    return v;
}

pragma(inline, true) quint32 qConstexprNextPowerOfTwo(qint32 v)
{
    return qConstexprNextPowerOfTwo(quint32(v));
}

pragma(inline, true) quint64 qConstexprNextPowerOfTwo(qint64 v)
{
    return qConstexprNextPowerOfTwo(quint64(v));
}
} // namespace QtPrivate

/+pragma(inline, true) quint32 qNextPowerOfTwo(quint32 v)
{
/+ #if defined(__cpp_lib_int_pow2) && __cpp_lib_int_pow2 >= 202002L +/
    static if ((configValue!"__cpp_lib_int_pow2" >= 202002 && defined!"__cpp_lib_int_pow2"))
    {
        return /+ std:: +/bit_ceil(v + 1);
    }
    else
    {
    /+ #elif defined(QT_HAS_BUILTIN_CLZ) +/
        if (v == 0)
            return 1;
        return 2U << (31 ^ /+ QAlgorithmsPrivate:: +/qt_builtin_clz(v));
    }
/+ #else
    return QtPrivate::qConstexprNextPowerOfTwo(v);
#endif +/
}+/

/+pragma(inline, true) quint64 qNextPowerOfTwo(quint64 v)
{
/+ #if defined(__cpp_lib_int_pow2) && __cpp_lib_int_pow2 >= 202002L +/
    static if ((configValue!"__cpp_lib_int_pow2" >= 202002 && defined!"__cpp_lib_int_pow2"))
    {
        return /+ std:: +/bit_ceil(v + 1);
    }
    else
    {
    /+ #elif defined(QT_HAS_BUILTIN_CLZLL) +/
        if (v == 0)
            return 1;
        return 2uL << (63 ^ /+ QAlgorithmsPrivate:: +/qt_builtin_clzll(v));
    }
/+ #else
    return QtPrivate::qConstexprNextPowerOfTwo(v);
#endif +/
}+/

pragma(inline, true) quint32 qNextPowerOfTwo(qint32 v)
{
    return qNextPowerOfTwo(quint32(v));
}

pragma(inline, true) quint64 qNextPowerOfTwo(qint64 v)
{
    return qNextPowerOfTwo(quint64(v));
}

