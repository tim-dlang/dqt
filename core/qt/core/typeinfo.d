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
module qt.core.typeinfo;

import std.traits;
import std.meta;

enum QTypeInfoFlags {
    Q_COMPLEX_TYPE = 0,
    Q_PRIMITIVE_TYPE = 0x1,
    Q_STATIC_TYPE = 0,
    Q_MOVABLE_TYPE = 0x2,               // ### Qt6: merge movable and relocatable once QList no longer depends on it
    Q_DUMMY_TYPE = 0x4,
    Q_RELOCATABLE_TYPE = 0x8
};
/*static foreach(name; __traits(allMembers, QTypeInfoFlags))
{
    mixin("enum " + name + " = QTypeInfoFlags." + name + ";");
}*/
enum Q_MOVABLE_TYPE = QTypeInfoFlags.Q_MOVABLE_TYPE;
enum Q_PRIMITIVE_TYPE = QTypeInfoFlags.Q_PRIMITIVE_TYPE;
enum Q_RELOCATABLE_TYPE = QTypeInfoFlags.Q_RELOCATABLE_TYPE;

template is_integral(T)
{
    enum is_integral = isIntegral!T || isBoolean!T || isSomeChar!T;
}

template qIsTrivial(T)
{
    enum qIsTrivial = is(T==enum) || is_integral!T;
}

template qIsRelocatable(T)
{
    enum qIsRelocatable = is(T==enum) || is_integral!T;
}

template QTypeInfo(T)
{
    static if(is(T == R*, R) || is(T == class))
    {
        enum isRelocatable = true;
        enum isComplex = false;
        enum isStatic = false;
    }
    else static if(is(T == int) || is(T == uint) || is(T == double))
    {
        enum isRelocatable = true;
        enum isComplex = false;
        enum isStatic = false;
    }
    else static if(is(T == enum))
    {
        enum isRelocatable = true;
        enum isComplex = false;
        enum isStatic = true;
    }
    else static if(getUDAs!(T, QTypeInfoFlags).length)
    {
        enum combinedFlags = (){
            QTypeInfoFlags r;
            foreach(flag; getUDAs!(T, QTypeInfoFlags))
            {
                r |= flag;
            }
            return r;
        }();
        enum isComplex = (combinedFlags & Q_PRIMITIVE_TYPE) == 0 && !qIsTrivial!T;
        enum isStatic = (combinedFlags & (Q_MOVABLE_TYPE | Q_PRIMITIVE_TYPE)) == 0;
        enum isRelocatable = !isStatic || ((combinedFlags) & Q_RELOCATABLE_TYPE) || qIsRelocatable!T;
    }
    else
    {
        enum isRelocatable = qIsRelocatable!T;
        enum isComplex = !qIsTrivial!T;
        enum isStatic = true;
    }
    enum isLarge = T.sizeof > (void*).sizeof;
    
    //pragma(msg, T.stringof, " ", isRelocatable, isComplex, isStatic, isLarge);
}
alias QTypeInfoQuery = QTypeInfo;
