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
module qt.qml.jsengine;
extern(C++):

import qt.config;
import qt.core.flags;
import qt.core.metatype;
import qt.core.object;
import qt.core.objectdefs;
import qt.core.string;
import qt.core.stringlist;
import qt.core.variant;
import qt.helpers;
import qt.qml.jsmanagedvalue;
import qt.qml.jsvalue;

pragma(inline, true) T qjsvalue_cast(T)(ref const(QJSValue) );

extern(C++, class) struct QJSEnginePrivate;
/// Binding for C++ class [QJSEngine](https://doc.qt.io/qt-6/qjsengine.html).
class /+ Q_QML_EXPORT +/ QJSEngine
    : QObject
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QString uiLanguage READ uiLanguage WRITE setUiLanguage NOTIFY uiLanguageChanged) +/
public:
    this();
    /+ explicit +/this(QObject parent);
    ~this();

    final QJSValue globalObject() const;

    final QJSValue evaluate(ref const(QString) program, ref const(QString) fileName = globalInitVar!QString, int lineNumber = 1, QStringList* exceptionStackTrace = null);

    final QJSValue importModule(ref const(QString) fileName);
    final bool registerModule(ref const(QString) moduleName, ref const(QJSValue) value);

    final QJSValue newObject();
    final QJSValue newSymbol(ref const(QString) name);
    final QJSValue newArray(uint length = 0);

    final QJSValue newQObject(QObject object);

    final QJSValue newQMetaObject(const(QMetaObject)* metaObject);

    /+ template <typename T> +/
    final QJSValue newQMetaObject(T)()
    {
        return newQMetaObject(&T.staticMetaObject);
    }

    final QJSValue newErrorObject(QJSValue.ErrorType errorType, ref const(QString) message = globalInitVar!QString);

    /+ template <typename T> +/
    pragma(inline, true) final QJSValue toScriptValue(T)(ref const(T) value)
    {
        return create(QMetaType.fromType!(T)(), &value);
    }

    /+ template <typename T> +/
    pragma(inline, true) final QJSManagedValue toManagedValue(T)(ref const(T) value)
    {
        return createManaged(QMetaType.fromType!(T)(), &value);
    }

    /+ template <typename T> +/
    pragma(inline, true) final T fromScriptValue(T)(ref const(QJSValue) value)
    {
        return qjsvalue_cast!(T)(value);
    }

    /+ template <typename T> +/
    pragma(inline, true) final T fromManagedValue(T)(ref const(QJSManagedValue) value)
    {
        return qjsvalue_cast!(T)(value);
    }

    /+ template <typename T> +/
    pragma(inline, true) final T fromVariant(T)(ref const(QVariant) value)
    {
        static if (/+ std:: +/is_same_v!(T, QVariant))
            return value;

        const(QMetaType) targetType = QMetaType.fromType!(T)();
        if (value.metaType() == targetType)
            return *reinterpret_cast!(const(T)*)(value.constData());

        static if (/+ std:: +/is_same_v!(T,const(/+ std:: +/remove_const_t!(/+ std:: +/remove_pointer_t!(T)))*)) {
            alias nonConstT = /+ std:: +/remove_const_t!(/+ std:: +/remove_pointer_t!(T))*;
            const(QMetaType) nonConstTargetType = QMetaType.fromType!(nonConstT)();
            if (value.metaType() == nonConstTargetType)
                return *reinterpret_cast!(const(nonConstT)*)(value.constData());
        }

        {
            T t;
            if (convertVariant(value, targetType, &t))
                return t;

            QMetaType.convert(value.metaType(), value.constData(), targetType, &t);
            return t;
        }
    }

    final void collectGarbage();

    enum ObjectOwnership { CppOwnership, JavaScriptOwnership }
    static void setObjectOwnership(QObject , ObjectOwnership);
    static ObjectOwnership objectOwnership(QObject );

    enum Extension {
        TranslationExtension = 0x1,
        ConsoleExtension = 0x2,
        GarbageCollectionExtension = 0x4,
        AllExtensions = 0xffffffff
    }
    /+ Q_DECLARE_FLAGS(Extensions, Extension) +/
alias Extensions = QFlags!(Extension);
    final void installExtensions(Extensions extensions, ref const(QJSValue) object = globalInitVar!QJSValue);

    final void setInterrupted(bool interrupted);
    final bool isInterrupted() const;

    /+ QV4::ExecutionEngine *handle() const { return m_v4Engine; } +/

    final void throwError(ref const(QString) message);
    final void throwError(QJSValue.ErrorType errorType, ref const(QString) message = globalInitVar!QString);
    final void throwError(ref const(QJSValue) error);
    final bool hasError() const;
    final QJSValue catchError();

    final QString uiLanguage() const;
    final void setUiLanguage(ref const(QString) language);

/+ Q_SIGNALS +/public:
    @QSignal final void uiLanguageChanged();

private:
    final QJSManagedValue createManaged(QMetaType type, const(void)* ptr);
    /+ QJSValue create(QMetaType type, const void *ptr); +/
/+ #if QT_VERSION < QT_VERSION_CHECK(7,0,0) +/
    /+ QJSValue create(int id, const void *ptr); +/ // only there for BC reasons
/+ #endif +/

    static bool convertManaged(ref const(QJSManagedValue) value, int type, void* ptr);
    static bool convertManaged(ref const(QJSManagedValue) value, QMetaType type, void* ptr);
    static bool convertV2(ref const(QJSValue) value, int type, void* ptr);
    static bool convertV2(ref const(QJSValue) value, QMetaType metaType, void* ptr);
    final bool convertVariant(ref const(QVariant) value, QMetaType metaType, void* ptr);

    /+ template<typename T> +/
    /+ friend inline T qjsvalue_cast(const QJSValue &); +/

    /+ template<typename T> +/
    /+ friend inline T qjsvalue_cast(const QJSManagedValue &); +/

protected:
    this(ref QJSEnginePrivate dd, QObject parent = null);

private:
    /+ QV4:: +/qt.qml.jsvalue.ExecutionEngine* m_v4Engine;
    /+ Q_DISABLE_COPY(QJSEngine) +/
    /+ Q_DECLARE_PRIVATE(QJSEngine) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
/+pragma(inline, true) QFlags!(QJSEngine.Extensions.enum_type) operator |(QJSEngine.Extensions.enum_type f1, QJSEngine.Extensions.enum_type f2)nothrow{return QFlags!(QJSEngine.Extensions.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QJSEngine.Extensions.enum_type) operator |(QJSEngine.Extensions.enum_type f1, QFlags!(QJSEngine.Extensions.enum_type) f2)nothrow{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QJSEngine.Extensions.enum_type) operator &(QJSEngine.Extensions.enum_type f1, QJSEngine.Extensions.enum_type f2)nothrow{return QFlags!(QJSEngine.Extensions.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QJSEngine.Extensions.enum_type) operator &(QJSEngine.Extensions.enum_type f1, QFlags!(QJSEngine.Extensions.enum_type) f2)nothrow{return f2&f1;}+/
/+pragma(inline, true) QFlags!(QJSEngine.Extensions.enum_type) operator ^(QJSEngine.Extensions.enum_type f1, QJSEngine.Extensions.enum_type f2)nothrow{return QFlags!(QJSEngine.Extensions.enum_type)(f1)^f2;}+/
/+pragma(inline, true) QFlags!(QJSEngine.Extensions.enum_type) operator ^(QJSEngine.Extensions.enum_type f1, QFlags!(QJSEngine.Extensions.enum_type) f2)nothrow{return f2^f1;}+/
/+pragma(inline, true) void operator +(QJSEngine.Extensions.enum_type f1, QJSEngine.Extensions.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QJSEngine.Extensions.enum_type f1, QFlags!(QJSEngine.Extensions.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QJSEngine.Extensions.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(QJSEngine.Extensions.enum_type f1, QJSEngine.Extensions.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QJSEngine.Extensions.enum_type f1, QFlags!(QJSEngine.Extensions.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QJSEngine.Extensions.enum_type) f2)nothrow;+/
/+pragma(inline, true) void operator +(int f1, QJSEngine.Extensions.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator +(QJSEngine.Extensions.enum_type f1, int f2)nothrow;+/
/+pragma(inline, true) void operator -(int f1, QJSEngine.Extensions.enum_type f2)nothrow;+/
/+pragma(inline, true) void operator -(QJSEngine.Extensions.enum_type f1, int f2)nothrow;+/
static if (defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QJSEngine.Extensions operator ~(QJSEngine.Extensions.enum_type e)nothrow{return~QJSEngine.Extensions(e);}+/
/+pragma(inline, true) void operator |(QJSEngine.Extensions.enum_type f1, int f2)nothrow;+/
}
static if (!defined!"QT_TYPESAFE_FLAGS")
{
/+pragma(inline, true) QIncompatibleFlag operator |(QJSEngine.Extensions.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/
}

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QJSEngine::Extensions) +/
T qjsvalue_cast(T)(ref const(QJSValue) value)
{
    T t;
    if (QJSEngine.convertV2(value, QMetaType.fromType!(T)(), &t))
        return t;
    else if (value.isVariant())
        return qvariant_cast!(T)(value.toVariant());

    return T();
}

T qjsvalue_cast(T)(ref const(QJSManagedValue) value)
{
    {
        T t;
        if (QJSEngine.convertManaged(value, QMetaType.fromType!(T)(), &t))
            return t;
    }

    return qvariant_cast!(T)(value.toVariant());
}

/+ template <> +/
pragma(inline, true) QVariant qjsvalue_cast(ref const(QJSValue) value)
{
    return value.toVariant();
}

/+ template <> +/
pragma(inline, true) QVariant qjsvalue_cast(ref const(QJSManagedValue) value)
{
    return value.toVariant();
}

mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
/+ Q_QML_EXPORT +/ QJSEngine qjsEngine(const(QObject) );
}));

