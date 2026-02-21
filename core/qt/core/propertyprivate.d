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
module qt.core.propertyprivate;
extern(C++):

import qt.config;
import qt.core.bindingstorage;
import qt.core.global;
import qt.core.metatype;
import qt.core.property;
import qt.core.taggedpointer;
import qt.helpers;

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API.  It exists purely as an
// implementation detail.  This header file may change from version to
// version without notice, or even be removed.
//
// We mean it.
//



/+ template<typename Class, typename T, auto Offset, auto Setter, auto Signal, auto Getter>
class QObjectCompatProperty; +/

struct QBindingObserverPtr;
//alias PendingBindingObserverList = QVarLengthArray!(QBindingObserverPtr);

extern(C++, "QtPrivate") {
// QPropertyBindingPrivatePtr operates on a RefCountingMixin solely so that we can inline
// the constructor and copy constructor
struct RefCounted {
    int ref_ = 0;
    void addRef() {++ref_;}
    bool deref() {--ref_; return (ref_) != 0;}
}
}

extern(C++, class) struct QQmlPropertyBinding;
extern(C++, class) struct QPropertyBindingPrivate;
extern(C++, class) struct QPropertyBindingPrivatePtr
{
public:
    alias T = /+ QtPrivate:: +/RefCounted;
    ref T opUnary(string op)() const if (op == "*") { return *d; }
    /+T* operator ->() nothrow { return d; }+/
    /+T* operator ->() const nothrow { return d; }+/
    /+/+ explicit +/ auto opCast(T : T)() { return d; }+/
    /+/+ explicit +/ auto opCast(T : const(T))() const nothrow { return d; }+/
    T* data() /*const*/  nothrow { return d; }
    T* get() /*const*/  nothrow { return d; }
    const(T)* constData() const nothrow { return d; }
    T* take() nothrow { T* x = d; d = null; return x; }

    @disable this();
    /+this() nothrow
    {
        this.d = null;
    }+/
    ~this()
    {
        if (d && (--d.ref_ == 0))
            destroyAndFreeMemory();
    }
    /+ Q_CORE_EXPORT +/ void destroyAndFreeMemory();

    /+ explicit +/this(T* data) /*nothrow*/
    {
        this.d = data;
        if (d) d.addRef();
    }
    this(this)
    {
        if (d) d.addRef();
    }

    //void reset(T* ptr = null) nothrow;

    /+ref QPropertyBindingPrivatePtr opAssign(ref const(QPropertyBindingPrivatePtr) o) nothrow
    {
        reset(o.d);
        return this;
    }
    ref QPropertyBindingPrivatePtr opAssign(T* o) nothrow
    {
        reset(o);
        return this;
    }+/
    /+ QPropertyBindingPrivatePtr(QPropertyBindingPrivatePtr &&o) noexcept : d(qExchange(o.d, nullptr)) {} +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QPropertyBindingPrivatePtr) +/

    /+auto opCast(T : bool) () const nothrow { return d !is null; }+/
    /+bool operator !() const nothrow { return d is null; }+/

    /+ void swap(QPropertyBindingPrivatePtr &other) noexcept
    { qt_ptr_swap(d, other.d); } +/

    /+ friend bool operator==(const QPropertyBindingPrivatePtr &p1, const QPropertyBindingPrivatePtr &p2) noexcept
    { return p1.d == p2.d; } +/
    /+ friend bool operator!=(const QPropertyBindingPrivatePtr &p1, const QPropertyBindingPrivatePtr &p2) noexcept
    { return p1.d != p2.d; } +/
    /+ friend bool operator==(const QPropertyBindingPrivatePtr &p1, const T *ptr) noexcept
    { return p1.d == ptr; } +/
    /+ friend bool operator!=(const QPropertyBindingPrivatePtr &p1, const T *ptr) noexcept
    { return p1.d != ptr; } +/
    /+ friend bool operator==(const T *ptr, const QPropertyBindingPrivatePtr &p2) noexcept
    { return ptr == p2.d; } +/
    /+ friend bool operator!=(const T *ptr, const QPropertyBindingPrivatePtr &p2) noexcept
    { return ptr != p2.d; } +/
    /+ friend bool operator==(const QPropertyBindingPrivatePtr &p1, std::nullptr_t) noexcept
    { return !p1; } +/
    /+ friend bool operator!=(const QPropertyBindingPrivatePtr &p1, std::nullptr_t) noexcept
    { return p1; } +/
    /+ friend bool operator==(std::nullptr_t, const QPropertyBindingPrivatePtr &p2) noexcept
    { return !p2; } +/
    /+ friend bool operator!=(std::nullptr_t, const QPropertyBindingPrivatePtr &p2) noexcept
    { return p2; } +/

private:
    /+ QtPrivate:: +/RefCounted* d = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

struct QPropertyBindingDataPointer;
struct QPropertyObserverPointer;

extern(C++, class) struct QUntypedPropertyData
{
public:
    // sentinel to check whether a class inherits QUntypedPropertyData
    struct InheritsQUntypedPropertyData {}
}


// Used for grouped property evaluations
/+ namespace QtPrivate {
class QPropertyBindingData} +/
struct QPropertyProxyBindingData
{
    // acts as QPropertyBindingData::d_ptr
    quintptr d_ptr;
    /*
        The two members below store the original binding data and property
        data pointer of the property which gets proxied.
        They are set in QPropertyDelayedNotifications::addProperty
    */
    const(/+ QtPrivate:: +/QPropertyBindingData)* originalBindingData;
    QUntypedPropertyData* propertyData;
}

extern(C++, "QtPrivate") {

/*  used in BindingFunctionVTable::createFor; on all other compilers, void would work, but on
    MSVC this causes C2182 when compiling in C++20 mode. As we only need to provide some default
    value which gets ignored, we introduce this dummy type.
*/
struct MSVCWorkAround {}

struct BindingFunctionVTable
{
    alias CallFn = ExternCPPFunc!(bool function(QMetaType, QUntypedPropertyData* , void* ));
    alias DtorFn = ExternCPPFunc!(void function(void* ));
    alias MoveCtrFn = ExternCPPFunc!(void function(void* , void* ));
    const(CallFn) call;
    const(DtorFn) destroy;
    const(MoveCtrFn) moveConstruct;
    const(qsizetype) size;

    /+ template<typename Callable, typename PropertyType=MSVCWorkAround> +/
    /+ static constexpr BindingFunctionVTable createFor()
    {
        static_assert (alignof(Callable) <= alignof(std::max_align_t), "Bindings do not support overaligned functors!");
        return {
            /*call=*/[](QMetaType metaType, QUntypedPropertyData *dataPtr, void *f){
                if constexpr (!std::is_invocable_v<Callable>) {
                    // we got an untyped callable
                    static_assert (std::is_invocable_r_v<bool, Callable, QMetaType, QUntypedPropertyData *> );
                    auto untypedEvaluationFunction = static_cast<Callable *>(f);
                    return std::invoke(*untypedEvaluationFunction, metaType, dataPtr);
                } else if constexpr (!std::is_same_v<PropertyType, MSVCWorkAround>) {
                    Q_UNUSED(metaType);
                    QPropertyData<PropertyType> *propertyPtr = static_cast<QPropertyData<PropertyType> *>(dataPtr);
                    // That is allowed by POSIX even if Callable is a function pointer
                    auto evaluationFunction = static_cast<Callable *>(f);
                    PropertyType newValue = std::invoke(*evaluationFunction);
                    if constexpr (QTypeTraits::has_operator_equal_v<PropertyType>) {
                        if (newValue == propertyPtr->valueBypassingBindings())
                            return false;
                    }
                    propertyPtr->setValueBypassingBindings(std::move(newValue));
                    return true;
                } else {
                    // Our code will never instantiate this
                    Q_UNREACHABLE();
                    return false;
                }
            },
            /*destroy*/[](void *f){ static_cast<Callable *>(f)->~Callable(); },
            /*moveConstruct*/[](void *addr, void *other){
                new (addr) Callable(std::move(*static_cast<Callable *>(other)));
            },
            /*size*/sizeof(Callable)
        };
    } +/
}

/+ template<typename Callable, typename PropertyType=MSVCWorkAround>
inline constexpr BindingFunctionVTable bindingFunctionVTable = BindingFunctionVTable::createFor<Callable, PropertyType>(); +/


// writes binding result into dataPtr
struct QPropertyBindingFunction {
    const(/+ QtPrivate:: +/BindingFunctionVTable)* vtable;
    void* functor;
}

alias QPropertyObserverCallback = ExternCPPFunc!(void function(QUntypedPropertyData* ));
alias QPropertyBindingWrapper = ExternCPPFunc!(bool function(QMetaType, QUntypedPropertyData* dataPtr, QPropertyBindingFunction));

/*!
    \internal
    A property normally consists of the actual property value and metadata for the binding system.
    QPropertyBindingData is the latter part. It stores a pointer to either
    - a (potentially empty) linked list of notifiers, in case there is no binding set,
    - an actual QUntypedPropertyBinding when the property has a binding,
    - or a pointer to QPropertyProxyBindingData when notifications occur inside a grouped update.

    \sa QPropertyDelayedNotifications, beginPropertyUpdateGroup
 */
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QPropertyBindingData
{
private:
    // Mutable because the address of the observer of the currently evaluating binding is stored here, for
    // notification later when the value changes.
    /+ mutable +/ quintptr d_ptr = 0;
    /+ friend struct QT_PREPEND_NAMESPACE(QPropertyBindingDataPointer); +/
    /+ friend class QT_PREPEND_NAMESPACE(QQmlPropertyBinding); +/
    /+ friend struct QT_PREPEND_NAMESPACE(QPropertyDelayedNotifications); +/

    /+ template<typename Class, typename T, auto Offset, auto Setter, auto Signal, auto Getter> +/
    /+ friend class QT_PREPEND_NAMESPACE(QObjectCompatProperty); +/

    /+ Q_DISABLE_COPY(QPropertyBindingData) +/
@disable this(this);
/+@disable this(ref const(QPropertyBindingData));+/@disable ref QPropertyBindingData opAssign(ref const(QPropertyBindingData));public:
    /+ QPropertyBindingData() = default; +/
    /+ QPropertyBindingData(QPropertyBindingData &&other); +/
    /+ QPropertyBindingData &operator=(QPropertyBindingData &&other) = delete; +/
    ~this();

    // Is d_ptr pointing to a binding (1) or list of notifiers (0)?
    extern(D) static immutable quintptr BindingBit = 0x1;
    // Is d_ptr pointing to QPropertyProxyBindingData (1) or to an actual binding/list of notifiers?
    extern(D) static immutable quintptr DelayedNotificationBit = 0x2;

    bool hasBinding() const { return (d_ptr & BindingBit) != 0; }
    bool isNotificationDelayed() const { return (d_ptr & DelayedNotificationBit) != 0; }

    QUntypedPropertyBinding setBinding(ref const(QUntypedPropertyBinding) newBinding,
                                           QUntypedPropertyData* propertyDataPtr,
                                           QPropertyObserverCallback staticObserverCallback = null,
                                           QPropertyBindingWrapper bindingWrapper = null);

    QPropertyBindingPrivate* binding() /*const*/
    {
        quintptr dd = d();
        if (dd & BindingBit)
            return reinterpret_cast!(QPropertyBindingPrivate*)(dd - BindingBit);
        return null;

    }

    void evaluateIfDirty(const(QUntypedPropertyData)* ) const; // ### Kept for BC reasons, unused

    void removeBinding()
    {
        if (hasBinding())
            removeBinding_helper();
    }

    void registerWithCurrentlyEvaluatingBinding(/+ QtPrivate:: +/qt.core.bindingstorage.BindingEvaluationState* currentBinding) const
    {
        if (!currentBinding)
            return;
        registerWithCurrentlyEvaluatingBinding_helper(currentBinding);
    }
    void registerWithCurrentlyEvaluatingBinding() const;
    void notifyObservers(QUntypedPropertyData* propertyDataPtr) const;
    void notifyObservers(QUntypedPropertyData* propertyDataPtr, QBindingStorage* storage) const;
private:
    /*!
        \internal
        Returns a reference to d_ptr, except when d_ptr points to a proxy.
        In that case, a reference to proxy->d_ptr is returned instead.

        To properly support proxying, direct access to d_ptr only occurs when
        - a function actually deals with proxying (e.g.
          QPropertyDelayedNotifications::addProperty),
        - only the tag value is accessed (e.g. hasBinding) or
        - inside a constructor.
     */
    ref quintptr d_ref() /*const*/ return
    {
        quintptr *d = &d_ptr;
        if (isNotificationDelayed())
            return reinterpret_cast!(QPropertyProxyBindingData*)(d_ptr & ~(BindingBit|DelayedNotificationBit)).d_ptr;
        return *d;
    }
    quintptr d() /*const*/ { return d_ref(); }
    void registerWithCurrentlyEvaluatingBinding_helper(qt.core.bindingstorage.BindingEvaluationState* currentBinding) const;
    void removeBinding_helper();

    enum NotificationResult { Delayed, Evaluated }
    /*NotificationResult notifyObserver_helper(
                QUntypedPropertyData* propertyDataPtr, QBindingStorage* storage,
                QPropertyObserverPointer observer,
                ref PendingBindingObserverList bindingObservers) const;*/
}

extern(C++, class) struct QTagPreservingPointerToPointer(T, Tag)
{
public:
    /+ constexpr QTagPreservingPointerToPointer() = default; +/

    this(T** ptr)
    {
        this.d = reinterpret_cast!(quintptr*)(ptr);
    }

    ref QTagPreservingPointerToPointer!(T, Tag) opAssign(T** ptr)
    {
        d = reinterpret_cast!(quintptr*)(ptr);
        return this;
    }

    ref QTagPreservingPointerToPointer!(T, Tag) opAssign(QTaggedPointer!(T, Tag)* ptr)
    {
        d = reinterpret_cast!(quintptr*)(ptr);
        return this;
    }

    void clear()
    {
        d = null;
    }

    void setPointer(T* ptr)
    {
        *d = reinterpret_cast!(quintptr)(ptr) | (*d & QTaggedPointer!(T, Tag).tagMask());
    }

    T* get() const
    {
        return reinterpret_cast!(T*)(*d & QTaggedPointer!(T, Tag).pointerMask());
    }

    /+/+ explicit +/ auto opCast(T : bool)() const
    {
        return d !is null;
    }+/

private:
    quintptr* d = null;
}

extern(C++, "detail") {
    /+ template <typename F>
    struct ExtractClassFromFunctionPointer;

    template<typename T, typename C>
    struct ExtractClassFromFunctionPointer<T C::*> { using Class = C; }; +/

    size_t getOffset(size_t o)
    {
        return o;
    }
    size_t getOffset(ExternCPPFunc!(size_t function()) offsetFn)
    {
        return offsetFn();
    }
}

} // namespace QtPrivate

