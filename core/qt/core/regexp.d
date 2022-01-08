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
module qt.core.regexp;
extern(C++):

import qt.config;
import qt.helpers;
version(QT_NO_REGEXP){}else
version(QT_NO_REGEXP_CAPTURE){}else
    import qt.core.stringlist;
version(QT_NO_REGEXP){}else
{
    import qt.core.metatype;
    import qt.core.namespace;
    import qt.core.string;
    import qt.core.typeinfo;
}

version(QT_NO_REGEXP){}else
{
}
version(QT_NO_REGEXP){}else
{



struct QRegExpPrivate;

/+ Q_CORE_EXPORT uint qHash(const QRegExp &key, uint seed = 0) noexcept; +/

/// Binding for C++ class [QRegExp](https://doc.qt.io/qt-5/qregexp.html).
@Q_MOVABLE_TYPE @(QMetaType.Type.QRegExp) extern(C++, class) struct /+ Q_CORE_EXPORT +/ QRegExp
{
public:
    enum PatternSyntax {
        RegExp,
        Wildcard,
        FixedString,
        RegExp2,
        WildcardUnix,
        W3CXmlSchema11 }
    enum CaretMode { CaretAtZero, CaretAtOffset, CaretWontMatch }

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ explicit +/this(ref const(QString) pattern, /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive,
                         PatternSyntax syntax = PatternSyntax.RegExp);
    @disable this(this);
    this(ref const(QRegExp) rx);
    ~this();
    /+ref QRegExp operator =(ref const(QRegExp) rx);+/
    /+ QRegExp &operator=(QRegExp &&other) noexcept { swap(other); return *this; } +/
    /+ void swap(QRegExp &other) noexcept { qSwap(priv, other.priv); } +/

    /+bool operator ==(ref const(QRegExp) rx) const;+/
    /+pragma(inline, true) bool operator !=(ref const(QRegExp) rx) const { return !operator==(rx); }+/

    bool isEmpty() const;
    bool isValid() const;
    QString pattern() const;
    void setPattern(ref const(QString) pattern);
    /+ Qt:: +/qt.core.namespace.CaseSensitivity caseSensitivity() const;
    void setCaseSensitivity(/+ Qt:: +/qt.core.namespace.CaseSensitivity cs);
    PatternSyntax patternSyntax() const;
    void setPatternSyntax(PatternSyntax syntax);

    bool isMinimal() const;
    void setMinimal(bool minimal);

    bool exactMatch(ref const(QString) str) const;

    int indexIn(ref const(QString) str, int offset = 0, CaretMode caretMode = CaretMode.CaretAtZero) const;
    int lastIndexIn(ref const(QString) str, int offset = -1, CaretMode caretMode = CaretMode.CaretAtZero) const;
    int matchedLength() const;
    version(QT_NO_REGEXP_CAPTURE){}else
    {
        int captureCount() const;
        QStringList capturedTexts() const;
        QStringList capturedTexts();
        QString cap(int nth = 0) const;
        QString cap(int nth = 0);
        int pos(int nth = 0) const;
        int pos(int nth = 0);
        QString errorString() const;
        QString errorString();
    }

    static QString escape(ref const(QString) str);

    /+ friend Q_CORE_EXPORT uint qHash(const QRegExp &key, uint seed) noexcept; +/

private:
    QRegExpPrivate* priv;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QRegExp, Q_MOVABLE_TYPE);

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &out, const QRegExp &regExp);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &in, QRegExp &regExp);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QRegExp &);
#endif +/


}
version(QT_NO_REGEXP)
{
extern(C++, class) struct QRegExp;
}


version(QT_NO_REGEXP){}else
{
}

