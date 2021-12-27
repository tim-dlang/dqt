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
module qt.gui.clipboard;
extern(C++):

import qt.config;
import qt.helpers;
version(QT_NO_CLIPBOARD){}else
{
    import qt.core.mimedata;
    import qt.core.object;
    import qt.core.string;
    import qt.gui.image;
    import qt.gui.pixmap;
}

version(QT_NO_CLIPBOARD){}else
{


/// Binding for C++ class [QClipboard](https://doc.qt.io/qt-5/qclipboard.html).
class /+ Q_GUI_EXPORT +/ QClipboard : QObject
{
    mixin(Q_OBJECT);
private:
    /+ explicit +/this(QObject parent);
    ~this();

public:
    enum Mode { Clipboard, Selection, FindBuffer, LastMode = Mode.FindBuffer }

    final void clear(Mode mode = Mode.Clipboard);

    final bool supportsSelection() const;
    final bool supportsFindBuffer() const;

    final bool ownsSelection() const;
    final bool ownsClipboard() const;
    final bool ownsFindBuffer() const;

    final QString text(Mode mode = Mode.Clipboard) const;
    final QString text(ref QString subtype, Mode mode = Mode.Clipboard) const;
    final void setText(ref const(QString) , Mode mode = Mode.Clipboard);

    mixin(changeWindowsMangling(q{mangleClassesTailConst}, q{
    final const(QMimeData) mimeData(Mode mode = Mode.Clipboard ) const;
    }));
    final void setMimeData(QMimeData data, Mode mode = Mode.Clipboard);

    final QImage image(Mode mode = Mode.Clipboard) const;
    final QPixmap pixmap(Mode mode = Mode.Clipboard) const;
    final void setImage(ref const(QImage) , Mode mode  = Mode.Clipboard);
    final void setPixmap(ref const(QPixmap) , Mode mode  = Mode.Clipboard);

/+ Q_SIGNALS +/public:
    @QSignal final void changed(QClipboard.Mode mode);
    @QSignal final void selectionChanged();
    @QSignal final void findBufferChanged();
    @QSignal final void dataChanged();

protected:
    /+ friend class QApplication; +/
    /+ friend class QApplicationPrivate; +/
    /+ friend class QGuiApplication; +/
    /+ friend class QBaseApplication; +/
    /+ friend class QDragManager; +/
    /+ friend class QPlatformClipboard; +/

private:
    /+ Q_DISABLE_COPY(QClipboard) +/

    final bool supportsMode(Mode mode) const;
    final bool ownsMode(Mode mode) const;
    final void emitChanged(Mode mode);
}

}

