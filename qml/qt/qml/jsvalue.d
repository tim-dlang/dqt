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
module qt.qml.jsvalue;
extern(C++):

import qt.config;
import qt.core.datetime;
import qt.core.global;
import qt.core.list;
import qt.core.metatype;
import qt.core.object;
import qt.core.objectdefs;
import qt.core.string;
import qt.core.variant;
import qt.helpers;
import qt.qml.jsengine;


alias QJSValueList = QList!(QJSValue);
extern(C++, "QV4") {
    struct ExecutionEngine;
    struct Value;
}

/// Binding for C++ class [QJSValue](https://doc.qt.io/qt-5/qjsvalue.html).
@Q_DECLARE_METATYPE extern(C++, class) struct /+ Q_QML_EXPORT +/ QJSValue
{
public:
    enum SpecialValue {
        NullValue,
        UndefinedValue
    }

    enum ErrorType {
        NoError,
        GenericError,
        EvalError,
        RangeError,
        ReferenceError,
        SyntaxError,
        TypeError,
        URIError
    }

public:
    this(SpecialValue value/+ = SpecialValue.UndefinedValue+/);
    ~this();
    @disable this(this);
    this(ref const(QJSValue) other);

/+ #ifdef Q_COMPILER_RVALUE_REFS +/
    /+ inline QJSValue(QJSValue && other) : d(other.d) { other.d = 0; } +/
    /+ inline QJSValue &operator=(QJSValue &&other)
    { qSwap(d, other.d); return *this; } +/
/+ #endif +/

    this(bool value);
    this(int value);
    this(uint value);
    this(double value);
    this(ref const(QString) value);
    this(ref const(QLatin1String) value);
/+ #ifndef QT_NO_CAST_FROM_ASCII
    QT_ASCII_CAST_WARN QJSValue(const char *str);
#endif +/

    /+ref QJSValue operator =(ref const(QJSValue) other);+/

    bool isBool() const;
    bool isNumber() const;
    bool isNull() const;
    bool isString() const;
    bool isUndefined() const;
    bool isVariant() const;
    bool isQObject() const;
    bool isQMetaObject() const;
    bool isObject() const;
    bool isDate() const;
    bool isRegExp() const;
    bool isArray() const;
    bool isError() const;

    QString toString() const;
    double toNumber() const;
    qint32 toInt() const;
    quint32 toUInt() const;
    bool toBool() const;
    QVariant toVariant() const;
    QObject toQObject() const;
    const(QMetaObject)* toQMetaObject() const;
    QDateTime toDateTime() const;

    bool equals(ref const(QJSValue) other) const;
    bool strictlyEquals(ref const(QJSValue) other) const;

    QJSValue prototype() const;
    void setPrototype(ref const(QJSValue) prototype);

    QJSValue property(ref const(QString) name) const;
    void setProperty(ref const(QString) name, ref const(QJSValue) value);

    bool hasProperty(ref const(QString) name) const;
    bool hasOwnProperty(ref const(QString) name) const;

    QJSValue property(quint32 arrayIndex) const;
    void setProperty(quint32 arrayIndex, ref const(QJSValue) value);

    bool deleteProperty(ref const(QString) name);

    bool isCallable() const;
    QJSValue call(ref const(QJSValueList) args = globalInitVar!QJSValueList); // ### Qt6: Make const
    QJSValue callWithInstance(ref const(QJSValue) instance, ref const(QJSValueList) args = globalInitVar!QJSValueList); // ### Qt6: Make const
    QJSValue callAsConstructor(ref const(QJSValueList) args = globalInitVar!QJSValueList); // ### Qt6: Make const

    ErrorType errorType() const;
/+ #ifdef QT_DEPRECATED +/
    /+ QT_DEPRECATED +/ QJSEngine engine() const;
/+ #endif +/

    this(/+ QV4:: +/ExecutionEngine* e, quint64 val);
private:
    /+ friend class QJSValuePrivate; +/
    // force compile error, prevent QJSValue(bool) to be called
    @disable this(void* ) /+ Q_DECL_EQ_DELETE +/;

    /+ mutable +/ quintptr d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}


/+ Q_DECLARE_METATYPE(QJSValue) +/

