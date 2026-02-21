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
import qt.core.object;
import qt.core.objectdefs;
import qt.core.string;
import qt.core.variant;
import qt.helpers;
import qt.qml.jsvalue;

pragma(inline, true) T qjsvalue_cast(T)(ref const(QJSValue) );

extern(C++, class) struct QJSEnginePrivate;
/// Binding for C++ class [QJSEngine](https://doc.qt.io/qt-5/qjsengine.html).
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

    final QJSValue evaluate(ref const(QString) program, ref const(QString) fileName = globalInitVar!QString, int lineNumber = 1);

    final QJSValue importModule(ref const(QString) fileName);

    final QJSValue newObject();
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
        import qt.core.metatype;

        return create(qMetaTypeId!(T)(), &value);
    }
    /+ template <typename T> +/
    pragma(inline, true) final T fromScriptValue(T)(ref const(QJSValue) value)
    {
        return qjsvalue_cast!(T)(value);
    }

    final void collectGarbage();

/+ #if QT_DEPRECATED_SINCE(5, 6) +/
    /+ QT_DEPRECATED +/ final void installTranslatorFunctions(ref const(QJSValue) object = globalInitVar!QJSValue);
/+ #endif +/

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

    final QString uiLanguage() const;
    final void setUiLanguage(ref const(QString) language);

/+ Q_SIGNALS +/public:
    @QSignal final void uiLanguageChanged();

private:
    /+ QJSValue create(int type, const void *ptr); +/

    static bool convertV2(ref const(QJSValue) value, int type, void* ptr);

    /+ friend inline bool qjsvalue_cast_helper(const QJSValue &, int, void *); +/

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
/+pragma(inline, true) QIncompatibleFlag operator |(QJSEngine.Extensions.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QJSEngine::Extensions) +/
pragma(inline, true) bool qjsvalue_cast_helper(ref const(QJSValue) value, int type, void* ptr)
{
    return QJSEngine.convertV2(value, type, ptr);
}

T qjsvalue_cast(T)(ref const(QJSValue) value)
{
    import qt.core.metatype;

    T t;
    const(int) id = qMetaTypeId!(T)();

    if (qjsvalue_cast_helper(value, id, &t))
        return t;
    else if (value.isVariant())
        return qvariant_cast!(T)(value.toVariant());

    return T();
}

/+ template <> +/
pragma(inline, true) QVariant qjsvalue_cast(ref const(QJSValue) value)
{
    return value.toVariant();
}

mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
/+ Q_QML_EXPORT +/ QJSEngine qjsEngine(const(QObject) );
}));

