import QtQuick 2.6
import QtQuick.Controls 2.0

Button {
    id: control
    width: 200
    height: 70
    text: "button"
    scale: control.pressed ? 0.95 : 1

    background: Rectangle {
        color: control.pressed ? "black" : "white"
        radius: 16

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    contentItem: Label {
        color: control.pressed ? "white" : "black"
        text: control.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 45
    }

    Behavior on scale {
        ScaleAnimator { duration: 120 }
    }
}
