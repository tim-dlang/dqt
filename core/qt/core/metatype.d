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
import qt.core.basicatomic;
import qt.core.bytearray;
import qt.core.bytearrayview;
import qt.core.compare;
import qt.core.datastream;
import qt.core.flags;
import qt.core.global;
import qt.core.iterable;
import qt.core.list;
import qt.core.object;
import qt.core.objectdefs;
import qt.core.typeinfo;
import qt.core.variant;
import qt.helpers;
import std.traits;

/+ #ifndef QT_NO_QOBJECT
#endif

#ifdef Bool
#error qmetatype.h must be included before any header file that defines Bool
#endif


// from qcborcommon.h
enum class QCborSimpleType : quint8;


template <typename T>
inline constexpr int qMetaTypeId();
+/

struct BuiltinTypeInfo
{
    string typeName;
    int typeNameID;
    string realType;
    string dType;
}

// F is a tuple: (QMetaType::TypeName, QMetaType::TypeNameID, RealType)
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
    BuiltinTypeInfo("Char16", 56, "char16_t", "wchar"),
    BuiltinTypeInfo("Char32", 57, "char32_t", "dchar"),
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

/+ #if QT_CONFIG(regularexpression) +/
enum immutable(BuiltinTypeInfo[]) regularExpressionTypes = [
    BuiltinTypeInfo("QRegularExpression", 44, "QRegularExpression"),
];
/+ #else
#  define QT_FOR_EACH_STATIC_REGULAR_EXPRESSION(F)
#endif +/

enum immutable(BuiltinTypeInfo[]) coreClasses = [
    BuiltinTypeInfo("QChar", 7, "QChar"),
    BuiltinTypeInfo("QString", 10, "QString"),
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
] ~ easingCurveTypes ~ [
    BuiltinTypeInfo("QUuid", 30, "QUuid"),
    BuiltinTypeInfo("QVariant", 41, "QVariant"),
] ~ regularExpressionTypes ~ [
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
    BuiltinTypeInfo("QVariantList", 9, "QVariantList", "QList!(QVariant)"),
    BuiltinTypeInfo("QVariantHash", 28, "QVariantHash"),
    BuiltinTypeInfo("QVariantPair", 58, "QVariantPair"),
    BuiltinTypeInfo("QByteArrayList", 49, "QByteArrayList", "QList!(QByteArray)"),
    BuiltinTypeInfo("QStringList", 11, "QStringList", "QList!(QString)"),
];

/+ #if QT_CONFIG(shortcut) +/
enum immutable(BuiltinTypeInfo[]) keySequenceClasses = [
    BuiltinTypeInfo("QKeySequence", 0x100b, "QKeySequence"),
];
/+ #else
#define QT_FOR_EACH_STATIC_KEYSEQUENCE_CLASS(F)
#endif +/

enum immutable(BuiltinTypeInfo[]) guiClasses = [
    BuiltinTypeInfo("QFont", 0x1000, "QFont"),
    BuiltinTypeInfo("QPixmap", 0x1001, "QPixmap"),
    BuiltinTypeInfo("QBrush", 0x1002, "QBrush"),
    BuiltinTypeInfo("QColor", 0x1003, "QColor"),
    BuiltinTypeInfo("QPalette", 0x1004, "QPalette"),
    BuiltinTypeInfo("QIcon", 0x1005, "QIcon"),
    BuiltinTypeInfo("QImage", 0x1006, "QImage"),
    BuiltinTypeInfo("QPolygon", 0x1007, "QPolygon"),
    BuiltinTypeInfo("QRegion", 0x1008, "QRegion"),
    BuiltinTypeInfo("QBitmap", 0x1009, "QBitmap"),
    BuiltinTypeInfo("QCursor", 0x100a, "QCursor"),
] ~ keySequenceClasses ~ [
    BuiltinTypeInfo("QPen", 0x100c, "QPen"),
    BuiltinTypeInfo("QTextLength", 0x100d, "QTextLength"),
    BuiltinTypeInfo("QTextFormat", 0x100e, "QTextFormat"),
    BuiltinTypeInfo("QTransform", 0x1010, "QTransform"),
    BuiltinTypeInfo("QMatrix4x4", 0x1011, "QMatrix4x4"),
    BuiltinTypeInfo("QVector2D", 0x1012, "QVector2D"),
    BuiltinTypeInfo("QVector3D", 0x1013, "QVector3D"),
    BuiltinTypeInfo("QVector4D", 0x1014, "QVector4D"),
    BuiltinTypeInfo("QQuaternion", 0x1015, "QQuaternion"),
    BuiltinTypeInfo("QPolygonF", 0x1016, "QPolygonF"),
    BuiltinTypeInfo("QColorSpace", 0x1017, "QColorSpace"),
];


enum immutable(BuiltinTypeInfo[]) widgetClasses = [
    BuiltinTypeInfo("QSizePolicy", 0x2000, "QSizePolicy"),
];

/+
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
    F(QVariantPair, -1, QVariantPair, "QPair<QVariant,QVariant>") \
    F(QByteArrayList, -1, QByteArrayList, "QList<QByteArray>") \
    F(QStringList, -1, QStringList, "QList<QString>") \
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
    F(QQueue) \
    F(QStack) \
    F(QSet) \
    /*end*/

#define QT_FOR_EACH_AUTOMATIC_TEMPLATE_2ARG(F) \
    F(QHash, class) \
    F(QMap, class)

#define QT_FOR_EACH_AUTOMATIC_TEMPLATE_SMART_POINTER(F) \
    F(QSharedPointer) \
    F(QWeakPointer) \
    F(QPointer) +/

extern(C++, "QtPrivate")
{


extern(C++, class) struct QDebug;
extern(C++, class) struct QMetaTypeInterface
{
public:
    ushort revision; // 0 in Qt 6.0. Can increase if new field are added
    ushort alignment;
    uint size;
    uint flags;
    /+ mutable +/ QBasicAtomicInt typeId;

    alias MetaObjectFn = ExternCPPFunc!(const(QMetaObject)* function(const(QMetaTypeInterface)* ));
    MetaObjectFn metaObjectFn;

    const(char)* name;

    alias DefaultCtrFn = ExternCPPFunc!(void function(const(QMetaTypeInterface)* , void* ));
    DefaultCtrFn defaultCtr;
    alias CopyCtrFn = ExternCPPFunc!(void function(const(QMetaTypeInterface)* , void* , const(void)* ));
    CopyCtrFn copyCtr;
    alias MoveCtrFn = ExternCPPFunc!(void function(const(QMetaTypeInterface)* , void* , void* ));
    MoveCtrFn moveCtr;
    alias DtorFn = ExternCPPFunc!(void function(const(QMetaTypeInterface)* , void* ));
    DtorFn dtor;
    alias EqualsFn = ExternCPPFunc!(bool function(const(QMetaTypeInterface)* , const(void)* , const(void)* ));
    EqualsFn equals;
    alias LessThanFn = ExternCPPFunc!(bool function(const(QMetaTypeInterface)* , const(void)* , const(void)* ));
    LessThanFn lessThan;
    alias DebugStreamFn = ExternCPPFunc!(void function(const(QMetaTypeInterface)* , ref QDebug , const(void)* ));
    DebugStreamFn debugStream;
    alias DataStreamOutFn = ExternCPPFunc!(void function(const(QMetaTypeInterface)* , ref QDataStream , const(void)* ));
    DataStreamOutFn dataStreamOut;
    alias DataStreamInFn = ExternCPPFunc!(void function(const(QMetaTypeInterface)* , ref QDataStream , void* ));
    DataStreamInFn dataStreamIn;

    alias LegacyRegisterOp = ExternCPPFunc!(void function());
    LegacyRegisterOp legacyRegisterOp;
}

/*!
    This template is used for implicit conversion from type From to type To.
    \internal
*/
To convertImplicit(From, To)(ref const(From) from)
{
    return from;
}

    /+ template<typename T, bool>
    struct SequentialValueTypeIsMetaType;
    template<typename T, bool>
    struct AssociativeValueTypeIsMetaType;
    template<typename T, bool>
    struct IsMetaTypePair;
    template<typename, typename>
    struct MetaTypeSmartPointerHelper; +/

    enum IsQFlags(T) = is(T : QFlags!X, X);

    enum IsEnumOrFlags(T) = is(T == enum) || IsQFlags!T;

}  // namespace QtPrivate

/// Binding for C++ class [QMetaType](https://doc.qt.io/qt-6/qmetatype.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QMetaType {
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
            LastCoreType = Type.QVariantPair,
            FirstGuiType = Type.QFont,
            LastGuiType = Type.QColorSpace,
            FirstWidgetsType = Type.QSizePolicy,
            LastWidgetsType = Type.QSizePolicy,
            HighestInternalId = Type.LastWidgetsType,

            QReal = qreal.sizeof == double.sizeof ? Type.Double : Type.Float,

            UnknownType = 0,
            User = 65536
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
        QLine = 23, QLineF = 24, QPoint = 25, QPointF = 26,
        QEasingCurve = 29, QUuid = 30, QVariant = 41, QModelIndex = 42,
        QPersistentModelIndex = 50, QRegularExpression = 44,
        QJsonValue = 45, QJsonObject = 46, QJsonArray = 47, QJsonDocument = 48,
        QByteArrayList = 49, QObjectStar = 39, SChar = 40,
        Void = 43,
        Nullptr = 51,
        QVariantMap = 8, QVariantList = 9, QVariantHash = 28,
        QCborSimpleType = 52, QCborValue = 53, QCborArray = 54, QCborMap = 55,
        Char16 = 56, Char32 = 57,

        // Gui types
        QFont = 0x1000, QPixmap = 0x1001, QBrush = 0x1002, QColor = 0x1003, QPalette = 0x1004,
        QIcon = 0x1005, QImage = 0x1006, QPolygon = 0x1007, QRegion = 0x1008, QBitmap = 0x1009,
        QCursor = 0x100a, QKeySequence = 0x100b, QPen = 0x100c, QTextLength = 0x100d, QTextFormat = 0x100e,
        QTransform = 0x1010, QMatrix4x4 = 0x1011, QVector2D = 0x1012,
        QVector3D = 0x1013, QVector4D = 0x1014, QQuaternion = 0x1015, QPolygonF = 0x1016, QColorSpace = 0x1017,

        // Widget types
        QSizePolicy = 0x2000,
        LastCoreType = Char32,
        LastGuiType = QColorSpace,
        User = 65536
    };
#endif +/

    enum TypeFlag {
        NeedsConstruction = 0x1,
        NeedsDestruction = 0x2,
        RelocatableType = 0x4,
/+ #if QT_DEPRECATED_SINCE(6, 0) +/
        MovableType /+ Q_DECL_ENUMERATOR_DEPRECATED_X("Use RelocatableType instead.") +/ = TypeFlag.RelocatableType,
/+ #endif +/
        PointerToQObject = 0x8,
        IsEnumeration = 0x10,
        SharedPointerToQObject = 0x20,
        WeakPointerToQObject = 0x40,
        TrackingPointerToQObject = 0x80,
        IsUnsignedEnumeration = 0x100,
        IsGadget = 0x200,
        PointerToGadget = 0x400,
        IsPointer = 0x800,
        IsQmlList =0x1000, // used in the QML engine to recognize QQmlListProperty<T> and list<T>
        IsConst = 0x2000,
    }
    /+ Q_DECLARE_FLAGS(TypeFlags, TypeFlag) +/
alias TypeFlags = QFlags!(TypeFlag);
    static void registerNormalizedTypedef(/+ QT_PREPEND_NAMESPACE(QByteArray) +/ ref const(.QByteArray) normalizedTypeName, QMetaType type);

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_6_0 +/
/+        static int type(const(char)* typeName)
    { return QMetaType.fromName(QByteArrayView(typeName)).id(); }
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static int type(/+ QT_PREPEND_NAMESPACE(QByteArray) +/ ref const(QByteArray) typeName)
    { return QMetaType.fromName(QByteArrayView(typeName)).id(); }
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static const(char)* typeName(int type)
    { return QMetaType(type).name(); }
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static int sizeOf(int type)
    { return cast(int)QMetaType(type).sizeOf(); }
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static TypeFlags typeFlags(int type)
    { return QMetaType(type).flags(); }
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static const(QMetaObject)* metaObjectForType(int type)
    { return QMetaType(type).metaObject(); }
    /+ QT_DEPRECATED_VERSION_6_0
    static void *create(int type, const void *copy = nullptr)
    { return QMetaType(type).create(copy); } +/
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static void destroy(int type, void* data)
    { return QMetaType(type).destroy(data); }
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static void* construct(int type, void* where, const(void)* copy)
    { return QMetaType(type).construct(where, copy); }
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static void destruct(int type, void* where)
    { return QMetaType(type).destruct(where); }+/
/+ #endif +/
    static bool isRegistered(int type);

    /+ explicit +/this(int type);
    /+ explicit +/ this(const(/+ QtPrivate:: +/QMetaTypeInterface)* d)
    {
        this.d_ptr = d;
    }
    /+ constexpr QMetaType() = default; +/

    bool isValid() const;
    bool isRegistered() const;
    static if (defined!"QT_QMETATYPE_BC_COMPAT")
    {
        int id() const;
    }
    else
    {
        // ### Qt 7: Remove traces of out of line version
        // unused int parameter is used to avoid ODR violation
        int id(int = 0) const
        {
            if (d_ptr) {
                if (int id = d_ptr.typeId.loadRelaxed())
                    return id;
                return idHelper();
            }
            return 0;
        }
    }
    qsizetype sizeOf() const
    {
        return d_ptr ? d_ptr.size : 0;
    }
    qsizetype alignOf() const
    {
        return d_ptr ? d_ptr.alignment : 0;
    }
    TypeFlags flags() const
    {
        return d_ptr ? TypeFlags(cast(QFlag) (d_ptr.flags)) : TypeFlags();
    }
    const(QMetaObject)* metaObject() const
    {
        return d_ptr && d_ptr.metaObjectFn ? d_ptr.metaObjectFn(d_ptr) : null;
    }
    const(char)* name() const
    {
        return d_ptr ? d_ptr.name : null;
    }

    mixin(mangleWindows("?create@QMetaType@@QEBAPEAXPEBX@Z", q{
    void *create(const void *copy = null) const;
    }));
    void destroy(void* data) const;
    void* construct(void* where, const(void)* copy = null) const;
    void destruct(void* data) const;
    QPartialOrdering compare(const(void)* lhs, const(void)* rhs) const;
    bool equals(const(void)* lhs, const(void)* rhs) const;

    bool isEqualityComparable() const;
    bool isOrdered() const;

/+ #ifndef QT_NO_DATASTREAM +/
    version (QT_NO_DATASTREAM) {} else
    {
        bool save(ref QDataStream stream, const(void)* data) const;
        bool load(ref QDataStream stream, void* data) const;
        bool hasRegisteredDataStreamOperators() const;

    /+ #if QT_DEPRECATED_SINCE(6, 0) +/
        /+ QT_DEPRECATED_VERSION_6_0 +/
            static bool save(ref QDataStream stream, int type, const(void)* data)
        { return QMetaType(type).save(stream, data); }
        /+ QT_DEPRECATED_VERSION_6_0 +/
            static bool load(ref QDataStream stream, int type, void* data)
        { return QMetaType(type).load(stream, data); }
    }
/+ #endif
#endif +/

    static QMetaType fromType(T)()
    {
        return QMetaType(qMetaTypeInterfaceForType!(T)());
    }
    static QMetaType fromName(QByteArrayView name);

    /+ friend bool operator==(QMetaType a, QMetaType b)
    {
        if (a.d_ptr == b.d_ptr)
            return true;
        if (!a.d_ptr || !b.d_ptr)
            return false; // one type is undefined, the other is defined
        // avoid id call if we already have the id
        const int aId = a.id();
        const int bId = b.id();
        return aId == bId;
    } +/
    /+ friend bool operator!=(QMetaType a, QMetaType b) { return !(a == b); } +/

public:

/+ #ifndef QT_NO_DEBUG_STREAM
    bool debugStream(QDebug& dbg, const void *rhs);
    bool hasRegisteredDebugStreamOperator() const;

#if QT_DEPRECATED_SINCE(6, 0)
    QT_DEPRECATED_VERSION_6_0
    static bool debugStream(QDebug& dbg, const void *rhs, int typeId)
    { return QMetaType(typeId).debugStream(dbg, rhs); }
    template<typename T>
    QT_DEPRECATED_VERSION_6_0
    static bool hasRegisteredDebugStreamOperator()
    { return QMetaType::fromType<T>().hasRegisteredDebugStreamOperator(); }
    QT_DEPRECATED_VERSION_6_0
    static bool hasRegisteredDebugStreamOperator(int typeId)
    { return QMetaType(typeId).hasRegisteredDebugStreamOperator(); }
#endif
#endif +/

    // type erased converter function
//    alias ConverterFunction = /+ std:: +/function_!(ExternCPPFunc!(bool function(const(void)* src, void* target)));

    // type erased mutable view, primarily for containers
//    alias MutableViewFunction = /+ std:: +/function_!(ExternCPPFunc!(bool function(void* src, void* target)));

    // implicit conversion supported like double -> float
    /+ template<typename From, typename To> +/
    /+ static bool registerConverter()
    {
        return registerConverter<From, To>(QtPrivate::convertImplicit<From, To>);
    } +/

    // member function as in "QString QFont::toString() const"
    /+ template<typename From, typename To> +/
    /+ static bool registerConverter(To(From::*function)() const)
    {
        static_assert((!QMetaTypeId2<To>::IsBuiltIn || !QMetaTypeId2<From>::IsBuiltIn),
            "QMetaType::registerConverter: At least one of the types must be a custom type.");

        const QMetaType fromType = QMetaType::fromType<From>();
        const QMetaType toType = QMetaType::fromType<To>();
        auto converter = [function](const void *from, void *to) -> bool {
            const From *f = static_cast<const From *>(from);
            To *t = static_cast<To *>(to);
            *t = (f->*function)();
            return true;
        };
        return registerConverterImpl<From, To>(converter, fromType, toType);
    } +/

    // member function
    /+ template<typename From, typename To> +/
    /+ static bool registerMutableView(From,To)(ExternCPPFunc!(To function())/+ From::* +/ function_)
    {
        static assert((!QMetaTypeId2!(To).IsBuiltIn || !QMetaTypeId2!(From).IsBuiltIn),
            "QMetaType::registerMutableView: At least one of the types must be a custom type.");

        const(QMetaType) fromType = QMetaType.fromType!(From)();
        const(QMetaType) toType = QMetaType.fromType!(To)();
        auto view = [function](void *from, void *to) -> bool {
            From* f = static_cast!(From*)(from);
            To* t = static_cast!(To*)(to);
            *t = (f->*function_)();
            return true;
        };
        return registerMutableViewImpl!(From, To)(view, fromType, toType);
    } +/

    // member function as in "double QString::toDouble(bool *ok = nullptr) const"
    /+ template<typename From, typename To> +/
    /+ static bool registerConverter(To(From::*function)(bool*) const)
    {
        static_assert((!QMetaTypeId2<To>::IsBuiltIn || !QMetaTypeId2<From>::IsBuiltIn),
            "QMetaType::registerConverter: At least one of the types must be a custom type.");

        const QMetaType fromType = QMetaType::fromType<From>();
        const QMetaType toType = QMetaType::fromType<To>();
        auto converter = [function](const void *from, void *to) -> bool {
            const From *f = static_cast<const From *>(from);
            To *t = static_cast<To *>(to);
            bool result = true;
            *t = (f->*function)(&result);
            if (!result)
                *t = To();
            return result;
        };
        return registerConverterImpl<From, To>(converter, fromType, toType);
    } +/

    // functor or function pointer
    /+ template<typename From, typename To, typename UnaryFunction> +/
    /+ static bool registerConverter(UnaryFunction function)
    {
        static_assert((!QMetaTypeId2<To>::IsBuiltIn || !QMetaTypeId2<From>::IsBuiltIn),
            "QMetaType::registerConverter: At least one of the types must be a custom type.");

        const QMetaType fromType = QMetaType::fromType<From>();
        const QMetaType toType = QMetaType::fromType<To>();
        auto converter = [function = std::move(function)](const void *from, void *to) -> bool {
            const From *f = static_cast<const From *>(from);
            To *t = static_cast<To *>(to);
            *t = function(*f);
            return true;
        };
        return registerConverterImpl<From, To>(std::move(converter), fromType, toType);
    } +/

    // functor or function pointer
    /+ template<typename From, typename To, typename UnaryFunction> +/
    /+ static bool registerMutableView(From,To,UnaryFunction)(UnaryFunction function_)
    {
        static assert((!QMetaTypeId2!(To).IsBuiltIn || !QMetaTypeId2!(From).IsBuiltIn),
            "QMetaType::registerMutableView: At least one of the types must be a custom type.");

        const(QMetaType) fromType = QMetaType.fromType!(From)();
        const(QMetaType) toType = QMetaType.fromType!(To)();
        auto view = [function = /+ std:: +/move(function_)](void *from, void *to) -> bool {
            From* f = static_cast!(From*)(from);
            To* t = static_cast!(To*)(to);
            *t = function_(*f);
            return true;
        };
        return registerMutableViewImpl!(From, To)(/+ std:: +/move(cast(_Tp && ) (view)), fromType, toType);
    } +/

private:
    /+ template<typename From, typename To> +/
    /+ static bool registerConverterImpl(From,To)(ConverterFunction converter, QMetaType fromType, QMetaType toType)
    {
        if (registerConverterFunction(/+ std:: +/move(converter), fromType, toType)) {
            extern(D) static __gshared const unregister = qScopeGuard([=] {
                unregisterConverterFunction(fromType, toType);
            });
            return true;
        } else {
            return false;
        }
    } +/

    /+ template<typename From, typename To> +/
    /+ static bool registerMutableViewImpl(From,To)(MutableViewFunction view, QMetaType fromType, QMetaType toType)
    {
        if (registerMutableViewFunction(/+ std:: +/move(view), fromType, toType)) {
            extern(D) static __gshared const unregister = qScopeGuard([=] {
               unregisterMutableViewFunction(fromType, toType);
            });
            return true;
        } else {
            return false;
        }
    } +/
public:

    static bool convert(QMetaType fromType, const(void)* from, QMetaType toType, void* to);
    static bool canConvert(QMetaType fromType, QMetaType toType);

    static bool view(QMetaType fromType, void* from, QMetaType toType, void* to);
    static bool canView(QMetaType fromType, QMetaType toType);
/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static bool convert(const(void)* from, int fromTypeId, void* to, int toTypeId)
    { return convert(QMetaType(fromTypeId), from, QMetaType(toTypeId), to); }
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static bool compare(const(void)* lhs, const(void)* rhs, int typeId, int* result)
    {
        auto t = QMetaType(typeId);
        auto c = t.compare(lhs, rhs);
        if (c == QPartialOrdering.Unordered) {
            *result = 0;
            return false;
        } else if (c == QPartialOrdering.Less) {
            *result = -1;
            return true;
        } else if (c == QPartialOrdering.Equivalent) {
            *result = 0;
            return true;
        } else {
            *result = 1;
            return true;
        }
    }
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static bool equals(const(void)* lhs, const(void)* rhs, int typeId, int* result)
    {
        auto t = QMetaType(typeId);
        if (!t.isEqualityComparable())
            return false;
        *result = t.equals(lhs, rhs) ? 0 : -1;
        return true;
    }
/+ #endif +/

    /+ template<typename From, typename To> +/
    /+ static bool hasRegisteredConverterFunction()
    {
        return hasRegisteredConverterFunction(
                    QMetaType::fromType<From>(), QMetaType::fromType<To>());
    } +/

    /+ static bool hasRegisteredConverterFunction(QMetaType fromType, QMetaType toType); +/

    /+ template<typename From, typename To> +/
    static bool hasRegisteredMutableViewFunction(From,To)()
    {
        return hasRegisteredMutableViewFunction(
                    QMetaType.fromType!(From)(), QMetaType.fromType!(To)());
    }

    static bool hasRegisteredMutableViewFunction(QMetaType fromType, QMetaType toType);

/+ #ifndef Q_CLANG_QDOC +/
    /+ template<typename, bool> +/ /+ friend struct QtPrivate::SequentialValueTypeIsMetaType; +/
    /+ template<typename, bool> +/ /+ friend struct QtPrivate::AssociativeValueTypeIsMetaType; +/
    /+ template<typename, bool> +/ /+ friend struct QtPrivate::IsMetaTypePair; +/
    /+ template<typename, typename> +/ /+ friend struct QtPrivate::MetaTypeSmartPointerHelper; +/
/+ #endif +/
//    static bool registerConverterFunction(ref const(ConverterFunction) f, QMetaType from, QMetaType to);
//    static void unregisterConverterFunction(QMetaType from, QMetaType to);

//    static bool registerMutableViewFunction(ref const(MutableViewFunction) f, QMetaType from, QMetaType to);
 //   static void unregisterMutableViewFunction(QMetaType from, QMetaType to);

    static void unregisterMetaType(QMetaType type);
    const(/+ QtPrivate:: +/QMetaTypeInterface)* iface() { return d_ptr; }

package:
    mixin(changeWindowsMangling(q{mangleChangeAccess("private")}, q{
    int idHelper() const;
    }));
    /+ friend class QVariant; +/
    const(/+ QtPrivate:: +/QMetaTypeInterface)* d_ptr = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #undef QT_DEFINE_METATYPE_ID +/
/+pragma(inline, true) QFlags!(QMetaType.TypeFlags.enum_type) operator |(QMetaType.TypeFlags.enum_type f1, QMetaType.TypeFlags.enum_type f2)/+noexcept+/{return QFlags!(QMetaType.TypeFlags.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QMetaType.TypeFlags.enum_type) operator |(QMetaType.TypeFlags.enum_type f1, QFlags!(QMetaType.TypeFlags.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QFlags!(QMetaType.TypeFlags.enum_type) operator &(QMetaType.TypeFlags.enum_type f1, QMetaType.TypeFlags.enum_type f2)/+noexcept+/{return QFlags!(QMetaType.TypeFlags.enum_type)(f1)&f2;}+/
/+pragma(inline, true) QFlags!(QMetaType.TypeFlags.enum_type) operator &(QMetaType.TypeFlags.enum_type f1, QFlags!(QMetaType.TypeFlags.enum_type) f2)/+noexcept+/{return f2&f1;}+/
/+pragma(inline, true) void operator +(QMetaType.TypeFlags.enum_type f1, QMetaType.TypeFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QMetaType.TypeFlags.enum_type f1, QFlags!(QMetaType.TypeFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(int f1, QFlags!(QMetaType.TypeFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QMetaType.TypeFlags.enum_type f1, QMetaType.TypeFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QMetaType.TypeFlags.enum_type f1, QFlags!(QMetaType.TypeFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QFlags!(QMetaType.TypeFlags.enum_type) f2)/+noexcept+/;+/
/+pragma(inline, true) QIncompatibleFlag operator |(QMetaType.TypeFlags.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/
/+pragma(inline, true) void operator +(int f1, QMetaType.TypeFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator +(QMetaType.TypeFlags.enum_type f1, int f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(int f1, QMetaType.TypeFlags.enum_type f2)/+noexcept+/;+/
/+pragma(inline, true) void operator -(QMetaType.TypeFlags.enum_type f1, int f2)/+noexcept+/;+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QMetaType::TypeFlags)
#define QT_METATYPE_PRIVATE_DECLARE_TYPEINFO(C, F)  \
    }                                               \
    Q_DECLARE_TYPEINFO(QtMetaTypePrivate:: C, (F)); \
    namespace QtMetaTypePrivate {


namespace QtMetaTypePrivate {


class QPairVariantInterfaceImpl
{
public:
    const void *_pair;
    QMetaType _metaType_first;
    QMetaType _metaType_second;

    typedef void (*getFunc)(const void * const *p, void *);

    getFunc _getFirst;
    getFunc _getSecond;

    template<class T>
    static void getFirstImpl(const void * const *pair, void *dataPtr)
    { *static_cast<typename T::first_type *>(dataPtr) = static_cast<const T*>(*pair)->first; }
    template<class T>
    static void getSecondImpl(const void * const *pair, void *dataPtr)
    { *static_cast<typename T::second_type *>(dataPtr) = static_cast<const T*>(*pair)->second; }

public:
    template<class T> QPairVariantInterfaceImpl(const T*p)
      : _pair(p)
      , _metaType_first(QMetaType::fromType<typename T::first_type>())
      , _metaType_second(QMetaType::fromType<typename T::second_type>())
      , _getFirst(getFirstImpl<T>)
      , _getSecond(getSecondImpl<T>)
    {
    }

    constexpr QPairVariantInterfaceImpl()
      : _pair(nullptr)
      , _getFirst(nullptr)
      , _getSecond(nullptr)
    {
    }

    inline void first(void *dataPtr) const { _getFirst(&_pair, dataPtr); }
    inline void second(void *dataPtr) const { _getSecond(&_pair, dataPtr); }
};
QT_METATYPE_PRIVATE_DECLARE_TYPEINFO(QPairVariantInterfaceImpl, Q_RELOCATABLE_TYPE)
template<typename From>
struct QPairVariantInterfaceConvertFunctor;

template<typename T, typename U>
struct QPairVariantInterfaceConvertFunctor<std::pair<T, U> >
{
    QPairVariantInterfaceImpl operator()(const std::pair<T, U>& f) const
==== BASE ====
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
        static yes_type checkType(const QObject* );
#endif
        static no_type checkType(...);
        static_assert(sizeof(T), "Type argument of Q_PROPERTY or Q_DECLARE_METATYPE(T*) must be fully defined");
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
    /+ template<> struct IsQEnumHelper<void> { enum { Value = false }; };

    template<typename T, typename Enable = void>
    struct MetaObjectForType
    {
        static constexpr const QMetaObject *value() { return nullptr; }
        using MetaObjectFn = const QMetaObject *(*)(const QMetaTypeInterface *);
        static constexpr MetaObjectFn metaObjectFunction = nullptr;
    };
#ifndef QT_NO_QOBJECT
    template<>
    struct MetaObjectForType<void>
    {
        static constexpr const QMetaObject *value() { return nullptr; }
        using MetaObjectFn = const QMetaObject *(*)(const QMetaTypeInterface *);
        static constexpr MetaObjectFn metaObjectFunction = nullptr;
    };
    template<typename T>
    struct MetaObjectForType<T*, typename std::enable_if<IsPointerToTypeDerivedFromQObject<T*>::Value>::type>
    {
        static constexpr const QMetaObject *value() { return &T::staticMetaObject; }
        static constexpr const QMetaObject *metaObjectFunction(const QMetaTypeInterface *) { return &T::staticMetaObject; }
    };
    template<typename T>
    struct MetaObjectForType<T, typename std::enable_if<IsGadgetHelper<T>::IsGadgetOrDerivedFrom>::type>
    {
        static constexpr const QMetaObject *value() { return &T::staticMetaObject; }
        static constexpr const QMetaObject *metaObjectFunction(const QMetaTypeInterface *) { return &T::staticMetaObject; }
    };
    template<typename T>
    struct MetaObjectForType<T, typename std::enable_if<IsPointerToGadgetHelper<T>::IsGadgetOrDerivedFrom>::type>
    {
        static constexpr const QMetaObject *value()
        {
            return &IsPointerToGadgetHelper<T>::BaseType::staticMetaObject;
        }
        static constexpr const QMetaObject *metaObjectFunction(const QMetaTypeInterface *) { return value(); }
    };
    template<typename T>
    struct MetaObjectForType<T, typename std::enable_if<IsQEnumHelper<T>::Value>::type >
    {
        static constexpr const QMetaObject *value() { return qt_getEnumMetaObject(T()); }
        static constexpr const QMetaObject *metaObjectFunction(const QMetaTypeInterface *) { return value(); }
    };
#endif +/
    template MetaObjectForType(T)
    {
        static if (is(const(T): const(QObject)))
        {
            static const(QMetaObject)* value() { return &T.staticMetaObject; }
            static const(QMetaObject)* metaObjectFunctionImpl(const(QMetaTypeInterface)*) { return &T.staticMetaObject; }
            extern(D) static immutable metaObjectFunction = &metaObjectFunctionImpl;
        }
        else
        {
            static const(QMetaObject)* value() { return null; }
            alias MetaObjectFn = const(QMetaObject)* function(const(QMetaTypeInterface)*);
            extern(D) static immutable MetaObjectFn metaObjectFunction = null;
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
    }; +/

    struct SequentialContainerTransformationHelper(T, /+ bool +/ /+ = QtPrivate::IsSequentialContainer<T>::Value +/)
    {
        /+ static bool registerConverter()
        {
            return false;
        } +/

        static bool registerMutableView()
        {
            return false;
        }
    }

    /+ template<typename T, bool = QMetaTypeId2<typename T::value_type>::Defined>
    struct SequentialValueTypeIsMetaType
    {
        static bool registerConverter()
        {
            return false;
        }

        static bool registerMutableView()
        {
            return false;
        }
    };

    template<typename T>
    struct SequentialContainerTransformationHelper<T, true> : SequentialValueTypeIsMetaType<T>
    {
    }; +/

    struct AssociativeContainerTransformationHelper(T, /+ bool +/ /+ = QtPrivate::IsAssociativeContainer<T>::Value +/)
    {
        /+ static bool registerConverter()
        {
            return false;
        } +/

        static bool registerMutableView()
        {
            return false;
        }
    }

    struct AssociativeKeyTypeIsMetaType(T, /+ bool +/ /+ = QMetaTypeId2<typename T::key_type>::Defined +/)
    {
        /+ static bool registerConverter()
        {
            return false;
        } +/

        static bool registerMutableView()
        {
            return false;
        }
    }

    struct AssociativeMappedTypeIsMetaType(T, /+ bool +/ /+ = QMetaTypeId2<typename T::mapped_type>::Defined +/)
    {
        /+ static bool registerConverter()
        {
            return false;
        } +/

        static bool registerMutableView()
        {
            return false;
        }
    }

    /+ template<typename T>
    struct AssociativeContainerTransformationHelper<T, true> : AssociativeKeyTypeIsMetaType<T>
    {
    };

    template<typename T, bool = QMetaTypeId2<typename T::first_type>::Defined
                                && QMetaTypeId2<typename T::second_type>::Defined>
    struct IsMetaTypePair
    {
        static bool registerConverter()
        {
            return false;
        }
    };

    template<typename T>
    struct IsMetaTypePair<T, true>
    {
        inline static bool registerConverter();
    };

    template<typename T>
    struct IsPair
    {
        static bool registerConverter()
        {
            return false;
        }
    };
    template<typename T, typename U>
    struct IsPair<std::pair<T, U> > : IsMetaTypePair<std::pair<T, U> > {};

    template<typename T>
    struct MetaTypePairHelper : IsPair<T> {};

    template<typename T, typename = void>
    struct MetaTypeSmartPointerHelper
    {
        static bool registerConverter() { return false; }
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
            code ~= text("            extern(D) static immutable(char[", t.realType.length, " + 1]) nameAsArray = \"", t.realType, "\";\n");
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
            code ~= text("                extern(D) static immutable(char[", t.realType.length, " + 1]) nameAsArray = \"", t.realType, "\";\n");
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
    struct IsPointerToTypeDerivedFromQObject<Result(*)(Args...)> { enum { Value = false }; };

    template<typename T>
    inline constexpr bool IsQmlListType = false; +/

    enum IsUnsignedEnum(T) = is(T == enum) && true/*isUnsigned!(OriginalType!(T))*/;

    private template RemovePointer(T)
    {
        static if (is(T == X*, X))
            alias RemovePointer = typeof(*T.init);
        else
            alias RemovePointer = T;
    }

    struct QMetaTypeTypeFlags(T)
    {
        enum { Flags = (QTypeInfo!(T).isRelocatable ? QMetaType.TypeFlag.RelocatableType : 0)
                     | (QTypeInfo!(T).isComplex ? QMetaType.TypeFlag.NeedsConstruction : 0)
                     | (QTypeInfo!(T).isComplex ? QMetaType.TypeFlag.NeedsDestruction : 0)
                     | (IsPointerToTypeDerivedFromQObject!(T).Value ? QMetaType.TypeFlag.PointerToQObject : 0)
                     | (IsSharedPointerToTypeDerivedFromQObject!(T).Value ? QMetaType.TypeFlag.SharedPointerToQObject : 0)
                     | (IsWeakPointerToTypeDerivedFromQObject!(T).Value ? QMetaType.TypeFlag.WeakPointerToQObject : 0)
                     | (IsTrackingPointerToTypeDerivedFromQObject!(T).Value ? QMetaType.TypeFlag.TrackingPointerToQObject : 0)
                     | (IsEnumOrFlags!(T) ? QMetaType.TypeFlag.IsEnumeration : 0)
                     | (IsGadgetHelper!(T).IsGadgetOrDerivedFrom ? QMetaType.TypeFlag.IsGadget : 0)
                     | (IsPointerToGadgetHelper!(T).IsGadgetOrDerivedFrom ? QMetaType.TypeFlag.PointerToGadget : 0)
                     | (QTypeInfo!(T).isPointer ? QMetaType.TypeFlag.IsPointer : 0)
                     | (IsUnsignedEnum!(T) ? QMetaType.TypeFlag.IsUnsignedEnumeration : 0)
                     //TODO
                     //| (IsQmlListType!(T) ? QMetaType.TypeFlag.IsQmlList : 0)
                     | (is(RemovePointer!(T) == const) ? QMetaType.TypeFlag.IsConst : 0)
             };
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

int qRegisterNormalizedMetaType(T)(/+ QT_PREPEND_NAMESPACE(QByteArray) +/ ref const(QByteArray) normalizedTypeName)
{
/+ #ifndef QT_NO_QOBJECT +/
    (mixin(Q_ASSERT_X(q{normalizedTypeName == QMetaObject.normalizedType(normalizedTypeName.constData())},q{
               "qRegisterNormalizedMetaType"},q{
               "qRegisterNormalizedMetaType was called with a not normalized type name, "
               "please call qRegisterMetaType instead."})));
/+ #endif +/

    const(QMetaType) metaType = QMetaType.fromType!(T)();
    const(int) id = metaType.id();

/+    /+ QtPrivate:: +/SequentialContainerTransformationHelper!(T).registerConverter();
    /+ QtPrivate:: +/SequentialContainerTransformationHelper!(T).registerMutableView();
    /+ QtPrivate:: +/AssociativeContainerTransformationHelper!(T).registerConverter();
    /+ QtPrivate:: +/AssociativeContainerTransformationHelper!(T).registerMutableView();
    /+ QtPrivate:: +/MetaTypePairHelper!(T).IsPair.registerConverter();
    /+ QtPrivate:: +/MetaTypeSmartPointerHelper!(T).registerConverter();+/

    if (normalizedTypeName != metaType.name())
        QMetaType.registerNormalizedTypedef(normalizedTypeName, metaType);

    return id;
}

int qRegisterMetaType(T)(const(char)* typeName)
{
/+ #ifdef QT_NO_QOBJECT
    QT_PREPEND_NAMESPACE(QByteArray) normalizedTypeName = typeName;
#else +/
    /+ QT_PREPEND_NAMESPACE(QByteArray) +/QByteArray normalizedTypeName = QMetaObject.normalizedType(typeName);
/+ #endif +/
    return qRegisterNormalizedMetaType!(T)(normalizedTypeName);
}

pragma(inline, true) int qMetaTypeId(T)()
{
    static if (QMetaTypeId2!(T).IsBuiltIn) {
        return QMetaTypeId2!(T).MetaType;
    } else {
        return QMetaType.fromType!(T)().id();
    }
}

pragma(inline, true) int qRegisterMetaType(T)()
{
    int id = qMetaTypeId!(T)();
    return id;
}

/+ #ifndef QT_NO_QOBJECT +/

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
            const char* cName = T.staticMetaObject.className();
            QByteArray typeName;
            typeName.reserve(strlen(cName) + 1);
            typeName.append(cName).append('*');
            const int newId = qRegisterNormalizedMetaType!(T)(typeName);
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
            const char* cName = T.staticMetaObject.className();
            QByteArray cNameB = QByteArray(cName);
            const int newId = qRegisterNormalizedMetaType!(T)(cNameB);
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
            const char* cName = T.staticMetaObject.className();
            QByteArray typeName;
            typeName.reserve(strlen(cName) + 1);
            typeName.append(cName).append('*');
            const int newId = qRegisterNormalizedMetaType!(T)(typeName);
            metatype_id.storeRelease(newId);
            return newId;
        }
    }
    else static if (is(T == enum) || is(T : QFlags!X, X) /*IsQEnumHelper!T.Value*/)
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
            /*const char *eName = qt_getEnumName(T());
            const char *cName = qt_getEnumMetaObject(T()).className();*/
            const char *eName = __traits(identifier, T);
            const char *cName = __traits(identifier, __traits(parent, T));
            QByteArray typeName;
            typeName.reserve(strlen(cName) + 2 + strlen(eName));
            typeName.append(cName).append("::").append(eName);
            const int newId = qRegisterNormalizedMetaType!(T)(typeName);
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
        /*constexpr auto arr = QtPrivate::typenameHelper<TYPE>();
        auto name = arr.data();
        if (QByteArrayView(name) == (#TYPE)) {
            const int id = qRegisterNormalizedMetaType<TYPE>(name);
            metatype_id.storeRelease(id);
            return id;
        }*/
        const int newId = qRegisterMetaType!(TYPE)(TYPE.stringof);
        metatype_id.storeRelease(newId);
        return newId;
    }
}

/+ #define Q_DECLARE_BUILTIN_METATYPE(TYPE, METATYPEID, NAME) \
    QT_BEGIN_NAMESPACE \
    template<> struct QMetaTypeId2<NAME> \
    { \
        using NameAsArrayType = std::array<char, sizeof(#NAME)>; \
        enum { Defined = 1, IsBuiltIn = true, MetaType = METATYPEID };   \
        static inline constexpr int qt_metatype_id() { return METATYPEID; } \
        static constexpr NameAsArrayType nameAsArray = { #NAME }; \
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

/+ #define Q_DECLARE_METATYPE_TEMPLATE_1ARG(SINGLE_ARG_TEMPLATE) \
QT_BEGIN_NAMESPACE \ +/
struct QMetaTypeId(X : C!T, alias C, T) if (is(const(X) == const(C!T)) && __traits(identifier, C) != "QFlags")
{
    enum Defined = QMetaTypeId2!T.Defined;
    static int qt_metatype_id()
    {
        import qt.core.basicatomic;
        import qt.core.bytearrayalgorithms;
        static QBasicAtomicInt metatype_id = QBasicAtomicInt(0);
        if (const int id = metatype_id.loadRelaxed())
            return id;
        const char *tName = QMetaType.fromType!T().name();
        assert(tName);
        const size_t tNameLen = qstrlen(tName);
        QByteArray typeName;
        immutable containerName = __traits(identifier, C);
        typeName.reserve(containerName.length + 1 + tNameLen + 1 + 1);
        typeName.append(containerName.ptr, containerName.length)
            .append('<').append(tName, tNameLen);
        typeName.append('>');
        const int newId = qRegisterNormalizedMetaType!(C!T)(typeName);
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
QT_END_NAMESPACE

#define Q_DECLARE_METATYPE_TEMPLATE_2ARG(DOUBLE_ARG_TEMPLATE) \
QT_BEGIN_NAMESPACE \ +/
struct QMetaTypeId(X : C!(T, U), alias C, T, U) if (is(const(X) == const(C!(T, U))))
{
    enum Defined = QMetaTypeId2!T.Defined && QMetaTypeId2!U.Defined;
    static int qt_metatype_id()
    {
        import qt.core.basicatomic;
        import qt.core.bytearrayalgorithms;
        static QBasicAtomicInt metatype_id = QBasicAtomicInt(0);
        if (const int id = metatype_id.loadAcquire())
            return id;
        const char *tName = QMetaType.fromType!T().name();
        const char *uName = QMetaType.fromType!U().name();
        assert(tName);
        assert(uName);
        const size_t tNameLen = qstrlen(tName);
        const size_t uNameLen = qstrlen(uName);
        QByteArray typeName;
        immutable containerName = __traits(identifier, C);
        typeName.reserve(containerName.length + 1 + tNameLen + 1 + uNameLen + 1 + 1);
        typeName.append(containerName.ptr, containerName.length)
            .append('<').append(tName, tNameLen).append(',').append(uName, uNameLen);
        typeName.append('>');
        const int newId = qRegisterNormalizedMetaType!(C!(T, U))(typeName);
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
        typeName.reserve(sizeof(#SMART_POINTER) + 1 + strlen(cName) + 1); \
        typeName.append(#SMART_POINTER, int(sizeof(#SMART_POINTER)) - 1) \
            .append('<').append(cName).append('>'); \
        const int newId = qRegisterNormalizedMetaType< SMART_POINTER<T> >(typeName); \
        metatype_id.storeRelease(newId); \
        return newId; \
    } \
}; \
template<typename T> \
struct MetaTypeSmartPointerHelper<SMART_POINTER<T> , \
        typename std::enable_if<IsPointerToTypeDerivedFromQObject<T*>::Value>::type> \
{ \
    static bool registerConverter() \
    { \
        const QMetaType to = QMetaType(QMetaType::QObjectStar); \
        if (!QMetaType::hasRegisteredConverterFunction(QMetaType::fromType<SMART_POINTER<T>>(), to)) { \
            QtPrivate::QSmartPointerConvertFunctor<SMART_POINTER<T> > o; \
            return QMetaType::registerConverter<SMART_POINTER<T>, QObject*>(o); \
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
    Q_DECLARE_METATYPE_TEMPLATE_1ARG(TEMPLATENAME)



QT_FOR_EACH_AUTOMATIC_TEMPLATE_1ARG(Q_DECLARE_SEQUENTIAL_CONTAINER_METATYPE_ITER)
#undef Q_DECLARE_SEQUENTIAL_CONTAINER_METATYPE_ITER

#define Q_DECLARE_SEQUENTIAL_CONTAINER_METATYPE Q_DECLARE_METATYPE_TEMPLATE_1ARG

Q_DECLARE_SEQUENTIAL_CONTAINER_METATYPE(std::vector)
Q_DECLARE_SEQUENTIAL_CONTAINER_METATYPE(std::list)

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
Q_DECLARE_METATYPE_TEMPLATE_2ARG(std::pair)

#define Q_DECLARE_METATYPE_TEMPLATE_SMART_POINTER_ITER(TEMPLATENAME) \
    Q_DECLARE_SMART_POINTER_METATYPE(TEMPLATENAME)


QT_FOR_EACH_AUTOMATIC_TEMPLATE_SMART_POINTER(Q_DECLARE_METATYPE_TEMPLATE_SMART_POINTER_ITER)

#undef Q_DECLARE_METATYPE_TEMPLATE_SMART_POINTER_ITER


QT_FOR_EACH_STATIC_TYPE(Q_DECLARE_BUILTIN_METATYPE)



template <typename T>
inline bool QtPrivate::IsMetaTypePair<T, true>::registerConverter()
{
    const QMetaType to = QMetaType::fromType<QtMetaTypePrivate::QPairVariantInterfaceImpl>();
    if (!QMetaType::hasRegisteredConverterFunction(QMetaType::fromType<T>(), to)) {
        QtMetaTypePrivate::QPairVariantInterfaceConvertFunctor<T> o;
        return QMetaType::registerConverter<T, QtMetaTypePrivate::QPairVariantInterfaceImpl>(o);
    }
    return true;
} +/

extern(C++, "QtPrivate") {

/+ template<typename From>
struct QSequentialIterableConvertFunctor
{
    QIterable<QMetaSequence> operator()(const From &f) const
    {
        return QIterable<QMetaSequence>(QMetaSequence::fromContainer<From>(), &f);
    }
}; +/

struct QSequentialIterableMutableViewFunctor(From)
{
    /+QIterable!(QMetaSequence) operator ()(ref From f) const
    {
        return QIterable!(QMetaSequence)(QMetaSequence.fromContainer!(From)(), &f);
    }+/
}

/+ template<typename T>
struct SequentialValueTypeIsMetaType<T, true>
{
    static bool registerConverter()
    {
        const QMetaType to = QMetaType::fromType<QIterable<QMetaSequence>>();
        if (!QMetaType::hasRegisteredConverterFunction(QMetaType::fromType<T>(), to)) {
            QSequentialIterableConvertFunctor<T> o;
            return QMetaType::registerConverter<T, QIterable<QMetaSequence>>(o);
        }
        return true;
    }

    static bool registerMutableView()
    {
        const QMetaType to = QMetaType::fromType<QIterable<QMetaSequence>>();
        if (!QMetaType::hasRegisteredMutableViewFunction(QMetaType::fromType<T>(), to)) {
            QSequentialIterableMutableViewFunctor<T> o;
            return QMetaType::registerMutableView<T, QIterable<QMetaSequence>>(o);
        }
        return true;
    }
};

template<typename From>
struct QAssociativeIterableConvertFunctor
{
    QIterable<QMetaAssociation> operator()(const From &f) const
    {
        return QIterable<QMetaAssociation>(QMetaAssociation::fromContainer<From>(), &f);
    }
}; +/

struct QAssociativeIterableMutableViewFunctor(From)
{
    /+QIterable!(QMetaAssociation) operator ()(ref From f) const
    {
        return QIterable!(QMetaAssociation)(QMetaAssociation.fromContainer!(From)(), &f);
    }+/
}

// Mapped type can be omitted, for example in case of a set.
// However, if it is available, we want to instantiate the metatype here.
/+ template<typename T>
struct AssociativeKeyTypeIsMetaType<T, true> : AssociativeMappedTypeIsMetaType<T>
{
    static bool registerConverter()
    {
        const QMetaType to = QMetaType::fromType<QIterable<QMetaAssociation>>();
        if (!QMetaType::hasRegisteredConverterFunction(QMetaType::fromType<T>(), to)) {
            QAssociativeIterableConvertFunctor<T> o;
            return QMetaType::registerConverter<T, QIterable<QMetaAssociation>>(o);
        }
        return true;
    }

    static bool registerMutableView()
    {
        const QMetaType to = QMetaType::fromType<QIterable<QMetaAssociation>>();
        if (!QMetaType::hasRegisteredMutableViewFunction(QMetaType::fromType<T>(), to)) {
            QAssociativeIterableMutableViewFunctor<T> o;
            return QMetaType::registerMutableView<T, QIterable<QMetaAssociation>>(o);
        }
        return true;
    }
}; +/

struct QTypeNormalizer
{
    char* output;
    int len = 0;
    char last = 0;

private:
    static bool is_ident_char(char s)
    {
        return ((s >= 'a' && s <= 'z') || (s >= 'A' && s <= 'Z') || (s >= '0' && s <= '9')
                || s == '_');
    }
    static bool is_space(char s) { return (s == ' ' || s == '\t' || s == '\n'); }
    static bool is_number(char s) { return s >= '0' && s <= '9'; }
    static bool starts_with_token(const(char)* b, const(char)* e, const(char)* token,
                                                bool msvcKw = false)
    {
        while (b != e && *token && *b == *token) {
            b++;
            token++;
        }
        if (*token)
            return false;
/+ #ifdef Q_CC_MSVC
        /// On MSVC, keywords like class or struct are not separated with spaces in constexpr
        /// context
        if (msvcKw)
            return true;
#endif
        Q_UNUSED(msvcKw) +/
        return b == e || !is_ident_char(*b);
    }
    static bool skipToken(ref const(char)* x, const(char)* e, const(char)* token,
                                        bool msvcKw = false)
    {
        if (!starts_with_token(x, e, token, msvcKw))
            return false;
        while (*token++)
            x++;
        while (x != e && is_space(*x))
            x++;
        return true;
    }
    static const(char)* skipString(const(char)* x, const(char)* e)
    {
        char delim = *x;
        x++;
        while (x != e && *x != delim) {
            if (*x == '\\') {
                x++;
                if (x == e)
                    return e;
            }
            x++;
        }
        if (x != e)
            x++;
        return x;
    }
    static const(char)* skipTemplate(const(char)* x, const(char)* e, bool stopAtComa = false)
    {
        int scopeDepth = 0;
        int templateDepth = 0;
        while (x != e) {
            switch (*x) {
            case '<':
                if (!scopeDepth)
                    templateDepth++;
                break;
            case ',':
                if (stopAtComa && !scopeDepth && !templateDepth)
                    return x;
                break;
            case '>':
                if (!scopeDepth)
                    if (--templateDepth < 0)
                        return x;
                break;
            case '(':
            case '[':
            case '{':
                scopeDepth++;
                break;
            case '}':
            case ']':
            case ')':
                scopeDepth--;
                break;
            case '\'':
                if (is_number(x[-1]))
                    break;
            goto case;
            case '\"':
                x = skipString(x, e);
                continue;default:

            }
            x++;
        }
        return x;
    }

    void append(char x)
    {
        last = x;
        len++;
        if (output)
            *output++ = x;
    }

    void replaceLast(char x)
    {
        last = x;
        if (output)
            *(output - 1) = x;
    }

    void appendStr(const(char)* x)
    {
        while (*x)
            append(*x++);
    }

    void normalizeIntegerTypes(ref const(char)* begin, const(char)* end)
    {
        int numLong = 0;
        int numSigned = 0;
        int numUnsigned = 0;
        int numInt = 0;
        int numShort = 0;
        int numChar = 0;
        while (begin < end) {
            if (skipToken(begin, end, "long")) {
                numLong++;
                continue;
            }
            if (skipToken(begin, end, "int")) {
                numInt++;
                continue;
            }
            if (skipToken(begin, end, "short")) {
                numShort++;
                continue;
            }
            if (skipToken(begin, end, "unsigned")) {
                numUnsigned++;
                continue;
            }
            if (skipToken(begin, end, "signed")) {
                numSigned++;
                continue;
            }
            if (skipToken(begin, end, "char")) {
                numChar++;
                continue;
            }
/+ #ifdef Q_CC_MSVC
            if (skipToken(begin, end, "__int64")) {
                numLong = 2;
                continue;
            }
#endif +/
            break;
        }
        if (numLong == 2)
            append('q'); // q(u)longlong
        if (numSigned && numChar)
            appendStr("signed ");
        else if (numUnsigned)
            appendStr("u");
        if (numChar)
            appendStr("char");
        else if (numShort)
            appendStr("short");
        else if (numLong == 1)
            appendStr("long");
        else if (numLong == 2)
            appendStr("longlong");
        else if (numUnsigned || numSigned || numInt)
            appendStr("int");
    }

    void skipStructClassOrEnum(ref const(char)* begin, const(char)* end)
    {
        // discard 'struct', 'class', and 'enum'; they are optional
        // and we don't want them in the normalized signature
        skipToken(begin, end, "struct", true) || skipToken(begin, end, "class", true)
                || skipToken(begin, end, "enum", true);
    }

    void skipQtNamespace(ref const(char)* begin, const(char)* end)
    {
/+ #ifdef QT_NAMESPACE
        const char *nsbeg = begin;
        if (skipToken(nsbeg, end, QT_STRINGIFY(QT_NAMESPACE)) && nsbeg + 2 < end && nsbeg[0] == ':'
            && nsbeg[1] == ':') {
            begin = nsbeg + 2;
            while (begin != end && is_space(*begin))
                begin++;
        }
#else
        Q_UNUSED(begin) +/
        /+ Q_UNUSED(end) +/
/+ #endif +/
    }

public:
/+ #if defined(Q_CC_CLANG) || defined (Q_CC_GNU) +/
    // this is much simpler than the full type normalization below
    // the reason is that the signature returned by Q_FUNC_INFO is already
    // normalized to the largest degree, and we need to do only small adjustments
    /+int normalizeTypeFromSignature(const(char)* begin, const(char)* end)
    {
        // bail out if there is an anonymous struct
        auto name = /+ std:: +/string_view(begin, end-begin);
/+ #if defined (Q_CC_CLANG)
        if (name.find("anonymous ") != std::string_view::npos)
            return normalizeType(begin, end);
#else +/
        if (name.find("unnamed ".ptr) != /+ std:: +/string_view.npos)
            return normalizeType(begin, end);
/+ #endif +/
        while (begin < end) {
            if (*begin == ' ') {
                if (last == ',' || last == '>' || last == '<' || last == '*' || last == '&') {
                    ++begin;
                    continue;
                }
            }
            if (last == ' ') {
                if (*begin == '*' || *begin == '&' || *begin == '(') {
                    replaceLast(*begin);
                    ++begin;
                    continue;
                }
            }
            if (!is_ident_char(last)) {
                skipStructClassOrEnum(begin, end);
                if (begin == end)
                    break;

                skipQtNamespace(begin, end);
                if (begin == end)
                    break;

                normalizeIntegerTypes(begin, end);
                if (begin == end)
                    break;
            }
            append(*begin);
            ++begin;
        }
        return len;
    }+/
/+ #else
    // MSVC needs the full normalization, as it puts the const in a different
    // place than we expect
    constexpr int normalizeTypeFromSignature(const char *begin, const char *end)
    { return normalizeType(begin, end); }
#endif +/

    int normalizeType(const(char)* begin, const(char)* end, bool adjustConst = true)
    {
        // Trim spaces
        while (begin != end && is_space(*begin))
            begin++;
        while (begin != end && is_space(*(end - 1)))
            end--;

        // Convert 'char const *' into 'const char *'. Start at index 1,
        // not 0, because 'const char *' is already OK.
        const(char)* cst = begin + 1;
        if (*begin == '\'' || *begin == '"')
            cst = skipString(begin, end);
        bool seenStar = false;
        bool hasMiddleConst = false;
        while (cst < end) {
            if (*cst == '\"' || (*cst == '\'' && !is_number(cst[-1]))) {
                cst = skipString(cst, end);
                if (cst == end)
                    break;
            }

            // We mustn't convert 'char * const *' into 'const char **'
            // and we must beware of 'Bar<const Bla>'.
            if (*cst == '&' || *cst == '*' || *cst == '[') {
                seenStar = *cst != '&' || cst != (end - 1);
                break;
            }
            if (*cst == '<') {
                cst = skipTemplate(cst + 1, end);
                if (cst == end)
                    break;
            }
            cst++;
            const(char)* skipedCst = cst;
            if (!is_ident_char(*(cst - 1)) && skipToken(skipedCst, end, "const")) {
                const(char)* testEnd = end;
                while (skipedCst < testEnd--) {
                    if (*testEnd == '*' || *testEnd == '['
                        || (*testEnd == '&' && testEnd != (end - 1))) {
                        seenStar = true;
                        break;
                    }
                    if (*testEnd == '>')
                        break;
                }
                if (adjustConst && !seenStar) {
                    if (*(end - 1) == '&')
                        end--;
                } else {
                    appendStr("const ");
                }
                normalizeType(begin, cst, false);
                begin = skipedCst;
                hasMiddleConst = true;
                break;
            }
        }
        if (skipToken(begin, end, "const")) {
            if (adjustConst && !seenStar) {
                if (*(end - 1) == '&')
                    end--;
            } else {
                appendStr("const ");
            }
        }
        if (seenStar && adjustConst) {
            const(char)* e = end;
            if (*(end - 1) == '&' && *(end - 2) != '&')
                e--;
            while (begin != e && is_space(*(e - 1)))
                e--;
            const(char)* token = "tsnoc"; // 'const' reverse, to check if it ends with const
            while (*token && begin != e && *(--e) == *token++)
                {}
            if (!*token && begin != e && !is_ident_char(*(e - 1))) {
                while (begin != e && is_space(*(e - 1)))
                    e--;
                end = e;
            }
        }

        skipStructClassOrEnum(begin, end);
        skipQtNamespace(begin, end);

        if (skipToken(begin, end, "QVector")) {
            // Replace QVector by QList
            appendStr("QList");
        }

        if (skipToken(begin, end, "QPair")) {
            // replace QPair by std::pair
            appendStr("std::pair");
        }

        if (!hasMiddleConst)
            // Normalize the integer types
            normalizeIntegerTypes(begin, end);

        bool spaceSkiped = true;
        while (begin != end) {
            char c = *begin++;
            if (is_space(c)) {
                spaceSkiped = true;
            } else if ((c == '\'' && !is_number(last)) || c == '\"') {
                begin--;
                auto x = skipString(begin, end);
                while (begin < x)
                    append(*begin++);
            } else {
                if (spaceSkiped && is_ident_char(last) && is_ident_char(c))
                    append(' ');
                append(c);
                spaceSkiped = false;
                if (c == '<') {
                    do {
                        // template recursion
                        const(char)* tpl = skipTemplate(begin, end, true);
                        normalizeType(begin, tpl, false);
                        if (tpl == end)
                            return len;
                        append(*tpl);
                        begin = tpl;
                    } while (*begin++ == ',');
                }
            }
        }
        return len;
    }
}

// Normalize the type between begin and end, and store the data in the output. Returns the length.
// The idea is to first run this function with nullptr as output to allocate the output with the
// size
/+int qNormalizeType(const(char)* begin, const(char)* end, char* output)
{
    return QTypeNormalizer { output} .normalizeType(begin, end);
}+/

/+ template<typename T>
struct is_std_pair : std::false_type {};

template <typename T1_, typename T2_>
struct is_std_pair<std::pair<T1_, T2_>> : std::true_type {
    using T1 = T1_;
    using T2 = T2_;
}; +/

extern(D) auto typenameHelper(T)()
{
    /+ if constexpr (is_std_pair<T>::value) {
        using T1 = typename is_std_pair<T>::T1;
        using T2 = typename is_std_pair<T>::T2;
        std::remove_const_t<std::conditional_t<bool (QMetaTypeId2<T1>::IsBuiltIn), typename QMetaTypeId2<T1>::NameAsArrayType, decltype(typenameHelper<T1>())>> t1Name {};
        std::remove_const_t<std::conditional_t<bool (QMetaTypeId2<T2>::IsBuiltIn), typename QMetaTypeId2<T2>::NameAsArrayType, decltype(typenameHelper<T2>())>> t2Name {};
        if constexpr (bool (QMetaTypeId2<T1>::IsBuiltIn) ) {
            t1Name = QMetaTypeId2<T1>::nameAsArray;
        } else {
            t1Name = typenameHelper<T1>();
        }
        if constexpr (bool(QMetaTypeId2<T2>::IsBuiltIn)) {
            t2Name = QMetaTypeId2<T2>::nameAsArray;
        } else {
            t2Name = typenameHelper<T2>();
        }
        constexpr auto nonTypeDependentLen = sizeof("std::pair<,>");
        constexpr auto t1Len = t1Name.size() - 1;
        constexpr auto t2Len = t2Name.size() - 1;
        constexpr auto length = nonTypeDependentLen + t1Len + t2Len;
        std::array<char, length + 1> result {};
        constexpr auto prefix = "std::pair<";
        int currentLength = 0;
        for (; currentLength < int(sizeof("std::pair<") - 1); ++currentLength)
            result[currentLength] = prefix[currentLength];
        for (int i = 0; i < int(t1Len); ++currentLength, ++i)
            result[currentLength] = t1Name[i];
        result[currentLength++] = ',';
        for (int i = 0; i < int(t2Len); ++currentLength, ++i)
            result[currentLength] = t2Name[i];
        result[currentLength++] = '>';
        result[currentLength++] = '\0';
        return result;
    } else +/ {
        immutable(char[T.stringof.length + 1]) result = T.stringof;
        //QTypeNormalizer{ result.data()} .normalizeTypeFromSignature(begin, end);
        // TODO: Use the same name as Qt.
        return result;
    }
}

struct BuiltinMetaType(T)
{
    static if (QMetaTypeId2!(T).IsBuiltIn)
        enum int value = QMetaTypeId2!(T).MetaType;
    else
        enum int value = 0;
}

struct QEqualityOperatorForType(T, /+ bool +/ /+ = (QTypeTraits::has_operator_equal_v<T> && !std::is_pointer_v<T>) +/)
{
/+ QT_WARNING_PUSH
QT_WARNING_DISABLE_FLOAT_COMPARE +/
    static bool equals(const(QMetaTypeInterface)* , const(void)* a, const(void)* b)
    { return *reinterpret_cast!(const(T)*)(a) == *reinterpret_cast!(const(T)*)(b); }
/+ QT_WARNING_POP +/
}

/+ template<typename T>
struct QEqualityOperatorForType <T, false>
{
    static constexpr QMetaTypeInterface::EqualsFn equals = nullptr;
}; +/

struct QLessThanOperatorForType(T, /+ bool +/ /+ = (QTypeTraits::has_operator_less_than_v<T> && !std::is_pointer_v<T>) +/)
{
    static bool lessThan(const(QMetaTypeInterface)* , const(void)* a, const(void)* b)
    { return *reinterpret_cast!(const(T)*)(a) < *reinterpret_cast!(const(T)*)(b); }
}

/+ template<typename T>
struct QLessThanOperatorForType <T, false>
{
    static constexpr QMetaTypeInterface::LessThanFn lessThan = nullptr;
}; +/

struct QDebugStreamOperatorForType(T, /+ bool +/ /+ = (QTypeTraits::has_ostream_operator_v<QDebug, T> && !std::is_pointer_v<T>) +/)
{
    /+ static void debugStream(const QMetaTypeInterface *, QDebug &dbg, const void *a)
    { dbg << *reinterpret_cast<const T *>(a); } +/
}

/+ template<typename T>
struct QDebugStreamOperatorForType <T, false>
{
    static constexpr QMetaTypeInterface::DebugStreamFn debugStream = nullptr;
}; +/


struct QDataStreamOperatorForType(T, /+ bool +/ /+ = QTypeTraits::has_stream_operator_v<QDataStream, T>> +/)
{
    static void dataStreamOut(const(QMetaTypeInterface)* , ref QDataStream ds, const(void)* a)
    { ds << *reinterpret_cast!(const(T)*)(a); }
    static void dataStreamIn(const(QMetaTypeInterface)* , ref QDataStream ds, void* a)
    { ds >> *reinterpret_cast!(T*)(a); }
}

/+ template<typename T>
struct QDataStreamOperatorForType <T, false>
{
    static constexpr QMetaTypeInterface::DataStreamOutFn dataStreamOut = nullptr;
    static constexpr QMetaTypeInterface::DataStreamInFn dataStreamIn = nullptr;
}; +/

extern(C++, class) struct QMetaTypeForType(S)
{
public:
    extern(D) static immutable name = typenameHelper!(S)();

    static QMetaTypeInterface.DefaultCtrFn getDefaultCtr()
    {
        import core.lifetime;

        static if (is(S == class))
        {
            return (const QMetaTypeInterface *, void *addr) {
                *cast(S*) addr = null;
            };
        }
        else static if (__traits(compiles, {S s;}) || __traits(hasMember, S, "rawConstructor")) {
            return (const QMetaTypeInterface *, void *addr) {
                static if (is(S == struct) && __traits(hasMember, S, "rawConstructor")) {
                    (cast(S*) addr).rawConstructor();
                } else {
                    emplace!S(cast(S*) addr);
                }
            };
        } else {
            return null;
        }
    }

    static QMetaTypeInterface.CopyCtrFn getCopyCtr()
    {
        import core.lifetime;

        static if (is(S == class))
        {
            return (const QMetaTypeInterface *, void *addr, const void *other) {
                *cast(S*) addr = *cast(S*) other;
            };
        }
        else static if (__traits(compiles, (ref S other){S s = other;})) {
            return (const QMetaTypeInterface *, void *addr, const void *other) {
                static if (is(S == struct) && __traits(hasCopyConstructor, S)) {
                    // Workaround for https://issues.dlang.org/show_bug.cgi?id=22766
                    import core.stdc.string;
                    memset(addr, 0, S.sizeof);
                    (*cast(S*) addr).__ctor(*cast(S*) other);
                } else {
                    copyEmplace!S(*cast(S*) other, *cast(S*) addr);
                }
            };
        } else {
            return null;
        }
    }

    static QMetaTypeInterface.MoveCtrFn getMoveCtr()
    {
        import core.lifetime;

        static if (0 /*/+ std:: +/is_move_constructible_v!(S)*/) {
            return (const QMetaTypeInterface *, void *addr, void *other) {
                emplace!S(cast(S*) addr, /+ std:: +/move(*reinterpret_cast!(S*)(other)));
            };
        } else {
            return null;
        }
    }

    static QMetaTypeInterface.DtorFn getDtor()
    {
        static if (is(S == class))
            return null;
        else static if (1 /*/+ std:: +/is_destructible_v!(S) && !/+ std:: +/is_trivially_destructible_v!(S)*/)
            return (const QMetaTypeInterface *, void *addr) {
                destroy!false(*reinterpret_cast!(S*)(addr));
            };
        else
            return null;
    }

    static QMetaTypeInterface.LegacyRegisterOp getLegacyRegister()
    {
        static if (QMetaTypeId2!(S).Defined && !QMetaTypeId2!(S).IsBuiltIn) {
            return () { QMetaTypeId2!(S).qt_metatype_id(); };
        } else {
            return null;
        }
    }

    static const(char)* getName()
    {
        static if (cast(bool) (QMetaTypeId2!(S).IsBuiltIn)) {
            return QMetaTypeId2!(S).nameAsArray.ptr;
        } else {
            return name.ptr;
        }
    }
}

extern(D) struct QMetaTypeInterfaceWrapper(T)
{
    extern(D) static __gshared /*immutable*/ QMetaTypeInterface metaType = {
        /*.revision=*/ 0,
        /*.alignment=*/ T.alignof,
        /*.size=*/ T.sizeof,
        /*.flags=*/ QMetaTypeTypeFlags!(T).Flags,
        /*.typeId=*/ QBasicAtomicInt(BuiltinMetaType!(T).value),
        /*.metaObjectFn=*/ MetaObjectForType!(T).metaObjectFunction,
        /*.name=*/ QMetaTypeForType!(T).getName(),
        /*.defaultCtr=*/ QMetaTypeForType!(T).getDefaultCtr(),
        /*.copyCtr=*/ QMetaTypeForType!(T).getCopyCtr(),
        /*.moveCtr=*/ QMetaTypeForType!(T).getMoveCtr(),
        /*.dtor=*/ QMetaTypeForType!(T).getDtor(),
//        /*.equals=*/ &QEqualityOperatorForType!(T).equals,
//        /*.lessThan=*/ &QLessThanOperatorForType!(T).lessThan,
//        /*.debugStream=*/ QDebugStreamOperatorForType!(T).debugStream,
//        /*.dataStreamOut=*/ &QDataStreamOperatorForType!(T).dataStreamOut,
//        /*.dataStreamIn=*/ &QDataStreamOperatorForType!(T).dataStreamIn,
//        /*.legacyRegisterOp=*/ QMetaTypeForType!(T).getLegacyRegister()
    };
};


struct QMetaTypeInterfaceWrapper(T: void)
{
    static immutable QMetaTypeInterface metaType =
    {
        /*.revision=*/ 0,
        /*.alignment=*/ 0,
        /*.size=*/ 0,
        /*.flags=*/ 0,
        /*.typeId=*/ BuiltinMetaType!(void).value,
        /*.metaObjectFn=*/ null,
        /*.name=*/ "void",
        /*.defaultCtr=*/ null,
        /*.copyCtr=*/ null,
        /*.moveCtr=*/ null,
        /*.dtor=*/ null,
        /*.equals=*/ null,
        /*.lessThan=*/ null,
        /*.debugStream=*/ null,
        /*.dataStreamOut=*/ null,
        /*.dataStreamIn=*/ null,
        /*.legacyRegisterOp=*/ null
    };
};
/+ #undef QT_METATYPE_CONSTEXPRLAMDA

#ifndef QT_BOOTSTRAPPED

#if !defined(Q_CC_MSVC) || !defined(QT_BUILD_CORE_LIB)
#define QT_METATYPE_TEMPLATE_EXPORT Q_CORE_EXPORT
#else
#define QT_METATYPE_TEMPLATE_EXPORT
#endif

#define QT_METATYPE_DECLARE_EXTERN_TEMPLATE_ITER(TypeName, Id, Name)                               \
    extern template class QT_METATYPE_TEMPLATE_EXPORT QMetaTypeForType<Name>;
QT_WARNING_PUSH
QT_WARNING_DISABLE_GCC("-Wattributes") // false positive because of QMetaTypeForType<void>
QT_FOR_EACH_STATIC_PRIMITIVE_TYPE(QT_METATYPE_DECLARE_EXTERN_TEMPLATE_ITER)
QT_WARNING_POP
QT_FOR_EACH_STATIC_PRIMITIVE_POINTER(QT_METATYPE_DECLARE_EXTERN_TEMPLATE_ITER)
QT_FOR_EACH_STATIC_CORE_CLASS(QT_METATYPE_DECLARE_EXTERN_TEMPLATE_ITER)
QT_FOR_EACH_STATIC_CORE_POINTER(QT_METATYPE_DECLARE_EXTERN_TEMPLATE_ITER)
QT_FOR_EACH_STATIC_CORE_TEMPLATE(QT_METATYPE_DECLARE_EXTERN_TEMPLATE_ITER)
#undef QT_METATYPE_DECLARE_EXTERN_TEMPLATE_ITER
#undef QT_METATYPE_TEMPLATE_EXPORT
#endif +/

const(QMetaTypeInterface)* qMetaTypeInterfaceForType(T)()
{
    import std.traits;
    alias Ty = Unqual!(T);
    return &QMetaTypeInterfaceWrapper!(Ty).metaType;
}

extern(C++, "detail") {
/+struct is_complete_helper(T, ODR_VIOLATION_PREVENTER)
{
    /+ template<typename U> +/
    static auto check(U)()/+ (U *) -> std::integral_constant<bool, sizeof(U) != 0> +/;
    static auto check()/+ (...) -> std::false_type +/;
    alias type = /+ decltype(check(static_cast<T *>(nullptr))) +/false_type;
}+/
} // namespace detail

struct is_complete(T, ODR_VIOLATION_PREVENTER) {
    /+ detail:: +/is_complete_helper!(T, ODR_VIOLATION_PREVENTER).is_complete_helper.type base0;
    alias base0 this;
}

struct qRemovePointerLike(T)
{
    alias type = /+ std:: +/remove_pointer_t!(T);
}

/+ #define Q_REMOVE_POINTER_LIKE_IMPL(Pointer) \
template <typename T> \
struct qRemovePointerLike<Pointer<T>> \
{ \
    using type = T; \
};

QT_FOR_EACH_AUTOMATIC_TEMPLATE_SMART_POINTER(Q_REMOVE_POINTER_LIKE_IMPL) +/
alias qRemovePointerLike_t(T) = qRemovePointerLike!(T).type;
/+ #undef Q_REMOVE_POINTER_LIKE_IMPL +/

struct TypeAndForceComplete(T, ForceComplete_)
{
    alias type = T;
    alias ForceComplete = ForceComplete_;
}

/+ template<typename Unique, typename TypeCompletePair>
constexpr const QMetaTypeInterface *qTryMetaTypeInterfaceForType()
{
    using T = typename TypeCompletePair::type;
    using ForceComplete = typename TypeCompletePair::ForceComplete;
    using Ty = std::remove_cv_t<std::remove_reference_t<T>>;
    using Tz = qRemovePointerLike_t<Ty>;
    if constexpr (!is_complete<Tz, Unique>::value && !ForceComplete::value) {
        return nullptr;
    } else {
        return &QMetaTypeInterfaceWrapper<Ty>::metaType;
    }
} +/

} // namespace QtPrivate

/+ template<typename T>
constexpr QMetaType QMetaType::fromType()
{
    return QMetaType(QtPrivate::qMetaTypeInterfaceForType<T>());
}

template<typename... T>
constexpr const QtPrivate::QMetaTypeInterface *const qt_metaTypeArray[] = {
    QtPrivate::qMetaTypeInterfaceForType<T>()...
};

template<typename Unique,typename... T>
constexpr const QtPrivate::QMetaTypeInterface *const qt_incomplete_metaTypeArray[] = {
    QtPrivate::qTryMetaTypeInterfaceForType<Unique, T>()...
}; +/

template qt_incomplete_metaTypeArray(Unique, T...)
{
    extern(D) mixin((){
        import std.conv;
        string code = text("extern(D) const __gshared QMetaTypeInterface*[", T.length, "] qt_incomplete_metaTypeArray = [");
        static foreach (i; 0 .. T.length)
        {
            static if (is(T[i] == void))
                code ~= text("null, ");
            else
                code ~= text("&T[", i, "].metaType, ");
        }
        code ~= "];";
        return code;
    }());
}

/+ Q_DECLARE_METATYPE(QtMetaTypePrivate::QPairVariantInterfaceImpl) +/

