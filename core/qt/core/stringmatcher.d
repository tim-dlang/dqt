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
module qt.core.stringmatcher;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.namespace;
import qt.core.qchar;
import qt.core.string;
import qt.core.stringview;
import qt.helpers;

extern(C++, class) struct QStringMatcherPrivate;

/// Binding for C++ class [QStringMatcher](https://doc.qt.io/qt-5/qstringmatcher.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QStringMatcher
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

    /+ explicit +/this(ref const(QString) pattern,
                       /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    this(const(QChar)* uc, int len,
                       /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    this(QStringView pattern,
                       /+ Qt:: +/qt.core.namespace.CaseSensitivity cs = /+ Qt:: +/qt.core.namespace.CaseSensitivity.CaseSensitive);
    @disable this(this);
    this(ref const(QStringMatcher) other);
    ~this();

    /+ref QStringMatcher operator =(ref const(QStringMatcher) other);+/

    void setPattern(ref const(QString) pattern);
    void setCaseSensitivity(/+ Qt:: +/qt.core.namespace.CaseSensitivity cs);

    int indexIn(ref const(QString) str, int from = 0) const;
    int indexIn(const(QChar)* str, int length, int from = 0) const;
    qsizetype indexIn(QStringView str, qsizetype from = 0) const;
    QString pattern() const;
    pragma(inline, true) /+ Qt:: +/qt.core.namespace.CaseSensitivity caseSensitivity() const { return q_cs; }

private:
    QStringMatcherPrivate* d_ptr;
    QString q_pattern;
    /+ Qt:: +/qt.core.namespace.CaseSensitivity q_cs;
    struct Data {
        uchar[256] q_skiptable;
        const(QChar)* uc;
        int len;
    }
    union {
        uint[256] q_data;
        Data p;
    }
}

