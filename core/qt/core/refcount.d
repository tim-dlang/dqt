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
module qt.core.refcount;
extern(C++):

import qt.config;
import qt.core.basicatomic;
import qt.helpers;

extern(C++, "QtPrivate")
{


extern(C++, class) struct RefCount
{
public:
    extern(D) pragma(inline, true) bool ref_(string filename = __FILE__, size_t line = __LINE__) nothrow {
        int count = atomic.loadRelaxed();
        if (count != -1) // !isStatic
            atomic.ref_();
        return true;
    }

    extern(D) pragma(inline, true) bool deref(string filename = __FILE__, size_t line = __LINE__) nothrow {
        int count = atomic.loadRelaxed();
        if (count == -1) // isStatic
            return true;
        return atomic.deref();
    }

/+    bool isStatic() const nothrow
    {
        // Persistent object, never deleted
        return atomic.loadRelaxed() == -1;
    }+/

    bool isShared() const nothrow
    {
        int count = atomic.loadRelaxed();
        return (count != 1) && (count != 0);
    }

//    void initializeOwned() nothrow { atomic.storeRelaxed(1); }
//    void initializeUnsharable() nothrow { atomic.storeRelaxed(0); }

    QBasicAtomicInt atomic;
}

}

/+ #define Q_REFCOUNT_INITIALIZE_STATIC { Q_BASIC_ATOMIC_INITIALIZER(-1) } +/


enum Q_REFCOUNT_INITIALIZE_STATIC = RefCount(QBasicAtomicInt(-1));

