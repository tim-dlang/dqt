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
module qt.gui.windowdefs;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.list;
import qt.helpers;

// Class forward definitions

extern(C++, class) struct QWindow;
version (QT_NO_CLIPBOARD)
{
extern(C++, class) struct QClipboard;
}


alias QWindowList = QList!(QWindow*);


// Window system dependent definitions


/+ #if defined(Q_OS_WIN)
#endif +/ // Q_OS_WIN




/+ QT_PREPEND_NAMESPACE(quintptr) +/alias WId = quintptr;




/+ typedef QHash<WId, QWidget *> QWidgetMapper;

template<class V> class QSet;
typedef QSet<QWidget *> QWidgetSet;


#if defined(QT_NEEDS_QMAIN)
#define main qMain
#endif +/

// Global platform-independent types and functions

