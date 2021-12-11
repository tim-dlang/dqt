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
module qt.gui.validator;
extern(C++):

import qt.config;
import qt.helpers;
version(QT_NO_REGEXP){}else
version(QT_NO_VALIDATOR){}else
    import qt.core.regexp;
version(QT_NO_VALIDATOR){}else
{
    import qt.core.locale;
    import qt.core.object;
    import qt.core.regularexpression;
    import qt.core.string;
}

/+ #if QT_CONFIG(regularexpression)
#endif +/


version(QT_NO_VALIDATOR){}else
{

extern(C++, class) struct QValidatorPrivate;

/// Binding for C++ class [QValidator](https://doc.qt.io/qt-5/qvalidator.html).
class /+ Q_GUI_EXPORT +/ QValidator : QObject
{
    mixin(Q_OBJECT);
public:
    /+ explicit +/this(QObject  parent = null);
    ~this();

    enum State {
        Invalid,
        Intermediate,
        Acceptable
    }
    /+ Q_ENUM(State) +/

    final void setLocale(ref const(QLocale) locale);
    final QLocale locale() const;

    /+ virtual +/ abstract State validate(ref QString , ref int ) const;
    /+ virtual +/ void fixup(ref QString ) const;

/+ Q_SIGNALS +/public:
    @QSignal final void changed();

protected:
    this(ref QObjectPrivate d, QObject parent);
    this(ref QValidatorPrivate d, QObject parent);

private:
    /+ Q_DISABLE_COPY(QValidator) +/
    /+ Q_DECLARE_PRIVATE(QValidator) +/
}

/// Binding for C++ class [QIntValidator](https://doc.qt.io/qt-5/qintvalidator.html).
class /+ Q_GUI_EXPORT +/ QIntValidator : QValidator
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(int bottom READ bottom WRITE setBottom NOTIFY bottomChanged)
    Q_PROPERTY(int top READ top WRITE setTop NOTIFY topChanged) +/

public:
    /+ explicit +/this(QObject  parent = null);
    this(int bottom, int top, QObject parent = null);
    ~this();

    override QValidator.State validate(ref QString , ref int ) const;
    override void fixup(ref QString input) const;

    final void setBottom(int);
    final void setTop(int);
    /+ virtual +/ void setRange(int bottom, int top);

    final int bottom() const { return b; }
    final int top() const { return t; }
/+ Q_SIGNALS +/public:
    @QSignal final void bottomChanged(int bottom);
    @QSignal final void topChanged(int top);

private:
    /+ Q_DISABLE_COPY(QIntValidator) +/

    int b;
    int t;
}

version(QT_NO_REGEXP){}else
{

extern(C++, class) struct QDoubleValidatorPrivate;

/// Binding for C++ class [QDoubleValidator](https://doc.qt.io/qt-5/qdoublevalidator.html).
class /+ Q_GUI_EXPORT +/ QDoubleValidator : QValidator
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(double bottom READ bottom WRITE setBottom NOTIFY bottomChanged)
    Q_PROPERTY(double top READ top WRITE setTop NOTIFY topChanged)
    Q_PROPERTY(int decimals READ decimals WRITE setDecimals NOTIFY decimalsChanged)
    Q_PROPERTY(Notation notation READ notation WRITE setNotation NOTIFY notationChanged) +/

public:
    /+ explicit +/this(QObject  parent = null);
    this(double bottom, double top, int decimals, QObject parent = null);
    ~this();

    enum Notation {
        StandardNotation,
        ScientificNotation
    }
    /+ Q_ENUM(Notation) +/
    override QValidator.State validate(ref QString , ref int ) const;

    /+ virtual +/ void setRange(double bottom, double top, int decimals = 0);
    final void setBottom(double);
    final void setTop(double);
    final void setDecimals(int);
    final void setNotation(Notation);

    final double bottom() const { return b; }
    final double top() const { return t; }
    final int decimals() const { return dec; }
    final Notation notation() const;

/+ Q_SIGNALS +/public:
    @QSignal final void bottomChanged(double bottom);
    @QSignal final void topChanged(double top);
    @QSignal final void decimalsChanged(int decimals);
    @QSignal final void notationChanged(QDoubleValidator.Notation notation);

private:
    /+ Q_DECLARE_PRIVATE(QDoubleValidator) +/
    /+ Q_DISABLE_COPY(QDoubleValidator) +/

    double b;
    double t;
    int dec;
}


/// Binding for C++ class [QRegExpValidator](https://doc.qt.io/qt-5/qregexpvalidator.html).
class /+ Q_GUI_EXPORT +/ QRegExpValidator : QValidator
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QRegExp regExp READ regExp WRITE setRegExp NOTIFY regExpChanged) +/

public:
    /+ explicit +/this(QObject parent = null);
    /+ explicit +/this(ref const(QRegExp) rx, QObject parent = null);
    ~this();

    /+ virtual +/ override QValidator.State validate(ref QString input, ref int pos) const;

    final void setRegExp(ref const(QRegExp) rx);
    final ref const(QRegExp) regExp() const { return r; }

/+ Q_SIGNALS +/public:
    @QSignal final void regExpChanged(ref const(QRegExp) regExp);

private:
    /+ Q_DISABLE_COPY(QRegExpValidator) +/

    QRegExp r;
}

}

/+ #if QT_CONFIG(regularexpression) +/

extern(C++, class) struct QRegularExpressionValidatorPrivate;

/// Binding for C++ class [QRegularExpressionValidator](https://doc.qt.io/qt-5/qregularexpressionvalidator.html).
class /+ Q_GUI_EXPORT +/ QRegularExpressionValidator : QValidator
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QRegularExpression regularExpression READ regularExpression WRITE setRegularExpression NOTIFY regularExpressionChanged) +/

public:
    /+ explicit +/this(QObject parent = null);
    /+ explicit +/this(ref const(QRegularExpression) re, QObject parent = null);
    ~this();

    /+ virtual +/ override QValidator.State validate(ref QString input, ref int pos) const;

    final QRegularExpression regularExpression() const;

public /+ Q_SLOTS +/:
    @QSlot final void setRegularExpression(ref const(QRegularExpression) re);

/+ Q_SIGNALS +/public:
    @QSignal final void regularExpressionChanged(ref const(QRegularExpression) re);

private:
    /+ Q_DISABLE_COPY(QRegularExpressionValidator) +/
    /+ Q_DECLARE_PRIVATE(QRegularExpressionValidator) +/
}

/+ #endif +/ // QT_CONFIG(regularexpression)

}

version(QT_NO_VALIDATOR)
{
extern(C++, class) struct QValidator;
}


