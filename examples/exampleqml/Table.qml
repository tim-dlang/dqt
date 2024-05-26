import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: root
    title: qsTr("Table")

    HorizontalHeaderView {
        id: horizontalHeader
        anchors.left: tableView.left
        anchors.top: parent.top
        syncView: tableView
        clip: true
    }

    VerticalHeaderView {
        id: verticalHeader
        anchors.top: tableView.top
        anchors.left: parent.left
        syncView: tableView
        clip: true
    }

    TableView {
        id: tableView
        anchors.left: verticalHeader.right
        anchors.top: horizontalHeader.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        columnSpacing: 1
        rowSpacing: 1
        clip: true

        model: logic.tableModel

        delegate: Rectangle {
            implicitWidth: 100
            implicitHeight: 30
            border.width: 1
            TextField {
                anchors.fill: parent
                text: display
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter
                onTextChanged: {
                    edit = text
                }
            }
        }

        ScrollBar.vertical: ScrollBar {
            parent: tableView.parent
            anchors.top: tableView.top
            anchors.right: tableView.right
            anchors.bottom: tableView.bottom
        }

        ScrollBar.horizontal: ScrollBar {
            parent: tableView.parent
            anchors.left: tableView.left
            anchors.right: tableView.right
            anchors.bottom: tableView.bottom
        }
    }
}
