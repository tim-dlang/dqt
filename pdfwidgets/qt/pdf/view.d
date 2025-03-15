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
module qt.pdf.view;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.margins;
import qt.core.scopedpointer;
import qt.gui.event;
import qt.helpers;
import qt.pdf.document;
import qt.pdf.pagenavigator;
import qt.widgets.abstractscrollarea;
import qt.widgets.widget;

extern(C++, class) struct QPdfViewPrivate;

/// Binding for C++ class [QPdfView](https://doc.qt.io/qt-6/qpdfview.html).
class /+ Q_PDF_WIDGETS_EXPORT +/ QPdfView : QAbstractScrollArea
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QPdfDocument* document READ document WRITE setDocument NOTIFY documentChanged)

    Q_PROPERTY(PageMode pageMode READ pageMode WRITE setPageMode NOTIFY pageModeChanged)
    Q_PROPERTY(ZoomMode zoomMode READ zoomMode WRITE setZoomMode NOTIFY zoomModeChanged)
    Q_PROPERTY(qreal zoomFactor READ zoomFactor WRITE setZoomFactor NOTIFY zoomFactorChanged)

    Q_PROPERTY(int pageSpacing READ pageSpacing WRITE setPageSpacing NOTIFY pageSpacingChanged)
    Q_PROPERTY(QMargins documentMargins READ documentMargins WRITE setDocumentMargins NOTIFY documentMarginsChanged) +/

public:
    enum /+ class +/ PageMode
    {
        SinglePage,
        MultiPage
    }
    /+ Q_ENUM(PageMode) +/

    enum /+ class +/ ZoomMode
    {
        Custom,
        FitToWidth,
        FitInView
    }
    /+ Q_ENUM(ZoomMode) +/

    this()
    {
        this(null);
    }
    /+ explicit +/this(QWidget parent);
    ~this();

    final void setDocument(QPdfDocument document);
    final QPdfDocument document() const;

    final QPdfPageNavigator pageNavigator() const;

    final PageMode pageMode() const;
    final ZoomMode zoomMode() const;
    final qreal zoomFactor() const;

    final int pageSpacing() const;
    final void setPageSpacing(int spacing);

    final QMargins documentMargins() const;
    final void setDocumentMargins(QMargins margins);

public /+ Q_SLOTS +/:
    @QSlot final void setPageMode(PageMode mode);
    @QSlot final void setZoomMode(ZoomMode mode);
    @QSlot final void setZoomFactor(qreal factor);

/+ Q_SIGNALS +/public:
    @QSignal final void documentChanged(QPdfDocument document);
    @QSignal final void pageModeChanged(PageMode pageMode);
    @QSignal final void zoomModeChanged(ZoomMode zoomMode);
    @QSignal final void zoomFactorChanged(qreal zoomFactor);
    @QSignal final void pageSpacingChanged(int pageSpacing);
    @QSignal final void documentMarginsChanged(QMargins documentMargins);

protected:
    override void paintEvent(QPaintEvent event);
    override void resizeEvent(QResizeEvent event);
    override void scrollContentsBy(int dx, int dy);

private:
    /+ Q_DECLARE_PRIVATE(QPdfView) +/
    QScopedPointer!(QPdfViewPrivate) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

