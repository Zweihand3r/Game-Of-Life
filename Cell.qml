import QtQuick 2.6

Rectangle {
    property bool occupied: false
    property bool animate: false

    id: root
    width: 16
    height: 16

    scale: occupied ? 1 : 0

    Behavior on scale {
        enabled: animate
        ScaleAnimator { duration: 80 }
    }

    Behavior on color {
        ColorAnimation { duration: 80 }
    }
}
