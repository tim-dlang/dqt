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
    extern(D) pragma(inline, true) bool ref_(string filename = __FILE__, size_t line = __LINE__)/+ noexcept+/ {
        int count = atomic.loadRelaxed();
        version (QT_NO_UNSHARABLE_CONTAINERS) {} else
        {
            if (count == 0) // !isSharable
                return false;
        }

        if (count != -1) // !isStatic
            atomic.ref_();
        return true;
    }

    extern(D) pragma(inline, true) bool deref(string filename = __FILE__, size_t line = __LINE__)/+ noexcept+/ {
        int count = atomic.loadRelaxed();
        version (QT_NO_UNSHARABLE_CONTAINERS) {} else
        {
            if (count == 0) // !isSharable
                return false;
        }

        if (count == -1) // isStatic
            return true;
        return atomic.deref();
    }

    version (QT_NO_UNSHARABLE_CONTAINERS) {} else
    {
        bool setSharable(bool sharable)/+ noexcept+/
        {
            import qt.core.global;

            (mixin(Q_ASSERT(q{!isShared()})));
            if (sharable)
                return atomic.testAndSetRelaxed(0, 1);
            else
                return atomic.testAndSetRelaxed(1, 0);
        }

        bool isSharable() const/+ noexcept+/
        {
            // Sharable === Shared ownership.
            return atomic.loadRelaxed() != 0;
        }
    }

/+    bool isStatic() const/+ noexcept+/
    {
        // Persistent object, never deleted
        return atomic.loadRelaxed() == -1;
    }+/

    bool isShared() const/+ noexcept+/
    {
        int count = atomic.loadRelaxed();
        return (count != 1) && (count != 0);
    }

//    void initializeOwned()/+ noexcept+/ { atomic.storeRelaxed(1); }
//    void initializeUnsharable()/+ noexcept+/ { atomic.storeRelaxed(0); }

    QBasicAtomicInt atomic;
}

}

/+ #define Q_REFCOUNT_INITIALIZE_STATIC { Q_BASIC_ATOMIC_INITIALIZER(-1) } +/


enum Q_REFCOUNT_INITIALIZE_STATIC = RefCount(QBasicAtomicInt(-1));

