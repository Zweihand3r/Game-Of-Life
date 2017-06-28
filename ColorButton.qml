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
    property string gradient0: ""
    property string gradient1: ""

    property int dimension: 64
    property bool switchState: false
    property bool connected: false
    property bool enableGradient: false
    property bool addMode: false
    property int modeIndex: 0

    function switchMode() {
        scale = 0
        switchTimer.start()
    }

    function switchEnding() {
        gradient.visible = enableGradient
        scale = 1
    }

    function setTitle() {
        switch (modeIndex) {
        case -1: return "-"
        case 0: return ""
        case 1: return "+"
        }
    }

    Timer {
        id: switchTimer
        running: false
        interval: 120
        onTriggered: switchEnding()
    }

    contentItem: Text {
        text: setTitle()
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: tint
        font.pixelSize: 45
        bottomPadding: 6
        scale: modeIndex != 0 ? 1 : 0

        Behavior on scale {
            ScaleAnimator { duration: 80 }
        }
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
            scale: switchState && (modeIndex == 0) ? 1 : 0

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
        visible: enableGradient

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
