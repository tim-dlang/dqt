import QtQuick 2.2
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: root
    width: 640
    height: 480
    visible: true
    title: appTitle

    header: ToolBar {
        RowLayout {
            anchors.fill: parent
            ToolButton {
                text: qsTr("‹")
                onClicked: stack.pop()
            }
            Label {
                text: appTitle + " - " + stack.currentItem.title
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                id: button
                text: qsTr("⋮")
                onClicked: menu.open()
            }
        }
    }

    footer: Text {
        text: "Footer"
    }

    Menu {
        id: menu
        x: root.width

        MenuItem {
            text: "Close"
            onTriggered: root.close()
        }
    }

    StackView {
        id: stack
        anchors.fill: parent
        initialItem: Home {}
    }
}
