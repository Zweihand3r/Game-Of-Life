import QtQuick 2.6
import QtQuick.Controls 2.0

Rectangle {
    id: root
    width: 480
    height: 480
    color: "transparent"

    Rectangle {
        id: expandingOneBackgroundCompanion
        anchors.fill: parent
        color: "black"
        opacity: 0.85
        radius: expandingOne.width / 2

        Behavior on Scale {
            ScaleAnimator { duration: 120 }
        }
    }

    Rectangle { // Move below EO
        width: 240
        height: 240
        radius: 120
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }

    Rectangle {
        id: expandingOne
        width: 480
        height: 480
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"
        scale: expandingOneBackgroundCompanion.scale

//        Behavior on Scale {
//            ScaleAnimator { duration: 120 }
//        }

        Rectangle {
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
                x: 365
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
                y: 366
                tint: "blue"
                dimension: 64
            }

            ColorButton {
                x: 123
                y: 366
                tint: "purple"
                dimension: 64
            }

            ColorButton {
                x: 37
                y: 262
                tint: "yellow"
                dimension: 64
            }

            ColorButton {
                x: 45
                y: 125
                tint: "cyan"
                dimension: 64
            }
        }
    }
}
