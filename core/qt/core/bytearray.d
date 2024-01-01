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
import qt.core.flags;
import qt.core.global;
import qt.core.list;
import qt.core.namespace;
import qt.core.typeinfo;
import qt.helpers;

/+ #ifdef truncate
#error qbytearray.h must be included before any header file that defines truncate
#endif

#if defined(Q_OS_DARWIN) || defined(Q_QDOC)
Q_FORWARD_DECLARE_CF_TYPE(CFData);
Q_FORWARD_DECLARE_OBJC_CLASS(NSData);
#endif +/



/*****************************************************************************
  Safe and portable C string functions; extensions to standard string.h
 *****************************************************************************/

/+ Q_CORE_EXPORT +/ char* qstrdup(const(char)* );

pragma(inline, true) uint qstrlen(const(char)* str)
{
    import core.stdc.string;
    return str ? cast(uint) (strlen(str)) : 0;
}

pragma(inline, true) uint qstrnlen(const(char)* str, uint maxlen)
{
    uint length = 0;
    if (str) {
        while (length < maxlen && *str++)
            length++;
    }
    return length;
}

/+ Q_CORE_EXPORT +/ char* qstrcpy(char* dst, const(char)* src);
/+ Q_CORE_EXPORT +/ char* qstrncpy(char* dst, const(char)* src, uint len);

/+ Q_CORE_EXPORT +/ int qstrcmp(const(char)* str1, const(char)* str2);
/+ Q_CORE_EXPORT +/ int qstrcmp(ref const(QByteArray) str1, ref const(QByteArray) str2);
/+ Q_CORE_EXPORT +/ int qstrcmp(ref const(QByteArray) str1, const(char)* str2);
pragma(inline, true) int qstrcmp(const(char)* str1, ref const(QByteArray) str2)
{ return -qstrcmp(str2, str1); }

pragma(inline, true) int qstrncmp(const(char)* str1, const(char)* str2, uint len)
{
    import core.stdc.string;

    return (str1 && str2) ? strncmp(str1, str2, len)
        : (str1 ? 1 : (str2 ? -1 : 0));
}
/+ Q_CORE_EXPORT +/ int qstricmp(const(char)* , const(char)* );
/+ Q_CORE_EXPORT +/ int qstrnicmp(const(char)* , const(char)* , uint len);
/+ Q_CORE_EXPORT +/ int qstrnicmp(const(char)* , qsizetype, const(char)* , qsizetype /+ = -1 +/);

// implemented in qvsnprintf.cpp
/+ Q_CORE_EXPORT +/ int qvsnprintf(char* str, size_t n, const(char)* fmt, va_list ap);
/+ Q_CORE_EXPORT +/ int qsnprintf(char* str, size_t n, const(char)* fmt, ...);

// qChecksum: Internet checksum
/+ Q_CORE_EXPORT +/ quint16 qChecksum(const(char)* s, uint len);                            // ### Qt 6: Remove
/+ Q_CORE_EXPORT +/ quint16 qChecksum(const(char)* s, uint len, /+ Qt:: +/qt.core.namespace.ChecksumType standard); // ### Qt 6: Use Qt::ChecksumType standard = Qt::ChecksumIso3309


alias QByteArrayData = QArrayData;

struct QStaticByteArrayData(int N)
{
    QByteArrayData ba;
    char[N + 1] data;

    QByteArrayData* data_ptr() const
    {
        (mixin(Q_ASSERT(q{QStaticByteArrayData.ba.ref_.isStatic()})));
        return const_cast!(QByteArrayData*)(&ba);
    }
}

struct QByteArrayDataPtr
{
    QByteArrayData* ptr;
}

/+ #define Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(size, offset) \
    Q_STATIC_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(size, offset)
    /**/

#define Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER(size) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(size, sizeof(QByteArrayData)) \
    /**/

#  define QByteArrayLiteral(str) \
    ([]() -> QByteArray { \
        enum { Size = sizeof(str) - 1 }; \
        static const QStaticByteArrayData<Size> qbytearray_literal = { \
            Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER(Size), \
            str }; \
        QByteArrayDataPtr holder = { qbytearray_literal.data_ptr() }; \
        return QByteArray(holder); \
    }()) \
    /**/
#    define Q_REQUIRED_RESULT
#    define Q_REQUIRED_RESULT_pushed +/

/// Binding for C++ class [QByteArray](https://doc.qt.io/qt-5/qbytearray.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QByteArray
{
private:
    alias Data = QTypedArrayData!(char);

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

    version (Windows)
    {
        @disable this();
        pragma(inline, true) void rawConstructor()/+ noexcept+/
        {
            this.d = Data.sharedNull();
        }
        static typeof(this) create()
        {
            typeof(this) r = typeof(this).init;
            r.rawConstructor();
            return r;
        }
    }
    else
    {
        static typeof(this) create()
        {
            return typeof(this).init;
        }
    }

    this(const(char)* , int size = -1);
    this(int size, char c);
    this(int size, /+ Qt:: +/qt.core.namespace.Initialization);
    @disable this(this);
    pragma(inline, true) this(ref const(QByteArray) a)/+ noexcept+/
    {
        this.d = cast(Data*)a.d;
        d.ref_.ref_();
    }
    pragma(inline, true) ~this() { if (!d.ref_.deref()) Data.deallocate(d); }

    /+ref QByteArray operator =(ref const(QByteArray) )/+ noexcept+/;+/
    /+ref QByteArray operator =(const(char)* str);+/
    /+ inline QByteArray(QByteArray && other) noexcept : d(other.d) { other.d = Data::sharedNull(); } +/
    /+ inline QByteArray &operator=(QByteArray &&other) noexcept
    { qSwap(d, other.d); return *this; } +/

    /+ inline void swap(QByteArray &other) noexcept
    { qSwap(d, other.d); } +/

    pragma(inline, true) int size() const
    { return d.size; }
    pragma(inline, true) bool isEmpty() const
    { return d.size == 0; }
    void resize(int size);

    ref QByteArray fill(char c, int size = -1);

    pragma(inline, true) int capacity() const
    { return d.alloc ? d.alloc - 1 : 0; }
    pragma(inline, true) void reserve(int asize)
    {
        if (d.ref_.isShared() || uint(asize) + 1u > d.alloc) {
            reallocData(qMax(uint(size()), uint(asize)) + 1u, d.detachFlags() | Data.AllocationOption.CapacityReserved);
        } else {
            // cannot set unconditionally, since d could be the shared_null or
            // otherwise static
            d.capacityReserved = true;
        }
    }
    pragma(inline, true) void squeeze()
    {
        if (d.ref_.isShared() || uint(d.size) + 1u < d.alloc) {
            reallocData(uint(d.size) + 1u, d.detachFlags() & ~Data.AllocationOption.CapacityReserved);
        } else {
            // cannot set unconditionally, since d could be shared_null or
            // otherwise static.
            d.capacityReserved = false;
        }
    }

    version (QT_NO_CAST_FROM_BYTEARRAY) {} else
    {
        /+pragma(inline, true) auto opCast(T : const(char))() const;+/
        /+pragma(inline, true) auto opCast(T : const(void))() const;+/
    }
    pragma(inline, true) char* data()
    { detach(); return cast(char*) (d.data()); }
    pragma(inline, true) const(char)* data() const
    { return cast(const(char)*) (d.data()); }
    pragma(inline, true) const(char)* constData() const
    { return cast(const(char)*) (d.data()); }

    extern(D) const(ubyte)[] toConstUByteArray()
    {
        return (cast(const(ubyte)*) constData())[0..length];
    }
    extern(D) const(char)[] toConstCharArray()
    {
        return (cast(const(char)*) constData())[0..length];
    }

    pragma(inline, true) void detach()
    { if (d.ref_.isShared() || (d.offset != QByteArrayData.sizeof)) reallocData(uint(d.size) + 1u, d.detachFlags()); }
    pragma(inline, true) bool isDetached() const
    { return !d.ref_.isShared(); }
    pragma(inline, true) bool isSharedWith(ref const(QByteArray) other) const { return d == other.d; }
    void clear();

    pragma(inline, true) char at(int i) const
    { (mixin(Q_ASSERT(q{uint(i) < uint(size())}))); return d.data()[i]; }
    pragma(inline, true) char opIndex(int i) const
    { (mixin(Q_ASSERT(q{uint(i) < uint(size())}))); return d.data()[i]; }
    pragma(inline, true) char opIndex(uint i) const
    { (mixin(Q_ASSERT(q{i < uint(size())}))); return d.data()[i]; }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QByteRef opIndex(int i)
    { (mixin(Q_ASSERT(q{i >= 0}))); detach(); return QByteRef(this, i); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QByteRef opIndex(uint i)
    {  detach(); return QByteRef(this, i); }
    /+ Q_REQUIRED_RESULT +/ char front() const { return at(0); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QByteRef front() { return opIndex(0); }
    /+ Q_REQUIRED_RESULT +/ char back() const { return at(size() - 1); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QByteRef back() { return opIndex(size() - 1); }

    int indexOf(char c, int from = 0) const;
    int indexOf(const(char)* c, int from = 0) const;
    int indexOf(ref const(QByteArray) a, int from = 0) const;
    int lastIndexOf(char c, int from = -1) const;
    int lastIndexOf(const(char)* c, int from = -1) const;
    int lastIndexOf(ref const(QByteArray) a, int from = -1) const;

    pragma(inline, true) bool contains(char c) const
    { return indexOf(c) != -1; }
    pragma(inline, true) bool contains(const(char)* c) const
    { return indexOf(c) != -1; }
    pragma(inline, true) bool contains(ref const(QByteArray) a) const
    { return indexOf(a) != -1; }
    int count(char c) const;
    int count(const(char)* a) const;
    int count(ref const(QByteArray) a) const;

    pragma(inline, true) int compare(const(char)* c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        return cs == /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive ? qstrcmp(this, c) :
                                         qstrnicmp(data(), size(), c, -1);
    }
    pragma(inline, true) int compare(ref const(QByteArray) a, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        return cs == /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive ? qstrcmp(this, a) :
                                         qstrnicmp(data(), size(), a.data(), a.size());
    }

    /+ Q_REQUIRED_RESULT +/ QByteArray left(int len) const;
    /+ Q_REQUIRED_RESULT +/ QByteArray right(int len) const;
    /+ Q_REQUIRED_RESULT +/ QByteArray mid(int index, int len = -1) const;
    /+ Q_REQUIRED_RESULT +/ QByteArray chopped(int len) const
    { (mixin(Q_ASSERT(q{len >= 0}))); (mixin(Q_ASSERT(q{len <= size()}))); return left(size() - len); }

    bool startsWith(ref const(QByteArray) a) const;
    bool startsWith(char c) const;
    bool startsWith(const(char)* c) const;

    bool endsWith(ref const(QByteArray) a) const;
    bool endsWith(char c) const;
    bool endsWith(const(char)* c) const;

    bool isUpper() const;
    bool isLower() const;

    void truncate(int pos);
    void chop(int n);

/+ #if defined(Q_COMPILER_REF_QUALIFIERS) && !defined(QT_COMPILING_QSTRING_COMPAT_CPP) && !defined(Q_CLANG_QDOC)
#  if defined(Q_CC_GNU) && !defined(Q_CC_CLANG) && !defined(Q_CC_INTEL) && !__has_cpp_attribute(nodiscard)
    // required due to https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61941
#    pragma push_macro("Q_REQUIRED_RESULT")
#    undef Q_REQUIRED_RESULT
#    define Q_REQUIRED_RESULT
#    define Q_REQUIRED_RESULT_pushed
#  endif +/
    /+ Q_REQUIRED_RESULT +/ QByteArray toLower() const/+ &+/
    { return toLower_helper(this); }
    /+ Q_REQUIRED_RESULT QByteArray toLower() &&
    { return toLower_helper(*this); } +/
    /+ Q_REQUIRED_RESULT +/ QByteArray toUpper() const/+ &+/
    { return toUpper_helper(this); }
    /+ Q_REQUIRED_RESULT QByteArray toUpper() &&
    { return toUpper_helper(*this); } +/
    /+ Q_REQUIRED_RESULT +/ QByteArray trimmed() const/+ &+/
    { return trimmed_helper(this); }
    /+ Q_REQUIRED_RESULT QByteArray trimmed() &&
    { return trimmed_helper(*this); } +/
    /+ Q_REQUIRED_RESULT +/ QByteArray simplified() const/+ &+/
    { return simplified_helper(this); }
    /+ Q_REQUIRED_RESULT QByteArray simplified() &&
    { return simplified_helper(*this); } +/
/+ #  ifdef Q_REQUIRED_RESULT_pushed
#    pragma pop_macro("Q_REQUIRED_RESULT")
#  endif
#else
    Q_REQUIRED_RESULT QByteArray toLower() const;
    Q_REQUIRED_RESULT QByteArray toUpper() const;
    Q_REQUIRED_RESULT QByteArray trimmed() const;
    Q_REQUIRED_RESULT QByteArray simplified() const;
#endif +/

    /+ Q_REQUIRED_RESULT +/ QByteArray leftJustified(int width, char fill = ' ', bool truncate = false) const;
    /+ Q_REQUIRED_RESULT +/ QByteArray rightJustified(int width, char fill = ' ', bool truncate = false) const;

    ref QByteArray prepend(char c);
    pragma(inline, true) ref QByteArray prepend(int n, char ch)
    { return insert(0, n, ch); }
    ref QByteArray prepend(const(char)* s);
    ref QByteArray prepend(const(char)* s, int len);
    ref QByteArray prepend(ref const(QByteArray) a);
    ref QByteArray append(char c);
    pragma(inline, true) ref QByteArray append(int n, char ch)
    { return insert(d.size, n, ch); }
    ref QByteArray append(const(char)* s);
    ref QByteArray append(const(char)* s, int len);
    ref QByteArray append(ref const(QByteArray) a);
    ref QByteArray insert(int i, char c);
    ref QByteArray insert(int i, int count, char c);
    ref QByteArray insert(int i, const(char)* s);
    ref QByteArray insert(int i, const(char)* s, int len);
    ref QByteArray insert(int i, ref const(QByteArray) a);
    ref QByteArray remove(int index, int len);
    ref QByteArray replace(int index, int len, const(char)* s);
    ref QByteArray replace(int index, int len, const(char)* s, int alen);
    ref QByteArray replace(int index, int len, ref const(QByteArray) s);
    pragma(inline, true) ref QByteArray replace(char before, const(char)* c)
    { return replace(&before, 1, c, qstrlen(c)); }
    ref QByteArray replace(char before, ref const(QByteArray) after);
    pragma(inline, true) ref QByteArray replace(const(char)* before, const(char)* after)
    { return replace(before, qstrlen(before), after, qstrlen(after)); }
    ref QByteArray replace(const(char)* before, int bsize, const(char)* after, int asize);
    ref QByteArray replace(ref const(QByteArray) before, ref const(QByteArray) after);
    pragma(inline, true) ref QByteArray replace(ref const(QByteArray) before, const(char)* c)
    { return replace(before.constData(), before.size(), c, qstrlen(c)); }
    ref QByteArray replace(const(char)* before, ref const(QByteArray) after);
    ref QByteArray replace(char before, char after);
    extern(D) pragma(inline, true) ref QByteArray opOpAssign(string op)(char c) if (op == "~")
    { return append(c); }
    extern(D) pragma(inline, true) ref QByteArray opOpAssign(string op)(const(char)* s) if (op == "~")
    { return append(s); }
    extern(D) pragma(inline, true) ref QByteArray opOpAssign(string op)(ref const(QByteArray) a) if (op == "~")
    { return append(a); }

    QList!(QByteArray) split(char sep) const;

    /+ Q_REQUIRED_RESULT +/ QByteArray repeated(int times) const;

/+ #if !defined(QT_NO_CAST_TO_ASCII) && QT_DEPRECATED_SINCE(5, 15)
    QT_DEPRECATED_VERSION_X_5_15("Use QString's toUtf8(), toLatin1() or toLocal8Bit()")
    QByteArray &append(const QString &s);
    QT_DEPRECATED_VERSION_X_5_15("Use QString's toUtf8(), toLatin1() or toLocal8Bit()")
    QByteArray &insert(int i, const QString &s);
    QT_DEPRECATED_VERSION_X_5_15("Use QString's toUtf8(), toLatin1() or toLocal8Bit()")
    QByteArray &replace(const QString &before, const char *after);
    QT_DEPRECATED_VERSION_X_5_15("Use QString's toUtf8(), toLatin1() or toLocal8Bit()")
    QByteArray &replace(char c, const QString &after);
    QT_DEPRECATED_VERSION_X_5_15("Use QString's toUtf8(), toLatin1() or toLocal8Bit()")
    QByteArray &replace(const QString &before, const QByteArray &after);

    QT_DEPRECATED_VERSION_X_5_15("Use QString's toUtf8(), toLatin1() or toLocal8Bit()")
    QByteArray &operator+=(const QString &s);
    QT_DEPRECATED_VERSION_X_5_15("Use QString's toUtf8(), toLatin1() or toLocal8Bit()")
    int indexOf(const QString &s, int from = 0) const;
    QT_DEPRECATED_VERSION_X_5_15("Use QString's toUtf8(), toLatin1() or toLocal8Bit()")
    int lastIndexOf(const QString &s, int from = -1) const;
#endif
#if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
    inline bool operator==(const QString &s2) const;
    inline bool operator!=(const QString &s2) const;
    inline bool operator<(const QString &s2) const;
    inline bool operator>(const QString &s2) const;
    inline bool operator<=(const QString &s2) const;
    inline bool operator>=(const QString &s2) const;
#endif +/

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
    QByteArray toBase64(Base64Options options) const;
    QByteArray toBase64() const; // ### Qt6 merge with previous
    QByteArray toHex() const;
    QByteArray toHex(char separator) const; // ### Qt6 merge with previous
    QByteArray toPercentEncoding(ref const(QByteArray) exclude/* = globalInitVar!QByteArray*/,
                                     ref const(QByteArray) include/* = globalInitVar!QByteArray*/,
                                     char percent/* = '%'*/) const;

    pragma(inline, true) ref QByteArray setNum(short n, int base = 10)
    { return base == 10 ? setNum(qlonglong(n), base) : setNum(qulonglong(ushort(n)), base); }
    pragma(inline, true) ref QByteArray setNum(ushort n, int base = 10)
    { return setNum(qulonglong(n), base); }
    pragma(inline, true) ref QByteArray setNum(int n, int base = 10)
    { return base == 10 ? setNum(qlonglong(n), base) : setNum(qulonglong(uint(n)), base); }
    pragma(inline, true) ref QByteArray setNum(uint n, int base = 10)
    { return setNum(qulonglong(n), base); }
    ref QByteArray setNum(qlonglong, int base = 10);
    ref QByteArray setNum(qulonglong, int base = 10);
    pragma(inline, true) ref QByteArray setNum(float n, char f = 'g', int prec = 6)
    { return setNum(double(n),f,prec); }
    ref QByteArray setNum(double, char f = 'g', int prec = 6);
    ref QByteArray setRawData(const(char)* a, uint n); // ### Qt 6: use an int

    /+ Q_REQUIRED_RESULT +/ static QByteArray number(int, int base = 10);
    /+ Q_REQUIRED_RESULT +/ static QByteArray number(uint, int base = 10);
    /+ Q_REQUIRED_RESULT +/ static QByteArray number(qlonglong, int base = 10);
    /+ Q_REQUIRED_RESULT +/ static QByteArray number(qulonglong, int base = 10);
    /+ Q_REQUIRED_RESULT +/ static QByteArray number(double, char f = 'g', int prec = 6);
    /+ Q_REQUIRED_RESULT +/ static QByteArray fromRawData(const(char)* , int size);

    /+
    extern(C++, class) struct FromBase64Result;
    +/
    /// Binding for C++ class [QByteArray::FromBase64Result](https://doc.qt.io/qt-5/qbytearray-frombase64result.html).
    extern(C++, class) struct FromBase64Result
    {
    public:
        QByteArray decoded;
        Base64DecodingStatus decodingStatus;

        /+ void swap(QByteArray::FromBase64Result &other) noexcept
        {
            qSwap(decoded, other.decoded);
            qSwap(decodingStatus, other.decodingStatus);
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
        mixin(CREATE_CONVENIENCE_WRAPPERS);
    }

    /+ Q_REQUIRED_RESULT static FromBase64Result fromBase64Encoding(QByteArray &&base64, Base64Options options = Base64Encoding); +/
    /+ Q_REQUIRED_RESULT +/ static FromBase64Result fromBase64Encoding(ref const(QByteArray) base64, Base64Options options = Base64Option.Base64Encoding);
    /+ Q_REQUIRED_RESULT +/ static QByteArray fromBase64(ref const(QByteArray) base64, Base64Options options);
    /+ Q_REQUIRED_RESULT +/ static QByteArray fromBase64(ref const(QByteArray) base64); // ### Qt6 merge with previous
    /+ Q_REQUIRED_RESULT +/ static QByteArray fromHex(ref const(QByteArray) hexEncoded);
    /+ Q_REQUIRED_RESULT +/ static QByteArray fromPercentEncoding(ref const(QByteArray) pctEncoded, char percent = '%');

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
    pragma(inline, true) iterator begin()
    { detach(); return cast(iterator) (d.data()); }
    pragma(inline, true) const_iterator begin() const
    { return cast(const_iterator) (d.data()); }
    pragma(inline, true) const_iterator cbegin() const
    { return cast(const_iterator) (d.data()); }
    pragma(inline, true) const_iterator constBegin() const
    { return cast(const_iterator) (d.data()); }
    pragma(inline, true) iterator end()
    { detach(); return cast(iterator) (d.data() + d.size); }
    pragma(inline, true) const_iterator end() const
    { return cast(const_iterator) (d.data() + d.size); }
    pragma(inline, true) const_iterator cend() const
    { return cast(const_iterator) (d.data() + d.size); }
    pragma(inline, true) const_iterator constEnd() const
    { return cast(const_iterator) (d.data() + d.size); }
    /+ reverse_iterator rbegin() { return reverse_iterator(end()); } +/
    /+ reverse_iterator rend() { return reverse_iterator(begin()); } +/
    /+ const_reverse_iterator rbegin() const { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator rend() const { return const_reverse_iterator(begin()); } +/
    /+ const_reverse_iterator crbegin() const { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator crend() const { return const_reverse_iterator(begin()); } +/

    // stl compatibility
    alias size_type = int;
    alias difference_type = qptrdiff;
    /+ typedef const char & const_reference; +/
    /+ typedef char & reference; +/
    alias pointer = char*;
    alias const_pointer = const(char)*;
    alias value_type = char;
    pragma(inline, true) void push_back(char c)
    { append(c); }
    pragma(inline, true) void push_back(const(char)* c)
    { append(c); }
    pragma(inline, true) void push_back(ref const(QByteArray) a)
    { append(a); }
    pragma(inline, true) void push_front(char c)
    { prepend(c); }
    pragma(inline, true) void push_front(const(char)* c)
    { prepend(c); }
    pragma(inline, true) void push_front(ref const(QByteArray) a)
    { prepend(a); }
    void shrink_to_fit() { squeeze(); }

    /+ static inline QByteArray fromStdString(const std::string &s); +/
    /+ inline std::string toStdString() const; +/

    pragma(inline, true) int count() const { return d.size; }
    int length() const { return d.size; }
    bool isNull() const;

    pragma(inline, true) this(QByteArrayDataPtr dd)
    {
        this.d = static_cast!(Data*)(dd.ptr);
    }

private:
    /+auto opCast(T : QNoImplicitBoolCast)() const;+/
    version (Windows)
        Data* d;
    else
    {
        union
        {
            const(QArrayData) *d2 = QArrayData.shared_null.ptr;
            Data* d;
        }
    }
    void reallocData(uint alloc, Data.AllocationOptions options);
    void expand(int i);
    QByteArray nulTerminated() const;

    static QByteArray toLower_helper(ref const(QByteArray) a);
    static QByteArray toLower_helper(ref QByteArray a);
    static QByteArray toUpper_helper(ref const(QByteArray) a);
    static QByteArray toUpper_helper(ref QByteArray a);
    static QByteArray trimmed_helper(ref const(QByteArray) a);
    static QByteArray trimmed_helper(ref QByteArray a);
    static QByteArray simplified_helper(ref const(QByteArray) a);
    static QByteArray simplified_helper(ref QByteArray a);

    /+ friend class QByteRef; +/
    /+ friend class QString; +/
    /+ friend Q_CORE_EXPORT QByteArray qUncompress(const uchar *data, int nbytes); +/
public:
    alias DataPtr = Data*;
    pragma(inline, true) ref DataPtr data_ptr() return { return d; }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QByteArray.Base64Options.enum_type) operator |(QByteArray.Base64Options.enum_type f1, QByteArray.Base64Options.enum_type f2)/+noexcept+/{return QFlags!(QByteArray.Base64Options.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QByteArray.Base64Options.enum_type) operator |(QByteArray.Base64Options.enum_type f1, QFlags!(QByteArray.Base64Options.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QByteArray.Base64Options.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QByteArray::Base64Options)#ifndef QT_NO_CAST_FROM_BYTEARRAY
#endif +/

extern(C++, "QtPrivate") {
extern(C++, "DeprecatedRefClassBehavior") {
    enum /+ class +/ EmittingClass {
        QByteRef,
        QCharRef,
    }

    enum /+ class +/ WarningType {
        OutOfRange,
        DelayedDetach,
    }

    /+ Q_CORE_EXPORT +/ /+ Q_DECL_COLD_FUNCTION +/ void warn(WarningType w, EmittingClass c);
} // namespace DeprecatedAssignmentOperatorBehavior
} // namespace QtPrivate

extern(C++, class) struct
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
Q_CORE_EXPORT
#endif +/
QByteRef {  // ### Qt 7: remove
private:
    QByteArray *a;
    int i;
    pragma(inline, true) this(ref QByteArray array, int idx)
    {
        this.a = &array;
        this.i = idx;
    }
    /+ friend class QByteArray; +/
public:
    /+ QByteRef(const QByteRef &) = default; +/
    /+pragma(inline, true) auto opCast(T : char)() const
    {
        using namespace /+ QtPrivate:: +/DeprecatedRefClassBehavior;
        if (/+ Q_LIKELY +/(i < a.d.size))
            return a.d.data()[i];
        version (QT_DEBUG)
        {
            warn(WarningType.OutOfRange, EmittingClass.QByteRef);
        }
        return cast(char) (0);
    }+/
    /+pragma(inline, true) ref QByteRef operator =(char c)
    {
        using namespace /+ QtPrivate:: +/DeprecatedRefClassBehavior;
        if (/+ Q_UNLIKELY +/(i >= a.d.size)) {
            version (QT_DEBUG)
            {
                warn(WarningType.OutOfRange, EmittingClass.QByteRef);
            }
            a.expand(i);
        } else {
            version (QT_DEBUG)
            {
                if (/+ Q_UNLIKELY +/(!a.isDetached()))
                    warn(WarningType.DelayedDetach, EmittingClass.QByteRef);
            }
            a.detach();
        }
        a.d.data()[i] = c;
        return this;
    }+/
    /+pragma(inline, true) ref QByteRef operator =(ref const(QByteRef) c)
    {
        return operator=(cast(char) (c));
    }+/
    /+pragma(inline, true) bool operator ==(char c) const
    { return a.d.data()[i] == c; }+/
    /+pragma(inline, true) bool operator !=(char c) const
    { return a.d.data()[i] != c; }+/
    /+pragma(inline, true) bool operator >(char c) const
    { return a.d.data()[i] > c; }+/
    /+pragma(inline, true) bool operator >=(char c) const
    { return a.d.data()[i] >= c; }+/
    /+pragma(inline, true) bool operator <(char c) const
    { return a.d.data()[i] < c; }+/
    /+pragma(inline, true) bool operator <=(char c) const
    { return a.d.data()[i] <= c; }+/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) bool operator ==(ref const(QByteArray) a1, ref const(QByteArray) a2)/+ noexcept+/
{
    import core.stdc.string;
    return (a1.size() == a2.size()) && (memcmp(a1.constData(), a2.constData(), a1.size())==0);
}+/
/+pragma(inline, true) bool operator ==(ref const(QByteArray) a1, const(char)* a2)/+ noexcept+/
{ return a2 ? qstrcmp(a1,a2) == 0 : a1.isEmpty(); }+/
/+pragma(inline, true) bool operator ==(const(char)* a1, ref const(QByteArray) a2)/+ noexcept+/
{ return a1 ? qstrcmp(a1,a2) == 0 : a2.isEmpty(); }+/
/+pragma(inline, true) bool operator !=(ref const(QByteArray) a1, ref const(QByteArray) a2)/+ noexcept+/
{ return !(a1==a2); }+/
/+pragma(inline, true) bool operator !=(ref const(QByteArray) a1, const(char)* a2)/+ noexcept+/
{ return a2 ? qstrcmp(a1,a2) != 0 : !a1.isEmpty(); }+/
/+pragma(inline, true) bool operator !=(const(char)* a1, ref const(QByteArray) a2)/+ noexcept+/
{ return a1 ? qstrcmp(a1,a2) != 0 : !a2.isEmpty(); }+/
/+pragma(inline, true) bool operator <(ref const(QByteArray) a1, ref const(QByteArray) a2)/+ noexcept+/
{ return qstrcmp(a1, a2) < 0; }+/
 /+pragma(inline, true) bool operator <(ref const(QByteArray) a1, const(char)* a2)/+ noexcept+/
{ return qstrcmp(a1, a2) < 0; }+/
/+pragma(inline, true) bool operator <(const(char)* a1, ref const(QByteArray) a2)/+ noexcept+/
{ return qstrcmp(a1, a2) < 0; }+/
/+pragma(inline, true) bool operator <=(ref const(QByteArray) a1, ref const(QByteArray) a2)/+ noexcept+/
{ return qstrcmp(a1, a2) <= 0; }+/
/+pragma(inline, true) bool operator <=(ref const(QByteArray) a1, const(char)* a2)/+ noexcept+/
{ return qstrcmp(a1, a2) <= 0; }+/
/+pragma(inline, true) bool operator <=(const(char)* a1, ref const(QByteArray) a2)/+ noexcept+/
{ return qstrcmp(a1, a2) <= 0; }+/
/+pragma(inline, true) bool operator >(ref const(QByteArray) a1, ref const(QByteArray) a2)/+ noexcept+/
{ return qstrcmp(a1, a2) > 0; }+/
/+pragma(inline, true) bool operator >(ref const(QByteArray) a1, const(char)* a2)/+ noexcept+/
{ return qstrcmp(a1, a2) > 0; }+/
/+pragma(inline, true) bool operator >(const(char)* a1, ref const(QByteArray) a2)/+ noexcept+/
{ return qstrcmp(a1, a2) > 0; }+/
/+pragma(inline, true) bool operator >=(ref const(QByteArray) a1, ref const(QByteArray) a2)/+ noexcept+/
{ return qstrcmp(a1, a2) >= 0; }+/
/+pragma(inline, true) bool operator >=(ref const(QByteArray) a1, const(char)* a2)/+ noexcept+/
{ return qstrcmp(a1, a2) >= 0; }+/
/+pragma(inline, true) bool operator >=(const(char)* a1, ref const(QByteArray) a2)/+ noexcept+/
{ return qstrcmp(a1, a2) >= 0; }+/
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

/+ inline std::string QByteArray::toStdString() const
{ return std::string(constData(), length()); }

inline QByteArray QByteArray::fromStdString(const std::string &s)
{ return QByteArray(s.data(), int(s.size())); }

#if !defined(QT_NO_DATASTREAM) || (defined(QT_BOOTSTRAPPED) && !defined(QT_BUILD_QMAKE))
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QByteArray &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QByteArray &);
#endif +/

version (QT_NO_COMPRESS) {} else
{
/+ Q_CORE_EXPORT +/ QByteArray qCompress(const(uchar)* data, int nbytes, int compressionLevel = -1);
/+ Q_CORE_EXPORT +/ QByteArray qUncompress(const(uchar)* data, int nbytes);
/+pragma(inline, true) QByteArray qCompress(ref const(QByteArray) data, int compressionLevel = -1)
{ return qCompress(reinterpret_cast!(const(uchar)*)(data.constData()), data.size(), compressionLevel); }
pragma(inline, true) QByteArray qUncompress(ref const(QByteArray) data)
{ return qUncompress(reinterpret_cast!(const(uchar)*)(data.constData()), data.size()); }
+/
}

/+ Q_DECLARE_SHARED(QByteArray)

Q_DECLARE_SHARED(QByteArray::FromBase64Result) +/

/+pragma(inline, true) bool operator ==(ref const(QByteArray.FromBase64Result) lhs, ref const(QByteArray.FromBase64Result) rhs)/+ noexcept+/
{
    if (lhs.decodingStatus != rhs.decodingStatus)
        return false;

    if (lhs.decodingStatus == QByteArray.Base64DecodingStatus.Ok && lhs.decoded != rhs.decoded)
        return false;

    return true;
}+/

/+pragma(inline, true) bool operator !=(ref const(QByteArray.FromBase64Result) lhs, ref const(QByteArray.FromBase64Result) rhs)/+ noexcept+/
{
    return !operator==(lhs, rhs);
}+/

/+ Q_CORE_EXPORT Q_DECL_PURE_FUNCTION uint qHash(const QByteArray::FromBase64Result &key, uint seed = 0) noexcept;
typedef QArrayData QByteArrayData; +/

