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
module qt.core.hash;
extern(C++):

// QHash
// ⊤
// Type
// /usr/include/qt/QtCore/qhash.h:225:7
struct QHash(Key, T)
{
private:
    void *d;

public:
    @disable this();
    ~this(){assert(0);}
}

