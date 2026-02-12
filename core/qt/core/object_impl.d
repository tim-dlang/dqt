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
module qt.core.object_impl;
extern(C++):

import qt.config;
import qt.core.metatype;
import qt.helpers;
import std.traits;

/+ #ifndef Q_QDOC +/

/+ #ifndef QOBJECT_H
#error Do not include qobject_impl.h directly
#endif

#if 0
#pragma qt_sync_skip_header_check
#pragma qt_sync_stop_processing
#endif +/



extern(C++, "QtPrivate") {
    /*
        Logic to statically generate the array of qMetaTypeId
        ConnectionTypes<FunctionPointer<Signal>::Arguments>::types() returns an array
        of int that is suitable for the types arguments of the connection functions.

        The array only exist of all the types are declared as a metatype
        (detected using the TypesAreDeclaredMetaType helper struct)
        If one of the type is not declared, the function return 0 and the signal
        cannot be used in queued connection.
    */

    extern(D) enum TypesAreDeclaredMetaType(immutable(bool)[] areRef, Args...) = () {
        bool r = true;
        static foreach (i; 0 .. Args.length)
        {
            static if (areRef[i] && is(Args[i] == const))
                r = r && QMetaTypeId2!(Unqual!(Args[i])).Defined;
            else
                r = r && QMetaTypeId2!(Args[i]).Defined;
        }
        return r;
    } ();

    extern(D) template ConnectionTypes(immutable(bool)[] areRef, Args...)
    {
        static if (Args.length && TypesAreDeclaredMetaType!(areRef, Args))
        {
            static __gshared int[Args.length + 1] t;
            extern(D) shared static this()
            {
                static foreach (i; 0 .. Args.length)
                {
                    static if (areRef[i] && is(Args[i] == const))
                        t[i] = QMetaTypeIdHelper!(Unqual!(Args[i])).qt_metatype_id();
                    else
                        t[i] = QMetaTypeIdHelper!(Args[i]).qt_metatype_id();
                }
            }
            const(int*) types()
            {
                return t.ptr;
            }
        }
        else
            const(int*) types()
            {
                return null;
            }
    }

    // implementation of QSlotObjectBase for which the slot is a static function
    // Args and R are the List of arguments and the return type of the signal to which the slot is connected.
    /+ template<typename Func, typename Args, typename R> class QStaticSlotObject : public QSlotObjectBase
    {
        typedef QtPrivate::FunctionPointer<Func> FuncType;
        Func function;
        static void impl(int which, QSlotObjectBase *this_, QObject *r, void **a, bool *ret)
        {
            switch (which) {
            case Destroy:
                delete static_cast<QStaticSlotObject*>(this_);
                break;
            case Call:
                FuncType::template call<Args, R>(static_cast<QStaticSlotObject*>(this_)->function, r, a);
                break;
            case Compare:   // not implemented
            case NumOperations:
                Q_UNUSED(ret);
            }
        }
    public:
        explicit QStaticSlotObject(Func f) : QSlotObjectBase(&impl), function(f) {}
    }; +/
}



/+ #endif +/

