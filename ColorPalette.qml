import QtQuick 2.7
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

    property alias presetTumblerIndex: tumbler.currentIndex

    property int paletteIndex: 0
    property int presetSelectionIndex: -1
    property var presetCombos: [false, false, false, false, false, false, false, false]

    property int presetSwitchIterator: 0
    property int dynamicIndex: 0
    property int dynamicIndexMax: 1

    property var buttons: [redButton1, redButton, greenButton, blueButton, purpleButton, yellowButton, cyanButton, cyanButton1]
    property var currentSliderTarget: dynamicButton1

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
        if (paletteIndex == -1 || paletteIndex == 1) {
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

        dismissSliders()

        if (paletteIndex == -1 || paletteIndex == 1) {
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

    Timer {
        id: switchOuterPaletteTimer
        interval: 120
        running: false
        onTriggered: switchOuterPalette()
    }

    function radialSelection(index) {
        presetRadial.selected = index === -1 // 0
        defaultRadial.selected = index === 0
        dynamicRadial.selected = index === 1
        advancedRadial.selected = index === 2 // 3

        paletteIndex = index

        dismissSliders()

        switch (index) {
        case -1:
            if (expandingOne.scale != 1) {
                switchOuterPalette()
            }
            else {
                collapseExpadingOne()
                switchOuterPaletteTimer.start()
            }

            for (var x in buttons) {
                buttons[x].switchState = false
                presetCombos[x] = false
            }
            resetRandomIndex()
            break

        case 0:
            collapseExpadingOne()
            generateDefaultColors()
            break

        case 1:
            if (expandingOne.scale != 1) {
                switchOuterPalette()
            }
            else {
                collapseExpadingOne()
                switchOuterPaletteTimer.start()
            }

            for (x = 0; x < ages.length; x++) {
                ages[x] = 0
            }

            generateAgeShades()
            break

        case 2:
            collapseExpadingOne()
            generateSequentialGradient()
            break
        }
    }

    function expandExpandingOne() {
        expandingOne.rotation = 0
        expandingOne.opacity = 1
        expandingOne.scale = 1
        expandingOneBackgroundCompanion.scale = 1
    }

    function collapseExpadingOne() {
        expandingOne.rotation = 60
        expandingOne.opacity = 0
        expandingOne.scale = 0.5
        expandingOneBackgroundCompanion.scale = 0.5
    }

    function switchOuterPalette() {
        randomExpander.visible = paletteIndex == -1
        dynamicExpander.visible = paletteIndex == 1
        expandExpandingOne()
    }

    function generateDefaultColors() {
        var totalCells = rows * columns
        var colorArray = []

        for (var index = 0; index < totalCells; index++) {
            colorArray.splice(index, 0, "#FFFFFF")
        }

        colorsGenerated(colorArray)
    }

    function generateRandomColors(presetIndex) {
        var totalCells = rows * columns
        var colorArray = []

        for (var index = 0; index < totalCells; index++) {
            switch (presetIndex) {
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
                red = parseInt(Math.random() * 127) + 127
                green = parseInt(Math.random() * 64) + 63
                blue = green // parseInt(Math.random() * 64)
                break

            case 1:
                red = parseInt(Math.random() * 64) + 63
                green = parseInt(Math.random() * 127) + 127
                blue = red // parseInt(Math.random() * 64)
                break

            case 2:
                red = parseInt(Math.random() * 64) + 63
                green = red // parseInt(Math.random() * 64)
                blue = parseInt(Math.random() * 127) + 127
                break

            case 3: // Good random mix
                red = parseInt(Math.random() * 127) + 127
                green = parseInt(Math.random() * 64)
                blue = parseInt(Math.random() * 127) + 127 // parseInt(Math.random() * 192) + 63
                break

            case 4:
                red = parseInt(Math.random() * 127) + 127
                green = parseInt(Math.random() * 127) + 127
                blue = parseInt(Math.random() * 64) + 63
                break

            case 5:
                red = parseInt(Math.random() * 64) + 63
                green = parseInt(Math.random() * 127) + 127
                blue = parseInt(Math.random() * 127) + 127
                break

            case 6:
                red = parseInt(Math.random() * 127) + 127
                green = parseInt(Math.random() * 64) + 127
                blue = parseInt(Math.random() * 64) + 64
                break

            case 7:
                red = parseInt(Math.random() * 127) + 127
                green = parseInt(Math.random() * 64) + 63
                blue = red // parseInt(Math.random() * 192) + 63
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

    function getRed(color) {
        var red = color.charAt(1) + color.charAt(2)
        return parseInt(red, 16)
    }

    function getGreen(color) {
        var green = color.charAt(3) + color.charAt(4)
        return parseInt(green, 16)
    }

    function getBlue(color) {
        var blue = color.charAt(5) + color.charAt(6)
        return parseInt(blue, 16)
    }

    function generateRandom(combos) {
        switch (combos.length) {
        case 0:
            generateRandomColors(-1)
            return

        case 1:
            generateRandomColors(combos[0])
            return
        }

        var colorArray = []

        var totalSteps = columns * rows - 1

        for (var index = 0; index < combos.length - 1; index++) {
            var gradient0 = getColorButton(combos[index]).tint
            var gradient1 = getColorButton(combos[index + 1]).tint
            var steps = parseInt(totalSteps / parseInt(combos.length - 1))

            var transitoryArray = generateGradient(gradient0, gradient1, steps)

            transitoryArray.forEach(function(color) {
                colorArray.push(color)
            })
        }

        // Need to come up with better logic. This is barely working as intended

        console.log(colorArray.length, totalSteps)

        var shuffledArray = shuffle(colorArray)
        colorsGenerated(colorArray)
    }

    function generateAgeShades() {
        var colorArray = []

        var colors = [dynamicButton1.tint, dynamicButton2.tint]
        var steps = [parseInt(dynamicSetButton1.onText)]

        if (dynamicButton3.modeIndex == 0) {
            colors.push(dynamicButton3.tint)
            steps.push(parseInt(dynamicSetButton2.onText))
        }

        if (dynamicButton4.modeIndex == 0) {
            colors.push(dynamicButton4.tint)
            steps.push(parseInt(dynamicSetButton3.onText))
        }

        for (var index = 0; index < colors.length - 1; index++) {
            var gradient0 = colors[index]
            var gradient1 = colors[index + 1]
            var stepCount = steps[index]

            var transitoryArray = generateGradient(gradient0, gradient1, stepCount)

            transitoryArray.forEach(function(color) {
                colorArray.push(color)
            })
        }

        colorsGenerated(colorArray)
    }

    function generateAltGradient() {
        var colorArray = generateGradient("#114357", "#F29492", rows * columns - 1)
        colorsGenerated(colorArray)
    }

    function generateGradientColors(gradient0, gradient1) {
        var colorArray = generateGradient(gradient0, gradient1, columns - 1)
        colorsGenerated(colorArray)
    }

    function generateGradient(gradient0, gradient1, steps) {
        var colorArray = []

        console.log(gradient0, gradient1, steps)

        var red1 = getRed(gradient0)
        var red2 = getRed(gradient1)
        var green1 = getGreen(gradient0)
        var green2 = getGreen(gradient1)
        var blue1 = getBlue(gradient0)
        var blue2 = getBlue(gradient1)

        var redStep = ((red2 - red1) / steps)
        var greenStep = ((green2 - green1) / steps)
        var blueStep = ((blue2 - blue1) / steps)

        for (var index = 0; index <= steps; index++) {
            var red = parseInt(red1 + redStep * index).toString(16)
            var green = parseInt(green1 + greenStep * index).toString(16)
            var blue = parseInt(blue1 + blueStep * index).toString(16)

            red = red.length < 2 ? "0" + red : red
            green = green.length < 2 ? "0" + green : green
            blue = blue.length < 2 ? "0" + blue : blue

            var color = "#" + red + green + blue

            colorArray.push(color)
        }

        return colorArray
    }

    function generateSequentialGradient() {
        var colorArray = []

        var color1 = 0x000000
        var color2 = 0xFFFFFF

        var steps = rows * columns - 1

        var colorStep = (color2 - color1) / steps

        for (var index = 0; index <= steps; index++) {
            var color = parseInt(color1 + colorStep * index).toString(16)

            var charCount = 6 - color.length
            var prefix = "#"
            for (var x = 0; x < charCount; x++) {
                prefix += "0"
            }

            colorArray.push(prefix + color)
        }

        colorsGenerated(colorArray)
    }

    function getColorButton(index) {
        switch (index) {
        case 0: return redButton
        case 1: return  greenButton
        case 2: return  blueButton
        case 3: return  purpleButton
        case 4: return  yellowButton
        case 5: return  cyanButton
        case 6: return  redButton1
        case 7: return  cyanButton1
        }
    }

    function selectPresetSets() {
        for (var index in buttons) {
            buttons[index].switchState = false
            presetCombos[index] = false
        }

        resetRandomIndex()
        switchPresets(tumbler.currentIndex)
    }

    function selectPreset(index, sender) {
        switch (tumbler.currentIndex) {
        case 0:
            var combos = []
            presetCombos[index] = !presetCombos[index]

            for (var x = 0; x < presetCombos.length; x++) {
                getColorButton(x).switchState = presetCombos[x]

                if (presetCombos[x]) {
                    combos.push(x)
                }
            }

            console.log(combos)
            console.log(presetCombos)

            generateRandom(combos)
            break

        case 1:
            redButton.switchState = index === 0
            greenButton.switchState = index === 1
            blueButton.switchState = index === 2
            purpleButton.switchState = index === 3
            yellowButton.switchState = index === 4
            cyanButton.switchState = index === 5
            redButton1.switchState = index === 6
            cyanButton1.switchState = index === 7

            presetSelectionIndex = index
            generateGradientColors(sender.gradient0, sender.gradient1)
            break
        }
    }

    function resetRandomIndex() {
        if (paletteIndex != -1) {
            return
        }

        presetSelectionIndex = -1

        switch (tumbler.currentIndex) {
        case 0:
            generateRandom([])
            break

        case 1:
            redButton.switchState = false
            greenButton.switchState = false
            blueButton.switchState = false
            purpleButton.switchState = false
            yellowButton.switchState = false
            cyanButton.switchState = false
            redButton1.switchState = false
            cyanButton1.switchState = false
            generateGradientColors("#000000", "#FFFFFF")
            break
        }
    }

    function shuffle(array) {
        var m = array.length, t, i;

        while (m) {
            i = Math.floor(Math.random() * m--);

            t = array[m];
            array[m] = array[i];
            array[i] = t;
        }

        return array;
    }

    function checkComboCondition() {
        if (tumbler.currentIndex === 0) {
            return true
        }

        return false
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
            visible: false

            ColorButton {
                id: redButton
                x: 390
                y: 208
                tint: Color.redTint
                gradient0: "#C04848"
                gradient1: "#480048"
                dimension: 64
                enableGradient: true
                onSwitchedOn: selectPreset(0, redButton)
                onSwitchedOff: checkComboCondition() ? selectPreset(0, redButton) : resetRandomIndex()
            }

            ColorButton {
                id: greenButton
                x: 359
                y: 310
                tint: Color.greenTint
                gradient0: "#f79d00"
                gradient1: "#64f38c"
                dimension: 64
                enableGradient: true
                onSwitchedOn: selectPreset(1, greenButton)
                onSwitchedOff: checkComboCondition() ? selectPreset(1, greenButton) : resetRandomIndex()
            }

            ColorButton {
                id: blueButton
                x: 273
                y: 378
                tint: Color.blueTint
                gradient0: "#C33764"
                gradient1: "#1D2671"
                dimension: 64
                enableGradient: true
                onSwitchedOn: selectPreset(2, blueButton)
                onSwitchedOff: checkComboCondition() ? selectPreset(2, blueButton) : resetRandomIndex()
            }

            ColorButton {
                id: purpleButton
                x: 147
                y: 377
                tint: Color.purpleTint
                gradient0: "#5f2c82"
                gradient1: "#49a09d"
                dimension: 64
                enableGradient: true
                onSwitchedOn: selectPreset(3, purpleButton)
                onSwitchedOff: checkComboCondition() ? selectPreset(3, purpleButton) : resetRandomIndex()
            }

            ColorButton {
                id: yellowButton
                x: 56
                y: 310
                tint: Color.yellowTint
                gradient0: "#C02425"
                gradient1: "#F0CB35"
                dimension: 64
                enableGradient: true
                onSwitchedOn: selectPreset(4, yellowButton)
                onSwitchedOff: checkComboCondition() ? selectPreset(4, yellowButton) : resetRandomIndex()
            }

            ColorButton {
                id: cyanButton
                x: 27
                y: 208
                tint: Color.cyanTinit
                gradient0: "#3494E6"
                gradient1: "#EC6EAD"
                dimension: 64
                enableGradient: true
                onSwitchedOn: selectPreset(5, cyanButton)
                onSwitchedOff: checkComboCondition() ? selectPreset(5, cyanButton) : resetRandomIndex()
            }

            ColorButton {
                id: redButton1
                x: 359
                y: 104
                enableGradient: true
                tint: "#FF8822"
                gradient0: "#ff4b1f"
                gradient1: "#1fddff"
                dimension: 64
                onSwitchedOn: selectPreset(6, redButton1)
                onSwitchedOff: checkComboCondition() ? selectPreset(6, redButton1) : resetRandomIndex()
            }

            ColorButton {
                id: cyanButton1
                x: 56
                y: 104
                enableGradient: true
                tint: "#CC88FF"
                gradient0: "#3a6186"
                gradient1: "#89253e"
                dimension: 64
                onSwitchedOn: selectPreset(7, cyanButton1)
                onSwitchedOff: checkComboCondition() ? selectPreset(7, cyanButton1) : resetRandomIndex()
            }

            Tumbler {
                id: tumbler
                x: 143
                y: 0
                width: 195
                height: 119
                visibleItemCount: 5
                model: ["Random", "Gradient"]

                delegate: Text {
                    height: 35
                    color: "#ffffff"
                    text: modelData
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: 35
                    scale: 1.0 - Math.abs(Tumbler.displacement) / 5.2
                    opacity: 1.0 - Math.abs(Tumbler.displacement) / 1.45
                }

                onCurrentIndexChanged: switchPresets(currentIndex)
            }
        }

        Rectangle {
            id: dynamicExpander
            anchors.fill: parent // 480x480
            color: "transparent"

            ColorButton {
                id: dynamicButton1
                x: 208
                y: 30
                tint: "#FFFFFF"
                enableGradient: false
//                addMode: false
                modeIndex: 0
                connected: true
                switchState: true
                onSwitchedOn: colorButtonPressed(dynamicButton1)
            }

            ToggleButton {
                id: dynamicSetButton1
                x: 345
                y: 97
                dimension: 56
                square: true
                diamond: true
                onText: "32"
                offText: "Set"
                connected: true
                switchState: true
                onSwitchedOn: functionButtonPressed(dynamicSetButton1)
            }

            ColorButton {
                id: dynamicButton2
                x: 390
                y: 208
                tint: "#000000"
                enableGradient: false
//                addMode: false
                modeIndex: 0
                connected: true
                switchState: true
                onSwitchedOn: colorButtonPressed(dynamicButton2)
            }

            ToggleButton {
                id: dynamicSetButton2
                x: 345
                y: 326
                dimension: 56
                square: true
                diamond: true
                onText: "Set"
                offText: "Set"
                connected: true
                switchState: true
                onSwitchedOn: functionButtonPressed(dynamicSetButton2)
            }

            ColorButton {
                id: dynamicButton3
                x: 208
                y: 383
                tint: "#FFFFFF"
                enableGradient: false
//                addMode: true
                modeIndex: 1
                connected: true
                onSwitchedOn: colorButtonPressed(dynamicButton3)
            }

            ToggleButton {
                id: dynamicSetButton3
                x: 75
                y: 326
                dimension: 56
                square: true
                diamond: true
                onText: "Set"
                offText: "Set"
                connected: true
                scale: 0
                onSwitchedOn: functionButtonPressed(dynamicSetButton3)
            }

            ColorButton {
                id: dynamicButton4
                x: 27
                y: 208
                tint: "#FFFFFF"
                enableGradient: false
//                addMode: true
                modeIndex: 1
                scale: 0
                connected: true
                onSwitchedOn: colorButtonPressed(dynamicButton4)
            }

            ToggleButton {
                id: dynamicSetButton4
                x: 75
                y: 97
                dimension: 56
                square: true
                diamond: true
                onText: "Set"
                offText: "Set"
                connected: true
                scale: 0
                onSwitchedOn: functionButtonPressed(dynamicSetButton4)
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

                    presetRadial.color = Color.black
                    advancedRadial.color = Color.black
                    dynamicRadial.color = Color.black
                    defaultRadial.color = Color.black
                }

                onExited: {
                    innerWorld.border.color = Color.white
                    innerCircle.color = Color.transparent

                    presetRadial.color = Color.transparent
                    advancedRadial.color = Color.transparent
                    dynamicRadial.color = Color.transparent
                    defaultRadial.color = Color.transparent
                }

                onClicked: dismissPalette()
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
                    id: presetRadial
                    contentInsetX: 6
                    contentInsetY: 6
                    title: "Presets"
                    onPressed: radialSelection(-1)
                }

                RadialButton {
                    id: defaultRadial
                    y: 115
                    contentInsetX: 10
                    contentInsetY: -10
                    title: "Default"
                    selected: true
                    onPressed: radialSelection(0)
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
                    id: advancedRadial
                    x: 115
                    contentInsetX: -10
                    contentInsetY: 10
                    title: "More +"
                    onPressed: radialSelection(2)
                }
            }
        }

        Rectangle {
            id: sliderFrame
            x: 0
            y: 0
            width: 240
            height: 240
            radius: 120
            color: "#ffffff"
            scale: 0

            Behavior on scale {
                ScaleAnimator { duration: 120 }
            }

            Behavior on color {
                ColorAnimation { duration: 120 }
            }

            MouseArea {
                anchors.fill: sliderFrame
            }

            Rectangle {
                id: sliderBackground
                x: 10
                y: 10
                width: 220
                height: 220
                radius: 110
                color: "#ffffff"
            }

            CustomSlider {
                id: redSlider
                x: 20
                y: 57
                value: 255
                from: 0
                to: 255
                minTrackColor: Color.redTint
                onValueChanged: colorSliderAction()
            }

            CustomSlider {
                id: greenSlider
                x: 20
                y: 101
                value: 255
                from: 0
                to: 255
                minTrackColor: Color.greenTint
                onValueChanged: colorSliderAction()
            }

            CustomSlider {
                id: blueSlider
                x: 20
                y: 149
                value: 255
                from: 0
                to: 255
                minTrackColor: Color.blueTint
                onValueChanged: colorSliderAction()
            }

            CustomButton {
                id: setButton
                x: 81
                y: 20
                width: 80
                height: 24
                text: "Set"
                buttonFont: 18
                onClicked: setSliderValuesToTarget()
            }

            CustomButton {
                id: cancelButton
                x: 81
                y: 196
                width: 80
                height: 24
                text: "Cancel"
                buttonFont: 18
                onClicked: dismissSliders()
            }
        }
    }

    // Dynamic Functions

    function setSlidersToColor(color) {
        var redHex = getRed(color)
        var greenHex = getGreen(color)
        var blueHex = getBlue(color)

        var red = parseFloat(redHex, 16)
        var green = parseFloat(greenHex, 16)
        var blue = parseFloat(blueHex, 16)

        redSlider.value = red
        greenSlider.value = green
        blueSlider.value = blue
    }

    function colorSliderAction() {
        var red = parseInt(redSlider.value)
        var green = parseInt(greenSlider.value)
        var blue = parseInt(blueSlider.value)

        var redHex = red < 16 ? "0" + red.toString(16) : red.toString(16)
        var greenHex = green < 16 ? "0" + green.toString(16) : green.toString(16)
        var blueHex = blue < 16 ? "0" + blue.toString(16) : blue.toString(16)

        var color = "#" + redHex + greenHex + blueHex
        sliderFrame.color = color
    }

    function presentSliders() {
        sliderFrame.scale = 1
    }

    function dismissSliders() {
        if (currentSliderTarget.modeIndex === -1) {
            currentSliderTarget.modeIndex = 0
        }

        sliderFrame.scale = 0
    }

    function resetDynamicButtons(button) {
        console.log("reset")
        switch (button) {
        case dynamicButton3:
            console.log("button3")
            dynamicSetButton4.scale = 0

            dynamicButton4.tint = "#FFFFFF"
            dynamicButton4.modeIndex = 1
            dynamicButton4.scale = 0

            dynamicSetButton3.scale = 0

            dynamicButton3.tint = "#FFFFFF"
            dynamicButton3.modeIndex = 1

            dynamicSetButton2.onText = "Set"
            dynamicSetButton2.switchState = false
            break

        case dynamicButton4:
            console.log("button4")
            dynamicSetButton4.scale = 0

            dynamicButton4.tint = "#FFFFFF"
            dynamicButton4.modeIndex = 1

            dynamicSetButton3.onText = "Set"
            dynamicSetButton3.switchState = false
            break
        }

        dismissSliders()
    }

    function colorButtonPressed(button) {
        if (currentSliderTarget.modeIndex === -1 && currentSliderTarget !== button) {
            currentSliderTarget.modeIndex = 0
        }

        currentSliderTarget = button
        setSlidersToColor(button.tint)
        presentSliders()

        switch (button) {
        case dynamicButton1: dynamicIndex = 0; break
        case dynamicButton2: dynamicIndex = 1; break
        case dynamicButton3:
            dynamicIndex = 2

            switch (button.modeIndex) {
            case -1: resetDynamicButtons(button); break
            case 0: button.modeIndex = -1; break
            }
            break

        case dynamicButton4:
            dynamicIndex = 3

            switch (button.modeIndex) {
            case -1: resetDynamicButtons(button); break
            case 0: button.modeIndex = -1; break
            }
            break
        }
    }

    function functionButtonPressed(button) {
        if (button.onText === "Set") {
            generateAgeShades()
        }
        else {
            var step = parseInt(button.onText)
            step *= 2

            if (step > 9999) {
                step = 1
            }

            button.onText = step
            resetSetFunction()
        }

        dismissSliders()
    }

    function setSliderValuesToTarget() {
        if (currentSliderTarget.modeIndex === -1) {
            currentSliderTarget.modeIndex = 0
        }

        currentSliderTarget.tint = sliderFrame.color
        dismissSliders()

        if (dynamicIndexMax < dynamicIndex) {
            dynamicIndexMax = dynamicIndex
        }

        switch (dynamicIndex) {
        case 0:
        case 1:
            break

        case 2:
            if (dynamicButton3.modeIndex == 1) {
                dynamicButton3.modeIndex = 0
                dynamicButton3.switchState = true

                dynamicSetButton2.onText = "32"
                dynamicSetButton2.switchState = true

                dynamicSetButton3.switchState = false
                dynamicSetButton3.scale = 1

                dynamicButton4.scale = 1
            }
            break

        case 3:
            if (dynamicButton4.modeIndex == 1) {
                dynamicButton4.modeIndex = 0
                dynamicButton4.switchState = true

                dynamicSetButton3.onText = "32"
                dynamicSetButton3.switchState = true

                dynamicSetButton4.switchState = false
                dynamicSetButton4.scale = 1
            }
            break
        }

        resetSetFunction()
    }

    function resetSetFunction() {
        switch (dynamicIndexMax) {
        case 1: dynamicSetButton2.switchState = false; break
        case 2: dynamicSetButton3.switchState = false; break
        case 3: dynamicSetButton4.switchState = false; break
        }
    }

    function switchPresets(index) {
        switch (index) {
        case 0:
            buttons[presetSwitchIterator].enableGradient = false
            buttons[presetSwitchIterator].switchMode()
            break

        case 1:
            buttons[presetSwitchIterator].enableGradient = true
            buttons[presetSwitchIterator].switchMode()
            break
        }

        if (presetSwitchIterator < buttons.length - 1) {
            presetSwitchIterator++
            switchPresetTimer.start()
        }
        else {
            presetSwitchIterator = 0

            // Finish Anim

        }
    }

    Timer {
        id: switchPresetTimer
        running: false
        interval: 64
        onTriggered: selectPresetSets()
    }


}
