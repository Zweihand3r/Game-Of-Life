import QtQuick 2.6
import QtQuick.Controls 2.0

import "./Colors.js" as Color

Rectangle {
    id: root
    height: 172
    width: 172
    color: Color.transparent
    state: 'title'
    clip: true

    signal switchedOn()

    property bool selected: false

    property alias title: titleText.text
    property string birthIndexes: "0000"
    property string survivalIndexes: "0000"

    Rectangle {
        id: borders
        anchors.fill: parent
        color: Color.transparent
        border.color: Color.white
        border.width: 2
        radius: 32

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }
    }

    Rectangle {
        id: rootBackground
        x: 5
        y: 5
        height: 162
        width: 162
        color: selected ? Color.white : Color.transparent
        radius: 28

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    Text {
        id: titleText
        x: 8
        y: 8
        width: 156
        height: 93
        text: qsTr("Text")
        color: selected ? Color.black : Color.white
        wrapMode: Text.WordWrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 28

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    Rectangle {
        id: rectangle
        x: 12
        y: 107
        width: 148
        height: 2
        radius: 1
        color: selected ? Color.black : Color.white
    }

    Text {
        id: birthText
        x: 8
        y: 108
        width: 156
        height: 35
        text: "B " + birthIndexes
        color: selected ? Color.black : Color.white
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 18

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    Text {
        id: survivalText
        x: 8
        y: 133
        width: 156
        height: 35
        text: "S " + survivalIndexes
        color: selected ? Color.black : Color.white
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 18

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
//            borders.scale = 1.1
            root.state = ''
        }

        onExited: {
//            borders.scale = 1
            root.state = 'title'
        }

        onClicked: {
            selected = true
            switchedOn()
        }
    }

    states: [
        State {
            name: "title"

            PropertyChanges {
                target: rectangle
                x: 12
                y: 173
                opacity: 0
            }

            PropertyChanges {
                target: birthText
                x: 8
                y: 186
                opacity: 0
            }

            PropertyChanges {
                target: survivalText
                x: 8
                y: 211
                opacity: 0
            }

            PropertyChanges {
                target: titleText
                x: 8
                y: 40
                font.pixelSize: 34
            }
        }
    ]

    transitions: [
        Transition {
            NumberAnimation {
                properties: "x, y, opacity, font.pixelSize"
                duration: 120
            }
        }
    ]
}
