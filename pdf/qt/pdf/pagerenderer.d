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
module qt.pdf.pagerenderer;
extern(C++):

import qt.config;
import qt.core.global;
import qt.core.object;
import qt.core.scopedpointer;
import qt.core.size;
import qt.gui.image;
import qt.helpers;
import qt.pdf.document;
import qt.pdf.documentrenderoptions;

extern(C++, class) struct QPdfPageRendererPrivate;

/// Binding for C++ class [QPdfPageRenderer](https://doc.qt.io/qt-6/qpdfpagerenderer.html).
class /+ Q_PDF_EXPORT +/ QPdfPageRenderer : QObject
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QPdfDocument* document READ document WRITE setDocument NOTIFY documentChanged)
    Q_PROPERTY(RenderMode renderMode READ renderMode WRITE setRenderMode NOTIFY renderModeChanged) +/

public:
    enum /+ class +/ RenderMode
    {
        MultiThreaded,
        SingleThreaded
    }
    /+ Q_ENUM(RenderMode) +/

    this()
    {
        this(null);
    }
    /+ explicit +/this(QObject parent);
    ~this();

    final RenderMode renderMode() const;
    final void setRenderMode(RenderMode mode);

    final QPdfDocument document() const;
    final void setDocument(QPdfDocument document);

    final quint64 requestPage(int pageNumber, QSize imageSize,
                            QPdfDocumentRenderOptions options = QPdfDocumentRenderOptions());

/+ Q_SIGNALS +/public:
    @QSignal final void documentChanged(QPdfDocument document);
    @QSignal final void renderModeChanged(RenderMode renderMode);

    @QSignal final void pageRendered(int pageNumber, QSize imageSize, ref const(QImage) image,
                          QPdfDocumentRenderOptions options, quint64 requestId);

private:
    QScopedPointer!(QPdfPageRendererPrivate) d_ptr;
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

