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
module qt.widgets.keysequenceedit;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.namespace;
import qt.core.string;
import qt.gui.event;
import qt.gui.keysequence;
import qt.helpers;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(keysequenceedit); +/


extern(C++, class) struct QKeySequenceEditPrivate;
/// Binding for C++ class [QKeySequenceEdit](https://doc.qt.io/qt-6/qkeysequenceedit.html).
class /+ Q_WIDGETS_EXPORT +/ QKeySequenceEdit : QWidget
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QKeySequence keySequence READ keySequence WRITE setKeySequence
               NOTIFY keySequenceChanged USER true)
    Q_PROPERTY(bool clearButtonEnabled READ isClearButtonEnabled WRITE setClearButtonEnabled) +/

public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QKeySequence) keySequence, QWidget parent = null);
    ~this();

    final QKeySequence keySequence() const;

    final void setClearButtonEnabled(bool enable);
    final bool isClearButtonEnabled() const;

public /+ Q_SLOTS +/:
    @QSlot final void setKeySequence(ref const(QKeySequence) keySequence);
    final void setKeySequence(const QString keySequence)
    {
        auto tmp = QKeySequence(keySequence);
        setKeySequence(tmp);
    }
    @QSlot final void clear();

/+ Q_SIGNALS +/public:
    @QSignal final void editingFinished();
    @QSignal final void keySequenceChanged(ref const(QKeySequence) keySequence);

protected:
    this(ref QKeySequenceEditPrivate d, QWidget parent, /+ Qt:: +/qt.core.namespace.WindowFlags f);

    override bool event(QEvent );
    override void keyPressEvent(QKeyEvent );
    override void keyReleaseEvent(QKeyEvent );
    override void timerEvent(QTimerEvent );
    override void focusOutEvent(QFocusEvent );

private:
    /+ Q_DISABLE_COPY(QKeySequenceEdit) +/
    /+ Q_DECLARE_PRIVATE(QKeySequenceEdit) +/
    mixin(CREATE_CONVENIENCE_WRAPPERS);
}

