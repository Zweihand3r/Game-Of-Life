import QtQuick 2.6
import QtQuick.Controls 2.0

Rectangle {
    id: root
    width: 1720
    height: 980
    color: "transparent"
    opacity: 1 // 0
    scale: 0.98
    visible: false

    property int currentRowIndex: 12
    property int currentColumnIndex: 14

    property int currentSpacing: 2

    property string selectedShape: "sqr"

    signal rowSelected(int row)
    signal columnSelected(int column)
    signal generation()
    signal reset()
    signal animationEnabled(bool status)
    signal intervalGenerated(int interval)
    signal spacingSelected(int spacing)
    signal highlightGridSwitched(bool highlight)

    function present() {
        visible = true

        opacity = 1
        scale = 1
    }

    function dismiss() {
        opacity = 0
        scale = 0.98

        visibilityDisableTimer.start()
    }

    function generatePreview() {
        populationControl.generatePreview()
    }

    function setFromPreview() {
        populationControl.setFromPreview()
    }

    function resetCompletion() {
        loadingIndicator.hideLoading()
        blinkText.start()

        generationButton.enabled = true
        generation.state = ''

        populationControl.opacity = 0.45
        populationControl.enabled = false
    }

    function generationCompletion() {
        loadingIndicator.hideLoading()
        blinkText.start()

        generationButton.enabled = true
    }

    function toggleColumnTumbler(toggle) {
        if (toggle) {
            columnTumbler.currentIndex = rowTumbler.currentIndex
            root.columnSelected(rowTumbler.currentIndex)

            columnTumbler.enabled = false
            columnTumbler.opacity = 0.65
            columnText.opacity = 0.65
        }
        else {
            root.columnSelected(columnTumbler.currentIndex)

            columnTumbler.enabled = true
            columnTumbler.opacity = 1
            columnText.opacity = 1
        }
    }

    function generationButtonAction() {
        loadingIndicator.showLoading()

        generationButton.contentItem.opacity = 0
        generationButton.enabled = false

        if (generation.state === '') {
            generation.state = 'reset'

            populationControl.opacity = 1
            populationControl.enabled = true

            root.generation()
        }
        else {

            root.reset()
        }
    }

    function setSpacingButton(spacing) {
        var rowPreviousIndex = rowTumbler.currentIndex
        var columnPreviousIndex = columnTumbler.currentIndex

        spacing0.switchState = false
        spacing1.switchState = false
        spacing2.switchState = false
        spacing4.switchState = false
        spacing8.switchState = false
        spacing16.switchState = false
        spacing32.switchState = false

        switch (spacing) {
        case 0:
            spacing0.switchState = true
            rowTumbler.model = 62
            columnTumbler.model = 121
            break

        case 1:
            spacing1.switchState = true
            rowTumbler.model = 58
            columnTumbler.model = 114
            break

        case 2:
            spacing2.switchState = true
            rowTumbler.model = 54
            columnTumbler.model = 105
            break

        case 4:
            spacing4.switchState = true
            rowTumbler.model = 49
            columnTumbler.model = 97
            break

        case 8:
            spacing8.switchState = true
            rowTumbler.model = 41
            columnTumbler.model = 82
            break

        case 16:
            spacing16.switchState = true
            rowTumbler.model = 31
            columnTumbler.model = 63
            break

        case 32:
            spacing32.switchState = true
            rowTumbler.model = 21
            columnTumbler.model = 43
            break

        }

        root.spacingSelected(spacing)
        currentSpacing = spacing

        if (rowPreviousIndex > rowTumbler.count) {
            rowTumbler.currentIndex = rowTumbler.count - 1
        }
        else {
            rowTumbler.currentIndex = rowPreviousIndex
        }

        if (columnPreviousIndex > columnTumbler.count) {
            columnTumbler.currentIndex = columnTumbler.count - 1
        }
        else {
            columnTumbler.currentIndex = columnPreviousIndex
        }
    }

    function setMaxDimesions() {
        switch (currentSpacing) {
        case 0:
            rowTumbler.currentIndex = 61
            columnTumbler.currentIndex = 120
            break

        case 1:
            rowTumbler.currentIndex = 57
            columnTumbler.currentIndex = 113
            break

        case 2:
            rowTumbler.currentIndex = 53
            columnTumbler.currentIndex = 104
            break

        case 4:
            rowTumbler.currentIndex = 48
            columnTumbler.currentIndex = 96
            break

        case 8:
            rowTumbler.currentIndex = 40
            columnTumbler.currentIndex = 81
            break

        case 16:
            rowTumbler.currentIndex = 30
            columnTumbler.currentIndex = 62
            break

        case 32:
            rowTumbler.currentIndex = 20
            columnTumbler.currentIndex = 42
            break
        }
    }

    function setShape(shape) {
        squareShape.switchState = false
        diamondShape.switchState = false
        circleShape.switchState = false

        switch (shape) {
        case "sqr":
            squareShape.switchState = true
            break

        case "dia":
            diamondShape.switchState = true
            break

        case "cir":
            circleShape.switchState = true
            break
        }

        selectedShape = shape
    }

    Behavior on opacity {
        OpacityAnimator { duration: 160; easing.type: Easing.InQuad }
    }

    Behavior on scale {
        ScaleAnimator { duration: 160; easing.type: Easing.InQuad }
    }

    Timer {
        id: visibilityDisableTimer
        running: false
        repeat: false
        interval: 160
        onTriggered: visible = false
    }

    Rectangle {
        x: 0
        y: 0
        width: 1720
        height: 980
        color: "black"
        opacity: 0.86
    }

    PopulationControl {
        id: populationControl
        x: 747
        y: 357
    }

    Rectangle {
        id: generation
        x: 191
        y: 357
        width: 476
        height: 448
        color: "transparent"
        border.width: 4
        border.color: generationButton.pressed ? "transparent" : "white"
        radius: 24
        scale: generationButton.pressed ? 0.98 : 1

        Tumbler {
            id: rowTumbler
            x: 29
            y: 56
            width: 100
            height: 184
            visibleItemCount: 4
            model: 54
            currentIndex: currentRowIndex

            delegate: Text {
                text: modelData
                height: 32
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "white"
                font.pixelSize: 45
                scale: 1.0 - Math.abs(Tumbler.displacement) / 6
                opacity: 1.0 - Math.abs(Tumbler.displacement) / 2.35
            }

            onCurrentIndexChanged: {
                if (toggleEqualButton.switchState) {
                    columnTumbler.currentIndex = currentIndex
                    root.columnSelected(currentIndex)
                }

                root.rowSelected(currentIndex)
            }
        }

        Tumbler {
            id: columnTumbler
            x: 129
            y: 56
            width: 100
            height: 184
            visibleItemCount: 4
            model: 105
            currentIndex: currentColumnIndex

            delegate: Text {
                height: 32
                color: "#ffffff"
                text: modelData
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 45
                scale: 1.0 - Math.abs(Tumbler.displacement) / 6
                opacity: 1.0 - Math.abs(Tumbler.displacement) / 2.35
            }

            onCurrentIndexChanged: toggleEqualButton.switchState ? null : root.columnSelected(currentIndex)

            Behavior on opacity {
                OpacityAnimator { duration: 120 }
            }
        }

        Button {
            id: maxButton
            x: 67
            y: 246
            width: 48
            height: 48
            text: qsTr("Max")

            background: Rectangle {
                color: "transparent"
                radius: width / 2
                scale: maxButton.pressed ? 0.9 : 1
                border.width: 2
                border.color: "white"

                Behavior on scale {
                    ScaleAnimator { duration: 60 }
                }
            }

            contentItem: Text {
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: maxButton.pressed ? 14 : 19
                color: "white"
                text: maxButton.text

                Behavior on font.pixelSize {
                    NumberAnimation { duration: 80 }
                }
            }

            onClicked: setMaxDimesions()
        }

        ToggleButton {
            id: toggleEqualButton
            x: 138
            y: 246
            dimension: 48
            fontSize: 17
            offText: "R=C"
            onText: "R=C"

            onSwitchedOn: toggleColumnTumbler(true)
            onSwitchedOff: toggleColumnTumbler(false)
        }

        Text {
            x: 29
            y: 17
            width: 100
            height: 39
            color: "#ffffff"
            text: qsTr("Rows")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 25
        }

        Text {
            id: columnText
            x: 129
            y: 17
            width: 100
            height: 39
            color: "#ffffff"
            text: qsTr("Columns")
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 25

            Behavior on opacity {
                OpacityAnimator { duration: 120 }
            }
        }

        Text {
            id: shapeText
            x: 302
            y: 17
            width: 100
            height: 39
            color: "#ffffff"
            text: qsTr("Shape")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 25
        }

        ToggleButton {
            id: squareShape
            x: 250
            y: 62
            dimension: 64
            square: true
            switchState: true
            connected: true

            onSwitchedOn: setShape("sqr")
        }

        ToggleButton {
            id: diamondShape
            x: 399
            y: 73
            rotation: 45
            dimension: 44
            connected: true
            square: true

            onSwitchedOn: setShape("dia")
        }

        ToggleButton {
            id: circleShape
            x: 320
            y: 62
            dimension: 64
            connected: true

            onSwitchedOn: setShape("cir")
        }

        ToggleButton {
            id: spacing0
            x: 246
            y: 200
            onText: "0"
            offText: "0"
            dimension: 48
            connected: true
            onSwitchedOn: setSpacingButton(0)
        }

        ToggleButton {
            id: spacing1
            x: 300
            y: 200
            onText: "1"
            offText: "1"
            dimension: 48
            connected: true
            onSwitchedOn: setSpacingButton(1)
        }

        ToggleButton {
            id: spacing2
            x: 354
            y: 200
            onText: "2"
            offText: "2"
            dimension: 48
            connected: true
            switchState: true
            onSwitchedOn: setSpacingButton(2)
        }

        ToggleButton {
            id: spacing4
            x: 408
            y: 200
            onText: "4"
            offText: "4"
            dimension: 48
            connected: true
            onSwitchedOn: setSpacingButton(4)
        }

        ToggleButton {
            id: spacing8
            x: 274
            y: 246
            onText: "8"
            offText: "8"
            dimension: 48
            connected: true
            onSwitchedOn: setSpacingButton(8)
        }

        ToggleButton {
            id: spacing16
            x: 328
            y: 246
            onText: "16"
            offText: "16"
            dimension: 48
            connected: true
            onSwitchedOn: setSpacingButton(16)
        }

        ToggleButton {
            id: spacing32
            x: 382
            y: 246
            onText: "32"
            offText: "32"
            dimension: 48
            connected: true
            onSwitchedOn: setSpacingButton(32)
        }

        Text {
            id: shapeText1
            x: 302
            y: 155
            width: 100
            height: 39
            color: "#ffffff"
            text: qsTr("Spacing")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 25
            verticalAlignment: Text.AlignVCenter
        }

        Button {
            id: generationButton
            x: 12
            y: 326
            width: 452
            height: 112
            text: "Generate"

            background: Rectangle {
                id: rectangle
                color: generationButton.pressed ? "black" : "white"
                radius: 18

                LoadingIndicator {
                    id: loadingIndicator
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    customRadius: 16
                    customColor: "black"
                    animationInterval: 160
                }

                Behavior on color {
                    ColorAnimation { duration: 120 }
                }
            }

            contentItem: Text {
                text: generationButton.text
                wrapMode: Text.WordWrap
                font.pixelSize: text === "Generate" ? 42 : 86
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color: generationButton.pressed ? "white" : "black"

                Behavior on font.pixelSize {
                    NumberAnimation { duration: 320 }
                }
            }

            onClicked: generationButtonAction()

            OpacityAnimator {
                id: blinkText
                running: false
                target: generationButton.contentItem
                from: 0
                to: 1
                duration: 320
            }
        }

        Behavior on scale {
            ScaleAnimator { duration: 80 }
        }

        Behavior on border.color {
            ColorAnimation { duration: 120 }
        }

        states: [
            State {
                name: "reset"
                PropertyChanges {
                    target: generationButton
                    y: 12
                    height: 426
                    text: "Reset"
                }
            }
        ]

        transitions: [
            Transition {
                NumberAnimation {
                    properties: "y, height"
                    duration: 320
                    easing.type: Easing.InQuad
                }
            }
        ]
    }

    CustomSwitch {
        id: animateSwitch
        x: 1345
        y: 311
        checked: true
        font.pixelSize: 25
        text: qsTr("Animate")

        onCheckedChanged: root.animationEnabled(checked)
    }

    Text {
        id: speedText
        x: 1414
        y: 620
        width: 100
        height: 39
        color: "#ffffff"
        text: qsTr("Interval")
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 25
    }

    CustomSwitch {
        id: highlightSwitch
        x: 1345
        y: 363
        text: qsTr("Grid Highlight")
        font.pixelSize: 25
        checked: false
        onCheckedChanged: root.highlightGridSwitched(checked)
    }

    CustomDial {
        id: speedDial
        x: 1382
        y: 450
        dimension: 164
        from: 100
        to: 1000
        value: 160

        onValueChanged: root.intervalGenerated(parseInt(value))
    }

    RuleSets {
        id: ruleSets
        x: 191
        y: 125
        width: 1032
        height: 172
    }

    Component.onCompleted: {
        generation.state = 'reset'
    }

}
