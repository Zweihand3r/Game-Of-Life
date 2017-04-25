import QtQuick 2.6
import QtQuick.Controls 2.0

Dial {
    property int dimension: 64

    id: control
    width: dimension
    height: dimension

//    background: Rectangle {
//        width: dimension
//        height: dimension
//        color: "transparent"
//        radius: dimension / 2
//        border.width: 2
//        border.color: "white"
//    }

//    handle: Rectangle {
//        id: handleItem
//        color: "white"
//        x: control.background.x + control.background.width / 2 - width / 2
//        y: control.background.y + control.background.height / 2 - height / 2
//        width: 16
//        height: 16
//        radius: 8
//        scale: 1.45

//        transform: [
//            Translate {
//                y: -Math.min(control.background.width, control.background.height) * 0.4 + handleItem.height / 2
//            },

//            Rotation {
//                angle: control.angle
//                origin.x: handleItem.width / 2
//                origin.y: handleItem.height / 2
//            }

//        ]
//    }
}
