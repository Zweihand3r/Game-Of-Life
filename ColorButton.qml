import QtQuick 2.6
import QtQuick.Controls 2.0

Button {
    id: control
    width: dimension
    height: dimension
    text: ""
    scale: control.pressed ? 0.85 : 1

    signal switchedOn()
    signal switchedOff()

    property string tint: "black"
    property int dimension: 64
    property bool switchState: true
    property bool connected: false

    property bool round: width === height && !square

    background: Rectangle {
        color: "transparent"
        radius: dimension / 2
        border.width: 10
        border.color: tint

        Rectangle {
            x: 15
            y: 15
            width: control.width - 30
            height: control.height - 30
            radius: dimension / 2
            color: tint
            scale: switchState ? 1 : 0

            Behavior on scale {
                ScaleAnimator { duration: 120 }
            }
        }
    }

    onPressed: {
        if (connected) {
            switchState = true
        }
        else {
            switchState = !switchState
        }

        switchState ? control.switchedOn() : control.switchedOff()
    }

    Behavior on scale {
        ScaleAnimator { duration: 120 }
    }
}
