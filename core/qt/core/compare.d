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
module qt.core.compare;
extern(C++):

import qt.config;
import qt.core.global;
import qt.helpers;

/+ #if 0
#pragma qt_class(QtCompare)
#endif +/


extern(C++, "QtPrivate") {
alias CompareUnderlyingType = qint8;

// [cmp.categories.pre] / 1
enum /+ class +/ Ordering : CompareUnderlyingType
{
    Equal = 0,
    Equivalent = Equal,
    Less = -1,
    Greater = 1
}

enum /+ class +/ Uncomparable : CompareUnderlyingType
{
    Unordered = -127
}

} // namespace QtPrivate

// [cmp.partialord]
/// Binding for C++ class [QPartialOrdering](https://doc.qt.io/qt-6/qpartialordering.html).
extern(C++, class) struct QPartialOrdering
{
public:
    extern(D) static immutable(QPartialOrdering) Less = QPartialOrdering(Ordering.Less);
    extern(D) static immutable(QPartialOrdering) Equivalent = QPartialOrdering(Ordering.Equivalent);
    extern(D) static immutable(QPartialOrdering) Greater = QPartialOrdering(Ordering.Greater);
    extern(D) static immutable(QPartialOrdering) Unordered = QPartialOrdering(Uncomparable.Unordered);

    /+ friend constexpr bool operator==(QPartialOrdering p, QtPrivate::CompareAgainstLiteralZero) noexcept
    { return p.isOrdered() && p.m_order == 0; } +/
    /+ friend constexpr bool operator!=(QPartialOrdering p, QtPrivate::CompareAgainstLiteralZero) noexcept
    { return p.isOrdered() && p.m_order != 0; } +/
    /+ friend constexpr bool operator< (QPartialOrdering p, QtPrivate::CompareAgainstLiteralZero) noexcept
    { return p.isOrdered() && p.m_order <  0; } +/
    /+ friend constexpr bool operator<=(QPartialOrdering p, QtPrivate::CompareAgainstLiteralZero) noexcept
    { return p.isOrdered() && p.m_order <= 0; } +/
    /+ friend constexpr bool operator> (QPartialOrdering p, QtPrivate::CompareAgainstLiteralZero) noexcept
    { return p.isOrdered() && p.m_order >  0; } +/
    /+ friend constexpr bool operator>=(QPartialOrdering p, QtPrivate::CompareAgainstLiteralZero) noexcept
    { return p.isOrdered() && p.m_order >= 0; } +/

    /+ friend constexpr bool operator==(QtPrivate::CompareAgainstLiteralZero, QPartialOrdering p) noexcept
    { return p.isOrdered() && 0 == p.m_order; } +/
    /+ friend constexpr bool operator!=(QtPrivate::CompareAgainstLiteralZero, QPartialOrdering p) noexcept
    { return p.isOrdered() && 0 != p.m_order; } +/
    /+ friend constexpr bool operator< (QtPrivate::CompareAgainstLiteralZero, QPartialOrdering p) noexcept
    { return p.isOrdered() && 0 <  p.m_order; } +/
    /+ friend constexpr bool operator<=(QtPrivate::CompareAgainstLiteralZero, QPartialOrdering p) noexcept
    { return p.isOrdered() && 0 <= p.m_order; } +/
    /+ friend constexpr bool operator> (QtPrivate::CompareAgainstLiteralZero, QPartialOrdering p) noexcept
    { return p.isOrdered() && 0 >  p.m_order; } +/
    /+ friend constexpr bool operator>=(QtPrivate::CompareAgainstLiteralZero, QPartialOrdering p) noexcept
    { return p.isOrdered() && 0 >= p.m_order; } +/

    /+ friend constexpr bool operator==(QPartialOrdering p1, QPartialOrdering p2) noexcept
    { return p1.m_order == p2.m_order; } +/
    /+ friend constexpr bool operator!=(QPartialOrdering p1, QPartialOrdering p2) noexcept
    { return p1.m_order != p2.m_order; } +/

private:
    /+ explicit +/this(/+ QtPrivate:: +/Ordering order)/+ noexcept+/
    {
        this.m_order = static_cast!(/+ QtPrivate:: +/CompareUnderlyingType)(order);
    }
    /+ explicit +/this(/+ QtPrivate:: +/Uncomparable order)/+ noexcept+/
    {
        this.m_order = static_cast!(/+ QtPrivate:: +/CompareUnderlyingType)(order);
    }

    // instead of the exposition only is_ordered member in [cmp.partialord],
    // use a private function
    bool isOrdered()/+ noexcept+/
    { return m_order != static_cast!(/+ QtPrivate:: +/CompareUnderlyingType)(/+ QtPrivate:: +/Uncomparable.Unordered); }

    /+ QtPrivate:: +/CompareUnderlyingType m_order;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


