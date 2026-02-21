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
module qt.core.regularexpression;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.global;
import qt.core.namespace;
import qt.core.shareddata;
import qt.core.string;
import qt.core.stringlist;
import qt.core.stringview;
import qt.core.typeinfo;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(regularexpression); +/


struct QRegularExpressionPrivate;

/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QRegularExpressionPrivate, Q_CORE_EXPORT)
Q_CORE_EXPORT size_t qHash(const QRegularExpression &key, size_t seed = 0) noexcept; +/

/// Binding for C++ class [QRegularExpression](https://doc.qt.io/qt-6/qregularexpression.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QRegularExpression
{
public:
    enum PatternOption {
        NoPatternOption                = 0x0000,
        CaseInsensitiveOption          = 0x0001,
        DotMatchesEverythingOption     = 0x0002,
        MultilineOption                = 0x0004,
        ExtendedPatternSyntaxOption    = 0x0008,
        InvertedGreedinessOption       = 0x0010,
        DontCaptureOption              = 0x0020,
        UseUnicodePropertiesOption     = 0x0040,
        // Formerly (no-ops deprecated in 5.12, removed 6.0):
        // OptimizeOnFirstUsageOption = 0x0080,
        // DontAutomaticallyOptimizeOption = 0x0100,
    }
    /+ Q_DECLARE_FLAGS(PatternOptions, PatternOption) +/
alias PatternOptions = QFlags!(PatternOption);
    PatternOptions patternOptions() const;
    void setPatternOptions(PatternOptions options);

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ explicit +/this(ref const(QString) pattern, PatternOptions options = PatternOption.NoPatternOption);
    @disable this(this);
    this(ref const(QRegularExpression) re);
    /+ QRegularExpression(QRegularExpression &&re) = default; +/
    ~this();
    ref QRegularExpression opAssign(ref const(QRegularExpression) re);
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QRegularExpression) +/

    /+ void swap(QRegularExpression &other) noexcept { d.swap(other.d); } +/

    QString pattern() const;
    void setPattern(ref const(QString) pattern);

    /+ [[nodiscard]] +/
        bool isValid() const;
    qsizetype patternErrorOffset() const;
    QString errorString() const;

    int captureCount() const;
    QStringList namedCaptureGroups() const;

    enum MatchType {
        NormalMatch = 0,
        PartialPreferCompleteMatch,
        PartialPreferFirstMatch,
        NoMatch
    }

    enum MatchOption {
        NoMatchOption              = 0x0000,
        AnchorAtOffsetMatchOption  = 0x0001,
        AnchoredMatchOption /+ Q_DECL_ENUMERATOR_DEPRECATED_X(
            "Use AnchorAtOffsetMatchOption instead") +/ = MatchOption.AnchorAtOffsetMatchOption, // Rename@Qt6.0
        DontCheckSubjectStringMatchOption = 0x0002
    }
    /+ Q_DECLARE_FLAGS(MatchOptions, MatchOption) +/
alias MatchOptions = QFlags!(MatchOption);
    /+ [[nodiscard]] +/
        QRegularExpressionMatch match(ref const(QString) subject,
                                      qsizetype offset          = 0,
                                      MatchType matchType       = MatchType.NormalMatch,
                                      MatchOptions matchOptions = MatchOption.NoMatchOption) const;

    /+ [[nodiscard]] +/
        QRegularExpressionMatch match(QStringView subjectView,
                                      qsizetype offset          = 0,
                                      MatchType matchType       = MatchType.NormalMatch,
                                      MatchOptions matchOptions = MatchOption.NoMatchOption) const;

    /+ [[nodiscard]] +/
        QRegularExpressionMatchIterator globalMatch(ref const(QString) subject,
                                                    qsizetype offset          = 0,
                                                    MatchType matchType       = MatchType.NormalMatch,
                                                    MatchOptions matchOptions = MatchOption.NoMatchOption) const;

    /+ [[nodiscard]] +/
        QRegularExpressionMatchIterator globalMatch(QStringView subjectView,
                                                    qsizetype offset          = 0,
                                                    MatchType matchType       = MatchType.NormalMatch,
                                                    MatchOptions matchOptions = MatchOption.NoMatchOption) const;

    void optimize() const;

    enum WildcardConversionOption {
        DefaultWildcardConversion = 0x0,
        UnanchoredWildcardConversion = 0x1
    }
    /+ Q_DECLARE_FLAGS(WildcardConversionOptions, WildcardConversionOption) +/
alias WildcardConversionOptions = QFlags!(WildcardConversionOption);
    static QString escape(ref const(QString) str)
    {
        return escape(qToStringViewIgnoringNull(str));
    }

    static QString wildcardToRegularExpression(ref const(QString) str, WildcardConversionOptions options = WildcardConversionOption.DefaultWildcardConversion)
    {
        return wildcardToRegularExpression(qToStringViewIgnoringNull(str), options);
    }

    pragma(inline, true) static QString anchoredPattern(ref const(QString) expression)
    {
        return anchoredPattern(qToStringViewIgnoringNull(expression));
    }

    static QString escape(QStringView str);
    static QString wildcardToRegularExpression(QStringView str, WildcardConversionOptions options = WildcardConversionOption.DefaultWildcardConversion);
    static QString anchoredPattern(QStringView expression);

    static QRegularExpression fromWildcard(QStringView pattern, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseInsensitive,
                                               WildcardConversionOptions options = WildcardConversionOption.DefaultWildcardConversion);

    /+bool operator ==(ref const(QRegularExpression) re) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QRegularExpression) re) const { return !operator==(re); }+/

private:
    /+ friend struct QRegularExpressionPrivate; +/
    /+ friend class QRegularExpressionMatch; +/
    /+ friend struct QRegularExpressionMatchPrivate; +/
    /+ friend class QRegularExpressionMatchIterator; +/
    /+ friend Q_CORE_EXPORT size_t qHash(const QRegularExpression &key, size_t seed) noexcept; +/

    this(ref QRegularExpressionPrivate dd);
    QExplicitlySharedDataPointer!(QRegularExpressionPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QRegularExpression.PatternOptions.enum_type) operator |(QRegularExpression.PatternOptions.enum_type f1, QRegularExpression.PatternOptions.enum_type f2)nothrow{return QFlags!(QRegularExpression.PatternOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QRegularExpression.PatternOptions.enum_type) operator |(QRegularExpression.PatternOptions.enum_type f1, QFlags!(QRegularExpression.PatternOptions.enum_type) f2)nothrow{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QRegularExpression.PatternOptions.enum_type) operator &(QRegularExpression.PatternOptions.enum_type f1, QRegularExpression.PatternOptions.enum_type f2)nothrow{return QFlags!(QRegularExpression.PatternOptions.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QRegularExpression.PatternOptions.enum_type) operator &(QRegularExpression.PatternOptions.enum_type f1, QFlags!(QRegularExpression.PatternOptions.enum_type) f2)nothrow{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QRegularExpression.PatternOptions.enum_type) operator ^(QRegularExpression.PatternOptions.enum_type f1, QRegularExpression.PatternOptions.enum_type f2)nothrow{return QFlags!(QRegularExpression.PatternOptions.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QRegularExpression.PatternOptions.enum_type) operator ^(QRegularExpression.PatternOptions.enum_type f1, QFlags!(QRegularExpression.PatternOptions.enum_type) f2)nothrow{return f2^f1;}+/
/+pragma(inline, true) void operator +(QRegularExpression.PatternOptions.enum_type f1, QRegularExpression.PatternOptions.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QRegularExpression.PatternOptions.enum_type f1, QFlags!(QRegularExpression.PatternOptions.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QRegularExpression.PatternOptions.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(QRegularExpression.PatternOptions.enum_type f1, QRegularExpression.PatternOptions.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QRegularExpression.PatternOptions.enum_type f1, QFlags!(QRegularExpression.PatternOptions.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QRegularExpression.PatternOptions.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QRegularExpression.PatternOptions.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QRegularExpression.PatternOptions.enum_type f1, int f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QRegularExpression.PatternOptions.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QRegularExpression.PatternOptions.enum_type f1, int f2)nothrow;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QRegularExpression.PatternOptions operator ~(QRegularExpression.PatternOptions.enum_type e)nothrow{return~QRegularExpression.PatternOptions(e);}+/
/+pragma(inline, true) void operator |(QRegularExpression.PatternOptions.enum_type f1, int f2)nothrow;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QRegularExpression.PatternOptions.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_SHARED(QRegularExpression)
Q_DECLARE_OPERATORS_FOR_FLAGS(QRegularExpression::PatternOptions) +/
/+pragma(inline, true) QFlags!(QRegularExpression.MatchOptions.enum_type) operator |(QRegularExpression.MatchOptions.enum_type f1, QRegularExpression.MatchOptions.enum_type f2)nothrow{return QFlags!(QRegularExpression.MatchOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QRegularExpression.MatchOptions.enum_type) operator |(QRegularExpression.MatchOptions.enum_type f1, QFlags!(QRegularExpression.MatchOptions.enum_type) f2)nothrow{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QRegularExpression.MatchOptions.enum_type) operator &(QRegularExpression.MatchOptions.enum_type f1, QRegularExpression.MatchOptions.enum_type f2)nothrow{return QFlags!(QRegularExpression.MatchOptions.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QRegularExpression.MatchOptions.enum_type) operator &(QRegularExpression.MatchOptions.enum_type f1, QFlags!(QRegularExpression.MatchOptions.enum_type) f2)nothrow{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QRegularExpression.MatchOptions.enum_type) operator ^(QRegularExpression.MatchOptions.enum_type f1, QRegularExpression.MatchOptions.enum_type f2)nothrow{return QFlags!(QRegularExpression.MatchOptions.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QRegularExpression.MatchOptions.enum_type) operator ^(QRegularExpression.MatchOptions.enum_type f1, QFlags!(QRegularExpression.MatchOptions.enum_type) f2)nothrow{return f2^f1;}+/
/+pragma(inline, true) void operator +(QRegularExpression.MatchOptions.enum_type f1, QRegularExpression.MatchOptions.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QRegularExpression.MatchOptions.enum_type f1, QFlags!(QRegularExpression.MatchOptions.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QRegularExpression.MatchOptions.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(QRegularExpression.MatchOptions.enum_type f1, QRegularExpression.MatchOptions.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QRegularExpression.MatchOptions.enum_type f1, QFlags!(QRegularExpression.MatchOptions.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QRegularExpression.MatchOptions.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QRegularExpression.MatchOptions.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QRegularExpression.MatchOptions.enum_type f1, int f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QRegularExpression.MatchOptions.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QRegularExpression.MatchOptions.enum_type f1, int f2)nothrow;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QRegularExpression.MatchOptions operator ~(QRegularExpression.MatchOptions.enum_type e)nothrow{return~QRegularExpression.MatchOptions(e);}+/
/+pragma(inline, true) void operator |(QRegularExpression.MatchOptions.enum_type f1, int f2)nothrow;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QRegularExpression.MatchOptions.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/
}
/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QRegularExpression::MatchOptions)
#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &out, const QRegularExpression &re);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &in, QRegularExpression &re);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug debug, const QRegularExpression &re);
Q_CORE_EXPORT QDebug operator<<(QDebug debug, QRegularExpression::PatternOptions patternOptions);
#endif +/

struct QRegularExpressionMatchPrivate;
/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QRegularExpressionMatchPrivate, Q_CORE_EXPORT) +/
/// Binding for C++ class [QRegularExpressionMatch](https://doc.qt.io/qt-6/qregularexpressionmatch.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QRegularExpressionMatch
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    ~this();
    @disable this(this);
    this(ref const(QRegularExpressionMatch) match);
    /+ QRegularExpressionMatch(QRegularExpressionMatch &&match) = default; +/
    ref QRegularExpressionMatch opAssign(ref const(QRegularExpressionMatch) match);
    /+ QRegularExpressionMatch &operator=(QRegularExpressionMatch &&match) noexcept
    { d.swap(match.d); return *this; } +/
    /+ void swap(QRegularExpressionMatch &other) noexcept { d.swap(other.d); } +/

    QRegularExpression regularExpression() const;
    QRegularExpression.MatchType matchType() const;
    QRegularExpression.MatchOptions matchOptions() const;

    bool hasMatch() const;
    bool hasPartialMatch() const;

    bool isValid() const;

    int lastCapturedIndex() const;

    bool hasCaptured(ref const(QString) name) const
    { return hasCaptured(QStringView(name)); }
    bool hasCaptured(QStringView name) const;
    bool hasCaptured(int nth) const;

    QString captured(int nth = 0) const;
    QStringView capturedView(int nth = 0) const;

    QString captured(ref const(QString) name) const
    { return captured(QStringView(name)); }
    QString captured(QStringView name) const;
    QStringView capturedView(QStringView name) const;

    QStringList capturedTexts() const;

    qsizetype capturedStart(int nth = 0) const;
    qsizetype capturedLength(int nth = 0) const;
    qsizetype capturedEnd(int nth = 0) const;

    qsizetype capturedStart(ref const(QString) name) const
    { return capturedStart(QStringView(name)); }
    qsizetype capturedLength(ref const(QString) name) const
    { return capturedLength(QStringView(name)); }
    qsizetype capturedEnd(ref const(QString) name) const
    { return capturedEnd(QStringView(name)); }

    qsizetype capturedStart(QStringView name) const;
    qsizetype capturedLength(QStringView name) const;
    qsizetype capturedEnd(QStringView name) const;

private:
    /+ friend class QRegularExpression; +/
    /+ friend struct QRegularExpressionMatchPrivate; +/
    /+ friend class QRegularExpressionMatchIterator; +/

    this(ref QRegularExpressionMatchPrivate dd);
    QExplicitlySharedDataPointer!(QRegularExpressionMatchPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QRegularExpressionMatch)

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug debug, const QRegularExpressionMatch &match);
#endif +/

extern(C++, "QtPrivate") {
extern(C++, class) struct QRegularExpressionMatchIteratorRangeBasedForIteratorSentinel {}
}

struct QRegularExpressionMatchIteratorPrivate;
/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QRegularExpressionMatchIteratorPrivate, Q_CORE_EXPORT) +/
/// Binding for C++ class [QRegularExpressionMatchIterator](https://doc.qt.io/qt-6/qregularexpressionmatchiterator.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QRegularExpressionMatchIterator
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    ~this();
    @disable this(this);
    this(ref const(QRegularExpressionMatchIterator) iterator);
    /+ QRegularExpressionMatchIterator(QRegularExpressionMatchIterator &&iterator) = default; +/
    ref QRegularExpressionMatchIterator opAssign(ref const(QRegularExpressionMatchIterator) iterator);
    /+ QRegularExpressionMatchIterator &operator=(QRegularExpressionMatchIterator &&iterator) noexcept
    { d.swap(iterator.d); return *this; } +/
    /+ void swap(QRegularExpressionMatchIterator &other) noexcept { d.swap(other.d); } +/

    bool isValid() const;

    bool hasNext() const;
    QRegularExpressionMatch next();
    QRegularExpressionMatch peekNext() const;

    QRegularExpression regularExpression() const;
    QRegularExpression.MatchType matchType() const;
    QRegularExpression.MatchOptions matchOptions() const;

private:
    /+ friend class QRegularExpression; +/
    /+ friend Q_CORE_EXPORT QtPrivate::QRegularExpressionMatchIteratorRangeBasedForIterator begin(const QRegularExpressionMatchIterator &iterator); +/
    /+ friend QtPrivate::QRegularExpressionMatchIteratorRangeBasedForIteratorSentinel end(const QRegularExpressionMatchIterator &) { return {}; } +/

    this(ref QRegularExpressionMatchIteratorPrivate dd);
    QExplicitlySharedDataPointer!(QRegularExpressionMatchIteratorPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, "QtPrivate") {

// support for range-based for loop
extern(C++, class) struct QRegularExpressionMatchIteratorRangeBasedForIterator
{
public:
    alias value_type = QRegularExpressionMatch;
    alias difference_type = int;
    /+ using reference_type = const QRegularExpressionMatch &; +/
    alias pointer_type = const(QRegularExpressionMatch)*;
    /+ using iterator_category = std::forward_iterator_tag; +/

    @disable this();
    /+this()
    {
        this.m_atEnd = true;
    }+/

    /+/+ explicit +/this(ref const(QRegularExpressionMatchIterator) iterator)
    {
        this.m_matchIterator = iterator;
        this.m_currentMatch = typeof(this.m_currentMatch)();
        this.m_atEnd = false;

        ++this;
    }+/

    ref const(QRegularExpressionMatch) opUnary(string op)() const if (op == "*")
    {
        (mixin(Q_ASSERT_X(q{!m_atEnd},q{ Q_FUNC_INFO},q{ "operator* called on an iterator already at the end"})));
        return m_currentMatch;
    }

    ref QRegularExpressionMatchIteratorRangeBasedForIterator opUnary(string op)() if (op == "++")
    {
        (mixin(Q_ASSERT_X(q{!m_atEnd},q{ Q_FUNC_INFO},q{ "operator++ called on an iterator already at the end"})));
        if (m_matchIterator.hasNext()) {
            m_currentMatch = m_matchIterator.next();
        } else {
            m_currentMatch = QRegularExpressionMatch();
            m_atEnd = true;
        }

        return this;
    }

    /+QRegularExpressionMatchIteratorRangeBasedForIterator operator ++(int)
    {
        QRegularExpressionMatchIteratorRangeBasedForIterator i = this;
        ++this;
        return i;
    }+/

private:
    // [input.iterators] imposes operator== on us. Unfortunately, it's not
    // trivial to implement, so just do the bare minimum to satifisfy
    // Cpp17EqualityComparable.
    /+ friend bool operator==(const QRegularExpressionMatchIteratorRangeBasedForIterator &lhs,
                           const QRegularExpressionMatchIteratorRangeBasedForIterator &rhs) noexcept
    {
        return (&lhs == &rhs);
    } +/

    /+ friend bool operator!=(const QRegularExpressionMatchIteratorRangeBasedForIterator &lhs,
                           const QRegularExpressionMatchIteratorRangeBasedForIterator &rhs) noexcept
    {
        return !(lhs == rhs);
    } +/

    // This is what we really use in a range-based for.
    /+ friend bool operator==(const QRegularExpressionMatchIteratorRangeBasedForIterator &lhs,
                           QRegularExpressionMatchIteratorRangeBasedForIteratorSentinel) noexcept
    {
        return lhs.m_atEnd;
    } +/

    /+ friend bool operator!=(const QRegularExpressionMatchIteratorRangeBasedForIterator &lhs,
                           QRegularExpressionMatchIteratorRangeBasedForIteratorSentinel) noexcept
    {
        return !lhs.m_atEnd;
    } +/

    QRegularExpressionMatchIterator m_matchIterator;
    QRegularExpressionMatch m_currentMatch;
    bool m_atEnd;
}

} // namespace QtPrivate

/+ Q_DECLARE_SHARED(QRegularExpressionMatchIterator) +/

