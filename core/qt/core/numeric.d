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
module qt.core.numeric;
extern(C++):

import qt.config;
import qt.core.global;
import qt.helpers;

/+ Q_CORE_EXPORT +/ /+ Q_DECL_CONST_FUNCTION +/ bool qIsInf(double d);
/+ Q_CORE_EXPORT +/ /+ Q_DECL_CONST_FUNCTION +/ bool qIsNaN(double d);
/+ Q_CORE_EXPORT +/ /+ Q_DECL_CONST_FUNCTION +/ bool qIsFinite(double d);
/+ Q_CORE_EXPORT +/ /+ Q_DECL_CONST_FUNCTION +/ int qFpClassify(double val);
/+ Q_CORE_EXPORT +/ /+ Q_DECL_CONST_FUNCTION +/ bool qIsInf(float f);
/+ Q_CORE_EXPORT +/ /+ Q_DECL_CONST_FUNCTION +/ bool qIsNaN(float f);
/+ Q_CORE_EXPORT +/ /+ Q_DECL_CONST_FUNCTION +/ bool qIsFinite(float f);
/+ Q_CORE_EXPORT +/ /+ Q_DECL_CONST_FUNCTION +/ int qFpClassify(float val);
/+ #if QT_CONFIG(signaling_nan) +/
/+ Q_CORE_EXPORT +/ /+ Q_DECL_CONST_FUNCTION +/ double qSNaN();
/+ #endif +/
/+ Q_CORE_EXPORT +/ /+ Q_DECL_CONST_FUNCTION +/ double qQNaN();
/+ Q_CORE_EXPORT +/ /+ Q_DECL_CONST_FUNCTION +/ double qInf();

/+ Q_CORE_EXPORT +/ quint32 qFloatDistance(float a, float b);
/+ Q_CORE_EXPORT +/ quint64 qFloatDistance(double a, double b);

/+ #define Q_INFINITY (QT_PREPEND_NAMESPACE(qInf)())
#if QT_CONFIG(signaling_nan)
#  define Q_SNAN (QT_PREPEND_NAMESPACE(qSNaN)())
#endif
#define Q_QNAN (QT_PREPEND_NAMESPACE(qQNaN)()) +/


