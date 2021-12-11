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
import qt.core.metatype;
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
/+ class QDataStream; +/

extern(C++, class) struct QUrlTwoFlags(E1, E2)
{
private:
    int i;
    alias Zero = int/+ QUrlTwoFlags:: * +/*;
public:
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
    @disable this();
    pragma(inline, true) this(Zero /+ = 0 +/)
    {
        this.i = 0;
    }

    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(int mask) if(op == "&") { i &= mask; return this; }
    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(uint mask) if(op == "&") { i &= mask; return this; }
    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(QUrlTwoFlags f) if(op == "|") { i |= f.i; return this; }
    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(E1 f) if(op == "|") { i |= f; return this; }
    pragma(inline, true) ref QUrlTwoFlags opOpAssign(string op)(E2 f) if(op == "|") { i |= f; return this; }
    /+pragma(inline, true) ref QUrlTwoFlags operator ^=(QUrlTwoFlags f) { i ^= f.i; return this; }+/
    /+pragma(inline, true) ref QUrlTwoFlags operator ^=(E1 f) { i ^= f; return this; }+/
    /+pragma(inline, true) ref QUrlTwoFlags operator ^=(E2 f) { i ^= f; return this; }+/

    /+pragma(inline, true) auto opCast(T : QFlags!(E1))() const { return QFlag(i); }+/
    /+pragma(inline, true) auto opCast(T : QFlags!(E2))() const { return QFlag(i); }+/
    /+pragma(inline, true) auto opCast(T : int)() const { return i; }+/
    /+pragma(inline, true) bool operator !() const { return !i; }+/

    pragma(inline, true) QUrlTwoFlags opBinary(string op)(QUrlTwoFlags f) const if(op == "|")
    { return QUrlTwoFlags(QFlag(i | f.i)); }
    pragma(inline, true) QUrlTwoFlags opBinary(string op)(E1 f) const if(op == "|")
    { return QUrlTwoFlags(QFlag(i | f)); }
    pragma(inline, true) QUrlTwoFlags opBinary(string op)(E2 f) const if(op == "|")
    { return QUrlTwoFlags(QFlag(i | f)); }
    /+pragma(inline, true) QUrlTwoFlags operator ^(QUrlTwoFlags f) const
    { return QUrlTwoFlags(QFlag(i ^ f.i)); }+/
    /+pragma(inline, true) QUrlTwoFlags operator ^(E1 f) const
    { return QUrlTwoFlags(QFlag(i ^ f)); }+/
    /+pragma(inline, true) QUrlTwoFlags operator ^(E2 f) const
    { return QUrlTwoFlags(QFlag(i ^ f)); }+/
    pragma(inline, true) QUrlTwoFlags opBinary(string op)(int mask) const if(op == "&")
    { return QUrlTwoFlags(QFlag(i & mask)); }
    pragma(inline, true) QUrlTwoFlags opBinary(string op)(uint mask) const if(op == "&")
    { return QUrlTwoFlags(QFlag(i & mask)); }
    pragma(inline, true) QUrlTwoFlags opBinary(string op)(E1 f) const if(op == "&")
    { return QUrlTwoFlags(QFlag(i & f)); }
    pragma(inline, true) QUrlTwoFlags opBinary(string op)(E2 f) const if(op == "&")
    { return QUrlTwoFlags(QFlag(i & f)); }
    /+pragma(inline, true) QUrlTwoFlags operator ~() const
    { return QUrlTwoFlags(QFlag(~i)); }+/

    pragma(inline, true) bool testFlag(E1 f) const { return (i & f) == f && (f != 0 || i == int(f)); }
    pragma(inline, true) bool testFlag(E2 f) const { return (i & f) == f && (f != 0 || i == int(f)); }
}

/+ template<typename E1, typename E2>
class QTypeInfo<QUrlTwoFlags<E1, E2> > : public QTypeInfoMerger<QUrlTwoFlags<E1, E2>, E1, E2> {};

class QUrl;
// qHash is a friend, but we can't use default arguments for friends (§8.3.6.4)
Q_CORE_EXPORT uint qHash(const QUrl &url, uint seed = 0) noexcept; +/

@Q_MOVABLE_TYPE @(QMetaType.Type.QUrl) extern(C++, class) struct /+ Q_CORE_EXPORT +/ QUrl
{
public:
    enum ParsingMode {
        TolerantMode,
        StrictMode,
        DecodedMode
    }

    // encoding / toString values
    enum UrlFormattingOption {
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

    enum ComponentFormattingOption {
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
    // it needs to be a QUrlTwoFlags for compiling default arguments of somme functions.
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
    /+ inline QUrl &operator=(QUrl &&other) noexcept
    { qSwap(d, other.d); return *this; } +/
    ~this();

    /+ inline void swap(QUrl &other) noexcept { qSwap(d, other.d); } +/

    void setUrl(ref const(QString) url, ParsingMode mode = ParsingMode.TolerantMode);
//    QString url(FormattingOptions options = FormattingOptions(cast(QUrlTwoFlags.Zero)(ComponentFormattingOption.PrettyDecoded))) const;
//    QString toString(FormattingOptions options = FormattingOptions(cast(QUrlTwoFlags.Zero)(ComponentFormattingOption.PrettyDecoded))) const;
//    QString toDisplayString(FormattingOptions options = FormattingOptions(cast(QUrlTwoFlags.Zero)(ComponentFormattingOption.PrettyDecoded))) const;
    /+ Q_REQUIRED_RESULT +/ QUrl adjusted(FormattingOptions options) const;

//    QByteArray toEncoded(FormattingOptions options = ComponentFormattingOption.FullyEncoded) const;
    static QUrl fromEncoded(ref const(QByteArray) url, ParsingMode mode = ParsingMode.TolerantMode);

    enum UserInputResolutionOption {
        DefaultResolution,
        AssumeLocalFile
    }
    /+ Q_DECLARE_FLAGS(UserInputResolutionOptions, UserInputResolutionOption) +/
alias UserInputResolutionOptions = QFlags!(UserInputResolutionOption);
    static QUrl fromUserInput(ref const(QString) userInput);
    // ### Qt6 merge with fromUserInput(QString), by adding = QString()
    static QUrl fromUserInput(ref const(QString) userInput, ref const(QString) workingDirectory,
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
/+ #if QT_DEPRECATED_SINCE(5, 15)
#if QT_CONFIG(topleveldomain) +/
    /+ QT_DEPRECATED +/ QString topLevelDomain(ComponentFormattingOptions options = ComponentFormattingOption.FullyDecoded) const;
/+ #endif
#endif +/ // QT_DEPRECATED_SINCE(5, 15)

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

    /+ Q_REQUIRED_RESULT +/ QUrl resolved(ref const(QUrl) relative) const;

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
/+ #if defined(Q_OS_DARWIN) || defined(Q_QDOC) +/
    static if((versionIsSet!("OSX") || versionIsSet!("iOS") || versionIsSet!("TVOS") || versionIsSet!("WatchOS")))
    {
        /+ static QUrl fromCFURL(CFURLRef url); +/
        /+ CFURLRef toCFURL() const Q_DECL_CF_RETURNS_RETAINED; +/
        /+ static QUrl fromNSURL(const NSURL *url); +/
        /+ NSURL *toNSURL() const Q_DECL_NS_RETURNS_AUTORELEASED; +/
    }
/+ #endif

#if QT_DEPRECATED_SINCE(5,0)
    QT_DEPRECATED static QString fromPunycode(const QByteArray &punycode)
    { return fromAce(punycode); }
    QT_DEPRECATED static QByteArray toPunycode(const QString &string)
    { return toAce(string); }

    QT_DEPRECATED inline void setQueryItems(const QList<QPair<QString, QString> > &qry);
    QT_DEPRECATED inline void addQueryItem(const QString &key, const QString &value);
    QT_DEPRECATED inline QList<QPair<QString, QString> > queryItems() const;
    QT_DEPRECATED inline bool hasQueryItem(const QString &key) const;
    QT_DEPRECATED inline QString queryItemValue(const QString &key) const;
    QT_DEPRECATED inline QStringList allQueryItemValues(const QString &key) const;
    QT_DEPRECATED inline void removeQueryItem(const QString &key);
    QT_DEPRECATED inline void removeAllQueryItems(const QString &key);

    QT_DEPRECATED inline void setEncodedQueryItems(const QList<QPair<QByteArray, QByteArray> > &query);
    QT_DEPRECATED inline void addEncodedQueryItem(const QByteArray &key, const QByteArray &value);
    QT_DEPRECATED inline QList<QPair<QByteArray, QByteArray> > encodedQueryItems() const;
    QT_DEPRECATED inline bool hasEncodedQueryItem(const QByteArray &key) const;
    QT_DEPRECATED inline QByteArray encodedQueryItemValue(const QByteArray &key) const;
    QT_DEPRECATED inline QList<QByteArray> allEncodedQueryItemValues(const QByteArray &key) const;
    QT_DEPRECATED inline void removeEncodedQueryItem(const QByteArray &key);
    QT_DEPRECATED inline void removeAllEncodedQueryItems(const QByteArray &key);

    QT_DEPRECATED void setEncodedUrl(const QByteArray &u, ParsingMode mode = TolerantMode)
    { setUrl(fromEncodedComponent_helper(u), mode); }

    QT_DEPRECATED QByteArray encodedUserName() const
    { return userName(FullyEncoded).toLatin1(); }
    QT_DEPRECATED void setEncodedUserName(const QByteArray &value)
    { setUserName(fromEncodedComponent_helper(value)); }

    QT_DEPRECATED QByteArray encodedPassword() const
    { return password(FullyEncoded).toLatin1(); }
    QT_DEPRECATED void setEncodedPassword(const QByteArray &value)
    { setPassword(fromEncodedComponent_helper(value)); }

    QT_DEPRECATED QByteArray encodedHost() const
    { return host(FullyEncoded).toLatin1(); }
    QT_DEPRECATED void setEncodedHost(const QByteArray &value)
    { setHost(fromEncodedComponent_helper(value)); }

    QT_DEPRECATED QByteArray encodedPath() const
    { return path(FullyEncoded).toLatin1(); }
    QT_DEPRECATED void setEncodedPath(const QByteArray &value)
    { setPath(fromEncodedComponent_helper(value)); }

    QT_DEPRECATED QByteArray encodedQuery() const
    { return toLatin1_helper(query(FullyEncoded)); }
    QT_DEPRECATED void setEncodedQuery(const QByteArray &value)
    { setQuery(fromEncodedComponent_helper(value)); }

    QT_DEPRECATED QByteArray encodedFragment() const
    { return toLatin1_helper(fragment(FullyEncoded)); }
    QT_DEPRECATED void setEncodedFragment(const QByteArray &value)
    { setFragment(fromEncodedComponent_helper(value)); }

private:
    // helper function for the encodedQuery and encodedFragment functions
    static QByteArray toLatin1_helper(const QString &string)
    {
        if (string.isEmpty())
            return string.isNull() ? QByteArray() : QByteArray("");
        return string.toLatin1();
    }
#endif +/
private:
    static QString fromEncodedComponent_helper(ref const(QByteArray) ba);

public:
    static QString fromAce(ref const(QByteArray) );
    static QByteArray toAce(ref const(QString) );
    static QStringList idnWhitelist();
    static QStringList toStringList(ref const(QList!(QUrl)) uris, FormattingOptions options = FormattingOptions(ComponentFormattingOption.PrettyDecoded));
    static QList!(QUrl) fromStringList(ref const(QStringList) uris, ParsingMode mode = ParsingMode.TolerantMode);

    static void setIdnWhitelist(ref const(QStringList) );
    /+ friend Q_CORE_EXPORT uint qHash(const QUrl &url, uint seed) noexcept; +/

private:
    QUrlPrivate* d;
    /+ friend class QUrlQuery; +/

public:
    alias DataPtr = QUrlPrivate*;
    pragma(inline, true) ref DataPtr data_ptr() return { return d; }
}
/+pragma(inline, true) QFlags!(QUrl.ComponentFormattingOptions.enum_type) operator |(QUrl.ComponentFormattingOptions.enum_type f1, QUrl.ComponentFormattingOptions.enum_type f2)/+noexcept+/{return QFlags!(QUrl.ComponentFormattingOptions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QUrl.ComponentFormattingOptions.enum_type) operator |(QUrl.ComponentFormattingOptions.enum_type f1, QFlags!(QUrl.ComponentFormattingOptions.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QUrl.ComponentFormattingOptions.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_SHARED(QUrl)
Q_DECLARE_OPERATORS_FOR_FLAGS(QUrl::ComponentFormattingOptions)//Q_DECLARE_OPERATORS_FOR_FLAGS(QUrl::FormattingOptions)

#ifndef Q_QDOC +/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.UrlFormattingOption f1, QUrl.UrlFormattingOption f2)
{ return QUrl.FormattingOptions(cast(QUrlTwoFlags.Zero)(f1)) | f2; }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.UrlFormattingOption f1, QUrl.FormattingOptions f2)
{ return f2 | f1; }+/
/+pragma(inline, true) QIncompatibleFlag operator |(QUrl.UrlFormattingOption f1, int f2)
{ return QIncompatibleFlag(int(f1) | f2); }+/

// add operators for OR'ing the two types of flags
/+pragma(inline, true) ref QUrl.FormattingOptions operator |=(ref QUrl.FormattingOptions i, QUrl.ComponentFormattingOptions f)
{ i |= QUrl.UrlFormattingOption(cast(int)(f)); return i; }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.UrlFormattingOption i, QUrl.ComponentFormattingOption f)
{ return i | QUrl.UrlFormattingOption(int(f)); }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.UrlFormattingOption i, QUrl.ComponentFormattingOptions f)
{ return i | QUrl.UrlFormattingOption(cast(int)(f)); }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.ComponentFormattingOption f, QUrl.UrlFormattingOption i)
{ return i | QUrl.UrlFormattingOption(int(f)); }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.ComponentFormattingOptions f, QUrl.UrlFormattingOption i)
{ return i | QUrl.UrlFormattingOption(cast(int)(f)); }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.FormattingOptions i, QUrl.ComponentFormattingOptions f)
{ return i | QUrl.UrlFormattingOption(cast(int)(f)); }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.ComponentFormattingOption f, QUrl.FormattingOptions i)
{ return i | QUrl.UrlFormattingOption(int(f)); }+/
/+pragma(inline, true) QUrl.FormattingOptions operator |(QUrl.ComponentFormattingOptions f, QUrl.FormattingOptions i)
{ return i | QUrl.UrlFormattingOption(cast(int)(f)); }+/

//inline QUrl::UrlFormattingOption &operator=(const QUrl::UrlFormattingOption &i, QUrl::ComponentFormattingOptions f)
//{ i = int(f); f; }
/+ #endif // Q_QDOC

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &, const QUrl &);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &, QUrl &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QUrl &);
#endif


#if QT_DEPRECATED_SINCE(5,0)
#endif +/

