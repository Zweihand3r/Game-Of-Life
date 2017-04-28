import QtQuick 2.6
import QtQuick.Controls 2.0

Rectangle {
    id: root
    width: 105
    height: 105
    color: "transparent"
    border.color: "white"
    border.width: selected ? 2 : 0

    property bool selected: false
    property int contentInsetX: 0
    property int contentInsetY: 0
    property string title: "Button"

    signal pressed()

    Behavior on color {
        ColorAnimation { duration: 120 }
    }

    Behavior on border.width {
        NumberAnimation { duration: 120 }
    }

    Text {
        id: text
        x: contentInsetX
        y: contentInsetY
        width: 105
        height: 105
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        rotation: -45
        text: title
        font.pixelSize: 21
        color: "white"

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            root.color = "white"

            text.color = "black"
            text.scale = 1.25
        }

        onExited: {
            root.color = "transparent"

            text.color = "white"
            text.scale = 1
        }

        onPressed: {
            root.pressed()
            selected = !selected
        }
    }
}
