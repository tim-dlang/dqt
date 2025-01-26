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
module qt.qml.property;
extern(C++):

import qt.config;
import qt.core.list;
import qt.core.metamacros;
import qt.core.metaobject;
import qt.core.metatype;
import qt.core.object;
import qt.core.string;
import qt.core.typeinfo;
import qt.core.variant;
import qt.helpers;
import qt.qml.context;
import qt.qml.engine;


extern(C++, class) struct QQmlPropertyPrivate;
/// Binding for C++ class [QQmlProperty](https://doc.qt.io/qt-6/qqmlproperty.html).
@Q_RELOCATABLE_TYPE extern(C++, class) struct /+ Q_QML_EXPORT +/ QQmlProperty
{
    mixin(Q_GADGET);
    /+ QML_ANONYMOUS
    QML_ADDED_IN_VERSION(2, 15)

    Q_PROPERTY(QObject *object READ object CONSTANT FINAL)
    Q_PROPERTY(QString name READ name CONSTANT FINAL) +/
public:
    enum PropertyTypeCategory {
        InvalidCategory,
        List,
        Object,
        Normal
    }

    enum Type {
        Invalid,
        Property,
        SignalProperty
    }

    @disable this();
    pragma(mangle, defaultConstructorMangling(__traits(identifier, typeof(this))))
    void rawConstructor();
    static typeof(this) create()
    {
        typeof(this) r = typeof(this).init;
        r.rawConstructor();
        return r;
    }

    ~this();

    this(QObject );
    this(QObject , QQmlContext );
    this(QObject , QQmlEngine );

    this(QObject , ref const(QString) );
    this(QObject , ref const(QString) , QQmlContext );
    this(QObject , ref const(QString) , QQmlEngine );

    @disable this(this);
    this(ref const(QQmlProperty) );
    /+ref QQmlProperty operator =(ref const(QQmlProperty) );+/

    /+ QQmlProperty(QQmlProperty &&other) noexcept : d(std::exchange(other.d, nullptr)) {} +/
    /+ QT_MOVE_ASSIGNMENT_OPERATOR_IMPL_VIA_MOVE_AND_SWAP(QQmlProperty) +/

    /+ void swap(QQmlProperty &other) noexcept { qt_ptr_swap(d, other.d); } +/
    /+bool operator ==(ref const(QQmlProperty) ) const;+/

    Type type() const;
    bool isValid() const;
    bool isProperty() const;
    bool isSignalProperty() const;

    int propertyType() const;
    QMetaType propertyMetaType() const;
    PropertyTypeCategory propertyTypeCategory() const;
    const(char)* propertyTypeName() const;

    QString name() const;

    QVariant read() const;
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static QVariant read(const(QObject) , ref const(QString) );
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static QVariant read(const(QObject) , ref const(QString) , QQmlContext );
    }));
    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    static QVariant read(const(QObject) , ref const(QString) , QQmlEngine );
    }));

    bool write(ref const(QVariant) ) const;
    static bool write(QObject , ref const(QString) , ref const(QVariant) );
    static bool write(QObject , ref const(QString) , ref const(QVariant) , QQmlContext );
    static bool write(QObject , ref const(QString) , ref const(QVariant) , QQmlEngine );

    bool reset() const;

    bool hasNotifySignal() const;
    bool needsNotifySignal() const;
    bool connectNotifySignal(QObject dest, const(char)* slot) const;
    bool connectNotifySignal(QObject dest, int method) const;

    bool isWritable() const;
    bool isBindable() const;
    bool isDesignable() const;
    bool isResettable() const;
    QObject object() const;

    int index() const;
    QMetaProperty property() const;
    QMetaMethod method() const;

private:
    /+ friend class QQmlPropertyPrivate; +/
    QQmlPropertyPrivate* d = null;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}
alias QQmlProperties = QList!(QQmlProperty);

/+ inline size_t qHash (const QQmlProperty &key, size_t seed = 0)
{
    return qHashMulti(seed, key.object(), key.name());
}

Q_DECLARE_TYPEINFO(QQmlProperty, Q_RELOCATABLE_TYPE); +/

