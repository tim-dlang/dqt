/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.widgets.calendarwidget;
extern(C++):

import qt.config;
import qt.core.calendar;
import qt.core.coreevent;
import qt.core.datetime;
import qt.core.map;
import qt.core.namespace;
import qt.core.object;
import qt.core.rect;
import qt.core.size;
import qt.gui.event;
import qt.gui.painter;
import qt.gui.textformat;
import qt.helpers;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(calendarwidget);


class QDate;
class QTextCharFormat; +/
extern(C++, class) struct QCalendarWidgetPrivate;

class /+ Q_WIDGETS_EXPORT +/ QCalendarWidget : QWidget
{
    mixin(Q_OBJECT);
    /+ Q_ENUMS(Qt::DayOfWeek)
    Q_PROPERTY(QDate selectedDate READ selectedDate WRITE setSelectedDate)
    Q_PROPERTY(QDate minimumDate READ minimumDate WRITE setMinimumDate)
    Q_PROPERTY(QDate maximumDate READ maximumDate WRITE setMaximumDate)
    Q_PROPERTY(Qt::DayOfWeek firstDayOfWeek READ firstDayOfWeek WRITE setFirstDayOfWeek)
    Q_PROPERTY(bool gridVisible READ isGridVisible WRITE setGridVisible)
    Q_PROPERTY(SelectionMode selectionMode READ selectionMode WRITE setSelectionMode)
    Q_PROPERTY(HorizontalHeaderFormat horizontalHeaderFormat READ horizontalHeaderFormat WRITE setHorizontalHeaderFormat)
    Q_PROPERTY(VerticalHeaderFormat verticalHeaderFormat READ verticalHeaderFormat WRITE setVerticalHeaderFormat)
    Q_PROPERTY(bool navigationBarVisible READ isNavigationBarVisible WRITE setNavigationBarVisible)
    Q_PROPERTY(bool dateEditEnabled READ isDateEditEnabled WRITE setDateEditEnabled)
    Q_PROPERTY(int dateEditAcceptDelay READ dateEditAcceptDelay WRITE setDateEditAcceptDelay) +/

public:
    enum HorizontalHeaderFormat {
        NoHorizontalHeader,
        SingleLetterDayNames,
        ShortDayNames,
        LongDayNames
    }
    /+ Q_ENUM(HorizontalHeaderFormat) +/

    enum VerticalHeaderFormat {
        NoVerticalHeader,
        ISOWeekNumbers
    }
    /+ Q_ENUM(VerticalHeaderFormat) +/

    enum SelectionMode {
        NoSelection,
        SingleSelection
    }
    /+ Q_ENUM(SelectionMode) +/

    /+ explicit +/this(QWidget parent = null);
    ~this();

    /+ virtual +/ override QSize sizeHint() const;
    /+ virtual +/ override QSize minimumSizeHint() const;

    final QDate selectedDate() const;

    final int yearShown() const;
    final int monthShown() const;

    final QDate minimumDate() const;
    final void setMinimumDate(ref const(QDate) date);

    final QDate maximumDate() const;
    final void setMaximumDate(ref const(QDate) date);

    final /+ Qt:: +/qt.core.namespace.DayOfWeek firstDayOfWeek() const;
    final void setFirstDayOfWeek(/+ Qt:: +/qt.core.namespace.DayOfWeek dayOfWeek);

    final bool isNavigationBarVisible() const;
    final bool isGridVisible() const;

    final QCalendar calendar() const;
    final void setCalendar(QCalendar calendar);

    final SelectionMode selectionMode() const;
    final void setSelectionMode(SelectionMode mode);

    final HorizontalHeaderFormat horizontalHeaderFormat() const;
    final void setHorizontalHeaderFormat(HorizontalHeaderFormat format);

    final VerticalHeaderFormat verticalHeaderFormat() const;
    final void setVerticalHeaderFormat(VerticalHeaderFormat format);

    final QTextCharFormat headerTextFormat() const;
    final void setHeaderTextFormat(ref const(QTextCharFormat) format);

    final QTextCharFormat weekdayTextFormat(/+ Qt:: +/qt.core.namespace.DayOfWeek dayOfWeek) const;
    final void setWeekdayTextFormat(/+ Qt:: +/qt.core.namespace.DayOfWeek dayOfWeek, ref const(QTextCharFormat) format);

//    final QMap!(QDate, QTextCharFormat) dateTextFormat() const;
    final QTextCharFormat dateTextFormat(ref const(QDate) date) const;
    final void setDateTextFormat(ref const(QDate) date, ref const(QTextCharFormat) format);

    final bool isDateEditEnabled() const;
    final void setDateEditEnabled(bool enable);

    final int dateEditAcceptDelay() const;
    final void setDateEditAcceptDelay(int delay);

protected:
    override bool event(QEvent event);
    override bool eventFilter(QObject watched, QEvent event);
    override void mousePressEvent(QMouseEvent event);
    override void resizeEvent(QResizeEvent  event);
    override void keyPressEvent(QKeyEvent  event);

    /+ virtual +/ void paintCell(QPainter* painter, ref const(QRect) rect, ref const(QDate) date) const;
    final void updateCell(ref const(QDate) date);
    final void updateCells();

public /+ Q_SLOTS +/:
    @QSlot final void setSelectedDate(ref const(QDate) date);
    @QSlot final void setDateRange(ref const(QDate) min, ref const(QDate) max);
    @QSlot final void setCurrentPage(int year, int month);
    @QSlot final void setGridVisible(bool show);
    @QSlot final void setNavigationBarVisible(bool visible);
    @QSlot final void showNextMonth();
    @QSlot final void showPreviousMonth();
    @QSlot final void showNextYear();
    @QSlot final void showPreviousYear();
    @QSlot final void showSelectedDate();
    @QSlot final void showToday();

/+ Q_SIGNALS +/public:
    @QSignal final void selectionChanged();
    @QSignal final void clicked(ref const(QDate) date);
    @QSignal final void activated(ref const(QDate) date);
    @QSignal final void currentPageChanged(int year, int month);

private:
    /+ Q_DECLARE_PRIVATE(QCalendarWidget) +/
    /+ Q_DISABLE_COPY(QCalendarWidget) +/

    /+ Q_PRIVATE_SLOT(d_func(), void _q_slotShowDate(const QDate &date))
    Q_PRIVATE_SLOT(d_func(), void _q_slotChangeDate(const QDate &date))
    Q_PRIVATE_SLOT(d_func(), void _q_slotChangeDate(const QDate &date, bool changeMonth))
    Q_PRIVATE_SLOT(d_func(), void _q_editingFinished())
    Q_PRIVATE_SLOT(d_func(), void _q_prevMonthClicked())
    Q_PRIVATE_SLOT(d_func(), void _q_nextMonthClicked())
    Q_PRIVATE_SLOT(d_func(), void _q_yearEditingFinished())
    Q_PRIVATE_SLOT(d_func(), void _q_yearClicked())
    Q_PRIVATE_SLOT(d_func(), void _q_monthChanged(QAction *act)) +/

}

