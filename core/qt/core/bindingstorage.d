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
module qt.core.bindingstorage;
extern(C++):

import qt.config;
import qt.core.namespace;
import qt.core.propertyprivate;
import qt.helpers;

/+ template <typename Class, typename T, auto Offset, auto Setter, auto Signal, auto Getter>
class QObjectCompatProperty; +/
struct QPropertyDelayedNotifications;

extern(C++, "QtPrivate") {

struct BindingEvaluationState;
struct CompatPropertySafePoint;
}

struct QBindingStatus
{
    /+ QtPrivate:: +/BindingEvaluationState* currentlyEvaluatingBinding = null;
    /+ QtPrivate:: +/CompatPropertySafePoint* currentCompatProperty = null;
    /+ Qt:: +/qt.core.namespace.HANDLE threadId = null;
    QPropertyDelayedNotifications* groupUpdateData = null;
}


struct QBindingStorageData;
extern(C++, class) struct /+ Q_CORE_EXPORT +/ QBindingStorage
{
private:
    /+ mutable +/ QBindingStorageData* d = null;
    QBindingStatus* bindingStatus = null;

    /+ template<typename Class, typename T, auto Offset, auto Setter, auto Signal, auto Getter> +/
    /+ friend class QObjectCompatProperty; +/
    /+ friend class QObjectPrivate; +/
    /+ friend class QtPrivate::QPropertyBindingData; +/
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

    bool isEmpty() { return !d; }

    void registerDependency(const(QUntypedPropertyData)* data) const
    {
        if (!bindingStatus.currentlyEvaluatingBinding)
            return;
        registerDependency_helper(data);
    }
    /+ QtPrivate:: +/qt.core.propertyprivate.QPropertyBindingData* bindingData(const(QUntypedPropertyData)* data) const
    {
        if (!d)
            return null;
        return bindingData_helper(data);
    }

    static if (defined!"QT_CORE_BUILD_REMOVED_API")
    {
        void maybeUpdateBindingAndRegister(const(QUntypedPropertyData)* data) const { registerDependency(data); }
    }

    /+ QtPrivate:: +/qt.core.propertyprivate.QPropertyBindingData* bindingData(QUntypedPropertyData* data, bool create)
    {
        if (!d && !create)
            return null;
        return bindingData_helper(data, create);
    }
private:
    void clear();
    void registerDependency_helper(const(QUntypedPropertyData)* data) const;
    static if (defined!"QT_CORE_BUILD_REMOVED_API")
    {
        // ### Unused, but keep for BC
        void maybeUpdateBindingAndRegister_helper(const(QUntypedPropertyData)* data) const;
    }
    /+ QtPrivate:: +/qt.core.propertyprivate.QPropertyBindingData* bindingData_helper(const(QUntypedPropertyData)* data) const;
    /+ QtPrivate:: +/qt.core.propertyprivate.QPropertyBindingData* bindingData_helper(QUntypedPropertyData* data, bool create);
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

