// QT_MODULES: core
module corelib.time.tst_date;

import qt.core.datetime;
import qt.core.datastream;
import qt.core.string;
import qt.core.bytearray;
import qt.core.locale;
import qt.core.namespace;
import qt.core.global;
import qt.core.calendar;
import qt.core.timezone;
import qt.core.stringview;
import std.stdio : writeln;
import std.conv : to;

/*
 * Port of qtbase/tests/auto/corelib/time/qdate/tst_qdate.cpp.
 *
 * Conventions used by this port:
 *   - Each C++ `*_data` fixture is a separate D function (isNull_data(),
 *     isValid_data(), ...); the test body iterates the rows it returns.
 *   - Functionality whose D binding is missing is still written but left
 *     commented out, preceded by a `// BINDING GAP:` note, so what is not
 *     implemented stays visible in the source.
 *
 * BINDING GAP: QDebug operator<< for QDate is
 * not bound (QDebug is only forward-declared in the bindings), so that case
 * stays commented out.
 *
 * BINDING GAP: `QDate()` (the default constructor) is not bound as an explicit
 * D `this()`. Qt's `QDate()` is inline/constexpr (`QDate() : jd(nullJd())`), so
 * Qt6Core exports no out-of-line constructor symbol - unlike `QDateTime`, whose
 * default constructor is exported and is bound as `rawConstructor()`. Because
 * the Qt constructor is trivial, the field initialiser `jd = nullJd()` already
 * reproduces it, so D's implicit default construction (`QDate()` / `QDate.init`)
 * yields exactly the C++ `QDate()` (the invalid/null date).
 *
 * BINDING GAP: `QTimeZone`'s `string` constructor is not bound - only
 * `QTimeZone(QByteArray)` is (Qt's `explicit QTimeZone(const QByteArray
 * &ianaId)`) - so zone ids are built with `qba()`, which wraps a D string in a
 * `QByteArray`.
 *
 * BINDING GAP: `QDataStream` (de)serialization of `QDate` (`writeDate`/
 * `readDate`) is not exercised, so `operator_insert_extract` is recorded
 * commented out.
 *
 * BINDING GAP: `qHash(QDate)` is not bound, so the qHash check in
 * `operator_eq_eq` is recorded commented out.
 *
 * Environment-dependent cases (locale / timezone data) are runtime-gated and
 * skipped with a reason when the prerequisite is missing.
 *
 * BINDING GAP: the `startOfDay`/`endOfDay` timezone tests construct `QTimeZone`
 * from an id; on Android Qt resolves the id through JNI
 * (`QJniObject::fromString` -> `QJniEnvironment`), which needs a `JavaVM`. The
 * qemu Android chroot has no ART/JVM, so those tests are compiled out on
 * Android with `version (Android) {} else`.
 */

private void gate(string name, string reason)
{
    writeln("SKIP ", name, " - ", reason);
}


private QByteArray qba(string s)
{
    return QByteArray(s.ptr, cast(qsizetype) s.length);
}

// ---------------------------------------------------------------------------
// Fixtures and tests
// ---------------------------------------------------------------------------

private struct IsNullRow
{
    long jd;
    bool null_;
}
private IsNullRow[] isNull_data()
{
    enum long minJd = -784_350_574_879L;
    enum long maxJd = 784_354_017_364L;
    return [
        // qint64 min
        IsNullRow(long.min, true),
        // minJd - 1
        IsNullRow(minJd - 1, true),
        // minJd
        IsNullRow(minJd, false),
        // minJd + 1
        IsNullRow(minJd + 1, false),
        // maxJd - 1
        IsNullRow(maxJd - 1, false),
        // maxJd
        IsNullRow(maxJd, false),
        // maxJd + 1
        IsNullRow(maxJd + 1, true),
        // qint64 max
        IsNullRow(long.max, true),
    ];
}

// isNull
unittest
{
    foreach (i, ref r; isNull_data())
    {
        QDate d = QDate.fromJulianDay(r.jd);
        assert(d.isNull() == r.null_, "isNull row " ~ i.to!string);
    }
}

private struct IsValidRow
{
    int y, m, d;
    long jd;
    bool valid;
}
private IsValidRow[] isValid_data()
{
    enum long nullJd = long.min;
    return [
        // 0-0-0
        IsValidRow(0, 0, 0, nullJd, false),
        // month 0
        IsValidRow(2000, 0, 1, nullJd, false),
        // day 0
        IsValidRow(2000, 1, 0, nullJd, false),
        // month 13
        IsValidRow(2000, 13, 1, nullJd, false),
        // non-leap
        IsValidRow(2006, 2, 29, nullJd, false),
        // normal leap
        IsValidRow(2004, 2, 29, 2_453_065, true),
        // century leap 1900
        IsValidRow(1900, 2, 29, nullJd, false),
        // century leap 2100
        IsValidRow(2100, 2, 29, nullJd, false),
        // 400-years leap 2000
        IsValidRow(2000, 2, 29, 2_451_604, true),
        // 400-years leap 2400
        IsValidRow(2400, 2, 29, 2_597_701, true),
        // 400-years leap 1600
        IsValidRow(1600, 2, 29, 2_305_507, true),
        // year 0
        IsValidRow(0, 2, 27, nullJd, false),
        // late
        IsValidRow(9999, 12, 31, 5_373_484, true),
        // jan
        IsValidRow(2000, 1, 31, 2_451_575, true),
        // mar
        IsValidRow(2000, 3, 31, 2_451_635, true),
        // apr
        IsValidRow(2000, 4, 30, 2_451_665, true),
        // may
        IsValidRow(2000, 5, 31, 2_451_696, true),
        // jun
        IsValidRow(2000, 6, 30, 2_451_726, true),
        // jul
        IsValidRow(2000, 7, 31, 2_451_757, true),
        // aug
        IsValidRow(2000, 8, 31, 2_451_788, true),
        // sep
        IsValidRow(2000, 9, 30, 2_451_818, true),
        // oct
        IsValidRow(2000, 10, 31, 2_451_849, true),
        // nov
        IsValidRow(2000, 11, 30, 2_451_879, true),
        // dec
        IsValidRow(2000, 12, 31, 2_451_910, true),
        // ijan
        IsValidRow(2000, 1, 32, nullJd, false),
        // ifeb
        IsValidRow(2000, 2, 30, nullJd, false),
        // imar
        IsValidRow(2000, 3, 32, nullJd, false),
        // iapr
        IsValidRow(2000, 4, 31, nullJd, false),
        // imay
        IsValidRow(2000, 5, 32, nullJd, false),
        // ijun
        IsValidRow(2000, 6, 31, nullJd, false),
        // ijul
        IsValidRow(2000, 7, 32, nullJd, false),
        // iaug
        IsValidRow(2000, 8, 32, nullJd, false),
        // isep
        IsValidRow(2000, 9, 31, nullJd, false),
        // ioct
        IsValidRow(2000, 10, 32, nullJd, false),
        // inov
        IsValidRow(2000, 11, 31, nullJd, false),
        // idec
        IsValidRow(2000, 12, 32, nullJd, false),
        // jd earliest formula
        IsValidRow(-4800, 1, 1, -31_738, true),
        // jd -1
        IsValidRow(-4714, 11, 23, -1, true),
        // jd 0
        IsValidRow(-4714, 11, 24, 0, true),
        // jd 1
        IsValidRow(-4714, 11, 25, 1, true),
        // jd latest formula
        IsValidRow(1_400_000, 12, 31, 513_060_925, true),
    ];
}

// isValid
unittest
{
    foreach (i, ref r; isValid_data())
    {
        string ctx = "isValid row " ~ i.to!string;
        assert(QDate.isValid(r.y, r.m, r.d) == r.valid, ctx);
        QDate d;
        d.setDate(r.y, r.m, r.d);
        assert(d.isValid() == r.valid, ctx);
        assert(d.toJulianDay() == r.jd, ctx);
        if (r.valid)
        {
            assert(d.year() == r.y, ctx);
            assert(d.month() == r.m, ctx);
            assert(d.day() == r.d, ctx);
/+ #if __cpp_lib_chrono >= 201907L +/
            // std::chrono::year_month_day conversion / toStdSysDays() checks are
            // not applicable to the D bindings.
/+ #endif +/
        }
        else
        {
            assert(d.year() == 0, ctx);
            assert(d.month() == 0, ctx);
            assert(d.day() == 0, ctx);
        }
    }
}

private IsValidRow[] julianDay_data()
{
    return isValid_data();
}

// julianDay
unittest
{
    foreach (i, ref r; julianDay_data())
    {
        string ctx = "julianDay row " ~ i.to!string;
        QDate d;
        d.setDate(r.y, r.m, r.d);
        assert(d.toJulianDay() == r.jd, ctx);
        if (r.jd != long.min)
        {
            QDate back = QDate.fromJulianDay(r.jd);
            assert(back.year() == r.y && back.month() == r.m && back.day() == r.d, ctx);
        }
    }
}

private struct DayOfWeekRow
{
    int year, month, day, dayOfWeek;
}
private DayOfWeekRow[] dayOfWeek_data()
{
    return [
        // data0
        DayOfWeekRow(0, 0, 0, 0),
        // data1
        DayOfWeekRow(2000, 1, 3, 1),
        // data2
        DayOfWeekRow(2000, 1, 4, 2),
        // data3
        DayOfWeekRow(2000, 1, 5, 3),
        // data4
        DayOfWeekRow(2000, 1, 6, 4),
        // data5
        DayOfWeekRow(2000, 1, 7, 5),
        // data6
        DayOfWeekRow(2000, 1, 8, 6),
        // data7
        DayOfWeekRow(2000, 1, 9, 7),
        // data8
        DayOfWeekRow(-4800, 1, 1, 1),
        // data9
        DayOfWeekRow(-4800, 1, 2, 2),
        // data10
        DayOfWeekRow(-4800, 1, 3, 3),
        // data11
        DayOfWeekRow(-4800, 1, 4, 4),
        // data12
        DayOfWeekRow(-4800, 1, 5, 5),
        // data13
        DayOfWeekRow(-4800, 1, 6, 6),
        // data14
        DayOfWeekRow(-4800, 1, 7, 7),
        // data15
        DayOfWeekRow(-4800, 1, 8, 1),
    ];
}

// dayOfWeek
unittest
{
    foreach (i, ref r; dayOfWeek_data())
    {
        QDate dt = QDate(r.year, r.month, r.day);
        assert(dt.dayOfWeek() == r.dayOfWeek, "dayOfWeek row " ~ i.to!string);
    }
}

private struct DayOfYearRow
{
    int year, month, day, dayOfYear;
}
private DayOfYearRow[] dayOfYear_data()
{
    return [
        // data0
        DayOfYearRow(0, 0, 0, 0),
        // data1
        DayOfYearRow(2000, 1, 1, 1),
        // data2
        DayOfYearRow(2000, 1, 2, 2),
        // data3
        DayOfYearRow(2000, 1, 3, 3),
        // data4
        DayOfYearRow(2000, 12, 31, 366),
        // data5
        DayOfYearRow(2001, 12, 31, 365),
        // data6
        DayOfYearRow(1815, 1, 1, 1),
        // data7
        DayOfYearRow(1815, 12, 31, 365),
        // data8
        DayOfYearRow(1500, 1, 1, 1),
        // data9
        DayOfYearRow(1500, 12, 31, 365),
        // data10
        DayOfYearRow(-1500, 1, 1, 1),
        // data11
        DayOfYearRow(-1500, 12, 31, 365),
        // data12
        DayOfYearRow(-4800, 1, 1, 1),
        // data13
        DayOfYearRow(-4800, 12, 31, 365),
    ];
}

// dayOfYear
unittest
{
    foreach (i, ref r; dayOfYear_data())
    {
        QDate dt = QDate(r.year, r.month, r.day);
        assert(dt.dayOfYear() == r.dayOfYear, "dayOfYear row " ~ i.to!string);
    }
}

private struct DaysInMonthRow
{
    int year, month, day, daysInMonth;
}
private DaysInMonthRow[] daysInMonth_data()
{
    return [
        // data0
        DaysInMonthRow(0, 0, 0, 0),
        // data1
        DaysInMonthRow(2000, 1, 1, 31),
        // data2
        DaysInMonthRow(2000, 2, 1, 29),
        // data3
        DaysInMonthRow(2000, 3, 1, 31),
        // data4
        DaysInMonthRow(2000, 4, 1, 30),
        // data5
        DaysInMonthRow(2000, 5, 1, 31),
        // data6
        DaysInMonthRow(2000, 6, 1, 30),
        // data7
        DaysInMonthRow(2000, 7, 1, 31),
        // data8
        DaysInMonthRow(2000, 8, 1, 31),
        // data9
        DaysInMonthRow(2000, 9, 1, 30),
        // data10
        DaysInMonthRow(2000, 10, 1, 31),
        // data11
        DaysInMonthRow(2000, 11, 1, 30),
        // data12
        DaysInMonthRow(2000, 12, 1, 31),
        // data13
        DaysInMonthRow(2001, 2, 1, 28),
        // data14
        DaysInMonthRow(2000, 0, 1, 0),
    ];
}

// daysInMonth
unittest
{
    foreach (i, ref r; daysInMonth_data())
    {
        QDate dt = QDate(r.year, r.month, r.day);
        assert(dt.daysInMonth() == r.daysInMonth, "daysInMonth row " ~ i.to!string);
    }
}

private struct DaysInYearRow
{
    int year, month, day, expectedDaysInYear;
}
private DaysInYearRow[] daysInYear_data()
{
    return [
        // 2000, 1, 1
        DaysInYearRow(2000, 1, 1, 366),
        // 2001, 1, 1
        DaysInYearRow(2001, 1, 1, 365),
        // 4, 1, 1
        DaysInYearRow(4, 1, 1, 366),
        // 5, 1, 1
        DaysInYearRow(5, 1, 1, 365),
        // 0, 0, 0
        DaysInYearRow(0, 0, 0, 0),
    ];
}

// daysInYear
unittest
{
    foreach (i, ref r; daysInYear_data())
    {
        QDate date = QDate(r.year, r.month, r.day);
        assert(date.daysInYear() == r.expectedDaysInYear, "daysInYear row " ~ i.to!string);
    }
}

// getDate
unittest
{
    const string ctx = "getDate";
    int y, m, d;
    QDate dt = QDate(2000, 1, 1);
    dt.getDate(&y, &m, &d);
    assert(y == 2000, ctx);
    assert(m == 1, ctx);
    assert(d == 1, ctx);
    dt.setDate(0, 0, 0);
    dt.getDate(&y, &m, &d);
    assert(y == 0, ctx);
    assert(m == 0, ctx);
    assert(d == 0, ctx);
}

private struct WeekNumberRow
{
    int expectedWeek;
    int expectedYear;
    int y, m, d;
}
private WeekNumberRow[] weekNumber_data()
{
    enum Thursday = 4;
    bool wasLastYearLong = false;
    WeekNumberRow[] rows;

    // Full 400-year cycle for Jan 1, Jan 4, Dec 28 and Dec 31.
    foreach (yr; 2000 .. 2400)
    {
        int wday = QDate(yr, 1, 1).dayOfWeek();
        bool isLongYear = (wday == Thursday) || (QDate.isLeapYear(yr) && wday == Thursday - 1);

        // Jan 4 is always on week 1.
        rows ~= WeekNumberRow(1, yr, yr, 1, 4);
        // Dec 28 is always on the last week.
        rows ~= WeekNumberRow(52 + (isLongYear ? 1 : 0), yr, yr, 12, 28);
        // Jan 1 is on week 1 or on the last week of the previous year.
        rows ~= WeekNumberRow(wday <= Thursday ? 1 : 52 + (wasLastYearLong ? 1 : 0),
                wday <= Thursday ? yr : yr - 1, yr, 1, 1);
        // Dec 31 is on the last week or on week 1 of the next year.
        int decWday = QDate(yr, 12, 31).dayOfWeek();
        rows ~= WeekNumberRow(decWday >= Thursday ? 52 + (isLongYear ? 1 : 0) : 1,
                decWday >= Thursday ? yr : yr + 1, yr, 12, 31);

        wasLastYearLong = isLongYear;
    }
    return rows;
}

// weekNumber
unittest
{
    foreach (i, ref r; weekNumber_data())
    {
        QDate dt = QDate(r.y, r.m, r.d);
        int yearNumber;
        int wn = dt.weekNumber(&yearNumber);
        string ctx = "weekNumber row " ~ i.to!string;
        assert(wn == r.expectedWeek, ctx);
        assert(yearNumber == r.expectedYear, ctx);
    }
}

private WeekNumberRow[] weekNumber_invalid_data()
{
    // The C++ fixture provides data rows but the test itself only checks a
    // default-constructed (invalid) QDate.
    return [
        // data0
        WeekNumberRow(0, 0, 0, 0, 0),
        // data1
        WeekNumberRow(0, 0, 2001, 1, 32),
        // data2
        WeekNumberRow(0, 0, 1999, 2, 29),
    ];
}

// weekNumber_invalid
unittest
{
    foreach (i, ref r; weekNumber_invalid_data())
    {
        QDate dt; // default-constructed is invalid
        int yearNumber;
        assert(dt.weekNumber(&yearNumber) == 0, "weekNumber_invalid row " ~ i.to!string);
    }
}

/+ #if QT_CONFIG(timezone) +/
private struct StartOfDayRow
{
    QDate date;
    string zoneName;
    QTime start, end;
}
private StartOfDayRow[] startOfDay_endOfDay_data()
{
    StartOfDayRow[] rows;
    QTime initial = QTime(0, 0);
    QTime final_ = QTime(23, 59, 59, 999);
    QTime invalid = QDateTime.create().time();

    // UTC is always a valid zone.
    // epoch
    rows ~= StartOfDayRow(QDate(1970, 1, 1), "UTC", initial, final_);
    {
        string s = "America/Sao_Paulo";
        QByteArray b = qba(s);
        QTimeZone z = QTimeZone(b);
        if (z.isValid())
            // Brazil
            rows ~= StartOfDayRow(QDate(2008, 10, 19), s, QTime(1, 0), final_);
    }
/+ #if QT_CONFIG(icu) || !defined(Q_OS_WIN) +/
    {
        string s = "Europe/Sofia";
        QByteArray b = qba(s);
        QTimeZone z = QTimeZone(b);
        version (Windows)
        {
            // MS's TZ APIs lack Europe/Sofia's 1994-03-27 spring-forward, so
            // this row is only valid on Windows when Qt is built with ICU.
        }
        else if (z.isValid())
        {
            // Sofia
            rows ~= StartOfDayRow(QDate(1994, 3, 27), s, QTime(1, 0), final_);
        }
    }
/+ #endif +/
    {
        string s = "Pacific/Kiritimati";
        QByteArray b = qba(s);
        QTimeZone z = QTimeZone(b);
        if (z.isValid())
            // Kiritimati
            rows ~= StartOfDayRow(QDate(1994, 12, 31), s, invalid, invalid);
    }
    {
        string s = "Pacific/Apia";
        QByteArray b = qba(s);
        QTimeZone z = QTimeZone(b);
        if (z.isValid())
            // Samoa
            rows ~= StartOfDayRow(QDate(2011, 12, 30), s, invalid, invalid);
    }
    return rows;
}

// startOfDay_endOfDay (timezone-dependent)
version (Android) {} else
unittest
{
    auto rows = startOfDay_endOfDay_data();
    foreach (i, ref r; rows)
    {
        string ctx = "startOfDay_endOfDay row " ~ i.to!string;
        QByteArray b = qba(r.zoneName);
        QTimeZone zone = QTimeZone(b);
        if (!zone.isValid())
        {
            gate(ctx, "timezone data is unavailable");
            continue;
        }

        QDateTime front = r.date.startOfDay(zone);
        QDateTime back = r.date.endOfDay(zone);

        if (r.end.isValid())
            assert(r.date.addDays(1).startOfDay(zone).addMSecs(-1) == back, "endOfDay " ~ ctx);
        if (r.start.isValid())
            assert(r.date.addDays(-1).endOfDay(zone).addMSecs(1) == front, "startOfDay " ~ ctx);

        immutable bool isSystem = QTimeZone.systemTimeZone() == zone;
        do { // Avoids duplicating these tests for local-time when it *is* zone:
            if (r.start.isValid()) {
                assert(front.date() == r.date, ctx);
                assert(front.time() == r.start, ctx);
            }
            if (r.end.isValid()) {
                assert(back.date() == r.date, ctx);
                assert(back.time() == r.end, ctx);
            }
            if (front.timeSpec() == TimeSpec.LocalTime)
                break;
            front = r.date.startOfDay(TimeSpec.LocalTime);
            back = r.date.endOfDay(TimeSpec.LocalTime);
        } while (isSystem);

        if (r.end.isValid())
            assert(r.date.addDays(1).startOfDay(TimeSpec.LocalTime).addMSecs(-1) == back, ctx);
        if (r.start.isValid())
            assert(r.date.addDays(-1).endOfDay(TimeSpec.LocalTime).addMSecs(1) == front, ctx);

        if (!isSystem) {
            // These might fail if system zone coincides with zone; but only if it
            // did something similarly unusual on the date picked for this test.
            if (r.start.isValid()) {
                immutable auto early = QTime(0, 0);
                assert(front.date() == r.date, ctx);
                assert(front.time() == early, ctx);
            }
            if (r.end.isValid()) {
                immutable auto late = QTime(23, 59, 59, 999);
                assert(back.date() == r.date, ctx);
                assert(back.time() == late, ctx);
            }
        }
    }
}

/+ #endif +/

private QDate[] startOfDay_endOfDay_fixed_data()
{
    enum long boundsMin = long.min;
    enum long boundsMax = long.max;
    enum long kilo = 1000L;

    QDateTime first = QDateTime.fromMSecsSinceEpoch(boundsMin + 1, TimeSpec.UTC);
    QDateTime start32sign = QDateTime.fromMSecsSinceEpoch(-0x80000000L * kilo, TimeSpec.UTC);
    QDateTime end32sign = QDateTime.fromMSecsSinceEpoch(0x80000000L * kilo, TimeSpec.UTC);
    QDateTime end32unsign = QDateTime.fromMSecsSinceEpoch(0x100000000L * kilo, TimeSpec.UTC);
    QDateTime last = QDateTime.fromMSecsSinceEpoch(boundsMax, TimeSpec.UTC);

    return [
        // epoch
        QDate(1970, 1, 1),
        // y2k-leap-day
        QDate(2000, 2, 29),
        // start-1900
        QDate(1900, 1, 1),
        // pre-sign32
        QDate(start32sign.date().year(), 1, 1),
        // post-sign32
        QDate(end32sign.date().year(), 12, 31),
        // post-uint32
        QDate(end32unsign.date().year(), 12, 31),
        // first-full
        first.date().addDays(1),
        // last-full
        last.date().addDays(-1),
    ];
}

// startOfDay_endOfDay_fixed
version (Android) {} else
unittest
{
    const string ctx = "startOfDay_endOfDay_fixed";
    immutable auto early = QTime(0, 0);
    immutable auto late = QTime(23, 59, 59, 999);

    foreach (date; startOfDay_endOfDay_fixed_data())
    {
        QDateTime start = date.startOfDay(TimeSpec.UTC);
        QDateTime end = date.endOfDay(TimeSpec.UTC);
        assert(start.date() == date, ctx);
        assert(end.date() == date, ctx);
        assert(start.time() == early, ctx);
        assert(end.time() == late, ctx);
        assert(date.addDays(1).startOfDay(TimeSpec.UTC).addMSecs(-1) == end, ctx);
        assert(date.addDays(-1).endOfDay(TimeSpec.UTC).addMSecs(1) == start, ctx);

        for (int offset = -60 * 16; offset <= 60 * 16; offset += 65)
        {
            start = date.startOfDay(TimeSpec.OffsetFromUTC, offset);
            end = date.endOfDay(TimeSpec.OffsetFromUTC, offset);
            assert(start.date() == date, ctx);
            assert(end.date() == date, ctx);
            assert(start.time() == early, ctx);
            assert(end.time() == late, ctx);
        }

        assert(date.startOfDay(TimeSpec.LocalTime).date() == date, ctx);
        assert(date.endOfDay(TimeSpec.LocalTime).date() == date, ctx);

/+ #if QT_CONFIG(timezone) +/
        QByteArray osloId = qba("Europe/Oslo");
        QTimeZone cet = QTimeZone(osloId);
        if (cet.isValid())
        {
            assert(date.startOfDay(cet).date() == date, ctx);
            assert(date.endOfDay(cet).date() == date, ctx);
        }
/+ #endif +/
    }
}

// startOfDay_endOfDay_bounds
version (Android) {} else
unittest
{
    const string ctx = "startOfDay_endOfDay_bounds";
    enum long boundsMin = long.min;
    enum long boundsMax = long.max;
    immutable auto early = QTime(0, 0);
    immutable auto late = QTime(23, 59, 59, 999);

    QDateTime first = QDateTime.fromMSecsSinceEpoch(boundsMin, TimeSpec.UTC);
    QDateTime last = QDateTime.fromMSecsSinceEpoch(boundsMax, TimeSpec.UTC);
    QDateTime epoch = QDateTime.fromMSecsSinceEpoch(0, TimeSpec.UTC);

    assert(first.isValid(), ctx);
    assert(last.isValid(), ctx);
    // Ordering via public API (QDateTime operators are not bound).
    assert(first.toMSecsSinceEpoch() < epoch.toMSecsSinceEpoch(), ctx);
    assert(last.toMSecsSinceEpoch() > epoch.toMSecsSinceEpoch(), ctx);

    assert(first.date().endOfDay(TimeSpec.UTC).time() == late, ctx);
    assert(last.date().startOfDay(TimeSpec.UTC).time() == early, ctx);
    assert(!first.date().startOfDay(TimeSpec.UTC).isValid(), ctx);
    assert(!last.date().endOfDay(TimeSpec.UTC).isValid(), ctx);

    QDate qdteMin = QDate(1752, 9, 14);
    assert(qdteMin.startOfDay(TimeSpec.UTC).date() == qdteMin, ctx);
    assert(qdteMin.startOfDay(TimeSpec.LocalTime).date() == qdteMin, ctx);

/+ #if QT_CONFIG(timezone) +/
    QByteArray berlinId = qba("Europe/Berlin");
    QTimeZone berlinZone = QTimeZone(berlinId);
    if (berlinZone.isValid())
        assert(qdteMin.startOfDay(berlinZone).date() == qdteMin, ctx);
/+ #endif +/
}

// julianDaysLimits
unittest
{
    const string ctx = "julianDaysLimits";
    enum long minJd = -784_350_574_879L;
    enum long maxJd = 784_354_017_364L;

    QDate maxDate = QDate.fromJulianDay(maxJd);
    QDate minDate = QDate.fromJulianDay(minJd);
    QDate zeroDate = QDate.fromJulianDay(0);

    assert(QDate.fromJulianDay(long.min).isValid() == false, ctx);
    assert(QDate.fromJulianDay(minJd - 1).isValid() == false, ctx);
    assert(QDate.fromJulianDay(minJd).isValid() == true, ctx);
    assert(QDate.fromJulianDay(minJd + 1).isValid() == true, ctx);
    assert(QDate.fromJulianDay(maxJd - 1).isValid() == true, ctx);
    assert(QDate.fromJulianDay(maxJd).isValid() == true, ctx);
    assert(QDate.fromJulianDay(maxJd + 1).isValid() == false, ctx);
    assert(QDate.fromJulianDay(long.max).isValid() == false, ctx);

    assert(maxDate.addDays(1).isValid() == false, ctx);
    assert(maxDate.addDays(0).isValid() == true, ctx);
    assert(maxDate.addDays(-1).isValid() == true, ctx);
    assert(maxDate.addDays(long.max).isValid() == false, ctx);
    assert(maxDate.addDays(long.min).isValid() == false, ctx);

    assert(minDate.addDays(-1).isValid() == false, ctx);
    assert(minDate.addDays(0).isValid() == true, ctx);
    assert(minDate.addDays(1).isValid() == true, ctx);
    assert(minDate.addDays(long.min).isValid() == false, ctx);
    assert(minDate.addDays(long.max).isValid() == false, ctx);

    assert(zeroDate.addDays(-1).isValid() == true, ctx);
    assert(zeroDate.addDays(0).isValid() == true, ctx);
    assert(zeroDate.addDays(1).isValid() == true, ctx);
    assert(zeroDate.addDays(long.min).isValid() == false, ctx);
    assert(zeroDate.addDays(long.max).isValid() == false, ctx);
}

private struct AddRow
{
    int y, m, d, add, ey, em, ed;
}
private AddRow[] addDays_data()
{
    return [
        // data0
        AddRow(2000, 1, 1, 1, 2000, 1, 2),
        // data1
        AddRow(2000, 1, 31, 1, 2000, 2, 1),
        // data2
        AddRow(2000, 2, 28, 1, 2000, 2, 29),
        // data3
        AddRow(2000, 2, 29, 1, 2000, 3, 1),
        // data4
        AddRow(2000, 12, 31, 1, 2001, 1, 1),
        // data5
        AddRow(2001, 2, 28, 1, 2001, 3, 1),
        // data6
        AddRow(2001, 2, 28, 30, 2001, 3, 30),
        // data7
        AddRow(2001, 3, 30, 5, 2001, 4, 4),
        // data8
        AddRow(2000, 1, 1, -1, 1999, 12, 31),
        // data9
        AddRow(2000, 1, 31, -1, 2000, 1, 30),
        // data10
        AddRow(2000, 2, 28, -1, 2000, 2, 27),
        // data11
        AddRow(2001, 2, 28, -30, 2001, 1, 29),
        // data12
        AddRow(-4713, 1, 2, -2, -4714, 12, 31),
        // data13
        AddRow(-4713, 1, 2, 2, -4713, 1, 4),
        // invalid
        AddRow(0, 0, 0, 1, 0, 0, 0),
    ];
}

// addDays
unittest
{
    foreach (i, ref r; addDays_data())
    {
        QDate dt = QDate(r.y, r.m, r.d);
        QDate dt2 = dt.addDays(r.add);
        string ctx = "addDays row " ~ i.to!string;
        assert(dt2.year() == r.ey && dt2.month() == r.em && dt2.day() == r.ed, ctx);
/+ #if __cpp_lib_chrono >= 201907L +/
        // QDate.addDuration(std::chrono::days(amountToAdd)) is not bound in D.
/+ #endif +/
    }
}

private AddRow[] addMonths_data()
{
    return [
        // data0
        AddRow(2000, 1, 1, 1, 2000, 2, 1),
        // data1
        AddRow(2000, 1, 31, 1, 2000, 2, 29),
        // data2
        AddRow(2000, 2, 28, 1, 2000, 3, 28),
        // data3
        AddRow(2000, 2, 29, 1, 2000, 3, 29),
        // data4
        AddRow(2000, 12, 31, 1, 2001, 1, 31),
        // data5
        AddRow(2001, 2, 28, 1, 2001, 3, 28),
        // data6
        AddRow(2001, 2, 28, 12, 2002, 2, 28),
        // data7
        AddRow(2000, 2, 29, 12, 2001, 2, 28),
        // data8
        AddRow(2000, 10, 15, 4, 2001, 2, 15),
        // data9
        AddRow(2000, 1, 1, -1, 1999, 12, 1),
        // data10
        AddRow(2000, 1, 31, -1, 1999, 12, 31),
        // data11
        AddRow(2000, 12, 31, -1, 2000, 11, 30),
        // data12
        AddRow(2001, 2, 28, -12, 2000, 2, 28),
        // data13
        AddRow(2000, 1, 31, -7, 1999, 6, 30),
        // data14
        AddRow(2000, 2, 29, -12, 1999, 2, 28),
        // data15
        AddRow(1, 1, 1, -1, -1, 12, 1),
        // data16
        AddRow(1, 1, 1, -12, -1, 1, 1),
        // data17
        AddRow(-1, 12, 1, 1, 1, 1, 1),
        // data18
        AddRow(-1, 1, 1, 12, 1, 1, 1),
        // data19
        AddRow(-2, 1, 1, 12, -1, 1, 1),
        // invalid
        AddRow(0, 0, 0, 1, 0, 0, 0),
    ];
}

// addMonths
unittest
{
    foreach (i, ref r; addMonths_data())
    {
        QDate dt = QDate(r.y, r.m, r.d);
        dt = dt.addMonths(r.add);
        string ctx = "addMonths row " ~ i.to!string;
        assert(dt.year() == r.ey && dt.month() == r.em && dt.day() == r.ed, ctx);
    }
}

private AddRow[] addYears_data()
{
    return [
        // data0
        AddRow(2000, 1, 1, 1, 2001, 1, 1),
        // data1
        AddRow(2000, 1, 31, 1, 2001, 1, 31),
        // data2
        AddRow(2000, 2, 28, 1, 2001, 2, 28),
        // data3
        AddRow(2000, 2, 29, 1, 2001, 2, 28),
        // data4
        AddRow(2000, 12, 31, 1, 2001, 12, 31),
        // data5
        AddRow(2001, 2, 28, 3, 2004, 2, 28),
        // data6
        AddRow(2000, 2, 29, 4, 2004, 2, 29),
        // data7
        AddRow(2000, 1, 31, -1, 1999, 1, 31),
        // data9
        AddRow(2000, 2, 29, -1, 1999, 2, 28),
        // data10
        AddRow(2000, 12, 31, -1, 1999, 12, 31),
        // data11
        AddRow(2001, 2, 28, -3, 1998, 2, 28),
        // data12
        AddRow(2000, 2, 29, -4, 1996, 2, 29),
        // data13
        AddRow(2000, 2, 29, -5, 1995, 2, 28),
        // data14
        AddRow(2000, 1, 1, -1999, 1, 1, 1),
        // data15
        AddRow(2000, 1, 1, -2000, -1, 1, 1),
        // data16
        AddRow(2000, 1, 1, -2001, -2, 1, 1),
        // data17
        AddRow(-2000, 1, 1, 1999, -1, 1, 1),
        // data18
        AddRow(-2000, 1, 1, 2000, 1, 1, 1),
        // data19
        AddRow(-2000, 1, 1, 2001, 2, 1, 1),
        // invalid
        AddRow(0, 0, 0, 1, 0, 0, 0),
    ];
}

// addYears
unittest
{
    foreach (i, ref r; addYears_data())
    {
        QDate dt = QDate(r.y, r.m, r.d);
        dt = dt.addYears(r.add);
        string ctx = "addYears row " ~ i.to!string;
        assert(dt.year() == r.ey && dt.month() == r.em && dt.day() == r.ed, ctx);
    }
}

// daysTo
unittest
{
    const string ctx = "daysTo";
    enum long minJd = -784_350_574_879L;
    enum long maxJd = 784_354_017_364L;

    QDate dt1 = QDate(2000, 1, 1);
    QDate dt2 = QDate(2000, 1, 5);
    assert(dt1.daysTo(dt2) == 4, ctx);
    assert(dt2.daysTo(dt1) == -4, ctx);

    dt1.setDate(0, 0, 0);
    assert(dt1.daysTo(dt2) == 0, ctx);
    dt1.setDate(2000, 1, 1);
    dt2.setDate(0, 0, 0);
    assert(dt1.daysTo(dt2) == 0, ctx);

    QDate maxDate = QDate.fromJulianDay(maxJd);
    QDate minDate = QDate.fromJulianDay(minJd);
    QDate zeroDate = QDate.fromJulianDay(0);

    assert(maxDate.daysTo(minDate) == minJd - maxJd, ctx);
    assert(minDate.daysTo(maxDate) == maxJd - minJd, ctx);
    assert(maxDate.daysTo(zeroDate) == -maxJd, ctx);
    assert(zeroDate.daysTo(maxDate) == maxJd, ctx);
    assert(minDate.daysTo(zeroDate) == -minJd, ctx);
    assert(zeroDate.daysTo(minDate) == minJd, ctx);
}

private struct EqRow
{
    QDate d1, d2;
    bool equal;
}
private EqRow[] operator_eq_eq_data()
{
    QDate date1 = QDate(1900, 1, 1);
    return [
        // data0
        EqRow(QDate(2000, 1, 2), QDate(2000, 1, 2), true),
        // data1
        EqRow(QDate(2001, 12, 5), QDate(2001, 12, 5), true),
        // data3
        EqRow(QDate(2001, 12, 5), QDate(2002, 12, 5), false),
        // data4
        EqRow(date1.addDays(1), date1.addDays(-1), false),
        // data5
        EqRow(date1.addMonths(1), date1.addMonths(-1), false),
        // data6
        EqRow(date1.addYears(1), date1.addYears(-1), false),
        // data7
        EqRow(date1, date1.addDays(1), false),
        // data8
        EqRow(date1, date1.addDays(-1), false),
        // data9
        EqRow(date1, date1.addMonths(1), false),
        // data10
        EqRow(date1, date1.addMonths(-1), false),
        // data11
        EqRow(date1, date1.addYears(1), false),
        // data12
        EqRow(date1, date1.addYears(-1), false),
    ];
}

// operator_eq_eq (QDate == / !=)
unittest
{
    foreach (i, ref r; operator_eq_eq_data())
    {
        string ctx = "operator_eq_eq row " ~ i.to!string;
        bool equal = r.d1 == r.d2;
        assert(equal == r.equal, ctx);
        bool notEqual = r.d1 != r.d2;
        assert(notEqual == !r.equal, ctx);
        // BINDING GAP: qHash(QDate) is not bound, so the qHash check is recorded
        // commented out.
        //
        // if (equal)
        //     assert(qHash(r.d1) == qHash(r.d2), ctx);
    }
}

// operator_lt
unittest
{
    const string ctx = "operator_lt";
    QDate d1 = QDate(2000, 1, 2);
    QDate d2 = QDate(2000, 1, 2);
    assert(!(d1 < d2), ctx);

    d1 = QDate(2001, 12, 4);
    d2 = QDate(2001, 12, 5);
    assert(d1 < d2, ctx);

    d1 = QDate(2001, 11, 5);
    d2 = QDate(2001, 12, 5);
    assert(d1 < d2, ctx);

    d1 = QDate(2000, 12, 5);
    d2 = QDate(2001, 12, 5);
    assert(d1 < d2, ctx);

    d1 = QDate(2002, 12, 5);
    d2 = QDate(2001, 12, 5);
    assert(!(d1 < d2), ctx);

    d1 = QDate(2001, 12, 5);
    d2 = QDate(2001, 11, 5);
    assert(!(d1 < d2), ctx);

    d1 = QDate(2001, 12, 6);
    d2 = QDate(2001, 12, 5);
    assert(!(d1 < d2), ctx);
}

// operator_gt
unittest
{
    const string ctx = "operator_gt";
    QDate d1 = QDate(2000, 1, 2);
    QDate d2 = QDate(2000, 1, 2);
    assert(!(d1 > d2), ctx);

    d1 = QDate(2001, 12, 4);
    d2 = QDate(2001, 12, 5);
    assert(!(d1 > d2), ctx);

    d1 = QDate(2001, 11, 5);
    d2 = QDate(2001, 12, 5);
    assert(!(d1 > d2), ctx);

    d1 = QDate(2000, 12, 5);
    d2 = QDate(2001, 12, 5);
    assert(!(d1 > d2), ctx);

    d1 = QDate(2002, 12, 5);
    d2 = QDate(2001, 12, 5);
    assert(d1 > d2, ctx);

    d1 = QDate(2001, 12, 5);
    d2 = QDate(2001, 11, 5);
    assert(d1 > d2, ctx);

    d1 = QDate(2001, 12, 6);
    d2 = QDate(2001, 12, 5);
    assert(d1 > d2, ctx);
}

// operator_lt_eq
unittest
{
    const string ctx = "operator_lt_eq";
    QDate d1 = QDate(2000, 1, 2);
    QDate d2 = QDate(2000, 1, 2);
    assert(d1 <= d2, ctx);

    d1 = QDate(2001, 12, 4);
    d2 = QDate(2001, 12, 5);
    assert(d1 <= d2, ctx);

    d1 = QDate(2001, 11, 5);
    d2 = QDate(2001, 12, 5);
    assert(d1 <= d2, ctx);

    d1 = QDate(2000, 12, 5);
    d2 = QDate(2001, 12, 5);
    assert(d1 <= d2, ctx);

    d1 = QDate(2002, 12, 5);
    d2 = QDate(2001, 12, 5);
    assert(!(d1 <= d2), ctx);

    d1 = QDate(2001, 12, 5);
    d2 = QDate(2001, 11, 5);
    assert(!(d1 <= d2), ctx);

    d1 = QDate(2001, 12, 6);
    d2 = QDate(2001, 12, 5);
    assert(!(d1 <= d2), ctx);
}

// operator_gt_eq
unittest
{
    const string ctx = "operator_gt_eq";
    QDate d1 = QDate(2000, 1, 2);
    QDate d2 = QDate(2000, 1, 2);
    assert(d1 >= d2, ctx);

    d1 = QDate(2001, 12, 4);
    d2 = QDate(2001, 12, 5);
    assert(!(d1 >= d2), ctx);

    d1 = QDate(2001, 11, 5);
    d2 = QDate(2001, 12, 5);
    assert(!(d1 >= d2), ctx);

    d1 = QDate(2000, 12, 5);
    d2 = QDate(2001, 12, 5);
    assert(!(d1 >= d2), ctx);

    d1 = QDate(2002, 12, 5);
    d2 = QDate(2001, 12, 5);
    assert(d1 >= d2, ctx);

    d1 = QDate(2001, 12, 5);
    d2 = QDate(2001, 11, 5);
    assert(d1 >= d2, ctx);

    d1 = QDate(2001, 12, 6);
    d2 = QDate(2001, 12, 5);
    assert(d1 >= d2, ctx);
}

// BINDING GAP: QDataStream (de)serialization of QDate (`writeDate`/`readDate`) is not exercised; the case is recorded commented out.
// private struct InsertExtractRow
// {
//     QDataStream.Version dataStreamVersion;
//     QDate date;
// }
// private InsertExtractRow[] operator_insert_extract_data()
// {
//     InsertExtractRow[] rows;
//     QDate invalid; // a default-constructed QDate is invalid
//     static immutable QDataStream.Version[] versions = [
//         QDataStream.Version.Qt_1_0, QDataStream.Version.Qt_2_0, QDataStream.Version.Qt_2_1,
//         QDataStream.Version.Qt_3_0, QDataStream.Version.Qt_3_1, QDataStream.Version.Qt_3_3,
//         QDataStream.Version.Qt_4_0, QDataStream.Version.Qt_4_1, QDataStream.Version.Qt_4_2,
//         QDataStream.Version.Qt_4_3, QDataStream.Version.Qt_4_4, QDataStream.Version.Qt_4_5,
//         QDataStream.Version.Qt_4_6, QDataStream.Version.Qt_4_7, QDataStream.Version.Qt_4_8,
//         QDataStream.Version.Qt_4_9, QDataStream.Version.Qt_5_0,
//     ];
//     foreach (v; versions)
//     {
//         rows ~= InsertExtractRow(v, invalid);
//         rows ~= InsertExtractRow(v, QDate(1, 1, 1));
//         rows ~= InsertExtractRow(v, QDate(-1, 1, 1));
//         rows ~= InsertExtractRow(v, QDate(1995, 5, 20));
//
//         // Minimum representable values differ between the quint32 and qint64
//         // encodings used before and after QDataStream::Qt_5_0.
//         if (cast(int) v >= cast(int) QDataStream.Version.Qt_5_0)
//             rows ~= InsertExtractRow(v, QDate(-4714, 11, 24));
//         else
//             rows ~= InsertExtractRow(v, QDate(-4713, 1, 2));
//     }
//     return rows;
// }
//
// // operator_insert_extract
// unittest
// {
//     foreach (i, ref r; operator_insert_extract_data())
//     {
//         QByteArray byteArray;
//         {
//             QDataStream writer = QDataStream(&byteArray, QDataStream.OpenModeFlag.ReadWrite);
//             writer.setVersion(cast(int) r.dataStreamVersion);
//             writer.writeDate(r.date);
//         }
//         // Re-open a stream over the same byte array instead of rewinding the
//         // writer's device; this reads from the beginning.
//         QDataStream reader = QDataStream(byteArray);
//         reader.setVersion(cast(int) r.dataStreamVersion);
//         QDate deserialised;
//         reader.readDate(deserialised);
//         string ctx = "operator_insert_extract row " ~ i.to!string;
//         assert(reader.status() == QDataStream.Status.Ok, ctx);
//         assert(deserialised == r.date, ctx);
//     }
// }
//
/+ #if QT_CONFIG(datestring) +/
/+ # if QT_CONFIG(datetimeparser) +/
private struct FromStringDateRow
{
    string s;
    DateFormat fmt;
    QDate expected;
}
private FromStringDateRow[] fromStringDateFormat_data()
{
    return [
        // Text
        // text0
        FromStringDateRow("Sat May 20 1995", DateFormat.TextDate, QDate(1995, 5, 20)),
        // text1
        FromStringDateRow("Tue Dec 17 2002", DateFormat.TextDate, QDate(2002, 12, 17)),
        // text3
        FromStringDateRow("xxx Jan 1 0999", DateFormat.TextDate, QDate(999, 1, 1)),
        // text3b
        FromStringDateRow("xxx Jan 1 999", DateFormat.TextDate, QDate(999, 1, 1)),
        // text4
        FromStringDateRow("xxx Jan 1 12345", DateFormat.TextDate, QDate(12_345, 1, 1)),
        // text5
        FromStringDateRow("xxx Jan 1 -0001", DateFormat.TextDate, QDate(-1, 1, 1)),
        // text6
        FromStringDateRow("xxx Jan 1 -4712", DateFormat.TextDate, QDate(-4712, 1, 1)),
        // text7
        FromStringDateRow("xxx Nov 25 -4713", DateFormat.TextDate, QDate(-4713, 11, 25)),
        // text, empty
        FromStringDateRow("", DateFormat.TextDate, QDate()),
        // text, 3 part
        FromStringDateRow("part1 part2 part3", DateFormat.TextDate, QDate()),
        // text, invalid month name
        FromStringDateRow("Wed BabytownFrolics 8 2012", DateFormat.TextDate, QDate()),
        // text, invalid day
        FromStringDateRow("Wed May Wilhelm 2012", DateFormat.TextDate, QDate()),
        // text, invalid year
        FromStringDateRow("Wed May 8 Cats", DateFormat.TextDate, QDate()),
        // ISO
        // iso0
        FromStringDateRow("1995-05-20", DateFormat.ISODate, QDate(1995, 5, 20)),
        // iso1
        FromStringDateRow("2002-12-17", DateFormat.ISODate, QDate(2002, 12, 17)),
        // iso3
        FromStringDateRow("0999-01-01", DateFormat.ISODate, QDate(999, 1, 1)),
        // iso4
        FromStringDateRow("2000101101", DateFormat.ISODate, QDate()),
        // iso5
        FromStringDateRow("2000/01/01", DateFormat.ISODate, QDate(2000, 1, 1)),
        // iso6
        FromStringDateRow("2000-01-01 blah", DateFormat.ISODate, QDate(2000, 1, 1)),
        // iso7
        FromStringDateRow("2000-01-011blah", DateFormat.ISODate, QDate()),
        // iso8
        FromStringDateRow("2000-01-01blah", DateFormat.ISODate, QDate(2000, 1, 1)),
        // iso9
        FromStringDateRow("-001-01-01", DateFormat.ISODate, QDate()),
        // iso10
        FromStringDateRow("99999-01-01", DateFormat.ISODate, QDate()),
        // Test DateFormat.RFC2822Date format (RFC 2822).
        // RFC 2822
        FromStringDateRow("13 Feb 1987 13:24:51 +0100", DateFormat.RFC2822Date, QDate(1987, 2, 13)),
        // RFC 2822 after space
        FromStringDateRow(" 13 Feb 1987 13:24:51 +0100", DateFormat.RFC2822Date, QDate(1987, 2, 13)),
        // RFC 2822 with day
        FromStringDateRow("Thu, 01 Jan 1970 00:12:34 +0000", DateFormat.RFC2822Date, QDate(1970, 1, 1)),
        // RFC 2822 with day after space
        FromStringDateRow(" Thu, 01 Jan 1970 00:12:34 +0000", DateFormat.RFC2822Date, QDate(1970, 1, 1)),
        // No timezone
        // RFC 2822 no timezone
        FromStringDateRow("01 Jan 1970 00:12:34", DateFormat.RFC2822Date, QDate(1970, 1, 1)),
        // RFC 2822 date only
        FromStringDateRow("01 Nov 2002", DateFormat.RFC2822Date, QDate(2002, 11, 1)),
        // RFC 2822 with day date only
        FromStringDateRow("Fri, 01 Nov 2002", DateFormat.RFC2822Date, QDate(2002, 11, 1)),
        // RFC 2822 malformed time
        FromStringDateRow("01 Nov 2002 0:", DateFormat.RFC2822Date, QDate()),
        // Test invalid month, day, year
        // RFC 2822 invalid month name
        FromStringDateRow("13 Fev 1987 13:24:51 +0100", DateFormat.RFC2822Date, QDate()),
        // RFC 2822 invalid day
        FromStringDateRow("36 Fev 1987 13:24:51 +0100", DateFormat.RFC2822Date, QDate()),
        // RFC 2822 invalid year
        FromStringDateRow("13 Fev 0000 13:24:51 +0100", DateFormat.RFC2822Date, QDate()),
        // RFC 2822 invalid character at end
        FromStringDateRow("01 Jan 2012 08:00:00 +0100!", DateFormat.RFC2822Date, QDate()),
        // RFC 2822 invalid character at front
        FromStringDateRow("!01 Jan 2012 08:00:00 +0100", DateFormat.RFC2822Date, QDate()),
        // RFC 2822 invalid character both ends
        FromStringDateRow("!01 Jan 2012 08:00:00 +0100!", DateFormat.RFC2822Date, QDate()),
        // RFC 2822 invalid character at front, 2 at back
        FromStringDateRow("!01 Jan 2012 08:00:00 +0100..", DateFormat.RFC2822Date, QDate()),
        // RFC 2822 invalid character 2 at front
        FromStringDateRow("!!01 Jan 2012 08:00:00 +0100", DateFormat.RFC2822Date, QDate()),
        // The common date text used by the "invalid character" tests, just to be
        // sure *it's* not what's invalid:
        // RFC 2822 (not invalid)
        FromStringDateRow("01 Jan 2012 08:00:00 +0100", DateFormat.RFC2822Date, QDate(2012, 1, 1)),
        // Test DateFormat.RFC2822Date format (RFC 850 and 1036, permissive).
        // RFC 850 and 1036
        FromStringDateRow("Fri Feb 13 13:24:51 1987 +0100", DateFormat.RFC2822Date, QDate(1987, 2, 13)),
        // RFC 850 and 1036 after space
        FromStringDateRow(" Fri Feb 13 13:24:51 1987 +0100", DateFormat.RFC2822Date, QDate(1987, 2, 13)),
        // No timezone
        // RFC 850 and 1036 no timezone
        FromStringDateRow("Thu Jan 01 00:12:34 1970", DateFormat.RFC2822Date, QDate(1970, 1, 1)),
        // No time specified
        // RFC 850 and 1036 date only
        FromStringDateRow("Fri Nov 01 2002", DateFormat.RFC2822Date, QDate(2002, 11, 1)),
        // Test invalid characters.
        // RFC 850 and 1036 invalid character at end
        FromStringDateRow("Sun Jan 01 08:00:00 2012 +0100!", DateFormat.RFC2822Date, QDate()),
        // RFC 850 and 1036 invalid character at front
        FromStringDateRow("!Sun Jan 01 08:00:00 2012 +0100", DateFormat.RFC2822Date, QDate()),
        // RFC 850 and 1036 invalid character both ends
        FromStringDateRow("!Sun Jan 01 08:00:00 2012 +0100!", DateFormat.RFC2822Date, QDate()),
        // RFC 850 and 1036 invalid character at front, 2 at back
        FromStringDateRow("!Sun Jan 01 08:00:00 2012 +0100..", DateFormat.RFC2822Date, QDate()),
        // RFC 850 and 1036 invalid character 2 at front
        FromStringDateRow("!!Sun Jan 01 08:00:00 2012 +0100", DateFormat.RFC2822Date, QDate()),
        // Again, check the text in the "invalid character" tests isn't the source of invalidity:
        // RFC 850 and 1036 (not invalid)
        FromStringDateRow("Sun Jan 01 08:00:00 2012 +0100", DateFormat.RFC2822Date, QDate(2012, 1, 1)),
        // RFC empty
        FromStringDateRow("", DateFormat.RFC2822Date, QDate()), 
    ];
}

// fromStringDateFormat
unittest
{
    foreach (i, ref r; fromStringDateFormat_data())
    {
        QDate got = QDate.fromString(QString(r.s), r.fmt);
        assert(got == r.expected, "fromStringDateFormat row " ~ i.to!string ~ " ('" ~ r.s ~ "')");
    }
}

private struct FromStringRow
{
    string s, format;
    QDate expected;
}
private FromStringRow[] fromStringFormat_data()
{
    QDate defDate = QDate(1900, 1, 1);
    return [
        // data0
        FromStringRow("", "", defDate),
        // data1
        FromStringRow(" ", "", QDate()),
        // data2
        FromStringRow(" ", " ", defDate),
        // data3
        FromStringRow("-%$%#", "$*(#@", QDate()),
        // data4
        FromStringRow("d", "'d'", defDate),
        // data5
        FromStringRow("101010", "dMyy", QDate(1910, 10, 10)),
        // data6
        FromStringRow("101010b", "dMyy", QDate()),
        // data7
        FromStringRow("January", "MMMM", defDate),
        // data8
        FromStringRow("ball", "balle", QDate()),
        // data9
        FromStringRow("balleh", "balleh", defDate),
        // data10
        FromStringRow("10.01.1", "M.dd.d", QDate(defDate.year(), 10, 1)),
        // data11
        FromStringRow("-1.01.1", "M.dd.d", QDate()),
        // data12
        FromStringRow("11010", "dMMyy", QDate()),
        // data13
        FromStringRow("-2", "d", QDate()),
        // data14
        FromStringRow("132", "Md", QDate()),
        // data15
        FromStringRow("February", "MMMM", QDate(defDate.year(), 2, 1)),
        // data16
        FromStringRow("Mon August 8 2005", "ddd MMMM d yyyy", QDate(2005, 8, 8)),
        // data17
        FromStringRow("2000:00", "yyyy:yy", QDate(2000, 1, 1)),
        // data18
        FromStringRow("1999:99", "yyyy:yy", QDate(1999, 1, 1)),
        // data19
        FromStringRow("2099:99", "yyyy:yy", QDate(2099, 1, 1)),
        // data20
        FromStringRow("2001:01", "yyyy:yy", QDate(2001, 1, 1)),
        // data21
        FromStringRow("99", "yy", QDate(1999, 1, 1)),
        // data22
        FromStringRow("01", "yy", QDate(1901, 1, 1)),
        // data23
        FromStringRow("Monday", "dddd", QDate(1900, 1, 1)),
        // data24
        FromStringRow("Tuesday", "dddd", QDate(1900, 1, 2)),
        // data25
        FromStringRow("Wednesday", "dddd", QDate(1900, 1, 3)),
        // data26
        FromStringRow("Thursday", "dddd", QDate(1900, 1, 4)),
        // data27
        FromStringRow("Friday", "dddd", QDate(1900, 1, 5)),
        // data28
        FromStringRow("Saturday", "dddd", QDate(1900, 1, 6)),
        // data29
        FromStringRow("Sunday", "dddd", QDate(1900, 1, 7)),
        // data30
        FromStringRow("Monday 2006", "dddd yyyy", QDate(2006, 1, 2)),
        // data31
        FromStringRow("Tuesday 2006", "dddd yyyy", QDate(2006, 1, 3)),
        // data32
        FromStringRow("Wednesday 2006", "dddd yyyy", QDate(2006, 1, 4)),
        // data33
        FromStringRow("Thursday 2006", "dddd yyyy", QDate(2006, 1, 5)),
        // data34
        FromStringRow("Friday 2006", "dddd yyyy", QDate(2006, 1, 6)),
        // data35
        FromStringRow("Saturday 2006", "dddd yyyy", QDate(2006, 1, 7)),
        // data36
        FromStringRow("Sunday 2006", "dddd yyyy", QDate(2006, 1, 1)),
        // data37
        FromStringRow("Tuesday 2007 March", "dddd yyyy MMMM", QDate(2007, 3, 6)),
        // data38
        FromStringRow("21052006", "ddMMyyyy", QDate(2006, 5, 21)),
        // data39
        FromStringRow("210506", "ddMMyy", QDate(1906, 5, 21)),
        // data40
        FromStringRow("21/5/2006", "d/M/yyyy", QDate(2006, 5, 21)),
        // data41
        FromStringRow("21/5/06", "d/M/yy", QDate(1906, 5, 21)),
        // data42
        FromStringRow("20060521", "yyyyMMdd", QDate(2006, 5, 21)),
        // data43
        FromStringRow("060521", "yyMMdd", QDate(1906, 5, 21)),
        // lateMarch
        FromStringRow("9999-03-06", "yyyy-MM-dd", QDate(9999, 3, 6)),
        // late
        FromStringRow("9999-12-31", "yyyy-MM-dd", QDate(9999, 12, 31)),
        // Test unicode handling.
        // Unicode in format string
        FromStringRow(
            "2020\U0001F92309\U0001F92321",
            "yyyy\U0001F923MM\U0001F923dd",
            QDate(2020, 9, 21)
        ),
        // Unicode in quoted format string
        FromStringRow(
            "\U0001F923\U0001F9232020\U0001F44D09\U0001F92321",
            "'\U0001F923\U0001F923'yyyy\U0001F44DMM\U0001F923dd",
            QDate(2020, 9, 21)
        ),
        // QTBUG-84334
        // -ve year: front, nosep
        FromStringRow("-20060521", "yyyyMMdd", QDate(-2006, 5, 21)),
        // -ve year: mid, nosep
        FromStringRow("05-200621", "MMyyyydd", QDate(-2006, 5, 21)),
        // -ve year: back, nosep
        FromStringRow("0521-2006", "MMddyyyy", QDate(-2006, 5, 21)),
        // -ve year: front, dash
        FromStringRow("-2006-05-21", "yyyy-MM-dd", QDate(-2006, 5, 21)),
        // positive year: front, dash
        FromStringRow("-2006-05-21", "-yyyy-MM-dd", QDate(2006, 5, 21)),
        // -ve year: mid, dash
        FromStringRow("05--2006-21", "MM-yyyy-dd", QDate(-2006, 5, 21)),
        // -ve year: back, dash
        FromStringRow("05-21--2006", "MM-dd-yyyy", QDate(-2006, 5, 21)),
        // -ve 3digit year: front
        FromStringRow("-206-05-21", "yyyy-MM-dd", QDate()),
        // -ve 3digit year: mid
        FromStringRow("05--206-21", "MM-yyyy-dd", QDate()),
        // -ve 3digit year: back
        FromStringRow("05-21--206", "MM-dd-yyyy", QDate()),
        // -ve 2digit month: mid
        FromStringRow("2060--05-21", "yyyy-MM-dd", QDate()),
        // -ve 2digit month: front
        FromStringRow("-05-2060-21", "MM-yyyy-dd", QDate()),
        // -ve 2digit month: back
        FromStringRow("21-2060--05", "dd-yyyy-MM", QDate()),
        // -ve 1digit month: mid
        FromStringRow("2060--5-21", "yyyy-MM-dd", QDate()),
        // -ve 1digit month: front
        FromStringRow("-5-2060-21", "MM-yyyy-dd", QDate()),
        // -ve 1digit month: back
        FromStringRow("21-2060--5", "dd-yyyy-MM", QDate()),
        // -ve 2digit day: front
        FromStringRow("-21-2060-05", "dd-yyyy-MM", QDate()),
        // -ve 2digit day: mid
        FromStringRow("2060--21-05", "yyyy-dd-MM", QDate()),
        // -ve 2digit day: back
        FromStringRow("05-2060--21", "MM-yyyy-dd", QDate()),
        // -ve 1digit day: front
        FromStringRow("-2-2060-05", "dd-yyyy-MM", QDate()),
        // -ve 1digit day: mid
        FromStringRow("05--2-2060", "MM-dd-yyyy", QDate()),
        // -ve 1digit day: back
        FromStringRow("2060-05--2", "yyyy-MM-dd", QDate()),
        // 3digit year, front
        FromStringRow("206-05-21", "yyyy-MM-dd", QDate()),
        // 3digit year, mid
        FromStringRow("05-206-21", "MM-yyyy-dd", QDate()),
        // 3digit year, back
        FromStringRow("05-21-206", "MM-dd-yyyy", QDate()),
        // 5digit year, front
        FromStringRow("00206-05-21", "yyyy-MM-dd", QDate()),
        // 5digit year, mid
        FromStringRow("05-00206-21", "MM-yyyy-dd", QDate()),
        // 5digit year, back
        FromStringRow("05-21-00206", "MM-dd-yyyy", QDate()),
        // dash separator, no year at end
        FromStringRow("05-21-", "dd-MM-yyyy", QDate()),
        // slash separator, no year at end
        FromStringRow("11/05/", "d/MM/yyyy", QDate()),
        // QTBUG-84349
        // + sign in year field
        FromStringRow("+0200322", "yyyyMMdd", QDate()),
        // + sign in month field
        FromStringRow("2020+322", "yyyyMMdd", QDate()),
        // + sign in day field
        FromStringRow("202003+1", "yyyyMMdd", QDate()),
    ];
}

// fromStringFormat
unittest
{
    foreach (i, ref r; fromStringFormat_data())
    {
        QString s = QString(r.s);
        QString fmt = QString(r.format);
        QDate got = QDate.fromString(s, qToStringViewIgnoringNull(fmt), QCalendar.create());
        assert(got == r.expected, "fromStringFormat row " ~ i.to!string ~ " ('" ~ r.s ~ "' / '" ~ r.format ~ "')");
    }
}

/+ #endif +/

private struct ToStringRow
{
    QDate t;
    string format, str;
}
private ToStringRow[] toStringFormat_data()
{
    return [
        // data0
        ToStringRow(QDate(1995, 5, 20), "d-M-yy", "20-5-95"),
        // data1
        ToStringRow(QDate(2002, 12, 17), "dd-MM-yyyy", "17-12-2002"),
        // data2
        ToStringRow(QDate(1995, 5, 20), "M-yy", "5-95"),
        // data3
        ToStringRow(QDate(2002, 12, 17), "dd", "17"),
    ];
}

// toStringFormat
unittest
{
    const string ctx = "toStringFormat";
    foreach (i, ref r; toStringFormat_data())
    {
        QString fmt = QString(r.format);
        QString got = r.t.toString(fmt, QCalendar.create());
        assert(got == r.str, "toStringFormat row " ~ i.to!string);
    }
    // Invalid date renders empty.
    assert(QDate().toString(QString("dd-mm-yyyy"), QCalendar.create()) == "", ctx);
}

private struct ToStringDateRow
{
    QDate date;
    DateFormat fmt;
    string expected;
}
private ToStringDateRow[] toStringDateFormat_data()
{
    return [
        // data0
        ToStringDateRow(QDate(1, 1, 1), DateFormat.ISODate, "0001-01-01"),
        // data1
        ToStringDateRow(QDate(11, 1, 1), DateFormat.ISODate, "0011-01-01"),
        // data2
        ToStringDateRow(QDate(111, 1, 1), DateFormat.ISODate, "0111-01-01"),
        // data3
        ToStringDateRow(QDate(1974, 12, 1), DateFormat.ISODate, "1974-12-01"),
        // year < 0
        ToStringDateRow(QDate(-1, 1, 1), DateFormat.ISODate, ""),
        // year > 9999
        ToStringDateRow(QDate(10_000, 1, 1), DateFormat.ISODate, ""),
        // RFC2822Date
        ToStringDateRow(QDate(1974, 12, 1), DateFormat.RFC2822Date, "01 Dec 1974"),
        // ISODateWithMs
        ToStringDateRow(QDate(1974, 12, 1), DateFormat.ISODateWithMs, "1974-12-01"),
    ];
}

// toStringDateFormat
unittest
{
    foreach (i, ref r; toStringDateFormat_data())
    {
        QString got = r.date.toString(r.fmt);
        assert(got == r.expected, "toStringDateFormat row " ~ i.to!string);
    }
}

/+ #endif +/

// isLeapYear
unittest
{
    const string ctx = "isLeapYear";
    assert(QDate.isLeapYear(-4801), ctx);
    assert(!QDate.isLeapYear(-4800), ctx);
    assert(QDate.isLeapYear(-4445), ctx);
    assert(!QDate.isLeapYear(-4444), ctx);
    assert(!QDate.isLeapYear(-6), ctx);
    assert(QDate.isLeapYear(-5), ctx);
    assert(!QDate.isLeapYear(-4), ctx);
    assert(!QDate.isLeapYear(-3), ctx);
    assert(!QDate.isLeapYear(-2), ctx);
    assert(QDate.isLeapYear(-1), ctx);
    assert(!QDate.isLeapYear(0), ctx); // Doesn't exist
    assert(!QDate.isLeapYear(1), ctx);
    assert(!QDate.isLeapYear(2), ctx);
    assert(!QDate.isLeapYear(3), ctx);
    assert(QDate.isLeapYear(4), ctx);
    assert(!QDate.isLeapYear(7), ctx);
    assert(QDate.isLeapYear(8), ctx);
    assert(!QDate.isLeapYear(100), ctx);
    assert(QDate.isLeapYear(400), ctx);
    assert(!QDate.isLeapYear(700), ctx);
    assert(!QDate.isLeapYear(1500), ctx);
    assert(QDate.isLeapYear(1600), ctx);
    assert(!QDate.isLeapYear(1700), ctx);
    assert(!QDate.isLeapYear(1800), ctx);
    assert(!QDate.isLeapYear(1900), ctx);
    assert(QDate.isLeapYear(2000), ctx);
    assert(!QDate.isLeapYear(2100), ctx);
    assert(!QDate.isLeapYear(2200), ctx);
    assert(!QDate.isLeapYear(2300), ctx);
    assert(QDate.isLeapYear(2400), ctx);
    assert(!QDate.isLeapYear(2500), ctx);
    assert(!QDate.isLeapYear(2600), ctx);
    assert(!QDate.isLeapYear(2700), ctx);
    assert(QDate.isLeapYear(2800), ctx);

    for (int i = -4713; i <= 10_000; ++i)
    {
        if (i == 0)
            continue;
        assert(!QDate(i, 2, 29).isValid() == !QDate.isLeapYear(i), "leap roundtrip " ~ i.to!string);
    }
}

// yearsZeroToNinetyNine
unittest
{
    const string ctx = "yearsZeroToNinetyNine";
    {
        QDate dt = QDate(-1, 2, 3);
        assert(dt.year() == -1 && dt.month() == 2 && dt.day() == 3, ctx);
    }
    {
        QDate dt = QDate(1, 2, 3);
        assert(dt.year() == 1 && dt.month() == 2 && dt.day() == 3, ctx);
    }
    {
        QDate dt = QDate(99, 2, 3);
        assert(dt.year() == 99 && dt.month() == 2 && dt.day() == 3, ctx);
    }
    assert(!QDate.isValid(0, 2, 3), ctx);
    assert(QDate.isValid(1, 2, 3), ctx);
    assert(QDate.isValid(-1, 2, 3), ctx);

    {
        QDate dt;
        dt.setDate(1, 2, 3);
        assert(dt.year() == 1 && dt.month() == 2 && dt.day() == 3, ctx);
        dt.setDate(0, 2, 3);
        assert(!dt.isValid(), ctx);
    }
}

private struct NegYearRow
{
    int year;
    string expect;
}
private NegYearRow[] printNegativeYear_data()
{
    return [
        // millennium
        NegYearRow(-1000, "-1000"),
        // century
        NegYearRow(-500, "-0500"),
        // decade
        NegYearRow(-20, "-0020"),
        // year
        NegYearRow(-7, "-0007"),
    ];
}

// printNegativeYear
unittest
{
    auto locale = QLocale.create();

    if (locale.negativeSign() != "-")
    {
        gate("printNegativeYear", "QLocale().negativeSign() is not '-'; locale-specific rendering not covered");
        return;
    }
    foreach (i, ref r; printNegativeYear_data())
    {
        QDate date = QDate(r.year, 3, 4);
        assert(date.isValid(), "printNegativeYear valid " ~ i.to!string);
        assert(date.year() == r.year, "printNegativeYear year " ~ i.to!string);
        assert(date.toString(QString("yyyy"), QCalendar.create()) == r.expect, "printNegativeYear row " ~ i.to!string);
    }
}

/+ #if QT_CONFIG(datestring) +/
// roundtripString
unittest
{
    const string ctx = "roundtripString";
    /* This code path should not result in warnings. */
    QDate date = QDate.currentDate();
    assert(QDate.fromString(date.toString(DateFormat.TextDate), DateFormat.TextDate) == date, ctx);

    QDateTime now = QDateTime.currentDateTime();
    // TextDate discards milliseconds, so clip to whole second:
    QDateTime when = now.addMSecs(-now.time().msec());
    assert(QDateTime.fromString(when.toString(DateFormat.TextDate), DateFormat.TextDate) == when, ctx);
}
/+ #endif +/

// roundtrip
unittest
{
    const string ctx = "roundtrip";
    // Test round trip, this exercises setDate(), isValid(), isLeapYear(),
    // year(), month(), day(), julianDayFromDate(), and getDateFromJulianDay()
    // to ensure they are internally consistent (but doesn't guarantee correct)

    // Test Julian round trip around JD 0 and the c++ integer division rounding
    // problem point (eg. negative numbers) in the conversion functions.
    QDate testDate;
    QDate loopDate = QDate.fromJulianDay(-50_001); // 1 Jan 4850 BC
    while (loopDate.toJulianDay() <= 5150)     // 31 Dec 4700 BC
    {
        testDate.setDate(loopDate.year(), loopDate.month(), loopDate.day());
        assert(loopDate.toJulianDay() == testDate.toJulianDay(), ctx);
        loopDate = loopDate.addDays(1);
    }

    // Test Julian round trip in both BC and AD
    loopDate = QDate.fromJulianDay(1_684_901);       //  1 Jan 100 BC
    while (loopDate.toJulianDay() <= 1_757_949)   // 31 Dec 100 AD
    {
        testDate.setDate(loopDate.year(), loopDate.month(), loopDate.day());
        assert(loopDate.toJulianDay() == testDate.toJulianDay(), ctx);
        loopDate = loopDate.addDays(1);
    }

    // Test Gregorian round trip at top end of widget/format range
    loopDate = QDate.fromJulianDay(2_378_497);     //  1 Jan 9900 AD
    while (loopDate.toJulianDay() <= 2_488_433) // 31 Dec 9999 AD
    {
        testDate.setDate(loopDate.year(), loopDate.month(), loopDate.day());
        assert(loopDate.toJulianDay() == testDate.toJulianDay(), ctx);
        loopDate = loopDate.addDays(1);
    }

    // Test Gregorian round trip at top end of widget/format range
    loopDate = QDate.fromJulianDay(5_336_961);     //  1 Jan 9900 AD
    while (loopDate.toJulianDay() <= 5_373_484) // 31 Dec 9999 AD
    {
        testDate.setDate(loopDate.year(), loopDate.month(), loopDate.day());
        assert(loopDate.toJulianDay() == testDate.toJulianDay(), ctx);
        loopDate = loopDate.addDays(1);
    }

    enum long minJd = -784_350_574_879L;
    enum long maxJd = 784_354_017_364L;

    // Test Gregorian round trip at top end of conversion range
    loopDate = QDate.fromJulianDay(maxJd);
    while (loopDate.toJulianDay() >= maxJd - 146_397)
    {
        testDate.setDate(loopDate.year(), loopDate.month(), loopDate.day());
        assert(loopDate.toJulianDay() == testDate.toJulianDay(), ctx);
        loopDate = loopDate.addDays(-1);
    }

    // Test Gregorian round trip at low end of conversion range
    loopDate = QDate.fromJulianDay(minJd);
    while (loopDate.toJulianDay() <= minJd + 146_397)
    {
        testDate.setDate(loopDate.year(), loopDate.month(), loopDate.day());
        assert(loopDate.toJulianDay() == testDate.toJulianDay(), ctx);
        loopDate = loopDate.addDays(1);
    }
}

/*
 * BINDING GAP: QDebug operator<< for QDate is not exposed by the D bindings.
 * The direct port of qdebug is below, commented out with the environment it
 * would need (QtTest's ignoreMessage):
 *
 * unittest
 * {
 *     // QTest::ignoreMessage(QtDebugMsg, "QDate(Invalid)");
 *     qDebug() << QDate();
 *     // QTest::ignoreMessage(QtDebugMsg, "QDate(\"1983-08-07\")");
 *     qDebug() << QDate(1983, 8, 7);
 * }
 */

