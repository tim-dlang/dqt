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

import core.stdc.config;
import qt.config;
import qt.core.abstractitemmodel;
import qt.core.atomic;
import qt.core.bitarray;
import qt.core.bytearray;
import qt.core.datetime;
import qt.core.easingcurve;
import qt.core.global;
import qt.core.hash;
import qt.core.list;
import qt.core.locale;
import qt.core.map;
import qt.core.metatype;
import qt.core.namespace;
import qt.core.object;
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
version(QT_NO_REGEXP){}else
    import qt.core.regexp;

/+ #ifndef QT_BOOTSTRAPPED
#endif

#if __has_include(<variant>) && __cplusplus >= 201703L
#elif defined(Q_CLANG_QDOC)
namespace std { template<typename...> struct variant; }
#endif



#if QT_CONFIG(easingcurve)
class QEasingCurve;
#endif
#ifndef QT_NO_REGEXP
#endif // QT_NO_REGEXP
#if QT_CONFIG(regularexpression)
class QRegularExpression;
#endif +/ // QT_CONFIG(regularexpression)

// pragma(inline, true) T qvariant_cast(T)(ref const(QVariant) );

extern(C++, "QtPrivate") {

    struct ObjectInvoker(Derived, Argument, ReturnType)
    {
        static ReturnType invoke(Argument a)
        {
            return Derived.object(a);
        }
    }

    struct MetaTypeInvoker(Derived, Argument, ReturnType)
    {
        static ReturnType invoke(Argument a)
        {
            return Derived.metaType(a);
        }
    }

    struct TreatAsQObjectBeforeMetaType(Derived, T, Argument, ReturnType, /+ bool +/ /+ = IsPointerToTypeDerivedFromQObject<T>::Value +/)
    {
        ObjectInvoker!(Derived, Argument, ReturnType) base0;
        alias base0 this;
    }

    /+ template <typename Derived, typename T, typename Argument, typename ReturnType>
    struct TreatAsQObjectBeforeMetaType<Derived, T, Argument, ReturnType, false> : MetaTypeInvoker<Derived, Argument, ReturnType>
    {
    };

    template<typename T> struct QVariantValueHelper; +/
}

/// Binding for C++ class [QVariant](https://doc.qt.io/qt-5/qvariant.html).
@Q_MOVABLE_TYPE extern(C++, class) struct /+ Q_CORE_EXPORT +/ QVariant
{
 public:
    enum Type {
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
        RegExp = QMetaType.Type.QRegExp,
        RegularExpression = QMetaType.Type.QRegularExpression,
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
        KeySequence = QMetaType.Type.QKeySequence,
        Pen = QMetaType.Type.QPen,
        TextLength = QMetaType.Type.QTextLength,
        TextFormat = QMetaType.Type.QTextFormat,
        Matrix = QMetaType.Type.QMatrix,
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

    /+this()/+ noexcept+/
    {
        this.d = typeof(this.d)();
    }+/
    ~this();
    this(Type type);
    this(int typeId, const(void)* copy);
    this(int typeId, const(void)* copy, uint flags);
    @disable this(this);
    this(ref const(QVariant) other);

    version(QT_NO_DATASTREAM){}else
    {
        this(ref QDataStream s);
    }

    this(int i);
    this(uint ui);
    this(qlonglong ll);
    this(qulonglong ull);
    this(bool b);
    this(double d);
    this(float f);
/+ #ifndef QT_NO_CAST_FROM_ASCII
    QT_ASCII_CAST_WARN QVariant(const char *str);
#endif +/

    this(ref const(QByteArray) bytearray);
    this(ref const(QBitArray) bitarray);
    this(ref const(QString) string);
    this(QLatin1String string);
    this(ref const(QStringList) stringlist);
    this(QChar qchar);
    this(ref const(QDate) date);
    this(ref const(QTime) time);
    this(ref const(QDateTime) datetime);
    this(ref const(QList!(QVariant)) list);
//    this(ref const(QMap!(QString,QVariant)) map);
//    this(ref const(QHash!(QString,QVariant)) hash);
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
/+ #ifndef QT_NO_REGEXP +/
    version(QT_NO_REGEXP){}else
    {
        this(ref const(QRegExp) regExp);
    }
/+ #endif // QT_NO_REGEXP
#if QT_CONFIG(regularexpression) +/
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
    /+ inline QVariant &operator=(QVariant &&other) noexcept
    { qSwap(d, other.d); return *this; } +/

    /+ inline void swap(QVariant &other) noexcept { qSwap(d, other.d); } +/

    Type type() const;
    int userType() const;
    const(char)* typeName() const;

    bool canConvert(int targetTypeId) const;
    bool convert(int targetTypeId);

    pragma(inline, true) bool isValid() const { return d.type != Type.Invalid; }
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
/+ #ifndef QT_NO_REGEXP +/
    version(QT_NO_REGEXP){}else
    {
        QRegExp toRegExp() const;
    }
/+ #endif // QT_NO_REGEXP
#if QT_CONFIG(regularexpression) +/
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
/+ #endif +/
    static const(char)* typeToName(int typeId);
    static Type nameToType(const(char)* name);

    void* data();
    const(void)* constData() const;
    pragma(inline, true) const(void)* data() const { return constData(); }

    /+ template<typename T> +/
    pragma(inline, true) void setValue(T)(ref const(T) avalue)
    {
        import core.lifetime;

        // If possible we reuse the current QVariant private.
        const(uint) type = qMetaTypeId!(T)();
        if (isDetached() && (type == d.type || (type <= uint(QVariant.Type.Char) && d.type <= uint(QVariant.Type.Char)))) {
            d.type = type;
            d.is_null = false;
            T* old = reinterpret_cast!(T*)(d.is_shared ? d.data.shared_.ptr : &d.data.ptr);
            if (QTypeInfo!(T).isComplex)
                destroy!false(old);
            emplace!T(old, avalue); // call the copy constructor
        } else {
            this = QVariant(type, &avalue, QTypeInfo!(T).isPointer);
        }
    }

    pragma(inline, true) T value(T)() const
    { return qvariant_cast!T(this); }

    static QVariant fromValue(T)(ref const T value)
    {
        import std.traits;
        return QVariant(qMetaTypeId!T(), &value, isPointer!T);
    }

/+ #if (__has_include(<variant>) && __cplusplus >= 201703L) || defined(Q_CLANG_QDOC)
    template<typename... Types>
    static inline QVariant fromStdVariant(const std::variant<Types...> &value)
    {
        if (value.valueless_by_exception())
            return QVariant();
        return std::visit([](const auto &arg) { return fromValue(arg); }, value);
    }
#endif +/

    /+ template<typename T> +/
    bool canConvert(T)() const
    { return canConvert(qMetaTypeId!(T)()); }

 public:
    struct PrivateShared
    {
        pragma(inline, true) this(void* v)
        {
            this.ptr = v;
            this.ref_ = 1;
        }
        void* ptr;
        QAtomicInt ref_;
    }
    struct Private
    {
        /+pragma(inline, true) this()/+ noexcept+/
        {
            this.type = Type.Invalid;
            this.is_shared = false;
            this.is_null = true;
            data.ptr = null;
        }+/

        // Internal constructor for initialized variants.
        /+ explicit +/ pragma(inline, true) this(uint variantType)/+ noexcept+/
        {
            this.type = variantType;
            this.is_shared = false;
            this.is_null = false;
        }

/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
        @disable this(this);
        this(ref const(Private) other)/+ noexcept+/
        {
            this.data = *cast(Data*)&other.data;
            this.type = other.type;
            this.is_shared = other.is_shared;
            this.is_null = other.is_null;
        }
        /+ Private &operator=(const Private &other) noexcept = default; +/
/+ #endif +/
        union Data
        {
            QObject o = null;
            char c;
            uchar uc;
            short s;
            byte  sc;
            ushort us;
            int i;
            uint u;
            cpp_long l;
            cpp_ulong ul;
            bool b;
            double d;
            float f;
            qreal real_;
            qlonglong ll;
            qulonglong ull;
            void* ptr;
            PrivateShared* shared_;
        }Data data;
        /+ uint type : 30; +/
        uint bitfieldData_type = Type.Invalid | (uint(1) << 31);
        final uint type() const
        {
            return (bitfieldData_type >> 0) & 0x3fffffff;
        }
        final uint type(uint value)
        {
            bitfieldData_type = (bitfieldData_type & ~0x3fffffff) | ((value & 0x3fffffff) << 0);
            return value;
        }
        /+ uint is_shared : 1; +/
        final uint is_shared() const
        {
            return (bitfieldData_type >> 30) & 0x1;
        }
        final uint is_shared(uint value)
        {
            bitfieldData_type = (bitfieldData_type & ~0x40000000) | ((value & 0x1) << 30);
            return value;
        }
        /+ uint is_null : 1; +/
        final uint is_null() const
        {
            return (bitfieldData_type >> 31) & 0x1;
        }
        final uint is_null(uint value)
        {
            bitfieldData_type = (bitfieldData_type & ~0x80000000) | ((value & 0x1) << 31);
            return value;
        }
    }
 public:
    alias f_construct = ExternCPPFunc!(void function(Private* , const(void)* ));
    alias f_clear = ExternCPPFunc!(void function(Private* ));
    alias f_null = ExternCPPFunc!(bool function(const(Private)* ));
    version(QT_NO_DATASTREAM){}else
    {
        alias f_load = ExternCPPFunc!(void function(Private* , ref QDataStream ));
        alias f_save = ExternCPPFunc!(void function(const(Private)* , ref QDataStream ));
    }
    alias f_compare = ExternCPPFunc!(bool function(const(Private)* , const(Private)* ));
    alias f_convert = ExternCPPFunc!(bool function(const(Private)* d, int t, void* , bool* ));
    alias f_canConvert = ExternCPPFunc!(bool function(const(Private)* d, int t));
    /+ typedef void (*f_debugStream)(QDebug, const QVariant &); +/
    /+ struct Handler {
        f_construct construct;
        f_clear clear;
        f_null isNull;
#ifndef QT_NO_DATASTREAM
        f_load load;
        f_save save;
#endif
        f_compare compare;
        f_convert convert;
        f_canConvert canConvert;
        f_debugStream debugStream;
    }; +/

    /+pragma(inline, true) bool operator ==(ref const(QVariant) v) const
    { return cmp(v); }+/
    /+pragma(inline, true) bool operator !=(ref const(QVariant) v) const
    { return !cmp(v); }+/
/+ #if QT_DEPRECATED_SINCE(5, 15) +/
    /+/+ QT_DEPRECATED +/ pragma(inline, true) bool operator <(ref const(QVariant) v) const
    { return compare(v) < 0; }+/
    /+/+ QT_DEPRECATED +/ pragma(inline, true) bool operator <=(ref const(QVariant) v) const
    { return compare(v) <= 0; }+/
    /+/+ QT_DEPRECATED +/ pragma(inline, true) bool operator >(ref const(QVariant) v) const
    { return compare(v) > 0; }+/
    /+/+ QT_DEPRECATED +/ pragma(inline, true) bool operator >=(ref const(QVariant) v) const
    { return compare(v) >= 0; }+/
/+ #endif +/

protected:
    /+ friend inline bool operator==(const QVariant &, const QVariantComparisonHelper &); +/
/+ #ifndef QT_NO_DEBUG_STREAM
    friend Q_CORE_EXPORT QDebug operator<<(QDebug, const QVariant &);
#endif
// ### Qt6: FIXME: Remove the special Q_CC_MSVC handling, it was introduced to maintain BC for QTBUG-41810 .
#if !defined(Q_NO_TEMPLATE_FRIENDS) && !defined(Q_CC_MSVC) +/
    /*static if (!defined!"Q_NO_TEMPLATE_FRIENDS")
    {
        /+ template<typename T> +/
        /+ friend inline T qvariant_cast(const QVariant &); +/
        /+ template<typename T> +/ /+ friend struct QtPrivate::QVariantValueHelper; +/
    protected:
    }
    else
    {
    /+ #else +/
    public:
    }*/
    public:
/+ #endif +/
    Private d;
    /+ void create(int type, const void *copy); +/
    bool cmp(ref const(QVariant) other) const;
    int compare(ref const(QVariant) other) const;
    bool convert(const(int) t, void* ptr) const; // ### Qt6: drop const

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

    // These constructors don't create QVariants of the type associcated
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

/+ #if QT_DEPRECATED_SINCE(5, 14) +/
/+ QT_DEPRECATED_X("Use QVariant::fromValue() instead.") +/
pragma(inline, true) QVariant qVariantFromValue(T)(ref const(T) t)
{
    return QVariant.fromValue(t);
}

/+ QT_DEPRECATED_X("Use QVariant::setValue() instead.") +/
pragma(inline, true) void qVariantSetValue(T)(ref QVariant v, ref const(T) t)
{
    v.setValue(t);
}
/+ #endif

template<>
#if __has_include(<variant>) && __cplusplus >= 201703L
template<>
inline QVariant QVariant::fromValue(const std::monostate &)
{
    return QVariant();
}
#endif

template<>
#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream& operator>> (QDataStream& s, QVariant& p);
Q_CORE_EXPORT QDataStream& operator<< (QDataStream& s, const QVariant& p);
Q_CORE_EXPORT QDataStream& operator>> (QDataStream& s, QVariant::Type& p);
Q_CORE_EXPORT QDataStream& operator<< (QDataStream& s, const QVariant::Type p);
#endif


#ifdef Q_QDOC
    inline bool operator==(const QVariant &v1, const QVariant &v2);
    inline bool operator!=(const QVariant &v1, const QVariant &v2);
#else +/

/* Helper class to add one more level of indirection to prevent
   implicit casts.
*/
extern(C++, class) struct QVariantComparisonHelper
{
public:
    pragma(inline, true) this(ref const(QVariant) var)
    {
        this.v = &var;
    }
private:
    /+ friend inline bool operator==(const QVariant &, const QVariantComparisonHelper &); +/
    const(QVariant)* v;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+pragma(inline, true) bool operator ==(ref const(QVariant) v1, ref const(QVariantComparisonHelper) v2)
{
    return v1.cmp(*v2.v);
}+/

/+pragma(inline, true) bool operator !=(ref const(QVariant) v1, ref const(QVariantComparisonHelper) v2)
{
    return !operator==(v1, v2);
}+/
/+ #endif
Q_DECLARE_SHARED(QVariant) +/

/+
/// Binding for C++ class [QSequentialIterable](https://doc.qt.io/qt-5/qsequentialiterable.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QSequentialIterable
{
private:
    /+ QtMetaTypePrivate:: +/QSequentialIterableImpl m_impl;
public:
    struct /+ Q_CORE_EXPORT +/ const_iterator
    {
    private:
        /+ QtMetaTypePrivate:: +/QSequentialIterableImpl m_impl;
        QAtomicInt* ref_;
        /+ friend class QSequentialIterable; +/
        /+ explicit +/this(ref const(QSequentialIterable) iter, QAtomicInt* ref_);

        /+ explicit +/this(ref const(/+ QtMetaTypePrivate:: +/QSequentialIterableImpl) impl, QAtomicInt* ref_);

        void begin();
        void end();
    public:
        ~this();

        @disable this(this);
        this(ref const(const_iterator) other);

        /+ref const_iterator operator =(ref const(const_iterator) other);+/

        const(QVariant) opUnary(string op)() const if (op == "*");
        /+bool operator ==(ref const(const_iterator) o) const;+/
        /+bool operator !=(ref const(const_iterator) o) const;+/
        ref const_iterator opUnary(string op)() if (op == "++");
        /+const_iterator operator ++(int);+/
        ref const_iterator opUnary(string op)() if (op == "--");
        /+const_iterator operator --(int);+/
        ref const_iterator opOpAssign(string op)(int j) if (op == "+");
        ref const_iterator opOpAssign(string op)(int j) if (op == "-");
        const_iterator opBinary(string op)(int j) const if (op == "+");
        const_iterator opBinary(string op)(int j) const if (op == "-");
        /+ friend inline const_iterator operator+(int j, const_iterator k) { return k + j; } +/
    }

    /+ friend struct const_iterator; +/

/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    /+ explicit +/this(/+ QtMetaTypePrivate:: +/QSequentialIterableImpl impl);
/+ #else
    explicit QSequentialIterable(const QtMetaTypePrivate::QSequentialIterableImpl &impl);
#endif +/

    const_iterator begin() const;
    const_iterator end() const;

    QVariant at(int idx) const;
    int size() const;

    bool canReverseIterate() const;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}+/

/+
/// Binding for C++ class [QAssociativeIterable](https://doc.qt.io/qt-5/qassociativeiterable.html).
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QAssociativeIterable
{
private:
    /+ QtMetaTypePrivate:: +/QAssociativeIterableImpl m_impl;
public:
    struct /+ Q_CORE_EXPORT +/ const_iterator
    {
    private:
        /+ QtMetaTypePrivate:: +/QAssociativeIterableImpl m_impl;
        QAtomicInt* ref_;
        /+ friend class QAssociativeIterable; +/
        /+ explicit +/this(ref const(QAssociativeIterable) iter, QAtomicInt* ref_);

        /+ explicit +/this(ref const(/+ QtMetaTypePrivate:: +/QAssociativeIterableImpl) impl, QAtomicInt* ref_);

        void begin();
        void end();
        /+ void find(const QVariant &key); +/
    public:
        ~this();
        @disable this(this);
        this(ref const(const_iterator) other);

        /+ref const_iterator operator =(ref const(const_iterator) other);+/

        const(QVariant) key() const;

        const(QVariant) value() const;

        const(QVariant) opUnary(string op)() const if (op == "*");
        /+bool operator ==(ref const(const_iterator) o) const;+/
        /+bool operator !=(ref const(const_iterator) o) const;+/
        ref const_iterator opUnary(string op)() if (op == "++");
        /+const_iterator operator ++(int);+/
        ref const_iterator opUnary(string op)() if (op == "--");
        /+const_iterator operator --(int);+/
        ref const_iterator opOpAssign(string op)(int j) if (op == "+");
        ref const_iterator opOpAssign(string op)(int j) if (op == "-");
        const_iterator opBinary(string op)(int j) const if (op == "+");
        const_iterator opBinary(string op)(int j) const if (op == "-");
        /+ friend inline const_iterator operator+(int j, const_iterator k) { return k + j; } +/
    }

    /+ friend struct const_iterator; +/

/+ #if QT_VERSION < QT_VERSION_CHECK(6, 0, 0) +/
    /+ explicit +/this(/+ QtMetaTypePrivate:: +/QAssociativeIterableImpl impl);
/+ #else
    explicit QAssociativeIterable(const QtMetaTypePrivate::QAssociativeIterableImpl &impl);
#endif +/

    const_iterator begin() const;
    const_iterator end() const;
    /+ const_iterator find(const QVariant &key) const; +/

    QVariant value(ref const(QVariant) key) const;

    int size() const;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}+/

version(QT_MOC){}else
{
/+extern(C++, "QtPrivate") {
    /+ template<typename T>
    struct QVariantValueHelper : TreatAsQObjectBeforeMetaType<QVariantValueHelper<T>, T, const QVariant &, T>
    {
        static T metaType(const QVariant &v)
        {
            const int vid = qMetaTypeId<T>();
            if (vid == v.userType())
                return *reinterpret_cast<const T *>(v.constData());
            T t;
            if (v.convert(vid, &t))
                return t;
            return T();
        }
#ifndef QT_NO_QOBJECT
        static T object(const QVariant &v)
        {
            return qobject_cast<T>(QMetaType::typeFlags(v.userType()) & QMetaType::PointerToQObject
                ? v.d.data.o
                : QVariantValueHelper::metaType(v));
        }
#endif
    }; +/

    struct QVariantValueHelperInterface(T)
    {
        QVariantValueHelper!(T) base0;
        alias base0 this;
    }

    /+ template<>
    struct QVariantValueHelperInterface<QSequentialIterable>
    {
        static QSequentialIterable invoke(const QVariant &v)
        {
            const int typeId = v.userType();
            if (typeId == qMetaTypeId<QVariantList>()) {
                return QSequentialIterable(QtMetaTypePrivate::QSequentialIterableImpl(reinterpret_cast<const QVariantList*>(v.constData())));
            }
            if (typeId == qMetaTypeId<QStringList>()) {
                return QSequentialIterable(QtMetaTypePrivate::QSequentialIterableImpl(reinterpret_cast<const QStringList*>(v.constData())));
            }
#ifndef QT_BOOTSTRAPPED
            if (typeId == qMetaTypeId<QByteArrayList>()) {
                return QSequentialIterable(QtMetaTypePrivate::QSequentialIterableImpl(reinterpret_cast<const QByteArrayList*>(v.constData())));
            }
#endif
            return QSequentialIterable(qvariant_cast<QtMetaTypePrivate::QSequentialIterableImpl>(v));
        }
    };
    template<>
    struct QVariantValueHelperInterface<QAssociativeIterable>
    {
        static QAssociativeIterable invoke(const QVariant &v)
        {
            const int typeId = v.userType();
            if (typeId == qMetaTypeId<QVariantMap>()) {
                return QAssociativeIterable(QtMetaTypePrivate::QAssociativeIterableImpl(reinterpret_cast<const QVariantMap*>(v.constData())));
            }
            if (typeId == qMetaTypeId<QVariantHash>()) {
                return QAssociativeIterable(QtMetaTypePrivate::QAssociativeIterableImpl(reinterpret_cast<const QVariantHash*>(v.constData())));
            }
            return QAssociativeIterable(qvariant_cast<QtMetaTypePrivate::QAssociativeIterableImpl>(v));
        }
    };
    template<>
    struct QVariantValueHelperInterface<QVariantList>
    {
        static QVariantList invoke(const QVariant &v)
        {
            const int typeId = v.userType();
            if (typeId == qMetaTypeId<QStringList>() || typeId == qMetaTypeId<QByteArrayList>() ||
                (QMetaType::hasRegisteredConverterFunction(typeId, qMetaTypeId<QtMetaTypePrivate::QSequentialIterableImpl>()) && !QMetaType::hasRegisteredConverterFunction(typeId, qMetaTypeId<QVariantList>()))) {
                QSequentialIterable iter = QVariantValueHelperInterface<QSequentialIterable>::invoke(v);
                QVariantList l;
                l.reserve(iter.size());
                for (QSequentialIterable::const_iterator it = iter.begin(), end = iter.end(); it != end; ++it)
                    l << *it;
                return l;
            }
            return QVariantValueHelper<QVariantList>::invoke(v);
        }
    };
    template<>
    struct QVariantValueHelperInterface<QVariantHash>
    {
        static QVariantHash invoke(const QVariant &v)
        {
            const int typeId = v.userType();
            if (typeId == qMetaTypeId<QVariantMap>() || ((QMetaType::hasRegisteredConverterFunction(typeId, qMetaTypeId<QtMetaTypePrivate::QAssociativeIterableImpl>())) && !QMetaType::hasRegisteredConverterFunction(typeId, qMetaTypeId<QVariantHash>()))) {
                QAssociativeIterable iter = QVariantValueHelperInterface<QAssociativeIterable>::invoke(v);
                QVariantHash l;
                l.reserve(iter.size());
                for (QAssociativeIterable::const_iterator it = iter.begin(), end = iter.end(); it != end; ++it)
                    static_cast<QMultiHash<QString, QVariant> &>(l).insert(it.key().toString(), it.value());
                return l;
            }
            return QVariantValueHelper<QVariantHash>::invoke(v);
        }
    };
    template<>
    struct QVariantValueHelperInterface<QVariantMap>
    {
        static QVariantMap invoke(const QVariant &v)
        {
            const int typeId = v.userType();
            if (typeId == qMetaTypeId<QVariantHash>() || (QMetaType::hasRegisteredConverterFunction(typeId, qMetaTypeId<QtMetaTypePrivate::QAssociativeIterableImpl>()) && !QMetaType::hasRegisteredConverterFunction(typeId, qMetaTypeId<QVariantMap>()))) {
                QAssociativeIterable iter = QVariantValueHelperInterface<QAssociativeIterable>::invoke(v);
                QVariantMap l;
                for (QAssociativeIterable::const_iterator it = iter.begin(), end = iter.end(); it != end; ++it)
                    static_cast<QMultiMap<QString, QVariant> &>(l).insert(it.key().toString(), it.value());
                return l;
            }
            return QVariantValueHelper<QVariantMap>::invoke(v);
        }
    };
    template<>
    struct QVariantValueHelperInterface<QPair<QVariant, QVariant> >
    {
        static QPair<QVariant, QVariant> invoke(const QVariant &v)
        {
            const int typeId = v.userType();

            if (QMetaType::hasRegisteredConverterFunction(typeId, qMetaTypeId<QtMetaTypePrivate::QPairVariantInterfaceImpl>()) && !(typeId == qMetaTypeId<QPair<QVariant, QVariant> >())) {
                QtMetaTypePrivate::QPairVariantInterfaceImpl pi = v.value<QtMetaTypePrivate::QPairVariantInterfaceImpl>();
                const QtMetaTypePrivate::VariantData d1 = pi.first();
                QVariant v1(d1.metaTypeId, d1.data, d1.flags);
                if (d1.metaTypeId == qMetaTypeId<QVariant>())
                    v1 = *reinterpret_cast<const QVariant*>(d1.data);

                const QtMetaTypePrivate::VariantData d2 = pi.second();
                QVariant v2(d2.metaTypeId, d2.data, d2.flags);
                if (d2.metaTypeId == qMetaTypeId<QVariant>())
                    v2 = *reinterpret_cast<const QVariant*>(d2.data);

                return QPair<QVariant, QVariant>(v1, v2);
            }
            return QVariantValueHelper<QPair<QVariant, QVariant> >::invoke(v);
        }
    }; +/
}+/

pragma(inline, true) T qvariant_cast(T)(ref const(QVariant) v)
{
    // TODO: special cases of qvariant_cast
    static if (is(T == class))
        static assert(false);
    else
    {
        const(int) vid = qMetaTypeId!(T)();
        if (vid == v.userType())
            return *reinterpret_cast!(T*)(v.constData());
        static if (__traits(hasMember, T, "rawConstructor"))
            mixin("T t = T.init; t.rawConstructor();");
        else
            mixin("T t;");
        if (v.convert(vid, &t))
            return t;
        static if (__traits(hasMember, T, "rawConstructor"))
            mixin("T r = T.init; r.rawConstructor(); return r;");
        else
            mixin("return T();");
    }
}
pragma(inline, true) T qvariant_cast(T)(const(QVariant) v)
{
    return qvariant_cast!T(v);
}

/+ #if QT_DEPRECATED_SINCE(5, 0)
template<typename T>
inline QT_DEPRECATED T qVariantValue(const QVariant &variant)
{ return qvariant_cast<T>(variant); }

template<typename T>
inline QT_DEPRECATED bool qVariantCanConvert(const QVariant &variant)
{ return variant.template canConvert<T>(); }
#endif +/

}

/+ #ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QVariant &);
Q_CORE_EXPORT QDebug operator<<(QDebug, const QVariant::Type);
#endif +/

