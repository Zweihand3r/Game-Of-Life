import QtQuick 2.6
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Button {
    id: control
    width: dimension
    height: dimension
    text: ""
    scale: control.pressed ? 0.85 : 1

    signal switchedOn()
    signal switchedOff()

    property string tint: "black"
    property string gradient0: "#114357"
    property string gradient1: "#F29492"

    property int dimension: 64
    property bool switchState: false
    property bool connected: false
    property bool enableGradient: false

    function switchMode() {
        scale = 0
        switchTimer.start()
    }

    function switchEnding() {
        gradient.visible = enableGradient
        scale = 1
    }

    Timer {
        id: switchTimer
        running: false
        interval: 120
        onTriggered: switchEnding()
    }

    background: Rectangle {
        color: "transparent"
        radius: dimension / 2
        border.width: 5
        border.color: tint

        Rectangle {
            x: 10
            y: 10
            width: control.width - 20
            height: control.height - 20
            radius: dimension / 2
            color: tint
            scale: switchState ? 1 : 0

            Behavior on scale {
                ScaleAnimator { duration: 120 }
            }
        }
    }

    LinearGradient {
        id: gradient
        width: dimension
        height: dimension
        start: Qt.point(0, 0)
        end: Qt.point(dimension, 0)
        source: control

        gradient: Gradient {
            GradientStop { position: 0.0; color: gradient0 }
            GradientStop { position: 1.0; color: gradient1 }
        }

        Behavior on opacity {
            OpacityAnimator { duration: 120 }
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
