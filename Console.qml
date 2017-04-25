import QtQuick 2.0

Rectangle {
    id: root
    width: 640
    height: 980
    color: "transparent"

    signal textEntered(var text)

    property alias backgroundColor: root.color
    property bool consoleVisibility: true
    property bool pauseLogs: false

    property var history: []
    property int historyIndex: 0

    function write(entry) {
        if (!pauseLogs) {
            consoleModel.append({ "entry": entry.toString(), "reply": true })
            consoleList.incrementCurrentIndex()
        }
    }

    function clear() {
        consoleModel.clear()
        consoleModel.append({"entry": "(-o-)", "reply": true})
        consoleList.currentIndex = 1
    }

    ListModel {
        id: consoleModel

        ListElement {
            entry: "(-o-)"
            reply: true
        }
    }

    ListView {
        id: consoleList
        width: 640
        height: 960
        model: consoleModel
        visible: consoleVisibility

        delegate: Rectangle {
            width: root.width
            height: 14
            color: "transparent"
            clip: true

            Text {
                width: root.width
                height: 14
                color: reply ? "red" : "green"
                font.pixelSize: 12
                text: entry
                verticalAlignment: Text.AlignVCenter
            }
        }

        add: Transition {
            NumberAnimation {
                property: "width"
                from: 0
                to: root.width
                duration: 160
            }
        }
    }

    Text {
        y: 960
        width: 26
        height: 20
        text: "~/>"
        color: "green"
        font.pixelSize: 14
    }

    TextInput {
        x: 26
        y: 960
        width: 614
        height: 20
        color: "green"
        font.pixelSize: 14

        Keys.onReturnPressed: {
            consoleModel.append({ "entry": text, "reply": false })
            consoleList.incrementCurrentIndex()

            history.splice(history.length, 0, text)
            root.textEntered(text)

            text = ""
            historyIndex = history.length - 1
        }

        Keys.onUpPressed: {
            text = history[historyIndex]
            historyIndex > 0 ? historyIndex-- : historyIndex
        }

        Keys.onDownPressed: {
            text = history[historyIndex]
            historyIndex < history.length - 1 ? historyIndex++ : historyIndex
        }

        Keys.onEscapePressed: {
            consoleList.visible = !consoleList.visible
        }
    }

    Component.onCompleted: consoleList.positionViewAtEnd()

    Behavior on color {
        ColorAnimation { duration: 160 }
    }
}


