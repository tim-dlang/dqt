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
module qt.multimedia.mediatimerange;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.list;
import qt.core.metatype;
import qt.core.shareddata;
import qt.core.typeinfo;
import qt.helpers;

extern(C++, class) struct QMediaTimeRangePrivate;

/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QMediaTimeRangePrivate, Q_MULTIMEDIA_EXPORT) +/
/// Binding for C++ class [QMediaTimeRange](https://doc.qt.io/qt-6/qmediatimerange.html).
@Q_DECLARE_METATYPE @Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_MULTIMEDIA_EXPORT +/ QMediaTimeRange
{
public:
    @Q_DECLARE_METATYPE extern(C++, struct) struct Interval
    {
        /+ constexpr Interval() noexcept = default; +/
        /+ explicit +/ this(qint64 start, qint64 end)/+ noexcept+/
        {
            this.s = start;
            this.e = end;
        }

        qint64 start() const/+ noexcept+/ { return s; }
        qint64 end() const/+ noexcept+/ { return e; }

        bool contains(qint64 time) const/+ noexcept+/
        {
            return isNormal() ? (s <= time && time <= e)
                : (e <= time && time <= s);
        }

        bool isNormal() const/+ noexcept+/ { return s <= e; }
        Interval normalized() const
        {
            return s > e ? Interval(e, s) : this;
        }
        Interval translated(qint64 offset) const
        {
            return Interval(s + offset, e + offset);
        }

        /+ friend constexpr bool operator==(Interval lhs, Interval rhs) noexcept
        {
            return lhs.start() == rhs.start() && lhs.end() == rhs.end();
        } +/
        /+ friend constexpr bool operator!=(Interval lhs, Interval rhs) noexcept
        {
            return lhs.start() != rhs.start() || lhs.end() != rhs.end();
        } +/

    private:
        /+ friend class QMediaTimeRangePrivate; +/
        qint64 s = 0;
        qint64 e = 0;
    }

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ explicit +/this(qint64 start, qint64 end);
    this(ref const(Interval));
    @disable this(this);
    this(ref const(QMediaTimeRange) range)/+ noexcept+/;
    ~this();

    ref QMediaTimeRange opAssign(ref const(QMediaTimeRange))/+ noexcept+/;

    /+ QMediaTimeRange(QMediaTimeRange &&other) noexcept = default; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QMediaTimeRange) +/
    /+ void swap(QMediaTimeRange &other) noexcept
    { d.swap(other.d); } +/
    void detach();

    ref QMediaTimeRange opAssign(ref const(Interval));

    qint64 earliestTime() const;
    qint64 latestTime() const;

    QList!(Interval) intervals() const;
    bool isEmpty() const;
    bool isContinuous() const;

    bool contains(qint64 time) const;

    void addInterval(qint64 start, qint64 end);
    void addInterval(ref const(Interval) interval);
    void addTimeRange(ref const(QMediaTimeRange));

    void removeInterval(qint64 start, qint64 end);
    void removeInterval(ref const(Interval) interval);
    void removeTimeRange(ref const(QMediaTimeRange));

    ref QMediaTimeRange opOpAssign(string op)(ref const(QMediaTimeRange)) if (op == "+");
    ref QMediaTimeRange opOpAssign(string op)(ref const(Interval)) if (op == "+");
    ref QMediaTimeRange opOpAssign(string op)(ref const(QMediaTimeRange)) if (op == "-");
    ref QMediaTimeRange opOpAssign(string op)(ref const(Interval)) if (op == "-");

    void clear();

    /+ friend inline bool operator==(const QMediaTimeRange &lhs, const QMediaTimeRange &rhs)
    { return lhs.intervals() == rhs.intervals(); } +/
    /+ friend inline bool operator!=(const QMediaTimeRange &lhs, const QMediaTimeRange &rhs)
    { return lhs.intervals() != rhs.intervals(); } +/

private:
    QExplicitlySharedDataPointer!(QMediaTimeRangePrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug, const QMediaTimeRange::Interval &);
Q_MULTIMEDIA_EXPORT QDebug operator<<(QDebug, const QMediaTimeRange &);
#endif +/

/+pragma(inline, true) QMediaTimeRange operator +(ref const(QMediaTimeRange) r1, ref const(QMediaTimeRange) r2)
{ return (QMediaTimeRange(r1) += r2); }+/
/+pragma(inline, true) QMediaTimeRange operator -(ref const(QMediaTimeRange) r1, ref const(QMediaTimeRange) r2)
{ return (QMediaTimeRange(r1) -= r2); }+/

/+ Q_DECLARE_SHARED(QMediaTimeRange)


Q_DECLARE_METATYPE(QMediaTimeRange)
Q_DECLARE_METATYPE(QMediaTimeRange::Interval) +/

