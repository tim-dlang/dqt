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
module qt.core.shareddata;
extern(C++):

import qt.config;
import qt.core.atomic;
import qt.helpers;

/+ #if QT_DEPRECATED_SINCE(5, 6)
#endif +/



/// Binding for C++ class [QSharedData](https://doc.qt.io/qt-5/qshareddata.html).
extern(C++, class) struct
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
Q_CORE_EXPORT
#endif +/
QSharedData
{
public:
    /+ mutable +/ QAtomicInt ref_/* = 0*/;

    @disable this();
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.ref_ = 0;
    }+/
    @disable this(this);
    pragma(inline, true) this(ref const(QSharedData) )/+ noexcept+/
    {
        this.ref_ = 0;
    }

    // using the assignment operator would lead to corruption in the ref-counting
    /+ref QSharedData operator =(ref const(QSharedData) ) /+ = delete +/;+/
    /+ ~QSharedData() = default; +/
}

/// Binding for C++ class [QSharedDataPointer](https://doc.qt.io/qt-5/qshareddatapointer.html).
extern(C++, class) struct QSharedDataPointer(T)
{
public:
    alias Type = T;
    alias pointer = T*;

    pragma(inline, true) void detach()() { if (d && d.ref_.loadRelaxed() != 1) detach_helper(); }
    pragma(inline, true) ref T opUnary(string op)() if(op == "*") { detach(); return *d; }
    pragma(inline, true) ref const(T) opUnary(string op)() const if(op == "*") { return *d; }
    /+pragma(inline, true) T* operator ->() { detach(); return d; }+/
    /+pragma(inline, true) const(T)* operator ->() const { return d; }+/
    /+pragma(inline, true) auto opCast(T : T)() { detach(); return d; }+/
    /+pragma(inline, true) auto opCast(T : const(T))() const { return d; }+/
    pragma(inline, true) T* data()() { detach(); return d; }
    pragma(inline, true) const(T)* data()() const { return d; }
    pragma(inline, true) const(T)* constData() const { return d; }

    /+pragma(inline, true) bool operator ==(ref const(QSharedDataPointer!(T)) other) const { return d == other.d; }+/
    /+pragma(inline, true) bool operator !=(ref const(QSharedDataPointer!(T)) other) const { return d != other.d; }+/

    /+pragma(inline, true) this() { d = null; }+/
    pragma(inline, true) ~this() {
        import core.stdcpp.new_;
        static if(__traits(compiles, (*d).sizeof))
        {
            import core.stdcpp.new_;
            if (d && !d.ref_.deref()) cpp_delete(d);
        }
        else
            assert(false);
    }

/+    /+ explicit +/pragma(inline, true) this(T* adata)/+ noexcept+/
    {
        this.d = adata;
        if (d) d.ref_.ref_();
    }+/
    pragma(inline, true) this(this)
    {
        static if(__traits(compiles, d.ref_))
        {
            if (d) d.ref_.ref_();
        }
        else
            assert(0);
    }
    /+pragma(inline, true) ref QSharedDataPointer!(T)  operator =(ref const(QSharedDataPointer!(T)) o) {
        import core.stdcpp.new_;

        if (o.d != d) {
            if (o.d)
                o.d.ref_.ref_();
            T* old = d;
            d = o.d;
            if (old && !old.ref_.deref())
                cpp_delete(old);
        }
        return this;
    }+/
    /+pragma(inline, true) ref QSharedDataPointer operator =(T* o) {
        import core.stdcpp.new_;

        if (o != d) {
            if (o)
                o.ref_.ref_();
            T* old = d;
            d = o;
            if (old && !old.ref_.deref())
                cpp_delete(old);
        }
        return this;
    }+/
    /+ QSharedDataPointer(QSharedDataPointer &&o) noexcept : d(o.d) { o.d = nullptr; } +/
    /+ inline QSharedDataPointer<T> &operator=(QSharedDataPointer<T> &&other) noexcept
    {
        QSharedDataPointer moved(std::move(other));
        swap(moved);
        return *this;
    } +/

    /+pragma(inline, true) bool operator !() const { return !d; }+/

    /+ inline void swap(QSharedDataPointer &other) noexcept
    { qSwap(d, other.d); } +/

protected:
    pragma(inline, true) T* clone()()
    {
        import core.stdcpp.new_;

        return cpp_new!T(*d);
    }

private:
    void detach_helper()()
    {
        import core.stdcpp.new_;

        T* x = clone();
        x.ref_.ref_();
        if (!d.ref_.deref())
            cpp_delete(d);
        d = x;
    }

    T* d;
}

/+pragma(inline, true) bool operator ==(T)(/+ std:: +/nullptr_t p1, ref const(QSharedDataPointer!(T)) p2)
{
    /+ Q_UNUSED(p1) +/
    return !p2;
}+/

/+pragma(inline, true) bool operator ==(T)(ref const(QSharedDataPointer!(T)) p1, /+ std:: +/nullptr_t p2)
{
    /+ Q_UNUSED(p2) +/
    return !p1;
}+/

/// Binding for C++ class [QExplicitlySharedDataPointer](https://doc.qt.io/qt-5/qexplicitlyshareddatapointer.html).
extern(C++, class) struct QExplicitlySharedDataPointer(T)
{
public:
    alias Type = T;
    alias pointer = T*;

    pragma(inline, true) ref T opUnary(string op)() const if(op == "*") { return *d; }
    /+pragma(inline, true) T* operator ->() { return d; }+/
    /+pragma(inline, true) T* operator ->() const { return d; }+/
    pragma(inline, true) T* data() const { return cast(T*)d; }
    pragma(inline, true) const(T)* constData() const { return d; }
    pragma(inline, true) T* take() { T* x = d; d = null; return x; }

    pragma(inline, true) void detach()() { if (d && d.ref_.loadRelaxed() != 1) detach_helper(); }

    pragma(inline, true) void reset()()
    {
        import core.stdcpp.new_;

        if(d && !d.ref_.deref())
            cpp_delete(d);

        d = null;
    }

    /+pragma(inline, true) auto opCast(T : bool) () const { return d !is null; }+/

    /+pragma(inline, true) bool operator ==(ref const(QExplicitlySharedDataPointer!(T)) other) const { return d == other.d; }+/
    /+pragma(inline, true) bool operator !=(ref const(QExplicitlySharedDataPointer!(T)) other) const { return d != other.d; }+/
    /+pragma(inline, true) bool operator ==(const(T)* ptr) const { return d == ptr; }+/
    /+pragma(inline, true) bool operator !=(const(T)* ptr) const { return d != ptr; }+/

    /+pragma(inline, true) this() { d = null; }+/
    pragma(inline, true) ~this() {
        static if(__traits(compiles, (*d).sizeof))
        {
            import core.stdcpp.new_;
            if (d && !d.ref_.deref()) cpp_delete(d);
        }
        else
            assert(false);
    }

/+    /+ explicit +/pragma(inline, true) this(T* adata)/+ noexcept+/
    {
        this.d = adata;
        if (d) d.ref_.ref_();
    }+/
    @disable this(this);
    pragma(inline, true) this(ref const(QExplicitlySharedDataPointer!(T)) o)
    {
        static if(__traits(compiles, (*d).sizeof))
        {
            this.d = cast(T*)o.d;
            if (d) d.ref_.ref_();
        }
        else
            assert(false);
    }

    /+ template<class X> +/
    /+ inline QExplicitlySharedDataPointer(const QExplicitlySharedDataPointer<X> &o)
#ifdef QT_ENABLE_QEXPLICITLYSHAREDDATAPOINTER_STATICCAST
        : d(static_cast<T *>(o.data()))
#else
        : d(o.data())
#endif
    {
        if(d)
            d->ref.ref();
    } +/

    /+pragma(inline, true) ref QExplicitlySharedDataPointer!(T)  operator =(ref const(QExplicitlySharedDataPointer!(T)) o) {
        import core.stdcpp.new_;

        if (o.d != d) {
            if (o.d)
                o.d.ref_.ref_();
            T* old = d;
            d = o.d;
            if (old && !old.ref_.deref())
                cpp_delete(old);
        }
        return this;
    }+/
    /+pragma(inline, true) ref QExplicitlySharedDataPointer operator =(T* o) {
        import core.stdcpp.new_;

        if (o != d) {
            if (o)
                o.ref_.ref_();
            T* old = d;
            d = o;
            if (old && !old.ref_.deref())
                cpp_delete(old);
        }
        return this;
    }+/
    /+ inline QExplicitlySharedDataPointer(QExplicitlySharedDataPointer &&o) noexcept : d(o.d) { o.d = nullptr; } +/
    /+ inline QExplicitlySharedDataPointer<T> &operator=(QExplicitlySharedDataPointer<T> &&other) noexcept
    {
        QExplicitlySharedDataPointer moved(std::move(other));
        swap(moved);
        return *this;
    } +/

    /+pragma(inline, true) bool operator !() const { return !d; }+/

    /+ inline void swap(QExplicitlySharedDataPointer &other) noexcept
    { qSwap(d, other.d); } +/

protected:
    pragma(inline, true) T* clone()()
    {
        import core.stdcpp.new_;

        return cpp_new!T(*d);
    }

private:
    void detach_helper()()
    {
        import core.stdcpp.new_;

        T* x = clone();
        x.ref_.ref_();
        if (!d.ref_.deref())
            cpp_delete(d);
        d = x;
    }

    T* d;
}

/+pragma(inline, true) bool operator ==(T)(/+ std:: +/nullptr_t p1, ref const(QExplicitlySharedDataPointer!(T)) p2)
{
    /+ Q_UNUSED(p1) +/
    return !p2;
}+/

/+pragma(inline, true) bool operator ==(T)(ref const(QExplicitlySharedDataPointer!(T)) p1, /+ std:: +/nullptr_t p2)
{
    /+ Q_UNUSED(p2) +/
    return !p1;
}+/

/+ template <class T>
void swap(QSharedDataPointer<T> &p1, QSharedDataPointer<T> &p2)
{ p1.swap(p2); }

template <class T>
void swap(QExplicitlySharedDataPointer<T> &p1, QExplicitlySharedDataPointer<T> &p2)
{ p1.swap(p2); }

template <class T>
uint qHash(const QSharedDataPointer<T> &ptr, uint seed = 0) noexcept
{
    return qHash(ptr.data(), seed);
}
template <class T>
uint qHash(const QExplicitlySharedDataPointer<T> &ptr, uint seed = 0) noexcept
{
    return qHash(ptr.data(), seed);
}

template<typename T> Q_DECLARE_TYPEINFO_BODY(QSharedDataPointer<T>, Q_MOVABLE_TYPE);
template<typename T> Q_DECLARE_TYPEINFO_BODY(QExplicitlySharedDataPointer<T>, Q_MOVABLE_TYPE); +/

