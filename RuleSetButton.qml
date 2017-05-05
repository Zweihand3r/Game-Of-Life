import QtQuick 2.6
import QtQuick.Controls 2.0

import "./Colors.js" as Color

Rectangle {
    id: root
    height: 172
    width: 172
    color: Color.transparent

    property bool selected: false

    property string birthIndexes: "0"
    property string survivalIndexes: "0"

    Rectangle {
        id: borders
        anchors.fill: parent
        color: Color.transparent
        border.color: Color.white
        border.width: 2
        radius: 16

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
        radius: 10

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    Text {
        id: titleText
        x: 8
        y: 8
        width: 156
        height: 72
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
        x: 12
        y: 82
        width: 148
        height: 2
        radius: 1
        color: selected ? Color.black : Color.white
    }

    Text {
        id: birthText
        x: 8
        y: 90
        width: 156
        height: 35
        text: "Birth - " + birthIndexes
        color: selected ? Color.black : Color.white
        font.italic: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    Text {
        id: survivalText
        x: 8
        y: 125
        width: 156
        height: 35
        text: "Survival - " + survivalIndexes
        color: selected ? Color.black : Color.white
        font.italic: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 20

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            borders.scale = 1.1
        }

        onExited: {
            borders.scale = 1
        }

        onClicked: selected = !selected
    }
}
