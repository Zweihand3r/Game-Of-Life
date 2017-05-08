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

//    Console {
//        id: console1
//        anchors.horizontalCenter: parent.horizontalCenter

//        consoleVisibility: debug
//        pauseLogs: false

//        onTextEntered: {
//            inputString = text

//            switch (text.split(" ")[0]) {
//            case "random":
//                if (text.split(" ")[1] === "int") {
//                    var num = parseInt(text.split(" ")[2])
//                    write("(int) = " + parseInt(Math.random() * num + 1))
//                }
//                else {
//                    num = text.split(" ")[1]
//                    write("= " + Math.random() * num)
//                }
//                break

//            case "populate":
//                var index = text.split(" ")[1]
//                grid[index].occupied = true
//                console1.write("Cell index " + index + " populated")
//                break

//            case "nuke":
//                for (index = 0; index < population.length; index++) {
//                    var cell = grid[index]

//                    cell.occupied = false
//                    population[index] = false
//                }
//                console1.write("Grid nuked !")
//                break

//            case "clear":
//                console1.clear()
//                break

//            case "pauseLogs":
//                switch (text.split(" ")[1]) {
//                case "true":
//                    write("Log feed is paused")
//                    pauseLogs = true
//                    break

//                case "false":
//                    pauseLogs = false
//                    write("Log feed is active")
//                    break

//                default:
//                    write("Invalid parameter. Use true/false")
//                    break
//                }
//                break

//            case "background":
//                var color = text.split(" ")[1]
//                switch (color) {
//                case "transparent":
//                case "white":
//                case "black":
//                    backgroundColor = color
//                    console1.write("Changed background color to " + color)
//                    break

//                default:
//                    console1.write("Invalid color. Use transparent, white or black")
//                }
//                break

//            case "advance":
//                for (index = 0; index < population.length; index++) {
//                    cell = grid[index]
//                    population[index] = cell.occupied
//                }
//                incrementCycle();
//                console1.write("Cycle incremented")
//                break

//            case "help":
//                var bypassPause = false
//                if (pauseLogs) {
//                    pauseLogs = false
//                    bypassPause = true
//                }

//                write("random *int <int>")
//                write("populate <int>")
//                write("nuke")
//                write("clear")
//                write("pauseLogs <bool>")
//                write("background <color> | color: transparent, white, black")

//                if (bypassPause) {
//                    pauseLogs = true
//                }
//                break

//            default:
//                write("Unrecognised command. Type help to display commands")
//                break
//            }
//        }
//    }
}


