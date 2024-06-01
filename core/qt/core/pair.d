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
module qt.core.pair;
extern(C++):

import qt.config;
import qt.helpers;

/+ #if 0
#pragma qt_class(QPair)
#endif +/

version (Android)
{
    import core.internal.traits : AliasSeq;
    enum StdNamespace = AliasSeq!("std", "__ndk1");
}
else
{
    import core.stdcpp.xutility : StdNamespace;
}

extern(C++, (StdNamespace)) struct pair(T1, T2)
{
    alias first_type = T1;
    alias second_type = T2;
    T1 first;
    T2 second;
}

alias QPair(T1, T2) = /+ std:: +/pair!(T1, T2);

/+ template <typename T1, typename T2>
constexpr decltype(auto) qMakePair(T1 &&value1, T2 &&value2)
    noexcept(noexcept(std::make_pair(std::forward<T1>(value1), std::forward<T2>(value2))))
{
    return std::make_pair(std::forward<T1>(value1), std::forward<T2>(value2));
}

template<class T1, class T2>
class QTypeInfo<std::pair<T1, T2>> : public QTypeInfoMerger<std::pair<T1, T2>, T1, T2> {}; +/

QPair!(T1, T2) qMakePair(T1, T2)(T1 value1, T2 value2)
{
    return QPair!(T1, T2)(value1, value2);
}
