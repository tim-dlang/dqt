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
import qt.core.global;
import qt.core.metatype;
import qt.core.string;
import qt.core.stringview;
import qt.core.typeinfo;
import qt.core.vector;
import qt.helpers;

/+ Q_CORE_EXPORT uint qHash(const QVersionNumber &key, uint seed = 0);

#ifndef QT_NO_DATASTREAM
Q_CORE_EXPORT QDataStream& operator<<(QDataStream &out, const QVersionNumber &version);
Q_CORE_EXPORT QDataStream& operator>>(QDataStream &in, QVersionNumber &version);
#endif +/

/// Binding for C++ class [QVersionNumber](https://doc.qt.io/qt-5/qversionnumber.html).
@Q_DECLARE_METATYPE @Q_MOVABLE_TYPE extern(C++, class) struct QVersionNumber
{
private:
    /*
     * QVersionNumber stores small values inline, without memory allocation.
     * We do that by setting the LSB in the pointer that would otherwise hold
     * the longer form of the segments.
     * The constants below help us deal with the permutations for 32- and 64-bit,
     * little- and big-endian architectures.
     */
    // in little-endian, inline_segments[0] is shared with the pointer's LSB, while
    // in big-endian, it's inline_segments[7]
    version (LittleEndian)
        enum InlineSegmentMarker = 0;
    else
        enum InlineSegmentMarker = (void*).sizeof - 1;
    enum InlineSegmentStartIdx = !InlineSegmentMarker; // 0 for BE, 1 for LE
    enum InlineSegmentCount = (void*).sizeof - 1;
    mixin(Q_STATIC_ASSERT(q{QVersionNumber.InlineSegmentCount >= 3}));   // at least major, minor, micro

    struct SegmentStorage {
        // Note: we alias the use of dummy and inline_segments in the use of the
        // union below. This is undefined behavior in C++98, but most compilers implement
        // the C++11 behavior. The one known exception is older versions of Sun Studio.
        union {
            quintptr dummy = 1;
            qint8[(void*).sizeof] inline_segments;
            QVector!(int)* pointer_segments;
        }

        // set the InlineSegmentMarker and set length to zero
        /+this()/+ noexcept+/
        {
            this.dummy = 1;
        }+/

        /+ this(ref const(QVector!(int)) seg)
        {
            import core.stdcpp.new_;

            if (dataFitsInline(cast(const(int)*) (seg.begin()), seg.size()))
                setInlineData(cast(const(int)*) (seg.begin()), seg.size());
            else
                pointer_segments = cpp_new!(QVector!(int))(seg);
        } +/

        @disable this(this);
        /+ this(ref const(SegmentStorage) other)
        {
            import core.stdcpp.new_;

            if (other.isUsingPointer())
                pointer_segments = cpp_new!(QVector!(int))(*other.pointer_segments);
            else
                dummy = other.dummy;
        } +/

        /+ref SegmentStorage operator =(ref const(SegmentStorage) other)
        {
            import core.stdcpp.new_;

            if (isUsingPointer() && other.isUsingPointer()) {
                *pointer_segments = *other.pointer_segments;
            } else if (other.isUsingPointer()) {
                pointer_segments = cpp_new!(QVector!(int))(*other.pointer_segments);
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

        /+ SegmentStorage &operator=(SegmentStorage &&other) noexcept
        {
            qSwap(dummy, other.dummy);
            return *this;
        } +/

        /+ explicit SegmentStorage(QVector<int> &&seg)
        {
            if (dataFitsInline(seg.begin(), seg.size()))
                setInlineData(seg.begin(), seg.size());
            else
                pointer_segments = new QVector<int>(std::move(seg));
        } +/
        /+ SegmentStorage(std::initializer_list<int> args)
        {
            if (dataFitsInline(args.begin(), int(args.size()))) {
                setInlineData(args.begin(), int(args.size()));
            } else {
                pointer_segments = new QVector<int>(args);
            }
        } +/

        ~this() {
            import core.stdcpp.new_;
            if (isUsingPointer()) cpp_delete(pointer_segments);
        }

        bool isUsingPointer() const/+ noexcept+/
        { return (inline_segments[InlineSegmentMarker] & 1) == 0; }

        int size() const/+ noexcept+/
        { return isUsingPointer() ? pointer_segments.size() : (inline_segments[InlineSegmentMarker] >> 1); }

        void setInlineSize(int len)
        { inline_segments[InlineSegmentMarker] = cast(byte) (1 + 2 * len); }

        void resize(int len)
        {
            if (isUsingPointer())
                pointer_segments.resize(len);
            else
                setInlineSize(len);
        }

        int at(int index) const
        {
            return isUsingPointer() ?
                        pointer_segments.at(index) :
                        inline_segments[InlineSegmentStartIdx + index];
        }

        void setSegments(int len, int maj, int min = 0, int mic = 0)
        {
            if (maj == cast(qint8) (maj) && min == cast(qint8) (min) && mic == cast(qint8) (mic)) {
                int[3] data = [maj, min, mic];
                setInlineData(data.ptr, len);
            } else {
                setVector(len, maj, min, mic);
            }
        }

    private:
        static bool dataFitsInline(const(int)* data, int len)
        {
            if (len > InlineSegmentCount)
                return false;
            for (int i = 0; i < len; ++i)
                if (data[i] != cast(qint8) (data[i]))
                    return false;
            return true;
        }
        void setInlineData(const(int)* data, int len)
        {
            dummy = 1 + len * 2;
            version (LittleEndian)
            {
                for (int i = 0; i < len; ++i)
                    dummy |= quintptr(data[i] & 0xFF) << (8 * (i + 1));
            }
            else version (BigEndian)
            {
                for (int i = 0; i < len; ++i)
                    dummy |= quintptr(data[i] & 0xFF) << (8 * ((void*).sizeof - i - 1));
            }
            else
            {
                // the code above is equivalent to:
                setInlineSize(len);
                for (int i = 0; i < len; ++i)
                    inline_segments[InlineSegmentStartIdx + i] = data[i] & 0xFF;
            }
        }

        /+ Q_CORE_EXPORT +/ void setVector(int len, int maj, int min, int mic);
    }SegmentStorage m_segments;

public:
    @disable this();
    /+pragma(inline, true) this()/+ noexcept+/
    {
        this.m_segments = typeof(this.m_segments)();
    }+/
    /+ /+ explicit +/pragma(inline, true) this(ref const(QVector!(int)) seg)
    {
        this.m_segments = seg;
    } +/

    // compiler-generated copy/move ctor/assignment operators and the destructor are ok

    /+ explicit QVersionNumber(QVector<int> &&seg)
        : m_segments(std::move(seg))
    {} +/

    /+ inline QVersionNumber(std::initializer_list<int> args)
        : m_segments(args)
    {} +/

    /+ explicit +/pragma(inline, true) this(int maj)
    { m_segments.setSegments(1, maj); }

    /+ explicit +/pragma(inline, true) this(int maj, int min)
    { m_segments.setSegments(2, maj, min); }

    /+ explicit +/pragma(inline, true) this(int maj, int min, int mic)
    { m_segments.setSegments(3, maj, min, mic); }

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool isNull() const/+ noexcept+/
    { return segmentCount() == 0; }

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool isNormalized() const/+ noexcept+/
    { return isNull() || segmentAt(segmentCount() - 1) != 0; }

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) int majorVersion() const/+ noexcept+/
    { return segmentAt(0); }

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) int minorVersion() const/+ noexcept+/
    { return segmentAt(1); }

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) int microVersion() const/+ noexcept+/
    { return segmentAt(2); }

    /+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ QVersionNumber normalized() const;

    /+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ QVector!(int) segments() const;

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) int segmentAt(int index) const/+ noexcept+/
    { return (m_segments.size() > index) ? m_segments.at(index) : 0; }

    /+ Q_REQUIRED_RESULT +/ pragma(inline, true) int segmentCount() const/+ noexcept+/
    { return m_segments.size(); }

    /+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ bool isPrefixOf(ref const(QVersionNumber) other) const/+ noexcept+/;

    /+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ static int compare(ref const(QVersionNumber) v1, ref const(QVersionNumber) v2)/+ noexcept+/;

    /+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ static QVersionNumber commonPrefix(ref const(QVersionNumber) v1, ref const(QVersionNumber) v2);

    /+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ QString toString() const;
    static if (QT_STRINGVIEW_LEVEL < 2)
    {
        /+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ static QVersionNumber fromString(ref const(QString) string, int* suffixIndex = null);
    }
    /+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ static QVersionNumber fromString(QLatin1String string, int* suffixIndex = null);
    /+ Q_REQUIRED_RESULT +/ /+ Q_CORE_EXPORT +/ /+ Q_DECL_PURE_FUNCTION +/ static QVersionNumber fromString(QStringView string, int* suffixIndex = null);

private:
    version (QT_NO_DATASTREAM) {} else
    {
        /+ friend Q_CORE_EXPORT QDataStream& operator>>(QDataStream &in, QVersionNumber &version); +/
    }
    /+ friend Q_CORE_EXPORT uint qHash(const QVersionNumber &key, uint seed); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ Q_DECLARE_TYPEINFO(QVersionNumber, Q_MOVABLE_TYPE);

#ifndef QT_NO_DEBUG_STREAM
Q_CORE_EXPORT QDebug operator<<(QDebug, const QVersionNumber &version);
#endif +/

/+/+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool operator > (ref const(QVersionNumber) lhs, ref const(QVersionNumber) rhs)/+ noexcept+/
{ return QVersionNumber.compare(lhs, rhs) > 0; }+/

/+/+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool operator >=(ref const(QVersionNumber) lhs, ref const(QVersionNumber) rhs)/+ noexcept+/
{ return QVersionNumber.compare(lhs, rhs) >= 0; }+/

/+/+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool operator < (ref const(QVersionNumber) lhs, ref const(QVersionNumber) rhs)/+ noexcept+/
{ return QVersionNumber.compare(lhs, rhs) < 0; }+/

/+/+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool operator <=(ref const(QVersionNumber) lhs, ref const(QVersionNumber) rhs)/+ noexcept+/
{ return QVersionNumber.compare(lhs, rhs) <= 0; }+/

/+/+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool operator ==(ref const(QVersionNumber) lhs, ref const(QVersionNumber) rhs)/+ noexcept+/
{ return QVersionNumber.compare(lhs, rhs) == 0; }+/

/+/+ Q_REQUIRED_RESULT +/ pragma(inline, true) bool operator !=(ref const(QVersionNumber) lhs, ref const(QVersionNumber) rhs)/+ noexcept+/
{ return QVersionNumber.compare(lhs, rhs) != 0; }+/


/+ Q_DECLARE_METATYPE(QVersionNumber) +/

