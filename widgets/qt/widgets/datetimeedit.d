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
module qt.widgets.datetimeedit;
extern(C++):

import qt.config;
import qt.core.calendar;
import qt.core.coreevent;
import qt.core.datetime;
import qt.core.flags;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.size;
import qt.core.string;
import qt.core.variant;
import qt.gui.event;
import qt.helpers;
import qt.widgets.abstractspinbox;
import qt.widgets.calendarwidget;
import qt.widgets.styleoption;
import qt.widgets.widget;
version(QT_NO_VALIDATOR){}else
    import qt.gui.validator;

/+ QT_REQUIRE_CONFIG(datetimeedit); +/


extern(C++, class) struct QDateTimeEditPrivate;
/+ class QStyleOptionSpinBox;
class QCalendarWidget; +/

class /+ Q_WIDGETS_EXPORT +/ QDateTimeEdit : QAbstractSpinBox
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QDateTime dateTime READ dateTime WRITE setDateTime NOTIFY dateTimeChanged USER true)
    Q_PROPERTY(QDate date READ date WRITE setDate NOTIFY dateChanged)
    Q_PROPERTY(QTime time READ time WRITE setTime NOTIFY timeChanged)
    Q_PROPERTY(QDateTime maximumDateTime READ maximumDateTime WRITE setMaximumDateTime RESET clearMaximumDateTime)
    Q_PROPERTY(QDateTime minimumDateTime READ minimumDateTime WRITE setMinimumDateTime RESET clearMinimumDateTime)
    Q_PROPERTY(QDate maximumDate READ maximumDate WRITE setMaximumDate RESET clearMaximumDate)
    Q_PROPERTY(QDate minimumDate READ minimumDate WRITE setMinimumDate RESET clearMinimumDate)
    Q_PROPERTY(QTime maximumTime READ maximumTime WRITE setMaximumTime RESET clearMaximumTime)
    Q_PROPERTY(QTime minimumTime READ minimumTime WRITE setMinimumTime RESET clearMinimumTime)
    Q_PROPERTY(Section currentSection READ currentSection WRITE setCurrentSection)
    Q_PROPERTY(Sections displayedSections READ displayedSections)
    Q_PROPERTY(QString displayFormat READ displayFormat WRITE setDisplayFormat)
    Q_PROPERTY(bool calendarPopup READ calendarPopup WRITE setCalendarPopup)
    Q_PROPERTY(int currentSectionIndex READ currentSectionIndex WRITE setCurrentSectionIndex)
    Q_PROPERTY(int sectionCount READ sectionCount)
    Q_PROPERTY(Qt::TimeSpec timeSpec READ timeSpec WRITE setTimeSpec) +/
public:
    enum Section { // a sub-type of QDateTimeParser's like-named enum.
        NoSection = 0x0000,
        AmPmSection = 0x0001,
        MSecSection = 0x0002,
        SecondSection = 0x0004,
        MinuteSection = 0x0008,
        HourSection   = 0x0010,
        DaySection    = 0x0100,
        MonthSection  = 0x0200,
        YearSection   = 0x0400,
        TimeSections_Mask = Section.AmPmSection|Section.MSecSection|Section.SecondSection|Section.MinuteSection|Section.HourSection,
        DateSections_Mask = Section.DaySection|Section.MonthSection|Section.YearSection
    }
    /+ Q_ENUM(Section) +/

    /+ Q_DECLARE_FLAGS(Sections, Section) +/
alias Sections = QFlags!(Section);    /+ Q_FLAG(Sections) +/

    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QDateTime) dt, QWidget parent = null);
    /+ explicit +/this(ref const(QDate) d, QWidget parent = null);
    /+ explicit +/this(ref const(QTime) t, QWidget parent = null);
    ~this();

    final QDateTime dateTime() const;
    final QDate date() const;
    final QTime time() const;

    final QCalendar calendar() const;
    final void setCalendar(QCalendar calendar);

    final QDateTime minimumDateTime() const;
    final void clearMinimumDateTime();
    final void setMinimumDateTime(ref const(QDateTime) dt);

    final QDateTime maximumDateTime() const;
    final void clearMaximumDateTime();
    final void setMaximumDateTime(ref const(QDateTime) dt);

    final void setDateTimeRange(ref const(QDateTime) min, ref const(QDateTime) max);

    final QDate minimumDate() const;
    final void setMinimumDate(ref const(QDate) min);
    final void clearMinimumDate();

    final QDate maximumDate() const;
    final void setMaximumDate(ref const(QDate) max);
    final void clearMaximumDate();

    final void setDateRange(ref const(QDate) min, ref const(QDate) max);

    final QTime minimumTime() const;
    final void setMinimumTime(ref const(QTime) min);
    final void clearMinimumTime();

    final QTime maximumTime() const;
    final void setMaximumTime(ref const(QTime) max);
    final void clearMaximumTime();

    final void setTimeRange(ref const(QTime) min, ref const(QTime) max);

    final Sections displayedSections() const;
    final Section currentSection() const;
    final Section sectionAt(int index) const;
    final void setCurrentSection(Section section);

    final int currentSectionIndex() const;
    final void setCurrentSectionIndex(int index);

    final QCalendarWidget calendarWidget() const;
    final void setCalendarWidget(QCalendarWidget calendarWidget);

    final int sectionCount() const;

    final void setSelectedSection(Section section);

    final QString sectionText(Section section) const;

    final QString displayFormat() const;
    final void setDisplayFormat(ref const(QString) format);

    final bool calendarPopup() const;
    final void setCalendarPopup(bool enable);

    final /+ Qt:: +/qt.core.namespace.TimeSpec timeSpec() const;
    final void setTimeSpec(/+ Qt:: +/qt.core.namespace.TimeSpec spec);

    override QSize sizeHint() const;

    override void clear();
    override void stepBy(int steps);

    override bool event(QEvent event);
/+ Q_SIGNALS +/public:
    @QSignal final void dateTimeChanged(ref const(QDateTime) dateTime);
    @QSignal final void timeChanged(ref const(QTime) time);
    @QSignal final void dateChanged(ref const(QDate) date);

public /+ Q_SLOTS +/:
    @QSlot final void setDateTime(ref const(QDateTime) dateTime);
    @QSlot final void setDate(ref const(QDate) date);
    @QSlot final void setTime(ref const(QTime) time);

protected:
    override void keyPressEvent(QKeyEvent event);
/+ #if QT_CONFIG(wheelevent) +/
    override void wheelEvent(QWheelEvent event);
/+ #endif +/
    override void focusInEvent(QFocusEvent event);
    override bool focusNextPrevChild(bool next);
    override QValidator.State validate(ref QString input, ref int pos) const;
    override void fixup(ref QString input) const;

    /+ virtual +/ QDateTime dateTimeFromText(ref const(QString) text) const;
    /+ virtual +/ QString textFromDateTime(ref const(QDateTime) dt) const;
    override StepEnabled stepEnabled() const;
    override void mousePressEvent(QMouseEvent event);
    override void paintEvent(QPaintEvent event);
//    final void initStyleOption(QStyleOptionSpinBox* option) const;

/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    this(ref const(QVariant) val, QVariant.Type parserType, QWidget parent = null);
/+ #endif +/
    this(ref const(QVariant) val, QMetaType.Type parserType, QWidget parent = null);
private:
    /+ Q_DECLARE_PRIVATE(QDateTimeEdit) +/
    /+ Q_DISABLE_COPY(QDateTimeEdit) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_resetButton()) +/
}

class /+ Q_WIDGETS_EXPORT +/ QTimeEdit : QDateTimeEdit
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QTime time READ time WRITE setTime NOTIFY userTimeChanged USER true) +/
public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QTime) time, QWidget parent = null);
    ~this();

/+ Q_SIGNALS +/public:
    @QSignal final void userTimeChanged(ref const(QTime) time);
}

class /+ Q_WIDGETS_EXPORT +/ QDateEdit : QDateTimeEdit
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QDate date READ date WRITE setDate NOTIFY userDateChanged USER true) +/
public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QDate) date, QWidget parent = null);
    ~this();

/+ Q_SIGNALS +/public:
    @QSignal final void userDateChanged(ref const(QDate) date);
}
/+pragma(inline, true) QFlags!(QDateTimeEdit.Sections.enum_type) operator |(QDateTimeEdit.Sections.enum_type f1, QDateTimeEdit.Sections.enum_type f2)/+noexcept+/{return QFlags!(QDateTimeEdit.Sections.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QDateTimeEdit.Sections.enum_type) operator |(QDateTimeEdit.Sections.enum_type f1, QFlags!(QDateTimeEdit.Sections.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QDateTimeEdit.Sections.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QDateTimeEdit::Sections) +/
