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
import qt.core.anystringview;
import qt.core.bytearray;
import qt.core.bytearrayview;
import qt.core.global;
import qt.core.namespace;
import qt.core.string;
import qt.core.typeinfo;
import qt.helpers;
version (Cygwin) {} else
version (Windows)
    import core.stdc.config;
static if (defined!"QT_CORE_BUILD_REMOVED_API")
    import qt.core.stringview;

version (Cygwin) {} else
version (Windows)
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



/// Binding for C++ class [QUuid](https://doc.qt.io/qt-6/quuid.html).
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

    @disable this();
    /+this()/+ noexcept+/
    {
        this.data1 = 0;
        this.data2 = 0;
        this.data3 = 0;
        this.data4 = [0,0,0,0,0,0,0,0];
    }+/

    this(uint l, ushort w1, ushort w2, uchar b1, uchar b2, uchar b3,
                               uchar b4, uchar b5, uchar b6, uchar b7, uchar b8)/+ noexcept+/
    {
        this.data1 = l;
        this.data2 = w1;
        this.data3 = w2;
        this.data4 = [b1, b2, b3, b4, b5, b6, b7, b8];
    }

    /+ explicit +/this(QAnyStringView string)/+ noexcept+/
    {
        this = fromString(string);
    }
    static QUuid fromString(QAnyStringView string)/+ noexcept+/;
    static if (defined!"QT_CORE_BUILD_REMOVED_API")
    {
        /+ explicit +/this(ref const(QString) );
        static QUuid fromString(QStringView string)/+ noexcept+/;
        static QUuid fromString(QLatin1String string)/+ noexcept+/;
        /+ explicit +/this(const(char)* );
        /+ explicit +/this(ref const(QByteArray) );
    }
    QString toString(StringFormat mode = StringFormat.WithBraces) const;
    QByteArray toByteArray(StringFormat mode = StringFormat.WithBraces) const;
    QByteArray toRfc4122() const;
    static if (defined!"QT_CORE_BUILD_REMOVED_API")
    {
        static QUuid fromRfc4122(ref const(QByteArray) );
    }
    static QUuid fromRfc4122(QByteArrayView)/+ noexcept+/;
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

    version (Cygwin) {} else
    version (Windows)
    {
        // On Windows we have a type GUID that is used by the platform API, so we
        // provide convenience operators to cast from and to this type.
        this(ref const(GUID) guid)/+ noexcept+/
        {
            this.data1 = guid.Data1;
            this.data2 = guid.Data2;
            this.data3 = guid.Data3;
            this.data4 = [guid.Data4[0], guid.Data4[1], guid.Data4[2], guid.Data4[3],
                            guid.Data4[4], guid.Data4[5], guid.Data4[6], guid.Data4[7]];
        }

        /+ref QUuid operator =(ref const(GUID) guid)/+ noexcept+/
        {
            this = QUuid(guid);
            return this;
        }+/

        /+auto opCast(T : GUID)() const/+ noexcept+/
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

    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ static QUuid fromCFUUID(CFUUIDRef uuid); +/
        /+ CFUUIDRef toCFUUID() const Q_DECL_CF_RETURNS_RETAINED; +/
        /+ static QUuid fromNSUUID(const NSUUID *uuid); +/
        /+ NSUUID *toNSUUID() const Q_DECL_NS_RETURNS_AUTORELEASED; +/
    }

    uint    data1 = 0;
    ushort  data2 = 0;
    ushort  data3 = 0;
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

Q_CORE_EXPORT size_t qHash(const QUuid &uuid, size_t seed = 0) noexcept; +/

/+pragma(inline, true) bool operator <=(ref const(QUuid) lhs, ref const(QUuid) rhs)/+ noexcept+/
{ return !(rhs < lhs); }+/
/+pragma(inline, true) bool operator >=(ref const(QUuid) lhs, ref const(QUuid) rhs)/+ noexcept+/
{ return !(lhs < rhs); }+/

