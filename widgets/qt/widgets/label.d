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
module qt.widgets.label;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.size;
import qt.core.string;
import qt.gui.event;
import qt.gui.movie;
import qt.gui.pixmap;
import qt.helpers;
import qt.widgets.frame;
import qt.widgets.widget;
version (QT_NO_PICTURE) {} else
    import qt.gui.picture;

/+ QT_REQUIRE_CONFIG(label); +/



extern(C++, class) struct QLabelPrivate;

/// Binding for C++ class [QLabel](https://doc.qt.io/qt-5/qlabel.html).
class /+ Q_WIDGETS_EXPORT +/ QLabel : QFrame
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QString text READ text WRITE setText)
    Q_PROPERTY(Qt::TextFormat textFormat READ textFormat WRITE setTextFormat)
    Q_PROPERTY(QPixmap pixmap READ pixmap WRITE setPixmap)
    Q_PROPERTY(bool scaledContents READ hasScaledContents WRITE setScaledContents)
    Q_PROPERTY(Qt::Alignment alignment READ alignment WRITE setAlignment)
    Q_PROPERTY(bool wordWrap READ wordWrap WRITE setWordWrap)
    Q_PROPERTY(int margin READ margin WRITE setMargin)
    Q_PROPERTY(int indent READ indent WRITE setIndent)
    Q_PROPERTY(bool openExternalLinks READ openExternalLinks WRITE setOpenExternalLinks)
    Q_PROPERTY(Qt::TextInteractionFlags textInteractionFlags READ textInteractionFlags WRITE setTextInteractionFlags)
    Q_PROPERTY(bool hasSelectedText READ hasSelectedText)
    Q_PROPERTY(QString selectedText READ selectedText) +/

public:
    /+ explicit +/this(QWidget parent=null, /+ Qt:: +/qt.core.namespace.WindowFlags f=/+ Qt:: +/qt.core.namespace.WindowFlags());
    /+ explicit +/this(ref const(QString) text, QWidget parent=null, /+ Qt:: +/qt.core.namespace.WindowFlags f=/+ Qt:: +/qt.core.namespace.WindowFlags());
    ~this();

    final QString text() const;

/+ #if QT_DEPRECATED_SINCE(5,15) +/
    /+ QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QPixmap by-value") +/
        final const(QPixmap)* pixmap() const; // ### Qt 7: Remove function

    final QPixmap pixmap(/+ Qt:: +/qt.core.namespace.ReturnByValueConstant) const;
/+ #else
    QPixmap pixmap(Qt::ReturnByValueConstant = Qt::ReturnByValue) const; // ### Qt 7: Remove arg
#endif // QT_DEPRECATED_SINCE(5,15)

#ifndef QT_NO_PICTURE
#  if QT_DEPRECATED_SINCE(5,15) +/
    version (QT_NO_PICTURE) {} else
    {
        /+ QT_DEPRECATED_VERSION_X(5, 15, "Use the other overload which returns QPicture by-value") +/
            final const(QPicture)* picture() const; // ### Qt 7: Remove function

        final QPicture picture(/+ Qt:: +/qt.core.namespace.ReturnByValueConstant) const;
    }
/+ #  else
    QPicture picture(Qt::ReturnByValueConstant = Qt::ReturnByValue) const; // ### Qt 7: Remove arg
#  endif // QT_DEPRECATED_SINCE(5,15)
#endif
#if QT_CONFIG(movie) +/
    final QMovie movie() const;
/+ #endif +/

    final /+ Qt:: +/qt.core.namespace.TextFormat textFormat() const;
    final void setTextFormat(/+ Qt:: +/qt.core.namespace.TextFormat);

    final /+ Qt:: +/qt.core.namespace.Alignment alignment() const;
    final void setAlignment(/+ Qt:: +/qt.core.namespace.Alignment);

    final void setWordWrap(bool on);
    final bool wordWrap() const;

    final int indent() const;
    final void setIndent(int);

    final int margin() const;
    final void setMargin(int);

    final bool hasScaledContents() const;
    final void setScaledContents(bool);
    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;
    version (QT_NO_SHORTCUT) {} else
    {
        final void setBuddy(QWidget );
        final QWidget buddy() const;
    }
    override int heightForWidth(int) const;

    final bool openExternalLinks() const;
    final void setOpenExternalLinks(bool open);

    final void setTextInteractionFlags(/+ Qt:: +/qt.core.namespace.TextInteractionFlags flags);
    final /+ Qt:: +/qt.core.namespace.TextInteractionFlags textInteractionFlags() const;

    final void setSelection(int, int);
    final bool hasSelectedText() const;
    final QString selectedText() const;
    final int selectionStart() const;

public /+ Q_SLOTS +/:
    @QSlot final void setText(ref const(QString) );
    @QSlot final void setPixmap(ref const(QPixmap) );
/+ #ifndef QT_NO_PICTURE +/
    version (QT_NO_PICTURE) {} else
    {
        @QSlot final void setPicture(ref const(QPicture) );
    }
/+ #endif
#if QT_CONFIG(movie) +/
    @QSlot final void setMovie(QMovie movie);
/+ #endif +/
    @QSlot final void setNum(int);
    @QSlot final void setNum(double);
    @QSlot final void clear();

/+ Q_SIGNALS +/public:
    @QSignal final void linkActivated(ref const(QString) link);
    @QSignal final void linkHovered(ref const(QString) link);

protected:
    override bool event(QEvent e);
    override void keyPressEvent(QKeyEvent ev);
    override void paintEvent(QPaintEvent );
    override void changeEvent(QEvent );
    override void mousePressEvent(QMouseEvent ev);
    override void mouseMoveEvent(QMouseEvent ev);
    override void mouseReleaseEvent(QMouseEvent ev);
    version (QT_NO_CONTEXTMENU) {} else
    {
        override void contextMenuEvent(QContextMenuEvent ev);
    }
    override void focusInEvent(QFocusEvent ev);
    override void focusOutEvent(QFocusEvent ev);
    override bool focusNextPrevChild(bool next);


private:
    /+ Q_DISABLE_COPY(QLabel) +/
    /+ Q_DECLARE_PRIVATE(QLabel) +/
/+ #if QT_CONFIG(movie)
    Q_PRIVATE_SLOT(d_func(), void _q_movieUpdated(const QRect&))
    Q_PRIVATE_SLOT(d_func(), void _q_movieResized(const QSize&))
#endif
    Q_PRIVATE_SLOT(d_func(), void _q_linkHovered(const QString &))

#ifndef QT_NO_SHORTCUT
    Q_PRIVATE_SLOT(d_func(), void _q_buddyDeleted())
#endif +/
    /+ friend class QTipLabel; +/
    /+ friend class QMessageBoxPrivate; +/
    /+ friend class QBalloonTip; +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

