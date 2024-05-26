import QtQuick 2.2
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Page {
    id: root
    title: qsTr("Properties")

    GridLayout {
        columns: 2

        Text {
            text: "bool1: "
        }
        Button {
            text: logic.bool1
            onClicked: logic.bool1 = !logic.bool1
        }

        Text {
            text: "notBool1: "
        }
        Text {
            text: logic.notBool1
        }

        Text {
            text: "bool2: "
        }
        Button {
            text: logic.bool2
            onClicked: logic.bool2 = !logic.bool2
        }

        Text {
            text: "string1: "
        }
        TextField {
            id: textField1
            text: logic.string1
            onTextChanged: logic.string1 = text
        }

        Text {
            text: "string1: "
        }
        Text {
            text: logic.string1
        }

        Text {
            text: "toUpper(string1): "
        }
        Text {
            text: logic.toUpper(textField1.text)
        }

        Text {}
        Button {
            text: "Reset"
            onClicked: logic.reset()
        }
    }
}
