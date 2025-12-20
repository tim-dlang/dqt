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
module qt.core.basicatomic;
extern(C++):

import core.atomic;
import qt.config;
import qt.core.global;
import qt.helpers;

/+ #ifndef QBASICATOMIC_H +/
/+ #define QBASICATOMIC_H

#if defined(QT_BOOTSTRAPPED)
// If C++11 atomics are supported, use them!
// Note that constexpr support is sometimes disabled in QNX or INTEGRITY builds,
// but their libraries have <atomic>.
#elif defined(Q_COMPILER_ATOMICS) && (defined(Q_COMPILER_CONSTEXPR) || defined(Q_OS_QNX) || defined(Q_OS_INTEGRITY))
// We only support one fallback: MSVC, because even on version 2015, it lacks full constexpr support
#elif defined(Q_CC_MSVC)
// No fallback
#else
#  error "Qt requires C++11 support"
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_MSVC(4522)


#if 0
// silence syncqt warnings
#pragma qt_no_master_include
#pragma qt_sync_stop_processing
#endif

// New atomics

#if defined(Q_COMPILER_CONSTEXPR)
# if defined(Q_CC_CLANG) && Q_CC_CLANG < 303
   /*
      Do not define QT_BASIC_ATOMIC_HAS_CONSTRUCTORS for Clang before version 3.3.
      For details about the bug: see http://llvm.org/bugs/show_bug.cgi?id=12670
    */
# else
#  define QT_BASIC_ATOMIC_HAS_CONSTRUCTORS
# endif
#endif +/

extern(C++, class) struct QBasicAtomicInteger(T)
{
public:
    alias Type = T;
    //alias Ops = QAtomicOps!(T);
    // static check that this is a valid integer
//    mixin(Q_STATIC_ASSERT_X(q{QTypeInfo!(T).isIntegral}, q{"template parameter is not an integral type"}));
//    mixin(Q_STATIC_ASSERT_X(q{QAtomicOpsSupport!(T.sizeof).IsSupported}, q{"template parameter is an integral of a size not supported on this platform"}));

    Type _q_value;

    // Everything below is either implemented in ../arch/qatomic_XXX.h or (as fallback) in qgenericatomic.h
/+ #if QT_DEPRECATED_SINCE(5, 14) +/
//    /+ QT_DEPRECATED_VERSION_X_5_14("Use loadRelaxed") +/ T load() const/+ noexcept+/ { return loadRelaxed(); }
//    /+ QT_DEPRECATED_VERSION_X_5_14("Use storeRelaxed") +/ void store(T newValue)/+ noexcept+/ { storeRelaxed(newValue); }
/+ #endif +/

    T loadRelaxed() const/+ noexcept+/
    {
        return atomicLoad!(MemoryOrder.raw)(_q_value); 
    }
//    void storeRelaxed(T newValue)/+ noexcept+/ { Ops.storeRelaxed(_q_value, newValue); }

    T loadAcquire() const/+ noexcept+/{ return atomicLoad!(MemoryOrder.acq)(_q_value);  }
    void storeRelease(T newValue)/+ noexcept+/ { atomicStore!(MemoryOrder.rel)(_q_value, newValue); }
    /+auto opCast(T : T)() const/+ noexcept+/ { return loadAcquire(); }+/
    T opAssign(T newValue)/+ noexcept+/ { storeRelease(newValue); return newValue; }

//    static bool isReferenceCountingNative()/+ noexcept+/ { return Ops.isReferenceCountingNative(); }
//    static bool isReferenceCountingWaitFree()/+ noexcept+/ { return Ops.isReferenceCountingWaitFree(); }

    bool ref_()/+ noexcept+/ 
    {
        return atomicFetchAdd(_q_value, 1) + 1 != 0;
    }
    bool deref()/+ noexcept+/
    {
        return atomicFetchSub(_q_value, 1) - 1 != 0;
    }

//    static bool isTestAndSetNative()/+ noexcept+/ { return Ops.isTestAndSetNative(); }
//    static bool isTestAndSetWaitFree()/+ noexcept+/ { return Ops.isTestAndSetWaitFree(); }

    bool testAndSetRelaxed(T expectedValue, T newValue)/+ noexcept+/
    {
        bool tmp = cas!(MemoryOrder.raw, MemoryOrder.raw)(&_q_value, expectedValue, newValue);
        return tmp;
    }
/+    bool testAndSetAcquire(T expectedValue, T newValue)/+ noexcept+/
    { return Ops.testAndSetAcquire(_q_value, expectedValue, newValue); }
    bool testAndSetRelease(T expectedValue, T newValue)/+ noexcept+/
    { return Ops.testAndSetRelease(_q_value, expectedValue, newValue); }
    bool testAndSetOrdered(T expectedValue, T newValue)/+ noexcept+/
    { return Ops.testAndSetOrdered(_q_value, expectedValue, newValue); }
+/
    /+bool testAndSetRelaxed(T expectedValue, T newValue, ref T currentValue)/+ noexcept+/
    { return Ops.testAndSetRelaxed(_q_value, expectedValue, newValue, &currentValue); }+
    bool testAndSetAcquire(T expectedValue, T newValue, ref T currentValue)/+ noexcept+/
    { return Ops.testAndSetAcquire(_q_value, expectedValue, newValue, &currentValue); }
    bool testAndSetRelease(T expectedValue, T newValue, ref T currentValue)/+ noexcept+/
    { return Ops.testAndSetRelease(_q_value, expectedValue, newValue, &currentValue); }
    bool testAndSetOrdered(T expectedValue, T newValue, ref T currentValue)/+ noexcept+/
    { return Ops.testAndSetOrdered(_q_value, expectedValue, newValue, &currentValue); }
+/
//    static bool isFetchAndStoreNative()/+ noexcept+/ { return Ops.isFetchAndStoreNative(); }
//    static bool isFetchAndStoreWaitFree()/+ noexcept+/ { return Ops.isFetchAndStoreWaitFree(); }

/*    T fetchAndStoreRelaxed(T newValue)/+ noexcept+/
    { return Ops.fetchAndStoreRelaxed(_q_value, newValue); }
    T fetchAndStoreAcquire(T newValue)/+ noexcept+/
    { return Ops.fetchAndStoreAcquire(_q_value, newValue); }
    T fetchAndStoreRelease(T newValue)/+ noexcept+/
    { return Ops.fetchAndStoreRelease(_q_value, newValue); }
    T fetchAndStoreOrdered(T newValue)/+ noexcept+/
    { return Ops.fetchAndStoreOrdered(_q_value, newValue); }*/

//    static bool isFetchAndAddNative()/+ noexcept+/ { return Ops.isFetchAndAddNative(); }
//    static bool isFetchAndAddWaitFree()/+ noexcept+/ { return Ops.isFetchAndAddWaitFree(); }

/+    T fetchAndAddRelaxed(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndAddRelaxed(_q_value, valueToAdd); }
    T fetchAndAddAcquire(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndAddAcquire(_q_value, valueToAdd); }
    T fetchAndAddRelease(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndAddRelease(_q_value, valueToAdd); }
    T fetchAndAddOrdered(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndAddOrdered(_q_value, valueToAdd); }

    T fetchAndSubRelaxed(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndSubRelaxed(_q_value, valueToAdd); }
    T fetchAndSubAcquire(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndSubAcquire(_q_value, valueToAdd); }
    T fetchAndSubRelease(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndSubRelease(_q_value, valueToAdd); }
    T fetchAndSubOrdered(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndSubOrdered(_q_value, valueToAdd); }

    T fetchAndAndRelaxed(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndAndRelaxed(_q_value, valueToAdd); }
    T fetchAndAndAcquire(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndAndAcquire(_q_value, valueToAdd); }
    T fetchAndAndRelease(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndAndRelease(_q_value, valueToAdd); }
    T fetchAndAndOrdered(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndAndOrdered(_q_value, valueToAdd); }

    T fetchAndOrRelaxed(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndOrRelaxed(_q_value, valueToAdd); }
    T fetchAndOrAcquire(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndOrAcquire(_q_value, valueToAdd); }
    T fetchAndOrRelease(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndOrRelease(_q_value, valueToAdd); }
    T fetchAndOrOrdered(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndOrOrdered(_q_value, valueToAdd); }

    T fetchAndXorRelaxed(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndXorRelaxed(_q_value, valueToAdd); }
    T fetchAndXorAcquire(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndXorAcquire(_q_value, valueToAdd); }
    T fetchAndXorRelease(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndXorRelease(_q_value, valueToAdd); }
    T fetchAndXorOrdered(T valueToAdd)/+ noexcept+/
    { return Ops.fetchAndXorOrdered(_q_value, valueToAdd); }
+/
    T opUnary(string op)()/+ noexcept+/ if (op == "++")
    { return fetchAndAddOrdered(1) + 1; }
    /+T operator ++(int)/+ noexcept+/
    { return fetchAndAddOrdered(1); }+/
    T opUnary(string op)()/+ noexcept+/ if (op == "--")
    { return fetchAndSubOrdered(1) - 1; }
    /+T operator --(int)/+ noexcept+/
    { return fetchAndSubOrdered(1); }+/

    T opOpAssign(string op)(T v)/+ noexcept+/ if (op == "+")
    { return fetchAndAddOrdered(v) + v; }
    T opOpAssign(string op)(T v)/+ noexcept+/ if (op == "-")
    { return fetchAndSubOrdered(v) - v; }
    T opOpAssign(string op)(T v)/+ noexcept+/ if (op == "&")
    { return fetchAndAndOrdered(v) & v; }
    T opOpAssign(string op)(T v)/+ noexcept+/ if (op == "|")
    { return fetchAndOrOrdered(v) | v; }
    /+T operator ^=(T v)/+ noexcept+/
    { return fetchAndXorOrdered(v) ^ v; }+/


/+ #ifdef QT_BASIC_ATOMIC_HAS_CONSTRUCTORS
    QBasicAtomicInteger() = default;
    constexpr QBasicAtomicInteger(T value) noexcept : _q_value(value) {}
    QBasicAtomicInteger(const QBasicAtomicInteger &) = delete;
    QBasicAtomicInteger &operator=(const QBasicAtomicInteger &) = delete;
    QBasicAtomicInteger &operator=(const QBasicAtomicInteger &) volatile = delete;
#endif +/
}
alias QBasicAtomicInt = QBasicAtomicInteger!(int);

/+ template <typename X>
class QBasicAtomicPointer
{
public:
    typedef X *Type;
    typedef QAtomicOps<Type> Ops;
    typedef typename Ops::Type AtomicType;

    AtomicType _q_value;

#if QT_DEPRECATED_SINCE(5, 14)
    QT_DEPRECATED_VERSION_X_5_14("Use loadRelaxed") Type load() const noexcept { return loadRelaxed(); }
    QT_DEPRECATED_VERSION_X_5_14("Use storeRelaxed") void store(Type newValue) noexcept { storeRelaxed(newValue); }
#endif

    Type loadRelaxed() const noexcept { return Ops::loadRelaxed(_q_value); }
    void storeRelaxed(Type newValue) noexcept { Ops::storeRelaxed(_q_value, newValue); }

    operator Type() const noexcept { return loadAcquire(); }
    Type operator=(Type newValue) noexcept { storeRelease(newValue); return newValue; }

    // Atomic API, implemented in qatomic_XXX.h
    Type loadAcquire() const noexcept { return Ops::loadAcquire(_q_value); }
    void storeRelease(Type newValue) noexcept { Ops::storeRelease(_q_value, newValue); }

    static bool isTestAndSetNative() noexcept { return Ops::isTestAndSetNative(); }
    static bool isTestAndSetWaitFree() noexcept { return Ops::isTestAndSetWaitFree(); }

    bool testAndSetRelaxed(Type expectedValue, Type newValue) noexcept
    { return Ops::testAndSetRelaxed(_q_value, expectedValue, newValue); }
    bool testAndSetAcquire(Type expectedValue, Type newValue) noexcept
    { return Ops::testAndSetAcquire(_q_value, expectedValue, newValue); }
    bool testAndSetRelease(Type expectedValue, Type newValue) noexcept
    { return Ops::testAndSetRelease(_q_value, expectedValue, newValue); }
    bool testAndSetOrdered(Type expectedValue, Type newValue) noexcept
    { return Ops::testAndSetOrdered(_q_value, expectedValue, newValue); }

    bool testAndSetRelaxed(Type expectedValue, Type newValue, Type &currentValue) noexcept
    { return Ops::testAndSetRelaxed(_q_value, expectedValue, newValue, &currentValue); }
    bool testAndSetAcquire(Type expectedValue, Type newValue, Type &currentValue) noexcept
    { return Ops::testAndSetAcquire(_q_value, expectedValue, newValue, &currentValue); }
    bool testAndSetRelease(Type expectedValue, Type newValue, Type &currentValue) noexcept
    { return Ops::testAndSetRelease(_q_value, expectedValue, newValue, &currentValue); }
    bool testAndSetOrdered(Type expectedValue, Type newValue, Type &currentValue) noexcept
    { return Ops::testAndSetOrdered(_q_value, expectedValue, newValue, &currentValue); }

    static bool isFetchAndStoreNative() noexcept { return Ops::isFetchAndStoreNative(); }
    static bool isFetchAndStoreWaitFree() noexcept { return Ops::isFetchAndStoreWaitFree(); }

    Type fetchAndStoreRelaxed(Type newValue) noexcept
    { return Ops::fetchAndStoreRelaxed(_q_value, newValue); }
    Type fetchAndStoreAcquire(Type newValue) noexcept
    { return Ops::fetchAndStoreAcquire(_q_value, newValue); }
    Type fetchAndStoreRelease(Type newValue) noexcept
    { return Ops::fetchAndStoreRelease(_q_value, newValue); }
    Type fetchAndStoreOrdered(Type newValue) noexcept
    { return Ops::fetchAndStoreOrdered(_q_value, newValue); }

    static bool isFetchAndAddNative() noexcept { return Ops::isFetchAndAddNative(); }
    static bool isFetchAndAddWaitFree() noexcept { return Ops::isFetchAndAddWaitFree(); }

    Type fetchAndAddRelaxed(qptrdiff valueToAdd) noexcept
    { return Ops::fetchAndAddRelaxed(_q_value, valueToAdd); }
    Type fetchAndAddAcquire(qptrdiff valueToAdd) noexcept
    { return Ops::fetchAndAddAcquire(_q_value, valueToAdd); }
    Type fetchAndAddRelease(qptrdiff valueToAdd) noexcept
    { return Ops::fetchAndAddRelease(_q_value, valueToAdd); }
    Type fetchAndAddOrdered(qptrdiff valueToAdd) noexcept
    { return Ops::fetchAndAddOrdered(_q_value, valueToAdd); }

    Type fetchAndSubRelaxed(qptrdiff valueToAdd) noexcept
    { return Ops::fetchAndSubRelaxed(_q_value, valueToAdd); }
    Type fetchAndSubAcquire(qptrdiff valueToAdd) noexcept
    { return Ops::fetchAndSubAcquire(_q_value, valueToAdd); }
    Type fetchAndSubRelease(qptrdiff valueToAdd) noexcept
    { return Ops::fetchAndSubRelease(_q_value, valueToAdd); }
    Type fetchAndSubOrdered(qptrdiff valueToAdd) noexcept
    { return Ops::fetchAndSubOrdered(_q_value, valueToAdd); }

    Type operator++() noexcept
    { return fetchAndAddOrdered(1) + 1; }
    Type operator++(int) noexcept
    { return fetchAndAddOrdered(1); }
    Type operator--() noexcept
    { return fetchAndSubOrdered(1) - 1; }
    Type operator--(int) noexcept
    { return fetchAndSubOrdered(1); }
    Type operator+=(qptrdiff valueToAdd) noexcept
    { return fetchAndAddOrdered(valueToAdd) + valueToAdd; }
    Type operator-=(qptrdiff valueToSub) noexcept
    { return fetchAndSubOrdered(valueToSub) - valueToSub; }

#ifdef QT_BASIC_ATOMIC_HAS_CONSTRUCTORS
    QBasicAtomicPointer() = default;
    constexpr QBasicAtomicPointer(Type value) noexcept : _q_value(value) {}
    QBasicAtomicPointer(const QBasicAtomicPointer &) = delete;
    QBasicAtomicPointer &operator=(const QBasicAtomicPointer &) = delete;
    QBasicAtomicPointer &operator=(const QBasicAtomicPointer &) volatile = delete;
#endif
};

#ifndef Q_BASIC_ATOMIC_INITIALIZER
#  define Q_BASIC_ATOMIC_INITIALIZER(a) { (a) }
#endif


QT_WARNING_POP +/

/+ #endif +/ // QBASICATOMIC_H

