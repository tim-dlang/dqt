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
module qt.gui.pageranges;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.metatype;
import qt.core.shareddata;
import qt.core.string;
import qt.core.typeinfo;
import qt.helpers;

/+ class QDebug; +/
extern(C++, class) struct QPageRangesPrivate;
/+ QT_DECLARE_QESDP_SPECIALIZATION_DTOR_WITH_EXPORT(QPageRangesPrivate, Q_GUI_EXPORT) +/
/// Binding for C++ class [QPageRanges](https://doc.qt.io/qt-6/qpageranges.html).
@Q_DECLARE_METATYPE @Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_GUI_EXPORT +/ QPageRanges
{
public:
    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    ref typeof(this) rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    ~this();

    @disable this(this);
    this(ref const(QPageRanges) other) nothrow;
    ref QPageRanges opAssign(ref const(QPageRanges) other) nothrow;

    /+ QPageRanges(QPageRanges &&other) noexcept = default; +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_PURE_SWAP(QPageRanges) +/
    /+ void swap(QPageRanges &other) noexcept
    { d.swap(other.d); } +/

    /+ friend bool operator==(const QPageRanges &lhs, const QPageRanges &rhs) noexcept
    { return lhs.isEqual(rhs); } +/
    /+ friend bool operator!=(const QPageRanges &lhs, const QPageRanges &rhs) noexcept
    { return !lhs.isEqual(rhs); } +/

    struct Range {
        int from = -1;
        int to = -1;
        bool contains(int pageNumber) const nothrow
        { return from <= pageNumber && to >= pageNumber; }
        /+ friend bool operator==(Range lhs, Range rhs) noexcept
        { return lhs.from == rhs.from && lhs.to == rhs.to; } +/
        /+ friend bool operator!=(Range lhs, Range rhs) noexcept
        { return !(lhs == rhs); } +/
        /+ friend bool operator<(Range lhs, Range rhs) noexcept
        { return lhs.from < rhs.from || (!(rhs.from < lhs.from) && lhs.to < rhs.to); } +/
    }

    void addPage(int pageNumber);
    void addRange(int from, int to);
    //QList!(Range) toRangeList() const;
    void clear();

    QString toString() const;
    static QPageRanges fromString(ref const(QString) ranges);

    bool contains(int pageNumber) const;
    bool isEmpty() const;
    int firstPage() const;
    int lastPage() const;

    void detach();

private:
    bool isEqual(ref const(QPageRanges) other) const nothrow;

    QExplicitlySharedDataPointer!(QPageRangesPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

/+ #ifndef QT_NO_DATASTREAM
Q_GUI_EXPORT QDataStream &operator<<(QDataStream &, const QPageRanges &);
Q_GUI_EXPORT QDataStream &operator>>(QDataStream &, QPageRanges &);
#endif

#ifndef QT_NO_DEBUG_STREAM
Q_GUI_EXPORT QDebug operator<<(QDebug dbg, const QPageRanges &pageRanges);
#endif

Q_DECLARE_SHARED(QPageRanges)
Q_DECLARE_TYPEINFO(QPageRanges::Range, Q_RELOCATABLE_TYPE);


QT_DECL_METATYPE_EXTERN(QPageRanges, Q_GUI_EXPORT) +/

