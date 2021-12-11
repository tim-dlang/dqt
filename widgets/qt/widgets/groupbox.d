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
module qt.widgets.groupbox;
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

/+ QT_REQUIRE_CONFIG(groupbox); +/


extern(C++, class) struct QGroupBoxPrivate;
/+ class QStyleOptionGroupBox; +/
/// Binding for C++ class [QGroupBox](https://doc.qt.io/qt-5/qgroupbox.html).
class /+ Q_WIDGETS_EXPORT +/ QGroupBox : QWidget
{
    mixin(Q_OBJECT);

    /+ Q_PROPERTY(QString title READ title WRITE setTitle)
    Q_PROPERTY(Qt::Alignment alignment READ alignment WRITE setAlignment)
    Q_PROPERTY(bool flat READ isFlat WRITE setFlat)
    Q_PROPERTY(bool checkable READ isCheckable WRITE setCheckable)
    Q_PROPERTY(bool checked READ isChecked WRITE setChecked NOTIFY toggled USER true) +/
public:
    /+ explicit +/this(QWidget parent = null);
    /+ explicit +/this(ref const(QString) title, QWidget parent = null);
    ~this();

    final QString title() const;
    final void setTitle(ref const(QString) title);
    final void setTitle(const(QString) title)
    {
        setTitle(title);
    }

    final /+ Qt:: +/qt.core.namespace.Alignment alignment() const;
    final void setAlignment(int alignment);

    override QSize minimumSizeHint() const;

    final bool isFlat() const;
    final void setFlat(bool flat);
    final bool isCheckable() const;
    final void setCheckable(bool checkable);
    final bool isChecked() const;

public /+ Q_SLOTS +/:
    @QSlot final void setChecked(bool checked);

/+ Q_SIGNALS +/public:
    @QSignal final void clicked(bool checked = false);
    @QSignal final void toggled(bool);

protected:
    override bool event(QEvent event);
    override void childEvent(QChildEvent event);
    override void resizeEvent(QResizeEvent event);
    override void paintEvent(QPaintEvent event);
    override void focusInEvent(QFocusEvent event);
    override void changeEvent(QEvent event);
    override void mousePressEvent(QMouseEvent event);
    override void mouseMoveEvent(QMouseEvent event);
    override void mouseReleaseEvent(QMouseEvent event);
    final void initStyleOption(QStyleOptionGroupBox* option) const;


private:
    /+ Q_DISABLE_COPY(QGroupBox) +/
    /+ Q_DECLARE_PRIVATE(QGroupBox) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_setChildrenEnabled(bool b)) +/
}

