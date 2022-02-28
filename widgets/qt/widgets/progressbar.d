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
module qt.widgets.progressbar;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.size;
import qt.core.string;
import qt.gui.event;
import qt.helpers;
import qt.widgets.styleoption;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(progressbar); +/


extern(C++, class) struct QProgressBarPrivate;

/// Binding for C++ class [QProgressBar](https://doc.qt.io/qt-6/qprogressbar.html).
class /+ Q_WIDGETS_EXPORT +/ QProgressBar : QWidget
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(int minimum READ minimum WRITE setMinimum)
    Q_PROPERTY(int maximum READ maximum WRITE setMaximum)
    Q_PROPERTY(QString text READ text)
    Q_PROPERTY(int value READ value WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(Qt::Alignment alignment READ alignment WRITE setAlignment)
    Q_PROPERTY(bool textVisible READ isTextVisible WRITE setTextVisible)
    Q_PROPERTY(Qt::Orientation orientation READ orientation WRITE setOrientation)
    Q_PROPERTY(bool invertedAppearance READ invertedAppearance WRITE setInvertedAppearance)
    Q_PROPERTY(Direction textDirection READ textDirection WRITE setTextDirection)
    Q_PROPERTY(QString format READ format WRITE setFormat RESET resetFormat) +/

public:
    enum Direction { TopToBottom, BottomToTop }
    /+ Q_ENUM(Direction) +/

    /+ explicit +/this(QWidget parent = null);
    ~this();

    final int minimum() const;
    final int maximum() const;

    final int value() const;

    /+ virtual +/ QString text() const;
    final void setTextVisible(bool visible);
    final bool isTextVisible() const;

    final /+ Qt:: +/qt.core.namespace.Alignment alignment() const;
    final void setAlignment(/+ Qt:: +/qt.core.namespace.Alignment alignment);

    override QSize sizeHint() const;
    override QSize minimumSizeHint() const;

    final /+ Qt:: +/qt.core.namespace.Orientation orientation() const;

    final void setInvertedAppearance(bool invert);
    final bool invertedAppearance() const;
    final void setTextDirection(Direction textDirection);
    final Direction textDirection() const;

    final void setFormat(ref const(QString) format);
    final void resetFormat();
    final QString format() const;

public /+ Q_SLOTS +/:
    @QSlot final void reset();
    @QSlot final void setRange(int minimum, int maximum);
    @QSlot final void setMinimum(int minimum);
    @QSlot final void setMaximum(int maximum);
    @QSlot final void setValue(int value);
    @QSlot final void setOrientation(/+ Qt:: +/qt.core.namespace.Orientation);

/+ Q_SIGNALS +/public:
    @QSignal final void valueChanged(int value);

protected:
    override bool event(QEvent e);
    override void paintEvent(QPaintEvent );
    /+ virtual +/ void initStyleOption(QStyleOptionProgressBar* option) const;

private:
    /+ Q_DECLARE_PRIVATE(QProgressBar) +/
    /+ Q_DISABLE_COPY(QProgressBar) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

