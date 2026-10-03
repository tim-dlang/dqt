// QT_MODULES: core
module corelib.time.tst_calendar;

import qt.core.calendar;
import qt.core.datetime;
import qt.core.locale;
import qt.core.metaobject : QMetaEnum;
import qt.core.string;
import qt.core.bytearray;
import qt.core.stringlist;
import qt.core.anystringview;
import std.stdio : writeln;
import std.conv : to;
import std.string : fromStringz;

/*
 * Port of qtbase/tests/auto/corelib/time/qcalendar/tst_qcalendar.cpp.
 *
 * Conventions (same as tst_date.d):
 *   - each C++ `*_data` fixture is a separate D function placed immediately
 *     before the test that uses it;
 *   - functionality whose D binding is missing is emitted as commented-out code
 *     with a `// BINDING GAP:` note.
 *
 * The `gregory` test is not ported: it exercises QGregorianCalendar, which is
 * private API (private header `qgregoriancalendar_p.h`, exported with the
 * `Qt_6_PRIVATE_API` tag), so dqt does not ship or test it.
 *
 * The C++ `basic_data` enumerates `QCalendar::System` through the meta-enum;
 * the D port does the same via `QCalendar.staticMetaObject` (bound through the
 * `Q_GADGET` mixin in `qt.core.calendar`). The C++ `#if QT_CONFIG(...)` guards
 * on the optional calendars are reproduced by `systemAvailable()`, which tests
 * membership of that same meta-enum (the D enum members exist regardless of
 * which backends Qt was built with).
 *
 * BINDING GAP: the `QCalendar(QString)` / `QCalendar(string)` convenience
 * constructors are not bound (only `QCalendar(QAnyStringView)` is), so the
 * C++ `QCalendar(cal.name())` / `QCalendar("gregory")` forms go through
 * `calFromName()` / `calFromLiteral()`, which wrap the argument in
 * `QAnyStringView`.
 *
 * BINDING GAP: `QCalendar()` (the default constructor) is not bound as D's
 * `this()` - the binding declares `@disable this();`. Qt's default constructor
 * is out-of-line and does real work: it installs the Gregorian backend
 * (`QCalendar::QCalendar() : d_ptr(QCalendarBackend::gregorian())`,
 * qcalendar.cpp), so it is not a plain field initialiser. D's implicit default
 * construction / `.init` would instead just zero the fields and leave `d_ptr`
 * null (an invalid calendar, diverging from `QCalendar()`); and a
 * D-declared default constructor is unusable in many contexts (array literals,
 * static/immutable/union members) and would not be run by `.init` either. The
 * real C++ constructor is therefore bound as `rawConstructor()` and exposed via
 * the static `create()` factory: `QCalendar.create()` runs the actual
 * `QCalendar()` and yields a valid Gregorian calendar.
 *
 * BINDING GAP: `QCalendar.availableCalendars()` returns a `QStringList`
 * (`QList!(QString)`); destroying that list destroys its `QString` elements
 * through `object.destroy!QString`, which references
 * `core.internal.destruction.destructRecurse!QString`. Some DMD frontends
 * (2.103.x, 2.113.x) do not instantiate that template when the test is compiled
 * with `-i=-qt`, so linking fails with an undefined reference (`LDC` links it
 * fine). The `nameCase` case, which is the only user of the list, is therefore
 * recorded rather than run. Plain `QString` locals/temporaries elsewhere do not
 * trigger this, so the `standaloneMonthName()`/`monthName()` checks in
 * `checkYear` are the equivalent `.isEmpty()` rather than a `QString()`
 * temporary, avoiding a needless allocation.
 */


// BINDING GAP: QCalendar(QString) / QCalendar(string) are not bound; wrap in
// QAnyStringView (the only bound name constructor), mirroring `QCalendar(name)`
// in the source.
private QCalendar calFromName(ref const(QString) name)
{
    return QCalendar(QAnyStringView(name));
}

private QCalendar calFromLiteral(string s)
{
    return QCalendar(QAnyStringView(s));
}

// QString -> D string, for diagnostics (cf. baStr() in tst_timezone.d).
private string qsStr(ref const(QString) s)
{
    QByteArray ba = s.toUtf8();
    return cast(string) ba.constData()[0 .. ba.size()].idup;
}

// checkYear() from the source, used by basic().
private void checkYear(QCalendar cal, int year, bool normal, string ctx)
{
    QLocale loc = QLocale.c();
    const string c = ctx ~ ", year " ~ year.to!string;
    const int moons = cal.monthsInYear(year);
    assert(moons > 0, c);
    assert(!cal.isDateValid(year, moons + 1, 1), c);
    assert(!cal.isDateValid(year, 0, 1), c);
    assert(!QDate(year, 0, 1, cal).isValid(), c);
    assert(moons <= cal.maximumMonthsInYear(), c);
    assert(cal.standaloneMonthName(loc, moons + 1, year).isEmpty(), c);
    assert(cal.monthName(loc, 0, year).isEmpty(), c);

    const int days = cal.daysInYear(year);
    assert(days > 0, c);

    int sum = 0;
    const int longest = cal.maximumDaysInMonth();
    for (int i = moons; i > 0; i--)
    {
        const int last = cal.daysInMonth(i, year);
        sum += last;
        assert(last > 0, c);
        assert(last <= longest, c);
        assert(cal.isDateValid(year, i, 1), c);
        assert(cal.isDateValid(year, i, last), c);
        assert(!cal.isDateValid(year, i, 0), c);
        assert(!cal.isDateValid(year, i, last + 1), c);
        if (normal)
            assert(cal.daysInMonth(i) == last, c);
    }
    assert(sum == days, c);
}

private QCalendar.System[] basic_data()
{
    QCalendar.System[] rows;
    const string ctx = "basic_data";
    QMetaEnum e = QCalendar.staticMetaObject.enumerator(0);
    assert(e.name().fromStringz() == "System", ctx);

    for (int i = 0; i <= cast(int) QCalendar.System.Last; ++i)
    {
        // There may be gaps in the enum's numbering; and Last is a duplicate:
        if (e.value(i) != -1 && e.key(i).fromStringz() != "Last")
            rows ~= cast(QCalendar.System) e.value(i);
    }
    return rows;
}

// Whether a calendar backend is available, mirroring the C++ `#if
// QT_CONFIG(...)` guards: the System meta-enum only lists the calendars
// compiled into this Qt, so membership is the equivalent of those guards.
private bool systemAvailable(QCalendar.System system)
{
    foreach (s; basic_data())
        if (s == system)
            return true;
    return false;
}

// basic
unittest
{
    foreach (i, system; basic_data())
    {
        string ctx = "basic system " ~ i.to!string;
        QCalendar cal = QCalendar(system);
        assert(cal.isValid(), ctx);

        QString nm = cal.name();
        {
            QCalendar byName = calFromName(nm);
            assert(byName.isGregorian() == cal.isGregorian(), ctx);
            assert(byName.name() == cal.name(), ctx);
        }

        if (cal.hasYearZero())
        {
            checkYear(cal, 0, false, ctx);
        }
        else
        {
            assert(cal.monthsInYear(0) == 0, ctx);
            assert(cal.daysInYear(0) == 0, ctx);
            assert(!cal.isDateValid(0, 1, 1), ctx);
            assert(!QDate(0, 1, 1, cal).isValid(), ctx);
        }

        if (cal.isProleptic())
        {
            checkYear(cal, -1, false, ctx);
        }
        else
        {
            assert(cal.monthsInYear(-1) == 0, ctx);
            assert(cal.daysInYear(-1) == 0, ctx);
            assert(!cal.isDateValid(-1, 1, 1), ctx);
        }

        // Look for a leap year in the last decade.
        int year = QDate.currentDate().year(cal);
        for (int k = 10; k > 0 && !cal.isLeapYear(year); --k)
            --year;
        if (cal.isLeapYear(year))
        {
            int leap = year--;
            for (int k = 10; k > 0 && cal.isLeapYear(year); --k)
                year--;
            if (!cal.isLeapYear(year))
            {
                // Diagnostic for the "basic system N" invariant below. Dump the
                // calendar and the computed years so a failure is self-describing.
                const int daysYear = cal.daysInYear(year);
                const int daysLeap = cal.daysInYear(leap);
                const QString calName = cal.name();
                const string diag = "calendar " ~ qsStr(calName)
                    ~ " (system " ~ i.to!string ~ ", enum " ~ (cast(int) system).to!string ~ ")"
                    ~ ", year=" ~ year.to!string
                    ~ " leap=" ~ leap.to!string
                    ~ ", daysInYear(year)=" ~ daysYear.to!string
                    ~ " daysInYear(leap)=" ~ daysLeap.to!string
                    ~ ", isLeapYear(year)=" ~ cal.isLeapYear(year).to!string
                    ~ ", isLeapYear(leap)=" ~ cal.isLeapYear(leap).to!string;
                writeln("DIAG basic ", diag);
                assert(daysYear < daysLeap, ctx ~ " [" ~ diag ~ "]");
            }
            checkYear(cal, leap, false, ctx);
        }
        checkYear(cal, year, true, ctx);
    }
}

// unspecified_data shares basic_data
private QCalendar.System[] unspecified_data() { return basic_data(); }

// unspecified
unittest
{
    foreach (i, system; unspecified_data())
    {
        string ctx = "unspecified system " ~ i.to!string;
        QCalendar cal = QCalendar(system);
        assert(cal.isValid(), ctx);

        const QDate today = QDate.currentDate();
        const int thisYear = today.year();
        assert(cal.monthsInYear(QCalendar.Unspecified) == cal.maximumMonthsInYear(), ctx);
        for (int month = cal.maximumMonthsInYear(); month > 0; month--)
        {
            const int days = cal.daysInMonth(month);
            int count = 0;
            // 19 years = one Metonic cycle (used by some lunar calendars)
            for (int k = 19; k > 0; --k)
            {
                if (cal.daysInMonth(month, thisYear - k) == days)
                    count++;
            }
            assert(count > 9, ctx ~ ": Default daysInMonth() should be for a normal year");
        }
    }
}

// BINDING GAP: `nameCase` uses `QCalendar.availableCalendars()`, whose
// `QStringList` destroys its `QString` elements via `object.destroy!QString`,
// referencing `core.internal.destruction.destructRecurse!QString`. With DMD
// and `-i=-qt` that template is not instantiated, so the test fails to link
// (see the header note). Recorded rather than run; LDC links it.
//
// // nameCase
// unittest
// {
//     const string ctx = "nameCase";
//     QString gregorian = QString("Gregorian");
//     assert(QCalendar.availableCalendars().contains(gregorian), ctx);
// }

private struct SpecificRow
{
    QCalendar.System system;
    string monthName;
    int sysyear, sysmonth, sysday;
    int gregyear, gregmonth, gregday;
}

private SpecificRow[] specific_data()
{
    SpecificRow[] rows;
    void add(QCalendar.System system, string monthName, int y, int m, int d,
            int gy, int gm, int gd)
    {
        if (systemAvailable(system))
            rows ~= SpecificRow(system, monthName, y, m, d, gy, gm, gd);
    }

    add(QCalendar.System.Gregorian, "January", 1970, 1, 1, 1970, 1, 1);

/+ #ifndef QT_BOOTSTRAPPED +/
    // Julian 1582-10-4 was followed by Gregorian 1582-10-15
    add(QCalendar.System.Julian, "October", 1582, 10, 4, 1582, 10, 14);
    // Milankovic matches Gregorian for a few centuries
    add(QCalendar.System.Milankovic, "March", 1923, 3, 20, 1923, 3, 20);
/+ #endif +/

/+ #if QT_CONFIG(jalalicalendar) +/
    // Jalali year 1355 started on Gregorian 1976-3-21
    add(QCalendar.System.Jalali, "Farvardin", 1355, 1, 1, 1976, 3, 21);
/+ #endif +/

/+ #if QT_CONFIG(islamiccivilcalendar) +/
    // Islamic civil epoch
    add(QCalendar.System.IslamicCivil, "Muharram", 1, 1, 1, 622, 7, 19);
/+ #endif +/
    return rows;
}

// specific
unittest
{
    foreach (i, ref r; specific_data())
    {
        string ctx = "specific row " ~ i.to!string;
        const QCalendar cal = QCalendar(r.system);
        QLocale loc = QLocale.c();
        assert(cal.monthName(loc, r.sysmonth) == r.monthName, ctx);
        const QDate date = QDate(r.sysyear, r.sysmonth, r.sysday, cal);
        const QDate gregory = QDate(r.gregyear, r.gregmonth, r.gregday);
        assert(date.toJulianDay() == gregory.toJulianDay(), ctx);
        assert(gregory.year(cal) == r.sysyear, ctx);
        assert(gregory.month(cal) == r.sysmonth, ctx);
        assert(gregory.day(cal) == r.sysday, ctx);
        assert(date.year() == r.gregyear, ctx);
        assert(date.month() == r.gregmonth, ctx);
        assert(date.day() == r.gregday, ctx);
    }
}

// daily_data shares basic_data
private QCalendar.System[] daily_data() { return basic_data(); }

// daily
unittest
{
    foreach (i, system; daily_data())
    {
        string ctx = "daily system " ~ i.to!string;
        QCalendar calendar = QCalendar(system);
        const ulong startJDN = 0, endJDN = 2_488_070;
        // Iterate from -4713-01-01 (Julian calendar) to 2100-01-01.
        for (ulong expect = startJDN; expect <= endJDN; ++expect)
        {
            const string c = ctx ~ ", jdn " ~ expect.to!string;
            QDate date = QDate.fromJulianDay(expect);
            QCalendar.YearMonthDay parts = calendar.partsFromDate(date);
            if (!parts.isValid())
                continue;

            const int year = date.year(calendar);
            assert(year == parts.year, c);
            const int month = date.month(calendar);
            assert(month == parts.month, c);
            const int day = date.day(calendar);
            assert(day == parts.day, c);
            const ulong actual = cast(ulong) QDate(year, month, day, calendar).toJulianDay();
            assert(actual == expect, c);
        }
    }
}

// testYearMonthDate
unittest
{
    const string ctx = "testYearMonthDate";
    QCalendar.YearMonthDay defYMD;
    assert(defYMD.year == QCalendar.Unspecified, ctx);
    assert(defYMD.month == QCalendar.Unspecified, ctx);
    assert(defYMD.day == QCalendar.Unspecified, ctx);

    QCalendar.YearMonthDay ymd2020 = QCalendar.YearMonthDay(2020);
    assert(ymd2020.year == 2020, ctx);
    assert(ymd2020.month == 1, ctx);
    assert(ymd2020.day == 1, ctx);

    assert(!QCalendar.YearMonthDay(QCalendar.Unspecified, QCalendar.Unspecified, QCalendar.Unspecified).isValid(), ctx);
    assert(!QCalendar.YearMonthDay(QCalendar.Unspecified, QCalendar.Unspecified, 1).isValid(), ctx);
    assert(!QCalendar.YearMonthDay(QCalendar.Unspecified, 1, QCalendar.Unspecified).isValid(), ctx);
    assert(QCalendar.YearMonthDay(QCalendar.Unspecified, 1, 1).isValid(), ctx);
    assert(!QCalendar.YearMonthDay(2020, QCalendar.Unspecified, QCalendar.Unspecified).isValid(), ctx);
    assert(!QCalendar.YearMonthDay(2020, QCalendar.Unspecified, 1).isValid(), ctx);
    assert(!QCalendar.YearMonthDay(2020, 1, QCalendar.Unspecified).isValid(), ctx);
    assert(QCalendar.YearMonthDay(2020, 1, 1).isValid(), ctx);
}

private struct PropertiesRow
{
    QCalendar.System system;
    bool gregory, lunar, luniSolar, solar, proleptic, yearZero;
    int monthMax, monthMin, yearMax;
    string name;
}

private PropertiesRow[] properties_data()
{
    PropertiesRow[] rows;
    void add(QCalendar.System system, bool gregory, bool lunar, bool luniSolar,
            bool solar, bool proleptic, bool yearZero, int monthMax, int monthMin,
            int yearMax, string name)
    {
        if (systemAvailable(system))
            rows ~= PropertiesRow(system, gregory, lunar, luniSolar, solar, proleptic,
                    yearZero, monthMax, monthMin, yearMax, name);
    }

    add(QCalendar.System.Gregorian, true, false, false, true, true, false, 31, 28, 12, "Gregorian");

/+ #ifndef QT_BOOTSTRAPPED +/
    add(QCalendar.System.Julian, false, false, false, true, true, false, 31, 28, 12, "Julian");
    add(QCalendar.System.Milankovic, false, false, false, true, true, false, 31, 28, 12, "Milankovic");
/+ #endif +/

/+ #if QT_CONFIG(jalalicalendar) +/
    add(QCalendar.System.Jalali, false, false, false, true, true, false, 31, 29, 12, "Jalali");
/+ #endif +/

/+ #if QT_CONFIG(islamiccivilcalendar) +/
    add(QCalendar.System.IslamicCivil, false, true, false, false, true, false, 30, 29, 12, "Islamic Civil");
/+ #endif +/
    return rows;
}

// properties
unittest
{
    foreach (i, ref r; properties_data())
    {
        string ctx = "properties row " ~ i.to!string;
        const QCalendar cal = QCalendar(r.system);
        assert(cal.isGregorian() == r.gregory, ctx);
        assert(cal.isLunar() == r.lunar, ctx);
        assert(cal.isLuniSolar() == r.luniSolar, ctx);
        assert(cal.isSolar() == r.solar, ctx);
        assert(cal.isProleptic() == r.proleptic, ctx);
        assert(cal.hasYearZero() == r.yearZero, ctx);
        assert(cal.maximumDaysInMonth() == r.monthMax, ctx);
        assert(cal.minimumDaysInMonth() == r.monthMin, ctx);
        assert(cal.maximumMonthsInYear() == r.yearMax, ctx);
        assert(cal.name() == r.name, ctx);
    }
}

// aliases
unittest
{
    const string ctx = "aliases";
    assert(calFromLiteral("gregory").name() == "Gregorian", ctx);

/+ #if QT_CONFIG(jalalicalendar) +/
    if (systemAvailable(QCalendar.System.Jalali))
        assert(calFromLiteral("Persian").name() == "Jalali", ctx);
/+ #endif +/

/+ #if QT_CONFIG(islamiccivilcalendar) +/
    if (systemAvailable(QCalendar.System.IslamicCivil))
    {
        // Exercise all constructors from name, while we're at it.
        assert(calFromLiteral("islamic-civil").name() == "Islamic Civil", ctx);
        assert(calFromLiteral("islamic").name() == "Islamic Civil", ctx);
        assert(calFromLiteral("Islamic").name() == "Islamic Civil", ctx);
    }
/+ #endif +/

    // Invalid is handled gracefully:
    assert(calFromLiteral("").name() == "", ctx);
    assert(QCalendar(QCalendar.System.User).name() == "", ctx);
}

// create
//
// NOTE: this is NOT a ported test - the upstream qcalendar autotest
// (`tst_qcalendar.cpp`) has no `create` case. It is a D-only addition that
// exercises the `QCalendar.create()` factory: `QCalendar()` (the default
// constructor) is not bound - the binding declares `@disable this();` - but the
// static `create()` factory is, so the C++ `QCalendar()` is exercised as
// `QCalendar.create()`. Qt's default constructor defaults to Gregorian
// (`qcalendar.cpp`), so it yields a valid Gregorian calendar.
unittest
{
    const string ctx = "create";
    QCalendar cal = QCalendar.create(); // == QCalendar()
    assert(cal.isValid(), ctx);
    assert(cal.isGregorian(), ctx);
    assert(cal.name() == "Gregorian", ctx);
}
