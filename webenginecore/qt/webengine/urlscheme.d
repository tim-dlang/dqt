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
module qt.webengine.urlscheme;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.flags;
import qt.core.metamacros;
import qt.core.shareddata;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct WebEngineContext;
}


extern(C++, class) struct QWebEngineUrlSchemePrivate;

extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineUrlScheme
{
    mixin(Q_GADGET);
public:
    enum /+ class +/ Syntax {
        HostPortAndUserInformation,
        HostAndPort,
        Host,
        Path,
    }

    enum SpecialPort {
        PortUnspecified = -1
    }

    enum Flag {
        SecureScheme = 0x1,
        LocalScheme = 0x2,
        LocalAccessAllowed = 0x4,
        NoAccessAllowed = 0x8,
        ServiceWorkersAllowed = 0x10,
        ViewSourceAllowed = 0x20,
        ContentSecurityPolicyIgnored = 0x40,
        CorsEnabled = 0x80,
    }
    /+ Q_DECLARE_FLAGS(Flags, Flag) +/
alias Flags = QFlags!(Flag);    /+ Q_FLAG(Flags) +/

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ explicit +/this(ref const(QByteArray) name);

    @disable this(this);
    this(ref const(QWebEngineUrlScheme) that);
    /+ref QWebEngineUrlScheme operator =(ref const(QWebEngineUrlScheme) that);+/

    /+ QWebEngineUrlScheme(QWebEngineUrlScheme &&that); +/
    /+ QWebEngineUrlScheme &operator=(QWebEngineUrlScheme &&that); +/

    ~this();

    /+bool operator ==(ref const(QWebEngineUrlScheme) that) const;+/
    /+bool operator !=(ref const(QWebEngineUrlScheme) that) const { return !(this == that); }+/

    QByteArray name() const;
    void setName(ref const(QByteArray) newValue);

    Syntax syntax() const;
    void setSyntax(Syntax newValue);

    int defaultPort() const;
    void setDefaultPort(int newValue);

    Flags flags() const;
    void setFlags(Flags newValue);

    static void registerScheme(ref const(QWebEngineUrlScheme) scheme);
    static QWebEngineUrlScheme schemeByName(ref const(QByteArray) name);

private:
    /+ friend QtWebEngineCore::WebEngineContext; +/
    static void lockSchemes();
    this(QWebEngineUrlSchemePrivate* d);
    QSharedDataPointer!(QWebEngineUrlSchemePrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QWebEngineUrlScheme.Flags.enum_type) operator |(QWebEngineUrlScheme.Flags.enum_type f1, QWebEngineUrlScheme.Flags.enum_type f2)/+noexcept+/{return QFlags!(QWebEngineUrlScheme.Flags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QWebEngineUrlScheme.Flags.enum_type) operator |(QWebEngineUrlScheme.Flags.enum_type f1, QFlags!(QWebEngineUrlScheme.Flags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QWebEngineUrlScheme.Flags.enum_type) operator &(QWebEngineUrlScheme.Flags.enum_type f1, QWebEngineUrlScheme.Flags.enum_type f2)/+noexcept+/{return QFlags!(QWebEngineUrlScheme.Flags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QWebEngineUrlScheme.Flags.enum_type) operator &(QWebEngineUrlScheme.Flags.enum_type f1, QFlags!(QWebEngineUrlScheme.Flags.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) void operator +(QWebEngineUrlScheme.Flags.enum_type f1, QWebEngineUrlScheme.Flags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QWebEngineUrlScheme.Flags.enum_type f1, QFlags!(QWebEngineUrlScheme.Flags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QWebEngineUrlScheme.Flags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QWebEngineUrlScheme.Flags.enum_type f1, QWebEngineUrlScheme.Flags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QWebEngineUrlScheme.Flags.enum_type f1, QFlags!(QWebEngineUrlScheme.Flags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QWebEngineUrlScheme.Flags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) QIncompatibleFlag operator |(QWebEngineUrlScheme.Flags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+pragma(inline, true) void operator +(int f1, QWebEngineUrlScheme.Flags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QWebEngineUrlScheme.Flags.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QWebEngineUrlScheme.Flags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QWebEngineUrlScheme.Flags.enum_type f1, int f2)/+noexcept+/;+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QWebEngineUrlScheme::Flags) +/
