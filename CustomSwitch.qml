import QtQuick 2.6
import QtQuick.Controls 2.0

Switch {
    id: control
    text: "Switch"

    indicator: Rectangle {
        implicitWidth: 60
        implicitHeight: 30
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 15
        color: "transparent"
        border.color: "white"
        border.width: 2
        scale: control.pressed ? 0.9 : 1

        Rectangle {
            x: control.checked ? parent.width - width : 0
            width: 30
            height: 30
            radius: 15
            scale: 0.75

            Behavior on x {
                NumberAnimation { duration: 120; easing: Easing.OutCurve }
            }
        }

        Behavior on scale {
            ScaleAnimator { duration: 80 }
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
