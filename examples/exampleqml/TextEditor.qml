import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: root
    title: qsTr("Text Editor")

    ScrollView {
        id: view
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: bottomRow.top

        TextArea {
            id: textArea
            text: "Hello World!"
            focus: true
            onEditingFinished: logic.processTextDocument(textDocument)
            background: Rectangle {
                color: "#ffffff"
            }
        }
    }

    Row {
        id: bottomRow
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        Button {
            text: "Process"
            onClicked: logic.processTextDocument(textArea.textDocument)
        }
        Text {
            text: logic.textStatistics
        }
    }
}
