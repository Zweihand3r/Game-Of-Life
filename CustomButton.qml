import QtQuick 2.6
import QtQuick.Controls 2.0

Button {
    id: control
    width: 200
    height: 70
    text: "button"

    property int buttonFont: 45
    property int cornerRadius: 16

    background: Rectangle {
        color: control.pressed ? "black" : "white"
        radius: cornerRadius

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    contentItem: Label {
        color: control.pressed ? "white" : "black"
        text: control.text
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: buttonFont
        scale: control.pressed ? 0.95 : 1

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }
    }
}
