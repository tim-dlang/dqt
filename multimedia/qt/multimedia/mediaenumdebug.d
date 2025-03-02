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
module qt.multimedia.mediaenumdebug;
extern(C++):

import qt.config;
import qt.helpers;

//
//  W A R N I N G
//  -------------
//
// This file is not part of the Qt API. It exists purely as an
// implementation detail. This header file may change from version to
// version without notice, or even be removed.
//
// We mean it.


/+ #ifndef QT_NO_DEBUG_STREAM

#define Q_MEDIA_ENUM_DEBUG(Class,Enum) \
inline QDebug operator<<(QDebug dbg, Class::Enum value) \
{ \
    int index = Class::staticMetaObject.indexOfEnumerator(#Enum); \
    dbg.nospace() << #Class << "::" << Class::staticMetaObject.enumerator(index).valueToKey(value); \
    return dbg.space(); \
}

#else

#define Q_MEDIA_ENUM_DEBUG(Class,Enum)

#endif +/ //QT_NO_DEBUG_STREAM

