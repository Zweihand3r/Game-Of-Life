import QtQuick 2.0
import QtQuick.Controls 2.1

import "./Colors.js" as Color

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
                innerWorld.border.color = Color.redTint
                innerCircle.color = Color.redTint

                presetRadial.color = Color.black
                advancedRadial.color = Color.black
                dynamicRadial.color = Color.black
                defaultRadial.color = Color.black
            }

            onExited: {
                innerWorld.border.color = Color.white
                innerCircle.color = Color.transparent

                presetRadial.color = Color.transparent
                advancedRadial.color = Color.transparent
                dynamicRadial.color = Color.transparent
                defaultRadial.color = Color.transparent
            }

            onClicked: dismissPalette()
        }

        Rectangle {
            id: mask
            width: 220
            height: 220
            radius: 110
            opacity: 0
        }

        Item {
            anchors.fill: mask
            layer.enabled: true
//            layer.effect: OpacityMask {
//                maskSource: mask
//            }

            RadialButton {
                id: presetRadial
                contentInsetX: 6
                contentInsetY: 6
                title: "Presets"
                onPressed: radialSelection(-1)
            }

            RadialButton {
                id: defaultRadial
                y: 115
                contentInsetX: 10
                contentInsetY: -10
                title: "Default"
                selected: true
                onPressed: radialSelection(0)
            }

            RadialButton {
                id: dynamicRadial
                x: 115
                y: 115
                contentInsetX: -8
                contentInsetY: -8
                title: "Dynamic"
                onPressed: radialSelection(1)
            }

            RadialButton {
                id: advancedRadial
                x: 115
                contentInsetX: -10
                contentInsetY: 10
                title: "More +"
                onPressed: radialSelection(2)
            }
        }
    }
}

