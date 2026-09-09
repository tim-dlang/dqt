import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id: win
    width: 640
    height: 480
    visible: true
    title: "expandable_list_test"
    color: "#1a1b26"

    // Static folder tree - enough to exercise drill-down ("expandable")
    // behavior: click a row -> show its children, Backspace -> go back.
    property var tree: ({
        "root": [
            { name: "home", size: 45.2, kids: [
                { name: "user", size: 30.1, kids: [
                    { name: "Documents", size: 3.4, kids: [
                        { name: "report.pdf", size: 0.8, kids: [] },
                        { name: "notes.txt", size: 0.02, kids: [] },
                    ] },
                    { name: ".cache", size: 12.3, kids: [
                        { name: "browser", size: 8.1, kids: [] },
                        { name: "builds", size: 4.2, kids: [] },
                    ] },
                ] },
                { name: "lost+found", size: 0.0, kids: [] },
            ] },
            { name: "usr", size: 31.7, kids: [
                { name: "lib", size: 18.9, kids: [
                    { name: "libQt6Core.so", size: 0.9, kids: [] },
                ] },
                { name: "share", size: 8.8, kids: [] },
            ] },
            { name: "var", size: 6.4, kids: [
                { name: "log", size: 0.4, kids: [
                    { name: "pacman.log", size: 0.3, kids: [] },
                ] },
                { name: "cache", size: 4.1, kids: [] },
            ] },
            { name: "<UNUSED>", size: 4.9, kids: [] },
            { name: "<METADATA>", size: 1.6, kids: [] },
        ]
    })

    // Navigation stack of source arrays; `rows` is the display model.
    property var stack: [tree.root]
    property var rows: []

    function showTop() {
        var top = stack[stack.length - 1];
        var out = [];
        for (var i = 0; i < top.length; i++)
            out.push({ name: top[i].name, size: top[i].size,
                       kids: top[i].kids, i: i });
        win.rows = out;
    }
    function enter(i) {
        console.log("QML enter", i);
        var kids = stack[stack.length - 1][i].kids;
        if (!kids || kids.length === 0)
            return;
        stack.push(kids);
        showTop();
    }
    function goUp() {
        if (stack.length > 1) {
            stack.pop();
            showTop();
        }
    }

    // DEBUG tracing for the injection experiments
    TapHandler {
        onTapped: console.log("QML window tapped at",
            eventPoint.position.x, eventPoint.position.y)
    }

    header: Rectangle {
        height: 44
        color: "#13141c"
        Text {
            anchors.centerIn: parent
            color: "#a9b1d6"
            text: stack.map(function(f) { return f === tree.root ? "/" : "…"; }).join(" / ")
        }
        Text {
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            color: stack.length > 1 ? "#c0caf5" : "#565f89"
            text: "← back"
            TapHandler {
                onTapped: win.goUp()
            }
        }
    }

    ListView {
        id: list
        anchors.fill: parent
        anchors.topMargin: 44
        clip: true
        model: win.rows
        boundsBehavior: Flickable.StopAtBounds

        delegate: Rectangle {
            id: row
            required property var modelData
            width: list.width
            height: 60
            color: rowTap.pressed ? "#3b4261"
                   : rowHover.hovered ? "#292e42" : "transparent"

            HoverHandler { id: rowHover }
            TapHandler {
                id: rowTap
                onTapped: {
                    console.log("QML row tapped:", modelData.name, "i=", modelData.i);
                    var idx = modelData.i;
                    Qt.callLater(function() {
                        console.log("QML callLater enter", idx);
                        win.enter(idx);
                    });
                }
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                color: "#a9b1d6"
                text: (typeof modelData.name === "string" ? modelData.name : "")
                      + (modelData.kids && modelData.kids.length ? "  ▸" : "")
            }
            Text {
                anchors.right: parent.right
                anchors.rightMargin: 12
                anchors.verticalCenter: parent.verticalCenter
                color: "#c0caf5"
                text: modelData.size.toFixed(1) + " GiB"
            }
        }
    }

    Component.onCompleted: {
        console.log("QML loaded, rows:", tree.root.length);
        showTop();
    }

    // Live row geometry export, read by the test drivers.
    property string rowMapJson: "[]"
    Timer {
        interval: 150
        running: true
        repeat: true
        onTriggered: {
            if (!list || list.count === 0) {
                win.rowMapJson = "[]";
                return;
            }
            var m = [];
            for (var i = 0; i < list.count; i++) {
                var it = list.itemAtIndex(i);
                if (!it)
                    continue;
                var c = it.mapToItem(null, 0, it.height / 2); // scene == window coords
                m.push({ i: i, x: c.x, y: c.y,
                         name: it.modelData ? it.modelData.name : "",
                         dir: it.modelData && it.modelData.kids
                              ? it.modelData.kids.length > 0 : false });
            }
            win.rowMapJson = JSON.stringify(m);
        }
    }

    Shortcut {
        sequence: "Backspace"
        onActivated: win.goUp()
    }
}
