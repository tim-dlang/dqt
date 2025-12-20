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
module qt.core.arraydataops;
extern(C++):

import qt.config;
import qt.core.arraydata;
import qt.core.arraydatapointer;
import qt.core.global;
import qt.core.typeinfo;
import qt.helpers;


extern(C++, "QtPrivate") {

template QPodArrayOps(T)
{
//    public QArrayDataPointer!(T) base0;
//    alias base0 this;
//    static assert (/+ std:: +/is_nothrow_destructible_v!(T), "Types with throwing destructors are not supported in Qt containers.");

protected:
    alias Data = QTypedArrayData!(T);
    alias DataPointer = QArrayDataPointer!(T);

public:
    alias parameter_type = QArrayDataPointer!(T).parameter_type;

    void appendInitialize()(ref QArrayDataPointer!T this_, qsizetype newSize)/+ noexcept+/
    {
        (mixin(Q_ASSERT(q{this_.isMutable()})));
        (mixin(Q_ASSERT(q{!this_.isShared()})));
        (mixin(Q_ASSERT(q{newSize > this_.size})));
        (mixin(Q_ASSERT(q{newSize - this_.size <= this_.freeSpaceAtEnd()})));

        T* where = this_.end();
        this_.size = newSize;
        const(T)* e = this_.end();
        while (where != e)
            *where++ = T.init;
    }

    void copyAppend()(ref QArrayDataPointer!T this_, const(T)* b, const(T)* e)/+ noexcept+/
    {
        import core.stdc.string;

        (mixin(Q_ASSERT(q{this_.isMutable() || b == e})));
        (mixin(Q_ASSERT(q{!this_.isShared() || b == e})));
        (mixin(Q_ASSERT(q{b <= e})));
        (mixin(Q_ASSERT(q{(e - b) <= this_.freeSpaceAtEnd()})));

        if (b == e)
            return;

        memcpy(static_cast!(void*)(this_.end()), static_cast!(const(void)*)(b), (e - b) * T.sizeof);
        this_.size += (e - b);
    }

    void copyAppend()(ref QArrayDataPointer!T this_, qsizetype n, parameter_type t)/+ noexcept+/
    {
        (mixin(Q_ASSERT(q{!this_.isShared() || n == 0})));
        (mixin(Q_ASSERT(q{this_.freeSpaceAtEnd() >= n})));
        if (!n)
            return;

        T* where = this_.end();
        this_.size += qsizetype(n);
        while (n--)
            *where++ = t;
    }

    void moveAppend()(ref QArrayDataPointer!T this_, T* b, T* e)/+ noexcept+/
    {
        copyAppend(this_, b, e);
    }

    void truncate()(ref QArrayDataPointer!T this_, size_t newSize)/+ noexcept+/
    {
        (mixin(Q_ASSERT(q{this_.isMutable()})));
        (mixin(Q_ASSERT(q{!this_.isShared()})));
        (mixin(Q_ASSERT(q{newSize < size_t(this_.size)})));

        this_.size = qsizetype(newSize);
    }

    void destroyAll()(ref QArrayDataPointer!T this_)/+ noexcept+/ // Call from destructors, ONLY!
    {
        (mixin(Q_ASSERT(q{this_.d})));
        (mixin(Q_ASSERT(q{this_.d.ref__.loadRelaxed() == 0})));

        // As this is to be called only from destructor, it doesn't need to be
        // exception safe; size not updated.
    }

    T* createHole()(ref QArrayDataPointer!T this_, QArrayData.GrowthPosition pos, qsizetype where, qsizetype n)
    {
        import core.stdc.string;

        (mixin(Q_ASSERT(q{(pos == QArrayData.GrowthPosition.GrowsAtBeginning && n <= this_.freeSpaceAtBegin()) ||
                     (pos == QArrayData.GrowthPosition.GrowsAtEnd && n <= this_.freeSpaceAtEnd())})));

        T* insertionPoint = this_.ptr + where;
        if (pos == QArrayData.GrowthPosition.GrowsAtEnd) {
            if (where < this_.size)
                memmove(static_cast!(void*)(insertionPoint + n), static_cast!(void*)(insertionPoint), (this_.size - where) * T.sizeof);
        } else {
            (mixin(Q_ASSERT(q{where == 0})));
            this_.ptr -= n;
            insertionPoint -= n;
        }
        this_.size += n;
        return insertionPoint;
    }

    void insert()(ref QArrayDataPointer!T this_, qsizetype i, const(T)* data, qsizetype n)
    {
        import core.stdc.string;

        Data.GrowthPosition pos = Data.GrowthPosition.GrowsAtEnd;
        if (this_.size != 0 && i == 0)
            pos = Data.GrowthPosition.GrowsAtBeginning;

        DataPointer oldData;
        this_.detachAndGrow(pos, n, &data, &oldData);
        (mixin(Q_ASSERT(q{(pos == Data.GrowthPosition.GrowsAtBeginning && this_.freeSpaceAtBegin() >= n) ||
                     (pos == Data.GrowthPosition.GrowsAtEnd && this_.freeSpaceAtEnd() >= n)})));

        T* where = createHole(this_, pos, i, n);
        memcpy(static_cast!(void*)(where), static_cast!(const(void)*)(data), n * T.sizeof);
    }

    void insert()(ref QArrayDataPointer!T this_, qsizetype i, qsizetype n, parameter_type t)
    {
        auto copy = /*T*/(t);

        Data.GrowthPosition pos = Data.GrowthPosition.GrowsAtEnd;
        if (this_.size != 0 && i == 0)
            pos = Data.GrowthPosition.GrowsAtBeginning;

        this_.detachAndGrow(pos, n, null, null);
        (mixin(Q_ASSERT(q{(pos == Data.GrowthPosition.GrowsAtBeginning && this_.freeSpaceAtBegin() >= n) ||
                     (pos == Data.GrowthPosition.GrowsAtEnd && this_.freeSpaceAtEnd() >= n)})));

        T* where = createHole(this_, pos, i, n);
        while (n--)
            *where++ = copy;
    }

    /+ template<typename... Args> +/
    void emplace(Args...)(ref QArrayDataPointer!T this_, qsizetype i, auto ref Args /+ && +/ args)
    {
        import core.lifetime;

        bool detach = this_.needsDetach();
        if (!detach) {
            if (i == this_.size && this_.freeSpaceAtEnd()) {
                core.lifetime.emplace!T(this_.end(), args /+ /+ std:: +/forward!(Args)(args)...+/);
                ++this_.size;
                return;
            }
            if (i == 0 && this_.freeSpaceAtBegin()) {
                core.lifetime.emplace!T(this_.begin() - 1, args /+ /+ std:: +/forward!(Args)(args)...+/);
                --this_.ptr;
                ++this_.size;
                return;
            }
        }
        static if (Args.length == 1 && is(const(Args[0]) == const(T)))
            auto tmp = args[0];
        else
            auto tmp = T(args /+ /+ std:: +/forward!(Args)(args)...+/);
        QArrayData.GrowthPosition pos = QArrayData.GrowthPosition.GrowsAtEnd;
        if (this_.size != 0 && i == 0)
            pos = QArrayData.GrowthPosition.GrowsAtBeginning;

        this_.detachAndGrow(pos, 1, null, null);

        T* where = createHole(this_, pos, i, 1);
        core.lifetime.emplace!T(where, /+ std:: +//+move+/(tmp));
    }

    void erase()(ref QArrayDataPointer!T this_, T* b, qsizetype n)
    {
        import core.stdc.string;

        T* e = b + n;
        (mixin(Q_ASSERT(q{this_.isMutable()})));
        (mixin(Q_ASSERT(q{b < e})));
        (mixin(Q_ASSERT(q{b >= this_.begin() && b < this_.end()})));
        (mixin(Q_ASSERT(q{e > this_.begin() && e <= this_.end()})));

        // Comply with std::vector::erase(): erased elements and all after them
        // are invalidated. However, erasing from the beginning effectively
        // means that all iterators are invalidated. We can use this_ freedom to
        // erase by moving towards the end.
        if (b == this_.begin() && e != this_.end()) {
            this_.ptr = e;
        } else if (e != this_.end()) {
            memmove(static_cast!(void*)(b), static_cast!(void*)(e),
                      (static_cast!(T*)(this_.end()) - e) * T.sizeof);
        }
        this_.size -= n;
    }

    void eraseFirst()(ref QArrayDataPointer!T this_)/+ noexcept+/
    {
        (mixin(Q_ASSERT(q{this_.isMutable()})));
        (mixin(Q_ASSERT(q{this_.size})));
        ++this_.ptr;
        --this_.size;
    }

    void eraseLast()(ref QArrayDataPointer!T this_)/+ noexcept+/
    {
        (mixin(Q_ASSERT(q{this_.isMutable()})));
        (mixin(Q_ASSERT(q{this_.size})));
        --this_.size;
    }

    void assign()(ref QArrayDataPointer!T this_, T* b, T* e, parameter_type t)/+ noexcept+/
    {
        import core.stdc.string;

        (mixin(Q_ASSERT(q{b <= e})));
        (mixin(Q_ASSERT(q{b >= this_.begin() && e <= this_.end()})));

        while (b != e)
            memcpy(static_cast!(void*)(b++), static_cast!(const(void)*)(&t), T.sizeof);
    }

    bool compare()(const ref QArrayDataPointer!T this_, const(T)* begin1, const(T)* begin2, size_t n)
    {
        import core.stdc.string;

        // only use memcmp for fundamental types or pointers.
        // Other types could have padding in the data structure or custom comparison
        // operators that would break the comparison using memcmp
        static if (false /*TODO: QArrayDataPointer!(T).pass_parameter_by_value*/) {
            return memcmp(begin1, begin2, n * T.sizeof) == 0;
        } else {
            const(T)* end1 = begin1 + n;
            while (begin1 != end1) {
                if (*begin1 == *begin2) {
                    ++begin1;
                    ++begin2;
                } else {
                    return false;
                }
            }
            return true;
        }
    }

    void reallocate()(ref QArrayDataPointer!T this_, qsizetype alloc, QArrayData.AllocationOption option)
    {
        auto pair = Data.reallocateUnaligned(this_.d, this_.ptr, alloc, option);
        mixin(Q_CHECK_PTR(q{pair.second}));
        (mixin(Q_ASSERT(q{pair.first !is null})));
        this_.d = pair.first;
        this_.ptr = pair.second;
    }
}

template QGenericArrayOps(T)
{
//    public QArrayDataPointer!(T) base0;
//    alias base0 this_;
    //static assert (/+ std:: +/is_nothrow_destructible_v!(T), "Types with throwing destructors are not supported in Qt containers.");

protected:
    alias Data = QTypedArrayData!(T);
    alias DataPointer = QArrayDataPointer!(T);

public:
    alias parameter_type = QArrayDataPointer!(T).parameter_type;

    void appendInitialize()(ref QArrayDataPointer!T this_, qsizetype newSize)
    {
        import core.lifetime;

        (mixin(Q_ASSERT(q{this_.isMutable()})));
        (mixin(Q_ASSERT(q{!this_.isShared()})));
        (mixin(Q_ASSERT(q{newSize > this_.size})));
        (mixin(Q_ASSERT(q{newSize - this_.size <= this_.freeSpaceAtEnd()})));

        T*/+ const +/  b = this_.begin();
        do {
            core.lifetime.emplace!T(b + this_.size);
        } while (++this_.size != newSize);
    }

    void copyAppend()(ref QArrayDataPointer!T this_, const(T)* b, const(T)* e)
    {
        import core.lifetime;

        (mixin(Q_ASSERT(q{this_.isMutable() || b == e})));
        (mixin(Q_ASSERT(q{!this_.isShared() || b == e})));
        (mixin(Q_ASSERT(q{b <= e})));
        (mixin(Q_ASSERT(q{(e - b) <= this_.freeSpaceAtEnd()})));

        if (b == e) // short-cut and handling the case b and e == nullptr
            return;

        T* data = this_.begin();
        while (b < e) {
            static if (is(T == struct) && __traits(hasCopyConstructor, T)) {
                // Workaround for https://issues.dlang.org/show_bug.cgi?id=22766
                import core.stdc.string;
                memset((data + this_.size), 0, T.sizeof);
                (*cast(T*)(data + this_.size)).__ctor(*cast(T*)b);
            } else {
                core.lifetime.copyEmplace!T(*cast(T*)b, *cast(T*)(data + this_.size));
            }
            ++b;
            ++this_.size;
        }
    }

    void copyAppend()(ref QArrayDataPointer!T this_, qsizetype n, parameter_type t)
    {
        import core.lifetime;

        (mixin(Q_ASSERT(q{!this_.isShared() || n == 0})));
        (mixin(Q_ASSERT(q{this_.freeSpaceAtEnd() >= n})));
        if (!n)
            return;

        T* data = this_.begin();
        while (n--) {
            core.lifetime.copyEmplace!T(*cast(T*)&t, *(data + this_.size));
            ++this_.size;
        }
    }

    void moveAppend()(ref QArrayDataPointer!T this_, T* b, T* e)
    {
        import core.lifetime;

        (mixin(Q_ASSERT(q{this_.isMutable() || b == e})));
        (mixin(Q_ASSERT(q{!this_.isShared() || b == e})));
        (mixin(Q_ASSERT(q{b <= e})));
        (mixin(Q_ASSERT(q{(e - b) <= this_.freeSpaceAtEnd()})));

        if (b == e)
            return;

        T* data = this_.begin();
        while (b < e) {
            core.lifetime.emplace!T(data + this_.size, /+ std:: +/move(*b));
            ++b;
            ++this_.size;
        }
    }

    void truncate()(ref QArrayDataPointer!T this_, size_t newSize)
    {
        (mixin(Q_ASSERT(q{this_.isMutable()})));
        (mixin(Q_ASSERT(q{!this_.isShared()})));
        (mixin(Q_ASSERT(q{newSize < size_t(this_.size)})));

        for (auto it = this_.begin() + newSize; it != this_.end(); it++)
            destroy(*it);
        this_.size = newSize;
    }

    void destroyAll()(ref QArrayDataPointer!T this_) // Call from destructors, ONLY
    {
        (mixin(Q_ASSERT(q{this_.d})));
        // As this_ is to be called only from destructor, it doesn't need to be
        // exception safe; size not updated.

        (mixin(Q_ASSERT(q{this_.d.ref__.loadRelaxed() == 0})));

        for (auto it = this_.begin(); it != this_.end(); it++)
            destroy(*it);
    }

    struct Inserter
    {
        QArrayDataPointer!(T)* data;
        T* begin;
        qsizetype size;

        qsizetype sourceCopyConstruct = 0; qsizetype nSource = 0; qsizetype move = 0; qsizetype sourceCopyAssign = 0;
        T* end = null; T* last = null; T* where = null;

        this(QArrayDataPointer!(T)* d)
        {
            this.data = d;

            begin = d.ptr;
            size = d.size;
        }
        ~this() {
            data.ptr = begin;
            data.size = size;
        }
        /+ Q_DISABLE_COPY(Inserter) +/
@disable this(this);
/+@disable this(ref const(Inserter));+//+@disable ref Inserter operator =(ref const(Inserter));+/
        void setup()(qsizetype pos, qsizetype n)
        {
            end = begin + size;
            last = end - 1;
            where = begin + pos;
            qsizetype dist = size - pos;
            sourceCopyConstruct = 0;
            nSource = n;
            move = n - dist; // smaller 0
            sourceCopyAssign = n;
            if (n > dist) {
                sourceCopyConstruct = n - dist;
                move = 0;
                sourceCopyAssign -= sourceCopyConstruct;
            }
        }

        void insert()(qsizetype pos, const(T)* source, qsizetype n)
        {
            import core.lifetime;

            qsizetype oldSize = size;
            /+ Q_UNUSED(oldSize) +/

            setup(pos, n);

            // first create new elements at the end, by copying from elements
            // to be inserted (if they extend past the current end of the array)
            for (qsizetype i = 0; i != sourceCopyConstruct; ++i) {
                core.lifetime.copyEmplace!T(*cast(T*)&source[nSource - sourceCopyConstruct + i], *(end + i));
                ++size;
            }
            (mixin(Q_ASSERT(q{size <= oldSize + n})));

            // now move construct new elements at the end from existing elements inside
            // the array.
            for (qsizetype i = sourceCopyConstruct; i != nSource; ++i) {
                core.lifetime.emplace!T(end + i, /+ std:: +//*move*/(*(end + i - nSource)));
                ++size;
            }
            // array has the new size now!
            (mixin(Q_ASSERT(q{size == oldSize + n})));

            // now move assign existing elements towards the end
            for (qsizetype i = 0; i != move; --i)
                last[i] = /+ std:: +//*move*/(last[i - nSource]);

            // finally copy the remaining elements from source over
            for (qsizetype i = 0; i != sourceCopyAssign; ++i)
                where[i] = *cast(T*)&source[i];
        }

        void insert()(qsizetype pos, ref const(T) t, qsizetype n)
        {
            import core.lifetime;

            const(qsizetype) oldSize = size;
            /+ Q_UNUSED(oldSize) +/

            setup(pos, n);

            // first create new elements at the end, by copying from elements
            // to be inserted (if they extend past the current end of the array)
            for (qsizetype i = 0; i != sourceCopyConstruct; ++i) {
                core.lifetime.copyEmplace!T(*cast(T*)&t, *(end + i));
                ++size;
            }
            (mixin(Q_ASSERT(q{size <= oldSize + n})));

            // now move construct new elements at the end from existing elements inside
            // the array.
            for (qsizetype i = sourceCopyConstruct; i != nSource; ++i) {
                core.lifetime.emplace!T(end + i, /+ std:: +//*move*/(*(end + i - nSource)));
                ++size;
            }
            // array has the new size now!
            (mixin(Q_ASSERT(q{size == oldSize + n})));

            // now move assign existing elements towards the end
            for (qsizetype i = 0; i != move; --i)
                last[i] = /+ std:: +//*move*/(last[i - nSource]);

            // finally copy the remaining elements from source over
            for (qsizetype i = 0; i != sourceCopyAssign; ++i)
                where[i] = *cast(T*)&t;
        }

        void insertOne()(qsizetype pos, auto ref T /+ && +/ t)
        {
            import core.lifetime;

            setup(pos, 1);

            if (sourceCopyConstruct) {
                (mixin(Q_ASSERT(q{QGenericArrayOps.Inserter.sourceCopyConstruct == 1})));
                core.lifetime.emplace!T(end, /+ std:: +/move(t));
                ++size;
            } else {
                // create a new element at the end by move constructing one existing element
                // inside the array.
                core.lifetime.emplace!T(end, /+ std:: +/move(*(end - 1)));
                ++size;

                // now move assign existing elements towards the end
                for (qsizetype i = 0; i != move; --i)
                    last[i] = /+ std:: +/move(last[i - 1]);

                // and move the new item into place
                *where = /+ std:: +/move(t);
            }
        }
    }

    void insert()(ref QArrayDataPointer!T this_, qsizetype i, const(T)* data, qsizetype n)
    {
        import core.lifetime;

        const(bool) growsAtBegin = this_.size != 0 && i == 0;
        const pos = growsAtBegin ? Data.GrowthPosition.GrowsAtBeginning : Data.GrowthPosition.GrowsAtEnd;

        DataPointer oldData;
        this_.detachAndGrow(pos, n, &data, &oldData);
        (mixin(Q_ASSERT(q{(pos == Data.GrowthPosition.GrowsAtBeginning && this_.freeSpaceAtBegin() >= n) ||
                     (pos == Data.GrowthPosition.GrowsAtEnd && this_.freeSpaceAtEnd() >= n)})));

        if (growsAtBegin) {
            // copy construct items in reverse order at the begin
            (mixin(Q_ASSERT(q{this_.freeSpaceAtBegin() >= n})));
            while (n) {
                --n;
                core.lifetime.copyEmplace!T(*cast(T*)&data[n], *(this_.begin() - 1));
                --this_.ptr;
                ++this_.size;
            }
        } else {
            Inserter(&this_).insert(i, data, n);
        }
    }

    void insert()(ref QArrayDataPointer!T this_, qsizetype i, qsizetype n, parameter_type t)
    {
        import core.lifetime;

        auto copy = /*T*/(t);

        const(bool) growsAtBegin = this_.size != 0 && i == 0;
        const pos = growsAtBegin ? Data.GrowthPosition.GrowsAtBeginning : Data.GrowthPosition.GrowsAtEnd;

        this_.detachAndGrow(pos, n, null, null);
        (mixin(Q_ASSERT(q{(pos == Data.GrowthPosition.GrowsAtBeginning && this_.freeSpaceAtBegin() >= n) ||
                     (pos == Data.GrowthPosition.GrowsAtEnd && this_.freeSpaceAtEnd() >= n)})));

        if (growsAtBegin) {
            // copy construct items in reverse order at the begin
            (mixin(Q_ASSERT(q{this_.freeSpaceAtBegin() >= n})));
            while (n--) {
                core.lifetime.emplace!T(this_.begin() - 1, copy);
                --this_.ptr;
                ++this_.size;
            }
        } else {
            Inserter(&this_).insert(i, copy, n);
        }
    }

    /+ template<typename... Args> +/
    void emplace(Args)(ref QArrayDataPointer!T this_, qsizetype i, auto ref Args /+ && +/ args)
    {
        import core.lifetime;

        bool detach = this_.needsDetach();
        if (!detach) {
            if (i == this_.size && this_.freeSpaceAtEnd()) {
                core.lifetime.emplace!T(this_.end(), args /+ /+ std:: +/forward!(Args)(args)...+/);
                ++this_.size;
                return;
            }
            if (i == 0 && this_.freeSpaceAtBegin()) {
                core.lifetime.emplace!T(this_.begin() - 1, args /+ /+ std:: +/forward!(Args)(args)...+/);
                --this_.ptr;
                ++this_.size;
                return;
            }
        }
        auto tmp = T(args /+ /+ std:: +/forward!(Args)(args)...+/);
        const(bool) growsAtBegin = this_.size != 0 && i == 0;
        const pos = growsAtBegin ? Data.GrowthPosition.GrowsAtBeginning : Data.GrowthPosition.GrowsAtEnd;

        this_.detachAndGrow(pos, 1, null, null);

        if (growsAtBegin) {
            (mixin(Q_ASSERT(q{this_.freeSpaceAtBegin()})));
            core.lifetime.emplace!T(this_.begin() - 1, /+ std:: +//+move+/(tmp));
            --this_.ptr;
            ++this_.size;
        } else {
            Inserter(&this_).insertOne(i, /+ std:: +//+move+/(tmp));
        }
    }

    void erase()(ref QArrayDataPointer!T this_, T* b, qsizetype n)
    {
        T* e = b + n;
        (mixin(Q_ASSERT(q{this_.isMutable()})));
        (mixin(Q_ASSERT(q{b < e})));
        (mixin(Q_ASSERT(q{b >= this_.begin() && b < this_.end()})));
        (mixin(Q_ASSERT(q{e > this_.begin() && e <= this_.end()})));

        // Comply with std::vector::erase(): erased elements and all after them
        // are invalidated. However, erasing from the beginning effectively
        // means that all iterators are invalidated. We can use this_ freedom to
        // erase by moving towards the end.
        if (b == this_.begin() && e != this_.end()) {
            this_.ptr = e;
        } else {
            const(T)*/+ const +/  end = this_.end();

            // move (by assignment) the elements from e to end
            // onto b to the new end
            while (e != end) {
                *b = /+ std:: +//*move*/(*e);
                ++b;
                ++e;
            }
        }
        this_.size -= n;
        for (auto it = b; it != e; it++)
            destroy(*it);
    }

    void eraseFirst()(ref QArrayDataPointer!T this_)/+ noexcept+/
    {
        (mixin(Q_ASSERT(q{this_.isMutable()})));
        (mixin(Q_ASSERT(q{this_.size})));
        destroy!false(*this_.begin());
        ++this_.ptr;
        --this_.size;
    }

    void eraseLast()(ref QArrayDataPointer!T this_)/+ noexcept+/
    {
        (mixin(Q_ASSERT(q{this_.isMutable()})));
        (mixin(Q_ASSERT(q{this_.size})));
        destroy!false(*this_.end() - 1);
        --this_.size;
    }


    void assign()(ref QArrayDataPointer!T this_, T* b, T* e, parameter_type t)
    {
        (mixin(Q_ASSERT(q{b <= e})));
        (mixin(Q_ASSERT(q{b >= this_.begin() && e <= this_.end()})));

        while (b != e)
            *b++ = t;
    }

    bool compare()(const ref QArrayDataPointer!T this_, const(T)* begin1, const(T)* begin2, size_t n)
    {
        const(T)* end1 = begin1 + n;
        while (begin1 != end1) {
            if (*begin1 == *begin2) {
                ++begin1;
                ++begin2;
            } else {
                return false;
            }
        }
        return true;
    }
}

template QMovableArrayOps(T)
{
    //QGenericArrayOps!(T) base0;
    //alias base0 this_;
    //static assert (/+ std:: +/is_nothrow_destructible_v!(T), "Types with throwing destructors are not supported in Qt containers.");

protected:
    alias Data = QTypedArrayData!(T);
    alias DataPointer = QArrayDataPointer!(T);

public:
    alias copyAppend = QGenericArrayOps!T.copyAppend;
    alias moveAppend = QGenericArrayOps!T.moveAppend;
    alias truncate = QGenericArrayOps!T.truncate;
    alias destroyAll = QGenericArrayOps!T.destroyAll;
    alias assign = QGenericArrayOps!T.assign;
    alias compare = QGenericArrayOps!T.compare;
    alias parameter_type = QGenericArrayOps!T.parameter_type;
    alias appendInitialize = QGenericArrayOps!T.appendInitialize;

    struct Inserter
    {
        QArrayDataPointer!(T)* data;
        T* displaceFrom;
        T* displaceTo;
        qsizetype nInserts = 0;
        qsizetype bytes;

        this(QArrayDataPointer!(T)* d)
        {
            this.data = d;
        }
        ~this() {
            import core.stdc.string;

            static if (true /* !/+ std:: +/is_nothrow_copy_constructible_v!(T)*/) {
                if (displaceFrom != displaceTo) {
                    memmove(static_cast!(void*)(displaceFrom), static_cast!(void*)(displaceTo), bytes);
                    nInserts -= qAbs(displaceFrom - displaceTo);
                }
            }
            data.size += nInserts;
        }
        /+ Q_DISABLE_COPY(Inserter) +/
@disable this(this);
/+@disable this(ref const(Inserter));+//+@disable ref Inserter operator =(ref const(Inserter));+/
        T* displace()(qsizetype pos, qsizetype n)
        {
            import core.stdc.string;

            nInserts = n;
            T* insertionPoint = data.ptr + pos;
            displaceFrom = data.ptr + pos;
            displaceTo = displaceFrom + n;
            bytes = data.size - pos;
            bytes *= T.sizeof;
            memmove(static_cast!(void*)(displaceTo), static_cast!(void*)(displaceFrom), bytes);
            return insertionPoint;
        }

        void insert()(qsizetype pos, const(T)* source, qsizetype n)
        {
            import core.lifetime;

            T* where = displace(pos, n);

            while (n--) {
                core.lifetime.copyEmplace!T(*cast(T*)source, *where);
                ++where;
                ++source;
                ++displaceFrom;
            }
        }

        void insert()(qsizetype pos, ref const(T) t, qsizetype n)
        {
            import core.lifetime;

            T* where = displace(pos, n);

            while (n--) {
                core.lifetime.copyEmplace!T(*cast(T*)&t, *where);
                ++where;
                ++displaceFrom;
            }
        }

        void insertOne()(qsizetype pos, auto ref T /+ && +/ t)
        {
            import core.lifetime;

            T* where = displace(pos, 1);
            core.lifetime.emplace!T(where, /+ std:: +/move(t));
            ++displaceFrom;
            (mixin(Q_ASSERT(q{displaceFrom == displaceTo})));
        }

    }


    void insert()(ref QArrayDataPointer!T this_, qsizetype i, const(T)* data, qsizetype n)
    {
        import core.lifetime;

        const(bool) growsAtBegin = this_.size != 0 && i == 0;
        const pos = growsAtBegin ? Data.GrowthPosition.GrowsAtBeginning : Data.GrowthPosition.GrowsAtEnd;

        DataPointer oldData;
        this_.detachAndGrow(pos, n, &data, &oldData);
        (mixin(Q_ASSERT(q{(pos == Data.GrowthPosition.GrowsAtBeginning && this_.freeSpaceAtBegin() >= n) ||
                     (pos == Data.GrowthPosition.GrowsAtEnd && this_.freeSpaceAtEnd() >= n)})));

        if (growsAtBegin) {
            // copy construct items in reverse order at the begin
            (mixin(Q_ASSERT(q{this_.freeSpaceAtBegin() >= n})));
            while (n) {
                --n;
                core.lifetime.copyEmplace!T(*cast(T*)&data[n], *(this_.begin() - 1));
                --this_.ptr;
                ++this_.size;
            }
        } else {
            Inserter(&this_).insert(i, data, n);
        }
    }

    void insert()(ref QArrayDataPointer!T this_, qsizetype i, qsizetype n, parameter_type t)
    {
        import core.lifetime;

        auto copy = /*T*/(t);

        const(bool) growsAtBegin = this_.size != 0 && i == 0;
        const pos = growsAtBegin ? Data.GrowthPosition.GrowsAtBeginning : Data.GrowthPosition.GrowsAtEnd;

        this_.detachAndGrow(pos, n, null, null);
        (mixin(Q_ASSERT(q{(pos == Data.GrowthPosition.GrowsAtBeginning && this_.freeSpaceAtBegin() >= n) ||
                     (pos == Data.GrowthPosition.GrowsAtEnd && this_.freeSpaceAtEnd() >= n)})));

        if (growsAtBegin) {
            // copy construct items in reverse order at the begin
            (mixin(Q_ASSERT(q{this_.freeSpaceAtBegin() >= n})));
            while (n--) {
                core.lifetime.emplace!T(this_.begin() - 1, copy);
                --this_.ptr;
                ++this_.size;
            }
        } else {
            Inserter(&this_).insert(i, copy, n);
        }
    }

    /+ template<typename... Args> +/
    void emplace(Args...)(ref QArrayDataPointer!T this_, qsizetype i, auto ref Args /+ && +/ args)
    {
        import core.lifetime;

        bool detach = this_.needsDetach();
        if (!detach) {
            if (i == this_.size && this_.freeSpaceAtEnd()) {
                core.lifetime.emplace!T(this_.end(), args /+ /+ std:: +/forward!(Args)(args)...+/);
                ++this_.size;
                return;
            }
            if (i == 0 && this_.freeSpaceAtBegin()) {
                core.lifetime.emplace!T(this_.begin() - 1, args /+ /+ std:: +/forward!(Args)(args)...+/);
                --this_.ptr;
                ++this_.size;
                return;
            }
        }
        static if (Args.length == 1 && is(const(Args[0]) == const(T)))
            auto tmp = args[0];
        else
            auto tmp = T(args /+ /+ std:: +/forward!(Args)(args)...+/);
        const(bool) growsAtBegin = this_.size != 0 && i == 0;
        const pos = growsAtBegin ? Data.GrowthPosition.GrowsAtBeginning : Data.GrowthPosition.GrowsAtEnd;

        this_.detachAndGrow(pos, 1, null, null);
        if (growsAtBegin) {
            (mixin(Q_ASSERT(q{this_.freeSpaceAtBegin()})));
            core.lifetime.emplace!T(this_.begin() - 1, /+ std:: +//+move+/(tmp));
            --this_.ptr;
            ++this_.size;
        } else {
            Inserter(&this_).insertOne(i, /+ std:: +//+move+/(tmp));
        }
    }

    void erase()(ref QArrayDataPointer!T this_, T* b, qsizetype n)
    {
        import core.stdc.string;

        T* e = b + n;

        (mixin(Q_ASSERT(q{this_.isMutable()})));
        (mixin(Q_ASSERT(q{b < e})));
        (mixin(Q_ASSERT(q{b >= this_.begin() && b < this_.end()})));
        (mixin(Q_ASSERT(q{e > this_.begin() && e <= this_.end()})));

        // Comply with std::vector::erase(): erased elements and all after them
        // are invalidated. However, erasing from the beginning effectively
        // means that all iterators are invalidated. We can use this_ freedom to
        // erase by moving towards the end.

        for (auto it = b; it != e; it++)
            destroy(*it);
        if (b == this_.begin() && e != this_.end()) {
            this_.ptr = e;
        } else if (e != this_.end()) {
            memmove(static_cast!(void*)(b), static_cast!(const(void)*)(e), (static_cast!(const(T)*)(this_.end()) - e)*T.sizeof);
        }
        this_.size -= n;
    }

    void reallocate()(ref QArrayDataPointer!T this_, qsizetype alloc, QArrayData.AllocationOption option)
    {
        auto pair = Data.reallocateUnaligned(this_.d, this_.ptr, alloc, option);
        mixin(Q_CHECK_PTR(q{pair.second}));
        (mixin(Q_ASSERT(q{pair.first !is null})));
        this_.d = pair.first;
        this_.ptr = pair.second;
    }
}

template QArrayOpsSelector(T)
{
    static if (!QTypeInfo!T.isComplex && QTypeInfo!T.isRelocatable)
        alias Type = QPodArrayOps!(T);
    else static if (QTypeInfo!T.isComplex && QTypeInfo!T.isRelocatable)
        alias Type = QMovableArrayOps!(T);
    else
        alias Type = QGenericArrayOps!(T);
}

/+ template <class T>
struct QArrayOpsSelector<T,
    typename std::enable_if<
        !QTypeInfo<T>::isComplex && QTypeInfo<T>::isRelocatable
    >::type>
{
    typedef QPodArrayOps<T> Type;
};

template <class T>
struct QArrayOpsSelector<T,
    typename std::enable_if<
        QTypeInfo<T>::isComplex && QTypeInfo<T>::isRelocatable
    >::type>
{
    typedef QMovableArrayOps<T> Type;
}; +/

template QCommonArrayOps(T)
{
    //QArrayOpsSelector!(T).Type base0;
    //alias base0 this_;
    alias Base = QArrayOpsSelector!(T).Type;
    alias Data = QTypedArrayData!(T);
    alias DataPointer = QArrayDataPointer!(T);
    alias parameter_type = Base.parameter_type;

protected:
    alias Self = QCommonArrayOps!(T);

public:
    alias truncate = Base.truncate;
    alias destroyAll = Base.destroyAll;
    alias assign = Base.assign;
    alias compare = Base.compare;
    static if (__traits(hasMember, Base, "reallocate"))
        alias reallocate = Base.reallocate;
    alias copyAppend = Base.copyAppend;
    alias moveAppend = Base.moveAppend;
    alias appendInitialize = Base.appendInitialize;
    alias emplace = Base.emplace;

    /+ template<typename It> +/
    void appendIteratorRange(It)(It b, It e, /+ QtPrivate:: +/IfIsForwardIterator!(It) /+ = true +/)
    {
        import core.lifetime;

        (mixin(Q_ASSERT(q{this.isMutable() || b == e})));
        (mixin(Q_ASSERT(q{!this.isShared() || b == e})));
        const(qsizetype) distance = /+ std:: +/distance(b, e);
        (mixin(Q_ASSERT(q{distance >= 0 && distance <= this.allocatedCapacity() - this.size})));
        /+ Q_UNUSED(distance) +/

/+ #if __cplusplus >= 202002L && defined(__cpp_concepts) && defined(__cpp_lib_concepts)
        constexpr bool canUseCopyAppend =
                std::contiguous_iterator<It> &&
                std::is_same_v<
                    std::remove_cv_t<typename std::iterator_traits<It>::value_type>,
                    T
                >;
        if constexpr (canUseCopyAppend) {
            this->copyAppend(std::to_address(b), std::to_address(e));
        } else
#endif +/
        {
            T* iter = this.end();
            for (; b != e; ++iter, ++b) {
                core.lifetime.emplace!T(iter, *b);
                ++this.size;
            }
        }
    }

    // slightly higher level API than copyAppend() that also preallocates space
    void growAppend()(ref QArrayDataPointer!T this_, const(T)* b, const(T)* e)
    {
        if (b == e)
            return;
        (mixin(Q_ASSERT(q{b < e})));
        const(qsizetype) n = e - b;
        DataPointer old;

        // points into range:
        if (b >= this_.begin() && b < this_.end()) {
            this_.detachAndGrow(QArrayData.GrowthPosition.GrowsAtEnd, n, &b, &old);
        } else {
            this_.detachAndGrow(QArrayData.GrowthPosition.GrowsAtEnd, n, null, null);
        }
        (mixin(Q_ASSERT(q{this_.freeSpaceAtEnd() >= n})));
        // b might be updated so use [b, n)
        this_.copyAppend(b, b + n);
    }
}

} // namespace QtPrivate

template QArrayDataOps(T)
{
    // /+ QtPrivate:: +/QCommonArrayOps!(T) base0;
    //alias base0 this_;
    alias QArrayDataOps = QCommonArrayOps!T;
}
