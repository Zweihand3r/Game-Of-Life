import QtQuick 2.7
import QtQuick.Controls 2.0

ComboBox {
    id: control
    width: 240
    height: 70
    model: ["First", "Second", "Third"]

    delegate: ItemDelegate {
        width: control.width

        contentItem: Text {
            text: modelData
            font.pixelSize: 34
            color: "black"
            elide: Text.ElideRight
            leftPadding: 14
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
        }
    }

    indicator: Rectangle {
        x: control.width - 48
        y: 30
        height: 15
        width: 25
        color: "transparent"
        scale: control.pressed ? 0.75 : 1

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }

        state: popup.visible ? 'dropdown' : ''

        Rectangle {
            id: pixel1
            width: 5
            height: 5
        }

        Rectangle {
            x: 5
            y: 5
            width: 5
            height: 5
        }

        Rectangle {
            id: pixel3
            x: 10
            y: 10
            width: 5
            height: 5
        }

        Rectangle {
            x: 15
            y: 5
            width: 5
            height: 5
        }

        Rectangle {
            id: pixel5
            x: 20
            y: 0
            width: 5
            height: 5
        }

        states: [
            State {
                name: "dropdown"
                PropertyChanges {
                    target: pixel1
                    y: 10
                }

                PropertyChanges {
                    target: pixel3
                    y: 0
                }

                PropertyChanges {
                    target: pixel5
                    y: 10
                }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation {
                    properties: "y"
                    duration: 120
                    easing: Easing.InQuad
                }
            }
        ]
    }

    contentItem: Text {
        color: "white"
        text: control.displayText
        font.pixelSize: 45
        leftPadding: 10
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        scale: control.pressed ? 0.9 : 1

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }
    }

    background: Rectangle {
        color: "transparent"
        radius: 16
        border.width: 3
        border.color: control.pressed ? "black" : "white"
        scale: control.pressed ? 0.9 : 1

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }

        Behavior on border.color {
            ColorAnimation { duration: 120 }
        }
    }

    popup: Popup {
        y: control.height
        width: control.width
        implicitHeight: listview.contentHeight // > 222 ? 222 : listview.contentHeight
        padding: 1

        contentItem: ListView {
            id: listview
            clip: true
            model: control.popup.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex

            ScrollIndicator.vertical: ScrollIndicator { }
        }

        background: Rectangle {
            color: "white"
            opacity: 0.98
            radius: 10
        }
    }
}
