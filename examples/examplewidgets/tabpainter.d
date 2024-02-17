module examplewidgets.tabpainter;

import qt.config;
import qt.core.string;
import qt.core.timer;
import qt.gui.brush;
import qt.gui.color;
import qt.gui.event;
import qt.gui.image;
import qt.gui.painter;
import qt.gui.picture;
import qt.gui.pixmap;
import qt.gui.statictext;
import qt.helpers;
import qt.widgets.widget;

class TabPainter : QWidget
{
    mixin(Q_OBJECT_D);
public:
    /+ explicit +/this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        super(parent);

        timer = cpp_new!QTimer(this);
        connect(timer.signal!"timeout", this.slot!"update");
        timer.setInterval(100);
        timer.start();

        staticText = QStaticText(globalInitVar!QString);
        staticText.setText("drawStaticText");
    }

protected:
    override extern(C++) void paintEvent(QPaintEvent e)
    {
        auto p = QPainter(this);
        drawImage(&p, "QPainter(QWidget)");

        QImage image = createImage();
        QPixmap pixmap = createPixmap();
        QPicture picture = createPicture();

        p.drawImage(0, 100, image);
        p.drawPixmap(0, 200, pixmap);
        p.drawPicture(0, 300, picture);
    }
    override extern(C++) void contextMenuEvent(QContextMenuEvent event)
    {
        import qt.widgets.action;
        import qt.widgets.filedialog;
        import qt.widgets.menu;
        import qt.gui.pagesize;
        import qt.gui.pdfwriter;

        scope menu = new QMenu(this);
        QAction pdfAction = menu.addAction("Create PDF");
        QAction selected = menu.exec(event.globalPos());

        if (selected == pdfAction)
        {
            QString filename = QFileDialog.getSaveFileName(this, globalInitVar!QString, globalInitVar!QString, QString("*.pdf"));
            if (!filename.isEmpty())
            {
                scope writer = new QPdfWriter(filename);
                writer.setPageSize(QPdfWriter.PageSize.A4);
                writer.setResolution(50);
                auto p = QPainter(writer);
                drawImage(&p, "QPainter(QPdfWriter)");
            }
        }
    }

private:
    QTimer timer;
    QStaticText staticText;

    final void drawImage(QPainter* p, string title)
    {
        import qt.core.datetime;
        import qt.core.namespace;
        import qt.core.rect;
        import qt.gui.textoption;

        p.drawText(15, 20, title);
        p.setBrush(QBrush(/+ Qt:: +/qt.core.namespace.GlobalColor.blue));
        p.drawRect(15, 30, 100, 30);
        p.drawText(QRectF(15, 30, 100, 30), "drawRect", /+ Qt:: +/qt.core.namespace.Alignment.AlignCenter);

        p.setBrush(QBrush(/+ Qt:: +/qt.core.namespace.GlobalColor.green));
        p.drawEllipse(140, 30, 100, 30);
        p.drawText(QRectF(140, 30, 100, 30), "drawEllipse", /+ Qt:: +/qt.core.namespace.Alignment.AlignCenter);

        p.drawStaticText(270, 30, staticText);

        p.drawText(15, 90, "currentDateTime: " ~ QDateTime.currentDateTime().toString(/+ Qt:: +/qt.core.namespace.DateFormat.ISODate));
    }
    final QImage createImage()
    {
        import qt.core.namespace;

        auto image = QImage(400, 100, QImage.Format.Format_RGBA8888);
        image.fill(/+ Qt:: +/qt.core.namespace.GlobalColor.white);
        auto p = QPainter(image.paintDevice);
        drawImage(&p, "QPainter(QImage)");
        return image;
    }
    final QPixmap createPixmap()
    {
        import qt.core.namespace;

        auto image = QPixmap(400, 100);
        image.fill(/+ Qt:: +/qt.core.namespace.GlobalColor.gray);
        auto p = QPainter(image.paintDevice);
        drawImage(&p, "QPainter(QPixmap)");
        return image;
    }
    final QPicture createPicture()
    {
        QPicture image = QPicture(-1);
        auto p = QPainter(image.paintDevice);
        drawImage(&p, "QPainter(QPicture)");
        return image;
    }
}

