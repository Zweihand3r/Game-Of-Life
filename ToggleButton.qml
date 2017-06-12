import QtQuick 2.6
import QtQuick.Controls 2.0

Button {
    id: control
    width: dimension
    height: dimension
    text: "button"
    scale: control.pressed ? 0.85 : 1

    signal switchedOn()
    signal switchedOff()

    property string onText
    property string offText

    property string tint: "white"
    property int dimension: 32
    property int fontSize: 19
    property bool switchState: false
    property bool square: false
    property bool diamond: false
    property bool connected: false

    property bool round: width === height && !square

    background: Rectangle {
        color: "transparent"
        radius: square ? 0 : (round ? dimension / 2 : 8)
        border.width: 2
        border.color: tint
        rotation: diamond ? 45 : 0

        Rectangle {
            x: 4
            y: 4
            width: control.width - 8
            height: control.height - 8
            radius: square ? 0 : (round ? dimension / 2 : 6)
            color: tint
            scale: switchState ? 1 : 0

            Behavior on scale {
                ScaleAnimator { duration: 120 }
            }
        }
    }

    contentItem: Text {
        color: switchState ? "black" : tint
        text: switchState ? onText : offText
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: fontSize
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
