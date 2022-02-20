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
module qt.core.uuid;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.global;
import qt.core.namespace;
import qt.core.string;
import qt.core.stringview;
import qt.core.typeinfo;
import qt.helpers;
version(Cygwin){}else
version(Windows)
    import core.stdc.config;

version(Cygwin){}else
version(Windows)
{
/+ #ifndef GUID_DEFINED +/
/+ #define GUID_DEFINED +/
struct _GUID
{
    cpp_ulong   Data1;
    ushort  Data2;
    ushort  Data3;
    uchar[8]   Data4;
}
alias GUID = _GUID/+ , +/;
alias REFGUID = _GUID */+ , +/;
alias LPGUID = _GUID *;
/+ #endif +/
}

/+ #if defined(Q_OS_DARWIN) || defined(Q_CLANG_QDOC)
Q_FORWARD_DECLARE_CF_TYPE(CFUUID);
Q_FORWARD_DECLARE_OBJC_CLASS(NSUUID);
#endif +/



/// Binding for C++ class [QUuid](https://doc.qt.io/qt-5/quuid.html).
@Q_PRIMITIVE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QUuid
{
private:
    this(/+ Qt:: +/qt.core.namespace.Initialization) {}
public:
    enum Variant {
        VarUnknown        =-1,
        NCS                = 0, // 0 - -
        DCE                = 2, // 1 0 -
        Microsoft        = 6, // 1 1 0
        Reserved        = 7  // 1 1 1
    }

    enum Version {
        VerUnknown        =-1,
        Time                = 1, // 0 0 0 1
        EmbeddedPOSIX        = 2, // 0 0 1 0
        Md5                 = 3, // 0 0 1 1
        Name = Version.Md5,
        Random                = 4,  // 0 1 0 0
        Sha1                 = 5 // 0 1 0 1
    }

    enum StringFormat {
        WithBraces      = 0,
        WithoutBraces   = 1,
        Id128           = 3
    }

/+ #if defined(Q_COMPILER_UNIFORM_INIT) && !defined(Q_CLANG_QDOC)

    QUuid() noexcept : data1(0), data2(0), data3(0), data4{0,0,0,0,0,0,0,0} {}

    QUuid(uint l, ushort w1, ushort w2, uchar b1, uchar b2, uchar b3,
                           uchar b4, uchar b5, uchar b6, uchar b7, uchar b8) noexcept
        : data1(l), data2(w1), data3(w2), data4{b1, b2, b3, b4, b5, b6, b7, b8} {}
#else +/
    @disable this();
    /+this()/+ noexcept+/
    {
        data1 = 0;
        data2 = 0;
        data3 = 0;
        for(int i = 0; i < 8; i++)
            data4[i] = 0;
    }+/
    this(uint l, ushort w1, ushort w2, uchar b1, uchar b2, uchar b3, uchar b4, uchar b5, uchar b6, uchar b7, uchar b8)/+ noexcept+/
    {
        data1 = l;
        data2 = w1;
        data3 = w2;
        data4[0] = b1;
        data4[1] = b2;
        data4[2] = b3;
        data4[3] = b4;
        data4[4] = b5;
        data4[5] = b6;
        data4[6] = b7;
        data4[7] = b8;
    }
/+ #endif +/

    this(ref const(QString) );
    static QUuid fromString(QStringView string)/+ noexcept+/;
    static QUuid fromString(QLatin1String string)/+ noexcept+/;
    this(const(char)* );
    QString toString() const;
    QString toString(StringFormat mode) const; // ### Qt6: merge with previous
    this(ref const(QByteArray) );
    QByteArray toByteArray() const;
    QByteArray toByteArray(StringFormat mode) const; // ### Qt6: merge with previous
    QByteArray toRfc4122() const;
    static QUuid fromRfc4122(ref const(QByteArray) );
    bool isNull() const/+ noexcept+/;

    /+bool operator ==(ref const(QUuid) orig) const/+ noexcept+/
    {
        if (data1 != orig.data1 || data2 != orig.data2 ||
             data3 != orig.data3)
            return false;

        for (uint i = 0; i < 8; i++)
            if (data4[i] != orig.data4[i])
                return false;

        return true;
    }+/

    /+bool operator !=(ref const(QUuid) orig) const/+ noexcept+/
    {
        return !(this == orig);
    }+/

    /+bool operator <(ref const(QUuid) other) const/+ noexcept+/;+/
    /+bool operator >(ref const(QUuid) other) const/+ noexcept+/;+/

/+ #if defined(Q_OS_WIN) || defined(Q_CLANG_QDOC)
    // On Windows we have a type GUID that is used by the platform API, so we
    // provide convenience operators to cast from and to this type.
#if defined(Q_COMPILER_UNIFORM_INIT) && !defined(Q_CLANG_QDOC)
    QUuid(const GUID &guid) noexcept
        : data1(guid.Data1), data2(guid.Data2), data3(guid.Data3),
          data4{guid.Data4[0], guid.Data4[1], guid.Data4[2], guid.Data4[3],
                guid.Data4[4], guid.Data4[5], guid.Data4[6], guid.Data4[7]} {}
#else +/
    static if((versionIsSet!("Windows") && !versionIsSet!("Cygwin")))
    {
        this(ref const(GUID) guid)/+ noexcept+/
        {
            data1 = cast(uint)(guid.Data1);
            data2 = guid.Data2;
            data3 = guid.Data3;
            for(int i = 0; i < 8; i++)
                data4[i] = guid.Data4[i];
        }
    /+ #endif +/

        /+ref QUuid operator =(ref const(GUID) guid)/+ noexcept+/
        {
            this = QUuid(guid);
            return this;
        }+/

        /+ auto opCast(T : GUID)() const/+ noexcept+/
        {
            GUID guid = _GUID( data1, data2, data3, [ data4[0], data4[1], data4[2], data4[3], data4[4], data4[5], data4[6], data4[7]] ) ;
            return guid;
        }+/

        /+bool operator ==(ref const(GUID) guid) const/+ noexcept+/
        {
            return this == QUuid(guid);
        }+/

        /+bool operator !=(ref const(GUID) guid) const/+ noexcept+/
        {
            return !(this == guid);
        }+/
    }
/+ #endif +/
    static QUuid createUuid();
/+ #ifndef QT_BOOTSTRAPPED +/
    static QUuid createUuidV3(ref const(QUuid) ns, ref const(QByteArray) baseData);
/+ #endif +/
    static QUuid createUuidV5(ref const(QUuid) ns, ref const(QByteArray) baseData);
/+ #ifndef QT_BOOTSTRAPPED +/
    pragma(inline, true) static QUuid createUuidV3(ref const(QUuid) ns, ref const(QString) baseData)
    {
        auto tmp = baseData.toUtf8(); return QUuid.createUuidV3(ns, tmp);
    }
/+ #endif +/

    pragma(inline, true) static QUuid createUuidV5(ref const(QUuid) ns, ref const(QString) baseData)
    {
        auto tmp = baseData.toUtf8(); return QUuid.createUuidV5(ns, tmp);
    }


    Variant variant() const/+ noexcept+/;
    //Version version_() const/+ noexcept+/;

    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ static QUuid fromCFUUID(CFUUIDRef uuid); +/
        /+ CFUUIDRef toCFUUID() const Q_DECL_CF_RETURNS_RETAINED; +/
        /+ static QUuid fromNSUUID(const NSUUID *uuid); +/
        /+ NSUUID *toNSUUID() const Q_DECL_NS_RETURNS_AUTORELEASED; +/
    }

    uint    data1;
    ushort  data2;
    ushort  data3;
    uchar[8]   data4;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QUuid, Q_PRIMITIVE_TYPE);

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QUuid &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QUuid &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QUuid &);
#endif

Q_CORE_EXPORT uint qHash(const QUuid &uuid, uint seed = 0) noexcept; +/

/+pragma(inline, true) bool operator <=(ref const(QUuid) lhs, ref const(QUuid) rhs)/+ noexcept+/
{ return !(rhs < lhs); }+/
/+pragma(inline, true) bool operator >=(ref const(QUuid) lhs, ref const(QUuid) rhs)/+ noexcept+/
{ return !(lhs < rhs); }+/

