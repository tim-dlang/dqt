// QT_MODULES: core
module corelib.time.tst_time;

import qt.core.datetime;
import qt.core.string;
import qt.core.namespace;
import std.stdio : writeln;
import std.conv : to;

/*
 * Port of qtbase/tests/auto/corelib/time/qtime/tst_qtime.cpp.
 *
 * Conventions (same as tst_date.d):
 *   - each C++ `*_data` fixture is a separate D function placed immediately
 *     before the test that uses it;
 *   - functionality whose D binding is missing is emitted as commented-out code
 *     with a `// BINDING GAP:` note.
 *
 * BINDING GAP: `QDebug operator<<(QDebug, QTime)` (declared in qdatetime.h) is
 * not exposed by the D bindings - `QDebug` is only forward-declared - so QTime
 * cannot be streamed for debugging. The source's qtime autotest has no
 * dedicated case for it; the equivalent check would look like:
 *
 *     unittest
 *     {
 *         // QTest::ignoreMessage(QtDebugMsg, "QTime(\"12:34:56.789\")");
 *         qDebug() << QTime(12, 34, 56, 789);
 *     }
 *
 * `QTime()` is bound: default construction is enabled (the binding leaves
 * `@disable this();` commented out) and the field initialiser `mds = NullTime`
 * reproduces Qt's inline/constexpr `QTime()` (the null time), so `QTime()` /
 * `QTime.init` are valid.
 *
 * BINDING GAP: `qHash(QTime)` is not bound, so the qHash check in
 * `operator_eq_eq` is recorded commented out.
 */

// An invalid time is expressed as `QTime(-1, -1, -1)` (null time) 
// `QTime.init`, mirroring the C++ `invalidTime()` / `QTime()`.
private QTime invalidTime()
{
    auto time = QTime(-1, -1, -1);
    assert(time == QTime.init, "invalidTime: QTime(-1, -1, -1) should equal QTime.init");
    return time;
}

private enum int INT_MAX = int.max;

// ---------------------------------------------------------------------------
// addSecs
// ---------------------------------------------------------------------------

private struct AddSecsRow
{
    QTime t1;
    int i;
    QTime exp;
}
private AddSecsRow[] addSecs_data()
{
    return [
        // Data0
        AddSecsRow(QTime(0, 0, 0), 200, QTime(0, 3, 20)),
        // Data1
        AddSecsRow(QTime(0, 0, 0), 20, QTime(0, 0, 20)),
        // overflow
        AddSecsRow(QTime(0, 0, 0), (INT_MAX / 1000 + 1),
                QTime.fromMSecsSinceStartOfDay(((INT_MAX / 1000 + 1) % 86_400) * 1000)),
    ];
}

// addSecs
unittest
{
    foreach (i, ref r; addSecs_data())
    {
        QTime t2 = r.t1.addSecs(r.i);
        assert(t2 == r.exp, "addSecs row " ~ i.to!string);
    }
}

// ---------------------------------------------------------------------------
// addMSecs
// ---------------------------------------------------------------------------

private struct AddMSecsRow
{
    QTime t1;
    int i;
    QTime exp;
}
private AddMSecsRow[] addMSecs_data()
{
    return [
        // positive values
        // Data1_0
        AddMSecsRow(QTime(0, 0, 0, 0), 2000, QTime(0, 0, 2, 0)),
        // Data1_1
        AddMSecsRow(QTime(0, 0, 0, 0), 200, QTime(0, 0, 0, 200)),
        // Data1_2
        AddMSecsRow(QTime(0, 0, 0, 0), 20, QTime(0, 0, 0, 20)),
        // Data1_3
        AddMSecsRow(QTime(0, 0, 0, 1), 1, QTime(0, 0, 0, 2)),
        // Data1_4
        AddMSecsRow(QTime(0, 0, 0, 0), 0, QTime(0, 0, 0, 0)),

        // Data2_0
        AddMSecsRow(QTime(0, 0, 0, 98), 0, QTime(0, 0, 0, 98)),
        // Data2_1
        AddMSecsRow(QTime(0, 0, 0, 98), 1, QTime(0, 0, 0, 99)),
        // Data2_2
        AddMSecsRow(QTime(0, 0, 0, 98), 2, QTime(0, 0, 0, 100)),
        // Data2_3
        AddMSecsRow(QTime(0, 0, 0, 98), 3, QTime(0, 0, 0, 101)),

        // Data3_0
        AddMSecsRow(QTime(0, 0, 0, 998), 0, QTime(0, 0, 0, 998)),
        // Data3_1
        AddMSecsRow(QTime(0, 0, 0, 998), 1, QTime(0, 0, 0, 999)),
        // Data3_2
        AddMSecsRow(QTime(0, 0, 0, 998), 2, QTime(0, 0, 1, 0)),
        // Data3_3
        AddMSecsRow(QTime(0, 0, 0, 998), 3, QTime(0, 0, 1, 1)),

        // Data4_0
        AddMSecsRow(QTime(0, 0, 1, 995), 4, QTime(0, 0, 1, 999)),
        // Data4_1
        AddMSecsRow(QTime(0, 0, 1, 995), 5, QTime(0, 0, 2, 0)),
        // Data4_2
        AddMSecsRow(QTime(0, 0, 1, 995), 6, QTime(0, 0, 2, 1)),
        // Data4_3
        AddMSecsRow(QTime(0, 0, 1, 995), 100, QTime(0, 0, 2, 95)),
        // Data4_4
        AddMSecsRow(QTime(0, 0, 1, 995), 105, QTime(0, 0, 2, 100)),

        // Data5_0
        AddMSecsRow(QTime(0, 0, 59, 995), 4, QTime(0, 0, 59, 999)),
        // Data5_1
        AddMSecsRow(QTime(0, 0, 59, 995), 5, QTime(0, 1, 0, 0)),
        // Data5_2
        AddMSecsRow(QTime(0, 0, 59, 995), 6, QTime(0, 1, 0, 1)),
        // Data5_3
        AddMSecsRow(QTime(0, 0, 59, 995), 1006, QTime(0, 1, 1, 1)),

        // Data6_0
        AddMSecsRow(QTime(0, 59, 59, 995), 4, QTime(0, 59, 59, 999)),
        // Data6_1
        AddMSecsRow(QTime(0, 59, 59, 995), 5, QTime(1, 0, 0, 0)),
        // Data6_2
        AddMSecsRow(QTime(0, 59, 59, 995), 6, QTime(1, 0, 0, 1)),
        // Data6_3
        AddMSecsRow(QTime(0, 59, 59, 995), 106, QTime(1, 0, 0, 101)),
        // Data6_4
        AddMSecsRow(QTime(0, 59, 59, 995), 1004, QTime(1, 0, 0, 999)),
        // Data6_5
        AddMSecsRow(QTime(0, 59, 59, 995), 1005, QTime(1, 0, 1, 0)),
        // Data6_6
        AddMSecsRow(QTime(0, 59, 59, 995), 61_006, QTime(1, 1, 1, 1)),

        // Data7_0
        AddMSecsRow(QTime(23, 59, 59, 995), 0, QTime(23, 59, 59, 995)),
        // Data7_1
        AddMSecsRow(QTime(23, 59, 59, 995), 4, QTime(23, 59, 59, 999)),
        // Data7_2
        AddMSecsRow(QTime(23, 59, 59, 995), 5, QTime(0, 0, 0, 0)),
        // Data7_3
        AddMSecsRow(QTime(23, 59, 59, 995), 6, QTime(0, 0, 0, 1)),
        // Data7_4
        AddMSecsRow(QTime(23, 59, 59, 995), 7, QTime(0, 0, 0, 2)),

        // negative values
        // Data11_0
        AddMSecsRow(QTime(0, 0, 2, 0), -2000, QTime(0, 0, 0, 0)),
        // Data11_1
        AddMSecsRow(QTime(0, 0, 0, 200), -200, QTime(0, 0, 0, 0)),
        // Data11_2
        AddMSecsRow(QTime(0, 0, 0, 20), -20, QTime(0, 0, 0, 0)),
        // Data11_3
        AddMSecsRow(QTime(0, 0, 0, 2), -1, QTime(0, 0, 0, 1)),
        // Data11_4
        AddMSecsRow(QTime(0, 0, 0, 0), 0, QTime(0, 0, 0, 0)),

        // Data12_0
        AddMSecsRow(QTime(0, 0, 0, 98), 0, QTime(0, 0, 0, 98)),
        // Data12_1
        AddMSecsRow(QTime(0, 0, 0, 99), -1, QTime(0, 0, 0, 98)),
        // Data12_2
        AddMSecsRow(QTime(0, 0, 0, 100), -2, QTime(0, 0, 0, 98)),
        // Data12_3
        AddMSecsRow(QTime(0, 0, 0, 101), -3, QTime(0, 0, 0, 98)),

        // Data13_0
        AddMSecsRow(QTime(0, 0, 0, 998), 0, QTime(0, 0, 0, 998)),
        // Data13_1
        AddMSecsRow(QTime(0, 0, 0, 999), -1, QTime(0, 0, 0, 998)),
        // Data13_2
        AddMSecsRow(QTime(0, 0, 1, 0), -2, QTime(0, 0, 0, 998)),
        // Data13_3
        AddMSecsRow(QTime(0, 0, 1, 1), -3, QTime(0, 0, 0, 998)),

        // Data14_0
        AddMSecsRow(QTime(0, 0, 1, 999), -4, QTime(0, 0, 1, 995)),
        // Data14_1
        AddMSecsRow(QTime(0, 0, 2, 0), -5, QTime(0, 0, 1, 995)),
        // Data14_2
        AddMSecsRow(QTime(0, 0, 2, 1), -6, QTime(0, 0, 1, 995)),
        // Data14_3
        AddMSecsRow(QTime(0, 0, 2, 95), -100, QTime(0, 0, 1, 995)),
        // Data14_4
        AddMSecsRow(QTime(0, 0, 2, 100), -105, QTime(0, 0, 1, 995)),

        // Data15_0
        AddMSecsRow(QTime(0, 0, 59, 999), -4, QTime(0, 0, 59, 995)),
        // Data15_1
        AddMSecsRow(QTime(0, 1, 0, 0), -5, QTime(0, 0, 59, 995)),
        // Data15_2
        AddMSecsRow(QTime(0, 1, 0, 1), -6, QTime(0, 0, 59, 995)),
        // Data15_3
        AddMSecsRow(QTime(0, 1, 1, 1), -1006, QTime(0, 0, 59, 995)),

        // Data16_0
        AddMSecsRow(QTime(0, 59, 59, 999), -4, QTime(0, 59, 59, 995)),
        // Data16_1
        AddMSecsRow(QTime(1, 0, 0, 0), -5, QTime(0, 59, 59, 995)),
        // Data16_2
        AddMSecsRow(QTime(1, 0, 0, 1), -6, QTime(0, 59, 59, 995)),
        // Data16_3
        AddMSecsRow(QTime(1, 0, 0, 101), -106, QTime(0, 59, 59, 995)),
        // Data16_4
        AddMSecsRow(QTime(1, 0, 0, 999), -1004, QTime(0, 59, 59, 995)),
        // Data16_5
        AddMSecsRow(QTime(1, 0, 1, 0), -1005, QTime(0, 59, 59, 995)),
        // Data16_6
        AddMSecsRow(QTime(1, 1, 1, 1), -61_006, QTime(0, 59, 59, 995)),

        // Data17_0
        AddMSecsRow(QTime(23, 59, 59, 995), 0, QTime(23, 59, 59, 995)),
        // Data17_1
        AddMSecsRow(QTime(23, 59, 59, 999), -4, QTime(23, 59, 59, 995)),
        // Data17_2
        AddMSecsRow(QTime(0, 0, 0, 0), -5, QTime(23, 59, 59, 995)),
        // Data17_3
        AddMSecsRow(QTime(0, 0, 0, 1), -6, QTime(23, 59, 59, 995)),
        // Data17_4
        AddMSecsRow(QTime(0, 0, 0, 2), -7, QTime(23, 59, 59, 995)),

        // Data18
        AddMSecsRow(invalidTime(), 1, invalidTime()),
    ];
}

// addMSecs
unittest
{
    foreach (i, ref r; addMSecs_data())
    {
        QTime t2 = r.t1.addMSecs(r.i);
        assert(t2 == r.exp, "addMSecs row " ~ i.to!string);
    }
}

// ---------------------------------------------------------------------------
// isNull / isValid
// ---------------------------------------------------------------------------

// isNull
unittest
{
    const string ctx = "isNull";
    QTime t1 = QTime.init;
    assert(t1.isNull(), ctx);
    QTime t2 = QTime(0, 0, 0);
    assert(!t2.isNull(), ctx);
    QTime t3 = QTime(0, 0, 1);
    assert(!t3.isNull(), ctx);
    QTime t4 = QTime(0, 0, 0, 1);
    assert(!t4.isNull(), ctx);
    QTime t5 = QTime(23, 59, 59);
    assert(!t5.isNull(), ctx);
}

// isValid
unittest
{
    const string ctx = "isValid";
    QTime t1 = QTime.init;
    assert(!t1.isValid(), ctx);
    QTime t2 = QTime(24, 0, 0, 0);
    assert(!t2.isValid(), ctx);
    QTime t3 = QTime(23, 60, 0, 0);
    assert(!t3.isValid(), ctx);
    QTime t4 = QTime(23, 0, -1, 0);
    assert(!t4.isValid(), ctx);
    QTime t5 = QTime(23, 0, 60, 0);
    assert(!t5.isValid(), ctx);
    QTime t6 = QTime(23, 0, 0, 1000);
    assert(!t6.isValid(), ctx);
}

// ---------------------------------------------------------------------------
// hour
// ---------------------------------------------------------------------------

private struct HourRow
{
    int hour, minute, sec, msec;
}
private HourRow[] hour_data()
{
    return [
        // data0
        HourRow(0, 0, 0, 0),
        // data1
        HourRow(0, 0, 0, 1),
        // data2
        HourRow(1, 2, 3, 4),
        // data3
        HourRow(2, 12, 13, 65),
        // data4
        HourRow(23, 59, 59, 999),
        // data5
        HourRow(-1, -1, -1, -1),
    ];
}

// hour
unittest
{
    foreach (i, ref r; hour_data())
    {
        QTime t1 = QTime(r.hour, r.minute, r.sec, r.msec);
        string ctx = "hour row " ~ i.to!string;
        assert(t1.hour() == r.hour, ctx);
        assert(t1.minute() == r.minute, ctx);
        assert(t1.second() == r.sec, ctx);
        assert(t1.msec() == r.msec, ctx);
    }
}

// ---------------------------------------------------------------------------
// setHMS
// ---------------------------------------------------------------------------

private struct SetHMSRow
{
    int hour, minute, sec;
}
private SetHMSRow[] setHMS_data()
{
    return [
        // data0
        SetHMSRow(0, 0, 0),
        // data1
        SetHMSRow(1, 2, 3),
        // data2
        SetHMSRow(0, 59, 0),
        // data3
        SetHMSRow(0, 59, 59),
        // data4
        SetHMSRow(23, 0, 0),
        // data5
        SetHMSRow(23, 59, 0),
        // data6
        SetHMSRow(23, 59, 59),
        // data7
        SetHMSRow(-1, -1, -1),
    ];
}

// setHMS
unittest
{
    foreach (i, ref r; setHMS_data())
    {
        QTime t = QTime(3, 4, 5);
        t.setHMS(r.hour, r.minute, r.sec);
        string ctx = "setHMS row " ~ i.to!string;
        assert(t.hour() == r.hour, ctx);
        assert(t.minute() == r.minute, ctx);
        assert(t.second() == r.sec, ctx);
    }
}

// ---------------------------------------------------------------------------
// secsTo / msecsTo
// ---------------------------------------------------------------------------

private struct TimePairRow
{
    QTime t1, t2;
    int delta;
}
private TimePairRow[] secsTo_data()
{
    return [
        // data0
        TimePairRow(QTime(0, 0, 0), QTime(0, 0, 59), 59),
        // data1
        TimePairRow(QTime(0, 0, 0), QTime(0, 1, 0), 60),
        // data2
        TimePairRow(QTime(0, 0, 0), QTime(0, 10, 0), 600),
        // data3
        TimePairRow(QTime(0, 0, 0), QTime(23, 59, 59), 86_399),
        // data4
        TimePairRow(QTime(-1, -1, -1), QTime(0, 0, 0), 0),
        // data5
        TimePairRow(QTime(0, 0, 0), QTime(-1, -1, -1), 0),
        // data6
        TimePairRow(QTime(-1, -1, -1), QTime(-1, -1, -1), 0),
        // disregard msec (1s)
        TimePairRow(QTime(12, 30, 1, 500), QTime(12, 30, 2, 400), 1),
        // disregard msec (0s)
        TimePairRow(QTime(12, 30, 1, 500), QTime(12, 30, 1, 900), 0),
        // disregard msec (-1s)
        TimePairRow(QTime(12, 30, 2, 400), QTime(12, 30, 1, 500), -1),
        // disregard msec (0s)
        TimePairRow(QTime(12, 30, 1, 900), QTime(12, 30, 1, 500), 0),
    ];
}

// secsTo
unittest
{
    foreach (i, ref r; secsTo_data())
        assert(r.t1.secsTo(r.t2) == r.delta, "secsTo row " ~ i.to!string);
}

private TimePairRow[] msecsTo_data()
{
    return [
        // data0
        TimePairRow(QTime(0, 0, 0, 0), QTime(0, 0, 0, 0), 0),
        // data1
        TimePairRow(QTime(0, 0, 0, 0), QTime(0, 0, 1, 0), 1000),
        // data2
        TimePairRow(QTime(0, 0, 0, 0), QTime(0, 0, 10, 0), 10_000),
        // data3
        TimePairRow(QTime(0, 0, 0, 0), QTime(23, 59, 59, 0), 86_399_000),
        // data4
        TimePairRow(QTime(-1, -1, -1, -1), QTime(0, 0, 0, 0), 0),
        // data5
        TimePairRow(QTime(0, 0, 0, 0), QTime(-1, -1, -1, -1), 0),
        // data6
        TimePairRow(QTime(-1, -1, -1, -1), QTime(-1, -1, -1, -1), 0),
    ];
}

// msecsTo
unittest
{
    foreach (i, ref r; msecsTo_data())
        assert(r.t1.msecsTo(r.t2) == r.delta, "msecsTo row " ~ i.to!string);
}

// ---------------------------------------------------------------------------
// operator_eq_eq
// ---------------------------------------------------------------------------

private struct EqRow
{
    QTime t1, t2;
    bool equal;
}
private EqRow[] operator_eq_eq_data()
{
    QTime time1 = QTime(0, 0, 0, 0);
    QTime time2 = time1.addMSecs(1);
    QTime time3 = time1.addMSecs(-1);
    QTime time4 = QTime(23, 59, 59, 999);

    return [
        // data0
        EqRow(time1, time2, false),
        // data1
        EqRow(time2, time3, false),
        // data2
        EqRow(time4, time1, false),
        // data3
        EqRow(time1, time1, true),
        // data4
        EqRow(QTime(12, 34, 56, 20), QTime(12, 34, 56, 20), true),
        // data5
        EqRow(QTime(1, 34, 56, 20), QTime(13, 34, 56, 20), false),
    ];
}

// operator_eq_eq (QTime == / !=)
unittest
{
    foreach (i, ref r; operator_eq_eq_data())
    {
        string ctx = "operator_eq_eq row " ~ i.to!string;
        bool equal = r.t1 == r.t2;
        assert(equal == r.equal, ctx);
        bool notEqual = r.t1 != r.t2;
        assert(notEqual == !r.equal, ctx);
        // BINDING GAP: qHash(QTime) is not bound, so the qHash check is recorded
        // commented out.
        //
        // if (equal)
        //     assert(qHash(r.t1) == qHash(r.t2), ctx);
    }
}

// operator_lt
unittest
{
    const string ctx = "operator_lt";
    QTime t1 = QTime(0, 0, 0, 0);
    QTime t2 = QTime(0, 0, 0, 0);
    assert(!(t1 < t2), ctx);
    t1 = QTime(12, 34, 56, 20); t2 = QTime(12, 34, 56, 30); assert(t1 < t2, ctx);
    t1 = QTime(13, 34, 46, 20); t2 = QTime(13, 34, 56, 20); assert(t1 < t2, ctx);
    t1 = QTime(13, 24, 56, 20); t2 = QTime(13, 34, 56, 20); assert(t1 < t2, ctx);
    t1 = QTime(12, 34, 56, 20); t2 = QTime(13, 34, 56, 20); assert(t1 < t2, ctx);
    t1 = QTime(14, 34, 56, 20); t2 = QTime(13, 34, 56, 20); assert(!(t1 < t2), ctx);
    t1 = QTime(13, 44, 56, 20); t2 = QTime(13, 34, 56, 20); assert(!(t1 < t2), ctx);
    t1 = QTime(13, 34, 56, 20); t2 = QTime(13, 34, 46, 20); assert(!(t1 < t2), ctx);
    t1 = QTime(13, 44, 56, 30); t2 = QTime(13, 44, 56, 20); assert(!(t1 < t2), ctx);
}

// operator_gt
unittest
{
    const string ctx = "operator_gt";
    QTime t1 = QTime(0, 0, 0, 0);
    QTime t2 = QTime(0, 0, 0, 0);
    assert(!(t1 > t2), ctx);
    t1 = QTime(12, 34, 56, 20); t2 = QTime(12, 34, 56, 30); assert(!(t1 > t2), ctx);
    t1 = QTime(13, 34, 46, 20); t2 = QTime(13, 34, 56, 20); assert(!(t1 > t2), ctx);
    t1 = QTime(13, 24, 56, 20); t2 = QTime(13, 34, 56, 20); assert(!(t1 > t2), ctx);
    t1 = QTime(12, 34, 56, 20); t2 = QTime(13, 34, 56, 20); assert(!(t1 > t2), ctx);
    t1 = QTime(14, 34, 56, 20); t2 = QTime(13, 34, 56, 20); assert(t1 > t2, ctx);
    t1 = QTime(13, 44, 56, 20); t2 = QTime(13, 34, 56, 20); assert(t1 > t2, ctx);
    t1 = QTime(13, 34, 56, 20); t2 = QTime(13, 34, 46, 20); assert(t1 > t2, ctx);
    t1 = QTime(13, 44, 56, 30); t2 = QTime(13, 44, 56, 20); assert(t1 > t2, ctx);
}

// operator_lt_eq
unittest
{
    const string ctx = "operator_lt_eq";
    QTime t1 = QTime(0, 0, 0, 0);
    QTime t2 = QTime(0, 0, 0, 0);
    assert(t1 <= t2, ctx);
    t1 = QTime(12, 34, 56, 20); t2 = QTime(12, 34, 56, 30); assert(t1 <= t2, ctx);
    t1 = QTime(13, 34, 46, 20); t2 = QTime(13, 34, 56, 20); assert(t1 <= t2, ctx);
    t1 = QTime(13, 24, 56, 20); t2 = QTime(13, 34, 56, 20); assert(t1 <= t2, ctx);
    t1 = QTime(12, 34, 56, 20); t2 = QTime(13, 34, 56, 20); assert(t1 <= t2, ctx);
    t1 = QTime(14, 34, 56, 20); t2 = QTime(13, 34, 56, 20); assert(!(t1 <= t2), ctx);
    t1 = QTime(13, 44, 56, 20); t2 = QTime(13, 34, 56, 20); assert(!(t1 <= t2), ctx);
    t1 = QTime(13, 34, 56, 20); t2 = QTime(13, 34, 46, 20); assert(!(t1 <= t2), ctx);
    t1 = QTime(13, 44, 56, 30); t2 = QTime(13, 44, 56, 20); assert(!(t1 <= t2), ctx);
}

// operator_gt_eq
unittest
{
    const string ctx = "operator_gt_eq";
    QTime t1 = QTime(0, 0, 0, 0);
    QTime t2 = QTime(0, 0, 0, 0);
    assert(t1 >= t2, ctx);
    t1 = QTime(12, 34, 56, 20); t2 = QTime(12, 34, 56, 30); assert(!(t1 >= t2), ctx);
    t1 = QTime(13, 34, 46, 20); t2 = QTime(13, 34, 56, 20); assert(!(t1 >= t2), ctx);
    t1 = QTime(13, 24, 56, 20); t2 = QTime(13, 34, 56, 20); assert(!(t1 >= t2), ctx);
    t1 = QTime(12, 34, 56, 20); t2 = QTime(13, 34, 56, 20); assert(!(t1 >= t2), ctx);
    t1 = QTime(14, 34, 56, 20); t2 = QTime(13, 34, 56, 20); assert(t1 >= t2, ctx);
    t1 = QTime(13, 44, 56, 20); t2 = QTime(13, 34, 56, 20); assert(t1 >= t2, ctx);
    t1 = QTime(13, 34, 56, 20); t2 = QTime(13, 34, 46, 20); assert(t1 >= t2, ctx);
    t1 = QTime(13, 44, 56, 30); t2 = QTime(13, 44, 56, 20); assert(t1 >= t2, ctx);
}


// ---------------------------------------------------------------------------
// fromString with an explicit format
// ---------------------------------------------------------------------------

/+ #if QT_CONFIG(datestring) +/
/+ # if QT_CONFIG(datetimeparser) +/
private struct FromFormatRow
{
    string s, format;
    QTime expected;
}
private FromFormatRow[] fromStringFormat_data()
{
    return [
        // data0
        FromFormatRow("1010", "mmm", QTime(0, 10, 0)),
        // data1
        FromFormatRow("00", "hm", invalidTime()),
        // data2
        FromFormatRow("10am", "hap", QTime(10, 0, 0)),
        // data3
        FromFormatRow("10pm", "hap", QTime(22, 0, 0)),
        // data4
        FromFormatRow("10pmam", "hapap", invalidTime()),
        // data5
        FromFormatRow("1070", "hhm", invalidTime()),
        // data6
        FromFormatRow("1011", "hh", invalidTime()),
        // data7
        FromFormatRow("25", "hh", invalidTime()),
        // data8
        FromFormatRow("22pm", "Hap", QTime(22, 0, 0)),
        // data9
        FromFormatRow("2221", "hhhh", invalidTime()),
        // Parsing of am/pm indicators is case-insensitive
        // pm-upper
        FromFormatRow("02:23PM", "hh:mmAp", QTime(14, 23)),
        // pm-lower
        FromFormatRow("02:23pm", "hh:mmaP", QTime(14, 23)),
        // pm-as-upper
        FromFormatRow("02:23Pm", "hh:mmAP", QTime(14, 23)),
        // pm-as-lower
        FromFormatRow("02:23pM", "hh:mmap", QTime(14, 23)),
        // Millisecond parsing interpolates 0s at the end and notices them at the start.
        // short-msecs-lt100
        FromFormatRow("10:12:34:045", "hh:m:ss:z", QTime(10, 12, 34, 45)),
        // short-msecs-gt100
        FromFormatRow("10:12:34:45", "hh:m:ss:z", QTime(10, 12, 34, 450)),
        // late
        FromFormatRow("23:59:59.999", "hh:mm:ss.z", QTime(23, 59, 59, 999)),
        // unicode handling
        // emoji in format string 1
        FromFormatRow(
            "12\U0001F44D31:25.05",
            "hh\U0001F44Dmm:ss.z",
            QTime(12, 31, 25, 50)
        ),
        // emoji in format string 2
        FromFormatRow(
            "\U0001F49612\U0001F44D31\U0001F30825\U0001F63A05\U0001F680",
            "\U0001F496hh\U0001F44Dmm\U0001F308ss\U0001F63Az\U0001F680", 
            QTime(12, 31, 25, 50)
        ),
    ];
}

// fromStringFormat
unittest
{
    foreach (i, ref r; fromStringFormat_data())
    {
        QString s = QString(r.s);
        QString fmt = QString(r.format);
        QTime got = QTime.fromString(s, fmt);
        assert(got == r.expected, "fromStringFormat row " ~ i.to!string);
    }
}
/+ #endif +/

// ---------------------------------------------------------------------------
// fromString with a DateFormat
// ---------------------------------------------------------------------------

private struct FromDateRow
{
    string s;
    DateFormat fmt;
    QTime expected;
}
private FromDateRow[] fromStringDateFormat_data()
{
    return [
        // TextDate - zero
        FromDateRow("00:00:00", DateFormat.TextDate, QTime(0, 0)),
        // TextDate - ordinary
        FromDateRow("10:12:34", DateFormat.TextDate, QTime(10, 12, 34)),
        // TextDate - milli-max
        FromDateRow("19:03:54.998601", DateFormat.TextDate, QTime(19, 3, 54, 999)),
        // TextDate - milli-wrap
        FromDateRow("19:03:54.999601", DateFormat.TextDate, QTime(19, 3, 55)),
        // TextDate - no-secs
        FromDateRow("10:12", DateFormat.TextDate, QTime(10, 12)),
        // TextDate - midnight-nowrap
        FromDateRow("23:59:59.9999", DateFormat.TextDate, QTime(23, 59, 59, 999)),
        // TextDate - invalid, minutes
        FromDateRow("23:XX:00", DateFormat.TextDate, invalidTime()),
        // TextDate - invalid, minute fraction
        FromDateRow("23:00.123456", DateFormat.TextDate, invalidTime()),
        // TextDate - invalid, seconds
        FromDateRow("23:00:XX", DateFormat.TextDate, invalidTime()),
        // TextDate - invalid, milliseconds
        FromDateRow("23:01:01:XXXX", DateFormat.TextDate, invalidTime()),
        // TextDate - midnight 24
        FromDateRow("24:00:00", DateFormat.TextDate, QTime.init),

        // IsoDate - valid, start of day, omit seconds
        FromDateRow("00:00", DateFormat.ISODate, QTime(0, 0, 0)),
        // IsoDate - valid, omit seconds
        FromDateRow("22:21", DateFormat.ISODate, QTime(22, 21, 0)),
        // IsoDate - minute fraction
        FromDateRow("22:21.816666", DateFormat.ISODate, QTime(22, 21, 49)),
        // IsoDate - valid, omit seconds (2)
        FromDateRow("23:59", DateFormat.ISODate, QTime(23, 59, 0)),
        // IsoDate - valid, end of day
        FromDateRow("23:59:59", DateFormat.ISODate, QTime(23, 59, 59)),
        // IsoDate - invalid, empty string
        FromDateRow("", DateFormat.ISODate, invalidTime()),
        // IsoDate - invalid, too many hours
        FromDateRow("25:00", DateFormat.ISODate, invalidTime()),
        // IsoDate - invalid, too many minutes
        FromDateRow("10:70", DateFormat.ISODate, invalidTime()),
        // This is a valid time if it happens on June 30 or December 31 (leap seconds).
        // IsoDate - invalid, too many seconds
        FromDateRow("23:59:60", DateFormat.ISODate, invalidTime()),
        // IsoDate - invalid, minutes
        FromDateRow("23:XX:00", DateFormat.ISODate, invalidTime()),
        // IsoDate - invalid, not enough minutes
        FromDateRow("23:0", DateFormat.ISODate, invalidTime()),
        // IsoDate - invalid, minute fraction
        FromDateRow("23:00,XX", DateFormat.ISODate, invalidTime()),
        // IsoDate - invalid, seconds
        FromDateRow("23:00:XX", DateFormat.ISODate, invalidTime()),
        // IsoDate - invalid, milliseconds
        FromDateRow("23:01:01:XXXX", DateFormat.ISODate, invalidTime()),
        // IsoDate - zero
        FromDateRow("00:00:00", DateFormat.ISODate, QTime(0, 0)),
        // IsoDate - ordinary
        FromDateRow("10:12:34", DateFormat.ISODate, QTime(10, 12, 34)),
        // IsoDate - milli-max
        FromDateRow("19:03:54.998601", DateFormat.ISODate, QTime(19, 3, 54, 999)),
        // IsoDate - milli-wrap
        FromDateRow("19:03:54.999601", DateFormat.ISODate, QTime(19, 3, 55)),
        // IsoDate - midnight-nowrap
        FromDateRow("23:59:59.9999", DateFormat.ISODate, QTime(23, 59, 59, 999)),
        // IsoDate - midnight 24
        FromDateRow("24:00:00", DateFormat.ISODate, QTime(0, 0)),
        // IsoDate - minute fraction midnight
        FromDateRow("24:00,0", DateFormat.ISODate, QTime(0, 0)),
        // Test DateFormat.RFC2822Date format (RFC 2822).
        // RFC 2822
        FromDateRow("13 Feb 1987 13:24:51 +0100", DateFormat.RFC2822Date, QTime(13, 24, 51)),
        // RFC 2822 after space
        FromDateRow(" 13 Feb 1987 13:24:51 +0100", DateFormat.RFC2822Date, QTime(13, 24, 51)),
        // RFC 2822 with day
        FromDateRow("Thu, 01 Jan 1970 00:12:34 +0000", DateFormat.RFC2822Date, QTime(0, 12, 34)),
        // RFC 2822 with day after space
        FromDateRow(" Thu, 01 Jan 1970 00:12:34 +0000", DateFormat.RFC2822Date, QTime(0, 12, 34)),
        // No timezone
        // RFC 2822 no timezone
        FromDateRow("01 Jan 1970 00:12:34", DateFormat.RFC2822Date, QTime(0, 12, 34)),
        // No time specified
        // RFC 2822 date only
        FromDateRow("01 Nov 2002", DateFormat.RFC2822Date, invalidTime()),
        // RFC 2822 with day date only
        FromDateRow("Fri, 01 Nov 2002", DateFormat.RFC2822Date, invalidTime()),
        // RFC 2822 malformed time
        FromDateRow("01 Nov 2002 0:", DateFormat.RFC2822Date, QTime.init),
        // Test invalid month, day, year are ignored:
        // RFC 2822 invalid month name
        FromDateRow("13 Fev 1987 13:24:51 +0100", DateFormat.RFC2822Date, QTime(13, 24, 51)),
        // RFC 2822 invalid day
        FromDateRow("36 Feb 1987 13:24:51 +0100", DateFormat.RFC2822Date, QTime(13, 24, 51)),
        // RFC 2822 invalid day name
        FromDateRow("Mud, 23 Feb 1987 13:24:51 +0100", DateFormat.RFC2822Date, QTime(13, 24, 51)),
        // RFC 2822 invalid year
        FromDateRow("13 Feb 0000 13:24:51 +0100", DateFormat.RFC2822Date, QTime(13, 24, 51)),
        // Test invalid characters:
        // RFC 2822 invalid character at end
        FromDateRow("01 Jan 2012 08:00:00 +0100!", DateFormat.RFC2822Date, invalidTime()),
        // RFC 2822 invalid character at front
        FromDateRow("!01 Jan 2012 08:00:00 +0100", DateFormat.RFC2822Date, invalidTime()),
        // RFC 2822 invalid character both ends
        FromDateRow("!01 Jan 2012 08:00:00 +0100!", DateFormat.RFC2822Date, invalidTime()),
        // RFC 2822 invalid character at front, 2 at back
        FromDateRow("!01 Jan 2012 08:00:00 +0100..", DateFormat.RFC2822Date, invalidTime()),
        // RFC 2822 invalid character 2 at front
        FromDateRow("!!01 Jan 2012 08:00:00 +0100", DateFormat.RFC2822Date, invalidTime()),
        // The common date text used by the "invalid character" tests, just to be
        // sure *it's* not what's invalid:
        // RFC 2822 (not invalid)
        FromDateRow("01 Jan 2012 08:00:00 +0100", DateFormat.RFC2822Date, QTime(8, 0, 0)),
        // Test DateFormat.RFC2822Date format (RFC 850 and 1036, permissive).
        // RFC 850 and 1036
        FromDateRow("Fri Feb 13 13:24:51 1987 +0100", DateFormat.RFC2822Date, QTime(13, 24, 51)),
        // RFC 850 and 1036 after space
        FromDateRow(" Fri Feb 13 13:24:51 1987 +0100", DateFormat.RFC2822Date, QTime(13, 24, 51)),
        // No timezone
        // RFC 850 and 1036 no timezone
        FromDateRow("Thu Jan 01 00:12:34 1970", DateFormat.RFC2822Date, QTime(0, 12, 34)),
        // No time specified
        // RFC 850 and 1036 date only
        FromDateRow("Fri Nov 01 2002", DateFormat.RFC2822Date, invalidTime()),
        // Test invalid characters.
        // RFC 850 and 1036 invalid character at end
        FromDateRow("Sun Jan 01 08:00:00 2012 +0100!", DateFormat.RFC2822Date, invalidTime()),
        // RFC 850 and 1036 invalid character at front
        FromDateRow("!Sun Jan 01 08:00:00 2012 +0100", DateFormat.RFC2822Date, invalidTime()),
        // RFC 850 and 1036 invalid character both ends
        FromDateRow("!Sun Jan 01 08:00:00 2012 +0100!", DateFormat.RFC2822Date, invalidTime()),
        // RFC 850 and 1036 invalid character at front, 2 at back
        FromDateRow("!Sun Jan 01 08:00:00 2012 +0100..", DateFormat.RFC2822Date, invalidTime()),
        // The common date text used by the "invalid character" tests, just to be
        // sure *it's* not what's invalid:
        // RFC 850 and 1036 invalid character at end
        FromDateRow("Sun Jan 01 08:00:00 2012 +0100", DateFormat.RFC2822Date, QTime(8, 0, 0)),
        // RFC empty
        FromDateRow("", DateFormat.RFC2822Date, invalidTime()),
    ];
}

// fromStringDateFormat
unittest
{
    foreach (i, ref r; fromStringDateFormat_data())
    {
        QTime got = QTime.fromString(QString(r.s), r.fmt);
        assert(got == r.expected, "fromStringDateFormat row " ~ i.to!string);
    }
}

// ---------------------------------------------------------------------------
// toString with a DateFormat
// ---------------------------------------------------------------------------

private struct ToDateRow
{
    QTime time;
    DateFormat fmt;
    string expected;
}
private ToDateRow[] toStringDateFormat_data()
{
    return [
        // 00:00:00.000
        ToDateRow(QTime(0, 0, 0, 0), DateFormat.TextDate, "00:00:00"),
        // ISO 00:00:00.000
        ToDateRow(QTime(0, 0, 0, 0), DateFormat.ISODate, "00:00:00"),
        // Text 10:12:34.000
        ToDateRow(QTime(10, 12, 34, 0), DateFormat.TextDate, "10:12:34"),
        // ISO 10:12:34.000
        ToDateRow(QTime(10, 12, 34, 0), DateFormat.ISODate, "10:12:34"),
        // Text 10:12:34.001
        ToDateRow(QTime(10, 12, 34, 1), DateFormat.TextDate, "10:12:34"),
        // ISO 10:12:34.001
        ToDateRow(QTime(10, 12, 34, 1), DateFormat.ISODate, "10:12:34"),
        // Text 10:12:34.999
        ToDateRow(QTime(10, 12, 34, 999), DateFormat.TextDate, "10:12:34"),
        // ISO 10:12:34.999
        ToDateRow(QTime(10, 12, 34, 999), DateFormat.ISODate, "10:12:34"),
        // RFC2822Date
        ToDateRow(QTime(10, 12, 34, 999), DateFormat.RFC2822Date, "10:12:34"),
        // ISOWithMs 10:12:34.000
        ToDateRow(QTime(10, 12, 34, 0), DateFormat.ISODateWithMs, "10:12:34.000"),
        // ISOWithMs 10:12:34.020
        ToDateRow(QTime(10, 12, 34, 20), DateFormat.ISODateWithMs, "10:12:34.020"),
        // ISOWithMs 10:12:34.999
        ToDateRow(QTime(10, 12, 34, 999), DateFormat.ISODateWithMs, "10:12:34.999"),
    ];
}

// toStringDateFormat
unittest
{
    foreach (i, ref r; toStringDateFormat_data())
        assert(r.time.toString(r.fmt) == r.expected, "toStringDateFormat row " ~ i.to!string);
}

// ---------------------------------------------------------------------------
// toString with a format string
// ---------------------------------------------------------------------------

private struct ToFormatRow
{
    QTime t;
    string format, str;
}
private ToFormatRow[] toStringFormat_data()
{
    return [
        // midnight
        ToFormatRow(QTime(0, 0, 0, 0), "h:m:s:z", "0:0:0:0"),
        // full
        ToFormatRow(QTime(10, 12, 34, 53), "hh:mm:ss:zzz", "10:12:34:053"),
        // short-msecs-lt100
        ToFormatRow(QTime(10, 12, 34, 45), "hh:m:ss:z", "10:12:34:045"),
        // short-msecs-gt100
        ToFormatRow(QTime(10, 12, 34, 450), "hh:m:ss:z", "10:12:34:45"),
        // am-pm
        ToFormatRow(QTime(10, 12, 34, 45), "hh:ss ap", "10:34 am"),
        // AM-PM
        ToFormatRow(QTime(22, 12, 34, 45), "hh:zzz AP", "10:045 PM"),
        // invalid
        ToFormatRow(QTime(230, 230, 230, 230), "hh:mm:ss", ""),
        // empty format
        ToFormatRow(QTime(4, 5, 6, 6), "", ""),
    ];
}

// toStringFormat
unittest
{
    foreach (i, ref r; toStringFormat_data())
    {
        QString fmt = QString(r.format);
        assert(r.t.toString(fmt) == r.str, "toStringFormat row " ~ i.to!string);
    }
}
/+ #endif +/

// ---------------------------------------------------------------------------
// msecsSinceStartOfDay
// ---------------------------------------------------------------------------

private struct MsecsRow
{
    int msecs;
    bool valid;
    int h, m, s, ms;
}
private MsecsRow[] msecsSinceStartOfDay_data()
{
    return [
        // 00:00:00.000
        MsecsRow(0, true, 0, 0, 0, 0),
        // 01:00:00.001
        MsecsRow((1 * 3600 * 1000) + 1, true, 1, 0, 0, 1),
        // 03:04:05.678
        MsecsRow(((3 * 3600 + 4 * 60 + 5) * 1000 + 678), true, 3, 4, 5, 678),
        // 23:59:59.999
        MsecsRow(((23 * 3600 + 59 * 60 + 59) * 1000 + 999), true, 23, 59, 59, 999),
        // 24:00:00.000
        MsecsRow((24 * 3600) * 1000, false, -1, -1, -1, -1),
        // -1 invalid
        MsecsRow(-1, false, -1, -1, -1, -1),
    ];
}

// msecsSinceStartOfDay
unittest
{
    foreach (i, ref r; msecsSinceStartOfDay_data())
    {
        string ctx = "msecsSinceStartOfDay row " ~ i.to!string;
        QTime time = QTime.fromMSecsSinceStartOfDay(r.msecs);
        assert(time.isValid() == r.valid, ctx);
        if (r.msecs >= 0)
            assert(time.msecsSinceStartOfDay() == r.msecs, ctx);
        else
            assert(time.msecsSinceStartOfDay() == 0, ctx);
        assert(time.hour() == r.h, ctx);
        assert(time.minute() == r.m, ctx);
        assert(time.second() == r.s, ctx);
        assert(time.msec() == r.ms, ctx);
    }
}
