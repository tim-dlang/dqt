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
module qt.core.mimedata;
extern(C++):

import qt.config;
import qt.core.bytearray;
import qt.core.list;
import qt.core.object;
import qt.core.string;
import qt.core.stringlist;
import qt.core.url;
import qt.core.variant;
import qt.helpers;

/+ class QUrl; +/
extern(C++, class) struct QMimeDataPrivate;

/// Binding for C++ class [QMimeData](https://doc.qt.io/qt-5/qmimedata.html).
class /+ Q_CORE_EXPORT +/ QMimeData : QObject
{
    mixin(Q_OBJECT);
public:
    this();
    ~this();

    final QList!(QUrl) urls() const;
    final void setUrls(ref const(QList!(QUrl)) urls);
    final bool hasUrls() const;

    final QString text() const;
    final void setText(ref const(QString) text);
    final bool hasText() const;

    final QString html() const;
    final void setHtml(ref const(QString) html);
    final bool hasHtml() const;

    final QVariant imageData() const;
    final void setImageData(ref const(QVariant) image);
    final bool hasImage() const;

    final QVariant colorData() const;
    final void setColorData(ref const(QVariant) color);
    final bool hasColor() const;

    final QByteArray data(ref const(QString) mimetype) const;
    final void setData(ref const(QString) mimetype, ref const(QByteArray) data);
    final void removeFormat(ref const(QString) mimetype);

    /+ virtual +/ bool hasFormat(ref const(QString) mimetype) const;
    /+ virtual +/ QStringList formats() const;

    final void clear();
protected:
    /+ virtual +/ QVariant retrieveData(ref const(QString) mimetype,
                                          QVariant.Type preferredType) const;
private:
    /+ Q_DISABLE_COPY(QMimeData) +/
    /+ Q_DECLARE_PRIVATE(QMimeData) +/
}

