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
module qt.core.arraydata;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.global;
import qt.core.refcount;
import qt.helpers;

struct /+ Q_CORE_EXPORT +/ QArrayData
{
    /+ QtPrivate:: +/qt.core.refcount.RefCount ref_;
    int size;
    /+ uint alloc : 31; +/
    uint bitfieldData_alloc;
    uint alloc() const
    {
        return (bitfieldData_alloc >> 0) & 0x7fffffff;
    }
    uint alloc(uint value)
    {
        bitfieldData_alloc = (bitfieldData_alloc & ~0x7fffffff) | ((value & 0x7fffffff) << 0);
        return value;
    }
    /+ uint capacityReserved : 1; +/
    uint capacityReserved() const
    {
        return (bitfieldData_alloc >> 31) & 0x1;
    }
    uint capacityReserved(uint value)
    {
        bitfieldData_alloc = (bitfieldData_alloc & ~0x80000000) | ((value & 0x1) << 31);
        return value;
    }

    qptrdiff offset; // in bytes from beginning of header

    void* data()
    {
        (mixin(Q_ASSERT(q{QArrayData.size == 0
                    || QArrayData.offset < 0 || size_t(QArrayData.offset) >= QArrayData.sizeof})));
        return reinterpret_cast!(char*)(&this) + offset;
    }

    const(void)* data() const
    {
        (mixin(Q_ASSERT(q{QArrayData.size == 0
                    || QArrayData.offset < 0 || size_t(QArrayData.offset) >= QArrayData.sizeof})));
        return reinterpret_cast!(const(char)*)(&this) + offset;
    }

    // This refers to array data mutability, not "header data" represented by
    // data members in QArrayData. Shared data (array and header) must still
    // follow COW principles.
    bool isMutable() const
    {
        return alloc != 0;
    }

    mixin("enum AllocationOption {"
        ~ q{
            CapacityReserved    = 0x1,
        }
        ~ (!versionIsSet!("QT_NO_UNSHARABLE_CONTAINERS") ? q{
    /+ #if !defined(QT_NO_UNSHARABLE_CONTAINERS) +/
            Unsharable          = 0x2,
        }:"")
        ~ q{
    /+ #endif +/
            RawData             = 0x4,
            Grow                = 0x8,

            Default = 0
        }
        ~ "}"
    );

    /+ Q_DECLARE_FLAGS(AllocationOptions, AllocationOption) +/
alias AllocationOptions = QFlags!(AllocationOption);
    size_t detachCapacity(size_t newSize) const
    {
        if (capacityReserved && newSize < alloc)
            return alloc;
        return newSize;
    }

    AllocationOptions detachFlags() const
    {
        AllocationOptions result;
        if (capacityReserved)
            result |= AllocationOption.CapacityReserved;
        return result;
    }

    AllocationOptions cloneFlags() const
    {
        AllocationOptions result;
        if (capacityReserved)
            result |= AllocationOption.CapacityReserved;
        return result;
    }

    /+ Q_REQUIRED_RESULT +/ static QArrayData* allocate(size_t objectSize, size_t alignment,
                size_t capacity, AllocationOptions options = AllocationOptions.Default)/+ noexcept+/;
    /+ Q_REQUIRED_RESULT +/ static QArrayData* reallocateUnaligned(QArrayData* data, size_t objectSize,
                size_t newCapacity, AllocationOptions newOptions = AllocationOption.Default)/+ noexcept+/;
    static void deallocate(QArrayData* data, size_t objectSize,
                size_t alignment)/+ noexcept+/;

    mixin(mangleWindows("?shared_null@QArrayData@@2QBU1@B", exportOnWindows ~ q{
    extern static __gshared const(const(QArrayData)[2]) shared_null;
    }));
    static QArrayData* sharedNull()/+ noexcept+/ { return const_cast!(QArrayData*)(shared_null.ptr); }
}
/+pragma(inline, true) QFlags!(QArrayData.AllocationOptions.enum_type) operator |(QArrayData.AllocationOptions.enum_type f1, QArrayData.AllocationOptions.enum_type f2)/+noexcept+/{return QFlags!(QArrayData.AllocationOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QArrayData.AllocationOptions.enum_type) operator |(QArrayData.AllocationOptions.enum_type f1, QFlags!(QArrayData.AllocationOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QArrayData.AllocationOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QArrayData::AllocationOptions) +/
struct QTypedArrayData(T)

{
    QArrayData base0;
    alias base0 this;
    alias AllocationOption = QArrayData.AllocationOption;
    alias AllocationOptions = QArrayData.AllocationOptions;

/+ #ifdef QT_STRICT_ITERATORS
    class iterator {
    public:
        T *i;
        typedef std::random_access_iterator_tag  iterator_category;
        typedef int difference_type;
        typedef T value_type;
        typedef T *pointer;
        typedef T &reference;

        inline iterator() : i(nullptr) {}
        inline iterator(T *n) : i(n) {}
        inline iterator(const iterator &o): i(o.i){} // #### Qt 6: remove, the implicit version is fine
        inline T &operator*() const { return *i; }
        inline T *operator->() const { return i; }
        inline T &operator[](int j) const { return *(i + j); }
        inline bool operator==(const iterator &o) const { return i == o.i; }
        inline bool operator!=(const iterator &o) const { return i != o.i; }
        inline bool operator<(const iterator& other) const { return i < other.i; }
        inline bool operator<=(const iterator& other) const { return i <= other.i; }
        inline bool operator>(const iterator& other) const { return i > other.i; }
        inline bool operator>=(const iterator& other) const { return i >= other.i; }
        inline iterator &operator++() { ++i; return *this; }
        inline iterator operator++(int) { T *n = i; ++i; return n; }
        inline iterator &operator--() { i--; return *this; }
        inline iterator operator--(int) { T *n = i; i--; return n; }
        inline iterator &operator+=(int j) { i+=j; return *this; }
        inline iterator &operator-=(int j) { i-=j; return *this; }
        inline iterator operator+(int j) const { return iterator(i+j); }
        inline iterator operator-(int j) const { return iterator(i-j); }
        friend inline iterator operator+(int j, iterator k) { return k + j; }
        inline int operator-(iterator j) const { return i - j.i; }
        inline operator T*() const { return i; }
    };
    friend class iterator;

    class const_iterator {
    public:
        const T *i;
        typedef std::random_access_iterator_tag  iterator_category;
        typedef int difference_type;
        typedef T value_type;
        typedef const T *pointer;
        typedef const T &reference;

        inline const_iterator() : i(nullptr) {}
        inline const_iterator(const T *n) : i(n) {}
        inline const_iterator(const const_iterator &o): i(o.i) {} // #### Qt 6: remove, the default version is fine
        inline explicit const_iterator(const iterator &o): i(o.i) {}
        inline const T &operator*() const { return *i; }
        inline const T *operator->() const { return i; }
        inline const T &operator[](int j) const { return *(i + j); }
        inline bool operator==(const const_iterator &o) const { return i == o.i; }
        inline bool operator!=(const const_iterator &o) const { return i != o.i; }
        inline bool operator<(const const_iterator& other) const { return i < other.i; }
        inline bool operator<=(const const_iterator& other) const { return i <= other.i; }
        inline bool operator>(const const_iterator& other) const { return i > other.i; }
        inline bool operator>=(const const_iterator& other) const { return i >= other.i; }
        inline const_iterator &operator++() { ++i; return *this; }
        inline const_iterator operator++(int) { const T *n = i; ++i; return n; }
        inline const_iterator &operator--() { i--; return *this; }
        inline const_iterator operator--(int) { const T *n = i; i--; return n; }
        inline const_iterator &operator+=(int j) { i+=j; return *this; }
        inline const_iterator &operator-=(int j) { i-=j; return *this; }
        inline const_iterator operator+(int j) const { return const_iterator(i+j); }
        inline const_iterator operator-(int j) const { return const_iterator(i-j); }
        friend inline const_iterator operator+(int j, const_iterator k) { return k + j; }
        inline int operator-(const_iterator j) const { return i - j.i; }
        inline operator const T*() const { return i; }
    };
    friend class const_iterator;
#else +/
    alias iterator = T*;
    alias const_iterator = const(T)*;
/+ #endif +/

    T* data() { return static_cast!(T*)(base0.data()); }
    const(T)* data() const { return static_cast!(const(T)*)(base0.data()); }

    iterator begin(/+iterator  = iterator() +/) { return data(); }
    iterator end(/+iterator  = iterator() +/) { return data() + size; }
    const_iterator begin(/+const_iterator  = const_iterator() +/) const { return data(); }
    const_iterator end(/+const_iterator  = const_iterator() +/) const { return data() + size; }
    const_iterator constBegin(/+const_iterator  = const_iterator() +/) const { return data(); }
    const_iterator constEnd(/+ const_iterator = const_iterator() +/) const { return data() + size; }

    extern(C++, class) struct AlignmentDummy {
    private:
 QArrayData header; T data; }

    /+ Q_REQUIRED_RESULT +/ static QTypedArrayData* allocate(size_t capacity,
                AllocationOptions options = AllocationOptions.Default)
    {
        mixin(Q_STATIC_ASSERT(q{QTypedArrayData.sizeof == QArrayData.sizeof}));
        return static_cast!(QTypedArrayData*)(QArrayData.allocate(T.sizeof,
                    /+ Q_ALIGNOF +/AlignmentDummy.alignof, capacity, options));
    }

    static QTypedArrayData* reallocateUnaligned(QTypedArrayData* data, size_t capacity,
                AllocationOptions options = AllocationOptions.Default)
    {
        mixin(Q_STATIC_ASSERT(q{QTypedArrayData.sizeof == QArrayData.sizeof}));
        return static_cast!(QTypedArrayData*)(QArrayData.reallocateUnaligned(&data.base0, T.sizeof,
                    capacity, options));
    }

    static void deallocate(QArrayData* data)
    {
        mixin(Q_STATIC_ASSERT(q{QTypedArrayData.sizeof == QArrayData.sizeof}));
        QArrayData.deallocate(data, T.sizeof, /+ Q_ALIGNOF +/AlignmentDummy.alignof);
    }

    static void deallocate(QTypedArrayData * data)
    {
        deallocate(&data.base0);
    }

    static QTypedArrayData* fromRawData(const(T)* data, size_t n,
                AllocationOptions options = AllocationOption.Default)
    {
        mixin(Q_STATIC_ASSERT(q{QTypedArrayData.sizeof == QArrayData.sizeof}));
        QTypedArrayData* result = allocate(0, options | AllocationOption.RawData);
        if (result) {
            (mixin(Q_ASSERT(q{!result.ref_.isShared()}))); // No shared empty, please!

            result.offset = reinterpret_cast!(const(char)*)(data)
                - reinterpret_cast!(const(char)*)(result);
            result.size = cast(int) (n);
        }
        return result;
    }

    static QTypedArrayData* sharedNull()/+ noexcept+/
    {
        mixin(Q_STATIC_ASSERT(q{QTypedArrayData.sizeof == QArrayData.sizeof}));
        return static_cast!(QTypedArrayData*)(QArrayData.sharedNull());
    }

    static QTypedArrayData* sharedEmpty()
    {
        mixin(Q_STATIC_ASSERT(q{QTypedArrayData.sizeof == QArrayData.sizeof}));
        return allocate(/* capacity */ 0);
    }

    version (QT_NO_UNSHARABLE_CONTAINERS) {} else
    {
        static QTypedArrayData* unsharableEmpty()
        {
            mixin(Q_STATIC_ASSERT(q{QTypedArrayData.sizeof == QArrayData.sizeof}));
            return allocate(/* capacity */ 0, AllocationOptions.Unsharable);
        }
    }
}

struct QStaticArrayData(T, size_t N)
{
    QArrayData header;
    T[N] data;
}

// Support for returning QArrayDataPointer<T> from functions
struct QArrayDataPointerRef(T)
{
    QTypedArrayData!(T)* ptr;
}

/+ #define Q_STATIC_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(size, offset) \
    { Q_REFCOUNT_INITIALIZE_STATIC, size, 0, 0, offset } \
    /**/

#define Q_STATIC_ARRAY_DATA_HEADER_INITIALIZER(type, size) \
    Q_STATIC_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(size,\
        ((sizeof(QArrayData) + (Q_ALIGNOF(type) - 1)) & ~(Q_ALIGNOF(type) - 1) )) \
    /**/

////////////////////////////////////////////////////////////////////////////////
//  Q_ARRAY_LITERAL

// The idea here is to place a (read-only) copy of header and array data in an
// mmappable portion of the executable (typically, .rodata section). This is
// accomplished by hiding a static const instance of QStaticArrayData, which is
// POD.

// Hide array inside a lambda
#define Q_ARRAY_LITERAL(Type, ...)                                              \
    ([]() -> QArrayDataPointerRef<Type> {                                       \
            /* MSVC 2010 Doesn't support static variables in a lambda, but */   \
            /* happily accepts them in a static function of a lambda-local */   \
            /* struct :-) */                                                    \
            struct StaticWrapper {                                              \
                static QArrayDataPointerRef<Type> get()                         \
                {                                                               \
                    Q_ARRAY_LITERAL_IMPL(Type, __VA_ARGS__)                     \
                    return ref;                                                 \
                }                                                               \
            };                                                                  \
            return StaticWrapper::get();                                        \
        }())                                                                    \
    /**/

#ifdef Q_COMPILER_CONSTEXPR
#define Q_ARRAY_LITERAL_CHECK_LITERAL_TYPE(Type) Q_STATIC_ASSERT(std::is_literal_type<Type>::value)
#else
#define Q_ARRAY_LITERAL_CHECK_LITERAL_TYPE(Type) do {} while (0)
#endif

#define Q_ARRAY_LITERAL_IMPL(Type, ...)                                         \
    Q_ARRAY_LITERAL_CHECK_LITERAL_TYPE(Type);                                   \
                                                                                \
    /* Portable compile-time array size computation */                          \
    Q_CONSTEXPR Type data[] = { __VA_ARGS__ }; Q_UNUSED(data);                  \
    enum { Size = sizeof(data) / sizeof(data[0]) };                             \
                                                                                \
    static const QStaticArrayData<Type, Size> literal = {                       \
        Q_STATIC_ARRAY_DATA_HEADER_INITIALIZER(Type, Size), { __VA_ARGS__ } };  \
                                                                                \
    QArrayDataPointerRef<Type> ref =                                            \
        { static_cast<QTypedArrayData<Type> *>(                                 \
            const_cast<QArrayData *>(&literal.header)) };                       \
    /**/ +/

extern(C++, "QtPrivate") {
struct /+ Q_CORE_EXPORT +/ QContainerImplHelper
{
    enum CutResult { Null, Empty, Full, Subset }
    static CutResult mid(int originalLength, int* position, int* length);
}
}

