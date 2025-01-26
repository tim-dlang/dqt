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
module qt.qml.jsmanagedvalue;
extern(C++):

import qt.config;
import qt.core.datetime;
import qt.core.global;
import qt.core.object;
import qt.core.objectdefs;
import qt.core.regularexpression;
import qt.core.string;
import qt.core.stringlist;
import qt.core.url;
import qt.core.variant;
import qt.helpers;
import qt.qml.jsengine;
import qt.qml.jsprimitivevalue;
import qt.qml.jsvalue;

extern(C++, "QV4") {
struct Value;
}

/// Binding for C++ class [QJSManagedValue](https://doc.qt.io/qt-6/qjsmanagedvalue.html).
extern(C++, class) struct /+ Q_QML_EXPORT +/ QJSManagedValue
{
private:
    /+ Q_DISABLE_COPY(QJSManagedValue) +/
@disable this(this);
/+this(ref const(QJSManagedValue));+//+ref QJSManagedValue operator =(ref const(QJSManagedValue));+/public:
    enum Type {
        Undefined,
        Boolean,
        Number,
        String,
        Object,
        Symbol,
        Function
    }

    /+ QJSManagedValue() = default; +/
    this(QJSValue value, QJSEngine engine);
    this(ref const(QJSPrimitiveValue) value, QJSEngine engine);
    this(ref const(QVariant) variant, QJSEngine engine);
    this(ref const(QString) string, QJSEngine engine);

    ~this();
    /+ QJSManagedValue(QJSManagedValue &&other); +/
    /+ QJSManagedValue &operator=(QJSManagedValue &&other); +/

    bool equals(ref const(QJSManagedValue) other) const;
    bool strictlyEquals(ref const(QJSManagedValue) other) const;

    QJSEngine engine() const;

    QJSManagedValue prototype() const;
    void setPrototype(ref const(QJSManagedValue) prototype);

    Type type() const;

    // Compatibility with QJSValue
    bool isUndefined() const { return type() == Type.Undefined; }
    bool isBoolean() const { return type() == Type.Boolean; }
    bool isNumber() const { return type() == Type.Number; }
    bool isString() const { return type() == Type.String; }
    bool isObject() const { return type() == Type.Object; }
    bool isSymbol() const { return type() == Type.Symbol; }
    bool isFunction() const { return type() == Type.Function; }

    // Special case of Number
    bool isInteger() const;

    // Selected special cases of Object
    bool isNull() const;
    bool isRegularExpression() const;
    bool isArray() const;
    bool isUrl() const;
    bool isVariant() const;
    bool isQObject() const;
    bool isQMetaObject() const;
    bool isDate() const;
    bool isError() const;
    bool isJsMetaType() const;

    // Native type transformations
    QString toString() const;
    double toNumber() const;
    bool toBoolean() const;

    // Variant-like type transformations
    QJSPrimitiveValue toPrimitive() const;
    QJSValue toJSValue() const;
    QVariant toVariant() const;

    // Special cases
    int toInteger() const;
    QRegularExpression toRegularExpression() const;
    QUrl toUrl() const;
    QObject toQObject() const;
    const(QMetaObject)* toQMetaObject() const;
    QDateTime toDateTime() const;

    // Properties of objects
    bool hasProperty(ref const(QString) name) const;
    bool hasOwnProperty(ref const(QString) name) const;
    QJSValue property(ref const(QString) name) const;
    void setProperty(ref const(QString) name, ref const(QJSValue) value);
    bool deleteProperty(ref const(QString) name);

    //  ### Qt 7 use qsizetype instead.
    // Array indexing
    bool hasProperty(quint32 arrayIndex) const;
    bool hasOwnProperty(quint32 arrayIndex) const;
    QJSValue property(quint32 arrayIndex) const;
    void setProperty(quint32 arrayIndex, ref const(QJSValue) value);
    bool deleteProperty(quint32 arrayIndex);

    // Calling functions
    /+ QJSValue call(const QJSValueList &arguments = {}) const; +/
    QJSValue callWithInstance(ref const(QJSValue) instance, ref const(QJSValueList) arguments /+ = {} +/) const;
    QJSValue callAsConstructor(ref const(QJSValueList) arguments /+ = {} +/) const;

    // JavaScript metatypes
    QJSManagedValue jsMetaType() const;
    QStringList jsMetaMembers() const;
    QJSManagedValue jsMetaInstantiate(ref const(QJSValueList) values /+ = {} +/) const;

private:
    /+ friend class QJSValue; +/
    /+ friend class QJSEngine; +/

    this(/+ QV4:: +/qt.qml.jsvalue.ExecutionEngine* engine);
    /+ QV4:: +/Value* d = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

