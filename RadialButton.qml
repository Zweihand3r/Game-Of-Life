import QtQuick 2.6
import QtQuick.Controls 2.0

Rectangle {
    id: root
    width: 105
    height: 105
    color: "transparent"

    property bool selected: false
    property int contentInsetX: 0
    property int contentInsetY: 0
    property string title: "Button"

    signal pressed()

    Behavior on color { ColorAnimation { duration: 120 } }

    Rectangle {
        id: rootground
        width: 105
        height: 105
        color: "transparent"

        Behavior on color {
            ColorAnimation { duration: 120 }
        }

        Behavior on opacity {
            OpacityAnimator { duration: 120 }
        }
    }

    Text {
        id: labelText
        x: contentInsetX
        y: contentInsetY
        width: 105
        height: 105
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        rotation: -45
        text: title
        wrapMode: Text.WordWrap
        font.pixelSize: 21
        color: "white"

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }

        Behavior on color {
            ColorAnimation { duration: 120 }
        }
    }

    function selectionBypass() {
        if (selected) {
            rootground.color = "white"
            rootground.opacity = 1

            labelText.color = "black"
            labelText.scale = 1.1
        }
        else {
            rootground.color = "transparent"

            labelText.color = "white"
            labelText.scale = 1
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            if (!selected) {
                rootground.color = "white"
                rootground.opacity = 0.75

                labelText.color = "black"
                labelText.scale = 1.1
            }
        }

        onExited: {
            if (!selected) {
                rootground.color = "transparent"
                rootground.opacity = 1

                labelText.color = "white"
                labelText.scale = 1
            }
        }

        onPressed: {
            root.pressed()
            selected = true
        }
    }

    onSelectedChanged: selectionBypass()
}
