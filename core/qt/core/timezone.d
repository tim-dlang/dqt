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
module qt.core.timezone;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.datetime;
import qt.core.list;
import qt.core.locale;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(timezone);

#if (defined(Q_OS_DARWIN) || defined(Q_QDOC)) && !defined(QT_NO_SYSTEMLOCALE)
Q_FORWARD_DECLARE_CF_TYPE(CFTimeZone);
Q_FORWARD_DECLARE_OBJC_CLASS(NSTimeZone);
#endif +/


extern(C++, class) struct QTimeZonePrivate;

/// Binding for C++ class [QTimeZone](https://doc.qt.io/qt-6/qtimezone.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QTimeZone
{
public:
    // Sane UTC offsets range from -14 to +14 hours:
    enum {
        // No known zone > 12 hrs West of Greenwich (Baker Island, USA)
        MinUtcOffsetSecs = -14 * 3600,
        // No known zone > 14 hrs East of Greenwich (Kiritimati, Christmas Island, Kiribati)
        MaxUtcOffsetSecs = +14 * 3600
    }

    enum TimeType {
        StandardTime = 0,
        DaylightTime = 1,
        GenericTime = 2
    }

    enum NameType {
        DefaultName = 0,
        LongName = 1,
        ShortName = 2,
        OffsetName = 3
    }

    // Workaround for https://issues.dlang.org/show_bug.cgi?id=20701
    @Q_RELOCATABLE_TYPE extern(C++, struct) struct OffsetData {
        QString abbreviation;
        QDateTime atUtc;
        int offsetFromUtc;
        int standardTimeOffset;
        int daylightTimeOffset;

        void rawConstructor()
        {
            import core.lifetime;
            this.abbreviation = QString.create;
      //TODO      emplace!QDateTime(&this.atUtc);
        }
    }
    //alias OffsetDataList = QList!(OffsetData);

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor()/+ noexcept+/;
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ explicit +/this(ref const(QByteArray) ianaId);
    /+ explicit +/this(int offsetSeconds);
    this(ref const(QByteArray) zoneId, int offsetSeconds, ref const(QString) name,
                  ref const(QString) abbreviation, QLocale.Territory territory = QLocale.Country.AnyTerritory,
                  ref const(QString) comment = globalInitVar!QString);
    @disable this(this);
    this(ref const(QTimeZone) other);
    ~this();

    /+ref QTimeZone operator =(ref const(QTimeZone) other);+/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QTimeZone) +/

    /+ void swap(QTimeZone &other) noexcept
    { d.swap(other.d); } +/

    /+bool operator ==(ref const(QTimeZone) other) const;+/
    /+bool operator !=(ref const(QTimeZone) other) const;+/

    bool isValid() const;

    QByteArray id() const;
    QLocale.Territory territory() const;
/+ #if QT_DEPRECATED_SINCE(6, 6) +/
    /+ QT_DEPRECATED_VERSION_X_6_6("Use territory() instead") +/
        QLocale.Country country() const;
/+ #endif +/
    QString comment() const;

    QString displayName(ref const(QDateTime) atDateTime,
                            NameType nameType/* = NameType.DefaultName*/,
                            ref const(QLocale) locale/* = globalInitVar!QLocale*/) const;
    QString displayName(TimeType timeType,
                            NameType nameType/* = NameType.DefaultName*/,
                            ref const(QLocale) locale/* = globalInitVar!QLocale*/) const;
    QString abbreviation(ref const(QDateTime) atDateTime) const;

    int offsetFromUtc(ref const(QDateTime) atDateTime) const;
    int standardTimeOffset(ref const(QDateTime) atDateTime) const;
    int daylightTimeOffset(ref const(QDateTime) atDateTime) const;

    bool hasDaylightTime() const;
    bool isDaylightTime(ref const(QDateTime) atDateTime) const;

    OffsetData offsetData(ref const(QDateTime) forDateTime) const;

    bool hasTransitions() const;
    OffsetData nextTransition(ref const(QDateTime) afterDateTime) const;
    OffsetData previousTransition(ref const(QDateTime) beforeDateTime) const;
    //OffsetDataList transitions(ref const(QDateTime) fromDateTime, ref const(QDateTime) toDateTime) const;

    static QByteArray systemTimeZoneId();
    static QTimeZone systemTimeZone();
    static QTimeZone utc();

    static bool isTimeZoneIdAvailable(ref const(QByteArray) ianaId);

    static QList!(QByteArray) availableTimeZoneIds();
    static QList!(QByteArray) availableTimeZoneIds(QLocale.Territory territory);
    static QList!(QByteArray) availableTimeZoneIds(int offsetSeconds);

    static QByteArray ianaIdToWindowsId(ref const(QByteArray) ianaId);
    static QByteArray windowsIdToDefaultIanaId(ref const(QByteArray) windowsId);
    static QByteArray windowsIdToDefaultIanaId(ref const(QByteArray) windowsId,
                                                   QLocale.Territory territory);
    static QList!(QByteArray) windowsIdToIanaIds(ref const(QByteArray) windowsId);
    static QList!(QByteArray) windowsIdToIanaIds(ref const(QByteArray) windowsId,
                                                    QLocale.Territory territory);

    static if ((!versionIsSet!("QT_NO_SYSTEMLOCALE") && (versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS"))))
    {
        /+ static QTimeZone fromCFTimeZone(CFTimeZoneRef timeZone); +/
        /+ CFTimeZoneRef toCFTimeZone() const Q_DECL_CF_RETURNS_RETAINED; +/
        /+ static QTimeZone fromNSTimeZone(const NSTimeZone *timeZone); +/
        /+ NSTimeZone *toNSTimeZone() const Q_DECL_NS_RETURNS_AUTORELEASED; +/
    }

private:
    this(ref QTimeZonePrivate dd);
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_CORE_EXPORT QDataStream &operator<<(QDataStream &ds, const QTimeZone &tz); +/
    }
    /+ friend class QTimeZonePrivate; +/
    /+ friend class QDateTime; +/
    /+ friend class QDateTimePrivate; +/
    QSharedDataPointer!(QTimeZonePrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QTimeZone::OffsetData, Q_RELOCATABLE_TYPE);
Q_DECLARE_SHARED(QTimeZone)

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &ds, const QTimeZone &tz);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &ds, QTimeZone &tz);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug dbg, const QTimeZone &tz);
#endif +/

