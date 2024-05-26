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

    @disable this();
    this(bool printWarning/+ = true+/);

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

// Execute code in constructor before first QQmlEngine is instantiated
static if (defined!"QT_QML_DEBUG_NO_WARNING")
{
extern(D) static __gshared auto qQmlEnableDebuggingHelper = QQmlDebuggingEnabler(false);
}
static if (defined!"QT_QML_DEBUG" && !defined!"QT_QML_DEBUG_NO_WARNING")
{
extern(D) static __gshared auto qQmlEnableDebuggingHelper = QQmlDebuggingEnabler(true);
}

/+ #endif +/

