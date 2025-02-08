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
module qt.qml.debug_;
extern(C++):

import qt.config;
import qt.core.string;
import qt.core.stringlist;
import qt.helpers;

/+ #if QT_CONFIG(qml_debug) +/

struct /+ Q_QML_EXPORT +/ QQmlDebuggingEnabler
{
    enum StartMode {
        DoNotWaitForClient,
        WaitForClient
    }

    static void enableDebugging(bool printWarning);

/+ #if QT_DEPRECATED_SINCE(6, 4) +/
    @disable this();
    /+ QT_DEPRECATED_VERSION_X_6_4("Use QQmlTriviallyDestructibleDebuggingEnabler instead "
                                    "or just call QQmlDebuggingEnabler::enableDebugging().") +/this(bool printWarning/+ = true+/);
/+ #endif +/

    static QStringList debuggerServices();
    static QStringList inspectorServices();
    static QStringList profilerServices();
    static QStringList nativeDebuggerServices();

    static void setServices(ref const(QStringList) services);

    static bool startTcpDebugServer(int port, StartMode mode = StartMode.DoNotWaitForClient,
                                        ref const(QString) hostName = globalInitVar!QString);
    static bool connectToLocalDebugger(ref const(QString) socketFileName,
                                           StartMode mode = StartMode.DoNotWaitForClient);
    /+ static bool startDebugConnector(const QString &pluginName,
                                    const QVariantHash &configuration = QVariantHash()); +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

// Unnamed namespace to signal the compiler that we
// indeed want each TU to have its own QQmlDebuggingEnabler.
/+ namespace { +/
/*struct QQmlTriviallyDestructibleDebuggingEnabler {
    @disable this();
    this(bool printWarning/+ = true+/)
    {
        static assert(/+ std:: +/is_trivially_destructible_v!(QQmlTriviallyDestructibleDebuggingEnabler));
        QQmlDebuggingEnabler.enableDebugging(printWarning);
    }
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}*/
// Execute code in constructor before first QQmlEngine is instantiated
static if (defined!"QT_QML_DEBUG_NO_WARNING")
{
//extern(D) static __gshared auto qQmlEnableDebuggingHelper = QQmlTriviallyDestructibleDebuggingEnabler(false);
}
static if (defined!"QT_QML_DEBUG" && !defined!"QT_QML_DEBUG_NO_WARNING")
{
//extern(D) static __gshared auto qQmlEnableDebuggingHelper = QQmlTriviallyDestructibleDebuggingEnabler(true);
}
/+ } +/ // unnamed namespace

/+ #endif +/

