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
module qt.core.scopedpointer;
extern(C++):

import qt.config;
import qt.core.object;
import qt.helpers;

struct QScopedPointerDeleter(T)
{
    static if (is(T == class))
    {
        alias P = T;
        enum IsIncompleteType = !__traits(compiles, __traits(classInstanceSize, T));
    }
    else
    {
        alias P = T*;
        enum IsIncompleteType = !__traits(compiles, T.sizeof);
    }
    static if (IsIncompleteType)
        static void cleanup(P pointer);
    else
        pragma(inline, true) static void cleanup(P pointer)
        {
            import core.stdcpp.new_;

            static if (IsIncompleteType)
                assert(false);
            else
                cpp_delete(pointer);
        }
}

/+ template <typename T>
struct QScopedPointerArrayDeleter
{
    static inline void cleanup(T *pointer)
    {
        // Enforce a complete type.
        // If you get a compile error here, read the section on forward declared
        // classes in the QScopedPointer documentation.
        typedef char IsIncompleteType[ sizeof(T) ? 1 : -1 ];
        (void) sizeof(IsIncompleteType);

        delete [] pointer;
    }
};

struct QScopedPointerPodDeleter
{
    static inline void cleanup(void *pointer) { if (pointer) free(pointer); }
};

#ifndef QT_NO_QOBJECT +/
struct QScopedPointerObjectDeleteLater(T) if (is(T : QObject))
{
    pragma(inline, true) static void cleanup(T pointer) { if (pointer) pointer.deleteLater(); }
}

alias QScopedPointerDeleteLater = QScopedPointerObjectDeleteLater!(QObject);
/+ #endif +/

/// Binding for C++ class [QScopedPointer](https://doc.qt.io/qt-5/qscopedpointer.html).
extern(C++, class) struct QScopedPointer(T, Cleanup = QScopedPointerDeleter!T)
{
private:
    static if (is(T == class))
    {
        alias P = T;
    }
    else
    {
        alias P = T*;
    }

    alias RestrictedBool = P/+ QScopedPointer:: * +/*;
public:
    /+ explicit +/this(P p/+ = null+/)/+ noexcept+/
    {
        this.d = p;
    }

    pragma(inline, true) ~this()
    {
        assert(false);
        /*P oldD = this.d;
        Cleanup.cleanup(oldD);*/
    }

    pragma(inline, true) ref T opUnary(string op)() const if (op == "*")
    {
        import qt.core.global;

        (mixin(Q_ASSERT(q{d})));
        return *d;
    }

    /+P operator ->() const/+ noexcept+/
    {
        return d;
    }+/

    /+bool operator !() const/+ noexcept+/
    {
        return !d;
    }+/

/+ #if defined(Q_QDOC)
    inline operator bool() const
    {
        return isNull() ? nullptr : &QScopedPointer::d;
    }
#else +/
    /+auto opCast(T : RestrictedBool)() const/+ noexcept+/
    {
        return isNull() ? null : &QScopedPointer.d;
    }+/
/+ #endif +/

    P data() const/+ noexcept+/
    {
        return cast(P)d;
    }
    
    alias data this;

    P get() const/+ noexcept+/
    {
        return cast(P)d;
    }

    bool isNull() const/+ noexcept+/
    {
        return !d;
    }

/+    void reset(P other = null) /+ noexcept(noexcept(Cleanup::cleanup(std::declval<T *>()))) +/
    {
        if (d == other)
            return;
        P oldD = d;
        d = other;
        Cleanup.cleanup(oldD);
    }+/

  /+  P take()/+ noexcept+/
    {
        P oldD = d;
        d = null;
        return oldD;
    }+/

    /+ void swap(QScopedPointer<T, Cleanup> &other) noexcept
    {
        qSwap(d, other.d);
    } +/

    alias pointer = P;

protected:
    P d = null;

private:
    /+ Q_DISABLE_COPY(QScopedPointer) +/
@disable this(this);
/+this(ref const(QScopedPointer));+//+ref QScopedPointer operator =(ref const(QScopedPointer));+/}

/+pragma(inline, true) bool operator ==(T, Cleanup)(ref const(QScopedPointer!(T, Cleanup)) lhs, ref const(QScopedPointer!(T, Cleanup)) rhs)/+ noexcept+/
{
    return lhs.data() == rhs.data();
}+/

/+pragma(inline, true) bool operator !=(T, Cleanup)(ref const(QScopedPointer!(T, Cleanup)) lhs, ref const(QScopedPointer!(T, Cleanup)) rhs)/+ noexcept+/
{
    return lhs.data() != rhs.data();
}+/

/+pragma(inline, true) bool operator ==(T, Cleanup)(ref const(QScopedPointer!(T, Cleanup)) lhs, /+ std:: +/nullptr_t)/+ noexcept+/
{
    return lhs.isNull();
}+/

/+pragma(inline, true) bool operator ==(T, Cleanup)(/+ std:: +/nullptr_t, ref const(QScopedPointer!(T, Cleanup)) rhs)/+ noexcept+/
{
    return rhs.isNull();
}+/

/+pragma(inline, true) bool operator !=(T, Cleanup)(ref const(QScopedPointer!(T, Cleanup)) lhs, /+ std:: +/nullptr_t)/+ noexcept+/
{
    return !lhs.isNull();
}+/

/+pragma(inline, true) bool operator !=(T, Cleanup)(/+ std:: +/nullptr_t, ref const(QScopedPointer!(T, Cleanup)) rhs)/+ noexcept+/
{
    return !rhs.isNull();
}+/

/+ template <class T, class Cleanup>
inline void swap(QScopedPointer<T, Cleanup> &p1, QScopedPointer<T, Cleanup> &p2) noexcept
{ p1.swap(p2); } +/

/// Binding for C++ class [QScopedArrayPointer](https://doc.qt.io/qt-5/qscopedarraypointer.html).
extern(C++, class) struct QScopedArrayPointer(T, Cleanup )
{
    public QScopedPointer!(T, Cleanup) base0;
    alias base0 this;
private:
    /+ template <typename Ptr> +/
    /+ using if_same_type = typename std::enable_if<std::is_same<typename std::remove_cv<T>::type, Ptr>::value, bool>::type; +/
public:
    @disable this();
    /+pragma(inline, true) this()
    {
        this.QScopedPointer!(T, Cleanup) = null;
    }+/

    /+ template <typename D, if_same_type<D> = true> +/
    /+ explicit +/this(D,)(D* p)
    {
        this.QScopedPointer!(T, Cleanup) = p;
    }

    pragma(inline, true) ref T opIndex(int i)
    {
        return this.d[i];
    }

    pragma(inline, true) ref const(T) opIndex(int i) const
    {
        return this.d[i];
    }

    /+ void swap(QScopedArrayPointer &other) noexcept // prevent QScopedPointer <->QScopedArrayPointer swaps
    { QScopedPointer<T, Cleanup>::swap(other); } +/

private:
    /+ explicit +/ pragma(inline, true) this(void* ) {
        // Enforce the same type.

        // If you get a compile error here, make sure you declare
        // QScopedArrayPointer with the same template type as you pass to the
        // constructor. See also the QScopedPointer documentation.

        // Storing a scalar array as a pointer to a different type is not
        // allowed and results in undefined behavior.
    }

    /+ Q_DISABLE_COPY(QScopedArrayPointer) +/
@disable this(this);
/+this(ref const(QScopedArrayPointer));+//+ref QScopedArrayPointer operator =(ref const(QScopedArrayPointer));+/}

/+ template <typename T, typename Cleanup>
inline void swap(QScopedArrayPointer<T, Cleanup> &lhs, QScopedArrayPointer<T, Cleanup> &rhs) noexcept
{ lhs.swap(rhs); } +/

