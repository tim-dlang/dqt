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
module qt.gui.drag;
extern(C++):

import qt.config;
import qt.core.mimedata;
import qt.core.namespace;
import qt.core.object;
import qt.core.point;
import qt.gui.pixmap;
import qt.helpers;

/+ QT_REQUIRE_CONFIG(draganddrop); +/


extern(C++, class) struct QDragPrivate;
extern(C++, class) struct QDragManager;


/// Binding for C++ class [QDrag](https://doc.qt.io/qt-6/qdrag.html).
class /+ Q_GUI_EXPORT +/ QDrag : QObject
{
    mixin(Q_OBJECT);
    /+ Q_DECLARE_PRIVATE(QDrag) +/
public:
    /+ explicit +/this(QObject dragSource);
    ~this();

    final void setMimeData(QMimeData data);
    final QMimeData mimeData() const;

    final void setPixmap(ref const(QPixmap) );
    final QPixmap pixmap() const;

    final void setHotSpot(ref const(QPoint) hotspot);
    final QPoint hotSpot() const;

    final QObject source() const;
    final QObject target() const;

    final /+ Qt:: +/qt.core.namespace.DropAction exec(/+ Qt:: +/qt.core.namespace.DropActions supportedActions = /+ Qt:: +/qt.core.namespace.DropAction.MoveAction);
    final /+ Qt:: +/qt.core.namespace.DropAction exec(/+ Qt:: +/qt.core.namespace.DropActions supportedActions, /+ Qt:: +/qt.core.namespace.DropAction defaultAction);

    final void setDragCursor(ref const(QPixmap) cursor, /+ Qt:: +/qt.core.namespace.DropAction action);
    final QPixmap dragCursor(/+ Qt:: +/qt.core.namespace.DropAction action) const;

    final /+ Qt:: +/qt.core.namespace.DropActions supportedActions() const;
    final /+ Qt:: +/qt.core.namespace.DropAction defaultAction() const;

    static void cancel();

/+ Q_SIGNALS +/public:
    @QSignal final void actionChanged(/+ Qt:: +/qt.core.namespace.DropAction action);
    @QSignal final void targetChanged(QObject newTarget);

private:
    /+ friend class QDragManager; +/
    /+ Q_DISABLE_COPY(QDrag) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

