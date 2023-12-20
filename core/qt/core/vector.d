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
module qt.core.vector;
extern(C++):

import qt.config;
import qt.core.arraydata;
import qt.core.global;
import qt.core.list;
import qt.core.typeinfo;
import qt.helpers;



/+ #if QT_VERSION < QT_VERSION_CHECK(6,0,0)
#endif +/

/// Binding for C++ class [QVector](https://doc.qt.io/qt-5/qvector.html).
extern(C++, class) struct QVector(T)
{
private:
    alias Data = QTypedArrayData!(T);
    version (Windows)
        Data* d;
    else
    {
        union
        {
            const(QArrayData)* d2 = QArrayData.shared_null.ptr;
            Data* d;
        }
    }

public:
    version (Windows)
    {
        @disable this();
        pragma(inline, true) void rawConstructor()/+ noexcept+/
        {
            this.d = Data.sharedNull();
        }
        static typeof(this) create()
        {
            typeof(this) r = typeof(this).init;
            r.rawConstructor();
            return r;
        }
    }
    else
    {
        static typeof(this) create()
        {
            return typeof(this).init;
        }
    }

    /+ explicit +/this(int asize)
    {
        (mixin(Q_ASSERT_X(q{asize >= 0},q{ "QVector::QVector"},q{ "Size must be greater than or equal to 0."})));
        if (/+ Q_LIKELY +/(asize > 0)) {
            d = cast(Data*) (Data.allocate(asize));
            //mixin(Q_CHECK_PTR(q{QVector.d}));
            d.size = asize;
            defaultConstruct(d.begin(), d.end());
        } else {
            d = cast(Data*) (Data.sharedNull());
        }
    }
    this(int asize, ref const(T) t)
    {
        import core.lifetime;

        (mixin(Q_ASSERT_X(q{asize >= 0},q{ "QVector::QVector"},q{ "Size must be greater than or equal to 0."})));
        if (asize > 0) {
            d = cast(Data*) (Data.allocate(asize));
            mixin(Q_CHECK_PTR(q{QVector.d}));
            d.size = asize;
            T* i = d.end();
            while (i != d.begin())
                copyEmplace!T(*--i, t);
        } else {
            d = cast(Data*) (Data.sharedNull());
        }
    }
    /+@disable this(this);
    pragma(inline, true) this()(ref const(QVector!(T)) v)
    {
        if ((cast(Data*)v.d).ref_.ref_()) {
            d = cast(Data*)v.d;
        } else {
            if (v.d.capacityReserved) {
                d = cast(Data*) (Data.allocate(v.d.alloc));
                mixin(Q_CHECK_PTR(q{QVector.d}));
                d.capacityReserved = true;
            } else {
                d = cast(Data*) (Data.allocate(v.d.size));
                mixin(Q_CHECK_PTR(q{QVector.d}));
            }
            if (d.alloc) {
                copyConstruct(v.d.begin(), v.d.end(), d.begin());
                d.size = v.d.size;
            }
        }
    }+/
    this(this)
    {
        if (!d.ref_.ref_()) {
            auto orig = d;
            if (d.capacityReserved) {
                d = cast(Data*)(Data.allocate(d.alloc));
                mixin(Q_CHECK_PTR(/*p*/q{    QVector.d}));
                d.capacityReserved = true;
            } else {
                d = cast(Data*)(Data.allocate(d.size));
                mixin(Q_CHECK_PTR(/*p*/q{    QVector.d}));
            }
            if (d.alloc) {
                copyConstruct(cast(const(T)*)(orig.begin()), cast(const(T)*)(orig.end()), cast(T*)(d.begin()));
                d.size = orig.size;
            }
        }
    }
    pragma(inline, true) ~this() { if (!d.base0.ref_.deref()) freeData(d); }
    /+ref QVector!(T) operator =(ref const(QVector!(T)) v)
    {
        if (v.d != d) {
            auto tmp = QVector!(T)(v);
            tmp.swap(this);
        }
        return this;
    }+/
    /+ QVector(QVector<T> &&other) noexcept : d(other.d) { other.d = Data::sharedNull(); } +/
    /+ QVector<T> &operator=(QVector<T> &&other) noexcept
    { QVector moved(std::move(other)); swap(moved); return *this; } +/
    /+ void swap(QVector<T> &other) noexcept { qSwap(d, other.d); } +/
    /+ inline QVector(std::initializer_list<T> args); +/
    /+ QVector<T> &operator=(std::initializer_list<T> args); +/
    /+ template <typename InputIterator, QtPrivate::IfIsInputIterator<InputIterator> = true> +/
    pragma(inline, true) this(InputIterator,)(InputIterator first, InputIterator last)
    {
        import qt.core.containertools_impl;
        this();

        /+ QtPrivate:: +/qt.core.containertools_impl.reserveIfForwardIterator(&this, first, last);
        /+ std:: +/copy(first, last, /+ std:: +/back_inserter(this));
    }
    /+ explicit +/this(QArrayDataPointerRef!(T) ref_)/+ noexcept+/
    {
        this.d = ref_.ptr;
    }

    /+bool operator ==(ref const(QVector!(T)) v) const
    {
        if (d == v.d)
            return true;
        if (d.size != v.d.size)
            return false;
        const(T)* vb = v.d.begin();
        const(T)* b  = d.begin();
        const(T)* e  = d.end();
        return /+ std:: +/equal(b, e, mixin(QT_MAKE_CHECKED_ARRAY_ITERATOR(q{vb},q{ v.d->size})));
    }+/
    /+pragma(inline, true) bool operator !=(ref const(QVector!(T)) v) const { return !(this == v); }+/

    pragma(inline, true) int size() const { return d.base0.size; }

    pragma(inline, true) bool isEmpty() const { return d.base0.size == 0; }

    void resize()(int asize)
    {
        if (asize == d.size)
            return detach();
        if (asize > int(d.alloc) || !isDetached()) { // there is not enough space
            QArrayData.AllocationOptions opt = asize > int(d.alloc) ? QArrayData.AllocationOption.Grow : QArrayData.AllocationOption.Default;
            realloc(qMax(int(d.alloc), asize), opt);
        }
        if (asize < d.size)
            destruct(begin() + asize, end());
        else
            defaultConstruct(end(), begin() + asize);
        d.size = asize;
    }

    pragma(inline, true) int capacity() const { return int(d.base0.alloc); }
    void reserve(int asize)
    {
        if (asize > int(d.alloc))
            realloc(asize);
        if ( mixin((!versionIsSet!("QT_NO_UNSHARABLE_CONTAINERS")) ? q{
                    isDetached()
            /+ #if !defined(QT_NO_UNSHARABLE_CONTAINERS) +/
                        && d != Data.unsharableEmpty()
            } : q{
            isDetached()
            })/+ #endif +/
                )
            d.capacityReserved = 1;
        (mixin(Q_ASSERT(q{QVector.capacity() >= asize})));
    }
    pragma(inline, true) void squeeze()
    {
        if (d.size < int(d.alloc)) {
            if (!d.size) {
                this = QVector!(T).create();
                return;
            }
            realloc(d.size);
        }
        if (d.capacityReserved) {
            // capacity reserved in a read only memory would be useless
            // this checks avoid writing to such memory.
            d.capacityReserved = 0;
        }
    }

    pragma(inline, true) void detach()
    {
        if (!isDetached()) {
    /+ #if !defined(QT_NO_UNSHARABLE_CONTAINERS) +/
            static if (!versionIsSet!("QT_NO_UNSHARABLE_CONTAINERS"))
            {
                    if (!d.alloc)
                    d = cast(Data*) (Data.unsharableEmpty());
                else
        /+ #endif +/
                    realloc(int(d.alloc));
            }
            else
            {
        realloc(int(d.alloc));
            }
        }
        (mixin(Q_ASSERT(q{QVector.isDetached()})));
    }
    pragma(inline, true) bool isDetached() const { return !d.ref_.isShared(); }
    version (QT_NO_UNSHARABLE_CONTAINERS) {} else
    {
        pragma(inline, true) void setSharable(bool sharable)
        {
            if (sharable == d.ref_.isSharable())
                return;
            if (!sharable)
                detach();

            if (d == Data.unsharableEmpty()) {
                if (sharable)
                    d = cast(Data*) (Data.sharedNull());
            } else {
                d.ref_.setSharable(sharable);
            }
            (mixin(Q_ASSERT(q{QVector.d.ref_.isSharable() == sharable})));
        }
    }

    pragma(inline, true) bool isSharedWith(ref const(QVector!(T)) other) const { return d == other.d; }

    pragma(inline, true) T* data() { detach(); return d.begin(); }
    pragma(inline, true) const(T)* data() const { return d.begin(); }
    pragma(inline, true) const(T)* constData() const { return d.begin(); }
    pragma(inline, true) void clear()
    {
        if (!d.size)
            return;
        destruct(begin(), end());
        d.size = 0;
    }

    pragma(inline, true) ref const(T) at(int i) const
    { (mixin(Q_ASSERT_X(q{i >= 0 && i < QVector.d.size},q{ "QVector<T>::at"},q{ "index out of range"})));
      return d.begin()[i]; }
    pragma(inline, true) ref T opIndex(int i)
    { (mixin(Q_ASSERT_X(q{i >= 0 && i < QVector.d.size},q{ "QVector<T>::operator[]"},q{ "index out of range"})));
      return data()[i]; }
    pragma(inline, true) ref const(T) opIndex(int i) const
    { (mixin(Q_ASSERT_X(q{i >= 0 && i < QVector.d.size},q{ "QVector<T>::operator[]"},q{ "index out of range"})));
      return d.begin()[i]; }
    void append(ref const(T) t)
    {
        import core.lifetime;

        const(bool) isTooSmall = uint(d.size + 1) > d.alloc;
        if (!isDetached() || isTooSmall) {
            auto copy = *cast(T*)&t;
            auto opt = QArrayData.AllocationOptions(isTooSmall ? QArrayData.AllocationOption.Grow : QArrayData.AllocationOption.Default);
            realloc(isTooSmall ? d.size + 1 : d.alloc, opt);

            if (QTypeInfo!(T).isComplex)
                moveEmplace!T(copy, *d.end());
            else
                moveEmplace!T(copy, *d.end());

        } else {
            if (QTypeInfo!(T).isComplex)
            {
                auto copy = *cast(T*)&t;
                emplace(d.end(), copy);
            }
            else
            {
                auto copy = *cast(T*)&t;
                *d.end() = copy;
            }
        }
        ++d.size;
    }
    void append(const(T)  t)
    {
        append(t);
    }

    /+ void append(T &&t); +/
    pragma(inline, true) void append()(ref const(QVector!(T)) l) { this += l; }
    /+ void prepend(T &&t); +/
    pragma(inline, true) void prepend()(ref const(T) t)
    { insert(begin(), 1, t); }
    /+ void insert(int i, T &&t); +/
    pragma(inline, true) void insert()(int i, ref const(T) t)
    { (mixin(Q_ASSERT_X(q{i >= 0 && i <= QVector.d.size},q{ "QVector<T>::insert"},q{ "index out of range"})));
      insert(begin() + i, 1, t); }
    pragma(inline, true) void insert()(int i, int n, ref const(T) t)
    { (mixin(Q_ASSERT_X(q{i >= 0 && i <= QVector.d.size},q{ "QVector<T>::insert"},q{ "index out of range"})));
      insert(begin() + i, n, t); }
    pragma(inline, true) void replace(int i, ref const(T) t)
    {
        (mixin(Q_ASSERT_X(q{i >= 0 && i < QVector.d.size},q{ "QVector<T>::replace"},q{ "index out of range"})));
        auto copy = *cast(T*)&t;
        data()[i] = copy;
    }
    pragma(inline, true) void remove(int i)
    { (mixin(Q_ASSERT_X(q{i >= 0 && i < QVector.d.size},q{ "QVector<T>::remove"},q{ "index out of range"})));
      erase(d.begin() + i, d.begin() + i + 1); }
    pragma(inline, true) void remove(int i, int n)
    { (mixin(Q_ASSERT_X(q{i >= 0 && n >= 0 && i + n <= QVector.d.size},q{ "QVector<T>::remove"},q{ "index out of range"})));
      erase(d.begin() + i, d.begin() + i + n); }
    pragma(inline, true) void removeFirst() { (mixin(Q_ASSERT(q{!QVector.isEmpty()}))); erase(d.begin()); }
    pragma(inline, true) void removeLast()
    {
        (mixin(Q_ASSERT(q{!QVector.isEmpty()})));
        (mixin(Q_ASSERT(q{QVector.d.alloc})));

        if (d.ref_.isShared())
            detach();
        --d.size;
        if (QTypeInfo!(T).isComplex)
            destroy!false(*(d.data() + d.size));
    }
/+    T takeFirst() { (mixin(Q_ASSERT(q{!QVector.isEmpty()}))); T r = /+ std:: +/move(first()); removeFirst(); return r; }
    T takeLast() { (mixin(Q_ASSERT(q{!QVector.isEmpty()}))); T r = /+ std:: +/move(last()); removeLast(); return r; }
+/
    ref QVector!(T) fill()(ref const(T) from, int asize = -1)
    {
        auto copy = const(T)(from);
        resize(asize < 0 ? d.size : asize);
        if (d.size) {
            T* i = d.end();
            T* b = d.begin();
            while (i != b)
                *--i = copy;
        }
        return this;
    }

    int indexOf(ref const(T) t, int from = 0) const
    {
        if (from < 0)
        {
            //from = qMax(from + d.size, 0);
            from = from + d.size;
            if(from < 0)
                from = 0;
        }
        if (from < d.size) {
            T* n = cast(T*)(d.begin() + from - 1);
            T* e = cast(T*)(d.end());
            while (++n != e)
                if (*n == t)
                    return cast(int) (n - d.begin());
        }
        return -1;
    }
    int indexOf(const(T)  t, int from = 0) const
    {
        return indexOf(t, from);
    }
    int lastIndexOf(ref const(T) t, int from = -1) const
    {
        if (from < 0)
            from += d.size;
        else if (from >= d.size)
            from = d.size-1;
        if (from >= 0) {
            T* b = cast(T*)(d.begin());
            T* n = cast(T*)(d.begin() + from + 1);
            while (n != b) {
                if (*--n == t)
                    return cast(int) (n - b);
            }
        }
        return -1;
    }
/+    bool contains(ref const(T) t) const
    {
        const(T)* b = d.begin();
        const(T)* e = d.end();
        return /+ std:: +/find(b, e, t) != e;
    }+/
/+    int count(ref const(T) t) const
    {
        const(T)* b = d.begin();
        const(T)* e = d.end();
        return int(/+ std:: +/count(b, e, t));
    }
+/

    // QList compatibility
//    void removeAt(int i) { remove(i); }
/+    int removeAll(ref const(T) t)
    {
        const(const_iterator) ce = this.cend(); const(const_iterator) cit = /+ std:: +/find(this.cbegin(), ce, t);
        if (cit == ce)
            return 0;
        // next operation detaches, so ce, cit, t may become invalidated:
        const(T) tCopy = t;
        const(int) firstFoundIdx = /+ std:: +/distance(this.cbegin(), cit);
        const(iterator) e = end(); const(iterator) it = /+ std:: +/remove(begin() + firstFoundIdx, e, tCopy);
        const(int) result = /+ std:: +/distance(it, e);
        erase(cast(iterator) (it), cast(iterator) (e));
        return result;
    }+/
    bool removeOne(ref const(T) t)
    {
        const(int) i = indexOf(t);
        if (i < 0)
            return false;
        remove(i);
        return true;
    }
    int length() const { return size(); }
    T takeAt(int i) { 
    T t = /+ std:: +//*move*/cast(T)((this)[i]); remove(i); return t; }
/+    void move(int from, int to)
    {
        (mixin(Q_ASSERT_X(q{from >= 0 && from < QVector.size()},q{ "QVector::move(int,int)"},q{ "'from' is out-of-range"})));
        (mixin(Q_ASSERT_X(q{to >= 0 && to < QVector.size()},q{ "QVector::move(int,int)"},q{ "'to' is out-of-range"})));
        if (from == to) // don't detach when no-op
            return;
        detach();
        T* /+ const +/  b = d.begin();
        if (from < to)
            /+ std:: +/rotate(b + from, b + from + 1, b + to + 1);
        else
            /+ std:: +/rotate(b + to, b + from, b + from + 1);
    }+/

    // STL-style
    alias iterator = Data.iterator;
    alias const_iterator = Data.const_iterator;
    /+ typedef std::reverse_iterator<iterator> reverse_iterator; +/
    /+ typedef std::reverse_iterator<const_iterator> const_reverse_iterator; +/
/+ #if !defined(QT_STRICT_ITERATORS) || defined(Q_CLANG_QDOC) +/
    pragma(inline, true) iterator begin() { detach(); return iterator(d.begin()); }
    pragma(inline, true) const_iterator begin() const/+ noexcept+/ { return d.constBegin(); }
    pragma(inline, true) const_iterator cbegin() const/+ noexcept+/ { return d.constBegin(); }
    pragma(inline, true) const_iterator constBegin() const/+ noexcept+/ { return d.constBegin(); }
    pragma(inline, true) iterator end() { detach(); return iterator(d.end()); }

    auto opSlice()const
    {
        struct R
        {
            iterator i;
            iterator end;
            ref T front()
            {
                return *i;
            }
            bool empty()
            {
                return i == end;
            }
            void popFront()
            {
                i++;
            }
        }
        auto this_ = cast(QVector*)&this;
        return R(this_.begin(), this_.end());
    }

    pragma(inline, true) const_iterator end() const/+ noexcept+/ { return d.constEnd(); }
    pragma(inline, true) const_iterator cend() const/+ noexcept+/ { return d.constEnd(); }
    pragma(inline, true) const_iterator constEnd() const/+ noexcept+/ { return d.constEnd(); }
/+ #else
    inline iterator begin(iterator = iterator()) { detach(); return d->begin(); }
    inline const_iterator begin(const_iterator = const_iterator()) const noexcept { return d->constBegin(); }
    inline const_iterator cbegin(const_iterator = const_iterator()) const noexcept { return d->constBegin(); }
    inline const_iterator constBegin(const_iterator = const_iterator()) const noexcept { return d->constBegin(); }
    inline iterator end(iterator = iterator()) { detach(); return d->end(); }
    inline const_iterator end(const_iterator = const_iterator()) const noexcept { return d->constEnd(); }
    inline const_iterator cend(const_iterator = const_iterator()) const noexcept { return d->constEnd(); }
    inline const_iterator constEnd(const_iterator = const_iterator()) const noexcept { return d->constEnd(); }
#endif +/
    /+ reverse_iterator rbegin() { return reverse_iterator(end()); } +/
    /+ reverse_iterator rend() { return reverse_iterator(begin()); } +/
    /+ const_reverse_iterator rbegin() const noexcept { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator rend() const noexcept { return const_reverse_iterator(begin()); } +/
    /+ const_reverse_iterator crbegin() const noexcept { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator crend() const noexcept { return const_reverse_iterator(begin()); } +/
    iterator insert()(iterator before, int n, ref const(T) t)
    /+iterator insert(iterator before, size_type n, ref const(T) t)+/
    {
        import core.lifetime;
        import core.stdc.string;

        (mixin(Q_ASSERT_X(q{QVector.isValidIterator(before)},q{  "QVector::insert"},q{ "The specified iterator argument 'before' is invalid"})));

        const offset = before - d.begin(); // /+ std:: +/distance(d.begin(), before);
        if (n != 0) {
            T copy = *cast(T*)&t;
            if (!isDetached() || d.size + n > int(d.alloc))
                realloc(d.size + n, QArrayData.AllocationOptions.Grow);
            static if (!QTypeInfoQuery!(T).isRelocatable) {
                T* b = d.end();
                T* i = d.end() + n;
                while (i != b)
                    emplace!T(--i);
                i = d.end();
                T* j = i + n;
                b = d.begin() + offset;
                while (i != b)
                    *--j = *--i;
                i = b+n;
                while (i != b)
                    *--i = copy;
            } else {
                T* b = d.begin() + offset;
                T* i = b + n;
                memmove(static_cast!(void*)(i), static_cast!(const(void)*)(b), (d.size - offset) * T.sizeof);
                while (i != b)
                    copyEmplace!T(copy, *--i);
            }
            d.size += n;
        }
        return d.begin() + offset;
    }
    pragma(inline, true) iterator insert()(iterator before, ref const(T) x) { return insert(before, 1, x); }
    /+ inline iterator insert(iterator before, T &&x); +/
    iterator erase(iterator abegin, iterator aend)
    {
        import core.lifetime;
        import core.stdc.string;

        (mixin(Q_ASSERT_X(q{QVector.isValidIterator(abegin)},q{ "QVector::erase"},q{ "The specified iterator argument 'abegin' is invalid"})));
        (mixin(Q_ASSERT_X(q{QVector.isValidIterator(aend)},q{ "QVector::erase"},q{ "The specified iterator argument 'aend' is invalid"})));

        const itemsToErase = aend - abegin;

        if (!itemsToErase)
            return abegin;

        (mixin(Q_ASSERT(q{abegin >= QVector.d.begin()})));
        (mixin(Q_ASSERT(q{aend <= QVector.d.end()})));
        (mixin(Q_ASSERT(q{abegin <= aend})));

        const itemsUntouched = abegin - d.begin();

        // FIXME we could do a proper realloc, which copy constructs only needed data.
        // FIXME we are about to delete data - maybe it is good time to shrink?
        // FIXME the shrink is also an issue in removeLast, that is just a copy + reduce of this.
        if (d.alloc) {
            detach();
            abegin = d.begin() + itemsUntouched;
            aend = abegin + itemsToErase;
            if (!QTypeInfoQuery!T.isRelocatable) {
                iterator moveBegin = abegin + itemsToErase;
                iterator moveEnd = d.end();
                while (moveBegin != moveEnd) {
                    if (QTypeInfo!(T).isComplex)
                        destroy!false(*static_cast!(T*)(abegin));
                    emplace!T(abegin++, *moveBegin++);
                }
                if (abegin < d.end()) {
                    // destroy rest of instances
                    destruct(abegin, d.end());
                }
            } else {
                destruct(abegin, aend);
                // QTBUG-53605: static_cast<void *> masks clang errors of the form
                // error: destination for this 'memmove' call is a pointer to class containing a dynamic class
                // FIXME maybe use std::is_polymorphic (as soon as allowed) to avoid the memmove
                memmove(static_cast!(void*)(abegin), static_cast!(void*)(aend),
                        (d.size - itemsToErase - itemsUntouched) * T.sizeof);
            }
            d.size -= cast(int)(itemsToErase);
        }
        return d.begin() + itemsUntouched;
    }
    pragma(inline, true) iterator erase(iterator pos) { return erase(pos, pos+1); }

    // more Qt
    pragma(inline, true) int count() const { return d.size; }
    pragma(inline, true) ref T first() { (mixin(Q_ASSERT(q{!QVector.isEmpty()}))); return *begin(); }
    pragma(inline, true) ref const(T) first() const { (mixin(Q_ASSERT(q{!QVector.isEmpty()}))); return *begin(); }
    pragma(inline, true) ref const(T) constFirst() const { (mixin(Q_ASSERT(q{!QVector.isEmpty()}))); return *begin(); }
    pragma(inline, true) ref T last() { (mixin(Q_ASSERT(q{!QVector.isEmpty()}))); return *(end()-1); }
    pragma(inline, true) ref const(T) last() const { (mixin(Q_ASSERT(q{!QVector.isEmpty()}))); return *(end()-1); }
    pragma(inline, true) ref const(T) constLast() const { (mixin(Q_ASSERT(q{!QVector.isEmpty()}))); return *(end()-1); }
    pragma(inline, true) bool startsWith(ref const(T) t) const { return !isEmpty() && first() == t; }
    pragma(inline, true) bool endsWith(ref const(T) t) const { return !isEmpty() && last() == t; }
/+    QVector!(T) mid(int pos, int len = -1) const
    {
        //using namespace QtPrivate;
        switch (QContainerImplHelper.mid(d.size, &pos, &len)) {
        case QContainerImplHelper.Null:
        case QContainerImplHelper.Empty:
            return QVector!(T)();
        case QContainerImplHelper.Full:
            return this;
        case QContainerImplHelper.Subset:
            break;default:

        }

        QVector!(T) midResult;
        midResult.realloc(len);
        T* srcFrom = d.begin() + pos;
        T* srcTo = d.begin() + pos + len;
        midResult.copyConstruct(srcFrom, srcTo, midResult.data());
        midResult.d.size = len;
        return midResult;
    }+/

    T value(int i) const
    {
        if (uint(i) >= uint(d.size)) {
            return T.init;
        }
        return *cast(T*)&d.begin()[i];
    }
    T value(int i, ref const(T) defaultValue) const
    {
        return *cast(T*)&(uint(i) >= uint(d.size) ? defaultValue : d.begin()[i]);
    }

/+    void swapItemsAt(int i, int j) {
        (mixin(Q_ASSERT_X(q{i >= 0 && i < QVector.size() && j >= 0 && j < QVector.size()},q{
                    "QVector<T>::swap"},q{ "index out of range"})));
        detach();
        auto tmp = d.begin()[i]; auto tmp__1 = d.begin()[j]; qSwap(tmp, tmp__1);
    }
+/
    // STL compatibility
    alias value_type = T;
    alias pointer = value_type*;
    alias const_pointer = const(value_type)*;
    /+ typedef value_type& reference; +/
    /+ typedef const value_type& const_reference; +/
    alias difference_type = qptrdiff;
    alias Iterator = iterator;
    alias ConstIterator = const_iterator;
    alias size_type = int;
    pragma(inline, true) void push_back()(ref const(T) t) { append(t); }
    /+ void push_back(T &&t) { append(std::move(t)); } +/
    /+ void push_front(T &&t) { prepend(std::move(t)); } +/
    pragma(inline, true) void push_front()(ref const(T) t) { prepend(t); }
    void pop_back() { removeLast(); }
    void pop_front() { removeFirst(); }
    pragma(inline, true) bool empty() const
    { return d.base0.size == 0; }
    pragma(inline, true) ref T front() { return first(); }
    pragma(inline, true) /*const_reference*/ref const(value_type) front() const { return first(); }
    pragma(inline, true) /*reference*/ref value_type back() { return last(); }
    pragma(inline, true) /*const_reference*/ ref const(value_type) back() const { return last(); }
    void shrink_to_fit() { squeeze(); }

    // comfort
    extern(D) ref QVector!(T) opOpAssign(string op)(ref const(QVector!(T)) l) if (op == "~");
    extern(D) pragma(inline, true) QVector!(T) opBinary(string op)(ref const(QVector!(T)) l) const if (op == "~")
    { QVector n = this; n ~= l; return n; }
    extern(D) pragma(inline, true) ref QVector!(T) opOpAssign(string op)(ref const(T) t) if (op == "~")
    { append(t); return this; }
    /+pragma(inline, true) ref QVector!(T) operator << (ref const(T) t)
    { append(t); return this; }+/
    /+pragma(inline, true) ref QVector!(T) operator <<(ref const(QVector!(T)) l)
    { this += l; return this; }+/
    extern(D) void opOpAssign(string op, T2)(ref const T2 t) if (op == "~" && !is(const(T2) == const(T)))
    {
        auto tmp = T(t);
        append(tmp);
    }
    extern(D) void opOpAssign(string op)(const T t) if (op == "~")
    {
        append(t);
    }
    /+ inline QVector<T> &operator+=(T &&t)
    { append(std::move(t)); return *this; } +/
    /+ inline QVector<T> &operator<<(T &&t)
    { append(std::move(t)); return *this; } +/

/+    static QVector!(T) fromList(ref const(QList!(T)) list)
    {
        return list.toVector();
    }+/
/+    QList!(T) toList() const
    {
        return QList!(T)(begin(), end());
    }+/

/+ #if QT_DEPRECATED_SINCE(5, 14) && QT_VERSION < QT_VERSION_CHECK(6,0,0) +/
    /+ QT_DEPRECATED_X("Use QVector<T>(vector.begin(), vector.end()) instead.")
    static inline QVector<T> fromStdVector(const std::vector<T> &vector)
    { return QVector<T>(vector.begin(), vector.end()); } +/
    /+ QT_DEPRECATED_X("Use std::vector<T>(vector.begin(), vector.end()) instead.")
    inline std::vector<T> toStdVector() const
    { return std::vector<T>(d->begin(), d->end()); } +/
/+ #endif +/
private:
    // ### Qt6: remove methods, they are unused
    void reallocData()(const(int) asize, const(int) aalloc, QArrayData.AllocationOptions options = QArrayData.AllocationOption.Default)
    {
        import core.lifetime;
        import core.stdc.string;

        (mixin(Q_ASSERT(q{asize >= 0 && asize <= aalloc})));
        Data* x = d;

        const(bool) isShared = d.ref_.isShared();

        if (aalloc != 0) {
            if (aalloc != int(d.alloc) || isShared) {
                /+ QT_TRY +/ {
                     /+ QT_CATCH (...) +/scope(failure) {
                        Data.deallocate(x);
                    }
                    import core.stdc.string;
                    // allocate memory
                    x = cast(Data*) (Data.allocate(aalloc, options));
                    //mixin(Q_CHECK_PTR(q{x}));
                    // aalloc is bigger then 0 so it is not [un]sharedEmpty
                    version (QT_NO_UNSHARABLE_CONTAINERS) {} else
                    {
                        (mixin(Q_ASSERT(q{x.ref_.isSharable() || options.testFlag(QArrayData.AllocationOption.Unsharable)})));
                    }
                    //(mixin(Q_ASSERT(q{!x.ref_.isStatic()})));
                    x.size = asize;

                    T* srcBegin = d.begin();
                    T* srcEnd = asize > d.size ? d.end() : d.begin() + asize;
                    T* dst = x.begin();

                    if (!QTypeInfoQuery!T.isRelocatable || (isShared && QTypeInfo!T.isComplex)) {
                        /+ QT_TRY +/ {
                             /+ QT_CATCH (...) +/scope(failure) {
                                // destruct already copied objects
                                destruct(x.begin(), dst);
                            }
                            if (true/+isShared || !std.is_nothrow_move_constructible<T>.value+/) {
                                // we can not move the data, we need to copy construct it
                                while (srcBegin != srcEnd)
                                    emplace!T(dst++, *srcBegin++);
                            } /+else {
                                while (srcBegin != srcEnd)
                                    emplace!T(dst++, /+ std:: +/move(*srcBegin++));
                            }+/
                        }
                    } else {
                        memcpy(static_cast!(void*)(dst), static_cast!(void*)(srcBegin), (srcEnd - srcBegin) * T.sizeof);
                        dst += srcEnd - srcBegin;

                        // destruct unused / not moved data
                        if (asize < d.size)
                            destruct(d.begin() + asize, d.end());
                    }

                    if (asize > d.size) {
                        // construct all new objects when growing
                        if (!QTypeInfo!(T).isComplex) {
                            .memset(static_cast!(void*)(dst), 0, (static_cast!(T*)(x.end()) - dst) * T.sizeof);
                        } else {
                            /+ QT_TRY +/ {
                                 /+ QT_CATCH (...) +/scope(failure) {
                                    // destruct already copied objects
                                    destruct(x.begin(), dst);
                                }
                                while (dst != x.end())
                                    emplace!T(dst++);
                            }
                        }
                    }
                }
                x.capacityReserved = d.capacityReserved;
            } else {
                (mixin(Q_ASSERT(q{int(QVector.d.alloc) == aalloc}))); // resize, without changing allocation size
                (mixin(Q_ASSERT(q{QVector.isDetached()})));       // can be done only on detached d
                (mixin(Q_ASSERT(q{x == QVector.d})));             // in this case we do not need to allocate anything
                if (asize <= d.size) {
                    destruct(x.begin() + asize, x.end()); // from future end to current end
                } else {
                    defaultConstruct(x.end(), x.begin() + asize); // from current end to future end
                }
                x.size = asize;
            }
        } else {
            x = cast(Data*) (Data.sharedNull());
        }
        if (d != x) {
            if (!d.ref_.deref()) {
                if (!QTypeInfoQuery!T.isRelocatable || !aalloc || (isShared && QTypeInfo!T.isComplex)) {
                    // data was copy constructed, we need to call destructors
                    // or if !alloc we did nothing to the old 'd'.
                    freeData(d);
                } else {
                    Data.deallocate(d);
                }
            }
            d = x;
        }

        (mixin(Q_ASSERT(q{QVector.d.data()})));
        (mixin(Q_ASSERT(q{uint(QVector.d.size) <= QVector.d.alloc})));
        version (QT_NO_UNSHARABLE_CONTAINERS) {} else
        {
            (mixin(Q_ASSERT(q{QVector.d != Data.unsharableEmpty()})));
        }
        (mixin(Q_ASSERT(q{aalloc ? QVector.d != Data.sharedNull() : QVector.d == Data.sharedNull()})));
        (mixin(Q_ASSERT(q{QVector.d.alloc >= uint(aalloc)})));
        (mixin(Q_ASSERT(q{QVector.d.size == asize})));
    }
    void reallocData()(const(int) sz) { reallocData(sz, d.alloc); }
    void realloc()(int aalloc, QArrayData.AllocationOptions options = QArrayData.AllocationOption.Default)
    {
        import core.lifetime;
        import core.stdc.string;

        (mixin(Q_ASSERT(q{aalloc >= QVector.d.size})));
        Data* x = d;

        const(bool) isShared = d.ref_.isShared();

        /+ QT_TRY +/ {
             /+ QT_CATCH (...) +/scope(failure) {
                Data.deallocate(x);
            }
            // allocate memory
            x = cast(Data*) (Data.allocate(aalloc, options));
            //mixin(Q_CHECK_PTR(q{x}));
            // aalloc is bigger then 0 so it is not [un]sharedEmpty
            version (QT_NO_UNSHARABLE_CONTAINERS) {} else
            {
                (mixin(Q_ASSERT(q{x.ref_.isSharable() || options.testFlag(QArrayData.AllocationOption.Unsharable)})));
            }
    //        (mixin(Q_ASSERT(q{!x.ref_.isStatic()})));
            x.size = d.size;

            T* srcBegin = d.begin();
            T* srcEnd = d.end();
            T* dst = x.begin();

            if (!QTypeInfoQuery!T.isRelocatable || (isShared && QTypeInfo!T.isComplex)) {
                /+ QT_TRY +/ {
                     /+ QT_CATCH (...) +/scope(failure) {
                        // destruct already copied objects
                        destruct(x.begin(), dst);
                    }
                    /+if (isShared || !std::is_nothrow_move_constructible<T>::value)+/ {
                        // we can not move the data, we need to copy construct it
                        while (srcBegin != srcEnd)
                            emplace!T(dst++, *srcBegin++);
                    } /+else {
                        while (srcBegin != srcEnd)
                            emplace!T(dst++, /+ std:: +/move(*srcBegin++));
                    }+/
                }
            } else {
                memcpy(static_cast!(void*)(dst), static_cast!(void*)(srcBegin), (srcEnd - srcBegin) * T.sizeof);
                dst += srcEnd - srcBegin;
            }

        }
        x.capacityReserved = d.capacityReserved;

        (mixin(Q_ASSERT(q{QVector.d != x})));
        if (!d.ref_.deref()) {
            if (!QTypeInfoQuery!T.isRelocatable || !aalloc || (isShared && QTypeInfo!T.isComplex)) {
                // data was copy constructed, we need to call destructors
                // or if !alloc we did nothing to the old 'd'.
                freeData(d);
            } else {
                Data.deallocate(d);
            }
        }
        d = x;

        (mixin(Q_ASSERT(q{QVector.d.data()})));
        (mixin(Q_ASSERT(q{uint(QVector.d.size) <= QVector.d.alloc})));
        version (QT_NO_UNSHARABLE_CONTAINERS) {} else
        {
            (mixin(Q_ASSERT(q{QVector.d != Data.unsharableEmpty()})));
        }
        (mixin(Q_ASSERT(q{QVector.d != Data.sharedNull()})));
        (mixin(Q_ASSERT(q{QVector.d.alloc >= uint(aalloc)})));
    }
    void freeData(Data* x)
    {
        destruct(x.begin(), x.end());
        Data.deallocate(x);
    }
    void defaultConstruct()(T* from, T* to)
    {
        import core.lifetime;
        import core.stdc.string;

        while (from != to)
        {
            static if (__traits(hasMember, T, "rawConstructor"))
                (*from++).rawConstructor();
            else
                emplace!T(from++);
        }
    }
    void copyConstruct()(const(T)* srcFrom, const(T)* srcTo, T* dstFrom)
    {
        import core.lifetime;
        import core.stdc.string;

        if (QTypeInfo!(T).isComplex) {
            while (srcFrom != srcTo)
                copyEmplace!T(*cast(T*)srcFrom++, *dstFrom++);
        } else {
            memcpy(static_cast!(void*)(dstFrom), static_cast!(const(void)*)(srcFrom), (srcTo - srcFrom) * T.sizeof);
        }
    }
    void destruct(T* from, T* to)
    {
        if (QTypeInfo!T.isComplex) {
            while (from != to) {
                destroy!false(*from++);
            }
        }
    }
    bool isValidIterator(ref const(iterator) i) const
    {
        return !(d.end() < i) && !(i < d.begin());
    }
    extern(C++, class) struct AlignmentDummy {
    private:
 Data header; T[1] array; }
}

/+ #if defined(__cpp_deduction_guides) && __cpp_deduction_guides >= 201606
template <typename InputIterator,
          typename ValueType = typename std::iterator_traits<InputIterator>::value_type,
          QtPrivate::IfIsInputIterator<InputIterator> = true>
QVector(InputIterator, InputIterator) -> QVector<ValueType>;
#endif

#ifdef Q_CC_MSVC
// behavior change: an object of POD type constructed with an initializer of the form ()
// will be default-initialized
#   pragma warning ( push )
#   pragma warning(disable : 4127) // conditional expression is constant
#endif

#if defined(Q_CC_MSVC)
#pragma warning( pop )
#endif
template <typename T>
inline void QVector<T>::insert(int i, T &&t)
{ Q_ASSERT_X(i >= 0 && i <= d->size, "QVector<T>::insert", "index out of range");
  insert(begin() + i, std::move(t)); }template <typename T>
inline void QVector<T>::prepend(T &&t)
{ insert(begin(), std::move(t)); }

#if defined(Q_CC_MSVC)
QT_WARNING_PUSH
QT_WARNING_DISABLE_MSVC(4127) // conditional expression is constant
#endif // Q_CC_MSVC

template <typename T>
QVector<T>::QVector(std::initializer_list<T> args)
{
    if (args.size() > 0) {
        d = Data::allocate(args.size());
        Q_CHECK_PTR(d);
        // std::initializer_list<T>::iterator is guaranteed to be
        // const T* ([support.initlist]/1), so can be memcpy'ed away from by copyConstruct
        copyConstruct(args.begin(), args.end(), d->begin());
        d->size = int(args.size());
    } else {
        d = Data::sharedNull();
    }
}

template <typename T>
QVector<T> &QVector<T>::operator=(std::initializer_list<T> args)
{
    QVector<T> tmp(args);
    tmp.swap(*this);
    return *this;
}

#if defined(Q_CC_MSVC)
QT_WARNING_POP
#endif // Q_CC_MSVC

#if defined(Q_CC_MSVC)
QT_WARNING_PUSH
QT_WARNING_DISABLE_MSVC(4127) // conditional expression is constant
#endif

#if defined(Q_CC_MSVC)
QT_WARNING_POP
#endif

template <typename T>
void QVector<T>::append(T &&t)
{
    const bool isTooSmall = uint(d->size + 1) > d->alloc;
    if (!isDetached() || isTooSmall) {
        QArrayData::AllocationOptions opt(isTooSmall ? QArrayData::Grow : QArrayData::Default);
        realloc(isTooSmall ? d->size + 1 : d->alloc, opt);
    }

    new (d->end()) T(std::move(t));

    ++d->size;
}

template <typename T>
typename QVector<T>::iterator QVector<T>::insert(iterator before, T &&t)
{
    Q_ASSERT_X(isValidIterator(before),  "QVector::insert", "The specified iterator argument 'before' is invalid");

    const auto offset = std::distance(d->begin(), before);
    if (!isDetached() || d->size + 1 > int(d->alloc))
        realloc(d->size + 1, QArrayData::Grow);
    if (!QTypeInfoQuery<T>::isRelocatable) {
        T *i = d->end();
        T *j = i + 1;
        T *b = d->begin() + offset;
        // The new end-element needs to be constructed, the rest must be move assigned
        if (i != b) {
            new (--j) T(std::move(*--i));
            while (i != b)
                *--j = std::move(*--i);
            *b = std::move(t);
        } else {
            new (b) T(std::move(t));
        }
    } else {
        T *b = d->begin() + offset;
        memmove(static_cast<void *>(b + 1), static_cast<const void *>(b), (d->size - offset) * sizeof(T));
        new (b) T(std::move(t));
    }
    d->size += 1;
    return d->begin() + offset;
}

Q_DECLARE_SEQUENTIAL_ITERATOR(Vector)
Q_DECLARE_MUTABLE_SEQUENTIAL_ITERATOR(Vector)

template <typename T>
uint qHash(const QVector<T> &key, uint seed = 0)
    noexcept(noexcept(qHashRange(key.cbegin(), key.cend(), seed)))
{
    return qHashRange(key.cbegin(), key.cend(), seed);
} +/

/+bool operator <(T)(ref const(QVector!(T)) lhs, ref const(QVector!(T)) rhs)
    /+ noexcept(noexcept(std::lexicographical_compare(lhs.begin(), lhs.end(),
                                                               rhs.begin(), rhs.end()))) +/
{
    return /+ std:: +/lexicographical_compare(lhs.begin(), lhs.end(),
                                        rhs.begin(), rhs.end());
}+/

/+pragma(inline, true) bool operator >(T)(ref const(QVector!(T)) lhs, ref const(QVector!(T)) rhs)
    /+ noexcept(noexcept(lhs < rhs)) +/
{
    return rhs < lhs;
}+/

/+pragma(inline, true) bool operator <=(T)(ref const(QVector!(T)) lhs, ref const(QVector!(T)) rhs)
    /+ noexcept(noexcept(lhs < rhs)) +/
{
    return !(lhs > rhs);
}+/

/+pragma(inline, true) bool operator >=(T)(ref const(QVector!(T)) lhs, ref const(QVector!(T)) rhs)
    /+ noexcept(noexcept(lhs < rhs)) +/
{
    return !(lhs < rhs);
}+/

/*
   ### Qt 5:
   ### This needs to be removed for next releases of Qt. It is a workaround for vc++ because
   ### Qt exports QPolygon and QPolygonF that inherit QVector<QPoint> and
   ### QVector<QPointF> respectively.
*/

/+ #if defined(Q_CC_MSVC) && !defined(QT_BUILD_CORE_LIB)
QT_BEGIN_INCLUDE_NAMESPACE
QT_END_INCLUDE_NAMESPACE
extern template class Q_CORE_EXPORT QVector<QPointF>;
extern template class Q_CORE_EXPORT QVector<QPoint>;
#endif +/



