module examplewidgets.tabtext;

import qt.config;
import qt.core.coreevent;
import qt.helpers;
import qt.widgets.ui;
import qt.widgets.widget;

class TabText : QWidget
{
    mixin(Q_OBJECT_D);

public:
    /+ explicit +/this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);

        connect(ui.textEdit.signal!"undoAvailable", ui.pushButtonUndo.slot!"setEnabled");
        connect(ui.textEdit.signal!"redoAvailable", ui.pushButtonRedo.slot!"setEnabled");
        connect(ui.pushButtonUndo.signal!"clicked", ui.textEdit.slot!"undo");
        connect(ui.pushButtonRedo.signal!"clicked", ui.textEdit.slot!"redo");

        connect(ui.pushButtonBold.signal!"clicked", this.slot!"changeFormat");
        connect(ui.pushButtonItalic.signal!"clicked", this.slot!"changeFormat");

        on_textEdit_textChanged();
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
    }

private /+ slots +/:
    @QSlot final void on_textEdit_textChanged()
    {
        ui.textBrowser.setHtml(ui.textEdit.document().toHtml());
    }

    @QSlot final void on_textEdit_cursorPositionChanged()
    {
        import qt.gui.font;
        import qt.gui.textcursor;

        QTextCursor cursor = ui.textEdit.textCursor();
        ui.pushButtonList.setChecked(cursor.currentList() !is null);
        ui.pushButtonBold.setChecked(cursor.charFormat().fontWeight() == QFont.Weight.Bold);
        ui.pushButtonItalic.setChecked(cursor.charFormat().fontItalic());
    }

    @QSlot final void changeFormat()
    {
        import qt.gui.font;
        import qt.gui.textcursor;
        import qt.gui.textformat;

        QTextCharFormat format;
        format.setFontWeight(ui.pushButtonBold.isChecked() ? QFont.Weight.Bold : QFont.Weight.Normal);
        format.setFontItalic(ui.pushButtonItalic.isChecked());
        QTextCursor cursor = ui.textEdit.textCursor();
        cursor.mergeCharFormat(format);
        ui.textEdit.mergeCurrentCharFormat(format);
        ui.textEdit.setFocus();
    }

    @QSlot final void on_pushButtonList_clicked()
    {
        import qt.gui.textcursor;
        import qt.gui.textformat;
        import qt.gui.textlist;

        QTextCursor cursor = ui.textEdit.textCursor();
        if(ui.pushButtonList.isChecked())
        {
            QTextListFormat listFmt;
            listFmt.setStyle(QTextListFormat.Style.ListDecimal);
            //cursor.createList(listFmt);TODO: only the following works
            cursor.createList(QTextListFormat.Style.ListDecimal);
        }
        else
        {
            QTextList list = cursor.currentList();
            if(list)
            {
                list.remove(cursor.block());
            }

            QTextBlockFormat blockFmt = cursor.blockFormat();
            blockFmt.setIndent(0);
            cursor.setBlockFormat(blockFmt);
        }
    }

protected:
    override extern(C++) void changeEvent(QEvent event)
    {
        if(event.type() == QEvent.Type.LanguageChange)
            ui.retranslateUi(this);
        QWidget.changeEvent(event);
    }

private:
    UIStruct!"tabtext.ui"* ui;
}

