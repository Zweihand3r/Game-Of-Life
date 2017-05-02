import QtQuick 2.6
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    width: 480
    height: 480
    color: "transparent"
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    scale: 0

    property int paletteIndex: -1

    Behavior on scale {
        ScaleAnimator { duration: 160 }
    }

    Timer {
        id: dismissCompletionTimer
        running: false
        repeat: false
        interval: 120
        onTriggered: scale = 0
    }

    Timer {
        id: presentCompletionTimer
        running: false
        repeat: false
        interval: 180
        onTriggered: presentCompletion()
    }

    function presentCompletion() {
        if (paletteIndex > -1) {
            expandingOne.rotation = 0
            expandingOne.opacity = 1
            expandingOne.scale = 1
            expandingOneBackgroundCompanion.scale = 1
        }
    }

    function presentPalette() {
        if (scale !== 1) {
            scale = 1
            presentCompletionTimer.start()
        }
    }

    function dismissPalette() {
        if (scale === 0) {
            return
        }

        if (paletteIndex > -1) {
            expandingOne.rotation = 60
            expandingOne.opacity = 0
            expandingOne.scale = 0.5
            expandingOneBackgroundCompanion.scale = 0.5

            dismissCompletionTimer.start()
        }
        else {
            scale = 0
        }
    }

    function radialSelection(index) {
        console.log("Called")
        defaultRadial.selected = index === 0 // 0
        randomRadial.selected = index === 3 // 3

        switch (index) {
        case -1:
            paletteIndex = -1

            expandingOne.rotation = 60
            expandingOne.opacity = 0
            expandingOne.scale = 0.5
            expandingOneBackgroundCompanion.scale = 0.5
            break

        case 0:
        case 1:
        case 2:
            paletteIndex = index

            expandingOne.rotation = 0
            expandingOne.opacity = 1
            expandingOne.scale = 1
            expandingOneBackgroundCompanion.scale = 1
        }
    }

    Rectangle {
        id: expandingOneBackgroundCompanion
        anchors.fill: parent
        color: "black"
        opacity: 0.85
        scale: 0.5
        radius: expandingOne.width / 2

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }
    }

    Rectangle { // Move below EO
        id: innerWorld
        width: 240
        height: 240
        radius: 120
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"
        clip: true
        border.color: "White"
        border.width: 3

        Behavior on border.color {
            ColorAnimation { duration: 120 }
        }

        Rectangle {
            id: innerCircle
            width: 220
            height: 220
            radius: 110
            color: "transparent"
            rotation: 45
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation { duration: 120 }
            }

            MouseArea {
                id: dismissMouse
                width: 220
                height: 220
                hoverEnabled: true

                onEntered: {
                    var redTint = "#DD4332"
                    innerWorld.border.color = redTint
                    innerCircle.color = redTint

                    defaultRadial.color = "black"
                    randomRadial.color = "black"
                }

                onExited: {
                    innerWorld.border.color = "white"
                    innerCircle.color = "transparent"

                    transparetor.start()
                }

                onClicked: dismissPalette()

                Timer {
                    id: transparetor
                    running: false
                    interval: 120
                    onTriggered: {
                        defaultRadial.color = "transparent"
                        randomRadial.color = "transparent"
                    }
                }
            }

            Rectangle {
                id: mask
                width: 220
                height: 220
                radius: 110
                color: "black"
                opacity: 0
            }

            Item {
                anchors.fill: mask
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: mask
                }

                RadialButton {
                    id: defaultRadial
                    contentInsetX: 6
                    contentInsetY: 6
                    title: "Default"
                    selected: true
                    onPressed: radialSelection(-1)
                }

                RadialButton {
                    y: 115
                    title: "-"
                    color: "black" // remove
                }

                RadialButton {
                    x: 115
                    y: 115
                    title: "-"
                    color: "black" // remove
                }

                RadialButton {
                    id: randomRadial
                    x: 115
                    contentInsetX: -10
                    contentInsetY: 10
                    title: "Random"
                    onPressed: radialSelection(2)
                }
            }
        }
    }

    Rectangle {
        id: expandingOne
        width: 480
        height: 480
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"
        opacity: 0
        scale: 0.5
        rotation: 60

        Behavior on rotation {
            RotationAnimation { duration: 120 }
        }

        Behavior on opacity {
            OpacityAnimator { duration:  120 }
        }

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }

        Rectangle {
            id: randomExpander
            anchors.fill: parent
            radius: expandingOne.width / 2
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            color: "transparent"

            ColorButton {
                id: toggleButton
                x: 208
                y: 25
                dimension: 64
            }

            ColorButton {
                x: 375
                y: 125
                tint: "red"
                dimension: 64
            }

            ColorButton {
                x: 375
                y: 262
                tint: "green"
                dimension: 64
            }

            ColorButton {
                x: 291
                y: 369
                tint: "blue"
                dimension: 64
            }

            ColorButton {
                x: 125
                y: 369
                tint: "purple"
                dimension: 64
            }

            ColorButton {
                x: 39
                y: 262
                tint: "yellow"
                dimension: 64
            }

            ColorButton {
                x: 39
                y: 125
                tint: "cyan"
                dimension: 64
            }
        }
    }
}
