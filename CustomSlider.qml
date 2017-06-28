import QtQuick 2.6
import QtQuick.Controls 2.1

Slider {
    id: control
    value: 0.5

    property string minTrackColor: "#21be2b"

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: control.availableWidth
        height: implicitHeight
        radius: 2
        color: "#bdbebf"

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            color: minTrackColor
            radius: 2

            Behavior on width {
                NumberAnimation { duration: 120 }
            }
        }
    }

    handle: Rectangle {
        x: control.leftPadding + control.visualPosition * (control.availableWidth - width)
        y: control.topPadding + control.availableHeight / 2 - height / 2
        implicitWidth: 26
        implicitHeight: 26
        radius: 13
        color: control.pressed ? "#f0f0f0" : "#f6f6f6"
        border.color: "#bdbebf"

        Behavior on x {
            NumberAnimation { duration: 120 }
        }
    }
}
