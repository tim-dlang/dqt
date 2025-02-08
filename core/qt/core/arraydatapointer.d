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
module qt.core.arraydatapointer;
extern(C++):

import qt.config;
import qt.core.arraydata;
import qt.core.arraydataops;
import qt.core.global;
import qt.core.pair;
import qt.core.typeinfo;
import qt.helpers;

struct QArrayDataPointer(T)
{
private:
    alias Data = QTypedArrayData!(T);
    alias DataOps = QArrayDataOps!(T);

public:
/+    enum {
        pass_parameter_by_value =
                /+ std:: +/is_arithmetic!(T).value || /+ std:: +/is_pointer!(T).value || /+ std:: +/is_enum!(T).value
    }

    }+/

//    alias parameter_type = /+ std:: +/conditional!(pass_parameter_by_value, T, ref const(T)).type;
    alias parameter_type = T; // TODO: ref

    /+this()/+ noexcept+/
    {
        this.d = null;
        this.ptr = null;
        this.size = 0;
    }+/

    /*this(ref const(QArrayDataPointer) other)/+ noexcept+/
    {
        this.d = other.d;
        this.ptr = other.ptr;
        this.size = other.size;

        ref_();
    }*/
    this(this)
    {
        ref_();
    }

    this(Data* header, T* adata, qsizetype n = 0)/+ noexcept+/
    {
        this.d = header;
        this.ptr = adata;
        this.size = n;
    }

    /+ explicit +/this(qt.core.pair.QPair!(QTypedArrayData!(T)*, T*) adata, qsizetype n = 0)/+ noexcept+/
    {
        this.d = adata.first;
        this.ptr = adata.second;
        this.size = n;
    }

    static QArrayDataPointer fromRawData(const(T)* rawData, qsizetype length)/+ noexcept+/
    {
        (mixin(Q_ASSERT(q{rawData || !length})));
        return QArrayDataPointer( null, const_cast!(T*)(rawData), length) ;
    }

    /+ref QArrayDataPointer operator =(ref const(QArrayDataPointer) other)/+ noexcept+/
    {
        auto tmp = QArrayDataPointer(other);
        this.swap(tmp);
        return this;
    }+/

    /+ QArrayDataPointer(QArrayDataPointer &&other) noexcept
        : d(other.d), ptr(other.ptr), size(other.size)
    {
        other.d = nullptr;
        other.ptr = nullptr;
        other.size = 0;
    } +/

    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QArrayDataPointer) +/

    /*ref DataOps opUnary(string op)()/+ noexcept+/ if (op == "*")
    {
        return *static_cast!(DataOps*)(&this);
    }*/

    /+DataOps* operator ->()/+ noexcept+/
    {
        return static_cast!(DataOps*)(&this);
    }+/

    /*ref const(DataOps) opUnary(string op)() const/+ noexcept+/ if (op == "*")
    {
        return *static_cast!(const(DataOps)*)(&this);
    }*/

    /+const(DataOps)* operator ->() const/+ noexcept+/
    {
        return static_cast!(const(DataOps)*)(&this);
    }+/

    ~this()
    {
        if (!deref()) {
            DataOps.destroyAll(this);
            Data.deallocate(cast(QArrayData*)d);
        }
    }

    bool isNull() const/+ noexcept+/
    {
        return !ptr;
    }

    T* data()/+ noexcept+/ { return ptr; }
    const(T)* data() const/+ noexcept+/ { return ptr; }

    T* begin()/+ noexcept+/ { return data(); }
    T* end()/+ noexcept+/ { return data() + size; }
    const(T)* begin() const/+ noexcept+/ { return data(); }
    const(T)* end() const/+ noexcept+/ { return data() + size; }
    const(T)* constBegin() const/+ noexcept+/ { return data(); }
    const(T)* constEnd() const/+ noexcept+/ { return data() + size; }

    void swap(ref QArrayDataPointer other) /+ noexcept +/
    {
        import std.algorithm;
        std.algorithm.swap(d, other.d);
        std.algorithm.swap(ptr, other.ptr);
        std.algorithm.swap(size, other.size);
    }

    void clear()/+ noexcept(is_nothrow_destructible<T>.value)+/
    {
        QArrayDataPointer tmp;
        swap(tmp);
    }

    void detach()(QArrayDataPointer* old = null)
    {
        if (needsDetach())
            reallocateAndGrow(QArrayData.GrowthPosition.GrowsAtEnd, 0, old);
    }

    /*! \internal

        Reinterprets the data of this QArrayDataPointer to type X. It's the
        caller's responsibility to ensure that the data contents are valid and
        properly aligned, particularly if T and X are not trivial types (i.e,
        don't do that). The current size is kept and the allocated capacity is
        updated to account for the difference in the element type's size.

        This is used in QString::fromLatin1 to perform in-place conversion of
        QString to QByteArray.
    */
    /+ template <typename X> +/ /+ QArrayDataPointer<X> reinterpreted() &&
    {
        if (sizeof(T) != sizeof(X)) {
            Q_ASSERT(!d->isShared());
            d->alloc = d->alloc * sizeof(T) / sizeof(X);
        }
        auto od = reinterpret_cast<QTypedArrayData<X> *>(std::exchange(d, nullptr));
        auto optr = reinterpret_cast<X *>(std::exchange(ptr, nullptr));
        return { od, optr, std::exchange(size, 0) };
    } +/

    /*! \internal

        Detaches this (optionally) and grows to accommodate the free space for
        \a n elements at the required side. The side is determined from \a pos.

        \a data pointer can be provided when the caller knows that \a data
        points into range [this->begin(), this->end()). In case it is, *data
        would be updated so that it continues to point to the element it was
        pointing to before the data move. if \a data does not point into range,
        one can/should pass \c nullptr.

        Similarly to \a data, \a old, pointer to a default-constructed QADP, can
        be provided when the caller expects to e.g. copy the data from this to
        itself:
        \code
        QList<T> list(5);
        qsizetype pos = getArbitraryPos();
        list.insert(pos, list.begin(), list.end());
        \endcode

        The default rule would be: \a data and \a old must either both be valid
        pointers, or both equal to \c nullptr.
    */
    void detachAndGrow()(QArrayData.GrowthPosition where, qsizetype n, const(T)** data,
                           QArrayDataPointer* old)
    {
        const(bool) detach = needsDetach();
        bool readjusted = false;
        if (!detach) {
            if (!n || (where == QArrayData.GrowthPosition.GrowsAtBeginning && freeSpaceAtBegin() >= n)
                || (where == QArrayData.GrowthPosition.GrowsAtEnd && freeSpaceAtEnd() >= n))
                return;
            readjusted = tryReadjustFreeSpace(where, n, data);
            (mixin(Q_ASSERT(q{!readjusted
                         || (where == QArrayData.GrowthPosition.GrowsAtBeginning && freeSpaceAtBegin() >= n)
                         || (where == QArrayData.GrowthPosition.GrowsAtEnd && freeSpaceAtEnd() >= n)})));
        }

        if (!readjusted)
            reallocateAndGrow(where, n, old);
    }

    /*! \internal

        Reallocates to accommodate the free space for \a n elements at the
        required side. The side is determined from \a pos. Might also shrink
        when n < 0.
    */
    /+ Q_NEVER_INLINE +/ void reallocateAndGrow()(QArrayData.GrowthPosition where, qsizetype n,
                                              QArrayDataPointer* old = null)
    {
        static if (QTypeInfo!(T).isRelocatable && T.alignof <= 8/* /+ std:: +/max_align_t.alignof*/) {
            if (where == QArrayData.GrowthPosition.GrowsAtEnd && !old && !needsDetach() && n > 0) {
                DataOps.reallocate(this, constAllocatedCapacity() - freeSpaceAtEnd() + n, QArrayData.AllocationOption.Grow); // fast path
                return;
            }
        }

        auto dp = /*QArrayDataPointer*/(allocateGrow(this, n, where));
        if (n > 0)
            mixin(Q_CHECK_PTR(q{dp.data()}));
        if (where == QArrayData.GrowthPosition.GrowsAtBeginning) {
            (mixin(Q_ASSERT(q{dp.freeSpaceAtBegin() >= n})));
        } else {
            (mixin(Q_ASSERT(q{dp.freeSpaceAtEnd() >= n})));
        }
        if (size) {
            qsizetype toCopy = size;
            if (n < 0)
                toCopy += n;
            if (needsDetach() || old)
                DataOps.copyAppend(dp, begin(), begin() + toCopy);
            else
                DataOps.moveAppend(dp, begin(), begin() + toCopy);
            (mixin(Q_ASSERT(q{dp.size == toCopy})));
        }

        swap(dp);
        if (old)
            old.swap(dp);
    }

    /*! \internal

        Attempts to relocate [begin(), end()) to accommodate the free space for
        \a n elements at the required side. The side is determined from \a pos.

        Returns \c true if the internal data is moved. Returns \c false when
        there is no point in moving the data or the move is impossible. If \c
        false is returned, it is the responsibility of the caller to figure out
        how to accommodate the free space for \a n elements at \a pos.

        This function expects that certain preconditions are met, e.g. the
        detach is not needed, n > 0 and so on. This is intentional to reduce the
        number of if-statements when the caller knows that preconditions would
        be satisfied.

        \sa reallocateAndGrow
    */
    bool tryReadjustFreeSpace(QArrayData.GrowthPosition pos, qsizetype n, const(T)** data = null)
    {
        (mixin(Q_ASSERT(q{!this.needsDetach()})));
        (mixin(Q_ASSERT(q{n > 0})));
        (mixin(Q_ASSERT(q{(pos == QArrayData.GrowthPosition.GrowsAtEnd && this.freeSpaceAtEnd() < n)
                     || (pos == QArrayData.GrowthPosition.GrowsAtBeginning && this.freeSpaceAtBegin() < n)})));

        const(qsizetype) capacity = this.constAllocatedCapacity();
        const(qsizetype) freeAtBegin = this.freeSpaceAtBegin();
        const(qsizetype) freeAtEnd = this.freeSpaceAtEnd();

        qsizetype dataStartOffset = 0;
        // algorithm:
        //   a. GrowsAtEnd: relocate if space at begin AND size < (capacity * 2) / 3
        //      [all goes to free space at end]:
        //      new free space at begin = 0
        //
        //   b. GrowsAtBeginning: relocate if space at end AND size < capacity / 3
        //      [balance the free space]:
        //      new free space at begin = n + (total free space - n) / 2
        if (pos == QArrayData.GrowthPosition.GrowsAtEnd && freeAtBegin >= n
            && ((3 * this.size) < (2 * capacity))) {
            // dataStartOffset = 0; - done in declaration
        } else if (pos == QArrayData.GrowthPosition.GrowsAtBeginning && freeAtEnd >= n
                   && ((3 * this.size) < capacity)) {
            // total free space == capacity - size
            dataStartOffset = n + qMax(0, (capacity - this.size - n) / 2);
        } else {
            // nothing to do otherwise
            return false;
        }

        relocate(dataStartOffset - freeAtBegin, data);

        (mixin(Q_ASSERT(q{(pos == QArrayData.GrowthPosition.GrowsAtEnd && this.freeSpaceAtEnd() >= n)
                     || (pos == QArrayData.GrowthPosition.GrowsAtBeginning && this.freeSpaceAtBegin() >= n)})));
        return true;
    }

    /*! \internal

        Relocates [begin(), end()) by \a offset and updates \a data if it is not
        \c nullptr and points into [begin(), end()).
    */
    void relocate(qsizetype offset, const(T)** data = null)
    {
        //import qt.core.containertools_impl;

        T* res = this.ptr + offset;
        // /+ QtPrivate:: +/qt.core.containertools_impl.q_relocate_overlap_n(this.ptr, this.size, res);
        if (offset > 0) {
            foreach_reverse (i; 0 .. this.size) {
                this.ptr[i + offset] = this.ptr[i];
            }
        }
        else {
            foreach (i; 0 .. this.size) {
                this.ptr[i + offset] = this.ptr[i];
            }
        }
        // first update data pointer, then this->ptr
        if (data && *data >= this.begin() && *data < this.end())
            *data += offset;
        this.ptr = res;
    }

    // forwards from QArrayData
    qsizetype allocatedCapacity()/+ noexcept+/ { return d ? d.allocatedCapacity() : 0; }
    qsizetype constAllocatedCapacity() const/+ noexcept+/ { return d ? d.constAllocatedCapacity() : 0; }
    void ref_()/+ noexcept+/ { if (d) d.ref_(); }
    bool deref()/+ noexcept+/ { return !d || d.deref(); }
    bool isMutable() const/+ noexcept+/ { return cast(bool) (d); }
    bool isShared() const/+ noexcept+/ { return !d || d.isShared(); }
    bool isSharedWith(ref const(QArrayDataPointer) other) const/+ noexcept+/ { return d && d == other.d; }
    bool needsDetach() const/+ noexcept+/ { return !d || d.needsDetach(); }
    qsizetype detachCapacity(qsizetype newSize) const/+ noexcept+/ { return d ? d.detachCapacity(newSize) : newSize; }
    const(Data.ArrayOptions) flags() const/+ noexcept+/ { return d ? d.flags : Data.ArrayOptions.ArrayOptionDefault; }
    void setFlag(Data.ArrayOptions f)/+ noexcept+/ { assert(d); d.flags |= f; }
    void clearFlag(Data.ArrayOptions f)/+ noexcept+/ { if (d) d.flags &= ~f; }

    Data* d_ptr()/+ noexcept+/ { return d; }
    void setBegin(T* begin)/+ noexcept+/ { ptr = begin; }

    qsizetype freeSpaceAtBegin() const/+ noexcept+/
    {
        if (d is null)
            return 0;
        return this.ptr - Data.dataStart(cast(QArrayData*)d, Data.AlignmentDummy.alignof);
    }

    qsizetype freeSpaceAtEnd() const/+ noexcept+/
    {
        if (d is null)
            return 0;
        return d.constAllocatedCapacity() - freeSpaceAtBegin() - this.size;
    }

    // allocate and grow. Ensure that at the minimum requiredSpace is available at the requested end
    static QArrayDataPointer allocateGrow(ref const(QArrayDataPointer) from, qsizetype n, QArrayData.GrowthPosition position)
    {
        // calculate new capacity. We keep the free capacity at the side that does not have to grow
        // to avoid quadratic behavior with mixed append/prepend cases

        // use qMax below, because constAllocatedCapacity() can be 0 when using fromRawData()
        qsizetype minimalCapacity = qMax(from.size, from.constAllocatedCapacity()) + n;
        // subtract the free space at the side we want to allocate. This ensures that the total size requested is
        // the existing allocation at the other side + size + n.
        minimalCapacity -= (position == QArrayData.GrowthPosition.GrowsAtEnd) ? from.freeSpaceAtEnd() : from.freeSpaceAtBegin();
        qsizetype capacity = from.detachCapacity(minimalCapacity);
        const(bool) grows = capacity > from.constAllocatedCapacity();
        auto headerAndDataPtr = Data.allocate(capacity, grows ? QArrayData.AllocationOption.Grow : QArrayData.AllocationOption.KeepSize);
        auto header = headerAndDataPtr.first;
        auto dataPtr = headerAndDataPtr.second;
        const(bool) valid = header !is null && dataPtr !is null;
        if (!valid)
            return QArrayDataPointer(header, dataPtr);

        // Idea: * when growing backwards, adjust pointer to prepare free space at the beginning
        //       * when growing forward, adjust by the previous data pointer offset
        dataPtr += (position == QArrayData.GrowthPosition.GrowsAtBeginning)
                ? n + qMax(0, (header.alloc - from.size - n) / 2)
                : from.freeSpaceAtBegin();
        header.flags = from.flags();
        return QArrayDataPointer(header, dataPtr);
    }

    /+ friend bool operator==(const QArrayDataPointer &lhs, const QArrayDataPointer &rhs) noexcept
    {
        return lhs.data() == rhs.data() && lhs.size == rhs.size;
    } +/

    /+ friend bool operator!=(const QArrayDataPointer &lhs, const QArrayDataPointer &rhs) noexcept
    {
        return lhs.data() != rhs.data() || lhs.size != rhs.size;
    } +/

    Data* d = null;
    T* ptr = null;
    qsizetype size = 0;
}

/+ template <class T>
inline void swap(QArrayDataPointer<T> &p1, QArrayDataPointer<T> &p2) noexcept
{
    p1.swap(p2);
}

////////////////////////////////////////////////////////////////////////////////
//  Q_ARRAY_LITERAL

// The idea here is to place a (read-only) copy of header and array data in an
// mmappable portion of the executable (typically, .rodata section).

// Hide array inside a lambda
#define Q_ARRAY_LITERAL(Type, ...) \
    ([]() -> QArrayDataPointer<Type> { \
        static Type const data[] = { __VA_ARGS__ }; \
        return QArrayDataPointer<Type>::fromRawData(const_cast<Type *>(data), std::size(data)); \
    }()) +/
/**/

