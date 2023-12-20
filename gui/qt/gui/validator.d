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
version (QT_NO_VALIDATOR) {} else
{
    import qt.core.locale;
    import qt.core.object;
    import qt.core.regularexpression;
    import qt.core.string;
}

/+ #if QT_CONFIG(regularexpression)
#endif +/


version (QT_NO_VALIDATOR) {} else
{

extern(C++, class) struct QValidatorPrivate;

/// Binding for C++ class [QValidator](https://doc.qt.io/qt-6/qvalidator.html).
abstract class /+ Q_GUI_EXPORT +/ QValidator : QObject
{
    mixin(Q_OBJECT);
public:
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    /+ explicit +/this(QObject  parent = null);
    }));
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
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QObjectPrivate d, QObject parent);
    }));
    mixin(changeItaniumMangling(q{mangleConstructorBaseObject}, q{
    this(ref QValidatorPrivate d, QObject parent);
    }));

private:
    /+ Q_DISABLE_COPY(QValidator) +/
    /+ Q_DECLARE_PRIVATE(QValidator) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QIntValidator](https://doc.qt.io/qt-6/qintvalidator.html).
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
    final void setRange(int bottom, int top);

    final int bottom() const { return b; }
    final int top() const { return t; }
/+ Q_SIGNALS +/public:
    @QSignal final void bottomChanged(int bottom);
    @QSignal final void topChanged(int top);

private:
    /+ Q_DISABLE_COPY(QIntValidator) +/

    int b;
    int t;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

extern(C++, class) struct QDoubleValidatorPrivate;

/// Binding for C++ class [QDoubleValidator](https://doc.qt.io/qt-6/qdoublevalidator.html).
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

    final void setRange(double bottom, double top, int decimals = 0);
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
    @QSignal final void notationChanged(Notation notation);

private:
    /+ Q_DECLARE_PRIVATE(QDoubleValidator) +/
    /+ Q_DISABLE_COPY(QDoubleValidator) +/

    double b;
    double t;
    int dec;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #if QT_CONFIG(regularexpression) +/

extern(C++, class) struct QRegularExpressionValidatorPrivate;

/// Binding for C++ class [QRegularExpressionValidator](https://doc.qt.io/qt-6/qregularexpressionvalidator.html).
class /+ Q_GUI_EXPORT +/ QRegularExpressionValidator : QValidator
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QRegularExpression regularExpression READ regularExpression WRITE setRegularExpression NOTIFY regularExpressionChanged) +/

public:
    /+ explicit +/this(QObject parent = null);
    /+ explicit +/this(ref const(QRegularExpression) re, QObject parent = null);
    ~this();

    override QValidator.State validate(ref QString input, ref int pos) const;

    final QRegularExpression regularExpression() const;

public /+ Q_SLOTS +/:
    @QSlot final void setRegularExpression(ref const(QRegularExpression) re);

/+ Q_SIGNALS +/public:
    @QSignal final void regularExpressionChanged(ref const(QRegularExpression) re);

private:
    /+ Q_DISABLE_COPY(QRegularExpressionValidator) +/
    /+ Q_DECLARE_PRIVATE(QRegularExpressionValidator) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #endif +/ // QT_CONFIG(regularexpression)

}

version (QT_NO_VALIDATOR)
{
extern(C++, class) struct QValidator;
}


