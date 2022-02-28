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
module qt.core.nativeinterface;
extern(C++):

import qt.config;
import qt.helpers;

// We declare a virtual non-inline function in the form
// of the destructor, making it the key function. This
// ensures that the typeinfo of the class is exported.
// By being protected, we also ensure that pointers to
// the interface can't be deleted.
/+ #define QT_DECLARE_NATIVE_INTERFACE_3(NativeInterface, Revision, BaseType) \
    protected: \
        virtual ~NativeInterface(); \
        \
        struct TypeInfo { \
            using baseType = BaseType; \
            static constexpr char const *name = QT_STRINGIFY(NativeInterface); \
            static constexpr int revision = Revision; \
        }; \
        \
        template <typename, typename> \
        friend struct QNativeInterface::Private::has_type_info; \
        \
        template <typename> \
        friend bool constexpr QNativeInterface::Private::hasTypeInfo(); \
        \
        template <typename> \
        friend struct QNativeInterface::Private::TypeInfo; \
    public: \
        NativeInterface() = default; \
        Q_DISABLE_COPY_MOVE(NativeInterface)

// Revisioned interfaces only make sense when exposed through a base
// type via QT_DECLARE_NATIVE_INTERFACE_ACCESSOR, as the revision
// checks happen at that level (and not for normal dynamic_casts).
#define QT_DECLARE_NATIVE_INTERFACE_2(NativeInterface, Revision) \
    static_assert(false, "Must provide a base type when specifying revision");

#define QT_DECLARE_NATIVE_INTERFACE_1(NativeInterface) \
    QT_DECLARE_NATIVE_INTERFACE_3(NativeInterface, 0, void)

#define QT_DECLARE_NATIVE_INTERFACE(...) \
    QT_OVERLOADED_MACRO(QT_DECLARE_NATIVE_INTERFACE, __VA_ARGS__)

namespace QNativeInterface::Private { +/

    // Basic type-trait to verify that a given native interface has
    // all the required type information for us to evaluate it.
    struct has_type_info(NativeInterface, ) {
        /+ std:: +/false_type base0;
        alias base0 this;
}

    // The type-trait is friended by TypeInfo, so that we can
    // evaluate TypeInfo in the template arguments.
    /+ template <typename NativeInterface>
    struct has_type_info<NativeInterface, std::void_t<
        typename NativeInterface::TypeInfo,
        typename NativeInterface::TypeInfo::baseType,
        decltype(&NativeInterface::TypeInfo::name),
        decltype(&NativeInterface::TypeInfo::revision)
        >> : std::true_type {}; +/

    // We need to wrap the instantiation of has_type_info in a
    // function friended by TypeInfo, otherwise MSVC will not
    // let us evaluate TypeInfo in the template arguments.
    bool hasTypeInfo(NativeInterface)()
    {
        return has_type_info!(NativeInterface__1).value;
    }

    struct TypeInfo(NativeInterface)
    {
        // To ensure SFINAE works for hasTypeInfo we can't use it in a constexpr
        // variable that also includes an expression that relies on the type
        // info. This helper variable is okey, as it it self contained.
        extern(D) static immutable bool haveTypeInfo = hasTypeInfo!(NativeInterface__1)();

        // We can then use the helper variable in a constexpr condition in a
        // function, which does not break SFINAE if haveTypeInfo is false.
        /+ template <typename BaseType> +/
        /+ static constexpr bool isCompatibleHelper()
        {
            if constexpr (haveTypeInfo)
                return std::is_base_of<typename NativeInterface::TypeInfo::baseType, BaseType>::value;
            else
                return false;
        } +/

        // MSVC however doesn't like constexpr functions in enable_if_t conditions,
        // so we need to wrap it yet again in a constexpr variable. This is fine,
        // as all the SFINAE magic has been resolved at this point.
        /+ template <typename BaseType> +/
        /+ static constexpr bool isCompatibleWith = isCompatibleHelper<BaseType>(); +/

        // The revision and name accessors are not used in enable_if_t conditions,
        // so we can leave them as constexpr functions. As this class template is
        // friended by TypeInfo we can access the protected members of TypeInfo.
        static int revision()
        {
            static if (haveTypeInfo)
                return cast(int)(NativeInterface__1.TypeInfo.revision);
            else
                return 0;
        }

        static const(char)* name()
        {
            static if (haveTypeInfo)
                return cast(const(char)*)(&NativeInterface__1.TypeInfo.name);
            else
                return null;
        }
    }

    // Wrapper type to make the error message in case
    // of incompatible interface types read better.
    struct NativeInterface(I) {
        TypeInfo!(I) base0;
        alias base0 this;
}
/+ } // QNativeInterface::Private

// Declares an accessor for the native interface
#ifdef Q_QDOC
#define QT_DECLARE_NATIVE_INTERFACE_ACCESSOR(T) \
    template <typename QNativeInterface> \
    QNativeInterface *nativeInterface() const;
#else +/
/+ #define QT_DECLARE_NATIVE_INTERFACE_ACCESSOR(T) \
    template <typename NativeInterface, typename TypeInfo = QNativeInterface::Private::NativeInterface<NativeInterface>, \
    typename BaseType = T, std::enable_if_t<TypeInfo::template isCompatibleWith<T>, bool> = true> \
    NativeInterface *nativeInterface() const \
    { \
        return static_cast<NativeInterface*>(resolveInterface( \
            TypeInfo::name(), TypeInfo::revision())); \
    } \
    protected: \
        void *resolveInterface(const char *name, int revision) const; \
    public: +/
extern(D) alias QT_DECLARE_NATIVE_INTERFACE_ACCESSOR = function string(string T)
{
    return
            mixin(interpolateMixin(q{/+ template <typename NativeInterface, typename TypeInfo = QNativeInterface::Private::NativeInterface<NativeInterface>,
            typename BaseType = T, std::enable_if_t<TypeInfo::template isCompatibleWith<T>, bool> = true> +/
            /+ NativeInterface *nativeInterface() const
            {
                return static_cast<NativeInterface*>(resolveInterface(
                    TypeInfo::name(), TypeInfo::revision()));
            } +/
            protected:
                /+ void *resolveInterface(const char *name, int revision) const; +/
            public:}));
};
/+ #endif +/

