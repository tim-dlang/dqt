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
module qt.core.atomic;
extern(C++):

import qt.config;
import qt.core.basicatomic;
import qt.helpers;

/+ #ifndef QATOMIC_H +/
/+ #define QATOMIC_H


QT_WARNING_PUSH
QT_WARNING_DISABLE_GCC("-Wextra")

#ifdef Q_CLANG_QDOC
#  undef QT_BASIC_ATOMIC_HAS_CONSTRUCTORS
#endif +/

// High-level atomic integer operations
/// Binding for C++ class [QAtomicInteger](https://doc.qt.io/qt-6/qatomicinteger.html).
extern(C++, class) struct QAtomicInteger(T)
{
    public QBasicAtomicInteger!(T) base0;
    alias base0 this;
public:
    // Non-atomic API
/+ #ifdef QT_BASIC_ATOMIC_HAS_CONSTRUCTORS
    constexpr QAtomicInteger(T value = 0) noexcept : QBasicAtomicInteger<T>(value) {}
#else +/
    pragma(inline, true) this(T value/+ = 0+/)/+ noexcept+/
    {
        this._q_value = value;
    }
/+ #endif +/

    @disable this(this);
    pragma(inline, true) this(ref const(QAtomicInteger) other)/+ noexcept+/
/+ #ifdef QT_BASIC_ATOMIC_HAS_CONSTRUCTORS
        : QBasicAtomicInteger<T>()
#endif +/
    {
        base0.storeRelease(other.base0.loadAcquire());
    }

    /+pragma(inline, true) ref QAtomicInteger operator =(ref const(QAtomicInteger) other)/+ noexcept+/
    {
        this.storeRelease(other.loadAcquire());
        return this;
    }+/

/+ #ifdef Q_CLANG_QDOC
    T loadRelaxed() const;
    T loadAcquire() const;
    void storeRelaxed(T newValue);
    void storeRelease(T newValue);

    operator T() const;
    QAtomicInteger &operator=(T);

    static constexpr bool isReferenceCountingNative();
    static constexpr bool isReferenceCountingWaitFree();

    bool ref();
    bool deref();

    static constexpr bool isTestAndSetNative();
    static constexpr bool isTestAndSetWaitFree();

    bool testAndSetRelaxed(T expectedValue, T newValue);
    bool testAndSetAcquire(T expectedValue, T newValue);
    bool testAndSetRelease(T expectedValue, T newValue);
    bool testAndSetOrdered(T expectedValue, T newValue);

    static constexpr bool isFetchAndStoreNative();
    static constexpr bool isFetchAndStoreWaitFree();

    T fetchAndStoreRelaxed(T newValue);
    T fetchAndStoreAcquire(T newValue);
    T fetchAndStoreRelease(T newValue);
    T fetchAndStoreOrdered(T newValue);

    static constexpr bool isFetchAndAddNative();
    static constexpr bool isFetchAndAddWaitFree();

    T fetchAndAddRelaxed(T valueToAdd);
    T fetchAndAddAcquire(T valueToAdd);
    T fetchAndAddRelease(T valueToAdd);
    T fetchAndAddOrdered(T valueToAdd);

    T fetchAndSubRelaxed(T valueToSub);
    T fetchAndSubAcquire(T valueToSub);
    T fetchAndSubRelease(T valueToSub);
    T fetchAndSubOrdered(T valueToSub);

    T fetchAndOrRelaxed(T valueToOr);
    T fetchAndOrAcquire(T valueToOr);
    T fetchAndOrRelease(T valueToOr);
    T fetchAndOrOrdered(T valueToOr);

    T fetchAndAndRelaxed(T valueToAnd);
    T fetchAndAndAcquire(T valueToAnd);
    T fetchAndAndRelease(T valueToAnd);
    T fetchAndAndOrdered(T valueToAnd);

    T fetchAndXorRelaxed(T valueToXor);
    T fetchAndXorAcquire(T valueToXor);
    T fetchAndXorRelease(T valueToXor);
    T fetchAndXorOrdered(T valueToXor);

    T operator++();
    T operator++(int);
    T operator--();
    T operator--(int);
    T operator+=(T value);
    T operator-=(T value);
    T operator|=(T value);
    T operator&=(T value);
    T operator^=(T value);
#endif +/
}

/// Binding for C++ class [QAtomicInt](https://doc.qt.io/qt-6/qatomicint.html).
extern(C++, class) struct QAtomicInt
{
    public QAtomicInteger!(int) base0;
    alias base0 this;
public:
    // Non-atomic API
    // We could use QT_COMPILER_INHERITING_CONSTRUCTORS, but we need only one;
    // the implicit definition for all the others is fine.
/+ #ifdef QT_BASIC_ATOMIC_HAS_CONSTRUCTORS
    constexpr
#endif +/
    this(int value/+ = 0+/)/+ noexcept+/
    {
        this.base0 = typeof(this.base0)(value);
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

// High-level atomic pointer operations
/// Binding for C++ class [QAtomicPointer](https://doc.qt.io/qt-6/qatomicpointer.html).
extern(C++, class) struct QAtomicPointer(T)
{
    public QBasicAtomicPointer!(T) base0;
    alias base0 this;
public:
/+ #ifdef QT_BASIC_ATOMIC_HAS_CONSTRUCTORS
    constexpr QAtomicPointer(T *value = nullptr) noexcept : QBasicAtomicPointer<T>(value) {}
#else +/
    @disable this();
    pragma(inline, true) this(T* value/+ = null+/)/+ noexcept+/
    {
        this.storeRelaxed(value);
    }
/+ #endif +/
    @disable this(this);
    pragma(inline, true) this(ref const(QAtomicPointer!(T)) other)/+ noexcept+/
/+ #ifdef QT_BASIC_ATOMIC_HAS_CONSTRUCTORS
        : QBasicAtomicPointer<T>()
#endif +/
    {
        this.storeRelease(other.loadAcquire());
    }

    /+pragma(inline, true) ref QAtomicPointer!(T) operator =(ref const(QAtomicPointer!(T)) other)/+ noexcept+/
    {
        this.storeRelease(other.loadAcquire());
        return this;
    }+/

/+ #ifdef Q_QDOC
    T *loadAcquire() const;
    T *loadRelaxed() const;
    void storeRelaxed(T *newValue);
    void storeRelease(T *newValue);

    static constexpr bool isTestAndSetNative();
    static constexpr bool isTestAndSetWaitFree();

    bool testAndSetRelaxed(T *expectedValue, T *newValue);
    bool testAndSetAcquire(T *expectedValue, T *newValue);
    bool testAndSetRelease(T *expectedValue, T *newValue);
    bool testAndSetOrdered(T *expectedValue, T *newValue);

    static constexpr bool isFetchAndStoreNative();
    static constexpr bool isFetchAndStoreWaitFree();

    T *fetchAndStoreRelaxed(T *newValue);
    T *fetchAndStoreAcquire(T *newValue);
    T *fetchAndStoreRelease(T *newValue);
    T *fetchAndStoreOrdered(T *newValue);

    static constexpr bool isFetchAndAddNative();
    static constexpr bool isFetchAndAddWaitFree();

    T *fetchAndAddRelaxed(qptrdiff valueToAdd);
    T *fetchAndAddAcquire(qptrdiff valueToAdd);
    T *fetchAndAddRelease(qptrdiff valueToAdd);
    T *fetchAndAddOrdered(qptrdiff valueToAdd);
#endif +/
}

/+ QT_WARNING_POP

#ifdef QT_BASIC_ATOMIC_HAS_CONSTRUCTORS
#  undef QT_BASIC_ATOMIC_HAS_CONSTRUCTORS
#endif +/

/*!
    This is a helper for the assignment operators of implicitly
    shared classes. Your assignment operator should look like this:

    \snippet code/src.corelib.thread.qatomic.h 0
*/
pragma(inline, true) void qAtomicAssign(T)(ref T* d, T* x)
{
    import core.stdcpp.new_;

    if (d == x)
        return;
    x.ref_.ref_();
    if (!d.ref_.deref())
        cpp_delete(d);
    d = x;
}

/*!
    This is a helper for the detach method of implicitly shared
    classes. Your private class needs a copy constructor which copies
    the members and sets the refcount to 1. After that, your detach
    function should look like this:

    \snippet code/src.corelib.thread.qatomic.h 1
*/
pragma(inline, true) void qAtomicDetach(T)(ref T* d)
{
    import core.stdcpp.new_;

    if (d.ref_.loadRelaxed() == 1)
        return;
    T* x = d;
    d = cpp_new!T(*d);
    if (!x.ref_.deref())
        cpp_delete(x);
}

/+ #endif +/ // QATOMIC_H

