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
module qt.core.datastream;
extern(C++):

import qt.config;
import qt.helpers;
version (QT_NO_DATASTREAM) {} else
{
    import qt.core.bytearray;
    import qt.core.global;
    import qt.core.iodevice;
    import qt.core.scopedpointer;
    import qt.core.sysinfo;
}


/+ #ifdef Status
#error qdatastream.h must be included before any header file that defines Status
#endif



template <typename T> class QSet; +/

version (QT_NO_DATASTREAM) {} else
{
extern(C++, class) struct QDataStreamPrivate;
/+ namespace QtPrivate {
class StreamStateSaver;
} +/
/// Binding for C++ class [QDataStream](https://doc.qt.io/qt-5/qdatastream.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QDataStream
{
public:
    enum Version {
        Qt_1_0 = 1,
        Qt_2_0 = 2,
        Qt_2_1 = 3,
        Qt_3_0 = 4,
        Qt_3_1 = 5,
        Qt_3_3 = 6,
        Qt_4_0 = 7,
        Qt_4_1 = Version.Qt_4_0,
        Qt_4_2 = 8,
        Qt_4_3 = 9,
        Qt_4_4 = 10,
        Qt_4_5 = 11,
        Qt_4_6 = 12,
        Qt_4_7 = Version.Qt_4_6,
        Qt_4_8 = Version.Qt_4_7,
        Qt_4_9 = Version.Qt_4_8,
        Qt_5_0 = 13,
        Qt_5_1 = 14,
        Qt_5_2 = 15,
        Qt_5_3 = Version.Qt_5_2,
        Qt_5_4 = 16,
        Qt_5_5 = Version.Qt_5_4,
        Qt_5_6 = 17,
        Qt_5_7 = Version.Qt_5_6,
        Qt_5_8 = Version.Qt_5_7,
        Qt_5_9 = Version.Qt_5_8,
        Qt_5_10 = Version.Qt_5_9,
        Qt_5_11 = Version.Qt_5_10,
        Qt_5_12 = 18,
        Qt_5_13 = 19,
        Qt_5_14 = Version.Qt_5_13,
/+ #if QT_VERSION >= 0x050f00 +/
        Qt_5_15 = Version.Qt_5_14,
        Qt_DefaultCompiledVersion = Version.Qt_5_15
/+ #elif QT_VERSION >= 0x060000
        Qt_6_0 = Qt_5_15,
        Qt_DefaultCompiledVersion = Qt_6_0
#else
        Qt_DefaultCompiledVersion = Qt_5_14
#endif
#if QT_VERSION >= 0x060100
#error Add the datastream version for this Qt version and update Qt_DefaultCompiledVersion
#endif +/
    }

    enum ByteOrder {
        BigEndian = QSysInfo.Endian.BigEndian,
        LittleEndian = QSysInfo.Endian.LittleEndian
    }

    enum Status {
        Ok,
        ReadPastEnd,
        ReadCorruptData,
        WriteFailed
    }

    enum FloatingPointPrecision {
        SinglePrecision,
        DoublePrecision
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

    /+ explicit +/this(QIODevice );
    this(QByteArray* , QIODevice.OpenMode flags);
    this(ref const(QByteArray) );
    ~this();

    pragma(inline, true) QIODevice device() const
    { return cast(QIODevice)dev; }
    void setDevice(QIODevice );
/+ #if QT_DEPRECATED_SINCE(5, 13) +/
    /+ QT_DEPRECATED_X("Use QDataStream::setDevice(nullptr) instead") +/
        void unsetDevice();
/+ #endif +/

    bool atEnd() const;

    Status status() const;
    void setStatus(Status status);
    void resetStatus();

    FloatingPointPrecision floatingPointPrecision() const;
    void setFloatingPointPrecision(FloatingPointPrecision precision);

    pragma(inline, true) ByteOrder byteOrder() const
    { return byteorder; }
    void setByteOrder(ByteOrder);

    pragma(inline, true) int version_() const
    { return ver; }
    pragma(inline, true) void setVersion(int v)
    { ver = v; }

    /+ref QDataStream operator >>(ref qint8 i);+/
    /+pragma(inline, true) ref QDataStream operator >>(ref quint8 i)
    { return this >> reinterpret_cast!(ref qint8)(i); }+/
    /+ref QDataStream operator >>(ref qint16 i);+/
    /+pragma(inline, true) ref QDataStream operator >>(ref quint16 i)
    { return this >> reinterpret_cast!(ref qint16)(i); }+/
    /+ref QDataStream operator >>(ref qint32 i);+/
    /+pragma(inline, true) ref QDataStream operator >>(ref quint32 i)
    { return this >> reinterpret_cast!(ref qint32)(i); }+/
    /+ref QDataStream operator >>(ref qint64 i);+/
    /+pragma(inline, true) ref QDataStream operator >>(ref quint64 i)
    { return this >> reinterpret_cast!(ref qint64)(i); }+/
    /+ref QDataStream operator >>(ref /+ std:: +/nullptr_t ptr) { ptr = null; return this; }+/

    /+ref QDataStream operator >>(ref bool i);+/
    /+ref QDataStream operator >>(ref qfloat16 f);+/
    /+ref QDataStream operator >>(ref float f);+/
    /+ref QDataStream operator >>(ref double f);+/
    /+ref QDataStream operator >>(ref char* str);+/

    /+ref QDataStream operator <<(qint8 i);+/
    /+pragma(inline, true) ref QDataStream operator <<(quint8 i)
    { return this << qint8(i); }+/
    /+ref QDataStream operator <<(qint16 i);+/
    /+pragma(inline, true) ref QDataStream operator <<(quint16 i)
    { return this << qint16(i); }+/
    /+ref QDataStream operator <<(qint32 i);+/
    /+pragma(inline, true) ref QDataStream operator <<(quint32 i)
    { return this << qint32(i); }+/
    /+ref QDataStream operator <<(qint64 i);+/
    /+pragma(inline, true) ref QDataStream operator <<(quint64 i)
    { return this << qint64(i); }+/
    /+ref QDataStream operator <<(/+ std:: +/nullptr_t) { return this; }+/
    /+ref QDataStream operator <<(bool i);+/
    /+ref QDataStream operator <<(qfloat16 f);+/
    /+ref QDataStream operator <<(float f);+/
    /+ref QDataStream operator <<(double f);+/
    /+ref QDataStream operator <<(const(char)* str);+/

    ref QDataStream readBytes(ref char* , ref uint len);
    int readRawData(char* , int len);

    ref QDataStream writeBytes(const(char)* , uint len);
    int writeRawData(const(char)* , int len);

    int skipRawData(int len);

    void startTransaction();
    bool commitTransaction();
    void rollbackTransaction();
    void abortTransaction();

private:
    /+ Q_DISABLE_COPY(QDataStream) +/
@disable this(this);
/+this(ref const(QDataStream));+//+ref QDataStream operator =(ref const(QDataStream));+/
    QScopedPointer!(QDataStreamPrivate) d;

    QIODevice dev;
    bool owndev;
    bool noswap;
    ByteOrder byteorder;
    int ver;
    Status q_status;

    int readBlock(char* data, int len);
    /+ friend class QtPrivate::StreamStateSaver; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ namespace QtPrivate {

class StreamStateSaver
{
public:
    inline StreamStateSaver(QDataStream *s) : stream(s), oldStatus(s->status())
    {
        if (!stream->dev || !stream->dev->isTransactionStarted())
            stream->resetStatus();
    }
    inline ~StreamStateSaver()
    {
        if (oldStatus != QDataStream::Ok) {
            stream->resetStatus();
            stream->setStatus(oldStatus);
        }
    }

private:
    QDataStream *stream;
    QDataStream::Status oldStatus;
};

template <typename Container>
QDataStream &readArrayBasedContainer(QDataStream &s, Container &c)
{
    StreamStateSaver stateSaver(&s);

    c.clear();
    quint32 n;
    s >> n;
    c.reserve(n);
    for (quint32 i = 0; i < n; ++i) {
        typename Container::value_type t;
        s >> t;
        if (s.status() != QDataStream::Ok) {
            c.clear();
            break;
        }
        c.append(t);
    }

    return s;
}

template <typename Container>
QDataStream &readListBasedContainer(QDataStream &s, Container &c)
{
    StreamStateSaver stateSaver(&s);

    c.clear();
    quint32 n;
    s >> n;
    for (quint32 i = 0; i < n; ++i) {
        typename Container::value_type t;
        s >> t;
        if (s.status() != QDataStream::Ok) {
            c.clear();
            break;
        }
        c << t;
    }

    return s;
}

template <typename T>
struct MultiContainer { using type = T; };
template <typename K, typename V>
struct MultiContainer<QMap<K, V>> { using type = QMultiMap<K, V>; };
template <typename K, typename V>
struct MultiContainer<QHash<K, V>> { using type = QMultiHash<K, V>; };

template <typename Container>
QDataStream &readAssociativeContainer(QDataStream &s, Container &c)
{
    StreamStateSaver stateSaver(&s);

    c.clear();
    quint32 n;
    s >> n;
    for (quint32 i = 0; i < n; ++i) {
        typename Container::key_type k;
        typename Container::mapped_type t;
        s >> k >> t;
        if (s.status() != QDataStream::Ok) {
            c.clear();
            break;
        }
        static_cast<typename MultiContainer<Container>::type &>(c).insert(k, t);
    }

    return s;
}

template <typename Container>
QDataStream &writeSequentialContainer(QDataStream &s, const Container &c)
{
    s << quint32(c.size());
    for (const typename Container::value_type &t : c)
        s << t;

    return s;
}

template <typename Container>
QDataStream &writeAssociativeContainer(QDataStream &s, const Container &c)
{
    s << quint32(c.size());
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) && QT_DEPRECATED_SINCE(5, 15)
    // Deserialization should occur in the reverse order.
    // Otherwise, value() will return the least recently inserted
    // value instead of the most recently inserted one.
    auto it = c.constEnd();
    auto begin = c.constBegin();
    while (it != begin) {
        QT_WARNING_PUSH
        QT_WARNING_DISABLE_DEPRECATED
        --it;
        QT_WARNING_POP
        s << it.key() << it.value();
    }
#else
    auto it = c.constBegin();
    auto end = c.constEnd();
    while (it != end) {
        const auto rangeStart = it++;
        while (it != end && rangeStart.key() == it.key())
            ++it;
        const qint64 last = std::distance(rangeStart, it) - 1;
        for (qint64 i = last; i >= 0; --i) {
            auto next = std::next(rangeStart, i);
            s << next.key() << next.value();
        }
    }
#endif

    return s;
}

} // QtPrivate namespace

/*****************************************************************************
  QDataStream inline functions
 *****************************************************************************/

template <typename Enum>
inline QDataStream &operator<<(QDataStream &s, QFlags<Enum> e)
{ return s << e.i; }

template <typename Enum>
inline QDataStream &operator>>(QDataStream &s, QFlags<Enum> &e)
{ return s >> e.i; }

template <typename T>
typename std::enable_if<std::is_enum<T>::value, QDataStream &>::type&
operator<<(QDataStream &s, const T &t)
{ return s << static_cast<typename std::underlying_type<T>::type>(t); }

template <typename T>
typename std::enable_if<std::is_enum<T>::value, QDataStream &>::type&
operator>>(QDataStream &s, T &t)
{ return s >> reinterpret_cast<typename std::underlying_type<T>::type &>(t); }

template <typename T>
inline QDataStream &operator>>(QDataStream &s, QList<T> &l)
{
    return QtPrivate::readArrayBasedContainer(s, l);
}

template <typename T>
inline QDataStream &operator<<(QDataStream &s, const QList<T> &l)
{
    return QtPrivate::writeSequentialContainer(s, l);
}

template<typename T>
inline QDataStream &operator>>(QDataStream &s, QVector<T> &v)
{
    return QtPrivate::readArrayBasedContainer(s, v);
}

template<typename T>
inline QDataStream &operator<<(QDataStream &s, const QVector<T> &v)
{
    return QtPrivate::writeSequentialContainer(s, v);
}

template <typename T>
inline QDataStream &operator>>(QDataStream &s, QSet<T> &set)
{
    return QtPrivate::readListBasedContainer(s, set);
}

template <typename T>
inline QDataStream &operator<<(QDataStream &s, const QSet<T> &set)
{
    return QtPrivate::writeSequentialContainer(s, set);
}

template <class Key, class T>
inline QDataStream &operator>>(QDataStream &s, QHash<Key, T> &hash)
{
    return QtPrivate::readAssociativeContainer(s, hash);
}

template <class Key, class T>
inline QDataStream &operator<<(QDataStream &s, const QHash<Key, T> &hash)
{
    return QtPrivate::writeAssociativeContainer(s, hash);
}

template <class Key, class T>
inline QDataStream &operator>>(QDataStream &s, QMap<Key, T> &map)
{
    return QtPrivate::readAssociativeContainer(s, map);
}

template <class Key, class T>
inline QDataStream &operator<<(QDataStream &s, const QMap<Key, T> &map)
{
    return QtPrivate::writeAssociativeContainer(s, map);
}

#ifndef QT_NO_DATASTREAM
template <class T1, class T2>
inline QDataStream& operator>>(QDataStream& s, QPair<T1, T2>& p)
{
    s >> p.first >> p.second;
    return s;
}

template <class T1, class T2>
inline QDataStream& operator<<(QDataStream& s, const QPair<T1, T2>& p)
{
    s << p.first << p.second;
    return s;
}
#endif +/

}


version (QT_NO_DATASTREAM)
{
extern(C++, class) struct QDataStream;
}



