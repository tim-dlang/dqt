module pdfreader.mainwindow;

import qt.config;
import qt.core.abstractitemmodel;
import qt.core.coreevent;
import qt.core.object;
import qt.core.string;
import qt.helpers;
import qt.pdf.document;
import qt.widgets.label;
import qt.widgets.mainwindow;
import qt.widgets.ui;
import qt.widgets.widget;
import std.conv;

class MainWindow : QMainWindow
{
    mixin(Q_OBJECT_D);

public:
    this(string filename, QWidget parent = null)
    {
        import core.stdcpp.new_;
        import qt.core.itemselectionmodel;
        import qt.core.list;
        import qt.core.namespace;
        import qt.pdf.bookmarkmodel;
        import qt.pdf.pagenavigator;
        import qt.pdf.view;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);

        ui.splitter.setStretchFactor(1, 1);
        QList!(int) sizes;
        sizes ~= 130;
        sizes ~= 500;
        sizes ~= 150;
        ui.splitter.setSizes(sizes);
        labelStatus = cpp_new!QLabel(this);
        ui.statusbar.addPermanentWidget(labelStatus);

        document = cpp_new!QPdfDocument(this);
        ui.pdfView.setDocument(document);
        ui.pdfView.setPageMode(QPdfView.PageMode.MultiPage);
        ui.pdfView.viewport().installEventFilter(this);

        QPdfBookmarkModel bookmarkModel = cpp_new!QPdfBookmarkModel(this);
        bookmarkModel.setDocument(document);
        ui.bookmarks.setModel(bookmarkModel);
        connect(ui.bookmarks.selectionModel().signal!"currentChanged", this.slot!"onBookmarkSelected");

        ui.thumbnails.setModel(document.pageModel());
        connect(ui.thumbnails.selectionModel().signal!"currentChanged", this.slot!"onThumbnailChanged");

        connect(ui.pdfView.pageNavigator().signal!"currentPageChanged", this.slot!"onCurrentPageChanged");
        connect(document.signal!"pageCountChanged", this.slot!"onCurrentPageChanged", /+ Qt:: +/qt.core.namespace.ConnectionType.QueuedConnection);
        connect(document.signal!"statusChanged", this.slot!"onPdfStatusChanged", /+ Qt:: +/qt.core.namespace.ConnectionType.QueuedConnection);

        if (filename.length)
            document.load(filename);
        else
            onCurrentPageChanged();
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
    }

    override extern(C++) bool eventFilter(QObject object, QEvent event)
    {
        import qt.core.math;
        import qt.core.namespace;
        import qt.gui.event;

        if (object == ui.pdfView.viewport() && event.type() == QEvent.Type.Wheel)
        {
            QWheelEvent wheelEvent = static_cast!(QWheelEvent)(event);
            if (wheelEvent.modifiers() & /+ Qt:: +/qt.core.namespace.KeyboardModifier.ControlModifier)
            {
                double zoomFactor = ui.pdfView.zoomFactor();
                zoomFactor = zoomFactor * qPow(2.0, wheelEvent.angleDelta().y() * 0.001);
                setZoomFactor(zoomFactor);
                return true;
            }
        }
        return false;
    }

    final void setZoomFactor(double zoomFactor, bool setText = true)
    {
        import qt.core.global;
        import qt.pdf.view;
        import qt.widgets.scrollbar;

        QScrollBar verticalScrollBar = ui.pdfView.verticalScrollBar();
        QScrollBar horizontalScrollBar = ui.pdfView.horizontalScrollBar();
        double verticalScrollPos = verticalScrollBar.maximum() ? double(verticalScrollBar.value()) / double(verticalScrollBar.maximum()) : 0.5;
        double horizontalScrollPos = horizontalScrollBar.maximum() ? double(horizontalScrollBar.value()) / double(horizontalScrollBar.maximum()) : 0.5;
        zoomFactor = qBound(0.1, zoomFactor, 10.0);
        ui.pdfView.setZoomMode(QPdfView.ZoomMode.Custom);
        ui.pdfView.setZoomFactor(zoomFactor);
        if (setText)
            ui.comboBoxZoom.setCurrentText(QString.number(qRound(zoomFactor * 100)) ~ "%");
        verticalScrollBar.setValue(qRound(verticalScrollPos * verticalScrollBar.maximum()));
        horizontalScrollBar.setValue(qRound(horizontalScrollPos * horizontalScrollBar.maximum()));
    }

private /+ slots +/:
    @QSlot final void onBookmarkSelected(ref const(QModelIndex) index)
    {
        import qt.core.global;
        import qt.core.point;
        import qt.pdf.bookmarkmodel;

        if (!index.isValid())
            return;

        const(int) page = index.data(int(QPdfBookmarkModel.Role.Page)).toInt();
        const(qreal) zoomLevel = index.data(int(QPdfBookmarkModel.Role.Level)).toReal();
        auto nav = ui.pdfView.pageNavigator();
        nav.jump(page, QPointF(), zoomLevel);
    }

    @QSlot final void onThumbnailChanged(ref const(QModelIndex) index)
    {
        import qt.core.point;

        auto nav = ui.pdfView.pageNavigator();
        nav.jump(index.row(), QPointF());
    }

    @QSlot final void onCurrentPageChanged()
    {
        int page = ui.pdfView.pageNavigator().currentPage();
        ui.thumbnails.setCurrentIndex(ui.thumbnails.model().index(page, 0));
        ui.labelPage.setText("/ " ~ QString.number(document.pageCount()) ~ " (" ~ document.pageLabel(page) ~ ")");
        ui.spinBoxPage.setMaximum(document.pageCount());
        ui.spinBoxPage.setValue(page + 1);
    }

    @QSlot final void on_actionMetadata_triggered()
    {
        import qt.core.variant;
        import qt.widgets.messagebox;

        QString text;
        text ~= "<table>\n";
        for (int i = 0; i <= int(QPdfDocument.MetaDataField.ModificationDate); i++)
        {
            QPdfDocument.MetaDataField m = cast(QPdfDocument.MetaDataField) (i);
            QVariant d = document.metaData(m);
            text ~= "<tr><td><nobr>" ~ QString(std.conv.text(m)).toHtmlEscaped() ~ ":</nobr></td><td><nobr>" ~ d.toString().toHtmlEscaped() ~ "</nobr></td></tr>\n";
        }
        text ~= "</table>";
        QMessageBox.information(this, QString.create(), text);
    }

    /*@QSlot*/ final void onPdfStatusChanged(QPdfDocument.Status status)
    {
        import qt.core.variant;

        labelStatus.setText("Status: " ~ QString(text(status)));
    }

    @QSlot final void on_actionOpen_triggered()
    {
        import qt.widgets.filedialog;

        QString filename = QFileDialog.getOpenFileName(this, "Open PDF file", QString.create(), "*.pdf");
        if (!filename.isEmpty())
            document.load(filename);
    }

    @QSlot final void on_actionAbout_Qt_triggered()
    {
        import qt.widgets.messagebox;

        QMessageBox.aboutQt(this);
    }

    @QSlot final void on_comboBoxZoom_currentTextChanged(ref const(QString) text)
    {
        import qt.core.global;
        import qt.core.qchar;
        import qt.pdf.view;

        if (text == ui.comboBoxZoom.itemText(0))
        {
            ui.pdfView.setZoomMode(QPdfView.ZoomMode.FitInView);
        }
        else if (text == ui.comboBoxZoom.itemText(1))
        {
            ui.pdfView.setZoomMode(QPdfView.ZoomMode.FitToWidth);
        }
        else if (text != QString.number(qRound(ui.pdfView.zoomFactor() * 100)) ~ "%")
        {
            QString text2 = text;
            text2.remove(QChar('%'));
            text2 = text2.trimmed();

            bool ok = false;
            const(int) zoomLevel = text2.toInt(&ok);
            if (ok)
            {
                setZoomFactor(zoomLevel / 100.0, false);
            }
        }
    }

    @QSlot final void on_pushButtonZoomMinus_clicked()
    {
        import qt.core.math;

        setZoomFactor(ui.pdfView.zoomFactor() / qSqrt(2.0));
    }

    @QSlot final void on_pushButtonZoomPlus_clicked()
    {
        import qt.core.math;

        setZoomFactor(ui.pdfView.zoomFactor() * qSqrt(2.0));
    }

    @QSlot final void on_spinBoxPage_valueChanged(int value)
    {
        import qt.core.point;

        auto nav = ui.pdfView.pageNavigator();
        nav.jump(value - 1, QPointF());
    }

private:
    UIStruct!"mainwindow.ui"* ui;
    QPdfDocument document;
    QLabel labelStatus;
}

