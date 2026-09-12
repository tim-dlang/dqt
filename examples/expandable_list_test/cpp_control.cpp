// Pure C++ control experiment: the same QML and the same synthesized-input
// pipeline as the D version, but with NO D/dqt anywhere in the process.
// If this aborts under MALLOC_CHECK_=3 too, the bug is in Qt 6.11.2;
// if not, the bug is in the D bindings' glue.
//
// Build:  make cpp   (see Makefile)
// Run:    MALLOC_CHECK_=3 MALLOC_PERTURB_=165 ./cpp_control

#include <QtGui/QGuiApplication>
#include <QtGui/QWindow>
#include <QtQml/QQmlApplicationEngine>
#include <QtQuick/QQuickWindow>
#include <QtQuick/QQuickItem>
#include <QtCore/QTimer>
#include <QtCore/QJsonDocument>
#include <QtCore/QJsonArray>
#include <QtCore/QJsonObject>
#include <QtCore/QPoint>
#include <QtCore/QPointF>
#include <QtGui/QVector2D>
#include <cstdio>
#include <QtCore/QCommandLineParser>
#include <QtCore/QDir>
#include <unistd.h> // usleep

// From qtestmouse.h (QTest's own input-injection entry point):
bool qt_handleMouseEvent(QWindow *window, const QPointF &local,
                         const QPointF &global, Qt::MouseButtons state,
                         Qt::MouseButton button, QEvent::Type type,
                         Qt::KeyboardModifiers mods, int timestamp);

static void realClick(QWindow *win, const QPointF &local)
{
    QPointF global = win->mapToGlobal(local.toPoint());
    bool ok1 = qt_handleMouseEvent(win, local, global, Qt::LeftButton,
                        Qt::LeftButton, QEvent::MouseButtonPress,
                        Qt::NoModifier, 10);
    bool ok2 = qt_handleMouseEvent(win, local, global, Qt::NoButton,
                        Qt::LeftButton, QEvent::MouseButtonRelease,
                        Qt::NoModifier, 20);
    fprintf(stderr, "CPP   qt_handleMouseEvent press=%d release=%d\n",
            (int)ok1, (int)ok2);
}

struct RowPos
{
    int i;
    double x, y;
    QString name;
    bool dir;
};

static QVector<RowPos> rowMap(QQmlApplicationEngine &engine)
{
    QVector<RowPos> out;
    if (engine.rootObjects().isEmpty())
        return out;
    QObject *root = engine.rootObjects().first();
    const QVariant v = root->property("rowMapJson");
    const QJsonDocument doc = QJsonDocument::fromJson(v.toString().toUtf8());
    for (const QJsonValue &r : doc.array()) {
        RowPos p;
        p.i = r.toObject()["i"].toInt();
        p.x = r.toObject()["x"].toDouble();
        p.y = r.toObject()["y"].toDouble();
        p.name = r.toObject()["name"].toString();
        p.dir = r.toObject()["dir"].toBool();
        out.push_back(p);
    }
    return out;
}

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;
    engine.load(QUrl::fromLocalFile(
        QDir(QCoreApplication::applicationDirPath()).filePath("expandable_list.qml")));
    if (engine.rootObjects().isEmpty())
        return 1;

    QTimer timer;
    int step = 0, clickIdx = 0;
    // Click through the expandable rows: 0 (home), then 0 (user), ...
    const int seq[] = { 0, 0, 0, 0, 0, 0 };
    int seqLen = 6;
    QObject::connect(&timer, &QTimer::timeout, [&]() {
        step++;
        fprintf(stderr, "CPP step %d\n", step);

        const QVector<RowPos> map = rowMap(engine);
        if (map.isEmpty()) {
            fprintf(stderr, "CPP waiting for rows...\n");
            return;
        }
        if (clickIdx >= seqLen) {
            fprintf(stderr, "CPP-OK (survived %d clicks)\n", clickIdx);
            QCoreApplication::quit();
            return;
        }
        QWindow *win = nullptr;
        for (QWindow *w : QGuiApplication::allWindows())
            if (w->isVisible()) { win = w; break; }
        if (!win)
            return;
        const RowPos &r = map[seq[clickIdx] % map.size()];
        fprintf(stderr, "CPP click row %d (%s) at %.1f,%.1f\n",
                r.i, r.name.toUtf8().constData(), r.x + 60, r.y);
        realClick(win, QPointF(r.x + 60, r.y));
        clickIdx++;
    });
    timer.start(500);

    return app.exec();
}
