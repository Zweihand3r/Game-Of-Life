import QtQuick 2.6

Rectangle {
    property bool occupied: false
    property alias index: label.text
    property bool animate: true

    id: root
    width: 32
    height: 32
    color: "transparent"

    Rectangle {
        anchors.fill: root
        scale: occupied ? 1 : 0

        Behavior on scale {
            enabled: animate
            ScaleAnimator { duration: 80 }
        }
    }

    Text {
        id: label
        text: "1"
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        color: occupied ? "black" : "white"
        anchors.fill: root
        font.pixelSize: 10
    }

    MouseArea {
        anchors.fill: root
        onClicked: occupied = !occupied
    }

}
