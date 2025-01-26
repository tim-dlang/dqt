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
module qt.core.bitarray;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.global;
import qt.core.sysinfo;
import qt.core.typeinfo;
import qt.helpers;

/// Binding for C++ class [QBitArray](https://doc.qt.io/qt-6/qbitarray.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QBitArray
{
private:
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QBitArray &); +/
        /+ friend Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QBitArray &); +/
    }
    /+ friend Q_CORE_EXPORT size_t qHash(const QBitArray &key, size_t seed) noexcept; +/
    QByteArray d;

public:
    @disable this();
    /+pragma(inline, true) this()/+ noexcept+/ {}+/
    /+ explicit +/this(qsizetype size, bool val = false);
    /+pragma(inline, true) ref QBitArray operator =(ref const(QBitArray) other) { d = other.d; return this; }+/
    /+ inline QBitArray(QBitArray &&other) noexcept : d(std::move(other.d)) {} +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QBitArray) +/

    /+ void swap(QBitArray &other) noexcept { d.swap(other.d); } +/

    pragma(inline, true) qsizetype size() const { return (d.size() << 3) - *d.constData(); }
    pragma(inline, true) qsizetype count() const { return (d.size() << 3) - *d.constData(); }
    qsizetype count(bool on) const;

    pragma(inline, true) bool isEmpty() const { return d.isEmpty(); }
    pragma(inline, true) bool isNull() const { return d.isNull(); }

    void resize(qsizetype size);

    pragma(inline, true) void detach() { d.detach(); }
    pragma(inline, true) bool isDetached() const { return d.isDetached(); }
    pragma(inline, true) void clear() { d.clear(); }

    pragma(inline, true) bool testBit(qsizetype i) const
    { (mixin(Q_ASSERT(q{size_t(i) < size_t(QBitArray.size())})));
     return (*(reinterpret_cast!(const(uchar)*)(d.constData())+1+(i>>3)) & (1 << (i & 7))) != 0; }
    pragma(inline, true) void setBit(qsizetype i)
    { (mixin(Q_ASSERT(q{size_t(i) < size_t(QBitArray.size())})));
     *(reinterpret_cast!(uchar*)(d.data())+1+(i>>3)) |= cast(uchar) (1 << (i & 7)); }
    pragma(inline, true) void setBit(qsizetype i, bool val)
    { if (val) setBit(i); else clearBit(i); }
    pragma(inline, true) void clearBit(qsizetype i)
    { (mixin(Q_ASSERT(q{size_t(i) < size_t(QBitArray.size())})));
     *(reinterpret_cast!(uchar*)(d.data())+1+(i>>3)) &= ~int(uchar(1 << (i & 7))); }
    pragma(inline, true) bool toggleBit(qsizetype i)
    { (mixin(Q_ASSERT(q{size_t(i) < size_t(QBitArray.size())})));
     uchar b = cast(uchar) (1<<(i&7)); uchar* p = reinterpret_cast!(uchar*)(d.data())+1+(i>>3);
     uchar c = cast(uchar) (*p&b); *p^=b; return c!=0; }

    pragma(inline, true) bool at(qsizetype i) const { return testBit(i); }
    pragma(inline, true) QBitRef opIndex(qsizetype i)
    { (mixin(Q_ASSERT(q{i >= 0}))); return QBitRef(this, i); }
    pragma(inline, true) bool opIndex(qsizetype i) const { return testBit(i); }

    ref QBitArray opOpAssign(string op)(ref const(QBitArray) ) if (op == "&");
    ref QBitArray opOpAssign(string op)(ref const(QBitArray) ) if (op == "|");
    /+ref QBitArray operator ^=(ref const(QBitArray) );+/
    /+QBitArray operator ~() const;+/

    /+pragma(inline, true) bool operator ==(ref const(QBitArray) other) const { return d == other.d; }+/
    /+pragma(inline, true) bool operator !=(ref const(QBitArray) other) const { return d != other.d; }+/

    pragma(inline, true) bool fill(bool aval, qsizetype asize = -1)
    { this = QBitArray((asize < 0 ? this.size() : asize), aval); return true; }
    void fill(bool val, qsizetype first, qsizetype last);

    pragma(inline, true) void truncate(qsizetype pos) { if (pos < size()) resize(pos); }

    const(char)* bits() const { return isEmpty() ? null : d.constData() + 1; }
    static QBitArray fromBits(const(char)* data, qsizetype len);

    quint32 toUInt32(QSysInfo.Endian endianness, bool* ok = null) const/+ noexcept+/;

public:
    alias DataPtr = QByteArray.DataPointer;
    pragma(inline, true) ref DataPtr data_ptr() return { return d.data_ptr(); }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+/+ Q_CORE_EXPORT +/ QBitArray operator &(ref const(QBitArray) , ref const(QBitArray) );+/
/+/+ Q_CORE_EXPORT +/ QBitArray operator |(ref const(QBitArray) , ref const(QBitArray) );+/
/+/+ Q_CORE_EXPORT +/ QBitArray operator ^(ref const(QBitArray) , ref const(QBitArray) );+/

extern(C++, class) struct /+ Q_CORE_EXPORT +/ QBitRef
{
private:
    QBitArray *a;
    qsizetype i;
    pragma(inline, true) this(ref QBitArray array, qsizetype idx)
    {
        this.a = &array;
        this.i = idx;
    }
    /+ friend class QBitArray; +/

public:
    /+pragma(inline, true) auto opCast(T : bool)() const { return a.testBit(i); }+/
    /+pragma(inline, true) bool operator !() const { return !a.testBit(i); }+/
    /+ref QBitRef operator =(ref const(QBitRef) val) { a.setBit(i, val); return this; }+/
    /+ref QBitRef operator =(bool val) { a.setBit(i, val); return this; }+/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QBitArray &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QBitArray &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QBitArray &);
#endif

Q_DECLARE_SHARED(QBitArray) +/

