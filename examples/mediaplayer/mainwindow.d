module mediaplayer.mainwindow;

import qt.config;
import qt.core.list;
import qt.core.object;
import qt.core.string;
import qt.core.url;
import qt.helpers;
import qt.multimedia.audiodevice;
import qt.multimedia.audiooutput;
import qt.multimedia.cameradevice;
import qt.widgets.mainwindow;
import qt.widgets.ui;
import qt.widgets.widget;

class MainWindow : QMainWindow
{
    mixin(Q_OBJECT_D);

public:
    this(string filename, QWidget parent = null)
    {
        import core.stdcpp.new_;
        import qt.core.variant;
        import qt.gui.action;
        import qt.multimedia.mediadevices;
        import qt.widgets.pushbutton;
        super(parent);
        this.ui = cpp_new!(typeof(*ui));

        ui.setupUi(this);

        cameras = QMediaDevices.videoInputs();
        foreach (i, ref cameraDevice; cameras.toConstSlice())
        {
            QAction action = cpp_new!QAction(cameraDevice.description(), this);
            action.setData(QVariant.fromValue(i));
            connect(action.signal!"triggered", this.slot!"onOpenCameraTriggered");
            ui.menuCameras.addAction(action);
        }

        audioOutput = cpp_new!QAudioOutput(this);
        updateVolume();
        updateMuted();
        connect(ui.pushButtonMute.signal!"clicked", this.slot!"updateMuted");
        connect(ui.doubleSpinBoxVolume.signal!"valueChanged", this.slot!"updateVolume");

        audioOutputs = QMediaDevices.audioOutputs();
        foreach (i, ref audioOutputDev; audioOutputs.toConstSlice())
        {
            ui.comboBoxAudio.addItem(audioOutputDev.description());
            if (audioOutput.device() == audioOutputDev)
                ui.comboBoxAudio.setCurrentIndex(cast(int) i);
        }
        connect(ui.comboBoxAudio.signal!"currentIndexChanged", this.slot!"updateAudioDevice");

        resetPlayer();
        if (filename.length)
            playFile(QUrl.fromLocalFile(filename));
    }
    ~this()
    {
        import core.stdcpp.new_;

        cpp_delete(ui);
    }

private:
    final void resetPlayer()
    {
        import core.stdcpp.new_;

        if (playerObj)
        {
            cpp_delete(playerObj);
            playerObj = null;
        }
        ui.horizontalSlider.setMaximum(1);
        ui.horizontalSlider.setValue(0);
        ui.horizontalSlider.setDisabled(true);
    }

    final void playFile(const(QUrl) url)
    {
        import core.stdcpp.new_;
        import qt.core.global;
        import qt.multimedia.mediaplayer;
        import qt.widgets.pushbutton;
        import qt.widgets.slider;

        resetPlayer();

        QMediaPlayer player = cpp_new!QMediaPlayer(this);
        playerObj = player;

        ui.horizontalSlider.setDisabled(false);
        connect(player.signal!"durationChanged", this, (qint64 duration) {
            ui.horizontalSlider.setMaximum(cast(int) (duration));
        });
        connect(player.signal!"positionChanged", this, (qint64 position) {
            ui.horizontalSlider.setSliderPosition(cast(int) (position));
        });

        connect(ui.pushButtonPlay.signal!"clicked", player.slot!"play");
        connect(ui.pushButtonPause.signal!"clicked", player.slot!"pause");
        connect(ui.horizontalSlider.signal!"sliderMoved", player.slot!"setPosition");

        player.setSource(url);
        player.setAudioOutput(audioOutput);
        player.setVideoOutput(ui.videoWidget);
        player.play();
    }

private /+ slots +/:
    @QSlot final void onOpenCameraTriggered()
    {
        import core.stdcpp.new_;
        import qt.gui.action;
        import qt.multimedia.camera;
        import qt.multimedia.mediacapturesession;
        import qt.widgets.pushbutton;

        resetPlayer();

        QAction action = qobject_cast!(QAction)(QObject.sender());
        if (!action)
            return;
        int i = action.data().toInt();
        if (i < 0 || i >= cameras.length())
            return;

        QCamera camera = cpp_new!QCamera(cameras[i]);
        playerObj = camera;
        QMediaCaptureSession captureSession = cpp_new!QMediaCaptureSession(camera);
        captureSession.setCamera(camera);
        captureSession.setVideoOutput(ui.videoWidget);

        connect(ui.pushButtonPlay.signal!"clicked", camera.slot!"start");
        connect(ui.pushButtonPause.signal!"clicked", camera.slot!"stop");

        camera.start();
    }

    @QSlot final void on_actionOpen_File_triggered()
    {
        import qt.widgets.filedialog;

        QUrl url = QFileDialog.getOpenFileUrl(this, "Open video file");
        playFile(url);
    }

    @QSlot final void on_actionAbout_Qt_triggered()
    {
        import qt.widgets.messagebox;

        QMessageBox.aboutQt(this);
    }

    @QSlot final void on_actionSystem_Info_triggered()
    {
        import qt.core.sysinfo;
        import qt.multimedia.mediaformat;
        import qt.widgets.messagebox;

        QString text;
        text ~= "Hostname: " ~ QSysInfo.machineHostName().toHtmlEscaped() ~ "<br>\n";
        text ~= "Pretty Product Name: " ~ QSysInfo.prettyProductName().toHtmlEscaped() ~ "<br>\n";
        text ~= "Product: " ~ QSysInfo.productType().toHtmlEscaped() ~ " " ~ QSysInfo.productVersion().toHtmlEscaped() ~ "<br>\n";
        text ~= "Kernel: " ~ QSysInfo.kernelType().toHtmlEscaped() ~ " " ~ QSysInfo.kernelVersion().toHtmlEscaped() ~ "<br>\n";
        text ~= "Build ABI: " ~ QSysInfo.buildAbi().toHtmlEscaped() ~ "<br>\n";
        text ~= "CPU Architecture: " ~ QSysInfo.buildCpuArchitecture().toHtmlEscaped() ~ "<br>\n";
        text ~= "Current CPU Architecture: " ~ QSysInfo.currentCpuArchitecture().toHtmlEscaped() ~ "<br>\n";

        text ~= "<table>\n";
        text ~= "<tr><th colspan=4>File Formats</th></tr>\n";
        QMediaFormat m;
        auto fileFormatsEncode = m.supportedFileFormats(QMediaFormat.ConversionMode.Encode);
        auto fileFormatsDecode = m.supportedFileFormats(QMediaFormat.ConversionMode.Decode);
        foreach (f; fileFormatsEncode)
            text ~= "<tr><td><nobr>" ~ QMediaFormat.fileFormatName(f).toHtmlEscaped()
                    ~ "</nobr></td><td><nobr>" ~ QMediaFormat.fileFormatDescription(f).toHtmlEscaped()
                    ~ "</nobr></td><td>" ~ (fileFormatsDecode.contains(f) ? "Encode</td><td>Decode" : "Encode</td><td>") ~ "</td></tr>\n";
        foreach (f; fileFormatsDecode)
            if (!fileFormatsEncode.contains(f))
                text ~= "<tr><td><nobr>" ~ QMediaFormat.fileFormatName(f).toHtmlEscaped()
                        ~ "</nobr></td><td><nobr>" ~ QMediaFormat.fileFormatDescription(f).toHtmlEscaped()
                        ~ "</nobr></td><td>" ~ "</td><td>Decode" ~ "</td></tr>\n";

        text ~= "<tr><th colspan=4>Audio Codecs</th></tr>\n";
        auto audioCodecsEncode = m.supportedAudioCodecs(QMediaFormat.ConversionMode.Encode);
        auto audioCodecsDecode = m.supportedAudioCodecs(QMediaFormat.ConversionMode.Decode);
        foreach (f; audioCodecsEncode)
            text ~= "<tr><td><nobr>" ~ QMediaFormat.audioCodecName(f).toHtmlEscaped()
                    ~ "</nobr></td><td><nobr>" ~ QMediaFormat.audioCodecDescription(f).toHtmlEscaped()
                    ~ "</nobr></td><td>" ~ (audioCodecsDecode.contains(f) ? "Encode</td><td>Decode" : "Encode</td><td>") ~ "</td></tr>\n";
        foreach (f; audioCodecsDecode)
            if (!audioCodecsEncode.contains(f))
                text ~= "<tr><td><nobr>" ~ QMediaFormat.audioCodecName(f).toHtmlEscaped()
                        ~ "</nobr></td><td><nobr>" ~ QMediaFormat.audioCodecDescription(f).toHtmlEscaped()
                        ~ "</nobr></td><td>" ~ "</td><td>Decode" ~ "</td></tr>\n";

        text ~= "<tr><th colspan=4>Video Codecs</th></tr>\n";
        auto videoCodecsEncode = m.supportedVideoCodecs(QMediaFormat.ConversionMode.Encode);
        auto videoCodecsDecode = m.supportedVideoCodecs(QMediaFormat.ConversionMode.Decode);
        foreach (f; videoCodecsEncode)
            text ~= "<tr><td><nobr>" ~ QMediaFormat.videoCodecName(f)
                    ~ "</nobr></td><td><nobr>" ~ QMediaFormat.videoCodecDescription(f)
                    ~ "</nobr></td><td>" ~ (videoCodecsDecode.contains(f) ? "Encode</td><td>Decode" : "Encode</td><td>") ~ "</td></tr>\n";
        foreach (f; videoCodecsDecode)
            if (!videoCodecsEncode.contains(f))
                text ~= "<tr><td><nobr>" ~ QMediaFormat.videoCodecName(f)
                        ~ "</nobr></td><td><nobr>" ~ QMediaFormat.videoCodecDescription(f)
                        ~ "</nobr></td><td>" ~ "</td><td>Decode" ~ "</td></tr>\n";
        text ~= "</table>";

        QMessageBox.information(this, "System Info", text);
    }

    @QSlot final void updateMuted()
    {
        audioOutput.setMuted(ui.pushButtonMute.isChecked());
    }

    @QSlot final void updateVolume()
    {
        audioOutput.setVolume(ui.doubleSpinBoxVolume.value() * 0.01);
    }

    @QSlot final void updateAudioDevice()
    {
        int index = ui.comboBoxAudio.currentIndex();
        if (index >= 0 && index < audioOutputs.length())
        {
            audioOutput.setDevice(audioOutputs[index]);
        }
    }

private:
    UIStruct!"mainwindow.ui"* ui;
    QList!(QCameraDevice) cameras;
    QList!(QAudioDevice) audioOutputs;
    QObject playerObj = null;
    QAudioOutput audioOutput = null;
}
