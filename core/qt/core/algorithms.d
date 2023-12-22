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
module qt.core.algorithms;
extern(C++):

import core.bitop;
import core.stdc.config;
import qt.config;
import qt.core.global;
import qt.helpers;
import std.traits;

extern(D) private Signed!T signed(T)(T val)
{
    return Signed!T(val);
}

/+ #if __has_include(<bit>) && __cplusplus > 201703L
#endif

#ifdef Q_CC_MSVC
#endif +/


extern(D) void qDeleteAll(ForwardIterator)(ForwardIterator begin, ForwardIterator end)
{
    import core.stdcpp.new_;

    while (begin != end) {
        if (*begin !is null) { // Check for null as a workaround for https://issues.dlang.org/show_bug.cgi?id=24298
            cpp_delete(*begin);
        }
        ++begin;
    }
}

pragma(inline, true) void qDeleteAll(Container)(ref Container c)
{
    qDeleteAll(c.begin(), c.end());
}

/*
    Warning: The contents of QAlgorithmsPrivate is not a part of the public Qt API
    and may be changed from version to version or even be completely removed.
*/
/+ namespace QAlgorithmsPrivate {

#ifdef Q_CC_CLANG
// Clang had a bug where __builtin_ctz/clz/popcount were not marked as constexpr.
#  if (defined __apple_build_version__ &&  __clang_major__ >= 7) || (Q_CC_CLANG >= 307)
#    define QT_HAS_CONSTEXPR_BUILTINS
#  endif
#elif defined(Q_CC_MSVC) && !defined(Q_CC_INTEL) && !defined(Q_PROCESSOR_ARM)
#  define QT_HAS_CONSTEXPR_BUILTINS
#elif defined(Q_CC_GNU)
#  define QT_HAS_CONSTEXPR_BUILTINS
#endif

#if defined QT_HAS_CONSTEXPR_BUILTINS
#if defined(Q_CC_GNU) || defined(Q_CC_CLANG)
#  define QT_HAS_BUILTIN_CTZS
constexpr Q_ALWAYS_INLINE uint qt_builtin_ctzs(quint16 v) noexcept
{
#  if __has_builtin(__builtin_ctzs)
    return __builtin_ctzs(v);
#  else
    return __builtin_ctz(v);
#  endif
}
#define QT_HAS_BUILTIN_CLZS
constexpr Q_ALWAYS_INLINE uint qt_builtin_clzs(quint16 v) noexcept
{
#  if __has_builtin(__builtin_clzs)
    return __builtin_clzs(v);
#  else
    return __builtin_clz(v) - 16U;
#  endif
}
#define QT_HAS_BUILTIN_CTZ
constexpr Q_ALWAYS_INLINE uint qt_builtin_ctz(quint32 v) noexcept
{
    return __builtin_ctz(v);
}
#define QT_HAS_BUILTIN_CLZ
constexpr Q_ALWAYS_INLINE uint qt_builtin_clz(quint32 v) noexcept
{
    return __builtin_clz(v);
}
#define QT_HAS_BUILTIN_CTZLL
constexpr Q_ALWAYS_INLINE uint qt_builtin_ctzll(quint64 v) noexcept
{
    return __builtin_ctzll(v);
}
#define QT_HAS_BUILTIN_CLZLL
constexpr Q_ALWAYS_INLINE uint qt_builtin_clzll(quint64 v) noexcept
{
    return __builtin_clzll(v);
}
#define QALGORITHMS_USE_BUILTIN_POPCOUNT
constexpr Q_ALWAYS_INLINE uint qt_builtin_popcount(quint32 v) noexcept
{
    return __builtin_popcount(v);
}
constexpr Q_ALWAYS_INLINE uint qt_builtin_popcount(quint8 v) noexcept
{
    return __builtin_popcount(v);
}
constexpr Q_ALWAYS_INLINE uint qt_builtin_popcount(quint16 v) noexcept
{
    return __builtin_popcount(v);
}
#define QALGORITHMS_USE_BUILTIN_POPCOUNTLL
constexpr Q_ALWAYS_INLINE uint qt_builtin_popcountll(quint64 v) noexcept
{
    return __builtin_popcountll(v);
}
#elif defined(Q_CC_MSVC) && !defined(Q_PROCESSOR_ARM)
#define QT_HAS_BUILTIN_CTZ
Q_ALWAYS_INLINE unsigned long qt_builtin_ctz(quint32 val)
{
    unsigned long result;
    _BitScanForward(&result, val);
    return result;
}
#define QT_HAS_BUILTIN_CLZ
Q_ALWAYS_INLINE unsigned long qt_builtin_clz(quint32 val)
{
    unsigned long result;
    _BitScanReverse(&result, val);
    // Now Invert the result: clz will count *down* from the msb to the lsb, so the msb index is 31
    // and the lsb index is 0. The result for the index when counting up: msb index is 0 (because it
    // starts there), and the lsb index is 31.
    result ^= sizeof(quint32) * 8 - 1;
    return result;
}
#if Q_PROCESSOR_WORDSIZE == 8
// These are only defined for 64bit builds.
#define QT_HAS_BUILTIN_CTZLL
Q_ALWAYS_INLINE unsigned long qt_builtin_ctzll(quint64 val)
{
    unsigned long result;
    _BitScanForward64(&result, val);
    return result;
}
// MSVC calls it _BitScanReverse and returns the carry flag, which we don't need
#define QT_HAS_BUILTIN_CLZLL
Q_ALWAYS_INLINE unsigned long qt_builtin_clzll(quint64 val)
{
    unsigned long result;
    _BitScanReverse64(&result, val);
    // see qt_builtin_clz
    result ^= sizeof(quint64) * 8 - 1;
    return result;
}
#endif // MSVC 64bit
#  define QT_HAS_BUILTIN_CTZS
Q_ALWAYS_INLINE uint qt_builtin_ctzs(quint16 v) noexcept
{
    return qt_builtin_ctz(v);
}
#define QT_HAS_BUILTIN_CLZS
Q_ALWAYS_INLINE uint qt_builtin_clzs(quint16 v) noexcept
{
    return qt_builtin_clz(v) - 16U;
}

// Neither MSVC nor the Intel compiler define a macro for the POPCNT processor
// feature, so we're using either the SSE4.2 or the AVX macro as a proxy (Clang
// does define the macro). It's incorrect for two reasons:
// 1. It's a separate bit in CPUID, so a processor could implement SSE4.2 and
//    not POPCNT, but that's unlikely to happen.
// 2. There are processors that support POPCNT but not AVX (Intel Nehalem
//    architecture), but unlike the other compilers, MSVC has no option
//    to generate code for those processors.
// So it's an acceptable compromise.
#if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
// We use C++20 <bit> operations instead which ensures constexpr popcount
#elif defined(__AVX__) || defined(__SSE4_2__) || defined(__POPCNT__)
#define QT_POPCOUNT_CONSTEXPR
#define QT_POPCOUNT_RELAXED_CONSTEXPR
#define QALGORITHMS_USE_BUILTIN_POPCOUNT
#define QALGORITHMS_USE_BUILTIN_POPCOUNTLL
Q_ALWAYS_INLINE uint qt_builtin_popcount(quint32 v) noexcept
{
    return __popcnt(v);
}
Q_ALWAYS_INLINE uint qt_builtin_popcount(quint8 v) noexcept
{
    return __popcnt16(v);
}
Q_ALWAYS_INLINE uint qt_builtin_popcount(quint16 v) noexcept
{
    return __popcnt16(v);
}
Q_ALWAYS_INLINE uint qt_builtin_popcountll(quint64 v) noexcept
{
#if Q_PROCESSOR_WORDSIZE == 8
    return __popcnt64(v);
#else
    return __popcnt(quint32(v)) + __popcnt(quint32(v >> 32));
#endif // MSVC 64bit
}

#endif // __AVX__ || __SSE4_2__ || __POPCNT__

#endif // MSVC
#endif // QT_HAS_CONSTEXPR_BUILTINS

#ifndef QT_POPCOUNT_CONSTEXPR
#define QT_POPCOUNT_CONSTEXPR constexpr
#define QT_POPCOUNT_RELAXED_CONSTEXPR constexpr
#endif

} +/ //namespace QAlgorithmsPrivate

/+ Q_DECL_CONST_FUNCTION +/ pragma(inline, true) uint qPopulationCount(quint32 v)/+ noexcept+/
{
/+ #if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
    return std::popcount(v);
#elif defined QALGORITHMS_USE_BUILTIN_POPCOUNT +/
    return popcnt(v);
/+ #else
    // See http://graphics.stanford.edu/~seander/bithacks.html#CountBitsSetParallel
    return
        (((v      ) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f +
        (((v >> 12) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f +
        (((v >> 24) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f;
#endif +/
}

/+ Q_DECL_CONST_FUNCTION +/ pragma(inline, true) uint qPopulationCount(quint8 v)/+ noexcept+/
{
/+ #if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
    return std::popcount(v);
#elif defined QALGORITHMS_USE_BUILTIN_POPCOUNT +/
    return popcnt(v);
/+ #else
    return
        (((v      ) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f;
#endif +/
}

/+ Q_DECL_CONST_FUNCTION +/ pragma(inline, true) uint qPopulationCount(quint16 v)/+ noexcept+/
{
/+ #if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
    return std::popcount(v);
#elif defined QALGORITHMS_USE_BUILTIN_POPCOUNT +/
    return popcnt(v);
/+ #else
    return
        (((v      ) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f +
        (((v >> 12) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f;
#endif +/
}

/+ Q_DECL_CONST_FUNCTION +/ pragma(inline, true) uint qPopulationCount(quint64 v)/+ noexcept+/
{
/+ #if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
    return std::popcount(v);
#elif defined QALGORITHMS_USE_BUILTIN_POPCOUNTLL +/
    return popcnt(v);
/+ #else
    return
        (((v      ) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f +
        (((v >> 12) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f +
        (((v >> 24) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f +
        (((v >> 36) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f +
        (((v >> 48) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f +
        (((v >> 60) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f;
#endif +/
}

/+ Q_DECL_CONST_FUNCTION +/ pragma(inline, true) uint qPopulationCount(cpp_ulong   v)/+ noexcept+/
{
    return qPopulationCount(static_cast!(quint64)(v));
}

/+ #if defined(QALGORITHMS_USE_BUILTIN_POPCOUNT)
#undef QALGORITHMS_USE_BUILTIN_POPCOUNT
#endif
#undef QT_POPCOUNT_CONSTEXPR +/

extern(C++, "QtPrivate") {
pragma(inline, true) uint qConstexprCountTrailingZeroBits(quint32 v)/+ noexcept+/
{
    // see http://graphics.stanford.edu/~seander/bithacks.html#ZerosOnRightParallel
    uint  c = 32; // c will be the number of zero bits on the right
    v &= -signed(v);
    if (v) c--;
    if (v & 0x0000FFFF) c -= 16;
    if (v & 0x00FF00FF) c -= 8;
    if (v & 0x0F0F0F0F) c -= 4;
    if (v & 0x33333333) c -= 2;
    if (v & 0x55555555) c -= 1;
    return c;
}

pragma(inline, true) uint qConstexprCountTrailingZeroBits(quint64 v)/+ noexcept+/
{
    quint32 x = static_cast!(quint32)(v);
    return x ? qConstexprCountTrailingZeroBits(x)
             : 32 + qConstexprCountTrailingZeroBits(static_cast!(quint32)(v >> 32));
}

pragma(inline, true) uint qConstexprCountTrailingZeroBits(quint8 v)/+ noexcept+/
{
    uint  c = 8; // c will be the number of zero bits on the right
    v &= -int(signed(v));
    if (v) c--;
    if (v & 0x0000000F) c -= 4;
    if (v & 0x00000033) c -= 2;
    if (v & 0x00000055) c -= 1;
    return c;
}

pragma(inline, true) uint qConstexprCountTrailingZeroBits(quint16 v)/+ noexcept+/
{
    uint  c = 16; // c will be the number of zero bits on the right
    v &= -int(signed(v));
    if (v) c--;
    if (v & 0x000000FF) c -= 8;
    if (v & 0x00000F0F) c -= 4;
    if (v & 0x00003333) c -= 2;
    if (v & 0x00005555) c -= 1;
    return c;
}

// Disabled as a workaround for https://issues.dlang.org/show_bug.cgi?id=22813
/*pragma(inline, true) uint qConstexprCountTrailingZeroBits(cpp_ulong  v)/+ noexcept+/
{
    return qConstexprCountTrailingZeroBits(QIntegerForSizeof!(cpp_long).Unsigned(v));
}*/
}

pragma(inline, true) uint qCountTrailingZeroBits(quint32 v)/+ noexcept+/
{
/+ #if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
    return std::countr_zero(v);
#elif defined(QT_HAS_BUILTIN_CTZ) +/
    return v ? bsf(v) : 32U;
/+ #else
    return QtPrivate::qConstexprCountTrailingZeroBits(v);
#endif +/
}

pragma(inline, true) uint qCountTrailingZeroBits(quint8 v)/+ noexcept+/
{
/+ #if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
    return std::countr_zero(v);
#elif defined(QT_HAS_BUILTIN_CTZ) +/
    return v ? bsf(v) : 8U;
/+ #else
    return QtPrivate::qConstexprCountTrailingZeroBits(v);
#endif +/
}

pragma(inline, true) uint qCountTrailingZeroBits(quint16 v)/+ noexcept+/
{
/+ #if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
    return std::countr_zero(v);
#elif defined(QT_HAS_BUILTIN_CTZS) +/
    return v ? bsf(v) : 16U;
/+ #else
    return QtPrivate::qConstexprCountTrailingZeroBits(v);
#endif +/
}

pragma(inline, true) uint qCountTrailingZeroBits(quint64 v)/+ noexcept+/
{
/+ #if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
    return std::countr_zero(v);
#elif defined(QT_HAS_BUILTIN_CTZLL) +/
    return v ? bsf(v) : 64;
/+ #else
    return QtPrivate::qConstexprCountTrailingZeroBits(v);
#endif +/
}

pragma(inline, true) uint qCountTrailingZeroBits(cpp_ulong  v)/+ noexcept+/
{
    return qCountTrailingZeroBits(QIntegerForSizeof!(cpp_long).Unsigned(v));
}

pragma(inline, true) uint qCountLeadingZeroBits(quint32 v)/+ noexcept+/
{
/+ #if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
    return std::countl_zero(v);
#elif defined(QT_HAS_BUILTIN_CLZ) +/
    return v ? 31U - bsr(v) : 32U;
/+ #else
    // Hacker's Delight, 2nd ed. Fig 5-16, p. 102
    v = v | (v >> 1);
    v = v | (v >> 2);
    v = v | (v >> 4);
    v = v | (v >> 8);
    v = v | (v >> 16);
    return qPopulationCount(~v);
#endif +/
}

pragma(inline, true) uint qCountLeadingZeroBits(quint8 v)/+ noexcept+/
{
/+ #if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
    return std::countl_zero(v);
#elif defined(QT_HAS_BUILTIN_CLZ) +/
    return v ? 7U - bsr(v) : 8U;
/+ #else
    v = v | (v >> 1);
    v = v | (v >> 2);
    v = v | (v >> 4);
    return qPopulationCount(static_cast<quint8>(~v));
#endif +/
}

pragma(inline, true) uint qCountLeadingZeroBits(quint16 v)/+ noexcept+/
{
/+ #if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
    return std::countl_zero(v);
#elif defined(QT_HAS_BUILTIN_CLZS) +/
    return v ? 15U - bsr(v) : 16U;
/+ #else
    v = v | (v >> 1);
    v = v | (v >> 2);
    v = v | (v >> 4);
    v = v | (v >> 8);
    return qPopulationCount(static_cast<quint16>(~v));
#endif +/
}

pragma(inline, true) uint qCountLeadingZeroBits(quint64 v)/+ noexcept+/
{
/+ #if defined(__cpp_lib_bitops) && __cpp_lib_bitops >= 201907L
    return std::countl_zero(v);
#elif defined(QT_HAS_BUILTIN_CLZLL) +/
    return v ? 63U - bsr(v) : 64U;
/+ #else
    v = v | (v >> 1);
    v = v | (v >> 2);
    v = v | (v >> 4);
    v = v | (v >> 8);
    v = v | (v >> 16);
    v = v | (v >> 32);
    return qPopulationCount(~v);
#endif +/
}

pragma(inline, true) uint qCountLeadingZeroBits(cpp_ulong  v)/+ noexcept+/
{
    return qCountLeadingZeroBits(QIntegerForSizeof!(cpp_long).Unsigned(v));
}

/+ #undef QT_POPCOUNT_RELAXED_CONSTEXPR +/


