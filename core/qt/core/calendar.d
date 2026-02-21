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
module qt.core.calendar;
extern(C++):

import qt.config;
import qt.core.anystringview;
import qt.core.datetime;
import qt.core.locale;
import qt.core.metamacros;
import qt.core.string;
import qt.core.stringlist;
import qt.core.stringview;
import qt.helpers;

/* Suggested enum names for other calendars known to CLDR (v33.1)

   Not yet implemented - see QCalendar::System - contributions welcome:

   * Buddhist -- Thai Buddhist, to be specific
   * Chinese
   * Coptic
   * Dangi -- Korean
   * Ethiopic (Amete Mihret - epoch approx. 8 C.E.)
   * EthiopicAmeteAlem (Amete Alem - epoch approx. 5493 B.C.E; data from
     type="ethiopic-amete-alem", an alias for type="ethioaa")
   * Hebrew
   * Indian -- National
   * Islamic -- Based on astronomical observations, not predictions, so hard to
     implement. CLDR's data for type="islamic" apply, unless overridden, to the
     other Islamic calendar variants, i.e. IslamicCivil, above, and the three
     following. See QHijriCalendar, a common base to provide that data.
   * IslamicTabular -- tabular, astronomical epoch (same as IslamicCivil, except
     for epoch), CLDR type="islamic-tbla"
   * Saudi -- Saudi Arabia, sighting; CLDR type="islamic-rgsa"
   * UmmAlQura -- Umm al-Qura, Saudi Arabia, calculated; CLDR type="islamic-umalqura"
   * Iso8601 -- as Gregorian, but treating ISO 8601 weeks as "months"
   * Japanese -- Imperial calendar
   * Minguo -- Republic of China, Taiwan; CLDR type="roc"

   See:
   http://www.unicode.org/repos/cldr/tags/latest/common/bcp47/calendar.xml

   These can potentially be supported, as features, using CLDR's data; any
   others shall need hand-crafted localization data; it would probably be best
   to do that by contributing data for them to CLDR.
*/


extern(C++, class) struct QCalendarBackend;

/// Binding for C++ class [QCalendar](https://doc.qt.io/qt-6/qcalendar.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QCalendar
{
    mixin(Q_GADGET);
public:
    // (Extra parentheses to suppress bogus reading of min() as a macro.)
    enum int Unspecified = int.min;
    // Workaround for https://issues.dlang.org/show_bug.cgi?id=20701
    extern(C++, struct) struct YearMonthDay
    {
        /+ YearMonthDay() = default; +/
        this(int y, int m = 1, int d = 1)
        {
            this.year = y;
            this.month = m;
            this.day = d;
        }

        bool isValid() const
        { return month != Unspecified && day != Unspecified; }
        // (The first year supported by QDate has year == Unspecified.)

        int year = Unspecified;
        int month = Unspecified;
        int day = Unspecified;
    }
    // Feature (\w+)calendar uses CLDR type="\1" data, except as noted in type="..." comments below
    enum /+ class +/ System
    {
        Gregorian, // CLDR: type = "gregory", alias = "gregorian"
/+ #ifndef QT_BOOTSTRAPPED +/
        Julian = 8,
        Milankovic = 9,
/+ #endif // These are Roman-based, so share Gregorian's CLDR data

        // Feature-controlled calendars:
#if QT_CONFIG(jalalicalendar) +/ // type="persian"
        Jalali = 10,
/+ #endif
#if QT_CONFIG(islamiccivilcalendar) +/ // type="islamic-civil", uses data from type="islamic"
        IslamicCivil = 11,
        // tabular, civil epoch
        // 30 year cycle, leap on 2, 5, 7, 10, 13, 16, 18, 21, 24, 26 and 29
        // (Other variants: 2, 5, 8, (10|11), 13, 16, 19, 21, 24, 27 and 29.)
/+ #endif +/

        Last = 11, // Highest number of any above
        User = -1
    }
    // New entries must be added to the \enum doc in qcalendar.cpp and
    // handled in QCalendarBackend::fromEnum()
    /+ Q_ENUM(System) +/
    /// Binding for C++ class [QCalendar::SystemId](https://doc.qt.io/qt-6/qcalendar-systemid.html).
    extern(C++, class) struct SystemId
    {
    private:
        size_t id = ~size_t(0);
        /+ friend class QCalendarBackend; +/
        bool isInEnum() const { return id <= size_t(QCalendar.System.Last); }
        /+ explicit +/this(QCalendar.System e)
        {
            this.id = size_t(e);
        }
        /+ explicit +/this(size_t i)
        {
            this.id = i;
        }

    public:
        @disable this();
        /+this()
        {
            this.id = UnresolvedMergeConflict!(q{~size_t(0)},q{~size_t(0)});
        }+/
        size_t index() const nothrow { return id; }
        bool isValid() const nothrow { return (~id) != 0; }
    }

    @disable this();
    /+ explicit +/pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }
 // Gregorian, optimised
    /+ explicit +/this(System system);
    static if (defined!"QT_CORE_BUILD_REMOVED_API")
    {
        /+ explicit +/this(QLatin1StringView name);
        /+ explicit +/this(QStringView name);
    }
    /+ explicit +/this(QAnyStringView name);
    /+ explicit +/this(SystemId id);

    // QCalendar is a trivially copyable value type.
    bool isValid() const { return d_ptr !is null; }

    // Date queries:
    int daysInMonth(int month, int year = Unspecified) const;
    int daysInYear(int year) const;
    int monthsInYear(int year) const;
    bool isDateValid(int year, int month, int day) const;

    // Leap years:
    bool isLeapYear(int year) const;

    // Properties of the calendar:
    bool isGregorian() const;
    bool isLunar() const;
    bool isLuniSolar() const;
    bool isSolar() const;
    bool isProleptic() const;
    bool hasYearZero() const;
    int maximumDaysInMonth() const;
    int minimumDaysInMonth() const;
    int maximumMonthsInYear() const;
    QString name() const;

    // QDate conversions:
    QDate dateFromParts(int year, int month, int day) const;
    QDate dateFromParts(ref const(YearMonthDay) parts) const;
    YearMonthDay partsFromDate(QDate date) const;
    int dayOfWeek(QDate date) const;

    // Month and week-day names (as in QLocale):
    QString monthName(ref const(QLocale) locale, int month, int year = Unspecified,
                          QLocale.FormatType format=QLocale.FormatType.LongFormat) const;
    QString standaloneMonthName(ref const(QLocale) locale, int month, int year = Unspecified,
                                    QLocale.FormatType format = QLocale.FormatType.LongFormat) const;
    QString weekDayName(ref const(QLocale) locale, int day,
                            QLocale.FormatType format = QLocale.FormatType.LongFormat) const;
    QString standaloneWeekDayName(ref const(QLocale) locale, int day,
                                      QLocale.FormatType format=QLocale.FormatType.LongFormat) const;

    // Formatting of date-times:
    QString dateTimeToString(QStringView format, ref const(QDateTime) datetime,
                                 QDate dateOnly, QTime timeOnly,
                                 ref const(QLocale) locale) const;

    // What's available ?
    static QStringList availableCalendars();
private:
    // Always supplied by QCalendarBackend and expected to be a singleton
    // Note that the calendar registry destroys all backends when it is itself
    // destroyed. The code should check if the registry is destroyed before
    // dereferencing this pointer.
    const(QCalendarBackend)* d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

