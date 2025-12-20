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
module qt.webengine.findtextresult;
extern(C++):

import qt.config;
import qt.core.metamacros;
import qt.core.metatype;
import qt.core.shareddata;
import qt.helpers;

extern(C++, "QtWebEngineCore") {
extern(C++, class) struct FindTextHelper;
}


extern(C++, class) struct QWebEngineFindTextResultPrivate;

/// Binding for C++ class [QWebEngineFindTextResult](https://doc.qt.io/qt-6/qwebenginefindtextresult.html).
@Q_DECLARE_METATYPE extern(C++, class) struct /+ Q_WEBENGINECORE_EXPORT +/ QWebEngineFindTextResult
{
    mixin(Q_GADGET);
    /+ Q_PROPERTY(int numberOfMatches READ numberOfMatches CONSTANT FINAL)
    Q_PROPERTY(int activeMatch READ activeMatch CONSTANT FINAL) +/

public:
    int numberOfMatches() const;
    int activeMatch() const;

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    @disable this(this);
    this(ref const(QWebEngineFindTextResult) other);
    ref QWebEngineFindTextResult opAssign(ref const(QWebEngineFindTextResult) other);
    ~this();

private:
    this(int numberOfMatches, int activeMatch);

    QSharedDataPointer!(QWebEngineFindTextResultPrivate) d;

    /+ friend class QtWebEngineCore::FindTextHelper; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ Q_DECLARE_METATYPE(QWebEngineFindTextResult) +/

