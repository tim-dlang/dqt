/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.gui.windowdefs;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.list;
import qt.helpers;

// Class forward definitions

/+ class QPaintDevice;
class QWidget; +/
extern(C++, class) struct QWindow;
/+ class QDialog;
class QColor;
class QPalette;
class QCursor;
class QPoint;
class QSize;
class QRect;
class QPolygon;
class QPainter;
class QRegion;
class QFont;
class QFontMetrics;
class QFontInfo;
class QPen;
class QBrush;
class QMatrix;
class QPixmap;
class QBitmap;
class QMovie;
class QImage;
class QTimer;
class QTime; +/
version(QT_NO_CLIPBOARD)
{
extern(C++, class) struct QClipboard;
}

/+ class QString;
class QByteArray;
class QApplication;

template<typename T> class QList; +/
alias QWindowList = QList!(QWindow*);


// Window system dependent definitions


/+ #if defined(Q_OS_WIN)
#endif +/ // Q_OS_WIN




/+ QT_PREPEND_NAMESPACE(quintptr) +/alias WId = quintptr;




/+ template<class K, class V> class QHash;
typedef QHash<WId, QWidget *> QWidgetMapper;

template<class V> class QSet;
typedef QSet<QWidget *> QWidgetSet;


#if defined(QT_NEEDS_QMAIN)
#define main qMain
#endif +/

// Global platform-independent types and functions

