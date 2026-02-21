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
    static inline void cleanup(T *pointer) noexcept
    {
        // Enforce a complete type.
        // If you get a compile error here, read the section on forward declared
        // classes in the QScopedPointer documentation.
        typedef char IsIncompleteType[ sizeof(T) ? 1 : -1 ];
        (void) sizeof(IsIncompleteType);

        delete[] pointer;
    }
    void operator()(T *pointer) const noexcept
    {
        cleanup(pointer);
    }
};

struct QScopedPointerPodDeleter
{
    static inline void cleanup(void *pointer) noexcept { free(pointer); }
    void operator()(void *pointer) const noexcept { cleanup(pointer); }
};

#ifndef QT_NO_QOBJECT +/
struct QScopedPointerObjectDeleteLater(T) if (is(T : QObject))
{
    pragma(inline, true) static void cleanup(T pointer) { if (pointer) pointer.deleteLater(); }
    /+void operator ()(T* pointer) const { cleanup(pointer); }+/
}

alias QScopedPointerDeleteLater = QScopedPointerObjectDeleteLater!(QObject);
/+ #endif +/

/// Binding for C++ class [QScopedPointer](https://doc.qt.io/qt-6/qscopedpointer.html).
extern(C++, class) struct /+ [[nodiscard]] +/ QScopedPointer(T, Cleanup = QScopedPointerDeleter!T)
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

public:
    /+ explicit +/this(P p/+ = null+/) nothrow
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

    /+P operator ->() const nothrow
    {
        return d;
    }+/

    /+bool operator !() const nothrow
    {
        return !d;
    }+/

    /+/+ explicit +/ auto opCast(T : bool)() const
    {
        return !isNull();
    }+/

    P data() const nothrow
    {
        return cast(P)d;
    }
    
    alias data this;

    P get() const nothrow
    {
        return cast(P)d;
    }

    bool isNull() const nothrow
    {
        return !d;
    }

/+    void reset(P other = null) /+ noexcept(noexcept(Cleanup::cleanup(std::declval<T *>()))) +/
    {
        if (d == other)
            return;
        T* oldD = qExchange(d, cast(U && ) (other));
        Cleanup.cleanup(oldD);
    }+/

/+ #if QT_DEPRECATED_SINCE(6, 1) +/
    /+ QT_DEPRECATED_VERSION_X_6_1("Use std::unique_ptr instead, and call release().") +/
/+        T* take() nothrow
    {
        T* oldD = qExchange(d, cast(U && ) (null));
        return oldD;
    }+/
/+ #endif

#if QT_DEPRECATED_SINCE(6, 2) +/
    /+ QT_DEPRECATED_VERSION_X_6_2("Use std::unique_ptr instead of QScopedPointer.")
    void swap(QScopedPointer<T, Cleanup> &other) noexcept
    {
        qt_ptr_swap(d, other.d);
    } +/
/+ #endif +/

    alias pointer = P;

    /+ friend bool operator==(const QScopedPointer<T, Cleanup> &lhs, const QScopedPointer<T, Cleanup> &rhs) noexcept
    {
        return lhs.data() == rhs.data();
    } +/

    /+ friend bool operator!=(const QScopedPointer<T, Cleanup> &lhs, const QScopedPointer<T, Cleanup> &rhs) noexcept
    {
        return lhs.data() != rhs.data();
    } +/

    /+ friend bool operator==(const QScopedPointer<T, Cleanup> &lhs, std::nullptr_t) noexcept
    {
        return lhs.isNull();
    } +/

    /+ friend bool operator==(std::nullptr_t, const QScopedPointer<T, Cleanup> &rhs) noexcept
    {
        return rhs.isNull();
    } +/

    /+ friend bool operator!=(const QScopedPointer<T, Cleanup> &lhs, std::nullptr_t) noexcept
    {
        return !lhs.isNull();
    } +/

    /+ friend bool operator!=(std::nullptr_t, const QScopedPointer<T, Cleanup> &rhs) noexcept
    {
        return !rhs.isNull();
    } +/

/+ #if QT_DEPRECATED_SINCE(6, 2) +/
    /+ QT_DEPRECATED_VERSION_X_6_2("Use std::unique_ptr instead of QScopedPointer.")
    friend void swap(QScopedPointer<T, Cleanup> &p1, QScopedPointer<T, Cleanup> &p2) noexcept
    { p1.swap(p2); } +/
/+ #endif +/

protected:
    P d;

private:
    /+ Q_DISABLE_COPY_MOVE(QScopedPointer) +/
@disable this(this);
/+@disable this(ref const(QScopedPointer));+/@disable ref QScopedPointer opAssign(ref const(QScopedPointer));}

/// Binding for C++ class [QScopedArrayPointer](https://doc.qt.io/qt-6/qscopedarraypointer.html).
extern(C++, class) struct /+ [[nodiscard]] +/ QScopedArrayPointer(T, Cleanup )
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
    /+ inline ~QScopedArrayPointer() = default; +/

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

/+ #if QT_DEPRECATED_SINCE(6, 2) +/
    /+ QT_DEPRECATED_VERSION_X_6_2("Use std::unique_ptr instead of QScopedArrayPointer.")
    void swap(QScopedArrayPointer &other) noexcept // prevent QScopedPointer <->QScopedArrayPointer swaps
    { QScopedPointer<T, Cleanup>::swap(other); } +/
/+ #endif +/

private:
    /+ explicit +/ pragma(inline, true) this(void* )
    {
        // Enforce the same type.

        // If you get a compile error here, make sure you declare
        // QScopedArrayPointer with the same template type as you pass to the
        // constructor. See also the QScopedPointer documentation.

        // Storing a scalar array as a pointer to a different type is not
        // allowed and results in undefined behavior.
    }

    /+ Q_DISABLE_COPY_MOVE(QScopedArrayPointer) +/
@disable this(this);
/+@disable this(ref const(QScopedArrayPointer));+/@disable ref QScopedArrayPointer opAssign(ref const(QScopedArrayPointer));}

/+ #if QT_DEPRECATED_SINCE(6, 2)
template <typename T, typename Cleanup>
QT_DEPRECATED_VERSION_X_6_2("Use std::unique_ptr instead of QScopedArrayPointer.")
inline void swap(QScopedArrayPointer<T, Cleanup> &lhs, QScopedArrayPointer<T, Cleanup> &rhs) noexcept
{ lhs.swap(rhs); }
#endif +/

