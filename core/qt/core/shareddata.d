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


/// Binding for C++ class [QSharedData](https://doc.qt.io/qt-6/qshareddata.html).
extern(C++, class) struct QSharedData
{
public:
    /+ mutable +/ QAtomicInt ref_/* = 0*/;

    @disable this();
    /+this()/+ noexcept+/
    {
        this.ref_ = 0;
    }+/
    @disable this(this);
    this(ref const(QSharedData) )/+ noexcept+/
    {
        this.ref_ = 0;
    }

    // using the assignment operator would lead to corruption in the ref-counting
    /+ref QSharedData operator =(ref const(QSharedData) ) /+ = delete +/;+/
    /+ ~QSharedData() = default; +/
}

struct QAdoptSharedDataTag { /+ explicit constexpr QAdoptSharedDataTag() = default; +/     mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ #define DECLARE_COMPARE_SET(T1, A1, T2, A2) \
    friend bool operator<(T1, T2) noexcept \
    { return std::less<T*>{}(A1, A2); } \
    friend bool operator<=(T1, T2) noexcept \
    { return !std::less<T*>{}(A2, A1); } \
    friend bool operator>(T1, T2) noexcept \
    { return std::less<T*>{}(A2, A1); } \
    friend bool operator>=(T1, T2) noexcept \
    { return !std::less<T*>{}(A1, A2); } \
    friend bool operator==(T1, T2) noexcept \
    { return A1 == A2; } \
    friend bool operator!=(T1, T2) noexcept \
    { return A1 != A2; } \
 +/

/// Binding for C++ class [QSharedDataPointer](https://doc.qt.io/qt-6/qshareddatapointer.html).
extern(C++, class) struct QSharedDataPointer(T)
{
public:
    alias Type = T;
    alias pointer = T*;

    void detach()() { if (d && d.ref_.loadRelaxed() != 1) detach_helper(); }
    ref T opUnary(string op)() if (op == "*") { detach(); return *d; }
    ref const(T) opUnary(string op)() const if (op == "*") { return *d; }
    /+T* operator ->() { detach(); return d; }+/
    /+const(T)* operator ->() const/+ noexcept+/ { return d; }+/
    /+auto opCast(T : T)() { detach(); return d; }+/
    /+auto opCast(T : const(T))() const/+ noexcept+/ { return d; }+/
    T* data()() { detach(); return d; }
    T* get()() { detach(); return d; }
    const(T)* data() const/+ noexcept+/ { return d; }
    const(T)* get() const/+ noexcept+/ { return d; }
    const(T)* constData() const/+ noexcept+/ { return d; }
//    T* take()/+ noexcept+/ { return qExchange(d, cast(U && ) (null)); }

    /+this()/+ noexcept+/
    {
        this.d = null;
    }+/
    ~this() {
        import core.stdcpp.new_;
        static if (__traits(compiles, (*d).sizeof))
        {
            import core.stdcpp.new_;
            if (d && !d.ref_.deref()) cpp_delete(d);
        }
        else
            assert(false);
    }

/+    /+ explicit +/this(T* data)/+ noexcept+/
    {
        this.d = data;
        if (d) d.ref_.ref_();
    }+/
    this(T* data, QAdoptSharedDataTag)/+ noexcept+/
    {
        this.d = data;
    }
    @disable this(this);
    this(ref const(QSharedDataPointer) o)/+ noexcept+/
    {
        static if (__traits(compiles, d.ref_))
        {
            if (d) d.ref_.ref_();
        }
        else
            assert(0);
    }

/+    void reset(T* ptr = null)/+ noexcept+/
    {
        import core.stdcpp.new_;

        if (ptr != d) {
            if (ptr)
                ptr.ref_.ref_();
            T* old = qExchange(d, cast(U && ) (ptr));
            if (old && !old.ref_.deref())
                cpp_delete(old);
        }
    }+/

    /+ref QSharedDataPointer operator =(ref const(QSharedDataPointer) o)/+ noexcept+/
    {
        reset(o.d);
        return this;
    }+/
    /+pragma(inline, true) ref QSharedDataPointer operator =(T* o)/+ noexcept+/
    {
        reset(o);
        return this;
    }+/
    /+ QSharedDataPointer(QSharedDataPointer &&o) noexcept : d(qExchange(o.d, nullptr)) {} +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QSharedDataPointer) +/

    /+auto opCast(T : bool) () const/+ noexcept+/ { return d !is null; }+/
    /+bool operator !() const/+ noexcept+/ { return d is null; }+/

    /+ void swap(QSharedDataPointer &other) noexcept
    { qSwap(d, other.d); } +/

/+ #define DECLARE_COMPARE_SET(T1, A1, T2, A2) \
    friend bool operator<(T1, T2) noexcept \
    { return std::less<T*>{}(A1, A2); } \
    friend bool operator<=(T1, T2) noexcept \
    { return !std::less<T*>{}(A2, A1); } \
    friend bool operator>(T1, T2) noexcept \
    { return std::less<T*>{}(A2, A1); } \
    friend bool operator>=(T1, T2) noexcept \
    { return !std::less<T*>{}(A1, A2); } \
    friend bool operator==(T1, T2) noexcept \
    { return A1 == A2; } \
    friend bool operator!=(T1, T2) noexcept \
    { return A1 != A2; } \

    DECLARE_COMPARE_SET(const QSharedDataPointer &p1, p1.d, const QSharedDataPointer &p2, p2.d) +/
    /+ DECLARE_COMPARE_SET(const QSharedDataPointer &p1, p1.d, const T *ptr, ptr) +/
    /+ DECLARE_COMPARE_SET(const T *ptr, ptr, const QSharedDataPointer &p2, p2.d) +/
    /+ DECLARE_COMPARE_SET(const QSharedDataPointer &p1, p1.d, std::nullptr_t, nullptr) +/
    /+ DECLARE_COMPARE_SET(std::nullptr_t, nullptr, const QSharedDataPointer &p2, p2.d) +/

protected:
    // Declared here and as Q_OUTOFLINE_TEMPLATE to work-around MSVC bug causing missing symbols at link time.
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

    T* d = null;
}

/// Binding for C++ class [QExplicitlySharedDataPointer](https://doc.qt.io/qt-6/qexplicitlyshareddatapointer.html).
extern(C++, class) struct QExplicitlySharedDataPointer(T) if (!is(T == class))
{
public:
    alias Type = T;
    alias pointer = T*;

    ref T opUnary(string op)() const if (op == "*") { return *d; }
    /+T* operator ->()/+ noexcept+/ { return d; }+/
    /+T* operator ->() const/+ noexcept+/ { return d; }+/
    /+/+ explicit +/ auto opCast(T : T)() { return d; }+/
    /+/+ explicit +/ auto opCast(T : const(T))() const/+ noexcept+/ { return d; }+/
    T* data() /*const*/ /+ noexcept+/ { return d; }
    T* get() /*const*/ /+ noexcept+/ { return d; }
    const(T)* constData() const/+ noexcept+/ { return d; }
//    T* take()/+ noexcept+/ { return qExchange(d, cast(U && ) (null)); }

    void detach()() { if (d && d.ref_.loadRelaxed() != 1) detach_helper(); }

    /+this()/+ noexcept+/
    {
        this.d = null;
    }+/
    ~this() {
        static if (__traits(compiles, (*d).sizeof))
        {
            import core.stdcpp.new_;
            if (d && !d.ref_.deref()) cpp_delete(d);
        }
        else
            assert(false);
    }

    /+ /+ explicit +/this(T* data)/+ noexcept+/
    {
        this.d = data;
        if (d) d.ref_.ref_();
    }+/
    this(T* data, QAdoptSharedDataTag)/+ noexcept+/
    {
        this.d = data;
    }
    @disable this(this);
    /+this(ref const(QExplicitlySharedDataPointer) o)/+ noexcept+/
    {
        static if (__traits(compiles, (*d).sizeof))
        {
            this.d = cast(T*)o.d;
            if (d) d.ref_.ref_();
        }
        else
            assert(false);
    }+/

    /+ template<typename X> +/
    /+ @disable this(this);
    this(X)(ref const(QExplicitlySharedDataPointer!(X)) o)/+ noexcept+//+ #ifdef QT_ENABLE_QEXPLICITLYSHAREDDATAPOINTER_STATICCAST +/
/+ #endif +/
{
    static if (defined!"QT_ENABLE_QEXPLICITLYSHAREDDATAPOINTER_STATICCAST")
    {
        this.d = static_cast!(T*)(o.data());

    }
    else
    {
        /+ #else +/
                this.d = o.data();

    }
    if (d) d.ref_.ref_();
} +/

/+    void reset(T* ptr = null)/+ noexcept+/
    {
        import core.stdcpp.new_;

        if (ptr != d) {
            if (ptr)
                ptr.ref_.ref_();
            T* old = qExchange(d, cast(U && ) (ptr));
            if (old && !old.ref_.deref())
                cpp_delete(old);
        }
    }+/

    /+ref QExplicitlySharedDataPointer operator =(ref const(QExplicitlySharedDataPointer) o)/+ noexcept+/
    {
        reset(o.d);
        return this;
    }+/
    /+ref QExplicitlySharedDataPointer operator =(T* o)/+ noexcept+/
    {
        reset(o);
        return this;
    }+/
    /+ QExplicitlySharedDataPointer(QExplicitlySharedDataPointer &&o) noexcept : d(qExchange(o.d, nullptr)) {} +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QExplicitlySharedDataPointer) +/

    /+auto opCast(T : bool) () const/+ noexcept+/ { return d !is null; }+/
    /+bool operator !() const/+ noexcept+/ { return d is null; }+/

    /+ void swap(QExplicitlySharedDataPointer &other) noexcept
    { qSwap(d, other.d); } +/

    /+ DECLARE_COMPARE_SET(const QExplicitlySharedDataPointer &p1, p1.d, const QExplicitlySharedDataPointer &p2, p2.d) +/
    /+ DECLARE_COMPARE_SET(const QExplicitlySharedDataPointer &p1, p1.d, const T *ptr, ptr) +/
    /+ DECLARE_COMPARE_SET(const T *ptr, ptr, const QExplicitlySharedDataPointer &p2, p2.d) +/
    /+ DECLARE_COMPARE_SET(const QExplicitlySharedDataPointer &p1, p1.d, std::nullptr_t, nullptr) +/
    /+ DECLARE_COMPARE_SET(std::nullptr_t, nullptr, const QExplicitlySharedDataPointer &p2, p2.d) +/

/+ #undef DECLARE_COMPARE_SET +/

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

    T* d = null;
}

/+ template <typename T>
void swap(QSharedDataPointer<T> &p1, QSharedDataPointer<T> &p2) noexcept
{ p1.swap(p2); }

template <typename T>
void swap(QExplicitlySharedDataPointer<T> &p1, QExplicitlySharedDataPointer<T> &p2) noexcept
{ p1.swap(p2); }

template <typename T>
size_t qHash(const QSharedDataPointer<T> &ptr, size_t seed = 0) noexcept
{
    return qHash(ptr.data(), seed);
}
template <typename T>
size_t qHash(const QExplicitlySharedDataPointer<T> &ptr, size_t seed = 0) noexcept
{
    return qHash(ptr.data(), seed);
}

template<typename T> Q_DECLARE_TYPEINFO_BODY(QSharedDataPointer<T>, Q_RELOCATABLE_TYPE);
template<typename T> Q_DECLARE_TYPEINFO_BODY(QExplicitlySharedDataPointer<T>, Q_RELOCATABLE_TYPE);

#define QT_DECLARE_QSDP_SPECIALIZATION_DTOR(Class) \
    template<> QSharedDataPointer<Class>::~QSharedDataPointer();

#define QT_DECLARE_QSDP_SPECIALIZATION_DTOR_WITH_EXPORT(Class, ExportMacro) \
    template<> ExportMacro QSharedDataPointer<Class>::~QSharedDataPointer();

#define QT_DEFINE_QSDP_SPECIALIZATION_DTOR(Class) \
    template<> QSharedDataPointer<Class>::~QSharedDataPointer() \
    { \
        if (d && !d->ref.deref()) \
            delete d; \
    }

#define QT_DECLARE_QESDP_SPECIALIZATION_DTOR(Class) \
    template<> QExplicitlySharedDataPointer<Class>::~QExplicitlySharedDataPointer();

#define QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(Class, ExportMacro) \
    template<> ExportMacro QExplicitlySharedDataPointer<Class>::~QExplicitlySharedDataPointer();

#define QT_DEFINE_QESDP_SPECIALIZATION_DTOR(Class) \
    template<> QExplicitlySharedDataPointer<Class>::~QExplicitlySharedDataPointer() \
    { \
        if (d && !d->ref.deref()) \
            delete d; \
    } +/


