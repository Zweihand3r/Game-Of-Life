import QtQuick 2.0
import QtQuick.Controls 2.0

RadioButton{

    indicator: Rectangle {
        width: 24
        height: 24
        radius: 12
        border.color: "#cbc6cd"
        border.width: 4
        Rectangle {
            x: 4
            y: 4
            height: 16
            width: 16
            visible: control.checked
            color: "#2ea2ec"
            radius: 8
            anchors.margins: 4
        }
    }

    contentItem: Label {
        x: 4
        font.pixelSize: 25
        text: control.text
        color: "#344550"
    }
}
