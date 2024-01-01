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
module qt.core.list;
extern(C++):

import qt.config;
import qt.core.arraydata;
import qt.core.arraydataops;
import qt.core.arraydatapointer;
import qt.core.global;
import qt.core.string;
import qt.core.typeinfo;
import qt.helpers;
import std.traits;

/+ extern(C++, "QtPrivate") {
   qsizetype indexOf(V, U)(ref const(QList!(V)) list, ref const(U) u, qsizetype from)/+ noexcept+/;
   qsizetype lastIndexOf(V, U)(ref const(QList!(V)) list, ref const(U) u, qsizetype from)/+ noexcept+/;
} +/

/+ struct QListSpecialMethodsBase(T)
{
protected:
    /+ ~QListSpecialMethodsBase() = default; +/

    alias Self = QList!(T);
    Self* self() { return static_cast!(Self*)(&this); }
    const(Self)* self() const { return static_cast!(const(Self)*)(&this); }

public:
    /+ template <typename AT = T> +/
    qsizetype indexOf(AT)(ref const(AT) t, qsizetype from = 0) const/+ noexcept+/
    {
        return /+ QtPrivate:: +/.indexOf(*self(), t, from);
    }
    /+ template <typename AT = T> +/
    qsizetype lastIndexOf(AT)(ref const(AT) t, qsizetype from = -1) const/+ noexcept+/
    {
        return /+ QtPrivate:: +/.lastIndexOf(*self(), t, from);
    }

    /+ template <typename AT = T> +/
    bool contains(AT)(ref const(AT) t) const/+ noexcept+/
    {
        return self().indexOf(t) != -1;
    }
}
struct QListSpecialMethods(T)
{
    QListSpecialMethodsBase!(T) base0;
    alias base0 this;
protected:
    /+ ~QListSpecialMethods() = default; +/
public:
    /+ using QListSpecialMethodsBase<T>::indexOf; +/
    /+ using QListSpecialMethodsBase<T>::lastIndexOf; +/
    /+ using QListSpecialMethodsBase<T>::contains; +/
} +/
/+ template <> struct QListSpecialMethods<QByteArray>;
template <> struct QListSpecialMethods<QString>;

#ifdef Q_QDOC // define QVector for QDoc
template<typename T> class QVector : public QList<T> {};
#endif +/

/// Binding for C++ class [QList](https://doc.qt.io/qt-6/qlist.html).
extern(C++, class) struct QList(T)
/+ #ifndef Q_QDOC +/

/+ #endif +/
{
private:
    alias Data = QTypedArrayData!(T);
    alias DataOps = QArrayDataOps!(T);
    alias DataPointer = QArrayDataPointer!(T);
    extern(C++, class) struct DisableRValueRefs {}

    DataPointer d;

    /+ template <typename V, typename U> +/ /+ friend qsizetype QtPrivate::indexOf(const QList<V> &list, const U &u, qsizetype from) noexcept; +/
    /+ template <typename V, typename U> +/ /+ friend qsizetype QtPrivate::lastIndexOf(const QList<V> &list, const U &u, qsizetype from) noexcept; +/

public:
    alias Type = T;
    alias value_type = T;
    alias pointer = T*;
    alias const_pointer = const(T)*;
    /+ using reference = T &; +/
    /+ using const_reference = const T &; +/
    alias size_type = qsizetype;
    alias difference_type = qptrdiff;
/+ #ifndef Q_QDOC +/
    //alias parameter_type = DataPointer.parameter_type;
    alias parameter_type = T;
    /+ using rvalue_ref = typename std::conditional<DataPointer::pass_parameter_by_value, DisableRValueRefs, T &&>::type; +/
/+ #else  // simplified aliases for QDoc
    using parameter_type = const T &;
    using rvalue_ref = T &&;
#endif +/

    /// Binding for C++ class [QList::iterator](https://doc.qt.io/qt-6/qlist-iterator.html).
    extern(C++, class) struct iterator {
    private:
        T* i = null;
    public:
        alias difference_type__1 = qsizetype;
        alias value_type__1 = T;
        // libstdc++ shipped with gcc < 11 does not have a fix for defect LWG 3346
/+ #if __cplusplus >= 202002L && (!defined(_GLIBCXX_RELEASE) || _GLIBCXX_RELEASE >= 11)
        using iterator_category = std::contiguous_iterator_tag;
        using element_type = value_type;
#else +/
//        alias iterator_category = /+ std:: +/random_access_iterator_tag;
/+ #endif +/

        alias pointer__1 = T*;
        /+ using reference = T &; +/

        /+ inline constexpr iterator() = default; +/
        pragma(inline, true) this(T* n)
        {
            this.i = n;
        }
        pragma(inline, true) ref T opUnary(string op)() const if (op == "*") { return *cast(T*) i; }
        /+pragma(inline, true) T* operator ->() const { return i; }+/
        //pragma(inline, true) ref T opIndex(qsizetype j) const { return *(i + j); }
        /+pragma(inline, true) bool operator ==(iterator o) const { return i == o.i; }+/
        /+pragma(inline, true) bool operator !=(iterator o) const { return i != o.i; }+/
        /+pragma(inline, true) bool operator <(iterator other) const { return i < other.i; }+/
        /+pragma(inline, true) bool operator <=(iterator other) const { return i <= other.i; }+/
        /+pragma(inline, true) bool operator >(iterator other) const { return i > other.i; }+/
        /+pragma(inline, true) bool operator >=(iterator other) const { return i >= other.i; }+/
        /+pragma(inline, true) bool operator ==(pointer p) const { return i == p; }+/
        /+pragma(inline, true) bool operator !=(pointer p) const { return i != p; }+/
        pragma(inline, true) ref iterator opUnary(string op)() if (op == "++") { ++i; return this; }
        /+pragma(inline, true) iterator operator ++(int) { T* n = i; ++i; return cast(iterator) (n); }+/
        pragma(inline, true) ref iterator opUnary(string op)() if (op == "--") { i--; return this; }
        /+pragma(inline, true) iterator operator --(int) { T* n = i; i--; return cast(iterator) (n); }+/
        pragma(inline, true) qsizetype opBinary(string op)(iterator j) const if (op == "-") { return i - j.i; }
        /+pragma(inline, true) auto opCast(T : T)() const { return i; }+/

        /+ template <typename Int> +/ /+ std::enable_if_t<std::is_integral_v<Int>, iterator>
        &operator+=(Int j) { i+=j; return *this; } +/
        /+ template <typename Int> +/ /+ std::enable_if_t<std::is_integral_v<Int>, iterator>
        &operator-=(Int j) { i-=j; return *this; } +/
        /+ template <typename Int> +/ /+ std::enable_if_t<std::is_integral_v<Int>, iterator>
        operator+(Int j) const { return iterator(i+j); } +/
        /+ template <typename Int> +/ /+ std::enable_if_t<std::is_integral_v<Int>, iterator>
        operator-(Int j) const { return iterator(i-j); } +/
        /+ template <typename Int> +/ /+ friend std::enable_if_t<std::is_integral_v<Int>, iterator>
        operator+(Int j, iterator k) { return k + j; } +/
    }

    /// Binding for C++ class [QList::const_iterator](https://doc.qt.io/qt-6/qlist-const-iterator.html).
    extern(C++, class) struct const_iterator {
    private:
        const(T)* i = null;
    public:
        alias difference_type__1 = qsizetype;
        alias value_type__1 = T;
        // libstdc++ shipped with gcc < 11 does not have a fix for defect LWG 3346
/+ #if __cplusplus >= 202002L && (!defined(_GLIBCXX_RELEASE) || _GLIBCXX_RELEASE >= 11)
        using iterator_category = std::contiguous_iterator_tag;
        using element_type = const value_type;
#else +/
//        alias iterator_category = /+ std:: +/random_access_iterator_tag;
/+ #endif +/
        alias pointer__1 = const(T)*;
        /+ using reference = const T &; +/

        /+ inline constexpr const_iterator() = default; +/
        pragma(inline, true) this(const(T)* n)
        {
            this.i = n;
        }
        /*pragma(inline, true) this(iterator o)
        {
            this.i = o;
        }*/
        pragma(inline, true) ref const(T) opUnary(string op)() const if (op == "*") { return *i; }
        /+pragma(inline, true) const(T)* operator ->() const { return i; }+/
        pragma(inline, true) ref const(T) opIndex(qsizetype j) const { return *(i + j); }
        /+pragma(inline, true) bool operator ==(const_iterator o) const { return i == o.i; }+/
        /+pragma(inline, true) bool operator !=(const_iterator o) const { return i != o.i; }+/
        /+pragma(inline, true) bool operator <(const_iterator other) const { return i < other.i; }+/
        /+pragma(inline, true) bool operator <=(const_iterator other) const { return i <= other.i; }+/
        /+pragma(inline, true) bool operator >(const_iterator other) const { return i > other.i; }+/
        /+pragma(inline, true) bool operator >=(const_iterator other) const { return i >= other.i; }+/
        /+pragma(inline, true) bool operator ==(iterator o) const { return i == const_iterator(o).i; }+/
        /+pragma(inline, true) bool operator !=(iterator o) const { return i != const_iterator(o).i; }+/
        /+pragma(inline, true) bool operator ==(pointer p) const { return i == p; }+/
        /+pragma(inline, true) bool operator !=(pointer p) const { return i != p; }+/
        pragma(inline, true) ref const_iterator opUnary(string op)() if (op == "++") { ++i; return this; }
        /+pragma(inline, true) const_iterator operator ++(int) { const(T)* n = i; ++i; return cast(const_iterator) (n); }+/
        pragma(inline, true) ref const_iterator opUnary(string op)() if (op == "--") { i--; return this; }
        /+pragma(inline, true) const_iterator operator --(int) { const(T)* n = i; i--; return cast(const_iterator) (n); }+/
        pragma(inline, true) qsizetype opBinary(string op)(const_iterator j) const if (op == "-") { return i - j.i; }
        /+pragma(inline, true) auto opCast(T : const(T))() const { return i; }+/
        int opCmp(const const_iterator other) const
        {
            if (i < other.i)
                return -1;
            if (i > other.i)
                return 1;

            return 0;
        }

        /+ template <typename Int> +/ /+ std::enable_if_t<std::is_integral_v<Int>, const_iterator>
        &operator+=(Int j) { i+=j; return *this; } +/
        /+ template <typename Int> +/ /+ std::enable_if_t<std::is_integral_v<Int>, const_iterator>
        &operator-=(Int j) { i-=j; return *this; } +/
        /+ template <typename Int> +/ /+ std::enable_if_t<std::is_integral_v<Int>, const_iterator>
        operator+(Int j) const { return const_iterator(i+j); } +/
        pragma(inline, true) const_iterator opBinary(string op, Int)(Int j) const if (op == "+" && isIntegral!Int) { return const_iterator(i+j); }
        /+ template <typename Int> +/ /+ std::enable_if_t<std::is_integral_v<Int>, const_iterator>
        operator-(Int j) const { return const_iterator(i-j); } +/
        pragma(inline, true) const_iterator opBinary(string op, Int)(Int j) const if (op == "-" && isIntegral!Int) { return const_iterator(i-j); }
        /+ template <typename Int> +/ /+ friend std::enable_if_t<std::is_integral_v<Int>, const_iterator>
        operator+(Int j, const_iterator k) { return k + j; } +/
    }
    alias Iterator = iterator;
    alias ConstIterator = const_iterator;
    /+ using reverse_iterator = std::reverse_iterator<iterator>; +/
    /+ using const_reverse_iterator = std::reverse_iterator<const_iterator>; +/

private:
    pragma(inline, true) void resize_internal()(qsizetype newSize)
    {
        (mixin(Q_ASSERT(q{newSize >= 0})));

        if (d.needsDetach() || newSize > capacity() - d.freeSpaceAtBegin()) {
            d.detachAndGrow(QArrayData.GrowthPosition.GrowsAtEnd, newSize - d.size, null, null);
        } else if (newSize < size()) {
            DataOps.truncate(d, newSize);
        }
    }
    bool isValidIterator(const_iterator i) const
    {
        return i.i < d.end() && i.i >= d.begin();
    }
public:
    this(DataPointer dd)/+ noexcept+/
    {
        this.d = dd;
    }

public:
    /+ QList() = default; +/
    /+ explicit +/this()(qsizetype size)
    {
        this.d = Data.allocate(size);

        if (size)
            DataOps.appendInitialize(d, size);
    }
    this()(qsizetype size, parameter_type t)
    {
        this.d = Data.allocate(size);

        if (size)
            DataOps.copyAppend(d, size, t);
    }

    static QList create()
    {
        return QList.init;
    }

    /+ inline QList(std::initializer_list<T> args)
        : d(Data::allocate(args.size()))
    {
        if (args.size())
            d->copyAppend(args.begin(), args.end());
    } +/

    /+ QList<T> &operator=(std::initializer_list<T> args)
    {
        d = DataPointer(Data::allocate(args.size()));
        if (args.size())
            d->copyAppend(args.begin(), args.end());
        return *this;
    } +/
    /+ template <typename InputIterator, QtPrivate::IfIsInputIterator<InputIterator> = true> +/
    /+ this(InputIterator,)(InputIterator i1, InputIterator i2)
    {
        static if (!/+ std:: +/is_convertible_v!(UnknownType!q{/+ std:: +/iterator_traits!(InputIterator).iterator_category}, /+ std:: +/forward_iterator_tag)) {
            /+ std:: +/copy(i1, i2, /+ std:: +/back_inserter(this));
        } else {
            const distance = /+ std:: +/distance(i1, i2);
            if (distance) {
                d = DataPointer(Data.allocate(distance));
                static if (/+ std:: +/is_same_v!(/+ std:: +/decay_t!(InputIterator), iterator) ||
                              /+ std:: +/is_same_v!(/+ std:: +/decay_t!(InputIterator), const_iterator)) {
                    d.copyAppend(i1, i2);
                } else {
                    d.appendIteratorRange(i1, i2);
               }
            }
        }
    } +/

    // This constructor is here for compatibility with QStringList in Qt 5, that has a QStringList(const QString &) constructor
    /+ template<typename String, typename = std::enable_if_t<std::is_same_v<T, QString> && std::is_convertible_v<String, QString>>> +/
    /+ /+ explicit +/pragma(inline, true) this(String,)(ref const(String) str)
    { append(str); } +/

    // compiler-generated special member functions are fine!

    /+ void swap(QList<T> &other) noexcept { qSwap(d, other.d); } +/

/+ #ifndef Q_CLANG_QDOC +/
    /+ template <typename U = T> +/
    /+/+ QTypeTraits:: +/qt.core.typeinfo.compare_eq_result_container!(QList, U) operator ==(U)(ref const(QList) other) const
    {
        if (size() != other.size())
            return cast(qt.core.typeinfo.compare_eq_result_container!(QList, U)) (false);
        if (begin() == other.begin())
            return cast(qt.core.typeinfo.compare_eq_result_container!(QList, U)) (true);

        // do element-by-element comparison
        return d.compare(begin(), other.begin(), size());
    }+/
    /+ template <typename U = T> +/
    /+/+ QTypeTraits:: +/qt.core.typeinfo.compare_eq_result_container!(QList, U) operator !=(U)(ref const(QList) other) const
    {
        return !(this == other);
    }+/

    /+ template <typename U = T> +/
    /+/+ QTypeTraits:: +/qt.core.typeinfo.compare_lt_result_container!(QList, U) operator <(U)(ref const(QList) other) const
            /+ noexcept(noexcept(std::lexicographical_compare<typename QList<U>::const_iterator,
                                                           typename QList::const_iterator>(
                                std::declval<QList<U>>().begin(), std::declval<QList<U>>().end(),
                                other.begin(), other.end()))) +/
    {
        return cast(qt.core.typeinfo.compare_lt_result_container!(QList, U)) (/+ std:: +/lexicographical_compare(begin(), end(),
                                            other.begin(), other.end()));
    }+/

    /+ template <typename U = T> +/
    /+/+ QTypeTraits:: +/qt.core.typeinfo.compare_lt_result_container!(QList, U) operator >(U)(ref const(QList) other) const
            /+ noexcept(noexcept(other < std::declval<QList<U>>())) +/
    {
        return cast(qt.core.typeinfo.compare_lt_result_container!(QList, U)) (other < this);
    }+/

    /+ template <typename U = T> +/
    /+/+ QTypeTraits:: +/qt.core.typeinfo.compare_lt_result_container!(QList, U) operator <=(U)(ref const(QList) other) const
            /+ noexcept(noexcept(other < std::declval<QList<U>>())) +/
    {
        return !(other < this);
    }+/

    /+ template <typename U = T> +/
    /+/+ QTypeTraits:: +/qt.core.typeinfo.compare_lt_result_container!(QList, U) operator >=(U)(ref const(QList) other) const
            /+ noexcept(noexcept(std::declval<QList<U>>() < other)) +/
    {
        return !(this < other);
    }+/
/+ #else
    bool operator==(const QList &other) const;
    bool operator!=(const QList &other) const;
    bool operator<(const QList &other) const;
    bool operator>(const QList &other) const;
    bool operator<=(const QList &other) const;
    bool operator>=(const QList &other) const;
#endif +/ // Q_CLANG_QDOC

    qsizetype size() const/+ noexcept+/ { return d.size; }
    qsizetype count() const/+ noexcept+/ { return size(); }
    qsizetype length() const/+ noexcept+/ { return size(); }

    pragma(inline, true) bool isEmpty() const/+ noexcept+/ { return d.size == 0; }

    void resize()(qsizetype size)
    {
        resize_internal(size);
        if (size > this.size())
            DataOps.appendInitialize(d, size);
    }
    void resize()(qsizetype size, parameter_type c)
    {
        resize_internal(size);
        if (size > this.size())
            DataOps.copyAppend(d, size - this.size(), c);
    }

    pragma(inline, true) qsizetype capacity() const { return qsizetype(d.constAllocatedCapacity()); }
/+    void reserve(qsizetype asize)
    {
        // capacity() == 0 for immutable data, so this will force a detaching below
        if (asize <= capacity() - d.freeSpaceAtBegin()) {
            if (d.flags() & Data.CapacityReserved)
                return;  // already reserved, don't shrink
            if (!d.isShared()) {
                // accept current allocation, don't shrink
                d.setFlag(Data.CapacityReserved);
                return;
            }
        }

        static if (#configValue!"merged")
        {
        auto detached = DataPointer(Data.allocate(qMax(asize, size())));
        }
    static if (#configValue!"merged")
    {
    DataPointer detached__1();
    }
        detached__1.copyAppend(constBegin(), constEnd());
        if (detached__1.d_ptr())
            detached__1.setFlag(Data.CapacityReserved);
        d.swap(detached__1);
    }+/
/+    pragma(inline, true) void squeeze()
    {
        if (!d.isMutable())
            return;
        if (d.needsDetach() || size() < capacity()) {
            // must allocate memory
            static if (#configValue!"merged")
            {
            auto detached = DataPointer(Data.allocate(size()));
            }
    static if (#configValue!"merged")
    {
    DataPointer detached__1();
    }
            if (size()) {
                if (d.needsDetach())
                    detached__1.copyAppend(constBegin(), constEnd());
                else
                    detached__1.moveAppend(d.data(), d.data() + d.size);
            }
            d.swap(detached__1);
        }
        // We're detached so this is fine
        d.clearFlag(Data.CapacityReserved);
    }+/

    void detach()() { d.detach(); }
    bool isDetached() const/+ noexcept+/ { return !d.isShared(); }

    pragma(inline, true) bool isSharedWith(ref const(QList!(T)) other) const { return d == other.d; }

    pointer data()() { detach(); return d.data(); }
    const_pointer data() const/+ noexcept+/ { return d.data(); }
    const_pointer constData() const/+ noexcept+/ { return d.data(); }
    void clear() {
        if (!size())
            return;
        if (d.needsDetach()) {
            // must allocate memory
            auto detached = DataPointer(Data.allocate(d.allocatedCapacity()));
            d.swap(detached);
        } else {
            DataOps.truncate(d, 0);
        }
    }

    ref const(T) at(qsizetype i) const/+ noexcept+/
    {
        (mixin(Q_ASSERT_X(q{size_t(i) < size_t(QList.d.size)},q{ "QList::at"},q{ "index out of range"})));
        return data()[i];
    }
    ref T opIndex()(qsizetype i)
    {
        (mixin(Q_ASSERT_X(q{size_t(i) < size_t(QList.d.size)},q{ "QList::operator[]"},q{ "index out of range"})));
        detach();
        return data()[i];
    }
    ref const(T) opIndex(qsizetype i) const/+ noexcept+/ { return at(i); }
    void append()(parameter_type t) { emplaceBack(t); }
    /*pragma(inline, true) void append(const_iterator i1, const_iterator i2)
    {
        DataOps.growAppend(d, i1, i2);
    }*/
/+    void append(rvalue_ref t)
    {
        static if (DataPointer.pass_parameter_by_value) {
            /+ Q_UNUSED(t) +/
        } else {
            emplaceBack(/+ std:: +/move(t));
        }
    }+/
    /+void append(ref const(QList!(T)) l)
    {
        append(l.constBegin(), l.constEnd());
    }+/
    /+ void append(QList<T> &&l); +/
/+    void prepend(rvalue_ref t) {
        static if (DataPointer.pass_parameter_by_value) {
            /+ Q_UNUSED(t) +/
        } else {
            emplaceFront(/+ std:: +/move(t));
        }
    }+/
    //void prepend(parameter_type t) { emplaceFront(t); }

    /+ template<typename... Args> +/
    pragma(inline, true) ref T emplaceBack(Args...)(auto ref Args /+ && +/ args)
    {
        DataOps.emplace(d, d.size, args /*/+ std:: +/forward!(Args)(args)...*/);
        return *(d.end() - 1);
    }

    /+ template <typename ...Args> +/
    pragma(inline, true) ref T emplaceFront(Args...)(auto ref Args /+ && +/ args)
    {
        DataOps.emplace(d, 0, args /*/+ std:: +/forward!(Args)(args)...*/);
        return *d.begin();
    }

    /+iterator insert(qsizetype i, parameter_type t)
    { return emplace(i, t); }+/
    /+pragma(inline, true) iterator insert(qsizetype i, qsizetype n, parameter_type t)
    {
        (mixin(Q_ASSERT_X(q{size_t(i) <= size_t(QList.d.size)},q{ "QList<T>::insert"},q{ "index out of range"})));
        (mixin(Q_ASSERT_X(q{n >= 0},q{ "QList::insert"},q{ "invalid count"})));
        if (/+ Q_LIKELY +/(n))
            d.insert(i, n, t);
        return d.begin() + i;
    }+/
/+    iterator insert(const_iterator before, parameter_type t)
    {
        (mixin(Q_ASSERT_X(q{QList.isValidIterator(before)},q{  "QList::insert"},q{ "The specified iterator argument 'before' is invalid"})));
        return insert(before, 1, t);
    }
    iterator insert(const_iterator before, qsizetype n, parameter_type t)
    {
        (mixin(Q_ASSERT_X(q{QList.isValidIterator(before)},q{  "QList::insert"},q{ "The specified iterator argument 'before' is invalid"})));
        return insert(/+ std:: +/distance(constBegin(), before), n, t);
    }+/
/+    iterator insert(const_iterator before, rvalue_ref t)
    {
        (mixin(Q_ASSERT_X(q{QList.isValidIterator(before)},q{  "QList::insert"},q{ "The specified iterator argument 'before' is invalid"})));
        return insert(/+ std:: +/distance(constBegin(), before), /+ std:: +/move(t));
    }
    iterator insert(qsizetype i, rvalue_ref t) {
        static if (DataPointer.pass_parameter_by_value) {
            /+ Q_UNUSED(i) +/
            /+ Q_UNUSED(t) +/
            return end();
        } else {
            return emplace(i, /+ std:: +/move(t));
        }
    }+/

    /+ template <typename ...Args> +/
    /+ iterator emplace(Args)(const_iterator before, Args && /+ && +/ args)
    {
        (mixin(Q_ASSERT_X(q{QList.isValidIterator(before)},q{  "QList::emplace"},q{ "The specified iterator argument 'before' is invalid"})));
        return emplace(/+ std:: +/distance(constBegin(), before), /+ std:: +/forward!(Args)(args)...);
    } +/

    /+ template <typename ...Args> +/
    iterator emplace(Args...)(qsizetype i, auto ref Args /+ && +/ args)
    {
        mixin(Q_ASSERT_X(q{i >= 0 && i <= d.size},q{ "QList<T>::insert"},q{ "index out of range"}));
        DataOps.emplace(d, i, args /*std::forward<Args>(args)...*/);
        return d.begin() + i;
    }
/+ #if 0
    template< class InputIt >
    iterator insert( const_iterator pos, InputIt first, InputIt last );
    iterator insert( const_iterator pos, std::initializer_list<T> ilist );
#endif +/
    void replace()(qsizetype i, parameter_type t)
    {
        (mixin(Q_ASSERT_X(q{i >= 0 && i < QList.d.size},q{ "QList<T>::replace"},q{ "index out of range"})));
        DataPointer oldData;
        d.detach(&oldData);
        d.data()[i] = t;
    }
/+    void replace(qsizetype i, rvalue_ref t)
    {
        static if (DataPointer.pass_parameter_by_value) {
            /+ Q_UNUSED(i) +/
            /+ Q_UNUSED(t) +/
        } else {
            (mixin(Q_ASSERT_X(q{i >= 0 && i < QList.d.size},q{ "QList<T>::replace"},q{ "index out of range"})));
            DataPointer oldData;
            d.detach(&oldData);
            d.data()[i] = /+ std:: +/move(t);
        }
    }+/

/+    pragma(inline, true) void remove(qsizetype i, qsizetype n = 1)
    {
        (mixin(Q_ASSERT_X(q{size_t(i) + size_t(n) <= size_t(QList.d.size)},q{ "QList::remove"},q{ "index out of range"})));
        (mixin(Q_ASSERT_X(q{n >= 0},q{ "QList::remove"},q{ "invalid count"})));

        if (n == 0)
            return;

        d.detach();
        d.erase(d.begin() + i, n);
    }+/
/+    pragma(inline, true) void removeFirst()/+ noexcept+/
    {
        (mixin(Q_ASSERT(q{!QList.isEmpty()})));
        d.detach();
        d.eraseFirst();
    }
    pragma(inline, true) void removeLast()/+ noexcept+/
    {
        (mixin(Q_ASSERT(q{!QList.isEmpty()})));
        d.detach();
        d.eraseLast();
    }
    value_type takeFirst() { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); value_type v = /+ std:: +/move(first()); d.eraseFirst(); return v; }
    value_type takeLast() { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); value_type v = /+ std:: +/move(last()); d.eraseLast(); return v; }
+/
    pragma(inline, true) ref QList!(T) fill()(parameter_type t, qsizetype newSize = -1)
    {
        if (newSize == -1)
            newSize = size();
        if (d.needsDetach() || newSize > capacity()) {
            // must allocate memory
            auto detached = DataPointer(Data.allocate(d.detachCapacity(newSize)));
            DataOps.copyAppend(detached, newSize, t);
            d.swap(detached);
        } else {
            // we're detached
            auto copy = t;
            DataOps.assign(d, d.begin(), d.begin() + qMin(size(), newSize), t);
            if (newSize > size()) {
                DataOps.copyAppend(d, newSize - size(), copy);
            } else if (newSize < size()) {
                DataOps.truncate(d, newSize);
            }
        }
        return this;
    }

/+ #ifndef Q_QDOC +/
    /+ using QListSpecialMethods<T>::contains; +/
    /+ using QListSpecialMethods<T>::indexOf; +/
    /+ using QListSpecialMethods<T>::lastIndexOf; +/
/+ #else
    template <typename AT>
    qsizetype indexOf(const AT &t, qsizetype from = 0) const noexcept;
    template <typename AT>
    qsizetype lastIndexOf(const AT &t, qsizetype from = -1) const noexcept;
    template <typename AT>
    bool contains(const AT &t) const noexcept;
#endif +/

    /+ template <typename AT = T> +/
    qsizetype count(AT)(ref const(AT) t) const/+ noexcept+/
    {
        return qsizetype(/+ std:: +/count(data(), data() + size(), t));
    }

    //void removeAt(qsizetype i) { remove(i); }
    /+ template <typename AT = T> +/
    qsizetype removeAll(AT)(ref const(AT) t)
    {
        import qt.core.containertools_impl;

        return /+ QtPrivate:: +/qt.core.containertools_impl.sequential_erase_with_copy(this, t);
    }

    /+ template <typename AT = T> +/
    bool removeOne(AT)(ref const(AT) t)
    {
        import qt.core.containertools_impl;

        return (/+ QtPrivate:: +/qt.core.containertools_impl.sequential_erase_one(this, t)) != 0;
    }

    /+ template <typename Predicate> +/
    qsizetype removeIf(Predicate)(Predicate pred)
    {
        import qt.core.containertools_impl;

        return /+ QtPrivate:: +/qt.core.containertools_impl.sequential_erase_if(this, pred);
    }

    //T takeAt(qsizetype i) { T t = /+ std:: +/move((this)[i]); remove(i); return t; }
    /+void move(qsizetype from, qsizetype to)
    {
        (mixin(Q_ASSERT_X(q{from >= 0 && from < QList.size()},q{ "QList::move(qsizetype, qsizetype)"},q{ "'from' is out-of-range"})));
        (mixin(Q_ASSERT_X(q{to >= 0 && to < QList.size()},q{ "QList::move(qsizetype, qsizetype)"},q{ "'to' is out-of-range"})));
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
    iterator begin()() { detach(); return iterator(d.begin()); }
    iterator end()() { detach(); return iterator(d.end()); }

    const_iterator begin() const/+ noexcept+/ { return const_iterator(d.constBegin()); }
    const_iterator end() const/+ noexcept+/ { return const_iterator(d.constEnd()); }
    const_iterator cbegin() const/+ noexcept+/ { return const_iterator(d.constBegin()); }
    const_iterator cend() const/+ noexcept+/ { return const_iterator(d.constEnd()); }
    const_iterator constBegin() const/+ noexcept+/ { return const_iterator(d.constBegin()); }
    const_iterator constEnd() const/+ noexcept+/ { return const_iterator(d.constEnd()); }
    /+ reverse_iterator rbegin() { return reverse_iterator(end()); } +/
    /+ reverse_iterator rend() { return reverse_iterator(begin()); } +/
    /+ const_reverse_iterator rbegin() const noexcept { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator rend() const noexcept { return const_reverse_iterator(begin()); } +/
    /+ const_reverse_iterator crbegin() const noexcept { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator crend() const noexcept { return const_reverse_iterator(begin()); } +/

    auto opSlice()()const
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
                ++i;
            }
        }
        auto this_ = cast(QList*)&this;
        return R(this_.begin(), this_.end());
    }

/+    iterator erase(const_iterator abegin, const_iterator aend)
    {
        (mixin(Q_ASSERT_X(q{QList.isValidIterator(abegin)},q{ "QList::erase"},q{ "The specified iterator argument 'abegin' is invalid"})));
        (mixin(Q_ASSERT_X(q{QList.isValidIterator(aend)},q{ "QList::erase"},q{ "The specified iterator argument 'aend' is invalid"})));
        (mixin(Q_ASSERT(q{aend >= abegin})));

        qsizetype i = /+ std:: +/distance(constBegin(), abegin);
        qsizetype n = /+ std:: +/distance(abegin, aend);
        remove(i, n);

        return d.begin() + i;
    }+/
//    pragma(inline, true) iterator erase(const_iterator pos) { return erase(pos, cast(const_iterator) (pos+1)); }

    // more Qt
    pragma(inline, true) ref T first()() { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); return *begin(); }
    pragma(inline, true) ref const(T) first()() const/+ noexcept+/ { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); return *begin(); }
    pragma(inline, true) ref const(T) constFirst()() const/+ noexcept+/ { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); return *begin(); }
//    pragma(inline, true) ref T last() { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); return *(end()-1); }
//    pragma(inline, true) ref const(T) last() const/+ noexcept+/ { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); return *(end()-1); }
//    pragma(inline, true) ref const(T) constLast() const/+ noexcept+/ { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); return *(end()-1); }
//    pragma(inline, true) bool startsWith(parameter_type t) const { return !isEmpty() && first() == t; }
//    pragma(inline, true) bool endsWith(parameter_type t) const { return !isEmpty() && last() == t; }
/+    pragma(inline, true) QList!(T) mid(qsizetype pos, qsizetype len = -1) const
    {
        qsizetype p = pos;
        qsizetype l = len;
        //using namespace QtPrivate;
        switch (QContainerImplHelper.mid(d.size, &p, &l)) {
        case QContainerImplHelper.Null:
        case QContainerImplHelper.Empty:
            return QList();
        case QContainerImplHelper.Full:
            return this;
        case QContainerImplHelper.Subset:
            break;default:

        }

        // Allocate memory
        static if (#configValue!"merged")
        {
        auto copied = DataPointer(Data.allocate(l));
        }
    static if (#configValue!"merged")
    {
    DataPointer copied__1();
    }
        copied__1.copyAppend(constBegin() + p, constBegin() + p + l);
        return cast(QList!(T)) (copied__1);
    }+/

/+    QList!(T) first(qsizetype n) const
    {
        (mixin(Q_ASSERT(q{size_t(n) <= size_t(QList.size())})));
        return QList!(T)(begin(), begin() + n);
    }
    QList!(T) last(qsizetype n) const
    {
        (mixin(Q_ASSERT(q{size_t(n) <= size_t(QList.size())})));
        return QList!(T)(end() - n, end());
    }+/
/+    QList!(T) sliced(qsizetype pos) const
    {
        (mixin(Q_ASSERT(q{size_t(pos) <= size_t(QList.size())})));
        return QList!(T)(begin() + pos, end());
    }
    QList!(T) sliced(qsizetype pos, qsizetype n) const
    {
        (mixin(Q_ASSERT(q{size_t(pos) <= size_t(QList.size())})));
        (mixin(Q_ASSERT(q{n >= 0})));
        (mixin(Q_ASSERT(q{pos + n <= QList.size()})));
        return QList!(T)(begin() + pos, begin() + pos + n);
    }+/

//    T value(qsizetype i) const { return value(i, T()); }
    /+pragma(inline, true) T value(qsizetype i, parameter_type defaultValue) const
    {
        return size_t(i) < size_t(d.size) ? at(i) : defaultValue;
    }+/

    void swapItemsAt()(qsizetype i, qsizetype j) {
        (mixin(Q_ASSERT_X(q{i >= 0 && i < QList.size() && j >= 0 && j < QList.size()},q{
                    "QList<T>::swap"},q{ "index out of range"})));
        detach();
        qt.core.arraydatapointer.qSwap(d.begin()[i], d.begin()[j]);
    }

    // STL compatibility
//    pragma(inline, true) void push_back(parameter_type t) { append(t); }
    //void push_back(rvalue_ref t) { append(/+ std:: +/move(t)); }
    //void push_front(rvalue_ref t) { prepend(/+ std:: +/move(t)); }
//    pragma(inline, true) void push_front(parameter_type t) { prepend(t); }
//    void pop_back()/+ noexcept+/ { removeLast(); }
//    void pop_front()/+ noexcept+/ { removeFirst(); }

    /+ template <typename ...Args> +/
    // reference emplace_back(Args)(Args && /+ && +/ args) { return emplaceBack(/+ std:: +/forward!(Args)(args)...); }

    pragma(inline, true) bool empty() const/+ noexcept+/
    { return d.size == 0; }
//    pragma(inline, true) ref T front() { return first(); }
//    pragma(inline, true) ref const(T) front() const/+ noexcept+/ { return first(); }
//    pragma(inline, true) ref T back() { return last(); }
//    pragma(inline, true) ref const(T) back() const/+ noexcept+/ { return last(); }
//    void shrink_to_fit() { squeeze(); }

    // comfort
    extern(D) ref QList!(T) opOpAssign(string op)(ref const(QList!(T)) l) if (op == "~") { append(l); return this; }
    /+ QList<T> &operator+=(QList<T> &&l) { append(std::move(l)); return *this; } +/
    extern(D) pragma(inline, true) QList!(T) opBinary(string op)(ref const(QList!(T)) l) const if (op == "~")
    { QList n = this; n ~= l; return n; }
    /+ inline QList<T> operator+(QList<T> &&l) const
    { QList n = *this; n += std::move(l); return n; } +/
    extern(D) pragma(inline, true) ref QList!(T) opOpAssign(string op)(parameter_type t) if (op == "~")
    { append(t); return this; }
    /+pragma(inline, true) ref QList!(T) operator << (parameter_type t)
    { append(t); return this; }+/
    /+pragma(inline, true) ref QList!(T) operator <<(ref const(QList!(T)) l)
    { this += l; return this; }+/
    /+ inline QList<T> &operator<<(QList<T> &&l)
    { *this += std::move(l); return *this; } +/
    /+extern(D) pragma(inline, true) ref QList!(T) opOpAssign(string op)(rvalue_ref t) if (op == "~")
    { append(/+ std:: +/move(t)); return this; }+/
    /+pragma(inline, true) ref QList!(T) operator <<(rvalue_ref t)
    { append(/+ std:: +/move(t)); return this; }+/

    // Consider deprecating in 6.4 or later
//    static QList!(T) fromList(ref const(QList!(T)) list)/+ noexcept+/ { return list; }
//    QList!(T) toList() const/+ noexcept+/ { return this; }

//    pragma(inline, true) static QList!(T) fromVector(ref const(QList!(T)) vector)/+ noexcept+/ { return vector; }
//    pragma(inline, true) QList!(T) toVector() const/+ noexcept+/ { return this; }

    /+ template<qsizetype N> +/
    /+ static QList!(T) fromReadOnlyData(qsizetype N)(ref const(T)[N] t)/+ noexcept+/
    {
        return QList!(T)({ null, const_cast!(T*)(t), N} );
    } +/

    /+ template <typename AT = T> +/
    qsizetype indexOf(AT)(ref const(AT) t, qsizetype from = 0) const/+ noexcept+/
    {
        return /+ QtPrivate:: +/.indexOf(this, t, from);
    }
    /+ template <typename AT = T> +/
    qsizetype lastIndexOf(AT)(ref const(AT) t, qsizetype from = -1) const/+ noexcept+/
    {
        return /+ QtPrivate:: +/.lastIndexOf(this, t, from);
    }

    /+ template <typename AT = T> +/
    bool contains(AT)(ref const(AT) t) const/+ noexcept+/
    {
        return this.indexOf(t) != -1;
    }
}

/+ #if defined(__cpp_deduction_guides) && __cpp_deduction_guides >= 201606
template <typename InputIterator,
          typename ValueType = typename std::iterator_traits<InputIterator>::value_type,
          QtPrivate::IfIsInputIterator<InputIterator> = true>
QList(InputIterator, InputIterator) -> QList<ValueType>;
#endif


template <typename T>
inline void QList<T>::append(QList<T> &&other)
{
    Q_ASSERT(&other != this);
    if (other.isEmpty())
        return;
    if (other.d->needsDetach() || !std::is_nothrow_move_constructible_v<T>)
        return append(other);

    // due to precondition &other != this, we can unconditionally modify 'this'
    d.detachAndGrow(QArrayData::GrowsAtEnd, other.size(), nullptr, nullptr);
    Q_ASSERT(d.freeSpaceAtEnd() >= other.size());
    d->moveAppend(other.begin(), other.end());
} +/


extern(C++, "QtPrivate") {
qsizetype indexOf(T, U)(ref const(QList!(T)) vector, ref const(U) u, qsizetype from)/+ noexcept+/
{
    if (from < 0)
        from = qMax(from + vector.size(), qsizetype(0));
    if (from < vector.size()) {
        auto n = vector.begin() + from - 1;
        auto e = vector.end();
        while (++n != e)
            if (*n == u)
                return qsizetype(n - vector.begin());
    }
    return -1;
}

qsizetype lastIndexOf(T, U)(ref const(QList!(T)) vector, ref const(U) u, qsizetype from)/+ noexcept+/
{
    if (from < 0)
        from += vector.d.size;
    else if (from >= vector.size())
        from = vector.size() - 1;
    if (from >= 0) {
        auto b = vector.begin();
        auto n = vector.begin() + from + 1;
        while (n != b) {
            if (*--n == u)
                return qsizetype(n - b);
        }
    }
    return -1;
}
}

/+ Q_DECLARE_SEQUENTIAL_ITERATOR(List)
Q_DECLARE_MUTABLE_SEQUENTIAL_ITERATOR(List)

template <typename T>
size_t qHash(const QList<T> &key, size_t seed = 0)
    noexcept(noexcept(qHashRange(key.cbegin(), key.cend(), seed)))
{
    return qHashRange(key.cbegin(), key.cend(), seed);
} +/

qsizetype erase(T, AT)(ref QList!(T) list, ref const(AT) t)
{
    import qt.core.containertools_impl;

    return /+ QtPrivate:: +/qt.core.containertools_impl.sequential_erase(list, t);
}

qsizetype erase_if(T, Predicate)(ref QList!(T) list, Predicate pred)
{
    import qt.core.containertools_impl;

    return /+ QtPrivate:: +/qt.core.containertools_impl.sequential_erase_if(list, pred);
}

