import QtQuick 2.2
import QtQuick.Controls 2.15

Page {
    id: root
    title: qsTr("Home") + " " + homeDepth
    property int homeDepth: 1

    Column {
        anchors.centerIn: parent
        spacing: 10

        Button {
            text: "Push Home (Depth " + (homeDepth + 1) + ")"
            onClicked: root.StackView.view.push("Home.qml", {homeDepth: homeDepth + 1})
        }
        Button {
            text: "Properties"
            onClicked: root.StackView.view.push("Properties.qml")
        }
        Button {
            text: "Open Table"
            onClicked: root.StackView.view.push("Table.qml")
        }
        Button {
            text: "Open Text Editor"
            onClicked: root.StackView.view.push("TextEditor.qml")
        }
    }
}
