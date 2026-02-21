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
module qt.core.versionnumber;
extern(C++):

import qt.config;
import qt.core.anystringview;
import qt.core.global;
import qt.core.list;
import qt.core.metatype;
import qt.core.string;
import qt.core.typeinfo;
import qt.helpers;
static if (defined!"QT_CORE_BUILD_REMOVED_API")
    import qt.core.stringview;

/+ Q_CORE_EXPORT size_t qHash(const QVersionNumber &key, size_t seed = 0);

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream &operator<<(QDataStream &out, const QVersionNumber &version);
Q_CORE_EXPORT QDataStream &operator>>(QDataStream &in, QVersionNumber &version);
#endif +/

/// Binding for C++ class [QVersionNumber](https://doc.qt.io/qt-6/qversionnumber.html).
@Q_DECLARE_METATYPE @Q_RELOCATABLE_TYPE extern(C++, class) struct QVersionNumber
{
private:
    /*
     * QVersionNumber stores small values inline, without memory allocation.
     * We do that by setting the LSB in the pointer that would otherwise hold
     * the longer form of the segments.
     * The constants below help us deal with the permutations for 32- and 64-bit,
     * little- and big-endian architectures.
     */
    enum {
        // in little-endian, inline_segments[0] is shared with the pointer's LSB, while
        // in big-endian, it's inline_segments[7]
        InlineSegmentMarker = versionIsSet!"LittleEndian" ? 0 : (void*).sizeof - 1,
        InlineSegmentStartIdx = !InlineSegmentMarker, // 0 for BE, 1 for LE
        InlineSegmentCount = (void*).sizeof - 1
    }
    static assert(InlineSegmentCount >= 3);   // at least major, minor, micro

    struct SegmentStorage
    {
        // Note: we alias the use of dummy and inline_segments in the use of the
        // union below. This is undefined behavior in C++98, but most compilers implement
        // the C++11 behavior. The one known exception is older versions of Sun Studio.
        union {
            quintptr dummy = 1;
            qint8[(void*).sizeof] inline_segments;
            QList!(int)* pointer_segments;
        }

        // set the InlineSegmentMarker and set length to zero
        //@disable this();
        /+this() nothrow
        {
            this.dummy = 1;
        }+/

/+        this(ref const(QList!(int)) seg)
        {
            if (dataFitsInline(seg.data(), seg.size()))
                setInlineData(seg.data(), seg.size());
            else
                setListData(seg);
        }+/

        /+ Q_CORE_EXPORT +/ void setListData(ref const(QList!(int)) seg);

        @disable this(this);
        /+this(ref const(SegmentStorage) other)
        {
            if (other.isUsingPointer())
                setListData(*other.pointer_segments);
            else
                dummy = other.dummy;
        }+/

        /+ref SegmentStorage opAssign(ref const(SegmentStorage) other)
        {
            import core.stdcpp.new_;

            if (isUsingPointer() && other.isUsingPointer()) {
                *pointer_segments = *other.pointer_segments;
            } else if (other.isUsingPointer()) {
                setListData(*other.pointer_segments);
            } else {
                if (isUsingPointer())
                    cpp_delete(pointer_segments);
                dummy = other.dummy;
            }
            return this;
        }+/

        /+ SegmentStorage(SegmentStorage &&other) noexcept
            : dummy(other.dummy)
        {
            other.dummy = 1;
        } +/

        /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(SegmentStorage) +/

        /+ void swap(SegmentStorage &other) noexcept
        {
            std::swap(dummy, other.dummy);
        } +/

        /+ explicit SegmentStorage(QList<int> &&seg)
        {
            if (dataFitsInline(std::as_const(seg).data(), seg.size()))
                setInlineData(std::as_const(seg).data(), seg.size());
            else
                setListData(std::move(seg));
        } +/

        /+ Q_CORE_EXPORT void setListData(QList<int> &&seg); +/

        /+ explicit SegmentStorage(std::initializer_list<int> args)
            : SegmentStorage(args.begin(), args.end()) {} +/

        /+ explicit +/this(const(int)* first, const(int)* last)
        {
            if (dataFitsInline(first, last - first)) {
                setInlineData(first, last - first);
            } else {
                setListData(first, last);
            }
        }

        /+ Q_CORE_EXPORT +/ void setListData(const(int)* first, const(int)* last);

        ~this() {
            import core.stdcpp.new_;
            if (isUsingPointer()) cpp_delete(pointer_segments);
        }

        bool isUsingPointer() const nothrow
        { return (inline_segments[InlineSegmentMarker] & 1) == 0; }

        qsizetype size() const nothrow
        { return isUsingPointer() ? pointer_segments.size() : (inline_segments[InlineSegmentMarker] >> 1); }

        void setInlineSize(qsizetype len)
        {
            (mixin(Q_ASSERT(q{len <= QVersionNumber.InlineSegmentCount})));
            inline_segments[InlineSegmentMarker] = cast(qint8) (1 + 2 * len);
        }

        /+ Q_CORE_EXPORT +/ void resize(qsizetype len);

        int at(qsizetype index) const
        {
            return isUsingPointer() ?
                        pointer_segments.at(index) :
                        inline_segments[InlineSegmentStartIdx + index];
        }

/+        void setSegments(int len, int maj, int min = 0, int mic = 0)
        {
            if (maj == cast(qint8) (maj) && min == cast(qint8) (min) && mic == cast(qint8) (mic)) {
                /+ int[0]  +/ auto data = mixin(buildStaticArray!(q{int}, q{ maj, min, mic})) ;
                setInlineData(data.ptr, len);
            } else {
                setVector(len, maj, min, mic);
            }
        }+/

    private:
        static bool dataFitsInline(const(int)* data, qsizetype len)
        {
            if (len > InlineSegmentCount)
                return false;
            for (qsizetype i = 0; i < len; ++i)
                if (data[i] != cast(qint8) (data[i]))
                    return false;
            return true;
        }
        void setInlineData(const(int)* data, qsizetype len)
        {
            (mixin(Q_ASSERT(q{len <= QVersionNumber.InlineSegmentCount})));
            dummy = 1 + len * 2;
            static if (versionIsSet!("LittleEndian"))
            {
                for (qsizetype i = 0; i < len; ++i)
                    dummy |= quintptr(data[i] & 0xFF) << (8 * (i + 1));
            }
            else static if (versionIsSet!("BigEndian"))
            {
                for (qsizetype i = 0; i < len; ++i)
                    dummy |= quintptr(data[i] & 0xFF) << (8 * ((void*).sizeof - i - 1));
            }
            else
            {
                // the code above is equivalent to:
                setInlineSize(len);
                for (qsizetype i = 0; i < len; ++i)
                    inline_segments[InlineSegmentStartIdx + i] = data[i] & 0xFF;
            }
        }

        /+ Q_CORE_EXPORT +/ void setVector(int len, int maj, int min, int mic);
    }SegmentStorage m_segments;

public:
    //@disable this();
    /+pragma(inline, true) this() nothrow
    {
        this.m_segments = typeof(this.m_segments)();
    }+/
/+    /+ explicit +/pragma(inline, true) this(ref const(QList!(int)) seg)
    {
        this.m_segments = seg;
    }+/

    // compiler-generated copy/move ctor/assignment operators and the destructor are ok

    /+ explicit QVersionNumber(QList<int> &&seg) : m_segments(std::move(seg)) { } +/

    /+ inline QVersionNumber(std::initializer_list<int> args)
        : m_segments(args)
    {} +/

    /+ template <qsizetype N> +/
    /+ explicit +/this(qsizetype N)(ref const(QVarLengthArray!(int, N)) sec)
    {
        this.m_segments = typeof(this.m_segments)(sec.begin(), sec.end());
    }

/+    /+ explicit +/pragma(inline, true) this(int maj)
    { m_segments.setSegments(1, maj); }

    /+ explicit +/pragma(inline, true) this(int maj, int min)
    { m_segments.setSegments(2, maj, min); }

    /+ explicit +/pragma(inline, true) this(int maj, int min, int mic)
    { m_segments.setSegments(3, maj, min, mic); }+/

    /+ [[nodiscard]] +/ pragma(inline, true) bool isNull() const nothrow
    { return segmentCount() == 0; }

    /+ [[nodiscard]] +/ pragma(inline, true) bool isNormalized() const /*nothrow*/
    { return isNull() || segmentAt(segmentCount() - 1) != 0; }

    /+ [[nodiscard]] +/ pragma(inline, true) int majorVersion() const /*nothrow*/
    { return segmentAt(0); }

    /+ [[nodiscard]] +/ pragma(inline, true) int minorVersion() const /*nothrow*/
    { return segmentAt(1); }

    /+ [[nodiscard]] +/ pragma(inline, true) int microVersion() const /*nothrow*/
    { return segmentAt(2); }

    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ QVersionNumber normalized() const;

    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ QList!(int) segments() const;

    /+ [[nodiscard]] +/ pragma(inline, true) int segmentAt(qsizetype index) const /*nothrow*/
    { return (m_segments.size() > index) ? m_segments.at(index) : 0; }

    /+ [[nodiscard]] +/ pragma(inline, true) qsizetype segmentCount() const nothrow
    { return m_segments.size(); }

    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ bool isPrefixOf(ref const(QVersionNumber) other) const nothrow;

    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ static int compare(ref const(QVersionNumber) v1, ref const(QVersionNumber) v2) nothrow;

    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ static QVersionNumber commonPrefix(ref const(QVersionNumber) v1, ref const(QVersionNumber) v2);

    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ QString toString() const;
    /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ static QVersionNumber fromString(QAnyStringView string, qsizetype* suffixIndex = null);

/+ #if QT_DEPRECATED_SINCE(6, 4) && QT_POINTER_SIZE != 4 +/
    static if (((configValue!"__SIZEOF_POINTER__" != 4 && defined!"__SIZEOF_POINTER__") || (!defined!"__SIZEOF_POINTER__" && (configValue!"Q_PROCESSOR_WORDSIZE" != 4 || versionIsSet!("D_LP64") || versionIsSet!("D_LP64")))))
    {
        /+ Q_WEAK_OVERLOAD +/
        /+ QT_DEPRECATED_VERSION_X_6_4("Use the 'qsizetype *suffixIndex' overload.") +/
            /+ [[nodiscard]] +/ static QVersionNumber fromString(QAnyStringView string, int* suffixIndex)
        {
            /+ QT_WARNING_PUSH
            // fromString() writes to *n unconditionally, but GCC can't know that
            QT_WARNING_DISABLE_GCC("-Wmaybe-uninitialized") +/
            qsizetype n;
            auto r = fromString(string, &n);
            if (suffixIndex) {
                (mixin(Q_ASSERT(q{cast(int)(n) == n})));
                *suffixIndex = cast(int)(n);
            }
            return cast(QVersionNumber) (r);
            /+ QT_WARNING_POP +/
        }
    }
/+ #endif


#if QT_CORE_REMOVED_SINCE(6, 4) +/
    static if (defined!"QT_CORE_BUILD_REMOVED_API")
    {
        /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ static QVersionNumber fromString(ref const(QString) string, int* suffixIndex);
        /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ static QVersionNumber fromString(QLatin1StringView string, int* suffixIndex);
        /+ [[nodiscard]] +/ /+ Q_CORE_EXPORT +/ static QVersionNumber fromString(QStringView string, int* suffixIndex);
    }
/+ #endif +/

    /+ [[nodiscard]] friend bool operator> (const QVersionNumber &lhs, const QVersionNumber &rhs) noexcept
    { return compare(lhs, rhs) > 0; } +/

    /+ [[nodiscard]] friend bool operator>=(const QVersionNumber &lhs, const QVersionNumber &rhs) noexcept
    { return compare(lhs, rhs) >= 0; } +/

    /+ [[nodiscard]] friend bool operator< (const QVersionNumber &lhs, const QVersionNumber &rhs) noexcept
    { return compare(lhs, rhs) < 0; } +/

    /+ [[nodiscard]] friend bool operator<=(const QVersionNumber &lhs, const QVersionNumber &rhs) noexcept
    { return compare(lhs, rhs) <= 0; } +/

    /+ [[nodiscard]] friend bool operator==(const QVersionNumber &lhs, const QVersionNumber &rhs) noexcept
    { return compare(lhs, rhs) == 0; } +/

    /+ [[nodiscard]] friend bool operator!=(const QVersionNumber &lhs, const QVersionNumber &rhs) noexcept
    { return compare(lhs, rhs) != 0; } +/

private:
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_CORE_EXPORT QDataStream& operator>>(QDataStream &in, QVersionNumber &version); +/
    }
    /+ friend Q_CORE_EXPORT size_t qHash(const QVersionNumber &key, size_t seed); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QVersionNumber, Q_RELOCATABLE_TYPE);

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QVersionNumber &version);
#endif

Q_CORE_EXPORT size_t qHash(const QTypeRevision &key, size_t seed = 0);

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream& operator<<(QDataStream &out, const QTypeRevision &revision);
Q_CORE_EXPORT QDataStream& operator>>(QDataStream &in, QTypeRevision &revision);
#endif +/

/// Binding for C++ class [QTypeRevision](https://doc.qt.io/qt-6/qtyperevision.html).
@Q_DECLARE_METATYPE @Q_RELOCATABLE_TYPE extern(C++, class) struct QTypeRevision
{
public:
    /+ template<typename Integer> +/
    alias if_valid_segment_type(Integer) = UnknownType!q{/+ std:: +/enable_if!(
                /+ std:: +/is_integral!(Integer).value, bool).type};

    /+ template<typename Integer> +/
    alias if_valid_value_type(Integer) = UnknownType!q{/+ std:: +/enable_if!(
                /+ std:: +/is_integral!(Integer).value
                && (Integer.sizeof > quint16.sizeof
                    || (Integer.sizeof == quint16.sizeof
                        && !/+ std:: +/is_signed!(Integer).value)), bool).type};

    /+ template<typename Integer, if_valid_segment_type<Integer> = true> +/
/+    static bool isValidSegment(Integer,)(Integer segment)
    {
        // using extra parentheses around max to avoid expanding it if it is a macro
        return segment >= Integer(0)
                && ((/+ std:: +/numeric_limits!(Integer).max)() < Integer(SegmentUnknown)
                    || segment < Integer(SegmentUnknown));
    }+/

    /+ template<typename Major, typename Minor,
             if_valid_segment_type<Major> = true,
             if_valid_segment_type<Minor> = true> +/
    static QTypeRevision fromVersion(Major,Minor,)(Major majorVersion, Minor minorVersion)
    {
        return (){(){ (mixin(Q_ASSERT(q{QTypeRevision.isValidSegment(majorVersion)})));
return
               /+ Q_ASSERT(isValidSegment(minorVersion)) +/ mixin(Q_ASSERT(q{QTypeRevision.isValidSegment(minorVersion)}));
}();
return
               QTypeRevision(quint8(majorVersion), quint8(minorVersion));
}();
    }

    /+ template<typename Major, if_valid_segment_type<Major> = true> +/
    /+static QTypeRevision fromMajorVersion(Major,)(Major majorVersion)
    {
        return (){ (mixin(Q_ASSERT(q{QTypeRevision.isValidSegment(majorVersion)})));
return
               QTypeRevision(quint8(majorVersion), cast(quint8) (SegmentUnknown));
}();
    }

    /+ template<typename Minor, if_valid_segment_type<Minor> = true> +/
    static QTypeRevision fromMinorVersion(Minor,)(Minor minorVersion)
    {
        return (){ (mixin(Q_ASSERT(q{QTypeRevision.isValidSegment(minorVersion)})));
return
               QTypeRevision(cast(quint8) (SegmentUnknown), quint8(minorVersion));
}();
    }

    /+ template<typename Integer, if_valid_value_type<Integer> = true> +/
    static QTypeRevision fromEncodedVersion(Integer,)(Integer value)
    {
        return (){ (mixin(Q_ASSERT(q{(value & UnresolvedMergeConflict!(q{~Integer(0xffff)},q{~Integer(0xffff)})) == Integer(0)})));
return
               QTypeRevision((value & Integer(0xff00)) >> 8, value & Integer(0xff));
}();
    }+/

    static QTypeRevision zero() { return QTypeRevision(0, 0); }

    /+ constexpr QTypeRevision() = default; +/

    bool hasMajorVersion() const { return m_majorVersion != SegmentUnknown; }
    quint8 majorVersion() const { return m_majorVersion; }

    bool hasMinorVersion() const { return m_minorVersion != SegmentUnknown; }
    quint8 minorVersion() const { return m_minorVersion; }

    bool isValid() const { return hasMajorVersion() || hasMinorVersion(); }

    /+ template<typename Integer, if_valid_value_type<Integer> = true> +/
    Integer toEncodedVersion(Integer,)() const
    {
        return Integer(m_majorVersion << 8) | Integer(m_minorVersion);
    }

    /+ [[nodiscard]] friend constexpr bool operator==(QTypeRevision lhs, QTypeRevision rhs)
    {
        return lhs.toEncodedVersion<quint16>() == rhs.toEncodedVersion<quint16>();
    } +/

    /+ [[nodiscard]] friend constexpr bool operator!=(QTypeRevision lhs, QTypeRevision rhs)
    {
        return lhs.toEncodedVersion<quint16>() != rhs.toEncodedVersion<quint16>();
    } +/

    /+ [[nodiscard]] friend constexpr bool operator<(QTypeRevision lhs, QTypeRevision rhs)
    {
        return (!lhs.hasMajorVersion() && rhs.hasMajorVersion())
                // non-0 major > unspecified major > major 0
                ? rhs.majorVersion() != 0
                : ((lhs.hasMajorVersion() && !rhs.hasMajorVersion())
                // major 0 < unspecified major < non-0 major
                ? lhs.majorVersion() == 0
                : (lhs.majorVersion() != rhs.majorVersion()
                    // both majors specified and non-0
                    ? lhs.majorVersion() < rhs.majorVersion()
                    : ((!lhs.hasMinorVersion() && rhs.hasMinorVersion())
                        // non-0 minor > unspecified minor > minor 0
                        ? rhs.minorVersion() != 0
                        : ((lhs.hasMinorVersion() && !rhs.hasMinorVersion())
                            // minor 0 < unspecified minor < non-0 minor
                            ? lhs.minorVersion() == 0
                            // both minors specified and non-0
                            : lhs.minorVersion() < rhs.minorVersion()))));
    } +/

    /+ [[nodiscard]] friend constexpr bool operator>(QTypeRevision lhs, QTypeRevision rhs)
    {
        return lhs != rhs && !(lhs < rhs);
    } +/

    /+ [[nodiscard]] friend constexpr bool operator<=(QTypeRevision lhs, QTypeRevision rhs)
    {
        return lhs == rhs || lhs < rhs;
    } +/

    /+ [[nodiscard]] friend constexpr bool operator>=(QTypeRevision lhs, QTypeRevision rhs)
    {
        return lhs == rhs || !(lhs < rhs);
    } +/

private:
    enum { SegmentUnknown = 0xff }

    version (LittleEndian)
    {
        this(quint8 major, quint8 minor)
        {
            this.m_minorVersion = minor;
            this.m_majorVersion = major;
        }

        quint8 m_minorVersion = SegmentUnknown;
        quint8 m_majorVersion = SegmentUnknown;
    }
    else
    {
        this(quint8 major, quint8 minor)
        {
            this.m_majorVersion = major;
            this.m_minorVersion = minor;
        }

        quint8 m_majorVersion = SegmentUnknown;
        quint8 m_minorVersion = SegmentUnknown;
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ static_assert(sizeof(QTypeRevision) == 2);
Q_DECLARE_TYPEINFO(QTypeRevision, Q_RELOCATABLE_TYPE);

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QTypeRevision &revision);
#endif


QT_DECL_METATYPE_EXTERN(QVersionNumber, Q_CORE_EXPORT)
QT_DECL_METATYPE_EXTERN(QTypeRevision, Q_CORE_EXPORT) +/

