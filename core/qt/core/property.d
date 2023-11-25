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
module qt.core.property;
extern(C++):

import qt.config;
import qt.core.anystringview;
import qt.core.global;
import qt.core.metatype;
import qt.core.propertyprivate;
import qt.core.shareddata;
import qt.core.string;
import qt.core.taggedpointer;
import qt.core.typeinfo;
import qt.helpers;

/+ #if __has_include(<source_location>) && __cplusplus >= 202002L && !defined(Q_CLANG_QDOC)
#if defined(__cpp_lib_source_location)
#define QT_SOURCE_LOCATION_NAMESPACE std
#define QT_PROPERTY_COLLECT_BINDING_LOCATION
#define QT_PROPERTY_DEFAULT_BINDING_LOCATION QPropertyBindingSourceLocation(std::source_location::current())
#endif
#endif +/

static if(!defined!"QT_PROPERTY_COLLECT_BINDING_LOCATION")
{
/+ #if defined(__cpp_lib_experimental_source_location) +/
/+ #define QT_SOURCE_LOCATION_NAMESPACE std::experimental
#define QT_PROPERTY_COLLECT_BINDING_LOCATION +/
/+ #define QT_PROPERTY_DEFAULT_BINDING_LOCATION QPropertyBindingSourceLocation(std::experimental::source_location::current()) +/
enum QT_PROPERTY_DEFAULT_BINDING_LOCATION = q{QPropertyBindingSourceLocation(current())};
/+ #endif +/
}

/+ #if !defined(QT_PROPERTY_COLLECT_BINDING_LOCATION)
#define QT_PROPERTY_DEFAULT_BINDING_LOCATION QPropertyBindingSourceLocation()
#endif +/


extern(C++, "Qt") {
/+ Q_CORE_EXPORT +/ void beginPropertyUpdateGroup();
/+ Q_CORE_EXPORT +/ void endPropertyUpdateGroup();
}

/// Binding for C++ class [QPropertyData](https://doc.qt.io/qt-6/qpropertydata.html).
extern(C++, class) struct QPropertyData(T)
{
    public QUntypedPropertyData base0;
    alias base0 this;
protected:
    /+ mutable +/ T val = T();
private:
    extern(C++, class) struct DisableRValueRefs {}
protected:
    extern(D) static immutable bool UseReferences = !(/+ std:: +/is_arithmetic_v!(T) || /+ std:: +/is_enum_v!(T) || /+ std:: +/is_pointer_v!(T));
public:
/*    alias value_type = T;
    alias parameter_type = /+ std:: +/conditional_t!(UseReferences, ref const(T), T);
    /+ using rvalue_ref = typename std::conditional_t<UseReferences, T &&, DisableRValueRefs>; +/
    alias arrow_operator_result = /+ std:: +/conditional_t!(bool, ref const(T),
                                            /+ std:: +/conditional_t!(bool, ref const(T), void));

    /+ QPropertyData() = default; +/
    this(parameter_type t)
    {
        this.val = t;
    }
    this(rvalue_ref t)
    {
        this.val = /+ std:: +/move(t);
    }
    /+ ~QPropertyData() = default; +/

    parameter_type valueBypassingBindings() const { return val; }
    void setValueBypassingBindings(parameter_type v) { val = v; }
    void setValueBypassingBindings(rvalue_ref v) { val = /+ std:: +/move(v); }*/
}

struct /+ Q_CORE_EXPORT +/ QPropertyBindingSourceLocation
{
    const(char)* fileName = null;
    const(char)* functionName = null;
    quint32 line = 0;
    quint32 column = 0;
    /+ QPropertyBindingSourceLocation() = default; +/
/+ #ifdef QT_PROPERTY_COLLECT_BINDING_LOCATION +/
/+    this(ref UnknownType!q{/+ QT_SOURCE_LOCATION_NAMESPACE:: +/source_location source_location} cppLocation)
    {
        fileName = cppLocation.file_name();
        functionName = cppLocation.function_name();
        line = cppLocation.line();
        column = cppLocation.column();
    }+/
/+ #endif +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QPropertyBindingErrorPrivate;

/// Binding for C++ class [QPropertyBindingError](https://doc.qt.io/qt-6/qpropertybindingerror.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QPropertyBindingError
{
public:
    enum Type {
        NoError,
        BindingLoop,
        EvaluationError,
        UnknownError
    }

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(Type type, ref const(QString) description = globalInitVar!QString);

    @disable this(this);
    this(ref const(QPropertyBindingError) other);
    /+ref QPropertyBindingError operator =(ref const(QPropertyBindingError) other);+/
    /+ QPropertyBindingError(QPropertyBindingError &&other); +/
    /+ QPropertyBindingError &operator=(QPropertyBindingError &&other); +/
    ~this();

    bool hasError() const { return d.get() !is null; }
    Type type() const;
    QString description() const;

private:
    QSharedDataPointer!(QPropertyBindingErrorPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct /+ Q_CORE_EXPORT +/ QUntypedPropertyBinding
{
public:
    // writes binding result into dataPtr
    alias BindingFunctionVTable = /+ QtPrivate:: +/qt.core.propertyprivate.BindingFunctionVTable;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(QMetaType metaType, const(BindingFunctionVTable)* vtable, void* function_, ref const(QPropertyBindingSourceLocation) location);

    /+ template<typename Functor> +/
    /+ QUntypedPropertyBinding(QMetaType metaType, Functor &&f, const QPropertyBindingSourceLocation &location)
        : QUntypedPropertyBinding(metaType, &QtPrivate::bindingFunctionVTable<std::remove_reference_t<Functor>>, &f, location)
    {} +/

    /+ QUntypedPropertyBinding(QUntypedPropertyBinding &&other); +/
    @disable this(this);
    this(ref const(QUntypedPropertyBinding) other);
    /+ref QUntypedPropertyBinding operator =(ref const(QUntypedPropertyBinding) other);+/
    /+ QUntypedPropertyBinding &operator=(QUntypedPropertyBinding &&other); +/
    ~this();

    bool isNull() const;

    QPropertyBindingError error() const;

    QMetaType valueMetaType() const;

    /+ explicit +/this(QPropertyBindingPrivate* priv);
private:
    /+ friend class QtPrivate::QPropertyBindingData; +/
    /+ friend class QPropertyBindingPrivate; +/
    /+ template <typename> +/ /+ friend class QPropertyBinding; +/
    QPropertyBindingPrivatePtr d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QPropertyBinding(PropertyType)
{
    public QUntypedPropertyBinding base0;
    alias base0 this;

public:
    /+ QPropertyBinding() = default; +/

    /+ template<typename Functor> +/
    /+ QPropertyBinding(Functor &&f, const QPropertyBindingSourceLocation &location)
        : QUntypedPropertyBinding(QMetaType::fromType<PropertyType>(), &QtPrivate::bindingFunctionVTable<std::remove_reference_t<Functor>, PropertyType>, &f, location)
    {} +/


    // Internal
    /+ explicit +/this(ref const(QUntypedPropertyBinding) binding)
    {
        this.base0 = QUntypedPropertyBinding(binding);
    }
}

/+ namespace Qt {
    template <typename Functor>
    auto makePropertyBinding(Functor &&f, const QPropertyBindingSourceLocation &location = QT_PROPERTY_DEFAULT_BINDING_LOCATION,
                             std::enable_if_t<std::is_invocable_v<Functor>> * = nullptr)
    {
        return QPropertyBinding<std::invoke_result_t<Functor>>(std::forward<Functor>(f), location);
    }
} +/

struct QPropertyObserverPrivate;
struct QPropertyObserverPointer;

extern(C++, class) struct QPropertyObserverBase
{
public:
    // Internal
    enum ObserverTag {
        ObserverNotifiesBinding, // observer was installed to notify bindings that obsverved property changed
        ObserverNotifiesChangeHandler, // observer is a change handler, which runs on every change
        ObserverIsPlaceholder,  // the observer before this one is currently evaluated in QPropertyObserver::notifyObservers.
        ObserverIsAlias
    }
protected:
    alias ChangeHandler = ExternCPPFunc!(void function(QPropertyObserver*, QUntypedPropertyData* ));

private:
    /+ friend struct QPropertyDelayedNotifications; +/
    /+ friend struct QPropertyObserverNodeProtector; +/
    /+ friend class QPropertyObserver; +/
    /+ friend struct QPropertyObserverPointer; +/
    /+ friend struct QPropertyBindingDataPointer; +/
    /+ friend class QPropertyBindingPrivate; +/

    QTaggedPointer!(QPropertyObserver, ObserverTag) next;
    // prev is a pointer to the "next" element within the previous node, or to the "firstObserverPtr" if it is the
    // first node.
    /+ QtPrivate:: +/qt.core.propertyprivate.QTagPreservingPointerToPointer!(QPropertyObserver, ObserverTag) prev;

    union {
        QPropertyBindingPrivate* binding = null;
        ChangeHandler changeHandler;
        QUntypedPropertyData* aliasData;
    }
}

extern(C++, class) struct /+ Q_CORE_EXPORT +/ QPropertyObserver
{
    public QPropertyObserverBase base0;
    alias base0 this;
protected:
    alias ChangeHandler = QPropertyObserverBase.ChangeHandler;
public:
    /+ constexpr QPropertyObserver() = default; +/
    /+ QPropertyObserver(QPropertyObserver &&other) noexcept; +/
    /+ QPropertyObserver &operator=(QPropertyObserver &&other) noexcept; +/
    ~this();

    /+ template<typename Property, typename = typename Property::InheritsQUntypedPropertyData> +/
    void setSource(Property,)(ref const(Property) property)
    { setSource(property.bindingData()); }
    void setSource(ref const(/+ QtPrivate:: +/qt.core.propertyprivate.QPropertyBindingData) property);

protected:
    this(ChangeHandler changeHandler);
    this(QUntypedPropertyData* aliasedPropertyPtr);

    QUntypedPropertyData* aliasedProperty() /*const*/
    {
        return aliasData;
    }

private:

    @disable this(this);
    /+this(ref const(QPropertyObserver) ) /+ = delete +/;+/
    /+ref QPropertyObserver operator =(ref const(QPropertyObserver) ) /+ = delete +/;+/

    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QPropertyChangeHandler](https://doc.qt.io/qt-6/qpropertychangehandler.html).
extern(C++, class) struct /+ [[nodiscard]] +/ QPropertyChangeHandler(Functor)
{
    public QPropertyObserver base0;
    alias base0 this;
private:
    Functor m_handler;
public:
/*    this(Functor handler)
    {
        this.base0 = QPropertyObserver([](QPropertyObserver *self, QUntypedPropertyData *) {
                      auto This = static_cast!(QPropertyChangeHandler!(Functor)*)(self);
                      This.m_handler();
                  });
        this.m_handler = handler;
    }*/

    /+ template<typename Property, typename = typename Property::InheritsQUntypedPropertyData> +/
    /+ this(Property,)(ref const(Property) property, Functor handler)
    {
        this.base0 = QPropertyObserver([](QPropertyObserver *self, QUntypedPropertyData *) {
                      auto This = static_cast!(QPropertyChangeHandler!(Functor)*)(self);
                      This.m_handler();
                  });
        this.m_handler = handler;

        setSource(property);
    } +/
}

/// Binding for C++ class [QPropertyNotifier](https://doc.qt.io/qt-6/qpropertynotifier.html).
/+extern(C++, class) struct /+ [[nodiscard]] +/ QPropertyNotifier
{
    public QPropertyObserver base0;
    alias base0 this;
private:
    /+ std:: +/function_!(UnresolvedMergeConflict!(q{UnknownType!q{void}},q{void()})) m_handler;
public:
    /+ QPropertyNotifier() = default; +/
    /+ template<typename Functor> +/
    this(Functor)(Functor handler)
    {
        this.base0 = QPropertyObserver([](QPropertyObserver *self, QUntypedPropertyData *) {
                    auto This = static_cast!(QPropertyNotifier*)(self);
                    This.m_handler();
                });
        this.m_handler = handler;
    }

    /+ template<typename Functor, typename Property, typename = typename Property::InheritsQUntypedPropertyData> +/
    this(Functor,Property,)(ref const(Property) property, Functor handler)
    {
        this.base0 = QPropertyObserver([](QPropertyObserver *self, QUntypedPropertyData *) {
                    auto This = static_cast!(QPropertyNotifier*)(self);
                    This.m_handler();
                });
        this.m_handler = handler;

        setSource(property);
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}+/

/// Binding for C++ class [QProperty](https://doc.qt.io/qt-6/qproperty.html).
extern(C++, class) struct QProperty(T)
{
    public QPropertyData!(T) base0;
    alias base0 this;
private:
    /+ QtPrivate:: +/qt.core.propertyprivate.QPropertyBindingData d;
    bool is_equal(ref const(T) v)
    {
        static if (/+ QTypeTraits:: +/qt.core.typeinfo.has_operator_equal_v!(T)) {
            if (v == this.val)
                return true;
        }
        return false;
    }

public:
    alias value_type = QPropertyData!(T).value_type;
    alias parameter_type = QPropertyData!(T).parameter_type;
    /+ using rvalue_ref = typename QPropertyData<T>::rvalue_ref; +/
    alias arrow_operator_result = QPropertyData!(T).arrow_operator_result;

    /+ QProperty() = default; +/
    /+ explicit +/this(parameter_type initialValue)
    {
        this.QPropertyData!(T) = initialValue;
    }
    /+ explicit +/this(rvalue_ref initialValue)
    {
        this.QPropertyData!(T) = /+ std:: +/move(initialValue);
    }
    /+ explicit +/this(ref const(QPropertyBinding!(T)) binding)
    {
        setBinding(binding);
    }
/+ #ifndef Q_CLANG_QDOC +/
    /+ template <typename Functor> +/
    /+ explicit QProperty(Functor &&f, const QPropertyBindingSourceLocation &location = QT_PROPERTY_DEFAULT_BINDING_LOCATION,
                       typename std::enable_if_t<std::is_invocable_r_v<T, Functor&>> * = nullptr)
        : QProperty(QPropertyBinding<T>(std::forward<Functor>(f), location))
    {} +/
/+ #else
    template <typename Functor>
    explicit QProperty(Functor &&f);
#endif +/
    /+ ~QProperty() = default; +/

    parameter_type value() const
    {
        d.registerWithCurrentlyEvaluatingBinding();
        return this.val;
    }

    /+arrow_operator_result operator ->() const
    {
        static if (/+ QTypeTraits:: +/qt.core.typeinfo.is_dereferenceable_v!(T)) {
            return value();
        } else static if (/+ std:: +/is_pointer_v!(T)) {
            value();
            return this.val;
        } else {
            return;
        }
    }+/

    parameter_type opUnary(string op)() const if(op == "*")
    {
        return value();
    }

    /+auto opCast(T : parameter_type)() const
    {
        return value();
    }+/

    void setValue(rvalue_ref newValue)
    {
        d.removeBinding();
        if (is_equal(newValue))
            return;
        this.val = /+ std:: +/move(newValue);
        notify();
    }

    void setValue(parameter_type newValue)
    {
        d.removeBinding();
        if (is_equal(newValue))
            return;
        this.val = newValue;
        notify();
    }

    /+ref QProperty!(T) operator =(rvalue_ref newValue)
    {
        setValue(/+ std:: +/move(newValue));
        return this;
    }+/

    /+ref QProperty!(T) operator =(parameter_type newValue)
    {
        setValue(newValue);
        return this;
    }+/

    QPropertyBinding!(T) setBinding(ref const(QPropertyBinding!(T)) newBinding)
    {
        return QPropertyBinding!(T)(d.setBinding(newBinding, &this));
    }

/+    bool setBinding(ref const(QUntypedPropertyBinding) newBinding)
    {
        if (!newBinding.isNull() && newBinding.valueMetaType().id() != qMetaTypeId!(T)())
            return false;
        setBinding(static_cast!(ref const(QPropertyBinding!(T)))(newBinding));
        return true;
    }+/

/+ #ifndef Q_CLANG_QDOC +/
    /+ template <typename Functor> +/
    /+ QPropertyBinding<T> setBinding(Functor &&f,
                                   const QPropertyBindingSourceLocation &location = QT_PROPERTY_DEFAULT_BINDING_LOCATION,
                                   std::enable_if_t<std::is_invocable_v<Functor>> * = nullptr)
    {
        return setBinding(Qt::makePropertyBinding(std::forward<Functor>(f), location));
    } +/
/+ #else
    template <typename Functor>
    QPropertyBinding<T> setBinding(Functor f);
#endif +/

    bool hasBinding() const { return d.hasBinding(); }

    QPropertyBinding!(T) binding() const
    {
        return QPropertyBinding!(T)(QUntypedPropertyBinding(d.binding()));
    }

    QPropertyBinding!(T) takeBinding()
    {
        return QPropertyBinding!(T)(d.setBinding(QUntypedPropertyBinding(), &this));
    }

    /+ template<typename Functor> +/
    QPropertyChangeHandler!(Functor) onValueChanged(Functor)(Functor f)
    {
        static assert(/+ std:: +/is_invocable_v!(Functor), "Functor callback must be callable without any parameters");
        return QPropertyChangeHandler!(Functor)(this, f);
    }

    /+ template<typename Functor> +/
    QPropertyChangeHandler!(Functor) subscribe(Functor)(Functor f)
    {
        static assert(/+ std:: +/is_invocable_v!(Functor), "Functor callback must be callable without any parameters");
        f();
        return onValueChanged(f);
    }

    /+ template<typename Functor> +/
    QPropertyNotifier addNotifier(Functor)(Functor f)
    {
        static assert(/+ std:: +/is_invocable_v!(Functor), "Functor callback must be callable without any parameters");
        return QPropertyNotifier(this, f);
    }

    ref const(/+ QtPrivate:: +/qt.core.propertyprivate.QPropertyBindingData) bindingData() const { return d; }
private:
    void notify()
    {
        d.notifyObservers(&this);
    }

    /+ Q_DISABLE_COPY_MOVE(QProperty) +/
@disable this(this);
/+this(ref const(QProperty));+//+ref QProperty operator =(ref const(QProperty));+/}

extern(C++, "Qt") {
/+    QPropertyBinding!(PropertyType) makePropertyBinding(PropertyType)(ref const(QProperty!(PropertyType)) otherProperty,
                                                           ref const(QPropertyBindingSourceLocation) location /+ =
                                                           QT_PROPERTY_DEFAULT_BINDING_LOCATION +/)
    {
        return makePropertyBinding([&otherProperty]() -> PropertyType { return otherProperty; }, location);
    }+/
}


extern(C++, "QtPrivate")
{


struct QBindableInterface
{
    alias Getter = ExternCPPFunc!(void function(const(QUntypedPropertyData)* d, void* value));
    alias Setter = ExternCPPFunc!(void function(QUntypedPropertyData* d, const(void)* value));
    alias BindingGetter = ExternCPPFunc!(QUntypedPropertyBinding function(const(QUntypedPropertyData)* d));
    alias BindingSetter = ExternCPPFunc!(QUntypedPropertyBinding function(QUntypedPropertyData* d, ref const(QUntypedPropertyBinding) binding));
    alias MakeBinding = ExternCPPFunc!(QUntypedPropertyBinding function(const(QUntypedPropertyData)* d, ref const(QPropertyBindingSourceLocation) location));
    alias SetObserver = ExternCPPFunc!(void function(const(QUntypedPropertyData)* d, QPropertyObserver* observer));
    alias GetMetaType = ExternCPPFunc!(QMetaType function());
    Getter getter;
    Setter setter;
    BindingGetter getBinding;
    BindingSetter setBinding;
    MakeBinding makeBinding;
    SetObserver setObserver;
    GetMetaType metaType;

    extern(D) static immutable quintptr MetaTypeAccessorFlag = 0x1;
}

extern(C++, class) struct QBindableInterfaceForProperty(Property, )
{
private:
    alias T = UnknownType!q{Property.value_type};
public:
    // interface for computed properties. Those do not have a binding()/setBinding() method, but one can
    // install observers on them.
/+    extern(D) static immutable QBindableInterface iface = {
        [](const QUntypedPropertyData *d, void *value) -> void
        { *static_cast!(T*)(value) = static_cast!(const(Property)*)(d).value(); },
        null,
        null,
        null,
        [](const QUntypedPropertyData *d, const QPropertyBindingSourceLocation &location) -> QUntypedPropertyBinding
        { return /+ Qt:: +/makePropertyBinding([d]() -> T { return static_cast!(const(Property)*)(d).value(); }, location); },
        [](const QUntypedPropertyData *d, QPropertyObserver *observer) -> void
        { observer.setSource(static_cast!(const(Property)*)(d).bindingData()); },
        []() { return QMetaType.fromType!(T)(); }}
    ;+/
}

/+ template<typename Property>
class QBindableInterfaceForProperty<const Property, std::void_t<decltype(std::declval<Property>().binding())>>
{
    using T = typename Property::value_type;
public:
    // A bindable created from a const property results in a read-only interface, too.
    static constexpr QBindableInterface iface = {

        [](const QUntypedPropertyData *d, void *value) -> void
        { *static_cast<T*>(value) = static_cast<const Property *>(d)->value(); },
        /*setter=*/nullptr,
        [](const QUntypedPropertyData *d) -> QUntypedPropertyBinding
        { return static_cast<const Property *>(d)->binding(); },
        /*setBinding=*/nullptr,
        [](const QUntypedPropertyData *d, const QPropertyBindingSourceLocation &location) -> QUntypedPropertyBinding
        { return Qt::makePropertyBinding([d]() -> T { return static_cast<const Property *>(d)->value(); }, location); },
        [](const QUntypedPropertyData *d, QPropertyObserver *observer) -> void
        { observer->setSource(static_cast<const Property *>(d)->bindingData()); },
        []() { return QMetaType::fromType<T>(); }
    };
};

template<typename Property>
class QBindableInterfaceForProperty<Property, std::void_t<decltype(std::declval<Property>().binding())>>
{
    using T = typename Property::value_type;
public:
    static constexpr QBindableInterface iface = {
        [](const QUntypedPropertyData *d, void *value) -> void
        { *static_cast<T*>(value) = static_cast<const Property *>(d)->value(); },
        [](QUntypedPropertyData *d, const void *value) -> void
        { static_cast<Property *>(d)->setValue(*static_cast<const T*>(value)); },
        [](const QUntypedPropertyData *d) -> QUntypedPropertyBinding
        { return static_cast<const Property *>(d)->binding(); },
        [](QUntypedPropertyData *d, const QUntypedPropertyBinding &binding) -> QUntypedPropertyBinding
        { return static_cast<Property *>(d)->setBinding(static_cast<const QPropertyBinding<T> &>(binding)); },
        [](const QUntypedPropertyData *d, const QPropertyBindingSourceLocation &location) -> QUntypedPropertyBinding
        { return Qt::makePropertyBinding([d]() -> T { return static_cast<const Property *>(d)->value(); }, location); },
        [](const QUntypedPropertyData *d, QPropertyObserver *observer) -> void
        { observer->setSource(static_cast<const Property *>(d)->bindingData()); },
        []() { return QMetaType::fromType<T>(); }
    };
}; +/

}

extern(C++, "QtPrivate") {
// used in Q(Untyped)Bindable to print warnings about various binding errors
extern(C++, "BindableWarnings") {
enum Reason { InvalidInterface, NonBindableInterface, ReadOnlyInterface }
/+ Q_CORE_EXPORT +/ void printUnsuitableBindableWarning(QAnyStringView prefix, Reason reason);
/+ Q_CORE_EXPORT +/ void printMetaTypeMismatch(QMetaType actual, QMetaType expected);
}
}

/// Binding for C++ class [QUntypedBindable](https://doc.qt.io/qt-6/quntypedbindable.html).
extern(C++, class) struct QUntypedBindable
{
private:
    /+ friend struct QUntypedBindablePrivate; +/ // allows access to internal data
protected:
    QUntypedPropertyData* data = null;
    const(/+ QtPrivate:: +/QBindableInterface)* iface = null;
    this(QUntypedPropertyData* d, const(/+ QtPrivate:: +/QBindableInterface)* i)
    {
        this.data = d;
        this.iface = i;
    }

public:
    /+ constexpr QUntypedBindable() = default; +/
    /+ template<typename Property> +/
    this(Property)(Property* p)
    {
        this.data = const_cast!(/+ std:: +/remove_cv_t!(Property)*)(p);
        this.iface = &/+ QtPrivate:: +/QBindableInterfaceForProperty!(Property).iface;
        (mixin(Q_ASSERT(q{QUntypedBindable.data && QUntypedBindable.iface})));
    }

    bool isValid() const { return data !is null; }
    bool isBindable() const { return iface && iface.getBinding; }
    bool isReadOnly() const { return !(iface && iface.setBinding && iface.setObserver); }

    QUntypedPropertyBinding makeBinding(ref const(QPropertyBindingSourceLocation) location /+ = QT_PROPERTY_DEFAULT_BINDING_LOCATION +/) const
    {
        return iface ? iface.makeBinding(data, location) : QUntypedPropertyBinding.create();
    }

    QUntypedPropertyBinding takeBinding()
    {
        if (!iface)
            return QUntypedPropertyBinding.create();
        // We do not have a dedicated takeBinding function pointer in the interface
        // therefore we synthesize takeBinding by retrieving the binding with binding
        // and calling setBinding with a default constructed QUntypedPropertyBinding
        // afterwards.
        if (!(iface.getBinding && iface.setBinding))
            return QUntypedPropertyBinding.create();
        QUntypedPropertyBinding binding = iface.getBinding(data);
        QUntypedPropertyBinding tmp = QUntypedPropertyBinding.create();
        iface.setBinding(data, tmp);
        return binding;
    }

    void observe(QPropertyObserver* observer) const
    {
        if (iface)
            iface.setObserver(data, observer);
/+ #ifndef QT_NO_DEBUG
        else
            QtPrivate::BindableWarnings::printUnsuitableBindableWarning("observe:",
                                                                        QtPrivate::BindableWarnings::InvalidInterface);
#endif +/
    }

    /+ template<typename Functor> +/
    /+ QPropertyChangeHandler!(Functor) onValueChanged(Functor)(Functor f) const
    {
        auto handler = QPropertyChangeHandler!(Functor)(f);
        observe(&handler);
        return handler;
    } +/

    /+ template<typename Functor> +/
    /+ QPropertyChangeHandler!(Functor) subscribe(Functor)(Functor f) const
    {
        f();
        return onValueChanged(f);
    } +/

    /+ template<typename Functor> +/
    QPropertyNotifier addNotifier(Functor)(Functor f)
    {
        auto handler = QPropertyNotifier(f);
        observe(&handler);
        return handler;
    }

    QUntypedPropertyBinding binding() const
    {
        if (!isBindable()) {
/+ #ifndef QT_NO_DEBUG
            QtPrivate::BindableWarnings::printUnsuitableBindableWarning("binding: ",
                                                                        QtPrivate::BindableWarnings::NonBindableInterface);
#endif +/
            return QUntypedPropertyBinding.create();
        }
        return iface.getBinding(data);
    }
    bool setBinding(ref const(QUntypedPropertyBinding) binding)
    {
        if (isReadOnly()) {
/+ #ifndef QT_NO_DEBUG
            const auto errorType = iface ? QtPrivate::BindableWarnings::ReadOnlyInterface :
                                           QtPrivate::BindableWarnings::InvalidInterface;
            QtPrivate::BindableWarnings::printUnsuitableBindableWarning("setBinding: Could not set binding via bindable interface.", errorType);
#endif +/
            return false;
        }
        if (!binding.isNull() && binding.valueMetaType() != metaType()) {
/+ #ifndef QT_NO_DEBUG
            QtPrivate::BindableWarnings::printMetaTypeMismatch(metaType(), binding.valueMetaType());
#endif +/
            return false;
        }
        iface.setBinding(data, binding);
        return true;
    }
    bool hasBinding() const
    {
        return !binding().isNull();
    }

    QMetaType metaType() const
    {
        if (!(iface && data))
            return QMetaType();
        if (iface.metaType)
            return iface.metaType();
        // ### Qt 7: Change the metatype function to take data as its argument
        // special casing for QML's proxy bindable: allow multiplexing in the getter
        // function to retrieve the metatype from data
        (mixin(Q_ASSERT(q{QUntypedBindable.iface.getter})));
        QMetaType result;
        iface.getter(data, reinterpret_cast!(void*)(cast(quintptr)(&result) | /+ QtPrivate:: +/QBindableInterface.MetaTypeAccessorFlag));
        return result;
    }

    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QBindable](https://doc.qt.io/qt-6/qbindable.html).
extern(C++, class) struct QBindable(T)
{
    public QUntypedBindable base0;
    alias base0 this;
private:
    /+ template<typename U> +/
    /+ friend class QPropertyAlias; +/
    this(QUntypedPropertyData* d, const(/+ QtPrivate:: +/QBindableInterface)* i)
    {
        this.base0 = QUntypedBindable(d, i);
    }
public:
    /+ using QUntypedBindable::QUntypedBindable; +/
    /*/+ explicit +/this(ref const(QUntypedBindable) b)
    {
        this.base0 = QUntypedBindable(b);

        if (iface && metaType() != QMetaType.fromType!(T)()) {
            data = null;
            iface = null;
        }
    }*/

/+    QPropertyBinding!(T) makeBinding(ref const(QPropertyBindingSourceLocation) location /+ = QT_PROPERTY_DEFAULT_BINDING_LOCATION +/) const
    {
        return static_cast!(QPropertyBinding!(T) && /+ && +/)(QUntypedBindable.makeBinding(location));
    }
    QPropertyBinding!(T) binding() const
    {
        return static_cast!(QPropertyBinding!(T) && /+ && +/)(QUntypedBindable.binding());
    }

    QPropertyBinding!(T) takeBinding()
    {
        return static_cast!(QPropertyBinding!(T) && /+ && +/)(QUntypedBindable.takeBinding());
    }

    /+ using QUntypedBindable::setBinding; +/
    QPropertyBinding!(T) setBinding(ref const(QPropertyBinding!(T)) binding)
    {
        (mixin(Q_ASSERT(q{!QUntypedBindable.iface || binding.isNull() || binding.valueMetaType() == QUntypedBindable.metaType()})));

        if (iface && iface.setBinding)
            return static_cast!(QPropertyBinding!(T) && /+ && +/)(iface.setBinding(data, binding));
/+ #ifndef QT_NO_DEBUG
        if (!iface)
            QtPrivate::BindableWarnings::printUnsuitableBindableWarning("setBinding", QtPrivate::BindableWarnings::InvalidInterface);
        else
            QtPrivate::BindableWarnings::printUnsuitableBindableWarning("setBinding: Could not set binding via bindable interface.", QtPrivate::BindableWarnings::ReadOnlyInterface);
#endif +/
        return QPropertyBinding!(T)();
    }+/
/+ #ifndef Q_CLANG_QDOC +/
    /+ template <typename Functor> +/
    /+ QPropertyBinding<T> setBinding(Functor &&f,
                                   const QPropertyBindingSourceLocation &location = QT_PROPERTY_DEFAULT_BINDING_LOCATION,
                                   std::enable_if_t<std::is_invocable_v<Functor>> * = nullptr)
    {
        return setBinding(Qt::makePropertyBinding(std::forward<Functor>(f), location));
    } +/
/+ #else
    template <typename Functor>
    QPropertyBinding<T> setBinding(Functor f);
#endif +/

    T value() const
    {
        if (iface) {
            T result;
            iface.getter(data, &result);
            return result;
        }
        return T.init;
    }

    void setValue(ref const(T) value)
    {
        if (iface && iface.setter)
            iface.setter(data, &value);
    }
}

extern(C++, class) struct QPropertyAlias(T)
{
    public QPropertyObserver base0;
    alias base0 this;
private:
    /+ Q_DISABLE_COPY_MOVE(QPropertyAlias) +/
@disable this(this);
/+this(ref const(QPropertyAlias));+//+ref QPropertyAlias operator =(ref const(QPropertyAlias));+/    const(/+ QtPrivate:: +/QBindableInterface)* iface = null;

public:
/+    this(QProperty!(T)* property)
    {
        this.base0 = QPropertyObserver(property);
        this.iface = &/+ QtPrivate:: +/QBindableInterfaceForProperty!(QProperty!(T)).iface;

        if (iface)
            iface.setObserver(aliasedProperty(), &this);
    }+/

    /+ template<typename Property, typename = typename Property::InheritsQUntypedPropertyData> +/
    this(Property,)(Property* property)
    {
        this.base0 = QPropertyObserver(property);
        this.iface = &/+ QtPrivate:: +/QBindableInterfaceForProperty!(Property).iface;

        if (iface)
            iface.setObserver(aliasedProperty(), &this);
    }

    this(QPropertyAlias!(T)* alias_)
    {
        this.base0 = QPropertyObserver(alias_.aliasedProperty());
        this.iface = alias_.iface;

        if (iface)
            iface.setObserver(aliasedProperty(), &this);
    }

    this(ref const(QBindable!(T)) property)
    {
        this.base0 = QPropertyObserver(property.data);
        this.iface = property.iface;

        if (iface)
            iface.setObserver(aliasedProperty(), &this);
    }

    /+T value() const
    {
        T t = T();
        if (auto* p = aliasedProperty())
            iface.getter(p, &t);
        return t;
    }+/

    /+auto opCast(T : T)() const { return value(); }+/

    /+void setValue(ref const(T) newValue)
    {
        if (auto* p = aliasedProperty())
            iface.setter(p, &newValue);
    }+/

    /+ref QPropertyAlias!(T) operator =(ref const(T) newValue)
    {
        setValue(newValue);
        return this;
    }+/

    /+QPropertyBinding!(T) setBinding(ref const(QPropertyBinding!(T)) newBinding)
    {
        return QBindable!(T)(aliasedProperty(), iface).setBinding(cast(Functor && )(newBinding));
    }+/

    bool setBinding(ref const(QUntypedPropertyBinding) newBinding)
    {
        return cast(bool)(QBindable!(T)(aliasedProperty(), iface).setBinding(newBinding));
    }

/+ #ifndef Q_CLANG_QDOC +/
    /+ template <typename Functor> +/
    /+ QPropertyBinding<T> setBinding(Functor &&f,
                                   const QPropertyBindingSourceLocation &location = QT_PROPERTY_DEFAULT_BINDING_LOCATION,
                                   std::enable_if_t<std::is_invocable_v<Functor>> * = nullptr)
    {
        return setBinding(Qt::makePropertyBinding(std::forward<Functor>(f), location));
    } +/
/+ #else
    template <typename Functor>
    QPropertyBinding<T> setBinding(Functor f);
#endif +/

    bool hasBinding() const
    {
        return QBindable!(T)(aliasedProperty(), iface).hasBinding();
    }

    QPropertyBinding!(T) binding() const
    {
        return QBindable!(T)(aliasedProperty(), iface).binding();
    }

    QPropertyBinding!(T) takeBinding()
    {
        return QBindable!(T)(aliasedProperty(), iface).takeBinding();
    }

    /+ template<typename Functor> +/
    QPropertyChangeHandler!(Functor) onValueChanged(Functor)(Functor f)
    {
        return QBindable!(T)(aliasedProperty(), iface).onValueChanged(f);
    }

    /+ template<typename Functor> +/
    QPropertyChangeHandler!(Functor) subscribe(Functor)(Functor f)
    {
        return QBindable!(T)(aliasedProperty(), iface).subscribe(f);
    }

    /+ template<typename Functor> +/
    QPropertyNotifier addNotifier(Functor)(Functor f)
    {
        return QBindable!(T)(aliasedProperty(), iface).notify(f);
    }

    bool isValid() const
    {
        return aliasedProperty() !is null;
    }
}

/+
/// Binding for C++ class [QObjectBindableProperty](https://doc.qt.io/qt-6/qobjectbindableproperty.html).
extern(C++, class) struct QObjectBindableProperty(Class, T, auto Offset, auto Signal=null)
{
    public QPropertyData!(T) base0;
    alias base0 this;
private:
    alias ThisType = QObjectBindableProperty!(Class, T, Offset, Signal);
    extern(D) static immutable bool HasSignal = !/+ std:: +/is_same_v!(/+ decltype(Signal) +/auto, /+ std:: +/nullptr_t);
    alias SignalTakesValue = /+ std:: +/is_invocable!(/+ decltype(Signal) +/auto, Class, T);
    Class* owner()
    {
        char* that = reinterpret_cast!(char*)(&this);
        return reinterpret_cast!(Class*)(that - /+ QtPrivate:: +//+ detail:: +/qt.core.propertyprivate.getOffset(Offset));
    }
    const(Class)* owner() const
    {
        char* that = const_cast!(char*)(reinterpret_cast!(const(char)*)(&this));
        return reinterpret_cast!(Class*)(that - /+ QtPrivate:: +//+ detail:: +/qt.core.propertyprivate.getOffset(Offset));
    }
    static void signalCallBack(QUntypedPropertyData* o)
    {
        QObjectBindableProperty* that = static_cast!(QObjectBindableProperty*)(o);
        static if (HasSignal) {
            static if (SignalTakesValue.value)
                (that.owner()->*Signal)(that.valueBypassingBindings());
            else
                (that.owner()->*Signal)();
        }
    }
public:
    alias value_type = QPropertyData!(T).value_type;
    alias parameter_type = QPropertyData!(T).parameter_type;
    /+ using rvalue_ref = typename QPropertyData<T>::rvalue_ref; +/
    alias arrow_operator_result = QPropertyData!(T).arrow_operator_result;

    /+ QObjectBindableProperty() = default; +/
    /+ explicit +/this(ref const(T) initialValue)
    {
        this.QPropertyData!(T) = initialValue;
    }
    /+ explicit QObjectBindableProperty(T &&initialValue) : QPropertyData<T>(std::move(initialValue)) {} +/
    /+ explicit +/this(ref const(QPropertyBinding!(T)) binding)
    {
        this();
        setBinding(binding);
    }
/+ #ifndef Q_CLANG_QDOC +/
    /+ template <typename Functor> +/
    /+ explicit QObjectBindableProperty(Functor &&f, const QPropertyBindingSourceLocation &location = QT_PROPERTY_DEFAULT_BINDING_LOCATION,
                       typename std::enable_if_t<std::is_invocable_r_v<T, Functor&>> * = nullptr)
        : QObjectBindableProperty(QPropertyBinding<T>(std::forward<Functor>(f), location))
    {} +/
/+ #else
    template <typename Functor>
    explicit QObjectBindableProperty(Functor &&f);
#endif +/

    parameter_type value() const
    {
        import qt.core.object;

        qGetBindingStorage(owner()).registerDependency(&this);
        return this.val;
    }

    /+arrow_operator_result operator ->() const
    {
        static if (/+ QTypeTraits:: +/qt.core.typeinfo.is_dereferenceable_v!(T)) {
            return value();
        } else static if (/+ std:: +/is_pointer_v!(T)) {
            value();
            return this.val;
        } else {
            return;
        }
    }+/

    parameter_type opUnary(string op)() const if(op == "*")
    {
        return value();
    }

    /+auto opCast(T : parameter_type)() const
    {
        return value();
    }+/

    void setValue(parameter_type t)
    {
        import qt.core.object;

        auto* bd = cast(auto*)(qGetBindingStorage(owner()).bindingData(&this));
        if (bd)
            bd.removeBinding();
        if (this.val == t)
            return;
        this.val = t;
        notify(cast(const(qt.core.propertyprivate.QPropertyBindingData)*)(bd));
    }

    void notify() {
        import qt.core.object;

        auto* bd = cast(auto*)(qGetBindingStorage(owner()).bindingData(&this));
        notify(cast(const(qt.core.propertyprivate.QPropertyBindingData)*)(bd));
    }

    void setValue(rvalue_ref t)
    {
        import qt.core.object;

        auto* bd = cast(auto*)(qGetBindingStorage(owner()).bindingData(&this));
        if (bd)
            bd.removeBinding();
        if (this.val == t)
            return;
        this.val = /+ std:: +/move(t);
        notify(cast(const(qt.core.propertyprivate.QPropertyBindingData)*)(bd));
    }

    /+ref QObjectBindableProperty operator =(rvalue_ref newValue)
    {
        setValue(/+ std:: +/move(newValue));
        return this;
    }+/

    /+ref QObjectBindableProperty operator =(parameter_type newValue)
    {
        setValue(newValue);
        return this;
    }+/

    QPropertyBinding!(T) setBinding(ref const(QPropertyBinding!(T)) newBinding)
    {
        import qt.core.object;

        /+ QtPrivate:: +/qt.core.propertyprivate.QPropertyBindingData* bd = qGetBindingStorage(owner()).bindingData(&this, true);
        auto oldBinding = QUntypedPropertyBinding(bd.setBinding(newBinding, &this, HasSignal ? &signalCallBack : null));
        return static_cast!(ref QPropertyBinding!(T))(oldBinding);
    }

    bool setBinding(ref const(QUntypedPropertyBinding) newBinding)
    {
        if (!newBinding.isNull() && newBinding.valueMetaType().id() != qMetaTypeId!(T)())
            return false;
        setBinding(static_cast!(ref const(QPropertyBinding!(T)))(newBinding));
        return true;
    }

/+ #ifndef Q_CLANG_QDOC +/
    /+ template <typename Functor> +/
    /+ QPropertyBinding<T> setBinding(Functor &&f,
                                   const QPropertyBindingSourceLocation &location = QT_PROPERTY_DEFAULT_BINDING_LOCATION,
                                   std::enable_if_t<std::is_invocable_v<Functor>> * = nullptr)
    {
        return setBinding(Qt::makePropertyBinding(std::forward<Functor>(f), location));
    } +/
/+ #else
    template <typename Functor>
    QPropertyBinding<T> setBinding(Functor f);
#endif +/

    bool hasBinding() const
    {
        import qt.core.object;

        auto* bd = cast(auto*)(qGetBindingStorage(owner()).bindingData(&this));
        return bd && bd.binding() !is null;
    }

    QPropertyBinding!(T) binding() const
    {
        import qt.core.object;

        auto* bd = cast(auto*)(qGetBindingStorage(owner()).bindingData(&this));
        return static_cast!(QPropertyBinding!(T) && /+ && +/)(QUntypedPropertyBinding(bd ? bd.binding() : null));
    }

    QPropertyBinding!(T) takeBinding()
    {
        return setBinding(cast(Functor && )(QPropertyBinding!(T)()));
    }

    /+ template<typename Functor> +/
    QPropertyChangeHandler!(Functor) onValueChanged(Functor)(Functor f)
    {
        static assert(/+ std:: +/is_invocable_v!(Functor), "Functor callback must be callable without any parameters");
        return QPropertyChangeHandler!(Functor)(this, f);
    }

    /+ template<typename Functor> +/
    QPropertyChangeHandler!(Functor) subscribe(Functor)(Functor f)
    {
        static assert(/+ std:: +/is_invocable_v!(Functor), "Functor callback must be callable without any parameters");
        f();
        return onValueChanged(f);
    }

    /+ template<typename Functor> +/
    QPropertyNotifier addNotifier(Functor)(Functor f)
    {
        static assert(/+ std:: +/is_invocable_v!(Functor), "Functor callback must be callable without any parameters");
        return QPropertyNotifier(this, f);
    }

    ref const(/+ QtPrivate:: +/qt.core.propertyprivate.QPropertyBindingData) bindingData() const
    {
        import qt.core.bindingstorage;
        import qt.core.object;

        auto* storage = const_cast!(QBindingStorage*)(qGetBindingStorage(owner()));
        return *storage.bindingData(const_cast!(ThisType*)(&this), true);
    }
private:
    void notify(const(/+ QtPrivate:: +/qt.core.propertyprivate.QPropertyBindingData)* binding)
    {
        import qt.core.object;

        if (binding)
            binding.notifyObservers(&this, qGetBindingStorage(owner()));
        static if (HasSignal) {
            static if (SignalTakesValue.value)
                (owner()->*Signal)(this.valueBypassingBindings());
            else
                (owner()->*Signal)();
        }
    }
}+/

/+ #define QT_OBJECT_BINDABLE_PROPERTY_3(Class, Type, name) \
    static constexpr size_t _qt_property_##name##_offset() { \
        QT_WARNING_PUSH QT_WARNING_DISABLE_INVALID_OFFSETOF \
        return offsetof(Class, name); \
        QT_WARNING_POP \
    } \
    QObjectBindableProperty<Class, Type, Class::_qt_property_##name##_offset, nullptr> name;

#define QT_OBJECT_BINDABLE_PROPERTY_4(Class, Type, name, Signal) \
    static constexpr size_t _qt_property_##name##_offset() { \
        QT_WARNING_PUSH QT_WARNING_DISABLE_INVALID_OFFSETOF \
        return offsetof(Class, name); \
        QT_WARNING_POP \
    } \
    QObjectBindableProperty<Class, Type, Class::_qt_property_##name##_offset, Signal> name;

#define Q_OBJECT_BINDABLE_PROPERTY(...) \
    QT_WARNING_PUSH QT_WARNING_DISABLE_INVALID_OFFSETOF \
    QT_OVERLOADED_MACRO(QT_OBJECT_BINDABLE_PROPERTY, __VA_ARGS__) \
    QT_WARNING_POP

#define QT_OBJECT_BINDABLE_PROPERTY_WITH_ARGS_4(Class, Type, name, value)                          \
    static constexpr size_t _qt_property_##name##_offset()                                         \
    {                                                                                              \
        QT_WARNING_PUSH QT_WARNING_DISABLE_INVALID_OFFSETOF                                        \
        return offsetof(Class, name);                                                              \
        QT_WARNING_POP                                                                             \
    }                                                                                              \
    QObjectBindableProperty<Class, Type, Class::_qt_property_##name##_offset, nullptr> name =      \
            QObjectBindableProperty<Class, Type, Class::_qt_property_##name##_offset, nullptr>(    \
                    value);

#define QT_OBJECT_BINDABLE_PROPERTY_WITH_ARGS_5(Class, Type, name, value, Signal)                  \
    static constexpr size_t _qt_property_##name##_offset()                                         \
    {                                                                                              \
        QT_WARNING_PUSH QT_WARNING_DISABLE_INVALID_OFFSETOF                                        \
        return offsetof(Class, name);                                                              \
        QT_WARNING_POP                                                                             \
    }                                                                                              \
    QObjectBindableProperty<Class, Type, Class::_qt_property_##name##_offset, Signal> name =       \
            QObjectBindableProperty<Class, Type, Class::_qt_property_##name##_offset, Signal>(     \
                    value);

#define Q_OBJECT_BINDABLE_PROPERTY_WITH_ARGS(...)                                                  \
    QT_WARNING_PUSH QT_WARNING_DISABLE_INVALID_OFFSETOF \
    QT_OVERLOADED_MACRO(QT_OBJECT_BINDABLE_PROPERTY_WITH_ARGS, __VA_ARGS__) \
    QT_WARNING_POP +/

/// Binding for C++ class [QObjectComputedProperty](https://doc.qt.io/qt-6/qobjectcomputedproperty.html).
/+extern(C++, class) struct QObjectComputedProperty(Class, T, auto Offset, auto Getter)
{
    public QUntypedPropertyData base0;
    alias base0 this;
private:
    Class* owner()
    {
        char* that = reinterpret_cast!(char*)(&this);
        return reinterpret_cast!(Class*)(that - /+ QtPrivate:: +//+ detail:: +/qt.core.propertyprivate.getOffset(Offset));
    }
    const(Class)* owner() const
    {
        char* that = const_cast!(char*)(reinterpret_cast!(const(char)*)(&this));
        return reinterpret_cast!(Class*)(that - /+ QtPrivate:: +//+ detail:: +/qt.core.propertyprivate.getOffset(Offset));
    }

public:
    alias value_type = T;
    alias parameter_type = T;

    /+ QObjectComputedProperty() = default; +/

    parameter_type value() const
    {
        import qt.core.object;

        qGetBindingStorage(owner()).registerDependency(&this);
        return (owner()->*Getter)();
    }

    /+ std::conditional_t<QTypeTraits::is_dereferenceable_v<T>, parameter_type, void>
    operator->() const
    {
        static if (QTypeTraits::is_dereferenceable_v<T>)
            return value();
        else
            return;
    } +/

    parameter_type opUnary(string op)() const if(op == "*")
    {
        return value();
    }

    /+auto opCast(T : parameter_type)() const
    {
        return value();
    }+/

    bool hasBinding() const { return false; }

    /+ template<typename Functor> +/
    QPropertyChangeHandler!(Functor) onValueChanged(Functor)(Functor f)
    {
        static assert(/+ std:: +/is_invocable_v!(Functor), "Functor callback must be callable without any parameters");
        return QPropertyChangeHandler!(Functor)(this, f);
    }

    /+ template<typename Functor> +/
    QPropertyChangeHandler!(Functor) subscribe(Functor)(Functor f)
    {
        static assert(/+ std:: +/is_invocable_v!(Functor), "Functor callback must be callable without any parameters");
        f();
        return onValueChanged(f);
    }

    /+ template<typename Functor> +/
    QPropertyNotifier addNotifier(Functor)(Functor f)
    {
        static assert(/+ std:: +/is_invocable_v!(Functor), "Functor callback must be callable without any parameters");
        return QPropertyNotifier(this, f);
    }

    ref /+ QtPrivate:: +/qt.core.propertyprivate.QPropertyBindingData bindingData() const
    {
        import qt.core.bindingstorage;
        import qt.core.object;

        auto* storage = const_cast!(QBindingStorage*)(qGetBindingStorage(owner()));
        return *storage.bindingData(const_cast!(QObjectComputedProperty*)(&this), true);
    }

    void notify() {
        import qt.core.bindingstorage;
        import qt.core.object;

        // computed property can't store a binding, so there's nothing to mark
        auto* storage = const_cast!(QBindingStorage*)(qGetBindingStorage(owner()));
        auto bd = storage.bindingData(const_cast!(QObjectComputedProperty*)(&this), false);
        if (bd)
            bd.notifyObservers(&this, qGetBindingStorage(owner()));
    }
}+/

/+ #define Q_OBJECT_COMPUTED_PROPERTY(Class, Type, name,  ...) \
    static constexpr size_t _qt_property_##name##_offset() { \
        QT_WARNING_PUSH QT_WARNING_DISABLE_INVALID_OFFSETOF \
        return offsetof(Class, name); \
        QT_WARNING_POP \
    } \
    QObjectComputedProperty<Class, Type, Class::_qt_property_##name##_offset, __VA_ARGS__> name;

#undef QT_SOURCE_LOCATION_NAMESPACE +/


