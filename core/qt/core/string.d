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
module qt.core.string;
extern(C++):

import core.stdc.config;
import core.stdc.stddef;
import core.vararg;
import qt.config;
import qt.core.arraydata;
import qt.core.bytearray;
import qt.core.flags;
import qt.core.global;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.qchar;
import qt.core.regularexpression;
import qt.core.stringlist;
import qt.core.stringliteral;
import qt.core.stringview;
import qt.core.typeinfo;
import qt.core.vector;
import qt.helpers;
version(QT_NO_REGEXP){}else
    import qt.core.regexp;

/+ #if defined(QT_NO_CAST_FROM_ASCII) && defined(QT_RESTRICTED_CAST_FROM_ASCII)
#error QT_NO_CAST_FROM_ASCII and QT_RESTRICTED_CAST_FROM_ASCII must not be defined at the same time
#endif

#ifdef truncate
#error qstring.h must be included before any header file that defines truncate
#endif

#if defined(Q_OS_DARWIN) || defined(Q_QDOC)
Q_FORWARD_DECLARE_CF_TYPE(CFString);
Q_FORWARD_DECLARE_OBJC_CLASS(NSString);
#endif


class QCharRef;
class QRegularExpression;
class QRegularExpressionMatch;
class QString;
class QStringList;
class QTextCodec;
class QStringRef;
template <typename T> class QVector;

namespace QtPrivate {
template <bool...B> class BoolList;
} +/

/// Binding for C++ class [QLatin1String](https://doc.qt.io/qt-5/qlatin1string.html).
@Q_MOVABLE_TYPE extern(C++, class) struct QLatin1String
{
public:
    static import qt.core.stringalgorithms;
    @disable this();
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.m_size = 0;
        this.m_data = null;
    }+/
    /+ explicit +/pragma(inline, true) this(const(char)* s)/+ noexcept+/
    {
        import core.stdc.string;
        this.m_size = s ? cast(int)(strlen(s)) : 0;
        this.m_data = s;
    }
    /+ explicit +/this(const(char)* f, const(char)* l)
    {
        this(f, cast(int)(l - f));
    }
    /+ explicit +/pragma(inline, true) this(const(char)* s, int sz)/+ noexcept+/
    {
        this.m_size = sz;
        this.m_data = s;
    }
    /+ explicit +/pragma(inline, true) this(ref const(QByteArray) s)/+ noexcept+/
    {
        this.m_size = int(qstrnlen(s.constData(), s.size()));
        this.m_data = s.constData();
    }

    const(char)* latin1() const/+ noexcept+/ { return m_data; }
    int size() const/+ noexcept+/ { return m_size; }
    const(char)* data() const/+ noexcept+/ { return m_data; }

    bool isNull() const/+ noexcept+/ { return !data(); }
    bool isEmpty() const/+ noexcept+/ { return !size(); }

    /+ template <typename...Args> +/
    /+ Q_REQUIRED_RESULT inline QString arg(Args &&...args) const; +/

    QLatin1Char at(int i) const
    { return (){(){ (mixin(Q_ASSERT(q{i >= 0})));
return /+ Q_ASSERT(i < size()) +/ mixin(Q_ASSERT(q{i < QLatin1String.size()}));
}();
return QLatin1Char(m_data[i]);
}(); }
    QLatin1Char opIndex(int i) const { return at(i); }

    /+ Q_REQUIRED_RESULT +/ QLatin1Char front() const { return at(0); }
    /+ Q_REQUIRED_RESULT +/ QLatin1Char back() const { return at(size() - 1); }

    /+ Q_REQUIRED_RESULT +/ int compare(QStringView other, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(this, other, cs);
    }
    /+ Q_REQUIRED_RESULT +/ int compare(QLatin1String other, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(this, other, cs);
    }
    /+ Q_REQUIRED_RESULT +/ int compare(QChar c) const/+ noexcept+/
    { return isEmpty() || front().unicode == c.unicode ? size() - 1 : uchar(m_data[0]) - c.unicode() ; }
    /+ Q_REQUIRED_RESULT +/ int compare(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(this, QStringView(&c, 1), cs);
    }

    /+ Q_REQUIRED_RESULT +/ bool startsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(this, s, cs);
    }
    /+ Q_REQUIRED_RESULT +/ bool startsWith(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(this, s, cs);
    }
    /+ Q_REQUIRED_RESULT +/ bool startsWith(QChar c) const/+ noexcept+/
    { return !isEmpty() && front().unicode == c.unicode; }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool startsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(this, QStringView(&c, 1), cs);
    }

    /+ Q_REQUIRED_RESULT +/ bool endsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(this, s, cs);
    }
    /+ Q_REQUIRED_RESULT +/ bool endsWith(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(this, s, cs);
    }
    /+ Q_REQUIRED_RESULT +/ bool endsWith(QChar c) const/+ noexcept+/
    { return !isEmpty() && back().unicode == c.unicode; }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool endsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(this, QStringView(&c, 1), cs);
    }

    /+ Q_REQUIRED_RESULT +/ int indexOf(QStringView s, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return cast(int)(/+ QtPrivate:: +/qt.core.stringalgorithms.findString(this, from, s, cs));
    } // ### Qt6: qsizetype
    /+ Q_REQUIRED_RESULT +/ int indexOf(QLatin1String s, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return cast(int)(/+ QtPrivate:: +/qt.core.stringalgorithms.findString(this, from, s, cs));
    } // ### Qt6: qsizetype
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) int indexOf(QChar c, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return cast(int)(/+ QtPrivate:: +/qt.core.stringalgorithms.findString(this, from, QStringView(&c, 1), cs));
    } // ### Qt6: qsizetype

    /+ Q_REQUIRED_RESULT +/ bool contains(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(s, 0, cs) != -1; }
    /+ Q_REQUIRED_RESULT +/ bool contains(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(s, 0, cs) != -1; }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool contains(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(QStringView(&c, 1), 0, cs) != -1; }

    /+ Q_REQUIRED_RESULT +/ int lastIndexOf(QStringView s, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return cast(int)(/+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, from, s, cs));
    } // ### Qt6: qsizetype
    /+ Q_REQUIRED_RESULT +/ int lastIndexOf(QLatin1String s, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return cast(int)(/+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, from, s, cs));
    } // ### Qt6: qsizetype
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) int lastIndexOf(QChar c, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return cast(int)(/+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(this, from, QStringView(&c, 1), cs));
    } // ### Qt6: qsizetype

    alias value_type = const(char);
    /+ using reference = value_type&; +/
    /+ using const_reference = reference; +/
    alias iterator = value_type*;
    alias const_iterator = iterator;
    alias difference_type = int; // violates Container concept requirements
    alias size_type = int;       // violates Container concept requirements

    const_iterator begin() const/+ noexcept+/ { return data(); }
    const_iterator cbegin() const/+ noexcept+/ { return data(); }
    const_iterator end() const/+ noexcept+/ { return data() + size(); }
    const_iterator cend() const/+ noexcept+/ { return data() + size(); }

    /+ using reverse_iterator = std::reverse_iterator<iterator>; +/
    /+ using const_reverse_iterator = reverse_iterator; +/

    /+ const_reverse_iterator rbegin() const noexcept { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator crbegin() const noexcept { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator rend() const noexcept { return const_reverse_iterator(begin()); } +/
    /+ const_reverse_iterator crend() const noexcept { return const_reverse_iterator(begin()); } +/

    QLatin1String mid(int pos) const
    { return (){(){ (mixin(Q_ASSERT(q{pos >= 0})));
return /+ Q_ASSERT(pos <= size()) +/ mixin(Q_ASSERT(q{pos <= QLatin1String.size()}));
}();
return QLatin1String(m_data + pos, m_size - pos);
}(); }
    QLatin1String mid(int pos, int n) const
    { return (){(){(){ (mixin(Q_ASSERT(q{pos >= 0})));
return /+ Q_ASSERT(n >= 0) +/ mixin(Q_ASSERT(q{n >= 0}));
}();
return /+ Q_ASSERT(pos + n <= size()) +/ mixin(Q_ASSERT(q{pos + n <= QLatin1String.size()}));
}();
return QLatin1String(m_data + pos, n);
}(); }
    QLatin1String left(int n) const
    { return (){(){ (mixin(Q_ASSERT(q{n >= 0})));
return /+ Q_ASSERT(n <= size()) +/ mixin(Q_ASSERT(q{n <= QLatin1String.size()}));
}();
return QLatin1String(m_data, n);
}(); }
    QLatin1String right(int n) const
    { return (){(){ (mixin(Q_ASSERT(q{n >= 0})));
return /+ Q_ASSERT(n <= size()) +/ mixin(Q_ASSERT(q{n <= QLatin1String.size()}));
}();
return QLatin1String(m_data + m_size - n, n);
}(); }
    /+ Q_REQUIRED_RESULT +/ QLatin1String chopped(int n) const
    { return (){(){ (mixin(Q_ASSERT(q{n >= 0})));
return /+ Q_ASSERT(n <= size()) +/ mixin(Q_ASSERT(q{n <= QLatin1String.size()}));
}();
return QLatin1String(m_data, m_size - n);
}(); }

    void chop(int n)
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QLatin1String.size()}))); m_size -= n; }
    void truncate(int n)
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QLatin1String.size()}))); m_size = n; }

    /+ Q_REQUIRED_RESULT +/ QLatin1String trimmed() const/+ noexcept+/ {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.trimmed(this);
    }

    /+pragma(inline, true) bool operator ==(ref const(QString) s) const/+ noexcept+/
    { return s == this; }+/
    /+pragma(inline, true) bool operator !=(ref const(QString) s) const/+ noexcept+/
    { return s != this; }+/
    /+pragma(inline, true) bool operator >(ref const(QString) s) const/+ noexcept+/
    { return s < this; }+/
    /+pragma(inline, true) bool operator <(ref const(QString) s) const/+ noexcept+/
    { return s > this; }+/
    /+pragma(inline, true) bool operator >=(ref const(QString) s) const/+ noexcept+/
    { return s <= this; }+/
    /+pragma(inline, true) bool operator <=(ref const(QString) s) const/+ noexcept+/
    { return s >= this; }+/

/+ #if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
    inline QT_ASCII_CAST_WARN bool operator==(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator!=(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator<(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator>(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator<=(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator>=(const char *s) const;

    inline QT_ASCII_CAST_WARN bool operator==(const QByteArray &s) const;
    inline QT_ASCII_CAST_WARN bool operator!=(const QByteArray &s) const;
    inline QT_ASCII_CAST_WARN bool operator<(const QByteArray &s) const;
    inline QT_ASCII_CAST_WARN bool operator>(const QByteArray &s) const;
    inline QT_ASCII_CAST_WARN bool operator<=(const QByteArray &s) const;
    inline QT_ASCII_CAST_WARN bool operator>=(const QByteArray &s) const;
#endif +/ // !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)

private:
    int m_size = 0;
    const(char)* m_data = null;
}
/+ Q_DECLARE_TYPEINFO(QLatin1String, Q_MOVABLE_TYPE);

// Qt 4.x compatibility
#if QT_DEPRECATED_SINCE(5, 14) +/
/+ QT_DEPRECATED_X("Use QLatin1String") +/
alias QLatin1Literal = QLatin1String;
/+ #endif +/

//
// QLatin1String inline implementations
//
bool isLatin1(QLatin1String)/+ noexcept+/
{ return true; }
static if(!versionIsSet!("QT_COMPILING_QSTRING_COMPAT_CPP") && defined!"Q_COMPILER_REF_QUALIFIERS")
{
/+ #    define Q_REQUIRED_RESULT
#    define Q_REQUIRED_RESULT_pushed +/
}

/// Binding for C++ class [QString](https://doc.qt.io/qt-5/qstring.html).
@Q_MOVABLE_TYPE @(QMetaType.Type.QString) extern(C++, class) struct /+ Q_CORE_EXPORT +/ QString
{
public:
    static import qt.core.stringalgorithms;
    static import qt.core.namespace;
    alias Data = QStringData;

    version(Windows)
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

    /+ explicit +/this(const(QChar)* unicode, int size = -1);
    this(QChar c);
    this(int size, QChar c);

    extern(D) this(const(wchar)[] unicode)
    {
        this(cast(const(QChar)*) unicode.ptr, cast(int)unicode.length);
    }

    extern(D) this(const(char)[] unicode)
    {
        QString s = fromUtf8_helper(unicode.ptr, cast(int)unicode.length);
        this.d = s.d;
        s.d = Data.sharedNull();
    }

    extern(D) this(const(dchar)[] unicode)
    {
        QString s = fromUcs4(unicode.ptr, cast(int)unicode.length);
        this.d = s.d;
        s.d = Data.sharedNull();
    }

    //
    // QString inline members
    //
    pragma(inline, true) this(QLatin1String aLatin1)
    {
        this.d = fromLatin1_helper(aLatin1.latin1(), aLatin1.size());
    }
    this(this)
    {
        d.ref_.ref_();
    }
    pragma(inline, true) ~this() { if (!d.ref_.deref()) Data.deallocate(d); }
    /+ref QString operator =(QChar c);+/
    /+ref QString operator =(ref const(QString) )/+ noexcept+/;+/
    /+ref QString operator =(QLatin1String latin1);+/
    /+ inline QString(QString && other) noexcept : d(other.d) { other.d = Data::sharedNull(); } +/
    /+ inline QString &operator=(QString &&other) noexcept
    { qSwap(d, other.d); return *this; } +/
    /+ inline void swap(QString &other) noexcept { qSwap(d, other.d); } +/
    pragma(inline, true) int size() const { return d.base0.size; }
    pragma(inline, true) int count() const { return d.base0.size; }
    pragma(inline, true) int length() const
    { return d.size; }
    pragma(inline, true) bool isEmpty() const
    { return d.size == 0; }
    void resize(int size);
    void resize(int size, QChar fillChar);

    ref QString fill(QChar c, int size = -1);
    void truncate(int pos);
    void chop(int n);

    pragma(inline, true) int capacity() const
    { return d.alloc ? d.alloc - 1 : 0; }
    pragma(inline, true) void reserve(int asize)
    {
        if (d.ref_.isShared() || uint(asize) >= d.alloc)
            reallocData(qMax(asize, d.size) + 1u);

        if (!d.capacityReserved) {
            // cannot set unconditionally, since d could be the shared_null/shared_empty (which is const)
            d.capacityReserved = true;
        }
    }
    pragma(inline, true) void squeeze()
    {
        if (d.ref_.isShared() || uint(d.size) + 1u < d.alloc)
            reallocData(uint(d.size) + 1u);

        if (d.capacityReserved) {
            // cannot set unconditionally, since d could be shared_null or
            // otherwise static.
            d.capacityReserved = false;
        }
    }

    pragma(inline, true) const(QChar)* unicode() const
    { return reinterpret_cast!(const(QChar)*)(d.data()); }
    pragma(inline, true) QChar* data()
    { detach(); return reinterpret_cast!(QChar*)(d.data()); }
    pragma(inline, true) const(QChar)* data() const
    { return reinterpret_cast!(const(QChar)*)(d.data()); }
    pragma(inline, true) const(QChar)* constData() const
    { return reinterpret_cast!(const(QChar)*)(d.data()); }

    extern(D) const(wchar)[] toConstWString()
    {
        return (cast(const(wchar)*)constData())[0..length];
    }

    pragma(inline, true) void detach()
    { if (d.ref_.isShared() || (d.offset != QStringData.sizeof)) reallocData(uint(d.size) + 1u); }
    pragma(inline, true) bool isDetached() const
    { return !d.ref_.isShared(); }
    pragma(inline, true) bool isSharedWith(ref const(QString) other) const { return d == other.d; }
    pragma(inline, true) void clear()
    { if (!isNull()) this = QString.create(); }

    pragma(inline, true) const(QChar) at(int i) const
    { (mixin(Q_ASSERT(q{uint(i) < uint(QString.size())}))); return QChar(d.data()[i]); }
    pragma(inline, true) const(QChar) opIndex(int i) const
    { (mixin(Q_ASSERT(q{uint(i) < uint(QString.size())}))); return QChar(d.data()[i]); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QCharRef opIndex(int i)
    { (mixin(Q_ASSERT(q{i >= 0}))); detach(); return QCharRef(this, i); }
    pragma(inline, true) const(QChar) opIndex(uint i) const
    { (mixin(Q_ASSERT(q{i < uint(QString.size())}))); return QChar(d.data()[i]); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QCharRef opIndex(uint i)
    {  detach(); return QCharRef(this, i); }

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QChar front() const { return at(0); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QCharRef front() { return opIndex(0); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QChar back() const { return at(size() - 1); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QCharRef back() { return opIndex(size() - 1); }

    /+ Q_REQUIRED_RESULT +/ QString arg(qlonglong a, int fieldwidth=0, int base=10,
                    QChar fillChar = QChar(QLatin1Char(' '))) const;
    /+ Q_REQUIRED_RESULT +/ QString arg(qulonglong a, int fieldwidth=0, int base=10,
                    QChar fillChar = QLatin1Char(' ')) const;
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(cpp_long a, int fieldWidth=0, int base=10,
                    QChar fillChar = QLatin1Char(' ')) const
    { return arg(qlonglong(a), fieldWidth, base, fillChar); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(cpp_ulong a, int fieldWidth=0, int base=10,
                    QChar fillChar = QLatin1Char(' ')) const
    { return arg(qulonglong(a), fieldWidth, base, fillChar); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(int a, int fieldWidth = 0, int base = 10,
                    QChar fillChar = QLatin1Char(' ')) const
    { return arg(qlonglong(a), fieldWidth, base, fillChar); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(uint a, int fieldWidth = 0, int base = 10,
                    QChar fillChar = QLatin1Char(' ')) const
    { return arg(qulonglong(a), fieldWidth, base, fillChar); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(short a, int fieldWidth = 0, int base = 10,
                    QChar fillChar = QLatin1Char(' ')) const
    { return arg(qlonglong(a), fieldWidth, base, fillChar); }
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(ushort a, int fieldWidth = 0, int base = 10,
                    QChar fillChar = QLatin1Char(' ')) const
    { return arg(qulonglong(a), fieldWidth, base, fillChar); }
    /+ Q_REQUIRED_RESULT +/ QString arg(double a, int fieldWidth = 0, char fmt = 'g', int prec = -1,
                    QChar fillChar = QLatin1Char(' ')) const;
    /+ Q_REQUIRED_RESULT +/ QString arg(char a, int fieldWidth = 0,
                    QChar fillChar = QLatin1Char(' ')) const;
    /+ Q_REQUIRED_RESULT +/ QString arg(QChar a, int fieldWidth = 0,
                    QChar fillChar = QLatin1Char(' ')) const;
    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        /+ Q_REQUIRED_RESULT +/ QString arg(ref const(QString) a, int fieldWidth = 0,
                        QChar fillChar = QLatin1Char(' ')) const;
    }
    /+ Q_REQUIRED_RESULT +/ QString arg(QStringView a, int fieldWidth = 0,
                    QChar fillChar = QLatin1Char(' ')) const;
    /+ Q_REQUIRED_RESULT +/ QString arg(QLatin1String a, int fieldWidth = 0,
                    QChar fillChar = QLatin1Char(' ')) const;
    static if(QT_STRINGVIEW_LEVEL < 2)
    {
/+        /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(ref const(QString) a1, ref const(QString) a2) const
        { return qToStringViewIgnoringNull(this).arg(a1, a2); }
        /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(ref const(QString) a1, ref const(QString) a2, ref const(QString) a3) const
        { return qToStringViewIgnoringNull(this).arg(a1, a2, a3); }
        /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(ref const(QString) a1, ref const(QString) a2, ref const(QString) a3,
                        ref const(QString) a4) const
        { return qToStringViewIgnoringNull(this).arg(a1, a2, a3, a4); }
        /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(ref const(QString) a1, ref const(QString) a2, ref const(QString) a3,
                        ref const(QString) a4, ref const(QString) a5) const
        { return qToStringViewIgnoringNull(this).arg(a1, a2, a3, a4, a5); }
        /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(ref const(QString) a1, ref const(QString) a2, ref const(QString) a3,
                        ref const(QString) a4, ref const(QString) a5, ref const(QString) a6) const
        { return qToStringViewIgnoringNull(this).arg(a1, a2, a3, a4, a5, a6); }
        /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(ref const(QString) a1, ref const(QString) a2, ref const(QString) a3,
                        ref const(QString) a4, ref const(QString) a5, ref const(QString) a6,
                        ref const(QString) a7) const
        { return qToStringViewIgnoringNull(this).arg(a1, a2, a3, a4, a5, a6, a7); }
        /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(ref const(QString) a1, ref const(QString) a2, ref const(QString) a3,
                        ref const(QString) a4, ref const(QString) a5, ref const(QString) a6,
                        ref const(QString) a7, ref const(QString) a8) const
        { return qToStringViewIgnoringNull(this).arg(a1, a2, a3, a4, a5, a6, a7, a8); }
        /+ Q_REQUIRED_RESULT +/ pragma(inline, true) QString arg(ref const(QString) a1, ref const(QString) a2, ref const(QString) a3,
                        ref const(QString) a4, ref const(QString) a5, ref const(QString) a6,
                        ref const(QString) a7, ref const(QString) a8, ref const(QString) a9) const
        { return qToStringViewIgnoringNull(this).arg(a1, a2, a3, a4, a5, a6, a7, a8, a9); }
+/
    }
private:
    /+ template <typename T> +/
    /+ struct is_convertible_to_view_or_qstring_helper
        : std::integral_constant<bool,
            std::is_convertible<T, QString>::value ||
            std::is_convertible<T, QStringView>::value ||
            std::is_convertible<T, QLatin1String>::value> {}; +/
    /+ template <typename T> +/
    /+ struct is_convertible_to_view_or_qstring
        : is_convertible_to_view_or_qstring_helper<typename std::decay<T>::type> {}; +/
public:
    /+ template <typename...Args> +/
    /+ Q_REQUIRED_RESULT
#ifdef Q_CLANG_QDOC
    QString
#else
    typename std::enable_if<
        sizeof...(Args) >= 2 && std::is_same<
            QtPrivate::BoolList<is_convertible_to_view_or_qstring<Args>::value..., true>,
            QtPrivate::BoolList<true, is_convertible_to_view_or_qstring<Args>::value...>
        >::value,
        QString
    >::type
#endif
    arg(Args &&...args) const
    { return qToStringViewIgnoringNull(*this).arg(std::forward<Args>(args)...); } +/

/+ #if QT_DEPRECATED_SINCE(5, 14) +/
    /+ QT_DEPRECATED_X("Use vasprintf(), arg() or QTextStream instead")
    QString &vsprintf(const char *format, va_list ap) Q_ATTRIBUTE_FORMAT_PRINTF(2, 0); +/
    /+ QT_DEPRECATED_X("Use asprintf(), arg() or QTextStream instead") +/
        ref QString sprintf(const(char)* format, ...) /+ Q_ATTRIBUTE_FORMAT_PRINTF(2, 3) +/;
/+ #endif +/
    static QString vasprintf(const(char)* format, va_list ap) /+ Q_ATTRIBUTE_FORMAT_PRINTF(1, 0) +/;
    static QString asprintf(const(char)* format, ...) /+ Q_ATTRIBUTE_FORMAT_PRINTF(1, 2) +/;

    int indexOf(QChar c, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    int indexOf(QLatin1String s, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        int indexOf(ref const(QString) s, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
        int indexOf(ref const(QStringRef) s, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    }
    /+ Q_REQUIRED_RESULT +/ int indexOf(QStringView s, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return cast(int)(/+ QtPrivate:: +/qt.core.stringalgorithms.findString(QStringView(this), from, s, cs));
    } // ### Qt6: qsizetype
    int lastIndexOf(QChar c, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    int lastIndexOf(QLatin1String s, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        int lastIndexOf(ref const(QString) s, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
        int lastIndexOf(ref const(QStringRef) s, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    }

    /+ Q_REQUIRED_RESULT +/ int lastIndexOf(QStringView s, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return cast(int)(/+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(QStringView(this), from, s, cs));
    } // ### Qt6: qsizetype

    pragma(inline, true) bool contains(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    { return indexOf(c, 0, cs) != -1; }
    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        pragma(inline, true) bool contains(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
        { return indexOf(s, 0, cs) != -1; }
        pragma(inline, true) bool contains(ref const(QStringRef) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
        { return indexOf(s, 0, cs) != -1; }
    }
    pragma(inline, true) bool contains(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    { return indexOf(s, 0, cs) != -1; }
    pragma(inline, true) bool contains(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(s, 0, cs) != -1; }
    int count(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    int count(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    int count(ref const(QStringRef) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;

/+ #ifndef QT_NO_REGEXP +/
    version(QT_NO_REGEXP){}else
    {
        int indexOf(ref const(QRegExp) , int from = 0) const;
        int lastIndexOf(ref const(QRegExp) , int from = -1) const;
        pragma(inline, true) bool contains(ref const(QRegExp) rx) const { return indexOf(rx) != -1; }
        int count(ref const(QRegExp) ) const;

        int indexOf(ref QRegExp , int from = 0) const;
        int lastIndexOf(ref QRegExp , int from = -1) const;
        pragma(inline, true) bool contains(ref QRegExp rx) const { return indexOf(rx) != -1; }
    }
/+ #endif

#if QT_CONFIG(regularexpression) +/
    int indexOf(ref const(QRegularExpression) re, int from = 0) const;
    int indexOf(ref const(QRegularExpression) re, int from, QRegularExpressionMatch* rmatch) const; // ### Qt 6: merge overloads
    int lastIndexOf(ref const(QRegularExpression) re, int from = -1) const;
    int lastIndexOf(ref const(QRegularExpression) re, int from, QRegularExpressionMatch* rmatch) const; // ### Qt 6: merge overloads
    bool contains(ref const(QRegularExpression) re) const;
    bool contains(ref const(QRegularExpression) re, QRegularExpressionMatch* rmatch) const; // ### Qt 6: merge overloads
    int count(ref const(QRegularExpression) re) const;
/+ #endif +/

    enum SectionFlag {
        SectionDefault             = 0x00,
        SectionSkipEmpty           = 0x01,
        SectionIncludeLeadingSep   = 0x02,
        SectionIncludeTrailingSep  = 0x04,
        SectionCaseInsensitiveSeps = 0x08
    }
    /+ Q_DECLARE_FLAGS(SectionFlags, SectionFlag) +/
alias SectionFlags = QFlags!(SectionFlag);
    pragma(inline, true) QString section(QChar asep, int astart, int aend = -1, SectionFlags aflags = SectionFlag.SectionDefault) const
    { auto tmp = QString(asep); return section(tmp, astart, aend, aflags); }
    QString section(ref const(QString) in_sep, int start, int end = -1, SectionFlags flags = SectionFlag.SectionDefault) const;
/+ #ifndef QT_NO_REGEXP +/
    version(QT_NO_REGEXP){}else
    {
        QString section(ref const(QRegExp) reg, int start, int end = -1, SectionFlags flags = SectionFlag.SectionDefault) const;
    }
/+ #endif
#if QT_CONFIG(regularexpression) +/
    QString section(ref const(QRegularExpression) re, int start, int end = -1, SectionFlags flags = SectionFlag.SectionDefault) const;
/+ #endif +/
    /+ Q_REQUIRED_RESULT +/ QString left(int n) const;
    /+ Q_REQUIRED_RESULT +/ QString right(int n) const;
    /+ Q_REQUIRED_RESULT +/ QString mid(int position, int n = -1) const;
    /+ Q_REQUIRED_RESULT +/ QString chopped(int n) const
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QString.size()}))); return left(size() - n); }


    /+ Q_REQUIRED_RESULT +/ QStringRef leftRef(int n) const;
    /+ Q_REQUIRED_RESULT +/ QStringRef rightRef(int n) const;
    /+ Q_REQUIRED_RESULT +/ QStringRef midRef(int position, int n = -1) const;

    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        bool startsWith(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
        bool startsWith(ref const(QStringRef) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    }
    /+ Q_REQUIRED_RESULT +/ bool startsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(QStringView(this), s, cs);
    }
    bool startsWith(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    bool startsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;

    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        bool endsWith(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
        bool endsWith(ref const(QStringRef) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    }
    /+ Q_REQUIRED_RESULT +/ bool endsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(QStringView(this), s, cs);
    }
    bool endsWith(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    bool endsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;

    bool isUpper() const;
    bool isLower() const;

    /+ Q_REQUIRED_RESULT +/ QString leftJustified(int width, QChar fill = QChar(QLatin1Char(' ')), bool trunc = false) const;
    /+ Q_REQUIRED_RESULT +/ QString rightJustified(int width, QChar fill = QChar(QLatin1Char(' ')), bool trunc = false) const;

/+ #if defined(Q_COMPILER_REF_QUALIFIERS) && !defined(QT_COMPILING_QSTRING_COMPAT_CPP) && !defined(Q_CLANG_QDOC)
#  if defined(Q_CC_GNU) && !defined(Q_CC_CLANG) && !defined(Q_CC_INTEL) && !__has_cpp_attribute(nodiscard)
    // required due to https://gcc.gnu.org/bugzilla/show_bug.cgi?id=61941
#    pragma push_macro("Q_REQUIRED_RESULT")
#    undef Q_REQUIRED_RESULT
#    define Q_REQUIRED_RESULT
#    define Q_REQUIRED_RESULT_pushed
#  endif
    Q_REQUIRED_RESULT +/ 
    static if((!versionIsSet!("QT_COMPILING_QSTRING_COMPAT_CPP") && defined!"Q_COMPILER_REF_QUALIFIERS"))
    {
        QString toLower() const/+ &+/
        { return toLower_helper(this); }
        /+ Q_REQUIRED_RESULT +/ QString toLower()/+ &&+/
        { return toLower_helper(this); }
        /+ Q_REQUIRED_RESULT +/ QString toUpper() const/+ &+/
        { return toUpper_helper(this); }
        /+ Q_REQUIRED_RESULT +/ QString toUpper()/+ &&+/
        { return toUpper_helper(this); }
        /+ Q_REQUIRED_RESULT +/ QString toCaseFolded() const/+ &+/
        { return toCaseFolded_helper(this); }
        /+ Q_REQUIRED_RESULT +/ QString toCaseFolded()/+ &&+/
        { return toCaseFolded_helper(this); }
        /+ Q_REQUIRED_RESULT +/ QString trimmed() const/+ &+/
        { return trimmed_helper(this); }
        /+ Q_REQUIRED_RESULT +/ QString trimmed()/+ &&+/
        { return trimmed_helper(this); }
        /+ Q_REQUIRED_RESULT +/ QString simplified() const/+ &+/
        { return simplified_helper(this); }
        /+ Q_REQUIRED_RESULT +/ QString simplified()/+ &&+/
        { return simplified_helper(this); }
    }
    else
    {
    /+ #  ifdef Q_REQUIRED_RESULT_pushed
    #    pragma pop_macro("Q_REQUIRED_RESULT")
    #  endif
    #else +/
        /+ Q_REQUIRED_RESULT +/ QString toLower() const;
        /+ Q_REQUIRED_RESULT +/ QString toUpper() const;
        /+ Q_REQUIRED_RESULT +/ QString toCaseFolded() const;
        /+ Q_REQUIRED_RESULT +/ QString trimmed() const;
        /+ Q_REQUIRED_RESULT +/ QString simplified() const;
    }
/+ #endif +/
    /+ Q_REQUIRED_RESULT +/ QString toHtmlEscaped() const;

    ref QString insert(int i, QChar c);
    ref QString insert(int i, const(QChar)* uc, int len);
    pragma(inline, true) ref QString insert(int i, ref const(QString) s) { return insert(i, s.constData(), s.length()); }
    pragma(inline, true) ref QString insert(int i, ref const(QStringRef) s)
    { return insert(i, s.constData(), s.length()); }
    pragma(inline, true) ref QString insert(int i, QStringView s)
    { return insert(i, s.data(), s.length()); }
    ref QString insert(int i, QLatin1String s);
    ref QString append(QChar c);
    ref QString append(const(QChar)* uc, int len);
    ref QString append(ref const(QString) s);
    ref QString append(ref const(QStringRef) s);
    ref QString append(QLatin1String s);
    pragma(inline, true) ref QString append(QStringView s) { return append(s.data(), s.length()); }
    pragma(inline, true) ref QString prepend(QChar c) { return insert(0, c); }
    pragma(inline, true) ref QString prepend(const(QChar)* uc, int len) { return insert(0, uc, len); }
    pragma(inline, true) ref QString prepend(ref const(QString) s) { return insert(0, s); }
    pragma(inline, true) ref QString prepend(ref const(QStringRef) s) { return insert(0, s); }
    pragma(inline, true) ref QString prepend(QLatin1String s) { return insert(0, s); }
    pragma(inline, true) ref QString prepend(QStringView s) { return insert(0, s); }

    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(QChar c) if(op == "~") {
        if (d.ref_.isShared() || uint(d.size) + 2u > d.alloc)
            reallocData(uint(d.size) + 2u, true);
        d.data()[d.size++] = c.unicode();
        d.data()[d.size] = '\0';
        return this;
    }

    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(QChar.SpecialCharacter c) if(op == "~") { return append(QChar(c)); }
    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(ref const(QString) s) if(op == "~") { return append(s); }
    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(const QString s) if(op == "~") { return append(s); }
    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(ref const(QStringRef) s) if(op == "~") { return append(s); }
    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(QLatin1String s) if(op == "~") { return append(s); }
    extern(D) pragma(inline, true) ref QString opOpAssign(string op)(QStringView s) if(op == "~") { return append(s); }

    ref QString remove(int i, int len);
    ref QString remove(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString remove(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString remove(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(int i, int len, QChar after);
    ref QString replace(int i, int len, const(QChar)* s, int slen);
    ref QString replace(int i, int len, ref const(QString) after);
    ref QString replace(QChar before, QChar after, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(const(QChar)* before, int blen, const(QChar)* after, int alen, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(QLatin1String before, QLatin1String after, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(QLatin1String before, ref const(QString) after, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(ref const(QString) before, QLatin1String after, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(ref const(QString) before, ref const(QString) after,
                         /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(QChar c, ref const(QString) after, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    ref QString replace(QChar c, QLatin1String after, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
/+ #ifndef QT_NO_REGEXP +/
    version(QT_NO_REGEXP){}else
    {
        ref QString replace(ref const(QRegExp) rx, ref const(QString) after);
        /+pragma(inline, true) ref QString remove(ref const(QRegExp) rx)
        { auto tmp = QString(); return replace(rx, tmp); }+/
    }
/+ #endif
#if QT_CONFIG(regularexpression) +/
    ref QString replace(ref const(QRegularExpression) re, ref const(QString)  after);
    pragma(inline, true) ref QString remove(ref const(QRegularExpression) re)
    { auto tmp = QString.create(); return replace(re, tmp); }
/+ #endif

#if QT_DEPRECATED_SINCE(5, 15) +/
    enum SplitBehavior // ### Qt 6: replace with Qt:: version
    {
        KeepEmptyParts /+ Q_DECL_ENUMERATOR_DEPRECATED +/,
        SkipEmptyParts /+ Q_DECL_ENUMERATOR_DEPRECATED +/
    }

    /+ Q_REQUIRED_RESULT +/ /+ QT_DEPRECATED_VERSION_X_5_15("Use Qt::SplitBehavior variant instead") +/
        QStringList split(ref const(QString) sep, SplitBehavior behavior,
                                            /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ Q_REQUIRED_RESULT +/ /+ QT_DEPRECATED_VERSION_X_5_15("Use Qt::SplitBehavior variant instead") +/
        QVector!(QStringRef) splitRef(ref const(QString) sep, SplitBehavior behavior,
                                                       /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ Q_REQUIRED_RESULT +/ /+ QT_DEPRECATED_VERSION_X_5_15("Use Qt::SplitBehavior variant instead") +/
        QStringList split(QChar sep, SplitBehavior behavior,
                                            /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ Q_REQUIRED_RESULT +/ /+ QT_DEPRECATED_VERSION_X_5_15("Use Qt::SplitBehavior variant instead") +/
        QVector!(QStringRef) splitRef(QChar sep, SplitBehavior behavior,
                                                       /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
/+ #ifndef QT_NO_REGEXP +/
    version(QT_NO_REGEXP){}else
    {
        /+ Q_REQUIRED_RESULT +/ /+ QT_DEPRECATED_VERSION_X_5_15("Use Qt::SplitBehavior variant instead") +/
            QStringList split(ref const(QRegExp) sep, SplitBehavior behavior) const;
        /+ Q_REQUIRED_RESULT +/ /+ QT_DEPRECATED_VERSION_X_5_15("Use Qt::SplitBehavior variant instead") +/
            QVector!(QStringRef) splitRef(ref const(QRegExp) sep, SplitBehavior behavior) const;
    }
/+ #endif
#if QT_CONFIG(regularexpression) +/
    /+ Q_REQUIRED_RESULT +/ /+ QT_DEPRECATED_VERSION_X_5_15("Use Qt::SplitBehavior variant instead") +/
        QStringList split(ref const(QRegularExpression) sep, SplitBehavior behavior) const;
    /+ Q_REQUIRED_RESULT +/ /+ QT_DEPRECATED_VERSION_X_5_15("Use Qt::SplitBehavior variant instead") +/
        QVector!(QStringRef) splitRef(ref const(QRegularExpression) sep, SplitBehavior behavior) const;
/+ #endif
#endif +/ // 5.15 deprecations

public:
    /+ Q_REQUIRED_RESULT +/
        QStringList split(ref const(QString) sep, /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts,
                          /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ Q_REQUIRED_RESULT +/
        QVector!(QStringRef) splitRef(ref const(QString) sep,
                                     /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts,
                                     /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ Q_REQUIRED_RESULT +/
        QStringList split(QChar sep, /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts,
                          /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ Q_REQUIRED_RESULT +/
        QVector!(QStringRef) splitRef(QChar sep, /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts,
                                     /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
/+ #ifndef QT_NO_REGEXP +/
    version(QT_NO_REGEXP){}else
    {
        /+ Q_REQUIRED_RESULT +/
            QStringList split(ref const(QRegExp) sep,
                              /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts) const;
        /+ Q_REQUIRED_RESULT +/
            QVector!(QStringRef) splitRef(ref const(QRegExp) sep,
                                         /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts) const;
    }
/+ #endif
#ifndef QT_NO_REGULAREXPRESSION +/
    version(QT_NO_REGULAREXPRESSION){}else
    {
        /+ Q_REQUIRED_RESULT +/
            QStringList split(ref const(QRegularExpression) sep,
                              /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts) const;
        /+ Q_REQUIRED_RESULT +/
            QVector!(QStringRef) splitRef(ref const(QRegularExpression) sep,
                                         /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts) const;
    }
/+ #endif +/


    enum NormalizationForm {
        NormalizationForm_D,
        NormalizationForm_C,
        NormalizationForm_KD,
        NormalizationForm_KC
    }
    /+ Q_REQUIRED_RESULT +/ QString normalized(NormalizationForm mode, QChar.UnicodeVersion version_ = QChar.UnicodeVersion.Unicode_Unassigned) const;

    /+ Q_REQUIRED_RESULT +/ QString repeated(int times) const;

    const(ushort)* utf16() const;


    static if((!versionIsSet!("QT_COMPILING_QSTRING_COMPAT_CPP") && defined!"Q_COMPILER_REF_QUALIFIERS"))
    {
        /+ Q_REQUIRED_RESULT +/ QByteArray toLatin1() const/+ &+/
        { return toLatin1_helper(this); }
        /+ Q_REQUIRED_RESULT +/ QByteArray toLatin1()/+ &&+/
        { return toLatin1_helper_inplace(this); }
        /+ Q_REQUIRED_RESULT +/ QByteArray toUtf8() const/+ &+/
        { return toUtf8_helper(this); }
        /+ Q_REQUIRED_RESULT +/ QByteArray toUtf8()/+ &&+/
        { return toUtf8_helper(this); }
        /+ Q_REQUIRED_RESULT +/ QByteArray toLocal8Bit() const/+ &+/
        { return toLocal8Bit_helper(isNull() ? null : constData(), size()); }
        /+ Q_REQUIRED_RESULT +/ QByteArray toLocal8Bit()/+ &&+/
        { return toLocal8Bit_helper(isNull() ? null : constData(), size()); }
    }
    else
    {
        /+ Q_REQUIRED_RESULT +/ QByteArray toLatin1() const;
        /+ Q_REQUIRED_RESULT +/ QByteArray toUtf8() const;
        /+ Q_REQUIRED_RESULT +/ QByteArray toLocal8Bit() const;
    }
    /+ Q_REQUIRED_RESULT +/ QVector!(uint) toUcs4() const;

    // note - this are all inline so we can benefit from strlen() compile time optimizations
    pragma(inline, true) static QString fromLatin1(const(char)* str, int size = -1)
    {
        import core.stdc.string;

        QStringDataPtr dataPtr = QStringDataPtr( fromLatin1_helper(str, (str && size == -1) ? cast(int)(strlen(str)) : size)) ;
        return QString(dataPtr);
    }
    pragma(inline, true) static QString fromUtf8(const(char)* str, int size = -1)
    {
        import core.stdc.string;

        return fromUtf8_helper(str, (str && size == -1) ? cast(int)(strlen(str)) : size);
    }
    pragma(inline, true) static QString fromLocal8Bit(const(char)* str, int size = -1)
    {
        import core.stdc.string;

        return fromLocal8Bit_helper(str, (str && size == -1) ? cast(int)(strlen(str)) : size);
    }
    pragma(inline, true) static QString fromLatin1(ref const(QByteArray) str)
    { return str.isNull() ? QString.create() : fromLatin1(str.data(), qstrnlen(str.constData(), str.size())); }
    pragma(inline, true) static QString fromUtf8(ref const(QByteArray) str)
    { return str.isNull() ? QString.create() : fromUtf8(str.data(), qstrnlen(str.constData(), str.size())); }
    pragma(inline, true) static QString fromLocal8Bit(ref const(QByteArray) str)
    { return str.isNull() ? QString.create() : fromLocal8Bit(str.data(), qstrnlen(str.constData(), str.size())); }
    static QString fromUtf16(const(ushort)* , int size = -1);
    static QString fromUcs4(const(uint)* , int size = -1);
    static QString fromRawData(const(QChar)* , int size);

/+ #if defined(Q_COMPILER_UNICODE_STRINGS) +/
    static QString fromUtf16(const(wchar)* str, int size = -1)
    { return fromUtf16(reinterpret_cast!(const(ushort)*)(str), size); }
    static QString fromUcs4(const(dchar)* str, int size = -1)
    { return fromUcs4(reinterpret_cast!(const(uint)*)(str), size); }
/+ #endif

#if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED static inline QString fromAscii(const char *str, int size = -1)
    { return fromLatin1(str, size); }
    QT_DEPRECATED static inline QString fromAscii(const QByteArray &str)
    { return fromLatin1(str); }
    Q_REQUIRED_RESULT QByteArray toAscii() const
    { return toLatin1(); }
#endif +/

/+    pragma(inline, true) int toWCharArray(wchar_t* array) const
    {
        return qToStringViewIgnoringNull(this).toWCharArray(array);
    }+/
    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) static QString fromWCharArray(const(wchar_t)* string, int size = -1)
    {
        return wchar_t.sizeof == QChar.sizeof ? fromUtf16(reinterpret_cast!(const(ushort)*)(string), size)
                                                : fromUcs4(reinterpret_cast!(const(uint)*)(string), size);
    }

    ref QString setRawData(const(QChar)* unicode, int size);
    ref QString setUnicode(const(QChar)* unicode, int size);
    pragma(inline, true) ref QString setUtf16(const(ushort)* autf16, int asize)
    { return setUnicode(reinterpret_cast!(const(QChar)*)(autf16), asize); }

    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        int compare(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/;
        pragma(inline, true) int compare(ref const(QStringRef) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
        { return QString.compare_helper(constData(), length(), s.constData(), s.length(), cs); }
    }
    int compare(QLatin1String other, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/;
    pragma(inline, true) int compare(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return -s.compare(QStringView(this), cs); }
    int compare(QChar ch, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return compare(QStringView(&ch, 1), cs); }

    pragma(inline, true) static int compare(ref const(QString) s1, ref const(QString) s2,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/
    { return s1.compare(s2, cs); }

    pragma(inline, true) static int compare(ref const(QString) s1, QLatin1String s2,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/
    { return s1.compare(s2, cs); }
    pragma(inline, true) static int compare(QLatin1String s1, ref const(QString) s2,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/
    { return -s2.compare(s1, cs); }

    pragma(inline, true) static int compare(ref const(QString) s1, ref const(QStringRef) s2,
                           /+ Qt:: +/qt.core.namespace.CaseSensitivity cs /+ = Qt::CaseSensitive +/)/+ noexcept+/
    { return QString.compare_helper(s1.constData(), s1.length(), s2.constData(), s2.length(), cs); }

    int localeAwareCompare(ref const(QString) s) const;
    static int localeAwareCompare(ref const(QString) s1, ref const(QString) s2)
    { return s1.localeAwareCompare(s2); }

    pragma(inline, true) int localeAwareCompare(ref const(QStringRef) s) const
    { return localeAwareCompare_helper(constData(), length(), s.constData(), s.length()); }
    pragma(inline, true) static int localeAwareCompare(ref const(QString) s1, ref const(QStringRef) s2)
    { return localeAwareCompare_helper(s1.constData(), s1.length(), s2.constData(), s2.length()); }

    // ### Qt6: make inline except for the long long versions
    short  toShort(bool* ok=null, int base=10) const;
    ushort toUShort(bool* ok=null, int base=10) const;
    int toInt(bool* ok=null, int base=10) const;
    uint toUInt(bool* ok=null, int base=10) const;
    cpp_long toLong(bool* ok=null, int base=10) const;
    cpp_ulong toULong(bool* ok=null, int base=10) const;
    qlonglong toLongLong(bool* ok=null, int base=10) const;
    qulonglong toULongLong(bool* ok=null, int base=10) const;
    float toFloat(bool* ok=null) const;
    double toDouble(bool* ok=null) const;

    pragma(inline, true) ref QString setNum(short n, int base=10)
    { return setNum(qlonglong(n), base); }
    pragma(inline, true) ref QString setNum(ushort n, int base=10)
    { return setNum(qulonglong(n), base); }
    pragma(inline, true) ref QString setNum(int n, int base=10)
    { return setNum(qlonglong(n), base); }
    pragma(inline, true) ref QString setNum(uint n, int base=10)
    { return setNum(qulonglong(n), base); }
    pragma(inline, true) ref QString setNum(cpp_long n, int base=10)
    { return setNum(qlonglong(n), base); }
    pragma(inline, true) ref QString setNum(cpp_ulong n, int base=10)
    { return setNum(qulonglong(n), base); }
    ref QString setNum(qlonglong, int base=10);
    ref QString setNum(qulonglong, int base=10);
    pragma(inline, true) ref QString setNum(float n, char f='g', int prec=6)
    { return setNum(double(n),f,prec); }
    ref QString setNum(double, char f='g', int prec=6);

    static QString number(int, int base=10);
    static QString number(uint, int base=10);
    static QString number(cpp_long, int base=10);
    static QString number(cpp_ulong, int base=10);
    static QString number(qlonglong, int base=10);
    static QString number(qulonglong, int base=10);
    static QString number(double, char f='g', int prec=6);

    /+ friend Q_CORE_EXPORT bool operator==(const QString &s1, const QString &s2) noexcept; +/
    /+ friend Q_CORE_EXPORT bool operator<(const QString &s1, const QString &s2) noexcept; +/
    /+ friend inline bool operator>(const QString &s1, const QString &s2) noexcept { return s2 < s1; } +/
    /+ friend inline bool operator!=(const QString &s1, const QString &s2) noexcept { return !(s1 == s2); } +/
    /+ friend inline bool operator<=(const QString &s1, const QString &s2) noexcept { return !(s1 > s2); } +/
    /+ friend inline bool operator>=(const QString &s1, const QString &s2) noexcept { return !(s1 < s2); } +/

    /+bool operator ==(QLatin1String s) const/+ noexcept+/;+/
    /+bool operator <(QLatin1String s) const/+ noexcept+/;+/
    /+bool operator >(QLatin1String s) const/+ noexcept+/;+/
    /+pragma(inline, true) bool operator !=(QLatin1String s) const/+ noexcept+/ { return !operator==(s); }+/
    /+pragma(inline, true) bool operator <=(QLatin1String s) const/+ noexcept+/ { return !operator>(s); }+/
    /+pragma(inline, true) bool operator >=(QLatin1String s) const/+ noexcept+/ { return !operator<(s); }+/

    // ASCII compatibility
/+ #if defined(QT_RESTRICTED_CAST_FROM_ASCII) +/
    version(QT_RESTRICTED_CAST_FROM_ASCII)
    {
        /+ template <int N> +/
        /+ inline QString(const char (&ch)[N])
            : d(fromAscii_helper(ch, N - 1))
        {} +/
        /+ template <int N> +/
        /+ QString(char (&)[N]) = delete; +/
        /+ template <int N> +/
        /+ inline QString &operator=(const char (&ch)[N])
        { return (*this = fromUtf8(ch, N - 1)); } +/
        /+ template <int N> +/
        /+ QString &operator=(char (&)[N]) = delete; +/
    }
/+ #endif
#if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
    inline QT_ASCII_CAST_WARN QString(const char *ch)
        : d(fromAscii_helper(ch, ch ? int(strlen(ch)) : -1))
    {}
    inline QT_ASCII_CAST_WARN QString(const QByteArray &a)
        : d(fromAscii_helper(a.constData(), qstrnlen(a.constData(), a.size())))
    {}
    inline QT_ASCII_CAST_WARN QString &operator=(const char *ch)
    { return (*this = fromUtf8(ch)); }
    inline QT_ASCII_CAST_WARN QString &operator=(const QByteArray &a)
    { return (*this = fromUtf8(a)); }
    inline QT_ASCII_CAST_WARN QString &operator=(char c)
    { return (*this = QChar::fromLatin1(c)); }

    // these are needed, so it compiles with STL support enabled
    inline QT_ASCII_CAST_WARN QString &prepend(const char *s)
    { return prepend(QString::fromUtf8(s)); }
    inline QT_ASCII_CAST_WARN QString &prepend(const QByteArray &s)
    { return prepend(QString::fromUtf8(s)); }
    inline QT_ASCII_CAST_WARN QString &append(const char *s)
    { return append(QString::fromUtf8(s)); }
    inline QT_ASCII_CAST_WARN QString &append(const QByteArray &s)
    { return append(QString::fromUtf8(s)); }
    inline QT_ASCII_CAST_WARN QString &insert(int i, const char *s)
    { return insert(i, QString::fromUtf8(s)); }
    inline QT_ASCII_CAST_WARN QString &insert(int i, const QByteArray &s)
    { return insert(i, QString::fromUtf8(s)); }
    inline QT_ASCII_CAST_WARN QString &operator+=(const char *s)
    { return append(QString::fromUtf8(s)); }
    inline QT_ASCII_CAST_WARN QString &operator+=(const QByteArray &s)
    { return append(QString::fromUtf8(s)); }
    inline QT_ASCII_CAST_WARN QString &operator+=(char c)
    { return append(QChar::fromLatin1(c)); }

    inline QT_ASCII_CAST_WARN bool operator==(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator!=(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator<(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator<=(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator>(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator>=(const char *s) const;

    inline QT_ASCII_CAST_WARN bool operator==(const QByteArray &s) const;
    inline QT_ASCII_CAST_WARN bool operator!=(const QByteArray &s) const;
    inline QT_ASCII_CAST_WARN bool operator<(const QByteArray &s) const;
    inline QT_ASCII_CAST_WARN bool operator>(const QByteArray &s) const;
    inline QT_ASCII_CAST_WARN bool operator<=(const QByteArray &s) const;
    inline QT_ASCII_CAST_WARN bool operator>=(const QByteArray &s) const;

    friend inline QT_ASCII_CAST_WARN bool operator==(const char *s1, const QString &s2);
    friend inline QT_ASCII_CAST_WARN bool operator!=(const char *s1, const QString &s2);
    friend inline QT_ASCII_CAST_WARN bool operator<(const char *s1, const QString &s2);
    friend inline QT_ASCII_CAST_WARN bool operator>(const char *s1, const QString &s2);
    friend inline QT_ASCII_CAST_WARN bool operator<=(const char *s1, const QString &s2);
    friend inline QT_ASCII_CAST_WARN bool operator>=(const char *s1, const QString &s2);

    friend inline QT_ASCII_CAST_WARN bool operator==(const char *s1, const QStringRef &s2);
    friend inline QT_ASCII_CAST_WARN bool operator!=(const char *s1, const QStringRef &s2);
    friend inline QT_ASCII_CAST_WARN bool operator<(const char *s1, const QStringRef &s2);
    friend inline QT_ASCII_CAST_WARN bool operator>(const char *s1, const QStringRef &s2);
    friend inline QT_ASCII_CAST_WARN bool operator<=(const char *s1, const QStringRef &s2);
    friend inline QT_ASCII_CAST_WARN bool operator>=(const char *s1, const QStringRef &s2);
#endif +/

    /*extern(D) bool opEquals(const char *s) const
    {
        auto r = compare_helper(constData(), size(), s, -1);
        return r == 0;
    }*/
    extern(D) bool opEquals(const(char)[] s) const
    {
        auto r = compare_helper(constData(), size(), s.ptr, cast(int)s.length);
        return r == 0;
    }
    extern(D) bool opEquals(const(wchar)[] s) const
    {
        return (cast(wchar*)constData())[0..size()] == s;
    }
    extern(D) bool opEquals(const ref QString s) const
    {
        return compare_helper(constData(), size(), s.constData, s.size()) == 0;
    }

    alias iterator = QChar*;
    alias const_iterator = const(QChar)*;
    alias Iterator = iterator;
    alias ConstIterator = const_iterator;
    /+ typedef std::reverse_iterator<iterator> reverse_iterator; +/
    /+ typedef std::reverse_iterator<const_iterator> const_reverse_iterator; +/
    pragma(inline, true) iterator begin()
    /+pragma(inline, true) QString.iterator begin()+/
    { detach(); return reinterpret_cast!(QChar*)(d.data()); }
    pragma(inline, true) const_iterator begin() const
    /+pragma(inline, true) QString.const_iterator begin() const+/
    { return reinterpret_cast!(const(QChar)*)(d.data()); }
    pragma(inline, true) const_iterator cbegin() const
    /+pragma(inline, true) QString.const_iterator cbegin() const+/
    { return reinterpret_cast!(const(QChar)*)(d.data()); }
    pragma(inline, true) const_iterator constBegin() const
    /+pragma(inline, true) QString.const_iterator constBegin() const+/
    { return reinterpret_cast!(const(QChar)*)(d.data()); }
    pragma(inline, true) iterator end()
    /+pragma(inline, true) QString.iterator end()+/
    { detach(); return reinterpret_cast!(QChar*)(d.data() + d.size); }
    pragma(inline, true) const_iterator end() const
    /+pragma(inline, true) QString.const_iterator end() const+/
    { return reinterpret_cast!(const(QChar)*)(d.data() + d.size); }
    pragma(inline, true) const_iterator cend() const
    /+pragma(inline, true) QString.const_iterator cend() const+/
    { return reinterpret_cast!(const(QChar)*)(d.data() + d.size); }
    pragma(inline, true) const_iterator constEnd() const
    /+pragma(inline, true) QString.const_iterator constEnd() const+/
    { return reinterpret_cast!(const(QChar)*)(d.data() + d.size); }
    /+ reverse_iterator rbegin() { return reverse_iterator(end()); } +/
    /+ reverse_iterator rend() { return reverse_iterator(begin()); } +/
    /+ const_reverse_iterator rbegin() const { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator rend() const { return const_reverse_iterator(begin()); } +/
    /+ const_reverse_iterator crbegin() const { return const_reverse_iterator(end()); } +/
    /+ const_reverse_iterator crend() const { return const_reverse_iterator(begin()); } +/

    // STL compatibility
    alias size_type = int;
    alias difference_type = qptrdiff;
    /+ typedef const QChar & const_reference; +/
    /+ typedef QChar & reference; +/
    alias pointer = QChar*;
    alias const_pointer = const(QChar)*;
    alias value_type = QChar;
    pragma(inline, true) void push_back(QChar c) { append(c); }
    pragma(inline, true) void push_back(ref const(QString) s) { append(s); }
    pragma(inline, true) void push_front(QChar c) { prepend(c); }
    pragma(inline, true) void push_front(ref const(QString) s) { prepend(s); }
    void shrink_to_fit() { squeeze(); }

    /+ static inline QString fromStdString(const std::string &s); +/
    /+ inline std::string toStdString() const; +/
    /+ static inline QString fromStdWString(const std::wstring &s); +/
    /+ inline std::wstring toStdWString() const; +/

/+ #if defined(Q_STDLIB_UNICODE_STRINGS) || defined(Q_QDOC)
    static inline QString fromStdU16String(const std::u16string &s);
    inline std::u16string toStdU16String() const;
    static inline QString fromStdU32String(const std::u32string &s);
    inline std::u32string toStdU32String() const;
#endif

#if defined(Q_OS_DARWIN) || defined(Q_QDOC) +/
    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ static QString fromCFString(CFStringRef string); +/
        /+ CFStringRef toCFString() const Q_DECL_CF_RETURNS_RETAINED; +/
        /+ static QString fromNSString(const NSString *string); +/
        /+ NSString *toNSString() const Q_DECL_NS_RETURNS_AUTORELEASED; +/
    }
/+ #endif
    // compatibility
#if QT_DEPRECATED_SINCE(5, 9) +/
    struct Null { }
    /+ QT_DEPRECATED_X("use QString()") +/
        /+ extern static __gshared const(Null) null_; +/
    pragma(inline, true) this(ref const(Null) )
    {
        this.d = Data.sharedNull();
    }
    /+pragma(inline, true) ref QString operator =(ref const(Null) ) { this = QString(); return this; }+/
/+ #endif +/
    pragma(inline, true) bool isNull() const { return d == Data.sharedNull(); }


    bool isSimpleText() const;
    bool isRightToLeft() const;
    /+ Q_REQUIRED_RESULT +/ bool isValidUtf16() const/+ noexcept+/
    { return QStringView(this).isValidUtf16(); }

    this(int size, /+ Qt:: +/qt.core.namespace.Initialization);
    pragma(inline, true) this(QStringDataPtr dd)
    {
        this.d = dd.ptr;
    }

    extern(D) QString opBinary(string op)(const ref QString s2) const if(op == "~")
    {
        QString t = *cast(QString*)&this; t ~= s2; return t;
    }
    extern(D) QString opBinary(string op)(const QString s2) const if(op == "~")
    {
        QString t = *cast(QString*)&this; t ~= s2; return t;
    }
    extern(D) QString opBinary(string op)(const char *s2) const if(op == "~")
    {
        QString t = *cast(QString*)&this; auto tmp = QString.fromUtf8(s2); t ~= tmp; return t;
    }
    extern(D) QString opBinaryRight(string op)(const char *s1) const if(op == "~")
    {
        QString t = QString.fromUtf8(s1); t ~= this; return t;
    }

    pragma(inline, true) bool opEquals(QStringView rhs)/+ noexcept+/ {
        import qt.core.stringalgorithms;
        return this.size() == rhs.size() && /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(QStringView(this), rhs) == 0;
    }

    pragma(inline, true) bool opEquals(QLatin1String rhs)/+ noexcept+/ {
        import qt.core.stringalgorithms;
        return this.size() == rhs.size() && /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(QStringView(this), rhs) == 0;
    }


private:
/+ #if defined(QT_NO_CAST_FROM_ASCII) +/
    extern(D) ref QString opOpAssign(string op)(const(char)* s) if(op == "~");
    extern(D) ref QString opOpAssign(string op)(ref const(QByteArray) s) if(op == "~");
    //this(const(char)* ch);
    //this(ref const(QByteArray) a);
    /+ref QString operator =(const(char)*  ch);+/
    /+ref QString operator =(ref const(QByteArray) a);+/
/+ #endif +/

    version(Windows)
        Data* d;
    else
    {
        union
        {
            const(QArrayData)* d2 = QArrayData.shared_null.ptr;
            Data* d;
        }
    }

    /+ friend inline bool operator==(QChar, const QString &) noexcept; +/
    /+ friend inline bool operator< (QChar, const QString &) noexcept; +/
    /+ friend inline bool operator> (QChar, const QString &) noexcept; +/
    /+ friend inline bool operator==(QChar, const QStringRef &) noexcept; +/
    /+ friend inline bool operator< (QChar, const QStringRef &) noexcept; +/
    /+ friend inline bool operator> (QChar, const QStringRef &) noexcept; +/
    /+ friend inline bool operator==(QChar, QLatin1String) noexcept; +/
    /+ friend inline bool operator< (QChar, QLatin1String) noexcept; +/
    /+ friend inline bool operator> (QChar, QLatin1String) noexcept; +/

    void reallocData(uint alloc, bool grow = false);
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    void expand(int i);
    QString multiArg(int numArgs, const(QString)** args) const;
/+ #endif +/
    static int compare_helper(const(QChar)* data1, int length1,
                                  const(QChar)* data2, int length2,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
    static int compare_helper(const(QChar)* data1, int length1,
                                  const(char)* data2, int length2,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    static int compare_helper(const(QChar)* data1, int length1,
                                  QLatin1String s2,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/;
    static int localeAwareCompare_helper(const(QChar)* data1, int length1,
                                             const(QChar)* data2, int length2);
    static QString toLower_helper(ref const(QString) str);
    static QString toLower_helper(ref QString str);
    static QString toUpper_helper(ref const(QString) str);
    static QString toUpper_helper(ref QString str);
    static QString toCaseFolded_helper(ref const(QString) str);
    static QString toCaseFolded_helper(ref QString str);
    static QString trimmed_helper(ref const(QString) str);
    static QString trimmed_helper(ref QString str);
    static QString simplified_helper(ref const(QString) str);
    static QString simplified_helper(ref QString str);
    static Data* fromLatin1_helper(const(char)* str, int size = -1);
    static Data* fromAscii_helper(const(char)* str, int size = -1);
    static QString fromUtf8_helper(const(char)* str, int size);
    static QString fromLocal8Bit_helper(const(char)* , int size);
    static QByteArray toLatin1_helper(ref const(QString) );
    static QByteArray toLatin1_helper_inplace(ref QString );
    static QByteArray toUtf8_helper(ref const(QString) );
    static QByteArray toLocal8Bit_helper(const(QChar)* data, int size);
    static int toUcs4_helper(const(ushort)* uc, int length, uint* out_);
    static qlonglong toIntegral_helper(const(QChar)* data, int len, bool* ok, int base);
    static qulonglong toIntegral_helper(const(QChar)* data, uint len, bool* ok, int base);
    void replace_helper(uint* indices, int nIndices, int blen, const(QChar)* after, int alen);
    /+ friend class QCharRef; +/
    /+ friend class QTextCodec; +/
    /+ friend class QStringRef; +/
    /+ friend class QStringView; +/
    /+ friend class QByteArray; +/
    /+ friend class QCollator; +/
    /+ friend struct QAbstractConcatenable; +/

    /+ template <typename T> +/ /+ static
    T toIntegral_helper(const QChar *data, int len, bool *ok, int base)
    {
        using Int64 = typename std::conditional<std::is_unsigned<T>::value, qulonglong, qlonglong>::type;
        using Int32 = typename std::conditional<std::is_unsigned<T>::value, uint, int>::type;

        // we select the right overload by casting size() to int or uint
        Int64 val = toIntegral_helper(data, Int32(len), ok, base);
        if (T(val) != val) {
            if (ok)
                *ok = false;
            val = 0;
        }
        return T(val);
    } +/

public:
    alias DataPtr = Data*;
    pragma(inline, true) ref DataPtr data_ptr() return { return d; }
}
/+ #if QT_STRINGVIEW_LEVEL < 2
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_MSVC(4127)   // "conditional expression is constant"
QT_WARNING_DISABLE_INTEL(111)   // "statement is unreachable"

QT_WARNING_POP +/

@Q_MOVABLE_TYPE extern(C++, class) struct
/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
Q_CORE_EXPORT
#endif +/
QCharRef { // ### Qt 7: remove
private:
    QString *s;
    int i;
    pragma(inline, true) this(ref QString str, int idx)
    {
        this.s = &str;
        this.i = idx;
    }
    /+ friend class QString; +/
public:
    /+ QCharRef(const QCharRef &) = default; +/

    // most QChar operations repeated here

    // all this is not documented: We just say "like QChar" and let it be.
    //pragma(inline, true) auto opCast(T : QChar)() const
    pragma(inline, true) QChar toQChar() const
    {
        //using namespace /+ QtPrivate:: +/DeprecatedRefClassBehavior;
        if (/+ Q_LIKELY +/(i < s.d.size))
            return QChar(s.d.data()[i]);
        version(QT_DEBUG)
        {
//            warn(WarningType.OutOfRange, EmittingClass.QCharRef);
        }
        return QChar();
    }
    /+pragma(inline, true) ref QCharRef operator =(QChar c)
    {
        using namespace /+ QtPrivate:: +/DeprecatedRefClassBehavior;
        if (/+ Q_UNLIKELY +/(i >= s.d.size)) {
            version(QT_DEBUG)
            {
                warn(WarningType.OutOfRange, EmittingClass.QCharRef);
            }
            s.resize(i + 1, QLatin1Char(' '));
        } else {
            version(QT_DEBUG)
            {
                if (/+ Q_UNLIKELY +/(!s.isDetached()))
                    warn(WarningType.DelayedDetach, EmittingClass.QCharRef);
            }
            s.detach();
        }
        s.d.data()[i] = c.unicode();
        return this;
    }+/

    // An operator= for each QChar cast constructors
/+ #ifndef QT_NO_CAST_FROM_ASCII
    inline QT_ASCII_CAST_WARN QCharRef &operator=(char c)
    { return operator=(QChar::fromLatin1(c)); }
    inline QT_ASCII_CAST_WARN QCharRef &operator=(uchar c)
    { return operator=(QChar::fromLatin1(c)); }
#endif +/
    /+pragma(inline, true) ref QCharRef operator =(ref const(QCharRef) c) { return operator=(QChar(c)); }+/
    /+pragma(inline, true) ref QCharRef operator =(ushort rc) { return operator=(QChar(rc)); }+/
    /+pragma(inline, true) ref QCharRef operator =(short rc) { return operator=(QChar(rc)); }+/
    /+pragma(inline, true) ref QCharRef operator =(uint rc) { return operator=(QChar(rc)); }+/
    /+pragma(inline, true) ref QCharRef operator =(int rc) { return operator=(QChar(rc)); }+/

    // each function...
    /+pragma(inline, true) bool isNull() const { return this.toQChar.isNull(); }
    pragma(inline, true) bool isPrint() const { return this.toQChar.isPrint(); }
    pragma(inline, true) bool isPunct() const { return this.toQChar.isPunct(); }
    pragma(inline, true) bool isSpace() const { return this.toQChar.isSpace(); }
    pragma(inline, true) bool isMark() const { return this.toQChar.isMark(); }
    pragma(inline, true) bool isLetter() const { return this.toQChar.isLetter(); }
    pragma(inline, true) bool isNumber() const { return this.toQChar.isNumber(); }
    pragma(inline, true) bool isLetterOrNumber() { return this.toQChar.isLetterOrNumber(); }
    pragma(inline, true) bool isDigit() const { return this.toQChar.isDigit(); }
    pragma(inline, true) bool isLower() const { return this.toQChar.isLower(); }
    pragma(inline, true) bool isUpper() const { return this.toQChar.isUpper(); }
    pragma(inline, true) bool isTitleCase() const { return this.toQChar.isTitleCase(); }

    pragma(inline, true) int digitValue() const { return this.toQChar.digitValue(); }
    QChar toLower() const { return this.toQChar.toLower(); }
    QChar toUpper() const { return this.toQChar.toUpper(); }
    QChar toTitleCase () const { return this.toQChar.toTitleCase(); }

    QChar.Category category() const { return this.toQChar.category(); }
    QChar.Direction direction() const { return this.toQChar.direction(); }
    QChar.JoiningType joiningType() const { return this.toQChar.joiningType(); }
/+ #if QT_DEPRECATED_SINCE(5, 3) +/
    /+ QT_DEPRECATED +/ QChar.Joining joining() const
    {
        switch (this.toQChar.joiningType()) {
        case QChar.JoiningType.Joining_Causing: return QChar.Joining.Center;
        case QChar.JoiningType.Joining_Dual: return QChar.Joining.Dual;
        case QChar.JoiningType.Joining_Right: return QChar.Joining.Right;
        case QChar.JoiningType.Joining_None:
        case QChar.JoiningType.Joining_Left:
        case QChar.JoiningType.Joining_Transparent:
        default: return QChar.Joining.OtherJoining;
        }
    }
/+ #endif +/
    bool hasMirrored() const { return this.toQChar.hasMirrored(); }
    QChar mirroredChar() const { return this.toQChar.mirroredChar(); }
    QString decomposition() const { return this.toQChar.decomposition(); }
    QChar.Decomposition decompositionTag() const { return this.toQChar.decompositionTag(); }
    uchar combiningClass() const { return this.toQChar.combiningClass(); }

    pragma(inline, true) QChar.Script script() const { return this.toQChar.script(); }

    QChar.UnicodeVersion unicodeVersion() const { return this.toQChar.unicodeVersion(); }

    pragma(inline, true) uchar cell() const { return this.toQChar.cell(); }
    pragma(inline, true) uchar row() const { return this.toQChar.row(); }
    pragma(inline, true) void setCell(uchar acell) { this.toQChar.setCell(acell); }
    pragma(inline, true) void setRow(uchar arow) { this.toQChar.setRow(arow); }+/

/+ #if QT_DEPRECATED_SINCE(5, 0)
    /+ QT_DEPRECATED  char toAscii() const { return QChar(*this).toLatin1(); } +/
#endif +/
    char toLatin1() const { return this.toQChar.toLatin1(); }
    ushort unicode() const { return this.toQChar.unicode(); }
    ref ushort unicode() { return s.data()[i].unicode(); }

}
/+ Q_DECLARE_TYPEINFO(QCharRef, Q_MOVABLE_TYPE);

#if QT_STRINGVIEW_LEVEL < 2
#endif

#if QT_DEPRECATED_SINCE(5, 9) +/
/+pragma(inline, true) bool operator ==(QString.Null, QString.Null) { return true; }+/
/+/+ QT_DEPRECATED_X("use QString::isNull()") +/
pragma(inline, true) bool operator ==(QString.Null, ref const(QString) s) { return s.isNull(); }+/
/+/+ QT_DEPRECATED_X("use QString::isNull()") +/
pragma(inline, true) bool operator ==(ref const(QString) s, QString.Null) { return s.isNull(); }+/
/+pragma(inline, true) bool operator !=(QString.Null, QString.Null) { return false; }+/
/+/+ QT_DEPRECATED_X("use !QString::isNull()") +/
pragma(inline, true) bool operator !=(QString.Null, ref const(QString) s) { return !s.isNull(); }+/
/+/+ QT_DEPRECATED_X("use !QString::isNull()") +/
pragma(inline, true) bool operator !=(ref const(QString) s, QString.Null) { return !s.isNull(); }+/
/+ #endif +/

/+pragma(inline, true) bool operator ==(QLatin1String s1, QLatin1String s2)/+ noexcept+/
{
    import core.stdc.string;
    return s1.size() == s2.size() && (!s1.size() || !memcmp(s1.latin1(), s2.latin1(), s1.size()));
}+/
/+pragma(inline, true) bool operator !=(QLatin1String s1, QLatin1String s2)/+ noexcept+/
{ return !operator==(s1, s2); }+/
/+pragma(inline, true) bool operator <(QLatin1String s1, QLatin1String s2)/+ noexcept+/
{
    import core.stdc.string;

    const(int) len = qMin(s1.size(), s2.size());
    const(int) r = len ? memcmp(s1.latin1(), s2.latin1(), len) : 0;
    return r < 0 || (r == 0 && s1.size() < s2.size());
}+/
/+pragma(inline, true) bool operator >(QLatin1String s1, QLatin1String s2)/+ noexcept+/
{ return operator<(s2, s1); }+/
/+pragma(inline, true) bool operator <=(QLatin1String s1, QLatin1String s2)/+ noexcept+/
{ return !operator>(s1, s2); }+/
/+pragma(inline, true) bool operator >=(QLatin1String s1, QLatin1String s2)/+ noexcept+/
{ return !operator<(s1, s2); }+/

/+ #if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
inline bool QString::operator==(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) == 0; }
inline bool QString::operator!=(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) != 0; }
inline bool QString::operator<(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) < 0; }
inline bool QString::operator>(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) > 0; }
inline bool QString::operator<=(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) <= 0; }
inline bool QString::operator>=(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) >= 0; }

inline QT_ASCII_CAST_WARN bool operator==(const char *s1, const QString &s2)
{ return QString::compare_helper(s2.constData(), s2.size(), s1, -1) == 0; }
inline QT_ASCII_CAST_WARN bool operator!=(const char *s1, const QString &s2)
{ return QString::compare_helper(s2.constData(), s2.size(), s1, -1) != 0; }
inline QT_ASCII_CAST_WARN bool operator<(const char *s1, const QString &s2)
{ return QString::compare_helper(s2.constData(), s2.size(), s1, -1) > 0; }
inline QT_ASCII_CAST_WARN bool operator>(const char *s1, const QString &s2)
{ return QString::compare_helper(s2.constData(), s2.size(), s1, -1) < 0; }
inline QT_ASCII_CAST_WARN bool operator<=(const char *s1, const QString &s2)
{ return QString::compare_helper(s2.constData(), s2.size(), s1, -1) >= 0; }
inline QT_ASCII_CAST_WARN bool operator>=(const char *s1, const QString &s2)
{ return QString::compare_helper(s2.constData(), s2.size(), s1, -1) <= 0; }

inline QT_ASCII_CAST_WARN bool operator==(const char *s1, QLatin1String s2)
{ return QString::fromUtf8(s1) == s2; }
inline QT_ASCII_CAST_WARN bool operator!=(const char *s1, QLatin1String s2)
{ return QString::fromUtf8(s1) != s2; }
inline QT_ASCII_CAST_WARN bool operator<(const char *s1, QLatin1String s2)
{ return (QString::fromUtf8(s1) < s2); }
inline QT_ASCII_CAST_WARN bool operator>(const char *s1, QLatin1String s2)
{ return (QString::fromUtf8(s1) > s2); }
inline QT_ASCII_CAST_WARN bool operator<=(const char *s1, QLatin1String s2)
{ return (QString::fromUtf8(s1) <= s2); }
inline QT_ASCII_CAST_WARN bool operator>=(const char *s1, QLatin1String s2)
{ return (QString::fromUtf8(s1) >= s2); }

inline QT_ASCII_CAST_WARN bool QLatin1String::operator==(const char *s) const
{ return QString::fromUtf8(s) == *this; }
inline QT_ASCII_CAST_WARN bool QLatin1String::operator!=(const char *s) const
{ return QString::fromUtf8(s) != *this; }
inline QT_ASCII_CAST_WARN bool QLatin1String::operator<(const char *s) const
{ return QString::fromUtf8(s) > *this; }
inline QT_ASCII_CAST_WARN bool QLatin1String::operator>(const char *s) const
{ return QString::fromUtf8(s) < *this; }
inline QT_ASCII_CAST_WARN bool QLatin1String::operator<=(const char *s) const
{ return QString::fromUtf8(s) >= *this; }
inline QT_ASCII_CAST_WARN bool QLatin1String::operator>=(const char *s) const
{ return QString::fromUtf8(s) <= *this; }

inline QT_ASCII_CAST_WARN bool QLatin1String::operator==(const QByteArray &s) const
{ return QString::fromUtf8(s) == *this; }
inline QT_ASCII_CAST_WARN bool QLatin1String::operator!=(const QByteArray &s) const
{ return QString::fromUtf8(s) != *this; }
inline QT_ASCII_CAST_WARN bool QLatin1String::operator<(const QByteArray &s) const
{ return QString::fromUtf8(s) > *this; }
inline QT_ASCII_CAST_WARN bool QLatin1String::operator>(const QByteArray &s) const
{ return QString::fromUtf8(s) < *this; }
inline QT_ASCII_CAST_WARN bool QLatin1String::operator<=(const QByteArray &s) const
{ return QString::fromUtf8(s) >= *this; }
inline QT_ASCII_CAST_WARN bool QLatin1String::operator>=(const QByteArray &s) const
{ return QString::fromUtf8(s) <= *this; }

inline QT_ASCII_CAST_WARN bool QString::operator==(const QByteArray &s) const
{ return QString::compare_helper(constData(), size(), s.constData(), qstrnlen(s.constData(), s.size())) == 0; }
inline QT_ASCII_CAST_WARN bool QString::operator!=(const QByteArray &s) const
{ return QString::compare_helper(constData(), size(), s.constData(), qstrnlen(s.constData(), s.size())) != 0; }
inline QT_ASCII_CAST_WARN bool QString::operator<(const QByteArray &s) const
{ return QString::compare_helper(constData(), size(), s.constData(), s.size()) < 0; }
inline QT_ASCII_CAST_WARN bool QString::operator>(const QByteArray &s) const
{ return QString::compare_helper(constData(), size(), s.constData(), s.size()) > 0; }
inline QT_ASCII_CAST_WARN bool QString::operator<=(const QByteArray &s) const
{ return QString::compare_helper(constData(), size(), s.constData(), s.size()) <= 0; }
inline QT_ASCII_CAST_WARN bool QString::operator>=(const QByteArray &s) const
{ return QString::compare_helper(constData(), size(), s.constData(), s.size()) >= 0; }

inline bool QByteArray::operator==(const QString &s) const
{ return QString::compare_helper(s.constData(), s.size(), constData(), qstrnlen(constData(), size())) == 0; }
inline bool QByteArray::operator!=(const QString &s) const
{ return QString::compare_helper(s.constData(), s.size(), constData(), qstrnlen(constData(), size())) != 0; }
inline bool QByteArray::operator<(const QString &s) const
{ return QString::compare_helper(s.constData(), s.size(), constData(), size()) > 0; }
inline bool QByteArray::operator>(const QString &s) const
{ return QString::compare_helper(s.constData(), s.size(), constData(), size()) < 0; }
inline bool QByteArray::operator<=(const QString &s) const
{ return QString::compare_helper(s.constData(), s.size(), constData(), size()) >= 0; }
inline bool QByteArray::operator>=(const QString &s) const
{ return QString::compare_helper(s.constData(), s.size(), constData(), size()) <= 0; }

#endif // !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)

#if !defined(QT_NO_CAST_TO_ASCII) && QT_DEPRECATED_SINCE(5, 15)
inline QByteArray &QByteArray::append(const QString &s)
{ return append(s.toUtf8()); }
inline QByteArray &QByteArray::insert(int i, const QString &s)
{ return insert(i, s.toUtf8()); }
inline QByteArray &QByteArray::replace(char c, const QString &after)
{ return replace(c, after.toUtf8()); }
inline QByteArray &QByteArray::replace(const QString &before, const char *after)
{ return replace(before.toUtf8(), after); }
inline QByteArray &QByteArray::replace(const QString &before, const QByteArray &after)
{ return replace(before.toUtf8(), after); }
inline QByteArray &QByteArray::operator+=(const QString &s)
{ return operator+=(s.toUtf8()); }
inline int QByteArray::indexOf(const QString &s, int from) const
{ return indexOf(s.toUtf8(), from); }
inline int QByteArray::lastIndexOf(const QString &s, int from) const
{ return lastIndexOf(s.toUtf8(), from); }
#endif +/ // !defined(QT_NO_CAST_TO_ASCII) && QT_DEPRECATED_SINCE(5, 15)

version(QT_USE_FAST_OPERATOR_PLUS){}else
version(QT_USE_QSTRINGBUILDER){}else
{
/+pragma(inline, true) const(QString) operator +(ref const(QString) s1, ref const(QString) s2)
{ auto t = QString(s1); t ~= s2; return t; }+/
/+pragma(inline, true) const(QString) operator +(ref const(QString) s1, QChar s2)
{ auto t = QString(s1); t ~= s2; return t; }+/
/+pragma(inline, true) const(QString) operator +(QChar s1, ref const(QString) s2)
{ auto t = QString(s1); t ~= s2; return t; }+/
/+ #  if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
inline QT_ASCII_CAST_WARN const QString operator+(const QString &s1, const char *s2)
{ QString t(s1); t += QString::fromUtf8(s2); return t; }
inline QT_ASCII_CAST_WARN const QString operator+(const char *s1, const QString &s2)
{ QString t = QString::fromUtf8(s1); t += s2; return t; }
inline QT_ASCII_CAST_WARN const QString operator+(char c, const QString &s)
{ QString t = s; t.prepend(QChar::fromLatin1(c)); return t; }
inline QT_ASCII_CAST_WARN const QString operator+(const QString &s, char c)
{ QString t = s; t += QChar::fromLatin1(c); return t; }
inline QT_ASCII_CAST_WARN const QString operator+(const QByteArray &ba, const QString &s)
{ QString t = QString::fromUtf8(ba); t += s; return t; }
inline QT_ASCII_CAST_WARN const QString operator+(const QString &s, const QByteArray &ba)
{ QString t(s); t += QString::fromUtf8(ba); return t; }
#  endif +/ // QT_NO_CAST_FROM_ASCII
}

/+ inline std::string QString::toStdString() const
{ return toUtf8().toStdString(); }

inline QString QString::fromStdString(const std::string &s)
{ return fromUtf8(s.data(), int(s.size())); }

inline std::wstring QString::toStdWString() const
{
    std::wstring str;
    str.resize(length());
#if __cplusplus >= 201703L
    str.resize(toWCharArray(str.data()));
#else
    if (length())
        str.resize(toWCharArray(&str.front()));
#endif
    return str;
}

inline QString QString::fromStdWString(const std::wstring &s)
{ return fromWCharArray(s.data(), int(s.size())); }

#if defined(Q_STDLIB_UNICODE_STRINGS)
inline QString QString::fromStdU16String(const std::u16string &s)
{ return fromUtf16(s.data(), int(s.size())); }

inline std::u16string QString::toStdU16String() const
{ return std::u16string(reinterpret_cast<const char16_t*>(utf16()), length()); }

inline QString QString::fromStdU32String(const std::u32string &s)
{ return fromUcs4(s.data(), int(s.size())); }

inline std::u32string QString::toStdU32String() const
{
    std::u32string u32str(length(), char32_t(0));
    int len = toUcs4_helper(d->data(), length(), reinterpret_cast<uint*>(&u32str[0]));
    u32str.resize(len);
    return u32str;
}
#endif

#if !defined(QT_NO_DATASTREAM) || (defined(QT_BOOTSTRAPPED) && !defined(QT_BUILD_QMAKE))
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QString &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QString &);
#endif +/
/+pragma(inline, true) QFlags!(QString.SectionFlags.enum_type) operator |(QString.SectionFlags.enum_type f1, QString.SectionFlags.enum_type f2)/+noexcept+/{return QFlags!(QString.SectionFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QString.SectionFlags.enum_type) operator |(QString.SectionFlags.enum_type f1, QFlags!(QString.SectionFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QString.SectionFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_SHARED(QString)
Q_DECLARE_OPERATORS_FOR_FLAGS(QString::SectionFlags) +/

/// Binding for C++ class [QStringRef](https://doc.qt.io/qt-5/qstringref.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QStringRef {
private:
    static import qt.core.stringalgorithms;
    static import qt.core.namespace;
    const(QString)* m_string = null;
    int m_position = 0;
    int m_size = 0;
public:
    alias size_type = QString.size_type;
    alias value_type = QString.value_type;
    alias const_iterator = const(QChar)*;
    /+ typedef std::reverse_iterator<const_iterator> const_reverse_iterator; +/
    alias const_pointer = QString.const_pointer;
    /+ typedef QString::const_reference const_reference; +/

    // ### Qt 6: make this constructor constexpr, after the destructor is made trivial
    /+pragma(inline, true) this()
    {
        this.m_string = null;
        this.m_position = 0;
        this.m_size = 0;
    }+/
    pragma(inline, true) this(const(QString)* aString, int aPosition, int aSize)
    {
        this.m_string = aString;
        this.m_position = aPosition;
        this.m_size = aSize;
    }
    pragma(inline, true) this(const(QString)* aString)
    {
        this.m_string = aString;
        this.m_position = 0;
        this.m_size = aString?aString.size() : 0;
    }

/+ #if QT_VERSION < QT_VERSION_CHECK(6,0,0) +/
    // ### Qt 6: remove all of these, the implicit ones are fine
    @disable this(this);
    this(ref const(QStringRef) other)/+ noexcept+/
    {
        this.m_string = other.m_string;
        this.m_position = other.m_position;
        this.m_size = other.m_size;
    }
    /+ QStringRef(QStringRef &&other) noexcept : m_string(other.m_string), m_position(other.m_position), m_size(other.m_size) {} +/
    /+ QStringRef &operator=(QStringRef &&other) noexcept { return *this = other; } +/
    /+ref QStringRef operator =(ref const(QStringRef) other)/+ noexcept+/
    {
        m_string = other.m_string; m_position = other.m_position;
        m_size = other.m_size; return this;
    }+/
    pragma(inline, true) ~this(){}
/+ #endif +/ // Qt < 6.0.0

    /+ inline const QString *string() const { return m_string; } +/
    pragma(inline, true) int position() const { return m_position; }
    pragma(inline, true) int size() const { return m_size; }
    pragma(inline, true) int count() const { return m_size; }
    pragma(inline, true) int length() const { return m_size; }

    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        int indexOf(ref const(QString) str, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
        int indexOf(ref const(QStringRef) str, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    }
    /+ Q_REQUIRED_RESULT +/ int indexOf(QStringView s, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return cast(int)(/+ QtPrivate:: +/qt.core.stringalgorithms.findString(QStringView(this), from, s, cs));
    } // ### Qt6: qsizetype
    int indexOf(QChar ch, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    int indexOf(QLatin1String str, int from = 0, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        int lastIndexOf(ref const(QStringRef) str, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
        int lastIndexOf(ref const(QString) str, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    }
    int lastIndexOf(QChar ch, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    int lastIndexOf(QLatin1String str, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ Q_REQUIRED_RESULT +/ int lastIndexOf(QStringView s, int from = -1, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return cast(int)(/+ QtPrivate:: +/qt.core.stringalgorithms.lastIndexOf(QStringView(this), from, s, cs));
    } // ### Qt6: qsizetype

    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        pragma(inline, true) bool contains(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
        { return indexOf(s, 0, cs) != -1; }
        pragma(inline, true) bool contains(ref const(QStringRef) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
        { return indexOf(s, 0, cs) != -1; }
    }
    pragma(inline, true) bool contains(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    { return indexOf(c, 0, cs) != -1; }
    pragma(inline, true) bool contains(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const
    { return indexOf(s, 0, cs) != -1; }
    pragma(inline, true) bool contains(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return indexOf(s, 0, cs) != -1; }

    int count(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    int count(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    int count(ref const(QStringRef) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;

/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+ Q_REQUIRED_RESULT +/ /+ QT_DEPRECATED_VERSION_X_5_15("Use Qt::SplitBehavior variant instead") +/
        QVector!(QStringRef) split(ref const(QString) sep, QString.SplitBehavior behavior,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ Q_REQUIRED_RESULT +/ /+ QT_DEPRECATED_VERSION_X_5_15("Use Qt::SplitBehavior variant instead") +/
        QVector!(QStringRef) split(QChar sep, QString.SplitBehavior behavior,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
/+ #endif +/ // 5.15 deprecations

    /+ Q_REQUIRED_RESULT +/
        QVector!(QStringRef) split(ref const(QString) sep, /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    /+ Q_REQUIRED_RESULT +/
        QVector!(QStringRef) split(QChar sep, /+ Qt:: +/qt.core.namespace.SplitBehavior behavior = /+ Qt:: +/qt.core.namespace.SplitBehaviorFlags.KeepEmptyParts,
                                  /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;

    /+ Q_REQUIRED_RESULT +/ QStringRef left(int n) const;
    /+ Q_REQUIRED_RESULT +/ QStringRef right(int n) const;
    /+ Q_REQUIRED_RESULT +/ QStringRef mid(int pos, int n = -1) const;
    /+ Q_REQUIRED_RESULT +/ QStringRef chopped(int n) const
    { (mixin(Q_ASSERT(q{n >= 0}))); (mixin(Q_ASSERT(q{n <= QStringRef.size()}))); return left(size() - n); }

    void truncate(int pos)/+ noexcept+/ { m_size = qBound(0, pos, m_size); }
    void chop(int n)/+ noexcept+/
    {
        if (n >= m_size)
            m_size = 0;
        else if (n > 0)
            m_size -= n;
    }

    bool isRightToLeft() const;

    /+ Q_REQUIRED_RESULT +/ bool startsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.startsWith(QStringView(this), s, cs);
    }
    bool startsWith(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    bool startsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        bool startsWith(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
        bool startsWith(ref const(QStringRef) c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    }

    /+ Q_REQUIRED_RESULT +/ bool endsWith(QStringView s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.endsWith(QStringView(this), s, cs);
    }
    bool endsWith(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    bool endsWith(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        bool endsWith(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
        bool endsWith(ref const(QStringRef) c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const;
    }

    /+pragma(inline, true) ref QStringRef operator =(const(QString)* aString)
    { m_string = aString; m_position = 0; m_size = aString?aString.size():0; return this; }+/

    pragma(inline, true) const(QChar)* unicode() const
    {
        if (!m_string)
            return reinterpret_cast!(const(QChar)*)(QString.Data.sharedNull().data());
        return m_string.unicode() + m_position;
    }
    pragma(inline, true) const(QChar)* data() const { return unicode(); }
    pragma(inline, true) const(QChar)* constData() const {  return unicode(); }

    pragma(inline, true) const_iterator begin() const { return unicode(); }
    pragma(inline, true) const_iterator cbegin() const { return unicode(); }
    pragma(inline, true) const_iterator constBegin() const { return unicode(); }
    pragma(inline, true) const_iterator end() const { return unicode() + size(); }
    pragma(inline, true) const_iterator cend() const { return unicode() + size(); }
    pragma(inline, true) const_iterator constEnd() const { return unicode() + size(); }
    /+ inline const_reverse_iterator rbegin() const { return const_reverse_iterator(end()); } +/
    /+ inline const_reverse_iterator crbegin() const { return rbegin(); } +/
    /+ inline const_reverse_iterator rend() const { return const_reverse_iterator(begin()); } +/
    /+ inline const_reverse_iterator crend() const { return rend(); } +/

/+ #if QT_DEPRECATED_SINCE(5, 0)
    Q_REQUIRED_RESULT QT_DEPRECATED QByteArray toAscii() const
    { return toLatin1(); }
#endif +/
    /+ Q_REQUIRED_RESULT +/ QByteArray toLatin1() const;
    /+ Q_REQUIRED_RESULT +/ QByteArray toUtf8() const;
    /+ Q_REQUIRED_RESULT +/ QByteArray toLocal8Bit() const;
    /+ Q_REQUIRED_RESULT +/ QVector!(uint) toUcs4() const;

    pragma(inline, true) void clear() { m_string = null; m_position = m_size = 0; }
    QString toString() const;
    pragma(inline, true) bool isEmpty() const { return m_size == 0; }
    pragma(inline, true) bool isNull() const { return m_string is null || m_string.isNull(); }

    QStringRef appendTo(QString* string) const;

    pragma(inline, true) const(QChar) at(int i) const
        { (mixin(Q_ASSERT(q{uint(i) < uint(QStringRef.size())}))); return m_string.at(i + m_position); }
    QChar opIndex(int i) const { return at(i); }
    /+ Q_REQUIRED_RESULT +/ QChar front() const { return at(0); }
    /+ Q_REQUIRED_RESULT +/ QChar back() const { return at(size() - 1); }

/+ #if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
    // ASCII compatibility
    inline QT_ASCII_CAST_WARN bool operator==(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator!=(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator<(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator<=(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator>(const char *s) const;
    inline QT_ASCII_CAST_WARN bool operator>=(const char *s) const;
#endif +/

    pragma(inline, true) int compare(ref const(QString) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return QString.compare_helper(constData(), length(), s.constData(), s.length(), cs); }
    pragma(inline, true) int compare(ref const(QStringRef) s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return QString.compare_helper(constData(), length(), s.constData(), s.length(), cs); }
    int compare(QChar c, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    {
        import qt.core.stringalgorithms;
        return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(QStringView(this), QStringView(&c, 1), cs);
    }
    pragma(inline, true) int compare(QLatin1String s, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive) const/+ noexcept+/
    { return QString.compare_helper(constData(), length(), s, cs); }
/+ #if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
    int compare(const QByteArray &s, Qt::CaseSensitivity cs = Qt::CaseSensitive) const
    { return QString::compare_helper(unicode(), size(), s.data(), qstrnlen(s.data(), s.size()), cs); }
#endif +/
    pragma(inline, true) static int compare(ref const(QStringRef) s1, ref const(QString) s2,
                           /+ Qt:: +/qt.core.namespace.CaseSensitivity cs /+ = Qt::CaseSensitive +/)/+ noexcept+/
    { return QString.compare_helper(s1.constData(), s1.length(), s2.constData(), s2.length(), cs); }
    pragma(inline, true) static int compare(ref const(QStringRef) s1, ref const(QStringRef) s2,
                           /+ Qt:: +/qt.core.namespace.CaseSensitivity cs /+ = Qt::CaseSensitive +/)/+ noexcept+/
    { return QString.compare_helper(s1.constData(), s1.length(), s2.constData(), s2.length(), cs); }
    pragma(inline, true) static int compare(ref const(QStringRef) s1, QLatin1String s2,
                           /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive)/+ noexcept+/
    { return QString.compare_helper(s1.constData(), s1.length(), s2, cs); }

    pragma(inline, true) int localeAwareCompare(ref const(QString) s) const
    { return QString.localeAwareCompare_helper(constData(), length(), s.constData(), s.length()); }
    pragma(inline, true) int localeAwareCompare(ref const(QStringRef) s) const
    { return QString.localeAwareCompare_helper(constData(), length(), s.constData(), s.length()); }
    pragma(inline, true) int localeAwareCompare(QStringView s) const
    { return QString.localeAwareCompare_helper(constData(), length(), s.data(), cast(int)(s.size())); }
    pragma(inline, true) static int localeAwareCompare(ref const(QStringRef) s1, ref const(QString) s2)
    { return QString.localeAwareCompare_helper(s1.constData(), s1.length(), s2.constData(), s2.length()); }
    pragma(inline, true) static int localeAwareCompare(ref const(QStringRef) s1, ref const(QStringRef) s2)
    { return QString.localeAwareCompare_helper(s1.constData(), s1.length(), s2.constData(), s2.length()); }
    pragma(inline, true) static int localeAwareCompare(QStringView s1, QStringView s2)
    { return QString.localeAwareCompare_helper(s1.data(), cast(int)(s1.size()), s2.data(), cast(int)(s2.size())); }

    /+ Q_REQUIRED_RESULT +/ QStringRef trimmed() const;
    short  toShort(bool* ok = null, int base = 10) const;
    ushort toUShort(bool* ok = null, int base = 10) const;
    int toInt(bool* ok = null, int base = 10) const;
    uint toUInt(bool* ok = null, int base = 10) const;
    cpp_long toLong(bool* ok = null, int base = 10) const;
    cpp_ulong toULong(bool* ok = null, int base = 10) const;
    qlonglong toLongLong(bool* ok = null, int base = 10) const;
    qulonglong toULongLong(bool* ok = null, int base = 10) const;
    float toFloat(bool* ok = null) const;
    double toDouble(bool* ok = null) const;
}
/+ Q_DECLARE_TYPEINFO(QStringRef, Q_PRIMITIVE_TYPE); +/

// QStringRef <> QStringRef
/+/+ Q_CORE_EXPORT +/ bool operator ==(ref const(QStringRef) s1, ref const(QStringRef) s2)/+ noexcept+/;+/
/+pragma(inline, true) bool operator !=(ref const(QStringRef) s1, ref const(QStringRef) s2)/+ noexcept+/
{ return !(s1 == s2); }+/
/+/+ Q_CORE_EXPORT +/ bool operator <(ref const(QStringRef) s1, ref const(QStringRef) s2)/+ noexcept+/;+/
/+pragma(inline, true) bool operator >(ref const(QStringRef) s1, ref const(QStringRef) s2)/+ noexcept+/
{ return s2 < s1; }+/
/+pragma(inline, true) bool operator <=(ref const(QStringRef) s1, ref const(QStringRef) s2)/+ noexcept+/
{ return !(s1 > s2); }+/
/+pragma(inline, true) bool operator >=(ref const(QStringRef) s1, ref const(QStringRef) s2)/+ noexcept+/
{ return !(s1 < s2); }+/

// QString <> QStringRef
/+/+ Q_CORE_EXPORT +/ bool operator ==(ref const(QString) lhs, ref const(QStringRef) rhs)/+ noexcept+/;+/
/+pragma(inline, true) bool operator !=(ref const(QString) lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return lhs.compare(rhs) != 0; }+/
/+pragma(inline, true) bool operator < (ref const(QString) lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return lhs.compare(rhs) <  0; }+/
/+pragma(inline, true) bool operator > (ref const(QString) lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return lhs.compare(rhs) >  0; }+/
/+pragma(inline, true) bool operator <=(ref const(QString) lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return lhs.compare(rhs) <= 0; }+/
/+pragma(inline, true) bool operator >=(ref const(QString) lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return lhs.compare(rhs) >= 0; }+/

/+pragma(inline, true) bool operator ==(ref const(QStringRef) lhs, ref const(QString) rhs)/+ noexcept+/ { return rhs == lhs; }+/
/+pragma(inline, true) bool operator !=(ref const(QStringRef) lhs, ref const(QString) rhs)/+ noexcept+/ { return rhs != lhs; }+/
/+pragma(inline, true) bool operator < (ref const(QStringRef) lhs, ref const(QString) rhs)/+ noexcept+/ { return rhs >  lhs; }+/
/+pragma(inline, true) bool operator > (ref const(QStringRef) lhs, ref const(QString) rhs)/+ noexcept+/ { return rhs <  lhs; }+/
/+pragma(inline, true) bool operator <=(ref const(QStringRef) lhs, ref const(QString) rhs)/+ noexcept+/ { return rhs >= lhs; }+/
/+pragma(inline, true) bool operator >=(ref const(QStringRef) lhs, ref const(QString) rhs)/+ noexcept+/ { return rhs <= lhs; }+/

/+ #if QT_STRINGVIEW_LEVEL < 2
#endif +/

// QLatin1String <> QStringRef
/+/+ Q_CORE_EXPORT +/ bool operator ==(QLatin1String lhs, ref const(QStringRef) rhs)/+ noexcept+/;+/
/+pragma(inline, true) bool operator !=(QLatin1String lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return rhs.compare(lhs) != 0; }+/
/+pragma(inline, true) bool operator < (QLatin1String lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return rhs.compare(lhs) >  0; }+/
/+pragma(inline, true) bool operator > (QLatin1String lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return rhs.compare(lhs) <  0; }+/
/+pragma(inline, true) bool operator <=(QLatin1String lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return rhs.compare(lhs) >= 0; }+/
/+pragma(inline, true) bool operator >=(QLatin1String lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return rhs.compare(lhs) <= 0; }+/

/+pragma(inline, true) bool operator ==(ref const(QStringRef) lhs, QLatin1String rhs)/+ noexcept+/ { return rhs == lhs; }+/
/+pragma(inline, true) bool operator !=(ref const(QStringRef) lhs, QLatin1String rhs)/+ noexcept+/ { return rhs != lhs; }+/
/+pragma(inline, true) bool operator < (ref const(QStringRef) lhs, QLatin1String rhs)/+ noexcept+/ { return rhs >  lhs; }+/
/+pragma(inline, true) bool operator > (ref const(QStringRef) lhs, QLatin1String rhs)/+ noexcept+/ { return rhs <  lhs; }+/
/+pragma(inline, true) bool operator <=(ref const(QStringRef) lhs, QLatin1String rhs)/+ noexcept+/ { return rhs >= lhs; }+/
/+pragma(inline, true) bool operator >=(ref const(QStringRef) lhs, QLatin1String rhs)/+ noexcept+/ { return rhs <= lhs; }+/

// QChar <> QString
/+pragma(inline, true) bool operator ==(QChar lhs, ref const(QString) rhs)/+ noexcept+/
{ return rhs.size() == 1 && lhs == rhs.front(); }+/
/+pragma(inline, true) bool operator < (QChar lhs, ref const(QString) rhs)/+ noexcept+/
{ return QString.compare_helper(&lhs, 1, rhs.data(), rhs.size()) <  0; }+/
/+pragma(inline, true) bool operator > (QChar lhs, ref const(QString) rhs)/+ noexcept+/
{ return QString.compare_helper(&lhs, 1, rhs.data(), rhs.size()) >  0; }+/

/+pragma(inline, true) bool operator !=(QChar lhs, ref const(QString) rhs)/+ noexcept+/ { return !(lhs == rhs); }+/
/+pragma(inline, true) bool operator <=(QChar lhs, ref const(QString) rhs)/+ noexcept+/ { return !(lhs >  rhs); }+/
/+pragma(inline, true) bool operator >=(QChar lhs, ref const(QString) rhs)/+ noexcept+/ { return !(lhs <  rhs); }+/

/+pragma(inline, true) bool operator ==(ref const(QString) lhs, QChar rhs)/+ noexcept+/ { return   rhs == lhs; }+/
/+pragma(inline, true) bool operator !=(ref const(QString) lhs, QChar rhs)/+ noexcept+/ { return !(rhs == lhs); }+/
/+pragma(inline, true) bool operator < (ref const(QString) lhs, QChar rhs)/+ noexcept+/ { return   rhs >  lhs; }+/
/+pragma(inline, true) bool operator > (ref const(QString) lhs, QChar rhs)/+ noexcept+/ { return   rhs <  lhs; }+/
/+pragma(inline, true) bool operator <=(ref const(QString) lhs, QChar rhs)/+ noexcept+/ { return !(rhs <  lhs); }+/
/+pragma(inline, true) bool operator >=(ref const(QString) lhs, QChar rhs)/+ noexcept+/ { return !(rhs >  lhs); }+/

// QChar <> QStringRef
/+pragma(inline, true) bool operator ==(QChar lhs, ref const(QStringRef) rhs)/+ noexcept+/
{ return rhs.size() == 1 && lhs == rhs.front(); }+/
/+pragma(inline, true) bool operator < (QChar lhs, ref const(QStringRef) rhs)/+ noexcept+/
{ return QString.compare_helper(&lhs, 1, rhs.data(), rhs.size()) <  0; }+/
/+pragma(inline, true) bool operator > (QChar lhs, ref const(QStringRef) rhs)/+ noexcept+/
{ return QString.compare_helper(&lhs, 1, rhs.data(), rhs.size()) >  0; }+/

/+pragma(inline, true) bool operator !=(QChar lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return !(lhs == rhs); }+/
/+pragma(inline, true) bool operator <=(QChar lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return !(lhs >  rhs); }+/
/+pragma(inline, true) bool operator >=(QChar lhs, ref const(QStringRef) rhs)/+ noexcept+/ { return !(lhs <  rhs); }+/

/+pragma(inline, true) bool operator ==(ref const(QStringRef) lhs, QChar rhs)/+ noexcept+/ { return   rhs == lhs; }+/
/+pragma(inline, true) bool operator !=(ref const(QStringRef) lhs, QChar rhs)/+ noexcept+/ { return !(rhs == lhs); }+/
/+pragma(inline, true) bool operator < (ref const(QStringRef) lhs, QChar rhs)/+ noexcept+/ { return   rhs >  lhs; }+/
/+pragma(inline, true) bool operator > (ref const(QStringRef) lhs, QChar rhs)/+ noexcept+/ { return   rhs <  lhs; }+/
/+pragma(inline, true) bool operator <=(ref const(QStringRef) lhs, QChar rhs)/+ noexcept+/ { return !(rhs <  lhs); }+/
/+pragma(inline, true) bool operator >=(ref const(QStringRef) lhs, QChar rhs)/+ noexcept+/ { return !(rhs >  lhs); }+/

// QChar <> QLatin1String
/+pragma(inline, true) bool operator ==(QChar lhs, QLatin1String rhs)/+ noexcept+/
{ return rhs.size() == 1 && lhs == rhs.front(); }+/
/+pragma(inline, true) bool operator < (QChar lhs, QLatin1String rhs)/+ noexcept+/
{ return QString.compare_helper(&lhs, 1, rhs) <  0; }+/
/+pragma(inline, true) bool operator > (QChar lhs, QLatin1String rhs)/+ noexcept+/
{ return QString.compare_helper(&lhs, 1, rhs) >  0; }+/

/+pragma(inline, true) bool operator !=(QChar lhs, QLatin1String rhs)/+ noexcept+/ { return !(lhs == rhs); }+/
/+pragma(inline, true) bool operator <=(QChar lhs, QLatin1String rhs)/+ noexcept+/ { return !(lhs >  rhs); }+/
/+pragma(inline, true) bool operator >=(QChar lhs, QLatin1String rhs)/+ noexcept+/ { return !(lhs <  rhs); }+/

/+pragma(inline, true) bool operator ==(QLatin1String lhs, QChar rhs)/+ noexcept+/ { return   rhs == lhs; }+/
/+pragma(inline, true) bool operator !=(QLatin1String lhs, QChar rhs)/+ noexcept+/ { return !(rhs == lhs); }+/
/+pragma(inline, true) bool operator < (QLatin1String lhs, QChar rhs)/+ noexcept+/ { return   rhs >  lhs; }+/
/+pragma(inline, true) bool operator > (QLatin1String lhs, QChar rhs)/+ noexcept+/ { return   rhs <  lhs; }+/
/+pragma(inline, true) bool operator <=(QLatin1String lhs, QChar rhs)/+ noexcept+/ { return !(rhs <  lhs); }+/
/+pragma(inline, true) bool operator >=(QLatin1String lhs, QChar rhs)/+ noexcept+/ { return !(rhs >  lhs); }+/

// QStringView <> QStringView
/+pragma(inline, true) bool operator ==(QStringView lhs, QStringView rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return lhs.size() == rhs.size() && /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) == 0;
}+/
/+pragma(inline, true) bool operator !=(QStringView lhs, QStringView rhs)/+ noexcept+/ { return !(lhs == rhs); }+/
/+pragma(inline, true) bool operator < (QStringView lhs, QStringView rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) <  0;
}+/
/+pragma(inline, true) bool operator <=(QStringView lhs, QStringView rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) <= 0;
}+/
/+pragma(inline, true) bool operator > (QStringView lhs, QStringView rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) >  0;
}+/
/+pragma(inline, true) bool operator >=(QStringView lhs, QStringView rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) >= 0;
}+/

// QStringView <> QChar
/+pragma(inline, true) bool operator ==(QStringView lhs, QChar rhs)/+ noexcept+/ { return lhs == QStringView(&rhs, 1); }+/
/+pragma(inline, true) bool operator !=(QStringView lhs, QChar rhs)/+ noexcept+/ { return lhs != QStringView(&rhs, 1); }+/
/+pragma(inline, true) bool operator < (QStringView lhs, QChar rhs)/+ noexcept+/ { return lhs <  QStringView(&rhs, 1); }+/
/+pragma(inline, true) bool operator <=(QStringView lhs, QChar rhs)/+ noexcept+/ { return lhs <= QStringView(&rhs, 1); }+/
/+pragma(inline, true) bool operator > (QStringView lhs, QChar rhs)/+ noexcept+/ { return lhs >  QStringView(&rhs, 1); }+/
/+pragma(inline, true) bool operator >=(QStringView lhs, QChar rhs)/+ noexcept+/ { return lhs >= QStringView(&rhs, 1); }+/

/+pragma(inline, true) bool operator ==(QChar lhs, QStringView rhs)/+ noexcept+/ { return QStringView(&lhs, 1) == rhs; }+/
/+pragma(inline, true) bool operator !=(QChar lhs, QStringView rhs)/+ noexcept+/ { return QStringView(&lhs, 1) != rhs; }+/
/+pragma(inline, true) bool operator < (QChar lhs, QStringView rhs)/+ noexcept+/ { return QStringView(&lhs, 1) <  rhs; }+/
/+pragma(inline, true) bool operator <=(QChar lhs, QStringView rhs)/+ noexcept+/ { return QStringView(&lhs, 1) <= rhs; }+/
/+pragma(inline, true) bool operator > (QChar lhs, QStringView rhs)/+ noexcept+/ { return QStringView(&lhs, 1) >  rhs; }+/
/+pragma(inline, true) bool operator >=(QChar lhs, QStringView rhs)/+ noexcept+/ { return QStringView(&lhs, 1) >= rhs; }+/

// QStringView <> QLatin1String
/+pragma(inline, true) bool operator ==(QStringView lhs, QLatin1String rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return lhs.size() == rhs.size() && /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) == 0;
}+/
/+pragma(inline, true) bool operator !=(QStringView lhs, QLatin1String rhs)/+ noexcept+/ { return !(lhs == rhs); }+/
/+pragma(inline, true) bool operator < (QStringView lhs, QLatin1String rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) <  0;
}+/
/+pragma(inline, true) bool operator <=(QStringView lhs, QLatin1String rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) <= 0;
}+/
/+pragma(inline, true) bool operator > (QStringView lhs, QLatin1String rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) >  0;
}+/
/+pragma(inline, true) bool operator >=(QStringView lhs, QLatin1String rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) >= 0;
}+/

/+pragma(inline, true) bool operator ==(QLatin1String lhs, QStringView rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return lhs.size() == rhs.size() && /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) == 0;
}+/
/+pragma(inline, true) bool operator !=(QLatin1String lhs, QStringView rhs)/+ noexcept+/ { return !(lhs == rhs); }+/
/+pragma(inline, true) bool operator < (QLatin1String lhs, QStringView rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) <  0;
}+/
/+pragma(inline, true) bool operator <=(QLatin1String lhs, QStringView rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) <= 0;
}+/
/+pragma(inline, true) bool operator > (QLatin1String lhs, QStringView rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) >  0;
}+/
/+pragma(inline, true) bool operator >=(QLatin1String lhs, QStringView rhs)/+ noexcept+/ {
    import qt.core.stringalgorithms;
    return /+ QtPrivate:: +/qt.core.stringalgorithms.compareStrings(lhs, rhs) >= 0;
}+/

/+ #if !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)
// QStringRef <> QByteArray
inline QT_ASCII_CAST_WARN bool operator==(const QStringRef &lhs, const QByteArray &rhs) { return lhs.compare(rhs) == 0; }
inline QT_ASCII_CAST_WARN bool operator!=(const QStringRef &lhs, const QByteArray &rhs) { return lhs.compare(rhs) != 0; }
inline QT_ASCII_CAST_WARN bool operator< (const QStringRef &lhs, const QByteArray &rhs) { return lhs.compare(rhs) <  0; }
inline QT_ASCII_CAST_WARN bool operator> (const QStringRef &lhs, const QByteArray &rhs) { return lhs.compare(rhs) >  0; }
inline QT_ASCII_CAST_WARN bool operator<=(const QStringRef &lhs, const QByteArray &rhs) { return lhs.compare(rhs) <= 0; }
inline QT_ASCII_CAST_WARN bool operator>=(const QStringRef &lhs, const QByteArray &rhs) { return lhs.compare(rhs) >= 0; }

inline QT_ASCII_CAST_WARN bool operator==(const QByteArray &lhs, const QStringRef &rhs) { return rhs.compare(lhs) == 0; }
inline QT_ASCII_CAST_WARN bool operator!=(const QByteArray &lhs, const QStringRef &rhs) { return rhs.compare(lhs) != 0; }
inline QT_ASCII_CAST_WARN bool operator< (const QByteArray &lhs, const QStringRef &rhs) { return rhs.compare(lhs) >  0; }
inline QT_ASCII_CAST_WARN bool operator> (const QByteArray &lhs, const QStringRef &rhs) { return rhs.compare(lhs) <  0; }
inline QT_ASCII_CAST_WARN bool operator<=(const QByteArray &lhs, const QStringRef &rhs) { return rhs.compare(lhs) >= 0; }
inline QT_ASCII_CAST_WARN bool operator>=(const QByteArray &lhs, const QStringRef &rhs) { return rhs.compare(lhs) <= 0; }

// QStringRef <> const char *
inline QT_ASCII_CAST_WARN bool QStringRef::operator==(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) == 0; }
inline QT_ASCII_CAST_WARN bool QStringRef::operator!=(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) != 0; }
inline QT_ASCII_CAST_WARN bool QStringRef::operator<(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) < 0; }
inline QT_ASCII_CAST_WARN bool QStringRef::operator<=(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) <= 0; }
inline QT_ASCII_CAST_WARN bool QStringRef::operator>(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) > 0; }
inline QT_ASCII_CAST_WARN bool QStringRef::operator>=(const char *s) const
{ return QString::compare_helper(constData(), size(), s, -1) >= 0; }

inline QT_ASCII_CAST_WARN bool operator==(const char *s1, const QStringRef &s2)
{ return QString::compare_helper(s2.constData(), s2.size(), s1, -1) == 0; }
inline QT_ASCII_CAST_WARN bool operator!=(const char *s1, const QStringRef &s2)
{ return QString::compare_helper(s2.constData(), s2.size(), s1, -1) != 0; }
inline QT_ASCII_CAST_WARN bool operator<(const char *s1, const QStringRef &s2)
{ return QString::compare_helper(s2.constData(), s2.size(), s1, -1) > 0; }
inline QT_ASCII_CAST_WARN bool operator<=(const char *s1, const QStringRef &s2)
{ return QString::compare_helper(s2.constData(), s2.size(), s1, -1) >= 0; }
inline QT_ASCII_CAST_WARN bool operator>(const char *s1, const QStringRef &s2)
{ return QString::compare_helper(s2.constData(), s2.size(), s1, -1) < 0; }
inline QT_ASCII_CAST_WARN bool operator>=(const char *s1, const QStringRef &s2)
{ return QString::compare_helper(s2.constData(), s2.size(), s1, -1) <= 0; }
#endif // !defined(QT_NO_CAST_FROM_ASCII) && !defined(QT_RESTRICTED_CAST_FROM_ASCII)

#if QT_STRINGVIEW_LEVEL < 2
#endif +/

version(QT_USE_FAST_OPERATOR_PLUS){}else
version(QT_USE_QSTRINGBUILDER){}else
{
/+pragma(inline, true) QString operator +(ref const(QString) s1, ref const(QStringRef) s2)
{ QString t; t.reserve(s1.size() + s2.size()); t ~= s1; t ~= s2; return t; }+/
/+pragma(inline, true) QString operator +(ref const(QStringRef) s1, ref const(QString) s2)
{ QString t; t.reserve(s1.size() + s2.size()); t ~= s1; t ~= s2; return t; }+/
/+pragma(inline, true) QString operator +(ref const(QStringRef) s1, QLatin1String s2)
{ QString t; t.reserve(s1.size() + s2.size()); t ~= s1; t ~= s2; return t; }+/
/+pragma(inline, true) QString operator +(QLatin1String s1, ref const(QStringRef) s2)
{ QString t; t.reserve(s1.size() + s2.size()); t ~= s1; t ~= s2; return t; }+/
/+pragma(inline, true) QString operator +(ref const(QStringRef) s1, ref const(QStringRef) s2)
{ QString t; t.reserve(s1.size() + s2.size()); t ~= s1; t ~= s2; return t; }+/
/+pragma(inline, true) QString operator +(ref const(QStringRef) s1, QChar s2)
{ QString t; t.reserve(s1.size() + 1); t ~= s1; t ~= s2; return t; }+/
/+pragma(inline, true) QString operator +(QChar s1, ref const(QStringRef) s2)
{ QString t; t.reserve(1 + s2.size()); t ~= s1; t ~= s2; return t; }+/
}

/+ namespace Qt {
#if QT_DEPRECATED_SINCE(5, 0)
QT_DEPRECATED inline QString escape(const QString &plain) {
    return plain.toHtmlEscaped();
}
#endif
} +/

extern(C++, "QtPrivate") {
// used by qPrintable() and qUtf8Printable() macros
// pragma(inline, true) ref const(QString) asString(ref const(QString) s)    { return s; }
/+ inline QString &&asString(QString &&s)              { return std::move(s); } +/
}

//
// QStringView::arg() implementation
//

extern(C++, "QtPrivate") {

struct ArgBase {
    enum Tag : uchar { L1, U8, U16 }Tag tag;
}

/+struct QStringViewArg {
    ArgBase base0;
    alias base0 this;
    QStringView string;
    /+ QStringViewArg() = default; +/
    /+ explicit +/this(QStringView v)/+ noexcept+/
    {
        this.base0 = ArgBase(ArgBase(Tag.U16));
        this.string = typeof(this.string)(QStringView(v));
    }
}+/

/+struct QLatin1StringArg {
    ArgBase base0;
    alias base0 this;
    QLatin1String string;
    /+ QLatin1StringArg() = default; +/
    /+ explicit +/this(QLatin1String v)/+ noexcept+/
    {
        this.base0 = ArgBase(ArgBase(Tag.L1));
        this.string = typeof(this.string)(QLatin1String(v));
    }
}+/

/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ QString argToQString(QStringView pattern, size_t n, const(ArgBase)** args);
/+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ QString argToQString(QLatin1String pattern, size_t n, const(ArgBase)** args);

/+
/+ Q_REQUIRED_RESULT +/ /+ Q_ALWAYS_INLINE +/ pragma(inline, true) QString argToQStringDispatch(StringView, Args)(StringView pattern, ref const(Args) args)
{
    /+ const(ArgBase)*[0]  +/ auto argBases = mixin(buildStaticArray!(q{const(ArgBase)*}, q{cast(const(ArgBase)*)(&args)..., /* avoid zero-sized array */ null}));
    return /+ QtPrivate:: +/argToQString(pattern, sizeof...(Args), argBases.ptr);
}+/

/+
                 pragma(inline, true) QStringViewArg   qStringLikeToArg(ref const(QString) s)/+ noexcept+/ { return QStringViewArg{qToStringViewIgnoringNull(s)}; }
pragma(inline, true) QStringViewArg   qStringLikeToArg(QStringView s)/+ noexcept+/ { return QStringViewArg{s}; }
                 pragma(inline, true) QStringViewArg   qStringLikeToArg(ref const(QChar) c)/+ noexcept+/ { return QStringViewArg{QStringView{&c, 1}}; }
pragma(inline, true) QLatin1StringArg qStringLikeToArg(QLatin1String s)/+ noexcept+/ { return QLatin1StringArg{s}; }
+/
} // namespace QtPrivate

/+ template <typename...Args>
Q_ALWAYS_INLINE
QString QStringView::arg(Args &&...args) const
{
    return QtPrivate::argToQStringDispatch(*this, QtPrivate::qStringLikeToArg(args)...);
}

template <typename...Args>
Q_ALWAYS_INLINE
QString QLatin1String::arg(Args &&...args) const
{
    return QtPrivate::argToQStringDispatch(*this, QtPrivate::qStringLikeToArg(args)...);
}


#if defined(QT_USE_FAST_OPERATOR_PLUS) || defined(QT_USE_QSTRINGBUILDER)
#endif +/

