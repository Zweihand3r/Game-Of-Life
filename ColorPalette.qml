import QtQuick 2.6
import QtQuick.Controls 2.0
import QtGraphicalEffects 1.0

import "./Colors.js" as Color

Rectangle {
    id: root
    width: 480
    height: 480
    color: "transparent"
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    scale: 0

    signal colorsGenerated(var colorArray)

    property int paletteIndex: -1
    property int randomSelectionIndex: -1

    Behavior on scale {
        ScaleAnimator { duration: 160 }
    }

    Timer {
        id: dismissCompletionTimer
        running: false
        repeat: false
        interval: 120
        onTriggered: scale = 0
    }

    Timer {
        id: presentCompletionTimer
        running: false
        repeat: false
        interval: 180
        onTriggered: presentCompletion()
    }

    function presentCompletion() {
        if (paletteIndex == 2) {
            expandingOne.rotation = 0
            expandingOne.opacity = 1
            expandingOne.scale = 1
            expandingOneBackgroundCompanion.scale = 1
        }
    }

    function presentPalette() {
        if (scale !== 1) {
            scale = 1
            presentCompletionTimer.start()
        }
    }

    function dismissPalette() {
        if (scale === 0) {
            return
        }

        if (paletteIndex > -1) {
            expandingOne.rotation = 60
            expandingOne.opacity = 0
            expandingOne.scale = 0.5
            expandingOneBackgroundCompanion.scale = 0.5

            dismissCompletionTimer.start()
        }
        else {
            scale = 0
        }
    }

    function radialSelection(index) {
        console.log("Called")
        defaultRadial.selected = index === -1 // 0
        dynamicRadial.selected = index === 1
        randomRadial.selected = index === 2 // 3

        paletteIndex = index

        switch (index) {
        case -1:
            expandingOne.rotation = 60
            expandingOne.opacity = 0
            expandingOne.scale = 0.5
            expandingOneBackgroundCompanion.scale = 0.5

            generateDefaultColors() // Maybe moved somewhere else later
            break

        case 0:
        case 1:
            expandingOne.rotation = 60
            expandingOne.opacity = 0
            expandingOne.scale = 0.5
            expandingOneBackgroundCompanion.scale = 0.5

            generateAgeShades()
            break

        case 2:
            expandingOne.rotation = 0
            expandingOne.opacity = 1
            expandingOne.scale = 1
            expandingOneBackgroundCompanion.scale = 1

            generateRandomColors()
        }
    }

    function generateDefaultColors() {
        var totalCells = rows * columns
        var colorArray = []

        for (var index = 0; index < totalCells; index++) {
            colorArray.splice(index, 0, "#FFFFFF")
        }

        colorsGenerated(colorArray)
    }

    function generateRandomColors() {
        var totalCells = rows * columns
        var colorArray = []

        for (var index = 0; index < totalCells; index++) {
            switch (randomSelectionIndex) {
            case -1:
                var red = parseInt(Math.random() * 256)
                var green = parseInt(Math.random() * 256)
                var blue = parseInt(Math.random() * 256)

                if (red < 128 && green < 128 && blue < 128) {
                    var rgbSwitch = parseInt(Math.random() * 3)
                    switch (rgbSwitch) {
                    case 0: red = 255; break
                    case 1: green = 255; break
                    case 2: blue = 255; break
                    }
                }
                break

            case 0:
                red = parseInt(Math.random() * 192) + 63
                green = parseInt(Math.random() * 64)
                blue = green // parseInt(Math.random() * 64)
                break

            case 1:
                red = parseInt(Math.random() * 64)
                green = parseInt(Math.random() * 192) + 63
                blue = red // parseInt(Math.random() * 64)
                break

            case 2:
                red = parseInt(Math.random() * 64)
                green = red // parseInt(Math.random() * 64)
                blue = parseInt(Math.random() * 192) + 63
                break

            case 3:
                red = parseInt(Math.random() * 192) + 63
                green = parseInt(Math.random() * 64)
                blue = red // parseInt(Math.random() * 192) + 63
                break

            case 4:
                red = parseInt(Math.random() * 192) + 63
                green = red // parseInt(Math.random() * 192) + 63
                blue = parseInt(Math.random() * 64)
                break

            case 5:
                red = parseInt(Math.random() * 64)
                green = parseInt(Math.random() * 192) + 63
                blue = green // parseInt(Math.random() * 192) + 63
                break
            }

            var redHex = red < 16 ? "0" + red.toString(16) : red.toString(16)
            var greenHex = green < 16 ? "0" + green.toString(16) : green.toString(16)
            var blueHex = blue < 16 ? "0" + blue.toString(16) : blue.toString(16)

            var color = "#" + redHex + greenHex + blueHex
            colorArray.splice(index, 0, color)
        }

        colorsGenerated(colorArray)
    }

    function generateAgeShades() {
//        shades = ["white", "violet", "indigo", "blue", "green", "yellow", "orange", "red"]
        shades = ["#111111", "#222222", "#333333", "#444444", "#555555", "#666666", "#777777", "#888888", "#999999", "#aaaaaa", "#bbbbbb", "#cccccc", "#dddddd", "#eeeeee", "#ffffff", "#face00"]
    }

    function selectRandomColor(index) {
        redButton.switchState = index === 0
        greenButton.switchState = index === 1
        blueButton.switchState = index === 2
        purpleButton.switchState = index === 3
        yellowButton.switchState = index === 4
        cyanButton.switchState = index === 5

        randomSelectionIndex = index
        generateRandomColors()
    }

    function resetRandomIndex() {
        randomSelectionIndex = -1
        generateRandomColors()
    }

    Rectangle {
        id: expandingOneBackgroundCompanion
        anchors.fill: parent
        color: "black"
        opacity: 0.85
        scale: 0.5
        radius: expandingOne.width / 2

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }
    }

    Rectangle {
        id: expandingOne
        width: 480
        height: 480
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"
        opacity: 0
        scale: 0.5
        rotation: 60

        Behavior on rotation {
            RotationAnimation { duration: 120 }
        }

        Behavior on opacity {
            OpacityAnimator { duration:  120 }
        }

        Behavior on scale {
            ScaleAnimator { duration: 120 }
        }

        Rectangle {
            id: randomExpander
            anchors.fill: parent
            radius: expandingOne.width / 2
            anchors.rightMargin: 0
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.topMargin: 0
            color: "transparent"

//            Button {
//                id: setRandomColorsButton
//                x: 208
//                y: 25
//                width: 64
//                height: 64
//                text: qsTr("Set")

//                background: Rectangle {
//                    color: "transparent"
//                    radius: width / 2
//                    scale: setRandomColorsButton.pressed ? 0.9 : 1
//                    border.width: 5
//                    border.color: "white"

//                    Behavior on scale {
//                        ScaleAnimator { duration: 60 }
//                    }
//                }

//                contentItem: Text {
//                    horizontalAlignment: Text.AlignHCenter
//                    verticalAlignment: Text.AlignVCenter
//                    font.pixelSize: setRandomColorsButton.pressed ? 21 : 26
//                    color: "white"
//                    text: setRandomColorsButton.text

//                    Behavior on font.pixelSize {
//                        NumberAnimation { duration: 80 }
//                    }
//                }

//                onClicked: generateRandomColors()
//            }

            ColorButton {
                id: redButton
                x: 390
                y: 208
                tint: Color.redTint
                dimension: 64
                onSwitchedOn: selectRandomColor(0)
                onSwitchedOff: resetRandomIndex()
            }

            ColorButton {
                id: greenButton
                x: 365
                y: 305
                tint: Color.greenTint
                dimension: 64
                onSwitchedOn: selectRandomColor(1)
                onSwitchedOff: resetRandomIndex()
            }

            ColorButton {
                id: blueButton
                x: 273
                y: 378
                tint: Color.blueTint
                dimension: 64
                onSwitchedOn: selectRandomColor(2)
                onSwitchedOff: resetRandomIndex()
            }

            ColorButton {
                id: purpleButton
                x: 147
                y: 377
                tint: Color.purpleTint
                dimension: 64
                onSwitchedOn: selectRandomColor(3)
                onSwitchedOff: resetRandomIndex()
            }

            ColorButton {
                id: yellowButton
                x: 50
                y: 305
                tint: Color.yellowTint
                dimension: 64
                onSwitchedOn: selectRandomColor(4)
                onSwitchedOff: resetRandomIndex()
            }

            ColorButton {
                id: cyanButton
                x: 27
                y: 208
                tint: Color.cyanTinit
                dimension: 64
                onSwitchedOn: selectRandomColor(5)
                onSwitchedOff: resetRandomIndex()
            }
        }
    }

    Rectangle { // Move below EO
        id: innerWorld
        width: 240
        height: 240
        radius: 120
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        color: "transparent"
        clip: true
        border.color: "White"
        border.width: 3

        Behavior on border.color {
            ColorAnimation { duration: 120 }
        }

        Rectangle {
            id: innerCircle
            width: 220
            height: 220
            radius: 110
            color: "transparent"
            rotation: 45
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color {
                ColorAnimation { duration: 120 }
            }

            MouseArea {
                id: dismissMouse
                width: 220
                height: 220
                hoverEnabled: true

                onEntered: {
                    innerWorld.border.color = Color.redTint
                    innerCircle.color = Color.redTint

                    defaultRadial.color = Color.black
                    randomRadial.color = Color.black
                    dynamicRadial.color = Color.black
                }

                onExited: {
                    innerWorld.border.color = Color.white
                    innerCircle.color = Color.transparent

                    defaultRadial.color = Color.transparent
                    randomRadial.color = Color.transparent
                    dynamicRadial.color = Color.transparent
                }

                onClicked: dismissPalette()

                Timer {
                    id: transparetor
                    running: false
                    interval: 120
                    onTriggered: {
                        defaultRadial.color = Color.transparent
                        randomRadial.color = Color.transparent
                    }
                }
            }

            Rectangle {
                id: mask
                width: 220
                height: 220
                radius: 110
                opacity: 0
            }

            Item {
                anchors.fill: mask
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: mask
                }

                RadialButton {
                    id: defaultRadial
                    contentInsetX: 6
                    contentInsetY: 6
                    title: "Default"
                    selected: true
                    onPressed: radialSelection(-1)
                }

                RadialButton {
                    y: 115
                    title: "-"
                    color: "black" // remove
                }

                RadialButton {
                    id: dynamicRadial
                    x: 115
                    y: 115
                    contentInsetX: -8
                    contentInsetY: -8
                    title: "Dynamic"
                    onPressed: radialSelection(1)
                }

                RadialButton {
                    id: randomRadial
                    x: 115
                    contentInsetX: -10
                    contentInsetY: 10
                    title: "Random"
                    onPressed: radialSelection(2)
                }
            }
        }
    }
}
