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
module qt.core.datetime;
extern(C++):

import qt.config;
import qt.core.calendar;
import qt.core.global;
import qt.core.namespace;
import qt.core.string;
import qt.core.stringview;
import qt.core.timezone;
import qt.core.typeinfo;
import qt.helpers;

/+ #if defined(Q_OS_DARWIN) || defined(Q_QDOC)
Q_FORWARD_DECLARE_CF_TYPE(CFDate);
Q_FORWARD_DECLARE_OBJC_CLASS(NSDate);
#endif


#if QT_CONFIG(timezone)
class QTimeZone;
#endif +/

/// Binding for C++ class [QDate](https://doc.qt.io/qt-6/qdate.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QDate
{
private:
    /+ explicit +/ this(qint64 julianDay)
    {
        this.jd = julianDay;
    }
public:
    /+this()
    {
        this.jd = nullJd();
    }+/
    this(int y, int m, int d);
    this(int y, int m, int d, QCalendar cal);
/+ #if __cpp_lib_chrono >= 201907L || defined(Q_QDOC)
    QT_POST_CXX17_API_IN_EXPORTED_CLASS
    Q_IMPLICIT QDate(std::chrono::year_month_day ymd)
    {
        if (!ymd.ok())
            jd = nullJd();
        else
            *this = fromStdSysDays(ymd);
    }

    QT_POST_CXX17_API_IN_EXPORTED_CLASS
    Q_IMPLICIT QDate(std::chrono::year_month_day_last ymdl)
    {
        if (!ymdl.ok())
            jd = nullJd();
        else
            *this = fromStdSysDays(ymdl);
    }

    QT_POST_CXX17_API_IN_EXPORTED_CLASS
    Q_IMPLICIT QDate(std::chrono::year_month_weekday ymw)
    {
        if (!ymw.ok())
            jd = nullJd();
        else
            *this = fromStdSysDays(ymw);
    }

    QT_POST_CXX17_API_IN_EXPORTED_CLASS
    Q_IMPLICIT QDate(std::chrono::year_month_weekday_last ymwl)
    {
        if (!ymwl.ok())
            jd = nullJd();
        else
            *this = fromStdSysDays(ymwl);
    }

    QT_POST_CXX17_API_IN_EXPORTED_CLASS
    static QDate fromStdSysDays(const std::chrono::sys_days &days)
    {
        const QDate epoch(unixEpochJd());
        return epoch.addDays(days.time_since_epoch().count());
    }

    QT_POST_CXX17_API_IN_EXPORTED_CLASS
    std::chrono::sys_days toStdSysDays() const
    {
        const QDate epoch(unixEpochJd());
        return std::chrono::sys_days(std::chrono::days(epoch.daysTo(*this)));
    }
#endif +/

    bool isNull() const { return !isValid(); }
    bool isValid() const { return jd >= minJd() && jd <= maxJd(); }

    // Gregorian-optimized:
    int year() const;
    int month() const;
    int day() const;
    int dayOfWeek() const;
    int dayOfYear() const;
    int daysInMonth() const;
    int daysInYear() const;
    int weekNumber(int* yearNum = null) const; // ISO 8601, always Gregorian

    int year(QCalendar cal) const;
    int month(QCalendar cal) const;
    int day(QCalendar cal) const;
    int dayOfWeek(QCalendar cal) const;
    int dayOfYear(QCalendar cal) const;
    int daysInMonth(QCalendar cal) const;
    int daysInYear(QCalendar cal) const;

    QDateTime startOfDay(/+ Qt:: +/qt.core.namespace.TimeSpec spec = /+ Qt:: +/qt.core.namespace.TimeSpec.LocalTime, int offsetSeconds = 0) const;
    QDateTime endOfDay(/+ Qt:: +/qt.core.namespace.TimeSpec spec = /+ Qt:: +/qt.core.namespace.TimeSpec.LocalTime, int offsetSeconds = 0) const;
/+ #if QT_CONFIG(timezone) +/
    QDateTime startOfDay(ref const(QTimeZone) zone) const;
    QDateTime endOfDay(ref const(QTimeZone) zone) const;
/+ #endif

#if QT_CONFIG(datestring) +/
    QString toString(/+ Qt:: +/qt.core.namespace.DateFormat format = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate) const;
    QString toString(ref const(QString) format, QCalendar cal/* = QCalendar()*/) const
    { return toString(qToStringViewIgnoringNull(format), cal); }
    QString toString(QStringView format, QCalendar cal/* = QCalendar()*/) const;
/+ #endif +/
    bool setDate(int year, int month, int day); // Gregorian-optimized
    bool setDate(int year, int month, int day, QCalendar cal);

    void getDate(int* year, int* month, int* day) const;

    /+ [[nodiscard]] +/ QDate addDays(qint64 days) const;
/+ #if __cpp_lib_chrono >= 201907L || defined(Q_QDOC)
    QT_POST_CXX17_API_IN_EXPORTED_CLASS
    [[nodiscard]] QDate addDuration(std::chrono::days days) const
    {
        return addDays(days.count());
    }
#endif +/
    // Gregorian-optimized:
    /+ [[nodiscard]] +/ QDate addMonths(int months) const;
    /+ [[nodiscard]] +/ QDate addYears(int years) const;
    /+ [[nodiscard]] +/ QDate addMonths(int months, QCalendar cal) const;
    /+ [[nodiscard]] +/ QDate addYears(int years, QCalendar cal) const;
    qint64 daysTo(QDate d) const;

    static QDate currentDate();
/+ #if QT_CONFIG(datestring) +/
    static QDate fromString(QStringView string, /+ Qt:: +/qt.core.namespace.DateFormat format = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate);
    static QDate fromString(QStringView string, QStringView format, QCalendar cal/* = QCalendar()*/)
    { auto tmp = string.toString(); return fromString(tmp, format, cal); }
    static QDate fromString(ref const(QString) string, QStringView format, QCalendar cal/* = QCalendar()*/);
    static QDate fromString(ref const(QString) string, /+ Qt:: +/qt.core.namespace.DateFormat format = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate)
    { return fromString(qToStringViewIgnoringNull(string), format); }
    static QDate fromString(ref const(QString) string, ref const(QString) format,
                                QCalendar cal/* = QCalendar()*/)
    { return fromString(string, qToStringViewIgnoringNull(format), cal); }
/+ #endif +/
    static bool isValid(int y, int m, int d);
    static bool isLeapYear(int year);

    pragma(inline, true) static QDate fromJulianDay(qint64 jd_)
    { return jd_ >= minJd() && jd_ <= maxJd() ? QDate(jd_) : QDate() ; }
    pragma(inline, true) qint64 toJulianDay() const { return jd; }

private:
    // using extra parentheses around min to avoid expanding it if it is a macro
    pragma(inline, true) static qint64 nullJd() { return qint64.min; }
    pragma(inline, true) static qint64 minJd() { return -784350574879L; }
    pragma(inline, true) static qint64 maxJd() { return  784354017364L; }
    pragma(inline, true) static qint64 unixEpochJd() { return 2440588L; }

    qint64 jd = nullJd();

    /+ friend class QDateTime; +/
    /+ friend class QDateTimePrivate; +/

    /+ friend constexpr bool operator==(QDate lhs, QDate rhs) { return lhs.jd == rhs.jd; } +/
    /+ friend constexpr bool operator!=(QDate lhs, QDate rhs) { return lhs.jd != rhs.jd; } +/
    /+ friend constexpr bool operator< (QDate lhs, QDate rhs) { return lhs.jd <  rhs.jd; } +/
    /+ friend constexpr bool operator<=(QDate lhs, QDate rhs) { return lhs.jd <= rhs.jd; } +/
    /+ friend constexpr bool operator> (QDate lhs, QDate rhs) { return lhs.jd >  rhs.jd; } +/
    /+ friend constexpr bool operator>=(QDate lhs, QDate rhs) { return lhs.jd >= rhs.jd; } +/
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, QDate); +/
        /+ friend Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QDate &); +/
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QDate, Q_RELOCATABLE_TYPE); +/

/// Binding for C++ class [QTime](https://doc.qt.io/qt-6/qtime.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QTime
{
private:
    /+ explicit +/ this(int ms)
    {
        this.mds = ms;
    }
public:
    @disable this();
    /+this()
    {
        this.mds = TimeFlag.NullTime;
    }+/
    this(int h, int m, int s = 0, int ms = 0);

    bool isNull() const { return mds == TimeFlag.NullTime; }
    bool isValid() const;

    int hour() const;
    int minute() const;
    int second() const;
    int msec() const;
/+ #if QT_CONFIG(datestring) +/
    QString toString(/+ Qt:: +/qt.core.namespace.DateFormat f = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate) const;
    QString toString(ref const(QString) format) const
    { return toString(qToStringViewIgnoringNull(format)); }
    QString toString(QStringView format) const;
/+ #endif +/
    bool setHMS(int h, int m, int s, int ms = 0);

    /+ [[nodiscard]] +/ QTime addSecs(int secs) const;
    int secsTo(QTime t) const;
    /+ [[nodiscard]] +/ QTime addMSecs(int ms) const;
    int msecsTo(QTime t) const;

    pragma(inline, true) static QTime fromMSecsSinceStartOfDay(int msecs) { return QTime(msecs); }
    pragma(inline, true) int msecsSinceStartOfDay() const { return mds == TimeFlag.NullTime ? 0 : mds; }

    static QTime currentTime();
/+ #if QT_CONFIG(datestring) +/
    static QTime fromString(QStringView string, /+ Qt:: +/qt.core.namespace.DateFormat format = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate);
    static QTime fromString(QStringView string, QStringView format)
    { auto tmp = string.toString(); return fromString(tmp, format); }
    static QTime fromString(ref const(QString) string, QStringView format);
    static QTime fromString(ref const(QString) string, /+ Qt:: +/qt.core.namespace.DateFormat format = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate)
    { return fromString(qToStringViewIgnoringNull(string), format); }
    static QTime fromString(ref const(QString) string, ref const(QString) format)
    { return fromString(string, qToStringViewIgnoringNull(format)); }
/+ #endif +/
    static bool isValid(int h, int m, int s, int ms = 0);

private:
    enum TimeFlag { NullTime = -1 }
    pragma(inline, true) int ds() const { return mds == -1 ? 0 : mds; }
    int mds = TimeFlag.NullTime;

    /+ friend constexpr bool operator==(QTime lhs, QTime rhs) { return lhs.mds == rhs.mds; } +/
    /+ friend constexpr bool operator!=(QTime lhs, QTime rhs) { return lhs.mds != rhs.mds; } +/
    /+ friend constexpr bool operator< (QTime lhs, QTime rhs) { return lhs.mds <  rhs.mds; } +/
    /+ friend constexpr bool operator<=(QTime lhs, QTime rhs) { return lhs.mds <= rhs.mds; } +/
    /+ friend constexpr bool operator> (QTime lhs, QTime rhs) { return lhs.mds >  rhs.mds; } +/
    /+ friend constexpr bool operator>=(QTime lhs, QTime rhs) { return lhs.mds >= rhs.mds; } +/

    /+ friend class QDateTime; +/
    /+ friend class QDateTimePrivate; +/
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, QTime); +/
        /+ friend Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QTime &); +/
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QTime, Q_RELOCATABLE_TYPE); +/

extern(C++, class) struct QDateTimePrivate;

/// Binding for C++ class [QDateTime](https://doc.qt.io/qt-6/qdatetime.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QDateTime
{
private:
    struct ShortData {
        size_t bitfieldData;
/+ #if QT_VERSION >= QT_VERSION_CHECK(7,0,0) || defined(QT_BOOTSTRAPPED)
#  if Q_BYTE_ORDER == Q_LITTLE_ENDIAN
        qint64 status : 8;
#  endif
        qint64 msecs : 56;

#  if Q_BYTE_ORDER == Q_BIG_ENDIAN
        qint64 status : 8;
#  endif
#else
#  if Q_BYTE_ORDER == Q_LITTLE_ENDIAN +/
/+        version (LittleEndian)
        {
            /+ quintptr status : 8; +/
            quintptr status() const
            {
                return (bitfieldData_status >> 0) & 0xff;
            }
            quintptr status(quintptr value)
            {
                bitfieldData_status = (bitfieldData_status & ~0xff) | ((value & 0xff) << 0);
                return value;
            }
        }
/+ #  endif +/
        // note: this is only 24 bits on 32-bit systems...
        /+ qintptr msecs : sizeof(void *) * 8 - 8; +/
        qintptr msecs() const
        {
            return (bitfieldData_msecs >> 0) & 0x1;
        }
        qintptr msecs(qintptr value)
        {
            bitfieldData_status = (bitfieldData_status & ~0x100) | ((value & 0x1) << 8);
            return value;
        }
        }

/+ #  if Q_BYTE_ORDER == Q_BIG_ENDIAN +/
        version (BigEndian)
        {
            /+ quintptr status : 8; +/
            quintptr status() const
            {
                return (bitfieldData_msecs >> 65) & 0xff;
            }
            quintptr status(quintptr value)
            {
                bitfieldData_msecs = (bitfieldData_msecs & ~0x1fe) | ((value & 0xff) << 65);
                return value;
            }
        }+/
/+ #  endif
#endif +/
    }

    union Data {
        enum {
            // To be of any use, we need at least 60 years around 1970, which
            // is 1,893,456,000,000 ms. That requires 41 bits to store, plus
            // the sign bit. With the status byte, the minimum size is 50 bits.
            CanBeSmall = ShortData.sizeof * 8 > 50
        }

        //this()/+ noexcept+/;
        this(/+ Qt:: +/qt.core.namespace.TimeSpec);
        /+ Data(const Data &other); +/
        /+ Data(Data &&other); +/
//        ~this();

        /+ void swap(Data &other) noexcept
        { std::swap(data, other.data); } +/

        bool isShort() const;
        void detach();

        /+const(QDateTimePrivate)* operator ->() const;+/
        /+QDateTimePrivate* operator ->();+/

        QDateTimePrivate* d;
        ShortData data;
    }

public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor()/+ noexcept+/;
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    this(QDate date, QTime time, /+ Qt:: +/qt.core.namespace.TimeSpec spec = /+ Qt:: +/qt.core.namespace.TimeSpec.LocalTime, int offsetSeconds = 0);
/+ #if QT_CONFIG(timezone) +/
    this(QDate date, QTime time, ref const(QTimeZone) timeZone);
/+ #endif +/ // timezone
    //@disable this(this);
    //this(ref const(QDateTime) other)/+ noexcept+/;
    /+ QDateTime(QDateTime &&other) noexcept; +/
    ~this();

    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QDateTime) +/
    ref QDateTime opAssign(ref const(QDateTime) other)/+ noexcept+/;

    /+ void swap(QDateTime &other) noexcept { d.swap(other.d); } +/

    bool isNull() const;
    bool isValid() const;

    QDate date() const;
    QTime time() const;
    /+ Qt:: +/qt.core.namespace.TimeSpec timeSpec() const;
    int offsetFromUtc() const;
/+ #if QT_CONFIG(timezone) +/
    QTimeZone timeZone() const;
/+ #endif +/ // timezone
    QString timeZoneAbbreviation() const;
    bool isDaylightTime() const;

    qint64 toMSecsSinceEpoch() const;
    qint64 toSecsSinceEpoch() const;

    void setDate(QDate date);
    void setTime(QTime time);
    void setTimeSpec(/+ Qt:: +/qt.core.namespace.TimeSpec spec);
    void setOffsetFromUtc(int offsetSeconds);
/+ #if QT_CONFIG(timezone) +/
    void setTimeZone(ref const(QTimeZone) toZone);
/+ #endif +/ // timezone
    void setMSecsSinceEpoch(qint64 msecs);
    void setSecsSinceEpoch(qint64 secs);

/+ #if QT_CONFIG(datestring) +/
    QString toString(/+ Qt:: +/qt.core.namespace.DateFormat format = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate) const;
    QString toString(ref const(QString) format, QCalendar cal/* = QCalendar()*/) const
    { return toString(qToStringViewIgnoringNull(format), cal); }
    QString toString(QStringView format, QCalendar cal/* = QCalendar()*/) const;
/+ #endif +/
    /+ [[nodiscard]] +/ QDateTime addDays(qint64 days) const;
    /+ [[nodiscard]] +/ QDateTime addMonths(int months) const;
    /+ [[nodiscard]] +/ QDateTime addYears(int years) const;
    /+ [[nodiscard]] +/ QDateTime addSecs(qint64 secs) const;
    /+ [[nodiscard]] +/ QDateTime addMSecs(qint64 msecs) const;
    /+ [[nodiscard]] QDateTime addDuration(std::chrono::milliseconds msecs) const
    {
        return addMSecs(msecs.count());
    } +/

    QDateTime toTimeSpec(/+ Qt:: +/qt.core.namespace.TimeSpec spec) const;
    pragma(inline, true) QDateTime toLocalTime() const { return toTimeSpec(/+ Qt:: +/qt.core.namespace.TimeSpec.LocalTime); }
    pragma(inline, true) QDateTime toUTC() const { return toTimeSpec(/+ Qt:: +/qt.core.namespace.TimeSpec.UTC); }
    QDateTime toOffsetFromUtc(int offsetSeconds) const;
/+ #if QT_CONFIG(timezone) +/
    QDateTime toTimeZone(ref const(QTimeZone) toZone) const;
/+ #endif +/ // timezone

    qint64 daysTo(ref const(QDateTime) ) const;
    qint64 secsTo(ref const(QDateTime) ) const;
    qint64 msecsTo(ref const(QDateTime) ) const;

    static QDateTime currentDateTime();
    static QDateTime currentDateTimeUtc();
/+ #if QT_CONFIG(datestring) +/
    static QDateTime fromString(QStringView string, /+ Qt:: +/qt.core.namespace.DateFormat format = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate);
    static QDateTime fromString(QStringView string, QStringView format,
                                    QCalendar cal/* = QCalendar()*/)
    { auto tmp = string.toString(); return fromString(tmp, format, cal); }
    static QDateTime fromString(ref const(QString) string, QStringView format,
                                    QCalendar cal/* = QCalendar()*/);
    static QDateTime fromString(ref const(QString) string, /+ Qt:: +/qt.core.namespace.DateFormat format = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate)
    { return fromString(qToStringViewIgnoringNull(string), format); }
    static QDateTime fromString(ref const(QString) string, ref const(QString) format,
                                    QCalendar cal/* = QCalendar()*/)
    { return fromString(string, qToStringViewIgnoringNull(format), cal); }
/+ #endif +/

    static QDateTime fromMSecsSinceEpoch(qint64 msecs, /+ Qt:: +/qt.core.namespace.TimeSpec spec = /+ Qt:: +/qt.core.namespace.TimeSpec.LocalTime,
                                             int offsetFromUtc = 0);
    static QDateTime fromSecsSinceEpoch(qint64 secs, /+ Qt:: +/qt.core.namespace.TimeSpec spec = /+ Qt:: +/qt.core.namespace.TimeSpec.LocalTime,
                                            int offsetFromUtc = 0);

/+ #if QT_CONFIG(timezone) +/
    static QDateTime fromMSecsSinceEpoch(qint64 msecs, ref const(QTimeZone) timeZone);
    static QDateTime fromSecsSinceEpoch(qint64 secs, ref const(QTimeZone) timeZone);
/+ #endif +/

    static qint64 currentMSecsSinceEpoch()/+ noexcept+/;
    static qint64 currentSecsSinceEpoch()/+ noexcept+/;

/+ #if defined(Q_OS_DARWIN) || defined(Q_QDOC) +/
    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ static QDateTime fromCFDate(CFDateRef date); +/
        /+ CFDateRef toCFDate() const Q_DECL_CF_RETURNS_RETAINED; +/
        /+ static QDateTime fromNSDate(const NSDate *date); +/
        /+ NSDate *toNSDate() const Q_DECL_NS_RETURNS_AUTORELEASED; +/
    }
/+ #endif

#if __cpp_lib_chrono >= 201907L || defined(Q_QDOC)
#if __cpp_concepts >= 201907L || defined(Q_QDOC)
    // Generic clock, as long as it's compatible with us (= system_clock)
    template <typename Clock, typename Duration>
    static QDateTime fromStdTimePoint(const std::chrono::time_point<Clock, Duration> &time)
        requires
            requires(const std::chrono::time_point<Clock, Duration> &t) {
                // the clock can be converted to system_clock
                std::chrono::clock_cast<std::chrono::system_clock>(t);
                // the duration can be converted to milliseconds
                requires std::is_convertible_v<Duration, std::chrono::milliseconds>;
            }
    {
        const auto sysTime = std::chrono::clock_cast<std::chrono::system_clock>(time);
        // clock_cast can change the duration, so convert it again to milliseconds
        const auto timeInMSec = std::chrono::time_point_cast<std::chrono::milliseconds>(sysTime);
        return fromMSecsSinceEpoch(timeInMSec.time_since_epoch().count(), Qt::UTC);
    }
#endif // __cpp_concepts

    // local_time
    QT_POST_CXX17_API_IN_EXPORTED_CLASS
    static QDateTime fromStdTimePoint(const std::chrono::local_time<std::chrono::milliseconds> &time)
    {
        return fromStdLocalTime(time);
    }

    QT_POST_CXX17_API_IN_EXPORTED_CLASS
    static QDateTime fromStdLocalTime(const std::chrono::local_time<std::chrono::milliseconds> &time)
    {
        QDateTime result(QDate(1970, 1, 1), QTime(0, 0, 0), Qt::LocalTime);
        return result.addMSecs(time.time_since_epoch().count());
    }

#if QT_CONFIG(timezone)
    // zoned_time. defined in qtimezone.h
    QT_POST_CXX17_API_IN_EXPORTED_CLASS
    static QDateTime fromStdZonedTime(const std::chrono::zoned_time<
                                          std::chrono::milliseconds,
                                          const std::chrono::time_zone *
                                      > &time);
#endif // QT_CONFIG(timezone)

    QT_POST_CXX17_API_IN_EXPORTED_CLASS
    std::chrono::sys_time<std::chrono::milliseconds> toStdSysMilliseconds() const
    {
        const std::chrono::milliseconds duration(toMSecsSinceEpoch());
        return std::chrono::sys_time<std::chrono::milliseconds>(duration);
    }

    QT_POST_CXX17_API_IN_EXPORTED_CLASS
    std::chrono::sys_seconds toStdSysSeconds() const
    {
        const std::chrono::seconds duration(toSecsSinceEpoch());
        return std::chrono::sys_seconds(duration);
    }
#endif +/ // __cpp_lib_chrono >= 201907L

    /+ friend std::chrono::milliseconds operator-(const QDateTime &lhs, const QDateTime &rhs)
    {
        return std::chrono::milliseconds(rhs.msecsTo(lhs));
    } +/

    /+ friend QDateTime operator+(const QDateTime &dateTime, std::chrono::milliseconds duration)
    {
        return dateTime.addMSecs(duration.count());
    } +/

    /+ friend QDateTime operator+(std::chrono::milliseconds duration, const QDateTime &dateTime)
    {
        return dateTime + duration;
    } +/

    /+ QDateTime &operator+=(std::chrono::milliseconds duration)
    {
        *this = addMSecs(duration.count());
        return *this;
    } +/

    /+ friend QDateTime operator-(const QDateTime &dateTime, std::chrono::milliseconds duration)
    {
        return dateTime.addMSecs(-duration.count());
    } +/

    /+ QDateTime &operator-=(std::chrono::milliseconds duration)
    {
        *this = addMSecs(-duration.count());
        return *this;
    } +/

    // (1<<63) ms is 292277024.6 (average Gregorian) years, counted from the start of 1970, so
    // Last is floor(1970 + 292277024.6); no year 0, so First is floor(1970 - 1 - 292277024.6)
    enum /+ class +/ YearRange : qint32 { First = -292275056,  Last = +292278994 }

private:
    bool equals(ref const(QDateTime) other) const;
    bool precedes(ref const(QDateTime) other) const;
    /+ friend class QDateTimePrivate; +/

    Data d;

    /+ friend bool operator==(const QDateTime &lhs, const QDateTime &rhs) { return lhs.equals(rhs); } +/
    /+ friend bool operator!=(const QDateTime &lhs, const QDateTime &rhs) { return !(lhs == rhs); } +/
    /+ friend bool operator<(const QDateTime &lhs, const QDateTime &rhs) { return lhs.precedes(rhs); } +/
    /+ friend bool operator<=(const QDateTime &lhs, const QDateTime &rhs) { return !(rhs < lhs); } +/
    /+ friend bool operator>(const QDateTime &lhs, const QDateTime &rhs) { return rhs.precedes(lhs); } +/
    /+ friend bool operator>=(const QDateTime &lhs, const QDateTime &rhs) { return !(lhs < rhs); } +/

/+ #ifndef QT_NO_DATASTREAM +/
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QDateTime &); +/
        /+ friend Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QDateTime &); +/
    }
/+ #endif

#if !defined(QT_NO_DEBUG_STREAM) && QT_CONFIG(datestring)
    friend Q_CORE_EXPORT QDebug operator<<(QDebug, const QDateTime &);
#endif +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_SHARED(QDateTime)

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, QDate);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QDate &);
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, QTime);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QTime &);
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QDateTime &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QDateTime &);
#endif // QT_NO_DATASTREAM

#if !defined(QT_NO_DEBUG_STREAM) && QT_CONFIG(datestring)
Q_CORE_EXPORT QDebug operator<<(QDebug, QDate);
Q_CORE_EXPORT QDebug operator<<(QDebug, QTime);
Q_CORE_EXPORT QDebug operator<<(QDebug, const QDateTime &);
#endif

// QDateTime is not noexcept for now -- to be revised once
// timezone and calendaring support is added
Q_CORE_EXPORT size_t qHash(const QDateTime &key, size_t seed = 0);
Q_CORE_EXPORT size_t qHash(QDate key, size_t seed = 0) noexcept;
Q_CORE_EXPORT size_t qHash(QTime key, size_t seed = 0) noexcept; +/

