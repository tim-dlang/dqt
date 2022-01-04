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
import qt.core.metatype;
import qt.core.shareddata;
import qt.core.string;
import qt.core.stringlist;
import qt.core.stringview;
import qt.core.typeinfo;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(regularexpression); +/


struct QRegularExpressionPrivate;

/+ Q_CORE_EXPORT uint qHash(const QRegularExpression &key, uint seed = 0) noexcept; +/

/// Binding for C++ class [QRegularExpression](https://doc.qt.io/qt-5/qregularexpression.html).
@Q_MOVABLE_TYPE @(QMetaType.Type.QRegularExpression) extern(C++, class) struct /+ Q_CORE_EXPORT +/ QRegularExpression
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
        OptimizeOnFirstUsageOption /+ Q_DECL_ENUMERATOR_DEPRECATED_X("This option does not have any effect since Qt 5.12") +/ = 0x0080,
        DontAutomaticallyOptimizeOption /+ Q_DECL_ENUMERATOR_DEPRECATED_X("This option does not have any effect since Qt 5.12") +/ = 0x0100,
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
    ~this();
    /+ref QRegularExpression operator =(ref const(QRegularExpression) re);+/
    /+ QRegularExpression &operator=(QRegularExpression &&re) noexcept
    { d.swap(re.d); return *this; } +/

    /+ void swap(QRegularExpression &other) noexcept { d.swap(other.d); } +/

    QString pattern() const;
    void setPattern(ref const(QString) pattern);

    bool isValid() const;
    int patternErrorOffset() const;
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
        AnchoredMatchOption        = 0x0001,
        DontCheckSubjectStringMatchOption = 0x0002
    }
    /+ Q_DECLARE_FLAGS(MatchOptions, MatchOption) +/
alias MatchOptions = QFlags!(MatchOption);
    QRegularExpressionMatch match(ref const(QString) subject,
                                      int offset                = 0,
                                      MatchType matchType       = MatchType.NormalMatch,
                                      MatchOptions matchOptions = MatchOption.NoMatchOption) const;

    QRegularExpressionMatch match(ref const(QStringRef) subjectRef,
                                      int offset                = 0,
                                      MatchType matchType       = MatchType.NormalMatch,
                                      MatchOptions matchOptions = MatchOption.NoMatchOption) const;

    pragma(inline, true) QRegularExpressionMatch match(QStringView subject,
                                      int offset                = 0,
                                      MatchType matchType       = MatchType.NormalMatch,
                                      MatchOptions matchOptions = MatchOption.NoMatchOption) const
    /+
    pragma(inline, true) QRegularExpressionMatch match(QStringView subject, int offset,
                                                      QRegularExpression.MatchType matchType, MatchOptions matchOptions) const+/
    {
        auto tmp = subject.toString(); return match(tmp, offset, matchType, matchOptions);
    }

    QRegularExpressionMatchIterator globalMatch(ref const(QString) subject,
                                                    int offset                = 0,
                                                    MatchType matchType       = MatchType.NormalMatch,
                                                    MatchOptions matchOptions = MatchOption.NoMatchOption) const;

    QRegularExpressionMatchIterator globalMatch(ref const(QStringRef) subjectRef,
                                                    int offset                = 0,
                                                    MatchType matchType       = MatchType.NormalMatch,
                                                    MatchOptions matchOptions = MatchOption.NoMatchOption) const;

    pragma(inline, true) QRegularExpressionMatchIterator globalMatch(QStringView subject,
                                                    int offset                = 0,
                                                    MatchType matchType       = MatchType.NormalMatch,
                                                    MatchOptions matchOptions = MatchOption.NoMatchOption) const
    /+
    pragma(inline, true) QRegularExpressionMatchIterator globalMatch(QStringView subject, int offset,
                                                                    QRegularExpression.MatchType matchType, MatchOptions matchOptions) const+/
    {
        auto tmp = subject.toString(); return globalMatch(tmp, offset, matchType, matchOptions);
    }

    void optimize() const;

    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        static QString escape(ref const(QString) str);
        static QString wildcardToRegularExpression(ref const(QString) str);
        pragma(inline, true) static QString anchoredPattern(ref const(QString) expression)
        {
            return anchoredPattern(QStringView(expression));
        }
    }

    static QString escape(QStringView str);
    static QString wildcardToRegularExpression(QStringView str);
    static QString anchoredPattern(QStringView expression);

    /+bool operator ==(ref const(QRegularExpression) re) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QRegularExpression) re) const { return !operator==(re); }+/

private:
    /+ friend struct QRegularExpressionPrivate; +/
    /+ friend class QRegularExpressionMatch; +/
    /+ friend struct QRegularExpressionMatchPrivate; +/
    /+ friend class QRegularExpressionMatchIterator; +/
    /+ friend Q_CORE_EXPORT uint qHash(const QRegularExpression &key, uint seed) noexcept; +/

    this(ref QRegularExpressionPrivate dd);
    QExplicitlySharedDataPointer!(QRegularExpressionPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QRegularExpression.PatternOptions.enum_type) operator |(QRegularExpression.PatternOptions.enum_type f1, QRegularExpression.PatternOptions.enum_type f2)/+noexcept+/{return QFlags!(QRegularExpression.PatternOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QRegularExpression.PatternOptions.enum_type) operator |(QRegularExpression.PatternOptions.enum_type f1, QFlags!(QRegularExpression.PatternOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QRegularExpression.PatternOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_SHARED(QRegularExpression)
Q_DECLARE_OPERATORS_FOR_FLAGS(QRegularExpression::PatternOptions) +/
/+pragma(inline, true) QFlags!(QRegularExpression.MatchOptions.enum_type) operator |(QRegularExpression.MatchOptions.enum_type f1, QRegularExpression.MatchOptions.enum_type f2)/+noexcept+/{return QFlags!(QRegularExpression.MatchOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QRegularExpression.MatchOptions.enum_type) operator |(QRegularExpression.MatchOptions.enum_type f1, QFlags!(QRegularExpression.MatchOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QRegularExpression.MatchOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
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

/// Binding for C++ class [QRegularExpressionMatch](https://doc.qt.io/qt-5/qregularexpressionmatch.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QRegularExpressionMatch
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
    /+ref QRegularExpressionMatch operator =(ref const(QRegularExpressionMatch) match);+/
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

    QString captured(int nth = 0) const;
    QStringRef capturedRef(int nth = 0) const;
    QStringView capturedView(int nth = 0) const;

    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        QString captured(ref const(QString) name) const;
        QStringRef capturedRef(ref const(QString) name) const;
    }

    QString captured(QStringView name) const;
    QStringRef capturedRef(QStringView name) const;
    QStringView capturedView(QStringView name) const;

    QStringList capturedTexts() const;

    int capturedStart(int nth = 0) const;
    int capturedLength(int nth = 0) const;
    int capturedEnd(int nth = 0) const;

    static if(QT_STRINGVIEW_LEVEL < 2)
    {
        int capturedStart(ref const(QString) name) const;
        int capturedLength(ref const(QString) name) const;
        int capturedEnd(ref const(QString) name) const;
    }

    int capturedStart(QStringView name) const;
    int capturedLength(QStringView name) const;
    int capturedEnd(QStringView name) const;

private:
    /+ friend class QRegularExpression; +/
    /+ friend struct QRegularExpressionMatchPrivate; +/
    /+ friend class QRegularExpressionMatchIterator; +/

    this(ref QRegularExpressionMatchPrivate dd);
    QSharedDataPointer!(QRegularExpressionMatchPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QRegularExpressionMatch)

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug debug, const QRegularExpressionMatch &match);
#endif +/

struct QRegularExpressionMatchIteratorPrivate;

/// Binding for C++ class [QRegularExpressionMatchIterator](https://doc.qt.io/qt-5/qregularexpressionmatchiterator.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QRegularExpressionMatchIterator
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
    /+ref QRegularExpressionMatchIterator operator =(ref const(QRegularExpressionMatchIterator) iterator);+/
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

    this(ref QRegularExpressionMatchIteratorPrivate dd);
    QSharedDataPointer!(QRegularExpressionMatchIteratorPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QRegularExpressionMatchIterator) +/


