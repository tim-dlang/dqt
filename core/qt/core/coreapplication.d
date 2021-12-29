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
module qt.core.coreapplication;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.eventloop;
import qt.core.global;
import qt.core.namespace;
import qt.core.object;
import qt.core.string;
import qt.core.stringlist;
import qt.helpers;

/+ #ifndef QT_NO_QOBJECT
#else
#endif

#ifndef QT_NO_QOBJECT +/
version(Cygwin){}else
version(Windows)
{
struct tagMSG;
alias MSG = tagMSG;
}
/+ #endif +/



extern(C++, class) struct QCoreApplicationPrivate;
extern(C++, class) struct QTranslator;
extern(C++, class) struct QPostEventList;
extern(C++, class) struct QAbstractEventDispatcher;
extern(C++, class) struct QAbstractNativeEventFilter;

/+ #define qApp QCoreApplication::instance() +/

/// Binding for C++ class [QCoreApplication](https://doc.qt.io/qt-5/qcoreapplication.html).
class /+ Q_CORE_EXPORT +/ QCoreApplication
/+ #ifndef QT_NO_QOBJECT +/
    : QObject
/+ #endif +/
{
/+ #ifndef QT_NO_QOBJECT +/
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QString applicationName READ applicationName WRITE setApplicationName NOTIFY applicationNameChanged)
    Q_PROPERTY(QString applicationVersion READ applicationVersion WRITE setApplicationVersion NOTIFY applicationVersionChanged)
    Q_PROPERTY(QString organizationName READ organizationName WRITE setOrganizationName NOTIFY organizationNameChanged)
    Q_PROPERTY(QString organizationDomain READ organizationDomain WRITE setOrganizationDomain NOTIFY organizationDomainChanged)
    Q_PROPERTY(bool quitLockEnabled READ isQuitLockEnabled WRITE setQuitLockEnabled)
#endif

    Q_DECLARE_PRIVATE(QCoreApplication) +/
public:
    enum { ApplicationFlags = QT_VERSION
    }

    this(ref int argc, char** argv
    /+ #ifndef Q_QDOC +/
                         , int = ApplicationFlags
    /+ #endif +/
                );

    ~this();

    static QStringList arguments();

    static void setAttribute(/+ Qt:: +/qt.core.namespace.ApplicationAttribute attribute, bool on = true);
    static bool testAttribute(/+ Qt:: +/qt.core.namespace.ApplicationAttribute attribute);

    static void setOrganizationDomain(ref const(QString) orgDomain);
    static QString organizationDomain();
    static void setOrganizationName(ref const(QString) orgName);
    static QString organizationName();
    static void setApplicationName(ref const(QString) application);
    static void setApplicationName(const(QString) application)
    {
        setApplicationName(application);
    }
    static QString applicationName();
    static void setApplicationVersion(ref const(QString) version_);
    static QString applicationVersion();

    static void setSetuidAllowed(bool allow);
    static bool isSetuidAllowed();

    static QCoreApplication instance() { return self; }

/+ #ifndef QT_NO_QOBJECT +/
    static int exec();
    static void processEvents(QEventLoop.ProcessEventsFlags flags = QEventLoop.ProcessEventsFlag.AllEvents);
    static void processEvents(QEventLoop.ProcessEventsFlags flags, int maxtime);
    static void exit(int retcode=0);

    static bool sendEvent(QObject receiver, QEvent event);
    static void postEvent(QObject receiver, QEvent event, int priority = /+ Qt:: +/qt.core.namespace.EventPriority.NormalEventPriority);
    static void sendPostedEvents(QObject receiver = null, int event_type = 0);
    static void removePostedEvents(QObject receiver, int eventType = 0);
/+ #if QT_DEPRECATED_SINCE(5, 3) +/
    /+ QT_DEPRECATED +/ static bool hasPendingEvents();
/+ #endif +/
    static QAbstractEventDispatcher* eventDispatcher();
    static void setEventDispatcher(QAbstractEventDispatcher* eventDispatcher);

    /+ virtual +/ bool notify(QObject , QEvent );

    static bool startingUp();
    static bool closingDown();
/+ #endif +/

    static QString applicationDirPath();
    static QString applicationFilePath();
    static qint64 applicationPid()/+ /+ Q_DECL_CONST_FUNCTION +/__attribute__((const))+/;

/+ #if QT_CONFIG(library) +/
    static void setLibraryPaths(ref const(QStringList) );
    static QStringList libraryPaths();
    static void addLibraryPath(ref const(QString) );
    static void removeLibraryPath(ref const(QString) );
/+ #endif // QT_CONFIG(library)

#ifndef QT_NO_TRANSLATION +/
    version(QT_NO_TRANSLATION){}else
    {
        static bool installTranslator(QTranslator*  messageFile);
        static bool removeTranslator(QTranslator*  messageFile);
    }
/+ #endif +/

    static QString translate(const(char)*  context,
                                 const(char)*  key,
                                 const(char)*  disambiguation = null,
                                 int n = -1);
/+ #if QT_DEPRECATED_SINCE(5, 0)
    enum Encoding { UnicodeUTF8, Latin1, DefaultCodec = UnicodeUTF8, CodecForTr = UnicodeUTF8 };
    QT_DEPRECATED static inline QString translate(const char * context, const char * key,
                             const char * disambiguation, Encoding, int n = -1)
        { return translate(context, key, disambiguation, n); }
#endif

#ifndef QT_NO_QOBJECT
#  if QT_DEPRECATED_SINCE(5, 9) +/
    /+ QT_DEPRECATED +/ static void flush();
/+ #  endif +/

    final void installNativeEventFilter(QAbstractNativeEventFilter* filterObj);
    final void removeNativeEventFilter(QAbstractNativeEventFilter* filterObj);

    static bool isQuitLockEnabled();
    static void setQuitLockEnabled(bool enabled);

public /+ Q_SLOTS +/:
    @QSlot static void quit();

/+ Q_SIGNALS +/public:
    @QSignal final void aboutToQuit(QPrivateSignal);

    @QSignal final void organizationNameChanged();
    @QSignal final void organizationDomainChanged();
    @QSignal final void applicationNameChanged();
    @QSignal final void applicationVersionChanged();

protected:
    override bool event(QEvent );

    /+ virtual +/ bool compressEvent(QEvent , QObject receiver, QPostEventList* );
/+ #endif +/ // QT_NO_QOBJECT

protected:
    this(ref QCoreApplicationPrivate p);

/+ #ifdef QT_NO_QOBJECT
    QScopedPointer<QCoreApplicationPrivate> d_ptr;
#endif +/

private:
/+ #ifndef QT_NO_QOBJECT +/
    static bool sendSpontaneousEvent(QObject receiver, QEvent event);
/+ #  if QT_DEPRECATED_SINCE(5,6) +/
    /+ QT_DEPRECATED +/ final bool notifyInternal(QObject receiver, QEvent event); // ### Qt6 BIC: remove me
/+ #  endif +/
    static bool notifyInternal2(QObject receiver, QEvent );
    static bool forwardEvent(QObject receiver, QEvent event, QEvent originatingEvent = null);
/+ #endif
#if QT_CONFIG(library) +/
    static QStringList libraryPathsLocked();
/+ #endif +/

    mixin(mangleWindows("?self@QCoreApplication@@0PEAV1@EA", exportOnWindows ~ q{
    extern static __gshared QCoreApplication self;
    }));

    /+ Q_DISABLE_COPY(QCoreApplication) +/

    /+ friend class QApplication; +/
    /+ friend class QApplicationPrivate; +/
    /+ friend class QGuiApplication; +/
    /+ friend class QGuiApplicationPrivate; +/
    /+ friend class QWidget; +/
    /+ friend class QWidgetWindow; +/
    /+ friend class QWidgetPrivate; +/
/+ #ifndef QT_NO_QOBJECT +/
    /+ friend class QEventDispatcherUNIXPrivate; +/
    /+ friend class QCocoaEventDispatcherPrivate; +/
    /+ friend bool qt_sendSpontaneousEvent(QObject*, QEvent*); +/
/+ #endif +/
    /+ friend Q_CORE_EXPORT QString qAppName(); +/
    /+ friend class QClassFactory; +/
    /+ friend class QCommandLineParserPrivate; +/
}

/+ #ifdef QT_NO_DEPRECATED
#  define QT_DECLARE_DEPRECATED_TR_FUNCTIONS(context)
#else +/
/+ #  define QT_DECLARE_DEPRECATED_TR_FUNCTIONS(context) \
    QT_DEPRECATED static inline QString trUtf8(const char *sourceText, const char *disambiguation = nullptr, int n = -1) \
        { return QCoreApplication::translate(#context, sourceText, disambiguation, n); } +/
extern(D) alias QT_DECLARE_DEPRECATED_TR_FUNCTIONS = function string(string context)
{
    return
            mixin(interpolateMixin(q{/+ QT_DEPRECATED +/ pragma(inline, true) static QString trUtf8(const(char)* sourceText, const(char)* disambiguation = null, int n = -1)
                { return QCoreApplication.translate($(stringifyMacroParameter(context)), sourceText, disambiguation, n); }}));
};
/+ #endif

#define Q_DECLARE_TR_FUNCTIONS(context) \
public: \
    static inline QString tr(const char *sourceText, const char *disambiguation = nullptr, int n = -1) \
        { return QCoreApplication::translate(#context, sourceText, disambiguation, n); } \
    QT_DECLARE_DEPRECATED_TR_FUNCTIONS(context) \
private: +/

alias QtStartUpFunction = ExternCPPFunc!(void function());
alias QtCleanUpFunction = ExternCPPFunc!(void function());

/+ Q_CORE_EXPORT +/ void qAddPreRoutine(QtStartUpFunction);
/+ Q_CORE_EXPORT +/ void qAddPostRoutine(QtCleanUpFunction);
/+ Q_CORE_EXPORT +/ void qRemovePostRoutine(QtCleanUpFunction);
/+ Q_CORE_EXPORT +/ QString qAppName();                // get application name

/+ #define Q_COREAPP_STARTUP_FUNCTION(AFUNC) \
    static void AFUNC ## _ctor_function() {  \
        qAddPreRoutine(AFUNC);        \
    }                                 \
    Q_CONSTRUCTOR_FUNCTION(AFUNC ## _ctor_function)

#ifndef QT_NO_QOBJECT
#if defined(Q_OS_WIN) && !defined(QT_NO_DEBUG_STREAM)
Q_CORE_EXPORT QString decodeMSG(const MSG &);
Q_CORE_EXPORT QDebug operator<<(QDebug, const MSG &);
#endif
#endif +/
static if(!versionIsSet!("Windows") || versionIsSet!("Cygwin"))
{
struct tagMSG;
}

static if(!versionIsSet!("Windows") || versionIsSet!("Cygwin"))
{
alias MSG = tagMSG;
}


