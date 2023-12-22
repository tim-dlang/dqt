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

/+ #ifdef Q_CC_MSVC
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED +/

/*
    Warning: The contents of QAlgorithmsPrivate is not a part of the public Qt API
    and may be changed from version to version or even be completely removed.
*/
extern(C++, "QAlgorithmsPrivate") {

/+ #if QT_DEPRECATED_SINCE(5, 2) +/
/+ QT_DEPRECATED_X("Use std::sort") +/ void qSortHelper(RandomAccessIterator, T, LessThan)(RandomAccessIterator start, RandomAccessIterator end, ref const(T) t, LessThan lessThan);
/+ QT_DEPRECATED_X("Use std::sort") +/ pragma(inline, true) void qSortHelper(RandomAccessIterator, T)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) dummy);

/+ QT_DEPRECATED_X("Use std::stable_sort") +/ void qStableSortHelper(RandomAccessIterator, T, LessThan)(RandomAccessIterator start, RandomAccessIterator end, ref const(T) t, LessThan lessThan);
/+ QT_DEPRECATED_X("Use std::stable_sort") +/ pragma(inline, true) void qStableSortHelper(RandomAccessIterator, T)(RandomAccessIterator, RandomAccessIterator, ref const(T) );

/+ QT_DEPRECATED_X("Use std::lower_bound") +/ RandomAccessIterator qLowerBoundHelper(RandomAccessIterator, T, LessThan)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) value, LessThan lessThan);
/+ QT_DEPRECATED_X("Use std::upper_bound") +/ RandomAccessIterator qUpperBoundHelper(RandomAccessIterator, T, LessThan)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) value, LessThan lessThan);
/+ QT_DEPRECATED_X("Use std::binary_search") +/ RandomAccessIterator qBinaryFindHelper(RandomAccessIterator, T, LessThan)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) value, LessThan lessThan);
/+ #endif +/ // QT_DEPRECATED_SINCE(5, 2)

}

/+ #if QT_DEPRECATED_SINCE(5, 2) +/
/+ QT_DEPRECATED_X("Use std::copy") +/ pragma(inline, true) OutputIterator qCopy(InputIterator, OutputIterator)(InputIterator begin, InputIterator end, OutputIterator dest)
{
    while (begin != end)
        *dest++ = *begin++;
    return dest;
}

/+ QT_DEPRECATED_X("Use std::copy_backward") +/ pragma(inline, true) BiIterator2 qCopyBackward(BiIterator1, BiIterator2)(BiIterator1 begin, BiIterator1 end, BiIterator2 dest)
{
    while (begin != end)
        *--dest = *--end;
    return dest;
}

/+ QT_DEPRECATED_X("Use std::equal") +/ pragma(inline, true) bool qEqual(InputIterator1, InputIterator2)(InputIterator1 first1, InputIterator1 last1, InputIterator2 first2)
{
    for (; first1 != last1; ++first1, ++first2)
        if (!(*first1 == *first2))
            return false;
    return true;
}

/+ QT_DEPRECATED_X("Use std::fill") +/ pragma(inline, true) void qFill(ForwardIterator, T)(ForwardIterator first, ForwardIterator last, ref const(T) val)
{
    for (; first != last; ++first)
        *first = val;
}

/+ QT_DEPRECATED_X("Use std::fill") +/ pragma(inline, true) void qFill(Container, T)(ref Container container, ref const(T) val)
{
    qFill(container.begin(), container.end(), val);
}

/+ QT_DEPRECATED_X("Use std::find") +/ pragma(inline, true) InputIterator qFind(InputIterator, T)(InputIterator first, InputIterator last, ref const(T) val)
{
    while (first != last && !(*first == val))
        ++first;
    return first;
}

/+ QT_DEPRECATED_X("Use std::find") +/ pragma(inline, true) UnknownType!q{Container.const_iterator} qFind(Container, T)(ref const(Container) container, ref const(T) val)
{
    return qFind(container.constBegin(), container.constEnd(), val);
}

/+ QT_DEPRECATED_X("Use std::count") +/ pragma(inline, true) void qCount(InputIterator, T, Size)(InputIterator first, InputIterator last, ref const(T) value, ref Size n)
{
    for (; first != last; ++first)
        if (*first == value)
            ++n;
}

/+ QT_DEPRECATED_X("Use std::count") +/ pragma(inline, true) void qCount(Container, T, Size)(ref const(Container) container, ref const(T) value, ref Size n)
{
    qCount(container.constBegin(), container.constEnd(), value, n);
}

/+ #ifdef Q_QDOC
typedef void* LessThan;
template <typename T> LessThan qLess();
template <typename T> LessThan qGreater();
#else +/
extern(C++, class) struct /+ QT_DEPRECATED_X("Use std::less") +/ qLess(T)
{
public:
    /+pragma(inline, true) bool operator ()(ref const(T) t1, ref const(T) t2) const
    {
        return (t1 < t2);
    }+/
}

extern(C++, class) struct /+ QT_DEPRECATED_X("Use std::greater") +/ qGreater(T)
{
public:
    /+pragma(inline, true) bool operator ()(ref const(T) t1, ref const(T) t2) const
    {
        return (t2 < t1);
    }+/
}
/+ #endif +/

/+ QT_DEPRECATED_X("Use std::sort") +/ pragma(inline, true) void qSort(RandomAccessIterator)(RandomAccessIterator start, RandomAccessIterator end)
{
    if (start != end)
        /+ QAlgorithmsPrivate:: +/qSortHelper(start, end, *start);
}

/+ QT_DEPRECATED_X("Use std::sort") +/ pragma(inline, true) void qSort(RandomAccessIterator, LessThan)(RandomAccessIterator start, RandomAccessIterator end, LessThan lessThan)
{
    if (start != end)
        /+ QAlgorithmsPrivate:: +/qSortHelper(start, end, *start, lessThan);
}

/+ QT_DEPRECATED_X("Use std::sort") +/ pragma(inline, true) void qSort(Container)(ref Container c)
{
/+ #ifdef Q_CC_BOR
    // Work around Borland 5.5 optimizer bug
    c.detach();
#endif +/
    if (!c.empty())
        /+ QAlgorithmsPrivate:: +/qSortHelper(c.begin(), c.end(), *c.begin());
}

/+ QT_DEPRECATED_X("Use std::stable_sort") +/ pragma(inline, true) void qStableSort(RandomAccessIterator)(RandomAccessIterator start, RandomAccessIterator end)
{
    if (start != end)
        /+ QAlgorithmsPrivate:: +/qStableSortHelper(start, end, *start);
}

/+ QT_DEPRECATED_X("Use std::stable_sort") +/ pragma(inline, true) void qStableSort(RandomAccessIterator, LessThan)(RandomAccessIterator start, RandomAccessIterator end, LessThan lessThan)
{
    if (start != end)
        /+ QAlgorithmsPrivate:: +/qStableSortHelper(start, end, *start, lessThan);
}

/+ QT_DEPRECATED_X("Use std::stable_sort") +/ pragma(inline, true) void qStableSort(Container)(ref Container c)
{
/+ #ifdef Q_CC_BOR
    // Work around Borland 5.5 optimizer bug
    c.detach();
#endif +/
    if (!c.empty())
        /+ QAlgorithmsPrivate:: +/qStableSortHelper(c.begin(), c.end(), *c.begin());
}

/+ QT_DEPRECATED_X("Use std::lower_bound") +/ RandomAccessIterator qLowerBound(RandomAccessIterator, T)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) value)
{
    // Implementation is duplicated from QAlgorithmsPrivate to keep existing code
    // compiling. We have to allow using *begin and value with different types,
    // and then implementing operator< for those types.
    RandomAccessIterator middle;
    int n = end - begin;
    int half;

    while (n > 0) {
        half = n >> 1;
        middle = begin + half;
        if (*middle < value) {
            begin = middle + 1;
            n -= half + 1;
        } else {
            n = half;
        }
    }
    return begin;
}

/+ QT_DEPRECATED_X("Use std::lower_bound") +/ RandomAccessIterator qLowerBound(RandomAccessIterator, T, LessThan)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) value, LessThan lessThan)
{
    return /+ QAlgorithmsPrivate:: +/qLowerBoundHelper(begin, end, value, lessThan);
}

/+ QT_DEPRECATED_X("Use std::lower_bound") +/ UnknownType!q{Container.const_iterator} qLowerBound(Container, T)(ref const(Container) container, ref const(T) value)
{
    return /+ QAlgorithmsPrivate:: +/qLowerBoundHelper(container.constBegin(), container.constEnd(), value, qLess!(T)());
}

/+ QT_DEPRECATED_X("Use std::upper_bound") +/ RandomAccessIterator qUpperBound(RandomAccessIterator, T)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) value)
{
    // Implementation is duplicated from QAlgorithmsPrivate.
    RandomAccessIterator middle;
    int n = end - begin;
    int half;

    while (n > 0) {
        half = n >> 1;
        middle = begin + half;
        if (value < *middle) {
            n = half;
        } else {
            begin = middle + 1;
            n -= half + 1;
        }
    }
    return begin;
}

/+ QT_DEPRECATED_X("Use std::upper_bound") +/ RandomAccessIterator qUpperBound(RandomAccessIterator, T, LessThan)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) value, LessThan lessThan)
{
    return /+ QAlgorithmsPrivate:: +/qUpperBoundHelper(begin, end, value, lessThan);
}

/+ QT_DEPRECATED_X("Use std::upper_bound") +/ UnknownType!q{Container.const_iterator} qUpperBound(Container, T)(ref const(Container) container, ref const(T) value)
{
    return /+ QAlgorithmsPrivate:: +/qUpperBoundHelper(container.constBegin(), container.constEnd(), value, qLess!(T)());
}

/+ QT_DEPRECATED_X("Use std::binary_search") +/ RandomAccessIterator qBinaryFind(RandomAccessIterator, T)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) value)
{
    // Implementation is duplicated from QAlgorithmsPrivate.
    RandomAccessIterator it = qLowerBound(begin, end, value);

    if (it == end || value < *it)
        return end;

    return it;
}

/+ QT_DEPRECATED_X("Use std::binary_search") +/ RandomAccessIterator qBinaryFind(RandomAccessIterator, T, LessThan)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) value, LessThan lessThan)
{
    return /+ QAlgorithmsPrivate:: +/qBinaryFindHelper(begin, end, value, lessThan);
}

/+ QT_DEPRECATED_X("Use std::binary_search") +/ UnknownType!q{Container.const_iterator} qBinaryFind(Container, T)(ref const(Container) container, ref const(T) value)
{
    return /+ QAlgorithmsPrivate:: +/qBinaryFindHelper(container.constBegin(), container.constEnd(), value, qLess!(T)());
}
/+ #endif +/ // QT_DEPRECATED_SINCE(5, 2)

void qDeleteAll(ForwardIterator)(ForwardIterator begin, ForwardIterator end)
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
extern(C++, "QAlgorithmsPrivate") {

/+ #if QT_DEPRECATED_SINCE(5, 2) +/

/+ QT_DEPRECATED_X("Use std::sort") +/ void qSortHelper(RandomAccessIterator, T, LessThan)(RandomAccessIterator start, RandomAccessIterator end, ref const(T) t, LessThan lessThan)
{
top:
    int span = int(end - start);
    if (span < 2)
        return;

    --end;
    RandomAccessIterator low = start; RandomAccessIterator high = end - 1;
    RandomAccessIterator pivot = start + span / 2;

    if (lessThan(*end, *start))
        qSwap(*end, *start);
    if (span == 2)
        return;

    if (lessThan(*pivot, *start))
        qSwap(*pivot, *start);
    if (lessThan(*end, *pivot))
        qSwap(*end, *pivot);
    if (span == 3)
        return;

    qSwap(*pivot, *end);

    while (low < high) {
        while (low < high && lessThan(*low, *end))
            ++low;

        while (high > low && lessThan(*end, *high))
            --high;

        if (low < high) {
            qSwap(*low, *high);
            ++low;
            --high;
        } else {
            break;
        }
    }

    if (lessThan(*low, *end))
        ++low;

    qSwap(*end, *low);
    qSortHelper(start, low, t, lessThan);

    start = low + 1;
    ++end;
    goto top;
}

/+ QT_DEPRECATED_X("Use std::sort") +/ pragma(inline, true) void qSortHelper(RandomAccessIterator, T)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) dummy)
{
    qSortHelper(begin, end, dummy, qLess!(T)());
}

/+ QT_DEPRECATED_X("Use std::reverse") +/ void qReverse(RandomAccessIterator)(RandomAccessIterator begin, RandomAccessIterator end)
{
    --end;
    while (begin < end)
        qSwap(*begin++, *end--);
}

/+ QT_DEPRECATED_X("Use std::rotate") +/ void qRotate(RandomAccessIterator)(RandomAccessIterator begin, RandomAccessIterator middle, RandomAccessIterator end)
{
    qReverse(begin, middle);
    qReverse(middle, end);
    qReverse(begin, end);
}

/+ QT_DEPRECATED_X("Use std::merge") +/ void qMerge(RandomAccessIterator, T, LessThan)(RandomAccessIterator begin, RandomAccessIterator pivot, RandomAccessIterator end, ref T t, LessThan lessThan)
{
    const(int) len1 = pivot - begin;
    const(int) len2 = end - pivot;

    if (len1 == 0 || len2 == 0)
        return;

    if (len1 + len2 == 2) {
        if (lessThan(*(begin + 1), *(begin)))
            qSwap(*begin, *(begin + 1));
        return;
    }

    RandomAccessIterator firstCut;
    RandomAccessIterator secondCut;
    int len2Half;
    if (len1 > len2) {
        const(int) len1Half = len1 / 2;
        firstCut = begin + len1Half;
        secondCut = qLowerBound(pivot, end, *firstCut, lessThan);
        len2Half = secondCut - pivot;
    } else {
        len2Half = len2 / 2;
        secondCut = pivot + len2Half;
        firstCut = qUpperBound(begin, pivot, *secondCut, lessThan);
    }

    qRotate(firstCut, pivot, secondCut);
    const(RandomAccessIterator) newPivot = firstCut + len2Half;
    qMerge(begin, firstCut, newPivot, t, lessThan);
    qMerge(newPivot, secondCut, end, t, lessThan);
}

/+ QT_DEPRECATED_X("Use std::stable_sort") +/ void qStableSortHelper(RandomAccessIterator, T, LessThan)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) t, LessThan lessThan)
{
    const(int) span = end - begin;
    if (span < 2)
       return;

    const(RandomAccessIterator) middle = begin + span / 2;
    qStableSortHelper(begin, middle, t, lessThan);
    qStableSortHelper(middle, end, t, lessThan);
    qMerge(begin, middle, end, t, lessThan);
}

/+ QT_DEPRECATED_X("Use std::stable_sort") +/ pragma(inline, true) void qStableSortHelper(RandomAccessIterator, T)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) dummy)
{
    qStableSortHelper(begin, end, dummy, qLess!(T)());
}

/+ QT_DEPRECATED_X("Use std::lower_bound") +/ RandomAccessIterator qLowerBoundHelper(RandomAccessIterator, T, LessThan)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) value, LessThan lessThan)
{
    RandomAccessIterator middle;
    int n = int(end - begin);
    int half;

    while (n > 0) {
        half = n >> 1;
        middle = begin + half;
        if (lessThan(*middle, value)) {
            begin = middle + 1;
            n -= half + 1;
        } else {
            n = half;
        }
    }
    return begin;
}


/+ QT_DEPRECATED_X("Use std::upper_bound") +/ RandomAccessIterator qUpperBoundHelper(RandomAccessIterator, T, LessThan)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) value, LessThan lessThan)
{
    RandomAccessIterator middle;
    int n = end - begin;
    int half;

    while (n > 0) {
        half = n >> 1;
        middle = begin + half;
        if (lessThan(value, *middle)) {
            n = half;
        } else {
            begin = middle + 1;
            n -= half + 1;
        }
    }
    return begin;
}

/+ QT_DEPRECATED_X("Use std::binary_search") +/ RandomAccessIterator qBinaryFindHelper(RandomAccessIterator, T, LessThan)(RandomAccessIterator begin, RandomAccessIterator end, ref const(T) value, LessThan lessThan)
{
    RandomAccessIterator it = qLowerBoundHelper(begin, end, value, lessThan);

    if (it == end || lessThan(value, *it))
        return end;

    return it;
}

/+ #endif // QT_DEPRECATED_SINCE(5, 2)

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
Q_ALWAYS_INLINE uint qt_builtin_ctzs(quint16 v) noexcept
{
#  if __has_builtin(__builtin_ctzs)
    return __builtin_ctzs(v);
#  else
    return __builtin_ctz(v);
#  endif
}
#define QT_HAS_BUILTIN_CLZS
Q_ALWAYS_INLINE uint qt_builtin_clzs(quint16 v) noexcept
{
#  if __has_builtin(__builtin_clzs)
    return __builtin_clzs(v);
#  else
    return __builtin_clz(v) - 16U;
#  endif
}
#define QT_HAS_BUILTIN_CTZ
Q_ALWAYS_INLINE uint qt_builtin_ctz(quint32 v) noexcept
{
    return __builtin_ctz(v);
}
#define QT_HAS_BUILTIN_CLZ
Q_ALWAYS_INLINE uint qt_builtin_clz(quint32 v) noexcept
{
    return __builtin_clz(v);
}
#define QT_HAS_BUILTIN_CTZLL
Q_ALWAYS_INLINE uint qt_builtin_ctzll(quint64 v) noexcept
{
    return __builtin_ctzll(v);
}
#define QT_HAS_BUILTIN_CLZLL
Q_ALWAYS_INLINE uint qt_builtin_clzll(quint64 v) noexcept
{
    return __builtin_clzll(v);
}
#define QALGORITHMS_USE_BUILTIN_POPCOUNT
Q_ALWAYS_INLINE uint qt_builtin_popcount(quint32 v) noexcept
{
    return __builtin_popcount(v);
}
Q_ALWAYS_INLINE uint qt_builtin_popcount(quint8 v) noexcept
{
    return __builtin_popcount(v);
}
Q_ALWAYS_INLINE uint qt_builtin_popcount(quint16 v) noexcept
{
    return __builtin_popcount(v);
}
#define QALGORITHMS_USE_BUILTIN_POPCOUNTLL
Q_ALWAYS_INLINE uint qt_builtin_popcountll(quint64 v) noexcept
{
    return __builtin_popcountll(v);
}
#elif defined(Q_CC_MSVC) && !defined(Q_PROCESSOR_ARM)
#define QT_POPCOUNT_CONSTEXPR
#define QT_POPCOUNT_RELAXED_CONSTEXPR
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
#if defined(__AVX__) || defined(__SSE4_2__) || defined(__POPCNT__)
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
#define QT_POPCOUNT_CONSTEXPR Q_DECL_CONSTEXPR
#define QT_POPCOUNT_RELAXED_CONSTEXPR Q_DECL_RELAXED_CONSTEXPR
#endif +/

} //namespace QAlgorithmsPrivate

/+ Q_DECL_CONST_FUNCTION +/ pragma(inline, true) uint qPopulationCount(quint32 v)/+ noexcept+/
{
/+ #ifdef QALGORITHMS_USE_BUILTIN_POPCOUNT +/
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
/+ #ifdef QALGORITHMS_USE_BUILTIN_POPCOUNT +/
    return popcnt(v);
/+ #else
    return
        (((v      ) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f;
#endif +/
}

/+ Q_DECL_CONST_FUNCTION +/ pragma(inline, true) uint qPopulationCount(quint16 v)/+ noexcept+/
{
/+ #ifdef QALGORITHMS_USE_BUILTIN_POPCOUNT +/
    return popcnt(v);
/+ #else
    return
        (((v      ) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f +
        (((v >> 12) & 0xfff)    * Q_UINT64_C(0x1001001001001) & Q_UINT64_C(0x84210842108421)) % 0x1f;
#endif +/
}

/+ Q_DECL_CONST_FUNCTION +/ pragma(inline, true) uint qPopulationCount(quint64 v)/+ noexcept+/
{
/+ #ifdef QALGORITHMS_USE_BUILTIN_POPCOUNTLL +/
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

/+ #if defined(Q_CC_GNU) && !defined(Q_CC_CLANG)
#undef QALGORITHMS_USE_BUILTIN_POPCOUNT
#endif
#undef QT_POPCOUNT_CONSTEXPR +/

pragma(inline, true) uint qCountTrailingZeroBits(quint32 v)/+ noexcept+/
{
/+ #if defined(QT_HAS_BUILTIN_CTZ) +/
    return v ? bsf(v) : 32U;
/+ #else
    // see http://graphics.stanford.edu/~seander/bithacks.html#ZerosOnRightParallel
    unsigned int c = 32; // c will be the number of zero bits on the right
    v &= -signed(v);
    if (v) c--;
    if (v & 0x0000FFFF) c -= 16;
    if (v & 0x00FF00FF) c -= 8;
    if (v & 0x0F0F0F0F) c -= 4;
    if (v & 0x33333333) c -= 2;
    if (v & 0x55555555) c -= 1;
    return c;
#endif +/
}

pragma(inline, true) uint qCountTrailingZeroBits(quint8 v)/+ noexcept+/
{
/+ #if defined(QT_HAS_BUILTIN_CTZ) +/
    return v ? bsf(v) : 8U;
/+ #else
    unsigned int c = 8; // c will be the number of zero bits on the right
    v &= -signed(v);
    if (v) c--;
    if (v & 0x0000000F) c -= 4;
    if (v & 0x00000033) c -= 2;
    if (v & 0x00000055) c -= 1;
    return c;
#endif +/
}

pragma(inline, true) uint qCountTrailingZeroBits(quint16 v)/+ noexcept+/
{
/+ #if defined(QT_HAS_BUILTIN_CTZS) +/
    return v ? bsf(v) : 16U;
/+ #else
    unsigned int c = 16; // c will be the number of zero bits on the right
    v &= -signed(v);
    if (v) c--;
    if (v & 0x000000FF) c -= 8;
    if (v & 0x00000F0F) c -= 4;
    if (v & 0x00003333) c -= 2;
    if (v & 0x00005555) c -= 1;
    return c;
#endif +/
}

pragma(inline, true) uint qCountTrailingZeroBits(quint64 v)/+ noexcept+/
{
/+ #if defined(QT_HAS_BUILTIN_CTZLL) +/
    return v ? bsf(v) : 64;
/+ #else
    quint32 x = static_cast<quint32>(v);
    return x ? qCountTrailingZeroBits(x)
             : 32 + qCountTrailingZeroBits(static_cast<quint32>(v >> 32));
#endif +/
}

pragma(inline, true) uint qCountTrailingZeroBits(cpp_ulong  v)/+ noexcept+/
{
    return qCountTrailingZeroBits(QIntegerForSizeof!(cpp_long).Unsigned(v));
}

pragma(inline, true) uint qCountLeadingZeroBits(quint32 v)/+ noexcept+/
{
/+ #if defined(QT_HAS_BUILTIN_CLZ) +/
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
/+ #if defined(QT_HAS_BUILTIN_CLZ) +/
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
/+ #if defined(QT_HAS_BUILTIN_CLZS) +/
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
/+ #if defined(QT_HAS_BUILTIN_CLZLL) +/
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

/+ QT_WARNING_POP +/

