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
module qt.core.arraydata;
extern(C++):

import qt.config;
import qt.core.basicatomic;
import qt.core.flags;
import qt.core.global;
import qt.core.pair;
import qt.helpers;


struct QArrayData
{
    enum AllocationOption {
        Grow,
        KeepSize
    }

    enum GrowthPosition {
        GrowsAtEnd,
        GrowsAtBeginning
    }

   enum ArrayOption {
        ArrayOptionDefault = 0,
        CapacityReserved     = 0x1  //!< the capacity was reserved by the user, try to keep it
    }
    /+ Q_DECLARE_FLAGS(ArrayOptions, ArrayOption) +/
alias ArrayOptions = QFlags!(ArrayOption);
    QBasicAtomicInt ref__;
    ArrayOptions flags;
    qsizetype alloc;

    qsizetype allocatedCapacity()/+ noexcept+/
    {
        return alloc;
    }

    qsizetype constAllocatedCapacity() const/+ noexcept+/
    {
        return alloc;
    }

    /// Returns true if sharing took place
    bool ref_()/+ noexcept+/
    {
        ref__.ref_();
        return true;
    }

    /// Returns false if deallocation is necessary
    bool deref()/+ noexcept+/
    {
        return ref__.deref();
    }

    bool isShared() const/+ noexcept+/
    {
        return ref__.loadRelaxed() != 1;
    }

    // Returns true if a detach is necessary before modifying the data
    // This method is intentionally not const: if you want to know whether
    // detaching is necessary, you should be in a non-const function already
    bool needsDetach() const/+ noexcept+/
    {
        return ref__.loadRelaxed() > 1;
    }

    qsizetype detachCapacity(qsizetype newSize) const/+ noexcept+/
    {
        if (flags & ArrayOption.CapacityReserved && newSize < constAllocatedCapacity())
            return constAllocatedCapacity();
        return newSize;
    }

    /+ [[nodiscard]] +/
    /+ #if defined(Q_CC_GNU) +/
        /+ __attribute__((__malloc__)) +/
    /+ #endif +/
        /+ Q_CORE_EXPORT +/ static void* allocate(QArrayData** pdata, qsizetype objectSize, qsizetype alignment,
                qsizetype capacity, AllocationOption option = AllocationOption.KeepSize)/+ noexcept+/;
    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ static qt.core.pair.QPair!(QArrayData*, void*) reallocateUnaligned(QArrayData* data, void* dataPointer,
                qsizetype objectSize, qsizetype newCapacity, AllocationOption option)/+ noexcept+/;
    /+ Q_CORE_EXPORT +/ static void deallocate(QArrayData* data, qsizetype objectSize,
                qsizetype alignment)/+ noexcept+/;
}
/+pragma(inline, true) QFlags!(QArrayData.ArrayOptions.enum_type) operator |(QArrayData.ArrayOptions.enum_type f1, QArrayData.ArrayOptions.enum_type f2)/+noexcept+/{return QFlags!(QArrayData.ArrayOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QArrayData.ArrayOptions.enum_type) operator |(QArrayData.ArrayOptions.enum_type f1, QFlags!(QArrayData.ArrayOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QArrayData.ArrayOptions.enum_type) operator &(QArrayData.ArrayOptions.enum_type f1, QArrayData.ArrayOptions.enum_type f2)/+noexcept+/{return QFlags!(QArrayData.ArrayOptions.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QArrayData.ArrayOptions.enum_type) operator &(QArrayData.ArrayOptions.enum_type f1, QFlags!(QArrayData.ArrayOptions.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) void operator +(QArrayData.ArrayOptions.enum_type f1, QArrayData.ArrayOptions.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QArrayData.ArrayOptions.enum_type f1, QFlags!(QArrayData.ArrayOptions.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QArrayData.ArrayOptions.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QArrayData.ArrayOptions.enum_type f1, QArrayData.ArrayOptions.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QArrayData.ArrayOptions.enum_type f1, QFlags!(QArrayData.ArrayOptions.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QArrayData.ArrayOptions.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) QIncompatibleFlag operator |(QArrayData.ArrayOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+pragma(inline, true) void operator +(int f1, QArrayData.ArrayOptions.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QArrayData.ArrayOptions.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QArrayData.ArrayOptions.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QArrayData.ArrayOptions.enum_type f1, int f2)/+noexcept+/;+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QArrayData::ArrayOptions) +/
struct QTypedArrayData(T)
{
    QArrayData base0;
    alias base0 this;
    alias AllocationOption = QArrayData.AllocationOption;
    struct AlignmentDummy { QArrayData header; T data; }

    /+ [[nodiscard]] +/ static qt.core.pair.QPair!(QTypedArrayData*, T*) allocate(qsizetype capacity, AllocationOption option = QArrayData.AllocationOption.KeepSize)
    {
        static assert(QTypedArrayData.sizeof == QArrayData.sizeof);
        QArrayData* d;
        void* result = QArrayData.allocate(&d, T.sizeof, AlignmentDummy.alignof, capacity, option);
        static if ((configValue!"__has_builtin___builtin_assume_aligned" && defined!"__has_builtin___builtin_assume_aligned"))
        {
            result = __builtin_assume_aligned(result, /+ Q_ALIGNOF +/AlignmentDummy.alignof);
        }
        return qMakePair(static_cast!(QTypedArrayData*)(d), static_cast!(T*)(result));
    }

    static qt.core.pair.QPair!(QTypedArrayData*, T*)
        reallocateUnaligned(QTypedArrayData* data, T* dataPointer, qsizetype capacity, AllocationOption option)
    {
        static assert(QTypedArrayData.sizeof == QArrayData.sizeof);
        qt.core.pair.QPair!(QArrayData*, void*) pair =
                QArrayData.reallocateUnaligned(cast(QArrayData*)data, dataPointer, T.sizeof, capacity, option);
        return qMakePair(static_cast!(QTypedArrayData*)(pair.first), static_cast!(T*)(pair.second));
    }

    static void deallocate(QArrayData* data)/+ noexcept+/
    {
        static assert(QTypedArrayData.sizeof == QArrayData.sizeof);
        QArrayData.deallocate(data, T.sizeof, AlignmentDummy.alignof);
    }

    static T* dataStart(QArrayData* data, qsizetype alignment)/+ noexcept+/
    {
        // Alignment is a power of two
        (mixin(Q_ASSERT(q{alignment >= qsizetype(QArrayData.alignof) && !(alignment & (alignment - 1))})));
        void* start =  reinterpret_cast!(void*)(
            (cast(quintptr)(data) + QArrayData.sizeof + alignment - 1) & ~(alignment - 1));
        return static_cast!(T*)(start);
    }
}

extern(C++, "QtPrivate") {
struct /+ Q_CORE_EXPORT +/ QContainerImplHelper
{
    enum CutResult { Null, Empty, Full, Subset }
    /+ static CutResult mid(qsizetype originalLength, qsizetype* _position, qsizetype* _length)
    {
        ref qsizetype position = *_position;
        ref qsizetype length = *_length;
        if (position > originalLength) {
            position = 0;
            length = 0;
            return CutResult.Null;
        }

        if (position < 0) {
            if (length < 0 || length + position >= originalLength) {
                position = 0;
                length = originalLength;
                return CutResult.Full;
            }
            if (length + position <= 0) {
                position = length = 0;
                return CutResult.Null;
            }
            length += position;
            position = 0;
        } else if (size_t(length) > size_t(originalLength - position)) {
            length = originalLength - position;
        }

        if (position == 0 && length == originalLength)
            return CutResult.Full;

        return length > 0 ? CutResult.Subset : CutResult.Empty;
    } +/
}
}

