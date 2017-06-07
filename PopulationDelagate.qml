import QtQuick 2.6
import QtQuick.Controls 2.0

import "./Colors.js" as Color

Rectangle {
    id: root
    width: 476
    height: 56
    color: selected ? Color.white : Color.transparent

    signal cellSelected()

    property string title
    property bool selected: false

    Behavior on color {
        ColorAnimation { duration: 120 }
    }

    Text {
        id: titleText
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: title
        font.pixelSize: 33
        color: selected ? Color.black : Color.white

        Behavior on color {
            ColorAnimation { duration: 120 }
        }

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: !selected ? titleText.scale = 1.05 : null
        onExited: titleText.scale = 1
        onClicked: cellSelected()
    }
}
