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
import qt.core.global;
import qt.core.refcount;
import qt.core.vector;
import qt.core.typeinfo;
import qt.helpers;

/+ #if QT_VERSION < QT_VERSION_CHECK(6,0,0)
#endif

#ifdef Q_CC_MSVC
#pragma warning( push )
#pragma warning( disable : 4127 ) // "conditional expression is constant"
#endif


template <typename T> class QSet; +/

struct QListSpecialMethods(T)
{
protected:
    /+ ~QListSpecialMethods() = default; +/
}
/+ template <> struct QListSpecialMethods<QByteArray>;
template <> struct QListSpecialMethods<QString>; +/

struct /+ Q_CORE_EXPORT +/ QListData {
    // tags for tag-dispatching of QList implementations,
    // based on QList's three different memory layouts:
    struct NotArrayCompatibleLayout {}
    struct NotIndirectLayout {}
    struct ArrayCompatibleLayout {
        NotIndirectLayout base0;
        alias base0 this;
}                           // data laid out like a C array
    struct InlineWithPaddingLayout {
        NotArrayCompatibleLayout base0;
        alias base0 this;
        NotIndirectLayout base1;
} // data laid out like a C array with padding
    struct IndirectLayout {
        NotArrayCompatibleLayout base0;
        alias base0 this;
}                    // data allocated on the heap

    struct Data {
        /+ QtPrivate:: +/qt.core.refcount.RefCount ref_;
        int alloc; int begin; int end;
        void*[1] array;
    }
    enum { DataHeaderSize = Data.sizeof - (void*).sizeof }

    Data* detach(int alloc);
    Data* detach_grow(int* i, int n);
    void realloc(int alloc);
    void realloc_grow(int growth);
    pragma(inline, true) void dispose() { dispose(d); }
    static void dispose(Data* d);
    mixin(mangleWindows("?shared_null@QListData@@2UData@1@B", exportOnWindows ~ q{
    extern static __gshared Data shared_null;
    }));
    Data* d;
    void** erase(void** xi);
    void** append(int n);
    void** append();
    void** append(ref const(QListData) l);
    void** prepend();
    void** insert(int i);
    void remove(int i);
    void remove(int i, int n);
    void move(int from, int to);
    pragma(inline, true) int size() const/+ noexcept+/ { return int(d.end - d.begin); }   // q6sizetype
    pragma(inline, true) bool isEmpty() const/+ noexcept+/ { return d.end  == d.begin; }
    pragma(inline, true) void** at(int i) const/+ noexcept+/ { return cast(void**)(d.array.ptr + d.begin + i); }
    pragma(inline, true) void** begin() const/+ noexcept+/ { return cast(void**)(d.array.ptr + d.begin); }
    pragma(inline, true) void** end() const/+ noexcept+/ { return cast(void**)(d.array.ptr + d.end); }
}

extern(C++, "QtPrivate") {
//    int indexOf(V, U)(ref const(QList!(V)) list, ref const(U) u, int from);
//    int lastIndexOf(V, U)(ref const(QList!(V)) list, ref const(U) u, int from);
}

/// Binding for C++ class [QList](https://doc.qt.io/qt-5/qlist.html).
extern(C++, class) struct QList(T)
/+ #ifndef Q_QDOC +/

/+ #endif +/
{
    /+public QListSpecialMethods!(T) base0;
    alias base0 this;+/
public:
    /+ struct MemoryLayout
        : std::conditional<
            // must stay isStatic until ### Qt 6 for BC reasons (don't use !isRelocatable)!
            QTypeInfo<T>::isStatic || QTypeInfo<T>::isLarge,
            QListData::IndirectLayout,
            typename std::conditional<
                sizeof(T) == sizeof(void*),
                QListData::ArrayCompatibleLayout,
                QListData::InlineWithPaddingLayout
             >::type>::type {}; +/
private:
    /+ template <typename V, typename U> +/ /+ friend int QtPrivate::indexOf(const QList<V> &list, const U &u, int from); +/
    /+ template <typename V, typename U> +/ /+ friend int QtPrivate::lastIndexOf(const QList<V> &list, const U &u, int from); +/
    struct Node { void* v;
        ref T t()
        {
            static if(QTypeInfo!T.isLarge || QTypeInfo!T.isStatic)
                return *reinterpret_cast!(T*)(v);
            else
                return *reinterpret_cast!(T*)(&this);
        }
    }

    version(Windows)
        union { QListData.Data * d; QListData p; }
    else
        union { QListData.Data * d = &QListData.shared_null; QListData p; }


public:
    version(Windows)
    {
        @disable this();
        pragma(inline, true) void rawConstructor()/+ noexcept+/
        {
            this.d = const_cast!(QListData.Data*)(&QListData.shared_null);
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

    this(this)
    {
        if (!d.ref_.ref_()) {
            auto orig = p;
            p.detach(d.alloc);

            /+ QT_TRY +/ {
                 /+ QT_CATCH(...) +/scope(failure) {
                    QListData.dispose(d);
                }
                node_copy(reinterpret_cast!(Node*)(p.begin()),
                        reinterpret_cast!(Node*)(p.end()),
                        reinterpret_cast!(Node*)(orig.begin()));
            }
        }
    }
    ~this()
    {
        if (!d.ref_.deref())
            dealloc(d);
    }
    /+pragma(inline, true) ref QList!(T) operator =(ref const(QList!(T)) l)
    {
        if (d != l.d) {
            QList<T> tmp(l);
            tmp.swap(this);
        }
        return this;
    }+/
    /+ inline QList(QList<T> &&other) noexcept
        : d(other.d) { other.d = const_cast<QListData::Data *>(&QListData::shared_null); } +/
    /+ inline QList &operator=(QList<T> &&other) noexcept
    { QList moved(std::move(other)); swap(moved); return *this; } +/
    /+ inline void swap(QList<T> &other) noexcept { qSwap(d, other.d); } +/
    /+ inline QList(std::initializer_list<T> args)
        : QList(args.begin(), args.end()) {} +/
    /+ template <typename InputIterator, QtPrivate::IfIsInputIterator<InputIterator> = true> +/
    this(InputIterator,)(InputIterator first, InputIterator last);
    /+bool operator ==(ref const(QList!(T)) l) const
    {
        if (d == l.d)
            return true;
        if (p.size() != l.p.size())
            return false;
        return this.op_eq_impl(l, MemoryLayout());
    }+/
    /+pragma(inline, true) bool operator !=(ref const(QList!(T)) l) const { return !(this == l); }+/

    pragma(inline, true) int size() const/+ noexcept+/ { return p.size(); }

    pragma(inline, true) void detach() { if (d.ref_.isShared()) detach_helper(); }

    pragma(inline, true) void detachShared()
    {
        // The "this->" qualification is needed for GCCE.
        if (d.ref_.isShared() && this.d != &QListData.shared_null)
            detach_helper();
    }

    pragma(inline, true) bool isDetached() const { return !d.ref_.isShared(); }
    version(QT_NO_UNSHARABLE_CONTAINERS){}else
    {
        pragma(inline, true) void setSharable(bool sharable)
        {
            if (sharable == d.ref_.isSharable())
                return;
            if (!sharable)
                detach();
            if (d != &QListData.shared_null)
                d.ref_.setSharable(sharable);
        }
    }
    pragma(inline, true) bool isSharedWith(ref const(QList!(T)) other) const/+ noexcept+/ { return d == other.d; }

    pragma(inline, true) bool isEmpty() const/+ noexcept+/ { return p.isEmpty(); }

    void clear()
    {
        this = QList!(T).create();
    }

    pragma(inline, true) ref const(T) at(int i) const
    { (mixin(Q_ASSERT_X(q{i >= 0 && i < p.size()},q{ "QList<T>::at"},q{ "index out of range"})));
     return reinterpret_cast!(Node*)(p.at(i)).t(); }
    pragma(inline, true) ref const(T) opIndex(int i) const
    { (mixin(Q_ASSERT_X(q{i >= 0 && i < p.size()},q{ "QList<T>::operator[]"},q{ "index out of range"})));
     return reinterpret_cast!(Node*)(p.at(i)).t(); }
    pragma(inline, true) ref T opIndex()(int i)
    { (mixin(Q_ASSERT_X(q{i >= 0 && i < p.size()},q{ "QList<T>::operator[]"},/*what*/q{ "index out of range"})));
      detach(); return reinterpret_cast!(Node*)(p.at(i)).t(); }

    void reserve(int alloc)
    {
        if (d.alloc < alloc) {
            if (d.ref_.isShared())
                detach_helper(alloc);
            else
                p.realloc(alloc);
        }
    }
    void append()(ref const(T) t)
    {
        if (d.ref_.isShared()) {
            Node* n = detach_helper_grow(int.max, 1);
            /+ QT_TRY +/ {
                 /+ QT_CATCH(...) +/scope(failure) {
                    --d.end;
                }
                node_construct(n, t);
            }
        } else {
            if (QTypeInfo!(T).isLarge || QTypeInfo!(T).isStatic) {
                Node* n = reinterpret_cast!(Node*)(p.append());
                /+ QT_TRY +/ {
                     /+ QT_CATCH(...) +/scope(failure) {
                        --d.end;
                    }
                    node_construct(n, t);
                }
            } else {
                Node* n; Node copy;
                node_construct(&copy, t); // t might be a reference to an object in the array
                /+ QT_TRY +/ {
                     /+ QT_CATCH(...) +/scope(failure) {
                        node_destruct(&copy);
                    }
                    n = reinterpret_cast!(Node*)(p.append());
                }
                *n = copy;
            }
        }
    }
    void append()(const(T) t)
    {
        append(t);
    }
    /+pragma(inline, true) void append(ref const(QList!(T)) t)
    {
        this += t;
    }+/
    pragma(inline, true) void prepend()(ref const(T) t)
    {
        if (d.ref_.isShared()) {
            Node* n = detach_helper_grow(0, 1);
            /+ QT_TRY +/ {
                 /+ QT_CATCH(...) +/scope(failure) {
                    ++d.begin;
                }
                node_construct(n, t);
            }
        } else {
            if (QTypeInfo!(T).isLarge || QTypeInfo!(T).isStatic) {
                Node* n = reinterpret_cast!(Node*)(p.prepend());
                /+ QT_TRY +/ {
                     /+ QT_CATCH(...) +/scope(failure) {
                        ++d.begin;
                    }
                    node_construct(n, t);
                }
            } else {
                Node* n; Node copy;
                node_construct(&copy, t); // t might be a reference to an object in the array
                /+ QT_TRY +/ {
                     /+ QT_CATCH(...) +/scope(failure) {
                        node_destruct(&copy);
                    }
                    n = reinterpret_cast!(Node*)(p.prepend());
                }
                *n = copy;
            }
        }
    }
    pragma(inline, true) void insert()(int i, ref const(T) t)
    {
    /+ #if !QT_DEPRECATED_SINCE(5, 15)
        Q_ASSERT_X(i >= 0 && i <= p.size(), "QList<T>::insert", "index out of range");
    #elif !defined(QT_NO_DEBUG)
        if (i < 0 || i > p.size())
            qWarning("QList::insert(): Index out of range.");
    #endif +/
        if (d.ref_.isShared()) {
            Node* n = detach_helper_grow(i, 1);
            /+ QT_TRY +/ {
                 /+ QT_CATCH(...) +/scope(failure) {
                    p.remove(i);
                }
                node_construct(n, t);
            }
        } else {
            if (QTypeInfo!(T).isLarge || QTypeInfo!(T).isStatic) {
                Node* n = reinterpret_cast!(Node*)(p.insert(i));
                /+ QT_TRY +/ {
                     /+ QT_CATCH(...) +/scope(failure) {
                        p.remove(i);
                    }
                    node_construct(n, t);
                }
            } else {
                Node* n; Node copy;
                node_construct(&copy, t); // t might be a reference to an object in the array
                /+ QT_TRY +/ {
                     /+ QT_CATCH(...) +/scope(failure) {
                        node_destruct(&copy);
                    }
                    n = reinterpret_cast!(Node*)(p.insert(i));
                }
                *n = copy;
            }
        }
    }
    pragma(inline, true) void replace()(int i, ref const(T) t)
    {
        (mixin(Q_ASSERT_X(q{i >= 0 && i < p.size()},q{ "QList<T>::replace"},q{ "index out of range"})));
        detach();
        reinterpret_cast!(Node*)(p.at(i)).t() = *cast(T*)&t;
    }
    pragma(inline, true) void removeAt(int i)
    {
    /+ #if !QT_DEPRECATED_SINCE(5, 15) +/
        (mixin(Q_ASSERT_X(q{i >= 0 && i < p.size()}, q{"QList<T>::removeAt"}, q{"index out of range"})));
    /+ #endif +/
        if (i < 0 || i >= p.size()) {
    /+ #if !defined(QT_NO_DEBUG)
            qWarning("QList::removeAt(): Index out of range.");
    #endif +/
            return;
        }
        detach();
        node_destruct(reinterpret_cast!(Node*)(p.at(i))); p.remove(i);
    }
/+    int removeAll(ref const(T) _t)
    {
        int index = indexOf(_t);
        if (index == -1)
            return 0;

        const(T) t = _t;
        detach();

        Node* i = reinterpret_cast!(Node*)(p.at(index));
        Node* e = reinterpret_cast!(Node*)(p.end());
        Node* n = i;
        node_destruct(i);
        while (++i != e) {
            if (i.t() == t)
                node_destruct(i);
            else
                *n++ = *i;
        }

        int removedCount = cast(int)(e - n);
        d.end -= removedCount;
        return removedCount;
    }+/
    /+bool removeOne(ref const(T) _t)
    {
        int index = indexOf(_t);
        if (index != -1) {
            removeAt(index);
            return true;
        }
        return false;
    }+/
    pragma(inline, true) T takeAt()(int i)
    { (mixin(Q_ASSERT_X(q{i >= 0 && i < p.size()},q{ "QList<T>::take"},q{ "index out of range"})));
     detach();
     Node* n = reinterpret_cast!(Node*)(p.at(i));
     T t = /+ std:: +//*move*/(n.t()); node_destruct(n);
     p.remove(i); return t; }
    pragma(inline, true) T takeFirst()()
    { T t = /+ std:: +//*move*/(first()); removeFirst(); return t; }
    pragma(inline, true) T takeLast()
    { T t = /+ std:: +//*move*/(last()); removeLast(); return t; }
    pragma(inline, true) void move()(int from, int to)
    {
        (mixin(Q_ASSERT_X(q{from >= 0 && from < p.size() && to >= 0 && to < p.size()},q{
                   "QList<T>::move"},q{ "index out of range"})));
        detach();
        p.move(from, to);
    }
/+    pragma(inline, true) void swapItemsAt(int i, int j)
    {
        (mixin(Q_ASSERT_X(q{i >= 0 && i < p.size() && j >= 0 && j < p.size()},q{
                    "QList<T>::swap"},q{ "index out of range"})));
        detach();
        qSwap(d.array[d.begin + i], d.array[d.begin + j]);
    }
+/
/+ #if QT_DEPRECATED_SINCE(5, 13) && QT_VERSION < QT_VERSION_CHECK(6,0,0) +/
    /+ QT_DEPRECATED_VERSION_X_5_13("Use QList<T>::swapItemsAt()")
    void swap(int i, int j) { swapItemsAt(i, j); } +/
/+ #endif +/
    int indexOf(ref const(T) t, int from = 0) const
    {
        return /+ QtPrivate:: +/.indexOf!(T, T)(this, t, from);
    }
    int lastIndexOf(ref const(T) t, int from = -1) const
    {
        import qt.core.stringalgorithms;

        return /+ QtPrivate:: +/.lastIndexOf!(T, T)(this, t, from);
    }
/+    bool contains(ref const(T) t) const
    {
        return contains_impl(t, MemoryLayout());
    }
    int count(ref const(T) t) const
    {
        return this.count_impl(t, MemoryLayout());
    }
+/

    /+
    extern(C++, class) struct const_iterator;
    +/

    extern(C++, class) struct iterator {
    public:
        Node* i = null;
//        alias iterator_category = /+ std:: +/random_access_iterator_tag;
        // ### Qt6: use int
        alias difference_type = qptrdiff;
        alias value_type = T;
        alias pointer = T*;
        /+ typedef T &reference; +/

        //@disable this();
        /+pragma(inline, true) this()/+ noexcept+/
        {
            this.i = null;
        }+/
        pragma(inline, true) this(Node* n)/+ noexcept+/
        {
            this.i = n;
        }
/+ #if QT_VERSION < QT_VERSION_CHECK(6,0,0) +/
        // can't remove it in Qt 5, since doing so would make the type trivial,
        // which changes the way it's passed to functions by value.
        //@disable this(this);
        pragma(inline, true) this(ref const(iterator) o)/+ noexcept+/
        {
            this.i = cast(Node*)o.i;
        }
        /+pragma(inline, true) ref iterator operator =(ref const(iterator) o)/+ noexcept+/
        { i = o.i; return this; }+/
/+ #endif +/
        pragma(inline, true) ref T opUnary(string op)() const if(op == "*") { return (cast(Node*)i).t(); }
        /+pragma(inline, true) T* operator ->() const { return &i.t(); }+/
        pragma(inline, true) ref T opIndex(difference_type j) const { return (cast(Node*)i).t(); }
        /+pragma(inline, true) bool operator ==(ref const(iterator) o) const/+ noexcept+/ { return i == o.i; }+/
        /+pragma(inline, true) bool operator !=(ref const(iterator) o) const/+ noexcept+/ { return i != o.i; }+/
        /+pragma(inline, true) bool operator <(ref const(iterator) other) const/+ noexcept+/ { return i < other.i; }+/
        /+pragma(inline, true) bool operator <=(ref const(iterator) other) const/+ noexcept+/ { return i <= other.i; }+/
        /+pragma(inline, true) bool operator >(ref const(iterator) other) const/+ noexcept+/ { return i > other.i; }+/
        /+pragma(inline, true) bool operator >=(ref const(iterator) other) const/+ noexcept+/ { return i >= other.i; }+/
/+ #ifndef QT_STRICT_ITERATORS +/
        /+pragma(inline, true) bool operator ==(ref const(const_iterator) o) const/+ noexcept+/
            { return i == o.i; }+/
        /+pragma(inline, true) bool operator !=(ref const(const_iterator) o) const/+ noexcept+/
            { return i != o.i; }+/
        /+pragma(inline, true) bool operator <(ref const(const_iterator) other) const/+ noexcept+/
            { return i < other.i; }+/
        /+pragma(inline, true) bool operator <=(ref const(const_iterator) other) const/+ noexcept+/
            { return i <= other.i; }+/
        /+pragma(inline, true) bool operator >(ref const(const_iterator) other) const/+ noexcept+/
            { return i > other.i; }+/
        /+pragma(inline, true) bool operator >=(ref const(const_iterator) other) const/+ noexcept+/
            { return i >= other.i; }+/
/+ #endif +/
        pragma(inline, true) ref iterator opUnary(string op)() if(op == "++") { ++i; return this; }
        /+pragma(inline, true) iterator operator ++(int) { Node* n = i; ++i; return cast(iterator)(n); }+/
        pragma(inline, true) ref iterator opUnary(string op)() if(op == "--") { i--; return this; }
        /+pragma(inline, true) iterator operator --(int) { Node* n = i; i--; return cast(iterator)(n); }+/
        pragma(inline, true) ref iterator opOpAssign(string op)(difference_type j) if(op == "+") { i+=j; return this; }
        pragma(inline, true) ref iterator opOpAssign(string op)(difference_type j) if(op == "-") { i-=j; return this; }
        pragma(inline, true) iterator opBinary(string op)(difference_type j) const if(op == "+") { return iterator(cast(Node*)(i+j)); }
        pragma(inline, true) iterator opBinary(string op)(difference_type j) const if(op == "-") { return iterator(cast(Node*)(i-j)); }
        /+ friend inline iterator operator+(difference_type j, iterator k) { return k + j; } +/
        pragma(inline, true) int opBinary(string op)(iterator j) const if(op == "-") { return cast(int)(i - j.i); }
    }
    /+ friend class iterator; +/

    extern(C++, class) struct const_iterator {
    public:
        Node* i = null;
//        alias iterator_category = /+ std:: +/random_access_iterator_tag;
        // ### Qt6: use int
        alias difference_type = qptrdiff;
        alias value_type = T;
        alias pointer = const(T)*;
        /+ typedef const T &reference; +/

        //@disable this();
        /+pragma(inline, true) this()/+ noexcept+/
        {
            this.i = null;
        }+/
        pragma(inline, true) this(Node* n)/+ noexcept+/
        {
            this.i = n;
        }
/+ #if QT_VERSION < QT_VERSION_CHECK(6,0,0) +/
        // can't remove it in Qt 5, since doing so would make the type trivial,
        // which changes the way it's passed to functions by value.
        //@disable this(this);
        pragma(inline, true) this(ref const(const_iterator) o)/+ noexcept+/
        {
            this.i = cast(Node*)o.i;
        }
        /+pragma(inline, true) ref const_iterator operator =(ref const(const_iterator) o)/+ noexcept+/
        { i = o.i; return this; }+/
/+ #endif
#ifdef QT_STRICT_ITERATORS
        inline explicit const_iterator(const iterator &o) noexcept : i(o.i) {}
#else +/
        pragma(inline, true) this(ref const(iterator) o)/+ noexcept+/
        {
            this.i = cast(Node*)o.i;
        }
        pragma(inline, true) this(const(iterator) o)/+ noexcept+/
        {
            this.i = cast(Node*)o.i;
        }
/+ #endif +/
        pragma(inline, true) ref const(T) opUnary(string op)() const if(op == "*") { return i.t(); }
        /+pragma(inline, true) const(T)* operator ->() const { return &i.t(); }+/
        pragma(inline, true) ref const(T) opIndex(difference_type j) const { return (cast(Node*)i)[j].t(); }
        /+pragma(inline, true) bool operator ==(ref const(const_iterator) o) const/+ noexcept+/ { return i == o.i; }+/
        /+pragma(inline, true) bool operator !=(ref const(const_iterator) o) const/+ noexcept+/ { return i != o.i; }+/
        /+pragma(inline, true) bool operator <(ref const(const_iterator) other) const/+ noexcept+/ { return i < other.i; }+/
        /+pragma(inline, true) bool operator <=(ref const(const_iterator) other) const/+ noexcept+/ { return i <= other.i; }+/
        /+pragma(inline, true) bool operator >(ref const(const_iterator) other) const/+ noexcept+/ { return i > other.i; }+/
        /+pragma(inline, true) bool operator >=(ref const(const_iterator) other) const/+ noexcept+/ { return i >= other.i; }+/
        pragma(inline, true) ref const_iterator opUnary(string op)() if(op == "++") { ++i; return this; }
        /+pragma(inline, true) const_iterator operator ++(int) { Node* n = i; ++i; return cast(const_iterator)(n); }+/
        pragma(inline, true) ref const_iterator opUnary(string op)() if(op == "--") { i--; return this; }
        /+pragma(inline, true) const_iterator operator --(int) { Node* n = i; i--; return cast(const_iterator)(n); }+/
        pragma(inline, true) ref const_iterator opOpAssign(string op)(difference_type j) if(op == "+") { i+=j; return this; }
        pragma(inline, true) ref const_iterator opOpAssign(string op)(difference_type j) if(op == "-") { i-=j; return this; }
        pragma(inline, true) const_iterator opBinary(string op)(difference_type j) const if(op == "+") { return const_iterator(i+j); }
        pragma(inline, true) const_iterator opBinary(string op)(difference_type j) const if(op == "-") { return const_iterator(i-j); }
        /+ friend inline const_iterator operator+(difference_type j, const_iterator k) { return k + j; } +/
        pragma(inline, true) int opBinary(string op)(const_iterator j) const if(op == "-") { return cast(int)(i - j.i); }
    }
    /+ friend class const_iterator; +/

    // stl style
    /+ typedef std::reverse_iterator<iterator> reverse_iterator; +/
    /+ typedef std::reverse_iterator<const_iterator> const_reverse_iterator; +/
    pragma(inline, true) iterator begin() { detach(); return iterator(reinterpret_cast!(Node*)(p.begin())); }
    pragma(inline, true) const_iterator begin() const/+ noexcept+/ { return const_iterator(reinterpret_cast!(Node*)(p.begin())); }
    pragma(inline, true) const_iterator cbegin() const/+ noexcept+/ { return const_iterator(reinterpret_cast!(Node*)(p.begin())); }
    pragma(inline, true) const_iterator constBegin() const/+ noexcept+/ { return const_iterator(reinterpret_cast!(Node*)(p.begin())); }
    pragma(inline, true) iterator end() { detach(); return iterator(reinterpret_cast!(Node*)(p.end())); }
    pragma(inline, true) const_iterator end() const/+ noexcept+/ { return const_iterator(reinterpret_cast!(Node*)(p.end())); }
    pragma(inline, true) const_iterator cend() const/+ noexcept+/ { return const_iterator(reinterpret_cast!(Node*)(p.end())); }
    pragma(inline, true) const_iterator constEnd() const/+ noexcept+/ { return const_iterator(reinterpret_cast!(Node*)(p.end())); }
    /+ reverse_iterator rbegin() { return reverse_iterator(end()); } +/
    /+ reverse_iterator rend() { return reverse_iterator(begin()); } +/
    /+ const_reverse_iterator rbegin() const noexcept { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator rend() const noexcept { return const_reverse_iterator(begin()); } +/
    /+ const_reverse_iterator crbegin() const noexcept { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator crend() const noexcept { return const_reverse_iterator(begin()); } +/

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
                ++i;
            }
        }
        auto this_ = cast(QList*)&this;
        return R(this_.begin(), this_.end());
    }

    pragma(inline, true) iterator insert()(iterator before, ref const(T) t)
    {
        (mixin(Q_ASSERT_X(q{QList.isValidIterator(before)},q{ "QList::insert"},q{ "The specified iterator argument 'before' is invalid"})));

        int iBefore = cast(int)(before.i - reinterpret_cast!(Node*)(p.begin()));
        Node* n = null;
        if (d.ref_.isShared())
            n = detach_helper_grow(iBefore, 1);
        else
            n = reinterpret_cast!(Node*)(p.insert(iBefore));
        /+ QT_TRY +/ {
             /+ QT_CATCH(...) +/scope(failure) {
                p.remove(iBefore);
            }
            node_construct(n, t);
        }
        return cast(iterator)(n);
    }
    pragma(inline, true) iterator erase(iterator it)
    /+/+ typename QList<T>::iterator +/pragma(inline, true) iterator erase(iterator it)+/
    {
        (mixin(Q_ASSERT_X(q{QList!T.isValidIterator(it)},q{ "QList::erase"},q{ "The specified iterator argument 'it' is invalid"})));
        if (d.ref_.isShared()) {
            int offset = cast(int)(it.i - reinterpret_cast!(Node*)(p.begin()));
            it = begin(); // implies detach()
            it += offset;
        }
        node_destruct(it.i);
        return iterator(reinterpret_cast!(Node*)(p.erase(reinterpret_cast!(void**)(it.i))));
    }
    iterator erase(iterator afirst, iterator alast)
    /+/+ typename QList<T>::iterator +/iterator erase(/+ typename QList<T>::iterator +/ iterator afirst,
                                                                     /+ typename QList<T>::iterator +/ iterator alast)+/
    {
        (mixin(Q_ASSERT_X(q{QList.isValidIterator(afirst)},q{ "QList::erase"},q{ "The specified iterator argument 'afirst' is invalid"})));
        (mixin(Q_ASSERT_X(q{QList.isValidIterator(alast)},q{ "QList::erase"},q{ "The specified iterator argument 'alast' is invalid"})));

        if (d.ref_.isShared()) {
            // ### A block is erased and a detach is needed. We should shrink and only copy relevant items.
            int offsetfirst = cast(int)(afirst.i - reinterpret_cast!(Node*)(p.begin()));
            int offsetlast = cast(int)(alast.i - reinterpret_cast!(Node*)(p.begin()));
            afirst = begin(); // implies detach()
            alast = afirst;
            afirst += offsetfirst;
            alast += offsetlast;
        }

        for (Node *n = afirst.i; n < alast.i; ++n)
            node_destruct(n);
        int idx = cast(int)(afirst - begin());
        p.remove(idx, alast - afirst);
        return begin() + idx;
    }

    // more Qt
    alias Iterator = iterator;
    alias ConstIterator = const_iterator;
    pragma(inline, true) int count() const { return p.size(); }
    pragma(inline, true) int length() const { return p.size(); } // Same as count()
    pragma(inline, true) ref T first() { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); return *begin(); }
    pragma(inline, true) ref const(T) constFirst() const { return first(); }
    pragma(inline, true) ref const(T) first() const { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); return at(0); }
    ref T last() { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); return *(--end()); }
    ref const(T) last() const { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); return at(count() - 1); }
    pragma(inline, true) ref const(T) constLast() const { return last(); }
    pragma(inline, true) void removeFirst() { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); erase(begin()); }
    pragma(inline, true) void removeLast() { (mixin(Q_ASSERT(q{!QList.isEmpty()}))); erase(--end()); }
    pragma(inline, true) bool startsWith(ref const(T) t) const { return !isEmpty() && first() == t; }
    pragma(inline, true) bool endsWith(ref const(T) t) const { return !isEmpty() && last() == t; }
/+    QList!(T) mid(int pos, int alength = -1) const
    {
//        using namespace QtPrivate;
        switch (QContainerImplHelper.mid(size(), &pos, &alength)) {
        case QContainerImplHelper.Null:
        case QContainerImplHelper.Empty:
            return QList!(T)();
        case QContainerImplHelper.Full:
            return this;
        case QContainerImplHelper.Subset:
            break;default:

        }

        QList!T cpy;
        if (alength <= 0)
            return cpy;
        cpy.reserve(alength);
        cpy.d.end = alength;
        /+ QT_TRY +/ {
             /+ QT_CATCH(...) +/scope(failure) {
                // restore the old end
                cpy.d.end = 0;
            }
            cpy.node_copy(reinterpret_cast!(Node*)(cpy.p.begin()),
                          reinterpret_cast!(Node*)(cpy.p.end()),
                          reinterpret_cast!(Node*)(p.begin() + pos));
        }
        return cpy;
    }
+/

    T value()(int i) const
    {
        if (i < 0 || i >= p.size()) {
            return T();
        }
        return reinterpret_cast!(Node*)(p.at(i)).t();
    }
/+    T value(int i, ref const(T) defaultValue) const
    {
        return ((i < 0 || i >= p.size()) ? defaultValue : reinterpret_cast!(Node*)(p.at(i)).t());
    }+/

    // stl compatibility
    pragma(inline, true) void push_back()(ref const(T) t) { append(t); }
    pragma(inline, true) void push_front()(ref const(T) t) { prepend(t); }
    pragma(inline, true) ref T front() { return first(); }
    pragma(inline, true) ref const(T) front() const { return first(); }
    pragma(inline, true) ref T back() { return last(); }
    pragma(inline, true) ref const(T) back() const { return last(); }
    pragma(inline, true) void pop_front() { removeFirst(); }
    pragma(inline, true) void pop_back() { removeLast(); }
    pragma(inline, true) bool empty() const { return isEmpty(); }
    alias size_type = int;
    alias value_type = T;
    alias pointer = value_type*;
    alias const_pointer = const(value_type)*;
    /+ typedef value_type &reference; +/
    /+ typedef const value_type &const_reference; +/
    // ### Qt6: use int
    alias difference_type = qptrdiff;

    // comfort
    extern(D) ref QList!(T) opOpAssign(string op)(ref const(QList!(T)) l) if(op == "~")
    {
        if (!l.isEmpty()) {
            if (d == &QListData.shared_null) {
                this = l;
            } else {
                Node* n = (d.ref_.isShared())
                          ? detach_helper_grow(int.max, l.size())
                          : reinterpret_cast!(Node*)(p.append(l.p));
                /+ QT_TRY +/ {
                     /+ QT_CATCH(...) +/scope(failure) {
                        // restore the old end
                        d.end -= int(reinterpret_cast!(Node*)(p.end()) - n);
                    }
                    node_copy(n, reinterpret_cast!(Node*)(p.end()),
                              reinterpret_cast!(Node*)(l.p.begin()));
                }
            }
        }
        return this;
    }
    extern(D) pragma(inline, true) QList!(T) opBinary(string op)(ref const(QList!(T)) l) const if(op == "~")
    { QList n = this; n ~= l; return n; }
    extern(D) pragma(inline, true) ref QList!(T) opOpAssign(string op)(ref const(T) t) if(op == "~")
    { append(t); return this; }
    /+pragma(inline, true) ref QList!(T) operator << (ref const(T) t)
    { append(t); return this; }+/
    /+pragma(inline, true) ref QList!(T) operator <<(ref const(QList!(T)) l)
    { this += l; return this; }+/

    extern(D) void opOpAssign(string op, T2)(ref const T2 t) if(op == "~" && !is(const(T2) == const(T)))
    {
        auto tmp = T(t);
        append(tmp);
    }
    extern(D) void opOpAssign(string op)(const T t) if(op == "~")
    {
        append(t);
    }

/+    static QList!(T) fromVector(ref const(QVector!(T)) vector)
    {
        return vector.toList();
    }
    QVector!(T) toVector() const
    {
        return QVector!(T)(begin(), end());
    }+/

/+ #if QT_DEPRECATED_SINCE(5, 14) && QT_VERSION < QT_VERSION_CHECK(6,0,0) +/
    /+ QT_DEPRECATED_VERSION_X_5_14("Use QList<T>(set.begin(), set.end()) instead.")
    static QList<T> fromSet(const QSet<T> &set); +/
    /+ QT_DEPRECATED_VERSION_X_5_14("Use QSet<T>(list.begin(), list.end()) instead.")
    QSet<T> toSet() const; +/

    /+ QT_DEPRECATED_VERSION_X_5_14("Use QList<T>(list.begin(), list.end()) instead.")
    static inline QList<T> fromStdList(const std::list<T> &list)
    { return QList<T>(list.begin(), list.end()); } +/
    /+ QT_DEPRECATED_VERSION_X_5_14("Use std::list<T>(list.begin(), list.end()) instead.")
    inline std::list<T> toStdList() const
    { return std::list<T>(begin(), end()); } +/
/+ #endif +/

private:
    Node* detach_helper_grow(int i, int c)
    /+/+ typename QList<T>::Node +/Node* detach_helper_grow(int i, int c)+/
    {
        Node* n = reinterpret_cast!(Node*)(p.begin());
        QListData.Data *x = p.detach_grow(&i, c);
        /+ QT_TRY +/ {
             /+ QT_CATCH(...) +/scope(failure) {
                p.dispose();
                d = x;
            }
            node_copy(reinterpret_cast!(Node*)(p.begin()),
                      reinterpret_cast!(Node*)(p.begin() + i), n);
        }
        /+ QT_TRY +/ {
             /+ QT_CATCH(...) +/scope(failure) {
                node_destruct(reinterpret_cast!(Node*)(p.begin()),
                              reinterpret_cast!(Node*)(p.begin() + i));
                p.dispose();
                d = x;
            }
            node_copy(reinterpret_cast!(Node*)(p.begin() + i + c),
                      reinterpret_cast!(Node*)(p.end()), n + i);
        }

        if (!x.ref_.deref())
            dealloc(x);

        return reinterpret_cast!(Node*)(p.begin() + i);
    }
    void detach_helper(int alloc)
    {
        Node* n = reinterpret_cast!(Node*)(p.begin());
        QListData.Data *x = p.detach(alloc);
        /+ QT_TRY +/ {
             /+ QT_CATCH(...) +/scope(failure) {
                p.dispose();
                d = x;
            }
            node_copy(reinterpret_cast!(Node*)(p.begin()), reinterpret_cast!(Node*)(p.end()), n);
        }

        if (!x.ref_.deref())
            dealloc(x);
    }
    void detach_helper()
    {
        detach_helper(d.alloc);
    }
    void dealloc(QListData.Data* data)
    {
        node_destruct(reinterpret_cast!(Node*)(data.array.ptr + data.begin),
                      reinterpret_cast!(Node*)(data.array.ptr + data.end));
        QListData.dispose(data);
    }

    pragma(inline, true) void node_construct()(Node* n, ref const(T) t)
    {
        import core.lifetime;
        import core.stdcpp.new_;

        static if (QTypeInfo!(T).isLarge || QTypeInfo!(T).isStatic)
        {
            n.v = cpp_new!T;
            *cast(T*)n.v = *cast(T*)&t;
        }
        else static if (QTypeInfo!(T).isComplex)
        {
            static if(__traits(hasMember, T, "rawConstructor"))
                (*cast(T*)n).rawConstructor();
            else
                emplace!T(cast(T*)n);
            *cast(T*)n = *cast(T*)&t;
        }
    /+ #if (defined(__GNUC__) || defined(__INTEL_COMPILER) || defined(__IBMCPP__)) && !defined(__OPTIMIZE__) +/
        // This violates pointer aliasing rules, but it is known to be safe (and silent)
        // in unoptimized GCC builds (-fno-strict-aliasing). The other compilers which
        // set the same define are assumed to be safe.
        else *reinterpret_cast!(T*)(n) = *cast(T*)&t;
    /+ #else
        // This is always safe, but penaltizes unoptimized builds a lot.
        else ::memcpy(n, static_cast<const void *>(&t), sizeof(T));
    #endif +/
    }
    pragma(inline, true) void node_destruct(Node* n)
    {
        import core.stdcpp.new_;

        static if (QTypeInfo!(T).isLarge || QTypeInfo!(T).isStatic) cpp_delete(reinterpret_cast!(T*)(n.v));
        else if (QTypeInfo!(T).isComplex) destroy!false(*reinterpret_cast!(T*)(n));
    }
    pragma(inline, true) void node_copy(Node* from, Node* to, Node* src)
    {
        import core.lifetime;
        import core.stdc.string;
        import core.stdcpp.new_;

        Node* current = from;
        static if (QTypeInfo!(T).isLarge || QTypeInfo!(T).isStatic) {
            /+ QT_TRY +/ {
                 /+ QT_CATCH(...) +/scope(failure) {
                    while (current-- != from)
                        cpp_delete(reinterpret_cast!(T*)(current.v));
                }
                while(current != to) {
                    current.v = cpp_new!T(*reinterpret_cast!(T*)(src.v));
                    ++current;
                    ++src;
                }
            }

        } else if (QTypeInfo!(T).isComplex) {
            /+ QT_TRY +/ {
                 /+ QT_CATCH(...) +/scope(failure) {
                    while (current-- != from)
                        destroy!false(*reinterpret_cast!(T*)(current));
                }
                while(current != to) {
                    emplace!T(cast(T*)current, *reinterpret_cast!(T*)(src));
                    ++current;
                    ++src;
                }
            }
        } else {
            if (src != from && to - from > 0)
                memcpy(from, src, (to - from) * Node.sizeof);
        }
    }
    pragma(inline, true) void node_destruct(Node* from, Node* to)
    {
        import core.stdcpp.new_;

        static if (QTypeInfo!(T).isLarge || QTypeInfo!(T).isStatic)
            while(from != to) {
                --to;
                cpp_delete(reinterpret_cast!(T*)(to.v));
            }
        else if (QTypeInfo!(T).isComplex)
            while (from != to) {
                --to;
                destroy!false(*reinterpret_cast!(T*)(to));
            }
    }

    bool isValidIterator(ref const(iterator) i) const/+ noexcept+/
    {
        return !(i.i < cbegin().i) && !(end().i < i.i);
    }

private:
    pragma(inline, true) bool op_eq_impl(ref const(QList) l, QListData.NotArrayCompatibleLayout) const
    {
        Node* i = reinterpret_cast!(Node*)(p.begin());
        Node* e = reinterpret_cast!(Node*)(p.end());
        Node* li = reinterpret_cast!(Node*)(l.p.begin());
        for (; i != e; ++i, ++li) {
            if (!(i.t() == li.t()))
                return false;
        }
        return true;
    }
/+    pragma(inline, true) bool op_eq_impl(ref const(QList) l, QListData.ArrayCompatibleLayout) const
    {
        const(T)* lb = reinterpret_cast!(const(T)*)(l.p.begin());
        const(T)* b  = reinterpret_cast!(const(T)*)(p.begin());
        const(T)* e  = reinterpret_cast!(const(T)*)(p.end());
        return /+ std:: +/equal(b, e, mixin(QT_MAKE_CHECKED_ARRAY_ITERATOR(q{lb},q{ l.p.size()})));
    }+/
    pragma(inline, true) bool contains_impl(ref const(T) t, QListData.NotArrayCompatibleLayout) const
    {
        Node* e = reinterpret_cast!(Node*)(p.end());
        Node* i = reinterpret_cast!(Node*)(p.begin());
        for (; i != e; ++i)
            if (i.t() == t)
                return true;
        return false;
    }
/+    pragma(inline, true) bool contains_impl(ref const(T) t, QListData.ArrayCompatibleLayout) const
    {
        const(T)* b = reinterpret_cast!(const(T)*)(p.begin());
        const(T)* e = reinterpret_cast!(const(T)*)(p.end());
        return /+ std:: +/find(b, e, t) != e;
    }+/
    pragma(inline, true) int count_impl(ref const(T) t, QListData.NotArrayCompatibleLayout) const
    {
        int c = 0;
        Node* e = reinterpret_cast!(Node*)(p.end());
        Node* i = reinterpret_cast!(Node*)(p.begin());
        for (; i != e; ++i)
            if (i.t() == t)
                ++c;
        return c;
    }
/+    pragma(inline, true) int count_impl(ref const(T) t, QListData.ArrayCompatibleLayout) const
    {
        return int(/+ std:: +/count(reinterpret_cast!(const(T)*)(p.begin()),
                              reinterpret_cast!(const(T)*)(p.end()),
                              t));
    }
+/
}

/+ #if defined(__cpp_deduction_guides) && __cpp_deduction_guides >= 201606
template <typename InputIterator,
          typename ValueType = typename std::iterator_traits<InputIterator>::value_type,
          QtPrivate::IfIsInputIterator<InputIterator> = true>
QList(InputIterator, InputIterator) -> QList<ValueType>;
#endif

#if defined(Q_CC_BOR)
template <typename T>
T &QList<T>::Node::t()
{ return QTypeInfo<T>::isLarge || QTypeInfo<T>::isStatic ? *(T*)v:*(T*)this; }
#endif +/


extern(C++, "QtPrivate")
{
int indexOf(T, U)(ref const(QList!(T)) list, ref const(U) u, int from)
{
    /+ typename QList<T>::Node +/// self alias: alias Node = QList.Node;

    if (from < 0)
        from = qMax(from + list.p.size(), 0);
    if (from < list.p.size()) {
        QList!T.Node* n = reinterpret_cast!(QList!T.Node*)(list.p.at(from -1));
        QList!T.Node* e = reinterpret_cast!(QList!T.Node*)(list.p.end());
        while (++n != e)
            if (n.t() == u)
                return cast(int)(n - reinterpret_cast!(QList!T.Node*)(list.p.begin()));
    }
    return -1;
}
}

extern(C++, "QtPrivate")
{
int lastIndexOf(T, U)(ref const(QList!(T)) list, ref const(U) u, int from)
{
    /+ typename QList<T>::Node +/// self alias: alias Node = QList.Node;

    if (from < 0)
        from += list.p.size();
    else if (from >= list.p.size())
        from = list.p.size()-1;
    if (from >= 0) {
        QList!T.Node* b = reinterpret_cast!(QList!T.Node*)(list.p.begin());
        QList!T.Node* n = reinterpret_cast!(QList!T.Node*)(list.p.at(from + 1));
        while (n-- != b) {
            if (n.t() == u)
                return cast(int)(n - b);
        }
    }
    return -1;
}
}

/+ Q_DECLARE_SEQUENTIAL_ITERATOR(List)
Q_DECLARE_MUTABLE_SEQUENTIAL_ITERATOR(List)

template <typename T>
uint qHash(const QList<T> &key, uint seed = 0)
    noexcept(noexcept(qHashRange(key.cbegin(), key.cend(), seed)))
{
    return qHashRange(key.cbegin(), key.cend(), seed);
} +/

/+bool operator <(T)(ref const(QList!(T)) lhs, ref const(QList!(T)) rhs)
    /+ noexcept(noexcept(std::lexicographical_compare(lhs.begin(), lhs.end(),
                                                               rhs.begin(), rhs.end()))) +/
{
    return /+ std:: +/lexicographical_compare(lhs.begin(), lhs.end(),
                                        rhs.begin(), rhs.end());
}+/

/+pragma(inline, true) bool operator >(T)(ref const(QList!(T)) lhs, ref const(QList!(T)) rhs)
    /+ noexcept(noexcept(lhs < rhs)) +/
{
    return rhs < lhs;
}+/

/+pragma(inline, true) bool operator <=(T)(ref const(QList!(T)) lhs, ref const(QList!(T)) rhs)
    /+ noexcept(noexcept(lhs < rhs)) +/
{
    return !(lhs > rhs);
}+/

/+pragma(inline, true) bool operator >=(T)(ref const(QList!(T)) lhs, ref const(QList!(T)) rhs)
    /+ noexcept(noexcept(lhs < rhs)) +/
{
    return !(lhs < rhs);
}+/


/+ #ifdef Q_CC_MSVC
#pragma warning( pop )
#endif +/

