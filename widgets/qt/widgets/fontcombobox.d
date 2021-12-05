/****************************************************************************
**
** DQt - D bindings for the Qt Toolkit
**
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl-3.0.html.
**
****************************************************************************/
module qt.widgets.fontcombobox;
extern(C++):

import qt.config;
import qt.core.coreevent;
import qt.core.flags;
import qt.core.size;
import qt.gui.font;
import qt.gui.fontdatabase;
import qt.helpers;
import qt.widgets.combobox;
import qt.widgets.widget;

/+ QT_REQUIRE_CONFIG(fontcombobox); +/


extern(C++, class) struct QFontComboBoxPrivate;

class /+ Q_WIDGETS_EXPORT +/ QFontComboBox : QComboBox
{
    mixin(Q_OBJECT);
    /+ Q_PROPERTY(QFontDatabase::WritingSystem writingSystem READ writingSystem WRITE setWritingSystem)
    Q_PROPERTY(FontFilters fontFilters READ fontFilters WRITE setFontFilters)
    Q_PROPERTY(QFont currentFont READ currentFont WRITE setCurrentFont NOTIFY currentFontChanged) +/

public:
    /+ explicit +/this(QWidget parent = null);
    ~this();

    final void setWritingSystem(QFontDatabase.WritingSystem);
    final QFontDatabase.WritingSystem writingSystem() const;

    enum FontFilter {
        AllFonts = 0,
        ScalableFonts = 0x1,
        NonScalableFonts = 0x2,
        MonospacedFonts = 0x4,
        ProportionalFonts = 0x8
    }
    /+ Q_DECLARE_FLAGS(FontFilters, FontFilter) +/
alias FontFilters = QFlags!(FontFilter);    /+ Q_FLAG(FontFilters) +/

    final void setFontFilters(FontFilters filters);
    final FontFilters fontFilters() const;

    final QFont currentFont() const;
    override QSize sizeHint() const;

public /+ Q_SLOTS +/:
    @QSlot final void setCurrentFont(ref const(QFont) f);

/+ Q_SIGNALS +/public:
    @QSignal final void currentFontChanged(ref const(QFont) f);

protected:
    override bool event(QEvent e);

private:
    /+ Q_DISABLE_COPY(QFontComboBox) +/
    /+ Q_DECLARE_PRIVATE(QFontComboBox) +/
    /+ Q_PRIVATE_SLOT(d_func(), void _q_currentChanged(const QString &))
    Q_PRIVATE_SLOT(d_func(), void _q_updateModel()) +/
}
/+pragma(inline, true) QFlags!(QFontComboBox.FontFilters.enum_type) operator |(QFontComboBox.FontFilters.enum_type f1, QFontComboBox.FontFilters.enum_type f2)/+noexcept+/{return QFlags!(QFontComboBox.FontFilters.enum_type)(f1)|f2;}+/
/+pragma(inline, true) QFlags!(QFontComboBox.FontFilters.enum_type) operator |(QFontComboBox.FontFilters.enum_type f1, QFlags!(QFontComboBox.FontFilters.enum_type) f2)/+noexcept+/{return f2|f1;}+/
/+pragma(inline, true) QIncompatibleFlag operator |(QFontComboBox.FontFilters.enum_type f1, int f2)/+noexcept+/{return QIncompatibleFlag(int(f1)|f2);}+/

/+ Q_DECLARE_OPERATORS_FOR_FLAGS(QFontComboBox::FontFilters) +/
