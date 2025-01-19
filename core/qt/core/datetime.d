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

/// Binding for C++ class [QDate](https://doc.qt.io/qt-5/qdate.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QDate // ### Qt 6: change to be used by value, not const &
{
public:
    enum MonthNameType { // ### Qt 6: remove, along with methods using it
        DateFormat = 0,
        StandaloneFormat
    }
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

    bool isNull() const { return !isValid(); }
    bool isValid() const { return jd >= minJd() && jd <= maxJd(); }

    int year() const;
    int month() const;
    int day() const;
    int dayOfWeek() const;
    int dayOfYear() const;
    int daysInMonth() const;
    int daysInYear() const;
    int weekNumber(int* yearNum = null) const;

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

#if QT_DEPRECATED_SINCE(5, 10) && QT_CONFIG(textdate) +/
    /+ QT_DEPRECATED_X("Use QLocale::monthName or QLocale::standaloneMonthName") +/
            static QString shortMonthName(int month, MonthNameType type = MonthNameType.DateFormat);
    /+ QT_DEPRECATED_X("Use QLocale::dayName or QLocale::standaloneDayName") +/
            static QString shortDayName(int weekday, MonthNameType type = MonthNameType.DateFormat);
    /+ QT_DEPRECATED_X("Use QLocale::monthName or QLocale::standaloneMonthName") +/
            static QString longMonthName(int month, MonthNameType type = MonthNameType.DateFormat);
    /+ QT_DEPRECATED_X("Use QLocale::dayName or QLocale::standaloneDayName") +/
            static QString longDayName(int weekday, MonthNameType type = MonthNameType.DateFormat);
/+ #endif // textdate && deprecated
#if QT_CONFIG(datestring) +/
    QString toString(/+ Qt:: +/qt.core.namespace.DateFormat format = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate) const;
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    // Only the deprecated locale-dependent formats use the calendar.
    /+ QT_DEPRECATED_X("Use QLocale or omit the calendar") +/
        QString toString(/+ Qt:: +/qt.core.namespace.DateFormat format, QCalendar cal) const;
/+ #endif

#if QT_STRINGVIEW_LEVEL < 2 +/
    static if (QT_STRINGVIEW_LEVEL < 2)
    {
        QString toString(ref const(QString) format) const;
        QString toString(ref const(QString) format, QCalendar cal) const;
    }
/+ #endif +/

    QString toString(QStringView format) const;
    QString toString(QStringView format, QCalendar cal) const;
/+ #endif
#if QT_DEPRECATED_SINCE(5,0)
    QT_DEPRECATED_X("Use setDate() instead") inline bool setYMD(int y, int m, int d)
    { if (uint(y) <= 99) y += 1900; return setDate(y, m, d); }
#endif +/

    bool setDate(int year, int month, int day);
    bool setDate(int year, int month, int day, QCalendar cal);

/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    void getDate(int* year, int* month, int* day); // ### Qt 6: remove
/+ #endif +/ // < Qt 6
    void getDate(int* year, int* month, int* day) const;

    /+ Q_REQUIRED_RESULT +/ QDate addDays(qint64 days) const;
    /+ Q_REQUIRED_RESULT +/ QDate addMonths(int months) const;
    /+ Q_REQUIRED_RESULT +/ QDate addYears(int years) const;
    /+ Q_REQUIRED_RESULT +/ QDate addMonths(int months, QCalendar cal) const;
    /+ Q_REQUIRED_RESULT +/ QDate addYears(int years, QCalendar cal) const;
    qint64 daysTo(ref const(QDate) ) const; // ### Qt 6: QDate

    /+bool operator ==(ref const(QDate) other) const { return jd == other.jd; }+/
    /+bool operator !=(ref const(QDate) other) const { return jd != other.jd; }+/
    /+bool operator < (ref const(QDate) other) const { return jd <  other.jd; }+/
    /+bool operator <=(ref const(QDate) other) const { return jd <= other.jd; }+/
    /+bool operator > (ref const(QDate) other) const { return jd >  other.jd; }+/
    /+bool operator >=(ref const(QDate) other) const { return jd >= other.jd; }+/

    static QDate currentDate();
/+ #if QT_CONFIG(datestring) +/
    static QDate fromString(ref const(QString) s, /+ Qt:: +/qt.core.namespace.DateFormat f = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate);
    static QDate fromString(ref const(QString) s, ref const(QString) format);
    static QDate fromString(ref const(QString) s, ref const(QString) format, QCalendar cal);
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

    qint64 jd = nullJd();

    /+ friend class QDateTime; +/
    /+ friend class QDateTimePrivate; +/
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QDate &); +/
        /+ friend Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QDate &); +/
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QDate, Q_MOVABLE_TYPE); +/

/// Binding for C++ class [QTime](https://doc.qt.io/qt-5/qtime.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QTime // ### Qt 6: change to be used by value, not const &
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
    static if (QT_STRINGVIEW_LEVEL < 2)
    {
        QString toString(ref const(QString) format) const;
    }
    QString toString(QStringView format) const;
/+ #endif +/
    bool setHMS(int h, int m, int s, int ms = 0);

    /+ Q_REQUIRED_RESULT +/ QTime addSecs(int secs) const;
    int secsTo(ref const(QTime) ) const; // ### Qt 6: plain QTime
    /+ Q_REQUIRED_RESULT +/ QTime addMSecs(int ms) const;
    int msecsTo(ref const(QTime) ) const; // ### Qt 6: plain QTime

    /+bool operator ==(ref const(QTime) other) const { return mds == other.mds; }+/
    /+bool operator !=(ref const(QTime) other) const { return mds != other.mds; }+/
    /+bool operator < (ref const(QTime) other) const { return mds <  other.mds; }+/
    /+bool operator <=(ref const(QTime) other) const { return mds <= other.mds; }+/
    /+bool operator > (ref const(QTime) other) const { return mds >  other.mds; }+/
    /+bool operator >=(ref const(QTime) other) const { return mds >= other.mds; }+/

    pragma(inline, true) static QTime fromMSecsSinceStartOfDay(int msecs) { return QTime(msecs); }
    pragma(inline, true) int msecsSinceStartOfDay() const { return mds == TimeFlag.NullTime ? 0 : mds; }

    static QTime currentTime();
/+ #if QT_CONFIG(datestring) +/
    static QTime fromString(ref const(QString) s, /+ Qt:: +/qt.core.namespace.DateFormat f = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate);
    static QTime fromString(ref const(QString) s, ref const(QString) format);
/+ #endif +/
    static bool isValid(int h, int m, int s, int ms = 0);

/+ #if QT_DEPRECATED_SINCE(5, 14) +/ // ### Qt 6: remove
    /+ QT_DEPRECATED_X("Use QElapsedTimer instead") +/ void start();
    /+ QT_DEPRECATED_X("Use QElapsedTimer instead") +/ int restart();
    /+ QT_DEPRECATED_X("Use QElapsedTimer instead") +/ int elapsed() const;
/+ #endif +/
private:
    enum TimeFlag { NullTime = -1 }
    pragma(inline, true) int ds() const { return mds == -1 ? 0 : mds; }
    int mds = TimeFlag.NullTime;

    /+ friend class QDateTime; +/
    /+ friend class QDateTimePrivate; +/
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QTime &); +/
        /+ friend Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QTime &); +/
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+ Q_DECLARE_TYPEINFO(QTime, Q_MOVABLE_TYPE); +/

extern(C++, class) struct QDateTimePrivate;

/// Binding for C++ class [QDateTime](https://doc.qt.io/qt-5/qdatetime.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QDateTime
{
private:
    // ### Qt 6: revisit the optimization
    struct ShortData {
        size_t bitfieldData;
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
    }

    union Data {
        enum {
            // To be of any use, we need at least 60 years around 1970, which
            // is 1,893,456,000,000 ms. That requires 41 bits to store, plus
            // the sign bit. With the status byte, the minimum size is 50 bits.
            CanBeSmall = ShortData.sizeof * 8 > 50
        }

        //@disable this();
        this(/+ Qt:: +/qt.core.namespace.TimeSpec);
        /+ Data(const Data &other); +/
        /+ Data(Data &&other); +/
//        ~this();

        bool isShort() const;
        void detach();

        /+const(QDateTimePrivate)* operator ->() const;+/
        /+QDateTimePrivate* operator ->();+/

        QDateTimePrivate* d;
        ShortData data;
    }

public:
    /+this() /+ noexcept(Data::CanBeSmall) +/ ;+/

/+ #if QT_DEPRECATED_SINCE(5, 15) +/ // ### Qt 6: remove
    /+ QT_DEPRECATED_X("Use QDate::startOfDay()") +/ /+ explicit +/this(ref const(QDate) );
/+ #endif +/
    this(ref const(QDate) , ref const(QTime) , /+ Qt:: +/qt.core.namespace.TimeSpec spec = /+ Qt:: +/qt.core.namespace.TimeSpec.LocalTime);
    // ### Qt 6: Merge with above with default offsetSeconds = 0
    this(ref const(QDate) date, ref const(QTime) time, /+ Qt:: +/qt.core.namespace.TimeSpec spec, int offsetSeconds);
/+ #if QT_CONFIG(timezone) +/
    this(ref const(QDate) date, ref const(QTime) time, ref const(QTimeZone) timeZone);
/+ #endif +/ // timezone
    //@disable this(this);
    //this(ref const(QDateTime) other)/+ noexcept+/;
    /+ QDateTime(QDateTime &&other) noexcept; +/
    ~this();

    /+ QDateTime &operator=(QDateTime &&other) noexcept { swap(other); return *this; } +/
    /+ref QDateTime operator =(ref const(QDateTime) other)/+ noexcept+/;+/

    /+ void swap(QDateTime &other) noexcept { qSwap(d.d, other.d.d); } +/

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

    void setDate(ref const(QDate) date); // ### Qt 6: plain QDate
    void setTime(ref const(QTime) time);
    void setTimeSpec(/+ Qt:: +/qt.core.namespace.TimeSpec spec);
    void setOffsetFromUtc(int offsetSeconds);
/+ #if QT_CONFIG(timezone) +/
    void setTimeZone(ref const(QTimeZone) toZone);
/+ #endif +/ // timezone
    void setMSecsSinceEpoch(qint64 msecs);
    void setSecsSinceEpoch(qint64 secs);

/+ #if QT_CONFIG(datestring) +/
    QString toString(/+ Qt:: +/qt.core.namespace.DateFormat format = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate) const;
    static if (QT_STRINGVIEW_LEVEL < 2)
    {
        QString toString(ref const(QString) format) const;
        QString toString(ref const(QString) format, QCalendar cal) const;
    }
    QString toString(QStringView format) const;
    QString toString(QStringView format, QCalendar cal) const;
/+ #endif +/
    /+ Q_REQUIRED_RESULT +/ QDateTime addDays(qint64 days) const;
    /+ Q_REQUIRED_RESULT +/ QDateTime addMonths(int months) const;
    /+ Q_REQUIRED_RESULT +/ QDateTime addYears(int years) const;
    /+ Q_REQUIRED_RESULT +/ QDateTime addSecs(qint64 secs) const;
    /+ Q_REQUIRED_RESULT +/ QDateTime addMSecs(qint64 msecs) const;

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

    /+bool operator ==(ref const(QDateTime) other) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QDateTime) other) const { return !(this == other); }+/
    /+bool operator <(ref const(QDateTime) other) const;+/
    /+pragma(inline, true) bool operator <=(ref const(QDateTime) other) const { return !(other < this); }+/
    /+pragma(inline, true) bool operator >(ref const(QDateTime) other) const { return other < this; }+/
    /+pragma(inline, true) bool operator >=(ref const(QDateTime) other) const { return !(this < other); }+/

/+ #if QT_DEPRECATED_SINCE(5, 2) +/ // ### Qt 6: remove
    /+ QT_DEPRECATED_X("Use setOffsetFromUtc() instead") +/ void setUtcOffset(int seconds);
    /+ QT_DEPRECATED_X("Use offsetFromUtc() instead") +/ int utcOffset() const;
/+ #endif +/ // QT_DEPRECATED_SINCE

    static QDateTime currentDateTime();
    static QDateTime currentDateTimeUtc();
/+ #if QT_CONFIG(datestring) +/
    static QDateTime fromString(ref const(QString) s, /+ Qt:: +/qt.core.namespace.DateFormat f = /+ Qt:: +/qt.core.namespace.DateFormat.TextDate);
    static QDateTime fromString(ref const(QString) s, ref const(QString) format);
    static QDateTime fromString(ref const(QString) s, ref const(QString) format, QCalendar cal);
/+ #endif

#if QT_DEPRECATED_SINCE(5, 8) +/
    uint toTime_t() const;
    void setTime_t(uint secsSince1Jan1970UTC);
    static QDateTime fromTime_t(uint secsSince1Jan1970UTC);
    static QDateTime fromTime_t(uint secsSince1Jan1970UTC, /+ Qt:: +/qt.core.namespace.TimeSpec spec,
                                    int offsetFromUtc = 0);
/+ #  if QT_CONFIG(timezone) +/
    static QDateTime fromTime_t(uint secsSince1Jan1970UTC, ref const(QTimeZone) timeZone);
/+ #  endif
#endif +/

    static QDateTime fromMSecsSinceEpoch(qint64 msecs);
    // ### Qt 6: Merge with above with default spec = Qt::LocalTime
    static QDateTime fromMSecsSinceEpoch(qint64 msecs, /+ Qt:: +/qt.core.namespace.TimeSpec spec, int offsetFromUtc = 0);
    static QDateTime fromSecsSinceEpoch(qint64 secs, /+ Qt:: +/qt.core.namespace.TimeSpec spe = /+ Qt:: +/qt.core.namespace.TimeSpec.LocalTime, int offsetFromUtc = 0);

/+ #if QT_CONFIG(timezone) +/
    static QDateTime fromMSecsSinceEpoch(qint64 msecs, ref const(QTimeZone) timeZone);
    static QDateTime fromSecsSinceEpoch(qint64 secs, ref const(QTimeZone) timeZone);
/+ #endif +/

    static qint64 currentMSecsSinceEpoch()/+ noexcept+/;
    static qint64 currentSecsSinceEpoch()/+ noexcept+/;

    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ static QDateTime fromCFDate(CFDateRef date); +/
        /+ CFDateRef toCFDate() const Q_DECL_CF_RETURNS_RETAINED; +/
        /+ static QDateTime fromNSDate(const NSDate *date); +/
        /+ NSDate *toNSDate() const Q_DECL_NS_RETURNS_AUTORELEASED; +/
    }

    // (1<<63) ms is 292277024.6 (average Gregorian) years, counted from the start of 1970, so
    // Last is floor(1970 + 292277024.6); no year 0, so First is floor(1970 - 1 - 292277024.6)
    enum /+ class +/ YearRange : qint32 { First = -292275056,  Last = +292278994 }

private:
    /+ friend class QDateTimePrivate; +/

    Data d;

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
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QDate &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QDate &);
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QTime &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QTime &);
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QDateTime &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QDateTime &);
#endif // QT_NO_DATASTREAM

#if !defined(QT_NO_DEBUG_STREAM) && QT_CONFIG(datestring)
Q_CORE_EXPORT QDebug operator<<(QDebug, const QDate &);
Q_CORE_EXPORT QDebug operator<<(QDebug, const QTime &);
Q_CORE_EXPORT QDebug operator<<(QDebug, const QDateTime &);
#endif

// QDateTime is not noexcept for now -- to be revised once
// timezone and calendaring support is added
Q_CORE_EXPORT uint qHash(const QDateTime &key, uint seed = 0);
Q_CORE_EXPORT uint qHash(const QDate &key, uint seed = 0) noexcept;
Q_CORE_EXPORT uint qHash(const QTime &key, uint seed = 0) noexcept; +/

