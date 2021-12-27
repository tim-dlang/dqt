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
        super(parent);

        timer = new QTimer(this);
        connect(timer.signal!"timeout", this.slot!"update");
        timer.setInterval(100);
        timer.start();

        staticText = QStaticText(globalInitVar!QString);
        staticText.setText(QString("drawStaticText"));
    }

protected:
    override extern(C++) void paintEvent(QPaintEvent e)
    {
        auto p = QPainter(this);
        drawImage(&p, QString("QPainter(QWidget)"));

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
        QAction pdfAction = menu.addAction(QString("Create PDF"));
        QAction selected = menu.exec(event.globalPos());

        if(selected == pdfAction)
        {
            QString filter = QString("*.pdf");
            QString filename = QFileDialog.getSaveFileName(this, globalInitVar!QString, globalInitVar!QString, filter);
            if(!filename.isEmpty())
            {
                scope writer = new QPdfWriter(filename);
                writer.setPageSize(QPdfWriter.PageSize.A4);
                writer.setResolution(50);
                auto p = QPainter(writer);
                drawImage(&p, QString("QPainter(QPdfWriter)"));
            }
        }
    }

private:
    QTimer timer;
    QStaticText staticText;

    final void drawImage(QPainter* p, const(QString) title)
    {
        import qt.core.datetime;
        import qt.core.namespace;
        import qt.core.rect;
        import qt.gui.textoption;

        p.drawText(15, 20, title);
        QBrush brush = QBrush(/+ Qt:: +/qt.core.namespace.GlobalColor.blue);
        p.setBrush(brush);
        p.drawRect(15, 30, 100, 30);
        auto tmp = QRectF(15, 30, 100, 30); auto tmp__1 = QTextOption(/+ Qt:: +/qt.core.namespace.Alignment.AlignCenter); auto tmpx1 = QString("drawRect"); p.drawText(tmp, tmpx1, tmp__1);

        brush = QBrush(/+ Qt:: +/qt.core.namespace.GlobalColor.green);
        p.setBrush(brush);
        p.drawEllipse(140, 30, 100, 30);
        auto tmp__2 = QRectF(140, 30, 100, 30); auto tmp__3 = QTextOption(/+ Qt:: +/qt.core.namespace.Alignment.AlignCenter); auto tmpx2 = QString("drawEllipse"); p.drawText(tmp__2, tmpx2, tmp__3);

        p.drawStaticText(270, 30, staticText);

        auto tmpx3 = "currentDateTime: " ~ QDateTime.currentDateTime().toString(/+ Qt:: +/qt.core.namespace.DateFormat.ISODate); p.drawText(15, 90, tmpx3);
    }
    final QImage createImage()
    {
        import qt.core.namespace;

        auto image = QImage(400, 100, QImage.Format.Format_RGBA8888);
        QColor tmp = QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.white);
        image.fill(tmp);
        auto p = QPainter(image.paintDevice);
        drawImage(&p, QString("QPainter(QImage)"));
        return image;
    }
    final QPixmap createPixmap()
    {
        import qt.core.namespace;

        auto image = QPixmap(400, 100);
        QColor tmp = QColor(/+ Qt:: +/qt.core.namespace.GlobalColor.gray);
        image.fill(tmp);
        auto p = QPainter(image.paintDevice);
        drawImage(&p, QString("QPainter(QPixmap)"));
        return image;
    }
    final QPicture createPicture()
    {
        QPicture image = QPicture(-1);
        auto p = QPainter(image.paintDevice);
        drawImage(&p, QString("QPainter(QPicture)"));
        return image;
    }
}

