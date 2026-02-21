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
module qt.core.bytearrayview;
extern(C++):

import core.stdc.config;
import qt.config;
import qt.core.bytearray;
import qt.core.global;
import qt.core.namespace;
import qt.core.string;
import qt.core.typeinfo;
import qt.helpers;

extern(C++, "QtPrivate") {

struct IsCompatibleByteTypeHelper(Byte)
 {
    /+ std:: +/integral_constant!(bool,
                                 /+ std:: +/is_same_v!(Byte, char) ||
                                 /+ std:: +/is_same_v!(Byte, uchar) ||
                                 /+ std:: +/is_same_v!(Byte, byte) ||
                                 /+ std:: +/is_same_v!(Byte, /+ std:: +/byte_)) base0;
    alias base0 this;
}

struct IsCompatibleByteType(Byte)
 {
    IsCompatibleByteTypeHelper!(
                  /+ std:: +/remove_cv_t!(/+ std:: +/remove_reference_t!(Byte))) base0;
    alias base0 this;
}

struct IsCompatibleByteArrayPointerHelper(Pointer) {
    /+ std:: +/false_type base0;
    alias base0 this;
}
/+ template <typename Byte>
struct IsCompatibleByteArrayPointerHelper<Byte *>
    : IsCompatibleByteType<Byte> {}; +/
struct IsCompatibleByteArrayPointer(Pointer)
 {
    IsCompatibleByteArrayPointerHelper!(
                  /+ std:: +/remove_cv_t!(/+ std:: +/remove_reference_t!(Pointer))) base0;
    alias base0 this;
}

struct IsContainerCompatibleWithQByteArrayView(T, Enable) {
    /+ std:: +/false_type base0;
    alias base0 this;
}

/+ template <typename T>
struct IsContainerCompatibleWithQByteArrayView<T, std::enable_if_t<
        std::conjunction_v<
                // lacking concepts and ranges, we accept any T whose std::data yields a suitable
                // pointer ...
                IsCompatibleByteArrayPointer<decltype(std::data(std::declval<const T &>()))>,
                // ... and that has a suitable size ...
                std::is_convertible<decltype(std::size(std::declval<const T &>())), qsizetype>,
                // ... and it's a range as it defines an iterator-like API
                IsCompatibleByteType<typename std::iterator_traits<decltype(
                        std::begin(std::declval<const T &>()))>::value_type>,
                std::is_convertible<decltype(std::begin(std::declval<const T &>())
                                             != std::end(std::declval<const T &>())),
                                    bool>,

                // This needs to be treated specially due to the empty vs null distinction
                std::negation<std::is_same<std::decay_t<T>, QByteArray>>,

                // We handle array literals specially for source compat reasons
                std::negation<std::is_array<T>>,

                // Don't make an accidental copy constructor
                std::negation<std::is_same<std::decay_t<T>, QByteArrayView>>>>> : std::true_type {};

// Used by QLatin1StringView too
template <typename Char>
static constexpr qsizetype lengthHelperPointer(const Char *data) noexcept
{
    return qsizetype(std::char_traits<Char>::length(data));
} +/

} // namespace QtPrivate

/// Binding for C++ class [QByteArrayView](https://doc.qt.io/qt-6/qbytearrayview.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QByteArrayView
{
public:
    alias storage_type = char;
    alias value_type = const(char);
    alias difference_type = qptrdiff;
    alias size_type = qsizetype;
    /+ typedef value_type &reference; +/
    /+ typedef value_type &const_reference; +/
    alias pointer = value_type*;
    alias const_pointer = value_type*;

    alias iterator = pointer;
    alias const_iterator = const_pointer;
    /+ typedef std::reverse_iterator<iterator> reverse_iterator; +/
    /+ typedef std::reverse_iterator<const_iterator> const_reverse_iterator; +/

private:
    /+ template <typename Byte> +/
    alias if_compatible_byte(Byte) =
                /+ std:: +/enable_if_t!(/+ QtPrivate:: +/IsCompatibleByteType!(Byte).value, bool);

    /+ template <typename Pointer> +/
    /+ using if_compatible_pointer =
            typename std::enable_if_t<QtPrivate::IsCompatibleByteArrayPointer<Pointer>::value,
                                      bool>; +/

    /+ template <typename T> +/
    /+ using if_compatible_qbytearray_like =
            typename std::enable_if_t<std::is_same_v<T, QByteArray>, bool>; +/

    /+ template <typename T> +/
    /+ using if_compatible_container =
            typename std::enable_if_t<QtPrivate::IsContainerCompatibleWithQByteArrayView<T>::value,
                                      bool>; +/

    /+ template <typename Container> +/
    static qsizetype lengthHelperContainer(Container)(ref const(Container) c) nothrow
    {
        return qsizetype(/+ std:: +/size(c));
    }

    /+static qsizetype lengthHelperCharArray(const(char)* data, size_t size) nothrow
    {
        const it = /+ std:: +/char_traits!(char).find(cast(const(char_traits.char_type)*) (data), size, '\0');
        const end = it ? it : /+ std:: +/next(data, size);
        return qsizetype(/+ std:: +/distance(data, end));
    }+/

    /+ template <typename Byte> +/
    static const(storage_type)* castHelper(Byte)(const(Byte)* data) nothrow
    { return reinterpret_cast!(const(storage_type)*)(data); }
    static const(storage_type)* castHelper(const(storage_type)* data) nothrow
    { return data; }

public:
    //@disable this();
    /+this() nothrow
    {
        this.m_size = 0;
        this.m_data = null;
    }+/
    this(typeof(null)) nothrow
    {
        //this();
    }

    /+ template <typename Byte, if_compatible_byte<Byte> = true> +/
    this(Byte,)(const(Byte)* data, qsizetype len)
    {
        this.m_size = ((){(){ (mixin(Q_ASSERT(q{len >= 0})));
        return /+ Q_ASSERT(data || !len) +/ mixin(Q_ASSERT(q{data || !len}));
        }();
        return len;
        }());
        this.m_data = castHelper(data);
    }

    /+ template <typename Byte, if_compatible_byte<Byte> = true> +/
    this(Byte,)(const(Byte)* first, const(Byte)* last)
    {
        this(first, last - first);
    }

/+ #ifdef Q_QDOC
    template <typename Byte>
    constexpr QByteArrayView(const Byte *data) noexcept;
#else +/
    /+ template <typename Pointer, if_compatible_pointer<Pointer> = true> +/
    this(Pointer)(ref const(Pointer) data) nothrow if (is(Pointer: const(char)*))
    {
        import core.stdc.string: strlen;
        this(
                      data, data ? strlen(data) : 0);
    }
/+ #endif

#ifdef Q_QDOC
    QByteArrayView(const QByteArray &data) noexcept;
#else +/
    /+ template <typename ByteArray, if_compatible_qbytearray_like<ByteArray> = true> +/
    this(ByteArray)(auto ref const(ByteArray) ba) nothrow if (is(ByteArray == QByteArray) || is(ByteArray == QLatin1String))
    {
        this(ba.isNull() ? null : ba.data(), qsizetype(ba.size()));
    }
/+ #endif +/

    /+ template <typename Container, if_compatible_container<Container> = true> +/
    /+this(Container,)(ref const(Container) c) nothrow
    {
        this(/+ std:: +/data(c), lengthHelperContainer(c));
    }+/
    /+ template <size_t Size> +/
    /+this(size_t Size)(ref const(char)[Size] data) nothrow
    {
        this(data, lengthHelperCharArray(data.ptr, Size));
    }+/

/+ #ifdef Q_QDOC
    template <typename Byte, size_t Size>
#else +/
    /+ template <typename Byte, size_t Size, if_compatible_byte<Byte> = true>
#endif +/
    /+ [[nodiscard]] +/ static QByteArrayView fromArray(Byte,size_t Size,)(ref const(Byte)[Size] data) nothrow
    { return QByteArrayView(data.ptr, Size); }
    //
    // QByteArrayView members that require QByteArray:
    //
    /+ [[nodiscard]] +/ pragma(inline, true) QByteArray toByteArray() const
    {
        return QByteArray(data(), size());
    } // defined in qbytearray.h

    /+ [[nodiscard]] +/ qsizetype size() const nothrow { return m_size; }
    /+ [[nodiscard]] +/ const_pointer data() const nothrow { return m_data; }
    /+ [[nodiscard]] +/ const_pointer constData() const nothrow { return data(); }

    /+ [[nodiscard]] +/ char opIndex(qsizetype n) const
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n < QByteArrayView.size()}))); return m_data[n]; }

    //
    // QByteArray API
    //
    /+ [[nodiscard]] +/ char at(qsizetype n) const { return (this)[n]; }

    /+ [[nodiscard]] +/ QByteArrayView first(qsizetype n) const
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QByteArrayView.size()}))); return QByteArrayView(data(), n); }
    /+ [[nodiscard]] +/ QByteArrayView last(qsizetype n) const
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QByteArrayView.size()}))); return QByteArrayView(data() + size() - n, n); }
    /+ [[nodiscard]] +/ QByteArrayView sliced(qsizetype pos) const
    { (mixin(Q_ASSERT(q{pos >= 0}))); (mixin(Q_ASSERT(q{pos <= QByteArrayView.size()}))); return QByteArrayView(data() + pos, size() - pos); }
    /+ [[nodiscard]] +/ QByteArrayView sliced(qsizetype pos, qsizetype n) const
    { (mixin(Q_ASSERT(q{pos >= 0}))); (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{size_t(pos) + size_t(n) <= size_t(QByteArrayView.size())}))); return QByteArrayView(data() + pos, n); }
    /+ [[nodiscard]] +/ QByteArrayView chopped(qsizetype len) const
    { (mixin(Q_ASSERT(q{len >= 0}))); (mixin(Q_ASSERT(q{len <= QByteArrayView.size()}))); return first(size() - len); }

    void truncate(qsizetype n)
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QByteArrayView.size()}))); m_size = n; }
    void chop(qsizetype n)
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QByteArrayView.size()}))); m_size -= n; }

    // Defined in qbytearray.cpp:
    /+ [[nodiscard]] +/ QByteArrayView trimmed() const nothrow
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.trimmed(this);
    }
    /+ [[nodiscard]] +/ short toShort(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(short)(this, ok, base);
    }
    /+ [[nodiscard]] +/ ushort toUShort(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(ushort)(this, ok, base);
    }
    /+ [[nodiscard]] +/ int toInt(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(int)(this, ok, base);
    }
    /+ [[nodiscard]] +/ uint toUInt(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(uint)(this, ok, base);
    }
    /+ [[nodiscard]] +/ cpp_long toLong(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(cpp_long)(this, ok, base);
    }
    /+ [[nodiscard]] +/ cpp_ulong toULong(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(cpp_ulong)(this, ok, base);
    }
    /+ [[nodiscard]] +/ qlonglong toLongLong(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(qlonglong)(this, ok, base);
    }
    /+ [[nodiscard]] +/ qulonglong toULongLong(bool* ok = null, int base = 10) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toIntegral!(qulonglong)(this, ok, base);
    }
    /+ [[nodiscard]] +/ float toFloat(bool* ok = null) const
    {
        import qt.core.bytearrayalgorithms;

        const r = /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toFloat(this);
        if (ok)
            *ok = cast(bool)(r);
        return r.value_or(0.0f);
    }
    /+ [[nodiscard]] +/ double toDouble(bool* ok = null) const
    {
        import qt.core.bytearrayalgorithms;

        const r = /+ QtPrivate:: +/qt.core.bytearrayalgorithms.toDouble(this);
        if (ok)
            *ok = cast(bool)(r);
        return r.value_or(0.0);
    }

    /+ [[nodiscard]] +/ bool startsWith(QByteArrayView other) const /*nothrow*/
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.startsWith(this, other);
    }
    /+ [[nodiscard]] +/ bool startsWith(char c) const /*nothrow*/
    { return !empty() && front() == c; }

    /+ [[nodiscard]] +/ bool endsWith(QByteArrayView other) const /*nothrow*/
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.endsWith(this, other);
    }
    /+ [[nodiscard]] +/ bool endsWith(char c) const /*nothrow*/
    { return !empty() && back() == c; }

    /+ [[nodiscard]] +/ qsizetype indexOf(QByteArrayView a, qsizetype from = 0) const /*nothrow*/
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.findByteArray(this, from, a);
    }
    /+ [[nodiscard]] +/ qsizetype indexOf(char ch, qsizetype from = 0) const /*nothrow*/
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.findByteArray(this, from, QByteArrayView(&ch, 1));
    }

    /+ [[nodiscard]] +/ bool contains(QByteArrayView a) const /*nothrow*/
    { return indexOf(a) != qsizetype(-1); }
    /+ [[nodiscard]] +/ bool contains(char c) const /*nothrow*/
    { return indexOf(c) != qsizetype(-1); }

    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QByteArrayView a) const /*nothrow*/
    { return lastIndexOf(a, size()); }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(QByteArrayView a, qsizetype from) const /*nothrow*/
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.lastIndexOf(this, from, a);
    }
    /+ [[nodiscard]] +/ qsizetype lastIndexOf(char ch, qsizetype from = -1) const /*nothrow*/
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.lastIndexOf(this, from, QByteArrayView(&ch, 1));
    }

    /+ [[nodiscard]] +/ qsizetype count(QByteArrayView a) const nothrow
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.count(this, a);
    }
    /+ [[nodiscard]] +/ qsizetype count(char ch) const nothrow
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.count(this, QByteArrayView(&ch, 1));
    }

    pragma(inline, true) int compare(QByteArrayView a, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const /*nothrow*/
    {
        import qt.core.bytearrayalgorithms;

        return cs == /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive ? /+ QtPrivate:: +/qt.core.bytearrayalgorithms.compareMemory(this, a) :
                                         qstrnicmp(data(), size(), a.data(), a.size());
    }

    /+ [[nodiscard]] +/ pragma(inline, true) bool isValidUtf8() const nothrow {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.isValidUtf8(this);
    }

    //
    // STL compatibility API:
    //
    /+ [[nodiscard]] +/ const_iterator begin()   const nothrow { return data(); }
    /+ [[nodiscard]] +/ const_iterator end()     const nothrow { return data() + size(); }
    /+ [[nodiscard]] +/ const_iterator cbegin()  const nothrow { return begin(); }
    /+ [[nodiscard]] +/ const_iterator cend()    const nothrow { return end(); }
    /+ [[nodiscard]] constexpr const_reverse_iterator rbegin()  const noexcept { return const_reverse_iterator(end()); } +/
    /+ [[nodiscard]] constexpr const_reverse_iterator rend()    const noexcept { return const_reverse_iterator(begin()); } +/
    /+ [[nodiscard]] constexpr const_reverse_iterator crbegin() const noexcept { return rbegin(); } +/
    /+ [[nodiscard]] constexpr const_reverse_iterator crend()   const noexcept { return rend(); } +/

    /+ [[nodiscard]] +/ bool empty() const nothrow { return size() == 0; }
    /+ [[nodiscard]] +/ char front() const { (mixin(Q_ASSERT(q{!QByteArrayView.empty()}))); return m_data[0]; }
    /+ [[nodiscard]] +/ char back()  const { (mixin(Q_ASSERT(q{!QByteArrayView.empty()}))); return m_data[m_size - 1]; }

    //
    // Qt compatibility API:
    //
    /+ [[nodiscard]] +/ bool isNull() const nothrow { return !m_data; }
    /+ [[nodiscard]] +/ bool isEmpty() const nothrow { return empty(); }
    /+ [[nodiscard]] +/ qsizetype length() const nothrow
    { return size(); }
    /+ [[nodiscard]] +/ char first() const { return front(); }
    /+ [[nodiscard]] +/ char last()  const { return back(); }

    /+ friend inline bool operator==(QByteArrayView lhs, QByteArrayView rhs) noexcept
    { return lhs.size() == rhs.size() && QtPrivate::compareMemory(lhs, rhs) == 0; } +/
    /+ friend inline bool operator!=(QByteArrayView lhs, QByteArrayView rhs) noexcept
    { return !(lhs == rhs); } +/
    /+ friend inline bool operator< (QByteArrayView lhs, QByteArrayView rhs) noexcept
    { return QtPrivate::compareMemory(lhs, rhs) <  0; } +/
    /+ friend inline bool operator<=(QByteArrayView lhs, QByteArrayView rhs) noexcept
    { return QtPrivate::compareMemory(lhs, rhs) <= 0; } +/
    /+ friend inline bool operator> (QByteArrayView lhs, QByteArrayView rhs) noexcept
    { return !(lhs <= rhs); } +/
    /+ friend inline bool operator>=(QByteArrayView lhs, QByteArrayView rhs) noexcept
    { return !(lhs < rhs); } +/

    bool opEquals(const QByteArrayView rhs) const
    {
        import qt.core.bytearrayalgorithms;
        return this.size() == rhs.size() && compareMemory(this, rhs) == 0;
    }
    int opCmp(const QByteArrayView rhs) const
    {
        import qt.core.bytearrayalgorithms;
        return compareMemory(this, rhs);
    }

private:
    qsizetype m_size = 0;
    const(storage_type)* m_data = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QByteArrayView, Q_PRIMITIVE_TYPE); +/

/+ [[nodiscard]] +/ pragma(inline, true) QByteArrayView qToByteArrayViewIgnoringNull(QByteArrayLike,
         /+ std::enable_if_t<std::is_same_v<QByteArrayLike, QByteArray>, bool> +/ /+ = true +/)(ref const(QByteArrayLike) b) nothrow
{ return QByteArrayView(b.data(), b.size()); }

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
/+ QT_DEPRECATED_VERSION_X_6_0("Use the QByteArrayView overload.") +/
pragma(inline, true) quint16 qChecksum(const(char)* s, qsizetype len,
                         /+ Qt:: +/qt.core.namespace.ChecksumType standard = /+ Qt:: +/qt.core.namespace.ChecksumType.ChecksumIso3309)
{
    import qt.core.bytearrayalgorithms;
    return qt.core.bytearrayalgorithms.qChecksum(QByteArrayView(s, len), standard);
}
/+ #endif +/

