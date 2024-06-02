import core.stdc.stdarg;
import imports.importc_jni;
import std.stdio;

extern(C)
{
    JNINativeInterface globalEnvInterface;
    _JNIEnv globalEnv;
    _JavaVM globalJavaVM;
    JNIInvokeInterface globalInvokeInterface;

    jint DestroyJavaVM(JavaVM*)
    {
        return 0;
    }
    jint AttachCurrentThread(JavaVM*, JNIEnv**, void*)
    {
        return 0;
    }
    jint DetachCurrentThread(JavaVM*)
    {
        return 0;
    }
    jint GetEnv(JavaVM*, void** p, jint)
    {
        *cast(_JNIEnv**)p = &globalEnv;
        return 0;
    }
    jint AttachCurrentThreadAsDaemon(JavaVM*, JNIEnv**, void*)
    {
        return 0;
    }
}

/* Create a fake JVM instance, because it is needed by Qt. */
void registerAndroidJVM()
{
    import std.traits;
    static foreach (member; __traits(allMembers, JNINativeInterface))
    {
        static if (isSomeFunction!(__traits(getMember, JNINativeInterface, member)))
        {
            static if (variadicFunctionStyle!(__traits(getMember, JNINativeInterface, member)) == Variadic.no)
                __traits(getMember, globalEnvInterface, member) = function(Parameters!(__traits(getMember, JNINativeInterface, member))) {
                    static if (!is(ReturnType!(__traits(getMember, JNINativeInterface, member)) == void))
                        return ReturnType!(__traits(getMember, JNINativeInterface, member)).init;
                };
        }
    }
    globalEnv.functions = &globalEnvInterface;

    globalInvokeInterface.DestroyJavaVM = &DestroyJavaVM;
    globalInvokeInterface.AttachCurrentThread = &AttachCurrentThread;
    globalInvokeInterface.DetachCurrentThread = &DetachCurrentThread;
    globalInvokeInterface.GetEnv = &GetEnv;
    globalInvokeInterface.AttachCurrentThreadAsDaemon = &AttachCurrentThreadAsDaemon;

    globalJavaVM.functions = &globalInvokeInterface;
    _JavaVM* javaVM = &globalJavaVM;

    JNI_OnLoad(cast(JavaVM*) javaVM, null);
}
