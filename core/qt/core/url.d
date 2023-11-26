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
module qt.core.url;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.flags;
import qt.core.list;
import qt.core.string;
import qt.core.stringlist;
import qt.core.typeinfo;
import qt.helpers;

/+ #if defined(Q_OS_DARWIN) || defined(Q_QDOC)
Q_FORWARD_DECLARE_CF_TYPE(CFURL);
Q_FORWARD_DECLARE_OBJC_CLASS(NSURL);
#endif +/



extern(C++, class) struct QUrlQuery;
extern(C++, class) struct QUrlPrivate;

extern(C++, class) struct QUrlTwoFlags(E1, E2)
{
private:
    int i = 0;
public:
    @disable this();
    /+pragma(inline, true) this()
    {
        this.i = 0;
    }+/
    pragma(inline, true) this(E1 f)
    {
        this.i = f;
    }
    pragma(inline, true) this(E2 f)
    {
        this.i = f;
    }
    pragma(inline, true) this(QFlag f)
    {
        this.i = f;
    }
    /+pragma(inline, true) this(QFlags!(E1) f)
    {
        this.i = f.operatortypenameQFlags<E1E1>::Int  ();
    }
    pragma(inline, true) this(QFlags!(E2) f)
    {
        this.i = f.operatortypenameQFlags<E2E2>::Int  ();
    }+/

    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(int mask) if (op == "&") { i &= mask; return this; }
    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(uint mask) if (op == "&") { i &= mask; return this; }
    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(QFlags!(E1) mask) if (op == "&") { i &= mask.toInt(); return this; }
    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(QFlags!(E2) mask) if (op == "&") { i &= mask.toInt(); return this; }
    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(QUrlTwoFlags f) if (op == "|") { i |= f.i; return this; }
    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(E1 f) if (op == "|") { i |= f; return this; }
    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(E2 f) if (op == "|") { i |= f; return this; }
    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(QFlags!(E1) mask) if (op == "|") { i |= mask.toInt(); return this; }
    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(QFlags!(E2) mask) if (op == "|") { i |= mask.toInt(); return this; }
    /+pragma(inline, true) ref QUrlTwoFlags operator ^=(QUrlTwoFlags f) { i ^= f.i; return this; }+/
    /+pragma(inline, true) ref QUrlTwoFlags operator ^=(E1 f) { i ^= f; return this; }+/
    /+pragma(inline, true) ref QUrlTwoFlags operator ^=(E2 f) { i ^= f; return this; }+/
    /+pragma(inline, true) ref QUrlTwoFlags operator ^=(QFlags!(E1) mask) { i ^= mask.toInt(); return this; }+/
    /+pragma(inline, true) ref QUrlTwoFlags operator ^=(QFlags!(E2) mask) { i ^= mask.toInt(); return this; }+/

    /+pragma(inline, true) auto opCast(T : QFlags!(E1))() const { return QFlag(i); }+/
    /+pragma(inline, true) auto opCast(T : QFlags!(E2))() const { return QFlag(i); }+/
    /+pragma(inline, true) auto opCast(T : int)() const { return i; }+/
    /+pragma(inline, true) bool operator !() const { return !i; }+/

    pragma(inline, true) QUrlTwoFlags opBinary(string op)(QUrlTwoFlags f) const if (op == "|")
    { return QUrlTwoFlags(QFlag(i | f.i)); }
    pragma(inline, true) QUrlTwoFlags opBinary(string op)(E1 f) const if (op == "|")
    { return QUrlTwoFlags(QFlag(i | f)); }
    pragma(inline, true) QUrlTwoFlags opBinary(string op)(E2 f) const if (op == "|")
    { return QUrlTwoFlags(QFlag(i | f)); }
    /+pragma(inline, true) QUrlTwoFlags operator ^(QUrlTwoFlags f) const
    { return QUrlTwoFlags(QFlag(i ^ f.i)); }+/
    /+pragma(inline, true) QUrlTwoFlags operator ^(E1 f) const
    { return QUrlTwoFlags(QFlag(i ^ f)); }+/
    /+pragma(inline, true) QUrlTwoFlags operator ^(E2 f) const
    { return QUrlTwoFlags(QFlag(i ^ f)); }+/
    pragma(inline, true) QUrlTwoFlags opBinary(string op)(int mask) const if (op == "&")
    { return QUrlTwoFlags(QFlag(i & mask)); }
    pragma(inline, true) QUrlTwoFlags opBinary(string op)(uint mask) const if (op == "&")
    { return QUrlTwoFlags(QFlag(i & mask)); }
    pragma(inline, true) QUrlTwoFlags opBinary(string op)(E1 f) const if (op == "&")
    { return QUrlTwoFlags(QFlag(i & f)); }
    pragma(inline, true) QUrlTwoFlags opBinary(string op)(E2 f) const if (op == "&")
    { return QUrlTwoFlags(QFlag(i & f)); }
    /+pragma(inline, true) QUrlTwoFlags operator ~() const
    { return QUrlTwoFlags(QFlag(~i)); }+/

    pragma(inline, true) bool testFlag(E1 f) const { return (i & f) == f && (f != 0 || i == int(f)); }
    pragma(inline, true) bool testFlag(E2 f) const { return (i & f) == f && (f != 0 || i == int(f)); }
}

/+ template<typename E1, typename E2>
class QTypeInfo<QUrlTwoFlags<E1, E2> > : public QTypeInfoMerger<QUrlTwoFlags<E1, E2>, E1, E2> {};

// qHash is a friend, but we can't use default arguments for friends (§8.3.6.4)
Q_CORE_EXPORT size_t qHash(const QUrl &url, size_t seed = 0) noexcept; +/

/// Binding for C++ class [QUrl](https://doc.qt.io/qt-6/qurl.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QUrl
{
public:
    enum ParsingMode {
        TolerantMode,
        StrictMode,
        DecodedMode
    }

    // encoding / toString values
    enum UrlFormattingOption : uint {
        None = 0x0,
        RemoveScheme = 0x1,
        RemovePassword = 0x2,
        RemoveUserInfo = UrlFormattingOption.RemovePassword | 0x4,
        RemovePort = 0x8,
        RemoveAuthority = UrlFormattingOption.RemoveUserInfo | UrlFormattingOption.RemovePort | 0x10,
        RemovePath = 0x20,
        RemoveQuery = 0x40,
        RemoveFragment = 0x80,
        // 0x100 was a private code in Qt 4, keep unused for a while
        PreferLocalFile = 0x200,
        StripTrailingSlash = 0x400,
        RemoveFilename = 0x800,
        NormalizePathSegments = 0x1000
    }

    enum ComponentFormattingOption : uint {
        PrettyDecoded = 0x000000,
        EncodeSpaces = 0x100000,
        EncodeUnicode = 0x200000,
        EncodeDelimiters = 0x400000 | 0x800000,
        EncodeReserved = 0x1000000,
        DecodeReserved = 0x2000000,
        // 0x4000000 used to indicate full-decode mode

        FullyEncoded = ComponentFormattingOption.EncodeSpaces | ComponentFormattingOption.EncodeUnicode | ComponentFormattingOption.EncodeDelimiters | ComponentFormattingOption.EncodeReserved,
        FullyDecoded = ComponentFormattingOption.FullyEncoded | ComponentFormattingOption.DecodeReserved | 0x4000000
    }
    /+ Q_DECLARE_FLAGS(ComponentFormattingOptions, ComponentFormattingOption) +/
alias ComponentFormattingOptions = QFlags!(ComponentFormattingOption);/+ #ifdef Q_QDOC
private:
    // We need to let qdoc think that FormattingOptions is a normal QFlags, but
    // it needs to be a QUrlTwoFlags for compiling default arguments of some functions.
    template<typename T> struct QFlags : QUrlTwoFlags<T, ComponentFormattingOption>
    { using QUrlTwoFlags<T, ComponentFormattingOption>::QUrlTwoFlags; };
public:
    Q_DECLARE_FLAGS(FormattingOptions, UrlFormattingOption)
#else +/
    alias FormattingOptions = QUrlTwoFlags!(UrlFormattingOption, ComponentFormattingOption);
/+ #endif +/

    /+this();+/

    @disable this(this);
    this(ref const(QUrl) copy);
    /+ref QUrl operator =(ref const(QUrl) copy);+/
    version(QT_NO_URL_CAST_FROM_STRING)
    {
        /+ explicit +/this(ref const(QString) url, ParsingMode mode = ParsingMode.TolerantMode);
    }
    else
    {
        this(ref const(QString) url, ParsingMode mode = ParsingMode.TolerantMode);
        /+ref QUrl operator =(ref const(QString) url);+/
    }
    /+ QUrl(QUrl &&other) noexcept : d(other.d)
    { other.d = nullptr; } +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QUrl) +/
    ~this();

    /+ inline void swap(QUrl &other) noexcept { qSwap(d, other.d); } +/

    void setUrl(ref const(QString) url, ParsingMode mode = ParsingMode.TolerantMode);
//    QString url(FormattingOptions options = FormattingOptions(ComponentFormattingOption.PrettyDecoded)) const;
//    QString toString(FormattingOptions options = FormattingOptions(ComponentFormattingOption.PrettyDecoded)) const;
//    QString toDisplayString(FormattingOptions options = FormattingOptions(ComponentFormattingOption.PrettyDecoded)) const;
    /+ [[nodiscard]] +/ QUrl adjusted(FormattingOptions options) const;

//    QByteArray toEncoded(FormattingOptions options = ComponentFormattingOption.FullyEncoded) const;
    static QUrl fromEncoded(ref const(QByteArray) url, ParsingMode mode = ParsingMode.TolerantMode);

    enum UserInputResolutionOption {
        DefaultResolution,
        AssumeLocalFile
    }
    /+ Q_DECLARE_FLAGS(UserInputResolutionOptions, UserInputResolutionOption) +/
alias UserInputResolutionOptions = QFlags!(UserInputResolutionOption);
    static QUrl fromUserInput(ref const(QString) userInput, ref const(QString) workingDirectory = globalInitVar!QString,
                                  UserInputResolutionOptions options = UserInputResolutionOption.DefaultResolution);

    bool isValid() const;
    QString errorString() const;

    bool isEmpty() const;
    void clear();

    void setScheme(ref const(QString) scheme);
    QString scheme() const;

    void setAuthority(ref const(QString) authority, ParsingMode mode = ParsingMode.TolerantMode);
    QString authority(ComponentFormattingOptions options = ComponentFormattingOption.PrettyDecoded) const;

    void setUserInfo(ref const(QString) userInfo, ParsingMode mode = ParsingMode.TolerantMode);
    QString userInfo(ComponentFormattingOptions options = ComponentFormattingOption.PrettyDecoded) const;

    void setUserName(ref const(QString) userName, ParsingMode mode = ParsingMode.DecodedMode);
    QString userName(ComponentFormattingOptions options = ComponentFormattingOption.FullyDecoded) const;

    void setPassword(ref const(QString) password, ParsingMode mode = ParsingMode.DecodedMode);
    QString password(ComponentFormattingOptions /+ = FullyDecoded +/) const;

    void setHost(ref const(QString) host, ParsingMode mode = ParsingMode.DecodedMode);
    QString host(ComponentFormattingOptions /+ = FullyDecoded +/) const;

    void setPort(int port);
    int port(int defaultPort = -1) const;

    void setPath(ref const(QString) path, ParsingMode mode = ParsingMode.DecodedMode);
    QString path(ComponentFormattingOptions options = ComponentFormattingOption.FullyDecoded) const;
    QString fileName(ComponentFormattingOptions options = ComponentFormattingOption.FullyDecoded) const;

    bool hasQuery() const;
    void setQuery(ref const(QString) query, ParsingMode mode = ParsingMode.TolerantMode);
    void setQuery(ref const(QUrlQuery) query);
    QString query(ComponentFormattingOptions /+ = PrettyDecoded +/) const;

    bool hasFragment() const;
    QString fragment(ComponentFormattingOptions options = ComponentFormattingOption.PrettyDecoded) const;
    void setFragment(ref const(QString) fragment, ParsingMode mode = ParsingMode.TolerantMode);

    /+ [[nodiscard]] +/ QUrl resolved(ref const(QUrl) relative) const;

    bool isRelative() const;
    bool isParentOf(ref const(QUrl) url) const;

    bool isLocalFile() const;
    static QUrl fromLocalFile(ref const(QString) localfile);
    QString toLocalFile() const;

    void detach();
    bool isDetached() const;

    /+bool operator <(ref const(QUrl) url) const;+/
    /+bool operator ==(ref const(QUrl) url) const;+/
    /+bool operator !=(ref const(QUrl) url) const;+/

    bool matches(ref const(QUrl) url, FormattingOptions options) const;

    static QString fromPercentEncoding(ref const(QByteArray) );
    static QByteArray toPercentEncoding(ref const(QString) ,
                                            ref const(QByteArray) exclude = globalInitVar!QByteArray,
                                            ref const(QByteArray) include = globalInitVar!QByteArray);
    static if ((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ static QUrl fromCFURL(CFURLRef url); +/
        /+ CFURLRef toCFURL() const Q_DECL_CF_RETURNS_RETAINED; +/
        /+ static QUrl fromNSURL(const NSURL *url); +/
        /+ NSURL *toNSURL() const Q_DECL_NS_RETURNS_AUTORELEASED; +/
    }

    static QString fromAce(ref const(QByteArray) );
    static QByteArray toAce(ref const(QString) );
    static QStringList idnWhitelist();
    static QStringList toStringList(ref const(QList!(QUrl)) uris, FormattingOptions options = FormattingOptions(ComponentFormattingOption.PrettyDecoded));
    static QList!(QUrl) fromStringList(ref const(QStringList) uris, ParsingMode mode = ParsingMode.TolerantMode);

    static void setIdnWhitelist(ref const(QStringList) );
    /+ friend Q_CORE_EXPORT size_t qHash(const QUrl &url, size_t seed) noexcept; +/

private:
    QUrlPrivate* d;
    /+ friend class QUrlQuery; +/

public:
    alias DataPtr = QUrlPrivate*;
    pragma(inline, true) ref DataPtr data_ptr() return { return d; }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QUrl.ComponentFormattingOptions.enum_type) operator |(QUrl.ComponentFormattingOptions.enum_type f1, QUrl.ComponentFormattingOptions.enum_type f2)/+noexcept+/{return QFlags!(QUrl.ComponentFormattingOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QUrl.ComponentFormattingOptions.enum_type) operator |(QUrl.ComponentFormattingOptions.enum_type f1, QFlags!(QUrl.ComponentFormattingOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QUrl.ComponentFormattingOptions.enum_type) operator &(QUrl.ComponentFormattingOptions.enum_type f1, QUrl.ComponentFormattingOptions.enum_type f2)/+noexcept+/{return QFlags!(QUrl.ComponentFormattingOptions.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QUrl.ComponentFormattingOptions.enum_type) operator &(QUrl.ComponentFormattingOptions.enum_type f1, QFlags!(QUrl.ComponentFormattingOptions.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) void operator +(QUrl.ComponentFormattingOptions.enum_type f1, QUrl.ComponentFormattingOptions.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QUrl.ComponentFormattingOptions.enum_type f1, QFlags!(QUrl.ComponentFormattingOptions.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QUrl.ComponentFormattingOptions.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QUrl.ComponentFormattingOptions.enum_type f1, QUrl.ComponentFormattingOptions.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QUrl.ComponentFormattingOptions.enum_type f1, QFlags!(QUrl.ComponentFormattingOptions.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QUrl.ComponentFormattingOptions.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) QIncompatibleFlag operator |(QUrl.ComponentFormattingOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+pragma(inline, true) void operator +(int f1, QUrl.ComponentFormattingOptions.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QUrl.ComponentFormattingOptions.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QUrl.ComponentFormattingOptions.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QUrl.ComponentFormattingOptions.enum_type f1, int f2)/+noexcept+/;+/

/+ Q_DECLARE_SHARED(QUrl)
Q_DECLARE_OPERATORS_FOR_FLAGS(QUrl::ComponentFormattingOptions)//Q_DECLARE_OPERATORS_FOR_FLAGS(QUrl::FormattingOptions)

#ifndef Q_QDOC +/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.UrlFormattingOption f1, QUrl.UrlFormattingOption f2)
{ return QUrl.FormattingOptions(f1) | f2; }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.UrlFormattingOption f1, QUrl.FormattingOptions f2)
{ return f2 | f1; }+/
/+pragma(inline, true) QIncompatibleFlag operator |(QUrl.UrlFormattingOption f1, int f2)
{ return QIncompatibleFlag(uint(f1) | f2); }+/

// add operators for OR'ing the two types of flags
/+pragma(inline, true) ref QUrl.FormattingOptions operator |=(ref QUrl.FormattingOptions i, QUrl.ComponentFormattingOptions f)
{ i |= QUrl.UrlFormattingOption(f.toInt()); return i; }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.UrlFormattingOption i, QUrl.ComponentFormattingOption f)
{ return i | QUrl.UrlFormattingOption(qToUnderlying(f)); }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.UrlFormattingOption i, QUrl.ComponentFormattingOptions f)
{ return i | QUrl.UrlFormattingOption(f.toInt()); }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.ComponentFormattingOption f, QUrl.UrlFormattingOption i)
{ return i | QUrl.UrlFormattingOption(qToUnderlying(f)); }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.ComponentFormattingOptions f, QUrl.UrlFormattingOption i)
{ return i | QUrl.UrlFormattingOption(f.toInt()); }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.FormattingOptions i, QUrl.ComponentFormattingOptions f)
{ return i | QUrl.UrlFormattingOption(f.toInt()); }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.ComponentFormattingOption f, QUrl.FormattingOptions i)
{ return i | QUrl.UrlFormattingOption(qToUnderlying(f)); }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.ComponentFormattingOptions f, QUrl.FormattingOptions i)
{ return i | QUrl.UrlFormattingOption(f.toInt()); }+/

//inline QUrl::UrlFormattingOption &operator=(const QUrl::UrlFormattingOption &i, QUrl::ComponentFormattingOptions f)
//{ i = int(f); f; }
/+ #endif // Q_QDOC

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QUrl &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QUrl &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QUrl &);
#endif +/

