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
module qt.core.iterable;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.taggedpointer;
import qt.helpers;

extern(C++, "QtPrivate") {
    class QConstPreservingPointer(Type, Storage)
    {
    private:
        enum Tag : bool { Const, Mutable }
        QTaggedPointer!(Storage, Tag) m_pointer;

    public:
        this(/+ std:: +/nullptr_t)
        {
            this.m_pointer = typeof(this.m_pointer)(null, Tag.Const);
        }

        this(const(void)* pointer, qsizetype alignment)
        {
            this.m_pointer = typeof(this.m_pointer)(reinterpret_cast!(Storage*)(const_cast!(void*)(pointer)), Tag.Const);

            /+ Q_UNUSED(alignment) +/
            (mixin(Q_ASSERT(q{alignment > qsizetype(Storage.alignof)})));
        }

        this(void* pointer, qsizetype alignment)
        {
            this.m_pointer = typeof(this.m_pointer)(reinterpret_cast!(Storage*)(pointer), Tag.Mutable);

            /+ Q_UNUSED(alignment) +/
            (mixin(Q_ASSERT(q{alignment > qsizetype(Storage.alignof)})));
        }

        /+ template<typename InputType> +/
        this(InputType)(const(InputType)* pointer)
        {
            this.m_pointer = typeof(this.m_pointer)(reinterpret_cast!(Storage*)(const_cast!(InputType*)(pointer)), Tag.Const);

            static assert(InputType.alignof >= Storage.alignof);
        }

        /+ template<typename InputType> +/
        this(InputType)(InputType* pointer)
        {
            this.m_pointer = typeof(this.m_pointer)(reinterpret_cast!(Storage*)(pointer), Tag.Mutable);

            static assert(InputType.alignof >= Storage.alignof);
        }

        /+ QConstPreservingPointer() = default; +/

        final const(Type)* constPointer() const
        {
            return reinterpret_cast!(const(Type)*)(m_pointer.data());
        }

        final Type* mutablePointer() const
        {
            return m_pointer.tag() == Tag.Mutable ? reinterpret_cast!(Type*)(m_pointer.data()) : null;
        }
    }
}

/// Binding for C++ class [QTaggedIterator](https://doc.qt.io/qt-6/qtaggediterator.html).
extern(C++, class) struct QTaggedIterator(Iterator, IteratorCategory)
{
    public Iterator base0;
    alias base0 this;
public:
    alias iterator_category = IteratorCategory;
    /+ QTaggedIterator(Iterator &&it) : Iterator(std::move(it))
    {
        const QMetaContainer metaContainer = this->metaContainer();
        if (std::is_base_of_v<std::random_access_iterator_tag, IteratorCategory>
                && !metaContainer.hasRandomAccessIterator()) {
            qFatal("You cannot use this iterator as a random access iterator");
            this->clearIterator();
        }

        if (std::is_base_of_v<std::bidirectional_iterator_tag, IteratorCategory>
                && !metaContainer.hasBidirectionalIterator()) {
            qFatal("You cannot use this iterator as a bidirectional iterator");
            this->clearIterator();
        }

        if (std::is_base_of_v<std::forward_iterator_tag, IteratorCategory>
                && !metaContainer.hasForwardIterator()) {
            qFatal("You cannot use this iterator as a forward iterator");
            this->clearIterator();
        }

        if (std::is_base_of_v<std::input_iterator_tag, IteratorCategory>
                && !metaContainer.hasInputIterator()) {
            qFatal("You cannot use this iterator as an input iterator");
            this->clearIterator();
        }
    } +/

    /+bool operator ==(ref const(QTaggedIterator) o) const { return Iterator.operator==(o); }+/
    /+bool operator !=(ref const(QTaggedIterator) o) const { return Iterator.operator!=(o); }+/
    ref QTaggedIterator opUnary(string op)() if(op == "++") { Iterator.operator++(); return this; }
    /+QTaggedIterator operator ++(int x) { return QTaggedIterator(Iterator.operator++(x)); }+//+ ; +/
    ref QTaggedIterator opUnary(string op)() if(op == "--") { Iterator.operator--(); return this; }
    /+QTaggedIterator operator --(int x) { return QTaggedIterator(Iterator.operator--(x)); }+//+ ; +/
    ref QTaggedIterator opOpAssign(string op)(qsizetype j) if(op == "+") { Iterator.operator+=(j); return this; }
    ref QTaggedIterator opOpAssign(string op)(qsizetype j) if(op == "-")  { Iterator.operator-=(j); return this; }
    QTaggedIterator opBinary(string op)(qsizetype j) const if(op == "+") { return QTaggedIterator(Iterator.operator+(j)); }
    QTaggedIterator opBinary(string op)(qsizetype j) const if(op == "-") { return QTaggedIterator(Iterator.operator-(j)); }
    qsizetype opBinary(string op)(ref const(QTaggedIterator) j) const if(op == "-") { return Iterator.operator-(j); }

    /+bool operator <(ref const(QTaggedIterator) j) { return operator-(j) < 0; }+/
    /+bool operator >=(ref const(QTaggedIterator) j) { return !operator<(j); }+/
    /+bool operator >(ref const(QTaggedIterator) j) { return operator-(j) > 0; }+/
    /+bool operator <=(ref const(QTaggedIterator) j) { return !operator>(j); }+/

    /+ friend inline QTaggedIterator operator+(qsizetype j, const QTaggedIterator &k) { return k + j; } +/
}


/// Binding for C++ class [QBaseIterator](https://doc.qt.io/qt-6/qbaseiterator.html).
class QBaseIterator(Container)
{
private:
    ValueClass!(/+ QtPrivate:: +/QConstPreservingPointer!(ValueClass!(QIterable!(Container)))) m_iterable;
    void* m_iterator = null;

protected:
    /+ QBaseIterator() = default; +/
    this(const(QIterable!(Container)) iterable, void* iterator)
    {
        this.m_iterable = iterable;
        this.m_iterator = iterator;
    }

    this(QIterable!(Container) iterable, void* iterator)
    {
        this.m_iterable = iterable;
        this.m_iterator = iterator;
    }

    /+ QBaseIterator(QBaseIterator &&other)
        : m_iterable(std::move(other.m_iterable)), m_iterator(std::move(other.m_iterator))
    {
        other.m_iterator = nullptr;
    } +/

    /+this(ref const(ValueClass!(QBaseIterator)) other)
    {
        this.m_iterable = other.m_iterable;

        initIterator(other.m_iterator);
    }+/

    ~this() { clearIterator(); }

    /+ QBaseIterator &operator=(QBaseIterator &&other)
    {
        if (this != &other) {
            clearIterator();
            m_iterable = std::move(other.m_iterable);
            m_iterator = std::move(other.m_iterator);
            other.m_iterator = nullptr;
        }
        return *this;
    } +/

    /+final ref ValueClass!(QBaseIterator) operator =(ref const(ValueClass!(QBaseIterator)) other)
    {
        if (this != &other) {
            clearIterator();
            m_iterable = other.m_iterable;
            initIterator(other.m_iterator);
        }
        return *this;
    }+/

    final QIterable!(Container) mutableIterable() const
    {
        return m_iterable.mutablePointer();
    }

    final const(QIterable!(Container)) constIterable() const
    {
        return m_iterable.constPointer();
    }

/+    final void initIterator(const(void)* copy)
    {
        if (!copy)
            return;
        if (auto* mutableIt = mutableIterable()) {
            m_iterator = metaContainer().begin(mutableIt.mutableIterable());
            metaContainer().copyIterator(m_iterator, copy);
        } else if (auto* constIt = constIterable()) {
            m_iterator = metaContainer().constBegin(constIt.constIterable());
            metaContainer().copyConstIterator(m_iterator, copy);
        }
    }+/

    final void clearIterator()
    {
        if (!m_iterator)
            return;
        if (mutableIterable())
            metaContainer().destroyIterator(m_iterator);
        else
            metaContainer().destroyConstIterator(m_iterator);
    }

public:
    final void* mutableIterator() { return m_iterator; }
    final const(void)* constIterator() const { return m_iterator; }
    final Container metaContainer() const { return constIterable().m_metaContainer; }
}

struct QIterator(Container)
{
    public QBaseIterator!(Container) base0;
    alias base0 this;
public:
    alias difference_type = qsizetype;

    /+ explicit +/this(QIterable!(Container) iterable, void* iterator)
    {
        this.QBaseIterator!(Container) = typeof(this.QBaseIterator!(Container))(iterable, iterator);

        (mixin(Q_ASSERT(q{iterable !is null})));
    }

    /+bool operator ==(ref const(QIterator) o) const
    {
        return this.metaContainer().compareIterator(this.constIterator(), o.constIterator());
    }+/

    /+bool operator !=(ref const(QIterator) o) const
    {
        return !this.metaContainer().compareIterator(this.constIterator(), o.constIterator());
    }+/

    ref QIterator opUnary(string op)() if(op == "++")
    {
        this.metaContainer().advanceIterator(this.mutableIterator(), 1);
        return this;
    }

    /+QIterator operator ++(int)
    {
        QIterable!(Container) iterable = this.mutableIterable();
        const(Container) metaContainer = this.metaContainer();
        auto result = QIterator(iterable, metaContainer.begin(iterable.mutableIterable()));
        metaContainer.copyIterator(result.mutableIterator(), this.constIterator());
        metaContainer.advanceIterator(this.mutableIterator(), 1);
        return result;
    }+/

    ref QIterator opUnary(string op)() if(op == "--")
    {
        this.metaContainer().advanceIterator(this.mutableIterator(), -1);
        return this;
    }

    /+QIterator operator --(int)
    {
        QIterable!(Container) iterable = this.mutableIterable();
        const(Container) metaContainer = this.metaContainer();
        auto result = QIterator(iterable, metaContainer.begin(iterable.mutableIterable()));
        metaContainer.copyIterator(result.mutableIterator(), this.constIterator());
        metaContainer.advanceIterator(this.mutableIterator(), -1);
        return result;
    }+/

    ref QIterator opOpAssign(string op)(qsizetype j) if(op == "+")
    {
        this.metaContainer().advanceIterator(this.mutableIterator(), j);
        return this;
    }

    ref QIterator opOpAssign(string op)(qsizetype j) if(op == "-")
    {
        this.metaContainer().advanceIterator(this.mutableIterator(), -j);
        return this;
    }

    QIterator opBinary(string op)(qsizetype j) const if(op == "+")
    {
        QIterable!(Container) iterable = this.mutableIterable();
        const(Container) metaContainer = this.metaContainer();
        auto result = QIterator(iterable, metaContainer.begin(iterable.mutableIterable()));
        metaContainer.copyIterator(result.mutableIterator(), this.constIterator());
        metaContainer.advanceIterator(result.mutableIterator(), j);
        return result;
    }

    QIterator opBinary(string op)(qsizetype j) const if(op == "-")
    {
        QIterable!(Container) iterable = this.mutableIterable();
        const(Container) metaContainer = this.metaContainer();
        auto result = QIterator(iterable, metaContainer.begin(iterable.mutableIterable()));
        metaContainer.copyIterator(result.mutableIterator(), this.constIterator());
        metaContainer.advanceIterator(result.mutableIterator(), -j);
        return result;
    }

    qsizetype opBinary(string op)(ref const(QIterator) j) const if(op == "-")
    {
        return this.metaContainer().diffIterator(this.constIterator(), j.constIterator());
    }

    /+ friend inline QIterator operator+(qsizetype j, const QIterator &k) { return k + j; } +/
}

struct QConstIterator(Container)
{
    public QBaseIterator!(Container) base0;
    alias base0 this;
public:
    alias difference_type = qsizetype;

    /+ explicit +/this(const(QIterable!(Container)) iterable, void* iterator)
    {
        this.QBaseIterator!(Container) = typeof(this.QBaseIterator!(Container))(iterable, iterator);
    }

    /+bool operator ==(ref const(QConstIterator) o) const
    {
        return this.metaContainer().compareConstIterator(
                    this.constIterator(), o.constIterator());
    }+/

    /+bool operator !=(ref const(QConstIterator) o) const
    {
        return !this.metaContainer().compareConstIterator(
                    this.constIterator(), o.constIterator());
    }+/

    ref QConstIterator opUnary(string op)() if(op == "++")
    {
        this.metaContainer().advanceConstIterator(this.mutableIterator(), 1);
        return this;
    }

    /+QConstIterator operator ++(int)
    {
        const(Container) metaContainer = this.metaContainer();
        auto result = QConstIterator(this.constIterable(), metaContainer.constBegin(
                                  this.constIterable().constIterable()));
        metaContainer.copyConstIterator(result.mutableIterator(), this.constIterator());
        metaContainer.advanceConstIterator(this.mutableIterator(), 1);
        return result;
    }+/

    ref QConstIterator opUnary(string op)() if(op == "--")
    {
        this.metaContainer().advanceConstIterator(this.mutableIterator(), -1);
        return this;
    }

    /+QConstIterator operator --(int)
    {
        const(Container) metaContainer = this.metaContainer();
        auto result = QConstIterator(this.constIterable(), metaContainer.constBegin(
                                  this.constIterable().constIterable()));
        metaContainer.copyConstIterator(result.mutableIterator(), this.constIterator());
        metaContainer.advanceConstIterator(this.mutableIterator(), -1);
        return result;
    }+/

    ref QConstIterator opOpAssign(string op)(qsizetype j) if(op == "+")
    {
        this.metaContainer().advanceConstIterator(this.mutableIterator(), j);
        return this;
    }

    ref QConstIterator opOpAssign(string op)(qsizetype j) if(op == "-")
    {
        this.metaContainer().advanceConstIterator(this.mutableIterator(), -j);
        return this;
    }

    QConstIterator opBinary(string op)(qsizetype j) const if(op == "+")
    {
        const(Container) metaContainer = this.metaContainer();
        auto result = QConstIterator(
                    this.constIterable(),
                    metaContainer.constBegin(this.constIterable().constIterable()));
        metaContainer.copyConstIterator(result.mutableIterator(), this.constIterator());
        metaContainer.advanceConstIterator(result.mutableIterator(), j);
        return result;
    }

    QConstIterator opBinary(string op)(qsizetype j) const if(op == "-")
    {
        const(Container) metaContainer = this.metaContainer();
        auto result = QConstIterator(this.constIterable(), metaContainer.constBegin(
                                  this.constIterable().constIterable()));
        metaContainer.copyConstIterator(result.mutableIterator(), this.constIterator());
        metaContainer.advanceConstIterator(result.mutableIterator(), -j);
        return result;
    }

    qsizetype opBinary(string op)(ref const(QConstIterator) j) const if(op == "-")
    {
        return this.metaContainer().diffIterator(this.constIterator(), j.constIterator());
    }

    /+ friend inline QConstIterator operator+(qsizetype j, const QConstIterator &k)
    {
        return k + j;
    } +/
}

/// Binding for C++ class [QIterable](https://doc.qt.io/qt-6/qiterable.html).
class QIterable(Container)
{
private:
    /+ friend class QBaseIterator<Container>; +/

protected:
    uint m_revision = 0;
    ValueClass!(/+ QtPrivate:: +/QConstPreservingPointer!(void, quint16)) m_iterable;
    Container m_metaContainer;

public:
    /+ template<class T> +/
    this(T)(ref const(Container) metaContainer, const(T)* p)
    {
        this.m_iterable = p;
        this.m_metaContainer = metaContainer;
    }

    /+ template<class T> +/
    this(T)(ref const(Container) metaContainer, T* p)
    {
        this.m_iterable = p;
        this.m_metaContainer = metaContainer;
    }

    /+ template<typename Pointer> +/
    this(Pointer)(ref const(Container) metaContainer, Pointer iterable)
    {
        this.m_iterable = iterable;
        this.m_metaContainer = metaContainer;
    }

    this(ref const(Container) metaContainer, qsizetype alignment, const(void)* p)
    {
        this.m_iterable = typeof(this.m_iterable)(p, alignment);
        this.m_metaContainer = metaContainer;
    }

    this(ref const(Container) metaContainer, qsizetype alignment, void* p)
    {
        this.m_iterable = typeof(this.m_iterable)(p, alignment);
        this.m_metaContainer = metaContainer;
    }

    final bool canInputIterate() const
    {
        return m_metaContainer.hasInputIterator();
    }

    final bool canForwardIterate() const
    {
        return m_metaContainer.hasForwardIterator();
    }

    final bool canReverseIterate() const
    {
        return m_metaContainer.hasBidirectionalIterator();
    }

    final bool canRandomAccessIterate() const
    {
        return m_metaContainer.hasRandomAccessIterator();
    }

    final const(void)* constIterable() const { return m_iterable.constPointer(); }
    final void* mutableIterable() { return m_iterable.mutablePointer(); }

    final QConstIterator!(Container) constBegin() const
    {
        return QConstIterator(this, m_metaContainer.constBegin(constIterable()));
    }

    final QConstIterator!(Container) constEnd() const
    {
        return QConstIterator(this, m_metaContainer.constEnd(constIterable()));
    }

    final QIterator!(Container) mutableBegin()
    {
        return QIterator(this, m_metaContainer.begin(mutableIterable()));
    }

    final QIterator!(Container) mutableEnd()
    {
        return QIterator(this, m_metaContainer.end(mutableIterable()));
    }

    final qsizetype size() const
    {
        const(void)* container = constIterable();
        if (m_metaContainer.hasSize())
            return m_metaContainer.size(container);
        if (!m_metaContainer.hasConstIterator())
            return -1;

        const(void)* begin = m_metaContainer.constBegin(container);
        const(void)* end = m_metaContainer.constEnd(container);
        const(qsizetype) size = m_metaContainer.diffConstIterator(end, begin);
        m_metaContainer.destroyConstIterator(begin);
        m_metaContainer.destroyConstIterator(end);
        return size;
    }

    final Container metaContainer() const
    {
        return m_metaContainer;
    }/+ ; +/
}

