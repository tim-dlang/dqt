/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.core.pair;
extern(C++):

import qt.config;
import qt.helpers;

struct QPair(T1, T2)
{
    alias first_type = T1;
    alias second_type = T2;

    /+this()
            /+ noexcept((std::is_nothrow_default_constructible<T1>::value &&
                                  std::is_nothrow_default_constructible<T2>::value)) +/
    {
        this.first = typeof(this.first)();
        this.second = typeof(this.second)();
    }+/
    this(ref const(T1) t1, ref const(T2) t2)
            /+ noexcept((std::is_nothrow_copy_constructible<T1>::value &&
                                  std::is_nothrow_copy_constructible<T2>::value)) +/
    {
        this.first = t1;
        this.second = t2;
    }
    // compiler-generated copy/move ctor/assignment operators are fine!

    /+ template <typename TT1, typename TT2> +/
    /+ QPair(const QPair<TT1, TT2> &p)
        noexcept((std::is_nothrow_constructible<T1, TT1&>::value &&
                              std::is_nothrow_constructible<T2, TT2&>::value))
        : first(p.first), second(p.second) {} +/
    /+ template <typename TT1, typename TT2> +/
    /+ QPair &operator=(const QPair<TT1, TT2> &p)
        noexcept((std::is_nothrow_assignable<T1, TT1&>::value &&
                              std::is_nothrow_assignable<T2, TT2&>::value))
    { first = p.first; second = p.second; return *this; } +/
    /+ template <typename TT1, typename TT2> +/
    /+ QPair(QPair<TT1, TT2> &&p)
        noexcept((std::is_nothrow_constructible<T1, TT1>::value &&
                              std::is_nothrow_constructible<T2, TT2>::value))
        // can't use std::move here as it's not constexpr in C++11:
        : first(static_cast<TT1 &&>(p.first)), second(static_cast<TT2 &&>(p.second)) {} +/
    /+ template <typename TT1, typename TT2> +/
    /+ QPair &operator=(QPair<TT1, TT2> &&p)
        noexcept((std::is_nothrow_assignable<T1, TT1>::value &&
                              std::is_nothrow_assignable<T2, TT2>::value))
    { first = std::move(p.first); second = std::move(p.second); return *this; } +/

    /+ void swap(QPair &other)
        noexcept(noexcept(qSwap(other.first, other.first)) && noexcept(qSwap(other.second, other.second)))
    {
        // use qSwap() to pick up ADL swaps automatically:
        qSwap(first, other.first);
        qSwap(second, other.second);
    } +/

    T1 first;
    T2 second;
}

/+ #if defined(__cpp_deduction_guides) && __cpp_deduction_guides >= 201606
template<class T1, class T2>
QPair(T1, T2) -> QPair<T1, T2>;
#endif

template <typename T1, typename T2>
void swap(QPair<T1, T2> &lhs, QPair<T1, T2> &rhs) noexcept(noexcept(lhs.swap(rhs)))
{ lhs.swap(rhs); }

// mark QPair<T1,T2> as complex/movable/primitive depending on the
// typeinfos of the constituents:
template<class T1, class T2>
class QTypeInfo<QPair<T1, T2> > : public QTypeInfoMerger<QPair<T1, T2>, T1, T2> {}; +/ // Q_DECLARE_TYPEINFO

/+pragma(inline, true) bool operator ==(T1, T2)(ref const(QPair!(T1, T2)) p1, ref const(QPair!(T1, T2)) p2)
    /+ noexcept(noexcept(p1.first == p2.first && p1.second == p2.second)) +/
{ return p1.first == p2.first && p1.second == p2.second; }+/

/+pragma(inline, true) bool operator !=(T1, T2)(ref const(QPair!(T1, T2)) p1, ref const(QPair!(T1, T2)) p2)
    /+ noexcept(noexcept(!(p1 == p2))) +/
{ return !(p1 == p2); }+/

/+pragma(inline, true) bool operator <(T1, T2)(ref const(QPair!(T1, T2)) p1, ref const(QPair!(T1, T2)) p2)
    /+ noexcept(noexcept(p1.first < p2.first || (!(p2.first < p1.first) && p1.second < p2.second))) +/
{
    return p1.first < p2.first || (!(p2.first < p1.first) && p1.second < p2.second);
}+/

/+pragma(inline, true) bool operator >(T1, T2)(ref const(QPair!(T1, T2)) p1, ref const(QPair!(T1, T2)) p2)
    /+ noexcept(noexcept(p2 < p1)) +/
{
    return p2 < p1;
}+/

/+pragma(inline, true) bool operator <=(T1, T2)(ref const(QPair!(T1, T2)) p1, ref const(QPair!(T1, T2)) p2)
    /+ noexcept(noexcept(!(p2 < p1))) +/
{
    return !(p2 < p1);
}+/

/+pragma(inline, true) bool operator >=(T1, T2)(ref const(QPair!(T1, T2)) p1, ref const(QPair!(T1, T2)) p2)
    /+ noexcept(noexcept(!(p1 < p2))) +/
{
    return !(p1 < p2);
}+/

QPair!(T1, T2) qMakePair(T1, T2)(ref const(T1) x, ref const(T2) y)
    /+ noexcept(noexcept(QPair<T1, T2>(x, y))) +/
{
    return QPair!(T1, T2)(x, y);
}

