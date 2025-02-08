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
module qt.core.bytearray;
extern(C++):

import core.stdc.config;
import core.vararg;
import qt.config;
import qt.core.arraydata;
import qt.core.arraydatapointer;
import qt.core.bytearrayview;
import qt.core.flags;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.typeinfo;
import qt.helpers;

/+ #ifndef QT5_NULL_STRINGS
// Would ideally be off, but in practice breaks too much (Qt 6.0).
#define QT5_NULL_STRINGS 1
#endif

#ifdef truncate
#error qbytearray.h must be included before any header file that defines truncate
#endif

#if defined(Q_OS_DARWIN) || defined(Q_QDOC)
Q_FORWARD_DECLARE_CF_TYPE(CFData);
Q_FORWARD_DECLARE_OBJC_CLASS(NSData);
#endif +/



alias QByteArrayData = QArrayDataPointer!(char);

/+ #  define QByteArrayLiteral(str) \
    (QByteArray(QByteArrayData(nullptr, const_cast<char *>(str), sizeof(str) - 1))) \
    /**/ +/

/// Binding for C++ class [QByteArray](https://doc.qt.io/qt-6/qbytearray.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QByteArray
{
public:
    alias DataPointer = QByteArrayData;
private:
    alias Data = QTypedArrayData!(char);

    DataPointer d;
    mixin(mangleWindows("?_empty@QByteArray@@0DB", exportOnWindows ~ q{
    extern static __gshared const(char) _empty;
    }));
public:

    enum Base64Option {
        Base64Encoding = 0,
        Base64UrlEncoding = 1,

        KeepTrailingEquals = 0,
        OmitTrailingEquals = 2,

        IgnoreBase64DecodingErrors = 0,
        AbortOnBase64DecodingErrors = 4,
    }
    /+ Q_DECLARE_FLAGS(Base64Options, Base64Option) +/
alias Base64Options = QFlags!(Base64Option);
    enum /+ class +/ Base64DecodingStatus {
        Ok,
        IllegalInputLength,
        IllegalCharacter,
        IllegalPadding,
    }

    //pragma(inline, true) void this()/+ noexcept+/ {}
    static typeof(this) create()
    {
        return typeof(this).init;
    }

    this(const(char)* , qsizetype size = -1);
    this(qsizetype size, char c);
    this(qsizetype size, /+ Qt:: +/qt.core.namespace.Initialization);
    /+@disable this(this);
    pragma(inline, true) this(ref const(QByteArray) a)/+ noexcept+/
    {
        this.d = a.d;
    }+/
    pragma(inline, true) ~this() {}

    /+ref QByteArray operator =(ref const(QByteArray) )/+ noexcept+/;+/
    /+ref QByteArray operator =(const(char)* str);+/
    /+ inline QByteArray(QByteArray && other) noexcept
        = default; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QByteArray) +/
    /+ inline void swap(QByteArray &other) noexcept
    { d.swap(other.d); } +/

    bool isEmpty() const/+ noexcept+/ { return size() == 0; }
    void resize(qsizetype size);
    void resize(qsizetype size, char c);

    ref QByteArray fill(char c, qsizetype size = -1);

    pragma(inline, true) qsizetype capacity() const { return qsizetype(d.constAllocatedCapacity()); }
    pragma(inline, true) void reserve(qsizetype asize)
    {
        if (d.needsDetach() || asize > capacity() - d.freeSpaceAtBegin())
            reallocData(qMax(size(), asize), QArrayData.AllocationOption.KeepSize);
        if (d.constAllocatedCapacity())
            d.setFlag(Data.ArrayOptions.CapacityReserved);
    }
    pragma(inline, true) void squeeze()
    {
        if (!d.isMutable())
            return;
        if (d.needsDetach() || size() < capacity())
            reallocData(size(), QArrayData.AllocationOption.KeepSize);
        if (d.constAllocatedCapacity())
            d.clearFlag(Data.ArrayOptions.CapacityReserved);
    }

    version (QT_NO_CAST_FROM_BYTEARRAY) {} else
    {
        /+pragma(inline, true) auto opCast(T : const(char))() const;+/
        /+pragma(inline, true) auto opCast(T : const(void))() const;+/
    }
    pragma(inline, true) char* data()
    {
        detach();
        (mixin(Q_ASSERT(q{QByteArray.d.data()})));
        return d.data();
    }
    pragma(inline, true) const(char)* data() const/+ noexcept+/
    {
        static if ((configValue!"QT5_NULL_STRINGS" == 1 || !defined!"QT5_NULL_STRINGS"))
        {
            return d.data() ? d.data() : &_empty;
        }
        else
        {
            return d.data();
        }
    }
    const(char)* constData() const/+ noexcept+/ { return data(); }

    extern(D) const(ubyte)[] toConstUByteArray() const
    {
        return (cast(const(ubyte)*)constData())[0..length];
    }
    extern(D) const(char)[] toConstCharArray() const
    {
        return (cast(const(char)*)constData())[0..length];
    }

    pragma(inline, true) void detach()
    { if (d.needsDetach()) reallocData(size(), QArrayData.AllocationOption.KeepSize); }
    pragma(inline, true) bool isDetached() const
    { return !d.isShared(); }
    pragma(inline, true) bool isSharedWith(ref const(QByteArray) other) const/+ noexcept+/
    { return data() == other.data() && size() == other.size(); }
    void clear();

    pragma(inline, true) char at(qsizetype i) const
    { (mixin(Q_ASSERT(q{size_t(i) < size_t(QByteArray.size())}))); return d.data()[i]; }
    pragma(inline, true) char opIndex(qsizetype i) const
    { (mixin(Q_ASSERT(q{size_t(i) < size_t(QByteArray.size())}))); return d.data()[i]; }
    /+ [[nodiscard]] +/ pragma(inline, true) ref char opIndex(qsizetype i)
    { (mixin(Q_ASSERT(q{i >= 0 && i < QByteArray.size()}))); return data()[i]; }
    /+ [[nodiscard]] +/ char front() const { return at(0); }
    /+ [[nodiscard]] +/ pragma(inline, true) ref char front() { return opIndex(0); }
    /+ [[nodiscard]] +/ char back() const { return at(size() - 1); }
    /+ [[nodiscard]] +/ pragma(inline, true) ref char back() { return opIndex(size() - 1); }

    qsizetype indexOf(char c, qsizetype from = 0) const;
    qsizetype indexOf(QByteArrayView bv, qsizetype from = 0) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.findByteArray(qToByteArrayViewIgnoringNull(this), from, bv);
    }

    qsizetype lastIndexOf(char c, qsizetype from = -1) const;
    qsizetype lastIndexOf(QByteArrayView bv) const
    { return lastIndexOf(bv, size()); }
    qsizetype lastIndexOf(QByteArrayView bv, qsizetype from) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.lastIndexOf(qToByteArrayViewIgnoringNull(this), from, bv);
    }

    pragma(inline, true) bool contains(char c) const
    { return indexOf(c) != -1; }
    pragma(inline, true) bool contains(QByteArrayView bv) const
    { return indexOf(bv) != -1; }
    qsizetype count(char c) const;
    qsizetype count(QByteArrayView bv) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.count(qToByteArrayViewIgnoringNull(this), bv);
    }

    pragma(inline, true) int compare(QByteArrayView a, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.bytearrayalgorithms;

        return cs == /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive ? /+ QtPrivate:: +/qt.core.bytearrayalgorithms.compareMemory(QByteArrayView(this), a) :
                                         qstrnicmp(data(), size(), a.data(), a.size());
    }

    /+ [[nodiscard]] +/ QByteArray left(qsizetype len) const;
    /+ [[nodiscard]] +/ QByteArray right(qsizetype len) const;
    /+ [[nodiscard]] +/ QByteArray mid(qsizetype index, qsizetype len = -1) const;

    /+ [[nodiscard]] +/ QByteArray first(qsizetype n) const
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= size()}))); return QByteArray(data(), n); }
    /+ [[nodiscard]] +/ QByteArray last(qsizetype n) const
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= size()}))); return QByteArray(data() + size() - n, n); }
    /+ [[nodiscard]] +/ QByteArray sliced(qsizetype pos) const
    { (mixin(Q_ASSERT(q{pos >= 0}))); (mixin(Q_ASSERT(q{pos <= size()}))); return QByteArray(data() + pos, size() - pos); }
    /+ [[nodiscard]] +/ QByteArray sliced(qsizetype pos, qsizetype n) const
    { (mixin(Q_ASSERT(q{pos >= 0}))); (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{size_t(pos) + size_t(n) <= size_t(size())}))); return QByteArray(data() + pos, n); }
    /+ [[nodiscard]] +/ QByteArray chopped(qsizetype len) const
    { (mixin(Q_ASSERT(q{len >= 0}))); (mixin(Q_ASSERT(q{len <= size()}))); return first(size() - len); }

    bool startsWith(QByteArrayView bv) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.startsWith(qToByteArrayViewIgnoringNull(this), bv);
    }
    bool startsWith(char c) const { return size() > 0 && front() == c; }

    bool endsWith(char c) const { return size() > 0 && back() == c; }
    bool endsWith(QByteArrayView bv) const
    {
        import qt.core.bytearrayalgorithms;
        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.endsWith(qToByteArrayViewIgnoringNull(this), bv);
    }

    bool isUpper() const;
    bool isLower() const;

    /+ [[nodiscard]] +/ bool isValidUtf8() const/+ noexcept+/
    {
        import qt.core.bytearrayalgorithms;

        return /+ QtPrivate:: +/qt.core.bytearrayalgorithms.isValidUtf8(qToByteArrayViewIgnoringNull(this));
    }

    void truncate(qsizetype pos);
    void chop(qsizetype n);

/+ #if !defined(Q_CLANG_QDOC) +/
    /+ [[nodiscard]] +/ QByteArray toLower() const/+ &+/
    { return toLower_helper(this); }
    /+ [[nodiscard]] QByteArray toLower() &&
    { return toLower_helper(*this); } +/
    /+ [[nodiscard]] +/ QByteArray toUpper() const/+ &+/
    { return toUpper_helper(this); }
    /+ [[nodiscard]] QByteArray toUpper() &&
    { return toUpper_helper(*this); } +/
    /+ [[nodiscard]] +/ QByteArray trimmed() const/+ &+/
    { return trimmed_helper(this); }
    /+ [[nodiscard]] QByteArray trimmed() &&
    { return trimmed_helper(*this); } +/
    /+ [[nodiscard]] +/ QByteArray simplified() const/+ &+/
    { return simplified_helper(this); }
    /+ [[nodiscard]] QByteArray simplified() &&
    { return simplified_helper(*this); } +/
/+ #else
    [[nodiscard]] QByteArray toLower() const;
    [[nodiscard]] QByteArray toUpper() const;
    [[nodiscard]] QByteArray trimmed() const;
    [[nodiscard]] QByteArray simplified() const;
#endif +/

    /+ [[nodiscard]] +/ QByteArray leftJustified(qsizetype width, char fill = ' ', bool truncate = false) const;
    /+ [[nodiscard]] +/ QByteArray rightJustified(qsizetype width, char fill = ' ', bool truncate = false) const;

    ref QByteArray prepend(char c)
    { return insert(0, QByteArrayView(&c, 1)); }
    pragma(inline, true) ref QByteArray prepend(qsizetype n, char ch)
    { return insert(0, n, ch); }
    ref QByteArray prepend(const(char)* s)
    {
        import qt.core.bytearrayalgorithms;
        return insert(0, QByteArrayView(s, qsizetype(qstrlen(s))));
    }
    ref QByteArray prepend(const(char)* s, qsizetype len)
    { return insert(0, QByteArrayView(s, len)); }
    ref QByteArray prepend(ref const(QByteArray) a);
    ref QByteArray prepend(QByteArrayView a)
    { return insert(0, a); }

    ref QByteArray append(char c);
    pragma(inline, true) ref QByteArray append(qsizetype n, char ch)
    { return insert(size(), n, ch); }
    ref QByteArray append(const(char)* s)
    { return append(s, -1); }
    ref QByteArray append(const(char)* s, qsizetype len)
    {
        import qt.core.bytearrayalgorithms;
        return append(QByteArrayView(s, len < 0 ? qsizetype(qstrlen(s)) : len));
    }
    ref QByteArray append(ref const(QByteArray) a);
    ref QByteArray append(QByteArrayView a)
    { return insert(size(), a); }

    ref QByteArray insert(qsizetype i, QByteArrayView data);
    pragma(inline, true) ref QByteArray insert(qsizetype i, const(char)* s)
    { return insert(i, QByteArrayView(s)); }
    pragma(inline, true) ref QByteArray insert(qsizetype i, ref const(QByteArray) data)
    { return insert(i, QByteArrayView(data)); }
    ref QByteArray insert(qsizetype i, qsizetype count, char c);
    ref QByteArray insert(qsizetype i, char c)
    { return insert(i, QByteArrayView(&c, 1)); }
    ref QByteArray insert(qsizetype i, const(char)* s, qsizetype len)
    { return insert(i, QByteArrayView(s, len)); }

    ref QByteArray remove(qsizetype index, qsizetype len);
    /+ template <typename Predicate> +/
    ref QByteArray removeIf(Predicate)(Predicate pred)
    {
        import qt.core.containertools_impl;

        /+ QtPrivate:: +/qt.core.containertools_impl.sequential_erase_if(this, pred);
        return this;
    }

    ref QByteArray replace(qsizetype index, qsizetype len, const(char)* s, qsizetype alen)
    { return replace(index, len, QByteArrayView(s, alen)); }
    ref QByteArray replace(qsizetype index, qsizetype len, QByteArrayView s);
    ref QByteArray replace(char before, QByteArrayView after)
    { return replace(QByteArrayView(&before, 1), after); }
    ref QByteArray replace(const(char)* before, qsizetype bsize, const(char)* after, qsizetype asize)
    { return replace(QByteArrayView(before, bsize), QByteArrayView(after, asize)); }
    ref QByteArray replace(QByteArrayView before, QByteArrayView after);
    ref QByteArray replace(char before, char after);

    extern(D) ref QByteArray opOpAssign(string op)(char c) if (op == "~")
    { return append(c); }
    extern(D) ref QByteArray opOpAssign(string op)(const(char)* s) if (op == "~")
    { return append(s); }
    extern(D) ref QByteArray opOpAssign(string op)(ref const(QByteArray) a) if (op == "~")
    { return append(a); }
    extern(D) ref QByteArray opOpAssign(string op)(QByteArrayView a) if (op == "~")
    { return append(a); }

    QList!(QByteArray) split(char sep) const;

    /+ [[nodiscard]] +/ QByteArray repeated(qsizetype times) const;

/+ #if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
    QT_ASCII_CAST_WARN inline bool operator==(const QString &s2) const;
    QT_ASCII_CAST_WARN inline bool operator!=(const QString &s2) const;
    QT_ASCII_CAST_WARN inline bool operator<(const QString &s2) const;
    QT_ASCII_CAST_WARN inline bool operator>(const QString &s2) const;
    QT_ASCII_CAST_WARN inline bool operator<=(const QString &s2) const;
    QT_ASCII_CAST_WARN inline bool operator>=(const QString &s2) const;
#endif +/
    /+ friend inline bool operator==(const QByteArray &a1, const QByteArray &a2) noexcept
    { return QByteArrayView(a1) == QByteArrayView(a2); } +/
    /+ friend inline bool operator==(const QByteArray &a1, const char *a2) noexcept
    { return a2 ? QtPrivate::compareMemory(a1, a2) == 0 : a1.isEmpty(); } +/
    /+ friend inline bool operator==(const char *a1, const QByteArray &a2) noexcept
    { return a1 ? QtPrivate::compareMemory(a1, a2) == 0 : a2.isEmpty(); } +/
    /+ friend inline bool operator!=(const QByteArray &a1, const QByteArray &a2) noexcept
    { return !(a1==a2); } +/
    /+ friend inline bool operator!=(const QByteArray &a1, const char *a2) noexcept
    { return a2 ? QtPrivate::compareMemory(a1, a2) != 0 : !a1.isEmpty(); } +/
    /+ friend inline bool operator!=(const char *a1, const QByteArray &a2) noexcept
    { return a1 ? QtPrivate::compareMemory(a1, a2) != 0 : !a2.isEmpty(); } +/
    /+ friend inline bool operator<(const QByteArray &a1, const QByteArray &a2) noexcept
    { return QtPrivate::compareMemory(QByteArrayView(a1), QByteArrayView(a2)) < 0; } +/
    /+ friend inline bool operator<(const QByteArray &a1, const char *a2) noexcept
    { return QtPrivate::compareMemory(a1, a2) < 0; } +/
    /+ friend inline bool operator<(const char *a1, const QByteArray &a2) noexcept
    { return QtPrivate::compareMemory(a1, a2) < 0; } +/
    /+ friend inline bool operator<=(const QByteArray &a1, const QByteArray &a2) noexcept
    { return QtPrivate::compareMemory(QByteArrayView(a1), QByteArrayView(a2)) <= 0; } +/
    /+ friend inline bool operator<=(const QByteArray &a1, const char *a2) noexcept
    { return QtPrivate::compareMemory(a1, a2) <= 0; } +/
    /+ friend inline bool operator<=(const char *a1, const QByteArray &a2) noexcept
    { return QtPrivate::compareMemory(a1, a2) <= 0; } +/
    /+ friend inline bool operator>(const QByteArray &a1, const QByteArray &a2) noexcept
    { return QtPrivate::compareMemory(QByteArrayView(a1), QByteArrayView(a2)) > 0; } +/
    /+ friend inline bool operator>(const QByteArray &a1, const char *a2) noexcept
    { return QtPrivate::compareMemory(a1, a2) > 0; } +/
    /+ friend inline bool operator>(const char *a1, const QByteArray &a2) noexcept
    { return QtPrivate::compareMemory(a1, a2) > 0; } +/
    /+ friend inline bool operator>=(const QByteArray &a1, const QByteArray &a2) noexcept
    { return QtPrivate::compareMemory(QByteArrayView(a1), QByteArrayView(a2)) >= 0; } +/
    /+ friend inline bool operator>=(const QByteArray &a1, const char *a2) noexcept
    { return QtPrivate::compareMemory(a1, a2) >= 0; } +/
    /+ friend inline bool operator>=(const char *a1, const QByteArray &a2) noexcept
    { return QtPrivate::compareMemory(a1, a2) >= 0; } +/

    // Check isEmpty() instead of isNull() for backwards compatibility.
    /+ friend inline bool operator==(const QByteArray &a1, std::nullptr_t) noexcept { return a1.isEmpty(); } +/
    /+ friend inline bool operator!=(const QByteArray &a1, std::nullptr_t) noexcept { return !a1.isEmpty(); } +/
    /+ friend inline bool operator< (const QByteArray &  , std::nullptr_t) noexcept { return false; } +/
    /+ friend inline bool operator> (const QByteArray &a1, std::nullptr_t) noexcept { return !a1.isEmpty(); } +/
    /+ friend inline bool operator<=(const QByteArray &a1, std::nullptr_t) noexcept { return a1.isEmpty(); } +/
    /+ friend inline bool operator>=(const QByteArray &  , std::nullptr_t) noexcept { return true; } +/

    /+ friend inline bool operator==(std::nullptr_t, const QByteArray &a2) noexcept { return a2 == nullptr; } +/
    /+ friend inline bool operator!=(std::nullptr_t, const QByteArray &a2) noexcept { return a2 != nullptr; } +/
    /+ friend inline bool operator< (std::nullptr_t, const QByteArray &a2) noexcept { return a2 >  nullptr; } +/
    /+ friend inline bool operator> (std::nullptr_t, const QByteArray &a2) noexcept { return a2 <  nullptr; } +/
    /+ friend inline bool operator<=(std::nullptr_t, const QByteArray &a2) noexcept { return a2 >= nullptr; } +/
    /+ friend inline bool operator>=(std::nullptr_t, const QByteArray &a2) noexcept { return a2 <= nullptr; } +/

    short toShort(bool* ok = null, int base = 10) const;
    ushort toUShort(bool* ok = null, int base = 10) const;
    int toInt(bool* ok = null, int base = 10) const;
    uint toUInt(bool* ok = null, int base = 10) const;
    cpp_long toLong(bool* ok = null, int base = 10) const;
    cpp_ulong toULong(bool* ok = null, int base = 10) const;
    qlonglong toLongLong(bool* ok = null, int base = 10) const;
    qulonglong toULongLong(bool* ok = null, int base = 10) const;
    float toFloat(bool* ok = null) const;
    double toDouble(bool* ok = null) const;
    QByteArray toBase64(Base64Options options = Base64Option.Base64Encoding) const;
    QByteArray toHex(char separator = '\0') const;
    QByteArray toPercentEncoding(ref const(QByteArray) exclude/* = globalInitVar!QByteArray*/,
                                     ref const(QByteArray) include/* = globalInitVar!QByteArray*/,
                                     char percent/* = '%'*/) const;
    /+ [[nodiscard]] +/ QByteArray percentDecoded(char percent = '%') const;

    pragma(inline, true) ref QByteArray setNum(short n, int base = 10)
    { return setNum(qlonglong(n), base); }
    pragma(inline, true) ref QByteArray setNum(ushort n, int base = 10)
    { return setNum(qulonglong(n), base); }
    pragma(inline, true) ref QByteArray setNum(int n, int base = 10)
    { return setNum(qlonglong(n), base); }
    pragma(inline, true) ref QByteArray setNum(uint n, int base = 10)
    { return setNum(qulonglong(n), base); }
    pragma(inline, true) ref QByteArray setNum(cpp_long n, int base = 10)
    { return setNum(qlonglong(n), base); }
    pragma(inline, true) ref QByteArray setNum(cpp_ulong n, int base = 10)
    { return setNum(qulonglong(n), base); }
    ref QByteArray setNum(qlonglong, int base = 10);
    ref QByteArray setNum(qulonglong, int base = 10);
    pragma(inline, true) ref QByteArray setNum(float n, char format = 'g', int precision = 6)
    { return setNum(double(n), format, precision); }
    ref QByteArray setNum(double, char format = 'g', int precision = 6);
    ref QByteArray setRawData(const(char)* a, qsizetype n);

    /+ [[nodiscard]] +/ static QByteArray number(int, int base = 10);
    /+ [[nodiscard]] +/ static QByteArray number(uint, int base = 10);
    /+ [[nodiscard]] +/ static QByteArray number(cpp_long, int base = 10);
    /+ [[nodiscard]] +/ static QByteArray number(cpp_ulong, int base = 10);
    /+ [[nodiscard]] +/ static QByteArray number(qlonglong, int base = 10);
    /+ [[nodiscard]] +/ static QByteArray number(qulonglong, int base = 10);
    /+ [[nodiscard]] +/ static QByteArray number(double, char format = 'g', int precision = 6);
    /+ [[nodiscard]] +/ static QByteArray fromRawData(const(char)* data, qsizetype size)
    {
        auto tmp = DataPointer(null, const_cast!(char*)(data), size); return QByteArray(tmp);
    }

    /+
    extern(C++, class) struct FromBase64Result;
    +/
    /// Binding for C++ class [QByteArray::FromBase64Result](https://doc.qt.io/qt-6/qbytearray-frombase64result.html).
    extern(C++, class) struct FromBase64Result
    {
    public:
        QByteArray decoded;
        Base64DecodingStatus decodingStatus;

        /+ void swap(QByteArray::FromBase64Result &other) noexcept
        {
            decoded.swap(other.decoded);
            std::swap(decodingStatus, other.decodingStatus);
        } +/

        /+/+ explicit +/ auto opCast(T : bool)() const/+ noexcept+/ { return decodingStatus == QByteArray.Base64DecodingStatus.Ok; }+/

    /+ #if defined(Q_COMPILER_REF_QUALIFIERS) && !defined(Q_QDOC) +/
        ref QByteArray opUnary(string op)()/+ & noexcept+/ if (op == "*") { return decoded; }
        ref const(QByteArray) opUnary(string op)() const/+ & noexcept+/ if (op == "*") { return decoded; }
        /+ QByteArray &&operator*() && noexcept { return std::move(decoded); } +/
    /+ #else
        QByteArray &operator*() noexcept { return decoded; }
        const QByteArray &operator*() const noexcept { return decoded; }
    #endif +/

        /+ friend inline bool operator==(const QByteArray::FromBase64Result &lhs, const QByteArray::FromBase64Result &rhs) noexcept
        {
            if (lhs.decodingStatus != rhs.decodingStatus)
                return false;

            if (lhs.decodingStatus == QByteArray::Base64DecodingStatus::Ok && lhs.decoded != rhs.decoded)
                return false;

            return true;
        } +/

        /+ friend inline bool operator!=(const QByteArray::FromBase64Result &lhs, const QByteArray::FromBase64Result &rhs) noexcept
        {
            return !(lhs == rhs);
        } +/
        mixin(CREATE_CONVENIENCE_WRAPPERS);
    }

    /+ [[nodiscard]] static FromBase64Result fromBase64Encoding(QByteArray &&base64, Base64Options options = Base64Encoding); +/
    /+ [[nodiscard]] +/ static FromBase64Result fromBase64Encoding(ref const(QByteArray) base64, Base64Options options = Base64Option.Base64Encoding);
    /+ [[nodiscard]] +/ static QByteArray fromBase64(ref const(QByteArray) base64, Base64Options options = Base64Option.Base64Encoding);
    /+ [[nodiscard]] +/ static QByteArray fromHex(ref const(QByteArray) hexEncoded);
    /+ [[nodiscard]] +/ static QByteArray fromPercentEncoding(ref const(QByteArray) pctEncoded, char percent = '%');

    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ static QByteArray fromCFData(CFDataRef data); +/
        /+ static QByteArray fromRawCFData(CFDataRef data); +/
        /+ CFDataRef toCFData() const Q_DECL_CF_RETURNS_RETAINED; +/
        /+ CFDataRef toRawCFData() const Q_DECL_CF_RETURNS_RETAINED; +/
        /+ static QByteArray fromNSData(const NSData *data); +/
        /+ static QByteArray fromRawNSData(const NSData *data); +/
        /+ NSData *toNSData() const Q_DECL_NS_RETURNS_AUTORELEASED; +/
        /+ NSData *toRawNSData() const Q_DECL_NS_RETURNS_AUTORELEASED; +/
    }

    alias iterator = char*;
    alias const_iterator = const(char)*;
    alias Iterator = iterator;
    alias ConstIterator = const_iterator;
    /+ typedef std::reverse_iterator<iterator> reverse_iterator; +/
    /+ typedef std::reverse_iterator<const_iterator> const_reverse_iterator; +/
    iterator begin() { return data(); }
    const_iterator begin() const/+ noexcept+/ { return data(); }
    const_iterator cbegin() const/+ noexcept+/ { return begin(); }
    const_iterator constBegin() const/+ noexcept+/ { return begin(); }
    iterator end() { return data() + size(); }
    const_iterator end() const/+ noexcept+/ { return data() + size(); }
    const_iterator cend() const/+ noexcept+/ { return end(); }
    const_iterator constEnd() const/+ noexcept+/ { return end(); }
    /+ reverse_iterator rbegin() { return reverse_iterator(end()); } +/
    /+ reverse_iterator rend() { return reverse_iterator(begin()); } +/
    /+ const_reverse_iterator rbegin() const noexcept { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator rend() const noexcept { return const_reverse_iterator(begin()); } +/
    /+ const_reverse_iterator crbegin() const noexcept { return rbegin(); } +/
    /+ const_reverse_iterator crend() const noexcept { return rend(); } +/

    // stl compatibility
    alias size_type = qsizetype;
    alias difference_type = qptrdiff;
    /+ typedef const char & const_reference; +/
    /+ typedef char & reference; +/
    alias pointer = char*;
    alias const_pointer = const(char)*;
    alias value_type = char;
    void push_back(char c)
    { append(c); }
    void push_back(const(char)* s)
    { append(s); }
    void push_back(ref const(QByteArray) a)
    { append(a); }
    void push_back(QByteArrayView a)
    { append(a); }
    void push_front(char c)
    { prepend(c); }
    void push_front(const(char)* c)
    { prepend(c); }
    void push_front(ref const(QByteArray) a)
    { prepend(a); }
    void push_front(QByteArrayView a)
    { prepend(a); }
    void shrink_to_fit() { squeeze(); }
    iterator erase(const_iterator first, const_iterator last);

    /+ static QByteArray fromStdString(const std::string &s); +/
    /+ std::string toStdString() const; +/

    pragma(inline, true) qsizetype size() const/+ noexcept+/ { return d.size; }
/+ #if QT_DEPRECATED_SINCE(6, 4) +/
    /+ QT_DEPRECATED_VERSION_X_6_4("Use size() or length() instead.") +/
        pragma(inline, true) qsizetype count() const/+ noexcept+/ { return size(); }
/+ #endif +/
    pragma(inline, true) qsizetype length() const/+ noexcept+/ { return size(); }
    /+ QT_CORE_INLINE_SINCE(6, 4) +/
        pragma(inline, true) bool isNull() const/+ noexcept+/
    {
        return d.isNull();
    }

    pragma(inline, true) ref DataPointer data_ptr() return { return d; }
/+ #if QT_VERSION < QT_VERSION_CHECK(7, 0, 0) +/
    /+ explicit +/ pragma(inline, true) this(ref DataPointer dd)
    {
        this.d = dd;
    }
/+ #endif +/
    /+ explicit inline QByteArray(DataPointer &&dd) : d(std::move(dd)) {} +/

    bool opEquals(const QByteArray a2) const
    {
        return QByteArrayView(this) == QByteArrayView(a2);
    }
    int opCmp(const QByteArray a2) const
    {
        import qt.core.bytearrayalgorithms;
        return compareMemory(QByteArrayView(this), QByteArrayView(a2));
    }
    bool opEquals(const char* a2) const
    {
        import qt.core.bytearrayalgorithms;
        return a2 ? compareMemory(QByteArrayView(this), QByteArrayView(a2)) == 0 : this.isEmpty();
    }

private:
    void reallocData(qsizetype alloc, QArrayData.AllocationOption option);
    void reallocGrowData(qsizetype n);
    void expand(qsizetype i);

    static QByteArray toLower_helper(ref const(QByteArray) a);
    static QByteArray toLower_helper(ref QByteArray a);
    static QByteArray toUpper_helper(ref const(QByteArray) a);
    static QByteArray toUpper_helper(ref QByteArray a);
    static QByteArray trimmed_helper(ref const(QByteArray) a);
    static QByteArray trimmed_helper(ref QByteArray a);
    static QByteArray simplified_helper(ref const(QByteArray) a);
    static QByteArray simplified_helper(ref QByteArray a);

    /+ friend class QString; +/
    /+ friend Q_CORE_EXPORT QByteArray qUncompress(const uchar *data, qsizetype nbytes); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QByteArray.Base64Options.enum_type) operator |(QByteArray.Base64Options.enum_type f1, QByteArray.Base64Options.enum_type f2)/+noexcept+/{return QFlags!(QByteArray.Base64Options.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QByteArray.Base64Options.enum_type) operator |(QByteArray.Base64Options.enum_type f1, QFlags!(QByteArray.Base64Options.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QByteArray.Base64Options.enum_type) operator &(QByteArray.Base64Options.enum_type f1, QByteArray.Base64Options.enum_type f2)/+noexcept+/{return QFlags!(QByteArray.Base64Options.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QByteArray.Base64Options.enum_type) operator &(QByteArray.Base64Options.enum_type f1, QFlags!(QByteArray.Base64Options.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QByteArray.Base64Options.enum_type) operator ^(QByteArray.Base64Options.enum_type f1, QByteArray.Base64Options.enum_type f2)/+noexcept+/{return QFlags!(QByteArray.Base64Options.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QByteArray.Base64Options.enum_type) operator ^(QByteArray.Base64Options.enum_type f1, QFlags!(QByteArray.Base64Options.enum_type) f2)/+noexcept+/{return f2^f1;}+/
/+pragma(inline, true) void operator +(QByteArray.Base64Options.enum_type f1, QByteArray.Base64Options.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QByteArray.Base64Options.enum_type f1, QFlags!(QByteArray.Base64Options.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QByteArray.Base64Options.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QByteArray.Base64Options.enum_type f1, QByteArray.Base64Options.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QByteArray.Base64Options.enum_type f1, QFlags!(QByteArray.Base64Options.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QByteArray.Base64Options.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QByteArray.Base64Options.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QByteArray.Base64Options.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QByteArray.Base64Options.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QByteArray.Base64Options.enum_type f1, int f2)/+noexcept+/;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QByteArray.Base64Options operator ~(QByteArray.Base64Options.enum_type e)/+noexcept+/{return~QByteArray.Base64Options(e);}+/
/+pragma(inline, true) void operator |(QByteArray.Base64Options.enum_type f1, int f2)/+noexcept+/;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QByteArray.Base64Options.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QByteArray::Base64Options)
#ifndef QT_NO_CAST_FROM_BYTEARRAY
#endif +/
version (QT_USE_QSTRINGBUILDER) {} else
{
/+pragma(inline, true) const(QByteArray) operator +(ref const(QByteArray) a1, ref const(QByteArray) a2)
{ return QByteArray(a1) ~= a2; }+/
/+pragma(inline, true) const(QByteArray) operator +(ref const(QByteArray) a1, const(char)* a2)
{ return QByteArray(a1) ~= a2; }+/
/+pragma(inline, true) const(QByteArray) operator +(ref const(QByteArray) a1, char a2)
{ return QByteArray(a1) ~= a2; }+/
/+pragma(inline, true) const(QByteArray) operator +(const(char)* a1, ref const(QByteArray) a2)
{ return QByteArray(a1) ~= a2; }+/
/+pragma(inline, true) const(QByteArray) operator +(char a1, ref const(QByteArray) a2)
{ return QByteArray(&a1, 1) ~= a2; }+/
}

/+ #if QT_CORE_INLINE_IMPL_SINCE(6, 4)
#endif

#if !defined(QT_NO_DATASTREAM) || defined(QT_BOOTSTRAPPED)
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QByteArray &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QByteArray &);
#endif +/

version (QT_NO_COMPRESS) {} else
{
/+ Q_CORE_EXPORT +/ QByteArray qCompress(const(uchar)* data, qsizetype nbytes, int compressionLevel = -1);
/+ Q_CORE_EXPORT +/ QByteArray qUncompress(const(uchar)* data, qsizetype nbytes);
pragma(inline, true) QByteArray qCompress(ref const(QByteArray) data, int compressionLevel = -1)
{ return qCompress(reinterpret_cast!(const(uchar)*)(data.constData()), data.size(), compressionLevel); }
pragma(inline, true) QByteArray qUncompress(ref const(QByteArray) data)
{ return qUncompress(reinterpret_cast!(const(uchar)*)(data.constData()), data.size()); }
}

/+ Q_DECLARE_SHARED(QByteArray)

Q_DECLARE_SHARED(QByteArray::FromBase64Result)


Q_CORE_EXPORT Q_DECL_PURE_FUNCTION size_t qHash(const QByteArray::FromBase64Result &key, size_t seed = 0) noexcept; +/

qsizetype erase(T)(ref QByteArray ba, ref const(T) t)
{
    import qt.core.containertools_impl;

    return /+ QtPrivate:: +/qt.core.containertools_impl.sequential_erase(ba, t);
}

qsizetype erase_if(Predicate)(ref QByteArray ba, Predicate pred)
{
    import qt.core.containertools_impl;

    return /+ QtPrivate:: +/qt.core.containertools_impl.sequential_erase_if(ba, pred);
}

/+ extern(C++, "Qt") {
/+ inline +/ 
inlineextern(C++, "Literals") {
/+ inline namespace StringLiterals {

} +/ // StringLiterals
} // Literals
} +/ // Qt

/+ inline namespace QtLiterals {
#if QT_DEPRECATED_SINCE(6, 8)

#endif // QT_DEPRECATED_SINCE(6, 8)
} +/ // QtLiterals

