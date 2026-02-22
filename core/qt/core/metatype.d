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
module qt.core.metatype;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.datastream;
import qt.core.flags;
import qt.core.global;
import qt.core.list;
import qt.core.object;
import qt.core.objectdefs;
import qt.core.typeinfo;
import qt.core.variant;
import qt.helpers;
import std.algorithm;
import std.traits;

/+ #ifndef QT_NO_QOBJECT
#endif
#ifdef Bool
#error qmetatype.h must be included before any header file that defines Bool
#endif


// from qcborcommon.h
enum class QCborSimpleType : quint8;


template <typename T>
inline int qMetaTypeId();
+/

struct BuiltinTypeInfo
{
    string typeName;
    int typeNameID;
    string realType;
    string dType;
}

// F is a tuple: (QMetaType::TypeName, QMetaType::TypeNameID, RealType)
// ### Qt6: reorder the types to match the C++ integral type ranking
enum immutable(BuiltinTypeInfo[]) primitiveTypes = [
    BuiltinTypeInfo("Void", 43, "void"),
    BuiltinTypeInfo("Bool", 1, "bool"),
    BuiltinTypeInfo("Int", 2, "int"),
    BuiltinTypeInfo("UInt", 3, "uint"),
    BuiltinTypeInfo("LongLong", 4, "qlonglong"),
    BuiltinTypeInfo("ULongLong", 5, "qulonglong"),
    BuiltinTypeInfo("Double", 6, "double"),
    BuiltinTypeInfo("Long", 32, "long"),
    BuiltinTypeInfo("Short", 33, "short"),
    BuiltinTypeInfo("Char", 34, "char"),
    BuiltinTypeInfo("ULong", 35, "ulong"),
    BuiltinTypeInfo("UShort", 36, "ushort"),
    BuiltinTypeInfo("UChar", 37, "uchar"),
    BuiltinTypeInfo("Float", 38, "float"),
    BuiltinTypeInfo("SChar", 40, "signed char", "byte"),
    BuiltinTypeInfo("Nullptr", 51, "std::nullptr_t", "typeof(null)"),
    BuiltinTypeInfo("QCborSimpleType", 52, "QCborSimpleType"),
];

enum immutable(BuiltinTypeInfo[]) primitivePointerTypes = [
    BuiltinTypeInfo("VoidStar", 31, "void*"),
];

/+ #if QT_CONFIG(easingcurve) +/
enum immutable(BuiltinTypeInfo[]) easingCurveTypes = [
    BuiltinTypeInfo("QEasingCurve", 29, "QEasingCurve"),
];
/+ #else
#define QT_FOR_EACH_STATIC_EASINGCURVE(F)
#endif +/

/+ #if QT_CONFIG(itemmodel) +/
enum immutable(BuiltinTypeInfo[]) itemModelClasses = [
    BuiltinTypeInfo("QModelIndex", 42, "QModelIndex"),
    BuiltinTypeInfo("QPersistentModelIndex", 50, "QPersistentModelIndex"),
];
/+ #else
#define QT_FOR_EACH_STATIC_ITEMMODEL_CLASS(F)
#endif +/

enum immutable(BuiltinTypeInfo[]) coreClasses = [
    BuiltinTypeInfo("QChar", 7, "QChar"),
    BuiltinTypeInfo("QString", 10, "QString"),
    BuiltinTypeInfo("QStringList", 11, "QStringList"),
    BuiltinTypeInfo("QByteArray", 12, "QByteArray"),
    BuiltinTypeInfo("QBitArray", 13, "QBitArray"),
    BuiltinTypeInfo("QDate", 14, "QDate"),
    BuiltinTypeInfo("QTime", 15, "QTime"),
    BuiltinTypeInfo("QDateTime", 16, "QDateTime"),
    BuiltinTypeInfo("QUrl", 17, "QUrl"),
    BuiltinTypeInfo("QLocale", 18, "QLocale"),
    BuiltinTypeInfo("QRect", 19, "QRect"),
    BuiltinTypeInfo("QRectF", 20, "QRectF"),
    BuiltinTypeInfo("QSize", 21, "QSize"),
    BuiltinTypeInfo("QSizeF", 22, "QSizeF"),
    BuiltinTypeInfo("QLine", 23, "QLine"),
    BuiltinTypeInfo("QLineF", 24, "QLineF"),
    BuiltinTypeInfo("QPoint", 25, "QPoint"),
    BuiltinTypeInfo("QPointF", 26, "QPointF"),
    BuiltinTypeInfo("QRegExp", 27, "QRegExp"),
] ~ easingCurveTypes ~ [
    BuiltinTypeInfo("QUuid", 30, "QUuid"),
    BuiltinTypeInfo("QVariant", 41, "QVariant"),
    BuiltinTypeInfo("QRegularExpression", 44, "QRegularExpression"),
    BuiltinTypeInfo("QJsonValue", 45, "QJsonValue"),
    BuiltinTypeInfo("QJsonObject", 46, "QJsonObject"),
    BuiltinTypeInfo("QJsonArray", 47, "QJsonArray"),
    BuiltinTypeInfo("QJsonDocument", 48, "QJsonDocument"),
    BuiltinTypeInfo("QCborValue", 53, "QCborValue"),
    BuiltinTypeInfo("QCborArray", 54, "QCborArray"),
    BuiltinTypeInfo("QCborMap", 55, "QCborMap"),
] ~ itemModelClasses;

enum immutable(BuiltinTypeInfo[]) corePointers = [
    BuiltinTypeInfo("QObjectStar", 39, "QObject*", "QObject"),
];

enum immutable(BuiltinTypeInfo[]) coreTemplates = [
    BuiltinTypeInfo("QVariantMap", 8, "QVariantMap"),
    BuiltinTypeInfo("QVariantList", 9, "QVariantList"),
    BuiltinTypeInfo("QVariantHash", 28, "QVariantHash"),
    BuiltinTypeInfo("QByteArrayList", 49, "QByteArrayList"),
];

enum immutable(BuiltinTypeInfo[]) guiClasses = [
    BuiltinTypeInfo("QFont", 64, "QFont"),
    BuiltinTypeInfo("QPixmap", 65, "QPixmap"),
    BuiltinTypeInfo("QBrush", 66, "QBrush"),
    BuiltinTypeInfo("QColor", 67, "QColor"),
    BuiltinTypeInfo("QPalette", 68, "QPalette"),
    BuiltinTypeInfo("QIcon", 69, "QIcon"),
    BuiltinTypeInfo("QImage", 70, "QImage"),
    BuiltinTypeInfo("QPolygon", 71, "QPolygon"),
    BuiltinTypeInfo("QRegion", 72, "QRegion"),
    BuiltinTypeInfo("QBitmap", 73, "QBitmap"),
    BuiltinTypeInfo("QCursor", 74, "QCursor"),
    BuiltinTypeInfo("QKeySequence", 75, "QKeySequence"),
    BuiltinTypeInfo("QPen", 76, "QPen"),
    BuiltinTypeInfo("QTextLength", 77, "QTextLength"),
    BuiltinTypeInfo("QTextFormat", 78, "QTextFormat"),
    BuiltinTypeInfo("QMatrix", 79, "QMatrix"),
    BuiltinTypeInfo("QTransform", 80, "QTransform"),
    BuiltinTypeInfo("QMatrix4x4", 81, "QMatrix4x4"),
    BuiltinTypeInfo("QVector2D", 82, "QVector2D"),
    BuiltinTypeInfo("QVector3D", 83, "QVector3D"),
    BuiltinTypeInfo("QVector4D", 84, "QVector4D"),
    BuiltinTypeInfo("QQuaternion", 85, "QQuaternion"),
    BuiltinTypeInfo("QPolygonF", 86, "QPolygonF"),
    BuiltinTypeInfo("QColorSpace", 87, "QColorSpace"),
];


enum immutable(BuiltinTypeInfo[]) widgetClasses = [
    BuiltinTypeInfo("QSizePolicy", 121, "QSizePolicy"),
];

/+
// ### FIXME kill that set
#define QT_FOR_EACH_STATIC_HACKS_TYPE(F)\
    F(QMetaTypeId2<qreal>::MetaType, -1, qreal)

// F is a tuple: (QMetaType::TypeName, QMetaType::TypeNameID, AliasingType, "RealType")
#define QT_FOR_EACH_STATIC_ALIAS_TYPE(F)\
    F(ULong, -1, ulong, "unsigned long") \
    F(UInt, -1, uint, "unsigned int") \
    F(UShort, -1, ushort, "unsigned short") \
    F(UChar, -1, uchar, "unsigned char") \
    F(LongLong, -1, qlonglong, "long long") \
    F(ULongLong, -1, qulonglong, "unsigned long long") \
    F(SChar, -1, signed char, "qint8") \
    F(UChar, -1, uchar, "quint8") \
    F(Short, -1, short, "qint16") \
    F(UShort, -1, ushort, "quint16") \
    F(Int, -1, int, "qint32") \
    F(UInt, -1, uint, "quint32") \
    F(LongLong, -1, qlonglong, "qint64") \
    F(ULongLong, -1, qulonglong, "quint64") \
    F(QVariantList, -1, QVariantList, "QList<QVariant>") \
    F(QVariantMap, -1, QVariantMap, "QMap<QString,QVariant>") \
    F(QVariantHash, -1, QVariantHash, "QHash<QString,QVariant>") \
    F(QByteArrayList, -1, QByteArrayList, "QList<QByteArray>") \
+/

enum immutable(BuiltinTypeInfo[]) allBuiltinTypes =
    primitiveTypes
    ~ primitivePointerTypes
    ~ coreClasses
    ~ corePointers
    ~ coreTemplates
    ~ guiClasses
    ~ widgetClasses;

/+
#define QT_DEFINE_METATYPE_ID(TypeName, Id, Name) \
    TypeName = Id,

#define QT_FOR_EACH_AUTOMATIC_TEMPLATE_1ARG(F) \
    F(QList) \
    F(QVector) \
    F(QQueue) \
    F(QStack) \
    F(QSet) \
    /*end*/

#define QT_FOR_EACH_AUTOMATIC_TEMPLATE_2ARG(F) \
    F(QHash, class) \
    F(QMap, class) \
    F(QPair, struct)

#define QT_FOR_EACH_AUTOMATIC_TEMPLATE_SMART_POINTER(F) \
    F(QSharedPointer) \
    F(QWeakPointer) \
    F(QPointer) +/
extern(C++, class) struct QMetaTypeInterface;

extern(C++, "QtPrivate")
{
/*!
    This template is used for implicit conversion from type From to type To.
    \internal
*/
To convertImplicit(From, To)(ref const(From) from)
{
    return from;
}

/+ #ifndef QT_NO_DEBUG_STREAM
struct AbstractDebugStreamFunction
{
    typedef void (*Stream)(const AbstractDebugStreamFunction *, QDebug&, const void *);
    typedef void (*Destroy)(AbstractDebugStreamFunction *);
    explicit AbstractDebugStreamFunction(Stream s = nullptr, Destroy d = nullptr)
        : stream(s), destroy(d) {}
    Q_DISABLE_COPY(AbstractDebugStreamFunction)
    Stream stream;
    Destroy destroy;
};

template<typename T>
struct BuiltInDebugStreamFunction : public AbstractDebugStreamFunction
{
    BuiltInDebugStreamFunction()
        : AbstractDebugStreamFunction(stream, destroy) {}
    static void stream(const AbstractDebugStreamFunction *, QDebug& dbg, const void *r)
    {
        const T *rhs = static_cast<const T *>(r);
        operator<<(dbg, *rhs);
    }

    static void destroy(AbstractDebugStreamFunction *_this)
    {
        delete static_cast<BuiltInDebugStreamFunction *>(_this);
    }
};
#endif +/

struct AbstractComparatorFunction
{
    alias LessThan = ExternCPPFunc!(bool function(const(AbstractComparatorFunction)* , const(void)* , const(void)* ));
    alias Equals = ExternCPPFunc!(bool function(const(AbstractComparatorFunction)* , const(void)* , const(void)* ));
    alias Destroy = ExternCPPFunc!(void function(AbstractComparatorFunction* ));
    @disable this();
    /+ explicit +/this(LessThan lt/+ = null+/, Equals e = null, Destroy d = null)
    {
        this.lessThan = lt;
        this.equals = e;
        this.destroy = d;
    }
    /+ Q_DISABLE_COPY(AbstractComparatorFunction) +/
@disable this(this);
/+@disable this(ref const(AbstractComparatorFunction));+/@disable ref AbstractComparatorFunction opAssign(ref const(AbstractComparatorFunction));    LessThan lessThan;
    Equals equals;
    Destroy destroy;
}

struct BuiltInComparatorFunction(T)
{
    public AbstractComparatorFunction base0;
    alias base0 this;
    @disable this();
    /+this()
    {
        this.base0 = AbstractComparatorFunction(lessThan, equals, destroy);
    }+/
    static bool lessThan(const(AbstractComparatorFunction)* , const(void)* l, const(void)* r)
    {
        const(T)* lhs = static_cast!(const(T)*)(l);
        const(T)* rhs = static_cast!(const(T)*)(r);
        return *lhs < *rhs;
    }

    static bool equals(const(AbstractComparatorFunction)* , const(void)* l, const(void)* r)
    {
        const(T)* lhs = static_cast!(const(T)*)(l);
        const(T)* rhs = static_cast!(const(T)*)(r);
        return *lhs == *rhs;
    }

    static void destroy(AbstractComparatorFunction* _this)
    {
        import core.stdcpp.new_;

        cpp_delete(static_cast!(BuiltInComparatorFunction*)(_this));
    }
}

struct BuiltInEqualsComparatorFunction(T)
{
    public AbstractComparatorFunction base0;
    alias base0 this;
    @disable this();
    /+this()
    {
        this.base0 = AbstractComparatorFunction(null, equals, destroy);
    }+/
    static bool equals(const(AbstractComparatorFunction)* , const(void)* l, const(void)* r)
    {
        const(T)* lhs = static_cast!(const(T)*)(l);
        const(T)* rhs = static_cast!(const(T)*)(r);
        return *lhs == *rhs;
    }

    static void destroy(AbstractComparatorFunction* _this)
    {
        import core.stdcpp.new_;

        cpp_delete(static_cast!(BuiltInEqualsComparatorFunction*)(_this));
    }
}

struct AbstractConverterFunction
{
    alias Converter = ExternCPPFunc!(bool function(const(AbstractConverterFunction)* , const(void)* , void*));
    @disable this();
    /+ explicit +/this(Converter c/+ = null+/)
    {
        this.convert = c;
    }
    /+ Q_DISABLE_COPY(AbstractConverterFunction) +/
@disable this(this);
/+@disable this(ref const(AbstractConverterFunction));+/@disable ref AbstractConverterFunction opAssign(ref const(AbstractConverterFunction));    Converter convert;
}

/+ template<typename From, typename To>
struct ConverterMemberFunction : public AbstractConverterFunction
{
    explicit ConverterMemberFunction(To(From::*function)() const)
        : AbstractConverterFunction(convert),
          m_function(function) {}
    ~ConverterMemberFunction();
    static bool convert(const AbstractConverterFunction *_this, const void *in, void *out)
    {
        const From *f = static_cast<const From *>(in);
        To *t = static_cast<To *>(out);
        const ConverterMemberFunction *_typedThis =
            static_cast<const ConverterMemberFunction *>(_this);
        *t = (f->*_typedThis->m_function)();
        return true;
    }

    To(From::* const m_function)() const;
};

template<typename From, typename To>
struct ConverterMemberFunctionOk : public AbstractConverterFunction
{
    explicit ConverterMemberFunctionOk(To(From::*function)(bool *) const)
        : AbstractConverterFunction(convert),
          m_function(function) {}
    ~ConverterMemberFunctionOk();
    static bool convert(const AbstractConverterFunction *_this, const void *in, void *out)
    {
        const From *f = static_cast<const From *>(in);
        To *t = static_cast<To *>(out);
        bool ok = false;
        const ConverterMemberFunctionOk *_typedThis =
            static_cast<const ConverterMemberFunctionOk *>(_this);
        *t = (f->*_typedThis->m_function)(&ok);
        if (!ok)
            *t = To();
        return ok;
    }

    To(From::* const m_function)(bool*) const;
};

template<typename From, typename To, typename UnaryFunction>
struct ConverterFunctor : public AbstractConverterFunction
{
    explicit ConverterFunctor(UnaryFunction function)
        : AbstractConverterFunction(convert),
          m_function(function) {}
    ~ConverterFunctor();
    static bool convert(const AbstractConverterFunction *_this, const void *in, void *out)
    {
        const From *f = static_cast<const From *>(in);
        To *t = static_cast<To *>(out);
        const ConverterFunctor *_typedThis =
            static_cast<const ConverterFunctor *>(_this);
        *t = _typedThis->m_function(*f);
        return true;
    }

    UnaryFunction m_function;
};

    template<typename T, bool>
    struct ValueTypeIsMetaType;
    template<typename T, bool>
    struct AssociativeValueTypeIsMetaType;
    template<typename T, bool>
    struct IsMetaTypePair;
    template<typename, typename>
    struct MetaTypeSmartPointerHelper; +/
}

/// Binding for C++ class [QMetaType](https://doc.qt.io/qt-5/qmetatype.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QMetaType {
private:
    enum ExtensionFlag { NoExtensionFlags,
                         CreateEx = 0x1, DestroyEx = 0x2,
                         ConstructEx = 0x4, DestructEx = 0x8,
                         NameEx = 0x10, SizeEx = 0x20,
                         CtorEx = 0x40, DtorEx = 0x80,
                         FlagsEx = 0x100, MetaObjectEx = 0x200
                       }
public:
/+ #ifndef Q_CLANG_QDOC +/
    // The code that actually gets compiled.
    extern(D) mixin((){
        import std.conv;
        string code = "enum Type {";
        // these are merged with QVariant
        /+ QT_FOR_EACH_STATIC_TYPE(QT_DEFINE_METATYPE_ID) +/
        foreach (t; allBuiltinTypes)
            code ~= text(t.typeName, " = ", t.typeNameID, ", ");
        code ~= q{
            FirstCoreType = Type.Bool,
            LastCoreType = Type.QCborMap,
            FirstGuiType = Type.QFont,
            LastGuiType = Type.QColorSpace,
            FirstWidgetsType = Type.QSizePolicy,
            LastWidgetsType = Type.QSizePolicy,
            HighestInternalId = Type.LastWidgetsType,

            QReal = qreal.sizeof == double.sizeof ? Type.Double : Type.Float,

            UnknownType = 0,
            User = 1024
        };
        code ~= "}";
        return code;
    }());
/+ #else
    // If we are using QDoc it fakes the Type enum looks like this.
    enum Type {
        UnknownType = 0, Bool = 1, Int = 2, UInt = 3, LongLong = 4, ULongLong = 5,
        Double = 6, Long = 32, Short = 33, Char = 34, ULong = 35, UShort = 36,
        UChar = 37, Float = 38,
        VoidStar = 31,
        QChar = 7, QString = 10, QStringList = 11, QByteArray = 12,
        QBitArray = 13, QDate = 14, QTime = 15, QDateTime = 16, QUrl = 17,
        QLocale = 18, QRect = 19, QRectF = 20, QSize = 21, QSizeF = 22,
        QLine = 23, QLineF = 24, QPoint = 25, QPointF = 26, QRegExp = 27,
        QEasingCurve = 29, QUuid = 30, QVariant = 41, QModelIndex = 42,
        QPersistentModelIndex = 50, QRegularExpression = 44,
        QJsonValue = 45, QJsonObject = 46, QJsonArray = 47, QJsonDocument = 48,
        QByteArrayList = 49, QObjectStar = 39, SChar = 40,
        Void = 43,
        Nullptr = 51,
        QVariantMap = 8, QVariantList = 9, QVariantHash = 28,
        QCborSimpleType = 52, QCborValue = 53, QCborArray = 54, QCborMap = 55,

        // Gui types
        QFont = 64, QPixmap = 65, QBrush = 66, QColor = 67, QPalette = 68,
        QIcon = 69, QImage = 70, QPolygon = 71, QRegion = 72, QBitmap = 73,
        QCursor = 74, QKeySequence = 75, QPen = 76, QTextLength = 77, QTextFormat = 78,
        QMatrix = 79, QTransform = 80, QMatrix4x4 = 81, QVector2D = 82,
        QVector3D = 83, QVector4D = 84, QQuaternion = 85, QPolygonF = 86, QColorSpace = 87,

        // Widget types
        QSizePolicy = 121,
        LastCoreType = QCborMap,
        LastGuiType = QColorSpace,
        User = 1024
    };
#endif +/

    enum TypeFlag {
        NeedsConstruction = 0x1,
        NeedsDestruction = 0x2,
        MovableType = 0x4,
        PointerToQObject = 0x8,
        IsEnumeration = 0x10,
        SharedPointerToQObject = 0x20,
        WeakPointerToQObject = 0x40,
        TrackingPointerToQObject = 0x80,
        WasDeclaredAsMetaType = 0x100,
        IsGadget = 0x200,
        PointerToGadget = 0x400
    }
    /+ Q_DECLARE_FLAGS(TypeFlags, TypeFlag) +/
alias TypeFlags = QFlags!(TypeFlag);
    alias Deleter = ExternCPPFunc!(void function(void* ));
    alias Creator = ExternCPPFunc!(void* function(const(void)* ));

/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    alias Destructor = ExternCPPFunc!(void function(void* ));
    alias Constructor = ExternCPPFunc!(void* function(void* , const(void)* )); // TODO Qt6: remove me
/+ #endif +/
    alias TypedDestructor = ExternCPPFunc!(void function(int, void* ));
    alias TypedConstructor = ExternCPPFunc!(void* function(int, void* , const(void)* ));

    alias SaveOperator = ExternCPPFunc!(void function(ref QDataStream , const(void)* ));
    alias LoadOperator = ExternCPPFunc!(void function(ref QDataStream , void* ));
    version (QT_NO_DATASTREAM) {} else
    {
        static void registerStreamOperators(const(char)* typeName, SaveOperator saveOp,
                                                LoadOperator loadOp);
        static void registerStreamOperators(int type, SaveOperator saveOp,
                                                LoadOperator loadOp);
    }
    static int registerType(const(char)* typeName, Deleter deleter,
                                Creator creator);
    static int registerType(const(char)* typeName, Deleter deleter,
                                Creator creator,
                                Destructor destructor,
                                Constructor constructor,
                                int size,
                                TypeFlags flags,
                                const(QMetaObject)* metaObject);
    static int registerType(const(char)* typeName,
                                TypedDestructor destructor,
                                TypedConstructor constructor,
                                int size,
                                TypeFlags flags,
                                const(QMetaObject)* metaObject);
    static bool unregisterType(int type);
    static int registerNormalizedType(/+ QT_PREPEND_NAMESPACE(QByteArray) +/ ref const(.QByteArray) normalizedTypeName, Deleter deleter,
                                Creator creator,
                                Destructor destructor,
                                Constructor constructor,
                                int size,
                                TypeFlags flags,
                                const(QMetaObject)* metaObject);
    static int registerNormalizedType(/+ QT_PREPEND_NAMESPACE(QByteArray) +/ ref const(.QByteArray) normalizedTypeName, Destructor destructor,
                                Constructor constructor,
                                int size,
                                TypeFlags flags,
                                const(QMetaObject)* metaObject);
    static int registerNormalizedType(/+ QT_PREPEND_NAMESPACE(QByteArray) +/ ref const(.QByteArray) normalizedTypeName, TypedDestructor destructor,
                                TypedConstructor constructor,
                                int size,
                                TypeFlags flags,
                                const(QMetaObject)* metaObject);
    static int registerTypedef(const(char)* typeName, int aliasId);
    static int registerNormalizedTypedef(/+ QT_PREPEND_NAMESPACE(QByteArray) +/ ref const(.QByteArray) normalizedTypeName, int aliasId);
    static int type(const(char)* typeName);

    static int type(/+ QT_PREPEND_NAMESPACE(QByteArray) +/ ref const(.QByteArray) typeName);
    static const(char)* typeName(int type);
    static int sizeOf(int type);
    static TypeFlags typeFlags(int type);
    static const(QMetaObject)* metaObjectForType(int type);
    static bool isRegistered(int type);
    mixin(mangleWindows("?create@QMetaType@@SAPEAXHPEBX@Z", q{
    static void *create(int type, const void *copy = null);
    }));
/+ #if QT_DEPRECATED_SINCE(5, 0)
    QT_DEPRECATED static void *construct(int type, const void *copy = nullptr)
    { return create(type, copy); }
#endif +/
    static void destroy(int type, void* data);
    static void* construct(int type, void* where, const(void)* copy);
    static void destruct(int type, void* where);

    version (QT_NO_DATASTREAM) {} else
    {
        static bool save(ref QDataStream stream, int type, const(void)* data);
        static bool load(ref QDataStream stream, int type, void* data);
    }

    @disable this();
    /+ explicit +/this(const(int) type/+ = Type.UnknownType+/); // ### Qt6: drop const
    pragma(inline, true) ~this()
    {
        if (/+ Q_UNLIKELY +/(isExtended(ExtensionFlag.DtorEx)))
            dtor();
    }

    pragma(inline, true) bool isValid() const
    {
        return m_typeId != Type.UnknownType;
    }
    pragma(inline, true) bool isRegistered() const
    {
        return isValid();
    }
    pragma(inline, true) int id() const
    {
        return m_typeId;
    }
    pragma(inline, true) int sizeOf() const
    {
        if (/+ Q_UNLIKELY +/(isExtended(ExtensionFlag.SizeEx)))
            return sizeExtended();
        return m_size;
    }
/+    pragma(inline, true) TypeFlags flags() const
    {
        if (/+ Q_UNLIKELY +/(isExtended(ExtensionFlag.FlagsEx)))
            return flagsExtended();
        return QMetaType.TypeFlags(cast(QFlag) (m_typeFlags));
    }
    pragma(inline, true) const(QMetaObject)* metaObject() const
    {
        if (/+ Q_UNLIKELY +/(isExtended(ExtensionFlag.MetaObjectEx)))
            return metaObjectExtended();
        return m_metaObject;
    }+/
    /+ QT_PREPEND_NAMESPACE(QByteArray) +/.QByteArray name() const;

    /+ inline void *create(const void *copy = nullptr) const; +/
    pragma(inline, true) void destroy(void* data) const
    {
        // ### TODO Qt6 remove the extension
        destroyExtended(data);
    }
    pragma(inline, true) void* construct(void* where, const(void)* copy = null) const
    {
        if (/+ Q_UNLIKELY +/(isExtended(ExtensionFlag.ConstructEx)))
            return constructExtended(where, copy);
        return m_constructor(where, copy);
    }
    pragma(inline, true) void destruct(void* data) const
    {
        if (/+ Q_UNLIKELY +/(isExtended(ExtensionFlag.DestructEx)))
            return destructExtended(data);
        if (/+ Q_UNLIKELY +/(!data))
            return;
        m_destructor(data);
    }

    /+ template<typename T> +/
    /+ static QMetaType fromType()
    { return QMetaType(qMetaTypeId<T>()); } +/

    /+ friend bool operator==(const QMetaType &a, const QMetaType &b)
    { return a.m_typeId == b.m_typeId; } +/

    /+ friend bool operator!=(const QMetaType &a, const QMetaType &b)
    { return a.m_typeId != b.m_typeId; } +/


public:
    /+ template<typename T> +/
    static bool registerComparators(T)()
    {
        mixin(Q_STATIC_ASSERT_X(q{(!QMetaTypeId2!(T).IsBuiltIn)},
                q{"QMetaType::registerComparators: The type must be a custom type."}));

        const(int) typeId = qMetaTypeId!(T)();
        extern(D) static __gshared const(/+ QtPrivate:: +/BuiltInComparatorFunction!(T)) f;
        return registerComparatorFunction( &f, typeId);
    }
    /+ template<typename T> +/
    static bool registerEqualsComparator(T)()
    {
        mixin(Q_STATIC_ASSERT_X(q{(!QMetaTypeId2!(T).IsBuiltIn)},
                q{"QMetaType::registerEqualsComparator: The type must be a custom type."}));
        const(int) typeId = qMetaTypeId!(T)();
        extern(D) static __gshared const(/+ QtPrivate:: +/BuiltInEqualsComparatorFunction!(T)) f;
        return registerComparatorFunction( &f, typeId);
    }

    /+ template<typename T> +/
    static bool hasRegisteredComparators(T)()
    {
        return hasRegisteredComparators(qMetaTypeId!(T)());
    }
    static bool hasRegisteredComparators(int typeId);


/+ #ifndef QT_NO_DEBUG_STREAM
    template<typename T>
    static bool registerDebugStreamOperator()
    {
        Q_STATIC_ASSERT_X((!QMetaTypeId2<T>::IsBuiltIn),
            "QMetaType::registerDebugStreamOperator: The type must be a custom type.");

        const int typeId = qMetaTypeId<T>();
        static const QtPrivate::BuiltInDebugStreamFunction<T> f;
        return registerDebugStreamOperatorFunction(&f, typeId);
    }
    template<typename T>
    static bool hasRegisteredDebugStreamOperator()
    {
        return hasRegisteredDebugStreamOperator(qMetaTypeId<T>());
    }
    static bool hasRegisteredDebugStreamOperator(int typeId);
#endif +/

    // implicit conversion supported like double -> float
    /+ template<typename From, typename To> +/
    /+ static bool registerConverter()
    {
        return registerConverter<From, To>(QtPrivate::convertImplicit<From, To>);
    } +/

/+ #ifdef Q_CLANG_QDOC
    template<typename MemberFunction, int>
    static bool registerConverter(MemberFunction function);
    template<typename MemberFunctionOk, char>
    static bool registerConverter(MemberFunctionOk function);
    template<typename UnaryFunction>
    static bool registerConverter(UnaryFunction function);
#else +/
    // member function as in "QString QFont::toString() const"
    /+ template<typename From, typename To> +/
    /+ static bool registerConverter(To(From::*function)() const)
    {
        Q_STATIC_ASSERT_X((!QMetaTypeId2<To>::IsBuiltIn || !QMetaTypeId2<From>::IsBuiltIn),
            "QMetaType::registerConverter: At least one of the types must be a custom type.");

        const int fromTypeId = qMetaTypeId<From>();
        const int toTypeId = qMetaTypeId<To>();
        static const QtPrivate::ConverterMemberFunction<From, To> f(function);
        return registerConverterFunction(&f, fromTypeId, toTypeId);
    } +/

    // member function as in "double QString::toDouble(bool *ok = nullptr) const"
    /+ template<typename From, typename To> +/
    /+ static bool registerConverter(To(From::*function)(bool*) const)
    {
        Q_STATIC_ASSERT_X((!QMetaTypeId2<To>::IsBuiltIn || !QMetaTypeId2<From>::IsBuiltIn),
            "QMetaType::registerConverter: At least one of the types must be a custom type.");

        const int fromTypeId = qMetaTypeId<From>();
        const int toTypeId = qMetaTypeId<To>();
        static const QtPrivate::ConverterMemberFunctionOk<From, To> f(function);
        return registerConverterFunction(&f, fromTypeId, toTypeId);
    } +/

    // functor or function pointer
    /+ template<typename From, typename To, typename UnaryFunction> +/
    /+ static bool registerConverter(UnaryFunction function)
    {
        Q_STATIC_ASSERT_X((!QMetaTypeId2<To>::IsBuiltIn || !QMetaTypeId2<From>::IsBuiltIn),
            "QMetaType::registerConverter: At least one of the types must be a custom type.");

        const int fromTypeId = qMetaTypeId<From>();
        const int toTypeId = qMetaTypeId<To>();
        static const QtPrivate::ConverterFunctor<From, To, UnaryFunction> f(function);
        return registerConverterFunction(&f, fromTypeId, toTypeId);
    } +/
/+ #endif +/

    static bool convert(const(void)* from, int fromTypeId, void* to, int toTypeId);
    static bool compare(const(void)* lhs, const(void)* rhs, int typeId, int* result);
    static bool equals(const(void)* lhs, const(void)* rhs, int typeId, int* result);
    /+ static bool debugStream(QDebug& dbg, const void *rhs, int typeId); +/

    /+ template<typename From, typename To> +/
    /+ static bool hasRegisteredConverterFunction()
    {
        return hasRegisteredConverterFunction(qMetaTypeId<From>(), qMetaTypeId<To>());
    } +/

    /+ static bool hasRegisteredConverterFunction(int fromTypeId, int toTypeId); +/

private:
    static QMetaType typeInfo(const(int) type);
    pragma(inline, true) this(const(ExtensionFlag) extensionFlags, const(QMetaTypeInterface)* info,
                         TypedConstructor creator,
                         TypedDestructor deleter,
                         SaveOperator saveOp,
                         LoadOperator loadOp,
                         Constructor constructor,
                         Destructor destructor,
                         uint size,
                         uint theTypeFlags,
                         int typeId,
                         const(QMetaObject)* _metaObject)
    {
        this.m_typedConstructor = creator;
        this.m_typedDestructor = deleter;
        this.m_saveOp = saveOp;
        this.m_loadOp = loadOp;
        this.m_constructor = constructor;
        this.m_destructor = destructor;
        this.m_extension = null;
        this.m_size = size;
        this.m_typeFlags = theTypeFlags;
        this.m_extensionFlags = extensionFlags;
        this.m_typeId = typeId;
        this.m_metaObject = _metaObject;

        if (/+ Q_UNLIKELY +/(isExtended(ExtensionFlag.CtorEx) || typeId == QMetaType.Type.Void))
            ctor(info);
    }
    @disable this(this);
    this(ref const(QMetaType) other);
    ref QMetaType opAssign(ref const(QMetaType) );
    pragma(inline, true) bool isExtended(const(ExtensionFlag) flag) const { return (m_extensionFlags & flag) != 0; }

    // Methods used for future binary compatible extensions
    void ctor(const(QMetaTypeInterface)* info);
    void dtor();
    uint sizeExtended() const;
    TypeFlags flagsExtended() const;
    const(QMetaObject)* metaObjectExtended() const;
    void* createExtended(const(void)* copy = null) const;
    void destroyExtended(void* data) const;
    void* constructExtended(void* where, const(void)* copy = null) const;
    void destructExtended(void* data) const;

    static bool registerComparatorFunction(const(/+ QtPrivate:: +/AbstractComparatorFunction)* f, int type);
/+ #ifndef QT_NO_DEBUG_STREAM
    static bool registerDebugStreamOperatorFunction(const QtPrivate::AbstractDebugStreamFunction *f, int type);
#endif

// ### Qt6: FIXME: Remove the special Q_CC_MSVC handling, it was introduced to maintain BC.
#if !defined(Q_NO_TEMPLATE_FRIENDS) && !defined(Q_CC_MSVC)
#ifndef Q_CLANG_QDOC +/
    /+ template<typename, bool> +/ /+ friend struct QtPrivate::ValueTypeIsMetaType; +/
    /+ template<typename, typename> +/ /+ friend struct QtPrivate::ConverterMemberFunction; +/
    /+ template<typename, typename> +/ /+ friend struct QtPrivate::ConverterMemberFunctionOk; +/
    /+ template<typename, typename, typename> +/ /+ friend struct QtPrivate::ConverterFunctor; +/
    /+ template<typename, bool> +/ /+ friend struct QtPrivate::AssociativeValueTypeIsMetaType; +/
    /+ template<typename, bool> +/ /+ friend struct QtPrivate::IsMetaTypePair; +/
    /+ template<typename, typename> +/ /+ friend struct QtPrivate::MetaTypeSmartPointerHelper; +/
/+ #endif
#else
public:
#endif +/
/*    static bool registerConverterFunction(const(/+ QtPrivate:: +/AbstractConverterFunction)* f, int from, int to);
    static void unregisterConverterFunction(int from, int to);*/
private:

    TypedConstructor m_typedConstructor;
    TypedDestructor m_typedDestructor;
    SaveOperator m_saveOp;
    LoadOperator m_loadOp;
    Constructor m_constructor;
    Destructor m_destructor;
    void* m_extension; // space reserved for future use
    uint m_size;
    uint m_typeFlags;
    uint m_extensionFlags;
    int m_typeId;
    const(QMetaObject)* m_metaObject;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #undef QT_DEFINE_METATYPE_ID +/
/+pragma(inline, true) QFlags!(QMetaType.TypeFlags.enum_type) operator |(QMetaType.TypeFlags.enum_type f1, QMetaType.TypeFlags.enum_type f2)nothrow{return QFlags!(QMetaType.TypeFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QMetaType.TypeFlags.enum_type) operator |(QMetaType.TypeFlags.enum_type f1, QFlags!(QMetaType.TypeFlags.enum_type) f2)nothrow{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QMetaType.TypeFlags.enum_type f1, int f2)nothrow{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QMetaType::TypeFlags)
namespace QtPrivate {

}

#define QT_METATYPE_PRIVATE_DECLARE_TYPEINFO(C, F)  \
    }                                               \
    Q_DECLARE_TYPEINFO(QtMetaTypePrivate:: C, (F)); \
    namespace QtMetaTypePrivate { +/

extern(C++, "QtMetaTypePrivate") {
struct QMetaTypeFunctionHelper(T, bool Accepted=true) {
    static void Destruct(void* t)
    {
        /+ Q_UNUSED(t) +/ // Silence MSVC that warns for POD types.
        static if (is(T == class))
            *static_cast!(T*)(t) = null;
        else
            destroy!false(*static_cast!(T*)(t));
    }

    static void* Construct(void* where, const(void)* t)
    {
        import core.lifetime;

        static if (is(T == class))
        {
            *static_cast!(T*)(where) = t ? *static_cast!(T*)(t) : null;
            return where;
        }
        else
        {
            if (t)
            {
                copyEmplace!T(*static_cast!(/*const*/T*)(t), *static_cast!(T*)(where));
                return where;
            }

            static if (is(T == struct) && __traits(hasMember, T, "rawConstructor"))
            {
                const void[] initSym = __traits(initSymbol, T);
                if (initSym.ptr !is null)
                    where[0 .. initSym.length] = initSym;
                else
                    (cast(ubyte*) where)[0 .. T.sizeof] = 0;
                (cast(T*) where).rawConstructor();
                return where;
            }
            else
                return emplace!T(cast(T*) where);
        }
    }
    /+ version (QT_NO_DATASTREAM) {} else
    {
        static void Save(ref QDataStream stream, const(void)* t)
        {
            stream << *static_cast!(const(T)*)(t);
        }

        static void Load(ref QDataStream stream, void* t)
        {
            stream >> *static_cast!(T*)(t);
        }
    }+/
}

/+ template <typename T>
struct QMetaTypeFunctionHelper<T, /* Accepted */ false> {
    static void Destruct(void *) {}
    static void *Construct(void *, const void *) { return nullptr; }
#ifndef QT_NO_DATASTREAM
    static void Save(QDataStream &, const void *) {}
    static void Load(QDataStream &, void *) {}
#endif // QT_NO_DATASTREAM
};
template <>
struct QMetaTypeFunctionHelper<void, /* Accepted */ true>
        : public QMetaTypeFunctionHelper<void, /* Accepted */ false>
{}; +/

struct VariantData
{
    this(const(int) metaTypeId_,
                    const(void)* data_,
                    const(uint) flags_)
    {
        this.metaTypeId = metaTypeId_;
        this.data = data_;
        this.flags = flags_;
    }
    @disable this(this);
    this(ref const(VariantData) other)
    {
        this.metaTypeId = other.metaTypeId;
        this.data = other.data;
        this.flags = other.flags;
    }
    const(int) metaTypeId;
    const(void)* data;
    const(uint) flags;
private:
    // copy constructor allowed to be implicit to silence level 4 warning from MSVC
    @disable ref VariantData opAssign(ref const(VariantData) );
}

struct IteratorOwnerCommon(const_iterator)
{
    static void assign(void** ptr, const_iterator iterator)
    {
        import core.stdcpp.new_;

        *ptr = cpp_new!const_iterator(iterator);
    }
    static void assign(void** ptr, const(void * )*  src)
    {
        import core.stdcpp.new_;

        *ptr = cpp_new!const_iterator(*static_cast!(const_iterator*)(*src));
    }

    static void advance(void** iterator, int step)
    {
        ref const_iterator it = *static_cast!(const_iterator*)(*iterator);
        /+ std:: +/advance(it, step);
    }

    static void destroy(void** ptr)
    {
        import core.stdcpp.new_;

        cpp_delete(static_cast!(const_iterator*)(*ptr));
    }

    static bool equal(const(void * )* it, const(void * )* other)
    {
        return *static_cast!(const_iterator*)(*it) == *static_cast!(const_iterator*)(*other);
    }
}

struct IteratorOwner(const_iterator)
{
    IteratorOwnerCommon!(const_iterator) base0;
    alias base0 this;
    static const(void)* getData(const(void * )* iterator)
    {
        return &**static_cast!(const_iterator*)(*iterator);
    }

    static const(void)* getData(const_iterator it)
    {
        return &*it;
    }
}

struct /+ Q_CORE_EXPORT +/ VectorBoolElements
{
  mixin(q{extern } ~ exportOnWindows ~ q{static __gshared const(bool) true_element;});
  mixin(q{extern } ~ exportOnWindows ~ q{static __gshared const(bool) false_element;});
}

/+ template<>
struct IteratorOwner<std::vector<bool>::const_iterator> : IteratorOwnerCommon<std::vector<bool>::const_iterator>
{
public:
    static const void *getData(void * const *iterator)
    {
        return **static_cast<std::vector<bool>::const_iterator*>(*iterator) ?
            &VectorBoolElements::true_element : &VectorBoolElements::false_element;
    }

    static const void *getData(const std::vector<bool>::const_iterator& it)
    {
        return *it ? &VectorBoolElements::true_element : &VectorBoolElements::false_element;
    }
};

template<typename value_type>
struct IteratorOwner<const value_type*>
{
private:
    // We need to disable typed overloads of assign() and getData() if the value_type
    // is void* to avoid overloads conflicts. We do it by injecting unaccessible Dummy
    // type as part of the overload signature.
    struct Dummy {};
    typedef typename std::conditional<std::is_same<value_type, void*>::value, Dummy, value_type>::type value_type_OR_Dummy;
public:
    static void assign(void **ptr, const value_type_OR_Dummy *iterator )
    {
        *ptr = const_cast<value_type*>(iterator);
    }
    static void assign(void **ptr, void * const * src)
    {
        *ptr = static_cast<value_type*>(*src);
    }

    static void advance(void **iterator, int step)
    {
        value_type *it = static_cast<value_type*>(*iterator);
        std::advance(it, step);
        *iterator = it;
    }

    static void destroy(void **)
    {
    }

    static const void *getData(void * const *iterator)
    {
        return *iterator;
    }

    static const void *getData(const value_type_OR_Dummy *it)
    {
        return it;
    }

    static bool equal(void * const *it, void * const *other)
    {
        return static_cast<value_type*>(*it) == static_cast<value_type*>(*other);
    }
}; +/

enum IteratorCapability
{
    ForwardCapability = 1,
    BiDirectionalCapability = 2,
    RandomAccessCapability = 4
}

enum ContainerCapability
{
    ContainerIsAppendable = 1
}

/+ template<typename Container, typename T = void>
struct ContainerCapabilitiesImpl
{
    enum {ContainerCapabilities = 0};
    using appendFunction = void(*)(const void *container, const void *newElement);
    static constexpr const appendFunction appendImpl = nullptr;
};

template<typename Container>
struct ContainerCapabilitiesImpl<Container, decltype(std::declval<Container>().push_back(std::declval<typename Container::value_type>()))>
{
    enum {ContainerCapabilities = ContainerIsAppendable};

    // The code below invokes undefined behavior if and only if the pointer passed into QSequentialIterableImpl
    // pointed to a const object to begin with
    static void appendImpl(const void *container, const void *value)
    { static_cast<Container *>(const_cast<void *>(container))->push_back(*static_cast<const typename Container::value_type *>(value)); }
}; +/

extern(C++, "QtPrivate") {
/+ namespace ContainerCapabilitiesMetaProgrammingHelper {
    template<typename... Ts>
    using void_t = void;
} +/
}
}

/+ template<typename Container>
struct ContainerCapabilitiesImpl<Container, QtPrivate::ContainerCapabilitiesMetaProgrammingHelper::void_t<decltype(std::declval<Container>().insert(std::declval<typename Container::value_type>())), decltype(std::declval<typename Container::value_type>() == std::declval<typename Container::value_type>())>>
{
    enum {ContainerCapabilities = ContainerIsAppendable};

    // The code below invokes undefined behavior if and only if the pointer passed into QSequentialIterableImpl
    // pointed to a const object to begin with
    static void appendImpl(const void *container, const void *value)
    { static_cast<Container *>(const_cast<void *>(container))->insert(*static_cast<const typename Container::value_type *>(value)); }
};

template<typename T, typename Category = typename std::iterator_traits<typename T::const_iterator>::iterator_category>
struct CapabilitiesImpl;

template<typename T>
struct CapabilitiesImpl<T, std::forward_iterator_tag>
{ enum { IteratorCapabilities = ForwardCapability }; };
template<typename T>
struct CapabilitiesImpl<T, std::bidirectional_iterator_tag>
{ enum { IteratorCapabilities = BiDirectionalCapability | ForwardCapability }; };
template<typename T>
struct CapabilitiesImpl<T, std::random_access_iterator_tag>
{ enum { IteratorCapabilities = RandomAccessCapability | BiDirectionalCapability | ForwardCapability }; };

template<typename T>
struct ContainerAPI : CapabilitiesImpl<T>
{
    static int size(const T *t) { return int(std::distance(t->begin(), t->end())); }
};

template<typename T>
struct ContainerAPI<QList<T> > : CapabilitiesImpl<QList<T> >
{ static int size(const QList<T> *t) { return t->size(); } };

template<typename T>
struct ContainerAPI<QVector<T> > : CapabilitiesImpl<QVector<T> >
{ static int size(const QVector<T> *t) { return t->size(); } };

template<typename T>
struct ContainerAPI<std::vector<T> > : CapabilitiesImpl<std::vector<T> >
{ static int size(const std::vector<T> *t) { return int(t->size()); } };

template<typename T>
struct ContainerAPI<std::list<T> > : CapabilitiesImpl<std::list<T> >
{ static int size(const std::list<T> *t) { return int(t->size()); } };

/*
 revision 0: _iteratorCapabilities is simply a uint, where the bits at _revision were never set
 revision 1: _iteratorCapabilties is treated as a bitfield, the remaining bits are used to introduce
             _revision, _containerCapabilities and _unused. The latter contains 21 bits that are
             not used yet
*/
class QSequentialIterableImpl
{
public:
    const void * _iterable;
    void *_iterator;
    int _metaType_id;
    uint _metaType_flags;
    uint _iteratorCapabilities;
    // Iterator capabilities looks actually like
    // uint _iteratorCapabilities:4;
    // uint _revision:3;
    // uint _containerCapabilities:4;
    // uint _unused:21;*/
    typedef int(*sizeFunc)(const void *p);
    typedef const void * (*atFunc)(const void *p, int);
    typedef void (*moveIteratorFunc)(const void *p, void **);
    enum Position { ToBegin, ToEnd };
    typedef void (*moveIteratorFunc2)(const void *p, void **, Position position);
    typedef void (*advanceFunc)(void **p, int);
    typedef VariantData (*getFunc)( void * const *p, int metaTypeId, uint flags);
    typedef void (*destroyIterFunc)(void **p);
    typedef bool (*equalIterFunc)(void * const *p, void * const *other);
    typedef void (*copyIterFunc)(void **, void * const *);
    typedef void(*appendFunction)(const void *container, const void *newElement);

    IteratorCapability iteratorCapabilities() {return static_cast<IteratorCapability>(_iteratorCapabilities & 0xF);}
    uint revision() {return _iteratorCapabilities >> 4 & 0x7;}
    uint containerCapabilities() {return _iteratorCapabilities >> 7 & 0xF;}

    sizeFunc _size;
    atFunc _at;
    union {
        moveIteratorFunc _moveToBegin;
        moveIteratorFunc2 _moveTo;
    };
    union {
        moveIteratorFunc _moveToEnd;
        appendFunction _append;
    };
    advanceFunc _advance;
    getFunc _get;
    destroyIterFunc _destroyIter;
    equalIterFunc _equalIter;
    copyIterFunc _copyIter;

    template<class T>
    static int sizeImpl(const void *p)
    { return ContainerAPI<T>::size(static_cast<const T*>(p)); }

    template<class T>
    static const void* atImpl(const void *p, int idx)
    {
        typename T::const_iterator i = static_cast<const T*>(p)->begin();
        std::advance(i, idx);
        return IteratorOwner<typename T::const_iterator>::getData(i);
    }

    template<class T>
    static void moveToBeginImpl(const void *container, void **iterator)
    { IteratorOwner<typename T::const_iterator>::assign(iterator, static_cast<const T*>(container)->begin()); }

    template<class T>
    static void moveToEndImpl(const void *container, void **iterator)
    { IteratorOwner<typename T::const_iterator>::assign(iterator, static_cast<const T*>(container)->end()); }

    template<class Container>
    static void moveToImpl(const void *container, void **iterator, Position position)
    {
        if (position == ToBegin)
            moveToBeginImpl<Container>(container, iterator);
        else
            moveToEndImpl<Container>(container, iterator);
    }

    template<class T>
    static VariantData getImpl(void * const *iterator, int metaTypeId, uint flags)
    { return VariantData(metaTypeId, IteratorOwner<typename T::const_iterator>::getData(iterator), flags); }

public:
    template<class T> QSequentialIterableImpl(const T*p)
      : _iterable(p)
      , _iterator(nullptr)
      , _metaType_id(qMetaTypeId<typename T::value_type>())
      , _metaType_flags(QTypeInfo<typename T::value_type>::isPointer)
      , _iteratorCapabilities(ContainerAPI<T>::IteratorCapabilities | (1 << 4) | (ContainerCapabilitiesImpl<T>::ContainerCapabilities << (4+3)))
      , _size(sizeImpl<T>)
      , _at(atImpl<T>)
      , _moveTo(moveToImpl<T>)
      , _append(ContainerCapabilitiesImpl<T>::appendImpl)
      , _advance(IteratorOwner<typename T::const_iterator>::advance)
      , _get(getImpl<T>)
      , _destroyIter(IteratorOwner<typename T::const_iterator>::destroy)
      , _equalIter(IteratorOwner<typename T::const_iterator>::equal)
      , _copyIter(IteratorOwner<typename T::const_iterator>::assign)
    {
    }

    QSequentialIterableImpl()
      : _iterable(nullptr)
      , _iterator(nullptr)
      , _metaType_id(QMetaType::UnknownType)
      , _metaType_flags(0)
      , _iteratorCapabilities(0 | (1 << 4) ) // no iterator capabilities, revision 1
      , _size(nullptr)
      , _at(nullptr)
      , _moveToBegin(nullptr)
      , _moveToEnd(nullptr)
      , _advance(nullptr)
      , _get(nullptr)
      , _destroyIter(nullptr)
      , _equalIter(nullptr)
      , _copyIter(nullptr)
    {
    }

    inline void moveToBegin() {
        if (revision() == 0)
            _moveToBegin(_iterable, &_iterator);
        else
            _moveTo(_iterable, &_iterator, ToBegin);
    }
    inline void moveToEnd() {
        if (revision() == 0)
            _moveToEnd(_iterable, &_iterator);
        else
            _moveTo(_iterable, &_iterator, ToEnd);
    }
    inline bool equal(const QSequentialIterableImpl&other) const { return _equalIter(&_iterator, &other._iterator); }
    inline QSequentialIterableImpl &advance(int i) {
      Q_ASSERT(i > 0 || _iteratorCapabilities & BiDirectionalCapability);
      _advance(&_iterator, i);
      return *this;
    }

    inline void append(const void *newElement) {
        if (containerCapabilities() & ContainerIsAppendable)
            _append(_iterable, newElement);
    }

    inline VariantData getCurrent() const { return _get(&_iterator, _metaType_id, _metaType_flags); }

    VariantData at(int idx) const
    { return VariantData(_metaType_id, _at(_iterable, idx), _metaType_flags); }

    int size() const { Q_ASSERT(_iterable); return _size(_iterable); }

    inline void destroyIter() { _destroyIter(&_iterator); }

    void copy(const QSequentialIterableImpl &other)
    {
      *this = other;
      _copyIter(&_iterator, &other._iterator);
    }
};
QT_METATYPE_PRIVATE_DECLARE_TYPEINFO(QSequentialIterableImpl, Q_MOVABLE_TYPE)
template<typename From>
struct QSequentialIterableConvertFunctor
{
    QSequentialIterableImpl operator()(const From &f) const
    {
        return QSequentialIterableImpl(&f);
    }
};
}

namespace QtMetaTypePrivate {

template<typename T, bool = std::is_same<typename T::const_iterator::value_type, typename T::mapped_type>::value>
struct AssociativeContainerAccessor
{
    static const typename T::key_type& getKey(const typename T::const_iterator &it)
    {
        return it.key();
    }

    static const typename T::mapped_type& getValue(const typename T::const_iterator &it)
    {
        return it.value();
    }
};

template<typename T, bool = std::is_same<typename T::const_iterator::value_type, std::pair<const typename T::key_type, typename T::mapped_type> >::value>
struct StlStyleAssociativeContainerAccessor;

template<typename T>
struct StlStyleAssociativeContainerAccessor<T, true>
{
    static const typename T::key_type& getKey(const typename T::const_iterator &it)
    {
        return it->first;
    }

    static const typename T::mapped_type& getValue(const typename T::const_iterator &it)
    {
        return it->second;
    }
};

template<typename T>
struct AssociativeContainerAccessor<T, false> : public StlStyleAssociativeContainerAccessor<T>
{
};

class QAssociativeIterableImpl
{
public:
    const void *_iterable;
    void *_iterator;
    int _metaType_id_key;
    uint _metaType_flags_key;
    int _metaType_id_value;
    uint _metaType_flags_value;
    typedef int(*sizeFunc)(const void *p);
    typedef void (*findFunc)(const void *container, const void *p, void **iterator);
    typedef void (*beginFunc)(const void *p, void **);
    typedef void (*advanceFunc)(void **p, int);
    typedef VariantData (*getFunc)(void * const *p, int metaTypeId, uint flags);
    typedef void (*destroyIterFunc)(void **p);
    typedef bool (*equalIterFunc)(void * const *p, void * const *other);
    typedef void (*copyIterFunc)(void **, void * const *);

    sizeFunc _size;
    findFunc _find;
    beginFunc _begin;
    beginFunc _end;
    advanceFunc _advance;
    getFunc _getKey;
    getFunc _getValue;
    destroyIterFunc _destroyIter;
    equalIterFunc _equalIter;
    copyIterFunc _copyIter;

    template<class T>
    static int sizeImpl(const void *p)
    { return int(std::distance(static_cast<const T*>(p)->begin(),
                               static_cast<const T*>(p)->end())); }

    template<class T>
    static void findImpl(const void *container, const void *p, void **iterator)
    { IteratorOwner<typename T::const_iterator>::assign(iterator,
                                                        static_cast<const T*>(container)->find(*static_cast<const typename T::key_type*>(p))); }

    QT_WARNING_PUSH
    QT_WARNING_DISABLE_DEPRECATED // Hits on the deprecated QHash::iterator::operator--()
    template<class T>
    static void advanceImpl(void **p, int step)
    { std::advance(*static_cast<typename T::const_iterator*>(*p), step); }
    QT_WARNING_POP

    template<class T>
    static void beginImpl(const void *container, void **iterator)
    { IteratorOwner<typename T::const_iterator>::assign(iterator, static_cast<const T*>(container)->begin()); }

    template<class T>
    static void endImpl(const void *container, void **iterator)
    { IteratorOwner<typename T::const_iterator>::assign(iterator, static_cast<const T*>(container)->end()); }

    template<class T>
    static VariantData getKeyImpl(void * const *iterator, int metaTypeId, uint flags)
    { return VariantData(metaTypeId, &AssociativeContainerAccessor<T>::getKey(*static_cast<typename T::const_iterator*>(*iterator)), flags); }

    template<class T>
    static VariantData getValueImpl(void * const *iterator, int metaTypeId, uint flags)
    { return VariantData(metaTypeId, &AssociativeContainerAccessor<T>::getValue(*static_cast<typename T::const_iterator*>(*iterator)), flags); }

public:
    template<class T> QAssociativeIterableImpl(const T*p)
      : _iterable(p)
      , _iterator(nullptr)
      , _metaType_id_key(qMetaTypeId<typename T::key_type>())
      , _metaType_flags_key(QTypeInfo<typename T::key_type>::isPointer)
      , _metaType_id_value(qMetaTypeId<typename T::mapped_type>())
      , _metaType_flags_value(QTypeInfo<typename T::mapped_type>::isPointer)
      , _size(sizeImpl<T>)
      , _find(findImpl<T>)
      , _begin(beginImpl<T>)
      , _end(endImpl<T>)
      , _advance(advanceImpl<T>)
      , _getKey(getKeyImpl<T>)
      , _getValue(getValueImpl<T>)
      , _destroyIter(IteratorOwner<typename T::const_iterator>::destroy)
      , _equalIter(IteratorOwner<typename T::const_iterator>::equal)
      , _copyIter(IteratorOwner<typename T::const_iterator>::assign)
    {
    }

    QAssociativeIterableImpl()
      : _iterable(nullptr)
      , _iterator(nullptr)
      , _metaType_id_key(QMetaType::UnknownType)
      , _metaType_flags_key(0)
      , _metaType_id_value(QMetaType::UnknownType)
      , _metaType_flags_value(0)
      , _size(nullptr)
      , _find(nullptr)
      , _begin(nullptr)
      , _end(nullptr)
      , _advance(nullptr)
      , _getKey(nullptr)
      , _getValue(nullptr)
      , _destroyIter(nullptr)
      , _equalIter(nullptr)
      , _copyIter(nullptr)
    {
    }

    inline void begin() { _begin(_iterable, &_iterator); }
    inline void end() { _end(_iterable, &_iterator); }
    inline bool equal(const QAssociativeIterableImpl&other) const { return _equalIter(&_iterator, &other._iterator); }
    inline QAssociativeIterableImpl &advance(int i) { _advance(&_iterator, i); return *this; }

    inline void destroyIter() { _destroyIter(&_iterator); }

    inline VariantData getCurrentKey() const { return _getKey(&_iterator, _metaType_id_key, _metaType_flags_key); }
    inline VariantData getCurrentValue() const { return _getValue(&_iterator, _metaType_id_value, _metaType_flags_value); }

    inline void find(const VariantData &key)
    { _find(_iterable, key.data, &_iterator); }

    int size() const { Q_ASSERT(_iterable); return _size(_iterable); }

    void copy(const QAssociativeIterableImpl &other)
    {
      *this = other;
      _copyIter(&_iterator, &other._iterator);
    }
};
QT_METATYPE_PRIVATE_DECLARE_TYPEINFO(QAssociativeIterableImpl, Q_MOVABLE_TYPE)

template<typename From>
struct QAssociativeIterableConvertFunctor
{
    QAssociativeIterableImpl operator()(const From& f) const
    {
        return QAssociativeIterableImpl(&f);
    }
};

class QPairVariantInterfaceImpl
{
    const void *_pair;
    int _metaType_id_first;
    uint _metaType_flags_first;
    int _metaType_id_second;
    uint _metaType_flags_second;

    typedef VariantData (*getFunc)(const void * const *p, int metaTypeId, uint flags);

    getFunc _getFirst;
    getFunc _getSecond;

    template<class T>
    static VariantData getFirstImpl(const void * const *pair, int metaTypeId, uint flags)
    { return VariantData(metaTypeId, &static_cast<const T*>(*pair)->first, flags); }
    template<class T>
    static VariantData getSecondImpl(const void * const *pair, int metaTypeId, uint flags)
    { return VariantData(metaTypeId, &static_cast<const T*>(*pair)->second, flags); }

public:
    template<class T> QPairVariantInterfaceImpl(const T*p)
      : _pair(p)
      , _metaType_id_first(qMetaTypeId<typename T::first_type>())
      , _metaType_flags_first(QTypeInfo<typename T::first_type>::isPointer)
      , _metaType_id_second(qMetaTypeId<typename T::second_type>())
      , _metaType_flags_second(QTypeInfo<typename T::second_type>::isPointer)
      , _getFirst(getFirstImpl<T>)
      , _getSecond(getSecondImpl<T>)
    {
    }

    QPairVariantInterfaceImpl()
      : _pair(nullptr)
      , _metaType_id_first(QMetaType::UnknownType)
      , _metaType_flags_first(0)
      , _metaType_id_second(QMetaType::UnknownType)
      , _metaType_flags_second(0)
      , _getFirst(nullptr)
      , _getSecond(nullptr)
    {
    }

    inline VariantData first() const { return _getFirst(&_pair, _metaType_id_first, _metaType_flags_first); }
    inline VariantData second() const { return _getSecond(&_pair, _metaType_id_second, _metaType_flags_second); }
};
QT_METATYPE_PRIVATE_DECLARE_TYPEINFO(QPairVariantInterfaceImpl, Q_MOVABLE_TYPE)
template<typename From>
struct QPairVariantInterfaceConvertFunctor;

template<typename T, typename U>
struct QPairVariantInterfaceConvertFunctor<QPair<T, U> >
{
    QPairVariantInterfaceImpl operator()(const QPair<T, U>& f) const
    {
        return QPairVariantInterfaceImpl(&f);
    }
};

template<typename T, typename U>
struct QPairVariantInterfaceConvertFunctor<std::pair<T, U> >
{
    QPairVariantInterfaceImpl operator()(const std::pair<T, U>& f) const
    {
        return QPairVariantInterfaceImpl(&f);
    }
};

}


#define QT_FORWARD_DECLARE_SHARED_POINTER_TYPES_ITER(Name) \
    template <class T> class Name; \


QT_FOR_EACH_AUTOMATIC_TEMPLATE_SMART_POINTER(QT_FORWARD_DECLARE_SHARED_POINTER_TYPES_ITER) +/
extern(C++, "QtPrivate")
{
    struct IsPointerToTypeDerivedFromQObject(T)
    {
        enum { Value = false }
    }

    // Specialize to avoid sizeof(void) warning
    /+ template<>
    struct IsPointerToTypeDerivedFromQObject<void*>
    {
        enum { Value = false };
    };
    template<>
    struct IsPointerToTypeDerivedFromQObject<const void*>
    {
        enum { Value = false };
    }; +/

    struct IsPointerToTypeDerivedFromQObject(T : QObject)
    {
        enum { Value = true }
    }

    /+ template<typename T>
    struct IsPointerToTypeDerivedFromQObject<T*>
    {
        typedef qint8 yes_type;
        typedef qint64 no_type;

#ifndef QT_NO_QOBJECT
        static yes_type checkType(QObject* );
#endif
        static no_type checkType(...);
        Q_STATIC_ASSERT_X(sizeof(T), "Type argument of Q_DECLARE_METATYPE(T*) must be fully defined");
        enum { Value = sizeof(checkType(static_cast<T*>(nullptr))) == sizeof(yes_type) };
    }; +/

    struct IsGadgetHelper(T) if (!__traits(hasMember, T, "QtGadgetHelper") || isPointer!T)
    {
        enum { IsRealGadget = false, IsGadgetOrDerivedFrom = false }
    }

    struct IsGadgetHelper(T) if (__traits(hasMember, T, "QtGadgetHelper") && !isPointer!T)
    {
        /*template <typename X>
        static char checkType(void (X::*)());
        static void *checkType(void (T::*)());*/
        enum {
            IsRealGadget = true, // sizeof(checkType(&T::qt_check_for_QGADGET_macro)) == sizeof(void *),
            IsGadgetOrDerivedFrom = true
        }
    }

    struct IsPointerToGadgetHelper(T) if (!__traits(hasMember, T, "QtGadgetHelper") || !isPointer!T)
    {
        enum { IsRealGadget = false, IsGadgetOrDerivedFrom = false }
    }

    struct IsPointerToGadgetHelper(T) if (__traits(hasMember, T, "QtGadgetHelper") && isPointer!T)
    {
        /*using BaseType = T;
        template <typename X>
        static char checkType(void (X::*)());
        static void *checkType(void (T::*)());*/
        enum {
            IsRealGadget = !IsPointerToTypeDerivedFromQObject!T.Value, // && sizeof(checkType(&T::qt_check_for_QGADGET_macro)) == sizeof(void *),
            IsGadgetOrDerivedFrom = !IsPointerToTypeDerivedFromQObject!T.Value
        }
    }

    /+ template<typename T> char qt_getEnumMetaObject(const T&); +/

    struct IsQEnumHelper(T) {
        static ref const(T) declval();
        // If the type was declared with Q_ENUM, the friend qt_getEnumMetaObject() declared in the
        // Q_ENUM macro will be chosen by ADL, and the return type will be QMetaObject*.
        // Otherwise the chosen overload will be the catch all template function
        // qt_getEnumMetaObject(T) which returns 'char'
        enum { Value = (qt_getEnumMetaObject(declval())). sizeof == (QMetaObject*).sizeof }
    }
    /+ template<> struct IsQEnumHelper<void> { enum { Value = false }; }; +/

    struct MetaObjectForType(T)
    {
        static const(QMetaObject) *value()
        {
            static if (is(T == void))
                return null;
            else static if (IsPointerToTypeDerivedFromQObject!T.Value)
                return &T.staticMetaObject;
            else static if (IsGadgetHelper!T.IsGadgetOrDerivedFrom)
                return &T.staticMetaObject;
            else static if (IsPointerToGadgetHelper!T.IsGadgetOrDerivedFrom)
                return &T.staticMetaObject;
            else static if (is(T == enum) && is(__traits(parent, T) == module) && __traits(getCppNamespaces, T).length == 1 && __traits(getCppNamespaces, T)[0] == "Qt")
                return qt_getQtMetaObject();
            else static if (is(T : QFlags!X, X) && is(__traits(parent, X) == module) && __traits(getCppNamespaces, X).length == 1 && __traits(getCppNamespaces, X)[0] == "Qt")
                return qt_getQtMetaObject();
            else static if (is(T == enum) && __traits(hasMember, __traits(parent, T), "staticMetaObject"))
                return &__traits(parent, T).staticMetaObject;
            else static if (is(T : QFlags!X2, X2) && __traits(hasMember, __traits(parent, X2), "staticMetaObject"))
                return &__traits(parent, X2).staticMetaObject;
            else
                return null;
        }
    }

    struct IsSharedPointerToTypeDerivedFromQObject(T)
    {
        enum { Value = false }
    }

    /+ template<typename T>
    struct IsSharedPointerToTypeDerivedFromQObject<QSharedPointer<T> > : IsPointerToTypeDerivedFromQObject<T*>
    {
    }; +/

    struct IsWeakPointerToTypeDerivedFromQObject(T)
    {
        enum { Value = false }
    }

    /+ template<typename T>
    struct IsWeakPointerToTypeDerivedFromQObject<QWeakPointer<T> > : IsPointerToTypeDerivedFromQObject<T*>
    {
    }; +/

    struct IsTrackingPointerToTypeDerivedFromQObject(T)
    {
        enum { Value = false }
    }

    /+ template<typename T>
    struct IsTrackingPointerToTypeDerivedFromQObject<QPointer<T> >
    {
        enum { Value = true };
    };

    template<typename T>
    struct IsSequentialContainer
    {
        enum { Value = false };
    };

    template<typename T>
    struct IsAssociativeContainer
    {
        enum { Value = false };
    };

    template<typename T, bool = QtPrivate::IsSequentialContainer<T>::Value>
    struct SequentialContainerConverterHelper
    {
        static bool registerConverter(int)
        {
            return false;
        }
    };

    template<typename T, bool = QMetaTypeId2<typename T::value_type>::Defined>
    struct ValueTypeIsMetaType
    {
        static bool registerConverter(int)
        {
            return false;
        }
    };

    template<typename T>
    struct SequentialContainerConverterHelper<T, true> : ValueTypeIsMetaType<T>
    {
    };

    template<typename T, bool = QtPrivate::IsAssociativeContainer<T>::Value>
    struct AssociativeContainerConverterHelper
    {
        static bool registerConverter(int)
        {
            return false;
        }
    };

    template<typename T, bool = QMetaTypeId2<typename T::mapped_type>::Defined>
    struct AssociativeValueTypeIsMetaType
    {
        static bool registerConverter(int)
        {
            return false;
        }
    };

    template<typename T, bool = QMetaTypeId2<typename T::key_type>::Defined>
    struct KeyAndValueTypeIsMetaType
    {
        static bool registerConverter(int)
        {
            return false;
        }
    };

    template<typename T>
    struct KeyAndValueTypeIsMetaType<T, true> : AssociativeValueTypeIsMetaType<T>
    {
    };

    template<typename T>
    struct AssociativeContainerConverterHelper<T, true> : KeyAndValueTypeIsMetaType<T>
    {
    };

    template<typename T, bool = QMetaTypeId2<typename T::first_type>::Defined
                                && QMetaTypeId2<typename T::second_type>::Defined>
    struct IsMetaTypePair
    {
        static bool registerConverter(int)
        {
            return false;
        }
    };

    template<typename T>
    struct IsMetaTypePair<T, true>
    {
        inline static bool registerConverter(int id);
    };

    template<typename T>
    struct IsPair
    {
        static bool registerConverter(int)
        {
            return false;
        }
    };
    template<typename T, typename U>
    struct IsPair<QPair<T, U> > : IsMetaTypePair<QPair<T, U> > {};
    template<typename T, typename U>
    struct IsPair<std::pair<T, U> > : IsMetaTypePair<std::pair<T, U> > {};

    template<typename T>
    struct MetaTypePairHelper : IsPair<T> {};

    template<typename T, typename = void>
    struct MetaTypeSmartPointerHelper
    {
        static bool registerConverter(int) { return false; }
    };

    Q_CORE_EXPORT bool isBuiltinType(const QByteArray &type); +/
} // namespace QtPrivate

extern(D) mixin((){
    import std.conv;
    string code = "template QMetaTypeId2(T)\n";
    code ~= "{\n";
    code ~= "    static if ((std.traits.isBuiltinType!T && !is(T == enum)) || is(T == void*))\n";
    code ~= "    {\n";
    bool needsElse = false;
    foreach (i, t; allBuiltinTypes)
    {
        string realType2 = t.realType;
        if (t.dType.length)
            realType2 = t.dType;
        if (realType2[0] != 'Q')
        {
            code ~= "        ";
            if(needsElse)
                code ~= "else ";
            code ~= text("static if (is(T == ", realType2, "))\n");
            code ~= "        {\n";
            code ~= text("            enum { Defined = 1, IsBuiltIn = true, MetaType = ", t.typeNameID, " };\n");
            code ~= text("            pragma(inline, true) static int qt_metatype_id() { return ", t.typeNameID, "; }\n");
            code ~= "        }\n";
            needsElse = true;
        }
    }
    code ~= "        else\n";
    code ~= "        {\n";
    code ~= "            enum { Defined = QMetaTypeId!(T).Defined, IsBuiltIn=false }\n";
    code ~= "            static if (Defined)\n";
    code ~= "                pragma(inline, true) static int qt_metatype_id() { return QMetaTypeId!(T).qt_metatype_id(); }\n";
    code ~= "        }\n";
    code ~= "    }\n";
    code ~= "    else\n";
    code ~= "    {\n";
    needsElse = false;
    code ~= "        static if (IsInQtPackage!T)\n";
    code ~= "        {\n";
    foreach (i, t; allBuiltinTypes)
    {
        string realType2 = t.realType;
        if (t.dType.length)
            realType2 = t.dType;
        if (realType2[0] == 'Q')
        {
            code ~= "            ";
            if(needsElse)
                code ~= "else ";
            code ~= text("static if (T.stringof == \"", realType2, "\")\n");
            code ~= "            {\n";
            code ~= text("                enum { Defined = 1, IsBuiltIn = true, MetaType = ", t.typeNameID, " };\n");
            code ~= text("                pragma(inline, true) static int qt_metatype_id() { return ", t.typeNameID, "; }\n");
            code ~= "            }\n";
            needsElse = true;
        }
    }
    code ~= "            else\n";
    code ~= "            {\n";
    code ~= "                enum { Defined = QMetaTypeId!(T).Defined, IsBuiltIn=false }\n";
    code ~= "                static if (Defined)\n";
    code ~= "                    pragma(inline, true) static int qt_metatype_id() { return QMetaTypeId!(T).qt_metatype_id(); }\n";
    code ~= "            }\n";
    code ~= "        }\n";
    code ~= "        else\n";
    code ~= "        {\n";
    code ~= "            enum { Defined = QMetaTypeId!(T).Defined, IsBuiltIn=false }\n";
    code ~= "            static if (Defined)\n";
    code ~= "                pragma(inline, true) static int qt_metatype_id() { return QMetaTypeId!(T).qt_metatype_id(); }\n";
    code ~= "        }\n";
    code ~= "    }\n";
    code ~= "}\n";
    return code;
}());

/+ template <typename T>
struct QMetaTypeId2<const T&> : QMetaTypeId2<T> {};

template <typename T>
struct QMetaTypeId2<T&> { enum {Defined = false }; }; +/

extern(C++, "QtPrivate") {
    struct QMetaTypeIdHelper(T) {
        static if (QMetaTypeId2!(T).Defined)
            pragma(inline, true) static int qt_metatype_id()
            { return QMetaTypeId2!(T).qt_metatype_id(); }
        else
            pragma(inline, true) static int qt_metatype_id()
            { return -1; }
    }
    // Function pointers don't derive from QObject
    /+ template <typename Result, typename... Args>
    struct IsPointerToTypeDerivedFromQObject<Result(*)(Args...)> { enum { Value = false }; }; +/

    struct QMetaTypeTypeFlags(T)
    {
        enum Flags = cast(QMetaType.TypeFlag)(
                       (QTypeInfoQuery!T.isRelocatable ? QMetaType.TypeFlag.MovableType : 0)
                     | (QTypeInfo!T.isComplex ? QMetaType.TypeFlag.NeedsConstruction : 0)
                     | (QTypeInfo!T.isComplex ? QMetaType.TypeFlag.NeedsDestruction : 0)
                     | (IsPointerToTypeDerivedFromQObject!T.Value ? QMetaType.TypeFlag.PointerToQObject : 0)
                     | (IsSharedPointerToTypeDerivedFromQObject!T.Value ? QMetaType.TypeFlag.SharedPointerToQObject : 0)
                     | (IsWeakPointerToTypeDerivedFromQObject!T.Value ? QMetaType.TypeFlag.WeakPointerToQObject : 0)
                     | (IsTrackingPointerToTypeDerivedFromQObject!T.Value ? QMetaType.TypeFlag.TrackingPointerToQObject : 0)
                     | (is(T == enum) ? QMetaType.TypeFlag.IsEnumeration : 0)
                     | (IsGadgetHelper!T.IsGadgetOrDerivedFrom ? QMetaType.TypeFlag.IsGadget : 0)
                     | (IsPointerToGadgetHelper!T.IsGadgetOrDerivedFrom ? QMetaType.TypeFlag.PointerToGadget : 0)
             );
    };

    struct MetaTypeDefinedHelper(T, bool defined)
    {
        enum DefinedType { Defined = defined }
    }

    struct QSmartPointerConvertFunctor(SmartPointer)
    {
        /+QObject operator ()(ref const(SmartPointer) p) const
        {
            return p.operator->();
        }+/
    }

    // hack to delay name lookup to instantiation time by making
    // EnableInternalData a dependent name:

    /+ template<typename T>
    struct QSmartPointerConvertFunctor<QWeakPointer<T> >
    {
        QObject* operator()(const QWeakPointer<T> &p) const
        {
            return QtPrivate::EnableInternalDataWrap<T>::internalData(p);
        }
    }; +/

}

extern(D) int qRegisterNormalizedMetaType(T)(/+ QT_PREPEND_NAMESPACE(QByteArray) +/ ref const(QByteArray) normalizedTypeName
/+ #ifndef Q_CLANG_QDOC +/
    , T*  dummy = null
    , /+ QtPrivate:: +/MetaTypeDefinedHelper!(T, QMetaTypeId2!(T).Defined && !QMetaTypeId2!(T).IsBuiltIn).DefinedType defined = /+ QtPrivate:: +/MetaTypeDefinedHelper!(T, QMetaTypeId2!(T).Defined && !QMetaTypeId2!(T).IsBuiltIn).DefinedType.Defined
/+ #endif +/
)
{
/+ #ifndef QT_NO_QOBJECT +/
    (mixin(Q_ASSERT_X(q{normalizedTypeName == QMetaObject.normalizedType(normalizedTypeName.constData())},q{ "qRegisterNormalizedMetaType"},q{ "qRegisterNormalizedMetaType was called with a not normalized type name, please call qRegisterMetaType instead."})));
/+ #endif +/
    const(int) typedefOf = dummy ? -1 : /+ QtPrivate:: +/QMetaTypeIdHelper!(T).qt_metatype_id();
    if (typedefOf != -1)
        return QMetaType.registerNormalizedTypedef(normalizedTypeName, typedefOf);

    auto flags = QMetaType.TypeFlags(/+ QtPrivate:: +/QMetaTypeTypeFlags!(T).Flags);

    if (defined)
        flags |= QMetaType.TypeFlag.WasDeclaredAsMetaType;

    const(int) id = QMetaType.registerNormalizedType(normalizedTypeName,
                                   &/+ QtMetaTypePrivate:: +/QMetaTypeFunctionHelper!(T).Destruct,
                                   &/+ QtMetaTypePrivate:: +/QMetaTypeFunctionHelper!(T).Construct,
                                   cast(int) (T.sizeof),
                                   flags,
                                   /+ QtPrivate:: +/MetaObjectForType!(T).value());

/+    if (id > 0) {
        /+ QtPrivate:: +/SequentialContainerConverterHelper!(T).registerConverter(id);
        /+ QtPrivate:: +/AssociativeContainerConverterHelper!(T).registerConverter(id);
        /+ QtPrivate:: +/MetaTypePairHelper!(T).IsPair.registerConverter(id);
        /+ QtPrivate:: +/MetaTypeSmartPointerHelper!(T).registerConverter(id);
    }+/

    return id;
}

extern(D) int qRegisterMetaType(T)(const(char)* typeName
/+ #ifndef Q_CLANG_QDOC +/
    , T*  dummy = null
    , /+ QtPrivate:: +/MetaTypeDefinedHelper!(T, QMetaTypeId2!(T).Defined && !QMetaTypeId2!(T).IsBuiltIn).DefinedType defined = /+ QtPrivate:: +/MetaTypeDefinedHelper!(T, QMetaTypeId2!(T).Defined && !QMetaTypeId2!(T).IsBuiltIn).DefinedType.Defined
/+ #endif +/
)
{
/+ #ifdef QT_NO_QOBJECT
    QT_PREPEND_NAMESPACE(QByteArray) normalizedTypeName = typeName;
#else +/
    /+ QT_PREPEND_NAMESPACE(QByteArray) +/QByteArray normalizedTypeName = QMetaObject.normalizedType(typeName);
/+ #endif +/
    return qRegisterNormalizedMetaType!(T)(normalizedTypeName, dummy, defined);
}

/+ #ifndef QT_NO_DATASTREAM
template <typename T>
void qRegisterMetaTypeStreamOperators(const char *typeName
#ifndef Q_CLANG_QDOC
    , T * /* dummy */ = nullptr
#endif
)
{
    qRegisterMetaType<T>(typeName);
    QMetaType::registerStreamOperators(typeName, QtMetaTypePrivate::QMetaTypeFunctionHelper<T>::Save,
                                                 QtMetaTypePrivate::QMetaTypeFunctionHelper<T>::Load);
}
#endif +/ // QT_NO_DATASTREAM

pragma(inline, true) int qMetaTypeId(T)()
{
    static assert(QMetaTypeId2!(T).Defined, "Type is not registered, please use the Q_DECLARE_METATYPE macro to make it known to Qt's meta-object system");
    return QMetaTypeId2!(T).qt_metatype_id();
}

pragma(inline, true) int qRegisterMetaType(T)()
{
    return qMetaTypeId!(T)();
}

/+ #if QT_DEPRECATED_SINCE(5, 1) && !defined(Q_CLANG_QDOC) +/
// There used to be a T *dummy = 0 argument in Qt 4.0 to support MSVC6
/+ QT_DEPRECATED +/ pragma(inline, true) int qMetaTypeId(T)(T* )
{ return qMetaTypeId!(T)(); }
/+ #ifndef Q_CC_SUN +/
/+ QT_DEPRECATED +/ pragma(inline, true) int qRegisterMetaType(T)(T* )
{ return qRegisterMetaType!(T)(); }
/+ #endif +/
/+ #endif

#ifndef QT_NO_QOBJECT +/

struct QMetaTypeIdQObject(T)
{
    static if (IsPointerToTypeDerivedFromQObject!T.Value)
    {
        enum {
            Defined = 1
        }

        static int qt_metatype_id()
        {
            import core.stdc.string;
            import qt.core.basicatomic;
            static QBasicAtomicInt metatype_id = QBasicAtomicInt(0);
            if (const int id = metatype_id.loadAcquire())
                return id;
            QByteArray typeName = QByteArray(typenameHelper!T().ptr);
            const int newId = qRegisterNormalizedMetaType!(T)(
                            typeName,
                            reinterpret_cast!(T*)(quintptr(-1)));
            metatype_id.storeRelease(newId);
            return newId;
        }
    }
    else static if (IsGadgetHelper!T.IsRealGadget)
    {
        enum {
            Defined = 1 //std::is_default_constructible<T>::value
        }

        static int qt_metatype_id()
        {
            import qt.core.basicatomic;
            static QBasicAtomicInt metatype_id = QBasicAtomicInt(0);
            if (const int id = metatype_id.loadAcquire())
                return id;
            QByteArray cNameB = QByteArray(typenameHelper!T().ptr);
            const int newId = qRegisterNormalizedMetaType!(T)(
                cNameB,
                reinterpret_cast!(T*)(quintptr(-1)));
            metatype_id.storeRelease(newId);
            return newId;
        }
    }
    else static if (IsPointerToGadgetHelper!T.IsRealGadget)
    {
        enum {
            Defined = 1
        }

        static int qt_metatype_id()
        {
            import core.stdc.string;
            import qt.core.basicatomic;
            static QBasicAtomicInt metatype_id = QBasicAtomicInt(0);
            if (const int id = metatype_id.loadAcquire())
                return id;
            QByteArray typeName = QByteArray(typenameHelper!T().ptr);
            const int newId = qRegisterNormalizedMetaType!(T)(
                typeName,
                reinterpret_cast!(T*)(quintptr(-1)));
            metatype_id.storeRelease(newId);
            return newId;
        }
    }
    else static if (is(T == enum) || is(T : QFlags!X, X))
    {
        enum {
            Defined = 1
        }

        static int qt_metatype_id()
        {
            import core.stdc.string;
            import qt.core.basicatomic;
            static QBasicAtomicInt metatype_id = QBasicAtomicInt(0);
            if (const int id = metatype_id.loadAcquire())
                return id;
            QByteArray typeName = QByteArray(typenameHelper!T().ptr);
            const int newId = qRegisterNormalizedMetaType!(T)(
                typeName,
                reinterpret_cast!(T*)(quintptr(-1)));
            metatype_id.storeRelease(newId);
            return newId;
        }
    }
    else
    {
        enum {
            Defined = 0
        }
    }
}
/+ #endif

#ifndef QT_NO_DATASTREAM
template <typename T>
inline int qRegisterMetaTypeStreamOperators()
{
    int id = qMetaTypeId<T>();
    QMetaType::registerStreamOperators(id, QtMetaTypePrivate::QMetaTypeFunctionHelper<T>::Save,
                                           QtMetaTypePrivate::QMetaTypeFunctionHelper<T>::Load);
    return id;
}
#endif

#define Q_DECLARE_OPAQUE_POINTER(POINTER)                               \
    QT_BEGIN_NAMESPACE namespace QtPrivate {                            \
        template <>                                                     \
        struct IsPointerToTypeDerivedFromQObject<POINTER >              \
        {                                                               \
            enum { Value = false };                                     \
        };                                                              \
    } QT_END_NAMESPACE                                                  \
    /**/
+/

enum Q_DECLARE_METATYPE;

struct QMetaTypeId(TYPE) if (getUDAs!(TYPE, Q_DECLARE_METATYPE).length == 0)
{
    enum Defined = QMetaTypeIdQObject!TYPE.Defined;
    static if (Defined)
        alias qt_metatype_id = QMetaTypeIdQObject!TYPE.qt_metatype_id;
}

struct QMetaTypeId(TYPE) if (getUDAs!(TYPE, Q_DECLARE_METATYPE).length > 0)
{
    enum { Defined = 1 }
    static int qt_metatype_id()
    {
        import qt.core.basicatomic;
        static QBasicAtomicInt metatype_id = QBasicAtomicInt(0);
        if (const int id = metatype_id.loadAcquire())
            return id;
        const int newId = qRegisterMetaType!(TYPE)(typenameHelper!TYPE().ptr,
                      reinterpret_cast!(TYPE *)(quintptr(-1)));
        metatype_id.storeRelease(newId);
        return newId;
    }
}

/+ #define Q_DECLARE_BUILTIN_METATYPE(TYPE, METATYPEID, NAME) \
    QT_BEGIN_NAMESPACE \
    template<> struct QMetaTypeId2<NAME> \
    { \
        enum { Defined = 1, IsBuiltIn = true, MetaType = METATYPEID };   \
        static inline Q_DECL_CONSTEXPR int qt_metatype_id() { return METATYPEID; } \
    }; \
    QT_END_NAMESPACE

#define QT_FORWARD_DECLARE_STATIC_TYPES_ITER(TypeName, TypeId, Name) \
    class Name;


QT_FOR_EACH_STATIC_CORE_CLASS(QT_FORWARD_DECLARE_STATIC_TYPES_ITER) +/
extern(C++, class) struct QMatrix4x4;
extern(C++, class) struct QQuaternion;
/+ QT_FOR_EACH_STATIC_GUI_CLASS(QT_FORWARD_DECLARE_STATIC_TYPES_ITER)
QT_FOR_EACH_STATIC_WIDGETS_CLASS(QT_FORWARD_DECLARE_STATIC_TYPES_ITER)
#undef QT_FORWARD_DECLARE_STATIC_TYPES_ITER +/

alias QVariantList = QList!(QVariant);
/+ typedef QMap<QString, QVariant> QVariantMap;
typedef QHash<QString, QVariant> QVariantHash;
#ifdef Q_CLANG_QDOC
class QByteArrayList;
#else
#endif

#define Q_DECLARE_METATYPE_TEMPLATE_1ARG(SINGLE_ARG_TEMPLATE)
QT_BEGIN_NAMESPACE \ +/
struct QMetaTypeId(X : C!T, alias C, T) if (is(const(X) == const(C!T)) && __traits(identifier, C) != "QFlags")
{
    enum Defined = QMetaTypeId2!T.Defined;
    static int qt_metatype_id()
    {
        import qt.core.basicatomic;
        static QBasicAtomicInt metatype_id = QBasicAtomicInt(0);
        if (const int id = metatype_id.loadRelaxed())
            return id;
        QByteArray typeName = QByteArray(typenameHelper!X().ptr);
        const int newId = qRegisterNormalizedMetaType!(C!T)(
                        typeName,
                        reinterpret_cast!(C!T*)(quintptr(-1)));
        metatype_id.storeRelease(newId);
        return newId;
    }
}
/+ namespace QtPrivate { \
template<typename T> \
struct IsSequentialContainer<SINGLE_ARG_TEMPLATE<T> > \
{ \
    enum { Value = true }; \
}; \
} \
QT_END_NAMESPACE +/

/+#define Q_DECLARE_METATYPE_TEMPLATE_2ARG(DOUBLE_ARG_TEMPLATE) \
QT_BEGIN_NAMESPACE \ +/
struct QMetaTypeId(X : C!(T, U), alias C, T, U) if (is(const(X) == const(C!(T, U))))
{
    enum Defined = QMetaTypeId2!T.Defined && QMetaTypeId2!U.Defined;
    static int qt_metatype_id()
    {
        import qt.core.basicatomic;
        static QBasicAtomicInt metatype_id = QBasicAtomicInt(0);
        if (const int id = metatype_id.loadAcquire())
            return id;
        QByteArray typeName = QByteArray(typenameHelper!X().ptr);
        const int newId = qRegisterNormalizedMetaType!(C!(T, U))(
                        typeName,
                        reinterpret_cast!(C!(T, U)*)(quintptr(-1)));
        metatype_id.storeRelease(newId);
        return newId;
    }
}
/+QT_END_NAMESPACE

namespace QtPrivate {

template<typename T, bool /* isSharedPointerToQObjectDerived */ = false>
struct SharedPointerMetaTypeIdHelper
{
    enum {
        Defined = 0
    };
    static int qt_metatype_id()
    {
        return -1;
    }
};

}

#define Q_DECLARE_SMART_POINTER_METATYPE(SMART_POINTER) \
QT_BEGIN_NAMESPACE \
namespace QtPrivate { \
template<typename T> \
struct SharedPointerMetaTypeIdHelper<SMART_POINTER<T>, true> \
{ \
    enum { \
        Defined = 1 \
    }; \
    static int qt_metatype_id() \
    { \
        static QBasicAtomicInt metatype_id = Q_BASIC_ATOMIC_INITIALIZER(0); \
        if (const int id = metatype_id.loadAcquire()) \
            return id; \
        const char * const cName = T::staticMetaObject.className(); \
        QByteArray typeName; \
        typeName.reserve(int(sizeof(#SMART_POINTER) + 1 + strlen(cName) + 1)); \
        typeName.append(#SMART_POINTER, int(sizeof(#SMART_POINTER)) - 1) \
            .append('<').append(cName).append('>'); \
        const int newId = qRegisterNormalizedMetaType< SMART_POINTER<T> >( \
                        typeName, \
                        reinterpret_cast< SMART_POINTER<T> *>(quintptr(-1))); \
        metatype_id.storeRelease(newId); \
        return newId; \
    } \
}; \
template<typename T> \
struct MetaTypeSmartPointerHelper<SMART_POINTER<T> , \
        typename std::enable_if<IsPointerToTypeDerivedFromQObject<T*>::Value>::type> \
{ \
    static bool registerConverter(int id) \
    { \
        const int toId = QMetaType::QObjectStar; \
        if (!QMetaType::hasRegisteredConverterFunction(id, toId)) { \
            QtPrivate::QSmartPointerConvertFunctor<SMART_POINTER<T> > o; \
            static const QtPrivate::ConverterFunctor<SMART_POINTER<T>, \
                                    QObject*, \
                                    QSmartPointerConvertFunctor<SMART_POINTER<T> > > f(o); \
            return QMetaType::registerConverterFunction(&f, id, toId); \
        } \
        return true; \
    } \
}; \
} \
template <typename T> \
struct QMetaTypeId< SMART_POINTER<T> > \
    : QtPrivate::SharedPointerMetaTypeIdHelper< SMART_POINTER<T>, \
                                                QtPrivate::IsPointerToTypeDerivedFromQObject<T*>::Value> \
{ \
};\
QT_END_NAMESPACE

#define Q_DECLARE_SEQUENTIAL_CONTAINER_METATYPE_ITER(TEMPLATENAME) \
    QT_BEGIN_NAMESPACE \
    template <class T> class TEMPLATENAME; \
    QT_END_NAMESPACE \
    Q_DECLARE_METATYPE_TEMPLATE_1ARG(TEMPLATENAME)



QT_FOR_EACH_AUTOMATIC_TEMPLATE_1ARG(Q_DECLARE_SEQUENTIAL_CONTAINER_METATYPE_ITER)
#undef Q_DECLARE_SEQUENTIAL_CONTAINER_METATYPE_ITER

#define Q_DECLARE_SEQUENTIAL_CONTAINER_METATYPE Q_DECLARE_METATYPE_TEMPLATE_1ARG

Q_DECLARE_SEQUENTIAL_CONTAINER_METATYPE(std::vector)
Q_DECLARE_SEQUENTIAL_CONTAINER_METATYPE(std::list)

#define Q_FORWARD_DECLARE_METATYPE_TEMPLATE_2ARG_ITER(TEMPLATENAME, CPPTYPE) \
    QT_BEGIN_NAMESPACE \
    template <class T1, class T2> CPPTYPE TEMPLATENAME; \
    QT_END_NAMESPACE \


QT_FOR_EACH_AUTOMATIC_TEMPLATE_2ARG(Q_FORWARD_DECLARE_METATYPE_TEMPLATE_2ARG_ITER)
#undef Q_DECLARE_METATYPE_TEMPLATE_2ARG_ITER

#define Q_DECLARE_ASSOCIATIVE_CONTAINER_METATYPE(TEMPLATENAME) \
    QT_BEGIN_NAMESPACE \
    namespace QtPrivate { \
    template<typename T, typename U> \
    struct IsAssociativeContainer<TEMPLATENAME<T, U> > \
    { \
        enum { Value = true }; \
    }; \
    } \
    QT_END_NAMESPACE \
    Q_DECLARE_METATYPE_TEMPLATE_2ARG(TEMPLATENAME)


Q_DECLARE_ASSOCIATIVE_CONTAINER_METATYPE(QHash)
Q_DECLARE_ASSOCIATIVE_CONTAINER_METATYPE(QMap)
Q_DECLARE_ASSOCIATIVE_CONTAINER_METATYPE(std::map)
Q_DECLARE_METATYPE_TEMPLATE_2ARG(QPair)
Q_DECLARE_METATYPE_TEMPLATE_2ARG(std::pair)

#define Q_DECLARE_METATYPE_TEMPLATE_SMART_POINTER_ITER(TEMPLATENAME) \
    Q_DECLARE_SMART_POINTER_METATYPE(TEMPLATENAME)



QT_FOR_EACH_AUTOMATIC_TEMPLATE_SMART_POINTER(Q_DECLARE_METATYPE_TEMPLATE_SMART_POINTER_ITER)

#undef Q_DECLARE_METATYPE_TEMPLATE_SMART_POINTER_ITER

inline void *QMetaType::create(const void *copy) const
{
    // ### TODO Qt6 remove the extension
    return createExtended(copy);
}



QT_FOR_EACH_STATIC_TYPE(Q_DECLARE_BUILTIN_METATYPE)

Q_DECLARE_METATYPE(QtMetaTypePrivate::QSequentialIterableImpl)
Q_DECLARE_METATYPE(QtMetaTypePrivate::QAssociativeIterableImpl)
Q_DECLARE_METATYPE(QtMetaTypePrivate::QPairVariantInterfaceImpl)


template <typename T>
inline bool QtPrivate::IsMetaTypePair<T, true>::registerConverter(int id)
{
    const int toId = qMetaTypeId<QtMetaTypePrivate::QPairVariantInterfaceImpl>();
    if (!QMetaType::hasRegisteredConverterFunction(id, toId)) {
        QtMetaTypePrivate::QPairVariantInterfaceConvertFunctor<T> o;
        static const QtPrivate::ConverterFunctor<T,
                                    QtMetaTypePrivate::QPairVariantInterfaceImpl,
                                    QtMetaTypePrivate::QPairVariantInterfaceConvertFunctor<T> > f(o);
        return QMetaType::registerConverterFunction(&f, id, toId);
    }
    return true;
}

namespace QtPrivate {
    template<typename T>
    struct ValueTypeIsMetaType<T, true>
    {
        static bool registerConverter(int id)
        {
            const int toId = qMetaTypeId<QtMetaTypePrivate::QSequentialIterableImpl>();
            if (!QMetaType::hasRegisteredConverterFunction(id, toId)) {
                QtMetaTypePrivate::QSequentialIterableConvertFunctor<T> o;
                static const QtPrivate::ConverterFunctor<T,
                        QtMetaTypePrivate::QSequentialIterableImpl,
                QtMetaTypePrivate::QSequentialIterableConvertFunctor<T> > f(o);
                return QMetaType::registerConverterFunction(&f, id, toId);
            }
            return true;
        }
    };

    template<typename T>
    struct AssociativeValueTypeIsMetaType<T, true>
    {
        static bool registerConverter(int id)
        {
            const int toId = qMetaTypeId<QtMetaTypePrivate::QAssociativeIterableImpl>();
            if (!QMetaType::hasRegisteredConverterFunction(id, toId)) {
                QtMetaTypePrivate::QAssociativeIterableConvertFunctor<T> o;
                static const QtPrivate::ConverterFunctor<T,
                                            QtMetaTypePrivate::QAssociativeIterableImpl,
                                            QtMetaTypePrivate::QAssociativeIterableConvertFunctor<T> > f(o);
                return QMetaType::registerConverterFunction(&f, id, toId);
            }
            return true;
        }
    };
} +/

enum QualifiedNameCppFlags
{
    none = 0,
    ignoreHeadConst = 0x01,
    ignoreTailConst = 0x02,
    ignoreConst = ignoreHeadConst | ignoreTailConst,
    replaceQFlags = 0x04,
}

// Same as fullyQualifiedName, but using C++ syntax
extern(D) enum fullyQualifiedNameCpp(T, QualifiedNameCppFlags flags = QualifiedNameCppFlags.none) = fqnTypeCpp!(T, flags);
extern(D) enum fullyQualifiedNameCpp(alias T, QualifiedNameCppFlags flags = QualifiedNameCppFlags.none) = fqnSymCpp!(T, flags);

extern(D) private template isCppSymbol(alias T)
{
    static if (is(T == module) || is(T == package))
        enum isCppSymbol = false;
    else static if (is(T == enum))
        enum isCppSymbol = __traits(getCppNamespaces, T).length > 0;
    else
        enum isCppSymbol = __traits(getLinkage, T) == "C++" || __traits(getLinkage, T) == "C";
}

extern(D) private template getCppNamespacesPrefix(alias T)
{
    static if (!isCppSymbol!T)
        enum getCppNamespacesPrefix = "";
    else
        enum getCppNamespacesPrefix = () {
            string r;
            foreach (n; __traits(getCppNamespaces, T))
                r ~= n ~ "::";
            return r;
        }();
}

extern(D) private template fqnSymParentPrefixCpp(alias T, bool isCpp, QualifiedNameCppFlags flags)
{
    static if (isCpp && (is(__traits(parent, T) == module) || is(__traits(parent, T) == package)))
        enum fqnSymParentPrefixCpp = null;
    else static if (__traits(compiles, __traits(parent, T)) && !__traits(isSame, T, __traits(parent, T)))
        enum fqnSymParentPrefixCpp = fqnSymCpp!(__traits(parent, T), flags) ~ "::";
    else static if (is(T == module) || is(T == package))
        enum fqnSymParentPrefixCpp = "D::";
    else
        enum fqnSymParentPrefixCpp = null;
}

extern(D) template findQFlagsAlias(T)
{
    static if (is(T : QFlags!X, X))
    {
        enum findQFlagsAlias = () {
            string ret;
            static foreach (name; __traits(allMembers, __traits(parent, X)))
                static if (is(__traits(getMember, __traits(parent, X), name)) && is(T == __traits(getMember, __traits(parent, X), name)))
                    ret = name;
            return ret;
        }();
    }
}

extern(D) private template fqnSymCpp(alias T : X!A, QualifiedNameCppFlags flags, alias X, A...)
{
    template fqnTuple(T...)
    {
        static if (T.length == 0)
            enum fqnTuple = "";
        else static if (T.length == 1)
        {
            static if (isExpressionTuple!T)
                enum fqnTuple = T[0].stringof;
            else
                enum fqnTuple = fullyQualifiedNameCpp!(T[0], flags);
        }
        else
            enum fqnTuple = fqnTuple!(T[0]) ~ "," ~ fqnTuple!(T[1 .. $]);
    }

    static if (is(T : QFlags!Y, Y) && findQFlagsAlias!T.length && (flags & QualifiedNameCppFlags.replaceQFlags))
    {
        enum fqnSymCpp =
            fqnSymParentPrefixCpp!(Y, isCppSymbol!Y, flags) ~
            getCppNamespacesPrefix!Y ~
            findQFlagsAlias!T;
    }
    else
    {
        enum fqnSymCpp =
            fqnSymParentPrefixCpp!(X, isCppSymbol!T, flags) ~
            getCppNamespacesPrefix!T ~
            __traits(identifier, X) ~ "<" ~ fqnTuple!A ~ (fqnTuple!A.endsWith(">") ? " " : "") ~ ">";
    }
}

extern(D) private template fqnSymCpp(alias T, QualifiedNameCppFlags flags)
{
    static string adjustIdent(string s)
    {
        import std.algorithm.searching : findSplit, skipOver;

        if (s.skipOver("package ") || s.skipOver("module "))
            return s;
        return s.findSplit("(")[0];
    }
    enum fqnSymCpp = fqnSymParentPrefixCpp!(T, isCppSymbol!T, flags) ~
        getCppNamespacesPrefix!T ~
        adjustIdent(__traits(identifier, T));
}

extern(D) private template fqnTypeCpp(T, QualifiedNameCppFlags flags)
{
    string addQualifiers(string typeString, bool addConst)
    {
        auto result = typeString;
        if (addConst)
        {
            static if (is(T == U*, U))
                result = result ~ " const";
            else
                result = "const " ~ result;
        }
        return result;
    }

    // Convenience template to avoid copy-paste
    template chain(string current)
    {
        enum chain = addQualifiers(current, is(T == const) && !(flags & QualifiedNameCppFlags.ignoreConst));
    }

    static if (isBasicType!T && !is(T == enum))
    {
        enum fqnTypeCpp = chain!((Unqual!T).stringof);
    }
    else static if (is(T == class))
    {
        enum fqnTypeCpp = chain!(
            chain!(chain!(fqnSymCpp!(T, flags & ~QualifiedNameCppFlags.ignoreHeadConst)) ~ "*")
        );
    }
    else static if (isAggregateType!T || is(T == enum))
    {
        enum fqnTypeCpp = chain!(fqnSymCpp!(T, flags));
    }
    else static if (isStaticArray!T)
    {
        import std.conv : to;
        enum fqnTypeCpp = chain!(
            fqnTypeCpp!(typeof(T.init[0]), flags) ~ "[" ~ to!string(T.length) ~ "]"
        );
    }
    else static if (isArray!T)
    {
        enum fqnTypeCpp = chain!(
            fqnTypeCpp!(typeof(T.init[0]), flags) ~ "[]"
        );
    }
    else static if (is(T == U*, U))
    {
        enum fqnTypeCpp = chain!(
            fqnTypeCpp!(U, flags & ~QualifiedNameCppFlags.ignoreHeadConst) ~ "*"
        );
    }
    else
        // In case something is forgotten
        static assert(0, "Unrecognized type " ~ T.stringof ~ ", can't convert to fully qualified string for C++");
}

extern(D) auto typenameHelper(T)()
{
    static immutable(char[fullyQualifiedNameCpp!T.length + 1]) result = fullyQualifiedNameCpp!(T, QualifiedNameCppFlags.ignoreConst | QualifiedNameCppFlags.replaceQFlags);
    return result;
}
