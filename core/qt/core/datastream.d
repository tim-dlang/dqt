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
static if (defined!"QT_CORE_BUILD_REMOVED_API" && !versionIsSet!("QT_NO_DATASTREAM"))
    import qt.core.float16;
version (QT_NO_DATASTREAM) {} else
{
    import qt.core.bytearray;
    import qt.core.global;
    import qt.core.iodevice;
    import qt.core.iodevicebase;
    import qt.core.scopedpointer;
    import qt.core.sysinfo;
}


/+ #ifdef Status
#error qdatastream.h must be included before any header file that defines Status
#endif


#if QT_CORE_REMOVED_SINCE(6, 3)
class qfloat16;
#endif +/

version (QT_NO_DATASTREAM) {} else
{
extern(C++, class) struct QDataStreamPrivate;
/+ namespace QtPrivate {
class StreamStateSaver;
} +/
/// Binding for C++ class [QDataStream](https://doc.qt.io/qt-6/qdatastream.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QDataStream
{
    /*public QIODeviceBase base0;
    alias base0 this;*/
    alias OpenModeFlag = QIODeviceBase.OpenModeFlag;
    alias OpenMode = QIODeviceBase.OpenMode;
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
        Qt_5_15 = Version.Qt_5_14,
        Qt_6_0 = 20,
        Qt_6_1 = Version.Qt_6_0,
        Qt_6_2 = Version.Qt_6_0,
        Qt_6_3 = Version.Qt_6_0,
        Qt_DefaultCompiledVersion = Version.Qt_6_3
/+ #if QT_VERSION >= QT_VERSION_CHECK(6, 4, 0)
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
    this(QByteArray* , OpenMode flags);
    this(ref const(QByteArray) );
    ~this();

    pragma(inline, true) QIODevice device() const
    { return cast(QIODevice)dev; }
    void setDevice(QIODevice );

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

    /+pragma(inline, true) ref QDataStream operator >>(ref char i)
    { return this >> reinterpret_cast!(ref qint8)(i); }+/
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
    static if (defined!"QT_CORE_BUILD_REMOVED_API")
    {
        /+ref QDataStream operator >>(ref qfloat16 f);+/
    }
    /+ref QDataStream operator >>(ref float f);+/
    /+ref QDataStream operator >>(ref double f);+/
    /+ref QDataStream operator >>(ref char* str);+/
    /+ref QDataStream operator >>(ref wchar c);+/
    /+ref QDataStream operator >>(ref dchar c);+/

    /+pragma(inline, true) ref QDataStream operator <<(char i)
    { return this << qint8(i); }+/
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
    static if (defined!"QT_CORE_BUILD_REMOVED_API")
    {
        /+ref QDataStream operator <<(qfloat16 f);+/
    }
    /+ref QDataStream operator <<(float f);+/
    /+ref QDataStream operator <<(double f);+/
    /+ref QDataStream operator <<(const(char)* str);+/
    /+ref QDataStream operator <<(wchar c);+/
    /+ref QDataStream operator <<(dchar c);+/


    ref QDataStream readBytes(ref char* , ref uint len);
    int readRawData(char* , int len);

    ref QDataStream writeBytes(const(char)* , uint len);
    int writeRawData(const(char)* , int len);

    int skipRawData(int len);

    void startTransaction();
    bool commitTransaction();
    void rollbackTransaction();
    void abortTransaction();

    bool isDeviceTransactionStarted() const;
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

extern(C++, "QtPrivate") {

/+ class StreamStateSaver
{
public:
    inline StreamStateSaver(QDataStream *s) : stream(s), oldStatus(s->status())
    {
        if (!stream->isDeviceTransactionStarted())
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
        c.insert(k, t);
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
    auto it = c.constBegin();
    auto end = c.constEnd();
    while (it != end) {
        s << it.key() << it.value();
        ++it;
    }

    return s;
} +/

/+ref QDataStream writeAssociativeMultiContainer(Container)(ref QDataStream s, ref const(Container) c)
{
    s << quint32(c.size());
    auto it = c.constBegin();
    auto end = c.constEnd();
    while (it != end) {
        const rangeStart = it++;
        while (it != end && rangeStart.key() == it.key())
            ++it;
        const(qint64) last = /+ std:: +/distance(rangeStart, it) - 1;
        for (qint64 i = last; i >= 0; --i) {
            auto next = /+ std:: +/next(rangeStart, i);
            s << next.key() << next.value();
        }
    }

    return s;
}+/

} // QtPrivate namespace

/+ template<typename ...T>
using QDataStreamIfHasOStreamOperators =
    std::enable_if_t<std::conjunction_v<QTypeTraits::has_ostream_operator<QDataStream, T>...>, QDataStream &>;
template<typename Container, typename ...T>
using QDataStreamIfHasOStreamOperatorsContainer =
    std::enable_if_t<std::conjunction_v<QTypeTraits::has_ostream_operator_container<QDataStream, Container, T>...>, QDataStream &>;

template<typename ...T>
using QDataStreamIfHasIStreamOperators =
    std::enable_if_t<std::conjunction_v<QTypeTraits::has_istream_operator<QDataStream, T>...>, QDataStream &>;
template<typename Container, typename ...T>
using QDataStreamIfHasIStreamOperatorsContainer =
    std::enable_if_t<std::conjunction_v<QTypeTraits::has_istream_operator_container<QDataStream, Container, T>...>, QDataStream &>;

/*****************************************************************************
  QDataStream inline functions
 *****************************************************************************/

template <typename Enum>
inline QDataStream &operator<<(QDataStream &s, QFlags<Enum> e)
{ return s << typename QFlags<Enum>::Int(e); }

template <typename Enum>
inline QDataStream &operator>>(QDataStream &s, QFlags<Enum> &e)
{
    typename QFlags<Enum>::Int i;
    s >> i;
    e = QFlag(i);
    return s;
}

template <typename T>
typename std::enable_if_t<std::is_enum<T>::value, QDataStream &>
operator<<(QDataStream &s, const T &t)
{ return s << static_cast<typename std::underlying_type<T>::type>(t); }

template <typename T>
typename std::enable_if_t<std::is_enum<T>::value, QDataStream &>
operator>>(QDataStream &s, T &t)
{ return s >> reinterpret_cast<typename std::underlying_type<T>::type &>(t); }

#ifndef Q_CLANG_QDOC

template<typename T>
inline QDataStreamIfHasIStreamOperatorsContainer<QList<T>, T> operator>>(QDataStream &s, QList<T> &v)
{
    return QtPrivate::readArrayBasedContainer(s, v);
}

template<typename T>
inline QDataStreamIfHasOStreamOperatorsContainer<QList<T>, T> operator<<(QDataStream &s, const QList<T> &v)
{
    return QtPrivate::writeSequentialContainer(s, v);
}

template <typename T>
inline QDataStreamIfHasIStreamOperatorsContainer<QSet<T>, T> operator>>(QDataStream &s, QSet<T> &set)
{
    return QtPrivate::readListBasedContainer(s, set);
}

template <typename T>
inline QDataStreamIfHasOStreamOperatorsContainer<QSet<T>, T> operator<<(QDataStream &s, const QSet<T> &set)
{
    return QtPrivate::writeSequentialContainer(s, set);
}

template <class Key, class T>
inline QDataStreamIfHasIStreamOperatorsContainer<QHash<Key, T>, Key, T> operator>>(QDataStream &s, QHash<Key, T> &hash)
{
    return QtPrivate::readAssociativeContainer(s, hash);
}

template <class Key, class T>

inline QDataStreamIfHasOStreamOperatorsContainer<QHash<Key, T>, Key, T> operator<<(QDataStream &s, const QHash<Key, T> &hash)
{
    return QtPrivate::writeAssociativeContainer(s, hash);
}

template <class Key, class T>
inline QDataStreamIfHasIStreamOperatorsContainer<QMultiHash<Key, T>, Key, T> operator>>(QDataStream &s, QMultiHash<Key, T> &hash)
{
    return QtPrivate::readAssociativeContainer(s, hash);
}

template <class Key, class T>
inline QDataStreamIfHasOStreamOperatorsContainer<QMultiHash<Key, T>, Key, T> operator<<(QDataStream &s, const QMultiHash<Key, T> &hash)
{
    return QtPrivate::writeAssociativeMultiContainer(s, hash);
}

template <class Key, class T>
inline QDataStreamIfHasIStreamOperatorsContainer<QMap<Key, T>, Key, T> operator>>(QDataStream &s, QMap<Key, T> &map)
{
    return QtPrivate::readAssociativeContainer(s, map);
}

template <class Key, class T>
inline QDataStreamIfHasOStreamOperatorsContainer<QMap<Key, T>, Key, T> operator<<(QDataStream &s, const QMap<Key, T> &map)
{
    return QtPrivate::writeAssociativeContainer(s, map);
}

template <class Key, class T>
inline QDataStreamIfHasIStreamOperatorsContainer<QMultiMap<Key, T>, Key, T> operator>>(QDataStream &s, QMultiMap<Key, T> &map)
{
    return QtPrivate::readAssociativeContainer(s, map);
}

template <class Key, class T>
inline QDataStreamIfHasOStreamOperatorsContainer<QMultiMap<Key, T>, Key, T> operator<<(QDataStream &s, const QMultiMap<Key, T> &map)
{
    return QtPrivate::writeAssociativeMultiContainer(s, map);
}

template <class T1, class T2>
inline QDataStreamIfHasIStreamOperators<T1, T2> operator>>(QDataStream& s, std::pair<T1, T2> &p)
{
    s >> p.first >> p.second;
    return s;
}

template <class T1, class T2>
inline QDataStreamIfHasOStreamOperators<T1, T2> operator<<(QDataStream& s, const std::pair<T1, T2> &p)
{
    s << p.first << p.second;
    return s;
}

#else

template <class T>
QDataStream &operator>>(QDataStream &s, QList<T> &l);

template <class T>
QDataStream &operator<<(QDataStream &s, const QList<T> &l);

template <class T>
QDataStream &operator>>(QDataStream &s, QSet<T> &set);

template <class T>
QDataStream &operator<<(QDataStream &s, const QSet<T> &set);

template <class Key, class T>
QDataStream &operator>>(QDataStream &s, QHash<Key, T> &hash);

template <class Key, class T>
QDataStream &operator<<(QDataStream &s, const QHash<Key, T> &hash);

template <class Key, class T>
QDataStream &operator>>(QDataStream &s, QMultiHash<Key, T> &hash);

template <class Key, class T>
QDataStream &operator<<(QDataStream &s, const QMultiHash<Key, T> &hash);

template <class Key, class T>
QDataStream &operator>>(QDataStream &s, QMap<Key, T> &map);

template <class Key, class T>
QDataStream &operator<<(QDataStream &s, const QMap<Key, T> &map);

template <class Key, class T>
QDataStream &operator>>(QDataStream &s, QMultiMap<Key, T> &map);

template <class Key, class T>
QDataStream &operator<<(QDataStream &s, const QMultiMap<Key, T> &map);

template <class T1, class T2>
QDataStream &operator>>(QDataStream& s, std::pair<T1, T2> &p);

template <class T1, class T2>
QDataStream &operator<<(QDataStream& s, const std::pair<T1, T2> &p);

#endif // Q_CLANG_QDOC

inline QDataStream &operator>>(QDataStream &s, QKeyCombination &combination)
{
    int combined;
    s >> combined;
    combination = QKeyCombination::fromCombined(combined);
    return s;
}

inline QDataStream &operator<<(QDataStream &s, QKeyCombination combination)
{
    return s << combination.toCombined();
} +/

}

version (QT_NO_DATASTREAM) {} else
{
}

version (QT_NO_DATASTREAM)
{
extern(C++, class) struct QDataStream;
}




