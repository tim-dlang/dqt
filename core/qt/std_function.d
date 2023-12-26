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
module qt.std_function;

import core.stdcpp.xutility : StdNamespace;
import std.traits;

extern(C++, (StdNamespace)):

version (CppRuntime_Microsoft)
{

enum int _Small_object_num_ptrs = 6 + 16 / (void*).sizeof;
enum size_t _Space_size = (_Small_object_num_ptrs - 1) * (void*).sizeof;

struct type_info;

abstract class _Func_base(_Fty) if (isSomeFunction!_Fty)
{
public:
    _Func_base _Copy(void*) const;
    _Func_base _Move(void*) nothrow;
    ReturnType!_Fty _Do_call(ref ParameterTypeTuple!_Fty);
    ref const(type_info) _Target_type() const nothrow;
    void _Delete_this(bool) nothrow;

    this()
    {
    }
    // dtor non-virtual due to _Delete_this()

//private:
    const(void)* _Get() const nothrow;
};

extern(D) class FuncImplD(_Fty, F2) : _Func_base!(_Fty)
        if (isSomeFunction!_Fty && isSomeFunction!F2)
{
public:
    pragma(mangle, FuncImplD.mangleof ~ "___Copy")
    override extern(C++) _Func_base!(_Fty) _Copy(void* _Where) const
    {
        import core.lifetime : emplace, forward;

        auto _Ptr = *cast(FuncImplD!(_Fty, F2)*) &_Where;
        emplace(_Ptr, callback);
        return _Ptr;
    }

    pragma(mangle, FuncImplD.mangleof ~ "___Move")
    override extern(C++) _Func_base!(_Fty) _Move(void* _Where) nothrow
    {
        import core.lifetime : emplace, forward;

        auto _Ptr = *cast(FuncImplD!(_Fty, F2)*) &_Where;
        emplace(_Ptr, callback);
        return _Ptr;
    }

    pragma(mangle, FuncImplD.mangleof ~ "___Do_call")
    override extern(C++) ReturnType!_Fty _Do_call(ref ParameterTypeTuple!_Fty params)
    {
        return callback(params);
    }

    pragma(mangle, FuncImplD.mangleof ~ "___Target_type")
    override extern(C++) ref const(type_info) _Target_type() const nothrow
    {
        assert(false);
    }

    pragma(mangle, FuncImplD.mangleof ~ "___Delete_this")
    override extern(C++) void _Delete_this(bool) nothrow
    {
    }

    this(F2 callback) nothrow
    {
        this.callback = callback;
    }

    // dtor non-virtual due to _Delete_this()

//private:
    pragma(mangle, FuncImplD.mangleof ~ "___Get")
    override extern(C++) const(void)* _Get() const nothrow
    {
        return null;
    }

    F2 callback;
};

extern(C++, class) struct _Func_class(_Fty) if (isSomeFunction!_Fty)
{
public:
    alias result_type = ReturnType!_Fty;

    alias _Ptrt = _Func_base!(_Fty);

    ~this() nothrow
    {
    }

private:
    union _Storage
    {
        ulong/*max_align_t*/ _Dummy1;
        byte[_Space_size] _Dummy2;
        _Ptrt[_Small_object_num_ptrs] _Ptrs;
    }

    _Storage _Mystorage;
    _Ptrt _Getimpl() /*const*/ nothrow
    {
        return _Mystorage._Ptrs[_Small_object_num_ptrs - 1];
    }

    void _Set(_Ptrt _Ptr) nothrow
    {
        _Mystorage._Ptrs[_Small_object_num_ptrs - 1] = _Ptr;
    }
}

extern(C++, class) struct std_function(_Fty) if (isSomeFunction!_Fty)
{
    _Func_class!(_Fty) base0;

    extern(D) this(F2)(F2 callback) if (isSomeFunction!F2)
    {
        import core.lifetime : emplace, forward;

        static assert(__traits(classInstanceSize, FuncImplD!(_Fty, F2)) <= _Space_size);

        void* data = &base0._Mystorage;
        auto impl = emplace(*cast(FuncImplD!(_Fty, F2)*) &data, callback);
        base0._Set(impl);
    }

    @disable this(this);
}

}
else version (CppRuntime_Clang)
{

abstract class __base(F)
{
    this() {}
    ~this() {}
    abstract __base __clone() const;
    abstract void __clone(__base) const;
    abstract void destroy() nothrow;
    abstract void destroy_deallocate() nothrow;
    abstract ReturnType!F opCall(ref ParameterTypeTuple!F);
    abstract const(void)* target(const void*) const nothrow;
    abstract const(void)* target_type() const nothrow;
};

extern(D) class FuncImplD(F, F2) : __base!(F)
        if (isSomeFunction!F && isSomeFunction!F2)
{
public:
    pragma(mangle, FuncImplD.mangleof ~ "__clone")
    override extern(C++) __base!F __clone() const
    {
        assert(false);
    }

    pragma(mangle, FuncImplD.mangleof ~ "__clone2")
    override extern(C++) void __clone(__base!F p) const
    {
        import core.lifetime : emplace, forward;

        void* data = cast(void*) p;
        auto impl = emplace(*cast(FuncImplD*) &data, callback);
    }

    pragma(mangle, FuncImplD.mangleof ~ "__destroy")
    override extern(C++) void destroy() nothrow
    {
    }

    pragma(mangle, FuncImplD.mangleof ~ "__destroy_deallocate")
    override extern(C++) void destroy_deallocate() nothrow
    {
    }

    pragma(mangle, FuncImplD.mangleof ~ "__opCall")
    override extern(C++) ReturnType!F opCall(ref ParameterTypeTuple!F params)
    {
        return callback(params);
    }

    pragma(mangle, FuncImplD.mangleof ~ "__target")
    override extern(C++) const(void)* target(const void*) const nothrow
    {
        assert(false);
    }

    pragma(mangle, FuncImplD.mangleof ~ "__target_type")
    override extern(C++) const(void)* target_type() const nothrow
    {
        assert(false);
    }

    this(F2 callback)
    {
        this.callback = callback;
    }

    F2 callback;
}

extern(C++, class) struct __value_func(F) if (isSomeFunction!F)
{
align (16):
    void*[3] __buf;
    alias __func = __base!(F);
    __func __f_;
}

extern(C++, class) struct std_function(F) if (isSomeFunction!F)
{
    alias __func = __value_func!(F);

    __func __f_;

    extern(D) this(F2)(F2 callback) if (isSomeFunction!F2)
    {
        import core.lifetime : emplace, forward;

        static assert(__traits(classInstanceSize, FuncImplD!(F, F2)) <= 3 * (void*).sizeof);

        void* data = __f_.__buf.ptr;
        auto impl = emplace(*cast(FuncImplD!(F, F2)*) &data, callback);
        __f_.__f_ = impl;
    }

    @disable this(this);
}

}
else // Assume every other platform is like gcc libcxx
{

union _Nocopy_types
{
    void* _M_object;
    const void* _M_const_object;
    void function() _M_function_pointer;
    void*[2] _M_member_pointer; //void (_Undefined_class::*_M_member_pointer)();
}

union _Any_data
{
    _Nocopy_types _M_unused;
    byte[_Nocopy_types.sizeof] _M_pod_data;
}

enum _Manager_operation
{
    __get_type_info,
    __get_functor_ptr,
    __clone_functor,
    __destroy_functor
}

extern(C++, class) struct _Function_base
{
    ~this()
    {
        if (_M_manager)
            _M_manager(_M_functor, _M_functor, _Manager_operation.__destroy_functor);
    }

    alias _Manager_type = bool function(ref _Any_data, ref const(_Any_data), _Manager_operation);

    _Any_data _M_functor;
    _Manager_type _M_manager;
}

extern(C++, class) struct std_function(F) if (isSomeFunction!F)
{
    _Function_base base1;

    this(ref const(std_function) __x)
    {
        if (__x.base1._M_manager)
        {
            __x.base1._M_manager(base1._M_functor, __x.base1._M_functor,
                    _Manager_operation.__clone_functor);
            _M_invoker = __x._M_invoker;
            base1._M_manager = __x.base1._M_manager;
        }
    }

    static bool manager_impl(ref _Any_data __dest, ref const _Any_data __source,
            _Manager_operation __op)
    {
        switch (__op)
        {
        case _Manager_operation.__get_type_info:
            break;

        case _Manager_operation.__get_functor_ptr:
            break;

        case _Manager_operation.__clone_functor:
            __dest._M_pod_data = __source._M_pod_data;
            break;

        case _Manager_operation.__destroy_functor:
            __dest._M_pod_data[] = 0;
            break;
        default:
        }
        return false;
    }

    template invoke_impl(F2)
    {
        pragma(mangle, std_function.mangleof ~ "___" ~ F2.mangleof ~ "__invoke_impl")
        static extern(C++) ReturnType!(F) invoke_impl(ref const(_Any_data) functor,
                ref ParameterTypeTuple!(F) args)
        {
            return (*(cast(F2*) &functor._M_pod_data))(args);
        }
    }

    extern(D) this(F2)(F2 callback) if (isSomeFunction!F2)
    {
        static assert(F2.sizeof <= base1._M_functor._M_pod_data.sizeof);
        _M_invoker = &invoke_impl!F2;
        base1._M_manager = &manager_impl;
        *(cast(F2*) &base1._M_functor._M_pod_data) = callback;
    }

    alias _Invoker_type = ReturnType!(F) function(ref const(_Any_data),
            ref ParameterTypeTuple!(F));
    _Invoker_type _M_invoker;
}

}
