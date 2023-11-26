module examplewidgets.tabthread;

import qt.config;
import qt.core.object;
import qt.core.string;
import qt.core.thread;
import qt.helpers;
import qt.widgets.ui;
import qt.widgets.widget;

class Thread : QThread
{
    mixin(Q_OBJECT_D);

public:
    /+ explicit +/this(QObject parent = null)
    {
        super(parent);
    }

/+ signals +/public:
    @QSignal final void progressChanged(int value) {mixin(Q_SIGNAL_IMPL_D);}

    @QSignal final void message(ref const(QString) msg) {mixin(Q_SIGNAL_IMPL_D);}

protected:
    override extern(C++) void run()
    {
        QString tmp = "Started";
        /+ emit +/ message(tmp);
        for (int i = 1; i <= 100; i++)
        {
            if (isInterruptionRequested())
            {
                QString tmp2 = "Canceled";
                /+ emit +/ message(tmp2);
                return;
            }
            QThread.msleep(500);
            if (i % 10 == 0)
            {
                QString tmp3 = QString.number(i) ~ "% done";
                /+ emit +/ message(tmp3);
            }
            /+ emit +/ progressChanged(i);
        }
        QString tmp4 = "Finished";
        /+ emit +/ message(tmp4);
    }
}

class TabThread : QWidget
{
    mixin(Q_OBJECT_D);

public:
    /+ explicit +/this(QWidget parent = null)
    {
        import core.stdcpp.new_;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);
    }
    ~this()
    {
        import core.stdcpp.new_;

        if (thread)
        {
            thread.requestInterruption();
            thread.wait();
        }
        cpp_delete(ui);
    }

private /+ slots +/:
    @QSlot final void on_pushButtonStart_clicked()
    {
        import core.stdcpp.new_;

        ui.progressBar.setValue(0);
        QString tmp = "";
        ui.plainTextEdit.setPlainText(tmp);
        thread = cpp_new!Thread(this);
        connect(thread.signal!"progressChanged", ui.progressBar.slot!"setValue");
        connect(thread.signal!"message", this.slot!"onThreadMessage");
        connect(thread.signal!"finished", this.slot!"onThreadFinished");
        connect(thread.signal!"finished", thread.slot!"deleteLater");
        thread.start();
        ui.pushButtonStart.setEnabled(false);
        ui.pushButtonCancel.setEnabled(true);
    }

    @QSlot final void on_pushButtonCancel_clicked()
    {
        thread.requestInterruption();
    }

    @QSlot final void onThreadMessage(ref const(QString) msg)
    {
        ui.plainTextEdit.appendPlainText(msg);
    }

    @QSlot final void onThreadFinished()
    {
        thread = null;
        ui.pushButtonStart.setEnabled(true);
        ui.pushButtonCancel.setEnabled(false);
    }

private:
    UIStruct!"tabthread.ui"* ui;
    Thread thread = null;
}

