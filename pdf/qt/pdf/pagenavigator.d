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
module qt.pdf.pagenavigator;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.object;
import qt.core.point;
import qt.core.scopedpointer;
import qt.helpers;
import qt.pdf.link;

struct QPdfPageNavigatorPrivate;

/// Binding for C++ class [QPdfPageNavigator](https://doc.qt.io/qt-6/qpdfpagenavigator.html).
class /+ Q_PDF_EXPORT +/ QPdfPageNavigator : QObject
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(int currentPage READ currentPage NOTIFY currentPageChanged)
    Q_PROPERTY(QPointF currentLocation READ currentLocation NOTIFY currentLocationChanged)
    Q_PROPERTY(qreal currentZoom READ currentZoom NOTIFY currentZoomChanged)
    Q_PROPERTY(bool backAvailable READ backAvailable NOTIFY backAvailableChanged)
    Q_PROPERTY(bool forwardAvailable READ forwardAvailable NOTIFY forwardAvailableChanged) +/

public:
    this()
    {
        this(null);
    }
    /+ explicit +/this(QObject parent);
    ~this();

    final int currentPage() const;
    final QPointF currentLocation() const;
    final qreal currentZoom() const;

    final bool backAvailable() const;
    final bool forwardAvailable() const;

public /+ Q_SLOTS +/:
    @QSlot final void clear();
    @QSlot final void jump(QPdfLink destination);
    @QSlot final void jump(int page, ref const(QPointF) location, qreal zoom = 0);
    @QSlot final void update(int page, ref const(QPointF) location, qreal zoom);
    @QSlot final void forward();
    @QSlot final void back();

/+ Q_SIGNALS +/public:
    @QSignal final void currentPageChanged(int page);
    @QSignal final void currentLocationChanged(QPointF location);
    @QSignal final void currentZoomChanged(qreal zoom);
    @QSignal final void backAvailableChanged(bool available);
    @QSignal final void forwardAvailableChanged(bool available);
    @QSignal final void jumped(QPdfLink current);

protected:
    final QPdfLink currentLink() const;

private:
    QScopedPointer!(QPdfPageNavigatorPrivate) d;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

