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
module qt.core.variant;
extern(C++):

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.atomic;
import qt.core.bitarray;
import qt.core.bytearray;
import qt.core.compare;
import qt.core.datetime;
import qt.core.easingcurve;
import qt.core.global;
import qt.core.hash;
import qt.core.list;
import qt.core.locale;
import qt.core.map;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.qchar;
import qt.core.regularexpression;
import qt.core.string;
import qt.core.stringlist;
import qt.core.typeinfo;
import qt.core.url;
import qt.core.uuid;
import qt.helpers;
version(QT_NO_DATASTREAM){}else
    import qt.core.datastream;
version(QT_NO_GEOM_VARIANT){}else
{
    import qt.core.line;
    import qt.core.point;
    import qt.core.rect;
    import qt.core.size;
}

/+ #ifndef QT_NO_DEBUG_STREAM
#endif
#ifndef QT_BOOTSTRAPPED
#endif
#if __has_include(<variant>) && __cplusplus >= 201703L
#elif defined(Q_CLANG_QDOC)
namespace std { template<typename...> struct variant; }
#endif



#if QT_CONFIG(easingcurve)
class QEasingCurve;
#endif
#if QT_CONFIG(regularexpression)
class QRegularExpression;
#endif +/ // QT_CONFIG(regularexpression)

/// Binding for C++ class [QVariant](https://doc.qt.io/qt-6/qvariant.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QVariant
{
 public:
/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    enum /+ QT_DEPRECATED_VERSION_X_6_0("Use QMetaType::Type instead.") +/ Type
    {
        Invalid = QMetaType.Type.UnknownType,
        Bool = QMetaType.Type.Bool,
        Int = QMetaType.Type.Int,
        UInt = QMetaType.Type.UInt,
        LongLong = QMetaType.Type.LongLong,
        ULongLong = QMetaType.Type.ULongLong,
        Double = QMetaType.Type.Double,
        Char = QMetaType.Type.QChar,
        Map = QMetaType.Type.QVariantMap,
        List = QMetaType.Type.QVariantList,
        String = QMetaType.Type.QString,
        StringList = QMetaType.Type.QStringList,
        ByteArray = QMetaType.Type.QByteArray,
        BitArray = QMetaType.Type.QBitArray,
        Date = QMetaType.Type.QDate,
        Time = QMetaType.Type.QTime,
        DateTime = QMetaType.Type.QDateTime,
        Url = QMetaType.Type.QUrl,
        Locale = QMetaType.Type.QLocale,
        Rect = QMetaType.Type.QRect,
        RectF = QMetaType.Type.QRectF,
        Size = QMetaType.Type.QSize,
        SizeF = QMetaType.Type.QSizeF,
        Line = QMetaType.Type.QLine,
        LineF = QMetaType.Type.QLineF,
        Point = QMetaType.Type.QPoint,
        PointF = QMetaType.Type.QPointF,
/+ #if QT_CONFIG(regularexpression) +/
        RegularExpression = QMetaType.Type.QRegularExpression,
/+ #endif +/
        Hash = QMetaType.Type.QVariantHash,
/+ #if QT_CONFIG(easingcurve) +/
        EasingCurve = QMetaType.Type.QEasingCurve,
/+ #endif +/
        Uuid = QMetaType.Type.QUuid,
/+ #if QT_CONFIG(itemmodel) +/
        ModelIndex = QMetaType.Type.QModelIndex,
        PersistentModelIndex = QMetaType.Type.QPersistentModelIndex,
/+ #endif +/
        LastCoreType = QMetaType.Type.LastCoreType,

        Font = QMetaType.Type.QFont,
        Pixmap = QMetaType.Type.QPixmap,
        Brush = QMetaType.Type.QBrush,
        Color = QMetaType.Type.QColor,
        Palette = QMetaType.Type.QPalette,
        Image = QMetaType.Type.QImage,
        Polygon = QMetaType.Type.QPolygon,
        Region = QMetaType.Type.QRegion,
        Bitmap = QMetaType.Type.QBitmap,
        Cursor = QMetaType.Type.QCursor,
/+ #if QT_CONFIG(shortcut) +/
        KeySequence = QMetaType.Type.QKeySequence,
/+ #endif +/
        Pen = QMetaType.Type.QPen,
        TextLength = QMetaType.Type.QTextLength,
        TextFormat = QMetaType.Type.QTextFormat,
        Transform = QMetaType.Type.QTransform,
        Matrix4x4 = QMetaType.Type.QMatrix4x4,
        Vector2D = QMetaType.Type.QVector2D,
        Vector3D = QMetaType.Type.QVector3D,
        Vector4D = QMetaType.Type.QVector4D,
        Quaternion = QMetaType.Type.QQuaternion,
        PolygonF = QMetaType.Type.QPolygonF,
        Icon = QMetaType.Type.QIcon,
        LastGuiType = QMetaType.Type.LastGuiType,

        SizePolicy = QMetaType.Type.QSizePolicy,

        UserType = QMetaType.Type.User,
//        LastType = 0xffffffff // need this so that gcc >= 3.4 allocates 32 bits for Type
    }
/+ #endif +/
    /+this()/+ noexcept+/
    {
        this.d = typeof(this.d)();
    }+/
    ~this();
    /+ explicit +/this(QMetaType type, const(void)* copy = null);
    @disable this(this);
    this(ref const(QVariant) other);

    this(int i);
    this(uint ui);
    this(qlonglong ll);
    this(qulonglong ull);
    this(bool b);
    this(double d);
    this(float f);
/+ #ifndef QT_NO_CAST_FROM_ASCII
    QT_ASCII_CAST_WARN QVariant(const char *str)
        : QVariant(QString::fromUtf8(str))
    {}
#endif +/

    this(ref const(QByteArray) bytearray);
    this(ref const(QBitArray) bitarray);
    this(ref const(QString) string);
    this(QLatin1String string);
    this(ref const(QStringList) stringlist);
    this(QChar qchar);
    this(QDate date);
    this(QTime time);
    this(ref const(QDateTime) datetime);
    this(ref const(QList!(QVariant)) list);
//    this(ref const(QMap!(QString, QVariant)) map);
//    this(ref const(QHash!(QString, QVariant)) hash);
    version(QT_NO_GEOM_VARIANT){}else
    {
        this(ref const(QSize) size);
        this(ref const(QSizeF) size);
        this(ref const(QPoint) pt);
        this(ref const(QPointF) pt);
        this(ref const(QLine) line);
        this(ref const(QLineF) line);
        this(ref const(QRect) rect);
        this(ref const(QRectF) rect);
    }
    this(ref const(QLocale) locale);
/+ #if QT_CONFIG(regularexpression) +/
    this(ref const(QRegularExpression) re);
/+ #endif // QT_CONFIG(regularexpression)
#if QT_CONFIG(easingcurve) +/
    this(ref const(QEasingCurve) easing);
/+ #endif +/
    this(ref const(QUuid) uuid);
/+ #ifndef QT_BOOTSTRAPPED +/
    this(ref const(QUrl) url);
//    this(ref const(QJsonValue) jsonValue);
//    this(ref const(QJsonObject) jsonObject);
//    this(ref const(QJsonArray) jsonArray);
//    this(ref const(QJsonDocument) jsonDocument);
/+ #endif // QT_BOOTSTRAPPED
#if QT_CONFIG(itemmodel) +/
    this(ref const(QModelIndex) modelIndex);
    this(ref const(QPersistentModelIndex) modelIndex);
/+ #endif +/

    /+ref QVariant operator =(ref const(QVariant) other);+/
    /+ inline QVariant(QVariant &&other) noexcept : d(other.d)
    { other.d = Private(); } +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QVariant) +/

    /+ inline void swap(QVariant &other) noexcept { qSwap(d, other.d); } +/

    int userType() const { return typeId(); }
    int typeId() const { return metaType().id(); }

    const(char)* typeName() const;
    QMetaType metaType() const;

    bool canConvert(QMetaType targetType) const
    { return QMetaType.canConvert(d.type(), targetType); }
    bool convert(QMetaType type);

    bool canView(QMetaType targetType) const
    { return QMetaType.canView(d.type(), targetType); }

/+ #if QT_DEPRECATED_SINCE(6, 0) +/
    /+ QT_DEPRECATED_VERSION_6_0 +/
        bool canConvert(int targetTypeId) const
    { return QMetaType.canConvert(d.type(), QMetaType(targetTypeId)); }
    /+ QT_DEPRECATED_VERSION_6_0 +/
        bool convert(int targetTypeId)
    { return convert(QMetaType(targetTypeId)); }
/+ #endif +/

    pragma(inline, true) bool isValid() const
    {
        return d.type().isValid();
    }
    bool isNull() const;

    void clear();

    void detach();
    pragma(inline, true) bool isDetached() const
    { return !d.is_shared || d.data.shared_.ref_.loadRelaxed() == 1; }

    int toInt(bool* ok = null) const;
    uint toUInt(bool* ok = null) const;
    qlonglong toLongLong(bool* ok = null) const;
    qulonglong toULongLong(bool* ok = null) const;
    bool toBool() const;
    double toDouble(bool* ok = null) const;
    float toFloat(bool* ok = null) const;
    qreal toReal(bool* ok = null) const;
    QByteArray toByteArray() const;
    QBitArray toBitArray() const;
    QString toString() const;
    QStringList toStringList() const;
    QChar toChar() const;
    QDate toDate() const;
    QTime toTime() const;
    QDateTime toDateTime() const;
    QList!(QVariant) toList() const;
//    QMap!(QString, QVariant) toMap() const;
//    QHash!(QString, QVariant) toHash() const;

    version(QT_NO_GEOM_VARIANT){}else
    {
        QPoint toPoint() const;
        QPointF toPointF() const;
        QRect toRect() const;
        QSize toSize() const;
        QSizeF toSizeF() const;
        QLine toLine() const;
        QLineF toLineF() const;
        QRectF toRectF() const;
    }
    QLocale toLocale() const;
/+ #if QT_CONFIG(regularexpression) +/
    QRegularExpression toRegularExpression() const;
/+ #endif // QT_CONFIG(regularexpression)
#if QT_CONFIG(easingcurve) +/
    QEasingCurve toEasingCurve() const;
/+ #endif +/
    QUuid toUuid() const;
/+ #ifndef QT_BOOTSTRAPPED +/
    QUrl toUrl() const;
    /+ QJsonValue toJsonValue() const; +/
    /+ QJsonObject toJsonObject() const; +/
    /+ QJsonArray toJsonArray() const; +/
    /+ QJsonDocument toJsonDocument() const; +/
/+ #endif // QT_BOOTSTRAPPED
#if QT_CONFIG(itemmodel) +/
    QModelIndex toModelIndex() const;
    QPersistentModelIndex toPersistentModelIndex() const;
/+ #endif

#ifndef QT_NO_DATASTREAM +/
    version(QT_NO_DATASTREAM){}else
    {
        void load(ref QDataStream ds);
        void save(ref QDataStream ds) const;
    }
/+ #endif
#if QT_DEPRECATED_SINCE(6, 0)
    QT_WARNING_PUSH
    QT_WARNING_DISABLE_DEPRECATED +/
    /+ QT_DEPRECATED_VERSION_X_6_0("Use the constructor taking a QMetaType instead.") +/
        /+ explicit +/this(Type type)
        {
            this(QMetaType(int(type)));
        }
    /+ QT_DEPRECATED_VERSION_X_6_0("Use typeId() or metaType().") +/
        Type type() const
    {
        int type = d.typeId();
        return type >= QMetaType.Type.User ? Type.UserType : static_cast!(Type)(type);
    }
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static const(char)* typeToName(int typeId)
    { return QMetaType(typeId).name(); }
    /+ QT_DEPRECATED_VERSION_6_0 +/
        static Type nameToType(const(char)* name)
    {
        import qt.core.bytearrayview;

        int metaType = QMetaType.fromName(cast(QByteArrayView)(name)).id();
        return metaType <= int(Type.UserType) ? cast(QVariant.Type)(metaType) : Type.UserType;
    }
    /+ QT_WARNING_POP
#endif +/

    void* data();
    const(void)* constData() const
    { return d.storage(); }
    pragma(inline, true) const(void)* data() const { return constData(); }

    /+ template<typename T, typename = std::enable_if_t<!std::is_same_v<std::decay_t<T>, QVariant>>> +/
    /+ void setValue(T &&avalue)
    {
        using VT = std::decay_t<T>;
        QMetaType metaType = QMetaType::fromType<VT>();
        // If possible we reuse the current QVariant private.
        if (isDetached() && d.type() == metaType) {
            *reinterpret_cast<VT *>(const_cast<void *>(constData())) = std::forward<T>(avalue);
        } else {
            *this = QVariant::fromValue<VT>(std::forward<T>(avalue));
        }
    } +/

    void setValue(ref const(QVariant) avalue)
    {
        this = avalue;
    }

    /+ void setValue(QVariant &&avalue)
    {
        *this = std::move(avalue);
    } +/

    pragma(inline, true) T value(T)() const
    { return qvariant_cast!(T)(this); }

    /+ template<typename T> +/
    /+ pragma(inline, true) T view(T)()
    {
        T t T();
        QMetaType.view(metaType(), data(), QMetaType.fromType!(T)(), &t);
        return t;
    } +/

    /+ template<typename T>
#ifndef Q_CLANG_QDOC +/
    pragma(inline, true) static QVariant fromValue(T)(ref const T value)/+ ->
        std::enable_if_t<std::is_copy_constructible_v<T>, QVariant> +/
/+ #else
    static inline QVariant fromValue(const T &value)
#endif +/
    {
        return QVariant(QMetaType.fromType!(T)(), &value);
    }

/+ #if (__has_include(<variant>) && __cplusplus >= 201703L) || defined(Q_CLANG_QDOC) +/
    /+ template<typename... Types> +/
    /+ static inline QVariant fromStdVariant(const std::variant<Types...> &value)
    {
        if (value.valueless_by_exception())
            return QVariant();
        return std::visit([](const auto &arg) { return fromValue(arg); }, value);
    } +/
/+ #endif +/

    /+ template<typename T> +/
    bool canConvert(T)() const
    { return canConvert(QMetaType.fromType!(T)()); }

    /+ template<typename T> +/
    bool canView(T)() const
    { return canView(QMetaType.fromType!(T)()); }

public:
    struct PrivateShared
    {
    private:
        @disable this();
        /+pragma(inline, true) this()
        {
            this.ref_ = 1;
        }+/
    public:
        /+ static PrivateShared *create(const QtPrivate::QMetaTypeInterface *type)
        {
            Q_ASSERT(type);
            size_t size = type->size;
            size_t align = type->alignment;

            size += sizeof(PrivateShared);
            if (align > sizeof(PrivateShared)) {
                // The alignment is larger than the alignment we can guarantee for the pointer
                // directly following PrivateShared, so we need to allocate some additional
                // memory to be able to fit the object into the available memory with suitable
                // alignment.
                size += align - sizeof(PrivateShared);
            }
            void *data = operator new(size);
            auto *ps = new (data) QVariant::PrivateShared();
            ps->offset = int(((quintptr(ps) + sizeof(PrivateShared) + align - 1) & ~(align - 1)) - quintptr(ps));
            return ps;
        } +/
        static void free(PrivateShared* p)
        {
            destroy!false(p);
//            operator delete(p);
        }

        /+ alignas(8) +/ QAtomicInt ref_ = QAtomicInt(1);
        int offset;

        const(void)* data() const
        { return reinterpret_cast!(const(ubyte)*)(&this) + offset; }
        void* data()
        { return reinterpret_cast!(ubyte*)(&this) + offset; }
    }
    struct Private
    {
        extern(D) static immutable size_t MaxInternalSize = 3*(void*).sizeof;
        /+ template<typename T> +/
        /+ static constexpr bool CanUseInternalSpace = (QTypeInfo<T>::isRelocatable && sizeof(T) <= MaxInternalSize && alignof(T) <= alignof(double)); +/
        static bool canUseInternalSpace(/+ QtPrivate:: +/qt.core.metatype.QMetaTypeInterface* type)
        {
            import qt.core.flags;

            (mixin(Q_ASSERT(q{type})));
            return QMetaType.TypeFlags(cast(QFlag)(type.flags)) & QMetaType.TypeFlag.RelocatableType &&
                   size_t(type.size) <= MaxInternalSize && size_t(type.alignment) <= double.alignof;
        }

        union generated_qvariant_0
        {
            uchar[MaxInternalSize] data = [0];
            PrivateShared* shared_;
            double _forAlignment; // we want an 8byte alignment on 32bit systems as well
        }generated_qvariant_0 data;
        quintptr bitfield = 1 << 1;
        /+ quintptr is_shared : 1; +/
        final quintptr is_shared() const
        {
            return (bitfield >> 0) & 0x1;
        }
        final quintptr is_shared(quintptr value)
        {
            bitfield = (bitfield & ~0x1) | ((value & 0x1) << 0);
            return value;
        }
        /+ quintptr is_null : 1; +/
        final quintptr is_null() const
        {
            return (bitfield >> 1) & 0x1;
        }
        final quintptr is_null(quintptr value)
        {
            bitfield = (bitfield & ~0x2) | ((value & 0x1) << 1);
            return value;
        }
        /+ quintptr packedType : sizeof(QMetaType) * 8 - 2; +/
        final quintptr packedType() const
        {
            return (bitfield >> 2) & 0x1;
        }
        final quintptr packedType(quintptr value)
        {
            bitfield = (bitfield & ~0x4) | ((value & 0x1) << 2);
            return value;
        }

        //@disable this();
        /+this()/+ noexcept+/
        {
            this.is_shared = false;
            this.is_null = true;
            this.packedType = 0;
        }+/
        /+ explicit +/this(QMetaType type)/+ noexcept+/
        {
            this.is_shared = false;
            this.is_null = false;

            quintptr mt = cast(quintptr)(type.d_ptr);
            (mixin(Q_ASSERT(q{(mt & 0x3) == 0})));
            packedType = mt >> 2;
        }
        /+ explicit +/this(int type)/+ noexcept+/
        {
            this(QMetaType(type));
        }

        const(void)* storage() const return
        { return is_shared ? data.shared_.data() : &data.data; }

        const(void)* internalStorage() const return
        { (mixin(Q_ASSERT(q{QVariant.Private.is_shared}))); return &data.data; }

        // determine internal storage at compile time
        /+ template<typename T> +/
        ref const(T) get(T)() const
        { return *static_cast!(const(T)*)(storage()); }
        /+ template<typename T> +/
        void set(T)(ref const(T) t)
        { *static_cast!(T*)(CanUseInternalSpace!(T) ? &data.data : data.shared_.data()) = t; }

        pragma(inline, true) QMetaType type() const
        {
            return QMetaType(reinterpret_cast!(/+ QtPrivate:: +/qt.core.metatype.QMetaTypeInterface*)(packedType << 2));
        }

        pragma(inline, true) /+ QtPrivate:: +/qt.core.metatype.QMetaTypeInterface*  typeInterface() const
        {
            return reinterpret_cast!(/+ QtPrivate:: +/qt.core.metatype.QMetaTypeInterface*)(packedType << 2);
        }

        pragma(inline, true) int typeId() const
        {
            return type().id();
        }
    }
 public:
    static QPartialOrdering compare(ref const(QVariant) lhs, ref const(QVariant) rhs);

private:
    /+ friend inline bool operator==(const QVariant &a, const QVariant &b)
    { return a.equals(b); } +/
    /+ friend inline bool operator!=(const QVariant &a, const QVariant &b)
    { return !a.equals(b); } +/
/+ #ifndef QT_NO_DEBUG_STREAM
    template <typename T>
    friend auto operator<<(const QDebug &debug, const T &variant) -> std::enable_if_t<std::is_same_v<T, QVariant>, QDebug> {
        return  variant.qdebugHelper(debug);
    }
    QDebug qdebugHelper(QDebug) const;
#endif +/
    /+ template<typename T> +/
    /+ friend inline T qvariant_cast(const QVariant &); +/
protected:
    Private d;
    /+ void create(int type, const void *copy); +/
    /+ void create(QMetaType type, const void *copy); +/
    bool equals(ref const(QVariant) other) const;
    bool convert(int type, void* ptr) const;
    bool view(int type, void* ptr);

private:
    // force compile error, prevent QVariant(bool) to be called
    pragma(inline, true) @disable this(void* ) /+ = delete +/;
    // QVariant::Type is marked as \obsolete, but we don't want to
    // provide a constructor from its intended replacement,
    // QMetaType::Type, instead, because the idea behind these
    // constructors is flawed in the first place. But we also don't
    // want QVariant(QMetaType::String) to compile and falsely be an
    // int variant, so delete this constructor:
    @disable this(QMetaType.Type) /+ = delete +/;

    // These constructors don't create QVariants of the type associated
    // with the enum, as expected, but they would create a QVariant of
    // type int with the value of the enum value.
    // Use QVariant v = QColor(Qt::red) instead of QVariant v = Qt::red for
    // example.
    @disable this(/+ Qt:: +/qt.core.namespace.GlobalColor) /+ = delete +/;
    @disable this(/+ Qt:: +/qt.core.namespace.BrushStyle) /+ = delete +/;
    @disable this(/+ Qt:: +/qt.core.namespace.PenStyle) /+ = delete +/;
    @disable this(/+ Qt:: +/qt.core.namespace.CursorShape) /+ = delete +/;
/+ #ifdef QT_NO_CAST_FROM_ASCII +/
    // force compile error when implicit conversion is not wanted
    pragma(inline, true) @disable this(const(char)* ) /+ = delete +/;
/+ #endif +/
public:
    alias DataPtr = Private;
    pragma(inline, true) ref DataPtr data_ptr() return { return d; }
    pragma(inline, true) ref const(DataPtr) data_ptr() const return { return d; }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ template<>
#if __has_include(<variant>) && __cplusplus >= 201703L
template<>
inline QVariant QVariant::fromValue(const std::monostate &)
{
    return QVariant();
}
#endif

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &s, QVariant &p);
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &s, const QVariant &p);

#if QT_DEPRECATED_SINCE(6, 0)
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_DEPRECATED_VERSION_6_0
inline QDataStream &operator>>(QDataStream &s, QVariant::Type &p)
{
    quint32 u;
    s >> u;
    p = static_cast<QVariant::Type>(u);
    return s;
}
QT_DEPRECATED_VERSION_6_0
inline QDataStream &operator<<(QDataStream &s, const QVariant::Type p)
{
    s << static_cast<quint32>(p);
    return s;
}
QT_WARNING_POP
#endif

#endif

Q_DECLARE_SHARED(QVariant) +/

version(QT_MOC){}else
{

/+pragma(inline, true) T qvariant_cast(T)(ref const(QVariant) v)
{
    QMetaType targetType = QMetaType.fromType!(T)();
    if (v.d.type() == targetType)
        return v.d.get<TT>();
    static if (/+ std:: +/is_same_v!(T,const(/+ std:: +/remove_const_t!(/+ std:: +/remove_pointer_t!(T)))*)) {
        alias nonConstT = /+ std:: +/remove_const_t!(/+ std:: +/remove_pointer_t!(T))*;
        QMetaType nonConstTargetType = QMetaType.fromType!(nonConstT)();
        if (v.d.type() == nonConstTargetType)
            return v.d.get<nonConstTnonConstT>();
    }

    T t T();
    QMetaType.convert(v.metaType(), v.constData(), targetType, &t);
    return t;
}

/+ template<> +/ 
pragma(inline, true) QVariant qvariant_cast(ref const(QVariant) v)
{
    if (v.metaType().id() == QMetaType.Type.QVariant)
        return *reinterpret_cast!(const(QVariant)*)(v.constData());
    return v;
}+/

}

/+ #ifndef QT_NO_DEBUG_STREAM
#if QT_DEPRECATED_SINCE(6, 0)
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_DEPRECATED_VERSION_6_0
Q_CORE_EXPORT QDebug operator<<(QDebug, const QVariant::Type);
QT_WARNING_POP
#endif
#endif +/

extern(C++, "QtPrivate") {
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QVariantTypeCoercer
{
public:
    const(void)* convert(ref const(QVariant) value, ref const(QMetaType) type);
    const(void)* coerce(ref const(QVariant) value, ref const(QMetaType) type);

private:
    QVariant converted;
}
}

/// Binding for C++ class [QVariantRef](https://doc.qt.io/qt-6/qvariantref.html).
extern(C++, class) struct QVariantRef(Pointer)
{
private:
    const(Pointer)* m_pointer = null;

public:
    /+ explicit +/this(const(Pointer)* reference)
    {
        this.m_pointer = reference;
    }
    /+ QVariantRef(const QVariantRef &) = default; +/
    /+ QVariantRef(QVariantRef &&) = default; +/
    /+ ~QVariantRef() = default; +/

    /+auto opCast(T : QVariant)() const;+/
    /+ref QVariantRef operator =(ref const(QVariant) value);+/
    /+ref QVariantRef operator =(ref const(QVariantRef) value) { return operator=(QVariant(value)); }+/
    /+ QVariantRef &operator=(QVariantRef &&value) { return operator=(QVariant(value)); } +/

    /+ friend void swap(QVariantRef a, QVariantRef b)
    {
        QVariant tmp = a;
        a = b;
        b = std::move(tmp);
    } +/
}

/// Binding for C++ class [QVariantConstPointer](https://doc.qt.io/qt-6/qvariantconstpointer.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QVariantConstPointer
{
private:
    QVariant m_variant;

public:
    /+ explicit +/this(QVariant variant);

    QVariant opUnary(string op)() const if(op == "*");
    /+const(QVariant)* operator ->() const;+/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/// Binding for C++ class [QVariantPointer](https://doc.qt.io/qt-6/qvariantpointer.html).
class QVariantPointer(Pointer)
{
private:
    const(Pointer)* m_pointer = null;

public:
    /+ explicit +/this(const(Pointer)* pointer)
    {
        this.m_pointer = pointer;
    }
    //final QVariantRef!(Pointer) opUnary(string op)() const if(op == "*") { return QVariantRef!(Pointer)(cast(QVariantRef && )(m_pointer)); }
    /+final Pointer operator ->() const { return *m_pointer; }+/
}

pragma(inline, true) T qvariant_cast(T)(ref const(QVariant) v)
{
    // TODO: special cases of qvariant_cast
    static if(is(T == class))
        static assert(false);
    else
    {
        const(int) vid = qMetaTypeId!(T)();
        if (vid == v.userType())
            return *reinterpret_cast!(T*)(v.constData());
        static if(__traits(hasMember, T, "rawConstructor"))
            mixin("T t = T.init; t.rawConstructor();");
        else
            mixin("T t;");
        if (v.convert(vid, &t))
            return t;
        static if(__traits(hasMember, T, "rawConstructor"))
            mixin("T r = T.init; r.rawConstructor(); return r;");
        else
            mixin("return T();");
    }
}
pragma(inline, true) T qvariant_cast(T)(const(QVariant) v)
{
    return qvariant_cast!T(v);
}

