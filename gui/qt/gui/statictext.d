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
module qt.gui.statictext;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.namespace;
import qt.core.shareddata;
import qt.core.size;
import qt.core.string;
import qt.core.typeinfo;
import qt.gui.font;
import qt.gui.textoption;
import qt.gui.transform;
import qt.helpers;

extern(C++, class) struct QStaticTextPrivate;
/// Binding for C++ class [QStaticText](https://doc.qt.io/qt-5/qstatictext.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QStaticText
{
public:
    enum PerformanceHint {
        ModerateCaching,
        AggressiveCaching
    }

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    /+ explicit +/this(ref const(QString) text);
    @disable this(this);
    this(ref const(QStaticText) other);
    /+ QStaticText &operator=(QStaticText &&other) noexcept { swap(other); return *this; } +/
    /+ref QStaticText operator =(ref const(QStaticText) );+/
    ~this();

    /+ void swap(QStaticText &other) noexcept { qSwap(data, other.data); } +/

    void setText(ref const(QString) text);
    QString text() const;

    void setTextFormat(/+ Qt:: +/qt.core.namespace.TextFormat textFormat);
    /+ Qt:: +/qt.core.namespace.TextFormat textFormat() const;

    void setTextWidth(qreal textWidth);
    qreal textWidth() const;

    void setTextOption(ref const(QTextOption) textOption);
    QTextOption textOption() const;

    QSizeF size() const;

    void prepare(ref const(QTransform) matrix/* = globalInitVar!QTransform*/, ref const(QFont) font/* = globalInitVar!QFont*/);

    void setPerformanceHint(PerformanceHint performanceHint);
    PerformanceHint performanceHint() const;

    /+bool operator ==(ref const(QStaticText) ) const;+/
    /+bool operator !=(ref const(QStaticText) ) const;+/

private:
    void detach();

    QExplicitlySharedDataPointer!(QStaticTextPrivate) data;
    /+ friend class QStaticTextPrivate; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_SHARED(QStaticText)


Q_DECLARE_METATYPE(QStaticText) +/

